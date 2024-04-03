//
//  AuthService.swift
//  KitDeneme
//
//  Created by Ozan Özkan on 13.03.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
class AuthService {
    
    public static let shared = AuthService()
    
    private init() {}
    
    ///  A method to register the user
    ///  - Parameters:
    ///    - userRequest: the users information (email, password, username)
    ///    - completion: A completion with two values...
    ///    - Bool: wasRegistered - Determines if the user was registered and saved in the database correctly
    ///    - Error?: An optional error if firebase provides one
    
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
        
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            
            let db = Firestore.firestore()
            
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "username": username,
                    "email": email,
                    "balance": 25
                    
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    completion(true, nil)
                }
        }
    }
    
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
                // sign in success
                completion(nil)
            }
        }
    }
    
    public func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            
        } catch let error {
            completion(error)
        }
    }
    
    public func forgotPassword(with email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    public func fetchUser(completion: @escaping (User?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let snapshot = snapshot,
                   let snapshotData = snapshot.data(),
                   let username = snapshotData["username"] as? String,
                   let balance = snapshotData["balance"] as? Double,
                   let email = snapshotData["email"] as? String {
                    let user = User(username: username, email: email, userUID: userUID, balance: balance)
                    completion(user, nil)
                }
            }
    }
    
    public func sendEmailVerification(completion: @escaping (Bool, Error?) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            currentUser.sendEmailVerification { error in
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        } else {
            // No current user found
            completion(false, NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"]))
        }
    }
    
    public func deleteUserData(forUserID userUID: String, completion: @escaping (Error?) -> Void) {
        
        
        let db = Firestore.firestore()
        
        
        db.collection("users").document(userUID).delete { error in
            if let error = error {
                print("error removing doc")
            } else {
                print("doc removed")
            }
        }
        
        
    }
}
