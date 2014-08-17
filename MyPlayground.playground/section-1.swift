import UIKit
//字符串与字节转换
let s = "12345678"
var bytes = [Byte]()
for char in s.utf8{
    bytes.append(char ^ 88)
}
NSString(bytes: bytes, length: bytes.count, encoding: NSASCIIStringEncoding)
