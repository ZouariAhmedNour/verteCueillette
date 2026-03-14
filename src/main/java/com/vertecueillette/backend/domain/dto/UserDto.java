package com.vertecueillette.backend.domain.dto;

import lombok.Data;

import java.time.LocalDate;

@Data
public class UserDto {
    private Integer idUser;
    private String nom;
    private String prenom;
    private String email;
    private String password;
    private String ville;
    private String role;
    private LocalDate dateNaiss;
    private String numTel;
    private LocalDate createdAt;
    private LocalDate passChangedAt;
    private String avatarUrl;
    private boolean is_verified;
}
