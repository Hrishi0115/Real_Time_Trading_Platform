// `Order` class: Represents a single order in our trading system
// In C#, classes are templates for creating objects, and they define the properties and methods that the object
// will have.

using System; 
// `importing` the `System` library - provides useful classes like `Console` or functions/methods such as `WriteLine`.
using System.ComponentModel.DataAnnotations.Schema;
// This directive is neccessary when we are working with `Entity Framework Core` or any other ORM (Object-Relational Mapping) that
// requires mapping between our C# classes and database tables. Specifically, this namespace contains attributes that help define
// how our C# class properties map to our database schema (needed for [C])



namespace OrderManagementService.Models
{
    // A namespace is a way to organize code into logical groups. Think of it as a folder for your classes.
    // The `Models` namespace here is where we will store all the data-related classes (like `Order`).

    public class Order
    // This class defines the structure of an order - each order will have properties like
    // `OrderId`, `Price`, `Quantity`, etc.
    // Class acts as a blueprint that defines how an order will look when it's stored in the database
    {
        // Properties: Each property in the class represents a piece of data that describes the order 
        // (maps to the `orders` table in `trading_platform` PostgreSQL database)
        [Column("order_id")] // Maps to order_id in `orders`
        public int OrderId {get; set;}
        // `get;` and `set;` are auto-implemented properties. They define a property (OrderId) in a class
        // (Order), which allows controlled access to a private field.
        // get: Getter for the property: It defines what happens when you access the value of the property, i.e., when you read it
        // set: Setter: defines what happens when you assign a value to the property (when you write it)
        // when you write `get; set;` like this in a property, C# automatically creates a private backing field for you behind the scenes.
        // allows you to use the `Getter`/`Setter` to access/modify the property using .OrderId, would have to manually
        // implement the getter and setter logic:

        // public class Order
        // {
        // `private int _orderId; // a private backing field
        // public int OrderId
        // {
        // get {return _orderId; } // Getter method
        // set {_orderId = value;} // Setter method
        // }
        
        [Column("user_id")]
        public int UserId {get; set;}

        [Column("portfolio_id")]
        public int PortfolioId {get; set;}

        [Column("instrument_id")]
        public int InstrumentId {get; set;}

        // *Error encountered: CS8618 - Non-nullable variable must contain a non-null value when exiting constructor. Consider declaring it as nullable.
        // Why this happens?
        // Value Types (int): In C#, value types (such as int) can never be null by default unless explicitly declared as nullable (e.g., int?).
        // When an instance of your class is created, value types like `UserId`, `PortfolioId`, etc., are automatically initialized to their default
        // value (in the case of `int`, this is 0).
        // Reference Types (string): Unlike value types, reference types (like string) can be null by default unless otherwise specified.
        // However, starting from C# 8.0, if nullable reference types are enabled in our project, C# assumes that a non-nullable reference type
        // (like string) must always have a non-null value unless we specifically declare it as nullable (using string?)
        // Since we are defining OrderDirection as a non-nullable string (string without ?), the compiler expects that it will be assigned a non-null value
        // before the constructor finishes executing. If we haven't explicitly assigned a value to OrderDirection by the time the constructor exists, it raises this warning.
        // Options to resolve this:
        // 1. Set a default value: public string OrderDirection {get; set;} = string.Empty; // or any default value
        // 2. Declare it as nullable: public string? OrderDirection {get; set;} (if OrderDirection can be null)
        // 3. 3. Use the required keyword - Starting from C# 11, we can use the required modifier to indicate that the property must be set
        // before exiting the constructor: public required string OrderDirection {get; set; }

        [Column("order_direction")]
        public required string OrderDirection {get; set;}

        [Column("order_type")]
        public required string OrderType {get; set;}

        [Column("quantity")]
        public decimal Quantity {get; set;}

        [Column("quantity_filled")]
        public decimal QuantityFilled {get; set;}

        
    }
}
