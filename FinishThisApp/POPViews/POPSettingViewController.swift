//
//  POPSettingViewController.swift
//  FinishThisApp
//
//  Created by Asad on 27/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleMobileAds

class POPSettingViewController: UIViewController {

    @IBOutlet weak var ViewS: UIView!
    
    
    @IBOutlet weak var admobSettingView: UIView!
    
    var bannerView: GADBannerView!
    
    var BannerID_2  = "ca-app-pub-3940256099942544/2934735716"
    let GadSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 50))
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        bannerView = GADBannerView(adSize: GadSize)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = BannerID_2
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self as? GADBannerViewDelegate
        
        
        
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target:self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.title = "Settings"

        
        ViewS.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }
    
    
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        admobSettingView.addSubview(bannerView)
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func editProfilebtn(_ sender: Any) {
        
        
        let sb = UIStoryboard(name: "Main",bundle: nil)
        if let screen = sb.IIVC(vc: EditProfileViewController(),id: "Edit_VC"){
            self.navigationController?.pushViewController(screen, animated: true)
        }
        
    }
    @IBAction func logOutbtn(_ sender: Any) {
        
        SignOut()
    }
    @IBAction func RateourApp(_ sender: Any) {
        
        
    }
    @IBAction func backbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func SignOut(){
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        do {
            try Auth.auth().signOut()
            if FBSDKAccessToken.current() != nil{
                FBSDKAccessToken.setCurrent(nil)
            }
            self.navigationController?.popToRootViewController(animated: true)
            

        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    

}
