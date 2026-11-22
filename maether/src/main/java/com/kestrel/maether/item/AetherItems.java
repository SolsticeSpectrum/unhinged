package com.kestrel.maether.item;

import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import net.minecraft.sounds.SoundEvents;
import net.minecraft.tags.BlockTags;
import net.minecraft.tags.TagKey;
import net.minecraft.world.InteractionResult;
import net.minecraft.world.effect.MobEffectInstance;
import net.minecraft.world.effect.MobEffects;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.EntityTypes;
import net.minecraft.world.entity.EquipmentSlot;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.animal.pig.Pig;
import net.minecraft.world.food.FoodProperties;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.item.ToolMaterial;
import net.minecraft.world.item.equipment.ArmorMaterial;
import net.minecraft.world.item.equipment.ArmorType;
import net.minecraft.world.item.equipment.EquipmentAssets;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.phys.Vec3;

import java.util.EnumMap;
import java.util.LinkedHashMap;
import java.util.Map;

public final class AetherItems {
	public static final Map<String, Item> ALL = new LinkedHashMap<>();

	private AetherItems() {}

	static Identifier id(String n) { return Identifier.fromNamespaceAndPath("aether", n); }

	static Item.Properties props(String name) { return new Item.Properties().setId(ResourceKey.create(Registries.ITEM, id(name))); }

	/** registers any item that is already built; also used by Accessories etc. */
	public static <T extends Item> T put(String name, T item) {
		ALL.put(name, Registry.register(BuiltInRegistries.ITEM, id(name), item));
		return item;
	}

	static void plain(String name) { put(name, new PolyItem(props(name), Items.PAPER, id(name), null, null)); }

	static void item(String name, Item base, Item.Properties p, PolyItem.Use use, PolyItem.Hit hit) {
		put(name, new PolyItem(p.setId(ResourceKey.create(Registries.ITEM, id(name))), base, id(name), use, hit));
	}

	// ---- tools ----
	private static TagKey<Item> materials(String tier) { return TagKey.create(Registries.ITEM, id(tier + "_tool_materials")); }

	private static void tools(String tier, TagKey<Block> incorrect, int durability, float speed, float bonus, int enchant) {
		ToolMaterial m = new ToolMaterial(incorrect, durability, speed, bonus, enchant, materials(tier));
		item(tier + "_pickaxe", Items.IRON_PICKAXE, new Item.Properties().pickaxe(m, 1.0F, -2.8F), null, null);
		item(tier + "_axe", Items.IRON_AXE, new Item.Properties().axe(m, 6.0F, -3.1F), null, null);
		item(tier + "_shovel", Items.IRON_SHOVEL, new Item.Properties().shovel(m, 1.5F, -3.0F), null, null);
		item(tier + "_sword", Items.IRON_SWORD, new Item.Properties().sword(m, 3.0F, -2.4F), null, null);
		item(tier + "_hoe", Items.IRON_HOE, new Item.Properties().hoe(m, -2.0F, -1.0F), null, null);
	}

	private static ArmorMaterial armorMat(String set, int dur, int boots, int legs, int chest, int helm, float tough, float kb, int ench) {
		Map<ArmorType, Integer> d = new EnumMap<>(ArmorType.class);
		d.put(ArmorType.BOOTS, boots); d.put(ArmorType.LEGGINGS, legs); d.put(ArmorType.CHESTPLATE, chest); d.put(ArmorType.HELMET, helm);
		return new ArmorMaterial(dur, d, ench, SoundEvents.ARMOR_EQUIP_IRON, tough, kb, materials(set),
			ResourceKey.create(EquipmentAssets.ROOT_ID, id(set)));
	}

	private static void armor(String set, ArmorMaterial m, boolean onlyBoots) {
		if (!onlyBoots) {
			item(set + "_helmet", Items.IRON_HELMET, new Item.Properties().humanoidArmor(m, ArmorType.HELMET), null, null);
			item(set + "_chestplate", Items.IRON_CHESTPLATE, new Item.Properties().humanoidArmor(m, ArmorType.CHESTPLATE), null, null);
			item(set + "_leggings", Items.IRON_LEGGINGS, new Item.Properties().humanoidArmor(m, ArmorType.LEGGINGS), null, null);
		}
		item(set + "_boots", Items.IRON_BOOTS, new Item.Properties().humanoidArmor(m, ArmorType.BOOTS), null, null);
	}

	/** one spawn egg per registered Aether mob (call after the entities exist) */
	public static void eggs() {
		for (var e : com.kestrel.maether.entity.AetherEntities.ALL.entrySet()) {
			String name = e.getKey() + "_spawn_egg";
			put(name, new PolySpawnEgg(new Item.Properties().spawnEgg(e.getValue()).setId(ResourceKey.create(Registries.ITEM, id(name))), id(name)));
		}
		for (String m : new String[]{"blue_moa_egg", "white_moa_egg", "black_moa_egg"})
			put(m, new PolySpawnEgg(new Item.Properties().spawnEgg(com.kestrel.maether.entity.AetherEntities.ALL.get("moa")).setId(ResourceKey.create(Registries.ITEM, id(m))), id(m)));
	}

	private static void heal(LivingEntity e, float amount) { e.heal(amount); }

	public static void init() {
		// plain materials / misc
		for (String n : new String[]{"zanite_gemstone", "skyroot_stick", "golden_amber", "swet_ball", "aechor_petal",
			"victory_medal", "bronze_dungeon_key", "silver_dungeon_key", "gold_dungeon_key", "book_of_lore", "life_shard", "nature_staff", "cloud_staff"}) plain(n);

		// ---- tools by tier
		tools("skyroot", BlockTags.INCORRECT_FOR_WOODEN_TOOL, 59, 2.0F, 0.0F, 15);
		tools("holystone", BlockTags.INCORRECT_FOR_STONE_TOOL, 131, 4.0F, 1.0F, 5);
		tools("zanite", BlockTags.INCORRECT_FOR_IRON_TOOL, 250, 6.0F, 2.0F, 14);
		tools("gravitite", BlockTags.INCORRECT_FOR_DIAMOND_TOOL, 1561, 8.0F, 3.0F, 10);
		ToolMaterial valk = new ToolMaterial(BlockTags.INCORRECT_FOR_DIAMOND_TOOL, 500, 8.0F, 3.0F, 10, materials("valkyrie"));
		item("valkyrie_pickaxe", Items.DIAMOND_PICKAXE, new Item.Properties().pickaxe(valk, 1.0F, -2.8F), null, null);
		item("valkyrie_axe", Items.DIAMOND_AXE, new Item.Properties().axe(valk, 6.0F, -3.1F), null, null);
		item("valkyrie_shovel", Items.DIAMOND_SHOVEL, new Item.Properties().shovel(valk, 1.5F, -3.0F), null, null);
		item("valkyrie_hoe", Items.DIAMOND_HOE, new Item.Properties().hoe(valk, -2.0F, -1.0F), null, null);
		item("valkyrie_lance", Items.DIAMOND_SWORD, new Item.Properties().sword(valk, 5.0F, -2.6F), null, null);

		// ---- special weapons (hit effects)
		ToolMaterial special = new ToolMaterial(BlockTags.INCORRECT_FOR_DIAMOND_TOOL, 500, 6.0F, 4.0F, 10, materials("gravitite"));
		item("flaming_sword", Items.DIAMOND_SWORD, new Item.Properties().sword(special, 3.0F, -2.4F), null, (s, t, a) -> t.igniteForSeconds(8));
		item("lightning_sword", Items.DIAMOND_SWORD, new Item.Properties().sword(special, 3.0F, -2.4F), null, (s, t, a) -> {
			if (t.level() instanceof net.minecraft.server.level.ServerLevel sl) {
				var bolt = EntityTypes.LIGHTNING_BOLT.create(sl, net.minecraft.world.entity.EntitySpawnReason.TRIGGERED);
				if (bolt != null) { bolt.snapTo(Vec3.atBottomCenterOf(t.blockPosition())); sl.addFreshEntity(bolt); }
			}
		});
		item("holy_sword", Items.DIAMOND_SWORD, new Item.Properties().sword(special, 3.0F, -2.4F), null, (s, t, a) -> {
			if (t.is(net.minecraft.tags.EntityTypeTags.UNDEAD) && t.level() instanceof net.minecraft.server.level.ServerLevel sl)
				t.hurtServer(sl, a.damageSources().magic(), 6.0F);
		});
		item("vampire_blade", Items.DIAMOND_SWORD, new Item.Properties().sword(special, 3.0F, -2.4F), null, (s, t, a) -> heal(a, 1.0F));
		item("pig_slayer", Items.DIAMOND_SWORD, new Item.Properties().sword(special, 3.0F, -2.4F), null, (s, t, a) -> {
			if ((t instanceof Pig || t.getType() == EntityTypes.PIGLIN || t.getType() == EntityTypes.ZOMBIFIED_PIGLIN || t.getType() == EntityTypes.HOGLIN) && t.level() instanceof net.minecraft.server.level.ServerLevel sl)
				t.hurtServer(sl, a.damageSources().magic(), 20.0F);
		});
		item("candy_cane_sword", Items.IRON_SWORD, new Item.Properties().sword(special, 2.0F, -2.4F), null, null);
		item("hammer_of_kingbdogz", Items.IRON_AXE, new Item.Properties().axe(special, 8.0F, -3.4F), null, (s, t, a) -> {
			Vec3 d = t.position().subtract(a.position()).normalize();
			t.push(d.x * 1.5, 0.9, d.z * 1.5); t.needsSync = true;
		});
		item("lightning_knife", Items.SNOWBALL, new Item.Properties().stacksTo(16), (level, p, hand, stack) -> {
			var hit = p.pick(40.0, 1.0F, false);
			if (level instanceof net.minecraft.server.level.ServerLevel sl && hit instanceof net.minecraft.world.phys.BlockHitResult b) {
				var bolt = EntityTypes.LIGHTNING_BOLT.create(sl, net.minecraft.world.entity.EntitySpawnReason.TRIGGERED);
				if (bolt != null) { bolt.snapTo(Vec3.atBottomCenterOf(b.getBlockPos().above())); sl.addFreshEntity(bolt); }
				if (!p.isCreative()) stack.shrink(1);
				p.getCooldowns().addCooldown(stack, 20);
				return InteractionResult.SUCCESS;
			}
			return InteractionResult.PASS;
		}, null);

		// ---- armor
		armor("zanite", armorMat("zanite", 29, 2, 5, 6, 2, 0.0F, 0.0F, 9), false);
		armor("gravitite", armorMat("gravitite", 33, 3, 6, 8, 3, 1.0F, 0.0F, 10), false);
		armor("valkyrie", armorMat("valkyrie", 37, 3, 6, 8, 3, 2.0F, 0.0F, 10), false);
		armor("neptune", armorMat("neptune", 15, 2, 5, 6, 2, 0.0F, 0.0F, 12), false);
		armor("phoenix", armorMat("phoenix", 33, 3, 6, 8, 3, 1.0F, 0.0F, 10), false);
		armor("obsidian", armorMat("obsidian", 66, 3, 6, 8, 3, 3.0F, 0.1F, 10), false);
		armor("sentry", armorMat("sentry", 15, 2, 5, 6, 2, 0.0F, 0.0F, 9), true);

		// ---- food / healing
		item("blue_berry", Items.SWEET_BERRIES, new Item.Properties().food(new FoodProperties(2, 0.3F, false)), null, null);
		item("enchanted_berry", Items.GOLDEN_APPLE, new Item.Properties().food(new FoodProperties(6, 0.8F, true)), null, null);
		item("white_apple", Items.APPLE, new Item.Properties().food(new FoodProperties(4, 0.3F, true)), null, null);
		item("blue_gummy_swet", Items.APPLE, new Item.Properties().food(new FoodProperties(8, 1.0F, true)), null, null);
		item("golden_gummy_swet", Items.GOLDEN_APPLE, new Item.Properties().food(new FoodProperties(10, 1.0F, true)), null, null);
		item("candy_cane", Items.APPLE, new Item.Properties().food(new FoodProperties(3, 0.2F, false)), null, null);
		item("gingerbread_man", Items.COOKIE, new Item.Properties().food(new FoodProperties(5, 0.4F, false)), null, null);
		item("ambrosium_shard", Items.PAPER, new Item.Properties(), (level, p, hand, stack) -> {
			if (p.getHealth() >= p.getMaxHealth()) return InteractionResult.PASS;
			p.heal(4.0F); if (!p.isCreative()) stack.shrink(1); return InteractionResult.SUCCESS;
		}, null);
		item("healing_stone", Items.PAPER, new Item.Properties().stacksTo(1), (level, p, hand, stack) -> {
			if (p.getHealth() >= p.getMaxHealth() || p.getCooldowns().isOnCooldown(stack)) return InteractionResult.PASS;
			p.heal(10.0F); p.getCooldowns().addCooldown(stack, 1200); return InteractionResult.SUCCESS;
		}, null);

		// ---- parachutes
		item("cold_parachute", Items.FEATHER, new Item.Properties().stacksTo(1).durability(1), (level, p, hand, stack) -> {
			p.addEffect(new MobEffectInstance(MobEffects.SLOW_FALLING, 400, 0)); stack.hurtAndBreak(1, p, EquipmentSlot.MAINHAND); return InteractionResult.SUCCESS;
		}, null);
		item("golden_parachute", Items.FEATHER, new Item.Properties().stacksTo(1).durability(20), (level, p, hand, stack) -> {
			p.addEffect(new MobEffectInstance(MobEffects.SLOW_FALLING, 400, 0)); stack.hurtAndBreak(1, p, EquipmentSlot.MAINHAND); return InteractionResult.SUCCESS;
		}, null);
	}
}
