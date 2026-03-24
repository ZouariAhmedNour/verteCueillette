package com.vertecueillette.backend.domain.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "ligne_panier")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LignePanier {
    @EmbeddedId
    private LignePanierId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idPanier")
    @JoinColumn(name = "idPanier")
    private Panier panier;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idProduit")
    @JoinColumn(name = "idProduit")
    private Produit produit;

    private Integer quantite;

    private double prixUnitaire;

    private Double sousTotal;

}
