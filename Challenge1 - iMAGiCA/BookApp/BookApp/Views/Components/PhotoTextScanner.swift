//
//  PhotoTextScanner.swift
//  Tests
//
//  Created by Caio on 14/10/25.
//


import Vision
import VisionKit
import SwiftUI

struct PhotoTextScanner: UIViewControllerRepresentable {
    @Binding var text: String
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = context.coordinator
        return vc
    }
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: PhotoTextScanner
        init(_ parent: PhotoTextScanner) { self.parent = parent }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController,
                                          didFinishWith scan: VNDocumentCameraScan) {
            guard scan.pageCount > 0 else { controller.dismiss(animated: true); return }
            let img = scan.imageOfPage(at: 0)
            recognize(img) { self.parent.text = $0; controller.dismiss(animated: true) }
        }

        private func recognize(_ image: UIImage, completion: @escaping (String)->Void) {
            let req = VNRecognizeTextRequest { req, _ in
                let lines = (req.results as? [VNRecognizedTextObservation])?
                    .compactMap { $0.topCandidates(1).first?.string } ?? []
                completion(lines.joined(separator: "\n"))
            }
            req.recognitionLevel = .accurate
            req.usesLanguageCorrection = true
            req.recognitionLanguages = ["pt-BR","en-US","it-IT"]

            let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
            try? handler.perform([req])
        }
    }
}
