//
//  CharacterView.swift
//  Practice Game
//
//  Created by Dante Natoli on 6/3/15.
//  Copyright (c) 2015 Dante Natoli. All rights reserved.
//

import UIKit

class CharacterView: UIButton {
  
  let char: Character
  
  init(char: Character, frame: CGRect) {
    self.char = char
    super.init(frame:frame)
  }
  
  // Unused
  required init?(coder aDecoder: NSCoder) {
    self.char = Character(player: "Player 0", start: MapTile(tileType: .Normal, at: (0, 0)))
    super.init(coder: aDecoder)
  }
  
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
    // Drawing code
    let shape = UIBezierPath(ovalInRect: self.bounds)
    switch char.type {
    case .Player:
      if (char.canMove) {
        UIColor.blueColor().setFill()
      } else {
        UIColor.grayColor().setFill()
      }
    case .Enemy:
      UIColor.redColor().setFill()
    }
    shape.fill()
  }
}
