package app.unofficial.cpmobile

import android.content.Context
import android.graphics.Color

data class Server(
    val id: String,
    val name: String,
    val tagline: String,
    val url: String,
    val color: Int,
    val custom: Boolean = false,
)

/**
 * Built-in list. These are community-run, unofficial servers and their addresses change.
 * If one moves, edit it here, or add your own from the app ("+ Add server").
 */
val BUILT_IN = listOf(
    Server("newcp", "New Club Penguin", "newcp.net", "https://newcp.net", Color.parseColor("#2E86DE")),
    Server("legacy", "Club Penguin Legacy", "cplegacy.com", "https://cplegacy.com", Color.parseColor("#E67E22")),
    Server("journey", "Club Penguin Journey", "cpjourney.net", "https://cpjourney.net", Color.parseColor("#8E44AD")),
    Server("zero", "Club Penguin Zero", "cpzero.net", "https://www.cpzero.net", Color.parseColor("#27AE60")),
)

object Store {
    private fun p(c: Context) = c.getSharedPreferences("hub", Context.MODE_PRIVATE)

    fun customServers(c: Context): List<Server> =
        (p(c).getString("custom", "") ?: "").lines().filter { it.contains('\t') }.map {
            val (n, u) = it.split('\t', limit = 2)
            Server("custom:$u", n, u.removePrefix("https://").removePrefix("http://"), u,
                Color.parseColor("#16A085"), custom = true)
        }

    fun addCustom(c: Context, name: String, url: String) {
        val cur = p(c).getString("custom", "") ?: ""
        p(c).edit().putString("custom", (cur + "\n" + name.replace('\t', ' ') + "\t" + url).trim()).apply()
    }

    fun removeCustom(c: Context, s: Server) {
        val keep = (p(c).getString("custom", "") ?: "").lines().filter { it.isNotBlank() && !it.endsWith("\t" + s.url) }
        p(c).edit().putString("custom", keep.joinToString("\n")).apply()
    }

    var Context.desktopMode: Boolean
        get() = p(this).getBoolean("desktop", true)
        set(v) = p(this).edit().putBoolean("desktop", v).apply()

    fun all(c: Context) = BUILT_IN + customServers(c)
}
