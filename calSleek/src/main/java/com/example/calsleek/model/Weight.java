package com.example.calsleek.model;

import lombok.Data;

import java.time.LocalDate;
import java.util.Date;

@Data
public class Weight {

    private Long id;
    private float value;
    private LocalDate date;

    public Weight(float value, LocalDate date) {
        this.value = value;
        this.date = date;
    }
}
