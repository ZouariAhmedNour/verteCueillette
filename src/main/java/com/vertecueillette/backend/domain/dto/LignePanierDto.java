package com.vertecueillette.backend.domain.dto;

import lombok.Data;

@Data
public class LignePanierDto {
    private Integer idProduit;
    private String nomProduit;
    private Integer quantite;
    private double prixUnitaire;
    private Double sousTotal;
    private String imageUrl;
}
