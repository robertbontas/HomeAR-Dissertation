//
//  HomeView.swift
//  disertatie
//
//  Created by Bontaș Robert on 30.03.2024.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Tab = .settings
    
    var body: some View {
        ZStack{
            VStack{
                TabView(selection:$selectedTab){
                    ForEach(Tab.allCases,id:\.rawValue){
                        tab in
                        if selectedTab == .profile{
                            ProfileView()
                        }
                        if selectedTab == .ar{
                            LandingPageArView()
                        }
                        if selectedTab == .settings{
                            SettingsView()
                        }
                        
                    }
                }
            }
            VStack{
                Spacer()
                CustomTabBarView(selectedTab: $selectedTab)
            }
        }
    }
    
}

#Preview {
    HomeView()
}
