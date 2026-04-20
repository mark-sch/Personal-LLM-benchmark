# Implementation Plan — Personal TV & Movie Companion

> **Scope:** Full-stack build of a personal entertainment companion app for collecting, organizing, rating, and discovering TV shows and movies. This plan is derived from the complete PRD suite: `product_prd.md`, `infra_rider_prd.md`, and all supporting documents in `docs/prd/supporting_docs/`.

---

## 1. Architecture Overview

### 1.1 Technology Stack

| Layer | Choice | Rationale |
|---|---|---|
| **Framework** | Next.js (latest stable) | Required by infra rider §2 |
| **Persistence** | Supabase (hosted preferred) | Required by infra rider §2 |
| **Language** | TypeScript | Type safety for complex data shapes; aligns with schema reference |
| **Styling** | Tailwind CSS + design tokens | Fast iteration; theme tokens in `src/theme/` |
| **State Management** | React Query (TanStack Query) + React Context | Server-state caching (React Query) + lightweight client state (Context) |
| **AI Integration** | OpenAI-compatible API (configurable model) | Matches `CloudSettings.aiModel` / `aiApiKey` pattern |
| **Content Catalog** | TMDB API | Industry standard; provides all required fields (credits, seasons, providers, etc.) |
| **Testing** | Vitest + React Testing Library + Playwright (E2E) | Unit + integration + E2E coverage |

### 1.2 High-Level Architecture

```
┌─────────────────────────────────────────────────┐
│                   Client (Next.js)               │
│  ┌───────────┐  ┌───────────┐  ┌──────────────┐ │
│  │  Pages &   │  │  Features │  │ Shared UI    │ │
│  │  Routes    │  │  (Fractal)│  │ Components   │ │
│  └─────┬─────┘  └─────┬─────┘  └──────┬───────┘ │
│        │              │               │          │
│  ┌─────▼──────────────▼───────────────▼───────┐ │
│  │          Hooks & Utils Layer               │ │
│  └─────┬──────────────┬───────────────┬───────┘ │
│        │              │               │          │
│  ┌─────▼─────┐  ┌─────▼─────┐  ┌─────▼──────┐  │
│  │ React     │  │ React     │  │ Client     │  │
│  │ Query     │  │ Context   │  │ Cache      │  │
│  │ (server   │  │ (UI state)│  │ (optional) │  │
│  │  state)   │  │           │  │            │  │
│  └─────┬─────┘  └───────────┘  └────────────┘  │
└────────┼────────────────────────────────────────┘
         │ Next.js API Routes (Server)
┌────────▼────────────────────────────────────────┐
│              Server Boundary                     │
│  ┌──────────────┐  ┌──────────────────────────┐ │
│  │ API Route    │  │ AI Proxy Routes          │ │
│  │ Handlers     │  │ (Scoop, Ask, Alchemy,    │ │
│  │ (CRUD,       │  │  Concepts, Recs)         │ │
│  │  Catalog)    │  │                          │ │
│  └──────┬───────┘  └───────────┬──────────────┘ │
│         │                      │                │
│  ┌──────▼──────────────────────▼──────────────┐ │
│  │          Service Layer                      │ │
│  │  (Business rules, merge logic, isolation)  │ │
│  └──────┬─────────────────────────────────────┘ │
└─────────┼───────────────────────────────────────┘
          │
┌─────────▼───────────────────────────────────────┐
│              Supabase                            │
│  ┌──────────┐  ┌──────────┐  ┌────────────────┐ │
│  │ shows    │  │ settings │  │ app_metadata   │ │
│  │ (per     │  │ (cloud   │  │ (migrations)   │ │
│  │  user)   │  │  sync)   │  │                │ │
│  └──────────┘  └──────────┘  └────────────────┘ │
└─────────────────────────────────────────────────┘
```

### 1.3 Key Architectural Decisions

1. **Server-side authority:** All mutations go through Next.js API routes → Supabase. Clients never write directly to Supabase. This keeps the backend as the source of truth (PRD §8, rule 9).
2. **AI calls are server-side only:** API keys stay on the server. The client never sees AI provider keys.
3. **Namespace + user_id partitioning:** Every Supabase query is scoped by `(namespace_id, user_id)` to satisfy the infra rider isolation model.
4. **Catalog proxy:** TMDB calls are proxied through server routes so the catalog API key stays server-side.
5. **Streaming for AI:** Scoop generation streams progressively via Server-Sent Events (SSE) or ReadableStream so the user sees "Generating…" not a blank state.

---

## 2. Directory Structure

Following the Fractal Architecture from `INSTRUCTIONS.md`:

```
src/
├── config/                        # Global constants, env vars, feature flags
│   ├── env.ts                     # Validates & exports env vars
│   ├── constants.ts               # App-wide constants (statuses, interest levels, etc.)
│   └── namespaces.ts              # Namespace resolution logic
│
├── theme/                         # Design tokens & styling
│   ├── tokens.ts                  # Colors, spacing, typography scales
│   ├── font-sizes.ts              # XS/S/M/L/XL/XXL scale mappings
│   └── components.ts              # Shared Tailwind component classes
│
├── components/                    # Shared UI primitives
│   ├── ShowTile/                  # Poster + title + badges
│   ├── ShowTile/ShowTile.tsx
│   ├── RatingBar/
│   ├── StatusChips/
│   ├── TagPicker/
│   ├── ConceptChips/
│   ├── ChatBubble/
│   ├── MediaCarousel/
│   ├── FilterSidebar/
│   └── EmptyState/
│
├── hooks/                         # Global hooks
│   ├── useNamespace.ts
│   ├── useUserId.ts
│   ├── useLocalSettings.ts
│   └── useFilterState.ts
│
├── utils/                         # Global pure functions
│   ├── merge-show.ts              # Catalog merge logic (PRD §5.5 + schema merge rules)
│   ├── show-helpers.ts            # Status/interest/tag display helpers
│   ├── date-formatters.ts
│   ├── export-data.ts             # Export/backup ZIP generation
│   └── catalog-mapper.ts          # TMDB → Show mapping
│
├── types/                         # Shared TypeScript types
│   ├── show.ts                    # Show, ShowType, MyStatusType, etc.
│   ├── filters.ts                 # FilterConfiguration, FilterType
│   ├── ai.ts                      # AI surface contracts
│   └── settings.ts                # CloudSettings, LocalSettings, etc.
│
├── server/                        # Server-side only code
│   ├── supabase/
│   │   ├── client.ts              # Server Supabase client
│   │   ├── queries/
│   │   │   ├── shows.ts           # CRUD for shows table
│   │   │   ├── settings.ts        # CloudSettings CRUD
│   │   │   └── metadata.ts        # AppMetadata read/write
│   │   └── migrations/            # SQL migration files
│   │       ├── 001_initial.sql
│   │       ├── 002_seed.sql
│   │       └── ...
│   ├── ai/
│   │   ├── client.ts              # AI provider client setup
│   │   ├── prompts/
│   │   │   ├── scoop.ts           # Scoop system prompt + response structure
│   │   │   ├── ask.ts             # Ask chat prompts (basic + extended)
│   │   │   ├── concepts.ts        # Concept extraction prompt
│   │   │   └── recommendations.ts # Concept-based rec prompt
│   │   ├── scoop-service.ts       # Scoop generation + caching logic
│   │   ├── ask-service.ts         # Ask chat + mentioned shows extraction
│   │   ├── concept-service.ts     # Concept generation
│   │   └── rec-service.ts         # Concept-based recommendations
│   ├── catalog/
│   │   ├── tmdb-client.ts         # TMDB API wrapper
│   │   ├── search.ts              # Search endpoint
│   │   ├── detail.ts              # Detail + credits + seasons + providers
│   │   └── person.ts              # Person detail + filmography
│   └── services/
│       ├── show-service.ts         # Business logic for save/remove/merge
│       ├── filter-service.ts       # Filter query building
│       ├── export-service.ts       # Export ZIP creation
│       └── identity-service.ts     # Dev-mode identity injection
│
├── pages/                         # Next.js App Router pages (or Pages Router)
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx               # Home (Collection Home)
│   │   ├── find/
│   │   │   ├── page.tsx           # Find/Discover hub (mode switcher)
│   │   │   ├── features/
│   │   │   │   ├── Search/
│   │   │   │   │   ├── Search.tsx
│   │   │   │   │   ├── hooks/
│   │   │   │   │   └── utils/
│   │   │   │   ├── Ask/
│   │   │   │   │   ├── Ask.tsx
│   │   │   │   │   ├── hooks/
│   │   │   │   │   └── features/
│   │   │   │   │       └── MentionedShowsStrip/
│   │   │   │   └── Alchemy/
│   │   │   │       ├── Alchemy.tsx
│   │   │   │       ├── hooks/
│   │   │   │       └── features/
│   │   │   │           ├── ShowSelector/
│   │   │   │           ├── ConceptPicker/
│   │   │   │           └── AlchemyResults/
│   │   ├── show/
│   │   │   └── [id]/
│   │   │       └── page.tsx       # Show Detail
│   │   │       └── features/
│   │   │           ├── HeaderMedia/
│   │   │           ├── CoreFacts/
│   │   │           ├── StatusControls/
│   │   │           ├── RatingControl/
│   │   │           ├── TagSection/
│   │   │           ├── ScoopSection/
│   │   │           ├── ExploreSimilar/
│   │   │           ├── Recommendations/
│   │   │           ├── StreamingProviders/
│   │   │           ├── CastCrew/
│   │   │           ├── SeasonsSection/
│   │   │           └── BudgetRevenue/
│   │   ├── person/
│   │   │   └── [id]/
│   │   │       └── page.tsx       # Person Detail
│   │   │       └── features/
│   │   │           ├── PersonHeader/
│   │   │           ├── PersonAnalytics/
│   │   │           └── Filmography/
│   │   └── settings/
│   │       └── page.tsx           # Settings
│   │       └── features/
│   │           ├── UserSection/
│   │           ├── AISection/
│   │           ├── IntegrationsSection/
│   │           ├── DisplaySection/
│   │           └── DataSection/
│   └── api/
│       ├── shows/
│       │   ├── route.ts           # GET (list/filter), POST (save)
│       │   └── [id]/
│       │       └── route.ts       # GET, PUT, DELETE
│       ├── search/
│       │   └── route.ts           # Catalog search proxy
│       ├── catalog/
│       │   └── [id]/
│       │       └── route.ts       # Catalog detail proxy
│       ├── person/
│       │   └── [id]/
│       │       └── route.ts       # Person detail proxy
│       ├── ai/
│       │   ├── scoop/
│       │   │   └── route.ts       # POST: generate scoop (streaming)
│       │   ├── ask/
│       │   │   └── route.ts       # POST: chat turn
│       │   ├── concepts/
│       │   │   └── route.ts       # POST: generate concepts
│       │   └── recommendations/
│       │       └── route.ts       # POST: concept-based recs
│       ├── settings/
│       │   └── route.ts           # GET/PUT cloud settings
│       ├── local-settings/
│       │   └── route.ts           # GET/PUT local settings (client-side only)
│       └── export/
│           └── route.ts           # GET: export ZIP
│
├── __tests__/                     # Test files co-located or centralized
│   ├── server/
│   │   ├── merge-show.test.ts
│   │   ├── show-service.test.ts
│   │   ├── concept-service.test.ts
│   │   └── catalog-mapper.test.ts
│   └── components/
│       ├── ShowTile.test.tsx
│       ├── StatusChips.test.tsx
│       └── ...
│
└── scripts/
    ├── seed.ts                    # Seed data for development
    ├── test-reset.ts              # Destructive test data reset per namespace
    └── migrate.ts                 # Run migrations
```

---

## 3. Database Schema (Supabase)

### 3.1 Tables

#### `shows`

| Column | Type | Nullable | Default | Notes |
|---|---|---|---|---|
| `id` | `text` | NO | — | Primary key (external catalog ID) |
| `namespace_id` | `text` | NO | — | Build isolation partition |
| `user_id` | `text` | NO | — | Owner partition |
| `title` | `text` | NO | — | |
| `show_type` | `text` | NO | `'unknown'` | `"movie" \| "tv" \| "person" \| "unknown"` |
| `external_ids` | `jsonb` | YES | `null` | |
| `overview` | `text` | YES | `null` | |
| `genres` | `jsonb` | NO | `'[]'::jsonb` | Array of genre name strings |
| `tagline` | `text` | YES | `null` | |
| `homepage` | `text` | YES | `null` | |
| `original_language` | `text` | YES | `null` | |
| `spoken_languages` | `jsonb` | NO | `'[]'::jsonb` | |
| `languages` | `jsonb` | NO | `'[]'::jsonb` | |
| `poster_url` | `text` | YES | `null` | |
| `backdrop_url` | `text` | YES | `null` | |
| `logo_url` | `text` | YES | `null` | |
| `network_logos` | `jsonb` | NO | `'[]'::jsonb` | |
| `vote_average` | `double precision` | YES | `null` | |
| `vote_count` | `integer` | YES | `null` | |
| `popularity` | `double precision` | YES | `null` | |
| `last_air_date` | `timestamptz` | YES | `null` | |
| `first_air_date` | `timestamptz` | YES | `null` | |
| `release_date` | `timestamptz` | YES | `null` | |
| `runtime` | `integer` | YES | `null` | Movies |
| `budget` | `bigint` | YES | `null` | Movies |
| `revenue` | `bigint` | YES | `null` | Movies |
| `series_status` | `text` | YES | `null` | TV |
| `number_of_episodes` | `integer` | YES | `null` | TV |
| `number_of_seasons` | `integer` | YES | `null` | TV |
| `episode_run_time` | `jsonb` | NO | `'[]'::jsonb` | TV |
| `last_episode_run_time` | `integer` | YES | `null` | TV |
| `my_tags` | `jsonb` | NO | `'[]'::jsonb` | |
| `my_tags_update_date` | `timestamptz` | YES | `null` | |
| `my_score` | `double precision` | YES | `null` | |
| `my_score_update_date` | `timestamptz` | YES | `null` | |
| `my_status` | `text` | YES | `null` | `"active"\|"next"\|"later"\|"done"\|"quit"\|"wait"` |
| `my_status_update_date` | `timestamptz` | YES | `null` | |
| `my_interest` | `text` | YES | `null` | `"excited"\|"interested"` |
| `my_interest_update_date` | `timestamptz` | YES | `null` | |
| `ai_scoop` | `text` | YES | `null` | |
| `ai_scoop_update_date` | `timestamptz` | YES | `null` | |
| `details_update_date` | `timestamptz` | YES | `null` | |
| `creation_date` | `timestamptz` | YES | `now()` | |
| `provider_data` | `jsonb` | YES | `null` | |
| `is_test` | `boolean` | NO | `false` | |

**Primary key:** `(namespace_id, user_id, id)`

**Indexes:**
- `(namespace_id, user_id, my_status)` — for collection queries grouped by status
- `(namespace_id, user_id, my_tags)` via GIN — for tag filtering
- `(namespace_id, user_id, genres)` via GIN — for genre filtering

#### `cloud_settings`

| Column | Type | Nullable | Default |
|---|---|---|---|
| `id` | `text` | NO | `'globalSettings'` |
| `namespace_id` | `text` | NO | — |
| `user_id` | `text` | NO | — |
| `user_name` | `text` | NO | — |
| `version` | `double precision` | NO | `0` |
| `catalog_api_key` | `text` | YES | `null` |
| `ai_api_key` | `text` | YES | `null` |
| `ai_model` | `text` | NO | `'default'` |

**Primary key:** `(namespace_id, user_id, id)`

#### `app_metadata`

| Column | Type | Nullable | Default |
|---|---|---|---|
| `namespace_id` | `text` | NO | — |
| `data_model_version` | `integer` | NO | `3` |

**Primary key:** `(namespace_id)`

### 3.2 Row-Level Security (RLS)

Enable RLS on all tables. Policies scope all access to `(namespace_id, user_id)` matching the request context. In benchmark/dev mode, `user_id` is injected via server middleware (see §5.2).

### 3.3 Migrations

Each migration is a numbered SQL file in `src/server/supabase/migrations/`. The migration runner reads `app_metadata.data_model_version` and applies pending migrations sequentially. Migration files are idempotent where possible.

---

## 4. Feature Implementation Plan

### Phase 1: Foundation (Week 1)

#### 4.1 Project Scaffolding

1. Initialize Next.js project with TypeScript and Tailwind CSS.
2. Install dependencies: `@supabase/supabase-js`, `@tanstack/react-query`, `zod` (validation), `archiver` (ZIP export), `openai` or generic AI SDK.
3. Create `.env.example` with all required variables:
   ```
   # Supabase
   NEXT_PUBLIC_SUPABASE_URL=
   NEXT_PUBLIC_SUPABASE_ANON_KEY=
   SUPABASE_SERVICE_ROLE_KEY=         # server-only

   # AI Provider
   AI_API_KEY=                        # server-only; may also come from user settings
   AI_MODEL=default

   # Content Catalog (TMDB)
   CATALOG_API_KEY=                   # server-only; may also come from user settings

   # Identity & Isolation
   NAMESPACE_ID=default-namespace
   DEFAULT_USER_ID=default-user

   # App
   NEXT_PUBLIC_APP_ENV=development
   ```
4. Configure `.gitignore` to exclude `.env*` (except `.env.example`).
5. Add scripts to `package.json`:
   - `"dev"` — start dev server
   - `"build"` — production build
   - `"test"` — run Vitest
   - `"test:e2e"` — run Playwright
   - `"test:reset"` — run destructive test reset script
   - `"db:migrate"` — run migrations
   - `"db:seed"` — seed development data

#### 4.2 Database Setup

1. Write initial migration `001_initial.sql` creating `shows`, `cloud_settings`, `app_metadata` tables with proper types and constraints.
2. Write `002_rls.sql` enabling RLS and creating scoping policies.
3. Write `003_indexes.sql` adding query-optimized indexes.
4. Implement migration runner in `scripts/migrate.ts`.

#### 4.3 Identity & Isolation Layer

1. Implement `src/server/services/identity-service.ts`:
   - Reads `NAMESPACE_ID` from env.
   - In development/test: accepts `X-User-Id` header or falls back to `DEFAULT_USER_ID`.
   - In production: placeholder for real OAuth wiring.
   - Attaches `(namespace_id, user_id)` to all downstream service calls.
2. Create middleware that validates/injects identity for all API routes.
3. Gate the dev identity mechanism behind `NEXT_PUBLIC_APP_ENV=development`.

#### 4.4 Supabase Client Layer

1. Create server-side Supabase client using service role key (server routes only).
2. Create a browser-side Supabase client using anon key (for optional realtime subscriptions later).
3. Implement base query helpers that auto-inject `(namespace_id, user_id)` scoping.

#### 4.5 Type Definitions

1. Implement `src/types/show.ts` mirroring the schema from `storage-schema.ts`.
2. Implement `src/types/filters.ts` for `FilterConfiguration`, `FilterType`.
3. Implement `src/types/ai.ts` for AI surface contracts (Scoop, Ask, Concepts, Recs).
4. Implement `src/types/settings.ts` for `CloudSettings`, `LocalSettings`, `UserDefaultsUIState`.

---

### Phase 2: Core Data & Catalog (Week 2)

#### 4.6 Catalog Integration (TMDB)

1. Implement `src/server/catalog/tmdb-client.ts`:
   - Generic request helper with rate-limit awareness.
   - Image URL builder (poster, backdrop, logo with configurable sizes).
2. Implement `src/server/catalog/search.ts`:
   - Multi-search endpoint (movies + TV).
   - Map TMDB results → `Show` type (transient, for display).
3. Implement `src/server/catalog/detail.ts`:
   - Movie detail + credits + videos + recommendations + similar + providers.
   - TV detail + credits + seasons + videos + recommendations + similar + providers.
4. Implement `src/server/catalog/person.ts`:
   - Person detail + combined credits (filmography).
5. Implement `src/utils/catalog-mapper.ts`:
   - TMDB JSON → `Show` type mapping following the field mapping rules from `storage-schema.md`.
   - Handle image URL construction, genre ID → name mapping, date parsing.

#### 4.7 Show Service (Business Logic)

1. Implement `src/server/services/show-service.ts` with these operations:

   **Save/Update show:**
   - Accept external catalog ID + optional user data mutations.
   - Fetch fresh catalog data from TMDB.
   - If show exists in DB: merge catalog data using the merge policy from `storage-schema.md`:
     - Non-my fields: `selectFirstNonEmpty(new, old)` — never overwrite with empty/nil.
     - My fields: resolve by update-date timestamp (newer wins).
     - Set `details_update_date = now()`.
   - If show doesn't exist: create with `creation_date = now()`.
   - Apply saving triggers from PRD §5.2–5.3:
     - Setting status → save.
     - Choosing interest chip → save with `status=Later`, `interest=chosen`.
     - Rating unsaved show → save with `status=Done`.
     - Adding tag to unsaved show → save with `status=Later`, `interest=Interested`.

   **Remove show:**
   - Validate user confirmation flow (client responsibility, but server clears all my-data).
   - Delete row from `shows` table.
   - Only scoped to `(namespace_id, user_id)`.

   **List shows (collection):**
   - Query by `(namespace_id, user_id)` with optional filters.
   - Support filtering by: `my_status`, genre, decade, community score range, `my_tags`, media type (`show_type`).
   - Return sorted by status groups: Active → Excited → Interested → Other.

   **Get single show:**
   - Fetch from DB if exists (user-overlay version).
   - Otherwise fetch from catalog (no user data).

2. Implement `src/utils/merge-show.ts` with pure merge logic, unit-tested against edge cases.

#### 4.8 API Routes — Shows & Catalog

1. `GET /api/shows` — list user's collection with filter support.
2. `POST /api/shows` — save/update a show (triggers catalog fetch + merge).
3. `GET /api/shows/[id]` — get single show (DB first, fallback catalog).
4. `PUT /api/shows/[id]` — update user data on a saved show.
5. `DELETE /api/shows/[id]` — remove show from collection.
6. `GET /api/search?q=...&page=...` — proxy catalog search.
7. `GET /api/catalog/[id]?type=movie|tv` — proxy catalog detail (with credits, seasons, providers).

---

### Phase 3: UI Foundation & Collection Home (Week 3)

#### 4.9 Shared UI Components

Build reusable components in `src/components/`:

1. **`ShowTile`** — poster image + title + in-collection badge + rating badge. Used everywhere shows appear.
2. **`RatingBar`** — interactive rating slider (0–10 scale).
3. **`StatusChips`** — row of status buttons (Active, Interested, Excited, Done, Quit, Wait). Handles the Interested/Excited → Later+Interest mapping.
4. **`TagPicker`** — tag input with autocomplete from existing tag library.
5. **`ConceptChips`** — selectable concept chip list for Explore Similar / Alchemy.
6. **`ChatBubble`** — styled message bubble for Ask UI.
7. **`MediaCarousel`** — backdrop/poster/logo/video carousel for show detail header.
8. **`FilterSidebar`** — sidebar with All Shows, tag filters, genre/decade/score filters, media type toggle.
9. **`EmptyState`** — illustration + message + CTA for empty collections/views.

All components follow the Humble Component pattern: markup and binding only, logic extracted to hooks.

#### 4.10 Theme & Design Tokens

1. Implement `src/theme/tokens.ts` with color palette, spacing scale, border radii.
2. Implement `src/theme/font-sizes.ts` mapping `XS/S/M/L/XL/XXL` to Tailwind classes.
3. Implement `src/theme/components.ts` with reusable class compositions.
4. Font size setting (from Settings) is applied globally via context.

#### 4.11 Collection Home Page

1. **Route:** `/` (home page).
2. **Layout:** FilterSidebar (left/top) + main content area.
3. **Main content:** Status-grouped show grid:
   - Section: **Active** (larger tiles, prominent).
   - Section: **Excited** (Later + Excited interest).
   - Section: **Interested** (Later + Interested interest).
   - Section: **Other** (collapsed: Wait, Quit, Done, unclassified Later).
4. **Media type toggle:** All / Movies / TV — applies as overlay filter.
5. **Empty states:**
   - No collection → prompt to Search/Ask.
   - Filter yields nothing → "No results found."

**Hooks:**
- `useCollectionShows(filter)` — React Query hook fetching `GET /api/shows?filter=...`.
- `useFilterState()` — manages active filter, persists `lastSelectedFilter` to local storage.

---

### Phase 4: Show Detail Page (Week 4)

#### 4.12 Show Detail Page

**Route:** `/show/[id]`

Implement features in narrative hierarchy order (from `detail_page_experience.md`):

1. **`HeaderMedia`** — Carousel of backdrops, posters, logos, and inline trailer playback (when available). Graceful fallback to poster-only.

2. **`CoreFacts`** — Year, runtime or seasons/episodes, community score bar.

3. **`StatusControls`** (toolbar):
   - Status chip row: Active / Interested / Excited / Done / Quit / Wait.
   - Selecting Interested/Excited → sets `myStatus=Later` + `myInterest`.
   - Reselecting current status → triggers removal confirmation dialog.
   - Post-confirmation: calls `DELETE /api/shows/[id]` which clears all My Data.

4. **`RatingControl`** — Interactive rating bar. Rating an unsaved show auto-saves as `Done`.

5. **`TagSection`** — Display tags + picker. Adding tag to unsaved show auto-saves as `Later + Interested`.

6. **Overview text.**

7. **`ScoopSection`** — Toggle "Give me the scoop!" / "Show the scoop" / title "The Scoop":
   - Streams progressively from `POST /api/ai/scoop`.
   - Freshness: if `ai_scoop_update_date` is > 4 hours ago, regenerate.
   - Persisted only if show is in collection; otherwise ephemeral (client state only).

8. **"Ask about this show" CTA** — Navigates to Find → Ask with show context seeded.

9. **Genres + languages row.**

10. **`Recommendations`** — Horizontal strand of similar/recommended shows from catalog.

11. **`ExploreSimilar`** — Three-step flow:
    - "Get Concepts" → fetch concepts via `POST /api/ai/concepts`.
    - Concept chips appear → user selects 1+.
    - "Explore Shows" → fetch recs via `POST /api/ai/recommendations`.
    - Displays 5 recommended shows.

12. **`StreamingProviders`** — Provider logos by region (using provider_data + TMDB provider metadata).

13. **`CastCrew`** — Horizontal strand of cast/crew headshots + names → links to Person Detail.

14. **`SeasonsSection`** (TV only) — Expandable seasons list with episode counts.

15. **`BudgetRevenue`** (movies only) — Budget vs revenue display.

**Hooks:**
- `useShowDetail(id)` — React Query hook for show data (DB + catalog merge).
- `useSaveShow()` — Mutation hook for saving/updating user data.
- `useRemoveShow()` — Mutation hook with confirmation state.
- `useScoop(showId)` — Manages scoop generation, streaming state, freshness check.

---

### Phase 5: Find/Discover Hub (Week 5)

#### 4.13 Find/Discover Hub

**Route:** `/find`

Mode switcher at top: **Search** | **Ask** | **Alchemy**

#### 4.14 Search Mode

1. Text input for title/keyword search.
2. Results displayed as poster grid via `ShowTile`.
3. In-collection items show badge.
4. Selecting a show navigates to `/show/[id]`.
5. Auto-open on launch if `autoSearch` setting is true.

**Hooks:**
- `useCatalogSearch(query, page)` — React Query hook for `GET /api/search`.

#### 4.15 Ask Mode

1. **Welcome view** (no active conversation): 6 random starter prompts from a curated list of 80, with refresh button.
2. **Chat UI:** User/assistant message bubbles.
3. **Mentioned shows strip:** Horizontal row of show tiles parsed from AI output's `showList`.
4. **Tapping a mentioned show** → navigates to `/show/[id]` or falls back to Search.

**AI contract:**
- `POST /api/ai/ask` sends: `{ message, conversationHistory[], userLibrary?, showContext? }`.
- Response: `{ commentary: string, showList: string }` where `showList` format is `Title::externalId::mediaType;;...`.
- Client parses `showList` into structured objects for the mentioned shows strip.
- Conversation summarization: after ~10 messages, older turns are summarized server-side (1–2 sentences, preserving persona tone).

**Variants:**
- **General Ask:** started from `/find`.
- **Ask About a Show:** navigated from Show Detail. Seeds `showContext` with current show data.

**Hooks:**
- `useAskChat()` — manages chat state, message sending, mentioned shows extraction.
- `useStarterPrompts()` — randomizes and manages starter prompt display.

#### 4.16 Alchemy Mode

Multi-step wizard UI:

1. **Step 1 — Select Shows:** User picks 2+ shows (from library or search). Display as selected tiles.
2. **Step 2 — Conceptualize:** Button "Conceptualize Shows" → `POST /api/ai/concepts` with `{ shows[], type: "multi" }`.
3. **Step 3 — Select Concepts:** Concept chips appear; user selects 1–8.
4. **Step 4 — Alchemize:** Button "ALCHEMIZE!" → `POST /api/ai/recommendations` with `{ shows[], concepts[], count: 6 }`.
5. **Step 5 — Results:** 6 recommended shows with reasons. Each reason names which concepts align.
6. **Chain:** "More Alchemy!" button returns to Step 1 with results as available inputs.

**UX:**
- Backtracking allowed: changing shows clears concepts and results.
- Step indicators show progress.
- Empty states nudge toward required actions.

**Hooks:**
- `useAlchemySession()` — manages the full multi-step state machine.

---

### Phase 6: Person Detail & Settings (Week 6)

#### 4.17 Person Detail Page

**Route:** `/person/[id]`

1. **`PersonHeader`** — Image gallery (profile photos), name, bio.
2. **`PersonAnalytics`** — Lightweight charts:
   - Average rating of projects (from community scores).
   - Top genres breakdown.
   - Projects by year histogram.
3. **`Filmography`** — Credits grouped by year, sorted by recency. Each credit is a `ShowTile` → navigates to `/show/[id]`.

**Data source:** TMDB person detail + combined credits endpoint, proxied through `GET /api/person/[id]`.

#### 4.18 Settings Page

**Route:** `/settings`

Sections:

1. **Display:** Font size selector (XS–XXL), "Search on Launch" toggle.
2. **User:** Username editor (synced if enabled).
3. **AI:** AI provider API key input (server-stored, never committed), model selector dropdown.
4. **Integrations:** Catalog API key input (server-stored).
5. **Your Data:**
   - "Export My Data" button → `GET /api/export` → downloads `.zip` containing JSON of all saved shows + My Data. Dates ISO-8601.
   - Import/Restore: placeholder (listed in Open Questions).

**Hooks:**
- `useCloudSettings()` — React Query hook for settings CRUD.
- `useLocalSettings()` — Client-side hook for font size, autoSearch, etc.
- `useExportData()` — Triggers ZIP download.

---

### Phase 7: AI Services (Week 7)

#### 4.19 AI Service Architecture

All AI calls go through server routes. The AI provider is abstracted behind a common interface so model swaps require config changes only.

**Shared inputs assembly:** Before each AI call, the server assembles:
- User's library (saved shows with My Data) as taste context.
- Current show context (for Ask-about-show, Scoop).
- Selected concepts (for Explore Similar, Alchemy).
- Recent conversation turns (for Ask), with summarization of older turns.

#### 4.20 Scoop Service

1. **Input:** Show object (full detail), user library (optional, for taste-awareness).
2. **Prompt design** (from `ai_voice_personality.md` + `ai_prompting_context.md`):
   - System prompt establishes persona: fun, chatty TV/movie nerd friend.
   - Structured output: personal take → honest stack-up → "The Scoop" (emotional centerpiece) → fit/warnings → verdict.
   - Spoiler-safe by default.
   - ~150–350 words.
3. **Streaming:** Server streams response via ReadableStream; client renders progressively.
4. **Caching:** Store `ai_scoop` + `ai_scoop_update_date` in DB. Regenerate if stale (> 4 hours).
5. **Persistence rule:** Only persist to DB if show is in user's collection. Otherwise, return ephemeral to client.

#### 4.21 Ask Service

1. **Input:** User message, conversation history, user library, optional show context.
2. **Prompt design:**
   - System prompt: same persona, conversational tone, taste-aware.
   - Ask for structured output: `{ commentary, showList }`.
   - `showList` format: `Title::externalId::mediaType;;...`.
3. **Conversation summarization:** After ~10 messages, summarize older turns into 1–2 sentences preserving persona tone.
4. **Fallback:** If `showList` parsing fails, retry once with stricter formatting; otherwise show commentary + Search handoff.

#### 4.22 Concept Service

1. **Input:** 1 show (Explore Similar) or 2+ shows (Alchemy).
2. **Prompt design:**
   - Generate short bullet list of 1–3 word evocative concepts.
   - For multi-show: concepts must represent shared commonality.
   - Avoids generic concepts ("good characters," "great story").
   - No plot details, no spoilers.
   - Default: 8 concepts.
3. **Output:** Array of concept strings.

#### 4.23 Recommendation Service

1. **Input:** Source shows + selected concepts + count (5 for Explore, 6 for Alchemy).
2. **Prompt design:**
   - Recommend real shows with concise reasons.
   - Reasons must explicitly reference selected concepts.
   - Output includes: title, external ID, media type, reason.
3. **Resolution:** Each recommendation's external ID is looked up in TMDB to verify it maps to a real show. If found → render as selectable `ShowTile`. If not found → show as non-interactive text or hand off to Search.

---

### Phase 8: Filters, Tags, & Polish (Week 8)

#### 4.24 Filter System

1. **Filter types** (from `storage-schema.md`):
   - `all` — All Shows (default).
   - `myTag` — one per tag in user's tag library + "No tags" if any tagless shows exist.
   - `genre` — populated from show genres in collection.
   - `decade` — derived from release/first air dates.
   - `communityScore` — ranges (e.g., 0–3, 3–5, 5–7, 7–8.5, 8.5–10).
   - `myStatus` — optional (listed in Open Questions).
2. **Media type toggle** (All / Movies / TV) applies as overlay on any filter.
3. **Tag library:** Dynamically built from all `my_tags` across user's shows.
4. **Persistence:** `lastSelectedFilter` stored in local settings.

**Implementation:**
- `FilterSidebar` component renders available filters.
- Server-side filtering via query params on `GET /api/shows`.
- `useFilterState()` hook manages active filter + media type toggle.

#### 4.25 Export/Backup

1. **`GET /api/export`:**
   - Query all shows for `(namespace_id, user_id)`.
   - Build JSON structure matching `StorageSnapshot` type (shows + settings + metadata).
   - Use `archiver` to create `.zip` containing `data.json`.
   - Dates encoded ISO-8601.
   - Stream ZIP as download response.

#### 4.26 Data Continuity & Migrations

1. **Migration strategy:**
   - `app_metadata.data_model_version` tracks current schema version.
   - On app startup, server checks version and applies pending migrations.
   - Migrations are additive and non-destructive.
   - User data is preserved across updates (PRD §5.11).
2. **Field-level timestamps** enable cloud sync conflict resolution (newer wins per field).

#### 4.27 Test Infrastructure

1. **Unit tests** (Vitest):
   - `merge-show.test.ts` — comprehensive merge/overwrite policy tests.
   - `show-service.test.ts` — save triggers, defaults, removal behavior.
   - `concept-service.test.ts` — concept generation quality.
   - `catalog-mapper.test.ts` — TMDB → Show mapping edge cases.
   - `export-data.test.ts` — export snapshot correctness.
2. **Component tests** (React Testing Library):
   - `ShowTile` — badge rendering.
   - `StatusChips` — status selection → correct state.
   - `FilterSidebar` — filter application.
3. **E2E tests** (Playwright):
   - Build collection flow (search → save → verify).
   - Rate-to-save flow.
   - Tag-to-save flow.
   - Ask conversation flow.
   - Alchemy flow.
   - Export flow.
4. **Test reset:** `npm run test:reset` script:
   - Deletes all rows in `shows` where `namespace_id = ? AND is_test = true`.
   - Resets test user's `cloud_settings`.
   - Does not touch other namespaces.

---

## 5. Cross-Cutting Concerns

### 5.1 Identity & Isolation Implementation

```
Request → Middleware
              ├─ Read NAMESPACE_ID from env (stable per build)
              ├─ Resolve user_id:
              │   ├─ Dev: X-User-Id header → validated
              │   ├─ Dev: fallback → DEFAULT_USER_ID from env
              │   └─ Prod: (future) OAuth session → user_id
              └─ Attach { namespace_id, user_id } to request context
                    ↓
              All service calls receive identity context
              All Supabase queries scoped to (namespace_id, user_id)
```

**Production migration path:** Replace the dev identity resolver with an OAuth session reader. The `(namespace_id, user_id)` partition key stays the same. No schema redesign needed.

### 5.2 Error Handling & Edge Cases

| Scenario | Behavior |
|---|---|
| Network failure during catalog fetch | Show cached data if available; display "refresh unavailable" state |
| AI provider timeout/error | Retry once; show friendly error message |
| Structured AI output parse failure | Retry with stricter formatting; fallback to unstructured + Search |
| Show not found in catalog | Display last-known data; mark as "unavailable" |
| Duplicate show save | Merge using timestamp-based conflict resolution |
| Invalid user action (e.g., tag on unsavable item) | Graceful error toast |

### 5.3 Performance Considerations

1. **React Query caching:** Show data cached by ID. Stale-while-revalidate for collection views.
2. **Image optimization:** Use Next.js `<Image>` with TMDB image URLs; configure remote patterns.
3. **Lazy loading:** Show Detail below-fold sections loaded on scroll intersection.
4. **Debounced search:** 300ms debounce on search input.
5. **Streaming AI:** Progressive rendering for Scoop and Ask responses.

### 5.4 Security

1. **API keys:** AI and catalog keys are server-only. Never exposed to client.
2. **RLS:** Supabase RLS ensures data isolation even if client is compromised.
3. **Input validation:** Zod schemas on all API route inputs.
4. **Rate limiting:** Apply basic rate limiting on AI endpoints to prevent abuse.
5. **Dev identity:** Only active when `NEXT_PUBLIC_APP_ENV=development`. Disabled in production builds.

---

## 6. Implementation Order Summary

| Phase | Duration | Key Deliverables |
|---|---|---|
| **1. Foundation** | Week 1 | Project scaffold, DB schema, identity/isolation, types, Supabase clients |
| **2. Core Data** | Week 2 | TMDB integration, show service (CRUD + merge), catalog/search API routes |
| **3. Collection Home** | Week 3 | Shared UI components, theme system, filter sidebar, collection home page |
| **4. Show Detail** | Week 4 | Full detail page with all sections, status/rating/tag controls, Scoop |
| **5. Discover Hub** | Week 5 | Find hub, Search mode, Ask mode (chat + mentioned shows), Alchemy mode |
| **6. Person & Settings** | Week 6 | Person detail page, settings page, export/backup |
| **7. AI Services** | Week 7 | Scoop streaming, Ask with mentions, concept extraction, recommendations |
| **8. Polish & Tests** | Week 8 | Filter system completion, E2E tests, migration hardening, test reset |

> **Note:** AI services (Phase 7) are designed to be developed in parallel with Phases 5–6 since they are server-side concerns with clear API contracts. The UI can be built with mock AI responses initially.

---

## 7. Risk Mitigation

| Risk | Mitigation |
|---|---|
| TMDB API rate limits | Server-side caching of catalog responses; respectful request spacing |
| AI hallucinating show titles | External ID resolution against real catalog; fallback to non-interactive display |
| Merge conflicts on re-add | Per-field timestamp comparison; deterministic newer-wins |
| Schema migration breaks user data | Migrations are additive; `dataModelVersion` gating; automated test verification |
| AI prompt drift across rebuilds | Prompt contracts documented in code with expected output schemas; regression tests |
| Namespace collision in CI | Unique `NAMESPACE_ID` per CI run; test data marked `is_test=true` for cleanup |

---

## 8. Success Criteria Checklist

Compliance with the Infrastructure Rider §9:

- [ ] `.env.example` provided; app configurable without code edits
- [ ] `.gitignore` excludes `.env*` (except `.env.example`)
- [ ] One-command: `npm run dev` starts the app
- [ ] One-command: `npm test` runs tests
- [ ] One-command: `npm run test:reset` resets test data per namespace
- [ ] Repeatable schema via migrations
- [ ] Namespace isolation: no cross-namespace data leakage
- [ ] All user-owned records scoped to `user_id`
- [ ] Destructive testing without global teardown
- [ ] Real OAuth migration path without schema redesign
- [ ] Browser code uses anon/public key only; service role server-side only
