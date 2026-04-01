package com.vertecueillette.backend.domain.dto;

import lombok.Data;

@Data
public class LigneResaDto {
    private Integer idLigneResa;
    private Integer idProduit;
    private Integer quantite;
    private double prixUnitaire;
    private Double sousTotal;
}
