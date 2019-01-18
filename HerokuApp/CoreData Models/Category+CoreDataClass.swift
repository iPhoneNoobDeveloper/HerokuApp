//
//  Category+CoreDataClass.swift
//  


import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    
    convenience init(id: Int, name: String,parentId:Int ,context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Category", in: context) {
            self.init(entity: ent, insertInto: context)
            self.id = Int64(id)
            self.name = name
            self.parentId = Int64(parentId)
        } else {
            fatalError("Can't find Entity")
        }
    }
}


extension Category{
    class func insertJsonData (json:Result) {
        
        var dictViewCount = [Int: Int]()
        var dictOrderCount = [Int: Int]()
        var dictShares = [Int: Int]()
        var dictParent = [Int: Int]()
        
        let categoriesArray = json.categories!
        let rankingArray = json.rankings!
        for count in 0..<rankingArray.count {
            let productRankingArray = rankingArray[count].products!
            for rankcount in 0..<productRankingArray.count {
                let id = productRankingArray[rankcount].id!
                if (productRankingArray[rankcount].view_count != nil) {
                    dictViewCount[id] = productRankingArray[rankcount].view_count
                }
                else if (productRankingArray[rankcount].order_count != nil) {
                    dictOrderCount[id] = productRankingArray[rankcount].order_count
                }
                else if (productRankingArray[rankcount].shares != nil) {
                    dictShares[id] = productRankingArray[rankcount].shares
                }
            }
        }
        
        if categoriesArray.count > 0 {
            for category in 0..<categoriesArray.count {
                if categoriesArray[category].products != nil {
                    if let childCategoryArray = categoriesArray[category].child_categories{
                        for childCount in 0..<childCategoryArray.count {
                            dictParent[childCategoryArray[childCount]] = categoriesArray[category].id
                        }
                    }
                }
            }
        }
        
        // saving data in core data
        
        if categoriesArray.count > 0 {
            for category in 0...(categoriesArray.count - 1) {
                let categoryId = categoriesArray[category].id!
                let categoryName = categoriesArray[category].name!
                let categoryProduct = categoriesArray[category].products!
                
                // saving category
                let privateContext = CoreDataManager.sharedInstance.privateContext
                let categoryData = Category(id: categoryId, name: categoryName,parentId:dictParent[categoryId, default: 0], context: privateContext)
                CoreDataManager.sharedInstance.saveTo(context: privateContext)
                
                // Inserting Product Data
                Product.insertProductData(categoryProduct: categoryProduct, dictViewCount: dictViewCount, dictOrderCount: dictOrderCount, dictShares: dictShares, categoryData: categoryData)
            }
            //Utility.sharedInstance.stopLoading()
        }
        else {
            //Utility.sharedInstance.stopLoading()
        }
    }
}

