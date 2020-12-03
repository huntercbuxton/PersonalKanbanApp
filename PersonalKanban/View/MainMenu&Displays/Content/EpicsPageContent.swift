//
//  EpicsPage.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/16/20.
//

import UIKit
import CoreData

// the content for the main menu option 'epics'
class EpicsPageContent: UITableViewController, NSFetchedResultsControllerDelegate, SlidingContentsVC {

    // MARK: - properties

    let cellReuseID = "EpicsPage.cellReuseID"
    weak var sliderDelegate: SlidingViewDelegate?
    let persistence: PersistenceManager!
    var fetchedResultsController: NSFetchedResultsController<Epic>?

    // MARK: - methods

    func loadSavedData() {
        if fetchedResultsController == nil {
            let entityName = String(describing: Epic.self)
            let request = NSFetchRequest<Epic>(entityName: entityName)
            let descriptorKey = "dateCreated"
            let sortDescriptor = NSSortDescriptor(key: descriptorKey, ascending: true)
            request.fetchBatchSize = 20
            request.sortDescriptors = [sortDescriptor]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistence.context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = self
        }

        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        } catch { print("Fetch attempted by function \(#function) failed") }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.tableFooterView = UIView()
        loadSavedData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController?.sections?[section]
        return sectionInfo!.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseID)
        let epic = fetchedResultsController?.object(at: indexPath)
        cell.textLabel?.text = epic!.title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sliderDelegate?.hideMenu()
        let detailVC = AddEditEpicVC(persistenceManager: self.persistence, useState: .edit, epic: fetchedResultsController!.object(at: indexPath))
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - NSFetchedResultsCOntroller

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        tableView.endUpdates()
    }

    // https://stackoverflow.com/questions/4637744/didchangesection-nsfetchedresultscontroller-delegate-method-not-being-called
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let epic = fetchedResultsController?.object(at: indexPath)
        cell.textLabel?.text = epic?.title
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert: tableView.insertSections([sectionIndex], with: .fade)
        case .delete: tableView.deleteSections([sectionIndex], with: .fade)
        default: fatalError("the type of change passed to \(#function) was invalid ")
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete: tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update: self.configureCell(tableView(tableView, cellForRowAt: indexPath!), at: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        default: fatalError("the type of change passed to \(#function) was invalid ")
        }
    }

    // MARK: - initializers

    init(persistence: PersistenceManager, sliderDelegate: SlidingViewDelegate?) {
        self.persistence = persistence
        self.sliderDelegate = sliderDelegate
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

}
