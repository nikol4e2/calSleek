package com.webapp.calsleek.services;

import com.webapp.calsleek.model.Measurement;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface MeasurementService {


    Optional<Measurement> getMeasurementById(Long id);
    Measurement addMeasurementToUser(Long userId, LocalDateTime time, float value);
    Measurement editMeasurement(Long id, LocalDateTime time, float value);
    void deleteMeasurement(Long id);
    List<Measurement> getAllMeasurementsForUser(Long userId);
}
