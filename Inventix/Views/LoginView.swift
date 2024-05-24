//
//  LoginView.swift
//  RoutePlanner
//
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @StateObject private var store = InventoryViewModel()

    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.vertical)
            
                VStack {
                    TextField("Enter user name", text: $username)
                        .frame(height: 45)
                        .padding(.leading, 10)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    SecureField("Enter your password", text: $password)
                        .frame(height: 45)
                        .padding(.leading, 10)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Text("Forgot Password?")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(Color.accentColor)
                    .padding(.vertical)
                
                Button {
                    isLoading = true
                    authenticationViewModel.loginUser(username: username, password: password) { success in
                        isLoading = false
                        if !success {
                            self.errorMessage = "Authentication failed. Check your credentials and try again."
                        }
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Login")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 52)
                .foregroundStyle(.white)
                .background(Color.accentColor)
                .clipShape(Capsule())
                
                Spacer()
                
                VStack {
                    Divider()
                    NavigationLink {
                        SignUpView(authenticationViewModel: AuthenticationViewModel(inventoryViewModel: store))
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack(spacing: 5) {
                            Text("Don't have an account?")
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .padding(.top, 10)
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .background(Color.background)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authenticationViewModel: AuthenticationViewModel(inventoryViewModel: InventoryViewModel()))
    }
}
