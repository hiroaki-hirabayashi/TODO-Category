//
//  CornerRadius.swift
//  TODO-Category
//
//  Created by Hiroaki-Hirabayashi on 2022/01/23.
//

import SwiftUI

/// 四隅の角が丸いShape
struct CornerRadius: Shape {
    
    var topRight: CGFloat = 0.0
    var topLelt: CGFloat = 0.0
    var bottomRight: CGFloat = 0.0
    var bottomLeft: CGFloat = 0.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.size.width
        let height = rect.size.height
        let topRight = min(min(self.topRight, height / 2), width / 2)
        let topLelt = min(min(self.topLelt, height / 2), width / 2)
        let bottomRight = min(min(self.bottomRight, height / 2), width / 2)
        let bottomLeft = min(min(self.bottomLeft, height / 2), width / 2)
        
        // move 書き出しの位置 addLine 線を引く addArc 弧を描く
        // 画面上の中央、右上から右下までの線
        path.move(to: CGPoint(x: width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: width - topRight, y: 0))
        path.addArc(center: CGPoint(x: width - topRight, y: topRight), radius: topRight, startAngle: Angle(degrees: -90), endAngle:  Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: width, y: height - bottomRight))
        // 右下から画面下の中央に向かって弧を描く
        path.addArc(center: CGPoint(x: width - bottomRight, y: height - bottomRight), radius: bottomRight, startAngle: Angle(degrees: 0), endAngle:  Angle(degrees: 90), clockwise: false)
        // 左下までの線
        path.addLine(to: CGPoint(x: bottomLeft, y: height))
        // 左下から左上に向かって弧を描く
        path.addArc(center: CGPoint(x: bottomLeft, y: height - bottomLeft), radius: bottomLeft, startAngle: Angle(degrees: 90), endAngle:  Angle(degrees: 180), clockwise: false)
        // 左上までの線
        path.addLine(to: CGPoint(x: 0, y: topLelt))
        // 左上から画面上の中央に向かって弧を描く
        path.addArc(center: CGPoint(x: topLelt, y: topLelt), radius: topLelt, startAngle: Angle(degrees: 180), endAngle:  Angle(degrees: 270), clockwise: false)
        // pathを閉じる
        path.closeSubpath()
        
        return path
        
    }
}

struct cornerRadius_Previews: PreviewProvider {
    static var previews: some View {
        CornerRadius(topRight: 30, topLelt: 30, bottomRight: 30, bottomLeft: 30).stroke().padding()
    }
}
