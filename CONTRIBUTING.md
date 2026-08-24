# Contributing to build-your-own-flutter-ui

Thank you for helping curate the best resources for building custom Flutter UI components from scratch!

---

## 📌 This Repository is an Index (Link-Only)

**build-your-own-flutter-ui** does not host tutorial files, blog posts, or codebases directly in this repository. Instead, it is an indexed directory of high-quality external resources (dev.to posts, Medium articles, personal GitHub repositories, YouTube tutorials, Flutter community articles, etc.).

**To contribute, you only need to add a single markdown table row linking to your resource.** Please do not paste full tutorial content or upload large codebases directly into this repository.

---

## 📜 Submission Rules

1. **Public & Accessible**: The tutorial, article, video, or repository must be publicly accessible without mandatory paywalls or private permissions.
2. **Built From Scratch**: The resource must teach or demonstrate how to build a Flutter UI component/pattern **from scratch** using Flutter's native widget tree, animation controllers, shaders, or custom painters — not just how to install a third-party package.
3. **One Link per PR**: Please submit one link/resource per pull request to make reviews straightforward.
4. **Alphabetical Order**: Keep entries sorted alphabetically by component name within each category section.
5. **No Duplicate Entries**: Check existing tables to ensure the tutorial or package has not already been indexed.

---

## 🛠️ How to Add an Entry

### Adding a "Build It Yourself" Tutorial Link
1. Open [`README.md`](README.md).
2. Find the relevant category under **Build It Yourself** (e.g., *Animations*, *Buttons & Inputs*, *Navigation*, etc.).
3. If the category currently has the placeholder row (`_No entries yet — be the first to add one!_`), replace it with your table row:
   ```markdown
   | <Component Name> | <Author Name or @handle> | Flutter / Dart | [Tutorial / Repo Title](https://link-to-resource.com) |
   ```
4. Save and open a Pull Request.

### Adding a Package to the Curated List
1. Open [`curated-list/README.md`](curated-list/README.md).
2. Locate the appropriate category.
3. Add a row with package name, description, direct pub.dev link, and placeholder stars:
   ```markdown
   | `package_name` | Concise description of what it does. | [pub.dev/packages/package_name](https://pub.dev/packages/package_name) | ⭐ check pub.dev |
   ```
4. Save and open a Pull Request.

---

## ✅ Pull Request Checklist

Before submitting your PR, verify that:

- [ ] You added your link to the correct category in [README.md](README.md) or [curated-list/README.md](curated-list/README.md).
- [ ] You did not duplicate an existing entry.
- [ ] The linked tutorial/repo is public, active, and working.
- [ ] The markdown table syntax is properly aligned and formatted.

---

## ⚠️ Link Rot & Dead Links

If you notice a link in this repository is broken, returning a 404, or points to a deleted repository, please open an issue using the [Broken Link Report template](.github/ISSUE_TEMPLATE/broken-link.md) so we can update or prune it.
