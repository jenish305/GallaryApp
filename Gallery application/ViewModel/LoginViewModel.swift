//
//  LoginViewModel.swift
//  Gallery application
//
//  Created by Jenish  Mac  on 19/09/25.
//

import Foundation
import GoogleSignIn


class LoginViewModel {

    var onLoginSuccess: ((User) -> Void)?
    var onLoginFailure: ((String) -> Void)?

    func signIn(presentingVC: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            if let error = error {
                self.onLoginFailure?("Google Sign-In failed: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else {
                self.onLoginFailure?("No user info found")
                return
            }

            let profile = user.profile
            let loggedInUser = User(
                name: profile?.name ?? "",
                email: profile?.email ?? "",
                profilePic: profile?.imageURL(withDimension: 200)?.absoluteString
            )

            // Save locally
            UserDefaults.standard.setValue(loggedInUser.name, forKey: "userName")
            UserDefaults.standard.setValue(loggedInUser.email, forKey: "userEmail")
            UserDefaults.standard.setValue(loggedInUser.profilePic, forKey: "userProfilePic")

            self.onLoginSuccess?(loggedInUser)
        }
    }
}
