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

## App icon

The launcher icon is `assets/app_icon.png` (calendar and location pin). Android, iOS, web, Windows, and macOS icons are generated from that file.

After you replace the image, regenerate the platform icons:

```powershell
dart run flutter_launcher_icons
```

Stop the app and run it again. Hot reload does not change a launcher icon. On Chrome, hard-refresh the tab. On Windows, rebuild so the `.exe` picks up the new icon.

## Run

```powershell
flutter pub get
flutter run
```

Try **United Kingdom** + city `London`, or **United States** + `New York`.

### VS Code

1. Install the **Flutter** extension (`Dart-Code.flutter`). It also installs Dart.
2. Open this folder: **File → Open Folder**.
3. Open a terminal (**View → Terminal**) and run `flutter pub get`.
4. Pick a device in the bottom-right status bar: **Chrome** for a quick demo, or an **Android emulator / phone** to show SQLite.
5. Press **F5** and choose **Campus Event Finder**. That configuration is type `dart` and starts Flutter. The Chrome entry named **Launch Chrome against localhost** only opens a browser at port 8080 and does not start the app.

If Chrome opens a blank page, use `http://127.0.0.1:8080` (not `0.0.0.0`). Demo Day SQLite belongs on Android or desktop, not Chrome.
