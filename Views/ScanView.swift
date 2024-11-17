//
//  ScanView.swift
//  app_visionKit
//
//  Created by MacOsX on 11/15/24.
//

import SwiftUI
import Vision
import AVFoundation

struct ScanView: View {
    @State private var scannedText: String = "Aquí aparecerá el texto extraído."
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var savedDocuments: [String] = []
    private let speechSynthesizer = AVSpeechSynthesizer() // AVSpeechSynthesizer para sintetizar el texto en voz.

    var body: some View {
        VStack(spacing: 20) {
            Text("Texto escaneado:")
                .font(.headline)

            ScrollView {
                Text(scannedText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .frame(height: 200)
            
            // Aquí está el ícono de la cámara, que simula abrir la cámara
            Button(action: {
                // Simular que se abre la cámara (aunque usaremos la galería para el simulador)
                showImagePicker = true
            }) {
                Image(systemName: "camera.fill") // Ícono de la cámara
                    .font(.system(size: 40))
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
            
            HStack(spacing: 20) {
                Button("Escuchar texto") {
                    playScannedText()
                }
                .disabled(scannedText.isEmpty || scannedText == "Aquí aparecerá el texto extraído.")
                .padding()
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)

                Button("Guardar") {
                    saveScannedText()
                }
                .disabled(scannedText.isEmpty || scannedText == "Aquí aparecerá el texto extraído.")
                .padding()
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(8)
            }
            .padding(.top, 10)
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage, onImagePicked: processImage)
        }
    }

    /// Procesa la imagen seleccionada para extraer texto con VisionKit.
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            scannedText = "Error al cargar la imagen."
            return
        }

        // Usamos VisionKit para reconocer el texto en la imagen.
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                scannedText = "Error al procesar la imagen: \(error.localizedDescription)"
                return
            }

            // Procesa los resultados de texto extraído y lo muestra.
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let extractedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                DispatchQueue.main.async {
                    scannedText = extractedText.isEmpty ? "No se detectó texto en la imagen." : extractedText
                }
            }
        }

        do {
            try handler.perform([request])
        } catch {
            scannedText = "Error al realizar la solicitud de reconocimiento."
        }
    }

    /// Reproduce el texto escaneado en voz alta usando AVSpeechSynthesizer.
    private func playScannedText() {
        // Usamos AVSpeechSynthesizer para leer el texto en voz alta.
        let utterance = AVSpeechUtterance(string: scannedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        utterance.rate = 0.5 // Ajusta la velocidad de la voz.

        speechSynthesizer.speak(utterance)
    }

    /// Guarda el texto escaneado en la lista de documentos.
    private func saveScannedText() {
        savedDocuments.append(scannedText)
        scannedText = "Texto guardado correctamente."
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
