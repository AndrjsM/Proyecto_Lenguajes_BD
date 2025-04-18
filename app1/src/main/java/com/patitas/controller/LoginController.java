package com.patitas.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String showLoginPage(@RequestParam(value = "successMessage", required = false) String successMessage,
                                 @RequestParam(value = "errorMessage", required = false) String errorMessage,
                                 Model model) {
        if (successMessage != null) {
            model.addAttribute("successMessage", successMessage);
        }
        if (errorMessage != null) {
            model.addAttribute("errorMessage", errorMessage);
        }
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
