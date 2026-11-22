package com.kestrel.maether.item;

import eu.pb4.polymer.core.api.item.PolymerItem;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.core.HolderLookup;
import net.minecraft.resources.Identifier;
import net.minecraft.world.InteractionHand;
import net.minecraft.world.InteractionResult;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.Level;

/** Generic Polymer item: vanilla base item + pack item_model, with optional use / hit hooks. */
public class PolyItem extends Item implements PolymerItem {
	public interface Use { InteractionResult use(Level level, Player player, InteractionHand hand, ItemStack stack); }
	public interface Hit { void hit(ItemStack stack, LivingEntity target, LivingEntity attacker); }

	private final Item base;
	private final Identifier model;
	private final Use use;
	private final Hit hit;

	public PolyItem(Properties p, Item base, Identifier model, Use use, Hit hit) {
		super(p);
		this.base = base; this.model = model; this.use = use; this.hit = hit;
	}

	@Override public Item getPolymerItem(ItemStack stack, PacketContext ctx) { return base; }
	@Override public Identifier getPolymerItemModel(ItemStack stack, PacketContext ctx, HolderLookup.Provider lookup) { return model; }

	@Override
	public InteractionResult use(Level level, Player player, InteractionHand hand) {
		if (use != null && !level.isClientSide()) {
			InteractionResult r = use.use(level, player, hand, player.getItemInHand(hand));
			if (r != InteractionResult.PASS) return r;
		}
		return super.use(level, player, hand);
	}

	@Override
	public void hurtEnemy(ItemStack stack, LivingEntity target, LivingEntity attacker) {
		super.hurtEnemy(stack, target, attacker);
		if (hit != null) hit.hit(stack, target, attacker);
	}
}
