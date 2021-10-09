//
//  HomeViewController.swift
//  Spotify
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSetting))
        
        fetchData()
    }
    
    private func fetchData() {
        APICaller.shared.getRecommendedGenres { result in
            switch result {
                
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)

                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds) { _ in
                    
                }
                
            case .failure(_):
                break
            }
        }
    }
    
    @objc private func didTapSetting() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}

