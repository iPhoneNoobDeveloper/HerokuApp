//
//  Category+CoreDataProperties.swift
//  
//


import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var parentId: Int64
    @NSManaged public var childCategories: NSOrderedSet?
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for childCategories
extension Category {

    @objc(insertObject:inChildCategoriesAtIndex:)
    @NSManaged public func insertIntoChildCategories(_ value: Category, at idx: Int)

    @objc(removeObjectFromChildCategoriesAtIndex:)
    @NSManaged public func removeFromChildCategories(at idx: Int)

    @objc(insertChildCategories:atIndexes:)
    @NSManaged public func insertIntoChildCategories(_ values: [Category], at indexes: NSIndexSet)

    @objc(removeChildCategoriesAtIndexes:)
    @NSManaged public func removeFromChildCategories(at indexes: NSIndexSet)

    @objc(replaceObjectInChildCategoriesAtIndex:withObject:)
    @NSManaged public func replaceChildCategories(at idx: Int, with value: Category)

    @objc(replaceChildCategoriesAtIndexes:withChildCategories:)
    @NSManaged public func replaceChildCategories(at indexes: NSIndexSet, with values: [Category])

    @objc(addChildCategoriesObject:)
    @NSManaged public func addToChildCategories(_ value: Category)

    @objc(removeChildCategoriesObject:)
    @NSManaged public func removeFromChildCategories(_ value: Category)

    @objc(addChildCategories:)
    @NSManaged public func addToChildCategories(_ values: NSOrderedSet)

    @objc(removeChildCategories:)
    @NSManaged public func removeFromChildCategories(_ values: NSOrderedSet)

}

// MARK: Generated accessors for products
extension Category {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
