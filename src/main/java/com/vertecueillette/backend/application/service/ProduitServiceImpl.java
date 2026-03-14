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
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
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
    public List<ProduitDto> getAll() {
        return produitRepository.findAll()
                .stream()
                .map(mapper::toDto)
                .toList();
    }

    @Override
    public ProduitDto create(ProduitDto dto) {

        Produit produit = mapper.toEntity(dto);

        // vérifier que la catégorie existe
        Categorie cat = categorieRepository.findById(dto.getIdCategorie())
                .orElseThrow(() -> new NotFoundException("Catégorie non trouvée : " + dto.getIdCategorie()));

        produit.setCategorie(cat);
        produit.setIdProduit(null); // sécurité

        return mapper.toDto(produitRepository.save(produit));
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

        // mise à jour de la catégorie si changée
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

}
