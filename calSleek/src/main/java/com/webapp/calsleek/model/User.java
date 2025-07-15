package com.webapp.calsleek.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String username;
    private String firstName;
    private String lastName;
    private String email;
    private String password;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "goal_id")
    private Goal goal;

    @OneToMany(cascade = CascadeType.ALL,mappedBy = "user",orphanRemoval = true)
    private List<Measurement> measurements;

    @OneToMany(cascade = CascadeType.ALL,mappedBy = "user",orphanRemoval = true)
    private List<DailyMacros> dailyMacros;


    public User(String username, String firstName, String lastName, String email, String password) {
        this.username = username;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.goal=null;
        this.measurements=new ArrayList<>();
        this.dailyMacros=new ArrayList<>();
    }

}
