import SwiftUI

struct HomeView: View {
    let role: UserRole

    var body: some View {
        Group {
            switch role {
            case .spectator:
                SpectatorHomeView()
            case .coach:
                CoachHomeView()
            case .organizer:
                OrganizerHomeView()
            }
        }
        .navigationBarHidden(true)
    }
}

private struct SpectatorHomeView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedEvent: TournamentEvent?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 22) {
                HomeTopBar(greeting: "Good afternoon", name: "John")

                if let pass = appState.passes.first {
                    NavigationLink {
                        PassDetailView(pass: pass)
                    } label: {
                        CompactPassCard(pass: pass)
                    }
                    .buttonStyle(.plain)
                }

                HStack(spacing: 12) {
                    QuickAction(icon: "magnifyingglass", title: "Find events") {
                        appState.selectedTab = .events
                    }
                    QuickAction(icon: "ticket.fill", title: "My passes") {
                        appState.selectedTab = .passes
                    }
                    QuickAction(icon: "person.2.fill", title: "Family") {}
                }

                SectionHeader(title: "Upcoming near you")

                ForEach(SampleData.events.prefix(2)) { event in
                    Button {
                        selectedEvent = event
                    } label: {
                        EventRow(event: event)
                            .appCard()
                    }
                    .buttonStyle(.plain)
                }

                FamilyWalletCard()
            }
            .padding(.horizontal, 18)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .screenBackground()
        .sheet(item: $selectedEvent) { event in
            NavigationStack {
                EventDetailView(event: event, role: .spectator)
            }
        }
    }
}

private struct CoachHomeView: View {
    @Environment(AppState.self) private var appState

    private var readyCount: Int {
        SampleData.teamMembers.filter { $0.status != .needsPass }.count
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 22) {
                HomeTopBar(greeting: "Next tournament", name: "River City Classic")

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Team readiness")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.82))
                            Text("\(readyCount) of \(SampleData.teamMembers.count) ready")
                                .font(.title.weight(.bold))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        ZStack {
                            Circle()
                                .stroke(.white.opacity(0.24), lineWidth: 8)
                            Circle()
                                .trim(from: 0, to: CGFloat(readyCount) / CGFloat(SampleData.teamMembers.count))
                                .stroke(.white, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                            Text("\(Int(Double(readyCount) / Double(SampleData.teamMembers.count) * 100))%")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 70, height: 70)
                    }

                    Button {
                        appState.selectedTab = .team
                    } label: {
                        Label("Review team status", systemImage: "arrow.right")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Color.tbNavy)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
                .padding(18)
                .background(Color.tbBlue)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                SectionHeader(title: "Needs attention")

                ForEach(SampleData.teamMembers.filter { $0.status == .needsPass }) { member in
                    HStack(spacing: 13) {
                        PlayerAvatar(member: member)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(member.playerName)
                                .font(.headline)
                                .foregroundStyle(Color.tbNavy)
                            Text("\(member.guardianName) has not purchased a pass")
                                .font(.caption)
                                .foregroundStyle(Color.tbMuted)
                        }
                        Spacer()
                        Button("Remind") {}
                            .font(.caption.weight(.bold))
                            .buttonStyle(.bordered)
                    }
                    .appCard()
                }

                SectionHeader(title: "Saturday schedule")
                ScheduleCard()
            }
            .padding(.horizontal, 18)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .screenBackground()
    }
}

private struct OrganizerHomeView: View {
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 22) {
                HomeTopBar(greeting: "Live event", name: "River City Classic")

                LiveEventBanner()

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(SampleData.organizerMetrics) { metric in
                        MetricTile(
                            label: metric.label,
                            value: metric.value,
                            detail: metric.detail,
                            systemImage: metric.systemImage
                        )
                    }
                }

                SectionHeader(title: "Admissions by hour")
                AdmissionsChart()

                SectionHeader(title: "Venue status")
                VenueStatusCard()
            }
            .padding(.horizontal, 18)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .screenBackground()
    }
}

private struct HomeTopBar: View {
    let greeting: String
    let name: String

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting.uppercased())
                    .font(.caption.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(Color.tbBlue)
                Text(name)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.tbNavy)
            }
            Spacer()
            Button {} label: {
                Image(systemName: "bell.fill")
                    .foregroundStyle(Color.tbNavy)
                    .frame(width: 42, height: 42)
                    .background(.white)
                    .clipShape(Circle())
                    .overlay(alignment: .topTrailing) {
                        Circle()
                            .fill(Color.tbOrange)
                            .frame(width: 9, height: 9)
                            .overlay(Circle().stroke(Color.tbBackground, lineWidth: 2))
                    }
            }
        }
    }
}

private struct CompactPassCard: View {
    let pass: AdmissionPass

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("YOUR NEXT PASS")
                        .font(.caption2.weight(.bold))
                        .tracking(1.2)
                        .foregroundStyle(.white.opacity(0.76))
                    Text(pass.eventName)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                }
                Spacer()
                StatusPill(text: pass.status.rawValue, color: .white, systemImage: "checkmark.circle.fill")
            }

            Divider().overlay(.white.opacity(0.22))

            HStack {
                Label(pass.validDates, systemImage: "calendar")
                Spacer()
                Label(pass.type.rawValue, systemImage: "ticket")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white.opacity(0.88))
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [Color.tbNavy, Color(red: 30 / 255, green: 64 / 255, blue: 175 / 255)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct QuickAction: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 9) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(Color.tbBlue)
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.tbNavy)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 78)
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

private struct FamilyWalletCard: View {
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "wallet.pass.fill")
                .font(.title2)
                .foregroundStyle(Color.tbGreen)
                .frame(width: 48, height: 48)
                .background(Color.tbGreen.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text("Family wallet")
                    .font(.headline)
                    .foregroundStyle(Color.tbNavy)
                Text("2 saved family members • Visa ending in 4242")
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.tbMuted)
        }
        .appCard()
    }
}

private struct ScheduleCard: View {
    var body: some View {
        VStack(spacing: 0) {
            ScheduleRow(time: "8:00 AM", title: "Team arrival", detail: "Court 3 entrance")
            Divider()
            ScheduleRow(time: "9:15 AM", title: "vs. Metro Elite", detail: "Court 4")
            Divider()
            ScheduleRow(time: "12:30 PM", title: "vs. Capital Select", detail: "Court 2")
        }
        .appCard(padding: 0)
    }
}

private struct ScheduleRow: View {
    let time: String
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 14) {
            Text(time)
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.tbBlue)
                .frame(width: 66, alignment: .leading)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.tbNavy)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
            }
            Spacer()
        }
        .padding(15)
    }
}

private struct LiveEventBanner: View {
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.tbGreen.opacity(0.16))
                Circle()
                    .fill(Color.tbGreen)
                    .frame(width: 12, height: 12)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 3) {
                Text("Admissions are live")
                    .font(.headline)
                    .foregroundStyle(Color.tbNavy)
                Text("8 gates online • Last sync just now")
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
            }
            Spacer()
            StatusPill(text: "LIVE", color: .tbGreen)
        }
        .appCard()
    }
}

private struct AdmissionsChart: View {
    private let values: [CGFloat] = [0.24, 0.52, 0.86, 0.68, 0.45, 0.58, 0.38]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Text("746")
                    .font(.title.weight(.bold))
                    .foregroundStyle(Color.tbNavy)
                Text("total check-ins")
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
                Spacer()
                StatusPill(text: "+18% today", color: .tbGreen)
            }

            HStack(alignment: .bottom, spacing: 10) {
                ForEach(Array(values.enumerated()), id: \.offset) { index, value in
                    VStack(spacing: 7) {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(index == 2 ? Color.tbBlue : Color.tbBlue.opacity(0.25))
                            .frame(height: 112 * value)
                        Text("\(index + 7)")
                            .font(.caption2)
                            .foregroundStyle(Color.tbMuted)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 135, alignment: .bottom)
        }
        .appCard()
    }
}

private struct VenueStatusCard: View {
    var body: some View {
        VStack(spacing: 0) {
            VenueRow(name: "Main entrance", scans: "412 scans", status: "Online", color: .tbGreen)
            Divider()
            VenueRow(name: "Court 5 entrance", scans: "198 scans", status: "Online", color: .tbGreen)
            Divider()
            VenueRow(name: "VIP entrance", scans: "136 scans", status: "Low battery", color: .tbOrange)
        }
        .appCard(padding: 0)
    }
}

private struct VenueRow: View {
    let name: String
    let scans: String
    let status: String
    let color: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.tbNavy)
                Text(scans)
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
            }
            Spacer()
            StatusPill(text: status, color: color)
        }
        .padding(15)
    }
}

struct PlayerAvatar: View {
    let member: TeamMember

    var body: some View {
        Text("\(member.jerseyNumber)")
            .font(.headline.weight(.bold))
            .foregroundStyle(Color.tbBlue)
            .frame(width: 44, height: 44)
            .background(Color.tbBlue.opacity(0.10))
            .clipShape(Circle())
    }
}
