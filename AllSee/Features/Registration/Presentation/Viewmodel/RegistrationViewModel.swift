//
//  RegistrationViewModel.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 12/07/2025.
//

import Foundation
import RxSwift
import RxCocoa

protocol RegistrationViewModelProtocol {
    var showAccessTokenErrorMessage: Driver<Bool> { get }
    var showRefreshTokenErrorMessage: Driver<Bool> { get }
    var errorDialogMessage: Driver<String?> { get }
}

final class RegistrationViewModel {
    private let repository: RegistrationRepository!
    private let disposeBag: DisposeBag!
    private var accessToken: String = ""
    private var refreshToken: String = ""
    
    private struct State {
        let accessToken = BehaviorRelay<String>(value: "")
        let refreshToken = BehaviorRelay<String>(value: "")
        let individual = BehaviorRelay<Individual?>(value: nil)
        let accessTokenErrorMessage = BehaviorRelay<Bool>(value: false)
        let refreshTokenErrorMessage = BehaviorRelay<Bool>(value: false)
        let errorDialogMessage = BehaviorRelay<String?>(value: nil)
        let showErrorDialog = BehaviorRelay<Bool>(value: false)
        let showUserConfirmationDialog = BehaviorRelay<Bool>(value: false)
    }
    
    private let state = State()
    
    init(
        repository: RegistrationRepository!
    ) {
        self.repository = repository
        self.disposeBag = DisposeBag()
    }
    
    func updateAccessToken(_ newToken: String) {
        state.accessToken.accept(newToken)
        
        if newToken.isEmpty {
            state.accessTokenErrorMessage.accept(true)
        } else {
            state.accessTokenErrorMessage.accept(false)
        }
    }
    
    func updateRefreshToken(_ newToken: String) {
        state.refreshToken.accept(newToken)
        
        if newToken.isEmpty {
            state.refreshTokenErrorMessage.accept(true)
        } else {
            state.refreshTokenErrorMessage.accept(false)
        }
    }
    
    func onNextButtonTap() {
        if !state.accessToken.value.isEmpty && !state.refreshToken.value.isEmpty {
            state.accessTokenErrorMessage.accept(false)
            state.refreshTokenErrorMessage.accept(false)
            saveTokens()
            getIndividualInformation()
        } else {
            state.accessTokenErrorMessage.accept(true)
            state.refreshTokenErrorMessage.accept(true)
        }
    }
    
    private func getIndividualInformation() {
        Task {
            try await repository.fetchIndividualInformation { [ weak self] result in
                switch result {
                case .success(let individual):
                    self?.state.individual.accept(individual)
                case .failure(let error):
                    if error is RepositoryErrors {
                        switch error {
                        case RepositoryErrors.cannotMapData:
                            self?.state.errorDialogMessage.accept(NSLocalizedString("errorMessage.invalidTokens", comment: ""))
                        default:
                            self?.state.errorDialogMessage.accept(NSLocalizedString("errorMessage.unknownError", comment: ""))
                        }
                    }
                }
            }
        }
    }
    
    private func saveTokens() {
        do {
            try repository.saveAccessAndRefreshTokens(
                accessToken: state.accessToken.value,
                refreshToken: state.refreshToken.value
            )
        } catch {
            state.accessTokenErrorMessage.accept(false)
            state.refreshTokenErrorMessage.accept(false)
            state.errorDialogMessage.accept(NSLocalizedString("errorMessage.tokensNotSaved", comment: ""))
        }
    }
}

extension RegistrationViewModel: RegistrationViewModelProtocol {
    var showAccessTokenErrorMessage: Driver<Bool> {
        state.accessTokenErrorMessage.asDriver()
    }
    
    var showRefreshTokenErrorMessage: Driver<Bool> {
        state.refreshTokenErrorMessage.asDriver()
    }
    
    var errorDialogMessage: Driver<String?> {
        state.errorDialogMessage.asDriver()
    }
}
