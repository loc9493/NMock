//
//  NMockApp.swift
//  NMock
//
//  Created by Nguyen Loc on 17/08/2023.
//

import SwiftUI
import Swifter

@main
struct NMockApp: App {
    let persistenceController = PersistenceController.shared
    let server = HttpServer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .task {
                    server["/hello"] = { .ok(.htmlBody("You asked for \($0)"))  }
                    do {
                        try server.start()
                    } catch let error {
                        print(error)
                    }
                }
        }
    }
}
