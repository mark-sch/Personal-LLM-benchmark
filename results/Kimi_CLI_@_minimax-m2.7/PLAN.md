# Implementation Plan: TV Companion App

## 1. Project Overview

A personal TV + movie companion app for collecting, organizing, rating, and discovering entertainment. Users build their version of each show (status, interest, tags, rating, AI Scoop), and the app uses that taste profile to power multiple discovery paths.

**Tech Stack:**
- **Runtime**: Next.js (latest stable)
- **Persistence**: Supabase (official client libraries)
- **AI**: External LLM provider (configurable via env vars)

---

## 2. Project Structure

```
/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── (app)/              # Main app routes (authenticated shell)
│   │   │   ├── page.tsx        # Collection Home
│   │   │   ├── show/[id]/      # Show Detail
│   │   │   ├── person/[id]/     # Person Detail
│   │   │   ├── find/           # Find/Discover hub
│   │   │   └── settings/       # Settings page
│   │   └── api/                # API routes
│   │       ├── shows/          # Show CRUD, search
│   │       ├── persons/        # Person data
│   │       ├── ai/             # AI surfaces (Scoop, Ask, Concepts, Alchemy)
│   │       └── admin/          # Dev/test endpoints
│   ├── components/             # UI components
│   │   ├── show/               # ShowTile, ShowGrid, StatusChips, RatingBar, TagPicker
│   │   ├── person/             # PersonCard, Filmography
│   │   ├── discover/           # SearchBar, AskChat, AlchemyFlow, ConceptSelector
│   │   ├── layout/             # AppShell, NavPanel, FilterSidebar
│   │   └── ui/                 # Shared UI primitives (Button, Chip, Modal, etc.)
│   ├── lib/
│   │   ├── supabase/           # Supabase client setup, types
│   │   ├── catalog/            # External catalog API integration
│   │   ├── ai/                 # AI provider abstraction, prompt templates
│   │   └── storage/            # Local storage utilities
│   ├── hooks/                  # React hooks (useShows, useUser, useSession, etc.)
│   └── types/                  # TypeScript types (matching storage schema)
├── supabase/
│   └── migrations/            # Database schema migrations
├── public/
├── .env.example                # Environment variables template
├── package.json
├── next.config.js
└── tsconfig.json
```

---

## 3. Database Schema (Supabase)

### 3.1 Core Tables

#### `shows`
| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID | Primary key |
| `external_id` | TEXT | External catalog ID |
| `title` | TEXT | Display title |
| `show_type` | TEXT | 'movie' \| 'tv' |
| `overview` | TEXT | |
| `genres` | TEXT[] | Genre names |
| `tagline` | TEXT | |
| `poster_url` | TEXT | |
| `backdrop_url` | TEXT | |
| `logo_url` | TEXT | |
| `vote_average` | FLOAT | Community score |
| `vote_count` | INT | |
| `popularity` | FLOAT | |
| `release_date` | DATE | |
| `runtime` | INT | Movies: minutes |
| `number_of_seasons` | INT | TV |
| `number_of_episodes` | INT | TV |
| `budget` | BIGINT | Movies |
| `revenue` | BIGINT | Movies |
| `provider_data` | JSONB | Streaming availability |
| `details_update_date` | TIMESTAMPTZ | |
| `creation_date` | TIMESTAMPTZ | |
| `is_test` | BOOLEAN | Default false |
| `namespace_id` | TEXT | **Indexed, required** |
| `user_id` | TEXT | **Indexed, required** |
| `my_status` | TEXT | Active/Later/Wait/Done/Quit |
| `my_status_update_date` | TIMESTAMPTZ | |
| `my_interest` | TEXT | Interested/Excited |
| `my_interest_update_date` | TIMESTAMPTZ | |
| `my_tags` | TEXT[] | |
| `my_tags_update_date` | TIMESTAMPTZ | |
| `my_score` | FLOAT | User rating |
| `my_score_update_date` | TIMESTAMPTZ | |
| `ai_scoop` | TEXT | |
| `ai_scoop_update_date` | TIMESTAMPTZ | |

**Indexes:** `(namespace_id, user_id)`, `(namespace_id, user_id, my_status)`

#### `user_settings`
| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID | Primary key |
| `user_id` | TEXT | **Indexed** |
| `namespace_id` | TEXT | **Indexed** |
| `user_name` | TEXT | |
| `ai_model` | TEXT | |
| `ai_api_key` | TEXT | Server-only |
| `catalog_api_key` | TEXT | |
| `auto_search` | BOOLEAN | Search on launch |
| `font_size` | TEXT | XS-XXL |
| `version` | BIGINT | Conflict resolution |
| `updated_at` | TIMESTAMPTZ | |

**Composite unique:** `(user_id, namespace_id)`

#### `app_metadata`
| Column | Type | Notes |
|--------|------|-------|
| `id` | TEXT | Primary key ('globalSettings') |
| `data_model_version` | INT | Default 3 |

### 3.2 Migrations Strategy

1. Create migrations in `supabase/migrations/` following semantic versioning
2. Use `supabase` CLI for deployment
3. Seed with minimal data if needed for testing

---

## 4. Infrastructure Requirements

### 4.1 Environment Variables (`.env.example`)

```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# AI Provider (required)
AI_API_KEY=your_api_key
AI_MODEL=your_model_preference

# Catalog Provider (e.g., TMDB)
CATALOG_API_KEY=your_tmdb_key
CATALOG_API_URL=https://api.themoviedb.org/3

# Benchmark/Testing
NAMESPACE_ID=default
DEV_USER_ID=dev_user_001
```

### 4.2 Identity Injection (Benchmark Mode)

- Accept `X-User-Id` header in API routes for dev/test
- Fall back to `DEV_USER_ID` env var if header absent
- Gate behind `NODE_ENV !== 'production'`
- All API routes must resolve `user_id` before processing

### 4.3 Namespace Isolation

- Every show record includes `namespace_id` in primary key
- All queries filter by `namespace_id`
- Test reset scripts operate within a single namespace

### 4.4 Dev Scripts (package.json)

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "test": "jest",
    "test:reset": "supabase exec --namespace $NAMESPACE_ID --command 'reset_test_data.sh'"
  }
}
```

---

## 5. Core Features Implementation

### 5.1 Collection Home

**Route:** `/` (or `/collection`)

**Requirements (PRD-042, PRD-043, PRD-044, PRD-045):**
- Display saved shows grouped by status sections:
  1. **Active** (prominent/larger tiles)
  2. **Excited** (Later + Excited interest)
  3. **Interested** (Later + Interested interest)
  4. **Other** (Wait, Quit, Done, unclassified Later)
- Support media-type toggle: All / Movies / TV
- Render poster, title, My Data badges (collection indicator, user rating)
- Filter sidebar: tag filters, genre, decade, community score
- Empty states for no collection / no filter results

**Data Flow:**
1. Query `shows` table filtered by `(namespace_id, user_id)` and active filters
2. Group results by status/interest
3. Render tile grid with badges

### 5.2 Search (Find → Search)

**Route:** `/find` (mode: search)

**Requirements (PRD-047, PRD-048, PRD-049, PRD-050):**
- Text search by title/keywords against external catalog (TMDB)
- Results in poster grid
- Mark in-collection items
- Option to auto-open on launch if `auto_search` setting is true
- **No AI voice** — straightforward catalog search

**Data Flow:**
1. User types query → call catalog API (TMDB search endpoint)
2. Merge results with local `shows` for collection markers
3. Render poster grid
4. Clicking show opens Detail

### 5.3 Ask (Find → Ask)

**Route:** `/find` (mode: ask)

**Requirements (PRD-065, PRD-066, PRD-067, PRD-068, PRD-069, PRD-070, PRD-071, PRD-072, PRD-073, PRD-074):**
- Chat UI with user/assistant turns
- AI responds in character (fun, chatty, opinionated, spoiler-safe)
- Inline show mentions appear in horizontal strip below chat
- Show mentioned shows as selectable → opens Detail or Search fallback
- Welcome view: 6 random starter prompts with refresh
- Conversation summarization after ~10 messages (preserve voice)
- **Ask About Show** from Detail seeds context

**AI Contract (PRD-072):**
- Output structured JSON:
  ```json
  {
    "commentary": "User-facing response text",
    "showList": "Title::externalId::mediaType;;Title2::externalId::mediaType"
  }
  ```
- Parser extracts shows for UI strip
- Retry once on parse failure, then fallback to text + Search

**Data Flow:**
1. Send conversation history + user library context + current show (if applicable)
2. AI returns structured response
3. Parse showList → resolve to Show objects
4. Render chat + mentioned shows strip
5. Chat state is session-only (not persisted)

### 5.4 Alchemy (Find → Alchemy)

**Route:** `/find` (mode: alchemy)

**Requirements (PRD-080, PRD-081, PRD-082, PRD-083, PRD-084):**
- Multi-step flow:
  1. Select 2+ starting shows (library + search catalog)
  2. Tap **Conceptualize Shows** → get shared concepts
  3. Select 1-8 concept catalysts
  4. Tap **ALCHEMIZE!** → get 6 recs
  5. Option to chain: results become new inputs
- Clear downstream results when inputs change
- Backtracking allowed

**AI Contracts:**
- Concepts: bullet list only, 1-3 words, evocative, no plot
- Recommendations: 6 shows with reasons citing selected concepts

### 5.5 Explore Similar (Show Detail)

**Flow:**
1. User taps **Get Concepts** → get 5 concepts for single show
2. User selects 1+ concepts
3. User taps **Explore Shows** → get 5 recommendations
4. Recommendations cite selected concepts

**Requirements (PRD-075, PRD-076, PRD-077, PRD-078, PRD-079, PRD-084):**
- Concepts are taste ingredients, not genres
- Return bullet-only, 1-3 word, non-generic concepts
- Order by strongest "aha" first, varied axes
- Return exactly 5 Explore Similar recommendations

### 5.6 Show Detail Page

**Route:** `/show/[id]`

**Requirements (PRD-051, PRD-052, PRD-053, PRD-054, PRD-055, PRD-056, PRD-057, PRD-058, PRD-059, PRD-060, PRD-061, PRD-062, PRD-063, PRD-064):**

**Section Order:**
1. Header media carousel (backdrops/posters/logos/trailers)
2. Core facts + community score
3. My Tags
4. Overview + Scoop toggle
5. "Ask about this show" CTA
6. Genres + languages
7. Traditional recommendations strand
8. Explore Similar (Get Concepts → select → Explore Shows)
9. Streaming availability
10. Cast, Crew → Person Detail
11. Seasons (TV only)
12. Budget/Revenue (movies)

**Auto-save Rules:**
- Rating unsaved show → `my_status = Done`
- Adding tag to unsaved show → `my_status = Later`, `my_interest = Interested`
- Reselecting current status → removal confirmation → clear My Data

**AI Scoop:**
- "Give me the scoop!" toggle
- Shows "Generating..." during stream
- Persists only if show is in collection
- Freshness: 4 hours

### 5.7 Person Detail

**Route:** `/person/[id]`

**Requirements (PRD-092, PRD-093, PRD-094, PRD-095):**
- Image gallery, name, bio
- Analytics: average ratings, top genres, projects-by-year
- Filmography grouped by year
- Tap credit → Show Detail

### 5.8 Settings

**Route:** `/settings`

**Requirements (PRD-096, PRD-097, PRD-098, PRD-099):**
- **App settings:** font size, Search on launch
- **User:** username
- **AI:** API key (server-only), model selection
- **Integrations:** catalog API key
- **Export My Data:** produces `.zip` with JSON backup, ISO-8601 dates

---

## 6. AI Personality Implementation

### 6.1 Shared Persona

- Fun, chatty TV/movie nerd friend
- Sharp taste, honest, spoiler-safe by default
- Specific, vibe-first, concise by default

**Tone:** 70% friend / 30% critic, 60% hype / 40% measured

### 6.2 Surface-Specific Prompts

#### Scoop
- ~150-350 words
- Sections: personal take, stack-up vs reviews, Scoop paragraph, fit/warnings, verdict
- Lyrical voice

#### Ask
- 1-3 paragraphs, then bulleted list
- Brisk, dialogue-like

#### Concepts
- Bullet list only
- 1-3 words, evocative
- No plot, no generic

#### Recommendations
- 1-3 sentences per rec
- Cite which concepts match
- Recent bias but allow classics

### 6.3 Guardrails

- Stay in TV/movies domain
- Spoiler-safe unless requested
- Opinionated honesty
- No generic output

---

## 7. Data Behaviors

### 7.1 Saving Triggers (PRD-023)

- Setting any status
- Choosing interest chip
- Rating
- Adding at least one tag

### 7.2 Default Values (PRD-024)

- Default: `my_status = Later`, `my_interest = Interested`
- Exception: rating → `my_status = Done`

### 7.3 Removal (PRD-025)

- Clear status triggers removal
- Removes all My Data (status, interest, tags, rating, scoop)
- Show confirmation (optional suppression after repeated removals)

### 7.4 Merge Policy (PRD-037)

- Non-my fields: `selectFirstNonEmpty(new, old)`
- My fields: resolve by timestamp (newer wins)
- `creation_date` set only on first creation

### 7.5 Timestamps (PRD-027, PRD-028)

Track for: `myStatusUpdateDate`, `myInterestUpdateDate`, `myTagsUpdateDate`, `myScoreUpdateDate`, `aiScoopUpdateDate`

Uses: sorting, sync resolution, AI cache freshness

---

## 8. Testing Strategy

### 8.1 Namespace Isolation

- Each test run uses unique `namespace_id`
- Destructive operations scoped to namespace
- No global database teardown

### 8.2 Test Fixtures

- Create test shows within namespace
- Test CRUD, filter, AI surfaces
- Reset via `npm run test:reset`

### 8.3 Quality Validation

- AI outputs validated with rubric:
  - Voice ≥1
  - Taste alignment ≥1
  - Real-show integrity =2 (non-negotiable)
  - Total ≥7/10

---

## 9. Implementation Phases

### Phase 1: Foundation
- [ ] Next.js project setup with App Router
- [ ] Supabase client and schema migrations
- [ ] Environment variables and `.env.example`
- [ ] Basic App Shell with navigation
- [ ] Namespace/user context middleware

### Phase 2: Collection Core
- [ ] Collection Home with status grouping
- [ ] Filter sidebar (tags, genre, decade, score, media type)
- [ ] Show Tile component with badges
- [ ] External catalog integration (TMDB)

### Phase 3: Search
- [ ] Search interface
- [ ] Catalog search with poster grid
- [ ] In-collection markers
- [ ] Auto-open on launch setting

### Phase 4: Show Detail
- [ ] Detail page with all sections
- [ ] My Relationship controls (status, rating, tags)
- [ ] Auto-save rules
- [ ] Traditional recommendations strand
- [ ] Cast/Crew linking to Person Detail
- [ ] Streaming availability

### Phase 5: AI Surfaces
- [ ] AI provider abstraction layer
- [ ] Scoop generation with streaming
- [ ] Ask chat with structured output
- [ ] Conversation summarization
- [ ] Concepts extraction
- [ ] Explore Similar flow
- [ ] Alchemy full flow

### Phase 6: Person Detail
- [ ] Person page with gallery, bio
- [ ] Analytics charts
- [ ] Filmography by year
- [ ] Credit → Show Detail linking

### Phase 7: Settings & Export
- [ ] Settings page
- [ ] Font size and preferences
- [ ] Export My Data as zip

### Phase 8: Polish
- [ ] Empty states
- [ ] Loading states
- [ ] Error handling
- [ ] Mobile responsiveness
- [ ] Data continuity across upgrades

---

## 10. Key Technical Decisions

### 10.1 State Management
- React Server Components for initial data
- Client components for interactive elements
- Server-side Supabase queries for data

### 10.2 Caching
- React Query or SWR for client-side caching
- Stale-while-revalidate for show data
- AI responses cached by show + timestamp

### 10.3 AI Integration
- Abstract provider behind interface
- Support OpenAI-compatible APIs
- Streaming for Scoop generation
- Structured output parsing with retry

### 10.4 Error Handling
- Supabase error boundaries
- Catalog API fallback
- Graceful degradation for AI failures

---

## 11. Open Questions (from PRD)

- Should **Next** become first-class UI status?
- Should users create **named custom lists** beyond tags?
- Should generating **Scoop on unsaved show** implicitly save it?
- Should clearing **My Rating** store Unrated vs nil?
- Add **Import/Restore** from export zip?
- Support saving/sharing **Alchemy sessions**?
- Add explicit **myStatus filters** in sidebar?

**Recommendation:** Exclude all open questions from initial implementation; address as post-MVP features.

---

## 12. Out of Scope

- Detailed caching/offline strategy
- Low-level data schema and migration details
- Vendor-specific API specs beyond what's needed
- UI animation prescriptions
- Social/community features

---

*Plan generated from PRD v1 and supporting documentation. 99 requirements across 10 functional areas.*
