package com.vertecueillette.backend.domain.repository;

import com.vertecueillette.backend.domain.entity.Panier;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PanierRepository extends JpaRepository<Panier, Integer> {

    @EntityGraph(attributePaths = {"user", "lignes", "lignes.produit"})
    Optional<Panier> findByUser_IdUser(Integer idUser);

    @EntityGraph(attributePaths = {"user", "lignes", "lignes.produit"})
    Optional<Panier> findDetailedByIdPanier(Integer idPanier);
}
