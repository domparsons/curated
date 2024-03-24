//
//  UpgradeAccountView.swift
//  Curated
//
//  Created by Dom Parsons on 04/02/2024.
//

import SwiftUI
import StoreKit

struct UpgradeAccountView: View {
    
    let productIds = ["com.domparsons.curated.pro"]
    
    @State private var products: [Product] = []
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(colors: [.purple, .purple.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Lifetime access!")
                                    .font(.title.bold())
                                    .padding(.bottom, 5)
                                
                                Text("Pay once for unlimited photo uploads to Curated")
                                    .foregroundStyle(.secondary)
                                    .padding(.bottom, 5)
                                
                                ProductView(id: "com.domparsons.curated.pro")
                                    .productViewStyle(CompactProductViewStyle())
                            }
                            .padding(30)
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 42))
                    .padding(20)
                }
                .ignoresSafeArea()
            }
        }
        .preferredColorScheme(.dark)
//        .onInAppPurchaseCompletion { product, result in
//            if case .success(.success(let transaction)) = result {
//                await BirdBrain.shared.process(transaction: transaction)
//                dismiss()
//            }
//        }
    }
    
    private func loadProducts() async throws {
        self.products = try await Product.products(for: productIds)
    }
}

#Preview {
    UpgradeAccountView()
}
