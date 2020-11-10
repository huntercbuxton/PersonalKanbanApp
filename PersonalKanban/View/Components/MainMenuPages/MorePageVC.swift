//
//  MorePageVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/9/20.
//

import UIKit

class MorePageVC: UITableViewController, SlidingContentsViewContoller {

    var sliderDelegate: SlidingViewDelegate?

    // MARK: - other instance properties

    private let titleText = "More"
    private let cellReuseID = "MorePageVC.cellReuseID"
    private let sections = ["sorting/displaying data",
                            "options for tasks & epic data",
                            "display and accessibility",
                            "my account",
                            "info",
                            "other"
                            ]
    private let options = [ ["main menu options","home screen","default"],
                            ["task types","priority","story points","due date","notes","related tasks"],
                            ["haptics","color schemes","font size","font weight","automatically read displayed text"],
                            ["login credentials","account recovery methods","device login","delete account"],
                            ["help FAQ's","'agile' principles","the kanban method","onboarding tutorials","how we protect your data","security tips"],
                            ["delete all data","restore with timestamp","force download","force backup","create restore point"]
                            ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleText
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseID)
        cell.textLabel?.text = self.options[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("action for selection of indexPath \(String.init(describing: indexPath)) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    // MARK: - initializers

    init(delegate: SlidingViewDelegate) {
        self.sliderDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
}
