package com.example.calsleek.repository;

import com.example.calsleek.model.DailyMacros;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Date;
import java.util.Optional;

@Repository
public interface DailyMacrosRepository extends JpaRepository<DailyMacros,Long> {

    Optional<DailyMacros> findByDateEquals(LocalDate date);
}
