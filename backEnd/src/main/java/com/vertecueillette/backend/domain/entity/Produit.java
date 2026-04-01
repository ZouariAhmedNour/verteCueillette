package com.vertecueillette.backend.domain.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "produit")
public class Produit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idProduit;

    private String nomProduit;
    private String description;
    private String imageUrl;
    private double prix;
    private Integer quantite;
    private boolean disponibilite;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "idCategorie")
    private Categorie categorie;


}
