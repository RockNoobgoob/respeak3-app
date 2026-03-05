// ReSpeakApp.swift
// ReSpeak
//
// App entry point. Injects AuthService into the SwiftUI environment so that
// AppView, LoginView, and any future screen can observe authentication state.

import SwiftUI

@main
struct ReSpeakApp: App {

    /// AuthService is owned here at the app level so it persists across
    /// view tree rebuilds. All views read it via @EnvironmentObject.
    @StateObject private var auth = ServiceContainer.shared.auth

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(auth)
        }
    }
}
