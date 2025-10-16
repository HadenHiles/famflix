# FamFlix • GitHub Copilot Command Playbook (Web‑Only Flutter)

Use these **numbered, copy‑paste prompts** directly in VS Code to drive GitHub Copilot. They assume you pasted the provided lib/ into your project and you're targeting **Flutter Web**. Prioritize **Jellyseerr** wiring first, then Plex and the rest.

## 0) Brief Copilot on the current structure

- **Prompt Copilot:**

- You are helping me implement FamFlix (Flutter web). Here's the current structure; memorize these files and their responsibilities:
- lib/  
    app_theme.dart // Theme + palette (Netflix-ish)  
    main.dart // MaterialApp.router setup  
    router.dart // Simple RouterDelegate-based nav  
    models/  
    media_item.dart // UI-facing model (MediaItem)  
    services/  
    jellyseerr_service.dart // Jellyseerr API client (trending, search)  
    plex_service.dart // Plex API client (recentlyAdded)  
    mock_data.dart // Mock data to run UI  
    widgets/  
    media_poster.dart // Poster tile  
    horizontal_carousel.dart // Horizontal scroller  
    screens/  
    components/  
    top_nav_bar.dart // AppBar  
    hero_banner.dart // Hero backdrop + CTAs  
    home_screen.dart // Hero + carousels (mock for now)  
    details_screen.dart // Poster + chips + actions  
    search_screen.dart // TextField + results (mock)  
    profile_screen.dart // Integration fields (no persistence yet)
- Our priorities:
  - Wire **Jellyseerr** for Trending + Search. 2) Persist integration settings (web safe). 3) Add request action to Jellyseerr. 4) Add Plex for Continue Watching / Recently Added. 5) Basic error/empty/loading UX. 6) Keep code simple and web-only.

## 1) Add foundational dependencies (http exists; add persistence)

- **Prompt Copilot:**

- Open pubspec.yaml and add dependencies (latest stable):
- dependencies:  
    flutter:  
    sdk: flutter  
    http: ^1.2.2  
    shared_preferences: ^2.3.2
- Then generate imports where used. Do **not** add mobile-only plugins.

## 2) Create a lightweight Settings store (web local storage)

- **Prompt Copilot:**

- Create lib/services/settings_store.dart that persists to shared_preferences (works on web). Keys:
  - jelly_base_url (string), jelly_api_key (string)
  - plex_base_url (string), plex_token (string), plex_client_id (string)
- API:
  - Future&lt;void&gt; save({required Map&lt;String,String&gt; values})
  - Future&lt;Map<String,String&gt;> load()
  - Stream&lt;Map<String,String&gt;> watch() (simple broadcast that emits after each save)
- Keep it tiny and synchronous where possible; wrap writes in async.

- **Prompt Copilot:**

- Update profile_screen.dart to:
  - Load settings on init and populate TextFields.
  - On Save, write via SettingsStore and show a SnackBar on success.
  - Emit a SettingsStore.watch() update so Home/Search can refresh.

## 3) Add a tiny DI/state holder (no heavy frameworks)

- **Prompt Copilot:**

- Create lib/services/app_context.dart that exposes:
  - SettingsStore settings
  - JellyseerrService? jelly() constructed lazily from settings (null if baseUrl/apiKey missing)
  - PlexService? plex() constructed lazily from settings (null if token/baseUrl missing)
  - A ValueNotifier&lt;int&gt; version that increments when settings change to trigger rebuilds.
- Also add an InheritedWidget named AppCtx with of(context) helper to access AppContext.

- **Prompt Copilot:**

- Wrap the app with AppCtx in main.dart (inside FamFlixApp build). Load settings on startup; when settings.watch() emits, rebuild MaterialApp.router by bumping version.

## 4) Wire Jellyseerr: Trending on Home, Search in SearchScreen

- **Prompt Copilot:**

- In home_screen.dart:
  - Replace mock Trending Now with live Jellyseerr fetchTrending(page: 1) if AppCtx.of(context).jelly() is non-null; otherwise fallback to mock.
  - Show LinearProgressIndicator while loading.
  - On error, show a subdued error row with retry.
  - Keep Continue Watching mock for now (Plex later).

- **Prompt Copilot:**

- In search_screen.dart:
  - Replace \_doSearch mock with JellyseerrService.search(query) when available.
  - Debounce user input by ~300ms.
  - Indicate loading and show empty-state if 0 results.
  - Use existing HorizontalCarousel to render results.

- **Prompt Copilot:**

- In jellyseerr_service.dart, add a method Future&lt;bool&gt; requestTitle({required int tmdbId, required String mediaType}) that calls Jellyseerr's Request endpoint (/request) with the API key. Keep parameters minimal; handle both movie and tv. Return true/false and throw on HTTP errors.

- **Prompt Copilot:**

Update item mapping in jellyseerr_service.dart to surface TMDB id and mediaType on MediaItem via an extension or add optional fields tmdbId (String) and origin (enum: tmdb, plex, unknown) without breaking existing UI. Default to unknown.

- **Prompt Copilot:**

In details_screen.dart and the bottom sheet in home_screen.dart, wire the **Request (Jellyseerr)** button: - If MediaItem has a tmdbId and origin == tmdb, call requestTitle with correct mediaType. - SnackBar: success/failure messages.

## 5) Add basic image/CDN handling + placeholders

- **Prompt Copilot:**

In widgets/media_poster.dart and screens/components/hero_banner.dart, ensure we set: - Timeouts on Image.network via errorBuilder fallback only (Flutter doesn't have timeout param; acceptable). - Maintain placeholders as already implemented; no external cache plugin needed for web.

## 6) Error, empty, and loading UX utilities

- **Prompt Copilot:**

Create lib/widgets/async_section.dart with a stateless helper that renders one of: loading bar, error row with retry, or child. Props: isLoading, errorText, onRetry, child.

Use this in Home (Trending section) and Search results.

## 7) Plex integration for Continue Watching / Recently Added

- **Prompt Copilot:**

In plex_service.dart, add a simple method fetchContinueWatching() that hits /status/sessions and combines with /library/metadata/{ratingKey} if necessary to map into MediaItem. If that's too involved, implement fetchRecentlyAdded(sectionKey) (already exists) and wire it first.

- **Prompt Copilot:**

Update home_screen.dart to: - Add a settings-driven toggle: if plex() available, call fetchRecentlyAdded(sectionKey) for a user-configured sectionKey (temporarily hardcode '1'), otherwise fallback to mock. - Render via HorizontalCarousel.

- **Prompt Copilot:**

In profile_screen.dart, add a TextField for Plex Section Key (string) and persist it via SettingsStore with key plex_section_key.

## 8) Play on Plex (deep link)

- **Prompt Copilot:**

Add a helper in plex_service.dart: Uri buildPlexWebUrl({required String ratingKey}) that returns a web app URL if baseUrl is accessible, else return <https://app.plex.tv/desktop> with ?X-Plex-Token=... if feasible. This can be a best-effort deep link; for web builds, opening in a new tab is fine.

- **Prompt Copilot:**

Wire the **Play on Plex** button in details_screen.dart to launchUrl (use url_launcher dependency). If ratingKey missing (e.g., Jellyseerr-only item), gray out the button.

- **Prompt Copilot:**

Add url_launcher: ^6.3.0 to pubspec.yaml and configure web.

## 9) Settings polish + validation

- **Prompt Copilot:**

In profile_screen.dart, add light validation: - Base URLs must be http(s) and non-empty when API keys/tokens are present. - On Save, test Jellyseerr by calling /status (if available) and Plex by calling /identity. Show validation SnackBars.

## 10) Proxy & CORS helper docs (non-code)

- **Prompt Copilot:**

Create docs/cors_proxy.md explaining that for Flutter Web we should reverse-proxy /jellyseerr → <http://localhost:5055/api/v1> and /plex → <http://localhost:32400>, then set base URLs accordingly. Include nginx and Caddy examples.

## 11) Light refactors for clarity (optional, keep it simple)

- **Prompt Copilot:**

Create lib/util/iter.dart with helpers like isNullOrEmpty&lt;T&gt;(List&lt;T&gt;?) and a safe mapNotNull. Use them in Home/Search to keep build methods tidy.

- **Prompt Copilot:**

Split the bottom sheet in home_screen.dart into lib/screens/components/item_action_sheet.dart that accepts a MediaItem and optional callbacks for play/request.

## 12) Minimal tests (web-safe)

- **Prompt Copilot:**

Add dev_dependencies: flutter_test: and write a unit test for jellyseerr_service.dart that verifies mapping of a minimal fake response into MediaItem (mock http.Client). No widget tests necessary.

## 13) Performance nits

- **Prompt Copilot:**

Make HorizontalCarousel list items const where possible, add cacheWidth/cacheHeight estimates to poster Image.network for typical 150px width cards (helps web rasterization), and ensure const constructors on stateless widgets.

## 14) Final pass checklist

- **Prompt Copilot:**

Do a full code pass to: - Remove unused imports. - Add doc comments to public methods in jellyseerr_service.dart and plex_service.dart. - Ensure all user-visible errors are subdued and recoverable (retry buttons). - Confirm no mobile-only plugins are added.

## Bonus: Exact snippets Copilot should generate

- **services/settings_store.dart skeleton**
- Create a simple class using SharedPreferences that saves/loads string keys and exposes a Stream via StreamController.broadcast(); close it on dispose.
- **jellyseerr_service.requestTitle**
- POST /request with headers X-Api-Key and JSON { mediaType: "movie"|"tv", mediaId: &lt;tmdbId&gt; }. Handle 201/200 as success.
- **home_screen.dart trending loader**
- On init, if AppCtx.of(context).jelly()!=null, call fetchTrending(), set local state, re-render; else use MockData.trending.
- **search_screen.dart debounce**
- Use Timer? \_debounce; in state to debounce input; cancel on dispose.
- **plex_service.buildPlexWebUrl**
- Construct Uri.parse('\$baseUrl/web/index.html#!/server/.../details?key=\$ratingKey&X-Plex-Token=\$token') as best-effort; document that app.plex.tv may be needed.

### That's it

Paste each prompt as you go. If Copilot derails, re-paste the relevant section to re-anchor it to our structure and priorities.