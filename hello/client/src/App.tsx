import { useState } from 'react'
import './App.css'

async function testApi() {
  try {
    const response = await fetch("/api")
    if (!response.ok) {
      console.error("HTTP error");
      return {};
    }
    const json = await response.json()
    return json
  } catch (error) {
    console.error("Error: ", error);
    return {};
  }
}

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <h1 className="bg-gray-100">GO VITE DEFAULT APP</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
      {console.log(testApi())}
    </>
  )
}

export default App
