import UIKit
//字符串与字节转换
let s = "12345678"
var bytes = [UInt8]()
for char in s.utf8{
    bytes += [char ^ 88]
}


print("This is wild", terminator: "")
print("world")










