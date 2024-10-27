//
//  IbanViewModel.swift
//  testIban
//
//  Created by Belhassen LIMAM on 27/10/2024.
//
import SwiftUI

class IBANViewModel: ObservableObject {
    @Published var enteredIBAN: String = ""
    @Published var showScanner: Bool = false
    @Published var detectedIBAN: String? = nil
    
    var ibanScanController = IBANScanController()
    
    init() {
        ibanScanController.onIBANDetected = { [weak self] detectedIBAN in
            self?.detectedIBAN = detectedIBAN
        }
    }
    
    func startScanning() {
        detectedIBAN = nil
        showScanner = true
        ibanScanController.startCaptureSession()
    }
    
    func stopScanning() {
        ibanScanController.stopCaptureSession()
        showScanner = false
    }
    
    func confirmIBAN() {
        enteredIBAN = detectedIBAN ?? ""
        detectedIBAN = nil
        stopScanning()
    }
    
    func retryScan() {
        detectedIBAN = nil
        startScanning()
    }
}
