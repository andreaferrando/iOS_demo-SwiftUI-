//
//  CoreData+Utils.swift
//
//
//  Created by Capco.
//  Copyright © 2019 Capco. All rights reserved.
//

import Foundation
import CoreData


protocol StructDecoder {
    // The name of our Core Data Entity
    static var EntityName: String { get }
    // Return an NSManagedObject with our properties set
    func toCoreData(context: NSManagedObjectContext) throws -> NSManagedObject
}

enum SerializationError: Error {
    // We only support structs
    case structRequired
    // The entity does not exist in the Core Data Model
    case unknownEntity(name: String)
    // The provided type cannot be stored in core data
    case unsupportedSubType(label: String?)
}

extension StructDecoder {
    func toCoreData(context: NSManagedObjectContext) throws -> NSManagedObject {
        let entityName = type(of:self).EntityName

        // Create the Entity Description
        guard let desc = NSEntityDescription.entity(forEntityName: entityName, in: context)
            else { throw SerializationError.unknownEntity(name: entityName) }

        // Create the NSManagedObject
        let managedObject = NSManagedObject(entity: desc, insertInto: context)

        // Create a Mirror
        let mirror = Mirror(reflecting: self)

        // Make sure we're analyzing a struct
        guard mirror.displayStyle == Mirror.DisplayStyle.struct else { throw SerializationError.structRequired }

        for case let (label?, anyValue) in mirror.children {
            managedObject.setValue(anyValue, forKey: label)
        }

        return managedObject
    }
}





extension NSManagedObjectContext {
    
    func deleteAllData(entity: String) {
        let managedContext = self
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                guard let managedObjectData = managedObject as? NSManagedObject else { return }
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }

}
