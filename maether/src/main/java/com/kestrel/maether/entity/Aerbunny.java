package com.kestrel.maether.entity;

import eu.pb4.polymer.core.api.entity.PolymerEntity;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.world.damagesource.DamageSource;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.EntityTypes;
import net.minecraft.world.entity.animal.rabbit.Rabbit;
import net.minecraft.world.level.Level;

public class Aerbunny extends Rabbit implements PolymerEntity {
	public Aerbunny(EntityType<? extends Rabbit> type, Level level) { super(type, level); }

	@Override public EntityType<?> getPolymerEntityType(PacketContext ctx) { return EntityTypes.RABBIT; }
	@Override public boolean causeFallDamage(double distance, float multiplier, DamageSource source) { return false; }
}
