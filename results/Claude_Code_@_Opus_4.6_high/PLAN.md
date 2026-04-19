# Implementation Plan — Showbiz

A personal TV + movie companion for collecting, organizing, rating, and discovering entertainment. Built with Next.js and Supabase.

---

## 1. Tech Stack & Project Bootstrap

### Stack
- **Runtime:** Next.js (latest stable) with App Router
- **Language:** TypeScript
- **Persistence:** Supabase (hosted or local — no Docker requirement)
- **Styling:** Tailwind CSS with a custom theme token layer
- **AI:** OpenAI-compatible API (provider-agnostic abstraction)
- **External Catalog:** TMDB API for show/movie metadata, images, and provider data
- **Package Manager:** npm

### Project Init
1. `npx create-next-app@latest showbiz --typescript --tailwind --app --src-dir`
2. Install dependencies: `@supabase/supabase-js`, `@supabase/ssr` (for server-side auth helpers)
3. Create `.env.example` with all required variables:
   ```
   # Supabase
   NEXT_PUBLIC_SUPABASE_URL=         # Supabase project URL
   NEXT_PUBLIC_SUPABASE_ANON_KEY=    # Supabase anon/public key
   SUPABASE_SERVICE_ROLE_KEY=        # Server-only — never exposed to browser

   # Namespace isolation
   NEXT_PUBLIC_NAMESPACE_ID=         # Unique build/run identifier

   # Identity (dev mode)
   NEXT_PUBLIC_DEFAULT_USER_ID=      # Default user ID for benchmark mode

   # TMDB
   TMDB_API_KEY=                     # TMDB v3 API key
   NEXT_PUBLIC_TMDB_IMAGE_BASE=https://image.tmdb.org/t/p

   # AI
   AI_API_KEY=                       # AI provider API key (server-only)
   AI_MODEL=                         # Model identifier (e.g., gpt-4o)
   AI_BASE_URL=                      # Optional: custom API base URL
   ```
4. `.gitignore` excludes `.env*` except `.env.example`
5. Add npm scripts:
   - `npm run dev` — start development server
   - `npm test` — run tests
   - `npm run db:migrate` — apply database migrations
   - `npm run db:seed` — seed test data for current namespace
   - `npm run test:reset` — reset test data for current namespace

---

## 2. Database Schema & Migrations

All migrations live in `supabase/migrations/` as numbered SQL files.

### 2.1 Table: `shows`

Primary table storing catalog data + user overlay ("My Data").

```sql
CREATE TABLE shows (
  -- Identity
  id              TEXT        NOT NULL,
  namespace_id    TEXT        NOT NULL,
  user_id         TEXT        NOT NULL,
  title           TEXT        NOT NULL,
  show_type       TEXT        NOT NULL CHECK (show_type IN ('movie', 'tv', 'unknown')),
  external_ids    JSONB       DEFAULT '{}',

  -- Catalog meta
  overview        TEXT,
  genres          TEXT[]      DEFAULT '{}',
  tagline         TEXT,
  homepage        TEXT,
  original_language TEXT,
  spoken_languages TEXT[]     DEFAULT '{}',
  languages       TEXT[]      DEFAULT '{}',

  -- Images
  poster_url      TEXT,
  backdrop_url    TEXT,
  logo_url        TEXT,

  -- Ratings / popularity
  vote_average    DOUBLE PRECISION,
  vote_count      INTEGER,
  popularity      DOUBLE PRECISION,

  -- Dates
  release_date    DATE,
  first_air_date  DATE,
  last_air_date   DATE,

  -- Movie-specific
  runtime         INTEGER,
  budget          BIGINT,
  revenue         BIGINT,

  -- TV-specific
  series_status   TEXT,
  number_of_episodes  INTEGER,
  number_of_seasons   INTEGER,
  episode_run_time    INTEGER[],

  -- User data ("My Data")
  my_status       TEXT CHECK (my_status IN ('active', 'later', 'wait', 'done', 'quit', 'next')),
  my_status_update_date   TIMESTAMPTZ,
  my_interest     TEXT CHECK (my_interest IN ('interested', 'excited')),
  my_interest_update_date TIMESTAMPTZ,
  my_tags         TEXT[]      DEFAULT '{}',
  my_tags_update_date     TIMESTAMPTZ,
  my_score        DOUBLE PRECISION,
  my_score_update_date    TIMESTAMPTZ,

  -- AI data
  ai_scoop        TEXT,
  ai_scoop_update_date    TIMESTAMPTZ,

  -- Management
  details_update_date     TIMESTAMPTZ,
  creation_date           TIMESTAMPTZ DEFAULT NOW(),
  is_test                 BOOLEAN DEFAULT FALSE,

  -- Providers
  provider_data   JSONB,

  -- Constraints
  PRIMARY KEY (id, namespace_id, user_id),
  CREATED_AT      TIMESTAMPTZ DEFAULT NOW(),
  UPDATED_AT      TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for common queries
CREATE INDEX idx_shows_namespace_user ON shows (namespace_id, user_id);
CREATE INDEX idx_shows_status ON shows (namespace_id, user_id, my_status);
CREATE INDEX idx_shows_type ON shows (namespace_id, user_id, show_type);
CREATE INDEX idx_shows_tags ON shows USING GIN (my_tags);
CREATE INDEX idx_shows_genres ON shows USING GIN (genres);
```

### 2.2 Table: `cloud_settings`

Synced app-wide settings per user per namespace.

```sql
CREATE TABLE cloud_settings (
  id              TEXT        NOT NULL DEFAULT 'globalSettings',
  namespace_id    TEXT        NOT NULL,
  user_id         TEXT        NOT NULL,
  user_name       TEXT,
  version         DOUBLE PRECISION DEFAULT 0,
  catalog_api_key TEXT,
  ai_api_key      TEXT,
  ai_model        TEXT,

  PRIMARY KEY (id, namespace_id, user_id)
);
```

### 2.3 Table: `app_metadata`

Tracks data model version for migrations.

```sql
CREATE TABLE app_metadata (
  namespace_id        TEXT PRIMARY KEY,
  data_model_version  INTEGER DEFAULT 3
);
```

### 2.4 Row-Level Security (RLS)

Enable RLS on all tables. Policies enforce namespace + user isolation:

```sql
ALTER TABLE shows ENABLE ROW LEVEL SECURITY;

-- Read/write only your own namespace + user data
CREATE POLICY "shows_isolation" ON shows
  FOR ALL
  USING (
    namespace_id = current_setting('app.namespace_id', true)
    AND user_id = current_setting('app.user_id', true)
  )
  WITH CHECK (
    namespace_id = current_setting('app.namespace_id', true)
    AND user_id = current_setting('app.user_id', true)
  );
```

Similar policies for `cloud_settings` and `app_metadata`.

**Alternative approach (simpler for benchmark):** Skip RLS and enforce isolation at the application layer via server-side middleware that always filters by `namespace_id` + `user_id`. This avoids the complexity of Supabase session variables while maintaining the same isolation guarantees. Both approaches are valid; the application-layer approach is more pragmatic for benchmark mode.

---

## 3. Identity & Isolation

### 3.1 Namespace Isolation
- `NEXT_PUBLIC_NAMESPACE_ID` env var provides the build/run namespace
- Every database query includes `namespace_id` in WHERE clauses
- Destructive test operations (`test:reset`) are scoped: `DELETE FROM shows WHERE namespace_id = $1 AND is_test = true`

### 3.2 User Identity (Benchmark Mode)
- `NEXT_PUBLIC_DEFAULT_USER_ID` provides the default user identity
- Server-side API routes read user identity from:
  1. `X-User-Id` request header (dev/test mode only)
  2. Fall back to `NEXT_PUBLIC_DEFAULT_USER_ID`
- A dev-only user selector in the UI header allows switching users (gated behind `NODE_ENV === 'development'`)

### 3.3 Identity Middleware

```
src/middleware.ts
```
- Reads namespace from env
- Reads user ID from header or env default
- Injects both into request context for downstream API routes
- In production mode: reject requests without valid auth (placeholder for future OAuth)

### 3.4 Migration Path to OAuth
- `user_id` is an opaque string — no provider-specific encoding
- Swapping dev identity for real OAuth requires:
  - Add auth provider config (e.g., Supabase Auth with Google)
  - Replace identity middleware to extract `user_id` from JWT
  - No schema changes needed

---

## 4. Application Architecture

Following the fractal architecture from INSTRUCTIONS.md.

### 4.1 Directory Structure

```
src/
├── config/
│   ├── constants.ts          # App-wide constants
│   ├── env.ts                # Typed env var access
│   └── routes.ts             # Route path constants
├── theme/
│   ├── tokens.ts             # Design tokens (colors, spacing, typography)
│   └── globals.css           # Tailwind base + token CSS vars
├── components/
│   ├── ShowTile/
│   │   ├── ShowTile.tsx      # Poster tile with badges
│   │   └── hooks/
│   │       └── useShowTile.ts
│   ├── ShowGrid/
│   │   └── ShowGrid.tsx      # Responsive grid of ShowTiles
│   ├── StatusChips/
│   │   ├── StatusChips.tsx   # Status/Interest chip bar
│   │   └── hooks/
│   │       └── useStatusChips.ts
│   ├── RatingBar/
│   │   └── RatingBar.tsx     # User rating slider
│   ├── TagPicker/
│   │   ├── TagPicker.tsx     # Tag display + add/remove
│   │   └── hooks/
│   │       └── useTagPicker.ts
│   ├── MediaTypeToggle/
│   │   └── MediaTypeToggle.tsx  # All / Movies / TV toggle
│   ├── ShowStrip/
│   │   └── ShowStrip.tsx     # Horizontal scrollable show row
│   ├── ConceptChips/
│   │   └── ConceptChips.tsx  # Selectable concept chips
│   ├── ChatMessage/
│   │   └── ChatMessage.tsx   # Chat bubble (user/assistant)
│   ├── ConfirmDialog/
│   │   └── ConfirmDialog.tsx # Confirmation modal
│   └── Layout/
│       ├── Layout.tsx        # App shell (sidebar + main)
│       ├── Sidebar/
│       │   ├── Sidebar.tsx
│       │   └── hooks/
│       │       └── useSidebar.ts
│       └── TopNav/
│           └── TopNav.tsx
├── hooks/
│   ├── useSupabase.ts        # Supabase client singleton
│   ├── useCurrentUser.ts     # Current user context
│   ├── useNamespace.ts       # Namespace context
│   ├── useCollection.ts     # Full collection query + cache
│   └── useShowSave.ts        # Save/remove show with business rules
├── utils/
│   ├── tmdb.ts               # TMDB API helpers (server-side)
│   ├── ai.ts                 # AI provider abstraction (server-side)
│   ├── showMapper.ts         # TMDB response → Show mapping
│   ├── mergeShow.ts          # Merge rules (catalog refresh + user data)
│   ├── dates.ts              # Date parsing/formatting
│   └── exportData.ts         # Collection export to JSON zip
├── types/
│   ├── show.ts               # Show, MyStatus, MyInterest types
│   ├── settings.ts           # CloudSettings type
│   ├── ai.ts                 # AI request/response types
│   └── filters.ts            # Filter configuration types
├── app/
│   ├── layout.tsx            # Root layout with providers
│   ├── page.tsx              # Redirect to /home
│   ├── home/
│   │   └── page.tsx          # → CollectionHome page
│   ├── show/[id]/
│   │   └── page.tsx          # → ShowDetail page
│   ├── person/[id]/
│   │   └── page.tsx          # → PersonDetail page
│   ├── find/
│   │   └── page.tsx          # → FindDiscover page
│   ├── settings/
│   │   └── page.tsx          # → Settings page
│   └── api/
│       ├── shows/
│       │   ├── route.ts              # CRUD for saved shows
│       │   └── [id]/route.ts         # Single show operations
│       ├── search/
│       │   └── route.ts              # TMDB search proxy
│       ├── show-details/
│       │   └── [id]/route.ts         # TMDB detail fetch + merge
│       ├── person/
│       │   └── [id]/route.ts         # TMDB person detail
│       ├── ai/
│       │   ├── scoop/route.ts        # AI Scoop generation
│       │   ├── ask/route.ts          # Ask chat (streaming)
│       │   ├── concepts/route.ts     # Concept extraction
│       │   └── recommendations/route.ts  # Concept-based recs
│       ├── settings/
│       │   └── route.ts              # Cloud settings CRUD
│       └── export/
│           └── route.ts              # Export collection as zip
└── pages/
    ├── CollectionHome/
    │   ├── CollectionHome.tsx
    │   ├── hooks/
    │   │   ├── useCollectionHome.ts
    │   │   └── useCollectionFilters.ts
    │   └── features/
    │       ├── StatusGroup/
    │       │   ├── StatusGroup.tsx
    │       │   └── hooks/
    │       │       └── useStatusGroup.ts
    │       └── FilterPanel/
    │           ├── FilterPanel.tsx
    │           └── hooks/
    │               └── useFilterPanel.ts
    ├── ShowDetail/
    │   ├── ShowDetail.tsx
    │   ├── hooks/
    │   │   ├── useShowDetail.ts
    │   │   └── useShowActions.ts
    │   └── features/
    │       ├── HeaderMedia/
    │       │   ├── HeaderMedia.tsx
    │       │   └── hooks/
    │       │       └── useHeaderMedia.ts
    │       ├── CoreFacts/
    │       │   └── CoreFacts.tsx
    │       ├── MyRelationship/
    │       │   ├── MyRelationship.tsx
    │       │   └── hooks/
    │       │       └── useMyRelationship.ts
    │       ├── OverviewScoop/
    │       │   ├── OverviewScoop.tsx
    │       │   └── hooks/
    │       │       └── useScoop.ts
    │       ├── ExploreSimilar/
    │       │   ├── ExploreSimilar.tsx
    │       │   └── hooks/
    │       │       └── useExploreSimilar.ts
    │       ├── StreamingProviders/
    │       │   └── StreamingProviders.tsx
    │       ├── CastCrew/
    │       │   ├── CastCrew.tsx
    │       │   └── hooks/
    │       │       └── useCastCrew.ts
    │       ├── Seasons/
    │       │   └── Seasons.tsx
    │       └── BudgetRevenue/
    │           └── BudgetRevenue.tsx
    ├── PersonDetail/
    │   ├── PersonDetail.tsx
    │   ├── hooks/
    │   │   └── usePersonDetail.ts
    │   └── features/
    │       ├── PersonHeader/
    │       │   └── PersonHeader.tsx
    │       ├── PersonAnalytics/
    │       │   ├── PersonAnalytics.tsx
    │       │   └── hooks/
    │       │       └── usePersonAnalytics.ts
    │       └── Filmography/
    │           └── Filmography.tsx
    ├── FindDiscover/
    │   ├── FindDiscover.tsx
    │   ├── hooks/
    │   │   └── useFindDiscover.ts
    │   └── features/
    │       ├── ModeSwitcher/
    │       │   └── ModeSwitcher.tsx
    │       ├── SearchMode/
    │       │   ├── SearchMode.tsx
    │       │   └── hooks/
    │       │       └── useSearch.ts
    │       ├── AskMode/
    │       │   ├── AskMode.tsx
    │       │   ├── hooks/
    │       │   │   ├── useAskChat.ts
    │       │   │   └── useMentionedShows.ts
    │       │   └── features/
    │       │       ├── ChatView/
    │       │       │   └── ChatView.tsx
    │       │       ├── StarterPrompts/
    │       │       │   └── StarterPrompts.tsx
    │       │       └── MentionedShowsStrip/
    │       │           └── MentionedShowsStrip.tsx
    │       └── AlchemyMode/
    │           ├── AlchemyMode.tsx
    │           ├── hooks/
    │           │   └── useAlchemy.ts
    │           └── features/
    │               ├── ShowSelector/
    │               │   ├── ShowSelector.tsx
    │               │   └── hooks/
    │               │       └── useShowSelector.ts
    │               ├── ConceptStep/
    │               │   └── ConceptStep.tsx
    │               └── ResultsStep/
    │                   └── ResultsStep.tsx
    └── Settings/
        ├── Settings.tsx
        ├── hooks/
        │   └── useSettings.ts
        └── features/
            ├── AppSettings/
            │   └── AppSettings.tsx
            ├── UserSettings/
            │   └── UserSettings.tsx
            ├── AISettings/
            │   └── AISettings.tsx
            ├── IntegrationSettings/
            │   └── IntegrationSettings.tsx
            └── DataManagement/
                ├── DataManagement.tsx
                └── hooks/
                    └── useExport.ts
```

### 4.2 Key Architectural Decisions

- **Humble components:** All TSX files contain markup and binding only. Logic lives in co-located `useFeatureLogic()` hooks.
- **No index.tsx:** Main file matches directory name (`ShowTile/ShowTile.tsx`).
- **Server components for data fetching:** Next.js App Router pages are server components by default. Client interactivity uses `"use client"` directives on feature components that need state/events.
- **API routes as BFF:** All TMDB and AI calls go through Next.js API routes (server-side) to protect API keys and enforce namespace/user isolation.
- **No magic numbers:** All constants, colors, spacing values in `config/` or `theme/`.

---

## 5. Data Layer

### 5.1 Supabase Client Setup

Two clients:
1. **Browser client** (`@supabase/ssr` `createBrowserClient`) — uses `NEXT_PUBLIC_SUPABASE_URL` + `NEXT_PUBLIC_SUPABASE_ANON_KEY`
2. **Server client** (`createServerClient` or `createClient` with service role) — used in API routes, uses `SUPABASE_SERVICE_ROLE_KEY` for operations that bypass RLS

### 5.2 Data Access Pattern

All data access goes through server-side API routes. Client components call API routes via `fetch`. This ensures:
- API keys stay server-side
- Namespace + user_id are always injected server-side
- Consistent data access patterns

### 5.3 Collection CRUD

**`GET /api/shows`** — Fetch all shows for current namespace + user
- Supports query params: `?status=active&showType=tv&tag=horror`
- Always filters by `namespace_id` and `user_id`

**`GET /api/shows/[id]`** — Fetch single show (from DB if saved, merge with TMDB if needed)

**`POST /api/shows`** — Save/update a show
- Accepts full show object
- Applies default values per business rules (Section 7)
- Upserts with merge logic

**`DELETE /api/shows/[id]`** — Remove show from collection
- Deletes the row entirely (clears all My Data)

### 5.4 Show Mapping: TMDB → Show

`src/utils/showMapper.ts`:
- Maps TMDB movie/TV response to `Show` type
- `id` = TMDB ID (as string)
- `externalIds` = `{ tmdb: id }`
- `show_type` = inferred from response shape (`title` field → movie, `name` field → tv)
- Images: construct full URLs using `NEXT_PUBLIC_TMDB_IMAGE_BASE` + size + path
- Logo selection: pick highest-rated English logo, or fall back to first available
- Genres: map TMDB genre objects to string array of names
- Dates: parse with fallback formats
- Providers: extract `watch/providers` by region, store as `{ countries: { [code]: { flatrate, rent, buy } } }`
- Transient data (cast, crew, seasons, videos, recommendations, similar, images): attached to response object but not persisted

### 5.5 Merge Rules

`src/utils/mergeShow.ts`:

When merging new catalog data into an existing saved show:
- **Non-user fields:** `selectFirstNonEmpty(newValue, oldValue)` — never overwrite non-empty stored data with empty/null
- **User fields** (`my_status`, `my_interest`, `my_tags`, `my_score`, `ai_scoop`): resolve by timestamp — keep the newer update date's value; if only one side has a date, keep that side
- Set `details_update_date` to now after merge
- Never change `creation_date` on merge

---

## 6. External Catalog Integration (TMDB)

### 6.1 API Routes

All TMDB calls are server-side (API key protection).

**`GET /api/search?query=...&type=multi|movie|tv&page=1`**
- Calls TMDB `/search/multi` (or `/search/movie`, `/search/tv`)
- Maps results through `showMapper`
- For each result, checks if show exists in user's collection and overlays My Data if so

**`GET /api/show-details/[id]?type=movie|tv`**
- Calls TMDB `/movie/{id}` or `/tv/{id}` with `append_to_response=credits,videos,recommendations,similar,watch/providers,images`
- Maps through `showMapper`
- If show exists in collection, merges using merge rules
- Returns full detail with transient data (cast, crew, seasons, etc.)

**`GET /api/person/[id]`**
- Calls TMDB `/person/{id}` with `append_to_response=combined_credits,images`
- Returns person info, image gallery, filmography grouped by year

### 6.2 Image URL Construction

Utility function:
```typescript
function tmdbImageUrl(path: string | null, size: string): string | null {
  if (!path) return null;
  return `${env.TMDB_IMAGE_BASE}/${size}${path}`;
}
```

Standard sizes:
- Poster: `w342` (tile), `w500` (detail)
- Backdrop: `w1280`
- Logo: `w300`
- Profile: `w185`

---

## 7. Business Rules Implementation

### 7.1 Save Triggers

Implemented in `src/hooks/useShowSave.ts`:

A show is saved to the collection when any of these occur:
1. **Setting any status** → save with that status
2. **Choosing Interested/Excited chip** → save with `status: 'later'`, `interest: 'interested' | 'excited'`
3. **Rating an unsaved show** → save with `status: 'done'` (rating implies watched)
4. **Adding a tag to an unsaved show** → save with `status: 'later'`, `interest: 'interested'`

### 7.2 Default Values

When saving without explicit status:
- `my_status` defaults to `'later'`
- `my_interest` defaults to `'interested'`

Exception: save via rating defaults `my_status` to `'done'`.

### 7.3 Removal Flow

When user reselects the currently active status chip:
1. Show confirmation dialog: "Remove [title] from your collection? This will clear all your data for this show."
2. Track confirmation count in local storage (`statusRemovalCountKey`)
3. After threshold (e.g., 3), offer "Don't ask again" checkbox → sets `hideStatusRemovalConfirmation`
4. On confirm: `DELETE /api/shows/[id]` — removes show and all My Data

### 7.4 Re-Adding a Show

If a show is encountered that's already saved:
- Preserve all existing My Data (status, interest, tags, rating, scoop)
- Refresh public metadata from TMDB
- Merge conflicts resolve by most recent update timestamp per field

### 7.5 Interest Level Logic

- Interest (`interested` | `excited`) only applies when `my_status === 'later'`
- If status changes away from `'later'`, interest value is retained in storage (not cleared) so it restores if status returns to `'later'`
- UI only displays interest chips when status is `'later'`

### 7.6 Tile Indicators

`ShowTile` displays:
- Collection badge when `my_status` exists
- User rating badge when `my_score` exists

---

## 8. Pages & Features — Detailed Behavior

### 8.1 Collection Home (`/home`)

**Layout:**
- Left sidebar: filter panel (All Shows, tag filters, genre/decade/score filters)
- Top: media type toggle (All / Movies / TV)
- Main: show grid grouped by status sections

**Status groups (in order):**
1. **Active** — larger tiles, prominent placement
2. **Excited** — shows where `my_status = 'later'` AND `my_interest = 'excited'`
3. **Interested** — shows where `my_status = 'later'` AND `my_interest = 'interested'`
4. **Other** (collapsed by default) — Wait, Quit, Done, and any Later without interest

**Filtering:**
- `useCollectionFilters` hook manages active filter state
- Persists `lastSelectedFilter` to local storage
- Filters compose: tag filter + media type toggle both apply simultaneously

**Empty states:**
- No shows at all: CTA to Search/Ask ("Start building your collection")
- Filter yields no results: "No results found"

### 8.2 Show Detail (`/show/[id]`)

**Data loading:**
- `useShowDetail` fetches full show details from `/api/show-details/[id]`
- Merges with saved data if show is in collection

**Section hierarchy (matches detail_page_experience.md):**
1. **HeaderMedia** — Backdrop/poster/logo carousel. Trailers inline when available. Graceful fallback to poster-only.
2. **CoreFacts** — Year, runtime (movies) or seasons/episodes (TV), community score bar.
3. **MyRelationship** (toolbar, not in scroll body):
   - Status/Interest chips: Active, Interested, Excited, Done, Quit, Wait
   - My Rating slider
   - Tag picker
4. **Overview + Scoop**:
   - Overview text always visible
   - Scoop toggle button:
     - No scoop cached: "Give me the scoop!"
     - Cached scoop exists: "Show the scoop"
     - Open state: title "The Scoop"
   - Scoop streams progressively (shows "Generating..." during fetch)
   - Freshness: regenerate after 4 hours on demand
   - Only persists if show is in collection
5. **Ask about this show** — CTA button that navigates to `/find` in Ask mode with show context seeded
6. **Genres + Languages** — chip display
7. **Recommendations strand** — horizontal strip of TMDB similar/recommended shows
8. **Explore Similar** — concept-based discovery:
   - "Get Concepts" button → fetches concepts from `/api/ai/concepts`
   - Concept chips appear (selectable, max 8)
   - "Explore Shows" button → fetches recs from `/api/ai/recommendations`
   - Results as horizontal strip with AI reason text
9. **Streaming Providers** — grouped by flatrate/rent/buy with provider logos
10. **Cast & Crew** — horizontal strips, tapping opens `/person/[id]`
11. **Seasons** (TV only) — expandable season/episode list
12. **Budget vs Revenue** (movies, when data available) — simple display

### 8.3 Person Detail (`/person/[id]`)

- **PersonHeader** — Image gallery, name, bio
- **PersonAnalytics** — Charts:
  - Average rating of their projects
  - Top genres (bar chart)
  - Projects by year (timeline)
- **Filmography** — Credits grouped by year, each linking to show detail

### 8.4 Find/Discover (`/find`)

Three modes with a clear mode switcher (tabs or segmented control):

#### Search Mode
- Text input for title/keyword search
- Results in poster grid via `/api/search`
- In-collection items marked with badge
- Tapping opens Show Detail
- Supports "Search on Launch" setting (auto-focus search input)

#### Ask Mode
- Chat UI with user/assistant message bubbles
- Welcome view: 6 random starter prompts (refreshable)
- Sends messages to `/api/ai/ask` (streaming response)
- AI responses parsed for mentioned shows → rendered in horizontal strip below chat
- Mentioned shows use `showList` structured format: `Title::externalId::mediaType;;...`
- Resolve each mentioned show via TMDB lookup; show as interactive if found, non-interactive otherwise
- Conversation context maintained in client state
- After ~10 messages, older turns summarized via AI (preserving persona tone)
- "Ask about a show" variant: seeds conversation context with show data from Detail page

#### Alchemy Mode
Multi-step flow:

**Step 1: Select Shows**
- Search interface to find shows (library + global catalog)
- Selected shows displayed as chips/cards
- Minimum 2 shows required to proceed

**Step 2: Conceptualize**
- "Conceptualize Shows" button → calls `/api/ai/concepts` with multiple show contexts
- Returns concept chips (shared themes across all selected shows)
- User selects 1-8 concepts
- Changing selected shows clears concepts and results

**Step 3: Alchemize**
- "ALCHEMIZE!" button → calls `/api/ai/recommendations` with selected concepts
- Returns 6 recommended shows with per-show reasons
- Each reason references which concepts it matches
- Results displayed as cards with reason text

**Step 4: Chain (optional)**
- "More Alchemy!" button → use result shows as new inputs → back to Step 2

### 8.5 Settings (`/settings`)

Sections:

**App Settings:**
- Font size selector (XS / S / M / L / XL / XXL) — stored in local storage, applied via CSS custom property
- Search on launch toggle — stored in local storage

**User:**
- Username text field — saved to `cloud_settings`

**AI:**
- AI API key input — saved to `cloud_settings` (server-side only; never committed)
- AI model selection dropdown — saved to `cloud_settings`
- Note: In benchmark mode, `AI_API_KEY` and `AI_MODEL` env vars take precedence

**Integrations:**
- TMDB API key input — saved to `cloud_settings`
- Note: In benchmark mode, `TMDB_API_KEY` env var takes precedence

**Your Data:**
- "Export My Data" button → calls `/api/export` → downloads `.zip` containing JSON backup
  - JSON includes all saved shows with all My Data fields
  - Dates encoded as ISO 8601
  - File named with username and export date
- Import/Restore: placeholder UI noting "Coming soon" (not implemented per PRD open questions)

---

## 9. AI Integration

### 9.1 Provider Abstraction

`src/utils/ai.ts`:

```typescript
interface AIProvider {
  chat(messages: Message[], options?: StreamOptions): AsyncIterable<string>;
}
```

- Supports OpenAI-compatible APIs
- Reads `AI_API_KEY`, `AI_MODEL`, `AI_BASE_URL` from env (with fallback to user's `cloud_settings`)
- All AI calls are server-side (API routes)
- Streaming supported for Scoop and Ask

### 9.2 AI Scoop (`/api/ai/scoop`)

**Input:** Show title, year, type, overview, genres, community score, user's collection context (optional)

**Prompt contract:**
- Persona: fun, chatty TV/movie nerd friend
- Structure: personal take → honest stack-up → "The Scoop" centerpiece → fit/warnings → verdict
- Spoiler-safe by default
- 150-350 words
- Streams progressively

**Caching:**
- Check `ai_scoop_update_date` — if < 4 hours old, return cached `ai_scoop`
- Otherwise regenerate and update `ai_scoop` + `ai_scoop_update_date`
- Only persist to DB if show is in collection

### 9.3 Ask Chat (`/api/ai/ask`)

**Input:** Conversation messages, user's library summary, optional seeded show context

**Prompt contract:**
- Persona: same friend persona as Scoop
- Stay within TV/movies domain
- Respond like a friend in dialogue, not an essay
- Pick favorites confidently
- Use bulleted lists for multi-recs

**Structured output:**
- Response includes `commentary` (user-facing text) and `showList` (machine-readable)
- `showList` format: `Title::tmdbId::movie|tv;;Title2::tmdbId2::movie|tv;;...`
- Parse `showList`, resolve each via TMDB, attach to response

**Summarization:**
- After ~10 messages, summarize older turns into 1-2 sentences
- Summary preserves persona tone (not sterile system voice)

### 9.4 Concepts (`/api/ai/concepts`)

**Input:** One or more shows (title, overview, genres, type)

**Prompt contract:**
- Return bullet list only
- Each concept 1-3 words, evocative, spoiler-free
- No generic concepts ("good characters", "great story")
- For multi-show: concepts must be shared across all input shows
- Order by strength (best "aha" concepts first)
- Cover different axes: structure, vibe, emotion, craft
- 8 concepts per request

### 9.5 Concept-Based Recommendations (`/api/ai/recommendations`)

**Input:** Selected concepts, source show(s), user's library (to avoid duplicates)

**Prompt contract:**
- Return list of recommended shows with concise reasons (not synopses)
- Reasons explicitly reference selected concepts
- Bias toward recent shows but allow classics/hidden gems
- Include TMDB ID and media type for each recommendation
- 5 recs for Explore Similar, 6 for Alchemy

**Resolution:**
- For each recommended show: look up TMDB by ID
- Accept if title matches case-insensitively
- If found: full Show object with AI reason as transient text
- If not found: show as non-interactive title or hand off to Search

### 9.6 Fallback Handling

- If structured output parsing fails: retry once with stricter formatting instructions
- If retry fails: fall back to unstructured commentary + Search handoff
- If recommendation can't resolve to real TMDB item: show title as non-interactive

---

## 10. UI & Interaction Details

### 10.1 Sidebar / Filter Panel

- **All Shows** (default)
- **Tag filters** — one per unique tag in collection, plus "No tags" if any tagless shows exist
- **Data filters:**
  - Genre (one per genre present in collection)
  - Decade (derived from release/air dates)
  - Community score ranges
- Selected filter persisted in local storage as `lastSelectedFilter`
- Filters compose with media type toggle

### 10.2 Show Tiles

- Poster image (fallback to placeholder)
- Title overlay at bottom
- Badges: collection indicator (checkmark/dot), user rating value
- Click/tap → navigate to Show Detail

### 10.3 Status Chips UX

Display order: Active | Interested | Excited | Wait | Done | Quit

Behavior:
- Tap unselected chip → set that status (+ interest if Interested/Excited) → save
- Tap already-selected chip → trigger removal flow (confirm dialog)
- Visually highlight the active status

### 10.4 Responsive Design

- Desktop: sidebar always visible, multi-column grids
- Tablet: collapsible sidebar, 3-column grids
- Mobile: bottom nav, single/double column grids, full-width detail page

---

## 11. Data Export

### Export Flow (`/api/export`)

1. Query all shows for current namespace + user
2. Build JSON structure:
   ```json
   {
     "exportDate": "2024-01-15T10:30:00Z",
     "userName": "...",
     "showCount": 42,
     "shows": [
       {
         "id": "...",
         "title": "...",
         "showType": "tv",
         "myStatus": "active",
         "myStatusUpdateDate": "2024-01-10T...",
         "myInterest": null,
         "myTags": ["cozy", "bingeworthy"],
         "myTagsUpdateDate": "2024-01-08T...",
         "myScore": 8.5,
         "myScoreUpdateDate": "2024-01-12T...",
         "aiScoop": "...",
         "aiScoopUpdateDate": "2024-01-09T...",
         ...allCatalogFields
       }
     ]
   }
   ```
3. Package as `.zip` file
4. Return as downloadable response with `Content-Disposition` header
5. Filename: `showbiz_export_{userName}_{date}.zip`

---

## 12. Testing Strategy

### 12.1 Test Data Isolation

- All test data created with `is_test = true`
- `npm run test:reset` executes: `DELETE FROM shows WHERE namespace_id = $NAMESPACE AND is_test = true`
- Tests use a dedicated namespace or the current `NAMESPACE_ID`

### 12.2 Test Categories

**Unit tests** (co-located with source):
- `mergeShow.test.ts` — merge rules (non-empty preservation, timestamp resolution)
- `showMapper.test.ts` — TMDB response mapping
- Business rule tests: save triggers, default values, removal semantics
- AI response parsing: `showList` format parsing, fallback handling

**Integration tests:**
- API route tests with Supabase (test namespace)
- Save/remove/re-add lifecycle
- Filter queries (status, tag, type combinations)
- Export produces valid JSON zip

**E2E tests (optional):**
- Core journeys: search → save → collection → detail → update → remove
- Alchemy flow end-to-end
- Ask conversation with mentioned shows

### 12.3 Dev Scripts

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "test": "vitest",
    "test:watch": "vitest --watch",
    "db:migrate": "npx supabase db push",
    "db:seed": "tsx scripts/seed.ts",
    "test:reset": "tsx scripts/reset-test-data.ts"
  }
}
```

---

## 13. Implementation Order

### Phase 1: Foundation
1. Project bootstrap (Next.js + Supabase + Tailwind)
2. Environment config and typed env access
3. Database schema migration
4. Supabase client setup (browser + server)
5. Identity middleware (namespace + user injection)
6. Theme tokens and global styles
7. Layout component (shell with sidebar + top nav)

### Phase 2: Core Data & Collection
8. TMDB API integration (server-side routes)
9. Show mapper utility
10. Show CRUD API routes
11. Merge utility
12. Collection Home page with status grouping
13. ShowTile component with badges
14. Filter panel (sidebar) with tag/genre/decade/score filters
15. Media type toggle

### Phase 3: Show Detail
16. Show Detail page with full section hierarchy
17. HeaderMedia (backdrop/poster/logo carousel)
18. CoreFacts + community score
19. StatusChips toolbar (with save/remove business rules)
20. RatingBar (with auto-save-as-Done)
21. TagPicker (with auto-save-as-Later)
22. Overview section
23. Streaming providers
24. Cast/Crew strips
25. Seasons (TV) and Budget/Revenue (movies)
26. Traditional recommendations strand

### Phase 4: AI Features
27. AI provider abstraction
28. AI Scoop (generation, streaming, caching, persistence rules)
29. Ask chat (streaming, conversation state, summarization)
30. Mentioned shows parsing and resolution
31. Starter prompts (6 random, refresh)
32. Concept extraction (single-show and multi-show)
33. Concept-based recommendations (Explore Similar: 5 recs)
34. "Ask about this show" flow (context seeding from Detail)

### Phase 5: Alchemy & Person
35. Alchemy mode (multi-step: select → conceptualize → alchemize → chain)
36. Alchemy recommendations (6 recs per round)
37. Person Detail page (bio, analytics, filmography)
38. Person analytics charts

### Phase 6: Settings & Polish
39. Settings page (font size, search on launch, username, API keys)
40. Data export (JSON zip download)
41. Find/Discover mode switcher
42. Empty states for all pages
43. Confirmation dialogs (removal, with "don't ask again")
44. Responsive layout adjustments
45. Local storage persistence (filters, font size, UI prefs)

### Phase 7: Testing & Hardening
46. Unit tests for business rules, mappers, merge logic
47. Integration tests for API routes
48. Test data seed/reset scripts
49. Error handling and loading states across all pages
50. Final review of all business rules against PRD
