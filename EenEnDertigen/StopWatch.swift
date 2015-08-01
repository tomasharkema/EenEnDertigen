//
//  StopWatch.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 01-08-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

class StopWatch {
  private var startDate: NSDate!
  
  init() {}
  
  func start() {
    startDate = NSDate()
  }
  
  func getLap() -> Double {
    return abs(startDate.timeIntervalSinceNow)
  }
}