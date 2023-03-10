//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-02-27.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
  
  var viewModel: MemoListViewModel!
  
  @IBOutlet var addButton: UIBarButtonItem!
  @IBOutlet var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  func bindViewModel() {
    viewModel.title
      .drive(navigationItem.rx.title)
      .disposed(by: rx.disposeBag)
    
    viewModel.memoList.bind(to: tableView.rx.items(cellIdentifier: "MemoCell")) { row, memo, cell in
      cell.textLabel?.text = memo.content
    }
    .disposed(by: rx.disposeBag)
    
    addButton.rx.action = viewModel.makeCreateAction()
    
    tableView.rx.modelSelected(Memo.self)
      .bind(to: viewModel.detailAction.inputs)
      .disposed(by: rx.disposeBag)
  }
}
