package com.example.calsleek.repository;

import com.example.calsleek.model.Weight;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.Optional;

@Repository
public interface WeightRepository extends JpaRepository<Weight,Long> {

    Optional<Weight> findByDateEqualsAndId(Date date, Long id);
}
