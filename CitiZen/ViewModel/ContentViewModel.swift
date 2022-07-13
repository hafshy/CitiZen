//
//  AuthtenticationVM.swift
//  CitiZen
//
//  Created by Kenneth Widjaya on 13/07/22.
//

import Foundation

class AuthtenticationVM: ObservableObject {
    @Published var userSession = LocalStorage.myUserBool
    
    static let shared = AuthtenticationVM()
    
}
