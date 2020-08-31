//
//  EditProfileViewController.swift
//  FinishThisApp
//
//  Created by Asad on 27/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit
import  FirebaseAuth
import FBSDKLoginKit
import FirebaseFirestore

class EditProfileViewController: UIViewController {
    
    var CurrentUID = ""
    var CurrentEmail = ""

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var EmailTxt: UITextField!
    
    @IBOutlet weak var PasswordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target:self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.title = "Edit profile"
        
        if FBSDKAccessToken.current() != nil {
            Alert(Message: "Can't Update", title: "Login from Facebook")
        }else{
            if Auth.auth().currentUser != nil{
                CurrentUID = (Auth.auth().currentUser?.uid)!
                CurrentEmail = (Auth.auth().currentUser?.email)!
                EmailTxt.text = CurrentEmail
                
                Firestore.firestore().getCurrentUser(userID: CurrentUID) { user in
                    
                    self.userName.text = user.userName
                }
                
                
                //            userName.text =
            }
        }
        

        // Do any additional setup after loading the view.
    }
    
    @objc func goBack(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func Alert (Message: String,title:String){
        
        let alert = UIAlertController(title: title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: alerbtn))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func alerbtn(_:UIAlertAction){
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func SaveButton(_ sender: Any) {
        
        guard let currentUser = Auth.auth().currentUser else{return}
        
        if EmailTxt.text == nil || userName.text == nil || PasswordTxt.text == nil{
            return
        }
        currentUser.updateEmail(to: EmailTxt.text!){ error in
            if let error = error {
                error.errorMesssage()
                self.showToast(message: "Couldn't Update")
                return
            } else {
                // Email updated.
                currentUser.updatePassword(to: self.PasswordTxt.text!) { error in
                    if let error = error {
                        error.errorMesssage()
                        return
                    } else {
                        // Password updated.
                        print("success")
                        let user = User()
                        user.userID = currentUser.uid
                        user.userName = self.userName.text!
                        Firestore.firestore().add(user: user)
                        self.Alertpop(Message: "Username and password updated", title: "Success")
                        
                    }
                }
            }
        }
        
    }
    
    
    func Alertpop (Message: String,title:String){
        
        let alert = UIAlertController(title: title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: UpdatePop))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func UpdatePop(_:UIAlertAction){
        self.navigationController?.popViewController(animated: true)
    }
}
