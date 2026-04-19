# Plan Evaluation

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
| PRD-001 | Use Next.js latest stable runtime | critical | full | Section 2 Technology Stack: "Next.js (latest stable, App Router)" | |
| PRD-002 | Use Supabase official client libraries | critical | full | Section 2 Technology Stack: "Supabase (PostgreSQL + PostgREST)" and migration setup | |
| PRD-003 | Ship `.env.example` with required variables | critical | full | Section 13 `.env.example` includes all required variables | |
| PRD-004 | Ignore `.env*` secrets except example | important | full | Section 13 `.gitignore` lists `.env*` and `!.env.example` | |
| PRD-005 | Configure build through env without code edits | critical | full | Success criteria states "Repo runs with `npm install` + env vars only (no code edits)" | |
| PRD-006 | Keep secrets out of repo and server-only | critical | full | Section 13 marks `SUPABASE_SERVICE_ROLE_KEY` as server-only; API keys from env | |
| PRD-007 | Provide app, test, reset command scripts | critical | full | Phase 1 lists `npm run dev`, `npm test`, `npm run test:reset` | |
| PRD-008 | Include repeatable schema evolution artifacts | critical | full | Phase 1: "Set up Supabase client, RLS policies, migrations" and seed scripts | |
| PRD-009 | Use one stable namespace per build | critical | full | Section 4.1 middleware reads `X-Namespace-Id` or `BENCHMARK_NAMESPACE` env | |
| PRD-010 | Isolate namespaces and scope destructive resets | critical | full | Section 4.3: all queries include `(namespace_id, user_id)`; test isolation in Section 12.4 | |
| PRD-011 | Attach every user record to `user_id` | critical | full | Every table schema includes `user_id` with RLS policies | |
| PRD-012 | Partition persisted data by namespace and user | critical | full | Composite unique keys on `(namespace_id, user_id, id)` across tables | |
| PRD-013 | Support documented dev auth injection, prod-gated | important | full | Section 4.1 describes dev middleware with `NODE_ENV=production` gating | |
| PRD-014 | Real OAuth later needs no schema redesign | important | full | Section 4.2 maps OAuth `sub` to existing `users.id` without schema changes | |
| PRD-015 | Keep backend as persisted source of truth | critical | full | Section 8.1: "React Server Components as the default" for server-first data | |
| PRD-016 | Make client cache safe to discard | critical | full | Server-first architecture with success criteria "no data loss on refresh" | |
| PRD-017 | Avoid Docker requirement for cloud-agent compatibility | important | full | Phase 6 success criteria: "Tests pass in isolation without Docker" | |
| PRD-018 | Overlay saved user data on every show appearance | critical | full | Business Rules Checklist: "Display rule: user-overlay version shown everywhere" | |
| PRD-019 | Support visible statuses plus hidden `Next` | important | full | Schema includes `my_status` check with `'next'`; UI groups visible statuses only | |
| PRD-020 | Map Interested/Excited chips to Later interest | critical | full | Section 7.2.2: "Interested/Excited map to Later + Interest" | |
| PRD-021 | Support free-form multi-tag personal tag library | important | full | Schema `my_tags text[]`, sidebar tag filters, and tag picker in Detail | |
| PRD-022 | Define collection membership by assigned status | critical | full | Business Rules Checklist and schema `my_status` presence | |
| PRD-023 | Save shows from status, interest, rating, tagging | critical | full | Business Rules Checklist explicitly lists all four saving triggers | |
| PRD-024 | Default save to Later/Interested except rating-save Done | critical | full | Business Rules Checklist states exact defaults and rating exception | |
| PRD-025 | Removing status deletes show and all My Data | critical | full | Business Rules Checklist: "removes show + all My Data" | |
| PRD-026 | Re-add preserves My Data and refreshes public data | critical | full | Business Rules Checklist: "preserve latest My Data; refresh public metadata; merge by timestamp" | |
| PRD-027 | Track per-field My Data modification timestamps | critical | full | Schema includes `my_*_update_date` for every user field; checklist confirms | |
| PRD-028 | Use timestamps for sorting, sync, freshness | important | partial | Schema has timestamps; merge logic uses them; no explicit UI sorting by timestamp planned | Missing explicit plan for timestamp-driven sorting in Collection Home and sync conflict resolution UI |
| PRD-029 | Persist Scoop only for saved shows, 4h freshness | critical | full | Section 8.3: "persist on completion only if show is in collection"; Phase 5: "Cache/freshness logic (4 hours)" | |
| PRD-030 | Keep Ask and Alchemy state session-only | important | partial | Business rules label chat/Alchemy as transient, but schema creates a persistent `chat_sessions` table in Supabase | Using a database table for session state contradicts session-only intent unless explicit cleanup is implemented |
| PRD-031 | Resolve AI recommendations to real selectable shows | critical | full | Section 9.4 details catalog resolution flow by external ID and title matching | |
| PRD-032 | Show collection and rating tile indicators | important | full | Section 7.2.1: "in-collection badge, rating badge"; Business Rules Checklist confirms | |
| PRD-033 | Sync libraries/settings consistently and merge duplicates | important | partial | Merge rules by timestamp exist, but cross-device sync pipeline and duplicate detection are not explicitly planned | Missing explicit sync transport and duplicate-detection algorithm |
| PRD-034 | Preserve saved libraries across data-model upgrades | critical | full | `app_metadata` table with `data_model_version`; Phase 6: "Data migration framework" | |
| PRD-035 | Persist synced settings, local settings, UI state | important | full | Tables for `cloud_settings`, `local_settings`, and `ui_state` with per-user rows | |
| PRD-036 | Keep provider IDs persisted and detail fetches transient | important | full | Schema stores `provider_data jsonb`; Section 5.2 lists cast/crew/seasons/videos as transient | |
| PRD-037 | Merge catalog fields safely and maintain timestamps | critical | full | Section 5.3: "selectFirstNonEmpty(new, old)" and timestamp resolution for my* fields | |
| PRD-038 | Provide filters panel and main screen destinations | important | full | Section 7.1 Layout Shell: sidebar with filters, main area with Home/Detail/Find/Person/Settings | |
| PRD-039 | Keep Find/Discover in persistent primary navigation | important | full | Section 7.1: "Global Nav (Find, Settings)" | |
| PRD-040 | Keep Settings in persistent primary navigation | important | full | Section 7.1: "Global Nav (Find, Settings)" | |
| PRD-041 | Offer Search, Ask, Alchemy discover modes | important | full | Section 7.3 Discover Hub: "Mode switcher: Search | Ask | Alchemy" | |
| PRD-042 | Show only library items matching active filters | important | full | Section 7.2.1 Collection Home: shows matching selected filter(s) | |
| PRD-043 | Group home into Active, Excited, Interested, Others | important | full | Section 7.2.1 explicitly lists the four groups | |
| PRD-044 | Support All, tag, genre, decade, score, media filters | important | full | Section 7.1 sidebar: "All Shows, Tag filters, Data filters (genre, decade, score), Media type toggle" | |
| PRD-045 | Render poster, title, and My Data badges | important | full | Section 7.2.1: "Each tile: poster, title, in-collection badge, rating badge" | |
| PRD-046 | Provide empty-library and empty-filter states | detail | full | Phase 2: "Empty states"; Section 7.2.1: "Empty state prompts to Search/Ask" | |
| PRD-047 | Search by title or keywords | important | full | Section 7.3 Search: "text input → poster grid results"; `/api/search` route | |
| PRD-048 | Use poster grid with collection markers | important | full | Section 7.3: "poster grid results" and in-collection badges | |
| PRD-049 | Auto-open Search when setting is enabled | detail | full | Schema `auto_search` boolean; Section 7.2.5 Settings: "Search on launch toggle" | |
| PRD-050 | Keep Search non-AI in tone | important | partial | AI personality doc says Search has no AI voice, but plan does not explicitly preserve straightforward search tone | Plan does not explicitly state Search should remain non-AI in tone |
| PRD-051 | Preserve Show Detail narrative section order | important | full | Section 7.2.2 lists 12 sections in exact PRD narrative hierarchy | |
| PRD-052 | Prioritize motion-rich header with graceful fallback | important | partial | Section 7.2.2 mentions trailers and inline playback, but does not explicitly plan fallback to poster/backdrop only | Missing explicit fallback strategy when trailers/backdrops are unavailable |
| PRD-053 | Surface year, runtime/seasons, and community score early | important | full | Section 7.2.2: CoreFacts is section 2 immediately after header | |
| PRD-054 | Place status/interest controls in toolbar | important | full | Section 7.2.2: MyRelationshipToolbar is section 3 | |
| PRD-055 | Auto-save unsaved tagged show as Later/Interested | critical | full | Business Rules Checklist explicitly states this rule | |
| PRD-056 | Auto-save unsaved rated show as Done | critical | full | Business Rules Checklist explicitly states this rule | |
| PRD-057 | Show overview early for fast scanning | important | full | Section 7.2.2: Overview + ScoopToggle is section 4 | |
| PRD-058 | Scoop shows correct states and progressive feedback | important | partial | Streaming UI is planned, but toggle copy states ("Give me the scoop!" / "Show the scoop" / "The Scoop") are not specified | Missing explicit plan for toggle copy state transitions |
| PRD-059 | Ask-about-show deep-link seeds Ask context | important | full | Section 7.2.2: "AskAboutShowCTA — links to Ask with show context seeded" | |
| PRD-060 | Include traditional recommendations strand | important | full | Section 7.2.2: "RecommendationsStrand — traditional similar/recommended shows" | |
| PRD-061 | Explore Similar uses CTA-first concept flow | important | full | Section 7.2.2: "Get Concepts → concept chips → Explore Shows → recs grid" | |
| PRD-062 | Include streaming availability and person-linking credits | important | full | Section 7.2.2: StreamingProviders and CastCrewStrands → Person Detail | |
| PRD-063 | Gate seasons to TV and financials to movies | important | full | Section 7.2.2: "SeasonsList (TV only)" and "BudgetRevenue (movies)" | |
| PRD-064 | Keep primary actions early and page not overwhelming | important | partial | Primary actions are ordered early, but plan does not explicitly address busyness-vs-power design intent | Missing explicit design constraint to prevent Detail page from becoming overwhelming |
| PRD-065 | Provide conversational Ask chat interface | important | full | Section 7.3: "chat UI with message list" | |
| PRD-066 | Answer directly with confident, spoiler-safe recommendations | important | partial | Base persona includes spoiler-safe and opinionated, but plan does not specify the "direct answer within first 3–5 lines" contract | Missing explicit plan for answer directness and brevity contract in Ask |
| PRD-067 | Show horizontal mentioned-shows strip from chat | important | full | Section 7.3: "mentioned-shows horizontal strip"; Section 9.1 mentions askWithMentionsPrompt | |
| PRD-068 | Open Detail from mentions or Search fallback | important | full | Section 9.4 resolution flow and Section 7.3 tapping behavior | |
| PRD-069 | Show six random starter prompts with refresh | important | full | Phase 3: "Starter prompts (6 random, refreshable)" | |
| PRD-070 | Summarize older turns while preserving voice | important | full | Section 9.2: "After ~10 turns, summarize older turns into 1–2 sentences preserving persona tone" | |
| PRD-071 | Seed Ask-about-show sessions with show handoff | important | full | Section 7.2.2 and Section 9.2: "Current show(s) for scoped requests" | |
| PRD-072 | Emit `commentary` plus exact `showList` contract | critical | full | Section 9.1: `askWithMentionsPrompt` outputs `{ commentary, showList }` with exact `Title::externalId::mediaType;;...` format | |
| PRD-073 | Retry malformed mention output once, then fallback | important | full | Section 9.3: "Retry once → plain text + search handoff" for Ask w/ Mentions | |
| PRD-074 | Redirect Ask back into TV/movie domain | important | full | Section 9.1 base personality: "Stay in TV/movies domain" | |
| PRD-075 | Treat concepts as taste ingredients, not genres | important | full | Section 9.1: "ingredient-like hooks" and "vibe/structure/thematic ingredients" | |
| PRD-076 | Return bullet-only, 1-3 word, non-generic concepts | important | full | Section 9.1: "bullet list, 1–3 words each" and avoidance of generic placeholders | |
| PRD-077 | Order concepts by strongest aha and varied axes | important | partial | Plan specifies bullet list format but does not explicitly plan ordering by strength or axis diversity | Missing explicit concept ordering and diversity rules in generation prompt |
| PRD-078 | Require concept selection and guide ingredient picking | important | partial | Alchemy and Explore Similar flows require selection, but plan does not include UI copy/hints guiding ingredient picking | Missing explicit guidance copy like "pick the ingredients you want more of" |
| PRD-079 | Return exactly five Explore Similar recommendations | important | partial | Section 9.1 conflates counts as "5–6 recs" without distinguishing Explore Similar (5) from Alchemy (6) | Missing explicit count distinction: Explore Similar must return exactly 5, Alchemy exactly 6 |
| PRD-080 | Support full Alchemy loop with chaining | important | full | Section 7.3 Alchemy lists all steps including "More Alchemy! chains results as new inputs" | |
| PRD-081 | Clear downstream results when inputs change | important | partial | Section 7.3 says "changing shows clears concepts/results" but does not mention clearing when concepts are selected/unselected | Missing explicit rule that selecting/unselecting concepts clears downstream recommendation results |
| PRD-082 | Generate shared multi-show concepts with larger option pool | important | partial | Plan says concepts are "shared across all inputs for multi-show" but does not mention returning a larger pool for multi-show vs single-show | Missing explicit plan for larger concept option pool in multi-show (Alchemy) vs single-show |
| PRD-083 | Cite selected concepts in concise recommendation reasons | important | full | Section 9.1: "recs with reasons citing concepts" | |
| PRD-084 | Deliver surprising but defensible taste-aligned recommendations | important | partial | Base personality is taste-aware, but plan does not explicitly target "surprise without betrayal" or taste-alignment validation | Missing explicit quality bar for surprising-yet-defensible recommendations and taste-alignment checks |
| PRD-085 | Keep one consistent AI persona across surfaces | important | full | Section 9.1: "Maintain a shared ai/prompts.ts with base personality + surface-specific overrides" | |
| PRD-086 | Enforce shared AI guardrails across all surfaces | critical | full | Section 9.1 base personality includes spoiler-safe, domain restriction, and opinionated honesty | |
| PRD-087 | Make AI warm, joyful, and light in critique | important | full | Section 9.1: "Fun, chatty TV/movie nerd friend" and voice pillars | |
| PRD-088 | Structure Scoop as personal taste mini-review | important | full | Section 9.1: "scoopPrompt → structured mini blog-post (~150–350 words)" | |
| PRD-089 | Keep Ask brisk and dialogue-like by default | important | full | Section 9.1: "askPrompt → conversational, 1–3 paragraphs + bulleted lists" | |
| PRD-090 | Feed AI the right surface-specific context inputs | important | full | Section 9.2 lists library, current show, conversation turns, and selected concepts per surface | |
| PRD-091 | Validate discovery with rubric and hard-fail integrity | important | partial | Risks table mentions "golden set regression tests" as mitigation, but no explicit implementation task for discovery quality rubric or hard-fail checks | Missing explicit plan to implement the discovery quality rubric and non-negotiable real-show integrity validation |
| PRD-092 | Show person gallery, name, and bio | important | full | Section 7.2.4: "Image gallery, name, bio" | |
| PRD-093 | Include ratings, genres, and projects-by-year analytics | important | full | Section 7.2.4: "Analytics charts (avg ratings by project, top genres, projects-by-year)" | |
| PRD-094 | Group filmography by year | important | full | Section 7.2.4: "Filmography grouped by year" | |
| PRD-095 | Open Show Detail from selected credit | important | full | Section 7.2.4: "credit opens Show Detail" | |
| PRD-096 | Include font size and Search-on-launch settings | important | full | Section 7.2.5: "Font size / readability" and "Search on launch toggle"; schema has both | |
| PRD-097 | Support username, model, and API-key settings safely | important | full | Section 7.2.5 lists username, AI key/model, catalog key; Section 13 says keys never committed | |
| PRD-098 | Export saved shows and My Data as zip | critical | full | Section 7.2.5: "Export My Data (ZIP with JSON backup)"; `/api/export` route | |
| PRD-099 | Encode export dates using ISO-8601 | important | full | Section 7.2.5 explicitly states "ISO-8601 dates" | |


## 3. Coverage Scores

**Overall score:**

```
score = (full_count × 1.0 + partial_count × 0.5) / total_count × 100
score = (84 × 1.0 + 15 × 0.5) / 99 × 100 = 92.4%
```

**Score by severity tier:**

```
Critical:  (30 × 1.0 + 0 × 0.5) / 30 × 100 = 100.0%  (30 of 30 critical requirements)
Important: (52 × 1.0 + 15 × 0.5) / 67 × 100 = 88.8%  (52 full, 15 partial of 67 important requirements)
Detail:    (2 × 1.0 + 0 × 0.5) / 2 × 100 = 100.0%   (2 of 2 detail requirements)
Overall:   92.4% (99 total requirements)
```

## 4. Top Gaps

1. **PRD-091 | `important` | Validate discovery with rubric and hard-fail integrity**
   The plan treats prompt brittleness as a risk to mitigate but does not schedule implementation of the discovery quality rubric or non-negotiable real-show integrity checks. Without this, AI outputs may drift, hallucinate titles, or fail the taste-alignment bar without any build-time or run-time detection.

2. **PRD-084 | `important` | Deliver surprising but defensible taste-aligned recommendations**
   While the base persona is taste-aware, the plan lacks explicit quality targets for recommendation surprise and defensibility. The core value proposition of the app—discovery grounded in the user's library—depends on this. Without planning for it, recommendations risk feeling generic and interchangeable with any algorithmic feed.

3. **PRD-066 | `important` | Answer directly with confident, spoiler-safe recommendations**
   The Ask prompt is described as "conversational, 1–3 paragraphs," but the PRD requires direct answers within the first 3–5 lines. Missing this contract means the chat could feel slow and essay-like, undermining the "low-friction, fast, and fun" target experience.

4. **PRD-079 | `important` | Return exactly five Explore Similar recommendations**
   The plan conflates Explore Similar (5 recs) and Alchemy (6 recs) into a single "5–6 recs" specification. This ambiguity could lead to inconsistent UI contracts and broken user expectations on one or both surfaces.

5. **PRD-081 | `important` | Clear downstream results when inputs change**
   The plan only specifies that changing starting shows clears concepts and results. It omits the rule that selecting or unselecting concepts must also clear downstream recommendations. Without this, users may see stale recommendations that no longer match their current concept selection.

## 5. Coverage Narrative

### Overall Posture

This is a structurally sound plan with minor but meaningful gaps. Every critical requirement is fully addressed, giving high confidence that the foundation—runtime, data model, identity isolation, and core business rules—is solid. The 92.4% overall score reflects strong coverage across infrastructure, collection management, navigation, and settings. The remaining 15 partial items are concentrated in AI behavioral contracts, discovery quality validation, and fine-grained interaction states. These gaps are unlikely to cause build failures, but they elevate the risk that the finished product will technically work without feeling emotionally resonant or trustworthy.

### Strength Clusters

The plan is strongest in **Benchmark Runtime & Isolation** and **Collection Data & Persistence**. Namespace isolation, user scoping, dev auth injection, schema evolution, and the full business-rules checklist (saving triggers, defaults, removal, re-add, timestamps) are all thoroughly specified. **Settings & Export** is another bright spot: the critical ZIP export, ISO-8601 encoding, and safe API-key handling are explicitly planned. The **App Navigation & Discover Shell** and **Person Detail** areas are also comprehensively covered, with clear component hierarchies and data flows.

### Weakness Clusters

Gaps do not scatter randomly; they cluster around three themes:

1. **AI Discovery Quality** — Six of the fifteen partial items relate to AI behavior: concept ordering and diversity (PRD-077), concept guidance copy (PRD-078), exact recommendation counts (PRD-079), downstream clearing (PRD-081), multi-show concept pool sizing (PRD-082), taste-alignment and surprise (PRD-084), and the missing validation rubric (PRD-091). This pattern suggests the plan treats AI as a prompt-and-parser implementation detail rather than a specifiable, quality-gated user surface.

2. **Show Detail Interaction States** — Three partial items (header media fallback PRD-052, Scoop toggle states PRD-058, busyness vs power PRD-064) indicate that the Detail page plan lists features in order but stops short of specifying granular interaction states and design constraints.

3. **Ask Directness and Tone Contracts** — Two partial items (Search non-AI tone PRD-050, Ask directness PRD-066) show that voice-specific behavioral contracts are under-specified relative to the rich personality documentation in the PRD.

### Risk Assessment

If this plan were executed without addressing gaps, the most likely failure mode is an AI discovery experience that technically functions but feels generic and untrustworthy. A user or QA reviewer would notice first that:

- **Ask responses are verbose** rather than brisk and direct, making the chat feel like reading a review instead of talking to a friend.
- **Recommendations lack specificity** — Alchemy and Explore Similar may return titles, but the reasons won't clearly cite concepts, and the count may be wrong (5 vs 6).
- **Hallucinated or unresolvable titles slip through** because there is no planned hard-fail integrity check or golden-set regression test.
- **The Scoop toggle feels broken** because it doesn't communicate cached vs. fresh states, leaving users uncertain whether they're seeing new content.

These are experience-degrading rather than build-blocking issues, but they directly undermine the app's primary value proposition of taste-aware, joyful discovery.

### Remediation Guidance

The weakness clusters require three categories of additional planning work:

1. **Detailed AI Behavioral Contracts** — Expand Section 9 (AI Integration) with explicit acceptance criteria for each surface: exact word-count targets for Ask, exact recommendation counts per surface, concept diversity rules, and downstream-clearing state machines.

2. **Discovery Quality Gates** — Elevate the "golden set regression tests" risk mitigation into an implementation task. Define who runs the rubric, when, and what hard-fail criteria block a build (real-show integrity must be non-negotiable).

3. **Interaction State Specifications** — Add a subsection to Show Detail and Alchemy that maps every user action to its immediate UI consequence: toggle copy transitions, concept-selection clearing rules, and header fallback behavior.

