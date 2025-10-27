import SwiftUI

struct MusicCreditsView: View {
    @Environment(\.dismiss) private var dismiss
    
    private func localizedGenreName(for genre: String) -> String {
        switch genre {
        case "Action Adventure":
            return String(localized: "musicCredit.actionAdventure")
        case "Historic":
            return String(localized: "musicCredit.historic")
        case "Lo-fi":
            return String(localized: "musicCredit.lofi")
        case "Fantasy":
            return String(localized: "musicCredit.fantasy")
        case "Sci-fi":
            return String(localized: "musicCredit.scifi")
        case "Horror":
            return String(localized: "musicCredit.horror")
        case "Piano":
            return String(localized: "musicCredit.piano")
        case "Biography":
            return String(localized: "musicCredit.biography")
        case "Non-fiction":
            return String(localized: "musicCredit.nonFiction")
        case "Poetry":
            return String(localized: "musicCredit.poetry")
        case "Drama":
            return String(localized: "musicCredit.drama")
        case "Fiction":
            return String(localized: "musicCredit.fiction")
        case "Comedy":
            return String(localized: "musicCredit.comedy")
        case "Kids":
            return String(localized: "musicCredit.kids")
        case "Spiritual":
            return String(localized: "musicCredit.spiritual")
        case "Education":
            return String(localized: "musicCredit.education")
        case "Comics":
            return String(localized: "musicCredit.comics")
        case "Forest":
            return String(localized: "musicCredit.forest")
        case "Rain":
            return String(localized: "musicCredit.rain")
        case "Wind":
            return String(localized: "musicCredit.wind")
        case "Mystery":
            return String(localized: "musicCredit.mystery")
        case "Personal Development":
            return String(localized: "musicCredit.personalDevelopment")
        case "Travel":
            return String(localized: "musicCredit.travel")
        default:
            return genre
        }
    }
    
    var body: some View {
        NavigationStack {
            List(MusicCredit.allCredits) { credit in
                HStack {
                    Text(localizedGenreName(for: credit.genre))
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(credit.shortURL) {
                        if let url = URL(string: credit.youtubeURL) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                    .truncationMode(.middle)
                }
                .padding(.vertical, 2)
            }
            .background(.second)
            .navigationTitle("Music Credits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}