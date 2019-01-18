//
//  ProductDetailTableViewCell.swift
//


import UIKit

protocol ProductDetailTableViewCellDelegate {
    func productBuy(productID:Int64,indexPath:IndexPath)
}


class ProductDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    
    var delegate:ProductDetailTableViewCellDelegate!
    var productId:Int64?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   
}
