//
//  APITest.swift
//  MeraCoinTests
//
//  Created by GoSELL_MacMini on 20/04/2022.
//

import Foundation
import XCTest
@testable import MeraCoin


class APITest: XCTestCase {
    
    var coinAPI: CoinAPI!
    var expectation: XCTestExpectation!
    let apiURL = URL(string: "https://www.coinhako.com/api/v3/price/all_prices_for_mobile?counter_currency=USD")!
    
    override func setUpWithError() throws {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        coinAPI = CoinAPI(urlSession: urlSession)
        expectation = expectation(description: "Expectation")
    }
    
    func testSuccessfulResponse() {
        let name = "Litecoin"
        let buyPrice = "112.748"
        let jsonString = """
                         {
                           "data": [
                             {
                               "base": "LTC",
                               "counter": "USD",
                               "buy_price": "\(buyPrice)",
                               "sell_price": "110.899",
                               "icon": "https://cdn.coinhako.com/assets/wallet-ltc-e4ce25a8fb34c45d40165b6f4eecfbca2729c40c20611acd45ea0dc3ab50f8a6.png",
                               "name": "\(name)"
                             }
                           ]
                         }
                         """
        
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
          guard let url = request.url, url == self.apiURL else {
            throw APIResponseError.request
          }
          let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
        
        coinAPI.fetchAPI { (result) in
            switch result {
            case .success(let coinModel):
                XCTAssertEqual(coinModel.data.first?.name, name, "Incorrect name")
            case .failure(let error):
                XCTFail("Error was not expected: \(error)")
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    
    func testParsingFailure() {
        // Prepare response
        let data = Data()
        MockURLProtocol.requestHandler = { request in
          let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
          return (response, data)
        }
        
        // Call API.
        coinAPI.fetchAPI { (result) in
          switch result {
          case .success(_):
            XCTFail("Success response was not expected.")
          case .failure(let error):
            guard let error = error as? APIResponseError else {
              XCTFail("Incorrect error received.")
              self.expectation.fulfill()
              return
            }
            
            XCTAssertEqual(error, APIResponseError.parsing, "Parsing error was expected.")
          }
          self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
      }
}


class MockURLProtocol: URLProtocol {
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
    
  static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

  override func startLoading() {
      guard let handler = MockURLProtocol.requestHandler else {
          fatalError("Handler is unavailable.")
        }
          
        do {
          let (response, data) = try handler(request)
          
          client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
          
          if let data = data {
            client?.urlProtocol(self, didLoad: data)
          }
          
          client?.urlProtocolDidFinishLoading(self)
        } catch {
          client?.urlProtocol(self, didFailWithError: error)
        }
  }

  override func stopLoading() {}
}
