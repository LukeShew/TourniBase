import SwiftUI

struct ScannerView: View {
    @Environment(AppState.self) private var appState
    @State private var scannerMode = 0
    @State private var result: ScanResult?
    @State private var torchEnabled = false

    var body: some View {
        ZStack {
            Color.tbNavy.ignoresSafeArea()

            VStack(spacing: 0) {
                ScannerTopBar(torchEnabled: $torchEnabled)

                Picker("Scanner mode", selection: $scannerMode) {
                    Text("Scan").tag(0)
                    Text("Recent").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)

                if scannerMode == 0 {
                    ScannerCameraView(result: result) {
                        simulateScan()
                    }
                } else {
                    RecentScansView(scans: appState.recentScans)
                }
            }
        }
        .navigationBarHidden(true)
    }

    private func simulateScan() {
        let statuses: [ScanStatus] = [.valid, .valid, .duplicate]
        let names = ["Michael Davis", "Rachel Green", "Chris Morgan"]
        let next = appState.recentScans.count % statuses.count
        let scan = ScanResult(
            id: UUID(),
            guestName: names[next],
            passType: next == 1 ? "Saturday pass" : "Weekend pass",
            timestamp: Date(),
            status: statuses[next]
        )
        appState.addScan(result: scan)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            result = scan
        }
    }
}

private struct ScannerTopBar: View {
    @Binding var torchEnabled: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("River City Classic")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Main entrance")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.62))
            }
            Spacer()
            Button {
                torchEnabled.toggle()
            } label: {
                Image(systemName: torchEnabled ? "flashlight.on.fill" : "flashlight.off.fill")
                    .foregroundStyle(torchEnabled ? Color.yellow : .white)
                    .frame(width: 44, height: 44)
                    .background(.white.opacity(0.12))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 12)
    }
}

private struct ScannerCameraView: View {
    let result: ScanResult?
    let simulateScan: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.white.opacity(0.035))
                    .frame(width: 284, height: 284)

                ScannerCorners()
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .frame(width: 250, height: 250)

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, Color.tbBlue, .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 230, height: 2)
                    .shadow(color: .tbBlue, radius: 8)
            }

            Text("Align the guest's TourniBase pass inside the frame")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.72))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 38)

            Button("Simulate pass scan", action: simulateScan)
                .font(.headline)
                .foregroundStyle(Color.tbNavy)
                .frame(width: 220, height: 50)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Spacer()

            if let result {
                ScanResultCard(result: result)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.horizontal, 18)
                    .padding(.bottom, 12)
            } else {
                Label("Ready to scan", systemImage: "dot.radiowaves.left.and.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.62))
                    .padding(.bottom, 24)
            }
        }
    }
}

private struct ScannerCorners: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let length: CGFloat = 42

        path.move(to: CGPoint(x: rect.minX, y: rect.minY + length))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + length, y: rect.minY))

        path.move(to: CGPoint(x: rect.maxX - length, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + length))

        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - length))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - length, y: rect.maxY))

        path.move(to: CGPoint(x: rect.minX + length, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - length))

        return path
    }
}

private struct ScanResultCard: View {
    let result: ScanResult

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: result.status == .valid ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .font(.system(size: 38))
                .foregroundStyle(result.status == .valid ? Color.tbGreen : Color.tbOrange)
            VStack(alignment: .leading, spacing: 4) {
                Text(result.status.rawValue)
                    .font(.headline)
                    .foregroundStyle(Color.tbNavy)
                Text("\(result.guestName) • \(result.passType)")
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
            }
            Spacer()
        }
        .appCard()
    }
}

private struct RecentScansView: View {
    let scans: [ScanResult]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                HStack {
                    Text("Recent activity")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    Spacer()
                    Text("\(scans.count) scans")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.62))
                }
                .padding(.bottom, 4)

                ForEach(scans) { scan in
                    HStack(spacing: 13) {
                        Image(systemName: scan.status == .valid ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                            .font(.title3)
                            .foregroundStyle(scan.status == .valid ? Color.tbGreen : Color.tbOrange)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(scan.guestName)
                                .font(.headline)
                                .foregroundStyle(Color.tbNavy)
                            Text(scan.passType)
                                .font(.caption)
                                .foregroundStyle(Color.tbMuted)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 3) {
                            Text(scan.status.rawValue)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(scan.status == .valid ? Color.tbGreen : Color.tbOrange)
                            Text(scan.timestamp, style: .time)
                                .font(.caption2)
                                .foregroundStyle(Color.tbMuted)
                        }
                    }
                    .appCard()
                }
            }
            .padding(18)
        }
    }
}
