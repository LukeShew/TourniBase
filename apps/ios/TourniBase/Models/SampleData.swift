import Foundation

enum SampleData {
    static let riverCityID = UUID(uuidString: "A5A730C7-91C0-4318-B65F-8B2B60049E4B")!
    static let summerTipoffID = UUID(uuidString: "9C119FE5-A1E2-4BA7-BE53-D8F50E7306E7")!
    static let eastCoastID = UUID(uuidString: "557A36A9-DF6A-49A5-A06E-DB55F2F50CE1")!

    static let events: [TournamentEvent] = [
        TournamentEvent(
            id: riverCityID,
            name: "River City Classic",
            sport: "Basketball",
            venue: "Richmond Sports Center",
            city: "Richmond, VA",
            startDate: date(month: 6, day: 21, hour: 8),
            endDate: date(month: 6, day: 22, hour: 18),
            imageSymbol: "basketball.fill",
            accent: .blue,
            teams: 48,
            courts: 8,
            weekendPrice: 24,
            dayPrice: 15,
            status: .upcoming
        ),
        TournamentEvent(
            id: summerTipoffID,
            name: "Summer Tip-Off",
            sport: "Basketball",
            venue: "Capital Athletic Complex",
            city: "Washington, DC",
            startDate: date(month: 6, day: 28, hour: 9),
            endDate: date(month: 6, day: 29, hour: 17),
            imageSymbol: "basketball.fill",
            accent: .green,
            teams: 36,
            courts: 6,
            weekendPrice: 22,
            dayPrice: 14,
            status: .upcoming
        ),
        TournamentEvent(
            id: eastCoastID,
            name: "East Coast Championship",
            sport: "Basketball",
            venue: "Atlantic Fieldhouse",
            city: "Baltimore, MD",
            startDate: date(month: 7, day: 12, hour: 8),
            endDate: date(month: 7, day: 13, hour: 19),
            imageSymbol: "trophy.fill",
            accent: .orange,
            teams: 64,
            courts: 10,
            weekendPrice: 28,
            dayPrice: 18,
            status: .upcoming
        )
    ]

    static let passes: [AdmissionPass] = [
        AdmissionPass(
            id: UUID(),
            eventID: riverCityID,
            eventName: "River City Classic",
            holderName: "John Smith",
            type: .weekend,
            validDates: "June 21–22, 2026",
            venue: "Richmond Sports Center",
            confirmationCode: "TB-482-719",
            status: .active
        ),
        AdmissionPass(
            id: UUID(),
            eventID: summerTipoffID,
            eventName: "Summer Tip-Off",
            holderName: "John Smith",
            type: .saturday,
            validDates: "June 28, 2026",
            venue: "Capital Athletic Complex",
            confirmationCode: "TB-216-504",
            status: .upcoming
        )
    ]

    static let teamMembers: [TeamMember] = [
        TeamMember(id: UUID(), playerName: "Marcus Reed", guardianName: "Dana Reed", jerseyNumber: 4, status: .checkedIn),
        TeamMember(id: UUID(), playerName: "Noah Carter", guardianName: "Elena Carter", jerseyNumber: 7, status: .ready),
        TeamMember(id: UUID(), playerName: "Eli Brooks", guardianName: "James Brooks", jerseyNumber: 11, status: .ready),
        TeamMember(id: UUID(), playerName: "Liam Foster", guardianName: "Taylor Foster", jerseyNumber: 13, status: .needsPass),
        TeamMember(id: UUID(), playerName: "Mason Hill", guardianName: "Morgan Hill", jerseyNumber: 21, status: .ready),
        TeamMember(id: UUID(), playerName: "Caleb Price", guardianName: "Robin Price", jerseyNumber: 24, status: .needsPass),
        TeamMember(id: UUID(), playerName: "Jayden Cole", guardianName: "Avery Cole", jerseyNumber: 30, status: .checkedIn)
    ]

    static let recentScans: [ScanResult] = [
        ScanResult(id: UUID(), guestName: "Sarah Miller", passType: "Weekend pass", timestamp: Date().addingTimeInterval(-80), status: .valid),
        ScanResult(id: UUID(), guestName: "David Carter", passType: "Saturday pass", timestamp: Date().addingTimeInterval(-210), status: .valid),
        ScanResult(id: UUID(), guestName: "Angela Brooks", passType: "Weekend pass", timestamp: Date().addingTimeInterval(-360), status: .duplicate)
    ]

    static let organizerMetrics: [RevenueMetric] = [
        RevenueMetric(label: "Revenue", value: "$18,420", detail: "+12% vs. last event", systemImage: "dollarsign.circle.fill"),
        RevenueMetric(label: "Passes sold", value: "1,084", detail: "72% weekend passes", systemImage: "ticket.fill"),
        RevenueMetric(label: "Checked in", value: "746", detail: "69% of sold passes", systemImage: "person.crop.circle.badge.checkmark"),
        RevenueMetric(label: "Peak hour", value: "9–10 AM", detail: "238 entrances", systemImage: "chart.line.uptrend.xyaxis")
    ]

    private static func date(month: Int, day: Int, hour: Int) -> Date {
        DateComponents(
            calendar: .current,
            timeZone: .current,
            year: 2026,
            month: month,
            day: day,
            hour: hour
        ).date ?? Date()
    }
}
