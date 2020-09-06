//
//  PrivacyViewController.swift
//  FinishThisApp
//
//  Created by Asad on 27/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    @IBOutlet weak var PrivacyTextView: UITextView!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target:self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.title = "Privacy"
        // Do any additional setup after loading the view.
    }
    @objc func goBack(){
        
        self.navigationController?.popViewController(animated: true)
                       
    }

}
