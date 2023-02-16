# UW-Projects
Postgres folder contains SQL code developed by me to help develop Database layer during my Co-op. (The code does not contain any company proprietary information). There are scripts for SQL procedures, triggers and functions which helped me in accomplishing my tasks of setting up a database system capable of managing blockchain based transactions and calculating valuations from such transactions.

C# folder contains following code files:

The file for C# code SOLID implements the SOLID principles through:
Abstraction: The IShape interface defines a common interface for all the shapes.
Single Responsibility Principle: The Circle class has a single responsibility of defining the area of a circle.
Open/Closed Principle: The Rectangle class can be extended to other shapes such as Square without modifying its existing code.
Liskov Substitution Principle: The Square class can be used in place of the Rectangle class without any issues.
Dependency Inversion Principle: The AreaCalculator class depends on the abstraction IShape instead of concrete implementations of Circle, Rectangle, or Square.


The file: Design Pattern-Singleton  implements the Singleton class that has a private constructor, which prevents direct instantiation. The Instance property provides the only way to access the single instance of the class and ensures that there is only one instance of the class created by using double-checked locking. The DoSomething method is an example of a functionality that can be added to the singleton instance.
The file: Design Pattern-factory demonstrates the Factory Pattern by creating a ShapeFactory class that returns objects of type IShape based on the string input provided. It returns a Circle object if the input is "CIRCLE" and a Square object if the input is "SQUARE".


Data Science Projects folder contains following projects:

Project contained in 'Exploratory Data Analysis - Cricket' folder involves exploratory data analysis on a sample of cricket matches data scraped from the web. The analysis includes - analyzing behavior of batting and bowling across innings and teams in a T20 game, generating a 20-ball highlights of second innings of each game (that shows turning points of the game- such as wickets/outs, fours, sixes etc.), clustering games based on scores, optimizing Duckworth-Lewis method to generate our own based on sample data.
The results are present in the 'STAT-847-Final-Project.Pdf' document. The code containing the analysis is present in the R markdown file 'STAT-847-Final-Project.Rmd'.

Project contained in 'Quantitative Data Analysis Project - R' folder is based on Regression analysis. Performed quantitative analysis on Canada population survey data by implementing regression models (linear and ordinal logistic regression) in R to study the effects of social factors on covid vaccine acceptance likelihood.

