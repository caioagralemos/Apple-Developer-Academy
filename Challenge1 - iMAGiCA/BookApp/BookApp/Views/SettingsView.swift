import SwiftUI
import FamilyControls

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var focusManager = FocusManager.shared
    @State private var showingDeleteAlert = false
    @State private var hasScreenTimeAccess = false
    @State private var showingFamilyActivityPicker = false
    @State private var showingMusicCredits = false
    @State private var editingName = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        if hasScreenTimeAccess {
                            showingFamilyActivityPicker = true
                        } else {
                            requestFamilyControlsAuthorization()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "hourglass")
                                .foregroundColor(.primary)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Screen Time Configuration")
                                    .foregroundColor(.primary)
                                Text(hasScreenTimeAccess ? "Choose Screen Time Apps" : "Allow Screen Time Access")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.primary)
                            .frame(width: 24)
                        
                        Text("Name")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        TextField("Reader", text: $editingName)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.secondary)
                            .onChange(of: editingName) { oldValue, newValue in
                                let trimmed = newValue.trimmingCharacters(in: .whitespaces)
                                if !trimmed.isEmpty {
                                    UserDefaults.standard.set(trimmed, forKey: "name")
                                } else {
                                    UserDefaults.standard.set("Reader", forKey: "name")
                                }
                                dataManager.name = UserDefaults.standard.string(forKey: "name") ?? "Reader"
                            }
                    }

                    
                    Button {
                        showingMusicCredits = true
                    } label: {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.primary)
                                .frame(width: 24)
                            
                            Text("Music Credits")
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .frame(width: 24)
                            
                            Text("Delete All Data")
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(.second)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            checkScreenTimeAccess()
            self.editingName = UserDefaults.standard.string(forKey: "name") ?? "Reader"
        }
        .familyActivityPicker(isPresented: $showingFamilyActivityPicker, selection: $focusManager.activitySelection)
        .sheet(isPresented: $showingMusicCredits) {
            MusicCreditsView()
        }
        .alert("Delete All Data", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.clearAllData()
            }
        } message: {
            Text("This will permanently delete all your books and reading sessions. This action cannot be undone.")
        }
    }
    
    private func checkScreenTimeAccess() {
        hasScreenTimeAccess = AuthorizationCenter.shared.authorizationStatus == .approved
    }
    
    private func requestFamilyControlsAuthorization() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                await MainActor.run {
                    checkScreenTimeAccess()
                    if hasScreenTimeAccess {
                        showingFamilyActivityPicker = true
                    }
                }
            } catch {
                print("Failed to request Family Controls authorization")
            }
        }
    }
}
