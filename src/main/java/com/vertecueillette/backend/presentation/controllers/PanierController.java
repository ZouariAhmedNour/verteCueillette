package com.vertecueillette.backend.presentation.controllers;

import com.vertecueillette.backend.domain.dto.*;
import com.vertecueillette.backend.domain.service.PanierService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/paniers")
@RequiredArgsConstructor
public class PanierController {

    private final PanierService panierService;

    @Operation(summary = "Récupérer ou créer le panier d'un utilisateur")
    @PreAuthorize("hasRole('CLIENT')")
    @GetMapping("/user/{idUser}")
    public ResponseEntity<PanierDto> getOrCreateByUser(@PathVariable Integer idUser) {
        return ResponseEntity.ok(panierService.getOrCreatePanierByUser(idUser));
    }

    @Operation(summary = "Ajouter un produit au panier")
    @PreAuthorize("hasRole('CLIENT')")
    @PostMapping("/add")
    public ResponseEntity<PanierDto> addProduit(@Valid @RequestBody AddToCartRequest request) {
        return ResponseEntity.ok(panierService.addProduit(request));
    }

    @Operation(summary = "Modifier la quantité d'un produit dans le panier")
    @PreAuthorize("hasRole('CLIENT')")
    @PutMapping("/{idPanier}/produits/{idProduit}")
    public ResponseEntity<PanierDto> updateQuantite(
            @PathVariable Integer idPanier,
            @PathVariable Integer idProduit,
            @Valid @RequestBody UpdateCartLineRequest request
    ) {
        return ResponseEntity.ok(panierService.updateQuantite(idPanier, idProduit, request));
    }

    @Operation(summary = "Supprimer un produit du panier")
    @PreAuthorize("hasRole('CLIENT')")
    @DeleteMapping("/{idPanier}/produits/{idProduit}")
    public ResponseEntity<PanierDto> removeProduit(
            @PathVariable Integer idPanier,
            @PathVariable Integer idProduit
    ) {
        return ResponseEntity.ok(panierService.removeProduit(idPanier, idProduit));
    }

    @Operation(summary = "Vider le panier")
    @PreAuthorize("hasRole('CLIENT')")
    @DeleteMapping("/{idPanier}/clear")
    public ResponseEntity<Void> clearPanier(@PathVariable Integer idPanier) {
        panierService.clearPanier(idPanier);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Valider le panier et créer une réservation")
    @PreAuthorize("hasRole('CLIENT')")
    @PostMapping("/{idPanier}/checkout")
    public ResponseEntity<ReservationDto> checkout(
            @PathVariable Integer idPanier,
            @Valid @RequestBody CheckoutPanierRequest request
    ) {
        return ResponseEntity.ok(panierService.checkout(idPanier, request));
    }
}
