package com.kestrel.maether.block;

import eu.pb4.polymer.blocks.api.BlockModelType;
import eu.pb4.polymer.blocks.api.PolymerBlockModel;
import eu.pb4.polymer.blocks.api.PolymerBlockResourceUtils;
import eu.pb4.polymer.core.api.block.PolymerBlock;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.resources.Identifier;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.block.state.BlockState;

/** Plain full-cube block shown to vanilla clients via a Polymer-managed block state + pack model. */
public class AetherBlock extends Block implements PolymerBlock {
	private final BlockState visual;

	public AetherBlock(Properties properties, BlockModelType type, Identifier model) {
		super(properties);
		this.visual = PolymerBlockResourceUtils.requestBlock(type, PolymerBlockModel.of(model));
	}

	@Override
	public BlockState getPolymerBlockState(BlockState state, PacketContext context) {
		return visual;
	}
}
