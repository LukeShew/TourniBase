import SwiftUI

struct PurchasePassView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    let event: TournamentEvent

    @State private var step = 0
    @State private var passType: PassType = .weekend
    @State private var quantity = 1
    @State private var holderName = "John Smith"
    @State private var isProcessing = false
    @State private var purchasedPass: AdmissionPass?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ProgressView(value: Double(step + 1), total: 3)
                    .tint(.tbBlue)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                Group {
                    switch step {
                    case 0:
                        PassSelectionStep(
                            event: event,
                            passType: $passType,
                            quantity: $quantity
                        )
                    case 1:
                        CheckoutStep(
                            event: event,
                            passType: passType,
                            quantity: quantity,
                            holderName: $holderName
                        )
                    default:
                        PurchaseSuccessStep(event: event, pass: purchasedPass)
                    }
                }

                if step < 2 {
                    Button(step == 0 ? "Continue" : isProcessing ? "Processing..." : "Pay securely") {
                        if step == 0 {
                            step = 1
                        } else {
                            completePurchase()
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(isProcessing)
                    .padding(20)
                } else {
                    Button("View my passes") {
                        appState.selectedTab = .passes
                        dismiss()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(20)
                }
            }
            .background(Color.tbBackground)
            .navigationTitle(step == 2 ? "You're ready" : "Buy admission")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if step == 1 {
                        Button {
                            step = 0
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func completePurchase() {
        isProcessing = true
        let newPass = AdmissionPass(
            id: UUID(),
            eventID: event.id,
            eventName: event.name,
            holderName: holderName,
            type: passType,
            validDates: passType == .weekend ? event.dateRange + ", 2026" : event.shortDate + ", 2026",
            venue: event.venue,
            confirmationCode: "TB-\(Int.random(in: 100...999))-\(Int.random(in: 100...999))",
            status: .active
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            appState.addPass(newPass)
            purchasedPass = newPass
            isProcessing = false
            step = 2
        }
    }
}

private struct PassSelectionStep: View {
    let event: TournamentEvent
    @Binding var passType: PassType
    @Binding var quantity: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ScreenHeader(
                    eyebrow: event.dateRange,
                    title: event.name,
                    subtitle: "Choose the admission option that works for your visit."
                )

                ForEach(PassType.allCases) { type in
                    Button {
                        passType = type
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(type.rawValue)
                                    .font(.headline)
                                    .foregroundStyle(Color.tbNavy)
                                Text(type == .weekend ? "Best value • Both days" : "Valid for one tournament day")
                                    .font(.caption)
                                    .foregroundStyle(Color.tbMuted)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 6) {
                                Text(price(for: type))
                                    .font(.headline)
                                    .foregroundStyle(Color.tbNavy)
                                Image(systemName: passType == type ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(passType == type ? Color.tbBlue : Color.tbBorder)
                            }
                        }
                        .appCard()
                    }
                    .buttonStyle(.plain)
                }

                HStack {
                    Text("Quantity")
                        .font(.headline)
                        .foregroundStyle(Color.tbNavy)
                    Spacer()
                    Stepper("\(quantity)", value: $quantity, in: 1...8)
                        .labelsHidden()
                    Text("\(quantity)")
                        .font(.headline.monospacedDigit())
                        .frame(width: 24)
                }
                .appCard()
            }
            .padding(20)
        }
    }

    private func price(for type: PassType) -> String {
        currency(type == .weekend ? event.weekendPrice : event.dayPrice)
    }
}

private struct CheckoutStep: View {
    let event: TournamentEvent
    let passType: PassType
    let quantity: Int
    @Binding var holderName: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ScreenHeader(
                    eyebrow: "Secure checkout",
                    title: "Review and pay",
                    subtitle: "Your pass will appear immediately after purchase."
                )

                VStack(alignment: .leading, spacing: 15) {
                    Text("Pass holder")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.tbMuted)
                    TextField("Full name", text: $holderName)
                        .padding(.horizontal, 12)
                        .frame(height: 48)
                        .background(Color.tbBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    Divider()

                    HStack(spacing: 12) {
                        Image(systemName: "creditcard.fill")
                            .font(.title2)
                            .foregroundStyle(Color.tbBlue)
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Visa •••• 4242")
                                .font(.headline)
                                .foregroundStyle(Color.tbNavy)
                            Text("Default payment method")
                                .font(.caption)
                                .foregroundStyle(Color.tbMuted)
                        }
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.tbGreen)
                    }
                }
                .appCard()

                VStack(spacing: 13) {
                    SummaryRow(label: passType.rawValue, value: "\(quantity) × \(unitPrice)")
                    SummaryRow(label: "Service fee", value: "$0.00")
                    Divider()
                    SummaryRow(label: "Total", value: totalPrice, emphasized: true)
                }
                .appCard()

                Label("Payments are encrypted and processed securely.", systemImage: "lock.fill")
                    .font(.caption)
                    .foregroundStyle(Color.tbMuted)
                    .frame(maxWidth: .infinity)
            }
            .padding(20)
        }
    }

    private var unitDecimal: Decimal {
        passType == .weekend ? event.weekendPrice : event.dayPrice
    }

    private var unitPrice: String {
        currency(unitDecimal)
    }

    private var totalPrice: String {
        currency(unitDecimal * Decimal(quantity))
    }
}

private struct SummaryRow: View {
    let label: String
    let value: String
    var emphasized = false

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
        .font(emphasized ? .headline : .subheadline)
        .foregroundStyle(emphasized ? Color.tbNavy : Color.tbMuted)
    }
}

private struct PurchaseSuccessStep: View {
    let event: TournamentEvent
    let pass: AdmissionPass?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.tbGreen.opacity(0.12))
                    .frame(width: 104, height: 104)
                Image(systemName: "checkmark")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(Color.tbGreen)
            }
            VStack(spacing: 10) {
                Text("Admission confirmed")
                    .font(.title.weight(.bold))
                    .foregroundStyle(Color.tbNavy)
                Text("Your \(pass?.type.rawValue.lowercased() ?? "pass") for \(event.name) is ready to use.")
                    .font(.body)
                    .foregroundStyle(Color.tbMuted)
                    .multilineTextAlignment(.center)
            }
            if let pass {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(pass.holderName)
                            .font(.headline)
                        Text(pass.confirmationCode)
                            .font(.caption.monospaced())
                            .foregroundStyle(Color.tbMuted)
                    }
                    Spacer()
                    StatusPill(text: "Paid", color: .tbGreen, systemImage: "checkmark.circle.fill")
                }
                .appCard()
            }
            Spacer()
        }
        .padding(24)
    }
}
