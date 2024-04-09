//
//  FaceIDViewModel.swift
//  Journal
//
//  Created by Brandon Johns on 4/9/24.
//

import Foundation
import LocalAuthentication
import SwiftUI


extension FaceIDAuthentication {
    
    class ViewModel: ObservableObject {
        var dataController: DataController
        
        init(dataController: DataController) {
            self.dataController = dataController
        }
        
        var isUnlocked = false
        
        var authenticationError = "Unknown error"
        var isShowingAuthenticationError = false
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."

                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in

                    if success {
                        self.isUnlocked = true
                    } else {
                        self.authenticationError = "There was a problem authenticating you; please try again."
                        self.isShowingAuthenticationError = true
                    }
                }
            } else {
                // no biometrics
                authenticationError = "Sorry, your device does not support biometric authentication."
                isShowingAuthenticationError = true
                
                
            }
        }
        
    }
}
