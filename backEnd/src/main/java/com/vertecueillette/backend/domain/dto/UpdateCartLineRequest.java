package com.vertecueillette.backend.domain.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateCartLineRequest {

    @NotNull
    @Min(1)
    private Integer quantite;
}
