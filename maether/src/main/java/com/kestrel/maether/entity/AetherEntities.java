package com.kestrel.maether.entity;

import net.fabricmc.fabric.api.object.builder.v1.entity.FabricDefaultAttributeRegistry;
import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import eu.pb4.polymer.core.api.entity.PolymerEntityUtils;
import net.minecraft.world.entity.*;
import net.minecraft.world.entity.ai.attributes.AttributeSupplier;
import net.minecraft.world.entity.ai.attributes.Attributes;
import net.minecraft.world.entity.animal.equine.Horse;
import net.minecraft.world.entity.animal.happyghast.HappyGhast;
import net.minecraft.world.entity.animal.sheep.Sheep;
import net.minecraft.world.entity.monster.Blaze;
import net.minecraft.world.entity.monster.Ghast;
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
	public static final java.util.Map<String, EntityType<?>> ALL = new java.util.LinkedHashMap<>();

	private AetherEntities() {}

	@FunctionalInterface private interface Placement<T extends Mob> { boolean test(EntityType<T> t, net.minecraft.world.level.ServerLevelAccessor l, EntitySpawnReason r, net.minecraft.core.BlockPos p, net.minecraft.util.RandomSource rnd); }

	private static <T extends Mob> EntityType<T> mob(String name, EntityType.EntityFactory<T> factory, MobCategory cat, float w, float h,
		AttributeSupplier.Builder attrs, SpawnPlacementType place, Heightmap.Types hm, SpawnPlacements.SpawnPredicate<T> pred) {
		ResourceKey<EntityType<?>> key = ResourceKey.create(Registries.ENTITY_TYPE, Identifier.fromNamespaceAndPath("aether", name));
		EntityType<T> type = Registry.register(BuiltInRegistries.ENTITY_TYPE, key, EntityType.Builder.of(factory, cat).sized(w, h).clientTrackingRange(8).build(key));
		PolymerEntityUtils.registerType(type);
		FabricDefaultAttributeRegistry.register(type, attrs);
		SpawnPlacements.register(type, place, hm, pred);
		ALL.put(name, type);
		return type;
	}

	private static final SpawnPlacementType GROUND = SpawnPlacementTypes.ON_GROUND;
	private static final Heightmap.Types SURF = Heightmap.Types.MOTION_BLOCKING_NO_LEAVES;

	public static void init() {
		PHYG = mob("phyg", Phyg::new, MobCategory.CREATURE, 0.9F, 0.9F, Pig.createAttributes(), GROUND, SURF, Animal::checkAnimalSpawnRules);
		FLYING_COW = mob("flying_cow", FlyingCow::new, MobCategory.CREATURE, 0.9F, 1.4F, Cow.createAttributes(), GROUND, SURF, Animal::checkAnimalSpawnRules);
		AERBUNNY = mob("aerbunny", Aerbunny::new, MobCategory.CREATURE, 0.4F, 0.5F, Rabbit.createAttributes(), GROUND, SURF, Animal::checkAnimalSpawnRules);
		BLUE_SWET = mob("blue_swet", BlueSwet::new, MobCategory.MONSTER, 0.52F, 0.52F, Monster.createMonsterAttributes(), GROUND, SURF, Monster::checkMonsterSpawnRules);
		mob("sheepuff", Mobs.Sheepuff::new, MobCategory.CREATURE, 0.9F, 1.3F, Sheep.createAttributes(), GROUND, SURF, Animal::checkAnimalSpawnRules);
		mob("moa", Mobs.Moa::new, MobCategory.CREATURE, 1.1F, 1.9F, Horse.createBaseHorseAttributes(), GROUND, SURF, Animal::checkAnimalSpawnRules);
		mob("aerwhale", Mobs.Aerwhale::new, MobCategory.AMBIENT, 4.0F, 4.0F, HappyGhast.createAttributes(), SpawnPlacementTypes.NO_RESTRICTIONS, Heightmap.Types.MOTION_BLOCKING, (t, l, r, p, rnd) -> true);
		mob("zephyr", Mobs.Zephyr::new, MobCategory.MONSTER, 4.0F, 4.0F, Ghast.createAttributes(), SpawnPlacementTypes.NO_RESTRICTIONS, Heightmap.Types.MOTION_BLOCKING, Ghast::checkGhastSpawnRules);
		mob("golden_swet", Mobs.GoldenSwet::new, MobCategory.MONSTER, 0.52F, 0.52F, Monster.createMonsterAttributes(), GROUND, SURF, Monster::checkMonsterSpawnRules);
		mob("sentry", Mobs.Sentry::new, MobCategory.MONSTER, 0.52F, 0.52F, Monster.createMonsterAttributes(), GROUND, SURF, Monster::checkMonsterSpawnRules);
		mob("fire_minion", Mobs.FireMinion::new, MobCategory.MONSTER, 0.6F, 1.8F, Blaze.createAttributes(), GROUND, SURF, Monster::checkMonsterSpawnRules);
		mob("cockatrice", Mobs.Cockatrice::new, MobCategory.MONSTER, 0.9F, 1.2F, Monster.createMonsterAttributes().add(Attributes.MAX_HEALTH, 20.0), GROUND, SURF, Monster::checkMonsterSpawnRules);
		mob("aechor_plant", Mobs.AechorPlant::new, MobCategory.MONSTER, 0.8F, 1.3F, Monster.createMonsterAttributes().add(Attributes.MAX_HEALTH, 10.0).add(Attributes.MOVEMENT_SPEED, 0.0), GROUND, SURF, Monster::checkMonsterSpawnRules);
		AetherEntities.<Mobs.Whirlwind>mob("whirlwind", Mobs.Whirlwind::new, MobCategory.CREATURE, 0.8F, 1.6F, Mobs.flyer(10.0, 0.3), SpawnPlacementTypes.NO_RESTRICTIONS, Heightmap.Types.MOTION_BLOCKING, (t, l, r, p, rnd) -> true);
		AetherEntities.<Mobs.EvilWhirlwind>mob("evil_whirlwind", Mobs.EvilWhirlwind::new, MobCategory.MONSTER, 0.8F, 1.6F, Mobs.flyer(10.0, 0.3), SpawnPlacementTypes.NO_RESTRICTIONS, Heightmap.Types.MOTION_BLOCKING, (t, l, r, p, rnd) -> true);
	}
}
