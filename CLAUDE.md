# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

Racket teaching materials for AP Computer Science Principles at duPont Manual High
School: an implementation of the APCSP pseudocode language, and customized HTDP-style
teaching languages. The goal is a package students install with `raco`.

### Related repositories

- **`toddobryan/dupontmanual-org`** (`~/code/racket/dupontmanual-org`) — the live class
  website, a Pollen project deployed to dupontmanual.org. The APCSP pages live under its
  `apcsp/` directory. This repo no longer contains any website sources: the former
  `website/` directory was removed once its content was confirmed present there. All
  website changes belong in `dupontmanual-org`.
- **`toddobryan/apcsp`** (`~/code/racket/apcsp`) — **archived**, do not commit there.
  Everything unique to it has now been copied here (`apcsp-lib/signature/`,
  `apcsp-lib/apcsp/record.rkt`, `apcsp-test/`, `reference/`, and
  `apcsp-racket/private/primitives.rkt`). Its `website/` and `apcsp-lib/pseudocode/`
  are older copies of what lives here and in `dupontmanual-org`. Once the signature
  question below is settled it can be deleted outright.

## Commands

Racket is installed system-wide (`/usr/share/racket`, Racket 9.1). Packages that must
be shared across users are installed at installation scope with `sudo raco pkg install -i`.
In-development packages in this repo are linked at **user** scope, since a linked
package points into a home directory.

On a fresh machine, the pseudocode language needs these first — without them
`main.rkt` fails to compile on `br/quicklang/lang/reader`:

```bash
sudo raco pkg install -i --auto beautiful-racket-lib brag-lib
```

Then:

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

### `apcsp-lib/signature/` — de-unitized signature rewrite (**not yet chosen**)

A second, competing implementation of the signature system, ported from the archived
`apcsp` repo. Where `apcsp-racket-signature/` is near-verbatim upstream DeinProgramm
(`#lang scheme/base`, unit-based: `signatures^`, `signatures@`), this one is a rewrite
to `#lang racket/base` with direct provides — roughly 1100 lines of divergence in
`signature-unit.rkt` alone.

Neither is a superset. This tree lacks `tool.rkt` (the DrRacket plugin) and the
`drracket-tools` registration; the unit-based tree lacks the rewrite. `record.rkt` and
`apcsp-test/` depend on **this** tree, not the unit-based one.

**Open decision:** adopt this rewrite and port `tool.rkt` onto it, or keep the
unit-based tree and discard this. Until then both are present on purpose.

### `apcsp-lib/apcsp/record.rkt` — `define-record`

Ported from the archived repo; provides `define-record`. Depends on
`apcsp-lib/signature/`, so it stands or falls with the decision above.

### `apcsp-test/` — signature test suite

Ported from the archived repo (644 lines, substantially diverged from upstream
`deinprogramm-test`). Run with:

```bash
racket -e '(require "apcsp-test/signature.rkt" rackunit/text-ui) (run-tests all-signature-tests)'
```

Currently **28 pass, 1 error**: the `mixed wrap` case under "Tests for signature
syntax" fails with `got #<procedure:procedure-to-blame>`, a real defect in the
rewrite's lazy-wrap blame handling. That is part of the open decision above.

### `reference/` — pedagogical sources

*Schreibe Dein Programm!* plus its machine translation (21 MB of PDFs). Not a package
and not shipped; see `reference/README.md`.

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
still fails, now for two remaining reasons:

- The `apcsp-racket` collection is not linked, so every `apcsp-racket/private/...`
  require fails to resolve. This is the first thing to fix.
- `apcsp-racket/private/stepper-button.rkt` — referenced by `lang/reader.rkt`, not
  found in any repo, including the archived one. It has to be written or the reference
  dropped.

`apcsp-racket/private/primitives.rkt` used to be missing too; it has been copied in
from the archived repo and is no longer a blocker.

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
