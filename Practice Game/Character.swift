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
  var neighbors: [MapTile] {
    return space.neighbors
  }
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
    health = 100
    numMoves = 3
    damage = 25
    self.name = name
    space = start
    type = .Enemy
  }
  
  func dealDamage(target: Character) {
    target.takeDamage(damage)
  }
  
  func takeDamage(amount: Int) {
    health -= amount
    if health <= 0 {
      dead = true
    }
  }
  
  func moveTo(tile: MapTile) {
    space.occupant = nil
    tile.occupant = self
    space = tile
    canMove = false
  }
  
  func range() -> [MapTile] {
    var result = [space]
    for step in 1...numMoves {
      for tile in result {
        for target in tile.edges.map({$0.target}) {
          if !result.contains(target) && target.isWalkable() { result.append(target) }
        }
      }
    }
    return result
  }
  
  func attackRange() -> [MapTile] {
    var result = [space]
    for step in 1...numMoves+1 {
      for tile in result {
        for edge in tile.edges {
          if !result.contains(edge.target) { result.append(edge.target) }
        }
      }
    }
    return result
  }
}
