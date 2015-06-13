//
//  MapTileView.swift
//  Practice Game
//
//  Created by Dante Natoli on 6/3/15.
//  Copyright (c) 2015 Dante Natoli. All rights reserved.
//

import UIKit

class MapTileView: UIButton {
  
  var tile: MapTile
  var enemyHighlighted = false
  
  init(tile: MapTile, frame: CGRect) {
    self.tile = tile
    super.init(frame: frame)
  }
  
  // Unused
  required init(coder aDecoder: NSCoder) {
    self.tile = MapTile(tileType: .Normal, at: (0, 0))
    super.init(coder: aDecoder)
  }
  
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
    // Drawing code
    super.drawRect(rect)
    if tile.type == .Obstacle {
      UIColor.blackColor().colorWithAlphaComponent(0.4).setFill()
      CGContextFillRect(UIGraphicsGetCurrentContext(), rect)
    } else if enemyHighlighted {
      UIColor.brownColor().colorWithAlphaComponent(0.3).setFill()
      CGContextFillRect(UIGraphicsGetCurrentContext(), rect)
    }
  }
}
