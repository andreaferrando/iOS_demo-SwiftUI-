//
//  HomeLocalDataManager.swift
//
//  Created by Capco.
//  Copyright © 2019 Capco. All rights reserved.
//

import Foundation
import UIKit
import Combine
import CoreData

enum LocalDataServiceError: Error {
  case parsing(description: String)
  case fetch(description: String)
}

class HomeLocalDataManager: HomeInteractorToLocalDataManagerProtocol {

    lazy var managedContext: NSManagedObjectContext? = {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }()

    func getPosts() -> AnyPublisher<[PostResponseModel], Error> {
        guard let managedContext = self.managedContext else {
            return Fail(error: LocalDataServiceError.fetch(description: "Couldn't get CoreData store")).eraseToAnyPublisher()
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Post")
        do {
            let postsManagedObjects = try managedContext.fetch(fetchRequest)
            let posts = postsManagedObjects.compactMap {p in
                return (p as? Post)?.postResponseModel() ?? nil
            }
            return Just(posts)
                .mapError { error in
                  LocalDataServiceError.fetch(description: error.localizedDescription)
                }
                .eraseToAnyPublisher()
         } catch let error as NSError {
            return Fail(error: LocalDataServiceError.fetch(description: "Could not fetch. \(error), \(error.userInfo)")).eraseToAnyPublisher()
         }
    }

    func savePosts(_ posts: [PostResponseModel]) {
        DispatchQueue.main.async {
            guard let managedContext = self.managedContext else { return }
            posts.forEach { (p) in
                do {
                    _ = try p.toCoreData(context: managedContext)
                } catch let error as NSError {
                   print("Could not save. \(error), \(error.userInfo)")
                }
            }
            do {
               try managedContext.save()
            } catch let error as NSError {
               print("Could not save. \(error), \(error.userInfo)")
            }

        }
    }

}
