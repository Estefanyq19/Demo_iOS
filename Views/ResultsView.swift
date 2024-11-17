//
//  ResultView.swift
//  app_visionKit
//
//  Created by MacOsX on 11/15/24.
//

import SwiftUI
import UniformTypeIdentifiers
import AVFoundation

struct ResultsView: View {
    @State private var scannedText: String = "No se ha seleccionado ningún archivo todavía."
    @State private var isFilePickerPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Texto escaneado:")
                .font(.headline)
            
            ScrollView {
                Text(scannedText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(maxHeight: 200)
            }
                Button(action: {
                    isFilePickerPresented = true
                }) {
                    Text("Seleccionar archivo")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    speakText()
                }) {
                    Text("Escuchar texto")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    saveText()
                }) {
                    Text("Guardar texto")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
        }
        .padding()
        .sheet(isPresented: $isFilePickerPresented) {
            FilePicker(scannedText: $scannedText)
        }
    }
    
    private func speakText() {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: scannedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        synthesizer.speak(utterance)
    }
    
    private func saveText() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = url.appendingPathComponent("TextoEscaneado.txt")
        
        do {
            try scannedText.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Texto guardado en \(fileURL.path)")
        } catch {
            print("Error al guardar el texto: \(error.localizedDescription)")
        }
    }
}

struct FilePicker: UIViewControllerRepresentable {
    @Binding var scannedText: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(scannedText: $scannedText)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image, UTType.plainText, UTType.pdf])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        @Binding var scannedText: String
        
        init(scannedText: Binding<String>) {
            _scannedText = scannedText
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            do {
                if url.pathExtension == "txt" {
                    scannedText = try String(contentsOf: url)
                } else {
                    scannedText = "Formato de archivo no soportado."
                }
            } catch {
                scannedText = "Error al leer el archivo: \(error.localizedDescription)"
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
