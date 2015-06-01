//
//  Character.swift
//  Practice Game
//
//  Created by Dante Natoli on 6/1/15.
//  Copyright (c) 2015 Dante Natoli. All rights reserved.
//

import UIKit

class Character: NSObject {
    var health: Int = 0
    var numMoves: Int = 0
    var damage: Int = 0
    var name: String = ""
    var space: Int = 0
    
    init(player name: String, index: Int) {
        health = 100
        numMoves = 4
        damage = 25
        self.name = name
        space = index
    }
    
    init(enemy name: String, index: Int) {
        health = 75
        numMoves = 3
        damage = 10
        self.name = name
        space = index

    }

    func dealDamage(target: Character) {
        target.takeDamage(damage)
    }
    
    func takeDamage(amount: Int) {
        health -= amount
    }
    
    func moveToSpace(index: Int) {
        space = index
        
    }
    
}
