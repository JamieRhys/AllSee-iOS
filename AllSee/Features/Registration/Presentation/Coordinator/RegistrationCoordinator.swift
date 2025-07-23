//
//  RegistrationCoordinator.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 12/07/2025.
//

import UIKit

final class RegistrationCoordinator : Coordinator {
    var childCoordinators = [Coordinator]()
    var navController: UINavigationController
    var repository: RegistrationRepository!
    weak var parentCoordinator: Coordinator?
    
    private var vc: RegistrationViewController
    
    init(
        navController: UINavigationController,
        apiService: StarlingBankApiService,
        individualMapper: IndividualMapper,
        upsertKeyChainTokenUseCase: UpsertKeyChainTokenUseCase
    ) {
        self.navController = navController
        
        self.repository = RegistrationRepositoryImpl(
            apiService: apiService,
            individualMapper: individualMapper,
            upsertKeyChainTokenUseCase: upsertKeyChainTokenUseCase
        )
        
        self.vc = RegistrationViewController(
            viewModel: RegistrationViewModel(
                repository: repository
            )
        )
    }
    
    func start() {
        vc.coordinator = self
        navController.setViewControllers([vc], animated: true)
    }
    
    func showErrorDialog(errorMessage: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("errorDialog.title", comment: ""),
            message: errorMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("label.ok", comment: ""), style: .cancel) { _ in })
        vc.present(alert, animated: true)
    }
    
    func showUserConfirmationDialog(firstName: String?, lastName: String?) {
        let alert = UIAlertController(
            title: NSLocalizedString("userConfirmationDialog.title", comment: ""),
            message: String(format: NSLocalizedString("userConfirmationDialog.label", comment: ""), firstName ?? "Unknown", lastName ?? "Person"),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("label.yes", comment: ""), style: .default) { _ in
            // TODO: Show next screen
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("label.no", comment: ""), style: .cancel))
        vc.present(alert, animated: true)
    }
}
