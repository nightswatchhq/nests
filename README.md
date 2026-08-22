# nuthatch nests - the index

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

**43 nests**: 34 available, 6 building, 0 planned, 3 blocked.

## Graph Protocol nests

First-class Graph Protocol replacements, with Horizon absorbing the broader Network subgraph surface
rather than creating a competing second network nest.

| Nest | Status | Chains | Surface | Get it |
|------|------|------|-------|------|
| **Graph Horizon** | 🟢 available | Arbitrum | The Graph's own protocol state - staking provisions, allocations, delegation, curation and rewards. The data every indexer pays GRT to read today. | [`init --from`](https://github.com/nightswatchhq/horizon-nest) · [horizon-nest](https://github.com/nightswatchhq/horizon-nest) |
| **Graph Staking** | 🟡 building | Arbitrum | HorizonStaking delegation history: deposits, undelegations and completed withdrawals for Graph indexers and delegators. | [`init --from`](https://github.com/nightswatchhq/graph-staking-nest) · [graph-staking-nest](https://github.com/nightswatchhq/graph-staking-nest) |
| **Graph Allocations + Curation** | 🟡 building | Arbitrum | Horizon allocation lifecycle and L2 curation signal in one nest, with a `port_queue` view over both: subgraph deployments carrying signal that no indexer is serving. | [`init --from`](https://github.com/nightswatchhq/graph-allocations-nest) · [graph-allocations-nest](https://github.com/nightswatchhq/graph-allocations-nest) |
| **Graph Name Service** | 🟡 building | Arbitrum | L2GNS subgraph publication history, including the event stream behind Graph developer-activity metrics. | [`init --from`](https://github.com/nightswatchhq/graph-gns-nest) · [graph-gns-nest](https://github.com/nightswatchhq/graph-gns-nest) |
| **Graph TAP Escrow** | 🟡 building | Arbitrum | Legacy TAP Escrow account funding, settlement, thaw, and authorised-signer event history. | [`init --from`](https://github.com/nightswatchhq/graph-tap-escrow-nest) · [graph-tap-escrow-nest](https://github.com/nightswatchhq/graph-tap-escrow-nest) |
| **Epoch Block Oracle** | 🟡 building | Arbitrum | The per-epoch canonical block for every indexed chain - the reference all indexers use to close multichain allocations consistently. | [`init --from`](https://github.com/nightswatchhq/epoch-block-oracle-nest) · [epoch-block-oracle-nest](https://github.com/nightswatchhq/epoch-block-oracle-nest) |
| **Gateway QoS telemetry** | 🔴 blocked | Arbitrum | Indexer quality-of-service as the gateway measures it. Not reachable by indexing: the gateway publishes this off-chain and no contract emits it. | - |
| **Graph Network** | 🟢 available | Arbitrum | The full Graph Network subgraph: indexers, allocations, curation, delegation, epochs and subgraph deployments in one surface. The pieces already ship as separate nests (graph-staking, graph-gns, graph-allocations); this is the union. | [`init --from`](https://github.com/nightswatchhq/graph-network) · [graph-network](https://github.com/nightswatchhq/graph-network) |
| **Subgraph Availability Oracle** | 🟢 available | Arbitrum | The availability vote behind indexing rewards: oracles vote on whether a subgraph deployment is available, and a denied deployment stops accruing rewards. | [`init --from`](https://github.com/nightswatchhq/subgraph-availability-oracle) · [subgraph-availability-oracle](https://github.com/nightswatchhq/subgraph-availability-oracle) |
| **Rewards Eligibility Oracle** | 🟢 available | Arbitrum | GIP-0088's Rewards Eligibility Oracle: authorised oracles mark indexers eligible to receive indexing rewards. Deployed and emitting, though not yet wired into the rewards flow. | [`init --from`](https://github.com/nightswatchhq/rewards-eligibility-oracle) · [rewards-eligibility-oracle](https://github.com/nightswatchhq/rewards-eligibility-oracle) |

## Ports of subgraphs

Deployment-specific ports of published Graph subgraphs. They exist because the original deployment was
stuck, unserved, costly to query, or needed a self-hosted event-data path. A port states its own
boundary: a source deployment is not an automatic claim of entity-for-entity parity.

| Nest | Status | Chains | Why | Get it |
|------|------|------|---|------|
| **Uniswap V4 Base** | 🟢 available | Base | Uniswap V4's Base deployment - pool lifecycle and swaps, PositionManager subscriptions, and Arrakis private-hook creation, all from three static contracts. | [`init --from`](https://github.com/nightswatchhq/uniswap-v4-base) · [uniswap-v4-base](https://github.com/nightswatchhq/uniswap-v4-base) |
| **SquadSwap WOW v2** | 🟢 available | BNB Smart Chain | Concentrated-liquidity DEX on BNB Smart Chain with a fee-override layer vanilla V3 lacks: a separate PoolManager can override a pool's fee and toggle it independently, so the launch tier is not the live fee. Pools are factory-discovered. | [`init --from`](https://github.com/nightswatchhq/squadswap-wow-v2-bsc) · [squadswap-wow-v2-bsc](https://github.com/nightswatchhq/squadswap-wow-v2-bsc) |
| **DOUDOCHAIN_V2** | 🟢 available | Arbitrum | DOUDOCHAIN_V2 ticket, prize, series, membership, voucher, VRF, refund, redraw and collection-book event data from 13 fixed Arbitrum contracts. | [`init --from`](https://github.com/nightswatchhq/doudouchain-v2-nest) · [doudouchain-v2-nest](https://github.com/nightswatchhq/doudouchain-v2-nest) |
| **Livepeer** | 🟢 available | Arbitrum | The Livepeer protocol - transcoders, rounds, delegators, tickets and governance polls. Built for feature parity with the official Livepeer subgraph. | [`init --from`](https://github.com/nightswatchhq/livepeer-nest) · [livepeer-nest](https://github.com/nightswatchhq/livepeer-nest) |
| **POA** | 🟢 available | Arbitrum | A full DAO-tooling stack - org deployment, Hats-based roles, tasks and bounties, hybrid + direct-democracy voting, and a gas paymaster. Replaces a subgraph that had been stuck syncing for over a day. | [`init --from`](https://github.com/nightswatchhq/poa-nest) · [poa-nest](https://github.com/nightswatchhq/poa-nest) |
| **Aerodrome** | 🟢 available | Base | Aerodrome's ve(3,3) DEX on Base: pools, gauges, votes and fee distribution. The sixth-highest-earning subgraph on the network and the largest non-Uniswap DEX in the top 25. | [`init --from`](https://github.com/nightswatchhq/aerodrome) · [aerodrome](https://github.com/nightswatchhq/aerodrome) |
| **PancakeSwap V3** | 🟢 available | BNB Smart Chain | PancakeSwap V3 concentrated-liquidity pools on BNB Smart Chain. The factory rule ports straight from the uniswap-v3 nest; the pool ABI does not - PancakeSwap's `Swap` carries two extra uint128 protocol-fee params, so a different topic0. | [`init --from`](https://github.com/nightswatchhq/pancakeswap-v3-bsc) · [pancakeswap-v3-bsc](https://github.com/nightswatchhq/pancakeswap-v3-bsc) |
| **Omen** | 🟢 available | Gnosis | Omen prediction markets on Gnosis: fixed-product market makers, positions and trades. | [`init --from`](https://github.com/nightswatchhq/omen-gnosis) · [omen-gnosis](https://github.com/nightswatchhq/omen-gnosis) |
| **Conditional Tokens** | 🟢 available | Gnosis | Gnosis Conditional Tokens: conditions, positions, splits, merges and redemptions - the collateral layer Omen and other prediction markets settle on. | [`init --from`](https://github.com/nightswatchhq/conditional-tokens-gnosis) · [conditional-tokens-gnosis](https://github.com/nightswatchhq/conditional-tokens-gnosis) |
| **Forsage x2** | 🟢 available | BNB Smart Chain | Forsage x2 matrix contract on BNB Smart Chain: registrations, upgrades and referral payouts. A plain fixed-contract event nest. | [`init --from`](https://github.com/nightswatchhq/forsage-bsc) · [forsage-bsc](https://github.com/nightswatchhq/forsage-bsc) |
| **Request Payments** | 🟢 available | Ethereum | Request Network payment proxies: ERC-20 and native payments with reference-tagged settlement. | [`init --from`](https://github.com/nightswatchhq/request-payments) · [request-payments](https://github.com/nightswatchhq/request-payments) |
| **SpookySwap** | 🟡 building | Fantom | SpookySwap's factory and every pair it creates on Fantom Opera: swaps, mints, burns, syncs and LP transfers. | [`init --from`](https://github.com/nightswatchhq/spookyswap-nest) · [spookyswap-nest](https://github.com/nightswatchhq/spookyswap-nest) |
| **Peeranha** | 🟢 available | Polygon | Peeranha's community-driven Q&A protocol on Polygon: users, communities, tags, posts, replies and reputation events across five contracts. | [`init --from`](https://github.com/nightswatchhq/peeranha-nest) · [peeranha-nest](https://github.com/nightswatchhq/peeranha-nest) |

## Other nests

| Nest | Category | Tier | Status | Chains | Get it |
|------|--------|:--:|------|------|------|
| **ERC-20 token** | Token | 1 | 🟢 available | Ethereum, Arbitrum, Base | `nuthatch init 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48` (generic) |
| **ERC-721 / ERC-1155 NFT** | NFT | 1 | 🟢 available | Ethereum, Arbitrum, Base | `nuthatch init 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D` (generic) |
| **Uniswap V4** | DEX | 1 | 🟢 available | Ethereum, BNB Smart Chain, Polygon | [`init --from`](https://github.com/nightswatchhq/uniswap-v4-ethereum) · [uniswap-v4-ethereum](https://github.com/nightswatchhq/uniswap-v4-ethereum) |
| **Uniswap V3** | DEX | 1 | 🟢 available | Arbitrum, Ethereum, Base, BNB Smart Chain, Polygon, Optimism | [`init --from`](https://github.com/nightswatchhq/uniswap-v3) · [uniswap-v3](https://github.com/nightswatchhq/uniswap-v3) |
| **Aave V3** | Lending | 1 | 🟢 available | Ethereum | [`init --from`](https://github.com/nightswatchhq/aave-v3) · [aave-v3](https://github.com/nightswatchhq/aave-v3) |
| **ENS** | Name service | 1 | 🟢 available | Ethereum | [`init --from`](https://github.com/nightswatchhq/ens) · [ens](https://github.com/nightswatchhq/ens) |
| **Uniswap V2 + Sushiswap** | DEX | 2 | 🟢 available | Ethereum | [`init --from`](https://github.com/nightswatchhq/uniswap-v2) · [uniswap-v2](https://github.com/nightswatchhq/uniswap-v2) |
| **Compound V2 + V3** | Lending | 2 | 🟢 available | Ethereum, Arbitrum, Base | [`init --from`](https://github.com/nightswatchhq/compound) · [compound](https://github.com/nightswatchhq/compound) |
| **Lido** | Staking / LST | 2 | 🟢 available | Ethereum | [`init --from`](https://github.com/nightswatchhq/lido) · [lido](https://github.com/nightswatchhq/lido) |
| **Seaport (OpenSea)** | NFT marketplace | 2 | 🟢 available | Ethereum, Arbitrum, Base | [`init --from`](https://github.com/nightswatchhq/seaport) · [seaport](https://github.com/nightswatchhq/seaport) |
| **Curve** | DEX | 2 | 🔴 blocked | Ethereum, Arbitrum | - |
| **EigenLayer** | Restaking | 3 | 🟢 available | Ethereum | [`init --from`](https://github.com/nightswatchhq/eigenlayer) · [eigenlayer](https://github.com/nightswatchhq/eigenlayer) |
| **GMX** | Perps | 3 | 🟢 available | Arbitrum | [`init --from`](https://github.com/nightswatchhq/gmx) · [gmx](https://github.com/nightswatchhq/gmx) |
| **MakerDAO / Sky** | CDP | 3 | 🔴 blocked | Ethereum | - |
| **Uniswap V2 (Arbitrum)** | DEX | 2 | 🟢 available | Arbitrum | [`init --from`](https://github.com/nightswatchhq/uniswap-v2-arbitrum) · [uniswap-v2-arbitrum](https://github.com/nightswatchhq/uniswap-v2-arbitrum) |
| **Uniswap V2 (Base)** | DEX | 2 | 🟢 available | Base | [`init --from`](https://github.com/nightswatchhq/uniswap-v2-base) · [uniswap-v2-base](https://github.com/nightswatchhq/uniswap-v2-base) |
| **Aave V3 (Arbitrum)** | Lending | 1 | 🟢 available | Arbitrum | [`init --from`](https://github.com/nightswatchhq/aave-v3-arbitrum) · [aave-v3-arbitrum](https://github.com/nightswatchhq/aave-v3-arbitrum) |
| **Aave V3 (Base)** | Lending | 1 | 🟢 available | Base | [`init --from`](https://github.com/nightswatchhq/aave-v3-base) · [aave-v3-base](https://github.com/nightswatchhq/aave-v3-base) |
| **Velodrome** | DEX | 2 | 🟢 available | Optimism | [`init --from`](https://github.com/nightswatchhq/velodrome) · [velodrome](https://github.com/nightswatchhq/velodrome) |
| **DAI token** | CDP | 3 | 🟢 available | Ethereum | [`init --from`](https://github.com/nightswatchhq/makerdao-dai) · [makerdao-dai](https://github.com/nightswatchhq/makerdao-dai) |

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
`scripts/render-readme.py`. See [`horizon-nest`](https://github.com/nightswatchhq/horizon-nest) for
the shape.
