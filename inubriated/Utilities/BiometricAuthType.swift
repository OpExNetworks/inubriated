//  BiometricAuthType.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import LocalAuthentication

enum BiometricTypes {
    case none
    case touchID
    case faceID
}

class BiometricAuthType {
    
    let context = LAContext()
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func biometricType() -> BiometricTypes {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            fatalError("Unknown BiometricType encountered")
        }
    }
    
    func isBiometric() -> Bool {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return false
        case .touchID, .faceID:
            return true
        @unknown default:
            fatalError("Unknown BiometricType encountered")
        }
    }
}

