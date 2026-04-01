package com.vertecueillette.backend.application.service;

import com.vertecueillette.backend.domain.dto.ProduitDto;
import com.vertecueillette.backend.domain.entity.Categorie;
import com.vertecueillette.backend.domain.entity.Produit;
import com.vertecueillette.backend.domain.exception.NotFoundException;
import com.vertecueillette.backend.domain.repository.CategorieRepository;
import com.vertecueillette.backend.domain.repository.ProduitRepository;
import com.vertecueillette.backend.domain.service.ProduitService;
import com.vertecueillette.backend.mapper.ProduitMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProduitServiceImpl implements ProduitService {

    private final ProduitRepository produitRepository;
    private final CategorieRepository categorieRepository;
    private final ProduitMapper mapper;

    @Override
    public ProduitDto getById(Integer id) {
        Produit produit = produitRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Produit non trouvé avec id : " + id));
        return mapper.toDto(produit);
    }

    @Override
    public Page<ProduitDto> getAll(int page, int size, String sortBy, String sortDir) {
        Pageable pageable = PageRequest.of(page, size,
                Sort.by("desc".equalsIgnoreCase(sortDir) ? Sort.Direction.DESC : Sort.Direction.ASC, sortBy));

        return produitRepository.findAll(pageable).map(mapper::toDto);
    }

    @Override
    public ProduitDto create(ProduitDto dto) {
        Produit produit = mapper.toEntity(dto);

        Categorie cat = categorieRepository.findById(dto.getIdCategorie())
                .orElseThrow(() -> new NotFoundException("Catégorie non trouvée : " + dto.getIdCategorie()));

        produit.setCategorie(cat);
        produit.setIdProduit(null);

        Produit saved = produitRepository.save(produit);
        log.info("Produit créé id={}, nom={}", saved.getIdProduit(), saved.getNomProduit());

        return mapper.toDto(saved);
    }

    @Override
    public ProduitDto update(Integer id, ProduitDto dto) {
        Produit existing = produitRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Produit non trouvé pour mise à jour : " + id));

        existing.setNomProduit(dto.getNomProduit());
        existing.setDescription(dto.getDescription());
        existing.setImageUrl(dto.getImageUrl());
        existing.setPrix(dto.getPrix());
        existing.setQuantite(dto.getQuantite());
        existing.setDisponibilite(dto.isDisponibilite());

        if (dto.getIdCategorie() != null) {
            Categorie cat = categorieRepository.findById(dto.getIdCategorie())
                    .orElseThrow(() -> new NotFoundException("Catégorie non trouvée : " + dto.getIdCategorie()));
            existing.setCategorie(cat);
        }

        return mapper.toDto(produitRepository.save(existing));
    }

    @Override
    public void delete(Integer id) {
        if (!produitRepository.existsById(id)) {
            throw new NotFoundException("Produit non trouvé pour suppression : " + id);
        }
        produitRepository.deleteById(id);
    }

    @Override
    public Page<ProduitDto> getByCategorie(Integer idCategorie, int page, int size, String sortBy, String sortDir) {
        Pageable pageable = PageRequest.of(page, size,
                Sort.by("desc".equalsIgnoreCase(sortDir) ? Sort.Direction.DESC : Sort.Direction.ASC, sortBy));

        return produitRepository.findByCategorie_IdCategorie(idCategorie, pageable).map(mapper::toDto);
    }

    @Override
    public Page<ProduitDto> search(String keyword, int page, int size, String sortBy, String sortDir) {
        Pageable pageable = PageRequest.of(page, size,
                Sort.by("desc".equalsIgnoreCase(sortDir) ? Sort.Direction.DESC : Sort.Direction.ASC, sortBy));

        return produitRepository.findByNomProduitContainingIgnoreCase(keyword, pageable).map(mapper::toDto);
    }
}