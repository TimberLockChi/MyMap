//
//  Location.swift
//  MyMap
//
//  Created by Chi Tim on 2023/8/8.
//

import Foundation
import MapKit
//Equatable表示可以进行比较，通过比较ID
struct Location: Identifiable,Equatable {
    
    let name:String
    let cityName:String
    let coordinates:CLLocationCoordinate2D
    let description:String
    let imageNames:[String]
    let link:String
    
    //自定义id
    var id: String{
        // name = a
        // cityName = b
        // id = ab
        name + cityName
    }
    //比较方法
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
}
