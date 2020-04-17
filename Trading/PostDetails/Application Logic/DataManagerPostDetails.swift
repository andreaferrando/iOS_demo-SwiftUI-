//
//  PostDetailsLocalDataManager.swift
//
//  Created by Andrea Ferrando
//  Copyright © 2020 Andrea Ferrando. All rights reserved.
//

import Foundation
import UIKit
import Combine
import CoreData

class PostDetailsLocalDataManager: PostDetailsInteractorToLocalDataManagerProtocol {

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

    private func getPostManagedObject(_ id: Int) -> NSManagedObject? {
        guard let managedContext = self.managedContext else { return nil }
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Post")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        do {
            let posts = try managedContext.fetch(fetchRequest)
            return posts.isEmpty ?  nil : posts[0] as? NSManagedObject
        } catch {
            return nil
        }
    }

//    func getPost(_ id:Int) -> PostResponseModel? {
//        guard let managedContext = self.managedContext else { return nil }
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Post")
//        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
//        do {
//            let postsManagedObject = try managedContext.fetch(fetchRequest)
//            guard let postManagedObject = postsManagedObject[0] as? NSManagedObject else { return nil }
//            return try JSONDecoder().decode(PostResponseModel.self, from: Data(postManagedObject.toJson()))
//        } catch {
//            return nil
//        }
//    }

    func savePosts(_ posts: [PostResponseModel]) {
        DispatchQueue.main.async {
            guard let managedContext = self.managedContext else { return }
            posts.forEach { (p) in
                do {
                    if self.updatePost(with: p) == nil {
                        _ = try p.toCoreData(context: managedContext)
                    }
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

    private func updatePost(with post: PostResponseModel) -> Bool? {
        if let existingPost = getPostManagedObject(post.id) {
            existingPost.setValue(post.title, forKey: "title")
            existingPost.setValue(post.body, forKey: "body")
            existingPost.setValue(post.userId, forKey: "userId")
            return true
        }
        return nil
    }

}
