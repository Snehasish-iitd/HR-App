package com.HR.app.Service.Storage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class FileStorageFactory {

    @Autowired
    private GoogleOAuthDriveStorageStrategy googleOAuthDriveStrategy; // NEW IMPLEMENTATION

    public FileStorageStrategy getStorageStrategy() {
        // For now, you only have the OAuth-based Drive strategy. Return it.
        return googleOAuthDriveStrategy;
    }
}
