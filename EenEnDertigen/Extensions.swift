//
//  Extensions.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 18-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

let Test = NSProcessInfo.processInfo().environment["TEST"] != nil

extension Array {
  mutating func shuffle() {
    for i in 0..<(count - 1) {
      let j = Int(arc4random_uniform(UInt32(count - i))) + i
      swap(&self[i], &self[j])
    }
  }
  
  func without(index: Int) -> [Element] {
    var newArray = [Element]()
    
    for (elIndex, el) in self.enumerate() {
      if index != elIndex {
        newArray.append(el)
      }
    }
    
    return newArray
  }
}

extension Array where Element: Equatable {
  mutating func remove(el: Element) {
    self = self.filter({ (element: Element) -> Bool in
      el != element
    })
  }
}

extension Set where Element: Equatable {
  func without(el: Element) -> Set<Element> {
    var newArray = Set<Element>()
    
    for obj in self {
      if el != obj {
        newArray.insert(obj)
      }
    }
    
    return newArray
  }
}