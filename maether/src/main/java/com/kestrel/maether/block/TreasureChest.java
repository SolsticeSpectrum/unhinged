package com.kestrel.maether.block;

import com.kestrel.maether.item.AetherItems;
import eu.pb4.polymer.blocks.api.BlockModelType;
import eu.pb4.polymer.blocks.api.PolymerBlockModel;
import net.minecraft.core.BlockPos;
import net.minecraft.network.chat.Component;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.sounds.SoundEvents;
import net.minecraft.sounds.SoundSource;
import net.minecraft.util.RandomSource;
import net.minecraft.world.InteractionHand;
import net.minecraft.world.InteractionResult;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.Block;
import net.minecraft.world.level.block.Blocks;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.phys.BlockHitResult;

import java.util.ArrayList;
import java.util.List;

/** Dungeon reward chest: opened with a bronze/silver/gold dungeon key, loot depends on the key. */
public class TreasureChest extends AetherBlock.Cube {
	private static final String[] BRONZE = {"iron_ring", "golden_ring", "iron_pendant", "golden_pendant", "leather_gloves", "chainmail_gloves", "iron_gloves", "golden_gloves",
		"zanite_helmet", "zanite_chestplate", "zanite_leggings", "zanite_boots", "red_cape", "blue_cape", "yellow_cape", "white_cape", "agility_cape", "swet_cape"};
	private static final String[] SILVER = {"vampire_blade", "flaming_sword", "holy_sword", "zanite_ring", "zanite_pendant", "ice_ring", "ice_pendant", "diamond_gloves",
		"gravitite_helmet", "gravitite_chestplate", "gravitite_leggings", "gravitite_boots", "zanite_gloves", "gravitite_gloves", "regeneration_stone", "iron_bubble", "candy_cane_sword"};
	private static final String[] GOLD = {"valkyrie_pickaxe", "valkyrie_axe", "valkyrie_shovel", "valkyrie_hoe", "valkyrie_lance", "lightning_sword", "hammer_of_kingbdogz", "pig_slayer",
		"phoenix_helmet", "phoenix_chestplate", "phoenix_leggings", "phoenix_boots", "obsidian_helmet", "obsidian_chestplate", "obsidian_leggings", "obsidian_boots",
		"neptune_helmet", "neptune_chestplate", "neptune_leggings", "neptune_boots", "shield_of_repulsion", "golden_feather", "valkyrie_cape", "invisibility_cloak", "netherite_gloves", "phoenix_gloves", "obsidian_gloves", "valkyrie_gloves", "neptune_gloves"};

	public TreasureChest(Properties p, PolymerBlockModel model) { super(p, BlockModelType.FULL_BLOCK, model); }

	private static String[] pool(String key) {
		return switch (key) { case "bronze_dungeon_key" -> BRONZE; case "silver_dungeon_key" -> SILVER; case "gold_dungeon_key" -> GOLD; default -> null; };
	}

	@Override
	protected InteractionResult useItemOn(ItemStack held, BlockState state, Level level, BlockPos pos, Player player, InteractionHand hand, BlockHitResult hit) {
		String[] pool = pool(net.minecraft.core.registries.BuiltInRegistries.ITEM.getKey(held.getItem()).getPath());
		if (pool == null) return InteractionResult.PASS;
		if (level instanceof ServerLevel sl) {
			if (!player.isCreative()) held.shrink(1);
			RandomSource r = sl.getRandom();
			List<ItemStack> loot = new ArrayList<>();
			for (int i = 0; i < 3; i++) { Item it = AetherItems.ALL.get(pool[r.nextInt(pool.length)]); if (it != null) loot.add(new ItemStack(it)); }
			Item shard = AetherItems.ALL.get("ambrosium_shard"), gem = AetherItems.ALL.get("zanite_gemstone");
			if (shard != null) loot.add(new ItemStack(shard, 4 + r.nextInt(8)));
			if (gem != null) loot.add(new ItemStack(gem, 2 + r.nextInt(4)));
			for (ItemStack s : loot) Block.popResource(sl, pos, s);
			sl.setBlock(pos, Blocks.AIR.defaultBlockState(), 3);
			sl.playSound(null, pos, SoundEvents.CHEST_OPEN, SoundSource.BLOCKS, 1.0F, 1.0F);
			player.sendOverlayMessage(Component.literal("The chest opens!"));
		}
		return InteractionResult.SUCCESS;
	}

	@Override
	protected InteractionResult useWithoutItem(BlockState s, Level level, BlockPos pos, Player player, BlockHitResult hit) {
		if (!level.isClientSide()) player.sendOverlayMessage(Component.literal("This chest needs a dungeon key."));
		return InteractionResult.SUCCESS;
	}
}
