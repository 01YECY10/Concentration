//
//  ViewController.swift
//  Concentration
//
//  Created by Vicatechnology on 24/01/22.
//

import UIKit

class ConcentrationViewController: VCLLoggingViewController {

    //relaciòn entre el controlador y el modelo (aqui ya se estàn comunicando):
    //lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2) //calcular el numero de pares de cartas. esta es una propiedad que se deriva de algo más (el conteo de cartas) por eso se puede transformar en una propiedad computada:
    
    //aquì se define de nuevo la variable game, solo que esta vez numberOfPairsOfCards será una propiedad computable:
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards) //es una propiedad privada, porque numberOfPairsOfCards está intimamente atada a la UI, así que si se deja publico, habría que hacer público algo para especificar el nùmero de tarjetas que aceptamos, pero esto se hace en la interface builder, asì que nada uqe ver
    
    var numberOfPairsOfCards: Int {
        //solo tiene un get (implicito) porque serà solo de lectura, así que no se implementará el set. Si tuviera el set, obligatoriamente se tiene que implementar un get que le corresponda:
        return (cardButtons.count + 1) / 2 //este se queda pública, porque de todas maneras no se puede cambiar, pero sí cualquier puede solicitar el número de pares de cartas y no hay lío
    }
    private(set) var flipCount: Int = 0 { //lo mismo con esta, cualquiera puede pedir cuàndo flips se han hecho, pero para nada se pueden cambiar
        didSet {
            /*let attributes: [NSAttributedString.Key: Any] = [//si se deja esto dentro de este didSet, la primera vez que aparezca la palabra flips no tendra las caracteristicas asociadas a ella, asì que se crea una funcion para eso y se saca todo lo del didSet y se pone allà
                .strokeWidth : 5.0,
                .strokeColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            ]
            let attributeString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
            //flipCountLabel.text = "Flips: \(flipCount)"
            flipCountLabel.attributedText = attributeString*/
            
            //acà se llama a la funcion updateFlipCountLabel para que haga lo suyo con las letras
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [//aquì se pone lo que dije arriba :V
            .strokeWidth : 5.0,
            .strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        let attributeString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        //flipCountLabel.text = "Flips: \(flipCount)"
        flipCountLabel.attributedText = attributeString
    }
    
    @IBOutlet private var cardButtons: [UIButton]! //los outlets siempre seràn privados, porque es una implementaciòn que pertenece al viewControler
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel() //se puede llamar acà, porque aquí esta la conexión entre el label y la configuraciòn de esta
        }
    }
    
    //aquì es donde en realidad se escogen las cartas:
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            //En vez de usar este flipCard, usaremos:
            //flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
            //print("cardNumber = \(cardNumber)")
            game.chooseCard(at: cardNumber) //aquì se cambia nuestra vista, por lo que esta debe ser actualizada:
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons")
        }
        
        //flipCountLabel.text = "Flips: \(flipCount)"
        //flipCard(withEmoji: "👻", on: sender)
    }
    
    //Buscarà las tarjetas, se asegurarà de que las cartas coincidan o no
    private func updateViewFromModel() { //esto tambièn serà privado porque es una implementaciòn interna de la UI
        if cardButtons != nil { // se deja todo el for que viene dentro de este if, porque con este if se garantiza que no se crashee cuando las cartas sean nil al momento de solicitar este view controller
            for index in cardButtons.indices { //indices es un método de los arrays que devuelve un rango contable de todos los indices del array
                let button = cardButtons[index] //let es para definir constantes que no pueden modificar su valor
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                }
            }
        }
        
    }
    
    // 31/01/22: se empieza a trabajar con los MVC's
    // aqui para cambiar el tema:
    var theme: String? {
        // esto es para que aparezcan los emojis, que ahora seràn parte del tema halloween
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    //27/01/22 se implementa un protocolo
    //lo que viene a continuaciòn es un ejemplo de cuando dejar algo privado para ver en el tiempo si es posible ponerlos publicos o no
   // private var emojiChoices = ["💀","🤡","👻","😈","🎃","👽","🦇","🕸"]
    private var emojiChoices = "💀🤡👻😈🎃👽🦇🕸" //los emojis ahora son un string, y para ser asignados se les asigna un ìndice a partir del las funciones del sting (tipo string.index y asì)
    
    //El diccionario de emojis:
    private var emoji = [Card:String]() //la llave es la carta, el valor es el emoji
    
    private func emoji(for card: Card) -> String {
        //agregando emojis al diccionario:
        if emoji[card] == nil , emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random) //aqui se asignan los indices de forma random y se hace usando starIndex indica el primer caracter del string y se compensa con un random int
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))//aqui toca convertirlo a string porque randomStringImdex es unc aracter
        }
        return emoji[card] ?? "?"
    }
    
    
    //@IBAction func touchSecondCard(_ sender: UIButton) {
      //  flipCount += 1
        //flipCountLabel.text = "Flips: \(flipCount)"
      //  flipCard(withEmoji: "🎃", on: sender)
    //}
    /*func flipCard(withEmoji emoji: String, on button: UIButton) {
        //print("flipCard(withEmoji: \(emoji)")
        if button.currentTitle == emoji {
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        } else {
            button.setTitle(emoji, for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }*/

}
//la extension es para escoger un numero aleatorio que estarà entre 0 y él mismo
extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
