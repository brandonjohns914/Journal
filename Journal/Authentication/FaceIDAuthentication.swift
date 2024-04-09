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
        if viewModel.isUnlocked {
            NavigationSplitView {
                MainView(dataController: viewModel.dataController)
            } content: {
                ContentView(dataController: viewModel.dataController)
            } detail: {
                DetailView()
            }
        } else  {
            Button("Unlock Journal", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
                .alert("Authentication error", isPresented: $viewModel.isShowingAuthenticationError) {
                    Button("OK") { }
                } message: {
                    Text(viewModel.authenticationError)
                }
        }
    }
}

//#Preview {
//    FaceIDAuthentication()
//}
