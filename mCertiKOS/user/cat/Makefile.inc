# -*-Makefile-*-

OBJDIRS		+= $(USER_OBJDIR)/cat

USER_CAT_SRC	+= $(USER_DIR)/cat/cat.c
USER_CAT_OBJ	:= $(patsubst %.c, $(OBJDIR)/%.o, $(USER_CAT_SRC))
USER_CAT_OBJ	:= $(patsubst %.S, $(OBJDIR)/%.o, $(USER_CAT_OBJ))

KERN_BINFILES	+= $(USER_OBJDIR)/cat/cat

cat: $(USER_OBJDIR)/cat/cat

$(USER_OBJDIR)/cat/cat: $(USER_LIB_OBJ) $(USER_CAT_OBJ)
	@echo + ld[USER/cat] $@
	$(V)$(LD) -o $@ $(USER_LDFLAGS) $(USER_LIB_OBJ) $(USER_CAT_OBJ) $(GCC_LIBS)
	$(V)$(OBJDUMP) -S $@ > $@.asm
	$(V)$(NM) -n $@ > $@.sym

$(USER_OBJDIR)/cat/%.o: $(USER_DIR)/cat/%.c
	@echo + cc[USER/cat] $<
	@mkdir -p $(@D)
	$(V)$(CC) $(USER_CFLAGS) -c -o $@ $<

$(USER_OBJDIR)/cat/%.o: $(USER_DIR)/cat/%.S
	@echo + as[USER/cat] $<
	@mkdir -p $(@D)
	$(V)$(CC) $(USER_CFLAGS) -c -o $@ $<
