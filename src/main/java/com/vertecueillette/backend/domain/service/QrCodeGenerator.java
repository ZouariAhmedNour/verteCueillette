package com.vertecueillette.backend.domain.service;

public interface QrCodeGenerator {
    byte[] generateQrPng(String text, int width, int height);
}
