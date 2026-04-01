package com.vertecueillette.backend.domain.service;

import com.vertecueillette.backend.domain.dto.AuthenticationRequest;
import com.vertecueillette.backend.domain.dto.AuthenticationResponse;
import com.vertecueillette.backend.domain.dto.RegisterRequest;

public interface AuthService {
    AuthenticationResponse register(RegisterRequest request);
    AuthenticationResponse authenticate(AuthenticationRequest request);
}
