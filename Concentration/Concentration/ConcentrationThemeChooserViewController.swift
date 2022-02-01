//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Vicatechnology on 31/01/22.
//

import UIKit

// Esta clase es para escoger el tema de las tarjeticas. Si es deportes, entonces las tarjetas se voltean y muestran cosas de deportes. Si es faces se muestra... caritas? si es Animales, se muestran animales y asì :D

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    let themes = [
        "Sports": "⚽️🏀🏈⚾️🥎🎾🏐🏉🥏🎱🏓🏸",
        "Animals": "🐶🐨🐭🐹🦊🐰🐻🐸🐤🐵🐷🐮",
        "Faces": "🤪😁😒😏😎🤬🤯🥺🤫😮🙄💀"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController (_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme  == nil {
                return false
            }
        }
        return true
    }
    
    // para hacer los segues desde el còdigo
    // aqui es la primera conexiòn
    
    @IBAction func ChangeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //el sender sera la palabra que dice cual es el tema
        if segue.identifier == "Choose Theme" {
           // if let button = sender as? UIButton { // como el sender es de tipo Any, toca castearlo a que sea un UIButton para hacerlo botòn y se pueda trabajar con èl, pero lo comento porque se puede dejar todo en una sola linea (la que seguia que era if let themeName = button.currentTitle, if let theme = themes[themeName], pero ahora se reemplaza el botton y queda:
                if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] { // se usa este if let theme por si el tema que llega no se encuentra en el diccionario de temas
                    if let cvc = segue.destination as? ConcentrationViewController { // aca se esta preparando con el segue para que siga al view controller de concentration, o algo asì D:
                        cvc.theme = theme
                        lastSeguedToConcentrationViewController = cvc
                    }
                }
            }
    }
}
