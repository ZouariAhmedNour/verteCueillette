package com.vertecueillette.backend.domain.dto;

import lombok.Data;

@Data
public class LigneResaDetailDto {
    private Integer idProduit;
    private String nomProduit;
    private Integer quantite;
    private double prixUnitaire;
    private Double sousTotal;
}
