import SwiftUI

struct EventsView: View {
    let role: UserRole
    @State private var searchText = ""
    @State private var selectedFilter = "All"

    private let filters = ["All", "Basketball", "Nearby", "This month"]

    private var filteredEvents: [TournamentEvent] {
        guard !searchText.isEmpty else { return SampleData.events }
        return SampleData.events.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.city.localizedCaseInsensitiveContains(searchText) ||
                $0.venue.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 18) {
                ScreenHeader(
                    eyebrow: role == .organizer ? "Manage tournaments" : "Tournament calendar",
                    title: role == .organizer ? "Your events" : "Find an event",
                    subtitle: role == .organizer
                        ? "Track live events and prepare upcoming admissions."
                        : "Search participating tournaments and buy admission before arrival."
                )

                if role != .organizer {
                    SearchField(text: $searchText)
                    FilterChips(filters: filters, selection: $selectedFilter)
                } else {
                    OrganizerEventSummary()
                }

                if filteredEvents.isEmpty {
                    EmptyStateView(
                        systemImage: "calendar.badge.exclamationmark",
                        title: "No events found",
                        message: "Try a different tournament, city, or venue."
                    )
                } else {
                    ForEach(filteredEvents) { event in
                        NavigationLink {
                            EventDetailView(event: event, role: role)
                        } label: {
                            EventCard(event: event, role: role)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .screenBackground()
        .navigationBarHidden(true)
    }
}

struct EventDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let event: TournamentEvent
    let role: UserRole
    @State private var purchaseEvent: TournamentEvent?
    @State private var showShareConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                EventHero(event: event)

                VStack(alignment: .leading, spacing: 18) {
                    EventFactGrid(event: event)

                    if role == .organizer {
                        OrganizerEventControls(event: event)
                    } else {
                        AdmissionOptions(event: event) {
                            purchaseEvent = event
                        }
                    }

                    SectionHeader(title: "Tournament details")
                    TournamentDetails(event: event)

                    SectionHeader(title: "Location")
                    LocationCard(event: event)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 28)
            }
        }
        .background(Color.tbBackground)
        .navigationTitle(event.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showShareConfirmation = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(item: $purchaseEvent) { event in
            PurchasePassView(event: event)
        }
        .alert("Link copied", isPresented: $showShareConfirmation) {
            Button("Done", role: .cancel) {}
        } message: {
            Text("The event link is ready to share.")
        }
    }
}

struct SearchField: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.tbMuted)
            TextField("Tournament, city, or venue", text: $text)
                .textInputAutocapitalization(.words)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.tbMuted)
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 50)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.tbBorder, lineWidth: 1)
        }
    }
}

private struct FilterChips: View {
    let filters: [String]
    @Binding var selection: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 9) {
                ForEach(filters, id: \.self) { filter in
                    Button(filter) {
                        selection = filter
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(selection == filter ? .white : Color.tbNavy)
                    .padding(.horizontal, 14)
                    .frame(height: 38)
                    .background(selection == filter ? Color.tbBlue : Color.white)
                    .clipShape(Capsule())
                    .overlay {
                        if selection != filter {
                            Capsule().stroke(Color.tbBorder, lineWidth: 1)
                        }
                    }
                }
            }
        }
    }
}

private struct EventCard: View {
    let event: TournamentEvent
    let role: UserRole

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                event.accent.color.opacity(0.12)
                    .frame(height: 126)

                Image(systemName: event.imageSymbol)
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(event.accent.color.opacity(0.25))
                    .offset(x: 270, y: -10)

                VStack(alignment: .leading, spacing: 7) {
                    StatusPill(
                        text: event.status.rawValue,
                        color: event.status == .live ? .tbGreen : event.accent.color
                    )
                    Text(event.name)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.tbNavy)
                    Text("\(event.dateRange) • \(event.city)")
                        .font(.subheadline)
                        .foregroundStyle(Color.tbMuted)
                }
                .padding(16)
            }
            .clipped()

            HStack {
                Label(event.venue, systemImage: "mappin.and.ellipse")
                    .lineLimit(1)
                Spacer()
                if role == .organizer {
                    Text("\(event.teams) teams")
                } else {
                    Text("From \(currency(event.dayPrice))")
                }
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.tbMuted)
            .padding(16)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.tbBorder, lineWidth: 1)
        }
    }
}

private struct EventHero: View {
    let event: TournamentEvent

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [event.accent.color.opacity(0.78), Color.tbNavy],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 260)

            Image(systemName: event.imageSymbol)
                .font(.system(size: 150, weight: .bold))
                .foregroundStyle(.white.opacity(0.09))
                .offset(x: 235, y: -36)

            VStack(alignment: .leading, spacing: 9) {
                StatusPill(text: event.status.rawValue, color: .white)
                Text(event.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
                Text("\(event.dateRange) • \(event.city)")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.84))
            }
            .padding(20)
        }
        .clipped()
    }
}

private struct EventFactGrid: View {
    let event: TournamentEvent

    var body: some View {
        HStack(spacing: 10) {
            EventFact(icon: "person.3.fill", value: "\(event.teams)", label: "Teams")
            EventFact(icon: "square.grid.2x2.fill", value: "\(event.courts)", label: "Courts")
            EventFact(icon: "clock.fill", value: "8 AM", label: "Doors")
        }
    }
}

private struct EventFact: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(Color.tbBlue)
            Text(value)
                .font(.headline)
                .foregroundStyle(Color.tbNavy)
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.tbMuted)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 94)
        .appCard(padding: 10)
    }
}

private struct AdmissionOptions: View {
    let event: TournamentEvent
    let purchase: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            SectionHeader(title: "Admission")

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weekend pass")
                        .font(.headline)
                        .foregroundStyle(Color.tbNavy)
                    Text("Entry Saturday and Sunday")
                        .font(.caption)
                        .foregroundStyle(Color.tbMuted)
                }
                Spacer()
                Text(currency(event.weekendPrice))
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Color.tbNavy)
            }
            .appCard()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Single-day pass")
                        .font(.headline)
                        .foregroundStyle(Color.tbNavy)
                    Text("Choose Saturday or Sunday")
                        .font(.caption)
                        .foregroundStyle(Color.tbMuted)
                }
                Spacer()
                Text(currency(event.dayPrice))
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Color.tbNavy)
            }
            .appCard()

            Button("Choose a pass", action: purchase)
                .buttonStyle(PrimaryButtonStyle())
        }
    }
}

private struct OrganizerEventControls: View {
    let event: TournamentEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Event operations")
            HStack(spacing: 10) {
                OrganizerAction(icon: "qrcode.viewfinder", title: "Open scanner")
                OrganizerAction(icon: "person.2.fill", title: "Gate staff")
                OrganizerAction(icon: "square.and.arrow.up.fill", title: "Share link")
            }

            VStack(spacing: 0) {
                OperationsRow(label: "Pass sales", value: "1,084", color: .tbBlue)
                Divider()
                OperationsRow(label: "Gross revenue", value: "$18,420", color: .tbGreen)
                Divider()
                OperationsRow(label: "Refunds", value: "$216", color: .tbOrange)
            }
            .appCard(padding: 0)
        }
    }
}

private struct OrganizerAction: View {
    let icon: String
    let title: String

    var body: some View {
        Button {} label: {
            VStack(spacing: 9) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(Color.tbBlue)
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.tbNavy)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 82)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.tbBorder, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct OperationsRow: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.tbMuted)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundStyle(color)
        }
        .padding(15)
    }
}

private struct TournamentDetails: View {
    let event: TournamentEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Doors open at 8:00 AM", systemImage: "door.left.hand.open")
            Label("Mobile passes accepted at every entrance", systemImage: "iphone")
            Label("Children 5 and under enter free", systemImage: "figure.and.child.holdinghands")
            Label("No cash needed at TourniBase gates", systemImage: "creditcard.fill")
        }
        .font(.subheadline)
        .foregroundStyle(Color.tbNavy)
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard()
    }
}

private struct LocationCard: View {
    let event: TournamentEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack {
                Color.tbBlue.opacity(0.08)
                Image(systemName: "map.fill")
                    .font(.system(size: 62))
                    .foregroundStyle(Color.tbBlue.opacity(0.18))
                Image(systemName: "mappin.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.tbBlue)
            }
            .frame(height: 128)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            Text(event.venue)
                .font(.headline)
                .foregroundStyle(Color.tbNavy)
            Text("\(event.city) • Parking available on site")
                .font(.subheadline)
                .foregroundStyle(Color.tbMuted)
        }
        .appCard()
    }
}

private struct OrganizerEventSummary: View {
    var body: some View {
        HStack(spacing: 12) {
            MetricTile(label: "Active", value: "1", detail: "Event live now", systemImage: "dot.radiowaves.left.and.right", color: .tbGreen)
            MetricTile(label: "Upcoming", value: "2", detail: "Next 30 days", systemImage: "calendar.badge.clock", color: .tbBlue)
        }
    }
}

func currency(_ value: Decimal) -> String {
    let number = NSDecimalNumber(decimal: value)
    return NumberFormatter.localizedString(from: number, number: .currency)
}
