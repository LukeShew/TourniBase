import SwiftUI

struct PassesView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedSegment = 0

    private var visiblePasses: [AdmissionPass] {
        if selectedSegment == 0 {
            return appState.passes.filter { $0.status != .used }
        }
        return appState.passes.filter { $0.status == .used }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                ScreenHeader(
                    eyebrow: "Admission wallet",
                    title: "My passes",
                    subtitle: "Open a pass before reaching the entrance for the fastest check-in."
                )

                Picker("Pass status", selection: $selectedSegment) {
                    Text("Active").tag(0)
                    Text("Past").tag(1)
                }
                .pickerStyle(.segmented)

                if visiblePasses.isEmpty {
                    EmptyStateView(
                        systemImage: "ticket",
                        title: selectedSegment == 0 ? "No active passes" : "No past passes",
                        message: selectedSegment == 0
                            ? "Your purchased tournament passes will appear here."
                            : "Checked-in and expired passes will be saved here."
                    )
                    .appCard()
                } else {
                    ForEach(visiblePasses) { pass in
                        NavigationLink {
                            PassDetailView(pass: pass)
                        } label: {
                            PassWalletCard(pass: pass)
                        }
                        .buttonStyle(.plain)
                    }
                }

                WalletHelpCard()
            }
            .padding(.horizontal, 18)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .screenBackground()
        .navigationBarHidden(true)
    }
}

struct PassDetailView: View {
    let pass: AdmissionPass
    @State private var brightnessBoosted = false
    @State private var showWalletMessage = false

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        TourniBaseLogo(compact: true)
                        Spacer()
                        StatusPill(text: pass.status.rawValue, color: .tbGreen, systemImage: "checkmark.circle.fill")
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text(pass.eventName)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(Color.tbNavy)
                        Text(pass.type.rawValue)
                            .font(.headline)
                            .foregroundStyle(Color.tbBlue)
                    }

                    MockQRCode(seed: pass.confirmationCode)
                        .frame(maxWidth: 240)
                        .frame(maxWidth: .infinity)

                    Text("Present this code at the entrance")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.tbMuted)
                        .frame(maxWidth: .infinity)

                    Divider()

                    PassDetailRow(label: "Pass holder", value: pass.holderName)
                    PassDetailRow(label: "Valid", value: pass.validDates)
                    PassDetailRow(label: "Venue", value: pass.venue)
                    PassDetailRow(label: "Confirmation", value: pass.confirmationCode, monospaced: true)
                }
                .padding(20)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.tbBorder, lineWidth: 1)
                }

                Button {
                    showWalletMessage = true
                } label: {
                    Label("Add to Apple Wallet", systemImage: "wallet.pass.fill")
                }
                .buttonStyle(SecondaryButtonStyle())

                Button {
                    brightnessBoosted.toggle()
                } label: {
                    Label(
                        brightnessBoosted ? "Brightness boosted" : "Boost screen brightness",
                        systemImage: brightnessBoosted ? "sun.max.fill" : "sun.max"
                    )
                }
                .buttonStyle(SecondaryButtonStyle())

                Text("Screenshots may not be accepted. This pass refreshes automatically to help prevent duplicate entry.")
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
            }
            .padding(18)
        }
        .background(brightnessBoosted ? Color.white : Color.tbBackground)
        .navigationTitle("Admission pass")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Apple Wallet mockup", isPresented: $showWalletMessage) {
            Button("Done", role: .cancel) {}
        } message: {
            Text("Wallet integration will be connected when live passes are implemented.")
        }
    }
}

private struct PassWalletCard: View {
    let pass: AdmissionPass

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 7) {
                    TourniBaseLogo(compact: true)
                    Text(pass.eventName)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Color.tbNavy)
                    Text(pass.type.rawValue)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.tbBlue)
                }
                Spacer()
                MockQRCode(seed: pass.confirmationCode)
                    .frame(width: 82, height: 82)
            }
            .padding(17)

            HStack {
                Label(pass.validDates, systemImage: "calendar")
                Spacer()
                StatusPill(text: pass.status.rawValue, color: pass.status == .active ? .tbGreen : .tbBlue)
            }
            .font(.caption)
            .foregroundStyle(Color.tbMuted)
            .padding(.horizontal, 17)
            .padding(.vertical, 13)
            .background(Color.tbBackground)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(Color.tbBorder, lineWidth: 1)
        }
    }
}

private struct PassDetailRow: View {
    let label: String
    let value: String
    var monospaced = false

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.tbMuted)
                .frame(width: 88, alignment: .leading)
            Text(value)
                .font(monospaced ? .subheadline.monospaced() : .subheadline)
                .foregroundStyle(Color.tbNavy)
            Spacer()
        }
    }
}

private struct WalletHelpCard: View {
    var body: some View {
        HStack(spacing: 13) {
            Image(systemName: "lightbulb.fill")
                .foregroundStyle(Color.tbOrange)
                .frame(width: 42, height: 42)
                .background(Color.tbOrange.opacity(0.10))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text("Entry tip")
                    .font(.headline)
                    .foregroundStyle(Color.tbNavy)
                Text("Open your pass before you reach the gate, especially when venue service is limited.")
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
            }
        }
        .appCard()
    }
}
