//
//  RegistrationViewController.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 12/07/2025.
//

import UIKit
import SnapKit
import RxSwift

class RegistrationViewController : UIViewController {
    private let viewModel: RegistrationViewModel
    var coordinator: RegistrationCoordinator?
    private let disposeBag = DisposeBag()
    
    private let mainContainer = UIStackView()
    
    private let errorLabelAccessToken = UILabel.caption(text: NSLocalizedString("errorMessage.emptyAccessToken", comment: ""))
    private let errorLabelRefreshToken = UILabel.caption(text: NSLocalizedString("errorMessage.emptyRefreshToken", comment: ""))
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
        configureBindings()
        
        mainContainer.axis = .vertical
        mainContainer.distribution = .equalSpacing
        mainContainer.alignment = .center
        mainContainer.spacing = 10
        mainContainer.isLayoutMarginsRelativeArrangement = true
        mainContainer.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        mainContainer.addBackground(color: UIColor.white.withAlphaComponent(0.15))
        
        labelTokenInstructions.textAlignment = .center
        
        errorLabelAccessToken.textColor = AppColor.error
        errorLabelAccessToken.isHidden = true
        
        errorLabelRefreshToken.textColor = AppColor.error
        errorLabelRefreshToken.isHidden = true
        
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
        mainContainer.addArrangedSubview(errorLabelAccessToken)
        mainContainer.addArrangedSubview(textfieldRefreshToken)
        mainContainer.addArrangedSubview(errorLabelRefreshToken)
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
    
    private func showErrorDialog() {
        
        //coordinator?.showErrorDialog(errorMessage: viewModel.errorMessage)
    }
    
    private func showUserConfirmationDialog() {
        /*
        coordinator?.showUserConfirmationDialog(
            firstName: viewModel.individual?.firstName,
            lastName: viewModel.individual?.lastName
        )
         */
    }
    
    @objc private func onNextButtonTapped() { viewModel.onNextButtonTap() }
    
    @objc private func onAccessTokenChanged() { viewModel.updateAccessToken(textfieldAccessToken.text ?? "") }
    
    @objc private func onRefreshTokenChanged() { viewModel.updateRefreshToken(textfieldRefreshToken.text ?? "") }
    
    private func configureBindings() {
        viewModel
            .showAccessTokenErrorMessage
            .drive(onNext: { [weak self] error in
                self?.errorLabelAccessToken.isHidden = !error
            })
            .disposed(by: disposeBag)
        
        viewModel
            .showRefreshTokenErrorMessage
            .drive(onNext: { [weak self] error in
                self?.errorLabelRefreshToken.isHidden = !error
            })
            .disposed(by: disposeBag)
        
        // TODO: configure bindings to errorDialogMessage.
        // TODO: configure bindings to individual. (This also needs to be exposed to the view controller.
    }
}
