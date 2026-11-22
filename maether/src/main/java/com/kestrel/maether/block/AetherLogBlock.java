package com.kestrel.maether.block;

import eu.pb4.polymer.blocks.api.BlockModelType;
import eu.pb4.polymer.blocks.api.PolymerBlockModel;
import eu.pb4.polymer.blocks.api.PolymerBlockResourceUtils;
import eu.pb4.polymer.core.api.block.PolymerBlock;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.resources.Identifier;
import net.minecraft.world.level.block.RotatedPillarBlock;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.core.Direction;

public class AetherLogBlock extends RotatedPillarBlock implements PolymerBlock {
	private final BlockState x, y, z;

	/** @param upright model for axis=y; @param side model for horizontal axes (rotated as in upstream blockstates) */
	public AetherLogBlock(Properties properties, Identifier upright, Identifier side) {
		super(properties);
		this.y = PolymerBlockResourceUtils.requestBlock(BlockModelType.FULL_BLOCK, PolymerBlockModel.of(upright));
		this.x = PolymerBlockResourceUtils.requestBlock(BlockModelType.FULL_BLOCK, PolymerBlockModel.of(side, 90, 90));
		this.z = PolymerBlockResourceUtils.requestBlock(BlockModelType.FULL_BLOCK, PolymerBlockModel.of(side, 90, 0));
	}

	@Override
	public BlockState getPolymerBlockState(BlockState state, PacketContext context) {
		return switch (state.getValue(AXIS)) {
			case X -> x;
			case Z -> z;
			default -> y;
		};
	}
}
