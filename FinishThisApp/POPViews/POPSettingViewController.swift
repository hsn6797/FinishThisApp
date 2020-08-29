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

class POPSettingViewController: UIViewController {

    @IBOutlet weak var ViewS: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target:self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.title = "Settings"

        
        ViewS.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
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
