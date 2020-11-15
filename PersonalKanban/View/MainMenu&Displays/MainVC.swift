//
//  ViewController.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/17/20.
//

import UIKit

class MainVC: UIViewController, SlidingViewDelegate, MainMenuControllerDelegate, CoreDataDisplayDelegate {

    // MARK: - MenuSelectionDelegate protocol conformance

    private var displayController: MainMenuController!
    private lazy var displayRequestHandler: ContentRequestHandler = ContentRequestHandler(persistenceManager: self.persistenceManager, delegateRef: self)
    var page: MainMenuOptions?

    func updateDisplay(for option: MainMenuOptions) {
        print("called \(#function) with argument option = \(option) in MainVC!!!")
        removeSlidingVCContents()
        page = option
        displayVC = displayRequestHandler.mainMenuRequest(option)
        setupContentChildVC(child: displayVC as! UIViewController, superView: contentView)
    }

    func setTitle(_ newTitle: String?) {
        self.title = newTitle
    }

    // MARK: - SlidingViewDelegate protocol conformance

    func toggleMenuVisibility() {
        UIView.animate(withDuration: self.animationDuration,
                       delay: self.animationDelay,
                       usingSpringWithDamping: self.animationSpringDamping,
                       initialSpringVelocity: self.animationInitialSpringVelocity,
                       options: self.animationOptions) {
            self.contentView.frame.origin.x = self.menuIsVisible ? 0 :
                abs(self.contentView.frame.width - self.slideInMenuPadding)
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

    private lazy var menuBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: UIConsts.menuButtonImageMame), style: .plain, target: self, action: #selector(menuBtnTapped))
    private lazy var addBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
    private lazy var menuContainerView: UIView = UIView()
    private lazy var contentView: UIView = UIView()
    private lazy var menuVC: MainMenu = MainMenu(sliderDelegate: self, selectionDelegate: displayController, savedSelection: displayController.initialSelection)
    private lazy var displayVC: SlidingContentsVC = displayRequestHandler.mainMenuRequest(displayController.initialSelection)

    // MARK: - other instance properties

    private var menuPercentageWidthOfParentView: CGFloat = 0.4
    private lazy var slideInMenuPadding: CGFloat = self.view.frame.width * (1 - menuPercentageWidthOfParentView)
    private var animationDuration: TimeInterval = 0.5
    private var animationDelay: TimeInterval = 0
    private var animationSpringDamping: CGFloat = 0.8
    private var animationInitialSpringVelocity: CGFloat = 0
    private var animationOptions: UIView.AnimationOptions = .curveEaseInOut

    private let persistenceManager: PersistenceManager
    private var menuIsVisible: Bool = false

    // MARK: - methods for initial UI setup

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        assignAccessibilityIdentifiers()
        setupNavBar()
        setupContentViews()
        setupContentChildVC(child: menuVC, superView: menuContainerView)
        setupContentChildVC(child: displayVC as! UIViewController, superView: contentView)

    }

    private func assignAccessibilityIdentifiers() {
        // used in the first UI Test
        view.accessibilityIdentifier = AccessibilityIDs.mainVCview
        addBtn.accessibilityIdentifier =  AccessibilityIDs.mainVCaddBtn
        menuBtn.accessibilityIdentifier = AccessibilityIDs.mainVCmenuBtn
    }

    private func setupNavBar() {
        title = self.displayController.initialSelection.pageTitle
        navigationItem.setLeftBarButton(menuBtn, animated: false)
        navigationItem.setRightBarButton(addBtn, animated: false)
    }

    private func setupContentViews() {
        view.addSubview(menuContainerView)
        menuContainerView.translatesAutoresizingMaskIntoConstraints = false
        menuContainerView.constrainVEdgeAnchors(view, constant: 0)
        menuContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -slideInMenuPadding).isActive = true

        view.addSubview(contentView)
        contentView.constrainEdgeAnchors(to: view)
        contentView.layer.shadowColor = UIColor.systemGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowOpacity = 0.6
        contentView.layer.shadowRadius = 4.0
    }

    // MARK: - other methods

    private func removeSlidingVCContents() {
        let vc = displayVC as! UIViewController
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }

    private func setupContentChildVC(child: UIViewController, superView: UIView) {
        child.view.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(child.view)
        self.addChild(child)
        child.view.constrainEdgeAnchors(to: contentView)
    }

    @objc func menuBtnTapped() {
        toggleMenuVisibility()
    }

    @objc func addBtnTapped() {
        let newVC = displayRequestHandler.composeBtnRequest(currentPage: self.page ?? displayController.selection, updateDelegate: displayVC)
        self.navigationController?.pushViewController(newVC, animated: true)
        hideMenu()
    }

    // MARK: - initializers

    init(persistenceManager: PersistenceManager, displayController: MainMenuController) {
        self.persistenceManager = persistenceManager
        self.displayController = displayController
        super.init(nibName: nil, bundle: nil)
        self.displayController.controllerDelegate = self
        self.menuVC.delegateResponder = self.displayController
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
}