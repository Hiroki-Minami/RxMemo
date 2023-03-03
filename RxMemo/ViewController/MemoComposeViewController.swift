//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-02-27.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {
  
  var viewModel: MemoComposeViewModel!
  
  @IBOutlet var cancelButton: UIBarButtonItem!
  @IBOutlet var saveButton: UIBarButtonItem!
  @IBOutlet var textView: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  func bindViewModel() {
    viewModel.title
      .drive(navigationItem.rx.title)
      .disposed(by: rx.disposeBag)
    
    viewModel.initialText
      .drive(textView.rx.text)
      .disposed(by: rx.disposeBag)
    
    cancelButton.rx.action = viewModel.cancelAction
    saveButton.rx.tap
      .throttle(.microseconds(500), scheduler: MainScheduler.instance)
      .withLatestFrom(textView.rx.text.orEmpty)
      .bind(to: viewModel.saveAction.inputs)
      .disposed(by: rx.disposeBag)
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textView.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if textView.isFirstResponder {
      textView.resignFirstResponder()
    }
  }
}
