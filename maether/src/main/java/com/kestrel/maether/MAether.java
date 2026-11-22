package com.kestrel.maether;

import com.kestrel.maether.block.AetherBlocks;
import eu.pb4.polymer.resourcepack.api.PolymerResourcePackUtils;
import net.fabricmc.api.ModInitializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MAether implements ModInitializer {
	public static final String ID = "maether";
	public static final Logger LOGGER = LoggerFactory.getLogger(ID);

	@Override
	public void onInitialize() {
		AetherBlocks.init();
		if (net.fabricmc.loader.api.FabricLoader.getInstance().isDevelopmentEnvironment()) DevCommands.register();
		com.kestrel.maether.family.FamilyBlocks.init();
		com.kestrel.maether.family.PlantBlocks.init();
		com.kestrel.maether.item.AetherItems.init();
		com.kestrel.maether.acc.Accessories.init();
		com.kestrel.maether.item.ArmorEffects.init();
		com.kestrel.maether.entity.AetherEntities.init();
		com.kestrel.maether.item.AetherItems.eggs();
		net.fabricmc.fabric.api.event.player.UseBlockCallback.EVENT.register((player, level, hand, hit) -> {
			var stack = player.getItemInHand(hand);
			if (level.isClientSide() || !stack.is(net.minecraft.world.item.Items.WATER_BUCKET)) return net.minecraft.world.InteractionResult.PASS;
			var dim = level.dimension();
			if (dim != net.minecraft.world.level.Level.OVERWORLD && dim != com.kestrel.maether.portal.AetherPortals.AETHER) return net.minecraft.world.InteractionResult.PASS;
			var inside = hit.getBlockPos().relative(hit.getDirection());
			if (!com.kestrel.maether.portal.AetherPortals.tryLight(level, inside)) return net.minecraft.world.InteractionResult.PASS;
			if (!player.isCreative()) player.setItemInHand(hand, new net.minecraft.world.item.ItemStack(net.minecraft.world.item.Items.BUCKET));
			return net.minecraft.world.InteractionResult.SUCCESS;
		});
		PolymerResourcePackUtils.addModAssets(ID);
		PolymerResourcePackUtils.markAsRequired();
		LOGGER.info("mAether initialised ({} blocks)", AetherBlocks.ALL.size());
	}
}
