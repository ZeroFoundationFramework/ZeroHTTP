//
//  Middleware.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation

// Der Typalias für die "nächste" Middleware in der Kette.
public typealias Responder = (HttpRequest) -> HttpResponse

public protocol Middleware: Sendable {
    /// Verarbeitet eine Anfrage und gibt sie entweder an die nächste Middleware
    /// weiter oder beendet die Kette mit einer eigenen Antwort.
    func handle(request: HttpRequest, next: Responder) -> HttpResponse
}

