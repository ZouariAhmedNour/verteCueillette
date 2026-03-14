package com.vertecueillette.backend.domain.repository;

import com.vertecueillette.backend.domain.entity.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReservationRepository extends JpaRepository <Reservation, Integer>{

}
