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

// Represents an edge in the map's graph, where MapTiles are nodes.
struct MapEdge {
  let weight: Int
  let source, target: MapTile
}

// Represents a node in the map's graph, as well as some associated game state.
class MapTile: NSObject {
  let type: MapTileType
  let position: (row: Int, col: Int)
  var edges = [MapEdge]()
  var neighbors: [MapTile] {
    return edges.map{ $0.target }
  }
  weak var occupant: Character?
  
  init(tileType: MapTileType, at: (row: Int, col: Int)) {
    type = tileType
    position = at
  }
  
  func isWalkable() -> Bool {
    return ((type != .Obstacle) && (occupant == nil))
  }
}

class Map: NSObject {
  var allTiles: [[MapTile]]
  let rows, cols: Int
  let playerStarts = [(4, 0)]
  let enemyStarts = [(3, 15)]
  
  init(size: (rows: Int, cols: Int), noWalk: [(row: Int, col: Int)]) {
    rows = size.rows
    cols = size.cols
    allTiles = [[MapTile]]()
    
    // Build MapTiles, adding obstacles to tiles in noWalk
    for row in 0..<rows {
      allTiles.append([MapTile]())
      for col in 0..<cols {
        let newTile: MapTile
        if noWalk.filter({ $0 == row && $1 == col }).count > 0 {
          newTile = MapTile(tileType: .Obstacle, at: (row, col))
        } else {
          newTile = MapTile(tileType: .Normal, at: (row, col))
        }
        allTiles[row].append(newTile)
      }
    }

    // Build the graph of MapTiles. Done in separate loop because it requires all tiles to be
    // instantiated.
    for row in 0..<rows {
      for col in 0..<cols {
        let source = allTiles[row][col]
        for point in [(row, col + 1), (row, col - 1), (row + 1, col), (row - 1, col)] {
          if point.0 >= 0 && point.0 < size.rows && point.1 >= 0 && point.1 < size.cols {
            let target = allTiles[point.0][point.1]
            if target.isWalkable() {
              source.edges.append(MapEdge(weight: 1, source: source, target: target))
            }
          }
        }
      }
    }
  }
  
  // Returns the map tile at POSITION, if it is within the map's bounds. Otherwise returns nil.
  func tileAt(position: (row: Int, col: Int)) -> MapTile? {
    if (position.row >= 0 && position.row < rows) && (position.col >= 0 && position.col < cols) {
      return allTiles[position.row][position.col]
    }
    return nil
  }
}

