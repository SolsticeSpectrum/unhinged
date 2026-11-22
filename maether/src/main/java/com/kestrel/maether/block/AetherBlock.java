package com.kestrel.maether.block;

import eu.pb4.polymer.blocks.api.BlockModelType;
import eu.pb4.polymer.blocks.api.PolymerBlockModel;
import eu.pb4.polymer.blocks.api.PolymerBlockResourceUtils;
import eu.pb4.polymer.core.api.block.PolymerBlock;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.core.BlockPos;
import net.minecraft.core.Direction;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.block.RotatedPillarBlock;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.block.state.StateDefinition;
import net.minecraft.world.level.block.state.properties.BlockStateProperties;
import net.minecraft.world.level.block.state.properties.EnumProperty;
import net.minecraft.world.phys.Vec3;

import java.util.Map;

/** Collection of simple Polymer block kinds used by the spec-driven registry. */
public final class AetherBlock {
	private AetherBlock() {}

	/** Full cube (or cutout cube when {@code type} is LEAVES) with one model. */
	public static class Cube extends Block implements PolymerBlock {
		private final BlockState visual;
		public Cube(Properties p, BlockModelType type, PolymerBlockModel model) {
			super(p);
			this.visual = PolymerBlockResourceUtils.requestBlock(type, model);
		}
		@Override public BlockState getPolymerBlockState(BlockState state, PacketContext ctx) { return visual; }
	}

	/** Log / wood / pillar: three axis states. */
	public static class Axis extends RotatedPillarBlock implements PolymerBlock {
		private final BlockState x, y, z;
		public Axis(Properties p, String name) {
			super(p);
			Map<String, PolymerBlockModel> v = BlockModels.variants(name);
			this.x = PolymerBlockResourceUtils.requestBlock(BlockModelType.FULL_BLOCK, v.get("axis=x"));
			this.y = PolymerBlockResourceUtils.requestBlock(BlockModelType.FULL_BLOCK, v.get("axis=y"));
			this.z = PolymerBlockResourceUtils.requestBlock(BlockModelType.FULL_BLOCK, v.get("axis=z"));
		}
		@Override public BlockState getPolymerBlockState(BlockState s, PacketContext c) {
			return switch (s.getValue(AXIS)) { case X -> x; case Z -> z; default -> y; };
		}
	}

	/** Six-way facing block (pillar tops). */
	public static class Facing extends Block implements PolymerBlock {
		public static final EnumProperty<Direction> FACING = BlockStateProperties.FACING;
		private final Map<Direction, BlockState> visuals = new java.util.EnumMap<>(Direction.class);
		public Facing(Properties p, String name) {
			super(p);
			registerDefaultState(stateDefinition.any().setValue(FACING, Direction.UP));
			var v = BlockModels.variants(name);
			for (Direction d : Direction.values())
				visuals.put(d, PolymerBlockResourceUtils.requestBlock(BlockModelType.FULL_BLOCK, v.get("facing=" + d.getName())));
		}
		@Override protected void createBlockStateDefinition(StateDefinition.Builder<Block, BlockState> b) { b.add(FACING); }
		@Override public BlockState getStateForPlacement(net.minecraft.world.item.context.BlockPlaceContext c) { return defaultBlockState().setValue(FACING, c.getClickedFace()); }
		@Override public BlockState getPolymerBlockState(BlockState s, PacketContext c) { return visuals.get(s.getValue(FACING)); }
	}

	/** Cloud blocks: soft landing and launch. bounce &lt;= 0 means plain soft landing. */
	public static class Cloud extends Cube {
		private final double bounce;
		public Cloud(Properties p, PolymerBlockModel model, double bounce) { super(p, BlockModelType.FULL_BLOCK, model); this.bounce = bounce; }
		@Override public void fallOn(Level level, BlockState state, BlockPos pos, Entity entity, double fallDistance) {
			super.fallOn(level, state, pos, entity, 0.0); // no fall damage
			if (bounce > 0 && !entity.isSuppressingBounce()) {
				double strength = bounce > 1.0 ? bounce : Math.min(bounce, 0.35 + fallDistance * 0.06);
				Vec3 v = entity.getDeltaMovement();
				entity.setDeltaMovement(v.x, strength, v.z);
				entity.needsSync = true;
			}
		}
	}
}
