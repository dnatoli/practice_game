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
    let noWalk = [(row: 7, col: 0), (row: 8, col: 0), (row: 0, col: 1), (row: 1, col: 10), (row: 5, col: 11), (row: 4, col: 13), (row: 4, col: 14)]
      + [(row: 1, col: 11), (row: 3, col: 12), (row: 4, col: 12), (row: 8, col: 8), (row: 7, col: 9), (row: 7, col: 10), (row: 6, col: 11), (row: 4, col: 15)]
    self.map = Map(size: mapSize, noWalk: noWalk)
    let playerStarts = [(4, 0)]
    let enemyStarts = [(3, 15)]
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
  
  // TODO: Possible point for refactoring, put movement logic in game rather than controller
//  func tryMove(char: Character, tile: (row: Int, col: Int)) -> Bool {
//    return false
//  }
  
  func attack(attacker: Character, target: Character) {
    attacker.dealDamage(target)
    if target.dead {
      switch target.type {
      case .Player:
        players = players.filter{$0 != target}
      case .Enemy:
        enemies = enemies.filter{$0 != target}
      }
    }
    if players.count == 0 {
      winner = .Enemy
    } else if enemies.count == 0 {
      winner = .Player
    }
  }
}
