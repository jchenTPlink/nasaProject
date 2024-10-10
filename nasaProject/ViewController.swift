//
//  ViewController.swift
//  nasaProject
//
//  Created by Jonathan Chen on 10/8/24.
//

import UIKit
import Combine

//TODO check project for retain cycles
//TODO cancel loading image if cell goes off screen
//TODO take care of magic numbers all over project

class PhotosObject: ObservableObject {
    
    @Published var photos = [Photo]()
    
    init() { getNewData() }
    
    func getNewData() {
        
        //TODO: store this API key someewhere else
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=2&api_key=AyHYvkgDh4gCmDpuFPUj5kmc2nLHsJS5ikGGHKHe") else {
            return // handle error
        }
        
        let task = URLSession.shared.dataTask(with: url) {[unowned self] (data, response, error) in
            
            guard error == nil else {
                return //handle error
            }
            guard let data = data else {
                return //handle error
            }
            
            do {
                
                let photoList = try JSONDecoder().decode(PhotoList.self, from: data)
                
                DispatchQueue.main.async {
                    self.photos = photoList.photos
                }
                
            } catch {
                return //handleerror
            }
            
        }
        
        task.resume()
        
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

