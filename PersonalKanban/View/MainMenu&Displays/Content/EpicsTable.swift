//
//  EpicsTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

class EpicsTable: UITableViewController, SlidingContentsVC {

    // MARK: - SlidingContentsViewContoller conformance

    weak var sliderDelegate: SlidingViewDelegate?

    func refreshDisplay() {
        self.epics = persistenceManager.getAllEpics()
        tableView.reloadData()
    }

    // MARK: - CoreDataDisplayDelegate conformance

    func updateCoreData() {
        self.epics = persistenceManager.getAllEpics()
        self.tableView.reloadData()
    }

    // MARK: - other instance properties

    let persistenceManager: PersistenceManager
    private let cellReuseID = "EpicsTableVC.CellReuseID"
    lazy var epics: [Epic] = []

    // MARK: - UIViewController function overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        epics = persistenceManager.getAllEpics()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseID)
        self.tableView.tableFooterView = UITableViewHeaderFooterView()
    }

    // this is what updates the displayed titles of the epics if they've been edited since last time we saw this table
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshDisplay()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.epics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseID, for: indexPath)
        cell.textLabel?.text = epics[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sliderDelegate?.hideMenu()
        let detailView = EpicDetailView(persistenceManager: persistenceManager, epic: epics[indexPath.row])
        self.navigationController?.pushViewController(detailView, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Are you sure?", message: "deleting this epic will also delete all its tasks.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                let epic = self.epics[indexPath.row]
                self.persistenceManager.delete(epic: epic)
                self.epics.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - initialization

    init(sliderDelegate: MainVC?, persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
