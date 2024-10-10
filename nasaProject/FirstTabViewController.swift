//
//  FirstTabViewController.swift
//  nasaProject
//
//  Created by Jonathan Chen on 10/8/24.
//

import UIKit
import SDWebImage
import AVFoundation

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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            return view.frame.height/1.2 // fit about 1 cell on landscape
        case .portrait, .portraitUpsideDown:
            return view.frame.height/3.5 // fit about 3 cells on portrait
        default:
            return -1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetUp()
    }
    
    func tableViewSetUp() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
        
        // detects device orientation change. we call reload data to rerender to views
        tableView.reloadData()
    }


}

class NasaTableViewCell: UITableViewCell {
    
    var centerImageURL: URL? {
        didSet {
            centerImageView.sd_setImage(with: centerImageURL)
        }
    }
    
    var title: String? {
        didSet {
            idLabel.text = title
        }
    }
    
    private var idLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    let labelHeight = 30.0
    let horizontalMargins = 30.0
    
    @objc dynamic private var centerImageView = UIImageView()
    
    var kvoToken: NSKeyValueObservation?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(centerImageView)
        centerImageView.contentMode = .scaleAspectFit
        
        centerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: labelHeight).isActive = true
        centerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        centerImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: horizontalMargins).isActive = true
        centerImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -horizontalMargins).isActive = true
        centerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        kvoToken = centerImageView.observe(\.image, options: [.new], changeHandler:  { [weak self] (imageView, change) in
            
            guard let self = self else { return }
            guard let optionalImage = change.newValue,
                  let image = optionalImage else { return }
            
            let imageFrame = AVMakeRect(aspectRatio: image.size, insideRect: centerImageView.frame)
            idLabel.frame = CGRect(x: imageFrame.origin.x, y: imageFrame.origin.y - labelHeight, width: imageFrame.width, height: labelHeight)
            contentView.addSubview(idLabel)
            
        })
        
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // reframing label for orientation change
        if let image = centerImageView.image {
            let imageFrame = AVMakeRect(aspectRatio: image.size, insideRect: centerImageView.frame)
            idLabel.frame = CGRect(x: imageFrame.origin.x, y: imageFrame.origin.y - labelHeight, width: imageFrame.width, height: labelHeight)
        }
        
    }
    
    deinit {
        kvoToken?.invalidate()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


