//
//  AuthContainerView.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 16/12/25.
//

import SwiftUI

struct AuthContainerView: View {
    @Environment(AuthViewModel.self) private var viewModel
    @State private var showRegister = false

    var body: some View {
        ZStack {
            // Login Screen
            LoginContentView(showRegister: $showRegister)
                .offset(x: showRegister ? -UIScreen.main.bounds.width : 0)
                .opacity(showRegister ? 0 : 1)

            // Register Screen
            RegisterContentView(showRegister: $showRegister)
                .offset(x: showRegister ? 0 : UIScreen.main.bounds.width)
                .opacity(showRegister ? 1 : 0)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showRegister)
    }
}

// MARK: - Login Content View

struct LoginContentView: View {
    @Environment(AuthViewModel.self) private var viewModel
    @Binding var showRegister: Bool
    @FocusState private var focusedField: LoginField?

    enum LoginField: Hashable {
        case email, password
    }

    var body: some View {
        @Bindable var vm = viewModel

        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header with Logo
                    VStack(spacing: 16) {
                        Image(systemName: "book.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.blue.gradient)
                            .symbolEffect(.pulse, options: .repeating)

                        VStack(spacing: 4) {
                            Text("Bienvenido")
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Text("Inicia sesión para continuar")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 40)

                    // Form Section
                    VStack(spacing: 20) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Correo electrónico")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)

                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .foregroundStyle(.secondary)
                                    .frame(width: 20)

                                TextField("nombre@ejemplo.com", text: $vm.email)
                                    .textContentType(.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                                    .focused($focusedField, equals: .email)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .password
                                    }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(focusedField == .email ? Color.blue : Color.clear, lineWidth: 2)
                            }
                        }

                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contraseña")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)

                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(.secondary)
                                    .frame(width: 20)

                                SecureField("Introduce tu contraseña", text: $vm.password)
                                    .textContentType(.password)
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.go)
                                    .onSubmit {
                                        if viewModel.canLogin {
                                            Task { await viewModel.login() }
                                        }
                                    }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(focusedField == .password ? Color.blue : Color.clear, lineWidth: 2)
                            }
                        }

                        // Error Message
                        if let error = viewModel.error {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.red)
                                    .imageScale(.small)

                                Text(error)
                                    .font(.footnote)
                                    .foregroundStyle(.red)

                                Spacer()

                                Button {
                                    viewModel.clearError()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                        .imageScale(.small)
                                }
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        // Login Button
                        Button {
                            focusedField = nil
                            Task { await viewModel.login() }
                        } label: {
                            HStack(spacing: 8) {
                                if viewModel.state == .authenticating {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                } else {
                                    Text("Iniciar Sesión")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(viewModel.canLogin ? Color.blue : Color.gray)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(!viewModel.canLogin || viewModel.state == .authenticating)
                        .padding(.top, 8)

                        // Divider
                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color(.systemGray4))

                            Text("o")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 8)

                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color(.systemGray4))
                        }
                        .padding(.vertical, 8)

                        // Register Button
                        Button {
                            focusedField = nil // Dismiss keyboard first
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    showRegister = true
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "person.badge.plus")
                                Text("Crear cuenta nueva")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(.systemGray6))
                            .foregroundStyle(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                focusedField = nil // Dismiss keyboard on tap outside
            }
            .onAppear {
                if !showRegister {
                    focusedField = .email
                }
            }
        }
    }
}

// MARK: - Register Content View

struct RegisterContentView: View {
    @Environment(AuthViewModel.self) private var viewModel
    @Binding var showRegister: Bool
    @FocusState private var focusedField: RegisterField?

    enum RegisterField: Hashable {
        case email, password, confirmPassword
    }

    var body: some View {
        @Bindable var vm = viewModel

        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .foregroundStyle(.blue.gradient)
                            .symbolEffect(.bounce, value: viewModel.state)

                        VStack(spacing: 4) {
                            Text("Crear cuenta")
                                .font(.title)
                                .fontWeight(.bold)

                            Text("Únete a la comunidad de lectores")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 32)

                    // Form Section
                    VStack(spacing: 20) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Correo electrónico")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)

                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .foregroundStyle(.secondary)
                                    .frame(width: 20)

                                TextField("nombre@ejemplo.com", text: $vm.email)
                                    .textContentType(.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                                    .focused($focusedField, equals: .email)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .password
                                    }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(borderColor(for: .email), lineWidth: 2)
                            }

                            // Email validation feedback
                            if !viewModel.email.isEmpty {
                                ValidationRow(
                                    isValid: viewModel.isValidEmail,
                                    message: viewModel.isValidEmail ? "Email válido" : "Formato de email inválido"
                                )
                            }
                        }

                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contraseña")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)

                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(.secondary)
                                    .frame(width: 20)

                                SecureField("Mínimo 8 caracteres", text: $vm.password)
                                    .textContentType(.newPassword)
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .confirmPassword
                                    }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(borderColor(for: .password), lineWidth: 2)
                            }

                            // Password validation feedback
                            if !viewModel.password.isEmpty {
                                ValidationRow(
                                    isValid: viewModel.isValidPassword,
                                    message: viewModel.isValidPassword ? "Contraseña válida" : "Mínimo 8 caracteres"
                                )
                            }
                        }

                        // Confirm Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirmar contraseña")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)

                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(.secondary)
                                    .frame(width: 20)

                                SecureField("Repite tu contraseña", text: $vm.confirmPassword)
                                    .textContentType(.newPassword)
                                    .focused($focusedField, equals: .confirmPassword)
                                    .submitLabel(.go)
                                    .onSubmit {
                                        if viewModel.canRegister {
                                            focusedField = nil
                                            Task { await viewModel.register() }
                                        }
                                    }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(borderColor(for: .confirmPassword), lineWidth: 2)
                            }

                            // Password match validation
                            if !viewModel.confirmPassword.isEmpty {
                                ValidationRow(
                                    isValid: viewModel.passwordsMatch,
                                    message: viewModel.passwordsMatch ? "Las contraseñas coinciden" : "Las contraseñas no coinciden"
                                )
                            }
                        }

                        // Error Message
                        if let error = viewModel.error {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.red)
                                    .imageScale(.small)

                                Text(error)
                                    .font(.footnote)
                                    .foregroundStyle(.red)

                                Spacer()

                                Button {
                                    viewModel.clearError()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                        .imageScale(.small)
                                }
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        // Register Button
                        Button {
                            focusedField = nil
                            Task {
                                await viewModel.register()
                            }
                        } label: {
                            HStack(spacing: 8) {
                                if viewModel.state == .authenticating {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Crear cuenta")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(viewModel.canRegister ? Color.blue : Color.gray)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(!viewModel.canRegister || viewModel.state == .authenticating)
                        .padding(.top, 8)

                        // Terms Text
                        Text("Al crear una cuenta, aceptas nuestros términos de servicio y política de privacidad")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                focusedField = nil // Dismiss keyboard on tap outside
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        focusedField = nil // Dismiss keyboard
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                showRegister = false
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                            Text("Atrás")
                        }
                    }
                }
            }
            .onAppear {
                if showRegister {
                    focusedField = .email
                }
            }
        }
    }

    // MARK: - Helper Functions

    private func borderColor(for field: RegisterField) -> Color {
        guard focusedField == field else { return .clear }

        switch field {
        case .email:
            return viewModel.email.isEmpty ? .blue : (viewModel.isValidEmail ? .green : .red)
        case .password:
            return viewModel.password.isEmpty ? .blue : (viewModel.isValidPassword ? .green : .red)
        case .confirmPassword:
            return viewModel.confirmPassword.isEmpty ? .blue : (viewModel.passwordsMatch ? .green : .red)
        }
    }
}

#Preview {
    AuthContainerView()
        .environment(AuthViewModel(
            repository: AuthRepository(
                tokenManager: TokenManager(keychainService: KeychainService())
            ),
            keychainService: KeychainService()
        ))
}
