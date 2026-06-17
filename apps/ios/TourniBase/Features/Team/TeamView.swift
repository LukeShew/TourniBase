import SwiftUI

struct TeamView: View {
    @State private var filter: ReadinessStatus?
    @State private var searchText = ""
    @State private var showShareAlert = false

    private var members: [TeamMember] {
        SampleData.teamMembers.filter { member in
            let matchesFilter = filter == nil || member.status == filter
            let matchesSearch = searchText.isEmpty ||
                member.playerName.localizedCaseInsensitiveContains(searchText) ||
                member.guardianName.localizedCaseInsensitiveContains(searchText)
            return matchesFilter && matchesSearch
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 18) {
                ScreenHeader(
                    eyebrow: "Metro Select 14U",
                    title: "Team access",
                    subtitle: "See which families are ready before the team arrives."
                )

                TeamReadinessSummary()

                SearchField(text: $searchText)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 9) {
                        TeamFilterChip(title: "All", selected: filter == nil) {
                            filter = nil
                        }
                        ForEach(ReadinessStatus.allCases) { status in
                            TeamFilterChip(title: status.rawValue, selected: filter == status) {
                                filter = status
                            }
                        }
                    }
                }

                HStack {
                    Text("\(members.count) players")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.tbMuted)
                    Spacer()
                    Button {
                        showShareAlert = true
                    } label: {
                        Label("Share registration link", systemImage: "square.and.arrow.up")
                            .font(.caption.weight(.bold))
                    }
                }

                ForEach(members) { member in
                    TeamMemberRow(member: member)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .screenBackground()
        .navigationBarHidden(true)
        .alert("Registration link copied", isPresented: $showShareAlert) {
            Button("Done", role: .cancel) {}
        } message: {
            Text("Send the TourniBase link to families who still need admission.")
        }
    }
}

private struct TeamReadinessSummary: View {
    private let members = SampleData.teamMembers

    var body: some View {
        HStack(spacing: 10) {
            ReadinessMetric(
                value: "\(members.filter { $0.status == .checkedIn }.count)",
                label: "Checked in",
                color: .tbGreen
            )
            ReadinessMetric(
                value: "\(members.filter { $0.status == .ready }.count)",
                label: "Pass ready",
                color: .tbBlue
            )
            ReadinessMetric(
                value: "\(members.filter { $0.status == .needsPass }.count)",
                label: "Needs pass",
                color: .tbOrange
            )
        }
    }
}

private struct ReadinessMetric: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.tbMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 84)
        .appCard(padding: 10)
    }
}

private struct TeamFilterChip: View {
    let title: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(title, action: action)
            .font(.caption.weight(.semibold))
            .foregroundStyle(selected ? .white : Color.tbNavy)
            .padding(.horizontal, 13)
            .frame(height: 36)
            .background(selected ? Color.tbBlue : Color.white)
            .clipShape(Capsule())
            .overlay {
                if !selected {
                    Capsule().stroke(Color.tbBorder, lineWidth: 1)
                }
            }
    }
}

private struct TeamMemberRow: View {
    let member: TeamMember

    var body: some View {
        HStack(spacing: 13) {
            PlayerAvatar(member: member)
            VStack(alignment: .leading, spacing: 4) {
                Text(member.playerName)
                    .font(.headline)
                    .foregroundStyle(Color.tbNavy)
                Text(member.guardianName)
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
            }
            Spacer()
            StatusPill(
                text: member.status.rawValue,
                color: statusColor,
                systemImage: statusIcon
            )
        }
        .appCard()
    }

    private var statusColor: Color {
        switch member.status {
        case .ready: .tbBlue
        case .checkedIn: .tbGreen
        case .needsPass: .tbOrange
        }
    }

    private var statusIcon: String {
        switch member.status {
        case .ready: "ticket.fill"
        case .checkedIn: "checkmark.circle.fill"
        case .needsPass: "exclamationmark.circle.fill"
        }
    }
}
