package com.vertecueillette.backend.domain.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class PanierDto {
    private Integer idPanier;
    private Integer idUser;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private double totalPanier;
    private List<LignePanierDto> lignes;
}
