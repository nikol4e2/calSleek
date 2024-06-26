package com.example.calsleek.service;

import com.example.calsleek.model.Weight;

import java.util.Date;
import java.util.Optional;

public interface WeightService {

    Weight save(float value, Date date);
    void deleteById(Long id);
    Optional<Weight> findById(Long id);
    Optional<Weight> addWeightToUser(float value,String username);

}
