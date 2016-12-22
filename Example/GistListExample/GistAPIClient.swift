//
//  GistAPIClient.swift
//  AlamofireRealmObjectMapperExample
//
//  Created by Atsushi Nagase on 5/19/16.
//  Copyright © 2016 Atsushi Nagase. All rights reserved.
//

import Alamofire
import AlamofireRealmObjectMapper
import RealmSwift
import UIKit

class GistAPIClient {
    let perPage = 20
    var isLoading = false
    var currentPage = 1

    func load(_ more: Bool = false, completionHandler: @escaping () -> ()) {
        if isLoading { return }
        if more {
            currentPage += 1
        } else {
            currentPage = 1
        }
        let url = URL(string: "https://api.github.com/gists/public?page=\(currentPage)&per_page=\(perPage)")!
        let req = Alamofire.request(url)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        req.responseRealmArray { (response: DataResponse<[Gist]>) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completionHandler()
        }
    }
}
