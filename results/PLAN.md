# Showbiz Implementation Plan

## Context

Build "Showbiz" — a personal TV/movie companion app — from scratch in this empty project directory. The full PRD lives in `docs/shows_prd/` (8 documents). The project currently has only documentation (CLAUDE.md, AGENTS.md, README) and no source code. The tech stack is mandated: **Next.js (App Router) + Supabase + TypeScript + Tailwind CSS**. External APIs: **TMDB** for catalog data, **Claude/OpenAI** for AI features.

**Key architectural decision:** Store the **full schema** from `storage-schema.ts` in Supabase (not a "slim" schema). The PRD specifies merge rules for non-my fields using `selectFirstNonEmpty(newValue, oldValue)` which requires persisted catalog data. This also simplifies data export.

---

## Phase 1: Project Setup & Infrastructure

### 1.1 Next.js Project Init
Create: `package.json`, `tsconfig.json`, `next.config.ts`, `postcss.config.js`, `tailwind.config.ts`, `.env.example`, `src/app/layout.tsx`, `src/app/globals.css`, `src/app/page.tsx`

- Next.js 16.x, React 19, Tailwind 4.x, App Router, `src/` directory
- Deps: `@supabase/supabase-js`, `@supabase/ssr`, `clsx`, `tailwind-merge`, `lucide-react`
- Dev deps: `vitest`, `@testing-library/react`, `happy-dom`
- `next.config.ts`: image remote patterns for `image.tmdb.org`
- `.env.example`: SUPABASE_URL, SUPABASE_ANON_KEY, TMDB_API_KEY, AI_API_KEY, NAMESPACE_ID, DEFAULT_USER_ID

### 1.2 Supabase Schema
Create: `supabase/migrations/001_initial_schema.sql`, `scripts/run-migrations.js`, `scripts/reset-test-data.js`

**`showbiz_shows` table** — full schema per `storage-schema.ts`:
- Composite PK: `(id, namespace_id, user_id)`
- All catalog fields (overview, genres, images, ratings, dates, movie/TV specifics)
- All my-fields with update timestamps (myStatus, myInterest, myScore, myTags, aiScoop)
- Management fields (detailsUpdateDate, creationDate, isTest)
- providerData as JSONB

**`showbiz_cloud_settings` table** — PK: `(id, namespace_id, user_id)`

**`showbiz_app_metadata` table** — PK: `(id, namespace_id)`

Indexes on `(namespace_id, user_id)`, `(namespace_id, user_id, my_status)`. RLS enabled with permissive policies for benchmark mode.

`scripts/reset-test-data.js`: Deletes rows where `is_test = true` within configured namespace.

### 1.3 Environment Config
Create: `src/config/env.ts`, `src/config/constants.ts`

- Validated env vars with `assertEnv()` that throws on missing required vars
- Server-only `AI_API_KEY` guarded with `typeof window === 'undefined'`
- Constants: AI_SCOOP_FRESHNESS_MS (4hrs), CONCEPT_COUNT (8), EXPLORE_SIMILAR_REC_COUNT (5), ALCHEMY_REC_COUNT (6), status ordering, font size scale

### 1.4 Theme System
Create/update: `src/theme/tokens.ts`, `src/app/globals.css`, `tailwind.config.ts`

- Dark cinematic palette (dark backgrounds, indigo/violet accents, amber for ratings)
- CSS custom properties in globals.css, extended in Tailwind config
- Status-specific colors

### 1.5 Shared Components
Create: `src/components/` — ShowTile, ShowGrid, ShowRow, StatusChips, RatingBar, TagPicker, Button, Input, Spinner, Modal, ConfirmationDialog, Markdown, Layout (AppLayout + Sidebar + MobileHeader + MobileDrawer + SidebarContext), Navigation

- `src/utils/cn.ts`: clsx + tailwind-merge utility
- All components: humble (TSX = markup + binding), theme tokens only, typed props

---

## Phase 2: Data Layer

### 2.1 Supabase Client
Create: `src/lib/supabase/client.ts` (browser), `src/lib/supabase/server.ts` (API routes), `src/lib/supabase/types.ts` (full TypeScript interfaces)

### 2.2 Namespace & Identity
Create: `src/hooks/useNamespace.ts`

- Returns `{ namespaceId, userId }` from env vars
- Server-side `getIdentity(request)` helper for API routes
- All queries scoped to `(namespace_id, user_id)`

### 2.3 Show CRUD
Create: `src/lib/supabase/shows.ts`

- `getCollectionShows`, `getShow`, `saveShow` (upsert with merge), `updateShowStatus`, `updateShowRating`, `updateShowTags`, `updateShowScoop`, `getAllTags`, `deleteTestData`, `exportUserData`
- All scoped to `(namespace_id, user_id)`

### 2.4 Merge Logic (Critical)
Create: `src/utils/merge.ts`, `src/utils/merge.test.ts`

Two merge strategies per PRD:
1. **Non-my fields**: `selectFirstNonEmpty(new, old)` — never overwrite non-empty with empty
2. **My-fields**: Timestamp-based resolution — newer wins

`mergeShows(incoming, existing)`: Applies both strategies, sets detailsUpdateDate to now, preserves creationDate.

Unit tests covering: empty existing, newer my-data, empty-string protection, timestamp conflicts, creationDate immutability.

### 2.5 TMDB Integration
Create: `src/lib/tmdb/client.ts`, `src/lib/tmdb/types.ts`, `src/lib/tmdb/mappers.ts`, `src/lib/tmdb/genre-map.ts`

- Client: searchMulti, getMovieDetails, getTVShowDetails, getPersonDetails, getSeasonDetails, buildImageUrl
- Mappers: `mapTMDBMovieToShow`, `mapTMDBTVShowToShow` — populate ALL schema fields, invoke mergeShows when existing record provided
- `resolveShowFromAI(title, externalId?, mediaType?)`: Lookup + validate for AI mention resolution

### 2.6 Settings
Create: `src/lib/supabase/settings.ts`, `src/hooks/useLocalSettings.ts`, `src/hooks/useUIState.ts`

- CloudSettings CRUD (scoped to namespace+user)
- LocalSettings via localStorage (autoSearch, fontSize)
- UIState via localStorage (hideStatusRemovalConfirmation, statusRemovalCountKey, lastSelectedFilter)

---

## Phase 3: Core Pages

### 3.1 Routing
Create/update: `src/app/page.tsx` (redirect to /home), `src/app/home/page.tsx`, `src/app/find/page.tsx`, `src/app/show/[type]/[id]/page.tsx`, `src/app/person/[id]/page.tsx`, `src/app/settings/page.tsx`

Each page.tsx is a thin shell delegating to feature components.

### 3.2 Collection Home
Create: `src/pages/Home/Home.tsx`, `hooks/useCollectionData.ts`, `features/StatusSection/`, `features/MediaTypeToggle/`, `features/FilterBar/`, `features/EmptyState/`

- Groups shows by: Active > Excited > Interested > Other
- Filter bar (tag, genre, decade, score, status)
- Media type toggle (All/Movies/TV)
- Empty states for no collection and no filter results

### 3.3 Show Detail (largest feature)
Create: `src/pages/ShowDetail/ShowDetail.tsx`, `hooks/useShowDetail.ts`, and 13 sub-features:

Narrative hierarchy (exact PRD order):
1. **HeaderMedia** — backdrop/poster/logo carousel, video trailer
2. **CoreFacts** — year, runtime/seasons, community score
3. **MyDataControls** — status chips (sticky toolbar), rating, tags
4. **OverviewSection** — overview + tagline
5. **ScoopSection** — toggle + streaming AI scoop
6. **AskAboutCTA** — navigates to Ask with show context
7. **GenresLanguages** — genre chips + languages
8. **RecommendationsStrand** — horizontal TMDB similar/recommended
9. **ExploreSimilar** — concepts → recs flow
10. **StreamingSection** — provider logos (flatrate/rent/buy)
11. **CastCrew** — horizontal rows, tap → person detail
12. **SeasonsSection** — TV only, expandable
13. **BudgetRevenue** — movies only

### 3.4 Person Detail
Create: `src/pages/PersonDetail/PersonDetail.tsx`, `hooks/usePersonDetail.ts`, features: PersonHeader, ImageGallery, Filmography (grouped by year), Analytics (ratings/genres/timeline charts via SVG)

### 3.5 Find Page (Search + Ask + Alchemy)
Create: `src/pages/Find/Find.tsx`, `hooks/useFindMode.ts`, features: ModeSwitcher, SearchMode, AskMode (placeholder), AlchemyMode (placeholder)

- SearchMode: debounced TMDB searchMulti, poster grid, in-collection indicators
- AskMode/AlchemyMode: structure only in Phase 3, full impl in Phase 5

### 3.6 Settings
Create: `src/pages/Settings/Settings.tsx`, features: FontSizeSelector, SearchOnLaunch, UserProfile, APIKeys, DataExport

---

## Phase 4: My Data & Auto-Save

### 4.1 Status/Interest Chips
- Interested → `later + interested`, Excited → `later + excited`
- Active/Done/Wait/Quit → direct status set
- Reselect → removal confirmation (4.5)

### 4.2 Rating Bar
- 10-point scale, displays both community and user scores
- Rating unsaved show → auto-save as Done

### 4.3 Tags System
- Add/remove/create tags with autocomplete from existing library
- Adding tag to unsaved show → auto-save as Later + Interested

### 4.4 Auto-Save Logic (centralized in useMyDataControls)
1. Any status on unsaved → save with that status (default interest: interested if later)
2. Interested/Excited on unsaved → save as later + interest
3. Rating unsaved → save as done + rating
4. Tag unsaved → save as later + interested + tag
5. Re-add existing → mergeShows with timestamp resolution

### 4.5 Status Removal Confirmation
- Reselect active chip → ConfirmationDialog with "don't ask again"
- Confirm → delete row, clear all My Data
- Tracks hideStatusRemovalConfirmation and statusRemovalCountKey in UIState

---

## Phase 5: AI Features

### 5.1 AI Client
Create: `src/lib/ai/client.ts`, `src/lib/ai/types.ts`

- Abstraction supporting both Claude and OpenAI API formats
- `createCompletion` (non-streaming) and `createStreamingCompletion` (returns ReadableStream)
- Auto-detect API format from key prefix
- Server-side only

### 5.2 AI Prompts
Create: `src/lib/ai/prompts.ts`, `src/lib/ai/starter-prompts.ts`

System prompts per surface following ai_voice_personality.md:
- **Chat**: Conversational, structured `[SHOWS]Title::externalId::mediaType;;...[/SHOWS]` output
- **Scoop**: Mini blog-post (150-350 words), sections: Personal Take, Stacks Up, The Scoop, Who It's For, Verdict
- **Concepts**: 8 bullets, 1-3 words, evocative, non-generic, ordered by strength
- **Recommendations**: JSON format, reasons cite concepts, bias recent

Prompt builders: `buildChatPrompt`, `buildScoopPrompt`, `buildConceptsPrompt`, `buildRecommendationsPrompt`, `buildConversationSummary`

### 5.3 API Routes
Create: `src/app/api/ai/chat/route.ts`, `scoop/route.ts`, `concepts/route.ts`, `recommendations/route.ts`

- **Chat**: Parse `[SHOWS]`, resolve via TMDB, return `{ commentary, shows[] }`
- **Scoop**: Stream response, return `text/plain` stream
- **Concepts**: Return `{ concepts: string[] }`
- **Recommendations**: Resolve each rec via TMDB, return `{ recommendations: { show, reason }[] }`

### 5.4 Scoop (Show Detail)
- 4-hour freshness check
- Toggle states: "Give me the scoop!" → "Show the scoop" → "The Scoop"
- Streams progressively
- Persists only if show is in collection

### 5.5 Ask Chat
- Message history with user/assistant turns
- Mentioned shows horizontal strip (resolved TMDB items)
- Starter prompts on empty chat (6 options)
- "Ask about this show" context from Show Detail
- Conversation summarization after ~10 messages
- Session-only (not persisted)

### 5.6 Alchemy
- Flow: Pick 2+ shows → Conceptualize → Pick 1-8 concepts → ALCHEMIZE! → 6 recs
- Chain: "More Alchemy!" uses results as new inputs
- Backtracking clears downstream
- Session-only

### 5.7 Explore Similar (Show Detail)
- Single-show concept extraction
- Select 1+ concepts → 5 recommendations
- "Pick the ingredients you want more of" nudge

---

## Phase 6: Polish & Testing

### 6.1 Responsive Design
- Mobile-first Tailwind breakpoints (375px → 1440px)
- Sidebar → mobile drawer, adaptive grid columns, 44px touch targets

### 6.2 Loading & Error States
Create: `src/components/Skeleton/`, `src/components/ErrorBoundary/`
- Skeleton placeholders for all data-fetching features
- Error boundaries with retry buttons
- "Generating..." indicators for AI operations

### 6.3 Data Export
- JSON format with version, exportDate, full shows + settings
- ISO-8601 dates, downloaded as .zip

### 6.4 Tests
Create: `vitest.config.ts`
- Merge logic (100% branch coverage)
- TMDB mappers
- Auto-save rules (all 4 triggers)
- Mentioned shows parsing
- Scripts: `npm test`, `npm run test:reset`

---

## Verification Checklist

1. `.env.example` complete, no secrets committed
2. `npm run dev` starts without errors
3. `npm test` passes all tests
4. `npm run test:reset` clears test data within namespace only
5. Collection flow: Find → Search → Detail → Save → appears on Home
6. Rate-to-save: Detail → Rate unsaved → saved as Done
7. Tag-to-save: Detail → Tag unsaved → saved as Later + Interested
8. Ask: Find → Ask → recommendations → tap show → Detail
9. Alchemy: Find → Alchemy → pick 3 → Conceptualize → select → Alchemize → 6 results
10. Explore Similar: Detail → Get Concepts → select → Explore Shows → 5 results
11. Scoop: Detail → "Give me the scoop!" → streaming text → persists if in collection
12. Person: Detail → Cast member → Person Detail → Credit → back to Detail
13. Settings: font size, search-on-launch, username, API keys, export all work
14. Status removal: Reselect status → confirm → removed from collection
15. Namespace isolation: two different NAMESPACE_IDs never see each other's data

## Complete File Tree

```
/
├── .env.example
├── .gitignore
├── package.json
├── tsconfig.json
├── next.config.ts
├── postcss.config.js
├── tailwind.config.ts
├── vitest.config.ts
├── supabase/
│   └── migrations/
│       └── 001_initial_schema.sql
├── scripts/
│   ├── run-migrations.js
│   └── reset-test-data.js
└── src/
    ├── app/
    │   ├── layout.tsx
    │   ├── globals.css
    │   ├── page.tsx
    │   ├── home/page.tsx
    │   ├── find/page.tsx
    │   ├── show/[type]/[id]/page.tsx
    │   ├── person/[id]/page.tsx
    │   ├── settings/page.tsx
    │   └── api/ai/
    │       ├── chat/route.ts
    │       ├── scoop/route.ts
    │       ├── concepts/route.ts
    │       └── recommendations/route.ts
    ├── config/
    │   ├── env.ts
    │   └── constants.ts
    ├── theme/
    │   └── tokens.ts
    ├── components/
    │   ├── ShowTile/ShowTile.tsx
    │   ├── ShowGrid/ShowGrid.tsx
    │   ├── ShowRow/ShowRow.tsx
    │   ├── StatusChips/StatusChips.tsx
    │   ├── RatingBar/RatingBar.tsx
    │   ├── TagPicker/TagPicker.tsx
    │   ├── Button/Button.tsx
    │   ├── Input/Input.tsx
    │   ├── Spinner/Spinner.tsx
    │   ├── Skeleton/Skeleton.tsx
    │   ├── Modal/Modal.tsx
    │   ├── ConfirmationDialog/ConfirmationDialog.tsx
    │   ├── ErrorBoundary/ErrorBoundary.tsx
    │   ├── Markdown/Markdown.tsx
    │   ├── Layout/
    │   │   ├── AppLayout.tsx
    │   │   ├── Sidebar.tsx
    │   │   ├── MobileHeader.tsx
    │   │   ├── MobileDrawer.tsx
    │   │   └── SidebarContext.tsx
    │   └── Navigation/Navigation.tsx
    ├── hooks/
    │   ├── useNamespace.ts
    │   ├── useLocalSettings.ts
    │   ├── useLocalStorage.ts
    │   └── useUIState.ts
    ├── utils/
    │   ├── cn.ts
    │   ├── merge.ts
    │   └── merge.test.ts
    ├── lib/
    │   ├── supabase/
    │   │   ├── client.ts
    │   │   ├── server.ts
    │   │   ├── types.ts
    │   │   ├── shows.ts
    │   │   └── settings.ts
    │   ├── tmdb/
    │   │   ├── client.ts
    │   │   ├── types.ts
    │   │   ├── mappers.ts
    │   │   ├── mappers.test.ts
    │   │   └── genre-map.ts
    │   └── ai/
    │       ├── client.ts
    │       ├── types.ts
    │       ├── prompts.ts
    │       └── starter-prompts.ts
    └── pages/
        ├── Home/
        │   ├── Home.tsx
        │   ├── hooks/useCollectionData.ts
        │   └── features/
        │       ├── StatusSection/StatusSection.tsx
        │       ├── MediaTypeToggle/MediaTypeToggle.tsx
        │       ├── FilterBar/
        │       │   ├── FilterBar.tsx
        │       │   └── hooks/useFilterLogic.ts
        │       └── EmptyState/EmptyState.tsx
        ├── ShowDetail/
        │   ├── ShowDetail.tsx
        │   ├── hooks/useShowDetail.ts
        │   └── features/
        │       ├── HeaderMedia/HeaderMedia.tsx
        │       ├── CoreFacts/CoreFacts.tsx
        │       ├── MyDataControls/
        │       │   ├── MyDataControls.tsx
        │       │   └── hooks/
        │       │       ├── useMyDataControls.ts
        │       │       └── useMyDataControls.test.ts
        │       ├── OverviewSection/OverviewSection.tsx
        │       ├── ScoopSection/
        │       │   ├── ScoopSection.tsx
        │       │   └── hooks/useScoopLogic.ts
        │       ├── AskAboutCTA/AskAboutCTA.tsx
        │       ├── GenresLanguages/GenresLanguages.tsx
        │       ├── RecommendationsStrand/RecommendationsStrand.tsx
        │       ├── ExploreSimilar/
        │       │   ├── ExploreSimilar.tsx
        │       │   └── hooks/useExploreSimilar.ts
        │       ├── StreamingSection/StreamingSection.tsx
        │       ├── CastCrew/CastCrew.tsx
        │       ├── SeasonsSection/
        │       │   ├── SeasonsSection.tsx
        │       │   └── hooks/useSeasonDetails.ts
        │       └── BudgetRevenue/BudgetRevenue.tsx
        ├── PersonDetail/
        │   ├── PersonDetail.tsx
        │   ├── hooks/usePersonDetail.ts
        │   └── features/
        │       ├── PersonHeader/PersonHeader.tsx
        │       ├── ImageGallery/ImageGallery.tsx
        │       ├── Filmography/Filmography.tsx
        │       └── Analytics/
        │           ├── Analytics.tsx
        │           ├── hooks/usePersonAnalytics.ts
        │           └── features/
        │               ├── RatingsChart/RatingsChart.tsx
        │               ├── GenresChart/GenresChart.tsx
        │               └── TimelineChart/TimelineChart.tsx
        ├── Find/
        │   ├── Find.tsx
        │   ├── hooks/useFindMode.ts
        │   └── features/
        │       ├── ModeSwitcher/ModeSwitcher.tsx
        │       ├── SearchMode/
        │       │   ├── SearchMode.tsx
        │       │   └── hooks/useSearch.ts
        │       ├── AskMode/
        │       │   ├── AskMode.tsx
        │       │   ├── hooks/useChat.ts
        │       │   └── features/
        │       │       ├── MentionedShows/MentionedShows.tsx
        │       │       ├── StarterPrompts/StarterPrompts.tsx
        │       │       └── ChatMessages/ChatMessages.tsx
        │       └── AlchemyMode/
        │           ├── AlchemyMode.tsx
        │           ├── hooks/useAlchemy.ts
        │           └── features/
        │               ├── ShowPicker/ShowPicker.tsx
        │               ├── ConceptChips/ConceptChips.tsx
        │               └── AlchemyResults/AlchemyResults.tsx
        └── Settings/
            ├── Settings.tsx
            ├── hooks/useSettingsLogic.ts
            └── features/
                ├── FontSizeSelector/FontSizeSelector.tsx
                ├── SearchOnLaunch/SearchOnLaunch.tsx
                ├── UserProfile/UserProfile.tsx
                ├── APIKeys/APIKeys.tsx
                └── DataExport/
                    ├── DataExport.tsx
                    └── hooks/useDataExport.ts
```

## Critical Files Reference

| File | Purpose |
|------|---------|
| `docs/shows_prd/showbiz_prd.md` | All business rules, auto-save, merge rules |
| `docs/shows_prd/supporting_docs/technical_docs/storage-schema.ts` | Canonical data schema |
| `docs/shows_prd/supporting_docs/ai_prompting_context.md` | AI behavioral contracts, output formats |
| `docs/shows_prd/supporting_docs/detail_page_experience.md` | Show detail section ordering and UX states |
| `docs/shows_prd/supporting_docs/ai_voice_personality.md` | AI persona and tone spec |
| `docs/shows_prd/supporting_docs/concept_system.md` | Concept generation rules and quality bar |
| `docs/shows_prd/showbiz_infra_rider_prd.md` | Namespace isolation, identity, infra requirements |
