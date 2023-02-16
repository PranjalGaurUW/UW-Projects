public interface IShape
{
    void Draw();
}

public class Circle : IShape
{
    public void Draw()
    {
        Console.WriteLine("Drawing Circle");
    }
}

public class Square : IShape
{
    public void Draw()
    {
        Console.WriteLine("Drawing Square");
    }
}

public class ShapeFactory
{
    public IShape GetShape(string shapeType)
    {
        if (shapeType == null)
        {
            return null;
        }
        if (shapeType.Equals("CIRCLE", StringComparison.OrdinalIgnoreCase))
        {
            return new Circle();
        }
        else if (shapeType.Equals("SQUARE", StringComparison.OrdinalIgnoreCase))
        {
            return new Square();
        }
        return null;
    }
}

class Program
{
    static void Main(string[] args)
    {
        ShapeFactory shapeFactory = new ShapeFactory();

        IShape shape1 = shapeFactory.GetShape("CIRCLE");
        shape1.Draw();

        IShape shape2 = shapeFactory.GetShape("SQUARE");
        shape2.Draw();

        Console.ReadLine();
    }
}
