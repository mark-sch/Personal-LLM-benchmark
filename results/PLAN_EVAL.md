# 1. Requirements Extraction

## Pass 1: Identify Functional Areas

1. Collection & Data Behaviors
2. Navigation, Home, & Search
3. Show Detail & Person Detail
4. Ask Conversational Discovery
5. Concepts, Explore Similar, & Alchemy
6. AI Voice, Context, & Quality
7. Settings, Export, & Local Preferences
8. Persistence, Mapping, & Migration
9. Identity, Isolation, & Benchmark Auth

## Pass 2: Extract Requirements Within Each Area

### Collection & Data Behaviors

- PRD-001 | `critical` | Overlay saved My Data everywhere shows appear | `product_prd.md > 4.1 Show (Movie or TV)`
- PRD-002 | `critical` | Support core statuses and keep Next hidden | `product_prd.md > 4.2 Status System (“My Status”)`
- PRD-003 | `important` | Interest chips map to Later plus priority | `product_prd.md > 4.2 Status System (“My Status”)`
- PRD-004 | `critical` | Clearing status deletes show and all My Data | `product_prd.md > 4.2 Status System (“My Status”); product_prd.md > 5.4 Removing from Collection`
- PRD-005 | `important` | Interest only matters for Later state | `product_prd.md > 4.3 Interest Levels (“My Interest”)`
- PRD-006 | `important` | Free-form multi-tags power library filters | `product_prd.md > 4.4 Tags (User Lists)`
- PRD-007 | `critical` | Collection membership is defined by assigned status | `product_prd.md > 5.1 Collection Membership`
- PRD-008 | `critical` | Setting status saves an unsaved show | `product_prd.md > 5.2 Saving Triggers`
- PRD-009 | `critical` | Choosing interest chip saves an unsaved show | `product_prd.md > 5.2 Saving Triggers`
- PRD-010 | `critical` | Rating unsaved shows auto-saves as Done | `product_prd.md > 5.2 Saving Triggers; product_prd.md > 5.3 Default Values When Saving`
- PRD-011 | `critical` | Adding first tag auto-saves Later plus Interested | `product_prd.md > 5.2 Saving Triggers; product_prd.md > 7.5 Show Detail Page`
- PRD-012 | `critical` | Implicit saves default to Later plus Interested | `product_prd.md > 5.3 Default Values When Saving`
- PRD-013 | `important` | Removal confirmation supports “don’t ask again” behavior | `product_prd.md > 5.4 Removing from Collection`
- PRD-014 | `critical` | Re-adding preserves My Data and refreshes catalog | `product_prd.md > 5.5 Re-adding the Same Show`
- PRD-015 | `critical` | Per-field timestamps drive conflicts, freshness, sorting | `product_prd.md > 5.6 Timestamps`
- PRD-016 | `important` | AI Scoop persists; Ask/Alchemy state stays session-only | `product_prd.md > 5.7 AI Data Persistence`
- PRD-017 | `critical` | AI recommendations resolve to real shows or fallback | `product_prd.md > 5.8 AI Recommendations Map to Real Shows`
- PRD-018 | `detail` | Tiles show collection and rating badges | `product_prd.md > 5.9 Tile Indicators`
- PRD-019 | `important` | Sync stays consistent and merges duplicates transparently | `product_prd.md > 5.10 Data Sync & Integrity`

### Navigation, Home, & Search

- PRD-020 | `important` | App shell exposes filters and main destinations | `product_prd.md > 6. App Structure & Navigation`
- PRD-021 | `important` | Find hub has persistent entry points and mode switcher | `product_prd.md > 6. App Structure & Navigation`
- PRD-022 | `important` | Filters include tags, no-tags, data, media toggle | `product_prd.md > 4.5 Filters (Ways to View the Collection); product_prd.md > 7.1 Collection Home`
- PRD-023 | `important` | Home groups library into ordered status sections | `product_prd.md > 7.1 Collection Home`
- PRD-024 | `detail` | Home shows badge-rich tiles and empty states | `product_prd.md > 7.1 Collection Home`
- PRD-025 | `critical` | Search supports live title/keyword poster-grid discovery | `product_prd.md > 7.2 Search (Find → Search)`
- PRD-026 | `important` | Search marks saved items, opens detail, auto-launches | `product_prd.md > 7.2 Search (Find → Search)`

### Show Detail & Person Detail

- PRD-027 | `critical` | Detail page is the show’s single truth | `product_prd.md > 7.5 Show Detail Page; detail_page_experience.md > 1. Purpose`
- PRD-028 | `important` | Detail preserves specified section order and discovery stack | `product_prd.md > 7.5 Show Detail Page; detail_page_experience.md > 3. Narrative Hierarchy (Section Intent)`
- PRD-029 | `detail` | Header media prioritizes motion with graceful fallbacks | `detail_page_experience.md > 3.1 Header Media`
- PRD-030 | `important` | Relationship controls stay early, quick, and toolbar-based | `detail_page_experience.md > 3.3 My Relationship Controls`
- PRD-031 | `important` | Scoop UX streams, toggles copy, expires, saves conditionally | `detail_page_experience.md > 3.4 Overview + Scoop; product_prd.md > 4.9 AI Scoop (“The Scoop”)`
- PRD-032 | `important` | “Ask about this show” hands off seeded context | `product_prd.md > 7.3 Ask (Find → Ask); detail_page_experience.md > 3.5 Ask About This Show`
- PRD-033 | `important` | Detail includes recs, providers, people, seasons, finances | `product_prd.md > 7.5 Show Detail Page`
- PRD-034 | `important` | Person detail shows gallery, analytics, yearly credits | `product_prd.md > 7.6 Person Detail Page`

### Ask Conversational Discovery

- PRD-035 | `critical` | Ask uses chat UI for natural-language discovery | `product_prd.md > 4.6 AI Chat Session (“Ask”); product_prd.md > 7.3 Ask (Find → Ask)`
- PRD-036 | `important` | Ask summarizes older turns in persona-preserving short form | `product_prd.md > 4.6 AI Chat Session (“Ask”); ai_prompting_context.md > 4. Conversation Summarization (Chat Surfaces)`
- PRD-037 | `important` | Ask tone stays friendly, honest, spoiler-safe | `product_prd.md > 7.3 Ask (Find → Ask); ai_voice_personality.md > 4.2 Ask (Find → Ask)`
- PRD-038 | `important` | Ask answers fast, uses lists, and makes calls | `discovery_quality_bar.md > 2.2 Ask / Explore Search Chat; ai_voice_personality.md > 4.2 Ask (Find → Ask)`
- PRD-039 | `important` | Ask mentions appear in row with actionable taps | `product_prd.md > 4.6 AI Chat Session (“Ask”); product_prd.md > 7.3 Ask (Find → Ask)`
- PRD-040 | `detail` | Ask welcome view shows six refreshable starters | `product_prd.md > 7.3 Ask (Find → Ask)`
- PRD-041 | `important` | Ask supports both general and show-seeded variants | `product_prd.md > 7.3 Ask (Find → Ask)`
- PRD-042 | `important` | Ask outputs commentary plus exact showList format | `ai_prompting_context.md > 3.2 Ask with Mentions (Structured “Mentioned Shows”)`

### Concepts, Explore Similar, & Alchemy

- PRD-043 | `important` | Concepts are specific, 1-3 word, bullet ingredients | `concept_system.md > 4. Generation Rules; ai_prompting_context.md > 3.4 Concepts (Single-Show and Multi-Show)`
- PRD-044 | `important` | Explore Similar runs concepts-to-recs from Detail | `product_prd.md > 4.8 Explore Similar (Per-Show Concepts); detail_page_experience.md > 3.7 Explore Similar (Concept Discovery)`
- PRD-045 | `critical` | Alchemy supports select, conceptualize, alchemize, chain | `product_prd.md > 4.7 Alchemy Session; product_prd.md > 7.4 Alchemy (Find → Alchemy)`
- PRD-046 | `important` | Alchemy supports backtracking and clears stale downstream state | `product_prd.md > 7.4 Alchemy (Find → Alchemy); concept_system.md > 5. Selection UX Rules`
- PRD-047 | `detail` | Multi-show concepts stay shared and offer larger pool | `concept_system.md > 4. Generation Rules; concept_system.md > 8. Notes`
- PRD-048 | `important` | Explore Similar returns 5, Alchemy 6 concept-grounded recs | `concept_system.md > 6. Concepts → Recommendations Contract; discovery_quality_bar.md > 2.4 Explore Similar / Alchemy Recs`
- PRD-049 | `detail` | Concept recs favor recency without excluding classics | `concept_system.md > 6. Concepts → Recommendations Contract; ai_voice_personality.md > 4.5 Concept-Based Recs (Explore Similar / Alchemy results)`
- PRD-050 | `critical` | Concept recs resolve to real catalog items deterministically | `concept_system.md > 6. Concepts → Recommendations Contract; discovery_quality_bar.md > 1.5 Real-Show Integrity`

### AI Voice, Context, & Quality

- PRD-051 | `important` | AI surfaces share one persona; Search stays non-AI | `ai_voice_personality.md > 1. Persona Summary`
- PRD-052 | `important` | AI stays in TV/movies and redirects off-domain asks | `ai_prompting_context.md > 1. Shared Rules (All AI Surfaces)`
- PRD-053 | `critical` | Ask/Alchemy/Explore Similar use library, My Data, context | `product_prd.md > 8. Cross-Cutting Rules & Principles; ai_prompting_context.md > 2. Shared Inputs (Typical)`
- PRD-054 | `important` | Scoop uses personal take, stack-up, centerpiece, fit, verdict | `ai_prompting_context.md > 3.3 Scoop (Detail Page); ai_voice_personality.md > 4.1 Scoop (Show Detail “The Scoop”)`
- PRD-055 | `important` | Parse failures retry once then hand off to Search | `ai_prompting_context.md > 5. Guardrails & Fallbacks`
- PRD-056 | `important` | Discovery quality demands specificity, surprise, real-show integrity | `discovery_quality_bar.md > 1. Quality Dimensions; discovery_quality_bar.md > 4. Scoring Rubric (Quick)`

### Settings, Export, & Local Preferences

- PRD-057 | `detail` | Settings support font size and Search on Launch | `product_prd.md > 7.7 Settings & Your Data; storage-schema.md > Other persistent storage (key-value settings) > Local settings`
- PRD-058 | `important` | Settings sync username, AI model, catalog provider key | `product_prd.md > 7.7 Settings & Your Data`
- PRD-059 | `critical` | AI keys may come from env and never hit repo | `product_prd.md > 7.7 Settings & Your Data; infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-060 | `critical` | Export My Data ships zipped JSON with ISO dates | `product_prd.md > 7.7 Settings & Your Data`
- PRD-061 | `detail` | Local/UI prefs persist filters and removal confirmations | `storage-schema.md > Other persistent storage (key-value settings) > Local settings; storage-schema.md > Other persistent storage (key-value settings) > UI state`

### Persistence, Mapping, & Migration

- PRD-062 | `critical` | Benchmark stack is Next.js plus Supabase, Docker-optional | `infra_rider_prd.md > 2. Benchmark Baseline (Current Round)`
- PRD-063 | `critical` | Repo is env-configurable with safe key separation | `infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-064 | `critical` | Repo includes scripts and repeatable schema artifacts | `infra_rider_prd.md > 3.2 One-command developer experience; infra_rider_prd.md > 3.3 Database evolution artifacts`
- PRD-065 | `critical` | Backend is source of truth; local cache disposable | `infra_rider_prd.md > 6. Data Ownership & Local Storage; product_prd.md > 8. Cross-Cutting Rules & Principles`
- PRD-066 | `important` | Schema persists core entities, timestamps, and omits transient fields | `storage-schema.md > Stored entities (conceptual); storage-schema.md > Show (movie or TV series) > Not stored (transient)`
- PRD-067 | `important` | Catalog mapping infers types, parses dates, picks best logo, stores provider IDs | `storage-schema.md > External catalog → Show mapping strategy > Field mapping rules (conceptual); storage-schema.md > ProviderData (embedded in Show)`
- PRD-068 | `critical` | Merge policy preserves public data and newest user edits | `storage-schema.md > External catalog → Show mapping strategy > Merge / overwrite policy (important); product_prd.md > 5.5 Re-adding the Same Show`
- PRD-069 | `critical` | Upgrades preserve libraries across model changes automatically | `product_prd.md > 5.11 Data Continuity Across Versions; storage-schema.md > AppMetadata`

### Identity, Isolation, & Benchmark Auth

- PRD-070 | `critical` | Namespace and user isolate all reads, writes, resets | `infra_rider_prd.md > 4. Identity & Isolation Model`
- PRD-071 | `critical` | User-owned records carry opaque stable user IDs | `infra_rider_prd.md > 4.2 User identity (required)`
- PRD-072 | `critical` | Dev identity is gated, documented, OAuth-ready | `infra_rider_prd.md > 5. Authentication Policy (Benchmark-Friendly)`
- PRD-073 | `critical` | Namespace-scoped destructive testing works for cloud agents | `infra_rider_prd.md > 7. Destructive Testing Rules; infra_rider_prd.md > 8. “Cloud Agent” Compatibility`

Total: 73 requirements (30 critical, 35 important, 8 detail) across 9 functional areas

# 2. Coverage Table

| PRD-ID | Requirement | Severity | Coverage | Evidence | Gap |
| ------ | ----------- | -------- | -------- | -------- | --- |
| PRD-001 | Overlay saved My Data everywhere shows appear | critical | full | `5.4 Show Mapping`; `6.1 API Routes` | |
| PRD-002 | Support core statuses and keep Next hidden | critical | full | `2.1 Table: shows`; `10.3 Status Chips UX` | |
| PRD-003 | Interest chips map to Later plus priority | important | full | `7.1 Save Triggers`; `10.3 Status Chips UX` | |
| PRD-004 | Clearing status deletes show and all My Data | critical | full | `7.3 Removal Flow` | |
| PRD-005 | Interest only matters for Later state | important | full | `7.5 Interest Level Logic` | |
| PRD-006 | Free-form multi-tags power library filters | important | full | `8.2 Show Detail`; `10.1 Sidebar / Filter Panel` | |
| PRD-007 | Collection membership is defined by assigned status | critical | full | `5.3 Collection CRUD`; `7.1 Save Triggers` | |
| PRD-008 | Setting status saves an unsaved show | critical | full | `7.1 Save Triggers` | |
| PRD-009 | Choosing interest chip saves an unsaved show | critical | full | `7.1 Save Triggers` | |
| PRD-010 | Rating unsaved shows auto-saves as Done | critical | full | `7.1 Save Triggers`; `7.2 Default Values`; `8.2 Show Detail` | |
| PRD-011 | Adding first tag auto-saves Later plus Interested | critical | full | `7.1 Save Triggers`; `8.2 Show Detail` | |
| PRD-012 | Implicit saves default to Later plus Interested | critical | full | `7.2 Default Values` | |
| PRD-013 | Removal confirmation supports “don’t ask again” behavior | important | full | `7.3 Removal Flow` | |
| PRD-014 | Re-adding preserves My Data and refreshes catalog | critical | full | `5.5 Merge Rules`; `7.4 Re-Adding a Show` | |
| PRD-015 | Per-field timestamps drive conflicts, freshness, sorting | critical | partial | `2.1 Table: shows`; `5.5 Merge Rules`; `9.2 AI Scoop` | The plan covers timestamps for merge and scoop freshness but does not explicitly plan timestamp-based sorting behavior. |
| PRD-016 | AI Scoop persists; Ask/Alchemy state stays session-only | important | partial | `9.2 AI Scoop`; `8.4 Ask Mode`; `8.4 Alchemy Mode` | The plan covers Scoop persistence and client-side session state, but it does not explicitly define reset/leave semantics for Ask history or Alchemy results. |
| PRD-017 | AI recommendations resolve to real shows or fallback | critical | full | `9.5 Concept-Based Recommendations`; `9.6 Fallback Handling` | |
| PRD-018 | Tiles show collection and rating badges | detail | full | `7.6 Tile Indicators`; `10.2 Show Tiles` | |
| PRD-019 | Sync stays consistent and merges duplicates transparently | important | partial | `2.2 Table: cloud_settings`; `5.5 Merge Rules` | The plan implies shared backend state and merge logic, but it never explicitly plans duplicate detection or cross-device sync behavior. |
| PRD-020 | App shell exposes filters and main destinations | important | full | `4.1 Directory Structure`; `Layout` in `4.1 Directory Structure` | |
| PRD-021 | Find hub has persistent entry points and mode switcher | important | full | `8.4 Find/Discover`; `4.1 Directory Structure` | |
| PRD-022 | Filters include tags, no-tags, data, media toggle | important | full | `10.1 Sidebar / Filter Panel`; `8.1 Collection Home` | |
| PRD-023 | Home groups library into ordered status sections | important | full | `8.1 Collection Home` | |
| PRD-024 | Home shows badge-rich tiles and empty states | detail | full | `8.1 Collection Home`; `10.2 Show Tiles` | |
| PRD-025 | Search supports live title/keyword poster-grid discovery | critical | full | `6.1 API Routes`; `8.4 Search Mode` | |
| PRD-026 | Search marks saved items, opens detail, auto-launches | important | full | `8.4 Search Mode` | |
| PRD-027 | Detail page is the show’s single truth | critical | full | `8.2 Show Detail` | |
| PRD-028 | Detail preserves specified section order and discovery stack | important | full | `8.2 Show Detail` | |
| PRD-029 | Header media prioritizes motion with graceful fallbacks | detail | partial | `8.2 Show Detail` | The plan covers inline trailers and fallback media, but it does not explicitly preserve the “never block reading” rule from the UX spec. |
| PRD-030 | Relationship controls stay early, quick, and toolbar-based | important | full | `8.2 Show Detail`; `7.3 Removal Flow` | |
| PRD-031 | Scoop UX streams, toggles copy, expires, saves conditionally | important | full | `8.2 Show Detail`; `9.2 AI Scoop` | |
| PRD-032 | “Ask about this show” hands off seeded context | important | full | `8.2 Show Detail`; `8.4 Ask Mode` | |
| PRD-033 | Detail includes recs, providers, people, seasons, finances | important | full | `8.2 Show Detail` | |
| PRD-034 | Person detail shows gallery, analytics, yearly credits | important | full | `8.3 Person Detail` | |
| PRD-035 | Ask uses chat UI for natural-language discovery | critical | full | `8.4 Ask Mode` | |
| PRD-036 | Ask summarizes older turns in persona-preserving short form | important | full | `8.4 Ask Mode`; `9.3 Ask Chat` | |
| PRD-037 | Ask tone stays friendly, honest, spoiler-safe | important | partial | `9.3 Ask Chat` | The plan preserves the friend persona, but it does not explicitly carry over the “honest about mixed reception” and spoiler-safe Ask contract. |
| PRD-038 | Ask answers fast, uses lists, and makes calls | important | partial | `9.3 Ask Chat` | The plan covers bulleted recommendations and confident picks, but not the direct-answer-within-first-lines requirement. |
| PRD-039 | Ask mentions appear in row with actionable taps | important | full | `8.4 Ask Mode`; `9.3 Ask Chat` | |
| PRD-040 | Ask welcome view shows six refreshable starters | detail | full | `8.4 Ask Mode`; `13. Implementation Order > Phase 4` | |
| PRD-041 | Ask supports both general and show-seeded variants | important | full | `8.4 Ask Mode`; `8.2 Show Detail` | |
| PRD-042 | Ask outputs commentary plus exact showList format | important | full | `8.4 Ask Mode`; `9.3 Ask Chat` | |
| PRD-043 | Concepts are specific, 1-3 word, bullet ingredients | important | partial | `9.4 Concepts` | The plan covers brevity, bullets, specificity, and axes, but it never explicitly forbids genre or plot-point concepts. |
| PRD-044 | Explore Similar runs concepts-to-recs from Detail | important | full | `8.2 Show Detail` | |
| PRD-045 | Alchemy supports select, conceptualize, alchemize, chain | critical | full | `8.4 Alchemy Mode` | |
| PRD-046 | Alchemy supports backtracking and clears stale downstream state | important | full | `8.4 Alchemy Mode` | |
| PRD-047 | Multi-show concepts stay shared and offer larger pool | detail | partial | `9.4 Concepts`; `8.4 Alchemy Mode` | The plan covers shared concepts across inputs, but it fixes concept generation at eight rather than planning a larger multi-show option pool. |
| PRD-048 | Explore Similar returns 5, Alchemy 6 concept-grounded recs | important | full | `9.5 Concept-Based Recommendations`; `8.2 Show Detail`; `8.4 Alchemy Mode` | |
| PRD-049 | Concept recs favor recency without excluding classics | detail | full | `9.5 Concept-Based Recommendations` | |
| PRD-050 | Concept recs resolve to real catalog items deterministically | critical | full | `9.5 Concept-Based Recommendations`; `9.6 Fallback Handling` | |
| PRD-051 | AI surfaces share one persona; Search stays non-AI | important | partial | `9.2 AI Scoop`; `9.3 Ask Chat` | The plan defines persona for Scoop and Ask, but not a single cross-surface voice contract or the explicit rule that Search remains non-AI. |
| PRD-052 | AI stays in TV/movies and redirects off-domain asks | important | partial | `9.3 Ask Chat` | The plan constrains Ask to TV/movies, but it does not state the shared cross-surface guardrail or redirect behavior from the AI context spec. |
| PRD-053 | Ask/Alchemy/Explore Similar use library, My Data, context | critical | partial | `9.3 Ask Chat`; `9.5 Concept-Based Recommendations` | The plan grounds Ask in the library, but Alchemy and Explore Similar only mention library use for duplicate avoidance rather than taste-aware reasoning from My Data and session context. |
| PRD-054 | Scoop uses personal take, stack-up, centerpiece, fit, verdict | important | full | `9.2 AI Scoop` | |
| PRD-055 | Parse failures retry once then hand off to Search | important | full | `9.6 Fallback Handling` | |
| PRD-056 | Discovery quality demands specificity, surprise, real-show integrity | important | partial | `9.5 Concept-Based Recommendations`; `12.2 Test Categories` | The plan handles integrity and concept-linked reasons, but it does not plan the broader qualitative acceptance bar for voice and “surprise without betrayal.” |
| PRD-057 | Settings support font size and Search on Launch | detail | full | `8.5 Settings` | |
| PRD-058 | Settings sync username, AI model, catalog provider key | important | full | `8.5 Settings`; `2.2 Table: cloud_settings` | |
| PRD-059 | AI keys may come from env and never hit repo | critical | full | `1. Project Init`; `8.5 Settings`; `9.1 Provider Abstraction` | |
| PRD-060 | Export My Data ships zipped JSON with ISO dates | critical | full | `8.5 Settings`; `11. Data Export` | |
| PRD-061 | Local/UI prefs persist filters and removal confirmations | detail | full | `7.3 Removal Flow`; `8.1 Collection Home`; `10.1 Sidebar / Filter Panel`; `8.5 Settings` | |
| PRD-062 | Benchmark stack is Next.js plus Supabase, Docker-optional | critical | full | `1. Stack` | |
| PRD-063 | Repo is env-configurable with safe key separation | critical | full | `1. Project Init`; `5.1 Supabase Client Setup` | |
| PRD-064 | Repo includes scripts and repeatable schema artifacts | critical | full | `1. Project Init`; `2. Database Schema & Migrations`; `12.3 Dev Scripts` | |
| PRD-065 | Backend is source of truth; local cache disposable | critical | partial | `5.2 Data Access Pattern` | The plan makes the backend authoritative, but it does not explicitly plan the “clear storage / reinstall without loss” disposal contract for local cache. |
| PRD-066 | Schema persists core entities, timestamps, and omits transient fields | important | full | `2.1 Table: shows`; `2.2 Table: cloud_settings`; `2.3 Table: app_metadata`; `5.4 Show Mapping`; `8.5 Settings` | |
| PRD-067 | Catalog mapping infers types, parses dates, picks best logo, stores provider IDs | important | partial | `5.4 Show Mapping` | The plan covers type inference, date parsing, and deterministic logo selection, but it does not explicitly limit persisted provider data to provider IDs only. |
| PRD-068 | Merge policy preserves public data and newest user edits | critical | full | `5.5 Merge Rules` | |
| PRD-069 | Upgrades preserve libraries across model changes automatically | critical | partial | `2.3 Table: app_metadata`; `2. Database Schema & Migrations` | The plan includes version tracking and migrations, but it never specifies how existing user libraries are safely carried forward without intervention. |
| PRD-070 | Namespace and user isolate all reads, writes, resets | critical | full | `3.1 Namespace Isolation`; `2.4 Row-Level Security (RLS)` | |
| PRD-071 | User-owned records carry opaque stable user IDs | critical | full | `2.1 Table: shows`; `2.2 Table: cloud_settings`; `3.2 User Identity` | |
| PRD-072 | Dev identity is gated, documented, OAuth-ready | critical | full | `3.2 User Identity`; `3.3 Identity Middleware`; `3.4 Migration Path to OAuth` | |
| PRD-073 | Namespace-scoped destructive testing works for cloud agents | critical | full | `3.1 Namespace Isolation`; `12.1 Test Data Isolation`; `1. Stack` | |

# 3. Coverage Scores

score = (full_count × 1.0 + partial_count × 0.5) / total_count × 100

Critical:  (26 × 1.0 + 4 × 0.5) / 30 × 100 = 93.33%  (28.0 of 30 critical requirements)
Important: (26 × 1.0 + 9 × 0.5) / 35 × 100 = 87.14%  (30.5 of 35 important requirements)
Detail:    (6 × 1.0 + 2 × 0.5) / 8 × 100 = 87.50%  (7.0 of 8 detail requirements)
Overall:   (58 × 1.0 + 15 × 0.5) / 73 × 100 = 89.73%  (65.5 of 73 total requirements)

# 4. Top Gaps

1. PRD-069 | `critical` | Upgrades preserve libraries across model changes automatically  
   This matters because the plan includes schema versioning but not a concrete carry-forward strategy, so a future data-model migration could strand or corrupt saved libraries even if the initial build works.

2. PRD-053 | `critical` | Ask/Alchemy/Explore Similar use library, My Data, context  
   This matters because the product’s core promise is taste-aware discovery; if Alchemy and Explore Similar are only concept-driven and duplicate-aware, recommendations can feel generic instead of personalized.

3. PRD-065 | `critical` | Backend is source of truth; local cache disposable  
   This matters because the rider treats disposable local state as a hard execution constraint, and without an explicit plan for cache-clearing/reinstall safety, benchmark runs can pass locally while still violating durability expectations.

4. PRD-015 | `critical` | Per-field timestamps drive conflicts, freshness, sorting  
   This matters because merge correctness, recency ordering, and AI freshness all depend on timestamps; leaving sorting/use cases implicit makes data behavior drift likely under real usage or sync scenarios.

5. PRD-056 | `important` | Discovery quality demands specificity, surprise, real-show integrity  
   This matters because the AI features can be technically complete but still feel flat or off-brand if the plan never defines how to validate voice quality and “surprise without betrayal.”

# 5. Coverage Narrative

This is a strong plan with a relatively small set of meaningful gaps. It covers the product’s structural surface area well: the runtime baseline, persistence model, identity/isolation strategy, page architecture, and almost every major user flow are all explicitly planned. The overall score is high because there are no fully unaddressed requirement clusters; the weaknesses are mostly under-specification rather than absence.

The plan is strongest in the benchmark-facing architecture and the concrete UI/data flows. Identity and namespace isolation are planned carefully, the schema/migration/bootstrap sections are detailed, and the Collection Home, Show Detail, Ask, Alchemy, Settings, and export flows all have explicit sections with recognizable acceptance behavior. The plan is also strong on merge semantics, save/remove business rules, and the overall page/component decomposition.

The gaps cluster in two places. First, AI behavioral contracts are less complete than the feature wiring: the plan explains endpoints, data flow, and some prompt constraints, but it underspecifies the shared persona contract, Ask’s exact response behavior, taste-aware grounding for Alchemy/Explore Similar, and the qualitative discovery bar from the supporting docs. Second, persistence lifecycle guarantees are weaker than initial persistence architecture: the plan creates migrations and timestamps, but it does not explicitly describe cache disposability, sync/duplicate handling, or forward migration of existing user libraries across schema changes.

If this plan were executed exactly as written, the most likely failure mode is not that a page is missing, but that the shipped product feels less like the PRD than it looks. A reviewer would probably first notice that AI recommendations are technically valid yet somewhat generic, or that a schema change / cache reset scenario lacks a clearly planned safety story. In other words, the visible app would be largely complete, but the “taste-aware and durable” promise could fail under closer QA or benchmark regression scrutiny.

The remaining planning work is mostly specification tightening, not a wholesale rewrite. The AI sections need stronger behavioral acceptance criteria: one cross-surface voice contract, explicit grounding inputs for every discovery mode, and a quality bar that can be tested beyond “returns results.” The persistence sections need explicit lifecycle guarantees: how timestamps are used in sorting, what makes local cache disposable, how duplicates are merged across devices, and how migrations preserve existing libraries automatically.
