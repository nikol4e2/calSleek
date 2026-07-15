package com.webapp.calsleek.model.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class MeasurementDto {

    private Long userId;
    private LocalDateTime date;
    private float value; //in kgs
}
