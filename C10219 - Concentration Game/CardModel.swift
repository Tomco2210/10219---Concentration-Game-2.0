//
//  CardModel.swift
//  C10219 - Concentration Game
//
//  Created by Tom Cohen on 27/04/2020.
//  Copyright © 2020 com.Tomco.iOs. All rights reserved.
//

import Foundation

class CardModel {
        
    func getDeck() -> [Card] {
        
        //create an array of cards
        var cardsArray = [Card]()
        
        //create pairs of cards
        for card in 1...8 {
            
            //create first card:
            let card1 = Card()
            card1.imageName = "symbol_\(card)"
            print(card1.imageName)
           
            //create second card:
            let card2 = Card()
            card2.imageName = "symbol_\(card)"
            print(card2.imageName)
           
            //append both cards to array
            cardsArray.append(card1)
            cardsArray.append(card2)
        }
        print("Cards in deck: \(cardsArray.count)")
        
        //suffle deck
        cardsArray.shuffle()
        for card in cardsArray{
            print(card.imageName)
        }
        
        //return array to main
        return cardsArray
    }
}
