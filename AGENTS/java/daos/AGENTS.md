# DAO Layer Development Guidelines for GitHub Copilot

## Naming Conventions
- **Entity Names**: Use camelCase for all entity names and field names
- **DAO Interface**: `<ModelName>Dao.java`
- **DAO Implementation**: `<ModelName>DaoImpl.java`

## Method Design Rules
- **No New Filter Methods**: Do not create separate methods for filtering when the criteria uses fields from the model class itself
- Use parameterized queries with existing get/fetch methods for field-based filtering

## Standard DAO Guidelines

### Interface Structure
- Keep interfaces clean and focused on core CRUD operations
- Use generic types where applicable: `<T, ID>`
- Follow below method naming pattern:
    - `load(pkid)` - to load an entity using the primary key
    - `save()` - to save an entity
    - `delete()` - to delete an entity
    - `getAll<Model>ByCriteria(<Model>)` - to fetch all the entities matching the critieria passed as parameter.


### Implementation Best Practices
- Implement proper exception handling
- Use prepared statements to prevent SQL injection
- Include proper logging for debugging
- Implement transaction management where needed
- Follow dependency injection patterns

### Query Methods
- `getAll<Model>ByCriteria(<Model>)` - to fetch all the entities matching the critieria passed as parameter.
- `get<Model>By<Condition>(filtering fields)` - to fetch all the entities matching the critieria passed as parameter.
- Use `countBy` for counting operations
- Parameters should match entity field names

### Code Quality
- Add proper JavaDoc comments for all public methods
- Use `@Override` annotations in implementation classes
- Implement proper null checks and validation
- Follow single responsibility principle

### Example Naming
```java
// Interface: UserDao.java
// Implementation: UserDaoImpl.java
// Methods: load(UUID pkid), getAllUsersByCriteria(User user), getUserByName(String name) save(User user), delete(UUID pkid)
```