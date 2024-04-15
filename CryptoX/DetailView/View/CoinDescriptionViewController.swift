//
//  CoinDescriptionViewController.swift
//  CryptoX
//
//  Created by uttam ahir on 14/04/24.
//

import UIKit
import SafariServices


class CoinDescriptionViewController: UIViewController {

    var model: CoinDetailDescriptionModel? = nil
    
    private var linkVStack = UIStackView()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var redditSiteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reddit", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapRedditSiteButton), for: .touchUpInside)
        return button
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var webSiteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Website", for: .normal)
        button.setImage(UIImage(systemName: "globe"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTapWebsiteButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupValues()
        setupView()
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapWebsiteButton() {
        guard let model = model,
              let websiteURL = model.websiteURL,
              let url = URL(string: websiteURL)
        else { return }
        presentSafariViewController(with: url)
    }
    
    @objc private func didTapRedditSiteButton() {
        guard let model = model,
              let redditURL = model.redditURL,
              let url = URL(string: redditURL)
        else { return }
        presentSafariViewController(with: url)
    }

    
    private func presentSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    private func setupValues() {
        descriptionLabel.text = model?.coinDescription ?? ""
        redditSiteButton.isHidden = model?.redditURL == nil
        webSiteButton.isHidden = model?.websiteURL == nil
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        let guide = view.safeAreaLayoutGuide
        setupCloseButton()
        setupScrollView()
        setupDescriptionView()
        setupLinkVStack()
    }
    
    private func setupCloseButton() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 12),
            closeButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupLinkVStack() {
        let guide = view.safeAreaLayoutGuide
        let linkVStack = UIStackView(arrangedSubviews: [webSiteButton, redditSiteButton])
        linkVStack.translatesAutoresizingMaskIntoConstraints = false
        linkVStack.axis = .horizontal
        linkVStack.spacing = 4
        linkVStack.distribution = .fillEqually
        
        view.addSubview(linkVStack)
        NSLayoutConstraint.activate([
            linkVStack.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 12),
            linkVStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            linkVStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            linkVStack.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 12)
        ])
        self.linkVStack = linkVStack
    }
    
    private func setupScrollView() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
    }
    
    private func setupDescriptionView() {
        scrollView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            descriptionLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 40)
        ])
    }
}
