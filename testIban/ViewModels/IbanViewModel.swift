//
//  IbanViewModel.swift
//  testIban
//
//  Created by Belhassen LIMAM on 27/10/2024.
//
import SwiftUI

class IbanViewModel: ObservableObject {
    @Published var enteredIBAN: String = ""
    @Published var showScanner: Bool = false
    @Published var detectedIBAN: String? = nil
    
    var ibanScanController = IbanScanController()
    
    init() {
        ibanScanController.onIBANDetected = { [weak self] detectedIBAN in
            self?.detectedIBAN = detectedIBAN
            self?.ibanScanController.captureSession?.stopRunning()
        }
    }
    
    func startScanning() {
        detectedIBAN = nil
        showScanner = true
        ibanScanController.startCaptureSession()
    }
    
    func stopScanning() {
        showScanner = false
        ibanScanController.stopCaptureSession()
    }
    
    func confirmIBAN() {
        enteredIBAN = detectedIBAN ?? ""
        detectedIBAN = nil
        stopScanning()
    }
    
    func retryScan() {
        detectedIBAN = nil
        showScanner = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.ibanScanController.captureSession?.startRunning()
        }
    }
}
