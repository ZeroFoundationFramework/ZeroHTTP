//
//  DiscoverbaleController.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation
import ZeroDI

/// Ein minimales, @objc-kompatibles Protokoll, das nur zur Laufzeit-Erkennung dient.
@objc public protocol DiscoverableController: NSObjectProtocol {
    init(container: Container)
}
