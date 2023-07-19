//
//  ViewController.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 18.07.23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var fieldUserName: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLogin(_ sender: Any) {
        guard let username = fieldUserName.text, let password = fieldPassword.text else {
            showAlert(title: "Error", message: "Please enter both username and password.")
            return
        }
        
        if username == "1" && password == "1" {
            let sb = UIStoryboard(name: "TabBarController", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "TabBarController")
            navigationController?.setViewControllers([vc], animated: true)
            
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.userLoggedIn)
        } else {
            showAlert(title: "Error", message: "Incorrect username or password.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

