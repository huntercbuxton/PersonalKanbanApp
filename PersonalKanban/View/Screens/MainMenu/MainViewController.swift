//
//  ViewController.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/17/20.
//

import UIKit

class MainViewController: UIViewController, SlidingViewDelegate, MenuSelectionDelegate {

    // MARK: - MenuSelectionDelegate protocol conformance

    typealias IdT = MainMenuOptions

    func upateSelection(from oldSelection: MainMenuOptions?, to newSelection: MainMenuOptions) {
        hideMenu()
        guard oldSelection != newSelection else { return }
        self.currentPage = newSelection
        removeSlidingVCContents()
        switch newSelection {
        case .inProgress:
            vcTwo = TasksTable(sliderDelegate: self, persistenceManager: persistenceManager, sortValue: .inProgress)
            setupContentChildVC(child: vcTwo as! UIViewController, superView: contentViewTwo)
        case .toDo:
            vcTwo = TasksTable(sliderDelegate: self, persistenceManager: persistenceManager, sortValue: .toDo)
            setupContentChildVC(child: vcTwo as! UIViewController, superView: contentViewTwo)
        case .backlog:
            vcTwo = TasksTable(sliderDelegate: self, persistenceManager: persistenceManager, sortValue: .backlog)
            setupContentChildVC(child: vcTwo as! UIViewController, superView: contentViewTwo)
        case .finished:
            vcTwo = TasksTable(sliderDelegate: self, persistenceManager: persistenceManager, sortValue: .finished)
            setupContentChildVC(child: vcTwo as! UIViewController, superView: contentViewTwo)
        case .epics:
            vcTwo = EpicsTableVC(sliderDelegate: self, persistenceManager: persistenceManager)
            setupContentChildVC(child: vcTwo as! UIViewController, superView: contentViewTwo)
        case .archived:
            vcTwo = ArchivedTasksTableVC(sliderDelegate: self, persistenceManager: self.persistenceManager)
            setupContentChildVC(child: vcTwo as! UIViewController, superView: contentViewTwo)
        case .more:
            vcTwo = MorePageVC(delegate: self)
            setupContentChildVC(child: vcTwo as! UIViewController, superView: contentViewTwo)
        }
    }

    // MARK: - SlidingViewDelegate protocol conformance

    func toggleMenuVisibility() {
        UIView.animate(withDuration: self.animationDuration,
                       delay: self.animationDelay,
                       usingSpringWithDamping: self.animationSpringDamping,
                       initialSpringVelocity: self.animationInitialSpringVelocity,
                       options: self.animationOptions) {
            self.contentViewTwo.frame.origin.x = self.menuIsVisible ? 0 :
                abs(self.contentViewTwo.frame.width - self.slideInMenuPadding)
        } completion: { (_) in }
        self.menuIsVisible.toggle()
    }

    func hideMenu() {
        if menuIsVisible { toggleMenuVisibility() }
    }

    func showMenu() {
        if !menuIsVisible { toggleMenuVisibility() }
    }

    // MARK: - properties referencing UI components

    private lazy var menuBBI: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: UIConsts.menuButtonImageMame), style: .plain, target: self, action: #selector(menuBBITapped))
    private lazy var addBBI: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBBITapped))
    private lazy var contentViewOne: UIView = UIView()
    private lazy var contentViewTwo: UIView = UIView()
    private lazy var vcOne: SliderOneVC = SliderOneVC(sliderDelegate: self, selectionDelegate: self, savedSelection: MainMenuOptions.backlog)
    private lazy var vcTwo: SlidingContentsViewContoller = TasksTable(sliderDelegate: self, persistenceManager: persistenceManager, sortValue: .backlog)

    // MARK: - properties specifying UI style/layout

    private var menuPercentageWidthOfParentView: CGFloat = 0.4
    private lazy var slideInMenuPadding: CGFloat = self.view.frame.width * (1 - menuPercentageWidthOfParentView)
    private var animationDuration: TimeInterval = 0.5
    private var animationDelay: TimeInterval = 0.0
    private var animationSpringDamping: CGFloat = 0.8
    private var animationInitialSpringVelocity: CGFloat = 0.0
    private var animationOptions: UIView.AnimationOptions = .curveEaseInOut
    private var currentPage: MainMenuOptions! {
        didSet {
            self.title = currentPage.pageTitle
        }
    }

    // MARK: - other properties

    private let persistenceManager: PersistenceManager
    private var menuIsVisible: Bool = false

    // MARK: - methods for initial UI setup

    override func viewDidLoad() {
        super.viewDidLoad()

        // used in the first 'example' UITest
        view.accessibilityIdentifier = "mainParentVCID"
//        navigationController!.navigationBar.accessibilityIdentifier = "featureNavigationBar"
        addBBI.accessibilityIdentifier = "addBBI"
        menuBBI.accessibilityIdentifier = "menuBBI"

        view.backgroundColor = .systemBackground
        setupSubviews()
        setupContentChildVC(child: vcOne, superView: contentViewOne)
        setupContentChildVC(child: vcTwo as! UIViewController, superView: contentViewTwo)

    }

    private func setupSubviews() {
        title = self.currentPage.pageTitle
//        self.navigationItem.title = "a title for some reason"
        navigationItem.setLeftBarButton(menuBBI, animated: false)
        navigationItem.setRightBarButton(addBBI, animated: false)

        view.addSubview(contentViewOne)
        contentViewOne.translatesAutoresizingMaskIntoConstraints = false
        contentViewOne.constrainVEdgeAnchors(view, constant: 0)
        contentViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -slideInMenuPadding).isActive = true

        view.addSubview(contentViewTwo)
        contentViewTwo.constrainEdgeAnchors(to: view)
        contentViewTwo.layer.shadowColor = UIColor.systemGray.cgColor
        contentViewTwo.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        contentViewTwo.layer.shadowOpacity = 0.6
        contentViewTwo.layer.shadowRadius = 4.0
    }

    // MARK: - other methods

    private func removeSlidingVCContents() {
        let vc = vcTwo as! UIViewController
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }

    private func setupContentChildVC(child: UIViewController, superView: UIView) {
        child.view.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(child.view)
        self.addChild(child)
        child.view.constrainEdgeAnchors(to: contentViewTwo)
    }

    @objc func menuBBITapped() {
        print("called \(#function)")
        self.toggleMenuVisibility()
    }

    @objc func addBBITapped() {
        switch currentPage {
        case .inProgress:
            let composeVC = AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: vcTwo, defaultPosition: .inProgress)
            self.navigationController?.pushViewController(composeVC, animated: true)
        case .toDo:
            let composeVC  = AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: vcTwo, defaultPosition: WorkflowPosition.toDo)
            self.navigationController?.pushViewController(composeVC, animated: true)
        case .backlog:
            let composeVC = AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: vcTwo, defaultPosition: .backlog)
            self.navigationController?.pushViewController(composeVC, animated: true)
        case .finished:
            let composeVC = AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: vcTwo, defaultPosition: .finished)
            self.navigationController?.pushViewController(composeVC, animated: true)
        case .epics:
            let composeVC = AddEditEpicVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: vcTwo)
            self.navigationController?.pushViewController(composeVC, animated: true)
        case .archived:
             let composeVC = AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: vcTwo, defaultPosition: .backlog)
             self.navigationController?.pushViewController(composeVC, animated: true)
        case .more:
            print("called \(#function); should probably remove the add button when on these pages.")
        default:
            fatalError("wrong case caught in \(#function)")
        }
        hideMenu()
    }

    // MARK: - initializers

    init(page selection: MainMenuOptions, persistenceManager: PersistenceManager) {
        self.currentPage = selection
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
}
