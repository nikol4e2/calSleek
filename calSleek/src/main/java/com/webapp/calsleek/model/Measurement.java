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
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private LocalDateTime date;
    @Column(name = "measurement_value")
    private float value; //in kgs

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;



    public Measurement(LocalDateTime date, float value, User user) {
        this.date = date;
        this.value = value;
        this.user = user;
    }
}
