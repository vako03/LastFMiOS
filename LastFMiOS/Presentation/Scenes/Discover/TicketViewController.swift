//
//  MarsViewController.swift
//  TravelApp
//
//  Created by valeri mekhashishvili on 03.05.23.
//

import UIKit

class TicketViewController: UIViewController {
    
    
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var ticketCounts: UILabel!
    @IBOutlet weak var sumPrice: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var ticketCount = 0
     let ticketPrice = 100

     override func viewDidLoad() {
         super.viewDidLoad()
         navigationController?.navigationBar.tintColor = .white
         button.layer.cornerRadius = button.frame.size.height / 2
         button.clipsToBounds = true
         navigationController?.navigationBar.tintColor = .white
         updateTicketCountLabel()
         updateTotalPriceLabel()
     }

     @IBAction func increaseTicketCount(_ sender: Any) {
         ticketCount += 1
         updateTicketCountLabel()
         updateTotalPriceLabel()
     }

     @IBAction func decreaseTicketCount(_ sender: Any) {
         if ticketCount > 0 {
             ticketCount -= 1
             updateTicketCountLabel()
             updateTotalPriceLabel()
         }
     }

     private func updateTicketCountLabel() {
         ticketCounts.text = "\(ticketCount)"
     }

     private func updateTotalPriceLabel() {
         let totalPrice = ticketCount * ticketPrice
         sumPrice.text = "$\(totalPrice)"
     }

     @IBAction func byTicket(_ sender: Any) {
         let paymentOptionsVC = PaymentOptionsViewController(nibName: "PaymentOptionsViewController", bundle: nil)
         navigationController?.pushViewController(paymentOptionsVC, animated: true)
     }
 }
