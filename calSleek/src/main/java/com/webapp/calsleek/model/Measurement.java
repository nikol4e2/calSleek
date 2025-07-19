package com.webapp.calsleek.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@Entity
public class Measurement {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private LocalDateTime date;
    private float value; //in kgs



    public Measurement(LocalDateTime date, float value) {
        this.date = date;
        this.value = value;
    }
}
