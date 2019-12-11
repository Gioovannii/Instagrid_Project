//
//  ViewController.swift
//  Instagrid
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019 Giovanni Gaffé. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // IBOutlet
    
    @IBOutlet var patternButtons: [UIButton]!
    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var bottomRightView: UIView!
    @IBOutlet weak var labelToSwipe: UILabel!
    @IBOutlet weak var squareImagesView: UIView!
    
    var swipeGestureRecognizer: UISwipeGestureRecognizer?
    
    // Properties

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        guard let swipeGesture = swipeGestureRecognizer else { return }
        setupSwipeDirection()
        squareImagesView.addGestureRecognizer(swipeGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(setupSwipeDirection), name: UIDevice.orientationDidChangeNotification, object: nil)
    
//    let panGestureReconizer = UIPanGestureRecognizer(target: self, action: #selector(dragSquareImagesView(sender:)))
//        squareImagesView.addGestureRecognizer(panGestureReconizer)
    }
    
    // ==============================
    // UIActivityController pop up
    
    /// switch when up or left share
    @objc
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .up:
                print("Swipe UP ")
            case .left:
                print("Swipe Left")
            default:
                break
            }
        }
    }
    
    @objc
    func setupSwipeDirection() {
        if UIDevice.current.orientation == .portrait {
            swipeGestureRecognizer?.direction = .up
        } else if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            swipeGestureRecognizer?.direction = .left
        }
    }
    
    @objc
    func dragSquareImagesView(sender: UIPanGestureRecognizer) {

        switch sender.state {
        case .began, .changed:
            swipeOutImageView(gesture: sender)
        case .cancelled, .ended:
            shareUIActivityController()
        default:
            break
        }

    }

    func swipeOutImageView(gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: squareImagesView)
//        squareImagesView.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
//
//        var screenLength = UIScreen.main.bounds.width
//        let translationPercent = translation.y / (screenLength/2)

        


    }
    
    
    func shareUIActivityController() {
        
    }
    
    
    /// switch action when tapped Layout
    @IBAction func paternButtonTapped(_ sender: UIButton) {
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
    @IBAction func pickUpImagesButton(_ sender: UIButton) {
        
        selectedButton = sender
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Upload Photo", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    var selectedButton: UIButton?
    
    /// set image in the view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        selectedButton?.setImage(image, for: .normal)
        selectedButton?.contentMode = .scaleAspectFit

        picker.dismiss(animated: true, completion: nil)
    }
}
