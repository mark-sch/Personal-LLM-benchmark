## 1. Requirements Extraction

### Benchmark Runtime & Isolation
- PRD-001 | `critical` | Use Next.js/Supabase baseline without Docker dependency | `infra_rider_prd.md > 2. Benchmark Baseline (Current Round); 8. “Cloud Agent” Compatibility`
- PRD-002 | `critical` | Configure builds through .env.example without code edits | `infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-003 | `critical` | Keep secrets out of repo and server-only | `infra_rider_prd.md > 3.1 Environment variable interface`
- PRD-004 | `critical` | Provide start, test, and namespace-reset scripts | `infra_rider_prd.md > 3.2 One-command developer experience`
- PRD-005 | `important` | Include repeatable database schema evolution artifacts | `infra_rider_prd.md > 3.3 Database evolution artifacts`
- PRD-006 | `critical` | Assign stable namespace ID for each build | `infra_rider_prd.md > 4.1 Build/run namespace (required)`
- PRD-007 | `critical` | Isolate namespaces and scope destructive tests | `infra_rider_prd.md > 4.1 Build/run namespace (required); 7. Destructive Testing Rules`
- PRD-008 | `critical` | Partition all user data by namespace and user | `infra_rider_prd.md > 4.2 User identity (required); 4.3 Relationship between namespace and user`
- PRD-009 | `important` | Support dev identity now, OAuth later | `infra_rider_prd.md > 5. Authentication Policy (Benchmark-Friendly)`
- PRD-010 | `critical` | Keep server data authoritative over client caches | `infra_rider_prd.md > 6. Data Ownership & Local Storage`

### Persistent Data & Sync
- PRD-011 | `critical` | Persist show identity, metadata, and user overlay | `product_prd.md > 4.1 Show (Movie or TV); storage-schema.md > Show (movie or TV series)`
- PRD-012 | `important` | Store provider availability as regional provider IDs | `storage-schema.md > ProviderData (embedded in Show)`
- PRD-013 | `important` | Keep credits/videos/recs transient, not persisted | `storage-schema.md > Show (movie or TV series); Field mapping rules (conceptual)`
- PRD-014 | `important` | Persist cloud settings plus local/UI state | `storage-schema.md > CloudSettings (optional synced settings); Local settings; UI state`
- PRD-015 | `important` | Map catalog fields into stored show semantics | `storage-schema.md > Field mapping rules (conceptual)`
- PRD-016 | `critical` | Merge public fields without blank overwrites | `storage-schema.md > Merge / overwrite policy (important)`
- PRD-017 | `critical` | Resolve user-field conflicts by newest timestamp | `product_prd.md > 5.5 Re-adding the Same Show; 5.6 Timestamps; storage-schema.md > Merge / overwrite policy (important)`
- PRD-018 | `important` | Define collection membership by assigned status | `product_prd.md > 5.1 Collection Membership`
- PRD-019 | `critical` | Save on status, interest, rating, or tag | `product_prd.md > 5.2 Saving Triggers`
- PRD-020 | `critical` | Default saves to Later/Interested except rating | `product_prd.md > 5.3 Default Values When Saving`
- PRD-021 | `critical` | Clear status by deleting show and My Data | `product_prd.md > 5.4 Removing from Collection; detail_page_experience.md > 3.3 My Relationship Controls`
- PRD-022 | `critical` | Re-adding shows preserves My Data on refresh | `product_prd.md > 5.5 Re-adding the Same Show`
- PRD-023 | `important` | Persist Scoop only; Ask/Alchemy stay session-only | `product_prd.md > 4.9 AI Scoop (“The Scoop”); 5.7 AI Data Persistence`
- PRD-024 | `critical` | Resolve AI recs to real shows or fallback | `product_prd.md > 5.8 AI Recommendations Map to Real Shows; ai_prompting_context.md > 5. Guardrails & Fallbacks`
- PRD-025 | `important` | Show collection and rating tile badges | `product_prd.md > 5.9 Tile Indicators`
- PRD-026 | `critical` | Preserve synced data across conflicts and upgrades | `product_prd.md > 5.10 Data Sync & Integrity; 5.11 Data Continuity Across Versions`

### Navigation & Global Structure
- PRD-027 | `important` | Use navigation plus main-content app structure | `product_prd.md > 6. App Structure & Navigation`
- PRD-028 | `important` | Keep Find and Settings persistently reachable | `product_prd.md > 6. App Structure & Navigation`
- PRD-029 | `important` | Provide Search, Ask, Alchemy hub switching | `product_prd.md > 6. App Structure & Navigation; 7.2 Search (Find → Search); 7.7 Settings & Your Data`

### Collection Home & Search
- PRD-030 | `critical` | Show filtered library grouped by relationship | `product_prd.md > 7.1 Collection Home`
- PRD-031 | `important` | Group Home into Active, Excited, Interested, Other | `product_prd.md > 7.1 Collection Home`
- PRD-032 | `detail` | Render Active items with more prominence | `product_prd.md > 7.1 Collection Home`
- PRD-033 | `important` | Support All, Movies, and TV filters | `product_prd.md > 4.5 Filters (Ways to View the Collection); 7.1 Collection Home`
- PRD-034 | `important` | Support tag, no-tag, genre, decade, score filters | `product_prd.md > 4.5 Filters (Ways to View the Collection); 7.1 Collection Home`
- PRD-035 | `important` | Show poster, title, and My Data badges | `product_prd.md > 7.1 Collection Home`
- PRD-036 | `important` | Handle empty library and empty filter states | `product_prd.md > 7.1 Collection Home`
- PRD-037 | `critical` | Search catalog by text into poster grid | `product_prd.md > 7.2 Search (Find → Search)`
- PRD-038 | `important` | Mark saved results and open Detail on tap | `product_prd.md > 7.2 Search (Find → Search); ai_voice_personality.md > 1. Persona Summary`

### Show Detail & Relationship Controls
- PRD-039 | `important` | Preserve Show Detail narrative section order | `product_prd.md > 7.5 Show Detail Page; detail_page_experience.md > 3. Narrative Hierarchy (Section Intent)`
- PRD-040 | `important` | Use rich header media with graceful fallback | `detail_page_experience.md > 3.1 Header Media`
- PRD-041 | `important` | Surface core facts and score near top | `detail_page_experience.md > 2. First-15-Seconds Experience; 3.2 Core Facts + Community Score`
- PRD-042 | `critical` | Keep status chips in toolbar with mapping | `product_prd.md > 4.2 Status System (“My Status”); detail_page_experience.md > 3.3 My Relationship Controls`
- PRD-043 | `critical` | Confirm status reselect removal and clear data | `detail_page_experience.md > 3.3 My Relationship Controls; product_prd.md > 5.4 Removing from Collection`
- PRD-044 | `critical` | Auto-save unsaved ratings and tag additions | `product_prd.md > 7.5 Show Detail Page; detail_page_experience.md > 3.3 My Relationship Controls`
- PRD-045 | `detail` | Keep overview early and Scoop copy stateful | `detail_page_experience.md > 2. First-15-Seconds Experience; 3.4 Overview + Scoop`
- PRD-046 | `important` | Stream Scoop visibly and persist only if saved | `detail_page_experience.md > 3.4 Overview + Scoop; 5. Critical States; ai_prompting_context.md > 3.3 Scoop (Detail Page)`
- PRD-047 | `important` | Seed Ask with current show context | `product_prd.md > 7.3 Ask (Find → Ask); detail_page_experience.md > 3.5 Ask About This Show`
- PRD-048 | `important` | Include recs, Explore Similar, streaming, cast links | `product_prd.md > 7.5 Show Detail Page; detail_page_experience.md > 3.6 Traditional Recommendations Strand; 3.7 Explore Similar (Concept Discovery); 3.8 Streaming Availability; 3.9 Cast, Crew, Seasons, Budget/Revenue`
- PRD-049 | `important` | Handle TV/movie-only sections and concept CTA states | `product_prd.md > 7.5 Show Detail Page; detail_page_experience.md > 5. Critical States`

### Person Detail
- PRD-050 | `important` | Show gallery, bio, and year-grouped filmography | `product_prd.md > 4.10 Person (Cast/Crew); 7.6 Person Detail Page`
- PRD-051 | `important` | Include person analytics charts | `product_prd.md > 7.6 Person Detail Page`
- PRD-052 | `important` | Open Show Detail from any credit | `product_prd.md > 4.10 Person (Cast/Crew); 7.6 Person Detail Page`

### Ask Chat & Mentioned Shows
- PRD-053 | `important` | Use chat UI with refreshable starter prompts | `product_prd.md > 7.3 Ask (Find → Ask)`
- PRD-054 | `important` | Summarize older chat turns in persona voice | `product_prd.md > 7.3 Ask (Find → Ask); ai_prompting_context.md > 4. Conversation Summarization (Chat Surfaces)`
- PRD-055 | `critical` | Return structured commentary plus exact showList | `ai_prompting_context.md > 3.2 Ask with Mentions (Structured “Mentioned Shows”)`
- PRD-056 | `important` | Render mentioned shows strip with Detail/Search handoff | `product_prd.md > 4.6 AI Chat Session (“Ask”); 7.3 Ask (Find → Ask)`
- PRD-057 | `important` | Retry Ask parse failures before final fallback | `ai_prompting_context.md > 5. Guardrails & Fallbacks`
- PRD-058 | `important` | Answer Ask directly and list multiple recommendations | `ai_prompting_context.md > 3.1 Ask (Chat); discovery_quality_bar.md > 2.2 Ask / Explore Search Chat; ai_voice_personality.md > 4.2 Ask (Find → Ask)`
- PRD-059 | `important` | Ground Ask in library and show context | `product_prd.md > 8. Cross-Cutting Rules & Principles; ai_prompting_context.md > 2. Shared Inputs (Typical)`

### Concepts / Explore Similar / Alchemy
- PRD-060 | `important` | Define concepts as ingredients, not genre/plot | `concept_system.md > 1. What a Concept Is (User Definition); 3. Concept Taxonomy (Implicit Today)`
- PRD-061 | `important` | Generate concise, evocative, spoiler-safe concept bullets | `concept_system.md > 4. Generation Rules; discovery_quality_bar.md > 2.3 Concepts`
- PRD-062 | `important` | Return eight single-show concepts and larger shared pools | `concept_system.md > 4. Generation Rules; 8. Notes; discovery_quality_bar.md > 2.3 Concepts`
- PRD-063 | `important` | Use selectable concepts with required selection | `detail_page_experience.md > 3.7 Explore Similar (Concept Discovery); concept_system.md > 5. Selection UX Rules`
- PRD-064 | `critical` | Require 2+ shows and capped Alchemy flow | `product_prd.md > 4.7 Alchemy Session; 7.4 Alchemy (Find → Alchemy); concept_system.md > 5. Selection UX Rules`
- PRD-065 | `important` | Clear downstream state and allow More Alchemy | `product_prd.md > 4.7 Alchemy Session; 7.4 Alchemy (Find → Alchemy); concept_system.md > 5. Selection UX Rules`
- PRD-066 | `critical` | Return five Explore Similar and six Alchemy recs | `product_prd.md > 4.7 Alchemy Session; 4.8 Explore Similar (Per-Show Concepts); concept_system.md > 6. Concepts → Recommendations Contract; discovery_quality_bar.md > 2.4 Explore Similar / Alchemy Recs`
- PRD-067 | `important` | Explain recs via selected concepts, concise and recent-biased | `concept_system.md > 6. Concepts → Recommendations Contract; ai_prompting_context.md > 3.5 Concept-Based Recommendations (Explore Similar / Alchemy); ai_voice_personality.md > 4.5 Concept-Based Recs (Explore Similar / Alchemy results)`

### Settings & Data Portability
- PRD-068 | `important` | Expose display and Search-on-Launch settings | `product_prd.md > 7.7 Settings & Your Data`
- PRD-069 | `important` | Expose username, AI, and catalog integration settings | `product_prd.md > 7.7 Settings & Your Data`
- PRD-070 | `critical` | Export zip JSON backup with ISO-8601 dates | `product_prd.md > 7.7 Settings & Your Data; 8. Cross-Cutting Rules & Principles`

### AI Voice, Quality & Guardrails
- PRD-071 | `important` | Maintain one AI persona outside Search | `ai_voice_personality.md > 1. Persona Summary`
- PRD-072 | `important` | Keep AI warm, honest, and non-snobby | `ai_voice_personality.md > 2. Non-Negotiable Voice Pillars; discovery_quality_bar.md > 1.1 Voice Adherence`
- PRD-073 | `critical` | Stay spoiler-safe and inside TV/movie domain | `ai_prompting_context.md > 1. Shared Rules (All AI Surfaces); ai_voice_personality.md > 2. Non-Negotiable Voice Pillars; 6. Do / Don’t`
- PRD-074 | `important` | Prefer specific craft reasoning over generic summaries | `ai_prompting_context.md > 1. Shared Rules (All AI Surfaces); ai_voice_personality.md > 2. Non-Negotiable Voice Pillars`
- PRD-075 | `important` | Structure Scoop as 150-350 word mini-blog | `ai_voice_personality.md > 4.1 Scoop (Show Detail “The Scoop”); ai_prompting_context.md > 3.3 Scoop (Detail Page)`
- PRD-076 | `important` | Ground discovery with specific, surprising reasons | `discovery_quality_bar.md > 1.2 Taste Alignment; 1.3 Surprise Without Betrayal; 1.4 Specificity of Reasoning`
- PRD-077 | `critical` | Treat real-show integrity as non-negotiable | `discovery_quality_bar.md > 1.5 Real-Show Integrity; 4. Scoring Rubric (Quick)`
- PRD-078 | `important` | Validate discovery with explicit scoring rubric | `discovery_quality_bar.md > 4. Scoring Rubric (Quick)`

Total: 78 requirements (28 critical, 48 important, 2 detail) across 10 functional areas

## 2. Coverage Table

| PRD-ID | Requirement | Severity | Coverage | Evidence | Gap |
| ------ | ----------- | -------- | -------- | -------- | --- |
| PRD-001 | Use Next.js/Supabase baseline without Docker dependency | critical | partial | `Tech Stack` | Names Next.js and Supabase, but does not commit to official client libraries or the Docker-optional/cloud-agent constraint. |
| PRD-002 | Configure builds through .env.example without code edits | critical | full | `§2.1 Environment Variables (.env.example)` |  |
| PRD-003 | Keep secrets out of repo and server-only | critical | partial | `§2.1 Environment Variables`; `SUPABASE_SERVICE_ROLE_KEY # server-only` | It marks the service role key as server-only, but does not cover repo secret exclusion rules beyond that. |
| PRD-004 | Provide start, test, and namespace-reset scripts | critical | full | `§2.3 One-Command Developer Experience` |  |
| PRD-005 | Include repeatable database schema evolution artifacts | important | full | `§1 Project Structure`; `supabase/migrations/`; `§3 Database Schema` |  |
| PRD-006 | Assign stable namespace ID for each build | critical | full | `§2.1 Environment Variables`; `§2.2 Identity & Namespace Model` |  |
| PRD-007 | Isolate namespaces and scope destructive tests | critical | full | `§2.2 Identity & Namespace Model`; `§2.3 One-Command Developer Experience`; `§11 Verification` |  |
| PRD-008 | Partition all user data by namespace and user | critical | full | `§2.2 Identity & Namespace Model`; `§3.1 shows table`; `§3.2 cloud_settings table`; `§3.3 Row Level Security` |  |
| PRD-009 | Support dev identity now, OAuth later | important | partial | `§2.2 Identity & Namespace Model` | It sketches dev header injection and future OAuth, but does not explicitly document the mechanism or call out schema-stable migration. |
| PRD-010 | Keep server data authoritative over client caches | critical | partial | `§3 Database Schema`; `§3.3 Row Level Security` | The plan assumes server persistence, but never states that client cache is disposable or that clearing local storage is safe. |
| PRD-011 | Persist show identity, metadata, and user overlay | critical | full | `§3.1 shows table` |  |
| PRD-012 | Store provider availability as regional provider IDs | important | partial | `§3.1 shows table`; `provider_data JSONB` | It stores provider data, but does not specify the IDs-only regional shape required by the schema reference. |
| PRD-013 | Keep credits/videos/recs transient, not persisted | important | full | `§5 External Catalog Integration`; `Transient fields ... returned in API response but not persisted` |  |
| PRD-014 | Persist cloud settings plus local/UI state | important | partial | `§3.2 cloud_settings table`; `§6.8 Settings`; `§4.2 Removing a Show` | Cloud settings are covered, but local settings/UI persistence like last selected filter and saved display/search state are not planned explicitly. |
| PRD-015 | Map catalog fields into stored show semantics | important | partial | `§5 External Catalog Integration`; `TMDB -> Show mapping` | The plan covers the core mapping, but leaves several schema semantics underspecified, especially providers and broader field-by-field mapping behavior. |
| PRD-016 | Merge public fields without blank overwrites | critical | partial | `§4.1 Saving a Show`; `merge catalog fields using selectFirstNonEmpty` | It covers non-empty overwrite protection, but omits the linked creation/details timestamp lifecycle from the same merge contract. |
| PRD-017 | Resolve user-field conflicts by newest timestamp | critical | full | `§4.1 Saving a Show`; `user fields resolved by timestamp (newer wins)`; `§4.3 Timestamps` |  |
| PRD-018 | Define collection membership by assigned status | important | partial | `§6.1 Collection Home`; `§6.6 Show Detail` | The behavior implies status-based membership, but the plan never states that status is the formal membership definition. |
| PRD-019 | Save on status, interest, rating, or tag | critical | full | `§4.1 Saving a Show`; `§6.6 Show Detail`; `§11 Verification` |  |
| PRD-020 | Default saves to Later/Interested except rating | critical | full | `§4.1 Saving a Show`; `§11 Verification` |  |
| PRD-021 | Clear status by deleting show and My Data | critical | partial | `§4.2 Removing a Show`; `§6.6 Show Detail` | The delete-and-clear behavior is present, but the trigger is narrowed to “reselecting active status” instead of clearing status more generally. |
| PRD-022 | Re-adding shows preserves My Data on refresh | critical | full | `§4.1 Saving a Show` |  |
| PRD-023 | Persist Scoop only; Ask/Alchemy stay session-only | important | partial | `§6.6 Show Detail`; `§7 AI Integration` | The plan covers Scoop persistence and freshness, but does not explicitly say Ask sessions, mentioned strips, and Alchemy outputs are cleared on exit. |
| PRD-024 | Resolve AI recs to real shows or fallback | critical | full | `§7.2 Show Resolution`; `§6.4 Ask — AI Chat` |  |
| PRD-025 | Show collection and rating tile badges | important | full | `§6.1 Collection Home`; `§8 Component Architecture`; `ShowTile` |  |
| PRD-026 | Preserve synced data across conflicts and upgrades | critical | partial | `§3.2 cloud_settings table`; `version ... for conflict resolution`; `§4.1 Saving a Show`; `§3 Database Schema` | The plan has timestamp/version hooks, but it does not spell out duplicate merging, settings sync consistency, or upgrade continuity guarantees. |
| PRD-027 | Use navigation plus main-content app structure | important | partial | `§6.1 Collection Home`; `Layout: sidebar + main content area` | The Home layout is covered, but the app-wide navigation/main-content framing is not specified beyond that page. |
| PRD-028 | Keep Find and Settings persistently reachable | important | partial | `§1 Project Structure`; routes for `/find` and `/settings` | Routes exist, but persistent primary-navigation entry points are not explicitly planned. |
| PRD-029 | Provide Search, Ask, Alchemy hub switching | important | partial | `§6.2 Find Hub`; `Mode switcher: Search | Ask | Alchemy`; `Default mode: Search (or Ask if autoSearch setting enabled)` | The hub switcher is covered, but the search-on-launch behavior is muddled by making Ask the alternate default. |
| PRD-030 | Show filtered library grouped by relationship | critical | full | `§6.1 Collection Home` |  |
| PRD-031 | Group Home into Active, Excited, Interested, Other | important | full | `§6.1 Collection Home` |  |
| PRD-032 | Render Active items with more prominence | detail | full | `§6.1 Collection Home`; `Active (prominent / larger tiles)` |  |
| PRD-033 | Support All, Movies, and TV filters | important | full | `§6.1 Collection Home`; `Media-type toggle: All / Movies / TV` |  |
| PRD-034 | Support tag, no-tag, genre, decade, score filters | important | full | `§6.1 Collection Home`; `Sidebar filters` |  |
| PRD-035 | Show poster, title, and My Data badges | important | full | `§6.1 Collection Home`; `Show tiles: poster, title, status badge, rating badge` |  |
| PRD-036 | Handle empty library and empty filter states | important | full | `§6.1 Collection Home`; `Empty states` |  |
| PRD-037 | Search catalog by text into poster grid | critical | full | `§6.3 Search`; `Text input -> debounced TMDB search`; `Results: poster grid` |  |
| PRD-038 | Mark saved results and open Detail on tap | important | full | `§6.3 Search` |  |
| PRD-039 | Preserve Show Detail narrative section order | important | full | `§6.6 Show Detail`; `Section order (per spec)` |  |
| PRD-040 | Use rich header media with graceful fallback | important | partial | `§6.6 Show Detail`; `Header media carousel (backdrops, posters, logos, trailer when available)` | It covers the media types, but not the fallback and non-blocking-reading behavior. |
| PRD-041 | Surface core facts and score near top | important | full | `§6.6 Show Detail`; `Core facts ... + community score bar` |  |
| PRD-042 | Keep status chips in toolbar with mapping | critical | full | `§6.6 Show Detail`; `My relationship controls (toolbar, always visible)` |  |
| PRD-043 | Confirm status reselect removal and clear data | critical | partial | `§6.6 Show Detail`; `Reselecting active status -> confirmation -> removes show`; `§4.2 Removing a Show` | It captures removal through reselecting Active, but not the broader “reselect status clears data” contract described in the supporting spec. |
| PRD-044 | Auto-save unsaved ratings and tag additions | critical | full | `§4.1 Saving a Show`; `§6.6 Show Detail`; `§11 Verification` |  |
| PRD-045 | Keep overview early and Scoop copy stateful | detail | partial | `§6.6 Show Detail`; `Overview + AI Scoop toggle`; toggle copy bullets | The stateful Scoop copy is covered, but the “overview is early/scannable” intent is not called out. |
| PRD-046 | Stream Scoop visibly and persist only if saved | important | full | `§6.6 Show Detail`; `Streams progressively ("Generating..." state)`; `Persisted only if show is in collection` |  |
| PRD-047 | Seed Ask with current show context | important | full | `§6.4 Ask — AI Chat`; `§6.6 Show Detail`; `Ask about this show` |  |
| PRD-048 | Include recs, Explore Similar, streaming, cast links | important | full | `§6.6 Show Detail` |  |
| PRD-049 | Handle TV/movie-only sections and concept CTA states | important | partial | `§6.6 Show Detail`; `Seasons (TV only)`; `Budget vs Revenue (movies, when available)` | TV/movie branching is covered, but the explicit pre-concepts CTA state for Explore Similar is not. |
| PRD-050 | Show gallery, bio, and year-grouped filmography | important | full | `§6.7 Person Detail` |  |
| PRD-051 | Include person analytics charts | important | full | `§6.7 Person Detail` |  |
| PRD-052 | Open Show Detail from any credit | important | full | `§6.7 Person Detail`; `Selecting a credit -> Show Detail` |  |
| PRD-053 | Use chat UI with refreshable starter prompts | important | full | `§6.4 Ask — AI Chat` |  |
| PRD-054 | Summarize older chat turns in persona voice | important | full | `§6.4 Ask — AI Chat`; `§7.3 Conversation Summarization` |  |
| PRD-055 | Return structured commentary plus exact showList | critical | full | `§6.4 Ask — AI Chat`; `§7.1 Surfaces & Prompts` |  |
| PRD-056 | Render mentioned shows strip with Detail/Search handoff | important | full | `§6.4 Ask — AI Chat` |  |
| PRD-057 | Retry Ask parse failures before final fallback | important | missing | none | The plan never specifies the retry-on-parse-failure path before degrading to a fallback experience. |
| PRD-058 | Answer Ask directly and list multiple recommendations | important | missing | none | The plan does not define Ask response formatting behavior such as answering early and using lists for multi-title replies. |
| PRD-059 | Ground Ask in library and show context | important | full | `§6.4 Ask — AI Chat`; `§7.1 Ask`; `Input: ... user library`; `Ask about this show` |  |
| PRD-060 | Define concepts as ingredients, not genre/plot | important | partial | `§7.1 Concepts — single show`; `1–3 words each, evocative, no plot` | The plan gets close, but does not explicitly frame concepts as cross-axis ingredients rather than genre labels. |
| PRD-061 | Generate concise, evocative, spoiler-safe concept bullets | important | partial | `§7.1 Concepts — single show`; `bullet list of 8 concepts (1–3 words each, evocative, no plot)` | It covers short evocative bullets, but not the stronger quality bar around non-generic, varied, strongest-first concepts. |
| PRD-062 | Return eight single-show concepts and larger shared pools | important | full | `§7.1 Concepts — single show`; `§7.1 Concepts — multi-show / Alchemy` |  |
| PRD-063 | Use selectable concepts with required selection | important | partial | `§6.5 Alchemy`; `Select concepts (up to 8)`; `§6.6 Show Detail`; `User selects 1+ concepts` | The plan includes concept selection, but does not explicitly state chip UI behavior or aligned limits across surfaces. |
| PRD-064 | Require 2+ shows and capped Alchemy flow | critical | full | `§6.5 Alchemy` |  |
| PRD-065 | Clear downstream state and allow More Alchemy | important | partial | `§6.5 Alchemy`; `Backtracking: changing shows clears concepts and results`; `"More Alchemy!"` | It handles changing shows, but not the requirement that changing concept selections also clears downstream results. |
| PRD-066 | Return five Explore Similar and six Alchemy recs | critical | full | `§6.5 Alchemy`; `§6.6 Show Detail`; `§7.1 Explore Similar recs`; `§7.1 Alchemy recs` |  |
| PRD-067 | Explain recs via selected concepts, concise and recent-biased | important | partial | `§6.5 Alchemy`; `Each recommendation ... reason citing specific concepts`; `§7.1 Explore Similar recs`; `§7.1 Alchemy recs` | It covers concept-citing reasons, but not the concision and recency/classics guidance from the supporting specs. |
| PRD-068 | Expose display and Search-on-Launch settings | important | full | `§6.8 Settings`; `Display: font size ... search-on-launch toggle` |  |
| PRD-069 | Expose username, AI, and catalog integration settings | important | full | `§6.8 Settings` |  |
| PRD-070 | Export zip JSON backup with ISO-8601 dates | critical | full | `§6.8 Settings`; `§11 Verification` |  |
| PRD-071 | Maintain one AI persona outside Search | important | partial | `§7.3 Conversation Summarization`; `same warm, casual AI persona voice` | The plan mentions persona consistency for summaries, but does not define one shared persona across Scoop, Ask, Explore Similar, and Alchemy. |
| PRD-072 | Keep AI warm, honest, and non-snobby | important | partial | `§7.1 Scoop`; `personal take -> honest stack-up -> ... verdict` | The Scoop structure hints at honesty, but the broader tone contract across AI surfaces is not specified. |
| PRD-073 | Stay spoiler-safe and inside TV/movie domain | critical | missing | none | The plan never states the default spoiler policy or the requirement to redirect out-of-domain requests back into TV/movies. |
| PRD-074 | Prefer specific craft reasoning over generic summaries | important | missing | none | No section defines the required specificity bar for AI reasoning or guards against generic genre boilerplate. |
| PRD-075 | Structure Scoop as 150-350 word mini-blog | important | full | `§7.1 Scoop`; `Output: ...`; `~150–350 words` |  |
| PRD-076 | Ground discovery with specific, surprising reasons | important | partial | `§7.1 Ask`; `Input: ... user library`; `§7.1 Explore Similar recs`; `§7.1 Alchemy recs` | The plan grounds discovery in library/context and concept-citing reasons, but omits the explicit “surprise without betrayal” quality bar. |
| PRD-077 | Treat real-show integrity as non-negotiable | critical | partial | `§7.2 Show Resolution` | Resolution mechanics are present, but the plan does not elevate real-show integrity to an explicit hard quality gate. |
| PRD-078 | Validate discovery with explicit scoring rubric | important | missing | none | The plan contains no AI-quality rubric, threshold, or golden-set style validation strategy. |

## 3. Coverage Scores

Critical:  (19 × 1.0 + 8 × 0.5) / 28 × 100 = 82.1%  (23 of 28 critical requirements)
Important: (25 × 1.0 + 19 × 0.5) / 48 × 100 = 71.9%  (34.5 of 48 important requirements)
Detail:    (1 × 1.0 + 1 × 0.5) / 2 × 100 = 75.0%  (1.5 of 2 detail requirements)
Overall:   (45 × 1.0 + 28 × 0.5) / 78 × 100 = 75.6%  (78 total requirements)

## 4. Top Gaps

1. PRD-073 | `critical` | Stay spoiler-safe and inside TV/movie domain
Without this, Ask and Scoop can violate one of the product’s core trust boundaries by drifting into spoilers or non-entertainment chat instead of feeling safely opinionated.

2. PRD-026 | `critical` | Preserve synced data across conflicts and upgrades
The plan has some merge primitives, but it does not fully cover duplicate handling, settings continuity, or upgrade-safe carry-forward of user libraries, which risks silent data loss or divergence.

3. PRD-021 | `critical` | Clear status by deleting show and My Data
Removal semantics are only partially specified around reselecting Active, leaving ambiguous what happens when users clear other saved states and increasing the chance of orphaned or unexpectedly retained My Data.

4. PRD-001 | `critical` | Use Next.js/Supabase baseline without Docker dependency
The benchmark rider treats cloud-agent compatibility and Docker-optional execution as baseline compliance, so leaving this implicit creates avoidable execution risk even if the product plan is otherwise sound.

5. PRD-077 | `critical` | Treat real-show integrity as non-negotiable
The plan resolves AI output into catalog items, but it never treats hallucinated or mismatched titles as a hard fail condition, which is exactly the kind of regression the discovery quality bar is trying to prevent.

## 5. Coverage Narrative

This is a structurally sound implementation plan with meaningful holes, not a fundamentally broken one. It covers the benchmark stack, namespace isolation, core schema, main routes, and nearly all primary product surfaces well enough that a team could start executing. The overall score is held back less by missing pages or CRUD flows than by under-specified behavioral contracts, especially where the PRD expects the AI experience to feel intentional rather than merely functional.

The plan is strongest in benchmark isolation, persistence scaffolding, and the main product topology. Infrastructure sections cover namespaces, user partitioning, row-level isolation, scripts, and migrations with concrete implementation detail. The Collection Home, Search, Show Detail, Person Detail, and Alchemy flows are all mapped into specific sections, endpoints, and verification steps, so the plan is particularly strong on route-level coverage and data-backed user flows.

The gaps cluster around AI behavior and quality, plus a smaller set of durability semantics. On the AI side, the plan specifies request/response shapes and major flows, but it largely treats voice, guardrails, and quality bars as implementation details. That shows up in missing or partial coverage for spoiler safety, domain restriction, direct-answer formatting, parse-retry fallback, surprise-without-betrayal, and the explicit discovery scoring rubric. On the data side, the plan has merge logic and timestamps, but it is thinner on client-cache disposability, upgrade continuity, duplicate merging, and some local/UI persistence details.

If this plan were executed as-is, the most likely failure mode is an app that looks complete on the surface but feels off-brand and brittle in discovery-heavy scenarios. A QA reviewer or stakeholder would probably notice Ask and Scoop first: responses could be technically wired up yet still sound generic, mishandle edge cases, skip required fallbacks, or violate spoiler/domain expectations. The other likely early failure would be around lifecycle semantics, such as status clearing or sync/version behavior, where the plan is close but not explicit enough to guarantee the PRD’s exact data guarantees.

The remaining planning work is mostly about specification depth, not whole new feature areas. The plan needs a dedicated AI behavior section that states persona, spoiler/domain guardrails, response-shape fallback behavior, and the quality rubric in first-class terms. It also needs a tighter data-durability section covering client-cache assumptions, duplicate merge behavior, upgrade continuity, and the exact local/UI persistence expectations that the technical reference calls out.
