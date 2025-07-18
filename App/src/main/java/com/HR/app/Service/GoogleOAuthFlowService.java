package com.HR.app.Service;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.auth.oauth2.TokenResponse;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.DriveScopes;

import jakarta.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.Collections;

@Service
public class GoogleOAuthFlowService {
    private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
    private static final java.io.File TOKENS_DIRECTORY = new java.io.File("tokens");

    @Value("${google.oauth.credentials.file.path}")
    private String credentialsFilePath;

    @Value("${google.oauth.redirect.uri}")
    private String redirectUri;

    private GoogleAuthorizationCodeFlow flow;

    @PostConstruct
    public void init() throws Exception {
        NetHttpTransport httpTransport = GoogleNetHttpTransport.newTrustedTransport();
        InputStream in = getClass().getClassLoader()
            .getResourceAsStream("credentials.json");
        if (in == null) throw new FileNotFoundException("Resource not found: credentials.json");

        GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(JSON_FACTORY, new InputStreamReader(in));

        // KEY CHANGE: Add setDataStoreFactory for token persistence
        flow = new GoogleAuthorizationCodeFlow.Builder(
                httpTransport, JSON_FACTORY, clientSecrets,
                Collections.singletonList(DriveScopes.DRIVE_FILE)) 
                .setAccessType("offline")
                .setDataStoreFactory(new FileDataStoreFactory(TOKENS_DIRECTORY))
                .build();
    }

    public String getAuthorizationUrl() {
        return flow.newAuthorizationUrl()
            .setRedirectUri(redirectUri)
            .build();
    }

    // CORRECTED: Add userId, store credentials this way!
    public Credential exchangeCode(String code, String userId) throws Exception {
        TokenResponse tokenResponse = flow.newTokenRequest(code)
            .setRedirectUri(redirectUri)
            .execute();
        // Save tokens for this user
        return flow.createAndStoreCredential(tokenResponse, userId);
    }

    public Credential loadCredential(String userId) throws Exception {
        return flow.loadCredential(userId);
    }

    public Drive getDriveService(Credential credential) throws Exception {
        NetHttpTransport httpTransport = GoogleNetHttpTransport.newTrustedTransport();
        return new Drive.Builder(httpTransport, JSON_FACTORY, credential)
                .setApplicationName("HR Reimbursement App")
                .build();
    }
}
