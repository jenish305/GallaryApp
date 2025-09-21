//
//  CoreDataManager.swift
//  Gallery application
//
//  Created by Jenish  Mac  on 21/09/25.
//

import Foundation
import CoreData
import UIKit


class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func saveImages(_ urls: [String]) {
        clearImages()

        for (index, url) in urls.enumerated() {
            let image = ImageEntity(context: context)
            image.id = Int64(index)
            image.url = url
        }

        do {
            try context.save()
        } catch {
            print("❌ Failed saving images: \(error)")
        }
    }

    func fetchImages() -> [String] {
        let request: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        do {
            let result = try context.fetch(request)
            return result.compactMap { $0.url }
        } catch {
            print("❌ Failed fetching images: \(error)")
            return []
        }
    }

    private func clearImages() {
        let request: NSFetchRequest<NSFetchRequestResult> = ImageEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("❌ Failed clearing images: \(error)")
        }
    }
}
