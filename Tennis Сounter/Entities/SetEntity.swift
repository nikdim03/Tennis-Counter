//
//  SetEntity.swift
//  Tennis Сounter
//
//  Created by Dmitriy on 2/17/23.
//

import Foundation
import RealmSwift

class SetEntity: Object {
    @objc dynamic var player1SetScore: Int = 0
    @objc dynamic var player2SetScore: Int = 0
    let games = List<GameEntity>()
}
