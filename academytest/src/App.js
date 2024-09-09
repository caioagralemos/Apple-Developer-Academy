import logo from './logo.svg';
import './App.css';
import { useState } from 'react';

function App() {
  const [currentPhase, setCurrentPhase] = useState("title")
  const [currentPage, setCurrentPage] = useState(0)
  const [flags, setFlags] = useState([])

  const generateTest = () => {

  }

  const title = (
    <div className='title'>
      <img src='./logo.png' alt='logo' />
      <div className='title-text'>Apple Developer Academy Mock Test</div>
      <div className='title-button' onClick={null}>Start</div>
    </div>
  )

  const 
  return (
    <div className="App">
      {currentPhase === "title" ? 
        title
      : null}
    </div>
  );
}

export default App;
