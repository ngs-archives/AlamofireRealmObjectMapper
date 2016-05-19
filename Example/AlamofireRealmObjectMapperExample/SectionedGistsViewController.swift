//
//  SectionedGistsViewController.swift
//  AlamofireRealmObjectMapperExample
//
//  Created by Atsushi Nagase on 5/19/16.
//  Copyright © 2016 Atsushi Nagase. All rights reserved.
//

import UIKit
import RealmSwift
import SafariServices
import SwiftFetchedResultsController

class SectionedGistsViewController: UITableViewController, FetchedResultsControllerDelegate {
    let realm = try! Realm()
    var fetchedResultsController: FetchedResultsController<Gist>!

    let client = GistAPIClient()

    override init(style: UITableViewStyle) {
        super.init(style: style)

        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "1182-cat"), selectedImage: UIImage(named: "1182-cat-selected"))

        self.title = "Sectioned Public Gists"

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.dynamicType.loadGists), forControlEvents: .ValueChanged)

        let predicate = NSPredicate(value: true)
        let fetchRequest = FetchRequest<Gist>(realm: realm, predicate: predicate)
        fetchRequest.sortDescriptors = [
            SortDescriptor(property: "dateHour", ascending: false),
            SortDescriptor(property: "createdAt", ascending: false)
        ]
        self.fetchedResultsController = FetchedResultsController<Gist>(fetchRequest: fetchRequest, sectionNameKeyPath: "dateHour", cacheName: "gistsCache")
        self.fetchedResultsController.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(GistCell.self, forCellReuseIdentifier: GistCell.cellIdentifier)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchedResultsController.performFetch()
        self.loadGists()
    }

    // Scroll view delegate

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.bounds.height >= scrollView.contentSize.height {
            self.loadGists(true)
        }
    }

    // Table view delegate

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row >= client.perPage * client.currentPage - 1 {
            self.loadGists(true)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.numberOfRowsForSectionIndex(section)
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = self.fetchedResultsController.titleForHeaderInSection(section)
        return title
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(GistCell.cellIdentifier, forIndexPath: indexPath) as! GistCell
        cell.gist = self.fetchedResultsController.objectAtIndexPath(indexPath)
        return cell
    }

    // Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = self.fetchedResultsController.objectAtIndexPath(indexPath)!.htmlUrl
        let vc = SFSafariViewController(URL: NSURL(string: url)!)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // FetchedResultsControllerDelegate

    func controllerDidChangeContent<T : Object>(controller: FetchedResultsController<T>) {
        self.tableView.endUpdates()
    }

    func controllerWillChangeContent<T : Object>(controller: FetchedResultsController<T>) {
        self.tableView.beginUpdates()
    }

    func controllerDidChangeSection<T : Object>(controller: FetchedResultsController<T>, section: FetchResultsSectionInfo<T>, sectionIndex: UInt, changeType: NSFetchedResultsChangeType) {
        if changeType == NSFetchedResultsChangeType.Insert {
            let indexSet = NSIndexSet(index: Int(sectionIndex))
            tableView.insertSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
        }
        else if changeType == NSFetchedResultsChangeType.Delete {
            let indexSet = NSIndexSet(index: Int(sectionIndex))
            tableView.deleteSections(indexSet, withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

    func controllerDidChangeObject<T : Object>(controller: FetchedResultsController<T>, anObject: SafeObject<T>, indexPath: NSIndexPath?, changeType: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch changeType {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

    // Actions

    func loadGists(more: Bool = false) {
        self.client.load(more) {
            self.refreshControl?.endRefreshing()
        }
    }
}
