//
//  Controller.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation

public protocol Controller: NSObjectProtocol {

    init()

    @RouteBuilder var body: [Route] { get }
}
