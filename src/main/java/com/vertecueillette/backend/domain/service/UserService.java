package com.vertecueillette.backend.domain.service;

import com.vertecueillette.backend.domain.dto.UserDto;

import java.util.List;


public interface UserService {

    UserDto getUserById(Integer id);

    UserDto getUserByEmail(String email);

    UserDto createUser(UserDto dto);

    UserDto updateUser(Integer id, UserDto dto);

    void deleteUser(Integer id);
}
