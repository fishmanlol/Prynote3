//
//  EditorViewController.swift
//  Prynote3
//
//  Created by tongyi on 12/14/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import UIKit

protocol EditorViewControllerDelegate {
    func didTapDoneButton(_ editor: EditorViewController, note: Note)
}

extension EditorViewControllerDelegate {
    func didTapDoneButton(_ editor: EditorViewController, note: Note) {}
}

class EditorViewController: UIViewController {
    weak var backgroudImageView: UIImageView!
    weak var titleTextField: UITextField!
    weak var contentTextView: UITextView!
    
    lazy var doneItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didDoneItemTapped))
    lazy var shareToItem = UIBarButtonItem(image: R.image.share_to(), style: .done, target: self, action: #selector(didShareToItemTapped))
    
    var note: Note!
    var notebook: Notebook!
    unowned var storage: Storage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    @objc func didTrashItemTapped() {
        displayWaitingView(msg: "Removing...")
//        note.notebook.remove(note)
    }
    
    @objc func didCameraItemTapped() {
        
    }
    
    @objc func didComposeItemTapped() {
//        notebook.add(note)
    }
    
    @objc func didShareToItemTapped() {
        
    }
    
    @objc func didDoneItemTapped() {
        
    }
    
    @objc func keyboardWillShow(no: Notification) {
        //navigation item
        navigationItem.setRightBarButtonItems([doneItem, shareToItem], animated: false)
    }
    
    @objc func keyboardWillHide(no: Notification) {
        //navigation item
        navigationItem.setRightBarButtonItems([shareToItem], animated: false)
    }
    
    private func setUp() {
        let backgroudImageView = UIImageView(image: R.image.paper_light())
        self.backgroudImageView = backgroudImageView
        view.addSubview(backgroudImageView)
        backgroudImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let titleTextField = UITextField()
        titleTextField.delegate = self
        titleTextField.placeholder = "Title..."
        self.titleTextField = titleTextField
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(36)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        let contentTextView = UITextView()
        contentTextView.delegate = self
        contentTextView.backgroundColor = .clear
        self.contentTextView = contentTextView
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleTextField.snp.bottom).offset(8)
        }
        
        
        //toolbar
        let trashItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTrashItemTapped))
        let cameraItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(didCameraItemTapped))
        let composeItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didComposeItemTapped))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [trashItem, spaceItem, cameraItem, spaceItem, composeItem]
        
        
        //navigation bar
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setRightBarButton(shareToItem, animated: false)
        
        //observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        let trashItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTrashItemTapped))
        let cameraItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(didCameraItemTapped))
        let composeItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didComposeItemTapped))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
        toolbarItems = [trashItem, spaceItem, cameraItem, spaceItem, composeItem]
    }
}

extension EditorViewController: UINavigationControllerDelegate {
    
}

extension EditorViewController: UITextFieldDelegate {

}

extension EditorViewController: UITextViewDelegate {
    
}
