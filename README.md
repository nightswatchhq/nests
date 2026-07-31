# nuthatch nests — the index

The catalogue of prebuilt **nests** for [Nuthatch](https://github.com/nightswatchhq/nuthatch) — packaged indexing definitions (ABIs + decoded event tables + declarative views) that replace a rented subgraph with a self-hosted one.

A nest is consumed with `nuthatch init --from <repo-url>`, or generated straight from a contract address with `nuthatch init 0xAddr`. This repo is the human- and machine-readable **index** ([`index.json`](index.json)) — the single source of truth the website builds from. Each nest lives in its own repo on this org.

- **Live catalogue page:** https://nuthatch-indexer.com/nests
- **Demand-ranked reasoning:** [`docs/nest-catalogue.md`](https://github.com/nightswatchhq/nuthatch/blob/main/docs/nest-catalogue.md) in the core repo

## Nests

| Nest | Category | Tier | Status | Get it |
|------|----------|:----:|--------|--------|
| **Graph Horizon** | Graph infra | 0 · beachhead | 🟢 available | [`init --from`](https://github.com/nightswatchhq/horizon-nest) · [horizon-nest](https://github.com/nightswatchhq/horizon-nest) |
| **ERC-20 token** | Token | 1 | 🟢 available | `init 0xAddr` (generic) |
| **ERC-721 / ERC-1155 NFT** | NFT | 1 | 🟢 available | `init 0xAddr` (generic) |
| **Epoch Block Oracle** | Graph infra | 0 · beachhead | ⚪ planned | — |
| **QoS / Rewards-Eligibility Oracle** | Graph infra | 0 · beachhead | ⚪ planned | — |
| **Aave V3** | Lending | 1 | ⚪ planned | — |
| **ENS** | Name service | 1 | ⚪ planned | — |
| **Uniswap V3** | DEX | 1 | 🟢 available | [`init --from`](https://github.com/nightswatchhq/uniswap-v3) · [uniswap-v3](https://github.com/nightswatchhq/uniswap-v3) |
| **Compound V2 + V3** | Lending | 2 | ⚪ planned | — |
| **Curve** | DEX | 2 | ⚪ planned | — |
| **Lido** | Staking / LST | 2 | ⚪ planned | — |
| **Seaport (OpenSea)** | NFT marketplace | 2 | ⚪ planned | — |
| **Uniswap V2 + Sushiswap** | DEX | 2 | ⚪ planned | — |
| **Livepeer** | Video infra | 2 | 🟢 available | [`init --from`](https://github.com/nightswatchhq/livepeer-nest) · [livepeer-nest](https://github.com/nightswatchhq/livepeer-nest) |
| **POA** | DAO tooling | 3 | 🟢 available | [`init --from`](https://github.com/nightswatchhq/poa-nest) · [poa-nest](https://github.com/nightswatchhq/poa-nest) |
| **EigenLayer** | Restaking | 3 | ⚪ planned | — |
| **GMX** | Perps | 3 | ⚪ planned | — |
| **MakerDAO / Sky** | CDP | 3 | ⚪ planned | — |

## Status

- 🟢 **available** — installable today, from a published repo or a contract address.
- 🟡 **building** — running in the wild, being packaged into a published nest here.
- ⚪ **planned** — on the catalogue, demand-ranked; not built yet. No fake install commands.

## Publishing a nest

A nest is self-contained — `nuthatch.toml`, vendored `abis/`, and its `views/` / `checks/`. Publishing one is a `git push` of its repo to this org; then add it to `index.json` (the site and this README follow). See [`horizon-nest`](https://github.com/nightswatchhq/horizon-nest) for the shape.
