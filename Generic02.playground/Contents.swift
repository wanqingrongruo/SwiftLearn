import UIKit

var str = "Hello, 泛型和 Any"

/** 泛型和 Any
 *  Any 代替任何类型, 需要使用内省(Introspection)或者动态类型转换 将类型转换成一个具体的类型. Introspection???
 *  泛型可以解决上述问题, 并且可以优化编译器类型检查和提高运行时效率
 */

// Introspection: 内省, 向一个对象发出询问, 以确定它是不是某个类型.
// oc: isKindOf(:), isMemberOf(:), swift 中同样可以使用
// swift: is, 对类和 enum struct 都起作用

