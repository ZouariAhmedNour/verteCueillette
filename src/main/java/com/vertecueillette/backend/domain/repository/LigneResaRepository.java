package com.vertecueillette.backend.domain.repository;

import com.vertecueillette.backend.domain.entity.LigneResa;
import com.vertecueillette.backend.domain.entity.LigneResaId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LigneResaRepository extends JpaRepository <LigneResa, LigneResaId>{

}
