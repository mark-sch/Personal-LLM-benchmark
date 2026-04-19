# Implementation Plan: Personal TV + Movie Companion

## Executive Summary

This plan describes the implementation of a personal TV + movie companion application that enables users to build, organize, and maintain a personal collection of shows/movies while providing AI-powered, taste-aware discovery. The application uses Next.js as the runtime and Supabase as the persistence layer, with a focus on isolating build runs via namespace/user partitioning.

**Scope**: This is a planning phase. The implementation will follow this plan in a subsequent step.

---

## 1. Project Architecture & Technology Stack

### 1.1 Core Technologies (Benchmark Baseline)
- **Frontend Framework**: Next.js (latest stable) - handles both UI and server boundary
- **Backend/Persistence**: Supabase (hosted or local)
- **Storage Schema**: TypeScript-based schema definition (per `storage-schema.ts`)
- **Environment Configuration**: `.env` variables with `.env.example` template
- **Development Identity Injection**: `X-User-Id` header mechanism for dev/test

### 1.2 Project Structure
```
/app
  /components      # Reusable UI components
  /pages           # Next.js pages (Home, Search, Ask, Alchemy, Detail, Person, Settings)
  /lib             # Core libraries, Supabase clients, utilities
  /services        # API services for catalog, AI, persistence
  /hooks           # React hooks for data access
  /styles          # Global styles and theme
/lib
  /supabase        # Supabase client configuration
  /schema          # TypeScript schema definitions
  /utils           # Utility functions
  /constants       # App-wide constants
/migrations        # Database schema migrations
/scripts           # Dev scripts (reset, seed)
/components
  /common          # Shared UI components
  /collection      # Collection-specific components
  /detail          # Show Detail components
  /discover        # Discovery mode components
  /person          # Person Detail components
  /settings        # Settings components
  /scoop           # AI Scoop components
  /alchemy         # Alchemy components
/types             # TypeScript type definitions
/tests             # Test suite
```

---

## 2. Database Schema & Migrations

### 2.1 Core Tables

#### 2.1.1 Shows Table
```sql
CREATE TABLE shows (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  namespace_id TEXT NOT NULL,
  title TEXT NOT NULL,
  show_type TEXT NOT NULL,
  overview TEXT,
  genres TEXT[],
  tagline TEXT,
  homepage TEXT,
  original_language TEXT,
  spoken_languages TEXT[],
  languages TEXT[],
  poster_url_string TEXT,
  backdrop_url_string TEXT,
  logo_url_string TEXT,
  vote_average FLOAT,
  popularity FLOAT,
  vote_count INT,
  last_air_date TEXT,
  first_air_date TEXT,
  release_date TEXT,
  runtime INT,
  budget INT,
  revenue INT,
  series_status TEXT,
  number_of_episodes INT,
  number_of_seasons INT,
  episode_run_time INT[],
  my_tags TEXT[],
  my_tags_update_date TIMESTAMP,
  my_score FLOAT,
  my_score_update_date TIMESTAMP,
  my_status TEXT,
  my_status_update_date TIMESTAMP,
  my_interest TEXT,
  my_interest_update_date TIMESTAMP,
  ai_scoop TEXT,
  ai_scoop_update_date TIMESTAMP,
  details_update_date TIMESTAMP,
  creation_date TIMESTAMP,
  is_test BOOLEAN DEFAULT FALSE,
  provider_data JSONB,
  CONSTRAINT fk_namespace FOREIGN KEY (namespace_id) REFERENCES builds(id),
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id)
);
```

#### 2.1.2 Builds Table (for namespace isolation)
```sql
CREATE TABLE builds (
  id TEXT PRIMARY KEY,
  namespace_id TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### 2.1.3 Users Table
```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  namespace_id TEXT NOT NULL,
  user_name TEXT,
  version BIGINT,
  catalog_api_key TEXT,
  ai_api_key TEXT,
  ai_model TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY (namespace_id) REFERENCES builds(id)
);
```

#### 2.1.4 LocalSettings Table
```sql
CREATE TABLE local_settings (
  key TEXT PRIMARY KEY,
  value JSONB NOT NULL,
  namespace_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  FOREIGN KEY (namespace_id) REFERENCES builds(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

#### 2.1.5 UIState Table
```sql
CREATE TABLE ui_state (
  key TEXT PRIMARY KEY,
  value JSONB NOT NULL,
  namespace_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  FOREIGN KEY (namespace_id) REFERENCES builds(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### 2.2 Indexes
```sql
-- Optimized for namespace/user partitioning
CREATE INDEX idx_shows_namespace_user ON shows(namespace_id, user_id);
CREATE INDEX idx_shows_my_status ON shows(my_status) WHERE my_status IS NOT NULL;
CREATE INDEX idx_shows_my_tags ON shows USING GIN(my_tags);
CREATE INDEX idx_shows_creation_date ON shows(creation_date DESC);
CREATE INDEX idx_shows_details_update ON shows(details_update_date DESC);
CREATE INDEX idx_builds_namespace ON builds(namespace_id);
```

### 2.3 Migration Strategy
- Use Supabase migrations for schema evolution
- Include version tracking in `app_metadata` table
- Support data migrations for schema upgrades (per PRD-034)
- Each migration includes rollback capability

---

## 3. Data Models & Types

### 3.1 Core Entity: Show
```typescript
type ShowType = "movie" | "tv" | "person" | "unknown";
type MyStatusType = "active" | "next" | "later" | "done" | "quit" | "wait";
type MyInterestType = "excited" | "interested";

interface Show {
  id: string;
  title: string;
  showType: ShowType;
  externalIds?: Record<string, string>;
  
  // Catalog metadata
  overview?: string;
  genres: string[];
  tagline?: string;
  homepage?: string;
  originalLanguage?: string;
  spokenLanguages: string[];
  languages: string[];
  
  // Images
  posterUrlString?: string;
  backdropUrlString?: string;
  logoUrlString?: string;
  
  // Ratings & popularity
  voteAverage?: number;
  popularity?: number;
  voteCount?: number;
  
  // Dates
  lastAirDate?: string;
  firstAirDate?: string;
  releaseDate?: string;
  
  // Movie-specific
  runtime?: number;
  budget?: number;
  revenue?: number;
  
  // TV-specific
  seriesStatus?: string;
  numberOfEpisodes?: number;
  numberOfSeasons?: number;
  episodeRunTime: number[];
  
  // User data
  myTags: string[];
  myTagsUpdateDate?: string;
  myScore?: number;
  myScoreUpdateDate?: string;
  myStatus?: MyStatusType;
  myStatusUpdateDate?: string;
  myInterest?: MyInterestType;
  myInterestUpdateDate?: string;
  
  // AI data
  aiScoop?: string;
  aiScoopUpdateDate?: string;
  
  // Management
  detailsUpdateDate?: string;
  creationDate?: string;
  isTest: boolean;
  
  // Providers
  providerData?: { countries: Record<string, { flatrate?: number[], rent?: number[], buy?: number[] }> };
  
  // Runtime fields (non-persisted)
  cast?: any[];
  crew?: any[];
  seasons?: any[];
  videos?: any[];
  recommendations?: any[];
}
```

### 3.2 CloudSettings Interface
```typescript
interface CloudSettings {
  id: string; // default "globalSettings"
  userName: string;
  version: number; // epoch seconds
  catalogApiKey?: string;
  aiApiKey?: string;
  aiModel: string;
}
```

### 3.3 LocalSettings Interface
```typescript
interface LocalSettings {
  autoSearch: boolean;
  fontSize: "XS" | "S" | "M" | "L" | "XL" | "XXL";
}
```

### 3.4 FilterConfiguration
```typescript
type FilterType = "all" | "genre" | "myStatus" | "communityScore" | "decade" | "myTag";

interface FilterConfiguration {
  type: FilterType;
  label: string;
  value: string;
}
```

---

## 4. Core Features Implementation

### 4.1 Collection Management

#### 4.1.1 Status System
- **Implementation**: Status chips in toolbar with direct state management
- **Status Values**: Active, Later, Wait, Done, Quit, Wait
- **Special Handling**:
  - Interested/Excited chips set `My Status = Later` + corresponding interest level
  - Re-selecting status triggers removal confirmation
  - Hidden `Next` status stored but not surfaced in UI

#### 4.1.2 Saving Triggers
```typescript
// Auto-save triggers
const autoSaveTriggers = {
  STATUS_CHANGE: (show: Show) => {
    show.myStatus = newStatus;
    show.myStatusUpdateDate = now();
    saveToCollection(show);
  },
  INTEREST_CHANGE: (show: Show, interest: MyInterestType) => {
    show.myStatus = "later";
    show.myInterest = interest;
    show.myStatusUpdateDate = now();
    show.myInterestUpdateDate = now();
    saveToCollection(show);
  },
  RATING_CHANGE: (show: Show, rating: number) => {
    show.myScore = rating;
    show.myScoreUpdateDate = now();
    // Rating implies watched -> Done status
    show.myStatus = "done";
    show.myStatusUpdateDate = now();
    saveToCollection(show);
  },
  TAG_ADD: (show: Show, tag: string) => {
    show.myTags = [...(show.myTags || []), tag];
    show.myTagsUpdateDate = now();
    // Tag implies Later + Interested
    show.myStatus = "later";
    show.myInterest = "interested";
    show.myStatusUpdateDate = now();
    show.myInterestUpdateDate = now();
    saveToCollection(show);
  }
};
```

#### 4.1.3 Removing from Collection
```typescript
const removeFromCollection = (show: Show) => {
  // Show confirmation (unless hideStatusRemovalConfirmation is set)
  if (!showHideConfirmation && ++removalCount > threshold) {
    // Skip confirmation
  } else {
    // Show confirmation modal
  }
  
  // Clear all My Data
  show.myStatus = null;
  show.myInterest = null;
  show.myTags = [];
  show.myScore = null;
  show.aiScoop = null;
  
  // Delete from storage
  await deleteFromStorage(show.id);
};
```

#### 4.1.4 Re-adding Show
```typescript
const reAddShow = async (externalShow: Show) => {
  // Check if show exists in collection
  const existing = await findByExternalId(externalShow.id);
  
  if (existing) {
    // Merge by most recent timestamp per field
    const merged = mergeByTimestamp(existing, externalShow);
    await saveToCollection(merged);
    return merged;
  }
  
  // New show
  const newShow = mapExternalToStored(externalShow);
  await saveToCollection(newShow);
  return newShow;
};
```

### 4.2 Collection Home

#### 4.2.1 Grouping Logic
```typescript
const groupShowsByStatus = (shows: Show[]) => {
  const groups = {
    active: [] as Show[],
    excited: [] as Show[],
    interested: [] as Show[],
    other: [] as Show[]
  };
  
  shows.forEach(show => {
    if (show.myStatus === "active") {
      groups.active.push(show);
    } else if (show.myStatus === "later" && show.myInterest === "excited") {
      groups.excited.push(show);
    } else if (show.myStatus === "later" && show.myInterest === "interested") {
      groups.interested.push(show);
    } else {
      groups.other.push(show);
    }
  });
  
  // Sort each group by update date
  Object.values(groups).forEach(group => {
    group.sort((a, b) => (b.myStatusUpdateDate || b.myTagsUpdateDate || b.creationDate) - 
                           (a.myStatusUpdateDate || a.myTagsUpdateDate || a.creationDate));
  });
  
  return groups;
};
```

#### 4.2.2 Filter System
```typescript
const applyFilters = (shows: Show[], filters: FilterConfiguration[]) => {
  return shows.filter(show => {
    return filters.every(filter => {
      switch (filter.type) {
        case "genre":
          return show.genres.includes(filter.value);
        case "myStatus":
          return show.myStatus === filter.value;
        case "myTag":
          return show.myTags.includes(filter.value);
        case "communityScore":
          return show.voteAverage && show.voteAverage >= parseFloat(filter.value);
        case "decade":
          const year = getReleaseYear(show);
          return Math.floor(year / 10) * 10 === parseInt(filter.value);
        case "mediaType":
          return show.showType === filter.value;
        default:
          return true;
      }
    });
  });
};
```

### 4.3 Search

#### 4.3.1 Search Implementation
```typescript
const searchShows = async (query: string) => {
  // Search external catalog
  const results = await catalogAPI.search(query);
  
  // Map to local representation
  const shows = results.map(result => mapExternalToStored(result));
  
  // Mark in-collection items
  const inCollectionIds = await getInCollectionIds();
  shows.forEach(show => {
    show.isInCollection = inCollectionIds.has(show.id);
  });
  
  return shows;
};
```

#### 4.3.2 Search UI
- Poster grid layout
- Collection indicators on tiles
- Quick access from Search icon
- Optional auto-open on launch (per `autoSearch` setting)

### 4.4 Show Detail Page

#### 4.4.1 Section Order (per PRD)
1. Header media carousel (backdrops/posters/logos/trailers)
2. Core facts row (year/length + community score)
3. Tag chips (My Tags)
4. Overview text + Scoop toggle
5. "Ask about this show" CTA
6. Genres + languages
7. Recommendations strand
8. Explore Similar (concepts → recs)
9. Providers ("Stream It")
10. Cast, Crew
11. Seasons (TV only)
12. Budget/Revenue (movies where available)

#### 4.4.2 Header Media Component
```typescript
const HeaderMedia = ({ show }: { show: Show }) => {
  // Prioritize trailers when available
  const mediaItems = [
    ...(show.videos || []).filter(v => v.type === "trailer"),
    ...(show.backdropUrlString ? [{ url: show.backdropUrlString, type: "backdrop" }] : []),
    ...(show.posterUrlString ? [{ url: show.posterUrlString, type: "poster" }] : [])
  ];
  
  return <Carousel items={mediaItems} />;
};
```

#### 4.4.3 Status Toolbar
```typescript
const StatusToolbar = ({ show, onUpdate }: { show: Show, onUpdate: (status: MyStatusType) => void }) => {
  const chips = [
    { label: "Active", value: "active", icon: "playing" },
    { label: "Excited", value: "interested", icon: "star" }, // Maps to Later + Excited
    { label: "Interested", value: "interested", icon: "bookmark" }, // Maps to Later + Interested
    { label: "Done", value: "done", icon: "check" },
    { label: "Wait", value: "wait", icon: "pause" },
    { label: "Quit", value: "quit", icon: "x" }
  ];
  
  return (
    <Toolbar>
      {chips.map(chip => (
        <Chip
          key={chip.value}
          label={chip.label}
          active={show.myStatus === chip.value || (chip.value === "interested" && show.myInterest === "excited")}
          onClick={() => handleStatusChange(chip.value, show.myInterest)}
        />
      ))}
    </Toolbar>
  );
};
```

### 4.5 AI Scoop ("The Scoop")

#### 4.5.1 Generation Logic
```typescript
const generateScoop = async (showId: string): Promise<string> => {
  const show = await getShow(showId);
  
  // Check freshness (4 hours)
  if (show.aiScoop && show.aiScoopUpdateDate) {
    const age = Date.now() - new Date(show.aiScoopUpdateDate).getTime();
    if (age < 4 * 60 * 60 * 1000) {
      return show.aiScoop; // Return cached
    }
  }
  
  // Generate new scoop
  const response = await aiAPI.generateScoop({
    show,
    personality: "fun-friend-critic",
    spoilerSafe: true,
    structure: {
      personalTake: true,
      honestStackup: true,
      scoopCenterpiece: true,
      fitWarnings: true,
      verdict: true
    }
  });
  
  // Update with timestamp
  show.aiScoop = response.content;
  show.aiScoopUpdateDate = new Date().toISOString();
  
  // Only persist if in collection
  if (show.myStatus) {
    await saveScoop(show);
  }
  
  return response.content;
};
```

#### 4.5.2 Progressive Streaming
```typescript
const StreamScoop = ({ showId }: { showId: string }) => {
  const [status, setStatus] = useState<"idle" | "generating" | "ready">("idle");
  const [content, setContent] = useState("");
  
  useEffect(() => {
    const stream = async () => {
      setStatus("generating");
      
      for await (const chunk of aiAPI.streamScoop(showId)) {
        setContent(prev => prev + chunk);
      }
      
      setStatus("ready");
    };
    
    stream();
  }, [showId]);
  
  return (
    <div>
      {status === "generating" && <GeneratingIndicator />}
      {status === "ready" && <ScoopContent content={content} />}
    </div>
  );
};
```

### 4.6 Ask Chat

#### 4.6.1 Chat Interface
```typescript
const AskChat = () => {
  const [messages, setMessages] = useState<Message[]>([]);
  const [context, setContext] = useState<ChatContext>({
    library: [],
    recentTurns: [],
    showContext: null
  });
  
  const handleSend = async (query: string) => {
    // Add user message
    const userMsg: Message = { role: "user", content: query };
    setMessages(prev => [...prev, userMsg]);
    
    // Get AI response with context
    const response = await aiAPI.ask({
      query,
      context,
      personality: "friendly-entertainment-nerd",
      format: "commentary-with-mentions"
    });
    
    // Add AI message
    const aiMsg: Message = {
      role: "assistant",
      content: response.commentary,
      showList: response.showList // For UI rendering
    };
    setMessages(prev => [...prev, aiMsg]);
    
    // Summarize if conversation exceeds 10 turns
    if (messages.length > 10) {
      context.recentTurns = await summarizeTurns(context.recentTurns);
    }
  };
  
  return (
    <ChatInterface
      messages={messages}
      onSend={handleSend}
      mentionedShows={lastMessage.showList}
      starterPrompts={getStarterPrompts()}
    />
  );
};
```

#### 4.6.2 Mentioned Shows Strip
```typescript
const parseMentionedShows = (text: string): ShowMention[] => {
  // Format: Title::externalId::mediaType;;Title2::externalId::mediaType;;...
  const pairs = text.split(";;");
  return pairs.map(pair => {
    const [title, externalId, mediaType] = pair.split("::");
    return { title, externalId, mediaType };
  });
};
```

#### 4.6.3 Starter Prompts
```typescript
const getStarterPrompts = (): string[] => {
  return [
    "What should I watch tonight?",
    "Recommend something with hopeful absurdity",
    "I'm in the mood for a procedural drama",
    "What's hidden gem with great writing?",
    "Show me something with quirky found family",
    "Need something light in dark moments"
    // ... 74 more prompts
  ];
};
```

### 4.7 Alchemy

#### 4.7.1 Alchemy Flow
```typescript
const AlchemySession = () => {
  const [step, setStep] = useState<1 | 2 | 3 | 4>(1);
  const [selectedShows, setSelectedShows] = useState<Show[]>([]);
  const [concepts, setConcepts] = useState<string[]>([]);
  const [selectedConcepts, setSelectedConcepts] = useState<string[]>([]);
  const [recommendations, setRecommendations] = useState<Show[]>([]);
  
  // Step 1: Select 2+ shows
  const handleSelectShows = (shows: Show[]) => {
    if (shows.length >= 2) {
      setSelectedShows(shows);
      setStep(2);
    }
  };
  
  // Step 2: Conceptualize
  const conceptualize = async () => {
    const concepts = await aiAPI.extractConcepts({
      shows: selectedShows,
      mode: "multi-show"
    });
    setConcepts(concepts);
    setStep(3);
  };
  
  // Step 3: Select concepts (max 8)
  const handleConceptSelection = (concepts: string[]) => {
    setSelectedConcepts(concepts.slice(0, 8));
  };
  
  // Step 4: Alchemize
  const alchemize = async () => {
    const recs = await aiAPI.generateRecommendations({
      concepts: selectedConcepts,
      mode: "alchemy",
      count: 6
    });
    setRecommendations(recs);
    setStep(4);
  };
  
  // Chain to new round
  const chain = (newBaseShows: Show[]) => {
    setSelectedShows(newBaseShows);
    setConcepts([]);
    setSelectedConcepts([]);
    setRecommendations([]);
    setStep(1);
  };
  
  return (
    <AlchemyFlow
      step={step}
      selectedShows={selectedShows}
      concepts={concepts}
      selectedConcepts={selectedConcepts}
      recommendations={recommendations}
      onSelectShows={handleSelectShows}
      onConceptualize={conceptualize}
      onConceptSelect={handleConceptSelection}
      onAlchemize={alchemize}
      onChain={chain}
    />
  );
};
```

#### 4.7.2 Clear Downstream Results
```typescript
const AlchemyControls = ({ state, setState }) => {
  const handleShowSelection = (shows) => {
    // Clear concepts and results when shows change
    setState(prev => ({
      ...prev,
      selectedShows: shows,
      concepts: [],
      selectedConcepts: [],
      recommendations: []
    }));
  };
  
  const handleConceptSelection = (concepts) => {
    // Clear results when concepts change
    setState(prev => ({
      ...prev,
      selectedConcepts: concepts,
      recommendations: []
    }));
  };
};
```

### 4.8 Explore Similar (Single Show)

#### 4.8.1 Concept Extraction
```typescript
const ExploreSimilar = ({ showId }: { showId: string }) => {
  const [show, setShow] = useState<Show | null>(null);
  const [concepts, setConcepts] = useState<string[]>([]);
  const [selectedConcepts, setSelectedConcepts] = useState<string[]>([]);
  const [recommendations, setRecommendations] = useState<Show[]>([]);
  
  const handleGetConcepts = async () => {
    const concepts = await aiAPI.extractConcepts({
      showId,
      mode: "single-show"
    });
    setConcepts(concepts);
  };
  
  const handleExplore = async () => {
    const recs = await aiAPI.generateRecommendations({
      concepts: selectedConcepts,
      mode: "explore-similar",
      count: 5
    });
    setRecommendations(recs);
  };
  
  return (
    <ExploreSimilarSection
      show={show}
      concepts={concepts}
      selectedConcepts={selectedConcepts}
      recommendations={recommendations}
      onGetConcepts={handleGetConcepts}
      onConceptSelect={setSelectedConcepts}
      onExplore={handleExplore}
    />
  );
};
```

### 4.9 Person Detail Page

#### 4.9.1 Person Profile
```typescript
const PersonDetail = ({ personId }: { personId: string }) => {
  const [person, setPerson] = useState<Person | null>(null);
  
  const fetchPerson = async () => {
    const person = await catalogAPI.getPerson(personId);
    
    // Fetch analytics data
    const analytics = await calculatePersonAnalytics(person.filmography);
    
    setPerson({
      ...person,
      analytics
    });
  };
  
  return (
    <PersonDetailPage
      person={person}
      onCreditClick={handleCreditClick}
    />
  );
};
```

#### 4.9.2 Analytics Calculation
```typescript
const calculatePersonAnalytics = (filmography: Credit[]) => {
  // Calculate average ratings by genre
  const ratingsByGenre = groupBy(filmography, "genre").map(
    ([genre, credits]) => ({
      genre,
      averageRating: average(credits.map(c => c.rating))
    })
  );
  
  // Projects by year
  const projectsByYear = groupBy(filmography, "year").map(
    ([year, credits]) => ({
      year,
      count: credits.length
    })
  );
  
  return {
    ratingsByGenre,
    projectsByYear
  };
};
```

### 4.10 Settings & Export

#### 4.10.1 Settings Configuration
```typescript
const Settings = () => {
  const [settings, setSettings] = useState<SettingsState>({
    app: {
      autoSearch: false,
      fontSize: "M"
    },
    user: {
      userName: "",
      aiApiKey: "",
      aiModel: "",
      catalogApiKey: ""
    }
  });
  
  const handleExport = async () => {
    const shows = await getAllShows();
    const settings = await getCloudSettings();
    
    const exportData = {
      version: 1,
      exportDate: new Date().toISOString(),
      shows: shows.map(show => ({
        ...show,
        // Exclude transient fields
        cast: undefined,
        crew: undefined,
        seasons: undefined,
        videos: undefined
      })),
      settings
    };
    
    // Create ZIP
    const zip = await createZip({
      "shows.json": JSON.stringify(exportData, null, 2),
      "settings.json": JSON.stringify(settings, null, 2)
    });
    
    // Trigger download
    downloadFile(zip, `backup-${new Date().toISOString()}.zip`);
  };
  
  return (
    <SettingsPage
      settings={settings}
      onSettingChange={setSettings}
      onExport={handleExport}
    />
  );
};
```

---

## 5. AI Integration

### 5.1 AI Provider Interface
```typescript
interface AIProvider {
  // Ask
  ask(params: AskParams): Promise<AskResponse>;
  askStream(params: AskParams): AsyncGenerator<AskResponse>;
  
  // Scoop
  generateScoop(params: ScoopParams): Promise<string>;
  generateScoopStream(params: ScoopParams): AsyncGenerator<string>;
  
  // Concepts
  extractConcepts(params: ConceptsParams): Promise<string[]>;
  
  // Recommendations
  generateRecommendations(params: RecsParams): Promise<Show[]>;
}
```

### 5.2 AI Personality Configuration
```typescript
const AI_PERSONALITY = {
  // Voice pillars
  joyForward: true,
  opinionatedHonesty: true,
  vibeFirst: true,
  specificNotGeneric: true,
  conciseByDefault: true,
  
  // Tone sliders
  friendToCritic: 0.7,
  hypeToMeasured: 0.6,
  playfulToSerious: "adaptive",
  conciseToLyrical: "concise", // except for Scoop
  
  // Guardrails
  domain: "tv-movies",
  spoilerSafe: true,
  redirectOutOfDomain: true
};
```

### 5.3 Prompt Templates
```typescript
const PROMPTS = {
  // Ask
  ask: (context: AskContext) => `
    You are a fun, chatty TV/movie nerd friend.
    Personality: ${JSON.stringify(AI_PERSONALITY)}
    
    User's library: ${context.library.map(s => s.title).join(", ")}
    Recent conversation: ${context.recentTurns}
    Current query: ${context.query}
    
    Respond like a friend in dialogue, be opinionated but honest,
    spoiler-safe by default. Use simple formatting and bulleted lists
    for multiple recommendations.
  `,
  
  // Scoop
  scoop: (show: Show) => `
    Generate a personality-driven "mini blog post of taste" for:
    ${show.title} (${show.showType})
    
    Structure:
    1. Personal take (make a stand)
    2. Honest stack-up vs reviews
    3. The Scoop centerpiece (emotional heart)
    4. Practical fit/warnings
    5. "Worth it?" gut check
    
    Target: ~150-350 words. Keep it gossipy, vivid, and useful.
  `,
  
  // Concepts
  concepts: (shows: Show[]) => `
    Extract 8 evocative concept ingredients from:
    ${shows.map(s => s.title).join(", ")}
    
    Rules:
    - 1-3 words per concept
    - Bullet list only
    - No generic concepts ("good characters")
    - No plot details or spoilers
    - Order by strength/aha factor
    - Cover varied axes (structure, vibe, emotion, craft)
    
    Examples: "hopeful absurdity", "case-a-week", "quirky makeshift family"
  `,
  
  // Recommendations
  recommendations: (concepts: string[], mode: string) => `
    Generate ${mode === "alchemy" ? "6" : "5"} show recommendations
    based on these concepts: ${concepts.join(", ")}
    
    For each:
    - Resolve to real catalog item
    - Provide concise reason naming which concept(s) align
    - 1-3 sentences per reason
    - Bias toward recent but allow classics
    
    Format: Show title + external ID + reason
  `
};
```

---

## 6. External Catalog Integration

### 6.1 Catalog Provider Interface
```typescript
interface CatalogProvider {
  search(query: string): Promise<SearchResult[]>;
  getShow(id: string): Promise<Show>;
  getPerson(id: string): Promise<Person>;
  getRecommendations(showId: string): Promise<Show[]>;
  getStreamingProviders(showId: string, region: string): Promise<ProviderData>;
}
```

### 6.2 Show Merging Strategy
```typescript
const mergeShows = (stored: Show, external: Show): Show => {
  const merged = { ...stored };
  
  // Non-my fields: use selectFirstNonEmpty
  const nonMyFields = [
    "overview", "tagline", "homepage", "originalLanguage",
    "posterUrlString", "backdropUrlString", "logoUrlString",
    "voteAverage", "popularity", "voteCount",
    "runtime", "budget", "revenue", "seriesStatus",
    "numberOfEpisodes", "numberOfSeasons"
  ];
  
  nonMyFields.forEach(field => {
    merged[field] = selectFirstNonEmpty(external[field], stored[field]);
  });
  
  // My fields: use timestamp comparison
  const myFields = [
    { user: "myTags", update: "myTagsUpdateDate" },
    { user: "myScore", update: "myScoreUpdateDate" },
    { user: "myStatus", update: "myStatusUpdateDate" },
    { user: "myInterest", update: "myInterestUpdateDate" }
  ];
  
  myFields.forEach(({ user, update }) => {
    if (stored[update] && external[update]) {
      if (new Date(stored[update]) > new Date(external[update])) {
        merged[user] = stored[user];
      } else {
        merged[user] = external[user];
      }
    } else if (stored[update]) {
      merged[user] = stored[user];
    } else {
      merged[user] = external[user];
    }
  });
  
  // Update details date
  merged.detailsUpdateDate = new Date().toISOString();
  
  return merged;
};

const selectFirstNonEmpty = (a: any, b: any) => {
  if (a !== null && a !== undefined) {
    if (typeof a === "string" && a !== "") return a;
    if (Array.isArray(a) && a.length > 0) return a;
    if (typeof a === "number") return a;
    return a;
  }
  return b;
};
```

---

## 7. Namespace & User Isolation

### 7.1 Namespace Management
```typescript
const namespaceManager = {
  // Generate or retrieve namespace ID
  getOrCreateNamespace: async (): Promise<string> => {
    // Check environment for existing namespace
    const envNamespace = process.env.NAMESPACE_ID;
    
    if (envNamespace) {
      return envNamespace;
    }
    
    // Generate new namespace
    const namespace = generateUUID();
    
    // Store in build tracking
    await createBuildRecord({
      namespaceId: namespace,
      createdAt: new Date()
    });
    
    return namespace;
  },
  
  // Get current user ID
  getCurrentUserId: (): string => {
    // Dev mode: use header or injected ID
    if (process.env.NODE_ENV === "development") {
      return devUserId || "dev-default-user";
    }
    
    // Production: use authenticated user
    return session?.user.id;
  },
  
  // Partition key for queries
  getPartitionKey: () => {
    return {
      namespaceId: namespaceManager.getOrCreateNamespace(),
      userId: namespaceManager.getCurrentUserId()
    };
  }
};
```

### 7.2 Dev Auth Injection
```typescript
// middleware.ts or server route handler
export const devAuthInjection = async (req, res, next) => {
  if (process.env.NODE_ENV === "development") {
    const devUserId = req.headers["x-user-id"] as string;
    
    if (devUserId) {
      // Set user context for the request
      req.userId = devUserId;
      req.namespaceId = process.env.NAMESPACE_ID || "dev-default";
    }
  }
  
  next();
};
```

### 7.3 Reset Test Data
```typescript
const resetNamespaceData = async (namespaceId: string, userId: string) => {
  // Delete all shows for namespace/user
  await db.shows.deleteMany({
    where: {
      namespaceId,
      userId
    }
  });
  
  // Reset local settings
  await db.localSettings.deleteMany({
    where: { namespaceId, userId }
  });
  
  // Reset UI state
  await db.uiState.deleteMany({
    where: { namespaceId, userId }
  });
  
  // Clear AI cache
  await aiCache.clear(namespaceId);
};
```

---

## 8. Commands & Scripts

### 8.1 Package.json Scripts
```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "test": "jest",
    "test:reset": "npm run test && npm run db:reset",
    "db:migrate": "npx supabase db push",
    "db:reset": "npx supabase db reset --namespace=$NAMESPACE_ID",
    "db:seed": "node scripts/seed.js"
  }
}
```

### 8.2 Environment Variables
```bash
# .env.example
# Required variables

# Supabase
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
SUPABASE_SERVICE_KEY=your-supabase-service-key (server-only)

# External Catalog API
CATALOG_API_KEY=your-catalog-api-key

# AI Provider
AI_API_KEY=your-ai-api-key
AI_MODEL=your-ai-model

# Namespace (for builds)
NAMESPACE_ID=unique-namespace-id

# Dev identity injection
DEV_USER_ID=dev-user-id (optional, for development)

# App settings
NEXT_PUBLIC_AUTO_SEARCH=false
NEXT_PUBLIC_FONT_SIZE=M
```

---

## 9. Implementation Phases

### Phase 1: Foundation (Weeks 1-2)
- [ ] Set up Next.js project with TypeScript
- [ ] Configure Supabase client and database schema
- [ ] Implement basic data models and types
- [ ] Create environment configuration
- [ ] Set up development identity injection
- [ ] Write initial migrations

### Phase 2: Core Data Layer (Weeks 3-4)
- [ ] Implement Show CRUD operations
- [ ] Build merge strategy for catalog data
- [ ] Implement timestamp-based conflict resolution
- [ ] Create namespace/user partitioning
- [ ] Add local settings storage
- [ ] Write integration tests for data layer

### Phase 3: Collection Home (Weeks 5-6)
- [ ] Build collection home page
- [ ] Implement status grouping (Active, Excited, Interested, Other)
- [ ] Create filter system (tag, genre, decade, score)
- [ ] Implement poster grid layout
- [ ] Add empty states
- [ ] Test collection management flows

### Phase 4: Show Detail (Weeks 7-8)
- [ ] Build Show Detail page with all sections
- [ ] Implement status toolbar with chips
- [ ] Add rating slider
- [ ] Build media carousel
- [ ] Implement streaming availability
- [ ] Add cast/crew links

### Phase 5: AI Integration (Weeks 9-12)
- [ ] Set up AI provider interface
- [ ] Implement Ask chat with streaming
- [ ] Build mentioned shows strip
- [ ] Implement Scoop generation with streaming
- [ ] Add concept extraction
- [ ] Build recommendation engine

### Phase 6: Discovery Features (Weeks 13-14)
- [ ] Implement Search page
- [ ] Build Alchemy flow (4 steps)
- [ ] Implement Explore Similar
- [ ] Add concept selection UX
- [ ] Create recommendation cards
- [ ] Test discovery flows

### Phase 7: Person Detail (Week 15)
- [ ] Build Person Detail page
- [ ] Implement filmography display
- [ ] Add analytics charts
- [ ] Link to Show Detail from credits

### Phase 8: Settings & Export (Week 16)
- [ ] Build Settings page
- [ ] Implement font size and search-on-launch
- [ ] Add API key management
- [ ] Build export functionality (ZIP)
- [ ] Add import placeholder
- [ ] Test settings persistence

### Phase 9: Polish & Testing (Weeks 17-18)
- [ ] Cross-browser testing
- [ ] Performance optimization
- [ ] Accessibility audit
- [ ] End-to-end testing
- [ ] Documentation
- [ ] Bug fixes

---

## 10. Testing Strategy

### 10.1 Unit Tests
- Data models and merge logic
- Filter application
- Timestamp comparison
- Save triggers
- AI prompt construction

### 10.2 Integration Tests
- Show CRUD operations
- Namespace isolation
- Catalog merging
- AI API integration
- Export/import

### 10.3 E2E Tests
- Collection management flows
- Search and discovery
- Ask chat interactions
- Alchemy sessions
- Settings persistence

---

## 11. Risk Mitigation

### 11.1 High Risks
1. **AI output consistency** - Implement prompt versioning and fallback strategies
2. **Catalog API rate limits** - Add caching and request throttling
3. **Data sync conflicts** - Test extensively with concurrent modifications
4. **Namespace isolation bugs** - Add integration tests for cross-namespace queries

### 11.2 Contingency Plans
- Fallback to simpler recommendations if AI fails
- Graceful degradation for catalog fetch failures
- Local caching for offline-first experience

---

## 12. Success Criteria

### 12.1 Functional Requirements
- [ ] All 99 catalog requirements covered
- [ ] 30 critical requirements fully implemented
- [ ] All discovery modes functional
- [ ] AI features working with appropriate quality

### 12.2 Performance Requirements
- [ ] Page load < 3 seconds
- [ ] AI response < 5 seconds
- [ ] Smooth scroll and interactions

### 12.3 Quality Requirements
- [ ] No critical bugs
- [ ] All E2E tests passing
- [ ] Accessibility compliance (WCAG 2.1 AA)

---

## 13. Deliverables

### 13.1 Code
- Complete Next.js application
- Supabase migrations
- TypeScript type definitions
- Test suite

### 13.2 Documentation
- README with setup instructions
- Environment variable documentation
- API integration guide
- Deployment guide

### 13.3 Configuration
- `.env.example` with all required variables
- `.gitignore` excluding `.env*` files
- Package.json with scripts
- Supabase configuration

---

## Appendix A: Requirement Traceability

This plan maps to the 99 requirements in the canonical catalog:

| PRD-ID | Feature Area | Implementation Location |
|--------|-------------|------------------------|
| PRD-001 to PRD-017 | Benchmark Runtime & Isolation | Sections 1, 7, 8 |
| PRD-018 to PRD-037 | Collection Data & Persistence | Sections 3, 4.1, 6.2 |
| PRD-038 to PRD-050 | App Navigation & Discover Shell | Sections 4.2, 4.3 |
| PRD-051 to PRD-064 | Show Detail & Relationship UX | Section 4.4 |
| PRD-065 to PRD-074 | Ask Chat | Section 4.6 |
| PRD-075 to PRD-084 | Concepts, Explore Similar & Alchemy | Sections 4.7, 4.8 |
| PRD-085 to PRD-091 | AI Voice, Persona & Quality | Section 5 |
| PRD-092 to PRD-095 | Person Detail | Section 4.9 |
| PRD-096 to PRD-099 | Settings & Export | Section 4.10 |

---

## Appendix B: Open Questions

1. **Import/Restore**: Should we implement import from export ZIP in this phase or defer?
2. **Next Status**: Should Next be made first-class UI status or remain hidden?
3. **Named Lists**: Should users be able to create named custom lists beyond tags?
4. **AI Scoop on unsaved**: Should generating Scoop on unsaved show auto-save?
5. **Unrated state**: Should clearing rating store explicit Unrated state vs nil?

---

**Plan Complete** - This implementation plan covers all 99 requirements across 10 functional areas, with detailed specifications for each feature, data models, AI integration, and testing strategy.
