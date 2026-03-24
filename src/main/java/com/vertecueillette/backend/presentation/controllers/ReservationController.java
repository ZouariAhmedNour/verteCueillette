package com.vertecueillette.backend.presentation.controllers;

import com.vertecueillette.backend.domain.dto.*;
import com.vertecueillette.backend.domain.service.QrCodeGenerator;
import com.vertecueillette.backend.domain.service.ReservationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reservations")
@RequiredArgsConstructor
public class ReservationController {

    private final ReservationService reservationService;
    private final QrCodeGenerator qrCodeGenerator;

    @PreAuthorize("hasAnyRole('CLIENT','ADMIN','VENDEUR')")
    @GetMapping("/{id}")
    public ReservationDto getById(@PathVariable Integer id) {
        return reservationService.getById(id);
    }

    @PreAuthorize("hasAnyRole('ADMIN','VENDEUR')")
    @GetMapping
    public List<ReservationDto> getAll() {
        return reservationService.getAll();
    }

    @PreAuthorize("hasRole('CLIENT')")
    @PostMapping
    public ReservationDto create(@Valid @RequestBody ReservationCreateRequest dto) {
        return reservationService.create(dto);
    }

    @PreAuthorize("hasAnyRole('ADMIN','VENDEUR')")
    @PatchMapping("/{id}/statut")
    public ReservationDto updateStatut(@PathVariable Integer id, @Valid @RequestBody UpdateReservationStatutRequest dto) {
        return reservationService.updateStatut(id, dto);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public void delete(@PathVariable Integer id) {
        reservationService.delete(id);
    }

    @PreAuthorize("hasAnyRole('ADMIN','VENDEUR')")
    @GetMapping("/{id}/details")
    public ReservationDetailDto getDetails(@PathVariable Integer id) {
        return reservationService.getDetailsByReservation(id);
    }

    @PreAuthorize("hasAnyRole('ADMIN','VENDEUR')")
    @PostMapping("/scan")
    public ReservationDetailDto scanQr(@Valid @RequestBody ScanQrRequest request) {
        return reservationService.scanQr(request);
    }

    @PreAuthorize("hasAnyRole('CLIENT','ADMIN')")
    @GetMapping("/user/{idUser}")
    public List<ReservationDto> getByUser(@PathVariable Integer idUser) {
        return reservationService.getByUser(idUser);
    }

    @PreAuthorize("hasAnyRole('CLIENT','ADMIN','VENDEUR')")
    @GetMapping(value = "/{id}/qrcode", produces = MediaType.IMAGE_PNG_VALUE)
    public ResponseEntity<byte[]> getReservationQr(@PathVariable Integer id) {
        ReservationDto dto = reservationService.getById(id);
        byte[] png = qrCodeGenerator.generateQrPng(dto.getQrCode(), 400, 400);

        return ResponseEntity.ok()
                .contentType(MediaType.IMAGE_PNG)
                .header("Content-Disposition", "attachment; filename=\"reservation-" + id + "-qr.png\"")
                .body(png);
    }
}