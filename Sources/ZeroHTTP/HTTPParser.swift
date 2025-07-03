//
//  HTTPParser.swift
//  zero_proj
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation

public class HTTPParser {
    
    public init() {}
    
    public func parse(data: Data) -> HttpRequest? {
        
        guard let requestString = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        let lines = requestString.components(separatedBy: "\r\n")
        guard !lines.isEmpty else { return nil }

        // Parse Request Line
        let requestLine = lines[0].components(separatedBy: " ")
        guard requestLine.count == 3 else { return nil }
            
        let method = HttpMethod(rawValue: requestLine[0]) ?? .UNKNOWN
        let path = requestLine[1]
                
        // Parse Headers
        var headers = HttpHeaders()
        var lineIndex = 1
        while lineIndex < lines.count && !lines[lineIndex].isEmpty {
            let headerLine = lines[lineIndex].components(separatedBy: ": ")
            if headerLine.count == 2 {
                headers[headerLine[0]] = headerLine[1]
            }
            lineIndex += 1
        }
                
        // Parse Body (vereinfacht)
        let bodyString = lines.dropFirst(lineIndex + 1).joined()
        let body = bodyString.data(using: .utf8)

        return HttpRequest(method: method, path: path, headers: headers, body: body)
    }
}
