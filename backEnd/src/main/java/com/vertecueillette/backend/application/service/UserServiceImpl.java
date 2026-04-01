package com.vertecueillette.backend.application.service;

import com.vertecueillette.backend.domain.dto.CreateUserRequest;
import com.vertecueillette.backend.domain.dto.UpdateUserRequest;
import com.vertecueillette.backend.domain.dto.UserDto;
import com.vertecueillette.backend.domain.entity.User;
import com.vertecueillette.backend.domain.exception.NotFoundException;
import com.vertecueillette.backend.domain.repository.UserRepository;
import com.vertecueillette.backend.domain.service.UserService;
import com.vertecueillette.backend.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public UserDto getUserById(Integer id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Utilisateur non trouvé avec id : " + id));
        return userMapper.toDto(user);
    }

    @Override
    public UserDto createUser(CreateUserRequest dto) {
        if (userRepository.findByEmail(dto.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Email déjà utilisé");
        }

        User user = new User();
        user.setNom(dto.getNom());
        user.setPrenom(dto.getPrenom());
        user.setEmail(dto.getEmail());
        user.setVille(dto.getVille());
        user.setRole(dto.getRole());
        user.setPassword(passwordEncoder.encode(dto.getPassword()));

        return userMapper.toDto(userRepository.save(user));
    }

    @Override
    public void deleteUser(Integer id) {
        if (!userRepository.existsById(id)) {
            throw new NotFoundException("Utilisateur non trouvé pour suppression : " + id);
        }
        userRepository.deleteById(id);
    }

    @Override
    public UserDto getUserByEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new NotFoundException("Utilisateur non trouvé avec email : " + email));
        return userMapper.toDto(user);
    }

    @Override
    public UserDto updateUser(Integer id, UpdateUserRequest dto) {
        User existing = userRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Utilisateur non trouvé pour mise à jour : " + id));

        if (dto.getNom() != null) existing.setNom(dto.getNom());
        if (dto.getPrenom() != null) existing.setPrenom(dto.getPrenom());
        if (dto.getEmail() != null) existing.setEmail(dto.getEmail());
        if (dto.getVille() != null) existing.setVille(dto.getVille());
        if (dto.getRole() != null) existing.setRole(dto.getRole());
        if (dto.getDateNaiss() != null) existing.setDateNaiss(dto.getDateNaiss());
        if (dto.getNumTel() != null) existing.setNumTel(dto.getNumTel());
        if (dto.getAvatarUrl() != null) existing.setAvatarUrl(dto.getAvatarUrl());

        if (dto.getPassword() != null && !dto.getPassword().isBlank()) {
            existing.setPassword(passwordEncoder.encode(dto.getPassword()));
            existing.setPassChangedAt(LocalDateTime.now());
        }

        return userMapper.toDto(userRepository.save(existing));
    }
}