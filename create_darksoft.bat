call setup_patch_env.bat

del build\out\darksoft\ssf2xjdi\sfx.02
java -jar RomMangler.jar combine split_cfgs\sf2_dma_darksoft_program.cfg build\out\darksoft\ssf2xjdi\sfx.02

pause