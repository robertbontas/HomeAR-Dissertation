//
//  disertatieApp.swift
//  disertatie
//
//  Created by Bontaș Robert on 30.03.2024.
//

import SwiftUI
import FirebaseCore

/*
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        FirebaseApp.configure()
        return true
    }
}
*/

@main
struct disertatieApp: App {
    init(){
        FirebaseApp.configure()
        print("Firebase got configured.")
    }
    var body: some Scene {
        WindowGroup {
            if AuthService.sharedInstance.currentUser != nil { //user is authenticated
                HomeView()
            }
            else{
                SignInView()
            }
        }
    }
}
