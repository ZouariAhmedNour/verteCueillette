package com.vertecueillette.backend.application.service;

import com.vertecueillette.backend.domain.dto.*;
import com.vertecueillette.backend.domain.entity.*;
import com.vertecueillette.backend.domain.exception.NotFoundException;
import com.vertecueillette.backend.domain.repository.LigneResaRepository;
import com.vertecueillette.backend.domain.repository.ProduitRepository;
import com.vertecueillette.backend.domain.repository.ReservationRepository;
import com.vertecueillette.backend.domain.repository.UserRepository;
import com.vertecueillette.backend.domain.service.ReservationService;
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
public class ReservationServiceImpl implements ReservationService {

    private final ReservationRepository reservationRepository;
    private final LigneResaRepository ligneResaRepository;
    private final UserRepository userRepository;
    private final ProduitRepository produitRepository;

    @Override
    @Transactional(readOnly = true)
    public ReservationDto getById(Integer id) {
        Reservation reservation = reservationRepository.findDetailedByIdReservation(id)
                .orElseThrow(() -> new NotFoundException("Réservation non trouvée : " + id));

        return mapToReservationDto(reservation);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReservationDto> getAll() {
        return reservationRepository.findAll()
                .stream()
                .map(this::mapToReservationDto)
                .toList();
    }

    @Override
    public ReservationDto create(ReservationCreateRequest dto) {
        User user = userRepository.findById(dto.getIdUser())
                .orElseThrow(() -> new NotFoundException("Utilisateur non trouvé : " + dto.getIdUser()));

        Reservation reservation = new Reservation();
        reservation.setUser(user);
        reservation.setDateReservation(dto.getDateReservation());
        reservation.setHeureReservation(dto.getHeureReservation());
        reservation.setStatut(StatutReservation.EN_ATTENTE);
        reservation.setTotalCommande(0);

        Reservation saved = reservationRepository.save(reservation);

        double total = 0;
        List<LigneResa> lignes = new ArrayList<>();

        for (LigneResaRequestDto ligneDto : dto.getLignes()) {
            Produit produit = produitRepository.findById(ligneDto.getIdProduit())
                    .orElseThrow(() -> new NotFoundException("Produit non trouvé : " + ligneDto.getIdProduit()));

            if (!produit.isDisponibilite()) {
                throw new IllegalArgumentException("Produit indisponible : " + produit.getNomProduit());
            }

            if (produit.getQuantite() < ligneDto.getQuantite()) {
                throw new IllegalArgumentException("Stock insuffisant pour le produit : " + produit.getNomProduit());
            }

            produit.setQuantite(produit.getQuantite() - ligneDto.getQuantite());
            if (produit.getQuantite() == 0) {
                produit.setDisponibilite(false);
            }
            produitRepository.save(produit);

            LigneResa ligne = new LigneResa();
            ligne.setId(new LigneResaId(saved.getIdReservation(), produit.getIdProduit()));
            ligne.setReservation(saved);
            ligne.setProduit(produit);
            ligne.setQuantite(ligneDto.getQuantite());
            ligne.setPrixUnitaire(produit.getPrix());

            double sousTotal = produit.getPrix() * ligneDto.getQuantite();
            ligne.setSousTotal(sousTotal);
            total += sousTotal;

            ligneResaRepository.save(ligne);
            lignes.add(ligne);
        }

        saved.setLignes(lignes);
        saved.setTotalCommande(total);
        saved.setQrCode("RESA:" + saved.getIdReservation() + ";USER:" + user.getIdUser());

        Reservation finalSaved = reservationRepository.save(saved);

        log.info("Réservation créée id={}, userId={}, total={}", finalSaved.getIdReservation(), user.getIdUser(), total);

        return mapToReservationDto(finalSaved);
    }

    @Override
    public ReservationDto updateStatut(Integer id, UpdateReservationStatutRequest dto) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Réservation non trouvée : " + id));

        StatutReservation nouveau = StatutReservation.valueOf(dto.getStatut());
        validateStatusTransition(reservation.getStatut(), nouveau);

        reservation.setStatut(nouveau);
        log.info("Changement statut réservation {} : {} -> {}", id, reservation.getStatut(), nouveau);

        return mapToReservationDto(reservationRepository.save(reservation));
    }

    @Override
    public void delete(Integer id) {
        Reservation reservation = reservationRepository.findDetailedByIdReservation(id)
                .orElseThrow(() -> new NotFoundException("Réservation non trouvée : " + id));

        for (LigneResa ligne : reservation.getLignes()) {
            Produit produit = ligne.getProduit();
            produit.setQuantite(produit.getQuantite() + ligne.getQuantite());
            produit.setDisponibilite(true);
            produitRepository.save(produit);
        }

        reservationRepository.delete(reservation);
        log.info("Réservation supprimée id={}", id);
    }

    @Override
    @Transactional(readOnly = true)
    public ReservationDetailDto getDetailsByReservation(Integer idReservation) {
        Reservation reservation = reservationRepository.findDetailedByIdReservation(idReservation)
                .orElseThrow(() -> new NotFoundException("Réservation non trouvée : " + idReservation));

        return mapToDetailDto(reservation);
    }

    @Override
    @Transactional(readOnly = true)
    public ReservationDetailDto scanQr(ScanQrRequest request) {
        String qr = request.getQrContent();
        if (!qr.startsWith("RESA:")) {
            throw new IllegalArgumentException("QR invalide");
        }

        String firstPart = qr.split(";")[0];
        Integer reservationId = Integer.parseInt(firstPart.replace("RESA:", "").trim());

        Reservation reservation = reservationRepository.findDetailedByIdReservation(reservationId)
                .orElseThrow(() -> new NotFoundException("Réservation non trouvée : " + reservationId));

        return mapToDetailDto(reservation);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReservationDto> getByUser(Integer idUser) {
        return reservationRepository.findByUser_IdUser(idUser)
                .stream()
                .map(this::mapToReservationDto)
                .toList();
    }

    private void validateStatusTransition(StatutReservation current, StatutReservation next) {
        if (current == StatutReservation.ANNULEE || current == StatutReservation.LIVREE) {
            throw new IllegalArgumentException("Transition interdite depuis le statut " + current);
        }
    }

    private ReservationDto mapToReservationDto(Reservation reservation) {
        ReservationDto dto = new ReservationDto();
        dto.setIdReservation(reservation.getIdReservation());
        dto.setIdUser(reservation.getUser().getIdUser());
        dto.setQrCode(reservation.getQrCode());
        dto.setDateReservation(reservation.getDateReservation());
        dto.setHeureReservation(reservation.getHeureReservation());
        dto.setTotalCommande(reservation.getTotalCommande());
        dto.setStatut(reservation.getStatut().name());

        if (reservation.getLignes() != null) {
            List<LigneResaDetailDto> lignes = reservation.getLignes().stream().map(l -> {
                LigneResaDetailDto ld = new LigneResaDetailDto();
                ld.setIdProduit(l.getProduit().getIdProduit());
                ld.setNomProduit(l.getProduit().getNomProduit());
                ld.setQuantite(l.getQuantite());
                ld.setPrixUnitaire(l.getPrixUnitaire());
                ld.setSousTotal(l.getSousTotal());
                return ld;
            }).toList();
            dto.setLignes(lignes);
        }

        return dto;
    }

    private ReservationDetailDto mapToDetailDto(Reservation reservation) {
        ReservationDetailDto dto = new ReservationDetailDto();
        dto.setIdReservation(reservation.getIdReservation());
        dto.setIdUser(reservation.getUser().getIdUser());
        dto.setNomClient(reservation.getUser().getNom());
        dto.setPrenomClient(reservation.getUser().getPrenom());
        dto.setEmailClient(reservation.getUser().getEmail());
        dto.setDateReservation(reservation.getDateReservation());
        dto.setHeureReservation(reservation.getHeureReservation());
        dto.setTotalCommande(reservation.getTotalCommande());
        dto.setStatut(reservation.getStatut().name());
        dto.setQrCode(reservation.getQrCode());

        List<LigneResaDetailDto> lignes = reservation.getLignes().stream().map(l -> {
            LigneResaDetailDto line = new LigneResaDetailDto();
            line.setIdProduit(l.getProduit().getIdProduit());
            line.setNomProduit(l.getProduit().getNomProduit());
            line.setQuantite(l.getQuantite());
            line.setPrixUnitaire(l.getPrixUnitaire());
            line.setSousTotal(l.getSousTotal());
            return line;
        }).toList();

        dto.setLignes(lignes);
        return dto;
    }
}
