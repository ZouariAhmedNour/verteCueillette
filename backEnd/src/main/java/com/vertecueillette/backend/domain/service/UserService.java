package com.vertecueillette.backend.domain.service;

import com.vertecueillette.backend.domain.dto.CreateUserRequest;
import com.vertecueillette.backend.domain.dto.UpdateUserRequest;
import com.vertecueillette.backend.domain.dto.UserDto;


public interface UserService {

    UserDto getUserById(Integer id);

    UserDto getUserByEmail(String email);

    UserDto createUser(CreateUserRequest dto);

    UserDto updateUser(Integer id, UpdateUserRequest dto);

    void deleteUser(Integer id);
}
