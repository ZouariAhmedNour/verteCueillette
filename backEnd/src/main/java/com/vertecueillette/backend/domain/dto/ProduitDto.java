package com.vertecueillette.backend.domain.dto;

import lombok.Data;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ProduitDto {
    private Integer idProduit;

    @NotBlank
    private String nomProduit;

    private String description;
    private String imageUrl;

    @Min(0)
    private double prix;

    @NotNull
    @Min(0)
    private Integer quantite;

    private boolean disponibilite;

    @NotNull
    private Integer idCategorie;
}