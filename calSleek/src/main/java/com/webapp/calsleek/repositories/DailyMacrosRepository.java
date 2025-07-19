package com.webapp.calsleek.repositories;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.Optional;

public interface DailyMacrosRepository extends JpaRepository<DailyMacros, Long> {

}
