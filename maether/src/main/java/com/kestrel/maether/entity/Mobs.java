package com.kestrel.maether.entity;

import eu.pb4.polymer.core.api.entity.PolymerEntity;
import net.fabricmc.fabric.api.networking.v1.context.PacketContext;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.world.damagesource.DamageSource;
import net.minecraft.world.effect.MobEffectInstance;
import net.minecraft.world.effect.MobEffects;
import net.minecraft.world.entity.*;
import net.minecraft.world.entity.ai.attributes.AttributeSupplier;
import net.minecraft.world.entity.ai.attributes.Attributes;
import net.minecraft.world.entity.ai.control.FlyingMoveControl;
import net.minecraft.world.entity.ai.goal.*;
import net.minecraft.world.entity.ai.goal.target.HurtByTargetGoal;
import net.minecraft.world.entity.ai.goal.target.NearestAttackableTargetGoal;
import net.minecraft.world.entity.ai.navigation.FlyingPathNavigation;
import net.minecraft.world.entity.ai.navigation.PathNavigation;
import net.minecraft.world.entity.animal.equine.Horse;
import net.minecraft.world.entity.animal.happyghast.HappyGhast;
import net.minecraft.world.entity.animal.sheep.Sheep;
import net.minecraft.world.entity.monster.Blaze;
import net.minecraft.world.entity.monster.Ghast;
import net.minecraft.world.entity.monster.Monster;
import net.minecraft.world.entity.monster.RangedAttackMob;
import net.minecraft.world.entity.monster.cubemob.Slime;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.entity.projectile.Projectile;
import net.minecraft.world.entity.projectile.arrow.Arrow;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.item.Items;
import net.minecraft.world.level.Level;
import net.minecraft.world.phys.AABB;

import java.util.List;

/** Aether mobs: server-side classes on vanilla bases (the client sees the vanilla base entity). */
public final class Mobs {
	private Mobs() {}

	/** Shoots a poison/effect arrow from {@code shooter} at {@code target}. */
	static void shoot(LivingEntity shooter, LivingEntity target, float damage, MobEffectInstance effect) {
		if (!(shooter.level() instanceof ServerLevel sl)) return;
		Arrow a = new Arrow(sl, shooter, new ItemStack(Items.ARROW), ItemStack.EMPTY);
		if (effect != null) a.addEffect(effect);
		a.setBaseDamage(damage);
		double dx = target.getX() - shooter.getX(), dy = target.getY(0.33) - a.getY(), dz = target.getZ() - shooter.getZ();
		Projectile.spawnProjectileUsingShoot(a, sl, ItemStack.EMPTY, dx, dy + Math.sqrt(dx * dx + dz * dz) * 0.1, dz, 1.6F, 6.0F);
	}

	// ---------------- passive ----------------
	public static class Sheepuff extends Sheep implements PolymerEntity {
		public Sheepuff(EntityType<? extends Sheep> t, Level l) { super(t, l); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.SHEEP; }
		@Override public boolean causeFallDamage(double d, float m, DamageSource s) { return false; }
	}

	public static class Moa extends Horse implements PolymerEntity {
		public Moa(EntityType<? extends Horse> t, Level l) { super(t, l); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.HORSE; }
		@Override public boolean causeFallDamage(double d, float m, DamageSource s) { return false; }
		@Override public net.minecraft.world.entity.SpawnGroupData finalizeSpawn(net.minecraft.world.level.ServerLevelAccessor w, net.minecraft.world.DifficultyInstance di,
			EntitySpawnReason r, net.minecraft.world.entity.SpawnGroupData d) {
			var out = super.finalizeSpawn(w, di, r, d);
			this.setTamed(true); // moas are always rideable once saddled
			return out;
		}
	}

	public static class Aerwhale extends HappyGhast implements PolymerEntity {
		public Aerwhale(EntityType<? extends HappyGhast> t, Level l) { super(t, l); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.HAPPY_GHAST; }
		@Override public boolean causeFallDamage(double d, float m, DamageSource s) { return false; }
	}

	// ---------------- hostile ----------------
	public static class Zephyr extends Ghast implements PolymerEntity {
		public Zephyr(EntityType<? extends Ghast> t, Level l) { super(t, l); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.GHAST; }
		@Override public int getExplosionPower() { return 0; } // fireballs knock back and ignite but do not wreck terrain
	}

	public static class GoldenSwet extends Slime implements PolymerEntity {
		public GoldenSwet(EntityType<? extends Slime> t, Level l) { super(t, l); }
		@Override public void setSize(int size, boolean heal) { super.setSize(2, heal); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.SLIME; }
	}

	public static class Sentry extends Slime implements PolymerEntity {
		public Sentry(EntityType<? extends Slime> t, Level l) { super(t, l); }
		@Override public void setSize(int size, boolean heal) { super.setSize(2, heal); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.SLIME; }
	}

	public static class FireMinion extends Blaze implements PolymerEntity {
		public FireMinion(EntityType<? extends Blaze> t, Level l) { super(t, l); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.BLAZE; }
	}

	/** Base for poison shooters (cockatrice, aechor plant). */
	public abstract static class Shooter extends Monster implements RangedAttackMob, PolymerEntity {
		private final boolean stationary;
		protected Shooter(EntityType<? extends Monster> t, Level l, boolean stationary) { super(t, l); this.stationary = stationary; }
		@Override protected void registerGoals() {
			this.goalSelector.addGoal(1, new FloatGoal(this));
			this.goalSelector.addGoal(2, new RangedAttackGoal(this, 1.0, 40, 14.0F));
			if (!stationary) this.goalSelector.addGoal(5, new WaterAvoidingRandomStrollGoal(this, 0.8));
			this.goalSelector.addGoal(6, new LookAtPlayerGoal(this, Player.class, 12.0F));
			this.goalSelector.addGoal(7, new RandomLookAroundGoal(this));
			this.targetSelector.addGoal(1, new HurtByTargetGoal(this));
			this.targetSelector.addGoal(2, new NearestAttackableTargetGoal<>(this, Player.class, true));
		}
		@Override public void performRangedAttack(LivingEntity target, float power) { shoot(this, target, 2.0F, new MobEffectInstance(MobEffects.POISON, 100, 0)); }
	}

	public static class Cockatrice extends Shooter {
		public Cockatrice(EntityType<? extends Monster> t, Level l) { super(t, l, false); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.CHICKEN; }
	}

	public static class AechorPlant extends Shooter {
		public AechorPlant(EntityType<? extends Monster> t, Level l) { super(t, l, true); }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.SNOW_GOLEM; }
		@Override public boolean isPushable() { return false; }
	}

	/** Drifting tornado: lifts everything it touches; the evil one also hurts. */
	public static class Whirlwind extends PathfinderMob implements PolymerEntity {
		protected final boolean evil;
		public Whirlwind(EntityType<? extends Whirlwind> t, Level l) { this(t, l, false); }
		protected Whirlwind(EntityType<? extends Whirlwind> t, Level l, boolean evil) {
			super(t, l); this.evil = evil;
			this.moveControl = new FlyingMoveControl(this, 10, true);
			this.setNoGravity(true);
		}
		@Override protected PathNavigation createNavigation(Level level) { var n = new FlyingPathNavigation(this, level); n.setCanOpenDoors(false); n.setCanFloat(true); return n; }
		@Override protected void registerGoals() {
			this.goalSelector.addGoal(1, new WaterAvoidingRandomFlyingGoal(this, 1.0));
			this.goalSelector.addGoal(2, new RandomLookAroundGoal(this));
		}
		@Override public void aiStep() {
			super.aiStep();
			if (level() instanceof ServerLevel sl) {
				List<Entity> hits = sl.getEntities(this, new AABB(blockPosition()).inflate(0.8), e -> e instanceof LivingEntity && !(e instanceof Whirlwind));
				for (Entity e : hits) {
					e.setDeltaMovement(e.getDeltaMovement().add(0, 0.12, 0)); e.needsSync = true;
					if (evil && tickCount % 20 == 0) e.hurtServer(sl, damageSources().mobAttack(this), 1.0F);
				}
			}
		}
		@Override public boolean causeFallDamage(double d, float m, DamageSource s) { return false; }
		@Override public EntityType<?> getPolymerEntityType(PacketContext c) { return EntityTypes.ALLAY; }
	}

	public static class EvilWhirlwind extends Whirlwind {
		public EvilWhirlwind(EntityType<? extends Whirlwind> t, Level l) { super(t, l, true); }
	}

	// ---------------- attributes ----------------
	public static AttributeSupplier.Builder flyer(double health, double speed) {
		return Mob.createMobAttributes().add(Attributes.MAX_HEALTH, health).add(Attributes.FLYING_SPEED, speed).add(Attributes.MOVEMENT_SPEED, speed);
	}
}
