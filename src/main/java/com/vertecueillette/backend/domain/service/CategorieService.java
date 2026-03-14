package com.vertecueillette.backend.domain.service;

import com.vertecueillette.backend.domain.dto.CategorieDto;

import java.util.List;

public interface CategorieService {
    CategorieDto getById(Integer id);

    List<CategorieDto> getAll();

    CategorieDto create(CategorieDto dto);

    CategorieDto update(Integer id, CategorieDto dto);

    void delete(Integer id);
}
