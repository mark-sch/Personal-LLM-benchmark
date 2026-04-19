# Implementation Plan: Personal TV + Movie Companion App

## 1. Product Overview

A personal TV/movie companion app for collecting, organizing, rating, and discovering entertainment. Users build a personal library with statuses, interest levels, tags, ratings, and AI-generated insights. Discovery is powered by three paths: traditional search/browse, conversational AI (Ask), and concept-based blending (Alchemy + Explore Similar).

**Tech Stack (Benchmark Baseline):**
- **Frontend:** Next.js (latest stable) — serves as both UI framework and server boundary
- **Backend/Persistence:** Supabase (hosted or local) — PostgreSQL with Row Level Security
- **AI:** External LLM API (configurable provider/model via Settings)
- **Content Catalog:** External TV/movie database API (configurable via Settings)

---

## 2. Architecture Overview

```
┌──────────────────────────────────────────────────────┐
│                    Next.js App                       │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────┐ │
│  │  Home    │ │  Find    │ │  Detail  │ │Settings │ │
│  │  Library │ │  (Search │ │  (Show   │ │  & Data │ │
│  │          │ │   Ask    │ │   Person)│ │ Export  │ │
│  │          │ │  Alchemy │ │          │ │         │ │
│  └──────────┘ └──────────┘ └──────────┘ └─────────┘ │
│       │              │               │               │
│  ┌────┴───────────────┴───────────────┴─────────┐   │
│  │         Next.js API Routes (Server)           │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────────┐  │   │
│  │  │Catalog   │ │ AI/LLM   │ │ Show CRUD    │  │   │
│  │  │Proxy     │ │Proxy     │ │ + Merge Logic│  │   │
│  │  └──────────┘ └──────────┘ └──────────────┘  │   │
│  └─────────────────────────┬─────────────────────┘   │
└─────────────────────────────┬───────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    │   Supabase DB     │
                    │   (PostgreSQL)    │
                    │   + RLS Policies  │
                    └───────────────────┘
```

**Key Architectural Decisions:**

1. **Server-side data ownership.** All user-owned data lives in Supabase. Clients may cache but correctness never depends on local persistence.
2. **API routes as a single backend boundary.** Next.js API routes proxy to external catalog APIs, AI providers, and handle all database operations.
3. **Namespace isolation via `namespace_id`** on all persisted records for benchmark run isolation.
4. **Opaque `user_id`** on all user-owned records, supporting future OAuth migration without schema changes.
5. **Field-level merge rules** for catalog refreshes and cloud sync, using per-field timestamps.

---

## 3. Database Schema

### 3.1 Tables

All tables include `namespace_id TEXT NOT NULL` for run isolation.

#### `users`
```
id           TEXT PRIMARY KEY     -- opaque stable string (UUID or config-injected)
namespace_id TEXT NOT NULL
username     TEXT DEFAULT gen_random_uuid()::text
created_at   TIMESTAMPTZ DEFAULT NOW()
```

#### `shows`
```
id                  TEXT PRIMARY KEY       -- catalog external ID
namespace_id        TEXT NOT NULL
user_id             TEXT NOT NULL REFERENCES users(id)

-- Catalog data (public, refreshed)
title               TEXT NOT NULL
show_type           TEXT NOT NULL CHECK (show_type IN ('movie','tv','person','unknown'))
overview            TEXT
genres              TEXT[] DEFAULT '{}'
tagline             TEXT
homepage            TEXT
original_language   TEXT
spoken_languages    TEXT[] DEFAULT '{}'
languages           TEXT[] DEFAULT '{}'
poster_url          TEXT
backdrop_url        TEXT
logo_url            TEXT
vote_average        DOUBLE PRECISION
vote_count          INTEGER
popularity          DOUBLE PRECISION
first_air_date      DATE
release_date        DATE
last_air_date       DATE
runtime             INTEGER
budget              BIGINT
revenue             BIGINT
series_status       TEXT
number_of_episodes  INTEGER
number_of_seasons   INTEGER
episode_run_time    INTEGER[] DEFAULT '{}'
provider_data       JSONB                  -- opaque provider IDs blob

-- User overlay ("My Data")
my_status           TEXT CHECK (my_status IN ('active','next','later','done','quit','wait'))
my_status_update_date TIMESTAMPTZ
my_interest         TEXT CHECK (my_interest IN ('excited','interested'))
my_interest_update_date TIMESTAMPTZ
my_tags             TEXT[] DEFAULT '{}'
my_tags_update_date   TIMESTAMPTZ
my_score            DOUBLE PRECISION
my_score_update_date  TIMESTAMPTZ

-- AI data
ai_scoop            TEXT
ai_scoop_update_date TIMESTAMPTZ

-- Management
details_update_date TIMESTAMPTZ
creation_date       TIMESTAMPTZ DEFAULT NOW()
is_test             BOOLEAN DEFAULT FALSE
```

#### `cloud_settings`
```
id                  TEXT PRIMARY KEY DEFAULT 'globalSettings'
namespace_id        TEXT NOT NULL
user_id             TEXT NOT NULL
version             BIGINT                 -- epoch seconds for conflict resolution
user_name           TEXT
catalog_api_key     TEXT
ai_api_key          TEXT
ai_model            TEXT DEFAULT 'default'
```

#### `app_metadata`
```
namespace_id        TEXT PRIMARY KEY
data_model_version  INTEGER DEFAULT 3
```

#### `local_settings` (stored in Supabase for sync, or localStorage fallback)
```
namespace_id        TEXT NOT NULL
user_id             TEXT NOT NULL
auto_search         BOOLEAN DEFAULT FALSE
font_size           TEXT DEFAULT 'M'
```

#### `ui_state`
```
namespace_id        TEXT NOT NULL
user_id             TEXT NOT NULL
hide_status_removal_confirmation BOOLEAN DEFAULT FALSE
status_removal_count  INTEGER DEFAULT 0
last_selected_filter  JSONB                -- FilterConfiguration
```

### 3.2 Indexes & Constraints
- Unique index: `(namespace_id, user_id, id)` on `shows` — prevents duplicates per user
- Index: `shows(namespace_id, user_id, my_status)` — for collection home filtering
- Index: `shows(namespace_id, user_id, my_tags_update_date)` — for recently updated sorting
- Index: `users(namespace_id)` — for namespace-scoped queries
- RLS policies on all user-owned tables scoped by `namespace_id` + `user_id`

### 3.3 Migration Strategy
- Use Supabase's migration system (or equivalent: e.g., Drizzle Kit, Prisma Migrate)
- Each migration is a SQL file with idempotent `CREATE TABLE IF NOT EXISTS` / `ALTER TABLE` statements
- `data_model_version` in `app_metadata` tracks schema evolution
- Migration logic: on app bootstrap, compare `data_model_version` against expected, run necessary upgrades

---

## 4. Application Structure (Next.js)

```
src/
├── app/                          # App Router (pages, layouts)
│   ├── layout.tsx                # Root layout with Provider wrappers
│   ├── page.tsx                  # Home / Library
│   ├── find/                     # Find/Discover hub
│   │   ├── search/
│   │   ├── ask/
│   │   └── alchemy/
│   ├── show/[id]/
│   │   └── page.tsx              # Show Detail
│   ├── person/[id]/
│   │   └── page.tsx              # Person Detail
│   └── settings/
│       └── page.tsx              # Settings & Data management
├── components/
│   ├── layout/
│   │   ├── AppLayout.tsx         # Filters sidebar + main content
│   │   ├── FiltersPanel.tsx      # Tag filters, data filters, status filters
│   │   └── Header.tsx            # Global nav (Find, Settings)
│   ├── library/
│   │   ├── CollectionHome.tsx    # Status-grouped show list
│   │   ├── ShowTile.tsx          # Poster + title + My Data badges
│   │   └── StatusGroups.tsx      # Active, Excited, Interested, Other
│   ├── detail/
│   │   ├── ShowDetail.tsx        # Full show detail page
│   │   ├── MediaHeader.tsx       # Backdrops/posters/carousel
│   │   ├── CoreFacts.tsx         # Year, runtime, genres, score
│   │   ├── StatusChips.tsx       # Status + interest chips (toolbar)
│   │   ├── RatingBar.tsx         # User rating slider
│   │   ├── Tags.tsx              # Tag display + picker
│   │   ├── OverviewScoop.tsx     # Overview + Scoop toggle/stream
│   │   ├── Recommendations.tsx   # Traditional recommendations
│   │   ├── ExploreSimilar.tsx    # Get Concepts → Explore Shows
│   │   ├── CastCrew.tsx          # Horizontal talent list
│   │   ├── Seasons.tsx           # TV seasons
│   │   └── StreamingAvail.tsx    # Provider availability
│   ├── find/
│   │   ├── SearchResults.tsx     # Search grid
│   │   ├── AskChat.tsx           # Chat UI with context summarization
│   │   └── AlchemyFlow.tsx       # Multi-step concept blending
│   ├── person/
│   │   └── PersonDetail.tsx      # Bio, gallery, analytics, filmography
│   ├── shared/
│   │   ├── ModeSwitcher.tsx      # Find hub mode tabs
│   │   ├── MediaGrid.tsx         # Reusable poster grid
│   │   ├── ConceptChips.tsx      # Selectable concept chips
│   │   ├── EmptyState.tsx        # Contextual empty states
│   │   └── UserChip.tsx          # Display current user
│   └── settings/
│       ├── AppSettings.tsx       # Font size, search on launch
│       ├── AiSettings.tsx        # AI provider, model, API key
│       └── DataManagement.tsx    # Export/backup
├── lib/
│   ├── db/
│   │   ├── client.ts             # Supabase client (typed)
│   │   ├── shows.ts              # Show CRUD + merge logic
│   │   ├── users.ts              # User management
│   │   ├── settings.ts           # Cloud + local settings
│   │   └── migrations.ts         # Schema version management
│   ├── catalog/
│   │   ├── client.ts             # External catalog API client
│   │   └── mapper.ts             # Catalog → Show mapping
│   ├── ai/
│   │   ├── client.ts             # Configurable LLM client (provider-agnostic)
│   │   ├── prompts/
│   │   │   ├── base.ts           # Shared rules & persona
│   │   │   ├── scoop.ts          # Scoop system prompt
│   │   │   ├── ask.ts            # Ask personality prompts
│   │   │   ├── concepts.ts       # Concept extraction prompt
│   │   │   ├── recommendations.ts # Concept-based recs prompt
│   │   │   └── mentions.ts       # Structured mention output prompt
│   │   └── surfaces/
│   │       ├── scoop.ts          # Generate/render scoop
│   │       ├── ask.ts            # Chat handling + summarization
│   │       ├── concepts.ts       # Single + multi-show concepts
│   │       └── recommendations.ts # Concept-based recommendations
│   ├── discovery/
│   │   ├── alchemy.ts            # Alchemy flow logic
│   │   ├── explore-similar.ts    # Explore Similar flow logic
│   │   └── mentioned-shows.ts    # Parse structured show mentions
│   └── utils/
│       ├── merge.ts              # Field-level merge logic
│       ├── timestamps.ts         # Date formatting, freshness checks
│       ├── filters.ts            # Filter configuration helpers
│       └── export.ts             # JSON export + zip generation
├── hooks/
│   ├── useUser.ts                # Current user context
│   ├── useNamespace.ts           # Current namespace
│   ├── useLibrary.ts             # Collection queries + mutations
│   ├── useShow.ts                # Single show + My Data
│   ├── useAskSession.ts          # Chat session state + summarization
│   ├── useAlchemySession.ts      # Alchemy flow state
│   └── useSettings.ts            # Cloud + local settings
├── types/
│   ├── show.ts                   # Show, MyStatusType, MyInterestType
│   ├── catalog.ts                # External catalog types
│   ├── ai.ts                     # AI request/response types
│   ├── filters.ts                # FilterConfiguration
│   └── index.ts                  # Barrel export
├── config/
│   └── env.ts                    # Env variable validation (Zod)
└── styles/
    └── globals.css               # Design tokens, responsive utilities
```

---

## 5. Core Feature Implementation

### 5.1 Authentication & Identity

**Goal:** Dev-friendly identity injection with path to real OAuth.

**Implementation:**
1. **Dev mode:** Accept `X-User-Id` header in API routes. If header absent, use a configurable default user from env vars (`DEFAULT_USER_ID`).
2. **User record:** On first request per `(namespace_id, user_id)`, auto-create the user record in `users` table with a random username.
3. **Session token:** Store `user_id` in an HTTP-only cookie scoped to the namespace.
4. **OAuth migration path:** Wrap identity resolution in an `auth/resolver` abstraction. Replace dev injection with NextAuth.js (Supabase provider) by changing one config file + wiring the provider.

**Namespace injection:** `namespace_id` injected from env var (`NEXT_PUBLIC_NAMESPACE_ID` or server-side `NAMESPACE_ID`). Each deployment gets a unique namespace.

---

### 5.2 Show Collection (CRUD)

#### Creating / Saving a Show
Triggered by: setting status, choosing interest, rating, or adding tags.

1. **Fetch from catalog** if not already stored (by external ID).
2. **Apply defaults:**
   - Status = `Later`, Interest = `Interested`
   - Exception: first save via rating → status = `Done`
3. **Insert into `shows`** with user_id + namespace_id.
4. **Return** merged show object.

#### Updating My Data
Each field update (status, interest, tags, rating, scoop):
1. **PATCH request** to `/api/shows/[id]` with fields to update.
2. Server updates only provided fields + sets corresponding `*_update_date` timestamp.
3. **Optimistic update** on client for instant feedback.

#### Removing from Collection
1. **Confirm dialog** (configurable to skip after repeated removals via `hide_status_removal_confirmation`).
2. **DELETE** show from `shows` table.
3. All My Data cleared implicitly (delete the row).

#### Fetching Collection Home
1. Query `shows` filtered by `namespace_id` + `user_id`.
2. Group by status: Active → Excited (Later+Excited) → Interested (Later+Interested) → Other.
3. Apply media-type toggle (All/Movies/TV).
4. Apply tag filters, data filters from sidebar.
5. Sort by `my_tags_update_date` DESC (recently updated first).

#### Re-adding a Show
1. **Lookup** by catalog ID + user + namespace.
2. If found: preserve all My Data, refresh public metadata from catalog.
3. **Merge** using field-level rules (Section 3 merge policy).

---

### 5.3 Catalog Integration

**Catalog API Client** (`lib/catalog/client.ts`):
- Provider-agnostic wrapper around external TV/movie database API.
- Reads API key from `cloud_settings` (or env for dev).
- Methods: `search(query)`, `getById(id)`, `getRecommendations(id)`, `getSimilar(id)`, `getPerson(id)`, `getProviders(id, region)`.

**Catalog → Show Mapper** (`lib/catalog/mapper.ts`):
- Decodes catalog payload into `Show` partial (public fields only).
- Maps genre IDs → display names (via a genre mapping file or API).
- Constructs image URLs from relative paths + base URL.
- Selects best logo deterministically (English preference, then highest resolution).

**Merge Logic** (`lib/utils/merge.ts`):
```typescript
function mergeShows(existing: Show, incoming: Show): Show {
  // Non-my fields: selectFirstNonEmpty
  const publicFields = pickNonMyFields(incoming, existing);
  // My fields: resolve by timestamp
  const myFields = resolveMyFieldConflicts(
    existing.myFields, incoming.myFields
  );
  return { ...publicFields, ...myFields, detailsUpdateDate: now() };
}
```

---

### 5.4 AI Surfaces

**Provider-Agnostic LLM Client** (`lib/ai/client.ts`):
- Reads config from `cloud_settings` (provider, model, API key).
- Supports multiple providers behind a shared interface:
  ```typescript
  interface AIClient {
    generateChat(messages: Message[], systemPrompt: string): Promise<string>;
    generateStructured<T>(messages: Message[], systemPrompt: string, schema: Schema): Promise<T>;
    streamText(messages: Message[], systemPrompt: string): AsyncIterable<string>;
  }
  ```
- Provider implementations: OpenAI, Anthropic, and a generic OpenAI-compatible adapter.

#### 5.4.1 AI Scoop (Show Detail)
- **Trigger:** User taps "Give me the Scoop!" on Show Detail.
- **Flow:**
  1. Check if cached scoop exists and is fresh (< 4 hours). If fresh, return cached.
  2. If expired or missing, call LLM with Scoop system prompt + show context.
  3. Stream response progressively for UX.
  4. **Persist only if show is in collection** (has My Data).
- **System Prompt:** Base persona + Scoop structure (personal take, stack-up, Scoop paragraph, fit/warnings, verdict).
- **Prompt file:** `lib/ai/prompts/scoop.ts`

#### 5.4.2 Ask Chat
- **Flow:**
  1. User types message.
  2. Build context: recent turns + user library summary + session state.
  3. If conversation exceeds ~10 turns, summarize older turns into 1-2 sentences (preserving persona/tone).
  4. Call LLM with Ask system prompt + context.
  5. Stream response.
  6. If AI mentions shows, parse structured `showList` format.
- **Welcome View:** 6 random starter prompts from the 80-prompt library. Refreshable.
- **Ask About a Show:** Launch from Show Detail "Ask about..." button. Pre-seed conversation with show context.
- **Prompt files:** `lib/ai/prompts/ask.ts`

#### 5.4.3 Concepts (Single + Multi-Show)
- **Single Show (Explore Similar):**
  1. User taps "Get Concepts" on Show Detail.
  2. Call LLM with concept extraction prompt + show context.
  3. Return bullet list of 1-3 word concepts.
- **Multi-Show (Alchemy):**
  1. User selects 2+ shows, taps "Conceptualize Shows".
  2. Call LLM with multi-show concept prompt (must find shared concepts).
  3. Return larger pool of concepts (more than single-show).
- **Prompt file:** `lib/ai/prompts/concepts.ts`

#### 5.4.4 Concept-Based Recommendations
- **Flow:**
  1. User selects concepts (1+ for Explore Similar, up to 8 for Alchemy).
  2. Call LLM with recommendation prompt + selected concepts + show context.
  3. Parse response: list of recommended shows with reasons.
  4. **Resolve each title to a real catalog item:**
     - If AI provided external ID, use it directly.
     - Otherwise, search catalog by title (case-insensitive match).
     - If found, render as interactive show tile with AI reason.
     - If not found, render as non-interactive or hand off to Search.
  5. **Count:** 5 recs for Explore Similar, 6 recs for Alchemy.
- **Prompt file:** `lib/ai/prompts/recommendations.ts`

#### 5.4.5 Structured Output (Mentioned Shows)
- **Contract:** AI outputs:
  ```
  commentary: "natural language response"
  showList: "Title1::externalId::type;;Title2::externalId::type;;..."
  ```
- **Parser** (`lib/discovery/mentioned-shows.ts`):
  - Parse `showList` string into array of `{title, externalId, mediaType}`.
  - On parse failure: retry once with stricter instructions; if still failing, fall back to commentary + Search handoff.

---

### 5.5 Alchemy Flow

**State Machine** (`lib/discovery/alchemy.ts` + `useAlchemySession` hook):

```typescript
type AlchemyStep = 'select-shows' | 'select-concepts' | 'review-results';
interface AlchemySession {
  step: AlchemyStep;
  inputShows: Show[];        // 2+ selected
  concepts: string[];        // extracted by AI
  selectedConcepts: string[]; // user-selected (max 8)
  recommendations: Recommendation[]; // AI results
  isChaining: boolean;
}
```

**Steps:**
1. **Select Shows (≥2):** User browses library + global catalog, selects shows.
2. **Conceptualize:** AI extracts shared concepts. User selects up to 8.
3. **Alchemize:** AI returns 6 recommendations with reasons.
4. **Chain:** User can use results as new inputs for another round.
5. **Clearing:** Changing input shows or concept selection resets downstream state.

---

### 5.6 Explore Similar (Per-Show Concepts)

**State Machine** (`lib/discovery/explore-similar.ts`):

```typescript
type ExploreStep = 'get-concepts' | 'select-concepts' | 'review-results';
```

**Steps:**
1. User taps "Get Concepts" on Show Detail.
2. AI extracts concepts for the single show.
3. User selects 1+ concepts.
4. User taps "Explore Shows" → AI returns 5 recommendations.

---

### 5.7 Filters & Navigation

**Filters Panel** (sidebar):
- **Quick:** "All Shows"
- **Tag filters:** One per user-created tag + "No tags" if applicable.
- **Data filters:** Genre, Decade, Community score ranges.
- **Media-type toggle:** All / Movies / TV (applies on top of any filter).

**Implementation:**
- Filter state stored in `ui_state.last_selected_filter` (JSONB).
- Filters compose: selected tag + media type + other data filters.
- Query: `SELECT * FROM shows WHERE namespace_id = $1 AND user_id = $2 AND my_status IS NOT NULL AND (tag_filter) AND (media_filter) ORDER BY my_tags_update_date DESC`

---

### 5.8 Settings & Data Management

**App Settings:**
- Font size (XS through XXL) — applied via CSS custom property.
- Search on launch — stored in `local_settings.auto_search`.

**AI Settings:**
- AI provider API key — stored in `cloud_settings.ai_api_key`.
- AI model selection — stored in `cloud_settings.ai_model`.

**Integrations:**
- Content catalog API key — stored in `cloud_settings.catalog_api_key`.

**Export / Backup:**
- Endpoint: `GET /api/export`
- Produces `.zip` containing `backup.json`:
  ```json
  {
    "shows": [/* full show objects with My Data */],
    "settings": { /* cloud + local settings */ },
    "exportDate": "ISO-8601"
  }
  ```
- All dates encoded as ISO-8601.
- Import/restore: documented as optional for v1 (open question).

---

## 6. Environment Configuration

### `.env.example`
```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
SUPABASE_SERVICE_ROLE_KEY=        # server-only, never client
SUPABASE_ANON_KEY=                # browser-safe

# External catalog API
CATALOG_API_KEY=

# AI
AI_PROVIDER=openai                 # or anthropic, etc.
AI_MODEL=
AI_API_KEY=

# Benchmark: namespace isolation
NAMESPACE_ID=

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### `.gitignore`
```
.env
.env.local
.env.*.local
!.env.example
```

### Scripts (package.json)
```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "test": "jest",
    "test:reset": "bash scripts/reset-namespace.sh"
  }
}
```

---

## 7. Migration & Data Continuity

### Schema Evolution
- `app_metadata.data_model_version` tracks current schema version.
- On app startup, compare version. If lower, run migration scripts sequentially.
- Migrations:
  1. Add new columns (`ALTER TABLE ... ADD COLUMN IF NOT EXISTS`).
  2. Backfill existing data where needed.
  3. Update `data_model_version`.

### Data Preservation
- All user data lives in Supabase (server-side).
- Client cache is disposable — clearing localStorage never loses data.
- Migration script runs on every deployment; safe for repeated execution (idempotent).

---

## 8. Testing Strategy

### Unit Tests
- **Merge logic:** Field-level merge with timestamp resolution, empty-field protection.
- **Catalog mapper:** Payload → Show transformation, genre mapping, logo selection.
- **Filter logic:** Tag + media type + data filter composition.
- **Structured output parser:** Valid/invalid showList formats, fallback handling.
- **AI prompt templates:** Static analysis for required sections.

### Integration Tests
- **Show CRUD:** Create, read, update, delete with user + namespace scoping.
- **Rating-to-save:** Rating triggers auto-save as Done.
- **Tag-to-save:** Tag triggers auto-save as Later + Interested.
- **Collection removal:** Clears all My Data, confirmation dialog behavior.
- **Catalog refresh merge:** External data merged without overwriting user edits.

### E2E / Smoke Tests
- **Happy path:** Search → open show → rate → appears in collection → filter by tag.
- **Ask flow:** Chat → mention shows → click mentioned show → open detail.
- **Alchemy flow:** Select shows → conceptualize → select concepts → alchemize → view results.
- **Settings:** Change AI model → save → verify in settings.

### Destructive Tests (Namespace-Scoped)
- Create namespace, seed data, delete all shows → verify namespace isolation.
- Verify no cross-namespace data leakage.

---

## 9. UI/UX Principles

### Design System
- **Responsive:** Mobile-first, adapts to desktop (sidebar + main layout).
- **Poster grid:** Consistent aspect ratio (2:3 for shows), responsive sizing.
- **Status badges:** Color-coded indicators on tiles.
- **Rating indicator:** User score badge when present.

### Status Grouping (Collection Home)
1. **Active** — prominent, larger tiles.
2. **Excited** (Later + Excited) — highlighted section.
3. **Interested** (Later + Interested) — highlighted section.
4. **Other** (Wait, Quit, Done, unclassified Later) — collapsed group.

### Empty States
- No shows in collection: "Start adding shows by searching or asking for recommendations."
- Filter yields no results: "No results found." + prompt to clear filter.

---

## 10. AI Prompt Architecture

### Prompt Files
Each AI surface has a dedicated prompt file:

```
lib/ai/prompts/
├── base.ts          # Shared persona: joy-forward, opinionated, vibe-first, specific, concise
├── scoop.ts         # Scoop structure: personal take → stack-up → scoop paragraph → fit → verdict
├── ask.ts           # Ask personality: friend in dialogue, opinionated, spoiler-safe
├── concepts.ts      # Concept extraction: 1-3 words, evocative, no generics, diversity across axes
├── recommendations.ts # Concept-based recs: name concepts, bias recent, real shows
└── mentions.ts      # Structured output: commentary + showList format
```

### Prompt Composition
- `base.ts` persona is included in every AI surface prompt.
- Surface-specific prompts extend base with format instructions and structural requirements.
- **Do not cross the red lines:** No encyclopedic tone, no hedging, no out-of-domain recommendations, no unsaved spoilers.

### Conversation Summarization
- After ~10 messages, summarize older turns into 1-2 sentences.
- Summary preserves the AI persona/tone (not a sterile system message).

---

## 11. Implementation Phases

### Phase 1: Foundation (Core Infrastructure)
- [ ] Next.js project setup with App Router
- [ ] Supabase project + RLS policies
- [ ] Database migrations (all tables from Section 3)
- [ ] Environment configuration (`.env.example`, `.gitignore`)
- [ ] Identity injection (dev mode + namespace)
- [ ] Basic API routes (health, user resolution)
- [ ] Catalog API client + mapper
- [ ] One-command setup (`npm run dev`, `npm test`, `npm run test:reset`)

**Deliverable:** App boots, resolves user + namespace, connects to Supabase, can search the catalog.

---

### Phase 2: Collection Core
- [ ] Show CRUD via API routes
- [ ] Merge logic (field-level with timestamps)
- [ ] Collection Home (status-grouped, filtered)
- [ ] Show Tile component (poster, title, badges)
- [ ] Filters panel (tags, genres, scores, media type)
- [ ] Status chips + save/remove flow
- [ ] Rating bar (rating-to-save behavior)
- [ ] Tags (add/remove, auto-save trigger)
- [ ] Show Detail page (sections per spec)

**Deliverable:** Users can browse catalog, save shows to collection, organize with statuses/tags/ratings, view collection home with filters.

---

### Phase 3: AI Surfaces
- [ ] Provider-agnostic LLM client
- [ ] Prompt files (base, scoop, ask, concepts, recommendations)
- [ ] AI Scoop (generate, cache 4hr, persist only if in collection)
- [ ] Ask Chat (streaming, context management, summarization)
- [ ] Structured output parser (mentioned shows)
- [ ] Concept extraction (single + multi-show)
- [ ] Concept-based recommendations (resolve to real shows)
- [ ] Ask About a Show (seed context)

**Deliverable:** All three AI surfaces work: Scoop, Ask, and concept-based recommendations.

---

### Phase 4: Advanced Discovery
- [ ] Alchemy flow (state machine, 3 steps, chaining)
- [ ] Explore Similar (per-show concepts)
- [ ] Mentioned shows strip in Ask
- [ ] Recommendation resolution (real show lookup + fallback)

**Deliverable:** Alchemy and Explore Similar fully functional. Recommendations map to real catalog items.

---

### Phase 5: Polish & Edge Cases
- [ ] Person Detail page (bio, gallery, analytics, filmography)
- [ ] Streaming availability display
- [ ] Seasons section (TV only)
- [ ] Budget vs Revenue (movies)
- [ ] Export / Backup (zip + JSON)
- [ ] Settings pages (app, AI, integrations)
- [ ] Empty states
- [ ] Responsive design polish
- [ ] Loading states + error handling
- [ ] Confirmation dialogs (removal, destructive)
- [ ] Cache freshness logic (AI scoop 4hr expiry)

**Deliverable:** Complete product matching all features in the PRD.

---

### Phase 6: Testing & Hardening
- [ ] Unit tests (merge, mapper, filters, parser)
- [ ] Integration tests (CRUD, save triggers, merge on refresh)
- [ ] E2E smoke tests (key user journeys)
- [ ] Namespace isolation verification
- [ ] Data migration tests (schema version upgrades)
- [ ] Destructive test scripts
- [ ] Performance review (catalog API latency, AI response streaming)
- [ ] Security audit (RLS policies, API key handling, XSS prevention)

**Deliverable:** All tests passing, compliant with Infrastructure Rider PRD.

---

## 12. Risk Mitigations

| Risk | Mitigation |
|------|-----------|
| AI provider downtime | Fallback to unstructured recommendations + Search handoff |
| Catalog API rate limits | Server-side caching (TTL-based, not client-dependent) |
| AI hallucinated recommendations | Resolution step: validate against catalog before presenting to user |
| Parse failures on structured output | Retry once with stricter instructions; fallback to commentary + Search |
| Schema migration failures | Idempotent migrations; version check before migration; rollback plan |
| Namespace collision | Enforce `namespace_id` on all queries via RLS policies + middleware |
| API key exposure | Service role key server-only; anon key for browser; never commit secrets |
| Large catalog payloads | Pagination on search; lazy-load cast/crew/seasons |
| AI token costs | Stream responses; summarize long conversations; cache scoops |

---

## 13. Open Questions (From PRD)

The following are explicitly marked as open in the product spec and should be addressed during implementation:

1. **Next status:** Should "Next" become a first-class status in UI? *(Recommendation: keep hidden in v1, surface in data model only.)*
2. **Named custom lists:** Beyond tags, should users create named lists? *(Defer to post-benchmark.)*
3. **AI Scoop on unsaved show:** Should generating Scoop implicitly save? *(Recommendation: no — respect explicit user intent to save.)*
4. **Unrated state:** Should clearing rating store explicit "Unrated" vs nil? *(Recommendation: nil is sufficient for v1.)*
5. **Import/Restore:** Add import from export zip. *(Documented as desired but not currently implemented.)*
6. **Shareable Alchemy sessions:** Save/share sessions as reusable "blends." *(Defer.)*
7. **Status filters in sidebar:** Add explicit myStatus filters. *(Defer — data model supports it.)*

---

## 14. Summary

This plan delivers a complete personal TV/movie companion app built on Next.js + Supabase, matching all requirements across:

- **Collection management** (statuses, interest, tags, ratings, AI Scoop)
- **Discovery** (search, Ask chat, Alchemy, Explore Similar)
- **AI surfaces** (taste-aware, spoiler-safe, opinionated, concept-based)
- **Data integrity** (field-level merge, timestamp resolution, namespace isolation)
- **Identity** (dev-friendly injection, OAuth migration path)
- **Infrastructure compliance** (env-based config, one-command dev, repeatable migrations, destructive test support, no Docker requirement)

Total estimated implementation: **14 major sections across 6 phases**, with clear deliverables at each phase boundary for iterative testing and validation.
