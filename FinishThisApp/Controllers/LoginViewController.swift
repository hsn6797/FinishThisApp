//
//  LoginViewController.swift
//  FinishThisApp
//
//  Created by Asad on 26/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//


import UIKit
import FirebaseFirestore
import FirebaseAuth
import FBSDKLoginKit
import SVProgressHUD
import GoogleMobileAds


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var FBView: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var MobAdView: UIView!
    var bannerView: GADBannerView!
    
    var BannerID_1  = "ca-app-pub-0653754342418962/9314829262"
    let GadSize = GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Banner Work Here
        
        bannerView = GADBannerView(adSize: GadSize)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = BannerID_1
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self as? GADBannerViewDelegate
        
        ////////////////////////****************************//////////////////////////////

        let loginButton = FBSDKLoginButton()
        FBView.addSubview(loginButton)

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.heightAnchor.constraint(equalTo: FBView.heightAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: FBView.widthAnchor).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: FBView.leadingAnchor).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: FBView.trailingAnchor).isActive = true
        
        
        //loginButton.center = FBView.center
        loginButton.delegate = self
        
        if Auth.auth().currentUser != nil {
            print("USER::::::::::::::::::: Already logged in" + (Auth.auth().currentUser?.uid)!)
            let userId = (Auth.auth().currentUser?.uid)!
                let sb = UIStoryboard(name: "Home",bundle: nil)
                if let homeVC = sb.IIVC(vc: HomeViewController(),id: "Home_VC"){
                    homeVC.USERID = userId
                    self.navigationController?.pushViewController(homeVC, animated: true)
            }
        }

        else {

        }
        // TAP gesture
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
        
    }
    
    @objc func dismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        
        MobAdView.addSubview(bannerView)

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        bannerView.heightAnchor.constraint(equalTo: MobAdView.heightAnchor).isActive = true
        bannerView.widthAnchor.constraint(equalTo: MobAdView.widthAnchor).isActive = true
        bannerView.leadingAnchor.constraint(equalTo: MobAdView.leadingAnchor).isActive = true
        bannerView.trailingAnchor.constraint(equalTo: MobAdView.trailingAnchor).isActive = true
      
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
       
        // Do any additional setup after loading the view.

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
         SVProgressHUD.show()
        if error != nil{
            print(error)
            return
        }
        else{
            if result.isCancelled{
                print("Cancelled")
                SVProgressHUD.dismiss()
            }
            else{
                
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        print("Facebook authentication with Firebase error: ", error)
                        return
                    }
                    print("User signed in!")
                    let userName = user?.displayName!
                    let userID = user?.uid
                    
                    let db = Firestore.firestore()
                    let user = User()
                    user.userID = userID!
                    user.userName = userName!
                    user.email = self.emailTF.text!
                    user.password = self.passwordTF.text!
                    db.add(user: user)
                    SVProgressHUD.dismiss()
                    let sb = UIStoryboard(name: "Home",bundle: nil)
                    if let homeVC = sb.IIVC(vc: HomeViewController(),id: "Home_VC"){
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                }

            }
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out Successfully")
    }
    
    
    fileprivate func presentLoginController() {
        
      let email = emailTF.text
      let password = passwordTF.text
        
           if email != "" && password != ""{
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] authResult, error in
                
                if(error != nil){
                    SVProgressHUD.dismiss()
                    self?.showToast(message: "Invalid email or password")
                    return
                }
                
                guard let strongSelf = self else { return }
                
                print("LogedIn!!!!!!!!")
                
                Firestore.firestore().getCurrentUser(userID: authResult!.user.uid ,completionHandler: {
                    user in
                    
                    print("ID is:  --> "+user.userID)
                    print("Username is:  --> "+user.userName)
                })
                
                SVProgressHUD.dismiss()
                let sb = UIStoryboard(name: "Home",bundle: nil)
                if let homeVC = sb.IIVC(vc: HomeViewController(),id: "Home_VC"){
                    strongSelf.navigationController?.pushViewController(homeVC, animated: true)
                }
                
                
            }
        }
        else{
            
            
        }
        

    }
        
    @IBAction func SignupB(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main",bundle: nil)
        if let signUpVC = sb.IIVC(vc: SignUpViewController(),id: "signup_vc"){
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
 
    @IBAction func LoginB(_ sender: UIButton) {
        
        
        
        
        presentLoginController()
    }

}
