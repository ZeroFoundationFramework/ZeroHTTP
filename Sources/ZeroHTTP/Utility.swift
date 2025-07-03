//
//  Utility.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 03.07.25.
//
import Foundation
import ZeroTemplate
import ZeroErrors

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
        let htmlContent = try String(contentsOfFile: filePath, encoding: .utf8).data(using: .utf8)
        var headers = HttpHeaders()
        headers.add(name: "Content-Type", value: "text/html; charset=utf-8")

        return HttpResponse(status: .ok, headers: headers, body: htmlContent ?? Data())
    } catch {
        return notFoundResponse()
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
public func rendered(_ filename: String, context: TemplateContext = [:]) -> HttpResponse {
    do {
        let renderedHTML = try templateRenderer.render(filename: "\(filename).html.zero", context: context)
        
        var headers = HttpHeaders()
        headers.add(name: "Content-Type", value: "text/html; charset=utf-8")
        return response(headers: headers, body: renderedHTML)
    } catch {
        return internalServerErrorResponse()
    }
}

public func notFoundResponse() -> HttpResponse {
    return response(
        status: .notFound,
        statusPhrase: "Not Found",
        headers: ["Content-Type": "text/html"],
        body: resourceNotFound
    )
}

public func internalServerErrorResponse() -> HttpResponse {
    return response(
        status: .internalServerError,
        statusPhrase: "Internal Server Error",
        headers: ["Content-Type": "text/html"],
        body: internalServerError
    )
}

public func response(
    status: HttpResponseStatus = .ok,
    statusPhrase: String = "",
    headers: HttpHeaders = .init(),
    body: String = "Ok") -> HttpResponse {
    return HttpResponse(status: status, statusPhrase: statusPhrase, headers: headers, body: body.data(using: .utf8))
}

