//
//  CoinAPI.swift
//  MeraCoin
//
//  Created by GoSELL_MacMini on 17/04/2022.
//

import Foundation
enum APIResponseError : Error {
    case network
    case parsing
    case request
}


class CoinAPI {
    let urlSession: URLSession
    
    
    
    init() {
        let configuration = URLSessionConfiguration.default
        let urlSession = URLSession.init(configuration: configuration)
        self.urlSession = urlSession
    }
    
    init(urlSession: URLSession = URLSession.shared) {
      self.urlSession = urlSession
    }
  
    func fetchAPI(completion: @escaping (_ result: Result<CoinResonseModel, Error>) -> Void) {
        let url = URL(string: "https://www.coinhako.com/api/v3/price/all_prices_for_mobile?counter_currency=USD")
        print(" fetchAPI  \(url)  ")
        let task = urlSession.dataTask(with: url!) {
            (data, response, error) in
            do {
                if let error = error {
                    throw error
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                          completion(Result.failure(APIResponseError.network))
                          return
                }

                if let responseData = data, let object = try? JSONDecoder().decode(CoinResonseModel.self, from: responseData) {
                  completion(Result.success(object))
                } else {
                  throw APIResponseError.parsing
                }
                
            } catch {
                completion(Result.failure(error))
            }
        }
        task.resume()
    }
}
