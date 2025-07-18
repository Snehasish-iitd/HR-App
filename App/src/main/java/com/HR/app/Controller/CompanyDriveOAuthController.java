package com.HR.app.Controller;

import com.HR.app.Service.GoogleOAuthFlowService;


import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/company-drive")
public class CompanyDriveOAuthController {
    private static final String COMPANY_USER_ID = "snehasishbala52@gmail.com";

    @Autowired
    private GoogleOAuthFlowService googleOAuthFlowService;

    // Step 1: Start the OAuth2 consent flow for admin/company Drive
    @GetMapping("/authorize")
    public void authorize(HttpServletResponse response) throws Exception {
        response.sendRedirect(googleOAuthFlowService.getAuthorizationUrl());
    }

    // Step 2: Google calls back with ?code=...
    @GetMapping("/oauth2callback")
    public String oauthCallback(@RequestParam("code") String code) throws Exception {
        googleOAuthFlowService.exchangeCode(code, COMPANY_USER_ID);
        return "Company Drive connected successfully!";
    }
}



