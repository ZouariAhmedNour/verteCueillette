package com.vertecueillette.backend.domain.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateReservationStatutRequest {
    @NotBlank
    private String statut;
}
