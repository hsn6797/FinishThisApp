//
//  EditProfileViewController.swift
//  FinishThisApp
//
//  Created by Asad on 27/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit
import  FirebaseAuth

class EditProfileViewController: UIViewController {
    
    
    
    var CurrentUID = ""
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var EmailTxt: UITextField!
    
    @IBOutlet weak var PasswordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target:self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.title = "Edit profile"
        
        if Auth.auth().currentUser != nil{
            CurrentUID = (Auth.auth().currentUser?.uid)!
        }

        // Do any additional setup after loading the view.
    }
    
    @objc func goBack(){
        
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func SaveButton(_ sender: Any) {
        
        
    }
}
