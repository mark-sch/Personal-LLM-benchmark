# Plan Coverage Evaluation

## 1. Requirements Extraction

### Pass 1: Functional Areas

1. Collection Core Model & My Data
2. Save/Remove/Merge Lifecycle
3. Identity, Isolation, and Data Ownership
4. Navigation, Home, Filters, and Search
5. Show Detail Experience
6. Person Detail, Settings, and Backup
7. AI Shared Voice, Safety, and Guardrails
8. Ask Chat Structured Contracts
9. Concepts, Explore Similar, and Alchemy
10. Storage Schema, Mapping, and Merge Mechanics

### Pass 2: Extract Requirements Within Each Area

#### Collection Core Model & My Data
- PRD-001 | `important` | Canonical show stores catalog data plus user overlay | `showbiz_prd.md > 4.1 Show (Movie or TV)`
- PRD-002 | `critical` | User-overlaid version always displayed; user edits take precedence | `showbiz_prd.md > 4.1 Show (Movie or TV)`
- PRD-003 | `important` | Status model includes core statuses and hidden Next | `showbiz_prd.md > 4.2 Status System (“My Status”)`
- PRD-004 | `critical` | Interested/Excited chips map to Later with matching interest | `showbiz_prd.md > 4.2 Status System (“My Status”)`
- PRD-005 | `detail` | Interest applies only when status is Later | `showbiz_prd.md > 4.3 Interest Levels (“My Interest”)`
- PRD-006 | `important` | Tags power organization; tiles surface collection and rating badges | `showbiz_prd.md > 4.4 Tags (User Lists)`

#### Save/Remove/Merge Lifecycle
- PRD-007 | `important` | Collection membership is defined by assigned status | `showbiz_prd.md > 5.1 Collection Membership`
- PRD-008 | `critical` | Status/interest/rating/tag actions on unsaved shows auto-save | `showbiz_prd.md > 5.2 Saving Triggers`
- PRD-009 | `critical` | Default save rules: Later+Interested; rating-first saves as Done | `showbiz_prd.md > 5.3 Default Values When Saving`
- PRD-010 | `critical` | Clearing status removes show and clears all My Data | `showbiz_prd.md > 5.4 Removing from Collection`
- PRD-011 | `important` | Status removal requires warning with optional suppression | `showbiz_prd.md > 5.4 Removing from Collection`
- PRD-012 | `critical` | Re-adding show preserves user fields and refreshes public metadata | `showbiz_prd.md > 5.5 Re-adding the Same Show`
- PRD-013 | `critical` | Per-field update timestamps drive sorting, merges, and freshness | `showbiz_prd.md > 5.6 Timestamps`
- PRD-014 | `critical` | Upgrades must migrate data without user-library loss | `showbiz_prd.md > 5.11 Data Continuity Across Versions`

#### Identity, Isolation, and Data Ownership
- PRD-015 | `critical` | All user-owned records are explicitly scoped by user_id | `showbiz_prd.md > 8. Cross-Cutting Rules & Principles`
- PRD-016 | `critical` | Every build/run uses stable namespace isolation | `showbiz_prd.md > 8. Cross-Cutting Rules & Principles`
- PRD-017 | `critical` | Effective partition is namespace_id plus user_id; resets are scoped | `showbiz_infra_rider_prd.md > 4.3 Relationship between namespace and user`
- PRD-018 | `important` | Benchmark auth may inject identity but must be gated/documented | `showbiz_infra_rider_prd.md > 5.1 Auth is not required to be “real” in benchmark mode`
- PRD-019 | `important` | Real OAuth migration must avoid schema redesign | `showbiz_infra_rider_prd.md > 5.2 Migration to real OAuth must be straightforward`
- PRD-020 | `critical` | Backend persistence is source of truth; client cache is disposable | `showbiz_prd.md > 8. Cross-Cutting Rules & Principles`
- PRD-021 | `important` | Optional sync resolves per-field conflicts and merges duplicates | `showbiz_prd.md > 5.10 Data Sync & Integrity`

#### Navigation, Home, Filters, and Search
- PRD-022 | `important` | App structure includes Home/Detail/Find/Person/Settings with persistent entries | `showbiz_prd.md > 6. App Structure & Navigation`
- PRD-023 | `important` | Find/Discover supports Search, Ask, and Alchemy mode switching | `showbiz_prd.md > 6. App Structure & Navigation`
- PRD-024 | `important` | Home groups statuses in required order with media-type toggle | `showbiz_prd.md > 7.1 Collection Home`
- PRD-025 | `important` | Filters include All, tags/No tags, genre, decade, score | `showbiz_prd.md > 4.5 Filters (Ways to View the Collection)`
- PRD-026 | `detail` | Home includes no-library and no-results empty states | `showbiz_prd.md > 7.1 Collection Home`
- PRD-027 | `important` | Search uses title/keyword query, poster grid, and Detail navigation | `showbiz_prd.md > 7.2 Search (Find → Search)`
- PRD-028 | `detail` | Search can auto-open at launch via setting | `showbiz_prd.md > 7.2 Search (Find → Search)`

#### Show Detail Experience
- PRD-029 | `important` | Detail page is source of truth plus discovery launchpad | `detail_page_experience.md > 1. Purpose`
- PRD-030 | `important` | Detail preserves specified section hierarchy/order | `detail_page_experience.md > 3. Narrative Hierarchy (Section Intent)`
- PRD-031 | `detail` | Header media gracefully falls back when rich media missing | `detail_page_experience.md > 3.1 Header Media`
- PRD-032 | `critical` | My relationship controls implement status/rating/tag semantics | `detail_page_experience.md > 3.3 My Relationship Controls`
- PRD-033 | `important` | Scoop UI supports toggle states and progressive generation feedback | `detail_page_experience.md > 3.4 Overview + Scoop`
- PRD-034 | `important` | Scoop refreshes after ~4 hours and persists only if saved | `detail_page_experience.md > 3.4 Overview + Scoop`
- PRD-035 | `important` | Ask-about CTA seeds Ask with current show context | `detail_page_experience.md > 3.5 Ask About This Show`
- PRD-036 | `important` | Explore Similar flow is concepts selection to recommendation fetch | `detail_page_experience.md > 3.7 Explore Similar (Concept Discovery)`
- PRD-037 | `important` | Detail includes traditional recs and streaming availability | `showbiz_prd.md > 7.5 Show Detail Page`
- PRD-038 | `important` | Cast/Crew interactions deep-link into Person detail | `showbiz_prd.md > 7.5 Show Detail Page`
- PRD-039 | `detail` | Seasons and budget/revenue sections are media-type conditional | `showbiz_prd.md > 7.5 Show Detail Page`

#### Person Detail, Settings, and Backup
- PRD-040 | `important` | Person detail includes gallery, bio, and year-grouped filmography | `showbiz_prd.md > 7.6 Person Detail Page`
- PRD-041 | `important` | Person detail includes analytics and credit-to-detail navigation | `showbiz_prd.md > 4.10 Person (Cast/Crew)`
- PRD-042 | `important` | Settings include readability, launch behavior, identity, and API config | `showbiz_prd.md > 7.7 Settings & Your Data`
- PRD-043 | `critical` | Secrets stay out of repo with env-based configuration interface | `showbiz_infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-044 | `important` | Export creates ZIP with ISO-8601 JSON backup of user data | `showbiz_prd.md > 7.7 Settings & Your Data`

#### AI Shared Voice, Safety, and Guardrails
- PRD-045 | `important` | One consistent AI persona across surfaces; Search is non-AI | `ai_voice_personality.md > 1. Persona Summary`
- PRD-046 | `important` | AI remains in TV/movie domain and redirects off-domain asks | `ai_prompting_context.md > 1. Shared Rules (All AI Surfaces)`
- PRD-047 | `critical` | AI recommendations resolve to real catalog items | `ai_prompting_context.md > 5. Guardrails & Fallbacks`
- PRD-048 | `important` | Unresolved recommendations fall back to non-interactive/Search handoff | `ai_prompting_context.md > 5. Guardrails & Fallbacks`
- PRD-049 | `important` | AI reasoning is specific, vibe/craft-driven, and honestly opinionated | `ai_voice_personality.md > 2. Non-Negotiable Voice Pillars`
- PRD-050 | `important` | Conversation summaries keep persona while compressing old turns | `ai_prompting_context.md > 4. Conversation Summarization (Chat Surfaces)`
- PRD-051 | `important` | Structured parse failures retry once before fallback path | `ai_prompting_context.md > 5. Guardrails & Fallbacks`

#### Ask Chat Structured Contracts
- PRD-052 | `important` | Ask answers quickly in conversational style with confident picks | `ai_prompting_context.md > 3.1 Ask (Chat)`
- PRD-053 | `critical` | Ask mentions contract uses commentary plus strict showList string format | `ai_prompting_context.md > 3.2 Ask with Mentions (Structured “Mentioned Shows”)`
- PRD-054 | `important` | Mentioned-shows strip opens Detail or Search fallback | `showbiz_prd.md > 7.3 Ask (Find → Ask)`
- PRD-055 | `detail` | Ask welcome state shows six random starter prompts with refresh | `showbiz_prd.md > 7.3 Ask (Find → Ask)`
- PRD-056 | `important` | Ask history and mention strip are session-only ephemeral data | `showbiz_prd.md > 5.7 AI Data Persistence`

#### Concepts, Explore Similar, and Alchemy
- PRD-057 | `important` | Concepts are bullet-only, 1-3 words, evocative, spoiler-safe | `ai_prompting_context.md > 3.4 Concepts (Single-Show and Multi-Show)`
- PRD-058 | `important` | Default concept count is 8; multi-show concepts are shared | `discovery_quality_bar.md > 2.3 Concepts`
- PRD-059 | `detail` | Concepts should be diverse across axes and ordered by strength | `concept_system.md > 4. Generation Rules`
- PRD-060 | `important` | Explore Similar/Alchemy return fixed rec counts with concept-linked reasons | `concept_system.md > 6. Concepts → Recommendations Contract`
- PRD-061 | `important` | Alchemy requires 2+ inputs, capped concept selection, and chaining | `showbiz_prd.md > 7.4 Alchemy (Find → Alchemy)`
- PRD-062 | `important` | Upstream selection changes clear downstream concepts/results | `showbiz_prd.md > 7.4 Alchemy (Find → Alchemy)`
- PRD-063 | `critical` | Real-show integrity is non-negotiable in discovery quality scoring | `discovery_quality_bar.md > 4. Scoring Rubric (Quick)`

#### Storage Schema, Mapping, and Merge Mechanics
- PRD-064 | `critical` | Persist full show schema with CloudSettings and AppMetadata versioning | `storage-schema.md > Stored entities (conceptual)`
- PRD-065 | `detail` | Persist local settings and UI-state keys exactly as specified | `storage-schema.md > Other persistent storage (key-value settings)`
- PRD-066 | `important` | External catalog mapping follows type/title/date/genre/image rules | `storage-schema.md > External catalog → Show mapping strategy`
- PRD-067 | `detail` | Transient fetch-only fields remain non-persistent | `storage-schema.md > Not stored (transient)`
- PRD-068 | `critical` | Merge policy uses non-my non-empty preference and my-field timestamps | `storage-schema.md > Merge / overwrite policy (important)`
- PRD-069 | `important` | Merge sets detailsUpdateDate and preserves original creationDate | `storage-schema.md > Merge / overwrite policy (important)`
- PRD-070 | `critical` | Benchmark baseline requires Next.js+Supabase, env-driven runs, no Docker dependency | `showbiz_infra_rider_prd.md > 2. Benchmark Baseline (Current Round)`

Total: 70 requirements (20 critical, 41 important, 9 detail) across 10 functional areas

## 2. Coverage Table

| PRD-ID | Requirement | Severity | Coverage | Evidence | Gap |
| ------ | ----------- | -------- | -------- | -------- | --- |
| PRD-001 | Canonical show stores catalog data plus user overlay | important | full | Context “Store the full schema from storage-schema.ts”; Phase 1.2 `showbiz_shows` full schema |  |
| PRD-002 | User-overlaid version always displayed; user edits take precedence | critical | partial | Context merge emphasis and Home tiles with My Data badges (Phase 3.2) | The plan does not explicitly state a global “user version wins everywhere” rendering rule across all surfaces. |
| PRD-003 | Status model includes core statuses and hidden Next | important | partial | Phase 1.3 status ordering constants; Phase 4.1 status chips | Hidden `Next` presence in the data model is not explicitly planned. |
| PRD-004 | Interested/Excited chips map to Later with matching interest | critical | full | Phase 4.1 “Interested → later+interested, Excited → later+excited” |  |
| PRD-005 | Interest applies only when status is Later | detail | partial | Phase 4.1 and 4.4 define Later+interest mappings | The plan does not state behavior for retaining/ignoring interest when status moves away from Later. |
| PRD-006 | Tags power organization; tiles surface collection and rating badges | important | full | Phase 3.2 filter bar + Phase 1.5 `ShowTile` badges + TagPicker |  |
| PRD-007 | Collection membership is defined by assigned status | important | partial | Phase 4 status flows update status and removal behavior | The plan uses status operationally but does not explicitly codify status as the membership definition. |
| PRD-008 | Status/interest/rating/tag actions on unsaved shows auto-save | critical | full | Phase 4.4 auto-save logic items 1-4 |  |
| PRD-009 | Default save rules: Later+Interested; rating-first saves as Done | critical | full | Phase 4.4 items 1 and 3 |  |
| PRD-010 | Clearing status removes show and clears all My Data | critical | full | Phase 4.5 “Confirm → delete row, clear all My Data” |  |
| PRD-011 | Status removal requires warning with optional suppression | important | full | Phase 4.5 ConfirmationDialog + “don’t ask again” + UIState counters |  |
| PRD-012 | Re-adding show preserves user fields and refreshes public metadata | critical | full | Phase 4.4 item 5 + Phase 2.4 `mergeShows(incoming, existing)` |  |
| PRD-013 | Per-field update timestamps drive sorting, merges, and freshness | critical | partial | Phase 1.2 includes my-field timestamps; Phase 2.4 timestamp merge logic | Sorting and cache-freshness usage are not fully specified, and AI scoop timestamp handling is not explicit in merge strategy text. |
| PRD-014 | Upgrades must migrate data without user-library loss | critical | partial | Phase 1.2 `showbiz_app_metadata` table and migrations | The plan does not define concrete migration/backfill strategy proving zero-loss continuity across schema evolution. |
| PRD-015 | All user-owned records are explicitly scoped by user_id | critical | full | Phase 1.2 composite PK includes `user_id`; Phase 2.2 scoped queries |  |
| PRD-016 | Every build/run uses stable namespace isolation | critical | full | Env includes `NAMESPACE_ID`; Phase 2.2 returns `{ namespaceId, userId }`; all queries scoped |  |
| PRD-017 | Effective partition is namespace_id plus user_id; resets are scoped | critical | full | Phase 2.2 query scoping and `reset-test-data.js` namespace deletion |  |
| PRD-018 | Benchmark auth may inject identity but must be gated/documented | important | partial | Phase 2.2 server-side `getIdentity(request)` helper and env default user | Production gating and explicit documentation requirements are not called out. |
| PRD-019 | Real OAuth migration must avoid schema redesign | important | partial | Schema design includes `user_id` + namespace partitioning | The plan does not explicitly document forward-compat auth boundary decisions for OAuth swap-in. |
| PRD-020 | Backend persistence is source of truth; client cache is disposable | critical | full | Context chooses Supabase persisted source; localStorage limited to settings/UI state (Phase 2.6) |  |
| PRD-021 | Optional sync resolves per-field conflicts and merges duplicates | important | partial | Phase 2 CRUD and merge logic support conflict handling primitives | Sync behavior and duplicate merge strategy across devices are not planned as explicit workflows. |
| PRD-022 | App structure includes Home/Detail/Find/Person/Settings with persistent entries | important | full | Phase 3.1 routing + Phase 1.5 Layout/Navigation components |  |
| PRD-023 | Find/Discover supports Search, Ask, and Alchemy mode switching | important | full | Phase 3.5 `ModeSwitcher`, `SearchMode`, `AskMode`, `AlchemyMode` |  |
| PRD-024 | Home groups statuses in required order with media-type toggle | important | full | Phase 3.2 grouping order and All/Movies/TV toggle |  |
| PRD-025 | Filters include All, tags/No tags, genre, decade, score | important | partial | Phase 3.2 `FilterBar` lists tag/genre/decade/score/status | The explicit `No tags` filter behavior is not mentioned. |
| PRD-026 | Home includes no-library and no-results empty states | detail | full | Phase 3.2 empty states for no collection and no filter results |  |
| PRD-027 | Search uses title/keyword query, poster grid, and Detail navigation | important | full | Phase 3.5 SearchMode “debounced TMDB searchMulti, poster grid, selecting opens Detail” |  |
| PRD-028 | Search can auto-open at launch via setting | detail | full | Phase 3.6 `SearchOnLaunch`; Phase 7 checklist item 13 |  |
| PRD-029 | Detail page is source of truth plus discovery launchpad | important | full | Phase 3.3 “Show Detail (largest feature)” with full section decomposition |  |
| PRD-030 | Detail preserves specified section hierarchy/order | important | full | Phase 3.3 explicitly states “Narrative hierarchy (exact PRD order)” with 13 sections |  |
| PRD-031 | Header media gracefully falls back when rich media missing | detail | partial | Phase 3.3 `HeaderMedia` includes backdrop/poster/logo carousel and trailer | The plan does not explicitly define fallback behavior for missing trailers/backdrops. |
| PRD-032 | My relationship controls implement status/rating/tag semantics | critical | full | Phase 3.3 `MyDataControls` + Phase 4 status/rating/tag auto-save/removal |  |
| PRD-033 | Scoop UI supports toggle states and progressive generation feedback | important | full | Phase 5.4 toggle-state sequence + streaming; Phase 6.2 “Generating...” indicators |  |
| PRD-034 | Scoop refreshes after ~4 hours and persists only if saved | important | full | Phase 1.3 `AI_SCOOP_FRESHNESS_MS (4hrs)` + Phase 5.4 persistence rule |  |
| PRD-035 | Ask-about CTA seeds Ask with current show context | important | full | Phase 3.3 `AskAboutCTA`; Phase 5.5 “Ask about this show context from Show Detail” |  |
| PRD-036 | Explore Similar flow is concepts selection to recommendation fetch | important | full | Phase 5.7 single-show concept extraction -> select -> recommendations |  |
| PRD-037 | Detail includes traditional recs and streaming availability | important | full | Phase 3.3 `RecommendationsStrand` + `StreamingSection` |  |
| PRD-038 | Cast/Crew interactions deep-link into Person detail | important | full | Phase 3.3 `CastCrew`; Phase 3.4 Person route and verification flow item 12 |  |
| PRD-039 | Seasons and budget/revenue sections are media-type conditional | detail | full | Phase 3.3 `SeasonsSection — TV only`, `BudgetRevenue — movies only` |  |
| PRD-040 | Person detail includes gallery, bio, and year-grouped filmography | important | full | Phase 3.4 `PersonHeader`, `ImageGallery`, `Filmography (grouped by year)` |  |
| PRD-041 | Person detail includes analytics and credit-to-detail navigation | important | full | Phase 3.4 analytics charts; Checklist item 12 includes credit -> Detail loop |  |
| PRD-042 | Settings include readability, launch behavior, identity, and API config | important | full | Phase 3.6 settings features `FontSizeSelector`, `SearchOnLaunch`, `UserProfile`, `APIKeys` |  |
| PRD-043 | Secrets stay out of repo with env-based configuration interface | critical | full | Phase 1.1 `.env.example` vars and `.gitignore`; rider-aligned credential notes |  |
| PRD-044 | Export creates ZIP with ISO-8601 JSON backup of user data | important | full | Phase 6.3 Data Export JSON + ISO-8601 + `.zip` |  |
| PRD-045 | One consistent AI persona across surfaces; Search is non-AI | important | full | Phase 5.2 prompts tied to `ai_voice_personality.md`; SearchMode isolated in Phase 3.5 |  |
| PRD-046 | AI remains in TV/movie domain and redirects off-domain asks | important | partial | Phase 5.2 references shared voice/personality prompts | Explicit domain-redirection guardrail is not described in prompt contract/tasks. |
| PRD-047 | AI recommendations resolve to real catalog items | critical | full | Phase 2.5 `resolveShowFromAI`; Phase 5.3 recommendations route resolves each rec via TMDB |  |
| PRD-048 | Unresolved recommendations fall back to non-interactive/Search handoff | important | partial | Phase 5.5/5.3 focus on resolved TMDB items | The plan does not specify UI fallback behavior when mapping fails. |
| PRD-049 | AI reasoning is specific, vibe/craft-driven, and honestly opinionated | important | partial | Phase 5.2 includes style goals and concept-cited reasons | Acceptance checks for anti-generic reasoning and mixed-reception honesty are not explicit. |
| PRD-050 | Conversation summaries keep persona while compressing old turns | important | partial | Phase 5.5 “Conversation summarization after ~10 messages” | The 1-2 sentence constraint and tone-preservation requirement are not specified. |
| PRD-051 | Structured parse failures retry once before fallback path | important | missing | none | No retry-then-fallback behavior is defined for structured parse failures. |
| PRD-052 | Ask answers quickly in conversational style with confident picks | important | full | Phase 5.5 Ask chat features + Phase 5.2 chat prompt style |  |
| PRD-053 | Ask mentions contract uses commentary plus strict showList string format | critical | partial | Phase 5.2 uses `[SHOWS]...[/SHOWS]` custom format; Phase 5.3 parses mentions | The implementation plan chooses a different wire format than the required `showList` schema contract. |
| PRD-054 | Mentioned-shows strip opens Detail or Search fallback | important | partial | Phase 5.5 mentioned shows strip and TMDB resolution | Search handoff path for unresolved mentions is not explicitly planned. |
| PRD-055 | Ask welcome state shows six random starter prompts with refresh | detail | full | Phase 5.5 “Starter prompts on empty chat (6 options), user can refresh” |  |
| PRD-056 | Ask history and mention strip are session-only ephemeral data | important | full | Phase 5.5 Ask session-only; Phase 5.6 Alchemy session-only |  |
| PRD-057 | Concepts are bullet-only, 1-3 words, evocative, spoiler-safe | important | full | Phase 5.2 Concepts prompt: “8 bullets, 1-3 words, evocative, non-generic” |  |
| PRD-058 | Default concept count is 8; multi-show concepts are shared | important | full | Phase 1.3 `CONCEPT_COUNT (8)`; Phase 5.6 conceptualize selected multi-show inputs |  |
| PRD-059 | Concepts should be diverse across axes and ordered by strength | detail | partial | Phase 5.2 includes “ordered by strength” | Diversity-across-axes quality constraint is not explicitly planned/tested. |
| PRD-060 | Explore Similar/Alchemy return fixed rec counts with concept-linked reasons | important | full | Phase 1.3 constants (5 and 6) + Phase 5.2 recommendation reasons cite concepts + 5.6/5.7 flows |  |
| PRD-061 | Alchemy requires 2+ inputs, capped concept selection, and chaining | important | full | Phase 5.6 full flow includes 2+ inputs, 1-8 concepts, More Alchemy chain |  |
| PRD-062 | Upstream selection changes clear downstream concepts/results | important | full | Phase 5.6 “Backtracking clears downstream” |  |
| PRD-063 | Real-show integrity is non-negotiable in discovery quality scoring | critical | full | Phase 5.3 resolves recommendations to TMDB show objects; resolve function in Phase 2.5 |  |
| PRD-064 | Persist full show schema with CloudSettings and AppMetadata versioning | critical | full | Context full-schema decision + Phase 1.2 tables (`showbiz_shows`, `showbiz_cloud_settings`, `showbiz_app_metadata`) |  |
| PRD-065 | Persist local settings and UI-state keys exactly as specified | detail | full | Phase 2.6 `useLocalSettings` and `useUIState` with required keys |  |
| PRD-066 | External catalog mapping follows type/title/date/genre/image rules | important | partial | Phase 2.5 mappers populate all fields and build image URLs | Detailed inference/failure semantics (title fallback, unknown rejection, deterministic logo selection, multi-format date parsing) are not fully specified. |
| PRD-067 | Transient fetch-only fields remain non-persistent | detail | partial | Phase 2.5 mappers and full schema persistence approach | The plan does not explicitly call out transient-field exclusion as a hard persistence rule. |
| PRD-068 | Merge policy uses non-my non-empty preference and my-field timestamps | critical | partial | Phase 2.4 defines both merge strategies | The listed timestamped my-fields do not explicitly include AI Scoop conflict resolution behavior. |
| PRD-069 | Merge sets detailsUpdateDate and preserves original creationDate | important | full | Phase 2.4 “sets detailsUpdateDate to now, preserves creationDate” |  |
| PRD-070 | Benchmark baseline requires Next.js+Supabase, env-driven runs, no Docker dependency | critical | partial | Context/Phase 1.1 enforce Next.js + Supabase + env interface + scripts | Docker-optional/cloud-agent compatibility requirements are not explicitly covered in deliverables/docs. |

## 3. Coverage Scores

Overall score math:

`score = (full_count × 1.0 + partial_count × 0.5) / total_count × 100`

- Full count = 47
- Partial count = 22
- Missing count = 1
- Total count = 70

`Overall = (47 × 1.0 + 22 × 0.5) / 70 × 100 = 82.9%`

Score by severity tier:

- Critical:  `(14 × 1.0 + 6 × 0.5) / 20 × 100 = 85.0%`  `(17.0 of 20 critical requirements)`
- Important: `(28 × 1.0 + 12 × 0.5) / 41 × 100 = 82.9%` `(34.0 of 41 important requirements)`
- Detail:    `(5 × 1.0 + 4 × 0.5) / 9 × 100 = 77.8%`   `(7.0 of 9 detail requirements)`
- Overall:   `82.9% (70 total requirements)`

## 4. Top Gaps

1. **PRD-014 (`critical`) — Upgrades must migrate data without user-library loss**  
   Why it matters: without explicit migration/backfill planning, schema changes can silently drop statuses, tags, ratings, or scoop data during upgrades.

2. **PRD-053 (`critical`) — Ask mentions contract uses strict `showList` format**  
   Why it matters: the plan uses a different serialization shape, which can break mention parsing and UI rendering for recommendation taps.

3. **PRD-068 (`critical`) — Merge policy must include all user-field timestamp rules**  
   Why it matters: incomplete timestamp conflict handling (especially around AI Scoop) risks stale overwrites and inconsistent cross-device behavior.

4. **PRD-013 (`critical`) — Timestamp usage for sorting/conflict/freshness is under-specified**  
   Why it matters: missing explicit consumers of timestamps can cause regressions in recency ordering, sync conflict resolution, and scoop refresh behavior.

5. **PRD-070 (`critical`) — Cloud-agent compatibility and Docker-optional path are not explicit**  
   Why it matters: benchmark execution can fail in constrained CI/cloud agents if Docker assumptions leak into setup or reset workflows.

## 5. Coverage Narrative

The plan is structurally strong and implementable, but not yet benchmark-ready without clarification in a few critical contracts. At 82.9% weighted coverage, it captures the broad product architecture, major flows, and most core behaviors. The remaining risk is less about missing big features and more about under-specified behavior where exact contracts matter.

The strongest coverage clusters are core product surfaces and architecture: collection/home flow, show detail hierarchy, settings/export, and baseline infrastructure scaffolding. The plan is especially concrete in file-level decomposition, data model breadth, and primary user journeys (save, rate-to-save, tag-to-save, ask, alchemy, explore similar). It also does a good job translating the PRD’s feature map into phased implementation tasks with explicit components/hooks.

Gaps cluster around behavioral precision for AI contracts and long-term data integrity. The largest concentration of partial/missing items involves strict interface requirements (Ask mention payload format, parse-failure fallback behavior, unresolved recommendation handoff), nuanced merge/timestamp semantics, and execution-rider constraints like Docker-optional cloud-agent compatibility. These are mostly not random omissions; they are “contract sharpness” gaps where the plan is directionally aligned but not exact.

If executed as-is, the most likely failure mode is integration-level mismatch rather than feature absence. QA would likely first notice flaky or broken mention-strip behavior in Ask (format mismatch/fallback gaps), followed by edge-case data integrity regressions during merges or schema evolution. The remediation needed is primarily specification hardening: tighten acceptance criteria around AI I/O formats and fallback paths, make migration/continuity strategy explicit, and add explicit compliance tasks for rider constraints (especially Docker-optional execution and identity-injection gating).
