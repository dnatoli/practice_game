//
//  MapTile.swift
//  Practice Game
//
//  Created by Dante Natoli on 6/1/15.
//  Copyright (c) 2015 Dante Natoli. All rights reserved.
//

import UIKit

enum Walkability {
  case Normal
  case Obstacle
}

class MapTile: NSObject {
  var walkability: Walkability
  var left: MapTile?, right: MapTile?, up: MapTile?, down: MapTile?
  let x: Int, y: Int
  weak var map: Map?
  
  init(walk: Walkability, x: Int, y: Int) {
    walkability = walk
    self.x = x
    self.y = y
  }
  
  func isWalkable() -> Bool {
    return walkability != .Obstacle
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
  let height: Int, width: Int
  
  init(height: Int, width: Int) {
    self.height = height
    self.width = width
    allTiles = [[MapTile]]()
  }
  
  // Builds the game map. Tiles at points contained in NOWALK will have obstacles, and the rest will be normal.
  func populateMap(noWalk: [(Int, Int)] = []) {
    for i in 0..<width {
      allTiles.append([MapTile]())
      for j in 0..<height {
        let newTile = MapTile(walk: .Normal, x: i, y: j)
        allTiles[i].append(newTile)
      }
    }
    for (x, y) in noWalk {
      allTiles[x][y].walkability = .Obstacle
    }
  }
}

