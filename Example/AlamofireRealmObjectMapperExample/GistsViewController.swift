//
//  GistsViewController.swift
//  AlamofireRealmObjectMapperExample
//
//  Created by Atsushi Nagase on 5/19/16.
//  Copyright © 2016 Atsushi Nagase. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices

class GistsViewController: UITableViewController {
    let realm = try! Realm()
    let results = try! Realm().objects(Gist.self).sorted("createdAt", ascending: false)
    var notificationToken: NotificationToken?
    let client = GistAPIClient()

    override init(style: UITableViewStyle) {
        super.init(style: style)

        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "1181-dog"), selectedImage: UIImage(named: "1181-dog-selected"))

        self.title = "Public Gists"

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.dynamicType.loadGists), forControlEvents: .ValueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerClass(GistCell.self, forCellReuseIdentifier: GistCell.cellIdentifier)

        // Set results notification block
        self.notificationToken = self.results.addNotificationBlock({ (changes: RealmCollectionChange) in
            switch changes {
            case .Initial:
                // Results are now populated and can be accessed without blocking the UI
                self.tableView.reloadData()
                break
            case .Update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the TableView
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self.tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self.tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: 0) },
                    withRowAnimation: .Automatic)
                self.tableView.endUpdates()
                break
            case .Error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break
            }
            self.title = "Public Gists (\(self.results.count))"
        })
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadGists()
    }

    // Scroll view delegate

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.bounds.height >= scrollView.contentSize.height {
            self.loadGists(true)
        }
    }

    // Table view data source

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= client.perPage * client.currentPage - 1 {
            self.loadGists(true)
        }
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(GistCell.cellIdentifier, forIndexPath: indexPath) as! GistCell
        cell.gist = results[indexPath.row]
        return cell
    }

    // Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = results[indexPath.row].htmlUrl
        let vc = SFSafariViewController(URL: NSURL(string: url)!)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // Actions

    func loadGists(more: Bool = false) {
        self.client.load(more) {
            self.refreshControl?.endRefreshing()
        }
    }
}