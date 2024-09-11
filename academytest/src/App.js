import './App.css';
import { useState, useEffect } from 'react';
import { Test, Question, TestError } from "./Test";
import { GoogleGenerativeAI } from "@google/generative-ai";

function App() {
  const [currentPhase, setCurrentPhase] = useState("title")
  const [testData, setTestData] = useState(new Test())
  const [currentPage, setCurrentPage] = useState(0)
  const [isLoading, setIsLoading] = useState(false)
  const [flags, setFlags] = useState([false, false, false, false, false, false, false, false, false, false])
  const [answers, setAnswers] = useState([0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
  const [wrongQuestions, setWrongQuestions] = useState([])
  const [minutes, setMinutes] = useState(20)
  const [seconds, setSeconds] = useState(0)
  const genAI = new GoogleGenerativeAI(process.env.REACT_APP_GEMINI_KEY);
  const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" });

  const getResponseForGivenPrompt = async () => {
    const result = await model.generateContent(
      `
      Generate 10 quiz questions in JSON format, following this structure:

      { "questions": [ { "text": "Question text", "opt1": "Option 1", "opt2": "Option 2", "opt3": "Option 3", "opt4": "Option 4", "answer": Correct option int (1, 2, 3, or 4) } ] }

      The first 5 questions should be medium to advanced logic problems, similar to questions like:

      - 'Consider this series of numbers: 8, 6, 9, 23, 87... What number should come next in the series?'
      - 'If I throw a 6 faced die, what is the probability of obtaining 5 or 6?'
      - 'In the system of equations below, what is the value of x? 2x + 2y = -4, 4x + y = 1'
      - 'If Luisa was 32 years old 8 years ago, how old was she x years ago?'
      - 'Look at your hands: you have 10 fingers! How many fingers do 10 hands have?'
      - 'Six foxes catch six hens in six minutes. How many foxes will be needed to catch sixty hens in sixty minutes?'
      - 'Which number is missing from this sequence? 32 31 32 29 32 27 32  … 32'

      The last 5 questions should cover object-oriented programming (OOP) concepts, ranging from medium to advanced, following examples like:

      - 'In the OOP paradigm, how do we call the property of having the same operation (method) behaving differently (override) in each descendant class OR having the same operation/method with different signatures (overload)?'
      - 'Inheritance allows sharing attributes and methods by classes and they are used mainly with the goal of reusing code or to define a general behavior for an object of this class and descendants. Is this statement correct?'
      - 'What is a computed property?'
      - 'What is the initializer function?'
      - 'What is class method?'
      - 'What is the difference between a class and an object?'
      - 'In the OOP paradigm, attributes define...'
      - 'In the OOP paradigm, it is true that..'
      - 'In the OOP paradigm, the definitions which are the base to create objects are called...'
      - 'In the OOP paradigm, the overload of a method is related to the OOP property called...'

      You should generate NEW questions similar to these, not those!!
      You are giving me a lot of incorrect answers, specially in the logic session, so make sure to double check the answers

      Ensure that the output is a valid JSON format, with exactly 10 questions, each having 4 options, one correct answer, and follows the structure exactly as specified. DONT use markdown or '''json
      Dont USE '''JSON it is breaking the app!!!!
      `
    );
    const response = await result.response;
    return await response.text();
  }

  const generateTest = async () => {
    setIsLoading(true)
    const prompt = await getResponseForGivenPrompt()
    console.log(prompt)
    try {
      const data = JSON.parse(prompt)
      await setTestData(data)
      setCurrentPage(1)
      setCurrentPhase("test")
    } catch (error) {
      console.log(error)
      setCurrentPhase("error")
    }
    setIsLoading(false)
  }

  const quizGuess = (guess) => {
    setAnswers((prevAnswers) => {
      const newAnswers = [...prevAnswers];
      newAnswers[currentPage - 1] = guess;
      return newAnswers;
    });
  }

  const getResults = async () => {
    var errors = []
    for (let i = 0; i < testData.questions.length; i++) {
      if (testData.questions[i].answer !== answers[i]) {
        var error = new TestError(testData.questions[i].text, null, null)
        switch (answers[i]) {
          case 1:
            error.guess = testData.questions[i].opt1
            break
          case 2:
            error.guess = testData.questions[i].opt2
            break
          case 3:
            error.guess = testData.questions[i].opt3
            break
          case 4:
            error.guess = testData.questions[i].opt4
            break
          default:
            error.guess = "no guess"
        }

        switch (testData.questions[i].answer) {
          case 1:
            error.answer = testData.questions[i].opt1
            break
          case 2:
            error.answer = testData.questions[i].opt2
            break
          case 3:
            error.answer = testData.questions[i].opt3
            break
          default:
            error.answer = testData.questions[i].opt4
        }
        console.log(error.question)
        await errors.push(error)
      }
    }
    await setWrongQuestions(errors)
    setCurrentPhase("result")
  }

  const flagQuestion = async (question) => {
    let copyFlags = [...flags]
    if (flags.includes(question)) {
      await copyFlags.pop(question)
    } else {
      await copyFlags.push(question)
    }
    await setFlags(copyFlags)
  }

  function formatTime(time) {
    return time < 10 ? "0" + time : time;
  }

  const reset = async () => {
    await setTestData(new Test())
    await setCurrentPage(0)
    await setIsLoading(false)
    await setFlags([false, false, false, false, false, false, false, false, false, false])
    await setAnswers([0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
    await setWrongQuestions([])
    await setMinutes(20)
    await setSeconds(0)
    await setCurrentPhase("title")
  }

  const title = (
    <div className='title'>
      <img src='./logo.png' alt='logo' />
      <div className='title-text'>Apple Developer Academy Mock Test</div>
      <div className='title-sub'>designed and developed by <a href='https://caioagralemos.com/en' rel='noreferrer' target='_blank'>@caioagralemos</a></div>
      <div className='title-button' disabled={!isLoading} onClick={generateTest}>{isLoading ? <img style={{ height: "23px", width: "45px", objectFit: "contain" }} src='./spinner.svg' alt='spinner' /> : "Start"}</div>
    </div>
  )

  const test = (
    <>
      <nav className='navbar'>
        <img src="./logo.png" alt="logo" className='icon' onClick={reset} />
        <div className='timer' onClick={() => setMinutes(0)}>{formatTime(minutes)}:{formatTime(seconds)}</div>
      </nav>
      <div className='test'>
        <div className='indexes'>
          {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((item, index) => (
            <div key={item} className={`index ${answers[item - 1] !== 0 ? "done" : ""} ${flags.includes(item) ? "flagged" : ""} ${currentPage === item ? "index-selected" : ""}`} onClick={() => (setCurrentPage(item))}>{item}</div>
          ))}
        </div>

        <div className='quiz'>
          <div className="quiz-question">
            {testData.questions && testData.questions.length > 0 ? (
              testData.questions[currentPage - 1].text
            ) : (
              "Carregando..."
            )}
          </div>
          <div className="quiz-options">
            {
              answers[currentPage - 1] === 1 ?
                <div className={`quiz-option ${answers[currentPage - 1] === 1 ? "selected" : ""}`} onClick={() => quizGuess(1)}>
                  {testData.questions && testData.questions.length > 0 ? (
                    testData.questions[currentPage - 1].opt1
                  ) : (
                    "Carregando..."
                  )}
                </div> : <div className='quiz-option' onClick={() => quizGuess(1)}>
                  {testData.questions && testData.questions.length > 0 ? (
                    testData.questions[currentPage - 1].opt1
                  ) : (
                    "Carregando..."
                  )}
                </div>
            }
            {
              answers[currentPage - 1] === 2 ?
                <div className='quiz-option selected' onClick={() => quizGuess(2)}>
                  {testData.questions && testData.questions.length > 0 ? (
                    testData.questions[currentPage - 1].opt2
                  ) : (
                    "Carregando..."
                  )}
                </div> : <div className='quiz-option' onClick={() => quizGuess(2)}>
                  {testData.questions && testData.questions.length > 0 ? (
                    testData.questions[currentPage - 1].opt2
                  ) : (
                    "Carregando..."
                  )}
                </div>
            }
            {
              answers[currentPage - 1] === 3 ?
                <div className='quiz-option selected' onClick={() => quizGuess(3)}>
                  {testData.questions && testData.questions.length > 0 ? (
                    testData.questions[currentPage - 1].opt3
                  ) : (
                    "Carregando..."
                  )}
                </div> : <div className='quiz-option' onClick={() => quizGuess(3)}>
                  {testData.questions && testData.questions.length > 0 ? (
                    testData.questions[currentPage - 1].opt3
                  ) : (
                    "Carregando..."
                  )}
                </div>
            }
            {
              answers[currentPage - 1] === 4 ?
                <div className='quiz-option selected' onClick={() => quizGuess(4)}>
                  {testData.questions && testData.questions.length > 0 ? (
                    testData.questions[currentPage - 1].opt4
                  ) : (
                    "Carregando..."
                  )}
                </div> : <div className='quiz-option' onClick={() => quizGuess(4)}>
                  {testData.questions && testData.questions.length > 0 ? (
                    testData.questions[currentPage - 1].opt4
                  ) : (
                    "Carregando..."
                  )}
                </div>
            }
          </div>
          <img src='flag.svg' alt='flag' onClick={() => flagQuestion(currentPage)} className={`flag ${flags.includes(currentPage) ? "selected" : ""}`} />
        </div>

        {answers.includes(0) ? <></> :
          <div className='test-done' onClick={getResults}>
            Done
          </div>
        }
      </div>
    </>
  )

  const result = (
    <>
      <nav className='result-navbar'>
        <img src="./logo.png" alt="logo" className='icon' onClick={reset} />
        <div className='timer'>{10 - wrongQuestions.length}/10</div>
      </nav>
      <div className='result'>
        <div className='result-box'>
          <div className='result-score'>{10 - wrongQuestions.length}/10</div>
          <div className='result-button' onClick={reset}>
            Try Again
          </div>
        </div>
        {wrongQuestions.length > 0 && <div className='wronganswer-title'>Correct your mistakes</div>}
        {wrongQuestions.length > 0 && wrongQuestions.map((item, index) => {
          return <div className='wronganswer'>
            <div className='wronganswer-question'>{item.question}</div>
            <div className='wronganswer-answer'>the answer: {item.answer}</div>
            <div className='wronganswer-guess'>your guess: {item.guess}</div>
          </div>
        })}
      </div>
    </>
  )

  const error = (
    <div className='error' onClick={() => setCurrentPhase("title")}>
      Something went wrong.
    </div>
  )

  useEffect(() => {
    let interval = null;
    if (currentPhase === "test" && (minutes > 0 || seconds > 0)) {
      interval = setInterval(() => {
        if (seconds === 0) {
          if (minutes > 0) {
            setMinutes((prevMinutes) => prevMinutes - 1);
            setSeconds(59);
          }
        } else {
          setSeconds((prevSeconds) => prevSeconds - 1);
        }
      }, 1000);
    } else if (currentPhase !== "test" && (minutes !== 0 || seconds !== 0)) {
      clearInterval(interval);
    } else if (minutes === 0 && seconds === 0) {
      getResults();
    }
    return () => clearInterval(interval);
  }, [currentPhase, seconds, minutes]);

  return (
    <div className="App">
      {currentPhase === "title" ?
        title
        : null}
      {currentPhase === "test" ?
        test
        : null}
      {currentPhase === "result" ?
        result
        : null}
      {currentPhase === "error" ?
        error
        : null}
    </div>
  );
}

export default App;
