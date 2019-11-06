import UIKit

var str = "Hello, Generic"

/** 多态编程 polymorphism
 * 1. 重载(overloading): 相同函数名, 不同参数类型,不通车参数个数
 * 2. 重写(override): 多继承
 * 3. 泛型(generic): 泛型类型,泛型方法
 * 4. 协议(protocol): 多个类型遵从同个协议,实现协议方法
 */


enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}

let op: Optional<Int> = .some(10) // 使用时必须明确泛型的具体类型


enum BinaryTree<Element> {
    case leaf
    indirect case node(Element, left: BinaryTree<Element>, right: BinaryTree<Element>)
}

let tree: BinaryTree<Int> = .node(4, left: .leaf, right: .leaf)

// BinaryTree 作用域内, Element都可以作为一个类型使用
extension BinaryTree {
    init(_ value: Element) {
        self = .node(value, left: .leaf, right: .leaf)
    }

    // 所有节点值的数组
    var values: [Element] {
        switch self {
        case .leaf:
            return []
        case let .node(el, l, r):
            return l.values + [el] + r.values
        }
    }

    // 构造新类型二叉树
    func map<T>(_ transform: (Element) -> T) -> BinaryTree<T> {
        switch self {
        case .leaf:
            return .leaf
        case let .node(el, l, r):
            return .node(transform(el), left: l.map(transform), right: r.map(transform))
        }
    }
}


let shiftTree: BinaryTree<Int> = tree.map { $0 + 1 }
let stringTree: BinaryTree<String> = tree.map { "\($0)" }


