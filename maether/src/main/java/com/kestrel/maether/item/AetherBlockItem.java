package com.kestrel.maether.item;

import eu.pb4.polymer.core.api.item.PolymerItem;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.core.HolderLookup;
import net.minecraft.resources.Identifier;
import net.minecraft.world.item.BlockItem;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.level.block.Block;

/** Block item shown as a vanilla item with an item_model pointing into our resource pack. */
public class AetherBlockItem extends BlockItem implements PolymerItem {
	private final Identifier model;

	public AetherBlockItem(Block block, Properties properties, Identifier model) {
		super(block, properties);
		this.model = model;
	}

	@Override
	public Item getPolymerItem(ItemStack stack, PacketContext context) {
		return Items.STONE;
	}

	@Override
	public Identifier getPolymerItemModel(ItemStack stack, PacketContext context, HolderLookup.Provider lookup) {
		return model;
	}
}
