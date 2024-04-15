//
//  HomeViewController.swift
//  CryptoX
//
//  Created by uttam ahir on 10/04/24.
//

import UIKit

class HomeViewController: UIViewController {
    var vm: HomeViewModel!
    private var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var homeTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CryptoX"
        setupSearchBar()
        setupView()
        fecthCoin()
    }
    
    private func fecthCoin() {
        Task {[weak self] in
            guard let self = self else { return }
            let responce = await vm.fetchCoinData()
            if responce {
                reloadTableView()
            }
        }
    }
    
    private func reloadTableView() {
        if Thread.isMainThread {
            homeTableView.reloadData()
        } else {
            DispatchQueue.main.async { [weak self] in
              guard let self = self else { return }
              homeTableView.reloadData()
            }
        }
    }
    
    private func navigateToCoinDetailVC(forCoin coin: CoinModel) {
        let vc = CoinDetailVCBuilder().make(coin: coin)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search by name or symbol"
        navigationItem.searchController = searchController
    }
    
    private func setupView() {
        self.view.backgroundColor = .systemBackground
        let guide = view.safeAreaLayoutGuide
        view.addSubview(homeTableView)
        NSLayoutConstraint.activate([
            homeTableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 24),
            homeTableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            homeTableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            homeTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -24),
        ])
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getCoinCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
        cell.configure(for: vm.getHomeCellConfig(forRow: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = vm.getCoin(forRow: indexPath.row)
        navigateToCoinDetailVC(forCoin: coin)
    }
    
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            vm.updateSearchText(text: searchText)
        } else {
            vm.updateSearchText(text: "")
        }
        reloadTableView()
    }
    
    
}
