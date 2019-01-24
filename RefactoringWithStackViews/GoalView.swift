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

    private var stackView = UIStackView()
    
    var state: GoalViewState = .empty {
        didSet {
            updateState(with: state)
        }
    }

    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        [goalSetLabel, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

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
        setupStackView()
        
        defer { state = .empty }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods

    func setProgress(_ progress: Int) {
        setProgress(progress, goal: goal)
        
        if goal != 0 && progress == goal {
            state = .success
            
            goal = 0
        }
    }
    
    func setGoal(_ goal: GoalSize) {
        self.goal = goal.rawValue
        setProgress(0, goal: goal.rawValue)
    }

    // MARK: Private methods
    
    private func updateState(with state: GoalViewState) {
        stackView.arrangedSubviews.forEach { $0.isHidden = true }
        goalSetLabel.isHidden = true
        
        switch state {
        case .empty:
            emptyGoalView.isHidden = false
        case .goal(let value):
            goalView.isHidden = false
            goalSetLabel.isHidden = false
            setGoal(value)
        case .success:
            successView.isHidden = false
        }
    }
    
    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        [emptyGoalView, goalView, successView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }

        addSubview(stackView)
        
        NSLayoutConstraint
            .activate([stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
                       stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                       stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                       stackView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }

    private func setupSuccessView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nice-meme")
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        successView.addSubview(imageView)

        NSLayoutConstraint
            .activate([imageView.topAnchor.constraint(equalTo: successView.topAnchor),
                       imageView.bottomAnchor.constraint(equalTo: successView.bottomAnchor),
                       imageView.trailingAnchor.constraint(equalTo: successView.trailingAnchor),
                       imageView.leadingAnchor.constraint(equalTo: successView.leadingAnchor)])
    }
    
    private func setupGoalView() {
        setProgress(0)

        [goalTitleLabel, progressLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            goalView.addSubview($0)
        }
        
        NSLayoutConstraint
            .activate([goalTitleLabel.topAnchor.constraint(equalTo: goalView.topAnchor, constant: 16),
                       goalTitleLabel.centerXAnchor.constraint(equalTo: goalView.centerXAnchor)])
        
        NSLayoutConstraint
            .activate([progressLabel.topAnchor.constraint(equalTo: goalTitleLabel.bottomAnchor, constant: 16),
                       progressLabel.centerXAnchor.constraint(equalTo: goalView.centerXAnchor),
                       progressLabel.bottomAnchor.constraint(equalTo: goalView.bottomAnchor, constant: -16)])
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

        [emptyGoalTitleLabel, optionsStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            emptyGoalView.addSubview($0)
        }

        NSLayoutConstraint
            .activate([emptyGoalTitleLabel.topAnchor.constraint(equalTo: emptyGoalView.topAnchor, constant: 16),
                       emptyGoalTitleLabel.trailingAnchor.constraint(equalTo: emptyGoalView.trailingAnchor, constant: -16),
                       emptyGoalTitleLabel.leadingAnchor.constraint(equalTo: emptyGoalView.leadingAnchor, constant: 16)])

        NSLayoutConstraint
            .activate([optionsStackView.topAnchor.constraint(equalTo: emptyGoalTitleLabel.bottomAnchor, constant: 32),
                       optionsStackView.trailingAnchor.constraint(equalTo: emptyGoalView.trailingAnchor, constant: -16),
                       optionsStackView.leadingAnchor.constraint(equalTo: emptyGoalView.leadingAnchor, constant: 16),
                       optionsStackView.bottomAnchor.constraint(equalTo: emptyGoalView.bottomAnchor, constant: -16)])
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
        state = .goal(value: .small)
    }
    
    @objc func onMediumGoalTapped() {
        state = .goal(value: .medium)
    }
    
    @objc func onBigGoalTapped() {
        state = .goal(value: .big)
    }
}

enum GoalSize: Int {
    case small = 15, medium = 45, big = 100
    
    var text: String {
        return String(self.rawValue)
    }
}

enum GoalViewState {
    case empty, goal(value: GoalSize), success
}
