//
//  ViewController.swift
//  LocationDemo
//
//  Created by he on 2017/8/26.
//  Copyright © 2017年 hezongjiang. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    fileprivate lazy var geocoder: CLGeocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
       
        LocationManager.shared.startUpdatingLocation(atOnce: false) { (location, status, error) in
        
            if status == CLAuthorizationStatus.notDetermined {
                print("用户还未决定是否能定位")
                return
            } else if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
                print("定位功能不可用")
                return
            } else if let location = location {
                print(location)
            }
            
        }
    }


}

