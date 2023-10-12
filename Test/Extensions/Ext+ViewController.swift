//
//  Ext+ViewController.swift
//  Test
//
//  Created by Uyg'un Tursunov on 08/10/23.
//

import UIKit

fileprivate var containerView: LoadingView!

extension UIViewController {
    func showLoadingView() {
        containerView = LoadingView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.size.equalTo(view)
        }
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            if let container = containerView {
                container.removeFromSuperview()
            }
            containerView = nil
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = EmptyView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func removeEmptyStateView(view: UIView) {
        view.removeFromSuperview()
    }
    
    func presentAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

