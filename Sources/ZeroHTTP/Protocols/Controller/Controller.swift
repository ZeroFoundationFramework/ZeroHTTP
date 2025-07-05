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

public extension Controller {
    var body: [Route] {
        // Verwende einen `Mirror`, um die Struktur der Controller-Instanz zu inspizieren.
        let mirror = Mirror(reflecting: self)
        
        // Finde alle "Kinder" (Eigenschaften), die dem `AnyRoute`-Protokoll entsprechen,
        // und extrahiere ihre `route`-Eigenschaft.
        return mirror.children.compactMap { child in
            // `child.value` ist der Wert der Eigenschaft (z.B. die PublicAccess-Instanz).
            // Wir versuchen, ihn auf unser Marker-Protokoll zu casten.
            return (child.value as? AnyRoute)?.route
        }
    }
}
