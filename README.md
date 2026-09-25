# Campus Event Finder

Flutter graduation project by LAYAN DIAB (Al-Quds / Abu Dis).

University students can discover events, save favorites, and register in one flow. There is no login. Saved data stays on the device.

## Tech stack

Dart and Flutter. Live events come from the Ticketmaster Discovery API through the `http` package. Provider shares favorites, registrations, theme, and language. SQLite (`sqflite`) stores favorites and registrations. SharedPreferences stores theme and language.

## Screens

Home (upcoming + featured) → Event Details → Register Form → My Events → Favorites → Profile (theme + language).

Bottom navigation: **Home | My Events | Favorites | Profile**

Home card → Details (Hero on the event image) → Register.

Named routes: `/` Home, `/event` Details, `/register` Register.

Home loads events with `FutureBuilder`: a spinner while the request runs, an error with Retry if it fails, and the event list when it arrives. The Register page is a `Form` that checks name, email, and student ID before saving.

## Live API

[Ticketmaster Discovery API](https://developer.ticketmaster.com) — search events by **country** and optional **city** or **keyword**, then fetch event details by ID.

Use the **country dropdown** (United Kingdom, United States, Canada, Ireland, and other Ticketmaster markets). Type a city such as `London` to narrow the list, or leave the city empty to see the whole country.

Ticketmaster does not cover every country. Places such as Palestine, France, or Japan can return no events.

Put your Consumer Key in `lib/services/api_config.dart`.

Registering in the app saves the event on the device. It does not buy a Ticketmaster ticket.

## Saved locally

- **SQLite:** favorites and registered events on Android, iOS, and desktop.
- **SharedPreferences:** theme and language. On web, favorites and registrations also use SharedPreferences because the browser has no SQLite plugin.

## Shared state (Provider)

Favorites count, registered events, dark/light theme, and Arabic/English. A change on one screen updates the others.

## Run

```powershell
flutter pub get
flutter run
```

Try **United Kingdom** + city `London`, or **United States** + `New York`.

Run on an Android phone or emulator to show SQLite. A browser demo stores the lists in SharedPreferences.
