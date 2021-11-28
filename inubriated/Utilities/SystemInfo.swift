//  SystemInfo.swift
//  inubriated
//
//  Created by David Holeman on 6/1/21
//  Copyright © 2021 OpExNetworks. All rights reserved.
//

import Foundation

class SystemInfo {
    static var os: String {
        let iOS = ProcessInfo().operatingSystemVersion
        return String(format: "%@.%@.%@", String(iOS.majorVersion), String(iOS.minorVersion), String(iOS.patchVersion))
    }
    static var osMajorVersion: String {
        let iOS = ProcessInfo().operatingSystemVersion
        return String(iOS.majorVersion)
    }
    static var deviceCode: String {
        var sysInfo = utsname()
        uname(&sysInfo)
        let modelCode = withUnsafePointer(to: &sysInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        /*
        let nodename = withUnsafePointer(to: &sysInfo.nodename) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        print(nodename as Any)
        let sysname = withUnsafePointer(to: &sysInfo.sysname) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        print(sysname as Any)
        let release = withUnsafePointer(to: &sysInfo.release) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        print(release as Any)
        */
        return modelCode ?? "Unknown"
    }
}

