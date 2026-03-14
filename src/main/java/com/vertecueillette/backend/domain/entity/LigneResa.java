package com.vertecueillette.backend.domain.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "ligne_resa")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LigneResa {

    @EmbeddedId
    private LigneResaId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idReservation")
    @JoinColumn(name = "idReservation")
    private Reservation reservation;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("idProduit")
    @JoinColumn(name = "idProduit")
    private Produit produit;

    private Integer quantite;

    private double prixUnitaire;

    private Double sousTotal;
}
