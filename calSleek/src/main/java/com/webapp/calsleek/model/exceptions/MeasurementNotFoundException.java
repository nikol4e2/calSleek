package com.webapp.calsleek.model.exceptions;

public class MeasurementNotFoundException extends RuntimeException{
    public MeasurementNotFoundException(Long id) {
        super("Measurement with id " + id + " not found");
    }
}
