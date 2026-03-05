// LoginView.swift
// ReSpeak
//
// Login screen for clinicians and patients. Calls AuthService.signIn()
// via Supabase Auth. On success, AppView's session listener reroutes
// automatically to MainTabView.

import SwiftUI

// MARK: - LoginView

struct LoginView: View {

    @EnvironmentObject private var auth: AuthService

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @FocusState private var focusedField: Field?

    private enum Field { case email, password }

    var body: some View {
        ZStack(alignment: .top) {
            BrandGradients.backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    heroHeader
                    formCard
                        .padding(.horizontal, Spacing.screenHorizontal)
                        .offset(y: -Radii.sheet)
                    footerNote
                        .padding(.top, Spacing.md)
                        .padding(.bottom, Spacing.xxl)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }

    // MARK: - Hero Header

    private var heroHeader: some View {
        ZStack {
            BrandGradients.heroGradient
                .ignoresSafeArea(edges: .top)

            VStack(spacing: Spacing.sm) {
                Spacer(minLength: Spacing.xxxl)

                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 84, height: 84)

                    Image(systemName: "waveform.circle.fill")
                        .font(.system(size: 52, weight: .light))
                        .foregroundStyle(BrandColors.onPrimary)
                }

                VStack(spacing: Spacing.xxs) {
                    Text("ReSpeak")
                        .font(BrandTypography.largeTitle)
                        .foregroundStyle(BrandColors.onPrimary)

                    Text("Speech Therapy Platform")
                        .font(BrandTypography.subheadline)
                        .foregroundStyle(BrandColors.onPrimary.opacity(0.75))
                }

                Spacer(minLength: Spacing.xxl + Radii.sheet)
            }
        }
        .frame(minHeight: 300)
    }

    // MARK: - Form Card

    private var formCard: some View {
        VStack(spacing: Spacing.lg) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Welcome back")
                    .font(BrandTypography.title2)
                    .foregroundStyle(BrandColors.onBackground)

                Text("Sign in to continue your session")
                    .font(BrandTypography.subheadline)
                    .foregroundStyle(BrandColors.onBackgroundSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: Spacing.sm) {
                BrandTextField(
                    placeholder: "Email address",
                    systemImage: "envelope",
                    text: $email,
                    keyboardType: .emailAddress,
                    contentType: .emailAddress
                )
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }

                BrandSecureField(
                    placeholder: "Password",
                    text: $password,
                    isVisible: $isPasswordVisible
                )
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                .onSubmit { handleSignIn() }
            }

            HStack {
                Spacer()
                Button("Forgot password?") { }
                    .font(BrandTypography.footnote)
                    .foregroundStyle(BrandColors.secondary)
            }

            // Error banner
            if let errorMessage = auth.authError {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(BrandColors.error)

                    Text(errorMessage)
                        .font(BrandTypography.footnote)
                        .foregroundStyle(BrandColors.error)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()
                }
                .padding(Spacing.sm)
                .background(BrandColors.error.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: Radii.input))
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.input)
                        .stroke(BrandColors.error.opacity(0.3), lineWidth: 1)
                )
            }

            Button(action: handleSignIn) {
                ZStack {
                    if auth.isLoading {
                        ProgressView()
                            .tint(BrandColors.onPrimary)
                    } else {
                        Text("Sign In")
                            .font(BrandTypography.button)
                            .foregroundStyle(BrandColors.onPrimary)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    auth.isLoading
                        ? AnyShapeStyle(BrandColors.disabled)
                        : AnyShapeStyle(BrandGradients.buttonGradient)
                )
                .clipShape(RoundedRectangle(cornerRadius: Radii.button))
            }
            .disabled(auth.isLoading || email.isEmpty || password.isEmpty)
            .cardShadow()
        }
        .padding(Spacing.xl)
        .background(BrandColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: Radii.sheet))
        .floatingShadow()
    }

    // MARK: - Footer

    private var footerNote: some View {
        Text("Access is provided by your clinic. Contact your care coordinator to create an account.")
            .font(BrandTypography.caption1)
            .foregroundStyle(BrandColors.onBackgroundSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, Spacing.xl)
    }

    // MARK: - Actions

    private func handleSignIn() {
        focusedField = nil
        Task {
            await auth.signIn(email: email, password: password)
        }
    }
}

// MARK: - BrandTextField

private struct BrandTextField: View {
    let placeholder: String
    let systemImage: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var contentType: UITextContentType? = nil

    var body: some View {
        HStack(spacing: Spacing.iconLabelGap) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(BrandColors.onBackgroundSecondary)
                .frame(width: 20)

            TextField(placeholder, text: $text)
                .font(BrandTypography.body)
                .foregroundStyle(BrandColors.onBackground)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(BrandColors.surfaceVariant)
        .clipShape(RoundedRectangle(cornerRadius: Radii.input))
        .overlay(
            RoundedRectangle(cornerRadius: Radii.input)
                .stroke(BrandColors.border, lineWidth: 1)
        )
    }
}

// MARK: - BrandSecureField

private struct BrandSecureField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool

    var body: some View {
        HStack(spacing: Spacing.iconLabelGap) {
            Image(systemName: "lock")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(BrandColors.onBackgroundSecondary)
                .frame(width: 20)

            Group {
                if isVisible {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } else {
                    SecureField(placeholder, text: $text)
                }
            }
            .font(BrandTypography.body)
            .foregroundStyle(BrandColors.onBackground)

            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye.slash" : "eye")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(BrandColors.onBackgroundSecondary)
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(BrandColors.surfaceVariant)
        .clipShape(RoundedRectangle(cornerRadius: Radii.input))
        .overlay(
            RoundedRectangle(cornerRadius: Radii.input)
                .stroke(BrandColors.border, lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview {
    LoginView()
        .environmentObject(AuthService())
}
