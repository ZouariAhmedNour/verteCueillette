package com.vertecueillette.backend.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AuthenticationResponse {
    private String token;
    private Integer idUser;
    private String nom;
    private String prenom;
    private String email;
    private String role;
}
