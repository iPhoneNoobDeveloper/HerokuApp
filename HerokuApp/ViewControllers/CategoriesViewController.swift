//
//  CategoriesViewController.swift
//  HerokuApp


import UIKit
import CoreData

class CategoriesViewController: UIViewController {
    
    var parentCategory: Category?
    var categoryTypes = CELL_TYPES.noCategory
    
    lazy var categoryResults: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        if let category = parentCategory  {
            fetchRequest.predicate = NSPredicate(format: "parentId == %@","\(category.id)")
        } else {
            fetchRequest.predicate = NSPredicate(format: "parentId == 0")
        }
        
        let resultsController = NSFetchedResultsController<Category>(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.privateContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
    
    fileprivate let router = ServiceRouter()
    
    @IBOutlet weak var categoryTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = AppStrings.navigationTitle

        if (parentCategory == nil) {
            self.fetchCategories()
        }
        do {
            try categoryResults.performFetch()
        } catch {
            print("Unable to fetch Data \(error)")
        }
        
    }
    
    func fetchCategories(){
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        router.requestForCategories { (jsonData) in
            
            guard let json = jsonData else {
                return
            }
            DispatchQueue.main.async {
                Category.insertJsonData(json: json as! Result)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    func pushToChildCategoryViewController(category: Category) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let childViewController = storyboard.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        childViewController.parentCategory = category
        navigationController?.pushViewController(childViewController, animated: true)
    }
    
    func pushToProductDetailViewController(product: Product) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailViewController = storyboard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
        productDetailViewController.product = product
        productDetailViewController.title = product.name
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}


extension CategoriesViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = categoryResults.sections {
            let section = sections[section]
            if section.numberOfObjects > 0 {
                categoryTypes = .category
                return section.numberOfObjects
            } else if let products = parentCategory?.products?.allObjects as? [Product], products.count > 0 {
                categoryTypes = .product
                return products.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CagetoriesCell", for: indexPath) as! CategoryTableViewCell
        switch categoryTypes {
        case .category:
            configureCategoryCell(cell , indexPath: indexPath)
        case .product:
            configureProductCell(cell , indexPath: indexPath)
        default:
            print("Error occured no category found")
        }
        return cell
    }
    
    func configureCategoryCell(_ cell: CategoryTableViewCell, indexPath: IndexPath) {
        let category = categoryResults.object(at: indexPath)
        cell.categoryTitleLabel.text = category.name
        cell.categoryImageLabel.text = String((category.name?.character(at: 0))!)
    }
    
    func configureProductCell(_ cell: CategoryTableViewCell, indexPath: IndexPath) {
        guard let product = parentCategory?.products?.allObjects[indexPath.row] as? Product else { return }
        cell.categoryTitleLabel.text = product.name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        switch categoryTypes {
        case .category:
            let category = categoryResults.object(at: indexPath)
            pushToChildCategoryViewController(category: category)
        case .product:
            guard let product = parentCategory?.products?.allObjects[indexPath.row] as? Product else { return }
            pushToProductDetailViewController(product: product)
        default:
            print("Error occured.")
        }
    }
}

extension String {
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CategoriesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.categoryTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                self.categoryTableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                self.categoryTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                if let cell = self.categoryTableView.cellForRow(at: indexPath) {
                    configureCategoryCell(cell as! CategoryTableViewCell, indexPath: indexPath)
                }
            }
            break;
        case .move:
            if let indexPath = indexPath {
                self.categoryTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                self.categoryTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.categoryTableView.endUpdates()
    }
}
