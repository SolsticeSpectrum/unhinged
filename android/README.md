# Penguin Hub (unofficial Android launcher)

A tiny launcher with a server picker (New CP, CP Legacy, CP Journey, CP Zero + your own)
that runs each game in a fullscreen, landscape, keep-awake WebView. No dependencies.

- Desktop-UA + wide viewport by default so servers serve the full client; toggle in the ☰ menu.
- Back button opens a menu instead of dropping you out of the game.
- Cookies/DOM storage persist, so you stay logged in.
- Server URLs live in `Servers.kt` (they change; verify them) or add your own in-app (long-press to remove).

Build: `gradle assembleDebug` (needs Android SDK, `ANDROID_HOME`), or let the GitHub Action produce the APK.
Not affiliated with Disney or any private server.
