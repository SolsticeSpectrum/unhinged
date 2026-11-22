package com.kestrel.maether.machine;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.kestrel.maether.block.AetherBlock;
import com.kestrel.maether.block.AetherBlocks;
import eu.pb4.polymer.blocks.api.BlockModelType;
import eu.pb4.polymer.blocks.api.PolymerBlockModel;
import eu.pb4.polymer.core.api.block.PolymerBlockUtils;
import eu.pb4.sgui.api.elements.GuiElementBuilder;
import eu.pb4.sgui.api.gui.SimpleGui;
import net.minecraft.core.BlockPos;
import net.minecraft.core.NonNullList;
import net.minecraft.core.Registry;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.core.registries.Registries;
import net.minecraft.network.chat.Component;
import net.minecraft.resources.Identifier;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.tags.TagKey;
import net.minecraft.world.Container;
import net.minecraft.world.ContainerHelper;
import net.minecraft.world.InteractionResult;
import net.minecraft.world.SimpleContainer;
import net.minecraft.world.entity.EntitySpawnReason;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.inventory.MenuType;
import net.minecraft.world.inventory.Slot;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.EntityBlock;
import net.minecraft.world.level.block.entity.BlockEntity;
import net.minecraft.world.level.block.entity.BlockEntityTicker;
import net.minecraft.world.level.block.entity.BlockEntityType;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.level.storage.ValueInput;
import net.minecraft.world.level.storage.ValueOutput;
import net.minecraft.world.phys.BlockHitResult;

import java.io.InputStreamReader;
import java.util.*;

/** Altar (enchanting/repair), Freezer, Incubator: furnace-like block entities with an sgui screen. */
public final class Machines {
	public enum Kind { ALTAR, FREEZER, INCUBATOR }

	record Recipe(String in, Identifier out, int n, int time) {}

	private static final Map<Kind, List<Recipe>> RECIPES = new EnumMap<>(Kind.class);
	private static final Map<Kind, Map<Identifier, Integer>> FUEL = new EnumMap<>(Kind.class);
	private static final Map<Kind, Map<String, Identifier>> ENTITY = new EnumMap<>(Kind.class);
	private static final List<Recipe> REPAIR = new ArrayList<>();
	public static BlockEntityType<Machine> TYPE;

	private Machines() {}

	private static boolean matches(String spec, ItemStack s) {
		if (s.isEmpty()) return false;
		if (spec.startsWith("item:")) return BuiltInRegistries.ITEM.getKey(s.getItem()).toString().equals(spec.substring(5));
		return s.is(TagKey.create(Registries.ITEM, Identifier.parse(spec.substring(4))));
	}

	public static class Block extends net.minecraft.world.level.block.Block implements EntityBlock, eu.pb4.polymer.core.api.block.PolymerBlock {
		final Kind kind;
		private final net.minecraft.world.level.block.state.BlockState visual;
		public Block(Properties p, Kind kind, PolymerBlockModel model) {
			super(p); this.kind = kind;
			this.visual = eu.pb4.polymer.blocks.api.PolymerBlockResourceUtils.requestBlock(BlockModelType.FULL_BLOCK, model);
		}
		@Override public net.minecraft.world.level.block.state.BlockState getPolymerBlockState(BlockState s, net.fabricmc.fabric.api.networking.v1.context.PacketContext c) { return visual; }
		@Override public BlockEntity newBlockEntity(BlockPos pos, BlockState state) { return new Machine(pos, state, kind); }
		@Override public <T extends BlockEntity> BlockEntityTicker<T> getTicker(Level level, BlockState state, BlockEntityType<T> type) {
			if (level.isClientSide() || type != TYPE) return null;
			return (l, p, s, be) -> ((Machine) be).tick((ServerLevel) l);
		}
		@Override protected InteractionResult useWithoutItem(BlockState s, Level level, BlockPos pos, Player pl, BlockHitResult hit) {
			if (level.getBlockEntity(pos) instanceof Machine m && pl instanceof ServerPlayer sp) { m.open(sp); return InteractionResult.SUCCESS; }
			return InteractionResult.PASS;
		}
		@Override protected void affectNeighborsAfterRemoval(BlockState s, ServerLevel level, BlockPos pos, boolean moved) {
			// contents are dropped in Machine#preRemoveSideEffects
		}
	}

	public static class Machine extends BlockEntity {
		final Kind kind;
		final SimpleContainer inv = new SimpleContainer(3); // 0 input, 1 fuel, 2 output
		int burn, burnMax, progress;

		public Machine(BlockPos pos, BlockState state, Kind kind) { super(TYPE, pos, state); this.kind = kind; }

		@Override protected void saveAdditional(ValueOutput out) {
			super.saveAdditional(out);
			NonNullList<ItemStack> l = NonNullList.withSize(3, ItemStack.EMPTY);
			for (int i = 0; i < 3; i++) l.set(i, inv.getItem(i));
			ContainerHelper.saveAllItems(out, l);
			out.putInt("burn", burn); out.putInt("burnMax", burnMax); out.putInt("progress", progress);
		}
		@Override protected void loadAdditional(ValueInput in) {
			super.loadAdditional(in);
			NonNullList<ItemStack> l = NonNullList.withSize(3, ItemStack.EMPTY);
			ContainerHelper.loadAllItems(in, l);
			for (int i = 0; i < 3; i++) inv.setItem(i, l.get(i));
			burn = in.getIntOr("burn", 0); burnMax = in.getIntOr("burnMax", 0); progress = in.getIntOr("progress", 0);
		}
		@Override public void preRemoveSideEffects(BlockPos pos, BlockState state) {
			super.preRemoveSideEffects(pos, state);
			if (level != null) net.minecraft.world.Containers.dropContents(level, pos, inv);
		}

		Recipe find(ItemStack in) {
			for (Recipe r : RECIPES.get(kind)) if (matches(r.in, in)) return r;
			if (kind == Kind.ALTAR && in.isDamaged()) for (Recipe r : REPAIR) if (matches(r.in, in)) return r;
			return null;
		}

		int fuelTime(ItemStack s) { return s.isEmpty() ? 0 : FUEL.get(kind).getOrDefault(BuiltInRegistries.ITEM.getKey(s.getItem()), 0); }

		void tick(ServerLevel level) {
			ItemStack in = inv.getItem(0), fuel = inv.getItem(1), out = inv.getItem(2);
			Recipe r = find(in);
			boolean can = r != null && canOutput(r, in, out);
			if (burn > 0) burn--;
			if (can && burn <= 0 && fuelTime(fuel) > 0) { burn = burnMax = fuelTime(fuel); fuel.shrink(1); setChanged(); }
			if (can && burn > 0) {
				if (++progress >= r.time) { progress = 0; finish(level, r, in, out); setChanged(); }
			} else if (progress > 0 && !can) progress = Math.max(0, progress - 2);
		}

		boolean canOutput(Recipe r, ItemStack in, ItemStack out) {
			if (kind == Kind.INCUBATOR) return ENTITY.get(kind).containsKey(r.in);
			if (r.out == null) return true; // repair
			Item it = BuiltInRegistries.ITEM.getOptional(r.out).orElse(null);
			if (it == null) return false;
			return out.isEmpty() || (out.is(it) && out.getCount() + r.n <= out.getMaxStackSize());
		}

		void finish(ServerLevel level, Recipe r, ItemStack in, ItemStack out) {
			if (kind == Kind.INCUBATOR) {
				var type = BuiltInRegistries.ENTITY_TYPE.getOptional(ENTITY.get(kind).get(r.in)).orElse(null);
				if (type != null) {
					var e = type.create(level, EntitySpawnReason.SPAWNER);
					if (e instanceof net.minecraft.world.entity.AgeableMob am) am.setAge(-24000);
					if (e != null) { e.setPos(worldPosition.getX() + 0.5, worldPosition.getY() + 1.0, worldPosition.getZ() + 0.5); level.addFreshEntity(e); }
				}
				in.shrink(1); return;
			}
			if (r.out == null) { in.setDamageValue(0); return; } // altar repair
			Item it = BuiltInRegistries.ITEM.getOptional(r.out).orElse(Items.AIR);
			if (out.isEmpty()) inv.setItem(2, new ItemStack(it, r.n)); else out.grow(r.n);
			in.shrink(1);
		}

		void open(ServerPlayer p) {
			var self = this;
			SimpleGui gui = new SimpleGui(MenuType.GENERIC_9x3, p, false) {
				@Override public void onTick() {
					int pct = self.progress == 0 ? 0 : 100;
					Recipe r = self.find(self.inv.getItem(0));
					if (r != null && r.time > 0) pct = Math.min(100, self.progress * 100 / r.time);
					setSlot(13, new GuiElementBuilder(Items.ARROW).setName(Component.literal("Progress: " + pct + "%")).addLoreLine(Component.literal(self.burn > 0 ? "Burning: " + self.burn / 20 + "s" : "No fuel")));
				}
			};
			gui.setTitle(Component.literal(switch (kind) { case ALTAR -> "Altar"; case FREEZER -> "Freezer"; case INCUBATOR -> "Incubator"; }));
			for (int i = 0; i < 27; i++) gui.setSlot(i, new GuiElementBuilder(Items.IRON_BARS).setName(Component.empty()));
			gui.setSlot(10, new Slot(inv, 0, 0, 0));
			gui.setSlot(12, new Slot(inv, 1, 0, 0) { @Override public boolean mayPlace(ItemStack s) { return self.fuelTime(s) > 0; } });
			gui.setSlot(16, new Slot(inv, 2, 0, 0) { @Override public boolean mayPlace(ItemStack s) { return false; } });
			gui.open();
		}
	}

	public static void init() {
		try (var in = Machines.class.getResourceAsStream("/maether/machines.json")) {
			JsonObject root = JsonParser.parseReader(new InputStreamReader(in)).getAsJsonObject();
			for (Kind k : Kind.values()) {
				JsonObject o = root.getAsJsonObject(k.name().toLowerCase());
				List<Recipe> l = new ArrayList<>(); Map<Identifier, Integer> fuel = new HashMap<>(); Map<String, Identifier> ent = new HashMap<>();
				for (var e : o.getAsJsonArray("recipes")) {
					JsonObject r = e.getAsJsonObject();
					if (k == Kind.INCUBATOR) { ent.put(r.get("in").getAsString(), Identifier.parse(r.get("entity").getAsString())); l.add(new Recipe(r.get("in").getAsString(), null, 1, r.get("time").getAsInt())); }
					else l.add(new Recipe(r.get("in").getAsString(), Identifier.parse(r.get("out").getAsString()), r.get("n").getAsInt(), r.get("time").getAsInt()));
				}
				for (var e : o.getAsJsonObject("fuel").entrySet()) fuel.put(Identifier.parse(e.getKey()), e.getValue().getAsInt());
				if (k == Kind.ALTAR) for (var e : o.getAsJsonArray("repair")) { JsonObject r = e.getAsJsonObject(); REPAIR.add(new Recipe(r.get("in").getAsString(), null, 1, r.get("time").getAsInt())); }
				RECIPES.put(k, l); FUEL.put(k, fuel); ENTITY.put(k, ent);
			}
		} catch (java.io.IOException e) { throw new RuntimeException(e); }
		var blocks = new net.minecraft.world.level.block.Block[]{AetherBlocks.ALL.get("altar"), AetherBlocks.ALL.get("freezer"), AetherBlocks.ALL.get("incubator")};
		TYPE = Registry.register(BuiltInRegistries.BLOCK_ENTITY_TYPE, Identifier.fromNamespaceAndPath("aether", "machine"),
			net.fabricmc.fabric.api.object.builder.v1.block.entity.FabricBlockEntityTypeBuilder.<Machine>create((pos, st) -> new Machine(pos, st,
				((Block) st.getBlock()).kind), blocks).build());
		PolymerBlockUtils.registerBlockEntity(TYPE);
	}
}
