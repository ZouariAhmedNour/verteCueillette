package com.vertecueillette.backend.domain.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ScanQrRequest {
    @NotBlank
    private String qrContent;
}
