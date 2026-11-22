# Pragmatic TDD & Verification

1. **Red-first for logic & bugs:** For business logic, algorithms, state machines, and bug fixes, write a reproducing failing test before implementing the fix.
2. **Match repo tooling:** Detect the existing test stack (`xUnit`, `NUnit`, `MSTest`, `bUnit`, `pytest`, engine tests) before creating tests; default new .NET libraries to `xUnit`.
3. **Verify after final edit:** Run the relevant test or build command (`dotnet test`, `dotnet build`, `pytest`, etc.) after modifying production code.
4. **Zero fabricated results:** Never claim tests or builds pass without observing their actual output after the last code edit.
