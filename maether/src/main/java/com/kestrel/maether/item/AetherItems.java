package com.kestrel.maether.item;

import eu.pb4.polymer.core.api.item.PolymerItem;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.core.HolderLookup;
import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.item.ToolMaterial;
import net.minecraft.tags.BlockTags;
import net.minecraft.tags.TagKey;
import net.minecraft.world.level.block.Block;

import java.util.LinkedHashMap;
import java.util.Map;

public final class AetherItems {
	public static final Map<String, Item> ALL = new LinkedHashMap<>();

	private AetherItems() {}

	/** Plain item: vanilla base item + item_model from our pack. */
	private static class Plain extends Item implements PolymerItem {
		private final Identifier model;
		Plain(Properties p, Identifier model) { super(p); this.model = model; }
		@Override public Item getPolymerItem(ItemStack stack, PacketContext ctx) { return Items.PAPER; }
		@Override public Identifier getPolymerItemModel(ItemStack stack, PacketContext ctx, HolderLookup.Provider lookup) { return model; }
	}

	private static void plain(String name) {
		Identifier id = Identifier.fromNamespaceAndPath("aether", name);
		Item.Properties p = new Item.Properties().setId(ResourceKey.create(Registries.ITEM, id));
		ALL.put(name, Registry.register(BuiltInRegistries.ITEM, id, new Plain(p, id)));
	}

	/** Tool/weapon: server keeps the real tool components, vanilla clients see an iron tool with an Aether item_model. */
	private static class Tool extends Item implements PolymerItem {
		private final Item base; private final Identifier model;
		Tool(Properties p, Item base, Identifier model) { super(p); this.base = base; this.model = model; }
		@Override public Item getPolymerItem(ItemStack stack, PacketContext ctx) { return base; }
		@Override public Identifier getPolymerItemModel(ItemStack stack, PacketContext ctx, HolderLookup.Provider lookup) { return model; }
	}

	private static TagKey<Item> materials(String tier) {
		return TagKey.create(Registries.ITEM, Identifier.fromNamespaceAndPath("aether", tier + "_tool_materials"));
	}

	// durability, speed, attack bonus, enchantability: approximated from upstream Aether tiers
	private static void tools(String tier, TagKey<Block> incorrect, int durability, float speed, float bonus, int enchant) {
		ToolMaterial m = new ToolMaterial(incorrect, durability, speed, bonus, enchant, materials(tier));
		tool(tier + "_pickaxe", Items.IRON_PICKAXE, new Item.Properties().pickaxe(m, 1.0F, -2.8F));
		tool(tier + "_axe", Items.IRON_AXE, new Item.Properties().axe(m, 6.0F, -3.1F));
		tool(tier + "_shovel", Items.IRON_SHOVEL, new Item.Properties().shovel(m, 1.5F, -3.0F));
		tool(tier + "_sword", Items.IRON_SWORD, new Item.Properties().sword(m, 3.0F, -2.4F));
		tool(tier + "_hoe", Items.IRON_HOE, new Item.Properties().hoe(m, -2.0F, -1.0F));
	}

	private static void tool(String name, Item base, Item.Properties p) {
		Identifier id = Identifier.fromNamespaceAndPath("aether", name);
		ALL.put(name, Registry.register(BuiltInRegistries.ITEM, id, new Tool(p.setId(ResourceKey.create(Registries.ITEM, id)), base, id)));
	}

	public static void init() {
		tools("skyroot", BlockTags.INCORRECT_FOR_WOODEN_TOOL, 59, 2.0F, 0.0F, 15);
		tools("holystone", BlockTags.INCORRECT_FOR_STONE_TOOL, 131, 4.0F, 1.0F, 5);
		tools("zanite", BlockTags.INCORRECT_FOR_IRON_TOOL, 250, 6.0F, 2.0F, 14);
		tools("gravitite", BlockTags.INCORRECT_FOR_DIAMOND_TOOL, 1561, 8.0F, 3.0F, 10);
		plain("ambrosium_shard");
		plain("zanite_gemstone");
		plain("skyroot_stick");
		plain("golden_amber");
	}
}
