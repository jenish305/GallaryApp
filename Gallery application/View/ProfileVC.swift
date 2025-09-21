//
//  ProfileVC.swift
//  Gallery application
//
//  Created by Jenish  Mac  on 20/09/25.
//

import UIKit
import GoogleSignIn
import SDWebImage

class ProfileVC: UIViewController {
    
    @IBOutlet weak var imgProfile: imgUserProfile!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUi()
        
    }
    
    
    func setUpUi() {
        
        
        lblUserName.text = UserDefaults.standard.string(forKey: "userName") ?? "No Name"
        lblEmail.text = UserDefaults.standard.string(forKey: "userEmail") ?? "No Email"
        
        if let profileURLString = UserDefaults.standard.string(forKey: "userProfilePic"),
           let url = URL(string: profileURLString) {
            imgProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            imgProfile.image = UIImage(named: "placeholder")
        }
        
    }
    

    @IBAction func btnLogoutTapped(_ sender: Any) {
              UserDefaults.standard.removeObject(forKey: "userName")
              UserDefaults.standard.removeObject(forKey: "userEmail")
              UserDefaults.standard.removeObject(forKey: "userProfilePic")
              
              // Google Sign Out
              GIDSignIn.sharedInstance.signOut()
              
              // Navigate back to Login screen
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                  let nav = UINavigationController(rootViewController: loginVC)
                  if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                      sceneDelegate.window?.rootViewController = nav
                  }
              }
    }
    

}
