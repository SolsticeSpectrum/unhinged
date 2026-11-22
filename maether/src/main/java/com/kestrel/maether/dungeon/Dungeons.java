package com.kestrel.maether.dungeon;

import com.mojang.serialization.Codec;
import com.mojang.serialization.MapCodec;
import com.mojang.serialization.codecs.RecordCodecBuilder;
import net.minecraft.core.BlockPos;
import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.resources.Identifier;
import net.minecraft.util.RandomSource;
import net.minecraft.world.level.ChunkPos;
import net.minecraft.world.level.StructureManager;
import net.minecraft.world.level.WorldGenLevel;
import net.minecraft.world.level.block.Blocks;
import net.minecraft.world.level.chunk.ChunkGenerator;
import net.minecraft.world.level.levelgen.Heightmap;
import net.minecraft.world.level.levelgen.structure.*;
import net.minecraft.world.level.levelgen.structure.pieces.StructurePieceSerializationContext;
import net.minecraft.world.level.levelgen.structure.pieces.StructurePieceType;
import net.minecraft.world.level.levelgen.structure.pieces.StructurePiecesBuilder;
import net.minecraft.world.level.levelgen.structure.templatesystem.BlockIgnoreProcessor;
import net.minecraft.world.level.levelgen.structure.templatesystem.StructurePlaceSettings;
import net.minecraft.world.level.levelgen.structure.templatesystem.StructureTemplateManager;

import java.util.Optional;

/**
 * Bronze / silver / gold dungeons built from upstream's room templates. The original assembly code is not portable, so
 * rooms are placed at fixed offsets and joined with carved tunnels plus a shaft up to the surface.
 */
public final class Dungeons {
	public static StructurePieceType ROOM, CARVE;
	public static net.minecraft.world.level.levelgen.structure.StructureType<DungeonStructure> TYPE;

	private Dungeons() {}

	private static StructurePlaceSettings settings() {
		return new StructurePlaceSettings().addProcessor(BlockIgnoreProcessor.STRUCTURE_BLOCK);
	}

	/** A room from a structure template. */
	public static class Room extends TemplateStructurePiece {
		public Room(StructureTemplateManager m, Identifier template, BlockPos pos) { super(ROOM, 0, m, template, template.toString(), settings(), pos); }
		public Room(StructureTemplateManager m, CompoundTag tag) { super(ROOM, tag, m, id -> settings()); }
		@Override protected void handleDataMarker(String s, BlockPos p, net.minecraft.world.level.ServerLevelAccessor l, RandomSource r, BoundingBox b) {}
	}

	/** An air box (tunnel / shaft). */
	public static class Carve extends StructurePiece {
		public Carve(BoundingBox box) { super(CARVE, 0, box); }
		public Carve(StructurePieceSerializationContext ctx, CompoundTag tag) { super(CARVE, tag); }
		@Override protected void addAdditionalSaveData(StructurePieceSerializationContext ctx, CompoundTag tag) {}
		@Override public void postProcess(WorldGenLevel level, StructureManager sm, ChunkGenerator gen, RandomSource r, BoundingBox chunk, ChunkPos cp, BlockPos pivot) {
			BoundingBox b = this.boundingBox;
			BlockPos.MutableBlockPos m = new BlockPos.MutableBlockPos();
			for (int x = Math.max(b.minX(), chunk.minX()); x <= Math.min(b.maxX(), chunk.maxX()); x++)
				for (int z = Math.max(b.minZ(), chunk.minZ()); z <= Math.min(b.maxZ(), chunk.maxZ()); z++)
					for (int y = Math.max(b.minY(), chunk.minY()); y <= Math.min(b.maxY(), chunk.maxY()); y++) {
						m.set(x, y, z);
						if (!level.getBlockState(m).is(Blocks.CHEST)) level.setBlock(m, Blocks.AIR.defaultBlockState(), 2);
					}
		}
	}

	public static class DungeonStructure extends Structure {
		public static final MapCodec<DungeonStructure> CODEC = RecordCodecBuilder.mapCodec(i -> i.group(settingsCodec(i),
			Codec.STRING.fieldOf("dungeon").forGetter(s -> s.dungeon)).apply(i, DungeonStructure::new));
		private final String dungeon;

		public DungeonStructure(StructureSettings settings, String dungeon) { super(settings); this.dungeon = dungeon; }

		private static Identifier t(String name) { return Identifier.fromNamespaceAndPath("aether", name); }

		@Override
		protected Optional<GenerationStub> findGenerationPoint(GenerationContext ctx) {
			ChunkPos cp = ctx.chunkPos();
			int x = cp.getMinBlockX() + 4, z = cp.getMinBlockZ() + 4;
			int top = ctx.chunkGenerator().getFirstOccupiedHeight(x, z, Heightmap.Types.WORLD_SURFACE_WG, ctx.heightAccessor(), ctx.randomState());
			StructureTemplateManager m = ctx.structureTemplateManager();
			return switch (dungeon) {
				case "bronze" -> top < 48 ? Optional.empty() : Optional.of(new GenerationStub(new BlockPos(x, top - 26, z), b -> bronze(b, m, new BlockPos(x, top - 26, z), top)));
				case "silver" -> top < 56 ? Optional.empty() : Optional.of(new GenerationStub(new BlockPos(x, top - 34, z), b -> silver(b, m, new BlockPos(x, top - 34, z), top)));
				case "gold" -> Optional.of(new GenerationStub(new BlockPos(x, 110, z), b -> gold(b, m, new BlockPos(x, 110, z))));
				default -> Optional.empty();
			};
		}

		private static void carve(StructurePiecesBuilder b, int x1, int y1, int z1, int x2, int y2, int z2) {
			b.addPiece(new Carve(new BoundingBox(Math.min(x1, x2), Math.min(y1, y2), Math.min(z1, z2), Math.max(x1, x2), Math.max(y1, y2), Math.max(z1, z2))));
		}

		private void bronze(StructurePiecesBuilder b, StructureTemplateManager m, BlockPos o, int top) {
			b.addPiece(new Room(m, t("bronze_dungeon/lobby"), o));                               // 12x12x12
			b.addPiece(new Room(m, t("bronze_dungeon/boss_room"), o.offset(20, -1, -2)));         // 16x14x16
			b.addPiece(new Room(m, t("bronze_dungeon/chest_room"), o.offset(0, 0, 18)));          // 12x8x12
			carve(b, o.getX() + 11, o.getY() + 1, o.getZ() + 4, o.getX() + 20, o.getY() + 4, o.getZ() + 7);   // lobby -> boss room
			carve(b, o.getX() + 4, o.getY() + 1, o.getZ() + 11, o.getX() + 7, o.getY() + 4, o.getZ() + 18);   // lobby -> chest room
			carve(b, o.getX() + 5, o.getY() + 11, o.getZ() + 5, o.getX() + 7, top + 2, o.getZ() + 7);          // shaft to the surface
		}

		private void silver(StructurePiecesBuilder b, StructureTemplateManager m, BlockPos o, int top) {
			b.addPiece(new Room(m, t("silver_dungeon/skeleton"), o));                               // 32x27x26
			b.addPiece(new Room(m, t("silver_dungeon/boss_room"), o.offset(36, 0, 0)));            // 22x17x26
			carve(b, o.getX() + 30, o.getY() + 2, o.getZ() + 10, o.getX() + 37, o.getY() + 5, o.getZ() + 13);
			carve(b, o.getX() + 15, o.getY() + 26, o.getZ() + 12, o.getX() + 17, top + 2, o.getZ() + 14);
		}

		private void gold(StructurePiecesBuilder b, StructureTemplateManager m, BlockPos o) {
			b.addPiece(new Room(m, t("gold_dungeon/island"), o));                                   // 38x43x38
			b.addPiece(new Room(m, t("gold_dungeon/boss_room"), o.offset(46, 4, 4)));              // 23x9x28
			carve(b, o.getX() + 36, o.getY() + 6, o.getZ() + 17, o.getX() + 47, o.getY() + 9, o.getZ() + 20);
		}

		@Override public StructureType<?> type() { return TYPE; }
	}

	public static void init() {
		ROOM = Registry.register(BuiltInRegistries.STRUCTURE_PIECE, Identifier.fromNamespaceAndPath("aether", "dungeon_room"), (StructurePieceType.StructureTemplateType) Room::new);
		CARVE = Registry.register(BuiltInRegistries.STRUCTURE_PIECE, Identifier.fromNamespaceAndPath("aether", "dungeon_carve"), (StructurePieceType.ContextlessType) tag -> new Carve(null, tag));
		TYPE = Registry.register(BuiltInRegistries.STRUCTURE_TYPE, Identifier.fromNamespaceAndPath("aether", "dungeon"), () -> DungeonStructure.CODEC);
	}
}
