import UIKit

var str = "Hello, playground"

/** 协议的特性
 * 1. 协议可以自行扩展功能. via extension
 * 2. 协议可以通过条件化扩展.
 * 3. 协议可以继承其他协议
 * 4. 通过组合形成新的协议
 * 5. 协议可以声明关联类型
 */

struct Eq<T> {
    let eq: (T, T) -> Bool
}

extension Array {
    // 比较数组元素是否全等
    func allEqual(_ compare: Eq<Element>) -> Bool {
        guard let f = first else { return true }
        for el in dropFirst() {
            guard compare.eq(f, el) else { return false }
        }

        return true
    }
}

let demo = [1, 2].allEqual(Eq(eq: { $0 == $1 }))
let demo02 = [1, 1].allEqual(Eq(eq: { $0 == $1 }))

extension Array where Element: Equatable {
    func allEqual() -> Bool {
        guard let f = first else { return true }
        for el in dropFirst() {
            guard f == el else { return false }
        }
        return true
    }
}

let demo03 = [1, 2].allEqual()


func eqArray<EL>(_ eqElement: Eq<EL>) -> Eq<[EL]> {
    return Eq { (arr01, arr02) -> Bool in
        guard arr01.count == arr02.count else { return false }
        for (l, r) in zip(arr01, arr02) {
            guard eqElement.eq(l, r) else { return false }
        }

        return true
    }
}
