//
//  ViewController.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/17/20.
//

import UIKit

class MainViewController: UIViewController, ViewSlidingDelegate {

    // MARK: - instance properties

    var currentPage: MenuOptions!
    var currentTitle: String {  currentPage.rawValue  }
    lazy var menuBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIConstants.menuButtonImageMame,
                                                                  target: self,
                                                                  selector: #selector(menuBarButtonItemTapped))
    lazy var composeBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIConstants.composeButtonImageName,
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

    lazy var vcOne: SliderOneVC = SliderOneVC(delegate: self)
    var vcTwo: BacklogTableVC = BacklogTableVC()

    // MARK: - instance methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.setupElements()
        self.setupChildVC()
    }

    @objc func menuBarButtonItemTapped() {
        self.toggleMenuVisibility()
        print("called \(#function)")
    }

    @objc func composeBarButtonItemTapped() {
        let composeVC = ComposeTaskVC()
        present(UINavigationController(rootViewController: composeVC), animated: true, completion: {})
        print("called \(#function)")
    }

    private func setupElements() {
        title = self.currentTitle
        navigationItem.setLeftBarButton(menuBarButtonItem, animated: false)
        navigationItem.setRightBarButton(composeBarButtonItem, animated: false)
        contentViewOne.pinMenuTo(view, with: slideInMenuPadding)
        contentViewOne.backgroundColor = .systemGray4
        contentViewTwo.edgeTo(view)
        contentViewTwo.backgroundColor = .systemBackground
    }

    private func setupChildVC() {
        vcOne.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentViewOne.addSubview(vcOne.view)
        self.addChild(vcOne)
        vcOne.view.topAnchor.constraint(equalTo: contentViewOne.topAnchor).isActive = true
        vcOne.view.leadingAnchor.constraint(equalTo: contentViewOne.leadingAnchor).isActive = true
        vcOne.view.trailingAnchor.constraint(equalTo: contentViewOne.trailingAnchor).isActive = true
        vcOne.view.bottomAnchor.constraint(equalTo: contentViewOne.bottomAnchor).isActive = true
        vcTwo.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentViewTwo.addSubview(vcTwo.view)
        self.addChild(vcTwo)
        vcTwo.view.topAnchor.constraint(equalTo: contentViewTwo.topAnchor).isActive = true
        vcTwo.view.leadingAnchor.constraint(equalTo: contentViewTwo.leadingAnchor).isActive = true
        vcTwo.view.trailingAnchor.constraint(equalTo: contentViewTwo.trailingAnchor).isActive = true
        vcTwo.view.bottomAnchor.constraint(equalTo: contentViewTwo.bottomAnchor).isActive = true
    }

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

    // MARK: - initialization

    init(page selection: MenuOptions) {
        self.currentPage = selection
        super.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) has not been implemented") }
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
