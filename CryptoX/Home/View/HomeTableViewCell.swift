//
//  HomeTableViewCell.swift
//  CryptoX
//
//  Created by uttam ahir on 11/04/24.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {

    static let identifier = "HomeTableViewCell"
    private var coinRankLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var coinImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "questionmark")
        return imageView
    }()
    
    private var coinSymbolLabel:  UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    private var coinPriceLabel:  UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    private var coinPriceChangeLabel:  UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let parentView = contentView
        parentView.backgroundColor = .clear
        
        let titleHStack = UIStackView(arrangedSubviews: [coinRankLabel, coinImageView, coinSymbolLabel])
        titleHStack.translatesAutoresizingMaskIntoConstraints = false
        titleHStack.axis = .horizontal
        titleHStack.spacing = 8
        
        let titleVStack = UIStackView(arrangedSubviews: [UIView(),titleHStack, UIView()])
        titleVStack.translatesAutoresizingMaskIntoConstraints = false
        titleVStack.axis = .vertical
        
        let priceVStack = UIStackView(arrangedSubviews: [coinPriceLabel, coinPriceChangeLabel])
        priceVStack.translatesAutoresizingMaskIntoConstraints = false
        priceVStack.axis = .vertical
        priceVStack.spacing = 4
        
        let mainHStack = UIStackView(arrangedSubviews: [titleVStack, UIView(), priceVStack])
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        mainHStack.axis = .horizontal
        
        parentView.addSubview(mainHStack)
        NSLayoutConstraint.activate([
            coinImageView.heightAnchor.constraint(equalToConstant: 30),
            coinImageView.widthAnchor.constraint(equalToConstant: 30),
            
            mainHStack.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 8),
            mainHStack.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 8),
            mainHStack.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -8),
            mainHStack.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(for model: HomeCellConfigModel) {
        coinRankLabel.text = model.rank
        coinPriceLabel.text = model.currentPrice
        coinSymbolLabel.text = model.symbol
        coinPriceChangeLabel.text = model.priceChangePercentage24H
        coinPriceChangeLabel.textColor = model.priceChangePositive ? .systemGreen : .systemRed
        if let url = URL(string: model.imageURL) {
            coinImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "questionmark"))
        }
    }
    
}

