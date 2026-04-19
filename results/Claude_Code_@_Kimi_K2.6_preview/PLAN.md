# Implementation Plan: TV & Movie Companion App

## 1. Executive Summary

Build a personal TV and movie companion using **Next.js (latest stable)** and **Supabase**. The app enables users to collect, organize, rate, and discover entertainment through traditional search, conversational AI ("Ask"), concept-based discovery ("Explore Similar"), and multi-show blending ("Alchemy"). All user data persists server-side with namespace-isolated builds for benchmark repeatability.

---

## 2. Tech Stack & Architecture

| Layer | Technology |
|---|---|
| Framework | Next.js (App Router, latest stable) |
| Language | TypeScript |
| Database / Auth | Supabase (hosted or local; Docker not required) |
| Styling | CSS modules or styled-components with theme tokens |
| AI Provider | Configurable (OpenAI, Anthropic, etc.) via user settings or env |
| External Catalog | TMDB or similar (configurable API key) |
| State Management | React hooks + Server Actions for mutations; SWR/React Query for server state |
| Testing | Vitest (unit), Playwright (e2e) |

**Key Architectural Decisions:**
- Use Next.js Server Actions for data mutations to keep auth/session logic server-side.
- Use a lightweight context or hook-based approach for client-side UI state (no global state library needed).
- All AI calls route through a server-side proxy to protect API keys.
- Namespace isolation is enforced at the data access layer (every query includes `namespace_id`).

---

## 3. Data Model & Schema

### 3.1 Core Tables (Supabase)

**`shows`**
- `id` (UUID, PK) — stable local identifier
- `namespace_id` (text, required, indexed) — build/run isolation
- `user_id` (text, required, indexed) — opaque user identifier
- `title` (text, required)
- `show_type` (enum: `movie` | `tv` | `person` | `unknown`)
- `external_ids` (jsonb) — catalog provider identifiers
- `overview` (text)
- `genres` (text[])
- `tagline` (text)
- `homepage` (text)
- `original_language` (text)
- `spoken_languages` (text[])
- `poster_url` (text)
- `backdrop_url` (text)
- `logo_url` (text)
- `vote_average` (float), `vote_count` (int), `popularity` (float)
- `release_date` (date), `first_air_date` (date), `last_air_date` (date)
- `runtime` (int), `budget` (int), `revenue` (int)
- `series_status` (text), `number_of_episodes` (int), `number_of_seasons` (int)
- `episode_run_time` (int[])
- `provider_data` (jsonb) — `{ countries: { [code]: { flatrate?: number[], rent?: number[], buy?: number[] } } }`
- `my_tags` (text[]), `my_tags_updated_at` (timestamptz)
- `my_score` (float), `my_score_updated_at` (timestamptz)
- `my_status` (enum: `active` | `later` | `wait` | `done` | `quit`), `my_status_updated_at` (timestamptz)
- `my_interest` (enum: `interested` | `excited`), `my_interest_updated_at` (timestamptz)
- `ai_scoop` (text), `ai_scoop_updated_at` (timestamptz)
- `details_updated_at` (timestamptz)
- `created_at` (timestamptz)
- `is_test` (boolean, default false)

**`cloud_settings`**
- `id` (text, PK, default `"globalSettings"`)
- `namespace_id` (text, required, indexed)
- `user_id` (text, required, indexed)
- `user_name` (text)
- `version` (float) — epoch seconds for conflict resolution
- `catalog_api_key` (text)
- `ai_api_key` (text)
- `ai_model` (text)

**`app_metadata`**
- `id` (int, PK)
- `namespace_id` (text, required)
- `data_model_version` (int, default 3)

### 3.2 RLS Policies

All tables enforce Row Level Security:
- `shows`: `namespace_id = current_setting('app.namespace_id') AND user_id = current_setting('app.user_id')`
- `cloud_settings`: same pattern
- Use Supabase `auth.uid()` only if real auth is wired; for benchmark mode, use custom session variables set per-request.

### 3.3 Migrations

- `migrations/001_initial_schema.sql` — creates tables, enums, indexes, RLS policies
- `migrations/002_seed_data.sql` — optional seed fixtures for testing
- Run via Supabase CLI or a custom migration runner (no Docker required).

---

## 4. Directory Structure (Fractal Architecture)

```
my-app/
├── .env.example
├── .gitignore
├── package.json
├── next.config.js
├── vitest.config.ts
├── playwright.config.ts
├── supabase/
│   └── migrations/
│       ├── 001_initial_schema.sql
│       └── 002_seed_data.sql
├── src/
│   ├── config/
│   │   ├── constants.ts          # App-wide constants (status enums, concept limits, etc.)
│   │   └── env.ts                # Validated environment variables
│   ├── theme/
│   │   ├── tokens.ts             # Colors, spacing, typography
│   │   └── ThemeProvider.tsx
│   ├── components/               # Shared UI primitives
│   │   ├── ShowTile/
│   │   ├── ShowTile.tsx
│   │   ├── StatusChip/
│   │   ├── StatusChip.tsx
│   │   ├── ConceptChip/
│   │   ├── ConceptChip.tsx
│   │   ├── RatingBar/
│   │   ├── RatingBar.tsx
│   │   ├── MediaCarousel/
│   │   ├── MediaCarousel.tsx
│   │   └── ...
│   ├── hooks/                    # Global hooks
│   │   ├── useAuth.ts
│   │   ├── useNamespace.ts
│   │   └── useSupabase.ts
│   ├── utils/                    # Global pure functions
│   │   ├── mergeShows.ts         # External catalog → Show merge logic
│   │   ├── catalogMapper.ts      # TMDB → Show field mapping
│   │   └── aiParser.ts           # Parse AI structured outputs
│   ├── lib/
│   │   ├── supabaseClient.ts     # Browser + server clients
│   │   ├── aiClient.ts           # AI provider proxy
│   │   └── catalogClient.ts      # External catalog API client
│   └── pages/                    # Next.js App Router routes
│       ├── layout.tsx
│       ├── page.tsx              # Collection Home (default route)
│       ├── find/
│       │   └── page.tsx          # Find/Discover hub (Search / Ask / Alchemy)
│       ├── show/
│       │   └── [id]/
│       │       └── page.tsx      # Show Detail
│       ├── person/
│       │   └── [id]/
│       │       └── page.tsx      # Person Detail
│       ├── settings/
│       │   └── page.tsx          # Settings
│       └── api/
│           ├── ai/
│           │   ├── scoop/route.ts
│           │   ├── ask/route.ts
│           │   ├── concepts/route.ts
│           │   └── recommendations/route.ts
│           └── catalog/
│               └── search/route.ts
```

**Feature directories follow the fractal pattern inside page routes or shared components.**

---

## 5. Feature Implementation Plan

### 5.1 Collection Home (`page.tsx`)

**Purpose:** Display the user's library organized by relationship/status.

**Sub-features:**
- **FilterPanel** — sidebar with: All Shows, tag filters, genre/decade/score filters, media-type toggle (All / Movies / TV)
- **StatusGroup** — displays tiles grouped by:
  1. Active (prominent/larger tiles)
  2. Excited (Later + Excited)
  3. Interested (Later + Interested)
  4. Other (Wait, Quit, Done, unclassified Later)
- **ShowTile** — poster + title + My Data badges (in-collection dot, rating star)
- **EmptyState** — prompt to Search/Ask when collection is empty

**Data flow:**
- Server Action: `fetchShows(namespaceId, userId, filters)` → queries Supabase with filters
- Client: group by status using `useShowGroups()` hook

**Key rules:**
- Media-type toggle applies on top of any filter.
- Tag filters are dynamically derived from the user's tag library.
- Sort within groups: recently updated first (by `my_status_updated_at` or equivalent).

### 5.2 Find / Discover Hub (`find/page.tsx`)

**Purpose:** Global entry point for Search, Ask, and Alchemy with a mode switcher.

**Sub-features:**
- **ModeSwitcher** — tab/button group to switch between Search, Ask, Alchemy
- **SearchFeature** — text search against external catalog
- **AskFeature** — AI chat session
- **AlchemyFeature** — multi-show concept blending

### 5.2.1 Search (`find/features/Search/`)

**Purpose:** Find shows in the global catalog by title/keywords.

**Sub-features:**
- **SearchInput** — debounced text input
- **SearchResultsGrid** — poster grid of catalog results
- **ShowTile** (reused from Home, with in-collection indicator)

**Data flow:**
- Client inputs query → Server Action `searchCatalog(query)` → calls external catalog API → maps to `Show` objects → returns.
- In-collection indicators fetched via `fetchSavedStatus(resultIds)`.

**Key rules:**
- Auto-open on launch if `autoSearch` setting is true.
- Selecting a result navigates to `/show/[id]`.

### 5.2.2 Ask (`find/features/Ask/`)

**Purpose:** Conversational AI discovery.

**Sub-features:**
- **ChatPanel** — scrollable message list (user/assistant turns)
- **ChatInput** — text input + send
- **MentionedShowsStrip** — horizontal scroll of shows mentioned in the last AI response
- **StarterPrompts** — 6 random starter prompts, refreshable

**Data flow:**
- Client sends message → Server Action `askChat(messages, libraryContext)` → calls AI proxy with:
  - User's library (saved shows + My Data)
  - Recent conversation turns (summarized after ~10 messages)
  - System prompt enforcing persona (fun, chatty, spoiler-safe, opinionated)
- AI returns structured response: `commentary` + optional `showList` (format: `Title::externalId::mediaType`)
- Parser extracts `showList`, resolves each to catalog items, renders as selectable tiles.

**Key rules:**
- Session-only persistence (no DB storage for chat history).
- Conversation summarization: after ~10 turns, compress older turns into 1-2 sentences preserving tone.
- Mentioned shows strip is derived from current chat context only.

### 5.2.3 Alchemy (`find/features/Alchemy/`)

**Purpose:** Structured discovery by blending multiple shows.

**Sub-features:**
- **InputShowSelector** — pick 2+ shows (from library + catalog search)
- **ConceptCatalystGrid** — selectable concept chips (max 8 selection)
- **AlchemyResults** — 6 recommended shows with reasons
- **ChainAction** — "More Alchemy!" to use results as new inputs

**Data flow:**
1. User selects input shows → Client calls `generateConcepts(showIds)` → Server Action fetches show data, calls AI with multi-show concept prompt → returns concept list (bullet list, 1-3 words each).
2. User selects concepts → Client calls `alchemize(showIds, selectedConcepts)` → Server Action calls AI with concept-based recommendation prompt → returns 6 recs with reasons.
3. Each rec attempts catalog resolution by title + external ID; successful matches become real `Show` objects.

**Key rules:**
- Changing input shows clears concepts and results.
- Selecting/unselecting concepts clears downstream results.
- Reasons must explicitly name which concepts align.
- Results are session-only (not persisted).

### 5.3 Show Detail (`show/[id]/page.tsx`)

**Purpose:** Single source of truth for a show: public facts + personal relationship + discovery launchpad.

**Sections (in order):**
1. **HeaderMedia** — carousel of backdrops/posters/logos/trailers; graceful fallback when media is sparse
2. **CoreFacts** — year, runtime/seasons, community score bar
3. **MyRelationshipToolbar** — status chips, rating bar, tag display
4. **Overview** + **ScoopToggle**
5. **AskAboutThisShow** CTA
6. **Genres** + **Languages**
7. **TraditionalRecommendations** — strand of similar/recommended shows from catalog
8. **ExploreSimilar** — Get Concepts → select → Explore Shows
9. **StreamingAvailability** — provider icons by region
10. **CastCrewStrands** — horizontal person tiles → navigates to Person Detail
11. **Seasons** (TV only)
12. **BudgetRevenue** (movies when available)

**Data flow:**
- Load show: `fetchShow(id)` → merge stored user data with fresh catalog data → return unified `Show`.
- Catalog data refreshed on each visit; merge uses `selectFirstNonEmpty` for non-user fields, timestamp-wins for user fields.

**Key interaction rules:**
- **Status chips** (`Active`, `Interested`, `Excited`, `Done`, `Quit`, `Wait`):
  - `Interested`/`Excited` map to `Later + Interest`.
  - Selecting a status saves the show.
  - Reselecting the active status triggers removal confirmation; confirming removes the show and clears all My Data.
- **Rating bar:** rating an unsaved show auto-saves as `Done`.
- **Tags:** adding a tag to an unsaved show auto-saves as `Later + Interested`.
- **Scoop:**
  - Toggle copy: "Give me the scoop!" → "Show the scoop" → "The Scoop".
  - Generated on demand via AI; streams progressively.
  - Cached for ~4 hours (`ai_scoop_updated_at`).
  - Only persisted if the show is in collection; otherwise ephemeral.
- **Explore Similar:**
  - "Get Concepts" fetches single-show concepts (same prompt contract as Alchemy, but single input).
  - Concepts appear as selectable chips.
  - "Explore Shows" returns 5 AI recs tied to real catalog items.

### 5.4 Person Detail (`person/[id]/page.tsx`)

**Purpose:** Explore talent behind shows.

**Sections:**
- Image gallery, name, bio
- Analytics charts: average project ratings, top genres, projects-by-year
- Filmography grouped by year (click credit → Show Detail)

**Data flow:**
- Fetch person from catalog API + filmography.
- Analytics computed client-side from filmography data.

### 5.5 Settings (`settings/page.tsx`)

**Sections:**
- **Appearance:** font size selector (`XS` to `XXL`), search-on-launch toggle
- **User:** username (synced if cloud enabled)
- **AI:** AI provider API key, model selection (synced if cloud enabled)
- **Integrations:** catalog API key (synced if cloud enabled)
- **Your Data:** Export My Data → `.zip` containing JSON backup of all saved shows (ISO-8601 dates)

**Data flow:**
- Settings read from `cloud_settings` table.
- Changes persisted with `version` set to current epoch seconds for conflict resolution.

---

## 6. AI Integration Strategy

### 6.1 Server-Side AI Proxy (`src/lib/aiClient.ts`)

All AI calls go through a server-side proxy to keep API keys secure.

**Supported providers:** OpenAI, Anthropic (configurable via settings).

### 6.2 Surface-Specific Prompts

All prompts share a base system persona (fun, chatty TV/movie nerd friend) with surface-specific adaptations:

| Surface | System Prompt Focus | Output Format |
|---|---|---|
| **Scoop** | Mini blog-post of taste: personal take, honest stack-up, emotional centerpiece, fit/warnings, verdict | Structured text, ~150-350 words |
| **Ask** | Conversational friend; picks favorites; adapts depth to question | Text + optional `showList` string |
| **Ask with Mentions** | Same as Ask, but enforce structured output | JSON: `{ commentary: string, showList: string }` |
| **Concepts (single)** | Extract vibe/structure/emotion ingredients | Bullet list, 1-3 words each, no explanation |
| **Concepts (multi/Alchemy)** | Find shared commonality across all input shows | Same as single, but concepts must apply to all inputs |
| **Concept Recs** | Excited, taste-aware suggestions grounded in selected concepts | List of shows with 1-3 sentence reasons citing concepts |

### 6.3 Guardrails

- All AI surfaces stay within TV/movies; redirect if asked otherwise.
- Spoiler-safe by default.
- Opinionated and honest: acknowledge mixed reception, don't gush for no reason.
- Specific, vibe-first reasoning; avoid generic genre summaries.
- If structured parsing fails: retry once with stricter formatting, then fall back to unstructured + search handoff.

### 6.4 Context Inclusion

AI calls include relevant context:
- User's library (saved shows + statuses/tags/ratings) for taste-aware responses.
- Current show context for "Ask about this show" and Scoop.
- Selected concepts for Explore Similar / Alchemy.
- Recent conversation turns for chat (summarized after ~10 messages).

---

## 7. Authentication & Identity

### 7.1 Benchmark/Dev Mode

- No real OAuth required.
- Identity injected via a development mechanism:
  - Option A: `X-User-Id` header on server routes, set from a dev-only UI selector.
  - Option B: fixed "default user" per namespace.
- Clearly documented in README; gated for production.

### 7.2 Production Migration Path

- Schema uses opaque `user_id` string with no provider-specific encoding.
- Replacing dev identity with real OAuth requires only auth wiring changes, not schema redesign.
- RLS policies updated to use `auth.uid()` instead of custom session variable.

---

## 8. Namespace Isolation

### 8.1 Build/Run Namespace

- Each build receives a stable `namespace_id` (env var or generated).
- All persisted data is scoped to `(namespace_id, user_id)`.
- Two different namespaces cannot read/write each other's data.

### 8.2 Implementation

- Supabase client initialized with `namespace_id` from env or config.
- Every query includes `namespace_id` filter.
- RLS policies enforce namespace boundaries.
- Test reset: `DELETE FROM shows WHERE namespace_id = ?` — no global teardown needed.

---

## 9. External Catalog Integration

### 9.1 Catalog Client (`src/lib/catalogClient.ts`)

- Wraps TMDB (or equivalent) API.
- Handles search, detail fetch, recommendations, similar shows, credits, videos, providers.
- Maps catalog responses to internal `Show` shape via `catalogMapper.ts`.

### 9.2 Field Mapping Rules

- IDs: catalog `id` → `Show.id`; external IDs stored in `external_ids`.
- Title: prefer `title` (movies) or `name` (TV); fail if neither.
- Show type: catalog `media_type` → enum; infer from field presence if missing.
- Images: map paths to full URLs; choose best-rated logo deterministically.
- Providers: store IDs only by region; fetch provider metadata separately.
- Transient data (`cast`, `crew`, `seasons`, `videos`, `recommendations`, `similar`) fetched for UI but not persisted.

### 9.3 Merge Policy

When merging fresh catalog data into a stored show:
- Non-user fields: `selectFirstNonEmpty(new, old)` — never overwrite non-empty with empty.
- User fields (`my_tags`, `my_score`, `my_status`, `my_interest`): timestamp wins.
- `details_updated_at` set to "now" after merge.
- `created_at` set only on first creation.

---

## 10. Testing Strategy

### 10.1 Unit Tests (Vitest)

- `mergeShows.test.ts` — merge policy edge cases
- `catalogMapper.test.ts` — field mapping for movies and TV
- `aiParser.test.ts` — structured output parsing (showList format, concept lists)
- `useShowGroups.test.ts` — status grouping logic
- Hook tests for status transitions, auto-save triggers, filter application

### 10.2 E2E Tests (Playwright)

- Build collection journey: search → save → set status → tag → rate
- Ask journey: send message → verify mentioned shows strip
- Alchemy journey: select shows → conceptualize → select concepts → alchemize
- Detail page: verify all sections render, status toggles work, scoop generates
- Settings: export data produces valid zip
- Namespace isolation: data from namespace A not visible in namespace B

### 10.3 Test Data Reset

- `npm run test:reset` script clears all data for the current namespace.
- No manual setup or global teardown required.

---

## 11. Implementation Phases

### Phase 1: Foundation (Week 1)
- Scaffold Next.js project with TypeScript
- Configure Supabase client, migrations, RLS policies
- Implement `namespace_id` + `user_id` isolation
- Set up dev identity injection mechanism
- Build catalog client + mapper with merge logic
- Implement `cloud_settings` and `app_metadata` tables

### Phase 2: Core Data & Home (Week 1-2)
- Implement Show data model and CRUD server actions
- Build Collection Home with filters and status groups
- Implement ShowTile component with My Data badges
- Build Search feature (catalog search + results grid)

### Phase 3: Show Detail (Week 2)
- Build Show Detail page with all sections
- Implement My Relationship controls (status, rating, tags) with auto-save rules
- Build Header Media carousel with graceful fallback
- Implement Overview + Scoop toggle with AI proxy endpoint
- Build Explore Similar (concepts + recommendations)
- Implement streaming availability display

### Phase 4: AI Surfaces (Week 2-3)
- Build AI proxy with provider abstraction
- Implement Scoop generation endpoint with streaming
- Build Ask chat UI with session management and summarization
- Implement structured output parsing for mentioned shows
- Build Alchemy flow (input selection → concepts → recommendations)
- Implement concept generation for both single and multi-show

### Phase 5: Person & Settings (Week 3)
- Build Person Detail page with analytics charts
- Implement Settings page (appearance, AI, integrations)
- Build Export My Data feature (JSON backup in zip)

### Phase 6: Polish & Testing (Week 3-4)
- Write unit tests for critical logic (merge, mapping, parsing, grouping)
- Write E2E tests for core user journeys
- Implement namespace-scoped test reset
- Performance review: ensure catalog images lazy-load, AI calls are cached appropriately
- Accessibility pass

---

## 12. Environment Variables

```bash
# .env.example
NEXT_PUBLIC_SUPABASE_URL=          # Supabase project URL
NEXT_PUBLIC_SUPABASE_ANON_KEY=     # Supabase public anon key
SUPABASE_SERVICE_ROLE_KEY=         # Server-only service role key (for migrations/admin)
NAMESPACE_ID=                      # Build/run isolation identifier
DEFAULT_USER_ID=                   # Dev-only default user ID
CATALOG_API_KEY=                   # TMDB or equivalent API key
AI_API_KEY=                        # Default AI provider API key
AI_MODEL=                          # Default AI model name
```

---

## 13. Risks & Mitigations

| Risk | Mitigation |
|---|---|
| AI structured output parsing is fragile | Implement retry logic; fall back to unstructured + search handoff |
| Catalog API rate limits | Add client-side caching for catalog details; debounce search |
| Supabase RLS complexity in dev mode | Use custom session variables for benchmark mode; document migration to real auth |
| Namespace isolation missed in a query | Enforce at the client initialization layer; add integration tests |
| AI persona drift across surfaces | Centralize base system prompt; write unit tests for prompt composition |
| Streaming Scoop UX feels slow | Implement progressive streaming; show "Generating..." immediately |

---

## 14. Open Questions from PRD

- Should **Next** become a first-class UI status? (Currently hidden in data model only.)
- Should generating Scoop on an unsaved show implicitly save it?
- Should clearing My Rating store an explicit **Unrated** state vs nil?
- Import/Restore from export zip is desired but not yet specced.
- Saving/sharing Alchemy sessions as reusable blends is a future extension.

---

*Plan generated for benchmark evaluation. Do not implement until plan is approved.*
