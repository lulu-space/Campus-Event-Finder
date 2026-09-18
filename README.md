# Campus Event Finder

Flutter graduation project by LAYAN DIAB (Al-Quds / Abu Dis).

University students can discover campus events, save favorites, and register in one flow.

## Screens

Home (upcoming + featured) → Event Details → Register Form → My Events → Favorites → Profile (theme + language).

Bottom navigation: **Home | My Events | Favorites | Profile**

Home card → Details → Register.

## Event data

Campus events (tech talks, seminars, workshops, debates, science fairs, club
activities, competitions, and sports) are bundled with the app in
[`assets/events.json`](assets/events.json) and loaded by
`lib/services/event_service.dart`.

To add or edit events, just edit `assets/events.json` — each event looks like:

```json
{
  "id": "evt-001",
  "name": "AI & Robotics: The Next Decade",
  "description": "A deep-dive tech talk …",
  "date": "2026-09-24",
  "time": "14:00",
  "location": "Main Auditorium, IT Building",
  "organizer": "Computer Science Department",
  "category": "Tech Talk",
  "registrationUrl": "https://…"
}
```

`registrationUrl` is optional. `category` should be one of the categories in
`lib/theme/category_style.dart` (each category has its own color + icon).

> The service layer keeps the same shape a remote API would have, so the app can
> later be pointed at a backend (e.g. Firebase) by changing only
> `event_service.dart`.

## Saved locally

Favorites, registered event IDs, theme, and language.

## Shared state (Provider)

Favorites count, registered events, dark/light theme, and Arabic/English.

## Run

```bash
flutter pub get
flutter run
```
