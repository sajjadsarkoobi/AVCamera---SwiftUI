//
//  CameraService.swift
//  AVCamera
//
//  Created by Sajjad Sarkoobi on 22.12.2022.
//

import Foundation
import AVFoundation

class CameraService {
    
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    let outPut = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate: AVCapturePhotoCaptureDelegate, complition: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkForPermission(complition: complition)
    }
    
    private func checkForPermission(complition: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(complition: complition)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            DispatchQueue.main.async {
                self.setupCamera(complition: complition)
            }
        @unknown default:
            break
        }
    }
    
    private func setupCamera(complition: @escaping (Error?) -> ()) {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(outPut) {
                    session.addOutput(outPut)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
                
            } catch {
                complition(error)
            }
        }
    }
    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        outPut.capturePhoto(with: settings, delegate: delegate!)
    }
}
