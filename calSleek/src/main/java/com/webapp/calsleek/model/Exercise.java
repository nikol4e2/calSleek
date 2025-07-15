package com.webapp.calsleek.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@Entity
public class Exercise {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String name;
    private int caloriesBurnedPerMinute;

    public Exercise(String name, int caloriesBurnedPerMinute) {
        this.name = name;
        this.caloriesBurnedPerMinute = caloriesBurnedPerMinute;
    }
}
