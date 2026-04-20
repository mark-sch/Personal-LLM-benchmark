# Plan Evaluation — PLAN.md

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

---

## 2. Coverage Table

| PRD-ID | Requirement | Severity | Coverage | Evidence | Gap |
| ------ | ----------- | -------- | -------- | -------- | --- |
| PRD-001 | Use Next.js latest stable runtime | critical | full | §1.1 Technology Stack: "Next.js (latest stable)" | |
| PRD-002 | Use Supabase official client libraries | critical | full | §1.1 "Supabase (hosted preferred)", §4.4 "@supabase/supabase-js" | |
| PRD-003 | Ship .env.example with required variables | critical | full | §4.1 step 3: complete .env.example listed with all variables | |
| PRD-004 | Ignore .env* secrets except example | important | full | §4.1 step 4: "Configure .gitignore to exclude .env* (except .env.example)" | |
| PRD-005 | Configure build through env without code edits | critical | full | §4.1 step 3: all config via env vars; §8 success checklist confirms | |
| PRD-006 | Keep secrets out of repo and server-only | critical | full | §1.3 decision 2: "AI calls are server-side only"; §5.4 security: "API keys server-only, never exposed to client" | |
| PRD-007 | Provide app, test, reset command scripts | critical | full | §4.1 step 5: dev, build, test, test:e2e, test:reset, db:migrate, db:seed scripts | |
| PRD-008 | Include repeatable schema evolution artifacts | critical | full | §3.3 Migrations: numbered SQL files with runner; §4.2: 001_initial, 002_rls, 003_indexes | |
| PRD-009 | Use one stable namespace per build | critical | full | §1.3 decision 3: namespace+user_id partitioning; §4.3: NAMESPACE_ID from env | |
| PRD-010 | Isolate namespaces and scope destructive resets | critical | full | §4.27 step 4: test:reset deletes only matching namespace_id + is_test; §3.2 RLS policies | |
| PRD-011 | Attach every user record to user_id | critical | full | §3.1: all tables include user_id column; §1.3 decision 3 | |
| PRD-012 | Partition persisted data by namespace and user | critical | full | §3.1: primary keys are (namespace_id, user_id, id); §5.1: all queries scoped | |
| PRD-013 | Support documented dev auth injection, prod-gated | important | full | §4.3: X-User-Id header in dev; §5.4: gated behind NEXT_PUBLIC_APP_ENV=development | |
| PRD-014 | Real OAuth later needs no schema redesign | important | full | §5.1: "Replace the dev identity resolver with an OAuth session reader… No schema redesign needed" | |
| PRD-015 | Keep backend as persisted source of truth | critical | full | §1.3 decision 1: "All mutations go through Next.js API routes → Supabase" | |
| PRD-016 | Make client cache safe to discard | critical | full | §1.2: React Query for caching; §5.3: stale-while-revalidate; backend is source of truth | |
| PRD-017 | Avoid Docker requirement for cloud-agent compatibility | important | partial | §1.1: "Supabase (hosted preferred)" implies hosted path | Does not explicitly state Docker MUST NOT be required; only implies preference for hosted |
| PRD-018 | Overlay saved user data on every show appearance | critical | full | §4.7 Get single show: "Fetch from DB if exists (user-overlay version)" | |
| PRD-019 | Support visible statuses plus hidden Next | important | partial | §3.1 shows table: my_status enum includes "next"; §4.9 StatusChips lists only Active/Interested/Excited/Done/Quit/Wait | Next is in the data model but not explicitly addressed as a hidden status in UI chips |
| PRD-020 | Map Interested/Excited chips to Later interest | critical | full | §4.9: "Handles the Interested/Excited → Later+Interest mapping"; §4.12 step 3 | |
| PRD-021 | Support free-form multi-tag personal tag library | important | full | §4.24 step 3: "Tag library: Dynamically built from all my_tags"; TagPicker with autocomplete | |
| PRD-022 | Define collection membership by assigned status | critical | full | §4.7: all save triggers result in status assignment; collection queries by (namespace_id, user_id) | |
| PRD-023 | Save shows from status, interest, rating, tagging | critical | full | §4.7: explicitly lists all four saving triggers with behavior | |
| PRD-024 | Default save to Later/Interested except rating-save Done | critical | full | §4.7: "Rating unsaved show → save with status=Done"; tag → "status=Later, interest=Interested" | |
| PRD-025 | Removing status deletes show and all My Data | critical | full | §4.7 Remove show: "Delete row from shows table"; §4.12 step 3: clears all My Data | |
| PRD-026 | Re-add preserves My Data and refreshes public data | critical | full | §4.7: merge policy with timestamp-based conflict resolution; catalog refresh on re-add | |
| PRD-027 | Track per-field My Data modification timestamps | critical | full | §3.1 shows table: my_tags/my_score/my_status/my_interest/ai_scoop _update_date columns | |
| PRD-028 | Use timestamps for sorting, sync, freshness | important | partial | §4.26: timestamps for sync conflict resolution; §4.20: scoop freshness check | Does not explicitly mention sorting by timestamps (e.g., recently updated shows first) |
| PRD-029 | Persist Scoop only for saved shows, 4h freshness | critical | full | §4.20: "Only persist to DB if show is in user's collection"; regeneration after > 4 hours | |
| PRD-030 | Keep Ask and Alchemy state session-only | important | partial | §4.15 Ask: client-side chat state; §4.16 Alchemy: client session state | Does not explicitly state that leaving/resetting Ask clears state, or that Alchemy results are cleared on exit |
| PRD-031 | Resolve AI recommendations to real selectable shows | critical | full | §4.23: external ID lookup in TMDB; §5.2: fallback to non-interactive display or Search | |
| PRD-032 | Show collection and rating tile indicators | important | full | §4.9: "ShowTile — poster image + title + in-collection badge + rating badge" | |
| PRD-033 | Sync libraries/settings consistently and merge duplicates | important | partial | §4.26: field-level timestamps for conflict resolution; §3.1: cloud_settings synced | Does not detail a sync protocol, duplicate detection algorithm, or merge strategy across devices |
| PRD-034 | Preserve saved libraries across data-model upgrades | critical | full | §4.26: migrations are additive and non-destructive; dataModelVersion gating; user data preserved | |
| PRD-035 | Persist synced settings, local settings, UI state | important | full | §3.1: cloud_settings table; §4.18: local settings via useLocalSettings; §4.24: lastSelectedFilter stored | |
| PRD-036 | Keep provider IDs persisted and detail fetches transient | important | full | §3.1: provider_data jsonb column persisted; §4.6: credits/seasons/videos as transient fetches | |
| PRD-037 | Merge catalog fields safely and maintain timestamps | critical | full | §4.7: selectFirstNonEmpty for non-my fields; timestamp for my fields; §4.8 merge-show.ts | |
| PRD-038 | Provide filters panel and main screen destinations | important | full | §4.11: FilterSidebar + main content area; layout described with left sidebar | |
| PRD-039 | Keep Find/Discover in persistent primary navigation | important | partial | §4.13: Find/Discover hub at /find route | Does not explicitly describe a persistent navigation element (e.g., bottom bar, sidebar link) that is always visible across all pages |
| PRD-040 | Keep Settings in persistent primary navigation | important | partial | §4.18: Settings page at /settings | Same as PRD-039: no explicit persistent navigation element described |
| PRD-041 | Offer Search, Ask, Alchemy discover modes | important | full | §4.13: "Mode switcher at top: Search \| Ask \| Alchemy" | |
| PRD-042 | Show only library items matching active filters | important | full | §4.7: filtering by my_status, genre, decade, score, my_tags, show_type; §4.11: filter-driven display | |
| PRD-043 | Group home into Active, Excited, Interested, Others | important | full | §4.11: explicit sections — Active, Excited, Interested, Other (collapsed) | |
| PRD-044 | Support All, tag, genre, decade, score, media filters | important | full | §4.24: all, myTag, genre, decade, communityScore, myStatus + media type toggle | |
| PRD-045 | Render poster, title, and My Data badges | important | full | §4.9: "ShowTile — poster image + title + in-collection badge + rating badge" | |
| PRD-046 | Provide empty-library and empty-filter states | detail | full | §4.11: "No collection → prompt to Search/Ask"; "Filter yields nothing → 'No results found.'" | |
| PRD-047 | Search by title or keywords | important | full | §4.14: "Text input for title/keyword search"; multi-search endpoint | |
| PRD-048 | Use poster grid with collection markers | important | full | §4.14: "Results displayed as poster grid via ShowTile"; "In-collection items show badge" | |
| PRD-049 | Auto-open Search when setting is enabled | detail | full | §4.14: "Auto-open on launch if autoSearch setting is true" | |
| PRD-050 | Keep Search non-AI in tone | important | partial | §4.14 describes Search as straightforward catalog search proxy | Does not explicitly state the Search surface should have no AI voice/persona applied; implied by omission but not stated as a design constraint |
| PRD-051 | Preserve Show Detail narrative section order | important | full | §4.12: features listed 1–15 matching the narrative hierarchy from detail_page_experience.md | |
| PRD-052 | Prioritize motion-rich header with graceful fallback | important | full | §4.12 step 1: "Carousel of backdrops, posters, logos, and inline trailer playback"; "Graceful fallback to poster-only" | |
| PRD-053 | Surface year, runtime/seasons, and community score early | important | full | §4.12 step 2: "Year, runtime or seasons/episodes, community score bar" | |
| PRD-054 | Place status/interest controls in toolbar | important | full | §4.12 step 3: "StatusControls (toolbar)" | |
| PRD-055 | Auto-save unsaved tagged show as Later/Interested | critical | full | §4.12 step 5: "Adding tag to unsaved show auto-saves as Later + Interested" | |
| PRD-056 | Auto-save unsaved rated show as Done | critical | full | §4.12 step 4: "Rating an unsaved show auto-saves as Done" | |
| PRD-057 | Show overview early for fast scanning | important | full | §4.12 step 6: Overview listed before scoop and discovery sections | |
| PRD-058 | Scoop shows correct states and progressive feedback | important | full | §4.12 step 7: toggle states "Give me the scoop!"/"Show the scoop"/"The Scoop"; streams progressively | |
| PRD-059 | Ask-about-show deep-link seeds Ask context | important | full | §4.12 step 8: "'Ask about this show' CTA — Navigates to Find → Ask with show context seeded" | |
| PRD-060 | Include traditional recommendations strand | important | full | §4.12 step 10: "Recommendations — Horizontal strand of similar/recommended shows from catalog" | |
| PRD-061 | Explore Similar uses CTA-first concept flow | important | full | §4.12 step 11: "Get Concepts" → select → "Explore Shows" three-step flow | |
| PRD-062 | Include streaming availability and person-linking credits | important | full | §4.12 step 12: StreamingProviders; step 13: CastCrew → Person Detail | |
| PRD-063 | Gate seasons to TV and financials to movies | important | full | §4.12 step 14: "SeasonsSection (TV only)"; step 15: "BudgetRevenue (movies only)" | |
| PRD-064 | Keep primary actions early and page not overwhelming | important | partial | §4.12: primary actions listed first; §5.3: lazy loading for below-fold | Does not explicitly address visual density management or busyness reduction beyond section ordering |
| PRD-065 | Provide conversational Ask chat interface | important | full | §4.15: Chat UI with user/assistant message bubbles; useAskChat hook | |
| PRD-066 | Answer directly with confident, spoiler-safe recommendations | important | partial | §4.21: persona and taste-aware prompt design | Does not specify "direct answer within first 3–5 lines" or confident pick behavior explicitly |
| PRD-067 | Show horizontal mentioned-shows strip from chat | important | full | §4.15: "Mentioned shows strip: Horizontal row of show tiles parsed from AI output's showList" | |
| PRD-068 | Open Detail from mentions or Search fallback | important | full | §4.15: "Tapping a mentioned show → navigates to /show/[id] or falls back to Search" | |
| PRD-069 | Show six random starter prompts with refresh | important | full | §4.15: "6 random starter prompts from a curated list of 80, with refresh button" | |
| PRD-070 | Summarize older turns while preserving voice | important | full | §4.15: "after ~10 messages, older turns summarized server-side (1–2 sentences, preserving persona tone)" | |
| PRD-071 | Seed Ask-about-show sessions with show handoff | important | full | §4.15: "Ask About a Show: navigated from Show Detail. Seeds showContext with current show data" | |
| PRD-072 | Emit commentary plus exact showList contract | critical | full | §4.15: response format { commentary, showList }; format "Title::externalId::mediaType;;..." | |
| PRD-073 | Retry malformed mention output once, then fallback | important | full | §4.21: "If showList parsing fails, retry once with stricter formatting; otherwise show commentary + Search handoff" | |
| PRD-074 | Redirect Ask back into TV/movie domain | important | partial | §4.19: shared inputs include library context; §4.21 prompt design | Does not explicitly state the TV/movie domain-redirection guardrail as a system rule for Ask |
| PRD-075 | Treat concepts as taste ingredients, not genres | important | partial | §4.22: "1-3 word evocative concepts"; "avoids generic concepts" | Does not articulate the taste-ingredient philosophy or why concepts differ fundamentally from genres |
| PRD-076 | Return bullet-only, 1-3 word, non-generic concepts | important | full | §4.22: "short bullet list of 1–3 word evocative concepts"; "avoids generic concepts ('good characters,' 'great story')" | |
| PRD-077 | Order concepts by strongest aha and varied axes | important | partial | §4.22: "8 concepts" default count | Does not specify ordering by "aha" strength or diversification across structure/vibe/emotion axes |
| PRD-078 | Require concept selection and guide ingredient picking | important | full | §4.12 step 11: concept chips → user selects 1+; §4.16 step 3: select 1–8; "pick the ingredients" copy | |
| PRD-079 | Return exactly five Explore Similar recommendations | important | full | §4.12 step 11: "Displays 5 recommended shows"; §4.23: count=5 for Explore | |
| PRD-080 | Support full Alchemy loop with chaining | important | full | §4.16: full 5-step wizard; step 6: "'More Alchemy!' button returns to Step 1 with results as inputs" | |
| PRD-081 | Clear downstream results when inputs change | important | full | §4.16: "changing shows clears concepts and results" | |
| PRD-082 | Generate shared multi-show concepts with larger option pool | important | partial | §4.16 step 2: concepts with type "multi"; §4.22: multi-show concepts "shared commonality" | Does not specify that multi-show should return a larger option pool than single-show |
| PRD-083 | Cite selected concepts in concise recommendation reasons | important | full | §4.16 step 5: "Each reason names which concepts align"; §4.23: "reasons must explicitly reference selected concepts" | |
| PRD-084 | Deliver surprising but defensible taste-aligned recommendations | important | partial | §4.23: recommendations grounded in concepts and library; external ID resolution | Does not address the "surprise without betrayal" quality bar or taste-alignment testing strategy |
| PRD-085 | Keep one consistent AI persona across surfaces | important | partial | §4.20: "same persona"; §4.21: "same persona, conversational tone" | No single persona definition that all services reference; each service has its own prompt section |
| PRD-086 | Enforce shared AI guardrails across all surfaces | critical | partial | §5.2: mentions structured output fallback; §4.19: shared inputs assembly | Does not enumerate the shared guardrails (spoiler-safe, TV/movie domain, opinionated honesty, actionable recs) as cross-cutting rules |
| PRD-087 | Make AI warm, joyful, and light in critique | important | partial | §4.20: persona as "fun, chatty TV/movie nerd friend" | Does not propagate joy-forward and warmth pillars to Ask, Concepts, or Recommendations explicitly |
| PRD-088 | Structure Scoop as personal taste mini-review | important | full | §4.20: "personal take → honest stack-up → 'The Scoop' → fit/warnings → verdict" | |
| PRD-089 | Keep Ask brisk and dialogue-like by default | important | partial | §4.21: "conversational tone"; "taste-aware" | Does not specify "1–3 tight paragraphs then list" length target or dialogue-first default |
| PRD-090 | Feed AI the right surface-specific context inputs | important | full | §4.19: lists all shared inputs — library, show context, concepts, conversation turns | |
| PRD-091 | Validate discovery with rubric and hard-fail integrity | important | missing | none | No mention of a scoring rubric, quality validation, or hard-fail integrity checks for AI outputs; no golden set or regression testing for AI quality |
| PRD-092 | Show person gallery, name, and bio | important | full | §4.17: "Image gallery (profile photos), name, bio" | |
| PRD-093 | Include ratings, genres, and projects-by-year analytics | important | full | §4.17: PersonAnalytics — "Average rating", "Top genres breakdown", "Projects by year histogram" | |
| PRD-094 | Group filmography by year | important | full | §4.17: "Credits grouped by year, sorted by recency" | |
| PRD-095 | Open Show Detail from selected credit | important | full | §4.17: "Each credit is a ShowTile → navigates to /show/[id]" | |
| PRD-096 | Include font size and Search-on-launch settings | important | full | §4.18: "Font size selector (XS–XXL)"; "'Search on Launch' toggle" | |
| PRD-097 | Support username, model, and API-key settings safely | important | full | §4.18: Username editor; AI API key input (server-stored); model selector; §5.4: never committed | |
| PRD-098 | Export saved shows and My Data as zip | critical | full | §4.25: GET /api/export; .zip via archiver; JSON of all saved shows + My Data | |
| PRD-099 | Encode export dates using ISO-8601 | important | full | §4.25: "Dates encoded ISO-8601" | |

---

## 3. Coverage Scores

**By severity tier:**

```
Critical:  (29 × 1.0 + 1 × 0.5) / 30 × 100 = 98.3%  (29.5 of 30 critical requirements)
Important: (48 × 1.0 + 18 × 0.5) / 67 × 100 = 85.1%  (57 of 67 important requirements)
Detail:    (2 × 1.0 + 0 × 0.5) / 2 × 100   = 100.0%  (2 of 2 detail requirements)
Overall:   88.4% (99 total requirements)
```

**Overall score:**

```
score = (79 × 1.0 + 19 × 0.5) / 99 × 100 = 88.4%
```

**Breakdown:**
- Full: 79
- Partial: 19
- Missing: 1

---

## 4. Top Gaps

### 1. PRD-086 | `critical` | Enforce shared AI guardrails across all surfaces

The plan mentions shared inputs and individual service prompts but does not codify the four shared guardrails — spoiler-safe defaults, TV/movie domain boundary, opinionated honesty, and actionable recommendations — as a cross-cutting rule set applied to every AI surface. Without this, individual AI services could drift from the product's behavioral contract, producing generic, spoiler-heavy, or off-domain responses that erode user trust in the app's "heart."

### 2. PRD-091 | `important` | Validate discovery with rubric and hard-fail integrity

The plan includes no mechanism for validating AI output quality. The PRD specifies a scoring rubric (voice adherence, taste alignment, surprise, specificity, real-show integrity) with a hard-fail threshold on real-show integrity (= 2, non-negotiable). Without this, hallucinated show titles, wrong external IDs, or off-brand AI responses could reach users with no automated check to catch them.

### 3. PRD-085 | `important` | Keep one consistent AI persona across surfaces

Each AI service section defines its own prompt in isolation. There is no single persona definition that all services reference or import. This risks tonal inconsistency where Ask feels like a chatbot while Scoop reads like a critic, breaking the "one consistent persona" contract that makes the app feel like talking to one friend, not four different tools.

### 4. PRD-066 | `important` | Answer directly with confident, spoiler-safe recommendations

The Ask prompt design lacks specificity about response structure. The PRD requires a direct answer within 3–5 lines, confident picks (willing to pick favorites), and bulleted lists for multi-recommendations. Without these constraints, Ask responses could default to verbose, hedging essays that bury the recommendation a user came for.

### 5. PRD-033 | `important` | Sync libraries/settings consistently and merge duplicates

The plan mentions field-level timestamps for conflict resolution but does not describe a sync protocol, duplicate detection algorithm, or merge strategy across devices. The PRD requires that the library and settings remain consistent across devices with conflicts resolved per field and duplicate items merged transparently. Without this specification, cross-device users could encounter data loss, conflicting states, or duplicate entries.

---

## 5. Coverage Narrative

### Overall Posture

This is a structurally strong plan that addresses the vast majority of requirements with concrete, implementable specifications. The infrastructure and data layers are thorough — namespace isolation, merge policies, timestamp tracking, and schema evolution are all well-specified. The plan's primary weakness is not in what it builds but in how it governs AI behavior: the AI voice, guardrails, and quality validation are described at the service level rather than codified as cross-cutting contracts. A stakeholder should feel confident about the app's data integrity and feature completeness, but should flag the AI governance gap as something that needs tightening before AI surfaces ship to users.

### Strength Clusters

The plan is strongest in three areas. **Benchmark Runtime & Isolation** is nearly perfect — every infra-rider requirement is addressed with specific implementation details including middleware, RLS policies, and env-driven configuration. **Collection Data & Persistence** is equally robust, with a detailed merge policy, comprehensive timestamp tracking, and a migration strategy that mirrors the PRD's data behaviors precisely. **Show Detail & Relationship UX** closely follows the narrative hierarchy from the detail page experience spec, preserving section order and auto-save semantics. These three areas represent the plan's structural backbone, and they are solid.

### Weakness Clusters

The gaps cluster around **AI Voice, Persona & Quality** — the plan treats AI as an implementation detail distributed across individual services rather than as a specifiable product surface. Eight of the twenty partial/missing items belong to the AI voice, persona, guardrails, and quality cluster (PRD-066, PRD-074, PRD-085, PRD-086, PRD-087, PRD-089, PRD-091, and PRD-084). The plan defines what each AI service does but not how the shared persona, shared guardrails, or quality validation hold them together. A secondary weakness cluster is **App Navigation** — the plan defines routes but does not describe the persistent navigation chrome that keeps Find/Discover and Settings always reachable. These gaps suggest the plan was written with a backend-first mindset where AI personality and navigation ergonomics were deferred as "UI polish."

### Risk Assessment

If executed as-is, the most likely failure mode is **AI tonal drift and quality regression**. Without codified shared guardrails, a persona reference, or a quality rubric, each AI surface will be built with independently authored prompts that gradually diverge. Users would first notice that Ask feels like a different entity than Scoop, then that recommendations are generic or spoiler-heavy, and finally that the app's "heart" — the consistent, opinionated, joyful companion — is missing. A QA reviewer would flag this as a brand consistency issue, not a functional bug. The secondary risk is navigation discoverability — users may struggle to find Settings or return to Find/Discover from deep within Show Detail because the persistent navigation element is unspecified.

### Remediation Guidance

The AI governance gaps require **cross-cutting specification work**: a single shared AI guardrails document or module that all AI services import and enforce, a persona definition referenced by every prompt, and a quality validation rubric applied to AI outputs (at minimum, a hard-fail check on real-show integrity). This is not new feature work — it is architectural contract work that should be completed before Phase 7 (AI Services) begins. The navigation gaps require **layout specification work**: defining the persistent navigation element — sidebar, bottom bar, or top bar — with its always-visible destinations (Home, Find/Discover, Settings) as part of the app shell layout in Phase 3. Both remediation categories are about adding specificity to existing plan sections, not creating entirely new sections.
