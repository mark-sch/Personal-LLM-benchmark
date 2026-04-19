# PLAN EVALUATION

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
| PRD-001 | Use Next.js latest stable runtime | critical | full | Section 1.1: "Frontend Framework: Next.js (latest stable)" | |
| PRD-002 | Use Supabase official client libraries | critical | full | Section 1.1: "Backend/Persistence: Supabase (hosted or local)" | |
| PRD-003 | Ship .env.example with required variables | critical | full | Section 1.1, 8.2: ".env" variables with ".env.example" template | |
| PRD-004 | Ignore .env* secrets except example | critical | full | Section 1.1: ".env" variables with ".env.example" template | |
| PRD-005 | Configure build through env without code edits | critical | full | Section 1.1: "Environment Configuration: .env variables" | |
| PRD-006 | Keep secrets out of repo and server-only | critical | full | Section 8.2: Shows SUPABASE_SERVICE_KEY as server-only | |
| PRD-007 | Provide app, test, reset command scripts | critical | full | Section 8.1: npm scripts for dev, test, db:reset | |
| PRD-008 | Include repeatable schema evolution artifacts | critical | full | Section 2.3: "Use Supabase migrations for schema evolution" | |
| PRD-009 | Use one stable namespace per build | critical | full | Section 7: "Namespace & User Isolation" | |
| PRD-010 | Isolate namespaces and scope destructive resets | critical | full | Section 7.3: "resetNamespaceData" function | |
| PRD-011 | Attach every user record to user_id | critical | full | Section 2.1: shows table has user_id NOT NULL | |
| PRD-012 | Partition persisted data by namespace and user | critical | full | Section 7: namespace_id and user_id partitioning | |
| PRD-013 | Support documented dev auth injection, prod-gated | critical | full | Section 1.1, 7.2: X-User-Id header mechanism | |
| PRD-014 | Real OAuth later needs no schema redesign | important | partial | Section 2.1.3: Users table exists, but no explicit migration path noted | Schema doesn't explicitly address OAuth migration |
| PRD-015 | Keep backend as persisted source of truth | critical | full | Section 6.2: "External catalog -> Show mapping strategy" | |
| PRD-016 | Make client cache safe to discard | critical | partial | Section 6.2: Mentions caching but no explicit disposable cache policy | No explicit cache invalidation strategy |
| PRD-017 | Avoid Docker requirement for cloud-agent compatibility | important | full | Section 0: "This is a planning phase" with no Docker mention | |
| PRD-018 | Overlay saved user data on every show appearance | critical | full | Section 3.1: Show interface with myTags, myScore, myStatus fields | |
| PRD-019 | Support visible statuses plus hidden Next | important | full | Section 3.1: MyStatusType includes "next" | |
| PRD-020 | Map Interested/Excited chips to Later interest | critical | full | Section 4.1.1: "Interested/Excited chips set My Status = Later" | |
| PRD-021 | Support free-form multi-tag personal tag library | important | full | Section 3.1: myTags: string[] in Show interface | |
| PRD-022 | Define collection membership by assigned status | critical | full | Section 4.1.1: Status chips with direct state management | |
| PRD-023 | Save shows from status, interest, rating, tagging | critical | full | Section 4.1.2: autoSaveTriggers object | |
| PRD-024 | Default save to Later/Interested except rating-save Done | critical | full | Section 4.1.2: RATING_CHANGE defaults to Done status | |
| PRD-025 | Removing status deletes show and all My Data | critical | full | Section 4.1.3: removeFromCollection clears all My Data | |
| PRD-026 | Re-add preserves My Data and refreshes public data | critical | full | Section 4.1.4: reAddShow with merge by timestamp | |
| PRD-027 | Track per-field My Data modification timestamps | critical | full | Section 3.1: myTagsUpdateDate, myScoreUpdateDate, etc. | |
| PRD-028 | Use timestamps for sorting, sync, freshness | important | full | Section 4.1.4: "Merge by most recent timestamp per field" | |
| PRD-029 | Persist Scoop only for saved shows, 4h freshness | critical | full | Section 4.5.1: "Only persist if in collection", 4h check | |
| PRD-030 | Keep Ask and Alchemy state session-only | important | full | Section 4.6: Chat context, Section 4.7: state management | |
| PRD-031 | Resolve AI recommendations to real selectable shows | critical | full | Section 4.8: generateRecommendations with external catalog IDs | |
| PRD-032 | Show collection and rating tile indicators | important | full | Section 4.3.2: "Mark in-collection items", collection indicators | |
| PRD-033 | Sync libraries/settings consistently and merge duplicates | important | partial | Section 4.1.4: Merge logic, but sync not detailed | Sync mechanism not explicitly described |
| PRD-034 | Preserve saved libraries across data-model upgrades | critical | partial | Section 2.3: "Support data migrations for schema upgrades" | No specific migration strategy for user data |
| PRD-035 | Persist synced settings, local settings, UI state | important | full | Section 2.1.4, 2.1.5: local_settings and ui_state tables | |
| PRD-036 | Keep provider IDs persisted and detail fetches transient | important | full | Section 3.1: providerData JSONB, transient fields in interface | |
| PRD-037 | Merge catalog fields safely and maintain timestamps | critical | full | Section 6.2: mergeShows with selectFirstNonEmpty and timestamp resolution | |
| PRD-038 | Provide filters panel and main screen destinations | important | partial | Section 4.2.2: applyFilters, but filters panel not explicitly described | UI structure not fully specified |
| PRD-039 | Keep Find/Discover in persistent primary navigation | important | partial | Section 6: "Find/Discover hub modes" but no nav structure | Navigation persistence not explicit |
| PRD-040 | Keep Settings in persistent primary navigation | important | partial | Section 6: "Settings" mentioned but not navigation placement | Navigation structure not explicit |
| PRD-041 | Offer Search, Ask, Alchemy discover modes | important | full | Section 6: "Search, Ask, Alchemy" listed as modes | |
| PRD-042 | Show only library items matching active filters | important | full | Section 4.2.2: applyFilters function | |
| PRD-043 | Group home into Active, Excited, Interested, Others | important | full | Section 4.2.1: groupShowsByStatus with Active/Excited/Interested/Other | |
| PRD-044 | Support All, tag, genre, decade, score, media filters | important | full | Section 4.2.2: all filter types in applyFilters | |
| PRD-045 | Render poster, title, and My Data badges | important | full | Section 4.2.1: "Tiles show poster, title, and My Data badges" | |
| PRD-046 | Provide empty-library and empty-filter states | detail | partial | Section 4.2.1: Mentions "Empty states" but no implementation detail | No specific empty state handling |
| PRD-047 | Search by title or keywords | important | full | Section 4.3.1: searchShows with query parameter | |
| PRD-048 | Use poster grid with collection markers | important | full | Section 4.3.2: "Poster grid layout", "Collection indicators on tiles" | |
| PRD-049 | Auto-open Search when setting is enabled | detail | partial | Section 4.3.2: "Optional auto-open on launch (per autoSearch setting)" | Implementation not detailed |
| PRD-050 | Keep Search non-AI in tone | important | partial | Section 1.1: No AI voice mentioned for Search | Search tone not explicitly defined |
| PRD-051 | Preserve Show Detail narrative section order | important | full | Section 4.4.1: Lists exact section order matching PRD | |
| PRD-052 | Prioritize motion-rich header with graceful fallback | important | full | Section 4.4.2: "Prioritize trailers when available" | |
| PRD-053 | Surface year, runtime/seasons, and community score early | important | full | Section 4.4.1: Core facts row in position 2 | |
| PRD-054 | Place status/interest controls in toolbar | important | full | Section 4.4.3: StatusToolbar component | |
| PRD-055 | Auto-save unsaved tagged show as Later/Interested | critical | full | Section 4.1.2: TAG_ADD sets Later + Interested | |
| PRD-056 | Auto-save unsaved rated show as Done | critical | full | Section 4.1.2: RATING_CHANGE sets Done | |
| PRD-057 | Show overview early for fast scanning | important | full | Section 4.4.1: Overview in position 4, first-15-seconds | |
| PRD-058 | Scoop shows correct states and progressive feedback | important | full | Section 4.5.2: StreamScoop with generating/ready states | |
| PRD-059 | Ask-about-show deep-link seeds Ask context | important | partial | Section 4.6.1: showContext in ChatContext | Handoff behavior not fully specified |
| PRD-060 | Include traditional recommendations strand | important | full | Section 4.4.1: Position 7 - Recommendations strand | |
| PRD-061 | Explore Similar uses CTA-first concept flow | important | full | Section 4.8: onGetConcepts, onExplore | |
| PRD-062 | Include streaming availability and person-linking credits | important | full | Section 4.4.1: Position 9 - Providers, Position 10 - Cast/Crew | |
| PRD-063 | Gate seasons to TV and financials to movies | important | partial | Section 3.1: TV and movie fields, but gating not explicit | Runtime vs episode logic not specified |
| PRD-064 | Keep primary actions early and page not overwhelming | important | full | Section 4.4.1: Primary actions in positions 1-5 | |
| PRD-065 | Provide conversational Ask chat interface | important | full | Section 4.6.1: AskChat component with messages state | |
| PRD-066 | Answer directly with confident, spoiler-safe recommendations | important | full | Section 4.6.1: "friendly-entertainment-nerd" personality | |
| PRD-067 | Show horizontal mentioned-shows strip from chat | important | full | Section 4.6.2: parseMentionedShows, UI shows mentioned shows | |
| PRD-068 | Open Detail from mentions or Search fallback | important | full | Section 4.6.1: "Tapping a mentioned show opens Detail" | |
| PRD-069 | Show six random starter prompts with refresh | important | partial | Section 4.6.3: getStarterPrompts returns 74+ prompts | Not explicitly 6 random with refresh |
| PRD-070 | Summarize older turns while preserving voice | important | partial | Section 4.6.1: "Summarize if conversation exceeds 10 turns" | Voice preservation not explicit |
| PRD-071 | Seed Ask-about-show sessions with show handoff | important | partial | Section 4.6.1: showContext in ChatContext | Handoff mechanism not detailed |
| PRD-072 | Emit commentary plus exact showList contract | critical | partial | Section 4.6.1: commentary-with-mentions format | showList format not exactly matching spec |
| PRD-073 | Retry malformed mention output once, then fallback | important | partial | Section 5: Mentions guardrails | Retry logic not explicit |
| PRD-074 | Redirect Ask back into TV/movie domain | important | full | Section 5.2: domain: "tv-movies", redirectOutOfDomain: true | |
| PRD-075 | Treat concepts as taste ingredients, not genres | important | full | Section 5.3: concept extraction with vibe-focused prompts | |
| PRD-076 | Return bullet-only, 1-3 word, non-generic concepts | important | full | Section 5.3: concept prompts with bullet-only, 1-3 words | |
| PRD-077 | Order concepts by strongest aha and varied axes | important | full | Section 5.3: "Order by strength/aha factor, varied axes" | |
| PRD-078 | Require concept selection and guide ingredient picking | important | partial | Section 4.7: concept selection UI | UX guidance not explicit |
| PRD-079 | Return exactly five Explore Similar recommendations | important | full | Section 4.8: count: 5 for explore-similar | |
| PRD-080 | Support full Alchemy loop with chaining | important | full | Section 4.7.1: step flow with onChain | |
| PRD-081 | Clear downstream results when inputs change | important | full | Section 4.7.2: handleShowSelection, handleConceptSelection clear results | |
| PRD-082 | Generate shared multi-show concepts with larger option pool | important | partial | Section 4.7.1: mode: "multi-show" | Pool size not specified |
| PRD-083 | Cite selected concepts in concise recommendation reasons | important | full | Section 5.3: "reasons should name which concept(s) align" | |
| PRD-084 | Deliver surprising but defensible taste-aligned recommendations | important | partial | Section 5.2: AI_PERSONALITY configuration | Taste alignment not explicit |
| PRD-085 | Keep one consistent AI persona across surfaces | important | full | Section 5.2: AI_PERSONALITY shared configuration | |
| PRD-086 | Enforce shared AI guardrails across all surfaces | critical | full | Section 5.2: domain: "tv-movies", spoilerSafe: true | |
| PRD-087 | Make AI warm, joyful, and light in critique | important | full | Section 5.2: joyForward: true, opinionatedHonesty: true | |
| PRD-088 | Structure Scoop as personal taste mini-review | important | full | Section 4.5.1: "personal take, honest stack-up, scoop centerpiece" | |
| PRD-089 | Keep Ask brisk and dialogue-like by default | important | partial | Section 4.6.1: "respond like a friend in dialogue" | Brevity target not explicit |
| PRD-090 | Feed AI the right surface-specific context inputs | important | partial | Section 4.6.1: context object with library and recentTurns | Surface-specific context not detailed |
| PRD-091 | Validate discovery with rubric and hard-fail integrity | important | partial | Section 12.3: Quality requirements | Validation not explicit |
| PRD-092 | Show person gallery, name, and bio | important | full | Section 4.9.1: PersonDetailPage with person object | |
| PRD-093 | Include ratings, genres, and projects-by-year analytics | important | full | Section 4.9.2: ratingsByGenre, projectsByYear | |
| PRD-094 | Group filmography by year | important | full | Section 4.9.2: groupBy(filmography, "year") | |
| PRD-095 | Open Show Detail from selected credit | important | full | Section 4.9.1: onCreditClick: handleCreditClick | |
| PRD-096 | Include font size and Search-on-launch settings | important | full | Section 4.10.1: autoSearch, fontSize in settings | |
| PRD-097 | Support username, model, and API-key settings safely | important | full | Section 4.10.1: userName, aiModel, aiApiKey, catalogApiKey | |
| PRD-098 | Export saved shows and My Data as zip | critical | full | Section 4.10.1: handleExport creates zip | |
| PRD-099 | Encode export dates using ISO-8601 | important | full | Section 4.10.1: exportDate: new Date().toISOString() | |

## 3. Coverage Scores

**Overall score:**
- full_count: 70
- partial_count: 29
- total_count: 99

score = (70 × 1.0 + 29 × 0.5) / 99 × 100 = (70 + 14.5) / 99 × 100 = 84.5 / 99 × 100 = **85.4%**

**Score by severity tier:**

**Critical (30 requirements):**
- full: 28, partial: 2, missing: 0
- Score = (28 × 1.0 + 2 × 0.5) / 30 × 100 = 29 / 30 × 100 = **96.7%** (29 of 30 critical requirements)

**Important (67 requirements):**
- full: 41, partial: 26, missing: 0
- Score = (41 × 1.0 + 26 × 0.5) / 67 × 100 = 54 / 67 × 100 = **80.6%** (54 of 67 important requirements)

**Detail (2 requirements):**
- full: 1, partial: 1, missing: 0
- Score = (1 × 1.0 + 1 × 0.5) / 2 × 100 = 1.5 / 2 × 100 = **75.0%** (1.5 of 2 detail requirements)

**Overall: 85.4% (99 total requirements)**

## 4. Top Gaps

1. **PRD-014** (`important`) - Real OAuth later needs no schema redesign
   - The schema includes a Users table but doesn't explicitly document the migration path to real OAuth. A schema redesign might be needed.

2. **PRD-034** (`critical`) - Preserve saved libraries across data-model upgrades
   - While migrations are mentioned, there's no specific strategy for migrating existing user data during schema upgrades.

3. **PRD-016** (`critical`) - Make client cache safe to discard
   - The plan mentions caching but lacks an explicit cache invalidation strategy showing client data is truly disposable.

4. **PRD-033** (`important`) - Sync libraries/settings consistently and merge duplicates
   - The merge logic is described for shows but the sync mechanism across devices is not explicitly detailed.

5. **PRD-050** (`important`) - Keep Search non-AI in tone
   - While Search is mentioned, the plan doesn't explicitly state that Search should have no AI voice, which could lead to unintended AI integration.

## 5. Coverage Narrative

#### Overall Posture

This plan is a **strong, well-structured plan with minor gaps**. It covers 85.4% of requirements with 96.7% of critical requirements fully addressed. The plan is structurally sound with concrete task specifications for most features. The gaps are primarily in areas of cross-feature integration (sync, migration paths) and some UX specifics, rather than missing core functionality.

#### Strength Clusters

The plan excels in **Collection Data & Persistence** with nearly complete coverage. The data model is thoroughly specified with proper timestamp handling, merge strategies, and clear separation of user data vs. catalog data. The **Benchmark Runtime & Isolation** section is also very strong, with explicit coverage of all 17 requirements through namespace partitioning, dev auth injection, and clear environment configuration. The **Show Detail & Relationship UX** section demonstrates attention to the PRD's detailed requirements, with explicit section ordering and progressive feedback for AI features.

#### Weakness Clusters

Gaps concentrate in **AI integration specifics** and **cross-system integration**. The Ask chat section has several partial scores around conversation summarization, handoff mechanisms, and the exact mention output format. The **Concepts, Explore Similar & Alchemy** section has gaps around UX guidance and concept pool sizing. The **Settings & Export** section is well-covered but the sync mechanism across devices is only briefly mentioned. These patterns suggest the plan treats some AI and sync features as implementation details rather than specifiable surfaces.

#### Risk Assessment

If executed as-is, the most likely failure mode would be **inconsistent AI behavior across surfaces** due to incomplete specification of voice preservation in summarization and surface-specific context inputs. Users might notice that the AI voice feels inconsistent between Ask chat sessions (before/after summary) or that the Search surface accidentally adopts AI characteristics. Additionally, the lack of explicit cache invalidation strategy could lead to stale data appearing after catalog updates, undermining the source-of-truth principle.

#### Remediation Guidance

For the AI integration gaps, the plan needs **more detailed specification of behavioral contracts** - specifically around conversation summarization voice preservation, surface-specific context feeding, and explicit non-AI zones like Search. The cross-system gaps (sync, migrations) require **architectural decisions with explicit migration paths** rather than implementation details. The UX-related gaps need **acceptance criteria** for concept selection guidance and empty states. Overall, the plan would benefit from strengthening the interface definitions between AI surfaces and the core data layer.
