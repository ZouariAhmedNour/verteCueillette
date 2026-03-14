package com.vertecueillette.backend.domain.service;

import com.vertecueillette.backend.domain.dto.ProduitDto;

import java.util.List;

public interface ProduitService {
    ProduitDto getById(Integer id);

    List<ProduitDto> getAll();

    ProduitDto create(ProduitDto dto);

    ProduitDto update(Integer id, ProduitDto dto);

    void delete(Integer id);
}
