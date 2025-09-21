# GallaryApp


Gallery App (Google Login + Core Data + Photo Editing)
This iOS app is a basic gallery application where users can:
*  Login with Google
*  Load online wallpapers/images with pagination
*  Cache images offline using Core Data
*  Preview images in fullscreen
*  Edit, crop & apply filters using FMPhotoPicker
*  Save edited images to Photos Library
*  MVVM architecture for clean code & separation of concerns
* 
*   Features
* Login Screen
    * Google login integration.
    * Once logged in, user lands on gallery.
* Gallery Screen
    * Displays online images from Picsum API.
    * Infinite scroll with pagination.
    * Loader shown when fetching more data.
    * Offline support (Core Data caching).
* Image Preview Screen
    * Fullscreen image preview with scaleAspectFill.
    * Filter button → opens FMPhotoPicker editor.
    * Save button → saves image to Photos with permission handling.
    * Success alert after save, then navigates back.   Tech Stack 
* Language: Swift 5
* UI Framework: UIKit + Storyboard
* Architecture: MVVM
* Database: Core Data
* Networking: URLSession
* Third-Party Pods:
    * Firebase/Auth → Google Login
    * SDWebImage → async image loading + caching
    * FMPhotoPicker → image editing, cropping, filters   Author
* Developed by Jenish  Kukadiya (iOS Developer – UIKit, Swift, Core Data,)
