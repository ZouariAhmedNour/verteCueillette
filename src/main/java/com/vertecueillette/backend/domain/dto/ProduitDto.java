package com.vertecueillette.backend.domain.dto;

import lombok.Data;

@Data
public class ProduitDto {
    private Integer idProduit;
    private String nomProduit;
    private String description;
    private String imageUrl;
    private double prix;
    private Integer quantite;
    private boolean disponibilite;
    private Integer idCategorie;
}
