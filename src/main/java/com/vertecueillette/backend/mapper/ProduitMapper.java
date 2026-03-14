package com.vertecueillette.backend.mapper;

import com.vertecueillette.backend.domain.dto.ProduitDto;
import com.vertecueillette.backend.domain.entity.Produit;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;


@Mapper(componentModel = "spring")

public interface ProduitMapper {
    @Mapping(source = "categorie.idCategorie", target = "idCategorie")
    ProduitDto toDto(Produit produit);

    @Mapping(target = "categorie", ignore = true)
    Produit toEntity(ProduitDto dto);
}
