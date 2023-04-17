//
//  WeatherView.swift
//  Weather!
//
//  Created by Dave Piernick on 4/16/23.
//

import Foundation
import SwiftUI

struct WeatherView: View {

    @ObservedObject var viewModel: WeatherViewModel
    var imagePadding: CGFloat = 100
    
    init(location: Location) {
        self.viewModel = WeatherViewModel(location: location)
    }
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack {
                Text(String.locationDisplayString(viewModel.location))
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Text(viewModel.weather?.weather?.first?.description?.capitalized ?? "--")
                    .padding(.top)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                HStack {
                    Spacer(minLength: imagePadding)
                    Image(uiImage: viewModel.image ?? UIImage(systemName: "questionmark")!)
                        .symbolRenderingMode(.multicolor)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer(minLength: imagePadding)
                }
                

                
                HStack(alignment: .bottom) {
                    VStack {
                        Text("\(viewModel.weather?.temp?.temp_min?.rounded().formatted() ?? "--")˚")
                            .padding(.bottom)
                        Text("Min")
                    }
                    
                    VStack {
                        Text("\(viewModel.weather?.temp?.temp?.rounded().formatted() ?? "--")˚")
                            .padding(.top)
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .padding(.leading, 45.0)
                        Text("Current")
                    }
                    
                    VStack {
                        Text("\(viewModel.weather?.temp?.temp_max?.rounded().formatted() ?? "--")˚")
                            .padding(.bottom)
                        Text("Max")
                    }
                    
                }

                
                Spacer()
                
                HStack(spacing: 100) {
                    VStack {
                        Image(systemName: "sunrise.fill")
                            .symbolRenderingMode(.multicolor)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Text(viewModel.sunriseTime())
                    }
                    
                    VStack {
                        Image(systemName: "sunset.fill")
                            .symbolRenderingMode(.multicolor)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)

                        Text(viewModel.sunsetTime())
                    }
                }
                
                Spacer()
            }
            .font(.system(size: 25, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding([.leading, .trailing])
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(location: MockWeather.loc)
    }
}

struct MockWeather {
    static var loc = Location(name: "Detroit", state: "MI", country: "USA", lat: 42, lon: 85)
}
