package com.vertecueillette.backend.application.service;

import com.vertecueillette.backend.domain.dto.UserDto;
import com.vertecueillette.backend.domain.entity.User;
import com.vertecueillette.backend.domain.exception.NotFoundException;
import com.vertecueillette.backend.domain.repository.UserRepository;
import com.vertecueillette.backend.domain.service.UserService;
import com.vertecueillette.backend.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final UserMapper userMapper;

    @Override
    public UserDto getUserById(Integer id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Utilisateur non trouvé avec id : " + id));
        return userMapper.toDto(user);
    }

    @Override
    public UserDto createUser(UserDto dto) {
        User user = userMapper.toEntity(dto);
        user.setIdUser(null); // sécurité
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
    public UserDto updateUser(Integer id, UserDto dto) {
        User existing = userRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Utilisateur non trouvé pour mise à jour : " + id));

        // mise à jour simple → domaine simple
        existing.setNom(dto.getNom());
        existing.setPrenom(dto.getPrenom());
        existing.setEmail(dto.getEmail());
        existing.setPassword(dto.getPassword());
        existing.setVille(dto.getVille());
        existing.setRole(dto.getRole());
        existing.setDateNaiss(dto.getDateNaiss());
        existing.setNumTel(dto.getNumTel());
        existing.setAvatarUrl(dto.getAvatarUrl());
        existing.set_verified(dto.is_verified());

        return userMapper.toDto(userRepository.save(existing));
    }
}