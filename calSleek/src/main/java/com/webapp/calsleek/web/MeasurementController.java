package com.webapp.calsleek.web;

import com.webapp.calsleek.model.Measurement;
import com.webapp.calsleek.model.User;
import com.webapp.calsleek.model.dtos.MeasurementDto;
import com.webapp.calsleek.services.MeasurementService;
import com.webapp.calsleek.services.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/measurement")
public class MeasurementController {

    private final MeasurementService measurementService;
    private final UserService userService;

    public MeasurementController(MeasurementService measurementService, UserService userService) {
        this.measurementService = measurementService;
        this.userService = userService;
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<MeasurementDto>> getAllMeasurementsForUser(@PathVariable Long userId) {
        if(!userService.findById(userId).isPresent()) {
            return ResponseEntity.notFound().build();
        }
        List<MeasurementDto> measurements= measurementService.getAllMeasurementsForUser(userId).stream().map(
                m->new MeasurementDto(
                        m.getId(),
                        m.getDate(),
                        m.getValue()
                )
        ).toList();
        return ResponseEntity.ok(measurements);
    }

    @PostMapping()
    public ResponseEntity<Measurement> createMeasurement(@RequestBody MeasurementDto measurementDto) {
        Measurement measurement=this.measurementService.addMeasurementToUser(measurementDto.getUserId(),measurementDto.getDate(),measurementDto.getValue());
        return ResponseEntity.ok(measurement);

    }
    @PutMapping("/{id}")
    public ResponseEntity<Measurement> editMeasurement(@PathVariable Long id, @RequestBody MeasurementDto measurementDto) {
        Measurement measurement=this.measurementService.editMeasurement(id,measurementDto.getDate(),measurementDto.getValue());
        return ResponseEntity.ok(measurement);

    }


    @DeleteMapping("/{id}")
    public ResponseEntity<Measurement> deleteMeasurement(@PathVariable Long id) {
        this.measurementService.deleteMeasurement(id);
        return ResponseEntity.noContent().build();
    }


    //TODO IMPLEMENT !!!
    @GetMapping("/user/{userId}/latest")
    public ResponseEntity<MeasurementDto> getLatest(@PathVariable Long userId) {
        Measurement m = measurementService.getLatest(userId);

        if (m == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(
                new MeasurementDto(
                        m.getId(),
                        m.getDate(),
                        m.getValue()
                )
        );
    }





}
