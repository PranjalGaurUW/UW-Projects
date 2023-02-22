# UW-Projects

C# folder contains following code files:

The Dot NET Projects folder contains a Web API project built in .NET Core. The project implements WebAPI which perform CRUD operations on a In-Memory database of 'Products' (products in an online shopping store), such as fetch products by productId, get all products, update, delete, etc. along with pagination, filter and search functionalities. Entity Framework is used to support these operations. OAuth is used to authenticate user to enable access to DELETE API and only authorized user is allowed to delete a product.


The file for C# code SOLID implements the SOLID principles through:

Abstraction: The IShape interface defines a common interface for all the shapes.
Single Responsibility Principle: The Circle class has a single responsibility of defining the area of a circle.
Open/Closed Principle: The Rectangle class can be extended to other shapes such as Square without modifying its existing code.
Liskov Substitution Principle: The Square class can be used in place of the Rectangle class without any issues.
Dependency Inversion Principle: The AreaCalculator class depends on the abstraction IShape instead of concrete implementations of Circle, Rectangle, or Square.

The file 'Design Pattern-Singleton' implements the Singleton class that has a private constructor, which prevents direct instantiation. The Instance property provides the only way to access the single instance of the class and ensures that there is only one instance of the class created by using double-checked locking. The DoSomething method is an example of a functionality that can be added to the singleton instance.
The file: Design Pattern-factory demonstrates the Factory Pattern by creating a ShapeFactory class that returns objects of type IShape based on the string input provided. It returns a Circle object if the input is "CIRCLE" and a Square object if the input is "SQUARE".
