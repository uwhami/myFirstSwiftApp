import UIKit

var greeting = "Hello, playground"

//변수
var name: String = "swift"
print("\(name)")
name = "123"
print("\(name)")

//상수
let age: Int = 8
//age = 9 //let 은 바꿀수 없다며 -> 엄청 느리게 반응함.
print("\(age)")

//옵셔널 Optional = nil값을 반영할 수 있다.
var name2: String? = nil
//print("\(name2)")

// nil check
if name2 != nil {
    print("\(name2!)")
}else{
    print("name2 is nil !!!")
}

// optional binding
if let nm = name2 {
    print("\(nm)")
}

// guard let
func checkGuard(){
    var name2: String? = nil
    guard let nm = name2 else{
        print("func nm name2 is nil !!")
        return
    }
    print("func nm name2 is not nil !!!")
}

//데이터 타입(Type)
//Boolean - true, false
let isSwift: Bool = true
let isNotSwift: Bool = false

if isSwift {
    
}
else{
    
}

//string literals
var str: String = "WelcomeToSwift"
//줄바꿈이 가능함.
var multiStr = """
hello Swift
I'm Senti
"""

if str == "WelcomeToSwift" {
    print("\(str)")
}
else{
    print(" 다름 ")
}

//Collection - Array
var arrNum1: [Int] = []
var arrNum2 = Array<Int>()
var arrNum3 = [1,2,3]
arrNum1.append(1)
arrNum1.append(3)
arrNum1.append(2)
for item in arrNum1{
    print("\(item)")
}

for (index, value) in arrNum1.enumerated() {
    print("\(index) :: \(value)")
}

//Dictionary - key value (JSON)
var dic: [String:String] = ["name":"swift", "version:":"5"]

for(keyName, val) in dic{
    print("\(keyName) :: \(val)")
}
for key in dic.keys {
    print("key: \(key)")
}
for val in dic.values {
    print("val: \(val)")
}

//값이 nill 이면 다르게 출력
print("\(dic["name"] ?? "nil..")")

//Tuple
let status = (100, "Success")
let resultStatus = (resultCode: 100, resultDesc: "Success")
let tupleDic = (100,["":""])

print("status.0 : \(status.0)")
print(status.1)

print()
print(tupleDic.1)
print()

print(resultStatus.resultCode)
print(resultStatus.resultDesc)

// 논리 연산
var isSwift2 = true
var isNotSwift2 = false

//할당
isSwift2 = isNotSwift2
var status2 = (100, "Success")
status2 = (404, "fail")

//and
if isSwift && isNotSwift {
    
}
if isSwift, isNotSwift{
    
}

//or
if isSwift || isNotSwift {
    
}

// 길이연산
var greeting2 = "Hello, playground"

// range
for item in 1 ... 5 {
    print(item)
}

print("---------")
let arr = ["hello", "welcome", "to", "swift"]
let cnt = arr.count
for i in 0 ..< cnt {
    print("arr \(i) is \(arr[i]) ")
}

// 함수
func hello(age:Int, name: String = "swift") -> String {
    let hello = "Hello, " + name + " age : \(age)"
    return hello
}

func hello2(_ name: String) -> String {
    let hello = "Hello, " + name
    return hello
}

print(hello(age:8, name: "swift1"))
print(hello(age:8)) //name은 = 를 넣어서 기본값 지정.
print(hello2("swift2")) // 언더바를 넣어서 변수명을 넣지 않아도 됨.

func test(testAge age:Int, testName name:String) -> String{
    return "\(age) : \(name)"
}
print(test(testAge: 8, testName: "123"));


