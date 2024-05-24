//
//  ProfileView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/5/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var store = InventoryViewModel()
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    init(authenticationViewModel: AuthenticationViewModel) {
            self._authenticationViewModel = ObservedObject(wrappedValue: authenticationViewModel)
        }
    var body: some View {
        Form {
            Section("User Information") {
                HStack(alignment: .top) {
                    AsyncImage(url: URL(string: "https://res.cloudinary.com/glide/image/fetch/t_media_lib_thumb/https%3A%2F%2Fstorage.googleapis.com%2Fglide-prod.appspot.com%2Fuploads-v2%2FYGvI36VoQe5mJNelMBS1-template-builder%2Fpub%2F8ijk5Xchy5qkOz4fHEy6.png")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } placeholder: {
                        ProgressView()
                    }
                    VStack(alignment: .leading) {
                        Text("\(SessionManager.shared.currentUserSession!.firstName) \(SessionManager.shared.currentUserSession!.lastName)")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(verbatim: "\(SessionManager.shared.currentUserSession!.email)")
                            .foregroundStyle(.gray)
                    }
                }
                .listRowBackground(Color.customSection)

            }
            
            Section("Settings") {
                Toggle("Daily Expired Reminder", isOn: $store.isScheduled)
                    .tint(Color.accentColor)
                
                if store.isScheduled {
                    DatePicker("Time", selection: $store.timeScheduled, displayedComponents: .hourAndMinute)
                }
            }
            .listRowBackground(Color.customSection)
            
            
            Button("Sign out", role: .destructive) {
                authenticationViewModel.logOut()
            }
            .listRowBackground(Color.customSection)
        }
        .onChange(of: store.timeScheduled) {
            UserDefaults.standard.set(store.timeScheduled.timeIntervalSince1970, forKey: "timeScheduled")
        }
        .scrollContentBackground(.hidden)
        .background(Color.background)
        
    }
}

#Preview {
    ProfileView(authenticationViewModel: AuthenticationViewModel(inventoryViewModel: InventoryViewModel()))
        .environmentObject(InventoryViewModel())
}
