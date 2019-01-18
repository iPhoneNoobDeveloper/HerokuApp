//
//  Product+CoreDataProperties.swift
//  



import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var orderedCount: Int64
    @NSManaged public var sharedCount: Int64
    @NSManaged public var taxName: String?
    @NSManaged public var taxValue: Float
    @NSManaged public var viewCount: Int64
    @NSManaged public var category: Category?
    @NSManaged public var varients: NSSet?
}

// MARK: Generated accessors for varients
extension Product {

    @objc(addVarientsObject:)
    @NSManaged public func addToVarients(_ value: Varient)

    @objc(removeVarientsObject:)
    @NSManaged public func removeFromVarients(_ value: Varient)

    @objc(addVarients:)
    @NSManaged public func addToVarients(_ values: NSSet)

    @objc(removeVarients:)
    @NSManaged public func removeFromVarients(_ values: NSSet)

}
