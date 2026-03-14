package com.vertecueillette.backend.domain.service;

import com.vertecueillette.backend.domain.dto.ReservationDto;
import com.vertecueillette.backend.domain.dto.ReservationViewDto;

import java.util.List;

public interface ReservationService {

    ReservationDto getById(Integer id);

    List<ReservationDto> getAll();

    ReservationDto create(ReservationDto dto);

    ReservationDto update(Integer id, ReservationDto dto);

    void delete(Integer id);

    ReservationViewDto getProduitsByReservation(Integer idReservation);
}
