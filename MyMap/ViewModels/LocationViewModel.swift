//
//  LocationViewModel.swift
//  MyMap
//
//  Created by Chi Tim on 2023/8/8.
//

import Foundation
import SwiftUI
import MapKit

class LocationViewModel:ObservableObject{
    //All loaded locations
    @Published var locations: [Location]
    // Current location on map
    @Published var mapLocation: Location{
        //在mapLocation发生变更时执行下述操作
        didSet{
            updateMapRegion(location: mapLocation)
        }
    }
    // 当前地图区域
    @Published var mapRegion:MKCoordinateRegion = MKCoordinateRegion()
    
    //地图放缩倍数
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    //是否展示位置列表
    @Published var showLocationList:Bool = false
    
    //通过sheet展示的位置详情信息
    @Published var sheetLocation: Location? = nil
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.updateMapRegion(location: locations.first!)
    }
    
    private func updateMapRegion(location:Location){
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                //地图显示中心坐标
                center: location.coordinates,
                //放大缩小倍数，小于1表示放大，大于1表示缩小
                span: mapSpan
            )
        }
    }
    //切换展示状态
    func toggleLocationsList(){
        showLocationList.toggle()
    }
    //将地图切换到下一个位置
    func showNextLocation(location:Location){
        withAnimation(.easeInOut){
            mapLocation = location//切换地图位置坐标
            showLocationList = false
        }
    }
    //点击next按钮时切换location
    func getNextLocation(){
        //得到当前位置在位置列表中的索引
        if let currentIndex = locations.firstIndex(where: {$0 == mapLocation}){
            let nextIndex = currentIndex + 1
            //判断下一个Index是否有效
            guard locations.indices.contains(nextIndex) else {
                //返回第一个位置
                guard let firstLocation = locations.first else {return}
                showNextLocation(location: firstLocation)
                return
            }
            showNextLocation(location: locations[nextIndex])
        }
    }
}
