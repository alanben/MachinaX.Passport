# PassportX

A .NET Framework 4.8 library providing authentication and user management functionality for the MachinaX platform.

## Overview

PassportX is a comprehensive authentication and user management library that provides core classes and data access functionality for user authentication, group management, and security operations. It serves as the foundation for passport-based authentication systems.

## Features

- **User Management**: Complete user lifecycle management including registration, authentication, and profile management
- **Group Management**: Support for user groups and group membership functionality
- **Authentication**: Secure user authentication with password and security question support
- **Multi-Database Support**: Compatible with both SQL Server and PostgreSQL databases
- **Security Features**: Password hashing, security levels, and token-based authentication
- **Activity Tracking**: User activity logging and audit trail functionality
- **Product/Service Integration**: Support for product and service-based access control

## Architecture

The library is built around several core components:

### Core Classes
- `x_passport` - Base passport functionality and database operations
- `x_user` - User management and authentication logic
- `x_group` - Group management and membership operations
- `x_service` - Service and product management
- `x_result` - Result handling and response management

### Data Models
- `x_config` - Configuration settings
- `x_activity` - User activity tracking
- `x_friend` - Friend/relationship management
- `x_message` - Messaging functionality
- `x_product` - Product definitions
- `x_questions` - Security questions
- `x_recruit` - User recruitment tracking

### Status Enumerations
- `x_userStatus` - User account status values
- `x_groupStatus` - Group status values
- `x_serviceStatus` - Service status values
- `x_productStatus` - Product status values
- `x_friendStatus` - Friendship status values
- `x_securityLevel` - Security level definitions

## Database Support

The library includes comprehensive database schemas for both:

### SQL Server (`sql/MsSQL/`)
- Core database schema (`dbcore.sql`)
- Data initialization (`dbdata.sql`)
- Database cleanup (`dbclean.sql`)
- Update scripts (`dbupdate.sql`)
- Individual table schemas (`x_*.sql`)

### PostgreSQL (`sql/PostgreSQL/`)
- PostgreSQL-specific implementations
- Historical migration scripts
- Test data and functions

## Dependencies

- **log4net** (v2.0.15) - Logging framework
- **Newtonsoft.Json** (v13.0.3) - JSON serialization
- **XXBoom.MachinaX** (v2.0.8) - Core MachinaX framework
- **XXBoom.MachinaX.DataX** (v2.0.6) - Data access layer
- **System.Web.Services** - Web service support

## Configuration

The library uses the DataX database provider manager for multi-database support. Configuration is handled through the `x_config` class and database tables.

## Version History

- **Version 2.0.0** - Current release targeting .NET Framework 4.8
- **Legacy versions** - Previous versions dating back to 2007 with extensive development history

## Development Notes

This library has been refactored from the original GateKeeper codebase and is designed to integrate with the broader MachinaX framework. The codebase includes extensive development notes and version history spanning from 2007 to present.

## License

MIT License - Copyright Alan Benington

## Build Configuration

The project is configured to:
- Generate NuGet packages on build
- Target .NET Framework 4.8
- Use semantic versioning (2.0.0)
- Include comprehensive package metadata