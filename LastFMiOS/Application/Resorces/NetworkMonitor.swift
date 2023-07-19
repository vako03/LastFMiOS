//
//  NetworkMonitor.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 22.07.23.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    static let networkStatusChangedNotification = Notification.Name("NetworkStatusChangedNotification")
    static let networkStatusUserInfoKey = "NetworkStatusUserInfoKey"
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
            self?.postNetworkStatusChangedNotification()
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
    
    private func postNetworkStatusChangedNotification() {
        NotificationCenter.default.post(name: NetworkMonitor.networkStatusChangedNotification, object: self, userInfo: [NetworkMonitor.networkStatusUserInfoKey: isConnected])
    }
}
