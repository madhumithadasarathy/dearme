import SwiftUI

struct AppTypography {
    static func heading(size: CGFloat) -> Font {
        return .system(size: size, weight: .regular, design: .serif)
    }
    
    static func body(size: CGFloat) -> Font {
        return .system(size: size, weight: .regular, design: .default)
    }
}

extension View {
    func headingFont(size: CGFloat = 28) -> some View {
        self.font(AppTypography.heading(size: size))
    }
    
    func bodyFont(size: CGFloat = 16) -> some View {
        self.font(AppTypography.body(size: size))
    }
}
