//
//  LocationManager.swift
//  定位工具类的封装
//
//  Created by xiaomage on 16/4/15.
//  Copyright © 2017年 何宗江. All rights reserved.
//

import CoreLocation

typealias LocationResult = (_ location: CLLocation?, _ status: CLAuthorizationStatus, _ error: Error?) -> ()

class LocationManager: NSObject {

    /// 单例
    static let shared = LocationManager()
    
    fileprivate override init() { super.init() }
    
    /// 是否只定位一次
    fileprivate var atOnce: Bool = false
    
    /// 定位结果回调
    fileprivate var resultBlock: LocationResult?
    
    /// 定位授权状态
    fileprivate var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    /// 定位管理者
    fileprivate lazy var locationManager: CLLocationManager = {
       
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        
        // 请求授权
        if #available(iOS 8.0, *) {
            
            guard let infoDic = Bundle.main.infoDictionary else { return locationManager }
            
            let whenInUse = infoDic["NSLocationWhenInUseUsageDescription"]
            
            let always = infoDic["NSLocationAlwaysUsageDescription"]
            
            if let backgroundModes = infoDic["UIBackgroundModes"] as? [String], backgroundModes.contains("location"), #available(iOS 9.0, *) {
                
                locationManager.allowsBackgroundLocationUpdates = true
            }
            
            if always != nil {
                
                locationManager.requestAlwaysAuthorization()
                
            } else if whenInUse != nil {
                
                locationManager.requestWhenInUseAuthorization()
                
            } else {
                
//                let exception = NSException(name: NSExceptionName(rawValue: ""), reason: "在ios8.0以后,想要使用用户位置,难道不知道要主动请求授权吗? 你应该, 在info.plist 配置NSLocationWhenInUseUsageDescription 或者 NSLocationAlwaysUsageDescription", userInfo: nil)
//                exception.raise()
                
                print("错误提示：在 iOS8.0 以后，想要使用用户位置，要主动请求授权。应该在 info.plist 配置NSLocationWhenInUseUsageDescription 或者 NSLocationAlwaysUsageDescription")
            }
        }
        return locationManager
    }()
    
    /// 获取当前位置
    ///
    /// - Parameters:
    ///   - atOnce: 是否只定位一次，若为 true，则定位一次后就停止定位
    ///   - resultBlock: 位置信息
    func startUpdatingLocation(atOnce: Bool, resultBlock: @escaping LocationResult) -> () {
        
        self.atOnce = atOnce
        
        self.resultBlock = resultBlock
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.startMonitoringSignificantLocationChanges()
            
            locationManager.startUpdatingLocation()
        }else {
            
            self.resultBlock?(nil, CLAuthorizationStatus.denied, nil)
        }
    }
    
    /// 停止定位
    func stopUpdatingLocation() {
        
        locationManager.stopUpdatingLocation()
        
        locationManager.stopMonitoringSignificantLocationChanges()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        resultBlock?(nil, authorizationStatus, error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard locations.count > 0, let location = locations.last else {
            resultBlock?(nil, authorizationStatus, nil)
            return
        }
        
        resultBlock?(location, authorizationStatus, nil)
        
        if atOnce {
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        authorizationStatus = status
        locationManager(locationManager, didUpdateLocations: [])
    }
}
