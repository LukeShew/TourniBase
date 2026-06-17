import SwiftUI

struct TourniBaseLogo: View {
    var compact = false

    var body: some View {
        Image("TourniBaseLogo")
            .resizable()
            .scaledToFit()
            .frame(width: compact ? 126 : 180, height: compact ? 42 : 60, alignment: .leading)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("TourniBase")
    }
}

struct ScreenHeader: View {
    let eyebrow: String?
    let title: String
    let subtitle: String?

    init(eyebrow: String? = nil, title: String, subtitle: String? = nil) {
        self.eyebrow = eyebrow
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let eyebrow {
                Text(eyebrow.uppercased())
                    .font(.caption.weight(.bold))
                    .tracking(1.4)
                    .foregroundStyle(Color.tbBlue)
            }

            Text(title)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(Color.tbNavy)

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.tbMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SectionHeader: View {
    let title: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(Color.tbNavy)

            Spacer()

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.subheadline.weight(.semibold))
            }
        }
    }
}

struct StatusPill: View {
    let text: String
    let color: Color
    var systemImage: String?

    var body: some View {
        HStack(spacing: 5) {
            if let systemImage {
                Image(systemName: systemImage)
            }
            Text(text)
        }
        .font(.caption.weight(.bold))
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.11))
        .clipShape(Capsule())
    }
}

struct MetricTile: View {
    let label: String
    let value: String
    let detail: String?
    let systemImage: String
    var color: Color = .tbBlue

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: systemImage)
                    .font(.headline)
                    .foregroundStyle(color)
                Spacer()
                Text(label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.tbMuted)
            }

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.tbNavy)

            if let detail {
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
                    .lineLimit(2)
            }
        }
        .appCard()
    }
}

struct EventRow: View {
    let event: TournamentEvent

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(event.accent.color.opacity(0.12))
                Image(systemName: event.imageSymbol)
                    .font(.title2)
                    .foregroundStyle(event.accent.color)
            }
            .frame(width: 58, height: 58)

            VStack(alignment: .leading, spacing: 5) {
                Text(event.name)
                    .font(.headline)
                    .foregroundStyle(Color.tbNavy)
                Text("\(event.dateRange) • \(event.city)")
                    .font(.subheadline)
                    .foregroundStyle(Color.tbMuted)
                    .lineLimit(1)
                Text(event.venue)
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.tbMuted)
        }
        .padding(.vertical, 4)
    }
}

struct MockQRCode: View {
    let seed: String

    private var cells: [[Bool]] {
        let values = Array(seed.utf8)
        return (0..<21).map { row in
            (0..<21).map { column in
                if isFinder(row: row, column: column) { return true }
                let value = Int(values[(row * 7 + column * 3) % max(values.count, 1)])
                return (value + row * 11 + column * 17) % 5 < 2
            }
        }
    }

    var body: some View {
        Canvas { context, size in
            let cellSize = min(size.width, size.height) / 21
            for row in 0..<21 {
                for column in 0..<21 where cells[row][column] {
                    let rect = CGRect(
                        x: CGFloat(column) * cellSize,
                        y: CGFloat(row) * cellSize,
                        width: cellSize + 0.2,
                        height: cellSize + 0.2
                    )
                    context.fill(Path(rect), with: .color(.tbNavy))
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityLabel("Admission QR code")
    }

    private func isFinder(row: Int, column: Int) -> Bool {
        let inTopLeft = row < 7 && column < 7
        let inTopRight = row < 7 && column > 13
        let inBottomLeft = row > 13 && column < 7
        guard inTopLeft || inTopRight || inBottomLeft else { return false }

        let localRow = row < 7 ? row : row - 14
        let localColumn = column < 7 ? column : column - 14
        return localRow == 0 || localRow == 6 || localColumn == 0 || localColumn == 6 ||
            (localRow >= 2 && localRow <= 4 && localColumn >= 2 && localColumn <= 4)
    }
}

struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 38))
                .foregroundStyle(Color.tbBlue)
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(Color.tbNavy)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Color.tbMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 42)
    }
}
