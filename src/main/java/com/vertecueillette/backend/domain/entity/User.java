package com.vertecueillette.backend.domain.entity;

import com.vertecueillette.backend.domain.enums.Role;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;

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

    @Enumerated(EnumType.STRING)
    private Role role = Role.CLIENT;

    private LocalDate dateNaiss;

    private String numTel;

    private LocalDateTime createdAt;

    private LocalDateTime passChangedAt;

    private String avatarUrl;

    private boolean is_verified;


}
