//
//  Game.swift
//  Practice Game
//
//  Created by Dante Natoli on 6/4/15.
//  Copyright (c) 2015 Dante Natoli. All rights reserved.
//

import UIKit

class Game: NSObject {
  var turn: CharacterType
  var map: Map
  var players: [Character], enemies: [Character]
  var moving: Bool
  weak var controller: GameViewController?
  
  init(mapSize: (rows: Int, cols: Int), numPlayers: Int, numEnemies: Int) {
    turn = .Player
    self.map = Map(size: mapSize)
    map.populateMap(noWalk: [(0, 0)])
    moving = false
    players = [Character]()
    enemies = [Character]()
    for i in 0..<numPlayers {
      players.append(Character(player: "Player \(i)", start: map.playerStarts[i]))
    }
    for j in 0..<numEnemies {
      enemies.append(Character(enemy: "Enemy \(j)", start: map.enemyStarts[j]))
    }

  }
  
  func endTurn() {
    for player in players {
      player.canMove = true
    }
    controller!.endTurn()
    turn = .Enemy
    println("ENEMY TURN HERE")
    turn = .Player
  }
  
  func tileAt(position: (row: Int, col: Int)) -> MapTile? {
    return map.tileAt(position)
  }
  
  func tryMove(char: Character, tile: (row: Int, col: Int)) -> Bool {
    return false
  }
}
