package com.webapp.calsleek.web;

import com.webapp.calsleek.model.Goal;
import com.webapp.calsleek.model.dtos.GoalDto;
import com.webapp.calsleek.services.GoalService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/goal")
public class GoalController {

    private final GoalService goalService;


    public GoalController(GoalService goalService) {
        this.goalService = goalService;
    }

    @GetMapping("/{id}")
    public ResponseEntity<Goal> getGoalById(@PathVariable Long id) {
        if(this.goalService.findById(id).isPresent()){
            return ResponseEntity.ok(this.goalService.findById(id).get());
        }
        return ResponseEntity.notFound().build();
    }


    //TODO-IMPLEMENT

//    @PostMapping
//    public ResponseEntity<Goal> createGoal(@RequestBody GoalDto goalDto) {
//
//
//    }


    //TODO-IMPLEMENT EDIT GOAL




    @DeleteMapping("/{id}")
    public ResponseEntity<Goal> deleteGoalById(@PathVariable Long id) {
        this.goalService.deleteGoal(id);
        if(!this.goalService.findById(id).isPresent()){
            return ResponseEntity.ok(this.goalService.findById(id).get());
        }
        return ResponseEntity.notFound().build();
    }
}
