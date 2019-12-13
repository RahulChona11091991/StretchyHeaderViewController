//
//  StretchyHeaderViewController.swift
//  StretchyHeaderViewController
//
//  Created by Frédéric Quenneville on 18-01-04.
//  Copyright © 2018 Frédéric Quenneville. All rights reserved.
//

//
//  StretchingHeaderScrollViewController.swift
//  myBook-iOS
//
//  Created by Frederic Quenneville on 17-11-03.
//  Copyright © 2017 Third Bridge. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class StretchyHeaderViewController: UIViewController {
    
    fileprivate var player: AVPlayer? {
        didSet { player?.play() }
    }
    fileprivate var playerObserver: Any?
        
    
    // MARK : - Attributes
    var headerTitle: String? {
        didSet {
            titleLabel.text = headerTitle
        }
    }
    
    var headerSubtitle: String? {
        didSet {
            subtitleLabel.text = headerSubtitle
        }
    }
    
    var image: UIImage? {
        didSet {
//            imageView.image = image
        }
    }
    
    var minHeaderHeight: CGFloat = 0 {
        didSet {
            updateHeaderView()
        }
    }

    var maxHeaderHeight: CGFloat = 300 {
        didSet {
            updateHeaderView()
        }
    }
    
    var tintColor: UIColor = .black {
        didSet {
            titleLabel.textColor = tintColor
            subtitleLabel.textColor = tintColor
        }
    }
    
    var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 32) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    var subtitleFont: UIFont = UIFont.systemFont(ofSize: 20) {
        didSet {
            subtitleLabel.font = subtitleFont
        }
    }
    
    var shadowColor: CGColor = UIColor.black.cgColor {
        didSet {
            titleLabel.layer.shadowColor = shadowColor
            subtitleLabel.layer.shadowColor = shadowColor
        }
    }
    
    var shadowOffset: CGSize = .zero {
        didSet {
            titleLabel.layer.shadowOffset = shadowOffset
            subtitleLabel.layer.shadowOffset = shadowOffset
        }
    }
    
    var shadowRadius: CGFloat = 0 {
        didSet {
            titleLabel.layer.shadowRadius = shadowRadius
            subtitleLabel.layer.shadowRadius = shadowRadius
        }
    }
    
    var shadowOpacity: Float = 0 {
        didSet {
            titleLabel.layer.shadowOpacity = shadowOpacity
            subtitleLabel.layer.shadowOpacity = shadowOpacity
        }
    }
    
    var scrollView: UIScrollView? {
        didSet {
            if oldValue == nil {
                scrollView?.translatesAutoresizingMaskIntoConstraints = false
                scrollView?.contentInsetAdjustmentBehavior = .never
                setupViews()
            }
        }
    }
    
    var progress : CGFloat {
        return (imageView.frame.height - minHeaderHeight)/(maxHeaderHeight - minHeaderHeight)
    }
    
    var headerCollapsingAnimationDuration: Double = 0
    var headerExpandingAnimationDuration: Double = 0
    
    // Defining margin in this file in order to reuser the class in multiple projects
    fileprivate let margin: CGFloat = 10
    
    // MARK : - UI Elements
    fileprivate lazy var imageView: VideoContainerView = {
        var image = VideoContainerView()
//        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = titleFont
        titleLabel.textColor = tintColor
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.layer.shadowColor = shadowColor
        titleLabel.layer.shadowOffset = shadowOffset
        titleLabel.layer.shadowRadius = shadowRadius
        titleLabel.layer.shadowOpacity = shadowOpacity
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    fileprivate lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = subtitleFont
        subtitleLabel.textColor = tintColor
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.layer.shadowColor = shadowColor
        subtitleLabel.layer.shadowOffset = shadowOffset
        subtitleLabel.layer.shadowRadius = shadowRadius
        subtitleLabel.layer.shadowOpacity = shadowOpacity
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return subtitleLabel
    }()
    
    // MARK :  - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        maxHeaderHeight = CGFloat(0.5 * self.view.frame.size.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        player?.play()
    }
    fileprivate func setupViews() {
        guard let scrollView = self.scrollView else {
            return
        }
        
        view.addSubview(imageView)
        imageView.frame.size = CGSize(width: view.frame.width, height: maxHeaderHeight)
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.bringSubview(toFront: imageView)
        
        scrollView.contentInset.top = imageView.frame.height
        scrollView.contentOffset.y = -imageView.frame.height
        
        view.addSubview(subtitleLabel)
        subtitleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -margin).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: margin).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -margin).isActive = true
        subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: margin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -margin).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -margin).isActive = true
                
        initializeVideoPlayerWithVideo()
        player?.play()

    }
    
    func expandHeader() {
        UIView.animate(withDuration: headerExpandingAnimationDuration) {
            self.scrollView?.contentOffset.y = -self.maxHeaderHeight
            self.imageView.frame.size.height = self.maxHeaderHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func collapseHeader() {
        UIView.animate(withDuration: headerCollapsingAnimationDuration) {
            self.scrollView?.contentOffset.y = -self.minHeaderHeight
            self.imageView.frame.size.height = self.minHeaderHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func updateHeaderView() {
        guard let scrollView = scrollView else {
            return
        }
        
        if scrollView.contentOffset.y < -maxHeaderHeight {
            imageView.frame.size.height = -scrollView.contentOffset.y
        } else if scrollView.contentOffset.y >= -maxHeaderHeight && scrollView.contentOffset.y < -minHeaderHeight {
            imageView.frame.size.height = -scrollView.contentOffset.y
        } else {
            imageView.frame.size.height = minHeaderHeight
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
        titleLabel.alpha = progress
        subtitleLabel.alpha = progress
        
        
//        player?.accessibilityFrame = CGRect(x: 0, y: 0, width: player?.currentItem?.presentationSize.width ?? 0.0, height: player?.currentItem?.presentationSize.height ?? 0.0)
    }
    
    func initializeVideoPlayerWithVideo() {

           let playerLayer = videoPlayerLayer()
            playerLayer.backgroundColor = UIColor.gray.cgColor
           playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
           playerLayer.frame = imageView.bounds
        playerLayer.needsDisplayOnBoundsChange = true
        playerLayer.masksToBounds = true
           imageView.layer.insertSublayer(playerLayer, at: 0)
        
            imageView.playerLayer = playerLayer;
       }
       
       func videoPlayerLayer() -> AVPlayerLayer {
           let fileURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        player = AVPlayer(url: fileURL!)
           let resetPlayer = {
            self.player?.seek(to: kCMTimeZero)
            self.player?.play()
           }
           playerObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: nil) { notification in
               resetPlayer()
           }
//           self.player = player
           return AVPlayerLayer(player: player)
       }
       
       deinit {
           guard let observer = playerObserver else { return }
           NotificationCenter.default.removeObserver(observer)
       }
}

class VideoContainerView: UIView {
  var playerLayer: CALayer?
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        CALayer.perform(withDuration: 0.0) {
            playerLayer?.frame = self.bounds
        }
    }
}

extension CALayer
{
    class func perform(withDuration duration: Double, actions: () -> Void) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        actions()
        CATransaction.commit()
    }
}
