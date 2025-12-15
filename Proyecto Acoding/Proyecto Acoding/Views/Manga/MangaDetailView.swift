//
//  MangaDetailView.swift
//  Proyecto Acoding
//
//  Created by Claude Code on 15/12/25.
//

import SwiftUI

struct MangaDetailView: View {
    let manga: Manga
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero section with cover
                    heroSection(width: geometry.size.width)

                    // Content
                    VStack(alignment: .leading, spacing: 24) {
                        // Title and metadata
                        titleSection

                        // Synopsis
                        synopsisSection

                        // Info section (compact)
                        infoSection

                        // Categories (tags)
                        if !manga.genres.isEmpty || !manga.themes.isEmpty {
                            categoriesSection
                        }

                        // Authors
                        if !manga.authors.isEmpty {
                            authorsSection
                        }

                        // Background info
                        if let background = manga.background, !background.isEmpty {
                            backgroundSection(background)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .ignoresSafeArea()
        }
        .background(Color(uiColor: .systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem() {
                Button {
                    // Add to list action
                } label: {
                    Image(systemName: "plus")
                }
            }

            ToolbarItem() {
                Button {
                    // Rate/favorite action
                } label: {
                    Image(systemName: "heart")
                }
            }
        }
    }

    // MARK: - Hero Section

    private func heroSection(width: CGFloat) -> some View {
        ZStack(alignment: .bottom) {
            // Cover image
            AsyncImage(url: manga.coverImageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: 500)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(width: width, height: 500)
                    .overlay {
                        VStack(spacing: 12) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 60))
                            ProgressView()
                        }
                        .foregroundStyle(.secondary)
                    }
            }

            // Gradient for readability
            LinearGradient(
                colors: [
                    .clear,
                    .clear,
                    Color(uiColor: .systemBackground).opacity(0.7),
                    Color(uiColor: .systemBackground)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 250)
        }

    }

    // MARK: - Title Section

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Main title
            Text(manga.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.primary)

            // Alternative title as subtitle
            if let altTitle = manga.japaneseTitle ?? manga.englishTitle {
                Text(altTitle)
                    .font(.system(size: 17))
                    .foregroundStyle(.secondary)
            }

            // Metadata row (Apple TV style - inline)
            HStack(spacing: 8) {
                if manga.score > 0 {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.yellow)
                        Text(manga.formattedScore)
                            .font(.system(size: 15, weight: .medium))
                    }
                }

                if manga.score > 0 {
                    Text("•")
                        .foregroundStyle(.secondary)
                }

                Text(manga.publicationPeriod)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)

                if let volumes = manga.totalVolumes {
                    Text("•")
                        .foregroundStyle(.secondary)

                    Text("\(volumes) tomos")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }

                Text("•")
                    .foregroundStyle(.secondary)

                Text(manga.status.displayName)
                    .font(.system(size: 15))
                    .foregroundStyle(manga.status.color)
            }
            .padding(.top, 4)
        }
        .padding(.top, 12)
    }

    // MARK: - Synopsis Section

    private var synopsisSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(manga.synopsis)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Info Section (Apple TV style)

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Géneros")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    if !manga.genres.isEmpty {
                        Text(manga.genreNames)
                            .font(.system(size: 15))
                            .foregroundStyle(.primary)
                    }
                }
                Spacer()
            }

            if !manga.authors.isEmpty {
                Divider()
                    .padding(.leading, 0)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(manga.authors.count > 1 ? "Autores" : "Autor")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                        Text(manga.authorNames)
                            .font(.system(size: 15))
                            .foregroundStyle(.primary)
                    }
                    Spacer()
                }
            }

            if let chapters = manga.totalChapters {
                Divider()

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Capítulos")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                        Text("\(chapters)")
                            .font(.system(size: 15))
                            .foregroundStyle(.primary)
                    }
                    Spacer()
                }
            }

            Divider()
        }
    }

    // MARK: - Authors Section (Simplified)

    private var authorsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Equipo Creativo")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.primary)

            ForEach(manga.authors) { author in
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(author.fullName)
                            .font(.system(size: 15))
                            .foregroundStyle(.primary)
                        Text(author.role.displayName)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: - Categories Section (Apple TV style tags)

    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !manga.themes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Temáticas")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)

                    TagsView(items: manga.themes.map { $0.name })
                }
            }

            if !manga.demographics.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Demografía")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)

                    TagsView(items: manga.demographics.map { $0.name })
                }
            }
        }
    }

    // MARK: - Background Section

    private func backgroundSection(_ background: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Más Información")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.primary)

            Text(background)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Supporting Views

/// Reusable tags view that displays pills horizontally and wraps to next line
struct TagsView: View {
    let items: [String]

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            FlowLayout(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    TagPill(text: item)
                }
            }
            Spacer(minLength: 0)
        }
    }
}

/// Individual tag pill component
struct TagPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 13))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(uiColor: .secondarySystemFill))
            .foregroundStyle(.primary)
            .clipShape(Capsule())
    }
}

/// Flow layout that wraps items to next line when they don't fit
struct FlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }

        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        var lineWidth: CGFloat = 0
        var lineHeight: CGFloat = 0

        for size in sizes {
            if lineWidth + size.width > proposal.width ?? 0 {
                totalHeight += lineHeight + spacing
                lineWidth = size.width
                lineHeight = size.height
            } else {
                lineWidth += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            totalWidth = max(totalWidth, lineWidth)
        }
        totalHeight += lineHeight

        return CGSize(width: totalWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var point = bounds.origin
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if point.x + size.width > bounds.maxX, point.x > bounds.minX {
                point.x = bounds.minX
                point.y += lineHeight + spacing
                lineHeight = 0
            }

            subview.place(at: point, proposal: .unspecified)

            point.x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        MangaDetailView(
            manga: Manga(
                id: 1,
                title: "One Piece",
                japaneseTitle: "ワンピース",
                englishTitle: "One Piece",
                score: 9.21,
                status: .publishing,
                startDate: Date(),
                endDate: Date(),
                totalChapters: 1100,
                totalVolumes: 106,
                synopsis: "Gol D. Roger, a man referred to as the 'Pirate King,' is set to be executed by the World Government. But just before his demise, he confirms the existence of a great treasure, One Piece, located somewhere within the vast ocean known as the Grand Line.",
                background: "One Piece is the best-selling manga series of all time.",
                coverImageURL: URL(string: "https://cdn.myanimelist.net/images/manga/2/253146.jpg"),
                externalURL: URL(string: "https://myanimelist.net/manga/13/One_Piece"),
                authors: [
                    Author(id: "1", firstName: "Eiichiro", lastName: "Oda", role: .storyAndArt)
                ],
                genres: [
                    Genre(id: "1", name: "Action"),
                    Genre(id: "2", name: "Adventure"),
                    Genre(id: "3", name: "Fantasy")
                ],
                themes: [
                    Theme(id: "1", name: "Pirates"),
                    Theme(id: "2", name: "Adventure")
                ],
                demographics: [
                    Demographic(id: "1", name: "Shounen")
                ]
            )
        )
    }
}
