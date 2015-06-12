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
  var space: MapTile
  let numMoves: Int, damage: Int, name: String
  let type: CharacterType
  var canMove = true, dead = false
  
  init(player name: String, start: MapTile) {
    health = 100
    numMoves = 4
    damage = 25
    self.name = name
    space = start
    type = .Player
  }
  
  init(enemy name: String, start: MapTile) {
    health = 75
    numMoves = 3
    damage = 10
    self.name = name
    space = start
    type = .Enemy
  }
  
  func dealDamage(target: Character) {
    target.takeDamage(damage)
  }
  
  func takeDamage(amount: Int) {
    health -= amount
    println("ARG I'M HIT")
    if health <= 0 {
      dead = true
    }
  }
  
  func moveTo(tile: MapTile) {
    space = tile
    canMove = false
  }
  
  func range() -> [MapTile] {
    var result = [space]
    for step in 1...numMoves {
      for tile in result {
        for edge in tile.edges {
          if !contains(result, edge.target) { result.append(edge.target) }
        }
      }
    }
    return result
  }
}
