
obj/user/idle/idle:     file format elf32-i386


Disassembly of section .text:

40000000 <main>:
#include <stdio.h>
#include <syscall.h>
#include <x86.h>

int main (int argc, char **argv)
{
40000000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
40000004:	83 e4 f0             	and    $0xfffffff0,%esp
40000007:	ff 71 fc             	push   -0x4(%ecx)
4000000a:	55                   	push   %ebp
4000000b:	89 e5                	mov    %esp,%ebp
4000000d:	51                   	push   %ecx
4000000e:	83 ec 10             	sub    $0x10,%esp
    printf ("idle\n");
40000011:	68 d4 11 00 40       	push   $0x400011d4
40000016:	e8 45 02 00 00       	call   40000260 <printf>
4000001b:	83 c4 10             	add    $0x10,%esp

    pid_t ping_pid, pong_pid, shell_pid;
    while(1) ;
4000001e:	eb fe                	jmp    4000001e <main+0x1e>

40000020 <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary/
	 */
	testl	$0x0fffffff, %esp
40000020:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
40000026:	75 04                	jne    4000002c <args_exist>

40000028 <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
40000028:	6a 00                	push   $0x0
	pushl	$0
4000002a:	6a 00                	push   $0x0

4000002c <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
4000002c:	e8 cf ff ff ff       	call   40000000 <main>

	/* When returning, save return value */
	pushl	%eax
40000031:	50                   	push   %eax

	/* Syscall SYS_exit (30) */
	movl	$30, %eax
40000032:	b8 1e 00 00 00       	mov    $0x1e,%eax
	int	$48
40000037:	cd 30                	int    $0x30

40000039 <spin>:

spin:
	call	yield
40000039:	e8 12 09 00 00       	call   40000950 <yield>
	jmp	spin
4000003e:	eb f9                	jmp    40000039 <spin>

40000040 <debug>:
#include <stdarg.h>
#include <stdio.h>

void
debug(const char *file, int line, const char *fmt, ...)
{
40000040:	55                   	push   %ebp
40000041:	89 e5                	mov    %esp,%ebp
40000043:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[D] %s:%d: ", file, line);
40000046:	ff 75 0c             	push   0xc(%ebp)
40000049:	ff 75 08             	push   0x8(%ebp)
4000004c:	68 98 11 00 40       	push   $0x40001198
40000051:	e8 0a 02 00 00       	call   40000260 <printf>
	vcprintf(fmt, ap);
40000056:	58                   	pop    %eax
40000057:	8d 45 14             	lea    0x14(%ebp),%eax
4000005a:	5a                   	pop    %edx
4000005b:	50                   	push   %eax
4000005c:	ff 75 10             	push   0x10(%ebp)
4000005f:	e8 9c 01 00 00       	call   40000200 <vcprintf>
	va_end(ap);
}
40000064:	83 c4 10             	add    $0x10,%esp
40000067:	c9                   	leave
40000068:	c3                   	ret
40000069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000070 <warn>:

void
warn(const char *file, int line, const char *fmt, ...)
{
40000070:	55                   	push   %ebp
40000071:	89 e5                	mov    %esp,%ebp
40000073:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[W] %s:%d: ", file, line);
40000076:	ff 75 0c             	push   0xc(%ebp)
40000079:	ff 75 08             	push   0x8(%ebp)
4000007c:	68 a4 11 00 40       	push   $0x400011a4
40000081:	e8 da 01 00 00       	call   40000260 <printf>
	vcprintf(fmt, ap);
40000086:	58                   	pop    %eax
40000087:	8d 45 14             	lea    0x14(%ebp),%eax
4000008a:	5a                   	pop    %edx
4000008b:	50                   	push   %eax
4000008c:	ff 75 10             	push   0x10(%ebp)
4000008f:	e8 6c 01 00 00       	call   40000200 <vcprintf>
	va_end(ap);
}
40000094:	83 c4 10             	add    $0x10,%esp
40000097:	c9                   	leave
40000098:	c3                   	ret
40000099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400000a0 <panic>:

void
panic(const char *file, int line, const char *fmt, ...)
{
400000a0:	55                   	push   %ebp
400000a1:	89 e5                	mov    %esp,%ebp
400000a3:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[P] %s:%d: ", file, line);
400000a6:	ff 75 0c             	push   0xc(%ebp)
400000a9:	ff 75 08             	push   0x8(%ebp)
400000ac:	68 b0 11 00 40       	push   $0x400011b0
400000b1:	e8 aa 01 00 00       	call   40000260 <printf>
	vcprintf(fmt, ap);
400000b6:	58                   	pop    %eax
400000b7:	8d 45 14             	lea    0x14(%ebp),%eax
400000ba:	5a                   	pop    %edx
400000bb:	50                   	push   %eax
400000bc:	ff 75 10             	push   0x10(%ebp)
400000bf:	e8 3c 01 00 00       	call   40000200 <vcprintf>
400000c4:	83 c4 10             	add    $0x10,%esp
400000c7:	90                   	nop
400000c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400000cf:	00 
	va_end(ap);

	while (1)
		yield();
400000d0:	e8 7b 08 00 00       	call   40000950 <yield>
	while (1)
400000d5:	eb f9                	jmp    400000d0 <panic+0x30>
400000d7:	66 90                	xchg   %ax,%ax
400000d9:	66 90                	xchg   %ax,%ax
400000db:	66 90                	xchg   %ax,%ax
400000dd:	66 90                	xchg   %ax,%ax
400000df:	90                   	nop

400000e0 <atoi>:
#include <stdlib.h>

int
atoi(const char *buf, int *i)
{
400000e0:	55                   	push   %ebp
400000e1:	89 e5                	mov    %esp,%ebp
400000e3:	57                   	push   %edi
400000e4:	56                   	push   %esi
400000e5:	53                   	push   %ebx
400000e6:	83 ec 04             	sub    $0x4,%esp
400000e9:	8b 75 08             	mov    0x8(%ebp),%esi
	int loc = 0;
	int numstart = 0;
	int acc = 0;
	int negative = 0;
	if (buf[loc] == '+')
400000ec:	0f b6 06             	movzbl (%esi),%eax
400000ef:	3c 2b                	cmp    $0x2b,%al
400000f1:	0f 84 89 00 00 00    	je     40000180 <atoi+0xa0>
		loc++;
	else if (buf[loc] == '-') {
400000f7:	3c 2d                	cmp    $0x2d,%al
400000f9:	74 65                	je     40000160 <atoi+0x80>
		negative = 1;
		loc++;
	}
	numstart = loc;
	// no grab the numbers
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400000fb:	8d 50 d0             	lea    -0x30(%eax),%edx
	int negative = 0;
400000fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int loc = 0;
40000105:	31 ff                	xor    %edi,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000107:	80 fa 09             	cmp    $0x9,%dl
4000010a:	0f 87 8c 00 00 00    	ja     4000019c <atoi+0xbc>
	int loc = 0;
40000110:	89 f9                	mov    %edi,%ecx
	int acc = 0;
40000112:	31 d2                	xor    %edx,%edx
40000114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000118:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000011f:	00 
		acc = acc*10 + (buf[loc]-'0');
40000120:	83 e8 30             	sub    $0x30,%eax
40000123:	8d 14 92             	lea    (%edx,%edx,4),%edx
		loc++;
40000126:	83 c1 01             	add    $0x1,%ecx
		acc = acc*10 + (buf[loc]-'0');
40000129:	0f be c0             	movsbl %al,%eax
4000012c:	8d 14 50             	lea    (%eax,%edx,2),%edx
	while ('0' <= buf[loc] && buf[loc] <= '9') {
4000012f:	0f b6 04 0e          	movzbl (%esi,%ecx,1),%eax
40000133:	8d 58 d0             	lea    -0x30(%eax),%ebx
40000136:	80 fb 09             	cmp    $0x9,%bl
40000139:	76 e5                	jbe    40000120 <atoi+0x40>
	}
	if (numstart == loc) {
4000013b:	39 f9                	cmp    %edi,%ecx
4000013d:	74 5d                	je     4000019c <atoi+0xbc>
		// no numbers have actually been scanned
		return 0;
	}
	if (negative)
		acc = - acc;
4000013f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
40000142:	89 d0                	mov    %edx,%eax
40000144:	f7 d8                	neg    %eax
40000146:	85 db                	test   %ebx,%ebx
40000148:	0f 45 d0             	cmovne %eax,%edx
	*i = acc;
4000014b:	8b 45 0c             	mov    0xc(%ebp),%eax
4000014e:	89 10                	mov    %edx,(%eax)
	return loc;
}
40000150:	83 c4 04             	add    $0x4,%esp
40000153:	89 c8                	mov    %ecx,%eax
40000155:	5b                   	pop    %ebx
40000156:	5e                   	pop    %esi
40000157:	5f                   	pop    %edi
40000158:	5d                   	pop    %ebp
40000159:	c3                   	ret
4000015a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000160:	0f b6 46 01          	movzbl 0x1(%esi),%eax
40000164:	8d 50 d0             	lea    -0x30(%eax),%edx
40000167:	80 fa 09             	cmp    $0x9,%dl
4000016a:	77 30                	ja     4000019c <atoi+0xbc>
		negative = 1;
4000016c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		loc++;
40000173:	bf 01 00 00 00       	mov    $0x1,%edi
40000178:	eb 96                	jmp    40000110 <atoi+0x30>
4000017a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000180:	0f b6 46 01          	movzbl 0x1(%esi),%eax
	int negative = 0;
40000184:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		loc++;
4000018b:	bf 01 00 00 00       	mov    $0x1,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000190:	8d 50 d0             	lea    -0x30(%eax),%edx
40000193:	80 fa 09             	cmp    $0x9,%dl
40000196:	0f 86 74 ff ff ff    	jbe    40000110 <atoi+0x30>
}
4000019c:	83 c4 04             	add    $0x4,%esp
		return 0;
4000019f:	31 c9                	xor    %ecx,%ecx
}
400001a1:	5b                   	pop    %ebx
400001a2:	89 c8                	mov    %ecx,%eax
400001a4:	5e                   	pop    %esi
400001a5:	5f                   	pop    %edi
400001a6:	5d                   	pop    %ebp
400001a7:	c3                   	ret
400001a8:	66 90                	xchg   %ax,%ax
400001aa:	66 90                	xchg   %ax,%ax
400001ac:	66 90                	xchg   %ax,%ax
400001ae:	66 90                	xchg   %ax,%ax

400001b0 <putch>:
	char buf[MAX_BUF];
};

static void
putch(int ch, struct printbuf *b)
{
400001b0:	55                   	push   %ebp
400001b1:	89 e5                	mov    %esp,%ebp
400001b3:	56                   	push   %esi
400001b4:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
400001b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
400001ba:	53                   	push   %ebx
	b->buf[b->idx++] = ch;
400001bb:	8b 06                	mov    (%esi),%eax
400001bd:	8d 50 01             	lea    0x1(%eax),%edx
400001c0:	89 16                	mov    %edx,(%esi)
400001c2:	88 4c 06 08          	mov    %cl,0x8(%esi,%eax,1)
	if (b->idx == MAX_BUF-1) {
400001c6:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
400001cc:	75 1c                	jne    400001ea <putch+0x3a>
		b->buf[b->idx] = 0;
400001ce:	c6 86 07 10 00 00 00 	movb   $0x0,0x1007(%esi)
		puts(b->buf, b->idx);
400001d5:	8d 4e 08             	lea    0x8(%esi),%ecx
sys_write(int fd, char *p, int n)
{
	int errno;
	size_t ret;

	asm volatile("int %2"
400001d8:	b8 08 00 00 00       	mov    $0x8,%eax
400001dd:	bb 01 00 00 00       	mov    $0x1,%ebx
400001e2:	cd 30                	int    $0x30
		b->idx = 0;
400001e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	}
	b->cnt++;
400001ea:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
400001ee:	5b                   	pop    %ebx
400001ef:	5e                   	pop    %esi
400001f0:	5d                   	pop    %ebp
400001f1:	c3                   	ret
400001f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400001f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400001ff:	00 

40000200 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
40000200:	55                   	push   %ebp
40000201:	89 e5                	mov    %esp,%ebp
40000203:	53                   	push   %ebx
40000204:	bb 01 00 00 00       	mov    $0x1,%ebx
	struct printbuf b;

	b.idx = 0;
	b.cnt = 0;
	vprintfmt((void*)putch, &b, fmt, ap);
40000209:	8d 85 f0 ef ff ff    	lea    -0x1010(%ebp),%eax
{
4000020f:	81 ec 14 10 00 00    	sub    $0x1014,%esp
	vprintfmt((void*)putch, &b, fmt, ap);
40000215:	ff 75 0c             	push   0xc(%ebp)
40000218:	ff 75 08             	push   0x8(%ebp)
4000021b:	50                   	push   %eax
4000021c:	68 b0 01 00 40       	push   $0x400001b0
	b.idx = 0;
40000221:	c7 85 f0 ef ff ff 00 	movl   $0x0,-0x1010(%ebp)
40000228:	00 00 00 
	b.cnt = 0;
4000022b:	c7 85 f4 ef ff ff 00 	movl   $0x0,-0x100c(%ebp)
40000232:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
40000235:	e8 26 01 00 00       	call   40000360 <vprintfmt>

	b.buf[b.idx] = 0;
4000023a:	8b 95 f0 ef ff ff    	mov    -0x1010(%ebp),%edx
40000240:	8d 8d f8 ef ff ff    	lea    -0x1008(%ebp),%ecx
40000246:	b8 08 00 00 00       	mov    $0x8,%eax
4000024b:	c6 84 15 f8 ef ff ff 	movb   $0x0,-0x1008(%ebp,%edx,1)
40000252:	00 
40000253:	cd 30                	int    $0x30
	puts(b.buf, b.idx);

	return b.cnt;
}
40000255:	8b 85 f4 ef ff ff    	mov    -0x100c(%ebp),%eax
4000025b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
4000025e:	c9                   	leave
4000025f:	c3                   	ret

40000260 <printf>:

int
printf(const char *fmt, ...)
{
40000260:	55                   	push   %ebp
40000261:	89 e5                	mov    %esp,%ebp
40000263:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
40000266:	8d 45 0c             	lea    0xc(%ebp),%eax
40000269:	50                   	push   %eax
4000026a:	ff 75 08             	push   0x8(%ebp)
4000026d:	e8 8e ff ff ff       	call   40000200 <vcprintf>
	va_end(ap);

	return cnt;
}
40000272:	c9                   	leave
40000273:	c3                   	ret
40000274:	66 90                	xchg   %ax,%ax
40000276:	66 90                	xchg   %ax,%ax
40000278:	66 90                	xchg   %ax,%ax
4000027a:	66 90                	xchg   %ax,%ax
4000027c:	66 90                	xchg   %ax,%ax
4000027e:	66 90                	xchg   %ax,%ax

40000280 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
40000280:	55                   	push   %ebp
40000281:	89 e5                	mov    %esp,%ebp
40000283:	57                   	push   %edi
40000284:	89 c7                	mov    %eax,%edi
40000286:	56                   	push   %esi
40000287:	89 d6                	mov    %edx,%esi
40000289:	53                   	push   %ebx
4000028a:	83 ec 2c             	sub    $0x2c,%esp
4000028d:	8b 45 08             	mov    0x8(%ebp),%eax
40000290:	8b 55 0c             	mov    0xc(%ebp),%edx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
40000293:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
{
4000029a:	8b 4d 18             	mov    0x18(%ebp),%ecx
4000029d:	89 45 d8             	mov    %eax,-0x28(%ebp)
400002a0:	8b 45 10             	mov    0x10(%ebp),%eax
400002a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
400002a6:	8b 55 14             	mov    0x14(%ebp),%edx
400002a9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	if (num >= base) {
400002ac:	39 45 d8             	cmp    %eax,-0x28(%ebp)
400002af:	8b 4d dc             	mov    -0x24(%ebp),%ecx
400002b2:	1b 4d d4             	sbb    -0x2c(%ebp),%ecx
400002b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
400002b8:	8d 5a ff             	lea    -0x1(%edx),%ebx
	if (num >= base) {
400002bb:	73 53                	jae    40000310 <printnum+0x90>
		while (--width > 0)
400002bd:	83 fa 01             	cmp    $0x1,%edx
400002c0:	7e 1f                	jle    400002e1 <printnum+0x61>
400002c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400002c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400002cf:	00 
			putch(padc, putdat);
400002d0:	83 ec 08             	sub    $0x8,%esp
400002d3:	56                   	push   %esi
400002d4:	ff 75 e4             	push   -0x1c(%ebp)
400002d7:	ff d7                	call   *%edi
		while (--width > 0)
400002d9:	83 c4 10             	add    $0x10,%esp
400002dc:	83 eb 01             	sub    $0x1,%ebx
400002df:	75 ef                	jne    400002d0 <printnum+0x50>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
400002e1:	89 75 0c             	mov    %esi,0xc(%ebp)
400002e4:	ff 75 d4             	push   -0x2c(%ebp)
400002e7:	ff 75 d0             	push   -0x30(%ebp)
400002ea:	ff 75 dc             	push   -0x24(%ebp)
400002ed:	ff 75 d8             	push   -0x28(%ebp)
400002f0:	e8 6b 0d 00 00       	call   40001060 <__umoddi3>
400002f5:	83 c4 10             	add    $0x10,%esp
400002f8:	0f be 80 bc 11 00 40 	movsbl 0x400011bc(%eax),%eax
400002ff:	89 45 08             	mov    %eax,0x8(%ebp)
}
40000302:	8d 65 f4             	lea    -0xc(%ebp),%esp
	putch("0123456789abcdef"[num % base], putdat);
40000305:	89 f8                	mov    %edi,%eax
}
40000307:	5b                   	pop    %ebx
40000308:	5e                   	pop    %esi
40000309:	5f                   	pop    %edi
4000030a:	5d                   	pop    %ebp
	putch("0123456789abcdef"[num % base], putdat);
4000030b:	ff e0                	jmp    *%eax
4000030d:	8d 76 00             	lea    0x0(%esi),%esi
		printnum(putch, putdat, num / base, base, width - 1, padc);
40000310:	83 ec 0c             	sub    $0xc,%esp
40000313:	ff 75 e4             	push   -0x1c(%ebp)
40000316:	53                   	push   %ebx
40000317:	50                   	push   %eax
40000318:	83 ec 08             	sub    $0x8,%esp
4000031b:	ff 75 d4             	push   -0x2c(%ebp)
4000031e:	ff 75 d0             	push   -0x30(%ebp)
40000321:	ff 75 dc             	push   -0x24(%ebp)
40000324:	ff 75 d8             	push   -0x28(%ebp)
40000327:	e8 14 0c 00 00       	call   40000f40 <__udivdi3>
4000032c:	83 c4 18             	add    $0x18,%esp
4000032f:	52                   	push   %edx
40000330:	89 f2                	mov    %esi,%edx
40000332:	50                   	push   %eax
40000333:	89 f8                	mov    %edi,%eax
40000335:	e8 46 ff ff ff       	call   40000280 <printnum>
4000033a:	83 c4 20             	add    $0x20,%esp
4000033d:	eb a2                	jmp    400002e1 <printnum+0x61>
4000033f:	90                   	nop

40000340 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
40000340:	55                   	push   %ebp
40000341:	89 e5                	mov    %esp,%ebp
40000343:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
40000346:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
4000034a:	8b 10                	mov    (%eax),%edx
4000034c:	3b 50 04             	cmp    0x4(%eax),%edx
4000034f:	73 0a                	jae    4000035b <sprintputch+0x1b>
		*b->buf++ = ch;
40000351:	8d 4a 01             	lea    0x1(%edx),%ecx
40000354:	89 08                	mov    %ecx,(%eax)
40000356:	8b 45 08             	mov    0x8(%ebp),%eax
40000359:	88 02                	mov    %al,(%edx)
}
4000035b:	5d                   	pop    %ebp
4000035c:	c3                   	ret
4000035d:	8d 76 00             	lea    0x0(%esi),%esi

40000360 <vprintfmt>:
{
40000360:	55                   	push   %ebp
40000361:	89 e5                	mov    %esp,%ebp
40000363:	57                   	push   %edi
40000364:	56                   	push   %esi
40000365:	53                   	push   %ebx
40000366:	83 ec 2c             	sub    $0x2c,%esp
40000369:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000036c:	8b 75 0c             	mov    0xc(%ebp),%esi
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000036f:	8b 45 10             	mov    0x10(%ebp),%eax
40000372:	8d 78 01             	lea    0x1(%eax),%edi
40000375:	0f b6 00             	movzbl (%eax),%eax
40000378:	83 f8 25             	cmp    $0x25,%eax
4000037b:	75 19                	jne    40000396 <vprintfmt+0x36>
4000037d:	eb 29                	jmp    400003a8 <vprintfmt+0x48>
4000037f:	90                   	nop
			putch(ch, putdat);
40000380:	83 ec 08             	sub    $0x8,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
40000383:	83 c7 01             	add    $0x1,%edi
			putch(ch, putdat);
40000386:	56                   	push   %esi
40000387:	50                   	push   %eax
40000388:	ff d3                	call   *%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000038a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
4000038e:	83 c4 10             	add    $0x10,%esp
40000391:	83 f8 25             	cmp    $0x25,%eax
40000394:	74 12                	je     400003a8 <vprintfmt+0x48>
			if (ch == '\0')
40000396:	85 c0                	test   %eax,%eax
40000398:	75 e6                	jne    40000380 <vprintfmt+0x20>
}
4000039a:	8d 65 f4             	lea    -0xc(%ebp),%esp
4000039d:	5b                   	pop    %ebx
4000039e:	5e                   	pop    %esi
4000039f:	5f                   	pop    %edi
400003a0:	5d                   	pop    %ebp
400003a1:	c3                   	ret
400003a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		padc = ' ';
400003a8:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
		precision = -1;
400003ac:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		altflag = 0;
400003b1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		width = -1;
400003b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		lflag = 0;
400003bf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400003c6:	0f b6 17             	movzbl (%edi),%edx
400003c9:	8d 47 01             	lea    0x1(%edi),%eax
400003cc:	89 45 10             	mov    %eax,0x10(%ebp)
400003cf:	8d 42 dd             	lea    -0x23(%edx),%eax
400003d2:	3c 55                	cmp    $0x55,%al
400003d4:	77 0a                	ja     400003e0 <vprintfmt+0x80>
400003d6:	0f b6 c0             	movzbl %al,%eax
400003d9:	ff 24 85 dc 11 00 40 	jmp    *0x400011dc(,%eax,4)
			putch('%', putdat);
400003e0:	83 ec 08             	sub    $0x8,%esp
400003e3:	56                   	push   %esi
400003e4:	6a 25                	push   $0x25
400003e6:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
400003e8:	83 c4 10             	add    $0x10,%esp
400003eb:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
400003ef:	89 7d 10             	mov    %edi,0x10(%ebp)
400003f2:	0f 84 77 ff ff ff    	je     4000036f <vprintfmt+0xf>
400003f8:	89 f8                	mov    %edi,%eax
400003fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000400:	83 e8 01             	sub    $0x1,%eax
40000403:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
40000407:	75 f7                	jne    40000400 <vprintfmt+0xa0>
40000409:	89 45 10             	mov    %eax,0x10(%ebp)
4000040c:	e9 5e ff ff ff       	jmp    4000036f <vprintfmt+0xf>
40000411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				if (ch < '0' || ch > '9')
40000418:	0f be 47 01          	movsbl 0x1(%edi),%eax
				precision = precision * 10 + ch - '0';
4000041c:	8d 4a d0             	lea    -0x30(%edx),%ecx
		switch (ch = *(unsigned char *) fmt++) {
4000041f:	8b 7d 10             	mov    0x10(%ebp),%edi
				if (ch < '0' || ch > '9')
40000422:	8d 50 d0             	lea    -0x30(%eax),%edx
40000425:	83 fa 09             	cmp    $0x9,%edx
40000428:	77 2b                	ja     40000455 <vprintfmt+0xf5>
4000042a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000430:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000437:	00 
40000438:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000043f:	00 
				precision = precision * 10 + ch - '0';
40000440:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
			for (precision = 0; ; ++fmt) {
40000443:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
40000446:	8d 4c 50 d0          	lea    -0x30(%eax,%edx,2),%ecx
				ch = *fmt;
4000044a:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
4000044d:	8d 50 d0             	lea    -0x30(%eax),%edx
40000450:	83 fa 09             	cmp    $0x9,%edx
40000453:	76 eb                	jbe    40000440 <vprintfmt+0xe0>
			if (width < 0)
40000455:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000458:	85 c0                	test   %eax,%eax
				width = precision, precision = -1;
4000045a:	0f 48 c1             	cmovs  %ecx,%eax
4000045d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
40000460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000465:	0f 48 c8             	cmovs  %eax,%ecx
40000468:	e9 59 ff ff ff       	jmp    400003c6 <vprintfmt+0x66>
			altflag = 1;
4000046d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000474:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000477:	e9 4a ff ff ff       	jmp    400003c6 <vprintfmt+0x66>
			putch(ch, putdat);
4000047c:	83 ec 08             	sub    $0x8,%esp
4000047f:	56                   	push   %esi
40000480:	6a 25                	push   $0x25
40000482:	ff d3                	call   *%ebx
			break;
40000484:	83 c4 10             	add    $0x10,%esp
40000487:	e9 e3 fe ff ff       	jmp    4000036f <vprintfmt+0xf>
			precision = va_arg(ap, int);
4000048c:	8b 45 14             	mov    0x14(%ebp),%eax
		switch (ch = *(unsigned char *) fmt++) {
4000048f:	8b 7d 10             	mov    0x10(%ebp),%edi
			precision = va_arg(ap, int);
40000492:	8b 08                	mov    (%eax),%ecx
40000494:	83 c0 04             	add    $0x4,%eax
40000497:	89 45 14             	mov    %eax,0x14(%ebp)
			goto process_precision;
4000049a:	eb b9                	jmp    40000455 <vprintfmt+0xf5>
			if (width < 0)
4000049c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
4000049f:	31 c0                	xor    %eax,%eax
		switch (ch = *(unsigned char *) fmt++) {
400004a1:	8b 7d 10             	mov    0x10(%ebp),%edi
			if (width < 0)
400004a4:	85 d2                	test   %edx,%edx
400004a6:	0f 49 c2             	cmovns %edx,%eax
400004a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			goto reswitch;
400004ac:	e9 15 ff ff ff       	jmp    400003c6 <vprintfmt+0x66>
			putch(va_arg(ap, int), putdat);
400004b1:	83 ec 08             	sub    $0x8,%esp
400004b4:	56                   	push   %esi
400004b5:	8b 45 14             	mov    0x14(%ebp),%eax
400004b8:	ff 30                	push   (%eax)
400004ba:	ff d3                	call   *%ebx
400004bc:	8b 45 14             	mov    0x14(%ebp),%eax
400004bf:	83 c0 04             	add    $0x4,%eax
			break;
400004c2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
400004c5:	89 45 14             	mov    %eax,0x14(%ebp)
			break;
400004c8:	e9 a2 fe ff ff       	jmp    4000036f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
400004cd:	8b 45 14             	mov    0x14(%ebp),%eax
400004d0:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
400004d2:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
400004d6:	0f 8f af 01 00 00    	jg     4000068b <vprintfmt+0x32b>
		return va_arg(*ap, unsigned long);
400004dc:	83 c0 04             	add    $0x4,%eax
400004df:	31 c9                	xor    %ecx,%ecx
400004e1:	bf 0a 00 00 00       	mov    $0xa,%edi
400004e6:	89 45 14             	mov    %eax,0x14(%ebp)
400004e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			printnum(putch, putdat, num, base, width, padc);
400004f0:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
400004f4:	83 ec 0c             	sub    $0xc,%esp
400004f7:	50                   	push   %eax
400004f8:	89 d8                	mov    %ebx,%eax
400004fa:	ff 75 e4             	push   -0x1c(%ebp)
400004fd:	57                   	push   %edi
400004fe:	51                   	push   %ecx
400004ff:	52                   	push   %edx
40000500:	89 f2                	mov    %esi,%edx
40000502:	e8 79 fd ff ff       	call   40000280 <printnum>
			break;
40000507:	83 c4 20             	add    $0x20,%esp
4000050a:	e9 60 fe ff ff       	jmp    4000036f <vprintfmt+0xf>
			putch('0', putdat);
4000050f:	83 ec 08             	sub    $0x8,%esp
			goto number;
40000512:	bf 10 00 00 00       	mov    $0x10,%edi
			putch('0', putdat);
40000517:	56                   	push   %esi
40000518:	6a 30                	push   $0x30
4000051a:	ff d3                	call   *%ebx
			putch('x', putdat);
4000051c:	58                   	pop    %eax
4000051d:	5a                   	pop    %edx
4000051e:	56                   	push   %esi
4000051f:	6a 78                	push   $0x78
40000521:	ff d3                	call   *%ebx
			num = (unsigned long long)
40000523:	8b 45 14             	mov    0x14(%ebp),%eax
40000526:	31 c9                	xor    %ecx,%ecx
40000528:	8b 10                	mov    (%eax),%edx
				(uintptr_t) va_arg(ap, void *);
4000052a:	83 c0 04             	add    $0x4,%eax
			goto number;
4000052d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
40000530:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;
40000533:	eb bb                	jmp    400004f0 <vprintfmt+0x190>
		return va_arg(*ap, unsigned long long);
40000535:	8b 45 14             	mov    0x14(%ebp),%eax
40000538:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
4000053a:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
4000053e:	0f 8f 5a 01 00 00    	jg     4000069e <vprintfmt+0x33e>
		return va_arg(*ap, unsigned long);
40000544:	83 c0 04             	add    $0x4,%eax
40000547:	31 c9                	xor    %ecx,%ecx
40000549:	bf 10 00 00 00       	mov    $0x10,%edi
4000054e:	89 45 14             	mov    %eax,0x14(%ebp)
40000551:	eb 9d                	jmp    400004f0 <vprintfmt+0x190>
		return va_arg(*ap, long long);
40000553:	8b 45 14             	mov    0x14(%ebp),%eax
	if (lflag >= 2)
40000556:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
4000055a:	0f 8f 51 01 00 00    	jg     400006b1 <vprintfmt+0x351>
		return va_arg(*ap, long);
40000560:	8b 4d 14             	mov    0x14(%ebp),%ecx
40000563:	8b 00                	mov    (%eax),%eax
40000565:	83 c1 04             	add    $0x4,%ecx
40000568:	99                   	cltd
40000569:	89 4d 14             	mov    %ecx,0x14(%ebp)
			if ((long long) num < 0) {
4000056c:	85 d2                	test   %edx,%edx
4000056e:	0f 88 68 01 00 00    	js     400006dc <vprintfmt+0x37c>
			num = getint(&ap, lflag);
40000574:	89 d1                	mov    %edx,%ecx
40000576:	bf 0a 00 00 00       	mov    $0xa,%edi
4000057b:	89 c2                	mov    %eax,%edx
4000057d:	e9 6e ff ff ff       	jmp    400004f0 <vprintfmt+0x190>
			lflag++;
40000582:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000586:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000589:	e9 38 fe ff ff       	jmp    400003c6 <vprintfmt+0x66>
			putch('X', putdat);
4000058e:	83 ec 08             	sub    $0x8,%esp
40000591:	56                   	push   %esi
40000592:	6a 58                	push   $0x58
40000594:	ff d3                	call   *%ebx
			putch('X', putdat);
40000596:	59                   	pop    %ecx
40000597:	5f                   	pop    %edi
40000598:	56                   	push   %esi
40000599:	6a 58                	push   $0x58
4000059b:	ff d3                	call   *%ebx
			putch('X', putdat);
4000059d:	58                   	pop    %eax
4000059e:	5a                   	pop    %edx
4000059f:	56                   	push   %esi
400005a0:	6a 58                	push   $0x58
400005a2:	ff d3                	call   *%ebx
			break;
400005a4:	83 c4 10             	add    $0x10,%esp
400005a7:	e9 c3 fd ff ff       	jmp    4000036f <vprintfmt+0xf>
			if ((p = va_arg(ap, char *)) == NULL)
400005ac:	8b 45 14             	mov    0x14(%ebp),%eax
400005af:	83 c0 04             	add    $0x4,%eax
400005b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
400005b5:	8b 45 14             	mov    0x14(%ebp),%eax
400005b8:	8b 38                	mov    (%eax),%edi
			if (width > 0 && padc != '-')
400005ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400005bd:	85 c0                	test   %eax,%eax
400005bf:	0f 9f c0             	setg   %al
400005c2:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
400005c6:	0f 95 c2             	setne  %dl
400005c9:	21 d0                	and    %edx,%eax
			if ((p = va_arg(ap, char *)) == NULL)
400005cb:	85 ff                	test   %edi,%edi
400005cd:	0f 84 32 01 00 00    	je     40000705 <vprintfmt+0x3a5>
			if (width > 0 && padc != '-')
400005d3:	84 c0                	test   %al,%al
400005d5:	0f 85 4d 01 00 00    	jne    40000728 <vprintfmt+0x3c8>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400005db:	0f be 07             	movsbl (%edi),%eax
400005de:	89 c2                	mov    %eax,%edx
400005e0:	85 c0                	test   %eax,%eax
400005e2:	74 7b                	je     4000065f <vprintfmt+0x2ff>
400005e4:	89 5d 08             	mov    %ebx,0x8(%ebp)
400005e7:	83 c7 01             	add    $0x1,%edi
400005ea:	89 cb                	mov    %ecx,%ebx
400005ec:	89 75 0c             	mov    %esi,0xc(%ebp)
400005ef:	8b 75 e4             	mov    -0x1c(%ebp),%esi
400005f2:	eb 21                	jmp    40000615 <vprintfmt+0x2b5>
400005f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					putch(ch, putdat);
400005f8:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400005fb:	83 c7 01             	add    $0x1,%edi
					putch(ch, putdat);
400005fe:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000601:	83 ee 01             	sub    $0x1,%esi
					putch(ch, putdat);
40000604:	50                   	push   %eax
40000605:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000608:	0f be 47 ff          	movsbl -0x1(%edi),%eax
4000060c:	83 c4 10             	add    $0x10,%esp
4000060f:	89 c2                	mov    %eax,%edx
40000611:	85 c0                	test   %eax,%eax
40000613:	74 41                	je     40000656 <vprintfmt+0x2f6>
40000615:	85 db                	test   %ebx,%ebx
40000617:	78 05                	js     4000061e <vprintfmt+0x2be>
40000619:	83 eb 01             	sub    $0x1,%ebx
4000061c:	72 38                	jb     40000656 <vprintfmt+0x2f6>
				if (altflag && (ch < ' ' || ch > '~'))
4000061e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
40000621:	85 c9                	test   %ecx,%ecx
40000623:	74 d3                	je     400005f8 <vprintfmt+0x298>
40000625:	0f be ca             	movsbl %dl,%ecx
40000628:	83 e9 20             	sub    $0x20,%ecx
4000062b:	83 f9 5e             	cmp    $0x5e,%ecx
4000062e:	76 c8                	jbe    400005f8 <vprintfmt+0x298>
					putch('?', putdat);
40000630:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000633:	83 c7 01             	add    $0x1,%edi
					putch('?', putdat);
40000636:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000639:	83 ee 01             	sub    $0x1,%esi
					putch('?', putdat);
4000063c:	6a 3f                	push   $0x3f
4000063e:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000641:	0f be 4f ff          	movsbl -0x1(%edi),%ecx
40000645:	83 c4 10             	add    $0x10,%esp
40000648:	89 ca                	mov    %ecx,%edx
4000064a:	89 c8                	mov    %ecx,%eax
4000064c:	85 c9                	test   %ecx,%ecx
4000064e:	74 06                	je     40000656 <vprintfmt+0x2f6>
40000650:	85 db                	test   %ebx,%ebx
40000652:	79 c5                	jns    40000619 <vprintfmt+0x2b9>
40000654:	eb d2                	jmp    40000628 <vprintfmt+0x2c8>
40000656:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40000659:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000065c:	8b 75 0c             	mov    0xc(%ebp),%esi
			for (; width > 0; width--)
4000065f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000662:	85 c0                	test   %eax,%eax
40000664:	7e 1a                	jle    40000680 <vprintfmt+0x320>
40000666:	89 c7                	mov    %eax,%edi
40000668:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000066f:	00 
				putch(' ', putdat);
40000670:	83 ec 08             	sub    $0x8,%esp
40000673:	56                   	push   %esi
40000674:	6a 20                	push   $0x20
40000676:	ff d3                	call   *%ebx
			for (; width > 0; width--)
40000678:	83 c4 10             	add    $0x10,%esp
4000067b:	83 ef 01             	sub    $0x1,%edi
4000067e:	75 f0                	jne    40000670 <vprintfmt+0x310>
			if ((p = va_arg(ap, char *)) == NULL)
40000680:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40000683:	89 45 14             	mov    %eax,0x14(%ebp)
40000686:	e9 e4 fc ff ff       	jmp    4000036f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
4000068b:	8b 48 04             	mov    0x4(%eax),%ecx
4000068e:	83 c0 08             	add    $0x8,%eax
40000691:	bf 0a 00 00 00       	mov    $0xa,%edi
40000696:	89 45 14             	mov    %eax,0x14(%ebp)
40000699:	e9 52 fe ff ff       	jmp    400004f0 <vprintfmt+0x190>
4000069e:	8b 48 04             	mov    0x4(%eax),%ecx
400006a1:	83 c0 08             	add    $0x8,%eax
400006a4:	bf 10 00 00 00       	mov    $0x10,%edi
400006a9:	89 45 14             	mov    %eax,0x14(%ebp)
400006ac:	e9 3f fe ff ff       	jmp    400004f0 <vprintfmt+0x190>
		return va_arg(*ap, long long);
400006b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
400006b4:	8b 50 04             	mov    0x4(%eax),%edx
400006b7:	8b 00                	mov    (%eax),%eax
400006b9:	83 c1 08             	add    $0x8,%ecx
400006bc:	89 4d 14             	mov    %ecx,0x14(%ebp)
400006bf:	e9 a8 fe ff ff       	jmp    4000056c <vprintfmt+0x20c>
		switch (ch = *(unsigned char *) fmt++) {
400006c4:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
400006c8:	8b 7d 10             	mov    0x10(%ebp),%edi
400006cb:	e9 f6 fc ff ff       	jmp    400003c6 <vprintfmt+0x66>
			padc = '-';
400006d0:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400006d4:	8b 7d 10             	mov    0x10(%ebp),%edi
400006d7:	e9 ea fc ff ff       	jmp    400003c6 <vprintfmt+0x66>
				putch('-', putdat);
400006dc:	83 ec 08             	sub    $0x8,%esp
400006df:	89 45 d8             	mov    %eax,-0x28(%ebp)
				num = -(long long) num;
400006e2:	bf 0a 00 00 00       	mov    $0xa,%edi
400006e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch('-', putdat);
400006ea:	56                   	push   %esi
400006eb:	6a 2d                	push   $0x2d
400006ed:	ff d3                	call   *%ebx
				num = -(long long) num;
400006ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
400006f2:	31 d2                	xor    %edx,%edx
400006f4:	f7 d8                	neg    %eax
400006f6:	1b 55 dc             	sbb    -0x24(%ebp),%edx
400006f9:	83 c4 10             	add    $0x10,%esp
400006fc:	89 d1                	mov    %edx,%ecx
400006fe:	89 c2                	mov    %eax,%edx
40000700:	e9 eb fd ff ff       	jmp    400004f0 <vprintfmt+0x190>
			if (width > 0 && padc != '-')
40000705:	84 c0                	test   %al,%al
40000707:	75 78                	jne    40000781 <vprintfmt+0x421>
40000709:	89 5d 08             	mov    %ebx,0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000070c:	bf ce 11 00 40       	mov    $0x400011ce,%edi
40000711:	ba 28 00 00 00       	mov    $0x28,%edx
40000716:	89 cb                	mov    %ecx,%ebx
40000718:	89 75 0c             	mov    %esi,0xc(%ebp)
4000071b:	b8 28 00 00 00       	mov    $0x28,%eax
40000720:	8b 75 e4             	mov    -0x1c(%ebp),%esi
40000723:	e9 ed fe ff ff       	jmp    40000615 <vprintfmt+0x2b5>
				for (width -= strnlen(p, precision); width > 0; width--)
40000728:	83 ec 08             	sub    $0x8,%esp
4000072b:	51                   	push   %ecx
4000072c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
4000072f:	57                   	push   %edi
40000730:	e8 eb 02 00 00       	call   40000a20 <strnlen>
40000735:	29 45 e4             	sub    %eax,-0x1c(%ebp)
40000738:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
4000073b:	83 c4 10             	add    $0x10,%esp
4000073e:	85 c9                	test   %ecx,%ecx
40000740:	8b 4d d0             	mov    -0x30(%ebp),%ecx
40000743:	7e 71                	jle    400007b6 <vprintfmt+0x456>
					putch(padc, putdat);
40000745:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
40000749:	89 4d cc             	mov    %ecx,-0x34(%ebp)
4000074c:	89 7d d0             	mov    %edi,-0x30(%ebp)
4000074f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
40000752:	89 45 e0             	mov    %eax,-0x20(%ebp)
40000755:	83 ec 08             	sub    $0x8,%esp
40000758:	56                   	push   %esi
40000759:	ff 75 e0             	push   -0x20(%ebp)
4000075c:	ff d3                	call   *%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
4000075e:	83 c4 10             	add    $0x10,%esp
40000761:	83 ef 01             	sub    $0x1,%edi
40000764:	75 ef                	jne    40000755 <vprintfmt+0x3f5>
40000766:	89 7d e4             	mov    %edi,-0x1c(%ebp)
40000769:	8b 7d d0             	mov    -0x30(%ebp),%edi
4000076c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000076f:	0f be 07             	movsbl (%edi),%eax
40000772:	89 c2                	mov    %eax,%edx
40000774:	85 c0                	test   %eax,%eax
40000776:	0f 85 68 fe ff ff    	jne    400005e4 <vprintfmt+0x284>
4000077c:	e9 ff fe ff ff       	jmp    40000680 <vprintfmt+0x320>
				for (width -= strnlen(p, precision); width > 0; width--)
40000781:	83 ec 08             	sub    $0x8,%esp
				p = "(null)";
40000784:	bf cd 11 00 40       	mov    $0x400011cd,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
40000789:	51                   	push   %ecx
4000078a:	89 4d d0             	mov    %ecx,-0x30(%ebp)
4000078d:	68 cd 11 00 40       	push   $0x400011cd
40000792:	e8 89 02 00 00       	call   40000a20 <strnlen>
40000797:	29 45 e4             	sub    %eax,-0x1c(%ebp)
4000079a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
4000079d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400007a0:	ba 28 00 00 00       	mov    $0x28,%edx
400007a5:	b8 28 00 00 00       	mov    $0x28,%eax
				for (width -= strnlen(p, precision); width > 0; width--)
400007aa:	85 c9                	test   %ecx,%ecx
400007ac:	8b 4d d0             	mov    -0x30(%ebp),%ecx
400007af:	7f 94                	jg     40000745 <vprintfmt+0x3e5>
400007b1:	e9 2e fe ff ff       	jmp    400005e4 <vprintfmt+0x284>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400007b6:	0f be 07             	movsbl (%edi),%eax
400007b9:	89 c2                	mov    %eax,%edx
400007bb:	85 c0                	test   %eax,%eax
400007bd:	0f 85 21 fe ff ff    	jne    400005e4 <vprintfmt+0x284>
400007c3:	e9 b8 fe ff ff       	jmp    40000680 <vprintfmt+0x320>
400007c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400007cf:	00 

400007d0 <printfmt>:
{
400007d0:	55                   	push   %ebp
400007d1:	89 e5                	mov    %esp,%ebp
400007d3:	83 ec 08             	sub    $0x8,%esp
	vprintfmt(putch, putdat, fmt, ap);
400007d6:	8d 45 14             	lea    0x14(%ebp),%eax
400007d9:	50                   	push   %eax
400007da:	ff 75 10             	push   0x10(%ebp)
400007dd:	ff 75 0c             	push   0xc(%ebp)
400007e0:	ff 75 08             	push   0x8(%ebp)
400007e3:	e8 78 fb ff ff       	call   40000360 <vprintfmt>
}
400007e8:	83 c4 10             	add    $0x10,%esp
400007eb:	c9                   	leave
400007ec:	c3                   	ret
400007ed:	8d 76 00             	lea    0x0(%esi),%esi

400007f0 <vsprintf>:

int
vsprintf(char *buf, const char *fmt, va_list ap)
{
400007f0:	55                   	push   %ebp
400007f1:	89 e5                	mov    %esp,%ebp
400007f3:	83 ec 18             	sub    $0x18,%esp
	//assert(buf != NULL);
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400007f6:	8b 45 08             	mov    0x8(%ebp),%eax

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400007f9:	ff 75 10             	push   0x10(%ebp)
400007fc:	ff 75 0c             	push   0xc(%ebp)
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400007ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000802:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000805:	50                   	push   %eax
40000806:	68 40 03 00 40       	push   $0x40000340
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
4000080b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
40000812:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000819:	e8 42 fb ff ff       	call   40000360 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
4000081e:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000821:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000824:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000827:	c9                   	leave
40000828:	c3                   	ret
40000829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000830 <sprintf>:

int
sprintf(char *buf, const char *fmt, ...)
{
40000830:	55                   	push   %ebp
40000831:	89 e5                	mov    %esp,%ebp
40000833:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
40000836:	8b 45 08             	mov    0x8(%ebp),%eax
40000839:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
40000840:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
40000847:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000084a:	8d 45 10             	lea    0x10(%ebp),%eax
4000084d:	50                   	push   %eax
4000084e:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000851:	ff 75 0c             	push   0xc(%ebp)
40000854:	50                   	push   %eax
40000855:	68 40 03 00 40       	push   $0x40000340
4000085a:	e8 01 fb ff ff       	call   40000360 <vprintfmt>
	*b.buf = '\0';
4000085f:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000862:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsprintf(buf, fmt, ap);
	va_end(ap);

	return rc;
}
40000865:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000868:	c9                   	leave
40000869:	c3                   	ret
4000086a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000870 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
40000870:	55                   	push   %ebp
40000871:	89 e5                	mov    %esp,%ebp
40000873:	83 ec 18             	sub    $0x18,%esp
40000876:	8b 45 08             	mov    0x8(%ebp),%eax
	//assert(buf != NULL && n > 0);
	struct sprintbuf b = {buf, buf+n-1, 0};
40000879:	8b 55 0c             	mov    0xc(%ebp),%edx

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000087c:	ff 75 14             	push   0x14(%ebp)
4000087f:	ff 75 10             	push   0x10(%ebp)
	struct sprintbuf b = {buf, buf+n-1, 0};
40000882:	89 45 ec             	mov    %eax,-0x14(%ebp)
40000885:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
40000889:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000088c:	8d 45 ec             	lea    -0x14(%ebp),%eax
4000088f:	50                   	push   %eax
40000890:	68 40 03 00 40       	push   $0x40000340
	struct sprintbuf b = {buf, buf+n-1, 0};
40000895:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000089c:	e8 bf fa ff ff       	call   40000360 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
400008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
400008a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
400008a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
400008aa:	c9                   	leave
400008ab:	c3                   	ret
400008ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

400008b0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
400008b0:	55                   	push   %ebp
400008b1:	89 e5                	mov    %esp,%ebp
400008b3:	83 ec 18             	sub    $0x18,%esp
400008b6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
400008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
400008bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
400008c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
400008c6:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
400008ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008cd:	8d 45 14             	lea    0x14(%ebp),%eax
400008d0:	50                   	push   %eax
400008d1:	8d 45 ec             	lea    -0x14(%ebp),%eax
400008d4:	ff 75 10             	push   0x10(%ebp)
400008d7:	50                   	push   %eax
400008d8:	68 40 03 00 40       	push   $0x40000340
400008dd:	e8 7e fa ff ff       	call   40000360 <vprintfmt>
	*b.buf = '\0';
400008e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
400008e5:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
	va_end(ap);

	return rc;
}
400008e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
400008eb:	c9                   	leave
400008ec:	c3                   	ret
400008ed:	66 90                	xchg   %ax,%ax
400008ef:	90                   	nop

400008f0 <spawn>:
#include <syscall.h>
#include <types.h>

pid_t
spawn(uintptr_t exec, unsigned int quota)
{
400008f0:	55                   	push   %ebp
	asm volatile("int %2"
400008f1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
400008f6:	b8 01 00 00 00       	mov    $0x1,%eax
400008fb:	89 e5                	mov    %esp,%ebp
400008fd:	56                   	push   %esi
400008fe:	89 d6                	mov    %edx,%esi
40000900:	53                   	push   %ebx
40000901:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000904:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000907:	cd 30                	int    $0x30
	return errno ? -1 : pid;
40000909:	85 c0                	test   %eax,%eax
4000090b:	75 0b                	jne    40000918 <spawn+0x28>
4000090d:	89 da                	mov    %ebx,%edx
	// Default: inherit console stdin/stdout
	return sys_spawn(exec, quota, -1, -1);
}
4000090f:	5b                   	pop    %ebx
40000910:	89 d0                	mov    %edx,%eax
40000912:	5e                   	pop    %esi
40000913:	5d                   	pop    %ebp
40000914:	c3                   	ret
40000915:	8d 76 00             	lea    0x0(%esi),%esi
40000918:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, -1, -1);
4000091d:	eb f0                	jmp    4000090f <spawn+0x1f>
4000091f:	90                   	nop

40000920 <spawn_with_fds>:

pid_t
spawn_with_fds(uintptr_t exec, unsigned int quota, int stdin_fd, int stdout_fd)
{
40000920:	55                   	push   %ebp
	asm volatile("int %2"
40000921:	b8 01 00 00 00       	mov    $0x1,%eax
40000926:	89 e5                	mov    %esp,%ebp
40000928:	56                   	push   %esi
40000929:	8b 4d 0c             	mov    0xc(%ebp),%ecx
4000092c:	8b 55 10             	mov    0x10(%ebp),%edx
4000092f:	53                   	push   %ebx
40000930:	8b 75 14             	mov    0x14(%ebp),%esi
40000933:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000936:	cd 30                	int    $0x30
	return errno ? -1 : pid;
40000938:	85 c0                	test   %eax,%eax
4000093a:	75 0c                	jne    40000948 <spawn_with_fds+0x28>
4000093c:	89 da                	mov    %ebx,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
}
4000093e:	5b                   	pop    %ebx
4000093f:	89 d0                	mov    %edx,%eax
40000941:	5e                   	pop    %esi
40000942:	5d                   	pop    %ebp
40000943:	c3                   	ret
40000944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000948:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
4000094d:	eb ef                	jmp    4000093e <spawn_with_fds+0x1e>
4000094f:	90                   	nop

40000950 <yield>:
	asm volatile("int %0" :
40000950:	b8 02 00 00 00       	mov    $0x2,%eax
40000955:	cd 30                	int    $0x30

void
yield(void)
{
	sys_yield();
}
40000957:	c3                   	ret
40000958:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000095f:	00 

40000960 <produce>:
	asm volatile("int %0" :
40000960:	b8 03 00 00 00       	mov    $0x3,%eax
40000965:	cd 30                	int    $0x30

void
produce(void)
{
	sys_produce();
}
40000967:	c3                   	ret
40000968:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000096f:	00 

40000970 <consume>:
	asm volatile("int %0" :
40000970:	b8 04 00 00 00       	mov    $0x4,%eax
40000975:	cd 30                	int    $0x30

void
consume(void)
{
	sys_consume();
}
40000977:	c3                   	ret
40000978:	66 90                	xchg   %ax,%ax
4000097a:	66 90                	xchg   %ax,%ax
4000097c:	66 90                	xchg   %ax,%ax
4000097e:	66 90                	xchg   %ax,%ax

40000980 <spinlock_init>:
	return result;
}

void
spinlock_init(spinlock_t *lk)
{
40000980:	55                   	push   %ebp
40000981:	89 e5                	mov    %esp,%ebp
	*lk = 0;
40000983:	8b 45 08             	mov    0x8(%ebp),%eax
40000986:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
4000098c:	5d                   	pop    %ebp
4000098d:	c3                   	ret
4000098e:	66 90                	xchg   %ax,%ax

40000990 <spinlock_acquire>:

void
spinlock_acquire(spinlock_t *lk)
{
40000990:	55                   	push   %ebp
	asm volatile("lock; xchgl %0, %1" :
40000991:	b8 01 00 00 00       	mov    $0x1,%eax
{
40000996:	89 e5                	mov    %esp,%ebp
40000998:	8b 55 08             	mov    0x8(%ebp),%edx
	asm volatile("lock; xchgl %0, %1" :
4000099b:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
4000099e:	85 c0                	test   %eax,%eax
400009a0:	74 1c                	je     400009be <spinlock_acquire+0x2e>
400009a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400009a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400009af:	00 
		asm volatile("pause");
400009b0:	f3 90                	pause
	asm volatile("lock; xchgl %0, %1" :
400009b2:	b8 01 00 00 00       	mov    $0x1,%eax
400009b7:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
400009ba:	85 c0                	test   %eax,%eax
400009bc:	75 f2                	jne    400009b0 <spinlock_acquire+0x20>
}
400009be:	5d                   	pop    %ebp
400009bf:	c3                   	ret

400009c0 <spinlock_release>:

// Release the lock.
void
spinlock_release(spinlock_t *lk)
{
400009c0:	55                   	push   %ebp
400009c1:	89 e5                	mov    %esp,%ebp
400009c3:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
bool
spinlock_holding(spinlock_t *lock)
{
	return *lock;
400009c6:	8b 02                	mov    (%edx),%eax
	if (spinlock_holding(lk) == FALSE)
400009c8:	84 c0                	test   %al,%al
400009ca:	74 05                	je     400009d1 <spinlock_release+0x11>
	asm volatile("lock; xchgl %0, %1" :
400009cc:	31 c0                	xor    %eax,%eax
400009ce:	f0 87 02             	lock xchg %eax,(%edx)
}
400009d1:	5d                   	pop    %ebp
400009d2:	c3                   	ret
400009d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
400009d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400009df:	00 

400009e0 <spinlock_holding>:
{
400009e0:	55                   	push   %ebp
400009e1:	89 e5                	mov    %esp,%ebp
	return *lock;
400009e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
400009e6:	5d                   	pop    %ebp
	return *lock;
400009e7:	8b 00                	mov    (%eax),%eax
}
400009e9:	c3                   	ret
400009ea:	66 90                	xchg   %ax,%ax
400009ec:	66 90                	xchg   %ax,%ax
400009ee:	66 90                	xchg   %ax,%ax
400009f0:	66 90                	xchg   %ax,%ax
400009f2:	66 90                	xchg   %ax,%ax
400009f4:	66 90                	xchg   %ax,%ax
400009f6:	66 90                	xchg   %ax,%ax
400009f8:	66 90                	xchg   %ax,%ax
400009fa:	66 90                	xchg   %ax,%ax
400009fc:	66 90                	xchg   %ax,%ax
400009fe:	66 90                	xchg   %ax,%ax

40000a00 <strlen>:
#include <string.h>
#include <types.h>

int
strlen(const char *s)
{
40000a00:	55                   	push   %ebp
	int n;

	for (n = 0; *s != '\0'; s++)
40000a01:	31 c0                	xor    %eax,%eax
{
40000a03:	89 e5                	mov    %esp,%ebp
40000a05:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; *s != '\0'; s++)
40000a08:	80 3a 00             	cmpb   $0x0,(%edx)
40000a0b:	74 0c                	je     40000a19 <strlen+0x19>
40000a0d:	8d 76 00             	lea    0x0(%esi),%esi
		n++;
40000a10:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
40000a13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
40000a17:	75 f7                	jne    40000a10 <strlen+0x10>
	return n;
}
40000a19:	5d                   	pop    %ebp
40000a1a:	c3                   	ret
40000a1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

40000a20 <strnlen>:

int
strnlen(const char *s, size_t size)
{
40000a20:	55                   	push   %ebp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000a21:	31 c0                	xor    %eax,%eax
{
40000a23:	89 e5                	mov    %esp,%ebp
40000a25:	8b 55 0c             	mov    0xc(%ebp),%edx
40000a28:	8b 4d 08             	mov    0x8(%ebp),%ecx
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000a2b:	85 d2                	test   %edx,%edx
40000a2d:	75 18                	jne    40000a47 <strnlen+0x27>
40000a2f:	eb 1c                	jmp    40000a4d <strnlen+0x2d>
40000a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a3f:	00 
		n++;
40000a40:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000a43:	39 c2                	cmp    %eax,%edx
40000a45:	74 06                	je     40000a4d <strnlen+0x2d>
40000a47:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
40000a4b:	75 f3                	jne    40000a40 <strnlen+0x20>
	return n;
}
40000a4d:	5d                   	pop    %ebp
40000a4e:	c3                   	ret
40000a4f:	90                   	nop

40000a50 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
40000a50:	55                   	push   %ebp
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
40000a51:	31 c0                	xor    %eax,%eax
{
40000a53:	89 e5                	mov    %esp,%ebp
40000a55:	53                   	push   %ebx
40000a56:	8b 4d 08             	mov    0x8(%ebp),%ecx
40000a59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while ((*dst++ = *src++) != '\0')
40000a60:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000a64:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000a67:	83 c0 01             	add    $0x1,%eax
40000a6a:	84 d2                	test   %dl,%dl
40000a6c:	75 f2                	jne    40000a60 <strcpy+0x10>
		/* do nothing */;
	return ret;
}
40000a6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000a71:	89 c8                	mov    %ecx,%eax
40000a73:	c9                   	leave
40000a74:	c3                   	ret
40000a75:	8d 76 00             	lea    0x0(%esi),%esi
40000a78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a7f:	00 

40000a80 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size)
{
40000a80:	55                   	push   %ebp
40000a81:	89 e5                	mov    %esp,%ebp
40000a83:	56                   	push   %esi
40000a84:	8b 55 0c             	mov    0xc(%ebp),%edx
40000a87:	8b 75 08             	mov    0x8(%ebp),%esi
40000a8a:	53                   	push   %ebx
40000a8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
40000a8e:	85 db                	test   %ebx,%ebx
40000a90:	74 21                	je     40000ab3 <strncpy+0x33>
40000a92:	01 f3                	add    %esi,%ebx
40000a94:	89 f0                	mov    %esi,%eax
40000a96:	66 90                	xchg   %ax,%ax
40000a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a9f:	00 
		*dst++ = *src;
40000aa0:	0f b6 0a             	movzbl (%edx),%ecx
40000aa3:	83 c0 01             	add    $0x1,%eax
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
40000aa6:	80 f9 01             	cmp    $0x1,%cl
		*dst++ = *src;
40000aa9:	88 48 ff             	mov    %cl,-0x1(%eax)
			src++;
40000aac:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
40000aaf:	39 c3                	cmp    %eax,%ebx
40000ab1:	75 ed                	jne    40000aa0 <strncpy+0x20>
	}
	return ret;
}
40000ab3:	89 f0                	mov    %esi,%eax
40000ab5:	5b                   	pop    %ebx
40000ab6:	5e                   	pop    %esi
40000ab7:	5d                   	pop    %ebp
40000ab8:	c3                   	ret
40000ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000ac0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
40000ac0:	55                   	push   %ebp
40000ac1:	89 e5                	mov    %esp,%ebp
40000ac3:	53                   	push   %ebx
40000ac4:	8b 45 10             	mov    0x10(%ebp),%eax
40000ac7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
40000aca:	85 c0                	test   %eax,%eax
40000acc:	74 2e                	je     40000afc <strlcpy+0x3c>
		while (--size > 0 && *src != '\0')
40000ace:	8b 55 08             	mov    0x8(%ebp),%edx
40000ad1:	83 e8 01             	sub    $0x1,%eax
40000ad4:	74 23                	je     40000af9 <strlcpy+0x39>
40000ad6:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
40000ad9:	eb 12                	jmp    40000aed <strlcpy+0x2d>
40000adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
			*dst++ = *src++;
40000ae0:	83 c2 01             	add    $0x1,%edx
40000ae3:	83 c1 01             	add    $0x1,%ecx
40000ae6:	88 42 ff             	mov    %al,-0x1(%edx)
		while (--size > 0 && *src != '\0')
40000ae9:	39 da                	cmp    %ebx,%edx
40000aeb:	74 07                	je     40000af4 <strlcpy+0x34>
40000aed:	0f b6 01             	movzbl (%ecx),%eax
40000af0:	84 c0                	test   %al,%al
40000af2:	75 ec                	jne    40000ae0 <strlcpy+0x20>
		*dst = '\0';
	}
	return dst - dst_in;
40000af4:	89 d0                	mov    %edx,%eax
40000af6:	2b 45 08             	sub    0x8(%ebp),%eax
		*dst = '\0';
40000af9:	c6 02 00             	movb   $0x0,(%edx)
}
40000afc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000aff:	c9                   	leave
40000b00:	c3                   	ret
40000b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b0f:	00 

40000b10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
40000b10:	55                   	push   %ebp
40000b11:	89 e5                	mov    %esp,%ebp
40000b13:	53                   	push   %ebx
40000b14:	8b 55 08             	mov    0x8(%ebp),%edx
40000b17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
40000b1a:	0f b6 02             	movzbl (%edx),%eax
40000b1d:	84 c0                	test   %al,%al
40000b1f:	75 2d                	jne    40000b4e <strcmp+0x3e>
40000b21:	eb 4a                	jmp    40000b6d <strcmp+0x5d>
40000b23:	eb 1b                	jmp    40000b40 <strcmp+0x30>
40000b25:	8d 76 00             	lea    0x0(%esi),%esi
40000b28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b2f:	00 
40000b30:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b37:	00 
40000b38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b3f:	00 
40000b40:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		p++, q++;
40000b44:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
40000b47:	84 c0                	test   %al,%al
40000b49:	74 15                	je     40000b60 <strcmp+0x50>
40000b4b:	83 c1 01             	add    $0x1,%ecx
40000b4e:	0f b6 19             	movzbl (%ecx),%ebx
40000b51:	38 c3                	cmp    %al,%bl
40000b53:	74 eb                	je     40000b40 <strcmp+0x30>
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000b55:	29 d8                	sub    %ebx,%eax
}
40000b57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000b5a:	c9                   	leave
40000b5b:	c3                   	ret
40000b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000b60:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
40000b64:	31 c0                	xor    %eax,%eax
40000b66:	29 d8                	sub    %ebx,%eax
}
40000b68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000b6b:	c9                   	leave
40000b6c:	c3                   	ret
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000b6d:	0f b6 19             	movzbl (%ecx),%ebx
40000b70:	31 c0                	xor    %eax,%eax
40000b72:	eb e1                	jmp    40000b55 <strcmp+0x45>
40000b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000b78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b7f:	00 

40000b80 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
40000b80:	55                   	push   %ebp
40000b81:	89 e5                	mov    %esp,%ebp
40000b83:	53                   	push   %ebx
40000b84:	8b 55 10             	mov    0x10(%ebp),%edx
40000b87:	8b 45 08             	mov    0x8(%ebp),%eax
40000b8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
40000b8d:	85 d2                	test   %edx,%edx
40000b8f:	75 16                	jne    40000ba7 <strncmp+0x27>
40000b91:	eb 2d                	jmp    40000bc0 <strncmp+0x40>
40000b93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b98:	3a 19                	cmp    (%ecx),%bl
40000b9a:	75 12                	jne    40000bae <strncmp+0x2e>
		n--, p++, q++;
40000b9c:	83 c0 01             	add    $0x1,%eax
40000b9f:	83 c1 01             	add    $0x1,%ecx
	while (n > 0 && *p && *p == *q)
40000ba2:	83 ea 01             	sub    $0x1,%edx
40000ba5:	74 19                	je     40000bc0 <strncmp+0x40>
40000ba7:	0f b6 18             	movzbl (%eax),%ebx
40000baa:	84 db                	test   %bl,%bl
40000bac:	75 ea                	jne    40000b98 <strncmp+0x18>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000bae:	0f b6 00             	movzbl (%eax),%eax
40000bb1:	0f b6 11             	movzbl (%ecx),%edx
}
40000bb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000bb7:	c9                   	leave
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000bb8:	29 d0                	sub    %edx,%eax
}
40000bba:	c3                   	ret
40000bbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
		return 0;
40000bc3:	31 c0                	xor    %eax,%eax
}
40000bc5:	c9                   	leave
40000bc6:	c3                   	ret
40000bc7:	90                   	nop
40000bc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bcf:	00 

40000bd0 <strchr>:

char *
strchr(const char *s, char c)
{
40000bd0:	55                   	push   %ebp
40000bd1:	89 e5                	mov    %esp,%ebp
40000bd3:	8b 45 08             	mov    0x8(%ebp),%eax
40000bd6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
40000bda:	0f b6 10             	movzbl (%eax),%edx
40000bdd:	84 d2                	test   %dl,%dl
40000bdf:	75 1a                	jne    40000bfb <strchr+0x2b>
40000be1:	eb 25                	jmp    40000c08 <strchr+0x38>
40000be3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000be8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bef:	00 
40000bf0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000bf4:	83 c0 01             	add    $0x1,%eax
40000bf7:	84 d2                	test   %dl,%dl
40000bf9:	74 0d                	je     40000c08 <strchr+0x38>
		if (*s == c)
40000bfb:	38 d1                	cmp    %dl,%cl
40000bfd:	75 f1                	jne    40000bf0 <strchr+0x20>
			return (char *) s;
	return 0;
}
40000bff:	5d                   	pop    %ebp
40000c00:	c3                   	ret
40000c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return 0;
40000c08:	31 c0                	xor    %eax,%eax
}
40000c0a:	5d                   	pop    %ebp
40000c0b:	c3                   	ret
40000c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000c10 <strfind>:

char *
strfind(const char *s, char c)
{
40000c10:	55                   	push   %ebp
40000c11:	89 e5                	mov    %esp,%ebp
40000c13:	8b 45 08             	mov    0x8(%ebp),%eax
40000c16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	for (; *s; s++)
40000c19:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
40000c1c:	38 ca                	cmp    %cl,%dl
40000c1e:	75 1b                	jne    40000c3b <strfind+0x2b>
40000c20:	eb 1d                	jmp    40000c3f <strfind+0x2f>
40000c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000c28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c2f:	00 
	for (; *s; s++)
40000c30:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000c34:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
40000c37:	38 ca                	cmp    %cl,%dl
40000c39:	74 04                	je     40000c3f <strfind+0x2f>
40000c3b:	84 d2                	test   %dl,%dl
40000c3d:	75 f1                	jne    40000c30 <strfind+0x20>
			break;
	return (char *) s;
}
40000c3f:	5d                   	pop    %ebp
40000c40:	c3                   	ret
40000c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c4f:	00 

40000c50 <strtol>:


long
strtol(const char *s, char **endptr, int base)
{
40000c50:	55                   	push   %ebp
40000c51:	89 e5                	mov    %esp,%ebp
40000c53:	57                   	push   %edi
40000c54:	8b 55 08             	mov    0x8(%ebp),%edx
40000c57:	56                   	push   %esi
40000c58:	53                   	push   %ebx
40000c59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
40000c5c:	0f b6 02             	movzbl (%edx),%eax
40000c5f:	3c 09                	cmp    $0x9,%al
40000c61:	74 0d                	je     40000c70 <strtol+0x20>
40000c63:	3c 20                	cmp    $0x20,%al
40000c65:	75 18                	jne    40000c7f <strtol+0x2f>
40000c67:	90                   	nop
40000c68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c6f:	00 
40000c70:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		s++;
40000c74:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
40000c77:	3c 20                	cmp    $0x20,%al
40000c79:	74 f5                	je     40000c70 <strtol+0x20>
40000c7b:	3c 09                	cmp    $0x9,%al
40000c7d:	74 f1                	je     40000c70 <strtol+0x20>

	// plus/minus sign
	if (*s == '+')
40000c7f:	3c 2b                	cmp    $0x2b,%al
40000c81:	0f 84 89 00 00 00    	je     40000d10 <strtol+0xc0>
		s++;
	else if (*s == '-')
		s++, neg = 1;
40000c87:	3c 2d                	cmp    $0x2d,%al
40000c89:	8d 4a 01             	lea    0x1(%edx),%ecx
40000c8c:	0f 94 c0             	sete   %al
40000c8f:	0f 44 d1             	cmove  %ecx,%edx
40000c92:	0f b6 c0             	movzbl %al,%eax

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000c95:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
40000c9b:	75 10                	jne    40000cad <strtol+0x5d>
40000c9d:	80 3a 30             	cmpb   $0x30,(%edx)
40000ca0:	74 7e                	je     40000d20 <strtol+0xd0>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
40000ca2:	83 fb 01             	cmp    $0x1,%ebx
40000ca5:	19 db                	sbb    %ebx,%ebx
40000ca7:	83 e3 fa             	and    $0xfffffffa,%ebx
40000caa:	83 c3 10             	add    $0x10,%ebx
40000cad:	89 5d 10             	mov    %ebx,0x10(%ebp)
40000cb0:	31 c9                	xor    %ecx,%ecx
40000cb2:	89 c7                	mov    %eax,%edi
40000cb4:	eb 13                	jmp    40000cc9 <strtol+0x79>
40000cb6:	66 90                	xchg   %ax,%ax
40000cb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000cbf:	00 
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
		s++, val = (val * base) + dig;
40000cc0:	0f af 4d 10          	imul   0x10(%ebp),%ecx
40000cc4:	83 c2 01             	add    $0x1,%edx
40000cc7:	01 f1                	add    %esi,%ecx
		if (*s >= '0' && *s <= '9')
40000cc9:	0f be 1a             	movsbl (%edx),%ebx
40000ccc:	8d 43 d0             	lea    -0x30(%ebx),%eax
			dig = *s - '0';
40000ccf:	8d 73 d0             	lea    -0x30(%ebx),%esi
		if (*s >= '0' && *s <= '9')
40000cd2:	3c 09                	cmp    $0x9,%al
40000cd4:	76 14                	jbe    40000cea <strtol+0x9a>
		else if (*s >= 'a' && *s <= 'z')
40000cd6:	8d 43 9f             	lea    -0x61(%ebx),%eax
			dig = *s - 'a' + 10;
40000cd9:	8d 73 a9             	lea    -0x57(%ebx),%esi
		else if (*s >= 'a' && *s <= 'z')
40000cdc:	3c 19                	cmp    $0x19,%al
40000cde:	76 0a                	jbe    40000cea <strtol+0x9a>
		else if (*s >= 'A' && *s <= 'Z')
40000ce0:	8d 43 bf             	lea    -0x41(%ebx),%eax
40000ce3:	3c 19                	cmp    $0x19,%al
40000ce5:	77 08                	ja     40000cef <strtol+0x9f>
			dig = *s - 'A' + 10;
40000ce7:	8d 73 c9             	lea    -0x37(%ebx),%esi
		if (dig >= base)
40000cea:	3b 75 10             	cmp    0x10(%ebp),%esi
40000ced:	7c d1                	jl     40000cc0 <strtol+0x70>
		// we don't properly detect overflow!
	}

	if (endptr)
40000cef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000cf2:	89 f8                	mov    %edi,%eax
40000cf4:	85 db                	test   %ebx,%ebx
40000cf6:	74 05                	je     40000cfd <strtol+0xad>
		*endptr = (char *) s;
40000cf8:	8b 7d 0c             	mov    0xc(%ebp),%edi
40000cfb:	89 17                	mov    %edx,(%edi)
	return (neg ? -val : val);
40000cfd:	89 ca                	mov    %ecx,%edx
}
40000cff:	5b                   	pop    %ebx
40000d00:	5e                   	pop    %esi
	return (neg ? -val : val);
40000d01:	f7 da                	neg    %edx
40000d03:	85 c0                	test   %eax,%eax
}
40000d05:	5f                   	pop    %edi
40000d06:	5d                   	pop    %ebp
	return (neg ? -val : val);
40000d07:	0f 45 ca             	cmovne %edx,%ecx
}
40000d0a:	89 c8                	mov    %ecx,%eax
40000d0c:	c3                   	ret
40000d0d:	8d 76 00             	lea    0x0(%esi),%esi
		s++;
40000d10:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
40000d13:	31 c0                	xor    %eax,%eax
40000d15:	e9 7b ff ff ff       	jmp    40000c95 <strtol+0x45>
40000d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000d20:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
40000d24:	74 1b                	je     40000d41 <strtol+0xf1>
	else if (base == 0 && s[0] == '0')
40000d26:	85 db                	test   %ebx,%ebx
40000d28:	74 0a                	je     40000d34 <strtol+0xe4>
40000d2a:	bb 10 00 00 00       	mov    $0x10,%ebx
40000d2f:	e9 79 ff ff ff       	jmp    40000cad <strtol+0x5d>
		s++, base = 8;
40000d34:	83 c2 01             	add    $0x1,%edx
40000d37:	bb 08 00 00 00       	mov    $0x8,%ebx
40000d3c:	e9 6c ff ff ff       	jmp    40000cad <strtol+0x5d>
		s += 2, base = 16;
40000d41:	83 c2 02             	add    $0x2,%edx
40000d44:	bb 10 00 00 00       	mov    $0x10,%ebx
40000d49:	e9 5f ff ff ff       	jmp    40000cad <strtol+0x5d>
40000d4e:	66 90                	xchg   %ax,%ax

40000d50 <memset>:

void *
memset(void *v, int c, size_t n)
{
40000d50:	55                   	push   %ebp
40000d51:	89 e5                	mov    %esp,%ebp
40000d53:	57                   	push   %edi
40000d54:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000d57:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000d5a:	85 c9                	test   %ecx,%ecx
40000d5c:	74 1a                	je     40000d78 <memset+0x28>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
40000d5e:	89 d0                	mov    %edx,%eax
40000d60:	09 c8                	or     %ecx,%eax
40000d62:	a8 03                	test   $0x3,%al
40000d64:	75 1a                	jne    40000d80 <memset+0x30>
		c &= 0xFF;
40000d66:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
40000d6a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000d6d:	89 d7                	mov    %edx,%edi
40000d6f:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
40000d75:	fc                   	cld
40000d76:	f3 ab                	rep stos %eax,%es:(%edi)
	} else
		asm volatile("cld; rep stosb\n"
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
}
40000d78:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000d7b:	89 d0                	mov    %edx,%eax
40000d7d:	c9                   	leave
40000d7e:	c3                   	ret
40000d7f:	90                   	nop
		asm volatile("cld; rep stosb\n"
40000d80:	8b 45 0c             	mov    0xc(%ebp),%eax
40000d83:	89 d7                	mov    %edx,%edi
40000d85:	fc                   	cld
40000d86:	f3 aa                	rep stos %al,%es:(%edi)
}
40000d88:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000d8b:	89 d0                	mov    %edx,%eax
40000d8d:	c9                   	leave
40000d8e:	c3                   	ret
40000d8f:	90                   	nop

40000d90 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
40000d90:	55                   	push   %ebp
40000d91:	89 e5                	mov    %esp,%ebp
40000d93:	57                   	push   %edi
40000d94:	8b 45 08             	mov    0x8(%ebp),%eax
40000d97:	8b 55 0c             	mov    0xc(%ebp),%edx
40000d9a:	56                   	push   %esi
40000d9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000d9e:	53                   	push   %ebx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
40000d9f:	39 c2                	cmp    %eax,%edx
40000da1:	73 2d                	jae    40000dd0 <memmove+0x40>
40000da3:	8d 1c 0a             	lea    (%edx,%ecx,1),%ebx
40000da6:	39 d8                	cmp    %ebx,%eax
40000da8:	73 26                	jae    40000dd0 <memmove+0x40>
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000daa:	8d 14 08             	lea    (%eax,%ecx,1),%edx
40000dad:	09 ca                	or     %ecx,%edx
40000daf:	09 da                	or     %ebx,%edx
40000db1:	83 e2 03             	and    $0x3,%edx
40000db4:	74 4a                	je     40000e00 <memmove+0x70>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
				     : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
40000db6:	8d 7c 08 ff          	lea    -0x1(%eax,%ecx,1),%edi
40000dba:	8d 73 ff             	lea    -0x1(%ebx),%esi
40000dbd:	fd                   	std
40000dbe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				     :: "D" (d-1), "S" (s-1), "c" (n)
				     : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
40000dc0:	fc                   	cld
			asm volatile("cld; rep movsb\n"
				     :: "D" (d), "S" (s), "c" (n)
				     : "cc", "memory");
	}
	return dst;
}
40000dc1:	5b                   	pop    %ebx
40000dc2:	5e                   	pop    %esi
40000dc3:	5f                   	pop    %edi
40000dc4:	5d                   	pop    %ebp
40000dc5:	c3                   	ret
40000dc6:	66 90                	xchg   %ax,%ax
40000dc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000dcf:	00 
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000dd0:	89 c3                	mov    %eax,%ebx
40000dd2:	09 cb                	or     %ecx,%ebx
40000dd4:	09 d3                	or     %edx,%ebx
40000dd6:	83 e3 03             	and    $0x3,%ebx
40000dd9:	74 15                	je     40000df0 <memmove+0x60>
			asm volatile("cld; rep movsb\n"
40000ddb:	89 c7                	mov    %eax,%edi
40000ddd:	89 d6                	mov    %edx,%esi
40000ddf:	fc                   	cld
40000de0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000de2:	5b                   	pop    %ebx
40000de3:	5e                   	pop    %esi
40000de4:	5f                   	pop    %edi
40000de5:	5d                   	pop    %ebp
40000de6:	c3                   	ret
40000de7:	90                   	nop
40000de8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000def:	00 
				     :: "D" (d), "S" (s), "c" (n/4)
40000df0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
40000df3:	89 c7                	mov    %eax,%edi
40000df5:	89 d6                	mov    %edx,%esi
40000df7:	fc                   	cld
40000df8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000dfa:	eb e6                	jmp    40000de2 <memmove+0x52>
40000dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			asm volatile("std; rep movsl\n"
40000e00:	8d 7c 08 fc          	lea    -0x4(%eax,%ecx,1),%edi
40000e04:	8d 73 fc             	lea    -0x4(%ebx),%esi
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
40000e07:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
40000e0a:	fd                   	std
40000e0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000e0d:	eb b1                	jmp    40000dc0 <memmove+0x30>
40000e0f:	90                   	nop

40000e10 <memcpy>:

void *
memcpy(void *dst, const void *src, size_t n)
{
	return memmove(dst, src, n);
40000e10:	e9 7b ff ff ff       	jmp    40000d90 <memmove>
40000e15:	8d 76 00             	lea    0x0(%esi),%esi
40000e18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e1f:	00 

40000e20 <memcmp>:
}

int
memcmp(const void *v1, const void *v2, size_t n)
{
40000e20:	55                   	push   %ebp
40000e21:	89 e5                	mov    %esp,%ebp
40000e23:	56                   	push   %esi
40000e24:	8b 75 10             	mov    0x10(%ebp),%esi
40000e27:	8b 45 08             	mov    0x8(%ebp),%eax
40000e2a:	53                   	push   %ebx
40000e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
40000e2e:	85 f6                	test   %esi,%esi
40000e30:	74 2e                	je     40000e60 <memcmp+0x40>
40000e32:	01 c6                	add    %eax,%esi
40000e34:	eb 14                	jmp    40000e4a <memcmp+0x2a>
40000e36:	66 90                	xchg   %ax,%ax
40000e38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e3f:	00 
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
40000e40:	83 c0 01             	add    $0x1,%eax
40000e43:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
40000e46:	39 f0                	cmp    %esi,%eax
40000e48:	74 16                	je     40000e60 <memcmp+0x40>
		if (*s1 != *s2)
40000e4a:	0f b6 08             	movzbl (%eax),%ecx
40000e4d:	0f b6 1a             	movzbl (%edx),%ebx
40000e50:	38 d9                	cmp    %bl,%cl
40000e52:	74 ec                	je     40000e40 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
40000e54:	0f b6 c1             	movzbl %cl,%eax
40000e57:	29 d8                	sub    %ebx,%eax
	}

	return 0;
}
40000e59:	5b                   	pop    %ebx
40000e5a:	5e                   	pop    %esi
40000e5b:	5d                   	pop    %ebp
40000e5c:	c3                   	ret
40000e5d:	8d 76 00             	lea    0x0(%esi),%esi
40000e60:	5b                   	pop    %ebx
	return 0;
40000e61:	31 c0                	xor    %eax,%eax
}
40000e63:	5e                   	pop    %esi
40000e64:	5d                   	pop    %ebp
40000e65:	c3                   	ret
40000e66:	66 90                	xchg   %ax,%ax
40000e68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e6f:	00 

40000e70 <memchr>:

void *
memchr(const void *s, int c, size_t n)
{
40000e70:	55                   	push   %ebp
40000e71:	89 e5                	mov    %esp,%ebp
40000e73:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
40000e76:	8b 55 10             	mov    0x10(%ebp),%edx
40000e79:	01 c2                	add    %eax,%edx
	for (; s < ends; s++)
40000e7b:	39 d0                	cmp    %edx,%eax
40000e7d:	73 21                	jae    40000ea0 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000e7f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
40000e83:	eb 12                	jmp    40000e97 <memchr+0x27>
40000e85:	8d 76 00             	lea    0x0(%esi),%esi
40000e88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e8f:	00 
	for (; s < ends; s++)
40000e90:	83 c0 01             	add    $0x1,%eax
40000e93:	39 c2                	cmp    %eax,%edx
40000e95:	74 09                	je     40000ea0 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000e97:	38 08                	cmp    %cl,(%eax)
40000e99:	75 f5                	jne    40000e90 <memchr+0x20>
			return (void *) s;
	return NULL;
}
40000e9b:	5d                   	pop    %ebp
40000e9c:	c3                   	ret
40000e9d:	8d 76 00             	lea    0x0(%esi),%esi
	return NULL;
40000ea0:	31 c0                	xor    %eax,%eax
}
40000ea2:	5d                   	pop    %ebp
40000ea3:	c3                   	ret
40000ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000ea8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000eaf:	00 

40000eb0 <memzero>:

void *
memzero(void *v, size_t n)
{
40000eb0:	55                   	push   %ebp
40000eb1:	89 e5                	mov    %esp,%ebp
40000eb3:	57                   	push   %edi
40000eb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000eb7:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000eba:	85 c9                	test   %ecx,%ecx
40000ebc:	74 11                	je     40000ecf <memzero+0x1f>
	if ((int)v%4 == 0 && n%4 == 0) {
40000ebe:	89 d0                	mov    %edx,%eax
40000ec0:	09 c8                	or     %ecx,%eax
40000ec2:	83 e0 03             	and    $0x3,%eax
40000ec5:	75 19                	jne    40000ee0 <memzero+0x30>
			     :: "D" (v), "a" (c), "c" (n/4)
40000ec7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000eca:	89 d7                	mov    %edx,%edi
40000ecc:	fc                   	cld
40000ecd:	f3 ab                	rep stos %eax,%es:(%edi)
	return memset(v, 0, n);
}
40000ecf:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000ed2:	89 d0                	mov    %edx,%eax
40000ed4:	c9                   	leave
40000ed5:	c3                   	ret
40000ed6:	66 90                	xchg   %ax,%ax
40000ed8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000edf:	00 
		asm volatile("cld; rep stosb\n"
40000ee0:	89 d7                	mov    %edx,%edi
40000ee2:	31 c0                	xor    %eax,%eax
40000ee4:	fc                   	cld
40000ee5:	f3 aa                	rep stos %al,%es:(%edi)
}
40000ee7:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000eea:	89 d0                	mov    %edx,%eax
40000eec:	c9                   	leave
40000eed:	c3                   	ret
40000eee:	66 90                	xchg   %ax,%ax

40000ef0 <sigaction>:
#include <signal.h>
#include <syscall.h>

int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
40000ef0:	55                   	push   %ebp

static gcc_inline int
sys_sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
	int errno;
	asm volatile ("int %1"
40000ef1:	b8 1a 00 00 00       	mov    $0x1a,%eax
40000ef6:	89 e5                	mov    %esp,%ebp
40000ef8:	53                   	push   %ebx
40000ef9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000efc:	8b 55 10             	mov    0x10(%ebp),%edx
40000eff:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000f02:	cd 30                	int    $0x30
		        "a" (SYS_sigaction),
		        "b" (signum),
		        "c" (act),
		        "d" (oldact)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000f04:	f7 d8                	neg    %eax
    return sys_sigaction(signum, act, oldact);
}
40000f06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000f09:	c9                   	leave
40000f0a:	19 c0                	sbb    %eax,%eax
40000f0c:	c3                   	ret
40000f0d:	8d 76 00             	lea    0x0(%esi),%esi

40000f10 <kill>:

int kill(int pid, int signum)
{
40000f10:	55                   	push   %ebp

static gcc_inline int
sys_kill(int pid, int signum)
{
	int errno;
	asm volatile ("int %1"
40000f11:	b8 1b 00 00 00       	mov    $0x1b,%eax
40000f16:	89 e5                	mov    %esp,%ebp
40000f18:	53                   	push   %ebx
40000f19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000f1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000f1f:	cd 30                	int    $0x30
		      : "i" (T_SYSCALL),
		        "a" (SYS_kill),
		        "b" (pid),
		        "c" (signum)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000f21:	f7 d8                	neg    %eax
    return sys_kill(pid, signum);
}
40000f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000f26:	c9                   	leave
40000f27:	19 c0                	sbb    %eax,%eax
40000f29:	c3                   	ret
40000f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000f30 <pause>:

static gcc_inline int
sys_pause(void)
{
	int errno;
	asm volatile ("int %1"
40000f30:	b8 1c 00 00 00       	mov    $0x1c,%eax
40000f35:	cd 30                	int    $0x30
		      : "=a" (errno)
		      : "i" (T_SYSCALL),
		        "a" (SYS_pause)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000f37:	f7 d8                	neg    %eax
40000f39:	19 c0                	sbb    %eax,%eax

int pause(void)
{
    return sys_pause();
}
40000f3b:	c3                   	ret
40000f3c:	66 90                	xchg   %ax,%ax
40000f3e:	66 90                	xchg   %ax,%ax

40000f40 <__udivdi3>:
40000f40:	55                   	push   %ebp
40000f41:	89 e5                	mov    %esp,%ebp
40000f43:	57                   	push   %edi
40000f44:	56                   	push   %esi
40000f45:	53                   	push   %ebx
40000f46:	83 ec 1c             	sub    $0x1c,%esp
40000f49:	8b 75 08             	mov    0x8(%ebp),%esi
40000f4c:	8b 45 14             	mov    0x14(%ebp),%eax
40000f4f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000f52:	8b 7d 10             	mov    0x10(%ebp),%edi
40000f55:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40000f58:	85 c0                	test   %eax,%eax
40000f5a:	75 1c                	jne    40000f78 <__udivdi3+0x38>
40000f5c:	39 fb                	cmp    %edi,%ebx
40000f5e:	73 50                	jae    40000fb0 <__udivdi3+0x70>
40000f60:	89 f0                	mov    %esi,%eax
40000f62:	31 f6                	xor    %esi,%esi
40000f64:	89 da                	mov    %ebx,%edx
40000f66:	f7 f7                	div    %edi
40000f68:	89 f2                	mov    %esi,%edx
40000f6a:	83 c4 1c             	add    $0x1c,%esp
40000f6d:	5b                   	pop    %ebx
40000f6e:	5e                   	pop    %esi
40000f6f:	5f                   	pop    %edi
40000f70:	5d                   	pop    %ebp
40000f71:	c3                   	ret
40000f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000f78:	39 c3                	cmp    %eax,%ebx
40000f7a:	73 14                	jae    40000f90 <__udivdi3+0x50>
40000f7c:	31 f6                	xor    %esi,%esi
40000f7e:	31 c0                	xor    %eax,%eax
40000f80:	89 f2                	mov    %esi,%edx
40000f82:	83 c4 1c             	add    $0x1c,%esp
40000f85:	5b                   	pop    %ebx
40000f86:	5e                   	pop    %esi
40000f87:	5f                   	pop    %edi
40000f88:	5d                   	pop    %ebp
40000f89:	c3                   	ret
40000f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000f90:	0f bd f0             	bsr    %eax,%esi
40000f93:	83 f6 1f             	xor    $0x1f,%esi
40000f96:	75 48                	jne    40000fe0 <__udivdi3+0xa0>
40000f98:	39 d8                	cmp    %ebx,%eax
40000f9a:	72 07                	jb     40000fa3 <__udivdi3+0x63>
40000f9c:	31 c0                	xor    %eax,%eax
40000f9e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
40000fa1:	72 dd                	jb     40000f80 <__udivdi3+0x40>
40000fa3:	b8 01 00 00 00       	mov    $0x1,%eax
40000fa8:	eb d6                	jmp    40000f80 <__udivdi3+0x40>
40000faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000fb0:	89 f9                	mov    %edi,%ecx
40000fb2:	85 ff                	test   %edi,%edi
40000fb4:	75 0b                	jne    40000fc1 <__udivdi3+0x81>
40000fb6:	b8 01 00 00 00       	mov    $0x1,%eax
40000fbb:	31 d2                	xor    %edx,%edx
40000fbd:	f7 f7                	div    %edi
40000fbf:	89 c1                	mov    %eax,%ecx
40000fc1:	31 d2                	xor    %edx,%edx
40000fc3:	89 d8                	mov    %ebx,%eax
40000fc5:	f7 f1                	div    %ecx
40000fc7:	89 c6                	mov    %eax,%esi
40000fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000fcc:	f7 f1                	div    %ecx
40000fce:	89 f2                	mov    %esi,%edx
40000fd0:	83 c4 1c             	add    $0x1c,%esp
40000fd3:	5b                   	pop    %ebx
40000fd4:	5e                   	pop    %esi
40000fd5:	5f                   	pop    %edi
40000fd6:	5d                   	pop    %ebp
40000fd7:	c3                   	ret
40000fd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000fdf:	00 
40000fe0:	89 f1                	mov    %esi,%ecx
40000fe2:	ba 20 00 00 00       	mov    $0x20,%edx
40000fe7:	29 f2                	sub    %esi,%edx
40000fe9:	d3 e0                	shl    %cl,%eax
40000feb:	89 45 e0             	mov    %eax,-0x20(%ebp)
40000fee:	89 d1                	mov    %edx,%ecx
40000ff0:	89 f8                	mov    %edi,%eax
40000ff2:	d3 e8                	shr    %cl,%eax
40000ff4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
40000ff7:	09 c1                	or     %eax,%ecx
40000ff9:	89 d8                	mov    %ebx,%eax
40000ffb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
40000ffe:	89 f1                	mov    %esi,%ecx
40001000:	d3 e7                	shl    %cl,%edi
40001002:	89 d1                	mov    %edx,%ecx
40001004:	d3 e8                	shr    %cl,%eax
40001006:	89 f1                	mov    %esi,%ecx
40001008:	89 7d dc             	mov    %edi,-0x24(%ebp)
4000100b:	89 45 d8             	mov    %eax,-0x28(%ebp)
4000100e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40001011:	d3 e3                	shl    %cl,%ebx
40001013:	89 d1                	mov    %edx,%ecx
40001015:	8b 55 d8             	mov    -0x28(%ebp),%edx
40001018:	d3 e8                	shr    %cl,%eax
4000101a:	09 d8                	or     %ebx,%eax
4000101c:	f7 75 e0             	divl   -0x20(%ebp)
4000101f:	89 d3                	mov    %edx,%ebx
40001021:	89 c7                	mov    %eax,%edi
40001023:	f7 65 dc             	mull   -0x24(%ebp)
40001026:	89 45 e0             	mov    %eax,-0x20(%ebp)
40001029:	39 d3                	cmp    %edx,%ebx
4000102b:	72 23                	jb     40001050 <__udivdi3+0x110>
4000102d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40001030:	89 f1                	mov    %esi,%ecx
40001032:	d3 e0                	shl    %cl,%eax
40001034:	3b 45 e0             	cmp    -0x20(%ebp),%eax
40001037:	73 04                	jae    4000103d <__udivdi3+0xfd>
40001039:	39 d3                	cmp    %edx,%ebx
4000103b:	74 13                	je     40001050 <__udivdi3+0x110>
4000103d:	89 f8                	mov    %edi,%eax
4000103f:	31 f6                	xor    %esi,%esi
40001041:	e9 3a ff ff ff       	jmp    40000f80 <__udivdi3+0x40>
40001046:	66 90                	xchg   %ax,%ax
40001048:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000104f:	00 
40001050:	8d 47 ff             	lea    -0x1(%edi),%eax
40001053:	31 f6                	xor    %esi,%esi
40001055:	e9 26 ff ff ff       	jmp    40000f80 <__udivdi3+0x40>
4000105a:	66 90                	xchg   %ax,%ax
4000105c:	66 90                	xchg   %ax,%ax
4000105e:	66 90                	xchg   %ax,%ax

40001060 <__umoddi3>:
40001060:	55                   	push   %ebp
40001061:	89 e5                	mov    %esp,%ebp
40001063:	57                   	push   %edi
40001064:	56                   	push   %esi
40001065:	53                   	push   %ebx
40001066:	83 ec 2c             	sub    $0x2c,%esp
40001069:	8b 5d 0c             	mov    0xc(%ebp),%ebx
4000106c:	8b 45 14             	mov    0x14(%ebp),%eax
4000106f:	8b 75 08             	mov    0x8(%ebp),%esi
40001072:	8b 7d 10             	mov    0x10(%ebp),%edi
40001075:	89 da                	mov    %ebx,%edx
40001077:	85 c0                	test   %eax,%eax
40001079:	75 15                	jne    40001090 <__umoddi3+0x30>
4000107b:	39 fb                	cmp    %edi,%ebx
4000107d:	73 51                	jae    400010d0 <__umoddi3+0x70>
4000107f:	89 f0                	mov    %esi,%eax
40001081:	f7 f7                	div    %edi
40001083:	89 d0                	mov    %edx,%eax
40001085:	31 d2                	xor    %edx,%edx
40001087:	83 c4 2c             	add    $0x2c,%esp
4000108a:	5b                   	pop    %ebx
4000108b:	5e                   	pop    %esi
4000108c:	5f                   	pop    %edi
4000108d:	5d                   	pop    %ebp
4000108e:	c3                   	ret
4000108f:	90                   	nop
40001090:	89 75 e0             	mov    %esi,-0x20(%ebp)
40001093:	39 c3                	cmp    %eax,%ebx
40001095:	73 11                	jae    400010a8 <__umoddi3+0x48>
40001097:	89 f0                	mov    %esi,%eax
40001099:	83 c4 2c             	add    $0x2c,%esp
4000109c:	5b                   	pop    %ebx
4000109d:	5e                   	pop    %esi
4000109e:	5f                   	pop    %edi
4000109f:	5d                   	pop    %ebp
400010a0:	c3                   	ret
400010a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400010a8:	0f bd c8             	bsr    %eax,%ecx
400010ab:	83 f1 1f             	xor    $0x1f,%ecx
400010ae:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
400010b1:	75 3d                	jne    400010f0 <__umoddi3+0x90>
400010b3:	39 d8                	cmp    %ebx,%eax
400010b5:	0f 82 cd 00 00 00    	jb     40001188 <__umoddi3+0x128>
400010bb:	39 fe                	cmp    %edi,%esi
400010bd:	0f 83 c5 00 00 00    	jae    40001188 <__umoddi3+0x128>
400010c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
400010c6:	83 c4 2c             	add    $0x2c,%esp
400010c9:	5b                   	pop    %ebx
400010ca:	5e                   	pop    %esi
400010cb:	5f                   	pop    %edi
400010cc:	5d                   	pop    %ebp
400010cd:	c3                   	ret
400010ce:	66 90                	xchg   %ax,%ax
400010d0:	89 f9                	mov    %edi,%ecx
400010d2:	85 ff                	test   %edi,%edi
400010d4:	75 0b                	jne    400010e1 <__umoddi3+0x81>
400010d6:	b8 01 00 00 00       	mov    $0x1,%eax
400010db:	31 d2                	xor    %edx,%edx
400010dd:	f7 f7                	div    %edi
400010df:	89 c1                	mov    %eax,%ecx
400010e1:	89 d8                	mov    %ebx,%eax
400010e3:	31 d2                	xor    %edx,%edx
400010e5:	f7 f1                	div    %ecx
400010e7:	89 f0                	mov    %esi,%eax
400010e9:	f7 f1                	div    %ecx
400010eb:	eb 96                	jmp    40001083 <__umoddi3+0x23>
400010ed:	8d 76 00             	lea    0x0(%esi),%esi
400010f0:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400010f4:	ba 20 00 00 00       	mov    $0x20,%edx
400010f9:	2b 55 e4             	sub    -0x1c(%ebp),%edx
400010fc:	89 55 e0             	mov    %edx,-0x20(%ebp)
400010ff:	d3 e0                	shl    %cl,%eax
40001101:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
40001105:	89 45 dc             	mov    %eax,-0x24(%ebp)
40001108:	89 f8                	mov    %edi,%eax
4000110a:	8b 55 dc             	mov    -0x24(%ebp),%edx
4000110d:	d3 e8                	shr    %cl,%eax
4000110f:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001113:	09 c2                	or     %eax,%edx
40001115:	d3 e7                	shl    %cl,%edi
40001117:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
4000111b:	89 55 dc             	mov    %edx,-0x24(%ebp)
4000111e:	89 da                	mov    %ebx,%edx
40001120:	89 7d d8             	mov    %edi,-0x28(%ebp)
40001123:	89 f7                	mov    %esi,%edi
40001125:	d3 ea                	shr    %cl,%edx
40001127:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
4000112b:	d3 e3                	shl    %cl,%ebx
4000112d:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
40001131:	d3 ef                	shr    %cl,%edi
40001133:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001137:	89 f8                	mov    %edi,%eax
40001139:	d3 e6                	shl    %cl,%esi
4000113b:	09 d8                	or     %ebx,%eax
4000113d:	f7 75 dc             	divl   -0x24(%ebp)
40001140:	89 d3                	mov    %edx,%ebx
40001142:	89 75 d4             	mov    %esi,-0x2c(%ebp)
40001145:	89 f7                	mov    %esi,%edi
40001147:	f7 65 d8             	mull   -0x28(%ebp)
4000114a:	89 c6                	mov    %eax,%esi
4000114c:	89 d1                	mov    %edx,%ecx
4000114e:	39 d3                	cmp    %edx,%ebx
40001150:	72 06                	jb     40001158 <__umoddi3+0xf8>
40001152:	75 0e                	jne    40001162 <__umoddi3+0x102>
40001154:	39 c7                	cmp    %eax,%edi
40001156:	73 0a                	jae    40001162 <__umoddi3+0x102>
40001158:	2b 45 d8             	sub    -0x28(%ebp),%eax
4000115b:	1b 55 dc             	sbb    -0x24(%ebp),%edx
4000115e:	89 d1                	mov    %edx,%ecx
40001160:	89 c6                	mov    %eax,%esi
40001162:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40001165:	29 f0                	sub    %esi,%eax
40001167:	19 cb                	sbb    %ecx,%ebx
40001169:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
4000116d:	89 da                	mov    %ebx,%edx
4000116f:	d3 e2                	shl    %cl,%edx
40001171:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001175:	d3 e8                	shr    %cl,%eax
40001177:	d3 eb                	shr    %cl,%ebx
40001179:	09 d0                	or     %edx,%eax
4000117b:	89 da                	mov    %ebx,%edx
4000117d:	83 c4 2c             	add    $0x2c,%esp
40001180:	5b                   	pop    %ebx
40001181:	5e                   	pop    %esi
40001182:	5f                   	pop    %edi
40001183:	5d                   	pop    %ebp
40001184:	c3                   	ret
40001185:	8d 76 00             	lea    0x0(%esi),%esi
40001188:	89 da                	mov    %ebx,%edx
4000118a:	29 fe                	sub    %edi,%esi
4000118c:	19 c2                	sbb    %eax,%edx
4000118e:	89 75 e0             	mov    %esi,-0x20(%ebp)
40001191:	e9 2d ff ff ff       	jmp    400010c3 <__umoddi3+0x63>
