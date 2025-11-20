//
//  OnboardingModalView.swift
//  Rabisco
//
//  Created by Caio on 15/11/25.
//

import SwiftUI
import SwiftUINavigationTransitions

struct ArtistView: View {
    let artist: Artist?
    let onClickEdit: (Artist) -> Void
    let onClickTrash: (Artist) -> Void
    let onClickAdd: () -> Void
    
    init(
        artist: Artist? = nil,
        onClickEdit: @escaping (Artist) -> Void = { _ in },
        onClickTrash: @escaping (Artist) -> Void = { _ in },
        onClickAdd: @escaping () -> Void = {}
    ) {
        self.artist = artist
        self.onClickEdit = onClickEdit
        self.onClickTrash = onClickTrash
        self.onClickAdd = onClickAdd
    }
    
    var body: some View {
        if let artist = artist {
            VStack {
                Image("is-there")
                    .resizable()
                    .frame(width: 70, height: 85)
                    .padding(.bottom, -2)
                
                Text(artist.name)
                    .font(.custom("Baby Doll", size: 18))
                    .foregroundStyle(.black)
                
                HStack {
                    Button {
                        SoundManager.shared.play(.click)
                        onClickEdit(artist)
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 13))
                            .foregroundStyle(.black)
                    }
                    
                    Button {
                        SoundManager.shared.play(.click)
                        onClickTrash(artist)
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 12))
                            .foregroundStyle(.black)
                    }
                }
            }
            .frame(width: 100, height: 120)
        } else {
            Button {
                SoundManager.shared.play(.click)
                onClickAdd()
            } label: {
                VStack {
                    Image("not-there")
                        .resizable()
                        .frame(width: 70, height: 85)
                        .padding(.bottom, -2)
                    
                    Text("Tap to add")
                        .font(.custom("Baby Doll", size: 18))
                        .foregroundStyle(.black)
                    
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 13))
                                .foregroundStyle(.black)
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 12))
                                .foregroundStyle(.black)
                        }
                    }
                    .opacity(artist != nil ? 1 : 0.6)
                    .disabled(artist == nil)
                }
            }
            .frame(width: 100, height: 120)
        }
    }
}

struct OnboardingArtistsModalView: View {
    let artist: Artist?
    @Binding var currentModal: Bool
    @ObservedObject var artistManager: ArtistManager
    @State var artistName: String
    @State var artistTopic: ArtistTopic
    @FocusState private var isFocused: Bool
    
    init(artist: Artist? = nil, currentModal: Binding<Bool>, artistManager: ArtistManager, artistName: String = "", artistTopic: ArtistTopic = .Random) {
        self.artist = artist
        self._currentModal = currentModal
        self.artistManager = artistManager
        self.artistName = artist?.name ?? artistName
        self.artistTopic = artist?.favoriteTopic ?? artistTopic
    }
    
    var body: some View {
        VStack(spacing: 40) {
            HStack {
                Button {
                    SoundManager.shared.play(.click)
                    isFocused = false
                    currentModal = false
                } label: {
                    Circle()
                        .stroke(lineWidth: 4)
                        .foregroundStyle(.black)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text("<")
                                .foregroundStyle(.black)
                                .font(.custom("Baby Doll", size: 36))
                                .padding(.top, 5)
                        )
                }
                
                Spacer()
                
                Button {
                    SoundManager.shared.play(.click)
                    if let artistToEdit = artist {
                        artistManager.updateArtist(artistToEdit, newName: artistName, newTopic: artistTopic)
                    } else {
                        artistManager.addArtist(name: artistName, favoriteTopic: artistTopic)
                    }
                    currentModal = false
                } label: {
                    Circle()
                        .stroke(lineWidth: 4)
                        .foregroundStyle(.black)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image("tick")
                                .resizable()
                                .frame(width: 16, height: 22)
                        )
                        .opacity(artistName.isEmpty ? 0.6 : 1.0)
                }
                .disabled(artistName.isEmpty)
            }
            .frame(maxWidth: 400)
            .padding(.bottom, -20)
            
            VStack(spacing: 20) {
                Text("Name")
                    .foregroundStyle(.black)
                    .font(.custom("Baby Doll", size: 36))
                
                
                RoundedRectangle(cornerRadius: 30)
                    .stroke(lineWidth: 5)
                    .foregroundStyle(.black)
                    .frame(width: 360, height: 50)
                    .overlay(
                        TextField("eg. Pablo Picasso", text: $artistName)
                            .padding(.leading)
                            .foregroundStyle(.black)
                            .font(.custom("Baby Doll", size: 24))
                            .focused($isFocused)
                            .onChange(of: artistName) { _, newValue in
                                if newValue.count > 12 {
                                    artistName = String(newValue.prefix(12))
                                }
                            }
                    )
                    
            }
            
            VStack(spacing: 25) {
                Text("Favorite Topic")
                    .foregroundStyle(.black)
                    .font(.custom("Baby Doll", size: 36))
                
                HStack(spacing: 30) {
                    Button {
                        SoundManager.shared.play(.click)
                        isFocused = false
                        withAnimation {
                            artistTopic = .Food
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(lineWidth: 5)
                            .foregroundStyle(.black)
                            .frame(width: 160, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(artistTopic == .Food ? Color.black.opacity(0.1) : Color.clear)
                            )
                            .overlay(
                                HStack {
                                    Text("Food")
                                        .foregroundStyle(.black)
                                        .font(.custom("Baby Doll", size: 20))
                                        .padding(.top, 5)
                                    Image(systemName: "carrot")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 18))
                                }
                            )
                    }
                    
                    Button {
                        SoundManager.shared.play(.click)
                        isFocused = false
                        withAnimation {
                            artistTopic = .Animals
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(lineWidth: 5)
                            .foregroundStyle(.black)
                            .frame(width: 160, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(artistTopic == .Animals ? Color.black.opacity(0.1) : Color.clear)
                            )
                            .overlay(
                                HStack {
                                    Text("Animals")
                                        .foregroundStyle(.black)
                                        .font(.custom("Baby Doll", size: 20))
                                        .padding(.top, 5)
                                    Image(systemName: "pawprint")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 18))
                                }
                            )
                    }
                }
                
                HStack(spacing: 30) {
                    Button {
                        SoundManager.shared.play(.click)
                        isFocused = false
                        withAnimation {
                            artistTopic = .Objects
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(lineWidth: 5)
                            .foregroundStyle(.black)
                            .frame(width: 160, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(artistTopic == .Objects ? Color.black.opacity(0.1) : Color.clear)
                            )
                            .overlay(
                                HStack {
                                    Text("Objects")
                                        .foregroundStyle(.black)
                                        .font(.custom("Baby Doll", size: 20))
                                        .padding(.top, 2)
                                    Image(systemName: "volleyball")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 18))
                                }
                            )
                    }
                    
                    Button {
                        SoundManager.shared.play(.click)
                        isFocused = false
                        withAnimation {
                            artistTopic = .Places
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(lineWidth: 5)
                            .foregroundStyle(.black)
                            .frame(width: 160, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(artistTopic == .Places ? Color.black.opacity(0.1) : Color.clear)
                            )
                            .overlay(
                                HStack {
                                    Text("Places")
                                        .foregroundStyle(.black)
                                        .font(.custom("Baby Doll", size: 20))
                                        .padding(.top, 5)
                                    Image(systemName: "location")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 18))
                                }
                            )
                    }
                }
                
                HStack(spacing: 30) {
                    Button {
                        SoundManager.shared.play(.click)
                        isFocused = false
                        withAnimation {
                            artistTopic = .Pop
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(lineWidth: 5)
                            .foregroundStyle(.black)
                            .frame(width: 160, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(artistTopic == .Pop ? Color.black.opacity(0.1) : Color.clear)
                            )
                            .overlay(
                                HStack {
                                    Text("Pop")
                                        .foregroundStyle(.black)
                                        .font(.custom("Baby Doll", size: 20))
                                        .padding(.top, 5)
                                    Image(systemName: "movieclapper")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 18))
                                }
                            )
                    }
                    
                    Button {
                        SoundManager.shared.play(.click)
                        isFocused = false
                        withAnimation {
                            artistTopic = .Random
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(lineWidth: 5)
                            .foregroundStyle(.black)
                            .frame(width: 160, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(artistTopic == .Random ? Color.black.opacity(0.1) : Color.clear)
                            )
                            .overlay(
                                HStack {
                                    Text("Random")
                                        .foregroundStyle(.black)
                                        .font(.custom("Baby Doll", size: 20))
                                        .padding(.top, 5)
                                    Image(systemName: "dice")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 18))
                                }
                            )
                    }
                }
            }
        }
        .padding(.bottom, 100)
    }
}


struct OnboardingModalView: View {
    @Binding var exitModal: Bool
    @StateObject private var artistManager = ArtistManager()
    @State var addingArtist = false
    @State var editingArtist = false
    @State var artistToEdit: Artist? = nil
    @State var artistName = ""
    @State var artistTopic = ArtistTopic.Random
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.7)
                .onTapGesture {
                    withAnimation {
                        exitModal = false
                    }
                }
            
            ZStack {
                Image("frame")
                    .resizable()
                    .frame(width: 610, height: 820)
                VStack {
                    if !addingArtist && artistToEdit == nil {
                        VStack(spacing: 10) {
                            Image("logo-dark")
                                .resizable()
                                .frame(width: 120, height: 30)
                            
                            Text("A collaborative drawing experience.\n3 phases, shared creativity.")
                                .font(.custom("Baby Doll", size: 21))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                            
                            HStack(spacing: 30) {
                                VStack {
                                    Image(systemName: "pencil.and.outline")
                                        .font(.system(size: 48))
                                    Text("Create the base")
                                }
                                
                                VStack {
                                    Image(systemName: "pencil.tip")
                                        .font(.system(size: 56))
                                    Text("Build the form")
                                }
                                
                                VStack {
                                    Image(systemName: "paintpalette")
                                        .font(.system(size: 52))
                                    Text("Bring it to life")
                                }
                            }
                            .font(.custom("Baby Doll", size: 14))
                            .foregroundStyle(.black)
                        }
                        .padding(.bottom, 20)
                        
                        VStack {
                            VStack(spacing: -3) {
                                Text("Artists")
                                    .font(.custom("Baby Doll", size: 36))
                                    .foregroundStyle(.black)
                                Text("Pick 3-6 people")
                                    .font(.custom("Baby Doll", size: 18))
                                    .foregroundStyle(.black)
                            }
                            
                            HStack(spacing: 30) {
                                ForEach(0..<3, id: \.self) { index in
                                    if index < artistManager.artists.count {
                                        ArtistView(
                                            artist: artistManager.artists[index],
                                            onClickEdit: handleEditArtist,
                                            onClickTrash: handleDeleteArtist
                                        )
                                    } else if artistManager.canAddMoreArtists {
                                        ArtistView(onClickAdd: handleAddArtist)
                                            .opacity(0.6)
                                    }
                                }
                            }
                            
                            HStack(spacing: 30) {
                                ForEach(3..<6, id: \.self) { index in
                                    if index < artistManager.artists.count {
                                        ArtistView(
                                            artist: artistManager.artists[index],
                                            onClickEdit: handleEditArtist,
                                            onClickTrash: handleDeleteArtist
                                        )
                                    } else if artistManager.canAddMoreArtists {
                                        ArtistView(onClickAdd: handleAddArtist)
                                            .opacity(0.6)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 30)
                        
                        VStack {
                            NavigationLink {
                                if artistManager.artists.count >= 3 {
                                    ExperienceView(experience: Experience(artists: artistManager.artists, type: .Local))
                                        .preferredColorScheme(.light)
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(lineWidth: 5)
                                    .foregroundStyle(.black)
                                    .frame(width: 200, height: 60)
                                    .overlay(
                                        Text("Start")
                                            .foregroundStyle(.black)
                                            .font(.custom("Baby Doll", size: 40))
                                    )
                                    .opacity(artistManager.artists.count >= 3 ? 1.0 : 0.6)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                if artistManager.artists.count >= 3 {
                                    SoundManager.shared.play(.click)
                                }
                            })
                            .navigationTransition(.fade(.in))
                            .disabled(artistManager.artists.count < 3)
                        }
                    } else if addingArtist {
                        OnboardingArtistsModalView(
                            currentModal: $addingArtist,
                            artistManager: artistManager
                        )
                    } else if editingArtist, let artistToEdit = artistToEdit {
                        OnboardingArtistsModalView(
                            artist: artistToEdit,
                            currentModal: $editingArtist,
                            artistManager: artistManager
                        )
                    }
                }
            }
        }
        .onChange(of: addingArtist) { _, newValue in
            if !newValue {
                resetModalState()
            }
        }
        .onChange(of: editingArtist) { _, newValue in
            if !newValue {
                resetModalState()
            }
        }
    }
    
    func resetModalState() {
        artistToEdit = nil
        artistName = ""
        artistTopic = .Random
    }
    
    func handleAddArtist() {
        guard artistManager.canAddMoreArtists else { return }
        withAnimation {
            addingArtist = true
        }
    }
    
    func handleEditArtist(artist: Artist) {
        withAnimation {
            artistToEdit = artist
            editingArtist = true
        }
    }
    
    func handleDeleteArtist(artist: Artist) {
        withAnimation {
            artistManager.deleteArtist(artist)
        }
    }
}

