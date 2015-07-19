//
//  Cards.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 18-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

enum Symbool: Character {
  case Ruiten = "♣"
  case Schoppen = "♠"
  case Klaver = "♦"
  case Harten = "♥"
}

let AllSymbols: [Symbool] = [.Ruiten, .Schoppen, .Klaver, .Harten]

struct Variant {
  let representation: String
  let punt: Int
}

enum Nummer: String {
  case Aas = "A"
  case Heer = "H"
  case Vrouw = "V"
  case Boer = "B"
  case Tien = "10"
  case Negen = "9"
  case Acht = "8"
  case Zeven = "7"
  
  var points: Int {
    switch self {
    case .Aas:
      return 11
    case .Heer, .Vrouw, .Boer, .Tien:
      return 10
    default:
      return Int(self.rawValue)!
    }
  }
}

let AllNummers: [Nummer] = [.Aas, .Heer, .Vrouw, .Boer, .Tien, .Negen, .Acht, .Zeven]

struct Kaart: CustomStringConvertible, Equatable {
  let symbool: Symbool
  let nummer: Nummer
  
  var description: String {
    return "\(symbool.rawValue)\(nummer.rawValue)"
  }
}

func ==(lhs: Kaart, rhs: Kaart) -> Bool {
  return lhs.nummer == rhs.nummer && lhs.symbool == lhs.symbool
}
