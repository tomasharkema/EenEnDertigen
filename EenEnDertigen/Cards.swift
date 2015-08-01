//
//  Cards.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 18-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

enum Symbool {
  case Ruiten
  case Schoppen
  case Klaver
  case Harten
  
  var color: Color {
    switch self {
    case .Klaver, .Schoppen:
      return .Black
    case .Ruiten, .Harten:
      return .Red
    }
  }
  
  var string: String {
    switch self {
    case .Ruiten:
      return "♦"
    case .Schoppen:
      return "♠"
    case .Klaver:
      return "♣"
    case .Harten:
      return "♥"
    }
  }
}

let AllSymbols: [Symbool] = [.Ruiten, .Schoppen, .Klaver, .Harten]

struct Variant {
  let representation: String
  let punt: Int
}

enum Nummer {
  case Aas
  case Heer
  case Vrouw
  case Boer
  case Tien
  case Negen
  case Acht
  case Zeven
  
  var string: String {
    switch self {
    case .Aas:
      return "A"
    case .Heer:
      return "H"
    case .Vrouw:
      return "V"
    case .Boer:
      return "B"
    case .Tien:
      return "10"
    case .Negen:
      return "9"
    case .Acht:
      return "8"
    case .Zeven:
      return "7"
    }
  }
  
  var points: Int {
    switch self {
    case .Aas:
      return 11
    case .Heer, .Vrouw, .Boer, .Tien:
      return 10
    case .Negen:
      return 9
    case .Acht:
      return 8
    case .Zeven:
      return 7
    }
  }
}

let AllNummers: [Nummer] = [.Aas, .Heer, .Vrouw, .Boer, .Tien, .Negen, .Acht, .Zeven]

struct Kaart: CustomStringConvertible, Equatable, Comparable {
  let symbool: Symbool
  let nummer: Nummer
  
  var description: String {
    let color = symbool.color
    
    return color >>> "\(symbool.string)\(nummer.string)"
  }
}

func ==(lhs: Kaart, rhs: Kaart) -> Bool {
  return lhs.nummer == rhs.nummer && lhs.symbool == rhs.symbool
}

func >(lhs: Kaart, rhs: Kaart) -> Bool {
  return lhs.nummer.points > rhs.nummer.points
}
func <(lhs: Kaart, rhs: Kaart) -> Bool {
  return lhs.nummer.points < rhs.nummer.points
}
func >=(lhs: Kaart, rhs: Kaart) -> Bool {
  return lhs.nummer.points >= rhs.nummer.points
}
func <=(lhs: Kaart, rhs: Kaart) -> Bool {
  return lhs.nummer.points <= rhs.nummer.points
}
