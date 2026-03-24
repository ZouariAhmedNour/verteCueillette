package com.vertecueillette.backend.domain.service;

import com.vertecueillette.backend.domain.dto.*;
import com.vertecueillette.backend.domain.entity.Reservation;

public interface PanierService {

    PanierDto getOrCreatePanierByUser(Integer idUser);

    PanierDto addProduit(AddToCartRequest request);

    PanierDto updateQuantite(Integer idPanier, Integer idProduit, UpdateCartLineRequest request);

    PanierDto removeProduit(Integer idPanier, Integer idProduit);

    void clearPanier(Integer idPanier);

    ReservationDto checkout(Integer idPanier, CheckoutPanierRequest request);
}
