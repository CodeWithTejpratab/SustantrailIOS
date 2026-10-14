//
//  LoginView.swift
//  SustantrailIOS
//
//  Created by Rahul Ramjeawon on 9/12/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(.welcomemessage)
                    .resizable()
                    .scaledToFit()
                
                Image(.loginimagenobg)
                    .resizable()
                    .scaledToFit()
                
                VStack(spacing: 16) {
                    InfoTextField(
                        username: $viewModel.username,
                        showError: viewModel.showError,
                        onChange: viewModel.onUsernameChange
                    )
                    
                    PasswordTextFeild(
                        password: $viewModel.password,
                        showError: viewModel.showError,
                        onChange: viewModel.onPasswordChange
                    )
                }
                .padding(.horizontal, 32)
                
                Button(action: viewModel.onClick) {
                    Text(K.textLoginViewLogin)
                        .font(.PoppinsRegular)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(Color(hex: K.Color.green))
                        .cornerRadius(15)
                }.padding(.horizontal, 32)
                
                HStack {
                    Text(K.textLoginViewRegister)
                        .font(.PoppinsRegular)
                        .fontWeight(.regular)
                    
                    Button(action: viewModel.onSignUpClick) {
                        Text(K.textLoginViewSignUp)
                            .font(.PoppinsRegular)
                    }
                }
            }
            .padding(30)
        }
    }
}

struct InfoTextField: View {
    @Binding var username: String
    var showError: Bool = false
    var onChange: (String) -> Void
    
    var body: some View {
        TextField(K.textLoginViewUsername, text: $username)
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(showError ? Color.red : Color.clear, lineWidth: 1.5)
            )
            .onChange(of: username) { _, newValue in
                onChange(newValue)
            }
    }
}

struct PasswordTextFeild: View {
    @Binding var password: String
    var showError: Bool = false
    var onChange: (String) -> Void
    
    @State private var isPasswordVisible = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isPasswordVisible {
                    TextField(K.textLoginViewPassword, text: $password)
                } else {
                    SecureField(K.textLoginViewPassword, text: $password)
                }
            }
            .textFieldStyle(.roundedBorder)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(showError ? Color.red : Color.clear, lineWidth: 1.5)
            )
            .onChange(of: password) { _, newValue in
                onChange(newValue)
            }
            
            Button {
                isPasswordVisible.toggle()
            } label: {
                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 12)
            .accessibilityLabel(isPasswordVisible ? "Hide password" : "Show password")
        }
    }
}

#Preview {
    LoginView()
}

