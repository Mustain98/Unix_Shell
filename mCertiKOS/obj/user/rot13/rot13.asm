
obj/user/rot13/rot13:     file format elf32-i386


Disassembly of section .text:

40000000 <main>:
        return 'A' + ((c - 'A' + 13) % 26);
    return c;   /* non-alpha: pass through */
}

int main(int argc, char **argv)
{
40000000:	55                   	push   %ebp
sys_read(int fd, char *buf, size_t n)
{
	int errno;
	size_t ret;

	asm volatile("int %2"
40000001:	b8 07 00 00 00       	mov    $0x7,%eax
40000006:	ba 00 02 00 00       	mov    $0x200,%edx
4000000b:	89 e5                	mov    %esp,%ebp
4000000d:	57                   	push   %edi
4000000e:	56                   	push   %esi
4000000f:	8d 8d f4 fd ff ff    	lea    -0x20c(%ebp),%ecx
40000015:	53                   	push   %ebx
40000016:	31 db                	xor    %ebx,%ebx
40000018:	81 ec 00 02 00 00    	sub    $0x200,%esp
4000001e:	cd 30                	int    $0x30
    char buf[BUFSIZE];
    int  n, i;

    /* Read from stdin, apply ROT13 in-place, write to stdout. */
    while ((n = sys_read(0, buf, sizeof(buf))) > 0) {
40000020:	85 db                	test   %ebx,%ebx
40000022:	0f 8e 94 00 00 00    	jle    400000bc <main+0xbc>
40000028:	89 df                	mov    %ebx,%edi
4000002a:	85 c0                	test   %eax,%eax
4000002c:	0f 85 8a 00 00 00    	jne    400000bc <main+0xbc>
        for (i = 0; i < n; i++)
40000032:	8d 8d f4 fd ff ff    	lea    -0x20c(%ebp),%ecx
40000038:	8d 1c 39             	lea    (%ecx,%edi,1),%ebx
4000003b:	eb 29                	jmp    40000066 <main+0x66>
4000003d:	8d 76 00             	lea    0x0(%esi),%esi
    if (c >= 'A' && c <= 'Z')
40000040:	8d 50 bf             	lea    -0x41(%eax),%edx
40000043:	80 fa 19             	cmp    $0x19,%dl
40000046:	77 15                	ja     4000005d <main+0x5d>
        return 'A' + ((c - 'A' + 13) % 26);
40000048:	8d 70 cc             	lea    -0x34(%eax),%esi
4000004b:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
40000050:	f7 e6                	mul    %esi
40000052:	c1 ea 03             	shr    $0x3,%edx
40000055:	6b d2 1a             	imul   $0x1a,%edx,%edx
40000058:	29 d6                	sub    %edx,%esi
4000005a:	8d 46 41             	lea    0x41(%esi),%eax
            buf[i] = rot13_char(buf[i]);
4000005d:	88 01                	mov    %al,(%ecx)
        for (i = 0; i < n; i++)
4000005f:	83 c1 01             	add    $0x1,%ecx
40000062:	39 cb                	cmp    %ecx,%ebx
40000064:	74 2a                	je     40000090 <main+0x90>
            buf[i] = rot13_char(buf[i]);
40000066:	0f be 01             	movsbl (%ecx),%eax
    if (c >= 'a' && c <= 'z')
40000069:	8d 50 9f             	lea    -0x61(%eax),%edx
4000006c:	80 fa 19             	cmp    $0x19,%dl
4000006f:	77 cf                	ja     40000040 <main+0x40>
        return 'a' + ((c - 'a' + 13) % 26);
40000071:	8d 70 ac             	lea    -0x54(%eax),%esi
40000074:	b8 4f ec c4 4e       	mov    $0x4ec4ec4f,%eax
        for (i = 0; i < n; i++)
40000079:	83 c1 01             	add    $0x1,%ecx
        return 'a' + ((c - 'a' + 13) % 26);
4000007c:	f7 e6                	mul    %esi
4000007e:	c1 ea 03             	shr    $0x3,%edx
40000081:	6b d2 1a             	imul   $0x1a,%edx,%edx
40000084:	29 d6                	sub    %edx,%esi
40000086:	8d 46 61             	lea    0x61(%esi),%eax
            buf[i] = rot13_char(buf[i]);
40000089:	88 41 ff             	mov    %al,-0x1(%ecx)
        for (i = 0; i < n; i++)
4000008c:	39 cb                	cmp    %ecx,%ebx
4000008e:	75 d6                	jne    40000066 <main+0x66>
sys_write(int fd, char *p, int n)
{
	int errno;
	size_t ret;

	asm volatile("int %2"
40000090:	b8 08 00 00 00       	mov    $0x8,%eax
40000095:	bb 01 00 00 00       	mov    $0x1,%ebx
4000009a:	8d 8d f4 fd ff ff    	lea    -0x20c(%ebp),%ecx
400000a0:	89 fa                	mov    %edi,%edx
400000a2:	cd 30                	int    $0x30
	asm volatile("int %2"
400000a4:	b8 07 00 00 00       	mov    $0x7,%eax
400000a9:	31 db                	xor    %ebx,%ebx
400000ab:	ba 00 02 00 00       	mov    $0x200,%edx
400000b0:	cd 30                	int    $0x30
	return errno ? -1 : ret;
400000b2:	89 df                	mov    %ebx,%edi
    while ((n = sys_read(0, buf, sizeof(buf))) > 0) {
400000b4:	85 db                	test   %ebx,%ebx
400000b6:	0f 8f 6e ff ff ff    	jg     4000002a <main+0x2a>
sys_close(int fd)
{
	int errno;
	int ret;

	asm volatile("int %2"
400000bc:	bb 01 00 00 00       	mov    $0x1,%ebx
400000c1:	b8 06 00 00 00       	mov    $0x6,%eax
400000c6:	cd 30                	int    $0x30
400000c8:	31 db                	xor    %ebx,%ebx
400000ca:	b8 06 00 00 00       	mov    $0x6,%eax
400000cf:	cd 30                	int    $0x30
     * in a multi-stage pipeline (e.g.  LS | CAT | ROT13) all get EOF.
     */
    sys_close(1);
    sys_close(0);
    return 0;
}
400000d1:	81 c4 00 02 00 00    	add    $0x200,%esp
400000d7:	31 c0                	xor    %eax,%eax
400000d9:	5b                   	pop    %ebx
400000da:	5e                   	pop    %esi
400000db:	5f                   	pop    %edi
400000dc:	5d                   	pop    %ebp
400000dd:	c3                   	ret

400000de <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary/
	 */
	testl	$0x0fffffff, %esp
400000de:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
400000e4:	75 04                	jne    400000ea <args_exist>

400000e6 <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
400000e6:	6a 00                	push   $0x0
	pushl	$0
400000e8:	6a 00                	push   $0x0

400000ea <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
400000ea:	e8 11 ff ff ff       	call   40000000 <main>

	/* When returning, save return value */
	pushl	%eax
400000ef:	50                   	push   %eax

	/* Syscall SYS_exit (30) */
	movl	$30, %eax
400000f0:	b8 1e 00 00 00       	mov    $0x1e,%eax
	int	$48
400000f5:	cd 30                	int    $0x30

400000f7 <spin>:

spin:
	call	yield
400000f7:	e8 14 09 00 00       	call   40000a10 <yield>
	jmp	spin
400000fc:	eb f9                	jmp    400000f7 <spin>
400000fe:	66 90                	xchg   %ax,%ax

40000100 <debug>:
#include <stdarg.h>
#include <stdio.h>

void
debug(const char *file, int line, const char *fmt, ...)
{
40000100:	55                   	push   %ebp
40000101:	89 e5                	mov    %esp,%ebp
40000103:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[D] %s:%d: ", file, line);
40000106:	ff 75 0c             	push   0xc(%ebp)
40000109:	ff 75 08             	push   0x8(%ebp)
4000010c:	68 58 12 00 40       	push   $0x40001258
40000111:	e8 0a 02 00 00       	call   40000320 <printf>
	vcprintf(fmt, ap);
40000116:	58                   	pop    %eax
40000117:	8d 45 14             	lea    0x14(%ebp),%eax
4000011a:	5a                   	pop    %edx
4000011b:	50                   	push   %eax
4000011c:	ff 75 10             	push   0x10(%ebp)
4000011f:	e8 9c 01 00 00       	call   400002c0 <vcprintf>
	va_end(ap);
}
40000124:	83 c4 10             	add    $0x10,%esp
40000127:	c9                   	leave
40000128:	c3                   	ret
40000129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000130 <warn>:

void
warn(const char *file, int line, const char *fmt, ...)
{
40000130:	55                   	push   %ebp
40000131:	89 e5                	mov    %esp,%ebp
40000133:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[W] %s:%d: ", file, line);
40000136:	ff 75 0c             	push   0xc(%ebp)
40000139:	ff 75 08             	push   0x8(%ebp)
4000013c:	68 64 12 00 40       	push   $0x40001264
40000141:	e8 da 01 00 00       	call   40000320 <printf>
	vcprintf(fmt, ap);
40000146:	58                   	pop    %eax
40000147:	8d 45 14             	lea    0x14(%ebp),%eax
4000014a:	5a                   	pop    %edx
4000014b:	50                   	push   %eax
4000014c:	ff 75 10             	push   0x10(%ebp)
4000014f:	e8 6c 01 00 00       	call   400002c0 <vcprintf>
	va_end(ap);
}
40000154:	83 c4 10             	add    $0x10,%esp
40000157:	c9                   	leave
40000158:	c3                   	ret
40000159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000160 <panic>:

void
panic(const char *file, int line, const char *fmt, ...)
{
40000160:	55                   	push   %ebp
40000161:	89 e5                	mov    %esp,%ebp
40000163:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[P] %s:%d: ", file, line);
40000166:	ff 75 0c             	push   0xc(%ebp)
40000169:	ff 75 08             	push   0x8(%ebp)
4000016c:	68 70 12 00 40       	push   $0x40001270
40000171:	e8 aa 01 00 00       	call   40000320 <printf>
	vcprintf(fmt, ap);
40000176:	58                   	pop    %eax
40000177:	8d 45 14             	lea    0x14(%ebp),%eax
4000017a:	5a                   	pop    %edx
4000017b:	50                   	push   %eax
4000017c:	ff 75 10             	push   0x10(%ebp)
4000017f:	e8 3c 01 00 00       	call   400002c0 <vcprintf>
40000184:	83 c4 10             	add    $0x10,%esp
40000187:	90                   	nop
40000188:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000018f:	00 
	va_end(ap);

	while (1)
		yield();
40000190:	e8 7b 08 00 00       	call   40000a10 <yield>
	while (1)
40000195:	eb f9                	jmp    40000190 <panic+0x30>
40000197:	66 90                	xchg   %ax,%ax
40000199:	66 90                	xchg   %ax,%ax
4000019b:	66 90                	xchg   %ax,%ax
4000019d:	66 90                	xchg   %ax,%ax
4000019f:	90                   	nop

400001a0 <atoi>:
#include <stdlib.h>

int
atoi(const char *buf, int *i)
{
400001a0:	55                   	push   %ebp
400001a1:	89 e5                	mov    %esp,%ebp
400001a3:	57                   	push   %edi
400001a4:	56                   	push   %esi
400001a5:	53                   	push   %ebx
400001a6:	83 ec 04             	sub    $0x4,%esp
400001a9:	8b 75 08             	mov    0x8(%ebp),%esi
	int loc = 0;
	int numstart = 0;
	int acc = 0;
	int negative = 0;
	if (buf[loc] == '+')
400001ac:	0f b6 06             	movzbl (%esi),%eax
400001af:	3c 2b                	cmp    $0x2b,%al
400001b1:	0f 84 89 00 00 00    	je     40000240 <atoi+0xa0>
		loc++;
	else if (buf[loc] == '-') {
400001b7:	3c 2d                	cmp    $0x2d,%al
400001b9:	74 65                	je     40000220 <atoi+0x80>
		negative = 1;
		loc++;
	}
	numstart = loc;
	// no grab the numbers
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400001bb:	8d 50 d0             	lea    -0x30(%eax),%edx
	int negative = 0;
400001be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int loc = 0;
400001c5:	31 ff                	xor    %edi,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400001c7:	80 fa 09             	cmp    $0x9,%dl
400001ca:	0f 87 8c 00 00 00    	ja     4000025c <atoi+0xbc>
	int loc = 0;
400001d0:	89 f9                	mov    %edi,%ecx
	int acc = 0;
400001d2:	31 d2                	xor    %edx,%edx
400001d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400001d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400001df:	00 
		acc = acc*10 + (buf[loc]-'0');
400001e0:	83 e8 30             	sub    $0x30,%eax
400001e3:	8d 14 92             	lea    (%edx,%edx,4),%edx
		loc++;
400001e6:	83 c1 01             	add    $0x1,%ecx
		acc = acc*10 + (buf[loc]-'0');
400001e9:	0f be c0             	movsbl %al,%eax
400001ec:	8d 14 50             	lea    (%eax,%edx,2),%edx
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400001ef:	0f b6 04 0e          	movzbl (%esi,%ecx,1),%eax
400001f3:	8d 58 d0             	lea    -0x30(%eax),%ebx
400001f6:	80 fb 09             	cmp    $0x9,%bl
400001f9:	76 e5                	jbe    400001e0 <atoi+0x40>
	}
	if (numstart == loc) {
400001fb:	39 f9                	cmp    %edi,%ecx
400001fd:	74 5d                	je     4000025c <atoi+0xbc>
		// no numbers have actually been scanned
		return 0;
	}
	if (negative)
		acc = - acc;
400001ff:	8b 5d f0             	mov    -0x10(%ebp),%ebx
40000202:	89 d0                	mov    %edx,%eax
40000204:	f7 d8                	neg    %eax
40000206:	85 db                	test   %ebx,%ebx
40000208:	0f 45 d0             	cmovne %eax,%edx
	*i = acc;
4000020b:	8b 45 0c             	mov    0xc(%ebp),%eax
4000020e:	89 10                	mov    %edx,(%eax)
	return loc;
}
40000210:	83 c4 04             	add    $0x4,%esp
40000213:	89 c8                	mov    %ecx,%eax
40000215:	5b                   	pop    %ebx
40000216:	5e                   	pop    %esi
40000217:	5f                   	pop    %edi
40000218:	5d                   	pop    %ebp
40000219:	c3                   	ret
4000021a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000220:	0f b6 46 01          	movzbl 0x1(%esi),%eax
40000224:	8d 50 d0             	lea    -0x30(%eax),%edx
40000227:	80 fa 09             	cmp    $0x9,%dl
4000022a:	77 30                	ja     4000025c <atoi+0xbc>
		negative = 1;
4000022c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		loc++;
40000233:	bf 01 00 00 00       	mov    $0x1,%edi
40000238:	eb 96                	jmp    400001d0 <atoi+0x30>
4000023a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000240:	0f b6 46 01          	movzbl 0x1(%esi),%eax
	int negative = 0;
40000244:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		loc++;
4000024b:	bf 01 00 00 00       	mov    $0x1,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000250:	8d 50 d0             	lea    -0x30(%eax),%edx
40000253:	80 fa 09             	cmp    $0x9,%dl
40000256:	0f 86 74 ff ff ff    	jbe    400001d0 <atoi+0x30>
}
4000025c:	83 c4 04             	add    $0x4,%esp
		return 0;
4000025f:	31 c9                	xor    %ecx,%ecx
}
40000261:	5b                   	pop    %ebx
40000262:	89 c8                	mov    %ecx,%eax
40000264:	5e                   	pop    %esi
40000265:	5f                   	pop    %edi
40000266:	5d                   	pop    %ebp
40000267:	c3                   	ret
40000268:	66 90                	xchg   %ax,%ax
4000026a:	66 90                	xchg   %ax,%ax
4000026c:	66 90                	xchg   %ax,%ax
4000026e:	66 90                	xchg   %ax,%ax

40000270 <putch>:
	char buf[MAX_BUF];
};

static void
putch(int ch, struct printbuf *b)
{
40000270:	55                   	push   %ebp
40000271:	89 e5                	mov    %esp,%ebp
40000273:	56                   	push   %esi
40000274:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
40000277:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
4000027a:	53                   	push   %ebx
	b->buf[b->idx++] = ch;
4000027b:	8b 06                	mov    (%esi),%eax
4000027d:	8d 50 01             	lea    0x1(%eax),%edx
40000280:	89 16                	mov    %edx,(%esi)
40000282:	88 4c 06 08          	mov    %cl,0x8(%esi,%eax,1)
	if (b->idx == MAX_BUF-1) {
40000286:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
4000028c:	75 1c                	jne    400002aa <putch+0x3a>
		b->buf[b->idx] = 0;
4000028e:	c6 86 07 10 00 00 00 	movb   $0x0,0x1007(%esi)
		puts(b->buf, b->idx);
40000295:	8d 4e 08             	lea    0x8(%esi),%ecx
	asm volatile("int %2"
40000298:	b8 08 00 00 00       	mov    $0x8,%eax
4000029d:	bb 01 00 00 00       	mov    $0x1,%ebx
400002a2:	cd 30                	int    $0x30
		b->idx = 0;
400002a4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	}
	b->cnt++;
400002aa:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
400002ae:	5b                   	pop    %ebx
400002af:	5e                   	pop    %esi
400002b0:	5d                   	pop    %ebp
400002b1:	c3                   	ret
400002b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400002b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400002bf:	00 

400002c0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
400002c0:	55                   	push   %ebp
400002c1:	89 e5                	mov    %esp,%ebp
400002c3:	53                   	push   %ebx
400002c4:	bb 01 00 00 00       	mov    $0x1,%ebx
	struct printbuf b;

	b.idx = 0;
	b.cnt = 0;
	vprintfmt((void*)putch, &b, fmt, ap);
400002c9:	8d 85 f0 ef ff ff    	lea    -0x1010(%ebp),%eax
{
400002cf:	81 ec 14 10 00 00    	sub    $0x1014,%esp
	vprintfmt((void*)putch, &b, fmt, ap);
400002d5:	ff 75 0c             	push   0xc(%ebp)
400002d8:	ff 75 08             	push   0x8(%ebp)
400002db:	50                   	push   %eax
400002dc:	68 70 02 00 40       	push   $0x40000270
	b.idx = 0;
400002e1:	c7 85 f0 ef ff ff 00 	movl   $0x0,-0x1010(%ebp)
400002e8:	00 00 00 
	b.cnt = 0;
400002eb:	c7 85 f4 ef ff ff 00 	movl   $0x0,-0x100c(%ebp)
400002f2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
400002f5:	e8 26 01 00 00       	call   40000420 <vprintfmt>

	b.buf[b.idx] = 0;
400002fa:	8b 95 f0 ef ff ff    	mov    -0x1010(%ebp),%edx
40000300:	8d 8d f8 ef ff ff    	lea    -0x1008(%ebp),%ecx
40000306:	b8 08 00 00 00       	mov    $0x8,%eax
4000030b:	c6 84 15 f8 ef ff ff 	movb   $0x0,-0x1008(%ebp,%edx,1)
40000312:	00 
40000313:	cd 30                	int    $0x30
	puts(b.buf, b.idx);

	return b.cnt;
}
40000315:	8b 85 f4 ef ff ff    	mov    -0x100c(%ebp),%eax
4000031b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
4000031e:	c9                   	leave
4000031f:	c3                   	ret

40000320 <printf>:

int
printf(const char *fmt, ...)
{
40000320:	55                   	push   %ebp
40000321:	89 e5                	mov    %esp,%ebp
40000323:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
40000326:	8d 45 0c             	lea    0xc(%ebp),%eax
40000329:	50                   	push   %eax
4000032a:	ff 75 08             	push   0x8(%ebp)
4000032d:	e8 8e ff ff ff       	call   400002c0 <vcprintf>
	va_end(ap);

	return cnt;
}
40000332:	c9                   	leave
40000333:	c3                   	ret
40000334:	66 90                	xchg   %ax,%ax
40000336:	66 90                	xchg   %ax,%ax
40000338:	66 90                	xchg   %ax,%ax
4000033a:	66 90                	xchg   %ax,%ax
4000033c:	66 90                	xchg   %ax,%ax
4000033e:	66 90                	xchg   %ax,%ax

40000340 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
40000340:	55                   	push   %ebp
40000341:	89 e5                	mov    %esp,%ebp
40000343:	57                   	push   %edi
40000344:	89 c7                	mov    %eax,%edi
40000346:	56                   	push   %esi
40000347:	89 d6                	mov    %edx,%esi
40000349:	53                   	push   %ebx
4000034a:	83 ec 2c             	sub    $0x2c,%esp
4000034d:	8b 45 08             	mov    0x8(%ebp),%eax
40000350:	8b 55 0c             	mov    0xc(%ebp),%edx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
40000353:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
{
4000035a:	8b 4d 18             	mov    0x18(%ebp),%ecx
4000035d:	89 45 d8             	mov    %eax,-0x28(%ebp)
40000360:	8b 45 10             	mov    0x10(%ebp),%eax
40000363:	89 55 dc             	mov    %edx,-0x24(%ebp)
40000366:	8b 55 14             	mov    0x14(%ebp),%edx
40000369:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	if (num >= base) {
4000036c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
4000036f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
40000372:	1b 4d d4             	sbb    -0x2c(%ebp),%ecx
40000375:	89 45 d0             	mov    %eax,-0x30(%ebp)
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
40000378:	8d 5a ff             	lea    -0x1(%edx),%ebx
	if (num >= base) {
4000037b:	73 53                	jae    400003d0 <printnum+0x90>
		while (--width > 0)
4000037d:	83 fa 01             	cmp    $0x1,%edx
40000380:	7e 1f                	jle    400003a1 <printnum+0x61>
40000382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000388:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000038f:	00 
			putch(padc, putdat);
40000390:	83 ec 08             	sub    $0x8,%esp
40000393:	56                   	push   %esi
40000394:	ff 75 e4             	push   -0x1c(%ebp)
40000397:	ff d7                	call   *%edi
		while (--width > 0)
40000399:	83 c4 10             	add    $0x10,%esp
4000039c:	83 eb 01             	sub    $0x1,%ebx
4000039f:	75 ef                	jne    40000390 <printnum+0x50>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
400003a1:	89 75 0c             	mov    %esi,0xc(%ebp)
400003a4:	ff 75 d4             	push   -0x2c(%ebp)
400003a7:	ff 75 d0             	push   -0x30(%ebp)
400003aa:	ff 75 dc             	push   -0x24(%ebp)
400003ad:	ff 75 d8             	push   -0x28(%ebp)
400003b0:	e8 6b 0d 00 00       	call   40001120 <__umoddi3>
400003b5:	83 c4 10             	add    $0x10,%esp
400003b8:	0f be 80 7c 12 00 40 	movsbl 0x4000127c(%eax),%eax
400003bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
400003c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
	putch("0123456789abcdef"[num % base], putdat);
400003c5:	89 f8                	mov    %edi,%eax
}
400003c7:	5b                   	pop    %ebx
400003c8:	5e                   	pop    %esi
400003c9:	5f                   	pop    %edi
400003ca:	5d                   	pop    %ebp
	putch("0123456789abcdef"[num % base], putdat);
400003cb:	ff e0                	jmp    *%eax
400003cd:	8d 76 00             	lea    0x0(%esi),%esi
		printnum(putch, putdat, num / base, base, width - 1, padc);
400003d0:	83 ec 0c             	sub    $0xc,%esp
400003d3:	ff 75 e4             	push   -0x1c(%ebp)
400003d6:	53                   	push   %ebx
400003d7:	50                   	push   %eax
400003d8:	83 ec 08             	sub    $0x8,%esp
400003db:	ff 75 d4             	push   -0x2c(%ebp)
400003de:	ff 75 d0             	push   -0x30(%ebp)
400003e1:	ff 75 dc             	push   -0x24(%ebp)
400003e4:	ff 75 d8             	push   -0x28(%ebp)
400003e7:	e8 14 0c 00 00       	call   40001000 <__udivdi3>
400003ec:	83 c4 18             	add    $0x18,%esp
400003ef:	52                   	push   %edx
400003f0:	89 f2                	mov    %esi,%edx
400003f2:	50                   	push   %eax
400003f3:	89 f8                	mov    %edi,%eax
400003f5:	e8 46 ff ff ff       	call   40000340 <printnum>
400003fa:	83 c4 20             	add    $0x20,%esp
400003fd:	eb a2                	jmp    400003a1 <printnum+0x61>
400003ff:	90                   	nop

40000400 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
40000400:	55                   	push   %ebp
40000401:	89 e5                	mov    %esp,%ebp
40000403:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
40000406:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
4000040a:	8b 10                	mov    (%eax),%edx
4000040c:	3b 50 04             	cmp    0x4(%eax),%edx
4000040f:	73 0a                	jae    4000041b <sprintputch+0x1b>
		*b->buf++ = ch;
40000411:	8d 4a 01             	lea    0x1(%edx),%ecx
40000414:	89 08                	mov    %ecx,(%eax)
40000416:	8b 45 08             	mov    0x8(%ebp),%eax
40000419:	88 02                	mov    %al,(%edx)
}
4000041b:	5d                   	pop    %ebp
4000041c:	c3                   	ret
4000041d:	8d 76 00             	lea    0x0(%esi),%esi

40000420 <vprintfmt>:
{
40000420:	55                   	push   %ebp
40000421:	89 e5                	mov    %esp,%ebp
40000423:	57                   	push   %edi
40000424:	56                   	push   %esi
40000425:	53                   	push   %ebx
40000426:	83 ec 2c             	sub    $0x2c,%esp
40000429:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000042c:	8b 75 0c             	mov    0xc(%ebp),%esi
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000042f:	8b 45 10             	mov    0x10(%ebp),%eax
40000432:	8d 78 01             	lea    0x1(%eax),%edi
40000435:	0f b6 00             	movzbl (%eax),%eax
40000438:	83 f8 25             	cmp    $0x25,%eax
4000043b:	75 19                	jne    40000456 <vprintfmt+0x36>
4000043d:	eb 29                	jmp    40000468 <vprintfmt+0x48>
4000043f:	90                   	nop
			putch(ch, putdat);
40000440:	83 ec 08             	sub    $0x8,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
40000443:	83 c7 01             	add    $0x1,%edi
			putch(ch, putdat);
40000446:	56                   	push   %esi
40000447:	50                   	push   %eax
40000448:	ff d3                	call   *%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000044a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
4000044e:	83 c4 10             	add    $0x10,%esp
40000451:	83 f8 25             	cmp    $0x25,%eax
40000454:	74 12                	je     40000468 <vprintfmt+0x48>
			if (ch == '\0')
40000456:	85 c0                	test   %eax,%eax
40000458:	75 e6                	jne    40000440 <vprintfmt+0x20>
}
4000045a:	8d 65 f4             	lea    -0xc(%ebp),%esp
4000045d:	5b                   	pop    %ebx
4000045e:	5e                   	pop    %esi
4000045f:	5f                   	pop    %edi
40000460:	5d                   	pop    %ebp
40000461:	c3                   	ret
40000462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		padc = ' ';
40000468:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
		precision = -1;
4000046c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		altflag = 0;
40000471:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		width = -1;
40000478:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		lflag = 0;
4000047f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000486:	0f b6 17             	movzbl (%edi),%edx
40000489:	8d 47 01             	lea    0x1(%edi),%eax
4000048c:	89 45 10             	mov    %eax,0x10(%ebp)
4000048f:	8d 42 dd             	lea    -0x23(%edx),%eax
40000492:	3c 55                	cmp    $0x55,%al
40000494:	77 0a                	ja     400004a0 <vprintfmt+0x80>
40000496:	0f b6 c0             	movzbl %al,%eax
40000499:	ff 24 85 94 12 00 40 	jmp    *0x40001294(,%eax,4)
			putch('%', putdat);
400004a0:	83 ec 08             	sub    $0x8,%esp
400004a3:	56                   	push   %esi
400004a4:	6a 25                	push   $0x25
400004a6:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
400004a8:	83 c4 10             	add    $0x10,%esp
400004ab:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
400004af:	89 7d 10             	mov    %edi,0x10(%ebp)
400004b2:	0f 84 77 ff ff ff    	je     4000042f <vprintfmt+0xf>
400004b8:	89 f8                	mov    %edi,%eax
400004ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400004c0:	83 e8 01             	sub    $0x1,%eax
400004c3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
400004c7:	75 f7                	jne    400004c0 <vprintfmt+0xa0>
400004c9:	89 45 10             	mov    %eax,0x10(%ebp)
400004cc:	e9 5e ff ff ff       	jmp    4000042f <vprintfmt+0xf>
400004d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				if (ch < '0' || ch > '9')
400004d8:	0f be 47 01          	movsbl 0x1(%edi),%eax
				precision = precision * 10 + ch - '0';
400004dc:	8d 4a d0             	lea    -0x30(%edx),%ecx
		switch (ch = *(unsigned char *) fmt++) {
400004df:	8b 7d 10             	mov    0x10(%ebp),%edi
				if (ch < '0' || ch > '9')
400004e2:	8d 50 d0             	lea    -0x30(%eax),%edx
400004e5:	83 fa 09             	cmp    $0x9,%edx
400004e8:	77 2b                	ja     40000515 <vprintfmt+0xf5>
400004ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400004f0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400004f7:	00 
400004f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400004ff:	00 
				precision = precision * 10 + ch - '0';
40000500:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
			for (precision = 0; ; ++fmt) {
40000503:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
40000506:	8d 4c 50 d0          	lea    -0x30(%eax,%edx,2),%ecx
				ch = *fmt;
4000050a:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
4000050d:	8d 50 d0             	lea    -0x30(%eax),%edx
40000510:	83 fa 09             	cmp    $0x9,%edx
40000513:	76 eb                	jbe    40000500 <vprintfmt+0xe0>
			if (width < 0)
40000515:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000518:	85 c0                	test   %eax,%eax
				width = precision, precision = -1;
4000051a:	0f 48 c1             	cmovs  %ecx,%eax
4000051d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
40000520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000525:	0f 48 c8             	cmovs  %eax,%ecx
40000528:	e9 59 ff ff ff       	jmp    40000486 <vprintfmt+0x66>
			altflag = 1;
4000052d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000534:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000537:	e9 4a ff ff ff       	jmp    40000486 <vprintfmt+0x66>
			putch(ch, putdat);
4000053c:	83 ec 08             	sub    $0x8,%esp
4000053f:	56                   	push   %esi
40000540:	6a 25                	push   $0x25
40000542:	ff d3                	call   *%ebx
			break;
40000544:	83 c4 10             	add    $0x10,%esp
40000547:	e9 e3 fe ff ff       	jmp    4000042f <vprintfmt+0xf>
			precision = va_arg(ap, int);
4000054c:	8b 45 14             	mov    0x14(%ebp),%eax
		switch (ch = *(unsigned char *) fmt++) {
4000054f:	8b 7d 10             	mov    0x10(%ebp),%edi
			precision = va_arg(ap, int);
40000552:	8b 08                	mov    (%eax),%ecx
40000554:	83 c0 04             	add    $0x4,%eax
40000557:	89 45 14             	mov    %eax,0x14(%ebp)
			goto process_precision;
4000055a:	eb b9                	jmp    40000515 <vprintfmt+0xf5>
			if (width < 0)
4000055c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
4000055f:	31 c0                	xor    %eax,%eax
		switch (ch = *(unsigned char *) fmt++) {
40000561:	8b 7d 10             	mov    0x10(%ebp),%edi
			if (width < 0)
40000564:	85 d2                	test   %edx,%edx
40000566:	0f 49 c2             	cmovns %edx,%eax
40000569:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			goto reswitch;
4000056c:	e9 15 ff ff ff       	jmp    40000486 <vprintfmt+0x66>
			putch(va_arg(ap, int), putdat);
40000571:	83 ec 08             	sub    $0x8,%esp
40000574:	56                   	push   %esi
40000575:	8b 45 14             	mov    0x14(%ebp),%eax
40000578:	ff 30                	push   (%eax)
4000057a:	ff d3                	call   *%ebx
4000057c:	8b 45 14             	mov    0x14(%ebp),%eax
4000057f:	83 c0 04             	add    $0x4,%eax
			break;
40000582:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
40000585:	89 45 14             	mov    %eax,0x14(%ebp)
			break;
40000588:	e9 a2 fe ff ff       	jmp    4000042f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
4000058d:	8b 45 14             	mov    0x14(%ebp),%eax
40000590:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
40000592:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
40000596:	0f 8f af 01 00 00    	jg     4000074b <vprintfmt+0x32b>
		return va_arg(*ap, unsigned long);
4000059c:	83 c0 04             	add    $0x4,%eax
4000059f:	31 c9                	xor    %ecx,%ecx
400005a1:	bf 0a 00 00 00       	mov    $0xa,%edi
400005a6:	89 45 14             	mov    %eax,0x14(%ebp)
400005a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			printnum(putch, putdat, num, base, width, padc);
400005b0:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
400005b4:	83 ec 0c             	sub    $0xc,%esp
400005b7:	50                   	push   %eax
400005b8:	89 d8                	mov    %ebx,%eax
400005ba:	ff 75 e4             	push   -0x1c(%ebp)
400005bd:	57                   	push   %edi
400005be:	51                   	push   %ecx
400005bf:	52                   	push   %edx
400005c0:	89 f2                	mov    %esi,%edx
400005c2:	e8 79 fd ff ff       	call   40000340 <printnum>
			break;
400005c7:	83 c4 20             	add    $0x20,%esp
400005ca:	e9 60 fe ff ff       	jmp    4000042f <vprintfmt+0xf>
			putch('0', putdat);
400005cf:	83 ec 08             	sub    $0x8,%esp
			goto number;
400005d2:	bf 10 00 00 00       	mov    $0x10,%edi
			putch('0', putdat);
400005d7:	56                   	push   %esi
400005d8:	6a 30                	push   $0x30
400005da:	ff d3                	call   *%ebx
			putch('x', putdat);
400005dc:	58                   	pop    %eax
400005dd:	5a                   	pop    %edx
400005de:	56                   	push   %esi
400005df:	6a 78                	push   $0x78
400005e1:	ff d3                	call   *%ebx
			num = (unsigned long long)
400005e3:	8b 45 14             	mov    0x14(%ebp),%eax
400005e6:	31 c9                	xor    %ecx,%ecx
400005e8:	8b 10                	mov    (%eax),%edx
				(uintptr_t) va_arg(ap, void *);
400005ea:	83 c0 04             	add    $0x4,%eax
			goto number;
400005ed:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
400005f0:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;
400005f3:	eb bb                	jmp    400005b0 <vprintfmt+0x190>
		return va_arg(*ap, unsigned long long);
400005f5:	8b 45 14             	mov    0x14(%ebp),%eax
400005f8:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
400005fa:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
400005fe:	0f 8f 5a 01 00 00    	jg     4000075e <vprintfmt+0x33e>
		return va_arg(*ap, unsigned long);
40000604:	83 c0 04             	add    $0x4,%eax
40000607:	31 c9                	xor    %ecx,%ecx
40000609:	bf 10 00 00 00       	mov    $0x10,%edi
4000060e:	89 45 14             	mov    %eax,0x14(%ebp)
40000611:	eb 9d                	jmp    400005b0 <vprintfmt+0x190>
		return va_arg(*ap, long long);
40000613:	8b 45 14             	mov    0x14(%ebp),%eax
	if (lflag >= 2)
40000616:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
4000061a:	0f 8f 51 01 00 00    	jg     40000771 <vprintfmt+0x351>
		return va_arg(*ap, long);
40000620:	8b 4d 14             	mov    0x14(%ebp),%ecx
40000623:	8b 00                	mov    (%eax),%eax
40000625:	83 c1 04             	add    $0x4,%ecx
40000628:	99                   	cltd
40000629:	89 4d 14             	mov    %ecx,0x14(%ebp)
			if ((long long) num < 0) {
4000062c:	85 d2                	test   %edx,%edx
4000062e:	0f 88 68 01 00 00    	js     4000079c <vprintfmt+0x37c>
			num = getint(&ap, lflag);
40000634:	89 d1                	mov    %edx,%ecx
40000636:	bf 0a 00 00 00       	mov    $0xa,%edi
4000063b:	89 c2                	mov    %eax,%edx
4000063d:	e9 6e ff ff ff       	jmp    400005b0 <vprintfmt+0x190>
			lflag++;
40000642:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000646:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000649:	e9 38 fe ff ff       	jmp    40000486 <vprintfmt+0x66>
			putch('X', putdat);
4000064e:	83 ec 08             	sub    $0x8,%esp
40000651:	56                   	push   %esi
40000652:	6a 58                	push   $0x58
40000654:	ff d3                	call   *%ebx
			putch('X', putdat);
40000656:	59                   	pop    %ecx
40000657:	5f                   	pop    %edi
40000658:	56                   	push   %esi
40000659:	6a 58                	push   $0x58
4000065b:	ff d3                	call   *%ebx
			putch('X', putdat);
4000065d:	58                   	pop    %eax
4000065e:	5a                   	pop    %edx
4000065f:	56                   	push   %esi
40000660:	6a 58                	push   $0x58
40000662:	ff d3                	call   *%ebx
			break;
40000664:	83 c4 10             	add    $0x10,%esp
40000667:	e9 c3 fd ff ff       	jmp    4000042f <vprintfmt+0xf>
			if ((p = va_arg(ap, char *)) == NULL)
4000066c:	8b 45 14             	mov    0x14(%ebp),%eax
4000066f:	83 c0 04             	add    $0x4,%eax
40000672:	89 45 d4             	mov    %eax,-0x2c(%ebp)
40000675:	8b 45 14             	mov    0x14(%ebp),%eax
40000678:	8b 38                	mov    (%eax),%edi
			if (width > 0 && padc != '-')
4000067a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
4000067d:	85 c0                	test   %eax,%eax
4000067f:	0f 9f c0             	setg   %al
40000682:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
40000686:	0f 95 c2             	setne  %dl
40000689:	21 d0                	and    %edx,%eax
			if ((p = va_arg(ap, char *)) == NULL)
4000068b:	85 ff                	test   %edi,%edi
4000068d:	0f 84 32 01 00 00    	je     400007c5 <vprintfmt+0x3a5>
			if (width > 0 && padc != '-')
40000693:	84 c0                	test   %al,%al
40000695:	0f 85 4d 01 00 00    	jne    400007e8 <vprintfmt+0x3c8>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000069b:	0f be 07             	movsbl (%edi),%eax
4000069e:	89 c2                	mov    %eax,%edx
400006a0:	85 c0                	test   %eax,%eax
400006a2:	74 7b                	je     4000071f <vprintfmt+0x2ff>
400006a4:	89 5d 08             	mov    %ebx,0x8(%ebp)
400006a7:	83 c7 01             	add    $0x1,%edi
400006aa:	89 cb                	mov    %ecx,%ebx
400006ac:	89 75 0c             	mov    %esi,0xc(%ebp)
400006af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
400006b2:	eb 21                	jmp    400006d5 <vprintfmt+0x2b5>
400006b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					putch(ch, putdat);
400006b8:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006bb:	83 c7 01             	add    $0x1,%edi
					putch(ch, putdat);
400006be:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006c1:	83 ee 01             	sub    $0x1,%esi
					putch(ch, putdat);
400006c4:	50                   	push   %eax
400006c5:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006c8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
400006cc:	83 c4 10             	add    $0x10,%esp
400006cf:	89 c2                	mov    %eax,%edx
400006d1:	85 c0                	test   %eax,%eax
400006d3:	74 41                	je     40000716 <vprintfmt+0x2f6>
400006d5:	85 db                	test   %ebx,%ebx
400006d7:	78 05                	js     400006de <vprintfmt+0x2be>
400006d9:	83 eb 01             	sub    $0x1,%ebx
400006dc:	72 38                	jb     40000716 <vprintfmt+0x2f6>
				if (altflag && (ch < ' ' || ch > '~'))
400006de:	8b 4d d8             	mov    -0x28(%ebp),%ecx
400006e1:	85 c9                	test   %ecx,%ecx
400006e3:	74 d3                	je     400006b8 <vprintfmt+0x298>
400006e5:	0f be ca             	movsbl %dl,%ecx
400006e8:	83 e9 20             	sub    $0x20,%ecx
400006eb:	83 f9 5e             	cmp    $0x5e,%ecx
400006ee:	76 c8                	jbe    400006b8 <vprintfmt+0x298>
					putch('?', putdat);
400006f0:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006f3:	83 c7 01             	add    $0x1,%edi
					putch('?', putdat);
400006f6:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006f9:	83 ee 01             	sub    $0x1,%esi
					putch('?', putdat);
400006fc:	6a 3f                	push   $0x3f
400006fe:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000701:	0f be 4f ff          	movsbl -0x1(%edi),%ecx
40000705:	83 c4 10             	add    $0x10,%esp
40000708:	89 ca                	mov    %ecx,%edx
4000070a:	89 c8                	mov    %ecx,%eax
4000070c:	85 c9                	test   %ecx,%ecx
4000070e:	74 06                	je     40000716 <vprintfmt+0x2f6>
40000710:	85 db                	test   %ebx,%ebx
40000712:	79 c5                	jns    400006d9 <vprintfmt+0x2b9>
40000714:	eb d2                	jmp    400006e8 <vprintfmt+0x2c8>
40000716:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40000719:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000071c:	8b 75 0c             	mov    0xc(%ebp),%esi
			for (; width > 0; width--)
4000071f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000722:	85 c0                	test   %eax,%eax
40000724:	7e 1a                	jle    40000740 <vprintfmt+0x320>
40000726:	89 c7                	mov    %eax,%edi
40000728:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000072f:	00 
				putch(' ', putdat);
40000730:	83 ec 08             	sub    $0x8,%esp
40000733:	56                   	push   %esi
40000734:	6a 20                	push   $0x20
40000736:	ff d3                	call   *%ebx
			for (; width > 0; width--)
40000738:	83 c4 10             	add    $0x10,%esp
4000073b:	83 ef 01             	sub    $0x1,%edi
4000073e:	75 f0                	jne    40000730 <vprintfmt+0x310>
			if ((p = va_arg(ap, char *)) == NULL)
40000740:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40000743:	89 45 14             	mov    %eax,0x14(%ebp)
40000746:	e9 e4 fc ff ff       	jmp    4000042f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
4000074b:	8b 48 04             	mov    0x4(%eax),%ecx
4000074e:	83 c0 08             	add    $0x8,%eax
40000751:	bf 0a 00 00 00       	mov    $0xa,%edi
40000756:	89 45 14             	mov    %eax,0x14(%ebp)
40000759:	e9 52 fe ff ff       	jmp    400005b0 <vprintfmt+0x190>
4000075e:	8b 48 04             	mov    0x4(%eax),%ecx
40000761:	83 c0 08             	add    $0x8,%eax
40000764:	bf 10 00 00 00       	mov    $0x10,%edi
40000769:	89 45 14             	mov    %eax,0x14(%ebp)
4000076c:	e9 3f fe ff ff       	jmp    400005b0 <vprintfmt+0x190>
		return va_arg(*ap, long long);
40000771:	8b 4d 14             	mov    0x14(%ebp),%ecx
40000774:	8b 50 04             	mov    0x4(%eax),%edx
40000777:	8b 00                	mov    (%eax),%eax
40000779:	83 c1 08             	add    $0x8,%ecx
4000077c:	89 4d 14             	mov    %ecx,0x14(%ebp)
4000077f:	e9 a8 fe ff ff       	jmp    4000062c <vprintfmt+0x20c>
		switch (ch = *(unsigned char *) fmt++) {
40000784:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
40000788:	8b 7d 10             	mov    0x10(%ebp),%edi
4000078b:	e9 f6 fc ff ff       	jmp    40000486 <vprintfmt+0x66>
			padc = '-';
40000790:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000794:	8b 7d 10             	mov    0x10(%ebp),%edi
40000797:	e9 ea fc ff ff       	jmp    40000486 <vprintfmt+0x66>
				putch('-', putdat);
4000079c:	83 ec 08             	sub    $0x8,%esp
4000079f:	89 45 d8             	mov    %eax,-0x28(%ebp)
				num = -(long long) num;
400007a2:	bf 0a 00 00 00       	mov    $0xa,%edi
400007a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch('-', putdat);
400007aa:	56                   	push   %esi
400007ab:	6a 2d                	push   $0x2d
400007ad:	ff d3                	call   *%ebx
				num = -(long long) num;
400007af:	8b 45 d8             	mov    -0x28(%ebp),%eax
400007b2:	31 d2                	xor    %edx,%edx
400007b4:	f7 d8                	neg    %eax
400007b6:	1b 55 dc             	sbb    -0x24(%ebp),%edx
400007b9:	83 c4 10             	add    $0x10,%esp
400007bc:	89 d1                	mov    %edx,%ecx
400007be:	89 c2                	mov    %eax,%edx
400007c0:	e9 eb fd ff ff       	jmp    400005b0 <vprintfmt+0x190>
			if (width > 0 && padc != '-')
400007c5:	84 c0                	test   %al,%al
400007c7:	75 78                	jne    40000841 <vprintfmt+0x421>
400007c9:	89 5d 08             	mov    %ebx,0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400007cc:	bf 8e 12 00 40       	mov    $0x4000128e,%edi
400007d1:	ba 28 00 00 00       	mov    $0x28,%edx
400007d6:	89 cb                	mov    %ecx,%ebx
400007d8:	89 75 0c             	mov    %esi,0xc(%ebp)
400007db:	b8 28 00 00 00       	mov    $0x28,%eax
400007e0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
400007e3:	e9 ed fe ff ff       	jmp    400006d5 <vprintfmt+0x2b5>
				for (width -= strnlen(p, precision); width > 0; width--)
400007e8:	83 ec 08             	sub    $0x8,%esp
400007eb:	51                   	push   %ecx
400007ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
400007ef:	57                   	push   %edi
400007f0:	e8 eb 02 00 00       	call   40000ae0 <strnlen>
400007f5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
400007f8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
400007fb:	83 c4 10             	add    $0x10,%esp
400007fe:	85 c9                	test   %ecx,%ecx
40000800:	8b 4d d0             	mov    -0x30(%ebp),%ecx
40000803:	7e 71                	jle    40000876 <vprintfmt+0x456>
					putch(padc, putdat);
40000805:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
40000809:	89 4d cc             	mov    %ecx,-0x34(%ebp)
4000080c:	89 7d d0             	mov    %edi,-0x30(%ebp)
4000080f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
40000812:	89 45 e0             	mov    %eax,-0x20(%ebp)
40000815:	83 ec 08             	sub    $0x8,%esp
40000818:	56                   	push   %esi
40000819:	ff 75 e0             	push   -0x20(%ebp)
4000081c:	ff d3                	call   *%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
4000081e:	83 c4 10             	add    $0x10,%esp
40000821:	83 ef 01             	sub    $0x1,%edi
40000824:	75 ef                	jne    40000815 <vprintfmt+0x3f5>
40000826:	89 7d e4             	mov    %edi,-0x1c(%ebp)
40000829:	8b 7d d0             	mov    -0x30(%ebp),%edi
4000082c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000082f:	0f be 07             	movsbl (%edi),%eax
40000832:	89 c2                	mov    %eax,%edx
40000834:	85 c0                	test   %eax,%eax
40000836:	0f 85 68 fe ff ff    	jne    400006a4 <vprintfmt+0x284>
4000083c:	e9 ff fe ff ff       	jmp    40000740 <vprintfmt+0x320>
				for (width -= strnlen(p, precision); width > 0; width--)
40000841:	83 ec 08             	sub    $0x8,%esp
				p = "(null)";
40000844:	bf 8d 12 00 40       	mov    $0x4000128d,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
40000849:	51                   	push   %ecx
4000084a:	89 4d d0             	mov    %ecx,-0x30(%ebp)
4000084d:	68 8d 12 00 40       	push   $0x4000128d
40000852:	e8 89 02 00 00       	call   40000ae0 <strnlen>
40000857:	29 45 e4             	sub    %eax,-0x1c(%ebp)
4000085a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
4000085d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000860:	ba 28 00 00 00       	mov    $0x28,%edx
40000865:	b8 28 00 00 00       	mov    $0x28,%eax
				for (width -= strnlen(p, precision); width > 0; width--)
4000086a:	85 c9                	test   %ecx,%ecx
4000086c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
4000086f:	7f 94                	jg     40000805 <vprintfmt+0x3e5>
40000871:	e9 2e fe ff ff       	jmp    400006a4 <vprintfmt+0x284>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000876:	0f be 07             	movsbl (%edi),%eax
40000879:	89 c2                	mov    %eax,%edx
4000087b:	85 c0                	test   %eax,%eax
4000087d:	0f 85 21 fe ff ff    	jne    400006a4 <vprintfmt+0x284>
40000883:	e9 b8 fe ff ff       	jmp    40000740 <vprintfmt+0x320>
40000888:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000088f:	00 

40000890 <printfmt>:
{
40000890:	55                   	push   %ebp
40000891:	89 e5                	mov    %esp,%ebp
40000893:	83 ec 08             	sub    $0x8,%esp
	vprintfmt(putch, putdat, fmt, ap);
40000896:	8d 45 14             	lea    0x14(%ebp),%eax
40000899:	50                   	push   %eax
4000089a:	ff 75 10             	push   0x10(%ebp)
4000089d:	ff 75 0c             	push   0xc(%ebp)
400008a0:	ff 75 08             	push   0x8(%ebp)
400008a3:	e8 78 fb ff ff       	call   40000420 <vprintfmt>
}
400008a8:	83 c4 10             	add    $0x10,%esp
400008ab:	c9                   	leave
400008ac:	c3                   	ret
400008ad:	8d 76 00             	lea    0x0(%esi),%esi

400008b0 <vsprintf>:

int
vsprintf(char *buf, const char *fmt, va_list ap)
{
400008b0:	55                   	push   %ebp
400008b1:	89 e5                	mov    %esp,%ebp
400008b3:	83 ec 18             	sub    $0x18,%esp
	//assert(buf != NULL);
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400008b6:	8b 45 08             	mov    0x8(%ebp),%eax

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008b9:	ff 75 10             	push   0x10(%ebp)
400008bc:	ff 75 0c             	push   0xc(%ebp)
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400008bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
400008c5:	50                   	push   %eax
400008c6:	68 00 04 00 40       	push   $0x40000400
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400008cb:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
400008d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008d9:	e8 42 fb ff ff       	call   40000420 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
400008de:	8b 45 ec             	mov    -0x14(%ebp),%eax
400008e1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
400008e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
400008e7:	c9                   	leave
400008e8:	c3                   	ret
400008e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400008f0 <sprintf>:

int
sprintf(char *buf, const char *fmt, ...)
{
400008f0:	55                   	push   %ebp
400008f1:	89 e5                	mov    %esp,%ebp
400008f3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400008f6:	8b 45 08             	mov    0x8(%ebp),%eax
400008f9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
40000900:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
40000907:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000090a:	8d 45 10             	lea    0x10(%ebp),%eax
4000090d:	50                   	push   %eax
4000090e:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000911:	ff 75 0c             	push   0xc(%ebp)
40000914:	50                   	push   %eax
40000915:	68 00 04 00 40       	push   $0x40000400
4000091a:	e8 01 fb ff ff       	call   40000420 <vprintfmt>
	*b.buf = '\0';
4000091f:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000922:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsprintf(buf, fmt, ap);
	va_end(ap);

	return rc;
}
40000925:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000928:	c9                   	leave
40000929:	c3                   	ret
4000092a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000930 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
40000930:	55                   	push   %ebp
40000931:	89 e5                	mov    %esp,%ebp
40000933:	83 ec 18             	sub    $0x18,%esp
40000936:	8b 45 08             	mov    0x8(%ebp),%eax
	//assert(buf != NULL && n > 0);
	struct sprintbuf b = {buf, buf+n-1, 0};
40000939:	8b 55 0c             	mov    0xc(%ebp),%edx

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000093c:	ff 75 14             	push   0x14(%ebp)
4000093f:	ff 75 10             	push   0x10(%ebp)
	struct sprintbuf b = {buf, buf+n-1, 0};
40000942:	89 45 ec             	mov    %eax,-0x14(%ebp)
40000945:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
40000949:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000094c:	8d 45 ec             	lea    -0x14(%ebp),%eax
4000094f:	50                   	push   %eax
40000950:	68 00 04 00 40       	push   $0x40000400
	struct sprintbuf b = {buf, buf+n-1, 0};
40000955:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000095c:	e8 bf fa ff ff       	call   40000420 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
40000961:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000964:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000967:	8b 45 f4             	mov    -0xc(%ebp),%eax
4000096a:	c9                   	leave
4000096b:	c3                   	ret
4000096c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000970 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
40000970:	55                   	push   %ebp
40000971:	89 e5                	mov    %esp,%ebp
40000973:	83 ec 18             	sub    $0x18,%esp
40000976:	8b 45 08             	mov    0x8(%ebp),%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
40000979:	8b 55 0c             	mov    0xc(%ebp),%edx
4000097c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
40000983:	89 45 ec             	mov    %eax,-0x14(%ebp)
40000986:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
4000098a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000098d:	8d 45 14             	lea    0x14(%ebp),%eax
40000990:	50                   	push   %eax
40000991:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000994:	ff 75 10             	push   0x10(%ebp)
40000997:	50                   	push   %eax
40000998:	68 00 04 00 40       	push   $0x40000400
4000099d:	e8 7e fa ff ff       	call   40000420 <vprintfmt>
	*b.buf = '\0';
400009a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
400009a5:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
	va_end(ap);

	return rc;
}
400009a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
400009ab:	c9                   	leave
400009ac:	c3                   	ret
400009ad:	66 90                	xchg   %ax,%ax
400009af:	90                   	nop

400009b0 <spawn>:
#include <syscall.h>
#include <types.h>

pid_t
spawn(uintptr_t exec, unsigned int quota)
{
400009b0:	55                   	push   %ebp
	asm volatile("int %2"
400009b1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
400009b6:	b8 01 00 00 00       	mov    $0x1,%eax
400009bb:	89 e5                	mov    %esp,%ebp
400009bd:	56                   	push   %esi
400009be:	89 d6                	mov    %edx,%esi
400009c0:	53                   	push   %ebx
400009c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
400009c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
400009c7:	cd 30                	int    $0x30
	return errno ? -1 : pid;
400009c9:	85 c0                	test   %eax,%eax
400009cb:	75 0b                	jne    400009d8 <spawn+0x28>
400009cd:	89 da                	mov    %ebx,%edx
	// Default: inherit console stdin/stdout
	return sys_spawn(exec, quota, -1, -1);
}
400009cf:	5b                   	pop    %ebx
400009d0:	89 d0                	mov    %edx,%eax
400009d2:	5e                   	pop    %esi
400009d3:	5d                   	pop    %ebp
400009d4:	c3                   	ret
400009d5:	8d 76 00             	lea    0x0(%esi),%esi
400009d8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, -1, -1);
400009dd:	eb f0                	jmp    400009cf <spawn+0x1f>
400009df:	90                   	nop

400009e0 <spawn_with_fds>:

pid_t
spawn_with_fds(uintptr_t exec, unsigned int quota, int stdin_fd, int stdout_fd)
{
400009e0:	55                   	push   %ebp
	asm volatile("int %2"
400009e1:	b8 01 00 00 00       	mov    $0x1,%eax
400009e6:	89 e5                	mov    %esp,%ebp
400009e8:	56                   	push   %esi
400009e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
400009ec:	8b 55 10             	mov    0x10(%ebp),%edx
400009ef:	53                   	push   %ebx
400009f0:	8b 75 14             	mov    0x14(%ebp),%esi
400009f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
400009f6:	cd 30                	int    $0x30
	return errno ? -1 : pid;
400009f8:	85 c0                	test   %eax,%eax
400009fa:	75 0c                	jne    40000a08 <spawn_with_fds+0x28>
400009fc:	89 da                	mov    %ebx,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
}
400009fe:	5b                   	pop    %ebx
400009ff:	89 d0                	mov    %edx,%eax
40000a01:	5e                   	pop    %esi
40000a02:	5d                   	pop    %ebp
40000a03:	c3                   	ret
40000a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000a08:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
40000a0d:	eb ef                	jmp    400009fe <spawn_with_fds+0x1e>
40000a0f:	90                   	nop

40000a10 <yield>:
	asm volatile("int %0" :
40000a10:	b8 02 00 00 00       	mov    $0x2,%eax
40000a15:	cd 30                	int    $0x30

void
yield(void)
{
	sys_yield();
}
40000a17:	c3                   	ret
40000a18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a1f:	00 

40000a20 <produce>:
	asm volatile("int %0" :
40000a20:	b8 03 00 00 00       	mov    $0x3,%eax
40000a25:	cd 30                	int    $0x30

void
produce(void)
{
	sys_produce();
}
40000a27:	c3                   	ret
40000a28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a2f:	00 

40000a30 <consume>:
	asm volatile("int %0" :
40000a30:	b8 04 00 00 00       	mov    $0x4,%eax
40000a35:	cd 30                	int    $0x30

void
consume(void)
{
	sys_consume();
}
40000a37:	c3                   	ret
40000a38:	66 90                	xchg   %ax,%ax
40000a3a:	66 90                	xchg   %ax,%ax
40000a3c:	66 90                	xchg   %ax,%ax
40000a3e:	66 90                	xchg   %ax,%ax

40000a40 <spinlock_init>:
	return result;
}

void
spinlock_init(spinlock_t *lk)
{
40000a40:	55                   	push   %ebp
40000a41:	89 e5                	mov    %esp,%ebp
	*lk = 0;
40000a43:	8b 45 08             	mov    0x8(%ebp),%eax
40000a46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
40000a4c:	5d                   	pop    %ebp
40000a4d:	c3                   	ret
40000a4e:	66 90                	xchg   %ax,%ax

40000a50 <spinlock_acquire>:

void
spinlock_acquire(spinlock_t *lk)
{
40000a50:	55                   	push   %ebp
	asm volatile("lock; xchgl %0, %1" :
40000a51:	b8 01 00 00 00       	mov    $0x1,%eax
{
40000a56:	89 e5                	mov    %esp,%ebp
40000a58:	8b 55 08             	mov    0x8(%ebp),%edx
	asm volatile("lock; xchgl %0, %1" :
40000a5b:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000a5e:	85 c0                	test   %eax,%eax
40000a60:	74 1c                	je     40000a7e <spinlock_acquire+0x2e>
40000a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000a68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a6f:	00 
		asm volatile("pause");
40000a70:	f3 90                	pause
	asm volatile("lock; xchgl %0, %1" :
40000a72:	b8 01 00 00 00       	mov    $0x1,%eax
40000a77:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000a7a:	85 c0                	test   %eax,%eax
40000a7c:	75 f2                	jne    40000a70 <spinlock_acquire+0x20>
}
40000a7e:	5d                   	pop    %ebp
40000a7f:	c3                   	ret

40000a80 <spinlock_release>:

// Release the lock.
void
spinlock_release(spinlock_t *lk)
{
40000a80:	55                   	push   %ebp
40000a81:	89 e5                	mov    %esp,%ebp
40000a83:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
bool
spinlock_holding(spinlock_t *lock)
{
	return *lock;
40000a86:	8b 02                	mov    (%edx),%eax
	if (spinlock_holding(lk) == FALSE)
40000a88:	84 c0                	test   %al,%al
40000a8a:	74 05                	je     40000a91 <spinlock_release+0x11>
	asm volatile("lock; xchgl %0, %1" :
40000a8c:	31 c0                	xor    %eax,%eax
40000a8e:	f0 87 02             	lock xchg %eax,(%edx)
}
40000a91:	5d                   	pop    %ebp
40000a92:	c3                   	ret
40000a93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a9f:	00 

40000aa0 <spinlock_holding>:
{
40000aa0:	55                   	push   %ebp
40000aa1:	89 e5                	mov    %esp,%ebp
	return *lock;
40000aa3:	8b 45 08             	mov    0x8(%ebp),%eax
}
40000aa6:	5d                   	pop    %ebp
	return *lock;
40000aa7:	8b 00                	mov    (%eax),%eax
}
40000aa9:	c3                   	ret
40000aaa:	66 90                	xchg   %ax,%ax
40000aac:	66 90                	xchg   %ax,%ax
40000aae:	66 90                	xchg   %ax,%ax
40000ab0:	66 90                	xchg   %ax,%ax
40000ab2:	66 90                	xchg   %ax,%ax
40000ab4:	66 90                	xchg   %ax,%ax
40000ab6:	66 90                	xchg   %ax,%ax
40000ab8:	66 90                	xchg   %ax,%ax
40000aba:	66 90                	xchg   %ax,%ax
40000abc:	66 90                	xchg   %ax,%ax
40000abe:	66 90                	xchg   %ax,%ax

40000ac0 <strlen>:
#include <string.h>
#include <types.h>

int
strlen(const char *s)
{
40000ac0:	55                   	push   %ebp
	int n;

	for (n = 0; *s != '\0'; s++)
40000ac1:	31 c0                	xor    %eax,%eax
{
40000ac3:	89 e5                	mov    %esp,%ebp
40000ac5:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; *s != '\0'; s++)
40000ac8:	80 3a 00             	cmpb   $0x0,(%edx)
40000acb:	74 0c                	je     40000ad9 <strlen+0x19>
40000acd:	8d 76 00             	lea    0x0(%esi),%esi
		n++;
40000ad0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
40000ad3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
40000ad7:	75 f7                	jne    40000ad0 <strlen+0x10>
	return n;
}
40000ad9:	5d                   	pop    %ebp
40000ada:	c3                   	ret
40000adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

40000ae0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
40000ae0:	55                   	push   %ebp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000ae1:	31 c0                	xor    %eax,%eax
{
40000ae3:	89 e5                	mov    %esp,%ebp
40000ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
40000ae8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000aeb:	85 d2                	test   %edx,%edx
40000aed:	75 18                	jne    40000b07 <strnlen+0x27>
40000aef:	eb 1c                	jmp    40000b0d <strnlen+0x2d>
40000af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000af8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000aff:	00 
		n++;
40000b00:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000b03:	39 c2                	cmp    %eax,%edx
40000b05:	74 06                	je     40000b0d <strnlen+0x2d>
40000b07:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
40000b0b:	75 f3                	jne    40000b00 <strnlen+0x20>
	return n;
}
40000b0d:	5d                   	pop    %ebp
40000b0e:	c3                   	ret
40000b0f:	90                   	nop

40000b10 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
40000b10:	55                   	push   %ebp
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
40000b11:	31 c0                	xor    %eax,%eax
{
40000b13:	89 e5                	mov    %esp,%ebp
40000b15:	53                   	push   %ebx
40000b16:	8b 4d 08             	mov    0x8(%ebp),%ecx
40000b19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while ((*dst++ = *src++) != '\0')
40000b20:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000b24:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000b27:	83 c0 01             	add    $0x1,%eax
40000b2a:	84 d2                	test   %dl,%dl
40000b2c:	75 f2                	jne    40000b20 <strcpy+0x10>
		/* do nothing */;
	return ret;
}
40000b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000b31:	89 c8                	mov    %ecx,%eax
40000b33:	c9                   	leave
40000b34:	c3                   	ret
40000b35:	8d 76 00             	lea    0x0(%esi),%esi
40000b38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b3f:	00 

40000b40 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size)
{
40000b40:	55                   	push   %ebp
40000b41:	89 e5                	mov    %esp,%ebp
40000b43:	56                   	push   %esi
40000b44:	8b 55 0c             	mov    0xc(%ebp),%edx
40000b47:	8b 75 08             	mov    0x8(%ebp),%esi
40000b4a:	53                   	push   %ebx
40000b4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
40000b4e:	85 db                	test   %ebx,%ebx
40000b50:	74 21                	je     40000b73 <strncpy+0x33>
40000b52:	01 f3                	add    %esi,%ebx
40000b54:	89 f0                	mov    %esi,%eax
40000b56:	66 90                	xchg   %ax,%ax
40000b58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b5f:	00 
		*dst++ = *src;
40000b60:	0f b6 0a             	movzbl (%edx),%ecx
40000b63:	83 c0 01             	add    $0x1,%eax
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
40000b66:	80 f9 01             	cmp    $0x1,%cl
		*dst++ = *src;
40000b69:	88 48 ff             	mov    %cl,-0x1(%eax)
			src++;
40000b6c:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
40000b6f:	39 c3                	cmp    %eax,%ebx
40000b71:	75 ed                	jne    40000b60 <strncpy+0x20>
	}
	return ret;
}
40000b73:	89 f0                	mov    %esi,%eax
40000b75:	5b                   	pop    %ebx
40000b76:	5e                   	pop    %esi
40000b77:	5d                   	pop    %ebp
40000b78:	c3                   	ret
40000b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000b80 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
40000b80:	55                   	push   %ebp
40000b81:	89 e5                	mov    %esp,%ebp
40000b83:	53                   	push   %ebx
40000b84:	8b 45 10             	mov    0x10(%ebp),%eax
40000b87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
40000b8a:	85 c0                	test   %eax,%eax
40000b8c:	74 2e                	je     40000bbc <strlcpy+0x3c>
		while (--size > 0 && *src != '\0')
40000b8e:	8b 55 08             	mov    0x8(%ebp),%edx
40000b91:	83 e8 01             	sub    $0x1,%eax
40000b94:	74 23                	je     40000bb9 <strlcpy+0x39>
40000b96:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
40000b99:	eb 12                	jmp    40000bad <strlcpy+0x2d>
40000b9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
			*dst++ = *src++;
40000ba0:	83 c2 01             	add    $0x1,%edx
40000ba3:	83 c1 01             	add    $0x1,%ecx
40000ba6:	88 42 ff             	mov    %al,-0x1(%edx)
		while (--size > 0 && *src != '\0')
40000ba9:	39 da                	cmp    %ebx,%edx
40000bab:	74 07                	je     40000bb4 <strlcpy+0x34>
40000bad:	0f b6 01             	movzbl (%ecx),%eax
40000bb0:	84 c0                	test   %al,%al
40000bb2:	75 ec                	jne    40000ba0 <strlcpy+0x20>
		*dst = '\0';
	}
	return dst - dst_in;
40000bb4:	89 d0                	mov    %edx,%eax
40000bb6:	2b 45 08             	sub    0x8(%ebp),%eax
		*dst = '\0';
40000bb9:	c6 02 00             	movb   $0x0,(%edx)
}
40000bbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000bbf:	c9                   	leave
40000bc0:	c3                   	ret
40000bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bcf:	00 

40000bd0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
40000bd0:	55                   	push   %ebp
40000bd1:	89 e5                	mov    %esp,%ebp
40000bd3:	53                   	push   %ebx
40000bd4:	8b 55 08             	mov    0x8(%ebp),%edx
40000bd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
40000bda:	0f b6 02             	movzbl (%edx),%eax
40000bdd:	84 c0                	test   %al,%al
40000bdf:	75 2d                	jne    40000c0e <strcmp+0x3e>
40000be1:	eb 4a                	jmp    40000c2d <strcmp+0x5d>
40000be3:	eb 1b                	jmp    40000c00 <strcmp+0x30>
40000be5:	8d 76 00             	lea    0x0(%esi),%esi
40000be8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bef:	00 
40000bf0:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bf7:	00 
40000bf8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bff:	00 
40000c00:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		p++, q++;
40000c04:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
40000c07:	84 c0                	test   %al,%al
40000c09:	74 15                	je     40000c20 <strcmp+0x50>
40000c0b:	83 c1 01             	add    $0x1,%ecx
40000c0e:	0f b6 19             	movzbl (%ecx),%ebx
40000c11:	38 c3                	cmp    %al,%bl
40000c13:	74 eb                	je     40000c00 <strcmp+0x30>
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c15:	29 d8                	sub    %ebx,%eax
}
40000c17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c1a:	c9                   	leave
40000c1b:	c3                   	ret
40000c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c20:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
40000c24:	31 c0                	xor    %eax,%eax
40000c26:	29 d8                	sub    %ebx,%eax
}
40000c28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c2b:	c9                   	leave
40000c2c:	c3                   	ret
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c2d:	0f b6 19             	movzbl (%ecx),%ebx
40000c30:	31 c0                	xor    %eax,%eax
40000c32:	eb e1                	jmp    40000c15 <strcmp+0x45>
40000c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000c38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c3f:	00 

40000c40 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
40000c40:	55                   	push   %ebp
40000c41:	89 e5                	mov    %esp,%ebp
40000c43:	53                   	push   %ebx
40000c44:	8b 55 10             	mov    0x10(%ebp),%edx
40000c47:	8b 45 08             	mov    0x8(%ebp),%eax
40000c4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
40000c4d:	85 d2                	test   %edx,%edx
40000c4f:	75 16                	jne    40000c67 <strncmp+0x27>
40000c51:	eb 2d                	jmp    40000c80 <strncmp+0x40>
40000c53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c58:	3a 19                	cmp    (%ecx),%bl
40000c5a:	75 12                	jne    40000c6e <strncmp+0x2e>
		n--, p++, q++;
40000c5c:	83 c0 01             	add    $0x1,%eax
40000c5f:	83 c1 01             	add    $0x1,%ecx
	while (n > 0 && *p && *p == *q)
40000c62:	83 ea 01             	sub    $0x1,%edx
40000c65:	74 19                	je     40000c80 <strncmp+0x40>
40000c67:	0f b6 18             	movzbl (%eax),%ebx
40000c6a:	84 db                	test   %bl,%bl
40000c6c:	75 ea                	jne    40000c58 <strncmp+0x18>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000c6e:	0f b6 00             	movzbl (%eax),%eax
40000c71:	0f b6 11             	movzbl (%ecx),%edx
}
40000c74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c77:	c9                   	leave
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000c78:	29 d0                	sub    %edx,%eax
}
40000c7a:	c3                   	ret
40000c7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
		return 0;
40000c83:	31 c0                	xor    %eax,%eax
}
40000c85:	c9                   	leave
40000c86:	c3                   	ret
40000c87:	90                   	nop
40000c88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c8f:	00 

40000c90 <strchr>:

char *
strchr(const char *s, char c)
{
40000c90:	55                   	push   %ebp
40000c91:	89 e5                	mov    %esp,%ebp
40000c93:	8b 45 08             	mov    0x8(%ebp),%eax
40000c96:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
40000c9a:	0f b6 10             	movzbl (%eax),%edx
40000c9d:	84 d2                	test   %dl,%dl
40000c9f:	75 1a                	jne    40000cbb <strchr+0x2b>
40000ca1:	eb 25                	jmp    40000cc8 <strchr+0x38>
40000ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ca8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000caf:	00 
40000cb0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000cb4:	83 c0 01             	add    $0x1,%eax
40000cb7:	84 d2                	test   %dl,%dl
40000cb9:	74 0d                	je     40000cc8 <strchr+0x38>
		if (*s == c)
40000cbb:	38 d1                	cmp    %dl,%cl
40000cbd:	75 f1                	jne    40000cb0 <strchr+0x20>
			return (char *) s;
	return 0;
}
40000cbf:	5d                   	pop    %ebp
40000cc0:	c3                   	ret
40000cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return 0;
40000cc8:	31 c0                	xor    %eax,%eax
}
40000cca:	5d                   	pop    %ebp
40000ccb:	c3                   	ret
40000ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000cd0 <strfind>:

char *
strfind(const char *s, char c)
{
40000cd0:	55                   	push   %ebp
40000cd1:	89 e5                	mov    %esp,%ebp
40000cd3:	8b 45 08             	mov    0x8(%ebp),%eax
40000cd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	for (; *s; s++)
40000cd9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
40000cdc:	38 ca                	cmp    %cl,%dl
40000cde:	75 1b                	jne    40000cfb <strfind+0x2b>
40000ce0:	eb 1d                	jmp    40000cff <strfind+0x2f>
40000ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000ce8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000cef:	00 
	for (; *s; s++)
40000cf0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000cf4:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
40000cf7:	38 ca                	cmp    %cl,%dl
40000cf9:	74 04                	je     40000cff <strfind+0x2f>
40000cfb:	84 d2                	test   %dl,%dl
40000cfd:	75 f1                	jne    40000cf0 <strfind+0x20>
			break;
	return (char *) s;
}
40000cff:	5d                   	pop    %ebp
40000d00:	c3                   	ret
40000d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d0f:	00 

40000d10 <strtol>:


long
strtol(const char *s, char **endptr, int base)
{
40000d10:	55                   	push   %ebp
40000d11:	89 e5                	mov    %esp,%ebp
40000d13:	57                   	push   %edi
40000d14:	8b 55 08             	mov    0x8(%ebp),%edx
40000d17:	56                   	push   %esi
40000d18:	53                   	push   %ebx
40000d19:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
40000d1c:	0f b6 02             	movzbl (%edx),%eax
40000d1f:	3c 09                	cmp    $0x9,%al
40000d21:	74 0d                	je     40000d30 <strtol+0x20>
40000d23:	3c 20                	cmp    $0x20,%al
40000d25:	75 18                	jne    40000d3f <strtol+0x2f>
40000d27:	90                   	nop
40000d28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d2f:	00 
40000d30:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		s++;
40000d34:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
40000d37:	3c 20                	cmp    $0x20,%al
40000d39:	74 f5                	je     40000d30 <strtol+0x20>
40000d3b:	3c 09                	cmp    $0x9,%al
40000d3d:	74 f1                	je     40000d30 <strtol+0x20>

	// plus/minus sign
	if (*s == '+')
40000d3f:	3c 2b                	cmp    $0x2b,%al
40000d41:	0f 84 89 00 00 00    	je     40000dd0 <strtol+0xc0>
		s++;
	else if (*s == '-')
		s++, neg = 1;
40000d47:	3c 2d                	cmp    $0x2d,%al
40000d49:	8d 4a 01             	lea    0x1(%edx),%ecx
40000d4c:	0f 94 c0             	sete   %al
40000d4f:	0f 44 d1             	cmove  %ecx,%edx
40000d52:	0f b6 c0             	movzbl %al,%eax

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000d55:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
40000d5b:	75 10                	jne    40000d6d <strtol+0x5d>
40000d5d:	80 3a 30             	cmpb   $0x30,(%edx)
40000d60:	74 7e                	je     40000de0 <strtol+0xd0>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
40000d62:	83 fb 01             	cmp    $0x1,%ebx
40000d65:	19 db                	sbb    %ebx,%ebx
40000d67:	83 e3 fa             	and    $0xfffffffa,%ebx
40000d6a:	83 c3 10             	add    $0x10,%ebx
40000d6d:	89 5d 10             	mov    %ebx,0x10(%ebp)
40000d70:	31 c9                	xor    %ecx,%ecx
40000d72:	89 c7                	mov    %eax,%edi
40000d74:	eb 13                	jmp    40000d89 <strtol+0x79>
40000d76:	66 90                	xchg   %ax,%ax
40000d78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d7f:	00 
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
		s++, val = (val * base) + dig;
40000d80:	0f af 4d 10          	imul   0x10(%ebp),%ecx
40000d84:	83 c2 01             	add    $0x1,%edx
40000d87:	01 f1                	add    %esi,%ecx
		if (*s >= '0' && *s <= '9')
40000d89:	0f be 1a             	movsbl (%edx),%ebx
40000d8c:	8d 43 d0             	lea    -0x30(%ebx),%eax
			dig = *s - '0';
40000d8f:	8d 73 d0             	lea    -0x30(%ebx),%esi
		if (*s >= '0' && *s <= '9')
40000d92:	3c 09                	cmp    $0x9,%al
40000d94:	76 14                	jbe    40000daa <strtol+0x9a>
		else if (*s >= 'a' && *s <= 'z')
40000d96:	8d 43 9f             	lea    -0x61(%ebx),%eax
			dig = *s - 'a' + 10;
40000d99:	8d 73 a9             	lea    -0x57(%ebx),%esi
		else if (*s >= 'a' && *s <= 'z')
40000d9c:	3c 19                	cmp    $0x19,%al
40000d9e:	76 0a                	jbe    40000daa <strtol+0x9a>
		else if (*s >= 'A' && *s <= 'Z')
40000da0:	8d 43 bf             	lea    -0x41(%ebx),%eax
40000da3:	3c 19                	cmp    $0x19,%al
40000da5:	77 08                	ja     40000daf <strtol+0x9f>
			dig = *s - 'A' + 10;
40000da7:	8d 73 c9             	lea    -0x37(%ebx),%esi
		if (dig >= base)
40000daa:	3b 75 10             	cmp    0x10(%ebp),%esi
40000dad:	7c d1                	jl     40000d80 <strtol+0x70>
		// we don't properly detect overflow!
	}

	if (endptr)
40000daf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000db2:	89 f8                	mov    %edi,%eax
40000db4:	85 db                	test   %ebx,%ebx
40000db6:	74 05                	je     40000dbd <strtol+0xad>
		*endptr = (char *) s;
40000db8:	8b 7d 0c             	mov    0xc(%ebp),%edi
40000dbb:	89 17                	mov    %edx,(%edi)
	return (neg ? -val : val);
40000dbd:	89 ca                	mov    %ecx,%edx
}
40000dbf:	5b                   	pop    %ebx
40000dc0:	5e                   	pop    %esi
	return (neg ? -val : val);
40000dc1:	f7 da                	neg    %edx
40000dc3:	85 c0                	test   %eax,%eax
}
40000dc5:	5f                   	pop    %edi
40000dc6:	5d                   	pop    %ebp
	return (neg ? -val : val);
40000dc7:	0f 45 ca             	cmovne %edx,%ecx
}
40000dca:	89 c8                	mov    %ecx,%eax
40000dcc:	c3                   	ret
40000dcd:	8d 76 00             	lea    0x0(%esi),%esi
		s++;
40000dd0:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
40000dd3:	31 c0                	xor    %eax,%eax
40000dd5:	e9 7b ff ff ff       	jmp    40000d55 <strtol+0x45>
40000dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000de0:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
40000de4:	74 1b                	je     40000e01 <strtol+0xf1>
	else if (base == 0 && s[0] == '0')
40000de6:	85 db                	test   %ebx,%ebx
40000de8:	74 0a                	je     40000df4 <strtol+0xe4>
40000dea:	bb 10 00 00 00       	mov    $0x10,%ebx
40000def:	e9 79 ff ff ff       	jmp    40000d6d <strtol+0x5d>
		s++, base = 8;
40000df4:	83 c2 01             	add    $0x1,%edx
40000df7:	bb 08 00 00 00       	mov    $0x8,%ebx
40000dfc:	e9 6c ff ff ff       	jmp    40000d6d <strtol+0x5d>
		s += 2, base = 16;
40000e01:	83 c2 02             	add    $0x2,%edx
40000e04:	bb 10 00 00 00       	mov    $0x10,%ebx
40000e09:	e9 5f ff ff ff       	jmp    40000d6d <strtol+0x5d>
40000e0e:	66 90                	xchg   %ax,%ax

40000e10 <memset>:

void *
memset(void *v, int c, size_t n)
{
40000e10:	55                   	push   %ebp
40000e11:	89 e5                	mov    %esp,%ebp
40000e13:	57                   	push   %edi
40000e14:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000e17:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000e1a:	85 c9                	test   %ecx,%ecx
40000e1c:	74 1a                	je     40000e38 <memset+0x28>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
40000e1e:	89 d0                	mov    %edx,%eax
40000e20:	09 c8                	or     %ecx,%eax
40000e22:	a8 03                	test   $0x3,%al
40000e24:	75 1a                	jne    40000e40 <memset+0x30>
		c &= 0xFF;
40000e26:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
40000e2a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000e2d:	89 d7                	mov    %edx,%edi
40000e2f:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
40000e35:	fc                   	cld
40000e36:	f3 ab                	rep stos %eax,%es:(%edi)
	} else
		asm volatile("cld; rep stosb\n"
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
}
40000e38:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000e3b:	89 d0                	mov    %edx,%eax
40000e3d:	c9                   	leave
40000e3e:	c3                   	ret
40000e3f:	90                   	nop
		asm volatile("cld; rep stosb\n"
40000e40:	8b 45 0c             	mov    0xc(%ebp),%eax
40000e43:	89 d7                	mov    %edx,%edi
40000e45:	fc                   	cld
40000e46:	f3 aa                	rep stos %al,%es:(%edi)
}
40000e48:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000e4b:	89 d0                	mov    %edx,%eax
40000e4d:	c9                   	leave
40000e4e:	c3                   	ret
40000e4f:	90                   	nop

40000e50 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
40000e50:	55                   	push   %ebp
40000e51:	89 e5                	mov    %esp,%ebp
40000e53:	57                   	push   %edi
40000e54:	8b 45 08             	mov    0x8(%ebp),%eax
40000e57:	8b 55 0c             	mov    0xc(%ebp),%edx
40000e5a:	56                   	push   %esi
40000e5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000e5e:	53                   	push   %ebx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
40000e5f:	39 c2                	cmp    %eax,%edx
40000e61:	73 2d                	jae    40000e90 <memmove+0x40>
40000e63:	8d 1c 0a             	lea    (%edx,%ecx,1),%ebx
40000e66:	39 d8                	cmp    %ebx,%eax
40000e68:	73 26                	jae    40000e90 <memmove+0x40>
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000e6a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
40000e6d:	09 ca                	or     %ecx,%edx
40000e6f:	09 da                	or     %ebx,%edx
40000e71:	83 e2 03             	and    $0x3,%edx
40000e74:	74 4a                	je     40000ec0 <memmove+0x70>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
				     : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
40000e76:	8d 7c 08 ff          	lea    -0x1(%eax,%ecx,1),%edi
40000e7a:	8d 73 ff             	lea    -0x1(%ebx),%esi
40000e7d:	fd                   	std
40000e7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				     :: "D" (d-1), "S" (s-1), "c" (n)
				     : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
40000e80:	fc                   	cld
			asm volatile("cld; rep movsb\n"
				     :: "D" (d), "S" (s), "c" (n)
				     : "cc", "memory");
	}
	return dst;
}
40000e81:	5b                   	pop    %ebx
40000e82:	5e                   	pop    %esi
40000e83:	5f                   	pop    %edi
40000e84:	5d                   	pop    %ebp
40000e85:	c3                   	ret
40000e86:	66 90                	xchg   %ax,%ax
40000e88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e8f:	00 
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000e90:	89 c3                	mov    %eax,%ebx
40000e92:	09 cb                	or     %ecx,%ebx
40000e94:	09 d3                	or     %edx,%ebx
40000e96:	83 e3 03             	and    $0x3,%ebx
40000e99:	74 15                	je     40000eb0 <memmove+0x60>
			asm volatile("cld; rep movsb\n"
40000e9b:	89 c7                	mov    %eax,%edi
40000e9d:	89 d6                	mov    %edx,%esi
40000e9f:	fc                   	cld
40000ea0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000ea2:	5b                   	pop    %ebx
40000ea3:	5e                   	pop    %esi
40000ea4:	5f                   	pop    %edi
40000ea5:	5d                   	pop    %ebp
40000ea6:	c3                   	ret
40000ea7:	90                   	nop
40000ea8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000eaf:	00 
				     :: "D" (d), "S" (s), "c" (n/4)
40000eb0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
40000eb3:	89 c7                	mov    %eax,%edi
40000eb5:	89 d6                	mov    %edx,%esi
40000eb7:	fc                   	cld
40000eb8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000eba:	eb e6                	jmp    40000ea2 <memmove+0x52>
40000ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			asm volatile("std; rep movsl\n"
40000ec0:	8d 7c 08 fc          	lea    -0x4(%eax,%ecx,1),%edi
40000ec4:	8d 73 fc             	lea    -0x4(%ebx),%esi
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
40000ec7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
40000eca:	fd                   	std
40000ecb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000ecd:	eb b1                	jmp    40000e80 <memmove+0x30>
40000ecf:	90                   	nop

40000ed0 <memcpy>:

void *
memcpy(void *dst, const void *src, size_t n)
{
	return memmove(dst, src, n);
40000ed0:	e9 7b ff ff ff       	jmp    40000e50 <memmove>
40000ed5:	8d 76 00             	lea    0x0(%esi),%esi
40000ed8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000edf:	00 

40000ee0 <memcmp>:
}

int
memcmp(const void *v1, const void *v2, size_t n)
{
40000ee0:	55                   	push   %ebp
40000ee1:	89 e5                	mov    %esp,%ebp
40000ee3:	56                   	push   %esi
40000ee4:	8b 75 10             	mov    0x10(%ebp),%esi
40000ee7:	8b 45 08             	mov    0x8(%ebp),%eax
40000eea:	53                   	push   %ebx
40000eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
40000eee:	85 f6                	test   %esi,%esi
40000ef0:	74 2e                	je     40000f20 <memcmp+0x40>
40000ef2:	01 c6                	add    %eax,%esi
40000ef4:	eb 14                	jmp    40000f0a <memcmp+0x2a>
40000ef6:	66 90                	xchg   %ax,%ax
40000ef8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000eff:	00 
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
40000f00:	83 c0 01             	add    $0x1,%eax
40000f03:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
40000f06:	39 f0                	cmp    %esi,%eax
40000f08:	74 16                	je     40000f20 <memcmp+0x40>
		if (*s1 != *s2)
40000f0a:	0f b6 08             	movzbl (%eax),%ecx
40000f0d:	0f b6 1a             	movzbl (%edx),%ebx
40000f10:	38 d9                	cmp    %bl,%cl
40000f12:	74 ec                	je     40000f00 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
40000f14:	0f b6 c1             	movzbl %cl,%eax
40000f17:	29 d8                	sub    %ebx,%eax
	}

	return 0;
}
40000f19:	5b                   	pop    %ebx
40000f1a:	5e                   	pop    %esi
40000f1b:	5d                   	pop    %ebp
40000f1c:	c3                   	ret
40000f1d:	8d 76 00             	lea    0x0(%esi),%esi
40000f20:	5b                   	pop    %ebx
	return 0;
40000f21:	31 c0                	xor    %eax,%eax
}
40000f23:	5e                   	pop    %esi
40000f24:	5d                   	pop    %ebp
40000f25:	c3                   	ret
40000f26:	66 90                	xchg   %ax,%ax
40000f28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f2f:	00 

40000f30 <memchr>:

void *
memchr(const void *s, int c, size_t n)
{
40000f30:	55                   	push   %ebp
40000f31:	89 e5                	mov    %esp,%ebp
40000f33:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
40000f36:	8b 55 10             	mov    0x10(%ebp),%edx
40000f39:	01 c2                	add    %eax,%edx
	for (; s < ends; s++)
40000f3b:	39 d0                	cmp    %edx,%eax
40000f3d:	73 21                	jae    40000f60 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000f3f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
40000f43:	eb 12                	jmp    40000f57 <memchr+0x27>
40000f45:	8d 76 00             	lea    0x0(%esi),%esi
40000f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f4f:	00 
	for (; s < ends; s++)
40000f50:	83 c0 01             	add    $0x1,%eax
40000f53:	39 c2                	cmp    %eax,%edx
40000f55:	74 09                	je     40000f60 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000f57:	38 08                	cmp    %cl,(%eax)
40000f59:	75 f5                	jne    40000f50 <memchr+0x20>
			return (void *) s;
	return NULL;
}
40000f5b:	5d                   	pop    %ebp
40000f5c:	c3                   	ret
40000f5d:	8d 76 00             	lea    0x0(%esi),%esi
	return NULL;
40000f60:	31 c0                	xor    %eax,%eax
}
40000f62:	5d                   	pop    %ebp
40000f63:	c3                   	ret
40000f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000f68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f6f:	00 

40000f70 <memzero>:

void *
memzero(void *v, size_t n)
{
40000f70:	55                   	push   %ebp
40000f71:	89 e5                	mov    %esp,%ebp
40000f73:	57                   	push   %edi
40000f74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000f77:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000f7a:	85 c9                	test   %ecx,%ecx
40000f7c:	74 11                	je     40000f8f <memzero+0x1f>
	if ((int)v%4 == 0 && n%4 == 0) {
40000f7e:	89 d0                	mov    %edx,%eax
40000f80:	09 c8                	or     %ecx,%eax
40000f82:	83 e0 03             	and    $0x3,%eax
40000f85:	75 19                	jne    40000fa0 <memzero+0x30>
			     :: "D" (v), "a" (c), "c" (n/4)
40000f87:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000f8a:	89 d7                	mov    %edx,%edi
40000f8c:	fc                   	cld
40000f8d:	f3 ab                	rep stos %eax,%es:(%edi)
	return memset(v, 0, n);
}
40000f8f:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000f92:	89 d0                	mov    %edx,%eax
40000f94:	c9                   	leave
40000f95:	c3                   	ret
40000f96:	66 90                	xchg   %ax,%ax
40000f98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f9f:	00 
		asm volatile("cld; rep stosb\n"
40000fa0:	89 d7                	mov    %edx,%edi
40000fa2:	31 c0                	xor    %eax,%eax
40000fa4:	fc                   	cld
40000fa5:	f3 aa                	rep stos %al,%es:(%edi)
}
40000fa7:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000faa:	89 d0                	mov    %edx,%eax
40000fac:	c9                   	leave
40000fad:	c3                   	ret
40000fae:	66 90                	xchg   %ax,%ax

40000fb0 <sigaction>:
#include <signal.h>
#include <syscall.h>

int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
40000fb0:	55                   	push   %ebp

static gcc_inline int
sys_sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
	int errno;
	asm volatile ("int %1"
40000fb1:	b8 1a 00 00 00       	mov    $0x1a,%eax
40000fb6:	89 e5                	mov    %esp,%ebp
40000fb8:	53                   	push   %ebx
40000fb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000fbc:	8b 55 10             	mov    0x10(%ebp),%edx
40000fbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000fc2:	cd 30                	int    $0x30
		        "a" (SYS_sigaction),
		        "b" (signum),
		        "c" (act),
		        "d" (oldact)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000fc4:	f7 d8                	neg    %eax
    return sys_sigaction(signum, act, oldact);
}
40000fc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000fc9:	c9                   	leave
40000fca:	19 c0                	sbb    %eax,%eax
40000fcc:	c3                   	ret
40000fcd:	8d 76 00             	lea    0x0(%esi),%esi

40000fd0 <kill>:

int kill(int pid, int signum)
{
40000fd0:	55                   	push   %ebp

static gcc_inline int
sys_kill(int pid, int signum)
{
	int errno;
	asm volatile ("int %1"
40000fd1:	b8 1b 00 00 00       	mov    $0x1b,%eax
40000fd6:	89 e5                	mov    %esp,%ebp
40000fd8:	53                   	push   %ebx
40000fd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000fdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000fdf:	cd 30                	int    $0x30
		      : "i" (T_SYSCALL),
		        "a" (SYS_kill),
		        "b" (pid),
		        "c" (signum)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000fe1:	f7 d8                	neg    %eax
    return sys_kill(pid, signum);
}
40000fe3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000fe6:	c9                   	leave
40000fe7:	19 c0                	sbb    %eax,%eax
40000fe9:	c3                   	ret
40000fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000ff0 <pause>:

static gcc_inline int
sys_pause(void)
{
	int errno;
	asm volatile ("int %1"
40000ff0:	b8 1c 00 00 00       	mov    $0x1c,%eax
40000ff5:	cd 30                	int    $0x30
		      : "=a" (errno)
		      : "i" (T_SYSCALL),
		        "a" (SYS_pause)
		      : "cc", "memory");
	return errno ? -1 : 0;
40000ff7:	f7 d8                	neg    %eax
40000ff9:	19 c0                	sbb    %eax,%eax

int pause(void)
{
    return sys_pause();
}
40000ffb:	c3                   	ret
40000ffc:	66 90                	xchg   %ax,%ax
40000ffe:	66 90                	xchg   %ax,%ax

40001000 <__udivdi3>:
40001000:	55                   	push   %ebp
40001001:	89 e5                	mov    %esp,%ebp
40001003:	57                   	push   %edi
40001004:	56                   	push   %esi
40001005:	53                   	push   %ebx
40001006:	83 ec 1c             	sub    $0x1c,%esp
40001009:	8b 75 08             	mov    0x8(%ebp),%esi
4000100c:	8b 45 14             	mov    0x14(%ebp),%eax
4000100f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40001012:	8b 7d 10             	mov    0x10(%ebp),%edi
40001015:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40001018:	85 c0                	test   %eax,%eax
4000101a:	75 1c                	jne    40001038 <__udivdi3+0x38>
4000101c:	39 fb                	cmp    %edi,%ebx
4000101e:	73 50                	jae    40001070 <__udivdi3+0x70>
40001020:	89 f0                	mov    %esi,%eax
40001022:	31 f6                	xor    %esi,%esi
40001024:	89 da                	mov    %ebx,%edx
40001026:	f7 f7                	div    %edi
40001028:	89 f2                	mov    %esi,%edx
4000102a:	83 c4 1c             	add    $0x1c,%esp
4000102d:	5b                   	pop    %ebx
4000102e:	5e                   	pop    %esi
4000102f:	5f                   	pop    %edi
40001030:	5d                   	pop    %ebp
40001031:	c3                   	ret
40001032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001038:	39 c3                	cmp    %eax,%ebx
4000103a:	73 14                	jae    40001050 <__udivdi3+0x50>
4000103c:	31 f6                	xor    %esi,%esi
4000103e:	31 c0                	xor    %eax,%eax
40001040:	89 f2                	mov    %esi,%edx
40001042:	83 c4 1c             	add    $0x1c,%esp
40001045:	5b                   	pop    %ebx
40001046:	5e                   	pop    %esi
40001047:	5f                   	pop    %edi
40001048:	5d                   	pop    %ebp
40001049:	c3                   	ret
4000104a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001050:	0f bd f0             	bsr    %eax,%esi
40001053:	83 f6 1f             	xor    $0x1f,%esi
40001056:	75 48                	jne    400010a0 <__udivdi3+0xa0>
40001058:	39 d8                	cmp    %ebx,%eax
4000105a:	72 07                	jb     40001063 <__udivdi3+0x63>
4000105c:	31 c0                	xor    %eax,%eax
4000105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
40001061:	72 dd                	jb     40001040 <__udivdi3+0x40>
40001063:	b8 01 00 00 00       	mov    $0x1,%eax
40001068:	eb d6                	jmp    40001040 <__udivdi3+0x40>
4000106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001070:	89 f9                	mov    %edi,%ecx
40001072:	85 ff                	test   %edi,%edi
40001074:	75 0b                	jne    40001081 <__udivdi3+0x81>
40001076:	b8 01 00 00 00       	mov    $0x1,%eax
4000107b:	31 d2                	xor    %edx,%edx
4000107d:	f7 f7                	div    %edi
4000107f:	89 c1                	mov    %eax,%ecx
40001081:	31 d2                	xor    %edx,%edx
40001083:	89 d8                	mov    %ebx,%eax
40001085:	f7 f1                	div    %ecx
40001087:	89 c6                	mov    %eax,%esi
40001089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
4000108c:	f7 f1                	div    %ecx
4000108e:	89 f2                	mov    %esi,%edx
40001090:	83 c4 1c             	add    $0x1c,%esp
40001093:	5b                   	pop    %ebx
40001094:	5e                   	pop    %esi
40001095:	5f                   	pop    %edi
40001096:	5d                   	pop    %ebp
40001097:	c3                   	ret
40001098:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000109f:	00 
400010a0:	89 f1                	mov    %esi,%ecx
400010a2:	ba 20 00 00 00       	mov    $0x20,%edx
400010a7:	29 f2                	sub    %esi,%edx
400010a9:	d3 e0                	shl    %cl,%eax
400010ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
400010ae:	89 d1                	mov    %edx,%ecx
400010b0:	89 f8                	mov    %edi,%eax
400010b2:	d3 e8                	shr    %cl,%eax
400010b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
400010b7:	09 c1                	or     %eax,%ecx
400010b9:	89 d8                	mov    %ebx,%eax
400010bb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
400010be:	89 f1                	mov    %esi,%ecx
400010c0:	d3 e7                	shl    %cl,%edi
400010c2:	89 d1                	mov    %edx,%ecx
400010c4:	d3 e8                	shr    %cl,%eax
400010c6:	89 f1                	mov    %esi,%ecx
400010c8:	89 7d dc             	mov    %edi,-0x24(%ebp)
400010cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
400010ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400010d1:	d3 e3                	shl    %cl,%ebx
400010d3:	89 d1                	mov    %edx,%ecx
400010d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
400010d8:	d3 e8                	shr    %cl,%eax
400010da:	09 d8                	or     %ebx,%eax
400010dc:	f7 75 e0             	divl   -0x20(%ebp)
400010df:	89 d3                	mov    %edx,%ebx
400010e1:	89 c7                	mov    %eax,%edi
400010e3:	f7 65 dc             	mull   -0x24(%ebp)
400010e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
400010e9:	39 d3                	cmp    %edx,%ebx
400010eb:	72 23                	jb     40001110 <__udivdi3+0x110>
400010ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400010f0:	89 f1                	mov    %esi,%ecx
400010f2:	d3 e0                	shl    %cl,%eax
400010f4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
400010f7:	73 04                	jae    400010fd <__udivdi3+0xfd>
400010f9:	39 d3                	cmp    %edx,%ebx
400010fb:	74 13                	je     40001110 <__udivdi3+0x110>
400010fd:	89 f8                	mov    %edi,%eax
400010ff:	31 f6                	xor    %esi,%esi
40001101:	e9 3a ff ff ff       	jmp    40001040 <__udivdi3+0x40>
40001106:	66 90                	xchg   %ax,%ax
40001108:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000110f:	00 
40001110:	8d 47 ff             	lea    -0x1(%edi),%eax
40001113:	31 f6                	xor    %esi,%esi
40001115:	e9 26 ff ff ff       	jmp    40001040 <__udivdi3+0x40>
4000111a:	66 90                	xchg   %ax,%ax
4000111c:	66 90                	xchg   %ax,%ax
4000111e:	66 90                	xchg   %ax,%ax

40001120 <__umoddi3>:
40001120:	55                   	push   %ebp
40001121:	89 e5                	mov    %esp,%ebp
40001123:	57                   	push   %edi
40001124:	56                   	push   %esi
40001125:	53                   	push   %ebx
40001126:	83 ec 2c             	sub    $0x2c,%esp
40001129:	8b 5d 0c             	mov    0xc(%ebp),%ebx
4000112c:	8b 45 14             	mov    0x14(%ebp),%eax
4000112f:	8b 75 08             	mov    0x8(%ebp),%esi
40001132:	8b 7d 10             	mov    0x10(%ebp),%edi
40001135:	89 da                	mov    %ebx,%edx
40001137:	85 c0                	test   %eax,%eax
40001139:	75 15                	jne    40001150 <__umoddi3+0x30>
4000113b:	39 fb                	cmp    %edi,%ebx
4000113d:	73 51                	jae    40001190 <__umoddi3+0x70>
4000113f:	89 f0                	mov    %esi,%eax
40001141:	f7 f7                	div    %edi
40001143:	89 d0                	mov    %edx,%eax
40001145:	31 d2                	xor    %edx,%edx
40001147:	83 c4 2c             	add    $0x2c,%esp
4000114a:	5b                   	pop    %ebx
4000114b:	5e                   	pop    %esi
4000114c:	5f                   	pop    %edi
4000114d:	5d                   	pop    %ebp
4000114e:	c3                   	ret
4000114f:	90                   	nop
40001150:	89 75 e0             	mov    %esi,-0x20(%ebp)
40001153:	39 c3                	cmp    %eax,%ebx
40001155:	73 11                	jae    40001168 <__umoddi3+0x48>
40001157:	89 f0                	mov    %esi,%eax
40001159:	83 c4 2c             	add    $0x2c,%esp
4000115c:	5b                   	pop    %ebx
4000115d:	5e                   	pop    %esi
4000115e:	5f                   	pop    %edi
4000115f:	5d                   	pop    %ebp
40001160:	c3                   	ret
40001161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001168:	0f bd c8             	bsr    %eax,%ecx
4000116b:	83 f1 1f             	xor    $0x1f,%ecx
4000116e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
40001171:	75 3d                	jne    400011b0 <__umoddi3+0x90>
40001173:	39 d8                	cmp    %ebx,%eax
40001175:	0f 82 cd 00 00 00    	jb     40001248 <__umoddi3+0x128>
4000117b:	39 fe                	cmp    %edi,%esi
4000117d:	0f 83 c5 00 00 00    	jae    40001248 <__umoddi3+0x128>
40001183:	8b 45 e0             	mov    -0x20(%ebp),%eax
40001186:	83 c4 2c             	add    $0x2c,%esp
40001189:	5b                   	pop    %ebx
4000118a:	5e                   	pop    %esi
4000118b:	5f                   	pop    %edi
4000118c:	5d                   	pop    %ebp
4000118d:	c3                   	ret
4000118e:	66 90                	xchg   %ax,%ax
40001190:	89 f9                	mov    %edi,%ecx
40001192:	85 ff                	test   %edi,%edi
40001194:	75 0b                	jne    400011a1 <__umoddi3+0x81>
40001196:	b8 01 00 00 00       	mov    $0x1,%eax
4000119b:	31 d2                	xor    %edx,%edx
4000119d:	f7 f7                	div    %edi
4000119f:	89 c1                	mov    %eax,%ecx
400011a1:	89 d8                	mov    %ebx,%eax
400011a3:	31 d2                	xor    %edx,%edx
400011a5:	f7 f1                	div    %ecx
400011a7:	89 f0                	mov    %esi,%eax
400011a9:	f7 f1                	div    %ecx
400011ab:	eb 96                	jmp    40001143 <__umoddi3+0x23>
400011ad:	8d 76 00             	lea    0x0(%esi),%esi
400011b0:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400011b4:	ba 20 00 00 00       	mov    $0x20,%edx
400011b9:	2b 55 e4             	sub    -0x1c(%ebp),%edx
400011bc:	89 55 e0             	mov    %edx,-0x20(%ebp)
400011bf:	d3 e0                	shl    %cl,%eax
400011c1:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
400011c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
400011c8:	89 f8                	mov    %edi,%eax
400011ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
400011cd:	d3 e8                	shr    %cl,%eax
400011cf:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400011d3:	09 c2                	or     %eax,%edx
400011d5:	d3 e7                	shl    %cl,%edi
400011d7:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
400011db:	89 55 dc             	mov    %edx,-0x24(%ebp)
400011de:	89 da                	mov    %ebx,%edx
400011e0:	89 7d d8             	mov    %edi,-0x28(%ebp)
400011e3:	89 f7                	mov    %esi,%edi
400011e5:	d3 ea                	shr    %cl,%edx
400011e7:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400011eb:	d3 e3                	shl    %cl,%ebx
400011ed:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
400011f1:	d3 ef                	shr    %cl,%edi
400011f3:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400011f7:	89 f8                	mov    %edi,%eax
400011f9:	d3 e6                	shl    %cl,%esi
400011fb:	09 d8                	or     %ebx,%eax
400011fd:	f7 75 dc             	divl   -0x24(%ebp)
40001200:	89 d3                	mov    %edx,%ebx
40001202:	89 75 d4             	mov    %esi,-0x2c(%ebp)
40001205:	89 f7                	mov    %esi,%edi
40001207:	f7 65 d8             	mull   -0x28(%ebp)
4000120a:	89 c6                	mov    %eax,%esi
4000120c:	89 d1                	mov    %edx,%ecx
4000120e:	39 d3                	cmp    %edx,%ebx
40001210:	72 06                	jb     40001218 <__umoddi3+0xf8>
40001212:	75 0e                	jne    40001222 <__umoddi3+0x102>
40001214:	39 c7                	cmp    %eax,%edi
40001216:	73 0a                	jae    40001222 <__umoddi3+0x102>
40001218:	2b 45 d8             	sub    -0x28(%ebp),%eax
4000121b:	1b 55 dc             	sbb    -0x24(%ebp),%edx
4000121e:	89 d1                	mov    %edx,%ecx
40001220:	89 c6                	mov    %eax,%esi
40001222:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40001225:	29 f0                	sub    %esi,%eax
40001227:	19 cb                	sbb    %ecx,%ebx
40001229:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
4000122d:	89 da                	mov    %ebx,%edx
4000122f:	d3 e2                	shl    %cl,%edx
40001231:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001235:	d3 e8                	shr    %cl,%eax
40001237:	d3 eb                	shr    %cl,%ebx
40001239:	09 d0                	or     %edx,%eax
4000123b:	89 da                	mov    %ebx,%edx
4000123d:	83 c4 2c             	add    $0x2c,%esp
40001240:	5b                   	pop    %ebx
40001241:	5e                   	pop    %esi
40001242:	5f                   	pop    %edi
40001243:	5d                   	pop    %ebp
40001244:	c3                   	ret
40001245:	8d 76 00             	lea    0x0(%esi),%esi
40001248:	89 da                	mov    %ebx,%edx
4000124a:	29 fe                	sub    %edi,%esi
4000124c:	19 c2                	sbb    %eax,%edx
4000124e:	89 75 e0             	mov    %esi,-0x20(%ebp)
40001251:	e9 2d ff ff ff       	jmp    40001183 <__umoddi3+0x63>
