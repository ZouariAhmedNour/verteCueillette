package com.vertecueillette.backend.mapper;

import com.vertecueillette.backend.domain.dto.LigneResaDto;
import com.vertecueillette.backend.domain.entity.LigneResa;
import com.vertecueillette.backend.domain.entity.LigneResaId;
import org.mapstruct.AfterMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface LigneResaMapper {

    @Mapping(target = "idLigneResa", source = "id.idReservation")
    @Mapping(target = "idProduit", source = "id.idProduit")
    LigneResaDto toDto(LigneResa entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "reservation", ignore = true)
    @Mapping(target = "produit", ignore = true)
    LigneResa toEntity(LigneResaDto dto);

    // Construction de l'ID composite après le mapping
    @AfterMapping
    default void assignId(@MappingTarget LigneResa entity, LigneResaDto dto) {
        LigneResaId id = new LigneResaId();
        id.setIdProduit(dto.getIdProduit());
        // idReservation sera renseigné dans le service
        entity.setId(id);
    }
}
