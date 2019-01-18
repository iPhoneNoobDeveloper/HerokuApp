//
//  Product+CoreDataClass.swift
//


import Foundation
import CoreData

@objc(Product)
public class Product: NSManagedObject {
    convenience init(id: Int, name: String, dateAdded: String, taxName: String, taxValue: String, viewCount: Int, orderCount: Int, shares: Int, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Product", in: context) {
            self.init(entity: ent, insertInto: context)
            self.id = Int64(id)
            self.name = name
            //self.dateAdded = Utility.sharedInstance.stringToDate(dateString: dateAdded) as NSDate
            self.taxName = taxName
            self.taxValue = Float(taxValue)!
            self.viewCount = Int64(viewCount)
            self.orderedCount = Int64(orderCount)
            self.sharedCount = Int64(shares)
        } else {
            fatalError("Can't find Entity")
        }
    }
}

extension Product {
    class func insertProductData(categoryProduct:[Products], dictViewCount:[Int: Int],dictOrderCount:[Int: Int],dictShares:[Int: Int], categoryData:Category){
        
        let privateContext = CoreDataManager.sharedInstance.privateContext
        
        if categoryProduct.count > 0 {
            for productCount in 0..<categoryProduct.count {
                let id = categoryProduct[productCount].id!
                let name = categoryProduct[productCount].name!
                let date = categoryProduct[productCount].date_added!
                let taxName = categoryProduct[productCount].tax?.name
                let taxValue = Double(categoryProduct[productCount].tax?.value ?? 0.0)
                let Variants = categoryProduct[productCount].variants!
                let ViewCount = dictViewCount[id]
                let OrderCount = dictOrderCount[id]
                let Shares = dictShares[id]
                
                // saving products
                
                let productCD = Product(id: id, name: name, dateAdded: date, taxName: taxName!, taxValue: "\(taxValue)", viewCount: ViewCount ?? 0, orderCount: OrderCount ?? 0, shares: Shares ?? 0, context: privateContext)
                productCD.category = categoryData
                CoreDataManager.sharedInstance.saveTo(context: privateContext)
                
                if Variants.count > 0 {
                    for variantCount in 0..<Variants.count {
                        let vId = Variants[variantCount].id!
                        let vColor = Variants[variantCount].color ?? ""
                        let vSize = Variants[variantCount].size ?? 0
                        let vPrice = Variants[variantCount].price ?? 0
                        
                        // saving variants
                        
                        let variantCD = Varient(id: vId, color: vColor, size: "\(vSize)", price: "\(vPrice)", context: privateContext)
                        variantCD.product = productCD
                        CoreDataManager.sharedInstance.saveTo(context: privateContext)
                    }
                }
            }
        }
    }
}
