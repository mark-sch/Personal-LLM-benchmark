# Implementation Plan: Showbiz — TV & Movie Companion App

## Tech Stack

- **Frontend + API:** Next.js (latest stable), TypeScript, Tailwind CSS
- **Database:** Supabase (hosted, PostgreSQL)
- **External catalog:** TMDB (The Movie Database) API
- **AI:** Anthropic Claude API (or OpenAI — configurable via env)
- **Auth (benchmark mode):** Dev identity injection via env var / dev-only selector

---

## 1. Project Structure

```
/
├── app/                        # Next.js App Router
│   ├── (app)/                  # Authenticated app shell
│   │   ├── page.tsx            # Collection Home
│   │   ├── show/[id]/page.tsx  # Show Detail
│   │   ├── person/[id]/page.tsx# Person Detail
│   │   ├── find/
│   │   │   ├── page.tsx        # Find hub (Search default)
│   │   │   ├── ask/page.tsx    # Ask (AI Chat)
│   │   │   └── alchemy/page.tsx# Alchemy
│   │   └── settings/page.tsx   # Settings
│   └── api/                    # API routes (server-side)
│       ├── shows/              # Show CRUD
│       ├── ai/                 # AI surfaces (scoop, ask, alchemy, concepts)
│       ├── catalog/            # TMDB proxy
│       └── export/             # Data export
├── components/                 # Shared UI components
├── lib/                        # Utilities, clients, types
│   ├── supabase/               # Supabase client (server + browser)
│   ├── tmdb/                   # TMDB API client
│   ├── ai/                     # AI prompt builders + parsers
│   └── types.ts                # Shared TypeScript types
├── supabase/
│   └── migrations/             # SQL migration files
├── .env.example
└── scripts/
    ├── dev.sh
    ├── test.sh
    └── test-reset.sh
```

---

## 2. Infrastructure & Isolation

### 2.1 Environment Variables (`.env.example`)

```
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=     # server-only

# TMDB
TMDB_API_KEY=

# AI
AI_API_KEY=
AI_MODEL=claude-sonnet-4-5-20251001

# Benchmark isolation
NAMESPACE_ID=dev
DEFAULT_USER_ID=dev-user-001

# App
NODE_ENV=development
```

### 2.2 Identity & Namespace Model

- `NAMESPACE_ID`: stable per-build string (e.g., `sonnet_4_6_high`). Stored in every persisted row.
- `DEFAULT_USER_ID`: injected in dev/benchmark mode. In prod, replaced by real OAuth `user_id`.
- All server API routes read `user_id` from:
  1. `X-User-Id` header (dev/benchmark mode, when `NODE_ENV !== production`)
  2. Supabase session (future OAuth path)
- Row-level security in Supabase scoped to `(namespace_id, user_id)`.

### 2.3 One-Command Developer Experience

```bash
npm run dev          # start Next.js dev server
npm test             # run test suite
npm run test:reset   # delete all rows WHERE namespace_id = $NAMESPACE_ID
```

---

## 3. Database Schema (Supabase / PostgreSQL)

### 3.1 `shows` table

```sql
CREATE TABLE shows (
  id               TEXT NOT NULL,
  namespace_id     TEXT NOT NULL,
  user_id          TEXT NOT NULL,
  PRIMARY KEY (id, namespace_id, user_id),

  -- Identity
  title            TEXT NOT NULL,
  show_type        TEXT NOT NULL CHECK (show_type IN ('movie','tv','unknown')),
  external_ids     JSONB,

  -- Catalog meta
  overview         TEXT,
  genres           TEXT[] DEFAULT '{}',
  tagline          TEXT,
  homepage         TEXT,
  original_language TEXT,
  spoken_languages TEXT[] DEFAULT '{}',
  languages        TEXT[] DEFAULT '{}',

  -- Images
  poster_url       TEXT,
  backdrop_url     TEXT,
  logo_url         TEXT,

  -- Ratings / popularity
  vote_average     FLOAT,
  vote_count       INT,
  popularity       FLOAT,

  -- Dates
  release_date     DATE,
  first_air_date   DATE,
  last_air_date    DATE,

  -- Movie-specific
  runtime          INT,
  budget           BIGINT,
  revenue          BIGINT,

  -- TV-specific
  series_status    TEXT,
  number_of_episodes INT,
  number_of_seasons  INT,
  episode_run_time INT[],

  -- User data ("my*")
  my_tags          TEXT[] DEFAULT '{}',
  my_tags_updated  TIMESTAMPTZ,
  my_score         FLOAT,
  my_score_updated TIMESTAMPTZ,
  my_status        TEXT CHECK (my_status IN ('active','later','wait','done','quit','next')),
  my_status_updated TIMESTAMPTZ,
  my_interest      TEXT CHECK (my_interest IN ('interested','excited')),
  my_interest_updated TIMESTAMPTZ,

  -- AI data
  ai_scoop         TEXT,
  ai_scoop_updated TIMESTAMPTZ,

  -- Provider data
  provider_data    JSONB,

  -- Management
  details_updated  TIMESTAMPTZ,
  created_at       TIMESTAMPTZ DEFAULT now(),
  is_test          BOOLEAN DEFAULT false
);
```

### 3.2 `cloud_settings` table

```sql
CREATE TABLE cloud_settings (
  id           TEXT NOT NULL DEFAULT 'globalSettings',
  namespace_id TEXT NOT NULL,
  user_id      TEXT NOT NULL,
  PRIMARY KEY (id, namespace_id, user_id),

  user_name    TEXT,
  version      FLOAT,   -- epoch seconds for conflict resolution
  catalog_api_key TEXT,
  ai_api_key   TEXT,
  ai_model     TEXT
);
```

### 3.3 Row Level Security

```sql
ALTER TABLE shows ENABLE ROW LEVEL SECURITY;
CREATE POLICY "namespace_user_isolation" ON shows
  USING (namespace_id = current_setting('app.namespace_id')
     AND user_id = current_setting('app.user_id'));
```

All API routes set these session settings before queries.

---

## 4. Data Layer: Merge & Business Rules

### 4.1 Saving a Show

When any user action triggers a save (status set, rating, tag added):

1. Check if `(id, namespace_id, user_id)` exists.
2. If yes: merge catalog fields using `selectFirstNonEmpty` (never overwrite non-empty with empty/null); user fields resolved by timestamp (newer wins).
3. If no: insert new row with defaults.
4. Default status when saved without explicit status: `later` + `interested`.
5. Exception: save via rating → default status `done`.

### 4.2 Removing a Show

1. Show confirmation dialog (suppressible after N confirmations via `hideStatusRemovalConfirmation`).
2. Delete row from `shows` table.
3. All My Data cleared.

### 4.3 Timestamps

Every `my*` field update sets corresponding `my_*_updated` to `now()`.

---

## 5. External Catalog Integration (TMDB)

All TMDB calls are proxied through server-side API routes (API key never exposed to client).

### Endpoints to implement:

- `GET /api/catalog/search?q=&type=` — title search
- `GET /api/catalog/show/[id]?type=` — full show details (with credits, seasons, videos, recommendations, similar, providers)
- `GET /api/catalog/person/[id]` — person + credits

### TMDB → Show mapping:

- `id` → `show.id` (as string, prefixed with type: `tmdb-movie-123`, `tmdb-tv-456`)
- `media_type: 'movie'` → `show_type: 'movie'`, `media_type: 'tv'` → `show_type: 'tv'`
- `title` (movie) or `name` (tv) → `title`
- `poster_path` → build full poster URL via TMDB image base URL
- Genres: map genre IDs to names
- Transient fields (credits, seasons, videos, etc.) returned in API response but not persisted

---

## 6. Application Features

### 6.1 Collection Home (`/`)

- Layout: sidebar (filters) + main content area
- Main area: shows grouped by status sections in order:
  1. Active (prominent / larger tiles)
  2. Excited (Later + Excited interest)
  3. Interested (Later + Interested)
  4. Other (Wait, Quit, Done — collapsed by default)
- Media-type toggle: All / Movies / TV (filters on top of sidebar filter)
- Sidebar filters:
  - All Shows
  - Tag filters (one per unique tag in collection, plus "No Tags" if any untagged shows)
  - Genre, Decade, Community Score range filters
- Show tiles: poster, title, status badge, rating badge
- Empty states: no collection → prompt to Search/Ask; filter yields none → "No results found"

### 6.2 Find Hub (`/find`)

Mode switcher: Search | Ask | Alchemy

Default mode: Search (or Ask if `autoSearch` setting enabled).

### 6.3 Search (`/find` default)

- Text input → debounced TMDB search
- Results: poster grid
- In-collection items marked with status badge
- Selecting a result → Show Detail

### 6.4 Ask — AI Chat (`/find/ask`)

- Chat UI (user + assistant bubbles)
- Welcome state: 6 random starter prompts (from a pool of ~80), refresh button
- Session context: last ~10 turns; older turns summarized (1-2 sentences, same persona voice)
- AI response format: structured JSON with `commentary` (user-facing text) + `showList` (machine-readable)
  - `showList` format: `Title::externalId::mediaType;;Title2::externalId::mediaType`
- Mentioned shows row: horizontal strip rendered below latest AI message
- Tapping mentioned show → Show Detail (resolve via TMDB ID) or Search handoff if not found
- "Ask about this show" entry: seeded with show context, same chat UI

### 6.5 Alchemy (`/find/alchemy`)

Flow (4 steps with clear section UI):

1. **Select shows** (2+ from library or catalog search)
2. **Conceptualize** — tap "Conceptualize Shows" → AI returns 8+ concept chips
3. **Select concepts** (up to 8)
4. **Alchemize** — tap "ALCHEMIZE!" → 6 AI recommendations

- Backtracking: changing shows clears concepts and results
- "More Alchemy!" → chain another round using results as new inputs
- Each recommendation: title, poster, reason citing specific concepts

### 6.6 Show Detail (`/show/[id]`)

Section order (per spec):
1. Header media carousel (backdrops, posters, logos, trailer when available)
2. Core facts (year, runtime or seasons/episodes) + community score bar
3. My Tags chips + tag picker
4. Overview + AI Scoop toggle
5. "Ask about this show" CTA
6. Genres + languages
7. Traditional recommendations strand
8. Explore Similar (Get Concepts → concept chips → Explore Shows → 5 recs)
9. Streaming availability (providers by region)
10. Cast & Crew strands → Person Detail
11. Seasons (TV only)
12. Budget vs Revenue (movies, when available)

**My relationship controls (toolbar, always visible):**
- Status/Interest chips: Active, Interested (Later+Interested), Excited (Later+Excited), Done, Wait, Quit
- Reselecting active status → confirmation → removes show
- My Rating slider (0–10)

**AI Scoop:**
- Toggle copy: "Give me the scoop!" / "Show the scoop" / "The Scoop"
- Streams progressively ("Generating…" state)
- Cached for 4 hours; regenerated on demand after expiry
- Persisted only if show is in collection

**Explore Similar flow:**
1. "Get Concepts" → AI generates 8 concept chips
2. User selects 1+ concepts
3. "Explore Shows" → 5 AI recommendations

### 6.7 Person Detail (`/person/[id]`)

- Image gallery (TMDB profile images)
- Name + bio
- Analytics charts: average project ratings, top genres, projects-by-year (use Recharts or similar)
- Filmography grouped by year
- Selecting a credit → Show Detail

### 6.8 Settings (`/settings`)

Sections:
- **Display:** font size (XS/S/M/L/XL/XXL), search-on-launch toggle
- **User:** username
- **AI:** API key input (never committed; stored in Supabase `cloud_settings`), AI model selector
- **Integrations:** catalog API key (TMDB)
- **Your Data:** "Export My Data" button → downloads `.zip` with JSON backup (all shows + My Data, dates ISO-8601)

---

## 7. AI Integration

All AI calls are server-side (API key never in client).

### 7.1 Surfaces & Prompts

**Scoop** (`POST /api/ai/scoop`):
- Input: show title, year, overview, genres, community score
- Output: streaming text structured as: personal take → honest stack-up → "The Scoop" centerpiece → fit/warnings → verdict
- ~150–350 words; stream via Server-Sent Events

**Ask** (`POST /api/ai/ask`):
- Input: user message, conversation history (last ~10 turns + summary of older), user library (status/tags/ratings)
- Output: `{ commentary: string, showList: string }` (JSON)
- Parse `showList` → resolve each via TMDB catalog; fallback to non-interactive if not found

**Concepts — single show** (`POST /api/ai/concepts/single`):
- Input: show title, overview, genres
- Output: bullet list of 8 concepts (1–3 words each, evocative, no plot)

**Concepts — multi-show / Alchemy** (`POST /api/ai/concepts/multi`):
- Input: array of shows
- Output: bullet list of 12+ concepts shared across all inputs

**Explore Similar recs** (`POST /api/ai/recs/explore`):
- Input: show context + selected concepts
- Output: 5 shows with reasons citing selected concepts

**Alchemy recs** (`POST /api/ai/recs/alchemy`):
- Input: source shows + selected concepts
- Output: 6 shows with reasons citing selected concepts

### 7.2 Show Resolution

When AI returns a show recommendation:
1. AI outputs `{ title, externalId, mediaType }`
2. Look up TMDB by `externalId` (if provided)
3. Verify title matches (case-insensitive)
4. If match: render as selectable show tile with reason
5. If no match / not found: render as non-interactive text with Search CTA

### 7.3 Conversation Summarization

After ~10 messages:
- Summarize oldest turns into 1–2 sentences
- Summary must use same warm, casual AI persona voice (not sterile "system" tone)
- Append summary as synthetic context message

---

## 8. Component Architecture

### Key shared components:

- `ShowTile` — poster + title + status badge + rating badge; handles both grid and strand layouts
- `StatusChips` — interactive status/interest selector (toolbar)
- `RatingSlider` — 0–10 user rating input
- `TagPicker` — tag input with autocomplete from existing collection tags
- `ConceptChips` — selectable concept grid
- `ShowStrand` — horizontal scrolling row of ShowTiles
- `ChatBubble` — user/assistant chat message
- `MentionedShowsStrip` — horizontal strip of mentioned shows from AI chat
- `ScoopDisplay` — streaming scoop text display
- `MediaCarousel` — header backdrop/poster/logo/trailer carousel
- `FilterSidebar` — navigation + filter panel

---

## 9. Key API Routes

| Route | Method | Purpose |
|---|---|---|
| `/api/shows` | GET | List user's collection (with filters) |
| `/api/shows` | POST | Save/update a show |
| `/api/shows/[id]` | DELETE | Remove show from collection |
| `/api/catalog/search` | GET | TMDB search proxy |
| `/api/catalog/show/[id]` | GET | TMDB show details proxy |
| `/api/catalog/person/[id]` | GET | TMDB person details proxy |
| `/api/ai/scoop` | POST | Generate AI Scoop (streaming) |
| `/api/ai/ask` | POST | AI chat turn |
| `/api/ai/concepts/single` | POST | Concepts for one show |
| `/api/ai/concepts/multi` | POST | Concepts for multiple shows |
| `/api/ai/recs/explore` | POST | Explore Similar recommendations |
| `/api/ai/recs/alchemy` | POST | Alchemy recommendations |
| `/api/settings` | GET/PUT | User settings |
| `/api/export` | GET | Export collection as zip |

---

## 10. Build Order

1. **Scaffolding** — Next.js project, Supabase client, env setup, `.env.example`
2. **Database** — migrations for `shows` + `cloud_settings` + RLS policies
3. **TMDB client** — search + show details + person details API routes
4. **Collection CRUD** — save/update/remove show API routes + merge logic
5. **Collection Home** — status-grouped display, filters sidebar, media-type toggle
6. **Show Detail** — all sections, status/rating/tag controls, auto-save rules
7. **Search** — TMDB search UI, in-collection badges
8. **AI Scoop** — streaming scoop generation + caching
9. **Ask** — chat UI, structured output parsing, mentioned shows strip
10. **Concepts + Explore Similar** — concept generation + recommendation flow
11. **Alchemy** — multi-show concept blending + chaining
12. **Person Detail** — profile, filmography, analytics charts
13. **Settings** — all settings panels + data export
14. **Polish** — empty states, error handling, loading states, graceful fallbacks

---

## 11. Verification

- `npm run dev` → app loads at localhost:3000 with no errors
- Collection Home: add a show via Search → appears in correct status section
- Status/interest chips update show placement in Home
- Rating an unsaved show auto-saves as Done
- Adding tag to unsaved show auto-saves as Later + Interested
- Removing status shows confirmation → show disappears from collection
- AI Scoop: generates, streams, caches, refreshes after 4 hours
- Ask: sends message, receives structured response, shows mentioned strip
- Alchemy: select 2 shows → get concepts → select → alchemize → get 6 recs
- Explore Similar: get concepts for one show → select → explore → get 5 recs
- Export: downloads valid zip with JSON
- Namespace isolation: two different NAMESPACE_IDs see separate data
- `npm run test:reset` clears all rows for current namespace without affecting others
