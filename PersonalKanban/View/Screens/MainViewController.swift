//
//  ViewController.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/17/20.
//

import UIKit

class MainViewController: UIViewController, SlidingViewDelegate, MenuSelectionDelegate {

    let persistenceManager: PersistenceManager

    // MARK: MenuSelectionDelegate

    typealias IdT = MainMenuOptions

    func upateSelection(from oldSelection: MainMenuOptions?, to newSelection: MainMenuOptions) {
//        print("called \(#function) in MainViewController. args are oldSelection: \(oldSelection) and newSelectioN: \(newSelection)")
        hideMenu()
        guard oldSelection != newSelection else {
//            print("selection repeated.")
            return
        }
        switch newSelection {
        case .backlog:
//            print("will now setup the BackLOG table")
            removeSlidingVCContents()
            self.vcTwo = BacklogTableVC(sliderDelegate: self, persistenceManager: persistenceManager)
            self.title = MainMenuOptions.backlog.pageTitle
            setupContentChildVC()
        case .epics:
//            print("will now setup the EPICS table")
            removeSlidingVCContents()
            self.vcTwo = EpicsTableVC(sliderDelegate: self, persistenceManager: persistenceManager)
            self.title = MainMenuOptions.epics.pageTitle
            setupContentChildVC()
        default:
            self.title = MainMenuOptions.more.pageTitle
//            print("that menu item has not been assigned a response yet")
        }
        self.currentPage = newSelection
    }

    func removeSlidingVCContents() {
//        print("called \(#function)")
        let vc = vcTwo as! UIViewController
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }

    func setupSlidingVCContents(_ newVC: UIViewController) {

    }

    // MARK: SlidingViewDelegate

    func toggleMenuVisibility() {
        UIView.animate(withDuration: self.animationDuration,
                       delay: self.animationDelay,
                       usingSpringWithDamping: self.animationSpringDamping,
                       initialSpringVelocity: self.animationInitialSpringVelocity,
                       options: self.animationOptions) {
            self.contentViewTwo.frame.origin.x = self.menuIsVisible ? 0 :
                self.contentViewTwo.frame.width - self.slideInMenuPadding
        } completion: { (_) in
            self.menuIsVisible.toggle()
        }
    }

    func hideMenu() {
        if menuIsVisible { toggleMenuVisibility() }
    }

    func showMenu() {
        if !menuIsVisible { toggleMenuVisibility() }
    }

    // MARK: MenuSelectionDelegate conformance

    // MARK: - instance properties

    var currentPage: MainMenuOptions!

    // MARK: other instance properties

    var currentTitle: String { currentPage.pageTitle }
    lazy var menuBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIConstants.menuButtonImageMame,
                                                                  target: self,
                                                                  selector: #selector(menuBarButtonItemTapped))
    lazy var addBarButton: UIBarButtonItem = UIBarButtonItem(image: UIConstants.addButtonImageName,
                                                                     target: self,
                                                                     selector: #selector(composeBarButtonItemTapped))
    var menuIsVisible: Bool = false
    var menuPercentageWidthOfParentView: CGFloat = 0.3
    lazy var slideInMenuPadding: CGFloat = self.view.frame.width * menuPercentageWidthOfParentView
    lazy var contentViewOne: UIView = UIView()
    lazy var contentViewTwo: UIView = UIView()
    var animationDuration: TimeInterval = 0.5
    var animationDelay: TimeInterval = 0.0
    var animationSpringDamping: CGFloat = 0.8
    var animationInitialSpringVelocity: CGFloat = 0.0
    var animationOptions: UIView.AnimationOptions = .curveEaseInOut

    lazy var vcOne: SliderOneVC = SliderOneVC(sliderDelegate: self, selectionDelegate: self, savedSelection: MainMenuOptions.backlog)
    lazy var vcTwo: SlidingContentsViewContoller = BacklogTableVC(sliderDelegate: self, persistenceManager: PersistenceManager.shared)

    // MARK: - instance methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        self.coreDataDisplayDelegate = self.vcTwo
        self.setupElements()
        setupFirstChildVC()
        setupContentChildVC()
    }

    @objc func menuBarButtonItemTapped() {
        self.toggleMenuVisibility()
//        print("called \(#function)")
    }

    @objc func composeBarButtonItemTapped() {
        switch currentPage {
        case .backlog:
            let composeVC = AddEditTaskVC(persistenceManager: self.persistenceManager, useState: .create, updateDelegate: self.vcTwo)
            present(UINavigationController(rootViewController: composeVC), animated: true, completion: { })
        case .epics:
            let composeVC = AddEditEpicVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: self.vcTwo)
            present(UINavigationController(rootViewController: composeVC), animated: true, completion: { })
        default:
            fatalError("wrong case caught in \(#function)")
//            print("you selected the compose button on a currentPage of \(currentPage) according to the main parent vc. \(#function) should not have been called.")
        }

        hideMenu()

        print("called \(#function)")
    }

    private func setupElements() {
        title = self.currentTitle
        navigationItem.setLeftBarButton(menuBarButtonItem, animated: false)
        navigationItem.setRightBarButton(addBarButton, animated: false)
        contentViewOne.pinMenuTo(view, with: slideInMenuPadding)
        contentViewOne.backgroundColor = .systemGray4
        contentViewTwo.edgeTo(view)
        contentViewTwo.backgroundColor = .systemBackground
    }

    private func setupFirstChildVC() {
        vcOne.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentViewOne.addSubview(vcOne.view)
        self.addChild(vcOne)
        vcOne.view.topAnchor.constraint(equalTo: contentViewOne.topAnchor).isActive = true
        vcOne.view.leadingAnchor.constraint(equalTo: contentViewOne.leadingAnchor).isActive = true
        vcOne.view.trailingAnchor.constraint(equalTo: contentViewOne.trailingAnchor).isActive = true
        vcOne.view.bottomAnchor.constraint(equalTo: contentViewOne.bottomAnchor).isActive = true
    }

    private func setupContentChildVC() {
        let castVC = self.vcTwo as! UIViewController
        castVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentViewTwo.addSubview(castVC.view)
        self.addChild(castVC)
        castVC.view.topAnchor.constraint(equalTo: contentViewTwo.topAnchor).isActive = true
        castVC.view.leadingAnchor.constraint(equalTo: contentViewTwo.leadingAnchor).isActive = true
        castVC.view.trailingAnchor.constraint(equalTo: contentViewTwo.trailingAnchor).isActive = true
        castVC.view.bottomAnchor.constraint(equalTo: contentViewTwo.bottomAnchor).isActive = true
    }

    // MARK: - initialization

    init(page selection: MainMenuOptions, persistenceManager: PersistenceManager) {
        self.currentPage = selection
        self.persistenceManager = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
}

// MARK: - other type extensions

extension UIBarButtonItem {
    convenience init(image systemName: String, target: AnyObject?, selector: Selector?) {
        self.init()
        let image: UIImage = UIImage(systemName: systemName)!.withRenderingMode(.alwaysOriginal)
        self.image = image
        self.style = .done
        self.setupButtonAction(target: target, selector: selector)
    }

    func setupButtonAction(target: AnyObject?, selector: Selector?) {
        self.target = target
        self.action = selector
    }
}

public extension UIView {

    func edgeTo(_ view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func pinMenuTo(_ view: UIView, with constant: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
