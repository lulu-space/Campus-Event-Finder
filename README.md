# Campus Event Finder

Flutter graduation project by **Layan Diab** (Al-Quds / Abu Dis).

University students can discover campus events, save favorites, and register in one flow.

## Screens

Home (upcoming + featured) → Event Details → Register Form → My Events → Favorites → Profile (theme + language).

Bottom navigation: **Home | My Events | Favorites | Profile**

Home card → Details (Hero on the event image) → Register.

## Live API

[Ticketmaster Discovery API](https://developer.ticketmaster.com) — search events by **city** and **keyword**, then fetch event details by ID.

Put your Consumer Key in `lib/services/api_config.dart`.

## Saved locally

Favorites, registered event IDs, theme, and language.

## Shared state (Provider)

Favorites count, registered events, dark/light theme, and Arabic/English.

## Run

```powershell
flutter pub get
flutter run
```

Try cities with Ticketmaster coverage, such as `London` or `New York`.
