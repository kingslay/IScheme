import UIKit
//字符串与字节转换
let s = "12345678"
var bytes = [UInt8]()
for char in s.utf8{
    bytes += [char ^ 88]
}


for i in stride(from: 0.0, through: 360, by: 1.0) {

}

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
}
var addd = "Hello, playground"

println(addd[0...5]) // ==> "Hello,"














