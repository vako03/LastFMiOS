//
//  AppDelegate.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 18.07.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           NetworkMonitor.shared.startMonitoring()
           setupNetworkStatusObserver()
           return true
       }

       // MARK: - UISceneSession Lifecycle

       func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
           return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
       }

       func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
           // Called when the user discards a scene session.
           // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
           // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
       }

       // MARK: - Network Status Observer

       private func setupNetworkStatusObserver() {
           NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: NetworkMonitor.networkStatusChangedNotification, object: nil)
       }

       @objc private func networkStatusChanged(_ notification: Notification) {
           if let isConnected = notification.userInfo?[NetworkMonitor.networkStatusUserInfoKey] as? Bool, !isConnected {
               showNoInternetAlert()
           }
       }

       private func showNoInternetAlert() {
           let alertController = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           alertController.addAction(okAction)

           if let rootViewController = window?.rootViewController {
               rootViewController.present(alertController, animated: true, completion: nil)
           }
       }
   }
