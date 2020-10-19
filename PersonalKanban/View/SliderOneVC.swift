//
//  HiddenSliderVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

class SliderOneVC: UITableViewController, MenuController {
    weak var menuSelectionDelegate: SlidingViewsMenuSelectionDelegate?
    var lastSelection: MenuOptions?

    // MARK: - SlidingViewsMenu

    weak var sliderDelegate: ViewSlidingDelegate!

    // MARK: - other instance properties

    private let tableViewCellReuseID = "hamburgerMenuCellReuseID"
    var menuTitles: [String]!

    // MARK: - miscellaneous instance methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellReuseID)
        tableView.tableFooterView = UITableViewHeaderFooterView()
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles!.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: self.tableViewCellReuseID)
        cell.textLabel?.text = menuTitles[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            sliderDelegate?.hideMenu()
        case 1:
            sliderDelegate?.showMenu()
        case 2:
            sliderDelegate?.toggleMenuVisibility()
        case 3:
            print("tappled the finished cell")
        case 4:
            print("tapprd the more cell")
        default:
            assertionFailure("error: the menu cell selected has an index path which has not been assigned a value.")
        }
        //self.menuSelectionDelegate!.menuSelection(MenuOptions.getTypeFor(section: 0, row: indexPath.row))
    }

    // MARK: - initialisation

    // This allows you to initialise your custom UIViewController without a nib or bundle.
    convenience init(delegate: ViewSlidingDelegate) {
        self.init(nibName: nil, bundle: nil)
        self.sliderDelegate = delegate
        self.lastSelection = MenuOptions.backlog
        self.menuTitles = MenuOptions.pageTitles
    }

    // This extends the superclass.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    // This is also necessary when extending the superclass.
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
