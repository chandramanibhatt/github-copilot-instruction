# Copilot Instructions

## Code Generation Rules

When generating code for any file in this repository, the coding assistant should:

1. **Check for AGENTS.md**: Look for an `AGENTS.md` file in the same directory as the target file
2. **Apply Directory Rules**: If `AGENTS.md` exists in the current directory, follow the coding rules and guidelines specified in that file
3. **Hierarchy Precedence**: If no `AGENTS.md` exists in the current directory, check parent directories up to the repository root
4. **Fallback to Defaults**: If no `AGENTS.md` file is found in any parent directory, use standard coding practices for the detected language/framework
5. Always use camelCase for variables.

## AGENTS.md File Format

The `AGENTS.md` file should contain:
- Coding standards and conventions
- Architecture patterns to follow
- Technology stack preferences
- Code style guidelines
- Testing requirements
- Documentation standards

This ensures consistent code generation that aligns with the specific requirements and patterns of each module or component within the repository.