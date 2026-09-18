# Campus Event Finder

Flutter graduation project by LAYAN DIAB (Al-Quds / Abu Dis).

University students can discover campus events, save favorites, and register in one flow.

## Screens

Home (upcoming + featured) → Event Details → Register Form → My Events → Favorites → Profile (theme + language).

Bottom navigation: **Home | My Events | Favorites | Profile**

Home card → Details (Hero on the event image) → Register.

Named routes: `/` Home, `/event` Details, `/register` Register.

## Live API

[Ticketmaster Discovery API](https://developer.ticketmaster.com) — search events by **country** and optional **city** or **keyword**, then fetch event details by ID.

Use the **country dropdown** (United Kingdom, United States, Canada, Ireland, and other Ticketmaster markets). Type a city such as `London` to narrow the list, or leave the city empty to see the whole country.

Ticketmaster does not cover every country. Places such as Palestine, France, or Japan can return no events.

Put your Consumer Key in `lib/services/api_config.dart`.

## Saved locally

- **SQLite:** favorites and registered events (main data) on Android, iOS, and desktop.
- **SharedPreferences:** theme and language. On web, favorites and registrations also use SharedPreferences because the browser has no SQLite plugin.

## Shared state (Provider)

Favorites count, registered events, dark/light theme, and Arabic/English.

## Run

```powershell
flutter pub get
flutter run
```

Try **United Kingdom** + city `London`, or **United States** + `New York`.
