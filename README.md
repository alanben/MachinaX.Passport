# MachinaX.Passport

A comprehensive .NET authentication and user management solution consisting of two interconnected projects providing robust passport-based authentication services.

## Projects Overview

### PassportX
Core authentication library providing foundational classes and data access functionality.
- **Type**: .NET Framework 4.8 Class Library
- **Purpose**: Core authentication, user management, and data access
- **Output**: NuGet package for integration into other applications

### PassportServiceX
Web service layer exposing PassportX functionality through SOAP endpoints.
- **Type**: .NET Framework 4.8 Web Service Library
- **Purpose**: SOAP-based web services for authentication and user management
- **Output**: NuGet package and deployable web services

## Key Features

- **Multi-Database Support**: Compatible with SQL Server and PostgreSQL
- **Comprehensive User Management**: Registration, authentication, profiles, and groups
- **Security Framework**: Token-based authentication, password hashing, security levels
- **Web Service Integration**: SOAP endpoints for cross-platform integration
- **Activity Tracking**: Complete audit trail and user activity logging
- **Product/Service Management**: Support for product-based access control
- **Legacy Migration Ready**: Designed for modernization from legacy .NET Framework

## Architecture

```
MachinaX.Passport/
├── PassportX/                    # Core Library
│   ├── Data Models (x_*.cs)      # User, Group, Service entities
│   ├── Core Logic                # Authentication & business logic
│   └── Database Schemas          # SQL Server & PostgreSQL schemas
│
└── PassportServiceX/             # Web Services
    ├── Passport/                 # Core authentication services
    └── ServiceX/                 # Extended functionality services
```

## Technology Stack

- **.NET Framework 4.8**
- **SQL Server / PostgreSQL** (multi-database support)
- **SOAP Web Services**
- **log4net** for logging
- **Newtonsoft.Json** for serialization
- **MachinaX Framework** integration

## Database Support

Comprehensive database schemas included for:
- **SQL Server**: Complete schema with tables, procedures, and data
- **PostgreSQL**: Native PostgreSQL implementation
- **Migration Scripts**: Historical versions and update paths
- **Test Data**: Sample data and test functions

## Getting Started

### Prerequisites
- .NET Framework 4.8 SDK
- SQL Server or PostgreSQL database
- Visual Studio 2019 or later

### Building the Solution
```bash
# Clone the repository
git clone https://github.com/alanben/MachinaX.Passport.git

# Build the solution
dotnet build MachinaX.Passport.sln

# Generate NuGet packages
dotnet pack --configuration Release
```

### Database Setup
1. Choose your database platform (SQL Server or PostgreSQL)
2. Run the appropriate schema scripts from `PassportX/sql/`
3. Configure connection strings in your application

## Integration Examples

### Using PassportX Library
```csharp
// Add reference to XXBoom.MachinaX.PassportX NuGet package
using XXBoom.MachinaX.PassportX;

// Authenticate user
var passport = new x_passport();
var result = passport.AuthenticateUser(username, password);
```

### Consuming PassportServiceX Web Services
```csharp
// Reference the web service
var passportService = new PassportServiceReference.Passport();
var authResult = passportService.Login(username, password);
```

## Development Status

This is a **legacy modernization project** in progress:
- ✅ **Current**: .NET Framework 4.8 with modern project format
- 🔄 **In Progress**: NuGet package generation and build optimization
- 📋 **Planned**: Migration to .NET 6/8, containerization, cloud deployment

## Version History

- **v2.0.0** - Current release with modernized project structure
- **Legacy** - Extensive development history since 2007, evolved from GateKeeper system

## Contributing

This project is part of the MachinaX framework modernization effort. The codebase includes extensive development notes and historical context for understanding the evolution of the authentication system.

## Security Considerations

- Token-based authentication with secure session management
- Password hashing and security question support
- SQL injection protection through parameterized queries
- Role-based access control and permission management
- Comprehensive audit logging for security compliance

## License

MIT License - Copyright Alan Benington

## Repository Structure

```
MachinaX.Passport/
├── MachinaX.Passport.sln         # Visual Studio solution
├── PassportX/                    # Core authentication library
│   ├── README.md                 # Detailed project documentation
│   ├── PassportX.csproj          # Project file with NuGet config
│   ├── x_*.cs                    # Core classes and entities
│   └── sql/                      # Database schemas
└── PassportServiceX/             # Web service layer
    ├── README.md                 # Service documentation
    ├── PassportServiceX.csproj   # Web service project
    ├── Passport/                 # Core service endpoints
    └── ServiceX/                 # Extended service functionality
```

For detailed information about each project, see their respective README files.