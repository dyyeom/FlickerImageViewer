//
//  ApiService.swift
//  FlickerImageViewer
//
//  Created by Doyeong Yeom on 24/12/2018.
//  Copyright © 2018 Doyeong Yeom. All rights reserved.
//

import Alamofire

class APIService {
    static var API_HOST = "https://api.flickr.com"
    
    class func getPublicFeedPhotos() -> Alamofire.DataRequest {
        return Alamofire.request(APIService.API_HOST + "/services/feeds/photos_public.gne", method: .get)
    }
}
