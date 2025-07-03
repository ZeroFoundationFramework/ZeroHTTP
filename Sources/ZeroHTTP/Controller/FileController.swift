//
//  FileController.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation

final class FileController: NSObject, DiscoverableController, Controller {
    // Ein Dictionary, um Dateiendungen auf MIME-Typen abzubilden.
    private let mimeTypes: [String: String] = [
        "html": "text/html; charset=utf-8",
        "css": "text/css",
        "js": "application/javascript",
        "png": "image/png",
        "jpg": "image/jpeg",
        "jpeg": "image/jpeg",
        "svg": "image/svg+xml",
        "webp": "image/webp"
    ]

    public var body: [Route] {
        // Diese Wildcard-Route fängt alle Anfragen an `/public/...` ab.
        Route(method: .GET, path: "/public/*") { request in
            // Extrahiere den angeforderten Dateipfad aus der URL.
            let requestedPath = String(request.path.dropFirst("/public/".count))

            let viewsDir = URL(fileURLWithPath: #file)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("Sources")
                .appendingPathComponent("App")
                .appendingPathComponent("Public")
            
            
            
            // Erstelle einen sicheren Dateipfad.
            let fileURL = viewsDir.appendingPathComponent(requestedPath)

            // Sicherheitscheck: Verhindere, dass auf Dateien außerhalb des Public-Ordners zugegriffen wird.
            guard fileURL.path.hasPrefix(viewsDir.path) else {
                return HttpResponse(status: .forbidden, headers: [:], body: "Access denied.".data(using: .utf8)!)
            }

            // Lese die Datei.
            guard let fileData = try? Data(contentsOf: fileURL) else {
                return HttpResponse(status: .notFound, headers: [:], body: "File not found.".data(using: .utf8)!)
            }
            
            // Bestimme den Content-Type und print ihn.
            let fileExtension = fileURL.pathExtension
            let contentType = self.mimeTypes[fileExtension.lowercased()] ?? "application/octet-stream"

            var headers = HttpHeaders()
            headers.add(name: "Content-Type", value: contentType)
            
            print("Content-Type used for \(fileURL) : \(contentType)")
            
            // Wandle die Daten in einen String um (für die HttpResponse-Struktur).
            // HINWEIS: Für eine performantere Lösung müsste HttpResponse direkt mit `Data` arbeiten.
            
            return HttpResponse(status: .ok, headers: headers, body: fileData)
             
        }
    }
}
