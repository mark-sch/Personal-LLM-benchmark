# Implementation Plan: Personal TV + Movie Companion

> Generated from PRD analysis. Covers architecture, schema, component design, AI integration, and phased build order.

---

## 1. Executive Summary

Build a Next.js web application backed by Supabase that lets users collect, organize, rate, and discover TV shows and movies. Discovery is powered by conversational AI ("Ask") and a concept-blending engine ("Alchemy"). All user data is scoped by `(namespace_id, user_id)` and persists server-side.

**Core principles**
- User edits always win over refreshed catalog data.
- Auto-save feels natural; status/rating/tag changes implicitly add shows to the collection.
- AI surfaces share one consistent persona: a fun, chatty, spoiler-safe TV/movie nerd friend.
- Discovery recommendations must map to real catalog items.

---

## 2. Technology Stack

| Layer | Choice | Rationale |
|-------|--------|-----------|
| Framework | Next.js (latest stable, App Router) | Required by infra rider; gives API routes + SSR/SSG |
| Language | TypeScript | Type safety across DB ↔ API ↔ UI |
| Styling | Tailwind CSS + shadcn/ui | Rapid UI, accessible primitives |
| Persistence | Supabase (PostgreSQL + PostgREST) | Required by infra rider; hosted or local |
| Auth (dev) | Dev identity injection | Header/default user per namespace (benchmark-friendly) |
| Auth (future) | OAuth swap-in | Schema must support it without redesign |
| AI | OpenAI/Anthropic via server routes | API keys from env or user settings; never committed |
| External catalog | TMDB (or equivalent) | Movie/TV metadata, search, images, providers |
| State management | React Server Components + Zustand (client) | Server-first where possible; client cache for UI state |
| Icons | Lucide React | Consistent iconography |

---

## 3. Database Schema (Supabase)

### 3.1 Tables

#### `namespaces`
```sql
id uuid primary key default gen_random_uuid();
code text unique not null; -- human-readable namespace_id / run_id
created_at timestamptz default now();
```

#### `users`
```sql
id uuid primary key default gen_random_uuid();
namespace_id uuid references namespaces(id) on delete cascade;
email text; -- nullable in dev mode
username text;
created_at timestamptz default now();
unique(namespace_id, id); -- scoped lookup
```

#### `shows` (catalog + user overlay)
```sql
id text primary key; -- external catalog id (e.g., tmdb-12345)
namespace_id uuid references namespaces(id) on delete cascade;
user_id uuid references users(id) on delete cascade;

title text not null;
show_type text not null check (show_type in ('movie','tv','person','unknown'));
external_ids jsonb default '{}';

overview text;
genres text[] default '{}';
tagline text;
homepage text;
original_language text;
spoken_languages text[] default '{}';
languages text[] default '{}';

poster_url text;
backdrop_url text;
logo_url text;
network_logos text[] default '{}';

vote_average numeric;
vote_count int;
popularity numeric;

last_air_date date;
first_air_date date;
release_date date;

runtime int;
budget bigint;
revenue bigint;

series_status text;
number_of_episodes int;
number_of_seasons int;
episode_run_time int[] default '{}';

-- user overlay ("My Data")
my_tags text[] default '{}';
my_tags_update_date timestamptz;
my_score numeric;
my_score_update_date timestamptz;
my_status text check (my_status in ('active','next','later','done','quit','wait'));
my_status_update_date timestamptz;
my_interest text check (my_interest in ('excited','interested'));
my_interest_update_date timestamptz;

-- ai data
ai_scoop text;
ai_scoop_update_date timestamptz;

-- metadata
provider_data jsonb;
details_update_date timestamptz;
creation_date timestamptz default now();
is_test boolean default false;

unique(namespace_id, user_id, id);
```

#### `app_metadata`
```sql
namespace_id uuid references namespaces(id) on delete cascade;
user_id uuid references users(id) on delete cascade;
data_model_version int default 3;
primary key (namespace_id, user_id);
```

#### `cloud_settings`
```sql
namespace_id uuid references namespaces(id) on delete cascade;
user_id uuid references users(id) on delete cascade;
user_name text;
version bigint; -- epoch seconds for conflict resolution
catalog_api_key text;
ai_api_key text;
ai_model text default 'gpt-4o';
primary key (namespace_id, user_id);
```

#### `local_settings` (stored server-side per user; client may mirror)
```sql
namespace_id uuid references namespaces(id) on delete cascade;
user_id uuid references users(id) on delete cascade;
auto_search boolean default false;
font_size text default 'M' check (font_size in ('XS','S','M','L','XL','XXL'));
primary key (namespace_id, user_id);
```

#### `ui_state`
```sql
namespace_id uuid references namespaces(id) on delete cascade;
user_id uuid references users(id) on delete cascade;
hide_status_removal_confirmation boolean default false;
status_removal_count int default 0;
last_selected_filter jsonb;
primary key (namespace_id, user_id);
```

#### `chat_sessions` (transient, server-side session only)
```sql
id uuid primary key default gen_random_uuid();
namespace_id uuid references namespaces(id) on delete cascade;
user_id uuid references users(id) on delete cascade;
mode text not null check (mode in ('ask','alchemy_concepts','alchemy_recs','explore_similar','scoop'));
context jsonb default '[]'; -- array of turns
summarized_context text;
created_at timestamptz default now();
updated_at timestamptz default now();
```

### 3.2 Row Level Security (RLS)

Every table must enforce:
```sql
-- namespace isolation: queries include namespace_id
-- user scoping: user-owned rows filtered by user_id
```

Policies (per table):
- `shows`: users can only read/write rows where `user_id = current_user_id()` within their namespace.
- `cloud_settings`, `local_settings`, `ui_state`, `app_metadata`: single row per user, read/write own only.
- `chat_sessions`: read/write own only.

---

## 4. Identity & Isolation Architecture

### 4.1 Dev/Benchmark Identity Injection

Create a thin auth middleware (`middleware.ts`):
- Reads `X-Namespace-Id` header (or env `BENCHMARK_NAMESPACE`).
- Reads `X-User-Id` header (falls back to a default user in that namespace).
- Upserts `namespaces` + `users` on first request.
- Attaches `namespace_id` and `user_id` to the request context (e.g., Next.js `headers()` or a lightweight context provider).
- **Gated**: if `NODE_ENV=production` and no OAuth config, reject or redirect.

### 4.2 Migration Path to Real Auth

- Replace middleware logic: instead of header injection, validate JWT from OAuth provider.
- Map OAuth `sub` → `users.id` (or store mapping table).
- Schema remains unchanged because `user_id` is already an opaque string/UUID.

### 4.3 Data Partitioning

All data queries MUST include `(namespace_id, user_id)`. No global unscoped reads.

---

## 5. External Catalog Integration (TMDB)

### 5.1 Responsibilities
- Search by title/keywords.
- Fetch show details (meta, images, cast, crew, recommendations, videos, providers).
- Fetch person details + filmography.
- Image URL construction (TMDB image CDN).

### 5.2 Data Flow
1. Client searches → hits Next.js API route `/api/search?q=...`.
2. Server calls TMDB, decodes payload into `Show` shape.
3. For each result, check if user already has a saved version in Supabase; if so, merge and return user overlay.
4. Transient data (cast, crew, seasons, videos, recommendations) is fetched on-demand for Detail pages and NOT persisted in `shows`.

### 5.3 Merge Rules (on refresh/re-add)
- Non-"my" fields: `selectFirstNonEmpty(new, old)` — never overwrite non-empty with empty.
- "My" fields: resolve by `update_date` timestamp (newer wins).
- `details_update_date` set to "now" after merge.
- `creation_date` immutable after first save.

---

## 6. API Layer (Next.js Route Handlers)

### 6.1 Core Routes

| Route | Method | Purpose |
|-------|--------|---------|
| `/api/search` | GET | Search TMDB catalog, merge with user data |
| `/api/shows/[id]` | GET/PUT/DELETE | Get/update/remove a show in collection |
| `/api/shows/[id]/scoop` | POST | Generate/stream AI Scoop |
| `/api/shows/[id]/concepts` | POST | Get concepts for Explore Similar |
| `/api/shows/[id]/explore` | POST | Recommendations from selected concepts |
| `/api/people/[id]` | GET | Person detail + filmography |
| `/api/ask` | POST | Chat turn in Ask mode |
| `/api/alchemy/concepts` | POST | Concepts from 2+ shows |
| `/api/alchemy/recommendations` | POST | Recommendations from selected concepts |
| `/api/settings` | GET/PUT | Cloud/local settings |
| `/api/export` | GET | Export user data as ZIP |
| `/api/reset` | POST | Delete all data for namespace (testing) |

### 6.2 AI Routes Design

All AI routes are **server-only** to protect API keys.

- Streaming: use Vercel AI SDK or native OpenAI streaming for Scoop and Ask.
- Structured output: use function calling / JSON mode for `showList` in Ask and concept lists.
- Parser fallback: if structured parse fails, retry once with stricter prompt; otherwise return unstructured commentary.

---

## 7. Component Architecture

### 7.1 Layout Shell

```
AppShell
├── Sidebar (filters, tags, navigation)
│   ├── All Shows
│   ├── Tag filters (dynamic)
│   ├── Data filters (genre, decade, score)
│   └── Media type toggle (All / Movies / TV)
├── Main Content Area
│   ├── Home (CollectionView)
│   ├── Detail (ShowDetail)
│   ├── Person (PersonDetail)
│   ├── Find/Discover (DiscoverHub)
│   └── Settings (SettingsPage)
└── Global Nav (Find, Settings)
```

### 7.2 Key Components

#### Collection Home (`CollectionView`)
- Group shows into status sections:
  1. Active (larger tiles)
  2. Excited (`Later` + `Excited`)
  3. Interested (`Later` + `Interested`)
  4. Other (`Wait`, `Quit`, `Done`, unclassified `Later`)
- Media-type toggle filters on top.
- Empty state prompts to Search/Ask.
- Each tile: poster, title, in-collection badge, rating badge.

#### Show Detail (`ShowDetail`)
Sections in order:
1. **HeaderMediaCarousel** — backdrops, posters, logos, trailers (inline playback)
2. **CoreFacts** — year, runtime/seasons, community score
3. **MyRelationshipToolbar** — status chips (Active, Interested, Excited, Done, Quit, Wait), rating slider, tag chips + picker
4. **Overview + ScoopToggle** — overview text; "Give me the scoop!" → streams AI Scoop
5. **AskAboutShowCTA** — links to Ask with show context seeded
6. **Genres + Languages**
7. **RecommendationsStrand** — traditional similar/recommended shows
8. **ExploreSimilar** — Get Concepts → concept chips → Explore Shows → recs grid
9. **StreamingProviders** — "Stream It" section
10. **CastCrewStrands** — horizontal scroll → Person Detail
11. **SeasonsList** (TV only)
12. **BudgetRevenue** (movies)

#### Discover Hub (`DiscoverHub`)
Mode switcher: Search | Ask | Alchemy
- **Search**: text input → poster grid results
- **Ask**: chat UI with message list + mentioned-shows horizontal strip + starter prompts
- **Alchemy**: multi-step wizard
  1. Select 2+ starting shows (search + library)
  2. Conceptualize → concept chips
  3. Select 1–8 concepts
  4. Alchemize! → 6 recs
  5. "More Alchemy!" chains results as new inputs

#### Person Detail (`PersonDetail`)
- Image gallery, name, bio
- Analytics charts (avg ratings by project, top genres, projects-by-year)
- Filmography grouped by year → credit opens Show Detail

#### Settings (`SettingsPage`)
- Font size / readability
- Search on launch toggle
- Username
- AI provider key + model selection
- Catalog API key
- Export My Data (ZIP with JSON backup, ISO-8601 dates)

---

## 8. State Management & Data Flow

### 8.1 Server-First Data

Use React Server Components (RSC) as the default:
- Collection Home fetches filtered shows server-side.
- Show Detail prefetches show + user overlay server-side.
- Person Detail prefetches person + filmography server-side.

### 8.2 Client Cache (Zustand)

Lightweight stores for:
- `useChatStore` — current Ask/Alchemy session context, messages, mentioned shows
- `useUIStore` — sidebar filter selection, media-type toggle, mode switcher
- `useSettingsStore` — local settings mirrored from server

### 8.3 Mutations

Use Server Actions or API routes with optimistic updates:
- Status change → optimistically update tile badges, revalidate `/api/shows`.
- Rating/tag change → optimistically update UI, revalidate.
- AI Scoop request → stream response into UI, persist on completion only if show is in collection.

---

## 9. AI Integration Deep Dive

### 9.1 Prompt Architecture

Maintain a shared `ai/prompts.ts` with base personality + surface-specific overrides.

**Base personality** (all surfaces):
- Fun, chatty TV/movie nerd friend.
- Spoiler-safe by default.
- Opinionated, honest, vibe-first.
- Stay in TV/movies domain.

**Surface overrides:**
- `scoopPrompt(showContext)` → structured mini blog-post (~150–350 words)
- `askPrompt(libraryContext, chatHistory, userMessage)` → conversational, 1–3 paragraphs + bulleted lists
- `askWithMentionsPrompt(...)` → outputs `{ commentary, showList }` where `showList` format is `Title::externalId::mediaType;;...`
- `conceptPrompt(shows[])` → bullet list, 1–3 words each, shared across all inputs for multi-show
- `recommendationPrompt(selectedConcepts, libraryContext)` → 5–6 recs with reasons citing concepts

### 9.2 Context Assembly

Before every AI call, assemble:
1. User's library (saved shows + My Data) as taste context.
2. Current show(s) for scoped requests.
3. Recent conversation turns (raw or summarized).
4. Selected concepts for recommendation calls.

**Summarization strategy:**
- After ~10 turns, summarize older turns into 1–2 sentences preserving persona tone.
- Truncate or summarize to fit token budget.

### 9.3 Response Handling

| Surface | Output Type | Parser | Fallback |
|---------|-------------|--------|----------|
| Scoop | Stream text | N/A | N/A |
| Ask | Text | N/A | N/A |
| Ask w/ Mentions | JSON | Custom string parser | Retry once → plain text + search handoff |
| Concepts | Text (bullets) | Line split + trim | Retry once |
| Recs | JSON array | JSON parser | Retry once → plain text |

### 9.4 Catalog Resolution

AI returns `title + externalId + mediaType`.
Resolution flow:
1. Look up external catalog by `externalId`.
2. Accept first result whose title matches case-insensitively.
3. If matched → create/select real `Show` object, attach AI reason as transient text.
4. If unmatched → display non-interactive or hand off to Search.

---

## 10. Feature Implementation Phases

### Phase 1: Foundation (Week 1)
- [ ] Initialize Next.js project with TypeScript, Tailwind, shadcn/ui
- [ ] Set up Supabase client, RLS policies, migrations
- [ ] Create `.env.example` with all required variables
- [ ] Implement dev identity middleware (namespace + user injection)
- [ ] Build database schema and seed scripts
- [ ] Create `npm run dev`, `npm test`, `npm run test:reset` scripts
- [ ] Set up TMDB API client and search route
- [ ] Basic app shell with sidebar + main content area

### Phase 2: Collection Core (Week 2)
- [ ] Collection Home with status grouping
- [ ] Show tile component with badges
- [ ] Show Detail page skeleton (header, facts, overview)
- [ ] Status/Interest chips with auto-save
- [ ] Rating slider with auto-save
- [ ] Tag picker with auto-save
- [ ] Media-type toggle
- [ ] Sidebar filters (tags, genre, decade, score)
- [ ] Empty states

### Phase 3: Discovery - Search & Ask (Week 3)
- [ ] Search UI + results grid
- [ ] Ask chat UI with message list
- [ ] AI route for Ask with streaming
- [ ] Mentioned shows strip + parsing
- [ ] Starter prompts (6 random, refreshable)
- [ ] Conversation summarization logic
- [ ] "Ask about this show" from Detail

### Phase 4: Discovery - Alchemy & Explore Similar (Week 4)
- [ ] Concept generation prompt + route
- [ ] Alchemy multi-step flow (select shows → concepts → recs)
- [ ] Explore Similar from Detail
- [ ] Recommendation resolution to real catalog items
- [ ] Chaining ("More Alchemy!")

### Phase 5: AI Scoop & Person Pages (Week 5)
- [ ] Scoop generation + streaming UI
- [ ] Cache/freshness logic (4 hours)
- [ ] Person Detail page
- [ ] Filmography grouping
- [ ] Lightweight analytics charts (recharts or similar)
- [ ] Cast/Crew strands on Show Detail

### Phase 6: Polish & Infrastructure (Week 6)
- [ ] Settings page (font, search-on-launch, username, keys, model)
- [ ] Export My Data as ZIP
- [ ] Data migration framework (preserve across model versions)
- [ ] Responsive design pass
- [ ] Error boundaries + loading states
- [ ] Testing: unit (Jest/Vitest), integration (Playwright)
- [ ] Documentation: README, AGENTS.md update

---

## 11. Business Rules Checklist

These must be enforced in code:

- [ ] **Saving triggers**: setting status, choosing interest chip, rating unsaved show, adding tag to unsaved show.
- [ ] **Default save**: status=`Later`, interest=`Interested`. Exception: first save via rating → `Done`.
- [ ] **Removal**: clearing status shows confirmation; removes show + all My Data.
- [ ] **Re-add**: preserve latest My Data; refresh public metadata; merge by timestamp.
- [ ] **Timestamp tracking**: every my* field has an update_date.
- [ ] **AI persistence**: Scoop persists only if show in collection; chat/Alchemy/session data is transient.
- [ ] **Tile indicators**: in-collection badge + rating badge.
- [ ] **Display rule**: user-overlay version shown everywhere.

---

## 12. Testing Strategy

### 12.1 Unit Tests
- Merge logic (selectFirstNonEmpty, timestamp resolution)
- Concept parser, showList parser
- Filter/sort functions for Collection Home
- Prompt builders

### 12.2 Integration Tests
- API routes with test namespace + user
- AI route mocks (avoid burning API credits)
- TMDB decoding/mapping

### 12.3 E2E Tests (Playwright)
- Add show → set status → verify collection
- Rate unsaved show → verify auto-save as Done
- Search → open detail → verify data
- Ask flow: send message → verify mentioned shows strip
- Alchemy flow: select 2 shows → conceptualize → select concepts → alchemize
- Export → verify ZIP contains valid JSON

### 12.4 Test Isolation
- All tests run inside a dedicated test namespace.
- `npm run test:reset` truncates data for the test namespace.
- Never require global DB teardown.

---

## 13. Environment & Secrets

### `.env.example`
```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY= # server-only

# TMDB / Catalog
TMDB_API_KEY=

# AI Provider (OpenAI or Anthropic)
OPENAI_API_KEY=
# ANTHROPIC_API_KEY=

# Dev/Benchmark
BENCHMARK_NAMESPACE=default-run
DEFAULT_USER_ID=
```

### `.gitignore`
```
.env*
!.env.example
```

---

## 14. Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| AI API latency/cost | Server-side streaming; cache Scoop for 4h; summarize old chat turns |
| TMDB rate limits | Server-side caching layer (Redis or Supabase cache table); debounce search |
| Schema drift on upgrade | Versioned migrations; `AppMetadata.dataModelVersion` check on boot |
| Prompt brittleness | Parser fallback chain; structured output + retry; golden set regression tests |
| Namespace collision | RLS + strict query scoping; middleware always injects namespace |
| OAuth migration later | Keep `user_id` opaque; store provider mapping separately |

---

## 15. Success Criteria

- [ ] User can build a collection via Search/Ask/Alchemy.
- [ ] User can organize with statuses, interest, tags, ratings.
- [ ] AI discovery (Ask, Alchemy, Explore Similar, Scoop) feels on-brand and maps to real shows.
- [ ] Data persists across sessions within a namespace; no data loss on refresh.
- [ ] Export produces a valid ZIP with ISO-8601 dates.
- [ ] Tests pass in isolation without Docker.
- [ ] Repo runs with `npm install` + env vars only (no code edits).
