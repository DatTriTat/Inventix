//
//  SignUpView.swift
//  Inventix
//
//  Created by Tri Tat on 5/7/24.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @StateObject private var store = InventoryViewModel()

    @State private var firstname = ""
    @State private var lastname = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode

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
                    TextField("Enter first name", text: $firstname)
                        .frame(height: 45)
                        .padding(.leading, 10)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    TextField("Enter last name", text: $lastname)
                        .frame(height: 45)
                        .padding(.leading, 10)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    TextField("Enter your email", text: $email)
                        .frame(height: 45)
                        .padding(.leading, 10)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
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
                .padding(.vertical)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button {
                    isLoading = true
                    authenticationViewModel.registerUser(username: username, password: password, firstName: firstname, lastName: lastname, email: email) { success in
                        isLoading = false
                        if !success {
                            self.errorMessage = "Sign up failed. Please try again."
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Sign Up")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 52)
                .background(Color.accentColor)
                .clipShape(Capsule())
                
                Spacer()
                
                VStack {
                    Divider()
                    NavigationLink(destination: LoginView(authenticationViewModel: AuthenticationViewModel(inventoryViewModel: store))) {
                        HStack(spacing: 5) {
                            Text("Already have an account?")
                            Text("Login")
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
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(authenticationViewModel: AuthenticationViewModel(inventoryViewModel: InventoryViewModel()))
    }
}
