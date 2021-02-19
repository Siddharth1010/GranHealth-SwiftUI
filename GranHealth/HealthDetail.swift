//
//  HealthDetail.swift
//  GranHealth
//
//  Created by MANI NAIR on 19/02/21.
//  Copyright © 2021 com.siddharthnair. All rights reserved.
//

import SwiftUI

struct HealthDetail: View {
    
    var health:Health
    
    @Binding var show:Bool
    @Binding var isActive:Bool
    var body: some View {
        
        List {
        ZStack(alignment: .bottom){
        Image(health.imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
            
        Rectangle()
            .frame(height: 80)
            .opacity(0.25)
            .blur(radius: 10)
            
            HStack{
                VStack(alignment: .leading, spacing: 8){
                    Text(health.name)
                    .foregroundColor(Color("Color"))
                        .font(.largeTitle)
                }
                .padding(.leading)
                .padding(.bottom)
                Spacer()
            }
            
        }
        .listRowInsets(EdgeInsets())
            
            VStack(alignment: .leading){
            Text(health.description)
                .foregroundColor(.primary)
                .font(.body)
                .lineLimit(nil)
                .lineSpacing(12)
                
                
                HStack{
                    
                    Spacer()
                    
                    Button(action: {}) {
                        
                        Text("View details")
                    }
                    .frame(width: 200, height: 50)
                    .background(Color("Color"))
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
                    
                    Spacer()
                }
                .padding(.top, 50)
                
            }
            .padding(.top)
            .padding(.bottom)
            
        
        }
//        .edgesIgnoringSafeArea(.top)
    .offset(y: -50)
    .navigationBarHidden(true)
        
    }
}

//struct HealthDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        HealthDetail(health: healthData[3])
//    }
//}
