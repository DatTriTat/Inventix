//
//  AuthenticationViewModel.swift
//  Inventix
//
//  Created by Tri Tat on 5/7/24.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    var inventoryViewModel: InventoryViewModel
    
    init(inventoryViewModel: InventoryViewModel) {
        self.inventoryViewModel = inventoryViewModel
    }
    
    func registerUser(username: String, password: String, firstName: String, lastName: String, email: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://104.199.116.95:80/register") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        let registerDetails = ["username": username, "password": password, "firstName": firstName, "lastName": lastName, "email": email]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(registerDetails)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode user")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    completion(false)
                    return
                }
            
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }.resume()
    }
    
    func loginUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://104.199.116.95:80/login") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let loginDetails = ["username": username, "password": password]
        
        do {
            request.httpBody = try JSONEncoder().encode(loginDetails)
        } catch {
            print("Failed to encode login details")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Network or decoding error: \(error!.localizedDescription)")
                    completion(false)
                    return
                }
                
                do {
                    let userSession = try JSONDecoder().decode(User.self, from: data)
                    print("Login successful: \(userSession)")
                    SessionManager.shared.updateUserSession(with: userSession)
                    self.inventoryViewModel.loadUserData()
                    completion(true)
                } catch {
                    print("Failed to decode response: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }.resume()
    }
    func logOut() {
        SessionManager.shared.clearUserSession()
    }
    
}
