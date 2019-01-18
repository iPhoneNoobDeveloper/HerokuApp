//
//  ProductsViewController.swift
//  HerokuApp
//

import UIKit

class ProductsViewController: UIViewController {

    
    var product:Product?
    var varientsArray = [Varient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        varientsArray = product?.varients?.allObjects as! [Varient]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return varientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailTableViewCell", for: indexPath) as! ProductDetailTableViewCell
        cell.lblColor.text = varientsArray[indexPath.row].color
        cell.lblSize.text = varientsArray[indexPath.row].size > 0 ? "\(varientsArray[indexPath.row].size)" : ""
        cell.lblPrice.text = "\(varientsArray[indexPath.row].price)"
        cell.productId = self.product?.id
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
}


extension ProductsViewController:ProductDetailTableViewCellDelegate {
    func productBuy(productID: Int64, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Purchase Product", message: "Are sure want to purchase this product?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("product purchased")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}
