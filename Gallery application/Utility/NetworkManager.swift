//
//  NetworkManager.swift
//  Gallery application
//
//  Created by Jenish  Mac  on 21/09/25.
//

import Foundation
import Network
import SystemConfiguration

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    var isConnected: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) { ptr -> SCNetworkReachability? in
            return ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { SCNetworkReachabilityCreateWithAddress(nil, $0) }
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) { return false }
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
}

