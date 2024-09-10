export class Test {
    constructor (questions) {
        this.questions = questions // [Question]
    }
}

export class Question {
    constructor (text, opt1, opt2, opt3, opt4, answer) {
        this.text = text // string (question)
        this.opt1 = opt1 // string (alternative)
        this.opt2 = opt2 // string (alternative)
        this.opt3 = opt3 // string (alternative)
        this.opt4 = opt4 // string (alternative)
        this.answer = answer // 1, 2, 3 or 4
    }
}

export class TestError {
    constructor (question, guess, answer) {
        this.question = question
        this.guess = guess
        this.answer = answer
    }
}