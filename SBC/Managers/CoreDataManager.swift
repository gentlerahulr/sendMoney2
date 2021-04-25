import CoreData
import Foundation
import UIKit

class CoreDataManager {
//------------------------------------------------------------------
// MARK: Database handling
//------------------------------------------------------------------
let appDelegate = UIApplication.shared.delegate as! AppDelegate
var context: NSManagedObjectContext!
    
    static var sharedCDManager: CoreDataManager?
    class func shared() -> CoreDataManager {
        if sharedCDManager == nil {
            sharedCDManager = CoreDataManager()
        }
        return sharedCDManager!
    }
    
func saveTrendingSearchObject(object: Trendings) {
    context = appDelegate.persistentContainer.viewContext
    
    if let trendings = object.data {
        deleteAll(entityName: "TrendingDB")
        for trending in trendings {
            let newTrending = NSEntityDescription.insertNewObject(forEntityName: "TrendingDB", into: context)
            newTrending.setValue(trending, forKey: "title")
        }
    }
    do {
        try context.save()
    } catch {
        print("Storing data Failed")
    }
}
func fetchTrendings() -> Trendings? {
    context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TrendingDB")
    var retrievedTrendings = Trendings()
    retrievedTrendings.data = []
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
            if let title = data.value(forKey: "title") as? String {
                retrievedTrendings.data?.append(title)
            }
        }
    } catch {
        print("Fetching data Failed")
    }
    return retrievedTrendings
}

func saveCuisines(object: Cuisines) {
    context = appDelegate.persistentContainer.viewContext
    let newObject = NSEntityDescription.insertNewObject(forEntityName: "CuisinesDB", into: context)
    if let cuisines = object.data {
        deleteAll(entityName: "CuisineDB")
        for cuisine in cuisines {
            let newCuisine = NSEntityDescription.insertNewObject(forEntityName: "CuisineDB", into: context)
            newCuisine.setValue(cuisine.name, forKey: "name")
            newCuisine.setValue(cuisine.id, forKey: "id")
            newCuisine.setValue(cuisine.imageUrl, forKey: "imageUrl")
            newCuisine.setValue(cuisine.isLiked, forKey: "isLiked")
        }
    }
    
    newObject.setValue(object.limit, forKey: "limit")
    newObject.setValue(object.count, forKey: "count")
    newObject.setValue(object.nextPageToken, forKey: "nextPageToken")
    do {
        try context.save()
    } catch {
        print("Storing data Failed")
    }
}

func fetchCuisines() -> [Cuisine]? {
    context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CuisineDB")
    var retrievedCuisines: [Cuisine] = []
    request.returnsObjectsAsFaults = false
    do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
            let id = data.value(forKey: "id") as? String
            let name = data.value(forKey: "name") as? String
            let imageUrl = data.value(forKey: "imageUrl") as? String
            let isLiked = data.value(forKey: "isLiked") as? Bool
            let cuisine = Cuisine(name: name, imageUrl: imageUrl, id: id ?? "", isLiked: isLiked ?? false)
            retrievedCuisines.append(cuisine)
        }
    } catch {
        print("Fetching data Failed")
    }
    return retrievedCuisines
}

func deleteAll(entityName: String) {
       //delete all data
       let context = appDelegate.persistentContainer.viewContext

       let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
       let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

       do {
           try context.execute(deleteRequest)
           try context.save()
       } catch {
           print("There was an error")
       }
   }
}
