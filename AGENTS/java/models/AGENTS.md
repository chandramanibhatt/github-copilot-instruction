# GitHub Copilot Code Generation Rules for Hibernate Entities

## Entity Naming Conventions
- Use **camelCase** for entity class names (e.g., `UserProfile`, `OrderDetail`)
- Use **camelCase** for field names (e.g., `firstName`, `createdDate`)
- Use **UPPER_CASE** for enum constants

## Hibernate 6 Specific Guidelines
- Use `@Entity` annotation on all entity classes
- Specify `@Table(name = "table_name")` with explicit table names
- Use `@Id` and `@GeneratedValue` for primary keys
- Prefer `GenerationType.IDENTITY` for auto-generated IDs

## Relationship Mapping
- **Always use LAZY loading** for associations: `fetch = FetchType.LAZY`
- Use `@OneToMany(fetch = FetchType.LAZY, mappedBy = "...")`
- Use `@ManyToOne(fetch = FetchType.LAZY)`
- Use `@ManyToMany(fetch = FetchType.LAZY)`

## Required Methods
- Implement `hashCode()` and `equals()` methods considering **all fields**
- Include proper `toString()` method
- Add default constructor and parameterized constructors
- The classes representing jsonb fields of the entity must implement `equals()` and `hashCode()` methods considering all the fields of the class

## Field Annotations
- Use `@Column` for explicit column mapping
- Add `@Temporal` for date/time fields
- Use `@Enumerated(EnumType.STRING)` for enums
- Apply `@NotNull`, `@Size`, `@Valid` for validation

## Best Practices
- Make fields `private` with public getters/setters
- Use `Optional<>` for nullable relationships
- Add proper JavaDoc comments
- Follow Java naming conventions
- Use meaningful variable names
- Implement `Serializable` interface when needed
- Use `@Version` for optimistic locking when applicable