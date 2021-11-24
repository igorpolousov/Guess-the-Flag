//
//  ViewController.swift
//  Guess the Flag
//  Day 19,20 and 21
//  Created by Igor Polousov on 16.06.2021.
//

import UIKit
import NotificationCenter

class ViewController: UIViewController, UNUserNotificationCenterDelegate  {
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
        
        registerLocal()
        
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
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.badge, .sound]) { granted, error in
            if granted {
                self.scheduleLocal()
            } else {
                print("Get off")
            }
        }
    }
    
    func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Play me again"
        content.body = "Wo plays often plays better"
        content.categoryIdentifier = "AAA"
        content.sound = .default
        
        var dateComponent = DateComponents()
        dateComponent.day = 1
        print(dateComponent)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let play = UNNotificationAction(identifier: "play", title: "Play Flags", options: .foreground)
        let category = UNNotificationCategory(identifier: "AAA", actions: [play], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        
        countries.shuffle()
        
        button1.alpha = 0
        button2.alpha = 0
        button3.alpha = 0
        
        // Поскольку для выбора флагов для размещения на кнопках выбраны названия стран с индексами от 0 до 2, делаем генерацию случайного числа от 0 до 2
        correctAnswer = Int.random(in: 0...2)
        UIView.animate(withDuration: 0.5, delay: 0, options: []) {
            self.button1.alpha = 1
            self.button2.alpha = 1
            self.button3.alpha = 1
        }

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
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: []) {
                sender.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                sender.transform = .identity
            }
            
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.present(ac, animated: true)
        }
        //present(ac, animated: true)
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

