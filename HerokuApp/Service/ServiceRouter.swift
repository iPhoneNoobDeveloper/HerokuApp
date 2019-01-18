//
//  ServiceRouter.swift
//  HerokuApp
//


import UIKit



class ServiceRouter: NSObject {
    
    var requestCancelStatus = false
    
    lazy var urlPath: URL = {
        let urlPath = URL(string:"\(ConfigUrl.API_BASE_URL)\(ConfigUrl.RESPONSE_FORMAT)")
        return urlPath!
    }()
    
    fileprivate var task: URLSessionTask?
    
    //MARK: - Cancel all previous tasks
    func cancelTask(){
        requestCancelStatus = true
        task?.cancel()
    }
    
}

extension ServiceRouter: SearchTextSpaceRemover{
    
    func requestForCategories(completionHandler: @escaping(_ responseData:Any?) -> () ){
        
        let keyword = self.urlPath.absoluteString.removeSpace
        guard keyword.count != 0 else { return }
        
        //Set timeout for request
        requestTimeOut()
        
        print(urlPath)
        URLSession.shared.dataTask(with: self.urlPath) { (data, response, error) in
            guard error == nil
                else {
                    print(error!.localizedDescription)
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    return
                }
            
            guard let data = data
                else {
                    print(error!.localizedDescription)
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    return
            }
            
            do {
                
                CoreDataManager.sharedInstance.clearPersistence()
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let response = jsonResponse as! NSDictionary
                let data = try! JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.init(rawValue: 0))
                let decode = try JSONDecoder().decode(Result.self, from: data)
                completionHandler(decode)
            }
            catch let error
            {
                print(error)
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            
        }.resume()
        
    }
    
    /**
     Adding here timeout for cancel current task if any case request not getting success or taking too much time because of internet. Default time out is 15 seconds.
     */
    fileprivate func requestTimeOut(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20), execute: {
            self.task?.resume()
        })
    }
}


protocol SearchTextSpaceRemover{}

extension String: SearchTextSpaceRemover {
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension SearchTextSpaceRemover where Self == String {
    
    //MARK: - Removing space from String
    var removeSpace: String {
        if self.isNotEmpty {
            return self.components(separatedBy: .whitespaces).joined()
        }else{
            return ""
        }
    }
}


struct Result : Codable {
    let categories : [Categories]?
    let rankings : [Rankings]?
    
    enum CodingKeys: String, CodingKey {
        case categories = "categories"
        case rankings = "rankings"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categories = try values.decodeIfPresent([Categories].self, forKey: .categories)
        rankings = try values.decodeIfPresent([Rankings].self, forKey: .rankings)
    }
    
}

struct Categories : Codable {
    let id : Int?
    let name : String?
    let products : [Products]?
    let child_categories : [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case products = "products"
        case child_categories = "child_categories"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        products = try values.decodeIfPresent([Products].self, forKey: .products)
        child_categories = try values.decodeIfPresent([Int].self, forKey: .child_categories)
    }
    
}

struct Products : Codable {
    let id : Int?
    let view_count : Int?
    let order_count : Int?
    let shares : Int?
    let name: String?
    let date_added: String?
    let variants : [Variants]?
    let tax : Tax?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case view_count = "view_count"
        case order_count = "order_count"
        case shares = "shares"
        case name = "name"
        case date_added = "date_added"
        case variants = "variants"
        case tax = "tax"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        view_count = try values.decodeIfPresent(Int.self, forKey: .view_count)
        order_count = try values.decodeIfPresent(Int.self, forKey: .order_count)
        shares = try values.decodeIfPresent(Int.self, forKey: .shares)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        date_added = try values.decodeIfPresent(String.self, forKey: .date_added)
        variants = try values.decodeIfPresent([Variants].self, forKey: .variants)
        tax = try values.decodeIfPresent(Tax.self, forKey: .tax)
    }
    
}


struct Rankings : Codable {
    let ranking : String?
    let products : [Products]?
    
    enum CodingKeys: String, CodingKey {
        
        case ranking = "ranking"
        case products = "products"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ranking = try values.decodeIfPresent(String.self, forKey: .ranking)
        products = try values.decodeIfPresent([Products].self, forKey: .products)
    }
    
}

struct Tax : Codable {
    let name : String?
    let value : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case value = "value"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        value = try values.decodeIfPresent(Double.self, forKey: .value)
    }
}

struct Variants : Codable {
    let id : Int?
    let color : String?
    let size : Int?
    let price : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case color = "color"
        case size = "size"
        case price = "price"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        size = try values.decodeIfPresent(Int.self, forKey: .size)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
    }
    
}

