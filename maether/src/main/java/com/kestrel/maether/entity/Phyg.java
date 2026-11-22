package com.kestrel.maether.entity;

import eu.pb4.polymer.core.api.entity.PolymerEntity;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.world.damagesource.DamageSource;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.EntityTypes;
import net.minecraft.world.entity.animal.pig.Pig;
import net.minecraft.world.level.Level;

/** Flying pig: a vanilla pig for vanilla clients (v1: no custom model), immune to fall damage. */
public class Phyg extends Pig implements PolymerEntity {
	public Phyg(EntityType<? extends Pig> type, Level level) { super(type, level); }

	@Override public EntityType<?> getPolymerEntityType(PacketContext ctx) { return EntityTypes.PIG; }
	@Override public boolean causeFallDamage(double distance, float multiplier, DamageSource source) { return false; }
}
