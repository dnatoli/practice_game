//
//  MapViewController.swift
//  Practice Game
//
//  Created by Dante Natoli on 6/2/15.
//  Copyright (c) 2015 Dante Natoli. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
  
  var map: Map!
  var tileViews: [[MapTileView]]!
  var playerViews: [CharacterView]!
  var enemyViews: [CharacterView]!
  
  override func loadView() {
    map = Map(rows: 9, columns: 16, numPlayers: 1, numEnemies: 1)
    map.populateMap(noWalk: [(0, 0)])
    tileViews = [[MapTileView]]()
    playerViews = [CharacterView]()
    enemyViews = [CharacterView]()
    let backgroundFrame = UIScreen.mainScreen().bounds
    view = UIView(frame: backgroundFrame)
    let buttonWidth = (backgroundFrame.width - 50) / CGFloat(map.columns)
    let buttonHeight = (backgroundFrame.height - 50) / CGFloat(map.rows)
    for i in 0..<map.columns {
      tileViews.append([MapTileView]())
      for j in 0..<map.rows {
        let frame = CGRect(x: 25 + CGFloat(i) * buttonWidth,
          y: 25 + CGFloat(j) * buttonHeight,
          width: buttonWidth,
          height: buttonHeight)
        let newTile = MapTileView(tile: map.tileAt((i, j)), frame: frame)
        map.tileAt((i, j)).view = newTile
        newTile.layer.borderColor = UIColor.blackColor().CGColor
        newTile.layer.borderWidth = 1.5
        view.addSubview(newTile)
        newTile.addTarget(self, action: "tileSelected:", forControlEvents: .TouchUpInside)
        tileViews[i].append(newTile)
      }
    }
    for player in map.players {
      let start = tileViewAt(player.position)
      let charView = CharacterView(character: player, frame: start.frame)
      view.addSubview(charView)
      charView.addTarget(self, action: "playerSelected:", forControlEvents: .TouchUpInside)
      playerViews.append(charView)
    }
    for enemy in map.enemies {
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
    let charView = playerViews[0]
    UIView.animateWithDuration(0.7, animations: {
      charView.center = sender.center
    })
  }
  
  func playerSelected(sender: CharacterView) {
    println("Player was selected")
  }
  
  func enemySelected(sender: CharacterView) {
    println("Enemy was selected")
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
