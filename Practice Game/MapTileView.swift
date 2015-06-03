//
//  MapTileView.swift
//  Practice Game
//
//  Created by Dante Natoli on 6/3/15.
//  Copyright (c) 2015 Dante Natoli. All rights reserved.
//

import UIKit

class MapTileView: UIButton {
  var x: Int, y: Int
  
  init(frame: CGRect, x: Int, y: Int) {
    self.x = x
    self.y = y
    super.init(frame: frame)
  }
  
  required init(coder aDecoder: NSCoder) {
    x = 0
    y = 0
    super.init(coder: aDecoder)
  }
  
  /*
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
    // Drawing code
  }*/
}
