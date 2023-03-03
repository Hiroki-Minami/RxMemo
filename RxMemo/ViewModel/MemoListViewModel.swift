//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-02-27.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Action

class MemoListViewModel: CommonViewModel {
  
  var memoList: Observable<[Memo]> {
    return storage.memoList()
  }
  
  func performUpdate(memo: Memo) -> Action<String, Void> {
    return Action { input in
      return self.storage.update(memo: memo, content: input)
        .map {_ in }
    }
  }
  
  func performCancel(memo: Memo) -> CocoaAction {
    return Action {
      return self.storage.delete(memo: memo)
        .map { _ in }
    }
  }
  
  func makeCreateAction() -> CocoaAction {
    return CocoaAction { _ in
      return self.storage.createMemo(content: "")
        .flatMap { memo -> Observable<Void> in
          let composeViewModel = MemoComposeViewModel(title: "New Memo", sceneCoordinater: self.sceneCoordinater, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))
          let composeScene = Scene.compose(composeViewModel)
          
          return self.sceneCoordinater.transition(to: composeScene, using: .modal, animated: true)
            .asObservable()
            .map {_ in }
        }
    }
  }
  
  lazy var detailAction: Action<Memo, Swift.Never> = { this in
    return Action { memo in
      
      print("\(this)")
      let detailViewModel = MemoDetailViewModel(title: "Edit Memo", memo: memo, sceneCoordinater: this.sceneCoordinater, storage: this.storage)
      
      print("\(this.sceneCoordinater)")
      return this.sceneCoordinater
        .transition(to: Scene.detail(detailViewModel), using: .push, animated: true)
        .asObservable()
    }
  }(self)
}
