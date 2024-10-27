//
//  HomeScreenView.swift
//  testIban
//
//  Created by Belhassen LIMAM on 27/10/2024.
//

import SwiftUI

struct HomeScreenView: View {
    @StateObject private var viewModel = IbanViewModel()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
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
                IbanScannerView(ibanScanController: viewModel.ibanScanController)
                
                if let detectedIBAN = viewModel.detectedIBAN {
                    VStack {
                        Text("L'IBAN du bénéficiaire a été scanné")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Pensez à le vérifier avant de valider :")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Text("\(detectedIBAN)")
                            .padding()
                            .font(.system(size: 18, weight: .medium, design: .monospaced))
                            .foregroundColor(.white)
                        HStack(spacing: 20) {
                            Button("Valider") {
                                viewModel.confirmIBAN()
                            }
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button("Recommencer") {
                                viewModel.retryScan()
                            }
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.clear)
                            .foregroundColor(Color.teal)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.teal, lineWidth: 1)
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black.opacity(0.85))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom))
                }
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
        }
    }
}

#Preview {
    HomeScreenView()
}
