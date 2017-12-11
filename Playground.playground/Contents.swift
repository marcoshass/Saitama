//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport

typealias JSONDictionary = [String: AnyObject]

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
