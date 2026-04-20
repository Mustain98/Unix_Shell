# -*-Makefile-*-

OBJDIRS		+= $(USER_OBJDIR)/rot13

USER_ROT13_SRC	+= $(USER_DIR)/rot13/rot13.c
USER_ROT13_OBJ	:= $(patsubst %.c, $(OBJDIR)/%.o, $(USER_ROT13_SRC))
USER_ROT13_OBJ	:= $(patsubst %.S, $(OBJDIR)/%.o, $(USER_ROT13_OBJ))

KERN_BINFILES	+= $(USER_OBJDIR)/rot13/rot13

rot13: $(USER_OBJDIR)/rot13/rot13

$(USER_OBJDIR)/rot13/rot13: $(USER_LIB_OBJ) $(USER_ROT13_OBJ)
	@echo + ld[USER/rot13] $@
	$(V)$(LD) -o $@ $(USER_LDFLAGS) $(USER_LIB_OBJ) $(USER_ROT13_OBJ) $(GCC_LIBS)
	$(V)$(OBJDUMP) -S $@ > $@.asm
	$(V)$(NM) -n $@ > $@.sym

$(USER_OBJDIR)/rot13/%.o: $(USER_DIR)/rot13/%.c
	@echo + cc[USER/rot13] $<
	@mkdir -p $(@D)
	$(V)$(CC) $(USER_CFLAGS) -c -o $@ $<

$(USER_OBJDIR)/rot13/%.o: $(USER_DIR)/rot13/%.S
	@echo + as[USER/rot13] $<
	@mkdir -p $(@D)
	$(V)$(CC) $(USER_CFLAGS) -c -o $@ $<
