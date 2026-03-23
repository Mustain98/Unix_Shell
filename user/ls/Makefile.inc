# -*-Makefile-*-

OBJDIRS		+= $(USER_OBJDIR)/ls

USER_LS_SRC	+= $(USER_DIR)/ls/ls.c
USER_LS_OBJ	:= $(patsubst %.c, $(OBJDIR)/%.o, $(USER_LS_SRC))
USER_LS_OBJ	:= $(patsubst %.S, $(OBJDIR)/%.o, $(USER_LS_OBJ))

KERN_BINFILES	+= $(USER_OBJDIR)/ls/ls

ls: $(USER_OBJDIR)/ls/ls

$(USER_OBJDIR)/ls/ls: $(USER_LIB_OBJ) $(USER_LS_OBJ)
	@echo + ld[USER/ls] $@
	$(V)$(LD) -o $@ $(USER_LDFLAGS) $(USER_LIB_OBJ) $(USER_LS_OBJ) $(GCC_LIBS)
	$(V)$(OBJDUMP) -S $@ > $@.asm
	$(V)$(NM) -n $@ > $@.sym

$(USER_OBJDIR)/ls/%.o: $(USER_DIR)/ls/%.c
	@echo + cc[USER/ls] $<
	@mkdir -p $(@D)
	$(V)$(CC) $(USER_CFLAGS) -c -o $@ $<

$(USER_OBJDIR)/ls/%.o: $(USER_DIR)/ls/%.S
	@echo + as[USER/ls] $<
	@mkdir -p $(@D)
	$(V)$(CC) $(USER_CFLAGS) -c -o $@ $<
