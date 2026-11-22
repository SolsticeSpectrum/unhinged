package com.kestrel.maether.entity;

import eu.pb4.polymer.core.api.entity.PolymerEntity;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.world.damagesource.DamageSource;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.EntityTypes;
import net.minecraft.world.entity.animal.cow.Cow;
import net.minecraft.world.level.Level;

public class FlyingCow extends Cow implements PolymerEntity {
	public FlyingCow(EntityType<? extends Cow> type, Level level) { super(type, level); }

	@Override public EntityType<?> getPolymerEntityType(PacketContext ctx) { return EntityTypes.COW; }
	@Override public boolean causeFallDamage(double distance, float multiplier, DamageSource source) { return false; }
}
