//
//  HttpHandler.swift
//  Zero
//
//  Created by Philipp Kotte on 28.06.25.
//
import Foundation
import NIO
import NIOHTTP1

public final class HttpHandler: ChannelInboundHandler, Sendable {
    public typealias InboundIn = HTTPServerRequestPart
    public typealias OutboundOut = HTTPServerResponsePart

    init() {}

    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let reqPart = self.unwrapInboundIn(data)

        switch reqPart {
        case .head(let requestHead):
            // 1. NIO-Methode in unsere eigene `HTTPMethod` umwandeln.
            guard let method = HttpMethod(requestHead.method) else {
                // Methode nicht unterstützt, sende Bad Request
                sendResponse(context: context, response: HttpResponse(status: .badRequest, body: "Unsupported HTTP method"))
                return
            }

            // 2. Erstelle unser eigenes `HTTPRequest`-Objekt.
            // (Header und Body werden hier der Einfachheit halber ignoriert)
            let request = HttpRequest(
                method: method,
                path: requestHead.uri,
                headers: [:], // Hier könntest du `requestHead.headers` parsen
                body: nil
            )

            // 3. Übergib die Anfrage an unseren Router.
            let response = Router.shared.handle(request: request)

            // 4. Sende die Antwort vom Router zurück an den Client.
            sendResponse(context: context, response: response)

        case .body, .end:
            // Wir behandeln den Body hier nicht, da wir ein einfaches Request/Response machen.
            break
        }
    }

    /// Hilfsfunktion, um eine Antwort an den Client zu senden.
    private func sendResponse(context: ChannelHandlerContext, response: HttpResponse) {
        let buffer = context.channel.allocator.buffer(string: response.body)

        // Bestimme den Content-Type. Einfache Prüfung auf HTML.
        let isHtml = response.body.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().hasPrefix("<!doctype")
        let contentType = isHtml ? "text/html; charset=utf-8" : "application/json; charset=utf-8"

        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: contentType)
        headers.add(name: "Content-Length", value: String(buffer.readableBytes))

        // Erstelle den Response Head mit dem Status aus unserer `HTTPResponse`.
        let head = HTTPResponseHead(version: .http1_1, status: response.status, headers: headers)

        context.write(self.wrapOutboundOut(.head(head)), promise: nil)
        context.write(self.wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
        context.writeAndFlush(self.wrapOutboundOut(.end(nil)), promise: nil)
    }
}
