package com.patitas.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String showLoginPage() {
        return "usuarios/login";
    }

    @GetMapping("/registrar")
    public String showRegistrarPage() {
        return "usuarios/registrar";
    }

    @GetMapping("/")
    public String showIndexPage() {
        return "index";
    }
}
