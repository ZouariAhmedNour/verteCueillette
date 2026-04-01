package com.vertecueillette.backend.domain.dto;

import com.vertecueillette.backend.domain.enums.Role;
import jakarta.validation.constraints.Email;
import lombok.Data;

import java.time.LocalDate;

@Data
public class UpdateUserRequest {
    private String nom;
    private String prenom;

    @Email
    private String email;

    private String password;
    private String ville;
    private Role role;
    private LocalDate dateNaiss;
    private String numTel;
    private String avatarUrl;
    private Boolean verified;
}
