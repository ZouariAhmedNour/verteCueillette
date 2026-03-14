package com.vertecueillette.backend.domain.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.cglib.core.Local;

import java.time.LocalDate;


@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idUser;

    private String nom;
    private String prenom;

    @Column(unique = true, nullable = false)
    private String email;

    private String password;

    private String ville;

    private String role = "CLIENT";

    private LocalDate dateNaiss;

    private String numTel;

    private LocalDate createdAt;

    private LocalDate passChangedAt;

    private String avatarUrl;

    private boolean is_verified;


}
