package com.vertecueillette.backend.domain.repository;

import com.vertecueillette.backend.domain.entity.Reservation;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ReservationRepository extends JpaRepository <Reservation, Integer>{

    @EntityGraph(attributePaths = {"user", "lignes", "lignes.produit"})
    Optional<Reservation> findDetailedByIdReservation(Integer idReservation);

    @EntityGraph(attributePaths = {"user", "lignes", "lignes.produit"})
    List<Reservation> findByUser_IdUser(Integer idUser);

}
