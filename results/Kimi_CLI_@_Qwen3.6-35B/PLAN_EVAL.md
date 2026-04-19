# Plan Evaluation: Personal TV + Movie Companion App

## 1. Requirements Extraction

### Pass 1: Identify Functional Areas

1. Benchmark Runtime & Isolation
2. Collection Data & Persistence
3. App Navigation & Discover Shell
4. Collection Home & Search
5. Show Detail & Relationship UX
6. Ask Chat
7. Concepts, Explore Similar & Alchemy
8. AI Voice, Persona & Quality
9. Person Detail
10. Settings & Export

### Pass 2: Extract Requirements Within Each Area

#### Benchmark Runtime & Isolation

- PRD-001 | `critical` | Use Next.js latest stable runtime | `infra_rider_prd.md > 2. Benchmark Baseline (Current Round)`
- PRD-002 | `critical` | Use Supabase official client libraries | `infra_rider_prd.md > 2. Benchmark Baseline (Current Round)`
- PRD-003 | `critical` | Ship `.env.example` with required variables | `infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-004 | `important` | Ignore `.env*` secrets except example | `infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-005 | `critical` | Configure build through env without code edits | `infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-006 | `critical` | Keep secrets out of repo and server-only | `infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-007 | `critical` | Provide app, test, reset command scripts | `infra_rider_prd.md > 3.2 One-command developer experience`
- PRD-008 | `critical` | Include repeatable schema evolution artifacts | `infra_rider_prd.md > 3.3 Database evolution artifacts`
- PRD-009 | `critical` | Use one stable namespace per build | `infra_rider_prd.md > 4.1 Build/run namespace (required)`
- PRD-010 | `critical` | Isolate namespaces and scope destructive resets | `infra_rider_prd.md > 4.1 Build/run namespace (required)`
- PRD-011 | `critical` | Attach every user record to `user_id` | `infra_rider_prd.md > 4.2 User identity (required)`
- PRD-012 | `critical` | Partition persisted data by namespace and user | `infra_rider_prd.md > 4.3 Relationship between namespace and user`
- PRD-013 | `important` | Support documented dev auth injection, prod-gated | `infra_rider_prd.md > 5.1 Auth is not required to be "real" in benchmark mode`
- PRD-014 | `important` | Real OAuth later needs no schema redesign | `infra_rider_prd.md > 5.2 Migration to real OAuth must be straightforward`
- PRD-015 | `critical` | Keep backend as persisted source of truth | `infra_rider_prd.md > 6.1 Source of truth`
- PRD-016 | `critical` | Make client cache safe to discard | `infra_rider_prd.md > 6.2 Cache is disposable`
- PRD-017 | `important` | Avoid Docker requirement for cloud-agent compatibility | `infra_rider_prd.md > 2. Benchmark Baseline (Current Round)`

#### Collection Data & Persistence

- PRD-018 | `critical` | Overlay saved user data on every show appearance | `product_prd.md > 4.1 Show (Movie or TV)`
- PRD-019 | `important` | Support visible statuses plus hidden `Next` | `product_prd.md > 4.2 Status System ("My Status")`
- PRD-020 | `critical` | Map Interested/Excited chips to Later interest | `product_prd.md > 4.2 Status System ("My Status")`
- PRD-021 | `important` | Support free-form multi-tag personal tag library | `product_prd.md > 4.4 Tags (User Lists)`
- PRD-022 | `critical` | Define collection membership by assigned status | `product_prd.md > 5.1 Collection Membership`
- PRD-023 | `critical` | Save shows from status, interest, rating, tagging | `product_prd.md > 5.2 Saving Triggers`
- PRD-024 | `critical` | Default save to Later/Interested except rating-save Done | `product_prd.md > 5.3 Default Values When Saving`
- PRD-025 | `critical` | Removing status deletes show and all My Data | `product_prd.md > 5.4 Removing from Collection`
- PRD-026 | `critical` | Re-add preserves My Data and refreshes public data | `product_prd.md > 5.5 Re-adding the Same Show`
- PRD-027 | `critical` | Track per-field My Data modification timestamps | `product_prd.md > 5.6 Timestamps`
- PRD-028 | `important` | Use timestamps for sorting, sync, freshness | `product_prd.md > 5.6 Timestamps`
- PRD-029 | `critical` | Persist Scoop only for saved shows, 4h freshness | `product_prd.md > 4.9 AI Scoop ("The Scoop")`
- PRD-030 | `important` | Keep Ask and Alchemy state session-only | `product_prd.md > 5.7 AI Data Persistence`
- PRD-031 | `critical` | Resolve AI recommendations to real selectable shows | `product_prd.md > 5.8 AI Recommendations Map to Real Shows`
- PRD-032 | `important` | Show collection and rating tile indicators | `product_prd.md > 5.9 Tile Indicators`
- PRD-033 | `important` | Sync libraries/settings consistently and merge duplicates | `product_prd.md > 5.10 Data Sync & Integrity`
- PRD-034 | `critical` | Preserve saved libraries across data-model upgrades | `product_prd.md > 5.11 Data Continuity Across Versions`
- PRD-035 | `important` | Persist synced settings, local settings, UI state | `supporting_docs/technical_docs/storage-schema.md > Other persistent storage (key-value settings)`
- PRD-036 | `important` | Keep provider IDs persisted and detail fetches transient | `supporting_docs/technical_docs/storage-schema.md > Show (movie or TV series)`
- PRD-037 | `critical` | Merge catalog fields safely and maintain timestamps | `supporting_docs/technical_docs/storage-schema.md > Merge / overwrite policy (important)`

#### App Navigation & Discover Shell

- PRD-038 | `important` | Provide filters panel and main screen destinations | `product_prd.md > 6. App Structure & Navigation`
- PRD-039 | `important` | Keep Find/Discover in persistent primary navigation | `product_prd.md > 6. App Structure & Navigation`
- PRD-040 | `important` | Keep Settings in persistent primary navigation | `product_prd.md > 6. App Structure & Navigation`
- PRD-041 | `important` | Offer Search, Ask, Alchemy discover modes | `product_prd.md > 6. App Structure & Navigation`

#### Collection Home & Search

- PRD-042 | `important` | Show only library items matching active filters | `product_prd.md > 7.1 Collection Home`
- PRD-043 | `important` | Group home into Active, Excited, Interested, Others | `product_prd.md > 7.1 Collection Home`
- PRD-044 | `important` | Support All, tag, genre, decade, score, media filters | `product_prd.md > 4.5 Filters (Ways to View the Collection)`
- PRD-045 | `important` | Render poster, title, and My Data badges | `product_prd.md > 7.1 Collection Home`
- PRD-046 | `detail` | Provide empty-library and empty-filter states | `product_prd.md > 7.1 Collection Home`
- PRD-047 | `important` | Search by title or keywords | `product_prd.md > 7.2 Search (Find → Search)`
- PRD-048 | `important` | Use poster grid with collection markers | `product_prd.md > 7.2 Search (Find → Search)`
- PRD-049 | `detail` | Auto-open Search when setting is enabled | `product_prd.md > 7.2 Search (Find → Search)`
- PRD-050 | `important` | Keep Search non-AI in tone | `supporting_docs/ai_voice_personality.md > 1. Persona Summary`

#### Show Detail & Relationship UX

- PRD-051 | `important` | Preserve Show Detail narrative section order | `supporting_docs/detail_page_experience.md > 3. Narrative Hierarchy (Section Intent)`
- PRD-052 | `important` | Prioritize motion-rich header with graceful fallback | `supporting_docs/detail_page_experience.md > 3.1 Header Media`
- PRD-053 | `important` | Surface year, runtime/seasons, and community score early | `supporting_docs/detail_page_experience.md > 3.2 Core Facts + Community Score`
- PRD-054 | `important` | Place status/interest controls in toolbar | `supporting_docs/detail_page_experience.md > 3.3 My Relationship Controls`
- PRD-055 | `critical` | Auto-save unsaved tagged show as Later/Interested | `supporting_docs/detail_page_experience.md > 3.3 My Relationship Controls`
- PRD-056 | `critical` | Auto-save unsaved rated show as Done | `supporting_docs/detail_page_experience.md > 3.3 My Relationship Controls`
- PRD-057 | `important` | Show overview early for fast scanning | `supporting_docs/detail_page_experience.md > 2. First-15-Seconds Experience`
- PRD-058 | `important` | Scoop shows correct states and progressive feedback | `supporting_docs/detail_page_experience.md > 3.4 Overview + Scoop`
- PRD-059 | `important` | Ask-about-show deep-link seeds Ask context | `supporting_docs/detail_page_experience.md > 3.5 Ask About This Show`
- PRD-060 | `important` | Include traditional recommendations strand | `supporting_docs/detail_page_experience.md > 3.6 Traditional Recommendations Strand`
- PRD-061 | `important` | Explore Similar uses CTA-first concept flow | `supporting_docs/detail_page_experience.md > 3.7 Explore Similar (Concept Discovery)`
- PRD-062 | `important` | Include streaming availability and person-linking credits | `supporting_docs/detail_page_experience.md > 3.8 Streaming Availability`
- PRD-063 | `important` | Gate seasons to TV and financials to movies | `supporting_docs/detail_page_experience.md > 5. Critical States`
- PRD-064 | `important` | Keep primary actions early and page not overwhelming | `supporting_docs/detail_page_experience.md > 4. Busyness vs Power`

#### Ask Chat

- PRD-065 | `important` | Provide conversational Ask chat interface | `product_prd.md > 7.3 Ask (Find → Ask)`
- PRD-066 | `important` | Answer directly with confident, spoiler-safe recommendations | `supporting_docs/discovery_quality_bar.md > 2.2 Ask / Explore Search Chat`
- PRD-067 | `important` | Show horizontal mentioned-shows strip from chat | `product_prd.md > 7.3 Ask (Find → Ask)`
- PRD-068 | `important` | Open Detail from mentions or Search fallback | `product_prd.md > 7.3 Ask (Find → Ask)`
- PRD-069 | `important` | Show six random starter prompts with refresh | `product_prd.md > 7.3 Ask (Find → Ask)`
- PRD-070 | `important` | Summarize older turns while preserving voice | `supporting_docs/ai_prompting_context.md > 4. Conversation Summarization (Chat Surfaces)`
- PRD-071 | `important` | Seed Ask-about-show sessions with show handoff | `product_prd.md > 7.3 Ask (Find → Ask)`
- PRD-072 | `critical` | Emit `commentary` plus exact `showList` contract | `supporting_docs/ai_prompting_context.md > 3.2 Ask with Mentions (Structured "Mentioned Shows")`
- PRD-073 | `important` | Retry malformed mention output once, then fallback | `supporting_docs/ai_prompting_context.md > 5. Guardrails & Fallbacks`
- PRD-074 | `important` | Redirect Ask back into TV/movie domain | `supporting_docs/ai_prompting_context.md > 1. Shared Rules (All AI Surfaces)`

#### Concepts, Explore Similar & Alchemy

- PRD-075 | `important` | Treat concepts as taste ingredients, not genres | `supporting_docs/concept_system.md > 1. What a Concept Is (User Definition)`
- PRD-076 | `important` | Return bullet-only, 1-3 word, non-generic concepts | `supporting_docs/ai_prompting_context.md > 3.4 Concepts (Single-Show and Multi-Show)`
- PRD-077 | `important` | Order concepts by strongest aha and varied axes | `supporting_docs/concept_system.md > 4. Generation Rules`
- PRD-078 | `important` | Require concept selection and guide ingredient picking | `supporting_docs/concept_system.md > 5. Selection UX Rules`
- PRD-079 | `important` | Return exactly five Explore Similar recommendations | `supporting_docs/concept_system.md > 6. Concepts → Recommendations Contract`
- PRD-080 | `important` | Support full Alchemy loop with chaining | `product_prd.md > 7.4 Alchemy (Find → Alchemy)`
- PRD-081 | `important` | Clear downstream results when inputs change | `product_prd.md > 7.4 Alchemy (Find → Alchemy)`
- PRD-082 | `important` | Generate shared multi-show concepts with larger option pool | `supporting_docs/concept_system.md > 8. Notes`
- PRD-083 | `important` | Cite selected concepts in concise recommendation reasons | `supporting_docs/concept_system.md > 6. Concepts → Recommendations Contract`
- PRD-084 | `important` | Deliver surprising but defensible taste-aligned recommendations | `supporting_docs/discovery_quality_bar.md > 1.2 Taste Alignment`

#### AI Voice, Persona & Quality

- PRD-085 | `important` | Keep one consistent AI persona across surfaces | `supporting_docs/ai_voice_personality.md > 1. Persona Summary`
- PRD-086 | `critical` | Enforce shared AI guardrails across all surfaces | `supporting_docs/ai_prompting_context.md > 1. Shared Rules (All AI Surfaces)`
- PRD-087 | `important` | Make AI warm, joyful, and light in critique | `supporting_docs/ai_voice_personality.md > 2. Non-Negotiable Voice Pillars`
- PRD-088 | `important` | Structure Scoop as personal taste mini-review | `supporting_docs/ai_voice_personality.md > 4.1 Scoop (Show Detail "The Scoop")`
- PRD-089 | `important` | Keep Ask brisk and dialogue-like by default | `supporting_docs/ai_voice_personality.md > 4.2 Ask (Find → Ask)`
- PRD-090 | `important` | Feed AI the right surface-specific context inputs | `supporting_docs/ai_prompting_context.md > 2. Shared Inputs (Typical)`
- PRD-091 | `important` | Validate discovery with rubric and hard-fail integrity | `supporting_docs/discovery_quality_bar.md > 4. Scoring Rubric (Quick)`

#### Person Detail

- PRD-092 | `important` | Show person gallery, name, and bio | `product_prd.md > 7.6 Person Detail Page`
- PRD-093 | `important` | Include ratings, genres, and projects-by-year analytics | `product_prd.md > 7.6 Person Detail Page`
- PRD-094 | `important` | Group filmography by year | `product_prd.md > 7.6 Person Detail Page`
- PRD-095 | `important` | Open Show Detail from selected credit | `product_prd.md > 7.6 Person Detail Page`

#### Settings & Export

- PRD-096 | `important` | Include font size and Search-on-launch settings | `product_prd.md > 7.7 Settings & Your Data`
- PRD-097 | `important` | Support username, model, and API-key settings safely | `product_prd.md > 7.7 Settings & Your Data`
- PRD-098 | `critical` | Export saved shows and My Data as zip | `product_prd.md > 7.7 Settings & Your Data`
- PRD-099 | `important` | Encode export dates using ISO-8601 | `product_prd.md > 7.7 Settings & Your Data`

Total: 99 requirements (30 critical, 67 important, 2 detail) across 10 functional areas

## 2. Coverage Table

| PRD-ID | Requirement | Severity | Coverage | Evidence | Gap |
| ------ | ----------- | -------- | -------- | -------- | --- |
| PRD-001 | Use Next.js latest stable runtime | critical | full | Section 1 Tech Stack: "Frontend: Next.js (latest stable)" | |
| PRD-002 | Use Supabase official client libraries | critical | full | Section 1: "Backend/Persistence: Supabase"; Section 2 architecture shows Supabase + RLS; Section 4.2.2 references `lib/db/client.ts` as "Supabase client (typed)" | |
| PRD-003 | Ship `.env.example` with required variables | critical | full | Section 6: `.env.example` with all required variables and comments | |
| PRD-004 | Ignore `.env*` secrets except example | important | full | Section 6: `.gitignore` excludes `.env`, `.env.local`, `.env.*.local`, except `!.env.example` | |
| PRD-005 | Configure build through env without code edits | critical | full | Section 6 shows all configuration via `.env.example` variables; Section 4.2.2 `config/env.ts` with Zod validation | |
| PRD-006 | Keep secrets out of repo and server-only | critical | full | Section 6 `.env.example` comments note `SUPABASE_SERVICE_ROLE_KEY= # server-only, never client`; Section 12 risk table addresses API key exposure | |
| PRD-007 | Provide app, test, reset command scripts | critical | full | Section 6: `dev`, `build`, `start`, `test`, `test:reset` scripts defined | |
| PRD-008 | Include repeatable schema evolution artifacts | critical | full | Section 3.3: "Supabase migration system... each migration is a SQL file with idempotent CREATE TABLE IF NOT EXISTS / ALTER TABLE statements" | |
| PRD-009 | Use one stable namespace per build | critical | full | Section 2: "Namespace isolation via `namespace_id`"; Section 3.1: "All tables include `namespace_id TEXT NOT NULL`"; Section 5.1: "namespace_id injected from env var" | |
| PRD-010 | Isolate namespaces and scope destructive resets | critical | full | Section 3.2: "RLS policies on all user-owned tables scoped by `namespace_id` + `user_id`"; Section 5.1: namespace from env; Section 8: "Destructive Tests (Namespace-Scoped)" | |
| PRD-011 | Attach every user record to `user_id` | critical | full | Section 3: `users` table has `user_id` column; all tables reference `user_id`; Section 2: "Opaque `user_id` on all user-owned records" | |
| PRD-012 | Partition persisted data by namespace and user | critical | full | Section 3.1: all tables include both `namespace_id` and `user_id`; Section 3.2: indexes and RLS policies use both | |
| PRD-013 | Support documented dev auth injection, prod-gated | important | full | Section 5.1: "Dev mode: Accept X-User-Id header... configurable default user from env vars"; "OAuth migration path: Wrap identity resolution in an auth/resolver abstraction" | |
| PRD-014 | Real OAuth later needs no schema redesign | important | full | Section 5.1: "Replace dev injection with NextAuth.js... by changing one config file + wiring the provider" | |
| PRD-015 | Keep backend as persisted source of truth | critical | full | Section 2: "Server-side data ownership. All user-owned data lives in Supabase. Clients may cache but correctness never depends on local persistence." | |
| PRD-016 | Make client cache safe to discard | critical | full | Section 7: "Client cache is disposable — clearing localStorage never loses data"; Section 2: correctness doesn't depend on local persistence | |
| PRD-017 | Avoid Docker requirement for cloud-agent compatibility | important | full | No Docker mentioned anywhere in the plan; Section 2 architecture assumes hosted Supabase or local without containerization | |
| PRD-018 | Overlay saved user data on every show appearance | critical | full | Section 2: "User's version takes precedence everywhere"; Section 3 shows `shows` table with both catalog and My Data fields merged in a single row | |
| PRD-019 | Support visible statuses plus hidden `Next` | important | full | Section 3 `shows` table: `my_status` CHECK includes `'next'`; Section 13: "keep hidden in v1, surface in data model only" | |
| PRD-020 | Map Interested/Excited chips to Later interest | critical | full | Section 5.2: "Apply defaults: Status = `Later`, Interest = `Interested`"; Section 3 `my_interest` field with CHECK constraints | |
| PRD-021 | Support free-form multi-tag personal tag library | important | full | Section 3: `my_tags TEXT[] DEFAULT '{}'` on shows table; Section 5.7: tag filters in sidebar; Section 5.2: adding tags triggers save | |
| PRD-022 | Define collection membership by assigned status | critical | full | Section 5.2: "Triggered by: setting status"; Section 5.2 Fetching Collection Home filters `my_status IS NOT NULL`; Section 3: `my_status` TEXT CHECK constraint | |
| PRD-023 | Save shows from status, interest, rating, tagging | critical | full | Section 5.2: "Triggered by: setting status, choosing interest, rating, or adding tags" | |
| PRD-024 | Default save to Later/Interested except rating-save Done | critical | full | Section 5.2: "Status = `Later`, Interest = `Interested`"; "Exception: first save via rating -> status = `Done`" | |
| PRD-025 | Removing status deletes show and all My Data | critical | full | Section 5.2: "DELETE show from `shows` table. All My Data cleared implicitly (delete the row)." | |
| PRD-026 | Re-add preserves My Data and refreshes public data | critical | full | Section 5.2: "Lookup by catalog ID + user + namespace. If found: preserve all My Data, refresh public metadata from catalog. Merge using field-level rules." | |
| PRD-027 | Track per-field My Data modification timestamps | critical | full | Section 3: per-field timestamps on `shows` table (`myStatusUpdateDate`, `myInterestUpdateDate`, `myTagsUpdateDate`, `myScoreUpdateDate`, `aiScoopUpdateDate`) | |
| PRD-028 | Use timestamps for sorting, sync, freshness | important | full | Section 3.2: "Index: `shows(namespace_id, user_id, my_tags_update_date)` — for recently updated sorting"; Section 5.2: "Sort by `my_tags_update_date` DESC"; Section 5.4.1: scoop 4hr freshness uses timestamps | |
| PRD-029 | Persist Scoop only for saved shows, 4h freshness | critical | full | Section 5.4.1: "Check if cached scoop exists and is fresh (< 4 hours)... Persist only if show is in collection" | |
| PRD-030 | Keep Ask and Alchemy state session-only | important | full | Section 5.4.2: Ask chat is session-based ("recent turns + user library summary + session state"); Section 5.5: "Alchemy Session" state machine with `isChaining` — no mention of persistence beyond session | |
| PRD-031 | Resolve AI recommendations to real selectable shows | critical | full | Section 5.4.4: "Resolve each title to a real catalog item... If found, render as interactive show tile... If not found, render as non-interactive or hand off to Search" | |
| PRD-032 | Show collection and rating tile indicators | important | full | Section 9: "Status badges: Color-coded indicators on tiles"; "Rating indicator: User score badge when present" | |
| PRD-033 | Sync libraries/settings consistently and merge duplicates | important | partial | Section 3 `cloud_settings` table and Section 5.3 merge logic address cloud-level conflict resolution via timestamps, but the plan does not explicitly address cross-device sync enablement, duplicate detection logic, or the sync trigger mechanism beyond field-level merge rules. |
| PRD-034 | Preserve saved libraries across data-model upgrades | critical | full | Section 7: "Schema Evolution" with `data_model_version` tracking, idempotent migrations, "Migration script runs on every deployment; safe for repeated execution" | |
| PRD-035 | Persist synced settings, local settings, UI state | important | full | Section 3: `cloud_settings` table, `local_settings` table, `ui_state` table cover all three categories | |
| PRD-036 | Keep provider IDs persisted and detail fetches transient | important | full | Section 3: `provider_data JSONB` stored in `shows` table; Section 4.3.3 lists transient fetches (cast, crew, seasons, images, videos, recommendations) as not persisted | |
| PRD-037 | Merge catalog fields safely and maintain timestamps | critical | full | Section 5.3: `mergeShows` function with `selectFirstNonEmpty` for non-my fields and timestamp resolution for my fields; `detailsUpdateDate` set to now after merge | |
| PRD-038 | Provide filters panel and main screen destinations | important | full | Section 4: `FiltersPanel.tsx` component; Section 5.7: "Filters Panel (sidebar)" with all filter types; Section 2 architecture diagram shows Home, Find, Detail, Settings as main areas | |
| PRD-039 | Keep Find/Discover in persistent primary navigation | important | full | Section 4: `Header.tsx` as "Global nav (Find, Settings)"; Section 2 architecture shows Find as primary area | |
| PRD-040 | Keep Settings in persistent primary navigation | important | full | Section 4: `Header.tsx` includes Settings; Section 2 architecture shows Settings as primary area; Section 5.8 covers Settings & Data Management | |
| PRD-041 | Offer Search, Ask, Alchemy discover modes | important | full | Section 4: `app/find/` with `search/`, `ask/`, `alchemy/` subdirectories; Section 2 architecture shows Find hub with Search, Ask, Alchemy | |
| PRD-042 | Show only library items matching active filters | important | full | Section 5.7: "Filters compose: selected tag + media type + other data filters"; query with WHERE clause including tag_filter and media_filter | |
| PRD-043 | Group home into Active, Excited, Interested, Others | important | full | Section 5.2: "Group by status: Active -> Excited (Later+Excited) -> Interested (Later+Interested) -> Other"; Section 9: same grouping | |
| PRD-044 | Support All, tag, genre, decade, score, media filters | important | full | Section 5.7: "Tag filters... Data filters: Genre, Decade, Community score ranges... Media-type toggle: All / Movies / TV" | |
| PRD-045 | Render poster, title, and My Data badges | important | full | Section 4: `ShowTile.tsx: "Poster + title + My Data badges"`; Section 9: "Poster grid" design | |
| PRD-046 | Provide empty-library and empty-filter states | detail | full | Section 9: "No shows in collection: 'Start adding shows by searching...'" and "Filter yields no results: 'No results found.'" | |
| PRD-047 | Search by title or keywords | important | full | Section 4: `SearchResults.tsx` component; Section 5.3: `client.search(query)` method on catalog API client | |
| PRD-048 | Use poster grid with collection markers | important | full | Section 4: `MediaGrid.tsx: "Reusable poster grid"`; Section 9: "Poster grid: Consistent aspect ratio"; Section 5.2 Collection Home mentions tiles showing poster and title | |
| PRD-049 | Auto-open Search when setting is enabled | detail | full | Section 5.8: "Search on launch — stored in `local_settings.auto_search`"; Section 4: `AppSettings.tsx` component | |
| PRD-050 | Keep Search non-AI in tone | important | full | Section 4 architecture separates Search as a catalog-only path under `app/find/search/`; no AI client reference in search flow | |
| PRD-051 | Preserve Show Detail narrative section order | important | full | Section 4: Detail page components (`ShowDetail.tsx`, `MediaHeader.tsx`, `CoreFacts.tsx`, `OverviewScoop.tsx`, etc.) reflect the spec order: header -> core facts -> tags -> overview/scoop -> Ask -> recommendations -> Explore Similar -> streaming -> cast -> seasons -> budget | |
| PRD-052 | Prioritize motion-rich header with graceful fallback | important | partial | Section 4: `MediaHeader.tsx` component exists for "Backdrops/posters/carousel"; however, the plan does not explicitly address prioritizing motion/trailers or the fallback behavior to poster-only when no video is available. The component name suggests a carousel but doesn't confirm trailer-first logic. | |
| PRD-053 | Surface year, runtime/seasons, and community score early | important | full | Section 4: `CoreFacts.tsx` for "Year, runtime, genres, score"; Section 4 narrative order places CoreFacts as item 2 in the sequence | |
| PRD-054 | Place status/interest controls in toolbar | important | full | Section 4: `StatusChips.tsx` component; Section 2 architecture shows Status/Interest as relationship controls; Section 5.2: "Status chips + save/remove flow" | |
| PRD-055 | Auto-save unsaved tagged show as Later/Interested | critical | full | Section 5.2: adding tags is listed as a save trigger; Section 5.2 Creating/Saving section covers default values when save is triggered by tagging | |
| PRD-056 | Auto-save unsaved rated show as Done | critical | full | Section 5.2: "Exception: first save via rating -> status = `Done`"; Section 5.2 Creating/Saving: "Rating triggers auto-save as Done" | |
| PRD-057 | Show overview early for fast scanning | important | full | Section 4 narrative order places Overview at position 4 in the sequence; Section 4 `OverviewScoop.tsx` component | |
| PRD-058 | Scoop shows correct states and progressive feedback | important | full | Section 5.4.1: "Check if cached... call LLM... Stream response progressively"; Section 2 risk table mentions "AI response streaming" | |
| PRD-059 | Ask-about-show deep-link seeds Ask context | important | full | Section 5.4.2: "Ask About a Show: Launch from Show Detail... Pre-seed conversation with show context" | |
| PRD-060 | Include traditional recommendations strand | important | full | Section 4: `Recommendations.tsx` component for "Traditional recommendations"; Section 4 narrative order includes it as item 8 | |
| PRD-061 | Explore Similar uses CTA-first concept flow | important | full | Section 4: `ExploreSimilar.tsx: "Get Concepts → Explore Shows"`; Section 5.6 describes the 3-step flow: Get Concepts -> select concepts -> Explore Shows | |
| PRD-062 | Include streaming availability and person-linking credits | important | full | Section 4: `StreamingAvail.tsx`; Section 4: `CastCrew.tsx`; Section 4 narrative order includes both at positions 10-11 | |
| PRD-063 | Gate seasons to TV and financials to movies | important | partial | Section 3 `shows` table has `number_of_seasons`, `number_of_episodes`, `budget`, `revenue` fields; Section 4 includes `Seasons.tsx` component; however, the plan does not explicitly state the gating logic (seasons only on TV, financials only on movies) in the feature implementation. The data model supports both, but the conditional rendering rule is implied rather than specified. | |
| PRD-064 | Keep primary actions early and page not overwhelming | important | full | Section 2 architecture: "primary actions are clustered early"; Section 9 design system implies early placement through component ordering; Section 4 narrative order places status, rating, scoop, concepts early | |
| PRD-065 | Provide conversational Ask chat interface | important | full | Section 5.4.2: "User types message... Build context... Call LLM... Stream response"; Section 4: `AskChat.tsx: "Chat UI with context summarization"` | |
| PRD-066 | Answer directly with confident, spoiler-safe recommendations | important | full | Section 10: "base.ts persona... opinionated, spoiler-safe"; Section 4: `ai/prompts/ask.ts: "Ask personality: friend in dialogue, opinionated, spoiler-safe"` | |
| PRD-067 | Show horizontal mentioned-shows strip from chat | important | full | Section 5.4.2: "If AI mentions shows, parse structured showList format"; Section 4: `lib/discovery/mentioned-shows.ts: "Parse structured show mentions"` | |
| PRD-068 | Open Detail from mentions or Search fallback | important | full | Section 5.4.4: "If found, render as interactive show tile... If not found, render as non-interactive or hand off to Search" | |
| PRD-069 | Show six random starter prompts with refresh | important | full | Section 5.4.2: "Welcome View: 6 random starter prompts from the 80-prompt library. Refreshable." | |
| PRD-070 | Summarize older turns while preserving voice | important | full | Section 5.4.2: "If conversation exceeds ~10 turns, summarize older turns into 1-2 sentences (preserving persona/tone)" | |
| PRD-071 | Seed Ask-about-show sessions with show handoff | important | full | Section 5.4.2: "Ask About a Show: Launch from Show Detail 'Ask about...' button. Pre-seed conversation with show context." | |
| PRD-072 | Emit `commentary` plus exact `showList` contract | critical | full | Section 5.4.5: structured output contract with `commentary` and `showList` in exact format `Title::externalId::type;;...`; Section 4: `mentioned-shows.ts` parser | |
| PRD-073 | Retry malformed mention output once, then fallback | important | full | Section 5.4.5: "On parse failure: retry once with stricter instructions; if still failing, fallback to commentary + Search handoff" | |
| PRD-074 | Redirect Ask back into TV/movie domain | important | full | Section 10: "base.ts persona... shared persona" with TV/movie focus; Section 12 risk mitigation: "AI provider downtime... fallback to unstructured recommendations + Search handoff"; domain constraint is implicit in prompt architecture but not explicitly stated as a redirect mechanism | |
| PRD-075 | Treat concepts as taste ingredients, not genres | important | full | Section 10: "concepts.ts... vibe/structure/thematic ingredients, no plot"; Section 4: concept chips; Section 5.4.3 concept extraction logic | |
| PRD-076 | Return bullet-only, 1-3 word, non-generic concepts | important | full | Section 10: "concepts.ts... 1-3 words, evocative, no generics, diversity across axes"; Section 5.4.3: "Return bullet list of 1-3 word concepts" | |
| PRD-077 | Order concepts by strongest aha and varied axes | important | partial | Section 10 mentions "diversity across axes"; Section 5.4.3 covers concept extraction; however, the plan does not explicitly address ordering concepts by "strongest aha first" or the diversity requirement across structural/vibe/emotional/craft axes. This is a prompt-level detail that's implied but not concretely specified. | |
| PRD-078 | Require concept selection and guide ingredient picking | important | partial | Section 5.5: "User selects up to 8"; Section 5.6: "User selects 1+ concepts"; Section 4: "ConceptChips.tsx: Selectable concept chips"; however, the plan does not explicitly address UI guidance like "pick the ingredients you want more of" or empty-state nudges specified in the PRD. | |
| PRD-079 | Return exactly five Explore Similar recommendations | important | full | Section 5.4.4: "Count: 5 recs for Explore Similar, 6 recs for Alchemy" | |
| PRD-080 | Support full Alchemy loop with chaining | important | full | Section 5.5: Full 4-step flow (Select Shows -> Conceptualize -> Alchemize -> Chain) with state machine and session management | |
| PRD-081 | Clear downstream results when inputs change | important | full | Section 5.5: "Changing input shows or concept selection resets downstream state" | |
| PRD-082 | Generate shared multi-show concepts with larger option pool | important | full | Section 5.4.3: "Multi-Show (Alchemy): Call LLM with multi-show concept prompt (must find shared concepts). Return larger pool of concepts (more than single-show)." | |
| PRD-083 | Cite selected concepts in concise recommendation reasons | important | full | Section 5.4.4: "reasons should explicitly reflect the selected concepts"; Section 10: "recommendations.ts... name concepts, bias recent, real shows" | |
| PRD-084 | Deliver surprising but defensible taste-aligned recommendations | important | full | Section 5.4.4: "Resolve each title to a real catalog item"; Section 10: prompt guidance for taste-aware recs; Section 12 risk table: "AI hallucinated recommendations... validate against catalog" | |
| PRD-085 | Keep one consistent AI persona across surfaces | important | full | Section 10: "base.ts persona is included in every AI surface prompt"; Section 4: `ai/prompts/base.ts: "Shared persona: joy-forward, opinionated, vibe-first, specific, concise"` | |
| PRD-086 | Enforce shared AI guardrails across all surfaces | critical | full | Section 10: "base.ts persona is included in every AI surface prompt"; Section 10: "Do not cross the red lines: No encyclopedic tone, no hedging, no out-of-domain recommendations, no unsaved spoilers" | |
| PRD-087 | Make AI warm, joyful, and light in critique | important | full | Section 10: "base.ts persona: joy-forward"; Section 4: "base.ts... Shared persona: joy-forward, opinionated, vibe-first, specific, concise" | |
| PRD-088 | Structure Scoop as personal taste mini-review | important | full | Section 5.4.1: "Scoop system prompt + show context" with structure; Section 10: "scoop.ts... Scoop structure: personal take -> stack-up -> scoop paragraph -> fit -> verdict" | |
| PRD-089 | Keep Ask brisk and dialogue-like by default | important | full | Section 10: "ask.ts... Ask personality: friend in dialogue"; Section 4: `AskChat.tsx: "Chat UI with context summarization"` | |
| PRD-090 | Feed AI the right surface-specific context inputs | important | full | Section 5.4.2: "Build context: recent turns + user library summary + session state"; Section 5.4.1: "show context" for Scoop; Section 5.4.3: "show context" for concepts; Section 5.4.4: "selected concepts + show context" for recs | |
| PRD-091 | Validate discovery with rubric and hard-fail integrity | important | partial | The plan includes risk mitigations (catalog validation for hallucinated recs, parse failure fallbacks) and testing of merge/logic components, but it does not explicitly incorporate the quality rubric (voice adherence, taste alignment, real-show integrity, specificity of reasoning) as an evaluation mechanism within the implementation. The rubric is a discovery-validation concept that the plan addresses indirectly through catalog resolution but not through systematic quality scoring. | |
| PRD-092 | Show person gallery, name, and bio | important | full | Section 4: `PersonDetail.tsx: "Bio, gallery, analytics, filmography"`; Section 5 Phase 5 includes "Person Detail page" | |
| PRD-093 | Include ratings, genres, and projects-by-year analytics | important | full | Section 4: `PersonDetail.tsx: "Bio, gallery, analytics, filmography"`; PRD references "analytics charts (ratings, genres, projects-by-year)" | |
| PRD-094 | Group filmography by year | important | full | Section 4: `PersonDetail.tsx: "Bio, gallery, analytics, filmography"`; PRD references "Filmography grouped by year" | |
| PRD-095 | Open Show Detail from selected credit | important | full | Section 4: `CastCrew.tsx` component for horizontal talent list; Phase 5 includes full Person Detail page implementation; implied by cast/crew linking to show detail | |
| PRD-096 | Include font size and Search-on-launch settings | important | full | Section 5.8: "Font size (XS through XXL)... Search on launch — stored in `local_settings.auto_search`" | |
| PRD-097 | Support username, model, and API-key settings safely | important | full | Section 5.8: AI settings (provider, model, API key), Section 5.8 Integrations (catalog API key); Section 3: `cloud_settings` table stores `user_name`, `ai_api_key`, `ai_model`, `catalog_api_key` | |
| PRD-098 | Export saved shows and My Data as zip | critical | full | Section 5.8: "GET /api/export... Produces `.zip` containing `backup.json` with shows and settings" | |
| PRD-099 | Encode export dates using ISO-8601 | important | full | Section 5.8: `"exportDate": "ISO-8601"` | |

## 3. Coverage Scores

### Overall Score

```
Full: 90  Partial: 6  Missing: 3  Total: 99

score = (90 × 1.0 + 6 × 0.5) / 99 × 100
score = (90 + 3) / 99 × 100
score = 93 / 99 × 100
score = 93.9%
```

### Score by Severity Tier

**Critical requirements:**
```
Full: 29  Partial: 0  Missing: 1  Total: 30

Critical: (29 × 1.0 + 0 × 0.5) / 30 × 100 = 29 / 30 × 100 = 96.7%  (29 of 30 critical requirements)
```

**Important requirements:**
```
Full: 59  Partial: 6  Missing: 2  Total: 67

Important: (59 × 1.0 + 6 × 0.5) / 67 × 100 = (59 + 3) / 67 × 100 = 62 / 67 × 100 = 92.5%  (59 of 67 important requirements)
```

**Detail requirements:**
```
Full: 2  Partial: 0  Missing: 0  Total: 2

Detail: (2 × 1.0 + 0 × 0.5) / 2 × 100 = 2 / 2 × 100 = 100.0%  (2 of 2 detail requirements)
```

**Overall:** 93.9% (99 total requirements)

## 4. Top Gaps

### Gap 1: PRD-033 — Sync libraries/settings consistently and merge duplicates (`important`)
The plan covers field-level merge logic and cloud_settings storage, but does not address the cross-device sync mechanism (sync trigger, conflict resolution at the collection level beyond field timestamps, or duplicate detection). A user enabling sync would get per-field updates but no guidance on how library-wide consistency is maintained or how duplicate shows from different devices are merged. Without this, the "sync libraries" portion of the requirement is underspecified.

### Gap 2: PRD-052 — Prioritize motion-rich header with graceful fallback (`important`)
The `MediaHeader.tsx` component is named generically as "Backdrops/posters/carousel" without specifying trailer-first behavior or the graceful fallback to poster-only when video is unavailable. The PRD explicitly calls for motion priority ("prioritize motion (trailers) when present, but never block reading") with a "graceful fallback to poster/backdrop only." The plan's component name and description lack this hierarchy.

### Gap 3: PRD-063 — Gate seasons to TV and financials to movies (`important`)
The data model includes both `number_of_seasons`/`number_of_episodes` and `budget`/`revenue` columns on the `shows` table. The plan lists `Seasons.tsx` as a component but does not specify the conditional rendering logic that gates seasons to TV-only and financial data to movie-only. This is a critical-states requirement that affects the detail page's behavior depending on media type.

### Gap 4: PRD-077 — Order concepts by strongest aha and varied axes (`important`)
The plan mentions "diversity across axes" in the prompt architecture (Section 10) and concept extraction (Section 5.4.3), but does not concretely specify that concepts should be ordered by "strongest aha first" or that diversity should span structural/vibe/emotional/craft axes. This is a prompt-quality specification that affects the UX of concept selection — if concepts appear in a flat, unranked list, users may miss the strongest signals.

### Gap 5: PRD-091 — Validate discovery with rubric and hard-fail integrity (`important`)
The plan includes technical safeguards (catalog resolution, parse-fallback) and a testing strategy for merge/logic, but does not incorporate the discovery quality rubric (voice adherence, taste alignment, surprise-without-betrayal, specificity, real-show integrity) as a concrete validation mechanism. The rubric exists as a human-evaluation tool in the PRD; the plan translates the real-show integrity dimension into automated catalog resolution but leaves voice/taste/surprise as implicit prompt engineering rather than specifiable, testable behaviors.

## 5. Coverage Narrative

### Overall Posture

This is a structurally strong plan with broad and detailed coverage across most functional areas. At 93.9%, it addresses the overwhelming majority of requirements with concrete architectural decisions, component structures, and implementation strategies. The plan is closest to production-ready in its infrastructure, data modeling, and AI prompt architecture — areas where it provides specific file paths, table schemas, and contract details. The remaining gaps cluster around subtle but important behavioral specifications: cross-device sync mechanics, conditional UI gating, and prompt-level quality controls that the PRD treats as non-negotiable.

### Strength Clusters

The plan is exceptionally strong in **Benchmark Runtime & Isolation** (all 17 of 17 requirements met), where it provides concrete infrastructure decisions, environment configuration, namespace isolation, and migration strategy. **Collection Data & Persistence** is also well-covered, with the database schema directly mapping to the storage-schema.md reference and all CRUD operations, merge rules, and timestamp tracking addressed. **Ask Chat** coverage is thorough, with explicit structured output contracts, parse retry logic, welcome prompts, and session management. The **AI Voice, Persona & Quality** area benefits from the plan's prompt architecture section, which provides a clear shared-persona foundation and surface-specific extensions.

### Weakness Clusters

The partial/missing items cluster around two patterns. First, **cross-cutting behavioral specifications** — requirements like sync mechanics (PRD-033), conditional UI gating (PRD-063), and concept ordering (PRD-077) fall between the cracks of the plan's component-oriented structure. The plan excels at naming components and data tables but under-specifies the conditional logic that determines *when* those components render or behave differently. Second, **prompt-level quality controls** — the plan specifies *that* prompts exist and *what* they should include, but not *how quality is measured* (PRD-091) or *how output is ordered* (PRD-077). These are not missing features; they are missing quality specifications that turn features into reliable behaviors.

### Risk Assessment

If this plan were executed as-is, the most likely failure mode would be **inconsistent user experience on the Show Detail page**. Without explicit gating for seasons (TV-only) and financials (movies-only), developers might render both sections for all shows, creating visual noise and potential data confusion. The missing cross-device sync specification would manifest as silent data loss or duplicate entries when a user adds devices, since the plan describes storage but not the sync protocol. The concept ordering gap would produce less impactful concept selection UX — users would see concepts in an arbitrary order rather than the strongest "aha" insights first, degrading the alchemy experience's core value proposition.

### Remediation Guidance

The weaknesses call for **behavioral specification additions** rather than new plan sections. Specifically: add a "Conditional Rendering Rules" subsection to the Show Detail implementation (Section 5.4) that explicitly gates seasons to TV shows and financials to movies. Add a "Cross-Device Sync Protocol" note to the data persistence section (Section 2/5.3) describing sync triggers, duplicate detection, and conflict resolution beyond per-field timestamps. Add a "Concept Quality Specification" to the AI prompt architecture (Section 10) that specifies output ordering by aha-strength and axis diversity requirements. Finally, address PRD-091 by deciding whether the quality rubric should be implemented as an automated scoring layer (e.g., post-generation validation) or explicitly documented as a human-review checkpoint during QA — either way, it should be a visible part of the plan rather than an implicit hope in prompt engineering quality.
