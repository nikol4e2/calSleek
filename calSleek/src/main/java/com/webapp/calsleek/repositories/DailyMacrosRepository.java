package com.webapp.calsleek.repositories;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.Optional;
@Repository
public interface DailyMacrosRepository extends JpaRepository<DailyMacros, Long> {
    Optional<DailyMacros> findByUser_IdAndDate(Long userId, LocalDate date);


}
