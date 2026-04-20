
obj/user/shell/shell:     file format elf32-i386


Disassembly of section .text:

40000000 <main>:
  for (i = 0; i < 100000; i++)
    ;
  printf("ipc test pass!!\n");
  return 0;
}
int main(int argc, char **argv) {
40000000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
40000004:	83 e4 f0             	and    $0xfffffff0,%esp
40000007:	ff 71 fc             	push   -0x4(%ecx)
4000000a:	55                   	push   %ebp
4000000b:	89 e5                	mov    %esp,%ebp
4000000d:	57                   	push   %edi
4000000e:	56                   	push   %esi
4000000f:	53                   	push   %ebx
40000010:	51                   	push   %ecx
40000011:	81 ec 54 08 00 00    	sub    $0x854,%esp
  // 1: shell test
  // 2: ipc test
  // 0: normal mode
  int mode = 0;
  char buf[1024];
  printf("\n\t\t************************ UNIX-Shell *************************\n");
40000017:	68 14 40 00 40       	push   $0x40004014
4000001c:	e8 3f 04 00 00       	call   40000460 <printf>
  printf("\n\t\t************************* Group 11 **************************\n");
40000021:	c7 04 24 58 40 00 40 	movl   $0x40004058,(%esp)
40000028:	e8 33 04 00 00       	call   40000460 <printf>
  printf("\n\t\t********************* IDs 09 42 49 66 ***********************\n\n");
4000002d:	c7 04 24 9c 40 00 40 	movl   $0x4000409c,(%esp)
40000034:	e8 27 04 00 00       	call   40000460 <printf>
  // init

  if (mode == 1) {
    shell_test();
    return 0;
  } else if (mode == 2) {
40000039:	83 c4 10             	add    $0x10,%esp
4000003c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
  }

  while (1) {
    /* FIX: print a prompt so the user knows the shell is ready */
    printf(">: ");
40000040:	83 ec 0c             	sub    $0xc,%esp
sys_read(int fd, char *buf, size_t n)
{
	int errno;
	size_t ret;

	asm volatile("int %2"
40000043:	31 db                	xor    %ebx,%ebx
40000045:	68 c8 38 00 40       	push   $0x400038c8
4000004a:	e8 11 04 00 00       	call   40000460 <printf>
4000004f:	ba 00 04 00 00       	mov    $0x400,%edx
40000054:	b8 07 00 00 00       	mov    $0x7,%eax
40000059:	8d 8d e8 f7 ff ff    	lea    -0x818(%ebp),%ecx
4000005f:	cd 30                	int    $0x30
		       "b" (fd),
		       "c" (buf),
		       "d" (n)
		     : "cc", "memory");

	return errno ? -1 : ret;
40000061:	83 c4 10             	add    $0x10,%esp
static gcc_inline int
sys_readline(char* buf)
{
	// Read a line from stdin (fd 0) up to 1024 bytes
	int n = sys_read(0, buf, 1024);
	if (n > 0) {
40000064:	85 c0                	test   %eax,%eax
40000066:	75 0c                	jne    40000074 <main+0x74>
40000068:	85 db                	test   %ebx,%ebx
4000006a:	7e 08                	jle    40000074 <main+0x74>
		// Null-terminate the string
		buf[n] = '\0';
4000006c:	c6 84 1d e8 f7 ff ff 	movb   $0x0,-0x818(%ebp,%ebx,1)
40000073:	00 
  strcpy(procbuf, buf);
40000074:	83 ec 08             	sub    $0x8,%esp
40000077:	8d 85 e8 f7 ff ff    	lea    -0x818(%ebp),%eax
4000007d:	50                   	push   %eax
4000007e:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
40000084:	50                   	push   %eax
40000085:	e8 c6 0b 00 00       	call   40000c50 <strcpy>
  if (strchr(procbuf, '|') != 0)
4000008a:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
40000090:	59                   	pop    %ecx
40000091:	5b                   	pop    %ebx
40000092:	6a 7c                	push   $0x7c
40000094:	50                   	push   %eax
40000095:	e8 36 0d 00 00       	call   40000dd0 <strchr>
4000009a:	83 c4 10             	add    $0x10,%esp
4000009d:	85 c0                	test   %eax,%eax
4000009f:	0f 85 22 01 00 00    	jne    400001c7 <main+0x1c7>
    while (*buf && strchr(WHITESPACE, *buf))
400000a5:	0f be 85 e8 f7 ff ff 	movsbl -0x818(%ebp),%eax
  argc = 0;
400000ac:	31 ff                	xor    %edi,%edi
    while (*buf && strchr(WHITESPACE, *buf))
400000ae:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
  argv[argc] = 0;
400000b4:	c7 85 a8 f7 ff ff 00 	movl   $0x0,-0x858(%ebp)
400000bb:	00 00 00 
400000be:	66 90                	xchg   %ax,%ax
    while (*buf && strchr(WHITESPACE, *buf))
400000c0:	84 c0                	test   %al,%al
400000c2:	0f 85 80 00 00 00    	jne    40000148 <main+0x148>
  argv[argc] = 0;
400000c8:	c7 84 bd a8 f7 ff ff 	movl   $0x0,-0x858(%ebp,%edi,4)
400000cf:	00 00 00 00 
  if (argc == 0)
400000d3:	85 ff                	test   %edi,%edi
400000d5:	0f 84 65 ff ff ff    	je     40000040 <main+0x40>
  if (is_process_cmd(argv[0]))
400000db:	8b 85 a8 f7 ff ff    	mov    -0x858(%ebp),%eax
400000e1:	e8 8a 12 00 00       	call   40001370 <is_process_cmd>
400000e6:	89 c3                	mov    %eax,%ebx
400000e8:	85 c0                	test   %eax,%eax
400000ea:	0f 85 d7 00 00 00    	jne    400001c7 <main+0x1c7>
    if (strcmp(argv[0], commands[i].name) == 0)
400000f0:	8d 34 5b             	lea    (%ebx,%ebx,2),%esi
400000f3:	83 ec 08             	sub    $0x8,%esp
400000f6:	c1 e6 02             	shl    $0x2,%esi
400000f9:	ff b6 20 44 00 40    	push   0x40004420(%esi)
400000ff:	ff b5 a8 f7 ff ff    	push   -0x858(%ebp)
40000105:	e8 06 0c 00 00       	call   40000d10 <strcmp>
4000010a:	83 c4 10             	add    $0x10,%esp
4000010d:	85 c0                	test   %eax,%eax
4000010f:	0f 84 d9 00 00 00    	je     400001ee <main+0x1ee>
  for (i = 0; i < NCOMMANDS; i++) {
40000115:	83 c3 01             	add    $0x1,%ebx
40000118:	83 fb 10             	cmp    $0x10,%ebx
4000011b:	75 d3                	jne    400000f0 <main+0xf0>
  printf("Unknown command '%s'\n", argv[0]);
4000011d:	50                   	push   %eax
4000011e:	50                   	push   %eax
4000011f:	ff b5 a8 f7 ff ff    	push   -0x858(%ebp)
40000125:	68 cc 38 00 40       	push   $0x400038cc
4000012a:	e8 31 03 00 00       	call   40000460 <printf>
  printf("try 'help' to see all supported commands.\n");
4000012f:	c7 04 24 e0 40 00 40 	movl   $0x400040e0,(%esp)
40000136:	e8 25 03 00 00       	call   40000460 <printf>
  return 0;
4000013b:	83 c4 10             	add    $0x10,%esp
4000013e:	e9 fd fe ff ff       	jmp    40000040 <main+0x40>
40000143:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    while (*buf && strchr(WHITESPACE, *buf))
40000148:	83 ec 08             	sub    $0x8,%esp
4000014b:	50                   	push   %eax
4000014c:	68 56 36 00 40       	push   $0x40003656
40000151:	e8 7a 0c 00 00       	call   40000dd0 <strchr>
40000156:	83 c4 10             	add    $0x10,%esp
40000159:	85 c0                	test   %eax,%eax
4000015b:	74 13                	je     40000170 <main+0x170>
      *buf++ = 0;
4000015d:	c6 06 00             	movb   $0x0,(%esi)
    while (*buf && strchr(WHITESPACE, *buf))
40000160:	0f be 46 01          	movsbl 0x1(%esi),%eax
      *buf++ = 0;
40000164:	83 c6 01             	add    $0x1,%esi
40000167:	e9 54 ff ff ff       	jmp    400000c0 <main+0xc0>
4000016c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (*buf == 0)
40000170:	0f be 06             	movsbl (%esi),%eax
40000173:	84 c0                	test   %al,%al
40000175:	0f 84 4d ff ff ff    	je     400000c8 <main+0xc8>
    if (argc == MAXARGS - 1) {
4000017b:	83 ff 0f             	cmp    $0xf,%edi
4000017e:	74 57                	je     400001d7 <main+0x1d7>
    argv[argc++] = buf;
40000180:	89 b4 bd a8 f7 ff ff 	mov    %esi,-0x858(%ebp,%edi,4)
40000187:	8d 5f 01             	lea    0x1(%edi),%ebx
    while (*buf && !strchr(WHITESPACE, *buf))
4000018a:	eb 0f                	jmp    4000019b <main+0x19b>
4000018c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000190:	0f be 46 01          	movsbl 0x1(%esi),%eax
      buf++;
40000194:	83 c6 01             	add    $0x1,%esi
    while (*buf && !strchr(WHITESPACE, *buf))
40000197:	84 c0                	test   %al,%al
40000199:	74 25                	je     400001c0 <main+0x1c0>
4000019b:	83 ec 08             	sub    $0x8,%esp
4000019e:	50                   	push   %eax
4000019f:	68 56 36 00 40       	push   $0x40003656
400001a4:	e8 27 0c 00 00       	call   40000dd0 <strchr>
400001a9:	83 c4 10             	add    $0x10,%esp
400001ac:	85 c0                	test   %eax,%eax
400001ae:	74 e0                	je     40000190 <main+0x190>
    while (*buf && strchr(WHITESPACE, *buf))
400001b0:	0f be 06             	movsbl (%esi),%eax
    argv[argc++] = buf;
400001b3:	89 df                	mov    %ebx,%edi
400001b5:	e9 06 ff ff ff       	jmp    400000c0 <main+0xc0>
400001ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400001c0:	89 df                	mov    %ebx,%edi
400001c2:	e9 01 ff ff ff       	jmp    400000c8 <main+0xc8>
    return run_pipeline(procbuf);
400001c7:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
400001cd:	e8 7e 19 00 00       	call   40001b50 <run_pipeline.isra.0>
400001d2:	e9 69 fe ff ff       	jmp    40000040 <main+0x40>
      printf("Too many arguments (max %d)\n", MAXARGS);
400001d7:	83 ec 08             	sub    $0x8,%esp
400001da:	6a 10                	push   $0x10
400001dc:	68 75 36 00 40       	push   $0x40003675
400001e1:	e8 7a 02 00 00       	call   40000460 <printf>
      return 0;
400001e6:	83 c4 10             	add    $0x10,%esp
400001e9:	e9 52 fe ff ff       	jmp    40000040 <main+0x40>
      return commands[i].func(argc, argv);
400001ee:	8d 85 a8 f7 ff ff    	lea    -0x858(%ebp),%eax
400001f4:	52                   	push   %edx
400001f5:	52                   	push   %edx
400001f6:	50                   	push   %eax
400001f7:	57                   	push   %edi
400001f8:	ff 96 28 44 00 40    	call   *0x40004428(%esi)
    shell_readline(buf);
    if (buf != NULL) {
      if (runcmd(buf) < 0)
400001fe:	83 c4 10             	add    $0x10,%esp
40000201:	85 c0                	test   %eax,%eax
40000203:	0f 89 37 fe ff ff    	jns    40000040 <main+0x40>
        break;
    }
  }
}
40000209:	8d 65 f0             	lea    -0x10(%ebp),%esp
4000020c:	59                   	pop    %ecx
4000020d:	5b                   	pop    %ebx
4000020e:	5e                   	pop    %esi
4000020f:	5f                   	pop    %edi
40000210:	5d                   	pop    %ebp
40000211:	8d 61 fc             	lea    -0x4(%ecx),%esp
40000214:	c3                   	ret

40000215 <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary/
	 */
	testl	$0x0fffffff, %esp
40000215:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
4000021b:	75 04                	jne    40000221 <args_exist>

4000021d <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
4000021d:	6a 00                	push   $0x0
	pushl	$0
4000021f:	6a 00                	push   $0x0

40000221 <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
40000221:	e8 da fd ff ff       	call   40000000 <main>

	/* When returning, save return value */
	pushl	%eax
40000226:	50                   	push   %eax

	/* Syscall SYS_exit (30) */
	movl	$30, %eax
40000227:	b8 1e 00 00 00       	mov    $0x1e,%eax
	int	$48
4000022c:	cd 30                	int    $0x30

4000022e <spin>:

spin:
	call	yield
4000022e:	e8 1d 09 00 00       	call   40000b50 <yield>
	jmp	spin
40000233:	eb f9                	jmp    4000022e <spin>
40000235:	66 90                	xchg   %ax,%ax
40000237:	66 90                	xchg   %ax,%ax
40000239:	66 90                	xchg   %ax,%ax
4000023b:	66 90                	xchg   %ax,%ax
4000023d:	66 90                	xchg   %ax,%ax
4000023f:	90                   	nop

40000240 <debug>:
#include <stdarg.h>
#include <stdio.h>

void
debug(const char *file, int line, const char *fmt, ...)
{
40000240:	55                   	push   %ebp
40000241:	89 e5                	mov    %esp,%ebp
40000243:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[D] %s:%d: ", file, line);
40000246:	ff 75 0c             	push   0xc(%ebp)
40000249:	ff 75 08             	push   0x8(%ebp)
4000024c:	68 80 34 00 40       	push   $0x40003480
40000251:	e8 0a 02 00 00       	call   40000460 <printf>
	vcprintf(fmt, ap);
40000256:	58                   	pop    %eax
40000257:	8d 45 14             	lea    0x14(%ebp),%eax
4000025a:	5a                   	pop    %edx
4000025b:	50                   	push   %eax
4000025c:	ff 75 10             	push   0x10(%ebp)
4000025f:	e8 9c 01 00 00       	call   40000400 <vcprintf>
	va_end(ap);
}
40000264:	83 c4 10             	add    $0x10,%esp
40000267:	c9                   	leave
40000268:	c3                   	ret
40000269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000270 <warn>:

void
warn(const char *file, int line, const char *fmt, ...)
{
40000270:	55                   	push   %ebp
40000271:	89 e5                	mov    %esp,%ebp
40000273:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[W] %s:%d: ", file, line);
40000276:	ff 75 0c             	push   0xc(%ebp)
40000279:	ff 75 08             	push   0x8(%ebp)
4000027c:	68 8c 34 00 40       	push   $0x4000348c
40000281:	e8 da 01 00 00       	call   40000460 <printf>
	vcprintf(fmt, ap);
40000286:	58                   	pop    %eax
40000287:	8d 45 14             	lea    0x14(%ebp),%eax
4000028a:	5a                   	pop    %edx
4000028b:	50                   	push   %eax
4000028c:	ff 75 10             	push   0x10(%ebp)
4000028f:	e8 6c 01 00 00       	call   40000400 <vcprintf>
	va_end(ap);
}
40000294:	83 c4 10             	add    $0x10,%esp
40000297:	c9                   	leave
40000298:	c3                   	ret
40000299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400002a0 <panic>:

void
panic(const char *file, int line, const char *fmt, ...)
{
400002a0:	55                   	push   %ebp
400002a1:	89 e5                	mov    %esp,%ebp
400002a3:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[P] %s:%d: ", file, line);
400002a6:	ff 75 0c             	push   0xc(%ebp)
400002a9:	ff 75 08             	push   0x8(%ebp)
400002ac:	68 98 34 00 40       	push   $0x40003498
400002b1:	e8 aa 01 00 00       	call   40000460 <printf>
	vcprintf(fmt, ap);
400002b6:	58                   	pop    %eax
400002b7:	8d 45 14             	lea    0x14(%ebp),%eax
400002ba:	5a                   	pop    %edx
400002bb:	50                   	push   %eax
400002bc:	ff 75 10             	push   0x10(%ebp)
400002bf:	e8 3c 01 00 00       	call   40000400 <vcprintf>
400002c4:	83 c4 10             	add    $0x10,%esp
400002c7:	90                   	nop
400002c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400002cf:	00 
	va_end(ap);

	while (1)
		yield();
400002d0:	e8 7b 08 00 00       	call   40000b50 <yield>
	while (1)
400002d5:	eb f9                	jmp    400002d0 <panic+0x30>
400002d7:	66 90                	xchg   %ax,%ax
400002d9:	66 90                	xchg   %ax,%ax
400002db:	66 90                	xchg   %ax,%ax
400002dd:	66 90                	xchg   %ax,%ax
400002df:	90                   	nop

400002e0 <atoi>:
#include <stdlib.h>

int
atoi(const char *buf, int *i)
{
400002e0:	55                   	push   %ebp
400002e1:	89 e5                	mov    %esp,%ebp
400002e3:	57                   	push   %edi
400002e4:	56                   	push   %esi
400002e5:	53                   	push   %ebx
400002e6:	83 ec 04             	sub    $0x4,%esp
400002e9:	8b 75 08             	mov    0x8(%ebp),%esi
	int loc = 0;
	int numstart = 0;
	int acc = 0;
	int negative = 0;
	if (buf[loc] == '+')
400002ec:	0f b6 06             	movzbl (%esi),%eax
400002ef:	3c 2b                	cmp    $0x2b,%al
400002f1:	0f 84 89 00 00 00    	je     40000380 <atoi+0xa0>
		loc++;
	else if (buf[loc] == '-') {
400002f7:	3c 2d                	cmp    $0x2d,%al
400002f9:	74 65                	je     40000360 <atoi+0x80>
		negative = 1;
		loc++;
	}
	numstart = loc;
	// no grab the numbers
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400002fb:	8d 50 d0             	lea    -0x30(%eax),%edx
	int negative = 0;
400002fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int loc = 0;
40000305:	31 ff                	xor    %edi,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000307:	80 fa 09             	cmp    $0x9,%dl
4000030a:	0f 87 8c 00 00 00    	ja     4000039c <atoi+0xbc>
	int loc = 0;
40000310:	89 f9                	mov    %edi,%ecx
	int acc = 0;
40000312:	31 d2                	xor    %edx,%edx
40000314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000318:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000031f:	00 
		acc = acc*10 + (buf[loc]-'0');
40000320:	83 e8 30             	sub    $0x30,%eax
40000323:	8d 14 92             	lea    (%edx,%edx,4),%edx
		loc++;
40000326:	83 c1 01             	add    $0x1,%ecx
		acc = acc*10 + (buf[loc]-'0');
40000329:	0f be c0             	movsbl %al,%eax
4000032c:	8d 14 50             	lea    (%eax,%edx,2),%edx
	while ('0' <= buf[loc] && buf[loc] <= '9') {
4000032f:	0f b6 04 0e          	movzbl (%esi,%ecx,1),%eax
40000333:	8d 58 d0             	lea    -0x30(%eax),%ebx
40000336:	80 fb 09             	cmp    $0x9,%bl
40000339:	76 e5                	jbe    40000320 <atoi+0x40>
	}
	if (numstart == loc) {
4000033b:	39 f9                	cmp    %edi,%ecx
4000033d:	74 5d                	je     4000039c <atoi+0xbc>
		// no numbers have actually been scanned
		return 0;
	}
	if (negative)
		acc = - acc;
4000033f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
40000342:	89 d0                	mov    %edx,%eax
40000344:	f7 d8                	neg    %eax
40000346:	85 db                	test   %ebx,%ebx
40000348:	0f 45 d0             	cmovne %eax,%edx
	*i = acc;
4000034b:	8b 45 0c             	mov    0xc(%ebp),%eax
4000034e:	89 10                	mov    %edx,(%eax)
	return loc;
}
40000350:	83 c4 04             	add    $0x4,%esp
40000353:	89 c8                	mov    %ecx,%eax
40000355:	5b                   	pop    %ebx
40000356:	5e                   	pop    %esi
40000357:	5f                   	pop    %edi
40000358:	5d                   	pop    %ebp
40000359:	c3                   	ret
4000035a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000360:	0f b6 46 01          	movzbl 0x1(%esi),%eax
40000364:	8d 50 d0             	lea    -0x30(%eax),%edx
40000367:	80 fa 09             	cmp    $0x9,%dl
4000036a:	77 30                	ja     4000039c <atoi+0xbc>
		negative = 1;
4000036c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		loc++;
40000373:	bf 01 00 00 00       	mov    $0x1,%edi
40000378:	eb 96                	jmp    40000310 <atoi+0x30>
4000037a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000380:	0f b6 46 01          	movzbl 0x1(%esi),%eax
	int negative = 0;
40000384:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		loc++;
4000038b:	bf 01 00 00 00       	mov    $0x1,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000390:	8d 50 d0             	lea    -0x30(%eax),%edx
40000393:	80 fa 09             	cmp    $0x9,%dl
40000396:	0f 86 74 ff ff ff    	jbe    40000310 <atoi+0x30>
}
4000039c:	83 c4 04             	add    $0x4,%esp
		return 0;
4000039f:	31 c9                	xor    %ecx,%ecx
}
400003a1:	5b                   	pop    %ebx
400003a2:	89 c8                	mov    %ecx,%eax
400003a4:	5e                   	pop    %esi
400003a5:	5f                   	pop    %edi
400003a6:	5d                   	pop    %ebp
400003a7:	c3                   	ret
400003a8:	66 90                	xchg   %ax,%ax
400003aa:	66 90                	xchg   %ax,%ax
400003ac:	66 90                	xchg   %ax,%ax
400003ae:	66 90                	xchg   %ax,%ax

400003b0 <putch>:
	char buf[MAX_BUF];
};

static void
putch(int ch, struct printbuf *b)
{
400003b0:	55                   	push   %ebp
400003b1:	89 e5                	mov    %esp,%ebp
400003b3:	56                   	push   %esi
400003b4:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
400003b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
400003ba:	53                   	push   %ebx
	b->buf[b->idx++] = ch;
400003bb:	8b 06                	mov    (%esi),%eax
400003bd:	8d 50 01             	lea    0x1(%eax),%edx
400003c0:	89 16                	mov    %edx,(%esi)
400003c2:	88 4c 06 08          	mov    %cl,0x8(%esi,%eax,1)
	if (b->idx == MAX_BUF-1) {
400003c6:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
400003cc:	75 1c                	jne    400003ea <putch+0x3a>
		b->buf[b->idx] = 0;
400003ce:	c6 86 07 10 00 00 00 	movb   $0x0,0x1007(%esi)
		puts(b->buf, b->idx);
400003d5:	8d 4e 08             	lea    0x8(%esi),%ecx
	asm volatile("int %2"
400003d8:	b8 08 00 00 00       	mov    $0x8,%eax
400003dd:	bb 01 00 00 00       	mov    $0x1,%ebx
400003e2:	cd 30                	int    $0x30
		b->idx = 0;
400003e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	}
	b->cnt++;
400003ea:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
400003ee:	5b                   	pop    %ebx
400003ef:	5e                   	pop    %esi
400003f0:	5d                   	pop    %ebp
400003f1:	c3                   	ret
400003f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400003f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400003ff:	00 

40000400 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
40000400:	55                   	push   %ebp
40000401:	89 e5                	mov    %esp,%ebp
40000403:	53                   	push   %ebx
40000404:	bb 01 00 00 00       	mov    $0x1,%ebx
	struct printbuf b;

	b.idx = 0;
	b.cnt = 0;
	vprintfmt((void*)putch, &b, fmt, ap);
40000409:	8d 85 f0 ef ff ff    	lea    -0x1010(%ebp),%eax
{
4000040f:	81 ec 14 10 00 00    	sub    $0x1014,%esp
	vprintfmt((void*)putch, &b, fmt, ap);
40000415:	ff 75 0c             	push   0xc(%ebp)
40000418:	ff 75 08             	push   0x8(%ebp)
4000041b:	50                   	push   %eax
4000041c:	68 b0 03 00 40       	push   $0x400003b0
	b.idx = 0;
40000421:	c7 85 f0 ef ff ff 00 	movl   $0x0,-0x1010(%ebp)
40000428:	00 00 00 
	b.cnt = 0;
4000042b:	c7 85 f4 ef ff ff 00 	movl   $0x0,-0x100c(%ebp)
40000432:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
40000435:	e8 26 01 00 00       	call   40000560 <vprintfmt>

	b.buf[b.idx] = 0;
4000043a:	8b 95 f0 ef ff ff    	mov    -0x1010(%ebp),%edx
40000440:	8d 8d f8 ef ff ff    	lea    -0x1008(%ebp),%ecx
40000446:	b8 08 00 00 00       	mov    $0x8,%eax
4000044b:	c6 84 15 f8 ef ff ff 	movb   $0x0,-0x1008(%ebp,%edx,1)
40000452:	00 
40000453:	cd 30                	int    $0x30
	puts(b.buf, b.idx);

	return b.cnt;
}
40000455:	8b 85 f4 ef ff ff    	mov    -0x100c(%ebp),%eax
4000045b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
4000045e:	c9                   	leave
4000045f:	c3                   	ret

40000460 <printf>:

int
printf(const char *fmt, ...)
{
40000460:	55                   	push   %ebp
40000461:	89 e5                	mov    %esp,%ebp
40000463:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
40000466:	8d 45 0c             	lea    0xc(%ebp),%eax
40000469:	50                   	push   %eax
4000046a:	ff 75 08             	push   0x8(%ebp)
4000046d:	e8 8e ff ff ff       	call   40000400 <vcprintf>
	va_end(ap);

	return cnt;
}
40000472:	c9                   	leave
40000473:	c3                   	ret
40000474:	66 90                	xchg   %ax,%ax
40000476:	66 90                	xchg   %ax,%ax
40000478:	66 90                	xchg   %ax,%ax
4000047a:	66 90                	xchg   %ax,%ax
4000047c:	66 90                	xchg   %ax,%ax
4000047e:	66 90                	xchg   %ax,%ax

40000480 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
40000480:	55                   	push   %ebp
40000481:	89 e5                	mov    %esp,%ebp
40000483:	57                   	push   %edi
40000484:	89 c7                	mov    %eax,%edi
40000486:	56                   	push   %esi
40000487:	89 d6                	mov    %edx,%esi
40000489:	53                   	push   %ebx
4000048a:	83 ec 2c             	sub    $0x2c,%esp
4000048d:	8b 45 08             	mov    0x8(%ebp),%eax
40000490:	8b 55 0c             	mov    0xc(%ebp),%edx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
40000493:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
{
4000049a:	8b 4d 18             	mov    0x18(%ebp),%ecx
4000049d:	89 45 d8             	mov    %eax,-0x28(%ebp)
400004a0:	8b 45 10             	mov    0x10(%ebp),%eax
400004a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
400004a6:	8b 55 14             	mov    0x14(%ebp),%edx
400004a9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	if (num >= base) {
400004ac:	39 45 d8             	cmp    %eax,-0x28(%ebp)
400004af:	8b 4d dc             	mov    -0x24(%ebp),%ecx
400004b2:	1b 4d d4             	sbb    -0x2c(%ebp),%ecx
400004b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
400004b8:	8d 5a ff             	lea    -0x1(%edx),%ebx
	if (num >= base) {
400004bb:	73 53                	jae    40000510 <printnum+0x90>
		while (--width > 0)
400004bd:	83 fa 01             	cmp    $0x1,%edx
400004c0:	7e 1f                	jle    400004e1 <printnum+0x61>
400004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400004c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400004cf:	00 
			putch(padc, putdat);
400004d0:	83 ec 08             	sub    $0x8,%esp
400004d3:	56                   	push   %esi
400004d4:	ff 75 e4             	push   -0x1c(%ebp)
400004d7:	ff d7                	call   *%edi
		while (--width > 0)
400004d9:	83 c4 10             	add    $0x10,%esp
400004dc:	83 eb 01             	sub    $0x1,%ebx
400004df:	75 ef                	jne    400004d0 <printnum+0x50>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
400004e1:	89 75 0c             	mov    %esi,0xc(%ebp)
400004e4:	ff 75 d4             	push   -0x2c(%ebp)
400004e7:	ff 75 d0             	push   -0x30(%ebp)
400004ea:	ff 75 dc             	push   -0x24(%ebp)
400004ed:	ff 75 d8             	push   -0x28(%ebp)
400004f0:	e8 4b 2e 00 00       	call   40003340 <__umoddi3>
400004f5:	83 c4 10             	add    $0x10,%esp
400004f8:	0f be 80 a4 34 00 40 	movsbl 0x400034a4(%eax),%eax
400004ff:	89 45 08             	mov    %eax,0x8(%ebp)
}
40000502:	8d 65 f4             	lea    -0xc(%ebp),%esp
	putch("0123456789abcdef"[num % base], putdat);
40000505:	89 f8                	mov    %edi,%eax
}
40000507:	5b                   	pop    %ebx
40000508:	5e                   	pop    %esi
40000509:	5f                   	pop    %edi
4000050a:	5d                   	pop    %ebp
	putch("0123456789abcdef"[num % base], putdat);
4000050b:	ff e0                	jmp    *%eax
4000050d:	8d 76 00             	lea    0x0(%esi),%esi
		printnum(putch, putdat, num / base, base, width - 1, padc);
40000510:	83 ec 0c             	sub    $0xc,%esp
40000513:	ff 75 e4             	push   -0x1c(%ebp)
40000516:	53                   	push   %ebx
40000517:	50                   	push   %eax
40000518:	83 ec 08             	sub    $0x8,%esp
4000051b:	ff 75 d4             	push   -0x2c(%ebp)
4000051e:	ff 75 d0             	push   -0x30(%ebp)
40000521:	ff 75 dc             	push   -0x24(%ebp)
40000524:	ff 75 d8             	push   -0x28(%ebp)
40000527:	e8 f4 2c 00 00       	call   40003220 <__udivdi3>
4000052c:	83 c4 18             	add    $0x18,%esp
4000052f:	52                   	push   %edx
40000530:	89 f2                	mov    %esi,%edx
40000532:	50                   	push   %eax
40000533:	89 f8                	mov    %edi,%eax
40000535:	e8 46 ff ff ff       	call   40000480 <printnum>
4000053a:	83 c4 20             	add    $0x20,%esp
4000053d:	eb a2                	jmp    400004e1 <printnum+0x61>
4000053f:	90                   	nop

40000540 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
40000540:	55                   	push   %ebp
40000541:	89 e5                	mov    %esp,%ebp
40000543:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
40000546:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
4000054a:	8b 10                	mov    (%eax),%edx
4000054c:	3b 50 04             	cmp    0x4(%eax),%edx
4000054f:	73 0a                	jae    4000055b <sprintputch+0x1b>
		*b->buf++ = ch;
40000551:	8d 4a 01             	lea    0x1(%edx),%ecx
40000554:	89 08                	mov    %ecx,(%eax)
40000556:	8b 45 08             	mov    0x8(%ebp),%eax
40000559:	88 02                	mov    %al,(%edx)
}
4000055b:	5d                   	pop    %ebp
4000055c:	c3                   	ret
4000055d:	8d 76 00             	lea    0x0(%esi),%esi

40000560 <vprintfmt>:
{
40000560:	55                   	push   %ebp
40000561:	89 e5                	mov    %esp,%ebp
40000563:	57                   	push   %edi
40000564:	56                   	push   %esi
40000565:	53                   	push   %ebx
40000566:	83 ec 2c             	sub    $0x2c,%esp
40000569:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000056c:	8b 75 0c             	mov    0xc(%ebp),%esi
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000056f:	8b 45 10             	mov    0x10(%ebp),%eax
40000572:	8d 78 01             	lea    0x1(%eax),%edi
40000575:	0f b6 00             	movzbl (%eax),%eax
40000578:	83 f8 25             	cmp    $0x25,%eax
4000057b:	75 19                	jne    40000596 <vprintfmt+0x36>
4000057d:	eb 29                	jmp    400005a8 <vprintfmt+0x48>
4000057f:	90                   	nop
			putch(ch, putdat);
40000580:	83 ec 08             	sub    $0x8,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
40000583:	83 c7 01             	add    $0x1,%edi
			putch(ch, putdat);
40000586:	56                   	push   %esi
40000587:	50                   	push   %eax
40000588:	ff d3                	call   *%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000058a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
4000058e:	83 c4 10             	add    $0x10,%esp
40000591:	83 f8 25             	cmp    $0x25,%eax
40000594:	74 12                	je     400005a8 <vprintfmt+0x48>
			if (ch == '\0')
40000596:	85 c0                	test   %eax,%eax
40000598:	75 e6                	jne    40000580 <vprintfmt+0x20>
}
4000059a:	8d 65 f4             	lea    -0xc(%ebp),%esp
4000059d:	5b                   	pop    %ebx
4000059e:	5e                   	pop    %esi
4000059f:	5f                   	pop    %edi
400005a0:	5d                   	pop    %ebp
400005a1:	c3                   	ret
400005a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		padc = ' ';
400005a8:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
		precision = -1;
400005ac:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		altflag = 0;
400005b1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		width = -1;
400005b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		lflag = 0;
400005bf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400005c6:	0f b6 17             	movzbl (%edi),%edx
400005c9:	8d 47 01             	lea    0x1(%edi),%eax
400005cc:	89 45 10             	mov    %eax,0x10(%ebp)
400005cf:	8d 42 dd             	lea    -0x23(%edx),%eax
400005d2:	3c 55                	cmp    $0x55,%al
400005d4:	77 0a                	ja     400005e0 <vprintfmt+0x80>
400005d6:	0f b6 c0             	movzbl %al,%eax
400005d9:	ff 24 85 60 39 00 40 	jmp    *0x40003960(,%eax,4)
			putch('%', putdat);
400005e0:	83 ec 08             	sub    $0x8,%esp
400005e3:	56                   	push   %esi
400005e4:	6a 25                	push   $0x25
400005e6:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
400005e8:	83 c4 10             	add    $0x10,%esp
400005eb:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
400005ef:	89 7d 10             	mov    %edi,0x10(%ebp)
400005f2:	0f 84 77 ff ff ff    	je     4000056f <vprintfmt+0xf>
400005f8:	89 f8                	mov    %edi,%eax
400005fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000600:	83 e8 01             	sub    $0x1,%eax
40000603:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
40000607:	75 f7                	jne    40000600 <vprintfmt+0xa0>
40000609:	89 45 10             	mov    %eax,0x10(%ebp)
4000060c:	e9 5e ff ff ff       	jmp    4000056f <vprintfmt+0xf>
40000611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				if (ch < '0' || ch > '9')
40000618:	0f be 47 01          	movsbl 0x1(%edi),%eax
				precision = precision * 10 + ch - '0';
4000061c:	8d 4a d0             	lea    -0x30(%edx),%ecx
		switch (ch = *(unsigned char *) fmt++) {
4000061f:	8b 7d 10             	mov    0x10(%ebp),%edi
				if (ch < '0' || ch > '9')
40000622:	8d 50 d0             	lea    -0x30(%eax),%edx
40000625:	83 fa 09             	cmp    $0x9,%edx
40000628:	77 2b                	ja     40000655 <vprintfmt+0xf5>
4000062a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000630:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000637:	00 
40000638:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000063f:	00 
				precision = precision * 10 + ch - '0';
40000640:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
			for (precision = 0; ; ++fmt) {
40000643:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
40000646:	8d 4c 50 d0          	lea    -0x30(%eax,%edx,2),%ecx
				ch = *fmt;
4000064a:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
4000064d:	8d 50 d0             	lea    -0x30(%eax),%edx
40000650:	83 fa 09             	cmp    $0x9,%edx
40000653:	76 eb                	jbe    40000640 <vprintfmt+0xe0>
			if (width < 0)
40000655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000658:	85 c0                	test   %eax,%eax
				width = precision, precision = -1;
4000065a:	0f 48 c1             	cmovs  %ecx,%eax
4000065d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
40000660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000665:	0f 48 c8             	cmovs  %eax,%ecx
40000668:	e9 59 ff ff ff       	jmp    400005c6 <vprintfmt+0x66>
			altflag = 1;
4000066d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000674:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000677:	e9 4a ff ff ff       	jmp    400005c6 <vprintfmt+0x66>
			putch(ch, putdat);
4000067c:	83 ec 08             	sub    $0x8,%esp
4000067f:	56                   	push   %esi
40000680:	6a 25                	push   $0x25
40000682:	ff d3                	call   *%ebx
			break;
40000684:	83 c4 10             	add    $0x10,%esp
40000687:	e9 e3 fe ff ff       	jmp    4000056f <vprintfmt+0xf>
			precision = va_arg(ap, int);
4000068c:	8b 45 14             	mov    0x14(%ebp),%eax
		switch (ch = *(unsigned char *) fmt++) {
4000068f:	8b 7d 10             	mov    0x10(%ebp),%edi
			precision = va_arg(ap, int);
40000692:	8b 08                	mov    (%eax),%ecx
40000694:	83 c0 04             	add    $0x4,%eax
40000697:	89 45 14             	mov    %eax,0x14(%ebp)
			goto process_precision;
4000069a:	eb b9                	jmp    40000655 <vprintfmt+0xf5>
			if (width < 0)
4000069c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
4000069f:	31 c0                	xor    %eax,%eax
		switch (ch = *(unsigned char *) fmt++) {
400006a1:	8b 7d 10             	mov    0x10(%ebp),%edi
			if (width < 0)
400006a4:	85 d2                	test   %edx,%edx
400006a6:	0f 49 c2             	cmovns %edx,%eax
400006a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			goto reswitch;
400006ac:	e9 15 ff ff ff       	jmp    400005c6 <vprintfmt+0x66>
			putch(va_arg(ap, int), putdat);
400006b1:	83 ec 08             	sub    $0x8,%esp
400006b4:	56                   	push   %esi
400006b5:	8b 45 14             	mov    0x14(%ebp),%eax
400006b8:	ff 30                	push   (%eax)
400006ba:	ff d3                	call   *%ebx
400006bc:	8b 45 14             	mov    0x14(%ebp),%eax
400006bf:	83 c0 04             	add    $0x4,%eax
			break;
400006c2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
400006c5:	89 45 14             	mov    %eax,0x14(%ebp)
			break;
400006c8:	e9 a2 fe ff ff       	jmp    4000056f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
400006cd:	8b 45 14             	mov    0x14(%ebp),%eax
400006d0:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
400006d2:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
400006d6:	0f 8f af 01 00 00    	jg     4000088b <vprintfmt+0x32b>
		return va_arg(*ap, unsigned long);
400006dc:	83 c0 04             	add    $0x4,%eax
400006df:	31 c9                	xor    %ecx,%ecx
400006e1:	bf 0a 00 00 00       	mov    $0xa,%edi
400006e6:	89 45 14             	mov    %eax,0x14(%ebp)
400006e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			printnum(putch, putdat, num, base, width, padc);
400006f0:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
400006f4:	83 ec 0c             	sub    $0xc,%esp
400006f7:	50                   	push   %eax
400006f8:	89 d8                	mov    %ebx,%eax
400006fa:	ff 75 e4             	push   -0x1c(%ebp)
400006fd:	57                   	push   %edi
400006fe:	51                   	push   %ecx
400006ff:	52                   	push   %edx
40000700:	89 f2                	mov    %esi,%edx
40000702:	e8 79 fd ff ff       	call   40000480 <printnum>
			break;
40000707:	83 c4 20             	add    $0x20,%esp
4000070a:	e9 60 fe ff ff       	jmp    4000056f <vprintfmt+0xf>
			putch('0', putdat);
4000070f:	83 ec 08             	sub    $0x8,%esp
			goto number;
40000712:	bf 10 00 00 00       	mov    $0x10,%edi
			putch('0', putdat);
40000717:	56                   	push   %esi
40000718:	6a 30                	push   $0x30
4000071a:	ff d3                	call   *%ebx
			putch('x', putdat);
4000071c:	58                   	pop    %eax
4000071d:	5a                   	pop    %edx
4000071e:	56                   	push   %esi
4000071f:	6a 78                	push   $0x78
40000721:	ff d3                	call   *%ebx
			num = (unsigned long long)
40000723:	8b 45 14             	mov    0x14(%ebp),%eax
40000726:	31 c9                	xor    %ecx,%ecx
40000728:	8b 10                	mov    (%eax),%edx
				(uintptr_t) va_arg(ap, void *);
4000072a:	83 c0 04             	add    $0x4,%eax
			goto number;
4000072d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
40000730:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;
40000733:	eb bb                	jmp    400006f0 <vprintfmt+0x190>
		return va_arg(*ap, unsigned long long);
40000735:	8b 45 14             	mov    0x14(%ebp),%eax
40000738:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
4000073a:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
4000073e:	0f 8f 5a 01 00 00    	jg     4000089e <vprintfmt+0x33e>
		return va_arg(*ap, unsigned long);
40000744:	83 c0 04             	add    $0x4,%eax
40000747:	31 c9                	xor    %ecx,%ecx
40000749:	bf 10 00 00 00       	mov    $0x10,%edi
4000074e:	89 45 14             	mov    %eax,0x14(%ebp)
40000751:	eb 9d                	jmp    400006f0 <vprintfmt+0x190>
		return va_arg(*ap, long long);
40000753:	8b 45 14             	mov    0x14(%ebp),%eax
	if (lflag >= 2)
40000756:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
4000075a:	0f 8f 51 01 00 00    	jg     400008b1 <vprintfmt+0x351>
		return va_arg(*ap, long);
40000760:	8b 4d 14             	mov    0x14(%ebp),%ecx
40000763:	8b 00                	mov    (%eax),%eax
40000765:	83 c1 04             	add    $0x4,%ecx
40000768:	99                   	cltd
40000769:	89 4d 14             	mov    %ecx,0x14(%ebp)
			if ((long long) num < 0) {
4000076c:	85 d2                	test   %edx,%edx
4000076e:	0f 88 68 01 00 00    	js     400008dc <vprintfmt+0x37c>
			num = getint(&ap, lflag);
40000774:	89 d1                	mov    %edx,%ecx
40000776:	bf 0a 00 00 00       	mov    $0xa,%edi
4000077b:	89 c2                	mov    %eax,%edx
4000077d:	e9 6e ff ff ff       	jmp    400006f0 <vprintfmt+0x190>
			lflag++;
40000782:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000786:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000789:	e9 38 fe ff ff       	jmp    400005c6 <vprintfmt+0x66>
			putch('X', putdat);
4000078e:	83 ec 08             	sub    $0x8,%esp
40000791:	56                   	push   %esi
40000792:	6a 58                	push   $0x58
40000794:	ff d3                	call   *%ebx
			putch('X', putdat);
40000796:	59                   	pop    %ecx
40000797:	5f                   	pop    %edi
40000798:	56                   	push   %esi
40000799:	6a 58                	push   $0x58
4000079b:	ff d3                	call   *%ebx
			putch('X', putdat);
4000079d:	58                   	pop    %eax
4000079e:	5a                   	pop    %edx
4000079f:	56                   	push   %esi
400007a0:	6a 58                	push   $0x58
400007a2:	ff d3                	call   *%ebx
			break;
400007a4:	83 c4 10             	add    $0x10,%esp
400007a7:	e9 c3 fd ff ff       	jmp    4000056f <vprintfmt+0xf>
			if ((p = va_arg(ap, char *)) == NULL)
400007ac:	8b 45 14             	mov    0x14(%ebp),%eax
400007af:	83 c0 04             	add    $0x4,%eax
400007b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
400007b5:	8b 45 14             	mov    0x14(%ebp),%eax
400007b8:	8b 38                	mov    (%eax),%edi
			if (width > 0 && padc != '-')
400007ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400007bd:	85 c0                	test   %eax,%eax
400007bf:	0f 9f c0             	setg   %al
400007c2:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
400007c6:	0f 95 c2             	setne  %dl
400007c9:	21 d0                	and    %edx,%eax
			if ((p = va_arg(ap, char *)) == NULL)
400007cb:	85 ff                	test   %edi,%edi
400007cd:	0f 84 32 01 00 00    	je     40000905 <vprintfmt+0x3a5>
			if (width > 0 && padc != '-')
400007d3:	84 c0                	test   %al,%al
400007d5:	0f 85 4d 01 00 00    	jne    40000928 <vprintfmt+0x3c8>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400007db:	0f be 07             	movsbl (%edi),%eax
400007de:	89 c2                	mov    %eax,%edx
400007e0:	85 c0                	test   %eax,%eax
400007e2:	74 7b                	je     4000085f <vprintfmt+0x2ff>
400007e4:	89 5d 08             	mov    %ebx,0x8(%ebp)
400007e7:	83 c7 01             	add    $0x1,%edi
400007ea:	89 cb                	mov    %ecx,%ebx
400007ec:	89 75 0c             	mov    %esi,0xc(%ebp)
400007ef:	8b 75 e4             	mov    -0x1c(%ebp),%esi
400007f2:	eb 21                	jmp    40000815 <vprintfmt+0x2b5>
400007f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					putch(ch, putdat);
400007f8:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400007fb:	83 c7 01             	add    $0x1,%edi
					putch(ch, putdat);
400007fe:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000801:	83 ee 01             	sub    $0x1,%esi
					putch(ch, putdat);
40000804:	50                   	push   %eax
40000805:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000808:	0f be 47 ff          	movsbl -0x1(%edi),%eax
4000080c:	83 c4 10             	add    $0x10,%esp
4000080f:	89 c2                	mov    %eax,%edx
40000811:	85 c0                	test   %eax,%eax
40000813:	74 41                	je     40000856 <vprintfmt+0x2f6>
40000815:	85 db                	test   %ebx,%ebx
40000817:	78 05                	js     4000081e <vprintfmt+0x2be>
40000819:	83 eb 01             	sub    $0x1,%ebx
4000081c:	72 38                	jb     40000856 <vprintfmt+0x2f6>
				if (altflag && (ch < ' ' || ch > '~'))
4000081e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
40000821:	85 c9                	test   %ecx,%ecx
40000823:	74 d3                	je     400007f8 <vprintfmt+0x298>
40000825:	0f be ca             	movsbl %dl,%ecx
40000828:	83 e9 20             	sub    $0x20,%ecx
4000082b:	83 f9 5e             	cmp    $0x5e,%ecx
4000082e:	76 c8                	jbe    400007f8 <vprintfmt+0x298>
					putch('?', putdat);
40000830:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000833:	83 c7 01             	add    $0x1,%edi
					putch('?', putdat);
40000836:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000839:	83 ee 01             	sub    $0x1,%esi
					putch('?', putdat);
4000083c:	6a 3f                	push   $0x3f
4000083e:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000841:	0f be 4f ff          	movsbl -0x1(%edi),%ecx
40000845:	83 c4 10             	add    $0x10,%esp
40000848:	89 ca                	mov    %ecx,%edx
4000084a:	89 c8                	mov    %ecx,%eax
4000084c:	85 c9                	test   %ecx,%ecx
4000084e:	74 06                	je     40000856 <vprintfmt+0x2f6>
40000850:	85 db                	test   %ebx,%ebx
40000852:	79 c5                	jns    40000819 <vprintfmt+0x2b9>
40000854:	eb d2                	jmp    40000828 <vprintfmt+0x2c8>
40000856:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40000859:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000085c:	8b 75 0c             	mov    0xc(%ebp),%esi
			for (; width > 0; width--)
4000085f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000862:	85 c0                	test   %eax,%eax
40000864:	7e 1a                	jle    40000880 <vprintfmt+0x320>
40000866:	89 c7                	mov    %eax,%edi
40000868:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000086f:	00 
				putch(' ', putdat);
40000870:	83 ec 08             	sub    $0x8,%esp
40000873:	56                   	push   %esi
40000874:	6a 20                	push   $0x20
40000876:	ff d3                	call   *%ebx
			for (; width > 0; width--)
40000878:	83 c4 10             	add    $0x10,%esp
4000087b:	83 ef 01             	sub    $0x1,%edi
4000087e:	75 f0                	jne    40000870 <vprintfmt+0x310>
			if ((p = va_arg(ap, char *)) == NULL)
40000880:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40000883:	89 45 14             	mov    %eax,0x14(%ebp)
40000886:	e9 e4 fc ff ff       	jmp    4000056f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
4000088b:	8b 48 04             	mov    0x4(%eax),%ecx
4000088e:	83 c0 08             	add    $0x8,%eax
40000891:	bf 0a 00 00 00       	mov    $0xa,%edi
40000896:	89 45 14             	mov    %eax,0x14(%ebp)
40000899:	e9 52 fe ff ff       	jmp    400006f0 <vprintfmt+0x190>
4000089e:	8b 48 04             	mov    0x4(%eax),%ecx
400008a1:	83 c0 08             	add    $0x8,%eax
400008a4:	bf 10 00 00 00       	mov    $0x10,%edi
400008a9:	89 45 14             	mov    %eax,0x14(%ebp)
400008ac:	e9 3f fe ff ff       	jmp    400006f0 <vprintfmt+0x190>
		return va_arg(*ap, long long);
400008b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
400008b4:	8b 50 04             	mov    0x4(%eax),%edx
400008b7:	8b 00                	mov    (%eax),%eax
400008b9:	83 c1 08             	add    $0x8,%ecx
400008bc:	89 4d 14             	mov    %ecx,0x14(%ebp)
400008bf:	e9 a8 fe ff ff       	jmp    4000076c <vprintfmt+0x20c>
		switch (ch = *(unsigned char *) fmt++) {
400008c4:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
400008c8:	8b 7d 10             	mov    0x10(%ebp),%edi
400008cb:	e9 f6 fc ff ff       	jmp    400005c6 <vprintfmt+0x66>
			padc = '-';
400008d0:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400008d4:	8b 7d 10             	mov    0x10(%ebp),%edi
400008d7:	e9 ea fc ff ff       	jmp    400005c6 <vprintfmt+0x66>
				putch('-', putdat);
400008dc:	83 ec 08             	sub    $0x8,%esp
400008df:	89 45 d8             	mov    %eax,-0x28(%ebp)
				num = -(long long) num;
400008e2:	bf 0a 00 00 00       	mov    $0xa,%edi
400008e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch('-', putdat);
400008ea:	56                   	push   %esi
400008eb:	6a 2d                	push   $0x2d
400008ed:	ff d3                	call   *%ebx
				num = -(long long) num;
400008ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
400008f2:	31 d2                	xor    %edx,%edx
400008f4:	f7 d8                	neg    %eax
400008f6:	1b 55 dc             	sbb    -0x24(%ebp),%edx
400008f9:	83 c4 10             	add    $0x10,%esp
400008fc:	89 d1                	mov    %edx,%ecx
400008fe:	89 c2                	mov    %eax,%edx
40000900:	e9 eb fd ff ff       	jmp    400006f0 <vprintfmt+0x190>
			if (width > 0 && padc != '-')
40000905:	84 c0                	test   %al,%al
40000907:	75 78                	jne    40000981 <vprintfmt+0x421>
40000909:	89 5d 08             	mov    %ebx,0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000090c:	bf b6 34 00 40       	mov    $0x400034b6,%edi
40000911:	ba 28 00 00 00       	mov    $0x28,%edx
40000916:	89 cb                	mov    %ecx,%ebx
40000918:	89 75 0c             	mov    %esi,0xc(%ebp)
4000091b:	b8 28 00 00 00       	mov    $0x28,%eax
40000920:	8b 75 e4             	mov    -0x1c(%ebp),%esi
40000923:	e9 ed fe ff ff       	jmp    40000815 <vprintfmt+0x2b5>
				for (width -= strnlen(p, precision); width > 0; width--)
40000928:	83 ec 08             	sub    $0x8,%esp
4000092b:	51                   	push   %ecx
4000092c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
4000092f:	57                   	push   %edi
40000930:	e8 eb 02 00 00       	call   40000c20 <strnlen>
40000935:	29 45 e4             	sub    %eax,-0x1c(%ebp)
40000938:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
4000093b:	83 c4 10             	add    $0x10,%esp
4000093e:	85 c9                	test   %ecx,%ecx
40000940:	8b 4d d0             	mov    -0x30(%ebp),%ecx
40000943:	7e 71                	jle    400009b6 <vprintfmt+0x456>
					putch(padc, putdat);
40000945:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
40000949:	89 4d cc             	mov    %ecx,-0x34(%ebp)
4000094c:	89 7d d0             	mov    %edi,-0x30(%ebp)
4000094f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
40000952:	89 45 e0             	mov    %eax,-0x20(%ebp)
40000955:	83 ec 08             	sub    $0x8,%esp
40000958:	56                   	push   %esi
40000959:	ff 75 e0             	push   -0x20(%ebp)
4000095c:	ff d3                	call   *%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
4000095e:	83 c4 10             	add    $0x10,%esp
40000961:	83 ef 01             	sub    $0x1,%edi
40000964:	75 ef                	jne    40000955 <vprintfmt+0x3f5>
40000966:	89 7d e4             	mov    %edi,-0x1c(%ebp)
40000969:	8b 7d d0             	mov    -0x30(%ebp),%edi
4000096c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000096f:	0f be 07             	movsbl (%edi),%eax
40000972:	89 c2                	mov    %eax,%edx
40000974:	85 c0                	test   %eax,%eax
40000976:	0f 85 68 fe ff ff    	jne    400007e4 <vprintfmt+0x284>
4000097c:	e9 ff fe ff ff       	jmp    40000880 <vprintfmt+0x320>
				for (width -= strnlen(p, precision); width > 0; width--)
40000981:	83 ec 08             	sub    $0x8,%esp
				p = "(null)";
40000984:	bf b5 34 00 40       	mov    $0x400034b5,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
40000989:	51                   	push   %ecx
4000098a:	89 4d d0             	mov    %ecx,-0x30(%ebp)
4000098d:	68 b5 34 00 40       	push   $0x400034b5
40000992:	e8 89 02 00 00       	call   40000c20 <strnlen>
40000997:	29 45 e4             	sub    %eax,-0x1c(%ebp)
4000099a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
4000099d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400009a0:	ba 28 00 00 00       	mov    $0x28,%edx
400009a5:	b8 28 00 00 00       	mov    $0x28,%eax
				for (width -= strnlen(p, precision); width > 0; width--)
400009aa:	85 c9                	test   %ecx,%ecx
400009ac:	8b 4d d0             	mov    -0x30(%ebp),%ecx
400009af:	7f 94                	jg     40000945 <vprintfmt+0x3e5>
400009b1:	e9 2e fe ff ff       	jmp    400007e4 <vprintfmt+0x284>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400009b6:	0f be 07             	movsbl (%edi),%eax
400009b9:	89 c2                	mov    %eax,%edx
400009bb:	85 c0                	test   %eax,%eax
400009bd:	0f 85 21 fe ff ff    	jne    400007e4 <vprintfmt+0x284>
400009c3:	e9 b8 fe ff ff       	jmp    40000880 <vprintfmt+0x320>
400009c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400009cf:	00 

400009d0 <printfmt>:
{
400009d0:	55                   	push   %ebp
400009d1:	89 e5                	mov    %esp,%ebp
400009d3:	83 ec 08             	sub    $0x8,%esp
	vprintfmt(putch, putdat, fmt, ap);
400009d6:	8d 45 14             	lea    0x14(%ebp),%eax
400009d9:	50                   	push   %eax
400009da:	ff 75 10             	push   0x10(%ebp)
400009dd:	ff 75 0c             	push   0xc(%ebp)
400009e0:	ff 75 08             	push   0x8(%ebp)
400009e3:	e8 78 fb ff ff       	call   40000560 <vprintfmt>
}
400009e8:	83 c4 10             	add    $0x10,%esp
400009eb:	c9                   	leave
400009ec:	c3                   	ret
400009ed:	8d 76 00             	lea    0x0(%esi),%esi

400009f0 <vsprintf>:

int
vsprintf(char *buf, const char *fmt, va_list ap)
{
400009f0:	55                   	push   %ebp
400009f1:	89 e5                	mov    %esp,%ebp
400009f3:	83 ec 18             	sub    $0x18,%esp
	//assert(buf != NULL);
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400009f6:	8b 45 08             	mov    0x8(%ebp),%eax

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400009f9:	ff 75 10             	push   0x10(%ebp)
400009fc:	ff 75 0c             	push   0xc(%ebp)
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400009ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000a02:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000a05:	50                   	push   %eax
40000a06:	68 40 05 00 40       	push   $0x40000540
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
40000a0b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
40000a12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000a19:	e8 42 fb ff ff       	call   40000560 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
40000a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000a21:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000a27:	c9                   	leave
40000a28:	c3                   	ret
40000a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000a30 <sprintf>:

int
sprintf(char *buf, const char *fmt, ...)
{
40000a30:	55                   	push   %ebp
40000a31:	89 e5                	mov    %esp,%ebp
40000a33:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
40000a36:	8b 45 08             	mov    0x8(%ebp),%eax
40000a39:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
40000a40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
40000a47:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000a4a:	8d 45 10             	lea    0x10(%ebp),%eax
40000a4d:	50                   	push   %eax
40000a4e:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000a51:	ff 75 0c             	push   0xc(%ebp)
40000a54:	50                   	push   %eax
40000a55:	68 40 05 00 40       	push   $0x40000540
40000a5a:	e8 01 fb ff ff       	call   40000560 <vprintfmt>
	*b.buf = '\0';
40000a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000a62:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsprintf(buf, fmt, ap);
	va_end(ap);

	return rc;
}
40000a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000a68:	c9                   	leave
40000a69:	c3                   	ret
40000a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000a70 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
40000a70:	55                   	push   %ebp
40000a71:	89 e5                	mov    %esp,%ebp
40000a73:	83 ec 18             	sub    $0x18,%esp
40000a76:	8b 45 08             	mov    0x8(%ebp),%eax
	//assert(buf != NULL && n > 0);
	struct sprintbuf b = {buf, buf+n-1, 0};
40000a79:	8b 55 0c             	mov    0xc(%ebp),%edx

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000a7c:	ff 75 14             	push   0x14(%ebp)
40000a7f:	ff 75 10             	push   0x10(%ebp)
	struct sprintbuf b = {buf, buf+n-1, 0};
40000a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
40000a85:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
40000a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000a8c:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000a8f:	50                   	push   %eax
40000a90:	68 40 05 00 40       	push   $0x40000540
	struct sprintbuf b = {buf, buf+n-1, 0};
40000a95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000a9c:	e8 bf fa ff ff       	call   40000560 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
40000aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000aa4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000aaa:	c9                   	leave
40000aab:	c3                   	ret
40000aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000ab0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
40000ab0:	55                   	push   %ebp
40000ab1:	89 e5                	mov    %esp,%ebp
40000ab3:	83 ec 18             	sub    $0x18,%esp
40000ab6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
40000ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
40000abc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
40000ac3:	89 45 ec             	mov    %eax,-0x14(%ebp)
40000ac6:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
40000aca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000acd:	8d 45 14             	lea    0x14(%ebp),%eax
40000ad0:	50                   	push   %eax
40000ad1:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000ad4:	ff 75 10             	push   0x10(%ebp)
40000ad7:	50                   	push   %eax
40000ad8:	68 40 05 00 40       	push   $0x40000540
40000add:	e8 7e fa ff ff       	call   40000560 <vprintfmt>
	*b.buf = '\0';
40000ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000ae5:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
	va_end(ap);

	return rc;
}
40000ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000aeb:	c9                   	leave
40000aec:	c3                   	ret
40000aed:	66 90                	xchg   %ax,%ax
40000aef:	90                   	nop

40000af0 <spawn>:
#include <syscall.h>
#include <types.h>

pid_t
spawn(uintptr_t exec, unsigned int quota)
{
40000af0:	55                   	push   %ebp
	asm volatile("int %2"
40000af1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
40000af6:	b8 01 00 00 00       	mov    $0x1,%eax
40000afb:	89 e5                	mov    %esp,%ebp
40000afd:	56                   	push   %esi
40000afe:	89 d6                	mov    %edx,%esi
40000b00:	53                   	push   %ebx
40000b01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000b04:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000b07:	cd 30                	int    $0x30
	return errno ? -1 : pid;
40000b09:	85 c0                	test   %eax,%eax
40000b0b:	75 0b                	jne    40000b18 <spawn+0x28>
40000b0d:	89 da                	mov    %ebx,%edx
	// Default: inherit console stdin/stdout
	return sys_spawn(exec, quota, -1, -1);
}
40000b0f:	5b                   	pop    %ebx
40000b10:	89 d0                	mov    %edx,%eax
40000b12:	5e                   	pop    %esi
40000b13:	5d                   	pop    %ebp
40000b14:	c3                   	ret
40000b15:	8d 76 00             	lea    0x0(%esi),%esi
40000b18:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, -1, -1);
40000b1d:	eb f0                	jmp    40000b0f <spawn+0x1f>
40000b1f:	90                   	nop

40000b20 <spawn_with_fds>:

pid_t
spawn_with_fds(uintptr_t exec, unsigned int quota, int stdin_fd, int stdout_fd)
{
40000b20:	55                   	push   %ebp
	asm volatile("int %2"
40000b21:	b8 01 00 00 00       	mov    $0x1,%eax
40000b26:	89 e5                	mov    %esp,%ebp
40000b28:	56                   	push   %esi
40000b29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000b2c:	8b 55 10             	mov    0x10(%ebp),%edx
40000b2f:	53                   	push   %ebx
40000b30:	8b 75 14             	mov    0x14(%ebp),%esi
40000b33:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000b36:	cd 30                	int    $0x30
	return errno ? -1 : pid;
40000b38:	85 c0                	test   %eax,%eax
40000b3a:	75 0c                	jne    40000b48 <spawn_with_fds+0x28>
40000b3c:	89 da                	mov    %ebx,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
}
40000b3e:	5b                   	pop    %ebx
40000b3f:	89 d0                	mov    %edx,%eax
40000b41:	5e                   	pop    %esi
40000b42:	5d                   	pop    %ebp
40000b43:	c3                   	ret
40000b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000b48:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
40000b4d:	eb ef                	jmp    40000b3e <spawn_with_fds+0x1e>
40000b4f:	90                   	nop

40000b50 <yield>:
	asm volatile("int %0" :
40000b50:	b8 02 00 00 00       	mov    $0x2,%eax
40000b55:	cd 30                	int    $0x30

void
yield(void)
{
	sys_yield();
}
40000b57:	c3                   	ret
40000b58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b5f:	00 

40000b60 <produce>:
	asm volatile("int %0" :
40000b60:	b8 03 00 00 00       	mov    $0x3,%eax
40000b65:	cd 30                	int    $0x30

void
produce(void)
{
	sys_produce();
}
40000b67:	c3                   	ret
40000b68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b6f:	00 

40000b70 <consume>:
	asm volatile("int %0" :
40000b70:	b8 04 00 00 00       	mov    $0x4,%eax
40000b75:	cd 30                	int    $0x30

void
consume(void)
{
	sys_consume();
}
40000b77:	c3                   	ret
40000b78:	66 90                	xchg   %ax,%ax
40000b7a:	66 90                	xchg   %ax,%ax
40000b7c:	66 90                	xchg   %ax,%ax
40000b7e:	66 90                	xchg   %ax,%ax

40000b80 <spinlock_init>:
	return result;
}

void
spinlock_init(spinlock_t *lk)
{
40000b80:	55                   	push   %ebp
40000b81:	89 e5                	mov    %esp,%ebp
	*lk = 0;
40000b83:	8b 45 08             	mov    0x8(%ebp),%eax
40000b86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
40000b8c:	5d                   	pop    %ebp
40000b8d:	c3                   	ret
40000b8e:	66 90                	xchg   %ax,%ax

40000b90 <spinlock_acquire>:

void
spinlock_acquire(spinlock_t *lk)
{
40000b90:	55                   	push   %ebp
	asm volatile("lock; xchgl %0, %1" :
40000b91:	b8 01 00 00 00       	mov    $0x1,%eax
{
40000b96:	89 e5                	mov    %esp,%ebp
40000b98:	8b 55 08             	mov    0x8(%ebp),%edx
	asm volatile("lock; xchgl %0, %1" :
40000b9b:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000b9e:	85 c0                	test   %eax,%eax
40000ba0:	74 1c                	je     40000bbe <spinlock_acquire+0x2e>
40000ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000baf:	00 
		asm volatile("pause");
40000bb0:	f3 90                	pause
	asm volatile("lock; xchgl %0, %1" :
40000bb2:	b8 01 00 00 00       	mov    $0x1,%eax
40000bb7:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000bba:	85 c0                	test   %eax,%eax
40000bbc:	75 f2                	jne    40000bb0 <spinlock_acquire+0x20>
}
40000bbe:	5d                   	pop    %ebp
40000bbf:	c3                   	ret

40000bc0 <spinlock_release>:

// Release the lock.
void
spinlock_release(spinlock_t *lk)
{
40000bc0:	55                   	push   %ebp
40000bc1:	89 e5                	mov    %esp,%ebp
40000bc3:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
bool
spinlock_holding(spinlock_t *lock)
{
	return *lock;
40000bc6:	8b 02                	mov    (%edx),%eax
	if (spinlock_holding(lk) == FALSE)
40000bc8:	84 c0                	test   %al,%al
40000bca:	74 05                	je     40000bd1 <spinlock_release+0x11>
	asm volatile("lock; xchgl %0, %1" :
40000bcc:	31 c0                	xor    %eax,%eax
40000bce:	f0 87 02             	lock xchg %eax,(%edx)
}
40000bd1:	5d                   	pop    %ebp
40000bd2:	c3                   	ret
40000bd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bdf:	00 

40000be0 <spinlock_holding>:
{
40000be0:	55                   	push   %ebp
40000be1:	89 e5                	mov    %esp,%ebp
	return *lock;
40000be3:	8b 45 08             	mov    0x8(%ebp),%eax
}
40000be6:	5d                   	pop    %ebp
	return *lock;
40000be7:	8b 00                	mov    (%eax),%eax
}
40000be9:	c3                   	ret
40000bea:	66 90                	xchg   %ax,%ax
40000bec:	66 90                	xchg   %ax,%ax
40000bee:	66 90                	xchg   %ax,%ax
40000bf0:	66 90                	xchg   %ax,%ax
40000bf2:	66 90                	xchg   %ax,%ax
40000bf4:	66 90                	xchg   %ax,%ax
40000bf6:	66 90                	xchg   %ax,%ax
40000bf8:	66 90                	xchg   %ax,%ax
40000bfa:	66 90                	xchg   %ax,%ax
40000bfc:	66 90                	xchg   %ax,%ax
40000bfe:	66 90                	xchg   %ax,%ax

40000c00 <strlen>:
#include <string.h>
#include <types.h>

int
strlen(const char *s)
{
40000c00:	55                   	push   %ebp
	int n;

	for (n = 0; *s != '\0'; s++)
40000c01:	31 c0                	xor    %eax,%eax
{
40000c03:	89 e5                	mov    %esp,%ebp
40000c05:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; *s != '\0'; s++)
40000c08:	80 3a 00             	cmpb   $0x0,(%edx)
40000c0b:	74 0c                	je     40000c19 <strlen+0x19>
40000c0d:	8d 76 00             	lea    0x0(%esi),%esi
		n++;
40000c10:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
40000c13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
40000c17:	75 f7                	jne    40000c10 <strlen+0x10>
	return n;
}
40000c19:	5d                   	pop    %ebp
40000c1a:	c3                   	ret
40000c1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

40000c20 <strnlen>:

int
strnlen(const char *s, size_t size)
{
40000c20:	55                   	push   %ebp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000c21:	31 c0                	xor    %eax,%eax
{
40000c23:	89 e5                	mov    %esp,%ebp
40000c25:	8b 55 0c             	mov    0xc(%ebp),%edx
40000c28:	8b 4d 08             	mov    0x8(%ebp),%ecx
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000c2b:	85 d2                	test   %edx,%edx
40000c2d:	75 18                	jne    40000c47 <strnlen+0x27>
40000c2f:	eb 1c                	jmp    40000c4d <strnlen+0x2d>
40000c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c3f:	00 
		n++;
40000c40:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000c43:	39 c2                	cmp    %eax,%edx
40000c45:	74 06                	je     40000c4d <strnlen+0x2d>
40000c47:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
40000c4b:	75 f3                	jne    40000c40 <strnlen+0x20>
	return n;
}
40000c4d:	5d                   	pop    %ebp
40000c4e:	c3                   	ret
40000c4f:	90                   	nop

40000c50 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
40000c50:	55                   	push   %ebp
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
40000c51:	31 c0                	xor    %eax,%eax
{
40000c53:	89 e5                	mov    %esp,%ebp
40000c55:	53                   	push   %ebx
40000c56:	8b 4d 08             	mov    0x8(%ebp),%ecx
40000c59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while ((*dst++ = *src++) != '\0')
40000c60:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000c64:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000c67:	83 c0 01             	add    $0x1,%eax
40000c6a:	84 d2                	test   %dl,%dl
40000c6c:	75 f2                	jne    40000c60 <strcpy+0x10>
		/* do nothing */;
	return ret;
}
40000c6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c71:	89 c8                	mov    %ecx,%eax
40000c73:	c9                   	leave
40000c74:	c3                   	ret
40000c75:	8d 76 00             	lea    0x0(%esi),%esi
40000c78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c7f:	00 

40000c80 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size)
{
40000c80:	55                   	push   %ebp
40000c81:	89 e5                	mov    %esp,%ebp
40000c83:	56                   	push   %esi
40000c84:	8b 55 0c             	mov    0xc(%ebp),%edx
40000c87:	8b 75 08             	mov    0x8(%ebp),%esi
40000c8a:	53                   	push   %ebx
40000c8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
40000c8e:	85 db                	test   %ebx,%ebx
40000c90:	74 21                	je     40000cb3 <strncpy+0x33>
40000c92:	01 f3                	add    %esi,%ebx
40000c94:	89 f0                	mov    %esi,%eax
40000c96:	66 90                	xchg   %ax,%ax
40000c98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c9f:	00 
		*dst++ = *src;
40000ca0:	0f b6 0a             	movzbl (%edx),%ecx
40000ca3:	83 c0 01             	add    $0x1,%eax
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
40000ca6:	80 f9 01             	cmp    $0x1,%cl
		*dst++ = *src;
40000ca9:	88 48 ff             	mov    %cl,-0x1(%eax)
			src++;
40000cac:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
40000caf:	39 c3                	cmp    %eax,%ebx
40000cb1:	75 ed                	jne    40000ca0 <strncpy+0x20>
	}
	return ret;
}
40000cb3:	89 f0                	mov    %esi,%eax
40000cb5:	5b                   	pop    %ebx
40000cb6:	5e                   	pop    %esi
40000cb7:	5d                   	pop    %ebp
40000cb8:	c3                   	ret
40000cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000cc0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
40000cc0:	55                   	push   %ebp
40000cc1:	89 e5                	mov    %esp,%ebp
40000cc3:	53                   	push   %ebx
40000cc4:	8b 45 10             	mov    0x10(%ebp),%eax
40000cc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
40000cca:	85 c0                	test   %eax,%eax
40000ccc:	74 2e                	je     40000cfc <strlcpy+0x3c>
		while (--size > 0 && *src != '\0')
40000cce:	8b 55 08             	mov    0x8(%ebp),%edx
40000cd1:	83 e8 01             	sub    $0x1,%eax
40000cd4:	74 23                	je     40000cf9 <strlcpy+0x39>
40000cd6:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
40000cd9:	eb 12                	jmp    40000ced <strlcpy+0x2d>
40000cdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
			*dst++ = *src++;
40000ce0:	83 c2 01             	add    $0x1,%edx
40000ce3:	83 c1 01             	add    $0x1,%ecx
40000ce6:	88 42 ff             	mov    %al,-0x1(%edx)
		while (--size > 0 && *src != '\0')
40000ce9:	39 da                	cmp    %ebx,%edx
40000ceb:	74 07                	je     40000cf4 <strlcpy+0x34>
40000ced:	0f b6 01             	movzbl (%ecx),%eax
40000cf0:	84 c0                	test   %al,%al
40000cf2:	75 ec                	jne    40000ce0 <strlcpy+0x20>
		*dst = '\0';
	}
	return dst - dst_in;
40000cf4:	89 d0                	mov    %edx,%eax
40000cf6:	2b 45 08             	sub    0x8(%ebp),%eax
		*dst = '\0';
40000cf9:	c6 02 00             	movb   $0x0,(%edx)
}
40000cfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000cff:	c9                   	leave
40000d00:	c3                   	ret
40000d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d0f:	00 

40000d10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
40000d10:	55                   	push   %ebp
40000d11:	89 e5                	mov    %esp,%ebp
40000d13:	53                   	push   %ebx
40000d14:	8b 55 08             	mov    0x8(%ebp),%edx
40000d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
40000d1a:	0f b6 02             	movzbl (%edx),%eax
40000d1d:	84 c0                	test   %al,%al
40000d1f:	75 2d                	jne    40000d4e <strcmp+0x3e>
40000d21:	eb 4a                	jmp    40000d6d <strcmp+0x5d>
40000d23:	eb 1b                	jmp    40000d40 <strcmp+0x30>
40000d25:	8d 76 00             	lea    0x0(%esi),%esi
40000d28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d2f:	00 
40000d30:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d37:	00 
40000d38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d3f:	00 
40000d40:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		p++, q++;
40000d44:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
40000d47:	84 c0                	test   %al,%al
40000d49:	74 15                	je     40000d60 <strcmp+0x50>
40000d4b:	83 c1 01             	add    $0x1,%ecx
40000d4e:	0f b6 19             	movzbl (%ecx),%ebx
40000d51:	38 c3                	cmp    %al,%bl
40000d53:	74 eb                	je     40000d40 <strcmp+0x30>
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000d55:	29 d8                	sub    %ebx,%eax
}
40000d57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000d5a:	c9                   	leave
40000d5b:	c3                   	ret
40000d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000d60:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
40000d64:	31 c0                	xor    %eax,%eax
40000d66:	29 d8                	sub    %ebx,%eax
}
40000d68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000d6b:	c9                   	leave
40000d6c:	c3                   	ret
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000d6d:	0f b6 19             	movzbl (%ecx),%ebx
40000d70:	31 c0                	xor    %eax,%eax
40000d72:	eb e1                	jmp    40000d55 <strcmp+0x45>
40000d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000d78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d7f:	00 

40000d80 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
40000d80:	55                   	push   %ebp
40000d81:	89 e5                	mov    %esp,%ebp
40000d83:	53                   	push   %ebx
40000d84:	8b 55 10             	mov    0x10(%ebp),%edx
40000d87:	8b 45 08             	mov    0x8(%ebp),%eax
40000d8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
40000d8d:	85 d2                	test   %edx,%edx
40000d8f:	75 16                	jne    40000da7 <strncmp+0x27>
40000d91:	eb 2d                	jmp    40000dc0 <strncmp+0x40>
40000d93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d98:	3a 19                	cmp    (%ecx),%bl
40000d9a:	75 12                	jne    40000dae <strncmp+0x2e>
		n--, p++, q++;
40000d9c:	83 c0 01             	add    $0x1,%eax
40000d9f:	83 c1 01             	add    $0x1,%ecx
	while (n > 0 && *p && *p == *q)
40000da2:	83 ea 01             	sub    $0x1,%edx
40000da5:	74 19                	je     40000dc0 <strncmp+0x40>
40000da7:	0f b6 18             	movzbl (%eax),%ebx
40000daa:	84 db                	test   %bl,%bl
40000dac:	75 ea                	jne    40000d98 <strncmp+0x18>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000dae:	0f b6 00             	movzbl (%eax),%eax
40000db1:	0f b6 11             	movzbl (%ecx),%edx
}
40000db4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000db7:	c9                   	leave
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000db8:	29 d0                	sub    %edx,%eax
}
40000dba:	c3                   	ret
40000dbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000dc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
		return 0;
40000dc3:	31 c0                	xor    %eax,%eax
}
40000dc5:	c9                   	leave
40000dc6:	c3                   	ret
40000dc7:	90                   	nop
40000dc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000dcf:	00 

40000dd0 <strchr>:

char *
strchr(const char *s, char c)
{
40000dd0:	55                   	push   %ebp
40000dd1:	89 e5                	mov    %esp,%ebp
40000dd3:	8b 45 08             	mov    0x8(%ebp),%eax
40000dd6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
40000dda:	0f b6 10             	movzbl (%eax),%edx
40000ddd:	84 d2                	test   %dl,%dl
40000ddf:	75 1a                	jne    40000dfb <strchr+0x2b>
40000de1:	eb 25                	jmp    40000e08 <strchr+0x38>
40000de3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000de8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000def:	00 
40000df0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000df4:	83 c0 01             	add    $0x1,%eax
40000df7:	84 d2                	test   %dl,%dl
40000df9:	74 0d                	je     40000e08 <strchr+0x38>
		if (*s == c)
40000dfb:	38 d1                	cmp    %dl,%cl
40000dfd:	75 f1                	jne    40000df0 <strchr+0x20>
			return (char *) s;
	return 0;
}
40000dff:	5d                   	pop    %ebp
40000e00:	c3                   	ret
40000e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return 0;
40000e08:	31 c0                	xor    %eax,%eax
}
40000e0a:	5d                   	pop    %ebp
40000e0b:	c3                   	ret
40000e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000e10 <strfind>:

char *
strfind(const char *s, char c)
{
40000e10:	55                   	push   %ebp
40000e11:	89 e5                	mov    %esp,%ebp
40000e13:	8b 45 08             	mov    0x8(%ebp),%eax
40000e16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	for (; *s; s++)
40000e19:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
40000e1c:	38 ca                	cmp    %cl,%dl
40000e1e:	75 1b                	jne    40000e3b <strfind+0x2b>
40000e20:	eb 1d                	jmp    40000e3f <strfind+0x2f>
40000e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000e28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e2f:	00 
	for (; *s; s++)
40000e30:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000e34:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
40000e37:	38 ca                	cmp    %cl,%dl
40000e39:	74 04                	je     40000e3f <strfind+0x2f>
40000e3b:	84 d2                	test   %dl,%dl
40000e3d:	75 f1                	jne    40000e30 <strfind+0x20>
			break;
	return (char *) s;
}
40000e3f:	5d                   	pop    %ebp
40000e40:	c3                   	ret
40000e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000e48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e4f:	00 

40000e50 <strtol>:


long
strtol(const char *s, char **endptr, int base)
{
40000e50:	55                   	push   %ebp
40000e51:	89 e5                	mov    %esp,%ebp
40000e53:	57                   	push   %edi
40000e54:	8b 55 08             	mov    0x8(%ebp),%edx
40000e57:	56                   	push   %esi
40000e58:	53                   	push   %ebx
40000e59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
40000e5c:	0f b6 02             	movzbl (%edx),%eax
40000e5f:	3c 09                	cmp    $0x9,%al
40000e61:	74 0d                	je     40000e70 <strtol+0x20>
40000e63:	3c 20                	cmp    $0x20,%al
40000e65:	75 18                	jne    40000e7f <strtol+0x2f>
40000e67:	90                   	nop
40000e68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e6f:	00 
40000e70:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		s++;
40000e74:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
40000e77:	3c 20                	cmp    $0x20,%al
40000e79:	74 f5                	je     40000e70 <strtol+0x20>
40000e7b:	3c 09                	cmp    $0x9,%al
40000e7d:	74 f1                	je     40000e70 <strtol+0x20>

	// plus/minus sign
	if (*s == '+')
40000e7f:	3c 2b                	cmp    $0x2b,%al
40000e81:	0f 84 89 00 00 00    	je     40000f10 <strtol+0xc0>
		s++;
	else if (*s == '-')
		s++, neg = 1;
40000e87:	3c 2d                	cmp    $0x2d,%al
40000e89:	8d 4a 01             	lea    0x1(%edx),%ecx
40000e8c:	0f 94 c0             	sete   %al
40000e8f:	0f 44 d1             	cmove  %ecx,%edx
40000e92:	0f b6 c0             	movzbl %al,%eax

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000e95:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
40000e9b:	75 10                	jne    40000ead <strtol+0x5d>
40000e9d:	80 3a 30             	cmpb   $0x30,(%edx)
40000ea0:	74 7e                	je     40000f20 <strtol+0xd0>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
40000ea2:	83 fb 01             	cmp    $0x1,%ebx
40000ea5:	19 db                	sbb    %ebx,%ebx
40000ea7:	83 e3 fa             	and    $0xfffffffa,%ebx
40000eaa:	83 c3 10             	add    $0x10,%ebx
40000ead:	89 5d 10             	mov    %ebx,0x10(%ebp)
40000eb0:	31 c9                	xor    %ecx,%ecx
40000eb2:	89 c7                	mov    %eax,%edi
40000eb4:	eb 13                	jmp    40000ec9 <strtol+0x79>
40000eb6:	66 90                	xchg   %ax,%ax
40000eb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ebf:	00 
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
		s++, val = (val * base) + dig;
40000ec0:	0f af 4d 10          	imul   0x10(%ebp),%ecx
40000ec4:	83 c2 01             	add    $0x1,%edx
40000ec7:	01 f1                	add    %esi,%ecx
		if (*s >= '0' && *s <= '9')
40000ec9:	0f be 1a             	movsbl (%edx),%ebx
40000ecc:	8d 43 d0             	lea    -0x30(%ebx),%eax
			dig = *s - '0';
40000ecf:	8d 73 d0             	lea    -0x30(%ebx),%esi
		if (*s >= '0' && *s <= '9')
40000ed2:	3c 09                	cmp    $0x9,%al
40000ed4:	76 14                	jbe    40000eea <strtol+0x9a>
		else if (*s >= 'a' && *s <= 'z')
40000ed6:	8d 43 9f             	lea    -0x61(%ebx),%eax
			dig = *s - 'a' + 10;
40000ed9:	8d 73 a9             	lea    -0x57(%ebx),%esi
		else if (*s >= 'a' && *s <= 'z')
40000edc:	3c 19                	cmp    $0x19,%al
40000ede:	76 0a                	jbe    40000eea <strtol+0x9a>
		else if (*s >= 'A' && *s <= 'Z')
40000ee0:	8d 43 bf             	lea    -0x41(%ebx),%eax
40000ee3:	3c 19                	cmp    $0x19,%al
40000ee5:	77 08                	ja     40000eef <strtol+0x9f>
			dig = *s - 'A' + 10;
40000ee7:	8d 73 c9             	lea    -0x37(%ebx),%esi
		if (dig >= base)
40000eea:	3b 75 10             	cmp    0x10(%ebp),%esi
40000eed:	7c d1                	jl     40000ec0 <strtol+0x70>
		// we don't properly detect overflow!
	}

	if (endptr)
40000eef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000ef2:	89 f8                	mov    %edi,%eax
40000ef4:	85 db                	test   %ebx,%ebx
40000ef6:	74 05                	je     40000efd <strtol+0xad>
		*endptr = (char *) s;
40000ef8:	8b 7d 0c             	mov    0xc(%ebp),%edi
40000efb:	89 17                	mov    %edx,(%edi)
	return (neg ? -val : val);
40000efd:	89 ca                	mov    %ecx,%edx
}
40000eff:	5b                   	pop    %ebx
40000f00:	5e                   	pop    %esi
	return (neg ? -val : val);
40000f01:	f7 da                	neg    %edx
40000f03:	85 c0                	test   %eax,%eax
}
40000f05:	5f                   	pop    %edi
40000f06:	5d                   	pop    %ebp
	return (neg ? -val : val);
40000f07:	0f 45 ca             	cmovne %edx,%ecx
}
40000f0a:	89 c8                	mov    %ecx,%eax
40000f0c:	c3                   	ret
40000f0d:	8d 76 00             	lea    0x0(%esi),%esi
		s++;
40000f10:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
40000f13:	31 c0                	xor    %eax,%eax
40000f15:	e9 7b ff ff ff       	jmp    40000e95 <strtol+0x45>
40000f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000f20:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
40000f24:	74 1b                	je     40000f41 <strtol+0xf1>
	else if (base == 0 && s[0] == '0')
40000f26:	85 db                	test   %ebx,%ebx
40000f28:	74 0a                	je     40000f34 <strtol+0xe4>
40000f2a:	bb 10 00 00 00       	mov    $0x10,%ebx
40000f2f:	e9 79 ff ff ff       	jmp    40000ead <strtol+0x5d>
		s++, base = 8;
40000f34:	83 c2 01             	add    $0x1,%edx
40000f37:	bb 08 00 00 00       	mov    $0x8,%ebx
40000f3c:	e9 6c ff ff ff       	jmp    40000ead <strtol+0x5d>
		s += 2, base = 16;
40000f41:	83 c2 02             	add    $0x2,%edx
40000f44:	bb 10 00 00 00       	mov    $0x10,%ebx
40000f49:	e9 5f ff ff ff       	jmp    40000ead <strtol+0x5d>
40000f4e:	66 90                	xchg   %ax,%ax

40000f50 <memset>:

void *
memset(void *v, int c, size_t n)
{
40000f50:	55                   	push   %ebp
40000f51:	89 e5                	mov    %esp,%ebp
40000f53:	57                   	push   %edi
40000f54:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000f57:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000f5a:	85 c9                	test   %ecx,%ecx
40000f5c:	74 1a                	je     40000f78 <memset+0x28>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
40000f5e:	89 d0                	mov    %edx,%eax
40000f60:	09 c8                	or     %ecx,%eax
40000f62:	a8 03                	test   $0x3,%al
40000f64:	75 1a                	jne    40000f80 <memset+0x30>
		c &= 0xFF;
40000f66:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
40000f6a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000f6d:	89 d7                	mov    %edx,%edi
40000f6f:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
40000f75:	fc                   	cld
40000f76:	f3 ab                	rep stos %eax,%es:(%edi)
	} else
		asm volatile("cld; rep stosb\n"
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
}
40000f78:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000f7b:	89 d0                	mov    %edx,%eax
40000f7d:	c9                   	leave
40000f7e:	c3                   	ret
40000f7f:	90                   	nop
		asm volatile("cld; rep stosb\n"
40000f80:	8b 45 0c             	mov    0xc(%ebp),%eax
40000f83:	89 d7                	mov    %edx,%edi
40000f85:	fc                   	cld
40000f86:	f3 aa                	rep stos %al,%es:(%edi)
}
40000f88:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000f8b:	89 d0                	mov    %edx,%eax
40000f8d:	c9                   	leave
40000f8e:	c3                   	ret
40000f8f:	90                   	nop

40000f90 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
40000f90:	55                   	push   %ebp
40000f91:	89 e5                	mov    %esp,%ebp
40000f93:	57                   	push   %edi
40000f94:	8b 45 08             	mov    0x8(%ebp),%eax
40000f97:	8b 55 0c             	mov    0xc(%ebp),%edx
40000f9a:	56                   	push   %esi
40000f9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000f9e:	53                   	push   %ebx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
40000f9f:	39 c2                	cmp    %eax,%edx
40000fa1:	73 2d                	jae    40000fd0 <memmove+0x40>
40000fa3:	8d 1c 0a             	lea    (%edx,%ecx,1),%ebx
40000fa6:	39 d8                	cmp    %ebx,%eax
40000fa8:	73 26                	jae    40000fd0 <memmove+0x40>
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000faa:	8d 14 08             	lea    (%eax,%ecx,1),%edx
40000fad:	09 ca                	or     %ecx,%edx
40000faf:	09 da                	or     %ebx,%edx
40000fb1:	83 e2 03             	and    $0x3,%edx
40000fb4:	74 4a                	je     40001000 <memmove+0x70>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
				     : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
40000fb6:	8d 7c 08 ff          	lea    -0x1(%eax,%ecx,1),%edi
40000fba:	8d 73 ff             	lea    -0x1(%ebx),%esi
40000fbd:	fd                   	std
40000fbe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				     :: "D" (d-1), "S" (s-1), "c" (n)
				     : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
40000fc0:	fc                   	cld
			asm volatile("cld; rep movsb\n"
				     :: "D" (d), "S" (s), "c" (n)
				     : "cc", "memory");
	}
	return dst;
}
40000fc1:	5b                   	pop    %ebx
40000fc2:	5e                   	pop    %esi
40000fc3:	5f                   	pop    %edi
40000fc4:	5d                   	pop    %ebp
40000fc5:	c3                   	ret
40000fc6:	66 90                	xchg   %ax,%ax
40000fc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000fcf:	00 
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000fd0:	89 c3                	mov    %eax,%ebx
40000fd2:	09 cb                	or     %ecx,%ebx
40000fd4:	09 d3                	or     %edx,%ebx
40000fd6:	83 e3 03             	and    $0x3,%ebx
40000fd9:	74 15                	je     40000ff0 <memmove+0x60>
			asm volatile("cld; rep movsb\n"
40000fdb:	89 c7                	mov    %eax,%edi
40000fdd:	89 d6                	mov    %edx,%esi
40000fdf:	fc                   	cld
40000fe0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000fe2:	5b                   	pop    %ebx
40000fe3:	5e                   	pop    %esi
40000fe4:	5f                   	pop    %edi
40000fe5:	5d                   	pop    %ebp
40000fe6:	c3                   	ret
40000fe7:	90                   	nop
40000fe8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000fef:	00 
				     :: "D" (d), "S" (s), "c" (n/4)
40000ff0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
40000ff3:	89 c7                	mov    %eax,%edi
40000ff5:	89 d6                	mov    %edx,%esi
40000ff7:	fc                   	cld
40000ff8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000ffa:	eb e6                	jmp    40000fe2 <memmove+0x52>
40000ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			asm volatile("std; rep movsl\n"
40001000:	8d 7c 08 fc          	lea    -0x4(%eax,%ecx,1),%edi
40001004:	8d 73 fc             	lea    -0x4(%ebx),%esi
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
40001007:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
4000100a:	fd                   	std
4000100b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
4000100d:	eb b1                	jmp    40000fc0 <memmove+0x30>
4000100f:	90                   	nop

40001010 <memcpy>:

void *
memcpy(void *dst, const void *src, size_t n)
{
	return memmove(dst, src, n);
40001010:	e9 7b ff ff ff       	jmp    40000f90 <memmove>
40001015:	8d 76 00             	lea    0x0(%esi),%esi
40001018:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000101f:	00 

40001020 <memcmp>:
}

int
memcmp(const void *v1, const void *v2, size_t n)
{
40001020:	55                   	push   %ebp
40001021:	89 e5                	mov    %esp,%ebp
40001023:	56                   	push   %esi
40001024:	8b 75 10             	mov    0x10(%ebp),%esi
40001027:	8b 45 08             	mov    0x8(%ebp),%eax
4000102a:	53                   	push   %ebx
4000102b:	8b 55 0c             	mov    0xc(%ebp),%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
4000102e:	85 f6                	test   %esi,%esi
40001030:	74 2e                	je     40001060 <memcmp+0x40>
40001032:	01 c6                	add    %eax,%esi
40001034:	eb 14                	jmp    4000104a <memcmp+0x2a>
40001036:	66 90                	xchg   %ax,%ax
40001038:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000103f:	00 
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
40001040:	83 c0 01             	add    $0x1,%eax
40001043:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
40001046:	39 f0                	cmp    %esi,%eax
40001048:	74 16                	je     40001060 <memcmp+0x40>
		if (*s1 != *s2)
4000104a:	0f b6 08             	movzbl (%eax),%ecx
4000104d:	0f b6 1a             	movzbl (%edx),%ebx
40001050:	38 d9                	cmp    %bl,%cl
40001052:	74 ec                	je     40001040 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
40001054:	0f b6 c1             	movzbl %cl,%eax
40001057:	29 d8                	sub    %ebx,%eax
	}

	return 0;
}
40001059:	5b                   	pop    %ebx
4000105a:	5e                   	pop    %esi
4000105b:	5d                   	pop    %ebp
4000105c:	c3                   	ret
4000105d:	8d 76 00             	lea    0x0(%esi),%esi
40001060:	5b                   	pop    %ebx
	return 0;
40001061:	31 c0                	xor    %eax,%eax
}
40001063:	5e                   	pop    %esi
40001064:	5d                   	pop    %ebp
40001065:	c3                   	ret
40001066:	66 90                	xchg   %ax,%ax
40001068:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000106f:	00 

40001070 <memchr>:

void *
memchr(const void *s, int c, size_t n)
{
40001070:	55                   	push   %ebp
40001071:	89 e5                	mov    %esp,%ebp
40001073:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
40001076:	8b 55 10             	mov    0x10(%ebp),%edx
40001079:	01 c2                	add    %eax,%edx
	for (; s < ends; s++)
4000107b:	39 d0                	cmp    %edx,%eax
4000107d:	73 21                	jae    400010a0 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
4000107f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
40001083:	eb 12                	jmp    40001097 <memchr+0x27>
40001085:	8d 76 00             	lea    0x0(%esi),%esi
40001088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000108f:	00 
	for (; s < ends; s++)
40001090:	83 c0 01             	add    $0x1,%eax
40001093:	39 c2                	cmp    %eax,%edx
40001095:	74 09                	je     400010a0 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40001097:	38 08                	cmp    %cl,(%eax)
40001099:	75 f5                	jne    40001090 <memchr+0x20>
			return (void *) s;
	return NULL;
}
4000109b:	5d                   	pop    %ebp
4000109c:	c3                   	ret
4000109d:	8d 76 00             	lea    0x0(%esi),%esi
	return NULL;
400010a0:	31 c0                	xor    %eax,%eax
}
400010a2:	5d                   	pop    %ebp
400010a3:	c3                   	ret
400010a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400010a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400010af:	00 

400010b0 <memzero>:

void *
memzero(void *v, size_t n)
{
400010b0:	55                   	push   %ebp
400010b1:	89 e5                	mov    %esp,%ebp
400010b3:	57                   	push   %edi
400010b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
400010b7:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
400010ba:	85 c9                	test   %ecx,%ecx
400010bc:	74 11                	je     400010cf <memzero+0x1f>
	if ((int)v%4 == 0 && n%4 == 0) {
400010be:	89 d0                	mov    %edx,%eax
400010c0:	09 c8                	or     %ecx,%eax
400010c2:	83 e0 03             	and    $0x3,%eax
400010c5:	75 19                	jne    400010e0 <memzero+0x30>
			     :: "D" (v), "a" (c), "c" (n/4)
400010c7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
400010ca:	89 d7                	mov    %edx,%edi
400010cc:	fc                   	cld
400010cd:	f3 ab                	rep stos %eax,%es:(%edi)
	return memset(v, 0, n);
}
400010cf:	8b 7d fc             	mov    -0x4(%ebp),%edi
400010d2:	89 d0                	mov    %edx,%eax
400010d4:	c9                   	leave
400010d5:	c3                   	ret
400010d6:	66 90                	xchg   %ax,%ax
400010d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400010df:	00 
		asm volatile("cld; rep stosb\n"
400010e0:	89 d7                	mov    %edx,%edi
400010e2:	31 c0                	xor    %eax,%eax
400010e4:	fc                   	cld
400010e5:	f3 aa                	rep stos %al,%es:(%edi)
}
400010e7:	8b 7d fc             	mov    -0x4(%ebp),%edi
400010ea:	89 d0                	mov    %edx,%eax
400010ec:	c9                   	leave
400010ed:	c3                   	ret
400010ee:	66 90                	xchg   %ax,%ax

400010f0 <sigaction>:
#include <signal.h>
#include <syscall.h>

int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
400010f0:	55                   	push   %ebp

static gcc_inline int
sys_sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
	int errno;
	asm volatile ("int %1"
400010f1:	b8 1a 00 00 00       	mov    $0x1a,%eax
400010f6:	89 e5                	mov    %esp,%ebp
400010f8:	53                   	push   %ebx
400010f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
400010fc:	8b 55 10             	mov    0x10(%ebp),%edx
400010ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
40001102:	cd 30                	int    $0x30
		        "a" (SYS_sigaction),
		        "b" (signum),
		        "c" (act),
		        "d" (oldact)
		      : "cc", "memory");
	return errno ? -1 : 0;
40001104:	f7 d8                	neg    %eax
    return sys_sigaction(signum, act, oldact);
}
40001106:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40001109:	c9                   	leave
4000110a:	19 c0                	sbb    %eax,%eax
4000110c:	c3                   	ret
4000110d:	8d 76 00             	lea    0x0(%esi),%esi

40001110 <kill>:

int kill(int pid, int signum)
{
40001110:	55                   	push   %ebp

static gcc_inline int
sys_kill(int pid, int signum)
{
	int errno;
	asm volatile ("int %1"
40001111:	b8 1b 00 00 00       	mov    $0x1b,%eax
40001116:	89 e5                	mov    %esp,%ebp
40001118:	53                   	push   %ebx
40001119:	8b 4d 0c             	mov    0xc(%ebp),%ecx
4000111c:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000111f:	cd 30                	int    $0x30
		      : "i" (T_SYSCALL),
		        "a" (SYS_kill),
		        "b" (pid),
		        "c" (signum)
		      : "cc", "memory");
	return errno ? -1 : 0;
40001121:	f7 d8                	neg    %eax
    return sys_kill(pid, signum);
}
40001123:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40001126:	c9                   	leave
40001127:	19 c0                	sbb    %eax,%eax
40001129:	c3                   	ret
4000112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40001130 <pause>:

static gcc_inline int
sys_pause(void)
{
	int errno;
	asm volatile ("int %1"
40001130:	b8 1c 00 00 00       	mov    $0x1c,%eax
40001135:	cd 30                	int    $0x30
		      : "=a" (errno)
		      : "i" (T_SYSCALL),
		        "a" (SYS_pause)
		      : "cc", "memory");
	return errno ? -1 : 0;
40001137:	f7 d8                	neg    %eax
40001139:	19 c0                	sbb    %eax,%eax

int pause(void)
{
    return sys_pause();
}
4000113b:	c3                   	ret
4000113c:	66 90                	xchg   %ax,%ax
4000113e:	66 90                	xchg   %ax,%ax

40001140 <shell_help>:
int shell_help(int argc, char **argv) {
40001140:	55                   	push   %ebp
40001141:	89 e5                	mov    %esp,%ebp
40001143:	53                   	push   %ebx
40001144:	bb 20 44 00 40       	mov    $0x40004420,%ebx
40001149:	83 ec 04             	sub    $0x4,%esp
4000114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf("%s - %s\n", commands[i].name, commands[i].desc);
40001150:	83 ec 04             	sub    $0x4,%esp
40001153:	ff 73 04             	push   0x4(%ebx)
  for (i = 0; i < NCOMMANDS; i++) {
40001156:	83 c3 0c             	add    $0xc,%ebx
    printf("%s - %s\n", commands[i].name, commands[i].desc);
40001159:	ff 73 f4             	push   -0xc(%ebx)
4000115c:	68 bc 34 00 40       	push   $0x400034bc
40001161:	e8 fa f2 ff ff       	call   40000460 <printf>
  for (i = 0; i < NCOMMANDS; i++) {
40001166:	83 c4 10             	add    $0x10,%esp
40001169:	81 fb e0 44 00 40    	cmp    $0x400044e0,%ebx
4000116f:	75 df                	jne    40001150 <shell_help+0x10>
}
40001171:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40001174:	31 c0                	xor    %eax,%eax
40001176:	c9                   	leave
40001177:	c3                   	ret
40001178:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000117f:	00 

40001180 <shell_pwd>:
int shell_pwd(int argc, char **argv) {
40001180:	55                   	push   %ebp
	asm volatile ("int %2"
40001181:	b8 15 00 00 00       	mov    $0x15,%eax
40001186:	89 e5                	mov    %esp,%ebp
40001188:	53                   	push   %ebx
40001189:	bb a0 55 00 40       	mov    $0x400055a0,%ebx
4000118e:	83 ec 0c             	sub    $0xc,%esp
40001191:	cd 30                	int    $0x30
  printf("%s\n", shell_buf);
40001193:	68 a0 55 00 40       	push   $0x400055a0
40001198:	68 c1 34 00 40       	push   $0x400034c1
4000119d:	e8 be f2 ff ff       	call   40000460 <printf>
}
400011a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
400011a5:	31 c0                	xor    %eax,%eax
400011a7:	c9                   	leave
400011a8:	c3                   	ret
400011a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400011b0 <signal_handler>:
  else
    printf("Failed to send signal (error: %d)\n", result);
  return 0;
}

void signal_handler(int signum) {
400011b0:	55                   	push   %ebp
400011b1:	89 e5                	mov    %esp,%ebp
400011b3:	83 ec 10             	sub    $0x10,%esp
  printf("\n*** Received signal %d ***\n", signum);
400011b6:	ff 75 08             	push   0x8(%ebp)
400011b9:	68 c5 34 00 40       	push   $0x400034c5
400011be:	e8 9d f2 ff ff       	call   40000460 <printf>
  printf(">:"); // Reprint prompt
400011c3:	83 c4 10             	add    $0x10,%esp
400011c6:	c7 45 08 e2 34 00 40 	movl   $0x400034e2,0x8(%ebp)
}
400011cd:	c9                   	leave
  printf(">:"); // Reprint prompt
400011ce:	e9 8d f2 ff ff       	jmp    40000460 <printf>
400011d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
400011d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400011df:	00 

400011e0 <shell_mkdir>:
int shell_mkdir(int argc, char **argv) {
400011e0:	55                   	push   %ebp
400011e1:	89 e5                	mov    %esp,%ebp
400011e3:	57                   	push   %edi
400011e4:	56                   	push   %esi
400011e5:	53                   	push   %ebx
400011e6:	83 ec 0c             	sub    $0xc,%esp
400011e9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if (argc == 1)
400011ec:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
400011f0:	74 3e                	je     40001230 <shell_mkdir+0x50>
  for (i = 1; i < argc; i++) {
400011f2:	7e 30                	jle    40001224 <shell_mkdir+0x44>
400011f4:	be 01 00 00 00       	mov    $0x1,%esi
400011f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (sys_mkdir(argv[i]) == 0)
40001200:	8b 1c b7             	mov    (%edi,%esi,4),%ebx
  unsigned int len = strlen(path);
40001203:	83 ec 0c             	sub    $0xc,%esp
40001206:	53                   	push   %ebx
40001207:	e8 f4 f9 ff ff       	call   40000c00 <strlen>
4000120c:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000120e:	b8 0a 00 00 00       	mov    $0xa,%eax
40001213:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001215:	83 c4 10             	add    $0x10,%esp
40001218:	85 c0                	test   %eax,%eax
4000121a:	75 34                	jne    40001250 <shell_mkdir+0x70>
  for (i = 1; i < argc; i++) {
4000121c:	83 c6 01             	add    $0x1,%esi
4000121f:	39 75 08             	cmp    %esi,0x8(%ebp)
40001222:	75 dc                	jne    40001200 <shell_mkdir+0x20>
}
40001224:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001227:	31 c0                	xor    %eax,%eax
40001229:	5b                   	pop    %ebx
4000122a:	5e                   	pop    %esi
4000122b:	5f                   	pop    %edi
4000122c:	5d                   	pop    %ebp
4000122d:	c3                   	ret
4000122e:	66 90                	xchg   %ax,%ax
    printf("mkdir failed, no path\n");
40001230:	83 ec 0c             	sub    $0xc,%esp
40001233:	68 e5 34 00 40       	push   $0x400034e5
40001238:	e8 23 f2 ff ff       	call   40000460 <printf>
4000123d:	83 c4 10             	add    $0x10,%esp
}
40001240:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001243:	31 c0                	xor    %eax,%eax
40001245:	5b                   	pop    %ebx
40001246:	5e                   	pop    %esi
40001247:	5f                   	pop    %edi
40001248:	5d                   	pop    %ebp
40001249:	c3                   	ret
4000124a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf("make dir failed.\n");
40001250:	83 ec 0c             	sub    $0xc,%esp
40001253:	68 fc 34 00 40       	push   $0x400034fc
40001258:	e8 03 f2 ff ff       	call   40000460 <printf>
4000125d:	83 c4 10             	add    $0x10,%esp
40001260:	eb ba                	jmp    4000121c <shell_mkdir+0x3c>
40001262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001268:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000126f:	00 

40001270 <shell_write>:
int shell_write(int argc, char **argv) {
40001270:	55                   	push   %ebp
40001271:	89 e5                	mov    %esp,%ebp
40001273:	56                   	push   %esi
40001274:	53                   	push   %ebx
40001275:	83 ec 10             	sub    $0x10,%esp
  if (argc == 1) {
40001278:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
4000127c:	0f 84 ae 00 00 00    	je     40001330 <shell_write+0xc0>
  int fd = open(argv[2], O_CREATE | O_RDWR);
40001282:	8b 45 0c             	mov    0xc(%ebp),%eax
        unsigned int len = strlen(path);
40001285:	83 ec 0c             	sub    $0xc,%esp
40001288:	8b 70 08             	mov    0x8(%eax),%esi
4000128b:	56                   	push   %esi
	asm volatile("int %2"
4000128c:	89 f3                	mov    %esi,%ebx
        unsigned int len = strlen(path);
4000128e:	e8 6d f9 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40001293:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
40001298:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
4000129a:	b8 05 00 00 00       	mov    $0x5,%eax
4000129f:	cd 30                	int    $0x30
400012a1:	89 de                	mov    %ebx,%esi
  if (fd >= 0) {
400012a3:	83 c4 10             	add    $0x10,%esp
400012a6:	85 db                	test   %ebx,%ebx
400012a8:	78 66                	js     40001310 <shell_write+0xa0>
400012aa:	85 c0                	test   %eax,%eax
400012ac:	75 62                	jne    40001310 <shell_write+0xa0>
    int n = write(fd, argv[1], strlen(argv[1]));
400012ae:	8b 45 0c             	mov    0xc(%ebp),%eax
400012b1:	83 ec 0c             	sub    $0xc,%esp
400012b4:	ff 70 04             	push   0x4(%eax)
400012b7:	e8 44 f9 ff ff       	call   40000c00 <strlen>
400012bc:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
400012be:	8b 45 0c             	mov    0xc(%ebp),%eax
400012c1:	8b 40 04             	mov    0x4(%eax),%eax
400012c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
400012c7:	b8 08 00 00 00       	mov    $0x8,%eax
400012cc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
400012cf:	cd 30                	int    $0x30
	return errno ? -1 : ret;
400012d1:	85 c0                	test   %eax,%eax
	asm volatile("int %2"
400012d3:	89 da                	mov    %ebx,%edx
	return errno ? -1 : ret;
400012d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
400012da:	59                   	pop    %ecx
400012db:	0f 45 d0             	cmovne %eax,%edx
    if (n != strlen(argv[1])) {
400012de:	8b 45 0c             	mov    0xc(%ebp),%eax
400012e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
400012e4:	ff 70 04             	push   0x4(%eax)
400012e7:	e8 14 f9 ff ff       	call   40000c00 <strlen>
400012ec:	83 c4 10             	add    $0x10,%esp
400012ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
400012f2:	75 5c                	jne    40001350 <shell_write+0xe0>
	asm volatile("int %2"
400012f4:	b8 06 00 00 00       	mov    $0x6,%eax
400012f9:	89 f3                	mov    %esi,%ebx
400012fb:	cd 30                	int    $0x30
}
400012fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
40001300:	31 c0                	xor    %eax,%eax
40001302:	5b                   	pop    %ebx
40001303:	5e                   	pop    %esi
40001304:	5d                   	pop    %ebp
40001305:	c3                   	ret
40001306:	66 90                	xchg   %ax,%ax
40001308:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000130f:	00 
    printf("shell write fail\n");
40001310:	83 ec 0c             	sub    $0xc,%esp
40001313:	68 0e 35 00 40       	push   $0x4000350e
40001318:	e8 43 f1 ff ff       	call   40000460 <printf>
4000131d:	83 c4 10             	add    $0x10,%esp
}
40001320:	8d 65 f8             	lea    -0x8(%ebp),%esp
40001323:	31 c0                	xor    %eax,%eax
40001325:	5b                   	pop    %ebx
40001326:	5e                   	pop    %esi
40001327:	5d                   	pop    %ebp
40001328:	c3                   	ret
40001329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    printf("write failed, too few arguments.\n");
40001330:	83 ec 0c             	sub    $0xc,%esp
40001333:	68 b8 3a 00 40       	push   $0x40003ab8
40001338:	e8 23 f1 ff ff       	call   40000460 <printf>
    return 0;
4000133d:	83 c4 10             	add    $0x10,%esp
}
40001340:	8d 65 f8             	lea    -0x8(%ebp),%esp
40001343:	31 c0                	xor    %eax,%eax
40001345:	5b                   	pop    %ebx
40001346:	5e                   	pop    %esi
40001347:	5d                   	pop    %ebp
40001348:	c3                   	ret
40001349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf("shell write fail\n");
40001350:	83 ec 0c             	sub    $0xc,%esp
40001353:	68 0e 35 00 40       	push   $0x4000350e
40001358:	e8 03 f1 ff ff       	call   40000460 <printf>
4000135d:	83 c4 10             	add    $0x10,%esp
40001360:	eb 92                	jmp    400012f4 <shell_write+0x84>
40001362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001368:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000136f:	00 

40001370 <is_process_cmd>:
static int is_process_cmd(const char *name) {
40001370:	55                   	push   %ebp
40001371:	89 e5                	mov    %esp,%ebp
40001373:	53                   	push   %ebx
40001374:	89 c3                	mov    %eax,%ebx
40001376:	83 ec 0c             	sub    $0xc,%esp
  return strcmp(name, "CAT") == 0 || strcmp(name, "LS") == 0 ||
40001379:	68 20 35 00 40       	push   $0x40003520
4000137e:	50                   	push   %eax
4000137f:	e8 8c f9 ff ff       	call   40000d10 <strcmp>
         strcmp(name, "ROT13") == 0 || strcmp(name, "biral") == 0 ||
40001384:	83 c4 10             	add    $0x10,%esp
40001387:	85 c0                	test   %eax,%eax
40001389:	75 0d                	jne    40001398 <is_process_cmd+0x28>
4000138b:	b8 01 00 00 00       	mov    $0x1,%eax
}
40001390:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40001393:	c9                   	leave
40001394:	c3                   	ret
40001395:	8d 76 00             	lea    0x0(%esi),%esi
  return strcmp(name, "CAT") == 0 || strcmp(name, "LS") == 0 ||
40001398:	83 ec 08             	sub    $0x8,%esp
4000139b:	68 24 35 00 40       	push   $0x40003524
400013a0:	53                   	push   %ebx
400013a1:	e8 6a f9 ff ff       	call   40000d10 <strcmp>
400013a6:	83 c4 10             	add    $0x10,%esp
400013a9:	85 c0                	test   %eax,%eax
400013ab:	74 de                	je     4000138b <is_process_cmd+0x1b>
         strcmp(name, "ROT13") == 0 || strcmp(name, "biral") == 0 ||
400013ad:	83 ec 08             	sub    $0x8,%esp
400013b0:	68 27 35 00 40       	push   $0x40003527
400013b5:	53                   	push   %ebx
400013b6:	e8 55 f9 ff ff       	call   40000d10 <strcmp>
  return strcmp(name, "CAT") == 0 || strcmp(name, "LS") == 0 ||
400013bb:	83 c4 10             	add    $0x10,%esp
400013be:	85 c0                	test   %eax,%eax
400013c0:	74 c9                	je     4000138b <is_process_cmd+0x1b>
         strcmp(name, "ROT13") == 0 || strcmp(name, "biral") == 0 ||
400013c2:	83 ec 08             	sub    $0x8,%esp
400013c5:	68 2d 35 00 40       	push   $0x4000352d
400013ca:	53                   	push   %ebx
400013cb:	e8 40 f9 ff ff       	call   40000d10 <strcmp>
400013d0:	83 c4 10             	add    $0x10,%esp
400013d3:	85 c0                	test   %eax,%eax
400013d5:	74 b4                	je     4000138b <is_process_cmd+0x1b>
         strcmp(name, "BIRAL") == 0;
400013d7:	83 ec 08             	sub    $0x8,%esp
400013da:	68 33 35 00 40       	push   $0x40003533
400013df:	53                   	push   %ebx
400013e0:	e8 2b f9 ff ff       	call   40000d10 <strcmp>
         strcmp(name, "ROT13") == 0 || strcmp(name, "biral") == 0 ||
400013e5:	83 c4 10             	add    $0x10,%esp
400013e8:	85 c0                	test   %eax,%eax
400013ea:	0f 94 c0             	sete   %al
400013ed:	0f b6 c0             	movzbl %al,%eax
400013f0:	eb 9e                	jmp    40001390 <is_process_cmd+0x20>
400013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400013f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400013ff:	00 

40001400 <shell_append>:
int shell_append(int argc, char **argv) {
40001400:	55                   	push   %ebp
40001401:	89 e5                	mov    %esp,%ebp
40001403:	57                   	push   %edi
40001404:	56                   	push   %esi
40001405:	53                   	push   %ebx
40001406:	81 ec fc 03 00 00    	sub    $0x3fc,%esp
  if (argc == 1) {
4000140c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
40001410:	0f 84 2a 01 00 00    	je     40001540 <shell_append+0x140>
  int fd = open(argv[2], O_RDONLY);
40001416:	8b 45 0c             	mov    0xc(%ebp),%eax
        unsigned int len = strlen(path);
40001419:	83 ec 0c             	sub    $0xc,%esp
4000141c:	8b 70 08             	mov    0x8(%eax),%esi
4000141f:	56                   	push   %esi
	asm volatile("int %2"
40001420:	89 f3                	mov    %esi,%ebx
        unsigned int len = strlen(path);
40001422:	e8 d9 f7 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40001427:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40001429:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
4000142b:	b8 05 00 00 00       	mov    $0x5,%eax
40001430:	cd 30                	int    $0x30
40001432:	89 de                	mov    %ebx,%esi
  if (fd >= 0) {
40001434:	83 c4 10             	add    $0x10,%esp
40001437:	85 db                	test   %ebx,%ebx
40001439:	0f 88 c1 00 00 00    	js     40001500 <shell_append+0x100>
4000143f:	85 c0                	test   %eax,%eax
40001441:	0f 85 b9 00 00 00    	jne    40001500 <shell_append+0x100>
	asm volatile("int %2"
40001447:	b8 07 00 00 00       	mov    $0x7,%eax
4000144c:	ba e8 03 00 00       	mov    $0x3e8,%edx
40001451:	8d 8d 00 fc ff ff    	lea    -0x400(%ebp),%ecx
40001457:	cd 30                	int    $0x30
	return errno ? -1 : ret;
40001459:	85 c0                	test   %eax,%eax
	asm volatile("int %2"
4000145b:	89 df                	mov    %ebx,%edi
	asm volatile("int %2"
4000145d:	b8 06 00 00 00       	mov    $0x6,%eax
40001462:	89 f3                	mov    %esi,%ebx
	return errno ? -1 : ret;
40001464:	0f 84 b6 00 00 00    	je     40001520 <shell_append+0x120>
	asm volatile("int %2"
4000146a:	cd 30                	int    $0x30
4000146c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    fd = open(argv[2], O_CREATE | O_RDWR);
40001471:	8b 45 0c             	mov    0xc(%ebp),%eax
        unsigned int len = strlen(path);
40001474:	83 ec 0c             	sub    $0xc,%esp
40001477:	8b 70 08             	mov    0x8(%eax),%esi
4000147a:	56                   	push   %esi
	asm volatile("int %2"
4000147b:	89 f3                	mov    %esi,%ebx
        unsigned int len = strlen(path);
4000147d:	e8 7e f7 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40001482:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
40001487:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001489:	b8 05 00 00 00       	mov    $0x5,%eax
4000148e:	cd 30                	int    $0x30
40001490:	89 de                	mov    %ebx,%esi
    if (fd < 0) {
40001492:	83 c4 10             	add    $0x10,%esp
40001495:	85 db                	test   %ebx,%ebx
40001497:	0f 88 c3 00 00 00    	js     40001560 <shell_append+0x160>
4000149d:	85 c0                	test   %eax,%eax
4000149f:	0f 85 bb 00 00 00    	jne    40001560 <shell_append+0x160>
    strncpy(buf + n, argv[1], strlen(argv[1]));
400014a5:	8b 45 0c             	mov    0xc(%ebp),%eax
400014a8:	83 ec 0c             	sub    $0xc,%esp
400014ab:	ff 70 04             	push   0x4(%eax)
400014ae:	e8 4d f7 ff ff       	call   40000c00 <strlen>
400014b3:	83 c4 0c             	add    $0xc,%esp
400014b6:	50                   	push   %eax
400014b7:	8b 45 0c             	mov    0xc(%ebp),%eax
400014ba:	ff 70 04             	push   0x4(%eax)
400014bd:	8d 84 3d 00 fc ff ff 	lea    -0x400(%ebp,%edi,1),%eax
400014c4:	50                   	push   %eax
400014c5:	e8 b6 f7 ff ff       	call   40000c80 <strncpy>
    write(fd, buf, strlen(buf));
400014ca:	8d 85 00 fc ff ff    	lea    -0x400(%ebp),%eax
400014d0:	89 04 24             	mov    %eax,(%esp)
400014d3:	e8 28 f7 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
400014d8:	8d 8d 00 fc ff ff    	lea    -0x400(%ebp),%ecx
400014de:	89 c2                	mov    %eax,%edx
400014e0:	b8 08 00 00 00       	mov    $0x8,%eax
400014e5:	cd 30                	int    $0x30
	asm volatile("int %2"
400014e7:	b8 06 00 00 00       	mov    $0x6,%eax
400014ec:	89 f3                	mov    %esi,%ebx
400014ee:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400014f0:	83 c4 10             	add    $0x10,%esp
}
400014f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
400014f6:	31 c0                	xor    %eax,%eax
400014f8:	5b                   	pop    %ebx
400014f9:	5e                   	pop    %esi
400014fa:	5f                   	pop    %edi
400014fb:	5d                   	pop    %ebp
400014fc:	c3                   	ret
400014fd:	8d 76 00             	lea    0x0(%esi),%esi
    printf("open append failed!\n");
40001500:	83 ec 0c             	sub    $0xc,%esp
40001503:	68 51 35 00 40       	push   $0x40003551
40001508:	e8 53 ef ff ff       	call   40000460 <printf>
4000150d:	83 c4 10             	add    $0x10,%esp
}
40001510:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001513:	31 c0                	xor    %eax,%eax
40001515:	5b                   	pop    %ebx
40001516:	5e                   	pop    %esi
40001517:	5f                   	pop    %edi
40001518:	5d                   	pop    %ebp
40001519:	c3                   	ret
4000151a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	asm volatile("int %2"
40001520:	cd 30                	int    $0x30
    if (n == 0) {
40001522:	85 ff                	test   %edi,%edi
40001524:	0f 85 47 ff ff ff    	jne    40001471 <shell_append+0x71>
      buf[0] = 0;
4000152a:	c6 85 00 fc ff ff 00 	movb   $0x0,-0x400(%ebp)
40001531:	e9 3b ff ff ff       	jmp    40001471 <shell_append+0x71>
40001536:	66 90                	xchg   %ax,%ax
40001538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000153f:	00 
    printf("append failed, too few arguments.\n");
40001540:	83 ec 0c             	sub    $0xc,%esp
40001543:	68 dc 3a 00 40       	push   $0x40003adc
40001548:	e8 13 ef ff ff       	call   40000460 <printf>
    return 0;
4000154d:	83 c4 10             	add    $0x10,%esp
}
40001550:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001553:	31 c0                	xor    %eax,%eax
40001555:	5b                   	pop    %ebx
40001556:	5e                   	pop    %esi
40001557:	5f                   	pop    %edi
40001558:	5d                   	pop    %ebp
40001559:	c3                   	ret
4000155a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf("create: append failed!\n");
40001560:	83 ec 0c             	sub    $0xc,%esp
40001563:	68 39 35 00 40       	push   $0x40003539
40001568:	e8 f3 ee ff ff       	call   40000460 <printf>
      return 0;
4000156d:	83 c4 10             	add    $0x10,%esp
}
40001570:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001573:	31 c0                	xor    %eax,%eax
40001575:	5b                   	pop    %ebx
40001576:	5e                   	pop    %esi
40001577:	5f                   	pop    %edi
40001578:	5d                   	pop    %ebp
40001579:	c3                   	ret
4000157a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40001580 <shell_kill>:
int shell_kill(int argc, char **argv) {
40001580:	55                   	push   %ebp
40001581:	89 e5                	mov    %esp,%ebp
40001583:	57                   	push   %edi
40001584:	56                   	push   %esi
40001585:	53                   	push   %ebx
40001586:	83 ec 1c             	sub    $0x1c,%esp
40001589:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if (argc < 3) {
4000158c:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
40001590:	0f 8e d2 00 00 00    	jle    40001668 <shell_kill+0xe8>
  if (argv[1][0] == '-')
40001596:	8b 43 04             	mov    0x4(%ebx),%eax
40001599:	80 38 2d             	cmpb   $0x2d,(%eax)
  int result = 0;
4000159c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  if (argv[1][0] == '-')
400015a3:	0f 84 9f 00 00 00    	je     40001648 <shell_kill+0xc8>
  atoi(s, &result);
400015a9:	83 ec 08             	sub    $0x8,%esp
400015ac:	8d 7d e4             	lea    -0x1c(%ebp),%edi
400015af:	57                   	push   %edi
400015b0:	50                   	push   %eax
400015b1:	e8 2a ed ff ff       	call   400002e0 <atoi>
  return result;
400015b6:	8b 75 e4             	mov    -0x1c(%ebp),%esi
400015b9:	83 c4 10             	add    $0x10,%esp
  atoi(s, &result);
400015bc:	83 ec 08             	sub    $0x8,%esp
  int result = 0;
400015bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  atoi(s, &result);
400015c6:	57                   	push   %edi
400015c7:	ff 73 08             	push   0x8(%ebx)
400015ca:	e8 11 ed ff ff       	call   400002e0 <atoi>
  if (sig < 1 || sig > 31) {
400015cf:	8d 46 ff             	lea    -0x1(%esi),%eax
  return result;
400015d2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  if (sig < 1 || sig > 31) {
400015d5:	83 c4 10             	add    $0x10,%esp
400015d8:	83 f8 1e             	cmp    $0x1e,%eax
400015db:	0f 87 bd 00 00 00    	ja     4000169e <shell_kill+0x11e>
  if (pid < 1 || pid > 63) {
400015e1:	8d 43 ff             	lea    -0x1(%ebx),%eax
400015e4:	83 f8 3e             	cmp    $0x3e,%eax
400015e7:	0f 87 99 00 00 00    	ja     40001686 <shell_kill+0x106>
  printf("Sending signal %d to process %d...\n", sig, pid);
400015ed:	83 ec 04             	sub    $0x4,%esp
400015f0:	53                   	push   %ebx
400015f1:	56                   	push   %esi
400015f2:	68 4c 3b 00 40       	push   $0x40003b4c
400015f7:	e8 64 ee ff ff       	call   40000460 <printf>
  int result = kill(pid, sig);
400015fc:	58                   	pop    %eax
400015fd:	5a                   	pop    %edx
400015fe:	56                   	push   %esi
400015ff:	53                   	push   %ebx
40001600:	e8 0b fb ff ff       	call   40001110 <kill>
  if (result == 0)
40001605:	83 c4 10             	add    $0x10,%esp
40001608:	85 c0                	test   %eax,%eax
4000160a:	75 24                	jne    40001630 <shell_kill+0xb0>
    printf("Signal sent successfully.\n");
4000160c:	83 ec 0c             	sub    $0xc,%esp
4000160f:	68 97 35 00 40       	push   $0x40003597
40001614:	e8 47 ee ff ff       	call   40000460 <printf>
40001619:	83 c4 10             	add    $0x10,%esp
    return 0;
4000161c:	31 c0                	xor    %eax,%eax
}
4000161e:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001621:	5b                   	pop    %ebx
40001622:	5e                   	pop    %esi
40001623:	5f                   	pop    %edi
40001624:	5d                   	pop    %ebp
40001625:	c3                   	ret
40001626:	66 90                	xchg   %ax,%ax
40001628:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000162f:	00 
    printf("Failed to send signal (error: %d)\n", result);
40001630:	83 ec 08             	sub    $0x8,%esp
40001633:	50                   	push   %eax
40001634:	68 70 3b 00 40       	push   $0x40003b70
40001639:	e8 22 ee ff ff       	call   40000460 <printf>
4000163e:	83 c4 10             	add    $0x10,%esp
40001641:	eb d9                	jmp    4000161c <shell_kill+0x9c>
40001643:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  atoi(s, &result);
40001648:	83 ec 08             	sub    $0x8,%esp
    sig = str_to_int(&argv[1][1]);
4000164b:	83 c0 01             	add    $0x1,%eax
  atoi(s, &result);
4000164e:	8d 7d e4             	lea    -0x1c(%ebp),%edi
40001651:	57                   	push   %edi
40001652:	50                   	push   %eax
40001653:	e8 88 ec ff ff       	call   400002e0 <atoi>
  return result;
40001658:	8b 75 e4             	mov    -0x1c(%ebp),%esi
4000165b:	83 c4 10             	add    $0x10,%esp
4000165e:	e9 59 ff ff ff       	jmp    400015bc <shell_kill+0x3c>
40001663:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    printf("Usage: kill -<signal> <pid>\n");
40001668:	83 ec 0c             	sub    $0xc,%esp
4000166b:	68 66 35 00 40       	push   $0x40003566
40001670:	e8 eb ed ff ff       	call   40000460 <printf>
    printf("Example: kill -9 2\n");
40001675:	c7 04 24 83 35 00 40 	movl   $0x40003583,(%esp)
4000167c:	e8 df ed ff ff       	call   40000460 <printf>
    return 0;
40001681:	83 c4 10             	add    $0x10,%esp
40001684:	eb 96                	jmp    4000161c <shell_kill+0x9c>
    printf("Invalid PID: %d (must be 1-63)\n", pid);
40001686:	83 ec 08             	sub    $0x8,%esp
40001689:	53                   	push   %ebx
4000168a:	68 2c 3b 00 40       	push   $0x40003b2c
4000168f:	e8 cc ed ff ff       	call   40000460 <printf>
    return -1; /* BUG FIX: was bare return; */
40001694:	83 c4 10             	add    $0x10,%esp
    return -1; /* BUG FIX: was bare return; */
40001697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
4000169c:	eb 80                	jmp    4000161e <shell_kill+0x9e>
    printf("Invalid signal number: %d (must be 1-31)\n", sig);
4000169e:	83 ec 08             	sub    $0x8,%esp
400016a1:	56                   	push   %esi
400016a2:	68 00 3b 00 40       	push   $0x40003b00
400016a7:	e8 b4 ed ff ff       	call   40000460 <printf>
    return -1; /* BUG FIX: was bare return; */
400016ac:	83 c4 10             	add    $0x10,%esp
400016af:	eb e6                	jmp    40001697 <shell_kill+0x117>
400016b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400016b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400016bf:	00 

400016c0 <shell_trap>:

int shell_trap(int argc, char **argv) {
400016c0:	55                   	push   %ebp
400016c1:	89 e5                	mov    %esp,%ebp
400016c3:	56                   	push   %esi
400016c4:	53                   	push   %ebx
400016c5:	83 ec 20             	sub    $0x20,%esp
  if (argc < 2) {
400016c8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
400016cc:	0f 8e 96 00 00 00    	jle    40001768 <shell_trap+0xa8>
  atoi(s, &result);
400016d2:	8b 45 0c             	mov    0xc(%ebp),%eax
400016d5:	83 ec 08             	sub    $0x8,%esp
400016d8:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  int result = 0;
400016db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  atoi(s, &result);
400016e2:	56                   	push   %esi
400016e3:	ff 70 04             	push   0x4(%eax)
400016e6:	e8 f5 eb ff ff       	call   400002e0 <atoi>
  return result;
400016eb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    return -1;
  }

  int signum = str_to_int(argv[1]);

  if (signum < 1 || signum >= 32) {
400016ee:	83 c4 10             	add    $0x10,%esp
400016f1:	8d 43 ff             	lea    -0x1(%ebx),%eax
400016f4:	83 f8 1e             	cmp    $0x1e,%eax
400016f7:	77 57                	ja     40001750 <shell_trap+0x90>
  struct sigaction sa;
  sa.sa_handler = signal_handler;
  sa.sa_flags = 0;
  sa.sa_mask = 0;

  printf("Registering handler for signal %d at address %x...\n", signum,
400016f9:	83 ec 04             	sub    $0x4,%esp
  sa.sa_handler = signal_handler;
400016fc:	c7 45 e4 b0 11 00 40 	movl   $0x400011b0,-0x1c(%ebp)
  sa.sa_flags = 0;
40001703:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  sa.sa_mask = 0;
4000170a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  printf("Registering handler for signal %d at address %x...\n", signum,
40001711:	68 b0 11 00 40       	push   $0x400011b0
40001716:	53                   	push   %ebx
40001717:	68 c8 3b 00 40       	push   $0x40003bc8
4000171c:	e8 3f ed ff ff       	call   40000460 <printf>
         (unsigned int)signal_handler);

  if (sigaction(signum, &sa, NULL) < 0) {
40001721:	83 c4 0c             	add    $0xc,%esp
40001724:	6a 00                	push   $0x0
40001726:	56                   	push   %esi
40001727:	53                   	push   %ebx
40001728:	e8 c3 f9 ff ff       	call   400010f0 <sigaction>
4000172d:	83 c4 10             	add    $0x10,%esp
40001730:	85 c0                	test   %eax,%eax
40001732:	78 52                	js     40001786 <shell_trap+0xc6>
    printf("Failed to register signal handler\n");
    return -1;
  }

  printf("Handler registered successfully.\n");
40001734:	83 ec 0c             	sub    $0xc,%esp
40001737:	68 20 3c 00 40       	push   $0x40003c20
4000173c:	e8 1f ed ff ff       	call   40000460 <printf>
  return 0;
40001741:	83 c4 10             	add    $0x10,%esp
40001744:	31 c0                	xor    %eax,%eax
}
40001746:	8d 65 f8             	lea    -0x8(%ebp),%esp
40001749:	5b                   	pop    %ebx
4000174a:	5e                   	pop    %esi
4000174b:	5d                   	pop    %ebp
4000174c:	c3                   	ret
4000174d:	8d 76 00             	lea    0x0(%esi),%esi
    printf("Invalid signal number: %d (must be 1-31)\n", signum);
40001750:	83 ec 08             	sub    $0x8,%esp
40001753:	53                   	push   %ebx
40001754:	68 00 3b 00 40       	push   $0x40003b00
40001759:	e8 02 ed ff ff       	call   40000460 <printf>
    return -1;
4000175e:	83 c4 10             	add    $0x10,%esp
    return -1;
40001761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40001766:	eb de                	jmp    40001746 <shell_trap+0x86>
    printf("Usage: trap <signum>\n");
40001768:	83 ec 0c             	sub    $0xc,%esp
4000176b:	68 b2 35 00 40       	push   $0x400035b2
40001770:	e8 eb ec ff ff       	call   40000460 <printf>
    printf("Example: trap 2   (register handler for SIGINT)\n");
40001775:	c7 04 24 94 3b 00 40 	movl   $0x40003b94,(%esp)
4000177c:	e8 df ec ff ff       	call   40000460 <printf>
    return -1;
40001781:	83 c4 10             	add    $0x10,%esp
40001784:	eb db                	jmp    40001761 <shell_trap+0xa1>
    printf("Failed to register signal handler\n");
40001786:	83 ec 0c             	sub    $0xc,%esp
40001789:	68 fc 3b 00 40       	push   $0x40003bfc
4000178e:	e8 cd ec ff ff       	call   40000460 <printf>
    return -1;
40001793:	83 c4 10             	add    $0x10,%esp
40001796:	eb c9                	jmp    40001761 <shell_trap+0xa1>
40001798:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000179f:	00 

400017a0 <shell_spawn>:

int shell_spawn(int argc, char **argv) {
400017a0:	55                   	push   %ebp
400017a1:	89 e5                	mov    %esp,%ebp
400017a3:	53                   	push   %ebx
400017a4:	83 ec 14             	sub    $0x14,%esp
  if (argc < 2) {
400017a7:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
400017ab:	7e 7b                	jle    40001828 <shell_spawn+0x88>
  atoi(s, &result);
400017ad:	83 ec 08             	sub    $0x8,%esp
400017b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  int result = 0;
400017b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  atoi(s, &result);
400017ba:	50                   	push   %eax
400017bb:	8b 45 0c             	mov    0xc(%ebp),%eax
400017be:	ff 70 04             	push   0x4(%eax)
400017c1:	e8 1a eb ff ff       	call   400002e0 <atoi>
  return result;
400017c6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    return -1;
  }

  int elf_id = str_to_int(argv[1]);

  if (elf_id < 1 || elf_id > 9) {
400017c9:	83 c4 10             	add    $0x10,%esp
400017cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
400017cf:	83 f8 08             	cmp    $0x8,%eax
400017d2:	77 3c                	ja     40001810 <shell_spawn+0x70>
    printf("Invalid elf_id: %d (must be 1-9)\n", elf_id);
    return -1;
  }

  printf("Spawning process with elf_id %d...\n", elf_id);
400017d4:	83 ec 08             	sub    $0x8,%esp
400017d7:	53                   	push   %ebx
400017d8:	68 bc 3c 00 40       	push   $0x40003cbc
400017dd:	e8 7e ec ff ff       	call   40000460 <printf>

  pid_t new_pid = spawn(elf_id, 1000);
400017e2:	58                   	pop    %eax
400017e3:	5a                   	pop    %edx
400017e4:	68 e8 03 00 00       	push   $0x3e8
400017e9:	53                   	push   %ebx
400017ea:	e8 01 f3 ff ff       	call   40000af0 <spawn>
  if (new_pid != -1) {
400017ef:	83 c4 10             	add    $0x10,%esp
400017f2:	83 f8 ff             	cmp    $0xffffffff,%eax
400017f5:	74 4f                	je     40001846 <shell_spawn+0xa6>
    printf("Process spawned with PID %d\n", new_pid);
400017f7:	83 ec 08             	sub    $0x8,%esp
400017fa:	50                   	push   %eax
400017fb:	68 df 35 00 40       	push   $0x400035df
40001800:	e8 5b ec ff ff       	call   40000460 <printf>
  } else {
    printf("Failed to spawn process\n");
    return -1;
  }

  return 0;
40001805:	83 c4 10             	add    $0x10,%esp
40001808:	31 c0                	xor    %eax,%eax
}
4000180a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
4000180d:	c9                   	leave
4000180e:	c3                   	ret
4000180f:	90                   	nop
    printf("Invalid elf_id: %d (must be 1-9)\n", elf_id);
40001810:	83 ec 08             	sub    $0x8,%esp
40001813:	53                   	push   %ebx
40001814:	68 98 3c 00 40       	push   $0x40003c98
40001819:	e8 42 ec ff ff       	call   40000460 <printf>
    return -1;
4000181e:	83 c4 10             	add    $0x10,%esp
    return -1;
40001821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40001826:	eb e2                	jmp    4000180a <shell_spawn+0x6a>
    printf("Usage: spawn <elf_id>\n");
40001828:	83 ec 0c             	sub    $0xc,%esp
4000182b:	68 c8 35 00 40       	push   $0x400035c8
40001830:	e8 2b ec ff ff       	call   40000460 <printf>
    printf("  elf_id: 1=ping, 2=pong, 3=ding, 4=fstest, 5=shell, 6=cat, "
40001835:	c7 04 24 44 3c 00 40 	movl   $0x40003c44,(%esp)
4000183c:	e8 1f ec ff ff       	call   40000460 <printf>
    return -1;
40001841:	83 c4 10             	add    $0x10,%esp
40001844:	eb db                	jmp    40001821 <shell_spawn+0x81>
    printf("Failed to spawn process\n");
40001846:	83 ec 0c             	sub    $0xc,%esp
40001849:	68 fc 35 00 40       	push   $0x400035fc
4000184e:	e8 0d ec ff ff       	call   40000460 <printf>
    return -1;
40001853:	83 c4 10             	add    $0x10,%esp
40001856:	eb c9                	jmp    40001821 <shell_spawn+0x81>
40001858:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000185f:	00 

40001860 <shell_ls>:
int shell_ls(int argc, char **argv) {
40001860:	55                   	push   %ebp
40001861:	89 e5                	mov    %esp,%ebp
40001863:	53                   	push   %ebx
40001864:	81 ec 84 00 00 00    	sub    $0x84,%esp
4000186a:	8b 45 08             	mov    0x8(%ebp),%eax
  if (argc == 1) {
4000186d:	83 f8 01             	cmp    $0x1,%eax
40001870:	0f 84 92 00 00 00    	je     40001908 <shell_ls+0xa8>
  } else if (argc == 2) {
40001876:	83 f8 02             	cmp    $0x2,%eax
40001879:	74 1d                	je     40001898 <shell_ls+0x38>
    printf("ls: too many arguments.\n");
4000187b:	83 ec 0c             	sub    $0xc,%esp
4000187e:	68 15 36 00 40       	push   $0x40003615
40001883:	e8 d8 eb ff ff       	call   40000460 <printf>
}
40001888:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    printf("ls: too many arguments.\n");
4000188b:	83 c4 10             	add    $0x10,%esp
}
4000188e:	31 c0                	xor    %eax,%eax
40001890:	c9                   	leave
40001891:	c3                   	ret
40001892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	asm volatile ("int %2"
40001898:	b8 15 00 00 00       	mov    $0x15,%eax
4000189d:	8d 5d 94             	lea    -0x6c(%ebp),%ebx
400018a0:	cd 30                	int    $0x30
    sys_chdir(argv[1]);
400018a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  unsigned int len = strlen(path);
400018a5:	83 ec 0c             	sub    $0xc,%esp
400018a8:	8b 50 04             	mov    0x4(%eax),%edx
400018ab:	52                   	push   %edx
400018ac:	89 55 84             	mov    %edx,-0x7c(%ebp)
400018af:	e8 4c f3 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
400018b4:	8b 5d 84             	mov    -0x7c(%ebp),%ebx
  unsigned int len = strlen(path);
400018b7:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400018b9:	b8 0b 00 00 00       	mov    $0xb,%eax
400018be:	cd 30                	int    $0x30
	asm volatile("int %2"
400018c0:	b8 12 00 00 00       	mov    $0x12,%eax
400018c5:	b9 00 04 00 00       	mov    $0x400,%ecx
400018ca:	bb a0 55 00 40       	mov    $0x400055a0,%ebx
400018cf:	cd 30                	int    $0x30
    printf("%s\n", shell_buf);
400018d1:	58                   	pop    %eax
400018d2:	5a                   	pop    %edx
400018d3:	68 a0 55 00 40       	push   $0x400055a0
	asm volatile("int %2"
400018d8:	8d 5d 94             	lea    -0x6c(%ebp),%ebx
400018db:	68 c1 34 00 40       	push   $0x400034c1
400018e0:	e8 7b eb ff ff       	call   40000460 <printf>
  unsigned int len = strlen(path);
400018e5:	8d 55 94             	lea    -0x6c(%ebp),%edx
400018e8:	89 14 24             	mov    %edx,(%esp)
400018eb:	e8 10 f3 ff ff       	call   40000c00 <strlen>
400018f0:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400018f2:	b8 0b 00 00 00       	mov    $0xb,%eax
400018f7:	cd 30                	int    $0x30
}
400018f9:	31 c0                	xor    %eax,%eax
400018fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
400018fe:	83 c4 10             	add    $0x10,%esp
40001901:	c9                   	leave
40001902:	c3                   	ret
40001903:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
	asm volatile("int %2"
40001908:	b8 12 00 00 00       	mov    $0x12,%eax
4000190d:	b9 00 04 00 00       	mov    $0x400,%ecx
40001912:	bb a0 55 00 40       	mov    $0x400055a0,%ebx
40001917:	cd 30                	int    $0x30
    printf("%s\n", shell_buf);
40001919:	83 ec 08             	sub    $0x8,%esp
4000191c:	68 a0 55 00 40       	push   $0x400055a0
40001921:	68 c1 34 00 40       	push   $0x400034c1
40001926:	e8 35 eb ff ff       	call   40000460 <printf>
}
4000192b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    printf("%s\n", shell_buf);
4000192e:	83 c4 10             	add    $0x10,%esp
}
40001931:	31 c0                	xor    %eax,%eax
40001933:	c9                   	leave
40001934:	c3                   	ret
40001935:	8d 76 00             	lea    0x0(%esi),%esi
40001938:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000193f:	00 

40001940 <shell_touch>:
int shell_touch(int argc, char **argv) {
40001940:	55                   	push   %ebp
40001941:	89 e5                	mov    %esp,%ebp
40001943:	57                   	push   %edi
40001944:	56                   	push   %esi
40001945:	53                   	push   %ebx
40001946:	83 ec 1c             	sub    $0x1c,%esp
40001949:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if (argc == 1) {
4000194c:	83 f9 01             	cmp    $0x1,%ecx
4000194f:	0f 84 ab 00 00 00    	je     40001a00 <shell_touch+0xc0>
  for (i = 1; i < argc; i++) {
40001955:	bf 01 00 00 00       	mov    $0x1,%edi
4000195a:	0f 8e 8e 00 00 00    	jle    400019ee <shell_touch+0xae>
40001960:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
40001963:	8b 75 0c             	mov    0xc(%ebp),%esi
40001966:	eb 39                	jmp    400019a1 <shell_touch+0x61>
40001968:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000196f:	00 
        unsigned int len = strlen(path);
40001970:	83 ec 0c             	sub    $0xc,%esp
40001973:	53                   	push   %ebx
40001974:	e8 87 f2 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40001979:	b9 00 02 00 00       	mov    $0x200,%ecx
        unsigned int len = strlen(path);
4000197e:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001980:	b8 05 00 00 00       	mov    $0x5,%eax
40001985:	cd 30                	int    $0x30
	return errno ? -1 : fd;
40001987:	83 c4 10             	add    $0x10,%esp
4000198a:	85 c0                	test   %eax,%eax
4000198c:	0f 85 86 00 00 00    	jne    40001a18 <shell_touch+0xd8>
	asm volatile("int %2"
40001992:	b8 06 00 00 00       	mov    $0x6,%eax
40001997:	cd 30                	int    $0x30
40001999:	83 c7 01             	add    $0x1,%edi
4000199c:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
4000199f:	74 4d                	je     400019ee <shell_touch+0xae>
    fd = open(argv[i], O_RDONLY);
400019a1:	8b 1c be             	mov    (%esi,%edi,4),%ebx
        unsigned int len = strlen(path);
400019a4:	83 ec 0c             	sub    $0xc,%esp
400019a7:	53                   	push   %ebx
400019a8:	e8 53 f2 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
400019ad:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
400019af:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
400019b1:	b8 05 00 00 00       	mov    $0x5,%eax
400019b6:	cd 30                	int    $0x30
400019b8:	89 da                	mov    %ebx,%edx
    if (fd >= 0) {
400019ba:	83 c4 10             	add    $0x10,%esp
      printf("%s file exist\n", argv[i]);
400019bd:	8b 1c be             	mov    (%esi,%edi,4),%ebx
    if (fd >= 0) {
400019c0:	85 d2                	test   %edx,%edx
400019c2:	78 ac                	js     40001970 <shell_touch+0x30>
400019c4:	85 c0                	test   %eax,%eax
400019c6:	75 a8                	jne    40001970 <shell_touch+0x30>
      printf("%s file exist\n", argv[i]);
400019c8:	83 ec 08             	sub    $0x8,%esp
400019cb:	53                   	push   %ebx
400019cc:	68 47 36 00 40       	push   $0x40003647
400019d1:	89 55 e0             	mov    %edx,-0x20(%ebp)
400019d4:	e8 87 ea ff ff       	call   40000460 <printf>
	asm volatile("int %2"
400019d9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
400019dc:	b8 06 00 00 00       	mov    $0x6,%eax
400019e1:	cd 30                	int    $0x30
      continue;
400019e3:	83 c4 10             	add    $0x10,%esp
  for (i = 1; i < argc; i++) {
400019e6:	83 c7 01             	add    $0x1,%edi
400019e9:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
400019ec:	75 b3                	jne    400019a1 <shell_touch+0x61>
}
400019ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
400019f1:	31 c0                	xor    %eax,%eax
400019f3:	5b                   	pop    %ebx
400019f4:	5e                   	pop    %esi
400019f5:	5f                   	pop    %edi
400019f6:	5d                   	pop    %ebp
400019f7:	c3                   	ret
400019f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400019ff:	00 
    printf("touch failed. No Path. \n");
40001a00:	c7 45 08 2e 36 00 40 	movl   $0x4000362e,0x8(%ebp)
}
40001a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001a0a:	5b                   	pop    %ebx
40001a0b:	5e                   	pop    %esi
40001a0c:	5f                   	pop    %edi
40001a0d:	5d                   	pop    %ebp
    printf("touch failed. No Path. \n");
40001a0e:	e9 4d ea ff ff       	jmp    40000460 <printf>
40001a13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
	return errno ? -1 : fd;
40001a18:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
40001a1d:	e9 70 ff ff ff       	jmp    40001992 <shell_touch+0x52>
40001a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001a28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40001a2f:	00 

40001a30 <shell_cd>:
int shell_cd(int argc, char **argv) {
40001a30:	55                   	push   %ebp
40001a31:	89 e5                	mov    %esp,%ebp
40001a33:	53                   	push   %ebx
40001a34:	81 ec 04 04 00 00    	sub    $0x404,%esp
  if (argc == 1) {
40001a3a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
40001a3e:	74 30                	je     40001a70 <shell_cd+0x40>
    strcpy(path, argv[1]);
40001a40:	8b 45 0c             	mov    0xc(%ebp),%eax
40001a43:	83 ec 08             	sub    $0x8,%esp
40001a46:	8d 9d f8 fb ff ff    	lea    -0x408(%ebp),%ebx
40001a4c:	ff 70 04             	push   0x4(%eax)
40001a4f:	53                   	push   %ebx
40001a50:	e8 fb f1 ff ff       	call   40000c50 <strcpy>
  unsigned int len = strlen(path);
40001a55:	89 1c 24             	mov    %ebx,(%esp)
40001a58:	e8 a3 f1 ff ff       	call   40000c00 <strlen>
40001a5d:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001a5f:	b8 0b 00 00 00       	mov    $0xb,%eax
40001a64:	cd 30                	int    $0x30
}
40001a66:	31 c0                	xor    %eax,%eax
40001a68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40001a6b:	83 c4 10             	add    $0x10,%esp
40001a6e:	c9                   	leave
40001a6f:	c3                   	ret
  unsigned int len = strlen(path);
40001a70:	83 ec 0c             	sub    $0xc,%esp
40001a73:	8d 9d f8 fb ff ff    	lea    -0x408(%ebp),%ebx
    path[0] = '\0';
40001a79:	c6 85 f8 fb ff ff 00 	movb   $0x0,-0x408(%ebp)
40001a80:	53                   	push   %ebx
40001a81:	eb d5                	jmp    40001a58 <shell_cd+0x28>
40001a83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40001a88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40001a8f:	00 

40001a90 <cp_file.part.0>:
int cp_file(char *dest_filename, char *src_filename) {
40001a90:	55                   	push   %ebp
40001a91:	89 e5                	mov    %esp,%ebp
40001a93:	57                   	push   %edi
40001a94:	56                   	push   %esi
40001a95:	89 d6                	mov    %edx,%esi
40001a97:	53                   	push   %ebx
	asm volatile("int %2"
40001a98:	89 f3                	mov    %esi,%ebx
40001a9a:	81 ec 18 04 00 00    	sub    $0x418,%esp
40001aa0:	89 85 f4 fb ff ff    	mov    %eax,-0x40c(%ebp)
        unsigned int len = strlen(path);
40001aa6:	52                   	push   %edx
40001aa7:	e8 54 f1 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40001aac:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40001aae:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001ab0:	b8 05 00 00 00       	mov    $0x5,%eax
40001ab5:	cd 30                	int    $0x30
	return errno ? -1 : fd;
40001ab7:	83 c4 10             	add    $0x10,%esp
40001aba:	85 c0                	test   %eax,%eax
40001abc:	75 72                	jne    40001b30 <cp_file.part.0+0xa0>
40001abe:	89 de                	mov    %ebx,%esi
	asm volatile("int %2"
40001ac0:	8d bd 00 fc ff ff    	lea    -0x400(%ebp),%edi
40001ac6:	b8 07 00 00 00       	mov    $0x7,%eax
40001acb:	ba e8 03 00 00       	mov    $0x3e8,%edx
40001ad0:	89 f3                	mov    %esi,%ebx
40001ad2:	89 f9                	mov    %edi,%ecx
40001ad4:	cd 30                	int    $0x30
	asm volatile("int %2"
40001ad6:	b8 06 00 00 00       	mov    $0x6,%eax
40001adb:	89 f3                	mov    %esi,%ebx
40001add:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
40001adf:	8b 9d f4 fb ff ff    	mov    -0x40c(%ebp),%ebx
40001ae5:	83 ec 0c             	sub    $0xc,%esp
40001ae8:	53                   	push   %ebx
40001ae9:	e8 12 f1 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40001aee:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
40001af3:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001af5:	b8 05 00 00 00       	mov    $0x5,%eax
40001afa:	cd 30                	int    $0x30
40001afc:	89 de                	mov    %ebx,%esi
	return errno ? -1 : fd;
40001afe:	83 c4 10             	add    $0x10,%esp
40001b01:	85 c0                	test   %eax,%eax
40001b03:	75 3b                	jne    40001b40 <cp_file.part.0+0xb0>
  write(fd, buf, strlen(buf));
40001b05:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001b08:	89 f3                	mov    %esi,%ebx
40001b0a:	57                   	push   %edi
40001b0b:	e8 f0 f0 ff ff       	call   40000c00 <strlen>
40001b10:	89 f9                	mov    %edi,%ecx
40001b12:	89 c2                	mov    %eax,%edx
40001b14:	b8 08 00 00 00       	mov    $0x8,%eax
40001b19:	cd 30                	int    $0x30
	asm volatile("int %2"
40001b1b:	b8 06 00 00 00       	mov    $0x6,%eax
40001b20:	89 f3                	mov    %esi,%ebx
40001b22:	cd 30                	int    $0x30
40001b24:	83 c4 10             	add    $0x10,%esp
}
40001b27:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001b2a:	5b                   	pop    %ebx
40001b2b:	5e                   	pop    %esi
40001b2c:	5f                   	pop    %edi
40001b2d:	5d                   	pop    %ebp
40001b2e:	c3                   	ret
40001b2f:	90                   	nop
	return errno ? -1 : fd;
40001b30:	be ff ff ff ff       	mov    $0xffffffff,%esi
40001b35:	eb 89                	jmp    40001ac0 <cp_file.part.0+0x30>
40001b37:	90                   	nop
40001b38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40001b3f:	00 
40001b40:	be ff ff ff ff       	mov    $0xffffffff,%esi
40001b45:	eb be                	jmp    40001b05 <cp_file.part.0+0x75>
40001b47:	90                   	nop
40001b48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40001b4f:	00 

40001b50 <run_pipeline.isra.0>:
static int run_pipeline(char *buf) {
40001b50:	55                   	push   %ebp
40001b51:	89 e5                	mov    %esp,%ebp
40001b53:	57                   	push   %edi
40001b54:	56                   	push   %esi
40001b55:	89 c6                	mov    %eax,%esi
40001b57:	53                   	push   %ebx
40001b58:	81 ec bc 08 00 00    	sub    $0x8bc,%esp
  int n = 0;
40001b5e:	c7 85 50 f7 ff ff 00 	movl   $0x0,-0x8b0(%ebp)
40001b65:	00 00 00 
40001b68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40001b6f:	00 
    while (*seg && strchr(WHITESPACE, *seg))
40001b70:	0f be 06             	movsbl (%esi),%eax
40001b73:	84 c0                	test   %al,%al
40001b75:	0f 85 d4 01 00 00    	jne    40001d4f <run_pipeline.isra.0+0x1ff>
  if (nstages == 0)
40001b7b:	8b 9d 50 f7 ff ff    	mov    -0x8b0(%ebp),%ebx
40001b81:	85 db                	test   %ebx,%ebx
40001b83:	0f 84 61 03 00 00    	je     40001eea <run_pipeline.isra.0+0x39a>
40001b89:	8d 85 a8 fb ff ff    	lea    -0x458(%ebp),%eax
40001b8f:	89 85 48 f7 ff ff    	mov    %eax,-0x8b8(%ebp)
  int argc = 0;
40001b95:	8b b5 48 f7 ff ff    	mov    -0x8b8(%ebp),%esi
40001b9b:	8b bd 50 f7 ff ff    	mov    -0x8b0(%ebp),%edi
  for (i = 0; i < nstages; i++) {
40001ba1:	31 db                	xor    %ebx,%ebx
    pids[i] = -1;
40001ba3:	c7 84 9d 68 f7 ff ff 	movl   $0xffffffff,-0x898(%ebp,%ebx,4)
40001baa:	ff ff ff ff 
    if (!is_process_cmd(stages[i].argv[0])) {
40001bae:	8b 06                	mov    (%esi),%eax
40001bb0:	e8 bb f7 ff ff       	call   40001370 <is_process_cmd>
40001bb5:	85 c0                	test   %eax,%eax
40001bb7:	0f 84 5f 05 00 00    	je     4000211c <run_pipeline.isra.0+0x5cc>
  for (i = 0; i < nstages; i++) {
40001bbd:	83 c3 01             	add    $0x1,%ebx
40001bc0:	83 c6 44             	add    $0x44,%esi
40001bc3:	39 fb                	cmp    %edi,%ebx
40001bc5:	75 dc                	jne    40001ba3 <run_pipeline.isra.0+0x53>
    if (i < nstages - 1) {
40001bc7:	8b 85 50 f7 ff ff    	mov    -0x8b0(%ebp),%eax
	asm volatile("int %2"
40001bcd:	8b b5 48 f7 ff ff    	mov    -0x8b8(%ebp),%esi
  for (i = 0; i < nstages; i++) {
40001bd3:	31 ff                	xor    %edi,%edi
  in_fd = -1;
40001bd5:	c7 85 54 f7 ff ff ff 	movl   $0xffffffff,-0x8ac(%ebp)
40001bdc:	ff ff ff 
    if (i < nstages - 1) {
40001bdf:	83 e8 01             	sub    $0x1,%eax
40001be2:	89 85 4c f7 ff ff    	mov    %eax,-0x8b4(%ebp)
40001be8:	e9 0b 01 00 00       	jmp    40001cf8 <run_pipeline.isra.0+0x1a8>
  if (strcmp(name, "CAT") == 0 || strcmp(name, "biral") == 0 ||
40001bed:	83 ec 08             	sub    $0x8,%esp
40001bf0:	68 2d 35 00 40       	push   $0x4000352d
40001bf5:	53                   	push   %ebx
40001bf6:	e8 15 f1 ff ff       	call   40000d10 <strcmp>
40001bfb:	83 c4 10             	add    $0x10,%esp
40001bfe:	85 c0                	test   %eax,%eax
40001c00:	0f 84 3a 01 00 00    	je     40001d40 <run_pipeline.isra.0+0x1f0>
      strcmp(name, "BIRAL") == 0)
40001c06:	83 ec 08             	sub    $0x8,%esp
40001c09:	68 33 35 00 40       	push   $0x40003533
40001c0e:	53                   	push   %ebx
40001c0f:	e8 fc f0 ff ff       	call   40000d10 <strcmp>
  if (strcmp(name, "CAT") == 0 || strcmp(name, "biral") == 0 ||
40001c14:	83 c4 10             	add    $0x10,%esp
40001c17:	85 c0                	test   %eax,%eax
40001c19:	0f 84 21 01 00 00    	je     40001d40 <run_pipeline.isra.0+0x1f0>
  if (strcmp(name, "ROT13") == 0)
40001c1f:	83 ec 08             	sub    $0x8,%esp
40001c22:	68 27 35 00 40       	push   $0x40003527
40001c27:	53                   	push   %ebx
40001c28:	e8 e3 f0 ff ff       	call   40000d10 <strcmp>
40001c2d:	83 c4 10             	add    $0x10,%esp
40001c30:	85 c0                	test   %eax,%eax
40001c32:	0f 84 fc 04 00 00    	je     40002134 <run_pipeline.isra.0+0x5e4>
  if (strcmp(name, "LS") == 0)
40001c38:	83 ec 08             	sub    $0x8,%esp
40001c3b:	68 24 35 00 40       	push   $0x40003524
40001c40:	53                   	push   %ebx
40001c41:	e8 ca f0 ff ff       	call   40000d10 <strcmp>
40001c46:	83 c4 10             	add    $0x10,%esp
40001c49:	85 c0                	test   %eax,%eax
40001c4b:	0f 85 90 06 00 00    	jne    400022e1 <run_pipeline.isra.0+0x791>
    return 9;
40001c51:	c7 85 48 f7 ff ff 09 	movl   $0x9,-0x8b8(%ebp)
40001c58:	00 00 00 
  if (strcmp(stage->argv[0], "LS") == 0) {
40001c5b:	83 ec 08             	sub    $0x8,%esp
40001c5e:	68 24 35 00 40       	push   $0x40003524
40001c63:	53                   	push   %ebx
40001c64:	e8 a7 f0 ff ff       	call   40000d10 <strcmp>
40001c69:	83 c4 10             	add    $0x10,%esp
40001c6c:	85 c0                	test   %eax,%eax
40001c6e:	0f 85 7e 02 00 00    	jne    40001ef2 <run_pipeline.isra.0+0x3a2>
    if (stage->argc > 2) {
40001c74:	83 7e 40 02          	cmpl   $0x2,0x40(%esi)
40001c78:	0f 8f dc 05 00 00    	jg     4000225a <run_pipeline.isra.0+0x70a>
    if (stage->argc == 2) {
40001c7e:	0f 84 e8 02 00 00    	je     40001f6c <run_pipeline.isra.0+0x41c>
    pid = spawn_with_fds(elf_id, 200, stdin_fd, stdout_fd);
40001c84:	ff b5 44 f7 ff ff    	push   -0x8bc(%ebp)
40001c8a:	ff b5 54 f7 ff ff    	push   -0x8ac(%ebp)
40001c90:	68 c8 00 00 00       	push   $0xc8
40001c95:	ff b5 48 f7 ff ff    	push   -0x8b8(%ebp)
40001c9b:	e8 80 ee ff ff       	call   40000b20 <spawn_with_fds>
    if (pid < 0) {
40001ca0:	83 c4 10             	add    $0x10,%esp
    pid = spawn_with_fds(elf_id, 200, stdin_fd, stdout_fd);
40001ca3:	89 c2                	mov    %eax,%edx
    if (pid < 0) {
40001ca5:	85 c0                	test   %eax,%eax
40001ca7:	0f 88 98 05 00 00    	js     40002245 <run_pipeline.isra.0+0x6f5>
    if (in_fd >= 0)
40001cad:	8b 9d 54 f7 ff ff    	mov    -0x8ac(%ebp),%ebx
    pids[i] = launch_process_stage(&stages[i], in_fd, out_fd);
40001cb3:	89 94 bd 68 f7 ff ff 	mov    %edx,-0x898(%ebp,%edi,4)
    if (in_fd >= 0)
40001cba:	85 db                	test   %ebx,%ebx
40001cbc:	78 07                	js     40001cc5 <run_pipeline.isra.0+0x175>
	asm volatile("int %2"
40001cbe:	b8 06 00 00 00       	mov    $0x6,%eax
40001cc3:	cd 30                	int    $0x30
    if (i < nstages - 1) {
40001cc5:	3b bd 4c f7 ff ff    	cmp    -0x8b4(%ebp),%edi
40001ccb:	7d 19                	jge    40001ce6 <run_pipeline.isra.0+0x196>
40001ccd:	b8 06 00 00 00       	mov    $0x6,%eax
40001cd2:	8b 9d 64 f7 ff ff    	mov    -0x89c(%ebp),%ebx
40001cd8:	cd 30                	int    $0x30
      in_fd = pipefd[0];
40001cda:	8b 85 60 f7 ff ff    	mov    -0x8a0(%ebp),%eax
40001ce0:	89 85 54 f7 ff ff    	mov    %eax,-0x8ac(%ebp)
  for (i = 0; i < nstages; i++) {
40001ce6:	83 c7 01             	add    $0x1,%edi
40001ce9:	83 c6 44             	add    $0x44,%esi
40001cec:	3b bd 50 f7 ff ff    	cmp    -0x8b0(%ebp),%edi
40001cf2:	0f 84 63 04 00 00    	je     4000215b <run_pipeline.isra.0+0x60b>
    if (i < nstages - 1) {
40001cf8:	3b bd 4c f7 ff ff    	cmp    -0x8b4(%ebp),%edi
40001cfe:	0f 8d 59 02 00 00    	jge    40001f5d <run_pipeline.isra.0+0x40d>
	asm volatile("int %2"
40001d04:	8d 9d 60 f7 ff ff    	lea    -0x8a0(%ebp),%ebx
40001d0a:	b8 09 00 00 00       	mov    $0x9,%eax
40001d0f:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001d11:	85 c0                	test   %eax,%eax
40001d13:	0f 85 7e 04 00 00    	jne    40002197 <run_pipeline.isra.0+0x647>
      out_fd = pipefd[1];
40001d19:	8b 85 64 f7 ff ff    	mov    -0x89c(%ebp),%eax
40001d1f:	89 85 44 f7 ff ff    	mov    %eax,-0x8bc(%ebp)
  elf_id = elf_id_for_process(stage->argv[0]);
40001d25:	8b 1e                	mov    (%esi),%ebx
  if (strcmp(name, "CAT") == 0 || strcmp(name, "biral") == 0 ||
40001d27:	83 ec 08             	sub    $0x8,%esp
40001d2a:	68 20 35 00 40       	push   $0x40003520
40001d2f:	53                   	push   %ebx
40001d30:	e8 db ef ff ff       	call   40000d10 <strcmp>
40001d35:	83 c4 10             	add    $0x10,%esp
40001d38:	85 c0                	test   %eax,%eax
40001d3a:	0f 85 ad fe ff ff    	jne    40001bed <run_pipeline.isra.0+0x9d>
    return 6;
40001d40:	c7 85 48 f7 ff ff 06 	movl   $0x6,-0x8b8(%ebp)
40001d47:	00 00 00 
40001d4a:	e9 0c ff ff ff       	jmp    40001c5b <run_pipeline.isra.0+0x10b>
    while (*seg && strchr(WHITESPACE, *seg))
40001d4f:	83 ec 08             	sub    $0x8,%esp
40001d52:	50                   	push   %eax
40001d53:	68 56 36 00 40       	push   $0x40003656
40001d58:	e8 73 f0 ff ff       	call   40000dd0 <strchr>
40001d5d:	83 c4 10             	add    $0x10,%esp
40001d60:	85 c0                	test   %eax,%eax
40001d62:	74 08                	je     40001d6c <run_pipeline.isra.0+0x21c>
      seg++;
40001d64:	83 c6 01             	add    $0x1,%esi
40001d67:	e9 04 fe ff ff       	jmp    40001b70 <run_pipeline.isra.0+0x20>
    if (*seg == 0)
40001d6c:	0f be 06             	movsbl (%esi),%eax
40001d6f:	84 c0                	test   %al,%al
40001d71:	0f 84 04 fe ff ff    	je     40001b7b <run_pipeline.isra.0+0x2b>
    if (n == MAXARGS) {
40001d77:	83 bd 50 f7 ff ff 10 	cmpl   $0x10,-0x8b0(%ebp)
40001d7e:	0f 84 bf 03 00 00    	je     40002143 <run_pipeline.isra.0+0x5f3>
      char *end = seg;
40001d84:	89 f7                	mov    %esi,%edi
      while (*end && *end != '|')
40001d86:	3c 7c                	cmp    $0x7c,%al
40001d88:	74 25                	je     40001daf <run_pipeline.isra.0+0x25f>
40001d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001d90:	0f b6 57 01          	movzbl 0x1(%edi),%edx
        end++;
40001d94:	83 c7 01             	add    $0x1,%edi
      while (*end && *end != '|')
40001d97:	84 d2                	test   %dl,%dl
40001d99:	74 05                	je     40001da0 <run_pipeline.isra.0+0x250>
40001d9b:	80 fa 7c             	cmp    $0x7c,%dl
40001d9e:	75 f0                	jne    40001d90 <run_pipeline.isra.0+0x240>
      int found_pipe = 0;
40001da0:	c7 85 4c f7 ff ff 00 	movl   $0x0,-0x8b4(%ebp)
40001da7:	00 00 00 
      if (*end == '|') {
40001daa:	80 fa 7c             	cmp    $0x7c,%dl
40001dad:	75 10                	jne    40001dbf <run_pipeline.isra.0+0x26f>
        found_pipe = 1;
40001daf:	c7 85 4c f7 ff ff 01 	movl   $0x1,-0x8b4(%ebp)
40001db6:	00 00 00 
        *end = 0;
40001db9:	c6 07 00             	movb   $0x0,(%edi)
    while (*cmd && strchr(WHITESPACE, *cmd))
40001dbc:	0f be 06             	movsbl (%esi),%eax
      if (parse_stage(seg, &stages[n]) < 0)
40001dbf:	8d 9d a8 fb ff ff    	lea    -0x458(%ebp),%ebx
  int argc = 0;
40001dc5:	31 c9                	xor    %ecx,%ecx
      if (parse_stage(seg, &stages[n]) < 0)
40001dc7:	89 9d 48 f7 ff ff    	mov    %ebx,-0x8b8(%ebp)
40001dcd:	6b 9d 50 f7 ff ff 44 	imul   $0x44,-0x8b0(%ebp),%ebx
  int argc = 0;
40001dd4:	8d 94 1d a8 fb ff ff 	lea    -0x458(%ebp,%ebx,1),%edx
40001ddb:	89 fb                	mov    %edi,%ebx
40001ddd:	89 d7                	mov    %edx,%edi
40001ddf:	90                   	nop
    while (*cmd && strchr(WHITESPACE, *cmd))
40001de0:	84 c0                	test   %al,%al
40001de2:	75 3c                	jne    40001e20 <run_pipeline.isra.0+0x2d0>
40001de4:	89 f8                	mov    %edi,%eax
40001de6:	89 df                	mov    %ebx,%edi
40001de8:	89 c3                	mov    %eax,%ebx
  stage->argv[argc] = 0;
40001dea:	c7 04 8b 00 00 00 00 	movl   $0x0,(%ebx,%ecx,4)
  stage->argc = argc;
40001df1:	89 4b 40             	mov    %ecx,0x40(%ebx)
      if (stages[n].argc == 0) {
40001df4:	85 c9                	test   %ecx,%ecx
40001df6:	0f 84 be 00 00 00    	je     40001eba <run_pipeline.isra.0+0x36a>
      if (!found_pipe)
40001dfc:	8b 8d 4c f7 ff ff    	mov    -0x8b4(%ebp),%ecx
      n++;
40001e02:	83 85 50 f7 ff ff 01 	addl   $0x1,-0x8b0(%ebp)
      if (!found_pipe)
40001e09:	85 c9                	test   %ecx,%ecx
40001e0b:	0f 84 84 fd ff ff    	je     40001b95 <run_pipeline.isra.0+0x45>
      seg = end + 1;
40001e11:	8d 77 01             	lea    0x1(%edi),%esi
    while (*seg && strchr(WHITESPACE, *seg))
40001e14:	e9 57 fd ff ff       	jmp    40001b70 <run_pipeline.isra.0+0x20>
40001e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while (*cmd && strchr(WHITESPACE, *cmd))
40001e20:	83 ec 08             	sub    $0x8,%esp
40001e23:	89 8d 54 f7 ff ff    	mov    %ecx,-0x8ac(%ebp)
40001e29:	50                   	push   %eax
40001e2a:	68 56 36 00 40       	push   $0x40003656
40001e2f:	e8 9c ef ff ff       	call   40000dd0 <strchr>
40001e34:	83 c4 10             	add    $0x10,%esp
40001e37:	8b 8d 54 f7 ff ff    	mov    -0x8ac(%ebp),%ecx
40001e3d:	85 c0                	test   %eax,%eax
40001e3f:	74 0f                	je     40001e50 <run_pipeline.isra.0+0x300>
      *cmd++ = 0;
40001e41:	c6 06 00             	movb   $0x0,(%esi)
    while (*cmd && strchr(WHITESPACE, *cmd))
40001e44:	0f be 46 01          	movsbl 0x1(%esi),%eax
      *cmd++ = 0;
40001e48:	83 c6 01             	add    $0x1,%esi
40001e4b:	eb 93                	jmp    40001de0 <run_pipeline.isra.0+0x290>
40001e4d:	8d 76 00             	lea    0x0(%esi),%esi
    if (*cmd == 0)
40001e50:	0f be 06             	movsbl (%esi),%eax
40001e53:	84 c0                	test   %al,%al
40001e55:	74 8d                	je     40001de4 <run_pipeline.isra.0+0x294>
    if (argc == MAXARGS - 1) {
40001e57:	83 f9 0f             	cmp    $0xf,%ecx
40001e5a:	74 7c                	je     40001ed8 <run_pipeline.isra.0+0x388>
    stage->argv[argc++] = cmd;
40001e5c:	89 34 8f             	mov    %esi,(%edi,%ecx,4)
40001e5f:	8d 51 01             	lea    0x1(%ecx),%edx
    while (*cmd && !strchr(WHITESPACE, *cmd))
40001e62:	eb 0f                	jmp    40001e73 <run_pipeline.isra.0+0x323>
40001e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40001e68:	0f be 46 01          	movsbl 0x1(%esi),%eax
      cmd++;
40001e6c:	83 c6 01             	add    $0x1,%esi
    while (*cmd && !strchr(WHITESPACE, *cmd))
40001e6f:	84 c0                	test   %al,%al
40001e71:	74 2d                	je     40001ea0 <run_pipeline.isra.0+0x350>
40001e73:	83 ec 08             	sub    $0x8,%esp
40001e76:	89 95 54 f7 ff ff    	mov    %edx,-0x8ac(%ebp)
40001e7c:	50                   	push   %eax
40001e7d:	68 56 36 00 40       	push   $0x40003656
40001e82:	e8 49 ef ff ff       	call   40000dd0 <strchr>
40001e87:	83 c4 10             	add    $0x10,%esp
40001e8a:	8b 95 54 f7 ff ff    	mov    -0x8ac(%ebp),%edx
40001e90:	85 c0                	test   %eax,%eax
40001e92:	74 d4                	je     40001e68 <run_pipeline.isra.0+0x318>
    while (*cmd && strchr(WHITESPACE, *cmd))
40001e94:	0f be 06             	movsbl (%esi),%eax
    stage->argv[argc++] = cmd;
40001e97:	89 d1                	mov    %edx,%ecx
40001e99:	e9 42 ff ff ff       	jmp    40001de0 <run_pipeline.isra.0+0x290>
40001e9e:	66 90                	xchg   %ax,%ax
40001ea0:	89 f8                	mov    %edi,%eax
40001ea2:	89 d1                	mov    %edx,%ecx
40001ea4:	89 df                	mov    %ebx,%edi
40001ea6:	89 c3                	mov    %eax,%ebx
  stage->argv[argc] = 0;
40001ea8:	c7 04 8b 00 00 00 00 	movl   $0x0,(%ebx,%ecx,4)
  stage->argc = argc;
40001eaf:	89 4b 40             	mov    %ecx,0x40(%ebx)
      if (stages[n].argc == 0) {
40001eb2:	85 c9                	test   %ecx,%ecx
40001eb4:	0f 85 42 ff ff ff    	jne    40001dfc <run_pipeline.isra.0+0x2ac>
        printf("Invalid null command in pipeline\n");
40001eba:	83 ec 0c             	sub    $0xc,%esp
40001ebd:	68 e0 3c 00 40       	push   $0x40003ce0
40001ec2:	e8 99 e5 ff ff       	call   40000460 <printf>
40001ec7:	83 c4 10             	add    $0x10,%esp
}
40001eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001ecd:	5b                   	pop    %ebx
40001ece:	5e                   	pop    %esi
40001ecf:	5f                   	pop    %edi
40001ed0:	5d                   	pop    %ebp
40001ed1:	c3                   	ret
40001ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf("Too many arguments (max %d)\n", MAXARGS);
40001ed8:	83 ec 08             	sub    $0x8,%esp
40001edb:	6a 10                	push   $0x10
40001edd:	68 75 36 00 40       	push   $0x40003675
40001ee2:	e8 79 e5 ff ff       	call   40000460 <printf>
40001ee7:	83 c4 10             	add    $0x10,%esp
}
40001eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001eed:	5b                   	pop    %ebx
40001eee:	5e                   	pop    %esi
40001eef:	5f                   	pop    %edi
40001ef0:	5d                   	pop    %ebp
40001ef1:	c3                   	ret
  if (strcmp(stage->argv[0], "CAT") == 0 ||
40001ef2:	83 ec 08             	sub    $0x8,%esp
40001ef5:	68 20 35 00 40       	push   $0x40003520
40001efa:	53                   	push   %ebx
40001efb:	e8 10 ee ff ff       	call   40000d10 <strcmp>
40001f00:	83 c4 10             	add    $0x10,%esp
40001f03:	85 c0                	test   %eax,%eax
40001f05:	0f 85 35 01 00 00    	jne    40002040 <run_pipeline.isra.0+0x4f0>
    if (stage->argc > 2) {
40001f0b:	83 7e 40 02          	cmpl   $0x2,0x40(%esi)
40001f0f:	0f 8f 1b 03 00 00    	jg     40002230 <run_pipeline.isra.0+0x6e0>
    input_fd = stdin_fd;
40001f15:	8b 9d 54 f7 ff ff    	mov    -0x8ac(%ebp),%ebx
    if (stage->argc == 2) {
40001f1b:	0f 84 d1 00 00 00    	je     40001ff2 <run_pipeline.isra.0+0x4a2>
    pid = spawn_with_fds(elf_id, 200, input_fd, stdout_fd);
40001f21:	ff b5 44 f7 ff ff    	push   -0x8bc(%ebp)
40001f27:	53                   	push   %ebx
40001f28:	68 c8 00 00 00       	push   $0xc8
40001f2d:	ff b5 48 f7 ff ff    	push   -0x8b8(%ebp)
40001f33:	e8 e8 eb ff ff       	call   40000b20 <spawn_with_fds>
    if (pid < 0) {
40001f38:	83 c4 10             	add    $0x10,%esp
    pid = spawn_with_fds(elf_id, 200, input_fd, stdout_fd);
40001f3b:	89 c2                	mov    %eax,%edx
      if (stage->argc == 2)
40001f3d:	8b 46 40             	mov    0x40(%esi),%eax
    if (pid < 0) {
40001f40:	85 d2                	test   %edx,%edx
40001f42:	0f 88 27 03 00 00    	js     4000226f <run_pipeline.isra.0+0x71f>
    if (stage->argc == 2)
40001f48:	83 f8 02             	cmp    $0x2,%eax
40001f4b:	0f 85 5c fd ff ff    	jne    40001cad <run_pipeline.isra.0+0x15d>
	asm volatile("int %2"
40001f51:	b8 06 00 00 00       	mov    $0x6,%eax
40001f56:	cd 30                	int    $0x30
    if (pids[i] < 0) {
40001f58:	e9 50 fd ff ff       	jmp    40001cad <run_pipeline.isra.0+0x15d>
      out_fd = -1;
40001f5d:	c7 85 44 f7 ff ff ff 	movl   $0xffffffff,-0x8bc(%ebp)
40001f64:	ff ff ff 
40001f67:	e9 b9 fd ff ff       	jmp    40001d25 <run_pipeline.isra.0+0x1d5>
	asm volatile ("int %2"
40001f6c:	b8 15 00 00 00       	mov    $0x15,%eax
40001f71:	8d 9d a8 f7 ff ff    	lea    -0x858(%ebp),%ebx
40001f77:	cd 30                	int    $0x30
      if (sys_chdir(stage->argv[1]) < 0) {
40001f79:	8b 5e 04             	mov    0x4(%esi),%ebx
  unsigned int len = strlen(path);
40001f7c:	83 ec 0c             	sub    $0xc,%esp
40001f7f:	53                   	push   %ebx
40001f80:	e8 7b ec ff ff       	call   40000c00 <strlen>
40001f85:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001f87:	b8 0b 00 00 00       	mov    $0xb,%eax
40001f8c:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001f8e:	83 c4 10             	add    $0x10,%esp
40001f91:	85 c0                	test   %eax,%eax
40001f93:	0f 85 f7 02 00 00    	jne    40002290 <run_pipeline.isra.0+0x740>
      pid = spawn_with_fds(elf_id, 200, stdin_fd, stdout_fd);
40001f99:	ff b5 44 f7 ff ff    	push   -0x8bc(%ebp)
40001f9f:	ff b5 54 f7 ff ff    	push   -0x8ac(%ebp)
40001fa5:	68 c8 00 00 00       	push   $0xc8
40001faa:	ff b5 48 f7 ff ff    	push   -0x8b8(%ebp)
40001fb0:	e8 6b eb ff ff       	call   40000b20 <spawn_with_fds>
      if (pid < 0) {
40001fb5:	83 c4 10             	add    $0x10,%esp
40001fb8:	85 c0                	test   %eax,%eax
40001fba:	0f 88 ef 02 00 00    	js     400022af <run_pipeline.isra.0+0x75f>
40001fc0:	89 85 48 f7 ff ff    	mov    %eax,-0x8b8(%ebp)
  unsigned int len = strlen(path);
40001fc6:	83 ec 0c             	sub    $0xc,%esp
40001fc9:	8d 85 a8 f7 ff ff    	lea    -0x858(%ebp),%eax
	asm volatile("int %2"
40001fcf:	8d 9d a8 f7 ff ff    	lea    -0x858(%ebp),%ebx
  unsigned int len = strlen(path);
40001fd5:	50                   	push   %eax
40001fd6:	e8 25 ec ff ff       	call   40000c00 <strlen>
40001fdb:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001fdd:	b8 0b 00 00 00       	mov    $0xb,%eax
40001fe2:	cd 30                	int    $0x30
    if (pids[i] < 0) {
40001fe4:	8b 95 48 f7 ff ff    	mov    -0x8b8(%ebp),%edx
40001fea:	83 c4 10             	add    $0x10,%esp
40001fed:	e9 bb fc ff ff       	jmp    40001cad <run_pipeline.isra.0+0x15d>
      input_fd = open(stage->argv[1], O_RDONLY);
40001ff2:	8b 5e 04             	mov    0x4(%esi),%ebx
        unsigned int len = strlen(path);
40001ff5:	83 ec 0c             	sub    $0xc,%esp
40001ff8:	53                   	push   %ebx
40001ff9:	e8 02 ec ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40001ffe:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40002000:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002002:	b8 05 00 00 00       	mov    $0x5,%eax
40002007:	cd 30                	int    $0x30
	return errno ? -1 : fd;
40002009:	83 c4 10             	add    $0x10,%esp
      if (input_fd < 0) {
4000200c:	85 c0                	test   %eax,%eax
4000200e:	75 08                	jne    40002018 <run_pipeline.isra.0+0x4c8>
40002010:	85 db                	test   %ebx,%ebx
40002012:	0f 89 09 ff ff ff    	jns    40001f21 <run_pipeline.isra.0+0x3d1>
        printf("CAT: cannot open %s\n", stage->argv[1]);
40002018:	6b c7 44             	imul   $0x44,%edi,%eax
4000201b:	83 ec 08             	sub    $0x8,%esp
4000201e:	ff b4 05 ac fb ff ff 	push   -0x454(%ebp,%eax,1)
40002025:	68 fe 36 00 40       	push   $0x400036fe
4000202a:	e8 31 e4 ff ff       	call   40000460 <printf>
4000202f:	83 c4 10             	add    $0x10,%esp
40002032:	e9 a9 00 00 00       	jmp    400020e0 <run_pipeline.isra.0+0x590>
40002037:	90                   	nop
40002038:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000203f:	00 
      strcmp(stage->argv[0], "biral") == 0 ||
40002040:	83 ec 08             	sub    $0x8,%esp
40002043:	68 2d 35 00 40       	push   $0x4000352d
40002048:	53                   	push   %ebx
40002049:	e8 c2 ec ff ff       	call   40000d10 <strcmp>
  if (strcmp(stage->argv[0], "CAT") == 0 ||
4000204e:	83 c4 10             	add    $0x10,%esp
40002051:	85 c0                	test   %eax,%eax
40002053:	0f 84 b2 fe ff ff    	je     40001f0b <run_pipeline.isra.0+0x3bb>
      strcmp(stage->argv[0], "BIRAL") == 0) {
40002059:	83 ec 08             	sub    $0x8,%esp
4000205c:	68 33 35 00 40       	push   $0x40003533
40002061:	53                   	push   %ebx
40002062:	e8 a9 ec ff ff       	call   40000d10 <strcmp>
      strcmp(stage->argv[0], "biral") == 0 ||
40002067:	83 c4 10             	add    $0x10,%esp
4000206a:	85 c0                	test   %eax,%eax
4000206c:	0f 84 99 fe ff ff    	je     40001f0b <run_pipeline.isra.0+0x3bb>
  if (strcmp(stage->argv[0], "ROT13") == 0) {
40002072:	83 ec 08             	sub    $0x8,%esp
40002075:	68 27 35 00 40       	push   $0x40003527
4000207a:	53                   	push   %ebx
4000207b:	e8 90 ec ff ff       	call   40000d10 <strcmp>
40002080:	83 c4 10             	add    $0x10,%esp
40002083:	85 c0                	test   %eax,%eax
40002085:	75 59                	jne    400020e0 <run_pipeline.isra.0+0x590>
    if (stage->argc > 2) {
40002087:	83 7e 40 02          	cmpl   $0x2,0x40(%esi)
4000208b:	0f 8f 84 01 00 00    	jg     40002215 <run_pipeline.isra.0+0x6c5>
    input_fd = stdin_fd;
40002091:	8b 9d 54 f7 ff ff    	mov    -0x8ac(%ebp),%ebx
    if (stage->argc == 2) {
40002097:	0f 84 2a 01 00 00    	je     400021c7 <run_pipeline.isra.0+0x677>
    pid = spawn_with_fds(elf_id, 200, input_fd, stdout_fd);
4000209d:	ff b5 44 f7 ff ff    	push   -0x8bc(%ebp)
400020a3:	53                   	push   %ebx
400020a4:	68 c8 00 00 00       	push   $0xc8
400020a9:	ff b5 48 f7 ff ff    	push   -0x8b8(%ebp)
400020af:	e8 6c ea ff ff       	call   40000b20 <spawn_with_fds>
    if (pid < 0) {
400020b4:	83 c4 10             	add    $0x10,%esp
    pid = spawn_with_fds(elf_id, 200, input_fd, stdout_fd);
400020b7:	89 c2                	mov    %eax,%edx
      if (stage->argc == 2)
400020b9:	8b 46 40             	mov    0x40(%esi),%eax
    if (pid < 0) {
400020bc:	85 d2                	test   %edx,%edx
400020be:	0f 89 84 fe ff ff    	jns    40001f48 <run_pipeline.isra.0+0x3f8>
      if (stage->argc == 2)
400020c4:	83 f8 02             	cmp    $0x2,%eax
400020c7:	75 07                	jne    400020d0 <run_pipeline.isra.0+0x580>
	asm volatile("int %2"
400020c9:	b8 06 00 00 00       	mov    $0x6,%eax
400020ce:	cd 30                	int    $0x30
      printf("ROT13: spawn failed\n");
400020d0:	83 ec 0c             	sub    $0xc,%esp
400020d3:	68 3d 37 00 40       	push   $0x4000373d
400020d8:	e8 83 e3 ff ff       	call   40000460 <printf>
400020dd:	83 c4 10             	add    $0x10,%esp
      if (in_fd >= 0)
400020e0:	8b 9d 54 f7 ff ff    	mov    -0x8ac(%ebp),%ebx
400020e6:	85 db                	test   %ebx,%ebx
400020e8:	78 07                	js     400020f1 <run_pipeline.isra.0+0x5a1>
400020ea:	b8 06 00 00 00       	mov    $0x6,%eax
400020ef:	cd 30                	int    $0x30
      if (i < nstages - 1) {
400020f1:	3b bd 4c f7 ff ff    	cmp    -0x8b4(%ebp),%edi
400020f7:	0f 8d ed fd ff ff    	jge    40001eea <run_pipeline.isra.0+0x39a>
400020fd:	8b 9d 60 f7 ff ff    	mov    -0x8a0(%ebp),%ebx
40002103:	b8 06 00 00 00       	mov    $0x6,%eax
40002108:	cd 30                	int    $0x30
4000210a:	b8 06 00 00 00       	mov    $0x6,%eax
4000210f:	8b 9d 64 f7 ff ff    	mov    -0x89c(%ebp),%ebx
40002115:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002117:	e9 ce fd ff ff       	jmp    40001eea <run_pipeline.isra.0+0x39a>
      printf("Pipelines currently support only LS, CAT, and ROT13\n");
4000211c:	83 ec 0c             	sub    $0xc,%esp
4000211f:	68 04 3d 00 40       	push   $0x40003d04
40002124:	e8 37 e3 ff ff       	call   40000460 <printf>
      return 0;
40002129:	83 c4 10             	add    $0x10,%esp
}
4000212c:	8d 65 f4             	lea    -0xc(%ebp),%esp
4000212f:	5b                   	pop    %ebx
40002130:	5e                   	pop    %esi
40002131:	5f                   	pop    %edi
40002132:	5d                   	pop    %ebp
40002133:	c3                   	ret
    return 7;
40002134:	c7 85 48 f7 ff ff 07 	movl   $0x7,-0x8b8(%ebp)
4000213b:	00 00 00 
4000213e:	e9 18 fb ff ff       	jmp    40001c5b <run_pipeline.isra.0+0x10b>
      printf("Too many pipeline stages\n");
40002143:	83 ec 0c             	sub    $0xc,%esp
40002146:	68 5b 36 00 40       	push   $0x4000365b
4000214b:	e8 10 e3 ff ff       	call   40000460 <printf>
40002150:	83 c4 10             	add    $0x10,%esp
}
40002153:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002156:	5b                   	pop    %ebx
40002157:	5e                   	pop    %esi
40002158:	5f                   	pop    %edi
40002159:	5d                   	pop    %ebp
4000215a:	c3                   	ret
  if (in_fd >= 0)
4000215b:	8b 9d 54 f7 ff ff    	mov    -0x8ac(%ebp),%ebx
40002161:	85 db                	test   %ebx,%ebx
40002163:	78 07                	js     4000216c <run_pipeline.isra.0+0x61c>
	asm volatile("int %2"
40002165:	b8 06 00 00 00       	mov    $0x6,%eax
4000216a:	cd 30                	int    $0x30
  for (i = 0; i < nstages; i++) {
4000216c:	8b 85 50 f7 ff ff    	mov    -0x8b0(%ebp),%eax
40002172:	8d 95 68 f7 ff ff    	lea    -0x898(%ebp),%edx
40002178:	8d 0c 82             	lea    (%edx,%eax,4),%ecx
static gcc_inline void sys_exit(void) {
    asm volatile("int %0" : : "i" (T_SYSCALL), "a" (SYS_exit) : "cc", "memory");
}

static gcc_inline void sys_waitpid(int pid) {
    asm volatile("int %0" : : "i" (T_SYSCALL), "a" (SYS_waitpid), "b" (pid) : "cc", "memory");
4000217b:	b8 1f 00 00 00       	mov    $0x1f,%eax
    if (pids[i] >= 0) {
40002180:	8b 1a                	mov    (%edx),%ebx
40002182:	85 db                	test   %ebx,%ebx
40002184:	78 02                	js     40002188 <run_pipeline.isra.0+0x638>
40002186:	cd 30                	int    $0x30
  for (i = 0; i < nstages; i++) {
40002188:	83 c2 04             	add    $0x4,%edx
4000218b:	39 ca                	cmp    %ecx,%edx
4000218d:	75 f1                	jne    40002180 <run_pipeline.isra.0+0x630>
}
4000218f:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002192:	5b                   	pop    %ebx
40002193:	5e                   	pop    %esi
40002194:	5f                   	pop    %edi
40002195:	5d                   	pop    %ebp
40002196:	c3                   	ret
        printf("pipe: failed\n");
40002197:	83 ec 0c             	sub    $0xc,%esp
4000219a:	68 92 36 00 40       	push   $0x40003692
4000219f:	e8 bc e2 ff ff       	call   40000460 <printf>
        if (in_fd >= 0)
400021a4:	8b 95 54 f7 ff ff    	mov    -0x8ac(%ebp),%edx
400021aa:	83 c4 10             	add    $0x10,%esp
400021ad:	85 d2                	test   %edx,%edx
400021af:	0f 88 35 fd ff ff    	js     40001eea <run_pipeline.isra.0+0x39a>
	asm volatile("int %2"
400021b5:	8b 9d 54 f7 ff ff    	mov    -0x8ac(%ebp),%ebx
400021bb:	b8 06 00 00 00       	mov    $0x6,%eax
400021c0:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400021c2:	e9 23 fd ff ff       	jmp    40001eea <run_pipeline.isra.0+0x39a>
      input_fd = open(stage->argv[1], O_RDONLY);
400021c7:	8b 5e 04             	mov    0x4(%esi),%ebx
        unsigned int len = strlen(path);
400021ca:	83 ec 0c             	sub    $0xc,%esp
400021cd:	89 85 40 f7 ff ff    	mov    %eax,-0x8c0(%ebp)
400021d3:	53                   	push   %ebx
400021d4:	e8 27 ea ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
400021d9:	8b 8d 40 f7 ff ff    	mov    -0x8c0(%ebp),%ecx
        unsigned int len = strlen(path);
400021df:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
400021e1:	b8 05 00 00 00       	mov    $0x5,%eax
400021e6:	cd 30                	int    $0x30
	return errno ? -1 : fd;
400021e8:	83 c4 10             	add    $0x10,%esp
      if (input_fd < 0) {
400021eb:	85 c0                	test   %eax,%eax
400021ed:	75 08                	jne    400021f7 <run_pipeline.isra.0+0x6a7>
400021ef:	85 db                	test   %ebx,%ebx
400021f1:	0f 89 a6 fe ff ff    	jns    4000209d <run_pipeline.isra.0+0x54d>
        printf("ROT13: cannot open %s\n", stage->argv[1]);
400021f7:	50                   	push   %eax
400021f8:	50                   	push   %eax
400021f9:	6b c7 44             	imul   $0x44,%edi,%eax
400021fc:	ff b4 05 ac fb ff ff 	push   -0x454(%ebp,%eax,1)
40002203:	68 26 37 00 40       	push   $0x40003726
40002208:	e8 53 e2 ff ff       	call   40000460 <printf>
4000220d:	83 c4 10             	add    $0x10,%esp
40002210:	e9 cb fe ff ff       	jmp    400020e0 <run_pipeline.isra.0+0x590>
      printf("ROT13: only zero or one filename is supported in this module\n");
40002215:	83 ec 0c             	sub    $0xc,%esp
40002218:	68 78 3d 00 40       	push   $0x40003d78
4000221d:	e8 3e e2 ff ff       	call   40000460 <printf>
40002222:	83 c4 10             	add    $0x10,%esp
40002225:	e9 b6 fe ff ff       	jmp    400020e0 <run_pipeline.isra.0+0x590>
4000222a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf("CAT: only zero or one filename is supported in this module\n");
40002230:	83 ec 0c             	sub    $0xc,%esp
40002233:	68 3c 3d 00 40       	push   $0x40003d3c
40002238:	e8 23 e2 ff ff       	call   40000460 <printf>
4000223d:	83 c4 10             	add    $0x10,%esp
40002240:	e9 9b fe ff ff       	jmp    400020e0 <run_pipeline.isra.0+0x590>
      printf("LS: spawn failed\n");
40002245:	83 ec 0c             	sub    $0xc,%esp
40002248:	68 ec 36 00 40       	push   $0x400036ec
4000224d:	e8 0e e2 ff ff       	call   40000460 <printf>
40002252:	83 c4 10             	add    $0x10,%esp
40002255:	e9 86 fe ff ff       	jmp    400020e0 <run_pipeline.isra.0+0x590>
      printf("LS: too many arguments\n");
4000225a:	83 ec 0c             	sub    $0xc,%esp
4000225d:	68 be 36 00 40       	push   $0x400036be
40002262:	e8 f9 e1 ff ff       	call   40000460 <printf>
40002267:	83 c4 10             	add    $0x10,%esp
4000226a:	e9 71 fe ff ff       	jmp    400020e0 <run_pipeline.isra.0+0x590>
      if (stage->argc == 2)
4000226f:	83 f8 02             	cmp    $0x2,%eax
40002272:	75 07                	jne    4000227b <run_pipeline.isra.0+0x72b>
	asm volatile("int %2"
40002274:	b8 06 00 00 00       	mov    $0x6,%eax
40002279:	cd 30                	int    $0x30
      printf("CAT: spawn failed\n");
4000227b:	83 ec 0c             	sub    $0xc,%esp
4000227e:	68 13 37 00 40       	push   $0x40003713
40002283:	e8 d8 e1 ff ff       	call   40000460 <printf>
40002288:	83 c4 10             	add    $0x10,%esp
4000228b:	e9 50 fe ff ff       	jmp    400020e0 <run_pipeline.isra.0+0x590>
        printf("LS: cannot access %s\n", stage->argv[1]);
40002290:	6b c7 44             	imul   $0x44,%edi,%eax
40002293:	83 ec 08             	sub    $0x8,%esp
40002296:	ff b4 05 ac fb ff ff 	push   -0x454(%ebp,%eax,1)
4000229d:	68 d6 36 00 40       	push   $0x400036d6
400022a2:	e8 b9 e1 ff ff       	call   40000460 <printf>
400022a7:	83 c4 10             	add    $0x10,%esp
400022aa:	e9 31 fe ff ff       	jmp    400020e0 <run_pipeline.isra.0+0x590>
  unsigned int len = strlen(path);
400022af:	83 ec 0c             	sub    $0xc,%esp
400022b2:	8d 85 a8 f7 ff ff    	lea    -0x858(%ebp),%eax
	asm volatile("int %2"
400022b8:	8d 9d a8 f7 ff ff    	lea    -0x858(%ebp),%ebx
  unsigned int len = strlen(path);
400022be:	50                   	push   %eax
400022bf:	e8 3c e9 ff ff       	call   40000c00 <strlen>
400022c4:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400022c6:	b8 0b 00 00 00       	mov    $0xb,%eax
400022cb:	cd 30                	int    $0x30
        printf("LS: spawn failed\n");
400022cd:	c7 04 24 ec 36 00 40 	movl   $0x400036ec,(%esp)
400022d4:	e8 87 e1 ff ff       	call   40000460 <printf>
400022d9:	83 c4 10             	add    $0x10,%esp
400022dc:	e9 ff fd ff ff       	jmp    400020e0 <run_pipeline.isra.0+0x590>
    printf("Unknown process command '%s'\n", stage->argv[0]);
400022e1:	83 ec 08             	sub    $0x8,%esp
400022e4:	53                   	push   %ebx
400022e5:	68 a0 36 00 40       	push   $0x400036a0
400022ea:	e8 71 e1 ff ff       	call   40000460 <printf>
400022ef:	83 c4 10             	add    $0x10,%esp
400022f2:	e9 e9 fd ff ff       	jmp    400020e0 <run_pipeline.isra.0+0x590>
400022f7:	90                   	nop
400022f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400022ff:	00 

40002300 <rm_file>:
int rm_file(char *filename) {
40002300:	55                   	push   %ebp
40002301:	89 e5                	mov    %esp,%ebp
40002303:	53                   	push   %ebx
40002304:	83 ec 10             	sub    $0x10,%esp
  unsigned int len = strlen(path);
40002307:	ff 75 08             	push   0x8(%ebp)
4000230a:	e8 f1 e8 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
4000230f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  unsigned int len = strlen(path);
40002312:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002314:	b8 0d 00 00 00       	mov    $0xd,%eax
40002319:	cd 30                	int    $0x30
	return errno ? -1 : 0;
4000231b:	83 c4 10             	add    $0x10,%esp
4000231e:	85 c0                	test   %eax,%eax
40002320:	75 0e                	jne    40002330 <rm_file+0x30>
}
40002322:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40002325:	c9                   	leave
40002326:	c3                   	ret
40002327:	90                   	nop
40002328:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000232f:	00 
    printf("rm: can not remove %s: sys_unlink error.\n", filename);
40002330:	83 ec 08             	sub    $0x8,%esp
40002333:	ff 75 08             	push   0x8(%ebp)
40002336:	68 b8 3d 00 40       	push   $0x40003db8
4000233b:	e8 20 e1 ff ff       	call   40000460 <printf>
40002340:	83 c4 10             	add    $0x10,%esp
40002343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return errno;
40002348:	eb d8                	jmp    40002322 <rm_file+0x22>
4000234a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40002350 <ls_dir>:
int ls_dir(char *buf, char *path) {
40002350:	55                   	push   %ebp
40002351:	89 e5                	mov    %esp,%ebp
40002353:	57                   	push   %edi
40002354:	56                   	push   %esi
40002355:	53                   	push   %ebx
40002356:	81 ec 0c 04 00 00    	sub    $0x40c,%esp
4000235c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if (path == NULL) {
4000235f:	85 ff                	test   %edi,%edi
40002361:	74 7d                	je     400023e0 <ls_dir+0x90>
	asm volatile ("int %2"
40002363:	8d b5 e8 fb ff ff    	lea    -0x418(%ebp),%esi
40002369:	b8 15 00 00 00       	mov    $0x15,%eax
4000236e:	89 f3                	mov    %esi,%ebx
40002370:	cd 30                	int    $0x30
  unsigned int len = strlen(path);
40002372:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002375:	89 fb                	mov    %edi,%ebx
  unsigned int len = strlen(path);
40002377:	57                   	push   %edi
40002378:	e8 83 e8 ff ff       	call   40000c00 <strlen>
4000237d:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000237f:	b8 0b 00 00 00       	mov    $0xb,%eax
40002384:	cd 30                	int    $0x30
	asm volatile("int %2"
40002386:	b8 12 00 00 00       	mov    $0x12,%eax
4000238b:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000238e:	b9 00 04 00 00       	mov    $0x400,%ecx
40002393:	cd 30                	int    $0x30
40002395:	89 df                	mov    %ebx,%edi
	return errno ? -1: len;
40002397:	83 c4 10             	add    $0x10,%esp
4000239a:	85 c0                	test   %eax,%eax
4000239c:	75 5e                	jne    400023fc <ls_dir+0xac>
  unsigned int len = strlen(path);
4000239e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400023a1:	89 f3                	mov    %esi,%ebx
  unsigned int len = strlen(path);
400023a3:	56                   	push   %esi
400023a4:	e8 57 e8 ff ff       	call   40000c00 <strlen>
400023a9:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400023ab:	b8 0b 00 00 00       	mov    $0xb,%eax
400023b0:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400023b2:	83 c4 10             	add    $0x10,%esp
  while (i < len) {
400023b5:	85 ff                	test   %edi,%edi
400023b7:	7e 16                	jle    400023cf <ls_dir+0x7f>
400023b9:	8b 45 08             	mov    0x8(%ebp),%eax
400023bc:	8d 14 38             	lea    (%eax,%edi,1),%edx
400023bf:	90                   	nop
    if (buf[i] == ' ') {
400023c0:	80 38 20             	cmpb   $0x20,(%eax)
400023c3:	75 03                	jne    400023c8 <ls_dir+0x78>
      buf[i] = '\0';
400023c5:	c6 00 00             	movb   $0x0,(%eax)
  while (i < len) {
400023c8:	83 c0 01             	add    $0x1,%eax
400023cb:	39 d0                	cmp    %edx,%eax
400023cd:	75 f1                	jne    400023c0 <ls_dir+0x70>
}
400023cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
400023d2:	89 f8                	mov    %edi,%eax
400023d4:	5b                   	pop    %ebx
400023d5:	5e                   	pop    %esi
400023d6:	5f                   	pop    %edi
400023d7:	5d                   	pop    %ebp
400023d8:	c3                   	ret
400023d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	asm volatile("int %2"
400023e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
400023e3:	b8 12 00 00 00       	mov    $0x12,%eax
400023e8:	b9 00 04 00 00       	mov    $0x400,%ecx
400023ed:	cd 30                	int    $0x30
400023ef:	89 df                	mov    %ebx,%edi
	return errno ? -1: len;
400023f1:	85 c0                	test   %eax,%eax
400023f3:	74 c0                	je     400023b5 <ls_dir+0x65>
    len = sys_ls(buf, BUFLEN);
400023f5:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  return len;
400023fa:	eb d3                	jmp    400023cf <ls_dir+0x7f>
  unsigned int len = strlen(path);
400023fc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400023ff:	89 f3                	mov    %esi,%ebx
  unsigned int len = strlen(path);
40002401:	56                   	push   %esi
40002402:	e8 f9 e7 ff ff       	call   40000c00 <strlen>
40002407:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002409:	b8 0b 00 00 00       	mov    $0xb,%eax
4000240e:	cd 30                	int    $0x30
40002410:	83 c4 10             	add    $0x10,%esp
40002413:	eb e0                	jmp    400023f5 <ls_dir+0xa5>
40002415:	8d 76 00             	lea    0x0(%esi),%esi
40002418:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000241f:	00 

40002420 <is_dir_empty>:
int is_dir_empty(char *dirname) {
40002420:	55                   	push   %ebp
40002421:	89 e5                	mov    %esp,%ebp
40002423:	83 ec 10             	sub    $0x10,%esp
  if (ls_dir(shell_buf, NULL) == 5) {
40002426:	6a 00                	push   $0x0
40002428:	68 a0 55 00 40       	push   $0x400055a0
4000242d:	e8 1e ff ff ff       	call   40002350 <ls_dir>
40002432:	83 c4 10             	add    $0x10,%esp
}
40002435:	c9                   	leave
  if (ls_dir(shell_buf, NULL) == 5) {
40002436:	83 f8 05             	cmp    $0x5,%eax
40002439:	0f 94 c0             	sete   %al
4000243c:	0f b6 c0             	movzbl %al,%eax
}
4000243f:	c3                   	ret

40002440 <is_dir>:
int is_dir(char *path) {
40002440:	55                   	push   %ebp
40002441:	89 e5                	mov    %esp,%ebp
40002443:	57                   	push   %edi
40002444:	56                   	push   %esi
40002445:	53                   	push   %ebx
40002446:	83 ec 18             	sub    $0x18,%esp
40002449:	8b 75 08             	mov    0x8(%ebp),%esi
        unsigned int len = strlen(path);
4000244c:	56                   	push   %esi
	asm volatile("int %2"
4000244d:	89 f3                	mov    %esi,%ebx
        unsigned int len = strlen(path);
4000244f:	e8 ac e7 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40002454:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40002456:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002458:	b8 05 00 00 00       	mov    $0x5,%eax
4000245d:	cd 30                	int    $0x30
  if (fd == -1) {
4000245f:	83 c4 10             	add    $0x10,%esp
40002462:	83 fb ff             	cmp    $0xffffffff,%ebx
40002465:	74 51                	je     400024b8 <is_dir+0x78>
40002467:	85 c0                	test   %eax,%eax
40002469:	75 4d                	jne    400024b8 <is_dir+0x78>
	asm volatile("int %2"
4000246b:	b8 06 00 00 00       	mov    $0x6,%eax
40002470:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
40002472:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002475:	89 f3                	mov    %esi,%ebx
        unsigned int len = strlen(path);
40002477:	56                   	push   %esi
40002478:	e8 83 e7 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
4000247d:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
4000247f:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002481:	b8 05 00 00 00       	mov    $0x5,%eax
40002486:	cd 30                	int    $0x30
40002488:	89 de                	mov    %ebx,%esi
	return errno ? -1 : fd;
4000248a:	83 c4 10             	add    $0x10,%esp
  if (fd < 0)
4000248d:	85 c0                	test   %eax,%eax
4000248f:	75 27                	jne    400024b8 <is_dir+0x78>
40002491:	85 db                	test   %ebx,%ebx
40002493:	78 23                	js     400024b8 <is_dir+0x78>
	asm volatile("int %2"
40002495:	b8 11 00 00 00       	mov    $0x11,%eax
4000249a:	cd 30                	int    $0x30
4000249c:	89 da                	mov    %ebx,%edx
	return errno ? -1 : isDir;
4000249e:	85 c0                	test   %eax,%eax
400024a0:	75 22                	jne    400024c4 <is_dir+0x84>
	asm volatile("int %2"
400024a2:	b8 06 00 00 00       	mov    $0x6,%eax
400024a7:	89 f3                	mov    %esi,%ebx
400024a9:	cd 30                	int    $0x30
}
400024ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
400024ae:	89 d0                	mov    %edx,%eax
400024b0:	5b                   	pop    %ebx
400024b1:	5e                   	pop    %esi
400024b2:	5f                   	pop    %edi
400024b3:	5d                   	pop    %ebp
400024b4:	c3                   	ret
400024b5:	8d 76 00             	lea    0x0(%esi),%esi
400024b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
400024bb:	31 d2                	xor    %edx,%edx
}
400024bd:	5b                   	pop    %ebx
400024be:	89 d0                	mov    %edx,%eax
400024c0:	5e                   	pop    %esi
400024c1:	5f                   	pop    %edi
400024c2:	5d                   	pop    %ebp
400024c3:	c3                   	ret
	return errno ? -1 : isDir;
400024c4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
400024c9:	eb d7                	jmp    400024a2 <is_dir+0x62>
400024cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

400024d0 <_shell_rm>:
int _shell_rm(char *path, int isRecursive) {
400024d0:	55                   	push   %ebp
400024d1:	89 e5                	mov    %esp,%ebp
400024d3:	56                   	push   %esi
400024d4:	53                   	push   %ebx
400024d5:	8b 55 0c             	mov    0xc(%ebp),%edx
400024d8:	8b 75 08             	mov    0x8(%ebp),%esi
  if (isRecursive) {
400024db:	85 d2                	test   %edx,%edx
400024dd:	74 11                	je     400024f0 <_shell_rm+0x20>
}
400024df:	8d 65 f8             	lea    -0x8(%ebp),%esp
400024e2:	89 f0                	mov    %esi,%eax
400024e4:	5b                   	pop    %ebx
400024e5:	5e                   	pop    %esi
400024e6:	5d                   	pop    %ebp
400024e7:	eb 77                	jmp    40002560 <_shell_rm.part.0>
400024e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (is_dir(path)) {
400024f0:	83 ec 0c             	sub    $0xc,%esp
400024f3:	56                   	push   %esi
400024f4:	e8 47 ff ff ff       	call   40002440 <is_dir>
400024f9:	83 c4 10             	add    $0x10,%esp
400024fc:	85 c0                	test   %eax,%eax
400024fe:	75 28                	jne    40002528 <_shell_rm+0x58>
  unsigned int len = strlen(path);
40002500:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002503:	89 f3                	mov    %esi,%ebx
  unsigned int len = strlen(path);
40002505:	56                   	push   %esi
40002506:	e8 f5 e6 ff ff       	call   40000c00 <strlen>
4000250b:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000250d:	b8 0d 00 00 00       	mov    $0xd,%eax
40002512:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002514:	83 c4 10             	add    $0x10,%esp
40002517:	85 c0                	test   %eax,%eax
40002519:	75 25                	jne    40002540 <_shell_rm+0x70>
}
4000251b:	8d 65 f8             	lea    -0x8(%ebp),%esp
4000251e:	5b                   	pop    %ebx
4000251f:	5e                   	pop    %esi
40002520:	5d                   	pop    %ebp
40002521:	c3                   	ret
40002522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf("rm: can not remove %s: is a directory. try '-r' ?\n", path);
40002528:	83 ec 08             	sub    $0x8,%esp
4000252b:	56                   	push   %esi
4000252c:	68 e4 3d 00 40       	push   $0x40003de4
40002531:	e8 2a df ff ff       	call   40000460 <printf>
      return -1;
40002536:	83 c4 10             	add    $0x10,%esp
40002539:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
4000253e:	eb db                	jmp    4000251b <_shell_rm+0x4b>
    printf("rm: can not remove %s: sys_unlink error.\n", filename);
40002540:	83 ec 08             	sub    $0x8,%esp
40002543:	56                   	push   %esi
40002544:	68 b8 3d 00 40       	push   $0x40003db8
40002549:	e8 12 df ff ff       	call   40000460 <printf>
4000254e:	83 c4 10             	add    $0x10,%esp
40002551:	eb e6                	jmp    40002539 <_shell_rm+0x69>
40002553:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40002558:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000255f:	00 

40002560 <_shell_rm.part.0>:
int _shell_rm(char *path, int isRecursive) {
40002560:	55                   	push   %ebp
40002561:	89 e5                	mov    %esp,%ebp
40002563:	57                   	push   %edi
40002564:	56                   	push   %esi
40002565:	89 c6                	mov    %eax,%esi
40002567:	53                   	push   %ebx
40002568:	81 ec 28 04 00 00    	sub    $0x428,%esp
4000256e:	89 95 e0 fb ff ff    	mov    %edx,-0x420(%ebp)
    if (!is_dir(path)) {
40002574:	50                   	push   %eax
40002575:	e8 c6 fe ff ff       	call   40002440 <is_dir>
4000257a:	83 c4 10             	add    $0x10,%esp
4000257d:	85 c0                	test   %eax,%eax
4000257f:	75 2f                	jne    400025b0 <_shell_rm.part.0+0x50>
  unsigned int len = strlen(path);
40002581:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002584:	89 f3                	mov    %esi,%ebx
  unsigned int len = strlen(path);
40002586:	56                   	push   %esi
40002587:	e8 74 e6 ff ff       	call   40000c00 <strlen>
4000258c:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000258e:	b8 0d 00 00 00       	mov    $0xd,%eax
40002593:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002595:	83 c4 10             	add    $0x10,%esp
40002598:	85 c0                	test   %eax,%eax
4000259a:	0f 85 28 01 00 00    	jne    400026c8 <_shell_rm.part.0+0x168>
    return 0;
400025a0:	31 c0                	xor    %eax,%eax
}
400025a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
400025a5:	5b                   	pop    %ebx
400025a6:	5e                   	pop    %esi
400025a7:	5f                   	pop    %edi
400025a8:	5d                   	pop    %ebp
400025a9:	c3                   	ret
400025aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  unsigned int len = strlen(path);
400025b0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400025b3:	89 f3                	mov    %esi,%ebx
  unsigned int len = strlen(path);
400025b5:	56                   	push   %esi
400025b6:	e8 45 e6 ff ff       	call   40000c00 <strlen>
400025bb:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400025bd:	b8 0b 00 00 00       	mov    $0xb,%eax
400025c2:	cd 30                	int    $0x30
	asm volatile("int %2"
400025c4:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
400025ca:	b8 12 00 00 00       	mov    $0x12,%eax
400025cf:	b9 00 04 00 00       	mov    $0x400,%ecx
400025d4:	89 fb                	mov    %edi,%ebx
400025d6:	cd 30                	int    $0x30
400025d8:	89 9d e4 fb ff ff    	mov    %ebx,-0x41c(%ebp)
	return errno ? -1: len;
400025de:	83 c4 10             	add    $0x10,%esp
400025e1:	85 c0                	test   %eax,%eax
400025e3:	75 5d                	jne    40002642 <_shell_rm.part.0+0xe2>
  while (i < len) {
400025e5:	8b 95 e4 fb ff ff    	mov    -0x41c(%ebp),%edx
400025eb:	85 d2                	test   %edx,%edx
400025ed:	7e 53                	jle    40002642 <_shell_rm.part.0+0xe2>
400025ef:	89 f8                	mov    %edi,%eax
400025f1:	01 fa                	add    %edi,%edx
400025f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
400025f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400025ff:	00 
    if (buf[i] == ' ') {
40002600:	80 38 20             	cmpb   $0x20,(%eax)
40002603:	75 03                	jne    40002608 <_shell_rm.part.0+0xa8>
      buf[i] = '\0';
40002605:	c6 00 00             	movb   $0x0,(%eax)
  while (i < len) {
40002608:	83 c0 01             	add    $0x1,%eax
4000260b:	39 d0                	cmp    %edx,%eax
4000260d:	75 f1                	jne    40002600 <_shell_rm.part.0+0xa0>
      sub_path = rm_buf;
4000260f:	89 fb                	mov    %edi,%ebx
        if (strcmp(sub_path, ".") && strcmp(sub_path, "..")) {
40002611:	83 ec 08             	sub    $0x8,%esp
40002614:	68 53 37 00 40       	push   $0x40003753
40002619:	53                   	push   %ebx
4000261a:	e8 f1 e6 ff ff       	call   40000d10 <strcmp>
4000261f:	83 c4 10             	add    $0x10,%esp
40002622:	85 c0                	test   %eax,%eax
40002624:	75 72                	jne    40002698 <_shell_rm.part.0+0x138>
        sub_path += strlen(sub_path) + 1;
40002626:	83 ec 0c             	sub    $0xc,%esp
40002629:	53                   	push   %ebx
4000262a:	e8 d1 e5 ff ff       	call   40000c00 <strlen>
      while (sub_path - rm_buf < len) {
4000262f:	83 c4 10             	add    $0x10,%esp
        sub_path += strlen(sub_path) + 1;
40002632:	8d 5c 03 01          	lea    0x1(%ebx,%eax,1),%ebx
      while (sub_path - rm_buf < len) {
40002636:	89 d8                	mov    %ebx,%eax
40002638:	29 f8                	sub    %edi,%eax
4000263a:	3b 85 e4 fb ff ff    	cmp    -0x41c(%ebp),%eax
40002640:	7c cf                	jl     40002611 <_shell_rm.part.0+0xb1>
  unsigned int len = strlen(path);
40002642:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002645:	bb 52 37 00 40       	mov    $0x40003752,%ebx
  unsigned int len = strlen(path);
4000264a:	68 52 37 00 40       	push   $0x40003752
4000264f:	e8 ac e5 ff ff       	call   40000c00 <strlen>
40002654:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002656:	b8 0b 00 00 00       	mov    $0xb,%eax
4000265b:	cd 30                	int    $0x30
  unsigned int len = strlen(path);
4000265d:	89 34 24             	mov    %esi,(%esp)
	asm volatile("int %2"
40002660:	89 f3                	mov    %esi,%ebx
  unsigned int len = strlen(path);
40002662:	e8 99 e5 ff ff       	call   40000c00 <strlen>
40002667:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002669:	b8 0d 00 00 00       	mov    $0xd,%eax
4000266e:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002670:	83 c4 10             	add    $0x10,%esp
40002673:	85 c0                	test   %eax,%eax
40002675:	0f 84 25 ff ff ff    	je     400025a0 <_shell_rm.part.0+0x40>
    printf("rm: can not remove %s: sys_unlink error.\n", filename);
4000267b:	83 ec 08             	sub    $0x8,%esp
4000267e:	56                   	push   %esi
4000267f:	68 b8 3d 00 40       	push   $0x40003db8
40002684:	e8 d7 dd ff ff       	call   40000460 <printf>
40002689:	83 c4 10             	add    $0x10,%esp
4000268c:	e9 0f ff ff ff       	jmp    400025a0 <_shell_rm.part.0+0x40>
40002691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (strcmp(sub_path, ".") && strcmp(sub_path, "..")) {
40002698:	83 ec 08             	sub    $0x8,%esp
4000269b:	68 52 37 00 40       	push   $0x40003752
400026a0:	53                   	push   %ebx
400026a1:	e8 6a e6 ff ff       	call   40000d10 <strcmp>
400026a6:	83 c4 10             	add    $0x10,%esp
400026a9:	85 c0                	test   %eax,%eax
400026ab:	0f 84 75 ff ff ff    	je     40002626 <_shell_rm.part.0+0xc6>
          _shell_rm(sub_path, isRecursive);
400026b1:	83 ec 08             	sub    $0x8,%esp
400026b4:	ff b5 e0 fb ff ff    	push   -0x420(%ebp)
400026ba:	53                   	push   %ebx
400026bb:	e8 10 fe ff ff       	call   400024d0 <_shell_rm>
400026c0:	83 c4 10             	add    $0x10,%esp
400026c3:	e9 5e ff ff ff       	jmp    40002626 <_shell_rm.part.0+0xc6>
    printf("rm: can not remove %s: sys_unlink error.\n", filename);
400026c8:	83 ec 08             	sub    $0x8,%esp
400026cb:	56                   	push   %esi
400026cc:	68 b8 3d 00 40       	push   $0x40003db8
400026d1:	e8 8a dd ff ff       	call   40000460 <printf>
400026d6:	83 c4 10             	add    $0x10,%esp
400026d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
400026de:	e9 bf fe ff ff       	jmp    400025a2 <_shell_rm.part.0+0x42>
400026e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
400026e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400026ef:	00 

400026f0 <shell_rm>:
int shell_rm(int argc, char **argv) {
400026f0:	55                   	push   %ebp
400026f1:	89 e5                	mov    %esp,%ebp
400026f3:	57                   	push   %edi
400026f4:	56                   	push   %esi
400026f5:	53                   	push   %ebx
400026f6:	83 ec 0c             	sub    $0xc,%esp
400026f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if (argc == 1) {
400026fc:	83 ff 01             	cmp    $0x1,%edi
400026ff:	0f 84 9b 00 00 00    	je     400027a0 <shell_rm+0xb0>
  if (!strcmp(argv[1], "-r")) {
40002705:	8b 45 0c             	mov    0xc(%ebp),%eax
40002708:	83 ec 08             	sub    $0x8,%esp
4000270b:	68 69 37 00 40       	push   $0x40003769
40002710:	ff 70 04             	push   0x4(%eax)
40002713:	e8 f8 e5 ff ff       	call   40000d10 <strcmp>
40002718:	83 c4 10             	add    $0x10,%esp
4000271b:	85 c0                	test   %eax,%eax
4000271d:	74 51                	je     40002770 <shell_rm+0x80>
    pathIdx = 1;
4000271f:	b8 01 00 00 00       	mov    $0x1,%eax
    isRecursive = 0;
40002724:	31 f6                	xor    %esi,%esi
  if (pathIdx >= argc) {
40002726:	39 f8                	cmp    %edi,%eax
40002728:	7d 54                	jge    4000277e <shell_rm+0x8e>
  path = argv[pathIdx];
4000272a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
        unsigned int len = strlen(path);
4000272d:	83 ec 0c             	sub    $0xc,%esp
40002730:	8b 3c 81             	mov    (%ecx,%eax,4),%edi
40002733:	57                   	push   %edi
	asm volatile("int %2"
40002734:	89 fb                	mov    %edi,%ebx
        unsigned int len = strlen(path);
40002736:	e8 c5 e4 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
4000273b:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
4000273d:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
4000273f:	b8 05 00 00 00       	mov    $0x5,%eax
40002744:	cd 30                	int    $0x30
	return errno ? -1 : fd;
40002746:	83 c4 10             	add    $0x10,%esp
  if (fd == -1) {
40002749:	85 c0                	test   %eax,%eax
4000274b:	75 73                	jne    400027c0 <shell_rm+0xd0>
4000274d:	83 fb ff             	cmp    $0xffffffff,%ebx
40002750:	74 6e                	je     400027c0 <shell_rm+0xd0>
	asm volatile("int %2"
40002752:	b8 06 00 00 00       	mov    $0x6,%eax
40002757:	cd 30                	int    $0x30
  _shell_rm(path, isRecursive);
40002759:	83 ec 08             	sub    $0x8,%esp
4000275c:	56                   	push   %esi
4000275d:	57                   	push   %edi
4000275e:	e8 6d fd ff ff       	call   400024d0 <_shell_rm>
  return 0;
40002763:	83 c4 10             	add    $0x10,%esp
}
40002766:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002769:	31 c0                	xor    %eax,%eax
4000276b:	5b                   	pop    %ebx
4000276c:	5e                   	pop    %esi
4000276d:	5f                   	pop    %edi
4000276e:	5d                   	pop    %ebp
4000276f:	c3                   	ret
    pathIdx = 2;
40002770:	b8 02 00 00 00       	mov    $0x2,%eax
    isRecursive = 1;
40002775:	be 01 00 00 00       	mov    $0x1,%esi
  if (pathIdx >= argc) {
4000277a:	39 f8                	cmp    %edi,%eax
4000277c:	7c ac                	jl     4000272a <shell_rm+0x3a>
    printf("rm: no path argument.\n");
4000277e:	83 ec 0c             	sub    $0xc,%esp
40002781:	68 6c 37 00 40       	push   $0x4000376c
40002786:	e8 d5 dc ff ff       	call   40000460 <printf>
    return 0;
4000278b:	83 c4 10             	add    $0x10,%esp
}
4000278e:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002791:	31 c0                	xor    %eax,%eax
40002793:	5b                   	pop    %ebx
40002794:	5e                   	pop    %esi
40002795:	5f                   	pop    %edi
40002796:	5d                   	pop    %ebp
40002797:	c3                   	ret
40002798:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000279f:	00 
    printf("Too few arguments.\n");
400027a0:	83 ec 0c             	sub    $0xc,%esp
400027a3:	68 55 37 00 40       	push   $0x40003755
400027a8:	e8 b3 dc ff ff       	call   40000460 <printf>
    return 0;
400027ad:	83 c4 10             	add    $0x10,%esp
}
400027b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
400027b3:	31 c0                	xor    %eax,%eax
400027b5:	5b                   	pop    %ebx
400027b6:	5e                   	pop    %esi
400027b7:	5f                   	pop    %edi
400027b8:	5d                   	pop    %ebp
400027b9:	c3                   	ret
400027ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf("rm: can not remove %s: is not a file or directory.\n", path);
400027c0:	83 ec 08             	sub    $0x8,%esp
400027c3:	57                   	push   %edi
400027c4:	68 18 3e 00 40       	push   $0x40003e18
400027c9:	e8 92 dc ff ff       	call   40000460 <printf>
    return 0;
400027ce:	83 c4 10             	add    $0x10,%esp
}
400027d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
400027d4:	31 c0                	xor    %eax,%eax
400027d6:	5b                   	pop    %ebx
400027d7:	5e                   	pop    %esi
400027d8:	5f                   	pop    %edi
400027d9:	5d                   	pop    %ebp
400027da:	c3                   	ret
400027db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

400027e0 <is_file_exist>:
int is_file_exist(char *path) {
400027e0:	55                   	push   %ebp
400027e1:	89 e5                	mov    %esp,%ebp
400027e3:	53                   	push   %ebx
400027e4:	83 ec 10             	sub    $0x10,%esp
        unsigned int len = strlen(path);
400027e7:	ff 75 08             	push   0x8(%ebp)
400027ea:	e8 11 e4 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
400027ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
400027f2:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
400027f4:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
400027f6:	b8 05 00 00 00       	mov    $0x5,%eax
400027fb:	cd 30                	int    $0x30
  if (fd == -1) {
400027fd:	83 c4 10             	add    $0x10,%esp
40002800:	83 fb ff             	cmp    $0xffffffff,%ebx
40002803:	74 1b                	je     40002820 <is_file_exist+0x40>
40002805:	85 c0                	test   %eax,%eax
40002807:	75 17                	jne    40002820 <is_file_exist+0x40>
	asm volatile("int %2"
40002809:	b8 06 00 00 00       	mov    $0x6,%eax
4000280e:	cd 30                	int    $0x30
  return 1;
40002810:	b8 01 00 00 00       	mov    $0x1,%eax
}
40002815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40002818:	c9                   	leave
40002819:	c3                   	ret
4000281a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40002820:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
40002823:	31 c0                	xor    %eax,%eax
}
40002825:	c9                   	leave
40002826:	c3                   	ret
40002827:	90                   	nop
40002828:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000282f:	00 

40002830 <_shell_cat>:
int _shell_cat(char *path) {
40002830:	55                   	push   %ebp
40002831:	89 e5                	mov    %esp,%ebp
40002833:	56                   	push   %esi
40002834:	53                   	push   %ebx
40002835:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
4000283b:	8b 75 08             	mov    0x8(%ebp),%esi
        unsigned int len = strlen(path);
4000283e:	56                   	push   %esi
	asm volatile("int %2"
4000283f:	89 f3                	mov    %esi,%ebx
        unsigned int len = strlen(path);
40002841:	e8 ba e3 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40002846:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40002848:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
4000284a:	b8 05 00 00 00       	mov    $0x5,%eax
4000284f:	cd 30                	int    $0x30
  if (fd == -1) {
40002851:	83 c4 10             	add    $0x10,%esp
40002854:	83 fb ff             	cmp    $0xffffffff,%ebx
40002857:	74 77                	je     400028d0 <_shell_cat+0xa0>
40002859:	85 c0                	test   %eax,%eax
4000285b:	75 73                	jne    400028d0 <_shell_cat+0xa0>
4000285d:	89 de                	mov    %ebx,%esi
	asm volatile("int %2"
4000285f:	8d 8d f8 fd ff ff    	lea    -0x208(%ebp),%ecx
40002865:	b8 07 00 00 00       	mov    $0x7,%eax
4000286a:	ba ff 01 00 00       	mov    $0x1ff,%edx
4000286f:	cd 30                	int    $0x30
40002871:	89 da                	mov    %ebx,%edx
  while ((n = read(fd, buf, sizeof(buf) - 1)) > 0) {
40002873:	85 db                	test   %ebx,%ebx
40002875:	7e 37                	jle    400028ae <_shell_cat+0x7e>
40002877:	85 c0                	test   %eax,%eax
40002879:	75 33                	jne    400028ae <_shell_cat+0x7e>
    printf("%s", buf);
4000287b:	83 ec 08             	sub    $0x8,%esp
    buf[n] = '\0';
4000287e:	c6 84 15 f8 fd ff ff 	movb   $0x0,-0x208(%ebp,%edx,1)
40002885:	00 
40002886:	89 f3                	mov    %esi,%ebx
    printf("%s", buf);
40002888:	51                   	push   %ecx
40002889:	68 83 37 00 40       	push   $0x40003783
4000288e:	e8 cd db ff ff       	call   40000460 <printf>
40002893:	b8 07 00 00 00       	mov    $0x7,%eax
40002898:	ba ff 01 00 00       	mov    $0x1ff,%edx
4000289d:	8d 8d f8 fd ff ff    	lea    -0x208(%ebp),%ecx
400028a3:	cd 30                	int    $0x30
400028a5:	89 da                	mov    %ebx,%edx
  while ((n = read(fd, buf, sizeof(buf) - 1)) > 0) {
400028a7:	83 c4 10             	add    $0x10,%esp
400028aa:	85 db                	test   %ebx,%ebx
400028ac:	7f c9                	jg     40002877 <_shell_cat+0x47>
  printf("\n");
400028ae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400028b1:	89 f3                	mov    %esi,%ebx
400028b3:	68 45 36 00 40       	push   $0x40003645
400028b8:	e8 a3 db ff ff       	call   40000460 <printf>
400028bd:	b8 06 00 00 00       	mov    $0x6,%eax
400028c2:	cd 30                	int    $0x30
  return 0;
400028c4:	31 c0                	xor    %eax,%eax
400028c6:	83 c4 10             	add    $0x10,%esp
}
400028c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
400028cc:	5b                   	pop    %ebx
400028cd:	5e                   	pop    %esi
400028ce:	5d                   	pop    %ebp
400028cf:	c3                   	ret
    return -1; /* file does not exist */
400028d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
400028d5:	eb f2                	jmp    400028c9 <_shell_cat+0x99>
400028d7:	90                   	nop
400028d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400028df:	00 

400028e0 <shell_cat>:
int shell_cat(int argc, char **argv) {
400028e0:	55                   	push   %ebp
400028e1:	89 e5                	mov    %esp,%ebp
400028e3:	57                   	push   %edi
400028e4:	56                   	push   %esi
400028e5:	53                   	push   %ebx
400028e6:	83 ec 0c             	sub    $0xc,%esp
400028e9:	8b 7d 08             	mov    0x8(%ebp),%edi
400028ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  if (argc == 1) {
400028ef:	83 ff 01             	cmp    $0x1,%edi
400028f2:	74 4c                	je     40002940 <shell_cat+0x60>
  for (i = 1; i < argc; i++) {
400028f4:	bb 01 00 00 00       	mov    $0x1,%ebx
400028f9:	7f 0c                	jg     40002907 <shell_cat+0x27>
400028fb:	eb 37                	jmp    40002934 <shell_cat+0x54>
400028fd:	8d 76 00             	lea    0x0(%esi),%esi
40002900:	83 c3 01             	add    $0x1,%ebx
40002903:	39 df                	cmp    %ebx,%edi
40002905:	74 2d                	je     40002934 <shell_cat+0x54>
    if (_shell_cat(argv[i]) == -1) {
40002907:	83 ec 0c             	sub    $0xc,%esp
4000290a:	ff 34 9e             	push   (%esi,%ebx,4)
4000290d:	e8 1e ff ff ff       	call   40002830 <_shell_cat>
40002912:	83 c4 10             	add    $0x10,%esp
40002915:	83 f8 ff             	cmp    $0xffffffff,%eax
40002918:	75 e6                	jne    40002900 <shell_cat+0x20>
      printf("cat: '%s': no such file or invalid path.\n", argv[i]);
4000291a:	83 ec 08             	sub    $0x8,%esp
4000291d:	ff 34 9e             	push   (%esi,%ebx,4)
  for (i = 1; i < argc; i++) {
40002920:	83 c3 01             	add    $0x1,%ebx
      printf("cat: '%s': no such file or invalid path.\n", argv[i]);
40002923:	68 4c 3e 00 40       	push   $0x40003e4c
40002928:	e8 33 db ff ff       	call   40000460 <printf>
4000292d:	83 c4 10             	add    $0x10,%esp
  for (i = 1; i < argc; i++) {
40002930:	39 df                	cmp    %ebx,%edi
40002932:	75 d3                	jne    40002907 <shell_cat+0x27>
}
40002934:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002937:	31 c0                	xor    %eax,%eax
40002939:	5b                   	pop    %ebx
4000293a:	5e                   	pop    %esi
4000293b:	5f                   	pop    %edi
4000293c:	5d                   	pop    %ebp
4000293d:	c3                   	ret
4000293e:	66 90                	xchg   %ax,%ax
    printf("cat: No path given.\n");
40002940:	83 ec 0c             	sub    $0xc,%esp
40002943:	68 86 37 00 40       	push   $0x40003786
40002948:	e8 13 db ff ff       	call   40000460 <printf>
    return 0;
4000294d:	83 c4 10             	add    $0x10,%esp
}
40002950:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002953:	31 c0                	xor    %eax,%eax
40002955:	5b                   	pop    %ebx
40002956:	5e                   	pop    %esi
40002957:	5f                   	pop    %edi
40002958:	5d                   	pop    %ebp
40002959:	c3                   	ret
4000295a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40002960 <shell_test>:
void shell_test() {
40002960:	55                   	push   %ebp
40002961:	89 e5                	mov    %esp,%ebp
40002963:	83 ec 44             	sub    $0x44,%esp
  printf("Test 1: Basic signal handling\n");
40002966:	68 78 3e 00 40       	push   $0x40003e78
4000296b:	e8 f0 da ff ff       	call   40000460 <printf>
  if (sigaction(SIGUSR1, &sa, NULL) < 0) {
40002970:	83 c4 0c             	add    $0xc,%esp
40002973:	8d 45 d0             	lea    -0x30(%ebp),%eax
  sa.sa_handler = signal_handler;
40002976:	c7 45 d0 b0 11 00 40 	movl   $0x400011b0,-0x30(%ebp)
  if (sigaction(SIGUSR1, &sa, NULL) < 0) {
4000297d:	6a 00                	push   $0x0
4000297f:	50                   	push   %eax
40002980:	6a 0a                	push   $0xa
  sa.sa_flags = 0;
40002982:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  sa.sa_mask = 0;
40002989:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  if (sigaction(SIGUSR1, &sa, NULL) < 0) {
40002990:	e8 5b e7 ff ff       	call   400010f0 <sigaction>
40002995:	83 c4 10             	add    $0x10,%esp
40002998:	85 c0                	test   %eax,%eax
4000299a:	0f 88 b0 00 00 00    	js     40002a50 <shell_test+0xf0>
  printf("Registered handler for SIGUSR1\n");
400029a0:	83 ec 0c             	sub    $0xc,%esp
400029a3:	68 98 3e 00 40       	push   $0x40003e98
400029a8:	e8 b3 da ff ff       	call   40000460 <printf>
  printf("Sending SIGUSR1 to self...\n");
400029ad:	c7 04 24 9b 37 00 40 	movl   $0x4000379b,(%esp)
400029b4:	e8 a7 da ff ff       	call   40000460 <printf>
  kill(getpid(), SIGUSR1);
400029b9:	59                   	pop    %ecx
400029ba:	58                   	pop    %eax
400029bb:	6a 0a                	push   $0xa
400029bd:	6a 01                	push   $0x1
400029bf:	e8 4c e7 ff ff       	call   40001110 <kill>
  printf("\nTest 2: Signal blocking\n");
400029c4:	c7 04 24 b7 37 00 40 	movl   $0x400037b7,(%esp)
400029cb:	e8 90 da ff ff       	call   40000460 <printf>
  if (sigaction(SIGUSR2, &sa2, NULL) < 0) {
400029d0:	83 c4 0c             	add    $0xc,%esp
400029d3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  sa2.sa_handler = signal_handler;
400029d6:	c7 45 e4 b0 11 00 40 	movl   $0x400011b0,-0x1c(%ebp)
  if (sigaction(SIGUSR2, &sa2, NULL) < 0) {
400029dd:	6a 00                	push   $0x0
400029df:	50                   	push   %eax
400029e0:	6a 0c                	push   $0xc
  sa2.sa_flags = 0;
400029e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  sa2.sa_mask = (1 << SIGUSR2); // Block SIGUSR2
400029e9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  if (sigaction(SIGUSR2, &sa2, NULL) < 0) {
400029f0:	e8 fb e6 ff ff       	call   400010f0 <sigaction>
400029f5:	83 c4 10             	add    $0x10,%esp
400029f8:	85 c0                	test   %eax,%eax
400029fa:	78 54                	js     40002a50 <shell_test+0xf0>
  printf("Registered handler for SIGUSR2 (blocked)\n");
400029fc:	83 ec 0c             	sub    $0xc,%esp
400029ff:	68 b8 3e 00 40       	push   $0x40003eb8
40002a04:	e8 57 da ff ff       	call   40000460 <printf>
  printf("Sending SIGUSR2 to self...\n");
40002a09:	c7 04 24 d1 37 00 40 	movl   $0x400037d1,(%esp)
40002a10:	e8 4b da ff ff       	call   40000460 <printf>
  kill(getpid(), SIGUSR2);
40002a15:	58                   	pop    %eax
40002a16:	5a                   	pop    %edx
40002a17:	6a 0c                	push   $0xc
40002a19:	6a 01                	push   $0x1
40002a1b:	e8 f0 e6 ff ff       	call   40001110 <kill>
  printf("\nTest 3: pause() functionality\n");
40002a20:	c7 04 24 e4 3e 00 40 	movl   $0x40003ee4,(%esp)
40002a27:	e8 34 da ff ff       	call   40000460 <printf>
  printf("Process will pause until SIGUSR1 is received...\n");
40002a2c:	c7 04 24 04 3f 00 40 	movl   $0x40003f04,(%esp)
40002a33:	e8 28 da ff ff       	call   40000460 <printf>
  pause();
40002a38:	e8 f3 e6 ff ff       	call   40001130 <pause>
  printf("Resumed after receiving signal\n");
40002a3d:	c7 04 24 38 3f 00 40 	movl   $0x40003f38,(%esp)
40002a44:	e8 17 da ff ff       	call   40000460 <printf>
40002a49:	83 c4 10             	add    $0x10,%esp
}
40002a4c:	c9                   	leave
40002a4d:	c3                   	ret
40002a4e:	66 90                	xchg   %ax,%ax
    printf("Failed to register signal handler\n");
40002a50:	83 ec 0c             	sub    $0xc,%esp
40002a53:	68 fc 3b 00 40       	push   $0x40003bfc
40002a58:	e8 03 da ff ff       	call   40000460 <printf>
40002a5d:	83 c4 10             	add    $0x10,%esp
}
40002a60:	c9                   	leave
40002a61:	c3                   	ret
40002a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40002a68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40002a6f:	00 

40002a70 <extract_filename>:
int extract_filename(char *path, char *filename) {
40002a70:	55                   	push   %ebp
40002a71:	89 e5                	mov    %esp,%ebp
40002a73:	56                   	push   %esi
40002a74:	53                   	push   %ebx
40002a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n = strlen(path);
40002a78:	83 ec 0c             	sub    $0xc,%esp
40002a7b:	53                   	push   %ebx
40002a7c:	e8 7f e1 ff ff       	call   40000c00 <strlen>
  if (n == 0)
40002a81:	83 c4 10             	add    $0x10,%esp
  int n = strlen(path);
40002a84:	89 c6                	mov    %eax,%esi
  if (n == 0)
40002a86:	85 c0                	test   %eax,%eax
40002a88:	74 40                	je     40002aca <extract_filename+0x5a>
  while (pos >= 0) {
40002a8a:	89 c2                	mov    %eax,%edx
40002a8c:	83 ea 01             	sub    $0x1,%edx
40002a8f:	79 16                	jns    40002aa7 <extract_filename+0x37>
40002a91:	eb 4e                	jmp    40002ae1 <extract_filename+0x71>
40002a93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40002a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40002a9f:	00 
    pos--;
40002aa0:	8d 52 ff             	lea    -0x1(%edx),%edx
  while (pos >= 0) {
40002aa3:	85 c0                	test   %eax,%eax
40002aa5:	74 31                	je     40002ad8 <extract_filename+0x68>
    if (path[pos] == '/') {
40002aa7:	89 d0                	mov    %edx,%eax
40002aa9:	80 3c 13 2f          	cmpb   $0x2f,(%ebx,%edx,1)
40002aad:	75 f1                	jne    40002aa0 <extract_filename+0x30>
  strncpy(filename, path + pos + 1, n - (pos + 1));
40002aaf:	8d 52 01             	lea    0x1(%edx),%edx
40002ab2:	29 d6                	sub    %edx,%esi
40002ab4:	89 f2                	mov    %esi,%edx
40002ab6:	83 ec 04             	sub    $0x4,%esp
40002ab9:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
40002abd:	52                   	push   %edx
40002abe:	50                   	push   %eax
40002abf:	ff 75 0c             	push   0xc(%ebp)
40002ac2:	e8 b9 e1 ff ff       	call   40000c80 <strncpy>
  return n - (pos + 1);
40002ac7:	83 c4 10             	add    $0x10,%esp
}
40002aca:	8d 65 f8             	lea    -0x8(%ebp),%esp
40002acd:	89 f0                	mov    %esi,%eax
40002acf:	5b                   	pop    %ebx
40002ad0:	5e                   	pop    %esi
40002ad1:	5d                   	pop    %ebp
40002ad2:	c3                   	ret
40002ad3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  strncpy(filename, path + pos + 1, n - (pos + 1));
40002ad8:	89 f2                	mov    %esi,%edx
40002ada:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40002adf:	eb d5                	jmp    40002ab6 <extract_filename+0x46>
40002ae1:	89 d0                	mov    %edx,%eax
40002ae3:	31 f6                	xor    %esi,%esi
40002ae5:	31 d2                	xor    %edx,%edx
40002ae7:	eb cd                	jmp    40002ab6 <extract_filename+0x46>
40002ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40002af0 <_shell_cp>:
int _shell_cp(char *dest_path, char *src_path, int isRecursive) {
40002af0:	55                   	push   %ebp
40002af1:	89 e5                	mov    %esp,%ebp
40002af3:	57                   	push   %edi
40002af4:	56                   	push   %esi
40002af5:	53                   	push   %ebx
40002af6:	81 ec 28 0c 00 00    	sub    $0xc28,%esp
40002afc:	8b 7d 0c             	mov    0xc(%ebp),%edi
        unsigned int len = strlen(path);
40002aff:	57                   	push   %edi
	asm volatile("int %2"
40002b00:	89 fb                	mov    %edi,%ebx
        unsigned int len = strlen(path);
40002b02:	e8 f9 e0 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40002b07:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40002b09:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002b0b:	b8 05 00 00 00       	mov    $0x5,%eax
40002b10:	cd 30                	int    $0x30
	return errno ? -1 : fd;
40002b12:	83 c4 10             	add    $0x10,%esp
  if (fd == -1) {
40002b15:	85 c0                	test   %eax,%eax
40002b17:	0f 85 53 01 00 00    	jne    40002c70 <_shell_cp+0x180>
40002b1d:	83 fb ff             	cmp    $0xffffffff,%ebx
40002b20:	0f 84 4a 01 00 00    	je     40002c70 <_shell_cp+0x180>
	asm volatile("int %2"
40002b26:	b8 06 00 00 00       	mov    $0x6,%eax
40002b2b:	cd 30                	int    $0x30
  if (isRecursive == 0) {
40002b2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
40002b30:	85 db                	test   %ebx,%ebx
40002b32:	0f 85 88 00 00 00    	jne    40002bc0 <_shell_cp+0xd0>
    if (is_dir(src_path)) {
40002b38:	83 ec 0c             	sub    $0xc,%esp
40002b3b:	57                   	push   %edi
40002b3c:	e8 ff f8 ff ff       	call   40002440 <is_dir>
40002b41:	83 c4 10             	add    $0x10,%esp
40002b44:	85 c0                	test   %eax,%eax
40002b46:	0f 85 84 01 00 00    	jne    40002cd0 <_shell_cp+0x1e0>
40002b4c:	89 85 e4 f3 ff ff    	mov    %eax,-0xc1c(%ebp)
        unsigned int len = strlen(path);
40002b52:	83 ec 0c             	sub    $0xc,%esp
40002b55:	ff 75 08             	push   0x8(%ebp)
40002b58:	e8 a3 e0 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40002b5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
40002b60:	8b 8d e4 f3 ff ff    	mov    -0xc1c(%ebp),%ecx
        unsigned int len = strlen(path);
40002b66:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002b68:	b8 05 00 00 00       	mov    $0x5,%eax
40002b6d:	cd 30                	int    $0x30
  if (fd == -1) {
40002b6f:	83 c4 10             	add    $0x10,%esp
40002b72:	83 fb ff             	cmp    $0xffffffff,%ebx
40002b75:	74 21                	je     40002b98 <_shell_cp+0xa8>
40002b77:	85 c0                	test   %eax,%eax
40002b79:	75 1d                	jne    40002b98 <_shell_cp+0xa8>
	asm volatile("int %2"
40002b7b:	b8 06 00 00 00       	mov    $0x6,%eax
40002b80:	cd 30                	int    $0x30
    if (is_file_exist(dest_path) && is_dir(dest_path)) {
40002b82:	83 ec 0c             	sub    $0xc,%esp
40002b85:	ff 75 08             	push   0x8(%ebp)
40002b88:	e8 b3 f8 ff ff       	call   40002440 <is_dir>
40002b8d:	83 c4 10             	add    $0x10,%esp
40002b90:	85 c0                	test   %eax,%eax
40002b92:	0f 85 90 02 00 00    	jne    40002e28 <_shell_cp+0x338>
  if (is_dir(src_filename)) {
40002b98:	83 ec 0c             	sub    $0xc,%esp
40002b9b:	57                   	push   %edi
40002b9c:	e8 9f f8 ff ff       	call   40002440 <is_dir>
40002ba1:	83 c4 10             	add    $0x10,%esp
40002ba4:	85 c0                	test   %eax,%eax
40002ba6:	0f 85 04 01 00 00    	jne    40002cb0 <_shell_cp+0x1c0>
40002bac:	8b 45 08             	mov    0x8(%ebp),%eax
40002baf:	89 fa                	mov    %edi,%edx
40002bb1:	e8 da ee ff ff       	call   40001a90 <cp_file.part.0>
}
40002bb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002bb9:	31 c0                	xor    %eax,%eax
40002bbb:	5b                   	pop    %ebx
40002bbc:	5e                   	pop    %esi
40002bbd:	5f                   	pop    %edi
40002bbe:	5d                   	pop    %ebp
40002bbf:	c3                   	ret
    if (is_dir(src_path)) {
40002bc0:	83 ec 0c             	sub    $0xc,%esp
40002bc3:	57                   	push   %edi
40002bc4:	e8 77 f8 ff ff       	call   40002440 <is_dir>
40002bc9:	83 c4 10             	add    $0x10,%esp
40002bcc:	85 c0                	test   %eax,%eax
40002bce:	0f 84 bc 00 00 00    	je     40002c90 <_shell_cp+0x1a0>
        unsigned int len = strlen(path);
40002bd4:	83 ec 0c             	sub    $0xc,%esp
40002bd7:	ff 75 08             	push   0x8(%ebp)
40002bda:	e8 21 e0 ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40002bdf:	8b 5d 08             	mov    0x8(%ebp),%ebx
40002be2:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40002be4:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002be6:	b8 05 00 00 00       	mov    $0x5,%eax
40002beb:	cd 30                	int    $0x30
	return errno ? -1 : fd;
40002bed:	83 c4 10             	add    $0x10,%esp
  if (fd == -1) {
40002bf0:	85 c0                	test   %eax,%eax
40002bf2:	0f 85 f8 00 00 00    	jne    40002cf0 <_shell_cp+0x200>
40002bf8:	83 fb ff             	cmp    $0xffffffff,%ebx
40002bfb:	0f 84 ef 00 00 00    	je     40002cf0 <_shell_cp+0x200>
	asm volatile("int %2"
40002c01:	b8 06 00 00 00       	mov    $0x6,%eax
40002c06:	cd 30                	int    $0x30
        if (is_dir(dest_path)) {
40002c08:	83 ec 0c             	sub    $0xc,%esp
40002c0b:	ff 75 08             	push   0x8(%ebp)
40002c0e:	e8 2d f8 ff ff       	call   40002440 <is_dir>
40002c13:	83 c4 10             	add    $0x10,%esp
40002c16:	85 c0                	test   %eax,%eax
40002c18:	0f 84 62 02 00 00    	je     40002e80 <_shell_cp+0x390>
          extract_filename(src_path, filename);
40002c1e:	83 ec 08             	sub    $0x8,%esp
40002c21:	8d b5 e8 fb ff ff    	lea    -0x418(%ebp),%esi
          strcpy(path, dest_path);
40002c27:	8d 9d e8 f3 ff ff    	lea    -0xc18(%ebp),%ebx
          extract_filename(src_path, filename);
40002c2d:	56                   	push   %esi
40002c2e:	57                   	push   %edi
40002c2f:	e8 3c fe ff ff       	call   40002a70 <extract_filename>
          strcpy(path, dest_path);
40002c34:	58                   	pop    %eax
40002c35:	5a                   	pop    %edx
40002c36:	ff 75 08             	push   0x8(%ebp)
40002c39:	53                   	push   %ebx
40002c3a:	e8 11 e0 ff ff       	call   40000c50 <strcpy>
          p = path + strlen(path);
40002c3f:	89 1c 24             	mov    %ebx,(%esp)
40002c42:	e8 b9 df ff ff       	call   40000c00 <strlen>
          *(p++) = '/';
40002c47:	c6 04 03 2f          	movb   $0x2f,(%ebx,%eax,1)
40002c4b:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
          strcpy(p, filename);
40002c4f:	59                   	pop    %ecx
40002c50:	5a                   	pop    %edx
40002c51:	56                   	push   %esi
40002c52:	50                   	push   %eax
40002c53:	e8 f8 df ff ff       	call   40000c50 <strcpy>
          _shell_cp(path, src_path, isRecursive);
40002c58:	83 c4 0c             	add    $0xc,%esp
40002c5b:	ff 75 10             	push   0x10(%ebp)
40002c5e:	57                   	push   %edi
40002c5f:	53                   	push   %ebx
40002c60:	e8 8b fe ff ff       	call   40002af0 <_shell_cp>
40002c65:	83 c4 10             	add    $0x10,%esp
40002c68:	eb 17                	jmp    40002c81 <_shell_cp+0x191>
40002c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf("cp: %s does not exist.\n", src_path);
40002c70:	83 ec 08             	sub    $0x8,%esp
40002c73:	57                   	push   %edi
40002c74:	68 ed 37 00 40       	push   $0x400037ed
40002c79:	e8 e2 d7 ff ff       	call   40000460 <printf>
    return 0;
40002c7e:	83 c4 10             	add    $0x10,%esp
}
40002c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002c84:	31 c0                	xor    %eax,%eax
40002c86:	5b                   	pop    %ebx
40002c87:	5e                   	pop    %esi
40002c88:	5f                   	pop    %edi
40002c89:	5d                   	pop    %ebp
40002c8a:	c3                   	ret
40002c8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      _shell_cp(dest_path, src_path, 0);
40002c90:	83 ec 04             	sub    $0x4,%esp
40002c93:	6a 00                	push   $0x0
40002c95:	57                   	push   %edi
40002c96:	ff 75 08             	push   0x8(%ebp)
40002c99:	e8 52 fe ff ff       	call   40002af0 <_shell_cp>
40002c9e:	83 c4 10             	add    $0x10,%esp
}
40002ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002ca4:	31 c0                	xor    %eax,%eax
40002ca6:	5b                   	pop    %ebx
40002ca7:	5e                   	pop    %esi
40002ca8:	5f                   	pop    %edi
40002ca9:	5d                   	pop    %ebp
40002caa:	c3                   	ret
40002cab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  unsigned int len = strlen(path);
40002cb0:	83 ec 0c             	sub    $0xc,%esp
40002cb3:	ff 75 08             	push   0x8(%ebp)
40002cb6:	e8 45 df ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40002cbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  unsigned int len = strlen(path);
40002cbe:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002cc0:	b8 0a 00 00 00       	mov    $0xa,%eax
40002cc5:	cd 30                	int    $0x30
    return 0;
40002cc7:	83 c4 10             	add    $0x10,%esp
40002cca:	eb b5                	jmp    40002c81 <_shell_cp+0x191>
40002ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf("cp: omitting directory '%s'. try '-r' ?\n", src_path);
40002cd0:	83 ec 08             	sub    $0x8,%esp
40002cd3:	57                   	push   %edi
40002cd4:	68 58 3f 00 40       	push   $0x40003f58
40002cd9:	e8 82 d7 ff ff       	call   40000460 <printf>
      return 0;
40002cde:	83 c4 10             	add    $0x10,%esp
}
40002ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002ce4:	31 c0                	xor    %eax,%eax
40002ce6:	5b                   	pop    %ebx
40002ce7:	5e                   	pop    %esi
40002ce8:	5f                   	pop    %edi
40002ce9:	5d                   	pop    %ebp
40002cea:	c3                   	ret
40002ceb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  if (is_dir(src_filename)) {
40002cf0:	83 ec 0c             	sub    $0xc,%esp
40002cf3:	57                   	push   %edi
40002cf4:	e8 47 f7 ff ff       	call   40002440 <is_dir>
40002cf9:	83 c4 10             	add    $0x10,%esp
40002cfc:	85 c0                	test   %eax,%eax
40002cfe:	0f 85 9c 01 00 00    	jne    40002ea0 <_shell_cp+0x3b0>
40002d04:	8b 45 08             	mov    0x8(%ebp),%eax
40002d07:	89 fa                	mov    %edi,%edx
40002d09:	e8 82 ed ff ff       	call   40001a90 <cp_file.part.0>
        int len = ls_dir(path, src_path);
40002d0e:	83 ec 08             	sub    $0x8,%esp
40002d11:	8d b5 e8 f3 ff ff    	lea    -0xc18(%ebp),%esi
40002d17:	57                   	push   %edi
        char *p = path;
40002d18:	89 f3                	mov    %esi,%ebx
        int len = ls_dir(path, src_path);
40002d1a:	56                   	push   %esi
40002d1b:	e8 30 f6 ff ff       	call   40002350 <ls_dir>
        while (p - path < len) {
40002d20:	83 c4 10             	add    $0x10,%esp
40002d23:	85 c0                	test   %eax,%eax
40002d25:	0f 8e 56 ff ff ff    	jle    40002c81 <_shell_cp+0x191>
40002d2b:	89 7d 0c             	mov    %edi,0xc(%ebp)
40002d2e:	89 c7                	mov    %eax,%edi
          if (strcmp(p, ".") && strcmp(p, "..")) {
40002d30:	83 ec 08             	sub    $0x8,%esp
40002d33:	68 53 37 00 40       	push   $0x40003753
40002d38:	53                   	push   %ebx
40002d39:	e8 d2 df ff ff       	call   40000d10 <strcmp>
40002d3e:	83 c4 10             	add    $0x10,%esp
40002d41:	85 c0                	test   %eax,%eax
40002d43:	75 23                	jne    40002d68 <_shell_cp+0x278>
          p += strlen(p) + 1; //
40002d45:	83 ec 0c             	sub    $0xc,%esp
40002d48:	53                   	push   %ebx
40002d49:	e8 b2 de ff ff       	call   40000c00 <strlen>
        while (p - path < len) {
40002d4e:	83 c4 10             	add    $0x10,%esp
          p += strlen(p) + 1; //
40002d51:	8d 5c 03 01          	lea    0x1(%ebx,%eax,1),%ebx
        while (p - path < len) {
40002d55:	89 d8                	mov    %ebx,%eax
40002d57:	29 f0                	sub    %esi,%eax
40002d59:	39 f8                	cmp    %edi,%eax
40002d5b:	7c d3                	jl     40002d30 <_shell_cp+0x240>
40002d5d:	e9 1f ff ff ff       	jmp    40002c81 <_shell_cp+0x191>
40002d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          if (strcmp(p, ".") && strcmp(p, "..")) {
40002d68:	83 ec 08             	sub    $0x8,%esp
40002d6b:	68 52 37 00 40       	push   $0x40003752
40002d70:	53                   	push   %ebx
40002d71:	e8 9a df ff ff       	call   40000d10 <strcmp>
40002d76:	83 c4 10             	add    $0x10,%esp
40002d79:	85 c0                	test   %eax,%eax
40002d7b:	74 c8                	je     40002d45 <_shell_cp+0x255>
            dest_len = strlen(dest_path);
40002d7d:	83 ec 0c             	sub    $0xc,%esp
40002d80:	ff 75 08             	push   0x8(%ebp)
40002d83:	e8 78 de ff ff       	call   40000c00 <strlen>
40002d88:	89 85 e0 f3 ff ff    	mov    %eax,-0xc20(%ebp)
            src_len = strlen(src_path);
40002d8e:	58                   	pop    %eax
40002d8f:	ff 75 0c             	push   0xc(%ebp)
40002d92:	e8 69 de ff ff       	call   40000c00 <strlen>
40002d97:	89 85 e4 f3 ff ff    	mov    %eax,-0xc1c(%ebp)
            strcpy(dest_path_buf, dest_path);
40002d9d:	5a                   	pop    %edx
40002d9e:	8d 95 e8 f7 ff ff    	lea    -0x818(%ebp),%edx
40002da4:	59                   	pop    %ecx
40002da5:	ff 75 08             	push   0x8(%ebp)
40002da8:	52                   	push   %edx
40002da9:	e8 a2 de ff ff       	call   40000c50 <strcpy>
            strcpy(src_path_buf, src_path);
40002dae:	58                   	pop    %eax
40002daf:	5a                   	pop    %edx
40002db0:	8d 95 e8 fb ff ff    	lea    -0x418(%ebp),%edx
40002db6:	ff 75 0c             	push   0xc(%ebp)
40002db9:	52                   	push   %edx
40002dba:	e8 91 de ff ff       	call   40000c50 <strcpy>
            dest_path_buf[dest_len] = '/';
40002dbf:	8b 8d e0 f3 ff ff    	mov    -0xc20(%ebp),%ecx
            src_path_buf[src_len] = '/';
40002dc5:	8b 85 e4 f3 ff ff    	mov    -0xc1c(%ebp),%eax
            dest_path_buf[dest_len] = '/';
40002dcb:	c6 84 0d e8 f7 ff ff 	movb   $0x2f,-0x818(%ebp,%ecx,1)
40002dd2:	2f 
            src_path_buf[src_len] = '/';
40002dd3:	c6 84 05 e8 fb ff ff 	movb   $0x2f,-0x418(%ebp,%eax,1)
40002dda:	2f 
            strcpy(dest_path_buf + dest_len + 1, p);
40002ddb:	58                   	pop    %eax
40002ddc:	8d 84 0d e9 f7 ff ff 	lea    -0x817(%ebp,%ecx,1),%eax
40002de3:	5a                   	pop    %edx
40002de4:	53                   	push   %ebx
40002de5:	50                   	push   %eax
40002de6:	e8 65 de ff ff       	call   40000c50 <strcpy>
            strcpy(src_path_buf + src_len + 1, p);
40002deb:	59                   	pop    %ecx
40002dec:	58                   	pop    %eax
40002ded:	53                   	push   %ebx
40002dee:	8b 85 e4 f3 ff ff    	mov    -0xc1c(%ebp),%eax
40002df4:	8d 84 05 e9 fb ff ff 	lea    -0x417(%ebp,%eax,1),%eax
40002dfb:	50                   	push   %eax
40002dfc:	e8 4f de ff ff       	call   40000c50 <strcpy>
            _shell_cp(dest_path_buf, src_path_buf, isRecursive);
40002e01:	83 c4 0c             	add    $0xc,%esp
40002e04:	ff 75 10             	push   0x10(%ebp)
40002e07:	8d 95 e8 fb ff ff    	lea    -0x418(%ebp),%edx
40002e0d:	8d 85 e8 f7 ff ff    	lea    -0x818(%ebp),%eax
40002e13:	52                   	push   %edx
40002e14:	50                   	push   %eax
40002e15:	e8 d6 fc ff ff       	call   40002af0 <_shell_cp>
40002e1a:	83 c4 10             	add    $0x10,%esp
40002e1d:	e9 23 ff ff ff       	jmp    40002d45 <_shell_cp+0x255>
40002e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      extract_filename(src_path, filename);
40002e28:	83 ec 08             	sub    $0x8,%esp
40002e2b:	8d b5 e8 fb ff ff    	lea    -0x418(%ebp),%esi
40002e31:	56                   	push   %esi
40002e32:	57                   	push   %edi
40002e33:	e8 38 fc ff ff       	call   40002a70 <extract_filename>
      strcpy(path, dest_path);
40002e38:	59                   	pop    %ecx
40002e39:	5b                   	pop    %ebx
40002e3a:	8d 9d e8 f3 ff ff    	lea    -0xc18(%ebp),%ebx
40002e40:	ff 75 08             	push   0x8(%ebp)
40002e43:	53                   	push   %ebx
40002e44:	e8 07 de ff ff       	call   40000c50 <strcpy>
      p = path + strlen(path);
40002e49:	89 1c 24             	mov    %ebx,(%esp)
40002e4c:	e8 af dd ff ff       	call   40000c00 <strlen>
      *(p++) = '/';
40002e51:	c6 04 03 2f          	movb   $0x2f,(%ebx,%eax,1)
40002e55:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
      strcpy(p, filename);
40002e59:	5a                   	pop    %edx
40002e5a:	59                   	pop    %ecx
40002e5b:	56                   	push   %esi
40002e5c:	50                   	push   %eax
40002e5d:	e8 ee dd ff ff       	call   40000c50 <strcpy>
      _shell_cp(path, src_path, isRecursive);
40002e62:	83 c4 0c             	add    $0xc,%esp
40002e65:	6a 00                	push   $0x0
40002e67:	57                   	push   %edi
40002e68:	53                   	push   %ebx
40002e69:	e8 82 fc ff ff       	call   40002af0 <_shell_cp>
40002e6e:	83 c4 10             	add    $0x10,%esp
40002e71:	e9 0b fe ff ff       	jmp    40002c81 <_shell_cp+0x191>
40002e76:	66 90                	xchg   %ax,%ax
40002e78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40002e7f:	00 
          printf("cp: can not copy a dir to a file '%s'.\n", dest_path);
40002e80:	83 ec 08             	sub    $0x8,%esp
40002e83:	ff 75 08             	push   0x8(%ebp)
40002e86:	68 84 3f 00 40       	push   $0x40003f84
40002e8b:	e8 d0 d5 ff ff       	call   40000460 <printf>
          return 0;
40002e90:	83 c4 10             	add    $0x10,%esp
40002e93:	e9 e9 fd ff ff       	jmp    40002c81 <_shell_cp+0x191>
40002e98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40002e9f:	00 
  unsigned int len = strlen(path);
40002ea0:	83 ec 0c             	sub    $0xc,%esp
40002ea3:	ff 75 08             	push   0x8(%ebp)
40002ea6:	e8 55 dd ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40002eab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  unsigned int len = strlen(path);
40002eae:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002eb0:	b8 0a 00 00 00       	mov    $0xa,%eax
40002eb5:	cd 30                	int    $0x30
    return 0;
40002eb7:	83 c4 10             	add    $0x10,%esp
40002eba:	e9 4f fe ff ff       	jmp    40002d0e <_shell_cp+0x21e>
40002ebf:	90                   	nop

40002ec0 <shell_cp>:
int shell_cp(int argc, char **argv) {
40002ec0:	55                   	push   %ebp
40002ec1:	89 e5                	mov    %esp,%ebp
40002ec3:	83 ec 08             	sub    $0x8,%esp
40002ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  if (argc < 3) {
40002ec9:	83 f8 02             	cmp    $0x2,%eax
40002ecc:	7e 5a                	jle    40002f28 <shell_cp+0x68>
  } else if (argc > 4) {
40002ece:	83 f8 04             	cmp    $0x4,%eax
40002ed1:	7f 6d                	jg     40002f40 <shell_cp+0x80>
    src_path = argv[1];
40002ed3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40002ed6:	8b 51 04             	mov    0x4(%ecx),%edx
  if (argc == 3) {
40002ed9:	83 f8 03             	cmp    $0x3,%eax
40002edc:	74 7a                	je     40002f58 <shell_cp+0x98>
    if (strcmp(argv[1], "-r")) {
40002ede:	83 ec 08             	sub    $0x8,%esp
40002ee1:	68 69 37 00 40       	push   $0x40003769
40002ee6:	52                   	push   %edx
40002ee7:	e8 24 de ff ff       	call   40000d10 <strcmp>
40002eec:	83 c4 10             	add    $0x10,%esp
40002eef:	85 c0                	test   %eax,%eax
40002ef1:	75 1d                	jne    40002f10 <shell_cp+0x50>
    _shell_cp(dest_path, src_path, 1);
40002ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
40002ef6:	83 ec 04             	sub    $0x4,%esp
40002ef9:	6a 01                	push   $0x1
40002efb:	ff 70 08             	push   0x8(%eax)
40002efe:	ff 70 0c             	push   0xc(%eax)
40002f01:	e8 ea fb ff ff       	call   40002af0 <_shell_cp>
    return 0;
40002f06:	83 c4 10             	add    $0x10,%esp
}
40002f09:	31 c0                	xor    %eax,%eax
40002f0b:	c9                   	leave
40002f0c:	c3                   	ret
40002f0d:	8d 76 00             	lea    0x0(%esi),%esi
      printf("cp: invalid option. try '-r' ?\n");
40002f10:	83 ec 0c             	sub    $0xc,%esp
40002f13:	68 ac 3f 00 40       	push   $0x40003fac
40002f18:	e8 43 d5 ff ff       	call   40000460 <printf>
      return 0;
40002f1d:	83 c4 10             	add    $0x10,%esp
}
40002f20:	31 c0                	xor    %eax,%eax
40002f22:	c9                   	leave
40002f23:	c3                   	ret
40002f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf("cp: too few arguments.\n");
40002f28:	83 ec 0c             	sub    $0xc,%esp
40002f2b:	68 05 38 00 40       	push   $0x40003805
40002f30:	e8 2b d5 ff ff       	call   40000460 <printf>
    return 0;
40002f35:	83 c4 10             	add    $0x10,%esp
}
40002f38:	31 c0                	xor    %eax,%eax
40002f3a:	c9                   	leave
40002f3b:	c3                   	ret
40002f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf("cp: too many arguments.\n");
40002f40:	83 ec 0c             	sub    $0xc,%esp
40002f43:	68 1d 38 00 40       	push   $0x4000381d
40002f48:	e8 13 d5 ff ff       	call   40000460 <printf>
    return 0;
40002f4d:	83 c4 10             	add    $0x10,%esp
}
40002f50:	31 c0                	xor    %eax,%eax
40002f52:	c9                   	leave
40002f53:	c3                   	ret
40002f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    _shell_cp(dest_path, src_path, 0);
40002f58:	83 ec 04             	sub    $0x4,%esp
40002f5b:	6a 00                	push   $0x0
40002f5d:	52                   	push   %edx
40002f5e:	ff 71 08             	push   0x8(%ecx)
40002f61:	e8 8a fb ff ff       	call   40002af0 <_shell_cp>
    return 0;
40002f66:	83 c4 10             	add    $0x10,%esp
}
40002f69:	31 c0                	xor    %eax,%eax
40002f6b:	c9                   	leave
40002f6c:	c3                   	ret
40002f6d:	8d 76 00             	lea    0x0(%esi),%esi

40002f70 <shell_mv>:
int shell_mv(int argc, char **argv) {
40002f70:	55                   	push   %ebp
40002f71:	89 e5                	mov    %esp,%ebp
40002f73:	57                   	push   %edi
40002f74:	56                   	push   %esi
40002f75:	53                   	push   %ebx
40002f76:	83 ec 0c             	sub    $0xc,%esp
40002f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (argc != 3) {
40002f7c:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
40002f80:	74 1e                	je     40002fa0 <shell_mv+0x30>
    printf("mv: argument invalid.\n");
40002f82:	83 ec 0c             	sub    $0xc,%esp
40002f85:	68 36 38 00 40       	push   $0x40003836
40002f8a:	e8 d1 d4 ff ff       	call   40000460 <printf>
    return 0;
40002f8f:	83 c4 10             	add    $0x10,%esp
}
40002f92:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002f95:	31 c0                	xor    %eax,%eax
40002f97:	5b                   	pop    %ebx
40002f98:	5e                   	pop    %esi
40002f99:	5f                   	pop    %edi
40002f9a:	5d                   	pop    %ebp
40002f9b:	c3                   	ret
40002f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *src = argv[1];
40002fa0:	8b 70 04             	mov    0x4(%eax),%esi
        unsigned int len = strlen(path);
40002fa3:	83 ec 0c             	sub    $0xc,%esp
  char *dest = argv[2];
40002fa6:	8b 78 08             	mov    0x8(%eax),%edi
40002fa9:	56                   	push   %esi
	asm volatile("int %2"
40002faa:	89 f3                	mov    %esi,%ebx
        unsigned int len = strlen(path);
40002fac:	e8 4f dc ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40002fb1:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40002fb3:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002fb5:	b8 05 00 00 00       	mov    $0x5,%eax
40002fba:	cd 30                	int    $0x30
  if (fd == -1) {
40002fbc:	83 c4 10             	add    $0x10,%esp
40002fbf:	83 fb ff             	cmp    $0xffffffff,%ebx
40002fc2:	0f 84 d8 00 00 00    	je     400030a0 <shell_mv+0x130>
40002fc8:	85 c0                	test   %eax,%eax
40002fca:	0f 85 d0 00 00 00    	jne    400030a0 <shell_mv+0x130>
	asm volatile("int %2"
40002fd0:	b8 06 00 00 00       	mov    $0x6,%eax
40002fd5:	cd 30                	int    $0x30
  if (is_dir(src)) {
40002fd7:	83 ec 0c             	sub    $0xc,%esp
40002fda:	56                   	push   %esi
40002fdb:	e8 60 f4 ff ff       	call   40002440 <is_dir>
40002fe0:	83 c4 10             	add    $0x10,%esp
40002fe3:	85 c0                	test   %eax,%eax
40002fe5:	74 69                	je     40003050 <shell_mv+0xe0>
        unsigned int len = strlen(path);
40002fe7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002fea:	89 fb                	mov    %edi,%ebx
        unsigned int len = strlen(path);
40002fec:	57                   	push   %edi
40002fed:	e8 0e dc ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
40002ff2:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40002ff4:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002ff6:	b8 05 00 00 00       	mov    $0x5,%eax
40002ffb:	cd 30                	int    $0x30
  if (fd == -1) {
40002ffd:	83 c4 10             	add    $0x10,%esp
40003000:	83 fb ff             	cmp    $0xffffffff,%ebx
40003003:	74 1f                	je     40003024 <shell_mv+0xb4>
40003005:	85 c0                	test   %eax,%eax
40003007:	75 1b                	jne    40003024 <shell_mv+0xb4>
	asm volatile("int %2"
40003009:	b8 06 00 00 00       	mov    $0x6,%eax
4000300e:	cd 30                	int    $0x30
    if (is_file_exist(dest) && !is_dir(dest)) {
40003010:	83 ec 0c             	sub    $0xc,%esp
40003013:	57                   	push   %edi
40003014:	e8 27 f4 ff ff       	call   40002440 <is_dir>
40003019:	83 c4 10             	add    $0x10,%esp
4000301c:	85 c0                	test   %eax,%eax
4000301e:	0f 84 9c 00 00 00    	je     400030c0 <shell_mv+0x150>
    _shell_cp(dest, src, 1);
40003024:	83 ec 04             	sub    $0x4,%esp
40003027:	6a 01                	push   $0x1
40003029:	56                   	push   %esi
4000302a:	57                   	push   %edi
4000302b:	e8 c0 fa ff ff       	call   40002af0 <_shell_cp>
  if (isRecursive) {
40003030:	89 f0                	mov    %esi,%eax
40003032:	ba 01 00 00 00       	mov    $0x1,%edx
40003037:	e8 24 f5 ff ff       	call   40002560 <_shell_rm.part.0>
4000303c:	83 c4 10             	add    $0x10,%esp
}
4000303f:	8d 65 f4             	lea    -0xc(%ebp),%esp
40003042:	31 c0                	xor    %eax,%eax
40003044:	5b                   	pop    %ebx
40003045:	5e                   	pop    %esi
40003046:	5f                   	pop    %edi
40003047:	5d                   	pop    %ebp
40003048:	c3                   	ret
40003049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    _shell_cp(dest, src, 1);
40003050:	83 ec 04             	sub    $0x4,%esp
40003053:	6a 01                	push   $0x1
40003055:	56                   	push   %esi
40003056:	57                   	push   %edi
40003057:	e8 94 fa ff ff       	call   40002af0 <_shell_cp>
    if (is_dir(path)) {
4000305c:	89 34 24             	mov    %esi,(%esp)
4000305f:	e8 dc f3 ff ff       	call   40002440 <is_dir>
40003064:	83 c4 10             	add    $0x10,%esp
40003067:	85 c0                	test   %eax,%eax
40003069:	75 6a                	jne    400030d5 <shell_mv+0x165>
  unsigned int len = strlen(path);
4000306b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
4000306e:	89 f3                	mov    %esi,%ebx
  unsigned int len = strlen(path);
40003070:	56                   	push   %esi
40003071:	e8 8a db ff ff       	call   40000c00 <strlen>
40003076:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40003078:	b8 0d 00 00 00       	mov    $0xd,%eax
4000307d:	cd 30                	int    $0x30
	return errno ? -1 : 0;
4000307f:	83 c4 10             	add    $0x10,%esp
40003082:	85 c0                	test   %eax,%eax
40003084:	0f 84 08 ff ff ff    	je     40002f92 <shell_mv+0x22>
    printf("rm: can not remove %s: sys_unlink error.\n", filename);
4000308a:	83 ec 08             	sub    $0x8,%esp
4000308d:	56                   	push   %esi
4000308e:	68 b8 3d 00 40       	push   $0x40003db8
40003093:	e8 c8 d3 ff ff       	call   40000460 <printf>
40003098:	83 c4 10             	add    $0x10,%esp
4000309b:	e9 f2 fe ff ff       	jmp    40002f92 <shell_mv+0x22>
    printf("mv: sorce file %s does not exist.\n", src);
400030a0:	83 ec 08             	sub    $0x8,%esp
400030a3:	56                   	push   %esi
400030a4:	68 cc 3f 00 40       	push   $0x40003fcc
400030a9:	e8 b2 d3 ff ff       	call   40000460 <printf>
    return 0;
400030ae:	83 c4 10             	add    $0x10,%esp
}
400030b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
400030b4:	31 c0                	xor    %eax,%eax
400030b6:	5b                   	pop    %ebx
400030b7:	5e                   	pop    %esi
400030b8:	5f                   	pop    %edi
400030b9:	5d                   	pop    %ebp
400030ba:	c3                   	ret
400030bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      printf("mv: cannot move a dir to a file\n");
400030c0:	83 ec 0c             	sub    $0xc,%esp
400030c3:	68 f0 3f 00 40       	push   $0x40003ff0
400030c8:	e8 93 d3 ff ff       	call   40000460 <printf>
      return 0;
400030cd:	83 c4 10             	add    $0x10,%esp
400030d0:	e9 bd fe ff ff       	jmp    40002f92 <shell_mv+0x22>
      printf("rm: can not remove %s: is a directory. try '-r' ?\n", path);
400030d5:	83 ec 08             	sub    $0x8,%esp
400030d8:	56                   	push   %esi
400030d9:	68 e4 3d 00 40       	push   $0x40003de4
400030de:	e8 7d d3 ff ff       	call   40000460 <printf>
      return -1;
400030e3:	83 c4 10             	add    $0x10,%esp
400030e6:	e9 a7 fe ff ff       	jmp    40002f92 <shell_mv+0x22>
400030eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

400030f0 <cp_file>:
int cp_file(char *dest_filename, char *src_filename) {
400030f0:	55                   	push   %ebp
400030f1:	89 e5                	mov    %esp,%ebp
400030f3:	53                   	push   %ebx
400030f4:	83 ec 10             	sub    $0x10,%esp
  if (is_dir(src_filename)) {
400030f7:	ff 75 0c             	push   0xc(%ebp)
400030fa:	e8 41 f3 ff ff       	call   40002440 <is_dir>
400030ff:	83 c4 10             	add    $0x10,%esp
40003102:	85 c0                	test   %eax,%eax
40003104:	75 1a                	jne    40003120 <cp_file+0x30>
40003106:	8b 45 08             	mov    0x8(%ebp),%eax
40003109:	8b 55 0c             	mov    0xc(%ebp),%edx
4000310c:	e8 7f e9 ff ff       	call   40001a90 <cp_file.part.0>
}
40003111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40003114:	31 c0                	xor    %eax,%eax
40003116:	c9                   	leave
40003117:	c3                   	ret
40003118:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000311f:	00 
  unsigned int len = strlen(path);
40003120:	83 ec 0c             	sub    $0xc,%esp
40003123:	ff 75 08             	push   0x8(%ebp)
40003126:	e8 d5 da ff ff       	call   40000c00 <strlen>
	asm volatile("int %2"
4000312b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  unsigned int len = strlen(path);
4000312e:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40003130:	b8 0a 00 00 00       	mov    $0xa,%eax
40003135:	cd 30                	int    $0x30
40003137:	31 c0                	xor    %eax,%eax
40003139:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
4000313c:	83 c4 10             	add    $0x10,%esp
}
4000313f:	c9                   	leave
40003140:	c3                   	ret
40003141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40003148:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000314f:	00 

40003150 <shell_readline>:
void shell_readline(char *buf) { sys_readline(buf); }
40003150:	55                   	push   %ebp
	asm volatile("int %2"
40003151:	b8 07 00 00 00       	mov    $0x7,%eax
40003156:	ba 00 04 00 00       	mov    $0x400,%edx
4000315b:	89 e5                	mov    %esp,%ebp
4000315d:	53                   	push   %ebx
4000315e:	31 db                	xor    %ebx,%ebx
40003160:	8b 4d 08             	mov    0x8(%ebp),%ecx
40003163:	cd 30                	int    $0x30
	if (n > 0) {
40003165:	85 db                	test   %ebx,%ebx
40003167:	7e 08                	jle    40003171 <shell_readline+0x21>
40003169:	85 c0                	test   %eax,%eax
4000316b:	75 04                	jne    40003171 <shell_readline+0x21>
		buf[n] = '\0';
4000316d:	c6 04 19 00          	movb   $0x0,(%ecx,%ebx,1)
40003171:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40003174:	c9                   	leave
40003175:	c3                   	ret
40003176:	66 90                	xchg   %ax,%ax
40003178:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000317f:	00 

40003180 <ipc_test>:
int ipc_test() {
40003180:	55                   	push   %ebp
40003181:	89 e5                	mov    %esp,%ebp
40003183:	83 ec 14             	sub    $0x14,%esp
  printf("ipc test begin\n");
40003186:	68 4d 38 00 40       	push   $0x4000384d
4000318b:	e8 d0 d2 ff ff       	call   40000460 <printf>
  if ((ping_pid = spawn(1, 1000)) != -1)
40003190:	58                   	pop    %eax
40003191:	5a                   	pop    %edx
40003192:	68 e8 03 00 00       	push   $0x3e8
40003197:	6a 01                	push   $0x1
40003199:	e8 52 d9 ff ff       	call   40000af0 <spawn>
4000319e:	83 c4 10             	add    $0x10,%esp
400031a1:	83 f8 ff             	cmp    $0xffffffff,%eax
400031a4:	74 4a                	je     400031f0 <ipc_test+0x70>
    printf("ping in process %d.\n", ping_pid);
400031a6:	83 ec 08             	sub    $0x8,%esp
400031a9:	50                   	push   %eax
400031aa:	68 5d 38 00 40       	push   $0x4000385d
400031af:	e8 ac d2 ff ff       	call   40000460 <printf>
400031b4:	83 c4 10             	add    $0x10,%esp
  if ((pong_pid = spawn(2, 1000)) != -1)
400031b7:	83 ec 08             	sub    $0x8,%esp
400031ba:	68 e8 03 00 00       	push   $0x3e8
400031bf:	6a 02                	push   $0x2
400031c1:	e8 2a d9 ff ff       	call   40000af0 <spawn>
400031c6:	83 c4 10             	add    $0x10,%esp
400031c9:	83 f8 ff             	cmp    $0xffffffff,%eax
400031cc:	74 3a                	je     40003208 <ipc_test+0x88>
    printf("pong in process %d.\n", pong_pid);
400031ce:	83 ec 08             	sub    $0x8,%esp
400031d1:	50                   	push   %eax
400031d2:	68 8a 38 00 40       	push   $0x4000388a
400031d7:	e8 84 d2 ff ff       	call   40000460 <printf>
400031dc:	83 c4 10             	add    $0x10,%esp
  printf("ipc test pass!!\n");
400031df:	83 ec 0c             	sub    $0xc,%esp
400031e2:	68 b7 38 00 40       	push   $0x400038b7
400031e7:	e8 74 d2 ff ff       	call   40000460 <printf>
}
400031ec:	31 c0                	xor    %eax,%eax
400031ee:	c9                   	leave
400031ef:	c3                   	ret
    printf("Failed to launch ping.\n");
400031f0:	83 ec 0c             	sub    $0xc,%esp
400031f3:	68 72 38 00 40       	push   $0x40003872
400031f8:	e8 63 d2 ff ff       	call   40000460 <printf>
400031fd:	83 c4 10             	add    $0x10,%esp
40003200:	eb b5                	jmp    400031b7 <ipc_test+0x37>
40003202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf("Failed to launch pong.\n");
40003208:	83 ec 0c             	sub    $0xc,%esp
4000320b:	68 9f 38 00 40       	push   $0x4000389f
40003210:	e8 4b d2 ff ff       	call   40000460 <printf>
40003215:	83 c4 10             	add    $0x10,%esp
40003218:	eb c5                	jmp    400031df <ipc_test+0x5f>
4000321a:	66 90                	xchg   %ax,%ax
4000321c:	66 90                	xchg   %ax,%ax
4000321e:	66 90                	xchg   %ax,%ax

40003220 <__udivdi3>:
40003220:	55                   	push   %ebp
40003221:	89 e5                	mov    %esp,%ebp
40003223:	57                   	push   %edi
40003224:	56                   	push   %esi
40003225:	53                   	push   %ebx
40003226:	83 ec 1c             	sub    $0x1c,%esp
40003229:	8b 75 08             	mov    0x8(%ebp),%esi
4000322c:	8b 45 14             	mov    0x14(%ebp),%eax
4000322f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40003232:	8b 7d 10             	mov    0x10(%ebp),%edi
40003235:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40003238:	85 c0                	test   %eax,%eax
4000323a:	75 1c                	jne    40003258 <__udivdi3+0x38>
4000323c:	39 fb                	cmp    %edi,%ebx
4000323e:	73 50                	jae    40003290 <__udivdi3+0x70>
40003240:	89 f0                	mov    %esi,%eax
40003242:	31 f6                	xor    %esi,%esi
40003244:	89 da                	mov    %ebx,%edx
40003246:	f7 f7                	div    %edi
40003248:	89 f2                	mov    %esi,%edx
4000324a:	83 c4 1c             	add    $0x1c,%esp
4000324d:	5b                   	pop    %ebx
4000324e:	5e                   	pop    %esi
4000324f:	5f                   	pop    %edi
40003250:	5d                   	pop    %ebp
40003251:	c3                   	ret
40003252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40003258:	39 c3                	cmp    %eax,%ebx
4000325a:	73 14                	jae    40003270 <__udivdi3+0x50>
4000325c:	31 f6                	xor    %esi,%esi
4000325e:	31 c0                	xor    %eax,%eax
40003260:	89 f2                	mov    %esi,%edx
40003262:	83 c4 1c             	add    $0x1c,%esp
40003265:	5b                   	pop    %ebx
40003266:	5e                   	pop    %esi
40003267:	5f                   	pop    %edi
40003268:	5d                   	pop    %ebp
40003269:	c3                   	ret
4000326a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40003270:	0f bd f0             	bsr    %eax,%esi
40003273:	83 f6 1f             	xor    $0x1f,%esi
40003276:	75 48                	jne    400032c0 <__udivdi3+0xa0>
40003278:	39 d8                	cmp    %ebx,%eax
4000327a:	72 07                	jb     40003283 <__udivdi3+0x63>
4000327c:	31 c0                	xor    %eax,%eax
4000327e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
40003281:	72 dd                	jb     40003260 <__udivdi3+0x40>
40003283:	b8 01 00 00 00       	mov    $0x1,%eax
40003288:	eb d6                	jmp    40003260 <__udivdi3+0x40>
4000328a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40003290:	89 f9                	mov    %edi,%ecx
40003292:	85 ff                	test   %edi,%edi
40003294:	75 0b                	jne    400032a1 <__udivdi3+0x81>
40003296:	b8 01 00 00 00       	mov    $0x1,%eax
4000329b:	31 d2                	xor    %edx,%edx
4000329d:	f7 f7                	div    %edi
4000329f:	89 c1                	mov    %eax,%ecx
400032a1:	31 d2                	xor    %edx,%edx
400032a3:	89 d8                	mov    %ebx,%eax
400032a5:	f7 f1                	div    %ecx
400032a7:	89 c6                	mov    %eax,%esi
400032a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400032ac:	f7 f1                	div    %ecx
400032ae:	89 f2                	mov    %esi,%edx
400032b0:	83 c4 1c             	add    $0x1c,%esp
400032b3:	5b                   	pop    %ebx
400032b4:	5e                   	pop    %esi
400032b5:	5f                   	pop    %edi
400032b6:	5d                   	pop    %ebp
400032b7:	c3                   	ret
400032b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400032bf:	00 
400032c0:	89 f1                	mov    %esi,%ecx
400032c2:	ba 20 00 00 00       	mov    $0x20,%edx
400032c7:	29 f2                	sub    %esi,%edx
400032c9:	d3 e0                	shl    %cl,%eax
400032cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
400032ce:	89 d1                	mov    %edx,%ecx
400032d0:	89 f8                	mov    %edi,%eax
400032d2:	d3 e8                	shr    %cl,%eax
400032d4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
400032d7:	09 c1                	or     %eax,%ecx
400032d9:	89 d8                	mov    %ebx,%eax
400032db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
400032de:	89 f1                	mov    %esi,%ecx
400032e0:	d3 e7                	shl    %cl,%edi
400032e2:	89 d1                	mov    %edx,%ecx
400032e4:	d3 e8                	shr    %cl,%eax
400032e6:	89 f1                	mov    %esi,%ecx
400032e8:	89 7d dc             	mov    %edi,-0x24(%ebp)
400032eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
400032ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400032f1:	d3 e3                	shl    %cl,%ebx
400032f3:	89 d1                	mov    %edx,%ecx
400032f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
400032f8:	d3 e8                	shr    %cl,%eax
400032fa:	09 d8                	or     %ebx,%eax
400032fc:	f7 75 e0             	divl   -0x20(%ebp)
400032ff:	89 d3                	mov    %edx,%ebx
40003301:	89 c7                	mov    %eax,%edi
40003303:	f7 65 dc             	mull   -0x24(%ebp)
40003306:	89 45 e0             	mov    %eax,-0x20(%ebp)
40003309:	39 d3                	cmp    %edx,%ebx
4000330b:	72 23                	jb     40003330 <__udivdi3+0x110>
4000330d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40003310:	89 f1                	mov    %esi,%ecx
40003312:	d3 e0                	shl    %cl,%eax
40003314:	3b 45 e0             	cmp    -0x20(%ebp),%eax
40003317:	73 04                	jae    4000331d <__udivdi3+0xfd>
40003319:	39 d3                	cmp    %edx,%ebx
4000331b:	74 13                	je     40003330 <__udivdi3+0x110>
4000331d:	89 f8                	mov    %edi,%eax
4000331f:	31 f6                	xor    %esi,%esi
40003321:	e9 3a ff ff ff       	jmp    40003260 <__udivdi3+0x40>
40003326:	66 90                	xchg   %ax,%ax
40003328:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000332f:	00 
40003330:	8d 47 ff             	lea    -0x1(%edi),%eax
40003333:	31 f6                	xor    %esi,%esi
40003335:	e9 26 ff ff ff       	jmp    40003260 <__udivdi3+0x40>
4000333a:	66 90                	xchg   %ax,%ax
4000333c:	66 90                	xchg   %ax,%ax
4000333e:	66 90                	xchg   %ax,%ax

40003340 <__umoddi3>:
40003340:	55                   	push   %ebp
40003341:	89 e5                	mov    %esp,%ebp
40003343:	57                   	push   %edi
40003344:	56                   	push   %esi
40003345:	53                   	push   %ebx
40003346:	83 ec 2c             	sub    $0x2c,%esp
40003349:	8b 5d 0c             	mov    0xc(%ebp),%ebx
4000334c:	8b 45 14             	mov    0x14(%ebp),%eax
4000334f:	8b 75 08             	mov    0x8(%ebp),%esi
40003352:	8b 7d 10             	mov    0x10(%ebp),%edi
40003355:	89 da                	mov    %ebx,%edx
40003357:	85 c0                	test   %eax,%eax
40003359:	75 15                	jne    40003370 <__umoddi3+0x30>
4000335b:	39 fb                	cmp    %edi,%ebx
4000335d:	73 51                	jae    400033b0 <__umoddi3+0x70>
4000335f:	89 f0                	mov    %esi,%eax
40003361:	f7 f7                	div    %edi
40003363:	89 d0                	mov    %edx,%eax
40003365:	31 d2                	xor    %edx,%edx
40003367:	83 c4 2c             	add    $0x2c,%esp
4000336a:	5b                   	pop    %ebx
4000336b:	5e                   	pop    %esi
4000336c:	5f                   	pop    %edi
4000336d:	5d                   	pop    %ebp
4000336e:	c3                   	ret
4000336f:	90                   	nop
40003370:	89 75 e0             	mov    %esi,-0x20(%ebp)
40003373:	39 c3                	cmp    %eax,%ebx
40003375:	73 11                	jae    40003388 <__umoddi3+0x48>
40003377:	89 f0                	mov    %esi,%eax
40003379:	83 c4 2c             	add    $0x2c,%esp
4000337c:	5b                   	pop    %ebx
4000337d:	5e                   	pop    %esi
4000337e:	5f                   	pop    %edi
4000337f:	5d                   	pop    %ebp
40003380:	c3                   	ret
40003381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40003388:	0f bd c8             	bsr    %eax,%ecx
4000338b:	83 f1 1f             	xor    $0x1f,%ecx
4000338e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
40003391:	75 3d                	jne    400033d0 <__umoddi3+0x90>
40003393:	39 d8                	cmp    %ebx,%eax
40003395:	0f 82 cd 00 00 00    	jb     40003468 <__umoddi3+0x128>
4000339b:	39 fe                	cmp    %edi,%esi
4000339d:	0f 83 c5 00 00 00    	jae    40003468 <__umoddi3+0x128>
400033a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
400033a6:	83 c4 2c             	add    $0x2c,%esp
400033a9:	5b                   	pop    %ebx
400033aa:	5e                   	pop    %esi
400033ab:	5f                   	pop    %edi
400033ac:	5d                   	pop    %ebp
400033ad:	c3                   	ret
400033ae:	66 90                	xchg   %ax,%ax
400033b0:	89 f9                	mov    %edi,%ecx
400033b2:	85 ff                	test   %edi,%edi
400033b4:	75 0b                	jne    400033c1 <__umoddi3+0x81>
400033b6:	b8 01 00 00 00       	mov    $0x1,%eax
400033bb:	31 d2                	xor    %edx,%edx
400033bd:	f7 f7                	div    %edi
400033bf:	89 c1                	mov    %eax,%ecx
400033c1:	89 d8                	mov    %ebx,%eax
400033c3:	31 d2                	xor    %edx,%edx
400033c5:	f7 f1                	div    %ecx
400033c7:	89 f0                	mov    %esi,%eax
400033c9:	f7 f1                	div    %ecx
400033cb:	eb 96                	jmp    40003363 <__umoddi3+0x23>
400033cd:	8d 76 00             	lea    0x0(%esi),%esi
400033d0:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400033d4:	ba 20 00 00 00       	mov    $0x20,%edx
400033d9:	2b 55 e4             	sub    -0x1c(%ebp),%edx
400033dc:	89 55 e0             	mov    %edx,-0x20(%ebp)
400033df:	d3 e0                	shl    %cl,%eax
400033e1:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
400033e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
400033e8:	89 f8                	mov    %edi,%eax
400033ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
400033ed:	d3 e8                	shr    %cl,%eax
400033ef:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400033f3:	09 c2                	or     %eax,%edx
400033f5:	d3 e7                	shl    %cl,%edi
400033f7:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
400033fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
400033fe:	89 da                	mov    %ebx,%edx
40003400:	89 7d d8             	mov    %edi,-0x28(%ebp)
40003403:	89 f7                	mov    %esi,%edi
40003405:	d3 ea                	shr    %cl,%edx
40003407:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
4000340b:	d3 e3                	shl    %cl,%ebx
4000340d:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
40003411:	d3 ef                	shr    %cl,%edi
40003413:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40003417:	89 f8                	mov    %edi,%eax
40003419:	d3 e6                	shl    %cl,%esi
4000341b:	09 d8                	or     %ebx,%eax
4000341d:	f7 75 dc             	divl   -0x24(%ebp)
40003420:	89 d3                	mov    %edx,%ebx
40003422:	89 75 d4             	mov    %esi,-0x2c(%ebp)
40003425:	89 f7                	mov    %esi,%edi
40003427:	f7 65 d8             	mull   -0x28(%ebp)
4000342a:	89 c6                	mov    %eax,%esi
4000342c:	89 d1                	mov    %edx,%ecx
4000342e:	39 d3                	cmp    %edx,%ebx
40003430:	72 06                	jb     40003438 <__umoddi3+0xf8>
40003432:	75 0e                	jne    40003442 <__umoddi3+0x102>
40003434:	39 c7                	cmp    %eax,%edi
40003436:	73 0a                	jae    40003442 <__umoddi3+0x102>
40003438:	2b 45 d8             	sub    -0x28(%ebp),%eax
4000343b:	1b 55 dc             	sbb    -0x24(%ebp),%edx
4000343e:	89 d1                	mov    %edx,%ecx
40003440:	89 c6                	mov    %eax,%esi
40003442:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40003445:	29 f0                	sub    %esi,%eax
40003447:	19 cb                	sbb    %ecx,%ebx
40003449:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
4000344d:	89 da                	mov    %ebx,%edx
4000344f:	d3 e2                	shl    %cl,%edx
40003451:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40003455:	d3 e8                	shr    %cl,%eax
40003457:	d3 eb                	shr    %cl,%ebx
40003459:	09 d0                	or     %edx,%eax
4000345b:	89 da                	mov    %ebx,%edx
4000345d:	83 c4 2c             	add    $0x2c,%esp
40003460:	5b                   	pop    %ebx
40003461:	5e                   	pop    %esi
40003462:	5f                   	pop    %edi
40003463:	5d                   	pop    %ebp
40003464:	c3                   	ret
40003465:	8d 76 00             	lea    0x0(%esi),%esi
40003468:	89 da                	mov    %ebx,%edx
4000346a:	29 fe                	sub    %edi,%esi
4000346c:	19 c2                	sbb    %eax,%edx
4000346e:	89 75 e0             	mov    %esi,-0x20(%ebp)
40003471:	e9 2d ff ff ff       	jmp    400033a3 <__umoddi3+0x63>
