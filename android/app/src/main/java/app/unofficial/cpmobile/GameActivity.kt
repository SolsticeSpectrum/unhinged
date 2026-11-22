package app.unofficial.cpmobile

import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.webkit.*
import android.widget.FrameLayout
import android.widget.ProgressBar
import android.widget.TextView
import app.unofficial.cpmobile.Store.desktopMode

class GameActivity : Activity() {
    private lateinit var web: WebView
    private lateinit var bar: ProgressBar
    private lateinit var homeUrl: String
    private lateinit var name: String
    private var host = ""

    @SuppressLint("SetJavaScriptEnabled", "ClickableViewAccessibility")
    override fun onCreate(b: Bundle?) {
        super.onCreate(b)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        homeUrl = intent.getStringExtra("url") ?: return finish()
        name = intent.getStringExtra("name") ?: "Game"
        host = Uri.parse(homeUrl).host.orEmpty().removePrefix("www.")

        val root = FrameLayout(this).apply { setBackgroundColor(Color.BLACK) }
        web = WebView(this).apply { setBackgroundColor(Color.BLACK); overScrollMode = View.OVER_SCROLL_NEVER }
        bar = ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal).apply { max = 100 }
        // Small translucent menu button, top-left, so the game keeps the whole screen.
        val menu = TextView(this).apply {
            text = "☰"; textSize = 18f; setTextColor(Color.WHITE); gravity = Gravity.CENTER
            setBackgroundColor(0x55000000); alpha = 0.6f
            setOnClickListener { showMenu() }
        }
        root.addView(web, FrameLayout.LayoutParams(-1, -1))
        root.addView(bar, FrameLayout.LayoutParams(-1, 8, Gravity.TOP))
        val sz = (40 * resources.displayMetrics.density).toInt()
        root.addView(menu, FrameLayout.LayoutParams(sz, sz, Gravity.BOTTOM or Gravity.START))
        setContentView(root)

        configure()
        if (b != null) web.restoreState(b) else web.loadUrl(homeUrl)
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun configure() {
        val s = web.settings
        s.javaScriptEnabled = true
        s.domStorageEnabled = true
        s.databaseEnabled = true
        s.mediaPlaybackRequiresUserGesture = false      // game audio
        s.mixedContentMode = WebSettings.MIXED_CONTENT_COMPATIBILITY_MODE
        s.javaScriptCanOpenWindowsAutomatically = true
        s.setSupportMultipleWindows(false)
        s.textZoom = 100
        s.setSupportZoom(false); s.builtInZoomControls = false; s.displayZoomControls = false
        s.allowFileAccess = false
        CookieManager.getInstance().apply { setAcceptCookie(true); setAcceptThirdPartyCookies(web, true) }
        applyLayoutMode()

        web.webChromeClient = object : WebChromeClient() {
            override fun onProgressChanged(v: WebView, p: Int) {
                bar.progress = p; bar.visibility = if (p >= 100) View.GONE else View.VISIBLE
            }
            // Fullscreen requests from the page: we're already fullscreen, so just acknowledge.
            override fun onShowCustomView(view: View, cb: CustomViewCallback) {}
            override fun onPermissionRequest(r: PermissionRequest) { r.deny() }
        }
        web.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(v: WebView, req: WebResourceRequest): Boolean {
                val u = req.url
                val h = u.host.orEmpty().removePrefix("www.")
                // Stay in-app for the game's own domain (and subdomains); open everything else externally.
                if (u.scheme == "http" || u.scheme == "https") {
                    if (h == host || h.endsWith(".$host") || host.endsWith(".$h") || h.endsWith(rootDomain(host))) return false
                }
                runCatching { startActivity(Intent(Intent.ACTION_VIEW, u)) }
                return true
            }
            override fun onReceivedError(v: WebView, r: WebResourceRequest, e: WebResourceError) {
                if (r.isForMainFrame) v.loadData(
                    "<body style='background:#0B2A4A;color:#fff;font-family:sans-serif;text-align:center;padding-top:15vh'>" +
                    "<h2>Can't reach $name</h2><p>${e.description}</p>" +
                    "<button style='font-size:20px;padding:10px 24px' onclick='location.href=\"$homeUrl\"'>Retry</button></body>",
                    "text/html", "utf-8")
            }
        }
    }

    private fun rootDomain(h: String) = h.split('.').takeLast(2).joinToString(".")

    private fun applyLayoutMode() {
        val s = web.settings
        if (desktopMode) {
            // Chrome-on-Linux UA: servers hand over the full desktop client instead of a broken mobile page.
            val ver = Regex("Chrome/[\\d.]+").find(WebSettings.getDefaultUserAgent(this))?.value ?: "Chrome/120.0.0.0"
            s.userAgentString = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) $ver Safari/537.36"
            s.useWideViewPort = true; s.loadWithOverviewMode = true
        } else {
            s.userAgentString = null
            s.useWideViewPort = true; s.loadWithOverviewMode = false
        }
    }

    private fun showMenu() {
        val items = arrayOf("Reload", "Layout: " + if (desktopMode) "desktop (tap for mobile)" else "mobile (tap for desktop)", "Back to game list")
        AlertDialog.Builder(this).setTitle(name).setItems(items) { _, i ->
            when (i) {
                0 -> web.reload()
                1 -> { desktopMode = !desktopMode; applyLayoutMode(); web.reload() }
                2 -> finish()
            }
        }.show()
    }

    @Deprecated("fine for minSdk 26")
    override fun onBackPressed() = showMenu()   // back shouldn't silently drop you out of a game

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) @Suppress("DEPRECATION") window.decorView.systemUiVisibility = (
            View.SYSTEM_UI_FLAG_FULLSCREEN or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
            View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY or View.SYSTEM_UI_FLAG_LAYOUT_STABLE or
            View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION)
    }

    override fun onSaveInstanceState(o: Bundle) { super.onSaveInstanceState(o); web.saveState(o) }
    override fun onPause() { web.onPause(); CookieManager.getInstance().flush(); super.onPause() }
    override fun onResume() { super.onResume(); web.onResume() }
    override fun onDestroy() { (web.parent as? ViewGroup)?.removeView(web); web.destroy(); super.onDestroy() }
}
