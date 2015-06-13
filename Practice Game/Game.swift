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
  let map: Map
  var players: [Character], enemies: [Character]
  weak var controller: GameViewController?
  var winner: CharacterType? = nil
  
  init(mapSize: (rows: Int, cols: Int), numPlayers: Int, numEnemies: Int) {
    turn = .Player
    self.map = Map(size: mapSize, noWalk: [(3, 9)])
    let playerStarts = [(4, 0)]
    let enemyStarts = [(4, 15)]
    players = [Character]()
    enemies = [Character]()
    for i in 0..<numPlayers {
      players.append(Character(player: "Player \(i)", start: map.tileAt(playerStarts[i])!))
    }
    for j in 0..<numEnemies {
      enemies.append(Character(enemy: "Enemy \(j)", start: map.tileAt(enemyStarts[j])!))
    }
  }
  
  func endTurn() {
    for player in players {
      player.canMove = true
    }
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
  
  func attack(attacker: Character, target: Character) {
    attacker.dealDamage(target)
    if target.dead {
      switch target.type {
      case .Player:
        println("\(target.name) died")
        players = players.filter{$0 != target}
      case .Enemy:
        println("\(target.name) died")
        players = enemies.filter{$0 != target}
      }
    }
    if players.count == 0 {
      winner = .Enemy
    } else if enemies.count == 0 {
      winner = .Player
    }
  }
}
