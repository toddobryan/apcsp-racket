# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

Racket teaching materials for AP Computer Science Principles at duPont Manual High
School: an implementation of the APCSP pseudocode language, and customized HTDP-style
teaching languages. The goal is a package students install with `raco`.

### Related repositories

- **`toddobryan/dupontmanual-org`** (`~/code/racket/dupontmanual-org`) — the live class
  website, a Pollen project deployed to dupontmanual.org. The `website/` directory in
  *this* repo is a **superseded copy**; do not edit it. Website changes belong in
  `dupontmanual-org`.
- **`toddobryan/apcsp`** (`~/code/racket/apcsp`) — **archived**, do not commit there.
  It is still needed as a source of files: see "Missing files" below.

## Commands

Racket is installed system-wide (`/usr/share/racket`, Racket 9.1). Packages that must
be shared across users are installed at installation scope with `sudo raco pkg install -i`.
In-development packages in this repo are linked at **user** scope, since a linked
package points into a home directory.

```bash
# Link a package for development (from the repo root)
raco pkg install --link --name apcsp-pseudocode --auto apcsp-lib/pseudocode

# Build one module (fastest feedback loop)
raco make apcsp-lib/pseudocode/main.rkt

# Run tests
raco test apcsp-lib/pseudocode/lexer-test.rkt        # a single test file
raco test apcsp-lib/pseudocode/*-test.rkt            # all pseudocode tests
```

Test files must be able to resolve the `apcsp-pseudocode` collection, so the package
has to be linked before `parser-test.rkt` will run at all.

`expander-test.rkt` is **not** a unit test — it is a sample program written in
`#lang apcsp-pseudocode`. Run it with `racket expander-test.rkt` to exercise the
language end to end.

## Architecture

Three separate bodies of work live under `apcsp-lib/`:

### `apcsp-lib/pseudocode/` — the APCSP pseudocode `#lang`

A Beautiful Racket / brag DSL. Collection name is **`apcsp-pseudocode`** (not
`pseudocode`), declared in its `info.rkt`. The pipeline:

```
lexer.rkt → tokenizer.rkt → parser.rkt (brag grammar) → expander.rkt
```

`main.rkt` is the language entry point: its `read-syntax` parses the source and wraps
the parse tree in a module whose language is `apcsp-pseudocode/expander`. Its `reader`
submodule supplies DrRacket integration — `colorer.rkt` for syntax highlighting and
`indenter.rkt` for indentation.

`parse-only.rkt` and `tokenize-only.rkt` are debugging entry points that stop the
pipeline early; use them to inspect tokens or the parse tree in isolation.

### `apcsp-lib/apcsp/` — HTDP language customizations

Two nested packages with their own `info.rkt` files:

- `apcsp-racket-lib/` — beginner/intermediate/advanced teaching languages
  (`beginner.rkt`, `private/module-begin.rkt`, `lang/reader.rkt`). The reader
  restricts the Racket reader per level (no dot notation, no quasiquote, decimals
  read as exact) and opts out of DrRacket toolbar buttons to keep the UI simple
  for students.
- `apcsp-racket-signature/` — the signature/contract system, derived from
  DeinProgramm. Includes `signature/tool.rkt`, registered as a DrRacket plugin via
  `drracket-tools` in its `info.rkt`.

These reference each other by **relative path** across package boundaries, e.g.
`private/module-begin.rkt` requires `"../../../apcsp-racket-signature/..."`. That is
the main structural problem to fix when restructuring — packages should refer to each
other by collection name.

### `apcsp-lib/quiz/` — self-check exercises

`questions.rkt` only, ~20 lines, an unfinished sketch that does not compile
(unbalanced parens). Essentially greenfield.

## Current state — read before building

**The pseudocode lexer and parser work: 25 tests pass.** Everything below is broken or
incomplete.

**The expander is mid-refactor.** Its sample program fails with
`set!: unbound identifier at: myList`. `ps-assignment` expands to `(set! ID ...)` but
nothing ever binds the variable. There are two half-started approaches to this same
problem, and choosing between them is an open design decision:

1. A runtime environment — `(struct Env (parent directory))` plus a `get` stub that was
   abandoned mid-`if`. It is now commented out in `expander.rkt`.
2. Compile-time identifier collection — the commented-out `find-unique-ids`, which
   selects on `(syntax-property stx 'ps-id)`. **That property is never set anywhere**,
   and the grammar's `@ps-id : ID` splices the node away, so this could not have
   worked as written.

**The HTDP languages do not compile.** `raco make apcsp-lib/apcsp/apcsp-racket/beginner.rkt`
fails: the `apcsp-racket` collection is not linked, and two referenced modules are
absent from this repo entirely:

- `apcsp-racket/private/primitives.rkt` — exists **only** in the archived `apcsp` repo
  at `apcsp-lib/apcsp/private/primitives.rkt`
- `apcsp-racket/private/stepper-button.rkt` — referenced by `lang/reader.rkt`, not
  found in either repo

**Empty leftover directories.** `apcsp-racket/` (nested inside itself) and
`apcsp-racket-doc/` contain no tracked files and only ever held compiled artifacts.
Safe to delete.

## Gotchas

Scribble build output under `apcsp-lib/pseudocode/doc/` **is tracked in git**, so
running `raco setup` or `raco pkg install` dirties the working tree with regenerated
`.sxref`, `.html`, and `.css` files. Check `git status` before assuming you changed
something. This output arguably should be gitignored.

`.gitignore` covers `compiled/`, `*.zo`, `*.dep`, and DrRacket autosaves — but a
directory containing *only* ignored files shows as clean, which is why the empty
leftover directories above are invisible to `git status`.

## Intended packaging

The target layout is the standard Racket split (as `htdp` itself uses): `apcsp-lib`
(implementation), `apcsp-doc` (Scribble docs), `apcsp-test` (tests), and an `apcsp`
metapackage depending on the three. The split matters because students installing on
lab machines should get the library without pulling `scribble-lib`, `racket-doc`, and
the test chain.

Students would install with:

```bash
raco pkg install "git://github.com/toddobryan/apcsp-racket?path=apcsp"
```

## Reference material

`apcsp-doc/` in the archived `apcsp` repo holds *Schreibe Dein Programm!* by Sperber
and Klaeren (CC BY-SA 4.0) plus a machine translation. It is the pedagogical source
for the signature system here, and uses the same `(: name (Arg -> Result))` notation
the signature code implements.
