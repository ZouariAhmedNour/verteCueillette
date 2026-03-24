package com.vertecueillette.backend.mapper;

import com.vertecueillette.backend.domain.dto.UserDto;
import com.vertecueillette.backend.domain.entity.User;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserMapper {
    UserDto toDto(User u);

}
