//
//  HiddenSliderVC.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/14/20.
//

import UIKit

class SliderOneVC: UITableViewController, MenuController {

    // MARK: MenuController conformance

    typealias SelectionT = MainMenuOptions

    typealias DelegateT = MainViewController

    typealias MenuT = MainMenuData<MainMenuOptions>

    var menu: MainMenuData = MainMenuData(options: MainMenuOptions.allCases, defaultSelection: MainMenuOptions.backlog, currentSelection: MainMenuOptions.backlog)

    weak var selectionDelegate: MainViewController?

    func select(option: MainMenuOptions) {
//        print("MainMenu class is calling \(#function) with arg option: \(option)")
        self.selectionDelegate?.upateSelection(from: menu.currentSelection, to: option)
        menu.currentSelection = option
        sliderDelegate?.hideMenu()
    }

    func reset() {
        self.select(option: menu.defaultSelection)
    }

    func refresh() {
        let selection = self.menu.currentSelection ?? self.menu.defaultSelection
        self.select(option: selection)
    }

    // MARK: - other instance properties

    weak var sliderDelegate: SlidingViewDelegate?

    private let tableViewCellReuseID = "hamburgerMenuCellReuseID"

    lazy var menuTitles: [String] = MainMenuOptions.allPageTitles

    // MARK: MenuViewController conformance
//
//    typealias customT = MenuT
//    typealias controllerT = SliderOneVC
//
//    lazy var controller: controllerT = self

    // MARK: - miscellaneous instance methods

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellReuseID)
        tableView.tableFooterView = UITableViewHeaderFooterView()
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: self.tableViewCellReuseID)
        cell.textLabel?.text = menuTitles[indexPath.row]
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("main menu class selected the option at \(String(describing: indexPath))")
        guard let option = MainMenuOptions.init(rawValue: indexPath.row) else {
            fatalError("the index path selected was \(indexPath.description) which cannot be converted to a menu option")
        }
        select(option: option)
    }

    // MARK: initialization

    init(sliderDelegate: SlidingViewDelegate, selectionDelegate: MainViewController?, savedSelection: MainMenuOptions?) {
        self.sliderDelegate = sliderDelegate
        self.selectionDelegate = selectionDelegate
        if let saved = savedSelection { self.menu.currentSelection = saved }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
