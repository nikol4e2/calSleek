package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.Measurement;
import com.webapp.calsleek.model.User;
import com.webapp.calsleek.model.exceptions.MeasurementNotFoundException;
import com.webapp.calsleek.model.exceptions.UserNotFoundException;
import com.webapp.calsleek.repositories.MeasurementRepository;
import com.webapp.calsleek.repositories.UserRepository;
import com.webapp.calsleek.services.MeasurementService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class MeasurementServiceImpl implements MeasurementService {

    private final MeasurementRepository measurementRepository;
    private final UserRepository userRepository;

    public MeasurementServiceImpl(MeasurementRepository measurementRepository,UserRepository userRepository) {
        this.measurementRepository = measurementRepository;
        this.userRepository = userRepository;
    }

    @Override
    public Optional<Measurement> getMeasurementById(Long id) {
        return  measurementRepository.findById(id);
    }

    @Override
    public Measurement addMeasurementToUser(Long userId, LocalDateTime time, float value) {
        User user=userRepository.findById(userId).orElseThrow(() -> new UserNotFoundException());
        Measurement measurement=new Measurement(time,value);

        List<Measurement> measurementList=user.getMeasurements();
        measurementList.add(measurement);
        user.setMeasurements(measurementList);
        userRepository.save(user);
        return measurement;
    }

    @Override
    public Measurement editMeasurement(Long id, LocalDateTime time, float value) {
        Measurement measurement=this.measurementRepository.findById(id).orElseThrow(()->new MeasurementNotFoundException(id));
        measurement.setDate(time);
        measurement.setValue(value);
        return this.measurementRepository.save(measurement);
    }

    @Override
    public void deleteMeasurement(Long id) {
        if(this.measurementRepository.existsById(id)) {
            this.measurementRepository.deleteById(id);
        }
    }

    @Override
    public List<Measurement> getAllMeasurementsForUser(Long userId)
    {

        //TODO SORT THE MEASUREMENTS BY DATE/TIME
        User user=userRepository.findById(userId).orElseThrow(() -> new UserNotFoundException());
        return user.getMeasurements();
    }
}
