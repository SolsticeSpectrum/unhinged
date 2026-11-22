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

	private static BlockBehaviour.Properties props(String name, BlockBehaviour.Properties p) {
		return p.setId(ResourceKey.create(Registries.BLOCK, id(name)));
	}

	private static <B extends Block> B reg(String name, Function<BlockBehaviour.Properties, B> factory, BlockBehaviour.Properties p) {
		B block = Registry.register(BuiltInRegistries.BLOCK, id(name), factory.apply(props(name, p)));
		Item.Properties ip = new Item.Properties().setId(ResourceKey.create(Registries.ITEM, id(name))).useBlockDescriptionPrefix();
		Registry.register(BuiltInRegistries.ITEM, id(name), new AetherBlockItem(block, ip, id(name)));
		ALL.put(name, block);
		return block;
	}

	private static void cube(String name, BlockBehaviour.Properties p) {
		reg(name, bp -> new AetherBlock(bp, BlockModelType.FULL_BLOCK, id("block/" + name)), p);
	}

	private static void leaves(String name) {
		reg(name, bp -> new AetherBlock(bp, BlockModelType.LEAVES, id("block/" + name)),
			BlockBehaviour.Properties.of().strength(0.2F).sound(SoundType.GRASS).noOcclusion());
	}

	private static void log(String name) {
		reg(name, bp -> new AetherLogBlock(bp, id("block/" + name), id("block/" + name + "_horizontal")),
			BlockBehaviour.Properties.of().strength(2.0F).sound(SoundType.WOOD));
	}

	private static BlockBehaviour.Properties stone(float hardness) {
		return BlockBehaviour.Properties.of().strength(hardness, 6.0F).requiresCorrectToolForDrops().sound(SoundType.STONE);
	}

	private static BlockBehaviour.Properties soft(SoundType s) {
		return BlockBehaviour.Properties.of().strength(0.5F).sound(s);
	}

	public static void init() {
		PORTAL = Registry.register(BuiltInRegistries.BLOCK, id("aether_portal"), new com.kestrel.maether.portal.AetherPortalBlock(
			props("aether_portal", BlockBehaviour.Properties.of().noCollision().strength(-1.0F).sound(SoundType.GLASS).lightLevel(s -> 11).noLootTable())));
		cube("holystone", stone(0.5F));
		cube("mossy_holystone", stone(0.5F));
		cube("holystone_bricks", stone(1.5F));
		cube("aether_dirt", soft(SoundType.GRAVEL));
		cube("aether_grass_block", soft(SoundType.GRASS));
		cube("quicksoil", soft(SoundType.SAND));
		cube("ambrosium_ore", stone(3.0F));
		cube("zanite_ore", stone(3.0F));
		cube("gravitite_ore", stone(5.0F));
		cube("icestone", stone(3.0F));
		cube("ambrosium_block", stone(3.0F));
		cube("zanite_block", stone(3.0F));
		cube("enchanted_gravitite", stone(5.0F));
		cube("skyroot_planks", BlockBehaviour.Properties.of().strength(2.0F, 3.0F).sound(SoundType.WOOD));
		cube("carved_stone", stone(0.5F));
		cube("sentry_stone", stone(0.5F));
		cube("angelic_stone", stone(0.5F));
		cube("hellfire_stone", stone(0.5F));
		cube("light_angelic_stone", stone(0.5F));
		cube("light_hellfire_stone", stone(0.5F));
		log("skyroot_log");
		log("golden_oak_log");
		leaves("skyroot_leaves");
		leaves("golden_oak_leaves");
		leaves("crystal_leaves");
		cube("cold_aercloud", soft(SoundType.WOOL));
		cube("blue_aercloud", soft(SoundType.WOOL));
		cube("golden_aercloud", soft(SoundType.WOOL));
	}
}
