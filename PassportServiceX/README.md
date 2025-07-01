# PassportServiceX

A .NET Framework 4.8 web service library providing authentication and passport services for the MachinaX platform.

## Overview

PassportServiceX is a web service layer built on top of the PassportX library, providing SOAP-based web services for authentication, user management, and passport operations. It exposes the core PassportX functionality through standardized web service interfaces.

## Features

- **Authentication Services**: User login, logout, and token-based authentication
- **User Management Services**: User registration, profile updates, and account management
- **Group Management Services**: Group creation, membership management, and permissions
- **Service Management**: Product and service registration and management
- **Administrative Services**: Admin-level operations for user and system management
- **Pseudo Services**: Support for anonymous/pseudo user operations

## Architecture

The service layer is organized into two main service categories:

### Passport Services (`Passport/`)
Core passport authentication and user management services:
- `Admin.asmx.cs` - Administrative operations and management functions
- `Customer.asmx.cs` - Customer-specific service operations
- `Passport.asmx.cs` - Core passport authentication services
- `PassportPseudo.asmx.cs` - Anonymous/pseudo user services

### Extended Services (`ServiceX/`)
Extended passport functionality and specialized services:
- `PassportBaseX.asmx.cs` - Base service functionality
- `PassportCoreX.asmx.cs` - Core passport operations
- `PassportDefaultX.asmx.cs` - Default service implementations
- `PassportMembershipX.asmx.cs` - Membership management services
- `PassportProductX.asmx.cs` - Product management services
- `PassportRootX.asmx.cs` - Root-level administrative services
- `PassportServiceX.asmx.cs` - Main service coordination
- `PassportWebServiceX.asmx.cs` - Web service infrastructure
- `PassportX.asmx.cs` - Core passport service implementations

## Web Service Endpoints

All services are exposed as SOAP web services with the following characteristics:
- **Namespace**: `http://www.clickclickBOOM.com/MachinaX/PassportX`
- **Protocol**: SOAP over HTTP
- **Format**: XML-based request/response
- **Authentication**: Token-based authentication for protected operations

### Key Service Methods
- User authentication and session management
- User registration and profile management
- Group and membership operations
- Product and service management
- Administrative functions
- Security and permission management

## Installation

### NuGet Package
```xml
<PackageReference Include="XXBoom.MachinaX.PassportServiceX" Version="2.0.0" />
```

### Package Manager Console
```powershell
Install-Package XXBoom.MachinaX.PassportServiceX -Version 2.0.0
```

### .NET CLI
```bash
dotnet add package XXBoom.MachinaX.PassportServiceX --version 2.0.0
```

## Dependencies

- **PassportX** - Core passport library (project reference)
- **log4net** (v2.0.15) - Logging framework
- **Newtonsoft.Json** (v13.0.3) - JSON serialization
- **XXBoom.MachinaX** (v2.0.8) - Core MachinaX framework
- **XXBoom.MachinaX.WebServiceX** (v2.0.6) - Web service framework
- **System.Web.Services** - .NET web services support

## Configuration

The service layer inherits configuration from the underlying PassportX library and adds web service-specific settings. Configuration includes:
- Database connection settings (via DataX)
- Web service endpoint configuration
- Security and authentication settings
- Logging configuration

## Deployment

The service is designed to be deployed as:
- IIS web application
- Standalone web service
- Part of larger web application

## Security

The service implements multiple security layers:
- Token-based authentication
- Session management
- Role-based access control
- SQL injection protection
- Input validation and sanitization

## Development History

This service layer has evolved from earlier GateKeeper implementations and has been refactored to align with the MachinaX framework architecture. The codebase includes extensive development notes spanning multiple years of evolution.

## Version History

- **Version 2.0.0** - Current release targeting .NET Framework 4.8
- **Legacy versions** - Continuous development since 2007

## Integration

PassportServiceX is designed to integrate with:
- Web applications requiring authentication
- Mobile applications needing user management
- Third-party systems requiring passport services
- Other MachinaX framework components

## License

MIT License - Copyright Alan Benington

## Build Configuration

The project is configured to:
- Generate NuGet packages on build
- Reference the PassportX library
- Target .NET Framework 4.8
- Include web service metadata
- Support both debug and release configurations