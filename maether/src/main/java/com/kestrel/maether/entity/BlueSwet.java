package com.kestrel.maether.entity;

import eu.pb4.polymer.core.api.entity.PolymerEntity;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.EntityTypes;
import net.minecraft.world.entity.monster.cubemob.Slime;
import net.minecraft.world.level.Level;

/** Hostile: a slime that never grows or splits (size is pinned to 1). */
public class BlueSwet extends Slime implements PolymerEntity {
	public BlueSwet(EntityType<? extends Slime> type, Level level) { super(type, level); }

	@Override public void setSize(int size, boolean heal) { super.setSize(1, heal); }
	@Override public EntityType<?> getPolymerEntityType(PacketContext ctx) { return EntityTypes.SLIME; }
}
