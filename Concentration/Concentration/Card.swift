//
//  Card.swift
//  Concentration
//
//  Created by Vicatechnology on 25/01/22.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int {
        return identifier
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier//left hand side == right hand side
    }
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int //usando el protocolo hashable, como se va a acceder directamente a la carta y no a su identificador, entonces ya no se necesita que esta variable sea pùblica sino que solo serà necesario acceder a ella desde su estructura pero no desde afuera.
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        Card.identifierFactory += 1
        return Card.identifierFactory
    }
    
    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
}
