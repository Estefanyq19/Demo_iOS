//
//  SavedDocumentsView.swift
//  app_visionKit
//
//  Created by MacOsX on 11/15/24.
//

import SwiftUI
import AVFoundation

struct SavedDocumentsView: View {
    @State private var documentList: [URL] = []
    @State private var selectedDocumentText: String = "Selecciona un documento para ver su contenido."
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack {
            Text("Documentos guardados")
                .font(.headline)
                .padding(.bottom, 10)
            
            List {
                ForEach(documentList, id: \.self) { document in
                    HStack {
                        Text(document.lastPathComponent)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button(action: {
                            openDocument(document)
                        }) {
                            Image(systemName: "eye")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            deleteDocument(document)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            
            Text("Contenido del documento:")
                .font(.headline)
                .padding(.top, 10)
            
            ScrollView {
                Text(selectedDocumentText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(maxHeight: 200)
            }
            
            HStack {
                Button(action: playText) {
                    Label("Escuchar", systemImage: "speaker.wave.2.fill")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                .disabled(selectedDocumentText.isEmpty || selectedDocumentText == "Selecciona un documento para ver su contenido.")
            }
        }
        .padding()
        .onAppear(perform: loadDocuments)
    }
    
    /// Carga los documentos guardados en el directorio de documentos
    private func loadDocuments() {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            documentList = urls.filter { $0.pathExtension == "txt" }
        } catch {
            print("Error al cargar los documentos: \(error.localizedDescription)")
        }
    }
    
    /// Abre un documento y carga su contenido
    private func openDocument(_ document: URL) {
        do {
            let content = try String(contentsOf: document)
            selectedDocumentText = content
        } catch {
            selectedDocumentText = "Error al abrir el documento."
        }
    }
    
    /// Elimina un documento del directorio
    private func deleteDocument(_ document: URL) {
        do {
            try FileManager.default.removeItem(at: document)
            loadDocuments() // Recarga la lista de documentos
            selectedDocumentText = "Documento eliminado."
        } catch {
            print("Error al eliminar el documento: \(error.localizedDescription)")
        }
    }
    
    /// Reproduce el texto seleccionado en voz alta
    private func playText() {
        guard !selectedDocumentText.isEmpty else { return }
        
        let utterance = AVSpeechUtterance(string: selectedDocumentText)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES") // Cambiar el idioma si es necesario
        utterance.rate = 0.5 // Velocidad de la voz
        
        speechSynthesizer.speak(utterance)
    }
}

struct SavedDocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedDocumentsView()
    }
}
