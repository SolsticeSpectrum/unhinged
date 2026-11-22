package com.kestrel.maether.family;

import com.kestrel.maether.item.AetherBlockItem;
import eu.pb4.factorytools.api.block.FactoryBlock;
import eu.pb4.factorytools.api.block.model.generic.BSMMParticleBlock;
import eu.pb4.factorytools.api.block.model.generic.BlockStateModelManager;
import eu.pb4.polymer.blocks.api.PolymerTexturedBlock;
import eu.pb4.polymer.virtualentity.api.ElementHolder;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.core.BlockPos;
import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.InteractionHand;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.block.*;
import net.minecraft.world.level.block.grower.TreeGrower;
import net.minecraft.world.level.block.state.BlockBehaviour;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.block.state.properties.BlockSetType;
import net.minecraft.world.level.block.state.properties.WoodType;
import net.minecraft.world.phys.BlockHitResult;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.LinkedHashMap;
import java.util.Map;

/** Reads maether/families.txt and registers stairs/slabs/walls/... as hitbox-block + display-model blocks. */
public final class FamilyBlocks {
	public static final Map<String, Block> ALL = new LinkedHashMap<>();

	private FamilyBlocks() {}

	/** Marker mixed into every family block: client sees {@code client} (state-copied), models come from blockstate assets. */
	public interface Visual extends FactoryBlock, PolymerTexturedBlock, BSMMParticleBlock {
		Block clientBlock();
		float range();

		@Override default BlockState getPolymerBlockState(BlockState state, PacketContext ctx) { return clientBlock().withPropertiesOf(state); }
		@Override default ElementHolder createElementHolder(ServerLevel w, BlockPos p, BlockState s) { return new FamilyModel(range()); }
		@Override default boolean isIgnoringBlockInteractionPlaySoundExceptedEntity(BlockState s, ServerPlayer pl, InteractionHand h, ItemStack st, ServerLevel w, BlockHitResult r) { return true; }
	}

	public static class Stairs extends StairBlock implements Visual {
		public Stairs(BlockState base, Properties p) { super(base, p); }
		public Block clientBlock() { return Blocks.SANDSTONE_STAIRS; } public float range() { return 3F; }
	}
	public static class Slab extends SlabBlock implements Visual {
		public Slab(Properties p) { super(p); }
		public Block clientBlock() { return Blocks.SANDSTONE_SLAB; } public float range() { return 3F; }
	}
	public static class Wall extends WallBlock implements Visual {
		public Wall(Properties p) { super(p); }
		public Block clientBlock() { return Blocks.SANDSTONE_WALL; } public float range() { return 3F; }
	}
	public static class Fence extends FenceBlock implements Visual {
		public Fence(Properties p) { super(p); }
		public Block clientBlock() { return Blocks.BIRCH_FENCE; } public float range() { return 3F; }
	}
	public static class Gate extends FenceGateBlock implements Visual {
		public Gate(Properties p) { super(WoodType.OAK, p); }
		public Block clientBlock() { return Blocks.BIRCH_FENCE_GATE; } public float range() { return 3F; }
	}
	public static class Button extends ButtonBlock implements Visual {
		public Button(BlockSetType t, int ticks, Properties p) { super(t, ticks, p); }
		public Block clientBlock() { return Blocks.STONE_BUTTON; } public float range() { return 1.1F; }
	}
	public static class Plate extends PressurePlateBlock implements Visual {
		public Plate(BlockSetType t, Properties p) { super(t, p); }
		public Block clientBlock() { return Blocks.STONE_PRESSURE_PLATE; } public float range() { return 1.1F; }
	}
	public static class Trapdoor extends TrapDoorBlock implements Visual {
		public Trapdoor(BlockSetType t, Properties p) { super(t, p); }
		public Block clientBlock() { return Blocks.IRON_TRAPDOOR; } public float range() { return 3F; }
	}
	public static class Door extends DoorBlock implements Visual {
		public Door(BlockSetType t, Properties p) { super(t, p); }
		public Block clientBlock() { return Blocks.IRON_DOOR; } public float range() { return 3F; }
	}

	private static BlockBehaviour.Properties props(String mat, float hardness) {
		var p = BlockBehaviour.Properties.of().strength(hardness, mat.equals("wood") ? 3.0F : 6.0F);
		return switch (mat) {
			case "wood" -> p.sound(SoundType.WOOD).ignitedByLava();
			case "glass" -> p.sound(SoundType.GLASS).noOcclusion();
			default -> p.sound(SoundType.STONE).requiresCorrectToolForDrops();
		};
	}

	public static void init() {
		try (var in = FamilyBlocks.class.getResourceAsStream("/maether/families.txt");
			 var r = new BufferedReader(new InputStreamReader(in))) {
			String line;
			while ((line = r.readLine()) != null) {
				line = line.trim();
				if (line.isEmpty() || line.startsWith("#")) continue;
				String[] t = line.split("\\s+");
				register(t[0], t[1], t.length > 2 ? t[2] : "stone", t.length > 3 ? Float.parseFloat(t[3]) : 1.5F, t.length > 4 ? t[4] : null);
			}
		} catch (Exception e) {
			throw new RuntimeException("failed to read families.txt", e);
		}
	}

	private static void register(String name, String kind, String mat, float hardness, String base) {
		Identifier id = Identifier.fromNamespaceAndPath("aether", name);
		var key = ResourceKey.create(Registries.BLOCK, id);
		var p = props(mat, hardness).setId(key);
		BlockSetType set = mat.equals("wood") ? BlockSetType.OAK : BlockSetType.STONE;
		Block b = switch (kind) {
			case "stairs" -> new Stairs(com.kestrel.maether.block.AetherBlocks.ALL.get(base).defaultBlockState(), p);
			case "slab" -> new Slab(p);
			case "wall" -> new Wall(p);
			case "fence" -> new Fence(p);
			case "gate" -> new Gate(p);
			case "button" -> new Button(set, mat.equals("wood") ? 30 : 20, p.noCollision());
			case "plate" -> new Plate(set, p.noCollision());
			case "trapdoor" -> new Trapdoor(set, p.noOcclusion());
			case "door" -> new Door(set, p.noOcclusion());
			default -> throw new IllegalArgumentException(kind);
		};
		Registry.register(BuiltInRegistries.BLOCK, id, b);
		Item.Properties ip = new Item.Properties().setId(ResourceKey.create(Registries.ITEM, id)).useBlockDescriptionPrefix();
		Registry.register(BuiltInRegistries.ITEM, id, new AetherBlockItem(b, ip, id));
		BlockStateModelManager.addBlock(id, b);
		ALL.put(name, b);
	}
}
