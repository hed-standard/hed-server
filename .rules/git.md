# Git workflow

## Branch strategy

- `main`: Most recent usable version on `hed-standard/hed-server`
- Feature branches: `feature/<issue-number>-short-description`
- Development happens on a personal fork of `hed-standard/hed-server`
- Push feature branches to the forked repository, then open a PR targeting `main` on `hed-standard/hed-server`

## Commits

- Atomic, focused changes
- Messages \<50 chars, no emojis
- No AI attribution in commits or PRs
- Precommit: Should run ruff check and ruff format locally before to eliminate format errors

## PR process

01. Create issue on `hed-standard/hed-server` (except for minor fixes)
02. Create a feature branch on your fork: `git checkout -b feature/<issue-number>-short-description`
03. Implement with atomic commits
04. Run tests: `python -m unittest discover -s tests -p "test*.py" -v`
05. Run linting and formatting check: `ruff check .` and `ruff format --check .`
06. Push the feature branch to your fork: `git push origin feature/<issue-number>-short-description`
07. Open a PR from your fork's feature branch targeting `main` on `hed-standard/hed-server`
08. Run `/review-pr` for code review
09. Address all critical/important findings
10. Merge by a maintainer

## Release process (see RELEASE_GUIDE.md)

1. Update CHANGELOG.md
2. Run code quality checks (ruff check, ruff format, typos)
3. Run all tests (unit + spec)
4. Push CHANGELOG PR, merge to main
5. Create git tag (semantic versioning: MAJOR.MINOR.PATCH)
6. Build: `python -m build`; check: `twine check dist/*`
7. Upload to PyPI: `twine upload dist/*`
8. Verify Zenodo DOI generation
9. setuptools-scm derives version from git tags automatically
