//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-02-27.
//

import Foundation
import RxCocoa
import RxSwift
import Action

class MemoComposeViewModel: CommonViewModel {
  private var content: String?
  var initialText: Driver<String?> {
    return Observable.just(content)
      .asDriver(onErrorJustReturn: nil)
  }
  
  var saveAction: Action<String, Void>
  var cancelAction: CocoaAction
  
  init(title: String, content: String? = nil, sceneCoordinater: SceneCoordinatorType, storage: MemoStorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {    
    self.content = content
    self.saveAction = Action<String, Void> { input in
      if let action = saveAction {
        action.execute(input)
      }
      return sceneCoordinater.close(animated: true)
        .asObservable()
        .map { _ in }
    }
    
    self.cancelAction = CocoaAction {
      if let action = cancelAction {
        action.execute()
      }
      return sceneCoordinater.close(animated: true)
        .asObservable()
        .map { _ in }
    }
    super.init(title: title, sceneCoordinater: sceneCoordinater, storage: storage)
  }
}
