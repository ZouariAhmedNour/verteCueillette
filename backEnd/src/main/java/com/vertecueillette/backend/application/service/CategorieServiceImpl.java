package com.vertecueillette.backend.application.service;

import com.vertecueillette.backend.domain.dto.CategorieDto;
import com.vertecueillette.backend.domain.entity.Categorie;
import com.vertecueillette.backend.domain.exception.NotFoundException;
import com.vertecueillette.backend.domain.repository.CategorieRepository;
import com.vertecueillette.backend.domain.service.CategorieService;
import com.vertecueillette.backend.mapper.CategorieMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategorieServiceImpl implements CategorieService {

    private final CategorieRepository repository;
    private final CategorieMapper mapper;

    @Override
    public CategorieDto getById(Integer id) {
        Categorie categorie = repository.findById(id)
                .orElseThrow(() -> new NotFoundException("Catégorie non trouvée avec id : " + id));

        return mapper.toDto(categorie);
    }

    @Override
    public List<CategorieDto> getAll() {
        return repository.findAll()
                .stream()
                .map(mapper::toDto)
                .toList();
    }

    @Override
    public CategorieDto create(CategorieDto dto) {
        Categorie categorie = mapper.toEntity(dto);
        categorie.setIdCategorie(null); // sécurité
        return mapper.toDto(repository.save(categorie));
    }

    @Override
    public CategorieDto update(Integer id, CategorieDto dto) {
        Categorie existing = repository.findById(id)
                .orElseThrow(() -> new NotFoundException("Catégorie non trouvée pour mise à jour : " + id));

        existing.setNomCategorie(dto.getNomCategorie());

        return mapper.toDto(repository.save(existing));
    }

    @Override
    public void delete(Integer id) {
        if (!repository.existsById(id)) {
            throw new NotFoundException("Catégorie non trouvée pour suppression : " + id);
        }
        repository.deleteById(id);
    }






}
