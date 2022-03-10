call setup_patch_env.bat

del build\sf2_hack.bin

Asm68k.exe /p src\sf2_dma_tests.asm, build\sf2_hack.bin

java -jar RomMangler.jar split split_cfgs\sf2ww_dma_cps2_out_split.cfg build\sf2_hack.bin


del %ROM_DIR%\sf2ww_dma_cps2\sf2ww_dma_cps2.03
del %ROM_DIR%\sf2ww_dma_cps2\sf2ww_dma_cps2.04

copy build/out/sf2ww_dma_cps2.03 %ROM_DIR%\sf2ww_dma_cps2\sf2ww_dma_cps2.03
copy build/out/sf2ww_dma_cps2.04 %ROM_DIR%\sf2ww_dma_cps2\sf2ww_dma_cps2.04

pause