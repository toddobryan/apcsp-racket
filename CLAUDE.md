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
- **`toddobryan/apcsp`** — **deleted.** Everything unique to it was copied here first
  (`apcsp-lib/signature/`, `apcsp-lib/apcsp/record.rkt`, `apcsp-test/`, `reference/`,
  and `apcsp-racket/private/primitives.rkt`); its `website/` and
  `apcsp-lib/pseudocode/` were older copies of what lives here and in
  `dupontmanual-org`. Nothing references it any more.

## Commands

Racket is installed system-wide (`/usr/share/racket`, Racket 9.3). Packages that must
be shared across users are installed at installation scope with `sudo raco pkg install -i`.
The in-development `apcsp` package is linked at **user** scope, since a linked package
points into a home directory.

```bash
# Link the package for development (from the repo root); --auto fetches
# beautiful-racket-lib and brag-lib if they are missing
raco pkg install --link --name apcsp --auto apcsp

# Rebuild it, including docs, and check its declared dependencies
raco setup --check-pkg-deps --pkgs apcsp

# Build one module (fastest feedback loop)
raco make apcsp/pseudocode/main.rkt

# Run tests
raco test -p apcsp                                # everything in the package
raco test apcsp/pseudocode/run-test.rkt           # a single test file
```

Tests in `#lang apcsp/bsl` programs live in a `test` submodule, so `check-expect`
results and signature violations appear under `raco test` or in DrRacket, not under
plain `racket`.

`expander-test.rkt` is **not** a unit test: it is a sample program written in
`#lang apcsp/pseudocode`. `run-test.rkt` holds the end-to-end tests.

## Architecture

### `apcsp/` — the package

One package, one collection, both named **`apcsp`**. This is what ships.

- `bsl.rkt` + `bsl/lang/reader.rkt` — `#lang apcsp/bsl`: `htdp/bsl` plus
  `private/extras.rkt`. To add a level (`bsl+`, `isl`, ...), copy this pair using the
  matching `lang/htdp-*` module and the options in `htdp/<level>/lang/reader.rkt`. Names
  clashing with `extras.rkt` differ per level; from `isl` up the level's own `let` must
  win over the extras' `let`.
- `private/extras.rkt` — what `htdp/bsl` lacks: image and event signatures, `ε`,
  degree-based trig, and exact number predicates. It began as `apcsp.rkt` on the class
  site, which students used to download and `require`.
- `pseudocode/` — `#lang apcsp/pseudocode`, described below.

A two-part `#lang` name needs a `lang/reader.rkt`; it never finds `main.rkt`'s `reader`
submodule. Every module in the package must compile, or `raco setup` reports errors to
everyone who installs it, so unfinished work stays outside `apcsp/`.

### `apcsp/pseudocode/` — the APCSP pseudocode `#lang`

A Beautiful Racket / brag DSL. The pipeline:

```
lexer.rkt → tokenizer.rkt → parser.rkt (brag grammar) → expander.rkt
```

`main.rkt` has the `read-syntax` that parses the source and wraps the parse tree in a
module whose language is `apcsp/pseudocode/expander`. Its `reader` submodule supplies
DrRacket integration: `colorer.rkt` for syntax highlighting and `indenter.rkt` for
indentation. `lang/reader.rkt` re-exports that submodule.

`parse-only.rkt` and `tokenize-only.rkt` are debugging entry points that stop the
pipeline early; use them to inspect tokens or the parse tree in isolation.

Variables live in a chain of `Env` structs, not in Racket bindings. The language exports
almost no names, so a variable read is an unbound identifier and reaches `ps-top`, the
language's `#%top`, which looks it up at run time. Assignment updates the nearest existing
variable, or creates one in the current environment. Only procedures create environments:
a call gets a new one whose parent is where the procedure was defined. Blocks do not, so
a `FOR EACH` variable outlives its loop. The AP exam reference sheet says nothing about
scope, so these are this language's choices rather than College Board rules.

### Outside the package

These are not installed. `apcsp-lib/` no longer holds anything that ships.

- `apcsp-lib/apcsp/apcsp-racket-signature/` — the signature/contract system, near-verbatim
  upstream DeinProgramm (`#lang scheme/base`, unit-based). Includes `signature/tool.rkt`,
  a DrRacket plugin.
- `apcsp-lib/signature/` — a de-unitized rewrite of the same system in `#lang racket/base`.
  Neither tree is a superset: this one lacks `tool.rkt`, the other lacks the rewrite.
- `apcsp-lib/apcsp/record.rkt` — `define-record`, built on `apcsp-lib/signature/`.
- `apcsp-lib/apcsp/apcsp-racket/private/` — `primitives.rkt` and `syntax-checkers.rkt`,
  kept because `record.rkt` needs them.
- `apcsp-test/` — the signature test suite, covering `apcsp-lib/signature/`. All 29 pass:

  ```bash
  racket -e '(require "apcsp-test/signature.rkt" rackunit/text-ui) (run-tests all-signature-tests)'
  ```

- `reference/` — *Schreibe Dein Programm!* plus its machine translation (21 MB of PDFs);
  see `reference/README.md`.

`apcsp/bsl` uses `deinprogramm` directly and needs none of this. The signature trees
exist to rename things: capitalized type names, `mixed` as `OneOf`, and so on. **Open
decision:** which tree to build that on, and how it feeds into `apcsp/bsl`.

### `unfinished-languages` branch

The DeinProgramm-style beginner language (`beginner.rkt`, its reader, and
`private/module-begin.rkt`) was removed from `main` and is kept on this branch, which
is the whole repo as it stood before the `apcsp/` rearrangement. It never compiled: the
`apcsp-racket` collection was never linked, and `private/stepper-button.rkt` does not
exist anywhere.

## Packaging

The goal is one `apcsp` package on the Racket package catalog, which students install
by name with `raco pkg install --auto apcsp` or the DrRacket Package Manager, and which
goes on the LTSP client image with `sudo raco pkg install -i --auto apcsp`. The catalog
entry's source is `https://github.com/toddobryan/apcsp-racket.git?path=apcsp`.

## Reference material

`reference/` holds *Schreibe Dein Programm!* by Sperber and Klaeren (CC BY-SA 4.0)
plus a machine translation. It is the pedagogical source for the signature system
here, and uses the same `(: name (Arg -> Result))` notation the signature code
implements.
