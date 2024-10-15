//
//  FirstTabViewController.swift
//  nasaProject
//
//  Created by Jonathan Chen on 10/8/24.
//

import UIKit
import SDWebImage
import AVFoundation
import SwiftUI

class FirstTabNavigationController: UINavigationController {
    
    let mainVC = FirstTabViewController()
    
    init() {
        super.init(rootViewController: mainVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func newPhotos(newPhotos: [Photo]) {
        mainVC.newPhotos(newPhotos: newPhotos)
    }
    
    
}

class FirstTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var photos = [Photo]()
    var tableView = UITableView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        header.textLabel?.adjustsFontSizeToFitWidth = true
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.textAlignment = .center
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NasaTableViewCell
        cell.centerImageURL = URL(string: photos[indexPath.row].imageSource)
        cell.title = photos[indexPath.row].id.description
        cell.tableView = self.tableView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! NasaTableViewCell
        cell.tapped()
        
        let secondTabVC = UIHostingController<PhotoDetailView>(rootView: PhotoDetailView(photo: self.photos[indexPath.row]) )
        
        navigationController?.pushViewController(secondTabVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    var heightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetUp()
    }
    
    func tableViewSetUp() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44 // This number can be anything. It just needs to be set
        
        view.addSubview(tableView)
        tableView.register(NasaTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func newPhotos(newPhotos: [Photo]) {
        photos = newPhotos
        tableView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { _ in
            // TODO there has to be a better solution...
            // This is for orientation change
            // The cell will still sometimes look funky
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {_ in
                self.tableView.reloadData()
            })
            // I've tried many other things... still looking for solution
        }
        
    }


}

class NasaTableViewCell: UITableViewCell {
    
    func tapped() {
        // leaving this here for testing. If a cell looks bad, tapping it will fix it
        tableView?.reloadData()
        // only time cell might look bad is after orientation change
    }
    
    var swiftUIMargin: CGFloat = 16.0
    
    var centerImageURL: URL? {
        didSet {
            
            centerImageView.sd_setImage(with: centerImageURL, completed: {[unowned self] img, err, cacheType, url in
                
                if let const = heightConstraint {
                    centerImageView.removeConstraint(const)
                    heightConstraint = nil
                }
                
                if let img = img {
                    
                    heightConstraint = NSLayoutConstraint(item: centerImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: img.size.height*((contentView.frame.width - swiftUIMargin*2) / img.size.width))
                    
                    centerImageView.addConstraint(heightConstraint)
                    
                    if cacheType.rawValue == 1 || cacheType.rawValue == 0 {
                        tableView?.reloadData()
                    }
                    
                }
                
            })
        }
    }
    
    var title: String? {
        didSet {
            idLabel.text = title
        }
    }
    
    var tableView: UITableView?
    
    private var idLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private var centerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.sd_imageIndicator = SDWebImageActivityIndicator.gray
        return view
    }()
    
    var heightConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 8
        contentView.layer.cornerRadius = 25
        contentView.addSubview(idLabel)
        contentView.addSubview(centerImageView)
        
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: swiftUIMargin).isActive = true
        idLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: swiftUIMargin).isActive = true
        idLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -swiftUIMargin).isActive = true
        
        centerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let botAnch = centerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -swiftUIMargin*3)
        
        centerImageView.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8).isActive = true
        botAnch.priority = .defaultHigh // Bottom constraint needs this when dealing with UITableViewCell dynamic sizing
        botAnch.isActive = true
        
        centerImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        centerImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: swiftUIMargin, left: swiftUIMargin, bottom: swiftUIMargin, right: swiftUIMargin)  )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        centerImageView.sd_cancelCurrentImageLoad()
        centerImageView.sd_setImage(with: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


