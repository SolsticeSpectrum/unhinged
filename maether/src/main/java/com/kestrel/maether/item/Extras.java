package com.kestrel.maether.item;

import eu.pb4.polymer.core.api.item.PolymerItem;
import net.fabricmc.fabric.api.event.player.UseBlockCallback;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.core.BlockPos;
import net.minecraft.core.HolderLookup;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.resources.Identifier;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.sounds.SoundEvents;
import net.minecraft.sounds.SoundSource;
import net.minecraft.world.InteractionHand;
import net.minecraft.world.InteractionResult;
import net.minecraft.world.effect.MobEffectInstance;
import net.minecraft.world.effect.MobEffects;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.entity.projectile.arrow.Arrow;
import net.minecraft.world.item.BowItem;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.level.ClipContext;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.block.Blocks;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.phys.BlockHitResult;
import net.minecraft.world.phys.HitResult;

import java.util.Map;

/** Darts + shooters, bow, skyroot buckets, and right-click block conversions (swet ball, ambrosium). */
public final class Extras {
	private static final java.util.List<Object[]> EXPIRE = new java.util.concurrent.CopyOnWriteArrayList<>();
	private static final Map<String, String> STRIP = Map.of("skyroot_log", "stripped_skyroot_log", "skyroot_wood", "stripped_skyroot_wood");

	private Extras() {}

	private static Item get(String n) { return AetherItems.ALL.get(n); }

	private static int count(Player p, Item it) { int c = 0; for (ItemStack s : p.getInventory()) if (s.is(it)) c += s.getCount(); return c; }

	private static void dart(String name) { AetherItems.item(name, Items.ARROW, new Item.Properties(), null, null); }

	private static void shooter(String name, String dart, float dmg, MobEffectInstance eff) {
		AetherItems.item(name, Items.CROSSBOW, new Item.Properties().stacksTo(1).durability(465), (level, p, hand, stack) -> {
			Item d = get(dart);
			if (d == null || (count(p, d) == 0 && !p.isCreative()) || !(level instanceof ServerLevel sl)) return InteractionResult.PASS;
			if (!p.isCreative()) for (ItemStack s : p.getInventory()) if (s.is(d)) { s.shrink(1); break; }
			Arrow a = new Arrow(sl, p, new ItemStack(Items.ARROW), ItemStack.EMPTY);
			a.setBaseDamage(dmg);
			if (eff != null) a.addEffect(new MobEffectInstance(eff));
			a.shootFromRotation(p, p.getXRot(), p.getYRot(), 0.0F, 2.6F, 1.0F);
			sl.addFreshEntity(a);
			sl.playSound(null, p.blockPosition(), SoundEvents.CROSSBOW_SHOOT, SoundSource.PLAYERS, 1.0F, 1.4F);
			stack.hurtAndBreak(1, p, hand == InteractionHand.MAIN_HAND ? net.minecraft.world.entity.EquipmentSlot.MAINHAND : net.minecraft.world.entity.EquipmentSlot.OFFHAND);
			p.getCooldowns().addCooldown(stack, 12);
			return InteractionResult.SUCCESS;
		}, null);
	}

	private static class PolyBow extends BowItem implements PolymerItem {
		private final Identifier model;
		PolyBow(Properties p, Identifier model) { super(p); this.model = model; }
		@Override public Item getPolymerItem(ItemStack s, PacketContext c) { return Items.BOW; }
		@Override public Identifier getPolymerItemModel(ItemStack s, PacketContext c, HolderLookup.Provider l) { return model; }
	}

	/** water or milk in a skyroot bucket; replaces vanilla bucket handling for our items */
	private static void buckets() {
		AetherItems.item("skyroot_bucket", Items.BUCKET, new Item.Properties().stacksTo(16), (level, p, hand, stack) -> {
			BlockHitResult hit = Item_pick(level, p);
			if (hit == null) return InteractionResult.PASS;
			BlockState st = level.getBlockState(hit.getBlockPos());
			if (st.is(Blocks.WATER) && st.getFluidState().isSource()) {
				level.setBlock(hit.getBlockPos(), Blocks.AIR.defaultBlockState(), 11);
				level.playSound(null, p.blockPosition(), SoundEvents.BUCKET_FILL, SoundSource.PLAYERS, 1.0F, 1.0F);
				swap(p, hand, stack, new ItemStack(get("skyroot_water_bucket")));
				return InteractionResult.SUCCESS;
			}
			return InteractionResult.PASS;
		}, null);
		AetherItems.item("skyroot_water_bucket", Items.WATER_BUCKET, new Item.Properties().stacksTo(1), (level, p, hand, stack) -> {
			BlockHitResult hit = Item_pick(level, p);
			if (hit == null) return InteractionResult.PASS;
			BlockPos pos = hit.getBlockPos().relative(hit.getDirection());
			if (!level.getBlockState(pos).canBeReplaced()) return InteractionResult.PASS;
			level.setBlock(pos, Blocks.WATER.defaultBlockState(), 11);
			level.playSound(null, p.blockPosition(), SoundEvents.BUCKET_EMPTY, SoundSource.PLAYERS, 1.0F, 1.0F);
			swap(p, hand, stack, new ItemStack(get("skyroot_bucket")));
			return InteractionResult.SUCCESS;
		}, null);
		AetherItems.item("skyroot_milk_bucket", Items.MILK_BUCKET, new Item.Properties().stacksTo(1), (level, p, hand, stack) -> {
			p.removeAllEffects();
			swap(p, hand, stack, new ItemStack(get("skyroot_bucket")));
			return InteractionResult.SUCCESS;
		}, null);
	}

	private static BlockHitResult Item_pick(Level level, Player p) {
		var from = p.getEyePosition(); var to = from.add(p.getLookAngle().scale(p.blockInteractionRange()));
		BlockHitResult r = level.clip(new ClipContext(from, to, ClipContext.Block.OUTLINE, ClipContext.Fluid.SOURCE_ONLY, p));
		return r.getType() == HitResult.Type.BLOCK ? r : null;
	}

	private static void swap(Player p, InteractionHand hand, ItemStack used, ItemStack replacement) {
		if (p.isCreative()) return;
		if (used.getCount() == 1) p.setItemInHand(hand, replacement); else { used.shrink(1); if (!p.getInventory().add(replacement)) p.spawnAtLocation((ServerLevel) p.level(), replacement); }
	}

	// swet ball turns soil into its "alive" form; ambrosium enchants aether grass
	private static final Map<String, String> SWET = Map.of("aether:aether_dirt", "aether:aether_grass_block", "minecraft:dirt", "minecraft:grass_block",
		"minecraft:grass_block", "minecraft:podzol", "minecraft:netherrack", "minecraft:crimson_nylium");

	public static net.fabricmc.fabric.api.attachment.v1.AttachmentType<Integer> LIFE;

	/** applies the permanent life-shard hearts (+2 max health each, up to 10 shards) */
	public static void applyLife(net.minecraft.server.level.ServerPlayer p) {
		int n = p.getAttachedOrElse(LIFE, 0);
		var inst = p.getAttribute(net.minecraft.world.entity.ai.attributes.Attributes.MAX_HEALTH);
		if (inst == null) return;
		Identifier mid = Identifier.fromNamespaceAndPath("aether", "life_shards");
		if (n <= 0) inst.removeModifier(mid);
		else inst.addOrReplacePermanentModifier(new net.minecraft.world.entity.ai.attributes.AttributeModifier(mid, n * 2.0, net.minecraft.world.entity.ai.attributes.AttributeModifier.Operation.ADD_VALUE));
	}

	public static void init() {
		LIFE = net.fabricmc.fabric.api.attachment.v1.AttachmentRegistry.create(Identifier.fromNamespaceAndPath("aether", "life_shards"), b -> b.persistent(com.mojang.serialization.Codec.INT).copyOnDeath());
		AetherItems.item("life_shard", Items.PAPER, new Item.Properties(), (level, p, hand, stack) -> {
			if (!(p instanceof net.minecraft.server.level.ServerPlayer sp)) return InteractionResult.PASS;
			int n = sp.getAttachedOrElse(LIFE, 0);
			if (n >= 10) return InteractionResult.PASS;
			sp.setAttached(LIFE, n + 1); applyLife(sp); sp.heal(2.0F);
			if (!sp.isCreative()) stack.shrink(1);
			return InteractionResult.SUCCESS;
		}, null);
		net.fabricmc.fabric.api.event.lifecycle.v1.ServerTickEvents.END_SERVER_TICK.register(server -> {
			if (server.getTickCount() % 40 == 0) for (var pl : server.getPlayerList().getPlayers()) applyLife(pl);
		});
		dart("golden_dart"); dart("poison_dart"); dart("enchanted_dart");
		shooter("golden_dart_shooter", "golden_dart", 2.0F, null);
		shooter("poison_dart_shooter", "poison_dart", 2.0F, new MobEffectInstance(MobEffects.POISON, 100, 0));
		shooter("enchanted_dart_shooter", "enchanted_dart", 5.0F, new MobEffectInstance(MobEffects.SLOWNESS, 60, 1));
		Identifier bow = Identifier.fromNamespaceAndPath("aether", "phoenix_bow");
		AetherItems.put("phoenix_bow", new PolyBow(new Item.Properties().durability(500).setId(net.minecraft.resources.ResourceKey.create(net.minecraft.core.registries.Registries.ITEM, bow)), bow));
		buckets();

		// cloud staff: a short-lived cloud platform under you (the original summons cloud minions you can stand on)
		AetherItems.item("cloud_staff", Items.STICK, new Item.Properties().stacksTo(1).durability(60), (level, p, hand, stack) -> {
			if (!(level instanceof ServerLevel sl)) return InteractionResult.PASS;
			Block cloud = com.kestrel.maether.block.AetherBlocks.ALL.get("cold_aercloud");
			BlockPos base = p.blockPosition().below();
			for (int dx = -1; dx <= 1; dx++) for (int dz = -1; dz <= 1; dz++) {
				BlockPos q = base.offset(dx, 0, dz);
				if (sl.getBlockState(q).isAir()) { sl.setBlock(q, cloud.defaultBlockState(), 3); EXPIRE.add(new Object[]{sl, q, sl.getServer().getTickCount() + 160}); }
			}
			stack.hurtAndBreak(1, p, hand == InteractionHand.MAIN_HAND ? net.minecraft.world.entity.EquipmentSlot.MAINHAND : net.minecraft.world.entity.EquipmentSlot.OFFHAND);
			p.getCooldowns().addCooldown(stack, 40);
			return InteractionResult.SUCCESS;
		}, null);
		AetherItems.item("nature_staff", Items.STICK, new Item.Properties().stacksTo(1).durability(100), (level, p, hand, stack) -> InteractionResult.PASS, null);
		net.fabricmc.fabric.api.event.lifecycle.v1.ServerTickEvents.END_SERVER_TICK.register(server -> {
			EXPIRE.removeIf(e -> {
				if (server.getTickCount() < (int) e[2]) return false;
				ServerLevel l = (ServerLevel) e[0]; BlockPos q = (BlockPos) e[1];
				if (l.getBlockState(q).is(com.kestrel.maether.block.AetherBlocks.ALL.get("cold_aercloud"))) l.setBlock(q, Blocks.AIR.defaultBlockState(), 3);
				return true;
			});
		});

		UseBlockCallback.EVENT.register((player, level, hand, hit) -> {
			ItemStack held = player.getItemInHand(hand);
			if (!level.isClientSide() && !held.isEmpty()) {
				BlockPos pos = hit.getBlockPos();
				String block = BuiltInRegistries.BLOCK.getKey(level.getBlockState(pos).getBlock()).getPath();
				if (held.is(net.minecraft.tags.ItemTags.AXES) && STRIP.containsKey(block)) {          // axe: strip skyroot logs/wood
					Block to = com.kestrel.maether.block.AetherBlocks.ALL.get(STRIP.get(block));
					level.setBlock(pos, to.withPropertiesOf(level.getBlockState(pos)), 11);
					level.playSound(null, pos, SoundEvents.AXE_STRIP.value(), SoundSource.BLOCKS, 1.0F, 1.0F);
					held.hurtAndBreak(1, player, hand == InteractionHand.MAIN_HAND ? net.minecraft.world.entity.EquipmentSlot.MAINHAND : net.minecraft.world.entity.EquipmentSlot.OFFHAND);
					return InteractionResult.SUCCESS;
				}
				if (held.is(net.minecraft.tags.ItemTags.SHOVELS) && (block.equals("aether_grass_block") || block.equals("enchanted_aether_grass_block")) && level.getBlockState(pos.above()).isAir()) {
					level.setBlock(pos, com.kestrel.maether.block.AetherBlocks.ALL.get("aether_dirt_path").defaultBlockState(), 11);
					level.playSound(null, pos, SoundEvents.SHOVEL_FLATTEN.value(), SoundSource.BLOCKS, 1.0F, 1.0F);
					held.hurtAndBreak(1, player, hand == InteractionHand.MAIN_HAND ? net.minecraft.world.entity.EquipmentSlot.MAINHAND : net.minecraft.world.entity.EquipmentSlot.OFFHAND);
					return InteractionResult.SUCCESS;
				}
				if (held.getItem() == AetherItems.ALL.get("nature_staff") && level instanceof ServerLevel sl
					&& net.minecraft.world.item.BoneMealItem.growCrop(new ItemStack(Items.BONE_MEAL), sl, pos)) {   // nature staff: infinite bone meal
					held.hurtAndBreak(1, player, hand == InteractionHand.MAIN_HAND ? net.minecraft.world.entity.EquipmentSlot.MAINHAND : net.minecraft.world.entity.EquipmentSlot.OFFHAND);
					return InteractionResult.SUCCESS;
				}
			}
			if (level.isClientSide() || held.isEmpty()) return InteractionResult.PASS;
			String item = BuiltInRegistries.ITEM.getKey(held.getItem()).toString();
			BlockPos pos = hit.getBlockPos();
			String block = BuiltInRegistries.BLOCK.getKey(level.getBlockState(pos).getBlock()).toString();
			String to = null;
			if (item.equals("aether:swet_ball")) to = SWET.get(block);
			else if (item.equals("aether:ambrosium_shard") && block.equals("aether:aether_grass_block")) to = "aether:enchanted_aether_grass_block";
			if (to == null) return InteractionResult.PASS;
			Block b = BuiltInRegistries.BLOCK.getOptional(Identifier.parse(to)).orElse(null);
			if (b == null) return InteractionResult.PASS;
			level.setBlock(pos, b.defaultBlockState(), 3);
			level.playSound(null, pos, SoundEvents.SLIME_BLOCK_PLACE, SoundSource.BLOCKS, 1.0F, 1.0F);
			if (!player.isCreative()) held.shrink(1);
			return InteractionResult.SUCCESS;
		});
	}
}
