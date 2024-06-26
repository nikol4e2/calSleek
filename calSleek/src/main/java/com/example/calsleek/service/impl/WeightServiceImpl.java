package com.example.calsleek.service.impl;

import com.example.calsleek.model.Weight;
import com.example.calsleek.repository.UserRepository;
import com.example.calsleek.repository.WeightRepository;
import com.example.calsleek.service.WeightService;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Optional;

@Service
public class WeightServiceImpl implements WeightService {

    private final WeightRepository weightRepository;
    private final UserRepository userRepository;

    public WeightServiceImpl(WeightRepository weightRepository, UserRepository userRepository) {
        this.weightRepository = weightRepository;
        this.userRepository = userRepository;
    }

    @Override
    public Weight save(float value, Date date) {
        return null;
    }

    @Override
    public void deleteById(Long id) {

    }

    @Override
    public Optional<Weight> findById(Long id) {
        return Optional.empty();
    }

    @Override
    public Optional<Weight> addWeightToUser(float value, String username) {
        return Optional.empty();
    }
}
