package com.vertecueillette.backend.presentation.controllers;

import com.vertecueillette.backend.domain.dto.ProduitDto;
import com.vertecueillette.backend.domain.service.ProduitService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.net.URI;

@RestController
@RequestMapping("/api/produits")
@RequiredArgsConstructor
public class ProduitController {
    private final ProduitService produitService;

    @Operation(summary = "Récupérer un produit par id")
    @GetMapping("/{id}")
    public ResponseEntity<ProduitDto> getById(@PathVariable Integer id) {
        return ResponseEntity.ok(produitService.getById(id));
    }

    @Operation(summary = "Lister les produits avec pagination")
    @GetMapping
    public ResponseEntity<Page<ProduitDto>> getAll(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "idProduit") String sortBy,
            @RequestParam(defaultValue = "asc") String sortDir
    ) {
        return ResponseEntity.ok(produitService.getAll(page, size, sortBy, sortDir));
    }

    @Operation(summary = "Lister les produits par catégorie")
    @GetMapping("/categorie/{idCategorie}")
    public ResponseEntity<Page<ProduitDto>> getByCategorie(
            @PathVariable Integer idCategorie,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "idProduit") String sortBy,
            @RequestParam(defaultValue = "asc") String sortDir
    ) {
        return ResponseEntity.ok(produitService.getByCategorie(idCategorie, page, size, sortBy, sortDir));
    }

    @Operation(summary = "Rechercher des produits")
    @GetMapping("/search")
    public ResponseEntity<Page<ProduitDto>> search(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "idProduit") String sortBy,
            @RequestParam(defaultValue = "asc") String sortDir
    ) {
        return ResponseEntity.ok(produitService.search(keyword, page, size, sortBy, sortDir));
    }

    @PreAuthorize("hasAnyRole('ADMIN','VENDEUR')")
    @PostMapping
    public ResponseEntity<ProduitDto> create(@Valid @RequestBody ProduitDto dto) {
        ProduitDto created = produitService.create(dto);
        return ResponseEntity.created(URI.create("/api/produits/" + created.getIdProduit())).body(created);
    }

    @PreAuthorize("hasAnyRole('ADMIN','VENDEUR')")
    @PutMapping("/{id}")
    public ResponseEntity<ProduitDto> update(@PathVariable Integer id, @Valid @RequestBody ProduitDto dto) {
        return ResponseEntity.ok(produitService.update(id, dto));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Integer id) {
        produitService.delete(id);
        return ResponseEntity.noContent().build();
    }
}