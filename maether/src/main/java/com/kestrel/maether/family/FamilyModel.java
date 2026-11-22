package com.kestrel.maether.family;

import eu.pb4.factorytools.api.block.model.generic.BlockStateModelManager;
import eu.pb4.factorytools.api.virtualentity.BlockModel;
import eu.pb4.factorytools.api.virtualentity.ItemDisplayElementUtil;
import eu.pb4.polymer.virtualentity.api.attachment.BlockAwareAttachment;
import eu.pb4.polymer.virtualentity.api.attachment.HolderAttachment;
import eu.pb4.polymer.virtualentity.api.elements.ItemDisplayElement;
import net.minecraft.core.BlockPos;
import net.minecraft.util.RandomSource;
import net.minecraft.world.item.ItemDisplayContext;
import net.minecraft.world.phys.Vec3;
import org.jetbrains.annotations.Nullable;

import java.util.ArrayList;
import java.util.List;

/** Display-entity model for one block state, driven by the aether blockstate assets (pattern from mPolymerPatchBundle). */
public class FamilyModel extends BlockModel {
	private final List<ItemDisplayElement> elements = new ArrayList<>();
	private final float viewRange;

	public FamilyModel(float viewRange) { this.viewRange = viewRange; }

	public static FamilyModel mid() { return new FamilyModel(3.0F); }
	public static FamilyModel shortRange() { return new FamilyModel(1.1F); }

	@Override
	public void notifyUpdate(HolderAttachment.UpdateType type) {
		super.notifyUpdate(type);
		if (type == BlockAwareAttachment.BLOCK_STATE_UPDATE) apply();
	}

	@Override
	protected void onAttachmentSet(HolderAttachment attachment, @Nullable HolderAttachment old) {
		super.onAttachmentSet(attachment, old);
		apply();
	}

	private void apply() {
		var models = BlockStateModelManager.get(this.blockState());
		RandomSource random = RandomSource.create(this.blockState().getSeed(this.blockPos()));
		while (models.size() < elements.size()) removeElement(elements.removeLast());
		for (int i = 0; i < models.size(); i++) {
			boolean fresh = i >= elements.size();
			ItemDisplayElement e;
			if (fresh) {
				e = ItemDisplayElementUtil.createSimple();
				e.setViewRange(viewRange);
				e.setTeleportDuration(0);
				e.setItemDisplayContext(ItemDisplayContext.NONE);
				e.setYaw(180.0F);
				elements.add(e);
			} else e = elements.get(i);
			var data = models.get(i).getModel(random);
			e.setItem(data.stack());
			e.setLeftRotation(data.quaternionfc());
			int j = Math.abs((i + blockPos().getX() + blockPos().getY() + blockPos().getZ()) % 5); // tiny offset against z-fighting
			e.setOffset(new Vec3(j / 5000f, j / 5000f, j / 5000f).subtract(5 / 5000f / 2));
			if (fresh) addElement(e); else e.tick();
		}
	}
}
