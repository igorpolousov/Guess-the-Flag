//
//  ViewController.swift
//  Guess the Flag
//  Day 19,20 and 21
//  Created by Igor Polousov on 16.06.2021.
//

import UIKit

class ViewController: UIViewController  {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var attemptsCounter = 0
    // Максимальное количество очков игрока
    var highScore = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries.append("estonia")
        countries.append("france")
        countries.append("germany")
        countries.append("ireland")
        countries.append("italy")
        countries.append("monaco")
        countries.append("nigeria")
        countries.append("poland")
        countries.append("russia")
        countries.append("spain")
        countries.append("uk")
        countries.append("us")
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.darkGray.cgColor
        button2.layer.borderColor = UIColor.darkGray.cgColor
        button3.layer.borderColor = UIColor.darkGray.cgColor
        
        askQuestion()
        
        // Добавил кнопку в navigation bar справа, функция showScore() ниже
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showScore))
        
        let defaults = UserDefaults.standard
        if let savedHighScore = defaults.object(forKey: "highScore") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                highScore = try jsonDecoder.decode(Int.self, from: savedHighScore)
            } catch  {
                print("Failed to load High Score")
            }
        }
    }
    
   
    
    func askQuestion(action: UIAlertAction! = nil) {
        
        countries.shuffle()
        // Поскольку для выбора флагов для размещения на кнопках выбраны названия стран с индексами от 0 до 2, делаем генерацию случайного числа от 0 до 2
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        // Покажет название одного из выбранного случайных образом флагов в заголовке таблицы
        title = "\(countries[correctAnswer].uppercased()) Score = \(score)"
        print(attemptsCounter)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var highScoreTitle: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That's flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        attemptsCounter += 1
        
        let ac = UIAlertController(title: title , message: "Your score is \(score)", preferredStyle: .alert)
        
        if attemptsCounter < 10 {
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        } else {
            if score > highScore {
                highScore = score
                save()
                highScoreTitle = "You have a new High Score: \(highScore)! "
            } else {
                highScoreTitle = "High score is \(highScore)"
            }
            ac.title = "Game over"
            ac.message = "Number of attempts is maximum(10). Your score is \(score).\n  \(highScoreTitle)"
            ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: askQuestion))
            attemptsCounter = 0
            score = 0
            
        }
        present(ac, animated: true)
    }
   
    // Функция которая показывает alert controller
    @objc func showScore() {
        
        // Задаём контроллёр alert controller - ac
        let ac = UIAlertController(title: "Your current High score:", message: "\(highScore)", preferredStyle: .alert)
        
        // Задаем что будет на кнопке alert controller - ac
        ac.addAction(UIAlertAction(title: "Done", style: .default))
        
        // Указываем что надо показать ac
        present(ac, animated: true)
    }
    
    func save() {
       let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(highScore){
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: "highScore")
        } else {
            print("Failed to save countries")
        }
    }
}

