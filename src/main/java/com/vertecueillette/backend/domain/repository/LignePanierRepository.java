package com.vertecueillette.backend.domain.repository;

import com.vertecueillette.backend.domain.entity.LignePanier;
import com.vertecueillette.backend.domain.entity.LignePanierId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LignePanierRepository extends JpaRepository<LignePanier, LignePanierId> {
}
