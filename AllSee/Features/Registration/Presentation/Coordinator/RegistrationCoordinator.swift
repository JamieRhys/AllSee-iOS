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
    weak var parentCoordinator: Coordinator?
    
    private var vc: RegistrationViewController
    
    init(navController: UINavigationController) {
        self.navController = navController
        
        self.vc = RegistrationViewController(
            viewModel: RegistrationViewModel()
        )
    }
    
    func start() {
        vc.coordinator = self
        navController.setViewControllers([vc], animated: true)
    }
}
