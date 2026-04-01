package com.vertecueillette.backend.domain.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CategorieDto {
    private Integer idCategorie;

    @NotBlank
    private String nomCategorie;
}
