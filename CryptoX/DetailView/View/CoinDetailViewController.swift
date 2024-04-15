//
//  CoinDetailViewController.swift
//  CryptoX
//
//  Created by uttam ahir on 11/04/24.
//

import UIKit
import Kingfisher

class CoinDetailViewController: UIViewController {
    
    var vm: CoinDetailViewModel!
    private var chartView: ChartView!
    private var descriptionVStack = UIStackView()
    private var linkVStack = UIStackView()
    private var statisticsVStack = UIStackView()
    private var mainVStack = UIStackView()
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        if let url = URL(string: vm.getCoinImage()) {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "questionmark.circle"))
        } else {
            imageView.image = UIImage(systemName: "questionmark.circle")
            imageView.tintColor = .systemBlue
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return imageView
    }()
    
    private var overviewLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "OverView"
        return label
    }()
    
    private var readMoreButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Read more", for: .normal)
        button.isHidden = true
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var coinDetailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(StatisticCollectionViewCell.self, forCellWithReuseIdentifier: StatisticCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView()
        setupView()
        fetchDetail()
    }
    
    private func setupHeaderView() {
        self.title = vm.getCoinModel().name
        self.navigationItem.rightBarButtonItem = .init(customView: coinImageView)
    }
    
    //MARK: API Call
    private func fetchDetail() {
        Task {[weak self] in
            guard let self = self else { return }
            let responce = await vm.fetchCoinDetail()
            if responce {
                setViewValues()
                reloadCollectionView()
            } else {
                showErrorMessage()
            }
        }
    }
    
    private func setViewValues() {
        guard let model = vm.getCoinDetailResponse() else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let description = model.coinDescription, !description.isEmpty {
                descriptionLabel.text = description
                readMoreButton.isHidden = false
            }
        }
    }
    
    private func reloadCollectionView() {
        if Thread.isMainThread {
            coinDetailCollectionView.reloadData()
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.coinDetailCollectionView.reloadData()
            }
        }
    }
    
    @objc private func didTapReadMore() {
        guard let model = vm.getCoinDetailResponse() else { return }
        let vc = CoinDescriptionVCBuilder().make(forModel: model)
        self.present(vc, animated: true)
    }
    
    private func showErrorMessage() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alertVC = UIAlertController(title: "Error", message: "Please try after sometime.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) {[weak self] alert in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }

}

//MARK: UI Setup
fileprivate extension CoinDetailViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupChartView()
        setupDescriptionVStack()
        setupMainVStack()
    }
    
    func setupScrollView() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 24),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
    }
    
    func setupChartView() {
        chartView = ChartView(coin: vm.getCoinModel())
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        
    }
    
    func setupDescriptionVStack() {
        readMoreButton.addTarget(self, action: #selector(didTapReadMore), for: .touchUpInside)
        descriptionVStack = UIStackView(arrangedSubviews: [descriptionLabel, readMoreButton])
        descriptionVStack.translatesAutoresizingMaskIntoConstraints = false
        descriptionVStack.axis = .vertical
        descriptionVStack.spacing = 4
        descriptionVStack.alignment = .leading
    }
    
    func setupMainVStack() {
        let mainVStack = UIStackView(arrangedSubviews: [chartView, overviewLabel, descriptionVStack, coinDetailCollectionView])
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        mainVStack.axis = .vertical
        mainVStack.spacing = 16
        
        scrollView.addSubview(mainVStack)
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            mainVStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            mainVStack.widthAnchor.constraint(equalToConstant: view.bounds.width - 40),
            mainVStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainVStack.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
        self.mainVStack = mainVStack
    }
}

//MARK: CollectionView delegate
extension CoinDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.getStatisticModelCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticCollectionViewCell.identifier, for: indexPath) as! StatisticCollectionViewCell
        cell.configure(with: vm.getStatisticModel(forRow: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 40
        let numberOfRow: CGFloat = 2
        let width = (collectionView.bounds.width - spacing) / numberOfRow
        let height = width - spacing
        return CGSize(width: width, height: height)
    }
    
}


