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
  let position: (row: Int, col: Int)
  weak var view: MapTileView!
  var enemy: Character?
  weak var map: Map!
  
  init(tileType: MapTileType, at: (Int, Int)) {
    type = tileType
    position = at
  }
  
  func isWalkable() -> Bool {
    return ((type != .Obstacle) && (enemy == nil))
  }
}

class Map: NSObject {
  var allTiles: [[MapTile]]
  let rows: Int, cols: Int
  let playerStarts = [(4, 0)]
  let enemyStarts = [(4, 15)]
  
  init(size: (rows: Int, cols: Int)) {
    rows = size.rows
    cols = size.cols
    allTiles = [[MapTile]]()
  }
  
  // Builds the game map. Tiles at points contained in NOWALK will have obstacles, and the rest will be normal.
  func populateMap(noWalk: [(Int, Int)] = []) {
    for row in 0..<rows {
      allTiles.append([MapTile]())
      for col in 0..<cols {
        let newTile = MapTile(tileType: .Normal, at: (row, col))
        allTiles[row].append(newTile)
      }
    }
    for position in noWalk {
      tileAt(position)?.type = .Obstacle
    }
  }
  
  // Returns the map tile at POSITION, if it is within the map's bounds. Otherwise returns nil.
  func tileAt(position: (row: Int, col: Int)) -> MapTile? {
    if (position.row >= 0 && position.row < rows) && (position.col >= 0 && position.col < cols) {
      return allTiles[position.row][position.col]
    }
    return nil
  }
  
  /* Returns an array of all tiles reachable by CHAR within its number of moves. Accounts for
     obstacles. */
  func rangeOf(char: Character) -> [MapTile] {
    var range = [MapTile]()
    let start = char.position
    range.append(tileAt(start)!)
    for step in 1...char.numMoves {
      for i in 0...step {
        if let tile = tileAt((start.row + i, start.col + step - i)) where tile.isWalkable() {
          range.append(tile)
        }
        if let tile = tileAt((start.row + i, start.col - step + i)) where tile.isWalkable() && i < step {
          range.append(tile)
        }
        // Conditional to prevent double counting tiles in same row as start
        if i > 0 {
          if let tile = tileAt((start.row - i, start.col + step - i)) where tile.isWalkable() {
            range.append(tile)
          }
          if let tile = tileAt((start.row - i, start.col - step + i)) where tile.isWalkable() && i < step {
            range.append(tile)
          }
        }
      }
    }
    return range
  }
}

