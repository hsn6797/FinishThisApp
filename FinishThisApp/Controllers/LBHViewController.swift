//
//  LBHViewController.swift
//  FinishThisApp
//
//  Created by Asad on 29/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit
import FirebaseFirestore
import GoogleMobileAds
class LBHViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   

    var quizObj = Quiz()
    var leaderboardList: [leaderUser] = []
    
    @IBOutlet weak var admobHSView: UIView!
    
    
    var bannerView: GADBannerView!
    
    var BannerID_5  = "ca-app-pub-0653754342418962/5184012566"
    let GadSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 50))
    
    
    
    @IBOutlet weak var LBH_tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        bannerView = GADBannerView(adSize: GadSize)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = BannerID_5
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self as? GADBannerViewDelegate
        
        
        
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target:self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.title = "Score"
        
        self.loadAllLeaderboards()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
  
        admobHSView.addSubview(bannerView)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        bannerView.heightAnchor.constraint(equalTo: admobHSView.heightAnchor).isActive = true
        bannerView.widthAnchor.constraint(equalTo: admobHSView.widthAnchor).isActive = true
        bannerView.leadingAnchor.constraint(equalTo: admobHSView.leadingAnchor).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: admobHSView.trailingAnchor).isActive = true
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    func loadAllLeaderboards(){
        Firestore.firestore().getLeaderboardsQuizName(quizObj.QuizName, completionHandler: {
            leaderboards in
            self.leaderboardList = leaderboards.sorted(by:{ Int($0.streak)! > Int($1.streak)!})
            
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
