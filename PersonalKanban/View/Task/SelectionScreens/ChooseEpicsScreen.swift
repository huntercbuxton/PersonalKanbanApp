//
//  ChooseEpicsScreen.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import UIKit

public protocol EpicsSelectorDelegate: AnyObject {
    func select( epic: Epic)
}

class ChooseEpicsScreen: UITableViewController {

    private let persistenceManager: PersistenceManager
    private let cellReuseID = "ChooseEpicsScreen.cellReuseID"
    weak var delegate: EpicsSelectorDelegate?
    lazy var epics: [Epic] = []
    var currentEpic: Epic?

    func loadData() {
        self.epics = persistenceManager.getAllEpics()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseID)
        self.tableView.tableFooterView = UITableViewHeaderFooterView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selection = self.currentEpic, let selectedIndex = epics.firstIndex(of: selection) {
                let indexPath = IndexPath(row: selectedIndex, section: 0)
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                let cell = tableView.cellForRow(at: indexPath)
                cell?.setHighlighted(true, animated: true)
            
        }
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
        delegate?.select(epic: self.epics[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - initialization

    init(persistenceManager: PersistenceManager, selectionDelegate: EpicsSelectorDelegate, currentEpic: Epic?) {
        self.persistenceManager = persistenceManager
        self.delegate = selectionDelegate
        self.currentEpic = currentEpic
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
