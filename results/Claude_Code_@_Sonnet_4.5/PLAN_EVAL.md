### 1. Requirements Extraction

#### Pass 1: Identify Functional Areas

1. Core Show Model & Overlay
2. Collection Behaviors & Data Integrity
3. Navigation, Home, and Filters
4. Search & Ask Discovery
5. Alchemy & Concept Discovery
6. Show Detail Experience
7. Person Detail Exploration
8. Settings & Data Portability
9. AI Voice & Discovery Quality
10. Persistence Schema & Mapping Rules
11. Identity, Isolation, and Data Ownership
12. Repo Deliverables, Test Operations, and Cloud Compatibility

#### Pass 2: Extract Requirements Within Each Area

##### Core Show Model & Overlay
- PRD-001 | `critical` | Show object stores public data plus user overlay | `showbiz_prd.md > 4.1 Show (Movie or TV)`
- PRD-002 | `critical` | Overlay includes status, interest, tags, rating, and Scoop | `showbiz_prd.md > 4.1 Show (Movie or TV)`
- PRD-003 | `critical` | Saved overlayed version displays everywhere a show appears | `showbiz_prd.md > 4.1 Show (Movie or TV)`
- PRD-004 | `critical` | User edits win over refreshed public metadata values | `showbiz_prd.md > 4.1 Show (Movie or TV)`
- PRD-005 | `important` | Status model includes hidden Next alongside core statuses | `showbiz_prd.md > 4.2 Status System (“My Status”)`

##### Collection Behaviors & Data Integrity
- PRD-006 | `critical` | Collection membership equals assigned status on stored show | `showbiz_prd.md > 5.1 Collection Membership`
- PRD-007 | `critical` | Status or interest selection saves unsaved show entries | `showbiz_prd.md > 5.2 Saving Triggers`
- PRD-008 | `critical` | Rating unsaved show auto-saves with Done status default | `showbiz_prd.md > 5.2 Saving Triggers`
- PRD-009 | `critical` | Tagging unsaved show auto-saves Later and Interested values | `showbiz_prd.md > 5.2 Saving Triggers`
- PRD-010 | `important` | Statusless save defaults to Later with Interested interest | `showbiz_prd.md > 5.3 Default Values When Saving`
- PRD-011 | `critical` | Reselecting active status confirms and removes from collection | `showbiz_prd.md > 5.4 Removing from Collection`
- PRD-012 | `critical` | Removal clears all My Data including persisted Scoop | `showbiz_prd.md > 5.4 Removing from Collection`
- PRD-013 | `critical` | Re-adding existing show preserves prior personal data fields | `showbiz_prd.md > 5.5 Re-adding the Same Show`
- PRD-014 | `critical` | Conflict resolution uses newest timestamp per mutable field | `showbiz_prd.md > 5.5 Re-adding the Same Show`
- PRD-015 | `critical` | Every My field tracks dedicated last-update timestamp | `showbiz_prd.md > 5.6 Timestamps`
- PRD-016 | `important` | Scoop persists but Ask, Alchemy, mentions remain session-only | `showbiz_prd.md > 5.7 AI Data Persistence`
- PRD-017 | `important` | Tiles show in-collection and user-rating badge indicators | `showbiz_prd.md > 5.9 Tile Indicators`
- PRD-018 | `important` | Sync mode keeps data consistent and merges duplicates | `showbiz_prd.md > 5.10 Data Sync & Integrity`
- PRD-019 | `critical` | Data-model upgrades preserve all user libraries automatically | `showbiz_prd.md > 5.11 Data Continuity Across Versions`

##### Navigation, Home, and Filters
- PRD-020 | `important` | App shell includes filters panel and main content area | `showbiz_prd.md > 6. App Structure & Navigation`
- PRD-021 | `important` | Primary nav always exposes Find and Settings entrypoints | `showbiz_prd.md > 6. App Structure & Navigation`
- PRD-022 | `critical` | Find hub supports Search, Ask, Alchemy with mode switch | `showbiz_prd.md > 6. App Structure & Navigation`
- PRD-023 | `important` | Home groups statuses with Active prominent and Later split | `showbiz_prd.md > 7.1 Collection Home`
- PRD-024 | `important` | Media-type toggle applies All, Movies, TV on top filters | `showbiz_prd.md > 7.1 Collection Home`
- PRD-025 | `important` | Filters include tags, no-tags, genre, decade, score ranges | `showbiz_prd.md > 4.5 Filters (Ways to View the Collection)`
- PRD-026 | `detail` | Home has empty-library and empty-filter state messaging | `showbiz_prd.md > 7.1 Collection Home`
- PRD-027 | `detail` | Home tiles show poster, title, and My Data badges | `showbiz_prd.md > 7.1 Collection Home`

##### Search & Ask Discovery
- PRD-028 | `critical` | Search supports title and keyword catalog lookup queries | `showbiz_prd.md > 7.2 Search (Find → Search)`
- PRD-029 | `important` | Search results use poster grid and mark saved shows | `showbiz_prd.md > 7.2 Search (Find → Search)`
- PRD-030 | `critical` | Selecting search result opens Show Detail destination page | `showbiz_prd.md > 7.2 Search (Find → Search)`
- PRD-031 | `detail` | Search optionally auto-opens at launch from user setting | `showbiz_prd.md > 7.2 Search (Find → Search)`
- PRD-032 | `critical` | Ask provides conversational discovery chat with turn history | `showbiz_prd.md > 7.3 Ask (Find → Ask)`
- PRD-033 | `important` | Ask tone stays friendly, honest, spoiler-safe, opinionated | `showbiz_prd.md > 7.3 Ask (Find → Ask)`
- PRD-034 | `critical` | Ask mentions return commentary and machine-readable showList format | `ai_prompting_context.md > 3.2 Ask with Mentions`
- PRD-035 | `important` | Mentioned shows are selectable with fallback Search handoff path | `showbiz_prd.md > 7.3 Ask (Find → Ask)`
- PRD-036 | `detail` | Ask welcome shows six random starter prompts refreshable | `showbiz_prd.md > 7.3 Ask (Find → Ask)`
- PRD-037 | `important` | Ask summarizes older turns while preserving session context | `showbiz_prd.md > 7.3 Ask (Find → Ask)`
- PRD-038 | `important` | Ask-about-show flow seeds chat context from active title | `showbiz_prd.md > 7.3 Ask (Find → Ask)`
- PRD-039 | `important` | Parse failure retries once then safe fallback behavior | `ai_prompting_context.md > 5. Guardrails & Fallbacks`

##### Alchemy & Concept Discovery
- PRD-040 | `critical` | Alchemy requires selecting at least two starting shows | `showbiz_prd.md > 4.7 Alchemy Session`
- PRD-041 | `critical` | Alchemy concept selection is capped at eight chips | `showbiz_prd.md > 4.7 Alchemy Session`
- PRD-042 | `important` | Alchemy returns six recommendations and supports chained rounds | `showbiz_prd.md > 4.7 Alchemy Session`
- PRD-043 | `critical` | Explore Similar uses Get Concepts select Explore Shows flow | `showbiz_prd.md > 4.8 Explore Similar`
- PRD-044 | `critical` | Concepts output bullets only with evocative 1-3 words | `concept_system.md > 4. Generation Rules`
- PRD-045 | `critical` | Multi-show concepts capture commonality shared across all inputs | `concept_system.md > 4. Generation Rules`
- PRD-046 | `important` | Concepts prioritize specificity, diversity, and strongest-first ordering | `concept_system.md > 4. Generation Rules`
- PRD-047 | `important` | Changing concept selections clears downstream recommendation results | `concept_system.md > 5. Selection UX Rules`
- PRD-048 | `important` | Recommendation reasons explicitly tie back to selected concepts | `concept_system.md > 6. Concepts → Recommendations Contract`
- PRD-049 | `important` | Recs count is fixed: Explore five, Alchemy six | `concept_system.md > 6. Concepts → Recommendations Contract`
- PRD-050 | `important` | Unresolved recommendations become non-interactive or Search handoff | `showbiz_prd.md > 5.8 AI Recommendations Map to Real Shows`

##### Show Detail Experience
- PRD-051 | `critical` | Detail unifies facts, personal state, and discovery actions | `showbiz_prd.md > 7.5 Show Detail Page`
- PRD-052 | `important` | Detail sections follow prescribed narrative order and hierarchy | `detail_page_experience.md > 3. Narrative Hierarchy`
- PRD-053 | `important` | Header prioritizes immersive media with graceful asset fallback | `detail_page_experience.md > 3.1 Header Media`
- PRD-054 | `important` | Core facts include year length, score, and My Rating | `detail_page_experience.md > 3.2 Core Facts + Community Score`
- PRD-055 | `critical` | Toolbar status controls include mapped chips and destructive confirm | `detail_page_experience.md > 3.3 My Relationship Controls`
- PRD-056 | `important` | Scoop supports stateful toggle labels, streaming, four-hour refresh | `detail_page_experience.md > 3.4 Overview + Scoop`
- PRD-057 | `important` | Scoop persistence is long-term only for saved collection items | `detail_page_experience.md > 3.4 Overview + Scoop`
- PRD-058 | `important` | Detail includes Ask CTA, recs, explore, streaming, cast blocks | `showbiz_prd.md > 7.5 Show Detail Page`
- PRD-059 | `detail` | Seasons and budget/revenue render conditionally by media type | `showbiz_prd.md > 7.5 Show Detail Page`
- PRD-060 | `important` | Critical detail states cover unsaved, no-media, no-concepts cases | `detail_page_experience.md > 5. Critical States`

##### Person Detail Exploration
- PRD-061 | `important` | Person detail shows gallery, bio, and year-grouped filmography | `showbiz_prd.md > 7.6 Person Detail Page`
- PRD-062 | `detail` | Person detail includes lightweight talent analytics chart section | `showbiz_prd.md > 4.10 Person (Cast/Crew)`
- PRD-063 | `important` | Credit navigation links Show Detail and Person Detail flows | `showbiz_prd.md > 4.10 Person (Cast/Crew)`

##### Settings & Data Portability
- PRD-064 | `important` | Settings expose font size and Search-on-launch controls | `showbiz_prd.md > 7.7 Settings & Your Data`
- PRD-065 | `important` | Settings manage username with sync-compatible persistence model | `showbiz_prd.md > 7.7 Settings & Your Data`
- PRD-066 | `important` | Settings include AI and catalog API credential fields | `showbiz_prd.md > 7.7 Settings & Your Data`
- PRD-067 | `critical` | Secrets are never committed regardless of storage strategy | `showbiz_prd.md > 7.7 Settings & Your Data`
- PRD-068 | `critical` | Export produces zip JSON backup with ISO-8601 dates | `showbiz_prd.md > 7.7 Settings & Your Data`

##### AI Voice & Discovery Quality
- PRD-069 | `important` | AI surfaces share one persona while Search remains non-AI | `ai_voice_personality.md > 1. Persona Summary`
- PRD-070 | `important` | Voice pillars enforce warmth honesty specificity spoiler safety | `ai_voice_personality.md > 2. Non-Negotiable Voice Pillars`
- PRD-071 | `important` | Scoop includes take stack-up fit warnings and verdict sections | `ai_voice_personality.md > 4.1 Scoop`
- PRD-072 | `detail` | Ask answers early and uses lists for multi-recs | `discovery_quality_bar.md > 2.2 Ask / Explore Search Chat`
- PRD-073 | `critical` | Real-show integrity is mandatory for recommendation quality acceptance | `discovery_quality_bar.md > 1.5 Real-Show Integrity`

##### Persistence Schema & Mapping Rules
- PRD-074 | `important` | Persistence includes Show CloudSettings and AppMetadata entities | `storage-schema.md > Stored entities (conceptual)`
- PRD-075 | `important` | Cast seasons videos recs remain transient not persisted fields | `storage-schema.md > Show (movie or TV series)`
- PRD-076 | `detail` | Local persistence stores settings and UI state keys | `storage-schema.md > Other persistent storage (key-value settings)`
- PRD-077 | `important` | Catalog mapping rejects missing title or invalid media identity | `storage-schema.md > Field mapping rules (conceptual)`
- PRD-078 | `critical` | Merge keeps non-empty public fields and newer My fields | `storage-schema.md > Merge / overwrite policy (important)`
- PRD-079 | `important` | Merge updates details timestamp and preserves creation timestamp | `storage-schema.md > Merge / overwrite policy (important)`

##### Identity, Isolation, and Data Ownership
- PRD-080 | `important` | Benchmark baseline requires Next.js runtime and Supabase persistence | `showbiz_infra_rider_prd.md > 2. Benchmark Baseline (Current Round)`
- PRD-081 | `critical` | Persisted records are partitioned by namespace_id and user_id | `showbiz_infra_rider_prd.md > 4. Identity & Isolation Model`
- PRD-082 | `critical` | Namespace isolation blocks cross-run collisions and destructive bleed | `showbiz_infra_rider_prd.md > 4.1 Build/run namespace (required)`
- PRD-083 | `important` | Dev identity injection is documented and gated for production | `showbiz_infra_rider_prd.md > 5.1 Auth is not required to be real`
- PRD-084 | `important` | Future OAuth migration requires no schema redesign changes | `showbiz_infra_rider_prd.md > 5.2 Migration to real OAuth must be straightforward`
- PRD-085 | `critical` | Backend is source of truth and cache is disposable | `showbiz_infra_rider_prd.md > 6. Data Ownership & Local Storage`
- PRD-086 | `critical` | user_id is required opaque stable value for ownership | `showbiz_infra_rider_prd.md > 4.2 User identity (required)`

##### Repo Deliverables, Test Operations, and Cloud Compatibility
- PRD-087 | `critical` | Repo provides env example and gitignore secret protections | `showbiz_infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-088 | `critical` | Build runs from env configuration without source edits | `showbiz_infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-089 | `critical` | Client uses public key and server holds elevated secrets | `showbiz_infra_rider_prd.md > 3.1 Credential handling rules`
- PRD-090 | `important` | One-command workflows exist for dev test and reset | `showbiz_infra_rider_prd.md > 3.2 One-command developer experience`
- PRD-091 | `critical` | Repo includes repeatable migrations for deterministic fresh schema | `showbiz_infra_rider_prd.md > 3.3 Database evolution artifacts`
- PRD-092 | `critical` | Destructive testing resets namespace data without global teardown | `showbiz_infra_rider_prd.md > 7. Destructive Testing Rules`
- PRD-093 | `important` | Docker remains optional and never benchmark run prerequisite | `showbiz_infra_rider_prd.md > 8. Cloud Agent Compatibility`
- PRD-094 | `important` | Cloud-agent path runs tests without privileged container access | `showbiz_infra_rider_prd.md > 8. Cloud Agent Compatibility`

Total: 94 requirements (39 critical, 47 important, 8 detail) across 12 functional areas

### 2. Coverage Table

| PRD-ID | Requirement | Severity | Coverage | Evidence | Gap |
| ------ | ----------- | -------- | -------- | -------- | --- |
| PRD-001 | Show object stores public data plus user overlay | critical | full | Database Schema section defines `{prefix}shows`; Phase 2 adds TMDB mappers into stored Show shape. | |
| PRD-002 | Overlay includes status, interest, tags, rating, and Scoop | critical | full | `{prefix}shows` includes `my_status`, `my_interest`, `my_tags`, `my_score`, `ai_scoop` columns. | |
| PRD-003 | Saved overlayed version displays everywhere a show appears | critical | partial | Plan defines shared components (`ShowTile`, `ShowGrid`, `ShowRow`) and `shows.ts` data layer. | It does not explicitly require overlay precedence on every surface that renders a show. |
| PRD-004 | User edits win over refreshed public metadata values | critical | partial | Key rules mention per-field timestamp updates and conflict resolution fields. | Non-My precedence policy over refreshed catalog data is not explicitly specified as a hard implementation rule. |
| PRD-005 | Status model includes hidden Next alongside core statuses | important | full | Status enum in schema includes `active/next/later/done/quit/wait`. | |
| PRD-006 | Collection membership equals assigned status on stored show | critical | full | Business rules table: “Set myStatus -> Show saved to collection.” | |
| PRD-007 | Status or interest selection saves unsaved show entries | critical | partial | Phase 4 `MyDataControls` and status/interest chips are planned. | Interest-chip-triggered save is not explicitly called out as a required save trigger. |
| PRD-008 | Rating unsaved show auto-saves with Done status default | critical | full | Business rules explicitly include “Rate unsaved show -> Auto-save as done.” | |
| PRD-009 | Tagging unsaved show auto-saves Later and Interested values | critical | full | Business rules explicitly include “Tag unsaved show -> Auto-save as later + interested.” | |
| PRD-010 | Statusless save defaults to Later with Interested interest | important | partial | Plan defines status/interest constants and tag-save default path. | Generic default behavior for all statusless saves is not specified beyond the tag/rating triggers. |
| PRD-011 | Reselecting active status confirms and removes from collection | critical | full | Business rules include reselect removal with confirmation dialog. | |
| PRD-012 | Removal clears all My Data including persisted Scoop | critical | full | Business rules specify remove show and clear all My Data. | |
| PRD-013 | Re-adding existing show preserves prior personal data fields | critical | partial | Data layer includes upsert/get patterns and per-field update timestamps. | Re-add semantics preserving prior My Data across encounters are not explicitly stated. |
| PRD-014 | Conflict resolution uses newest timestamp per mutable field | critical | partial | Plan includes field-level `my_*_update_date` columns and conflict rationale. | It does not describe explicit merge algorithm coverage for all mutable fields and sources. |
| PRD-015 | Every My field tracks dedicated last-update timestamp | critical | full | Schema contains status/interest/score/tags/scoop update timestamp columns plus business rule to set them. | |
| PRD-016 | Scoop persists but Ask, Alchemy, mentions remain session-only | important | partial | Plan implements persistent scoop fields and separate Ask/Alchemy modes. | Session-only clearing behavior for Ask history and mentions is not explicitly planned. |
| PRD-017 | Tiles show in-collection and user-rating badge indicators | important | full | Home phase and shared tile components call out My Data badges. | |
| PRD-018 | Sync mode keeps data consistent and merges duplicates | important | partial | Supabase persistence and conflict timestamp fields are defined. | Duplicate-detection/merge behavior across devices is not described. |
| PRD-019 | Data-model upgrades preserve all user libraries automatically | critical | partial | Plan adds migrations and `app_metadata` version table. | No explicit upgrade migration strategy guarantees preserving existing user data. |
| PRD-020 | App shell includes filters panel and main content area | important | full | Phase 1 includes app layout/navigation shell; page routes are enumerated. | |
| PRD-021 | Primary nav always exposes Find and Settings entrypoints | important | full | Layout/nav shell plus `/find` and `/settings` pages are included. | |
| PRD-022 | Find hub supports Search, Ask, Alchemy with mode switch | critical | full | Phase 5 `Find.tsx` mode switcher and Phase 7/8 mode sub-features. | |
| PRD-023 | Home groups statuses with Active prominent and Later split | important | full | Phase 3 `StatusSection` defines Active, Later(Excited/Interested), Wait, Done, Quit groups. | |
| PRD-024 | Media-type toggle applies All, Movies, TV on top filters | important | full | Phase 3 explicitly includes `MediaTypeToggle` sub-feature. | |
| PRD-025 | Filters include tags, no-tags, genre, decade, score ranges | important | full | Phase 3 `FilterSidebar` includes genre/tag/decade/community score filters. | |
| PRD-026 | Home has empty-library and empty-filter state messaging | detail | partial | Home feature and status grouping are planned. | Empty-state copy/behaviors are not explicitly listed as tasks. |
| PRD-027 | Home tiles show poster, title, and My Data badges | detail | full | Shared tile/grid components and Home behavior include tile badges. | |
| PRD-028 | Search supports title and keyword catalog lookup queries | critical | full | Phase 2 TMDB search client and Phase 5 `useSearch.ts` are planned. | |
| PRD-029 | Search results use poster grid and mark saved shows | important | partial | Shared `ShowGrid` exists; Search mode implementation is planned. | Saved-item marker behavior in Search results is not explicit in task list. |
| PRD-030 | Selecting search result opens Show Detail destination page | critical | partial | Route structure includes `/show/[type]/[id]` and Search mode feature. | Explicit click-through requirement from Search result to Detail is implied, not stated. |
| PRD-031 | Search optionally auto-opens at launch from user setting | detail | full | Settings include `auto-search`; Search mode exists in Find flow. | |
| PRD-032 | Ask provides conversational discovery chat with turn history | critical | full | Phase 7 includes `/api/ai/chat`, `AskMode`, and `useChat.ts`. | |
| PRD-033 | Ask tone stays friendly, honest, spoiler-safe, opinionated | important | partial | AI prompts infrastructure (`lib/ai/prompts.ts`) is planned. | No explicit tone contract tasks or acceptance criteria are included. |
| PRD-034 | Ask mentions return commentary and machine-readable showList format | critical | full | API contract section defines `{commentary, showList}` with required delimiter format. | |
| PRD-035 | Mentioned shows are selectable with fallback Search handoff path | important | partial | Ask mode and structured mention output are planned. | Mentioned-strip UI behavior and fallback interaction are not explicitly specified. |
| PRD-036 | Ask welcome shows six random starter prompts refreshable | detail | missing | None. | No task covers starter prompts, randomization, or refresh interaction. |
| PRD-037 | Ask summarizes older turns while preserving session context | important | partial | `useChat.ts` and AI client infrastructure are planned. | No explicit summarization threshold/strategy is planned. |
| PRD-038 | Ask-about-show flow seeds chat context from active title | important | full | Phase 7 explicitly plans show context seeding via URL params from Detail. | |
| PRD-039 | Parse failure retries once then safe fallback behavior | important | missing | None. | Structured-output retry/fallback handling is not included in API task breakdown. |
| PRD-040 | Alchemy requires selecting at least two starting shows | critical | partial | Phase 8 includes `ShowPicker` and Alchemy flow features. | Minimum input count validation is not explicitly specified. |
| PRD-041 | Alchemy concept selection is capped at eight chips | critical | partial | Phase 8 includes concept and recommendation endpoints and `useAlchemy`. | Selection cap is not called out in implementation tasks. |
| PRD-042 | Alchemy returns six recommendations and supports chained rounds | important | partial | Alchemy mode and recommendation API are planned. | Fixed count and chaining loop behavior are not explicitly specified. |
| PRD-043 | Explore Similar uses Get Concepts select Explore Shows flow | critical | full | Phase 9 adds `ExploreSimilar` with reused concepts/recommendations APIs. | |
| PRD-044 | Concepts output bullets only with evocative 1-3 words | critical | missing | None. | Prompt/output contract for concept shape is not specified in the plan. |
| PRD-045 | Multi-show concepts capture commonality shared across all inputs | critical | partial | Phase 8 concept extraction API and Alchemy mode are included. | Shared-commonality requirement is not explicitly encoded as acceptance criteria. |
| PRD-046 | Concepts prioritize specificity, diversity, and strongest-first ordering | important | missing | None. | No quality constraints are defined for concept generation output quality. |
| PRD-047 | Changing concept selections clears downstream recommendation results | important | missing | None. | State-reset behavior on concept toggles/backtracking is not specified. |
| PRD-048 | Recommendation reasons explicitly tie back to selected concepts | important | partial | Recommendation endpoint and Explore/Alchemy features are planned. | No explicit requirement ensures reasons mention selected concepts directly. |
| PRD-049 | Recs count is fixed: Explore five, Alchemy six | important | missing | None. | Fixed recommendation counts are not documented in tasks or API contracts. |
| PRD-050 | Unresolved recommendations become non-interactive or Search handoff | important | partial | Ask mapping contract exists and Search mode exists. | Failure-path rendering/interaction for unresolved recs is not explicitly planned. |
| PRD-051 | Detail unifies facts, personal state, and discovery actions | critical | full | Phase 4 defines `ShowDetail` plus comprehensive sub-features. | |
| PRD-052 | Detail sections follow prescribed narrative order and hierarchy | important | partial | Phase 4 includes all major detail sub-sections. | Required ordering and narrative hierarchy are not explicitly called out. |
| PRD-053 | Header prioritizes immersive media with graceful asset fallback | important | partial | `HeaderMedia` sub-feature exists in Phase 4. | Fallback rules for missing media assets are not specified. |
| PRD-054 | Core facts include year length, score, and My Rating | important | partial | `CoreFacts` plus rating controls and `RatingBar` components are planned. | Exact composition of facts and score presentation is not explicit. |
| PRD-055 | Toolbar status controls include mapped chips and destructive confirm | critical | full | `MyDataControls` and business rules cover chip mapping, save triggers, and remove confirmation. | |
| PRD-056 | Scoop supports stateful toggle labels, streaming, four-hour refresh | important | full | `ScoopSection` + `useScoop` with 4h expiry and `POST /api/ai/scoop` streaming route. | |
| PRD-057 | Scoop persistence is long-term only for saved collection items | important | partial | Scoop fields are persisted in shows table and hooked to Detail flow. | Unsaved-show ephemeral scoop handling is not explicitly planned. |
| PRD-058 | Detail includes Ask CTA, recs, explore, streaming, cast blocks | important | full | Phase 4 explicitly lists `AskAboutCTA`, `RecommendationsSection`, `ExploreSimilar`, `StreamingSection`, `CastCrew`. | |
| PRD-059 | Seasons and budget/revenue render conditionally by media type | detail | full | Phase 4 includes dedicated `SeasonsSection` and `BudgetRevenue` sub-features. | |
| PRD-060 | Critical detail states cover unsaved, no-media, no-concepts cases | important | partial | Related sections exist (`ScoopSection`, `HeaderMedia`, `ExploreSimilar`). | Explicit critical-state handling requirements are not itemized. |
| PRD-061 | Person detail shows gallery, bio, and year-grouped filmography | important | partial | Phase 10 has `PersonDetail.tsx` with TMDB data and person route. | Gallery/bio/year-grouping behaviors are not explicitly broken out. |
| PRD-062 | Person detail includes lightweight talent analytics chart section | detail | full | Phase 10 explicitly includes `AnalyticsSection` charts sub-feature. | |
| PRD-063 | Credit navigation links Show Detail and Person Detail flows | important | partial | Cast/Crew sections and person routes are present in file structure. | Explicit bidirectional navigation behavior is implied, not specified as tasks. |
| PRD-064 | Settings expose font size and Search-on-launch controls | important | full | Phase 11 settings scope includes font size and auto-search options. | |
| PRD-065 | Settings manage username with sync-compatible persistence model | important | full | Phase 11 includes username and cloud settings CRUD in Phase 2. | |
| PRD-066 | Settings include AI and catalog API credential fields | important | full | Phase 11 includes API keys and model selector; cloud settings schema has key fields. | |
| PRD-067 | Secrets are never committed regardless of storage strategy | critical | partial | `.env.example` and `.env.local (gitignored)` are in planned structure. | Explicit secret-handling policies for user-entered values are not defined as acceptance checks. |
| PRD-068 | Export produces zip JSON backup with ISO-8601 dates | critical | full | Phase 11 includes `utils/export.ts` ZIP export with JSON backup flow. | |
| PRD-069 | AI surfaces share one persona while Search remains non-AI | important | partial | Prompts are centralized in `src/lib/ai/prompts.ts`; Search mode is separate feature. | Persona consistency and explicit Search non-AI boundary are not stated as constraints. |
| PRD-070 | Voice pillars enforce warmth honesty specificity spoiler safety | important | partial | AI infrastructure and prompt builders are present. | No voice-pillar acceptance criteria are defined. |
| PRD-071 | Scoop includes take stack-up fit warnings and verdict sections | important | partial | Scoop feature and streaming API exist in plan. | Required Scoop content structure is not specified. |
| PRD-072 | Ask answers early and uses lists for multi-recs | detail | missing | None. | No UX quality bar for answer placement or formatting is in the plan. |
| PRD-073 | Real-show integrity is mandatory for recommendation quality acceptance | critical | missing | None. | Plan lacks explicit quality-gate/testing criteria enforcing deterministic real-show integrity. |
| PRD-074 | Persistence includes Show CloudSettings and AppMetadata entities | important | full | Database schema defines `{prefix}shows`, `{prefix}cloud_settings`, `{prefix}app_metadata`. | |
| PRD-075 | Cast seasons videos recs remain transient not persisted fields | important | full | Plan explicitly states slim schema and transient TMDB detail fetch policy. | |
| PRD-076 | Local persistence stores settings and UI state keys | detail | partial | File structure includes `useLocalStorage.ts` hook and settings feature. | Specific required local keys (`autoSearch`, `fontSize`, UI state flags) are not specified. |
| PRD-077 | Catalog mapping rejects missing title or invalid media identity | important | partial | TMDB mapper layer is planned (`mappers.ts`). | Validation/rejection behavior for malformed catalog payloads is not explicit. |
| PRD-078 | Merge keeps non-empty public fields and newer My fields | critical | partial | Timestamp-based My-field conflict handling is represented in schema/business rules. | Non-My `selectFirstNonEmpty` merge policy is not captured in plan tasks. |
| PRD-079 | Merge updates details timestamp and preserves creation timestamp | important | partial | Schema includes `created_at` and `updated_at` management columns. | `detailsUpdateDate` and immutable creation timestamp semantics are not specified. |
| PRD-080 | Benchmark baseline requires Next.js runtime and Supabase persistence | important | full | Tech stack section explicitly states Next.js latest stable and Supabase. | |
| PRD-081 | Persisted records are partitioned by namespace_id and user_id | critical | full | Composite PKs include `namespace_id` and `user_id`; `useNamespace.ts` is planned. | |
| PRD-082 | Namespace isolation blocks cross-run collisions and destructive bleed | critical | full | Table prefix resolver, namespace hook, and namespace-scoped reset script are included. | |
| PRD-083 | Dev identity injection is documented and gated for production | important | partial | Env vars include `NEXT_PUBLIC_DEFAULT_USER_ID` and `NEXT_PUBLIC_DEV_USER_SELECTOR`. | Documentation and explicit production gating behavior are not fully planned. |
| PRD-084 | Future OAuth migration requires no schema redesign changes | important | missing | None. | Plan does not state migration-to-OAuth design constraints or compatibility checks. |
| PRD-085 | Backend is source of truth and cache is disposable | critical | partial | Supabase server persistence is primary in architecture and data layer. | Disposable-cache and data-survival semantics are not explicitly defined/tested. |
| PRD-086 | user_id is required opaque stable value for ownership | critical | partial | Namespace/user hook and schema include `user_id` fields. | Opaque-stable user_id semantics are not explicitly documented or validated. |
| PRD-087 | Repo provides env example and gitignore secret protections | critical | partial | Plan includes `.env.example` and `.env.local (gitignored)` in structure. | `.gitignore` secret rules are not explicitly listed as deliverables or checks. |
| PRD-088 | Build runs from env configuration without source edits | critical | partial | Environment variable section is comprehensive and central to setup. | The plan does not explicitly assert no-code-edit bootstrap as an acceptance criterion. |
| PRD-089 | Client uses public key and server holds elevated secrets | critical | full | Separate browser/server Supabase clients and env key split are defined. | |
| PRD-090 | One-command workflows exist for dev test and reset | important | partial | Create-next-app defaults plus Phase 12 reset script and test plan are present. | Explicit command contract for all three workflows is not itemized. |
| PRD-091 | Repo includes repeatable migrations for deterministic fresh schema | critical | full | `supabase/migrations/001_initial_schema.sql` and migration scripts are planned. | |
| PRD-092 | Destructive testing resets namespace data without global teardown | critical | full | `scripts/reset-test-data.js` targets namespace test rows only. | |
| PRD-093 | Docker remains optional and never benchmark run prerequisite | important | partial | Plan targets hosted Supabase and does not require Docker in stack. | Optional-Docker guidance/documentation is not explicitly called out. |
| PRD-094 | Cloud-agent path runs tests without privileged container access | important | missing | None. | Cloud-agent execution constraints are not captured in tasks or validation steps. |

### 3. Coverage Scores

Critical:  (21 × 1.0 + 16 × 0.5) / 39 × 100 = 74.36%  (29.0 of 39 critical requirements)
Important: (16 × 1.0 + 25 × 0.5) / 47 × 100 = 60.64%  (28.5 of 47 important requirements)
Detail:    (4 × 1.0 + 2 × 0.5) / 8 × 100 = 62.50%  (5.0 of 8 detail requirements)
Overall:   (41 × 1.0 + 43 × 0.5) / 94 × 100 = 66.49%  (94 total requirements)

### 4. Top Gaps

1. PRD-073 (`critical`) Real-show integrity is mandatory for recommendation quality acceptance.
   - Why it matters: Without an explicit real-show integrity gate, AI recommendations can ship with hallucinated or mismatched titles, which breaks trust in all discovery surfaces quickly.
2. PRD-044 (`critical`) Concepts output bullets only with evocative 1-3 words.
   - Why it matters: Concept quality is the steering input for Explore Similar and Alchemy; weakly specified concept formatting degrades downstream recommendation relevance and UI consistency.
3. PRD-078 (`critical`) Merge keeps non-empty public fields and newer My fields.
   - Why it matters: Missing non-My merge rules can overwrite valid metadata with empty values during refresh, causing silent data regression and inconsistent detail views.
4. PRD-003 (`critical`) Saved overlayed version displays everywhere a show appears.
   - Why it matters: If overlay precedence is inconsistent by surface, users will see conflicting statuses/ratings across Home, Search, and AI-derived rows.
5. PRD-087 (`critical`) Repo provides env example and gitignore secret protections.
   - Why it matters: Incomplete explicit secret-protection requirements raise real risk of credential leakage during benchmark setup and collaboration.

### 5. Coverage Narrative

The plan is structurally sound and buildable, but not yet spec-complete. Coverage is strongest in core application scaffolding, route architecture, Supabase schema setup, and major feature decomposition. It is not a broken plan, but it has meaningful contract-level holes that will create behavioral drift from the PRD unless filled before implementation proceeds deeply.

The strongest clusters are page and feature topology, persistence plumbing, and major user flows. Collection Home, Show Detail feature decomposition, Find mode partitioning, settings surfaces, namespace/user isolation, migration artifacts, and reset-test tooling are all concretely planned with named files and phase sequencing. This gives high execution confidence for infrastructure and baseline product functionality.

Gaps cluster around behavioral contracts rather than component existence. The plan frequently defines that a feature exists but not the required quality or fallback semantics: AI voice contracts, concept-output constraints, recommendation integrity gates, parse-failure fallback strategy, deterministic merge policy for non-My fields, and explicit overlay precedence across all surfaces. These are mostly not random misses; they are concentrated in AI behavior fidelity and data-consistency edge rules.

If executed as-is, the most likely failure mode is “feature-complete but behavior-inconsistent.” A QA pass would likely first notice that AI outputs vary in style/format, concept quality is unstable, and some recommendation rows are unresolved or mismatched. In parallel, users may encounter inconsistent personal data rendering across surfaces because overlay precedence and merge rules are under-specified.

Remediation work should focus on planning precision, not wholesale re-architecture: add explicit behavioral acceptance criteria for AI outputs and fallbacks, define deterministic merge/precedence contracts (including non-My fields), encode recommendation integrity checks in tests, and expand detail/search/ask UX tasks where the PRD calls for exact states or copy-level interactions. Most missing work is specification hardening and testable contract definition, not additional feature breadth.
