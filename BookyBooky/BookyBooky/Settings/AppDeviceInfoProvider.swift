//
//  AppDeviceInfoProvider.swift
//  BookyBooky
//
//  Created by 김건우 on 7/29/23.
//

import DeviceKit
import Foundation

class AppDeviceInfoProvider {
    
    static let device = Device.current
    
    // 싱글톤(Singleton)
    let current = AppDeviceInfoProvider()
    
    private init() { }
    
    static var deviceName: String {
        return device.realDevice.description
    }
    
    static var deviceOS: String {
        return "\(device.systemName ?? "Unknown OS") \(device.systemVersion ?? "Unknown Version")"
    }
    
    static var deviceDiagonal: String {
        return "\(device.diagonal)인치"
    }
    
    static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    static var appBuild: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
}
