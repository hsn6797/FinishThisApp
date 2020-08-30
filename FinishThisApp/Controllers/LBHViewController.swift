//
//  LBHViewController.swift
//  FinishThisApp
//
//  Created by Asad on 29/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit
import FirebaseFirestore
class LBHViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   

    var quizObj = Quiz()
    var leaderboardList: [leaderUser] = []

    @IBOutlet weak var LBH_tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target:self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.title = "Score"
        
        self.loadAllLeaderboards()

        // Do any additional setup after loading the view.
    }
    
    func loadAllLeaderboards(){
        Firestore.firestore().getLeaderboardsQuizName(quizObj.QuizName, completionHandler: {
            leaderboards in
            self.leaderboardList = leaderboards.sorted(by: { $0.streak > $1.streak })
            
            self.LBH_tableView.reloadData()
            
        })
        
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leaderboardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! LHS_TableViewCell
        cell.userName.text = self.leaderboardList[indexPath.row].userName
        cell.scoreLbl.text = self.leaderboardList[indexPath.row].streak
        return cell
    }
    
}
