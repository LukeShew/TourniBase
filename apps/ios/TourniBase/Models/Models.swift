import Foundation

enum UserRole: String, CaseIterable, Identifiable {
    case spectator
    case coach
    case organizer

    var id: String { rawValue }

    var title: String {
        switch self {
        case .spectator: "Parent or spectator"
        case .coach: "Coach"
        case .organizer: "Tournament director"
        }
    }

    var shortTitle: String {
        switch self {
        case .spectator: "Spectator"
        case .coach: "Coach"
        case .organizer: "Director"
        }
    }

    var subtitle: String {
        switch self {
        case .spectator: "Buy passes once and enter faster."
        case .coach: "Know which families are ready before arrival."
        case .organizer: "Run admissions, check-in, and revenue in one place."
        }
    }

    var systemImage: String {
        switch self {
        case .spectator: "person.2.fill"
        case .coach: "sportscourt.fill"
        case .organizer: "chart.bar.fill"
        }
    }

    var tabs: [AppTab] {
        switch self {
        case .spectator: [.home, .events, .passes, .profile]
        case .coach: [.home, .team, .events, .profile]
        case .organizer: [.home, .events, .scan, .profile]
        }
    }

    var defaultTab: AppTab { .home }
}

struct TournamentEvent: Identifiable, Hashable {
    let id: UUID
    let name: String
    let sport: String
    let venue: String
    let city: String
    let startDate: Date
    let endDate: Date
    let imageSymbol: String
    let accent: EventAccent
    let teams: Int
    let courts: Int
    let weekendPrice: Decimal
    let dayPrice: Decimal
    let status: EventStatus

    var dateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "\(formatter.string(from: startDate))–\(formatter.string(from: endDate))"
    }

    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter.string(from: startDate)
    }
}

enum EventStatus: String, Hashable {
    case upcoming = "Upcoming"
    case live = "Live"
    case completed = "Completed"
}

enum EventAccent: String, Hashable {
    case blue
    case green
    case orange
    case violet
}

struct AdmissionPass: Identifiable, Hashable {
    let id: UUID
    let eventID: UUID
    let eventName: String
    let holderName: String
    let type: PassType
    let validDates: String
    let venue: String
    let confirmationCode: String
    var status: PassStatus
}

enum PassType: String, CaseIterable, Identifiable {
    case weekend = "Weekend pass"
    case saturday = "Saturday pass"
    case sunday = "Sunday pass"

    var id: String { rawValue }
}

enum PassStatus: String, Hashable {
    case active = "Active"
    case used = "Checked in"
    case upcoming = "Upcoming"
}

struct TeamMember: Identifiable, Hashable {
    let id: UUID
    let playerName: String
    let guardianName: String
    let jerseyNumber: Int
    let status: ReadinessStatus
}

enum ReadinessStatus: String, CaseIterable, Identifiable {
    case ready = "Pass ready"
    case checkedIn = "Checked in"
    case needsPass = "Needs pass"

    var id: String { rawValue }
}

struct ScanResult: Identifiable, Hashable {
    let id: UUID
    let guestName: String
    let passType: String
    let timestamp: Date
    let status: ScanStatus
}

enum ScanStatus: String, Hashable {
    case valid = "Valid"
    case duplicate = "Already used"
    case invalid = "Invalid"
}

struct RevenueMetric: Identifiable {
    let id = UUID()
    let label: String
    let value: String
    let detail: String
    let systemImage: String
}
