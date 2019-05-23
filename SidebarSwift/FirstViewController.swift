//
//  FirstViewController.swift
//  SidebarSwift
//
//  Created by Igor Shukyurov on 07.04.17.
//  Copyright © 2017 Igor Shukyurov. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    let animator = Animator()
    var isMenuOpen: Bool = false
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sidebarView: UIView!
    
    // MARK: Sidebar open/close animations
    func showMenu() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.frame.origin.x = self.contentView.frame.width - 75
            self.contentView.frame.origin.y = 20
        }, completion: { success in self.isMenuOpen = true })
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.frame.origin.x = 0
            self.contentView.frame.origin.y = 0
        }, completion: { success in self.isMenuOpen = false })
    }
    
    // MARK: Transition delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        destination.transitioningDelegate = animator
    }
    
    // MARK: Button actions
    @IBAction func actionMenu(_ sender: Any) { // Кнопка меню
        if isMenuOpen == false {
            showMenu()
        } else {
            hideMenu()
        }
    }

    @IBAction func actionHide(_ sender: Any) { // Кнопка выбора данной вьюхи в боковом меню
        hideMenu()
    }
    
    @IBAction func gotoView2(_ sender: Any) { // Кнопка выбора второй вьюхи в боковом меню
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.frame.origin.x = self.view.frame.width
            self.contentView.frame.origin.y = self.view.frame.width / ((self.view.frame.width - 75) / 20)
        }, completion: { success in
            self.contentView.removeFromSuperview()
            self.performSegue(withIdentifier: "gotoView2", sender: self)
        })
    }
    
    // MARK: Swipe actions
    @IBAction func actionSwipe(_ sender: UIScreenEdgePanGestureRecognizer) { // Свайп с левой грани (открытие меню)
        let contentView = sender.view
        let point = sender.translation(in: view)
        
        if point.x < 0 { // Чтобы не двигалась за границу налево
            hideMenu()
            return
        }
        
        if sender.state == UIGestureRecognizerState.ended { // Если убрали палец
            
            if point.x < view.frame.width / 2 { // Если палец слева от центра, то прячем меню
                hideMenu()
                return
            } else { // Если палец справа от центра, то показываем меню
                showMenu()
                return
            }
        }
        
        // Задаем траекторию движения
        contentView!.center = CGPoint(x: view.center.x + point.x,
                                      y: view.frame.height / 2 + point.x / ((view.frame.width - 75) / 20))
    }
    
    @IBAction func actionSwipeBack(_ sender: UIPanGestureRecognizer) { // Свайп с правой грани (закрытие меню)
        let contentView = sender.view
        let point = sender.translation(in: view)
        
        if isMenuOpen == false { // Если меню закрыто, то не обрабатываем свайп справа
            return
        }
        
        if (point.x + (contentView?.frame.width)! - 75) < 0 { // Чтобы не двигалась за границу налево
            hideMenu()
            return
        }
        
        if sender.state == UIGestureRecognizerState.ended { // Если убрали палец, то прячем менюху
            hideMenu()
            return
        }
        
        // Задаем траекторию движения
        contentView!.center = CGPoint(x: view.center.x + point.x + (contentView?.frame.width)! - 75,
                                      y: view.frame.height / 2 + point.x / ((view.frame.width - 75) / 20) + 20)
    }
}
