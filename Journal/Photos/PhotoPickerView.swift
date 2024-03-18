//
//  PhotoPickerView.swift
//  Journal
//
//  Created by Brandon Johns on 3/15/24.
//

import PhotosUI
import SwiftUI
import CoreImage

struct PhotoPickerView: View {
    @EnvironmentObject var dataController: DataController
    @State private var selectedImage: Image?
    @State private var selectedItem: PhotosPickerItem?
    @State private var inputImageSave: UIImage? = nil
    @ObservedObject var entry: Entry
    
    let context = CIContext()
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                PhotosPicker(selection: $selectedItem) {
                    if let selectedImage {
                        selectedImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                        
                        
                        
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                    
                }
                .onChange(of: selectedItem, loadImage)
                
                
                
            
            }
        }
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else {return}
            
            guard let inputImage = UIImage(data: imageData) else { return }
            
            
            
            selectedImage = Image(uiImage: inputImage)
          //  guard let inputImageSave = UIImage(data: imageData) else {return}
            
        
           // dataController.saveImage(image: inputImageSave)
        }
    }
    
    
    
    
    
}



//#Preview {
//    PhotoPickerView()
//}
