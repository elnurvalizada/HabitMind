//
//  ViewController+Ext.swift
//  HabitMind
//
//  Created by Elnur Valizada on 07.08.25.
//

import UIKit

class RootViewController : UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Loaded: \(String(describing: self))")
    }
    
    // MARK: - Modal Presentation Helper
    func presentWithNavigation(_ viewController: UIViewController, style: UIModalPresentationStyle = .formSheet, animated: Bool = true, completion: (() -> Void)? = nil) {
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = style
        navController.presentationController?.delegate = self
        present(navController, animated: animated, completion: completion)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension RootViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Override in subclasses if needed
    }
}
