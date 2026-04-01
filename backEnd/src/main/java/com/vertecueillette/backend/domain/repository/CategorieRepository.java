package com.vertecueillette.backend.domain.repository;

import com.vertecueillette.backend.domain.entity.Categorie;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategorieRepository extends JpaRepository<Categorie, Integer> {

}
