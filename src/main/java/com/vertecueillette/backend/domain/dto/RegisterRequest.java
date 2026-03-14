package com.vertecueillette.backend.domain.dto;

import lombok.Data;

@Data
public class RegisterRequest {

    private String nom;
    private String prenom;
    private String email;
    private String password;
    private String ville;

}
