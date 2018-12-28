//
//  ViewController.swift
//  FlickerImageViewer
//
//  Created by Doyeong Yeom on 24/12/2018.
//  Copyright © 2018 Doyeong Yeom. All rights reserved.
//

import Kingfisher
import SWXMLHash
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var settingView: UIView!
    
    var imageItems: [String] = []
    var showIndex = 0 {
        didSet {
            if showIndex == imageItems.count - 1 {
//                getPublicFeedPhotos() // 마지막 이미지일 때는 새로운 이미지들을 불러온다.
            }
        }
    }
    var interval = 5.0
    var isLoadingFeeds = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slider.minimumValue = 1
        self.slider.maximumValue = 10
        self.slider.value = 5
        self.imageView.isHidden = true
    }
    
    @IBAction func intervalChanged(_ sender: Any) {
        self.interval = Double(self.slider.value)
        intervalLabel.text = String(format: "사진 보여지는 시간 : %.2f\n(다음 이미지 불러오는 시간이 오래걸리면\n더 오랫동안 사진이 보일 수 있습니다)", Double(round(100 * self.interval) / 100))
    }
    
    @IBAction func selectStartButton(_ sender: Any) {
        self.imageView.isHidden = false
        self.getPublicFeedPhotos()
    }
    
    func getPublicFeedPhotos() {
        APIService.getPublicFeedPhotos().responseData { [weak self] response in
            if let result = response.result.value {
                let xml = SWXMLHash.parse(result)
                let feedArray = xml["feed"]["entry"].all
                if feedArray.count > 0 {
                    for entry in feedArray {
                        if let imagePath = entry["link"][1].element?.attribute(by: "href")?.text {
                            self?.imageItems.append(imagePath)
                        }
                    }
                    
                    self?.showImageSlide()
                    self?.settingView.isHidden = true
                } else {
                    if self?.imageItems.count == 0 {
                        let alertController = UIAlertController(title: "FlickerImageViewer", message: "불러올 사진이 없습니다", preferredStyle: .alert)
                        self?.present(alertController, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
    }
    
    func showImageSlide() {
        self.imageView.kf.setImage(with: URL(string: self.imageItems[self.showIndex]), options: [.transition(.fade(1)), .keepCurrentImageWhileLoading], completionHandler: { [weak self] result in
            let _ = Timer.scheduledTimer(withTimeInterval: self?.interval ?? 5.0, repeats: false, block: { [weak self] _ in
                if let showIndex = self?.showIndex, let imageItems = self?.imageItems {
                    self?.showIndex = showIndex + 1
                    if showIndex + 1 < imageItems.count {
                        self?.showImageSlide()
                    } else {
                        self?.getPublicFeedPhotos()
                    }
                }
            })
        })
    }
}

