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
  var playerViews = [CharacterView](), enemyViews = [CharacterView]()
  var activeChar: CharacterView? = nil, returnSpace: MapTileView? = nil
  let backgroundImage = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://old.serenesforest.net/fe7/map/14.PNG")!)!)
  var moving = false, attacking = false
  var newGame = false
  var game: Game
  let rows, cols: Int
  let numPlayers = 1, numEnemies = 1
  var menu, playerMenu: UIView!
  var menuDisplayed = false, playerDisplayed = false
  
  init(size: (rows: Int, cols: Int)) {
    rows = size.rows
    cols = size.cols
    game = Game(mapSize: (rows, cols), numPlayers: numPlayers, numEnemies: numEnemies)
    super.init(nibName: nil, bundle: nil)
  }
  
  // Unused
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
    let imageView = UIImageView(frame: backgroundFrame)
    let buttonWidth = (backgroundFrame.width - 50) / CGFloat(game.map.cols)
    let buttonHeight = (backgroundFrame.height - 50) / CGFloat(game.map.rows)
    menu = buildMenu()
    playerMenu = buildPlayerMenu()
    
    imageView.image = backgroundImage
    view.addSubview(imageView)
    
    for enemy in game.enemies {
      enemy.space.occupant = enemy
    }
    
    for row in 0..<rows {
      tileViews.append([MapTileView]())
      for col in 0..<cols {
        let frame = CGRect(x: 25 + CGFloat(col) * buttonWidth,
          y: 25 + CGFloat(row) * buttonHeight,
          width: buttonWidth,
          height: buttonHeight)
        let newTile = MapTileView(tile: game.tileAt((row, col))!, frame: frame)
        newTile.layer.borderColor = UIColor.blackColor().CGColor
        newTile.layer.borderWidth = 1.5
        view.addSubview(newTile)
        newTile.addTarget(self, action: "tileSelected:", forControlEvents: .TouchUpInside)
        tileViews[row].append(newTile)
      }
    }
    
    for player in game.players {
      let start = tileViewAt(player.space.position)!
      let charView = CharacterView(char: player, frame: start.frame)
      view.addSubview(charView)
      charView.addTarget(self, action: "playerSelected:", forControlEvents: .TouchUpInside)
      playerViews.append(charView)
    }
    
    for enemy in game.enemies {
      let start = tileViewAt(enemy.space.position)!
      let charView = CharacterView(char: enemy, frame: start.frame)
      view.addSubview(charView)
      charView.addTarget(self, action: "enemySelected:", forControlEvents: .TouchUpInside)
      enemyViews.append(charView)
    }
  }
  
  func tileViewAt(position: (row: Int, col: Int)) -> MapTileView? {
    if position.row < 0 || position.row >= rows || position.col < 0 || position.col >= cols {
      return nil
    } else {
      return tileViews[position.row][position.col]
    }
  }
  
  func tileViewFromChar(charView: CharacterView) -> MapTileView? {
    return tileViewAt(charView.char.space.position)
  }
  
  func tileSelected(sender: MapTileView) {
    if game.turn == .Player && game.winner == nil {
      if menuDisplayed {
        removeMenu(sender)
      } else {
        if let charView = activeChar where sender.backgroundColor == UIColor.blueColor().colorWithAlphaComponent(0.3) {
          moveCharacter(charView, to: sender)
        } else if !moving && !attacking {
          displayMenu(sender)
        }
      }
    }
  }
  
  func moveCharacter(charView: CharacterView, to: MapTileView) {
    returnSpace = tileViewFromChar(charView)
    UIView.animateWithDuration(0.7, animations: {
      charView.center = to.center
      }, completion: { _ in
        charView.char.moveTo(to.tile)
        self.displayPlayerMenu(to)
    })
    for tile in charView.char.range() {
      tileViewAt(tile.position)!.backgroundColor = .clearColor()
    }
  }
  
  func playerSelected(sender: CharacterView) {
    if game.turn == .Player && game.winner == nil {
      if sender.char.canMove && !moving && !attacking {
        activeChar = sender
        moving = true;
        let range = sender.char.range()
        for tile in range {
          tileViewAt(tile.position)!.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3)
        }
      } else if moving {
        if !attacking {
          moveCharacter(sender, to: tileViewFromChar(sender)!)
        } else {
          displayPlayerMenu(sender)
        }
      } else if !attacking {
        displayMenu(sender)
      }
    }
  }
  
  func enemySelected(sender: CharacterView) {
    if game.turn == .Player && game.winner == nil {
      if !moving {
        let range = sender.char.range()
        if !tileViewAt(range[0].position)!.enemyHighlighted {
          for point in range.map({ $0.position }) {
            tileViewAt(point)!.enemyHighlighted = true
            tileViewAt(point)!.setNeedsDisplay()
          }
        } else {
          for point in range.map({ $0.position }) {
            tileViewAt(point)!.enemyHighlighted = false
            tileViewAt(point)!.setNeedsDisplay()
          }
        }
      } else if tileViewAt(sender.char.space.position)!.backgroundColor == UIColor.redColor().colorWithAlphaComponent(0.3) {
        completeAttack(sender)
      }
    }
  }
  
  func displayPlayerMenu(sender: UIButton) {
    let y: CGFloat
    let diff = playerMenu.frame.size.height / 2
    if sender.center.y < diff + 50 {
      y = sender.center.y + diff
    } else {
      y = sender.center.y - diff
    }
    playerMenu.center = CGPoint(x: sender.center.x, y: y)
    if let neighbors = activeChar?.char.neighbors {
      if neighbors.filter({ $0.occupant != nil }).count == 0 {
        var button = playerMenu.subviews[0] as! UIButton
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        button.userInteractionEnabled = false
      } else {
        var button = playerMenu.subviews[0] as! UIButton
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.userInteractionEnabled = true
      }
    }
    view.addSubview(playerMenu)
    playerDisplayed = true
  }
  
  func displayMenu(sender: UIButton) {
    let y: CGFloat
    let diff = menu.frame.size.height / 2
    if sender.center.y < diff + 50 {
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
        tile.enemyHighlighted = false
        tile.setNeedsDisplay()
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
    menu.layer.borderColor = UIColor.blueColor().CGColor
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
    playerMenu.layer.borderColor = UIColor.blueColor().CGColor
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
    attacking = true
    for tile in activeChar!.char.space.neighbors {
      tileViewAt(tile.position)?.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.3)
    }
    if playerDisplayed {
      playerMenu.removeFromSuperview()
    }
  }
  
  func endMove(sender: UIButton) {
    playerMenu.removeFromSuperview()
    activeChar?.setNeedsDisplay()
    activeChar = nil
    returnSpace = nil
    moving = false
    if game.players.filter({$0.canMove}).count == 0 {
      endTurn(sender)
    }
  }
  
  func cancelMove(sender: UIButton) {
    playerMenu.removeFromSuperview()
    let attacks = activeChar!.char.space.neighbors.map{ self.tileViewAt($0.position)! }
    for attack in attacks {
      attack.backgroundColor = .clearColor()
    }
    if let tile = returnSpace?.tile {
      activeChar?.char.moveTo(tile)
      activeChar?.char.canMove = true
      activeChar?.center = returnSpace!.center
    }
    activeChar = nil
    returnSpace = nil
    moving = false
    attacking = false
  }
  
  func completeAttack(target: CharacterView) {
    game.attack(activeChar!.char, target: target.char)
    for tile in activeChar!.char.space.neighbors {
      tileViewAt(tile.position)?.backgroundColor = .clearColor()
    }
    if target.char.dead {
      target.removeFromSuperview()
      switch target.char.type {
      case .Player:
        playerViews = playerViews.filter{$0 != target}
      case .Enemy:
        enemyViews = enemyViews.filter{$0 != target}
      }
    }
    attacking = false
    endMove(activeChar!)
    if game.winner != nil {
      endGame(game.winner!)
    }
  }
  
  func endGame(winner: CharacterType) {
    var message = winner == .Player ? "Congratulations!" : "Too bad!"
    message += " Play Again?"
    var gameOver = UIButton(frame: CGRect(origin: view.frame.origin, size: CGSize(width: 250, height: 50)))
    gameOver.backgroundColor = .whiteColor()
    gameOver.layer.borderColor = UIColor.blackColor().CGColor
    gameOver.layer.borderWidth = 1.5
    gameOver.center = view.center
    gameOver.setTitle(message, forState: .Normal)
    gameOver.setTitleColor(UIColor.blackColor(), forState: .Normal)
    gameOver.addTarget(self, action: "newGame:", forControlEvents: .TouchUpInside)
    view.addSubview(gameOver)
  }
  
  func newGame(sender: UIButton) {
    newGame = true
    for view in playerViews {
      view.removeFromSuperview()
    }
    for view in enemyViews {
      view.removeFromSuperview()
    }
    for row in tileViews {
      for view in row {
        view.removeFromSuperview()
      }
    }
    playerViews = [CharacterView]()
    enemyViews = [CharacterView]()
    tileViews = [[MapTileView]]()
    game = Game(mapSize: (rows: rows, cols: cols), numPlayers: numPlayers, numEnemies: numEnemies)
    for char in game.players {
      println("\(char.numMoves)")
    }
    moving = false
    attacking = false
    loadView()
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
