//
//  StatisticCollectionViewCell.swift
//  CryptoX
//
//  Created by uttam ahir on 11/04/24.
//

import UIKit

class StatisticCollectionViewCell: UICollectionViewCell {
    static let identifier = "StatisticCollectionViewCell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.text = "Loading"
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "0.0"
        return label
    }()
    
    private let percentageChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGreen
        label.textAlignment = .left
        label.text = "0.0%"
        return label
    }()
    
    private lazy var triangleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var percentageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.isHidden = true
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        percentageStackView.addArrangedSubview(triangleImageView)
        percentageStackView.addArrangedSubview(percentageChangeLabel)
        percentageStackView.addArrangedSubview(UIView())
        
        let verticalStackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel, percentageStackView, UIView()])
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 4
        
        addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor,constant: 4),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(with model: StatisticModel) {
        titleLabel.text = model.title
        valueLabel.text = model.value
        configPercentageStackView(percentageChange: model.percentageChange)
    }
    
    private func configPercentageStackView(percentageChange: Double?) {
        guard let percentageChange = percentageChange else { return }
        let isProfit = percentageChange >= 0
        percentageStackView.isHidden = false
        
        percentageChangeLabel.text = percentageChange.asPencentageString()
        percentageChangeLabel.textColor = isProfit ? .systemGreen : .systemRed
        
        let imageName = isProfit ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill"
        triangleImageView.image = UIImage(systemName: imageName)
        triangleImageView.tintColor = (isProfit ? .systemGreen : .systemRed)
    }
}
