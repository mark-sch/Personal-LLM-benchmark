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

---

## 2. Coverage Table

| PRD-ID | Requirement | Severity | Coverage | Evidence | Gap |
| ------ | ----------- | -------- | -------- | -------- | --- |
| PRD-001 | Use Next.js latest stable runtime | critical | full | Executive Summary and Tech Stack table both specify Next.js (latest stable) | |
| PRD-002 | Use Supabase official client libraries | critical | full | Tech Stack: "Supabase (hosted or local)"; lib/supabaseClient.ts planned | |
| PRD-003 | Ship `.env.example` with required variables | critical | full | Section 12 lists complete .env.example with all required variables | |
| PRD-004 | Ignore `.env*` secrets except example | important | partial | Directory structure lists `.gitignore` but does not explicitly describe `.env*` exclusion rules | Plan does not explicitly commit to excluding `.env*` secrets in `.gitignore` |
| PRD-005 | Configure build through env without code edits | critical | full | Section 12 provides full .env.example; "build MUST run by filling in environment variables" | |
| PRD-006 | Keep secrets out of repo and server-only | critical | full | Section 12 separates public and server-only keys; AI proxy keeps API keys server-side | |
| PRD-007 | Provide app, test, reset command scripts | critical | full | Section 10.3 mentions `npm run test:reset`; Vitest and Playwright configs planned; Next.js dev script is standard | |
| PRD-008 | Include repeatable schema evolution artifacts | critical | full | Section 3.3 describes migrations/001_initial_schema.sql and 002_seed_data.sql | |
| PRD-009 | Use one stable namespace per build | critical | full | Section 8.1: "Each build receives a stable namespace_id" | |
| PRD-010 | Isolate namespaces and scope destructive resets | critical | full | Section 8.2: RLS policies, query filters, and `DELETE FROM shows WHERE namespace_id = ?` | |
| PRD-011 | Attach every user record to `user_id` | critical | full | Data model: `user_id` (text, required, indexed) on all tables | |
| PRD-012 | Partition persisted data by namespace and user | critical | full | "All persisted data is scoped to `(namespace_id, user_id)`"; RLS policies enforce this | |
| PRD-013 | Support documented dev auth injection, prod-gated | important | full | Section 7.1: X-User-Id header or fixed default user; "clearly documented in README; gated for production" | |
| PRD-014 | Real OAuth later needs no schema redesign | important | full | Section 7.2: "Replacing dev identity with real OAuth requires only auth wiring changes, not schema redesign" | |
| PRD-015 | Keep backend as persisted source of truth | critical | full | Executive Summary: "All user data persists server-side"; data model uses Supabase | |
| PRD-016 | Make client cache safe to discard | critical | partial | Mentions "Clients MAY use caching for performance" but never explicitly states cache is disposable | Plan assumes server-side truth but does not explicitly commit to safe cache discard |
| PRD-017 | Avoid Docker requirement for cloud-agent compatibility | important | full | Tech Stack: "Supabase (hosted or local; Docker not required)" | |
| PRD-018 | Overlay saved user data on every show appearance | critical | full | Section 5.3: "merge stored user data with fresh catalog data → return unified Show" | |
| PRD-019 | Support visible statuses plus hidden `Next` | important | partial | Data model enum lacks `next`; open questions ask if Next should become first-class | Data model does not include the hidden `Next` status required by the PRD |
| PRD-020 | Map Interested/Excited chips to Later interest | critical | full | Section 5.3: "Interested/Excited map to Later + Interest" | |
| PRD-021 | Support free-form multi-tag personal tag library | important | full | Data model: `my_tags` (text[]); Section 5.1: "Tag filters are dynamically derived from the user's tag library" | |
| PRD-022 | Define collection membership by assigned status | critical | full | Data model uses `my_status`; Section 5.3: "Selecting a status saves the show" | |
| PRD-023 | Save shows from status, interest, rating, tagging | critical | full | Section 5.3 explicitly lists all four saving triggers with behavior | |
| PRD-024 | Default save to Later/Interested except rating-save Done | critical | full | Section 5.3: "Default status: Later, Default interest: Interested. Exception: First save via rating defaults status to Done" | |
| PRD-025 | Removing status deletes show and all My Data | critical | full | Section 5.3: "confirming removes the show and clears all My Data" | |
| PRD-026 | Re-add preserves My Data and refreshes public data | critical | full | Section 9.3 merge policy and timestamp-wins logic | |
| PRD-027 | Track per-field My Data modification timestamps | critical | full | Data model has `my_*_updated_at` fields for all user data | |
| PRD-028 | Use timestamps for sorting, sync, freshness | important | full | Section 5.1: "Sort within groups: recently updated first"; Section 9.3: "timestamp-wins for user fields" | |
| PRD-029 | Persist Scoop only for saved shows, 4h freshness | critical | full | Section 5.3: "Only persisted if the show is in collection; otherwise ephemeral. Cached for ~4 hours" | |
| PRD-030 | Keep Ask and Alchemy state session-only | important | full | Section 5.2.2: "Session-only persistence"; Section 5.2.3: "Results are session-only" | |
| PRD-031 | Resolve AI recommendations to real selectable shows | critical | full | Section 5.2.2: "resolves each to catalog items"; Section 5.2.3: "Each rec attempts catalog resolution" | |
| PRD-032 | Show collection and rating tile indicators | important | full | Section 5.1: "ShowTile — poster + title + My Data badges (in-collection dot, rating star)" | |
| PRD-033 | Sync libraries/settings consistently and merge duplicates | important | partial | `cloud_settings` has version field but no sync mechanism or duplicate merge logic described | Plan acknowledges sync but does not describe the sync protocol or duplicate merge behavior |
| PRD-034 | Preserve saved libraries across data-model upgrades | critical | partial | `app_metadata` table tracks `data_model_version` but no migration strategy is described | Version field exists but no upgrade/migration path is planned; risk of data loss on schema change |
| PRD-035 | Persist synced settings, local settings, UI state | important | partial | `cloud_settings` covers synced; local settings and UI state storage location not specified | Plan does not describe where local settings (fontSize, autoSearch) or UI state are persisted |
| PRD-036 | Keep provider IDs persisted and detail fetches transient | important | full | Data model: `provider_data` (jsonb); Section 9.2: "Transient data (cast, crew, seasons...) fetched for UI but not persisted" | |
| PRD-037 | Merge catalog fields safely and maintain timestamps | critical | full | Section 9.3: "selectFirstNonEmpty(new, old) for non-user fields, timestamp-wins for user fields" | |
| PRD-038 | Provide filters panel and main screen destinations | important | full | Section 5.1 describes FilterPanel; directory structure shows routes for Home, Find, Show, Person, Settings | |
| PRD-039 | Keep Find/Discover in persistent primary navigation | important | full | Section 5.2: "Find / Discover Hub" as dedicated page route | |
| PRD-040 | Keep Settings in persistent primary navigation | important | full | `settings/page.tsx` in directory structure | |
| PRD-041 | Offer Search, Ask, Alchemy discover modes | important | full | Section 5.2 describes ModeSwitcher with Search, Ask, Alchemy tabs | |
| PRD-042 | Show only library items matching active filters | important | full | Section 5.1: "Server Action: fetchShows(namespaceId, userId, filters) → queries Supabase with filters" | |
| PRD-043 | Group home into Active, Excited, Interested, Others | important | full | Section 5.1 lists exact groups: Active, Excited, Interested, Other | |
| PRD-044 | Support All, tag, genre, decade, score, media filters | important | full | Section 5.1: "FilterPanel — sidebar with: All Shows, tag filters, genre/decade/score filters, media-type toggle" | |
| PRD-045 | Render poster, title, and My Data badges | important | full | Section 5.1: "ShowTile — poster + title + My Data badges" | |
| PRD-046 | Provide empty-library and empty-filter states | detail | partial | Section 5.1 mentions "EmptyState — prompt to Search/Ask when collection is empty" | Empty-filter state ("No results found.") is not mentioned |
| PRD-047 | Search by title or keywords | important | full | Section 5.2.1: "SearchInput — debounced text input" calling `searchCatalog(query)` | |
| PRD-048 | Use poster grid with collection markers | important | full | Section 5.2.1: "SearchResultsGrid — poster grid" with "in-collection indicator" | |
| PRD-049 | Auto-open Search when setting is enabled | detail | full | Section 5.2.1: "Auto-open on launch if autoSearch setting is true" | |
| PRD-050 | Keep Search non-AI in tone | important | partial | Search is described as catalog text search with no AI involvement | Plan never explicitly states Search should have no AI voice; this is architectural inference, not product commitment |
| PRD-051 | Preserve Show Detail narrative section order | important | full | Section 5.3 lists 12 sections in exact PRD order | |
| PRD-052 | Prioritize motion-rich header with graceful fallback | important | full | Section 5.3: "Header Media carousel with graceful fallback" | |
| PRD-053 | Surface year, runtime/seasons, and community score early | important | full | Section 5.3: "CoreFacts — year, runtime/seasons, community score bar" as section 2 | |
| PRD-054 | Place status/interest controls in toolbar | important | full | Section 5.3: "MyRelationshipToolbar — status chips, rating bar, tag display" as section 3 | |
| PRD-055 | Auto-save unsaved tagged show as Later/Interested | critical | full | Section 5.3: "adding a tag to an unsaved show auto-saves as Later + Interested" | |
| PRD-056 | Auto-save unsaved rated show as Done | critical | full | Section 5.3: "rating an unsaved show auto-saves as Done" | |
| PRD-057 | Show overview early for fast scanning | important | full | Section 5.3: "Overview + ScoopToggle" as section 4 | |
| PRD-058 | Scoop shows correct states and progressive feedback | important | full | Section 5.3: toggle copy covers all three states; "Generated on demand via AI; streams progressively" | |
| PRD-059 | Ask-about-show deep-link seeds Ask context | important | partial | Section 5.3 lists "AskAboutThisShow CTA" but does not describe context seeding | Detail page section omits the handoff behavior; AI section mentions show context inclusion but not the deep-link mechanism |
| PRD-060 | Include traditional recommendations strand | important | full | Section 5.3: "TraditionalRecommendations — strand of similar/recommended shows from catalog" | |
| PRD-061 | Explore Similar uses CTA-first concept flow | important | full | Section 5.3: "Get Concepts" → concepts as selectable chips → "Explore Shows" for 5 recs | |
| PRD-062 | Include streaming availability and person-linking credits | important | full | Section 5.3: "StreamingAvailability" and "CastCrewStrands — horizontal person tiles → navigates to Person Detail" | |
| PRD-063 | Gate seasons to TV and financials to movies | important | full | Section 5.3: "Seasons (TV only)" and "BudgetRevenue (movies when available)" | |
| PRD-064 | Keep primary actions early and page not overwhelming | important | partial | Section order places primary actions early but plan does not explicitly address "not overwhelming" as a design goal | The page ordering is correct but the plan lacks explicit busyness constraints or density guidelines |
| PRD-065 | Provide conversational Ask chat interface | important | full | Section 5.2.2: ChatPanel, ChatInput, MentionedShowsStrip, StarterPrompts | |
| PRD-066 | Answer directly with confident, spoiler-safe recommendations | important | full | Section 6.2: "picks favorites; adapts depth to question"; Section 6.3: "Spoiler-safe by default" | |
| PRD-067 | Show horizontal mentioned-shows strip from chat | important | full | Section 5.2.2: "MentionedShowsStrip — horizontal scroll of shows mentioned in the last AI response" | |
| PRD-068 | Open Detail from mentions or Search fallback | important | full | Section 5.2.2: "resolves each to catalog items, renders as selectable tiles"; Section 6.3 fallback to Search | |
| PRD-069 | Show six random starter prompts with refresh | important | full | Section 5.2.2: "StarterPrompts — 6 random starter prompts, refreshable" | |
| PRD-070 | Summarize older turns while preserving voice | important | full | Section 5.2.2: "after ~10 turns, compress older turns into 1-2 sentences preserving tone" | |
| PRD-071 | Seed Ask-about-show sessions with show handoff | important | full | Section 6.4: "Current show context for 'Ask about this show' and Scoop" | |
| PRD-072 | Emit `commentary` plus exact `showList` contract | critical | full | Section 5.2.2: "AI returns structured response: commentary + optional showList"; Section 6.2 table confirms JSON format | |
| PRD-073 | Retry malformed mention output once, then fallback | important | full | Section 6.3: "retry once with stricter formatting, then fall back to unstructured + search handoff" | |
| PRD-074 | Redirect Ask back into TV/movie domain | important | full | Section 6.3: "All AI surfaces stay within TV/movies; redirect if asked otherwise" | |
| PRD-075 | Treat concepts as taste ingredients, not genres | important | full | Section 6.2: "Extract vibe/structure/emotion ingredients"; aligns with concept system philosophy | |
| PRD-076 | Return bullet-only, 1-3 word, non-generic concepts | important | full | Section 6.2: "Bullet list, 1-3 words each, no explanation"; Section 6.3: "avoid generic concepts" | |
| PRD-077 | Order concepts by strongest aha and varied axes | important | partial | Plan describes concept generation but does not specify ordering by strength or axis diversity | Plan omits explicit ordering rules for concept generation |
| PRD-078 | Require concept selection and guide ingredient picking | important | partial | Plan describes selectable concept chips but does not describe user guidance or nudging to select concepts | Missing UX guidance like "pick the ingredients you want more of" in the plan |
| PRD-079 | Return exactly five Explore Similar recommendations | important | full | Section 5.3: "'Explore Shows' returns 5 AI recs tied to real catalog items" | |
| PRD-080 | Support full Alchemy loop with chaining | important | full | Section 5.2.3: InputShowSelector → ConceptCatalystGrid → AlchemyResults → ChainAction "More Alchemy!" | |
| PRD-081 | Clear downstream results when inputs change | important | full | Section 5.2.3: "Changing input shows clears concepts and results. Selecting/unselecting concepts clears downstream results" | |
| PRD-082 | Generate shared multi-show concepts with larger option pool | important | partial | Plan describes multi-show concept generation but does not specify a larger pool than single-show | No differentiation in concept pool size between single-show and multi-show generation |
| PRD-083 | Cite selected concepts in concise recommendation reasons | important | full | Section 5.2.3: "Reasons must explicitly name which concepts align"; Section 6.2: "reasons should explicitly reflect the selected concepts" | |
| PRD-084 | Deliver surprising but defensible taste-aligned recommendations | important | partial | Plan mentions taste-aware AI but does not explicitly target surprise or defensibility in recommendations | The "surprising but defensible" quality bar is not explicitly addressed in the AI strategy |
| PRD-085 | Keep one consistent AI persona across surfaces | important | full | Section 6.2: "All prompts share a base system persona"; Section 6.1: single AI proxy | |
| PRD-086 | Enforce shared AI guardrails across all surfaces | critical | full | Section 6.3 lists spoiler-safe, opinionated, vibe-first, domain-restriction guardrails | |
| PRD-087 | Make AI warm, joyful, and light in critique | important | full | Section 6.2: "fun, chatty TV/movie nerd friend"; Section 6.3: "acknowledge mixed reception, don't gush for no reason" | |
| PRD-088 | Structure Scoop as personal taste mini-review | important | full | Section 6.2: "Mini blog-post of taste: personal take, honest stack-up, emotional centerpiece, fit/warnings, verdict" | |
| PRD-089 | Keep Ask brisk and dialogue-like by default | important | full | Section 6.2: "Conversational friend; picks favorites; adapts depth to question"; Section 5.2.2: "respond like a friend in dialogue" | |
| PRD-090 | Feed AI the right surface-specific context inputs | important | full | Section 6.4: "User's library, Current show context, Selected concepts, Recent conversation turns" | |
| PRD-091 | Validate discovery with rubric and hard-fail integrity | important | missing | Testing strategy covers merge, mapping, parsing, grouping but not discovery quality validation | No plan for validating AI discovery output quality against the rubric |
| PRD-092 | Show person gallery, name, and bio | important | full | Section 5.4: "Image gallery, name, bio" | |
| PRD-093 | Include ratings, genres, and projects-by-year analytics | important | full | Section 5.4: "Analytics charts: average project ratings, top genres, projects-by-year" | |
| PRD-094 | Group filmography by year | important | full | Section 5.4: "Filmography grouped by year" | |
| PRD-095 | Open Show Detail from selected credit | important | full | Section 5.4: "click credit → Show Detail" | |
| PRD-096 | Include font size and Search-on-launch settings | important | full | Section 5.5: "Appearance: font size selector (XS to XXL), search-on-launch toggle" | |
| PRD-097 | Support username, model, and API-key settings safely | important | full | Section 5.5 covers all three; PRD cross-cutting rule 7 says keys "must never be committed to the repo" | |
| PRD-098 | Export saved shows and My Data as zip | critical | full | Section 5.5: "Export My Data → .zip containing JSON backup of all saved shows" | |
| PRD-099 | Encode export dates using ISO-8601 | important | full | Section 5.5: "(ISO-8601 dates)" explicitly stated | |

---

## 3. Coverage Scores

**Overall score:**

```
score = (full_count × 1.0 + partial_count × 0.5) / total_count × 100
score = (83 × 1.0 + 15 × 0.5 + 1 × 0) / 99 × 100 = 91.4%
```

**Score by severity tier:**

```
Critical:  (28 × 1.0 + 2 × 0.5) / 30 × 100 = 96.7%  (28 of 30 critical requirements)
Important: (54 × 1.0 + 12 × 0.5 + 1 × 0) / 67 × 100 = 89.6%  (54 of 67 important requirements)
Detail:    (1 × 1.0 + 1 × 0.5) / 2 × 100 = 75.0%  (1 of 2 detail requirements)
Overall:   91.4% (83 full, 15 partial, 1 missing of 99 total requirements)
```

---

## 4. Top Gaps

1. **PRD-034 | `critical` | Preserve saved libraries across data-model upgrades**
   The plan includes an `app_metadata` table with a `data_model_version` field, but it does not describe any migration strategy, schema evolution path, or data transformation logic for upgrading existing user data. Without this, a schema change could silently orphan or destroy user collections.

2. **PRD-016 | `critical` | Make client cache safe to discard**
   The plan correctly designs for server-side persistence but never explicitly states that client-side cache is disposable. In a Next.js app with SWR/React Query, developers might inadvertently treat local cache as authoritative during offline moments or optimistic updates, violating the PRD's backend-first contract.

3. **PRD-091 | `important` | Validate discovery with rubric and hard-fail integrity**
   The testing strategy covers unit tests for merge logic, mapping, parsing, and grouping, plus E2E tests for journeys. It completely omits any validation of AI discovery quality — no rubric-based scoring, no golden-set regression tests, no hard-fail integrity checks for hallucinated recommendations. The product could ship with poor AI output quality and no automated signal.

4. **PRD-019 | `important` | Support visible statuses plus hidden `Next`**
   The data model's `my_status` enum (`active | later | wait | done | quit`) omits the `Next` status entirely. The PRD specifies `Next` as an optional/hidden status present in the data model. Leaving it out means the "up-next" queue concept cannot be implemented later without a schema change.

5. **PRD-035 | `important` | Persist synced settings, local settings, UI state**
   While `cloud_settings` covers synced data, the plan does not specify where local-only settings (font size, auto-search) or UI state (last selected filter, removal confirmation preferences) are stored. This gap could lead to inconsistent settings persistence or loss of user preferences across sessions.

---

## 5. Coverage Narrative

### Overall Posture

This is a structurally sound plan with strong coverage of the core product and infrastructure requirements. At 91.4% overall and 96.7% on critical items, the plan demonstrates a solid understanding of the PRD's intent. Most gaps are in refinement areas — polish, validation, and edge-case persistence — rather than fundamental architectural omissions. The plan is executable as-is for an MVP, but the missing discovery-quality validation and data-model upgrade path represent real risks that should be addressed before production commitment.

### Strength Clusters

The plan is strongest in **Benchmark Runtime & Isolation** and **Show Detail & Relationship UX**. Namespace isolation, user_id partitioning, RLS policies, and the dev auth injection mechanism are all thoroughly specified. The Show Detail page preserves the exact narrative hierarchy from the PRD, with every section accounted for in the correct order and all auto-save rules explicitly stated. The **AI integration strategy** is also well-covered: guardrails, structured output contracts, retry logic, and surface-specific prompts are all documented.

### Weakness Clusters

Gaps concentrate in three areas:

1. **Data persistence edge cases**: The plan handles the happy path of saving, merging, and retrieving data well, but stumbles on cache disposal, data-model upgrades, and local/UI state storage. These are all "what happens when things change" scenarios.

2. **Concept/Alchemy UX refinement**: Several requirements around concept ordering, user guidance during selection, and multi-show pool sizing are only partially addressed. The plan describes the mechanics but not the craft of the concept experience.

3. **Quality validation**: The most significant cluster is the complete absence of discovery quality validation. The plan treats AI output as deterministic plumbing to be tested at the parser level, but not as a product surface whose quality must be measured and guarded.

### Risk Assessment

If executed as-is, the most likely first failure is **inconsistent or poor-quality AI recommendations**. Without a validation rubric or golden-set tests, the AI surfaces could ship with generic concepts, off-brand voice, or hallucinated titles — and the team would have no automated way to detect regression. Users would notice this immediately in Ask and Alchemy, eroding trust in the app's core discovery value proposition.

The second likely failure is **data loss during schema evolution**. When the team inevitably needs to add a field or change an enum, the absence of a migration strategy could destroy user collections. This would be a catastrophic breach of the "Your data is yours" product principle.

### Remediation Guidance

For the data persistence gaps, the plan needs **explicit acceptance criteria** around cache behavior and a **migration framework design** (not just a version field). For the concept/Alchemy gaps, the plan needs **UX specification** — not just what the components are, but how they guide the user and what the empty/loading/error states feel like. For the quality validation gap, the plan needs an entirely new section: **AI output quality testing** — rubric-based evaluation, golden-set regression tests, and possibly automated prompt-evaluation pipelines. This is the highest-value planning work remaining.
