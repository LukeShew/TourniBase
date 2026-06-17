# TourniBase iOS Mockup

This folder contains a native SwiftUI mockup of the TourniBase mobile app.

## Included Flows

- Three-step onboarding and role selection
- Spectator home, event discovery, admission purchase, and digital pass wallet
- Coach team readiness, guardian status, reminders, and event schedule
- Tournament director revenue dashboard, event operations, venue status, and pass scanner
- Demo role switching from the profile screen
- Mock checkout, scan results, notifications, family wallet, and Apple Wallet states

The mockup uses local sample data. It does not connect to Supabase, payments, cameras, Apple Wallet, or live tournament services yet.

## Requirements

- Xcode with an iOS Simulator runtime
- iOS 17 or later

## Run The App

1. Install Xcode from the Mac App Store.
2. Open Xcode once and allow it to install required components.
3. Open `TourniBase.xcodeproj`.
4. Select the `TourniBase` scheme.
5. Choose an iPhone simulator.
6. Press the Run button.

If Terminal still points to Command Line Tools after Xcode is installed, run:

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

Then verify:

```bash
xcodebuild -version
xcrun simctl list devices
```

## Project Details

- Bundle identifier: `com.tournibase.app`
- Deployment target: iOS 17
- Framework: SwiftUI
- External dependencies: none
