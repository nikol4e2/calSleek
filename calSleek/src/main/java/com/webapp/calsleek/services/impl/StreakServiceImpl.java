package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.User;
import com.webapp.calsleek.repositories.UserRepository;
import com.webapp.calsleek.services.StreakService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
public class StreakServiceImpl implements StreakService {

    private final UserRepository userRepository;


    public StreakServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }



    @Override
    public void updateStreak(User user) {
        LocalDate today=LocalDate.now();


        if(user.getLastActivityDate()==null)
        {
            user.setCurrentStreak(1);
            user.setBestStreak(1);
        }

        else {
            LocalDate last=user.getLastActivityDate();

            //if the user has been active today
            if(last.equals(today))
            {
                return;
            }

            if(last.plusDays(1).equals(today))
            {
                user.setCurrentStreak(user.getCurrentStreak()+1);
            }else {
                user.setCurrentStreak(1);
            }

            if(user.getCurrentStreak() > user.getBestStreak())
            {
                user.setBestStreak(user.getCurrentStreak());
            }
        }
        user.setLastActivityDate(today);
        userRepository.save(user);
    }

}
