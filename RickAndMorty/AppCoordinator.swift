//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by Slehyder Martinez on 24/01/25.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showFilterViewController(from viewController: UIViewController, filters: CharacterFilters, sender: UIView, onApplyFilter: @escaping (CharacterFilters?) -> Void) {
        let filterVC = FilterViewController(nibName: "FilterViewController", bundle: nil)
        filterVC.onApplyFilter = { itemsFiltered in
            onApplyFilter(itemsFiltered)
        }
        filterVC.selectedFilters = filters
        
        let nv = UINavigationController(rootViewController: filterVC)
        nv.isNavigationBarHidden = true
        presentPopover(viewController, nv, sender: sender, size: CGSize(width: 300, height: 216), arrowDirection: .up)
    }
    
    func showCharacterDetail(id: Int) {
        let vc = DetailCharacterViewController()
        vc.coordinator = self
        vc.idCharacter = id
        navigationController.pushViewController(vc, animated: true)
    }
}
