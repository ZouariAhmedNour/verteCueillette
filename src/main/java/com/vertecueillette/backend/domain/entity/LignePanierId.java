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
public class LignePanierId implements Serializable {
    private Integer idPanier;
    private Integer idProduit;
}
