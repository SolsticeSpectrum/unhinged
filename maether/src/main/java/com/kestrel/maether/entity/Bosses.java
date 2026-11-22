package com.kestrel.maether.entity;

import eu.pb4.polymer.core.api.entity.PolymerEntity;
import eu.pb4.polymer.virtualentity.api.ElementHolder;
import eu.pb4.polymer.virtualentity.api.attachment.EntityAttachment;
import eu.pb4.polymer.virtualentity.api.elements.ItemDisplayElement;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.core.BlockPos;
import net.minecraft.core.component.DataComponents;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.network.chat.Component;
import net.minecraft.network.syncher.EntityDataAccessor;
import net.minecraft.network.syncher.SynchedEntityData;
import net.minecraft.resources.Identifier;
import net.minecraft.server.level.ServerBossEvent;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.BossEvent;
import net.minecraft.world.damagesource.DamageSource;
import net.minecraft.world.effect.MobEffectInstance;
import net.minecraft.world.effect.MobEffects;
import net.minecraft.world.entity.*;
import net.minecraft.world.entity.ai.goal.*;
import net.minecraft.world.entity.ai.goal.target.HurtByTargetGoal;
import net.minecraft.world.entity.ai.goal.target.NearestAttackableTargetGoal;
import net.minecraft.world.entity.monster.Monster;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.block.Blocks;
import net.minecraft.world.level.block.state.BlockState;
import net.minecraft.world.phys.AABB;
import net.minecraft.world.phys.Vec3;
import org.joml.Vector3f;

import java.util.List;

/** Dungeon bosses: Slider, Valkyrie Queen, Sun Spirit (+ Valkyrie and Mimic guards). */
public final class Bosses {
	private Bosses() {}

	/** Common boss: bar, no despawn, immovable by players, opens the dungeon doorways when it dies. */
	public abstract static class Boss extends Monster implements PolymerEntity {
		protected final ServerBossEvent bar;
		protected int ticks;

		protected Boss(EntityType<? extends Monster> t, Level l, BossEvent.BossBarColor color) {
			super(t, l);
			this.bar = new ServerBossEvent(java.util.UUID.randomUUID(), getDisplayName(), color, BossEvent.BossBarOverlay.PROGRESS);
			this.setPersistenceRequired();
		}
		@Override public boolean removeWhenFarAway(double d) { return false; }
		@Override public void startSeenByPlayer(ServerPlayer p) { super.startSeenByPlayer(p); bar.addPlayer(p); }
		@Override public void stopSeenByPlayer(ServerPlayer p) { super.stopSeenByPlayer(p); bar.removePlayer(p); }
		@Override protected void customServerAiStep(ServerLevel level) {
			super.customServerAiStep(level);
			bar.setProgress(getHealth() / getMaxHealth());
			ticks++;
		}
		@Override public boolean causeFallDamage(double d, float m, DamageSource s) { return false; }
		@Override public void die(DamageSource source) {
			super.die(source);
			if (level() instanceof ServerLevel sl) openDoorways(sl, blockPosition(), 28);
		}
	}

	/** Removes every boss/treasure doorway block (and locked blocks) near the boss: the fight is over. */
	public static void openDoorways(ServerLevel level, BlockPos center, int r) {
		for (BlockPos p : BlockPos.betweenClosed(center.offset(-r, -r, -r), center.offset(r, r, r))) {
			var id = BuiltInRegistries.BLOCK.getKey(level.getBlockState(p).getBlock());
			if (id.getNamespace().equals("aether") && (id.getPath().startsWith("boss_doorway_") || id.getPath().startsWith("treasure_doorway_")))
				level.setBlock(p.immutable(), Blocks.AIR.defaultBlockState(), 3);
		}
	}

	protected static <T extends LivingEntity> List<Player> nearbyPlayers(LivingEntity e, double r) {
		return e.level().getEntitiesOfClass(Player.class, e.getBoundingBox().inflate(r), p -> !p.isSpectator() && p.isAlive());
	}

	// ---------------------------------------------------------------- Slider
	/** A stone cube that sleeps until hit, then slides along axes at its target; hurts anything it crashes into. */
	public static class Slider extends Boss {
		private boolean awake;
		private int dashTicks, cooldown;
		private Vec3 dir = Vec3.ZERO;
		private ElementHolder holder;

		public Slider(EntityType<? extends Monster> t, Level l) {
			super(t, l, BossEvent.BossBarColor.RED);
			setNoGravity(false);
			attach();
		}
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.SLIME; }
		@Override public void modifyRawTrackedData(List<SynchedEntityData.DataValue<?>> data, ServerPlayer player, boolean initial) {
			data.removeIf(d -> d.id() == 0 || d.id() == 16); // flags, slime size
			data.add(SynchedEntityData.DataValue.create(new EntityDataAccessor<>(0, net.minecraft.network.syncher.EntityDataSerializers.BYTE), (byte) 0x20)); // invisible
			data.add(SynchedEntityData.DataValue.create(new EntityDataAccessor<>(16, net.minecraft.network.syncher.EntityDataSerializers.INT), 4)); // hitbox ~2 blocks
		}
		private void attach() {
			holder = new ElementHolder();
			ItemStack stack = new ItemStack(Items.STONE);
			stack.set(DataComponents.ITEM_MODEL, Identifier.fromNamespaceAndPath("aether", "carved_stone"));
			ItemDisplayElement cube = new ItemDisplayElement(stack);
			cube.setScale(new Vector3f(2.1F, 2.1F, 2.1F));
			cube.setOffset(new Vec3(0, 1.05, 0));
			holder.addElement(cube);
			EntityAttachment.ofTicking(holder, this);
		}
		@Override public boolean hurtServer(ServerLevel level, DamageSource source, float amount) {
			if (!awake && source.getEntity() instanceof Player) { awake = true; level.playSound(null, blockPosition(), net.minecraft.sounds.SoundEvents.IRON_GOLEM_ATTACK, net.minecraft.sounds.SoundSource.HOSTILE, 2F, 0.5F); }
			return awake && super.hurtServer(level, source, amount * 0.6F);
		}
		@Override public void aiStep() {
			super.aiStep();
			if (!(level() instanceof ServerLevel sl) || !awake) return;
			float speed = 0.6F + 0.6F * (1.0F - getHealth() / getMaxHealth()); // faster as it gets hurt
			if (cooldown > 0) { cooldown--; return; }
			if (dashTicks <= 0) {
				var ps = nearbyPlayers(this, 40);
				if (ps.isEmpty()) return;
				Vec3 d = ps.get(0).position().subtract(position());
				dir = Math.abs(d.x) > Math.abs(d.z) ? new Vec3(Math.signum(d.x), 0, 0) : new Vec3(0, 0, Math.signum(d.z));
				dashTicks = 24;
			}
			move(MoverType.SELF, dir.scale(speed));
			dashTicks--;
			for (Entity e : sl.getEntities(this, getBoundingBox().inflate(0.2), x -> x instanceof LivingEntity && !(x instanceof Boss))) {
				e.hurtServer(sl, damageSources().mobAttack(this), 6.0F);
				e.push(dir.x * 1.2, 0.5, dir.z * 1.2); e.needsSync = true;
			}
			if (horizontalCollision) { dashTicks = 0; cooldown = 30; sl.playSound(null, blockPosition(), net.minecraft.sounds.SoundEvents.GENERIC_EXPLODE.value(), net.minecraft.sounds.SoundSource.HOSTILE, 1.0F, 1.4F); }
		}
		@Override public boolean isPushable() { return false; }
		@Override public void push(double x, double y, double z) {}
	}

	// ---------------------------------------------------------------- Valkyrie (+Queen)
	public static class Valkyrie extends Monster implements PolymerEntity {
		public Valkyrie(EntityType<? extends Monster> t, Level l) { super(t, l); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.VINDICATOR; }
		@Override protected void registerGoals() {
			goalSelector.addGoal(1, new FloatGoal(this));
			goalSelector.addGoal(2, new MeleeAttackGoal(this, 1.2, false));
			goalSelector.addGoal(5, new WaterAvoidingRandomStrollGoal(this, 0.9));
			goalSelector.addGoal(6, new LookAtPlayerGoal(this, Player.class, 10F));
			targetSelector.addGoal(1, new HurtByTargetGoal(this));
			targetSelector.addGoal(2, new NearestAttackableTargetGoal<>(this, Player.class, true));
		}
		@Override public boolean causeFallDamage(double d, float m, DamageSource s) { return false; }
	}

	public static class ValkyrieQueen extends Boss {
		public ValkyrieQueen(EntityType<? extends Monster> t, Level l) { super(t, l, BossEvent.BossBarColor.PURPLE); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.WITCH; }
		@Override protected void registerGoals() {
			goalSelector.addGoal(1, new FloatGoal(this));
			goalSelector.addGoal(2, new MeleeAttackGoal(this, 1.3, false));
			goalSelector.addGoal(5, new WaterAvoidingRandomStrollGoal(this, 0.9));
			goalSelector.addGoal(6, new LookAtPlayerGoal(this, Player.class, 12F));
			targetSelector.addGoal(1, new HurtByTargetGoal(this));
			targetSelector.addGoal(2, new NearestAttackableTargetGoal<>(this, Player.class, true));
		}
		@Override protected void customServerAiStep(ServerLevel level) {
			super.customServerAiStep(level);
			LivingEntity t = getTarget();
			if (t == null) return;
			if (ticks % 120 == 0) { // blink next to the target
				teleportTo(t.getX() + (random.nextDouble() - 0.5) * 6, t.getY(), t.getZ() + (random.nextDouble() - 0.5) * 6);
			}
			if (ticks % 90 == 45) { // call lightning on the target
				var bolt = EntityTypes.LIGHTNING_BOLT.create(level, EntitySpawnReason.TRIGGERED);
				if (bolt != null) { bolt.snapTo(t.position()); level.addFreshEntity(bolt); }
			}
			if (getHealth() < getMaxHealth() * 0.5F && ticks % 200 == 0) { // enrage: summon a valkyrie guard
				var v = com.kestrel.maether.entity.AetherEntities.ALL.get("valkyrie");
				if (v != null) { Entity e = v.create(level, EntitySpawnReason.MOB_SUMMONED); if (e != null) { e.snapTo(position()); level.addFreshEntity(e); } }
			}
		}
	}

	// ---------------------------------------------------------------- Sun Spirit
	public static class SunSpirit extends Boss {
		public SunSpirit(EntityType<? extends Monster> t, Level l) { super(t, l, BossEvent.BossBarColor.YELLOW); setNoGravity(true); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.BLAZE; }
		@Override protected void registerGoals() {
			goalSelector.addGoal(7, new LookAtPlayerGoal(this, Player.class, 30F));
			targetSelector.addGoal(1, new HurtByTargetGoal(this));
			targetSelector.addGoal(2, new NearestAttackableTargetGoal<>(this, Player.class, true));
		}
		@Override protected void customServerAiStep(ServerLevel level) {
			super.customServerAiStep(level);
			LivingEntity t = getTarget();
			if (t == null) return;
			// hover 4 blocks above and circle the target
			double ang = ticks * 0.05;
			Vec3 want = new Vec3(t.getX() + Math.cos(ang) * 9, t.getY() + 4, t.getZ() + Math.sin(ang) * 9);
			setDeltaMovement(getDeltaMovement().scale(0.8).add(want.subtract(position()).scale(0.02)));
			int period = getHealth() < getMaxHealth() * 0.5F ? 25 : 45;
			if (ticks % period == 0) {
				Vec3 d = t.getEyePosition().subtract(position().add(0, 1.5, 0)).normalize();
				if ((ticks / period) % 2 == 0) {
					var fb = new net.minecraft.world.entity.projectile.hurtingprojectile.SmallFireball(level, this, d);
					fb.setPos(getX(), getY() + 1.5, getZ()); level.addFreshEntity(fb);
				} else { // "ice crystal": freezing snowball
					t.addEffect(new MobEffectInstance(MobEffects.SLOWNESS, 60, 1));
					var sb = new net.minecraft.world.entity.projectile.throwableitemprojectile.Snowball(level, this, new ItemStack(Items.SNOWBALL));
					sb.setPos(getX(), getY() + 1.5, getZ()); sb.shoot(d.x, d.y, d.z, 1.6F, 0.5F); level.addFreshEntity(sb);
				}
			}
		}
		@Override public boolean isOnFire() { return false; }
	}

	// ---------------------------------------------------------------- Mimic
	public static class Mimic extends Monster implements PolymerEntity {
		public Mimic(EntityType<? extends Monster> t, Level l) { super(t, l); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.HUSK; }
		@Override protected void registerGoals() {
			goalSelector.addGoal(1, new FloatGoal(this));
			goalSelector.addGoal(2, new MeleeAttackGoal(this, 1.3, false));
			goalSelector.addGoal(5, new WaterAvoidingRandomStrollGoal(this, 0.8));
			targetSelector.addGoal(1, new HurtByTargetGoal(this));
			targetSelector.addGoal(2, new NearestAttackableTargetGoal<>(this, Player.class, true));
		}
	}
}
