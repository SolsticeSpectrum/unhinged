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
		com.kestrel.maether.dungeon.Dungeons.init();
		com.kestrel.maether.machine.Machines.init();
		com.kestrel.maether.family.FamilyBlocks.init();
		com.kestrel.maether.family.PlantBlocks.init();
		com.kestrel.maether.item.AetherItems.init();
		com.kestrel.maether.acc.Accessories.init();
		com.kestrel.maether.item.Extras.init();
		com.kestrel.maether.item.ArmorEffects.init();
		com.kestrel.maether.entity.AetherEntities.init();
		com.kestrel.maether.entity.Boats.init();
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
		// players standing still inside a portal never trigger entityInside (no movement packets): poll instead
		net.fabricmc.fabric.api.event.lifecycle.v1.ServerTickEvents.END_SERVER_TICK.register(server -> {
			for (var p : server.getPlayerList().getPlayers()) {
				var st = p.level().getBlockState(p.blockPosition());
				// falling out of the Aether drops you back into the overworld sky, with a parachute-ish soft landing
				if (p.level().dimension() == com.kestrel.maether.portal.AetherPortals.AETHER && p.getY() < -16) {
					var ow = server.getLevel(net.minecraft.world.level.Level.OVERWORLD);
					if (ow != null) {
						p.teleport(new net.minecraft.world.level.portal.TeleportTransition(ow, new net.minecraft.world.phys.Vec3(p.getX(), ow.getMaxY() - 8, p.getZ()),
							net.minecraft.world.phys.Vec3.ZERO, p.getYRot(), p.getXRot(), net.minecraft.world.level.portal.TeleportTransition.DO_NOTHING));
						p.addEffect(new net.minecraft.world.effect.MobEffectInstance(net.minecraft.world.effect.MobEffects.SLOW_FALLING, 1200, 0));
					}
				}
				if (st.is(com.kestrel.maether.block.AetherBlocks.PORTAL)) p.setAsInsidePortal((net.minecraft.world.level.block.Portal) st.getBlock(), p.blockPosition());
			}
		});
		PolymerResourcePackUtils.addModAssets(ID);
		PolymerResourcePackUtils.markAsRequired();
		long b = net.minecraft.core.registries.BuiltInRegistries.BLOCK.keySet().stream().filter(k -> k.getNamespace().equals("aether")).count();
		long i = net.minecraft.core.registries.BuiltInRegistries.ITEM.keySet().stream().filter(k -> k.getNamespace().equals("aether")).count();
		long e = net.minecraft.core.registries.BuiltInRegistries.ENTITY_TYPE.keySet().stream().filter(k -> k.getNamespace().equals("aether")).count();
		LOGGER.info("mAether initialised: {} blocks, {} items, {} entity types", b, i, e);
	}
}
