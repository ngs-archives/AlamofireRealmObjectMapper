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
        let URL = NSURL(string: "https://api.github.com/gists/public?page=\(currentPage)&per_page=\(perPage)")!
        let req = Alamofire.request(.GET, URL)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        req.responseRealmArray { (response: Response<[RealmObjectMapperResult<Gist>], NSError>) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            completionHandler()
        }
    }
}
