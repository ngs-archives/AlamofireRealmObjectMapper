//
//  GistCell.swift
//  AlamofireRealmObjectMapperExample
//
//  Created by Atsushi Nagase on 5/19/16.
//  Copyright © 2016 Atsushi Nagase. All rights reserved.
//

import UIKit

class GistCell: UITableViewCell {
    static let cellIdentifier = "GistCell"
    lazy var dateFormatter: NSDateFormatter = {
        let fmt = NSDateFormatter()
        fmt.dateStyle = .MediumStyle
        fmt.timeStyle = .MediumStyle
        return fmt
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    var gist: Gist? = nil {
        didSet {
            if let text = gist?.descriptionText where !text.isEmpty {
                textLabel?.text = text
            } else {
                textLabel?.text = "<Untitled>"
            }
            if let date = gist?.createdAt {
                detailTextLabel?.text = dateFormatter.stringFromDate(date)
            } else {
                detailTextLabel?.text = ""
            }
        }
    }
}
