package app.unofficial.cpmobile

import android.app.Activity
import android.app.AlertDialog
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.text.InputType
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.*

class MainActivity : Activity() {
    private lateinit var list: LinearLayout

    override fun onCreate(b: Bundle?) {
        super.onCreate(b)
        val root = ScrollView(this).apply { setBackgroundColor(Color.parseColor("#0B2A4A")); isFillViewport = true }
        val col = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
            setPadding(dp(24), dp(20), dp(24), dp(20))
        }
        col.addView(TextView(this).apply {
            text = "🐧 Penguin Hub"; textSize = 28f; setTextColor(Color.WHITE)
            typeface = Typeface.DEFAULT_BOLD; gravity = Gravity.CENTER
        })
        col.addView(TextView(this).apply {
            text = "Unofficial launcher for community Club Penguin servers"
            textSize = 13f; setTextColor(Color.parseColor("#9FB8D6")); gravity = Gravity.CENTER
            setPadding(0, dp(4), 0, dp(16))
        })
        list = LinearLayout(this).apply { orientation = LinearLayout.VERTICAL }
        col.addView(list, LinearLayout.LayoutParams(dp(520).coerceAtMost(resources.displayMetrics.widthPixels - dp(48)), ViewGroup.LayoutParams.WRAP_CONTENT))
        col.addView(Button(this).apply {
            text = "+ Add server"; setOnClickListener { addDialog() }
        })
        col.addView(TextView(this).apply {
            text = "Not affiliated with Disney or any server. Use at your own discretion."
            textSize = 11f; setTextColor(Color.parseColor("#6E8BAE")); gravity = Gravity.CENTER
            setPadding(0, dp(16), 0, 0)
        })
        root.addView(col)
        setContentView(root)
        fill()
    }

    private fun fill() {
        list.removeAllViews()
        for (s in Store.all(this)) list.addView(card(s))
    }

    private fun card(s: Server): View {
        val v = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(18), dp(14), dp(18), dp(14))
            background = GradientDrawable().apply { setColor(s.color); cornerRadius = dp(16).toFloat() }
            isClickable = true; isFocusable = true
            setOnClickListener {
                startActivity(Intent(this@MainActivity, GameActivity::class.java)
                    .putExtra("name", s.name).putExtra("url", s.url))
            }
            if (s.custom) setOnLongClickListener {
                AlertDialog.Builder(this@MainActivity).setTitle("Remove ${s.name}?")
                    .setPositiveButton("Remove") { _, _ -> Store.removeCustom(this@MainActivity, s); fill() }
                    .setNegativeButton("Cancel", null).show(); true
            }
        }
        v.addView(TextView(this).apply { text = s.name; textSize = 20f; setTextColor(Color.WHITE); typeface = Typeface.DEFAULT_BOLD })
        v.addView(TextView(this).apply { text = s.tagline; textSize = 12f; setTextColor(Color.parseColor("#E8F1FB")) })
        v.layoutParams = LinearLayout.LayoutParams(-1, -2).apply { bottomMargin = dp(12) }
        return v
    }

    private fun addDialog() {
        val name = EditText(this).apply { hint = "Name" }
        val url = EditText(this).apply { hint = "https://…"; inputType = InputType.TYPE_TEXT_VARIATION_URI }
        val box = LinearLayout(this).apply { orientation = LinearLayout.VERTICAL; setPadding(dp(20), dp(8), dp(20), 0); addView(name); addView(url) }
        AlertDialog.Builder(this).setTitle("Add server").setView(box)
            .setPositiveButton("Add") { _, _ ->
                var u = url.text.toString().trim()
                if (u.isEmpty()) return@setPositiveButton
                if (!u.startsWith("http")) u = "https://$u"
                Store.addCustom(this, name.text.toString().ifBlank { u }, u); fill()
            }.setNegativeButton("Cancel", null).show()
    }

    private fun dp(n: Int) = (n * resources.displayMetrics.density).toInt()
}
