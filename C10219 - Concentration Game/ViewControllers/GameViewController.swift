//
//  GameViewController.swift
//  C10219 - Concentration Game
//
//  Created by Tom Cohen on 16/04/2020.
//  Copyright © 2020 com.Tomco.iOs. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    //Deck Collection view/Users/user167774/Documents/10219/C10219 - Concentration Game/C10219 - Concentration Game/GameViewController.swift
    @IBOutlet weak var main_CV_cards: UICollectionView!
  
    
    //Deck init
    var deck = [Card]()
    var cardsTheme:String = "casino"
    var numberOfPairs:Int = 0

    //CardModel for Deck cards
    var model = CardModel()
    
    //Match related member
    var firstCardFlipped:IndexPath?
    
    //timer related members
    @IBOutlet weak var main_LBL_timer: UILabel!
    var timer:Timer?
    var timeElapsed:Int!
    
    override func viewDidLoad() {
        //OnCreate()
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true,animated: false)
        initGame(numberOfPairs,cardsTheme)
        //Easy = 8, Medium = 10, Hard = 15
    }
    
    //MARK: Game Logic:
    func checkMatch (_ secondCardFlipped:IndexPath)
    {
        let cell1 = main_CV_cards.cellForItem(at: firstCardFlipped!) as? CardCollectionViewCell
        let cell2 = main_CV_cards.cellForItem(at: secondCardFlipped) as? CardCollectionViewCell
        
        let card1 = deck[firstCardFlipped!.row]
        let card2 = deck[secondCardFlipped.row]
        
        if card1.imageName == card2.imageName {
            
            //set both as matched
            card1.isMatched=true
            card2.isMatched=true
            
            //remove both from screen
            cell1?.remove()
            cell2?.remove()
            
            //check if game ended
            isGameEnded()
            
        } else{
            //flip both back
            card1.isShown=false
            card2.isShown=false
            cell1?.flipBack()
            cell2?.flipBack()
        }
        
        if cell1 == nil{
            // for cases of cell1 being recycled and needed to be reloaded
            main_CV_cards.reloadItems(at: [firstCardFlipped!])
        }
        
        firstCardFlipped = nil
    }
    
    func isGameEnded(){
        var haveWon = true
        
        for card in deck {
            if card.isMatched == false
            {
                haveWon=false
                return
            }
        }
        
        let title = "Congratulations!"
        var message = "You've Won!"
        
        if haveWon{
            
            timer?.invalidate()
            message = message + "\nSorry, But It Wasn't Good Enough To Enter The High Scroes Table 😔"
            
            showAlert(title, message,(isHighScore(timeElapsed,numberOfPairs) ? true : false), timeElapsed)
        }
    }
    func isHighScore(_ timeElapsed:Int,_ numberOfPairs:Int) -> Bool
    {
        
        return false
    }
    func showAlert(_ title:String, _ message:String,_ requestName:Bool ,_ timeElapsed:Int)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Start Again!", style: .default, handler: {(alert: UIAlertAction!) in self.initGame(self.numberOfPairs,"casino")})
        alert.addAction(alertAction)
        present(alert,animated: true, completion: nil)
    }
    
    func initGame(_ numOfPairs:Int,_ theme:String)
    {
        deck = model.getDeck(numOfPairs, theme)
        
        timeElapsed = 0
        main_CV_cards.delegate = self
        main_CV_cards.dataSource = self
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerElapsedTime), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        firstCardFlipped = nil
        main_CV_cards.reloadData()
        
    }
    
    //MARK: Timer:
    @objc func timerElapsedTime() {
        timeElapsed += 1
    
        let seconds = String(format: "%02d", (timeElapsed%60))
        let minutes = String(format: "%02d", timeElapsed/60)

        main_LBL_timer.text = "\(minutes):\(seconds)"
    }
    
    // MARK: UICollectionView Related Protocols:
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deck.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Resize each card to be able to show it on low resolutions screens.
        
        // width:
        var width:CGFloat
        if (self.view.frame.size.width < self.view.frame.size.height){
        width = self.view.frame.size.width
        width = width - (10*10)
        let divisor = Int(sqrt(Double(deck.count)).rounded(.towardZero))
        // 16 -> 4*4, 20 -> 4*5, 30 -> 5*6
        print(divisor)
            width = width/CGFloat(divisor)}
        else{
            width = self.view.frame.size.height
                   width = width - (10*10)
                   let divisor = Int(sqrt(Double(deck.count)).rounded(.awayFromZero))
                   // 16 -> 8*2, 20 -> 10*2, 30 -> 10*3
                   print(divisor)
                       width = width/CGFloat(divisor)
        }
        print(width)
        
        //height:
        var height = width / 79
        height = height * 127.5
        print(height)
        
        //return values as CGSize
        return CGSize(width: width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //assign Cell in CollectionView To a card in deck.
        let cell = main_CV_cards.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        let card = deck[indexPath.row]
        
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //onClick()
        let cell = main_CV_cards.cellForItem(at: indexPath)  as! CardCollectionViewCell
        let card = deck[indexPath.row]
        
        if card.isShown == false && card.isMatched == false {
            cell.flip()
            card.isShown = true
            
            if firstCardFlipped == nil {
                firstCardFlipped = indexPath
            } else {
                checkMatch(indexPath)
            }
        }
    }
    
    // MARK: - Navigation
    //onBackPressed(), mimic the NavigationController Back action, with my custom back button.
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}