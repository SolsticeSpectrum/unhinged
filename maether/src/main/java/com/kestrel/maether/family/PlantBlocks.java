package com.kestrel.maether.family;

import com.kestrel.maether.item.AetherBlockItem;
import eu.pb4.factorytools.api.block.FactoryBlock;
import eu.pb4.factorytools.api.block.model.generic.BSMMParticleBlock;
import eu.pb4.factorytools.api.block.model.generic.BlockStateModelManager;
import eu.pb4.polymer.blocks.api.BlockModelType;
import eu.pb4.polymer.blocks.api.PolymerBlockResourceUtils;
import eu.pb4.polymer.blocks.api.PolymerTexturedBlock;
import eu.pb4.polymer.core.api.item.PolymerItem;
import eu.pb4.polymer.virtualentity.api.ElementHolder;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.core.BlockPos;
import net.minecraft.core.Direction;
import net.minecraft.core.HolderLookup;
import net.minecraft.core.Registry;
import net.minecraft.core.particles.ParticleTypes;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.tags.BlockTags;
import net.minecraft.util.RandomSource;
import net.minecraft.world.InteractionHand;
import net.minecraft.world.InteractionResult;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.item.StandingAndWallBlockItem;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.LevelReader;
import net.minecraft.world.level.block.*;
import net.minecraft.world.level.block.state.BlockBehaviour;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.phys.BlockHitResult;
import net.minecraft.world.phys.shapes.CollisionContext;
import net.minecraft.world.phys.shapes.Shapes;
import net.minecraft.world.phys.shapes.VoxelShape;

import java.util.Map;

/** Saplings, flowers, berry bush and torches: empty polymer plant state (or vanilla torch hitbox) + display models. */
public final class PlantBlocks {
	private PlantBlocks() {}

	private static final VoxelShape PLANT = Block.box(2, 0, 2, 14, 12, 14);

	interface PlantVisual extends FactoryBlock, PolymerTexturedBlock, BSMMParticleBlock {
		@Override default BlockState getPolymerBlockState(BlockState s, PacketContext c) { return PolymerBlockResourceUtils.requestEmpty(BlockModelType.PLANT); }
		@Override default ElementHolder createElementHolder(ServerLevel w, BlockPos p, BlockState s) { return new FamilyModel(3.0F); }
		@Override default boolean isIgnoringBlockInteractionPlaySoundExceptedEntity(BlockState s, ServerPlayer pl, InteractionHand h, ItemStack st, ServerLevel w, BlockHitResult r) { return true; }
	}

	static boolean onSoil(BlockState below) { return below.is(BlockTags.DIRT); }

	public static class Flower extends VegetationBlock implements PlantVisual {
		public Flower(Properties p) { super(p); }
		@Override protected boolean mayPlaceOn(BlockState s, net.minecraft.world.level.BlockGetter g, BlockPos p) { return onSoil(s); }
		@Override protected VoxelShape getShape(BlockState s, net.minecraft.world.level.BlockGetter g, BlockPos p, CollisionContext c) { return PLANT; }
	}

	/** Sapling: random ticks grow it into the tree feature via the vanilla {@code place feature} command. */
	public static class Sapling extends Flower {
		private final String feature;
		public Sapling(Properties p, String feature) { super(p.randomTicks()); this.feature = feature; }
		@Override protected void randomTick(BlockState s, ServerLevel level, BlockPos pos, RandomSource r) {
			if (r.nextInt(7) != 0 || level.getMaxLocalRawBrightness(pos.above()) < 9) return;
			level.removeBlock(pos, false);
			var src = level.getServer().createCommandSourceStack().withLevel(level).withSuppressedOutput();
			var parsed = level.getServer().getCommands().getDispatcher().parse("place feature " + feature + " " + pos.getX() + " " + pos.getY() + " " + pos.getZ(), src);
			level.getServer().getCommands().performCommand(parsed, "place feature");
			if (level.getBlockState(pos).isAir()) level.setBlock(pos, s, 3); // placement failed -> keep the sapling
		}
	}

	/** Berry bush with blue berries; right-click harvests, the stem regrows berries. */
	public static class Bush extends Flower {
		private final boolean ripe;
		public Bush(Properties p, boolean ripe) { super(ripe ? p : p.randomTicks()); this.ripe = ripe; }
		@Override protected InteractionResult useWithoutItem(BlockState s, Level level, BlockPos pos, Player pl, BlockHitResult hit) {
			if (!ripe) return InteractionResult.PASS;
			if (level instanceof ServerLevel sl) {
				Block.popResource(sl, pos, new ItemStack(com.kestrel.maether.item.AetherItems.ALL.get("blue_berry"), 1 + sl.getRandom().nextInt(3)));
				sl.setBlock(pos, FamilyBlocks_stem().defaultBlockState(), 3);
			}
			return InteractionResult.SUCCESS;
		}
		@Override protected void randomTick(BlockState s, ServerLevel level, BlockPos pos, RandomSource r) {
			if (!ripe && r.nextInt(8) == 0) level.setBlock(pos, BUSH.defaultBlockState(), 3);
		}
	}

	static Block BUSH, STEM;
	static Block FamilyBlocks_stem() { return STEM; }

	public static class Torch extends TorchBlock implements FactoryBlock, PolymerTexturedBlock, BSMMParticleBlock {
		public Torch(Properties p) { super(ParticleTypes.FLAME, p); }
		@Override public BlockState getPolymerBlockState(BlockState s, PacketContext c) { return Blocks.TORCH.defaultBlockState(); }
		@Override public ElementHolder createElementHolder(ServerLevel w, BlockPos p, BlockState s) { return new FamilyModel(3.0F); }
	}
	public static class WallTorch extends WallTorchBlock implements FactoryBlock, PolymerTexturedBlock, BSMMParticleBlock {
		public WallTorch(Properties p) { super(ParticleTypes.FLAME, p); }
		@Override public BlockState getPolymerBlockState(BlockState s, PacketContext c) { return Blocks.WALL_TORCH.withPropertiesOf(s); }
		@Override public ElementHolder createElementHolder(ServerLevel w, BlockPos p, BlockState s) { return new FamilyModel(3.0F); }
	}

	static class TorchItem extends StandingAndWallBlockItem implements PolymerItem {
		private final Identifier model;
		TorchItem(Block b, Block w, Properties p, Identifier model) { super(b, w, Direction.DOWN, p); this.model = model; }
		@Override public Item getPolymerItem(ItemStack s, PacketContext c) { return Items.TORCH; }
		@Override public Identifier getPolymerItemModel(ItemStack s, PacketContext c, HolderLookup.Provider l) { return model; }
	}

	private static <B extends Block> B block(String name, java.util.function.Function<BlockBehaviour.Properties, B> f, BlockBehaviour.Properties p) {
		Identifier id = Identifier.fromNamespaceAndPath("aether", name);
		B b = Registry.register(BuiltInRegistries.BLOCK, id, f.apply(p.setId(ResourceKey.create(Registries.BLOCK, id))));
		BlockStateModelManager.addBlock(id, b);
		FamilyBlocks.ALL.put(name, b);
		return b;
	}

	private static void item(String name, Block b) {
		Identifier id = Identifier.fromNamespaceAndPath("aether", name);
		Registry.register(BuiltInRegistries.ITEM, id, new AetherBlockItem(b, new Item.Properties().setId(ResourceKey.create(Registries.ITEM, id)).useBlockDescriptionPrefix(), id));
	}

	public static void init() {
		var plant = BlockBehaviour.Properties.of().noCollision().instabreak().sound(SoundType.GRASS);
		item("purple_flower", block("purple_flower", Flower::new, plant));
		item("white_flower", block("white_flower", Flower::new, plant));
		item("skyroot_sapling", block("skyroot_sapling", p -> new Sapling(p, "aether:skyroot_tree"), plant));
		item("golden_oak_sapling", block("golden_oak_sapling", p -> new Sapling(p, "aether:golden_oak_tree"), plant));
		BUSH = block("berry_bush", p -> new Bush(p, true), plant.sound(SoundType.SWEET_BERRY_BUSH));
		STEM = block("berry_bush_stem", p -> new Bush(p, false), plant);
		item("berry_bush", BUSH);
		Block t = block("ambrosium_torch", Torch::new, BlockBehaviour.Properties.of().noCollision().instabreak().lightLevel(s -> 14).sound(SoundType.WOOD));
		Block wt = block("ambrosium_wall_torch", WallTorch::new, BlockBehaviour.Properties.of().noCollision().instabreak().lightLevel(s -> 14).sound(SoundType.WOOD).overrideLootTable(t.getLootTable()));
		Identifier tid = Identifier.fromNamespaceAndPath("aether", "ambrosium_torch");
		Registry.register(BuiltInRegistries.ITEM, tid, new TorchItem(t, wt, new Item.Properties().setId(ResourceKey.create(Registries.ITEM, tid)).useBlockDescriptionPrefix(), tid));
	}
}
