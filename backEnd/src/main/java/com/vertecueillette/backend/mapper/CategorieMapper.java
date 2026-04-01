package com.vertecueillette.backend.mapper;

import com.vertecueillette.backend.domain.dto.CategorieDto;
import com.vertecueillette.backend.domain.entity.Categorie;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface CategorieMapper {

    CategorieDto toDto(Categorie categorie);

    Categorie toEntity(CategorieDto dto);


}
