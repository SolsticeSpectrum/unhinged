package com.kestrel.maether.acc;

import com.kestrel.maether.item.AetherItems;
import com.kestrel.maether.item.PolyItem;
import com.mojang.serialization.Codec;
import eu.pb4.sgui.api.gui.SimpleGui;
import net.fabricmc.fabric.api.attachment.v1.AttachmentRegistry;
import net.fabricmc.fabric.api.attachment.v1.AttachmentType;
import net.fabricmc.fabric.api.command.v2.CommandRegistrationCallback;
import net.fabricmc.fabric.api.entity.event.v1.ServerLivingEntityEvents;
import net.fabricmc.fabric.api.event.lifecycle.v1.ServerTickEvents;
import net.minecraft.commands.Commands;
import net.minecraft.core.Holder;
import net.minecraft.network.chat.Component;
import net.minecraft.resources.Identifier;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.tags.DamageTypeTags;
import net.minecraft.world.InteractionResult;
import net.minecraft.world.SimpleContainer;
import net.minecraft.world.effect.MobEffectInstance;
import net.minecraft.world.effect.MobEffects;
import net.minecraft.world.entity.ai.attributes.Attribute;
import net.minecraft.world.entity.ai.attributes.AttributeModifier;
import net.minecraft.world.entity.ai.attributes.Attributes;
import net.minecraft.world.inventory.MenuType;
import net.minecraft.world.inventory.Slot;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;

import java.util.*;

/** Accessory slots (rings, pendants, gloves, capes, shield, misc) backed by a persistent player attachment. */
public final class Accessories {
	public enum Kind { RING, PENDANT, CAPE, GLOVES, SHIELD, MISC }

	/** slot layout of the GUI */
	public static final Kind[] LAYOUT = {Kind.RING, Kind.RING, Kind.PENDANT, Kind.CAPE, Kind.GLOVES, Kind.SHIELD, Kind.MISC, Kind.MISC};

	private record Spec(Kind kind, Map<Holder<Attribute>, Double> attrs, List<MobEffectInstance> effects) {}

	private static final Map<Item, Spec> SPECS = new HashMap<>();
	private static final List<String> NAMES = new ArrayList<>();
	public static AttachmentType<List<ItemStack>> STORE;

	private Accessories() {}

	private static MobEffectInstance eff(Holder<net.minecraft.world.effect.MobEffect> e, int amp) { return new MobEffectInstance(e, 100, amp, true, false); }

	private static void acc(String name, Kind kind, Map<Holder<Attribute>, Double> attrs, MobEffectInstance... effects) {
		Identifier id = Identifier.fromNamespaceAndPath("aether", name);
		PolyItem item = new PolyItem(new Item.Properties().stacksTo(1).setId(net.minecraft.resources.ResourceKey.create(net.minecraft.core.registries.Registries.ITEM, id)),
			Items.PAPER, id, (level, p, hand, stack) -> equip(p, stack) ? InteractionResult.SUCCESS : InteractionResult.PASS, null);
		AetherItems.put(name, item);
		SPECS.put(item, new Spec(kind, attrs, List.of(effects)));
		NAMES.add(name);
	}

	private static Map<Holder<Attribute>, Double> a(Holder<Attribute> k, double v) { return Map.of(k, v); }

	public static List<ItemStack> get(ServerPlayer p) { return new ArrayList<>(p.getAttachedOrCreate(STORE)); }

	public static void save(ServerPlayer p, List<ItemStack> l) { p.setAttached(STORE, List.copyOf(l)); }

	public static Kind kindOf(ItemStack s) { Spec sp = SPECS.get(s.getItem()); return sp == null ? null : sp.kind; }

	public static boolean equip(net.minecraft.world.entity.player.Player pl, ItemStack stack) {
		if (!(pl instanceof ServerPlayer p)) return false;
		Kind k = kindOf(stack);
		List<ItemStack> l = get(p);
		for (int i = 0; i < LAYOUT.length; i++) {
			if (LAYOUT[i] == k && l.get(i).isEmpty()) {
				l.set(i, stack.copyWithCount(1)); save(p, l); stack.shrink(1); return true;
			}
		}
		return false;
	}

	public static void init() {
		STORE = AttachmentRegistry.create(Identifier.fromNamespaceAndPath("aether", "accessories"), b -> b
			.persistent(ItemStack.OPTIONAL_CODEC.listOf())
			.copyOnDeath()
			.initializer(() -> new ArrayList<>(Collections.nCopies(LAYOUT.length, ItemStack.EMPTY))));

		acc("iron_ring", Kind.RING, a(Attributes.ARMOR, 1.0));
		acc("golden_ring", Kind.RING, a(Attributes.LUCK, 1.0));
		acc("zanite_ring", Kind.RING, a(Attributes.MINING_EFFICIENCY, 2.0));
		acc("ice_ring", Kind.RING, a(Attributes.KNOCKBACK_RESISTANCE, 0.2));
		acc("iron_pendant", Kind.PENDANT, a(Attributes.ARMOR_TOUGHNESS, 1.0));
		acc("golden_pendant", Kind.PENDANT, a(Attributes.MAX_HEALTH, 2.0));
		acc("zanite_pendant", Kind.PENDANT, a(Attributes.ATTACK_SPEED, 0.2));
		acc("ice_pendant", Kind.PENDANT, a(Attributes.KNOCKBACK_RESISTANCE, 0.3));
		Object[][] gloves = {{"leather", 0.5}, {"chainmail", 1.0}, {"iron", 1.5}, {"golden", 1.0}, {"diamond", 2.0}, {"netherite", 3.0},
			{"zanite", 1.5}, {"gravitite", 2.5}, {"valkyrie", 2.5}, {"neptune", 1.5}, {"phoenix", 2.5}, {"obsidian", 3.0}};
		for (Object[] g : gloves) acc(g[0] + "_gloves", Kind.GLOVES, a(Attributes.ARMOR, (Double) g[1]));
		for (String c : new String[]{"red_cape", "blue_cape", "yellow_cape", "white_cape", "swet_cape"}) acc(c, Kind.CAPE, Map.of());
		acc("agility_cape", Kind.CAPE, a(Attributes.STEP_HEIGHT, 1.0));
		acc("invisibility_cloak", Kind.CAPE, Map.of(), eff(MobEffects.INVISIBILITY, 0));
		acc("valkyrie_cape", Kind.CAPE, Map.of(), eff(MobEffects.SLOW_FALLING, 0));
		acc("golden_feather", Kind.MISC, Map.of(), eff(MobEffects.SLOW_FALLING, 0));
		acc("regeneration_stone", Kind.MISC, Map.of(), eff(MobEffects.REGENERATION, 0));
		acc("iron_bubble", Kind.MISC, Map.of(), eff(MobEffects.WATER_BREATHING, 0));
		acc("shield_of_repulsion", Kind.SHIELD, Map.of());

		ServerTickEvents.END_SERVER_TICK.register(server -> {
			if (server.getTickCount() % 20 != 0) return;
			for (ServerPlayer p : server.getPlayerList().getPlayers()) apply(p);
		});
		// Shield of Repulsion: projectiles do nothing while standing still
		ServerLivingEntityEvents.ALLOW_DAMAGE.register((entity, source, amount) -> {
			if (entity instanceof ServerPlayer p && source.is(DamageTypeTags.IS_PROJECTILE)
				&& p.getDeltaMovement().horizontalDistanceSqr() < 0.0004) {
				for (ItemStack s : get(p)) if (!s.isEmpty() && s.getItem() == AetherItems.ALL.get("shield_of_repulsion")) return false;
			}
			return true;
		});
		CommandRegistrationCallback.EVENT.register((d, c, env) -> d.register(Commands.literal("accessories").executes(ctx -> {
			open(ctx.getSource().getPlayerOrException()); return 1;
		})));
	}

	private static void apply(ServerPlayer p) {
		Map<Holder<Attribute>, Double> sum = new HashMap<>();
		for (ItemStack s : get(p)) {
			Spec sp = SPECS.get(s.getItem());
			if (sp == null) continue;
			sp.attrs.forEach((k, v) -> sum.merge(k, v, Double::sum));
			for (MobEffectInstance e : sp.effects) p.addEffect(new MobEffectInstance(e));
		}
		for (Holder<Attribute> attr : TRACKED) {
			var inst = p.getAttribute(attr);
			if (inst == null) continue;
			Identifier mid = Identifier.fromNamespaceAndPath("aether", "acc");
			Double v = sum.get(attr);
			if (v == null) inst.removeModifier(mid);
			else inst.addOrReplacePermanentModifier(new AttributeModifier(mid, v, AttributeModifier.Operation.ADD_VALUE));
		}
	}

	private static final List<Holder<Attribute>> TRACKED = List.of(Attributes.ARMOR, Attributes.LUCK, Attributes.MINING_EFFICIENCY, Attributes.KNOCKBACK_RESISTANCE,
		Attributes.ARMOR_TOUGHNESS, Attributes.MAX_HEALTH, Attributes.ATTACK_SPEED, Attributes.STEP_HEIGHT);

	public static void open(ServerPlayer p) {
		SimpleContainer inv = new SimpleContainer(LAYOUT.length);
		List<ItemStack> l = get(p);
		for (int i = 0; i < LAYOUT.length; i++) inv.setItem(i, l.get(i));
		SimpleGui gui = new SimpleGui(MenuType.GENERIC_9x1, p, false) {
			@Override public void onPlayerClose(boolean success) { List<ItemStack> out = new ArrayList<>(); for (int i = 0; i < LAYOUT.length; i++) out.add(inv.getItem(i)); save(p, out); apply(p); }
		};
		gui.setTitle(Component.literal("Accessories: ring, ring, pendant, cape, gloves, shield, misc, misc"));
		for (int i = 0; i < LAYOUT.length; i++) {
			final Kind k = LAYOUT[i];
			gui.setSlot(i, new Slot(inv, i, 0, 0) {
				@Override public boolean mayPlace(ItemStack s) { return kindOf(s) == k; }
				@Override public int getMaxStackSize() { return 1; }
			});
		}
		gui.open();
	}

	public static List<String> names() { return NAMES; }
}
