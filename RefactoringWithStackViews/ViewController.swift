//
//  ViewController.swift
//  RefactoringWithStackViews
//
//  Created by Nicholas Meschke on 22.01.19.
//  Copyright © 2019 Nicholas Meschke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    private var clickCount = 0 {
        didSet {
            setClickCount(clickCount)
            goalView.setProgress(clickCount)
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        return label
    }()
    
    private lazy var clickButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onClickTapped), for: .touchUpInside)
        button.setTitle("Tap me", for: [])
        button.setTitleColor(.black, for: [])
        
        return button
    }()
    
    private let clickView = UIView()
    private let goalView = GoalView()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.layoutSubviews()
    }

    // MARK: Views methods
    
    private func setupView() {
        setupClickView()
        setupGoalView()
    }
    
    private func setupGoalView() {
        view.addSubview(goalView)
        
        goalView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint
            .activate([goalView.topAnchor.constraint(equalTo: clickView.bottomAnchor),
                       goalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                       goalView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
    }

    private func setupClickView() {
        clickCount = 0

        [clickView, clickButton, titleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        clickView.addSubview(titleLabel)
        clickView.addSubview(clickButton)
        
        NSLayoutConstraint
            .activate([titleLabel.centerXAnchor.constraint(equalTo: clickView.centerXAnchor),
                       titleLabel.topAnchor.constraint(equalTo: clickView.topAnchor, constant: 32)])

        NSLayoutConstraint
            .activate([clickButton.centerXAnchor.constraint(equalTo: clickView.centerXAnchor),
                       clickButton.bottomAnchor.constraint(equalTo: clickView.bottomAnchor, constant: -16),
                       clickButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)])
        
        self.view.addSubview(clickView)
        
        NSLayoutConstraint
            .activate([clickView.topAnchor.constraint(equalTo: view.topAnchor, constant: 48),
                       clickView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                       clickView.leadingAnchor.constraint(equalTo: view.leadingAnchor)])
        
        clickView.layer.borderColor = UIColor.black.cgColor
        clickView.layer.borderWidth = 2
    }
    
    private func setClickCount(_ clickCount: Int) {
        titleLabel.text = "Total count: \(clickCount)"
    }
    
    // MARK: Objective-c methods
    
    @objc func onClickTapped() {
        clickCount += 1
    }
}

