# PLAN EVALUATION: Personal TV + Movie Companion

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
| PRD-001 | Use Next.js latest stable runtime | critical | full | Phase 1: "Next.js (latest stable, App Router)" | |
| PRD-002 | Use Supabase official client libraries | critical | full | Section 1.1: "official @supabase/supabase-js client" | |
| PRD-003 | Ship .env.example with required variables | critical | full | Phase 1.6: ".env.example with all required variables" | |
| PRD-004 | Ignore .env* secrets except example | important | full | Section 5.4: ".env* in .gitignore" | |
| PRD-005 | Configure build through env without code edits | critical | full | Phase 1.6: env-listed config, rider says "without editing source code" | |
| PRD-006 | Keep secrets out of repo and server-only | critical | full | Section 5.4: "anon key for browser, service role key server-only" | |
| PRD-007 | Provide app, test, reset command scripts | critical | full | Phase 1.7 + scripts: dev.sh, test.sh, test-reset.sh | |
| PRD-008 | Include repeatable schema evolution artifacts | critical | full | Phase 1.3 + Section 2.2: migration files listed | |
| PRD-009 | Use one stable namespace per build | critical | full | Section 1.3: "Namespace isolation" with namespace_id | |
| PRD-010 | Isolate namespaces and scope destructive resets | critical | full | Section 1.3, Phase 1.4: RLS scoped to (namespace_id, user_id) | |
| PRD-011 | Attach every user record to user_id | critical | full | Section 1.3: "user_id — required — scopes to user" | |
| PRD-012 | Partition persisted data by namespace and user | critical | full | Section 1.3: "(namespace_id, user_id)" partition | |
| PRD-013 | Support documented dev auth injection, prod-gated | important | full | Phase 1.5: X-User-Id header, gated by NODE_ENV !== 'production' | |
| PRD-014 | Real OAuth later needs no schema redesign | important | full | Section 5.4: "config + auth wiring only, no schema redesign" | |
| PRD-015 | Keep backend as persisted source of truth | critical | full | Section 5.1: "Backend is source of truth" | |
| PRD-016 | Make client cache safe to discard | critical | full | Section 5.1: "client caching is disposable" | |
| PRD-017 | Avoid Docker requirement for cloud-agent compatibility | important | full | Rider: Supabase may be hosted or local, Docker not required | |
| PRD-018 | Overlay saved user data on every show appearance | critical | full | Schema: shows table includes my_status, my_tags, my_score, ai_scoop | |
| PRD-019 | Support visible statuses plus hidden Next | important | partial | Schema has my_status enum but Next status not mentioned | Next status (hidden) not referenced in schema or phases |
| PRD-020 | Map Interested/Excited chips to Later interest | critical | full | Phase 3.3 + Phase 5: "Interested/Excited map to Later + Interest" | |
| PRD-021 | Support free-form multi-tag personal tag library | important | full | Schema: my_tags text[]; Phase 4.1: dynamic tag filters | |
| PRD-022 | Define collection membership by assigned status | critical | full | PRD explicitly defines this; plan implements status-based membership | |
| PRD-023 | Save shows from status, interest, rating, tagging | critical | full | Phase 3.3: all four saving triggers listed | |
| PRD-024 | Default save to Later/Interested except rating-save Done | critical | full | Phase 3.3: defaults explicitly documented | |
| PRD-025 | Removing status deletes show and all My Data | critical | full | Phase 3.4: "Status removal flow with confirmation" | |
| PRD-026 | Re-add preserves My Data and refreshes public data | critical | full | Section 5.1: "User version takes precedence everywhere" | |
| PRD-027 | Track per-field My Data modification timestamps | critical | full | Schema: my_status_updated_at, my_interest_updated_at, etc. | |
| PRD-028 | Use timestamps for sorting, sync, freshness | important | full | Cross-cutting 5.1: per-field timestamp comparison | |
| PRD-029 | Persist Scoop only for saved shows, 4h freshness | critical | full | Phase 10: "Only persisted if show is in collection, 4-hour TTL" | |
| PRD-030 | Keep Ask and Alchemy state session-only | important | full | Phase 7.6 + Phase 8.7: "Session-only state — cleared when leaving" | |
| PRD-031 | Resolve AI recommendations to real selectable shows | critical | full | Section 5.1: actionability rule; Phase 2: catalog resolution | |
| PRD-032 | Show collection and rating tile indicators | important | full | Phase 4.2: "My Data badges (status, rating indicators)" | |
| PRD-033 | Sync libraries/settings consistently and merge duplicates | important | partial | Timestamp-based conflict resolution covered, but no explicit duplicate merge strategy | No mention of duplicate detection or transparent merging |
| PRD-034 | Preserve saved libraries across data-model upgrades | critical | full | Section 5.2: dataModelVersion tracking, transparent migration | |
| PRD-035 | Persist synced settings, local settings, UI state | important | partial | Settings mentioned at high level, but no detailed key-value schema for local/UI state | No explicit plan for fontSize, autoSearch, statusRemovalCount, etc. |
| PRD-036 | Keep provider IDs persisted and detail fetches transient | important | full | Schema: provider_data jsonb persisted; cast/seasons as transient fetches | |
| PRD-037 | Merge catalog fields safely and maintain timestamps | critical | full | Phase 2.3: merge-show.ts with selectFirstNonEmpty | |
| PRD-038 | Provide filters panel and main screen destinations | important | full | Phase 4.1: filters panel with sidebar; Phase 4.3: nav shell | |
| PRD-039 | Keep Find/Discover in persistent primary navigation | important | full | Phase 4.3: "persistent top nav with: Home, Find/Discover, Settings" | |
| PRD-040 | Keep Settings in persistent primary navigation | important | full | Phase 4.3: "persistent top nav with: Home, Find/Discover, Settings" | |
| PRD-041 | Offer Search, Ask, Alchemy discover modes | important | full | Phase 4.3 nav + Phase 6/7/8: three discover modes with route structure | |
| PRD-042 | Show only library items matching active filters | important | full | Phase 4.1: filters panel; listShows with filter support | |
| PRD-043 | Group home into Active, Excited, Interested, Others | important | full | Phase 4.2: "Status-grouped sections: Active, Excited, Interested, Others" | |
| PRD-044 | Support All, tag, genre, decade, score, media filters | important | full | Phase 4.1: All Shows, tag, genre, decade, score, media toggle | |
| PRD-045 | Render poster, title, and My Data badges | important | full | Phase 4.2: "poster, title, My Data badges" | |
| PRD-046 | Provide empty-library and empty-filter states | detail | full | Phase 4.2: empty states explicitly described | |
| PRD-047 | Search by title or keywords | important | full | Phase 6.1: "Text search by title/keywords" | |
| PRD-048 | Use poster grid with collection markers | important | full | Phase 6.2: "Poster grid results with in-collection markers" | |
| PRD-049 | Auto-open Search when setting is enabled | detail | full | Phase 6.4: "Search on Launch auto-open setting" | |
| PRD-050 | Keep Search non-AI in tone | important | full | Phase 6.5: "No AI voice in Search" | |
| PRD-051 | Preserve Show Detail narrative section order | important | full | Phase 5: all 12 sections listed in exact PRD order | |
| PRD-052 | Prioritize motion-rich header with graceful fallback | important | full | Phase 5.1: "backdrops/posters/logos/trailers, graceful fallback" | |
| PRD-053 | Surface year, runtime/seasons, community score early | important | full | Phase 5.2: "year, runtime/seasons, community score bar" | |
| PRD-054 | Place status/interest controls in toolbar | important | full | Phase 5: "Relationship controls (in toolbar, not scroll body)" | |
| PRD-055 | Auto-save unsaved tagged show as Later/Interested | critical | full | Phase 5: "Tag picker: adding tag to unsaved show auto-saves" | |
| PRD-056 | Auto-save unsaved rated show as Done | critical | full | Phase 5: "Rating bar: rating unsaved show auto-saves as Done" | |
| PRD-057 | Show overview early for fast scanning | important | full | Phase 5.4: "Overview text + Scoop toggle" at position 4 | |
| PRD-058 | Scoop shows correct states and progressive feedback | important | full | Phase 10.2: "Generating... placeholder, streams in" | |
| PRD-059 | Ask-about-show deep-link seeds Ask context | important | full | Phase 7.5: "deep-link from Detail seeds conversation" | |
| PRD-060 | Include traditional recommendations strand | important | full | Phase 5.7: "Traditional Recommendations strand" | |
| PRD-061 | Explore Similar uses CTA-first concept flow | important | full | Phase 9: Get Concepts → select → Explore Shows | |
| PRD-062 | Include streaming availability and person-linking credits | important | full | Phase 5.9 + Phase 5.10: "Stream It" and "Cast, Crew → Person Detail" | |
| PRD-063 | Gate seasons to TV and financials to movies | important | full | Phase 5.11: "Seasons (TV only)"; Phase 5.12: "Budget/Revenue (movies)" | |
| PRD-064 | Keep primary actions early and page not overwhelming | important | full | Phase 5: relationship controls in toolbar; section 5.1 busyness note | |
| PRD-065 | Provide conversational Ask chat interface | important | full | Phase 7.1: "Chat UI with user/assistant turns" | |
| PRD-066 | Answer directly with confident, spoiler-safe recommendations | important | partial | Shared guardrails mention spoiler-safe and opinionated, but no "direct answer within 3-5 lines" or "confident picks" guidance | Quality bar specifics (direct answer first, confident picks) not concretely planned |
| PRD-067 | Show horizontal mentioned-shows strip from chat | important | full | Phase 7.4: "Mentioned shows strip — horizontal row" | |
| PRD-068 | Open Detail from mentions or Search fallback | important | full | Phase 7.4: "tap to open Detail" | |
| PRD-069 | Show six random starter prompts with refresh | important | full | Phase 7.2: "6 random starter prompts (refreshable)" | |
| PRD-070 | Summarize older turns while preserving voice | important | full | Phase 13.4: "same persona voice" summarization | |
| PRD-071 | Seed Ask-about-show sessions with show handoff | important | full | Phase 7.5: "deep-link from Detail seeds conversation with show context" | |
| PRD-072 | Emit commentary plus exact showList contract | critical | full | Phase 7.3: structured output with showList in Title::externalId::mediaType format | |
| PRD-073 | Retry malformed mention output once, then fallback | important | partial | Guardrail fallback mentioned at shared level, but no specific retry-once-then-fallback strategy | No explicit retry strategy for malformed structured output |
| PRD-074 | Redirect Ask back into TV/movie domain | important | full | Phase 13.3: "TV/movies domain only (redirect if asked otherwise)" | |
| PRD-075 | Treat concepts as taste ingredients, not genres | important | partial | Phase 13 implies vibe-first but no explicit "taste ingredients, not genres" framing | Plan treats concepts functionally without addressing the taste-ingredient philosophy |
| PRD-076 | Return bullet-only, 1-3 word, non-generic concepts | important | partial | Phase 13.3: "1-3 word evocative bullets only" — but no explicit guard against generic concepts | No explicit plan to filter out "good characters" / "great story" type generica |
| PRD-077 | Order concepts by strongest aha and varied axes | important | partial | No explicit ordering strategy for concept quality or axis diversity | Plan does not address ordering or diversity of concept axes |
| PRD-078 | Require concept selection and guide ingredient picking | important | full | Phase 8.3: select concepts; Phase 9.2: select 1+ concepts | |
| PRD-079 | Return exactly five Explore Similar recommendations | important | full | Phase 9.3: "Returns 5 recommendations" | |
| PRD-080 | Support full Alchemy loop with chaining | important | full | Phase 8: all 4 steps + Phase 8.5: "More Alchemy! chaining" | |
| PRD-081 | Clear downstream results when inputs change | important | full | Phase 8.6: "changing shows clears concepts + results" | |
| PRD-082 | Generate shared multi-show concepts with larger option pool | important | full | Phase 8.2: "shared concepts (larger pool for multi-show)" | |
| PRD-083 | Cite selected concepts in concise recommendation reasons | important | full | Phase 9.3: "reasons citing selected concepts" | |
| PRD-084 | Deliver surprising but defensible taste-aligned recommendations | important | partial | Shared guardrails mention "vibe-first reasoning" but no explicit surprise + defensibility criteria | Quality bar's "surprise without betrayal" dimension not addressed in planning |
| PRD-085 | Keep one consistent AI persona across surfaces | important | full | Phase 13.1: "Shared base prompt" + Phase 13.2: surface variations | |
| PRD-086 | Enforce shared AI guardrails across all surfaces | critical | full | Phase 13.3: spoiler-safe, domain-only, opinionated, vibe-first | |
| PRD-087 | Make AI warm, joyful, and light in critique | important | partial | "fun, chatty TV/movie nerd friend" stated, but no explicit joy-forward or light-critique guidance | Voice pillars 1 & 3 (joy-forward, light critique) not concretely specified |
| PRD-088 | Structure Scoop as personal taste mini-review | important | full | Phase 10.5: "Personal take → Honest stack-up → The Scoop → Fit/Warnings → Verdict" | |
| PRD-089 | Keep Ask brisk and dialogue-like by default | important | full | Phase 13.2: "Ask: dialogue-like, 1-3 paragraphs + bullet lists" | |
| PRD-090 | Feed AI the right surface-specific context inputs | important | full | Phase 7.3: library context + history; Phase 8: multi-show context | |
| PRD-091 | Validate discovery with rubric and hard-fail integrity | important | partial | No explicit QA/validation rubric planned for discovery quality | No plan for rubric scoring or hard-fail integrity checks |
| PRD-092 | Show person gallery, name, and bio | important | full | Phase 11.1: "Image gallery, name, bio" | |
| PRD-093 | Include ratings, genres, and projects-by-year analytics | important | full | Phase 11.2: "Analytics charts (ratings, genres, projects-by-year)" | |
| PRD-094 | Group filmography by year | important | full | Phase 11.3: "Filmography grouped by year" | |
| PRD-095 | Open Show Detail from selected credit | important | full | Phase 11.4: "Selecting a credit opens that show's Detail" | |
| PRD-096 | Include font size and Search-on-launch settings | important | full | Phase 12.1: font size selector, Search on Launch toggle | |
| PRD-097 | Support username, model, and API-key settings safely | important | full | Phase 12.2-12.4: username, AI key, AI model, catalog key | |
| PRD-098 | Export saved shows and My Data as zip | critical | full | Phase 12.5: "Export My Data → generates .zip with JSON backup" | |
| PRD-099 | Encode export dates using ISO-8601 | important | full | Phase 12.5: "Dates encoded as ISO-8601" | |

## 3. Coverage Scores

```
Critical:  (30 × 1.0 + 0 × 0.5) / 30 × 100 = 100.0%  (30 of 30 critical requirements)
Important: (56 × 1.0 + 11 × 0.5) / 67 × 100 =  91.8%  (61.5 of 67 important requirements)
Detail:    ( 2 × 1.0 + 0 × 0.5) /  2 × 100 = 100.0%  (2 of 2 detail requirements)
Overall:   (88 × 1.0 + 11 × 0.5) / 99 × 100 =  94.4%  (93.5 of 99 total requirements)
```

## 4. Top Gaps

### 1. PRD-091 — Validate discovery with rubric and hard-fail integrity (`important`)

The discovery_quality_bar.md defines a concrete scoring rubric (0–2 per dimension, ≥7/10 passing threshold, Real-Show Integrity = 2 non-negotiable). The plan has no section or phase dedicated to validating AI output quality or running against a rubric. Without this, there is no mechanism to catch hallucinated recommendations, generic concepts, or voice drift before they reach the user.

### 2. PRD-084 — Deliver surprising but defensible taste-aligned recommendations (`important`)

The PRD expects recommendations that are "pleasantly unexpected but defensible" — at least 1–2 recs that surprise while still tracking with the user's taste. The plan addresses taste alignment via concept-based reasoning but does not plan for the surprise dimension. Without deliberate planning here, the system risks producing only safe, genre-adjacent picks that feel generic.

### 3. PRD-077 — Order concepts by strongest aha and varied axes (`important`)

The concept system spec requires ordering by "best 'aha' concepts first" and covering different axes (structure, vibe, emotion, craft) rather than producing synonyms. The plan returns concepts but has no guidance on ordering quality or axis diversity, which risks flat, repetitive concept chips that undermine the alchemy experience.

### 4. PRD-066 — Answer directly with confident, spoiler-safe recommendations (`important`)

The quality bar demands a direct answer within 3–5 lines, bulleted multi-rec lists, and confident picks. The plan covers spoiler-safety and general tone but does not plan for the structural response format (direct answer first, confident stance). This gap could result in verbose, hedging responses that bury the answer.

### 5. PRD-073 — Retry malformed mention output once, then fallback (`important`)

The AI prompting spec defines a specific guardrail: if structured output parsing fails, retry once with stricter formatting, then fall back to unstructured commentary + Search. The plan mentions a provider-agnostic AI layer with a structured showList contract but no explicit retry-and-fallback strategy for malformed AI responses, which could leave the mentioned-shows strip broken on parsing failures.

## 5. Coverage Narrative

#### Overall Posture

This is a structurally strong plan with thorough coverage of infrastructure, data model, UI architecture, and core feature flows. All 30 critical requirements are fully covered — the plan nails the non-negotiables: namespace isolation, Supabase persistence, Supabase official client, environment configuration, dev auth gating, saving triggers, status system, real-show resolution, Scoop persistence, and data continuity. The plan reads like it was written by someone who deeply understands both the technical and product requirements. The gaps are concentrated in the AI quality and behavioral nuance layer — not in the foundation.

#### Strength Clusters

**Infrastructure & Isolation** (17/17 in Benchmark Runtime & Isolation) is comprehensively covered. The multi-tenancy model, namespace partitioning, dev auth injection, migration strategy, and environment configuration are all explicitly planned with concrete implementation details.

**Show Data Model & Persistence** (Collection Data & Persistence area) is remarkably thorough. The schema design captures every required field, the saving triggers and defaults are explicitly documented, the merge strategy with selectFirstNonEmpty is defined, and the data migration approach with dataModelVersion tracking is solid.

**Show Detail & Relationship UX** (14/14 in that area) shows excellent attention to the PRD's narrative hierarchy — all 12 sections are listed in exact PRD order, toolbar placement of relationship controls is explicitly called out, and the auto-save behaviors for tagging and rating unsaved shows are captured.

**Navigation & Discover Shell** is fully planned with a clear route structure, persistent navigation pattern, and three distinct discover modes.

#### Weakness Clusters

The partials concentrate in two related domains:

**AI Quality & Behavioral Contracts** — Approximately two-thirds of the partial scores (PRD-066, PRD-073, PRD-075, PRD-076, PRD-077, PRD-084, PRD-087, PRD-091) cluster around the AI system's behavioral nuance. The plan treats AI as an infrastructure concern (provider abstraction, structured output format, shared guardrails) but under-specifies the product-level behavioral expectations: concept quality filtering, ordering strategy, surprise dimension in recommendations, voice pillar specifics, direct-answer response formatting, and the discovery quality rubric validation. This suggests the plan views AI surfaces primarily as API integration tasks rather than carefully designed user experiences with quality gates.

**Settings & Sync Granularity** — A smaller cluster (PRD-033, PRD-035) addresses the finer details of settings persistence, local state management, and duplicate merge strategy. These are acknowledged at a structural level but lack the concrete key-level planning the catalog requires.

#### Risk Assessment

If this plan were executed as-is, the most likely failure mode would be: **the AI surfaces would technically function but would feel flat and generic**. A QA reviewer would notice that concept chips produce repetitive or generic suggestions ("good characters," "great story"), recommendations lack the "aha" surprise factor, Ask responses are verbose and hedge-y rather than direct and confident, and there is no quality validation mechanism to catch these regressions. The infrastructure works — namespace isolation, persistence, routing — but the product's differentiator (the AI-powered discovery experience) would under-deliver on its emotional promise. Users would get a competent library app with an AI bolt-on, rather than the "taste-aware, joy-forward, surprising-but-defensible" experience the PRD envisions.

#### Remediation Guidance

The weakness clusters point to the need for **surface-specific behavioral specification**, not architectural redesign. The plan needs:

1. **AI quality gate definition** — A dedicated section or sub-phase that defines how AI output will be validated against the discovery quality bar (rubric scoring, hard-fail integrity checks, golden set considerations). This is not a new API surface; it is acceptance criteria for existing AI phases.

2. **Concept system quality spec** — More detailed guidance on concept generation: filtering out generic concepts, ordering by strength, ensuring axis diversity across the 6 taxonomy dimensions from the concept system spec. This should live as explicit constraints in the AI route handler specifications.

3. **Response format contracts per surface** — Concrete response shape expectations (e.g., Ask: direct answer within 3–5 lines; recommendations: surprise + defensible mix) should be added to each AI phase's task descriptions.

4. **Settings persistence detail** — Expand Phase 12 or add a short section covering local settings keys (fontSize, autoSearch, statusRemovalCount), UI state persistence, and the duplicate merge strategy for cross-device sync.
