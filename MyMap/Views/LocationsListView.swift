//
//  LocationsListView.swift
//  MyMap
//
//  Created by Chi Tim on 2023/8/8.
//

import SwiftUI

struct LocationsListView: View {
    
    @EnvironmentObject private var vm:LocationViewModel
    
    
    var body: some View {
        List{
            ForEach(vm.locations){ location in
                Button{
                    vm.showNextLocation(location: location)
                }label: {
                    listRowView(location: location)
                }
                .padding(.vertical,4)
                .listRowBackground(Color.clear)//透明背景
            }
        }
        .scaledToFit()//防止下滑列表过长出现空白
        .listStyle(PlainListStyle())
    }
}

extension LocationsListView{
    
    private func listRowView(location:Location)->some View{
        HStack{
            //如果存在图片
            if let imageName = location.imageNames.first{
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45,height: 45)
                    .cornerRadius(10)
            }
            VStack(alignment: .leading){
                Text(location.name)
                    .font(.headline)
                Text(location.cityName)
                    .font(.subheadline)
            }
            .frame(maxWidth:.infinity,alignment: .leading)
        }
    }
}

struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
            .environmentObject(LocationViewModel())
    }
}
