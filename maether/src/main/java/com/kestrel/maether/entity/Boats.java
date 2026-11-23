package com.kestrel.maether.entity;

import com.kestrel.maether.item.AetherItems;
import eu.pb4.polymer.core.api.entity.PolymerEntity;
import eu.pb4.polymer.core.api.entity.PolymerEntityUtils;
import eu.pb4.polymer.core.api.item.PolymerItem;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.core.HolderLookup;
import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.EntityTypes;
import net.minecraft.world.entity.MobCategory;
import net.minecraft.world.entity.vehicle.boat.Boat;
import net.minecraft.world.entity.vehicle.boat.ChestBoat;
import net.minecraft.world.item.BoatItem;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.level.Level;

/** Skyroot boats: vanilla boat physics, shown to vanilla clients as oak boats. */
public final class Boats {
	public static EntityType<SkyrootBoat> BOAT;
	public static EntityType<SkyrootChestBoat> CHEST_BOAT;

	private Boats() {}

	public static class SkyrootBoat extends Boat implements PolymerEntity {
		public SkyrootBoat(EntityType<? extends Boat> t, Level l) { super(t, l, () -> AetherItems.ALL.get("skyroot_boat")); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.OAK_BOAT; }
	}

	public static class SkyrootChestBoat extends ChestBoat implements PolymerEntity {
		public SkyrootChestBoat(EntityType<? extends ChestBoat> t, Level l) { super(t, l, () -> AetherItems.ALL.get("skyroot_chest_boat")); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.OAK_CHEST_BOAT; }
	}

	private static class PolyBoatItem extends BoatItem implements PolymerItem {
		private final Item base; private final Identifier model;
		PolyBoatItem(EntityType<? extends net.minecraft.world.entity.vehicle.boat.AbstractBoat> t, Properties p, Item base, Identifier model) { super(t, p); this.base = base; this.model = model; }
		@Override public Item getPolymerItem(ItemStack s, PacketContext c) { return base; }
		@Override public Identifier getPolymerItemModel(ItemStack s, PacketContext c, HolderLookup.Provider l) { return model; }
	}

	private static <T extends net.minecraft.world.entity.Entity> EntityType<T> reg(String name, EntityType.EntityFactory<T> f) {
		ResourceKey<EntityType<?>> key = ResourceKey.create(Registries.ENTITY_TYPE, Identifier.fromNamespaceAndPath("aether", name));
		EntityType<T> t = Registry.register(BuiltInRegistries.ENTITY_TYPE, key, EntityType.Builder.of(f, MobCategory.MISC).sized(1.375F, 0.5625F).clientTrackingRange(10).updateInterval(3).build(key));
		PolymerEntityUtils.registerType(t);
		return t;
	}

	public static void init() {
		BOAT = reg("skyroot_boat", SkyrootBoat::new);
		CHEST_BOAT = reg("skyroot_chest_boat", SkyrootChestBoat::new);
		for (var e : new Object[][]{{"skyroot_boat", BOAT, Items.OAK_BOAT}, {"skyroot_chest_boat", CHEST_BOAT, Items.OAK_CHEST_BOAT}}) {
			String n = (String) e[0]; Identifier id = Identifier.fromNamespaceAndPath("aether", n);
			@SuppressWarnings("unchecked") var type = (EntityType<? extends net.minecraft.world.entity.vehicle.boat.AbstractBoat>) e[1];
			AetherItems.put(n, new PolyBoatItem(type, new Item.Properties().stacksTo(1).setId(ResourceKey.create(Registries.ITEM, id)), (Item) e[2], id));
		}
	}
}
