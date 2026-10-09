#!/usr/bin/env bash
# Render README.md from index.json.
#
# The README used to be maintained by hand alongside index.json, which is two copies of one list and
# exactly the drift the file itself warns about: it claimed index.json was "the single source of truth"
# while carrying nine entries fewer than it. Now it is derived, so the only way to add a nest is to add
# it to index.json.
#
# Run: scripts/render-readme.sh    (needs jq)
set -euo pipefail
cd "$(dirname "$0")/.."

tmp=$(mktemp "README.md.XXXXXX")
trap 'rm -f "$tmp"' EXIT
jq -r -f /dev/stdin index.json > "$tmp" <<'JQ'
def dot:
  {"available": "🟢 available", "building": "🟡 building", "planned": "⚪ planned",
   "blocked": "🔴 blocked"}[.] // error("unknown status: \(.)");

def get_it:
  if (.repo // "") != "" then
    (.repo | sub("/+$"; "") | split("/") | last) as $name
    | "[`init --from`](\(.repo)) · [\($name)](\(.repo))"
  elif (.command // "") != "" then
    "`\(.command | split(" --chain")[0])` (generic)"
  else "-" end;

# $cols is a list of [header, separator]; cell maps one nest to its list of cell strings.
def table($rows; $cols; cell):
  (["| " + ($cols | map(.[0]) | join(" | ")) + " |",
    "|" + ($cols | map(.[1]) | join("|")) + "|"]
   + ($rows | map("| " + (cell | join(" | ")) + " |")))
  | join("\n");

def count($status): [.[] | select(.status == $status)] | length;

.nests as $nests
| ($nests | map(select(.category == "Graph Protocol"))) as $graph
| ($nests | map(select(.catalogue_section == "subgraph-ports"))) as $ports
| ($nests | map(select(.category != "Graph Protocol" and .catalogue_section != "subgraph-ports"))) as $other
| "# nuthatch nests - the index

The catalogue of prebuilt **nests** for [Nuthatch](https://github.com/nuthatch-org/nuthatch): packaged
indexing definitions (ABIs, decoded event tables, declarative views) that replace a rented subgraph
with a self-hosted one.

A nest is consumed with `nuthatch init --from <repo-url>`, or generated straight from a contract
address with `nuthatch init 0xAddr`. This repo is the human- and machine-readable **index**
([`index.json`](index.json)), the single source of truth the website builds from. Each nest lives in
its own repo on this org.

**This README is generated from `index.json`** by `scripts/render-readme.sh`. Do not edit it by hand;
edit the index and re-run the script. It was hand-maintained until 2026-08-19 and had drifted nine
entries behind.

- **Live catalogue page:** https://nuthatch-indexer.com/nests
- **Proof order:** [`PRIORITY.md`](PRIORITY.md), ranked by what each nest proves rather than by demand
- **Demand-ranked reasoning:** [`docs/nest-catalogue.md`](https://github.com/nuthatch-org/nuthatch/blob/main/docs/nest-catalogue.md) in the core repo

**\($nests | length) nests**: \($nests | count("available")) available, \($nests | count("building")) building, \($nests | count("planned")) planned, \($nests | count("blocked")) blocked.

## Graph Protocol nests

First-class Graph Protocol replacements, with Horizon absorbing the broader Network subgraph surface
rather than creating a competing second network nest.

\(table($graph; [["Nest","------"],["Status","------"],["Chains","------"],["Surface","-------"],["Get it","------"]];
        ["**\(.name)**", (.status | dot), (.chains | join(", ")), .summary, get_it]))

## Ports of subgraphs

Deployment-specific ports of published Graph subgraphs. They exist because the original deployment was
stuck, unserved, costly to query, or needed a self-hosted event-data path. A port states its own
boundary: a source deployment is not an automatic claim of entity-for-entity parity.

\(table($ports; [["Nest","------"],["Status","------"],["Chains","------"],["Why","---"],["Get it","------"]];
        ["**\(.name)**", (.status | dot), (.chains | join(", ")), .summary, get_it]))

## Other nests

\(table($other; [["Nest","------"],["Category","--------"],["Tier",":--:"],["Status","------"],["Chains","------"],["Get it","------"]];
        ["**\(.name)**", .category, (.tier | tostring), (.status | dot), (.chains | join(", ")), get_it]))

## Status

- 🟢 **available** - installable today, from a published repo or a contract address.
- 🟡 **building** - running in the wild, being packaged into a published nest here.
- ⚪ **planned** - on the catalogue, demand-ranked; not built yet. No fake install commands.
- 🔴 **blocked** - tried, and the chain will not give it up. Distinct from *planned* on purpose: a
  planned nest is waiting for someone's afternoon, a blocked one is waiting for a capability that does
  not exist. Read its `note` for what stopped it.

## Publishing a nest

A nest is self-contained: `nuthatch.toml`, vendored `abis/`, and its `views/` and `checks/`.
Publishing one is a `git push` of its repo to this org, then adding it to `index.json` and re-running
`scripts/render-readme.sh`. See [`horizon-nest`](https://github.com/nuthatch-org/horizon-nest) for
the shape."
JQ
mv "$tmp" README.md
echo "rendered README.md from $(jq '.nests | length' index.json) index entries"
