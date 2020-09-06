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

    @IBOutlet weak var admobSettingView: UIView!
    
    var bannerView: GADBannerView!
    var BannerID_2  = "ca-app-pub-0653754342418962/2749420914"
    let GadSize = GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
    
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

        

        // Do any additional setup after loading the view.
    }
    
    
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        admobSettingView.addSubview(bannerView)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        bannerView.heightAnchor.constraint(equalTo: admobSettingView.heightAnchor).isActive = true
        bannerView.widthAnchor.constraint(equalTo: admobSettingView.widthAnchor).isActive = true
        bannerView.leadingAnchor.constraint(equalTo: admobSettingView.leadingAnchor).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: admobSettingView.trailingAnchor).isActive = true
        
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
    
    private func SignOut(){
        
        guard Auth.auth().currentUser != nil else {
            self.navigationController?.popToRootViewController(animated: true)
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
