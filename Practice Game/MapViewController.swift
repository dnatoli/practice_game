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
  
  override func loadView() {
    map = Map(height: 9, width: 16)
    map.populateMap(noWalk: [])
    tileViews = [[MapTileView]]()
    let backgroundFrame = UIScreen.mainScreen().bounds
    view = UIView(frame: backgroundFrame)
    let buttonWidth = backgroundFrame.width / CGFloat(map.width)
    let buttonHeight = backgroundFrame.height / CGFloat(map.height)
    for i in 0..<map.width {
      tileViews.append([MapTileView]())
      for j in 0..<map.height {
        let frame = CGRect(x: CGFloat(i) * buttonWidth,
          y: CGFloat(j) * buttonHeight,
          width: buttonWidth,
          height: buttonHeight)
        let newTile = MapTileView(frame: frame, x: i, y: j)
        newTile.layer.borderColor = UIColor.blackColor().CGColor
        newTile.layer.borderWidth = 1.5
        view.addSubview(newTile)
        newTile.addTarget(self, action: "tileSelected:", forControlEvents: .TouchUpInside)
        tileViews[i].append(newTile)
      }
    }
  }
  
  func tileSelected() {
    
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
