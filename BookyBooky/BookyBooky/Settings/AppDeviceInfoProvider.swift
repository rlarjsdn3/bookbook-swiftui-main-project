//
//  AppDeviceInfoProvider.swift
//  BookyBooky
//
//  Created by 김건우 on 7/29/23.
//

import DeviceKit
import Foundation

class AppDeviceInfoProvider {
    
    let device = Device.current
    
    // 싱글톤(Singleton)
    static let current = AppDeviceInfoProvider()
    
    private init() { }
    
    var deviceName: String {
        return device.realDevice.description
    }
    
    var deviceOS: String {
        return "\(device.systemName ?? "Unknown OS") \(device.systemVersion ?? "Unknown Version")"
    }
    
    var deviceDiagonal: String {
        return "\(device.diagonal)인치"
    }
    
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var appBuild: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
}
