package com.vertecueillette.backend.presentation.controllers;

import com.vertecueillette.backend.domain.dto.UserDto;
import com.vertecueillette.backend.domain.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/{id}")
    public ResponseEntity<UserDto> getById(@PathVariable Integer id) {
        return ResponseEntity.ok(userService.getUserById(id));
    }

    // GET - Find by Email
    @GetMapping("/email/{email}")
    public ResponseEntity<UserDto> getByEmail(@PathVariable String email) {
        return ResponseEntity.ok(userService.getUserByEmail(email));
    }

    // POST - Create
    @PostMapping
    public ResponseEntity<UserDto> create(@RequestBody UserDto dto) {
        UserDto created = userService.createUser(dto);
        return ResponseEntity.created(URI.create("/api/users/" + created.getIdUser()))
                .body(created);
    }
    // PUT - Update
    @PutMapping("/{id}")
    public ResponseEntity<UserDto> update(
            @PathVariable Integer id,
            @RequestBody UserDto dto
    ) {
        return ResponseEntity.ok(userService.updateUser(id, dto));
    }

    // DELETE - Delete
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Integer id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }









}
