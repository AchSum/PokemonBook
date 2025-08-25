//
//  CoreDataStack.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 25/08/25.
//

import CoreData

final class CoreDataStack {
  static let shared = CoreDataStack()

  let container: NSPersistentContainer
  var viewContext: NSManagedObjectContext { container.viewContext }

  init(inMemory: Bool = false, modelName: String = "Model") {
    container = NSPersistentContainer(name: modelName)

    if inMemory {
      let desc = NSPersistentStoreDescription()
      desc.type = NSInMemoryStoreType
      container.persistentStoreDescriptions = [desc]
    } else if let desc = container.persistentStoreDescriptions.first {
      // Lightweight migration
      desc.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
      desc.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
    }

    container.loadPersistentStores { desc, error in
      if let error = error { fatalError("CoreData load error: \(error)") }
      #if DEBUG
      print("CoreData store loaded:", desc.url?.lastPathComponent ?? "-")
      #endif
    }

    // Main context policy (aman untuk upsert & merge dari BG)
    container.viewContext.name = "viewContext"
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.shouldDeleteInaccessibleFaults = true
  }

  func newBackgroundContext() -> NSManagedObjectContext {
    let ctx = container.newBackgroundContext()
    ctx.name = "bgContext-\(UUID().uuidString.prefix(4))"
    ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    ctx.automaticallyMergesChangesFromParent = true
    return ctx
  }

  @discardableResult
  func saveViewContext() -> Bool {
    let ctx = viewContext
    guard ctx.hasChanges else { return false }
    do { try ctx.save(); return true } catch {
      print("CoreData save error:", error)
      return false
    }
  }
}

#if DEBUG
extension CoreDataStack {
  /// Stack untuk Preview/Tests (in-memory)
  static let preview: CoreDataStack = {
    CoreDataStack(inMemory: true, modelName: "Model")
  }()
}
#endif
