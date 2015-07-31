//
//  AiTest.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 20-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import XCTest

class AiTest: XCTestCase {

  func testAiSwitch() {
    // ♥V ♣B ♠H
    let tafel: Tafel = [
      Kaart(symbool: .Harten, nummer: .Vrouw),
      Kaart(symbool: .Klaver, nummer: .Boer),
      Kaart(symbool: .Schoppen, nummer: .Heer)]
    
    // ♥A ♦9 ♦V
    let speler = Speler(kaarten: [
      Kaart(symbool: .Harten, nummer: .Aas),
      Kaart(symbool: .Ruiten, nummer: .Negen),
      Kaart(symbool: .Ruiten, nummer: .Vrouw)],
      name: "Test", sticks: 5, beurten: [], position: NoordPosition)
    
    let aiBeurt = AIbeurt(speler, tafel: tafel)
    
    XCTAssertEqual(aiBeurt, Beurt.Switch(
      PossibleBeurt(
        throwKaart: Kaart(symbool: .Ruiten, nummer: .Negen),
        grabKaart: Kaart(symbool: .Harten, nummer: .Vrouw),
        points: 21)))
  }
  
  func testAiPass() {
    // ♥V ♣B ♠H
    let tafel: Tafel = [
      Kaart(symbool: .Harten, nummer: .Vrouw),
      Kaart(symbool: .Klaver, nummer: .Boer),
      Kaart(symbool: .Schoppen, nummer: .Heer)]
    
    // ♦A ♦10 ♦9
    let speler = Speler(kaarten: [
      Kaart(symbool: .Ruiten, nummer: .Aas),
      Kaart(symbool: .Ruiten, nummer: .Tien),
      Kaart(symbool: .Ruiten, nummer: .Negen)],
      name: "Test", sticks: 5, beurten: [], position: NoordPosition)
    
    let aiBeurt = AIbeurt(speler, tafel: tafel)
    
    XCTAssertEqual(aiBeurt, Beurt.Pass)
  }
  
  func testAiWissel() {
    // ♦A ♦10 ♦9
    let tafel: Tafel = [
      Kaart(symbool: .Ruiten, nummer: .Aas),
      Kaart(symbool: .Ruiten, nummer: .Tien),
      Kaart(symbool: .Ruiten, nummer: .Negen)]
    
    // ♥V ♣B ♠H
    let speler = Speler(kaarten: [
      Kaart(symbool: .Harten, nummer: .Vrouw),
      Kaart(symbool: .Klaver, nummer: .Boer),
      Kaart(symbool: .Schoppen, nummer: .Heer)],
      name: "Test", sticks: 5, beurten: [], position: NoordPosition)
    
    let aiBeurt = AIbeurt(speler, tafel: tafel)
    
    XCTAssertEqual(aiBeurt, Beurt.Wissel)
  }

}
