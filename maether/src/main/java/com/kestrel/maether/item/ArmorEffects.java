package com.kestrel.maether.item;

import net.fabricmc.fabric.api.event.lifecycle.v1.ServerTickEvents;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.effect.MobEffectInstance;
import net.minecraft.world.effect.MobEffects;
import net.minecraft.world.entity.EquipmentSlot;

/** Full-set bonuses for Aether armor (applied as short, ambient effects every second). */
public final class ArmorEffects {
	private ArmorEffects() {}

	private static boolean full(ServerPlayer p, String set) {
		for (EquipmentSlot s : new EquipmentSlot[]{EquipmentSlot.HEAD, EquipmentSlot.CHEST, EquipmentSlot.LEGS, EquipmentSlot.FEET}) {
			var id = BuiltInRegistries.ITEM.getKey(p.getItemBySlot(s).getItem());
			if (!id.getNamespace().equals("aether") || !id.getPath().startsWith(set + "_")) return false;
		}
		return true;
	}

	private static void give(ServerPlayer p, net.minecraft.core.Holder<net.minecraft.world.effect.MobEffect> e, int amp) {
		p.addEffect(new MobEffectInstance(e, 120, amp, true, false, false));
	}

	public static void init() {
		ServerTickEvents.END_SERVER_TICK.register(server -> {
			if (server.getTickCount() % 20 != 0) return;
			for (ServerPlayer p : server.getPlayerList().getPlayers()) {
				if (full(p, "neptune")) { give(p, MobEffects.WATER_BREATHING, 0); if (p.isInWater()) give(p, MobEffects.DOLPHINS_GRACE, 0); }
				if (full(p, "phoenix")) give(p, MobEffects.FIRE_RESISTANCE, 0);
				if (full(p, "valkyrie")) give(p, MobEffects.SLOW_FALLING, 0);
				if (full(p, "gravitite")) give(p, MobEffects.JUMP_BOOST, 0);
			}
		});
	}
}
