package com.webapp.calsleek.repositories;

import com.webapp.calsleek.model.Measurement;
import com.webapp.calsleek.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
@Repository
public interface MeasurementRepository extends JpaRepository<Measurement, Long> {


    Optional<Measurement> findFirstByUserIdOrderByDateDesc(Long userId);
}
