//
//  RegistrationViewController.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 12/07/2025.
//

import UIKit
import SnapKit

class RegistrationViewController : UIViewController {
    private let viewModel: RegistrationViewModel
    var coordinator: RegistrationCoordinator?
    
    private let mainContainer = UIStackView()
    
    private let labelWelcome = UILabel.headline(text: NSLocalizedString("registrationView.labelWelcome", comment: ""))
    private let labelTokenInstructions = UILabel.body(text: NSLocalizedString("registrationView.labelTokenInstructions", comment: ""))
    
    private let textfieldAccessToken = UITextField()
    private let textfieldRefreshToken = UITextField()
    
    private let buttonNext = UIButton(
        configuration: .primary(title: NSLocalizedString("label.next", comment: ""))
    )
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainContainer.axis = .vertical
        mainContainer.distribution = .equalSpacing
        mainContainer.alignment = .center
        mainContainer.spacing = 10
        mainContainer.isLayoutMarginsRelativeArrangement = true
        mainContainer.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        mainContainer.addBackground(color: UIColor.white.withAlphaComponent(0.15))
        
        labelTokenInstructions.textAlignment = .center
        
        textfieldAccessToken.placeholder = NSLocalizedString("registrationView.placeholderAccessToken", comment: "")
        textfieldAccessToken.addTarget(self, action: #selector(onAccessTokenChanged), for: .editingChanged)
        textfieldAccessToken.borderStyle = .roundedRect
        
        textfieldRefreshToken.placeholder = NSLocalizedString("registrationView.placeholderRefreshToken", comment: "")
        textfieldRefreshToken.addTarget(self, action: #selector(onRefreshTokenChanged), for: .editingChanged)
        textfieldRefreshToken.borderStyle = .roundedRect
        
        buttonNext.addTarget(self, action: #selector(onNextButtonTapped), for: .touchUpInside)
        
        mainContainer.addArrangedSubview(labelWelcome)
        mainContainer.addArrangedSubview(labelTokenInstructions)
        mainContainer.addArrangedSubview(textfieldAccessToken)
        mainContainer.addArrangedSubview(textfieldRefreshToken)
        mainContainer.addArrangedSubview(buttonNext)
        view.addSubview(mainContainer)
        
        mainContainer.setCustomSpacing(32, after: labelWelcome)
        
        labelTokenInstructions.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(500)
        }
        
        textfieldAccessToken.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(500)
        }
        
        textfieldRefreshToken.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(500)
        }
        
        mainContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc private func onNextButtonTapped() {
        print("Next tapped.")
    }
    
    @objc private func onAccessTokenChanged() {
        
    }
    
    @objc private func onRefreshTokenChanged() {
        
    }
}
