//
//  Gist.swift
//  AlamofireRealmObjectMapperExample
//
//  Created by Atsushi Nagase on 5/19/16.
//  Copyright © 2016 Atsushi Nagase. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper

class Gist: Object, Mappable {
    dynamic var htmlUrl: String = ""
    dynamic var id: String = ""
    dynamic var descriptionText: String = ""
    dynamic var isPublic: Bool = false
    dynamic var updatedAt: Date?
    dynamic var createdAt: Date?
    dynamic var dateHour: String = ""

    // MARK: - Initialization

    required init?(map: Map) {
        super.init()
        self.mapping(map: map)
    }

    required init() {
        super.init()
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    // MARK: - Mappable

    override static func primaryKey() -> String? {
        return "id"
    }

    func mapping(map: Map) {
        htmlUrl <- map["html_url"]
        id <- map["id"]
        descriptionText <- map["description"]
        isPublic <- map["public"]
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
        createdAt <- (map["created_at"], ISO8601DateTransform())
        dateHour <- (map["created_at"], DateHourTransform())
    }
}

class DateHourTransform: TransformType {
    typealias Object = String
    typealias JSON = String
    let fromDateFormatter = DateFormatter()
    let toDateFormatter = DateFormatter()

    init() {
        fromDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        fromDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        toDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        toDateFormatter.dateFormat = "yyyy/MM/dd HH:00"
    }

    func transformFromJSON(_ value: Any?) -> Object? {
        if let value = value as? String
            , let date = fromDateFormatter.date(from: value) {
            return toDateFormatter.string(from: date)
        }
        return nil
    }

    func transformToJSON(_ value: Object?) -> JSON? {
        return ""
    }
}
