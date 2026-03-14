package com.vertecueillette.backend.domain.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Data
public class ReservationDto {
    private Integer idReservation;
    private Integer idUser;
    private String qrCode;
    private LocalDate dateReservation;
    private LocalTime heureReservation;
    private double totalCommande;
    private String statut;
    private List<LigneResaDto> lignes;
}
