# Context-Based Rules for REST Endpoint Definitions

This directory contains REST endpoint definitions using Spring's `@Controller` annotations. Follow these rules when defining or modifying endpoints:

## General Guidelines
1. Use JAX-RS style annotations for defining
    - Path Parameter
    - Query Parameter
    - Resquest body
2. Ensure all endpoints produce JSON responses using `@Produces(MediaType.APPLICATION_JSON)`.

## Request body Validation
- Use `@Valid` annotation for the validation of the request body

## Request and Response Object
- Define the request and response objects in the  webapp/src/main/java/com/cisco/collab/hcsac/beans directory

## Package imports
- Always use specific imports and no wild card package imports

Follow these conventions to maintain consistency and clarity in the codebase.