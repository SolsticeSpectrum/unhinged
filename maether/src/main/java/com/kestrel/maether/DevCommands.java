package com.kestrel.maether;

import com.kestrel.maether.portal.AetherPortals;
import com.mojang.brigadier.arguments.IntegerArgumentType;
import net.fabricmc.fabric.api.command.v2.CommandRegistrationCallback;
import net.minecraft.commands.Commands;
import net.minecraft.core.BlockPos;
import net.minecraft.network.chat.Component;

/** Development-only helpers (registered only in a Fabric dev environment). */
final class DevCommands {
	private DevCommands() {}

	static void register() {
		CommandRegistrationCallback.EVENT.register((dispatcher, ctx, env) -> dispatcher.register(
			Commands.literal("maether").requires(s -> s.permissions().hasPermission(net.minecraft.server.permissions.Permissions.COMMANDS_GAMEMASTER))
				.then(Commands.literal("heights")
					.then(Commands.argument("x", IntegerArgumentType.integer())
						.then(Commands.argument("z", IntegerArgumentType.integer()).executes(c -> {
							var level = c.getSource().getLevel();
							int x = IntegerArgumentType.getInteger(c, "x"), z = IntegerArgumentType.getInteger(c, "z");
							var hs = net.minecraft.world.level.levelgen.Heightmap.Types.values();
							var sb = new StringBuilder();
							for (var h : hs) sb.append(h.name()).append('=').append(level.getHeight(h, x, z)).append(' ');
							var holy = com.kestrel.maether.block.AetherBlocks.ALL.get("holystone").defaultBlockState();
							sb.append("| holystone solid=").append(holy.isSolid()).append(" stone solid=").append(net.minecraft.world.level.block.Blocks.STONE.defaultBlockState().isSolid());
							c.getSource().sendSuccess(() -> Component.literal(sb.toString()), false);
							return 1;
						}))))
				.then(Commands.literal("scan").executes(c -> {
					var level = c.getSource().getLevel();
					var sb = new StringBuilder();
					for (var h : net.minecraft.world.level.levelgen.Heightmap.Types.values()) {
						int nz = 0, max = 0;
						for (int x = 0; x < 128; x++) for (int z = 0; z < 128; z++) { int v = level.getHeight(h, x, z); if (v > 0) nz++; max = Math.max(max, v); }
						sb.append(h.name()).append(": columns>0=").append(nz).append(" max=").append(max).append("; ");
					}
					c.getSource().sendSuccess(() -> Component.literal(sb.toString()), false);
					return 1;
				}))
				.then(Commands.literal("states").executes(c -> {
					var sb = new StringBuilder();
					for (var t : new eu.pb4.polymer.blocks.api.BlockModelType[]{eu.pb4.polymer.blocks.api.BlockModelType.FULL_BLOCK, eu.pb4.polymer.blocks.api.BlockModelType.LEAVES,
						eu.pb4.polymer.blocks.api.BlockModelType.PLANT, eu.pb4.polymer.blocks.api.BlockModelType.BIOME_COLORED_LEAVES})
						sb.append(t.name()).append(" left=").append(eu.pb4.polymer.blocks.api.PolymerBlockResourceUtils.getBlocksLeft(t)).append("; ");
					c.getSource().sendSuccess(() -> Component.literal(sb.toString()), false);
					return 1;
				}))
				.then(Commands.literal("dump").executes(c -> {
					var sb = new StringBuilder();
					for (var k : net.minecraft.core.registries.BuiltInRegistries.BLOCK.keySet()) if (k.getNamespace().equals("aether")) sb.append("block ").append(k.getPath()).append('\n');
					for (var k : net.minecraft.core.registries.BuiltInRegistries.ITEM.keySet()) if (k.getNamespace().equals("aether")) sb.append("item ").append(k.getPath()).append('\n');
					for (var k : net.minecraft.core.registries.BuiltInRegistries.ENTITY_TYPE.keySet()) if (k.getNamespace().equals("aether")) sb.append("entity ").append(k.getPath()).append('\n');
					try { java.nio.file.Files.writeString(java.nio.file.Path.of("aether_registry.txt"), sb.toString()); } catch (java.io.IOException e) { throw new RuntimeException(e); }
					c.getSource().sendSuccess(() -> Component.literal("dumped"), false);
					return 1;
				}))
				.then(Commands.literal("light")
					.then(Commands.argument("x", IntegerArgumentType.integer())
						.then(Commands.argument("y", IntegerArgumentType.integer())
							.then(Commands.argument("z", IntegerArgumentType.integer()).executes(c -> {
								var pos = new BlockPos(IntegerArgumentType.getInteger(c, "x"), IntegerArgumentType.getInteger(c, "y"), IntegerArgumentType.getInteger(c, "z"));
								boolean ok = AetherPortals.tryLight(c.getSource().getLevel(), pos);
								c.getSource().sendSuccess(() -> Component.literal(ok ? "portal lit" : "no valid frame"), false);
								return ok ? 1 : 0;
							})))))));
	}
}
