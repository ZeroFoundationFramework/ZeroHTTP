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
        
        let endOfHeadersRange = data.range(of: "\r\n\r\n".data(using: .utf8)!)
        
        // Wenn keine Trennung gefunden wird, ist die Anfrage unvollständig.
        guard let endOfHeadersRange = endOfHeadersRange else {
            return nil
        }
        
        let headerData = data[..<endOfHeadersRange.lowerBound]
        let bodyData = data[endOfHeadersRange.upperBound...]
        
        guard let headerString = String(data: headerData, encoding: .utf8) else {
            return nil
        }
        
        let lines = headerString.components(separatedBy: "\r\n")
        guard !lines.isEmpty else { return nil }
        
        // Parse Request Line
        let requestLine = lines[0].components(separatedBy: " ")
        guard requestLine.count >= 2 else { return nil } // HTTP Version ist optional für uns
        
        let method = HttpMethod(rawValue: requestLine[0]) ?? .UNKNOWN
        let path = requestLine[1]
        
        // Parse Headers
        var headers = HttpHeaders()
        for line in lines.dropFirst() {
            let headerParts = line.split(separator: ":", maxSplits: 1).map(String.init)
            if headerParts.count == 2 {
                headers[headerParts[0]] = headerParts[1].trimmingCharacters(in: .whitespaces)
            }
        }
        
        return HttpRequest(method: method, path: path, headers: headers, body: bodyData.isEmpty ? nil : bodyData)
    }
}
