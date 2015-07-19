//
//  Positions.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 19-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

struct Position {
  let x: Int
  let y: Int
  
  var cliRep: String {
    return "\u{1B}[\(y);\(x)H"
  }
  
  func down(n: Int) -> Position {
    return Position(x: x, y: y+n)
  }
}

let HeaderPosition = Position(x: 0, y: 0)
let TafelPosition = Position(x: 20, y: 0)
let StatusPosition = Position(x: 100, y: 10)
let VerliezerPosition = Position(x: 50, y: 10)
let InputPosition = Position(x: 0, y: 20)