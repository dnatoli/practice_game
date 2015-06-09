//
//  MapViewController.swift
//  Practice Game
//
//  Created by Dante Natoli on 6/2/15.
//  Copyright (c) 2015 Dante Natoli. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
  
  var tileViews = [[MapTileView]]()
  var playerViews = [CharacterView]()
  var enemyViews = [CharacterView]()
  var activeChar: CharacterView?, returnSpace: MapTileView?
  var game: Game
  let rows: Int, cols: Int
  var menu: UIView!, playerMenu: UIView!
  var menuDisplayed = false, playerDisplayed = false
  
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
    game.controller = self
    
    let backgroundFrame = UIScreen.mainScreen().bounds
    view = UIView(frame: backgroundFrame)
    let buttonWidth = (backgroundFrame.width - 50) / CGFloat(game.map.cols)
    let buttonHeight = (backgroundFrame.height - 50) / CGFloat(game.map.rows)
    menu = buildMenu()
    playerMenu = buildPlayerMenu()
    
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
      if menuDisplayed {
        removeMenu(sender)
      } else {
        let charView = playerViews[0]
        if sender.backgroundColor == UIColor.blueColor().colorWithAlphaComponent(0.3) {
          moveCharacter(charView, to: sender)
        } else {
          displayMenu(sender)
        }
      }
    }
  }
  
  func moveCharacter(charView: CharacterView, to: MapTileView) {
    UIView.animateWithDuration(0.7, animations: {
      charView.center = to.center
      }, completion: { _ in
        charView.character.moveToSpace(to.tile.position)
        self.displayPlayerMenu(to)
    })
    for row in tileViews {
      for tile in row {
        tile.backgroundColor = .clearColor()
      }
    }

    game.moving = false
  }
  
  func playerSelected(sender: CharacterView) {
    if game.turn == .Player {
      if sender.character.canMove && !game.moving {
        activeChar = sender
        game.moving = true;
        let range = game.map.rangeOf(sender.character)
        for tile in range {
          tile.view.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3)
        }
      } else if game.moving {
        moveCharacter(sender, to: tileViewAt(sender.character.position))
      } else {
        displayMenu(sender)
      }
    }
  }
  
  func enemySelected(sender: CharacterView) {
    if game.turn == .Player {
      if !game.moving {
        let range = game.map.rangeOf(sender.character)
        println("\(range[0].view.backgroundColor)")
        if range[0].view.backgroundColor != UIColor.redColor().colorWithAlphaComponent(0.3) {
          for tile in range {
            tile.view.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.3)
          }
        } else {
          for tile in range {
            tile.view.backgroundColor = .clearColor()
          }
        }
      }
    }
  }
  
  func displayPlayerMenu(sender: UIButton) {
    let y: CGFloat
    let diff = playerMenu.frame.size.height / 2
    if sender.center.y < diff {
      y = sender.center.y + diff
    } else {
      y = sender.center.y - diff
    }
    playerMenu.center = CGPoint(x: sender.center.x, y: y)
    view.addSubview(playerMenu)
    playerDisplayed = true
  }
  
  func displayMenu(sender: UIButton) {
    let y: CGFloat
    let diff = menu.frame.size.height / 2
    if sender.center.y < diff {
      y = sender.center.y + diff
    } else {
      y = sender.center.y - diff
    }

    menu.center = CGPoint(x: sender.center.x, y: y)
    menuDisplayed = true
    view.addSubview(menu)
  }
  
  func removeMenu(sender: UIButton) {
    menu.removeFromSuperview()
    menuDisplayed = false
  }
  
  func endTurn(sender: UIButton) {
    if menuDisplayed {
      removeMenu(sender)
    }
    for row in tileViews {
      for tile in row {
        tile.backgroundColor = .clearColor()
      }
    }
    game.endTurn()
    for player in playerViews {
      player.setNeedsDisplay()
    }
  }
  
  func buildMenu() -> UIView {
    var menu = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 60)))
    menu.backgroundColor = .whiteColor()
    menu.layer.borderColor = UIColor.blackColor().CGColor
    menu.layer.borderWidth = 1.0
    
    let endOrigin = menu.frame.origin
    var endButton = UIButton(frame: CGRect(origin: endOrigin, size: CGSize(width: 100, height: 30)))
    endButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    endButton.setTitle("End Turn", forState: .Normal)
    endButton.addTarget(self, action: "endTurn:", forControlEvents: .TouchUpInside)
    menu.addSubview(endButton)
    
    let cancelOrigin = CGPoint(x: menu.frame.origin.x, y: menu.frame.origin.y + 30)
    var cancelButton = UIButton(frame: CGRect(origin: cancelOrigin, size: CGSize(width: 100, height: 30)))
    cancelButton.setTitle("Cancel", forState: .Normal)
    cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    cancelButton.addTarget(self, action: "removeMenu:", forControlEvents: .TouchUpInside)
    menu.addSubview(cancelButton)
    
    return menu
  }
  
  func buildPlayerMenu() -> UIView {
    var playerMenu = UIView(frame: CGRect(origin: view.frame.origin, size: CGSize(width: 100, height: 90)))
    playerMenu.backgroundColor = .whiteColor()
    playerMenu.layer.borderColor = UIColor.blackColor().CGColor
    playerMenu.layer.borderWidth = 1.0
    
    let attackOrigin = playerMenu.frame.origin
    var attackButton = UIButton(frame: CGRect(origin: attackOrigin, size: CGSize(width: 100, height: 30)))
    attackButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    attackButton.setTitle("Attack", forState: .Normal)
    attackButton.addTarget(self, action: "attack:", forControlEvents: .TouchUpInside)
    playerMenu.addSubview(attackButton)
    
    let endOrigin = CGPoint(x: playerMenu.frame.origin.x, y: playerMenu.frame.origin.y + 30)
    var endButton = UIButton(frame: CGRect(origin: endOrigin, size: CGSize(width: 100, height: 30)))
    endButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    endButton.setTitle("End", forState: .Normal)
    endButton.addTarget(self, action: "endMove:", forControlEvents: .TouchUpInside)
    playerMenu.addSubview(endButton)
    
    let cancelOrigin = CGPoint(x: playerMenu.frame.origin.x, y: playerMenu.frame.origin.y + 60)
    var cancelButton = UIButton(frame: CGRect(origin: cancelOrigin, size: CGSize(width: 100, height: 30)))
    cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    cancelButton.setTitle("Cancel", forState: .Normal)
    cancelButton.addTarget(self, action: "cancelMove:", forControlEvents: .TouchUpInside)
    playerMenu.addSubview(cancelButton)
    
    return playerMenu
  }
  
  func attack(sender: UIButton) {
    // Do the attacking things
  }
  
  func endMove(sender: UIButton) {
    activeChar?.setNeedsDisplay()
    activeChar = nil
    playerMenu.removeFromSuperview()
  }
  
  func cancelMove(sender: UIButton) {
    // Go back to previous position without using up moves
    playerMenu.removeFromSuperview()
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
