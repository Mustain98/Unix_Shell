# -*-Makefile-*-

OBJDIRS		+= $(USER_OBJDIR)/echo

USER_ECHO_SRC	+= $(USER_DIR)/echo/echo.c
USER_ECHO_OBJ	:= $(patsubst %.c, $(OBJDIR)/%.o, $(USER_ECHO_SRC))
USER_ECHO_OBJ	:= $(patsubst %.S, $(OBJDIR)/%.o, $(USER_ECHO_OBJ))

KERN_BINFILES	+= $(USER_OBJDIR)/echo/echo

echo: $(USER_OBJDIR)/echo/echo

$(USER_OBJDIR)/echo/echo: $(USER_LIB_OBJ) $(USER_ECHO_OBJ)
	@echo + ld[USER/echo] $@
	$(V)$(LD) -o $@ $(USER_LDFLAGS) $(USER_LIB_OBJ) $(USER_ECHO_OBJ) $(GCC_LIBS)
	$(V)$(OBJDUMP) -S $@ > $@.asm
	$(V)$(NM) -n $@ > $@.sym

$(USER_OBJDIR)/echo/%.o: $(USER_DIR)/echo/%.c
	@echo + cc[USER/echo] $<
	@mkdir -p $(@D)
	$(V)$(CC) $(USER_CFLAGS) -c -o $@ $<

$(USER_OBJDIR)/echo/%.o: $(USER_DIR)/echo/%.S
	@echo + as[USER/echo] $<
	@mkdir -p $(@D)
	$(V)$(CC) $(USER_CFLAGS) -c -o $@ $<
