//
//  ZeroHTTP
//  HttpResponse.swift
//
//  Created by Philipp Kotte on 29.06.25.
//

import Foundation
import NIOHTTP1
import ZeroTemplate

/// Represents an outgoing HTTP response.
///
/// This struct encapsulates all necessary components for an HTTP response,
/// including the status code, headers, and the response body.
public struct HttpResponse {
    /// The HTTP status code of the response (e.g., `.ok`, `.notFound`).
    public let status: HTTPResponseStatus
    
    /// The HTTP headers to be sent with the response.
    public var headers: HTTPHeaders
    
    /// The body of the response as a `String`.
    public let body: String

    /// Initializes a new `HttpResponse` for plain text content.
    ///
    /// This initializer defaults to a `200 OK` status and sets the
    /// `Content-Type` header to `text/plain`.
    ///
    /// - Parameters:
    ///   - status: The HTTP status for the response. Defaults to `.ok`.
    ///   - body: The string content of the response body.
    public init(status: HTTPResponseStatus = .ok, body: String) {
        self.status = status
        self.body = body
        self.headers = HTTPHeaders()
        self.headers.add(name: "Content-Type", value: "text/plain; charset=utf-8")
    }

    /// Initializes a new `HttpResponse` with custom headers.
    ///
    /// - Parameters:
    ///   - status: The HTTP status for the response.
    ///   - headers: A dictionary of `HTTPHeaders` for the response.
    ///   - body: The string content of the response body.
    public init(status: HTTPResponseStatus, headers: HTTPHeaders, body: String) {
        self.status = status
        self.headers = headers
        self.body = body
    }
}

private let viewsDirectoryPath: String = {
    let fileURL = URL(fileURLWithPath: #file)
    let foundationUrl = fileURL.deletingLastPathComponent()
    let appDirURL = foundationUrl.deletingLastPathComponent().appendingPathComponent("Sources").appendingPathComponent("App")
    let viewsDirURL = appDirURL.appendingPathComponent("Views")
    print("✅ Views directory located at: \(viewsDirURL.path)")
    return viewsDirURL.path
}()

/// Creates an `HttpResponse` by reading a static HTML file from the filesystem.
///
/// This function is a simple way to serve static HTML pages without any templating.
/// - Parameter filename: The name of the file within the "Views" directory (e.g., "index.html").
/// - Returns: An `HttpResponse` containing the HTML content or a 404 error page.
public func View(_ filename: String) -> HttpResponse {
    let filePath = "\(viewsDirectoryPath)/\(filename)"

    do {
        let htmlContent = try String(contentsOfFile: filePath, encoding: .utf8)
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "text/html; charset=utf-8")

        return HttpResponse(status: .ok, headers: headers, body: htmlContent)
    } catch {
        return HttpResponse(
            status: .notFound,
            headers: [:],
            body: "<h1>404 Not Found</h1><p>View file '\(filename)' not found at expected path: \(filePath)</p>"
        )
    }
}

nonisolated(unsafe) private let templateRenderer: TemplateRenderer = {
    let viewsDir = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Sources")
        .appendingPathComponent("App")
        .appendingPathComponent("Views")
    return TemplateRenderer(viewsDirectory: viewsDir)
}()

/// Renders a template file with a given context and creates an `HttpResponse`.
///
/// This function uses the `TemplateRenderer` to parse a template file,
/// replace placeholders with data from the context, and return a complete HTML response.
///
/// - Parameters:
///   - filename: The name of the template file (without the `.html.zero` extension).
///   - context: A dictionary of data to be injected into the template. Defaults to an empty dictionary.
/// - Returns: An `HttpResponse` containing the rendered HTML or a 500 error page.
public func render(_ filename: String, context: TemplateContext = [:]) -> HttpResponse {
    do {
        let fullFilename = "\(filename).html.zero"
        let renderedHTML = try templateRenderer.render(filename: fullFilename, context: context)
        
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "text/html; charset=utf-8")
        return HttpResponse(status: .ok, headers: headers, body: renderedHTML)
    } catch {
        let notFound = "<h1>500 Internal Server Error</h1><p>Failed to render template: \(error)</p>"
        return HttpResponse(status: .internalServerError, headers: [:], body: notFound)
    }
}
