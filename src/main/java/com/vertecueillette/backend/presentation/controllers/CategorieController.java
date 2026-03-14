package com.vertecueillette.backend.presentation.controllers;

import com.vertecueillette.backend.domain.dto.CategorieDto;
import com.vertecueillette.backend.domain.service.CategorieService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategorieController {

    private final CategorieService categorieService;

    @GetMapping("/{id}")
    public ResponseEntity<CategorieDto> getById(@PathVariable Integer id) {
        return ResponseEntity.ok(categorieService.getById(id));
    }

    @GetMapping
    public ResponseEntity<List<CategorieDto>> getAll() {
        return ResponseEntity.ok(categorieService.getAll());
    }

    @PostMapping
    public ResponseEntity<CategorieDto> create(@RequestBody CategorieDto dto) {
        CategorieDto created = categorieService.create(dto);
        return ResponseEntity.created(URI.create("/api/v1/categories/" + created.getIdCategorie()))
                .body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<CategorieDto> update(
            @PathVariable Integer id,
            @RequestBody CategorieDto dto
    ) {
        return ResponseEntity.ok(categorieService.update(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Integer id) {
        categorieService.delete(id);
        return ResponseEntity.noContent().build();
    }






}
