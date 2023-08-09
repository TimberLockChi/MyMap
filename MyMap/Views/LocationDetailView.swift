//
//  LocationDetailView.swift
//  MyMap
//
//  Created by Chi Tim on 2023/8/9.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    @EnvironmentObject private var vm: LocationViewModel
    
    let location: Location
    
    var body: some View {
        ScrollView{
            VStack{
                //轮播图部分
                imageSection
                    .shadow(color: Color.black.opacity(0.3), radius: 20,x:0,y:10)
                VStack(alignment: .leading,spacing: 16) {
                    //标题部分
                    titleSection
                    Divider()//分割线
                    //详情部分
                    descriptionSection
                    Divider()
                    mapLayer
                    
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(alignment: .topLeading) {
            backButton
        }
    }
}

extension LocationDetailView{
    private var imageSection: some View{
        //用来实现轮播图
        TabView {
            ForEach(location.imageNames, id: \.self) {
                Image($0)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)//判断当前是在哪个设备上运行
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())//轮播图风格
    }
    
    private var titleSection: some View{
        VStack(alignment: .leading,spacing: 8) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(location.cityName)
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
    
    private var descriptionSection: some View{
        VStack(alignment: .leading,spacing: 16) {
            Text(location.description)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            if let url=URL(string: location.link){
                Link("Read more on Wikipeida",destination: url)//转跳链接
                    .font(.headline)
                    .tint(.blue)
            }
        }
    }
    
    private var mapLayer:some View{
        Map(coordinateRegion: .constant(
            MKCoordinateRegion(
                center: location.coordinates,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )),
            annotationItems: [location]) { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .shadow(radius: 10)
            }
        }
            .allowsHitTesting(false)//不允许移动/点击地图
            .aspectRatio(1, contentMode: .fit)//调整长宽比，并使得布局尽可能的适应尺寸
            .cornerRadius(30)
    }
    
    private var backButton:some View{
        Button {
            vm.sheetLocation = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }

    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(location: LocationsDataService.locations.first!)
            .environmentObject(LocationViewModel())
    }
}

