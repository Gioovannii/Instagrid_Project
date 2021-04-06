//
//  ViewController.swift
//  Instagrid
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019 Giovanni Gaffé. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Properties
    private var selectedButton: UIButton?
    private var swipeGestureRecognizer: UISwipeGestureRecognizer?
   
    // MARK: - IBOutlet
    @IBOutlet private var patternButtons: [UIButton]!
    @IBOutlet private weak var topRightView: UIView!
    @IBOutlet private weak var topLeftView: UIView!
    @IBOutlet private weak var bottomRightView: UIView!
    @IBOutlet private weak var bottomLeftView: UIView!
    @IBOutlet private weak var labelToSwipe: UILabel!
    @IBOutlet private weak var squareView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeOutImageView(sender:)))
        guard let swipeGesture = swipeGestureRecognizer else { return }
        setupSwipeDirection()
        squareView.addGestureRecognizer(swipeGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(setupSwipeDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        squareView.layer.borderWidth = 1
        squareView.layer.borderColor = UIColor.white.cgColor
        squareView.layer.cornerRadius = 20
        
        let viewArray = [topLeftView, topRightView, bottomLeftView, bottomRightView]
        
        viewArray.forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
        }
        
        patternButtons.forEach {
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 20
            $0.layer.borderColor = UIColor(red: 0.718, green: 0.082, blue: 0.251, alpha: 1).cgColor }
    }
    
    /// switch action when tapped Layout
    @IBAction private func paternButtonTapped(_ sender: UIButton) {
        // UnSelect all buttons to normal and selected the one tapped
        patternButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        
        switch sender.tag {
        case 1:
            topRightView.isHidden = true
            bottomRightView.isHidden = false
            presentCheckmark(text: "Incroyable")
            
        case 2:
            topRightView.isHidden = false
            bottomRightView.isHidden = true
            presentCheckmark(text: "Pas mal")
            
        case 3:
            topRightView.isHidden = false
            bottomRightView.isHidden = false
            presentCheckmark(text: "Parfait")
        default:
            break
        }
    }

    func presentCheckmark() {
        let hudView = HudView.hud(inView: squareView, animated: true)
        hudView.text = "Parfait !"
        afterDelay(1.0) {
            hudView.hide()
        }
    }
    
    /// UIAlert to ask user interaction
    @IBAction private func pickUpImagesButton(_ sender: UIButton) {
        
        selectedButton = sender
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Charger une photo", message: "Choisissez source", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            actionSheet.addAction(UIAlertAction(title: "Caméra", style: .default){ (action: UIAlertAction) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true)
            })
        }
        actionSheet.addAction(UIAlertAction(title: "Bibliothèque", style: .default) { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Annuler", style: .cancel))
        present(actionSheet, animated: true)
        
    }

    @objc /// Adjust view if view change
       private func setupSwipeDirection() {
           if UIDevice.current.orientation == .portrait {
               swipeGestureRecognizer?.direction = .up
               labelToSwipe.text = "Glisser vers le haut pour partager"
               
           } else if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
               swipeGestureRecognizer?.direction = .left
               labelToSwipe.text = "Glisser vers la gauche pour partager"
            labelToSwipe.numberOfLines = 0
           }
       }
    
    /// switch when up or left share
    @objc
    private func swipeOutImageView(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .up:
                swipeActionUp(gesture: sender)
            case .left:
                swipeActionLeft(gesture: sender)
            default:
                break
            }
        }
    }
    
    /// animate view for sharing
    private func swipeActionUp(gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 1, animations: {
            self.squareView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
        }) { (_) in
            self.shareUIActivityController()
        }
    }
    
    /// animate view for sharing
    private func swipeActionLeft(gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 1, animations: {
            self.squareView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        }) { (_) in
            self.shareUIActivityController()
        }
    }
    
    /// UIActivity for share Image
    private func shareUIActivityController() {
        
        // present Activity with transform image
        let items = [squareView.asImage]
        let ac = UIActivityViewController(activityItems: items , applicationActivities: nil)
        present(ac, animated: true)
        // parameters { activityType, completed(bool), returnItems, activityError }
        ac.completionWithItemsHandler = { _, _ , _, _ in
            UIView.animate(withDuration: 1) {
                // identity put back element original position
                self.squareView.transform = .identity
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// set image in squareCenterView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        selectedButton?.setImage(image, for: .normal)
        // selectedButton?.contentMode = .scaleAspectFit
        
        picker.dismiss(animated: true, completion: nil)
    }
}
