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
//  var index: Int
  var left: MapTile?, right: MapTile?, up: MapTile?, down: MapTile?
  weak var map: Map?
  
  init(walk: Walkability, index: Int) {
    walkability = walk
//    self.index = index
  }
  
  func isWalkable() -> Bool {
    return walkability != .Obstacle
  }
}

class Map: NSObject {
  var allTiles: [MapTile]
  let height: Int, width: Int
  
  init(height: Int, width: Int) {
    self.height = height
    self.width = width
    allTiles = [MapTile]()
  }
  
  // Builds the game map. Tiles at indeces contained in NOWALK will have obstacles, and the rest will be normal.
  func populateMap(noWalk: [Int] = []) {
    let numSquares = height * width
    for i in 0..<numSquares {
      let newTile = MapTile(walk: .Normal, index: i)
      if contains(noWalk, i) {
        newTile.walkability = .Obstacle
      }
      newTile.map = self
      if i / height != 0 {
        newTile.up = allTiles[i - height]
        allTiles[i - height].down = newTile
      }
      if i % width != 0 {
        newTile.left = allTiles[i - 1]
        allTiles[i - 1].right = newTile
      }
      allTiles.append(newTile)
    }
  }
  
  // Calculates the number of spaces between two tiles on the game map.
//  func calcDist(tile1: MapTile, tile2: MapTile) -> Int {
//    return abs((tile1.index % width) - (tile2.index % width)) + abs((tile1.index / height) - (tile2.index / height));
//  }
  
  /* Uses breadth-first search to return the range a character can move from SPACE using no more than NUMMOVES moves.
   * Takes obstacles into account. */
  func reachable(space: MapTile, numMoves: Int) -> [MapTile] {
    var range = [MapTile]()
    range.append(space)
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

