//
//  ViewController.swift
//  Instagrid
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019 Giovanni Gaffé. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - IBOutlet and IBAction
    
    @IBOutlet private var patternButtons: [UIButton]!
    @IBOutlet private weak var topRightView: UIView!
    @IBOutlet private weak var bottomRightView: UIView!
    @IBOutlet private weak var labelToSwipe: UILabel!
    @IBOutlet private weak var squareImagesView: UIView!
    
    /// switch action when tapped Layout
    @IBAction private func paternButtonTapped(_ sender: UIButton) {
        // UnSelect all buttons to normal and selcted the one tapped
        patternButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        
        switch sender.tag {
        case 1:
            topRightView.isHidden = true
            bottomRightView.isHidden = false
        case 2:
            topRightView.isHidden = false
            bottomRightView.isHidden = true
        case 3:
            topRightView.isHidden = false
            bottomRightView.isHidden = false
        default:
            break
        }
    }
    
    /// UIAlert to ask user interaction
    @IBAction private func pickUpImagesButton(_ sender: UIButton) {
        
        selectedButton = sender
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Upload Photo", message: "Choose a source", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeOutImageView(sender:)))
        guard let swipeGesture = swipeGestureRecognizer else { return }
        setupSwipeDirection()
        squareImagesView.addGestureRecognizer(swipeGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(setupSwipeDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Properties
    
    private var selectedButton: UIButton?
    private var swipeGestureRecognizer: UISwipeGestureRecognizer?
   
    @objc /// Adjust view if view change
       private func setupSwipeDirection() {
           if UIDevice.current.orientation == .portrait {
               swipeGestureRecognizer?.direction = .up
               labelToSwipe.text = "Swipe up to share"
               
           } else if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
               swipeGestureRecognizer?.direction = .left
               labelToSwipe.text = "Swipe left to share"
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
            self.squareImagesView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
        }) { (_) in
            self.shareUIActivityController()
        }
    }
    
    /// animate view for sharing
    private func swipeActionLeft(gesture: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 1, animations: {
            self.squareImagesView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        }) { (_) in
            self.shareUIActivityController()
        }
    }
    
    /// UIActivity for share Image
    private func shareUIActivityController() {
        
        // present Activity with transform image
        let items = [squareImagesView.asImage]
        let ac = UIActivityViewController(activityItems: items , applicationActivities: nil)
        present(ac, animated: true)
        // parameters { activityType, completed(bool), returnItems, activityError }
        ac.completionWithItemsHandler = { _, _ , _, _ in
            UIView.animate(withDuration: 1) {
                // identity put back element original position
                self.squareImagesView.transform = .identity
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
