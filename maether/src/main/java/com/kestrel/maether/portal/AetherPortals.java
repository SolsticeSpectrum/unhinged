package com.kestrel.maether.portal;

import com.kestrel.maether.block.AetherBlocks;
import net.minecraft.core.BlockPos;
import net.minecraft.core.Direction;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.block.Blocks;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.levelgen.Heightmap;
import net.minecraft.world.level.portal.TeleportTransition;
import net.minecraft.world.phys.Vec3;

import java.util.Optional;

/** Frame detection, lighting and cross-dimension destination logic for the Aether portal. */
public final class AetherPortals {
	public static final ResourceKey<Level> AETHER = ResourceKey.create(Registries.DIMENSION, Identifier.fromNamespaceAndPath("aether", "the_aether"));
	private static final int MAX = 21, SEARCH = 8;

	private AetherPortals() {}

	private static boolean isFrame(BlockState s) { return s.is(Blocks.GLOWSTONE); }
	private static boolean isEmpty(BlockState s) { return s.isAir() || s.is(Blocks.FIRE) || s.is(Blocks.WATER); }

	private static Block portal() { return AetherBlocks.PORTAL; }

	/** Tries to light a portal with {@code inside} being an interior position. */
	public static boolean tryLight(Level level, BlockPos inside) {
		for (Direction.Axis axis : new Direction.Axis[]{Direction.Axis.X, Direction.Axis.Z}) {
			if (lightAxis(level, inside, axis)) return true;
		}
		return false;
	}

	private static boolean lightAxis(Level level, BlockPos inside, Direction.Axis axis) {
		if (!isEmpty(level.getBlockState(inside))) return false;
		Direction right = Direction.get(Direction.AxisDirection.POSITIVE, axis);
		Direction left = right.getOpposite();
		// find the bottom row: go down through empty blocks until the glowstone floor
		BlockPos bottom = inside;
		int n = 0;
		while (isEmpty(level.getBlockState(bottom.below())) && n++ < MAX) bottom = bottom.below();
		if (!isFrame(level.getBlockState(bottom.below()))) return false;
		// width: extend left/right until frame
		int wl = 0, wr = 0;
		BlockPos p = bottom;
		while (isEmpty(level.getBlockState(p.relative(left))) && wl < MAX) { p = p.relative(left); wl++; }
		if (!isFrame(level.getBlockState(p.relative(left)))) return false;
		BlockPos start = p;
		int width = 1;
		BlockPos q = start;
		while (isEmpty(level.getBlockState(q.relative(right))) && width < MAX) { q = q.relative(right); width++; }
		if (!isFrame(level.getBlockState(q.relative(right)))) return false;
		if (width < 2) return false;
		// height
		int height = 0;
		while (height < MAX) {
			boolean rowOk = true, rowTop = true;
			BlockPos row = start.above(height);
			for (int i = 0; i < width; i++) {
				BlockPos c = row.relative(right, i);
				if (!isEmpty(level.getBlockState(c))) rowOk = false;
				if (!isFrame(level.getBlockState(c))) rowTop = false;
			}
			if (!rowOk) break;
			// sides must be frame
			if (!isFrame(level.getBlockState(row.relative(left))) || !isFrame(level.getBlockState(row.relative(right, width)))) return false;
			height++;
		}
		if (height < 3) return false;
		// top row must be frame
		for (int i = 0; i < width; i++) if (!isFrame(level.getBlockState(start.above(height).relative(right, i)))) return false;
		// bottom row frame
		for (int i = 0; i < width; i++) if (!isFrame(level.getBlockState(start.below().relative(right, i)))) return false;
		BlockState ps = portal().defaultBlockState().setValue(AetherPortalBlock.AXIS, axis);
		for (int h = 0; h < height; h++)
			for (int i = 0; i < width; i++)
				level.setBlock(start.above(h).relative(right, i), ps, 18);
		return true;
	}

	public static TeleportTransition destination(ServerLevel from, Entity entity, BlockPos pos) {
		ResourceKey<Level> targetKey = from.dimension() == AETHER ? Level.OVERWORLD : AETHER;
		ServerLevel dest = from.getServer().getLevel(targetKey);
		if (dest == null) return null;
		int x = entity.getBlockX(), z = entity.getBlockZ();
		BlockPos found = findPortal(dest, x, z);
		if (found == null) found = createPortal(dest, x, z);
		Direction.Axis axis = dest.getBlockState(found).getValue(AetherPortalBlock.AXIS);
		// stand in front of the portal, on the Z-side for X-axis portals and vice versa
		Direction out = axis == Direction.Axis.X ? Direction.SOUTH : Direction.EAST;
		Vec3 target = Vec3.atBottomCenterOf(found.relative(out));
		float yaw = out.getOpposite().toYRot();
		return new TeleportTransition(dest, target, Vec3.ZERO, yaw, 0.0F, TeleportTransition.PLACE_PORTAL_TICKET);
	}

	private static BlockPos findPortal(ServerLevel level, int cx, int cz) {
		BlockPos best = null; double bestD = Double.MAX_VALUE;
		BlockPos.MutableBlockPos m = new BlockPos.MutableBlockPos();
		for (int dx = -SEARCH; dx <= SEARCH; dx++) for (int dz = -SEARCH; dz <= SEARCH; dz++) {
			if (!level.hasChunkAt(m.set(cx + dx, 64, cz + dz))) continue;
			for (int y = level.getMaxY(); y >= level.getMinY(); y--) {
				m.set(cx + dx, y, cz + dz);
				if (level.getBlockState(m).is(portal())) {
					double d = dx * dx + dz * dz + (y - 64) * 0.01;
					if (d < bestD) { bestD = d; best = m.immutable(); }
				}
			}
		}
		return best;
	}

	/** Builds a small platform + glowstone frame + lit portal on the destination, returns the lowest portal block. */
	private static BlockPos createPortal(ServerLevel level, int x, int z) {
		level.getChunk(x >> 4, z >> 4); // make sure it is generated
		int surface = level.getHeight(Heightmap.Types.MOTION_BLOCKING_NO_LEAVES, x, z);
		int y = surface <= level.getMinY() + 1 ? Math.min(level.getMaxY() - 12, 72) : surface;
		boolean aether = level.dimension() == AETHER;
		BlockState floor = aether ? AetherBlocks.ALL.get("aether_grass_block").defaultBlockState() : Blocks.GRASS_BLOCK.defaultBlockState();
		BlockState sub = aether ? AetherBlocks.ALL.get("holystone").defaultBlockState() : Blocks.STONE.defaultBlockState();
		// platform 7x7 centred, clear 7x7x6 above
		for (int dx = -3; dx <= 3; dx++) for (int dz = -3; dz <= 3; dz++) {
			level.setBlock(new BlockPos(x + dx, y - 1, z + dz), floor, 18);
			level.setBlock(new BlockPos(x + dx, y - 2, z + dz), sub, 18);
			for (int dy = 0; dy < 6; dy++) level.setBlock(new BlockPos(x + dx, y + dy, z + dz), Blocks.AIR.defaultBlockState(), 18);
		}
		// frame on X axis: interior x..x+1, y..y+2
		BlockState frame = Blocks.GLOWSTONE.defaultBlockState();
		BlockState ps = portal().defaultBlockState().setValue(AetherPortalBlock.AXIS, Direction.Axis.X);
		for (int dx = -1; dx <= 2; dx++) for (int dy = -1; dy <= 3; dy++) {
			boolean edge = dx == -1 || dx == 2 || dy == -1 || dy == 3;
			level.setBlock(new BlockPos(x + dx, y + dy, z), edge ? frame : ps, 18);
		}
		return new BlockPos(x, y, z);
	}
}
