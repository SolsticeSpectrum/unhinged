#!/usr/bin/env python3
"""Find mod jar by mod id in run/mods, remove it. usage: poly_iter.py <modid>..."""
import zipfile,json,glob,os,sys
ids=set(sys.argv[1:])
for j in glob.glob('/home/user/mAether/run/mods/*.jar'):
    try: m=json.loads(zipfile.ZipFile(j).read('fabric.mod.json'))
    except Exception: continue
    if m.get('id') in ids: print('removing',os.path.basename(j)); os.remove(j)
