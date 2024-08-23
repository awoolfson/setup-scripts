#!/bin/bash

# Check if the directory name was provided
if [ -z "$1" ]; then
  echo "No directory name provided. Usage: ./script.sh <directory-name> <module-name>"
  exit 1
fi

# Check if the module name was provided
if [ -z "$2" ]; then
  echo "No module name provided. Usage: ./script.sh <directory-name> <module-name>"
  exit 1
fi

# Create and navigate to the specified directory
mkdir -p "$1"
cd "$1" || exit 1

echo "Scanning for dependencies..."

command -v go >/dev/null 2>&1 || { echo >&2 "go not found, exiting."; exit 1; }
command -v npm >/dev/null 2>&1 || { echo >&2 "npm not found, exiting."; exit 1; }
command -v yarn >/dev/null 2>&1 || { echo >&2 "yarn not found, exiting."; exit 1; }

# Initialize go module
go mod init "$2"
go get -u github.com/gin-gonic/gin
go get -u github.com/gin-gonic/contrib/static

# Write basig go web server
cat <<EOT > server.go
package main

import (
	"net/http"

	"github.com/gin-gonic/contrib/static"
	"github.com/gin-gonic/gin"
)

func main() {
	// Set the router as the default one shipped with Gin
	router := gin.Default()

	// Serve frontend static files
	router.Use(static.Serve("/", static.LocalFile("./client/dist", true)))

	// Setup route group for the API
	api := router.Group("/api")
	{
		api.GET("/", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{
				"message": "pong",
			})
		})
	}

	// Start and run the server
	router.Run(":5001")
}
EOT

# Initialize vite client
npm create vite@latest client -- --template react-ts
cd client

# Add tailwind to client
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Update server in vite config
cat <<EOT > vite.config.ts
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    origin: "http:127.0.0.1:5001",
  },
})
EOT

# Write to tailwind.config.js
cat <<EOT > tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOT

# Write to src/index.css
cat <<EOT > src/index.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOT

# Update default App.tsx
cat <<EOT > src/App.tsx
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
EOT

# Remove logo assets
rm src/assets/react.svg
rm public/vite.svg
