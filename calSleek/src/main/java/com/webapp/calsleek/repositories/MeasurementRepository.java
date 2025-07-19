package com.webapp.calsleek.repositories;

import com.webapp.calsleek.model.Measurement;
import com.webapp.calsleek.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface MeasurementRepository extends JpaRepository<Measurement, Long> {


}
