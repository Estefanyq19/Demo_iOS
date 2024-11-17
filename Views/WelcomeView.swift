//
//  WelcomeView.swift
//  app_visionKit
//
//  Created by MacOsX on 11/15/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 20){
            Text("Bienvenida/o a ScanSpeak.")
                .font(.title)
                .multilineTextAlignment(.center)
            Text("Tu soluciòn de escaneo y reconocimiento de audio en un solo lugar")
                .font(.headline)
                .multilineTextAlignment(.center)
            NavigationLink(destination: ScanView()){
                Text("Escanear")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
            NavigationLink(destination: ResultsView()){
                Text("Seleccionar Documento")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
            NavigationLink(destination: SavedDocumentsView()){
                Text("Documentos Guardados")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
