//
//  ViewController.swift
//  Project 2
//
//  Created by Keertiraj Laxman Malik on 14/01/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionCount = 0
    var highestScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        askQuestion()
        
        displayBorder()
        
        let defaults = UserDefaults.standard
        
        if let savedScore = defaults.object(forKey: "score") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                highestScore = try jsonDecoder.decode(Int.self, from: savedScore)
            } catch {
                print("Failed to get the score.")
            }
        }
    }
    
    func askQuestion(action: UIAlertAction! = nil){
        if questionCount == 10 {
            
            if score > highestScore {
                displayAlert(title: "Highest Score")
                save()
            } else {
                displayAlert(title: "Final Score")
            }
        } else {
            countries.shuffle()
            
            button1.setImage(UIImage(named: countries[0]), for: .normal)
            button2.setImage(UIImage(named: countries[1]), for: .normal)
            button3.setImage(UIImage(named: countries[2]), for: .normal)
            
            correctAnswer = Int.random(in: 0...2)
            title = countries[correctAnswer].uppercased() + " Your score is \(score)"
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String?
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That's flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        displayAlert(title: title)
        questionCount += 1
    }
    
    func displayAlert(title: String?){
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    func displayBorder() {
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(score) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "score")
        } else {
            print("Failed to save score.")
        }
    }
}
