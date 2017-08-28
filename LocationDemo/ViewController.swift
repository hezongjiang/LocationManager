//
//  ViewController.swift
//  LocationDemo
//
//  Created by he on 2017/8/26.
//  Copyright © 2017年 hezongjiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        LocationManager.shared.startUpdatingLocation(atOnce: false) { (location, status, error) in
            print(location)
            print(status.rawValue)
        }
        
    }


}

