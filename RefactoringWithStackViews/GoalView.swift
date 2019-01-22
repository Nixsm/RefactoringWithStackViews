//
//  GoalView.swift
//  RefactoringWithStackViews
//
//  Created by Nicholas Meschke on 22.01.19.
//  Copyright © 2019 Nicholas Meschke. All rights reserved.
//

import UIKit

final class GoalView: UIView {
    
    // MARK: Properties
    
    private let emptyGoalView = UIView()
    private let goalView = UIView()
    private let successView = UIView()

    private lazy var goalTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        return label
    }()

    private lazy var progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.textColor = .black
        
        return progressLabel
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        return label
    }()
    
    private lazy var goalSetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.text = "Goal set!"
        
        return label
    }()

    private var goal: Int = 0

    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        [goalSetLabel, titleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        addSubview(titleLabel)
        addSubview(goalSetLabel)
        
        titleLabel.text = "Clicking goal"
        
        NSLayoutConstraint
            .activate([titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                       titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)])
        
        NSLayoutConstraint
            .activate([goalSetLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                       goalSetLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
                       goalSetLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)])

        setupEmptyGoal()
        setupGoalView()
        setupSuccessView()
        
        showGoal(false)
        showSuccessView(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    
    func showSuccessView(_ show: Bool) {
        successView.isHidden = !show
    }
    
    func showEmptyGoal(_ show: Bool) {
        emptyGoalView.isHidden = !show
    }
    
    func showGoal(_ show: Bool) {
        goalView.isHidden = !show
        goalSetLabel.isHidden = !show
    }
    
    func setProgress(_ progress: Int) {
        setProgress(progress, goal: goal)
        
        if goal != 0 && progress == goal {
            showGoal(false)
            showEmptyGoal(false)
            showSuccessView(true)
            
            goal = 0
        }
    }
    
    func setGoal(_ goal: GoalSize) {
        self.goal = goal.rawValue
        setProgress(0, goal: goal.rawValue)
        showGoal(true)
        showEmptyGoal(false)
    }

    // MARK: Private methods
    
    private func setupSuccessView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nice-meme")
        imageView.contentMode = .scaleAspectFill
        
        [successView, imageView].forEach { $0?.translatesAutoresizingMaskIntoConstraints = false }
        
        successView.addSubview(imageView)

        NSLayoutConstraint
            .activate([imageView.topAnchor.constraint(equalTo: successView.topAnchor),
                       imageView.bottomAnchor.constraint(equalTo: successView.bottomAnchor),
                       imageView.trailingAnchor.constraint(equalTo: successView.trailingAnchor),
                       imageView.leadingAnchor.constraint(equalTo: successView.leadingAnchor)])
        
        addSubview(successView)
        
        NSLayoutConstraint
            .activate([successView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
                       successView.topAnchor.constraint(equalTo: goalSetLabel.bottomAnchor, constant: 16),
                       successView.bottomAnchor.constraint(equalTo: bottomAnchor),
                       successView.trailingAnchor.constraint(equalTo: trailingAnchor),
                       successView.leadingAnchor.constraint(equalTo: leadingAnchor)])
    }
    
    private func setupGoalView() {
        setProgress(0)

        [goalView, goalTitleLabel, progressLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        goalView.addSubview(goalTitleLabel)
        goalView.addSubview(progressLabel)
        
        NSLayoutConstraint
            .activate([goalTitleLabel.topAnchor.constraint(equalTo: goalView.topAnchor, constant: 16),
                       goalTitleLabel.centerXAnchor.constraint(equalTo: goalView.centerXAnchor)])
        
        NSLayoutConstraint
            .activate([progressLabel.topAnchor.constraint(equalTo: goalTitleLabel.bottomAnchor, constant: 16),
                       progressLabel.centerXAnchor.constraint(equalTo: goalView.centerXAnchor),
                       progressLabel.bottomAnchor.constraint(equalTo: goalView.bottomAnchor, constant: -16)])
        
        addSubview(goalView)
        
        NSLayoutConstraint
            .activate([goalView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
                       goalView.topAnchor.constraint(equalTo: goalSetLabel.bottomAnchor, constant: 16),
                       goalView.bottomAnchor.constraint(equalTo: bottomAnchor),
                       goalView.trailingAnchor.constraint(equalTo: trailingAnchor),
                       goalView.leadingAnchor.constraint(equalTo: leadingAnchor)])
    }
    
    private func setupEmptyGoal() {
        let emptyGoalTitleLabel = UILabel()
        emptyGoalTitleLabel.text = "You have no goal, you can set a goal below! Setting a goal can help you click more and turn you into a professional clicker!"
        emptyGoalTitleLabel.numberOfLines = 0
        emptyGoalTitleLabel.textColor = .black
        
        let smallGoalButton = createGoalButton(with: .small, target: self, action: #selector(onSmallGoalTapped))
        let mediumGoalButton = createGoalButton(with: .medium, target: self, action: #selector(onMediumGoalTapped))
        let bigGoalButton = createGoalButton(with: .big, target: self, action: #selector(onBigGoalTapped))
        
        let optionsStackView = UIStackView(arrangedSubviews: [smallGoalButton, mediumGoalButton, bigGoalButton])
        optionsStackView.axis = .horizontal
        optionsStackView.spacing = 16
        optionsStackView.distribution = .equalSpacing

        [emptyGoalView, emptyGoalTitleLabel, optionsStackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        emptyGoalView.addSubview(emptyGoalTitleLabel)
        emptyGoalView.addSubview(optionsStackView)

        NSLayoutConstraint
            .activate([emptyGoalTitleLabel.topAnchor.constraint(equalTo: emptyGoalView.topAnchor, constant: 16),
                       emptyGoalTitleLabel.trailingAnchor.constraint(equalTo: emptyGoalView.trailingAnchor, constant: -16),
                       emptyGoalTitleLabel.leadingAnchor.constraint(equalTo: emptyGoalView.leadingAnchor, constant: 16)])

        NSLayoutConstraint
            .activate([optionsStackView.topAnchor.constraint(equalTo: emptyGoalTitleLabel.bottomAnchor, constant: 32),
                       optionsStackView.trailingAnchor.constraint(equalTo: emptyGoalView.trailingAnchor, constant: -16),
                       optionsStackView.leadingAnchor.constraint(equalTo: emptyGoalView.leadingAnchor, constant: 16),
                       optionsStackView.bottomAnchor.constraint(equalTo: emptyGoalView.bottomAnchor, constant: -16)])
        
        addSubview(emptyGoalView)
    
        NSLayoutConstraint
            .activate([emptyGoalView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
                       emptyGoalView.bottomAnchor.constraint(equalTo: bottomAnchor),
                       emptyGoalView.trailingAnchor.constraint(equalTo: trailingAnchor),
                       emptyGoalView.leadingAnchor.constraint(equalTo: leadingAnchor)])
    }
    
    private func createGoalButton(with size: GoalSize, target: Any?, action: Selector) -> UIButton {
        let goalButton = UIButton()
        
        goalButton.setTitle(size.text, for: [])
        goalButton.setTitleColor(.black, for: [])
        goalButton.addTarget(self, action: action, for: .touchUpInside)
        
        return goalButton
    }
    
    private func setProgress(_ progress: Int, goal: Int) {
        goalTitleLabel.text = "Your Goal is \(goal)"
        progressLabel.text = "Your current progress is \(progress)/\(goal)"
    }
    
    // MARK: Obj-c methods
    
    @objc func onSmallGoalTapped() {
        setGoal(.small)
    }
    
    @objc func onMediumGoalTapped() {
        setGoal(.medium)
    }
    
    @objc func onBigGoalTapped() {
        setGoal(.big)
    }
}

enum GoalSize: Int {
    case small = 15, medium = 45, big = 100
    
    var text: String {
        return String(self.rawValue)
    }
}
