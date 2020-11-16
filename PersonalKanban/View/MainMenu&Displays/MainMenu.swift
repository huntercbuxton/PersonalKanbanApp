//
//  HiddenSliderVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

class MainMenu: UITableViewController {

    // MARK: - other instance properties

    private let cellReuseID = "MainMenuVC.cellReuseID"
    private let options: [MainMenuPages] = MainMenuPages.allCases
    private var savedSelection: MainMenuPages!
    var delegateResponder: MenuInteractionsResponder!

    // MARK: - miscellaneous instance methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableView.tableFooterView = UIView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let cell = tableView.cellForRow(at: IndexPath(row: savedSelection.rawValue, section: 0))
        cell!.setSelected(true, animated: true)
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: self.cellReuseID)
        cell.textLabel?.text = options[indexPath.row].toString
        cell.selectionStyle = .default
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionType = options[indexPath.row]
        self.delegateResponder.detectedSelection(optionType)
        if indexPath.row !=  MainMenuPages.inProgress.rawValue || indexPath.section != 0 {
            tableView.cellForRow(at: IndexPath(row: MainMenuPages.inProgress.rawValue, section: 0))?.setSelected(false, animated: true)
        }
    }

    // MARK: - initialization

    init(sliderDelegate: SlidingViewDelegate, selectionDelegate: MainMenuController?, savedSelection: MainMenuPages) {
        self.savedSelection = savedSelection
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
