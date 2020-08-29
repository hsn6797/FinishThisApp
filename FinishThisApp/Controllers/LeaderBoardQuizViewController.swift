//
//  LeaderBoardQuizViewController.swift
//  FinishThisApp
//
//  Created by Asad on 29/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit
import FirebaseFirestore

class LeaderBoardQuizViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var quizList: [Quiz] = []
    
    @IBOutlet weak var LBQ_tableView: UITableView!
    override func viewDidLoad() {

        super.viewDidLoad()
        
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target:self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.title = "Leader Board"

        // Do any additional setup after loading the view.
        // get all quizes list from firebase
        loadAllQuizes()
    }
    
    func loadAllQuizes(){
        Firestore.firestore().getQuezies(completionHandler: {
            quizes in
            self.quizList = quizes
            self.LBQ_tableView.reloadData()
            
        })
        
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! leaderBoardQTableViewCell
        cell.quizName.text = self.quizList[indexPath.row].QuizName

        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Quiz Button Pressed -> " + self.quizList[indexPath.row].QuizName )

        let sb = UIStoryboard(name: "Home",bundle: nil)
        if let screen = sb.IIVC(vc: LBHViewController(),id: "LBH_VC"){
            screen.quizObj = self.quizList[indexPath.row]
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
    
//    @objc func performTask(sender: UIButton){
//        print("Quiz Button Pressed -> " + self.quizList[sender.tag].QuizName )
//
//        let sb = UIStoryboard(name: "Home",bundle: nil)
//        if let screen = sb.IIVC(vc: LBHViewController(),id: "LBH_VC"){
//            screen.quizObj = self.quizList[sender.tag]
//            self.navigationController?.pushViewController(screen, animated: true)
//        }
//    }

}
