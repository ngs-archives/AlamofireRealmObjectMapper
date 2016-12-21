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
        self.refreshControl?.addTarget(self, action: #selector(type(of: self).loadGists), for: .valueChanged)

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
        self.tableView.register(GistCell.self, forCellReuseIdentifier: GistCell.cellIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchedResultsController.performFetch()
        self.loadGists()
    }

    // Scroll view delegate

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.bounds.height >= scrollView.contentSize.height {
            self.loadGists(true)
        }
    }

    // Table view delegate

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= client.perPage * client.currentPage - 1 {
            self.loadGists(true)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.numberOfRowsForSectionIndex(section)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = self.fetchedResultsController.titleForHeaderInSection(section)
        return title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GistCell.cellIdentifier, for: indexPath) as! GistCell
        cell.gist = self.fetchedResultsController.objectAtIndexPath(indexPath)
        return cell
    }

    // Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = self.fetchedResultsController.objectAtIndexPath(indexPath)!.htmlUrl
        let vc = SFSafariViewController(URL: URL(string: url)!)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // FetchedResultsControllerDelegate

    func controllerDidChangeContent<T : Object>(_ controller: FetchedResultsController<T>) {
        self.tableView.endUpdates()
    }

    func controllerWillChangeContent<T : Object>(_ controller: FetchedResultsController<T>) {
        self.tableView.beginUpdates()
    }

    func controllerDidChangeSection<T : Object>(_ controller: FetchedResultsController<T>, section: FetchResultsSectionInfo<T>, sectionIndex: UInt, changeType: NSFetchedResultsChangeType) {
        if changeType == NSFetchedResultsChangeType.Insert {
            let indexSet = IndexSet(integer: Int(sectionIndex))
            tableView.insertSections(indexSet, with: UITableViewRowAnimation.fade)
        }
        else if changeType == NSFetchedResultsChangeType.Delete {
            let indexSet = IndexSet(integer: Int(sectionIndex))
            tableView.deleteSections(indexSet, with: UITableViewRowAnimation.fade)
        }
    }

    func controllerDidChangeObject<T : Object>(_ controller: FetchedResultsController<T>, anObject: SafeObject<T>, indexPath: IndexPath?, changeType: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch changeType {
        case .Insert:
            tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.fade)
        case .Delete:
            tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
        case .Update:
            tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
        case .Move:
            tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
            tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.fade)
        }
    }

    // Actions

    func loadGists(_ more: Bool = false) {
        self.client.load(more) {
            self.refreshControl?.endRefreshing()
        }
    }
}
