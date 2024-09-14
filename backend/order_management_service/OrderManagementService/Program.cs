// Program.cs: An entry point to creating an API in ASP.NET Core (framework for building web applications). An API allows different

// 1. Creating the Web Application

var builder = WebApplication.CreateBuilder(args);

// Initializing the `builder` object, which is used to configure and eventually build our web application
// `WebApplication.CreateBuilder(args)` is a method provided by ASP.NET Core that:
// 1.1. Prepares the application for running (sets up environment, reads configuration files, etc.)
// 1.2. Allows us to `add services` (like *logging, **dependency injection, and more)
// 1.3. `args` is the command-line arguments passed to the application when it's started

// 2. Adding Services to the Container

// In ASP.NET Core, `services` are objects that are used throughout the application. These services might handle
// things like talking to a database, logging information, or sending emails.

builder.Services.AddControllers();

// `builder.Services`: This is where you register your services. These are classes that you'll use later
// in the your application.
// `AddControllers()`: This adds the neccessary code to support `Controllers`. A Controller is a class that 
// processes incoming HTTP requests and sends back a response. For example, if your API receives a request
// like `GET /products`, a controller would handle that and return a list of products.

// 3. Enabling API Discovery & Documentation

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
// `AddEndpointsApiExplorer()`: This registers the API endpoints (routes like /api/products, /api/orders)
// so tools like Swagger can "see" them.

builder.Services.AddSwaggerGen();
// `AddSwaggerGen()`: This is where you enable Swagger - a tool that generates interactive API documentation.
// It's a useful way to vizualise and test API endpoints from a web page.

// 4. Building the Application
var app = builder.Build();

// Once you've added services, builder.Build() builds the application.
// This creates an `app` object that represents your web server. The server will be able to listen for HTTP requests
// and respond with data.

// 5. Configuring the Request Pipeline
// A pipeline in ASP.NET Core is a series of steps that handle an HTTP request.
// Imagine a pipeline as a sequence of operations that occur when a user visits your API, like checking authentication,
// logging, and finally processing the request.

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment()) 
// `app.Environment.IsDevelopment()`: This checks whether the application is running in development mode
// (vs production mode). Development mode usually has extra tools enabled for debugging
{
    app.UseSwagger();
    app.UseSwaggerUI();
    // If the app is in development mode, this will enable Swagger and its UI (which is available at /swagger).
    // Swagger lets you see a visual representation of your API, making it easier to test API endpoints in a browser.
}

// 6. Handling HTTP Requests

app.UseHttpsRedirection();
// `UseHttpsRedirection()`: This middleware forces HTTP requests (less secure) to be automatically redirected
// to HTTPs (secure). HTTPs encrypt communication, making it more secure.

app.UseAuthorization();
// `UseAuthorization()`: This middleware ensures that the user has permission to access the resource.
// You will use this when you want to protect certain parts of your API (e.g., making sure only logged-in users
// can place orders).

app.MapControllers();
// `MapControllers()`: This is the step where ASP.NET connects incoming HTTP requests (like /api/products)
// to the appropriate Controller and action (method). It essentially links your controllers to specific routes,
// allowing them to handle requests.

// 7. Starting the Web Server
app.Run();
// This starts the web server and begins listening for incoming HTTP requests.