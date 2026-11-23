package com.kestrel.maether.block;

import com.kestrel.maether.item.AetherBlockItem;
import eu.pb4.polymer.blocks.api.BlockModelType;
import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import net.minecraft.world.item.Item;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.block.SoundType;
import net.minecraft.world.level.block.state.BlockBehaviour;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.function.Function;

public final class AetherBlocks {
	public static final String NS = "aether";
	public static final Map<String, Block> ALL = new LinkedHashMap<>();
	public static Block PORTAL;

	private AetherBlocks() {}

	private static Identifier id(String name) { return Identifier.fromNamespaceAndPath(NS, name); }

	private static BlockBehaviour.Properties base(String mat, float h) {
		var p = BlockBehaviour.Properties.of();
		return switch (mat) {
			case "stone" -> p.strength(h, 6.0F).requiresCorrectToolForDrops().sound(SoundType.STONE);
			case "obsidian" -> p.strength(h, 1200.0F).requiresCorrectToolForDrops().sound(SoundType.STONE);
			case "dirt" -> p.strength(h).sound(SoundType.GRAVEL);
			case "grass" -> p.strength(h).sound(SoundType.GRASS);
			case "sand" -> p.strength(h).sound(SoundType.SAND);
			case "wood" -> p.strength(h, 3.0F).sound(SoundType.WOOD).ignitedByLava();
			case "cloud" -> p.strength(h).sound(SoundType.WOOL);
			case "glass" -> p.strength(h).sound(SoundType.GLASS).noOcclusion();
			case "ice" -> p.strength(h).sound(SoundType.GLASS).friction(0.98F).noOcclusion();
			case "leaves" -> p.strength(h).sound(SoundType.GRASS).noOcclusion();
			default -> throw new IllegalArgumentException(mat);
		};
	}

	public static void init() {
		PORTAL = Registry.register(BuiltInRegistries.BLOCK, id("aether_portal"), new com.kestrel.maether.portal.AetherPortalBlock(
			BlockBehaviour.Properties.of().noCollision().strength(-1.0F).sound(SoundType.GLASS).lightLevel(s -> 11).noLootTable()
				.setId(ResourceKey.create(Registries.BLOCK, id("aether_portal")))));
		try (var in = AetherBlocks.class.getResourceAsStream("/maether/blocks.txt");
			 var r = new java.io.BufferedReader(new java.io.InputStreamReader(in))) {
			String line;
			while ((line = r.readLine()) != null) {
				line = line.trim();
				if (line.isEmpty() || line.startsWith("#")) continue;
				String[] t = line.split("\\s+");
				register(t[0], t[1], t[2], Float.parseFloat(t[3]), java.util.Set.of(java.util.Arrays.copyOfRange(t, 4, t.length)));
			}
		} catch (java.io.IOException e) {
			throw new RuntimeException(e);
		}
	}

	private static String flag(java.util.Set<String> flags, String key, String def) {
		for (String f : flags) if (f.startsWith(key + "=")) return f.substring(key.length() + 1);
		return def;
	}

	private static void register(String name, String kind, String mat, float h, java.util.Set<String> flags) {
		var p = base(mat, h);
		if (flags.contains("unbreakable")) p = p.strength(-1.0F, 3600000.0F).noLootTable();
		String light = flag(flags, "light", null);
		if (light != null) { int l = Integer.parseInt(light); p = p.lightLevel(s -> l); }
		String fr = flag(flags, "friction", null);
		if (fr != null) p = p.friction(Float.parseFloat(fr));
		final var props = p.setId(ResourceKey.create(Registries.BLOCK, id(name)));
		Block b = switch (kind) {
			case "cube" -> new AetherBlock.Cube(props, flags.contains("trans") ? BlockModelType.LEAVES : BlockModelType.FULL_BLOCK, BlockModels.first(name));
			case "leaves" -> new AetherBlock.Cube(props, BlockModelType.LEAVES, BlockModels.first(name));
			case "machine" -> new com.kestrel.maether.machine.Machines.Block(props, com.kestrel.maether.machine.Machines.Kind.valueOf(name.toUpperCase()), BlockModels.first(name));
			case "chest" -> new TreasureChest(props, BlockModels.first(name));
			case "rising" -> new AetherBlock.Rising(props, BlockModels.first(name));
			case "axis" -> new AetherBlock.Axis(props, name);
			case "facing" -> new AetherBlock.Facing(props, name);
			case "cloud" -> new AetherBlock.Cloud(props, BlockModels.first(name), Double.parseDouble(flag(flags, "bounce", "0")));
			default -> throw new IllegalArgumentException(kind + " for " + name);
		};
		Registry.register(BuiltInRegistries.BLOCK, id(name), b);
		Item.Properties ip = new Item.Properties().setId(ResourceKey.create(Registries.ITEM, id(name))).useBlockDescriptionPrefix();
		Registry.register(BuiltInRegistries.ITEM, id(name), new AetherBlockItem(b, ip, id(name)));
		ALL.put(name, b);
	}
}
