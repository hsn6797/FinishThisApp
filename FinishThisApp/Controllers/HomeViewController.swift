//
//  HomeViewController.swift
//  FinishThisApp
//
//  Created by Asad on 27/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    
    var quizList: [Quiz] = []
    
    var USERID = ""
    

    @IBOutlet weak var QuizTableViewController: UITableView!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("USERIDH:: "+USERID)
        
        
        
        //        Navigation Work HERE::::
        
        
        let MenuButton = UIButton(type: .custom)
        MenuButton.setImage(UIImage(named: "menu"), for: .normal)
        MenuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        MenuButton.addTarget(self, action: #selector(MenuOpen), for: .touchUpInside)
        let MenuItem = UIBarButtonItem(customView: MenuButton)

        self.navigationItem.rightBarButtonItem = MenuItem

        self.navigationItem.hidesBackButton = true

        let logo = UIImage(named: "logoT.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        // get all quizes list from firebase
        loadAllQuizes()
        
////////////**********************/////////////////
        // Do any additional setup after loading the view.
    }
    
    func loadAllQuizes(){
        Firestore.firestore().getQuezies(completionHandler: {
            quizes in
            self.quizList = quizes
            self.QuizTableViewController.reloadData()
//            for q in quizes {
//                print(q.QuizName)
//
//            }
        })
        
    }
    

    @objc func MenuOpen(){
        
        
        let alertViewByButton = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      
        alertViewByButton.addAction(UIAlertAction(title: "LeaderBoard", style: .default, handler: self.LeaderBoardClicked))
        alertViewByButton.addAction(UIAlertAction(title: "Settings", style: .default, handler: self.SettingClicked))
        alertViewByButton.addAction(UIAlertAction(title: "Contact Us", style:.default, handler:self.ContactUsClicked))
        alertViewByButton.addAction(UIAlertAction(title: "Privacy/T&C's", style:.default, handler:self.PrivacyClicked))
        alertViewByButton.addAction(UIAlertAction(title: "About Us", style:.default, handler:self.AboutClicked))
        alertViewByButton.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertViewByButton,animated: true,completion: nil)
        
    }
    
    

    
    func LeaderBoardClicked(alert:UIAlertAction){
        
        print("leader Clicked")
        
        let sb = UIStoryboard(name: "Home",bundle: nil)
        if let screen = sb.IIVC(vc:LeaderBoardQuizViewController(),id: "LBQ_VC"){
            self.navigationController!.pushViewController(screen, animated: true)
        }

    }
    
    func SettingClicked(alert:UIAlertAction){
        
        print("setting Clicked")
        
        let sb = UIStoryboard(name: "Home",bundle: nil)
        if let screen = sb.IIVC(vc:POPSettingViewController(),id: "popView"){
            self.navigationController!.pushViewController(screen, animated: true)
        }

    }
    
    func ContactUsClicked(alert:UIAlertAction){
        print("contact Clicked")
        let sb = UIStoryboard(name: "Home",bundle: nil)
        if let screen = sb.IIVC(vc: ContactUSViewController(),id: "Contact_VC"){
            self.navigationController?.pushViewController(screen, animated: true)
        }

        
    }
    
    func AboutClicked(alert:UIAlertAction){
        print("ABout Clicked")

        let sb = UIStoryboard(name: "Home",bundle: nil)
        if let screen = sb.IIVC(vc: AboutViewController(),id: "About_VC"){
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
    func PrivacyClicked(alert:UIAlertAction){
        
        print("Privacy Clicked")
        let sb = UIStoryboard(name: "Home",bundle: nil)
        if let screen = sb.IIVC(vc: PrivacyViewController(),id: "Privacy_VC"){
            self.navigationController?.pushViewController(screen, animated: true)
        }

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! HomeTableViewCell
        let quiz = quizList[indexPath.row]
        cell.quizB.setTitle(quiz.QuizName, for: .normal)
        
        cell.quizB.tag = indexPath.row
        //        cell.DetailButton.indexPath = indexPath
        cell.quizB.addTarget(self, action: #selector(performTask(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func performTask(sender: UIButton){
        print("Quiz Button Pressed -> " + self.quizList[sender.tag].QuizName )
        
        let sb = UIStoryboard(name: "Home",bundle: nil)
        if let screen = sb.IIVC(vc: QuestionsViewController(),id: "Ques_VC"){
            screen.quizObj = self.quizList[sender.tag]
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }

}