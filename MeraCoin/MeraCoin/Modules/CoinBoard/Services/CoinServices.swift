//
//  CoinServices.swift
//  MeraCoin
//
//  Created by GoSELL_MacMini on 17/04/2022.
//

import Foundation
import RxSwift
import RxCocoa


protocol CoinServiceProtocol {
    var hideLoading: BehaviorRelay<Bool> { get }
   
    var coinStream: BehaviorSubject<[CoinModel]> { get }
    var orgCoinStream: BehaviorSubject<[CoinModel]> { get }
    

    func fetchCoins()
}

class CoinService: CoinServiceProtocol {

    var hideLoading = BehaviorRelay<Bool>(value: false)
    var coinStream = BehaviorSubject<[CoinModel]>(value: [])
    var orgCoinStream = BehaviorSubject<[CoinModel]>(value: [])

    func fetchCoins() {
        self.hideLoading.accept(false)
        
        let apiClient = CoinAPI()
        
        
        apiClient.fetchAPI { result in
            self.hideLoading.accept(true)
            switch result {
            case .success(let coinModel):
                self.coinStream.onNext(coinModel.data)
                self.orgCoinStream.onNext(coinModel.data)
            case .failure(let error):
                self.coinStream.onError(error)
            }
        }

    }
}


