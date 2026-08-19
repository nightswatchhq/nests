# Proof order

**What this is.** The 33 nests in [`index.json`](index.json), ranked by the order in which proving them
teaches us the most. Not a demand ranking - that is what `tier` already is - and not a hosting plan.
Each one gets built, run against its chain, checked, and its repo published. Nothing is hosted.

**The ordering rule.** A nest earns its place by what it *proves that nothing else has proved yet*, then
by cost, then by demand. Working down a demand list would re-prove plain event decoding twenty times
and leave the hard capabilities untouched until last, which is the opposite of a proof programme.

**Cross off by**: the nest builds from `init`, backfills its range, `nuthatch check` passes against
committed fixtures, and the repo is pushed. Where the subgraph is served, diff it against the gateway
and record the result.

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

## Still unproved by any nest

- **Parameterised `eth_call`** (RFC-0038 §3) against a real subgraph. Built and unit-tested; never run
  against a mapping that actually needs it.
- **Top-level call handlers** (RFC-0038 §5). Same.
- **Factory discovery at scale** - thousands of children, not a handful.
- **Entity derivation**, and by how much a fixed point diverges from the subgraph's order-dependent
  number (RFC-0038 §6a).
- **Gnosis, Polygon, Optimism** end to end.

---

## The ranking

### 1. `uniswap-v3` (Arbitrum first) - the single most informative nest on the list
Factory discovery at scale, parameterised `eth_call` (`token0()`, `token1()`, `fee()` on each pool
creation; ERC-20 `symbol()`/`decimals()` per token), *and* the entity-derivation question all at once.
It is also already half-proved: the swap rows diff clean against the gateway, so the remaining unknown
is exactly the interesting half. **Everything else on this list is easier than this one.** Do it first,
because if it holds, most of the rest is grind.

### 2. `graph-allocations` - finish what is already built
Built today, backfilled, parked. Its release gate is unmet: read the top of the port queue by hand, and
re-check `HorizonStaking`'s pending ABI when it verifies on Sourcify. Cheapest cross-off on the list and
it unblocks the port loop, which is how every later nest finds its next subject.

### 3. `erc20-token` / `erc721-nft` on each new chain - the cheap chain sweep
No repo to clone; `nuthatch init 0xAddr --chain <name>` and go. One each on **Gnosis**, **Optimism**,
**Polygon** proves those three chains end to end for the price of an afternoon, and every later nest on
those chains then starts from a known-good base rather than debugging two things at once.

### 4. `aerodrome` (Base) - a factory that is not Uniswap's
Ranked #6 by query fees, Base is already first-class, and ve(3,3) gauges and voting are a genuinely
different shape from a concentrated-liquidity factory. Proves factory discovery generalises rather than
being fitted to one protocol.

### 5. `pancakeswap-v3-bsc` - the reuse test
The same factory and tick shape as Uniswap V3 on a different chain. If #1 is done and this is not
largely a config change, that tells us the nest format is not as parameterisable as claimed. Cheap, and
it is a *falsifiable* claim rather than more coverage.

### 6. `ens` - the `eth_call` and text-record shape
Resolvers, registrations and text records: a different call pattern from a DEX, and the top-25 entry
most likely to need a read that is not a factory child lookup. Also the one subgraph on the list that
uses `@fulltext`, which nuthatch does not have - so it doubles as the measurement of how much that
actually costs.

### 7. `aave-v3` - the lending shape, and a template family
Messari organises lending subgraphs as `aave-forks`: one schema serving many deployments. If the nest
format can express that family, the catalogue multiplies; if not, we learn the limit here.

### 8. `omen-gnosis` + `conditional-tokens-gnosis` - Gnosis with real subgraphs
Two of the top 25 on one chain, and they compose (Omen settles on Conditional Tokens), so proving both
tests cross-nest reasoning as well as the chain.

### 9. `uniswap-v2` - the simplest possible factory
Deliberately *after* V3. If V3 works, V2 is a formality; running it first would have proved the easy
case and told us nothing about the hard one.

### 10. `graph-network` - the crown jewel, and the port queue's engine
Tier 0.1 of the catalogue. Heavy, and #9 in the top 25. Worth doing once the pieces (`graph-staking`,
`graph-gns`, `graph-allocations`) are each proved, since it is largely their union.

### 11-16. Breadth, in demand order
`compound`, `lido`, `curve`, `seaport`, `gmx`, `makerdao`. Each is a category the catalogue names and
none proves a new capability. Fill these in when the capability questions are settled.

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
