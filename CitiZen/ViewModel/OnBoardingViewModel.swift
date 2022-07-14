//
//  OnBoardingViewModel.swift
//  CitiZen
//
//  Created by Kenneth Widjaya on 12/07/22.
//

import Foundation

class OnBoardingViewModel: ObservableObject {
    
}

class LocalStorage {
    private static var myStorageUserBool: String = "myStorageUserBool"
    
    public static var myUserBool: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: myStorageUserBool)
        }
        get {
            return UserDefaults.standard.object(forKey: myStorageUserBool) as? Bool ?? false
        }
    }
    
    public static func removeValue() {
        self.myUserBool = false
    }
}
