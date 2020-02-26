//
//  ViewController.swift
//  PopoverBugReport
//
//  Created by Péter Urbanovics on 2020. 02. 26..
//  Copyright © 2020. Péter Urbanovics. All rights reserved.
//

import UIKit

class ViewControllerWithOverridedLoadView: UIViewController {
    // If loadView is overridden then this view will not change its size when keyboard comes up
    override func loadView() {
        view = UIView(frame: .zero)
    }
}

class ViewController: UIViewController {

    var popoverVC = UIViewController()
    var openButton = UIButton(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Button
        openButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openButton)
        openButton.addTarget(self, action: #selector(openPopup), for: .touchUpInside)

        NSLayoutConstraint.activate([
            openButton.widthAnchor.constraint(equalToConstant: 100),
            openButton.heightAnchor.constraint(equalToConstant: 100),
            openButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        openButton.backgroundColor = .blue

        popoverVC.view.translatesAutoresizingMaskIntoConstraints = false
        popoverVC.view.backgroundColor = .green
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 300.0, height: 652.0)

        // ViewController in navigation controller
        let vcInNavigationController = ViewControllerWithOverridedLoadView()

        // Textfield
        let textfield = UITextField()
        textfield.backgroundColor = .cyan
        textfield.translatesAutoresizingMaskIntoConstraints = false
        vcInNavigationController.view.addSubview(textfield)
        NSLayoutConstraint.activate([
            textfield.widthAnchor.constraint(equalToConstant: 100),
            textfield.heightAnchor.constraint(equalToConstant: 50),
            textfield.centerXAnchor.constraint(equalTo: vcInNavigationController.view.centerXAnchor),
            textfield.centerYAnchor.constraint(equalTo: vcInNavigationController.view.centerYAnchor)
        ])

        // Navigation controller in popover
        let nav = UINavigationController()
        nav.view.translatesAutoresizingMaskIntoConstraints = false
        nav.view.backgroundColor = .red
        nav.pushViewController(vcInNavigationController, animated: true)

        popoverVC.addChild(nav)
        popoverVC.view.addSubview(nav.view)
        nav.didMove(toParent: popoverVC)
        NSLayoutConstraint.activate([
            nav.view.leftAnchor.constraint(equalTo: popoverVC.view.leftAnchor),
            nav.view.rightAnchor.constraint(equalTo: popoverVC.view.rightAnchor),
            nav.view.topAnchor.constraint(equalTo: popoverVC.view.topAnchor),
            nav.view.bottomAnchor.constraint(equalTo: popoverVC.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popoverVC.popoverPresentationController?.sourceView = openButton
        popoverVC.popoverPresentationController?.sourceRect = openButton.bounds
        present(popoverVC, animated: true)
    }

    @objc func openPopup(_ sender: UIButton) {
        popoverVC.popoverPresentationController?.sourceView = openButton
        popoverVC.popoverPresentationController?.sourceRect = openButton.bounds
        present(popoverVC, animated: true)
    }
}
