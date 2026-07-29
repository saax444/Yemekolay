import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            Circle()
                .fill(Color.orange.opacity(0.16))
                .frame(width: 330, height: 330)
                .blur(radius: 70)
                .offset(x: 150, y: -290)
            Circle()
                .fill(Color.yellow.opacity(0.09))
                .frame(width: 280, height: 280)
                .blur(radius: 80)
                .offset(x: -170, y: 310)
        }
        .ignoresSafeArea()
    }
}

struct GlassCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(20)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.55), .white.opacity(0.12)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.8
                    )
            }
            .shadow(color: .black.opacity(0.05), radius: 18, y: 8)
    }
}

struct RecipeSummaryCard: View {
    let recipe: Recipe

    var body: some View {
        GlassCard {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: recipe.imageSymbol)
                    .font(.title2)
                    .frame(width: 48, height: 48)
                    .background(Color.orange.opacity(0.14), in: Circle())

                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.name)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(recipe.category)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(recipe.preparationMinutes + recipe.cookingMinutes) dk • \(recipe.servings) kişilik")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
    }
}
