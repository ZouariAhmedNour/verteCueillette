package com.vertecueillette.backend.presentation.controllers;

import com.vertecueillette.backend.domain.dto.ProduitDto;
import com.vertecueillette.backend.domain.service.ProduitService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/produits")
@RequiredArgsConstructor
public class ProduitController {
    private final ProduitService produitService;

    @GetMapping("/{id}")
    public ResponseEntity<ProduitDto> getById(@PathVariable Integer id) {
        return ResponseEntity.ok(produitService.getById(id));
    }

    @GetMapping
    public ResponseEntity<List<ProduitDto>> getAll() {
        return ResponseEntity.ok(produitService.getAll());
    }

    @PostMapping
    public ResponseEntity<ProduitDto> create(@RequestBody ProduitDto dto) {
        ProduitDto created = produitService.create(dto);
        return ResponseEntity.created(URI.create("/api/v1/produits/" + created.getIdProduit()))
                .body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProduitDto> update(
            @PathVariable Integer id,
            @RequestBody ProduitDto dto
    ) {
        return ResponseEntity.ok(produitService.update(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Integer id) {
        produitService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
