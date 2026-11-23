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

	public static void init() {
		dart("golden_dart"); dart("poison_dart"); dart("enchanted_dart");
		shooter("golden_dart_shooter", "golden_dart", 2.0F, null);
		shooter("poison_dart_shooter", "poison_dart", 2.0F, new MobEffectInstance(MobEffects.POISON, 100, 0));
		shooter("enchanted_dart_shooter", "enchanted_dart", 5.0F, new MobEffectInstance(MobEffects.SLOWNESS, 60, 1));
		Identifier bow = Identifier.fromNamespaceAndPath("aether", "phoenix_bow");
		AetherItems.put("phoenix_bow", new PolyBow(new Item.Properties().durability(500).setId(net.minecraft.resources.ResourceKey.create(net.minecraft.core.registries.Registries.ITEM, bow)), bow));
		buckets();

		UseBlockCallback.EVENT.register((player, level, hand, hit) -> {
			ItemStack held = player.getItemInHand(hand);
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
