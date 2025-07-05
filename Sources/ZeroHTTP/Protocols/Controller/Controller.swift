//
//  Controller.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation
import ZeroDI

public protocol Controller: NSObjectProtocol {

    init(container: Container)

    @RouteBuilder var body: [Route] { get }
}
