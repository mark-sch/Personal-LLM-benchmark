# Showbiz Application Implementation Plan

This document outlines the architecture, data models, integration points, and user interfaces required to build the Showbiz application in accordance with the PRD and Infrastructure Rider.

## Goal Description

Build a personal TV and movie companion application that allows users to collect, organize, rate, and discover entertainment. The app uses user-curated libraries to power rich, taste-aware AI discovery (Ask, Alchemy, The Scoop, and Concept generation). 
The build will be benchmark-friendly, meaning it supports namespaces, user isolation without full auth, and disposable local caches. 

## User Review Required

> [!IMPORTANT]
> - **External Catalog API**: We will need a TMDB (The Movie Database) API key for global catalog searches, provider data, and images. Is TMDB the preferred provider?
> - **AI Provider**: We will use OpenAI (gpt-4o or gpt-4o-mini) by default for the AI features unless Anthropic is preferred. We will need an API key for the environment.
> - **State Management**: For a modern, rich Next.js app, we plan to use Zustand for global client state (useful for the transient chat/alchemy state) and React Query for server state caching/mutations alongside Supabase UI. 

## Proposed Architecture & Stack

- **Framework**: Next.js 14+ (App Router)
- **Styling**: Tailwind CSS + Framer Motion (for rich micro-animations, transitions, and a premium visual feel).
- **Components**: Radix UI primitives or `shadcn/ui` for accessible, beautifully styled base components.
- **Database**: Supabase (PostgreSQL) + Supabase JS Client.
- **AI**: Vercel AI SDK or direct OpenAI API for streaming responses and structured outputs.

---

## Proposed Changes

### 1. Database Schema & Setup (Supabase)

We will create migrations to establish the following tables. To satisfy the Infrastructure Rider, all tables will be partitioned by `namespace_id` and `user_id`.

#### Table: `shows` (Global Cache)
Caches public catalog data so we don't hammer the external API for known entities.
- `id` (text, primary key) - typically a prefix + external id (e.g., `tmdb-movie-123`)
- `title` (text), `show_type` (text)
- `external_ids` (jsonb)
- Catalog meta: `overview`, `genres`, `tagline`, `image_urls` (jsonb), `dates` (jsonb), `stats` (jsonb)
- TV/Movie specific: `runtime`, `seasons`, `episodes`
- `provider_data` (jsonb)
- *Note:* We won't include user-specific data here since `shows` can be shared across users.

#### Table: `user_shows` (My Data)
Links a user to a show and stores all user-overlaid data.
- `namespace_id` (text), `user_id` (text), `show_id` (text, references `shows.id`)
- `my_status` (text), `my_interest` (text), `my_rating` (numeric)
- `my_tags` (text[])
- `ai_scoop` (text)
- Timestamps for each field (e.g., `my_status_update_date`, `my_tags_update_date`, `ai_scoop_update_date`) for conflict resolution.
- *Primary Key*: `(namespace_id, user_id, show_id)`

#### Table: `user_settings`
- `namespace_id`, `user_id`
- `cloud_settings` (jsonb), `ui_state` (jsonb)

---

### 2. External API Integrations

#### TMDB Catalog Mapping
- Build a service `lib/catalog.ts` that implements methods: `searchShows(query)`, `getShowDetails(id)`, `getPersonDetails(id)`.
- Use the TMDB mapping rules defined in `storage-schema.md` to map TMDB payloads into our `Show` typescript interfaces.

#### AI Services
- Build `lib/ai.ts` with dedicated endpoints/functions for each AI surface adhering strictly to the `ai_prompting_context.md`:
  1. **Ask (Chat)**: conversational discovery, summarizing older turns.
  2. **Ask with Mentions**: structured outputs requesting `Title::externalId::mediaType;;...`.
  3. **The Scoop**: streamed, opinionated mini blog-post.
  4. **Concept Generation**: single and multi-show concept extraction (1-3 words per concept, bulleted list).
  5. **Explore Similar / Alchemy Recs**: mapped AI recommendations grounded in concepts, returning real catalog item lookups.

---

### 3. Application UI & Routing (`app/`)

We will build a responsive, highly animated UI with dark mode as the default for a cinematic feel.

#### `layout.tsx`
- **Sidebar**: Navigation links (Home, Search, Ask, Alchemy), and dynamic tag/data filters based on the user's collection.
- **Top Bar / Dev Tools**: A dropdown to easily switch `namespace_id` and `user_id` for benchmark/dev testing without a real login flow.

#### `page.tsx` (Collection Home)
- Groups library by: Active, Excited, Interested, and Other Statuses.
- Media toggle (Movies/TV/All).
- Animated tile grid. Hovering a tile reveals badges/quick actions.

#### `search/page.tsx`
- Live search input querying the external catalog.
- Grid results marking items already in the user's collection.

#### `show/[id]/page.tsx` (Show Detail)
- Cinematic header with backdrops/trailers.
- Sticky/floating action bar for `My Status`, `Interest`, `My Tags`, and `My Rating`.
- Streaming container for **The Scoop**.
- "Explore Similar" block (Get Concepts -> Select -> Explore Shows).

#### `ask/page.tsx`
- Chat interface with starter prompts.
- "Mentioned Shows" horizontal carousel that dynamically populates as the AI responds.

#### `alchemy/page.tsx`
- Multi-step wizard UI:
  1. Select 2+ shows (search or library).
  2. *Conceptualize* -> displays selectable concept chips.
  3. *Alchemize* -> displays 6 recommendations.
  4. Chain button to use results as new inputs.

#### `settings/page.tsx`
- Form for API keys (optional user override).
- Export Data button (generates a downloaded ZIP of JSON data).

---

## Verification Plan

### Automated/Dev Tests
1. **Environment Setup**:
   - Create `.env.example`. Check that the app runs on `npm run dev` with only environment variables.
2. **Namespace Isolation**:
   - Create user A in namespace 1. Add a show.
   - Switch to namespace 2. Verify the show does not exist.
3. **Data Merge Rules**:
   - Write unit tests in `lib/merge.test.ts` to ensure that `selectFirstNonEmpty` is respected and `my*` fields resolve by timestamps correctly when catalog data refreshes.

### Manual Verification
1. **Core Loop**:
   - Search for "Breaking Bad".
   - Set status to "Active". Ensure it appears on Collection Home.
   - Add a Tag "Crime". Ensure "Crime" appears in the sidebar filters.
2. **AI Verification**:
   - Go to a popular show, click "Give me the scoop!". Ensure it streams in and persists.
   - Go to Ask, converse, and ask for 3 comedy movies. Ensure the AI responds and the Mentioned Shows strip populates correctly with clickable titles.
   - Go to Alchemy, select 2 shows, generate concepts, select 2 concepts, and get recommendations. Verification passes if the recommendations are valid external shows with tailored descriptions.
3. **Destructive Testing**:
   - Change a show's status back-and-forth and verify UI updates immediately.
   - Clear a status and confirm all explicit `user_shows` data is wiped.
