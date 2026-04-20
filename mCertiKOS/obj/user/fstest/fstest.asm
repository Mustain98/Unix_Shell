
obj/user/fstest/fstest:     file format elf32-i386


Disassembly of section .text:

40000000 <main>:
}


int
main(int argc, char *argv[])
{
40000000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
40000004:	83 e4 f0             	and    $0xfffffff0,%esp
40000007:	ff 71 fc             	push   -0x4(%ecx)
4000000a:	55                   	push   %ebp
4000000b:	89 e5                	mov    %esp,%ebp
4000000d:	53                   	push   %ebx
sys_open(char *path, int omode)
{
	int errno;
	int fd;
        unsigned int len = strlen(path);
	asm volatile("int %2"
4000000e:	bb a7 3c 00 40       	mov    $0x40003ca7,%ebx
40000013:	51                   	push   %ecx
  printf("*******usertests starting*******\n\n");
40000014:	83 ec 0c             	sub    $0xc,%esp
40000017:	68 b4 42 00 40       	push   $0x400042b4
4000001c:	e8 1f 03 00 00       	call   40000340 <printf>

  printf("=====test file usertests.ran does not exists=====\n");
40000021:	c7 04 24 d8 42 00 40 	movl   $0x400042d8,(%esp)
40000028:	e8 13 03 00 00       	call   40000340 <printf>
        unsigned int len = strlen(path);
4000002d:	c7 04 24 a7 3c 00 40 	movl   $0x40003ca7,(%esp)
40000034:	e8 a7 0a 00 00       	call   40000ae0 <strlen>
	asm volatile("int %2"
40000039:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
4000003b:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
4000003d:	b8 05 00 00 00       	mov    $0x5,%eax
40000042:	cd 30                	int    $0x30

  if(open("usertests.ran", O_RDONLY) >= 0){
40000044:	83 c4 10             	add    $0x10,%esp
40000047:	85 db                	test   %ebx,%ebx
40000049:	78 08                	js     40000053 <main+0x53>
4000004b:	85 c0                	test   %eax,%eax
4000004d:	0f 84 94 00 00 00    	je     400000e7 <main+0xe7>
    printf("already ran user tests (file usertests.ran exists) -- recreate certikos_disk.img\n");
    exit();
  }
  printf("=====test file usertests.ran does not exists: ok\n\n");
40000053:	83 ec 0c             	sub    $0xc,%esp
40000056:	bb a7 3c 00 40       	mov    $0x40003ca7,%ebx
4000005b:	68 60 43 00 40       	push   $0x40004360
40000060:	e8 db 02 00 00       	call   40000340 <printf>
        unsigned int len = strlen(path);
40000065:	c7 04 24 a7 3c 00 40 	movl   $0x40003ca7,(%esp)
4000006c:	e8 6f 0a 00 00       	call   40000ae0 <strlen>
	asm volatile("int %2"
40000071:	b9 00 02 00 00       	mov    $0x200,%ecx
        unsigned int len = strlen(path);
40000076:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40000078:	b8 05 00 00 00       	mov    $0x5,%eax
4000007d:	cd 30                	int    $0x30
4000007f:	89 da                	mov    %ebx,%edx
		       "b" (path),
		       "c" (omode),
                       "d" (len)
		     : "cc", "memory");

	return errno ? -1 : fd;
40000081:	83 c4 10             	add    $0x10,%esp
40000084:	85 c0                	test   %eax,%eax
40000086:	75 71                	jne    400000f9 <main+0xf9>
	asm volatile("int %2"
40000088:	b8 06 00 00 00       	mov    $0x6,%eax
4000008d:	89 d3                	mov    %edx,%ebx
4000008f:	cd 30                	int    $0x30
  close(open("usertests.ran", O_CREATE));

  smallfile();
40000091:	e8 8a 0f 00 00       	call   40001020 <smallfile>
  bigfile1();
40000096:	e8 85 11 00 00       	call   40001220 <bigfile1>
  createtest();
4000009b:	e8 90 13 00 00       	call   40001430 <createtest>

  rmdot();
400000a0:	e8 6b 14 00 00       	call   40001510 <rmdot>
  fourteen();
400000a5:	e8 46 16 00 00       	call   400016f0 <fourteen>
  bigfile2();
400000aa:	e8 01 18 00 00       	call   400018b0 <bigfile2>
  subdir();
400000af:	e8 3c 1a 00 00       	call   40001af0 <subdir>
  linktest();
400000b4:	e8 a7 23 00 00       	call   40002460 <linktest>
  unlinkread();
400000b9:	e8 b2 26 00 00       	call   40002770 <unlinkread>
  dirfile();
400000be:	e8 dd 28 00 00       	call   400029a0 <dirfile>
  iref();
400000c3:	e8 98 2b 00 00       	call   40002c60 <iref>
  bigdir(); // slow
400000c8:	e8 43 2d 00 00       	call   40002e10 <bigdir>
  printf("*******end of tests*******\n");
400000cd:	83 ec 0c             	sub    $0xc,%esp
400000d0:	68 b5 3c 00 40       	push   $0x40003cb5
400000d5:	e8 66 02 00 00       	call   40000340 <printf>
400000da:	83 c4 10             	add    $0x10,%esp
}
400000dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
400000e0:	59                   	pop    %ecx
400000e1:	5b                   	pop    %ebx
400000e2:	5d                   	pop    %ebp
400000e3:	8d 61 fc             	lea    -0x4(%ecx),%esp
400000e6:	c3                   	ret
    printf("already ran user tests (file usertests.ran exists) -- recreate certikos_disk.img\n");
400000e7:	83 ec 0c             	sub    $0xc,%esp
400000ea:	68 0c 43 00 40       	push   $0x4000430c
400000ef:	e8 4c 02 00 00       	call   40000340 <printf>
    exit();
400000f4:	83 c4 10             	add    $0x10,%esp
400000f7:	eb e4                	jmp    400000dd <main+0xdd>
	return errno ? -1 : fd;
400000f9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
400000fe:	eb 88                	jmp    40000088 <main+0x88>

40000100 <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary/
	 */
	testl	$0x0fffffff, %esp
40000100:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
40000106:	75 04                	jne    4000010c <args_exist>

40000108 <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
40000108:	6a 00                	push   $0x0
	pushl	$0
4000010a:	6a 00                	push   $0x0

4000010c <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
4000010c:	e8 ef fe ff ff       	call   40000000 <main>

	/* When returning, save return value */
	pushl	%eax
40000111:	50                   	push   %eax

	/* Syscall SYS_exit (30) */
	movl	$30, %eax
40000112:	b8 1e 00 00 00       	mov    $0x1e,%eax
	int	$48
40000117:	cd 30                	int    $0x30

40000119 <spin>:

spin:
	call	yield
40000119:	e8 12 09 00 00       	call   40000a30 <yield>
	jmp	spin
4000011e:	eb f9                	jmp    40000119 <spin>

40000120 <debug>:
#include <stdarg.h>
#include <stdio.h>

void
debug(const char *file, int line, const char *fmt, ...)
{
40000120:	55                   	push   %ebp
40000121:	89 e5                	mov    %esp,%ebp
40000123:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[D] %s:%d: ", file, line);
40000126:	ff 75 0c             	push   0xc(%ebp)
40000129:	ff 75 08             	push   0x8(%ebp)
4000012c:	68 38 32 00 40       	push   $0x40003238
40000131:	e8 0a 02 00 00       	call   40000340 <printf>
	vcprintf(fmt, ap);
40000136:	58                   	pop    %eax
40000137:	8d 45 14             	lea    0x14(%ebp),%eax
4000013a:	5a                   	pop    %edx
4000013b:	50                   	push   %eax
4000013c:	ff 75 10             	push   0x10(%ebp)
4000013f:	e8 9c 01 00 00       	call   400002e0 <vcprintf>
	va_end(ap);
}
40000144:	83 c4 10             	add    $0x10,%esp
40000147:	c9                   	leave
40000148:	c3                   	ret
40000149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000150 <warn>:

void
warn(const char *file, int line, const char *fmt, ...)
{
40000150:	55                   	push   %ebp
40000151:	89 e5                	mov    %esp,%ebp
40000153:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[W] %s:%d: ", file, line);
40000156:	ff 75 0c             	push   0xc(%ebp)
40000159:	ff 75 08             	push   0x8(%ebp)
4000015c:	68 44 32 00 40       	push   $0x40003244
40000161:	e8 da 01 00 00       	call   40000340 <printf>
	vcprintf(fmt, ap);
40000166:	58                   	pop    %eax
40000167:	8d 45 14             	lea    0x14(%ebp),%eax
4000016a:	5a                   	pop    %edx
4000016b:	50                   	push   %eax
4000016c:	ff 75 10             	push   0x10(%ebp)
4000016f:	e8 6c 01 00 00       	call   400002e0 <vcprintf>
	va_end(ap);
}
40000174:	83 c4 10             	add    $0x10,%esp
40000177:	c9                   	leave
40000178:	c3                   	ret
40000179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000180 <panic>:

void
panic(const char *file, int line, const char *fmt, ...)
{
40000180:	55                   	push   %ebp
40000181:	89 e5                	mov    %esp,%ebp
40000183:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[P] %s:%d: ", file, line);
40000186:	ff 75 0c             	push   0xc(%ebp)
40000189:	ff 75 08             	push   0x8(%ebp)
4000018c:	68 50 32 00 40       	push   $0x40003250
40000191:	e8 aa 01 00 00       	call   40000340 <printf>
	vcprintf(fmt, ap);
40000196:	58                   	pop    %eax
40000197:	8d 45 14             	lea    0x14(%ebp),%eax
4000019a:	5a                   	pop    %edx
4000019b:	50                   	push   %eax
4000019c:	ff 75 10             	push   0x10(%ebp)
4000019f:	e8 3c 01 00 00       	call   400002e0 <vcprintf>
400001a4:	83 c4 10             	add    $0x10,%esp
400001a7:	90                   	nop
400001a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400001af:	00 
	va_end(ap);

	while (1)
		yield();
400001b0:	e8 7b 08 00 00       	call   40000a30 <yield>
	while (1)
400001b5:	eb f9                	jmp    400001b0 <panic+0x30>
400001b7:	66 90                	xchg   %ax,%ax
400001b9:	66 90                	xchg   %ax,%ax
400001bb:	66 90                	xchg   %ax,%ax
400001bd:	66 90                	xchg   %ax,%ax
400001bf:	90                   	nop

400001c0 <atoi>:
#include <stdlib.h>

int
atoi(const char *buf, int *i)
{
400001c0:	55                   	push   %ebp
400001c1:	89 e5                	mov    %esp,%ebp
400001c3:	57                   	push   %edi
400001c4:	56                   	push   %esi
400001c5:	53                   	push   %ebx
400001c6:	83 ec 04             	sub    $0x4,%esp
400001c9:	8b 75 08             	mov    0x8(%ebp),%esi
	int loc = 0;
	int numstart = 0;
	int acc = 0;
	int negative = 0;
	if (buf[loc] == '+')
400001cc:	0f b6 06             	movzbl (%esi),%eax
400001cf:	3c 2b                	cmp    $0x2b,%al
400001d1:	0f 84 89 00 00 00    	je     40000260 <atoi+0xa0>
		loc++;
	else if (buf[loc] == '-') {
400001d7:	3c 2d                	cmp    $0x2d,%al
400001d9:	74 65                	je     40000240 <atoi+0x80>
		negative = 1;
		loc++;
	}
	numstart = loc;
	// no grab the numbers
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400001db:	8d 50 d0             	lea    -0x30(%eax),%edx
	int negative = 0;
400001de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int loc = 0;
400001e5:	31 ff                	xor    %edi,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400001e7:	80 fa 09             	cmp    $0x9,%dl
400001ea:	0f 87 8c 00 00 00    	ja     4000027c <atoi+0xbc>
	int loc = 0;
400001f0:	89 f9                	mov    %edi,%ecx
	int acc = 0;
400001f2:	31 d2                	xor    %edx,%edx
400001f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400001f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400001ff:	00 
		acc = acc*10 + (buf[loc]-'0');
40000200:	83 e8 30             	sub    $0x30,%eax
40000203:	8d 14 92             	lea    (%edx,%edx,4),%edx
		loc++;
40000206:	83 c1 01             	add    $0x1,%ecx
		acc = acc*10 + (buf[loc]-'0');
40000209:	0f be c0             	movsbl %al,%eax
4000020c:	8d 14 50             	lea    (%eax,%edx,2),%edx
	while ('0' <= buf[loc] && buf[loc] <= '9') {
4000020f:	0f b6 04 0e          	movzbl (%esi,%ecx,1),%eax
40000213:	8d 58 d0             	lea    -0x30(%eax),%ebx
40000216:	80 fb 09             	cmp    $0x9,%bl
40000219:	76 e5                	jbe    40000200 <atoi+0x40>
	}
	if (numstart == loc) {
4000021b:	39 f9                	cmp    %edi,%ecx
4000021d:	74 5d                	je     4000027c <atoi+0xbc>
		// no numbers have actually been scanned
		return 0;
	}
	if (negative)
		acc = - acc;
4000021f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
40000222:	89 d0                	mov    %edx,%eax
40000224:	f7 d8                	neg    %eax
40000226:	85 db                	test   %ebx,%ebx
40000228:	0f 45 d0             	cmovne %eax,%edx
	*i = acc;
4000022b:	8b 45 0c             	mov    0xc(%ebp),%eax
4000022e:	89 10                	mov    %edx,(%eax)
	return loc;
}
40000230:	83 c4 04             	add    $0x4,%esp
40000233:	89 c8                	mov    %ecx,%eax
40000235:	5b                   	pop    %ebx
40000236:	5e                   	pop    %esi
40000237:	5f                   	pop    %edi
40000238:	5d                   	pop    %ebp
40000239:	c3                   	ret
4000023a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000240:	0f b6 46 01          	movzbl 0x1(%esi),%eax
40000244:	8d 50 d0             	lea    -0x30(%eax),%edx
40000247:	80 fa 09             	cmp    $0x9,%dl
4000024a:	77 30                	ja     4000027c <atoi+0xbc>
		negative = 1;
4000024c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		loc++;
40000253:	bf 01 00 00 00       	mov    $0x1,%edi
40000258:	eb 96                	jmp    400001f0 <atoi+0x30>
4000025a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000260:	0f b6 46 01          	movzbl 0x1(%esi),%eax
	int negative = 0;
40000264:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		loc++;
4000026b:	bf 01 00 00 00       	mov    $0x1,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000270:	8d 50 d0             	lea    -0x30(%eax),%edx
40000273:	80 fa 09             	cmp    $0x9,%dl
40000276:	0f 86 74 ff ff ff    	jbe    400001f0 <atoi+0x30>
}
4000027c:	83 c4 04             	add    $0x4,%esp
		return 0;
4000027f:	31 c9                	xor    %ecx,%ecx
}
40000281:	5b                   	pop    %ebx
40000282:	89 c8                	mov    %ecx,%eax
40000284:	5e                   	pop    %esi
40000285:	5f                   	pop    %edi
40000286:	5d                   	pop    %ebp
40000287:	c3                   	ret
40000288:	66 90                	xchg   %ax,%ax
4000028a:	66 90                	xchg   %ax,%ax
4000028c:	66 90                	xchg   %ax,%ax
4000028e:	66 90                	xchg   %ax,%ax

40000290 <putch>:
	char buf[MAX_BUF];
};

static void
putch(int ch, struct printbuf *b)
{
40000290:	55                   	push   %ebp
40000291:	89 e5                	mov    %esp,%ebp
40000293:	56                   	push   %esi
40000294:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
40000297:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
4000029a:	53                   	push   %ebx
	b->buf[b->idx++] = ch;
4000029b:	8b 06                	mov    (%esi),%eax
4000029d:	8d 50 01             	lea    0x1(%eax),%edx
400002a0:	89 16                	mov    %edx,(%esi)
400002a2:	88 4c 06 08          	mov    %cl,0x8(%esi,%eax,1)
	if (b->idx == MAX_BUF-1) {
400002a6:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
400002ac:	75 1c                	jne    400002ca <putch+0x3a>
		b->buf[b->idx] = 0;
400002ae:	c6 86 07 10 00 00 00 	movb   $0x0,0x1007(%esi)
		puts(b->buf, b->idx);
400002b5:	8d 4e 08             	lea    0x8(%esi),%ecx
	asm volatile("int %2"
400002b8:	b8 08 00 00 00       	mov    $0x8,%eax
400002bd:	bb 01 00 00 00       	mov    $0x1,%ebx
400002c2:	cd 30                	int    $0x30
		b->idx = 0;
400002c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	}
	b->cnt++;
400002ca:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
400002ce:	5b                   	pop    %ebx
400002cf:	5e                   	pop    %esi
400002d0:	5d                   	pop    %ebp
400002d1:	c3                   	ret
400002d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400002d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400002df:	00 

400002e0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
400002e0:	55                   	push   %ebp
400002e1:	89 e5                	mov    %esp,%ebp
400002e3:	53                   	push   %ebx
400002e4:	bb 01 00 00 00       	mov    $0x1,%ebx
	struct printbuf b;

	b.idx = 0;
	b.cnt = 0;
	vprintfmt((void*)putch, &b, fmt, ap);
400002e9:	8d 85 f0 ef ff ff    	lea    -0x1010(%ebp),%eax
{
400002ef:	81 ec 14 10 00 00    	sub    $0x1014,%esp
	vprintfmt((void*)putch, &b, fmt, ap);
400002f5:	ff 75 0c             	push   0xc(%ebp)
400002f8:	ff 75 08             	push   0x8(%ebp)
400002fb:	50                   	push   %eax
400002fc:	68 90 02 00 40       	push   $0x40000290
	b.idx = 0;
40000301:	c7 85 f0 ef ff ff 00 	movl   $0x0,-0x1010(%ebp)
40000308:	00 00 00 
	b.cnt = 0;
4000030b:	c7 85 f4 ef ff ff 00 	movl   $0x0,-0x100c(%ebp)
40000312:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
40000315:	e8 26 01 00 00       	call   40000440 <vprintfmt>

	b.buf[b.idx] = 0;
4000031a:	8b 95 f0 ef ff ff    	mov    -0x1010(%ebp),%edx
40000320:	8d 8d f8 ef ff ff    	lea    -0x1008(%ebp),%ecx
40000326:	b8 08 00 00 00       	mov    $0x8,%eax
4000032b:	c6 84 15 f8 ef ff ff 	movb   $0x0,-0x1008(%ebp,%edx,1)
40000332:	00 
40000333:	cd 30                	int    $0x30
	puts(b.buf, b.idx);

	return b.cnt;
}
40000335:	8b 85 f4 ef ff ff    	mov    -0x100c(%ebp),%eax
4000033b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
4000033e:	c9                   	leave
4000033f:	c3                   	ret

40000340 <printf>:

int
printf(const char *fmt, ...)
{
40000340:	55                   	push   %ebp
40000341:	89 e5                	mov    %esp,%ebp
40000343:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
40000346:	8d 45 0c             	lea    0xc(%ebp),%eax
40000349:	50                   	push   %eax
4000034a:	ff 75 08             	push   0x8(%ebp)
4000034d:	e8 8e ff ff ff       	call   400002e0 <vcprintf>
	va_end(ap);

	return cnt;
}
40000352:	c9                   	leave
40000353:	c3                   	ret
40000354:	66 90                	xchg   %ax,%ax
40000356:	66 90                	xchg   %ax,%ax
40000358:	66 90                	xchg   %ax,%ax
4000035a:	66 90                	xchg   %ax,%ax
4000035c:	66 90                	xchg   %ax,%ax
4000035e:	66 90                	xchg   %ax,%ax

40000360 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
40000360:	55                   	push   %ebp
40000361:	89 e5                	mov    %esp,%ebp
40000363:	57                   	push   %edi
40000364:	89 c7                	mov    %eax,%edi
40000366:	56                   	push   %esi
40000367:	89 d6                	mov    %edx,%esi
40000369:	53                   	push   %ebx
4000036a:	83 ec 2c             	sub    $0x2c,%esp
4000036d:	8b 45 08             	mov    0x8(%ebp),%eax
40000370:	8b 55 0c             	mov    0xc(%ebp),%edx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
40000373:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
{
4000037a:	8b 4d 18             	mov    0x18(%ebp),%ecx
4000037d:	89 45 d8             	mov    %eax,-0x28(%ebp)
40000380:	8b 45 10             	mov    0x10(%ebp),%eax
40000383:	89 55 dc             	mov    %edx,-0x24(%ebp)
40000386:	8b 55 14             	mov    0x14(%ebp),%edx
40000389:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	if (num >= base) {
4000038c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
4000038f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
40000392:	1b 4d d4             	sbb    -0x2c(%ebp),%ecx
40000395:	89 45 d0             	mov    %eax,-0x30(%ebp)
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
40000398:	8d 5a ff             	lea    -0x1(%edx),%ebx
	if (num >= base) {
4000039b:	73 53                	jae    400003f0 <printnum+0x90>
		while (--width > 0)
4000039d:	83 fa 01             	cmp    $0x1,%edx
400003a0:	7e 1f                	jle    400003c1 <printnum+0x61>
400003a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400003a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400003af:	00 
			putch(padc, putdat);
400003b0:	83 ec 08             	sub    $0x8,%esp
400003b3:	56                   	push   %esi
400003b4:	ff 75 e4             	push   -0x1c(%ebp)
400003b7:	ff d7                	call   *%edi
		while (--width > 0)
400003b9:	83 c4 10             	add    $0x10,%esp
400003bc:	83 eb 01             	sub    $0x1,%ebx
400003bf:	75 ef                	jne    400003b0 <printnum+0x50>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
400003c1:	89 75 0c             	mov    %esi,0xc(%ebp)
400003c4:	ff 75 d4             	push   -0x2c(%ebp)
400003c7:	ff 75 d0             	push   -0x30(%ebp)
400003ca:	ff 75 dc             	push   -0x24(%ebp)
400003cd:	ff 75 d8             	push   -0x28(%ebp)
400003d0:	e8 2b 2d 00 00       	call   40003100 <__umoddi3>
400003d5:	83 c4 10             	add    $0x10,%esp
400003d8:	0f be 80 5c 32 00 40 	movsbl 0x4000325c(%eax),%eax
400003df:	89 45 08             	mov    %eax,0x8(%ebp)
}
400003e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
	putch("0123456789abcdef"[num % base], putdat);
400003e5:	89 f8                	mov    %edi,%eax
}
400003e7:	5b                   	pop    %ebx
400003e8:	5e                   	pop    %esi
400003e9:	5f                   	pop    %edi
400003ea:	5d                   	pop    %ebp
	putch("0123456789abcdef"[num % base], putdat);
400003eb:	ff e0                	jmp    *%eax
400003ed:	8d 76 00             	lea    0x0(%esi),%esi
		printnum(putch, putdat, num / base, base, width - 1, padc);
400003f0:	83 ec 0c             	sub    $0xc,%esp
400003f3:	ff 75 e4             	push   -0x1c(%ebp)
400003f6:	53                   	push   %ebx
400003f7:	50                   	push   %eax
400003f8:	83 ec 08             	sub    $0x8,%esp
400003fb:	ff 75 d4             	push   -0x2c(%ebp)
400003fe:	ff 75 d0             	push   -0x30(%ebp)
40000401:	ff 75 dc             	push   -0x24(%ebp)
40000404:	ff 75 d8             	push   -0x28(%ebp)
40000407:	e8 d4 2b 00 00       	call   40002fe0 <__udivdi3>
4000040c:	83 c4 18             	add    $0x18,%esp
4000040f:	52                   	push   %edx
40000410:	89 f2                	mov    %esi,%edx
40000412:	50                   	push   %eax
40000413:	89 f8                	mov    %edi,%eax
40000415:	e8 46 ff ff ff       	call   40000360 <printnum>
4000041a:	83 c4 20             	add    $0x20,%esp
4000041d:	eb a2                	jmp    400003c1 <printnum+0x61>
4000041f:	90                   	nop

40000420 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
40000420:	55                   	push   %ebp
40000421:	89 e5                	mov    %esp,%ebp
40000423:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
40000426:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
4000042a:	8b 10                	mov    (%eax),%edx
4000042c:	3b 50 04             	cmp    0x4(%eax),%edx
4000042f:	73 0a                	jae    4000043b <sprintputch+0x1b>
		*b->buf++ = ch;
40000431:	8d 4a 01             	lea    0x1(%edx),%ecx
40000434:	89 08                	mov    %ecx,(%eax)
40000436:	8b 45 08             	mov    0x8(%ebp),%eax
40000439:	88 02                	mov    %al,(%edx)
}
4000043b:	5d                   	pop    %ebp
4000043c:	c3                   	ret
4000043d:	8d 76 00             	lea    0x0(%esi),%esi

40000440 <vprintfmt>:
{
40000440:	55                   	push   %ebp
40000441:	89 e5                	mov    %esp,%ebp
40000443:	57                   	push   %edi
40000444:	56                   	push   %esi
40000445:	53                   	push   %ebx
40000446:	83 ec 2c             	sub    $0x2c,%esp
40000449:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000044c:	8b 75 0c             	mov    0xc(%ebp),%esi
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000044f:	8b 45 10             	mov    0x10(%ebp),%eax
40000452:	8d 78 01             	lea    0x1(%eax),%edi
40000455:	0f b6 00             	movzbl (%eax),%eax
40000458:	83 f8 25             	cmp    $0x25,%eax
4000045b:	75 19                	jne    40000476 <vprintfmt+0x36>
4000045d:	eb 29                	jmp    40000488 <vprintfmt+0x48>
4000045f:	90                   	nop
			putch(ch, putdat);
40000460:	83 ec 08             	sub    $0x8,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
40000463:	83 c7 01             	add    $0x1,%edi
			putch(ch, putdat);
40000466:	56                   	push   %esi
40000467:	50                   	push   %eax
40000468:	ff d3                	call   *%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000046a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
4000046e:	83 c4 10             	add    $0x10,%esp
40000471:	83 f8 25             	cmp    $0x25,%eax
40000474:	74 12                	je     40000488 <vprintfmt+0x48>
			if (ch == '\0')
40000476:	85 c0                	test   %eax,%eax
40000478:	75 e6                	jne    40000460 <vprintfmt+0x20>
}
4000047a:	8d 65 f4             	lea    -0xc(%ebp),%esp
4000047d:	5b                   	pop    %ebx
4000047e:	5e                   	pop    %esi
4000047f:	5f                   	pop    %edi
40000480:	5d                   	pop    %ebp
40000481:	c3                   	ret
40000482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		padc = ' ';
40000488:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
		precision = -1;
4000048c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		altflag = 0;
40000491:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		width = -1;
40000498:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		lflag = 0;
4000049f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400004a6:	0f b6 17             	movzbl (%edi),%edx
400004a9:	8d 47 01             	lea    0x1(%edi),%eax
400004ac:	89 45 10             	mov    %eax,0x10(%ebp)
400004af:	8d 42 dd             	lea    -0x23(%edx),%eax
400004b2:	3c 55                	cmp    $0x55,%al
400004b4:	77 0a                	ja     400004c0 <vprintfmt+0x80>
400004b6:	0f b6 c0             	movzbl %al,%eax
400004b9:	ff 24 85 e8 3c 00 40 	jmp    *0x40003ce8(,%eax,4)
			putch('%', putdat);
400004c0:	83 ec 08             	sub    $0x8,%esp
400004c3:	56                   	push   %esi
400004c4:	6a 25                	push   $0x25
400004c6:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
400004c8:	83 c4 10             	add    $0x10,%esp
400004cb:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
400004cf:	89 7d 10             	mov    %edi,0x10(%ebp)
400004d2:	0f 84 77 ff ff ff    	je     4000044f <vprintfmt+0xf>
400004d8:	89 f8                	mov    %edi,%eax
400004da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400004e0:	83 e8 01             	sub    $0x1,%eax
400004e3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
400004e7:	75 f7                	jne    400004e0 <vprintfmt+0xa0>
400004e9:	89 45 10             	mov    %eax,0x10(%ebp)
400004ec:	e9 5e ff ff ff       	jmp    4000044f <vprintfmt+0xf>
400004f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				if (ch < '0' || ch > '9')
400004f8:	0f be 47 01          	movsbl 0x1(%edi),%eax
				precision = precision * 10 + ch - '0';
400004fc:	8d 4a d0             	lea    -0x30(%edx),%ecx
		switch (ch = *(unsigned char *) fmt++) {
400004ff:	8b 7d 10             	mov    0x10(%ebp),%edi
				if (ch < '0' || ch > '9')
40000502:	8d 50 d0             	lea    -0x30(%eax),%edx
40000505:	83 fa 09             	cmp    $0x9,%edx
40000508:	77 2b                	ja     40000535 <vprintfmt+0xf5>
4000050a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000510:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000517:	00 
40000518:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000051f:	00 
				precision = precision * 10 + ch - '0';
40000520:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
			for (precision = 0; ; ++fmt) {
40000523:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
40000526:	8d 4c 50 d0          	lea    -0x30(%eax,%edx,2),%ecx
				ch = *fmt;
4000052a:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
4000052d:	8d 50 d0             	lea    -0x30(%eax),%edx
40000530:	83 fa 09             	cmp    $0x9,%edx
40000533:	76 eb                	jbe    40000520 <vprintfmt+0xe0>
			if (width < 0)
40000535:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000538:	85 c0                	test   %eax,%eax
				width = precision, precision = -1;
4000053a:	0f 48 c1             	cmovs  %ecx,%eax
4000053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
40000540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000545:	0f 48 c8             	cmovs  %eax,%ecx
40000548:	e9 59 ff ff ff       	jmp    400004a6 <vprintfmt+0x66>
			altflag = 1;
4000054d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000554:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000557:	e9 4a ff ff ff       	jmp    400004a6 <vprintfmt+0x66>
			putch(ch, putdat);
4000055c:	83 ec 08             	sub    $0x8,%esp
4000055f:	56                   	push   %esi
40000560:	6a 25                	push   $0x25
40000562:	ff d3                	call   *%ebx
			break;
40000564:	83 c4 10             	add    $0x10,%esp
40000567:	e9 e3 fe ff ff       	jmp    4000044f <vprintfmt+0xf>
			precision = va_arg(ap, int);
4000056c:	8b 45 14             	mov    0x14(%ebp),%eax
		switch (ch = *(unsigned char *) fmt++) {
4000056f:	8b 7d 10             	mov    0x10(%ebp),%edi
			precision = va_arg(ap, int);
40000572:	8b 08                	mov    (%eax),%ecx
40000574:	83 c0 04             	add    $0x4,%eax
40000577:	89 45 14             	mov    %eax,0x14(%ebp)
			goto process_precision;
4000057a:	eb b9                	jmp    40000535 <vprintfmt+0xf5>
			if (width < 0)
4000057c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
4000057f:	31 c0                	xor    %eax,%eax
		switch (ch = *(unsigned char *) fmt++) {
40000581:	8b 7d 10             	mov    0x10(%ebp),%edi
			if (width < 0)
40000584:	85 d2                	test   %edx,%edx
40000586:	0f 49 c2             	cmovns %edx,%eax
40000589:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			goto reswitch;
4000058c:	e9 15 ff ff ff       	jmp    400004a6 <vprintfmt+0x66>
			putch(va_arg(ap, int), putdat);
40000591:	83 ec 08             	sub    $0x8,%esp
40000594:	56                   	push   %esi
40000595:	8b 45 14             	mov    0x14(%ebp),%eax
40000598:	ff 30                	push   (%eax)
4000059a:	ff d3                	call   *%ebx
4000059c:	8b 45 14             	mov    0x14(%ebp),%eax
4000059f:	83 c0 04             	add    $0x4,%eax
			break;
400005a2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
400005a5:	89 45 14             	mov    %eax,0x14(%ebp)
			break;
400005a8:	e9 a2 fe ff ff       	jmp    4000044f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
400005ad:	8b 45 14             	mov    0x14(%ebp),%eax
400005b0:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
400005b2:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
400005b6:	0f 8f af 01 00 00    	jg     4000076b <vprintfmt+0x32b>
		return va_arg(*ap, unsigned long);
400005bc:	83 c0 04             	add    $0x4,%eax
400005bf:	31 c9                	xor    %ecx,%ecx
400005c1:	bf 0a 00 00 00       	mov    $0xa,%edi
400005c6:	89 45 14             	mov    %eax,0x14(%ebp)
400005c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			printnum(putch, putdat, num, base, width, padc);
400005d0:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
400005d4:	83 ec 0c             	sub    $0xc,%esp
400005d7:	50                   	push   %eax
400005d8:	89 d8                	mov    %ebx,%eax
400005da:	ff 75 e4             	push   -0x1c(%ebp)
400005dd:	57                   	push   %edi
400005de:	51                   	push   %ecx
400005df:	52                   	push   %edx
400005e0:	89 f2                	mov    %esi,%edx
400005e2:	e8 79 fd ff ff       	call   40000360 <printnum>
			break;
400005e7:	83 c4 20             	add    $0x20,%esp
400005ea:	e9 60 fe ff ff       	jmp    4000044f <vprintfmt+0xf>
			putch('0', putdat);
400005ef:	83 ec 08             	sub    $0x8,%esp
			goto number;
400005f2:	bf 10 00 00 00       	mov    $0x10,%edi
			putch('0', putdat);
400005f7:	56                   	push   %esi
400005f8:	6a 30                	push   $0x30
400005fa:	ff d3                	call   *%ebx
			putch('x', putdat);
400005fc:	58                   	pop    %eax
400005fd:	5a                   	pop    %edx
400005fe:	56                   	push   %esi
400005ff:	6a 78                	push   $0x78
40000601:	ff d3                	call   *%ebx
			num = (unsigned long long)
40000603:	8b 45 14             	mov    0x14(%ebp),%eax
40000606:	31 c9                	xor    %ecx,%ecx
40000608:	8b 10                	mov    (%eax),%edx
				(uintptr_t) va_arg(ap, void *);
4000060a:	83 c0 04             	add    $0x4,%eax
			goto number;
4000060d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
40000610:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;
40000613:	eb bb                	jmp    400005d0 <vprintfmt+0x190>
		return va_arg(*ap, unsigned long long);
40000615:	8b 45 14             	mov    0x14(%ebp),%eax
40000618:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
4000061a:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
4000061e:	0f 8f 5a 01 00 00    	jg     4000077e <vprintfmt+0x33e>
		return va_arg(*ap, unsigned long);
40000624:	83 c0 04             	add    $0x4,%eax
40000627:	31 c9                	xor    %ecx,%ecx
40000629:	bf 10 00 00 00       	mov    $0x10,%edi
4000062e:	89 45 14             	mov    %eax,0x14(%ebp)
40000631:	eb 9d                	jmp    400005d0 <vprintfmt+0x190>
		return va_arg(*ap, long long);
40000633:	8b 45 14             	mov    0x14(%ebp),%eax
	if (lflag >= 2)
40000636:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
4000063a:	0f 8f 51 01 00 00    	jg     40000791 <vprintfmt+0x351>
		return va_arg(*ap, long);
40000640:	8b 4d 14             	mov    0x14(%ebp),%ecx
40000643:	8b 00                	mov    (%eax),%eax
40000645:	83 c1 04             	add    $0x4,%ecx
40000648:	99                   	cltd
40000649:	89 4d 14             	mov    %ecx,0x14(%ebp)
			if ((long long) num < 0) {
4000064c:	85 d2                	test   %edx,%edx
4000064e:	0f 88 68 01 00 00    	js     400007bc <vprintfmt+0x37c>
			num = getint(&ap, lflag);
40000654:	89 d1                	mov    %edx,%ecx
40000656:	bf 0a 00 00 00       	mov    $0xa,%edi
4000065b:	89 c2                	mov    %eax,%edx
4000065d:	e9 6e ff ff ff       	jmp    400005d0 <vprintfmt+0x190>
			lflag++;
40000662:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000666:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000669:	e9 38 fe ff ff       	jmp    400004a6 <vprintfmt+0x66>
			putch('X', putdat);
4000066e:	83 ec 08             	sub    $0x8,%esp
40000671:	56                   	push   %esi
40000672:	6a 58                	push   $0x58
40000674:	ff d3                	call   *%ebx
			putch('X', putdat);
40000676:	59                   	pop    %ecx
40000677:	5f                   	pop    %edi
40000678:	56                   	push   %esi
40000679:	6a 58                	push   $0x58
4000067b:	ff d3                	call   *%ebx
			putch('X', putdat);
4000067d:	58                   	pop    %eax
4000067e:	5a                   	pop    %edx
4000067f:	56                   	push   %esi
40000680:	6a 58                	push   $0x58
40000682:	ff d3                	call   *%ebx
			break;
40000684:	83 c4 10             	add    $0x10,%esp
40000687:	e9 c3 fd ff ff       	jmp    4000044f <vprintfmt+0xf>
			if ((p = va_arg(ap, char *)) == NULL)
4000068c:	8b 45 14             	mov    0x14(%ebp),%eax
4000068f:	83 c0 04             	add    $0x4,%eax
40000692:	89 45 d4             	mov    %eax,-0x2c(%ebp)
40000695:	8b 45 14             	mov    0x14(%ebp),%eax
40000698:	8b 38                	mov    (%eax),%edi
			if (width > 0 && padc != '-')
4000069a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
4000069d:	85 c0                	test   %eax,%eax
4000069f:	0f 9f c0             	setg   %al
400006a2:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
400006a6:	0f 95 c2             	setne  %dl
400006a9:	21 d0                	and    %edx,%eax
			if ((p = va_arg(ap, char *)) == NULL)
400006ab:	85 ff                	test   %edi,%edi
400006ad:	0f 84 32 01 00 00    	je     400007e5 <vprintfmt+0x3a5>
			if (width > 0 && padc != '-')
400006b3:	84 c0                	test   %al,%al
400006b5:	0f 85 4d 01 00 00    	jne    40000808 <vprintfmt+0x3c8>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006bb:	0f be 07             	movsbl (%edi),%eax
400006be:	89 c2                	mov    %eax,%edx
400006c0:	85 c0                	test   %eax,%eax
400006c2:	74 7b                	je     4000073f <vprintfmt+0x2ff>
400006c4:	89 5d 08             	mov    %ebx,0x8(%ebp)
400006c7:	83 c7 01             	add    $0x1,%edi
400006ca:	89 cb                	mov    %ecx,%ebx
400006cc:	89 75 0c             	mov    %esi,0xc(%ebp)
400006cf:	8b 75 e4             	mov    -0x1c(%ebp),%esi
400006d2:	eb 21                	jmp    400006f5 <vprintfmt+0x2b5>
400006d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					putch(ch, putdat);
400006d8:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006db:	83 c7 01             	add    $0x1,%edi
					putch(ch, putdat);
400006de:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006e1:	83 ee 01             	sub    $0x1,%esi
					putch(ch, putdat);
400006e4:	50                   	push   %eax
400006e5:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006e8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
400006ec:	83 c4 10             	add    $0x10,%esp
400006ef:	89 c2                	mov    %eax,%edx
400006f1:	85 c0                	test   %eax,%eax
400006f3:	74 41                	je     40000736 <vprintfmt+0x2f6>
400006f5:	85 db                	test   %ebx,%ebx
400006f7:	78 05                	js     400006fe <vprintfmt+0x2be>
400006f9:	83 eb 01             	sub    $0x1,%ebx
400006fc:	72 38                	jb     40000736 <vprintfmt+0x2f6>
				if (altflag && (ch < ' ' || ch > '~'))
400006fe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
40000701:	85 c9                	test   %ecx,%ecx
40000703:	74 d3                	je     400006d8 <vprintfmt+0x298>
40000705:	0f be ca             	movsbl %dl,%ecx
40000708:	83 e9 20             	sub    $0x20,%ecx
4000070b:	83 f9 5e             	cmp    $0x5e,%ecx
4000070e:	76 c8                	jbe    400006d8 <vprintfmt+0x298>
					putch('?', putdat);
40000710:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000713:	83 c7 01             	add    $0x1,%edi
					putch('?', putdat);
40000716:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000719:	83 ee 01             	sub    $0x1,%esi
					putch('?', putdat);
4000071c:	6a 3f                	push   $0x3f
4000071e:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000721:	0f be 4f ff          	movsbl -0x1(%edi),%ecx
40000725:	83 c4 10             	add    $0x10,%esp
40000728:	89 ca                	mov    %ecx,%edx
4000072a:	89 c8                	mov    %ecx,%eax
4000072c:	85 c9                	test   %ecx,%ecx
4000072e:	74 06                	je     40000736 <vprintfmt+0x2f6>
40000730:	85 db                	test   %ebx,%ebx
40000732:	79 c5                	jns    400006f9 <vprintfmt+0x2b9>
40000734:	eb d2                	jmp    40000708 <vprintfmt+0x2c8>
40000736:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40000739:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000073c:	8b 75 0c             	mov    0xc(%ebp),%esi
			for (; width > 0; width--)
4000073f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000742:	85 c0                	test   %eax,%eax
40000744:	7e 1a                	jle    40000760 <vprintfmt+0x320>
40000746:	89 c7                	mov    %eax,%edi
40000748:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000074f:	00 
				putch(' ', putdat);
40000750:	83 ec 08             	sub    $0x8,%esp
40000753:	56                   	push   %esi
40000754:	6a 20                	push   $0x20
40000756:	ff d3                	call   *%ebx
			for (; width > 0; width--)
40000758:	83 c4 10             	add    $0x10,%esp
4000075b:	83 ef 01             	sub    $0x1,%edi
4000075e:	75 f0                	jne    40000750 <vprintfmt+0x310>
			if ((p = va_arg(ap, char *)) == NULL)
40000760:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40000763:	89 45 14             	mov    %eax,0x14(%ebp)
40000766:	e9 e4 fc ff ff       	jmp    4000044f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
4000076b:	8b 48 04             	mov    0x4(%eax),%ecx
4000076e:	83 c0 08             	add    $0x8,%eax
40000771:	bf 0a 00 00 00       	mov    $0xa,%edi
40000776:	89 45 14             	mov    %eax,0x14(%ebp)
40000779:	e9 52 fe ff ff       	jmp    400005d0 <vprintfmt+0x190>
4000077e:	8b 48 04             	mov    0x4(%eax),%ecx
40000781:	83 c0 08             	add    $0x8,%eax
40000784:	bf 10 00 00 00       	mov    $0x10,%edi
40000789:	89 45 14             	mov    %eax,0x14(%ebp)
4000078c:	e9 3f fe ff ff       	jmp    400005d0 <vprintfmt+0x190>
		return va_arg(*ap, long long);
40000791:	8b 4d 14             	mov    0x14(%ebp),%ecx
40000794:	8b 50 04             	mov    0x4(%eax),%edx
40000797:	8b 00                	mov    (%eax),%eax
40000799:	83 c1 08             	add    $0x8,%ecx
4000079c:	89 4d 14             	mov    %ecx,0x14(%ebp)
4000079f:	e9 a8 fe ff ff       	jmp    4000064c <vprintfmt+0x20c>
		switch (ch = *(unsigned char *) fmt++) {
400007a4:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
400007a8:	8b 7d 10             	mov    0x10(%ebp),%edi
400007ab:	e9 f6 fc ff ff       	jmp    400004a6 <vprintfmt+0x66>
			padc = '-';
400007b0:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400007b4:	8b 7d 10             	mov    0x10(%ebp),%edi
400007b7:	e9 ea fc ff ff       	jmp    400004a6 <vprintfmt+0x66>
				putch('-', putdat);
400007bc:	83 ec 08             	sub    $0x8,%esp
400007bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
				num = -(long long) num;
400007c2:	bf 0a 00 00 00       	mov    $0xa,%edi
400007c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch('-', putdat);
400007ca:	56                   	push   %esi
400007cb:	6a 2d                	push   $0x2d
400007cd:	ff d3                	call   *%ebx
				num = -(long long) num;
400007cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
400007d2:	31 d2                	xor    %edx,%edx
400007d4:	f7 d8                	neg    %eax
400007d6:	1b 55 dc             	sbb    -0x24(%ebp),%edx
400007d9:	83 c4 10             	add    $0x10,%esp
400007dc:	89 d1                	mov    %edx,%ecx
400007de:	89 c2                	mov    %eax,%edx
400007e0:	e9 eb fd ff ff       	jmp    400005d0 <vprintfmt+0x190>
			if (width > 0 && padc != '-')
400007e5:	84 c0                	test   %al,%al
400007e7:	75 78                	jne    40000861 <vprintfmt+0x421>
400007e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400007ec:	bf 6e 32 00 40       	mov    $0x4000326e,%edi
400007f1:	ba 28 00 00 00       	mov    $0x28,%edx
400007f6:	89 cb                	mov    %ecx,%ebx
400007f8:	89 75 0c             	mov    %esi,0xc(%ebp)
400007fb:	b8 28 00 00 00       	mov    $0x28,%eax
40000800:	8b 75 e4             	mov    -0x1c(%ebp),%esi
40000803:	e9 ed fe ff ff       	jmp    400006f5 <vprintfmt+0x2b5>
				for (width -= strnlen(p, precision); width > 0; width--)
40000808:	83 ec 08             	sub    $0x8,%esp
4000080b:	51                   	push   %ecx
4000080c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
4000080f:	57                   	push   %edi
40000810:	e8 eb 02 00 00       	call   40000b00 <strnlen>
40000815:	29 45 e4             	sub    %eax,-0x1c(%ebp)
40000818:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
4000081b:	83 c4 10             	add    $0x10,%esp
4000081e:	85 c9                	test   %ecx,%ecx
40000820:	8b 4d d0             	mov    -0x30(%ebp),%ecx
40000823:	7e 71                	jle    40000896 <vprintfmt+0x456>
					putch(padc, putdat);
40000825:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
40000829:	89 4d cc             	mov    %ecx,-0x34(%ebp)
4000082c:	89 7d d0             	mov    %edi,-0x30(%ebp)
4000082f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
40000832:	89 45 e0             	mov    %eax,-0x20(%ebp)
40000835:	83 ec 08             	sub    $0x8,%esp
40000838:	56                   	push   %esi
40000839:	ff 75 e0             	push   -0x20(%ebp)
4000083c:	ff d3                	call   *%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
4000083e:	83 c4 10             	add    $0x10,%esp
40000841:	83 ef 01             	sub    $0x1,%edi
40000844:	75 ef                	jne    40000835 <vprintfmt+0x3f5>
40000846:	89 7d e4             	mov    %edi,-0x1c(%ebp)
40000849:	8b 7d d0             	mov    -0x30(%ebp),%edi
4000084c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000084f:	0f be 07             	movsbl (%edi),%eax
40000852:	89 c2                	mov    %eax,%edx
40000854:	85 c0                	test   %eax,%eax
40000856:	0f 85 68 fe ff ff    	jne    400006c4 <vprintfmt+0x284>
4000085c:	e9 ff fe ff ff       	jmp    40000760 <vprintfmt+0x320>
				for (width -= strnlen(p, precision); width > 0; width--)
40000861:	83 ec 08             	sub    $0x8,%esp
				p = "(null)";
40000864:	bf 6d 32 00 40       	mov    $0x4000326d,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
40000869:	51                   	push   %ecx
4000086a:	89 4d d0             	mov    %ecx,-0x30(%ebp)
4000086d:	68 6d 32 00 40       	push   $0x4000326d
40000872:	e8 89 02 00 00       	call   40000b00 <strnlen>
40000877:	29 45 e4             	sub    %eax,-0x1c(%ebp)
4000087a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
4000087d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000880:	ba 28 00 00 00       	mov    $0x28,%edx
40000885:	b8 28 00 00 00       	mov    $0x28,%eax
				for (width -= strnlen(p, precision); width > 0; width--)
4000088a:	85 c9                	test   %ecx,%ecx
4000088c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
4000088f:	7f 94                	jg     40000825 <vprintfmt+0x3e5>
40000891:	e9 2e fe ff ff       	jmp    400006c4 <vprintfmt+0x284>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000896:	0f be 07             	movsbl (%edi),%eax
40000899:	89 c2                	mov    %eax,%edx
4000089b:	85 c0                	test   %eax,%eax
4000089d:	0f 85 21 fe ff ff    	jne    400006c4 <vprintfmt+0x284>
400008a3:	e9 b8 fe ff ff       	jmp    40000760 <vprintfmt+0x320>
400008a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400008af:	00 

400008b0 <printfmt>:
{
400008b0:	55                   	push   %ebp
400008b1:	89 e5                	mov    %esp,%ebp
400008b3:	83 ec 08             	sub    $0x8,%esp
	vprintfmt(putch, putdat, fmt, ap);
400008b6:	8d 45 14             	lea    0x14(%ebp),%eax
400008b9:	50                   	push   %eax
400008ba:	ff 75 10             	push   0x10(%ebp)
400008bd:	ff 75 0c             	push   0xc(%ebp)
400008c0:	ff 75 08             	push   0x8(%ebp)
400008c3:	e8 78 fb ff ff       	call   40000440 <vprintfmt>
}
400008c8:	83 c4 10             	add    $0x10,%esp
400008cb:	c9                   	leave
400008cc:	c3                   	ret
400008cd:	8d 76 00             	lea    0x0(%esi),%esi

400008d0 <vsprintf>:

int
vsprintf(char *buf, const char *fmt, va_list ap)
{
400008d0:	55                   	push   %ebp
400008d1:	89 e5                	mov    %esp,%ebp
400008d3:	83 ec 18             	sub    $0x18,%esp
	//assert(buf != NULL);
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400008d6:	8b 45 08             	mov    0x8(%ebp),%eax

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008d9:	ff 75 10             	push   0x10(%ebp)
400008dc:	ff 75 0c             	push   0xc(%ebp)
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400008df:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
400008e5:	50                   	push   %eax
400008e6:	68 20 04 00 40       	push   $0x40000420
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400008eb:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
400008f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008f9:	e8 42 fb ff ff       	call   40000440 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
400008fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000901:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000904:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000907:	c9                   	leave
40000908:	c3                   	ret
40000909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000910 <sprintf>:

int
sprintf(char *buf, const char *fmt, ...)
{
40000910:	55                   	push   %ebp
40000911:	89 e5                	mov    %esp,%ebp
40000913:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
40000916:	8b 45 08             	mov    0x8(%ebp),%eax
40000919:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
40000920:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
40000927:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000092a:	8d 45 10             	lea    0x10(%ebp),%eax
4000092d:	50                   	push   %eax
4000092e:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000931:	ff 75 0c             	push   0xc(%ebp)
40000934:	50                   	push   %eax
40000935:	68 20 04 00 40       	push   $0x40000420
4000093a:	e8 01 fb ff ff       	call   40000440 <vprintfmt>
	*b.buf = '\0';
4000093f:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000942:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsprintf(buf, fmt, ap);
	va_end(ap);

	return rc;
}
40000945:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000948:	c9                   	leave
40000949:	c3                   	ret
4000094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000950 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
40000950:	55                   	push   %ebp
40000951:	89 e5                	mov    %esp,%ebp
40000953:	83 ec 18             	sub    $0x18,%esp
40000956:	8b 45 08             	mov    0x8(%ebp),%eax
	//assert(buf != NULL && n > 0);
	struct sprintbuf b = {buf, buf+n-1, 0};
40000959:	8b 55 0c             	mov    0xc(%ebp),%edx

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000095c:	ff 75 14             	push   0x14(%ebp)
4000095f:	ff 75 10             	push   0x10(%ebp)
	struct sprintbuf b = {buf, buf+n-1, 0};
40000962:	89 45 ec             	mov    %eax,-0x14(%ebp)
40000965:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
40000969:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000096c:	8d 45 ec             	lea    -0x14(%ebp),%eax
4000096f:	50                   	push   %eax
40000970:	68 20 04 00 40       	push   $0x40000420
	struct sprintbuf b = {buf, buf+n-1, 0};
40000975:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000097c:	e8 bf fa ff ff       	call   40000440 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
40000981:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000984:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000987:	8b 45 f4             	mov    -0xc(%ebp),%eax
4000098a:	c9                   	leave
4000098b:	c3                   	ret
4000098c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000990 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
40000990:	55                   	push   %ebp
40000991:	89 e5                	mov    %esp,%ebp
40000993:	83 ec 18             	sub    $0x18,%esp
40000996:	8b 45 08             	mov    0x8(%ebp),%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
40000999:	8b 55 0c             	mov    0xc(%ebp),%edx
4000099c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
400009a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
400009a6:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
400009aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400009ad:	8d 45 14             	lea    0x14(%ebp),%eax
400009b0:	50                   	push   %eax
400009b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
400009b4:	ff 75 10             	push   0x10(%ebp)
400009b7:	50                   	push   %eax
400009b8:	68 20 04 00 40       	push   $0x40000420
400009bd:	e8 7e fa ff ff       	call   40000440 <vprintfmt>
	*b.buf = '\0';
400009c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
400009c5:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
	va_end(ap);

	return rc;
}
400009c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
400009cb:	c9                   	leave
400009cc:	c3                   	ret
400009cd:	66 90                	xchg   %ax,%ax
400009cf:	90                   	nop

400009d0 <spawn>:
#include <syscall.h>
#include <types.h>

pid_t
spawn(uintptr_t exec, unsigned int quota)
{
400009d0:	55                   	push   %ebp
	asm volatile("int %2"
400009d1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
400009d6:	b8 01 00 00 00       	mov    $0x1,%eax
400009db:	89 e5                	mov    %esp,%ebp
400009dd:	56                   	push   %esi
400009de:	89 d6                	mov    %edx,%esi
400009e0:	53                   	push   %ebx
400009e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
400009e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
400009e7:	cd 30                	int    $0x30
	return errno ? -1 : pid;
400009e9:	85 c0                	test   %eax,%eax
400009eb:	75 0b                	jne    400009f8 <spawn+0x28>
400009ed:	89 da                	mov    %ebx,%edx
	// Default: inherit console stdin/stdout
	return sys_spawn(exec, quota, -1, -1);
}
400009ef:	5b                   	pop    %ebx
400009f0:	89 d0                	mov    %edx,%eax
400009f2:	5e                   	pop    %esi
400009f3:	5d                   	pop    %ebp
400009f4:	c3                   	ret
400009f5:	8d 76 00             	lea    0x0(%esi),%esi
400009f8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, -1, -1);
400009fd:	eb f0                	jmp    400009ef <spawn+0x1f>
400009ff:	90                   	nop

40000a00 <spawn_with_fds>:

pid_t
spawn_with_fds(uintptr_t exec, unsigned int quota, int stdin_fd, int stdout_fd)
{
40000a00:	55                   	push   %ebp
	asm volatile("int %2"
40000a01:	b8 01 00 00 00       	mov    $0x1,%eax
40000a06:	89 e5                	mov    %esp,%ebp
40000a08:	56                   	push   %esi
40000a09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000a0c:	8b 55 10             	mov    0x10(%ebp),%edx
40000a0f:	53                   	push   %ebx
40000a10:	8b 75 14             	mov    0x14(%ebp),%esi
40000a13:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000a16:	cd 30                	int    $0x30
	return errno ? -1 : pid;
40000a18:	85 c0                	test   %eax,%eax
40000a1a:	75 0c                	jne    40000a28 <spawn_with_fds+0x28>
40000a1c:	89 da                	mov    %ebx,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
}
40000a1e:	5b                   	pop    %ebx
40000a1f:	89 d0                	mov    %edx,%eax
40000a21:	5e                   	pop    %esi
40000a22:	5d                   	pop    %ebp
40000a23:	c3                   	ret
40000a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000a28:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
40000a2d:	eb ef                	jmp    40000a1e <spawn_with_fds+0x1e>
40000a2f:	90                   	nop

40000a30 <yield>:
	asm volatile("int %0" :
40000a30:	b8 02 00 00 00       	mov    $0x2,%eax
40000a35:	cd 30                	int    $0x30

void
yield(void)
{
	sys_yield();
}
40000a37:	c3                   	ret
40000a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a3f:	00 

40000a40 <produce>:
	asm volatile("int %0" :
40000a40:	b8 03 00 00 00       	mov    $0x3,%eax
40000a45:	cd 30                	int    $0x30

void
produce(void)
{
	sys_produce();
}
40000a47:	c3                   	ret
40000a48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a4f:	00 

40000a50 <consume>:
	asm volatile("int %0" :
40000a50:	b8 04 00 00 00       	mov    $0x4,%eax
40000a55:	cd 30                	int    $0x30

void
consume(void)
{
	sys_consume();
}
40000a57:	c3                   	ret
40000a58:	66 90                	xchg   %ax,%ax
40000a5a:	66 90                	xchg   %ax,%ax
40000a5c:	66 90                	xchg   %ax,%ax
40000a5e:	66 90                	xchg   %ax,%ax

40000a60 <spinlock_init>:
	return result;
}

void
spinlock_init(spinlock_t *lk)
{
40000a60:	55                   	push   %ebp
40000a61:	89 e5                	mov    %esp,%ebp
	*lk = 0;
40000a63:	8b 45 08             	mov    0x8(%ebp),%eax
40000a66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
40000a6c:	5d                   	pop    %ebp
40000a6d:	c3                   	ret
40000a6e:	66 90                	xchg   %ax,%ax

40000a70 <spinlock_acquire>:

void
spinlock_acquire(spinlock_t *lk)
{
40000a70:	55                   	push   %ebp
	asm volatile("lock; xchgl %0, %1" :
40000a71:	b8 01 00 00 00       	mov    $0x1,%eax
{
40000a76:	89 e5                	mov    %esp,%ebp
40000a78:	8b 55 08             	mov    0x8(%ebp),%edx
	asm volatile("lock; xchgl %0, %1" :
40000a7b:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000a7e:	85 c0                	test   %eax,%eax
40000a80:	74 1c                	je     40000a9e <spinlock_acquire+0x2e>
40000a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000a88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a8f:	00 
		asm volatile("pause");
40000a90:	f3 90                	pause
	asm volatile("lock; xchgl %0, %1" :
40000a92:	b8 01 00 00 00       	mov    $0x1,%eax
40000a97:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000a9a:	85 c0                	test   %eax,%eax
40000a9c:	75 f2                	jne    40000a90 <spinlock_acquire+0x20>
}
40000a9e:	5d                   	pop    %ebp
40000a9f:	c3                   	ret

40000aa0 <spinlock_release>:

// Release the lock.
void
spinlock_release(spinlock_t *lk)
{
40000aa0:	55                   	push   %ebp
40000aa1:	89 e5                	mov    %esp,%ebp
40000aa3:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
bool
spinlock_holding(spinlock_t *lock)
{
	return *lock;
40000aa6:	8b 02                	mov    (%edx),%eax
	if (spinlock_holding(lk) == FALSE)
40000aa8:	84 c0                	test   %al,%al
40000aaa:	74 05                	je     40000ab1 <spinlock_release+0x11>
	asm volatile("lock; xchgl %0, %1" :
40000aac:	31 c0                	xor    %eax,%eax
40000aae:	f0 87 02             	lock xchg %eax,(%edx)
}
40000ab1:	5d                   	pop    %ebp
40000ab2:	c3                   	ret
40000ab3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ab8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000abf:	00 

40000ac0 <spinlock_holding>:
{
40000ac0:	55                   	push   %ebp
40000ac1:	89 e5                	mov    %esp,%ebp
	return *lock;
40000ac3:	8b 45 08             	mov    0x8(%ebp),%eax
}
40000ac6:	5d                   	pop    %ebp
	return *lock;
40000ac7:	8b 00                	mov    (%eax),%eax
}
40000ac9:	c3                   	ret
40000aca:	66 90                	xchg   %ax,%ax
40000acc:	66 90                	xchg   %ax,%ax
40000ace:	66 90                	xchg   %ax,%ax
40000ad0:	66 90                	xchg   %ax,%ax
40000ad2:	66 90                	xchg   %ax,%ax
40000ad4:	66 90                	xchg   %ax,%ax
40000ad6:	66 90                	xchg   %ax,%ax
40000ad8:	66 90                	xchg   %ax,%ax
40000ada:	66 90                	xchg   %ax,%ax
40000adc:	66 90                	xchg   %ax,%ax
40000ade:	66 90                	xchg   %ax,%ax

40000ae0 <strlen>:
#include <string.h>
#include <types.h>

int
strlen(const char *s)
{
40000ae0:	55                   	push   %ebp
	int n;

	for (n = 0; *s != '\0'; s++)
40000ae1:	31 c0                	xor    %eax,%eax
{
40000ae3:	89 e5                	mov    %esp,%ebp
40000ae5:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; *s != '\0'; s++)
40000ae8:	80 3a 00             	cmpb   $0x0,(%edx)
40000aeb:	74 0c                	je     40000af9 <strlen+0x19>
40000aed:	8d 76 00             	lea    0x0(%esi),%esi
		n++;
40000af0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
40000af3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
40000af7:	75 f7                	jne    40000af0 <strlen+0x10>
	return n;
}
40000af9:	5d                   	pop    %ebp
40000afa:	c3                   	ret
40000afb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

40000b00 <strnlen>:

int
strnlen(const char *s, size_t size)
{
40000b00:	55                   	push   %ebp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000b01:	31 c0                	xor    %eax,%eax
{
40000b03:	89 e5                	mov    %esp,%ebp
40000b05:	8b 55 0c             	mov    0xc(%ebp),%edx
40000b08:	8b 4d 08             	mov    0x8(%ebp),%ecx
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000b0b:	85 d2                	test   %edx,%edx
40000b0d:	75 18                	jne    40000b27 <strnlen+0x27>
40000b0f:	eb 1c                	jmp    40000b2d <strnlen+0x2d>
40000b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b1f:	00 
		n++;
40000b20:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000b23:	39 c2                	cmp    %eax,%edx
40000b25:	74 06                	je     40000b2d <strnlen+0x2d>
40000b27:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
40000b2b:	75 f3                	jne    40000b20 <strnlen+0x20>
	return n;
}
40000b2d:	5d                   	pop    %ebp
40000b2e:	c3                   	ret
40000b2f:	90                   	nop

40000b30 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
40000b30:	55                   	push   %ebp
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
40000b31:	31 c0                	xor    %eax,%eax
{
40000b33:	89 e5                	mov    %esp,%ebp
40000b35:	53                   	push   %ebx
40000b36:	8b 4d 08             	mov    0x8(%ebp),%ecx
40000b39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while ((*dst++ = *src++) != '\0')
40000b40:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000b44:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000b47:	83 c0 01             	add    $0x1,%eax
40000b4a:	84 d2                	test   %dl,%dl
40000b4c:	75 f2                	jne    40000b40 <strcpy+0x10>
		/* do nothing */;
	return ret;
}
40000b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000b51:	89 c8                	mov    %ecx,%eax
40000b53:	c9                   	leave
40000b54:	c3                   	ret
40000b55:	8d 76 00             	lea    0x0(%esi),%esi
40000b58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b5f:	00 

40000b60 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size)
{
40000b60:	55                   	push   %ebp
40000b61:	89 e5                	mov    %esp,%ebp
40000b63:	56                   	push   %esi
40000b64:	8b 55 0c             	mov    0xc(%ebp),%edx
40000b67:	8b 75 08             	mov    0x8(%ebp),%esi
40000b6a:	53                   	push   %ebx
40000b6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
40000b6e:	85 db                	test   %ebx,%ebx
40000b70:	74 21                	je     40000b93 <strncpy+0x33>
40000b72:	01 f3                	add    %esi,%ebx
40000b74:	89 f0                	mov    %esi,%eax
40000b76:	66 90                	xchg   %ax,%ax
40000b78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b7f:	00 
		*dst++ = *src;
40000b80:	0f b6 0a             	movzbl (%edx),%ecx
40000b83:	83 c0 01             	add    $0x1,%eax
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
40000b86:	80 f9 01             	cmp    $0x1,%cl
		*dst++ = *src;
40000b89:	88 48 ff             	mov    %cl,-0x1(%eax)
			src++;
40000b8c:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
40000b8f:	39 c3                	cmp    %eax,%ebx
40000b91:	75 ed                	jne    40000b80 <strncpy+0x20>
	}
	return ret;
}
40000b93:	89 f0                	mov    %esi,%eax
40000b95:	5b                   	pop    %ebx
40000b96:	5e                   	pop    %esi
40000b97:	5d                   	pop    %ebp
40000b98:	c3                   	ret
40000b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000ba0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
40000ba0:	55                   	push   %ebp
40000ba1:	89 e5                	mov    %esp,%ebp
40000ba3:	53                   	push   %ebx
40000ba4:	8b 45 10             	mov    0x10(%ebp),%eax
40000ba7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
40000baa:	85 c0                	test   %eax,%eax
40000bac:	74 2e                	je     40000bdc <strlcpy+0x3c>
		while (--size > 0 && *src != '\0')
40000bae:	8b 55 08             	mov    0x8(%ebp),%edx
40000bb1:	83 e8 01             	sub    $0x1,%eax
40000bb4:	74 23                	je     40000bd9 <strlcpy+0x39>
40000bb6:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
40000bb9:	eb 12                	jmp    40000bcd <strlcpy+0x2d>
40000bbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
			*dst++ = *src++;
40000bc0:	83 c2 01             	add    $0x1,%edx
40000bc3:	83 c1 01             	add    $0x1,%ecx
40000bc6:	88 42 ff             	mov    %al,-0x1(%edx)
		while (--size > 0 && *src != '\0')
40000bc9:	39 da                	cmp    %ebx,%edx
40000bcb:	74 07                	je     40000bd4 <strlcpy+0x34>
40000bcd:	0f b6 01             	movzbl (%ecx),%eax
40000bd0:	84 c0                	test   %al,%al
40000bd2:	75 ec                	jne    40000bc0 <strlcpy+0x20>
		*dst = '\0';
	}
	return dst - dst_in;
40000bd4:	89 d0                	mov    %edx,%eax
40000bd6:	2b 45 08             	sub    0x8(%ebp),%eax
		*dst = '\0';
40000bd9:	c6 02 00             	movb   $0x0,(%edx)
}
40000bdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000bdf:	c9                   	leave
40000be0:	c3                   	ret
40000be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000be8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bef:	00 

40000bf0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
40000bf0:	55                   	push   %ebp
40000bf1:	89 e5                	mov    %esp,%ebp
40000bf3:	53                   	push   %ebx
40000bf4:	8b 55 08             	mov    0x8(%ebp),%edx
40000bf7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
40000bfa:	0f b6 02             	movzbl (%edx),%eax
40000bfd:	84 c0                	test   %al,%al
40000bff:	75 2d                	jne    40000c2e <strcmp+0x3e>
40000c01:	eb 4a                	jmp    40000c4d <strcmp+0x5d>
40000c03:	eb 1b                	jmp    40000c20 <strcmp+0x30>
40000c05:	8d 76 00             	lea    0x0(%esi),%esi
40000c08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c0f:	00 
40000c10:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c17:	00 
40000c18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c1f:	00 
40000c20:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		p++, q++;
40000c24:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
40000c27:	84 c0                	test   %al,%al
40000c29:	74 15                	je     40000c40 <strcmp+0x50>
40000c2b:	83 c1 01             	add    $0x1,%ecx
40000c2e:	0f b6 19             	movzbl (%ecx),%ebx
40000c31:	38 c3                	cmp    %al,%bl
40000c33:	74 eb                	je     40000c20 <strcmp+0x30>
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c35:	29 d8                	sub    %ebx,%eax
}
40000c37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c3a:	c9                   	leave
40000c3b:	c3                   	ret
40000c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c40:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
40000c44:	31 c0                	xor    %eax,%eax
40000c46:	29 d8                	sub    %ebx,%eax
}
40000c48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c4b:	c9                   	leave
40000c4c:	c3                   	ret
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c4d:	0f b6 19             	movzbl (%ecx),%ebx
40000c50:	31 c0                	xor    %eax,%eax
40000c52:	eb e1                	jmp    40000c35 <strcmp+0x45>
40000c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000c58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c5f:	00 

40000c60 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
40000c60:	55                   	push   %ebp
40000c61:	89 e5                	mov    %esp,%ebp
40000c63:	53                   	push   %ebx
40000c64:	8b 55 10             	mov    0x10(%ebp),%edx
40000c67:	8b 45 08             	mov    0x8(%ebp),%eax
40000c6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
40000c6d:	85 d2                	test   %edx,%edx
40000c6f:	75 16                	jne    40000c87 <strncmp+0x27>
40000c71:	eb 2d                	jmp    40000ca0 <strncmp+0x40>
40000c73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c78:	3a 19                	cmp    (%ecx),%bl
40000c7a:	75 12                	jne    40000c8e <strncmp+0x2e>
		n--, p++, q++;
40000c7c:	83 c0 01             	add    $0x1,%eax
40000c7f:	83 c1 01             	add    $0x1,%ecx
	while (n > 0 && *p && *p == *q)
40000c82:	83 ea 01             	sub    $0x1,%edx
40000c85:	74 19                	je     40000ca0 <strncmp+0x40>
40000c87:	0f b6 18             	movzbl (%eax),%ebx
40000c8a:	84 db                	test   %bl,%bl
40000c8c:	75 ea                	jne    40000c78 <strncmp+0x18>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000c8e:	0f b6 00             	movzbl (%eax),%eax
40000c91:	0f b6 11             	movzbl (%ecx),%edx
}
40000c94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c97:	c9                   	leave
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000c98:	29 d0                	sub    %edx,%eax
}
40000c9a:	c3                   	ret
40000c9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ca0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
		return 0;
40000ca3:	31 c0                	xor    %eax,%eax
}
40000ca5:	c9                   	leave
40000ca6:	c3                   	ret
40000ca7:	90                   	nop
40000ca8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000caf:	00 

40000cb0 <strchr>:

char *
strchr(const char *s, char c)
{
40000cb0:	55                   	push   %ebp
40000cb1:	89 e5                	mov    %esp,%ebp
40000cb3:	8b 45 08             	mov    0x8(%ebp),%eax
40000cb6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
40000cba:	0f b6 10             	movzbl (%eax),%edx
40000cbd:	84 d2                	test   %dl,%dl
40000cbf:	75 1a                	jne    40000cdb <strchr+0x2b>
40000cc1:	eb 25                	jmp    40000ce8 <strchr+0x38>
40000cc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000cc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ccf:	00 
40000cd0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000cd4:	83 c0 01             	add    $0x1,%eax
40000cd7:	84 d2                	test   %dl,%dl
40000cd9:	74 0d                	je     40000ce8 <strchr+0x38>
		if (*s == c)
40000cdb:	38 d1                	cmp    %dl,%cl
40000cdd:	75 f1                	jne    40000cd0 <strchr+0x20>
			return (char *) s;
	return 0;
}
40000cdf:	5d                   	pop    %ebp
40000ce0:	c3                   	ret
40000ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return 0;
40000ce8:	31 c0                	xor    %eax,%eax
}
40000cea:	5d                   	pop    %ebp
40000ceb:	c3                   	ret
40000cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000cf0 <strfind>:

char *
strfind(const char *s, char c)
{
40000cf0:	55                   	push   %ebp
40000cf1:	89 e5                	mov    %esp,%ebp
40000cf3:	8b 45 08             	mov    0x8(%ebp),%eax
40000cf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	for (; *s; s++)
40000cf9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
40000cfc:	38 ca                	cmp    %cl,%dl
40000cfe:	75 1b                	jne    40000d1b <strfind+0x2b>
40000d00:	eb 1d                	jmp    40000d1f <strfind+0x2f>
40000d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000d08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d0f:	00 
	for (; *s; s++)
40000d10:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000d14:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
40000d17:	38 ca                	cmp    %cl,%dl
40000d19:	74 04                	je     40000d1f <strfind+0x2f>
40000d1b:	84 d2                	test   %dl,%dl
40000d1d:	75 f1                	jne    40000d10 <strfind+0x20>
			break;
	return (char *) s;
}
40000d1f:	5d                   	pop    %ebp
40000d20:	c3                   	ret
40000d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d2f:	00 

40000d30 <strtol>:


long
strtol(const char *s, char **endptr, int base)
{
40000d30:	55                   	push   %ebp
40000d31:	89 e5                	mov    %esp,%ebp
40000d33:	57                   	push   %edi
40000d34:	8b 55 08             	mov    0x8(%ebp),%edx
40000d37:	56                   	push   %esi
40000d38:	53                   	push   %ebx
40000d39:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
40000d3c:	0f b6 02             	movzbl (%edx),%eax
40000d3f:	3c 09                	cmp    $0x9,%al
40000d41:	74 0d                	je     40000d50 <strtol+0x20>
40000d43:	3c 20                	cmp    $0x20,%al
40000d45:	75 18                	jne    40000d5f <strtol+0x2f>
40000d47:	90                   	nop
40000d48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d4f:	00 
40000d50:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		s++;
40000d54:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
40000d57:	3c 20                	cmp    $0x20,%al
40000d59:	74 f5                	je     40000d50 <strtol+0x20>
40000d5b:	3c 09                	cmp    $0x9,%al
40000d5d:	74 f1                	je     40000d50 <strtol+0x20>

	// plus/minus sign
	if (*s == '+')
40000d5f:	3c 2b                	cmp    $0x2b,%al
40000d61:	0f 84 89 00 00 00    	je     40000df0 <strtol+0xc0>
		s++;
	else if (*s == '-')
		s++, neg = 1;
40000d67:	3c 2d                	cmp    $0x2d,%al
40000d69:	8d 4a 01             	lea    0x1(%edx),%ecx
40000d6c:	0f 94 c0             	sete   %al
40000d6f:	0f 44 d1             	cmove  %ecx,%edx
40000d72:	0f b6 c0             	movzbl %al,%eax

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000d75:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
40000d7b:	75 10                	jne    40000d8d <strtol+0x5d>
40000d7d:	80 3a 30             	cmpb   $0x30,(%edx)
40000d80:	74 7e                	je     40000e00 <strtol+0xd0>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
40000d82:	83 fb 01             	cmp    $0x1,%ebx
40000d85:	19 db                	sbb    %ebx,%ebx
40000d87:	83 e3 fa             	and    $0xfffffffa,%ebx
40000d8a:	83 c3 10             	add    $0x10,%ebx
40000d8d:	89 5d 10             	mov    %ebx,0x10(%ebp)
40000d90:	31 c9                	xor    %ecx,%ecx
40000d92:	89 c7                	mov    %eax,%edi
40000d94:	eb 13                	jmp    40000da9 <strtol+0x79>
40000d96:	66 90                	xchg   %ax,%ax
40000d98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d9f:	00 
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
		s++, val = (val * base) + dig;
40000da0:	0f af 4d 10          	imul   0x10(%ebp),%ecx
40000da4:	83 c2 01             	add    $0x1,%edx
40000da7:	01 f1                	add    %esi,%ecx
		if (*s >= '0' && *s <= '9')
40000da9:	0f be 1a             	movsbl (%edx),%ebx
40000dac:	8d 43 d0             	lea    -0x30(%ebx),%eax
			dig = *s - '0';
40000daf:	8d 73 d0             	lea    -0x30(%ebx),%esi
		if (*s >= '0' && *s <= '9')
40000db2:	3c 09                	cmp    $0x9,%al
40000db4:	76 14                	jbe    40000dca <strtol+0x9a>
		else if (*s >= 'a' && *s <= 'z')
40000db6:	8d 43 9f             	lea    -0x61(%ebx),%eax
			dig = *s - 'a' + 10;
40000db9:	8d 73 a9             	lea    -0x57(%ebx),%esi
		else if (*s >= 'a' && *s <= 'z')
40000dbc:	3c 19                	cmp    $0x19,%al
40000dbe:	76 0a                	jbe    40000dca <strtol+0x9a>
		else if (*s >= 'A' && *s <= 'Z')
40000dc0:	8d 43 bf             	lea    -0x41(%ebx),%eax
40000dc3:	3c 19                	cmp    $0x19,%al
40000dc5:	77 08                	ja     40000dcf <strtol+0x9f>
			dig = *s - 'A' + 10;
40000dc7:	8d 73 c9             	lea    -0x37(%ebx),%esi
		if (dig >= base)
40000dca:	3b 75 10             	cmp    0x10(%ebp),%esi
40000dcd:	7c d1                	jl     40000da0 <strtol+0x70>
		// we don't properly detect overflow!
	}

	if (endptr)
40000dcf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000dd2:	89 f8                	mov    %edi,%eax
40000dd4:	85 db                	test   %ebx,%ebx
40000dd6:	74 05                	je     40000ddd <strtol+0xad>
		*endptr = (char *) s;
40000dd8:	8b 7d 0c             	mov    0xc(%ebp),%edi
40000ddb:	89 17                	mov    %edx,(%edi)
	return (neg ? -val : val);
40000ddd:	89 ca                	mov    %ecx,%edx
}
40000ddf:	5b                   	pop    %ebx
40000de0:	5e                   	pop    %esi
	return (neg ? -val : val);
40000de1:	f7 da                	neg    %edx
40000de3:	85 c0                	test   %eax,%eax
}
40000de5:	5f                   	pop    %edi
40000de6:	5d                   	pop    %ebp
	return (neg ? -val : val);
40000de7:	0f 45 ca             	cmovne %edx,%ecx
}
40000dea:	89 c8                	mov    %ecx,%eax
40000dec:	c3                   	ret
40000ded:	8d 76 00             	lea    0x0(%esi),%esi
		s++;
40000df0:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
40000df3:	31 c0                	xor    %eax,%eax
40000df5:	e9 7b ff ff ff       	jmp    40000d75 <strtol+0x45>
40000dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000e00:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
40000e04:	74 1b                	je     40000e21 <strtol+0xf1>
	else if (base == 0 && s[0] == '0')
40000e06:	85 db                	test   %ebx,%ebx
40000e08:	74 0a                	je     40000e14 <strtol+0xe4>
40000e0a:	bb 10 00 00 00       	mov    $0x10,%ebx
40000e0f:	e9 79 ff ff ff       	jmp    40000d8d <strtol+0x5d>
		s++, base = 8;
40000e14:	83 c2 01             	add    $0x1,%edx
40000e17:	bb 08 00 00 00       	mov    $0x8,%ebx
40000e1c:	e9 6c ff ff ff       	jmp    40000d8d <strtol+0x5d>
		s += 2, base = 16;
40000e21:	83 c2 02             	add    $0x2,%edx
40000e24:	bb 10 00 00 00       	mov    $0x10,%ebx
40000e29:	e9 5f ff ff ff       	jmp    40000d8d <strtol+0x5d>
40000e2e:	66 90                	xchg   %ax,%ax

40000e30 <memset>:

void *
memset(void *v, int c, size_t n)
{
40000e30:	55                   	push   %ebp
40000e31:	89 e5                	mov    %esp,%ebp
40000e33:	57                   	push   %edi
40000e34:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000e37:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000e3a:	85 c9                	test   %ecx,%ecx
40000e3c:	74 1a                	je     40000e58 <memset+0x28>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
40000e3e:	89 d0                	mov    %edx,%eax
40000e40:	09 c8                	or     %ecx,%eax
40000e42:	a8 03                	test   $0x3,%al
40000e44:	75 1a                	jne    40000e60 <memset+0x30>
		c &= 0xFF;
40000e46:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
40000e4a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000e4d:	89 d7                	mov    %edx,%edi
40000e4f:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
40000e55:	fc                   	cld
40000e56:	f3 ab                	rep stos %eax,%es:(%edi)
	} else
		asm volatile("cld; rep stosb\n"
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
}
40000e58:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000e5b:	89 d0                	mov    %edx,%eax
40000e5d:	c9                   	leave
40000e5e:	c3                   	ret
40000e5f:	90                   	nop
		asm volatile("cld; rep stosb\n"
40000e60:	8b 45 0c             	mov    0xc(%ebp),%eax
40000e63:	89 d7                	mov    %edx,%edi
40000e65:	fc                   	cld
40000e66:	f3 aa                	rep stos %al,%es:(%edi)
}
40000e68:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000e6b:	89 d0                	mov    %edx,%eax
40000e6d:	c9                   	leave
40000e6e:	c3                   	ret
40000e6f:	90                   	nop

40000e70 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
40000e70:	55                   	push   %ebp
40000e71:	89 e5                	mov    %esp,%ebp
40000e73:	57                   	push   %edi
40000e74:	8b 45 08             	mov    0x8(%ebp),%eax
40000e77:	8b 55 0c             	mov    0xc(%ebp),%edx
40000e7a:	56                   	push   %esi
40000e7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000e7e:	53                   	push   %ebx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
40000e7f:	39 c2                	cmp    %eax,%edx
40000e81:	73 2d                	jae    40000eb0 <memmove+0x40>
40000e83:	8d 1c 0a             	lea    (%edx,%ecx,1),%ebx
40000e86:	39 d8                	cmp    %ebx,%eax
40000e88:	73 26                	jae    40000eb0 <memmove+0x40>
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000e8a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
40000e8d:	09 ca                	or     %ecx,%edx
40000e8f:	09 da                	or     %ebx,%edx
40000e91:	83 e2 03             	and    $0x3,%edx
40000e94:	74 4a                	je     40000ee0 <memmove+0x70>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
				     : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
40000e96:	8d 7c 08 ff          	lea    -0x1(%eax,%ecx,1),%edi
40000e9a:	8d 73 ff             	lea    -0x1(%ebx),%esi
40000e9d:	fd                   	std
40000e9e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				     :: "D" (d-1), "S" (s-1), "c" (n)
				     : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
40000ea0:	fc                   	cld
			asm volatile("cld; rep movsb\n"
				     :: "D" (d), "S" (s), "c" (n)
				     : "cc", "memory");
	}
	return dst;
}
40000ea1:	5b                   	pop    %ebx
40000ea2:	5e                   	pop    %esi
40000ea3:	5f                   	pop    %edi
40000ea4:	5d                   	pop    %ebp
40000ea5:	c3                   	ret
40000ea6:	66 90                	xchg   %ax,%ax
40000ea8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000eaf:	00 
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000eb0:	89 c3                	mov    %eax,%ebx
40000eb2:	09 cb                	or     %ecx,%ebx
40000eb4:	09 d3                	or     %edx,%ebx
40000eb6:	83 e3 03             	and    $0x3,%ebx
40000eb9:	74 15                	je     40000ed0 <memmove+0x60>
			asm volatile("cld; rep movsb\n"
40000ebb:	89 c7                	mov    %eax,%edi
40000ebd:	89 d6                	mov    %edx,%esi
40000ebf:	fc                   	cld
40000ec0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000ec2:	5b                   	pop    %ebx
40000ec3:	5e                   	pop    %esi
40000ec4:	5f                   	pop    %edi
40000ec5:	5d                   	pop    %ebp
40000ec6:	c3                   	ret
40000ec7:	90                   	nop
40000ec8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ecf:	00 
				     :: "D" (d), "S" (s), "c" (n/4)
40000ed0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
40000ed3:	89 c7                	mov    %eax,%edi
40000ed5:	89 d6                	mov    %edx,%esi
40000ed7:	fc                   	cld
40000ed8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000eda:	eb e6                	jmp    40000ec2 <memmove+0x52>
40000edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			asm volatile("std; rep movsl\n"
40000ee0:	8d 7c 08 fc          	lea    -0x4(%eax,%ecx,1),%edi
40000ee4:	8d 73 fc             	lea    -0x4(%ebx),%esi
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
40000ee7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
40000eea:	fd                   	std
40000eeb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000eed:	eb b1                	jmp    40000ea0 <memmove+0x30>
40000eef:	90                   	nop

40000ef0 <memcpy>:

void *
memcpy(void *dst, const void *src, size_t n)
{
	return memmove(dst, src, n);
40000ef0:	e9 7b ff ff ff       	jmp    40000e70 <memmove>
40000ef5:	8d 76 00             	lea    0x0(%esi),%esi
40000ef8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000eff:	00 

40000f00 <memcmp>:
}

int
memcmp(const void *v1, const void *v2, size_t n)
{
40000f00:	55                   	push   %ebp
40000f01:	89 e5                	mov    %esp,%ebp
40000f03:	56                   	push   %esi
40000f04:	8b 75 10             	mov    0x10(%ebp),%esi
40000f07:	8b 45 08             	mov    0x8(%ebp),%eax
40000f0a:	53                   	push   %ebx
40000f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
40000f0e:	85 f6                	test   %esi,%esi
40000f10:	74 2e                	je     40000f40 <memcmp+0x40>
40000f12:	01 c6                	add    %eax,%esi
40000f14:	eb 14                	jmp    40000f2a <memcmp+0x2a>
40000f16:	66 90                	xchg   %ax,%ax
40000f18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f1f:	00 
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
40000f20:	83 c0 01             	add    $0x1,%eax
40000f23:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
40000f26:	39 f0                	cmp    %esi,%eax
40000f28:	74 16                	je     40000f40 <memcmp+0x40>
		if (*s1 != *s2)
40000f2a:	0f b6 08             	movzbl (%eax),%ecx
40000f2d:	0f b6 1a             	movzbl (%edx),%ebx
40000f30:	38 d9                	cmp    %bl,%cl
40000f32:	74 ec                	je     40000f20 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
40000f34:	0f b6 c1             	movzbl %cl,%eax
40000f37:	29 d8                	sub    %ebx,%eax
	}

	return 0;
}
40000f39:	5b                   	pop    %ebx
40000f3a:	5e                   	pop    %esi
40000f3b:	5d                   	pop    %ebp
40000f3c:	c3                   	ret
40000f3d:	8d 76 00             	lea    0x0(%esi),%esi
40000f40:	5b                   	pop    %ebx
	return 0;
40000f41:	31 c0                	xor    %eax,%eax
}
40000f43:	5e                   	pop    %esi
40000f44:	5d                   	pop    %ebp
40000f45:	c3                   	ret
40000f46:	66 90                	xchg   %ax,%ax
40000f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f4f:	00 

40000f50 <memchr>:

void *
memchr(const void *s, int c, size_t n)
{
40000f50:	55                   	push   %ebp
40000f51:	89 e5                	mov    %esp,%ebp
40000f53:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
40000f56:	8b 55 10             	mov    0x10(%ebp),%edx
40000f59:	01 c2                	add    %eax,%edx
	for (; s < ends; s++)
40000f5b:	39 d0                	cmp    %edx,%eax
40000f5d:	73 21                	jae    40000f80 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000f5f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
40000f63:	eb 12                	jmp    40000f77 <memchr+0x27>
40000f65:	8d 76 00             	lea    0x0(%esi),%esi
40000f68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f6f:	00 
	for (; s < ends; s++)
40000f70:	83 c0 01             	add    $0x1,%eax
40000f73:	39 c2                	cmp    %eax,%edx
40000f75:	74 09                	je     40000f80 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000f77:	38 08                	cmp    %cl,(%eax)
40000f79:	75 f5                	jne    40000f70 <memchr+0x20>
			return (void *) s;
	return NULL;
}
40000f7b:	5d                   	pop    %ebp
40000f7c:	c3                   	ret
40000f7d:	8d 76 00             	lea    0x0(%esi),%esi
	return NULL;
40000f80:	31 c0                	xor    %eax,%eax
}
40000f82:	5d                   	pop    %ebp
40000f83:	c3                   	ret
40000f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000f88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f8f:	00 

40000f90 <memzero>:

void *
memzero(void *v, size_t n)
{
40000f90:	55                   	push   %ebp
40000f91:	89 e5                	mov    %esp,%ebp
40000f93:	57                   	push   %edi
40000f94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000f97:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000f9a:	85 c9                	test   %ecx,%ecx
40000f9c:	74 11                	je     40000faf <memzero+0x1f>
	if ((int)v%4 == 0 && n%4 == 0) {
40000f9e:	89 d0                	mov    %edx,%eax
40000fa0:	09 c8                	or     %ecx,%eax
40000fa2:	83 e0 03             	and    $0x3,%eax
40000fa5:	75 19                	jne    40000fc0 <memzero+0x30>
			     :: "D" (v), "a" (c), "c" (n/4)
40000fa7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000faa:	89 d7                	mov    %edx,%edi
40000fac:	fc                   	cld
40000fad:	f3 ab                	rep stos %eax,%es:(%edi)
	return memset(v, 0, n);
}
40000faf:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000fb2:	89 d0                	mov    %edx,%eax
40000fb4:	c9                   	leave
40000fb5:	c3                   	ret
40000fb6:	66 90                	xchg   %ax,%ax
40000fb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000fbf:	00 
		asm volatile("cld; rep stosb\n"
40000fc0:	89 d7                	mov    %edx,%edi
40000fc2:	31 c0                	xor    %eax,%eax
40000fc4:	fc                   	cld
40000fc5:	f3 aa                	rep stos %al,%es:(%edi)
}
40000fc7:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000fca:	89 d0                	mov    %edx,%eax
40000fcc:	c9                   	leave
40000fcd:	c3                   	ret
40000fce:	66 90                	xchg   %ax,%ax

40000fd0 <sigaction>:
#include <signal.h>
#include <syscall.h>

int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
40000fd0:	55                   	push   %ebp

static gcc_inline int
sys_sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
	int errno;
	asm volatile ("int %1"
40000fd1:	b8 1a 00 00 00       	mov    $0x1a,%eax
40000fd6:	89 e5                	mov    %esp,%ebp
40000fd8:	53                   	push   %ebx
40000fd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000fdc:	8b 55 10             	mov    0x10(%ebp),%edx
40000fdf:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000fe2:	cd 30                	int    $0x30
		        "a" (SYS_sigaction),
		        "b" (signum),
		        "c" (act),
		        "d" (oldact)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000fe4:	f7 d8                	neg    %eax
    return sys_sigaction(signum, act, oldact);
}
40000fe6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000fe9:	c9                   	leave
40000fea:	19 c0                	sbb    %eax,%eax
40000fec:	c3                   	ret
40000fed:	8d 76 00             	lea    0x0(%esi),%esi

40000ff0 <kill>:

int kill(int pid, int signum)
{
40000ff0:	55                   	push   %ebp

static gcc_inline int
sys_kill(int pid, int signum)
{
	int errno;
	asm volatile ("int %1"
40000ff1:	b8 1b 00 00 00       	mov    $0x1b,%eax
40000ff6:	89 e5                	mov    %esp,%ebp
40000ff8:	53                   	push   %ebx
40000ff9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000ffc:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000fff:	cd 30                	int    $0x30
		      : "i" (T_SYSCALL),
		        "a" (SYS_kill),
		        "b" (pid),
		        "c" (signum)
		      : "cc", "memory");
	return errno ? -1 : 0;
40001001:	f7 d8                	neg    %eax
    return sys_kill(pid, signum);
}
40001003:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40001006:	c9                   	leave
40001007:	19 c0                	sbb    %eax,%eax
40001009:	c3                   	ret
4000100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40001010 <pause>:

static gcc_inline int
sys_pause(void)
{
	int errno;
	asm volatile ("int %1"
40001010:	b8 1c 00 00 00       	mov    $0x1c,%eax
40001015:	cd 30                	int    $0x30
		      : "=a" (errno)
		      : "i" (T_SYSCALL),
		        "a" (SYS_pause)
		      : "cc", "memory");
	return errno ? -1 : 0;
40001017:	f7 d8                	neg    %eax
40001019:	19 c0                	sbb    %eax,%eax

int pause(void)
{
    return sys_pause();
}
4000101b:	c3                   	ret
4000101c:	66 90                	xchg   %ax,%ax
4000101e:	66 90                	xchg   %ax,%ax

40001020 <smallfile>:
{
40001020:	55                   	push   %ebp
40001021:	89 e5                	mov    %esp,%ebp
40001023:	57                   	push   %edi
40001024:	56                   	push   %esi
40001025:	53                   	push   %ebx
	asm volatile("int %2"
40001026:	bb 8f 32 00 40       	mov    $0x4000328f,%ebx
4000102b:	83 ec 18             	sub    $0x18,%esp
  printf("=====small file test=====\n");
4000102e:	68 74 32 00 40       	push   $0x40003274
40001033:	e8 08 f3 ff ff       	call   40000340 <printf>
        unsigned int len = strlen(path);
40001038:	c7 04 24 8f 32 00 40 	movl   $0x4000328f,(%esp)
4000103f:	e8 9c fa ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001044:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
40001049:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
4000104b:	b8 05 00 00 00       	mov    $0x5,%eax
40001050:	cd 30                	int    $0x30
	return errno ? -1 : fd;
40001052:	83 c4 10             	add    $0x10,%esp
  if(fd >= 0){
40001055:	85 c0                	test   %eax,%eax
40001057:	0f 85 13 01 00 00    	jne    40001170 <smallfile+0x150>
4000105d:	89 de                	mov    %ebx,%esi
4000105f:	85 db                	test   %ebx,%ebx
40001061:	0f 88 09 01 00 00    	js     40001170 <smallfile+0x150>
    printf("creat small succeeded; ok, fd: %d\n", fd);
40001067:	83 ec 08             	sub    $0x8,%esp
  for(i = 0; i < 100; i++){
4000106a:	31 ff                	xor    %edi,%edi
    printf("creat small succeeded; ok, fd: %d\n", fd);
4000106c:	53                   	push   %ebx
4000106d:	68 40 3e 00 40       	push   $0x40003e40
40001072:	e8 c9 f2 ff ff       	call   40000340 <printf>
40001077:	83 c4 10             	add    $0x10,%esp
	asm volatile("int %2"
4000107a:	ba 0a 00 00 00       	mov    $0xa,%edx
4000107f:	b8 08 00 00 00       	mov    $0x8,%eax
40001084:	89 f3                	mov    %esi,%ebx
40001086:	b9 b1 32 00 40       	mov    $0x400032b1,%ecx
4000108b:	cd 30                	int    $0x30
    if(write(fd, "aaaaaaaaaa", 10) != 10){
4000108d:	83 fb 0a             	cmp    $0xa,%ebx
40001090:	0f 85 ba 00 00 00    	jne    40001150 <smallfile+0x130>
40001096:	85 c0                	test   %eax,%eax
40001098:	0f 85 b2 00 00 00    	jne    40001150 <smallfile+0x130>
4000109e:	b9 bc 32 00 40       	mov    $0x400032bc,%ecx
400010a3:	b8 08 00 00 00       	mov    $0x8,%eax
400010a8:	89 f3                	mov    %esi,%ebx
400010aa:	cd 30                	int    $0x30
    if(write(fd, "bbbbbbbbbb", 10) != 10){
400010ac:	83 fb 0a             	cmp    $0xa,%ebx
400010af:	0f 85 db 00 00 00    	jne    40001190 <smallfile+0x170>
400010b5:	85 c0                	test   %eax,%eax
400010b7:	0f 85 d3 00 00 00    	jne    40001190 <smallfile+0x170>
  for(i = 0; i < 100; i++){
400010bd:	83 c7 01             	add    $0x1,%edi
400010c0:	83 ff 64             	cmp    $0x64,%edi
400010c3:	75 ba                	jne    4000107f <smallfile+0x5f>
  printf("writes ok\n");
400010c5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400010c8:	89 f3                	mov    %esi,%ebx
400010ca:	68 c7 32 00 40       	push   $0x400032c7
400010cf:	e8 6c f2 ff ff       	call   40000340 <printf>
400010d4:	b8 06 00 00 00       	mov    $0x6,%eax
400010d9:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
400010db:	c7 04 24 8f 32 00 40 	movl   $0x4000328f,(%esp)
	asm volatile("int %2"
400010e2:	bb 8f 32 00 40       	mov    $0x4000328f,%ebx
        unsigned int len = strlen(path);
400010e7:	e8 f4 f9 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
400010ec:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
400010ee:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
400010f0:	b8 05 00 00 00       	mov    $0x5,%eax
400010f5:	cd 30                	int    $0x30
400010f7:	89 df                	mov    %ebx,%edi
  if(fd >= 0){
400010f9:	83 c4 10             	add    $0x10,%esp
400010fc:	85 db                	test   %ebx,%ebx
400010fe:	0f 88 a5 00 00 00    	js     400011a9 <smallfile+0x189>
40001104:	85 c0                	test   %eax,%eax
40001106:	0f 85 9d 00 00 00    	jne    400011a9 <smallfile+0x189>
    printf("open small succeeded ok\n");
4000110c:	83 ec 0c             	sub    $0xc,%esp
4000110f:	68 d2 32 00 40       	push   $0x400032d2
40001114:	e8 27 f2 ff ff       	call   40000340 <printf>
	asm volatile("int %2"
40001119:	b8 07 00 00 00       	mov    $0x7,%eax
4000111e:	b9 a0 54 00 40       	mov    $0x400054a0,%ecx
40001123:	ba d0 07 00 00       	mov    $0x7d0,%edx
40001128:	cd 30                	int    $0x30
  if(i == 2000){
4000112a:	83 c4 10             	add    $0x10,%esp
4000112d:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
40001133:	75 08                	jne    4000113d <smallfile+0x11d>
40001135:	85 c0                	test   %eax,%eax
40001137:	0f 84 7e 00 00 00    	je     400011bb <smallfile+0x19b>
    printf("read failed\n");
4000113d:	83 ec 0c             	sub    $0xc,%esp
40001140:	68 49 3a 00 40       	push   $0x40003a49
40001145:	e8 f6 f1 ff ff       	call   40000340 <printf>
    exit();
4000114a:	83 c4 10             	add    $0x10,%esp
4000114d:	eb 12                	jmp    40001161 <smallfile+0x141>
4000114f:	90                   	nop
      printf("error: write aa %d new file failed\n", i);
40001150:	83 ec 08             	sub    $0x8,%esp
40001153:	57                   	push   %edi
40001154:	68 64 3e 00 40       	push   $0x40003e64
40001159:	e8 e2 f1 ff ff       	call   40000340 <printf>
      exit();
4000115e:	83 c4 10             	add    $0x10,%esp
}
40001161:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001164:	5b                   	pop    %ebx
40001165:	5e                   	pop    %esi
40001166:	5f                   	pop    %edi
40001167:	5d                   	pop    %ebp
40001168:	c3                   	ret
40001169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    printf("error: creat small failed!\n");
40001170:	83 ec 0c             	sub    $0xc,%esp
40001173:	68 95 32 00 40       	push   $0x40003295
40001178:	e8 c3 f1 ff ff       	call   40000340 <printf>
    exit();
4000117d:	83 c4 10             	add    $0x10,%esp
}
40001180:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001183:	5b                   	pop    %ebx
40001184:	5e                   	pop    %esi
40001185:	5f                   	pop    %edi
40001186:	5d                   	pop    %ebp
40001187:	c3                   	ret
40001188:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000118f:	00 
      printf("error: write bb %d new file failed\n", i);
40001190:	83 ec 08             	sub    $0x8,%esp
40001193:	57                   	push   %edi
40001194:	68 88 3e 00 40       	push   $0x40003e88
40001199:	e8 a2 f1 ff ff       	call   40000340 <printf>
      exit();
4000119e:	83 c4 10             	add    $0x10,%esp
}
400011a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
400011a4:	5b                   	pop    %ebx
400011a5:	5e                   	pop    %esi
400011a6:	5f                   	pop    %edi
400011a7:	5d                   	pop    %ebp
400011a8:	c3                   	ret
    printf("error: open small failed!\n");
400011a9:	83 ec 0c             	sub    $0xc,%esp
400011ac:	68 eb 32 00 40       	push   $0x400032eb
400011b1:	e8 8a f1 ff ff       	call   40000340 <printf>
    exit();
400011b6:	83 c4 10             	add    $0x10,%esp
400011b9:	eb a6                	jmp    40001161 <smallfile+0x141>
    printf("read succeeded ok\n");
400011bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400011be:	89 fb                	mov    %edi,%ebx
400011c0:	68 06 33 00 40       	push   $0x40003306
400011c5:	e8 76 f1 ff ff       	call   40000340 <printf>
400011ca:	b8 06 00 00 00       	mov    $0x6,%eax
400011cf:	cd 30                	int    $0x30
  unsigned int len = strlen(path);
400011d1:	c7 04 24 8f 32 00 40 	movl   $0x4000328f,(%esp)
	asm volatile("int %2"
400011d8:	bb 8f 32 00 40       	mov    $0x4000328f,%ebx
  unsigned int len = strlen(path);
400011dd:	e8 fe f8 ff ff       	call   40000ae0 <strlen>
400011e2:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400011e4:	b8 0d 00 00 00       	mov    $0xd,%eax
400011e9:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400011eb:	83 c4 10             	add    $0x10,%esp
400011ee:	85 c0                	test   %eax,%eax
400011f0:	75 15                	jne    40001207 <smallfile+0x1e7>
  printf("=====small file test ok=====\n\n");
400011f2:	83 ec 0c             	sub    $0xc,%esp
400011f5:	68 ac 3e 00 40       	push   $0x40003eac
400011fa:	e8 41 f1 ff ff       	call   40000340 <printf>
400011ff:	83 c4 10             	add    $0x10,%esp
40001202:	e9 5a ff ff ff       	jmp    40001161 <smallfile+0x141>
    printf("unlink small failed\n");
40001207:	83 ec 0c             	sub    $0xc,%esp
4000120a:	68 19 33 00 40       	push   $0x40003319
4000120f:	e8 2c f1 ff ff       	call   40000340 <printf>
    exit();
40001214:	83 c4 10             	add    $0x10,%esp
40001217:	e9 45 ff ff ff       	jmp    40001161 <smallfile+0x141>
4000121c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40001220 <bigfile1>:
{
40001220:	55                   	push   %ebp
40001221:	89 e5                	mov    %esp,%ebp
40001223:	57                   	push   %edi
40001224:	56                   	push   %esi
40001225:	53                   	push   %ebx
	asm volatile("int %2"
40001226:	bb b2 33 00 40       	mov    $0x400033b2,%ebx
4000122b:	83 ec 28             	sub    $0x28,%esp
  printf("=====big files test=====\n");
4000122e:	68 2e 33 00 40       	push   $0x4000332e
40001233:	e8 08 f1 ff ff       	call   40000340 <printf>
        unsigned int len = strlen(path);
40001238:	c7 04 24 b2 33 00 40 	movl   $0x400033b2,(%esp)
4000123f:	e8 9c f8 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001244:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
40001249:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
4000124b:	b8 05 00 00 00       	mov    $0x5,%eax
40001250:	cd 30                	int    $0x30
	return errno ? -1 : fd;
40001252:	83 c4 10             	add    $0x10,%esp
  if(fd < 0){
40001255:	85 c0                	test   %eax,%eax
40001257:	0f 85 e3 00 00 00    	jne    40001340 <bigfile1+0x120>
  for(i = 0; i < MAXFILE; i++){
4000125d:	31 f6                	xor    %esi,%esi
  if(fd < 0){
4000125f:	85 db                	test   %ebx,%ebx
40001261:	0f 88 d9 00 00 00    	js     40001340 <bigfile1+0x120>
40001267:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    ((int*)buf)[0] = i;
4000126a:	89 35 a0 54 00 40    	mov    %esi,0x400054a0
	asm volatile("int %2"
40001270:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
40001273:	b8 08 00 00 00       	mov    $0x8,%eax
40001278:	b9 a0 54 00 40       	mov    $0x400054a0,%ecx
4000127d:	ba 00 02 00 00       	mov    $0x200,%edx
40001282:	cd 30                	int    $0x30
    if(write(fd, buf, 512) != 512){
40001284:	85 c0                	test   %eax,%eax
40001286:	0f 85 94 00 00 00    	jne    40001320 <bigfile1+0x100>
4000128c:	81 fb 00 02 00 00    	cmp    $0x200,%ebx
40001292:	0f 85 88 00 00 00    	jne    40001320 <bigfile1+0x100>
  for(i = 0; i < MAXFILE; i++){
40001298:	83 c6 01             	add    $0x1,%esi
4000129b:	81 fe 8c 00 00 00    	cmp    $0x8c,%esi
400012a1:	75 c7                	jne    4000126a <bigfile1+0x4a>
	asm volatile("int %2"
400012a3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
400012a6:	b8 06 00 00 00       	mov    $0x6,%eax
400012ab:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
400012ad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400012b0:	bb b2 33 00 40       	mov    $0x400033b2,%ebx
        unsigned int len = strlen(path);
400012b5:	68 b2 33 00 40       	push   $0x400033b2
400012ba:	e8 21 f8 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
400012bf:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
400012c1:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
400012c3:	b8 05 00 00 00       	mov    $0x5,%eax
400012c8:	cd 30                	int    $0x30
400012ca:	89 de                	mov    %ebx,%esi
  if(fd < 0){
400012cc:	83 c4 10             	add    $0x10,%esp
400012cf:	85 db                	test   %ebx,%ebx
400012d1:	0f 88 cb 00 00 00    	js     400013a2 <bigfile1+0x182>
400012d7:	85 c0                	test   %eax,%eax
400012d9:	0f 85 c3 00 00 00    	jne    400013a2 <bigfile1+0x182>
	asm volatile("int %2"
400012df:	b8 07 00 00 00       	mov    $0x7,%eax
400012e4:	b9 a0 54 00 40       	mov    $0x400054a0,%ecx
400012e9:	ba 00 02 00 00       	mov    $0x200,%edx
400012ee:	cd 30                	int    $0x30
400012f0:	89 da                	mov    %ebx,%edx
400012f2:	89 c7                	mov    %eax,%edi
	return errno ? -1 : ret;
400012f4:	85 c0                	test   %eax,%eax
400012f6:	74 7f                	je     40001377 <bigfile1+0x157>
400012f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400012ff:	00 
  for(i = 0; i < MAXFILE; i++){
40001300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      printf("read failed %d\n", i);
40001305:	83 ec 08             	sub    $0x8,%esp
40001308:	50                   	push   %eax
40001309:	68 b6 33 00 40       	push   $0x400033b6
4000130e:	e8 2d f0 ff ff       	call   40000340 <printf>
      exit();
40001313:	83 c4 10             	add    $0x10,%esp
40001316:	eb 19                	jmp    40001331 <bigfile1+0x111>
40001318:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000131f:	00 
      printf("error: write big file failed\n", i);
40001320:	83 ec 08             	sub    $0x8,%esp
40001323:	56                   	push   %esi
40001324:	68 62 33 00 40       	push   $0x40003362
40001329:	e8 12 f0 ff ff       	call   40000340 <printf>
      exit();
4000132e:	83 c4 10             	add    $0x10,%esp
}
40001331:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001334:	5b                   	pop    %ebx
40001335:	5e                   	pop    %esi
40001336:	5f                   	pop    %edi
40001337:	5d                   	pop    %ebp
40001338:	c3                   	ret
40001339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    printf("error: creat big failed!\n");
40001340:	83 ec 0c             	sub    $0xc,%esp
40001343:	68 48 33 00 40       	push   $0x40003348
40001348:	e8 f3 ef ff ff       	call   40000340 <printf>
    exit();
4000134d:	83 c4 10             	add    $0x10,%esp
}
40001350:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001353:	5b                   	pop    %ebx
40001354:	5e                   	pop    %esi
40001355:	5f                   	pop    %edi
40001356:	5d                   	pop    %ebp
40001357:	c3                   	ret
40001358:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000135f:	00 
    n++;
40001360:	83 c7 01             	add    $0x1,%edi
	asm volatile("int %2"
40001363:	b8 07 00 00 00       	mov    $0x7,%eax
40001368:	89 f3                	mov    %esi,%ebx
4000136a:	b9 a0 54 00 40       	mov    $0x400054a0,%ecx
4000136f:	cd 30                	int    $0x30
40001371:	89 da                	mov    %ebx,%edx
	return errno ? -1 : ret;
40001373:	85 c0                	test   %eax,%eax
40001375:	75 89                	jne    40001300 <bigfile1+0xe0>
40001377:	89 d0                	mov    %edx,%eax
    if(i == 0){
40001379:	85 d2                	test   %edx,%edx
4000137b:	74 3a                	je     400013b7 <bigfile1+0x197>
    } else if(i != 512){
4000137d:	81 fa 00 02 00 00    	cmp    $0x200,%edx
40001383:	75 80                	jne    40001305 <bigfile1+0xe5>
    if(((int*)buf)[0] != n){
40001385:	a1 a0 54 00 40       	mov    0x400054a0,%eax
4000138a:	39 f8                	cmp    %edi,%eax
4000138c:	74 d2                	je     40001360 <bigfile1+0x140>
      printf("read content of block %d is %d\n",
4000138e:	83 ec 04             	sub    $0x4,%esp
40001391:	50                   	push   %eax
40001392:	57                   	push   %edi
40001393:	68 cc 3e 00 40       	push   $0x40003ecc
40001398:	e8 a3 ef ff ff       	call   40000340 <printf>
      exit();
4000139d:	83 c4 10             	add    $0x10,%esp
400013a0:	eb 8f                	jmp    40001331 <bigfile1+0x111>
    printf("error: open big failed!\n");
400013a2:	83 ec 0c             	sub    $0xc,%esp
400013a5:	68 80 33 00 40       	push   $0x40003380
400013aa:	e8 91 ef ff ff       	call   40000340 <printf>
    exit();
400013af:	83 c4 10             	add    $0x10,%esp
400013b2:	e9 7a ff ff ff       	jmp    40001331 <bigfile1+0x111>
      if(n == MAXFILE - 1){
400013b7:	81 ff 8b 00 00 00    	cmp    $0x8b,%edi
400013bd:	74 40                	je     400013ff <bigfile1+0x1df>
	asm volatile("int %2"
400013bf:	b8 06 00 00 00       	mov    $0x6,%eax
400013c4:	89 f3                	mov    %esi,%ebx
400013c6:	cd 30                	int    $0x30
  unsigned int len = strlen(path);
400013c8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400013cb:	bb b2 33 00 40       	mov    $0x400033b2,%ebx
  unsigned int len = strlen(path);
400013d0:	68 b2 33 00 40       	push   $0x400033b2
400013d5:	e8 06 f7 ff ff       	call   40000ae0 <strlen>
400013da:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400013dc:	b8 0d 00 00 00       	mov    $0xd,%eax
400013e1:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400013e3:	83 c4 10             	add    $0x10,%esp
400013e6:	85 c0                	test   %eax,%eax
400013e8:	75 2e                	jne    40001418 <bigfile1+0x1f8>
  printf("=====big files ok=====\n\n");
400013ea:	83 ec 0c             	sub    $0xc,%esp
400013ed:	68 c6 33 00 40       	push   $0x400033c6
400013f2:	e8 49 ef ff ff       	call   40000340 <printf>
400013f7:	83 c4 10             	add    $0x10,%esp
400013fa:	e9 32 ff ff ff       	jmp    40001331 <bigfile1+0x111>
        printf("read only %d blocks from big", n);
400013ff:	50                   	push   %eax
40001400:	50                   	push   %eax
40001401:	68 8b 00 00 00       	push   $0x8b
40001406:	68 99 33 00 40       	push   $0x40003399
4000140b:	e8 30 ef ff ff       	call   40000340 <printf>
        exit();
40001410:	83 c4 10             	add    $0x10,%esp
40001413:	e9 19 ff ff ff       	jmp    40001331 <bigfile1+0x111>
    printf("unlink big failed\n");
40001418:	83 ec 0c             	sub    $0xc,%esp
4000141b:	68 df 33 00 40       	push   $0x400033df
40001420:	e8 1b ef ff ff       	call   40000340 <printf>
    exit();
40001425:	83 c4 10             	add    $0x10,%esp
40001428:	e9 04 ff ff ff       	jmp    40001331 <bigfile1+0x111>
4000142d:	8d 76 00             	lea    0x0(%esi),%esi

40001430 <createtest>:
{
40001430:	55                   	push   %ebp
40001431:	89 e5                	mov    %esp,%ebp
40001433:	57                   	push   %edi
40001434:	56                   	push   %esi
  name[2] = '\0';
40001435:	be 30 00 00 00       	mov    $0x30,%esi
{
4000143a:	53                   	push   %ebx
4000143b:	83 ec 18             	sub    $0x18,%esp
  printf("=====many creates, followed by unlink test=====\n");
4000143e:	68 ec 3e 00 40       	push   $0x40003eec
40001443:	e8 f8 ee ff ff       	call   40000340 <printf>
  name[0] = 'a';
40001448:	c6 05 8a 54 00 40 61 	movb   $0x61,0x4000548a
  name[2] = '\0';
4000144f:	83 c4 10             	add    $0x10,%esp
40001452:	c6 05 8c 54 00 40 00 	movb   $0x0,0x4000548c
  for(i = 0; i < 52; i++){
40001459:	eb 15                	jmp    40001470 <createtest+0x40>
4000145b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
	asm volatile("int %2"
40001460:	b8 06 00 00 00       	mov    $0x6,%eax
40001465:	cd 30                	int    $0x30
40001467:	83 c6 01             	add    $0x1,%esi
4000146a:	89 f0                	mov    %esi,%eax
4000146c:	3c 64                	cmp    $0x64,%al
4000146e:	74 38                	je     400014a8 <createtest+0x78>
    name[1] = '0' + i;
40001470:	89 f0                	mov    %esi,%eax
        unsigned int len = strlen(path);
40001472:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001475:	bb 8a 54 00 40       	mov    $0x4000548a,%ebx
4000147a:	a2 8b 54 00 40       	mov    %al,0x4000548b
        unsigned int len = strlen(path);
4000147f:	68 8a 54 00 40       	push   $0x4000548a
40001484:	e8 57 f6 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001489:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
4000148e:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001490:	b8 05 00 00 00       	mov    $0x5,%eax
40001495:	cd 30                	int    $0x30
	return errno ? -1 : fd;
40001497:	83 c4 10             	add    $0x10,%esp
4000149a:	85 c0                	test   %eax,%eax
4000149c:	74 c2                	je     40001460 <createtest+0x30>
4000149e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
400014a3:	eb bb                	jmp    40001460 <createtest+0x30>
400014a5:	8d 76 00             	lea    0x0(%esi),%esi
  name[0] = 'a';
400014a8:	c6 05 8a 54 00 40 61 	movb   $0x61,0x4000548a
  name[2] = '\0';
400014af:	be 30 00 00 00       	mov    $0x30,%esi
400014b4:	c6 05 8c 54 00 40 00 	movb   $0x0,0x4000548c
  for(i = 0; i < 52; i++){
400014bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    name[1] = '0' + i;
400014c0:	89 f0                	mov    %esi,%eax
  unsigned int len = strlen(path);
400014c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400014c5:	bb 8a 54 00 40       	mov    $0x4000548a,%ebx
400014ca:	a2 8b 54 00 40       	mov    %al,0x4000548b
  unsigned int len = strlen(path);
400014cf:	68 8a 54 00 40       	push   $0x4000548a
400014d4:	e8 07 f6 ff ff       	call   40000ae0 <strlen>
400014d9:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400014db:	b8 0d 00 00 00       	mov    $0xd,%eax
400014e0:	cd 30                	int    $0x30
  for(i = 0; i < 52; i++){
400014e2:	83 c6 01             	add    $0x1,%esi
400014e5:	83 c4 10             	add    $0x10,%esp
400014e8:	89 f0                	mov    %esi,%eax
400014ea:	3c 64                	cmp    $0x64,%al
400014ec:	75 d2                	jne    400014c0 <createtest+0x90>
  printf("=====many creates, followed by unlink; ok=====\n\n");
400014ee:	83 ec 0c             	sub    $0xc,%esp
400014f1:	68 20 3f 00 40       	push   $0x40003f20
400014f6:	e8 45 ee ff ff       	call   40000340 <printf>
}
400014fb:	83 c4 10             	add    $0x10,%esp
400014fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001501:	5b                   	pop    %ebx
40001502:	5e                   	pop    %esi
40001503:	5f                   	pop    %edi
40001504:	5d                   	pop    %ebp
40001505:	c3                   	ret
40001506:	66 90                	xchg   %ax,%ax
40001508:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000150f:	00 

40001510 <rmdot>:
{
40001510:	55                   	push   %ebp
40001511:	89 e5                	mov    %esp,%ebp
40001513:	56                   	push   %esi
40001514:	53                   	push   %ebx
	asm volatile("int %2"
40001515:	bb 08 34 00 40       	mov    $0x40003408,%ebx
  printf("=====rmdot test=====\n");
4000151a:	83 ec 0c             	sub    $0xc,%esp
4000151d:	68 f2 33 00 40       	push   $0x400033f2
40001522:	e8 19 ee ff ff       	call   40000340 <printf>
  unsigned int len = strlen(path);
40001527:	c7 04 24 08 34 00 40 	movl   $0x40003408,(%esp)
4000152e:	e8 ad f5 ff ff       	call   40000ae0 <strlen>
40001533:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001535:	b8 0a 00 00 00       	mov    $0xa,%eax
4000153a:	cd 30                	int    $0x30
	return errno ? -1 : 0;
4000153c:	83 c4 10             	add    $0x10,%esp
4000153f:	85 c0                	test   %eax,%eax
40001541:	75 5d                	jne    400015a0 <rmdot+0x90>
  unsigned int len = strlen(path);
40001543:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001546:	bb 08 34 00 40       	mov    $0x40003408,%ebx
  unsigned int len = strlen(path);
4000154b:	68 08 34 00 40       	push   $0x40003408
40001550:	e8 8b f5 ff ff       	call   40000ae0 <strlen>
40001555:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001557:	b8 0b 00 00 00       	mov    $0xb,%eax
4000155c:	cd 30                	int    $0x30
	return errno ? -1 : 0;
4000155e:	83 c4 10             	add    $0x10,%esp
40001561:	85 c0                	test   %eax,%eax
40001563:	75 53                	jne    400015b8 <rmdot+0xa8>
  unsigned int len = strlen(path);
40001565:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001568:	bb 54 37 00 40       	mov    $0x40003754,%ebx
  unsigned int len = strlen(path);
4000156d:	68 54 37 00 40       	push   $0x40003754
40001572:	e8 69 f5 ff ff       	call   40000ae0 <strlen>
40001577:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001579:	b8 0d 00 00 00       	mov    $0xd,%eax
4000157e:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001580:	83 c4 10             	add    $0x10,%esp
40001583:	85 c0                	test   %eax,%eax
40001585:	75 49                	jne    400015d0 <rmdot+0xc0>
    printf("rm . worked!\n");
40001587:	83 ec 0c             	sub    $0xc,%esp
4000158a:	68 33 34 00 40       	push   $0x40003433
4000158f:	e8 ac ed ff ff       	call   40000340 <printf>
    exit();
40001594:	83 c4 10             	add    $0x10,%esp
}
40001597:	8d 65 f8             	lea    -0x8(%ebp),%esp
4000159a:	5b                   	pop    %ebx
4000159b:	5e                   	pop    %esi
4000159c:	5d                   	pop    %ebp
4000159d:	c3                   	ret
4000159e:	66 90                	xchg   %ax,%ax
    printf("mkdir dots failed\n");
400015a0:	83 ec 0c             	sub    $0xc,%esp
400015a3:	68 0d 34 00 40       	push   $0x4000340d
400015a8:	e8 93 ed ff ff       	call   40000340 <printf>
    exit();
400015ad:	83 c4 10             	add    $0x10,%esp
400015b0:	eb e5                	jmp    40001597 <rmdot+0x87>
400015b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf("chdir dots failed\n");
400015b8:	83 ec 0c             	sub    $0xc,%esp
400015bb:	68 20 34 00 40       	push   $0x40003420
400015c0:	e8 7b ed ff ff       	call   40000340 <printf>
    exit();
400015c5:	83 c4 10             	add    $0x10,%esp
400015c8:	eb cd                	jmp    40001597 <rmdot+0x87>
400015ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  unsigned int len = strlen(path);
400015d0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400015d3:	bb 53 37 00 40       	mov    $0x40003753,%ebx
  unsigned int len = strlen(path);
400015d8:	68 53 37 00 40       	push   $0x40003753
400015dd:	e8 fe f4 ff ff       	call   40000ae0 <strlen>
400015e2:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400015e4:	b8 0d 00 00 00       	mov    $0xd,%eax
400015e9:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400015eb:	83 c4 10             	add    $0x10,%esp
400015ee:	85 c0                	test   %eax,%eax
400015f0:	75 12                	jne    40001604 <rmdot+0xf4>
    printf("rm .. worked!\n");
400015f2:	83 ec 0c             	sub    $0xc,%esp
400015f5:	68 41 34 00 40       	push   $0x40003441
400015fa:	e8 41 ed ff ff       	call   40000340 <printf>
    exit();
400015ff:	83 c4 10             	add    $0x10,%esp
40001602:	eb 93                	jmp    40001597 <rmdot+0x87>
  unsigned int len = strlen(path);
40001604:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001607:	bb 50 34 00 40       	mov    $0x40003450,%ebx
  unsigned int len = strlen(path);
4000160c:	68 50 34 00 40       	push   $0x40003450
40001611:	e8 ca f4 ff ff       	call   40000ae0 <strlen>
40001616:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001618:	b8 0b 00 00 00       	mov    $0xb,%eax
4000161d:	cd 30                	int    $0x30
	return errno ? -1 : 0;
4000161f:	83 c4 10             	add    $0x10,%esp
40001622:	85 c0                	test   %eax,%eax
40001624:	75 39                	jne    4000165f <rmdot+0x14f>
  unsigned int len = strlen(path);
40001626:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001629:	be 0d 00 00 00       	mov    $0xd,%esi
4000162e:	bb 64 34 00 40       	mov    $0x40003464,%ebx
  unsigned int len = strlen(path);
40001633:	68 64 34 00 40       	push   $0x40003464
40001638:	e8 a3 f4 ff ff       	call   40000ae0 <strlen>
4000163d:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000163f:	89 f0                	mov    %esi,%eax
40001641:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001643:	83 c4 10             	add    $0x10,%esp
40001646:	85 c0                	test   %eax,%eax
40001648:	75 27                	jne    40001671 <rmdot+0x161>
    printf("unlink dots/. worked!\n");
4000164a:	83 ec 0c             	sub    $0xc,%esp
4000164d:	68 6b 34 00 40       	push   $0x4000346b
40001652:	e8 e9 ec ff ff       	call   40000340 <printf>
    exit();
40001657:	83 c4 10             	add    $0x10,%esp
4000165a:	e9 38 ff ff ff       	jmp    40001597 <rmdot+0x87>
    printf("chdir '/' failed\n");
4000165f:	83 ec 0c             	sub    $0xc,%esp
40001662:	68 52 34 00 40       	push   $0x40003452
40001667:	e8 d4 ec ff ff       	call   40000340 <printf>
4000166c:	83 c4 10             	add    $0x10,%esp
4000166f:	eb b5                	jmp    40001626 <rmdot+0x116>
  unsigned int len = strlen(path);
40001671:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001674:	bb 82 34 00 40       	mov    $0x40003482,%ebx
  unsigned int len = strlen(path);
40001679:	68 82 34 00 40       	push   $0x40003482
4000167e:	e8 5d f4 ff ff       	call   40000ae0 <strlen>
40001683:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001685:	89 f0                	mov    %esi,%eax
40001687:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001689:	83 c4 10             	add    $0x10,%esp
4000168c:	85 c0                	test   %eax,%eax
4000168e:	75 15                	jne    400016a5 <rmdot+0x195>
    printf("unlink dots/.. worked!\n");
40001690:	83 ec 0c             	sub    $0xc,%esp
40001693:	68 8a 34 00 40       	push   $0x4000348a
40001698:	e8 a3 ec ff ff       	call   40000340 <printf>
    exit();
4000169d:	83 c4 10             	add    $0x10,%esp
400016a0:	e9 f2 fe ff ff       	jmp    40001597 <rmdot+0x87>
  unsigned int len = strlen(path);
400016a5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400016a8:	bb 08 34 00 40       	mov    $0x40003408,%ebx
  unsigned int len = strlen(path);
400016ad:	68 08 34 00 40       	push   $0x40003408
400016b2:	e8 29 f4 ff ff       	call   40000ae0 <strlen>
400016b7:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400016b9:	89 f0                	mov    %esi,%eax
400016bb:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400016bd:	83 c4 10             	add    $0x10,%esp
400016c0:	85 c0                	test   %eax,%eax
400016c2:	75 15                	jne    400016d9 <rmdot+0x1c9>
  printf("=====rmdot ok=====\n\n");
400016c4:	83 ec 0c             	sub    $0xc,%esp
400016c7:	68 a2 34 00 40       	push   $0x400034a2
400016cc:	e8 6f ec ff ff       	call   40000340 <printf>
400016d1:	83 c4 10             	add    $0x10,%esp
400016d4:	e9 be fe ff ff       	jmp    40001597 <rmdot+0x87>
    printf("unlink dots failed!\n");
400016d9:	83 ec 0c             	sub    $0xc,%esp
400016dc:	68 b7 34 00 40       	push   $0x400034b7
400016e1:	e8 5a ec ff ff       	call   40000340 <printf>
    exit();
400016e6:	83 c4 10             	add    $0x10,%esp
400016e9:	e9 a9 fe ff ff       	jmp    40001597 <rmdot+0x87>
400016ee:	66 90                	xchg   %ax,%ax

400016f0 <fourteen>:
{
400016f0:	55                   	push   %ebp
400016f1:	89 e5                	mov    %esp,%ebp
400016f3:	57                   	push   %edi
400016f4:	56                   	push   %esi
400016f5:	53                   	push   %ebx
	asm volatile("int %2"
400016f6:	bb 11 35 00 40       	mov    $0x40003511,%ebx
400016fb:	83 ec 18             	sub    $0x18,%esp
  printf("=====fourteen test=====\n");
400016fe:	68 cc 34 00 40       	push   $0x400034cc
40001703:	e8 38 ec ff ff       	call   40000340 <printf>
  unsigned int len = strlen(path);
40001708:	c7 04 24 11 35 00 40 	movl   $0x40003511,(%esp)
4000170f:	e8 cc f3 ff ff       	call   40000ae0 <strlen>
40001714:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001716:	b8 0a 00 00 00       	mov    $0xa,%eax
4000171b:	cd 30                	int    $0x30
	return errno ? -1 : 0;
4000171d:	83 c4 10             	add    $0x10,%esp
40001720:	85 c0                	test   %eax,%eax
40001722:	0f 85 08 01 00 00    	jne    40001830 <fourteen+0x140>
  unsigned int len = strlen(path);
40001728:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
4000172b:	bb 54 3f 00 40       	mov    $0x40003f54,%ebx
  unsigned int len = strlen(path);
40001730:	68 54 3f 00 40       	push   $0x40003f54
40001735:	e8 a6 f3 ff ff       	call   40000ae0 <strlen>
4000173a:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000173c:	b8 0a 00 00 00       	mov    $0xa,%eax
40001741:	cd 30                	int    $0x30
40001743:	89 c7                	mov    %eax,%edi
	return errno ? -1 : 0;
40001745:	83 c4 10             	add    $0x10,%esp
40001748:	85 c0                	test   %eax,%eax
4000174a:	0f 85 f8 00 00 00    	jne    40001848 <fourteen+0x158>
        unsigned int len = strlen(path);
40001750:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001753:	bb 74 3f 00 40       	mov    $0x40003f74,%ebx
        unsigned int len = strlen(path);
40001758:	68 74 3f 00 40       	push   $0x40003f74
4000175d:	e8 7e f3 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001762:	b9 00 02 00 00       	mov    $0x200,%ecx
        unsigned int len = strlen(path);
40001767:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001769:	b8 05 00 00 00       	mov    $0x5,%eax
4000176e:	cd 30                	int    $0x30
  if(fd < 0){
40001770:	83 c4 10             	add    $0x10,%esp
40001773:	85 db                	test   %ebx,%ebx
40001775:	0f 88 95 00 00 00    	js     40001810 <fourteen+0x120>
4000177b:	85 c0                	test   %eax,%eax
4000177d:	0f 85 8d 00 00 00    	jne    40001810 <fourteen+0x120>
	asm volatile("int %2"
40001783:	b8 06 00 00 00       	mov    $0x6,%eax
40001788:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
4000178a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
4000178d:	bb 14 40 00 40       	mov    $0x40004014,%ebx
        unsigned int len = strlen(path);
40001792:	68 14 40 00 40       	push   $0x40004014
40001797:	e8 44 f3 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
4000179c:	89 f9                	mov    %edi,%ecx
        unsigned int len = strlen(path);
4000179e:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
400017a0:	b8 05 00 00 00       	mov    $0x5,%eax
400017a5:	cd 30                	int    $0x30
  if(fd < 0){
400017a7:	83 c4 10             	add    $0x10,%esp
400017aa:	85 db                	test   %ebx,%ebx
400017ac:	78 4a                	js     400017f8 <fourteen+0x108>
400017ae:	85 c0                	test   %eax,%eax
400017b0:	75 46                	jne    400017f8 <fourteen+0x108>
	asm volatile("int %2"
400017b2:	b8 06 00 00 00       	mov    $0x6,%eax
400017b7:	cd 30                	int    $0x30
  unsigned int len = strlen(path);
400017b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400017bc:	bb 02 35 00 40       	mov    $0x40003502,%ebx
  unsigned int len = strlen(path);
400017c1:	68 02 35 00 40       	push   $0x40003502
400017c6:	e8 15 f3 ff ff       	call   40000ae0 <strlen>
400017cb:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400017cd:	b8 0a 00 00 00       	mov    $0xa,%eax
400017d2:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400017d4:	83 c4 10             	add    $0x10,%esp
400017d7:	85 c0                	test   %eax,%eax
400017d9:	75 7f                	jne    4000185a <fourteen+0x16a>
    printf("mkdir 12345678901234/12345678901234 succeeded!\n");
400017db:	83 ec 0c             	sub    $0xc,%esp
400017de:	68 80 40 00 40       	push   $0x40004080
400017e3:	e8 58 eb ff ff       	call   40000340 <printf>
    exit();
400017e8:	83 c4 10             	add    $0x10,%esp
}
400017eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
400017ee:	5b                   	pop    %ebx
400017ef:	5e                   	pop    %esi
400017f0:	5f                   	pop    %edi
400017f1:	5d                   	pop    %ebp
400017f2:	c3                   	ret
400017f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    printf("open 12345678901234/12345678901234/12345678901234 failed\n");
400017f8:	83 ec 0c             	sub    $0xc,%esp
400017fb:	68 44 40 00 40       	push   $0x40004044
40001800:	e8 3b eb ff ff       	call   40000340 <printf>
    exit();
40001805:	83 c4 10             	add    $0x10,%esp
}
40001808:	8d 65 f4             	lea    -0xc(%ebp),%esp
4000180b:	5b                   	pop    %ebx
4000180c:	5e                   	pop    %esi
4000180d:	5f                   	pop    %edi
4000180e:	5d                   	pop    %ebp
4000180f:	c3                   	ret
    printf("create 123456789012345/123456789012345/123456789012345 failed\n");
40001810:	83 ec 0c             	sub    $0xc,%esp
40001813:	68 d4 3f 00 40       	push   $0x40003fd4
40001818:	e8 23 eb ff ff       	call   40000340 <printf>
    exit();
4000181d:	83 c4 10             	add    $0x10,%esp
}
40001820:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001823:	5b                   	pop    %ebx
40001824:	5e                   	pop    %esi
40001825:	5f                   	pop    %edi
40001826:	5d                   	pop    %ebp
40001827:	c3                   	ret
40001828:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000182f:	00 
    printf("mkdir 12345678901234 failed\n");
40001830:	83 ec 0c             	sub    $0xc,%esp
40001833:	68 e5 34 00 40       	push   $0x400034e5
40001838:	e8 03 eb ff ff       	call   40000340 <printf>
    exit();
4000183d:	83 c4 10             	add    $0x10,%esp
40001840:	eb a9                	jmp    400017eb <fourteen+0xfb>
40001842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf("mkdir 12345678901234/123456789012345 failed\n");
40001848:	83 ec 0c             	sub    $0xc,%esp
4000184b:	68 a4 3f 00 40       	push   $0x40003fa4
40001850:	e8 eb ea ff ff       	call   40000340 <printf>
    exit();
40001855:	83 c4 10             	add    $0x10,%esp
40001858:	eb 91                	jmp    400017eb <fourteen+0xfb>
  unsigned int len = strlen(path);
4000185a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
4000185d:	bb 54 3f 00 40       	mov    $0x40003f54,%ebx
  unsigned int len = strlen(path);
40001862:	68 54 3f 00 40       	push   $0x40003f54
40001867:	e8 74 f2 ff ff       	call   40000ae0 <strlen>
4000186c:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000186e:	b8 0a 00 00 00       	mov    $0xa,%eax
40001873:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001875:	83 c4 10             	add    $0x10,%esp
40001878:	85 c0                	test   %eax,%eax
4000187a:	75 15                	jne    40001891 <fourteen+0x1a1>
    printf("mkdir 12345678901234/123456789012345 succeeded!\n");
4000187c:	83 ec 0c             	sub    $0xc,%esp
4000187f:	68 b0 40 00 40       	push   $0x400040b0
40001884:	e8 b7 ea ff ff       	call   40000340 <printf>
    exit();
40001889:	83 c4 10             	add    $0x10,%esp
4000188c:	e9 5a ff ff ff       	jmp    400017eb <fourteen+0xfb>
  printf("=====fourteen ok=====\n\n");
40001891:	83 ec 0c             	sub    $0xc,%esp
40001894:	68 20 35 00 40       	push   $0x40003520
40001899:	e8 a2 ea ff ff       	call   40000340 <printf>
4000189e:	83 c4 10             	add    $0x10,%esp
400018a1:	e9 45 ff ff ff       	jmp    400017eb <fourteen+0xfb>
400018a6:	66 90                	xchg   %ax,%ax
400018a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400018af:	00 

400018b0 <bigfile2>:
{
400018b0:	55                   	push   %ebp
400018b1:	89 e5                	mov    %esp,%ebp
400018b3:	57                   	push   %edi
400018b4:	56                   	push   %esi
400018b5:	53                   	push   %ebx
	asm volatile("int %2"
400018b6:	bb 5e 35 00 40       	mov    $0x4000355e,%ebx
400018bb:	83 ec 28             	sub    $0x28,%esp
  printf("=====bigfile test=====\n");
400018be:	68 38 35 00 40       	push   $0x40003538
400018c3:	e8 78 ea ff ff       	call   40000340 <printf>
  unsigned int len = strlen(path);
400018c8:	c7 04 24 5e 35 00 40 	movl   $0x4000355e,(%esp)
400018cf:	e8 0c f2 ff ff       	call   40000ae0 <strlen>
400018d4:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400018d6:	b8 0d 00 00 00       	mov    $0xd,%eax
400018db:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
400018dd:	c7 04 24 5e 35 00 40 	movl   $0x4000355e,(%esp)
	asm volatile("int %2"
400018e4:	bb 5e 35 00 40       	mov    $0x4000355e,%ebx
        unsigned int len = strlen(path);
400018e9:	e8 f2 f1 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
400018ee:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
400018f3:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
400018f5:	b8 05 00 00 00       	mov    $0x5,%eax
400018fa:	cd 30                	int    $0x30
	return errno ? -1 : fd;
400018fc:	83 c4 10             	add    $0x10,%esp
  if(fd < 0){
400018ff:	85 c0                	test   %eax,%eax
40001901:	0f 85 39 01 00 00    	jne    40001a40 <bigfile2+0x190>
40001907:	89 de                	mov    %ebx,%esi
  for(i = 0; i < 20; i++){
40001909:	31 ff                	xor    %edi,%edi
  if(fd < 0){
4000190b:	85 db                	test   %ebx,%ebx
4000190d:	0f 88 2d 01 00 00    	js     40001a40 <bigfile2+0x190>
    memset(buf, i, 600);
40001913:	83 ec 04             	sub    $0x4,%esp
	asm volatile("int %2"
40001916:	89 f3                	mov    %esi,%ebx
40001918:	68 58 02 00 00       	push   $0x258
4000191d:	57                   	push   %edi
4000191e:	68 a0 54 00 40       	push   $0x400054a0
40001923:	e8 08 f5 ff ff       	call   40000e30 <memset>
40001928:	b8 08 00 00 00       	mov    $0x8,%eax
4000192d:	b9 a0 54 00 40       	mov    $0x400054a0,%ecx
40001932:	ba 58 02 00 00       	mov    $0x258,%edx
40001937:	cd 30                	int    $0x30
    if(write(fd, buf, 600) != 600){
40001939:	83 c4 10             	add    $0x10,%esp
4000193c:	81 fb 58 02 00 00    	cmp    $0x258,%ebx
40001942:	0f 85 d8 00 00 00    	jne    40001a20 <bigfile2+0x170>
40001948:	85 c0                	test   %eax,%eax
4000194a:	0f 85 d0 00 00 00    	jne    40001a20 <bigfile2+0x170>
  for(i = 0; i < 20; i++){
40001950:	83 c7 01             	add    $0x1,%edi
40001953:	83 ff 14             	cmp    $0x14,%edi
40001956:	75 bb                	jne    40001913 <bigfile2+0x63>
	asm volatile("int %2"
40001958:	b8 06 00 00 00       	mov    $0x6,%eax
4000195d:	89 f3                	mov    %esi,%ebx
4000195f:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
40001961:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001964:	bb 5e 35 00 40       	mov    $0x4000355e,%ebx
        unsigned int len = strlen(path);
40001969:	68 5e 35 00 40       	push   $0x4000355e
4000196e:	e8 6d f1 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001973:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40001975:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001977:	b8 05 00 00 00       	mov    $0x5,%eax
4000197c:	cd 30                	int    $0x30
4000197e:	89 df                	mov    %ebx,%edi
  if(fd < 0){
40001980:	83 c4 10             	add    $0x10,%esp
40001983:	85 db                	test   %ebx,%ebx
40001985:	0f 88 d5 00 00 00    	js     40001a60 <bigfile2+0x1b0>
4000198b:	85 c0                	test   %eax,%eax
4000198d:	0f 85 cd 00 00 00    	jne    40001a60 <bigfile2+0x1b0>
	asm volatile("int %2"
40001993:	b8 07 00 00 00       	mov    $0x7,%eax
40001998:	ba 2c 01 00 00       	mov    $0x12c,%edx
4000199d:	b9 a0 54 00 40       	mov    $0x400054a0,%ecx
400019a2:	cd 30                	int    $0x30
400019a4:	89 da                	mov    %ebx,%edx
    if(cc < 0){
400019a6:	85 db                	test   %ebx,%ebx
400019a8:	78 61                	js     40001a0b <bigfile2+0x15b>
  total = 0;
400019aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  for(i = 0; ; i++){
400019b1:	31 f6                	xor    %esi,%esi
    if(cc < 0){
400019b3:	85 c0                	test   %eax,%eax
400019b5:	75 54                	jne    40001a0b <bigfile2+0x15b>
    if(cc == 0)
400019b7:	85 d2                	test   %edx,%edx
400019b9:	0f 84 d7 00 00 00    	je     40001a96 <bigfile2+0x1e6>
    if(cc != 300){
400019bf:	81 fa 2c 01 00 00    	cmp    $0x12c,%edx
400019c5:	0f 85 b9 00 00 00    	jne    40001a84 <bigfile2+0x1d4>
    if(buf[0] != i/2 || buf[299] != i/2){
400019cb:	89 f1                	mov    %esi,%ecx
400019cd:	0f be 05 a0 54 00 40 	movsbl 0x400054a0,%eax
400019d4:	d1 f9                	sar    $1,%ecx
400019d6:	39 c8                	cmp    %ecx,%eax
400019d8:	0f 85 94 00 00 00    	jne    40001a72 <bigfile2+0x1c2>
400019de:	0f be 0d cb 55 00 40 	movsbl 0x400055cb,%ecx
400019e5:	39 c8                	cmp    %ecx,%eax
400019e7:	0f 85 85 00 00 00    	jne    40001a72 <bigfile2+0x1c2>
  for(i = 0; ; i++){
400019ed:	83 c6 01             	add    $0x1,%esi
400019f0:	b8 07 00 00 00       	mov    $0x7,%eax
400019f5:	89 fb                	mov    %edi,%ebx
400019f7:	b9 a0 54 00 40       	mov    $0x400054a0,%ecx
    total += cc;
400019fc:	81 45 e4 2c 01 00 00 	addl   $0x12c,-0x1c(%ebp)
40001a03:	cd 30                	int    $0x30
40001a05:	89 da                	mov    %ebx,%edx
    if(cc < 0){
40001a07:	85 db                	test   %ebx,%ebx
40001a09:	79 a8                	jns    400019b3 <bigfile2+0x103>
      printf("read bigfile failed\n");
40001a0b:	83 ec 0c             	sub    $0xc,%esp
40001a0e:	68 91 35 00 40       	push   $0x40003591
40001a13:	e8 28 e9 ff ff       	call   40000340 <printf>
      exit();
40001a18:	83 c4 10             	add    $0x10,%esp
40001a1b:	eb 13                	jmp    40001a30 <bigfile2+0x180>
40001a1d:	8d 76 00             	lea    0x0(%esi),%esi
      printf("write bigfile failed\n");
40001a20:	83 ec 0c             	sub    $0xc,%esp
40001a23:	68 66 35 00 40       	push   $0x40003566
40001a28:	e8 13 e9 ff ff       	call   40000340 <printf>
      exit();
40001a2d:	83 c4 10             	add    $0x10,%esp
}
40001a30:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001a33:	5b                   	pop    %ebx
40001a34:	5e                   	pop    %esi
40001a35:	5f                   	pop    %edi
40001a36:	5d                   	pop    %ebp
40001a37:	c3                   	ret
40001a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40001a3f:	00 
    printf("cannot create bigfile");
40001a40:	83 ec 0c             	sub    $0xc,%esp
40001a43:	68 50 35 00 40       	push   $0x40003550
40001a48:	e8 f3 e8 ff ff       	call   40000340 <printf>
    exit();
40001a4d:	83 c4 10             	add    $0x10,%esp
}
40001a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001a53:	5b                   	pop    %ebx
40001a54:	5e                   	pop    %esi
40001a55:	5f                   	pop    %edi
40001a56:	5d                   	pop    %ebp
40001a57:	c3                   	ret
40001a58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40001a5f:	00 
    printf("cannot open bigfile\n");
40001a60:	83 ec 0c             	sub    $0xc,%esp
40001a63:	68 7c 35 00 40       	push   $0x4000357c
40001a68:	e8 d3 e8 ff ff       	call   40000340 <printf>
    exit();
40001a6d:	83 c4 10             	add    $0x10,%esp
40001a70:	eb be                	jmp    40001a30 <bigfile2+0x180>
      printf("read bigfile wrong data\n");
40001a72:	83 ec 0c             	sub    $0xc,%esp
40001a75:	68 ba 35 00 40       	push   $0x400035ba
40001a7a:	e8 c1 e8 ff ff       	call   40000340 <printf>
      exit();
40001a7f:	83 c4 10             	add    $0x10,%esp
40001a82:	eb ac                	jmp    40001a30 <bigfile2+0x180>
      printf("short read bigfile\n");
40001a84:	83 ec 0c             	sub    $0xc,%esp
40001a87:	68 a6 35 00 40       	push   $0x400035a6
40001a8c:	e8 af e8 ff ff       	call   40000340 <printf>
      exit();
40001a91:	83 c4 10             	add    $0x10,%esp
40001a94:	eb 9a                	jmp    40001a30 <bigfile2+0x180>
	asm volatile("int %2"
40001a96:	b8 06 00 00 00       	mov    $0x6,%eax
40001a9b:	89 fb                	mov    %edi,%ebx
40001a9d:	cd 30                	int    $0x30
  if(total != 20*600){
40001a9f:	81 7d e4 e0 2e 00 00 	cmpl   $0x2ee0,-0x1c(%ebp)
40001aa6:	74 15                	je     40001abd <bigfile2+0x20d>
    printf("read bigfile wrong total\n");
40001aa8:	83 ec 0c             	sub    $0xc,%esp
40001aab:	68 d3 35 00 40       	push   $0x400035d3
40001ab0:	e8 8b e8 ff ff       	call   40000340 <printf>
    exit();
40001ab5:	83 c4 10             	add    $0x10,%esp
40001ab8:	e9 73 ff ff ff       	jmp    40001a30 <bigfile2+0x180>
  unsigned int len = strlen(path);
40001abd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001ac0:	bb 5e 35 00 40       	mov    $0x4000355e,%ebx
  unsigned int len = strlen(path);
40001ac5:	68 5e 35 00 40       	push   $0x4000355e
40001aca:	e8 11 f0 ff ff       	call   40000ae0 <strlen>
40001acf:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001ad1:	b8 0d 00 00 00       	mov    $0xd,%eax
40001ad6:	cd 30                	int    $0x30
  printf("=====bigfile test ok=====\n\n");
40001ad8:	c7 04 24 ed 35 00 40 	movl   $0x400035ed,(%esp)
40001adf:	e8 5c e8 ff ff       	call   40000340 <printf>
40001ae4:	83 c4 10             	add    $0x10,%esp
40001ae7:	e9 44 ff ff ff       	jmp    40001a30 <bigfile2+0x180>
40001aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40001af0 <subdir>:
{
40001af0:	55                   	push   %ebp
40001af1:	89 e5                	mov    %esp,%ebp
40001af3:	57                   	push   %edi
40001af4:	56                   	push   %esi
40001af5:	53                   	push   %ebx
40001af6:	bb 9b 36 00 40       	mov    $0x4000369b,%ebx
40001afb:	83 ec 28             	sub    $0x28,%esp
  printf("=====subdir test=====\n");
40001afe:	68 09 36 00 40       	push   $0x40003609
40001b03:	e8 38 e8 ff ff       	call   40000340 <printf>
  unsigned int len = strlen(path);
40001b08:	c7 04 24 9b 36 00 40 	movl   $0x4000369b,(%esp)
40001b0f:	e8 cc ef ff ff       	call   40000ae0 <strlen>
40001b14:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001b16:	b8 0d 00 00 00       	mov    $0xd,%eax
40001b1b:	cd 30                	int    $0x30
  unsigned int len = strlen(path);
40001b1d:	c7 04 24 34 37 00 40 	movl   $0x40003734,(%esp)
	asm volatile("int %2"
40001b24:	bb 34 37 00 40       	mov    $0x40003734,%ebx
  unsigned int len = strlen(path);
40001b29:	e8 b2 ef ff ff       	call   40000ae0 <strlen>
40001b2e:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001b30:	b8 0a 00 00 00       	mov    $0xa,%eax
40001b35:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001b37:	83 c4 10             	add    $0x10,%esp
40001b3a:	85 c0                	test   %eax,%eax
40001b3c:	0f 85 9e 00 00 00    	jne    40001be0 <subdir+0xf0>
        unsigned int len = strlen(path);
40001b42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001b45:	bb 56 36 00 40       	mov    $0x40003656,%ebx
        unsigned int len = strlen(path);
40001b4a:	68 56 36 00 40       	push   $0x40003656
40001b4f:	e8 8c ef ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001b54:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
40001b59:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001b5b:	b8 05 00 00 00       	mov    $0x5,%eax
40001b60:	cd 30                	int    $0x30
40001b62:	89 df                	mov    %ebx,%edi
  if(fd < 0){
40001b64:	83 c4 10             	add    $0x10,%esp
40001b67:	85 db                	test   %ebx,%ebx
40001b69:	78 5d                	js     40001bc8 <subdir+0xd8>
40001b6b:	85 c0                	test   %eax,%eax
40001b6d:	75 59                	jne    40001bc8 <subdir+0xd8>
	asm volatile("int %2"
40001b6f:	b8 08 00 00 00       	mov    $0x8,%eax
40001b74:	b9 9b 36 00 40       	mov    $0x4000369b,%ecx
40001b79:	ba 02 00 00 00       	mov    $0x2,%edx
40001b7e:	cd 30                	int    $0x30
	asm volatile("int %2"
40001b80:	b8 06 00 00 00       	mov    $0x6,%eax
40001b85:	89 fb                	mov    %edi,%ebx
40001b87:	cd 30                	int    $0x30
  unsigned int len = strlen(path);
40001b89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001b8c:	bb 34 37 00 40       	mov    $0x40003734,%ebx
  unsigned int len = strlen(path);
40001b91:	68 34 37 00 40       	push   $0x40003734
40001b96:	e8 45 ef ff ff       	call   40000ae0 <strlen>
40001b9b:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001b9d:	b8 0d 00 00 00       	mov    $0xd,%eax
40001ba2:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001ba4:	83 c4 10             	add    $0x10,%esp
40001ba7:	85 c0                	test   %eax,%eax
40001ba9:	75 4d                	jne    40001bf8 <subdir+0x108>
    printf("unlink dd (non-empty dir) succeeded!\n");
40001bab:	83 ec 0c             	sub    $0xc,%esp
40001bae:	68 e4 40 00 40       	push   $0x400040e4
40001bb3:	e8 88 e7 ff ff       	call   40000340 <printf>
    exit();
40001bb8:	83 c4 10             	add    $0x10,%esp
}
40001bbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001bbe:	5b                   	pop    %ebx
40001bbf:	5e                   	pop    %esi
40001bc0:	5f                   	pop    %edi
40001bc1:	5d                   	pop    %ebp
40001bc2:	c3                   	ret
40001bc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    printf("create dd/ff failed\n");
40001bc8:	83 ec 0c             	sub    $0xc,%esp
40001bcb:	68 38 36 00 40       	push   $0x40003638
40001bd0:	e8 6b e7 ff ff       	call   40000340 <printf>
    exit();
40001bd5:	83 c4 10             	add    $0x10,%esp
}
40001bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
40001bdb:	5b                   	pop    %ebx
40001bdc:	5e                   	pop    %esi
40001bdd:	5f                   	pop    %edi
40001bde:	5d                   	pop    %ebp
40001bdf:	c3                   	ret
    printf("subdir mkdir dd failed\n");
40001be0:	83 ec 0c             	sub    $0xc,%esp
40001be3:	68 20 36 00 40       	push   $0x40003620
40001be8:	e8 53 e7 ff ff       	call   40000340 <printf>
    exit();
40001bed:	83 c4 10             	add    $0x10,%esp
40001bf0:	eb c9                	jmp    40001bbb <subdir+0xcb>
40001bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  unsigned int len = strlen(path);
40001bf8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001bfb:	bb 4d 36 00 40       	mov    $0x4000364d,%ebx
  unsigned int len = strlen(path);
40001c00:	68 4d 36 00 40       	push   $0x4000364d
40001c05:	e8 d6 ee ff ff       	call   40000ae0 <strlen>
40001c0a:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001c0c:	b8 0a 00 00 00       	mov    $0xa,%eax
40001c11:	cd 30                	int    $0x30
40001c13:	89 c7                	mov    %eax,%edi
	return errno ? -1 : 0;
40001c15:	83 c4 10             	add    $0x10,%esp
40001c18:	85 c0                	test   %eax,%eax
40001c1a:	0f 85 84 02 00 00    	jne    40001ea4 <subdir+0x3b4>
        unsigned int len = strlen(path);
40001c20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001c23:	bb 53 36 00 40       	mov    $0x40003653,%ebx
        unsigned int len = strlen(path);
40001c28:	68 53 36 00 40       	push   $0x40003653
40001c2d:	e8 ae ee ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001c32:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
40001c37:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001c39:	b8 05 00 00 00       	mov    $0x5,%eax
40001c3e:	cd 30                	int    $0x30
40001c40:	89 de                	mov    %ebx,%esi
  if(fd < 0){
40001c42:	83 c4 10             	add    $0x10,%esp
40001c45:	85 db                	test   %ebx,%ebx
40001c47:	0f 88 97 00 00 00    	js     40001ce4 <subdir+0x1f4>
40001c4d:	85 c0                	test   %eax,%eax
40001c4f:	0f 85 8f 00 00 00    	jne    40001ce4 <subdir+0x1f4>
	asm volatile("int %2"
40001c55:	b9 8f 36 00 40       	mov    $0x4000368f,%ecx
40001c5a:	b8 08 00 00 00       	mov    $0x8,%eax
40001c5f:	ba 02 00 00 00       	mov    $0x2,%edx
40001c64:	cd 30                	int    $0x30
	asm volatile("int %2"
40001c66:	b8 06 00 00 00       	mov    $0x6,%eax
40001c6b:	89 f3                	mov    %esi,%ebx
40001c6d:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
40001c6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001c72:	bb 92 36 00 40       	mov    $0x40003692,%ebx
        unsigned int len = strlen(path);
40001c77:	68 92 36 00 40       	push   $0x40003692
40001c7c:	e8 5f ee ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001c81:	89 f9                	mov    %edi,%ecx
        unsigned int len = strlen(path);
40001c83:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001c85:	b8 05 00 00 00       	mov    $0x5,%eax
40001c8a:	cd 30                	int    $0x30
40001c8c:	89 de                	mov    %ebx,%esi
  if(fd < 0){
40001c8e:	83 c4 10             	add    $0x10,%esp
40001c91:	85 db                	test   %ebx,%ebx
40001c93:	78 6b                	js     40001d00 <subdir+0x210>
40001c95:	85 c0                	test   %eax,%eax
40001c97:	75 67                	jne    40001d00 <subdir+0x210>
	asm volatile("int %2"
40001c99:	b8 07 00 00 00       	mov    $0x7,%eax
40001c9e:	ba 00 20 00 00       	mov    $0x2000,%edx
40001ca3:	b9 a0 54 00 40       	mov    $0x400054a0,%ecx
40001ca8:	cd 30                	int    $0x30
  if(cc != 2 || buf[0] != 'f'){
40001caa:	0f be 15 a0 54 00 40 	movsbl 0x400054a0,%edx
	return errno ? -1 : ret;
40001cb1:	85 c0                	test   %eax,%eax
40001cb3:	75 44                	jne    40001cf9 <subdir+0x209>
40001cb5:	89 d8                	mov    %ebx,%eax
40001cb7:	83 fb 02             	cmp    $0x2,%ebx
40001cba:	75 05                	jne    40001cc1 <subdir+0x1d1>
40001cbc:	80 fa 66             	cmp    $0x66,%dl
40001cbf:	74 54                	je     40001d15 <subdir+0x225>
    printf("cc = %d, buf[0] = %c\n", cc, buf[0]);
40001cc1:	83 ec 04             	sub    $0x4,%esp
40001cc4:	52                   	push   %edx
40001cc5:	50                   	push   %eax
40001cc6:	68 b7 36 00 40       	push   $0x400036b7
40001ccb:	e8 70 e6 ff ff       	call   40000340 <printf>
    printf("dd/dd/../ff wrong content\n");
40001cd0:	c7 04 24 cd 36 00 40 	movl   $0x400036cd,(%esp)
40001cd7:	e8 64 e6 ff ff       	call   40000340 <printf>
    exit();
40001cdc:	83 c4 10             	add    $0x10,%esp
40001cdf:	e9 d7 fe ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("create dd/dd/ff failed\n");
40001ce4:	83 ec 0c             	sub    $0xc,%esp
40001ce7:	68 77 36 00 40       	push   $0x40003677
40001cec:	e8 4f e6 ff ff       	call   40000340 <printf>
    exit();
40001cf1:	83 c4 10             	add    $0x10,%esp
40001cf4:	e9 c2 fe ff ff       	jmp    40001bbb <subdir+0xcb>
40001cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40001cfe:	eb c1                	jmp    40001cc1 <subdir+0x1d1>
    printf("open dd/dd/../ff failed\n");
40001d00:	83 ec 0c             	sub    $0xc,%esp
40001d03:	68 9e 36 00 40       	push   $0x4000369e
40001d08:	e8 33 e6 ff ff       	call   40000340 <printf>
    exit();
40001d0d:	83 c4 10             	add    $0x10,%esp
40001d10:	e9 a6 fe ff ff       	jmp    40001bbb <subdir+0xcb>
	asm volatile("int %2"
40001d15:	b8 06 00 00 00       	mov    $0x6,%eax
40001d1a:	89 f3                	mov    %esi,%ebx
40001d1c:	cd 30                	int    $0x30
  old_len = strlen(old);
40001d1e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001d21:	bb 53 36 00 40       	mov    $0x40003653,%ebx
  old_len = strlen(old);
40001d26:	68 53 36 00 40       	push   $0x40003653
40001d2b:	e8 b0 ed ff ff       	call   40000ae0 <strlen>
  new_len = strlen(new);
40001d30:	c7 04 24 e8 36 00 40 	movl   $0x400036e8,(%esp)
  old_len = strlen(old);
40001d37:	89 c7                	mov    %eax,%edi
  new_len = strlen(new);
40001d39:	e8 a2 ed ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001d3e:	b9 e8 36 00 40       	mov    $0x400036e8,%ecx
40001d43:	89 fa                	mov    %edi,%edx
  new_len = strlen(new);
40001d45:	89 c6                	mov    %eax,%esi
	asm volatile("int %2"
40001d47:	b8 0c 00 00 00       	mov    $0xc,%eax
40001d4c:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001d4e:	83 c4 10             	add    $0x10,%esp
40001d51:	85 c0                	test   %eax,%eax
40001d53:	0f 85 9f 01 00 00    	jne    40001ef8 <subdir+0x408>
  unsigned int len = strlen(path);
40001d59:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001d5c:	bb 53 36 00 40       	mov    $0x40003653,%ebx
  unsigned int len = strlen(path);
40001d61:	68 53 36 00 40       	push   $0x40003653
40001d66:	e8 75 ed ff ff       	call   40000ae0 <strlen>
40001d6b:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001d6d:	b8 0d 00 00 00       	mov    $0xd,%eax
40001d72:	cd 30                	int    $0x30
40001d74:	89 c6                	mov    %eax,%esi
	return errno ? -1 : 0;
40001d76:	83 c4 10             	add    $0x10,%esp
40001d79:	85 c0                	test   %eax,%eax
40001d7b:	0f 85 62 01 00 00    	jne    40001ee3 <subdir+0x3f3>
        unsigned int len = strlen(path);
40001d81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001d84:	bb 53 36 00 40       	mov    $0x40003653,%ebx
        unsigned int len = strlen(path);
40001d89:	68 53 36 00 40       	push   $0x40003653
40001d8e:	e8 4d ed ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001d93:	89 f1                	mov    %esi,%ecx
        unsigned int len = strlen(path);
40001d95:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001d97:	b8 05 00 00 00       	mov    $0x5,%eax
40001d9c:	cd 30                	int    $0x30
  if(open("dd/dd/ff", O_RDONLY) >= 0){
40001d9e:	83 c4 10             	add    $0x10,%esp
40001da1:	85 db                	test   %ebx,%ebx
40001da3:	78 08                	js     40001dad <subdir+0x2bd>
40001da5:	85 c0                	test   %eax,%eax
40001da7:	0f 84 21 01 00 00    	je     40001ece <subdir+0x3de>
  unsigned int len = strlen(path);
40001dad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001db0:	bb 34 37 00 40       	mov    $0x40003734,%ebx
  unsigned int len = strlen(path);
40001db5:	68 34 37 00 40       	push   $0x40003734
40001dba:	e8 21 ed ff ff       	call   40000ae0 <strlen>
40001dbf:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001dc1:	b8 0b 00 00 00       	mov    $0xb,%eax
40001dc6:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001dc8:	83 c4 10             	add    $0x10,%esp
40001dcb:	85 c0                	test   %eax,%eax
40001dcd:	0f 85 64 01 00 00    	jne    40001f37 <subdir+0x447>
  unsigned int len = strlen(path);
40001dd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001dd6:	bb 0b 37 00 40       	mov    $0x4000370b,%ebx
  unsigned int len = strlen(path);
40001ddb:	68 0b 37 00 40       	push   $0x4000370b
40001de0:	e8 fb ec ff ff       	call   40000ae0 <strlen>
40001de5:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001de7:	b8 0b 00 00 00       	mov    $0xb,%eax
40001dec:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001dee:	83 c4 10             	add    $0x10,%esp
40001df1:	85 c0                	test   %eax,%eax
40001df3:	0f 85 29 01 00 00    	jne    40001f22 <subdir+0x432>
  unsigned int len = strlen(path);
40001df9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001dfc:	bb 28 37 00 40       	mov    $0x40003728,%ebx
  unsigned int len = strlen(path);
40001e01:	68 28 37 00 40       	push   $0x40003728
40001e06:	e8 d5 ec ff ff       	call   40000ae0 <strlen>
40001e0b:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001e0d:	b8 0b 00 00 00       	mov    $0xb,%eax
40001e12:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40001e14:	83 c4 10             	add    $0x10,%esp
40001e17:	85 c0                	test   %eax,%eax
40001e19:	0f 85 03 01 00 00    	jne    40001f22 <subdir+0x432>
  unsigned int len = strlen(path);
40001e1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001e22:	bb 51 37 00 40       	mov    $0x40003751,%ebx
  unsigned int len = strlen(path);
40001e27:	68 51 37 00 40       	push   $0x40003751
40001e2c:	e8 af ec ff ff       	call   40000ae0 <strlen>
40001e31:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40001e33:	b8 0b 00 00 00       	mov    $0xb,%eax
40001e38:	cd 30                	int    $0x30
40001e3a:	89 c6                	mov    %eax,%esi
	return errno ? -1 : 0;
40001e3c:	83 c4 10             	add    $0x10,%esp
40001e3f:	85 c0                	test   %eax,%eax
40001e41:	0f 85 c6 00 00 00    	jne    40001f0d <subdir+0x41d>
        unsigned int len = strlen(path);
40001e47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001e4a:	bb e8 36 00 40       	mov    $0x400036e8,%ebx
        unsigned int len = strlen(path);
40001e4f:	68 e8 36 00 40       	push   $0x400036e8
40001e54:	e8 87 ec ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001e59:	89 f1                	mov    %esi,%ecx
        unsigned int len = strlen(path);
40001e5b:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001e5d:	b8 05 00 00 00       	mov    $0x5,%eax
40001e62:	cd 30                	int    $0x30
40001e64:	89 df                	mov    %ebx,%edi
  if(fd < 0){
40001e66:	83 c4 10             	add    $0x10,%esp
40001e69:	85 db                	test   %ebx,%ebx
40001e6b:	78 4c                	js     40001eb9 <subdir+0x3c9>
40001e6d:	85 c0                	test   %eax,%eax
40001e6f:	75 48                	jne    40001eb9 <subdir+0x3c9>
	asm volatile("int %2"
40001e71:	b8 07 00 00 00       	mov    $0x7,%eax
40001e76:	ba 00 20 00 00       	mov    $0x2000,%edx
40001e7b:	b9 a0 54 00 40       	mov    $0x400054a0,%ecx
40001e80:	cd 30                	int    $0x30
  if(read(fd, buf, sizeof(buf)) != 2){
40001e82:	83 fb 02             	cmp    $0x2,%ebx
40001e85:	75 08                	jne    40001e8f <subdir+0x39f>
40001e87:	85 c0                	test   %eax,%eax
40001e89:	0f 84 bd 00 00 00    	je     40001f4c <subdir+0x45c>
    printf("read dd/dd/ffff wrong len\n");
40001e8f:	83 ec 0c             	sub    $0xc,%esp
40001e92:	68 81 37 00 40       	push   $0x40003781
40001e97:	e8 a4 e4 ff ff       	call   40000340 <printf>
    exit();
40001e9c:	83 c4 10             	add    $0x10,%esp
40001e9f:	e9 17 fd ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("subdir mkdir dd/dd failed\n");
40001ea4:	83 ec 0c             	sub    $0xc,%esp
40001ea7:	68 5c 36 00 40       	push   $0x4000365c
40001eac:	e8 8f e4 ff ff       	call   40000340 <printf>
    exit();
40001eb1:	83 c4 10             	add    $0x10,%esp
40001eb4:	e9 02 fd ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("open dd/dd/ffff failed\n");
40001eb9:	83 ec 0c             	sub    $0xc,%esp
40001ebc:	68 69 37 00 40       	push   $0x40003769
40001ec1:	e8 7a e4 ff ff       	call   40000340 <printf>
    exit();
40001ec6:	83 c4 10             	add    $0x10,%esp
40001ec9:	e9 ed fc ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("open (unlinked) dd/dd/ff succeeded\n");
40001ece:	83 ec 0c             	sub    $0xc,%esp
40001ed1:	68 30 41 00 40       	push   $0x40004130
40001ed6:	e8 65 e4 ff ff       	call   40000340 <printf>
    exit();
40001edb:	83 c4 10             	add    $0x10,%esp
40001ede:	e9 d8 fc ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("unlink dd/dd/ff failed\n");
40001ee3:	83 ec 0c             	sub    $0xc,%esp
40001ee6:	68 f3 36 00 40       	push   $0x400036f3
40001eeb:	e8 50 e4 ff ff       	call   40000340 <printf>
    exit();
40001ef0:	83 c4 10             	add    $0x10,%esp
40001ef3:	e9 c3 fc ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("link dd/dd/ff dd/dd/ffff failed\n");
40001ef8:	83 ec 0c             	sub    $0xc,%esp
40001efb:	68 0c 41 00 40       	push   $0x4000410c
40001f00:	e8 3b e4 ff ff       	call   40000340 <printf>
    exit();
40001f05:	83 c4 10             	add    $0x10,%esp
40001f08:	e9 ae fc ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("chdir ./.. failed\n");
40001f0d:	83 ec 0c             	sub    $0xc,%esp
40001f10:	68 56 37 00 40       	push   $0x40003756
40001f15:	e8 26 e4 ff ff       	call   40000340 <printf>
    exit();
40001f1a:	83 c4 10             	add    $0x10,%esp
40001f1d:	e9 99 fc ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("chdir dd/../../dd failed\n");
40001f22:	83 ec 0c             	sub    $0xc,%esp
40001f25:	68 37 37 00 40       	push   $0x40003737
40001f2a:	e8 11 e4 ff ff       	call   40000340 <printf>
    exit();
40001f2f:	83 c4 10             	add    $0x10,%esp
40001f32:	e9 84 fc ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("chdir dd failed\n");
40001f37:	83 ec 0c             	sub    $0xc,%esp
40001f3a:	68 17 37 00 40       	push   $0x40003717
40001f3f:	e8 fc e3 ff ff       	call   40000340 <printf>
    exit();
40001f44:	83 c4 10             	add    $0x10,%esp
40001f47:	e9 6f fc ff ff       	jmp    40001bbb <subdir+0xcb>
	asm volatile("int %2"
40001f4c:	b8 06 00 00 00       	mov    $0x6,%eax
40001f51:	89 fb                	mov    %edi,%ebx
40001f53:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
40001f55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001f58:	bb 53 36 00 40       	mov    $0x40003653,%ebx
        unsigned int len = strlen(path);
40001f5d:	68 53 36 00 40       	push   $0x40003653
40001f62:	e8 79 eb ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001f67:	89 f1                	mov    %esi,%ecx
        unsigned int len = strlen(path);
40001f69:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001f6b:	b8 05 00 00 00       	mov    $0x5,%eax
40001f70:	cd 30                	int    $0x30
  if(open("dd/dd/ff", O_RDONLY) >= 0){
40001f72:	83 c4 10             	add    $0x10,%esp
40001f75:	85 db                	test   %ebx,%ebx
40001f77:	78 08                	js     40001f81 <subdir+0x491>
40001f79:	85 c0                	test   %eax,%eax
40001f7b:	0f 84 a8 01 00 00    	je     40002129 <subdir+0x639>
        unsigned int len = strlen(path);
40001f81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001f84:	bb 9c 37 00 40       	mov    $0x4000379c,%ebx
        unsigned int len = strlen(path);
40001f89:	68 9c 37 00 40       	push   $0x4000379c
40001f8e:	e8 4d eb ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001f93:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
40001f98:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001f9a:	b8 05 00 00 00       	mov    $0x5,%eax
40001f9f:	cd 30                	int    $0x30
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
40001fa1:	83 c4 10             	add    $0x10,%esp
40001fa4:	85 db                	test   %ebx,%ebx
40001fa6:	78 08                	js     40001fb0 <subdir+0x4c0>
40001fa8:	85 c0                	test   %eax,%eax
40001faa:	0f 84 b8 01 00 00    	je     40002168 <subdir+0x678>
        unsigned int len = strlen(path);
40001fb0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001fb3:	bb c1 37 00 40       	mov    $0x400037c1,%ebx
        unsigned int len = strlen(path);
40001fb8:	68 c1 37 00 40       	push   $0x400037c1
40001fbd:	e8 1e eb ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001fc2:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
40001fc7:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001fc9:	b8 05 00 00 00       	mov    $0x5,%eax
40001fce:	cd 30                	int    $0x30
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
40001fd0:	83 c4 10             	add    $0x10,%esp
40001fd3:	85 db                	test   %ebx,%ebx
40001fd5:	78 08                	js     40001fdf <subdir+0x4ef>
40001fd7:	85 c0                	test   %eax,%eax
40001fd9:	0f 84 5f 01 00 00    	je     4000213e <subdir+0x64e>
        unsigned int len = strlen(path);
40001fdf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40001fe2:	bb 34 37 00 40       	mov    $0x40003734,%ebx
        unsigned int len = strlen(path);
40001fe7:	68 34 37 00 40       	push   $0x40003734
40001fec:	e8 ef ea ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40001ff1:	b9 00 02 00 00       	mov    $0x200,%ecx
        unsigned int len = strlen(path);
40001ff6:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40001ff8:	b8 05 00 00 00       	mov    $0x5,%eax
40001ffd:	cd 30                	int    $0x30
  if(open("dd", O_CREATE) >= 0){
40001fff:	83 c4 10             	add    $0x10,%esp
40002002:	85 db                	test   %ebx,%ebx
40002004:	78 08                	js     4000200e <subdir+0x51e>
40002006:	85 c0                	test   %eax,%eax
40002008:	0f 84 45 01 00 00    	je     40002153 <subdir+0x663>
        unsigned int len = strlen(path);
4000200e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002011:	bb 34 37 00 40       	mov    $0x40003734,%ebx
        unsigned int len = strlen(path);
40002016:	68 34 37 00 40       	push   $0x40003734
4000201b:	e8 c0 ea ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002020:	b9 02 00 00 00       	mov    $0x2,%ecx
        unsigned int len = strlen(path);
40002025:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002027:	b8 05 00 00 00       	mov    $0x5,%eax
4000202c:	cd 30                	int    $0x30
  if(open("dd", O_RDWR) >= 0){
4000202e:	83 c4 10             	add    $0x10,%esp
40002031:	85 db                	test   %ebx,%ebx
40002033:	78 04                	js     40002039 <subdir+0x549>
40002035:	85 c0                	test   %eax,%eax
40002037:	74 7b                	je     400020b4 <subdir+0x5c4>
        unsigned int len = strlen(path);
40002039:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
4000203c:	bb 34 37 00 40       	mov    $0x40003734,%ebx
        unsigned int len = strlen(path);
40002041:	68 34 37 00 40       	push   $0x40003734
40002046:	e8 95 ea ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
4000204b:	b9 01 00 00 00       	mov    $0x1,%ecx
        unsigned int len = strlen(path);
40002050:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002052:	b8 05 00 00 00       	mov    $0x5,%eax
40002057:	cd 30                	int    $0x30
  if(open("dd", O_WRONLY) >= 0){
40002059:	83 c4 10             	add    $0x10,%esp
4000205c:	85 db                	test   %ebx,%ebx
4000205e:	78 04                	js     40002064 <subdir+0x574>
40002060:	85 c0                	test   %eax,%eax
40002062:	74 65                	je     400020c9 <subdir+0x5d9>
  old_len = strlen(old);
40002064:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002067:	bf 0c 00 00 00       	mov    $0xc,%edi
4000206c:	bb 9c 37 00 40       	mov    $0x4000379c,%ebx
  old_len = strlen(old);
40002071:	68 9c 37 00 40       	push   $0x4000379c
40002076:	e8 65 ea ff ff       	call   40000ae0 <strlen>
4000207b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  new_len = strlen(new);
4000207e:	c7 04 24 30 38 00 40 	movl   $0x40003830,(%esp)
40002085:	e8 56 ea ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
4000208a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
4000208d:	b9 30 38 00 40       	mov    $0x40003830,%ecx
  new_len = strlen(new);
40002092:	89 c6                	mov    %eax,%esi
	asm volatile("int %2"
40002094:	89 f8                	mov    %edi,%eax
40002096:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002098:	83 c4 10             	add    $0x10,%esp
4000209b:	85 c0                	test   %eax,%eax
4000209d:	75 3f                	jne    400020de <subdir+0x5ee>
    printf("link dd/ff/ff dd/dd/xx succeeded!\n");
4000209f:	83 ec 0c             	sub    $0xc,%esp
400020a2:	68 7c 41 00 40       	push   $0x4000417c
400020a7:	e8 94 e2 ff ff       	call   40000340 <printf>
    exit();
400020ac:	83 c4 10             	add    $0x10,%esp
400020af:	e9 07 fb ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("open dd rdwr succeeded!\n");
400020b4:	83 ec 0c             	sub    $0xc,%esp
400020b7:	68 fc 37 00 40       	push   $0x400037fc
400020bc:	e8 7f e2 ff ff       	call   40000340 <printf>
    exit();
400020c1:	83 c4 10             	add    $0x10,%esp
400020c4:	e9 f2 fa ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("open dd wronly succeeded!\n");
400020c9:	83 ec 0c             	sub    $0xc,%esp
400020cc:	68 15 38 00 40       	push   $0x40003815
400020d1:	e8 6a e2 ff ff       	call   40000340 <printf>
    exit();
400020d6:	83 c4 10             	add    $0x10,%esp
400020d9:	e9 dd fa ff ff       	jmp    40001bbb <subdir+0xcb>
  old_len = strlen(old);
400020de:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400020e1:	bb c1 37 00 40       	mov    $0x400037c1,%ebx
  old_len = strlen(old);
400020e6:	68 c1 37 00 40       	push   $0x400037c1
400020eb:	e8 f0 e9 ff ff       	call   40000ae0 <strlen>
400020f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  new_len = strlen(new);
400020f3:	c7 04 24 30 38 00 40 	movl   $0x40003830,(%esp)
400020fa:	e8 e1 e9 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
400020ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
40002102:	b9 30 38 00 40       	mov    $0x40003830,%ecx
  new_len = strlen(new);
40002107:	89 c6                	mov    %eax,%esi
	asm volatile("int %2"
40002109:	89 f8                	mov    %edi,%eax
4000210b:	cd 30                	int    $0x30
	return errno ? -1 : 0;
4000210d:	83 c4 10             	add    $0x10,%esp
40002110:	85 c0                	test   %eax,%eax
40002112:	75 69                	jne    4000217d <subdir+0x68d>
    printf("link dd/xx/ff dd/dd/xx succeeded!\n");
40002114:	83 ec 0c             	sub    $0xc,%esp
40002117:	68 a0 41 00 40       	push   $0x400041a0
4000211c:	e8 1f e2 ff ff       	call   40000340 <printf>
    exit();
40002121:	83 c4 10             	add    $0x10,%esp
40002124:	e9 92 fa ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("open (unlinked) dd/dd/ff succeeded!\n");
40002129:	83 ec 0c             	sub    $0xc,%esp
4000212c:	68 54 41 00 40       	push   $0x40004154
40002131:	e8 0a e2 ff ff       	call   40000340 <printf>
    exit();
40002136:	83 c4 10             	add    $0x10,%esp
40002139:	e9 7d fa ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("create dd/xx/ff succeeded!\n");
4000213e:	83 ec 0c             	sub    $0xc,%esp
40002141:	68 ca 37 00 40       	push   $0x400037ca
40002146:	e8 f5 e1 ff ff       	call   40000340 <printf>
    exit();
4000214b:	83 c4 10             	add    $0x10,%esp
4000214e:	e9 68 fa ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("create dd succeeded!\n");
40002153:	83 ec 0c             	sub    $0xc,%esp
40002156:	68 e6 37 00 40       	push   $0x400037e6
4000215b:	e8 e0 e1 ff ff       	call   40000340 <printf>
    exit();
40002160:	83 c4 10             	add    $0x10,%esp
40002163:	e9 53 fa ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("create dd/ff/ff succeeded!\n");
40002168:	83 ec 0c             	sub    $0xc,%esp
4000216b:	68 a5 37 00 40       	push   $0x400037a5
40002170:	e8 cb e1 ff ff       	call   40000340 <printf>
    exit();
40002175:	83 c4 10             	add    $0x10,%esp
40002178:	e9 3e fa ff ff       	jmp    40001bbb <subdir+0xcb>
  old_len = strlen(old);
4000217d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002180:	bb 56 36 00 40       	mov    $0x40003656,%ebx
  old_len = strlen(old);
40002185:	68 56 36 00 40       	push   $0x40003656
4000218a:	e8 51 e9 ff ff       	call   40000ae0 <strlen>
4000218f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  new_len = strlen(new);
40002192:	c7 04 24 e8 36 00 40 	movl   $0x400036e8,(%esp)
40002199:	e8 42 e9 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
4000219e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
400021a1:	b9 e8 36 00 40       	mov    $0x400036e8,%ecx
  new_len = strlen(new);
400021a6:	89 c6                	mov    %eax,%esi
	asm volatile("int %2"
400021a8:	89 f8                	mov    %edi,%eax
400021aa:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400021ac:	83 c4 10             	add    $0x10,%esp
400021af:	85 c0                	test   %eax,%eax
400021b1:	75 15                	jne    400021c8 <subdir+0x6d8>
    printf("link dd/ff dd/dd/ffff succeeded!\n");
400021b3:	83 ec 0c             	sub    $0xc,%esp
400021b6:	68 c4 41 00 40       	push   $0x400041c4
400021bb:	e8 80 e1 ff ff       	call   40000340 <printf>
    exit();
400021c0:	83 c4 10             	add    $0x10,%esp
400021c3:	e9 f3 f9 ff ff       	jmp    40001bbb <subdir+0xcb>
  unsigned int len = strlen(path);
400021c8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400021cb:	be 0a 00 00 00       	mov    $0xa,%esi
400021d0:	bb 9c 37 00 40       	mov    $0x4000379c,%ebx
  unsigned int len = strlen(path);
400021d5:	68 9c 37 00 40       	push   $0x4000379c
400021da:	e8 01 e9 ff ff       	call   40000ae0 <strlen>
400021df:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400021e1:	89 f0                	mov    %esi,%eax
400021e3:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400021e5:	83 c4 10             	add    $0x10,%esp
400021e8:	85 c0                	test   %eax,%eax
400021ea:	75 15                	jne    40002201 <subdir+0x711>
    printf("mkdir dd/ff/ff succeeded!\n");
400021ec:	83 ec 0c             	sub    $0xc,%esp
400021ef:	68 39 38 00 40       	push   $0x40003839
400021f4:	e8 47 e1 ff ff       	call   40000340 <printf>
    exit();
400021f9:	83 c4 10             	add    $0x10,%esp
400021fc:	e9 ba f9 ff ff       	jmp    40001bbb <subdir+0xcb>
  unsigned int len = strlen(path);
40002201:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002204:	bb c1 37 00 40       	mov    $0x400037c1,%ebx
  unsigned int len = strlen(path);
40002209:	68 c1 37 00 40       	push   $0x400037c1
4000220e:	e8 cd e8 ff ff       	call   40000ae0 <strlen>
40002213:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002215:	89 f0                	mov    %esi,%eax
40002217:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002219:	83 c4 10             	add    $0x10,%esp
4000221c:	85 c0                	test   %eax,%eax
4000221e:	75 15                	jne    40002235 <subdir+0x745>
    printf("mkdir dd/xx/ff succeeded!\n");
40002220:	83 ec 0c             	sub    $0xc,%esp
40002223:	68 54 38 00 40       	push   $0x40003854
40002228:	e8 13 e1 ff ff       	call   40000340 <printf>
    exit();
4000222d:	83 c4 10             	add    $0x10,%esp
40002230:	e9 86 f9 ff ff       	jmp    40001bbb <subdir+0xcb>
  unsigned int len = strlen(path);
40002235:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002238:	bb e8 36 00 40       	mov    $0x400036e8,%ebx
  unsigned int len = strlen(path);
4000223d:	68 e8 36 00 40       	push   $0x400036e8
40002242:	e8 99 e8 ff ff       	call   40000ae0 <strlen>
40002247:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002249:	89 f0                	mov    %esi,%eax
4000224b:	cd 30                	int    $0x30
	return errno ? -1 : 0;
4000224d:	83 c4 10             	add    $0x10,%esp
40002250:	85 c0                	test   %eax,%eax
40002252:	75 15                	jne    40002269 <subdir+0x779>
    printf("mkdir dd/dd/ffff succeeded!\n");
40002254:	83 ec 0c             	sub    $0xc,%esp
40002257:	68 6f 38 00 40       	push   $0x4000386f
4000225c:	e8 df e0 ff ff       	call   40000340 <printf>
    exit();
40002261:	83 c4 10             	add    $0x10,%esp
40002264:	e9 52 f9 ff ff       	jmp    40001bbb <subdir+0xcb>
  unsigned int len = strlen(path);
40002269:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
4000226c:	bb c1 37 00 40       	mov    $0x400037c1,%ebx
  unsigned int len = strlen(path);
40002271:	68 c1 37 00 40       	push   $0x400037c1
40002276:	e8 65 e8 ff ff       	call   40000ae0 <strlen>
4000227b:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000227d:	b8 0d 00 00 00       	mov    $0xd,%eax
40002282:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002284:	83 c4 10             	add    $0x10,%esp
40002287:	85 c0                	test   %eax,%eax
40002289:	75 15                	jne    400022a0 <subdir+0x7b0>
    printf("unlink dd/xx/ff succeeded!\n");
4000228b:	83 ec 0c             	sub    $0xc,%esp
4000228e:	68 8c 38 00 40       	push   $0x4000388c
40002293:	e8 a8 e0 ff ff       	call   40000340 <printf>
    exit();
40002298:	83 c4 10             	add    $0x10,%esp
4000229b:	e9 1b f9 ff ff       	jmp    40001bbb <subdir+0xcb>
  unsigned int len = strlen(path);
400022a0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400022a3:	bb 9c 37 00 40       	mov    $0x4000379c,%ebx
  unsigned int len = strlen(path);
400022a8:	68 9c 37 00 40       	push   $0x4000379c
400022ad:	e8 2e e8 ff ff       	call   40000ae0 <strlen>
400022b2:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400022b4:	b8 0d 00 00 00       	mov    $0xd,%eax
400022b9:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400022bb:	83 c4 10             	add    $0x10,%esp
400022be:	85 c0                	test   %eax,%eax
400022c0:	75 15                	jne    400022d7 <subdir+0x7e7>
    printf("unlink dd/ff/ff succeeded!\n");
400022c2:	83 ec 0c             	sub    $0xc,%esp
400022c5:	68 a8 38 00 40       	push   $0x400038a8
400022ca:	e8 71 e0 ff ff       	call   40000340 <printf>
    exit();
400022cf:	83 c4 10             	add    $0x10,%esp
400022d2:	e9 e4 f8 ff ff       	jmp    40001bbb <subdir+0xcb>
  unsigned int len = strlen(path);
400022d7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400022da:	bb 56 36 00 40       	mov    $0x40003656,%ebx
  unsigned int len = strlen(path);
400022df:	68 56 36 00 40       	push   $0x40003656
400022e4:	e8 f7 e7 ff ff       	call   40000ae0 <strlen>
400022e9:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400022eb:	b8 0b 00 00 00       	mov    $0xb,%eax
400022f0:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400022f2:	83 c4 10             	add    $0x10,%esp
400022f5:	85 c0                	test   %eax,%eax
400022f7:	75 15                	jne    4000230e <subdir+0x81e>
    printf("chdir dd/ff succeeded!\n");
400022f9:	83 ec 0c             	sub    $0xc,%esp
400022fc:	68 c4 38 00 40       	push   $0x400038c4
40002301:	e8 3a e0 ff ff       	call   40000340 <printf>
    exit();
40002306:	83 c4 10             	add    $0x10,%esp
40002309:	e9 ad f8 ff ff       	jmp    40001bbb <subdir+0xcb>
  unsigned int len = strlen(path);
4000230e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002311:	bb 33 38 00 40       	mov    $0x40003833,%ebx
  unsigned int len = strlen(path);
40002316:	68 33 38 00 40       	push   $0x40003833
4000231b:	e8 c0 e7 ff ff       	call   40000ae0 <strlen>
40002320:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002322:	b8 0b 00 00 00       	mov    $0xb,%eax
40002327:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002329:	83 c4 10             	add    $0x10,%esp
4000232c:	85 c0                	test   %eax,%eax
4000232e:	75 15                	jne    40002345 <subdir+0x855>
    printf("chdir dd/xx succeeded!\n");
40002330:	83 ec 0c             	sub    $0xc,%esp
40002333:	68 dc 38 00 40       	push   $0x400038dc
40002338:	e8 03 e0 ff ff       	call   40000340 <printf>
    exit();
4000233d:	83 c4 10             	add    $0x10,%esp
40002340:	e9 76 f8 ff ff       	jmp    40001bbb <subdir+0xcb>
  unsigned int len = strlen(path);
40002345:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002348:	bb e8 36 00 40       	mov    $0x400036e8,%ebx
  unsigned int len = strlen(path);
4000234d:	68 e8 36 00 40       	push   $0x400036e8
40002352:	e8 89 e7 ff ff       	call   40000ae0 <strlen>
40002357:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002359:	b8 0d 00 00 00       	mov    $0xd,%eax
4000235e:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002360:	83 c4 10             	add    $0x10,%esp
40002363:	85 c0                	test   %eax,%eax
40002365:	0f 85 78 fb ff ff    	jne    40001ee3 <subdir+0x3f3>
  unsigned int len = strlen(path);
4000236b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
4000236e:	bb 56 36 00 40       	mov    $0x40003656,%ebx
  unsigned int len = strlen(path);
40002373:	68 56 36 00 40       	push   $0x40003656
40002378:	e8 63 e7 ff ff       	call   40000ae0 <strlen>
4000237d:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000237f:	b8 0d 00 00 00       	mov    $0xd,%eax
40002384:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002386:	83 c4 10             	add    $0x10,%esp
40002389:	85 c0                	test   %eax,%eax
4000238b:	75 37                	jne    400023c4 <subdir+0x8d4>
  unsigned int len = strlen(path);
4000238d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002390:	bb 34 37 00 40       	mov    $0x40003734,%ebx
  unsigned int len = strlen(path);
40002395:	68 34 37 00 40       	push   $0x40003734
4000239a:	e8 41 e7 ff ff       	call   40000ae0 <strlen>
4000239f:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400023a1:	b8 0d 00 00 00       	mov    $0xd,%eax
400023a6:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400023a8:	83 c4 10             	add    $0x10,%esp
400023ab:	85 c0                	test   %eax,%eax
400023ad:	75 2a                	jne    400023d9 <subdir+0x8e9>
    printf("unlink non-empty dd succeeded!\n");
400023af:	83 ec 0c             	sub    $0xc,%esp
400023b2:	68 e8 41 00 40       	push   $0x400041e8
400023b7:	e8 84 df ff ff       	call   40000340 <printf>
    exit();
400023bc:	83 c4 10             	add    $0x10,%esp
400023bf:	e9 f7 f7 ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("unlink dd/ff failed\n");
400023c4:	83 ec 0c             	sub    $0xc,%esp
400023c7:	68 f4 38 00 40       	push   $0x400038f4
400023cc:	e8 6f df ff ff       	call   40000340 <printf>
    exit();
400023d1:	83 c4 10             	add    $0x10,%esp
400023d4:	e9 e2 f7 ff ff       	jmp    40001bbb <subdir+0xcb>
  unsigned int len = strlen(path);
400023d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400023dc:	bb 4d 36 00 40       	mov    $0x4000364d,%ebx
  unsigned int len = strlen(path);
400023e1:	68 4d 36 00 40       	push   $0x4000364d
400023e6:	e8 f5 e6 ff ff       	call   40000ae0 <strlen>
400023eb:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400023ed:	b8 0d 00 00 00       	mov    $0xd,%eax
400023f2:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400023f4:	83 c4 10             	add    $0x10,%esp
400023f7:	85 c0                	test   %eax,%eax
400023f9:	75 37                	jne    40002432 <subdir+0x942>
  unsigned int len = strlen(path);
400023fb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400023fe:	bb 34 37 00 40       	mov    $0x40003734,%ebx
  unsigned int len = strlen(path);
40002403:	68 34 37 00 40       	push   $0x40003734
40002408:	e8 d3 e6 ff ff       	call   40000ae0 <strlen>
4000240d:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000240f:	b8 0d 00 00 00       	mov    $0xd,%eax
40002414:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002416:	83 c4 10             	add    $0x10,%esp
40002419:	85 c0                	test   %eax,%eax
4000241b:	75 2a                	jne    40002447 <subdir+0x957>
  printf("=====subdir ok=====\n\n");
4000241d:	83 ec 0c             	sub    $0xc,%esp
40002420:	68 1e 39 00 40       	push   $0x4000391e
40002425:	e8 16 df ff ff       	call   40000340 <printf>
4000242a:	83 c4 10             	add    $0x10,%esp
4000242d:	e9 89 f7 ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("unlink dd/dd failed\n");
40002432:	83 ec 0c             	sub    $0xc,%esp
40002435:	68 09 39 00 40       	push   $0x40003909
4000243a:	e8 01 df ff ff       	call   40000340 <printf>
    exit();
4000243f:	83 c4 10             	add    $0x10,%esp
40002442:	e9 74 f7 ff ff       	jmp    40001bbb <subdir+0xcb>
    printf("unlink dd failed\n");
40002447:	83 ec 0c             	sub    $0xc,%esp
4000244a:	68 34 39 00 40       	push   $0x40003934
4000244f:	e8 ec de ff ff       	call   40000340 <printf>
    exit();
40002454:	83 c4 10             	add    $0x10,%esp
40002457:	e9 5f f7 ff ff       	jmp    40001bbb <subdir+0xcb>
4000245c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40002460 <linktest>:
{
40002460:	55                   	push   %ebp
40002461:	89 e5                	mov    %esp,%ebp
40002463:	57                   	push   %edi
40002464:	56                   	push   %esi
40002465:	53                   	push   %ebx
	asm volatile("int %2"
40002466:	bb 5a 39 00 40       	mov    $0x4000395a,%ebx
4000246b:	83 ec 28             	sub    $0x28,%esp
  printf("=====linktest=====\n");
4000246e:	68 46 39 00 40       	push   $0x40003946
40002473:	e8 c8 de ff ff       	call   40000340 <printf>
  unsigned int len = strlen(path);
40002478:	c7 04 24 5a 39 00 40 	movl   $0x4000395a,(%esp)
4000247f:	e8 5c e6 ff ff       	call   40000ae0 <strlen>
40002484:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002486:	b8 0d 00 00 00       	mov    $0xd,%eax
4000248b:	cd 30                	int    $0x30
  unsigned int len = strlen(path);
4000248d:	c7 04 24 5e 39 00 40 	movl   $0x4000395e,(%esp)
	asm volatile("int %2"
40002494:	bb 5e 39 00 40       	mov    $0x4000395e,%ebx
  unsigned int len = strlen(path);
40002499:	e8 42 e6 ff ff       	call   40000ae0 <strlen>
4000249e:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400024a0:	b8 0d 00 00 00       	mov    $0xd,%eax
400024a5:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
400024a7:	c7 04 24 5a 39 00 40 	movl   $0x4000395a,(%esp)
	asm volatile("int %2"
400024ae:	bb 5a 39 00 40       	mov    $0x4000395a,%ebx
        unsigned int len = strlen(path);
400024b3:	e8 28 e6 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
400024b8:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
400024bd:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
400024bf:	b8 05 00 00 00       	mov    $0x5,%eax
400024c4:	cd 30                	int    $0x30
  if(fd < 0){
400024c6:	83 c4 10             	add    $0x10,%esp
400024c9:	85 db                	test   %ebx,%ebx
400024cb:	78 3b                	js     40002508 <linktest+0xa8>
400024cd:	85 c0                	test   %eax,%eax
400024cf:	75 37                	jne    40002508 <linktest+0xa8>
400024d1:	89 de                	mov    %ebx,%esi
	asm volatile("int %2"
400024d3:	b8 08 00 00 00       	mov    $0x8,%eax
400024d8:	b9 75 39 00 40       	mov    $0x40003975,%ecx
400024dd:	ba 05 00 00 00       	mov    $0x5,%edx
400024e2:	cd 30                	int    $0x30
  if(write(fd, "hello", 5) != 5){
400024e4:	83 fb 05             	cmp    $0x5,%ebx
400024e7:	75 04                	jne    400024ed <linktest+0x8d>
400024e9:	85 c0                	test   %eax,%eax
400024eb:	74 33                	je     40002520 <linktest+0xc0>
    printf("write lf1 failed\n");
400024ed:	83 ec 0c             	sub    $0xc,%esp
400024f0:	68 7b 39 00 40       	push   $0x4000397b
400024f5:	e8 46 de ff ff       	call   40000340 <printf>
    exit();
400024fa:	83 c4 10             	add    $0x10,%esp
}
400024fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002500:	5b                   	pop    %ebx
40002501:	5e                   	pop    %esi
40002502:	5f                   	pop    %edi
40002503:	5d                   	pop    %ebp
40002504:	c3                   	ret
40002505:	8d 76 00             	lea    0x0(%esi),%esi
    printf("create lf1 failed\n");
40002508:	83 ec 0c             	sub    $0xc,%esp
4000250b:	68 62 39 00 40       	push   $0x40003962
40002510:	e8 2b de ff ff       	call   40000340 <printf>
    exit();
40002515:	83 c4 10             	add    $0x10,%esp
}
40002518:	8d 65 f4             	lea    -0xc(%ebp),%esp
4000251b:	5b                   	pop    %ebx
4000251c:	5e                   	pop    %esi
4000251d:	5f                   	pop    %edi
4000251e:	5d                   	pop    %ebp
4000251f:	c3                   	ret
	asm volatile("int %2"
40002520:	b8 06 00 00 00       	mov    $0x6,%eax
40002525:	89 f3                	mov    %esi,%ebx
40002527:	cd 30                	int    $0x30
  old_len = strlen(old);
40002529:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
4000252c:	bb 5a 39 00 40       	mov    $0x4000395a,%ebx
  old_len = strlen(old);
40002531:	68 5a 39 00 40       	push   $0x4000395a
40002536:	e8 a5 e5 ff ff       	call   40000ae0 <strlen>
4000253b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  new_len = strlen(new);
4000253e:	c7 04 24 5e 39 00 40 	movl   $0x4000395e,(%esp)
40002545:	e8 96 e5 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
4000254a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
4000254d:	b9 5e 39 00 40       	mov    $0x4000395e,%ecx
  new_len = strlen(new);
40002552:	89 c6                	mov    %eax,%esi
	asm volatile("int %2"
40002554:	b8 0c 00 00 00       	mov    $0xc,%eax
40002559:	cd 30                	int    $0x30
4000255b:	89 c6                	mov    %eax,%esi
	return errno ? -1 : 0;
4000255d:	83 c4 10             	add    $0x10,%esp
40002560:	85 c0                	test   %eax,%eax
40002562:	0f 85 2d 01 00 00    	jne    40002695 <linktest+0x235>
  unsigned int len = strlen(path);
40002568:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
4000256b:	bb 5a 39 00 40       	mov    $0x4000395a,%ebx
  unsigned int len = strlen(path);
40002570:	68 5a 39 00 40       	push   $0x4000395a
40002575:	e8 66 e5 ff ff       	call   40000ae0 <strlen>
4000257a:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000257c:	b8 0d 00 00 00       	mov    $0xd,%eax
40002581:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
40002583:	c7 04 24 5a 39 00 40 	movl   $0x4000395a,(%esp)
	asm volatile("int %2"
4000258a:	bb 5a 39 00 40       	mov    $0x4000395a,%ebx
        unsigned int len = strlen(path);
4000258f:	e8 4c e5 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002594:	89 f1                	mov    %esi,%ecx
        unsigned int len = strlen(path);
40002596:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002598:	b8 05 00 00 00       	mov    $0x5,%eax
4000259d:	cd 30                	int    $0x30
  if(open("lf1", 0) >= 0){
4000259f:	83 c4 10             	add    $0x10,%esp
400025a2:	85 db                	test   %ebx,%ebx
400025a4:	78 08                	js     400025ae <linktest+0x14e>
400025a6:	85 c0                	test   %eax,%eax
400025a8:	0f 84 ba 00 00 00    	je     40002668 <linktest+0x208>
        unsigned int len = strlen(path);
400025ae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400025b1:	bb 5e 39 00 40       	mov    $0x4000395e,%ebx
        unsigned int len = strlen(path);
400025b6:	68 5e 39 00 40       	push   $0x4000395e
400025bb:	e8 20 e5 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
400025c0:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
400025c2:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
400025c4:	b8 05 00 00 00       	mov    $0x5,%eax
400025c9:	cd 30                	int    $0x30
400025cb:	89 de                	mov    %ebx,%esi
  if(fd < 0){
400025cd:	83 c4 10             	add    $0x10,%esp
400025d0:	85 db                	test   %ebx,%ebx
400025d2:	0f 88 a8 00 00 00    	js     40002680 <linktest+0x220>
400025d8:	85 c0                	test   %eax,%eax
400025da:	0f 85 a0 00 00 00    	jne    40002680 <linktest+0x220>
	asm volatile("int %2"
400025e0:	b8 07 00 00 00       	mov    $0x7,%eax
400025e5:	b9 a0 54 00 40       	mov    $0x400054a0,%ecx
400025ea:	ba 00 20 00 00       	mov    $0x2000,%edx
400025ef:	cd 30                	int    $0x30
  if(read(fd, buf, sizeof(buf)) != 5){
400025f1:	83 fb 05             	cmp    $0x5,%ebx
400025f4:	75 5a                	jne    40002650 <linktest+0x1f0>
400025f6:	85 c0                	test   %eax,%eax
400025f8:	75 56                	jne    40002650 <linktest+0x1f0>
	asm volatile("int %2"
400025fa:	b8 06 00 00 00       	mov    $0x6,%eax
400025ff:	89 f3                	mov    %esi,%ebx
40002601:	cd 30                	int    $0x30
  old_len = strlen(old);
40002603:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002606:	bf 0c 00 00 00       	mov    $0xc,%edi
4000260b:	bb 5e 39 00 40       	mov    $0x4000395e,%ebx
  old_len = strlen(old);
40002610:	68 5e 39 00 40       	push   $0x4000395e
40002615:	e8 c6 e4 ff ff       	call   40000ae0 <strlen>
4000261a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  new_len = strlen(new);
4000261d:	c7 04 24 5e 39 00 40 	movl   $0x4000395e,(%esp)
40002624:	e8 b7 e4 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002629:	8b 55 e4             	mov    -0x1c(%ebp),%edx
4000262c:	89 d9                	mov    %ebx,%ecx
  new_len = strlen(new);
4000262e:	89 c6                	mov    %eax,%esi
	asm volatile("int %2"
40002630:	89 f8                	mov    %edi,%eax
40002632:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002634:	83 c4 10             	add    $0x10,%esp
40002637:	85 c0                	test   %eax,%eax
40002639:	75 6f                	jne    400026aa <linktest+0x24a>
    printf("link lf2 lf2 succeeded! oops\n");
4000263b:	83 ec 0c             	sub    $0xc,%esp
4000263e:	68 c4 39 00 40       	push   $0x400039c4
40002643:	e8 f8 dc ff ff       	call   40000340 <printf>
    exit();
40002648:	83 c4 10             	add    $0x10,%esp
4000264b:	e9 ad fe ff ff       	jmp    400024fd <linktest+0x9d>
    printf("read lf2 failed\n");
40002650:	83 ec 0c             	sub    $0xc,%esp
40002653:	68 b3 39 00 40       	push   $0x400039b3
40002658:	e8 e3 dc ff ff       	call   40000340 <printf>
    exit();
4000265d:	83 c4 10             	add    $0x10,%esp
40002660:	e9 98 fe ff ff       	jmp    400024fd <linktest+0x9d>
40002665:	8d 76 00             	lea    0x0(%esi),%esi
    printf("unlinked lf1 but it is still there!\n");
40002668:	83 ec 0c             	sub    $0xc,%esp
4000266b:	68 08 42 00 40       	push   $0x40004208
40002670:	e8 cb dc ff ff       	call   40000340 <printf>
    exit();
40002675:	83 c4 10             	add    $0x10,%esp
40002678:	e9 80 fe ff ff       	jmp    400024fd <linktest+0x9d>
4000267d:	8d 76 00             	lea    0x0(%esi),%esi
    printf("open lf2 failed\n");
40002680:	83 ec 0c             	sub    $0xc,%esp
40002683:	68 a2 39 00 40       	push   $0x400039a2
40002688:	e8 b3 dc ff ff       	call   40000340 <printf>
    exit();
4000268d:	83 c4 10             	add    $0x10,%esp
40002690:	e9 68 fe ff ff       	jmp    400024fd <linktest+0x9d>
    printf("link lf1 lf2 failed\n");
40002695:	83 ec 0c             	sub    $0xc,%esp
40002698:	68 8d 39 00 40       	push   $0x4000398d
4000269d:	e8 9e dc ff ff       	call   40000340 <printf>
    exit();
400026a2:	83 c4 10             	add    $0x10,%esp
400026a5:	e9 53 fe ff ff       	jmp    400024fd <linktest+0x9d>
  unsigned int len = strlen(path);
400026aa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400026ad:	bb 5e 39 00 40       	mov    $0x4000395e,%ebx
  unsigned int len = strlen(path);
400026b2:	68 5e 39 00 40       	push   $0x4000395e
400026b7:	e8 24 e4 ff ff       	call   40000ae0 <strlen>
400026bc:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400026be:	b8 0d 00 00 00       	mov    $0xd,%eax
400026c3:	cd 30                	int    $0x30
  old_len = strlen(old);
400026c5:	c7 04 24 5e 39 00 40 	movl   $0x4000395e,(%esp)
	asm volatile("int %2"
400026cc:	bb 5e 39 00 40       	mov    $0x4000395e,%ebx
  old_len = strlen(old);
400026d1:	e8 0a e4 ff ff       	call   40000ae0 <strlen>
400026d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  new_len = strlen(new);
400026d9:	c7 04 24 5a 39 00 40 	movl   $0x4000395a,(%esp)
400026e0:	e8 fb e3 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
400026e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
400026e8:	b9 5a 39 00 40       	mov    $0x4000395a,%ecx
  new_len = strlen(new);
400026ed:	89 c6                	mov    %eax,%esi
	asm volatile("int %2"
400026ef:	89 f8                	mov    %edi,%eax
400026f1:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400026f3:	83 c4 10             	add    $0x10,%esp
400026f6:	85 c0                	test   %eax,%eax
400026f8:	75 15                	jne    4000270f <linktest+0x2af>
    printf("link non-existant succeeded! oops\n");
400026fa:	83 ec 0c             	sub    $0xc,%esp
400026fd:	68 30 42 00 40       	push   $0x40004230
40002702:	e8 39 dc ff ff       	call   40000340 <printf>
    exit();
40002707:	83 c4 10             	add    $0x10,%esp
4000270a:	e9 ee fd ff ff       	jmp    400024fd <linktest+0x9d>
  old_len = strlen(old);
4000270f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002712:	bb 54 37 00 40       	mov    $0x40003754,%ebx
  old_len = strlen(old);
40002717:	68 54 37 00 40       	push   $0x40003754
4000271c:	e8 bf e3 ff ff       	call   40000ae0 <strlen>
40002721:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  new_len = strlen(new);
40002724:	c7 04 24 5a 39 00 40 	movl   $0x4000395a,(%esp)
4000272b:	e8 b0 e3 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002730:	8b 55 e4             	mov    -0x1c(%ebp),%edx
40002733:	b9 5a 39 00 40       	mov    $0x4000395a,%ecx
  new_len = strlen(new);
40002738:	89 c6                	mov    %eax,%esi
	asm volatile("int %2"
4000273a:	89 f8                	mov    %edi,%eax
4000273c:	cd 30                	int    $0x30
	return errno ? -1 : 0;
4000273e:	83 c4 10             	add    $0x10,%esp
40002741:	85 c0                	test   %eax,%eax
40002743:	75 15                	jne    4000275a <linktest+0x2fa>
    printf("link . lf1 succeeded! oops\n");
40002745:	83 ec 0c             	sub    $0xc,%esp
40002748:	68 e2 39 00 40       	push   $0x400039e2
4000274d:	e8 ee db ff ff       	call   40000340 <printf>
    exit();
40002752:	83 c4 10             	add    $0x10,%esp
40002755:	e9 a3 fd ff ff       	jmp    400024fd <linktest+0x9d>
  printf("=====linktest ok=====\n\n");
4000275a:	83 ec 0c             	sub    $0xc,%esp
4000275d:	68 fe 39 00 40       	push   $0x400039fe
40002762:	e8 d9 db ff ff       	call   40000340 <printf>
40002767:	83 c4 10             	add    $0x10,%esp
4000276a:	e9 8e fd ff ff       	jmp    400024fd <linktest+0x9d>
4000276f:	90                   	nop

40002770 <unlinkread>:
{
40002770:	55                   	push   %ebp
40002771:	89 e5                	mov    %esp,%ebp
40002773:	57                   	push   %edi
40002774:	56                   	push   %esi
40002775:	53                   	push   %ebx
	asm volatile("int %2"
40002776:	bb 31 3a 00 40       	mov    $0x40003a31,%ebx
4000277b:	83 ec 18             	sub    $0x18,%esp
  printf("=====unlinkread test=====\n");
4000277e:	68 16 3a 00 40       	push   $0x40003a16
40002783:	e8 b8 db ff ff       	call   40000340 <printf>
        unsigned int len = strlen(path);
40002788:	c7 04 24 31 3a 00 40 	movl   $0x40003a31,(%esp)
4000278f:	e8 4c e3 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002794:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
40002799:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
4000279b:	b8 05 00 00 00       	mov    $0x5,%eax
400027a0:	cd 30                	int    $0x30
  if(fd < 0){
400027a2:	83 c4 10             	add    $0x10,%esp
400027a5:	85 db                	test   %ebx,%ebx
400027a7:	0f 88 63 01 00 00    	js     40002910 <unlinkread+0x1a0>
400027ad:	85 c0                	test   %eax,%eax
400027af:	0f 85 5b 01 00 00    	jne    40002910 <unlinkread+0x1a0>
400027b5:	89 de                	mov    %ebx,%esi
	asm volatile("int %2"
400027b7:	b8 08 00 00 00       	mov    $0x8,%eax
400027bc:	b9 75 39 00 40       	mov    $0x40003975,%ecx
400027c1:	ba 05 00 00 00       	mov    $0x5,%edx
400027c6:	cd 30                	int    $0x30
	asm volatile("int %2"
400027c8:	b8 06 00 00 00       	mov    $0x6,%eax
400027cd:	89 f3                	mov    %esi,%ebx
400027cf:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
400027d1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400027d4:	bb 31 3a 00 40       	mov    $0x40003a31,%ebx
        unsigned int len = strlen(path);
400027d9:	68 31 3a 00 40       	push   $0x40003a31
400027de:	e8 fd e2 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
400027e3:	b9 02 00 00 00       	mov    $0x2,%ecx
        unsigned int len = strlen(path);
400027e8:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
400027ea:	b8 05 00 00 00       	mov    $0x5,%eax
400027ef:	cd 30                	int    $0x30
400027f1:	89 de                	mov    %ebx,%esi
  if(fd < 0){
400027f3:	83 c4 10             	add    $0x10,%esp
400027f6:	85 db                	test   %ebx,%ebx
400027f8:	0f 88 d2 00 00 00    	js     400028d0 <unlinkread+0x160>
400027fe:	85 c0                	test   %eax,%eax
40002800:	0f 85 ca 00 00 00    	jne    400028d0 <unlinkread+0x160>
  unsigned int len = strlen(path);
40002806:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002809:	bb 31 3a 00 40       	mov    $0x40003a31,%ebx
  unsigned int len = strlen(path);
4000280e:	68 31 3a 00 40       	push   $0x40003a31
40002813:	e8 c8 e2 ff ff       	call   40000ae0 <strlen>
40002818:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000281a:	b8 0d 00 00 00       	mov    $0xd,%eax
4000281f:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002821:	83 c4 10             	add    $0x10,%esp
40002824:	85 c0                	test   %eax,%eax
40002826:	0f 85 4e 01 00 00    	jne    4000297a <unlinkread+0x20a>
        unsigned int len = strlen(path);
4000282c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
4000282f:	bb 31 3a 00 40       	mov    $0x40003a31,%ebx
        unsigned int len = strlen(path);
40002834:	68 31 3a 00 40       	push   $0x40003a31
40002839:	e8 a2 e2 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
4000283e:	b9 02 02 00 00       	mov    $0x202,%ecx
        unsigned int len = strlen(path);
40002843:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002845:	b8 05 00 00 00       	mov    $0x5,%eax
4000284a:	cd 30                	int    $0x30
4000284c:	89 df                	mov    %ebx,%edi
	return errno ? -1 : fd;
4000284e:	83 c4 10             	add    $0x10,%esp
40002851:	85 c0                	test   %eax,%eax
40002853:	0f 85 36 01 00 00    	jne    4000298f <unlinkread+0x21f>
	asm volatile("int %2"
40002859:	b9 88 3a 00 40       	mov    $0x40003a88,%ecx
4000285e:	ba 03 00 00 00       	mov    $0x3,%edx
40002863:	b8 08 00 00 00       	mov    $0x8,%eax
40002868:	89 fb                	mov    %edi,%ebx
4000286a:	cd 30                	int    $0x30
	asm volatile("int %2"
4000286c:	b8 06 00 00 00       	mov    $0x6,%eax
40002871:	89 fb                	mov    %edi,%ebx
40002873:	cd 30                	int    $0x30
	asm volatile("int %2"
40002875:	b9 a0 54 00 40       	mov    $0x400054a0,%ecx
4000287a:	b8 07 00 00 00       	mov    $0x7,%eax
4000287f:	ba 00 20 00 00       	mov    $0x2000,%edx
40002884:	89 f3                	mov    %esi,%ebx
40002886:	cd 30                	int    $0x30
  if(read(fd, buf, sizeof(buf)) != 5){
40002888:	83 fb 05             	cmp    $0x5,%ebx
4000288b:	75 63                	jne    400028f0 <unlinkread+0x180>
4000288d:	85 c0                	test   %eax,%eax
4000288f:	75 5f                	jne    400028f0 <unlinkread+0x180>
  if(buf[0] != 'h'){
40002891:	80 3d a0 54 00 40 68 	cmpb   $0x68,0x400054a0
40002898:	0f 85 92 00 00 00    	jne    40002930 <unlinkread+0x1c0>
	asm volatile("int %2"
4000289e:	ba 0a 00 00 00       	mov    $0xa,%edx
400028a3:	b8 08 00 00 00       	mov    $0x8,%eax
400028a8:	89 f3                	mov    %esi,%ebx
400028aa:	cd 30                	int    $0x30
  if(write(fd, buf, 10) != 10){
400028ac:	83 fb 0a             	cmp    $0xa,%ebx
400028af:	75 08                	jne    400028b9 <unlinkread+0x149>
400028b1:	85 c0                	test   %eax,%eax
400028b3:	0f 84 89 00 00 00    	je     40002942 <unlinkread+0x1d2>
    printf("unlinkread write failed\n");
400028b9:	83 ec 0c             	sub    $0xc,%esp
400028bc:	68 ba 3a 00 40       	push   $0x40003aba
400028c1:	e8 7a da ff ff       	call   40000340 <printf>
    exit();
400028c6:	83 c4 10             	add    $0x10,%esp
400028c9:	eb 15                	jmp    400028e0 <unlinkread+0x170>
400028cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    printf("open unlinkread failed\n");
400028d0:	83 ec 0c             	sub    $0xc,%esp
400028d3:	68 56 3a 00 40       	push   $0x40003a56
400028d8:	e8 63 da ff ff       	call   40000340 <printf>
    exit();
400028dd:	83 c4 10             	add    $0x10,%esp
}
400028e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
400028e3:	5b                   	pop    %ebx
400028e4:	5e                   	pop    %esi
400028e5:	5f                   	pop    %edi
400028e6:	5d                   	pop    %ebp
400028e7:	c3                   	ret
400028e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400028ef:	00 
    printf("unlinkread read failed");
400028f0:	83 ec 0c             	sub    $0xc,%esp
400028f3:	68 8c 3a 00 40       	push   $0x40003a8c
400028f8:	e8 43 da ff ff       	call   40000340 <printf>
    exit();
400028fd:	83 c4 10             	add    $0x10,%esp
}
40002900:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002903:	5b                   	pop    %ebx
40002904:	5e                   	pop    %esi
40002905:	5f                   	pop    %edi
40002906:	5d                   	pop    %ebp
40002907:	c3                   	ret
40002908:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000290f:	00 
    printf("create unlinkread failed\n");
40002910:	83 ec 0c             	sub    $0xc,%esp
40002913:	68 3c 3a 00 40       	push   $0x40003a3c
40002918:	e8 23 da ff ff       	call   40000340 <printf>
    exit();
4000291d:	83 c4 10             	add    $0x10,%esp
}
40002920:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002923:	5b                   	pop    %ebx
40002924:	5e                   	pop    %esi
40002925:	5f                   	pop    %edi
40002926:	5d                   	pop    %ebp
40002927:	c3                   	ret
40002928:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000292f:	00 
    printf("unlinkread wrong data\n");
40002930:	83 ec 0c             	sub    $0xc,%esp
40002933:	68 a3 3a 00 40       	push   $0x40003aa3
40002938:	e8 03 da ff ff       	call   40000340 <printf>
    exit();
4000293d:	83 c4 10             	add    $0x10,%esp
40002940:	eb 9e                	jmp    400028e0 <unlinkread+0x170>
	asm volatile("int %2"
40002942:	b8 06 00 00 00       	mov    $0x6,%eax
40002947:	89 f3                	mov    %esi,%ebx
40002949:	cd 30                	int    $0x30
  unsigned int len = strlen(path);
4000294b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
4000294e:	bb 31 3a 00 40       	mov    $0x40003a31,%ebx
  unsigned int len = strlen(path);
40002953:	68 31 3a 00 40       	push   $0x40003a31
40002958:	e8 83 e1 ff ff       	call   40000ae0 <strlen>
4000295d:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
4000295f:	b8 0d 00 00 00       	mov    $0xd,%eax
40002964:	cd 30                	int    $0x30
  printf("=====unlinkread ok=====\n\n");
40002966:	c7 04 24 d3 3a 00 40 	movl   $0x40003ad3,(%esp)
4000296d:	e8 ce d9 ff ff       	call   40000340 <printf>
40002972:	83 c4 10             	add    $0x10,%esp
40002975:	e9 66 ff ff ff       	jmp    400028e0 <unlinkread+0x170>
    printf("unlink unlinkread failed\n");
4000297a:	83 ec 0c             	sub    $0xc,%esp
4000297d:	68 6e 3a 00 40       	push   $0x40003a6e
40002982:	e8 b9 d9 ff ff       	call   40000340 <printf>
    exit();
40002987:	83 c4 10             	add    $0x10,%esp
4000298a:	e9 51 ff ff ff       	jmp    400028e0 <unlinkread+0x170>
	return errno ? -1 : fd;
4000298f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
40002994:	e9 c0 fe ff ff       	jmp    40002859 <unlinkread+0xe9>
40002999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400029a0 <dirfile>:
{
400029a0:	55                   	push   %ebp
400029a1:	89 e5                	mov    %esp,%ebp
400029a3:	56                   	push   %esi
400029a4:	53                   	push   %ebx
	asm volatile("int %2"
400029a5:	bb 04 3b 00 40       	mov    $0x40003b04,%ebx
400029aa:	83 ec 1c             	sub    $0x1c,%esp
  printf("=====dir vs file=====\n");
400029ad:	68 ed 3a 00 40       	push   $0x40003aed
400029b2:	e8 89 d9 ff ff       	call   40000340 <printf>
        unsigned int len = strlen(path);
400029b7:	c7 04 24 04 3b 00 40 	movl   $0x40003b04,(%esp)
400029be:	e8 1d e1 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
400029c3:	b9 00 02 00 00       	mov    $0x200,%ecx
        unsigned int len = strlen(path);
400029c8:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
400029ca:	b8 05 00 00 00       	mov    $0x5,%eax
400029cf:	cd 30                	int    $0x30
	return errno ? -1 : fd;
400029d1:	83 c4 10             	add    $0x10,%esp
  if(fd < 0){
400029d4:	85 c0                	test   %eax,%eax
400029d6:	75 48                	jne    40002a20 <dirfile+0x80>
400029d8:	85 db                	test   %ebx,%ebx
400029da:	78 44                	js     40002a20 <dirfile+0x80>
	asm volatile("int %2"
400029dc:	b8 06 00 00 00       	mov    $0x6,%eax
400029e1:	cd 30                	int    $0x30
  unsigned int len = strlen(path);
400029e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
400029e6:	bb 04 3b 00 40       	mov    $0x40003b04,%ebx
  unsigned int len = strlen(path);
400029eb:	68 04 3b 00 40       	push   $0x40003b04
400029f0:	e8 eb e0 ff ff       	call   40000ae0 <strlen>
400029f5:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
400029f7:	b8 0b 00 00 00       	mov    $0xb,%eax
400029fc:	cd 30                	int    $0x30
	return errno ? -1 : 0;
400029fe:	83 c4 10             	add    $0x10,%esp
40002a01:	85 c0                	test   %eax,%eax
40002a03:	75 3b                	jne    40002a40 <dirfile+0xa0>
    printf("chdir dirfile succeeded!\n");
40002a05:	83 ec 0c             	sub    $0xc,%esp
40002a08:	68 23 3b 00 40       	push   $0x40003b23
40002a0d:	e8 2e d9 ff ff       	call   40000340 <printf>
    exit();
40002a12:	83 c4 10             	add    $0x10,%esp
}
40002a15:	8d 65 f8             	lea    -0x8(%ebp),%esp
40002a18:	5b                   	pop    %ebx
40002a19:	5e                   	pop    %esi
40002a1a:	5d                   	pop    %ebp
40002a1b:	c3                   	ret
40002a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf("create dirfile failed\n");
40002a20:	83 ec 0c             	sub    $0xc,%esp
40002a23:	68 0c 3b 00 40       	push   $0x40003b0c
40002a28:	e8 13 d9 ff ff       	call   40000340 <printf>
    exit();
40002a2d:	83 c4 10             	add    $0x10,%esp
}
40002a30:	8d 65 f8             	lea    -0x8(%ebp),%esp
40002a33:	5b                   	pop    %ebx
40002a34:	5e                   	pop    %esi
40002a35:	5d                   	pop    %ebp
40002a36:	c3                   	ret
40002a37:	90                   	nop
40002a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40002a3f:	00 
        unsigned int len = strlen(path);
40002a40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002a43:	bb 3d 3b 00 40       	mov    $0x40003b3d,%ebx
        unsigned int len = strlen(path);
40002a48:	68 3d 3b 00 40       	push   $0x40003b3d
40002a4d:	e8 8e e0 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002a52:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40002a54:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002a56:	b8 05 00 00 00       	mov    $0x5,%eax
40002a5b:	cd 30                	int    $0x30
  if(fd >= 0){
40002a5d:	83 c4 10             	add    $0x10,%esp
40002a60:	85 db                	test   %ebx,%ebx
40002a62:	78 04                	js     40002a68 <dirfile+0xc8>
40002a64:	85 c0                	test   %eax,%eax
40002a66:	74 62                	je     40002aca <dirfile+0x12a>
        unsigned int len = strlen(path);
40002a68:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002a6b:	bb 3d 3b 00 40       	mov    $0x40003b3d,%ebx
        unsigned int len = strlen(path);
40002a70:	68 3d 3b 00 40       	push   $0x40003b3d
40002a75:	e8 66 e0 ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002a7a:	b9 00 02 00 00       	mov    $0x200,%ecx
        unsigned int len = strlen(path);
40002a7f:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002a81:	b8 05 00 00 00       	mov    $0x5,%eax
40002a86:	cd 30                	int    $0x30
  if(fd >= 0){
40002a88:	83 c4 10             	add    $0x10,%esp
40002a8b:	85 db                	test   %ebx,%ebx
40002a8d:	78 04                	js     40002a93 <dirfile+0xf3>
40002a8f:	85 c0                	test   %eax,%eax
40002a91:	74 37                	je     40002aca <dirfile+0x12a>
  unsigned int len = strlen(path);
40002a93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002a96:	bb 3d 3b 00 40       	mov    $0x40003b3d,%ebx
  unsigned int len = strlen(path);
40002a9b:	68 3d 3b 00 40       	push   $0x40003b3d
40002aa0:	e8 3b e0 ff ff       	call   40000ae0 <strlen>
40002aa5:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002aa7:	b8 0a 00 00 00       	mov    $0xa,%eax
40002aac:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002aae:	83 c4 10             	add    $0x10,%esp
40002ab1:	85 c0                	test   %eax,%eax
40002ab3:	75 2a                	jne    40002adf <dirfile+0x13f>
    printf("mkdir dirfile/xx succeeded!\n");
40002ab5:	83 ec 0c             	sub    $0xc,%esp
40002ab8:	68 66 3b 00 40       	push   $0x40003b66
40002abd:	e8 7e d8 ff ff       	call   40000340 <printf>
    exit();
40002ac2:	83 c4 10             	add    $0x10,%esp
40002ac5:	e9 4b ff ff ff       	jmp    40002a15 <dirfile+0x75>
    printf("create dirfile/xx succeeded!\n");
40002aca:	83 ec 0c             	sub    $0xc,%esp
40002acd:	68 48 3b 00 40       	push   $0x40003b48
40002ad2:	e8 69 d8 ff ff       	call   40000340 <printf>
    exit();
40002ad7:	83 c4 10             	add    $0x10,%esp
40002ada:	e9 36 ff ff ff       	jmp    40002a15 <dirfile+0x75>
  unsigned int len = strlen(path);
40002adf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002ae2:	bb 3d 3b 00 40       	mov    $0x40003b3d,%ebx
  unsigned int len = strlen(path);
40002ae7:	68 3d 3b 00 40       	push   $0x40003b3d
40002aec:	e8 ef df ff ff       	call   40000ae0 <strlen>
40002af1:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002af3:	b8 0d 00 00 00       	mov    $0xd,%eax
40002af8:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002afa:	83 c4 10             	add    $0x10,%esp
40002afd:	85 c0                	test   %eax,%eax
40002aff:	75 15                	jne    40002b16 <dirfile+0x176>
    printf("unlink dirfile/xx succeeded!\n");
40002b01:	83 ec 0c             	sub    $0xc,%esp
40002b04:	68 83 3b 00 40       	push   $0x40003b83
40002b09:	e8 32 d8 ff ff       	call   40000340 <printf>
    exit();
40002b0e:	83 c4 10             	add    $0x10,%esp
40002b11:	e9 ff fe ff ff       	jmp    40002a15 <dirfile+0x75>
  old_len = strlen(old);
40002b16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002b19:	bb a1 3b 00 40       	mov    $0x40003ba1,%ebx
  old_len = strlen(old);
40002b1e:	68 a1 3b 00 40       	push   $0x40003ba1
40002b23:	e8 b8 df ff ff       	call   40000ae0 <strlen>
40002b28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  new_len = strlen(new);
40002b2b:	c7 04 24 3d 3b 00 40 	movl   $0x40003b3d,(%esp)
40002b32:	e8 a9 df ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002b37:	8b 55 f4             	mov    -0xc(%ebp),%edx
40002b3a:	b9 3d 3b 00 40       	mov    $0x40003b3d,%ecx
  new_len = strlen(new);
40002b3f:	89 c6                	mov    %eax,%esi
	asm volatile("int %2"
40002b41:	b8 0c 00 00 00       	mov    $0xc,%eax
40002b46:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002b48:	83 c4 10             	add    $0x10,%esp
40002b4b:	85 c0                	test   %eax,%eax
40002b4d:	75 15                	jne    40002b64 <dirfile+0x1c4>
    printf("link to dirfile/xx succeeded!\n");
40002b4f:	83 ec 0c             	sub    $0xc,%esp
40002b52:	68 54 42 00 40       	push   $0x40004254
40002b57:	e8 e4 d7 ff ff       	call   40000340 <printf>
    exit();
40002b5c:	83 c4 10             	add    $0x10,%esp
40002b5f:	e9 b1 fe ff ff       	jmp    40002a15 <dirfile+0x75>
  unsigned int len = strlen(path);
40002b64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002b67:	bb 04 3b 00 40       	mov    $0x40003b04,%ebx
  unsigned int len = strlen(path);
40002b6c:	68 04 3b 00 40       	push   $0x40003b04
40002b71:	e8 6a df ff ff       	call   40000ae0 <strlen>
40002b76:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002b78:	b8 0d 00 00 00       	mov    $0xd,%eax
40002b7d:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002b7f:	83 c4 10             	add    $0x10,%esp
40002b82:	85 c0                	test   %eax,%eax
40002b84:	0f 85 a9 00 00 00    	jne    40002c33 <dirfile+0x293>
        unsigned int len = strlen(path);
40002b8a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002b8d:	bb 54 37 00 40       	mov    $0x40003754,%ebx
        unsigned int len = strlen(path);
40002b92:	68 54 37 00 40       	push   $0x40003754
40002b97:	e8 44 df ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002b9c:	b9 02 00 00 00       	mov    $0x2,%ecx
        unsigned int len = strlen(path);
40002ba1:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002ba3:	b8 05 00 00 00       	mov    $0x5,%eax
40002ba8:	cd 30                	int    $0x30
  if(fd >= 0){
40002baa:	83 c4 10             	add    $0x10,%esp
40002bad:	85 db                	test   %ebx,%ebx
40002baf:	78 08                	js     40002bb9 <dirfile+0x219>
40002bb1:	85 c0                	test   %eax,%eax
40002bb3:	0f 84 8f 00 00 00    	je     40002c48 <dirfile+0x2a8>
        unsigned int len = strlen(path);
40002bb9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002bbc:	bb 54 37 00 40       	mov    $0x40003754,%ebx
        unsigned int len = strlen(path);
40002bc1:	68 54 37 00 40       	push   $0x40003754
40002bc6:	e8 15 df ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002bcb:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40002bcd:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002bcf:	b8 05 00 00 00       	mov    $0x5,%eax
40002bd4:	cd 30                	int    $0x30
40002bd6:	89 de                	mov    %ebx,%esi
	return errno ? -1 : fd;
40002bd8:	83 c4 10             	add    $0x10,%esp
40002bdb:	85 c0                	test   %eax,%eax
40002bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40002be2:	0f 45 f0             	cmovne %eax,%esi
	asm volatile("int %2"
40002be5:	b9 37 38 00 40       	mov    $0x40003837,%ecx
40002bea:	b8 08 00 00 00       	mov    $0x8,%eax
40002bef:	ba 01 00 00 00       	mov    $0x1,%edx
40002bf4:	89 f3                	mov    %esi,%ebx
40002bf6:	cd 30                	int    $0x30
  if(write(fd, "x", 1) > 0){
40002bf8:	85 db                	test   %ebx,%ebx
40002bfa:	7e 04                	jle    40002c00 <dirfile+0x260>
40002bfc:	85 c0                	test   %eax,%eax
40002bfe:	74 1e                	je     40002c1e <dirfile+0x27e>
	asm volatile("int %2"
40002c00:	b8 06 00 00 00       	mov    $0x6,%eax
40002c05:	89 f3                	mov    %esi,%ebx
40002c07:	cd 30                	int    $0x30
  printf("=====dir vs file OK=====\n\n");
40002c09:	83 ec 0c             	sub    $0xc,%esp
40002c0c:	68 d4 3b 00 40       	push   $0x40003bd4
40002c11:	e8 2a d7 ff ff       	call   40000340 <printf>
40002c16:	83 c4 10             	add    $0x10,%esp
40002c19:	e9 f7 fd ff ff       	jmp    40002a15 <dirfile+0x75>
    printf("write . succeeded!\n");
40002c1e:	83 ec 0c             	sub    $0xc,%esp
40002c21:	68 c0 3b 00 40       	push   $0x40003bc0
40002c26:	e8 15 d7 ff ff       	call   40000340 <printf>
    exit();
40002c2b:	83 c4 10             	add    $0x10,%esp
40002c2e:	e9 e2 fd ff ff       	jmp    40002a15 <dirfile+0x75>
    printf("unlink dirfile failed!\n");
40002c33:	83 ec 0c             	sub    $0xc,%esp
40002c36:	68 a8 3b 00 40       	push   $0x40003ba8
40002c3b:	e8 00 d7 ff ff       	call   40000340 <printf>
    exit();
40002c40:	83 c4 10             	add    $0x10,%esp
40002c43:	e9 cd fd ff ff       	jmp    40002a15 <dirfile+0x75>
    printf("open . for writing succeeded!\n");
40002c48:	83 ec 0c             	sub    $0xc,%esp
40002c4b:	68 74 42 00 40       	push   $0x40004274
40002c50:	e8 eb d6 ff ff       	call   40000340 <printf>
    exit();
40002c55:	83 c4 10             	add    $0x10,%esp
40002c58:	e9 b8 fd ff ff       	jmp    40002a15 <dirfile+0x75>
40002c5d:	8d 76 00             	lea    0x0(%esi),%esi

40002c60 <iref>:
{
40002c60:	55                   	push   %ebp
40002c61:	89 e5                	mov    %esp,%ebp
40002c63:	57                   	push   %edi
  printf("=====empty file name=====\n");
40002c64:	bf 33 00 00 00       	mov    $0x33,%edi
{
40002c69:	56                   	push   %esi
40002c6a:	53                   	push   %ebx
40002c6b:	83 ec 28             	sub    $0x28,%esp
  printf("=====empty file name=====\n");
40002c6e:	68 ef 3b 00 40       	push   $0x40003bef
40002c73:	e8 c8 d6 ff ff       	call   40000340 <printf>
40002c78:	83 c4 10             	add    $0x10,%esp
40002c7b:	e9 f4 00 00 00       	jmp    40002d74 <iref+0x114>
  unsigned int len = strlen(path);
40002c80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002c83:	bb 0a 3c 00 40       	mov    $0x40003c0a,%ebx
  unsigned int len = strlen(path);
40002c88:	68 0a 3c 00 40       	push   $0x40003c0a
40002c8d:	e8 4e de ff ff       	call   40000ae0 <strlen>
40002c92:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002c94:	b8 0b 00 00 00       	mov    $0xb,%eax
40002c99:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002c9b:	83 c4 10             	add    $0x10,%esp
40002c9e:	85 c0                	test   %eax,%eax
40002ca0:	0f 85 4a 01 00 00    	jne    40002df0 <iref+0x190>
  unsigned int len = strlen(path);
40002ca6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002ca9:	bb ee 3b 00 40       	mov    $0x40003bee,%ebx
  unsigned int len = strlen(path);
40002cae:	68 ee 3b 00 40       	push   $0x40003bee
40002cb3:	e8 28 de ff ff       	call   40000ae0 <strlen>
40002cb8:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002cba:	b8 0a 00 00 00       	mov    $0xa,%eax
40002cbf:	cd 30                	int    $0x30
  old_len = strlen(old);
40002cc1:	c7 04 24 a1 3b 00 40 	movl   $0x40003ba1,(%esp)
	asm volatile("int %2"
40002cc8:	bb a1 3b 00 40       	mov    $0x40003ba1,%ebx
  old_len = strlen(old);
40002ccd:	e8 0e de ff ff       	call   40000ae0 <strlen>
40002cd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  new_len = strlen(new);
40002cd5:	c7 04 24 ee 3b 00 40 	movl   $0x40003bee,(%esp)
40002cdc:	e8 ff dd ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002ce1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
40002ce4:	b9 ee 3b 00 40       	mov    $0x40003bee,%ecx
  new_len = strlen(new);
40002ce9:	89 c6                	mov    %eax,%esi
	asm volatile("int %2"
40002ceb:	b8 0c 00 00 00       	mov    $0xc,%eax
40002cf0:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
40002cf2:	89 0c 24             	mov    %ecx,(%esp)
	asm volatile("int %2"
40002cf5:	bb ee 3b 00 40       	mov    $0x40003bee,%ebx
        unsigned int len = strlen(path);
40002cfa:	e8 e1 dd ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002cff:	b9 00 02 00 00       	mov    $0x200,%ecx
        unsigned int len = strlen(path);
40002d04:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002d06:	b8 05 00 00 00       	mov    $0x5,%eax
40002d0b:	cd 30                	int    $0x30
    if(fd >= 0)
40002d0d:	83 c4 10             	add    $0x10,%esp
40002d10:	85 db                	test   %ebx,%ebx
40002d12:	78 0b                	js     40002d1f <iref+0xbf>
40002d14:	85 c0                	test   %eax,%eax
40002d16:	75 07                	jne    40002d1f <iref+0xbf>
	asm volatile("int %2"
40002d18:	b8 06 00 00 00       	mov    $0x6,%eax
40002d1d:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
40002d1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002d22:	bb 36 38 00 40       	mov    $0x40003836,%ebx
        unsigned int len = strlen(path);
40002d27:	68 36 38 00 40       	push   $0x40003836
40002d2c:	e8 af dd ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002d31:	b9 00 02 00 00       	mov    $0x200,%ecx
        unsigned int len = strlen(path);
40002d36:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002d38:	b8 05 00 00 00       	mov    $0x5,%eax
40002d3d:	cd 30                	int    $0x30
    if(fd >= 0)
40002d3f:	83 c4 10             	add    $0x10,%esp
40002d42:	85 db                	test   %ebx,%ebx
40002d44:	78 0b                	js     40002d51 <iref+0xf1>
40002d46:	85 c0                	test   %eax,%eax
40002d48:	75 07                	jne    40002d51 <iref+0xf1>
	asm volatile("int %2"
40002d4a:	b8 06 00 00 00       	mov    $0x6,%eax
40002d4f:	cd 30                	int    $0x30
  unsigned int len = strlen(path);
40002d51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002d54:	bb 36 38 00 40       	mov    $0x40003836,%ebx
  unsigned int len = strlen(path);
40002d59:	68 36 38 00 40       	push   $0x40003836
40002d5e:	e8 7d dd ff ff       	call   40000ae0 <strlen>
40002d63:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002d65:	b8 0d 00 00 00       	mov    $0xd,%eax
40002d6a:	cd 30                	int    $0x30
  for(i = 0; i < 50 + 1; i++){
40002d6c:	83 c4 10             	add    $0x10,%esp
40002d6f:	83 ef 01             	sub    $0x1,%edi
40002d72:	74 44                	je     40002db8 <iref+0x158>
  unsigned int len = strlen(path);
40002d74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002d77:	bb 0a 3c 00 40       	mov    $0x40003c0a,%ebx
  unsigned int len = strlen(path);
40002d7c:	68 0a 3c 00 40       	push   $0x40003c0a
40002d81:	e8 5a dd ff ff       	call   40000ae0 <strlen>
40002d86:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002d88:	b8 0a 00 00 00       	mov    $0xa,%eax
40002d8d:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002d8f:	83 c4 10             	add    $0x10,%esp
40002d92:	85 c0                	test   %eax,%eax
40002d94:	0f 84 e6 fe ff ff    	je     40002c80 <iref+0x20>
      printf("mkdir irefd failed\n");
40002d9a:	83 ec 0c             	sub    $0xc,%esp
40002d9d:	68 10 3c 00 40       	push   $0x40003c10
40002da2:	e8 99 d5 ff ff       	call   40000340 <printf>
      exit();
40002da7:	83 c4 10             	add    $0x10,%esp
}
40002daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002dad:	5b                   	pop    %ebx
40002dae:	5e                   	pop    %esi
40002daf:	5f                   	pop    %edi
40002db0:	5d                   	pop    %ebp
40002db1:	c3                   	ret
40002db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  unsigned int len = strlen(path);
40002db8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002dbb:	bb 50 34 00 40       	mov    $0x40003450,%ebx
  unsigned int len = strlen(path);
40002dc0:	68 50 34 00 40       	push   $0x40003450
40002dc5:	e8 16 dd ff ff       	call   40000ae0 <strlen>
40002dca:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002dcc:	b8 0b 00 00 00       	mov    $0xb,%eax
40002dd1:	cd 30                	int    $0x30
  printf("=====empty file name OK=====\n\n");
40002dd3:	c7 04 24 94 42 00 40 	movl   $0x40004294,(%esp)
40002dda:	e8 61 d5 ff ff       	call   40000340 <printf>
40002ddf:	83 c4 10             	add    $0x10,%esp
}
40002de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002de5:	5b                   	pop    %ebx
40002de6:	5e                   	pop    %esi
40002de7:	5f                   	pop    %edi
40002de8:	5d                   	pop    %ebp
40002de9:	c3                   	ret
40002dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf("chdir irefd failed\n");
40002df0:	83 ec 0c             	sub    $0xc,%esp
40002df3:	68 24 3c 00 40       	push   $0x40003c24
40002df8:	e8 43 d5 ff ff       	call   40000340 <printf>
      exit();
40002dfd:	83 c4 10             	add    $0x10,%esp
}
40002e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002e03:	5b                   	pop    %ebx
40002e04:	5e                   	pop    %esi
40002e05:	5f                   	pop    %edi
40002e06:	5d                   	pop    %ebp
40002e07:	c3                   	ret
40002e08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40002e0f:	00 

40002e10 <bigdir>:
{
40002e10:	55                   	push   %ebp
40002e11:	89 e5                	mov    %esp,%ebp
40002e13:	57                   	push   %edi
40002e14:	56                   	push   %esi
40002e15:	53                   	push   %ebx
	asm volatile("int %2"
40002e16:	bb 4f 3c 00 40       	mov    $0x40003c4f,%ebx
40002e1b:	83 ec 28             	sub    $0x28,%esp
  printf("=====bigdir test=====\n");
40002e1e:	68 38 3c 00 40       	push   $0x40003c38
40002e23:	e8 18 d5 ff ff       	call   40000340 <printf>
  unsigned int len = strlen(path);
40002e28:	c7 04 24 4f 3c 00 40 	movl   $0x40003c4f,(%esp)
40002e2f:	e8 ac dc ff ff       	call   40000ae0 <strlen>
40002e34:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002e36:	b8 0d 00 00 00       	mov    $0xd,%eax
40002e3b:	cd 30                	int    $0x30
        unsigned int len = strlen(path);
40002e3d:	c7 04 24 4f 3c 00 40 	movl   $0x40003c4f,(%esp)
	asm volatile("int %2"
40002e44:	bb 4f 3c 00 40       	mov    $0x40003c4f,%ebx
        unsigned int len = strlen(path);
40002e49:	e8 92 dc ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002e4e:	b9 00 02 00 00       	mov    $0x200,%ecx
        unsigned int len = strlen(path);
40002e53:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40002e55:	b8 05 00 00 00       	mov    $0x5,%eax
40002e5a:	cd 30                	int    $0x30
  if(fd < 0){
40002e5c:	83 c4 10             	add    $0x10,%esp
40002e5f:	85 db                	test   %ebx,%ebx
40002e61:	0f 88 a9 00 00 00    	js     40002f10 <bigdir+0x100>
40002e67:	85 c0                	test   %eax,%eax
40002e69:	0f 85 a1 00 00 00    	jne    40002f10 <bigdir+0x100>
	asm volatile("int %2"
40002e6f:	b8 06 00 00 00       	mov    $0x6,%eax
40002e74:	cd 30                	int    $0x30
40002e76:	31 ff                	xor    %edi,%edi
40002e78:	eb 15                	jmp    40002e8f <bigdir+0x7f>
40002e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0; i < 500; i++){
40002e80:	83 c7 01             	add    $0x1,%edi
40002e83:	81 ff f4 01 00 00    	cmp    $0x1f4,%edi
40002e89:	0f 84 99 00 00 00    	je     40002f28 <bigdir+0x118>
    namel[1] = '0' + (i / 64);
40002e8f:	89 f8                	mov    %edi,%eax
  old_len = strlen(old);
40002e91:	83 ec 0c             	sub    $0xc,%esp
    namel[0] = 'x';
40002e94:	c6 05 80 54 00 40 78 	movb   $0x78,0x40005480
	asm volatile("int %2"
40002e9b:	bb 4f 3c 00 40       	mov    $0x40003c4f,%ebx
    namel[1] = '0' + (i / 64);
40002ea0:	c1 f8 06             	sar    $0x6,%eax
    namel[3] = '\0';
40002ea3:	c6 05 83 54 00 40 00 	movb   $0x0,0x40005483
    namel[1] = '0' + (i / 64);
40002eaa:	83 c0 30             	add    $0x30,%eax
40002ead:	a2 81 54 00 40       	mov    %al,0x40005481
    namel[2] = '0' + (i % 64);
40002eb2:	89 f8                	mov    %edi,%eax
40002eb4:	83 e0 3f             	and    $0x3f,%eax
40002eb7:	83 c0 30             	add    $0x30,%eax
40002eba:	a2 82 54 00 40       	mov    %al,0x40005482
  old_len = strlen(old);
40002ebf:	68 4f 3c 00 40       	push   $0x40003c4f
40002ec4:	e8 17 dc ff ff       	call   40000ae0 <strlen>
40002ec9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  new_len = strlen(new);
40002ecc:	c7 04 24 80 54 00 40 	movl   $0x40005480,(%esp)
40002ed3:	e8 08 dc ff ff       	call   40000ae0 <strlen>
	asm volatile("int %2"
40002ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
40002edb:	b9 80 54 00 40       	mov    $0x40005480,%ecx
  new_len = strlen(new);
40002ee0:	89 c6                	mov    %eax,%esi
	asm volatile("int %2"
40002ee2:	b8 0c 00 00 00       	mov    $0xc,%eax
40002ee7:	cd 30                	int    $0x30
40002ee9:	89 c6                	mov    %eax,%esi
	return errno ? -1 : 0;
40002eeb:	83 c4 10             	add    $0x10,%esp
40002eee:	85 c0                	test   %eax,%eax
40002ef0:	74 8e                	je     40002e80 <bigdir+0x70>
      printf("bigdir link failed\n");
40002ef2:	83 ec 0c             	sub    $0xc,%esp
40002ef5:	68 68 3c 00 40       	push   $0x40003c68
40002efa:	e8 41 d4 ff ff       	call   40000340 <printf>
      exit();
40002eff:	83 c4 10             	add    $0x10,%esp
}
40002f02:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002f05:	5b                   	pop    %ebx
40002f06:	5e                   	pop    %esi
40002f07:	5f                   	pop    %edi
40002f08:	5d                   	pop    %ebp
40002f09:	c3                   	ret
40002f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf("bigdir create failed\n");
40002f10:	83 ec 0c             	sub    $0xc,%esp
40002f13:	68 52 3c 00 40       	push   $0x40003c52
40002f18:	e8 23 d4 ff ff       	call   40000340 <printf>
    exit();
40002f1d:	83 c4 10             	add    $0x10,%esp
}
40002f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002f23:	5b                   	pop    %ebx
40002f24:	5e                   	pop    %esi
40002f25:	5f                   	pop    %edi
40002f26:	5d                   	pop    %ebp
40002f27:	c3                   	ret
  unsigned int len = strlen(path);
40002f28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %2"
40002f2b:	bb 4f 3c 00 40       	mov    $0x40003c4f,%ebx
  unsigned int len = strlen(path);
40002f30:	68 4f 3c 00 40       	push   $0x40003c4f
40002f35:	e8 a6 db ff ff       	call   40000ae0 <strlen>
40002f3a:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002f3c:	b8 0d 00 00 00       	mov    $0xd,%eax
40002f41:	cd 30                	int    $0x30
40002f43:	83 c4 10             	add    $0x10,%esp
40002f46:	eb 13                	jmp    40002f5b <bigdir+0x14b>
40002f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40002f4f:	00 
  for(i = 0; i < 500; i++){
40002f50:	83 c6 01             	add    $0x1,%esi
40002f53:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
40002f59:	74 62                	je     40002fbd <bigdir+0x1ad>
    namel[1] = '0' + (i / 64);
40002f5b:	89 f0                	mov    %esi,%eax
  unsigned int len = strlen(path);
40002f5d:	83 ec 0c             	sub    $0xc,%esp
    namel[0] = 'x';
40002f60:	c6 05 80 54 00 40 78 	movb   $0x78,0x40005480
	asm volatile("int %2"
40002f67:	bb 80 54 00 40       	mov    $0x40005480,%ebx
    namel[1] = '0' + (i / 64);
40002f6c:	c1 f8 06             	sar    $0x6,%eax
    namel[3] = '\0';
40002f6f:	c6 05 83 54 00 40 00 	movb   $0x0,0x40005483
    namel[1] = '0' + (i / 64);
40002f76:	83 c0 30             	add    $0x30,%eax
40002f79:	a2 81 54 00 40       	mov    %al,0x40005481
    namel[2] = '0' + (i % 64);
40002f7e:	89 f0                	mov    %esi,%eax
40002f80:	83 e0 3f             	and    $0x3f,%eax
40002f83:	83 c0 30             	add    $0x30,%eax
40002f86:	a2 82 54 00 40       	mov    %al,0x40005482
  unsigned int len = strlen(path);
40002f8b:	68 80 54 00 40       	push   $0x40005480
40002f90:	e8 4b db ff ff       	call   40000ae0 <strlen>
40002f95:	89 c1                	mov    %eax,%ecx
	asm volatile("int %2"
40002f97:	b8 0d 00 00 00       	mov    $0xd,%eax
40002f9c:	cd 30                	int    $0x30
	return errno ? -1 : 0;
40002f9e:	83 c4 10             	add    $0x10,%esp
40002fa1:	85 c0                	test   %eax,%eax
40002fa3:	74 ab                	je     40002f50 <bigdir+0x140>
      printf("bigdir unlink failed");
40002fa5:	83 ec 0c             	sub    $0xc,%esp
40002fa8:	68 7c 3c 00 40       	push   $0x40003c7c
40002fad:	e8 8e d3 ff ff       	call   40000340 <printf>
      exit();
40002fb2:	83 c4 10             	add    $0x10,%esp
}
40002fb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
40002fb8:	5b                   	pop    %ebx
40002fb9:	5e                   	pop    %esi
40002fba:	5f                   	pop    %edi
40002fbb:	5d                   	pop    %ebp
40002fbc:	c3                   	ret
  printf("=====bigdir ok=====\n\n");
40002fbd:	83 ec 0c             	sub    $0xc,%esp
40002fc0:	68 91 3c 00 40       	push   $0x40003c91
40002fc5:	e8 76 d3 ff ff       	call   40000340 <printf>
40002fca:	83 c4 10             	add    $0x10,%esp
40002fcd:	e9 30 ff ff ff       	jmp    40002f02 <bigdir+0xf2>
40002fd2:	66 90                	xchg   %ax,%ax
40002fd4:	66 90                	xchg   %ax,%ax
40002fd6:	66 90                	xchg   %ax,%ax
40002fd8:	66 90                	xchg   %ax,%ax
40002fda:	66 90                	xchg   %ax,%ax
40002fdc:	66 90                	xchg   %ax,%ax
40002fde:	66 90                	xchg   %ax,%ax

40002fe0 <__udivdi3>:
40002fe0:	55                   	push   %ebp
40002fe1:	89 e5                	mov    %esp,%ebp
40002fe3:	57                   	push   %edi
40002fe4:	56                   	push   %esi
40002fe5:	53                   	push   %ebx
40002fe6:	83 ec 1c             	sub    $0x1c,%esp
40002fe9:	8b 75 08             	mov    0x8(%ebp),%esi
40002fec:	8b 45 14             	mov    0x14(%ebp),%eax
40002fef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40002ff2:	8b 7d 10             	mov    0x10(%ebp),%edi
40002ff5:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40002ff8:	85 c0                	test   %eax,%eax
40002ffa:	75 1c                	jne    40003018 <__udivdi3+0x38>
40002ffc:	39 fb                	cmp    %edi,%ebx
40002ffe:	73 50                	jae    40003050 <__udivdi3+0x70>
40003000:	89 f0                	mov    %esi,%eax
40003002:	31 f6                	xor    %esi,%esi
40003004:	89 da                	mov    %ebx,%edx
40003006:	f7 f7                	div    %edi
40003008:	89 f2                	mov    %esi,%edx
4000300a:	83 c4 1c             	add    $0x1c,%esp
4000300d:	5b                   	pop    %ebx
4000300e:	5e                   	pop    %esi
4000300f:	5f                   	pop    %edi
40003010:	5d                   	pop    %ebp
40003011:	c3                   	ret
40003012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40003018:	39 c3                	cmp    %eax,%ebx
4000301a:	73 14                	jae    40003030 <__udivdi3+0x50>
4000301c:	31 f6                	xor    %esi,%esi
4000301e:	31 c0                	xor    %eax,%eax
40003020:	89 f2                	mov    %esi,%edx
40003022:	83 c4 1c             	add    $0x1c,%esp
40003025:	5b                   	pop    %ebx
40003026:	5e                   	pop    %esi
40003027:	5f                   	pop    %edi
40003028:	5d                   	pop    %ebp
40003029:	c3                   	ret
4000302a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40003030:	0f bd f0             	bsr    %eax,%esi
40003033:	83 f6 1f             	xor    $0x1f,%esi
40003036:	75 48                	jne    40003080 <__udivdi3+0xa0>
40003038:	39 d8                	cmp    %ebx,%eax
4000303a:	72 07                	jb     40003043 <__udivdi3+0x63>
4000303c:	31 c0                	xor    %eax,%eax
4000303e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
40003041:	72 dd                	jb     40003020 <__udivdi3+0x40>
40003043:	b8 01 00 00 00       	mov    $0x1,%eax
40003048:	eb d6                	jmp    40003020 <__udivdi3+0x40>
4000304a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40003050:	89 f9                	mov    %edi,%ecx
40003052:	85 ff                	test   %edi,%edi
40003054:	75 0b                	jne    40003061 <__udivdi3+0x81>
40003056:	b8 01 00 00 00       	mov    $0x1,%eax
4000305b:	31 d2                	xor    %edx,%edx
4000305d:	f7 f7                	div    %edi
4000305f:	89 c1                	mov    %eax,%ecx
40003061:	31 d2                	xor    %edx,%edx
40003063:	89 d8                	mov    %ebx,%eax
40003065:	f7 f1                	div    %ecx
40003067:	89 c6                	mov    %eax,%esi
40003069:	8b 45 e4             	mov    -0x1c(%ebp),%eax
4000306c:	f7 f1                	div    %ecx
4000306e:	89 f2                	mov    %esi,%edx
40003070:	83 c4 1c             	add    $0x1c,%esp
40003073:	5b                   	pop    %ebx
40003074:	5e                   	pop    %esi
40003075:	5f                   	pop    %edi
40003076:	5d                   	pop    %ebp
40003077:	c3                   	ret
40003078:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000307f:	00 
40003080:	89 f1                	mov    %esi,%ecx
40003082:	ba 20 00 00 00       	mov    $0x20,%edx
40003087:	29 f2                	sub    %esi,%edx
40003089:	d3 e0                	shl    %cl,%eax
4000308b:	89 45 e0             	mov    %eax,-0x20(%ebp)
4000308e:	89 d1                	mov    %edx,%ecx
40003090:	89 f8                	mov    %edi,%eax
40003092:	d3 e8                	shr    %cl,%eax
40003094:	8b 4d e0             	mov    -0x20(%ebp),%ecx
40003097:	09 c1                	or     %eax,%ecx
40003099:	89 d8                	mov    %ebx,%eax
4000309b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
4000309e:	89 f1                	mov    %esi,%ecx
400030a0:	d3 e7                	shl    %cl,%edi
400030a2:	89 d1                	mov    %edx,%ecx
400030a4:	d3 e8                	shr    %cl,%eax
400030a6:	89 f1                	mov    %esi,%ecx
400030a8:	89 7d dc             	mov    %edi,-0x24(%ebp)
400030ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
400030ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400030b1:	d3 e3                	shl    %cl,%ebx
400030b3:	89 d1                	mov    %edx,%ecx
400030b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
400030b8:	d3 e8                	shr    %cl,%eax
400030ba:	09 d8                	or     %ebx,%eax
400030bc:	f7 75 e0             	divl   -0x20(%ebp)
400030bf:	89 d3                	mov    %edx,%ebx
400030c1:	89 c7                	mov    %eax,%edi
400030c3:	f7 65 dc             	mull   -0x24(%ebp)
400030c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
400030c9:	39 d3                	cmp    %edx,%ebx
400030cb:	72 23                	jb     400030f0 <__udivdi3+0x110>
400030cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400030d0:	89 f1                	mov    %esi,%ecx
400030d2:	d3 e0                	shl    %cl,%eax
400030d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
400030d7:	73 04                	jae    400030dd <__udivdi3+0xfd>
400030d9:	39 d3                	cmp    %edx,%ebx
400030db:	74 13                	je     400030f0 <__udivdi3+0x110>
400030dd:	89 f8                	mov    %edi,%eax
400030df:	31 f6                	xor    %esi,%esi
400030e1:	e9 3a ff ff ff       	jmp    40003020 <__udivdi3+0x40>
400030e6:	66 90                	xchg   %ax,%ax
400030e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400030ef:	00 
400030f0:	8d 47 ff             	lea    -0x1(%edi),%eax
400030f3:	31 f6                	xor    %esi,%esi
400030f5:	e9 26 ff ff ff       	jmp    40003020 <__udivdi3+0x40>
400030fa:	66 90                	xchg   %ax,%ax
400030fc:	66 90                	xchg   %ax,%ax
400030fe:	66 90                	xchg   %ax,%ax

40003100 <__umoddi3>:
40003100:	55                   	push   %ebp
40003101:	89 e5                	mov    %esp,%ebp
40003103:	57                   	push   %edi
40003104:	56                   	push   %esi
40003105:	53                   	push   %ebx
40003106:	83 ec 2c             	sub    $0x2c,%esp
40003109:	8b 5d 0c             	mov    0xc(%ebp),%ebx
4000310c:	8b 45 14             	mov    0x14(%ebp),%eax
4000310f:	8b 75 08             	mov    0x8(%ebp),%esi
40003112:	8b 7d 10             	mov    0x10(%ebp),%edi
40003115:	89 da                	mov    %ebx,%edx
40003117:	85 c0                	test   %eax,%eax
40003119:	75 15                	jne    40003130 <__umoddi3+0x30>
4000311b:	39 fb                	cmp    %edi,%ebx
4000311d:	73 51                	jae    40003170 <__umoddi3+0x70>
4000311f:	89 f0                	mov    %esi,%eax
40003121:	f7 f7                	div    %edi
40003123:	89 d0                	mov    %edx,%eax
40003125:	31 d2                	xor    %edx,%edx
40003127:	83 c4 2c             	add    $0x2c,%esp
4000312a:	5b                   	pop    %ebx
4000312b:	5e                   	pop    %esi
4000312c:	5f                   	pop    %edi
4000312d:	5d                   	pop    %ebp
4000312e:	c3                   	ret
4000312f:	90                   	nop
40003130:	89 75 e0             	mov    %esi,-0x20(%ebp)
40003133:	39 c3                	cmp    %eax,%ebx
40003135:	73 11                	jae    40003148 <__umoddi3+0x48>
40003137:	89 f0                	mov    %esi,%eax
40003139:	83 c4 2c             	add    $0x2c,%esp
4000313c:	5b                   	pop    %ebx
4000313d:	5e                   	pop    %esi
4000313e:	5f                   	pop    %edi
4000313f:	5d                   	pop    %ebp
40003140:	c3                   	ret
40003141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40003148:	0f bd c8             	bsr    %eax,%ecx
4000314b:	83 f1 1f             	xor    $0x1f,%ecx
4000314e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
40003151:	75 3d                	jne    40003190 <__umoddi3+0x90>
40003153:	39 d8                	cmp    %ebx,%eax
40003155:	0f 82 cd 00 00 00    	jb     40003228 <__umoddi3+0x128>
4000315b:	39 fe                	cmp    %edi,%esi
4000315d:	0f 83 c5 00 00 00    	jae    40003228 <__umoddi3+0x128>
40003163:	8b 45 e0             	mov    -0x20(%ebp),%eax
40003166:	83 c4 2c             	add    $0x2c,%esp
40003169:	5b                   	pop    %ebx
4000316a:	5e                   	pop    %esi
4000316b:	5f                   	pop    %edi
4000316c:	5d                   	pop    %ebp
4000316d:	c3                   	ret
4000316e:	66 90                	xchg   %ax,%ax
40003170:	89 f9                	mov    %edi,%ecx
40003172:	85 ff                	test   %edi,%edi
40003174:	75 0b                	jne    40003181 <__umoddi3+0x81>
40003176:	b8 01 00 00 00       	mov    $0x1,%eax
4000317b:	31 d2                	xor    %edx,%edx
4000317d:	f7 f7                	div    %edi
4000317f:	89 c1                	mov    %eax,%ecx
40003181:	89 d8                	mov    %ebx,%eax
40003183:	31 d2                	xor    %edx,%edx
40003185:	f7 f1                	div    %ecx
40003187:	89 f0                	mov    %esi,%eax
40003189:	f7 f1                	div    %ecx
4000318b:	eb 96                	jmp    40003123 <__umoddi3+0x23>
4000318d:	8d 76 00             	lea    0x0(%esi),%esi
40003190:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40003194:	ba 20 00 00 00       	mov    $0x20,%edx
40003199:	2b 55 e4             	sub    -0x1c(%ebp),%edx
4000319c:	89 55 e0             	mov    %edx,-0x20(%ebp)
4000319f:	d3 e0                	shl    %cl,%eax
400031a1:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
400031a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
400031a8:	89 f8                	mov    %edi,%eax
400031aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
400031ad:	d3 e8                	shr    %cl,%eax
400031af:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400031b3:	09 c2                	or     %eax,%edx
400031b5:	d3 e7                	shl    %cl,%edi
400031b7:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
400031bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
400031be:	89 da                	mov    %ebx,%edx
400031c0:	89 7d d8             	mov    %edi,-0x28(%ebp)
400031c3:	89 f7                	mov    %esi,%edi
400031c5:	d3 ea                	shr    %cl,%edx
400031c7:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400031cb:	d3 e3                	shl    %cl,%ebx
400031cd:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
400031d1:	d3 ef                	shr    %cl,%edi
400031d3:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400031d7:	89 f8                	mov    %edi,%eax
400031d9:	d3 e6                	shl    %cl,%esi
400031db:	09 d8                	or     %ebx,%eax
400031dd:	f7 75 dc             	divl   -0x24(%ebp)
400031e0:	89 d3                	mov    %edx,%ebx
400031e2:	89 75 d4             	mov    %esi,-0x2c(%ebp)
400031e5:	89 f7                	mov    %esi,%edi
400031e7:	f7 65 d8             	mull   -0x28(%ebp)
400031ea:	89 c6                	mov    %eax,%esi
400031ec:	89 d1                	mov    %edx,%ecx
400031ee:	39 d3                	cmp    %edx,%ebx
400031f0:	72 06                	jb     400031f8 <__umoddi3+0xf8>
400031f2:	75 0e                	jne    40003202 <__umoddi3+0x102>
400031f4:	39 c7                	cmp    %eax,%edi
400031f6:	73 0a                	jae    40003202 <__umoddi3+0x102>
400031f8:	2b 45 d8             	sub    -0x28(%ebp),%eax
400031fb:	1b 55 dc             	sbb    -0x24(%ebp),%edx
400031fe:	89 d1                	mov    %edx,%ecx
40003200:	89 c6                	mov    %eax,%esi
40003202:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40003205:	29 f0                	sub    %esi,%eax
40003207:	19 cb                	sbb    %ecx,%ebx
40003209:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
4000320d:	89 da                	mov    %ebx,%edx
4000320f:	d3 e2                	shl    %cl,%edx
40003211:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40003215:	d3 e8                	shr    %cl,%eax
40003217:	d3 eb                	shr    %cl,%ebx
40003219:	09 d0                	or     %edx,%eax
4000321b:	89 da                	mov    %ebx,%edx
4000321d:	83 c4 2c             	add    $0x2c,%esp
40003220:	5b                   	pop    %ebx
40003221:	5e                   	pop    %esi
40003222:	5f                   	pop    %edi
40003223:	5d                   	pop    %ebp
40003224:	c3                   	ret
40003225:	8d 76 00             	lea    0x0(%esi),%esi
40003228:	89 da                	mov    %ebx,%edx
4000322a:	29 fe                	sub    %edi,%esi
4000322c:	19 c2                	sbb    %eax,%edx
4000322e:	89 75 e0             	mov    %esi,-0x20(%ebp)
40003231:	e9 2d ff ff ff       	jmp    40003163 <__umoddi3+0x63>
