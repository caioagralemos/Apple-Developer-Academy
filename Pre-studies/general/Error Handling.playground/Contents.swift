// ### ERROR HANDLING ###
// Tratamento de erros em swift. Dividiremos aqui entre erros recuperaveis (não fatais) e fatais

/*
 There are four ways to handle errors in Swift:
- Propogate the error with a throw
- Handle the error with a do-catch
- Return an optional, or assert that the error will not occcur
- Returning an error via completion handler block
*/

// Exemplo de Erro
enum ErroInscricao: Error {
    case naoMatriculado, nivelInsuficiente(periodo: Int), cursoLotado
}

struct Aluno {
    let matriculado = false
    let periodo = 2
    let nome = "Fulano"
}

protocol Curso {
    var perMinimo: Int { get set }
    var capacidade: Int { get set }
    var nome: String { get set }
    mutating func inscricao(_ aluno: Aluno) throws
}

var alunos = [Aluno]()

extension Curso {
    func inscricao(_ aluno: Aluno) throws { // a keyword throws indica que pode gerar um erro
        guard aluno.matriculado else {
            throw ErroInscricao.naoMatriculado
        }
        guard aluno.periodo >= self.perMinimo else {
            throw ErroInscricao.nivelInsuficiente(periodo: aluno.periodo)
        }
        guard self.capacidade > alunos.count else {
            throw ErroInscricao.cursoLotado
        }
        alunos.append(aluno)
    }
}

struct Discreta: Curso {
    var perMinimo: Int = 2
    var capacidade: Int = 5
    var nome = "Matemática Discreta"
}

// Use isso para pegar os erros
class MatriculaHandler {
    func enroll(_ student: Aluno, inCourse course: Curso) {
        do {
            try course.inscricao(student)
            print("Inscreveu \(student.nome) em \(course.nome) com sucesso!")
        } catch ErroInscricao.naoMatriculado {
            print("Não foi possivel inscrever \(student.nome) pois não está matriculado")
        } catch ErroInscricao.nivelInsuficiente(periodo: student.periodo) {
            print("Não foi possivel inscrever \(student.nome). Tem que chegar pelo menos ao \(student.periodo)º período.")
        } catch ErroInscricao.cursoLotado {
            print("Não foi possivel inscrever \(student.nome). O curso já está cheio")
        } catch {
            print("Cheque seus dados e tente novamente")
        }
    }
}

MatriculaHandler().enroll(Aluno(), inCourse: Discreta())

// Erros não recuperáveis
// assert() - debug builds / won't 💥 program in production
func printAge(_ age: Int) {
    assert(age >= 0, "Age can't be a negative value")

    print("Age is: ", age)
}

// assertionFailure() - debug builds
func printAge2(_ age: Int) {
    guard age >= 0 else {
        assertionFailure("Age can't be a negative value")
        return
    }
    print("Age is: ", age)
}

// precondition() - debug builds / release 💥
func printAge3(_ age: Int) {
    precondition(age >= 0, "Age can't be a negative value")

    print("Age is: ", age)
}

// preconditionFailure() - debug builds / release 💥
func printAge4(_ age: Int) {
    guard age >= 0 else {
        preconditionFailure("Age can't be a negative value")
    }
    print("Age is: ", age)
}

// fatalError() - hard stop all builds 💥
func printAge5(_ age: Int) {
    guard age >= 0 else {
        fatalError("Age can't be a negative value")
    }
    print("Age is: ", age)
}

/*
  ___                     _                  _
 | __|_ _ _ _ ___ _ _    /_\  _ _ __ __ _ __| |___
 | _|| '_| '_/ _ \ '_|  / _ \| '_/ _/ _` / _` / -_)
 |___|_| |_| \___/_|   /_/ \_\_| \__\__,_\__,_\___|

 */

import Foundation

/*
🕹 Bad Bill - Error.

 Create an error called `BillError` and give it a single case called `negativeAmount`.

 */

enum BillError: Error {
    case negativeAmount
}

/*
🕹 Bad Bill - throws.

 Write a method called payBill that takes an Double amount, and throws an `negativeAmount` error if the bill is a negative amount.
 If the bill is not negative simply print out the amount.
 Then call the method x3 ways - try, try?, try!.

 */

func payBill(_ value: Double) throws {
    if value >= 0 {
        print(value)
    } else {
        throw BillError.negativeAmount
    }
}

do {
    try payBill(-7.2)
} catch BillError.negativeAmount {
    print("Não aceitamos valores negativos!")
}

try? payBill(-31.2) // retorna nil
try! payBill(31.2) // negativo - quebra o programa (mesmo com handling)

/*
🕹 Bad Bill - programmer error

 Take the payBill you just created, and re-write it to genereate a programmer error (assert() or preCondition())
 instead of throwing an error.

 Discussion: What are the differences between these two techniques? Which do you prefer? Why?

 */

func payBill2(_ value: Double) {
    assert(value >= 0, "Não aceitamos valores negativos!") // bom pra debug
    //precondition(value >= 0, "Não aceitamos valores negativos!")
    print(value)
}

payBill2(7.2) // negativo - dá erro e detalha o erro no terminal
