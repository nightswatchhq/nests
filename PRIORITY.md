# Proof order

**What this is.** The 35 nests in [`index.json`](index.json), ranked by the order in which proving them
teaches us the most. Not a demand ranking - that is what `tier` already is - and not a hosting plan.
Each one gets built, run against its chain, checked, and its repo published. Nothing is hosted.

**The ordering rule.** A nest earns its place by what it *proves that nothing else has proved yet*, then
by cost, then by demand. Working down a demand list would re-prove plain event decoding twenty times
and leave the hard capabilities untouched until last, which is the opposite of a proof programme.

**Cross off by**: the nest builds from `init`, backfills its range, `nuthatch check` passes against
committed fixtures, and the repo is pushed. Where the subgraph is served, diff it against the gateway
and record the result.

**Two operational notes, both measured 2026-08-22 and both cheap to forget.**

*The bill is block headers.* On a metered endpoint the dominant cost of any nest is
`eth_getBlockByNumber` - one per block containing a matching log - not `eth_getLogs` and not
`[[calls]]`. Traced through a counting proxy, a 171,509-block catch-up issued **61,709 header fetches
against 110 `getLogs` and 24 `eth_call`**: ~99.5% of the cost. Budget in blocks-with-events, not in
contracts. And a nest left tip-following on a metered endpoint costs **~$100/month doing nothing**.

*The built-in public endpoints cannot be assumed.* BSC's only default refuses archive requests
outright ("Archive requests require a personal token"), so no BSC backfill runs on it; it also refuses
address-less `getLogs`, which is exactly what the topic0 flip issues, so a BSC factory nest works until
500 children and then stops. Two of three mainnet defaults are dead (403; transport failure). Gnosis
and Base are genuinely fine. Probe with `nuthatch doctor --rpc <url>` before trusting a backfill.

---

## Already proved, and what by

Keep these in view, because the ranking below exists to fill the gaps they leave.

| Capability | Proved by | Evidence |
|---|---|---|
| Plain event decode | many | routine |
| Multi-contract at scale | DOUDOCHAIN_V2 port | 13 contracts, 84 tables, 2,602 events in 3 min |
| `file/ipfs` data sources | DOUDOCHAIN_V2 port | 58 documents resolved, **every one CID-verified** |
| Row-level parity vs the gateway | Uniswap V3 Arbitrum | **343 swaps, row-for-row identical** on `(block, sqrtPriceX96, tick)` |
| A new chain end to end | BSC | scaffolded via `--chain bsc`; 1.67M events backfilled 200k blocks deep with an operator archive RPC |
| Parameterised `eth_call` | `uniswap-v3` | 18 pools, 18 rows in each of four call tables - one call per pool per declaration, no misses, no duplicates. Symbols decode (`ARBISHIP`, `CPR`); WETH 18 decimals across 15 pools, USDC 6 across 2 |
| **Factory discovery at scale** | `omen-gnosis` | **1,082 children**, and the RFC-0009 §4 topic0 flip *fired* at 540 - `factory backfill filter flipped to topic0-only + local filter`. Decoding survived it: 27,812 buys across all 1,082 distinct addresses |
| Gnosis end to end | `omen-gnosis` + `conditional-tokens-gnosis` | 9 tables populated, 135,545 transfers; 500k blocks in 53s on a keyless public endpoint |

## Still unproved by any nest

- **Top-level call handlers** (RFC-0038 §5). Built and unit-tested; never run against a mapping that
  needs it.
- **Entity derivation**, and by how much a fixed point diverges from the subgraph's order-dependent
  number (RFC-0038 §6a). §6d narrowed this to the *recursive* `findEthPerToken` layer only - the root
  `ethPriceUSD` reproduces the subgraph exactly, to 10^-32.
- **Polygon, Optimism** end to end. (Gnosis is done; see above.)

> **Corrected 2026-08-22.** The first two bullets were stale the day this file was written:
> RFC-0038 §6c recorded parameterised `eth_call` proved on 2026-08-19, the same day. Factory
> discovery at scale was then proved on Gnosis for **nothing** - `omen-gnosis` crosses 500 children
> on a free public endpoint in under a minute - rather than for the ~$1,500 a full Arbitrum
> `uniswap-v3` history would have cost. **Where a capability question can be answered on a cheap
> chain, ask it there.**

---

## The ranking

### 1. `uniswap-v3` (Arbitrum first) - mostly done; one question left
**Correction:** `token0()`, `token1()` and `fee()` are *not* irreducible reads. `PoolCreated` carries
all three in its topics as value types, and `views/10-pools.sql` already selects them - calling the
pool to ask what the event just told us would prove the plumbing and index nothing. The read that
genuinely needs a call is ERC-20 `symbol()`/`decimals()` on the *discovered tokens*, because
`src/metadata.rs` only walks declared `[[contracts]]` and a token found in an event row is not one.
That shipped 2026-08-22 and is proved above.

What remains is **entity derivation** alone, and it is the expensive half: the `derivedETH` divergence
needs the full factory history, which is 495M blocks and ~$1,500 of block-header fetches on a metered
endpoint. Not scheduled. Note the cost is dominated by `eth_getBlockByNumber` - one per block
containing a matching log, ~99% of the bill - not by the logs or the calls.

### 2. `graph-allocations` - DONE 2026-08-22, both halves of the gate
**The ABI half:** the staking implementation `0xaa3359...` *is* Sourcify-verified, and the vendored
`abis/staking.json` matches it **28 events to 28**, nothing missing or extra (control-tested by
dropping a real signature and injecting a fake - the diff catches both). There is **no pending
implementation**: the slot reads zero and the implementation is unchanged across blocks 480M-497M,
which brackets the 2026-07-23 the nest's README cites. The staged upgrade has not executed, so
`POIPresented` still stays out.

**The port queue half**, top four resolved by hand (CIDs via The Graph's IPFS gateway - ipfs.io
returned *empty* for three of the four with a cheerful 200):

| GRT signalled | what it is |
|---:|---|
| 208,847 | **`uniswap_v3` on Ethereum mainnet** |
| 44,287 | Estfor `Players`/`PlayerNFT`, Fantom |
| 20,002 | SpookySwap's factory, Fantom |
| 10,781 | Peeranha, Polygon |

Two of the four are nests we already have, which is the queue validating itself. The most-signalled
unserved deployment on the network is **Uniswap V3 on mainnet** - a two-line `chain`/`chain_id` edit
from the existing nest, since the factory address is identical on every chain. Full mainnet history is
13.4M blocks, ~$146; a recent 1.8M-block window is ~$20.

### 3. `erc20-token` / `erc721-nft` on each new chain - the cheap chain sweep
No repo to clone; `nuthatch init 0xAddr --chain <name>` and go. One each on **Gnosis**, **Optimism**,
**Polygon** proves those three chains end to end for the price of an afternoon, and every later nest on
those chains then starts from a known-good base rather than debugging two things at once.

### 4. `aerodrome` (Base) - DONE 2026-08-22; a factory that is genuinely not Uniswap's
83,099 events over 200k Base blocks: 101 pools, 27,674 swaps, and **27,664 `Fees`**. Those last two
tracking each other to within ten is the ve(3,3) shape showing up in the data - trading fees accrue to
voters rather than to LPs, so a fee is its own event rather than an implicit slice of a swap. A nest
that had merely copied the Uniswap template would have no `Fees` table at all.

`PoolCreated` carries an indexed `stable` bool: one factory, two different curves, and the flag arrives
free in the topics so telling them apart needs no call. The pool ABI needed the **reverse** of the Lido
trick - Aerodrome pools are minimal-proxy clones and every child is unverified on both Sourcify and
Blockscout, but the factory's own `implementation()` names the contract it clones, and *that* is
verified.

### 5. `pancakeswap-v3-bsc` - the reuse test, **run 2026-08-22, and it FAILED**
The falsifiable claim was "this should be largely a config change". It is not.

PancakeSwap's pool `Swap` carries two extra `uint128` protocol-fee parameters:

```
uniswap   Swap(address,address,int256,int256,uint160,uint128,int24)
pancake   Swap(address,address,int256,int256,uint160,uint128,int24,uint128,uint128)
```

Different arity, different topic0. Vendoring `uniswap-v3/abis/pool.json` here matches nothing and
seals **zero swaps while reporting a healthy run** - `factory__pool_created` would still fill. The
pool also has `SetLmPoolEvent`, which Uniswap V3 has no equivalent of.

Verified on-chain, not by reading: over 300 BSC blocks the Uniswap-shaped topic0 returned 1,111 logs
and the nine-parameter one 7,025, and `factory()` on an emitter of each resolves to a *different*
factory. Built with the correct ABI it works - 19,465 swaps, and `pool__initialize` equals
`factory__pool_created` exactly, as it must.

**So the nest format is parameterisable over the factory rule and not over the child ABI.** The
discovery rule really was a config change; the template never can be. Budget an ABI hunt per fork.

### 6. `ens` - registry DONE 2026-08-22; resolvers and `@fulltext` still open
The Registry (`0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e`) builds clean from Sourcify and decodes
4,635 events over 20k mainnet blocks across its five events. That is the ownership graph, not the
resolver surface: text records and the `@fulltext` question - which nuthatch does not have - are
untouched and remain the interesting half.

### 7. `aave-v3` - Pool DONE 2026-08-22; the `aave-forks` template family untested
15 events, 51,253 over 20k mainnet blocks. Notably `init` resolved the *implementation* ABI straight
through the proxy with no help, unlike Lido - so the proxy trap is per-contract, not universal.

Messari's one-schema-many-deployments `aave-forks` shape is what this entry was really for, and it is
still unasked. Given §5's finding - the factory rule ports, the child ABI does not - expect the schema
to port and the per-deployment ABIs not to.

### 8. `omen-gnosis` + `conditional-tokens-gnosis` - DONE 2026-08-22, and they answered #1's question
Both built and verified on a **keyless public endpoint**. `conditional-tokens-gnosis`: 9 tables, 1,269
condition preparations, 1,133 resolutions, 135,545 single transfers. `omen-gnosis`: 1,082 markets,
27,812 buys, and the topic0 flip fired at 540 children with decoding intact.

Two things the build found. The Omen factory's ABI declares the *children's* trade events
(`FPMMBuy`/`FPMMSell`/…) because the Solidity that builds a market maker imports them - decoded on the
factory they stand up four permanently empty tables, so the ABI has to be split. And `CloneCreated`,
inherited from the CloneFactory base, is **never emitted at all**: measured zero from this address over
5,000,000 blocks and zero anywhere on Gnosis. Dropped rather than shipped as a fifth empty table.

### 9. `uniswap-v2` - DONE 2026-08-22, and it found a bug in the core
Deliberately after V3, and it earned its place by failing. Its backfill **aborted**:

```
Error: getLogs (children) 25791463..=25811399
  HTTP 400: Log response size exceeded
```

`backfill_direct_factory` fetches twice per chunk. Pass 1 catches an over-cap response and shrinks the
window; pass 2 - the children discovered *in that chunk* - carried a bare `?` and treated the identical
provider refusal as fatal. It was the only one of nine such sites in the file that did. Pass 2 asks the
harder question (freshly-created children are the busiest), so it is the pass more likely to hit a cap.
Reproduced on two chains and two providers; fixed in nuthatch#759.

With the fix: 51,543 events over 30k blocks, 445 pairs, 23,856 swaps, and 25,697 `Sync` against 25,630
swaps+mints+burns - right, because `Sync` fires on every reserve change.

**This bites every high-complexity factory on the list**: V2, Curve, Aerodrome, PancakeSwap.

### 10. `graph-network` - the crown jewel, and the port queue's engine
Tier 0.1 of the catalogue. Heavy, and #9 in the top 25. Worth doing once the pieces (`graph-staking`,
`graph-gns`, `graph-allocations`) are each proved, since it is largely their union.

### 11-16. Breadth, in demand order
`compound`, `lido`, `curve`, `seaport`, `gmx`, `makerdao`. Each is a category the catalogue names and
none proves a new capability. **Four of the six were built and verified on 2026-08-22**; two of them
are not what this list assumed.

- `compound` (876 events), `seaport` (42,123), `lido` (32 tables; `transfer` == `transfer_shares` ==
  10,144, and 3 `TokenRebased` across ~2.8 days, which is its daily oracle) - all sound.
  **`lido` needed the proxy-implementation trick**: `0xae7a...` is an Aragon proxy whose EIP-1967 slot
  is *empty*, so resolving it directly yields one event, `ProxyDeposit`, and a nest that decodes
  nothing. `implementation()` answers `0x028271E3...`; its ABI is not on Sourcify and was vendored from
  **Blockscout, which speaks the Etherscan-compatible API with no key**.
- **`makerdao` cannot be built as listed.** The Vat's only event is `LogNote`, and it is
  **anonymous** - no topic0, the function selector occupies its slot. nuthatch's decode is
  topic0-keyed, so the nest scaffolds to **zero tables**. This is architectural and applies to every
  core dss contract. `makerdao-dai` (the DAI token, 82,762 events) stands in.
- **`gmx` points at a dormant contract.** The V1 Vault emitted **10 logs in 300,000 blocks** (164 in
  3M). The nest decodes correctly; the subject is dead. V2 routes everything through a generic
  `EventLog`/`EventLog1`/`EventLog2` emitter, which yields opaque encoded blobs rather than typed
  tables - a different decode problem, not a port.
- `curve` is untouched, and is a factory, so budget for the child-ABI hunt §5 describes.

### 17-19. Cheap top-25 stragglers
`forsage-bsc`, `request-payments`, `uniswap-v4` on BNB/Polygon. Low complexity, fixed contracts, real
query-fee demand. Good filler between hard ones.

### 20+. Already available, or deferred
`horizon`, `livepeer`, `poa`, `doudouchain-v2`, `squadswap-wow-v2-bsc`, `uniswap-v4`,
`uniswap-v4-base`, `erc20-token`, `erc721-nft` are published; re-run them when a release needs a
regression sweep rather than as new work. `graph-staking`, `graph-gns`, `graph-tap-escrow`, `ebo` are
building and finish on their own timelines. `qos-reo` and `eigenlayer` stay deferred: neither answers a
question the others leave open.

---

## Why this order and not the demand order

Query fees rank `uniswap-v4-base-3` first and `Graph Network Arbitrum` ninth. Building down that list
would mean four Uniswap V4 deployments before touching a factory, and would have us prove plain event
decode - the one thing already beyond doubt - five more times.

The ordering above front-loads the three questions that could still embarrass us: **does parameterised
`eth_call` work on a real mapping**, **does factory discovery hold at thousands of children**, and
**how far does a fixed-point entity model drift from an order-dependent one**. If those three land, the
rest of the list is work rather than risk.
