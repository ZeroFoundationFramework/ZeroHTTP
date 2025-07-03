//
//  ControllerRegistry.swift
//  ZeroHTTP
//
//  Created by Philipp Kotte on 03.07.25.
//

import Foundation

public class ControllerRegistry {
    /// Gibt eine Liste von Instanzen zurück, die dem `Controller`-Protokoll entsprechen.
    public static func discoverControllers() -> [Controller] {
        var controllers: [Controller] = []
        let classCount = objc_getClassList(nil, 0)
        let classes = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(classCount))
        defer { free(classes) }
        objc_getClassList(AutoreleasingUnsafeMutablePointer(classes), classCount)

        for i in 0..<Int(classCount) {
            guard let cls = classes[i] else { continue }

            // 1. Suche nach Klassen, die dem @objc-Protokoll `DiscoverableController` entsprechen.
            if class_conformsToProtocol(cls, DiscoverableController.self) {
                // 2. Erstelle eine Instanz über den `DiscoverableController`-Typ.
                if let discoverableInstance = (cls as? DiscoverableController.Type)?.init() {
                    // 3. Prüfe, ob diese Instanz auch dem reinen Swift-Protokoll `Controller` entspricht.
                    if let controllerInstance = discoverableInstance as? Controller {
                        print("✅ \(type(of: controllerInstance))")
                                                
                            for route in controllerInstance.body {
                                print(
                                    "   -> Route: \(route.method.rawValue.padding(toLength: 5, withPad: " ", startingAt: 0)) \(route.path)")
                            }
                        
                        controllers.append(controllerInstance)
                        
                    }
                }
            }
        }

        return controllers
    }
}
