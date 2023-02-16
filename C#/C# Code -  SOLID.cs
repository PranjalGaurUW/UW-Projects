using System;

//Abstraction
interface IShape
{
    double Area();
}

//Single Responsibility Principle
class Circle : IShape
{
    double radius;

    public Circle(double r)
    {
        radius = r;
    }

    public double Area()
    {
        return Math.PI * radius * radius;
    }
}

//Open/Closed Principle
class Rectangle : IShape
{
    double length;
    double width;

    public Rectangle(double l, double w)
    {
        length = l;
        width = w;
    }

    public double Area()
    {
        return length * width;
    }
}

//Liskov Substitution Principle
class Square : Rectangle
{
    public Square(double side) : base(side, side) { }
}

//Dependency Inversion Principle
class AreaCalculator
{
    private IShape[] shapes;

    public AreaCalculator(IShape[] shapes)
    {
        this.shapes = shapes;
    }

    public double TotalArea()
    {
        double total = 0;
        foreach (IShape shape in shapes)
        {
            total += shape.Area();
        }
        return total;
    }
}

class Program
{
    static void Main(string[] args)
    {
        IShape[] shapes = { new Circle(5), new Rectangle(2, 3), new Square(5) };
        AreaCalculator calculator = new AreaCalculator(shapes);
        Console.WriteLine("Total Area: " + calculator.TotalArea());
    }
}