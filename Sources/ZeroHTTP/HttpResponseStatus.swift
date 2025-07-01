//
//  HttpResponseStatus.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 01.07.25.
//

enum HttpResponseStatus: UInt, Sendable {
    
    // 1xx
    case `continue` = 100
    case switchingProtocols
    case processing
    case earlyHints
    // TODO: add '103: Early Hints' (requires bumping SemVer major).

    // 2xx
    case ok = 200
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent
    case multiStatus
    case alreadyReported
    case imUsed

    // 3xx
    case multipleChoices = 300
    case movedPermanently
    case found
    case seeOther
    case notModified
    case useProxy = 305
    case unused
    case temporaryRedirect
    case permanentRedirect

    // 4xx
    case badRequest = 400
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound = 404
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case gone
    case lengthRequired
    case preconditionFailed
    case contentTooLarge
    case uriTooLong
    case unsupportedMediaType
    case rangeNotSatisfiable
    case expectationFailed
    case imATeapot
    case misdirectedRequest
    case unprocessableEntity
    case locked
    case failedDependency
    case toEarly
    case upgradeRequired
    case preconditionRequired
    case tooManyRequests
    case requestHeaderFieldsTooLarge
    case unavailableForLegalReasons

    // 5xx
    case internalServerError = 500
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case httpVersionNotSupported
    case variantAlsoNegotiates
    case insufficientStorage
    case loopDetected
    case notExtended
    case networkAuthenticationRequired

    
}

