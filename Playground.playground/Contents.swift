//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport
import SaitamaPlayground

PlaygroundPage.current.needsIndefiniteExecution = true

// ----------------------------------------------------------------------------
// Api
// ----------------------------------------------------------------------------

func testWebServiceLoad() {
    let url = URL(string: "http://www.mocky.io/v2/599f29ea2c0000820151d480")!
    let resource = Resource(url: url) { (_) -> NSObject? in return nil }
    WebService(session: MockURLSession()).load(resource) { (data, error) in
    }
}

class MockURLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        print("datatask=called")
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {
        print("resume=called")
    }
}

// ----------------------------------------------------------------------------
// Client
// ----------------------------------------------------------------------------

testWebServiceLoad()