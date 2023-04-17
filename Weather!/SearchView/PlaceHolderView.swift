//
//  PlaceHolderView.swift
//  Weather!
//
//  Created by Dave Piernick on 4/16/23.
//

import SwiftUI

struct PlaceHolderView: View {
    
    private var imagePadding: CGFloat = 100
    
    var body: some View {
        ZStack {
            Color.blue
            VStack {
                HStack {
                    Spacer(minLength: imagePadding)
                    Image(systemName: "cloud.sun.fill")
                        .symbolRenderingMode(.multicolor)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer(minLength: imagePadding)
                }
                Text("Weather!")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

            }
        }
        .ignoresSafeArea()
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct PlaceHolderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceHolderView()
    }
}
