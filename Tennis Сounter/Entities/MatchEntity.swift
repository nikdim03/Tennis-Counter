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
