//
//  ContentView.swift
//  NMock
//
//  Created by Nguyen Loc on 17/08/2023.
//

import SwiftUI
import CoreData
import Citadel

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Project>
    @State var projectName: String = ""
    @State var editMode: Bool = false
    @State var editItem: Project? = nil
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.name ?? "")")
                            
                        
                    } label: {
                        if editItem == item {
                            TextField(item.name ?? "", text: $projectName) {
                                editItem = nil
                                updateItem(item: item)
                            }
                        } else {
                            Text(item.name ?? "")
                                .onTapGesture(count: 2) {
                                    editItem = item
                                    projectName = item.name ?? ""
                                }
                        }
                        
                            
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func updateItem(item: Project) {
        item.name = projectName
        do {
            try viewContext.save()
            projectName = ""
        } catch let error {
            print(error)
        }
    }
    private func addItem() {
        withAnimation {
            var newItem = Project(context: viewContext)
            newItem.name = "test"
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
