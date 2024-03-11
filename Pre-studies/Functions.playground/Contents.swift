import Cocoa

// Funções
// Sintaxe func nomeDaFunc(param: tipoParam) -> tipoRetorno

// Argument Labels são palavras que a gente pode passar antes do nome da var para ser uma label na hora de passar os parametros
// _ como argument label: Omite o prefixo quando chamando a func
func greet(_ person: String, from hometown: String) -> String {
    return "Olá, \(person)! Adoramos receber visitas de \(hometown)"
}

greet("Caio", from: "Maceió")

// Default values
func soma(_ num1: Int, _ num2: Int = 0) -> Int {
    return num1 + num2
}

soma(3)

// Tipos de Funções (Signatures)

func multiplicar(_ num1: Int, _ num2: Int = 0) -> Int {
    return num1 * num2
} // tipo (Int, Int) -> Int

func helloWorld() {
    print("Olá, mundo!")
} // tipo () -> void

// Podemos passar tipos pra funcs assim como em variáveis

var funcMat: (Int, Int) -> Int;
funcMat = soma


// Funcs como parametros

func checagem(_ nums: [Int], condition: (Int) -> Bool) -> Bool {
    for num in nums {
        if condition(num) { return true }
    }
    return false
}

func umADez(_ num: Int) -> Bool {
    return num >= 1 && num <= 10
}

checagem([3,1,2,4,5,2], condition: umADez)
checagem([12,0,444,-2,33], condition: umADez)


/*
  ___             _   _              _                  _
 | __|  _ _ _  __| |_(_)___ _ _     /_\  _ _ __ __ _ __| |___
 | _| || | ' \/ _|  _| / _ \ ' \   / _ \| '_/ _/ _` / _` / -_)
 |_| \_,_|_||_\__|\__|_\___/_||_| /_/ \_\_| \__\__,_\__,_\___|

 */

/*
🕹 Min

Write a function named min2 that takes two Int values, a and b, and returns the smallest one. Use _ to ignore the external parameter names for both a and b.
 
 > min(1,2)
 > 1
*/

func min(_ n1: Int, _ n2: Int) -> Int {
    return n1 < n2 ? n1 : n2
}


/*
🕹 Last Digit

Write a function that takes an Int and returns it’s last digit. Name the function lastDigit. Use _ to ignore the external parameter name.

 > lastDigit(12345)                     Hint: % modulus operator
 > 5
 */

func lastDigit(_ n: Int) -> Int{
//    return String(n).last!.wholeNumberValue!
    return n % 10
}

lastDigit(12345)

/*
🕹 First Numbers

Write a function named first that takes an Int named N and returns an array with the first N numbers starting from 1. Use _ to ignore the external parameter name.

 > first(3)
 > [1, 2, 3]
*/

func first(_ n: Int) -> [Int] {
    var array: [Int] = []
    for num in 1...n {
        array.append(num)
    }
    return array
}

first(3)

/*
🕹 Reverse

Write a function named reverse that takes an array of integers named numbers as a parameter. The function should return an array with the numbers from numbers in reverse order.

 > reverse([1, 2, 3])
 > [3, 2, 1]
 */


func reverse (_ nums: [Int]) -> [Int] {
    var a = nums
    a.reverse()
    return a
}

 reverse([1,2,3])

/*
🕹 Sum

Write a function named sum that takes an array of integers and returns their sum. Use a label variable of the word 'of' and a parameter label named numbers.

 > sum(of: [1, 2, 3])
 > 6
 */

func sum(of nums: [Int]) -> Int {
    var soma = 0
    for num in nums {
        soma += num
    }
    return soma
}

sum(of: [1,2,4])
