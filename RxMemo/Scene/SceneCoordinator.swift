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
  private var currentVC: UIViewController
  
  required init(window: UIWindow) {
    self.window = window
    self.currentVC = window.rootViewController!
  }
  
  @discardableResult
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
    let subject = PublishSubject<Void>()
    let target = scene.instanciate()
    
    switch style {
    case .root:
      currentVC = target.sceneViewContoller
      window.rootViewController = target
      subject.onCompleted()
    case .push:
      print(currentVC)
      guard let nav = currentVC.navigationController else {
        subject.onError(TransitionError.navigationControllerMissing)
        break
      }
      nav.pushViewController(target, animated: animated)
      currentVC = target.sceneViewContoller
      subject.onCompleted()
    case .modal:
      currentVC.present(target, animated: animated) {
        subject.onCompleted()
      }
      currentVC = target.sceneViewContoller
    }
    return subject.ignoreElements().asCompletable()
  }
  
  func close(animated: Bool) -> Completable {
    return Completable.create { [unowned self] completable in
      if let presentingVC = self.currentVC.presentingViewController {
        self.currentVC.dismiss(animated: animated) {
          self.currentVC = presentingVC.sceneViewContoller
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

extension UIViewController {
  var sceneViewContoller: UIViewController {
    return self.children.first ?? self
  }
}
