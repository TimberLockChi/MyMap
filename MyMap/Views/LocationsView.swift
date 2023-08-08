//
//  LocationsView.swift
//  MyMap
//
//  Created by Chi Tim on 2023/8/8.
//

import SwiftUI
import MapKit



struct LocationsView: View {
    //获取环境变量,命名必须一致
    @EnvironmentObject private var vm : LocationViewModel

    var body: some View {
        ZStack{
            // 地图层
            mapLayer.ignoresSafeArea()
            // 控件层
            VStack(spacing: 0) {
                //头部标题栏
                header
                    .padding()
                Spacer()
                
                // 位置预览控件
                locationPreviewStack
            }
            
        }//如果在此添加.ignoresSafeArea()将会导致内部所有的组件上移，产生覆盖，因此只在背景View中添加ignoresSafeArea
        
    }
}

extension LocationsView{
    private var header:some View{
        VStack {
            Button {
                //动画加到ViewModel层不生效
                withAnimation(.spring()) {
                    vm.showLocationList.toggle()
                }
            } label: {
                Text(vm.mapLocation.name + "," + vm.mapLocation.cityName)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.mapLocation)//mapLocation发生变化时，通过动画进行调整
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .foregroundColor(.primary)
                            .padding()
                            //箭头旋转
                            .rotationEffect(Angle(degrees: vm.showLocationList ? 180 : 0))
                    }
            }
            if vm.showLocationList{
                LocationsListView()
            }
           
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow( color: Color.black.opacity(0.3),  radius: 20,x:0,y:15)
    }
    
    private var mapLayer:some View{
        Map(
            coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations,
            annotationContent: { location in
            //地图注标
            MapAnnotation(coordinate: location.coordinates) {
                //可定制marker
                LocationMapAnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7 )//缩放效果
                    .shadow(radius: 10)
                    .onTapGesture {
                        //点击注标切换位置
                        vm.showNextLocation(location: location)
                    }
            }
        })
    }
    
    private var locationPreviewStack:some View{
        ZStack{
            ForEach(vm.locations){location in
                if vm.mapLocation == location{
                    LocationPreviewView(location: location)
                        .shadow(color: Color.black.opacity(0.3), radius: 20)
                        .padding()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))//实现横移出入的效果
                }
            }
        }
    }
}


struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
            .environmentObject(LocationViewModel())
    }
}
