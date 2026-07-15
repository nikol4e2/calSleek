package com.webapp.calsleek.model.dtos;


import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class MeasurementResponseDto {
    private Long id;
    private LocalDateTime date;
    private float value;
}
