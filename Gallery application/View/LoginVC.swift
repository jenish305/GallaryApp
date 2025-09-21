//
//  LoginVC.swift
//  Gallery application
//
//  Created by Jenish  Mac  on 19/09/25.
//

import UIKit

class LoginVC: UIViewController {

    private let viewModel = LoginViewModel()

       override func viewDidLoad() {
           super.viewDidLoad()
           setupBindings()
       }

       private func setupBindings() {
           viewModel.onLoginSuccess = { [weak self] user in
               print("✅ Logged in as: \(user.name), Email: \(user.email)")
               DispatchQueue.main.async {
                   self?.navigateToGallery()
               }
           }

           viewModel.onLoginFailure = { errorMessage in
               print("❌ Login Failed: \(errorMessage)")
           }
       }

    @IBAction func googleLoginTapped(_ sender: Any) {
        viewModel.signIn(presentingVC: self)
    }
    
    private func navigateToGallery() {
           if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let tabbarVC = storyboard.instantiateViewController(withIdentifier: "MainTabbarVC") as! BubbleTabBarController
               sceneDelegate.window?.rootViewController = tabbarVC
               sceneDelegate.window?.makeKeyAndVisible()
           }
       }
    

}
