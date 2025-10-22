package com.webapp.calsleek.model.dtos;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class MeasurementDto {

    private Long userId;
    private LocalDateTime date;
    private float value; //in kgs
}
