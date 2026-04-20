
obj/user/pingpong/pong:     file format elf32-i386


Disassembly of section .text:

40000000 <main>:
#include <stdio.h>
#include <syscall.h>
#include <x86.h>

int main (int argc, char **argv)
{
40000000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
40000004:	83 e4 f0             	and    $0xfffffff0,%esp
    char msg_buf[100];
    char msg[] = "Hello ping, this is pong.";
40000007:	b8 2e 00 00 00       	mov    $0x2e,%eax
{
4000000c:	ff 71 fc             	push   -0x4(%ecx)
4000000f:	55                   	push   %ebp
40000010:	89 e5                	mov    %esp,%ebp
40000012:	53                   	push   %ebx
}
static gcc_inline int
sys_sync_receive(int send_pid, char* addr, size_t len)
{
       int errno, length;
	asm volatile("int %2"
40000013:	bb 07 00 00 00       	mov    $0x7,%ebx
40000018:	51                   	push   %ecx
40000019:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
    char msg[] = "Hello ping, this is pong.";
4000001f:	c7 45 82 6e 67 2c 20 	movl   $0x202c676e,-0x7e(%ebp)
    printf("[pong] started.\n");
40000026:	68 74 12 00 40       	push   $0x40001274
    char msg[] = "Hello ping, this is pong.";
4000002b:	c7 85 7a ff ff ff 48 	movl   $0x6c6c6548,-0x86(%ebp)
40000032:	65 6c 6c 
40000035:	c7 85 7e ff ff ff 6f 	movl   $0x6970206f,-0x82(%ebp)
4000003c:	20 70 69 
4000003f:	c7 45 86 74 68 69 73 	movl   $0x73696874,-0x7a(%ebp)
40000046:	c7 45 8a 20 69 73 20 	movl   $0x20736920,-0x76(%ebp)
4000004d:	c7 45 8e 70 6f 6e 67 	movl   $0x676e6f70,-0x72(%ebp)
40000054:	66 89 45 92          	mov    %ax,-0x6e(%ebp)
    printf("[pong] started.\n");
40000058:	e8 a3 02 00 00       	call   40000300 <printf>
    printf("[pong] recving msg...\n");
4000005d:	c7 04 24 85 12 00 40 	movl   $0x40001285,(%esp)
40000064:	e8 97 02 00 00       	call   40000300 <printf>
40000069:	8d 4d 94             	lea    -0x6c(%ebp),%ecx
4000006c:	b8 10 00 00 00       	mov    $0x10,%eax
40000071:	ba 64 00 00 00       	mov    $0x64,%edx
40000076:	cd 30                	int    $0x30
    sys_sync_receive(7, msg_buf, sizeof(msg_buf));
    printf("[pong] msg from proc %d: %s\n", 4, msg_buf);
40000078:	83 c4 0c             	add    $0xc,%esp
	asm volatile("int %0" :
4000007b:	bb 07 00 00 00       	mov    $0x7,%ebx
40000080:	51                   	push   %ecx
40000081:	6a 04                	push   $0x4
40000083:	68 9c 12 00 40       	push   $0x4000129c
40000088:	e8 73 02 00 00       	call   40000300 <printf>
    printf("[pong] sending msg...\n");
4000008d:	c7 04 24 b9 12 00 40 	movl   $0x400012b9,(%esp)
40000094:	e8 67 02 00 00       	call   40000300 <printf>
40000099:	8d 8d 7a ff ff ff    	lea    -0x86(%ebp),%ecx
4000009f:	b8 0f 00 00 00       	mov    $0xf,%eax
400000a4:	ba 1a 00 00 00       	mov    $0x1a,%edx
400000a9:	cd 30                	int    $0x30
    sys_sync_send(7, msg, sizeof(msg));
    printf("[pong] msg sent.");
400000ab:	c7 04 24 d0 12 00 40 	movl   $0x400012d0,(%esp)
400000b2:	e8 49 02 00 00       	call   40000300 <printf>
400000b7:	83 c4 10             	add    $0x10,%esp
    while(1) ; 
400000ba:	eb fe                	jmp    400000ba <main+0xba>

400000bc <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary/
	 */
	testl	$0x0fffffff, %esp
400000bc:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
400000c2:	75 04                	jne    400000c8 <args_exist>

400000c4 <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
400000c4:	6a 00                	push   $0x0
	pushl	$0
400000c6:	6a 00                	push   $0x0

400000c8 <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
400000c8:	e8 33 ff ff ff       	call   40000000 <main>

	/* When returning, save return value */
	pushl	%eax
400000cd:	50                   	push   %eax

	/* Syscall SYS_exit (30) */
	movl	$30, %eax
400000ce:	b8 1e 00 00 00       	mov    $0x1e,%eax
	int	$48
400000d3:	cd 30                	int    $0x30

400000d5 <spin>:

spin:
	call	yield
400000d5:	e8 16 09 00 00       	call   400009f0 <yield>
	jmp	spin
400000da:	eb f9                	jmp    400000d5 <spin>
400000dc:	66 90                	xchg   %ax,%ax
400000de:	66 90                	xchg   %ax,%ax

400000e0 <debug>:
#include <stdarg.h>
#include <stdio.h>

void
debug(const char *file, int line, const char *fmt, ...)
{
400000e0:	55                   	push   %ebp
400000e1:	89 e5                	mov    %esp,%ebp
400000e3:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[D] %s:%d: ", file, line);
400000e6:	ff 75 0c             	push   0xc(%ebp)
400000e9:	ff 75 08             	push   0x8(%ebp)
400000ec:	68 38 12 00 40       	push   $0x40001238
400000f1:	e8 0a 02 00 00       	call   40000300 <printf>
	vcprintf(fmt, ap);
400000f6:	58                   	pop    %eax
400000f7:	8d 45 14             	lea    0x14(%ebp),%eax
400000fa:	5a                   	pop    %edx
400000fb:	50                   	push   %eax
400000fc:	ff 75 10             	push   0x10(%ebp)
400000ff:	e8 9c 01 00 00       	call   400002a0 <vcprintf>
	va_end(ap);
}
40000104:	83 c4 10             	add    $0x10,%esp
40000107:	c9                   	leave
40000108:	c3                   	ret
40000109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000110 <warn>:

void
warn(const char *file, int line, const char *fmt, ...)
{
40000110:	55                   	push   %ebp
40000111:	89 e5                	mov    %esp,%ebp
40000113:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[W] %s:%d: ", file, line);
40000116:	ff 75 0c             	push   0xc(%ebp)
40000119:	ff 75 08             	push   0x8(%ebp)
4000011c:	68 44 12 00 40       	push   $0x40001244
40000121:	e8 da 01 00 00       	call   40000300 <printf>
	vcprintf(fmt, ap);
40000126:	58                   	pop    %eax
40000127:	8d 45 14             	lea    0x14(%ebp),%eax
4000012a:	5a                   	pop    %edx
4000012b:	50                   	push   %eax
4000012c:	ff 75 10             	push   0x10(%ebp)
4000012f:	e8 6c 01 00 00       	call   400002a0 <vcprintf>
	va_end(ap);
}
40000134:	83 c4 10             	add    $0x10,%esp
40000137:	c9                   	leave
40000138:	c3                   	ret
40000139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000140 <panic>:

void
panic(const char *file, int line, const char *fmt, ...)
{
40000140:	55                   	push   %ebp
40000141:	89 e5                	mov    %esp,%ebp
40000143:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[P] %s:%d: ", file, line);
40000146:	ff 75 0c             	push   0xc(%ebp)
40000149:	ff 75 08             	push   0x8(%ebp)
4000014c:	68 50 12 00 40       	push   $0x40001250
40000151:	e8 aa 01 00 00       	call   40000300 <printf>
	vcprintf(fmt, ap);
40000156:	58                   	pop    %eax
40000157:	8d 45 14             	lea    0x14(%ebp),%eax
4000015a:	5a                   	pop    %edx
4000015b:	50                   	push   %eax
4000015c:	ff 75 10             	push   0x10(%ebp)
4000015f:	e8 3c 01 00 00       	call   400002a0 <vcprintf>
40000164:	83 c4 10             	add    $0x10,%esp
40000167:	90                   	nop
40000168:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000016f:	00 
	va_end(ap);

	while (1)
		yield();
40000170:	e8 7b 08 00 00       	call   400009f0 <yield>
	while (1)
40000175:	eb f9                	jmp    40000170 <panic+0x30>
40000177:	66 90                	xchg   %ax,%ax
40000179:	66 90                	xchg   %ax,%ax
4000017b:	66 90                	xchg   %ax,%ax
4000017d:	66 90                	xchg   %ax,%ax
4000017f:	90                   	nop

40000180 <atoi>:
#include <stdlib.h>

int
atoi(const char *buf, int *i)
{
40000180:	55                   	push   %ebp
40000181:	89 e5                	mov    %esp,%ebp
40000183:	57                   	push   %edi
40000184:	56                   	push   %esi
40000185:	53                   	push   %ebx
40000186:	83 ec 04             	sub    $0x4,%esp
40000189:	8b 75 08             	mov    0x8(%ebp),%esi
	int loc = 0;
	int numstart = 0;
	int acc = 0;
	int negative = 0;
	if (buf[loc] == '+')
4000018c:	0f b6 06             	movzbl (%esi),%eax
4000018f:	3c 2b                	cmp    $0x2b,%al
40000191:	0f 84 89 00 00 00    	je     40000220 <atoi+0xa0>
		loc++;
	else if (buf[loc] == '-') {
40000197:	3c 2d                	cmp    $0x2d,%al
40000199:	74 65                	je     40000200 <atoi+0x80>
		negative = 1;
		loc++;
	}
	numstart = loc;
	// no grab the numbers
	while ('0' <= buf[loc] && buf[loc] <= '9') {
4000019b:	8d 50 d0             	lea    -0x30(%eax),%edx
	int negative = 0;
4000019e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int loc = 0;
400001a5:	31 ff                	xor    %edi,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400001a7:	80 fa 09             	cmp    $0x9,%dl
400001aa:	0f 87 8c 00 00 00    	ja     4000023c <atoi+0xbc>
	int loc = 0;
400001b0:	89 f9                	mov    %edi,%ecx
	int acc = 0;
400001b2:	31 d2                	xor    %edx,%edx
400001b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400001b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400001bf:	00 
		acc = acc*10 + (buf[loc]-'0');
400001c0:	83 e8 30             	sub    $0x30,%eax
400001c3:	8d 14 92             	lea    (%edx,%edx,4),%edx
		loc++;
400001c6:	83 c1 01             	add    $0x1,%ecx
		acc = acc*10 + (buf[loc]-'0');
400001c9:	0f be c0             	movsbl %al,%eax
400001cc:	8d 14 50             	lea    (%eax,%edx,2),%edx
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400001cf:	0f b6 04 0e          	movzbl (%esi,%ecx,1),%eax
400001d3:	8d 58 d0             	lea    -0x30(%eax),%ebx
400001d6:	80 fb 09             	cmp    $0x9,%bl
400001d9:	76 e5                	jbe    400001c0 <atoi+0x40>
	}
	if (numstart == loc) {
400001db:	39 f9                	cmp    %edi,%ecx
400001dd:	74 5d                	je     4000023c <atoi+0xbc>
		// no numbers have actually been scanned
		return 0;
	}
	if (negative)
		acc = - acc;
400001df:	8b 5d f0             	mov    -0x10(%ebp),%ebx
400001e2:	89 d0                	mov    %edx,%eax
400001e4:	f7 d8                	neg    %eax
400001e6:	85 db                	test   %ebx,%ebx
400001e8:	0f 45 d0             	cmovne %eax,%edx
	*i = acc;
400001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
400001ee:	89 10                	mov    %edx,(%eax)
	return loc;
}
400001f0:	83 c4 04             	add    $0x4,%esp
400001f3:	89 c8                	mov    %ecx,%eax
400001f5:	5b                   	pop    %ebx
400001f6:	5e                   	pop    %esi
400001f7:	5f                   	pop    %edi
400001f8:	5d                   	pop    %ebp
400001f9:	c3                   	ret
400001fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000200:	0f b6 46 01          	movzbl 0x1(%esi),%eax
40000204:	8d 50 d0             	lea    -0x30(%eax),%edx
40000207:	80 fa 09             	cmp    $0x9,%dl
4000020a:	77 30                	ja     4000023c <atoi+0xbc>
		negative = 1;
4000020c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		loc++;
40000213:	bf 01 00 00 00       	mov    $0x1,%edi
40000218:	eb 96                	jmp    400001b0 <atoi+0x30>
4000021a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000220:	0f b6 46 01          	movzbl 0x1(%esi),%eax
	int negative = 0;
40000224:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		loc++;
4000022b:	bf 01 00 00 00       	mov    $0x1,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000230:	8d 50 d0             	lea    -0x30(%eax),%edx
40000233:	80 fa 09             	cmp    $0x9,%dl
40000236:	0f 86 74 ff ff ff    	jbe    400001b0 <atoi+0x30>
}
4000023c:	83 c4 04             	add    $0x4,%esp
		return 0;
4000023f:	31 c9                	xor    %ecx,%ecx
}
40000241:	5b                   	pop    %ebx
40000242:	89 c8                	mov    %ecx,%eax
40000244:	5e                   	pop    %esi
40000245:	5f                   	pop    %edi
40000246:	5d                   	pop    %ebp
40000247:	c3                   	ret
40000248:	66 90                	xchg   %ax,%ax
4000024a:	66 90                	xchg   %ax,%ax
4000024c:	66 90                	xchg   %ax,%ax
4000024e:	66 90                	xchg   %ax,%ax

40000250 <putch>:
	char buf[MAX_BUF];
};

static void
putch(int ch, struct printbuf *b)
{
40000250:	55                   	push   %ebp
40000251:	89 e5                	mov    %esp,%ebp
40000253:	56                   	push   %esi
40000254:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
40000257:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
4000025a:	53                   	push   %ebx
	b->buf[b->idx++] = ch;
4000025b:	8b 06                	mov    (%esi),%eax
4000025d:	8d 50 01             	lea    0x1(%eax),%edx
40000260:	89 16                	mov    %edx,(%esi)
40000262:	88 4c 06 08          	mov    %cl,0x8(%esi,%eax,1)
	if (b->idx == MAX_BUF-1) {
40000266:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
4000026c:	75 1c                	jne    4000028a <putch+0x3a>
		b->buf[b->idx] = 0;
4000026e:	c6 86 07 10 00 00 00 	movb   $0x0,0x1007(%esi)
		puts(b->buf, b->idx);
40000275:	8d 4e 08             	lea    0x8(%esi),%ecx
sys_write(int fd, char *p, int n)
{
	int errno;
	size_t ret;

	asm volatile("int %2"
40000278:	b8 08 00 00 00       	mov    $0x8,%eax
4000027d:	bb 01 00 00 00       	mov    $0x1,%ebx
40000282:	cd 30                	int    $0x30
		b->idx = 0;
40000284:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	}
	b->cnt++;
4000028a:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
4000028e:	5b                   	pop    %ebx
4000028f:	5e                   	pop    %esi
40000290:	5d                   	pop    %ebp
40000291:	c3                   	ret
40000292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000298:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000029f:	00 

400002a0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
400002a0:	55                   	push   %ebp
400002a1:	89 e5                	mov    %esp,%ebp
400002a3:	53                   	push   %ebx
400002a4:	bb 01 00 00 00       	mov    $0x1,%ebx
	struct printbuf b;

	b.idx = 0;
	b.cnt = 0;
	vprintfmt((void*)putch, &b, fmt, ap);
400002a9:	8d 85 f0 ef ff ff    	lea    -0x1010(%ebp),%eax
{
400002af:	81 ec 14 10 00 00    	sub    $0x1014,%esp
	vprintfmt((void*)putch, &b, fmt, ap);
400002b5:	ff 75 0c             	push   0xc(%ebp)
400002b8:	ff 75 08             	push   0x8(%ebp)
400002bb:	50                   	push   %eax
400002bc:	68 50 02 00 40       	push   $0x40000250
	b.idx = 0;
400002c1:	c7 85 f0 ef ff ff 00 	movl   $0x0,-0x1010(%ebp)
400002c8:	00 00 00 
	b.cnt = 0;
400002cb:	c7 85 f4 ef ff ff 00 	movl   $0x0,-0x100c(%ebp)
400002d2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
400002d5:	e8 26 01 00 00       	call   40000400 <vprintfmt>

	b.buf[b.idx] = 0;
400002da:	8b 95 f0 ef ff ff    	mov    -0x1010(%ebp),%edx
400002e0:	8d 8d f8 ef ff ff    	lea    -0x1008(%ebp),%ecx
400002e6:	b8 08 00 00 00       	mov    $0x8,%eax
400002eb:	c6 84 15 f8 ef ff ff 	movb   $0x0,-0x1008(%ebp,%edx,1)
400002f2:	00 
400002f3:	cd 30                	int    $0x30
	puts(b.buf, b.idx);

	return b.cnt;
}
400002f5:	8b 85 f4 ef ff ff    	mov    -0x100c(%ebp),%eax
400002fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
400002fe:	c9                   	leave
400002ff:	c3                   	ret

40000300 <printf>:

int
printf(const char *fmt, ...)
{
40000300:	55                   	push   %ebp
40000301:	89 e5                	mov    %esp,%ebp
40000303:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
40000306:	8d 45 0c             	lea    0xc(%ebp),%eax
40000309:	50                   	push   %eax
4000030a:	ff 75 08             	push   0x8(%ebp)
4000030d:	e8 8e ff ff ff       	call   400002a0 <vcprintf>
	va_end(ap);

	return cnt;
}
40000312:	c9                   	leave
40000313:	c3                   	ret
40000314:	66 90                	xchg   %ax,%ax
40000316:	66 90                	xchg   %ax,%ax
40000318:	66 90                	xchg   %ax,%ax
4000031a:	66 90                	xchg   %ax,%ax
4000031c:	66 90                	xchg   %ax,%ax
4000031e:	66 90                	xchg   %ax,%ax

40000320 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
40000320:	55                   	push   %ebp
40000321:	89 e5                	mov    %esp,%ebp
40000323:	57                   	push   %edi
40000324:	89 c7                	mov    %eax,%edi
40000326:	56                   	push   %esi
40000327:	89 d6                	mov    %edx,%esi
40000329:	53                   	push   %ebx
4000032a:	83 ec 2c             	sub    $0x2c,%esp
4000032d:	8b 45 08             	mov    0x8(%ebp),%eax
40000330:	8b 55 0c             	mov    0xc(%ebp),%edx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
40000333:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
{
4000033a:	8b 4d 18             	mov    0x18(%ebp),%ecx
4000033d:	89 45 d8             	mov    %eax,-0x28(%ebp)
40000340:	8b 45 10             	mov    0x10(%ebp),%eax
40000343:	89 55 dc             	mov    %edx,-0x24(%ebp)
40000346:	8b 55 14             	mov    0x14(%ebp),%edx
40000349:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	if (num >= base) {
4000034c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
4000034f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
40000352:	1b 4d d4             	sbb    -0x2c(%ebp),%ecx
40000355:	89 45 d0             	mov    %eax,-0x30(%ebp)
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
40000358:	8d 5a ff             	lea    -0x1(%edx),%ebx
	if (num >= base) {
4000035b:	73 53                	jae    400003b0 <printnum+0x90>
		while (--width > 0)
4000035d:	83 fa 01             	cmp    $0x1,%edx
40000360:	7e 1f                	jle    40000381 <printnum+0x61>
40000362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000368:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000036f:	00 
			putch(padc, putdat);
40000370:	83 ec 08             	sub    $0x8,%esp
40000373:	56                   	push   %esi
40000374:	ff 75 e4             	push   -0x1c(%ebp)
40000377:	ff d7                	call   *%edi
		while (--width > 0)
40000379:	83 c4 10             	add    $0x10,%esp
4000037c:	83 eb 01             	sub    $0x1,%ebx
4000037f:	75 ef                	jne    40000370 <printnum+0x50>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
40000381:	89 75 0c             	mov    %esi,0xc(%ebp)
40000384:	ff 75 d4             	push   -0x2c(%ebp)
40000387:	ff 75 d0             	push   -0x30(%ebp)
4000038a:	ff 75 dc             	push   -0x24(%ebp)
4000038d:	ff 75 d8             	push   -0x28(%ebp)
40000390:	e8 6b 0d 00 00       	call   40001100 <__umoddi3>
40000395:	83 c4 10             	add    $0x10,%esp
40000398:	0f be 80 5c 12 00 40 	movsbl 0x4000125c(%eax),%eax
4000039f:	89 45 08             	mov    %eax,0x8(%ebp)
}
400003a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
	putch("0123456789abcdef"[num % base], putdat);
400003a5:	89 f8                	mov    %edi,%eax
}
400003a7:	5b                   	pop    %ebx
400003a8:	5e                   	pop    %esi
400003a9:	5f                   	pop    %edi
400003aa:	5d                   	pop    %ebp
	putch("0123456789abcdef"[num % base], putdat);
400003ab:	ff e0                	jmp    *%eax
400003ad:	8d 76 00             	lea    0x0(%esi),%esi
		printnum(putch, putdat, num / base, base, width - 1, padc);
400003b0:	83 ec 0c             	sub    $0xc,%esp
400003b3:	ff 75 e4             	push   -0x1c(%ebp)
400003b6:	53                   	push   %ebx
400003b7:	50                   	push   %eax
400003b8:	83 ec 08             	sub    $0x8,%esp
400003bb:	ff 75 d4             	push   -0x2c(%ebp)
400003be:	ff 75 d0             	push   -0x30(%ebp)
400003c1:	ff 75 dc             	push   -0x24(%ebp)
400003c4:	ff 75 d8             	push   -0x28(%ebp)
400003c7:	e8 14 0c 00 00       	call   40000fe0 <__udivdi3>
400003cc:	83 c4 18             	add    $0x18,%esp
400003cf:	52                   	push   %edx
400003d0:	89 f2                	mov    %esi,%edx
400003d2:	50                   	push   %eax
400003d3:	89 f8                	mov    %edi,%eax
400003d5:	e8 46 ff ff ff       	call   40000320 <printnum>
400003da:	83 c4 20             	add    $0x20,%esp
400003dd:	eb a2                	jmp    40000381 <printnum+0x61>
400003df:	90                   	nop

400003e0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
400003e0:	55                   	push   %ebp
400003e1:	89 e5                	mov    %esp,%ebp
400003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
400003e6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
400003ea:	8b 10                	mov    (%eax),%edx
400003ec:	3b 50 04             	cmp    0x4(%eax),%edx
400003ef:	73 0a                	jae    400003fb <sprintputch+0x1b>
		*b->buf++ = ch;
400003f1:	8d 4a 01             	lea    0x1(%edx),%ecx
400003f4:	89 08                	mov    %ecx,(%eax)
400003f6:	8b 45 08             	mov    0x8(%ebp),%eax
400003f9:	88 02                	mov    %al,(%edx)
}
400003fb:	5d                   	pop    %ebp
400003fc:	c3                   	ret
400003fd:	8d 76 00             	lea    0x0(%esi),%esi

40000400 <vprintfmt>:
{
40000400:	55                   	push   %ebp
40000401:	89 e5                	mov    %esp,%ebp
40000403:	57                   	push   %edi
40000404:	56                   	push   %esi
40000405:	53                   	push   %ebx
40000406:	83 ec 2c             	sub    $0x2c,%esp
40000409:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000040c:	8b 75 0c             	mov    0xc(%ebp),%esi
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000040f:	8b 45 10             	mov    0x10(%ebp),%eax
40000412:	8d 78 01             	lea    0x1(%eax),%edi
40000415:	0f b6 00             	movzbl (%eax),%eax
40000418:	83 f8 25             	cmp    $0x25,%eax
4000041b:	75 19                	jne    40000436 <vprintfmt+0x36>
4000041d:	eb 29                	jmp    40000448 <vprintfmt+0x48>
4000041f:	90                   	nop
			putch(ch, putdat);
40000420:	83 ec 08             	sub    $0x8,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
40000423:	83 c7 01             	add    $0x1,%edi
			putch(ch, putdat);
40000426:	56                   	push   %esi
40000427:	50                   	push   %eax
40000428:	ff d3                	call   *%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000042a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
4000042e:	83 c4 10             	add    $0x10,%esp
40000431:	83 f8 25             	cmp    $0x25,%eax
40000434:	74 12                	je     40000448 <vprintfmt+0x48>
			if (ch == '\0')
40000436:	85 c0                	test   %eax,%eax
40000438:	75 e6                	jne    40000420 <vprintfmt+0x20>
}
4000043a:	8d 65 f4             	lea    -0xc(%ebp),%esp
4000043d:	5b                   	pop    %ebx
4000043e:	5e                   	pop    %esi
4000043f:	5f                   	pop    %edi
40000440:	5d                   	pop    %ebp
40000441:	c3                   	ret
40000442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		padc = ' ';
40000448:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
		precision = -1;
4000044c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		altflag = 0;
40000451:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		width = -1;
40000458:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		lflag = 0;
4000045f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000466:	0f b6 17             	movzbl (%edi),%edx
40000469:	8d 47 01             	lea    0x1(%edi),%eax
4000046c:	89 45 10             	mov    %eax,0x10(%ebp)
4000046f:	8d 42 dd             	lea    -0x23(%edx),%eax
40000472:	3c 55                	cmp    $0x55,%al
40000474:	77 0a                	ja     40000480 <vprintfmt+0x80>
40000476:	0f b6 c0             	movzbl %al,%eax
40000479:	ff 24 85 e4 12 00 40 	jmp    *0x400012e4(,%eax,4)
			putch('%', putdat);
40000480:	83 ec 08             	sub    $0x8,%esp
40000483:	56                   	push   %esi
40000484:	6a 25                	push   $0x25
40000486:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
40000488:	83 c4 10             	add    $0x10,%esp
4000048b:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
4000048f:	89 7d 10             	mov    %edi,0x10(%ebp)
40000492:	0f 84 77 ff ff ff    	je     4000040f <vprintfmt+0xf>
40000498:	89 f8                	mov    %edi,%eax
4000049a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400004a0:	83 e8 01             	sub    $0x1,%eax
400004a3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
400004a7:	75 f7                	jne    400004a0 <vprintfmt+0xa0>
400004a9:	89 45 10             	mov    %eax,0x10(%ebp)
400004ac:	e9 5e ff ff ff       	jmp    4000040f <vprintfmt+0xf>
400004b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				if (ch < '0' || ch > '9')
400004b8:	0f be 47 01          	movsbl 0x1(%edi),%eax
				precision = precision * 10 + ch - '0';
400004bc:	8d 4a d0             	lea    -0x30(%edx),%ecx
		switch (ch = *(unsigned char *) fmt++) {
400004bf:	8b 7d 10             	mov    0x10(%ebp),%edi
				if (ch < '0' || ch > '9')
400004c2:	8d 50 d0             	lea    -0x30(%eax),%edx
400004c5:	83 fa 09             	cmp    $0x9,%edx
400004c8:	77 2b                	ja     400004f5 <vprintfmt+0xf5>
400004ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400004d0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400004d7:	00 
400004d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400004df:	00 
				precision = precision * 10 + ch - '0';
400004e0:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
			for (precision = 0; ; ++fmt) {
400004e3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
400004e6:	8d 4c 50 d0          	lea    -0x30(%eax,%edx,2),%ecx
				ch = *fmt;
400004ea:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
400004ed:	8d 50 d0             	lea    -0x30(%eax),%edx
400004f0:	83 fa 09             	cmp    $0x9,%edx
400004f3:	76 eb                	jbe    400004e0 <vprintfmt+0xe0>
			if (width < 0)
400004f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400004f8:	85 c0                	test   %eax,%eax
				width = precision, precision = -1;
400004fa:	0f 48 c1             	cmovs  %ecx,%eax
400004fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
40000500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000505:	0f 48 c8             	cmovs  %eax,%ecx
40000508:	e9 59 ff ff ff       	jmp    40000466 <vprintfmt+0x66>
			altflag = 1;
4000050d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000514:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000517:	e9 4a ff ff ff       	jmp    40000466 <vprintfmt+0x66>
			putch(ch, putdat);
4000051c:	83 ec 08             	sub    $0x8,%esp
4000051f:	56                   	push   %esi
40000520:	6a 25                	push   $0x25
40000522:	ff d3                	call   *%ebx
			break;
40000524:	83 c4 10             	add    $0x10,%esp
40000527:	e9 e3 fe ff ff       	jmp    4000040f <vprintfmt+0xf>
			precision = va_arg(ap, int);
4000052c:	8b 45 14             	mov    0x14(%ebp),%eax
		switch (ch = *(unsigned char *) fmt++) {
4000052f:	8b 7d 10             	mov    0x10(%ebp),%edi
			precision = va_arg(ap, int);
40000532:	8b 08                	mov    (%eax),%ecx
40000534:	83 c0 04             	add    $0x4,%eax
40000537:	89 45 14             	mov    %eax,0x14(%ebp)
			goto process_precision;
4000053a:	eb b9                	jmp    400004f5 <vprintfmt+0xf5>
			if (width < 0)
4000053c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
4000053f:	31 c0                	xor    %eax,%eax
		switch (ch = *(unsigned char *) fmt++) {
40000541:	8b 7d 10             	mov    0x10(%ebp),%edi
			if (width < 0)
40000544:	85 d2                	test   %edx,%edx
40000546:	0f 49 c2             	cmovns %edx,%eax
40000549:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			goto reswitch;
4000054c:	e9 15 ff ff ff       	jmp    40000466 <vprintfmt+0x66>
			putch(va_arg(ap, int), putdat);
40000551:	83 ec 08             	sub    $0x8,%esp
40000554:	56                   	push   %esi
40000555:	8b 45 14             	mov    0x14(%ebp),%eax
40000558:	ff 30                	push   (%eax)
4000055a:	ff d3                	call   *%ebx
4000055c:	8b 45 14             	mov    0x14(%ebp),%eax
4000055f:	83 c0 04             	add    $0x4,%eax
			break;
40000562:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
40000565:	89 45 14             	mov    %eax,0x14(%ebp)
			break;
40000568:	e9 a2 fe ff ff       	jmp    4000040f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
4000056d:	8b 45 14             	mov    0x14(%ebp),%eax
40000570:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
40000572:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
40000576:	0f 8f af 01 00 00    	jg     4000072b <vprintfmt+0x32b>
		return va_arg(*ap, unsigned long);
4000057c:	83 c0 04             	add    $0x4,%eax
4000057f:	31 c9                	xor    %ecx,%ecx
40000581:	bf 0a 00 00 00       	mov    $0xa,%edi
40000586:	89 45 14             	mov    %eax,0x14(%ebp)
40000589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			printnum(putch, putdat, num, base, width, padc);
40000590:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
40000594:	83 ec 0c             	sub    $0xc,%esp
40000597:	50                   	push   %eax
40000598:	89 d8                	mov    %ebx,%eax
4000059a:	ff 75 e4             	push   -0x1c(%ebp)
4000059d:	57                   	push   %edi
4000059e:	51                   	push   %ecx
4000059f:	52                   	push   %edx
400005a0:	89 f2                	mov    %esi,%edx
400005a2:	e8 79 fd ff ff       	call   40000320 <printnum>
			break;
400005a7:	83 c4 20             	add    $0x20,%esp
400005aa:	e9 60 fe ff ff       	jmp    4000040f <vprintfmt+0xf>
			putch('0', putdat);
400005af:	83 ec 08             	sub    $0x8,%esp
			goto number;
400005b2:	bf 10 00 00 00       	mov    $0x10,%edi
			putch('0', putdat);
400005b7:	56                   	push   %esi
400005b8:	6a 30                	push   $0x30
400005ba:	ff d3                	call   *%ebx
			putch('x', putdat);
400005bc:	58                   	pop    %eax
400005bd:	5a                   	pop    %edx
400005be:	56                   	push   %esi
400005bf:	6a 78                	push   $0x78
400005c1:	ff d3                	call   *%ebx
			num = (unsigned long long)
400005c3:	8b 45 14             	mov    0x14(%ebp),%eax
400005c6:	31 c9                	xor    %ecx,%ecx
400005c8:	8b 10                	mov    (%eax),%edx
				(uintptr_t) va_arg(ap, void *);
400005ca:	83 c0 04             	add    $0x4,%eax
			goto number;
400005cd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
400005d0:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;
400005d3:	eb bb                	jmp    40000590 <vprintfmt+0x190>
		return va_arg(*ap, unsigned long long);
400005d5:	8b 45 14             	mov    0x14(%ebp),%eax
400005d8:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
400005da:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
400005de:	0f 8f 5a 01 00 00    	jg     4000073e <vprintfmt+0x33e>
		return va_arg(*ap, unsigned long);
400005e4:	83 c0 04             	add    $0x4,%eax
400005e7:	31 c9                	xor    %ecx,%ecx
400005e9:	bf 10 00 00 00       	mov    $0x10,%edi
400005ee:	89 45 14             	mov    %eax,0x14(%ebp)
400005f1:	eb 9d                	jmp    40000590 <vprintfmt+0x190>
		return va_arg(*ap, long long);
400005f3:	8b 45 14             	mov    0x14(%ebp),%eax
	if (lflag >= 2)
400005f6:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
400005fa:	0f 8f 51 01 00 00    	jg     40000751 <vprintfmt+0x351>
		return va_arg(*ap, long);
40000600:	8b 4d 14             	mov    0x14(%ebp),%ecx
40000603:	8b 00                	mov    (%eax),%eax
40000605:	83 c1 04             	add    $0x4,%ecx
40000608:	99                   	cltd
40000609:	89 4d 14             	mov    %ecx,0x14(%ebp)
			if ((long long) num < 0) {
4000060c:	85 d2                	test   %edx,%edx
4000060e:	0f 88 68 01 00 00    	js     4000077c <vprintfmt+0x37c>
			num = getint(&ap, lflag);
40000614:	89 d1                	mov    %edx,%ecx
40000616:	bf 0a 00 00 00       	mov    $0xa,%edi
4000061b:	89 c2                	mov    %eax,%edx
4000061d:	e9 6e ff ff ff       	jmp    40000590 <vprintfmt+0x190>
			lflag++;
40000622:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000626:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000629:	e9 38 fe ff ff       	jmp    40000466 <vprintfmt+0x66>
			putch('X', putdat);
4000062e:	83 ec 08             	sub    $0x8,%esp
40000631:	56                   	push   %esi
40000632:	6a 58                	push   $0x58
40000634:	ff d3                	call   *%ebx
			putch('X', putdat);
40000636:	59                   	pop    %ecx
40000637:	5f                   	pop    %edi
40000638:	56                   	push   %esi
40000639:	6a 58                	push   $0x58
4000063b:	ff d3                	call   *%ebx
			putch('X', putdat);
4000063d:	58                   	pop    %eax
4000063e:	5a                   	pop    %edx
4000063f:	56                   	push   %esi
40000640:	6a 58                	push   $0x58
40000642:	ff d3                	call   *%ebx
			break;
40000644:	83 c4 10             	add    $0x10,%esp
40000647:	e9 c3 fd ff ff       	jmp    4000040f <vprintfmt+0xf>
			if ((p = va_arg(ap, char *)) == NULL)
4000064c:	8b 45 14             	mov    0x14(%ebp),%eax
4000064f:	83 c0 04             	add    $0x4,%eax
40000652:	89 45 d4             	mov    %eax,-0x2c(%ebp)
40000655:	8b 45 14             	mov    0x14(%ebp),%eax
40000658:	8b 38                	mov    (%eax),%edi
			if (width > 0 && padc != '-')
4000065a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
4000065d:	85 c0                	test   %eax,%eax
4000065f:	0f 9f c0             	setg   %al
40000662:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
40000666:	0f 95 c2             	setne  %dl
40000669:	21 d0                	and    %edx,%eax
			if ((p = va_arg(ap, char *)) == NULL)
4000066b:	85 ff                	test   %edi,%edi
4000066d:	0f 84 32 01 00 00    	je     400007a5 <vprintfmt+0x3a5>
			if (width > 0 && padc != '-')
40000673:	84 c0                	test   %al,%al
40000675:	0f 85 4d 01 00 00    	jne    400007c8 <vprintfmt+0x3c8>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000067b:	0f be 07             	movsbl (%edi),%eax
4000067e:	89 c2                	mov    %eax,%edx
40000680:	85 c0                	test   %eax,%eax
40000682:	74 7b                	je     400006ff <vprintfmt+0x2ff>
40000684:	89 5d 08             	mov    %ebx,0x8(%ebp)
40000687:	83 c7 01             	add    $0x1,%edi
4000068a:	89 cb                	mov    %ecx,%ebx
4000068c:	89 75 0c             	mov    %esi,0xc(%ebp)
4000068f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
40000692:	eb 21                	jmp    400006b5 <vprintfmt+0x2b5>
40000694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					putch(ch, putdat);
40000698:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000069b:	83 c7 01             	add    $0x1,%edi
					putch(ch, putdat);
4000069e:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006a1:	83 ee 01             	sub    $0x1,%esi
					putch(ch, putdat);
400006a4:	50                   	push   %eax
400006a5:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006a8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
400006ac:	83 c4 10             	add    $0x10,%esp
400006af:	89 c2                	mov    %eax,%edx
400006b1:	85 c0                	test   %eax,%eax
400006b3:	74 41                	je     400006f6 <vprintfmt+0x2f6>
400006b5:	85 db                	test   %ebx,%ebx
400006b7:	78 05                	js     400006be <vprintfmt+0x2be>
400006b9:	83 eb 01             	sub    $0x1,%ebx
400006bc:	72 38                	jb     400006f6 <vprintfmt+0x2f6>
				if (altflag && (ch < ' ' || ch > '~'))
400006be:	8b 4d d8             	mov    -0x28(%ebp),%ecx
400006c1:	85 c9                	test   %ecx,%ecx
400006c3:	74 d3                	je     40000698 <vprintfmt+0x298>
400006c5:	0f be ca             	movsbl %dl,%ecx
400006c8:	83 e9 20             	sub    $0x20,%ecx
400006cb:	83 f9 5e             	cmp    $0x5e,%ecx
400006ce:	76 c8                	jbe    40000698 <vprintfmt+0x298>
					putch('?', putdat);
400006d0:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006d3:	83 c7 01             	add    $0x1,%edi
					putch('?', putdat);
400006d6:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006d9:	83 ee 01             	sub    $0x1,%esi
					putch('?', putdat);
400006dc:	6a 3f                	push   $0x3f
400006de:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006e1:	0f be 4f ff          	movsbl -0x1(%edi),%ecx
400006e5:	83 c4 10             	add    $0x10,%esp
400006e8:	89 ca                	mov    %ecx,%edx
400006ea:	89 c8                	mov    %ecx,%eax
400006ec:	85 c9                	test   %ecx,%ecx
400006ee:	74 06                	je     400006f6 <vprintfmt+0x2f6>
400006f0:	85 db                	test   %ebx,%ebx
400006f2:	79 c5                	jns    400006b9 <vprintfmt+0x2b9>
400006f4:	eb d2                	jmp    400006c8 <vprintfmt+0x2c8>
400006f6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
400006f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
400006fc:	8b 75 0c             	mov    0xc(%ebp),%esi
			for (; width > 0; width--)
400006ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000702:	85 c0                	test   %eax,%eax
40000704:	7e 1a                	jle    40000720 <vprintfmt+0x320>
40000706:	89 c7                	mov    %eax,%edi
40000708:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000070f:	00 
				putch(' ', putdat);
40000710:	83 ec 08             	sub    $0x8,%esp
40000713:	56                   	push   %esi
40000714:	6a 20                	push   $0x20
40000716:	ff d3                	call   *%ebx
			for (; width > 0; width--)
40000718:	83 c4 10             	add    $0x10,%esp
4000071b:	83 ef 01             	sub    $0x1,%edi
4000071e:	75 f0                	jne    40000710 <vprintfmt+0x310>
			if ((p = va_arg(ap, char *)) == NULL)
40000720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40000723:	89 45 14             	mov    %eax,0x14(%ebp)
40000726:	e9 e4 fc ff ff       	jmp    4000040f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
4000072b:	8b 48 04             	mov    0x4(%eax),%ecx
4000072e:	83 c0 08             	add    $0x8,%eax
40000731:	bf 0a 00 00 00       	mov    $0xa,%edi
40000736:	89 45 14             	mov    %eax,0x14(%ebp)
40000739:	e9 52 fe ff ff       	jmp    40000590 <vprintfmt+0x190>
4000073e:	8b 48 04             	mov    0x4(%eax),%ecx
40000741:	83 c0 08             	add    $0x8,%eax
40000744:	bf 10 00 00 00       	mov    $0x10,%edi
40000749:	89 45 14             	mov    %eax,0x14(%ebp)
4000074c:	e9 3f fe ff ff       	jmp    40000590 <vprintfmt+0x190>
		return va_arg(*ap, long long);
40000751:	8b 4d 14             	mov    0x14(%ebp),%ecx
40000754:	8b 50 04             	mov    0x4(%eax),%edx
40000757:	8b 00                	mov    (%eax),%eax
40000759:	83 c1 08             	add    $0x8,%ecx
4000075c:	89 4d 14             	mov    %ecx,0x14(%ebp)
4000075f:	e9 a8 fe ff ff       	jmp    4000060c <vprintfmt+0x20c>
		switch (ch = *(unsigned char *) fmt++) {
40000764:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
40000768:	8b 7d 10             	mov    0x10(%ebp),%edi
4000076b:	e9 f6 fc ff ff       	jmp    40000466 <vprintfmt+0x66>
			padc = '-';
40000770:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000774:	8b 7d 10             	mov    0x10(%ebp),%edi
40000777:	e9 ea fc ff ff       	jmp    40000466 <vprintfmt+0x66>
				putch('-', putdat);
4000077c:	83 ec 08             	sub    $0x8,%esp
4000077f:	89 45 d8             	mov    %eax,-0x28(%ebp)
				num = -(long long) num;
40000782:	bf 0a 00 00 00       	mov    $0xa,%edi
40000787:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch('-', putdat);
4000078a:	56                   	push   %esi
4000078b:	6a 2d                	push   $0x2d
4000078d:	ff d3                	call   *%ebx
				num = -(long long) num;
4000078f:	8b 45 d8             	mov    -0x28(%ebp),%eax
40000792:	31 d2                	xor    %edx,%edx
40000794:	f7 d8                	neg    %eax
40000796:	1b 55 dc             	sbb    -0x24(%ebp),%edx
40000799:	83 c4 10             	add    $0x10,%esp
4000079c:	89 d1                	mov    %edx,%ecx
4000079e:	89 c2                	mov    %eax,%edx
400007a0:	e9 eb fd ff ff       	jmp    40000590 <vprintfmt+0x190>
			if (width > 0 && padc != '-')
400007a5:	84 c0                	test   %al,%al
400007a7:	75 78                	jne    40000821 <vprintfmt+0x421>
400007a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400007ac:	bf 6e 12 00 40       	mov    $0x4000126e,%edi
400007b1:	ba 28 00 00 00       	mov    $0x28,%edx
400007b6:	89 cb                	mov    %ecx,%ebx
400007b8:	89 75 0c             	mov    %esi,0xc(%ebp)
400007bb:	b8 28 00 00 00       	mov    $0x28,%eax
400007c0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
400007c3:	e9 ed fe ff ff       	jmp    400006b5 <vprintfmt+0x2b5>
				for (width -= strnlen(p, precision); width > 0; width--)
400007c8:	83 ec 08             	sub    $0x8,%esp
400007cb:	51                   	push   %ecx
400007cc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
400007cf:	57                   	push   %edi
400007d0:	e8 eb 02 00 00       	call   40000ac0 <strnlen>
400007d5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
400007d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
400007db:	83 c4 10             	add    $0x10,%esp
400007de:	85 c9                	test   %ecx,%ecx
400007e0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
400007e3:	7e 71                	jle    40000856 <vprintfmt+0x456>
					putch(padc, putdat);
400007e5:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
400007e9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
400007ec:	89 7d d0             	mov    %edi,-0x30(%ebp)
400007ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
400007f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
400007f5:	83 ec 08             	sub    $0x8,%esp
400007f8:	56                   	push   %esi
400007f9:	ff 75 e0             	push   -0x20(%ebp)
400007fc:	ff d3                	call   *%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
400007fe:	83 c4 10             	add    $0x10,%esp
40000801:	83 ef 01             	sub    $0x1,%edi
40000804:	75 ef                	jne    400007f5 <vprintfmt+0x3f5>
40000806:	89 7d e4             	mov    %edi,-0x1c(%ebp)
40000809:	8b 7d d0             	mov    -0x30(%ebp),%edi
4000080c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000080f:	0f be 07             	movsbl (%edi),%eax
40000812:	89 c2                	mov    %eax,%edx
40000814:	85 c0                	test   %eax,%eax
40000816:	0f 85 68 fe ff ff    	jne    40000684 <vprintfmt+0x284>
4000081c:	e9 ff fe ff ff       	jmp    40000720 <vprintfmt+0x320>
				for (width -= strnlen(p, precision); width > 0; width--)
40000821:	83 ec 08             	sub    $0x8,%esp
				p = "(null)";
40000824:	bf 6d 12 00 40       	mov    $0x4000126d,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
40000829:	51                   	push   %ecx
4000082a:	89 4d d0             	mov    %ecx,-0x30(%ebp)
4000082d:	68 6d 12 00 40       	push   $0x4000126d
40000832:	e8 89 02 00 00       	call   40000ac0 <strnlen>
40000837:	29 45 e4             	sub    %eax,-0x1c(%ebp)
4000083a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
4000083d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000840:	ba 28 00 00 00       	mov    $0x28,%edx
40000845:	b8 28 00 00 00       	mov    $0x28,%eax
				for (width -= strnlen(p, precision); width > 0; width--)
4000084a:	85 c9                	test   %ecx,%ecx
4000084c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
4000084f:	7f 94                	jg     400007e5 <vprintfmt+0x3e5>
40000851:	e9 2e fe ff ff       	jmp    40000684 <vprintfmt+0x284>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000856:	0f be 07             	movsbl (%edi),%eax
40000859:	89 c2                	mov    %eax,%edx
4000085b:	85 c0                	test   %eax,%eax
4000085d:	0f 85 21 fe ff ff    	jne    40000684 <vprintfmt+0x284>
40000863:	e9 b8 fe ff ff       	jmp    40000720 <vprintfmt+0x320>
40000868:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000086f:	00 

40000870 <printfmt>:
{
40000870:	55                   	push   %ebp
40000871:	89 e5                	mov    %esp,%ebp
40000873:	83 ec 08             	sub    $0x8,%esp
	vprintfmt(putch, putdat, fmt, ap);
40000876:	8d 45 14             	lea    0x14(%ebp),%eax
40000879:	50                   	push   %eax
4000087a:	ff 75 10             	push   0x10(%ebp)
4000087d:	ff 75 0c             	push   0xc(%ebp)
40000880:	ff 75 08             	push   0x8(%ebp)
40000883:	e8 78 fb ff ff       	call   40000400 <vprintfmt>
}
40000888:	83 c4 10             	add    $0x10,%esp
4000088b:	c9                   	leave
4000088c:	c3                   	ret
4000088d:	8d 76 00             	lea    0x0(%esi),%esi

40000890 <vsprintf>:

int
vsprintf(char *buf, const char *fmt, va_list ap)
{
40000890:	55                   	push   %ebp
40000891:	89 e5                	mov    %esp,%ebp
40000893:	83 ec 18             	sub    $0x18,%esp
	//assert(buf != NULL);
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
40000896:	8b 45 08             	mov    0x8(%ebp),%eax

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000899:	ff 75 10             	push   0x10(%ebp)
4000089c:	ff 75 0c             	push   0xc(%ebp)
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
4000089f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
400008a5:	50                   	push   %eax
400008a6:	68 e0 03 00 40       	push   $0x400003e0
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400008ab:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
400008b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008b9:	e8 42 fb ff ff       	call   40000400 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
400008be:	8b 45 ec             	mov    -0x14(%ebp),%eax
400008c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
400008c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
400008c7:	c9                   	leave
400008c8:	c3                   	ret
400008c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400008d0 <sprintf>:

int
sprintf(char *buf, const char *fmt, ...)
{
400008d0:	55                   	push   %ebp
400008d1:	89 e5                	mov    %esp,%ebp
400008d3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400008d6:	8b 45 08             	mov    0x8(%ebp),%eax
400008d9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
400008e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
400008e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008ea:	8d 45 10             	lea    0x10(%ebp),%eax
400008ed:	50                   	push   %eax
400008ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
400008f1:	ff 75 0c             	push   0xc(%ebp)
400008f4:	50                   	push   %eax
400008f5:	68 e0 03 00 40       	push   $0x400003e0
400008fa:	e8 01 fb ff ff       	call   40000400 <vprintfmt>
	*b.buf = '\0';
400008ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000902:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsprintf(buf, fmt, ap);
	va_end(ap);

	return rc;
}
40000905:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000908:	c9                   	leave
40000909:	c3                   	ret
4000090a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000910 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
40000910:	55                   	push   %ebp
40000911:	89 e5                	mov    %esp,%ebp
40000913:	83 ec 18             	sub    $0x18,%esp
40000916:	8b 45 08             	mov    0x8(%ebp),%eax
	//assert(buf != NULL && n > 0);
	struct sprintbuf b = {buf, buf+n-1, 0};
40000919:	8b 55 0c             	mov    0xc(%ebp),%edx

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000091c:	ff 75 14             	push   0x14(%ebp)
4000091f:	ff 75 10             	push   0x10(%ebp)
	struct sprintbuf b = {buf, buf+n-1, 0};
40000922:	89 45 ec             	mov    %eax,-0x14(%ebp)
40000925:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
40000929:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000092c:	8d 45 ec             	lea    -0x14(%ebp),%eax
4000092f:	50                   	push   %eax
40000930:	68 e0 03 00 40       	push   $0x400003e0
	struct sprintbuf b = {buf, buf+n-1, 0};
40000935:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000093c:	e8 bf fa ff ff       	call   40000400 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
40000941:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000944:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000947:	8b 45 f4             	mov    -0xc(%ebp),%eax
4000094a:	c9                   	leave
4000094b:	c3                   	ret
4000094c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000950 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
40000950:	55                   	push   %ebp
40000951:	89 e5                	mov    %esp,%ebp
40000953:	83 ec 18             	sub    $0x18,%esp
40000956:	8b 45 08             	mov    0x8(%ebp),%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
40000959:	8b 55 0c             	mov    0xc(%ebp),%edx
4000095c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
40000963:	89 45 ec             	mov    %eax,-0x14(%ebp)
40000966:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
4000096a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000096d:	8d 45 14             	lea    0x14(%ebp),%eax
40000970:	50                   	push   %eax
40000971:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000974:	ff 75 10             	push   0x10(%ebp)
40000977:	50                   	push   %eax
40000978:	68 e0 03 00 40       	push   $0x400003e0
4000097d:	e8 7e fa ff ff       	call   40000400 <vprintfmt>
	*b.buf = '\0';
40000982:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000985:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
	va_end(ap);

	return rc;
}
40000988:	8b 45 f4             	mov    -0xc(%ebp),%eax
4000098b:	c9                   	leave
4000098c:	c3                   	ret
4000098d:	66 90                	xchg   %ax,%ax
4000098f:	90                   	nop

40000990 <spawn>:
#include <syscall.h>
#include <types.h>

pid_t
spawn(uintptr_t exec, unsigned int quota)
{
40000990:	55                   	push   %ebp
	asm volatile("int %2"
40000991:	ba ff ff ff ff       	mov    $0xffffffff,%edx
40000996:	b8 01 00 00 00       	mov    $0x1,%eax
4000099b:	89 e5                	mov    %esp,%ebp
4000099d:	56                   	push   %esi
4000099e:	89 d6                	mov    %edx,%esi
400009a0:	53                   	push   %ebx
400009a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
400009a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
400009a7:	cd 30                	int    $0x30
	return errno ? -1 : pid;
400009a9:	85 c0                	test   %eax,%eax
400009ab:	75 0b                	jne    400009b8 <spawn+0x28>
400009ad:	89 da                	mov    %ebx,%edx
	// Default: inherit console stdin/stdout
	return sys_spawn(exec, quota, -1, -1);
}
400009af:	5b                   	pop    %ebx
400009b0:	89 d0                	mov    %edx,%eax
400009b2:	5e                   	pop    %esi
400009b3:	5d                   	pop    %ebp
400009b4:	c3                   	ret
400009b5:	8d 76 00             	lea    0x0(%esi),%esi
400009b8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, -1, -1);
400009bd:	eb f0                	jmp    400009af <spawn+0x1f>
400009bf:	90                   	nop

400009c0 <spawn_with_fds>:

pid_t
spawn_with_fds(uintptr_t exec, unsigned int quota, int stdin_fd, int stdout_fd)
{
400009c0:	55                   	push   %ebp
	asm volatile("int %2"
400009c1:	b8 01 00 00 00       	mov    $0x1,%eax
400009c6:	89 e5                	mov    %esp,%ebp
400009c8:	56                   	push   %esi
400009c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
400009cc:	8b 55 10             	mov    0x10(%ebp),%edx
400009cf:	53                   	push   %ebx
400009d0:	8b 75 14             	mov    0x14(%ebp),%esi
400009d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
400009d6:	cd 30                	int    $0x30
	return errno ? -1 : pid;
400009d8:	85 c0                	test   %eax,%eax
400009da:	75 0c                	jne    400009e8 <spawn_with_fds+0x28>
400009dc:	89 da                	mov    %ebx,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
}
400009de:	5b                   	pop    %ebx
400009df:	89 d0                	mov    %edx,%eax
400009e1:	5e                   	pop    %esi
400009e2:	5d                   	pop    %ebp
400009e3:	c3                   	ret
400009e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400009e8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
400009ed:	eb ef                	jmp    400009de <spawn_with_fds+0x1e>
400009ef:	90                   	nop

400009f0 <yield>:
	asm volatile("int %0" :
400009f0:	b8 02 00 00 00       	mov    $0x2,%eax
400009f5:	cd 30                	int    $0x30

void
yield(void)
{
	sys_yield();
}
400009f7:	c3                   	ret
400009f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400009ff:	00 

40000a00 <produce>:
	asm volatile("int %0" :
40000a00:	b8 03 00 00 00       	mov    $0x3,%eax
40000a05:	cd 30                	int    $0x30

void
produce(void)
{
	sys_produce();
}
40000a07:	c3                   	ret
40000a08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a0f:	00 

40000a10 <consume>:
	asm volatile("int %0" :
40000a10:	b8 04 00 00 00       	mov    $0x4,%eax
40000a15:	cd 30                	int    $0x30

void
consume(void)
{
	sys_consume();
}
40000a17:	c3                   	ret
40000a18:	66 90                	xchg   %ax,%ax
40000a1a:	66 90                	xchg   %ax,%ax
40000a1c:	66 90                	xchg   %ax,%ax
40000a1e:	66 90                	xchg   %ax,%ax

40000a20 <spinlock_init>:
	return result;
}

void
spinlock_init(spinlock_t *lk)
{
40000a20:	55                   	push   %ebp
40000a21:	89 e5                	mov    %esp,%ebp
	*lk = 0;
40000a23:	8b 45 08             	mov    0x8(%ebp),%eax
40000a26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
40000a2c:	5d                   	pop    %ebp
40000a2d:	c3                   	ret
40000a2e:	66 90                	xchg   %ax,%ax

40000a30 <spinlock_acquire>:

void
spinlock_acquire(spinlock_t *lk)
{
40000a30:	55                   	push   %ebp
	asm volatile("lock; xchgl %0, %1" :
40000a31:	b8 01 00 00 00       	mov    $0x1,%eax
{
40000a36:	89 e5                	mov    %esp,%ebp
40000a38:	8b 55 08             	mov    0x8(%ebp),%edx
	asm volatile("lock; xchgl %0, %1" :
40000a3b:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000a3e:	85 c0                	test   %eax,%eax
40000a40:	74 1c                	je     40000a5e <spinlock_acquire+0x2e>
40000a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000a48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a4f:	00 
		asm volatile("pause");
40000a50:	f3 90                	pause
	asm volatile("lock; xchgl %0, %1" :
40000a52:	b8 01 00 00 00       	mov    $0x1,%eax
40000a57:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000a5a:	85 c0                	test   %eax,%eax
40000a5c:	75 f2                	jne    40000a50 <spinlock_acquire+0x20>
}
40000a5e:	5d                   	pop    %ebp
40000a5f:	c3                   	ret

40000a60 <spinlock_release>:

// Release the lock.
void
spinlock_release(spinlock_t *lk)
{
40000a60:	55                   	push   %ebp
40000a61:	89 e5                	mov    %esp,%ebp
40000a63:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
bool
spinlock_holding(spinlock_t *lock)
{
	return *lock;
40000a66:	8b 02                	mov    (%edx),%eax
	if (spinlock_holding(lk) == FALSE)
40000a68:	84 c0                	test   %al,%al
40000a6a:	74 05                	je     40000a71 <spinlock_release+0x11>
	asm volatile("lock; xchgl %0, %1" :
40000a6c:	31 c0                	xor    %eax,%eax
40000a6e:	f0 87 02             	lock xchg %eax,(%edx)
}
40000a71:	5d                   	pop    %ebp
40000a72:	c3                   	ret
40000a73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a7f:	00 

40000a80 <spinlock_holding>:
{
40000a80:	55                   	push   %ebp
40000a81:	89 e5                	mov    %esp,%ebp
	return *lock;
40000a83:	8b 45 08             	mov    0x8(%ebp),%eax
}
40000a86:	5d                   	pop    %ebp
	return *lock;
40000a87:	8b 00                	mov    (%eax),%eax
}
40000a89:	c3                   	ret
40000a8a:	66 90                	xchg   %ax,%ax
40000a8c:	66 90                	xchg   %ax,%ax
40000a8e:	66 90                	xchg   %ax,%ax
40000a90:	66 90                	xchg   %ax,%ax
40000a92:	66 90                	xchg   %ax,%ax
40000a94:	66 90                	xchg   %ax,%ax
40000a96:	66 90                	xchg   %ax,%ax
40000a98:	66 90                	xchg   %ax,%ax
40000a9a:	66 90                	xchg   %ax,%ax
40000a9c:	66 90                	xchg   %ax,%ax
40000a9e:	66 90                	xchg   %ax,%ax

40000aa0 <strlen>:
#include <string.h>
#include <types.h>

int
strlen(const char *s)
{
40000aa0:	55                   	push   %ebp
	int n;

	for (n = 0; *s != '\0'; s++)
40000aa1:	31 c0                	xor    %eax,%eax
{
40000aa3:	89 e5                	mov    %esp,%ebp
40000aa5:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; *s != '\0'; s++)
40000aa8:	80 3a 00             	cmpb   $0x0,(%edx)
40000aab:	74 0c                	je     40000ab9 <strlen+0x19>
40000aad:	8d 76 00             	lea    0x0(%esi),%esi
		n++;
40000ab0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
40000ab3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
40000ab7:	75 f7                	jne    40000ab0 <strlen+0x10>
	return n;
}
40000ab9:	5d                   	pop    %ebp
40000aba:	c3                   	ret
40000abb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

40000ac0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
40000ac0:	55                   	push   %ebp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000ac1:	31 c0                	xor    %eax,%eax
{
40000ac3:	89 e5                	mov    %esp,%ebp
40000ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
40000ac8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000acb:	85 d2                	test   %edx,%edx
40000acd:	75 18                	jne    40000ae7 <strnlen+0x27>
40000acf:	eb 1c                	jmp    40000aed <strnlen+0x2d>
40000ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000ad8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000adf:	00 
		n++;
40000ae0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000ae3:	39 c2                	cmp    %eax,%edx
40000ae5:	74 06                	je     40000aed <strnlen+0x2d>
40000ae7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
40000aeb:	75 f3                	jne    40000ae0 <strnlen+0x20>
	return n;
}
40000aed:	5d                   	pop    %ebp
40000aee:	c3                   	ret
40000aef:	90                   	nop

40000af0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
40000af0:	55                   	push   %ebp
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
40000af1:	31 c0                	xor    %eax,%eax
{
40000af3:	89 e5                	mov    %esp,%ebp
40000af5:	53                   	push   %ebx
40000af6:	8b 4d 08             	mov    0x8(%ebp),%ecx
40000af9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while ((*dst++ = *src++) != '\0')
40000b00:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000b04:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000b07:	83 c0 01             	add    $0x1,%eax
40000b0a:	84 d2                	test   %dl,%dl
40000b0c:	75 f2                	jne    40000b00 <strcpy+0x10>
		/* do nothing */;
	return ret;
}
40000b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000b11:	89 c8                	mov    %ecx,%eax
40000b13:	c9                   	leave
40000b14:	c3                   	ret
40000b15:	8d 76 00             	lea    0x0(%esi),%esi
40000b18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b1f:	00 

40000b20 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size)
{
40000b20:	55                   	push   %ebp
40000b21:	89 e5                	mov    %esp,%ebp
40000b23:	56                   	push   %esi
40000b24:	8b 55 0c             	mov    0xc(%ebp),%edx
40000b27:	8b 75 08             	mov    0x8(%ebp),%esi
40000b2a:	53                   	push   %ebx
40000b2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
40000b2e:	85 db                	test   %ebx,%ebx
40000b30:	74 21                	je     40000b53 <strncpy+0x33>
40000b32:	01 f3                	add    %esi,%ebx
40000b34:	89 f0                	mov    %esi,%eax
40000b36:	66 90                	xchg   %ax,%ax
40000b38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b3f:	00 
		*dst++ = *src;
40000b40:	0f b6 0a             	movzbl (%edx),%ecx
40000b43:	83 c0 01             	add    $0x1,%eax
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
40000b46:	80 f9 01             	cmp    $0x1,%cl
		*dst++ = *src;
40000b49:	88 48 ff             	mov    %cl,-0x1(%eax)
			src++;
40000b4c:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
40000b4f:	39 c3                	cmp    %eax,%ebx
40000b51:	75 ed                	jne    40000b40 <strncpy+0x20>
	}
	return ret;
}
40000b53:	89 f0                	mov    %esi,%eax
40000b55:	5b                   	pop    %ebx
40000b56:	5e                   	pop    %esi
40000b57:	5d                   	pop    %ebp
40000b58:	c3                   	ret
40000b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000b60 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
40000b60:	55                   	push   %ebp
40000b61:	89 e5                	mov    %esp,%ebp
40000b63:	53                   	push   %ebx
40000b64:	8b 45 10             	mov    0x10(%ebp),%eax
40000b67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
40000b6a:	85 c0                	test   %eax,%eax
40000b6c:	74 2e                	je     40000b9c <strlcpy+0x3c>
		while (--size > 0 && *src != '\0')
40000b6e:	8b 55 08             	mov    0x8(%ebp),%edx
40000b71:	83 e8 01             	sub    $0x1,%eax
40000b74:	74 23                	je     40000b99 <strlcpy+0x39>
40000b76:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
40000b79:	eb 12                	jmp    40000b8d <strlcpy+0x2d>
40000b7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
			*dst++ = *src++;
40000b80:	83 c2 01             	add    $0x1,%edx
40000b83:	83 c1 01             	add    $0x1,%ecx
40000b86:	88 42 ff             	mov    %al,-0x1(%edx)
		while (--size > 0 && *src != '\0')
40000b89:	39 da                	cmp    %ebx,%edx
40000b8b:	74 07                	je     40000b94 <strlcpy+0x34>
40000b8d:	0f b6 01             	movzbl (%ecx),%eax
40000b90:	84 c0                	test   %al,%al
40000b92:	75 ec                	jne    40000b80 <strlcpy+0x20>
		*dst = '\0';
	}
	return dst - dst_in;
40000b94:	89 d0                	mov    %edx,%eax
40000b96:	2b 45 08             	sub    0x8(%ebp),%eax
		*dst = '\0';
40000b99:	c6 02 00             	movb   $0x0,(%edx)
}
40000b9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000b9f:	c9                   	leave
40000ba0:	c3                   	ret
40000ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000baf:	00 

40000bb0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
40000bb0:	55                   	push   %ebp
40000bb1:	89 e5                	mov    %esp,%ebp
40000bb3:	53                   	push   %ebx
40000bb4:	8b 55 08             	mov    0x8(%ebp),%edx
40000bb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
40000bba:	0f b6 02             	movzbl (%edx),%eax
40000bbd:	84 c0                	test   %al,%al
40000bbf:	75 2d                	jne    40000bee <strcmp+0x3e>
40000bc1:	eb 4a                	jmp    40000c0d <strcmp+0x5d>
40000bc3:	eb 1b                	jmp    40000be0 <strcmp+0x30>
40000bc5:	8d 76 00             	lea    0x0(%esi),%esi
40000bc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bcf:	00 
40000bd0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bd7:	00 
40000bd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bdf:	00 
40000be0:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		p++, q++;
40000be4:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
40000be7:	84 c0                	test   %al,%al
40000be9:	74 15                	je     40000c00 <strcmp+0x50>
40000beb:	83 c1 01             	add    $0x1,%ecx
40000bee:	0f b6 19             	movzbl (%ecx),%ebx
40000bf1:	38 c3                	cmp    %al,%bl
40000bf3:	74 eb                	je     40000be0 <strcmp+0x30>
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000bf5:	29 d8                	sub    %ebx,%eax
}
40000bf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000bfa:	c9                   	leave
40000bfb:	c3                   	ret
40000bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c00:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
40000c04:	31 c0                	xor    %eax,%eax
40000c06:	29 d8                	sub    %ebx,%eax
}
40000c08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c0b:	c9                   	leave
40000c0c:	c3                   	ret
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c0d:	0f b6 19             	movzbl (%ecx),%ebx
40000c10:	31 c0                	xor    %eax,%eax
40000c12:	eb e1                	jmp    40000bf5 <strcmp+0x45>
40000c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000c18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c1f:	00 

40000c20 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
40000c20:	55                   	push   %ebp
40000c21:	89 e5                	mov    %esp,%ebp
40000c23:	53                   	push   %ebx
40000c24:	8b 55 10             	mov    0x10(%ebp),%edx
40000c27:	8b 45 08             	mov    0x8(%ebp),%eax
40000c2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
40000c2d:	85 d2                	test   %edx,%edx
40000c2f:	75 16                	jne    40000c47 <strncmp+0x27>
40000c31:	eb 2d                	jmp    40000c60 <strncmp+0x40>
40000c33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c38:	3a 19                	cmp    (%ecx),%bl
40000c3a:	75 12                	jne    40000c4e <strncmp+0x2e>
		n--, p++, q++;
40000c3c:	83 c0 01             	add    $0x1,%eax
40000c3f:	83 c1 01             	add    $0x1,%ecx
	while (n > 0 && *p && *p == *q)
40000c42:	83 ea 01             	sub    $0x1,%edx
40000c45:	74 19                	je     40000c60 <strncmp+0x40>
40000c47:	0f b6 18             	movzbl (%eax),%ebx
40000c4a:	84 db                	test   %bl,%bl
40000c4c:	75 ea                	jne    40000c38 <strncmp+0x18>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000c4e:	0f b6 00             	movzbl (%eax),%eax
40000c51:	0f b6 11             	movzbl (%ecx),%edx
}
40000c54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c57:	c9                   	leave
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000c58:	29 d0                	sub    %edx,%eax
}
40000c5a:	c3                   	ret
40000c5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
		return 0;
40000c63:	31 c0                	xor    %eax,%eax
}
40000c65:	c9                   	leave
40000c66:	c3                   	ret
40000c67:	90                   	nop
40000c68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c6f:	00 

40000c70 <strchr>:

char *
strchr(const char *s, char c)
{
40000c70:	55                   	push   %ebp
40000c71:	89 e5                	mov    %esp,%ebp
40000c73:	8b 45 08             	mov    0x8(%ebp),%eax
40000c76:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
40000c7a:	0f b6 10             	movzbl (%eax),%edx
40000c7d:	84 d2                	test   %dl,%dl
40000c7f:	75 1a                	jne    40000c9b <strchr+0x2b>
40000c81:	eb 25                	jmp    40000ca8 <strchr+0x38>
40000c83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c8f:	00 
40000c90:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000c94:	83 c0 01             	add    $0x1,%eax
40000c97:	84 d2                	test   %dl,%dl
40000c99:	74 0d                	je     40000ca8 <strchr+0x38>
		if (*s == c)
40000c9b:	38 d1                	cmp    %dl,%cl
40000c9d:	75 f1                	jne    40000c90 <strchr+0x20>
			return (char *) s;
	return 0;
}
40000c9f:	5d                   	pop    %ebp
40000ca0:	c3                   	ret
40000ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return 0;
40000ca8:	31 c0                	xor    %eax,%eax
}
40000caa:	5d                   	pop    %ebp
40000cab:	c3                   	ret
40000cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000cb0 <strfind>:

char *
strfind(const char *s, char c)
{
40000cb0:	55                   	push   %ebp
40000cb1:	89 e5                	mov    %esp,%ebp
40000cb3:	8b 45 08             	mov    0x8(%ebp),%eax
40000cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	for (; *s; s++)
40000cb9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
40000cbc:	38 ca                	cmp    %cl,%dl
40000cbe:	75 1b                	jne    40000cdb <strfind+0x2b>
40000cc0:	eb 1d                	jmp    40000cdf <strfind+0x2f>
40000cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000cc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ccf:	00 
	for (; *s; s++)
40000cd0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000cd4:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
40000cd7:	38 ca                	cmp    %cl,%dl
40000cd9:	74 04                	je     40000cdf <strfind+0x2f>
40000cdb:	84 d2                	test   %dl,%dl
40000cdd:	75 f1                	jne    40000cd0 <strfind+0x20>
			break;
	return (char *) s;
}
40000cdf:	5d                   	pop    %ebp
40000ce0:	c3                   	ret
40000ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000ce8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000cef:	00 

40000cf0 <strtol>:


long
strtol(const char *s, char **endptr, int base)
{
40000cf0:	55                   	push   %ebp
40000cf1:	89 e5                	mov    %esp,%ebp
40000cf3:	57                   	push   %edi
40000cf4:	8b 55 08             	mov    0x8(%ebp),%edx
40000cf7:	56                   	push   %esi
40000cf8:	53                   	push   %ebx
40000cf9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
40000cfc:	0f b6 02             	movzbl (%edx),%eax
40000cff:	3c 09                	cmp    $0x9,%al
40000d01:	74 0d                	je     40000d10 <strtol+0x20>
40000d03:	3c 20                	cmp    $0x20,%al
40000d05:	75 18                	jne    40000d1f <strtol+0x2f>
40000d07:	90                   	nop
40000d08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d0f:	00 
40000d10:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		s++;
40000d14:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
40000d17:	3c 20                	cmp    $0x20,%al
40000d19:	74 f5                	je     40000d10 <strtol+0x20>
40000d1b:	3c 09                	cmp    $0x9,%al
40000d1d:	74 f1                	je     40000d10 <strtol+0x20>

	// plus/minus sign
	if (*s == '+')
40000d1f:	3c 2b                	cmp    $0x2b,%al
40000d21:	0f 84 89 00 00 00    	je     40000db0 <strtol+0xc0>
		s++;
	else if (*s == '-')
		s++, neg = 1;
40000d27:	3c 2d                	cmp    $0x2d,%al
40000d29:	8d 4a 01             	lea    0x1(%edx),%ecx
40000d2c:	0f 94 c0             	sete   %al
40000d2f:	0f 44 d1             	cmove  %ecx,%edx
40000d32:	0f b6 c0             	movzbl %al,%eax

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000d35:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
40000d3b:	75 10                	jne    40000d4d <strtol+0x5d>
40000d3d:	80 3a 30             	cmpb   $0x30,(%edx)
40000d40:	74 7e                	je     40000dc0 <strtol+0xd0>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
40000d42:	83 fb 01             	cmp    $0x1,%ebx
40000d45:	19 db                	sbb    %ebx,%ebx
40000d47:	83 e3 fa             	and    $0xfffffffa,%ebx
40000d4a:	83 c3 10             	add    $0x10,%ebx
40000d4d:	89 5d 10             	mov    %ebx,0x10(%ebp)
40000d50:	31 c9                	xor    %ecx,%ecx
40000d52:	89 c7                	mov    %eax,%edi
40000d54:	eb 13                	jmp    40000d69 <strtol+0x79>
40000d56:	66 90                	xchg   %ax,%ax
40000d58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d5f:	00 
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
		s++, val = (val * base) + dig;
40000d60:	0f af 4d 10          	imul   0x10(%ebp),%ecx
40000d64:	83 c2 01             	add    $0x1,%edx
40000d67:	01 f1                	add    %esi,%ecx
		if (*s >= '0' && *s <= '9')
40000d69:	0f be 1a             	movsbl (%edx),%ebx
40000d6c:	8d 43 d0             	lea    -0x30(%ebx),%eax
			dig = *s - '0';
40000d6f:	8d 73 d0             	lea    -0x30(%ebx),%esi
		if (*s >= '0' && *s <= '9')
40000d72:	3c 09                	cmp    $0x9,%al
40000d74:	76 14                	jbe    40000d8a <strtol+0x9a>
		else if (*s >= 'a' && *s <= 'z')
40000d76:	8d 43 9f             	lea    -0x61(%ebx),%eax
			dig = *s - 'a' + 10;
40000d79:	8d 73 a9             	lea    -0x57(%ebx),%esi
		else if (*s >= 'a' && *s <= 'z')
40000d7c:	3c 19                	cmp    $0x19,%al
40000d7e:	76 0a                	jbe    40000d8a <strtol+0x9a>
		else if (*s >= 'A' && *s <= 'Z')
40000d80:	8d 43 bf             	lea    -0x41(%ebx),%eax
40000d83:	3c 19                	cmp    $0x19,%al
40000d85:	77 08                	ja     40000d8f <strtol+0x9f>
			dig = *s - 'A' + 10;
40000d87:	8d 73 c9             	lea    -0x37(%ebx),%esi
		if (dig >= base)
40000d8a:	3b 75 10             	cmp    0x10(%ebp),%esi
40000d8d:	7c d1                	jl     40000d60 <strtol+0x70>
		// we don't properly detect overflow!
	}

	if (endptr)
40000d8f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000d92:	89 f8                	mov    %edi,%eax
40000d94:	85 db                	test   %ebx,%ebx
40000d96:	74 05                	je     40000d9d <strtol+0xad>
		*endptr = (char *) s;
40000d98:	8b 7d 0c             	mov    0xc(%ebp),%edi
40000d9b:	89 17                	mov    %edx,(%edi)
	return (neg ? -val : val);
40000d9d:	89 ca                	mov    %ecx,%edx
}
40000d9f:	5b                   	pop    %ebx
40000da0:	5e                   	pop    %esi
	return (neg ? -val : val);
40000da1:	f7 da                	neg    %edx
40000da3:	85 c0                	test   %eax,%eax
}
40000da5:	5f                   	pop    %edi
40000da6:	5d                   	pop    %ebp
	return (neg ? -val : val);
40000da7:	0f 45 ca             	cmovne %edx,%ecx
}
40000daa:	89 c8                	mov    %ecx,%eax
40000dac:	c3                   	ret
40000dad:	8d 76 00             	lea    0x0(%esi),%esi
		s++;
40000db0:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
40000db3:	31 c0                	xor    %eax,%eax
40000db5:	e9 7b ff ff ff       	jmp    40000d35 <strtol+0x45>
40000dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000dc0:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
40000dc4:	74 1b                	je     40000de1 <strtol+0xf1>
	else if (base == 0 && s[0] == '0')
40000dc6:	85 db                	test   %ebx,%ebx
40000dc8:	74 0a                	je     40000dd4 <strtol+0xe4>
40000dca:	bb 10 00 00 00       	mov    $0x10,%ebx
40000dcf:	e9 79 ff ff ff       	jmp    40000d4d <strtol+0x5d>
		s++, base = 8;
40000dd4:	83 c2 01             	add    $0x1,%edx
40000dd7:	bb 08 00 00 00       	mov    $0x8,%ebx
40000ddc:	e9 6c ff ff ff       	jmp    40000d4d <strtol+0x5d>
		s += 2, base = 16;
40000de1:	83 c2 02             	add    $0x2,%edx
40000de4:	bb 10 00 00 00       	mov    $0x10,%ebx
40000de9:	e9 5f ff ff ff       	jmp    40000d4d <strtol+0x5d>
40000dee:	66 90                	xchg   %ax,%ax

40000df0 <memset>:

void *
memset(void *v, int c, size_t n)
{
40000df0:	55                   	push   %ebp
40000df1:	89 e5                	mov    %esp,%ebp
40000df3:	57                   	push   %edi
40000df4:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000df7:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000dfa:	85 c9                	test   %ecx,%ecx
40000dfc:	74 1a                	je     40000e18 <memset+0x28>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
40000dfe:	89 d0                	mov    %edx,%eax
40000e00:	09 c8                	or     %ecx,%eax
40000e02:	a8 03                	test   $0x3,%al
40000e04:	75 1a                	jne    40000e20 <memset+0x30>
		c &= 0xFF;
40000e06:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
40000e0a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000e0d:	89 d7                	mov    %edx,%edi
40000e0f:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
40000e15:	fc                   	cld
40000e16:	f3 ab                	rep stos %eax,%es:(%edi)
	} else
		asm volatile("cld; rep stosb\n"
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
}
40000e18:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000e1b:	89 d0                	mov    %edx,%eax
40000e1d:	c9                   	leave
40000e1e:	c3                   	ret
40000e1f:	90                   	nop
		asm volatile("cld; rep stosb\n"
40000e20:	8b 45 0c             	mov    0xc(%ebp),%eax
40000e23:	89 d7                	mov    %edx,%edi
40000e25:	fc                   	cld
40000e26:	f3 aa                	rep stos %al,%es:(%edi)
}
40000e28:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000e2b:	89 d0                	mov    %edx,%eax
40000e2d:	c9                   	leave
40000e2e:	c3                   	ret
40000e2f:	90                   	nop

40000e30 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
40000e30:	55                   	push   %ebp
40000e31:	89 e5                	mov    %esp,%ebp
40000e33:	57                   	push   %edi
40000e34:	8b 45 08             	mov    0x8(%ebp),%eax
40000e37:	8b 55 0c             	mov    0xc(%ebp),%edx
40000e3a:	56                   	push   %esi
40000e3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000e3e:	53                   	push   %ebx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
40000e3f:	39 c2                	cmp    %eax,%edx
40000e41:	73 2d                	jae    40000e70 <memmove+0x40>
40000e43:	8d 1c 0a             	lea    (%edx,%ecx,1),%ebx
40000e46:	39 d8                	cmp    %ebx,%eax
40000e48:	73 26                	jae    40000e70 <memmove+0x40>
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000e4a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
40000e4d:	09 ca                	or     %ecx,%edx
40000e4f:	09 da                	or     %ebx,%edx
40000e51:	83 e2 03             	and    $0x3,%edx
40000e54:	74 4a                	je     40000ea0 <memmove+0x70>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
				     : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
40000e56:	8d 7c 08 ff          	lea    -0x1(%eax,%ecx,1),%edi
40000e5a:	8d 73 ff             	lea    -0x1(%ebx),%esi
40000e5d:	fd                   	std
40000e5e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				     :: "D" (d-1), "S" (s-1), "c" (n)
				     : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
40000e60:	fc                   	cld
			asm volatile("cld; rep movsb\n"
				     :: "D" (d), "S" (s), "c" (n)
				     : "cc", "memory");
	}
	return dst;
}
40000e61:	5b                   	pop    %ebx
40000e62:	5e                   	pop    %esi
40000e63:	5f                   	pop    %edi
40000e64:	5d                   	pop    %ebp
40000e65:	c3                   	ret
40000e66:	66 90                	xchg   %ax,%ax
40000e68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e6f:	00 
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000e70:	89 c3                	mov    %eax,%ebx
40000e72:	09 cb                	or     %ecx,%ebx
40000e74:	09 d3                	or     %edx,%ebx
40000e76:	83 e3 03             	and    $0x3,%ebx
40000e79:	74 15                	je     40000e90 <memmove+0x60>
			asm volatile("cld; rep movsb\n"
40000e7b:	89 c7                	mov    %eax,%edi
40000e7d:	89 d6                	mov    %edx,%esi
40000e7f:	fc                   	cld
40000e80:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000e82:	5b                   	pop    %ebx
40000e83:	5e                   	pop    %esi
40000e84:	5f                   	pop    %edi
40000e85:	5d                   	pop    %ebp
40000e86:	c3                   	ret
40000e87:	90                   	nop
40000e88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e8f:	00 
				     :: "D" (d), "S" (s), "c" (n/4)
40000e90:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
40000e93:	89 c7                	mov    %eax,%edi
40000e95:	89 d6                	mov    %edx,%esi
40000e97:	fc                   	cld
40000e98:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000e9a:	eb e6                	jmp    40000e82 <memmove+0x52>
40000e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			asm volatile("std; rep movsl\n"
40000ea0:	8d 7c 08 fc          	lea    -0x4(%eax,%ecx,1),%edi
40000ea4:	8d 73 fc             	lea    -0x4(%ebx),%esi
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
40000ea7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
40000eaa:	fd                   	std
40000eab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000ead:	eb b1                	jmp    40000e60 <memmove+0x30>
40000eaf:	90                   	nop

40000eb0 <memcpy>:

void *
memcpy(void *dst, const void *src, size_t n)
{
	return memmove(dst, src, n);
40000eb0:	e9 7b ff ff ff       	jmp    40000e30 <memmove>
40000eb5:	8d 76 00             	lea    0x0(%esi),%esi
40000eb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ebf:	00 

40000ec0 <memcmp>:
}

int
memcmp(const void *v1, const void *v2, size_t n)
{
40000ec0:	55                   	push   %ebp
40000ec1:	89 e5                	mov    %esp,%ebp
40000ec3:	56                   	push   %esi
40000ec4:	8b 75 10             	mov    0x10(%ebp),%esi
40000ec7:	8b 45 08             	mov    0x8(%ebp),%eax
40000eca:	53                   	push   %ebx
40000ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
40000ece:	85 f6                	test   %esi,%esi
40000ed0:	74 2e                	je     40000f00 <memcmp+0x40>
40000ed2:	01 c6                	add    %eax,%esi
40000ed4:	eb 14                	jmp    40000eea <memcmp+0x2a>
40000ed6:	66 90                	xchg   %ax,%ax
40000ed8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000edf:	00 
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
40000ee0:	83 c0 01             	add    $0x1,%eax
40000ee3:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
40000ee6:	39 f0                	cmp    %esi,%eax
40000ee8:	74 16                	je     40000f00 <memcmp+0x40>
		if (*s1 != *s2)
40000eea:	0f b6 08             	movzbl (%eax),%ecx
40000eed:	0f b6 1a             	movzbl (%edx),%ebx
40000ef0:	38 d9                	cmp    %bl,%cl
40000ef2:	74 ec                	je     40000ee0 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
40000ef4:	0f b6 c1             	movzbl %cl,%eax
40000ef7:	29 d8                	sub    %ebx,%eax
	}

	return 0;
}
40000ef9:	5b                   	pop    %ebx
40000efa:	5e                   	pop    %esi
40000efb:	5d                   	pop    %ebp
40000efc:	c3                   	ret
40000efd:	8d 76 00             	lea    0x0(%esi),%esi
40000f00:	5b                   	pop    %ebx
	return 0;
40000f01:	31 c0                	xor    %eax,%eax
}
40000f03:	5e                   	pop    %esi
40000f04:	5d                   	pop    %ebp
40000f05:	c3                   	ret
40000f06:	66 90                	xchg   %ax,%ax
40000f08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f0f:	00 

40000f10 <memchr>:

void *
memchr(const void *s, int c, size_t n)
{
40000f10:	55                   	push   %ebp
40000f11:	89 e5                	mov    %esp,%ebp
40000f13:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
40000f16:	8b 55 10             	mov    0x10(%ebp),%edx
40000f19:	01 c2                	add    %eax,%edx
	for (; s < ends; s++)
40000f1b:	39 d0                	cmp    %edx,%eax
40000f1d:	73 21                	jae    40000f40 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000f1f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
40000f23:	eb 12                	jmp    40000f37 <memchr+0x27>
40000f25:	8d 76 00             	lea    0x0(%esi),%esi
40000f28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f2f:	00 
	for (; s < ends; s++)
40000f30:	83 c0 01             	add    $0x1,%eax
40000f33:	39 c2                	cmp    %eax,%edx
40000f35:	74 09                	je     40000f40 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000f37:	38 08                	cmp    %cl,(%eax)
40000f39:	75 f5                	jne    40000f30 <memchr+0x20>
			return (void *) s;
	return NULL;
}
40000f3b:	5d                   	pop    %ebp
40000f3c:	c3                   	ret
40000f3d:	8d 76 00             	lea    0x0(%esi),%esi
	return NULL;
40000f40:	31 c0                	xor    %eax,%eax
}
40000f42:	5d                   	pop    %ebp
40000f43:	c3                   	ret
40000f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f4f:	00 

40000f50 <memzero>:

void *
memzero(void *v, size_t n)
{
40000f50:	55                   	push   %ebp
40000f51:	89 e5                	mov    %esp,%ebp
40000f53:	57                   	push   %edi
40000f54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000f57:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000f5a:	85 c9                	test   %ecx,%ecx
40000f5c:	74 11                	je     40000f6f <memzero+0x1f>
	if ((int)v%4 == 0 && n%4 == 0) {
40000f5e:	89 d0                	mov    %edx,%eax
40000f60:	09 c8                	or     %ecx,%eax
40000f62:	83 e0 03             	and    $0x3,%eax
40000f65:	75 19                	jne    40000f80 <memzero+0x30>
			     :: "D" (v), "a" (c), "c" (n/4)
40000f67:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000f6a:	89 d7                	mov    %edx,%edi
40000f6c:	fc                   	cld
40000f6d:	f3 ab                	rep stos %eax,%es:(%edi)
	return memset(v, 0, n);
}
40000f6f:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000f72:	89 d0                	mov    %edx,%eax
40000f74:	c9                   	leave
40000f75:	c3                   	ret
40000f76:	66 90                	xchg   %ax,%ax
40000f78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f7f:	00 
		asm volatile("cld; rep stosb\n"
40000f80:	89 d7                	mov    %edx,%edi
40000f82:	31 c0                	xor    %eax,%eax
40000f84:	fc                   	cld
40000f85:	f3 aa                	rep stos %al,%es:(%edi)
}
40000f87:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000f8a:	89 d0                	mov    %edx,%eax
40000f8c:	c9                   	leave
40000f8d:	c3                   	ret
40000f8e:	66 90                	xchg   %ax,%ax

40000f90 <sigaction>:
#include <signal.h>
#include <syscall.h>

int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
40000f90:	55                   	push   %ebp

static gcc_inline int
sys_sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
	int errno;
	asm volatile ("int %1"
40000f91:	b8 1a 00 00 00       	mov    $0x1a,%eax
40000f96:	89 e5                	mov    %esp,%ebp
40000f98:	53                   	push   %ebx
40000f99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000f9c:	8b 55 10             	mov    0x10(%ebp),%edx
40000f9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000fa2:	cd 30                	int    $0x30
		        "a" (SYS_sigaction),
		        "b" (signum),
		        "c" (act),
		        "d" (oldact)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000fa4:	f7 d8                	neg    %eax
    return sys_sigaction(signum, act, oldact);
}
40000fa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000fa9:	c9                   	leave
40000faa:	19 c0                	sbb    %eax,%eax
40000fac:	c3                   	ret
40000fad:	8d 76 00             	lea    0x0(%esi),%esi

40000fb0 <kill>:

int kill(int pid, int signum)
{
40000fb0:	55                   	push   %ebp

static gcc_inline int
sys_kill(int pid, int signum)
{
	int errno;
	asm volatile ("int %1"
40000fb1:	b8 1b 00 00 00       	mov    $0x1b,%eax
40000fb6:	89 e5                	mov    %esp,%ebp
40000fb8:	53                   	push   %ebx
40000fb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000fbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000fbf:	cd 30                	int    $0x30
		      : "i" (T_SYSCALL),
		        "a" (SYS_kill),
		        "b" (pid),
		        "c" (signum)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000fc1:	f7 d8                	neg    %eax
    return sys_kill(pid, signum);
}
40000fc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000fc6:	c9                   	leave
40000fc7:	19 c0                	sbb    %eax,%eax
40000fc9:	c3                   	ret
40000fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000fd0 <pause>:

static gcc_inline int
sys_pause(void)
{
	int errno;
	asm volatile ("int %1"
40000fd0:	b8 1c 00 00 00       	mov    $0x1c,%eax
40000fd5:	cd 30                	int    $0x30
		      : "=a" (errno)
		      : "i" (T_SYSCALL),
		        "a" (SYS_pause)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000fd7:	f7 d8                	neg    %eax
40000fd9:	19 c0                	sbb    %eax,%eax

int pause(void)
{
    return sys_pause();
}
40000fdb:	c3                   	ret
40000fdc:	66 90                	xchg   %ax,%ax
40000fde:	66 90                	xchg   %ax,%ax

40000fe0 <__udivdi3>:
40000fe0:	55                   	push   %ebp
40000fe1:	89 e5                	mov    %esp,%ebp
40000fe3:	57                   	push   %edi
40000fe4:	56                   	push   %esi
40000fe5:	53                   	push   %ebx
40000fe6:	83 ec 1c             	sub    $0x1c,%esp
40000fe9:	8b 75 08             	mov    0x8(%ebp),%esi
40000fec:	8b 45 14             	mov    0x14(%ebp),%eax
40000fef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000ff2:	8b 7d 10             	mov    0x10(%ebp),%edi
40000ff5:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40000ff8:	85 c0                	test   %eax,%eax
40000ffa:	75 1c                	jne    40001018 <__udivdi3+0x38>
40000ffc:	39 fb                	cmp    %edi,%ebx
40000ffe:	73 50                	jae    40001050 <__udivdi3+0x70>
40001000:	89 f0                	mov    %esi,%eax
40001002:	31 f6                	xor    %esi,%esi
40001004:	89 da                	mov    %ebx,%edx
40001006:	f7 f7                	div    %edi
40001008:	89 f2                	mov    %esi,%edx
4000100a:	83 c4 1c             	add    $0x1c,%esp
4000100d:	5b                   	pop    %ebx
4000100e:	5e                   	pop    %esi
4000100f:	5f                   	pop    %edi
40001010:	5d                   	pop    %ebp
40001011:	c3                   	ret
40001012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001018:	39 c3                	cmp    %eax,%ebx
4000101a:	73 14                	jae    40001030 <__udivdi3+0x50>
4000101c:	31 f6                	xor    %esi,%esi
4000101e:	31 c0                	xor    %eax,%eax
40001020:	89 f2                	mov    %esi,%edx
40001022:	83 c4 1c             	add    $0x1c,%esp
40001025:	5b                   	pop    %ebx
40001026:	5e                   	pop    %esi
40001027:	5f                   	pop    %edi
40001028:	5d                   	pop    %ebp
40001029:	c3                   	ret
4000102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001030:	0f bd f0             	bsr    %eax,%esi
40001033:	83 f6 1f             	xor    $0x1f,%esi
40001036:	75 48                	jne    40001080 <__udivdi3+0xa0>
40001038:	39 d8                	cmp    %ebx,%eax
4000103a:	72 07                	jb     40001043 <__udivdi3+0x63>
4000103c:	31 c0                	xor    %eax,%eax
4000103e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
40001041:	72 dd                	jb     40001020 <__udivdi3+0x40>
40001043:	b8 01 00 00 00       	mov    $0x1,%eax
40001048:	eb d6                	jmp    40001020 <__udivdi3+0x40>
4000104a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001050:	89 f9                	mov    %edi,%ecx
40001052:	85 ff                	test   %edi,%edi
40001054:	75 0b                	jne    40001061 <__udivdi3+0x81>
40001056:	b8 01 00 00 00       	mov    $0x1,%eax
4000105b:	31 d2                	xor    %edx,%edx
4000105d:	f7 f7                	div    %edi
4000105f:	89 c1                	mov    %eax,%ecx
40001061:	31 d2                	xor    %edx,%edx
40001063:	89 d8                	mov    %ebx,%eax
40001065:	f7 f1                	div    %ecx
40001067:	89 c6                	mov    %eax,%esi
40001069:	8b 45 e4             	mov    -0x1c(%ebp),%eax
4000106c:	f7 f1                	div    %ecx
4000106e:	89 f2                	mov    %esi,%edx
40001070:	83 c4 1c             	add    $0x1c,%esp
40001073:	5b                   	pop    %ebx
40001074:	5e                   	pop    %esi
40001075:	5f                   	pop    %edi
40001076:	5d                   	pop    %ebp
40001077:	c3                   	ret
40001078:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000107f:	00 
40001080:	89 f1                	mov    %esi,%ecx
40001082:	ba 20 00 00 00       	mov    $0x20,%edx
40001087:	29 f2                	sub    %esi,%edx
40001089:	d3 e0                	shl    %cl,%eax
4000108b:	89 45 e0             	mov    %eax,-0x20(%ebp)
4000108e:	89 d1                	mov    %edx,%ecx
40001090:	89 f8                	mov    %edi,%eax
40001092:	d3 e8                	shr    %cl,%eax
40001094:	8b 4d e0             	mov    -0x20(%ebp),%ecx
40001097:	09 c1                	or     %eax,%ecx
40001099:	89 d8                	mov    %ebx,%eax
4000109b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
4000109e:	89 f1                	mov    %esi,%ecx
400010a0:	d3 e7                	shl    %cl,%edi
400010a2:	89 d1                	mov    %edx,%ecx
400010a4:	d3 e8                	shr    %cl,%eax
400010a6:	89 f1                	mov    %esi,%ecx
400010a8:	89 7d dc             	mov    %edi,-0x24(%ebp)
400010ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
400010ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400010b1:	d3 e3                	shl    %cl,%ebx
400010b3:	89 d1                	mov    %edx,%ecx
400010b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
400010b8:	d3 e8                	shr    %cl,%eax
400010ba:	09 d8                	or     %ebx,%eax
400010bc:	f7 75 e0             	divl   -0x20(%ebp)
400010bf:	89 d3                	mov    %edx,%ebx
400010c1:	89 c7                	mov    %eax,%edi
400010c3:	f7 65 dc             	mull   -0x24(%ebp)
400010c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
400010c9:	39 d3                	cmp    %edx,%ebx
400010cb:	72 23                	jb     400010f0 <__udivdi3+0x110>
400010cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400010d0:	89 f1                	mov    %esi,%ecx
400010d2:	d3 e0                	shl    %cl,%eax
400010d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
400010d7:	73 04                	jae    400010dd <__udivdi3+0xfd>
400010d9:	39 d3                	cmp    %edx,%ebx
400010db:	74 13                	je     400010f0 <__udivdi3+0x110>
400010dd:	89 f8                	mov    %edi,%eax
400010df:	31 f6                	xor    %esi,%esi
400010e1:	e9 3a ff ff ff       	jmp    40001020 <__udivdi3+0x40>
400010e6:	66 90                	xchg   %ax,%ax
400010e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400010ef:	00 
400010f0:	8d 47 ff             	lea    -0x1(%edi),%eax
400010f3:	31 f6                	xor    %esi,%esi
400010f5:	e9 26 ff ff ff       	jmp    40001020 <__udivdi3+0x40>
400010fa:	66 90                	xchg   %ax,%ax
400010fc:	66 90                	xchg   %ax,%ax
400010fe:	66 90                	xchg   %ax,%ax

40001100 <__umoddi3>:
40001100:	55                   	push   %ebp
40001101:	89 e5                	mov    %esp,%ebp
40001103:	57                   	push   %edi
40001104:	56                   	push   %esi
40001105:	53                   	push   %ebx
40001106:	83 ec 2c             	sub    $0x2c,%esp
40001109:	8b 5d 0c             	mov    0xc(%ebp),%ebx
4000110c:	8b 45 14             	mov    0x14(%ebp),%eax
4000110f:	8b 75 08             	mov    0x8(%ebp),%esi
40001112:	8b 7d 10             	mov    0x10(%ebp),%edi
40001115:	89 da                	mov    %ebx,%edx
40001117:	85 c0                	test   %eax,%eax
40001119:	75 15                	jne    40001130 <__umoddi3+0x30>
4000111b:	39 fb                	cmp    %edi,%ebx
4000111d:	73 51                	jae    40001170 <__umoddi3+0x70>
4000111f:	89 f0                	mov    %esi,%eax
40001121:	f7 f7                	div    %edi
40001123:	89 d0                	mov    %edx,%eax
40001125:	31 d2                	xor    %edx,%edx
40001127:	83 c4 2c             	add    $0x2c,%esp
4000112a:	5b                   	pop    %ebx
4000112b:	5e                   	pop    %esi
4000112c:	5f                   	pop    %edi
4000112d:	5d                   	pop    %ebp
4000112e:	c3                   	ret
4000112f:	90                   	nop
40001130:	89 75 e0             	mov    %esi,-0x20(%ebp)
40001133:	39 c3                	cmp    %eax,%ebx
40001135:	73 11                	jae    40001148 <__umoddi3+0x48>
40001137:	89 f0                	mov    %esi,%eax
40001139:	83 c4 2c             	add    $0x2c,%esp
4000113c:	5b                   	pop    %ebx
4000113d:	5e                   	pop    %esi
4000113e:	5f                   	pop    %edi
4000113f:	5d                   	pop    %ebp
40001140:	c3                   	ret
40001141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001148:	0f bd c8             	bsr    %eax,%ecx
4000114b:	83 f1 1f             	xor    $0x1f,%ecx
4000114e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
40001151:	75 3d                	jne    40001190 <__umoddi3+0x90>
40001153:	39 d8                	cmp    %ebx,%eax
40001155:	0f 82 cd 00 00 00    	jb     40001228 <__umoddi3+0x128>
4000115b:	39 fe                	cmp    %edi,%esi
4000115d:	0f 83 c5 00 00 00    	jae    40001228 <__umoddi3+0x128>
40001163:	8b 45 e0             	mov    -0x20(%ebp),%eax
40001166:	83 c4 2c             	add    $0x2c,%esp
40001169:	5b                   	pop    %ebx
4000116a:	5e                   	pop    %esi
4000116b:	5f                   	pop    %edi
4000116c:	5d                   	pop    %ebp
4000116d:	c3                   	ret
4000116e:	66 90                	xchg   %ax,%ax
40001170:	89 f9                	mov    %edi,%ecx
40001172:	85 ff                	test   %edi,%edi
40001174:	75 0b                	jne    40001181 <__umoddi3+0x81>
40001176:	b8 01 00 00 00       	mov    $0x1,%eax
4000117b:	31 d2                	xor    %edx,%edx
4000117d:	f7 f7                	div    %edi
4000117f:	89 c1                	mov    %eax,%ecx
40001181:	89 d8                	mov    %ebx,%eax
40001183:	31 d2                	xor    %edx,%edx
40001185:	f7 f1                	div    %ecx
40001187:	89 f0                	mov    %esi,%eax
40001189:	f7 f1                	div    %ecx
4000118b:	eb 96                	jmp    40001123 <__umoddi3+0x23>
4000118d:	8d 76 00             	lea    0x0(%esi),%esi
40001190:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001194:	ba 20 00 00 00       	mov    $0x20,%edx
40001199:	2b 55 e4             	sub    -0x1c(%ebp),%edx
4000119c:	89 55 e0             	mov    %edx,-0x20(%ebp)
4000119f:	d3 e0                	shl    %cl,%eax
400011a1:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
400011a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
400011a8:	89 f8                	mov    %edi,%eax
400011aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
400011ad:	d3 e8                	shr    %cl,%eax
400011af:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400011b3:	09 c2                	or     %eax,%edx
400011b5:	d3 e7                	shl    %cl,%edi
400011b7:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
400011bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
400011be:	89 da                	mov    %ebx,%edx
400011c0:	89 7d d8             	mov    %edi,-0x28(%ebp)
400011c3:	89 f7                	mov    %esi,%edi
400011c5:	d3 ea                	shr    %cl,%edx
400011c7:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400011cb:	d3 e3                	shl    %cl,%ebx
400011cd:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
400011d1:	d3 ef                	shr    %cl,%edi
400011d3:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400011d7:	89 f8                	mov    %edi,%eax
400011d9:	d3 e6                	shl    %cl,%esi
400011db:	09 d8                	or     %ebx,%eax
400011dd:	f7 75 dc             	divl   -0x24(%ebp)
400011e0:	89 d3                	mov    %edx,%ebx
400011e2:	89 75 d4             	mov    %esi,-0x2c(%ebp)
400011e5:	89 f7                	mov    %esi,%edi
400011e7:	f7 65 d8             	mull   -0x28(%ebp)
400011ea:	89 c6                	mov    %eax,%esi
400011ec:	89 d1                	mov    %edx,%ecx
400011ee:	39 d3                	cmp    %edx,%ebx
400011f0:	72 06                	jb     400011f8 <__umoddi3+0xf8>
400011f2:	75 0e                	jne    40001202 <__umoddi3+0x102>
400011f4:	39 c7                	cmp    %eax,%edi
400011f6:	73 0a                	jae    40001202 <__umoddi3+0x102>
400011f8:	2b 45 d8             	sub    -0x28(%ebp),%eax
400011fb:	1b 55 dc             	sbb    -0x24(%ebp),%edx
400011fe:	89 d1                	mov    %edx,%ecx
40001200:	89 c6                	mov    %eax,%esi
40001202:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40001205:	29 f0                	sub    %esi,%eax
40001207:	19 cb                	sbb    %ecx,%ebx
40001209:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
4000120d:	89 da                	mov    %ebx,%edx
4000120f:	d3 e2                	shl    %cl,%edx
40001211:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001215:	d3 e8                	shr    %cl,%eax
40001217:	d3 eb                	shr    %cl,%ebx
40001219:	09 d0                	or     %edx,%eax
4000121b:	89 da                	mov    %ebx,%edx
4000121d:	83 c4 2c             	add    $0x2c,%esp
40001220:	5b                   	pop    %ebx
40001221:	5e                   	pop    %esi
40001222:	5f                   	pop    %edi
40001223:	5d                   	pop    %ebp
40001224:	c3                   	ret
40001225:	8d 76 00             	lea    0x0(%esi),%esi
40001228:	89 da                	mov    %ebx,%edx
4000122a:	29 fe                	sub    %edi,%esi
4000122c:	19 c2                	sbb    %eax,%edx
4000122e:	89 75 e0             	mov    %esi,-0x20(%ebp)
40001231:	e9 2d ff ff ff       	jmp    40001163 <__umoddi3+0x63>
