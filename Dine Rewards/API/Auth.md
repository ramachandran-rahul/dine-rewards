# Dine Rewards - AuthManager

## Overview

The `AuthManager` class is a singleton responsible for managing user authentication in the Dine Rewards app. It leverages Firebase Authentication to handle phone number verification, OTP verification, and user sign-in/sign-out operations. The class also tracks the user's login status and provides user information.

## Features

- **Phone Number Authentication**: Initiates authentication by sending an OTP to the provided phone number.
- **OTP Verification**: Verifies the OTP code received by the user and signs them in.
- **Sign Out**: Signs out the current user.
- **Login Status Tracking**: Tracks and publishes the login status and user information.

## Usage

### Initialization

The `AuthManager` is implemented as a singleton, which can be accessed using `AuthManager.shared`.

### Start Authentication

To start the authentication process by sending an OTP to the user's phone number:

```swift
AuthManager.shared.startAuth(phoneNumber: "+1234567890") { success in
    if success {
        print("OTP sent successfully.")
    } else {
        print("Failed to send OTP.")
    }
}```

### Verify OTP

To verify the OTP code and sign in the user:

```swift
AuthManager.shared.verifyCode(smsCode: "123456") { success in
    if success {
        print("User signed in successfully.")
    } else {
        print("Failed to sign in.")
    }
}```

### Sign Out

To sign out the current user:

```swift
AuthManager.shared.signOut { success in
    if success {
        print("User signed out successfully.")
    } else {
        print("Failed to sign out.")
    }
}```

### Observing Login Status

The AuthManager provides published properties isLoggedIn and user to observe the login status and user information.

```swift
@StateObject var authManager = AuthManager.shared

var body: some View {
    if authManager.isLoggedIn {
        Text("User is logged in: \(authManager.user?.phoneNumber ?? "Unknown")")
    } else {
        Text("User is not logged in")
    }
}```

### Dependencies
    
FirebaseAuth: The Firebase Authentication library is used to handle the authentication processes.

### License

This project is licensed under the MIT License.
