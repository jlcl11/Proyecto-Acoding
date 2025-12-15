//
//  SearchFiltersView.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import SwiftUI

struct SearchFiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var filtersViewModel: SearchFiltersViewModel

    let onApply: (CustomSearchDTO) -> Void

    var body: some View {
        NavigationStack {
            Form {
                // Text Search Section
                Section {
                    TextField("Título del manga", text: $filtersViewModel.searchTitle)
                        .textInputAutocapitalization(.words)

                    TextField("Nombre del autor", text: $filtersViewModel.searchAuthorFirstName)
                        .textInputAutocapitalization(.words)

                    TextField("Apellido del autor", text: $filtersViewModel.searchAuthorLastName)
                        .textInputAutocapitalization(.words)
                } header: {
                    Text("Búsqueda por Texto")
                } footer: {
                    Text("Busca por título o nombre del autor")
                }

                // Search Mode
                Section {
                    Toggle("Búsqueda parcial", isOn: $filtersViewModel.containsSearch)
                } footer: {
                    Text("Si está activado, buscará coincidencias parciales. Si está desactivado, buscará coincidencias exactas.")
                }

                // Genres
                Section {
                    ForEach(filtersViewModel.availableGenres) { genre in
                        MultiSelectionRow(
                            title: genre.rawValue,
                            isSelected: filtersViewModel.selectedGenres.contains(genre)
                        ) {
                            toggleGenreSelection(genre)
                        }
                    }
                } header: {
                    HStack {
                        Text("Géneros")
                        Spacer()
                        if !filtersViewModel.selectedGenres.isEmpty {
                            Text("(\(filtersViewModel.selectedGenres.count))")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }

                // Themes
                Section {
                    ForEach(filtersViewModel.availableThemes) { theme in
                        MultiSelectionRow(
                            title: theme.rawValue,
                            isSelected: filtersViewModel.selectedThemes.contains(theme)
                        ) {
                            toggleThemeSelection(theme)
                        }
                    }
                } header: {
                    HStack {
                        Text("Temáticas")
                        Spacer()
                        if !filtersViewModel.selectedThemes.isEmpty {
                            Text("(\(filtersViewModel.selectedThemes.count))")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }

                // Demographics
                Section {
                    ForEach(filtersViewModel.availableDemographics) { demo in
                        MultiSelectionRow(
                            title: demo.localizedName,
                            isSelected: filtersViewModel.selectedDemographics.contains(demo)
                        ) {
                            toggleDemographicSelection(demo)
                        }
                    }
                } header: {
                    HStack {
                        Text("Demografía")
                        Spacer()
                        if !filtersViewModel.selectedDemographics.isEmpty {
                            Text("(\(filtersViewModel.selectedDemographics.count))")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }

                // Reset Section
                if filtersViewModel.hasActiveFilters {
                    Section {
                        Button(role: .destructive) {
                            filtersViewModel.resetAllFilters()
                        } label: {
                            HStack {
                                Spacer()
                                Label("Limpiar todos los filtros", systemImage: "xmark.circle.fill")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filtros")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Aplicar") {
                        let searchDTO = filtersViewModel.createSearchDTO()
                        onApply(searchDTO)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func toggleGenreSelection(_ genre: GenreFilter) {
        if filtersViewModel.selectedGenres.contains(genre) {
            filtersViewModel.selectedGenres.remove(genre)
        } else {
            filtersViewModel.selectedGenres.insert(genre)
        }
    }

    private func toggleThemeSelection(_ theme: ThemeFilter) {
        if filtersViewModel.selectedThemes.contains(theme) {
            filtersViewModel.selectedThemes.remove(theme)
        } else {
            filtersViewModel.selectedThemes.insert(theme)
        }
    }

    private func toggleDemographicSelection(_ demographic: DemographicFilter) {
        if filtersViewModel.selectedDemographics.contains(demographic) {
            filtersViewModel.selectedDemographics.remove(demographic)
        } else {
            filtersViewModel.selectedDemographics.insert(demographic)
        }
    }
}

// MARK: - Multi-Selection Row

struct MultiSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundStyle(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.primary)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    SearchFiltersView(filtersViewModel: SearchFiltersViewModel()) { dto in
        print("Applied filters: \(dto)")
    }
}
