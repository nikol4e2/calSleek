package com.example.calsleek.model;

import lombok.Data;

import java.util.Date;

@Data
public class Weight {

    private Long id;
    private float value;
    private Date date;

    public Weight(float value, Date date) {
        this.value = value;
        this.date = date;
    }
}
