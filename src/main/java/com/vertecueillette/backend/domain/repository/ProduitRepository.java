package com.vertecueillette.backend.domain.repository;

import com.vertecueillette.backend.domain.entity.Produit;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProduitRepository extends JpaRepository<Produit, Integer> {

}
