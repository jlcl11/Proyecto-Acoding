//
//  RegisterView.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 16/12/25.
//

import SwiftUI

struct RegisterView: View {
    @Environment(AuthViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
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
                                    .tint(.blue)
                                    .foregroundStyle(.primary)
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
                                    .tint(.blue)
                                    .foregroundStyle(.primary)
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
                                    .tint(.blue)
                                    .foregroundStyle(.primary)
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
                                if viewModel.isAuthenticated {
                                    dismiss()
                                }
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
            .navigationTitle("Crear cuenta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                focusedField = .email
            }
        }
    }

    // MARK: - Helper Functions

    private func borderColor(for field: Field) -> Color {
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

// MARK: - Supporting Views

struct ValidationRow: View {
    let isValid: Bool
    let message: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(isValid ? .green : .red)
                .imageScale(.small)

            Text(message)
                .font(.caption)
                .foregroundStyle(isValid ? .green : .red)

            Spacer()
        }
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}

#Preview {
    RegisterView()
        .environment(AuthViewModel(
            repository: AuthRepository(
                tokenManager: TokenManager(keychainService: KeychainService())
            ),
            keychainService: KeychainService()
        ))
}
