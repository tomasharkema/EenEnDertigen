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
  
//  func without(index: Int) -> [Element] {
//    var newArray = [Element]()
//    newArray = self
//    newArray.removeAtIndex(index)
//    return newArray
//  }
}

extension Array where Element: Equatable {
  mutating func remove(el: Element) {
    self = self.filter { (element: Element) -> Bool in
      el != element
    }
  }
  
  func without(el: Element) -> Array<Element> {
    var newArray = self
    if let index = newArray.indexOf(el) {
      newArray.removeAtIndex(index)
    }
    return newArray
  }
  
  func without(el: Array<Element>) -> Array<Element> {
    var newArray = self
    
    for e in el {
      newArray = newArray.without(e)
    }
    
    return newArray
  }
}

extension Array where Element: Hashable {
  func without(el: Set<Element>) -> Array<Element> {
    var newArray = self
    
    for e in el {
      newArray.remove(e)
    }
    
    return newArray
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

func flatten(el: [[String: Int]]) -> [String: Int] {
  var newDict = [String: Int]()
  
  for e in el {
    for (k, v) in e {
      newDict[k] = (newDict[k] ?? 0) + v
    }
  }
  
  return newDict
}

extension Int {
  static func random(range: Range<Int> ) -> Int {
    var offset = 0
    
    if range.startIndex < 0   // allow negative ranges
    {
      offset = abs(range.startIndex)
    }
    
    let mini = UInt32(range.startIndex + offset)
    let maxi = UInt32(range.endIndex   + offset)
    
    return Int(mini + arc4random_uniform(maxi - mini)) - offset
  }
}