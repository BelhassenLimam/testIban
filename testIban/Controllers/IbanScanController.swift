//
//  IbanScanController.swift
//  testIban
//
//  Created by Belhassen LIMAM on 27/10/2024.
//

import AVFoundation
import Vision

class IBANScanController: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var onIBANDetected: ((String) -> Void)?
    let textRecognitionRequest = VNRecognizeTextRequest()
    var captureSession: AVCaptureSession?

    override init() {
        super.init()
        configureTextRecognition()
    }

    private func configureTextRecognition() {
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.recognitionLanguages = ["fr", "en"]
        textRecognitionRequest.usesLanguageCorrection = true
    }

    func startCaptureSession() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }

        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoInput) else { return }

        captureSession.addInput(videoInput)

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        // Lancement de la session sur un thread en arrière-plan
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
    }

    func stopCaptureSession() {
        guard let captureSession = captureSession else { return }
        
        // Arrêt de la session sur un thread en arrière-plan
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.stopRunning()
        }

        self.captureSession = nil
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? requestHandler.perform([textRecognitionRequest])
        
        guard let observations = textRecognitionRequest.results else { return }
        
        for observation in observations {
            if let candidate = observation.topCandidates(1).first {
                let detectedText = candidate.string
                let ibanRegex = "[A-Z]{2}[0-9]{2}[A-Z0-9]{1,30}" // Regex pour l'IBAN
                
                if detectedText.range(of: ibanRegex, options: .regularExpression) != nil {
                    DispatchQueue.main.async {
                        self.onIBANDetected?(detectedText)
                        self.stopCaptureSession()
                    }
                    break
                }
            }
        }
    }
}
