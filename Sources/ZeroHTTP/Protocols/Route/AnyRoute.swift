//
//  AnyRoute.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 05.07.25.
//


/// Ein Marker-Protokoll, um eine Eigenschaft als Route identifizierbar zu machen.
///
/// Jeder Typ, der eine Route repräsentiert oder enthält, sollte diesem Protokoll folgen.
public protocol AnyRoute {
    /// Gibt die eigentliche `Route`-Instanz zurück.
    var route: Route { get }
}
