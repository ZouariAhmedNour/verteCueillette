package com.vertecueillette.backend.domain.service;

import com.vertecueillette.backend.domain.dto.*;

import java.util.List;

public interface ReservationService {

    ReservationDto getById(Integer id);

    List<ReservationDto> getAll();

    ReservationDto create(ReservationCreateRequest dto);

    ReservationDto updateStatut(Integer id, UpdateReservationStatutRequest dto);

    void delete(Integer id);

    ReservationDetailDto getDetailsByReservation(Integer idReservation);

    ReservationDetailDto scanQr(ScanQrRequest request);

    List<ReservationDto> getByUser(Integer idUser);
}
