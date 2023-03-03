//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-02-27.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel: CommonViewModel {
  
  var memoRelay = BehaviorRelay<[Memo]>(value: [])
  
  func makeUpdateAction() -> CocoaAction {
    return CocoaAction { _ in
      let composeViewModel = MemoComposeViewModel(title: "Edit Memo", content: self.memoRelay.value[0].content, sceneCoordinater: self.sceneCoordinater, storage: self.storage, saveAction: self.performSave(memo: self.memoRelay.value[0]))
      let composeScene = Scene.compose(composeViewModel)
      
      return self.sceneCoordinater.transition(to: composeScene, using: .modal, animated: true)
        .asObservable()
        .map {_ in }
    }
  }
  
  func performSave(memo: Memo) -> Action<String, Void> {
    return Action { input in
      return self.storage.update(memo: memo, content: input)
        .do(onNext: { memo in
          self.memoRelay.accept([memo, memo])
        })
        .map {_ in }
    }
  }
  
  func makeDeleteAction() -> CocoaAction {
    return CocoaAction { _ in
      return self.storage.delete(memo: self.memoRelay.value[0])
        .flatMap { _ -> Observable<Void> in   
          return self.sceneCoordinater.close(animated: true)
            .asObservable()
            .map {_ in }
        }
    }
  }
  
  func makeBackAction() -> CocoaAction {
    return CocoaAction { _ in
      return self.sceneCoordinater.close(animated: true)
        .asObservable()
        .map {_ in }
    }
  }

  init(title: String, memo: Memo, sceneCoordinater: SceneCoordinatorType, storage: MemoStorageType) {
    self.memoRelay.accept([memo, memo])
    super.init(title: title, sceneCoordinater: sceneCoordinater, storage: storage)
  }
}
