package com.vertecueillette.backend.domain.entity;

import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Embeddable
@NoArgsConstructor
@AllArgsConstructor
public class LigneResaId implements Serializable {
    private Integer idReservation;
    private Integer idProduit;
}
