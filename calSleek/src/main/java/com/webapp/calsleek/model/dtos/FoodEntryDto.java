package com.webapp.calsleek.model.dtos;

import com.webapp.calsleek.model.Food;
import com.webapp.calsleek.model.enums.TimeCategory;
import jakarta.persistence.CascadeType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FoodEntryDto {
    private TimeCategory category;
    private Long foodId;
    private Long dailyMacrosId;
    private int grams;



    public FoodEntryDto(Long foodId, TimeCategory category, int grams) {
        this.category = category;
        this.foodId = foodId;
        this.grams = grams;

        float multiplier= grams / 100.0f;

    }
}
