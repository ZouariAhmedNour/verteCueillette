package com.vertecueillette.backend.domain.dto;

import lombok.Data;

import java.util.List;

@Data
public class ReservationViewDto {
    private Integer idReservation;
    private List<ProduitDto> produits;
}
