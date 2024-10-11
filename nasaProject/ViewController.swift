//
//  ViewController.swift
//  nasaProject
//
//  Created by Jonathan Chen on 10/8/24.
//

import UIKit
import Combine

//TODO check project for retain cycles
//TODO take care of magic numbers all over project

class PhotosObject: ObservableObject {
    
    @Published var photos = [Photo]()
    
    init() { getNewData() }
    
    func getNewData() {
        
        Task {
            let photoList = try await NasaApiService.shared.getPhotos()
            DispatchQueue.main.async {
                self.photos = photoList.photos
            }
        }
        
    }
    
}

class ViewController: UITabBarController {
    
    var photosObject = PhotosObject()
    var cancellableBag = Set<AnyCancellable>()
    
    let firstTabVC: FirstTabNavigationController = {
        var vc = FirstTabNavigationController()
        vc.tabBarItem = UITabBarItem(title: "UIKit", image: UIImage(systemName: "cross.case"), tag: 0)
        return vc
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosObject.$photos.sink { [unowned self] photos in
            firstTabVC.newPhotos(newPhotos: photos)
        }.store(in: &cancellableBag)
        
        let secondTabVC = SecondTabViewController(rootView: SwiftUIView(photosObject: self.photosObject) )
        secondTabVC.tabBarItem = UITabBarItem(title: "SwiftUI", image: UIImage(systemName: "swift"), tag: 0)
        
        
        self.viewControllers = [firstTabVC, secondTabVC]
        
    }


}

