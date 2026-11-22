package com.kestrel.maether.portal;

import eu.pb4.polymer.core.api.block.PolymerBlock;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.core.BlockPos;
import net.minecraft.core.Direction;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.util.RandomSource;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.LevelReader;
import net.minecraft.world.level.ScheduledTickAccess;
import net.minecraft.world.level.block.Blocks;
import net.minecraft.world.level.block.NetherPortalBlock;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.portal.TeleportTransition;

/** Aether portal: behaves like a nether portal server-side, shown to vanilla clients as a nether portal block. */
public class AetherPortalBlock extends NetherPortalBlock implements PolymerBlock {
	public AetherPortalBlock(Properties properties) {
		super(properties);
	}

	@Override
	public BlockState getPolymerBlockState(BlockState state, PacketContext context) {
		return Blocks.NETHER_PORTAL.defaultBlockState().setValue(AXIS, state.getValue(AXIS));
	}

	@Override
	protected void randomTick(BlockState state, ServerLevel level, BlockPos pos, RandomSource random) {
		// vanilla spawns zombified piglins here; the Aether portal must not
	}

	@Override
	protected BlockState updateShape(BlockState state, LevelReader level, ScheduledTickAccess ticks, BlockPos pos,
									 Direction direction, BlockPos neighborPos, BlockState neighborState, RandomSource random) {
		// vanilla checks for an obsidian frame; ours is glowstone
		Direction.Axis axis = state.getValue(AXIS);
		if (direction.getAxis() != Direction.Axis.Y && direction.getAxis() == axis) {
			boolean ok = neighborState.is(this) || neighborState.is(Blocks.GLOWSTONE);
			if (!ok) return Blocks.AIR.defaultBlockState();
		} else if (direction.getAxis() == Direction.Axis.Y) {
			boolean ok = neighborState.is(this) || neighborState.is(Blocks.GLOWSTONE);
			if (!ok) return Blocks.AIR.defaultBlockState();
		}
		return state;
	}

	@Override
	public TeleportTransition getPortalDestination(ServerLevel level, Entity entity, BlockPos pos) {
		return AetherPortals.destination(level, entity, pos);
	}
}
