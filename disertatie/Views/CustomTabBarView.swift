//
//  MyCustomTabBar.swift
//  homear
//
//  Created by Bontaș Robert on 01.03.2024.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case profile = "person"
    case ar = "scale.3d"
    case settings = "gearshape"
}

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab

    var body: some View {
        VStack {
            HStack(spacing: 60) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    getImage(for: tab)
                        .padding()
                }
                .font(.title2)
            }
            .padding(.horizontal, 30)
        }
        .frame(width: UIScreen.main.bounds.width-60, height: 60)
        .background(Color(hex:"6B9080"))
        .cornerRadius(15)
        .padding()
    }
    private func getImage(for tab: Tab) -> some View {
        let isSelected = tab == selectedTab
        return Image(systemName: tab.rawValue)
            .foregroundColor(isSelected ? Color(hex:"#0A2E36") : Color(hex:"#EAF4F4"))
            .scaleEffect(isSelected ? 0.9 : 0.7)
            .font(isSelected ? .title : .title2)
            .shadow(radius: 10)
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.1)){
                    selectedTab = tab
                }
            }
    }
}

struct CustomTabBarView_Previews: PreviewProvider{
    static var previews: some View{
        CustomTabBarView(selectedTab: .constant(.profile))
    }
}
