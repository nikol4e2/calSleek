package com.webapp.calsleek.repositories;

import com.webapp.calsleek.model.DailySummary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DailySummaryRepository extends JpaRepository<DailySummary, Long> {
}
