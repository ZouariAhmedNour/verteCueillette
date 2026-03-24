package com.vertecueillette.backend.domain.repository;

import com.vertecueillette.backend.domain.entity.Produit;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProduitRepository extends JpaRepository<Produit, Integer> {
    Page<Produit> findByCategorie_IdCategorie(Integer idCategorie, Pageable pageable);
    Page<Produit> findByNomProduitContainingIgnoreCase(String keyword, Pageable pageable);

}
