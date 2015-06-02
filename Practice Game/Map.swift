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
  var left: MapTile?
  var right: MapTile?
  var up: MapTile?
  var down: MapTile?
  weak var map: Map?
  
  init(walk: Walkability, index: Int) {
    walkability = walk
//    self.index = index
  }
}

class Map: NSObject {
  var allTiles: [MapTile]
  var height: Int
  var width: Int
  
  init(height: Int, width: Int) {
    self.height = height
    self.width = width
    allTiles = [MapTile]()
  }
  
  // Builds the game map. Tiles at indeces contained in NOWALK will have obstacles, and the rest will be normal.
  func populateMap(noWalk: [Int] = []) {
    let count = height * width
    for i in 0..<count {
      var tmp = MapTile(walk: .Normal, index: i)
      if contains(noWalk, i) {
        tmp.walkability = .Obstacle
      }
      tmp.map = self
      if i / height != 0 {
        tmp.up = allTiles[i - height]
        allTiles[i - height].down = tmp
      }
      if i % width != 0 {
        tmp.left = allTiles[i - 1]
        allTiles[i - 1].right = tmp
      }
      allTiles.append(tmp)
    }
  }
  
  // Calculates the number of spaces between two tiles on the game map.
//  func calcDist(tile1: MapTile, tile2: MapTile) -> Int {
//    return abs((tile1.index % width) - (tile2.index % width)) + abs((tile1.index / height) - (tile2.index / height));
//  }
  
  /* Uses breadth-first search to return the range a character can move, taking obstacles and number of moves
   * into account. */
  func reachable(by: Character) -> [MapTile] {
    var range = [MapTile]()
    range.append(by.space)
    var level = 0
    var count = 0
    var curr = 0
    var tmp: MapTile
    while level < by.numMoves {
      count = range.count
      for i in curr..<count {
        if let tmp = range[i].left {
          if tmp.walkability != .Obstacle && !contains(range, tmp) {
            range.append(tmp)
          }
        }
        if let tmp = range[i].right {
          if tmp.walkability != .Obstacle && !contains(range, tmp) {
            range.append(tmp)
          }
        }
        if let tmp = range[i].up {
          if tmp.walkability != .Obstacle && !contains(range, tmp) {
            range.append(tmp)
          }
        }
        if let tmp = range[i].down {
          if tmp.walkability != .Obstacle && !contains(range, tmp) {
            range.append(tmp)
          }
        }
      }
      curr = count
      ++level
    }
    return range
  }
}

