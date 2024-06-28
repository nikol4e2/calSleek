package com.example.calsleek.service.impl;

import com.example.calsleek.model.User;
import com.example.calsleek.model.Weight;
import com.example.calsleek.repository.UserRepository;
import com.example.calsleek.repository.WeightRepository;
import com.example.calsleek.service.WeightService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
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
    public Weight save(float value, LocalDate date) {
        return this.weightRepository.save(new Weight(value,date));
    }

    @Override
    public void deleteById(Long id) {
        this.weightRepository.deleteById(id);
    }


    @Override
    public Optional<Weight> findById(Long id) {
        return this.weightRepository.findById(id);
    }

    @Override
    public Optional<Weight> addWeightToUser(float value, String username) {
        Weight weight=new Weight(value, LocalDate.now());
        this.weightRepository.save(weight);
        User user=this.userRepository.findByUsername(username).get();
        List<Weight> weightList=user.getWeightList();
        weightList.add(weight);
        user.setWeightList(weightList);
        this.userRepository.save(user);
        return Optional.of(weight);
    }
}
