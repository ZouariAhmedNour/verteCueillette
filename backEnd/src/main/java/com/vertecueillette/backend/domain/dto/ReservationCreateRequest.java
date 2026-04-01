package com.vertecueillette.backend.domain.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Data
public class ReservationCreateRequest {

    @NotNull
    private Integer idUser;

    @NotNull
    private LocalDate dateReservation;

    @NotNull
    private LocalTime heureReservation;

    @Valid
    @NotEmpty
    private List<LigneResaRequestDto> lignes;
}
