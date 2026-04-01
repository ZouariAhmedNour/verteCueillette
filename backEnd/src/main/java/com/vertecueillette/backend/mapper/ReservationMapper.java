package com.vertecueillette.backend.mapper;

import com.vertecueillette.backend.domain.dto.ReservationDto;
import com.vertecueillette.backend.domain.entity.Reservation;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;


@Mapper(componentModel = "spring", uses = { LigneResaMapper.class })
public interface ReservationMapper {

    @Mapping(source = "user.idUser", target = "idUser")
    @Mapping(source = "statut", target = "statut")
    ReservationDto toDto(Reservation reservation);

    @Mapping(target = "user", ignore = true)
    @Mapping(target = "lignes", ignore = true)
    @Mapping(target = "statut", ignore = true)
    Reservation toEntity(ReservationDto dto);

}