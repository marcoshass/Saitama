//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport

typealias JSONDictionary = [String: AnyObject]

// ----------------------------------------------------------------------------
// Place
// ----------------------------------------------------------------------------

let CREATEDAT: String = "createdAt"
let ID: String = "id"
let LOCATION: String = "location"
let NAME: String = "name"
let UPDATEDAT: String = "updatedAt"

struct Place {
    let createdAt: String?
    let id: String?
    let location: String?
    let name: String?
    let updatedAt: String?
}

extension Place {
    init(dictionary: JSONDictionary) {
        self.createdAt = dictionary[CREATEDAT] as? String
        self.id = dictionary[ID] as? String
        self.location = dictionary[LOCATION] as? String
        self.name = dictionary[NAME] as? String
        self.updatedAt = dictionary[UPDATEDAT] as? String
    }
}

// ----------------------------------------------------------------------------
// API
// ----------------------------------------------------------------------------

struct Resource<T> {
    let url: URL
    let parse: (Data) -> T?
}

extension Resource {
    init(url: URL, parseJSON: @escaping (AnyObject)->(T?)) {
        self.url = url
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            return json.flatMap(parseJSON)
        }
    }
}

final class WebService {
    
    func load<T>(resource: Resource<T>, completion: @escaping (T?, Error?) ->()) {
        URLSession.shared.dataTask(with: resource.url) {(data, _, error) in
            guard let data = data else { completion(nil, error); return }
            completion(resource.parse(data), error)
        }.resume()
    }
    
}

/** Enum is not assigned a default integer value when they are
 * created each element is of type 'Status'.
 */
enum Status { // Should Start With A Capital Letter
    
    // you can set a constant or a varible to each case
    // and check this value later on. This feature is
    // known as an 'associated value'
    case aberta, em_andamento, fechada, apropriada
}

enum Barcode {
    // the associated values can be extracted as part of the switch statement
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

// ----------------------------------------------------------------------------
// Client
// ----------------------------------------------------------------------------

PlaygroundPage.current.needsIndefiniteExecution = true

var status: Status = .apropriada

// switch case is exhaustive when considering enumeration's cases
// if some case is omitted the code won't compile
switch status {
case .aberta:
    print("aberta")
case .em_andamento:
    print("em andamento")
case .fechada:
    print("fechada")
default:
    print("apropriada")
}

var productBarCode: Barcode
productBarCode = .upc(8, 85909, 51226, 3)
productBarCode = .qrCode("ABCDEFGHIJKLMNOP")

// associated values can be extracted during  a switch-case statement
switch productBarCode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("upc:\(numberSystem), \(manufacturer), \(product), \(check)")
case .qrCode(let productCode):
    print("qr-code=\(productCode)")
}

// summarized version
switch productBarCode {
case let .upc(numberSystem, manufacturer, product, check):
    print("upc:\(numberSystem), \(manufacturer), \(product), \(check)")
case let .qrCode(productCode):
    print("qr-code=\(productCode)")
}
