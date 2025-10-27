import Foundation

struct MusicCredit: Identifiable {
    let id = UUID()
    let genre: String
    let youtubeURL: String
    
    var shortURL: String {
        if let videoID = extractVideoID(from: youtubeURL) {
            return "https://youtu.be/\(videoID)"
        }
        return youtubeURL
    }
    
    private func extractVideoID(from url: String) -> String? {
        let patterns = [
            "(?:youtube\\.com/watch\\?v=|youtu\\.be/)([a-zA-Z0-9_-]{11})",
            "(?:youtube\\.com/embed/)([a-zA-Z0-9_-]{11})"
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: url, range: NSRange(url.startIndex..., in: url)) {
                let range = Range(match.range(at: 1), in: url)!
                return String(url[range])
            }
        }
        return nil
    }
}

extension MusicCredit {
    static let allCredits: [MusicCredit] = [
        MusicCredit(genre: "Action Adventure", youtubeURL: "https://www.youtube.com/watch?v=heS-eGCbyVk&list=RDheS-eGCbyVk&start_radio=1"),
        MusicCredit(genre: "Historic", youtubeURL: "https://www.youtube.com/watch?v=oh2u7aSxYIU&list=PLfP6i5T0-DkKU3x5JNjGZBXffi84I2nIt"),
        MusicCredit(genre: "Lo-fi", youtubeURL: "https://www.youtube.com/watch?v=DSWYAclv2I8&list=PLQwRmTwWx0ubcpv0SkHroupj1LqW5_Va5&index=1"),
        MusicCredit(genre: "Fantasy", youtubeURL: "https://www.youtube.com/watch?v=eZ_r1H9vHkI&list=PLnuhlOfdJ2WKvIu8eaF3uel9p3VjuK10M"),
        MusicCredit(genre: "Sci-fi", youtubeURL: "https://www.youtube.com/watch?v=2a-VL1VoHJ0&list=PL7-_Ltr8Xtuy90yqoxcvm_D_rZGHYQJ-3&index=1"),
        MusicCredit(genre: "Horror", youtubeURL: "https://www.youtube.com/watch?v=uQbzK4OROjQ&list=PLfP6i5T0-DkI74kb_BWxYNZRjIvF1D4Lp&index=3"),
        MusicCredit(genre: "Piano", youtubeURL: "https://www.youtube.com/watch?v=wuEU-GFx3AM&list=PLxtYnqeBFouSSGXjXgbsdpRAEyJGPMFjP&index=3"),
        MusicCredit(genre: "Biography", youtubeURL: "https://www.youtube.com/watch?v=4_R9l5Rac0E&list=PLxtYnqeBFouSSGXjXgbsdpRAEyJGPMFjP&index=5"),
        MusicCredit(genre: "Non-fiction", youtubeURL: "https://www.youtube.com/watch?v=BeQ8t9ZCnOI&list=RDBeQ8t9ZCnOI&start_radio=1"),
        MusicCredit(genre: "Poetry", youtubeURL: "https://www.youtube.com/watch?v=CHiLnKoBtsk&list=RDCHiLnKoBtsk&start_radio=1"),
        MusicCredit(genre: "Drama", youtubeURL: "https://www.youtube.com/watch?v=XQaNaFtI11Q&list=PLfP6i5T0-DkKt8eo7u222EnUO4N7Q3raT"),
        MusicCredit(genre: "Fiction", youtubeURL: "https://www.youtube.com/watch?v=8mdDft5-q28&list=PLfP6i5T0-DkKt8eo7u222EnUO4N7Q3raT&index=4"),
        MusicCredit(genre: "Comedy", youtubeURL: "https://www.youtube.com/watch?v=oGv9HD_k6b4&list=RDQMkG_EVRpgoPE&start_radio=1"),
        MusicCredit(genre: "Kids", youtubeURL: "https://www.youtube.com/watch?v=1y0wd-JgRZ4&list=PLzCxunOM5WFIEA9J1aC6fJOZFBFPGPFVV"),
        MusicCredit(genre: "Spiritual", youtubeURL: "https://www.youtube.com/watch?v=pM_yiZyC4dU"),
        MusicCredit(genre: "Education", youtubeURL: "https://www.youtube.com/watch?v=pBEdwmP8B4o&list=PLfP6i5T0-DkL0PYrS7c6oo1eYuKswXNNs"),
        MusicCredit(genre: "Comics", youtubeURL: "https://www.youtube.com/watch?v=XdfKUa16gmY&list=RDXdfKUa16gmY&start_radio=1"),
        MusicCredit(genre: "Forest", youtubeURL: "https://www.youtube.com/watch?v=1Z2u_KJzS0g&list=PLf-kQDdCmb1fM7l573YIK60Bg2VIrvb9F"),
        MusicCredit(genre: "Rain", youtubeURL: "https://www.youtube.com/watch?v=J6G0EuPAoKQ"),
        MusicCredit(genre: "Wind", youtubeURL: "https://www.youtube.com/watch?v=5jlUVr6gkos"),
        MusicCredit(genre: "Mystery", youtubeURL: "https://www.youtube.com/watch?v=-zvQoPyY2XE&list=RD-zvQoPyY2XE&start_radio=1"),
        MusicCredit(genre: "Personal Development", youtubeURL: "https://www.youtube.com/watch?v=J3VrtjFIy7U&list=RDJ3VrtjFIy7U&start_radio=1"),
        MusicCredit(genre: "Travel", youtubeURL: "https://www.youtube.com/watch?v=04Q_v2y1WEk&list=RD04Q_v2y1WEk&start_radio=1")
    ]
}