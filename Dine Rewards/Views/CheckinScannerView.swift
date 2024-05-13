//
//  CheckinScannerView.swift
//  Dine Rewards
//
//  Created by Ba Toan Nguyen on 12/5/24.
//

import SwiftUI
import AVFoundation

struct CheckinScannerView: UIViewControllerRepresentable {
    var phoneNumber: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = CheckinScannerViewController(phoneNumber: phoneNumber)
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

class CheckinScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var viewModel = RestaurantViewModel()
    var phoneNumber: String

    init(phoneNumber: String) {
            self.phoneNumber = phoneNumber
            super.init(nibName: nil, bundle: nil)
            self.commonInit()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func commonInit() {
            view.backgroundColor = UIColor.black
            setupScanning()
        }

        override func viewDidLoad() {
            super.viewDidLoad()
        }

    func setupScanning() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession?.canAddInput(videoInput) ?? false) {
            captureSession?.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession?.canAddOutput(metadataOutput) ?? false) {
            captureSession?.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.frame = view.layer.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)

        captureSession?.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()

        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            guard let stringValue = metadataObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            processQRCodeData(qrData: stringValue)
            dismiss(animated: true)
        }
    }
    
    private func processQRCodeData(qrData: String) {
        guard let data = qrData.data(using: .utf8),
              let jsonData = try? JSONDecoder().decode(Restaurant.self, from: data) else {
            print("Error decoding JSON")
            return
        }

        let newRestaurant = jsonData

        viewModel.updateCheckin(restaurantId: newRestaurant.id, phone: phoneNumber)

        // Potentially notify via NotificationCenter or another method to update the UI
        NotificationCenter.default.post(name: NSNotification.Name("UpdateUI"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning ?? false) {
            captureSession?.stopRunning()
        }
    }
}

