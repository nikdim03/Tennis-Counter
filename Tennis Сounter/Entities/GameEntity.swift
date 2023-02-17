//
//  GameEntity.swift
//  Tennis Сounter
//
//  Created by Dmitriy on 2/17/23.
//

import Foundation
import RealmSwift

class GameEntity: Object {
    @objc dynamic var player1GameScore: Int = 0
    @objc dynamic var player2GameScore: Int = 0
    @objc dynamic var gameInProgress: Bool = false
}
