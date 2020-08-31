//
//  LeaderBoardQuizViewController.swift
//  FinishThisApp
//
//  Created by Asad on 29/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit
import FirebaseFirestore
import GoogleMobileAds

class LeaderBoardQuizViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var quizList: [Quiz] = []
    
    @IBOutlet weak var LBQ_tableView: UITableView!
    
    @IBOutlet weak var admobLeaderView: UIView!
    
    var bannerView: GADBannerView!
    
    var BannerID_4  = "ca-app-pub-3940256099942544/2934735716"
    let GadSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 50))
    
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        
        bannerView = GADBannerView(adSize: GadSize)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = BannerID_4
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self as? GADBannerViewDelegate
        
        
        
        
        
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target:self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.title = "Leader Board"

        // Do any additional setup after loading the view.
        // get all quizes list from firebase
        loadAllQuizes()
    }
    
    
    
    
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        admobLeaderView.addSubview(bannerView)
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
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
        tableView.deselectRow(at: indexPath, animated: true)
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
