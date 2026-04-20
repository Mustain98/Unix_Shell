
obj/user/echo/echo:     file format elf32-i386


Disassembly of section .text:

40000000 <main>:
#include <stdio.h>
#include <syscall.h>

int main(int argc, char **argv)
{
40000000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
40000004:	83 e4 f0             	and    $0xfffffff0,%esp
40000007:	ff 71 fc             	push   -0x4(%ecx)
4000000a:	55                   	push   %ebp
4000000b:	89 e5                	mov    %esp,%ebp
4000000d:	57                   	push   %edi
4000000e:	56                   	push   %esi
4000000f:	53                   	push   %ebx
40000010:	51                   	push   %ecx
40000011:	83 ec 08             	sub    $0x8,%esp
40000014:	8b 31                	mov    (%ecx),%esi
40000016:	8b 79 04             	mov    0x4(%ecx),%edi
    int i;

    for (i = 1; i < argc; i++) {
40000019:	83 fe 01             	cmp    $0x1,%esi
4000001c:	7e 34                	jle    40000052 <main+0x52>
4000001e:	bb 01 00 00 00       	mov    $0x1,%ebx
40000023:	eb 13                	jmp    40000038 <main+0x38>
40000025:	8d 76 00             	lea    0x0(%esi),%esi
        if (i > 1) {
            printf(" ");
40000028:	83 ec 0c             	sub    $0xc,%esp
4000002b:	68 02 12 00 40       	push   $0x40001202
40000030:	e8 8b 02 00 00       	call   400002c0 <printf>
40000035:	83 c4 10             	add    $0x10,%esp
        }
        printf("%s", argv[i]);
40000038:	83 ec 08             	sub    $0x8,%esp
4000003b:	ff 34 9f             	push   (%edi,%ebx,4)
    for (i = 1; i < argc; i++) {
4000003e:	83 c3 01             	add    $0x1,%ebx
        printf("%s", argv[i]);
40000041:	68 34 12 00 40       	push   $0x40001234
40000046:	e8 75 02 00 00       	call   400002c0 <printf>
    for (i = 1; i < argc; i++) {
4000004b:	83 c4 10             	add    $0x10,%esp
4000004e:	39 de                	cmp    %ebx,%esi
40000050:	75 d6                	jne    40000028 <main+0x28>
    }
    printf("\n");
40000052:	83 ec 0c             	sub    $0xc,%esp
40000055:	68 37 12 00 40       	push   $0x40001237
4000005a:	e8 61 02 00 00       	call   400002c0 <printf>
    
    return 0;
}
4000005f:	8d 65 f0             	lea    -0x10(%ebp),%esp
40000062:	31 c0                	xor    %eax,%eax
40000064:	59                   	pop    %ecx
40000065:	5b                   	pop    %ebx
40000066:	5e                   	pop    %esi
40000067:	5f                   	pop    %edi
40000068:	5d                   	pop    %ebp
40000069:	8d 61 fc             	lea    -0x4(%ecx),%esp
4000006c:	c3                   	ret

4000006d <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary/
	 */
	testl	$0x0fffffff, %esp
4000006d:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
40000073:	75 04                	jne    40000079 <args_exist>

40000075 <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
40000075:	6a 00                	push   $0x0
	pushl	$0
40000077:	6a 00                	push   $0x0

40000079 <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
40000079:	e8 82 ff ff ff       	call   40000000 <main>

	/* When returning, save return value */
	pushl	%eax
4000007e:	50                   	push   %eax

	/* Syscall SYS_exit (30) */
	movl	$30, %eax
4000007f:	b8 1e 00 00 00       	mov    $0x1e,%eax
	int	$48
40000084:	cd 30                	int    $0x30

40000086 <spin>:

spin:
	call	yield
40000086:	e8 25 09 00 00       	call   400009b0 <yield>
	jmp	spin
4000008b:	eb f9                	jmp    40000086 <spin>
4000008d:	66 90                	xchg   %ax,%ax
4000008f:	90                   	nop

40000090 <debug>:
#include <stdarg.h>
#include <stdio.h>

void
debug(const char *file, int line, const char *fmt, ...)
{
40000090:	55                   	push   %ebp
40000091:	89 e5                	mov    %esp,%ebp
40000093:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[D] %s:%d: ", file, line);
40000096:	ff 75 0c             	push   0xc(%ebp)
40000099:	ff 75 08             	push   0x8(%ebp)
4000009c:	68 f8 11 00 40       	push   $0x400011f8
400000a1:	e8 1a 02 00 00       	call   400002c0 <printf>
	vcprintf(fmt, ap);
400000a6:	58                   	pop    %eax
400000a7:	8d 45 14             	lea    0x14(%ebp),%eax
400000aa:	5a                   	pop    %edx
400000ab:	50                   	push   %eax
400000ac:	ff 75 10             	push   0x10(%ebp)
400000af:	e8 ac 01 00 00       	call   40000260 <vcprintf>
	va_end(ap);
}
400000b4:	83 c4 10             	add    $0x10,%esp
400000b7:	c9                   	leave
400000b8:	c3                   	ret
400000b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400000c0 <warn>:

void
warn(const char *file, int line, const char *fmt, ...)
{
400000c0:	55                   	push   %ebp
400000c1:	89 e5                	mov    %esp,%ebp
400000c3:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[W] %s:%d: ", file, line);
400000c6:	ff 75 0c             	push   0xc(%ebp)
400000c9:	ff 75 08             	push   0x8(%ebp)
400000cc:	68 04 12 00 40       	push   $0x40001204
400000d1:	e8 ea 01 00 00       	call   400002c0 <printf>
	vcprintf(fmt, ap);
400000d6:	58                   	pop    %eax
400000d7:	8d 45 14             	lea    0x14(%ebp),%eax
400000da:	5a                   	pop    %edx
400000db:	50                   	push   %eax
400000dc:	ff 75 10             	push   0x10(%ebp)
400000df:	e8 7c 01 00 00       	call   40000260 <vcprintf>
	va_end(ap);
}
400000e4:	83 c4 10             	add    $0x10,%esp
400000e7:	c9                   	leave
400000e8:	c3                   	ret
400000e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400000f0 <panic>:

void
panic(const char *file, int line, const char *fmt, ...)
{
400000f0:	55                   	push   %ebp
400000f1:	89 e5                	mov    %esp,%ebp
400000f3:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[P] %s:%d: ", file, line);
400000f6:	ff 75 0c             	push   0xc(%ebp)
400000f9:	ff 75 08             	push   0x8(%ebp)
400000fc:	68 10 12 00 40       	push   $0x40001210
40000101:	e8 ba 01 00 00       	call   400002c0 <printf>
	vcprintf(fmt, ap);
40000106:	58                   	pop    %eax
40000107:	8d 45 14             	lea    0x14(%ebp),%eax
4000010a:	5a                   	pop    %edx
4000010b:	50                   	push   %eax
4000010c:	ff 75 10             	push   0x10(%ebp)
4000010f:	e8 4c 01 00 00       	call   40000260 <vcprintf>
40000114:	83 c4 10             	add    $0x10,%esp
40000117:	90                   	nop
40000118:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000011f:	00 
	va_end(ap);

	while (1)
		yield();
40000120:	e8 8b 08 00 00       	call   400009b0 <yield>
	while (1)
40000125:	eb f9                	jmp    40000120 <panic+0x30>
40000127:	66 90                	xchg   %ax,%ax
40000129:	66 90                	xchg   %ax,%ax
4000012b:	66 90                	xchg   %ax,%ax
4000012d:	66 90                	xchg   %ax,%ax
4000012f:	66 90                	xchg   %ax,%ax
40000131:	66 90                	xchg   %ax,%ax
40000133:	66 90                	xchg   %ax,%ax
40000135:	66 90                	xchg   %ax,%ax
40000137:	66 90                	xchg   %ax,%ax
40000139:	66 90                	xchg   %ax,%ax
4000013b:	66 90                	xchg   %ax,%ax
4000013d:	66 90                	xchg   %ax,%ax
4000013f:	90                   	nop

40000140 <atoi>:
#include <stdlib.h>

int
atoi(const char *buf, int *i)
{
40000140:	55                   	push   %ebp
40000141:	89 e5                	mov    %esp,%ebp
40000143:	57                   	push   %edi
40000144:	56                   	push   %esi
40000145:	53                   	push   %ebx
40000146:	83 ec 04             	sub    $0x4,%esp
40000149:	8b 75 08             	mov    0x8(%ebp),%esi
	int loc = 0;
	int numstart = 0;
	int acc = 0;
	int negative = 0;
	if (buf[loc] == '+')
4000014c:	0f b6 06             	movzbl (%esi),%eax
4000014f:	3c 2b                	cmp    $0x2b,%al
40000151:	0f 84 89 00 00 00    	je     400001e0 <atoi+0xa0>
		loc++;
	else if (buf[loc] == '-') {
40000157:	3c 2d                	cmp    $0x2d,%al
40000159:	74 65                	je     400001c0 <atoi+0x80>
		negative = 1;
		loc++;
	}
	numstart = loc;
	// no grab the numbers
	while ('0' <= buf[loc] && buf[loc] <= '9') {
4000015b:	8d 50 d0             	lea    -0x30(%eax),%edx
	int negative = 0;
4000015e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int loc = 0;
40000165:	31 ff                	xor    %edi,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000167:	80 fa 09             	cmp    $0x9,%dl
4000016a:	0f 87 8c 00 00 00    	ja     400001fc <atoi+0xbc>
	int loc = 0;
40000170:	89 f9                	mov    %edi,%ecx
	int acc = 0;
40000172:	31 d2                	xor    %edx,%edx
40000174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000178:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000017f:	00 
		acc = acc*10 + (buf[loc]-'0');
40000180:	83 e8 30             	sub    $0x30,%eax
40000183:	8d 14 92             	lea    (%edx,%edx,4),%edx
		loc++;
40000186:	83 c1 01             	add    $0x1,%ecx
		acc = acc*10 + (buf[loc]-'0');
40000189:	0f be c0             	movsbl %al,%eax
4000018c:	8d 14 50             	lea    (%eax,%edx,2),%edx
	while ('0' <= buf[loc] && buf[loc] <= '9') {
4000018f:	0f b6 04 0e          	movzbl (%esi,%ecx,1),%eax
40000193:	8d 58 d0             	lea    -0x30(%eax),%ebx
40000196:	80 fb 09             	cmp    $0x9,%bl
40000199:	76 e5                	jbe    40000180 <atoi+0x40>
	}
	if (numstart == loc) {
4000019b:	39 f9                	cmp    %edi,%ecx
4000019d:	74 5d                	je     400001fc <atoi+0xbc>
		// no numbers have actually been scanned
		return 0;
	}
	if (negative)
		acc = - acc;
4000019f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
400001a2:	89 d0                	mov    %edx,%eax
400001a4:	f7 d8                	neg    %eax
400001a6:	85 db                	test   %ebx,%ebx
400001a8:	0f 45 d0             	cmovne %eax,%edx
	*i = acc;
400001ab:	8b 45 0c             	mov    0xc(%ebp),%eax
400001ae:	89 10                	mov    %edx,(%eax)
	return loc;
}
400001b0:	83 c4 04             	add    $0x4,%esp
400001b3:	89 c8                	mov    %ecx,%eax
400001b5:	5b                   	pop    %ebx
400001b6:	5e                   	pop    %esi
400001b7:	5f                   	pop    %edi
400001b8:	5d                   	pop    %ebp
400001b9:	c3                   	ret
400001ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400001c0:	0f b6 46 01          	movzbl 0x1(%esi),%eax
400001c4:	8d 50 d0             	lea    -0x30(%eax),%edx
400001c7:	80 fa 09             	cmp    $0x9,%dl
400001ca:	77 30                	ja     400001fc <atoi+0xbc>
		negative = 1;
400001cc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		loc++;
400001d3:	bf 01 00 00 00       	mov    $0x1,%edi
400001d8:	eb 96                	jmp    40000170 <atoi+0x30>
400001da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400001e0:	0f b6 46 01          	movzbl 0x1(%esi),%eax
	int negative = 0;
400001e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		loc++;
400001eb:	bf 01 00 00 00       	mov    $0x1,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400001f0:	8d 50 d0             	lea    -0x30(%eax),%edx
400001f3:	80 fa 09             	cmp    $0x9,%dl
400001f6:	0f 86 74 ff ff ff    	jbe    40000170 <atoi+0x30>
}
400001fc:	83 c4 04             	add    $0x4,%esp
		return 0;
400001ff:	31 c9                	xor    %ecx,%ecx
}
40000201:	5b                   	pop    %ebx
40000202:	89 c8                	mov    %ecx,%eax
40000204:	5e                   	pop    %esi
40000205:	5f                   	pop    %edi
40000206:	5d                   	pop    %ebp
40000207:	c3                   	ret
40000208:	66 90                	xchg   %ax,%ax
4000020a:	66 90                	xchg   %ax,%ax
4000020c:	66 90                	xchg   %ax,%ax
4000020e:	66 90                	xchg   %ax,%ax

40000210 <putch>:
	char buf[MAX_BUF];
};

static void
putch(int ch, struct printbuf *b)
{
40000210:	55                   	push   %ebp
40000211:	89 e5                	mov    %esp,%ebp
40000213:	56                   	push   %esi
40000214:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
40000217:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
4000021a:	53                   	push   %ebx
	b->buf[b->idx++] = ch;
4000021b:	8b 06                	mov    (%esi),%eax
4000021d:	8d 50 01             	lea    0x1(%eax),%edx
40000220:	89 16                	mov    %edx,(%esi)
40000222:	88 4c 06 08          	mov    %cl,0x8(%esi,%eax,1)
	if (b->idx == MAX_BUF-1) {
40000226:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
4000022c:	75 1c                	jne    4000024a <putch+0x3a>
		b->buf[b->idx] = 0;
4000022e:	c6 86 07 10 00 00 00 	movb   $0x0,0x1007(%esi)
		puts(b->buf, b->idx);
40000235:	8d 4e 08             	lea    0x8(%esi),%ecx
sys_write(int fd, char *p, int n)
{
	int errno;
	size_t ret;

	asm volatile("int %2"
40000238:	b8 08 00 00 00       	mov    $0x8,%eax
4000023d:	bb 01 00 00 00       	mov    $0x1,%ebx
40000242:	cd 30                	int    $0x30
		b->idx = 0;
40000244:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	}
	b->cnt++;
4000024a:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
4000024e:	5b                   	pop    %ebx
4000024f:	5e                   	pop    %esi
40000250:	5d                   	pop    %ebp
40000251:	c3                   	ret
40000252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000258:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000025f:	00 

40000260 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
40000260:	55                   	push   %ebp
40000261:	89 e5                	mov    %esp,%ebp
40000263:	53                   	push   %ebx
40000264:	bb 01 00 00 00       	mov    $0x1,%ebx
	struct printbuf b;

	b.idx = 0;
	b.cnt = 0;
	vprintfmt((void*)putch, &b, fmt, ap);
40000269:	8d 85 f0 ef ff ff    	lea    -0x1010(%ebp),%eax
{
4000026f:	81 ec 14 10 00 00    	sub    $0x1014,%esp
	vprintfmt((void*)putch, &b, fmt, ap);
40000275:	ff 75 0c             	push   0xc(%ebp)
40000278:	ff 75 08             	push   0x8(%ebp)
4000027b:	50                   	push   %eax
4000027c:	68 10 02 00 40       	push   $0x40000210
	b.idx = 0;
40000281:	c7 85 f0 ef ff ff 00 	movl   $0x0,-0x1010(%ebp)
40000288:	00 00 00 
	b.cnt = 0;
4000028b:	c7 85 f4 ef ff ff 00 	movl   $0x0,-0x100c(%ebp)
40000292:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
40000295:	e8 26 01 00 00       	call   400003c0 <vprintfmt>

	b.buf[b.idx] = 0;
4000029a:	8b 95 f0 ef ff ff    	mov    -0x1010(%ebp),%edx
400002a0:	8d 8d f8 ef ff ff    	lea    -0x1008(%ebp),%ecx
400002a6:	b8 08 00 00 00       	mov    $0x8,%eax
400002ab:	c6 84 15 f8 ef ff ff 	movb   $0x0,-0x1008(%ebp,%edx,1)
400002b2:	00 
400002b3:	cd 30                	int    $0x30
	puts(b.buf, b.idx);

	return b.cnt;
}
400002b5:	8b 85 f4 ef ff ff    	mov    -0x100c(%ebp),%eax
400002bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
400002be:	c9                   	leave
400002bf:	c3                   	ret

400002c0 <printf>:

int
printf(const char *fmt, ...)
{
400002c0:	55                   	push   %ebp
400002c1:	89 e5                	mov    %esp,%ebp
400002c3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
400002c6:	8d 45 0c             	lea    0xc(%ebp),%eax
400002c9:	50                   	push   %eax
400002ca:	ff 75 08             	push   0x8(%ebp)
400002cd:	e8 8e ff ff ff       	call   40000260 <vcprintf>
	va_end(ap);

	return cnt;
}
400002d2:	c9                   	leave
400002d3:	c3                   	ret
400002d4:	66 90                	xchg   %ax,%ax
400002d6:	66 90                	xchg   %ax,%ax
400002d8:	66 90                	xchg   %ax,%ax
400002da:	66 90                	xchg   %ax,%ax
400002dc:	66 90                	xchg   %ax,%ax
400002de:	66 90                	xchg   %ax,%ax

400002e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
400002e0:	55                   	push   %ebp
400002e1:	89 e5                	mov    %esp,%ebp
400002e3:	57                   	push   %edi
400002e4:	89 c7                	mov    %eax,%edi
400002e6:	56                   	push   %esi
400002e7:	89 d6                	mov    %edx,%esi
400002e9:	53                   	push   %ebx
400002ea:	83 ec 2c             	sub    $0x2c,%esp
400002ed:	8b 45 08             	mov    0x8(%ebp),%eax
400002f0:	8b 55 0c             	mov    0xc(%ebp),%edx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
400002f3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
{
400002fa:	8b 4d 18             	mov    0x18(%ebp),%ecx
400002fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
40000300:	8b 45 10             	mov    0x10(%ebp),%eax
40000303:	89 55 dc             	mov    %edx,-0x24(%ebp)
40000306:	8b 55 14             	mov    0x14(%ebp),%edx
40000309:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	if (num >= base) {
4000030c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
4000030f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
40000312:	1b 4d d4             	sbb    -0x2c(%ebp),%ecx
40000315:	89 45 d0             	mov    %eax,-0x30(%ebp)
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
40000318:	8d 5a ff             	lea    -0x1(%edx),%ebx
	if (num >= base) {
4000031b:	73 53                	jae    40000370 <printnum+0x90>
		while (--width > 0)
4000031d:	83 fa 01             	cmp    $0x1,%edx
40000320:	7e 1f                	jle    40000341 <printnum+0x61>
40000322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000328:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000032f:	00 
			putch(padc, putdat);
40000330:	83 ec 08             	sub    $0x8,%esp
40000333:	56                   	push   %esi
40000334:	ff 75 e4             	push   -0x1c(%ebp)
40000337:	ff d7                	call   *%edi
		while (--width > 0)
40000339:	83 c4 10             	add    $0x10,%esp
4000033c:	83 eb 01             	sub    $0x1,%ebx
4000033f:	75 ef                	jne    40000330 <printnum+0x50>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
40000341:	89 75 0c             	mov    %esi,0xc(%ebp)
40000344:	ff 75 d4             	push   -0x2c(%ebp)
40000347:	ff 75 d0             	push   -0x30(%ebp)
4000034a:	ff 75 dc             	push   -0x24(%ebp)
4000034d:	ff 75 d8             	push   -0x28(%ebp)
40000350:	e8 6b 0d 00 00       	call   400010c0 <__umoddi3>
40000355:	83 c4 10             	add    $0x10,%esp
40000358:	0f be 80 1c 12 00 40 	movsbl 0x4000121c(%eax),%eax
4000035f:	89 45 08             	mov    %eax,0x8(%ebp)
}
40000362:	8d 65 f4             	lea    -0xc(%ebp),%esp
	putch("0123456789abcdef"[num % base], putdat);
40000365:	89 f8                	mov    %edi,%eax
}
40000367:	5b                   	pop    %ebx
40000368:	5e                   	pop    %esi
40000369:	5f                   	pop    %edi
4000036a:	5d                   	pop    %ebp
	putch("0123456789abcdef"[num % base], putdat);
4000036b:	ff e0                	jmp    *%eax
4000036d:	8d 76 00             	lea    0x0(%esi),%esi
		printnum(putch, putdat, num / base, base, width - 1, padc);
40000370:	83 ec 0c             	sub    $0xc,%esp
40000373:	ff 75 e4             	push   -0x1c(%ebp)
40000376:	53                   	push   %ebx
40000377:	50                   	push   %eax
40000378:	83 ec 08             	sub    $0x8,%esp
4000037b:	ff 75 d4             	push   -0x2c(%ebp)
4000037e:	ff 75 d0             	push   -0x30(%ebp)
40000381:	ff 75 dc             	push   -0x24(%ebp)
40000384:	ff 75 d8             	push   -0x28(%ebp)
40000387:	e8 14 0c 00 00       	call   40000fa0 <__udivdi3>
4000038c:	83 c4 18             	add    $0x18,%esp
4000038f:	52                   	push   %edx
40000390:	89 f2                	mov    %esi,%edx
40000392:	50                   	push   %eax
40000393:	89 f8                	mov    %edi,%eax
40000395:	e8 46 ff ff ff       	call   400002e0 <printnum>
4000039a:	83 c4 20             	add    $0x20,%esp
4000039d:	eb a2                	jmp    40000341 <printnum+0x61>
4000039f:	90                   	nop

400003a0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
400003a0:	55                   	push   %ebp
400003a1:	89 e5                	mov    %esp,%ebp
400003a3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
400003a6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
400003aa:	8b 10                	mov    (%eax),%edx
400003ac:	3b 50 04             	cmp    0x4(%eax),%edx
400003af:	73 0a                	jae    400003bb <sprintputch+0x1b>
		*b->buf++ = ch;
400003b1:	8d 4a 01             	lea    0x1(%edx),%ecx
400003b4:	89 08                	mov    %ecx,(%eax)
400003b6:	8b 45 08             	mov    0x8(%ebp),%eax
400003b9:	88 02                	mov    %al,(%edx)
}
400003bb:	5d                   	pop    %ebp
400003bc:	c3                   	ret
400003bd:	8d 76 00             	lea    0x0(%esi),%esi

400003c0 <vprintfmt>:
{
400003c0:	55                   	push   %ebp
400003c1:	89 e5                	mov    %esp,%ebp
400003c3:	57                   	push   %edi
400003c4:	56                   	push   %esi
400003c5:	53                   	push   %ebx
400003c6:	83 ec 2c             	sub    $0x2c,%esp
400003c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
400003cc:	8b 75 0c             	mov    0xc(%ebp),%esi
		while ((ch = *(unsigned char *) fmt++) != '%') {
400003cf:	8b 45 10             	mov    0x10(%ebp),%eax
400003d2:	8d 78 01             	lea    0x1(%eax),%edi
400003d5:	0f b6 00             	movzbl (%eax),%eax
400003d8:	83 f8 25             	cmp    $0x25,%eax
400003db:	75 19                	jne    400003f6 <vprintfmt+0x36>
400003dd:	eb 29                	jmp    40000408 <vprintfmt+0x48>
400003df:	90                   	nop
			putch(ch, putdat);
400003e0:	83 ec 08             	sub    $0x8,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
400003e3:	83 c7 01             	add    $0x1,%edi
			putch(ch, putdat);
400003e6:	56                   	push   %esi
400003e7:	50                   	push   %eax
400003e8:	ff d3                	call   *%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
400003ea:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
400003ee:	83 c4 10             	add    $0x10,%esp
400003f1:	83 f8 25             	cmp    $0x25,%eax
400003f4:	74 12                	je     40000408 <vprintfmt+0x48>
			if (ch == '\0')
400003f6:	85 c0                	test   %eax,%eax
400003f8:	75 e6                	jne    400003e0 <vprintfmt+0x20>
}
400003fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
400003fd:	5b                   	pop    %ebx
400003fe:	5e                   	pop    %esi
400003ff:	5f                   	pop    %edi
40000400:	5d                   	pop    %ebp
40000401:	c3                   	ret
40000402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		padc = ' ';
40000408:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
		precision = -1;
4000040c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		altflag = 0;
40000411:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		width = -1;
40000418:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		lflag = 0;
4000041f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000426:	0f b6 17             	movzbl (%edi),%edx
40000429:	8d 47 01             	lea    0x1(%edi),%eax
4000042c:	89 45 10             	mov    %eax,0x10(%ebp)
4000042f:	8d 42 dd             	lea    -0x23(%edx),%eax
40000432:	3c 55                	cmp    $0x55,%al
40000434:	77 0a                	ja     40000440 <vprintfmt+0x80>
40000436:	0f b6 c0             	movzbl %al,%eax
40000439:	ff 24 85 3c 12 00 40 	jmp    *0x4000123c(,%eax,4)
			putch('%', putdat);
40000440:	83 ec 08             	sub    $0x8,%esp
40000443:	56                   	push   %esi
40000444:	6a 25                	push   $0x25
40000446:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
40000448:	83 c4 10             	add    $0x10,%esp
4000044b:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
4000044f:	89 7d 10             	mov    %edi,0x10(%ebp)
40000452:	0f 84 77 ff ff ff    	je     400003cf <vprintfmt+0xf>
40000458:	89 f8                	mov    %edi,%eax
4000045a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000460:	83 e8 01             	sub    $0x1,%eax
40000463:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
40000467:	75 f7                	jne    40000460 <vprintfmt+0xa0>
40000469:	89 45 10             	mov    %eax,0x10(%ebp)
4000046c:	e9 5e ff ff ff       	jmp    400003cf <vprintfmt+0xf>
40000471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				if (ch < '0' || ch > '9')
40000478:	0f be 47 01          	movsbl 0x1(%edi),%eax
				precision = precision * 10 + ch - '0';
4000047c:	8d 4a d0             	lea    -0x30(%edx),%ecx
		switch (ch = *(unsigned char *) fmt++) {
4000047f:	8b 7d 10             	mov    0x10(%ebp),%edi
				if (ch < '0' || ch > '9')
40000482:	8d 50 d0             	lea    -0x30(%eax),%edx
40000485:	83 fa 09             	cmp    $0x9,%edx
40000488:	77 2b                	ja     400004b5 <vprintfmt+0xf5>
4000048a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000490:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000497:	00 
40000498:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000049f:	00 
				precision = precision * 10 + ch - '0';
400004a0:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
			for (precision = 0; ; ++fmt) {
400004a3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
400004a6:	8d 4c 50 d0          	lea    -0x30(%eax,%edx,2),%ecx
				ch = *fmt;
400004aa:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
400004ad:	8d 50 d0             	lea    -0x30(%eax),%edx
400004b0:	83 fa 09             	cmp    $0x9,%edx
400004b3:	76 eb                	jbe    400004a0 <vprintfmt+0xe0>
			if (width < 0)
400004b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400004b8:	85 c0                	test   %eax,%eax
				width = precision, precision = -1;
400004ba:	0f 48 c1             	cmovs  %ecx,%eax
400004bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
400004c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
400004c5:	0f 48 c8             	cmovs  %eax,%ecx
400004c8:	e9 59 ff ff ff       	jmp    40000426 <vprintfmt+0x66>
			altflag = 1;
400004cd:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400004d4:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
400004d7:	e9 4a ff ff ff       	jmp    40000426 <vprintfmt+0x66>
			putch(ch, putdat);
400004dc:	83 ec 08             	sub    $0x8,%esp
400004df:	56                   	push   %esi
400004e0:	6a 25                	push   $0x25
400004e2:	ff d3                	call   *%ebx
			break;
400004e4:	83 c4 10             	add    $0x10,%esp
400004e7:	e9 e3 fe ff ff       	jmp    400003cf <vprintfmt+0xf>
			precision = va_arg(ap, int);
400004ec:	8b 45 14             	mov    0x14(%ebp),%eax
		switch (ch = *(unsigned char *) fmt++) {
400004ef:	8b 7d 10             	mov    0x10(%ebp),%edi
			precision = va_arg(ap, int);
400004f2:	8b 08                	mov    (%eax),%ecx
400004f4:	83 c0 04             	add    $0x4,%eax
400004f7:	89 45 14             	mov    %eax,0x14(%ebp)
			goto process_precision;
400004fa:	eb b9                	jmp    400004b5 <vprintfmt+0xf5>
			if (width < 0)
400004fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
400004ff:	31 c0                	xor    %eax,%eax
		switch (ch = *(unsigned char *) fmt++) {
40000501:	8b 7d 10             	mov    0x10(%ebp),%edi
			if (width < 0)
40000504:	85 d2                	test   %edx,%edx
40000506:	0f 49 c2             	cmovns %edx,%eax
40000509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			goto reswitch;
4000050c:	e9 15 ff ff ff       	jmp    40000426 <vprintfmt+0x66>
			putch(va_arg(ap, int), putdat);
40000511:	83 ec 08             	sub    $0x8,%esp
40000514:	56                   	push   %esi
40000515:	8b 45 14             	mov    0x14(%ebp),%eax
40000518:	ff 30                	push   (%eax)
4000051a:	ff d3                	call   *%ebx
4000051c:	8b 45 14             	mov    0x14(%ebp),%eax
4000051f:	83 c0 04             	add    $0x4,%eax
			break;
40000522:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
40000525:	89 45 14             	mov    %eax,0x14(%ebp)
			break;
40000528:	e9 a2 fe ff ff       	jmp    400003cf <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
4000052d:	8b 45 14             	mov    0x14(%ebp),%eax
40000530:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
40000532:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
40000536:	0f 8f af 01 00 00    	jg     400006eb <vprintfmt+0x32b>
		return va_arg(*ap, unsigned long);
4000053c:	83 c0 04             	add    $0x4,%eax
4000053f:	31 c9                	xor    %ecx,%ecx
40000541:	bf 0a 00 00 00       	mov    $0xa,%edi
40000546:	89 45 14             	mov    %eax,0x14(%ebp)
40000549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			printnum(putch, putdat, num, base, width, padc);
40000550:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
40000554:	83 ec 0c             	sub    $0xc,%esp
40000557:	50                   	push   %eax
40000558:	89 d8                	mov    %ebx,%eax
4000055a:	ff 75 e4             	push   -0x1c(%ebp)
4000055d:	57                   	push   %edi
4000055e:	51                   	push   %ecx
4000055f:	52                   	push   %edx
40000560:	89 f2                	mov    %esi,%edx
40000562:	e8 79 fd ff ff       	call   400002e0 <printnum>
			break;
40000567:	83 c4 20             	add    $0x20,%esp
4000056a:	e9 60 fe ff ff       	jmp    400003cf <vprintfmt+0xf>
			putch('0', putdat);
4000056f:	83 ec 08             	sub    $0x8,%esp
			goto number;
40000572:	bf 10 00 00 00       	mov    $0x10,%edi
			putch('0', putdat);
40000577:	56                   	push   %esi
40000578:	6a 30                	push   $0x30
4000057a:	ff d3                	call   *%ebx
			putch('x', putdat);
4000057c:	58                   	pop    %eax
4000057d:	5a                   	pop    %edx
4000057e:	56                   	push   %esi
4000057f:	6a 78                	push   $0x78
40000581:	ff d3                	call   *%ebx
			num = (unsigned long long)
40000583:	8b 45 14             	mov    0x14(%ebp),%eax
40000586:	31 c9                	xor    %ecx,%ecx
40000588:	8b 10                	mov    (%eax),%edx
				(uintptr_t) va_arg(ap, void *);
4000058a:	83 c0 04             	add    $0x4,%eax
			goto number;
4000058d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
40000590:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;
40000593:	eb bb                	jmp    40000550 <vprintfmt+0x190>
		return va_arg(*ap, unsigned long long);
40000595:	8b 45 14             	mov    0x14(%ebp),%eax
40000598:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
4000059a:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
4000059e:	0f 8f 5a 01 00 00    	jg     400006fe <vprintfmt+0x33e>
		return va_arg(*ap, unsigned long);
400005a4:	83 c0 04             	add    $0x4,%eax
400005a7:	31 c9                	xor    %ecx,%ecx
400005a9:	bf 10 00 00 00       	mov    $0x10,%edi
400005ae:	89 45 14             	mov    %eax,0x14(%ebp)
400005b1:	eb 9d                	jmp    40000550 <vprintfmt+0x190>
		return va_arg(*ap, long long);
400005b3:	8b 45 14             	mov    0x14(%ebp),%eax
	if (lflag >= 2)
400005b6:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
400005ba:	0f 8f 51 01 00 00    	jg     40000711 <vprintfmt+0x351>
		return va_arg(*ap, long);
400005c0:	8b 4d 14             	mov    0x14(%ebp),%ecx
400005c3:	8b 00                	mov    (%eax),%eax
400005c5:	83 c1 04             	add    $0x4,%ecx
400005c8:	99                   	cltd
400005c9:	89 4d 14             	mov    %ecx,0x14(%ebp)
			if ((long long) num < 0) {
400005cc:	85 d2                	test   %edx,%edx
400005ce:	0f 88 68 01 00 00    	js     4000073c <vprintfmt+0x37c>
			num = getint(&ap, lflag);
400005d4:	89 d1                	mov    %edx,%ecx
400005d6:	bf 0a 00 00 00       	mov    $0xa,%edi
400005db:	89 c2                	mov    %eax,%edx
400005dd:	e9 6e ff ff ff       	jmp    40000550 <vprintfmt+0x190>
			lflag++;
400005e2:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400005e6:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
400005e9:	e9 38 fe ff ff       	jmp    40000426 <vprintfmt+0x66>
			putch('X', putdat);
400005ee:	83 ec 08             	sub    $0x8,%esp
400005f1:	56                   	push   %esi
400005f2:	6a 58                	push   $0x58
400005f4:	ff d3                	call   *%ebx
			putch('X', putdat);
400005f6:	59                   	pop    %ecx
400005f7:	5f                   	pop    %edi
400005f8:	56                   	push   %esi
400005f9:	6a 58                	push   $0x58
400005fb:	ff d3                	call   *%ebx
			putch('X', putdat);
400005fd:	58                   	pop    %eax
400005fe:	5a                   	pop    %edx
400005ff:	56                   	push   %esi
40000600:	6a 58                	push   $0x58
40000602:	ff d3                	call   *%ebx
			break;
40000604:	83 c4 10             	add    $0x10,%esp
40000607:	e9 c3 fd ff ff       	jmp    400003cf <vprintfmt+0xf>
			if ((p = va_arg(ap, char *)) == NULL)
4000060c:	8b 45 14             	mov    0x14(%ebp),%eax
4000060f:	83 c0 04             	add    $0x4,%eax
40000612:	89 45 d4             	mov    %eax,-0x2c(%ebp)
40000615:	8b 45 14             	mov    0x14(%ebp),%eax
40000618:	8b 38                	mov    (%eax),%edi
			if (width > 0 && padc != '-')
4000061a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
4000061d:	85 c0                	test   %eax,%eax
4000061f:	0f 9f c0             	setg   %al
40000622:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
40000626:	0f 95 c2             	setne  %dl
40000629:	21 d0                	and    %edx,%eax
			if ((p = va_arg(ap, char *)) == NULL)
4000062b:	85 ff                	test   %edi,%edi
4000062d:	0f 84 32 01 00 00    	je     40000765 <vprintfmt+0x3a5>
			if (width > 0 && padc != '-')
40000633:	84 c0                	test   %al,%al
40000635:	0f 85 4d 01 00 00    	jne    40000788 <vprintfmt+0x3c8>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000063b:	0f be 07             	movsbl (%edi),%eax
4000063e:	89 c2                	mov    %eax,%edx
40000640:	85 c0                	test   %eax,%eax
40000642:	74 7b                	je     400006bf <vprintfmt+0x2ff>
40000644:	89 5d 08             	mov    %ebx,0x8(%ebp)
40000647:	83 c7 01             	add    $0x1,%edi
4000064a:	89 cb                	mov    %ecx,%ebx
4000064c:	89 75 0c             	mov    %esi,0xc(%ebp)
4000064f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
40000652:	eb 21                	jmp    40000675 <vprintfmt+0x2b5>
40000654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					putch(ch, putdat);
40000658:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000065b:	83 c7 01             	add    $0x1,%edi
					putch(ch, putdat);
4000065e:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000661:	83 ee 01             	sub    $0x1,%esi
					putch(ch, putdat);
40000664:	50                   	push   %eax
40000665:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000668:	0f be 47 ff          	movsbl -0x1(%edi),%eax
4000066c:	83 c4 10             	add    $0x10,%esp
4000066f:	89 c2                	mov    %eax,%edx
40000671:	85 c0                	test   %eax,%eax
40000673:	74 41                	je     400006b6 <vprintfmt+0x2f6>
40000675:	85 db                	test   %ebx,%ebx
40000677:	78 05                	js     4000067e <vprintfmt+0x2be>
40000679:	83 eb 01             	sub    $0x1,%ebx
4000067c:	72 38                	jb     400006b6 <vprintfmt+0x2f6>
				if (altflag && (ch < ' ' || ch > '~'))
4000067e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
40000681:	85 c9                	test   %ecx,%ecx
40000683:	74 d3                	je     40000658 <vprintfmt+0x298>
40000685:	0f be ca             	movsbl %dl,%ecx
40000688:	83 e9 20             	sub    $0x20,%ecx
4000068b:	83 f9 5e             	cmp    $0x5e,%ecx
4000068e:	76 c8                	jbe    40000658 <vprintfmt+0x298>
					putch('?', putdat);
40000690:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000693:	83 c7 01             	add    $0x1,%edi
					putch('?', putdat);
40000696:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000699:	83 ee 01             	sub    $0x1,%esi
					putch('?', putdat);
4000069c:	6a 3f                	push   $0x3f
4000069e:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006a1:	0f be 4f ff          	movsbl -0x1(%edi),%ecx
400006a5:	83 c4 10             	add    $0x10,%esp
400006a8:	89 ca                	mov    %ecx,%edx
400006aa:	89 c8                	mov    %ecx,%eax
400006ac:	85 c9                	test   %ecx,%ecx
400006ae:	74 06                	je     400006b6 <vprintfmt+0x2f6>
400006b0:	85 db                	test   %ebx,%ebx
400006b2:	79 c5                	jns    40000679 <vprintfmt+0x2b9>
400006b4:	eb d2                	jmp    40000688 <vprintfmt+0x2c8>
400006b6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
400006b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
400006bc:	8b 75 0c             	mov    0xc(%ebp),%esi
			for (; width > 0; width--)
400006bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400006c2:	85 c0                	test   %eax,%eax
400006c4:	7e 1a                	jle    400006e0 <vprintfmt+0x320>
400006c6:	89 c7                	mov    %eax,%edi
400006c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400006cf:	00 
				putch(' ', putdat);
400006d0:	83 ec 08             	sub    $0x8,%esp
400006d3:	56                   	push   %esi
400006d4:	6a 20                	push   $0x20
400006d6:	ff d3                	call   *%ebx
			for (; width > 0; width--)
400006d8:	83 c4 10             	add    $0x10,%esp
400006db:	83 ef 01             	sub    $0x1,%edi
400006de:	75 f0                	jne    400006d0 <vprintfmt+0x310>
			if ((p = va_arg(ap, char *)) == NULL)
400006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
400006e3:	89 45 14             	mov    %eax,0x14(%ebp)
400006e6:	e9 e4 fc ff ff       	jmp    400003cf <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
400006eb:	8b 48 04             	mov    0x4(%eax),%ecx
400006ee:	83 c0 08             	add    $0x8,%eax
400006f1:	bf 0a 00 00 00       	mov    $0xa,%edi
400006f6:	89 45 14             	mov    %eax,0x14(%ebp)
400006f9:	e9 52 fe ff ff       	jmp    40000550 <vprintfmt+0x190>
400006fe:	8b 48 04             	mov    0x4(%eax),%ecx
40000701:	83 c0 08             	add    $0x8,%eax
40000704:	bf 10 00 00 00       	mov    $0x10,%edi
40000709:	89 45 14             	mov    %eax,0x14(%ebp)
4000070c:	e9 3f fe ff ff       	jmp    40000550 <vprintfmt+0x190>
		return va_arg(*ap, long long);
40000711:	8b 4d 14             	mov    0x14(%ebp),%ecx
40000714:	8b 50 04             	mov    0x4(%eax),%edx
40000717:	8b 00                	mov    (%eax),%eax
40000719:	83 c1 08             	add    $0x8,%ecx
4000071c:	89 4d 14             	mov    %ecx,0x14(%ebp)
4000071f:	e9 a8 fe ff ff       	jmp    400005cc <vprintfmt+0x20c>
		switch (ch = *(unsigned char *) fmt++) {
40000724:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
40000728:	8b 7d 10             	mov    0x10(%ebp),%edi
4000072b:	e9 f6 fc ff ff       	jmp    40000426 <vprintfmt+0x66>
			padc = '-';
40000730:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000734:	8b 7d 10             	mov    0x10(%ebp),%edi
40000737:	e9 ea fc ff ff       	jmp    40000426 <vprintfmt+0x66>
				putch('-', putdat);
4000073c:	83 ec 08             	sub    $0x8,%esp
4000073f:	89 45 d8             	mov    %eax,-0x28(%ebp)
				num = -(long long) num;
40000742:	bf 0a 00 00 00       	mov    $0xa,%edi
40000747:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch('-', putdat);
4000074a:	56                   	push   %esi
4000074b:	6a 2d                	push   $0x2d
4000074d:	ff d3                	call   *%ebx
				num = -(long long) num;
4000074f:	8b 45 d8             	mov    -0x28(%ebp),%eax
40000752:	31 d2                	xor    %edx,%edx
40000754:	f7 d8                	neg    %eax
40000756:	1b 55 dc             	sbb    -0x24(%ebp),%edx
40000759:	83 c4 10             	add    $0x10,%esp
4000075c:	89 d1                	mov    %edx,%ecx
4000075e:	89 c2                	mov    %eax,%edx
40000760:	e9 eb fd ff ff       	jmp    40000550 <vprintfmt+0x190>
			if (width > 0 && padc != '-')
40000765:	84 c0                	test   %al,%al
40000767:	75 78                	jne    400007e1 <vprintfmt+0x421>
40000769:	89 5d 08             	mov    %ebx,0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000076c:	bf 2e 12 00 40       	mov    $0x4000122e,%edi
40000771:	ba 28 00 00 00       	mov    $0x28,%edx
40000776:	89 cb                	mov    %ecx,%ebx
40000778:	89 75 0c             	mov    %esi,0xc(%ebp)
4000077b:	b8 28 00 00 00       	mov    $0x28,%eax
40000780:	8b 75 e4             	mov    -0x1c(%ebp),%esi
40000783:	e9 ed fe ff ff       	jmp    40000675 <vprintfmt+0x2b5>
				for (width -= strnlen(p, precision); width > 0; width--)
40000788:	83 ec 08             	sub    $0x8,%esp
4000078b:	51                   	push   %ecx
4000078c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
4000078f:	57                   	push   %edi
40000790:	e8 eb 02 00 00       	call   40000a80 <strnlen>
40000795:	29 45 e4             	sub    %eax,-0x1c(%ebp)
40000798:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
4000079b:	83 c4 10             	add    $0x10,%esp
4000079e:	85 c9                	test   %ecx,%ecx
400007a0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
400007a3:	7e 71                	jle    40000816 <vprintfmt+0x456>
					putch(padc, putdat);
400007a5:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
400007a9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
400007ac:	89 7d d0             	mov    %edi,-0x30(%ebp)
400007af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
400007b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
400007b5:	83 ec 08             	sub    $0x8,%esp
400007b8:	56                   	push   %esi
400007b9:	ff 75 e0             	push   -0x20(%ebp)
400007bc:	ff d3                	call   *%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
400007be:	83 c4 10             	add    $0x10,%esp
400007c1:	83 ef 01             	sub    $0x1,%edi
400007c4:	75 ef                	jne    400007b5 <vprintfmt+0x3f5>
400007c6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
400007c9:	8b 7d d0             	mov    -0x30(%ebp),%edi
400007cc:	8b 4d cc             	mov    -0x34(%ebp),%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400007cf:	0f be 07             	movsbl (%edi),%eax
400007d2:	89 c2                	mov    %eax,%edx
400007d4:	85 c0                	test   %eax,%eax
400007d6:	0f 85 68 fe ff ff    	jne    40000644 <vprintfmt+0x284>
400007dc:	e9 ff fe ff ff       	jmp    400006e0 <vprintfmt+0x320>
				for (width -= strnlen(p, precision); width > 0; width--)
400007e1:	83 ec 08             	sub    $0x8,%esp
				p = "(null)";
400007e4:	bf 2d 12 00 40       	mov    $0x4000122d,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
400007e9:	51                   	push   %ecx
400007ea:	89 4d d0             	mov    %ecx,-0x30(%ebp)
400007ed:	68 2d 12 00 40       	push   $0x4000122d
400007f2:	e8 89 02 00 00       	call   40000a80 <strnlen>
400007f7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
400007fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
400007fd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000800:	ba 28 00 00 00       	mov    $0x28,%edx
40000805:	b8 28 00 00 00       	mov    $0x28,%eax
				for (width -= strnlen(p, precision); width > 0; width--)
4000080a:	85 c9                	test   %ecx,%ecx
4000080c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
4000080f:	7f 94                	jg     400007a5 <vprintfmt+0x3e5>
40000811:	e9 2e fe ff ff       	jmp    40000644 <vprintfmt+0x284>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000816:	0f be 07             	movsbl (%edi),%eax
40000819:	89 c2                	mov    %eax,%edx
4000081b:	85 c0                	test   %eax,%eax
4000081d:	0f 85 21 fe ff ff    	jne    40000644 <vprintfmt+0x284>
40000823:	e9 b8 fe ff ff       	jmp    400006e0 <vprintfmt+0x320>
40000828:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000082f:	00 

40000830 <printfmt>:
{
40000830:	55                   	push   %ebp
40000831:	89 e5                	mov    %esp,%ebp
40000833:	83 ec 08             	sub    $0x8,%esp
	vprintfmt(putch, putdat, fmt, ap);
40000836:	8d 45 14             	lea    0x14(%ebp),%eax
40000839:	50                   	push   %eax
4000083a:	ff 75 10             	push   0x10(%ebp)
4000083d:	ff 75 0c             	push   0xc(%ebp)
40000840:	ff 75 08             	push   0x8(%ebp)
40000843:	e8 78 fb ff ff       	call   400003c0 <vprintfmt>
}
40000848:	83 c4 10             	add    $0x10,%esp
4000084b:	c9                   	leave
4000084c:	c3                   	ret
4000084d:	8d 76 00             	lea    0x0(%esi),%esi

40000850 <vsprintf>:

int
vsprintf(char *buf, const char *fmt, va_list ap)
{
40000850:	55                   	push   %ebp
40000851:	89 e5                	mov    %esp,%ebp
40000853:	83 ec 18             	sub    $0x18,%esp
	//assert(buf != NULL);
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
40000856:	8b 45 08             	mov    0x8(%ebp),%eax

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000859:	ff 75 10             	push   0x10(%ebp)
4000085c:	ff 75 0c             	push   0xc(%ebp)
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
4000085f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000862:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000865:	50                   	push   %eax
40000866:	68 a0 03 00 40       	push   $0x400003a0
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
4000086b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
40000872:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000879:	e8 42 fb ff ff       	call   400003c0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
4000087e:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000881:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000884:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000887:	c9                   	leave
40000888:	c3                   	ret
40000889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000890 <sprintf>:

int
sprintf(char *buf, const char *fmt, ...)
{
40000890:	55                   	push   %ebp
40000891:	89 e5                	mov    %esp,%ebp
40000893:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
40000896:	8b 45 08             	mov    0x8(%ebp),%eax
40000899:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
400008a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
400008a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008aa:	8d 45 10             	lea    0x10(%ebp),%eax
400008ad:	50                   	push   %eax
400008ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
400008b1:	ff 75 0c             	push   0xc(%ebp)
400008b4:	50                   	push   %eax
400008b5:	68 a0 03 00 40       	push   $0x400003a0
400008ba:	e8 01 fb ff ff       	call   400003c0 <vprintfmt>
	*b.buf = '\0';
400008bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
400008c2:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsprintf(buf, fmt, ap);
	va_end(ap);

	return rc;
}
400008c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
400008c8:	c9                   	leave
400008c9:	c3                   	ret
400008ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

400008d0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
400008d0:	55                   	push   %ebp
400008d1:	89 e5                	mov    %esp,%ebp
400008d3:	83 ec 18             	sub    $0x18,%esp
400008d6:	8b 45 08             	mov    0x8(%ebp),%eax
	//assert(buf != NULL && n > 0);
	struct sprintbuf b = {buf, buf+n-1, 0};
400008d9:	8b 55 0c             	mov    0xc(%ebp),%edx

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008dc:	ff 75 14             	push   0x14(%ebp)
400008df:	ff 75 10             	push   0x10(%ebp)
	struct sprintbuf b = {buf, buf+n-1, 0};
400008e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
400008e5:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
400008e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008ec:	8d 45 ec             	lea    -0x14(%ebp),%eax
400008ef:	50                   	push   %eax
400008f0:	68 a0 03 00 40       	push   $0x400003a0
	struct sprintbuf b = {buf, buf+n-1, 0};
400008f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008fc:	e8 bf fa ff ff       	call   400003c0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
40000901:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000904:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000907:	8b 45 f4             	mov    -0xc(%ebp),%eax
4000090a:	c9                   	leave
4000090b:	c3                   	ret
4000090c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000910 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
40000910:	55                   	push   %ebp
40000911:	89 e5                	mov    %esp,%ebp
40000913:	83 ec 18             	sub    $0x18,%esp
40000916:	8b 45 08             	mov    0x8(%ebp),%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
40000919:	8b 55 0c             	mov    0xc(%ebp),%edx
4000091c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
40000923:	89 45 ec             	mov    %eax,-0x14(%ebp)
40000926:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
4000092a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000092d:	8d 45 14             	lea    0x14(%ebp),%eax
40000930:	50                   	push   %eax
40000931:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000934:	ff 75 10             	push   0x10(%ebp)
40000937:	50                   	push   %eax
40000938:	68 a0 03 00 40       	push   $0x400003a0
4000093d:	e8 7e fa ff ff       	call   400003c0 <vprintfmt>
	*b.buf = '\0';
40000942:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000945:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
	va_end(ap);

	return rc;
}
40000948:	8b 45 f4             	mov    -0xc(%ebp),%eax
4000094b:	c9                   	leave
4000094c:	c3                   	ret
4000094d:	66 90                	xchg   %ax,%ax
4000094f:	90                   	nop

40000950 <spawn>:
#include <syscall.h>
#include <types.h>

pid_t
spawn(uintptr_t exec, unsigned int quota)
{
40000950:	55                   	push   %ebp
	asm volatile("int %2"
40000951:	ba ff ff ff ff       	mov    $0xffffffff,%edx
40000956:	b8 01 00 00 00       	mov    $0x1,%eax
4000095b:	89 e5                	mov    %esp,%ebp
4000095d:	56                   	push   %esi
4000095e:	89 d6                	mov    %edx,%esi
40000960:	53                   	push   %ebx
40000961:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000964:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000967:	cd 30                	int    $0x30
	return errno ? -1 : pid;
40000969:	85 c0                	test   %eax,%eax
4000096b:	75 0b                	jne    40000978 <spawn+0x28>
4000096d:	89 da                	mov    %ebx,%edx
	// Default: inherit console stdin/stdout
	return sys_spawn(exec, quota, -1, -1);
}
4000096f:	5b                   	pop    %ebx
40000970:	89 d0                	mov    %edx,%eax
40000972:	5e                   	pop    %esi
40000973:	5d                   	pop    %ebp
40000974:	c3                   	ret
40000975:	8d 76 00             	lea    0x0(%esi),%esi
40000978:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, -1, -1);
4000097d:	eb f0                	jmp    4000096f <spawn+0x1f>
4000097f:	90                   	nop

40000980 <spawn_with_fds>:

pid_t
spawn_with_fds(uintptr_t exec, unsigned int quota, int stdin_fd, int stdout_fd)
{
40000980:	55                   	push   %ebp
	asm volatile("int %2"
40000981:	b8 01 00 00 00       	mov    $0x1,%eax
40000986:	89 e5                	mov    %esp,%ebp
40000988:	56                   	push   %esi
40000989:	8b 4d 0c             	mov    0xc(%ebp),%ecx
4000098c:	8b 55 10             	mov    0x10(%ebp),%edx
4000098f:	53                   	push   %ebx
40000990:	8b 75 14             	mov    0x14(%ebp),%esi
40000993:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000996:	cd 30                	int    $0x30
	return errno ? -1 : pid;
40000998:	85 c0                	test   %eax,%eax
4000099a:	75 0c                	jne    400009a8 <spawn_with_fds+0x28>
4000099c:	89 da                	mov    %ebx,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
}
4000099e:	5b                   	pop    %ebx
4000099f:	89 d0                	mov    %edx,%eax
400009a1:	5e                   	pop    %esi
400009a2:	5d                   	pop    %ebp
400009a3:	c3                   	ret
400009a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400009a8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
400009ad:	eb ef                	jmp    4000099e <spawn_with_fds+0x1e>
400009af:	90                   	nop

400009b0 <yield>:
	asm volatile("int %0" :
400009b0:	b8 02 00 00 00       	mov    $0x2,%eax
400009b5:	cd 30                	int    $0x30

void
yield(void)
{
	sys_yield();
}
400009b7:	c3                   	ret
400009b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400009bf:	00 

400009c0 <produce>:
	asm volatile("int %0" :
400009c0:	b8 03 00 00 00       	mov    $0x3,%eax
400009c5:	cd 30                	int    $0x30

void
produce(void)
{
	sys_produce();
}
400009c7:	c3                   	ret
400009c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400009cf:	00 

400009d0 <consume>:
	asm volatile("int %0" :
400009d0:	b8 04 00 00 00       	mov    $0x4,%eax
400009d5:	cd 30                	int    $0x30

void
consume(void)
{
	sys_consume();
}
400009d7:	c3                   	ret
400009d8:	66 90                	xchg   %ax,%ax
400009da:	66 90                	xchg   %ax,%ax
400009dc:	66 90                	xchg   %ax,%ax
400009de:	66 90                	xchg   %ax,%ax

400009e0 <spinlock_init>:
	return result;
}

void
spinlock_init(spinlock_t *lk)
{
400009e0:	55                   	push   %ebp
400009e1:	89 e5                	mov    %esp,%ebp
	*lk = 0;
400009e3:	8b 45 08             	mov    0x8(%ebp),%eax
400009e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
400009ec:	5d                   	pop    %ebp
400009ed:	c3                   	ret
400009ee:	66 90                	xchg   %ax,%ax

400009f0 <spinlock_acquire>:

void
spinlock_acquire(spinlock_t *lk)
{
400009f0:	55                   	push   %ebp
	asm volatile("lock; xchgl %0, %1" :
400009f1:	b8 01 00 00 00       	mov    $0x1,%eax
{
400009f6:	89 e5                	mov    %esp,%ebp
400009f8:	8b 55 08             	mov    0x8(%ebp),%edx
	asm volatile("lock; xchgl %0, %1" :
400009fb:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
400009fe:	85 c0                	test   %eax,%eax
40000a00:	74 1c                	je     40000a1e <spinlock_acquire+0x2e>
40000a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000a08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a0f:	00 
		asm volatile("pause");
40000a10:	f3 90                	pause
	asm volatile("lock; xchgl %0, %1" :
40000a12:	b8 01 00 00 00       	mov    $0x1,%eax
40000a17:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000a1a:	85 c0                	test   %eax,%eax
40000a1c:	75 f2                	jne    40000a10 <spinlock_acquire+0x20>
}
40000a1e:	5d                   	pop    %ebp
40000a1f:	c3                   	ret

40000a20 <spinlock_release>:

// Release the lock.
void
spinlock_release(spinlock_t *lk)
{
40000a20:	55                   	push   %ebp
40000a21:	89 e5                	mov    %esp,%ebp
40000a23:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
bool
spinlock_holding(spinlock_t *lock)
{
	return *lock;
40000a26:	8b 02                	mov    (%edx),%eax
	if (spinlock_holding(lk) == FALSE)
40000a28:	84 c0                	test   %al,%al
40000a2a:	74 05                	je     40000a31 <spinlock_release+0x11>
	asm volatile("lock; xchgl %0, %1" :
40000a2c:	31 c0                	xor    %eax,%eax
40000a2e:	f0 87 02             	lock xchg %eax,(%edx)
}
40000a31:	5d                   	pop    %ebp
40000a32:	c3                   	ret
40000a33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a3f:	00 

40000a40 <spinlock_holding>:
{
40000a40:	55                   	push   %ebp
40000a41:	89 e5                	mov    %esp,%ebp
	return *lock;
40000a43:	8b 45 08             	mov    0x8(%ebp),%eax
}
40000a46:	5d                   	pop    %ebp
	return *lock;
40000a47:	8b 00                	mov    (%eax),%eax
}
40000a49:	c3                   	ret
40000a4a:	66 90                	xchg   %ax,%ax
40000a4c:	66 90                	xchg   %ax,%ax
40000a4e:	66 90                	xchg   %ax,%ax
40000a50:	66 90                	xchg   %ax,%ax
40000a52:	66 90                	xchg   %ax,%ax
40000a54:	66 90                	xchg   %ax,%ax
40000a56:	66 90                	xchg   %ax,%ax
40000a58:	66 90                	xchg   %ax,%ax
40000a5a:	66 90                	xchg   %ax,%ax
40000a5c:	66 90                	xchg   %ax,%ax
40000a5e:	66 90                	xchg   %ax,%ax

40000a60 <strlen>:
#include <string.h>
#include <types.h>

int
strlen(const char *s)
{
40000a60:	55                   	push   %ebp
	int n;

	for (n = 0; *s != '\0'; s++)
40000a61:	31 c0                	xor    %eax,%eax
{
40000a63:	89 e5                	mov    %esp,%ebp
40000a65:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; *s != '\0'; s++)
40000a68:	80 3a 00             	cmpb   $0x0,(%edx)
40000a6b:	74 0c                	je     40000a79 <strlen+0x19>
40000a6d:	8d 76 00             	lea    0x0(%esi),%esi
		n++;
40000a70:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
40000a73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
40000a77:	75 f7                	jne    40000a70 <strlen+0x10>
	return n;
}
40000a79:	5d                   	pop    %ebp
40000a7a:	c3                   	ret
40000a7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

40000a80 <strnlen>:

int
strnlen(const char *s, size_t size)
{
40000a80:	55                   	push   %ebp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000a81:	31 c0                	xor    %eax,%eax
{
40000a83:	89 e5                	mov    %esp,%ebp
40000a85:	8b 55 0c             	mov    0xc(%ebp),%edx
40000a88:	8b 4d 08             	mov    0x8(%ebp),%ecx
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000a8b:	85 d2                	test   %edx,%edx
40000a8d:	75 18                	jne    40000aa7 <strnlen+0x27>
40000a8f:	eb 1c                	jmp    40000aad <strnlen+0x2d>
40000a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a9f:	00 
		n++;
40000aa0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000aa3:	39 c2                	cmp    %eax,%edx
40000aa5:	74 06                	je     40000aad <strnlen+0x2d>
40000aa7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
40000aab:	75 f3                	jne    40000aa0 <strnlen+0x20>
	return n;
}
40000aad:	5d                   	pop    %ebp
40000aae:	c3                   	ret
40000aaf:	90                   	nop

40000ab0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
40000ab0:	55                   	push   %ebp
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
40000ab1:	31 c0                	xor    %eax,%eax
{
40000ab3:	89 e5                	mov    %esp,%ebp
40000ab5:	53                   	push   %ebx
40000ab6:	8b 4d 08             	mov    0x8(%ebp),%ecx
40000ab9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while ((*dst++ = *src++) != '\0')
40000ac0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000ac4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000ac7:	83 c0 01             	add    $0x1,%eax
40000aca:	84 d2                	test   %dl,%dl
40000acc:	75 f2                	jne    40000ac0 <strcpy+0x10>
		/* do nothing */;
	return ret;
}
40000ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000ad1:	89 c8                	mov    %ecx,%eax
40000ad3:	c9                   	leave
40000ad4:	c3                   	ret
40000ad5:	8d 76 00             	lea    0x0(%esi),%esi
40000ad8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000adf:	00 

40000ae0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size)
{
40000ae0:	55                   	push   %ebp
40000ae1:	89 e5                	mov    %esp,%ebp
40000ae3:	56                   	push   %esi
40000ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
40000ae7:	8b 75 08             	mov    0x8(%ebp),%esi
40000aea:	53                   	push   %ebx
40000aeb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
40000aee:	85 db                	test   %ebx,%ebx
40000af0:	74 21                	je     40000b13 <strncpy+0x33>
40000af2:	01 f3                	add    %esi,%ebx
40000af4:	89 f0                	mov    %esi,%eax
40000af6:	66 90                	xchg   %ax,%ax
40000af8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000aff:	00 
		*dst++ = *src;
40000b00:	0f b6 0a             	movzbl (%edx),%ecx
40000b03:	83 c0 01             	add    $0x1,%eax
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
40000b06:	80 f9 01             	cmp    $0x1,%cl
		*dst++ = *src;
40000b09:	88 48 ff             	mov    %cl,-0x1(%eax)
			src++;
40000b0c:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
40000b0f:	39 c3                	cmp    %eax,%ebx
40000b11:	75 ed                	jne    40000b00 <strncpy+0x20>
	}
	return ret;
}
40000b13:	89 f0                	mov    %esi,%eax
40000b15:	5b                   	pop    %ebx
40000b16:	5e                   	pop    %esi
40000b17:	5d                   	pop    %ebp
40000b18:	c3                   	ret
40000b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000b20 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
40000b20:	55                   	push   %ebp
40000b21:	89 e5                	mov    %esp,%ebp
40000b23:	53                   	push   %ebx
40000b24:	8b 45 10             	mov    0x10(%ebp),%eax
40000b27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
40000b2a:	85 c0                	test   %eax,%eax
40000b2c:	74 2e                	je     40000b5c <strlcpy+0x3c>
		while (--size > 0 && *src != '\0')
40000b2e:	8b 55 08             	mov    0x8(%ebp),%edx
40000b31:	83 e8 01             	sub    $0x1,%eax
40000b34:	74 23                	je     40000b59 <strlcpy+0x39>
40000b36:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
40000b39:	eb 12                	jmp    40000b4d <strlcpy+0x2d>
40000b3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
			*dst++ = *src++;
40000b40:	83 c2 01             	add    $0x1,%edx
40000b43:	83 c1 01             	add    $0x1,%ecx
40000b46:	88 42 ff             	mov    %al,-0x1(%edx)
		while (--size > 0 && *src != '\0')
40000b49:	39 da                	cmp    %ebx,%edx
40000b4b:	74 07                	je     40000b54 <strlcpy+0x34>
40000b4d:	0f b6 01             	movzbl (%ecx),%eax
40000b50:	84 c0                	test   %al,%al
40000b52:	75 ec                	jne    40000b40 <strlcpy+0x20>
		*dst = '\0';
	}
	return dst - dst_in;
40000b54:	89 d0                	mov    %edx,%eax
40000b56:	2b 45 08             	sub    0x8(%ebp),%eax
		*dst = '\0';
40000b59:	c6 02 00             	movb   $0x0,(%edx)
}
40000b5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000b5f:	c9                   	leave
40000b60:	c3                   	ret
40000b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b6f:	00 

40000b70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
40000b70:	55                   	push   %ebp
40000b71:	89 e5                	mov    %esp,%ebp
40000b73:	53                   	push   %ebx
40000b74:	8b 55 08             	mov    0x8(%ebp),%edx
40000b77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
40000b7a:	0f b6 02             	movzbl (%edx),%eax
40000b7d:	84 c0                	test   %al,%al
40000b7f:	75 2d                	jne    40000bae <strcmp+0x3e>
40000b81:	eb 4a                	jmp    40000bcd <strcmp+0x5d>
40000b83:	eb 1b                	jmp    40000ba0 <strcmp+0x30>
40000b85:	8d 76 00             	lea    0x0(%esi),%esi
40000b88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b8f:	00 
40000b90:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b97:	00 
40000b98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b9f:	00 
40000ba0:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		p++, q++;
40000ba4:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
40000ba7:	84 c0                	test   %al,%al
40000ba9:	74 15                	je     40000bc0 <strcmp+0x50>
40000bab:	83 c1 01             	add    $0x1,%ecx
40000bae:	0f b6 19             	movzbl (%ecx),%ebx
40000bb1:	38 c3                	cmp    %al,%bl
40000bb3:	74 eb                	je     40000ba0 <strcmp+0x30>
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000bb5:	29 d8                	sub    %ebx,%eax
}
40000bb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000bba:	c9                   	leave
40000bbb:	c3                   	ret
40000bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000bc0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
40000bc4:	31 c0                	xor    %eax,%eax
40000bc6:	29 d8                	sub    %ebx,%eax
}
40000bc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000bcb:	c9                   	leave
40000bcc:	c3                   	ret
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000bcd:	0f b6 19             	movzbl (%ecx),%ebx
40000bd0:	31 c0                	xor    %eax,%eax
40000bd2:	eb e1                	jmp    40000bb5 <strcmp+0x45>
40000bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000bd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bdf:	00 

40000be0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
40000be0:	55                   	push   %ebp
40000be1:	89 e5                	mov    %esp,%ebp
40000be3:	53                   	push   %ebx
40000be4:	8b 55 10             	mov    0x10(%ebp),%edx
40000be7:	8b 45 08             	mov    0x8(%ebp),%eax
40000bea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
40000bed:	85 d2                	test   %edx,%edx
40000bef:	75 16                	jne    40000c07 <strncmp+0x27>
40000bf1:	eb 2d                	jmp    40000c20 <strncmp+0x40>
40000bf3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bf8:	3a 19                	cmp    (%ecx),%bl
40000bfa:	75 12                	jne    40000c0e <strncmp+0x2e>
		n--, p++, q++;
40000bfc:	83 c0 01             	add    $0x1,%eax
40000bff:	83 c1 01             	add    $0x1,%ecx
	while (n > 0 && *p && *p == *q)
40000c02:	83 ea 01             	sub    $0x1,%edx
40000c05:	74 19                	je     40000c20 <strncmp+0x40>
40000c07:	0f b6 18             	movzbl (%eax),%ebx
40000c0a:	84 db                	test   %bl,%bl
40000c0c:	75 ea                	jne    40000bf8 <strncmp+0x18>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000c0e:	0f b6 00             	movzbl (%eax),%eax
40000c11:	0f b6 11             	movzbl (%ecx),%edx
}
40000c14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c17:	c9                   	leave
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000c18:	29 d0                	sub    %edx,%eax
}
40000c1a:	c3                   	ret
40000c1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
		return 0;
40000c23:	31 c0                	xor    %eax,%eax
}
40000c25:	c9                   	leave
40000c26:	c3                   	ret
40000c27:	90                   	nop
40000c28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c2f:	00 

40000c30 <strchr>:

char *
strchr(const char *s, char c)
{
40000c30:	55                   	push   %ebp
40000c31:	89 e5                	mov    %esp,%ebp
40000c33:	8b 45 08             	mov    0x8(%ebp),%eax
40000c36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
40000c3a:	0f b6 10             	movzbl (%eax),%edx
40000c3d:	84 d2                	test   %dl,%dl
40000c3f:	75 1a                	jne    40000c5b <strchr+0x2b>
40000c41:	eb 25                	jmp    40000c68 <strchr+0x38>
40000c43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c4f:	00 
40000c50:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000c54:	83 c0 01             	add    $0x1,%eax
40000c57:	84 d2                	test   %dl,%dl
40000c59:	74 0d                	je     40000c68 <strchr+0x38>
		if (*s == c)
40000c5b:	38 d1                	cmp    %dl,%cl
40000c5d:	75 f1                	jne    40000c50 <strchr+0x20>
			return (char *) s;
	return 0;
}
40000c5f:	5d                   	pop    %ebp
40000c60:	c3                   	ret
40000c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return 0;
40000c68:	31 c0                	xor    %eax,%eax
}
40000c6a:	5d                   	pop    %ebp
40000c6b:	c3                   	ret
40000c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000c70 <strfind>:

char *
strfind(const char *s, char c)
{
40000c70:	55                   	push   %ebp
40000c71:	89 e5                	mov    %esp,%ebp
40000c73:	8b 45 08             	mov    0x8(%ebp),%eax
40000c76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	for (; *s; s++)
40000c79:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
40000c7c:	38 ca                	cmp    %cl,%dl
40000c7e:	75 1b                	jne    40000c9b <strfind+0x2b>
40000c80:	eb 1d                	jmp    40000c9f <strfind+0x2f>
40000c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000c88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c8f:	00 
	for (; *s; s++)
40000c90:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000c94:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
40000c97:	38 ca                	cmp    %cl,%dl
40000c99:	74 04                	je     40000c9f <strfind+0x2f>
40000c9b:	84 d2                	test   %dl,%dl
40000c9d:	75 f1                	jne    40000c90 <strfind+0x20>
			break;
	return (char *) s;
}
40000c9f:	5d                   	pop    %ebp
40000ca0:	c3                   	ret
40000ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000ca8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000caf:	00 

40000cb0 <strtol>:


long
strtol(const char *s, char **endptr, int base)
{
40000cb0:	55                   	push   %ebp
40000cb1:	89 e5                	mov    %esp,%ebp
40000cb3:	57                   	push   %edi
40000cb4:	8b 55 08             	mov    0x8(%ebp),%edx
40000cb7:	56                   	push   %esi
40000cb8:	53                   	push   %ebx
40000cb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
40000cbc:	0f b6 02             	movzbl (%edx),%eax
40000cbf:	3c 09                	cmp    $0x9,%al
40000cc1:	74 0d                	je     40000cd0 <strtol+0x20>
40000cc3:	3c 20                	cmp    $0x20,%al
40000cc5:	75 18                	jne    40000cdf <strtol+0x2f>
40000cc7:	90                   	nop
40000cc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ccf:	00 
40000cd0:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		s++;
40000cd4:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
40000cd7:	3c 20                	cmp    $0x20,%al
40000cd9:	74 f5                	je     40000cd0 <strtol+0x20>
40000cdb:	3c 09                	cmp    $0x9,%al
40000cdd:	74 f1                	je     40000cd0 <strtol+0x20>

	// plus/minus sign
	if (*s == '+')
40000cdf:	3c 2b                	cmp    $0x2b,%al
40000ce1:	0f 84 89 00 00 00    	je     40000d70 <strtol+0xc0>
		s++;
	else if (*s == '-')
		s++, neg = 1;
40000ce7:	3c 2d                	cmp    $0x2d,%al
40000ce9:	8d 4a 01             	lea    0x1(%edx),%ecx
40000cec:	0f 94 c0             	sete   %al
40000cef:	0f 44 d1             	cmove  %ecx,%edx
40000cf2:	0f b6 c0             	movzbl %al,%eax

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000cf5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
40000cfb:	75 10                	jne    40000d0d <strtol+0x5d>
40000cfd:	80 3a 30             	cmpb   $0x30,(%edx)
40000d00:	74 7e                	je     40000d80 <strtol+0xd0>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
40000d02:	83 fb 01             	cmp    $0x1,%ebx
40000d05:	19 db                	sbb    %ebx,%ebx
40000d07:	83 e3 fa             	and    $0xfffffffa,%ebx
40000d0a:	83 c3 10             	add    $0x10,%ebx
40000d0d:	89 5d 10             	mov    %ebx,0x10(%ebp)
40000d10:	31 c9                	xor    %ecx,%ecx
40000d12:	89 c7                	mov    %eax,%edi
40000d14:	eb 13                	jmp    40000d29 <strtol+0x79>
40000d16:	66 90                	xchg   %ax,%ax
40000d18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d1f:	00 
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
		s++, val = (val * base) + dig;
40000d20:	0f af 4d 10          	imul   0x10(%ebp),%ecx
40000d24:	83 c2 01             	add    $0x1,%edx
40000d27:	01 f1                	add    %esi,%ecx
		if (*s >= '0' && *s <= '9')
40000d29:	0f be 1a             	movsbl (%edx),%ebx
40000d2c:	8d 43 d0             	lea    -0x30(%ebx),%eax
			dig = *s - '0';
40000d2f:	8d 73 d0             	lea    -0x30(%ebx),%esi
		if (*s >= '0' && *s <= '9')
40000d32:	3c 09                	cmp    $0x9,%al
40000d34:	76 14                	jbe    40000d4a <strtol+0x9a>
		else if (*s >= 'a' && *s <= 'z')
40000d36:	8d 43 9f             	lea    -0x61(%ebx),%eax
			dig = *s - 'a' + 10;
40000d39:	8d 73 a9             	lea    -0x57(%ebx),%esi
		else if (*s >= 'a' && *s <= 'z')
40000d3c:	3c 19                	cmp    $0x19,%al
40000d3e:	76 0a                	jbe    40000d4a <strtol+0x9a>
		else if (*s >= 'A' && *s <= 'Z')
40000d40:	8d 43 bf             	lea    -0x41(%ebx),%eax
40000d43:	3c 19                	cmp    $0x19,%al
40000d45:	77 08                	ja     40000d4f <strtol+0x9f>
			dig = *s - 'A' + 10;
40000d47:	8d 73 c9             	lea    -0x37(%ebx),%esi
		if (dig >= base)
40000d4a:	3b 75 10             	cmp    0x10(%ebp),%esi
40000d4d:	7c d1                	jl     40000d20 <strtol+0x70>
		// we don't properly detect overflow!
	}

	if (endptr)
40000d4f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000d52:	89 f8                	mov    %edi,%eax
40000d54:	85 db                	test   %ebx,%ebx
40000d56:	74 05                	je     40000d5d <strtol+0xad>
		*endptr = (char *) s;
40000d58:	8b 7d 0c             	mov    0xc(%ebp),%edi
40000d5b:	89 17                	mov    %edx,(%edi)
	return (neg ? -val : val);
40000d5d:	89 ca                	mov    %ecx,%edx
}
40000d5f:	5b                   	pop    %ebx
40000d60:	5e                   	pop    %esi
	return (neg ? -val : val);
40000d61:	f7 da                	neg    %edx
40000d63:	85 c0                	test   %eax,%eax
}
40000d65:	5f                   	pop    %edi
40000d66:	5d                   	pop    %ebp
	return (neg ? -val : val);
40000d67:	0f 45 ca             	cmovne %edx,%ecx
}
40000d6a:	89 c8                	mov    %ecx,%eax
40000d6c:	c3                   	ret
40000d6d:	8d 76 00             	lea    0x0(%esi),%esi
		s++;
40000d70:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
40000d73:	31 c0                	xor    %eax,%eax
40000d75:	e9 7b ff ff ff       	jmp    40000cf5 <strtol+0x45>
40000d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000d80:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
40000d84:	74 1b                	je     40000da1 <strtol+0xf1>
	else if (base == 0 && s[0] == '0')
40000d86:	85 db                	test   %ebx,%ebx
40000d88:	74 0a                	je     40000d94 <strtol+0xe4>
40000d8a:	bb 10 00 00 00       	mov    $0x10,%ebx
40000d8f:	e9 79 ff ff ff       	jmp    40000d0d <strtol+0x5d>
		s++, base = 8;
40000d94:	83 c2 01             	add    $0x1,%edx
40000d97:	bb 08 00 00 00       	mov    $0x8,%ebx
40000d9c:	e9 6c ff ff ff       	jmp    40000d0d <strtol+0x5d>
		s += 2, base = 16;
40000da1:	83 c2 02             	add    $0x2,%edx
40000da4:	bb 10 00 00 00       	mov    $0x10,%ebx
40000da9:	e9 5f ff ff ff       	jmp    40000d0d <strtol+0x5d>
40000dae:	66 90                	xchg   %ax,%ax

40000db0 <memset>:

void *
memset(void *v, int c, size_t n)
{
40000db0:	55                   	push   %ebp
40000db1:	89 e5                	mov    %esp,%ebp
40000db3:	57                   	push   %edi
40000db4:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000db7:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000dba:	85 c9                	test   %ecx,%ecx
40000dbc:	74 1a                	je     40000dd8 <memset+0x28>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
40000dbe:	89 d0                	mov    %edx,%eax
40000dc0:	09 c8                	or     %ecx,%eax
40000dc2:	a8 03                	test   $0x3,%al
40000dc4:	75 1a                	jne    40000de0 <memset+0x30>
		c &= 0xFF;
40000dc6:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
40000dca:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000dcd:	89 d7                	mov    %edx,%edi
40000dcf:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
40000dd5:	fc                   	cld
40000dd6:	f3 ab                	rep stos %eax,%es:(%edi)
	} else
		asm volatile("cld; rep stosb\n"
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
}
40000dd8:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000ddb:	89 d0                	mov    %edx,%eax
40000ddd:	c9                   	leave
40000dde:	c3                   	ret
40000ddf:	90                   	nop
		asm volatile("cld; rep stosb\n"
40000de0:	8b 45 0c             	mov    0xc(%ebp),%eax
40000de3:	89 d7                	mov    %edx,%edi
40000de5:	fc                   	cld
40000de6:	f3 aa                	rep stos %al,%es:(%edi)
}
40000de8:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000deb:	89 d0                	mov    %edx,%eax
40000ded:	c9                   	leave
40000dee:	c3                   	ret
40000def:	90                   	nop

40000df0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
40000df0:	55                   	push   %ebp
40000df1:	89 e5                	mov    %esp,%ebp
40000df3:	57                   	push   %edi
40000df4:	8b 45 08             	mov    0x8(%ebp),%eax
40000df7:	8b 55 0c             	mov    0xc(%ebp),%edx
40000dfa:	56                   	push   %esi
40000dfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000dfe:	53                   	push   %ebx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
40000dff:	39 c2                	cmp    %eax,%edx
40000e01:	73 2d                	jae    40000e30 <memmove+0x40>
40000e03:	8d 1c 0a             	lea    (%edx,%ecx,1),%ebx
40000e06:	39 d8                	cmp    %ebx,%eax
40000e08:	73 26                	jae    40000e30 <memmove+0x40>
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000e0a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
40000e0d:	09 ca                	or     %ecx,%edx
40000e0f:	09 da                	or     %ebx,%edx
40000e11:	83 e2 03             	and    $0x3,%edx
40000e14:	74 4a                	je     40000e60 <memmove+0x70>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
				     : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
40000e16:	8d 7c 08 ff          	lea    -0x1(%eax,%ecx,1),%edi
40000e1a:	8d 73 ff             	lea    -0x1(%ebx),%esi
40000e1d:	fd                   	std
40000e1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				     :: "D" (d-1), "S" (s-1), "c" (n)
				     : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
40000e20:	fc                   	cld
			asm volatile("cld; rep movsb\n"
				     :: "D" (d), "S" (s), "c" (n)
				     : "cc", "memory");
	}
	return dst;
}
40000e21:	5b                   	pop    %ebx
40000e22:	5e                   	pop    %esi
40000e23:	5f                   	pop    %edi
40000e24:	5d                   	pop    %ebp
40000e25:	c3                   	ret
40000e26:	66 90                	xchg   %ax,%ax
40000e28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e2f:	00 
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000e30:	89 c3                	mov    %eax,%ebx
40000e32:	09 cb                	or     %ecx,%ebx
40000e34:	09 d3                	or     %edx,%ebx
40000e36:	83 e3 03             	and    $0x3,%ebx
40000e39:	74 15                	je     40000e50 <memmove+0x60>
			asm volatile("cld; rep movsb\n"
40000e3b:	89 c7                	mov    %eax,%edi
40000e3d:	89 d6                	mov    %edx,%esi
40000e3f:	fc                   	cld
40000e40:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000e42:	5b                   	pop    %ebx
40000e43:	5e                   	pop    %esi
40000e44:	5f                   	pop    %edi
40000e45:	5d                   	pop    %ebp
40000e46:	c3                   	ret
40000e47:	90                   	nop
40000e48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e4f:	00 
				     :: "D" (d), "S" (s), "c" (n/4)
40000e50:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
40000e53:	89 c7                	mov    %eax,%edi
40000e55:	89 d6                	mov    %edx,%esi
40000e57:	fc                   	cld
40000e58:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000e5a:	eb e6                	jmp    40000e42 <memmove+0x52>
40000e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			asm volatile("std; rep movsl\n"
40000e60:	8d 7c 08 fc          	lea    -0x4(%eax,%ecx,1),%edi
40000e64:	8d 73 fc             	lea    -0x4(%ebx),%esi
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
40000e67:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
40000e6a:	fd                   	std
40000e6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000e6d:	eb b1                	jmp    40000e20 <memmove+0x30>
40000e6f:	90                   	nop

40000e70 <memcpy>:

void *
memcpy(void *dst, const void *src, size_t n)
{
	return memmove(dst, src, n);
40000e70:	e9 7b ff ff ff       	jmp    40000df0 <memmove>
40000e75:	8d 76 00             	lea    0x0(%esi),%esi
40000e78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e7f:	00 

40000e80 <memcmp>:
}

int
memcmp(const void *v1, const void *v2, size_t n)
{
40000e80:	55                   	push   %ebp
40000e81:	89 e5                	mov    %esp,%ebp
40000e83:	56                   	push   %esi
40000e84:	8b 75 10             	mov    0x10(%ebp),%esi
40000e87:	8b 45 08             	mov    0x8(%ebp),%eax
40000e8a:	53                   	push   %ebx
40000e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
40000e8e:	85 f6                	test   %esi,%esi
40000e90:	74 2e                	je     40000ec0 <memcmp+0x40>
40000e92:	01 c6                	add    %eax,%esi
40000e94:	eb 14                	jmp    40000eaa <memcmp+0x2a>
40000e96:	66 90                	xchg   %ax,%ax
40000e98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e9f:	00 
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
40000ea0:	83 c0 01             	add    $0x1,%eax
40000ea3:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
40000ea6:	39 f0                	cmp    %esi,%eax
40000ea8:	74 16                	je     40000ec0 <memcmp+0x40>
		if (*s1 != *s2)
40000eaa:	0f b6 08             	movzbl (%eax),%ecx
40000ead:	0f b6 1a             	movzbl (%edx),%ebx
40000eb0:	38 d9                	cmp    %bl,%cl
40000eb2:	74 ec                	je     40000ea0 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
40000eb4:	0f b6 c1             	movzbl %cl,%eax
40000eb7:	29 d8                	sub    %ebx,%eax
	}

	return 0;
}
40000eb9:	5b                   	pop    %ebx
40000eba:	5e                   	pop    %esi
40000ebb:	5d                   	pop    %ebp
40000ebc:	c3                   	ret
40000ebd:	8d 76 00             	lea    0x0(%esi),%esi
40000ec0:	5b                   	pop    %ebx
	return 0;
40000ec1:	31 c0                	xor    %eax,%eax
}
40000ec3:	5e                   	pop    %esi
40000ec4:	5d                   	pop    %ebp
40000ec5:	c3                   	ret
40000ec6:	66 90                	xchg   %ax,%ax
40000ec8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ecf:	00 

40000ed0 <memchr>:

void *
memchr(const void *s, int c, size_t n)
{
40000ed0:	55                   	push   %ebp
40000ed1:	89 e5                	mov    %esp,%ebp
40000ed3:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
40000ed6:	8b 55 10             	mov    0x10(%ebp),%edx
40000ed9:	01 c2                	add    %eax,%edx
	for (; s < ends; s++)
40000edb:	39 d0                	cmp    %edx,%eax
40000edd:	73 21                	jae    40000f00 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000edf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
40000ee3:	eb 12                	jmp    40000ef7 <memchr+0x27>
40000ee5:	8d 76 00             	lea    0x0(%esi),%esi
40000ee8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000eef:	00 
	for (; s < ends; s++)
40000ef0:	83 c0 01             	add    $0x1,%eax
40000ef3:	39 c2                	cmp    %eax,%edx
40000ef5:	74 09                	je     40000f00 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000ef7:	38 08                	cmp    %cl,(%eax)
40000ef9:	75 f5                	jne    40000ef0 <memchr+0x20>
			return (void *) s;
	return NULL;
}
40000efb:	5d                   	pop    %ebp
40000efc:	c3                   	ret
40000efd:	8d 76 00             	lea    0x0(%esi),%esi
	return NULL;
40000f00:	31 c0                	xor    %eax,%eax
}
40000f02:	5d                   	pop    %ebp
40000f03:	c3                   	ret
40000f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000f08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f0f:	00 

40000f10 <memzero>:

void *
memzero(void *v, size_t n)
{
40000f10:	55                   	push   %ebp
40000f11:	89 e5                	mov    %esp,%ebp
40000f13:	57                   	push   %edi
40000f14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000f17:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000f1a:	85 c9                	test   %ecx,%ecx
40000f1c:	74 11                	je     40000f2f <memzero+0x1f>
	if ((int)v%4 == 0 && n%4 == 0) {
40000f1e:	89 d0                	mov    %edx,%eax
40000f20:	09 c8                	or     %ecx,%eax
40000f22:	83 e0 03             	and    $0x3,%eax
40000f25:	75 19                	jne    40000f40 <memzero+0x30>
			     :: "D" (v), "a" (c), "c" (n/4)
40000f27:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000f2a:	89 d7                	mov    %edx,%edi
40000f2c:	fc                   	cld
40000f2d:	f3 ab                	rep stos %eax,%es:(%edi)
	return memset(v, 0, n);
}
40000f2f:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000f32:	89 d0                	mov    %edx,%eax
40000f34:	c9                   	leave
40000f35:	c3                   	ret
40000f36:	66 90                	xchg   %ax,%ax
40000f38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f3f:	00 
		asm volatile("cld; rep stosb\n"
40000f40:	89 d7                	mov    %edx,%edi
40000f42:	31 c0                	xor    %eax,%eax
40000f44:	fc                   	cld
40000f45:	f3 aa                	rep stos %al,%es:(%edi)
}
40000f47:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000f4a:	89 d0                	mov    %edx,%eax
40000f4c:	c9                   	leave
40000f4d:	c3                   	ret
40000f4e:	66 90                	xchg   %ax,%ax

40000f50 <sigaction>:
#include <signal.h>
#include <syscall.h>

int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
40000f50:	55                   	push   %ebp

static gcc_inline int
sys_sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
	int errno;
	asm volatile ("int %1"
40000f51:	b8 1a 00 00 00       	mov    $0x1a,%eax
40000f56:	89 e5                	mov    %esp,%ebp
40000f58:	53                   	push   %ebx
40000f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000f5c:	8b 55 10             	mov    0x10(%ebp),%edx
40000f5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000f62:	cd 30                	int    $0x30
		        "a" (SYS_sigaction),
		        "b" (signum),
		        "c" (act),
		        "d" (oldact)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000f64:	f7 d8                	neg    %eax
    return sys_sigaction(signum, act, oldact);
}
40000f66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000f69:	c9                   	leave
40000f6a:	19 c0                	sbb    %eax,%eax
40000f6c:	c3                   	ret
40000f6d:	8d 76 00             	lea    0x0(%esi),%esi

40000f70 <kill>:

int kill(int pid, int signum)
{
40000f70:	55                   	push   %ebp

static gcc_inline int
sys_kill(int pid, int signum)
{
	int errno;
	asm volatile ("int %1"
40000f71:	b8 1b 00 00 00       	mov    $0x1b,%eax
40000f76:	89 e5                	mov    %esp,%ebp
40000f78:	53                   	push   %ebx
40000f79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000f7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000f7f:	cd 30                	int    $0x30
		      : "i" (T_SYSCALL),
		        "a" (SYS_kill),
		        "b" (pid),
		        "c" (signum)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000f81:	f7 d8                	neg    %eax
    return sys_kill(pid, signum);
}
40000f83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000f86:	c9                   	leave
40000f87:	19 c0                	sbb    %eax,%eax
40000f89:	c3                   	ret
40000f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000f90 <pause>:

static gcc_inline int
sys_pause(void)
{
	int errno;
	asm volatile ("int %1"
40000f90:	b8 1c 00 00 00       	mov    $0x1c,%eax
40000f95:	cd 30                	int    $0x30
		      : "=a" (errno)
		      : "i" (T_SYSCALL),
		        "a" (SYS_pause)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000f97:	f7 d8                	neg    %eax
40000f99:	19 c0                	sbb    %eax,%eax

int pause(void)
{
    return sys_pause();
}
40000f9b:	c3                   	ret
40000f9c:	66 90                	xchg   %ax,%ax
40000f9e:	66 90                	xchg   %ax,%ax

40000fa0 <__udivdi3>:
40000fa0:	55                   	push   %ebp
40000fa1:	89 e5                	mov    %esp,%ebp
40000fa3:	57                   	push   %edi
40000fa4:	56                   	push   %esi
40000fa5:	53                   	push   %ebx
40000fa6:	83 ec 1c             	sub    $0x1c,%esp
40000fa9:	8b 75 08             	mov    0x8(%ebp),%esi
40000fac:	8b 45 14             	mov    0x14(%ebp),%eax
40000faf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000fb2:	8b 7d 10             	mov    0x10(%ebp),%edi
40000fb5:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40000fb8:	85 c0                	test   %eax,%eax
40000fba:	75 1c                	jne    40000fd8 <__udivdi3+0x38>
40000fbc:	39 fb                	cmp    %edi,%ebx
40000fbe:	73 50                	jae    40001010 <__udivdi3+0x70>
40000fc0:	89 f0                	mov    %esi,%eax
40000fc2:	31 f6                	xor    %esi,%esi
40000fc4:	89 da                	mov    %ebx,%edx
40000fc6:	f7 f7                	div    %edi
40000fc8:	89 f2                	mov    %esi,%edx
40000fca:	83 c4 1c             	add    $0x1c,%esp
40000fcd:	5b                   	pop    %ebx
40000fce:	5e                   	pop    %esi
40000fcf:	5f                   	pop    %edi
40000fd0:	5d                   	pop    %ebp
40000fd1:	c3                   	ret
40000fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000fd8:	39 c3                	cmp    %eax,%ebx
40000fda:	73 14                	jae    40000ff0 <__udivdi3+0x50>
40000fdc:	31 f6                	xor    %esi,%esi
40000fde:	31 c0                	xor    %eax,%eax
40000fe0:	89 f2                	mov    %esi,%edx
40000fe2:	83 c4 1c             	add    $0x1c,%esp
40000fe5:	5b                   	pop    %ebx
40000fe6:	5e                   	pop    %esi
40000fe7:	5f                   	pop    %edi
40000fe8:	5d                   	pop    %ebp
40000fe9:	c3                   	ret
40000fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000ff0:	0f bd f0             	bsr    %eax,%esi
40000ff3:	83 f6 1f             	xor    $0x1f,%esi
40000ff6:	75 48                	jne    40001040 <__udivdi3+0xa0>
40000ff8:	39 d8                	cmp    %ebx,%eax
40000ffa:	72 07                	jb     40001003 <__udivdi3+0x63>
40000ffc:	31 c0                	xor    %eax,%eax
40000ffe:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
40001001:	72 dd                	jb     40000fe0 <__udivdi3+0x40>
40001003:	b8 01 00 00 00       	mov    $0x1,%eax
40001008:	eb d6                	jmp    40000fe0 <__udivdi3+0x40>
4000100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001010:	89 f9                	mov    %edi,%ecx
40001012:	85 ff                	test   %edi,%edi
40001014:	75 0b                	jne    40001021 <__udivdi3+0x81>
40001016:	b8 01 00 00 00       	mov    $0x1,%eax
4000101b:	31 d2                	xor    %edx,%edx
4000101d:	f7 f7                	div    %edi
4000101f:	89 c1                	mov    %eax,%ecx
40001021:	31 d2                	xor    %edx,%edx
40001023:	89 d8                	mov    %ebx,%eax
40001025:	f7 f1                	div    %ecx
40001027:	89 c6                	mov    %eax,%esi
40001029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
4000102c:	f7 f1                	div    %ecx
4000102e:	89 f2                	mov    %esi,%edx
40001030:	83 c4 1c             	add    $0x1c,%esp
40001033:	5b                   	pop    %ebx
40001034:	5e                   	pop    %esi
40001035:	5f                   	pop    %edi
40001036:	5d                   	pop    %ebp
40001037:	c3                   	ret
40001038:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000103f:	00 
40001040:	89 f1                	mov    %esi,%ecx
40001042:	ba 20 00 00 00       	mov    $0x20,%edx
40001047:	29 f2                	sub    %esi,%edx
40001049:	d3 e0                	shl    %cl,%eax
4000104b:	89 45 e0             	mov    %eax,-0x20(%ebp)
4000104e:	89 d1                	mov    %edx,%ecx
40001050:	89 f8                	mov    %edi,%eax
40001052:	d3 e8                	shr    %cl,%eax
40001054:	8b 4d e0             	mov    -0x20(%ebp),%ecx
40001057:	09 c1                	or     %eax,%ecx
40001059:	89 d8                	mov    %ebx,%eax
4000105b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
4000105e:	89 f1                	mov    %esi,%ecx
40001060:	d3 e7                	shl    %cl,%edi
40001062:	89 d1                	mov    %edx,%ecx
40001064:	d3 e8                	shr    %cl,%eax
40001066:	89 f1                	mov    %esi,%ecx
40001068:	89 7d dc             	mov    %edi,-0x24(%ebp)
4000106b:	89 45 d8             	mov    %eax,-0x28(%ebp)
4000106e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40001071:	d3 e3                	shl    %cl,%ebx
40001073:	89 d1                	mov    %edx,%ecx
40001075:	8b 55 d8             	mov    -0x28(%ebp),%edx
40001078:	d3 e8                	shr    %cl,%eax
4000107a:	09 d8                	or     %ebx,%eax
4000107c:	f7 75 e0             	divl   -0x20(%ebp)
4000107f:	89 d3                	mov    %edx,%ebx
40001081:	89 c7                	mov    %eax,%edi
40001083:	f7 65 dc             	mull   -0x24(%ebp)
40001086:	89 45 e0             	mov    %eax,-0x20(%ebp)
40001089:	39 d3                	cmp    %edx,%ebx
4000108b:	72 23                	jb     400010b0 <__udivdi3+0x110>
4000108d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40001090:	89 f1                	mov    %esi,%ecx
40001092:	d3 e0                	shl    %cl,%eax
40001094:	3b 45 e0             	cmp    -0x20(%ebp),%eax
40001097:	73 04                	jae    4000109d <__udivdi3+0xfd>
40001099:	39 d3                	cmp    %edx,%ebx
4000109b:	74 13                	je     400010b0 <__udivdi3+0x110>
4000109d:	89 f8                	mov    %edi,%eax
4000109f:	31 f6                	xor    %esi,%esi
400010a1:	e9 3a ff ff ff       	jmp    40000fe0 <__udivdi3+0x40>
400010a6:	66 90                	xchg   %ax,%ax
400010a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400010af:	00 
400010b0:	8d 47 ff             	lea    -0x1(%edi),%eax
400010b3:	31 f6                	xor    %esi,%esi
400010b5:	e9 26 ff ff ff       	jmp    40000fe0 <__udivdi3+0x40>
400010ba:	66 90                	xchg   %ax,%ax
400010bc:	66 90                	xchg   %ax,%ax
400010be:	66 90                	xchg   %ax,%ax

400010c0 <__umoddi3>:
400010c0:	55                   	push   %ebp
400010c1:	89 e5                	mov    %esp,%ebp
400010c3:	57                   	push   %edi
400010c4:	56                   	push   %esi
400010c5:	53                   	push   %ebx
400010c6:	83 ec 2c             	sub    $0x2c,%esp
400010c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
400010cc:	8b 45 14             	mov    0x14(%ebp),%eax
400010cf:	8b 75 08             	mov    0x8(%ebp),%esi
400010d2:	8b 7d 10             	mov    0x10(%ebp),%edi
400010d5:	89 da                	mov    %ebx,%edx
400010d7:	85 c0                	test   %eax,%eax
400010d9:	75 15                	jne    400010f0 <__umoddi3+0x30>
400010db:	39 fb                	cmp    %edi,%ebx
400010dd:	73 51                	jae    40001130 <__umoddi3+0x70>
400010df:	89 f0                	mov    %esi,%eax
400010e1:	f7 f7                	div    %edi
400010e3:	89 d0                	mov    %edx,%eax
400010e5:	31 d2                	xor    %edx,%edx
400010e7:	83 c4 2c             	add    $0x2c,%esp
400010ea:	5b                   	pop    %ebx
400010eb:	5e                   	pop    %esi
400010ec:	5f                   	pop    %edi
400010ed:	5d                   	pop    %ebp
400010ee:	c3                   	ret
400010ef:	90                   	nop
400010f0:	89 75 e0             	mov    %esi,-0x20(%ebp)
400010f3:	39 c3                	cmp    %eax,%ebx
400010f5:	73 11                	jae    40001108 <__umoddi3+0x48>
400010f7:	89 f0                	mov    %esi,%eax
400010f9:	83 c4 2c             	add    $0x2c,%esp
400010fc:	5b                   	pop    %ebx
400010fd:	5e                   	pop    %esi
400010fe:	5f                   	pop    %edi
400010ff:	5d                   	pop    %ebp
40001100:	c3                   	ret
40001101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001108:	0f bd c8             	bsr    %eax,%ecx
4000110b:	83 f1 1f             	xor    $0x1f,%ecx
4000110e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
40001111:	75 3d                	jne    40001150 <__umoddi3+0x90>
40001113:	39 d8                	cmp    %ebx,%eax
40001115:	0f 82 cd 00 00 00    	jb     400011e8 <__umoddi3+0x128>
4000111b:	39 fe                	cmp    %edi,%esi
4000111d:	0f 83 c5 00 00 00    	jae    400011e8 <__umoddi3+0x128>
40001123:	8b 45 e0             	mov    -0x20(%ebp),%eax
40001126:	83 c4 2c             	add    $0x2c,%esp
40001129:	5b                   	pop    %ebx
4000112a:	5e                   	pop    %esi
4000112b:	5f                   	pop    %edi
4000112c:	5d                   	pop    %ebp
4000112d:	c3                   	ret
4000112e:	66 90                	xchg   %ax,%ax
40001130:	89 f9                	mov    %edi,%ecx
40001132:	85 ff                	test   %edi,%edi
40001134:	75 0b                	jne    40001141 <__umoddi3+0x81>
40001136:	b8 01 00 00 00       	mov    $0x1,%eax
4000113b:	31 d2                	xor    %edx,%edx
4000113d:	f7 f7                	div    %edi
4000113f:	89 c1                	mov    %eax,%ecx
40001141:	89 d8                	mov    %ebx,%eax
40001143:	31 d2                	xor    %edx,%edx
40001145:	f7 f1                	div    %ecx
40001147:	89 f0                	mov    %esi,%eax
40001149:	f7 f1                	div    %ecx
4000114b:	eb 96                	jmp    400010e3 <__umoddi3+0x23>
4000114d:	8d 76 00             	lea    0x0(%esi),%esi
40001150:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001154:	ba 20 00 00 00       	mov    $0x20,%edx
40001159:	2b 55 e4             	sub    -0x1c(%ebp),%edx
4000115c:	89 55 e0             	mov    %edx,-0x20(%ebp)
4000115f:	d3 e0                	shl    %cl,%eax
40001161:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
40001165:	89 45 dc             	mov    %eax,-0x24(%ebp)
40001168:	89 f8                	mov    %edi,%eax
4000116a:	8b 55 dc             	mov    -0x24(%ebp),%edx
4000116d:	d3 e8                	shr    %cl,%eax
4000116f:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001173:	09 c2                	or     %eax,%edx
40001175:	d3 e7                	shl    %cl,%edi
40001177:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
4000117b:	89 55 dc             	mov    %edx,-0x24(%ebp)
4000117e:	89 da                	mov    %ebx,%edx
40001180:	89 7d d8             	mov    %edi,-0x28(%ebp)
40001183:	89 f7                	mov    %esi,%edi
40001185:	d3 ea                	shr    %cl,%edx
40001187:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
4000118b:	d3 e3                	shl    %cl,%ebx
4000118d:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
40001191:	d3 ef                	shr    %cl,%edi
40001193:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001197:	89 f8                	mov    %edi,%eax
40001199:	d3 e6                	shl    %cl,%esi
4000119b:	09 d8                	or     %ebx,%eax
4000119d:	f7 75 dc             	divl   -0x24(%ebp)
400011a0:	89 d3                	mov    %edx,%ebx
400011a2:	89 75 d4             	mov    %esi,-0x2c(%ebp)
400011a5:	89 f7                	mov    %esi,%edi
400011a7:	f7 65 d8             	mull   -0x28(%ebp)
400011aa:	89 c6                	mov    %eax,%esi
400011ac:	89 d1                	mov    %edx,%ecx
400011ae:	39 d3                	cmp    %edx,%ebx
400011b0:	72 06                	jb     400011b8 <__umoddi3+0xf8>
400011b2:	75 0e                	jne    400011c2 <__umoddi3+0x102>
400011b4:	39 c7                	cmp    %eax,%edi
400011b6:	73 0a                	jae    400011c2 <__umoddi3+0x102>
400011b8:	2b 45 d8             	sub    -0x28(%ebp),%eax
400011bb:	1b 55 dc             	sbb    -0x24(%ebp),%edx
400011be:	89 d1                	mov    %edx,%ecx
400011c0:	89 c6                	mov    %eax,%esi
400011c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
400011c5:	29 f0                	sub    %esi,%eax
400011c7:	19 cb                	sbb    %ecx,%ebx
400011c9:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
400011cd:	89 da                	mov    %ebx,%edx
400011cf:	d3 e2                	shl    %cl,%edx
400011d1:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400011d5:	d3 e8                	shr    %cl,%eax
400011d7:	d3 eb                	shr    %cl,%ebx
400011d9:	09 d0                	or     %edx,%eax
400011db:	89 da                	mov    %ebx,%edx
400011dd:	83 c4 2c             	add    $0x2c,%esp
400011e0:	5b                   	pop    %ebx
400011e1:	5e                   	pop    %esi
400011e2:	5f                   	pop    %edi
400011e3:	5d                   	pop    %ebp
400011e4:	c3                   	ret
400011e5:	8d 76 00             	lea    0x0(%esi),%esi
400011e8:	89 da                	mov    %ebx,%edx
400011ea:	29 fe                	sub    %edi,%esi
400011ec:	19 c2                	sbb    %eax,%edx
400011ee:	89 75 e0             	mov    %esi,-0x20(%ebp)
400011f1:	e9 2d ff ff ff       	jmp    40001123 <__umoddi3+0x63>
