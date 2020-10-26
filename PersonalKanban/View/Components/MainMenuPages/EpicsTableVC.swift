//
//  EpicsTableVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

class EpicsTableVC: UITableViewController, SlidingContentsViewContoller {

    // MARK: - SlidingContentsViewContoller

    weak var sliderDelegate: SlidingViewDelegate?

    func refreshDisplay() {
        print("called \(#function) in EpicsTableVC")
    }

    func updateCoreData() {
        print("called \(#function) in EpicsTableVC")
        self.epics = persistenceManager.getAllEpics()
        self.tableView.reloadData()
    }

    // MARK: Data management

    let persistenceManager: PersistenceManager

    func loadData() {
        print("called loadData!!!!")
        self.epics = persistenceManager.getAllEpics()
    }

    lazy var epics: [Epic] = []

    private let cellReuseID = "EpicsTableVC.CellReuseID"

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseID)
        self.tableView.tableFooterView = UITableViewHeaderFooterView()
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

    // MARK: UITableViewDelegate conformance

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sliderDelegate?.hideMenu()
//        print("selected the cell at \(indexPath) for task titled: \(self.epics[indexPath.row].title)")
      //  let detailView = AddEditEpicVC(persistenceManager: persistenceManager, useState: .edit, epic: epics[indexPath.row], updateDelegate: self)
        let detailView = EpicTasksTableVC(persistenceManager: persistenceManager, epic: epics[indexPath.row])
        self.navigationController?.pushViewController(detailView, animated: true)
    }

    // MARK: - initialization

    init(sliderDelegate: MainViewController?, persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
