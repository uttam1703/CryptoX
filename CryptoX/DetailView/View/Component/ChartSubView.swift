//
//  ChartSubView.swift
//  CryptoX
//
//  Created by uttam ahir on 13/04/24.
//

import UIKit
final class ChartSubView: UIView {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: UIColor
    
    init(data: [Double]) {
        self.data = data
        
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        
        let priceChange = (data.first ?? 0) - (data.last ?? 0)
        self.lineColor = priceChange > 0 ? .systemRed : .systemGreen
        
        
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let path = UIBezierPath()
        
        for (index, _) in data.enumerated() {
            let xPosition = rect.width / CGFloat(data.count) * CGFloat(index + 1)
            let yAxis = maxY - minY
            let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * rect.height
            
            if index == 0 {
                path.move(to: CGPoint(x: xPosition, y: yPosition))
            }
            
            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
        }
        
        context.addPath(path.cgPath)
        context.setLineWidth(2)
        context.setStrokeColor(lineColor.cgColor)
        context.setShadow(offset: .init(width: 0.1, height: 0.1), blur: 0.7, color: lineColor.cgColor)
        context.strokePath()
       
    }
}
