//
//  TakePhotoView.swift
//  AVCamera
//
//  Created by Sajjad Sarkoobi on 22.12.2022.
//

import SwiftUI

struct TakePhotoView: View {
    
    @State var image: UIImage? = nil
    let cameraService: CameraService = CameraService()
    @State var takePhoto: Bool = false
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            } else {
                Text("Take photo")
            }
            
            VStack {
                Spacer()
                
                Button {
                    takePhoto.toggle()
                } label: {
                    Image(systemName: "camera")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(uiColor: .darkGray))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(.bottom)
            }
            .sheet(isPresented: $takePhoto) {
                CustomCameraCaptureView(capturedPhoto: $image, show: $takePhoto)
            }
            
        }
    }
}

struct TakePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        TakePhotoView()
    }
}
