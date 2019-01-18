//
//  Reachability.swift
//  


import Foundation
import Reachability

class NetworkReachability: NSObject {
    var reachability: Reachability!
    static let sharedInstance: NetworkReachability = { return NetworkReachability() }()
    override init() {
        super.init()
        reachability = Reachability()!
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
        do {
            try (NetworkReachability.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    static func isReachable(completed: @escaping (NetworkReachability) -> Void) {
        if (NetworkReachability.sharedInstance.reachability).connection != .none {
            completed(NetworkReachability.sharedInstance)
        }
    }
    
    static func isUnreachable(completed: @escaping (NetworkReachability) -> Void) {
        if (NetworkReachability.sharedInstance.reachability).connection == .none {
            completed(NetworkReachability.sharedInstance)
        }
    }
    
    static func isReachableViaWWAN(completed: @escaping (NetworkReachability) -> Void) {
        if (NetworkReachability.sharedInstance.reachability).connection == .cellular {
            completed(NetworkReachability.sharedInstance)
        }
    }
    
    static func isReachableViaWiFi(completed: @escaping (NetworkReachability) -> Void) {
        if (NetworkReachability.sharedInstance.reachability).connection == .wifi {
            completed(NetworkReachability.sharedInstance)
        }
    }
}
