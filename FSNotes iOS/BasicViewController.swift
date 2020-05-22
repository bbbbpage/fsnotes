//
//  BasicViewController.swift
//  FSNotes iOS
//
//  Created by Олександр Глущенко on 21.05.2020.
//  Copyright © 2020 Oleksandr Glushchenko. All rights reserved.
//

import Foundation
import UIKit

class BasicViewController: UIViewController, SwiftyPageControllerDelegate {

    var containerController: SwiftyPageController!

    func swiftyPageController(_ controller: SwiftyPageController, willMoveToController toController: UIViewController) {
        if let nav = toController as? UINavigationController {
            if let pvc = nav.viewControllers.first as? PreviewViewController {
                //pvc.loadPreview()
                return
            }
        }
    }

    func swiftyPageController(_ controller: SwiftyPageController, didMoveToController toController: UIViewController) {
        if toController.isKind(of: UINavigationController.self) {
            DispatchQueue.main.async {
                self.enableSwipe()
            }
        } else {
            DispatchQueue.main.async {
                self.disableSwipe()
            }
        }

        if let pvc = UIApplication.getPVC() {
            //pvc.clear()
        }
    }

    func swiftyPageController(_ controller: SwiftyPageController, alongSideTransitionToController toController: UIViewController) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let containerController = segue.destination as? SwiftyPageController {
            setupContainerController(containerController)
        }
    }

    func setupContainerController(_ controller: SwiftyPageController) {
        containerController = controller
        containerController.delegate = self
        containerController.animator = .parallax

        let listController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "listViewController")
        let editorController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "editorViewController")
        let previewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "previewViewController")

        let editorNav = UINavigationController(rootViewController: editorController)
        let previewNav = UINavigationController(rootViewController: previewController)

        containerController.viewControllers = [listController, editorNav, previewNav]
        containerController.selectController(atIndex: 0, animated: false)
    }

    public func disableSwipe() {
        if let pan = containerController.panGesture {
            pan.isEnabled = false
        }
    }

    public func enableSwipe() {
        if let pan = containerController.panGesture {
            pan.isEnabled = true
        }
    }
}