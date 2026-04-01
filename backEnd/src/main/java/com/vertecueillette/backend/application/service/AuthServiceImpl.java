package com.vertecueillette.backend.application.service;

import com.vertecueillette.backend.domain.dto.AuthenticationRequest;
import com.vertecueillette.backend.domain.dto.AuthenticationResponse;
import com.vertecueillette.backend.domain.dto.RegisterRequest;
import com.vertecueillette.backend.domain.entity.User;
import com.vertecueillette.backend.domain.enums.Role;
import com.vertecueillette.backend.domain.exception.NotFoundException;
import com.vertecueillette.backend.domain.repository.UserRepository;
import com.vertecueillette.backend.domain.service.AuthService;
import com.vertecueillette.backend.infrastructure.security.JwtService;
import com.vertecueillette.backend.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    @Override
    public AuthenticationResponse register(RegisterRequest request) {
        // vérifier si email existe
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Email déjà utilisé");
        }

        User user = new User();
        user.setNom(request.getNom());
        user.setPrenom(request.getPrenom());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setVille(request.getVille());
        user.setRole(Role.CLIENT); // par défaut, adapte si besoin

        User saved = userRepository.save(user);

        String token = jwtService.generateToken(saved);
        return new AuthenticationResponse(token);
    }

    @Override
    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        // authentifier via AuthenticationManager (déclenche UserDetailsService + password check)
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new NotFoundException("Utilisateur non trouvé"));

        String token = jwtService.generateToken(user);
        return new AuthenticationResponse(token);
    }
}
