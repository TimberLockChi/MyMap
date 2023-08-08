//
//  MyMapApp.swift
//  MyMap
//
//  Created by Chi Tim on 2023/8/8.
//

import SwiftUI

@main
struct MyMapApp: App {
    
    //APP初始化时创建数据
    @StateObject private var vm = LocationViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environmentObject(vm)//任何子视图都可以获取数据变更
        }
    }
}
