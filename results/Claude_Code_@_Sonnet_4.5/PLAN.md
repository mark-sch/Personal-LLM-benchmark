# Showbiz App — Implementation Plan

## Context

Building **Showbiz**, a personal TV + movie companion app, from scratch in the `sonnet_4_5_planning` folder. No source code exists yet — only PRD documentation and architecture guidelines. A reference implementation exists at `../shows_opus45/` which can be consulted for patterns. The goal is to build a fully functional app per the spec.

---

## Tech Stack

- **Next.js** (latest stable, App Router) — UI + API routes
- **Supabase** — hosted PostgreSQL persistence
- **TypeScript** — strict mode
- **Tailwind CSS** — styling (no inline styles, no magic numbers — theme tokens only)
- **Vitest** — unit testing
- **TMDB API** — content catalog
- **Anthropic API** — AI features (default provider; user-switchable to OpenAI)

---

## Architecture

Follows the fractal pattern from `CLAUDE.md`:
- Pages → Features → Sub-Features, each self-contained
- No `index.tsx` — main file matches directory name
- Humble components: TSX = markup + binding only; logic in `useXxx` hooks
- Feature-specific hooks/utils co-located inside feature directory

---

## Phase Plan

### Phase 1 — Foundation
1. `npx create-next-app@latest` — TypeScript, App Router, Tailwind
2. `src/config/env.ts` — typed env var accessors
3. `src/app/globals.css` — theme tokens (CSS variables)
4. `tailwind.config.ts` — reference `shows_opus45` for token names
5. Supabase clients: `src/lib/supabase/client.ts` (browser), `src/lib/supabase/server.ts`
6. `supabase/migrations/001_initial_schema.sql` — schema (see below)
7. `src/lib/supabase/types.ts` — TypeScript types
8. `src/lib/supabase/tables.ts` — prefixed table name resolver
9. `src/hooks/useNamespace.ts` — namespaceId + userId from env
10. App layout + navigation shell
11. Shared components: `Button`, `Spinner`, `ShowTile`, `ShowGrid`, `ShowRow`, `StatusChips`, `RatingBar`, `TagPicker`, `Modal`

### Phase 2 — Data Layer
1. `src/lib/supabase/shows.ts` — CRUD: getCollection, upsertShow, deleteShow, getShow
2. `src/lib/supabase/settings.ts` — cloud settings CRUD
3. `src/lib/tmdb/client.ts` — search, getMovie, getTVShow, getPerson, getWatchProviders
4. `src/lib/tmdb/mappers.ts` — TMDB payloads → Show type (slim for storage)
5. `src/config/constants.ts` — status config, interest config, AI limits

### Phase 3 — Collection Home (`/home`)
1. `src/features/Home/Home.tsx` + `useCollectionData.ts`
2. `StatusSection` sub-feature — groups: Active, Later(Excited/Interested), Wait, Done, Quit
3. `MediaTypeToggle` sub-feature
4. `FilterSidebar` sub-feature — genre, tag, decade, community score filters

### Phase 4 — Show Detail (`/show/[type]/[id]`)
1. `ShowDetail.tsx` + `useShowDetail.ts` — all business rules live here
2. Sub-features: `HeaderMedia`, `CoreFacts`, `OverviewSection`
3. Sub-features: `MyDataControls` (status chips, interest, rating slider, tag picker)
4. Sub-feature: `ScoopSection` + `useScoop.ts` (4h expiry, generate/show toggle)
5. Sub-features: `AskAboutCTA`, `RecommendationsSection`, `StreamingSection`, `CastCrew`, `SeasonsSection`, `BudgetRevenue`

### Phase 5 — Search (`/find` — Search mode)
1. `Find.tsx` — mode switcher (Search | Ask | Alchemy)
2. `SearchMode` sub-feature + `useSearch.ts`

### Phase 6 — AI Infrastructure + Scoop API
1. `src/lib/ai/client.ts` — `createCompletion`, `createStreamingCompletion` (Anthropic + OpenAI)
2. `src/lib/ai/prompts.ts` — all prompt builders
3. `POST /api/ai/scoop` — streaming response
4. Wire `ScoopSection` to scoop API

### Phase 7 — Ask Mode
1. `POST /api/ai/chat` — structured output: `{commentary, shows}`
2. `AskMode` sub-feature + `useChat.ts`
3. Show context seeding via URL params from Show Detail

### Phase 8 — Alchemy Mode
1. `POST /api/ai/concepts`
2. `POST /api/ai/recommendations`
3. `AlchemyMode` sub-feature + `useAlchemy.ts`
4. `ShowPicker` component (from collection or search)

### Phase 9 — Explore Similar (in Show Detail)
1. `ExploreSimilar` sub-feature + `useExploreSimilar.ts` (reuses concepts + recs APIs)

### Phase 10 — Person Detail (`/person/[id]`)
1. `PersonDetail.tsx` — TMDB-only (no Supabase writes)
2. `AnalyticsSection` sub-feature (filmography stats charts)

### Phase 11 — Settings (`/settings`)
1. `Settings.tsx` — username, font size, auto-search, API keys, AI model selector
2. `src/utils/export.ts` — ZIP export (JSON backup)
3. Export My Data flow

### Phase 12 — Tests + Polish
1. Unit tests for `shows.ts`, `mappers.ts`, `formatters.ts`, `export.ts`
2. Hook logic tests: `useShowDetail` business rules, `useCollectionData`, `useAlchemy`
3. `scripts/reset-test-data.js` — delete all `is_test=true` rows for namespace
4. Lint clean pass

---

## Database Schema (Supabase)

Tables use a configurable prefix from `NEXT_PUBLIC_SHOWBIZ_TABLE_PREFIX` (e.g., `sonnet45_`).

### `{prefix}shows` — composite PK: `(id, namespace_id, user_id)`

Slim schema — transient TMDB data (cast, overview, budget) fetched live, not stored.

| Column | Type | Notes |
|--------|------|-------|
| id | TEXT | TMDB ID |
| namespace_id | TEXT | build isolation |
| user_id | TEXT | user isolation |
| title | TEXT | display title |
| show_type | TEXT | movie/tv/person/unknown |
| poster_url | TEXT | for grid display |
| genres | TEXT[] | for filtering |
| release_date | TEXT | movies |
| first_air_date | TEXT | tv |
| vote_average | FLOAT | for filtering |
| my_status | TEXT | active/next/later/done/quit/wait |
| my_status_update_date | TIMESTAMPTZ | conflict resolution |
| my_interest | TEXT | excited/interested |
| my_interest_update_date | TIMESTAMPTZ | |
| my_score | FLOAT | user rating |
| my_score_update_date | TIMESTAMPTZ | |
| my_tags | TEXT[] | user labels |
| my_tags_update_date | TIMESTAMPTZ | |
| ai_scoop | TEXT | cached 4 hours |
| ai_scoop_update_date | TIMESTAMPTZ | |
| is_test | BOOLEAN | default false; for test reset |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | auto-trigger |

### `{prefix}cloud_settings` — composite PK: `(id, namespace_id, user_id)`

| Column | Type | Notes |
|--------|------|-------|
| id | TEXT | default 'globalSettings' |
| namespace_id | TEXT | |
| user_id | TEXT | |
| user_name | TEXT | |
| version | FLOAT | epoch seconds for conflict resolution |
| catalog_api_key | TEXT | user-supplied TMDB override |
| ai_api_key | TEXT | user-supplied AI key |
| ai_provider | TEXT | 'anthropic' \| 'openai' |
| ai_model | TEXT | model key/name |

### `{prefix}app_metadata` — composite PK: `(id, namespace_id)`

| Column | Type |
|--------|------|
| id | TEXT |
| namespace_id | TEXT |
| data_model_version | INTEGER |

RLS enabled on all tables with permissive policy (`USING (true)`) for benchmark mode.

---

## Key Business Rules (all in `useShowDetail.ts`)

| Trigger | Rule |
|---------|------|
| Set myStatus | Show saved to collection |
| Clear myStatus (reselect active chip) | Remove show + all My Data cleared (confirmation dialog) |
| Rate unsaved show | Auto-save as `done` |
| Tag unsaved show | Auto-save as `later` + `interested` |
| AI Scoop freshness | Check `ai_scoop_update_date` — if >4h, show "Regenerate" button |
| Every My* field update | Set corresponding `my_*_update_date` to `new Date().toISOString()` |

---

## Environment Variables (`.env.example`)

```bash
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_ACCESS_TOKEN=
NEXT_PUBLIC_SHOWBIZ_TABLE_PREFIX=sonnet45_
NEXT_PUBLIC_TMDB_API_KEY=
ANTHROPIC_API_KEY=
OPENAI_API_KEY=                         # optional fallback
NEXT_PUBLIC_NAMESPACE_ID=ns_dev_sonnet45
NEXT_PUBLIC_DEFAULT_USER_ID=default-user
NEXT_PUBLIC_DEV_USER_SELECTOR=false
```

---

## API Routes

| Route | Method | Purpose |
|-------|--------|---------|
| `/api/ai/scoop` | POST | Streaming scoop generation |
| `/api/ai/chat` | POST | Ask: returns `{commentary, shows}` |
| `/api/ai/concepts` | POST | Concept extraction for Alchemy/Explore |
| `/api/ai/recommendations` | POST | Concept-based recommendations |

### AI Structured Output Contract (Ask)
```
{
  "commentary": "user-facing response text",
  "showList": "Title::tmdbId::mediaType;;Title2::tmdbId::mediaType"
}
```

---

## Complete File Structure

```
sonnet_4_5_planning/
├── .env.example
├── .env.local                        (gitignored)
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
├── package.json
├── supabase/migrations/001_initial_schema.sql
├── scripts/{run-migrations.js,reset-test-data.js}
└── src/
    ├── app/
    │   ├── layout.tsx
    │   ├── page.tsx                   → redirect /home
    │   ├── globals.css
    │   ├── home/page.tsx
    │   ├── find/page.tsx
    │   ├── settings/page.tsx
    │   ├── show/[type]/[id]/page.tsx
    │   ├── person/[id]/page.tsx
    │   └── api/ai/{scoop,chat,concepts,recommendations}/route.ts
    ├── config/{env.ts,constants.ts}
    ├── hooks/{useNamespace.ts,useLocalStorage.ts}
    ├── lib/
    │   ├── supabase/{client.ts,server.ts,types.ts,tables.ts,shows.ts,settings.ts}
    │   ├── tmdb/{client.ts,mappers.ts}
    │   └── ai/{client.ts,prompts.ts}
    ├── components/
    │   └── {Layout,Button,Input,Modal,ConfirmationDialog,Spinner,
    │          RatingBar,StatusChips,TagPicker,ShowTile,ShowGrid,ShowRow}/
    ├── utils/{cn.ts,formatters.ts,images.ts,export.ts}
    └── features/
        ├── Home/{Home.tsx,hooks/useCollectionData.ts,
        │     features/{StatusSection,MediaTypeToggle,FilterSidebar}/}
        ├── ShowDetail/{ShowDetail.tsx,hooks/useShowDetail.ts,
        │     features/{HeaderMedia,CoreFacts,MyDataControls,OverviewSection,
        │               ScoopSection,AskAboutCTA,ExploreSimilar,RecommendationsSection,
        │               CastCrew,SeasonsSection,StreamingSection,BudgetRevenue}/}
        ├── Find/{Find.tsx,features/{SearchMode,AskMode,AlchemyMode}/}
        ├── PersonDetail/{PersonDetail.tsx,features/AnalyticsSection/}
        └── Settings/Settings.tsx
```

---

## Reference Files (consult for patterns)

- `../shows_opus45/src/lib/supabase/types.ts` — Show + CloudSettings types
- `../shows_opus45/src/features/ShowDetail/hooks/useShowDetail.ts` — business rules
- `../shows_opus45/supabase/migrations/` — schema reference (use slim version)
- `../shows_opus45/src/lib/ai/prompts.ts` — AI prompt builders
- `../shows_opus45/src/app/globals.css` — theme tokens

---

## Verification Steps

1. `npm run dev` — app starts, navigable shell loads
2. Fill `.env.local` from `.env.example` — no code changes needed
3. Run migrations → Home shows empty collection → Search a show → Add to collection → Verify persisted in Supabase
4. Open Show Detail → set status → rate → add tags → verify all My Data saved with timestamps
5. Generate AI Scoop → verify 4h cache behavior (regenerate button appears after expiry)
6. Use Ask mode → get recommendations → click through to detail
7. Use Alchemy → 2+ shows → get concepts → select → get 6 recs → chain another round
8. Use Explore Similar → get 5 concepts-based recs on a show
9. Click cast member → Person Detail → click credit → Show Detail
10. `npm test` — all unit tests pass
11. `npm run test:reset` — all `is_test=true` rows deleted for namespace
12. Settings → Export My Data → verify .zip downloads with JSON backup
