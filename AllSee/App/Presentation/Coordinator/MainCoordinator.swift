//
//  MainCoordinator.swift
//  AllSee
//
//  Created by Jamie-Rhys Edwards on 12/07/2025.
//

import RealmSwift
import OSLog
import UIKit

final class MainCoordinator : Coordinator {
    var childCoordinators = [Coordinator]()
    var navController: UINavigationController
    
    private let log: os.Logger!
    private let realmDb: Realm!
    
    private let apiService: StarlingBankApiService
    private let keyChain: KeyChainStorable
    private let networkClient: NetworkClient
    
    init(navController: UINavigationController) {
        self.navController = navController
        self.realmDb = try! Realm()
        self.log = os.Logger()
        
        self.keyChain = KeyChain()
        self.networkClient = NetworkClientImpl(log: log)
        self.apiService = StarlingBankApiServiceImpl(
            keyChain: keyChain,
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
