//
//  MapViewController.swift
//  Practice Game
//
//  Created by Dante Natoli on 6/2/15.
//  Copyright (c) 2015 Dante Natoli. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
  
  var tileViews: [[MapTileView]]!
  var playerViews: [CharacterView]!
  var enemyViews: [CharacterView]!
  var game: Game
  let rows: Int, cols: Int
  
  init(size: (rows: Int, cols: Int)) {
    rows = size.rows
    cols = size.cols
    game = Game(mapSize: (rows, cols), numPlayers: 1, numEnemies: 1)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init(coder aDecoder: NSCoder) {
    rows = 1
    cols = 1
    game = Game(mapSize: (rows, cols), numPlayers: 0, numEnemies: 0)
    super.init(coder: aDecoder)
  }
  
  override func loadView() {
    tileViews = [[MapTileView]]()
    playerViews = [CharacterView]()
    enemyViews = [CharacterView]()
    game.controller = self
    
    let backgroundFrame = UIScreen.mainScreen().bounds
    view = UIView(frame: backgroundFrame)
    let buttonWidth = (backgroundFrame.width - 50) / CGFloat(game.map.cols)
    let buttonHeight = (backgroundFrame.height - 50) / CGFloat(game.map.rows)
    
    for row in 0..<rows {
      tileViews.append([MapTileView]())
      for col in 0..<cols {
        let frame = CGRect(x: 25 + CGFloat(col) * buttonWidth,
          y: 25 + CGFloat(row) * buttonHeight,
          width: buttonWidth,
          height: buttonHeight)
        let newTile = MapTileView(tile: game.tileAt((row, col))!, frame: frame)
        game.tileAt((row, col))!.view = newTile
        newTile.layer.borderColor = UIColor.blackColor().CGColor
        newTile.layer.borderWidth = 1.5
        view.addSubview(newTile)
        newTile.addTarget(self, action: "tileSelected:", forControlEvents: .TouchUpInside)
        tileViews[row].append(newTile)
      }
    }
    
    for player in game.players {
      let start = tileViewAt(player.position)
      let charView = CharacterView(character: player, frame: start.frame)
      view.addSubview(charView)
      charView.addTarget(self, action: "playerSelected:", forControlEvents: .TouchUpInside)
      playerViews.append(charView)
    }
    
    for enemy in game.enemies {
      let start = tileViewAt(enemy.position)
      let charView = CharacterView(character: enemy, frame: start.frame)
      view.addSubview(charView)
      charView.addTarget(self, action: "enemySelected:", forControlEvents: .TouchUpInside)
      enemyViews.append(charView)
    }
  }
  
  func tileViewAt(position: (row: Int, col: Int)) -> MapTileView {
    return tileViews[position.row][position.col]
  }
  
  func tileSelected(sender: MapTileView) {
    if game.turn == .Player {
      let charView = playerViews[0]
      if sender.backgroundColor == UIColor.blueColor().colorWithAlphaComponent(0.3) {
        moveCharacter(charView, to: sender)
        for row in tileViews {
          for tile in row {
            tile.backgroundColor = .clearColor()
            tile.setTitle(nil, forState: .Normal)
          }
        }
      }
    }
  }
  
  func moveCharacter(charView: CharacterView, to: MapTileView) {
    UIView.animateWithDuration(0.7, animations: {
      charView.center = to.center
      }, completion: { _ in
        charView.character.moveToSpace(to.tile.position)
        charView.setNeedsDisplay()
    })
  }
  
  func playerSelected(sender: CharacterView) {
    if game.turn == .Player {
      if sender.character.canMove {
        // highlight reachable range
        let range = game.map.rangeOf(sender.character)
        for tile in range {
          tile.view.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3)
        }
      } else {
        // show default menu (end turn)
      }
    } else {
      println("Not your turn bub")
    }
  }
  
  func enemySelected(sender: CharacterView) {
    if game.turn == .Player {
      println("Enemy was selected")
      game.endTurn()
    }
  }
  
  func endTurn() {
    for player in playerViews {
      player.setNeedsDisplay()
    }
  }
  
  override func supportedInterfaceOrientations() -> Int {
    return Int(UIInterfaceOrientationMask.Landscape.rawValue)
  }
  
  override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
    return UIInterfaceOrientation.LandscapeLeft
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
