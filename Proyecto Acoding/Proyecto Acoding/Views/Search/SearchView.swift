//
//  SearchView.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var viewModel = SearchViewModel()
    @State private var filtersViewModel = SearchFiltersViewModel()
    @State private var searchTask: Task<Void, Never>?
    @State private var showFilters = false

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    emptySearchState

                case .loading where viewModel.searchResults.isEmpty:
                    ProgressView("Buscando...")

                case .loaded:
                    searchResultsList

                case .empty:
                    noResultsState

                case .error(let message):
                    errorState(message: message)

                default:
                    searchResultsList
                }
            }
            .navigationTitle("Buscar")
            .searchable(text: $searchText, prompt: "Buscar manga...")
            .onChange(of: searchText) { _, newValue in
                performSearch(query: newValue)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFilters = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.title3)

                            if filtersViewModel.hasActiveFilters {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 4, y: -4)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                SearchFiltersView(filtersViewModel: filtersViewModel) { searchDTO in
                    applyFilters(searchDTO)
                }
            }
        }
    }

    // MARK: - Empty Search State

    private var emptySearchState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("Buscar Manga")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Encuentra tus mangas favoritos")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    // MARK: - Search Results List

    private var searchResultsList: some View {
        List {
            ForEach(viewModel.searchResults) { manga in
                NavigationLink {
                    MangaDetailView(manga: manga)
                } label: {
                    MangaRow(manga: manga)
                }
            }

            // Pagination loader
            if viewModel.hasMorePages {
                HStack {
                    Spacer()
                    ProgressView()
                        .task {
                            await viewModel.loadNextPage(query: searchText)
                        }
                    Spacer()
                }
            }
        }
        .listStyle(.plain)
    }

    // MARK: - No Results State

    private var noResultsState: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("No se encontraron resultados")
                .font(.title3)
                .fontWeight(.semibold)
            Text("Intenta buscar con otros términos")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    // MARK: - Error State

    private func errorState(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.red)
            Text("Error")
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Reintentar") {
                Task {
                    await viewModel.search(query: searchText)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    // MARK: - Search Logic

    private func performSearch(query: String) {
        // Cancel previous search task
        searchTask?.cancel()

        // If query is empty, reset
        guard !query.isEmpty else {
            viewModel.reset()
            return
        }

        // Debounce: wait 0.5 seconds before searching
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

            guard !Task.isCancelled else { return }

            await viewModel.search(query: query)
        }
    }

    private func applyFilters(_ searchDTO: CustomSearchDTO) {
        // Clear search text when using filters
        searchText = ""

        // Cancel any pending search
        searchTask?.cancel()

        // Perform search with filters
        Task {
            await viewModel.searchWithDTO(searchDTO)
        }
    }
}

#Preview {
    SearchView()
}
