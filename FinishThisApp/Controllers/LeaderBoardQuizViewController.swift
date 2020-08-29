//
//  LeaderBoardQuizViewController.swift
//  FinishThisApp
//
//  Created by Asad on 29/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit

class LeaderBoardQuizViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var LBQ_tableView: UITableView!
    override func viewDidLoad() {

        super.viewDidLoad()
        
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target:self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.title = "Leader Board"

        // Do any additional setup after loading the view.
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! leaderBoardQTableViewCell
        cell.quizName.text = "GEnerallera"
        
        return cell
        
    }
    
    

    

}
