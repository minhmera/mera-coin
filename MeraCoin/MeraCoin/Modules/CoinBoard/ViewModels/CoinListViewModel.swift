//
//  CoinBoardViewModel.swift
//  MeraCoin
//
//  Created by GoSELL_MacMini on 17/04/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol CoinListViewModelProtocol {
    var hideLoading: BehaviorRelay<Bool> { get }
    var coinViewModels: BehaviorSubject<[CoinViewModel]> { get }
    
    func fetchCoin()
    func localSearch(searchText: String)

}

final class CoinListViewModel: CoinListViewModelProtocol {
    
    let hideLoading: BehaviorRelay<Bool>
    private let coinService: CoinServiceProtocol
    let coinViewModels = BehaviorSubject<[CoinViewModel]>(value: [])
    
    private let bag = DisposeBag()
    private var timer: Timer!
    private let defaultFireInterval = 30.0
    private var counting: Bool = false
    
    init(coinService: CoinServiceProtocol) {
        self.coinService    = coinService
        self.hideLoading    = coinService.hideLoading
        
        coinService.coinStream.map {
            $0.map {
                CoinViewModel(coin: $0)
            }
        }
        .bind(to: coinViewModels).disposed(by: bag)
        setupTimer()
    }
    
    private func setupTimer() {
        hideLoading.accept(false)
        timer = Timer.scheduledTimer(timeInterval: defaultFireInterval,
                                                       target: self,
                                                       selector: #selector(fetchCoinInSecond),
                                                       userInfo: nil,
                                                       repeats: true)
        
        //RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        counting = true
    }
    
    func disposeTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    @objc func fetchCoinInSecond() {
        fetchCoin()
    }
    
    func fetchCoin() {
        coinService.fetchCoins()
    }
    
    func localSearch(searchText: String) {
        do {
            let snapShot: [CoinModel] = try coinService.orgCoinStream.value()
            if searchText == "" {
                self.coinService.coinStream.onNext(snapShot)
            } else {
                let filteredData: [CoinModel] = snapShot.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
                self.coinService.coinStream.onNext(filteredData)
            }
            
        } catch {
            print(error)
        }
    }
    
    deinit {
        disposeTimer()
    }
    

}
