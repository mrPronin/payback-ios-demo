//
//  TopBannerView.swift
//  Payback
//
//  Created by Pronin Oleksandr on 02.04.23.
//

import SwiftUI

struct BannerViewModifier: ViewModifier {
    
    struct BannerData {
        let title: String
        let details: String
        let type: BannerType
    }
    
    enum BannerType {
        case info
        case warning
        case error
        
        var textColor: Color {
            return .white
        }
        
        var backgroundColor: Color {
            switch self {
            case .info: return .blue
            case .warning: return .orange
            case .error: return Color(red: 217/255, green: 77/255, blue: 77/255)
            }
        }
    }
    
    // Banner members
    @Binding var data: BannerData?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if let data = data {
                VStack {
                    HStack {
                        // Banner Content
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.title)
                                .bold()
                            Text(data.details)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        Spacer()
                    }
                    .foregroundColor(data.type.textColor)
                    .padding(12)
                    .background(data.type.backgroundColor)
                    .cornerRadius(8)
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .animation(.easeInOut, value: UUID())
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.data = nil
                    }
                }
            }
        }
    }
}

extension View {
    func banner(data: Binding<BannerViewModifier.BannerData?>) -> some View {
        self.modifier(BannerViewModifier(data: data))
    }
}
