# Showbiz Implementation Plan

## 1. Architecture & Tech Stack

- **Framework:** Next.js (App Router, Latest Stable)
- **Language:** TypeScript
- **Styling:** Tailwind CSS + Lucide React (Icons)
- **State Management:** React Server Components (Server) + Context/Hooks (Client)
- **Persistence:** Supabase (PostgreSQL)
- **External APIs:**
    - **Catalog:** TMDB (The Movie Database) - *Assumed standard*
    - **AI:** OpenAI (or compatible LLM) - *Configurable*

### Directory Structure
```
/src
  /app                 # Next.js App Router
    /layout.tsx        # Global shell (Sidebar, etc.)
    /page.tsx          # Home (Collection)
    /search/page.tsx   # Search
    /show/[id]/page.tsx # Detail
    /ask/page.tsx      # Ask (AI)
    /alchemy/page.tsx  # Alchemy
    /settings/page.tsx # Settings
  /components
    /ui                # Atomic components (Button, Badge, etc.)
    /domain            # Domain components (ShowTile, StatusPicker)
  /lib
    /supabase          # Supabase client & types
    /catalog           # TMDB client
    /ai                # LLM client & prompts
    /utils             # Helpers
  /types               # Global types
```

---

## 2. Data Model (Supabase Schema)

Based on `storage-schema.ts`, we will create a `shows` table.
*Note: We will use `jsonb` for complex nested fields like `externalIds`, `myTags`, `providerData` to keep the schema flexible while strictly typing the application layer.*

**Table: `shows`**
- `id` (text, primary key) - *Composite or UUID, but mapped from external ID*
- `user_id` (text, not null) - *Benchmark identity*
- `namespace_id` (text, not null) - *Benchmark isolation*
- `external_id` (text) - *TMDB ID*
- `title` (text)
- `data` (jsonb) - *Stores all non-indexable metadata (images, runtime, etc.)*
- `my_status` (text)
- `my_rating` (numeric)
- `my_tags` (jsonb)
- `updated_at` (timestamptz)

**Indexes:**
- `(namespace_id, user_id)`
- `(namespace_id, user_id, my_status)`

---

## 3. Development Phases

### Phase 1: Foundation & Search
**Goal:** A user can search for a show and view its public details.
1.  **Setup:** Initialize Next.js, Tailwind, Supabase client.
2.  **Infra:** Create `setup-db.sql` migration for the `shows` table.
3.  **Config:** Implement `Env` loader with `.env.example` (API Keys, etc.).
4.  **Catalog Service:** Implement `searchShows(query)` and `getShowDetails(id)` using TMDB.
5.  **UI Shell:** Create the Sidebar/Layout.
6.  **Search Page:** Implement search input and grid results.
7.  **Detail Page (Read-only):** Render header, facts, and overview from Catalog data.

### Phase 2: Library Management
**Goal:** A user can save shows, organize them, and view their collection.
1.  **DB Access:** Implement `ShowRepository` (UPSERT logic).
    - *Key Logic:* Merge public catalog data with user data on save.
2.  **Detail Controls:**
    - Status Picker (Active, Later, Wait, etc.).
    - Interest Picker (Interested, Excited).
    - Rating Slider.
    - Tags Input.
3.  **Home Page:**
    - Fetch saved shows from Supabase.
    - Implement Filter Sidebar (Status, Tags, Type).
    - Render Collection Grid (grouped by status).
4.  **Persistence:** Ensure "My Data" persists and updates correctly.

### Phase 3: AI Foundation (Ask & Scoop)
**Goal:** "Taste-aware" AI features on the detail page and chat.
1.  **AI Service:** Implement `generateScoop(show, userData)` and `chat(messages, context)`.
2.  **The Scoop:**
    - Add "Get Scoop" button on Detail page.
    - Stream AI response.
    - Persist `aiScoop` to DB.
3.  **Ask (Chat):**
    - Implement Chat UI.
    - Inject "My Collection" context into system prompt.
    - Implement "Mentioned Shows" parsing and rendering.

### Phase 4: Advanced Discovery (Alchemy & Concepts)
**Goal:** Concept-based discovery.
1.  **Concepts:**
    - Implement `getConcepts(show)` in AI Service.
    - Add "Get Concepts" to Detail page.
2.  **Explore Similar:**
    - UX: Select concepts -> Fetch recommendations.
    - Map recommendations back to Catalog IDs.
3.  **Alchemy:**
    - Multi-show selection UI.
    - Concept extraction from multiple shows.
    - Recommendation generation loop.

### Phase 5: Polish & Benchmarks
**Goal:** Meet all "Benchmark" and "Quality" requirements.
1.  **Settings:** API Key configuration (stored in local storage or cookies for benchmark).
2.  **Export:** Generate JSON dump of user data.
3.  **Testing:** Add unit/integration tests for critical paths.
4.  **Review:** Audit against `discovery_quality_bar.md`.

---

## 4. Benchmark & Identity Strategy

Per `showbiz_infra_rider_prd.md`:
- We will use a **Cookies/Headers** approach for `user_id` and `namespace_id` in Dev/Benchmark mode.
- Middleware will inject these into Server Components/Actions.
- Default to `default-namespace` and `default-user` if not set, to ensure "run out of the box" experience.

## 5. Next Steps

1.  Initialize repository.
2.  Create Supabase project (or local instance).
3.  Begin Phase 1.
