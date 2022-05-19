end_short_object_offset = $102;

; Vars
vsync_handled = $400

loop_count = $404

loop_count_string_pos = $ff8410
loop_count_string_start = $ff8413

config_values_start = $ff8430
palette_select = $ff8430
scroll_1_select = $ff8431
scroll_2_select = $ff8432
scroll_3_select = $ff8433
object_select = $ff8434
row_scroll_select = $ff8435
control_select = $ff8436

value_string_pos = $ff8460
value_string_start = $ff8463

base_vram_object_var = $ff8490
base_vram_scroll1_var = $ff8492
base_vram_scroll2_var = $ff8494
base_vram_scroll3_var = $ff8496
base_vram_rowscroll_var = $ff8498
base_vram_pal_control_var = $ff849A

base_reg_null_ptr = $ff84A0

base_reg_object_ptr = $ff84A4
base_reg_scroll1_ptr = $ff84A8
base_reg_scroll2_ptr = $ff84AC
base_reg_scroll3_ptr = $ff84B0
base_reg_rowscroll_ptr = $ff84B4
base_reg_palette_ptr = $ff84B8
base_reg_pal_control_ptr = $ff84BC

cps2_object_buffer_bit = $500
; Vars

; Vram constants
base_vram_object = $9100
base_vram_scroll1 = $90c0
base_vram_scroll2 = $9040
base_vram_scroll3 = $9080
base_vram_rowscroll = $9200
base_vram_palette = $9000

base_reg_object = $804100
base_reg_scroll1 = $804102
base_reg_scroll2 = $804104
base_reg_scroll3 = $804106
base_reg_rowscroll = $804108
base_reg_palette = $80410a
base_reg_pal_control = $804170
; Vram constants

; Inputs
b_input_right = $00
b_input_left = $01
b_input_down = $02
b_input_up = $03

b_input_b1 = $04
b_input_b2 = $05
b_input_b3 = $06

input_right = $0001
input_left = $0002
input_down = $0004
input_up = $0008

input_b1 = $0010
input_b2 = $0020
input_b3 = $0040
; Inputs

scroll_2_pos_offset = $3a
scroll_3_pos_offset = $3e


video_control_offset = $4c

video_control_scroll_2_on = $0004
video_control_scroll_2_off = $FFFB
video_control_scroll_3_on = $0008
video_control_scroll_3_off = $FFF7

video_control_unknown_1_on = $0002
video_control_unknown_1_off = $FFFD
video_control_unknown_2_on = $0010
video_control_unknown_2_off = $FFEF
video_control_unknown_3_on = $0020
video_control_unknown_3_off = $FFDF


layer_control_offset = $52

layer_control_scroll_1_on = $0002
layer_control_scroll_1_off = $FFFD
layer_control_scroll_2_on = $0004
layer_control_scroll_2_off = $FFFB
layer_control_scroll_3_on = $0008
layer_control_scroll_3_off = $FFF7

layer_control_unknown_1_on = $0010
layer_control_unknown_1_off = $FFEF
layer_control_unknown_2_on = $0020
layer_control_unknown_2_off = $FFDF

;-----------------
; Layer control
;
; UU UU OO OO   S1 S1 S2 S2   S3 S3 SF2 SF1   S3E S2E S1E RS 
; 0  0  0  0    0  1  1  0    1  1  0   0     1   1   1   1

default_layer_control = $06CF
;-----------------

rowscroll_on = $0001
rowscroll_off = $FFFE

menu_item_count = $06

 org  0
  incbin "build\sf2.bin"
   
 org $8D1
;  dc.b "123  "

 ; Ignore cps b id check.   
 org $0004D0
   nop
   nop
 
 ; Do not add $4000 to scroll 1 text tiles
 org $000728
   nop
   nop

 org $000774
   move.w  #$20, D0
   
 org $000A54
  jmp main

 org $0016D6
  move.b  $804001.l, D0

 org $0016E2
  move.b  $804000.l, D0

 ; Don't fade out test screen 
 org $000984
;   NOP
;   NOP
 
 org $000752
   jmp hijack_clear_ram
 
;-------------------
; Stop vsync handling after inputs are read and palette updated and do custom logic
 org $000AC0
  jmp hijack_vsync
;-------------------

 org $000004
   dc.l hijack_reset_vec

 org $000934
  jmp hijack_load_stack

 ; Ignore dips
 org $00170E
   NOP
   NOP
   NOP

 org $00171A
   NOP
   NOP
   NOP

 org $001726
   NOP
   NOP
   NOP
 ; Ignore dips

 org $0016BE
   NOP
   NOP
   NOP

 org $000998
  bra $9ac

 org $00042E
  NOP
  NOP
  NOP
  NOP
  move.w  #$ffc0, $80410c.l ; Scroll x
  move.w  #$0, $80410e.l ; Scroll y
  move.w  #$9100, $804100.l ; Object ram base
  move.w  #$90c0, $804102.l ; Scroll1 ram base
  move.w  #$9040, $804104.l ; Scroll2 ram base
  move.w  #$9080, $804106.l ; Scroll3 ram base
  move.w  #$9200, $804108.l ; Rowscroll  ram base

 org $00048E
  move.w  #$12c8, $804166.l ; Layer ctrl
  move.w  #$3e, $804122.l ; Vid ctrl
  move.w  #$3f, $804170.l ; Pal Control
  move.w  #$9000, $80410a.l ; Palette base

 org $0005FE
  move.w  #$3f, $804122.l ; Video control

 org $00061E
  move.w  #$9100, $804100.l ; Object ram base
  move.w  #$9100, ($2a,A5)
  move.w  #$90c0, $804102.l ; Scroll1 ram base
  move.w  #$90c0, ($2c,A5)
  move.w  #$9040, $804104.l ; Scroll2 ram base
  move.w  #$9040, ($2e,A5)
  move.w  #$9080, $804106.l ; Scroll3 ram base
  move.w  #$9080, ($30,A5)
  move.w  #$9200, $804108.l ; Rowscroll ram base
  move.w  #$9200, ($32,A5)

 org $00167E
  move.w  D0, $804122.l ; Video control
  move.w  ($52,A5), $804166.l ; Layer control
  ; Ignore coin control 
  NOP
  NOP
  NOP
  NOP
  ; Ignore coin control 
  move.w  ($54,A5), $804168.l
  move.w  ($56,A5), $80416a.l
  move.w  ($58,A5), $80416c.l
  move.w  ($5a,A5), $80416e.l

 org $00173A
  move.w  ($60,A5), $80410c.l

 org $00174C
  move.w  ($64,A5), $804110.l

 org $00175E
  move.w  ($68,A5), $804114.l

 org $001770
  move.w  ($6c,A5), $804118.l

 org $00178E
  move.w  ($70,A5), $80411c.l

 org $0017AC
  move.w  ($62,A5), $80410e.l

 org $0017C0
  move.w  ($66,A5), $804112.l

 org $0017D4
  move.w  ($6a,A5), $804116.l

 org $0017E8
  move.w  ($74,A5), $804120.l

 org $0017FC
  move.w  ($6e,A5), $80411a.l

 org $001816
  move.w  ($72,A5), $80411e.l
 
 ; Clear less work ram
 org $0005CC
  adda.l  #$ffee, A1

;=================================
; Free space
;=================================
 org $0E0000

hijack_load_stack:
  lea     $ffffe0.l, A7
  lea     $ff8000.l, A5
  jmp $00093C

hijack_reset_vec:
  ; Configure cps2  
  move.w  #$7000, $FFFFF0.l ; /* Unknown (not base address of objects). Could be bass address of bank used when object swap bit set? */

  move.w  #$0, $8040a0.l ; Unknown in mame

  move.w  #$807d, $FFFFF2.l
  move.w  #$4570, $FFFFF4.l
  move.w  #$0, $FFFFF6.l
  move.w  #$40, $FFFFF8.l
  move.w  #$10, $FFFFFa.l

  move.w  #$f00, $804040.l ; Eeprom
  ; Configure cps2
  
  jmp $00041E

;-------------------
hijack_vsync:

  move.w  (cps2_object_buffer_bit, A5), $8040e0.l ; Set object bank after vblank - bit 0 = Object ram bank swap
  eori.w #$1, (cps2_object_buffer_bit, A5)

  ; From 000AD0
  move.w  $800172.l, ($5e,A5) ; Get system id

  move.w  ($4c,A5), $804122.l ; Video control
  jsr $001684 ; Input and update video control, skip video control
  ; From 000AD0  

  move.w  #$7000, $FFFFF0.l
  move.w  #$40, $FFFFF8.l
  move.w  #$10, $FFFFFa.l   
  move.w  #$4570, $FFFFF4.l

  move.l #$7fffffff, D7
  sub.l D6, D7
  move.l D7, (loop_count, A5) ; Store loop count

  ; Update pal
  move.w base_vram_pal_control_var, D0
  movea.l base_reg_pal_control_ptr, A0
  move.w D0, (A0)
  
  move.w  #base_vram_palette, D0
  movea.l  base_reg_palette_ptr, A0
  move.w D0, (A0)
  
  move.w  #$50, D0
.palette_vsync_loop
  dbra    D0, .palette_vsync_loop ; Original code does this
  ; Update pal
  
  ; Update rowscroll
  move.w base_vram_rowscroll_var, D0
  movea.l base_reg_rowscroll_ptr, A0
  move.w D0, (A0)
  
  movea.l #base_vram_rowscroll_var, A0
  eori.w  #$0010, (A0) ; Switch object buffers each frame
  ; Update rowscroll

  ; Update object base
  move.w base_vram_object_var, D0
  movea.l base_reg_object_ptr, A0
  move.w D0, (A0)
  
  movea.l #base_vram_object_var, A0
  eori.w  #$0080, (A0) ; Switch object buffers each frame
  ; Update object base

  ; Update scroll2 base
  move.w base_vram_scroll2_var, D0
  movea.l base_reg_scroll2_ptr, A0
  move.w D0, (A0)
  
  movea.l #base_vram_scroll2_var, A0
  eori.w  #$0100, (A0) ; Switch object buffers each frame
  ; Update scroll2 base

  ; Update scroll3 base
  move.w base_vram_scroll3_var, D0
  movea.l base_reg_scroll3_ptr, A0
  move.w D0, (A0)
  
  movea.l #base_vram_scroll3_var, A0
  eori.w  #$0100, (A0) ; Switch object buffers each frame
  ; Update scroll3 base
  
  movem.l (A7)+, D0-D7/A0-A6 ; Restore regs

  moveq #$0, D6 ; Vsync handled

  rte
;-------------------

;-------------------
hijack_clear_ram
  lea     $ff0000.l, A0 
  move.w  #$1ffd, D4
  moveq   #$0, D0

.clear_ram_loop
  move.l  D0, (A0)+
  move.l  D0, (A0)+
  dbra    D4, .clear_ram_loop
  
  jmp initialize_base_register_vars
;-------------------

;-------------------
main:
  bsr init_qsound
  bsr fix_palette_brightness
  bsr upload_object_data
  bsr upload_rowscroll_data
  bsr setup_variable_strings
  bsr draw_ui
  bsr upload_scroll23_data

.loop
  bsr draw_count
  bsr draw_values
  bsr handle_controls

  move.l #$7fffffff, D6 ; Reset loop count

.count_loop
  dbra D6, .count_loop

  bra .loop
;-------------------

;-------------------
initialize_base_register_vars:

  ; Values
  move.w #base_vram_object, D0
  move.w D0, base_vram_object_var

  move.w #base_vram_scroll1, D0
  move.w D0, base_vram_scroll1_var

  move.w #base_vram_scroll2, D0
  move.w D0, base_vram_scroll2_var

  move.w #base_vram_scroll3, D0
  move.w D0, base_vram_scroll3_var

  move.w #base_vram_rowscroll, D0
  move.w D0, base_vram_rowscroll_var

  move.w #$003F, D0
  move.w D0, base_vram_pal_control_var
  ; Values

  ; Pointers
  move.l #base_reg_object, D0
  move.l D0, base_reg_object_ptr

  move.l #base_reg_scroll1, D0
  move.l D0, base_reg_scroll1_ptr

  move.l #base_reg_scroll2, D0
  move.l D0, base_reg_scroll2_ptr

  move.l #base_reg_scroll3, D0
  move.l D0, base_reg_scroll3_ptr

  move.l #base_reg_rowscroll, D0
  move.l D0, base_reg_rowscroll_ptr

  move.l #base_reg_palette, D0
  move.l D0, base_reg_palette_ptr

  move.l #base_reg_pal_control, D0
  move.l D0, base_reg_pal_control_ptr
  ; Pointers
  
  jmp     (A4)
;-------------------

;-------------------
draw_ui:
  movea.l #control_string, A2
  bsr draw_string_hook

  movea.l #config_string, A2
  bsr draw_string_hook

  movea.l #spacer_string_1, A2
  bsr draw_string_hook

  movea.l #spacer_string_2, A2
  bsr draw_string_hook

  movea.l #spacer_string_3, A2
  bsr draw_string_hook

  rts
;-------------------

;-------------------
setup_variable_strings:
  moveq #$3, D0
  movea.l #default_count_string, A1
  movea.l #loop_count_string_pos, A0

  bsr copy_mem

  moveq #$15, D0
  movea.l #default_value_string, A1
  movea.l #value_string_pos, A0

  bsr copy_mem

  rts
;-------------------

;-------------------
handle_controls:
  moveq #$00, D0
  moveq #$00, D1

  move.w  ($7e,A5), D0
  move.w  ($80,A5), D1
  eor.w D0, D1 ; Fresh input
  and.w D0, D1 ; Was a press not a release

  tst.w D1
  beq .handle_controls_continue ; Nothing pressed!
  
  bsr increment_value
  
  bsr clamp_value_and_update_pointers
  
  bsr update_value_string

.handle_controls_continue
  rts
;-------------------

;-------------------
clamp_value_and_update_pointers:
  btst #b_input_right, D1
  beq .clamp_check_left
  
  bsr handle_palette_value_change

.clamp_check_left
  btst #b_input_left, D1
  beq .clamp_check_down
  
  bsr handle_scroll1_value_change

.clamp_check_down
  btst #b_input_down, D1
  beq .clamp_check_up
  
  bsr handle_scroll2_value_change

.clamp_check_up
  btst #b_input_up, D1
  beq .clamp_check_b1
  
  bsr handle_scroll3_value_change

.clamp_check_b1
  btst #b_input_b1, D1
  beq .clamp_check_b2
  
  bsr handle_object_value_change

.clamp_check_b2
  btst #b_input_b2, D1
  beq .clamp_check_b3
  
  bsr handle_row_scroll_value_change

.clamp_check_b3
  btst #b_input_b3, D1
  beq .clamp_exit
  
  bsr handle_control_value_change

.clamp_exit
  rts
;-------------------

;===========================================
handle_control_value_change:
  movea.l #control_select, A0
  move.b (A0), D0
  cmpi.b #$07, D0
  bne .control_continue
  
  move.b #$00, (A0)
  
.control_continue
  moveq #$00, D0
  move.b (A0), D0
  add.w   D0, D0
  add.w   D0, D0
  movea.l control_value_jump_tbl(PC,D0.w), A0
  jsr     (A0)

  rts

;-------------------
  
control_value_jump_tbl:
  dc.l control_value_0, control_value_1, control_value_2, control_value_3, control_value_4, control_value_5, control_value_6

;-------------------

control_value_0:
  ori.w #layer_control_scroll_1_on, (layer_control_offset, A5)   
  andi.w #layer_control_unknown_1_off, (layer_control_offset, A5)   
  andi.w #layer_control_unknown_2_off, (layer_control_offset, A5)   
  
  ori.w #video_control_unknown_1_on, (video_control_offset, A5)
  ori.w #video_control_unknown_2_on, (video_control_offset, A5)
  ori.w #video_control_unknown_3_on, (video_control_offset, A5)
  rts

control_value_1:
  ori.w #layer_control_scroll_1_on, (layer_control_offset, A5)   
  ori.w #layer_control_unknown_1_on, (layer_control_offset, A5)   
  andi.w #layer_control_unknown_2_off, (layer_control_offset, A5)   
  
  ori.w #video_control_unknown_1_on, (video_control_offset, A5)
  ori.w #video_control_unknown_2_on, (video_control_offset, A5)
  ori.w #video_control_unknown_3_on, (video_control_offset, A5)
  rts

control_value_2:
  ori.w #layer_control_scroll_1_on, (layer_control_offset, A5)   
  andi.w #layer_control_unknown_1_off, (layer_control_offset, A5)   
  ori.w #layer_control_unknown_2_on, (layer_control_offset, A5)   
  
  ori.w #video_control_unknown_1_on, (video_control_offset, A5)
  ori.w #video_control_unknown_2_on, (video_control_offset, A5)
  ori.w #video_control_unknown_3_on, (video_control_offset, A5)
  rts

control_value_3:
  ori.w #layer_control_scroll_1_on, (layer_control_offset, A5)   
  andi.w #layer_control_unknown_1_off, (layer_control_offset, A5)   
  andi.w #layer_control_unknown_2_off, (layer_control_offset, A5)   
  
  andi.w #video_control_unknown_1_off, (video_control_offset, A5)
  ori.w #video_control_unknown_2_on, (video_control_offset, A5)
  ori.w #video_control_unknown_3_on, (video_control_offset, A5)
  rts

control_value_4:
  ori.w #layer_control_scroll_1_on, (layer_control_offset, A5)   
  andi.w #layer_control_unknown_1_off, (layer_control_offset, A5)   
  andi.w #layer_control_unknown_2_off, (layer_control_offset, A5)   
  
  ori.w #video_control_unknown_1_on, (video_control_offset, A5)
  andi.w #video_control_unknown_2_off, (video_control_offset, A5)
  ori.w #video_control_unknown_3_on, (video_control_offset, A5)
  rts

control_value_5:
  ori.w #layer_control_scroll_1_on, (layer_control_offset, A5)   
  andi.w #layer_control_unknown_1_off, (layer_control_offset, A5)   
  andi.w #layer_control_unknown_2_off, (layer_control_offset, A5)   
  
  ori.w #video_control_unknown_1_on, (video_control_offset, A5)
  ori.w #video_control_unknown_2_on, (video_control_offset, A5)
  andi.w #video_control_unknown_3_off, (video_control_offset, A5)
  rts

control_value_6:
  andi.w #layer_control_scroll_1_off, (layer_control_offset, A5)   
  andi.w #layer_control_unknown_1_off, (layer_control_offset, A5)   
  andi.w #layer_control_unknown_2_off, (layer_control_offset, A5)   
  
  ori.w #video_control_unknown_1_on, (video_control_offset, A5)
  ori.w #video_control_unknown_2_on, (video_control_offset, A5)
  ori.w #video_control_unknown_3_on, (video_control_offset, A5)

  rts
;===========================================

;===========================================
handle_palette_value_change:
  movea.l #palette_select, A0
  move.b (A0), D0
  cmpi.b #$0A, D0
  bne .palette_continue
  
  move.b #$00, (A0)
  
.palette_continue
  moveq #$00, D0
  move.b (A0), D0
  add.w   D0, D0
  move.w palette_control_table(PC,D0.w), D0
  move.w D0, base_vram_pal_control_var
  
  move.b (A0), D0
  cmpi.b #$09, D0
  beq .disable_palette_update

  move.l #base_reg_palette, D0
  move.l D0, base_reg_palette_ptr

  move.l #base_reg_pal_control, D0
  move.l D0, base_reg_pal_control_ptr
  
  rts

.disable_palette_update
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_palette_ptr

  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_pal_control_ptr
  
  rts

palette_control_table:
  dc.w $003F, $0001, $0002, $0004, $0008, $0010, $0020, $0015, $002A, $0000
;===========================================

;-------------------
handle_scroll1_value_change:
  movea.l #scroll_1_select, A0
  move.b (A0), D0
  cmpi.b #$04, D0
  bne .scroll1_exit
  
  move.b #$00, (A0)
  
.scroll1_exit
  rts
;-------------------

;===========================================
handle_scroll2_value_change:
  movea.l #scroll_2_select, A0
  move.b (A0), D0
  cmpi.b #$08, D0
  bne .scroll2_exit
  
  move.b #$00, (A0)
  
.scroll2_exit
  moveq #$00, D0
  move.b (A0), D0
  add.w   D0, D0
  add.w   D0, D0
  movea.l scroll2_value_jump_tbl(PC,D0.w), A0
  jsr     (A0)

  rts

;-------------------
  
scroll2_value_jump_tbl:
  dc.l scroll2_value_0, scroll2_value_1, scroll2_value_2, scroll2_value_3, scroll2_value_4, scroll2_value_5, scroll2_value_6, scroll2_value_7

;-------------------

scroll2_value_0:
  move.l #base_reg_scroll2, D0
  move.l D0, base_reg_scroll2_ptr
  
  ori.w #video_control_scroll_2_on, (video_control_offset, A5)
  ori.w #layer_control_scroll_2_on, (layer_control_offset, A5)
  rts

scroll2_value_1:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_scroll2_ptr

  ori.w #video_control_scroll_2_on, (video_control_offset, A5)   
  ori.w #layer_control_scroll_2_on, (layer_control_offset, A5)
  rts

scroll2_value_2:
  move.l #base_reg_scroll2, D0
  move.l D0, base_reg_scroll2_ptr

  andi.w #video_control_scroll_2_off, (video_control_offset, A5)   
  ori.w #layer_control_scroll_2_on, (layer_control_offset, A5)
  rts

scroll2_value_3:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_scroll2_ptr

  andi.w #video_control_scroll_2_off, (video_control_offset, A5)   
  ori.w #layer_control_scroll_2_on, (layer_control_offset, A5)
  rts
  
scroll2_value_4:
  move.l #base_reg_scroll2, D0
  move.l D0, base_reg_scroll2_ptr
  
  ori.w #video_control_scroll_2_on, (video_control_offset, A5)
  andi.w #layer_control_scroll_2_off, (layer_control_offset, A5)
  rts

scroll2_value_5:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_scroll2_ptr

  ori.w #video_control_scroll_2_on, (video_control_offset, A5)   
  andi.w #layer_control_scroll_2_off, (layer_control_offset, A5)
  rts

scroll2_value_6:
  move.l #base_reg_scroll2, D0
  move.l D0, base_reg_scroll2_ptr

  andi.w #video_control_scroll_2_off, (video_control_offset, A5)   
  andi.w #layer_control_scroll_2_off, (layer_control_offset, A5)
  rts

scroll2_value_7:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_scroll2_ptr

  andi.w #video_control_scroll_2_off, (video_control_offset, A5)   
  andi.w #layer_control_scroll_2_off, (layer_control_offset, A5)
  rts
;===========================================

;===========================================
handle_scroll3_value_change:
  movea.l #scroll_3_select, A0
  move.b (A0), D0
  cmpi.b #$08, D0
  bne .scroll3_exit
  
  move.b #$00, (A0)
  
.scroll3_exit
  moveq #$00, D0
  move.b (A0), D0
  add.w   D0, D0
  add.w   D0, D0
  movea.l scroll3_value_jump_tbl(PC,D0.w), A0
  jsr     (A0)

  rts

;-------------------
  
scroll3_value_jump_tbl:
  dc.l scroll3_value_0, scroll3_value_1, scroll3_value_2, scroll3_value_3, scroll3_value_4, scroll3_value_5, scroll3_value_6, scroll3_value_7

;-------------------

scroll3_value_0:
  move.l #base_reg_scroll3, D0
  move.l D0, base_reg_scroll3_ptr
  
  ori.w #video_control_scroll_3_on, (video_control_offset, A5)   
  ori.w #layer_control_scroll_3_on, (layer_control_offset, A5)
  rts

scroll3_value_1:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_scroll3_ptr

  ori.w #video_control_scroll_3_on, (video_control_offset, A5)   
  ori.w #layer_control_scroll_3_on, (layer_control_offset, A5)
  rts

scroll3_value_2:
  move.l #base_reg_scroll3, D0
  move.l D0, base_reg_scroll3_ptr

  andi.w #video_control_scroll_3_off, (video_control_offset, A5)   
  ori.w #layer_control_scroll_3_on, (layer_control_offset, A5)
  rts

scroll3_value_3:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_scroll3_ptr

  andi.w #video_control_scroll_3_off, (video_control_offset, A5)   
  ori.w #layer_control_scroll_3_on, (layer_control_offset, A5)
  rts
  
scroll3_value_4:
  move.l #base_reg_scroll3, D0
  move.l D0, base_reg_scroll3_ptr
  
  ori.w #video_control_scroll_3_on, (video_control_offset, A5)   
  andi.w #layer_control_scroll_3_off, (layer_control_offset, A5)
  rts

scroll3_value_5:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_scroll3_ptr

  ori.w #video_control_scroll_3_on, (video_control_offset, A5)   
  andi.w #layer_control_scroll_3_off, (layer_control_offset, A5)
  rts

scroll3_value_6:
  move.l #base_reg_scroll3, D0
  move.l D0, base_reg_scroll3_ptr

  andi.w #video_control_scroll_3_off, (video_control_offset, A5)   
  andi.w #layer_control_scroll_3_off, (layer_control_offset, A5)
  rts

scroll3_value_7:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_scroll3_ptr

  andi.w #video_control_scroll_3_off, (video_control_offset, A5)   
  andi.w #layer_control_scroll_3_off, (layer_control_offset, A5)
  rts
;===========================================

;===========================================
handle_object_value_change:
  movea.l #object_select, A0
  move.b (A0), D0
  cmpi.b #$03, D0
  bne .object_exit
  
  move.b #$00, (A0)
  
.object_exit
  moveq #$00, D0
  move.b (A0), D0
  add.w   D0, D0
  add.w   D0, D0
  movea.l object_value_jump_tbl(PC,D0.w), A0
  jsr     (A0)
    
  rts

;-------------------

object_value_jump_tbl:
  dc.l object_value_0, object_value_1, object_value_2

;-------------------

object_value_0:
  move.l #base_reg_object, D0
  move.l D0, base_reg_object_ptr

  movea.l #base_vram_object_var, A0
  andi.w #$FFBF, (A0)   
  rts

object_value_1:
  move.l #base_reg_object, D0
  move.l D0, base_reg_object_ptr

  movea.l #base_vram_object_var, A0
  ori.w #$0040, (A0)   
  rts
  
object_value_2:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_object_ptr
  rts
;===========================================


;===========================================
handle_row_scroll_value_change:
  movea.l #row_scroll_select, A0
  move.b (A0), D0
  cmpi.b #$08, D0
  bne .row_scroll_exit
  
  move.b #$00, (A0)
  
.row_scroll_exit
  moveq #$00, D0
  move.b (A0), D0
  add.w   D0, D0
  add.w   D0, D0
  movea.l rowscroll_value_jump_tbl(PC,D0.w), A0
  jsr     (A0)
    
  rts

;-------------------

rowscroll_value_jump_tbl:
  dc.l rowscroll_value_0, rowscroll_value_1, rowscroll_value_2, rowscroll_value_3, rowscroll_value_4, rowscroll_value_5, rowscroll_value_6, rowscroll_value_7

;-------------------

rowscroll_value_0:
  move.l #base_reg_rowscroll, D0
  move.l D0, base_reg_rowscroll_ptr

  ori.w #rowscroll_on, (video_control_offset, A5)   
  ori.w #rowscroll_on, (layer_control_offset, A5)
  rts

rowscroll_value_1:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_rowscroll_ptr

  ori.w #rowscroll_on, (video_control_offset, A5)   
  ori.w #rowscroll_on, (layer_control_offset, A5)
  rts

rowscroll_value_2:
  move.l #base_reg_rowscroll, D0
  move.l D0, base_reg_rowscroll_ptr

  andi.w #rowscroll_off, (video_control_offset, A5)   
  ori.w #rowscroll_on, (layer_control_offset, A5)
  rts

rowscroll_value_3:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_rowscroll_ptr

  andi.w #rowscroll_off, (video_control_offset, A5)   
  ori.w #rowscroll_on, (layer_control_offset, A5)
  rts
  
rowscroll_value_4:
  move.l #base_reg_rowscroll, D0
  move.l D0, base_reg_rowscroll_ptr

  ori.w #rowscroll_on, (video_control_offset, A5)   
  andi.w #rowscroll_off, (layer_control_offset, A5)
  rts

rowscroll_value_5:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_rowscroll_ptr

  ori.w #rowscroll_on, (video_control_offset, A5)   
  andi.w #rowscroll_off, (layer_control_offset, A5)
  rts

rowscroll_value_6:
  move.l #base_reg_rowscroll, D0
  move.l D0, base_reg_rowscroll_ptr

  andi.w #rowscroll_off, (video_control_offset, A5)   
  andi.w #rowscroll_off, (layer_control_offset, A5)
  rts

rowscroll_value_7:
  move.l #base_reg_null_ptr, D0
  move.l D0, base_reg_rowscroll_ptr

  andi.w #rowscroll_off, (video_control_offset, A5)   
  andi.w #rowscroll_off, (layer_control_offset, A5)
  rts
;===========================================

;-------------------
update_value_string:
  movea.l #config_values_start, A0
  movea.l #value_string_start, A1
  movea.l #nibble_to_char, A2
  
  moveq #menu_item_count, D0

.update_value_string_loop  
  moveq #$00, D1
  moveq #$00, D2

  move.b D0, D1
  rol.b #$01, D1
  add.b D0, D1 ; D1 contains the value string offset
  
  move.b (A0, D0), D2 ; Get value
  move.b (A2, D2), D2 ; Convert to char
  
  move.b D2, (A1, D1)

  dbra D0, .update_value_string_loop  

  rts
;-------------------

;-------------------
increment_value:
  moveq #menu_item_count, D0

.increment_value_loop
  btst D0, D1
  bne .increment_value_exit
  
  dbra D0, .increment_value_loop

  rts

.increment_value_exit
  movea.l #config_values_start, A0
  addq.b #$01, (A0, D0)

  rts  
;-------------------

;-------------------
draw_values:
  movea.l #value_string_pos, A2
  bsr draw_string_hook

  rts
;-------------------

;-------------------
draw_count:
  movea.l #nibble_to_char, A2
  movea.l #$ffff8404, A1 ; loop count
  movea.l #loop_count_string_start, A0
  
  moveq #$3, D0 ; Loop three times
  moveq #$0, D2
.draw_count_loop
  move.b (A1)+, D1
  move.b D1, D2

  ; First nibble
  andi.b #$F0, D1
  ror.b #$4, D1
  
  move.b (A2, D1), D1
  move.b D1, (A0)+

  ; Second nibble
  andi.b #$0F, D2
  
  move.b (A2, D2), D2
  move.b D2, (A0)+
  
  dbra D0, .draw_count_loop ; Do it four times

  movea.l #loop_count_string_pos, A2
  bsr draw_string_hook

  move.w base_vram_object_var, D0
  rol.l #$08, D0
  add.w #$80, D0
  movea.l D0, A0 ; Object vram location in A0

  movea.l #loop_count_string_start, A1
  move.l #$00D00040, D5
  moveq   #$7, D2 ; Draw eight characters
  bsr draw_object_text

  rts
;-------------------

;-------------------
draw_object_text:
  moveq   #$0, D0
  move.b  (A1)+, D0
  addi.w  #-$7f80, D0

  move.l  D5, (A0)+
  move.w  D0, (A0)+
  move.w  #$d, (A0)+

  addi.l  #$c0000, D5 ; Change x position
  dbra    D2, draw_object_text
  rts
;-------------------

;-------------------
draw_string_hook:
  movea.l #.draw_string_hook_continue, A5

  jmp $706

.draw_string_hook_continue
  movea.l #$ffff8000, A5 

  rts
;-------------------

;-------------------
init_qsound:
  move.b  #$88, $619ffb.l
  move.b  #$0, $619ffd.l
  move.b  #$ff, $619fff.l

  rts
;-------------------

;-------------------
fix_palette_brightness:
  movea.l	#$900000, A0
  move.l	#$F000F000, D0
  moveq		#0, D1
  move.b	#$80, D1

palette_brightness_loop:
  or.l		D0, (A0)+
  or.l		D0, (A0)+
  or.l		D0, (A0)+
  or.l		D0, (A0)+
  or.l		D0, (A0)+
  or.l		D0, (A0)+
  or.l		D0, (A0)+
  or.l		D0, (A0)+
  dbeq		D1, palette_brightness_loop

  rts
;-------------------

;-------------------
; TODO FIX ME
upload_object_data:
  move.w  #$0, $8040e0.l ; Set object bank

  moveq #$0, D0
  move.w #$2000, D0
  movea.l #$708000, A0
  movea.l #ssf2xj_objects, A1
  
  bsr copy_mem

  move.w  #$1, $8040e0.l ; Set object bank

  moveq #$0, D0
  move.w #$2000, D0
  movea.l #$708000, A0
  movea.l #ssf2xj_objects, A1
  
  bsr copy_mem

  rts
;-----------------

upload_scroll23_data:
  move.w #$4000, D0
  movea.l #$00904000, A0
  movea.l #sf2_scroll2, A1
  
  bsr copy_mem

  move.l #$20000000, D1  
  move.l D1, D2  
  move.w #$FFF, D0
  movea.l #$00914000, A0

  bsr clear_mem
  
  move.w #$4000, D0
  movea.l #$00908000, A0
  movea.l #sf2_scroll3, A1
  
  bsr copy_mem

  move.l #$56000000, D1  
  move.l D1, D2  
  move.w #$FFF, D0
  movea.l #$00918000, A0

  bsr clear_mem

  move.w #$1000, D0
  movea.l #$00900000, A0
  movea.l #sf2_palettes, A1
  
  bsr copy_mem
  
  ; Position scroll layers and enable them
  move.l #$01c00000, (scroll_2_pos_offset, A5)
  move.l #$03000010, (scroll_3_pos_offset, A5)
  move.w #default_layer_control, (layer_control_offset, A5) ; Thawk stage settings + untested rowscroll bit
  
  rts

;-----------------

;-----------------
upload_rowscroll_data:

  move.w #$1000, D0
  movea.l #$00920000, A0
  movea.l #sf2_rowscroll, A1
  
  bsr copy_mem
  rts
;-----------------

;-----------------
clear_mem:
  move.l  D1, (A0)+
  move.l  D2, (A0)+
  dbra D0, clear_mem
  rts
;-----------------

;-----------------
copy_mem:
  move.b  (A1, D0.w), D1
  move.b  D1, (A0, D0.w)
  dbra D0, copy_mem
  rts
;-----------------

spacer_string_1:
  dc.b $10, $0b, $00, "                  ", $00

control_string:
  dc.b $10, $0c, $00, "R  L  D  U  B1 B2 B3", $00

spacer_string_2:
  dc.b $10, $0d, $00, "                  ", $00

config_string:
  dc.b $10, $0e, $00, "PL S1 S2 S3 OB RS CT", $00

spacer_string_3:
  dc.b $10, $0f, $00, "                  ", $00

default_value_string:
  dc.b $10, $10, $00, "0  0  0  0  0  0  0 ", $00

default_count_string:
  dc.b $14, $0A, $00, $00
 
nibble_to_char:
  dc.b "0123456789ABCDEF"

ssf2xj_objects:
  incbin "bin\ssf2xj_obj_1.bin"
 
sf2_objects_2:
  incbin "bin\sf2_objects_2.bin"
 
sf2_scroll2:
  incbin "bin\scroll2_thawk.bin"
  
sf2_scroll3:
  incbin "bin\scroll3_thawk.bin"
  
sf2_palettes:
  incbin "bin\palettes_thawk.bin"
  
sf2_rowscroll:
  incbin "bin\sf2_rowscroll.bin"
