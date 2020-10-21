//
//  ChooseEpicsScreen.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit


protocol EpicsSelectorDelegate {
    func select(epic: Epic)
}

class ChooseEpicsScreen: UITableViewController {

    let persistenceManager: PersistenceManager
    private let cellReuseID = "ChooseEpicsScreen.cellReuseID"
    var selectionDelegate: EpicsSelectorDelegate?

    func loadData() {
        print("called loadData!!!!")
        self.epics = persistenceManager.getAllEpics()
    }

    lazy var epics: [Epic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseID)
        self.tableView.tableFooterView = UITableViewHeaderFooterView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return epics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseID, for: indexPath)
        cell.textLabel?.text = epics[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected the cell at \(indexPath) for task titled: \(self.epics[indexPath.row].title)")
        selectionDelegate?.select(epic: self.epics[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - initialization

    init(persistenceManager: PersistenceManager, selectionDelegate: EpicsSelectorDelegate) {
        self.persistenceManager = persistenceManager
        self.selectionDelegate = selectionDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
