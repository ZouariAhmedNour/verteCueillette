package com.vertecueillette.backend.domain.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

@Data
public class CheckoutPanierRequest {

    @NotNull
    private LocalDate dateReservation;

    @NotNull
    private LocalTime heureReservation;
}
