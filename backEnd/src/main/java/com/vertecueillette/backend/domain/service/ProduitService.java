package com.vertecueillette.backend.domain.service;

import com.vertecueillette.backend.domain.dto.ProduitDto;
import org.springframework.data.domain.Page;


public interface ProduitService {
    ProduitDto getById(Integer id);
    Page<ProduitDto> getAll(int page, int size, String sortBy, String sortDir);
    ProduitDto create(ProduitDto dto);
    ProduitDto update(Integer id, ProduitDto dto);
    void delete(Integer id);
    Page<ProduitDto> getByCategorie(Integer idCategorie, int page, int size, String sortBy, String sortDir);
    Page<ProduitDto> search(String keyword, int page, int size, String sortBy, String sortDir);
}
