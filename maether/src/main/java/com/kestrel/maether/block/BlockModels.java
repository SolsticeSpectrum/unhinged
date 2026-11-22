package com.kestrel.maether.block;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import eu.pb4.polymer.blocks.api.PolymerBlockModel;
import net.minecraft.resources.Identifier;

import java.io.InputStreamReader;
import java.util.LinkedHashMap;
import java.util.Map;

/** Reads upstream blockstate JSON (shipped in our pack) to pick the Polymer model for each variant. */
public final class BlockModels {
	private BlockModels() {}

	/** variant key (e.g. "axis=y", "" ) -> first model of that variant */
	public static Map<String, PolymerBlockModel> variants(String blockName) {
		Map<String, PolymerBlockModel> out = new LinkedHashMap<>();
		try (var in = BlockModels.class.getResourceAsStream("/assets/aether/blockstates/" + blockName + ".json")) {
			if (in == null) throw new IllegalStateException("missing blockstate for " + blockName);
			JsonObject root = JsonParser.parseReader(new InputStreamReader(in)).getAsJsonObject();
			JsonObject variants = root.getAsJsonObject("variants");
			for (var e : variants.entrySet()) {
				JsonElement v = e.getValue();
				JsonObject o = v.isJsonArray() ? v.getAsJsonArray().get(0).getAsJsonObject() : v.getAsJsonObject();
				Identifier id = Identifier.parse(o.get("model").getAsString());
				int x = o.has("x") ? o.get("x").getAsInt() : 0, y = o.has("y") ? o.get("y").getAsInt() : 0;
				out.put(e.getKey(), PolymerBlockModel.of(id, x, y));
			}
		} catch (java.io.IOException ex) {
			throw new RuntimeException(ex);
		}
		return out;
	}

	public static PolymerBlockModel first(String blockName) {
		return variants(blockName).values().iterator().next();
	}
}
