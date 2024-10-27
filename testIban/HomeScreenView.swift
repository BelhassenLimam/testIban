//
//  HomeScreenView.swift
//  testIban
//
//  Created by Belhassen LIMAM on 27/10/2024.
//

import SwiftUI

struct HomeScreenView: View {
    @StateObject private var viewModel = IBANViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Entrez ou scannez un IBAN", text: $viewModel.enteredIBAN)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(true)
            
            Button("Scanner un IBAN") {
                viewModel.startScanning()
            }
            .font(.title)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Spacer()
        }
        .sheet(isPresented: $viewModel.showScanner) {
            VStack {
                IBANScannerView(ibanScanController: viewModel.ibanScanController)
                
                if let detectedIBAN = viewModel.detectedIBAN {
                    VStack {
                        Text("IBAN détecté : \(detectedIBAN)")
                            .padding()
                        
                        HStack {
                            Button("Valider") {
                                viewModel.confirmIBAN()
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            
                            Button("Recommencer") {
                                viewModel.retryScan()
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom))
                }
            }
            .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    HomeScreenView()
}
