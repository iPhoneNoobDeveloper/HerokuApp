//
//  Varient+CoreDataClass.swift
//  


import Foundation
import CoreData

@objc(Varient)
public class Varient: NSManagedObject {
    convenience init(id: Int, color: String, size: String, price: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Varient", in: context) {
            self.init(entity: ent, insertInto: context)
            self.id = Int64(id)
            self.color = color
            self.size = Int64(size) ?? 0
            self.price = Float(price) ?? 0.0
        } else {
            fatalError("Can't find Entity")
        }
    }
}

