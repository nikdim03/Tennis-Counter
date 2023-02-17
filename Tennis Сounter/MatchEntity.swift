//
//  MatchEntity.swift
//  Tennis Сounter
//
//  Created by Dmitriy on 2/16/23.
//

import Foundation
import RealmSwift

class MatchEntity: Object {
    @objc dynamic var time = ""
    let sets = List<SetEntity>()
}

class SetEntity: Object {
    @objc dynamic var player1SetScore: Int = 0
    @objc dynamic var player2SetScore: Int = 0
    let games = List<GameEntity>()
}

class GameEntity: Object {
    @objc dynamic var player1GameScore: Int = 0
    @objc dynamic var player2GameScore: Int = 0
    @objc dynamic var gameInProgress: Bool = false
}
