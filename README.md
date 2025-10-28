#  Simple Flutter Calculator App

This is a simple calculator app built using **Flutter**.  
It performs all the basic math operations like addition, subtraction, multiplication, and division — with a clean, easy-to-use layout.

##About the App

I made this app to practice Flutter basics like widgets, state management, and UI layouts.  
It’s a single-screen calculator where users can type numbers and operations just like a normal calculator.  
The app also handles small errors like invalid input and division by zero.

##Features

 Perform basic arithmetic:  
- Addition (+)  
- Subtraction (-)  
- Multiplication (×)  
- Division (÷)  
- Percentage (%)  

 Other functions:
- **C** – clears all input  
- **** – deletes the last entered character  
- **.** – for decimal numbers  
- **=** – calculates the final result  

 Clean interface with large buttons and simple layout  
Works on mobile and web (with a small setup change)


## Folder Structure
my_calculator/
│
├── lib/
│ └── main.dart # main code file for the calculator UI and logic
│
├── pubspec.yaml # contains app name, Flutter SDK, and dependencies
│
└── README.md # this file

##  How It Works (Quick Overview)

- The main calculator logic is handled inside `main.dart`.  
- It uses **setState()** to update the display when numbers or operators are clicked.  
- There’s a small built-in math parser that converts the input expression into Reverse Polish Notation (RPN) and then evaluates it.  
- For example:  
  - If you enter `2 + 3 × 4`, it first converts it internally to `2 3 4 × +`, then evaluates it correctly as `14`.

##  How to Run the App

Make sure you have **Flutter** installed on your computer.

1. **Open the folder** in VS Code or Android Studio  
   ```bash
   cd "C:\Users\Het\Desktop\my calculator"
### use ai to understand the code and solve the error 
### use gpt to generate the idea and while bulding the app i got stuck at some code in main file so i use gpt to hendle it 
### also i use gpt to structure my readme file 
