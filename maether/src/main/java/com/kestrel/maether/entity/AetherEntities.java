package com.kestrel.maether.entity;

import net.fabricmc.fabric.api.object.builder.v1.entity.FabricDefaultAttributeRegistry;
import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import net.minecraft.world.entity.*;
import net.minecraft.world.entity.animal.Animal;
import net.minecraft.world.entity.animal.cow.Cow;
import net.minecraft.world.entity.animal.pig.Pig;
import net.minecraft.world.entity.animal.rabbit.Rabbit;
import net.minecraft.world.entity.monster.Monster;
import net.minecraft.world.entity.monster.cubemob.Slime;
import net.minecraft.world.level.levelgen.Heightmap;

/** Aether mobs, registered under the aether namespace so upstream worldgen/loot ids line up. */
public final class AetherEntities {
	public static EntityType<Phyg> PHYG;
	public static EntityType<FlyingCow> FLYING_COW;
	public static EntityType<Aerbunny> AERBUNNY;
	public static EntityType<BlueSwet> BLUE_SWET;

	private AetherEntities() {}

	private static <T extends Entity> EntityType<T> reg(String name, EntityType.EntityFactory<T> factory, MobCategory cat, float w, float h) {
		ResourceKey<EntityType<?>> key = ResourceKey.create(Registries.ENTITY_TYPE, Identifier.fromNamespaceAndPath("aether", name));
		return Registry.register(BuiltInRegistries.ENTITY_TYPE, key, EntityType.Builder.of(factory, cat).sized(w, h).clientTrackingRange(8).build(key));
	}

	public static void init() {
		PHYG = reg("phyg", Phyg::new, MobCategory.CREATURE, 0.9F, 0.9F);
		FLYING_COW = reg("flying_cow", FlyingCow::new, MobCategory.CREATURE, 0.9F, 1.4F);
		AERBUNNY = reg("aerbunny", Aerbunny::new, MobCategory.CREATURE, 0.4F, 0.5F);
		BLUE_SWET = reg("blue_swet", BlueSwet::new, MobCategory.MONSTER, 0.52F, 0.52F);
		FabricDefaultAttributeRegistry.register(PHYG, Pig.createAttributes());
		FabricDefaultAttributeRegistry.register(FLYING_COW, Cow.createAttributes());
		FabricDefaultAttributeRegistry.register(AERBUNNY, Rabbit.createAttributes());
		FabricDefaultAttributeRegistry.register(BLUE_SWET, Monster.createMonsterAttributes());
		SpawnPlacements.register(PHYG, SpawnPlacementTypes.ON_GROUND, Heightmap.Types.MOTION_BLOCKING_NO_LEAVES, Animal::checkAnimalSpawnRules);
		SpawnPlacements.register(FLYING_COW, SpawnPlacementTypes.ON_GROUND, Heightmap.Types.MOTION_BLOCKING_NO_LEAVES, Animal::checkAnimalSpawnRules);
		SpawnPlacements.register(AERBUNNY, SpawnPlacementTypes.ON_GROUND, Heightmap.Types.MOTION_BLOCKING_NO_LEAVES, Animal::checkAnimalSpawnRules);
		SpawnPlacements.register(BLUE_SWET, SpawnPlacementTypes.ON_GROUND, Heightmap.Types.MOTION_BLOCKING_NO_LEAVES, Monster::checkMonsterSpawnRules);
	}
}
