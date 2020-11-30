//
//  FRCTaskLists.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/15/20.
//

import UIKit
import CoreData

class TasksPageContent: UITableViewController, SlidingContentsVC, NSFetchedResultsControllerDelegate {

    let cellReuseID = "FRCTaskLists.cellReuseID"
    var sliderDelegate: SlidingViewDelegate?
    let persistence: PersistenceManager!
    let folder: TaskFolder!
    var fetchedResultsController: NSFetchedResultsController<Task>?

    func loadSavedData() {
        if fetchedResultsController == nil {
            let entityName = String(describing: Task.self)
            let request = NSFetchRequest<Task>(entityName: entityName)
            let descriptorKey = "dateUpdated"
            let taskPredicate = folder.fetchPredicate
            let sortDescriptor = NSSortDescriptor(key: descriptorKey, ascending: true)
            request.fetchBatchSize = 20
            request.sortDescriptors = [sortDescriptor]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistence.context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.fetchRequest.predicate = taskPredicate
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
        let task = fetchedResultsController?.object(at: indexPath)
        cell.textLabel?.text = task!.title
        cell.detailTextLabel?.text = task!.stickyNote
        print("task: \(task!.title) with status: \(String(describing: task?.workflowStatusEnum?.toString)), storypoints: \(task!.storyPointsEnum) and folder: \(task!.computedFolder) ")
           return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sliderDelegate?.hideMenu()
        let detailVC = AddEditTaskVC(persistenceManager: persistence, useState: .edit, task: fetchedResultsController!.object(at: indexPath), updateDelegate: self)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - NSFetchedResultsCOntroller

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    // https://stackoverflow.com/questions/4637744/didchangesection-nsfetchedresultscontroller-delegate-method-not-being-called
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let task = fetchedResultsController?.object(at: indexPath)
        cell.textLabel?.text = task?.title
        cell.detailTextLabel?.text = task?.stickyNote
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

    init(persistenceManager: PersistenceManager, sliderDelegate: SlidingViewDelegate?, folder: TaskFolder) {
        self.persistence = persistenceManager
        self.sliderDelegate = sliderDelegate
        self.folder = folder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
}
