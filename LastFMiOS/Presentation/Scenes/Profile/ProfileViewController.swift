//
//  ProfileViewController.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 18.07.23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        UserDefaults.standard.set(false, forKey:UserDefaultKeys.userLoggedIn)
        let vc = UIStoryboard(name: "LoginViewController", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        navigationController?.setViewControllers([vc], animated: true)
    }
    
}
