package com.vertecueillette.backend.application.service;

import com.vertecueillette.backend.domain.dto.LigneResaDto;
import com.vertecueillette.backend.domain.dto.ProduitDto;
import com.vertecueillette.backend.domain.dto.ReservationDto;
import com.vertecueillette.backend.domain.dto.ReservationViewDto;
import com.vertecueillette.backend.domain.entity.*;
import com.vertecueillette.backend.domain.exception.NotFoundException;
import com.vertecueillette.backend.domain.repository.LigneResaRepository;
import com.vertecueillette.backend.domain.repository.ProduitRepository;
import com.vertecueillette.backend.domain.repository.ReservationRepository;
import com.vertecueillette.backend.domain.repository.UserRepository;
import com.vertecueillette.backend.domain.service.QrService;
import com.vertecueillette.backend.domain.service.ReservationService;
import com.vertecueillette.backend.mapper.LigneResaMapper;
import com.vertecueillette.backend.mapper.ProduitMapper;
import com.vertecueillette.backend.mapper.ReservationMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;


import java.util.List;

@Service
@RequiredArgsConstructor
public class ReservationServiceImpl implements ReservationService {

    private final ReservationRepository reservationRepository;
    private final LigneResaRepository ligneResaRepository;
    private final UserRepository userRepository;
    private final ProduitRepository produitRepository;

    private final ReservationMapper reservationMapper;
    private final LigneResaMapper ligneResaMapper;
    private final ProduitMapper produitMapper;

    private final QrService qrCodeService;

    @Override
    public ReservationDto getById(Integer id) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Réservation non trouvée : " + id));

        return reservationMapper.toDto(reservation);
    }

    @Override
    public List<ReservationDto> getAll() {
        return reservationRepository.findAll()
                .stream()
                .map(reservationMapper::toDto)
                .toList();
    }

    @Override
    public ReservationDto create(ReservationDto dto) {
        Reservation reservation = reservationMapper.toEntity(dto);

        User user = userRepository.findById(dto.getIdUser())
                .orElseThrow(() -> new NotFoundException("Utilisateur non trouvé : " + dto.getIdUser()));

        reservation.setUser(user);
        reservation.setStatut(StatutReservation.valueOf(dto.getStatut()));

        Reservation saved = reservationRepository.save(reservation);

        String qrContent =
                "RESA:" + saved.getIdReservation() +
                        ";USER:" + saved.getUser().getIdUser() +
                        ";TOTAL:" + saved.getTotalCommande();

        saved.setQrCode(qrContent);

        // Gestion des lignes
        if (dto.getLignes() != null) {
            for (LigneResaDto ligneDto : dto.getLignes()) {

                LigneResa ligne = ligneResaMapper.toEntity(ligneDto);

                Produit produit = produitRepository.findById(ligneDto.getIdProduit())
                        .orElseThrow(() -> new NotFoundException("Produit non trouvé : " + ligneDto.getIdProduit()));

                ligne.getId().setIdReservation(saved.getIdReservation());
                ligne.setReservation(saved);
                ligne.setProduit(produit);

                ligne.setPrixUnitaire(produit.getPrix());
                ligne.setSousTotal(ligne.getQuantite() * produit.getPrix());

                ligneResaRepository.save(ligne);
            }
        }

        return reservationMapper.toDto(saved);
    }

    @Override
    public ReservationDto update(Integer id, ReservationDto dto) {
        Reservation existing = reservationRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Réservation non trouvée : " + id));

        existing.setQrCode(dto.getQrCode());
        existing.setDateReservation(dto.getDateReservation());
        existing.setHeureReservation(dto.getHeureReservation());
        existing.setTotalCommande(dto.getTotalCommande());
        existing.setStatut(StatutReservation.valueOf(dto.getStatut()));

        Reservation saved = reservationRepository.save(existing);

        return reservationMapper.toDto(saved);
    }

    @Override
    public void delete(Integer id) {
        if (!reservationRepository.existsById(id)) {
            throw new NotFoundException("Réservation non trouvée : " + id);
        }
        reservationRepository.deleteById(id);
    }

    @Override
    public ReservationViewDto getProduitsByReservation(Integer idReservation) {
        Reservation reservation = reservationRepository.findById(idReservation)
                .orElseThrow(() -> new NotFoundException("Réservation non trouvée : " + idReservation));

        ReservationViewDto view = new ReservationViewDto();
        view.setIdReservation(reservation.getIdReservation());

        List<ProduitDto> produits = reservation.getLignes()
                .stream()
                .map(ligne -> produitMapper.toDto(ligne.getProduit()))
                .toList();

        view.setProduits(produits);

        return view;
    }
}
