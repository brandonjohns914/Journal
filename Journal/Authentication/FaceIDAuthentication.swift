//
//  FaceIDAuthentication.swift
//  Journal
//
//  Created by Brandon Johns on 4/9/24.
//

import SwiftUI

struct FaceIDAuthentication: View {
    @StateObject var viewModel: ViewModel
    @State private var unlocked = false
    
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
                        Button("Unlock Reflect", systemImage: "lock.shield", action: viewModel.authenticate)
                        .symbolEffect(.bounce.down, value: unlocked)
                        .font(.largeTitle)
                        .foregroundStyle(.primary)
                        
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
