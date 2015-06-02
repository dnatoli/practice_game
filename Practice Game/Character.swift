//
//  Character.swift
//  Practice Game
//
//  Created by Dante Natoli on 6/1/15.
//  Copyright (c) 2015 Dante Natoli. All rights reserved.
//

import UIKit

class Character: NSObject {
  var health: Int
  var numMoves: Int
  var damage: Int
  var name: String
  var space: MapTile
  
  init(player name: String, start: MapTile) {
    health = 100
    numMoves = 4
    damage = 25
    self.name = name
    space = start
  }
  
  init(enemy name: String, start: MapTile) {
    health = 75
    numMoves = 3
    damage = 10
    self.name = name
    space = start
    
  }
  
  func dealDamage(target: Character) {
    target.takeDamage(damage)
  }
  
  func takeDamage(amount: Int) {
    health -= amount
  }
  
  func moveToSpace(tile: MapTile) {
    space = tile
    
  }
}
