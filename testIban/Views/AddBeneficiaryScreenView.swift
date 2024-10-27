//
//  AddBeneficiaryScreenView.swift
//  testIban
//
//  Created by Belhassen LIMAM on 27/10/2024.
//

import SwiftUI

struct AddBeneficiaryScreenView: View {
    @StateObject private var viewModel = IbanViewModel()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Scannez, importez ou saissez l'IBAN")
                    .foregroundColor(Color.white)
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.startScanning()
                    }) {
                        Label("Scanner", systemImage: "camera.fill")
                            .font(.headline)
                            .padding()
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                            .background(Color.clear)
                            .foregroundColor(Color.teal)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.teal, lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        showAlert = true
                    }) {
                        Label("Importez", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .padding()
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                            .background(Color.clear)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.teal)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.teal, lineWidth: 1)
                            )
                    }
                    .alert("Fonctionnalité en cours de développement", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                TextField("FR76 XXXX", text: $viewModel.enteredIBAN)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(true)
                
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .navigationTitle("Ajouter un bénéficiaire")
            .background(Color.black.opacity(0.85))
            .navigationBarTitleDisplayMode(.inline)
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
                            VStack(spacing: 20) {
                                Button {
                                    viewModel.confirmIBAN()
                                } label: {
                                    Text("Valider")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.teal)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }

                                Button {
                                    viewModel.retryScan()
                                } label: {
                                    Text("Recommencer")
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
                .background(Color.black.opacity(0.6).ignoresSafeArea())
            }
        }
    }
}

#Preview {
    AddBeneficiaryScreenView()
}
