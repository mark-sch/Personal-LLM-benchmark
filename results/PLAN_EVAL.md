# Plan Coverage Evaluation

## 1. Requirements Extraction

### Pass 1: Functional Areas

1. Infrastructure, Execution, and Benchmark Isolation
2. Data Persistence and Merge Integrity
3. Collection Membership and My Data Rules
4. Collection Home, Filters, and Tagging
5. Navigation and Search
6. Show Detail Experience
7. Ask Chat and Mention Contracts
8. Concepts, Explore Similar, and Alchemy
9. Person Detail Experience
10. Settings and Data Portability
11. AI Voice, Prompting, and Discovery Quality

### Pass 2: Requirements by Functional Area

#### Infrastructure, Execution, and Benchmark Isolation
- PRD-001 | `critical` | Use Next.js latest stable as runtime baseline | `showbiz_infra_rider_prd.md > 2. Benchmark Baseline (Current Round)`
- PRD-002 | `critical` | Use Supabase via official client libraries for persistence | `showbiz_infra_rider_prd.md > 2. Benchmark Baseline (Current Round)`
- PRD-003 | `critical` | Provide env contract and secret-safe repo configuration | `showbiz_infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-004 | `important` | Provide one-command scripts for run, test, and reset | `showbiz_infra_rider_prd.md > 3.2 One-command developer experience`
- PRD-005 | `important` | Include repeatable migrations for deterministic fresh database state | `showbiz_infra_rider_prd.md > 3.3 Database evolution artifacts`
- PRD-006 | `critical` | Keep stable namespace per run with strict isolation | `showbiz_infra_rider_prd.md > 4.1 Build/run namespace (required)`
- PRD-007 | `critical` | Scope user-owned records by user and namespace identifiers | `showbiz_infra_rider_prd.md > 4.2 User identity (required)`
- PRD-008 | `important` | Support dev identity now and OAuth-ready schema later | `showbiz_infra_rider_prd.md > 5. Authentication Policy (Benchmark-Friendly)`
- PRD-009 | `important` | Ensure Docker remains optional for local and cloud runs | `showbiz_infra_rider_prd.md > 8. “Cloud Agent” Compatibility`
- PRD-010 | `critical` | Make backend truth with disposable client cache and reset | `showbiz_infra_rider_prd.md > 6. Data Ownership & Local Storage`

#### Data Persistence and Merge Integrity
- PRD-011 | `critical` | Persist show records with catalog, user, and AI fields | `storage-schema.md > Stored entities (conceptual) > Show`
- PRD-012 | `critical` | Track per-field timestamps for status, interest, tags, rating, scoop | `showbiz_prd.md > 5.6 Timestamps`
- PRD-013 | `important` | Prevent empty catalog updates from clobbering stored values | `storage-schema.md > Merge / overwrite policy (important)`
- PRD-014 | `critical` | Resolve My Data conflicts by newest per-field timestamp | `storage-schema.md > Merge / overwrite policy (important)`
- PRD-015 | `critical` | Preserve My Data when refreshing already-saved shows | `showbiz_prd.md > 5.5 Re-adding the Same Show`
- PRD-016 | `critical` | Preserve user libraries safely across data model upgrades | `showbiz_prd.md > 5.11 Data Continuity Across Versions`
- PRD-017 | `important` | Persist only Scoop; keep Ask/Alchemy/Mentions session-scoped | `showbiz_prd.md > 5.7 AI Data Persistence`
- PRD-018 | `critical` | Map AI recommendations to real shows with fallback behavior | `showbiz_prd.md > 5.8 AI Recommendations Map to Real Shows`

#### Collection Membership and My Data Rules
- PRD-019 | `critical` | Define in-collection state by assigned status presence | `showbiz_prd.md > 5.1 Collection Membership`
- PRD-020 | `critical` | Trigger autosave from status, interest, rating, or first tag | `showbiz_prd.md > 5.2 Saving Triggers`
- PRD-021 | `critical` | Apply Later/Interested defaults except rating-first saves as Done | `showbiz_prd.md > 5.3 Default Values When Saving`
- PRD-022 | `important` | Map Interested or Excited chips to Later plus interest | `showbiz_prd.md > 4.2 Status System (“My Status”)`
- PRD-023 | `critical` | Clearing status removes show and clears all My Data | `showbiz_prd.md > 5.4 Removing from Collection`
- PRD-024 | `important` | Require removal confirmation with optional suppression after repeats | `showbiz_prd.md > 5.4 Removing from Collection`
- PRD-025 | `critical` | Always render user-overlay version when a saved show appears | `showbiz_prd.md > 4.1 Show (Movie or TV)`
- PRD-026 | `important` | Show tiles include collection and user-rating indicators | `showbiz_prd.md > 5.9 Tile Indicators`

#### Collection Home, Filters, and Tagging
- PRD-027 | `important` | Home applies active filters and groups library by status | `showbiz_prd.md > 7.1 Collection Home`
- PRD-028 | `important` | Use Active/Excited/Interested/Other status section grouping model | `showbiz_prd.md > 7.1 Collection Home`
- PRD-029 | `important` | Keep active prominence and media-type toggle over filters | `showbiz_prd.md > 7.1 Collection Home`
- PRD-030 | `important` | Provide all, tag, no-tag, genre, decade, score filters | `showbiz_prd.md > 4.5 Filters (Ways to View the Collection)`
- PRD-031 | `detail` | Provide empty states for empty library and filter misses | `showbiz_prd.md > 7.1 Collection Home`

#### Navigation and Search
- PRD-032 | `important` | Keep persistent Find/Discover and Settings app navigation entries | `showbiz_prd.md > 6. App Structure & Navigation`
- PRD-033 | `important` | Offer Search, Ask, Alchemy modes with explicit mode switch | `showbiz_prd.md > 6. App Structure & Navigation`
- PRD-034 | `important` | Search by title/keywords in poster grid with collection marks | `showbiz_prd.md > 7.2 Search (Find → Search)`
- PRD-035 | `detail` | Support optional search auto-open from launch setting | `showbiz_prd.md > 7.2 Search (Find → Search)`

#### Show Detail Experience
- PRD-036 | `critical` | Detail combines facts, My Data, and discovery actions | `showbiz_prd.md > 7.5 Show Detail Page`
- PRD-037 | `important` | Preserve detail narrative hierarchy and section ordering intent | `detail_page_experience.md > 3. Narrative Hierarchy (Section Intent)`
- PRD-038 | `important` | Prioritize rich header media with graceful fallback behavior | `detail_page_experience.md > 3.1 Header Media`
- PRD-039 | `critical` | Keep toolbar relationship controls with destructive reselect handling | `detail_page_experience.md > 3.3 My Relationship Controls`
- PRD-040 | `important` | Scoop UX uses stateful copy and progressive generation feedback | `detail_page_experience.md > 3.4 Overview + Scoop`
- PRD-041 | `important` | Persist Scoop only for saved shows with refresh window | `detail_page_experience.md > 3.4 Overview + Scoop`
- PRD-042 | `important` | Ask-about-show handoff and Explore Similar flow are required | `detail_page_experience.md > 3.5 Ask About This Show`

#### Ask Chat and Mention Contracts
- PRD-043 | `important` | Ask retains context and summarizes older turns for depth | `showbiz_prd.md > 7.3 Ask (Find → Ask)`
- PRD-044 | `important` | Ask voice stays friendly, opinionated, honest, spoiler-safe | `showbiz_prd.md > 7.3 Ask (Find → Ask)`
- PRD-045 | `detail` | Ask welcome shows six random refreshable starter prompts | `showbiz_prd.md > 7.3 Ask (Find → Ask)`
- PRD-046 | `important` | Mentioned shows appear inline and in horizontal strip | `showbiz_prd.md > 7.3 Ask (Find → Ask)`
- PRD-047 | `critical` | Mention protocol requires strict structured output and parsing | `ai_prompting_context.md > 3.2 Ask with Mentions`

#### Concepts, Explore Similar, and Alchemy
- PRD-048 | `critical` | Concepts output bullet-only evocative 1-3 word spoiler-free terms | `ai_prompting_context.md > 3.4 Concepts (Single-Show and Multi-Show)`
- PRD-049 | `important` | Concepts must be specific, diverse, and non-generic | `concept_system.md > 4. Generation Rules`
- PRD-050 | `critical` | Multi-show concepts reflect shared traits across all inputs | `concept_system.md > 4. Generation Rules`
- PRD-051 | `important` | Alchemy and Explore Similar enforce selection flow constraints | `showbiz_prd.md > 7.4 Alchemy (Find → Alchemy)`
- PRD-052 | `important` | Recommendation reasons explicitly tie back to selected concepts | `ai_prompting_context.md > 3.5 Concept-Based Recommendations`
- PRD-053 | `critical` | Recommendation contracts enforce counts and real catalog mapping | `concept_system.md > 6. Concepts → Recommendations Contract`

#### Person Detail Experience
- PRD-054 | `important` | Person page includes gallery, bio, analytics, year-grouped credits | `showbiz_prd.md > 7.6 Person Detail Page`
- PRD-055 | `important` | Tapping person credits opens associated show detail page | `showbiz_prd.md > 7.6 Person Detail Page`

#### Settings and Data Portability
- PRD-056 | `important` | Settings include readability, launch, identity, and AI/provider controls | `showbiz_prd.md > 7.7 Settings & Your Data`
- PRD-057 | `critical` | Keep secrets out of repo and elevated keys server-only | `showbiz_infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-058 | `important` | Export backup as zip JSON with ISO-8601 encoded dates | `showbiz_prd.md > 7.7 Settings & Your Data`

#### AI Voice, Prompting, and Discovery Quality
- PRD-059 | `important` | Keep one AI persona while Search remains non-voice | `ai_voice_personality.md > 1. Persona Summary`
- PRD-060 | `important` | Keep AI in TV/movies and spoiler-safe by default | `ai_prompting_context.md > 1. Shared Rules (All AI Surfaces)`
- PRD-061 | `important` | Favor specific vibe/craft reasoning over generic recommendation filler | `ai_prompting_context.md > 1. Shared Rules (All AI Surfaces)`
- PRD-062 | `important` | Scoop content includes take, stack-up, fit warnings, verdict | `ai_voice_personality.md > 4.1 Scoop (Show Detail “The Scoop”)`
- PRD-063 | `critical` | Discovery quality requires directness, real items, and surprise | `discovery_quality_bar.md > 2. Surface-Specific Minimum Bars`

Total: 63 requirements (25 critical, 35 important, 3 detail) across 11 functional areas

## 2. Coverage Table

| PRD-ID | Requirement | Severity | Coverage | Evidence | Gap |
| ------ | ----------- | -------- | -------- | -------- | --- |
| PRD-001 | Use Next.js latest stable as runtime baseline | critical | full | `1. Architecture & Tech Stack` -> "Framework: Next.js (App Router, Latest Stable)" |  |
| PRD-002 | Use Supabase via official client libraries for persistence | critical | full | `1. Architecture & Tech Stack` -> "Persistence: Supabase (PostgreSQL)" |  |
| PRD-003 | Provide env contract and secret-safe repo configuration | critical | partial | `Phase 1 > Config` mentions `.env.example` | Missing `.gitignore`/secret-handling specifics and no explicit “no source edits needed” commitment. |
| PRD-004 | Provide one-command scripts for run, test, and reset | important | missing | none | Plan does not define required developer scripts, especially namespace-scoped reset script. |
| PRD-005 | Include repeatable migrations for deterministic fresh database state | important | partial | `Phase 1 > Infra` -> "Create setup-db.sql migration" | Single migration mention does not specify repeatable deterministic recreation workflow. |
| PRD-006 | Keep stable namespace per run with strict isolation | critical | partial | `4. Benchmark & Identity Strategy` mentions `namespace_id` via cookies/headers | Isolation guarantees and destructive test scoping are not explicitly planned. |
| PRD-007 | Scope user-owned records by user and namespace identifiers | critical | partial | `2. Data Model` includes `user_id`, `namespace_id`, and composite index | Coverage is only shown for `shows`; plan does not assert this for all user-owned records/entities. |
| PRD-008 | Support dev identity now and OAuth-ready schema later | important | partial | `4. Benchmark & Identity Strategy` describes dev cookies/headers approach | No explicit production gating/documentation plan or OAuth migration strategy. |
| PRD-009 | Ensure Docker remains optional for local and cloud runs | important | missing | none | Plan never addresses Docker optionality or cloud-agent compatibility constraints. |
| PRD-010 | Make backend truth with disposable client cache and reset | critical | missing | none | Source-of-truth/caching/disposable-client guarantees and reset semantics are absent. |
| PRD-011 | Persist show records with catalog, user, and AI fields | critical | partial | `2. Data Model` defines `shows` table and JSONB payload | Schema is high-level and omits many required explicit fields/shape guarantees from storage contract. |
| PRD-012 | Track per-field timestamps for status, interest, tags, rating, scoop | critical | missing | none | Plan only includes a single `updated_at`, not required per-field timestamps. |
| PRD-013 | Prevent empty catalog updates from clobbering stored values | important | partial | `Phase 2 > DB Access` -> "Merge public catalog data with user data" | Merge safety rule (`selectFirstNonEmpty`) is not specified. |
| PRD-014 | Resolve My Data conflicts by newest per-field timestamp | critical | partial | `Phase 2 > DB Access` merge mention | Timestamp-based conflict policy is implied but not defined. |
| PRD-015 | Preserve My Data when refreshing already-saved shows | critical | partial | `Phase 2 > Persistence` and merge mention | No explicit behavior for re-encountering previously saved shows across surfaces. |
| PRD-016 | Preserve user libraries safely across data model upgrades | critical | missing | none | Plan does not include migration/backfill strategy for version upgrades without data loss. |
| PRD-017 | Persist only Scoop; keep Ask/Alchemy/Mentions session-scoped | important | partial | `Phase 3 > The Scoop` persists `aiScoop` | Session-only policies for Ask/Alchemy/Mentions are not specified. |
| PRD-018 | Map AI recommendations to real shows with fallback behavior | critical | partial | `Phase 4 > Explore Similar` -> "Map recommendations back to Catalog IDs" | Missing explicit unresolved-title fallback behavior and match rules. |
| PRD-019 | Define in-collection state by assigned status presence | critical | partial | `Phase 2 > Detail Controls` includes status picker | Plan does not define status-presence as canonical membership rule. |
| PRD-020 | Trigger autosave from status, interest, rating, or first tag | critical | partial | `Phase 2 > Detail Controls` includes status/interest/rating/tags | Triggers for unsaved shows are not explicitly defined. |
| PRD-021 | Apply Later/Interested defaults except rating-first saves as Done | critical | missing | none | Defaulting behavior and rating exception are not in plan tasks. |
| PRD-022 | Map Interested or Excited chips to Later plus interest | important | partial | `Phase 2 > Detail Controls` lists interest picker | Mapping semantics between chips and `Later` status are unspecified. |
| PRD-023 | Clearing status removes show and clears all My Data | critical | missing | none | Removal semantics and full My Data clearing are not described. |
| PRD-024 | Require removal confirmation with optional suppression after repeats | important | missing | none | No confirmation UX or suppression tracking plan exists. |
| PRD-025 | Always render user-overlay version when a saved show appears | critical | partial | `Phase 2 > Persistence` says My Data persists | Cross-surface precedence rule is not made explicit. |
| PRD-026 | Show tiles include collection and user-rating indicators | important | missing | none | Plan does not commit to tile badge indicators. |
| PRD-027 | Home applies active filters and groups library by status | important | full | `Phase 2 > Home Page` -> filter sidebar + grouped collection grid |  |
| PRD-028 | Use Active/Excited/Interested/Other status section grouping model | important | partial | `Phase 2 > Home Page` grouped by status | Specific required bucket model is not spelled out. |
| PRD-029 | Keep active prominence and media-type toggle over filters | important | partial | `Phase 2 > Home Page` includes type filter and grouped view | No explicit active prominence treatment or top-level media toggle behavior. |
| PRD-030 | Provide all, tag, no-tag, genre, decade, score filters | important | partial | `Phase 2 > Home Page` -> "Filter Sidebar (Status, Tags, Type)" | Missing no-tags, genre, decade, and community score filters. |
| PRD-031 | Provide empty states for empty library and filter misses | detail | missing | none | Empty-state behaviors are omitted. |
| PRD-032 | Keep persistent Find/Discover and Settings app navigation entries | important | partial | `Directory Structure` includes `/search`, `/ask`, `/alchemy`, `/settings` and sidebar shell | Route presence is planned, but persistent global entry behavior is not explicit. |
| PRD-033 | Offer Search, Ask, Alchemy modes with explicit mode switch | important | partial | Separate pages for `/search`, `/ask`, `/alchemy` | Clear in-hub mode-switcher behavior is not defined. |
| PRD-034 | Search by title/keywords in poster grid with collection marks | important | partial | `Phase 1 > Search Page` -> search input and grid results | In-collection markers and complete behavior details are missing. |
| PRD-035 | Support optional search auto-open from launch setting | detail | missing | none | Search-on-launch setting is not planned. |
| PRD-036 | Detail combines facts, My Data, and discovery actions | critical | partial | `Phase 1` read-only detail + `Phase 2` controls + `Phase 3/4` AI actions | Required major-section completeness is not fully enumerated. |
| PRD-037 | Preserve detail narrative hierarchy and section ordering intent | important | missing | none | No ordering/hierarchy constraint appears in the plan. |
| PRD-038 | Prioritize rich header media with graceful fallback behavior | important | partial | `Phase 1 > Detail Page` renders header/facts/overview | No trailer prioritization or fallback rules included. |
| PRD-039 | Keep toolbar relationship controls with destructive reselect handling | critical | partial | `Phase 2 > Detail Controls` defines status/interest/rating/tags controls | Toolbar placement and reselect-removal behavior are not defined. |
| PRD-040 | Scoop UX uses stateful copy and progressive generation feedback | important | partial | `Phase 3 > The Scoop` -> button + stream response | Missing explicit copy-state contract and non-blank loading behavior details. |
| PRD-041 | Persist Scoop only for saved shows with refresh window | important | missing | none | Plan persists `aiScoop` but omits saved-only persistence gate and freshness window. |
| PRD-042 | Ask-about-show handoff and Explore Similar flow are required | important | partial | `Phase 4 > Explore Similar` present | Ask-about-this-show seeded handoff behavior is absent. |
| PRD-043 | Ask retains context and summarizes older turns for depth | important | partial | `Phase 3 > Ask` injects collection context into chat | No summary policy for older turns is planned. |
| PRD-044 | Ask voice stays friendly, opinionated, honest, spoiler-safe | important | partial | `Phase 3` goal says "taste-aware" AI | Tone/voice/guardrail constraints are not specified concretely. |
| PRD-045 | Ask welcome shows six random refreshable starter prompts | detail | missing | none | Starter prompt UX is not included. |
| PRD-046 | Mentioned shows appear inline and in horizontal strip | important | partial | `Phase 3 > Ask` -> mentioned shows parsing/rendering | Plan does not explicitly guarantee inline + strip dual rendering. |
| PRD-047 | Mention protocol requires strict structured output and parsing | critical | partial | `Phase 3 > Ask` mentions parsing/rendering mentioned shows | Exact output format, parser contract, and retry fallback are missing. |
| PRD-048 | Concepts output bullet-only evocative 1-3 word spoiler-free terms | critical | partial | `Phase 4 > Concepts` implements `getConcepts(show)` | No explicit output-format constraints are defined. |
| PRD-049 | Concepts must be specific, diverse, and non-generic | important | missing | none | Quality constraints for concept wording are absent. |
| PRD-050 | Multi-show concepts reflect shared traits across all inputs | critical | partial | `Phase 4 > Alchemy` concept extraction from multiple shows | Shared-across-all-inputs constraint is not explicit. |
| PRD-051 | Alchemy and Explore Similar enforce selection flow constraints | important | partial | `Phase 4` includes select concepts and recommendation loop | Missing explicit minimums/caps/backtracking-clears behavior. |
| PRD-052 | Recommendation reasons explicitly tie back to selected concepts | important | partial | `Phase 4` recommendation generation | Plan never specifies concept-linked reason text contract. |
| PRD-053 | Recommendation contracts enforce counts and real catalog mapping | critical | partial | `Phase 4 > Explore Similar` maps recs to catalog IDs | Required fixed counts (5/6) and complete contract details are missing. |
| PRD-054 | Person page includes gallery, bio, analytics, year-grouped credits | important | missing | none | Person detail feature is not represented in plan phases. |
| PRD-055 | Tapping person credits opens associated show detail page | important | missing | none | Person-to-show navigation is not planned. |
| PRD-056 | Settings include readability, launch, identity, and AI/provider controls | important | partial | `Phase 5 > Settings` -> API key configuration only | Missing font/readability, search-on-launch, username, model, and provider-key details. |
| PRD-057 | Keep secrets out of repo and elevated keys server-only | critical | missing | none | Credential-handling policy is not specified. |
| PRD-058 | Export backup as zip JSON with ISO-8601 encoded dates | important | partial | `Phase 5 > Export` -> "Generate JSON dump of user data" | Missing zip packaging and ISO-8601 date encoding requirements. |
| PRD-059 | Keep one AI persona while Search remains non-voice | important | partial | `Phase 3` introduces Ask/Scoop AI services | Persona consistency and Search non-AI voice boundaries are not planned explicitly. |
| PRD-060 | Keep AI in TV/movies and spoiler-safe by default | important | partial | `Phase 3` general AI foundation language | Domain and spoiler guardrails are not codified. |
| PRD-061 | Favor specific vibe/craft reasoning over generic recommendation filler | important | missing | none | Reasoning-quality contract is not present in planning tasks. |
| PRD-062 | Scoop content includes take, stack-up, fit warnings, verdict | important | missing | none | Scoop structure/content requirements are not planned beyond generation. |
| PRD-063 | Discovery quality requires directness, real items, and surprise | critical | partial | `Phase 5 > Review` -> audit against `discovery_quality_bar.md` | Plan references the quality doc but lacks concrete acceptance gates and measurable criteria. |

## 3. Coverage Scores

Critical:  (full × 1.0 + partial × 0.5) / critical_total × 100 = (2 × 1.0 + 17 × 0.5) / 25 × 100 = 42.0%  (10.5 of 25 critical requirements)
Important: (full × 1.0 + partial × 0.5) / important_total × 100 = (1 × 1.0 + 23 × 0.5) / 35 × 100 = 35.7%  (12.5 of 35 important requirements)
Detail:    (full × 1.0 + partial × 0.5) / detail_total × 100 = (0 × 1.0 + 0 × 0.5) / 3 × 100 = 0.0%  (0 of 3 detail requirements)
Overall:   (full × 1.0 + partial × 0.5) / total × 100 = (3 × 1.0 + 40 × 0.5) / 63 × 100 = 36.5% (63 total requirements)

## 4. Top Gaps

1. PRD-010 | `critical` | Make backend truth with disposable client cache and reset  
This gap leaves data correctness, cache invalidation, and destructive-test reset behavior undefined, which can cause inconsistent state between clients and server.

2. PRD-012 | `critical` | Track per-field timestamps for status, interest, tags, rating, scoop  
Without field-level timestamps, merge/conflict logic cannot safely preserve user edits, especially under sync and refresh scenarios.

3. PRD-016 | `critical` | Preserve user libraries safely across data model upgrades  
No migration continuity plan means real users could lose collections or My Data when schema/model evolves.

4. PRD-021 | `critical` | Apply Later/Interested defaults except rating-first saves as Done  
Core “rate-to-save” and implicit-save journeys can drift from product behavior, breaking expected collection semantics.

5. PRD-057 | `critical` | Keep secrets out of repo and elevated keys server-only  
Missing credential boundaries risks key leakage and invalid benchmark security posture.

## 5. Coverage Narrative

This is a structurally useful but under-specified plan. It captures the broad architecture, feature sequencing, and major surfaces, but it does not yet encode many of the PRD’s behavioral contracts. At 36.5% weighted coverage, it is not execution-ready for parity; it is a foundation draft that still needs specification depth before implementation begins.

The strongest coverage clusters are baseline architecture and core surface scaffolding: Next.js + Supabase baseline choices, a phased delivery model, primary pages/routes, home grouping intent, and initial AI feature lanes (Scoop, Ask, Concepts, Alchemy). The plan also correctly introduces namespace and user identifiers and includes high-level mapping of recommendations back to catalog IDs.

Gaps concentrate in rule-heavy areas: persistence integrity contracts, implicit save/remove semantics, detail-page behavioral specifics, structured AI I/O contracts, and infra safety constraints. Most misses are not random; they cluster around “exact behavior under edge and lifecycle conditions” (merge conflicts, stale data refresh, fallback handling, session boundaries, migration continuity, and key management). The plan tends to say what feature exists, but not how it must behave to satisfy the PRD.

If executed as-is, the most likely failure mode is a product that looks complete in demos but fails QA on deterministic behaviors: save defaults, removal semantics, mention parsing, concept/recommendation quality bars, and data durability across refreshes/upgrades. Stakeholders would likely notice mismatches first in collection consistency and AI recommendation reliability (especially real-show mapping and reasoning quality).

Remediation work should focus on adding concrete behavioral specs and acceptance criteria, not adding more epics. Specifically: define persistence/merge contracts in detail, codify autosave/removal defaults, formalize AI structured output and fallback protocols, add security/credential handling constraints, and attach measurable quality gates from `discovery_quality_bar.md` to phase exit criteria.
