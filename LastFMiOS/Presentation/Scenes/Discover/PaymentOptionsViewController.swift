//
//  PaymentOptionsViewController.swift
//  TravelApp
//
//  Created by valeri mekhashishvili on 10.05.23.
//

import UIKit

class PaymentOptionsViewController: UIViewController {
    
    @IBOutlet weak var cardName: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var expiryDate: UITextField!
    @IBOutlet weak var cVV: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
    }
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        guard let cardNameText = cardName.text,
                     let cardNumberText = cardNumber.text?.replacingOccurrences(of: " ", with: ""),
                     let expiryDateText = expiryDate.text,
                     let cVVText = cVV.text else {
                   showNotification("Please fill in all fields.")
                   return
               }
               
               if cardNameText.isEmpty || cardNumberText.isEmpty || expiryDateText.isEmpty || cVVText.isEmpty {
                   showNotification("Please fill in all fields.")
               } else if !isValidCardNumber(cardNumberText) {
                   showNotification("Please enter a valid card number.")
               } else if !isValidExpiryDate(expiryDateText) {
                   showNotification("Please enter expiry date in MM/YY format.")
               } else if !isValidCVV(cVVText) {
                   showNotification("Please enter a valid CVV number.")
               } else {
                   showNotification("Payment completed successfully. Tickets will be sent to the email you provided during registration.")
                   navigateToPreviousPage()
               }
           }
           
           func showNotification(_ message: String) {
               let alertController = UIAlertController(title: "Notification", message: message, preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                   if self?.areAllFieldsFilled() ?? false {
                       self?.navigateToPreviousPage()
                   }
               }
               alertController.addAction(okAction)
               present(alertController, animated: true, completion: nil)
           }
           
           func navigateToPreviousPage() {
               navigationController?.popViewController(animated: true)
           }
           
           func areAllFieldsFilled() -> Bool {
               guard let cardNameText = cardName.text,
                     let cardNumberText = cardNumber.text,
                     let expiryDateText = expiryDate.text,
                     let cVVText = cVV.text else {
                   return false
               }
               
               return !cardNameText.isEmpty && !cardNumberText.isEmpty && !expiryDateText.isEmpty && !cVVText.isEmpty
           }
           
           func isValidCardNumber(_ cardNumber: String) -> Bool {
               let cardNumberWithoutSpaces = cardNumber.replacingOccurrences(of: " ", with: "")
               let cardNumberRegex = "^\\d{16}$"
               return NSPredicate(format: "SELF MATCHES %@", cardNumberRegex).evaluate(with: cardNumberWithoutSpaces)
           }
           
           func isValidExpiryDate(_ expiryDate: String) -> Bool {
               let expiryDateRegex = "^(0[1-9]|1[0-2])\\/(\\d{2})$"
               return NSPredicate(format: "SELF MATCHES %@", expiryDateRegex).evaluate(with: expiryDate)
           }
           
           func isValidCVV(_ cvv: String) -> Bool {
               let cvvRegex = "^\\d{3}$"
               return NSPredicate(format: "SELF MATCHES %@", cvvRegex).evaluate(with: cvv)
           }
       }
