package com.vertecueillette.backend.domain.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Data
public class ReservationDetailDto {
    private Integer idReservation;
    private Integer idUser;
    private String nomClient;
    private String prenomClient;
    private String emailClient;
    private LocalDate dateReservation;
    private LocalTime heureReservation;
    private double totalCommande;
    private String statut;
    private String qrCode;
    private List<LigneResaDetailDto> lignes;
}
