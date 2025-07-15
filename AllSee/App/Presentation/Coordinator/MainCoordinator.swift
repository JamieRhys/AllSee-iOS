//
//  MainCoordinator.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 12/07/2025.
//

import OSLog
import UIKit

final class MainCoordinator : Coordinator {
    var childCoordinators = [Coordinator]()
    var navController: UINavigationController
    
    private let log: Logger = Logger()
    
    private let networkClient: NetworkClient
    private let apiService: StarlingBankApiService
    
    init(navController: UINavigationController) {
        self.navController = navController
        
        self.networkClient = NetworkClient(log: log)
        self.apiService = StarlingBankApiServiceImpl(
            log: log,
            networkClient: networkClient
        )
    }
    
    func start() {
        showRegistrationView()
    }
    
    func showRegistrationView() {
        let child = RegistrationCoordinator(navController: navController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
