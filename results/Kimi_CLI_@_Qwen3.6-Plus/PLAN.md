# Implementation Plan: Personal TV + Movie Companion

## 1. Architecture Overview

### 1.1 Stack
- **Frontend + Server Boundary:** Next.js (latest stable, App Router)
- **Persistence Layer:** Supabase (PostgreSQL) via official `@supabase/supabase-js` client
- **AI Integration:** OpenAI-compatible API via server-side Route Handlers (provider-agnostic, configurable via env)
- **External Content Catalog:** TMDB-like API (configurable via env)
- **Styling:** Tailwind CSS
- **Testing:** Vitest + Playwright (or Next.js built-in testing)

### 1.2 Architectural Pattern
```
┌─────────────────────────────────────────────────┐
│                   Next.js App                    │
│  ┌───────────────┐  ┌─────────────────────────┐ │
│  │  Client Pages  │  │   Server Route Handlers │ │
│  │  (RSC + CSR)   │  │   (AI, Auth, Export)   │ │
│  └───────┬───────┘  └──────────┬──────────────┘ │
│          │                     │                 │
│  ┌───────┴─────────────────────┴──────────────┐ │
│  │          Data Access Layer (Server)        │ │
│  │  Supabase Client (server-side + client)    │ │
│  └──────────────────┬─────────────────────────┘ │
└─────────────────────┼───────────────────────────┘
                      │
         ┌────────────┴────────────┐
         │                         │
   ┌─────┴──────┐          ┌──────┴─────┐
   │  Supabase  │          │  External   │
   │  Database  │          │  Catalog    │
   │            │          │  API (TMDB) │
   └────────────┘          └─────────────┘
```

### 1.3 Multi-Tenancy Model
- **Namespace isolation:** Every query is filtered by `(namespace_id, user_id)`
- **Dev auth:** `X-User-Id` header injection in dev/test mode, gated behind `NODE_ENV !== 'production'`
- **Default user:** A configurable fallback `user_id` when no header is provided

---

## 2. Database Schema (Supabase / PostgreSQL)

### 2.1 Tables

#### `namespace_metadata`
- `id` (uuid, PK) — the namespace/run identifier
- `data_model_version` (int, default 3) — for migration tracking
- `created_at` (timestamptz)

#### `shows`
Core table combining catalog metadata + user data, scoped to namespace + user.

| Column | Type | Notes |
|--------|------|-------|
| `id` | text | composite key: `{namespace_id}/{user_id}/{show_external_id}` |
| `namespace_id` | uuid, FK | required — partitions data |
| `user_id` | text | required — scopes to user |
| `title` | text | required |
| `show_type` | text | movie \| tv \| person \| unknown |
| `external_ids` | jsonb | catalog identifiers map |
| `overview` | text | |
| `genres` | text[] | genre name strings |
| `tagline` | text | |
| `homepage` | text | |
| `original_language` | text | |
| `spoken_languages` | text[] | ISO 639-1 codes |
| `languages` | text[] | |
| `poster_url` | text | |
| `backdrop_url` | text | |
| `logo_url` | text | |
| `vote_average` | float | |
| `vote_count` | int | |
| `popularity` | float | |
| `last_air_date` | timestamptz | |
| `first_air_date` | timestamptz | |
| `release_date` | timestamptz | |
| `runtime` | int | movies only |
| `budget` | bigint | movies only |
| `revenue` | bigint | movies only |
| `series_status` | text | TV only |
| `num_episodes` | int | TV only |
| `num_seasons` | int | TV only |
| `episode_run_time` | int[] | TV only |
| `provider_data` | jsonb | streaming provider IDs by region |
| — **User data** — | | |
| `my_status` | text | active \| next \| later \| done \| quit \| wait |
| `my_status_updated_at` | timestamptz | |
| `my_interest` | text | interested \| excited |
| `my_interest_updated_at` | timestamptz | |
| `my_tags` | text[] | free-form user tags |
| `my_tags_updated_at` | timestamptz | |
| `my_score` | float | user rating |
| `my_score_updated_at` | timestamptz | |
| `ai_scoop` | text | AI-generated description |
| `ai_scoop_updated_at` | timestamptz | |
| — **Management** — | | |
| `details_updated_at` | timestamptz | catalog refresh timestamp |
| `created_at` | timestamptz | first creation |
| `is_test` | boolean | default false |

Composite unique constraint: `(namespace_id, user_id, id)`

RLS policies: All tables scoped by `namespace_id` and `user_id` via Row Level Security.

#### `cloud_settings`
| Column | Type | Notes |
|--------|------|-------|
| `id` | text | default "globalSettings" |
| `namespace_id` | uuid, FK | |
| `user_id` | text | |
| `user_name` | text | |
| `version` | float | epoch seconds for conflict resolution |
| `catalog_api_key` | text | |
| `ai_api_key` | text | |
| `ai_model` | text | |

#### `app_metadata` (per namespace)
| Column | Type |
|--------|------|
| `namespace_id` | uuid, PK |
| `data_model_version` | int |

### 2.2 Migrations
- `supabase/migrations/001_initial_schema.sql` — full table creation, RLS policies, indexes
- `supabase/migrations/002_seed_data.sql` — optional fixtures
- Migration runner: Supabase CLI `supabase db push` or application-level migration check on startup

---

## 3. Project Structure

```
/
├── .env.example
├── .gitignore
├── next.config.ts
├── package.json
├── tsconfig.json
├── tailwind.config.ts
├── supabase/
│   ├── migrations/
│   │   ├── 001_initial_schema.sql
│   │   └── 002_seed_data.sql
│   └── config.toml
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── layout.tsx          # Root layout with providers
│   │   ├── page.tsx            # Collection Home (default)
│   │   ├── (auth)/
│   │   │   └── dev-login/      # Dev identity injection UI
│   │   ├── (discover)/
│   │   │   ├── layout.tsx      # Discover shell layout
│   │   │   ├── page.tsx        # Discover hub (mode switcher)
│   │   │   ├── search/
│   │   │   │   └── page.tsx    # Search mode
│   │   │   ├── ask/
│   │   │   │   └── page.tsx    # Ask chat mode
│   │   │   └── alchemy/
│   │   │       └── page.tsx    # Alchemy mode
│   │   ├── show/
│   │   │   └── [id]/
│   │   │       └── page.tsx    # Show Detail
│   │   ├── person/
│   │   │   └── [id]/
│   │   │       └── page.tsx    # Person Detail
│   │   ├── settings/
│   │   │   └── page.tsx        # Settings & Your Data
│   │   └── api/                # Route Handlers
│   │       ├── auth/           # Dev identity middleware
│   │       ├── ai/
│   │       │   ├── scoop/      # POST /api/ai/scoop
│   │       │   ├── ask/        # POST /api/ai/ask (chat)
│   │       │   ├── concepts/   # POST /api/ai/concepts
│   │       │   └── recommendations/ # POST /api/ai/recommendations
│   │       ├── search/         # Proxy to external catalog
│   │       └── export/         # Export My Data (zip)
│   ├── components/
│   │   ├── ui/                 # Reusable primitives (buttons, chips, modals)
│   │   ├── layout/             # Navigation, filters panel, shell
│   │   ├── show/               # ShowCard, ShowTile, ShowGrid
│   │   ├── detail/             # DetailHeader, StatusChips, RatingBar, TagPicker, ScoopSection, etc.
│   │   ├── discover/           # SearchResults, ChatInterface, AlchemyFlow
│   │   ├── person/             # PersonGallery, FilmographyYearGroup, AnalyticsCharts
│   │   └── settings/           # SettingsForm, ExportButton
│   ├── lib/
│   │   ├── supabase/           # Client + server init, RLS helpers
│   │   ├── catalog/            # External catalog client (TMDB adapter)
│   │   ├── ai/                 # AI client (provider-agnostic)
│   │   ├── auth/               # Identity injection, user context
│   │   ├── store/              # Client state (Zustand or React Context)
│   │   ├── hooks/              # Custom hooks (useShow, useCollection, useAI)
│   │   ├── utils/              # Date formatting, merge logic, helpers
│   │   └── constants/          # Status enums, interest types, config
│   ├── types/                  # TypeScript type definitions
│   │   └── show.ts             # ShowType, MyStatusType, Show interface
│   └── middleware.ts           # Identity injection, namespace routing
├── scripts/
│   ├── dev.sh                  # npm run dev wrapper
│   ├── test.sh                 # npm test wrapper
│   └── test-reset.sh          # namespace-scoped test data reset
└── tests/
    ├── unit/                   # Merge logic, defaults, validation
    ├── integration/            # API routes, Supabase queries
    └── e2e/                    # Key user journeys
```

---

## 4. Implementation Phases

### Phase 1: Foundation — Infrastructure & Infrastructure
**Goal:** Get the app running with namespace isolation, dev auth, and Supabase connection.

1. **Initialize Next.js project** with App Router, TypeScript, Tailwind
2. **Set up Supabase** connection (client + server)
3. **Create database schema** via migration files
4. **Implement RLS policies** scoped to `(namespace_id, user_id)`
5. **Build dev identity injection** middleware:
   - Accept `X-User-Id` header in dev/test
   - Provide dev-only "login as user" selector
   - Gate behind `NODE_ENV !== 'production'`
6. **Environment interface:**
   - `.env.example` with all required variables:
     - `NEXT_PUBLIC_SUPABASE_URL`
     - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
     - `SUPABASE_SERVICE_ROLE_KEY` (server only)
     - `CATALOG_API_KEY`
     - `AI_API_KEY`
     - `AI_MODEL`
     - `DEFAULT_NAMESPACE_ID`
     - `DEFAULT_USER_ID`
7. **Scripts:** `npm run dev`, `npm test`, `npm run test:reset` (namespace-scoped)

### Phase 2: External Catalog Integration
**Goal:** Connect to the external content catalog (TMDB-like API).

1. **Catalog client** (`src/lib/catalog/`):
   - Search by title/keywords
   - Fetch show details (movie + TV)
   - Fetch person details
   - Fetch cast/crew, seasons, streaming providers
   - Resolve external IDs
2. **Proxy route handlers** (`/api/search`, `/api/catalog/*`):
   - Server-side proxying (hide API key)
   - Response normalization to internal `Show` type
3. **Merge logic** (`src/lib/utils/merge-show.ts`):
   - `selectFirstNonEmpty` for catalog fields
   - Timestamp-based resolution for `my*` fields
   - `detailsUpdateDate` refresh on merge

### Phase 3: Show Data Model & Persistence Layer
**Goal:** Full CRUD for shows with user data overlay.

1. **TypeScript types** matching the schema (`src/types/show.ts`)
2. **Data access layer** (`src/lib/supabase/`):
   - `getShow(namespaceId, userId, showId)` — fetches + merges catalog data
   - `saveShow(namespaceId, userId, show)` — upserts
   - `removeShow(namespaceId, userId, showId)` — deletes
   - `listShows(namespaceId, userId, filters)` — with filter support
   - `bulkGetShows(namespaceId, userId, showIds[])` — for batch resolution
3. **Saving triggers logic** (`src/lib/utils/saving-triggers.ts`):
   - Status set → save
   - Interest chip → save
   - Rating unsaved show → save as Done
   - Tag on unsaved show → save as Later + Interested
   - Default values: Later/Interested (rating-save → Done)
4. **Status removal flow** with confirmation + "don't ask again" persistence

### Phase 4: Collection Home & Filters
**Goal:** Display the user's library with status grouping and filters.

1. **Filters panel** (sidebar):
   - "All Shows" quick filter
   - Tag filters (dynamically populated from user's tag library)
   - "No tags" filter when tagless shows exist
   - Data filters: genre, decade, community score ranges
   - Media-type toggle: All / Movies / TV
2. **Home view:**
   - Status-grouped sections: Active (large tiles), Excited, Interested, Others (collapsed)
   - Show tiles with poster, title, My Data badges (status, rating indicators)
   - Empty states: no collection → Search/Ask prompt; no filter results → "No results found"
3. **Navigation shell:**
   - Persistent top nav with: Home, Find/Discover, Settings
   - Filter panel + main content area layout

### Phase 5: Show Detail Page
**Goal:** Single source of truth with narrative section order.

Sections in order:
1. **Header media carousel** — backdrops/posters/logos/trailers, graceful fallback
2. **Core facts row** — year, runtime/seasons, community score bar
3. **Tag chips (My Tags)** — displayed inline
4. **Overview text + Scoop toggle/stream** — "Give me the scoop!" / "Show the scoop" toggle
5. **"Ask about this show" CTA** — deep-links to Ask with seeded context
6. **Genres + languages**
7. **Traditional recommendations strand** — similar/recommended shows from catalog
8. **Explore Similar (concepts → recs)** — Get Concepts → select → Explore Shows
9. **Streaming availability ("Stream It")**
10. **Cast, Crew** — horizontal strands → Person Detail
11. **Seasons (TV only)**
12. **Budget/Revenue (movies)**

**Relationship controls** (in toolbar, not scroll body):
- Status/Interest chips: Interested/Excited map to Later + Interest
- Rating bar: rating unsaved show auto-saves as Done
- Tag picker: adding tag to unsaved show auto-saves as Later + Interested
- Reselecting status → removal confirmation

### Phase 6: Search (Find → Search)
**Goal:** Find shows in the global catalog.

1. Text search by title/keywords
2. Poster grid results with in-collection markers
3. Selecting a show opens Detail
4. "Search on Launch" auto-open setting
5. **No AI voice** in Search — straightforward catalog search

### Phase 7: Ask (Find → Ask)
**Goal:** Conversational AI discovery.

1. **Chat UI** with user/assistant turns
2. **Welcome view** with 6 random starter prompts (refreshable)
3. **AI Route Handler** (`/api/ai/ask`):
   - Sends user library context + conversation history
   - Structured output: `commentary` + `showList` in `Title::externalId::mediaType` format
   - Token management: summarize older turns after ~10 messages
4. **Mentioned shows strip** — horizontal row of mentioned shows, tap to open Detail
5. **Ask about a show** — deep-link from Detail seeds conversation with show context
6. **Session-only state** — cleared when leaving Ask

### Phase 8: Alchemy (Find → Alchemy)
**Goal:** Structured concept blending discovery.

1. **Step 1: Select 2+ starting shows** (library + global catalog search)
2. **Step 2: Conceptualize** — POST `/api/ai/concepts` with multiple shows
   - Returns shared concepts (larger pool for multi-show)
3. **Step 3: Select concepts** (max 8 chips)
4. **Step 4: Alchemize** — POST `/api/ai/recommendations` with concepts
   - Returns 6 recommendations with reasons
5. **Chaining** — "More Alchemy!" uses results as new inputs
6. **Backtracking** — changing shows clears concepts + results
7. **Session-only state** — cleared when leaving Alchemy

### Phase 9: Explore Similar (Per-Show Concepts)
**Goal:** Concept discovery from a single show's Detail.

1. **Get Concepts** button — POST `/api/ai/concepts` with single show
   - Returns 8 concept chips
2. **Select 1+ concepts**
3. **Explore Shows** — POST `/api/ai/recommendations`
   - Returns 5 recommendations with reasons citing selected concepts
4. Flow matches Alchemy concept system but per-show

### Phase 10: AI Scoop System
**Goal:** Personality-driven show taste review.

1. **Generate on demand** from Detail page
2. **Progressive streaming** — "Generating..." placeholder, streams in
3. **Caching:** 4-hour freshness TTL
4. **Persistence:** Only persisted if show is in collection
5. **Structure:** Personal take → Honest stack-up → The Scoop (centerpiece) → Fit/Warnings → Verdict
6. **Length target:** ~150-350 words

### Phase 11: Person Detail
**Goal:** Explore talent behind shows.

1. Image gallery, name, bio
2. Analytics charts (ratings, genres, projects-by-year)
3. Filmography grouped by year
4. Selecting a credit opens that show's Detail

### Phase 12: Settings & Export
**Goal:** App settings and data portability.

1. **App settings:**
   - Font size selector (XS/S/M/L/XL/XXL)
   - "Search on Launch" toggle
2. **User settings:**
   - Username
3. **AI settings:**
   - AI provider API key (never committed)
   - AI model selection
4. **Integrations:**
   - Content catalog API key
5. **Your Data — Export:**
   - "Export My Data" → generates `.zip` with JSON backup
   - All saved shows + My Data
   - Dates encoded as ISO-8601
6. **Import/Restore** — noted as future (open question in PRD)

### Phase 13: AI Voice & Personality Integration
**Goal:** Consistent AI persona across all surfaces.

1. **Shared base prompt** — "fun, chatty TV/movie nerd friend"
2. **Surface-specific variations:**
   - Scoop: mini blog-post of taste, ~150-350 words
   - Ask: dialogue-like, 1-3 paragraphs + bullet lists
   - Concepts: 1-3 word evocative bullets only
   - Recommendations: excited friend tone, 1-3 sentence reasons
3. **Shared guardrails:**
   - TV/movies domain only (redirect if asked otherwise)
   - Spoiler-safe by default
   - Opinionated and honest
   - Vibe-first reasoning over generic genre summaries
4. **Conversation summarization:** older turns → 1-2 sentences, same persona voice

### Phase 14: Testing & Quality
**Goal:** Comprehensive test coverage and quality validation.

1. **Unit tests:**
   - Merge logic (selectFirstNonEmpty, timestamp resolution)
   - Saving triggers and defaults
   - Status removal flow
   - AI output parsing (mention format validation)
2. **Integration tests:**
   - API routes (AI, search, export)
   - Supabase queries (scoped to namespace)
3. **E2E tests** (key user journeys):
   - Build collection (Search → Interested → tag → rate)
   - Rate-to-save (rating unsaved → Done)
   - Tag-to-save (tagging unsaved → Later + Interested)
   - Maintain collection (Home → Detail → update)
   - Tag-driven organization (add tags → filter by tag)
   - Ask discovery (Ask → recommendation → save)
   - Explore Similar (Detail → Get Concepts → select → save)
   - Alchemy (pick shows → Conceptualize → select → Alchemize → chain)
   - Talent deep-dive (Detail → Person → credit → Detail)
   - Backup (Settings → Export → validate zip)
   - Destructive test reset (namespace-scoped cleanup)

---

## 5. Key Cross-Cutting Concerns

### 5.1 Data Consistency
- **User version takes precedence everywhere** — My Data never overwritten by catalog refresh
- **Conflict resolution** — per-field timestamp comparison (winner: newest)
- **"Select first non-empty"** — never overwrite non-empty catalog data with empty
- **Backend is source of truth** — client caching is disposable

### 5.2 Data Migration
- `app_metadata.dataModelVersion` tracks schema version
- On upgrade, existing shows are migrated to new model transparently
- User data (status, tags, rating, interest, Scoop) preserved through migrations

### 5.3 AI Provider Abstraction
- Provider-agnostic AI client layer
- Configurable via `AI_API_KEY` and `AI_MODEL` env vars
- Supports any OpenAI-compatible endpoint
- Provider switching requires only config change

### 5.4 Security
- Secrets never committed (`.env*` in `.gitignore`)
- Supabase anon key for browser, service role key server-only
- Dev auth gated behind environment check
- Real OAuth migration path: config + auth wiring only, no schema redesign needed

---

## 6. Deliverables Checklist

- [ ] `.env.example` with all required variables + comments
- [ ] `.gitignore` excluding `.env*` secrets
- [ ] `supabase/migrations/001_initial_schema.sql` — complete schema + RLS
- [ ] Scripts: `npm run dev`, `npm test`, `npm run test:reset`
- [ ] Next.js App Router full application
- [ ] Collection Home (status-grouped, filtered)
- [ ] Search (catalog, no AI voice)
- [ ] Ask (chat, structured mentions, starter prompts, summarization)
- [ ] Alchemy (multi-show concepts, chaining)
- [ ] Explore Similar (per-show concepts)
- [ ] Show Detail (full narrative section order)
- [ ] Person Detail (gallery, analytics, filmography)
- [ ] Settings (font, search-on-launch, AI key/model, export)
- [ ] Export My Data (zip with JSON, ISO-8601 dates)
- [ ] AI Scoop system (streaming, caching, persistence rules)
- [ ] Consistent AI persona across all surfaces
- [ ] Test suite (unit + integration + E2E)
