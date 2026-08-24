# Contributing to build-your-own-flutter-ui

Thank you for your interest in contributing! This project aims to help Flutter developers master custom UI development by building components from scratch and discovering great libraries in the Flutter ecosystem.

---

## Two Ways to Contribute

### 1. Add a New Component Tutorial

If you'd like to share how to build a Flutter UI component from scratch:

1. **Pick a Component**: Choose a popular, visually interesting, or technically educational Flutter UI pattern that isn't already covered (or open an issue to discuss it).
2. **Create Tutorial Folder**: Create a directory under `tutorials/<component-slug>/` with the following structure:
   ```text
   tutorials/<component-slug>/
   ├── README.md
   └── final/
       └── <component_name>.dart
   ```
3. **Follow the Standard Tutorial Template**:
   Your `tutorials/<component-slug>/README.md` must follow this structure:
   - `# <Component Name>`
   - `## What we're building` (concise description + mention/embed of screenshot or demo)
   - `## Concepts you'll learn` (bullet list of Flutter/Dart APIs, widgets, and animation techniques)
   - `## Prerequisites` (Flutter SDK version requirements and dependencies, if any)
   - `## Step-by-step` (numbered steps with working, runnable Dart code snippets)
   - `## Challenges` (2-3 suggestions to extend the component)
   - `## Final result` (link to the `final/` folder)
4. **Provide Complete Code**: Add a self-contained, working widget file (e.g. `<component_name>.dart` or `main.dart`) inside the `final/` folder.
5. **Update Root README**: Add an entry for your new tutorial in the table within the root [README.md](../../README.md).

---

### 2. Add a Package to the Curated List

If you know of a robust, well-maintained Flutter package for custom UI:

1. Open [`curated-list/README.md`](curated-list/README.md).
2. Locate the appropriate category (or suggest a new one if it doesn't fit existing sections).
3. Add the package to the table with:
   - Package name
   - Short, accurate description
   - Direct pub.dev link
   - Star indicator (`⭐ check pub.dev`)
4. Ensure the package is actively maintained and published on pub.dev.

---

## Pull Request Checklist

Before submitting your pull request, please make sure:

- [ ] The tutorial's `README.md` follows the standard template format.
- [ ] All Dart code snippets and the file in `final/` are valid, error-free Dart code that compiles with Flutter stable.
- [ ] No extraneous build files, `.dart_tool`, or IDE configs are included.
- [ ] The component has been added to the table in root `README.md` with appropriate difficulty and key concepts.
- [ ] If adding to the curated list, the package exists on pub.dev and is placed in the correct category.
