//
//  TabBarViewController.swift
//  Spotify
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//
 
import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = HomeViewController()
        let vc2 = SearchViewController()
        let vc3 = LibraryViewController()
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        
        vc1.title = "Browse"
        vc2.title = "Search"
        vc3.title = "Library"
                
        let homeNavigationVC = UINavigationController(rootViewController: vc1)
        let searchNavigationVC = UINavigationController(rootViewController: vc2)
        let libraryNavigationVC = UINavigationController(rootViewController: vc3)
        
        homeNavigationVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        searchNavigationVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        libraryNavigationVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "music.note.list"), tag: 3)
        
        homeNavigationVC.navigationBar.prefersLargeTitles = true
        searchNavigationVC.navigationBar.prefersLargeTitles = true
        libraryNavigationVC.navigationBar.prefersLargeTitles = true
        
        viewControllers = [homeNavigationVC, searchNavigationVC, libraryNavigationVC]

    }
}

//MARK: Setup Canvas
import SwiftUI

struct TabBarViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            TabBarViewController()
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
