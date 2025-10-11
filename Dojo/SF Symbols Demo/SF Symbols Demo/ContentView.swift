//
//  ContentView.swift
//  SF Symbols Demo
//
//  Created by Caio on 08/10/25.
//

import SwiftUI

struct SymbolPlaygroundView: View {
    // Controls
    @State private var animate = false
    @State private var size: CGFloat = 56
    @State private var mode: RenderMode = .mono

    // Data
    private let weights: [Font.Weight] = [.ultraLight,.regular,.black]
    private let weightNames: [Font.Weight:String] = [
        .ultraLight:"Ultralight", .regular:"Regular",
        .black:"Black"
    ]
    private let textStyles: [Font.TextStyle] = [.largeTitle,.title,.title2,.title3,.headline,.body,.callout,.footnote,.caption,.caption2]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Controls
                VStack(alignment: .leading, spacing: 12) {
                    Button {
                        animate.toggle()
                    } label: {
                        Text("Animate")
                    }
                    HStack {
                        Text("Size \(Int(size))")
                        Slider(value: $size, in: 24...120)
                    }
                }

                // Weights grid
                VStack(alignment: .leading, spacing: 12) {
                    Text("Weights").font(.headline)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                        ForEach(weights, id: \.self) { w in
                            VStack {
                                demoSymbol
                                    .font(.system(size: size, weight: w))
                                Text(weightNames[w] ?? "").font(.caption)
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(.quaternary.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }

                // Dynamic Type preview
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dynamic Type").font(.headline)
                    ForEach(textStyles, id: \.self) { style in
                        HStack(spacing: 12) {
                            demoSymbol.font(.system(style))
                            Text("\(style.description)")
                                .font(.system(style))
                        }
                    }
                }

                // Light / Dark blocks
                HStack(spacing: 16) {
                    colorBlock(.light, label: "Light")
                    colorBlock(.dark, label: "Dark")
                }
                .frame(height: 140)
            }
            .padding()
        }
    }

    // MARK: - Views

    private var demoSymbol: some View {
        Image("robot")
            .symbolRenderingMode(mode.symbolMode)
            .foregroundStyle(.primary)
            .symbolEffect(.bounce, options: .repeating, value: animate) // iOS 17+
    }

    private func colorBlock(_ scheme: ColorScheme, label: String) -> some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 12).fill(.background).shadow(radius: 2)
            demoSymbol.font(.system(size: size, weight: .regular)).padding()
            Text(label).font(.caption).padding(6)
        }
        .environment(\.colorScheme, scheme)
    }
}

// Picker helper (Hashable)
private enum RenderMode: String, CaseIterable, Hashable {
    case mono, hier, multi
    var symbolMode: SymbolRenderingMode {
        switch self {
        case .mono: return .monochrome
        case .hier: return .hierarchical
        case .multi: return .multicolor
        }
    }
}

// Pretty names for text styles
private extension Font.TextStyle {
    var description: String {
        switch self {
        case .largeTitle: return "Large Title"
        case .title: return "Title"
        case .title2: return "Title2"
        case .title3: return "Title3"
        case .headline: return "Headline"
        case .body: return "Body"
        case .callout: return "Callout"
        case .footnote: return "Footnote"
        case .caption: return "Caption"
        case .caption2: return "Caption2"
        default: return "\(self)"
        }
    }
}

#Preview { SymbolPlaygroundView() }
