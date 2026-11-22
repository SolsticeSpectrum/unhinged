package com.kestrel.maether.item;

import eu.pb4.polymer.core.api.item.PolymerItem;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.core.HolderLookup;
import net.minecraft.resources.Identifier;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.item.SpawnEggItem;

/** Spawn egg for an Aether mob; vanilla clients see a vanilla egg re-modelled by the pack (tints come from the item definition). */
public class PolySpawnEgg extends SpawnEggItem implements PolymerItem {
	private final Identifier model;
	public PolySpawnEgg(Properties p, Identifier model) { super(p); this.model = model; }
	@Override public Item getPolymerItem(ItemStack stack, PacketContext ctx) { return Items.PIG_SPAWN_EGG; }
	@Override public Identifier getPolymerItemModel(ItemStack stack, PacketContext ctx, HolderLookup.Provider lookup) { return model; }
}
