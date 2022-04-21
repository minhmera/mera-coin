//
//  MeraCoinTests.swift
//  MeraCoinTests
//
//  Created by GoSELL_MacMini on 20/04/2022.
//

import XCTest
import RxBlocking
import RxTest
import RxCocoa
import RxSwift

@testable import MeraCoin

class MeraCoinTests: XCTestCase {
    
    private var coinListViewModel: CoinListViewModel!
    private var coinService: MockCoinService!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    private var mockCoin: CoinModel!
    
    var coinboardVC: CoinboardViewController!
    
    override func setUpWithError() throws {
        mockCoin = CoinModel(base: "MockCoin", counter: "a", buy_price: "123", sell_price: "124", icon: "", name: "MockCoin nè")
        coinService = MockCoinService(coin: mockCoin)
        coinListViewModel = CoinListViewModel(coinService: coinService)
        scheduler = TestScheduler(initialClock: 0, resolution: 1)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testListView() throws {
        let mockVM = MockCoinListViewModel(coin: mockCoin)
        coinboardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoinboardViewController") as? CoinboardViewController
        coinboardVC.loadViewIfNeeded()
        coinboardVC.viewModel = mockVM
        coinboardVC.viewModel.fetchCoin()
        
        coinboardVC.bindTableData()
        coinboardVC.tableView.reloadData()
     
        let cell0 = coinboardVC.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CoinDetailCell
        cell0?.setupData(coinVM: CoinViewModel(coin: mockCoin))
        XCTAssertEqual(cell0?.fullNameLabel.text, "MockCoin nè")
        
    }

    func testCoinListViewModel() throws {
        var to : TestableObserver<[CoinViewModel]>
        to = scheduler.createObserver([CoinViewModel].self)
        _ = coinListViewModel.coinViewModels.subscribe(to)
        scheduler.start()
        coinListViewModel.fetchCoin()
        XCTAssertEqual((to.events[1].value.element?.first!.fullNameText)!, [CoinViewModel(coin: mockCoin)].first?.fullNameText)
    }
}


class MockCoinListViewModel : CoinListViewModelProtocol {

    var hideLoading = BehaviorRelay<Bool>(value: false)
    var coinViewModels = BehaviorSubject<[CoinViewModel]>(value: [])
    private var coinStream = BehaviorSubject<[CoinModel]>(value: [])
    private var mockCoin: CoinModel
    private let bag = DisposeBag()
    
    init(coin: CoinModel) {
        self.mockCoin = coin
    }
    
    func fetchCoin() {
        coinViewModels.onNext([CoinViewModel(coin: mockCoin)])
    }
    
    func localSearch(searchText: String) {
        
    }
}


class MockCoinService: CoinServiceProtocol {
    
    
    var hideLoading = BehaviorRelay<Bool>(value: false)
    var coinStream = BehaviorSubject<[CoinModel]>(value: [])
    var orgCoinStream = BehaviorSubject<[CoinModel]>(value: [])
    
    var mockCoin : CoinModel
    
    init(coin: CoinModel) {
        self.mockCoin = coin
    }
    
    func fetchCoins() {
        coinStream.onNext([mockCoin])
    }
}
