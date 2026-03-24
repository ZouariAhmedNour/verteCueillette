package com.vertecueillette.backend.application.service;

import com.vertecueillette.backend.domain.dto.*;
import com.vertecueillette.backend.domain.entity.*;
import com.vertecueillette.backend.domain.exception.NotFoundException;
import com.vertecueillette.backend.domain.repository.*;
import com.vertecueillette.backend.domain.service.PanierService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class PanierServiceImpl implements PanierService {

    private final PanierRepository panierRepository;
    private final LignePanierRepository lignePanierRepository;
    private final UserRepository userRepository;
    private final ProduitRepository produitRepository;
    private final ReservationRepository reservationRepository;
    private final LigneResaRepository ligneResaRepository;

    @Override
    @Transactional(readOnly = true)
    public PanierDto getOrCreatePanierByUser(Integer idUser) {
        Panier panier = panierRepository.findByUser_IdUser(idUser)
                .orElseGet(() -> {
                    User user = userRepository.findById(idUser)
                            .orElseThrow(() -> new NotFoundException("Utilisateur non trouvé : " + idUser));
                    Panier p = new Panier();
                    p.setUser(user);
                    p.setLignes(new ArrayList<>());
                    return panierRepository.save(p);
                });

        Panier detailed = panierRepository.findDetailedByIdPanier(panier.getIdPanier())
                .orElseThrow(() -> new NotFoundException("Panier non trouvé : " + panier.getIdPanier()));

        return mapToDto(detailed);
    }

    @Override
    public PanierDto addProduit(AddToCartRequest request) {
        User user = userRepository.findById(request.getIdUser())
                .orElseThrow(() -> new NotFoundException("Utilisateur non trouvé : " + request.getIdUser()));

        Produit produit = produitRepository.findById(request.getIdProduit())
                .orElseThrow(() -> new NotFoundException("Produit non trouvé : " + request.getIdProduit()));

        if (!produit.isDisponibilite()) {
            throw new IllegalArgumentException("Produit indisponible : " + produit.getNomProduit());
        }

        Panier panier = panierRepository.findByUser_IdUser(user.getIdUser())
                .orElseGet(() -> {
                    Panier p = new Panier();
                    p.setUser(user);
                    p.setLignes(new ArrayList<>());
                    return panierRepository.save(p);
                });

        LignePanierId id = new LignePanierId(panier.getIdPanier(), produit.getIdProduit());

        LignePanier ligne = lignePanierRepository.findById(id).orElse(null);

        if (ligne == null) {
            ligne = new LignePanier();
            ligne.setId(id);
            ligne.setPanier(panier);
            ligne.setProduit(produit);
            ligne.setQuantite(request.getQuantite());
        } else {
            ligne.setQuantite(ligne.getQuantite() + request.getQuantite());
        }

        ligne.setPrixUnitaire(produit.getPrix());
        ligne.setSousTotal(ligne.getQuantite() * produit.getPrix());

        lignePanierRepository.save(ligne);

        Panier detailed = panierRepository.findDetailedByIdPanier(panier.getIdPanier())
                .orElseThrow(() -> new NotFoundException("Panier non trouvé : " + panier.getIdPanier()));

        log.info("Produit {} ajouté au panier {} user {}", produit.getIdProduit(), panier.getIdPanier(), user.getIdUser());

        return mapToDto(detailed);
    }

    @Override
    public PanierDto updateQuantite(Integer idPanier, Integer idProduit, UpdateCartLineRequest request) {
        Panier panier = panierRepository.findDetailedByIdPanier(idPanier)
                .orElseThrow(() -> new NotFoundException("Panier non trouvé : " + idPanier));

        LignePanierId id = new LignePanierId(idPanier, idProduit);

        LignePanier ligne = lignePanierRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Ligne panier non trouvée"));

        ligne.setQuantite(request.getQuantite());
        ligne.setPrixUnitaire(ligne.getProduit().getPrix());
        ligne.setSousTotal(ligne.getQuantite() * ligne.getProduit().getPrix());

        lignePanierRepository.save(ligne);

        Panier detailed = panierRepository.findDetailedByIdPanier(panier.getIdPanier())
                .orElseThrow(() -> new NotFoundException("Panier non trouvé : " + panier.getIdPanier()));

        return mapToDto(detailed);
    }

    @Override
    public PanierDto removeProduit(Integer idPanier, Integer idProduit) {
        Panier panier = panierRepository.findDetailedByIdPanier(idPanier)
                .orElseThrow(() -> new NotFoundException("Panier non trouvé : " + idPanier));

        LignePanierId id = new LignePanierId(idPanier, idProduit);

        if (!lignePanierRepository.existsById(id)) {
            throw new NotFoundException("Produit non trouvé dans le panier");
        }

        lignePanierRepository.deleteById(id);

        Panier detailed = panierRepository.findDetailedByIdPanier(panier.getIdPanier())
                .orElseThrow(() -> new NotFoundException("Panier non trouvé : " + panier.getIdPanier()));

        return mapToDto(detailed);
    }

    @Override
    public void clearPanier(Integer idPanier) {
        Panier panier = panierRepository.findDetailedByIdPanier(idPanier)
                .orElseThrow(() -> new NotFoundException("Panier non trouvé : " + idPanier));

        panier.getLignes().clear();
        panierRepository.save(panier);

        log.info("Panier vidé {}", idPanier);
    }

    @Override
    public ReservationDto checkout(Integer idPanier, CheckoutPanierRequest request) {
        Panier panier = panierRepository.findDetailedByIdPanier(idPanier)
                .orElseThrow(() -> new NotFoundException("Panier non trouvé : " + idPanier));

        if (panier.getLignes() == null || panier.getLignes().isEmpty()) {
            throw new IllegalArgumentException("Le panier est vide");
        }

        Reservation reservation = new Reservation();
        reservation.setUser(panier.getUser());
        reservation.setDateReservation(request.getDateReservation());
        reservation.setHeureReservation(request.getHeureReservation());
        reservation.setStatut(StatutReservation.EN_ATTENTE);
        reservation.setTotalCommande(0);

        Reservation savedReservation = reservationRepository.save(reservation);

        double total = 0;
        List<LigneResa> lignesReservation = new ArrayList<>();

        for (LignePanier lignePanier : panier.getLignes()) {
            Produit produit = produitRepository.findById(lignePanier.getProduit().getIdProduit())
                    .orElseThrow(() -> new NotFoundException("Produit non trouvé : " + lignePanier.getProduit().getIdProduit()));

            if (!produit.isDisponibilite()) {
                throw new IllegalArgumentException("Produit indisponible : " + produit.getNomProduit());
            }

            if (produit.getQuantite() < lignePanier.getQuantite()) {
                throw new IllegalArgumentException("Stock insuffisant pour le produit : " + produit.getNomProduit());
            }

            produit.setQuantite(produit.getQuantite() - lignePanier.getQuantite());
            if (produit.getQuantite() == 0) {
                produit.setDisponibilite(false);
            }
            produitRepository.save(produit);

            LigneResa ligneResa = new LigneResa();
            ligneResa.setId(new LigneResaId(savedReservation.getIdReservation(), produit.getIdProduit()));
            ligneResa.setReservation(savedReservation);
            ligneResa.setProduit(produit);
            ligneResa.setQuantite(lignePanier.getQuantite());
            ligneResa.setPrixUnitaire(produit.getPrix());

            double sousTotal = produit.getPrix() * lignePanier.getQuantite();
            ligneResa.setSousTotal(sousTotal);

            total += sousTotal;

            ligneResaRepository.save(ligneResa);
            lignesReservation.add(ligneResa);
        }

        savedReservation.setLignes(lignesReservation);
        savedReservation.setTotalCommande(total);
        savedReservation.setQrCode("RESA:" + savedReservation.getIdReservation() + ";USER:" + panier.getUser().getIdUser());

        Reservation finalReservation = reservationRepository.save(savedReservation);

        panier.getLignes().clear();
        panierRepository.save(panier);

        log.info("Checkout panier {} -> réservation {}", idPanier, finalReservation.getIdReservation());

        return mapReservationToDto(finalReservation);
    }

    private PanierDto mapToDto(Panier panier) {
        PanierDto dto = new PanierDto();
        dto.setIdPanier(panier.getIdPanier());
        dto.setIdUser(panier.getUser().getIdUser());
        dto.setCreatedAt(panier.getCreatedAt());
        dto.setUpdatedAt(panier.getUpdatedAt());

        List<LignePanierDto> lignes = panier.getLignes() == null ? List.of() :
                panier.getLignes().stream().map(l -> {
                    LignePanierDto ld = new LignePanierDto();
                    ld.setIdProduit(l.getProduit().getIdProduit());
                    ld.setNomProduit(l.getProduit().getNomProduit());
                    ld.setQuantite(l.getQuantite());
                    ld.setPrixUnitaire(l.getPrixUnitaire());
                    ld.setSousTotal(l.getSousTotal());
                    ld.setImageUrl(l.getProduit().getImageUrl());
                    return ld;
                }).toList();

        dto.setLignes(lignes);
        dto.setTotalPanier(lignes.stream().mapToDouble(l -> l.getSousTotal() != null ? l.getSousTotal() : 0).sum());

        return dto;
    }

    private ReservationDto mapReservationToDto(Reservation reservation) {
        ReservationDto dto = new ReservationDto();
        dto.setIdReservation(reservation.getIdReservation());
        dto.setIdUser(reservation.getUser().getIdUser());
        dto.setQrCode(reservation.getQrCode());
        dto.setDateReservation(reservation.getDateReservation());
        dto.setHeureReservation(reservation.getHeureReservation());
        dto.setTotalCommande(reservation.getTotalCommande());
        dto.setStatut(reservation.getStatut().name());

        List<LigneResaDetailDto> lignes = reservation.getLignes().stream().map(l -> {
            LigneResaDetailDto detail = new LigneResaDetailDto();
            detail.setIdProduit(l.getProduit().getIdProduit());
            detail.setNomProduit(l.getProduit().getNomProduit());
            detail.setQuantite(l.getQuantite());
            detail.setPrixUnitaire(l.getPrixUnitaire());
            detail.setSousTotal(l.getSousTotal());
            return detail;
        }).toList();

        dto.setLignes(lignes);
        return dto;
    }
}
