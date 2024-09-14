# Required NuGet Packages

Install via NuGet Package Manager Console

1. `Entity Framework Core` for database access:
```powershell
Install-Package Microsoft.EntityFrameworkCore
``` 

2. `PostgreSQL Provider` for Entity Framework
```powershell
Install-Package Npgsql.EntityFrameworkCore.PostgreSQL
```

3. `Swagger` for API Documentation (already downloaded)
```powershell
Install-Package Swashbuckle.AspNetCore
```

Refer to the `.csproj` file: lists all the NuGet packages installed.
