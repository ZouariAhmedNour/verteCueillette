package com.vertecueillette.backend.presentation.controllers;

import com.vertecueillette.backend.domain.dto.ReservationDto;
import com.vertecueillette.backend.domain.dto.ReservationViewDto;
import com.vertecueillette.backend.domain.service.QrService;
import com.vertecueillette.backend.domain.service.ReservationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reservations")
@RequiredArgsConstructor
public class ReservationController {

    private final ReservationService reservationService;
    private final QrService qrCodeService;

    @GetMapping("/{id}")
    public ReservationDto getById(@PathVariable Integer id) {
        return reservationService.getById(id);
    }

    @GetMapping
    public List<ReservationDto> getAll() {
        return reservationService.getAll();
    }

    @PostMapping
    public ReservationDto create(@RequestBody ReservationDto dto) {
        return reservationService.create(dto);
    }

    @PutMapping("/{id}")
    public ReservationDto update(@PathVariable Integer id, @RequestBody ReservationDto dto) {
        return reservationService.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Integer id) {
        reservationService.delete(id);
    }

    @GetMapping("/{id}/produits")
    public ReservationViewDto getProduits(@PathVariable Integer id) {
        return reservationService.getProduitsByReservation(id);
    }

    @GetMapping("/{id}/qrcode")
    public ResponseEntity<byte[]> getReservationQr(@PathVariable Integer id) {
        ReservationDto dto = reservationService.getById(id);
        if (dto.getQrCode() == null || dto.getQrCode().isBlank()) {
            throw new RuntimeException("QR non généré pour la réservation " + id); // ou NotFoundException
        }
        byte[] png = qrCodeService.generateQrPng(dto.getQrCode(), 400, 400);
        return ResponseEntity.ok()
                .contentType(org.springframework.http.MediaType.IMAGE_PNG)
                .header("Content-Disposition", "attachment; filename=\"reservation-" + id + "-qr.png\"")
                .body(png);
    }

}
