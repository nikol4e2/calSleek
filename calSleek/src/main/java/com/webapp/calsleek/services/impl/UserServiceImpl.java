package com.webapp.calsleek.services.impl;

import com.webapp.calsleek.model.DailyMacros;
import com.webapp.calsleek.model.User;
import com.webapp.calsleek.model.exceptions.InvalidUserCredentialsException;
import com.webapp.calsleek.model.exceptions.PasswordsDoNotMatchException;
import com.webapp.calsleek.model.exceptions.UserNameAlreadyExists;
import com.webapp.calsleek.model.exceptions.UserNotFoundException;
import com.webapp.calsleek.repositories.UserRepository;
import com.webapp.calsleek.services.UserService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {


    //TODO Add BCryptPassword Encoder


    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public User login(String username, String password) {
        if(username == null || password == null){
            throw new InvalidUserCredentialsException(username);
        }

        User user =userRepository.findByUsername(username).orElseThrow(()->new InvalidUserCredentialsException(username));

        /* if(!passwordEncoder.matches(password,user.getPassword())){
            throw new PasswordsDoNotMatchException();
         */
        return user;
    }

    @Override
    public User register(String username, String firstName, String lastName,String email, String password, String repeatPassword) {
        if(username==null || username.isEmpty() || password==null || password.isEmpty())
        {
            throw new InvalidUserCredentialsException(username);
        }
        if(!password.equals(repeatPassword))
        {
            throw new PasswordsDoNotMatchException();
        }
        if(this.userRepository.findByUsername(username).isPresent())
        {
            throw new UserNameAlreadyExists(username);
        }

        //String encodedPassword=passwordEncoder.encode(password);
        User user = new User(username,firstName,lastName,email,password); //encoded password ovde
        return userRepository.save(user);
    }

    @Override
    public Optional<User> findByUsername(String username) {
       return userRepository.findByUsername(username);
    }

    @Override
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }


    @Override
    public void addDailyMacrosToUser(Long userId, DailyMacros dailyMacros) {
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);

        List<DailyMacros> dailyMacrosList = user.getDailyMacros();
        dailyMacrosList.add(dailyMacros);
        user.setDailyMacros(dailyMacrosList);
        userRepository.save(user);
    }
}
