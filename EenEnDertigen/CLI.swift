//
//  CLI.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 19-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

let Background = "44"
let TextColor = "39"

struct Position {
  let x: Int
  let y: Int
  
  var cliRep: String {
    return "\u{1B}[\(y);\(x)H"
  }
  
  func down(n: Int) -> Position {
    return Position(x: x, y: y+n)
  }
  
  func right(n: Int) -> Position {
    return Position(x: x+n, y: y)
  }
}

enum Color: String {
  case Red = "31"
  case Black = "30"
}

let ClearChar = "\u{1B}[2J"

func clear() {
  print(ClearChar)
}

func setBackground() {
  print("\u{1B}[\(TextColor);\(Background);m")
}

func print(pos: Position, string: String) {
  print("\u{001B}[\(TextColor);\(Background);m\(pos.cliRep)\(string)")
}

infix operator >>> {}

func >>>(lhs: Position, rhs: String) {
  print(lhs, string: rhs)
}

func >>>(color: Color, string: String) -> String {
  return "\u{001B}[47;\(color.rawValue)m\(string)\u{001B}[\(TextColor);\(Background)m"
}

