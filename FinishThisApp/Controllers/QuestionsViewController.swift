//
//  QuestionsViewController.swift
//  FinishThisApp
//
//  Created by Asad on 27/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FBSDKShareKit

class QuestionsViewController: UIViewController {

    var quizObj = Quiz()
    var questionList: [Question] = []
    var Buttons: [UIButton] = []
    var currentQuestionNo = 0
    var isCorrect = false
    var streakCount = 0
    var timerIsValidate = false
    
    //TIMER
    
    var timer:Timer?
    var timeLeft = 30

    
    @IBOutlet weak var timerLable: UILabel!
    
    @IBOutlet weak var QuestuionLabel: UILabel!
    
    @IBOutlet weak var StreakLabel: UILabel!
    
    @IBOutlet weak var AnswerBtn1: UIButton!
    
    @IBOutlet weak var AnswerBtn2: UIButton!
    
    @IBOutlet weak var AnswerBtn3: UIButton!
    @IBOutlet weak var AnswerBtn4: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AnswerBtn1.layer.cornerRadius = 10
        AnswerBtn2.layer.cornerRadius = 10
        AnswerBtn3.layer.cornerRadius = 10
        AnswerBtn4.layer.cornerRadius = 10

        
        //Timer HERE::::
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        // Nav work:::
        
        
        let reloadBtn = UIBarButtonItem(barButtonSystemItem: .refresh , target: self , action: #selector(reloadQuiz))
        self.navigationItem.leftBarButtonItem = reloadBtn
        self.navigationItem.title = "Quiz"

        // Put buttons in List
        self.AnswerBtn1.tag = 0
        self.AnswerBtn2.tag = 1
        self.AnswerBtn3.tag = 2
        self.AnswerBtn4.tag = 3
        self.Buttons.append(self.AnswerBtn1)
        self.Buttons.append(self.AnswerBtn2)
        self.Buttons.append(self.AnswerBtn3)
        self.Buttons.append(self.AnswerBtn4)
        self.StreakLabel.text = String(streakCount)
        
        
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        Firestore.firestore().getQuestionByQuizID(quizObj.QuizID, completionHandler: {
            questions in
            
            if questions.count > 0{
                self.questionList = questions.shuffled()
                myGroup.leave()
            }
            else{
                self.timerLable.isHidden = true
                self.timer?.invalidate()
                self.Alert(Message: "Catch you later !", title: "No Data Available")
            }
        
            
        })
        
        myGroup.notify(queue: .main) {
            print("Got Questions from Firebase")
                self.setQuestionUI()
        }
        
    }// View Did load
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        timerLable.text = "\(timeLeft)"
        
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            
            if streakCount > 0 {
                // Save record into DB
                putScoreInLeaderboard()
            }
            Alert(Message: "You did'nt answer,\nBetter Luck, Next time", title: "Times Out")
        }
    }
    
    @objc func reloadQuiz(){
        print("Reload your Quiz here")
        currentQuestionNo = 0
        self.questionList = self.questionList.shuffled()
        self.streakCount = 0
        self.setQuestionUI()
        self.timeLeft = 30
        self.timer?.fire()
        
    }
    
    func Alert (Message: String,title:String){
        
        let alert = UIAlertController(title: title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: alerbtn))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func alerbtn (_:UIAlertAction){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func AlertOnFinish (Message: String,title:String){
        
        let alert = UIAlertController(title: title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: alerOnFinishbtn))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func alerOnFinishbtn (_:UIAlertAction){
        if streakCount > 0 {
            putScoreInLeaderboard()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    func setQuestionUI(){
        // reset buttons states
        if timerIsValidate{
            timeLeft = 30
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        }
      
        
        ////////////////////
        isCorrect = false
        self.AnswerBtn1.resetButton()
        self.AnswerBtn2.resetButton()
        self.AnswerBtn3.resetButton()
        self.AnswerBtn4.resetButton()

        // set Question label
        QuestuionLabel.text = String(currentQuestionNo + 1) + " - " + self.questionList[self.currentQuestionNo].Question.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // get wrong answers in list
        var wrongAnswers: [String] = []
        var wrongAnsCount = 0
        wrongAnswers.append(self.questionList[self.currentQuestionNo].wrongAns1)
        wrongAnswers.append(self.questionList[self.currentQuestionNo].wrongAns2)
        wrongAnswers.append(self.questionList[self.currentQuestionNo].wrongAns3)
        
        // generate the random position to display correct answer to button
        let number = Int.random(in: 0..<4)
        self.Buttons[number].setTitle(self.questionList[self.currentQuestionNo].correctAns, for: .normal)
        
        // set wrong answers to other buttons
        for n in 0..<self.Buttons.count {
            if self.Buttons[n].tag != number{
                if wrongAnsCount < 3{
                    self.Buttons[n].setTitle(wrongAnswers[wrongAnsCount], for: .normal)
                    wrongAnsCount += 1
                }
                
            }
        }
    }
    
    
    @IBAction func AnswerBtn1(_ sender: Any) {
        timer?.invalidate()
        timerIsValidate = true
        
        if AnswerBtn1.titleLabel?.text == self.questionList[self.currentQuestionNo].correctAns{
            AnswerBtn1.changeColor(color: UIColor.green, text: "Correct")
            isCorrect = true
            AnswerBtn4.disableButton()
            AnswerBtn2.disableButton()
            AnswerBtn3.disableButton()
            AnswerBtn1.disableButton()
        }else{
            AnswerBtn1.changeColor(color: UIColor.red, text: "Wrong")
            AnswerBtn4.disableButton()
            AnswerBtn2.disableButton()
            AnswerBtn3.disableButton()
            AnswerBtn1.disableButton()
        }
    }
    
    @IBAction func AnswerBtn2(_ sender: Any) {
        timer?.invalidate()
        timerIsValidate = true


        if AnswerBtn2.titleLabel?.text == self.questionList[self.currentQuestionNo].correctAns{
            AnswerBtn2.changeColor(color: UIColor.green, text: "Correct")
            isCorrect = true
            AnswerBtn2.disableButton()
            AnswerBtn3.disableButton()
            AnswerBtn1.disableButton()
            AnswerBtn4.disableButton()
        }else{
            AnswerBtn2.changeColor(color: UIColor.red, text: "Wrong")
            AnswerBtn2.disableButton()
            AnswerBtn3.disableButton()
            AnswerBtn1.disableButton()
            AnswerBtn4.disableButton()
        }
    }
    
    @IBAction func AnswerBtn3(_ sender: Any) {
        timer?.invalidate()
        timerIsValidate = true


        if AnswerBtn3.titleLabel?.text == self.questionList[self.currentQuestionNo].correctAns{
            AnswerBtn3.changeColor(color: UIColor.green, text: "Correct")
            isCorrect = true
            AnswerBtn2.disableButton()
            AnswerBtn3.disableButton()
            AnswerBtn1.disableButton()
            AnswerBtn4.disableButton()
        }else{
            AnswerBtn3.changeColor(color: UIColor.red, text: "Wrong")
            AnswerBtn2.disableButton()
            AnswerBtn3.disableButton()
            AnswerBtn1.disableButton()
            AnswerBtn4.disableButton()
        }
    }
    
    @IBAction func AnswerBtn4(_ sender: Any) {
        timer?.invalidate()
        timerIsValidate = true


        if AnswerBtn4.titleLabel?.text == self.questionList[self.currentQuestionNo].correctAns{
            AnswerBtn4.changeColor(color: UIColor.green, text: "Correct")
            isCorrect = true
            AnswerBtn2.disableButton()
            AnswerBtn3.disableButton()
            AnswerBtn1.disableButton()
            AnswerBtn4.disableButton()
        }else{
            AnswerBtn4.changeColor(color: UIColor.red, text: "Wrong")
            AnswerBtn2.disableButton()
            AnswerBtn3.disableButton()
            AnswerBtn1.disableButton()
            AnswerBtn4.disableButton()
        }
    }
    
    
    // Submit Button
    @IBAction func SubmitBtn(_ sender: Any) {
        if isCorrect {
            if currentQuestionNo < self.questionList.count {
                
                self.streakCount += 1
                self.StreakLabel.text = String(self.streakCount)
                
                self.currentQuestionNo += 1
                setQuestionUI()
            }
            else{
                self.AlertOnFinish(Message: "you successfully finished the quiz with result: "+String(streakCount), title: "Congrats!!!")
            }
        }else{
            // Save Information in DB userName with Score
            
            self.AlertOnFinish(Message: "you failed the quiz with result: "+String(streakCount), title: "Better luck next time")
}
        
    }
    
    @IBAction func shareFB(_ sender: Any) {
        
        shareInFacebook()
        
    }
    
    
     func shareInFacebook() {
        
        let image = captureScreen()
        let photo:FBSDKSharePhoto = FBSDKSharePhoto()
        
        photo.image = image
        photo.caption = "Paste url App url here"
        photo.isUserGenerated = true
        
        let content = FBSDKSharePhotoContent()
        content.photos = [photo];
        
        
        let dialog = FBSDKShareDialog()
        dialog.fromViewController = self
        dialog.shareContent = content
        dialog.mode = .native
        dialog.show()
    }
    
    func captureScreen() -> UIImage
    {
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0);
        
        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    func putScoreInLeaderboard(){
        
        guard let currentUser = Auth.auth().currentUser else{return}
        
        Firestore.firestore().getCurrentUser(userID: currentUser.uid , completionHandler:{
            user in
            
            let lUser = leaderUser()
            lUser.quizName = self.quizObj.QuizName
            lUser.userName = user.userName
            lUser.streak = String(self.streakCount)
            
            print("User:::\(lUser.quizName)and name\(lUser.userName)")
            
            Firestore.firestore().leaderboardExist(quizName: lUser.quizName, userName: lUser.userName, completionHandler: {
                leaderU in
              //  print("HAAAAAANNNN JIIIIII:::::::::::: "+(leaderU?.leadID)!)
                guard let lu = leaderU else {
                    print("ni mila")
                    lUser.leadID = String(Int.random(in: 0..<1000)) + currentUser.uid  + String(Int.random(in: 0..<800))
                    Firestore.firestore().add(lUser: lUser)
                    return
                    
                }
                print("mil gaya " + lu.leadID)
                lUser.leadID = lu.leadID
                Firestore.firestore().add(lUser: lUser)
                
                
                
            })
            self.navigationController?.popViewController(animated: true)
        })

    }
    
}
