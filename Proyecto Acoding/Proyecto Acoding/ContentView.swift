//
//  ContentView.swift
//  Proyecto Acoding
//
//  Created by José Luis Corral López on 15/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = MangasViewModel()

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    Text("Toca para cargar mangas")
                        .foregroundStyle(.secondary)

                case .loading:
                    ProgressView("Cargando mangas...")

                case .loaded:
                    List {
                        ForEach(viewModel.mangas) { manga in
                            NavigationLink {
                                MangaDetailView(manga: manga)
                            } label: {
                                MangaRow(manga: manga)
                            }
                        }

                        if viewModel.hasMorePages {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .task {
                                        await viewModel.loadNextPage()
                                    }
                                Spacer()
                            }
                        }
                    }
                    .listStyle(.plain)

                case .error(let message):
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
                                await viewModel.refresh()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()

                case .empty:
                    Text("No hay mangas disponibles")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Mis Mangas")
        }
        .task {
            if viewModel.state == .idle {
                await viewModel.loadMangas()
            }
        }
    }
}

struct MangaRow: View {
    let manga: Manga

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Placeholder para la imagen
            AsyncImage(url: manga.coverImageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "book.closed")
                            .foregroundStyle(.secondary)
                    }
            }
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(manga.title)
                    .font(.headline)
                    .lineLimit(2)

                if !manga.authors.isEmpty {
                    Text(manga.authorNames)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                HStack {
                    if manga.score > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text(manga.formattedScore)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }

                    if !manga.demographics.isEmpty {
                        Text(manga.demographics.first?.name ?? "")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }

                if !manga.genres.isEmpty {
                    Text(manga.genreNames)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
}
