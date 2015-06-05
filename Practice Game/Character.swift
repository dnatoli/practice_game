//
//  Character.swift
//  Practice Game
//
//  Created by Dante Natoli on 6/1/15.
//  Copyright (c) 2015 Dante Natoli. All rights reserved.
//

import UIKit

enum CharacterType {
  case Player
  case Enemy
}

class Character: NSObject {
  var health: Int
  var position: (row: Int, col: Int)
  let numMoves: Int, damage: Int, name: String
  let type: CharacterType
  var canMove: Bool
  
  init(player name: String, start: (row: Int, col: Int)) {
    health = 100
    numMoves = 4
    damage = 25
    self.name = name
    position = start
    type = .Player
    canMove = true
  }
  
  init(enemy name: String, start: (row: Int, col: Int)) {
    health = 75
    numMoves = 3
    damage = 10
    self.name = name
    position = start
    type = .Enemy
    canMove = true
  }
  
  func dealDamage(target: Character) {
    target.takeDamage(damage)
  }
  
  func takeDamage(amount: Int) {
    health -= amount
  }
  
  func moveToSpace(tile: (row: Int, col: Int)) {
    position = tile
    canMove = false
  }
}
