//
//  CustomCameraCaptureView.swift
//  AVCamera
//
//  Created by Sajjad Sarkoobi on 22.12.2022.
//

import SwiftUI

struct CustomCameraCaptureView: View {
    
    @Binding var capturedPhoto: UIImage?
    @Binding var show: Bool
    let cameraService: CameraService = CameraService()
    
    var body: some View {
        ZStack {
            CameraView(cameraService: cameraService) { result in
                switch result {
                case .success(let photoData):
                    if let data = photoData.fileDataRepresentation(),
                       let image = UIImage(data: data) {
                        capturedPhoto = image
                    } else {
                        print("Can not convert photo from data")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                show.toggle()
            }
            
            VStack {
                Spacer()
                
                Button {
                    cameraService.capturePhoto()
                } label: {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 60, height: 60, alignment: .center)
                }
                .padding(.bottom)
            }
        }
    }
}
