//
//  LoginView.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 16/12/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) private var viewModel
    @State private var showRegister = false
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case email, password
    }

    var body: some View {
        @Bindable var vm = viewModel

        NavigationStack {
            
            ZStack {
                
                PastelCloudMesh()
                
                ScrollView {
                    VStack(spacing: 0) {
                        
                        // Header with Logo
                        VStack(spacing: 16) {
                            Image(systemName: "hand.wave.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.white)
                                .symbolEffect(.wiggle, options: .repeating)
                            
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
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                                            .stroke(.white.opacity(0.25), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.10), radius: 20, x: 0, y: 12)
                                    .padding(.horizontal,10)
                              

                            
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
                                            .onChange(of: vm.email) { oldValue, newValue in
                                                let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                                                if trimmed != newValue {
                                                    vm.email = trimmed
                                                }
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
                                            .tint(.blue)
                                            .foregroundStyle(.primary)
                                            .onSubmit {
                                                if viewModel.canLogin {
                                                    Task { await viewModel.login() }
                                                }
                                            }
                                            .onChange(of: vm.password) { oldValue, newValue in
                                                let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                                                if trimmed != newValue {
                                                    vm.password = trimmed
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
                                    .foregroundStyle(.ultraThinMaterial)
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
                                    focusedField = nil
                                    showRegister = true
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
                            }
                            .padding(  24)
                        }
                        
                        Spacer(minLength: 40)
                    }
                    
                }
                //.background(Color(.systemBackground))
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showRegister) {
                    RegisterView()
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                }
                .onAppear {
                    focusedField = .email
                }
            }
        }
    }
}

struct PastelCloudMesh: View {
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                // top row (borde superior completamente anclado)
                .init(0.0, 0.0), .init(0.5, 0.0), .init(1.0, 0.0),

                // centro (zona de mezcla)
                .init(0.0, 0.5), .init(0.5, 0.5), .init(1.0, 0.5),

                // bottom row
                .init(0.0, 1.0), .init(0.5, 1.0), .init(1.0, 1.0),
            ],
            colors: [
                // top: azul → blanco azulado (⚠️ no blanco puro)
                Color(red: 0.56, green: 0.74, blue: 0.98),
                Color(red: 0.63, green: 0.78, blue: 0.98),
                Color(red: 0.86, green: 0.90, blue: 0.96),

                // middle: transición suave
                Color(red: 0.72, green: 0.82, blue: 0.95),
                Color(red: 0.84, green: 0.90, blue: 0.92),
                Color(red: 0.78, green: 0.88, blue: 0.88),

                // bottom: blanco frío → verde agua
                Color(red: 0.90, green: 0.93, blue: 0.96),
                Color(red: 0.78, green: 0.90, blue: 0.88),
                Color(red: 0.53, green: 0.74, blue: 0.70),
            ]
        )
        .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel(
            repository: AuthRepository(
                tokenManager: TokenManager(keychainService: KeychainService())
            ),
            keychainService: KeychainService()
        ))
}
