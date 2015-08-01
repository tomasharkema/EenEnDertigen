//
//  SynchronizedArray.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 31-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

class SynchronizedArray<T> {
  private var array: [T] = []
  private let accessQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
  
  init () {}
  init (el: [T]) {
    array = el
  }
  
  func append(newElement: T) {
    dispatch_async(accessQueue) {
      self.array.append(newElement)
    }
  }
  
  subscript(index: Int) -> T {
    set {
      dispatch_async(self.accessQueue) {
        self.array[index] = newValue
      }
    }
    get {
      var element: T!
      
      dispatch_sync(self.accessQueue) {
        element = self.array[index]
      }
      
      return element
    }
  }
  
  func toArray() -> [T] {
    var array: [T] = [T]()
    
    dispatch_sync(accessQueue) {
      array = self.array
    }
    
    return array
  }
}

extension Array {
  func toSyncedArray() -> SynchronizedArray<Element> {
    return SynchronizedArray(el: self)
  }
}