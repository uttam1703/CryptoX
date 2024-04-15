//
//  ChartView.swift
//  CryptoX
//
//  Created by uttam ahir on 13/04/24.
//

import UIKit

final class ChartView: UIView {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let startingDate: Date
    private let endingDate: Date
    private var chartSubView: ChartSubView
    
    private var yAxisView = UIView()
    private var dateLabelView = UIView()
    
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        self.endingDate = Date(coinGechoString: coin.lastUpdated ?? "")
        self.startingDate = endingDate.addingTimeInterval(-(7 * 24 * 60 * 60))
        self.chartSubView = ChartSubView(data: data)
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupChartYAxis()
        setupChartDateLabel()
        
        chartSubView.translatesAutoresizingMaskIntoConstraints = false
        chartSubView.backgroundColor = .clear
        addSubview(chartSubView)
        
        yAxisView.backgroundColor = .clear
        addSubview(yAxisView)
        
        dateLabelView.backgroundColor = .clear
        addSubview(dateLabelView)
    }
    
    private func setupConstraints() {
        
        
        NSLayoutConstraint.activate([
            chartSubView.topAnchor.constraint(equalTo: topAnchor),
            chartSubView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartSubView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartSubView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            yAxisView.topAnchor.constraint(equalTo: topAnchor),
            yAxisView.leadingAnchor.constraint(equalTo: leadingAnchor),
            yAxisView.trailingAnchor.constraint(equalTo: trailingAnchor),
            yAxisView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            dateLabelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLabelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLabelView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dateLabelView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupChartDateLabel() {
        let startingDateLabel = createLabel(text: startingDate.asShortStringDate())
        startingDateLabel.textAlignment = .left
        let endingDateLabel = createLabel(text: endingDate.asShortStringDate())
        endingDateLabel.textAlignment = .right
        
        let dateLabelHView = UIStackView(arrangedSubviews: [startingDateLabel,UIView(), endingDateLabel])
        dateLabelHView.backgroundColor = .clear
        dateLabelHView.axis = .horizontal
        dateLabelHView.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabelView = dateLabelHView
    }
    
    private func setupChartYAxis() {
        
        let separtorView1 = createSepartorLine()
        let maxYLabel = createLabel(text: "\(maxY.formattedWithAbbreviations())")
        let maxYLabelVStack = UIStackView(arrangedSubviews: [separtorView1, maxYLabel, UIView()])
        maxYLabelVStack.translatesAutoresizingMaskIntoConstraints = false
        maxYLabelVStack.axis = .vertical
        
        
        let separtorView2 = createSepartorLine()
        let minYLabel = createLabel(text: "\(minY.formattedWithAbbreviations())")
        let minYLabelVStack = UIStackView(arrangedSubviews: [UIView(), minYLabel, separtorView2])
        minYLabelVStack.translatesAutoresizingMaskIntoConstraints = false
        minYLabelVStack.axis = .vertical
        
        let yAxisView = UIStackView(arrangedSubviews: [maxYLabelVStack, minYLabelVStack])
        yAxisView.backgroundColor = .clear
        yAxisView.axis = .vertical
        yAxisView.translatesAutoresizingMaskIntoConstraints = false
        yAxisView.distribution = .fillEqually
        
        
        self.yAxisView = yAxisView
    }
    
    private func createSepartorLine() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.text = text
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }
    
}

