package com.vertecueillette.backend.domain.dto;

import com.vertecueillette.backend.domain.enums.Role;
import lombok.Data;

import java.time.LocalDate;

@Data
public class UserDto {
    private Integer idUser;
    private String nom;
    private String prenom;
    private String email;
    private String ville;
    private Role role;
    private LocalDate dateNaiss;
    private String numTel;
    private LocalDate createdAt;
    private LocalDate passChangedAt;
    private String avatarUrl;
    private boolean is_verified;
}
