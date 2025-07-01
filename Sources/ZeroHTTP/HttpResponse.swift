//
//  HttpResponse.swift
//  zero_proj
//
//  Created by Philipp Kotte on 29.06.25.
//

import Foundation
import NIOHTTP1
import ZeroTemplate // <--- Wichtig!

public struct HttpResponse {
    public let status: HTTPResponseStatus
    public var headers: HTTPHeaders
    public let body: String

    // Ein einfacher Initializer für Text-Antworten (setzt standardmäßig text/plain).
    public init(status: HTTPResponseStatus = .ok, body: String) {
        self.status = status
        self.body = body
        self.headers = HTTPHeaders()
        self.headers.add(name: "Content-Type", value: "text/plain; charset=utf-8")
    }

    // Ein Initializer, der das Setzen von Headern erlaubt.
    public init(status: HTTPResponseStatus, headers: HTTPHeaders, body: String) {
        self.status = status
        self.headers = headers
        self.body = body
    }
}

// Ein globaler Pfad zum Views-Verzeichnis.
// Er wird einmal beim Start der App intelligent ermittelt.
private let viewsDirectoryPath: String = {
    // #file ist ein spezieller Swift-String, der den Pfad zur aktuellen Datei enthält.
    // Von hier aus können wir zuverlässig zum `Views`-Ordner navigieren.
    // Pfad: .../Sources/App/Utility/View.swift
    // Ziel: .../Sources/App/Views/
    let fileURL = URL(fileURLWithPath: #file)
    let foundationUrl = fileURL.deletingLastPathComponent()
    let appDirURL = foundationUrl.deletingLastPathComponent().appendingPathComponent("Sources").appendingPathComponent("App")
    let viewsDirURL = appDirURL.appendingPathComponent("Views")
    print("✅ Views-Verzeichnis gefunden unter: \(viewsDirURL.path)")
    return viewsDirURL.path
}()

/// Lädt eine HTML-Datei aus dem Resource-Bundle und erstellt eine HTTP-Antwort.
/// - Parameter filename: Der Name der Datei im `Views`-Ordner (z.B. "index.html").
/// - Returns: Eine `HTTPResponse` mit dem HTML-Inhalt oder eine 404-Fehler-Antwort.
public func View(_ filename: String) -> HttpResponse {
    let filePath = "\(viewsDirectoryPath)/\(filename)"

    do {
        // Lese den Inhalt der Datei direkt vom Pfad.
        let htmlContent = try String(contentsOfFile: filePath, encoding: .utf8)
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "text/html; charset=utf-8")

        return HttpResponse(status: .ok, headers: headers, body: htmlContent)
    } catch {
        // Gib eine hilfreiche Fehlermeldung zurück, wenn die Datei nicht gefunden wurde.
        return HttpResponse(
            status: .notFound,
            headers: [:],
            body: "<h1>404 Not Found</h1><p>View file '\(filename)' not found at expected path: \(filePath)</p>"
        )
    }
}



// Erstelle eine globale Instanz des Renderers.
nonisolated(unsafe) private let templateRenderer: TemplateRenderer = {
    let viewsDir = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Sources")
        .appendingPathComponent("App")
        .appendingPathComponent("Views")
    return TemplateRenderer(viewsDirectory: viewsDir)
}()

// Die `View`-Funktion verwendet jetzt unsere Engine.
public func render(_ filename: String, context: TemplateContext = [:]) -> HttpResponse {
    do {
        // Hänge automatisch die richtige Dateiendung an.
        let fullFilename = "\(filename).html.zero"
        let renderedHTML = try templateRenderer.render(filename: fullFilename, context: context)
        
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "text/html; charset=utf-8")
        return HttpResponse(status: .ok, headers: headers, body: renderedHTML)
    } catch {
        return HttpResponse(status: .internalServerError, headers: [:], body: notFound)
    }
}

