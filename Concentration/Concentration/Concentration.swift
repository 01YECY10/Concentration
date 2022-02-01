//
//  Concentration.swift
//  Concentration
//
//  Created by Vicatechnology on 25/01/22.
//

import Foundation
//Este es el modelo
struct Concentration {
    
    private(set) var cards = [Card]()
    
    //esto es para encontrar el indice de la carta que està volteada
    //esta se convertirà en una variable computada (propiedad computada), y ademas el 27/01/22 se convertirà usara un closure para que haga su funciòn de revisar cual carta esta volteada :D
    var indexOfOneAndOnlyOneFaceUpCard: Int? {
        get {
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly //aplicando la extensiòn del protocolo
            
            /*podriamos no usar esta constante y solo retornar a partir de la extension del protocolo oneAndOnly
            let faceUpCardIndices = cards.indices.filter {cards[$0].isFaceUp} //esta constante sera un array de los indices de un arreglo :'v o sea un array.index que tiene un alias de int... por eso es que los array se pueden indexar por enteros, cosa diferente qeu con los string, pues string.index no es un int
            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first :nil //aqui si la constante es igual a 1 retornarà al unico valor que tiene el array, y si no, retornara nil, porque habràn cero cartas volteadas o habran muchas*/
            
            //se calculará el índice que la tarjeta
            /*var foundIndex: Int? //it's gonna be an optional int
            //se buscará entre todas las tarjetas y ver si puedo encontrar la que esté volteada, por lo que se usará un for para buscar en todos los índices:
            for index in cards.indices {
                if cards[index].isFaceUp { //si encuentro la que esté volteada
                    if foundIndex == nil { //si todavìa no la encuentro
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex*/
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue) //newValue es el nombre del argumento que tiene el set por defecto, pero se puede cambiar si asì se prefiere
            }
        }
    }
    
    //se le agrega mutating porque ya concentracion no es una clase si no una estructura.
    mutating func chooseCard(at index: Int) { //será público porque de otra manera no se podrían escoger las cartas
        /*if cards[index].isFaceUp {
            cards[index].isFaceUp = false
        } else {
            cards[index].isFaceUp = true
        }*/
        //playing the game:
        //agregando un assert, para cuando por alguna razòn llegue un índice = -1, o que sea 100 pero solo hay 10 cartas, entonces se lanza un mensaje cuando se crashee (cuando falle pues D:!):
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        //cuando se escogen dos cartas que coinciden, se ignoran:
        if !cards[index].isMatched {//cuando no coinciden
            if let matchIndex = indexOfOneAndOnlyOneFaceUpCard, matchIndex != index {
                //ver si las cartas coinciden
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                //indexOfOneAndOnlyOneFaceUpCard = nil //convirtiendo esto en una propiedad computda, aquí ya no se tendría que convertir a nil, porque se está computando cada vez que se pregunta por ella y al tiempo se está enviando su valor, ni tampoco se necesitaría el código dentro del else, excepto la lìnea de indexOfOneAndOnlyOneFaceUpCard = index
            } else {
                //o no hay cartas, o se han volteado dos
                /*for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true*/
                indexOfOneAndOnlyOneFaceUpCard = index
            }
        }
    }
    
    // será público porque de otra manera no se inicializaría el juego
    init(numberOfPairsOfCards: Int) {
        //agregando una aserciòn cuando las parejas tienen un número menor a cero:
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        //TODO: shuffle the cards
    }
}

//ahora se va a mejorar lo de las cartas volteadas agregando una extensiòn de un protocolo:
extension Collection { //Collection es un tipo genèrico
    var oneAndOnly: Element? {//retornara la ùnica cosa en la coleccion o retornara nil (el elemento tambièn serà de tipo generico
        return count == 1 ? first : nil
    }
}
