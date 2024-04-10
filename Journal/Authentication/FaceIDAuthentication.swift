//
//  FaceIDAuthentication.swift
//  Journal
//
//  Created by Brandon Johns on 4/9/24.
//

import SwiftUI

struct FaceIDAuthentication: View {
    @StateObject var viewModel: ViewModel
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isUnlocked {
                NavigationSplitView {
                    MainView(dataController: viewModel.dataController)
                } content: {
                    ContentView(dataController: viewModel.dataController)
                } detail: {
                    DetailView()
                }
            } else  {
                Group {
                    VStack {
                        Text("Tap To Unlock")
                            .font(.custom("San Francisco", size: 40))
                        
                            .foregroundStyle(.red)
                            .font(.title)
                            .fontWeight(.heavy)
                        
                            .padding()
                        
                        Image(systemName: "lock.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(AngularGradient(colors: [.gray, .black, .gray, .black, .gray], center: .center))
                            .padding()
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(LinearGradient(colors: [.blue, .teal, .green, .gray ], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea())
                    
                }
                
                .onTapGesture(perform: viewModel.authenticate)
                .alert("Authentication error", isPresented: $viewModel.isShowingAuthenticationError) {
                    Button("OK") { }
                } message: {
                    Text(viewModel.authenticationError)
                }
            }
        }
        //.background(Gradient(colors: [])
    }
}

//#Preview {
//    FaceIDAuthentication()
//}
