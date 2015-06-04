//
//  MapTile.swift
//  Practice Game
//
//  Created by Dante Natoli on 6/1/15.
//  Copyright (c) 2015 Dante Natoli. All rights reserved.
//

import UIKit

enum MapTileType {
  case Normal
  case Obstacle
}

class MapTile: NSObject {
  var type: MapTileType
  var left: MapTile?, right: MapTile?, up: MapTile?, down: MapTile?
  let position: (row: Int, col: Int)
  weak var view: MapTileView!
  var occupant: Character?
  weak var map: Map!
  
  init(tileType: MapTileType, at: (Int, Int)) {
    type = tileType
    position = at
  }
  
  func isWalkable() -> Bool {
    return type != .Obstacle
  }
  
  /* Uses breadth-first search to return the range a character can move from this space using
   * no more than NUMMOVES moves. Takes obstacles into account. */
  func reachable(numMoves: Int) -> [MapTile] {
    var range = [MapTile]()
    range.append(self)
    var level = 0
    var count = 0
    var curr = 0
    while level < numMoves {
      count = range.count
      for i in curr..<count {
        if let left = range[i].left where (left.isWalkable() && !contains(range, left)) {
          range.append(left)
        }
        if let right = range[i].right where (right.isWalkable() && !contains(range, right)){
          range.append(right)
        }
        if let up = range[i].up where up.isWalkable() && !contains(range, up) {
          range.append(up)
        }
        if let down = range[i].down where (down.isWalkable() && !contains(range, down)) {
          range.append(down)
        }
      }
      curr = count
      ++level
    }
    return range
  }
}

class Map: NSObject {
  var allTiles: [[MapTile]]
  let rows: Int, columns: Int
  var players: [Character], enemies: [Character]
  let playerStarts = [(0, 4)]
  let enemyStarts = [(15, 4)]
  
  init(rows: Int, columns: Int, numPlayers: Int, numEnemies: Int) {
    self.rows = rows
    self.columns = columns
    allTiles = [[MapTile]]()
    players = [Character]()
    enemies = [Character]()
    for i in 0..<numPlayers {
      players.append(Character(player: "Player \(i)", start: playerStarts[i]))
    }
    for j in 0..<numEnemies {
      enemies.append(Character(enemy: "Enemy \(j)", start: enemyStarts[j]))
    }
  }
  
  // Builds the game map. Tiles at points contained in NOWALK will have obstacles, and the rest will be normal.
  func populateMap(noWalk: [(Int, Int)] = []) {
    for i in 0..<columns {
      allTiles.append([MapTile]())
      for j in 0..<rows {
        let newTile = MapTile(tileType: .Normal, at: (i, j))
        allTiles[i].append(newTile)
      }
    }
    for (x, y) in noWalk {
      allTiles[x][y].type = .Obstacle
    }
  }
  
  func tileAt(position: (row: Int, col: Int)) -> MapTile {
    return allTiles[position.row][position.col]
  }
}

