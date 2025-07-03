//
//  Utility.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 03.07.25.
//
import Foundation
import ZeroTemplate
import ZeroErrors

/// Der Pfad zum "Views"-Verzeichnis, wird einmal beim Start ermittelt.
private let viewsDirectoryPath: String = {
    let fileURL = URL(fileURLWithPath: #file)
    let utilityDirURL = fileURL.deletingLastPathComponent()
    let appDirURL = utilityDirURL.deletingLastPathComponent()
    let viewsDirURL = appDirURL.appendingPathComponent("Views")
    print("✅ Views-Verzeichnis gefunden unter: \(viewsDirURL.path)")
    return viewsDirURL.path
}()

/// Eine globale Instanz des Template-Renderers.
nonisolated(unsafe) private let templateRenderer: TemplateRenderer = {
    let viewsDir = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Sources")
        .appendingPathComponent("App")
        .appendingPathComponent("Views")
    return TemplateRenderer(viewsDirectory: viewsDir)
}()

// --- Öffentliche Hilfsfunktionen ---

/// Erstellt eine `HttpResponse` durch das Lesen einer statischen HTML-Datei.
public func View(_ filename: String) -> HttpResponse {
    let filePath = "\(viewsDirectoryPath)/\(filename)"
    do {
        let htmlContent = try String(contentsOfFile: filePath, encoding: .utf8)
        var headers = HttpHeaders()
        headers["Content-Type"] = "text/html; charset=utf-8"
        return response(status: .ok, statusPhrase: "OK", headers: headers, body: htmlContent)
    } catch {
        return notFoundResponse()
    }
}

/// Rendert eine Template-Datei mit einem Kontext und erstellt eine `HttpResponse`.
public func rendered(_ filename: String, context: TemplateContext = [:]) -> HttpResponse {
    do {
        let fullFilename = "\(filename).zero.html"
        let renderedHTML = try templateRenderer.render(filename: fullFilename, context: context)
        
        var headers = HttpHeaders()
        headers["Content-Type"] = "text/html; charset=utf-8"
        return response(status: .ok, statusPhrase: "OK", headers: headers, body: renderedHTML)
    } catch {
        return internalServerErrorResponse()
    }
}

/// Gibt eine standardisierte 404 Not Found-Antwort zurück.
public func notFoundResponse() -> HttpResponse {
    return response(
        status: .notFound,
        statusPhrase: "Not Found",
        headers: ["Content-Type": "text/html; charset=utf-8"],
        body: resourceNotFound
    )
}

/// Gibt eine standardisierte 500 Internal Server Error-Antwort zurück.
public func internalServerErrorResponse() -> HttpResponse {
    return response(
        status: .internalServerError,
        statusPhrase: "Internal Server Error",
        headers: ["Content-Type": "text/html; charset=utf-8"],
        body: internalServerError
    )
}

/// Die zentrale Funktion zum Erstellen einer `HttpResponse` aus einem String.
public func response(
    status: HttpResponseStatus = .ok,
    statusPhrase: String = "OK",
    headers: HttpHeaders = .init(),
    body: String = "") -> HttpResponse {
    
    // Konvertiere den String-Body sicher in Data.
    guard let bodyData = body.data(using: .utf8) else {
        // Wenn die Konvertierung fehlschlägt, sende einen internen Fehler.
        return internalServerErrorResponse()
    }
    
    return HttpResponse(status: status, statusPhrase: statusPhrase, headers: headers, body: bodyData)
}

