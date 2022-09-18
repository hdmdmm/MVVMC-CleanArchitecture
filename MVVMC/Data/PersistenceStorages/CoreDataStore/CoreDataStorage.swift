//
//  CoreDataPersistentStore.swift
//  MVVMC
//
//  Created by Dmitry Kh on 30.08.22.
//

import CoreData

final class CoreDataStorage {
  static let shared = CoreDataStorage()
  private init() {}
  
  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MVVMC_DB")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // TODO: to replace fatalError and add debug logger
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        // TODO: to replace fatalError and add debug logger
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
    persistentContainer.performBackgroundTask(block)
  }
  
}
