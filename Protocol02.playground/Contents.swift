import UIKit
import CoreGraphics

var str = "Hello, 使用协议进行设计"

protocol DrawingContext {
    mutating func addEllipse(rect: CGRect, fillColor: UIColor)
    mutating func addRectangle(rect: CGRect, fillColor: UIColor)
}

extension CGContext: DrawingContext {
    func addEllipse(rect: CGRect, fillColor: UIColor) {
        setFillColor(fillColor.cgColor)
        fillEllipse(in: rect)
    }

    func addRectangle(rect: CGRect, fillColor: UIColor) {
        setFillColor(fillColor.cgColor)
        fill(rect)
    }
}


extension DrawingContext {
    mutating func addCircle(center: CGPoint, radius: CGFloat, fill: UIColor) {
        let diameter = radius * 2
        let origin = CGPoint(x: center.x - radius, y: center.y - radius)
        let size = CGSize(width: diameter, height: diameter)
        let rect = CGRect(origin: origin, size: size)
        addEllipse(rect: rect.integral, fillColor: fill)
    }

    mutating func drawSomething() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        addRectangle(rect: rect, fillColor: .yellow)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        addCircle(center: center, radius: 25, fill: .blue)
    }
}

// 只需实现协议的几个方法就能免费获得协议扩展中的所有功能
/**
 “带有默认实现的协议方法在 Swift 社区中有时也叫做定制点 (customization point)。实现协议的类型会收到一份方法的默认实现，并有权决定是否要对其进行覆盖”

 摘录来自: Chris Eidhof. “Swift 进阶。” Apple Books.
 */


// 协议继承: Comparable and Equalable

// 协议组合: Codable = Encodable & Decodable

// 协议和关联类型

protocol ViewController {}

protocol Restorable {
    associatedtype State: Codable
    var state: State { get set}
}

class MessageViewController: ViewController, Restorable {
    struct MessageState: Codable {
        var messages: [String] = []
        var scrollPoint: CGFloat = 0
    }

    typealias State = MessageState

    var state: State = MessageState()
}

// 存在关联类型的协议以及存在.Self约束的协议只能作为类型约束使用,不能作为一种类型使用了
// 作为类型使用时编译器将协议优化成了有确定大小的存在体. 存在体大小随着类型实现协议的增加而增大
// 固定大小: 32 + n*8 字节
