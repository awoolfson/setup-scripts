# Setup Scripts

This repository contains setup scripts for various project templates to quickly initialize new projects with commonly used configurations. Each script automates the process of setting up a new project with specific tools and technologies.

## Available Scripts

### 1. Go + Vite (React + TypeScript) + Tailwind

This script sets up a basic Go backend with a Vite-powered frontend using React, TypeScript, and Tailwind CSS. The setup includes:

- A Go web server using the `gin-gonic` framework.
- A React frontend with TypeScript and Vite.
- Tailwind CSS for styling the frontend.

#### Usage

1. Clone this repository:
    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```

2. Make the script executable (if necessary):
    ```bash
    chmod +x go-vite-setup.sh
    ```

3. Run the script with the desired directory and module name:
    ```bash
    ./go-vite-setup.sh <directory-name> <module-name>
    ```

4. Navigate to the new directory and start the Go server:
    ```bash
    cd <directory-name>
    go run server.go
    ```

5. In a separate terminal, navigate to the `client` directory and start the Vite development server:
    ```bash
    cd client
    npm install
    npm run dev
    ```

6. Open your browser and navigate to `http://localhost:3000` to view the app.

## Contributing

Feel free to submit issues or pull requests if you have suggestions for improvements or new templates to add.
