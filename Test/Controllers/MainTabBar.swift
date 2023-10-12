//
//  MainTabBar.swift
//  Test
//
//  Created by Uyg'un Tursunov on 07/10/23.
//

import UIKit

class MainTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: MainVC())
        let vc2 = UINavigationController(rootViewController: SavedVC())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "bookmark")
        
        vc1.title = "Home"
        vc2.title = "Saved"
        
        tabBar.tintColor = .label
        setViewControllers([vc1, vc2], animated: true)
    }
}
