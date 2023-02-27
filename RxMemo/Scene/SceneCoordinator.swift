//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-02-27.
//

import UIKit
import RxSwift

class ScenCoordinator: SceneCoordinatorType {
  
  private let bag = DisposeBag()
  
  private var window: UIWindow
  private var currentVC: UIViewController {
    didSet {
      window.rootViewController = currentVC
    }
  }
  
  required init(window: UIWindow) {
    self.window = window
    self.currentVC = window.rootViewController!
  }
  
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
    let subject = PublishSubject<Void>()
    let target = scene.instanciate()
    
    switch style {
    case .root:
      currentVC = target
      subject.onCompleted()
    case .push:
      guard let nav = currentVC.navigationController else {
        subject.onError(TransitionError.navigationControllerMissing)
        break
      }
      nav.pushViewController(target, animated: animated)
      currentVC = target
      subject.onCompleted()
    case .modal:
      currentVC.present(target, animated: animated) {
        subject.onCompleted()
      }
      self.currentVC = target
    }
    return subject.ignoreElements().asCompletable()
  }
  
  func close(animated: Bool) -> Completable {
    return Completable.create { [unowned self] completable in
      if let presentingVC = self.currentVC.presentingViewController {
        self.currentVC.dismiss(animated: animated) {
          self.currentVC = presentingVC
          completable(.completed)
        }
      } else if let nav = self.currentVC.navigationController {
        if nav.popViewController(animated: animated) == nil {
          completable(.error(TransitionError.cannotPop))
          return Disposables.create()
        }
        self.currentVC = nav.viewControllers.last!
        completable(.completed)
      } else {
        completable(.error(TransitionError.unknown))
      }
      return Disposables.create()
    }
  }
  
  
}
