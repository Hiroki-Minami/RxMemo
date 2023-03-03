//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-02-27.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoDetailViewController: UIViewController, ViewModelBindableType {
  
  var viewModel: MemoDetailViewModel!
  
  @IBOutlet var tableView: UITableView!
  
  @IBOutlet var deleteButton: UIBarButtonItem!
  @IBOutlet var composeButton: UIBarButtonItem!
  @IBOutlet var shareButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let barbutton = UIBarButtonItem(title: "My memo", style: .plain, target: nil, action: nil)
    self.navigationItem.leftBarButtonItem = barbutton
//    self.navigationItem.leftBarButtonItem?.rx.action =
//    self.navigationItem.setHidesBackButton(true, animated: false)
  }
  
  func bindViewModel() {
    viewModel.title
      .drive(navigationItem.rx.title)
      .disposed(by: rx.disposeBag)
    
    viewModel.memoRelay
      .bind(to: tableView.rx.items) { tableView, row, value in
        switch row {
        case 0:
          let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell")!
          cell.textLabel?.text = value.content
          return cell
        case 1:
          let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell")!
          cell.textLabel?.text = value.insertDate.formatted()
          return cell
        default:
          fatalError("Table View error")
        }
      }
      .disposed(by: rx.disposeBag)
    
    self.navigationItem.leftBarButtonItem!.rx.action = viewModel.makeBackAction()
    
//    viewModel.memoRelay
//      .bind(to: tableView.rx.items(cellIdentifier: "DetailCell")) { row, memo, cell in
//        let datailCell = cell as! MemoDetailTableViewCell
//        datailCell.contentLabel.text = memo.content
//        datailCell.dateLabel.text = memo.insertDate.formatted()
//      }
//      .disposed(by: rx.disposeBag)
    
    deleteButton.rx.action = viewModel.makeDeleteAction()
    composeButton.rx.action = viewModel.makeUpdateAction()
    
    shareButton.rx.tap
      .subscribe(onNext: {[unowned self] in
        let activityViewController = UIActivityViewController(activityItems: [viewModel.memoRelay.value[0].content], applicationActivities: nil)
        self.present(activityViewController, animated: true)
      })
      .disposed(by: rx.disposeBag)
  }
}
