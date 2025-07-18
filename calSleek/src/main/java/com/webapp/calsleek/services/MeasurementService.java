package com.webapp.calsleek.services;

import com.webapp.calsleek.model.Measurement;

import java.time.LocalDateTime;
import java.util.List;

public interface MeasurementService {

    Measurement addMeasurementToUser(Long userId, LocalDateTime time, float value);
    Measurement editMeasurement(Long id, LocalDateTime time, float value);
    void deleteMeasurement(Long id);
    List<Measurement> getAllMeasurementsForUser(Long userId);
}
