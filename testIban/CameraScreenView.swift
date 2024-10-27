//
//  CameraScreenView.swift
//  testIban
//
//  Created by Belhassen LIMAM on 27/10/2024.
//
import SwiftUI
import AVFoundation
import UIKit

struct IBANScannerView: UIViewControllerRepresentable {
    var ibanScanController: IBANScanController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: ibanScanController.captureSession!)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        viewController.view.layer.addSublayer(previewLayer)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame = UIScreen.main.bounds
        blurView.alpha = 0.7
        viewController.view.addSubview(blurView)
        
        let detectionFrame = UIView()
        detectionFrame.frame.size = CGSize(width: 300, height: 100)
        detectionFrame.center = viewController.view.center
        detectionFrame.layer.borderColor = UIColor.red.cgColor
        detectionFrame.layer.borderWidth = 2
        viewController.view.addSubview(detectionFrame)
        
        blurView.mask = createMaskView(inside: detectionFrame.frame, for: blurView.bounds)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    private func createMaskView(inside rect: CGRect, for bounds: CGRect) -> UIView {
        let path = UIBezierPath(rect: bounds)
        path.append(UIBezierPath(rect: rect).reversing())
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        let maskView = UIView(frame: bounds)
        maskView.layer.mask = maskLayer
        
        return maskView
    }
}
