package com.webapp.calsleek.model.dtos;


import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class FoodDtoResponse {

    private Long id;
    private String name;
    private String brand;
    private int calories;
    private int carbs;
    private int protein;
    private int fats;
    private boolean verified;
}
