call setup_patch_env.bat

del build\ssf2xj_hack.bin
copy build\ssf2xj.bin build\ssf2xj_hack.bin

Asm68k.exe /p /o ae+ /o c+ /o l+ src\sf2_dma_tests.asm, build\ssf2xj_hack.bin

java -jar RomMangler.jar split split_cfgs\ssf2xjr1d_out_split.cfg build\ssf2xj_hack.bin

copy build\out\sfxjd.03c %ROM_DIR%\sf2ww_dma_cps2\sfxjd.03c
copy build\out\sfxjd.04a %ROM_DIR%\sf2ww_dma_cps2\sfxjd.04a
copy build\out\sfxjd.05 %ROM_DIR%\sf2ww_dma_cps2\sfxjd.05
copy build\out\sfxjd.06a %ROM_DIR%\sf2ww_dma_cps2\sfxjd.06a
copy build\out\sfxjd.07 %ROM_DIR%\sf2ww_dma_cps2\sfxjd.07
copy build\out\sfxjd.08 %ROM_DIR%\sf2ww_dma_cps2\sfxjd.08
copy build\out\sfxd.09 %ROM_DIR%\sf2ww_dma_cps2\sfxd.09

pause