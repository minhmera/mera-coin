//
//  CoinboardViewController.swift
//  MeraCoin
//
//  Created by GoSELL_MacMini on 17/04/2022.
//

import UIKit
import RxSwift
import RxCocoa


class CoinboardViewController: BaseViewController {

    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var iconClearSearch: UIImageView!
    
    
    var viewModel: CoinListViewModelProtocol = CoinListViewModel(coinService: CoinService())
    private var disposeBag = DisposeBag()
    
    
    
    @IBAction func btnClearSearchAction(_ sender: Any) {
        resetTextField()
        viewModel.localSearch(searchText: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindTableData()
        bindLoading()
        bindSearchView()
        
        showLoading()
        viewModel.fetchCoin()
        
    }
    
    @objc private func refreshCoinData(_ sender: Any) {
        viewModel.fetchCoin()
    }
    
    func setupUI() {
        showEmptyData(isShow: false)
        tableView.register(UINib(nibName: "CoinDetailCell", bundle: nil), forCellReuseIdentifier: "CoinDetailCell")
        
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshCoinData(_:)), for: .valueChanged)
        
        searchView.layer.cornerRadius = 12
        iconClearSearch.isHidden = true
    }
    
    private func resetTextField() {
        searchTF.text = ""
        
    }
    
    private func showClearSearchIcon() {
        if searchTF.text == "" {
            iconClearSearch.isHidden = true
        } else {
            iconClearSearch.isHidden = false
        }
        
    }
    
    private func showEmptyData(isShow: Bool) {
        if isShow {
            self.tableView.isHidden = true
        } else {
            self.tableView.isHidden = false
        }
    }
    
    func bindSearchView() {
        searchTF.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                let searchText: String =  self.searchTF.text ?? ""
                showClearSearchIcon()
                viewModel.localSearch(searchText: searchText)
            }).disposed(by: disposeBag)
    }
    
    func bindLoading() {
        viewModel.hideLoading.subscribe(onNext: {
            hide in
            
            if (hide) {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.hideLoading()
                }
            } else {
            /* show loading here if needed
                DispatchQueue.main.async {
                    self.showLoading()
                }
                */
            }
        })
            .disposed(by: disposeBag)
    }
    
    func bindTableData() {
        tableView.delegate = nil
        tableView.dataSource = nil
        viewModel.coinViewModels.observe(on: MainScheduler.instance)
            .filter({ [weak self] array in
                guard let self = self else {return true}
                
                if array.isEmpty && self.searchTF.text != "" {
                    self.showEmptyData(isShow: true)
                } else {
                    self.showEmptyData(isShow: false)
                }
                return true
            })
        
            .bind(to: tableView.rx.items(cellIdentifier: "CoinDetailCell", cellType: CoinDetailCell.self)) {
                row, cellViewModel, cell in
                cell.setupData(coinVM: cellViewModel)
            }
            .disposed(by: disposeBag)
        tableView.rx.modelSelected(CoinViewModel.self).bind { coinViewModel in
            print("You clicked on \(coinViewModel.fullNameText)")
        }
        .disposed(by: disposeBag)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
   
    
}



extension CoinboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
