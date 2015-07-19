//
//  Positions.swift
//  EenEnDertigen
//
//  Created by Tomas Harkema on 19-07-15.
//  Copyright © 2015 Tomas Harkema. All rights reserved.
//

import Foundation

let HeaderPosition = Position(x: 0, y: 0)
let TafelPosition = Position(x: 50, y: 10)
let StatusPosition = Position(x: 100, y: 10)
let VerliezerPosition = Position(x: 50, y: 10)
let InputPosition = Position(x: 0, y: 25)

let NoordPosition = Position(x: 50, y: 5)
let OostPosition = Position(x: 75, y: 10)
let ZuidPosition = Position(x: 50, y: 15)
let WestPosition = Position(x: 25, y: 10)

let HandPosition = ZuidPosition.down(5).right(-5)