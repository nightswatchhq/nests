#!/usr/bin/env python3
"""Render README.md from index.json.

The README used to be maintained by hand alongside index.json, which is two copies of one list and
exactly the drift the file itself warns about: it claimed index.json was "the single source of truth"
while carrying nine entries fewer than it. Now it is derived, so the only way to add a nest is to add
it to index.json.

Run: python3 scripts/render-readme.py
"""
import json, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
nests = json.loads((ROOT / "index.json").read_text())["nests"]

DOT = {"available": "🟢 available", "building": "🟡 building", "planned": "⚪ planned"}

def get_it(n):
    repo = n.get("repo")
    if repo:
        name = repo.rstrip("/").rsplit("/", 1)[-1]
        return f"[`init --from`]({repo}) · [{name}]({repo})"
    if n.get("command"):
        return f"`{n['command'].split(' --chain')[0]}` (generic)"
    return "-"

def table(rows, cols, cell):
    out = ["| " + " | ".join(c[0] for c in cols) + " |",
           "|" + "|".join(c[1] for c in cols) + "|"]
    out += ["| " + " | ".join(cell(n)) + " |" for n in rows]
    return "\n".join(out)

graph  = [n for n in nests if n["category"] == "Graph Protocol"]
ports  = [n for n in nests if n.get("catalogue_section") == "subgraph-ports"]
other  = [n for n in nests if n not in graph and n not in ports]

doc = f"""# nuthatch nests - the index

The catalogue of prebuilt **nests** for [Nuthatch](https://github.com/nightswatchhq/nuthatch): packaged
indexing definitions (ABIs, decoded event tables, declarative views) that replace a rented subgraph
with a self-hosted one.

A nest is consumed with `nuthatch init --from <repo-url>`, or generated straight from a contract
address with `nuthatch init 0xAddr`. This repo is the human- and machine-readable **index**
([`index.json`](index.json)), the single source of truth the website builds from. Each nest lives in
its own repo on this org.

**This README is generated from `index.json`** by `scripts/render-readme.py`. Do not edit it by hand;
edit the index and re-run the script. It was hand-maintained until 2026-08-19 and had drifted nine
entries behind.

- **Live catalogue page:** https://nuthatch-indexer.com/nests
- **Proof order:** [`PRIORITY.md`](PRIORITY.md), ranked by what each nest proves rather than by demand
- **Demand-ranked reasoning:** [`docs/nest-catalogue.md`](https://github.com/nightswatchhq/nuthatch/blob/main/docs/nest-catalogue.md) in the core repo

**{len(nests)} nests**: {sum(1 for n in nests if n['status']=='available')} available, {sum(1 for n in nests if n['status']=='building')} building, {sum(1 for n in nests if n['status']=='planned')} planned.

## Graph Protocol nests

First-class Graph Protocol replacements, with Horizon absorbing the broader Network subgraph surface
rather than creating a competing second network nest.

{table(graph, [("Nest","------"),("Status","------"),("Chains","------"),("Surface","-------"),("Get it","------")],
       lambda n: [f"**{n['name']}**", DOT[n['status']], ", ".join(n['chains']), n['summary'], get_it(n)])}

## Ports of subgraphs

Deployment-specific ports of published Graph subgraphs. They exist because the original deployment was
stuck, unserved, costly to query, or needed a self-hosted event-data path. A port states its own
boundary: a source deployment is not an automatic claim of entity-for-entity parity.

{table(ports, [("Nest","------"),("Status","------"),("Chains","------"),("Why","---"),("Get it","------")],
       lambda n: [f"**{n['name']}**", DOT[n['status']], ", ".join(n['chains']), n['summary'], get_it(n)])}

## Other nests

{table(other, [("Nest","------"),("Category","--------"),("Tier",":--:"),("Status","------"),("Chains","------"),("Get it","------")],
       lambda n: [f"**{n['name']}**", n['category'], str(n['tier']), DOT[n['status']], ", ".join(n['chains']), get_it(n)])}

## Status

- 🟢 **available** - installable today, from a published repo or a contract address.
- 🟡 **building** - running in the wild, being packaged into a published nest here.
- ⚪ **planned** - on the catalogue, demand-ranked; not built yet. No fake install commands.

## Publishing a nest

A nest is self-contained: `nuthatch.toml`, vendored `abis/`, and its `views/` and `checks/`.
Publishing one is a `git push` of its repo to this org, then adding it to `index.json` and re-running
`scripts/render-readme.py`. See [`horizon-nest`](https://github.com/nightswatchhq/horizon-nest) for
the shape.
"""
(ROOT / "README.md").write_text(doc)
print(f"rendered README.md from {len(nests)} index entries")
