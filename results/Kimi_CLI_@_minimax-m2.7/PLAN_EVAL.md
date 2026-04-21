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
| PRD-001 | Use Next.js latest stable runtime | critical | full | Project Overview specifies "Next.js (latest stable)" | |
| PRD-002 | Use Supabase official client libraries | critical | full | Project Overview specifies "Supabase (official client libraries)" | |
| PRD-003 | Ship `.env.example` with required variables | critical | full | Project Structure includes `.env.example`; Section 4.1 provides complete template | |
| PRD-004 | Ignore `.env*` secrets except example | important | missing | No mention of `.gitignore` handling of `.env*` files | Plan omits the `.gitignore` configuration that prevents `.env` secrets from being committed |
| PRD-005 | Configure build through env without code edits | critical | full | Section 4.1 explicitly states "The build MUST run by filling in environment variables, without editing source code" | |
| PRD-006 | Keep secrets out of repo and server-only | critical | partial | `.env.example` included but `.gitignore` not specified; Supabase service role marked server-only in schema | Plan does not explicitly mandate `.gitignore` exclusion of `.env*` secrets |
| PRD-007 | Provide app, test, reset command scripts | critical | full | Section 4.4 (Dev Scripts) lists dev, build, start, test, and test:reset scripts | |
| PRD-008 | Include repeatable schema evolution artifacts | critical | full | Section 3.2 describes migration strategy using `supabase/migrations/` with semantic versioning | |
| PRD-009 | Use one stable namespace per build | critical | full | Section 4.3 (Namespace Isolation) and database schema both include `namespace_id` | |
| PRD-010 | Isolate namespaces and scope destructive resets | critical | full | Section 4.3 states "Test reset scripts operate within a single namespace"; Section 8.1 confirms namespace-scoped destructive testing | |
| PRD-011 | Attach every user record to `user_id` | critical | full | Database schema shows `user_id` column in `shows` table marked "**Indexed, required**" | |
| PRD-012 | Partition persisted data by namespace and user | critical | full | Schema shows composite index `(namespace_id, user_id)`; Section 4.3 confirms queries filter by both | |
| PRD-013 | Support documented dev auth injection, prod-gated | important | full | Section 4.2 (Identity Injection) documents X-User-Id header, DEV_USER_ID fallback, and NODE_ENV gating | |
| PRD-014 | Real OAuth later needs no schema redesign | important | full | Plan uses opaque `user_id` (not provider-specific); Section 10 notes no schema changes needed for future OAuth | |
| PRD-015 | Keep backend as persisted source of truth | critical | full | Section 6.1 explicitly states "Persisted user data MUST be stored server-side" | |
| PRD-016 | Make client cache safe to discard | critical | full | Section 6.2 states "Cache is disposable"; Section 10.2 describes client-side caching as optional optimization | |
| PRD-017 | Avoid Docker requirement for cloud-agent compatibility | important | full | Infra rider text in plan confirms "Builds MUST NOT assume Docker is available" | |
| PRD-018 | Overlay saved user data on every show appearance | critical | full | Section 4.1 states "User edits always win over refreshed public data"; Section 7.1 data behaviors confirm overlay | |
| PRD-019 | Support visible statuses plus hidden `Next` | important | partial | Schema includes `my_status` column; Status chips documented for toolbar, but hidden "Next" status not explicitly mentioned | Plan covers visible statuses but does not address the hidden "Next" status in the data model |
| PRD-020 | Map Interested/Excited chips to Later interest | critical | full | Section 5.6 Show Detail confirms "Interested/Excited map to Later + Interest"; Section 7.3 removal rules confirm same | |
| PRD-021 | Support free-form multi-tag personal tag library | important | partial | Tags system planned with `my_tags` array in schema; TagPicker component listed; Section 5.1 mentions "personal tag library" powering filters | Plan mentions tags but does not detail the free-form multi-tag library UX for creating and managing personal tags |
| PRD-022 | Define collection membership by assigned status | critical | full | Section 5.1 (Collection Home) defines "in collection" by non-nil `My Status`; Section 7.3 confirms removal clears status | |
| PRD-023 | Save shows from status, interest, rating, tagging | critical | full | Section 7.1 (Saving Triggers) lists all four triggers explicitly | |
| PRD-024 | Default save to Later/Interested except rating-save Done | critical | full | Section 7.2 (Default Values) specifies defaults: `my_status = Later`, `my_interest = Interested`; exception for rating → Done | |
| PRD-025 | Removing status deletes show and all My Data | critical | full | Section 7.3 (Removal) specifies clearing status removes all My Data (status, interest, tags, rating, scoop) | |
| PRD-026 | Re-add preserves My Data and refreshes public data | critical | full | Section 5.5 states "Preserve their latest status, interest, tags, rating, and AI Scoop" on re-add | |
| PRD-027 | Track per-field My Data modification timestamps | critical | full | Section 5.6 lists all five timestamp fields (myStatusUpdateDate, etc.); Section 7.5 confirms per-field tracking | |
| PRD-028 | Use timestamps for sorting, sync, freshness | important | full | Section 7.5 explicitly lists sorting, sync resolution, and AI cache freshness as uses | |
| PRD-029 | Persist Scoop only for saved shows, 4h freshness | critical | full | Section 5.6 states "Persists only if show is in collection"; freshness "4 hours" documented | |
| PRD-030 | Keep Ask and Alchemy state session-only | important | full | Section 5.3 (Ask) states "Chat state is session-only (not persisted)"; Section 5.4 (Alchemy) confirms same | |
| PRD-031 | Resolve AI recommendations to real selectable shows | critical | full | Section 5.3 AI Contract shows resolution via external ID lookup; Section 5.8 confirms recommendations map to real Show objects | |
| PRD-032 | Show collection and rating tile indicators | important | partial | Section 5.1 mentions "In-collection indicator" and "user rating"; Section 5.2 confirms "Mark in-collection items"; ShowTile component planned | Plan mentions indicators but may not fully specify both collection AND rating badges on tiles as separate UI elements |
| PRD-033 | Sync libraries/settings consistently and merge duplicates | important | missing | Not addressed in the plan | Plan does not address cross-device sync behavior, conflict resolution by timestamp, or duplicate detection/merging |
| PRD-034 | Preserve saved libraries across data-model upgrades | critical | full | Section 8.8 (Polish phase) includes "Data continuity across upgrades"; Section 7.5 confirms merge policy preserves user data | |
| PRD-035 | Persist synced settings, local settings, UI state | important | partial | Schema includes `user_settings` table; local settings (`auto_search`, `font_size`) mentioned in schema; Section 5.8 lists settings page | Plan does not clearly distinguish between synced settings, local settings, and ephemeral UI state, or specify which is persisted where |
| PRD-036 | Keep provider IDs persisted and detail fetches transient | important | missing | Schema includes `provider_data` JSONB column; transient fetches not explicitly distinguished | Plan does not explicitly state that provider IDs should be persisted while cast/crew/seasons/recommendations are transient re-fetchable data |
| PRD-037 | Merge catalog fields safely and maintain timestamps | critical | full | Section 7.4 (Merge Policy) details `selectFirstNonEmpty` for non-my fields, timestamp resolution for my fields, and `creation_date` preservation | |
| PRD-038 | Provide filters panel and main screen destinations | important | full | Section 6 (App Structure) describes "Filters/navigation panel" and "Main content area"; FilterSidebar component planned | |
| PRD-039 | Keep Find/Discover in persistent primary navigation | important | full | Section 6 explicitly states "Persistent Find/Discover entry point from primary navigation" | |
| PRD-040 | Keep Settings in persistent primary navigation | important | full | Section 6 explicitly states "Persistent Settings entry point from primary navigation" | |
| PRD-041 | Offer Search, Ask, Alchemy discover modes | important | full | Section 6 lists all three modes; Section 5.2-5.4 detail each mode | |
| PRD-042 | Show only library items matching active filters | important | full | Section 5.1 states "Shows matching the selected filter(s) are displayed"; Section 7.1 confirms query filtering | |
| PRD-043 | Group home into Active, Excited, Interested, Others | important | full | Section 5.1 lists exactly these four status groups with section descriptions | |
| PRD-044 | Support All, tag, genre, decade, score, media filters | important | full | Section 5.1 and 4.5 specify all filter types: media-type toggle, tag filters, genre, decade, community score | |
| PRD-045 | Render poster, title, and My Data badges | important | full | Section 5.1 states "Tiles show poster, title, and My Data badges"; ShowTile component planned | |
| PRD-046 | Provide empty-library and empty-filter states | detail | partial | Section 5.1 mentions empty states but Section 9 (Phase 8) only lists "Empty states" without detail | Empty states are listed as a polish task but not designed or specified |
| PRD-047 | Search by title or keywords | important | full | Section 5.2 states "Text search by title/keywords" | |
| PRD-048 | Use poster grid with collection markers | important | full | Section 5.2 states "Results in poster grid" and "Mark in-collection items" | |
| PRD-049 | Auto-open Search when setting is enabled | detail | partial | Section 5.2 mentions "Option to auto-open on launch if `auto_search` setting is true" but implementation detail not specified | Auto-open behavior on launch is mentioned but not detailed in implementation phases |
| PRD-050 | Keep Search non-AI in tone | important | full | Section 5.2 explicitly states "**No AI voice** — straightforward catalog search" | |
| PRD-051 | Preserve Show Detail narrative section order | important | full | Section 5.6 lists the exact 12-section order matching PRD-051's source document | |
| PRD-052 | Prioritize motion-rich header with graceful fallback | important | full | Section 5.6 lists "Header media carousel (backdrops/posters/logos/trailers)"; Section 3.1 confirms graceful fallback | |
| PRD-053 | Surface year, runtime/seasons, and community score early | important | full | Section 5.6 shows these in Section 2 (Core facts); Section 3.2 confirms fast orientation intent | |
| PRD-054 | Place status/interest controls in toolbar | important | full | Section 5.6 specifies "My Status + Interest: status chips in toolbar (not in the scroll body)" | |
| PRD-055 | Auto-save unsaved tagged show as Later/Interested | critical | full | Section 5.6 states "Adding tag to unsaved show → `my_status = Later`, `my_interest = Interested`" | |
| PRD-056 | Auto-save unsaved rated show as Done | critical | full | Section 5.6 states "Rating unsaved show → `my_status = Done`" | |
| PRD-057 | Show overview early for fast scanning | important | full | Section 5.6 places Overview at position 4 of 12; Section 2 confirms first-15-seconds orientation | |
| PRD-058 | Scoop shows correct states and progressive feedback | important | full | Section 5.6 specifies "Shows 'Generating...' during stream" and "Persists only if show is in collection" | |
| PRD-059 | Ask-about-show deep-link seeds Ask context | important | full | Section 5.3 states "Ask About Show from Detail seeds context"; Section 5.6 confirms CTA | |
| PRD-060 | Include traditional recommendations strand | important | full | Section 5.6 shows strand at position 7; Section 3.6 confirms non-AI fallback path | |
| PRD-061 | Explore Similar uses CTA-first concept flow | important | full | Section 5.5 describes "Get Concepts → select → Explore Shows" flow with CTA buttons | |
| PRD-062 | Include streaming availability and person-linking credits | important | full | Section 5.6 includes "Streaming availability" and "Cast, Crew → Person Detail" | |
| PRD-063 | Gate seasons to TV and financials to movies | important | full | Section 5.6 specifies "Seasons (TV only)" and "Budget/Revenue (movies)" | |
| PRD-064 | Keep primary actions early and page not overwhelming | important | full | Section 5.6 prioritizes status/rating/scoop/concepts early; Section 4 confirms "powerful but not overwhelming" | |
| PRD-065 | Provide conversational Ask chat interface | important | full | Section 5.3 describes chat UI with user/assistant turns | |
| PRD-066 | Answer directly with confident, spoiler-safe recommendations | important | full | Section 5.3 states "AI responds in character (fun, chatty, opinionated, spoiler-safe)"; Section 2.2 of discovery bar confirms direct answers | |
| PRD-067 | Show horizontal mentioned-shows strip from chat | important | full | Section 5.3 states "Inline show mentions appear in horizontal strip below chat" | |
| PRD-068 | Open Detail from mentions or Search fallback | important | full | Section 5.3 states "Show mentioned shows as selectable → opens Detail or Search fallback" | |
| PRD-069 | Show six random starter prompts with refresh | important | full | Section 5.3 states "Welcome view: 6 random starter prompts with refresh" | |
| PRD-070 | Summarize older turns while preserving voice | important | full | Section 5.3 states "Conversation summarization after ~10 messages (preserve voice)" | |
| PRD-071 | Seed Ask-about-show sessions with show handoff | important | full | Section 5.3 confirms "Ask About Show from Detail seeds context" | |
| PRD-072 | Emit `commentary` plus exact `showList` contract | critical | full | Section 5.3 AI Contract specifies exact JSON structure: `{ "commentary": "...", "showList": "Title::externalId::mediaType;;..." }` | |
| PRD-073 | Retry malformed mention output once, then fallback | important | full | Section 5.3 states "Retry once on parse failure, then fallback to text + Search" | |
| PRD-074 | Redirect Ask back into TV/movie domain | important | full | Section 6.3 (Guardrails) states "Stay in TV/movies domain" | |
| PRD-075 | Treat concepts as taste ingredients, not genres | important | full | Section 5.5 states "Concepts are taste ingredients, not genres"; Section 1 of concept_system.md confirms | |
| PRD-076 | Return bullet-only, 1-3 word, non-generic concepts | important | full | Section 5.5 specifies "bullet list only, 1-3 words, evocative, no plot"; AI Contracts confirm same | |
| PRD-077 | Order concepts by strongest aha and varied axes | important | full | Section 5.5 states "Order by strongest 'aha' first, varied axes"; Section 4 of concept_system.md confirms | |
| PRD-078 | Require concept selection and guide ingredient picking | important | full | Section 5.5 includes "Select 1+ concepts" step; Section 5.4 mentions "pick the ingredients you want more of" | |
| PRD-079 | Return exactly five Explore Similar recommendations | important | full | Section 5.5 explicitly states "Return exactly 5 Explore Similar recommendations" | |
| PRD-080 | Support full Alchemy loop with chaining | important | full | Section 5.4 describes complete 5-step flow with "More Alchemy!" chaining option | |
| PRD-081 | Clear downstream results when inputs change | important | full | Section 5.4 states "Changing shows clears concepts/results"; Section 5.5 confirms same | |
| PRD-082 | Generate shared multi-show concepts with larger option pool | important | full | Section 5.4 states "Select 2+ starting shows" for Alchemy; Section 8 of concept_system.md confirms larger pool | |
| PRD-083 | Cite selected concepts in concise recommendation reasons | important | full | Section 5.4 AI Contracts state "reasons citing selected concepts"; Section 6 confirms citing concepts | |
| PRD-084 | Deliver surprising but defensible taste-aligned recommendations | important | full | Section 5.4 mentions "surprising but defensible"; Section 1.2 of discovery bar confirms taste alignment | |
| PRD-085 | Keep one consistent AI persona across surfaces | important | full | Section 6.1 (Shared Persona) explicitly states single persona; Section 1 of voice document confirms | |
| PRD-086 | Enforce shared AI guardrails across all surfaces | critical | full | Section 6.3 (Guardrails) lists domain restriction, spoiler-safety, opinionated honesty, no generic output | |
| PRD-087 | Make AI warm, joyful, and light in critique | important | full | Section 6.1 specifies "Fun, chatty TV/movie nerd friend"; Section 2 confirms joy-forward and light critique | |
| PRD-088 | Structure Scoop as personal taste mini-review | important | full | Section 6.2 (Scoop) describes 5-section structure: personal take, stack-up, Scoop paragraph, fit/warnings, verdict | |
| PRD-089 | Keep Ask brisk and dialogue-like by default | important | full | Section 6.2 (Ask) specifies "1-3 paragraphs, then bulleted list"; "Brisk, dialogue-like" | |
| PRD-090 | Feed AI the right surface-specific context inputs | important | full | Section 5.3 Data Flow lists context sent to AI (conversation history, library, current show) | |
| PRD-091 | Validate discovery with rubric and hard-fail integrity | important | full | Section 8.3 (Quality Validation) specifies rubric scoring with Real-show integrity = 2 (non-negotiable) | |
| PRD-092 | Show person gallery, name, and bio | important | full | Section 5.7 states "Image gallery, name, bio" | |
| PRD-093 | Include ratings, genres, and projects-by-year analytics | important | full | Section 5.7 states "Analytics: average ratings, top genres, projects-by-year" | |
| PRD-094 | Group filmography by year | important | full | Section 5.7 states "Filmography grouped by year" | |
| PRD-095 | Open Show Detail from selected credit | important | full | Section 5.7 states "Tap credit → Show Detail" | |
| PRD-096 | Include font size and Search-on-launch settings | important | full | Section 5.8 lists "font size, Search on launch"; schema includes `font_size` and `auto_search` fields | |
| PRD-097 | Support username, model, and API-key settings safely | important | full | Section 5.8 lists "username, model selection, API key (server-only)"; schema marks `ai_api_key` server-only | |
| PRD-098 | Export saved shows and My Data as zip | critical | full | Section 5.8 states "Export My Data: produces `.zip` with JSON backup" | |
| PRD-099 | Encode export dates using ISO-8601 | important | full | Section 5.8 specifies "ISO-8601 dates" | |

## 3. Coverage Scores

**Overall score:**

```
score = (full_count × 1.0 + partial_count × 0.5) / total_count × 100
score = (92 × 1.0 + 10 × 0.5 + 0 × 0.0) / 102 × 100 = 95/102 × 100 = 93.14%
```

**Score by severity tier:**

```
Critical:  (27 × 1.0 + 0 × 0.5) / 30 × 100 = 90.00%  (27 of 30 critical requirements)
Important: (61 × 1.0 + 9 × 0.5) / 67 × 100 = 69.5/67 = 96.27%  (61 of 67 important requirements)
Detail:    (1 × 1.0 + 1 × 0.5) / 2 × 100 = 75.00%  (1 of 2 detail requirements)
Overall:   93.14% (92 of 99 requirements with full coverage, 10 partial, 3 missing)
```

*Note: 3 requirements marked "partial" are actually important severity (PRD-019, PRD-021, PRD-032, PRD-035, PRD-046, PRD-049). Corrected calculation:*

```
Critical:  (27 × 1.0 + 1 × 0.5) / 30 × 100 = 27.5/30 × 100 = 91.67%  (27 full, 1 partial, 2 missing of 30)
Important: (60 × 1.0 + 6 × 0.5) / 67 × 100 = 63/67 × 100 = 94.03%  (60 full, 6 partial, 1 missing of 67)
Detail:    (1 × 1.0 + 1 × 0.5) / 2 × 100 = 1.5/2 × 100 = 75.00%  (1 full, 1 partial of 2)
Overall:   (88 × 1.0 + 8 × 0.5 + 3 × 0.0) / 99 × 100 = 92/99 × 100 = 92.93%
```

*Final counts: 88 full, 8 partial, 3 missing*

## 4. Top Gaps

### Gap 1: PRD-036 | `important` | Keep provider IDs persisted and detail fetches transient

**Why it matters:** The storage-schema.md explicitly requires storing provider IDs (streaming availability) persistently while treating cast, crew, seasons, recommendations, and similar shows as transient data that can be re-fetched. Without this distinction, the system may either over-fetch on every interaction or lose critical availability data. This is a core data architecture decision that affects API design, caching strategy, and offline behavior.

### Gap 2: PRD-033 | `important` | Sync libraries/settings consistently and merge duplicates

**Why it matters:** The PRD envisions optional cross-device sync for the user's collection and preferences. Without addressing this, the plan assumes a single-device experience. Sync introduces complex requirements around conflict resolution (timestamp-based), duplicate detection, and data consistency that must be architected upfront if sync is ever to be added.

### Gap 3: PRD-004 | `important` | Ignore `.env*` secrets except example

**Why it matters:** The infra rider explicitly requires that `.gitignore` exclude all `.env*` files except `.env.example`. This is a security-critical requirement for preventing secret leakage in version control. The plan mentions `.env.example` but does not specify the corresponding `.gitignore` rules.

### Gap 4: PRD-019 | `important` | Support visible statuses plus hidden `Next`

**Why it matters:** The status system PRD specifically notes that "Next" (up-next queue) exists in the data model but is not surfaced as a first-class UI status. The plan covers all five visible statuses but does not mention the hidden "Next" status at all, leaving ambiguity about whether it will be properly supported in the data layer.

### Gap 5: PRD-021 | `important` | Support free-form multi-tag personal tag library

**Why it matters:** Tags are a primary organizational mechanism in the app. The plan includes tag support in the schema and mentions tags in filters, but does not detail how users create and manage their personal tag library. Without this, the tag-based organization features lack a foundation.

## 5. Coverage Narrative

### Overall Posture

This plan is **structurally sound with minor but meaningful gaps**. The majority of requirements (88 of 99, or 89%) are fully addressed with concrete implementation details. The plan demonstrates strong coverage of critical infrastructure requirements (Next.js, Supabase, namespace isolation, user identity, environment configuration) and comprehensive treatment of UI features across all major screens (Collection Home, Show Detail, Ask, Alchemy, Person Detail, Settings).

The partial and missing items cluster around **data architecture concerns** (provider data persistence, sync behavior) and **specific security configurations** (`.gitignore`) rather than missing entire feature areas. This suggests the plan prioritizes getting features right while leaving some infrastructure subtleties unspecified.

### Strength Clusters

The plan is strongest in:

1. **Show Detail & Relationship UX** — Every requirement from section order to auto-save rules to progressive Scoop feedback is addressed with specificity. The 12-section narrative hierarchy is preserved verbatim.

2. **Ask Chat** — The conversational interface is thoroughly specified, including the exact JSON contract (`commentary` + `showList`), retry behavior, conversation summarization, and Ask-about-show seeding.

3. **Concepts, Explore Similar & Alchemy** — The multi-step flows for both features are fully detailed, including concept format (bullet-only, 1-3 words), recommendation counts (5 for Explore Similar, 6 for Alchemy), and the concept-to-recommendation contract.

4. **Infrastructure & Isolation** — All benchmark-mode requirements are met: Next.js runtime, Supabase client, namespace isolation, user identity injection, schema migrations, and one-command developer experience.

5. **AI Voice & Quality** — The shared persona specification is complete with tone sliders, surface-specific adaptations, and the rubric-based quality validation.

### Weakness Clusters

The gaps concentrate around **data persistence semantics** rather than feature coverage:

1. **Provider Data Architecture (PRD-036)**: The distinction between persisted provider IDs (streaming availability) and transient detail fetches (cast/crew/seasons) is not addressed. This affects how the app handles offline scenarios and API efficiency.

2. **Sync Behavior (PRD-033, PRD-035)**: Cross-device sync is mentioned in passing but not architected. The distinction between synced settings, local settings, and ephemeral UI state is unclear.

3. **Hidden Status (PRD-019)**: The "Next" status exists in the PRD but receives no mention in the plan, leaving uncertainty about whether this data model feature will be implemented.

4. **Tag Library Management (PRD-021)**: While tags are in the schema, the UX for creating and managing the personal tag library is not detailed.

5. **Security Configuration (PRD-004, PRD-006)**: The `.gitignore` rules for environment files are not specified, creating a potential for secret leakage in development.

### Risk Assessment

If executed as-is, the most likely failure mode is **data integrity issues during catalog refreshes and offline scenarios**. Without explicit handling of provider data persistence vs. transient fetches, the app may lose streaming availability data or over-fetch on every interaction. Users who rely on the "Stream It" section will have inconsistent experiences.

A secondary risk is **tag-based organization feeling incomplete**. Tags power filters across the app, but without a clear tag library management UX, users may struggle to build and maintain meaningful personal tag collections. This degrades the organizational power of the collection features.

The security configuration gaps (`.gitignore`) are lower immediate risk because they can be corrected before production, but represent a process gap in the plan's completeness.

### Remediation Guidance

The weakness clusters require the following categories of work:

1. **More detailed specification** for data persistence semantics (PRD-033, PRD-035, PRD-036): The plan should explicitly document which data is persisted server-side vs. cached locally, and how provider data flows through the system. This is an architectural decision, not a new feature.

2. **Missing plan sections** for tag library management (PRD-021): A new section detailing the tag creation, editing, and library management UX should be added. This is straightforward feature specification work.

3. **Configuration artifact addition** for security (PRD-004): A `.gitignore` file should be specified in the project structure with the appropriate rules for excluding `.env*` except `.env.example`. This is a small but critical deliverable.

4. **Data model clarification** for hidden "Next" status (PRD-019): The plan should explicitly state whether the "Next" hidden status will be implemented in the schema, even if not surfaced in UI. This avoids ambiguity for the development team.

---

*Evaluation completed. 88/99 requirements fully covered, 8 partial, 3 missing. Overall coverage: 92.93%*
