
obj/user/cat/cat:     file format elf32-i386


Disassembly of section .text:

40000000 <main>:
#include <string.h>

#define BUFSIZE 512

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
40000011:	81 ec 18 02 00 00    	sub    $0x218,%esp
40000017:	8b 01                	mov    (%ecx),%eax
40000019:	8b 71 04             	mov    0x4(%ecx),%esi
sys_read(int fd, char *buf, size_t n)
{
	int errno;
	size_t ret;

	asm volatile("int %2"
4000001c:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
40000022:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)
40000028:	89 b5 e4 fd ff ff    	mov    %esi,-0x21c(%ebp)
    char buf[BUFSIZE];
    int  fd, n, i;

    if (argc <= 1) {
4000002e:	83 f8 01             	cmp    $0x1,%eax
40000031:	7e 77                	jle    400000aa <main+0xaa>
40000033:	bf 01 00 00 00       	mov    $0x1,%edi
40000038:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000003f:	00 
        while ((n = sys_read(0, buf, sizeof(buf))) > 0)
            sys_write(1, buf, n);
    } else {
        /* File arguments: open each one and copy to stdout. */
        for (i = 1; i < argc; i++) {
            fd = sys_open(argv[i], O_RDONLY);
40000040:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
static gcc_inline int
sys_open(char *path, int omode)
{
	int errno;
	int fd;
        unsigned int len = strlen(path);
40000046:	83 ec 0c             	sub    $0xc,%esp
40000049:	8b 1c b8             	mov    (%eax,%edi,4),%ebx
4000004c:	53                   	push   %ebx
4000004d:	e8 ae 0a 00 00       	call   40000b00 <strlen>
	asm volatile("int %2"
40000052:	31 c9                	xor    %ecx,%ecx
        unsigned int len = strlen(path);
40000054:	89 c2                	mov    %eax,%edx
	asm volatile("int %2"
40000056:	b8 05 00 00 00       	mov    $0x5,%eax
4000005b:	cd 30                	int    $0x30
4000005d:	89 de                	mov    %ebx,%esi
            if (fd < 0) {
4000005f:	83 c4 10             	add    $0x10,%esp
40000062:	85 db                	test   %ebx,%ebx
40000064:	0f 88 96 00 00 00    	js     40000100 <main+0x100>
	asm volatile("int %2"
4000006a:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
40000070:	85 c0                	test   %eax,%eax
40000072:	0f 85 88 00 00 00    	jne    40000100 <main+0x100>
40000078:	b8 07 00 00 00       	mov    $0x7,%eax
4000007d:	ba 00 02 00 00       	mov    $0x200,%edx
40000082:	89 f3                	mov    %esi,%ebx
40000084:	cd 30                	int    $0x30
40000086:	89 da                	mov    %ebx,%edx
                printf("CAT: cannot open %s\n", argv[i]);
                continue;
            }
            while ((n = sys_read(fd, buf, sizeof(buf))) > 0)
40000088:	85 db                	test   %ebx,%ebx
4000008a:	7e 54                	jle    400000e0 <main+0xe0>
4000008c:	85 c0                	test   %eax,%eax
4000008e:	75 50                	jne    400000e0 <main+0xe0>
	asm volatile("int %2"
40000090:	b8 08 00 00 00       	mov    $0x8,%eax
40000095:	bb 01 00 00 00       	mov    $0x1,%ebx
4000009a:	cd 30                	int    $0x30
4000009c:	eb da                	jmp    40000078 <main+0x78>
4000009e:	b8 08 00 00 00       	mov    $0x8,%eax
400000a3:	bb 01 00 00 00       	mov    $0x1,%ebx
400000a8:	cd 30                	int    $0x30
	asm volatile("int %2"
400000aa:	b8 07 00 00 00       	mov    $0x7,%eax
400000af:	31 db                	xor    %ebx,%ebx
400000b1:	ba 00 02 00 00       	mov    $0x200,%edx
400000b6:	cd 30                	int    $0x30
	return errno ? -1 : ret;
400000b8:	89 da                	mov    %ebx,%edx
        while ((n = sys_read(0, buf, sizeof(buf))) > 0)
400000ba:	85 db                	test   %ebx,%ebx
400000bc:	7e 04                	jle    400000c2 <main+0xc2>
400000be:	85 c0                	test   %eax,%eax
400000c0:	74 dc                	je     4000009e <main+0x9e>
	asm volatile("int %2"
400000c2:	b8 06 00 00 00       	mov    $0x6,%eax
400000c7:	bb 01 00 00 00       	mov    $0x1,%ebx
400000cc:	cd 30                	int    $0x30
     * CRITICAL: close stdout (the pipe write-end) so the next pipeline
     * stage receives EOF and terminates cleanly.
     */
    sys_close(1);
    return 0;
}
400000ce:	8d 65 f0             	lea    -0x10(%ebp),%esp
400000d1:	31 c0                	xor    %eax,%eax
400000d3:	59                   	pop    %ecx
400000d4:	5b                   	pop    %ebx
400000d5:	5e                   	pop    %esi
400000d6:	5f                   	pop    %edi
400000d7:	5d                   	pop    %ebp
400000d8:	8d 61 fc             	lea    -0x4(%ecx),%esp
400000db:	c3                   	ret
400000dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400000e0:	b8 06 00 00 00       	mov    $0x6,%eax
400000e5:	89 f3                	mov    %esi,%ebx
400000e7:	cd 30                	int    $0x30
        for (i = 1; i < argc; i++) {
400000e9:	83 c7 01             	add    $0x1,%edi
400000ec:	39 bd e0 fd ff ff    	cmp    %edi,-0x220(%ebp)
400000f2:	0f 85 48 ff ff ff    	jne    40000040 <main+0x40>
400000f8:	eb c8                	jmp    400000c2 <main+0xc2>
400000fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                printf("CAT: cannot open %s\n", argv[i]);
40000100:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
40000106:	83 ec 08             	sub    $0x8,%esp
40000109:	ff 34 b8             	push   (%eax,%edi,4)
4000010c:	68 d4 12 00 40       	push   $0x400012d4
40000111:	e8 4a 02 00 00       	call   40000360 <printf>
                continue;
40000116:	83 c4 10             	add    $0x10,%esp
40000119:	eb ce                	jmp    400000e9 <main+0xe9>

4000011b <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary/
	 */
	testl	$0x0fffffff, %esp
4000011b:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
40000121:	75 04                	jne    40000127 <args_exist>

40000123 <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
40000123:	6a 00                	push   $0x0
	pushl	$0
40000125:	6a 00                	push   $0x0

40000127 <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
40000127:	e8 d4 fe ff ff       	call   40000000 <main>

	/* When returning, save return value */
	pushl	%eax
4000012c:	50                   	push   %eax

	/* Syscall SYS_exit (30) */
	movl	$30, %eax
4000012d:	b8 1e 00 00 00       	mov    $0x1e,%eax
	int	$48
40000132:	cd 30                	int    $0x30

40000134 <spin>:

spin:
	call	yield
40000134:	e8 17 09 00 00       	call   40000a50 <yield>
	jmp	spin
40000139:	eb f9                	jmp    40000134 <spin>
4000013b:	66 90                	xchg   %ax,%ax
4000013d:	66 90                	xchg   %ax,%ax
4000013f:	90                   	nop

40000140 <debug>:
#include <stdarg.h>
#include <stdio.h>

void
debug(const char *file, int line, const char *fmt, ...)
{
40000140:	55                   	push   %ebp
40000141:	89 e5                	mov    %esp,%ebp
40000143:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[D] %s:%d: ", file, line);
40000146:	ff 75 0c             	push   0xc(%ebp)
40000149:	ff 75 08             	push   0x8(%ebp)
4000014c:	68 98 12 00 40       	push   $0x40001298
40000151:	e8 0a 02 00 00       	call   40000360 <printf>
	vcprintf(fmt, ap);
40000156:	58                   	pop    %eax
40000157:	8d 45 14             	lea    0x14(%ebp),%eax
4000015a:	5a                   	pop    %edx
4000015b:	50                   	push   %eax
4000015c:	ff 75 10             	push   0x10(%ebp)
4000015f:	e8 9c 01 00 00       	call   40000300 <vcprintf>
	va_end(ap);
}
40000164:	83 c4 10             	add    $0x10,%esp
40000167:	c9                   	leave
40000168:	c3                   	ret
40000169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000170 <warn>:

void
warn(const char *file, int line, const char *fmt, ...)
{
40000170:	55                   	push   %ebp
40000171:	89 e5                	mov    %esp,%ebp
40000173:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[W] %s:%d: ", file, line);
40000176:	ff 75 0c             	push   0xc(%ebp)
40000179:	ff 75 08             	push   0x8(%ebp)
4000017c:	68 a4 12 00 40       	push   $0x400012a4
40000181:	e8 da 01 00 00       	call   40000360 <printf>
	vcprintf(fmt, ap);
40000186:	58                   	pop    %eax
40000187:	8d 45 14             	lea    0x14(%ebp),%eax
4000018a:	5a                   	pop    %edx
4000018b:	50                   	push   %eax
4000018c:	ff 75 10             	push   0x10(%ebp)
4000018f:	e8 6c 01 00 00       	call   40000300 <vcprintf>
	va_end(ap);
}
40000194:	83 c4 10             	add    $0x10,%esp
40000197:	c9                   	leave
40000198:	c3                   	ret
40000199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400001a0 <panic>:

void
panic(const char *file, int line, const char *fmt, ...)
{
400001a0:	55                   	push   %ebp
400001a1:	89 e5                	mov    %esp,%ebp
400001a3:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[P] %s:%d: ", file, line);
400001a6:	ff 75 0c             	push   0xc(%ebp)
400001a9:	ff 75 08             	push   0x8(%ebp)
400001ac:	68 b0 12 00 40       	push   $0x400012b0
400001b1:	e8 aa 01 00 00       	call   40000360 <printf>
	vcprintf(fmt, ap);
400001b6:	58                   	pop    %eax
400001b7:	8d 45 14             	lea    0x14(%ebp),%eax
400001ba:	5a                   	pop    %edx
400001bb:	50                   	push   %eax
400001bc:	ff 75 10             	push   0x10(%ebp)
400001bf:	e8 3c 01 00 00       	call   40000300 <vcprintf>
400001c4:	83 c4 10             	add    $0x10,%esp
400001c7:	90                   	nop
400001c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400001cf:	00 
	va_end(ap);

	while (1)
		yield();
400001d0:	e8 7b 08 00 00       	call   40000a50 <yield>
	while (1)
400001d5:	eb f9                	jmp    400001d0 <panic+0x30>
400001d7:	66 90                	xchg   %ax,%ax
400001d9:	66 90                	xchg   %ax,%ax
400001db:	66 90                	xchg   %ax,%ax
400001dd:	66 90                	xchg   %ax,%ax
400001df:	90                   	nop

400001e0 <atoi>:
#include <stdlib.h>

int
atoi(const char *buf, int *i)
{
400001e0:	55                   	push   %ebp
400001e1:	89 e5                	mov    %esp,%ebp
400001e3:	57                   	push   %edi
400001e4:	56                   	push   %esi
400001e5:	53                   	push   %ebx
400001e6:	83 ec 04             	sub    $0x4,%esp
400001e9:	8b 75 08             	mov    0x8(%ebp),%esi
	int loc = 0;
	int numstart = 0;
	int acc = 0;
	int negative = 0;
	if (buf[loc] == '+')
400001ec:	0f b6 06             	movzbl (%esi),%eax
400001ef:	3c 2b                	cmp    $0x2b,%al
400001f1:	0f 84 89 00 00 00    	je     40000280 <atoi+0xa0>
		loc++;
	else if (buf[loc] == '-') {
400001f7:	3c 2d                	cmp    $0x2d,%al
400001f9:	74 65                	je     40000260 <atoi+0x80>
		negative = 1;
		loc++;
	}
	numstart = loc;
	// no grab the numbers
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400001fb:	8d 50 d0             	lea    -0x30(%eax),%edx
	int negative = 0;
400001fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int loc = 0;
40000205:	31 ff                	xor    %edi,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000207:	80 fa 09             	cmp    $0x9,%dl
4000020a:	0f 87 8c 00 00 00    	ja     4000029c <atoi+0xbc>
	int loc = 0;
40000210:	89 f9                	mov    %edi,%ecx
	int acc = 0;
40000212:	31 d2                	xor    %edx,%edx
40000214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000218:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000021f:	00 
		acc = acc*10 + (buf[loc]-'0');
40000220:	83 e8 30             	sub    $0x30,%eax
40000223:	8d 14 92             	lea    (%edx,%edx,4),%edx
		loc++;
40000226:	83 c1 01             	add    $0x1,%ecx
		acc = acc*10 + (buf[loc]-'0');
40000229:	0f be c0             	movsbl %al,%eax
4000022c:	8d 14 50             	lea    (%eax,%edx,2),%edx
	while ('0' <= buf[loc] && buf[loc] <= '9') {
4000022f:	0f b6 04 0e          	movzbl (%esi,%ecx,1),%eax
40000233:	8d 58 d0             	lea    -0x30(%eax),%ebx
40000236:	80 fb 09             	cmp    $0x9,%bl
40000239:	76 e5                	jbe    40000220 <atoi+0x40>
	}
	if (numstart == loc) {
4000023b:	39 f9                	cmp    %edi,%ecx
4000023d:	74 5d                	je     4000029c <atoi+0xbc>
		// no numbers have actually been scanned
		return 0;
	}
	if (negative)
		acc = - acc;
4000023f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
40000242:	89 d0                	mov    %edx,%eax
40000244:	f7 d8                	neg    %eax
40000246:	85 db                	test   %ebx,%ebx
40000248:	0f 45 d0             	cmovne %eax,%edx
	*i = acc;
4000024b:	8b 45 0c             	mov    0xc(%ebp),%eax
4000024e:	89 10                	mov    %edx,(%eax)
	return loc;
}
40000250:	83 c4 04             	add    $0x4,%esp
40000253:	89 c8                	mov    %ecx,%eax
40000255:	5b                   	pop    %ebx
40000256:	5e                   	pop    %esi
40000257:	5f                   	pop    %edi
40000258:	5d                   	pop    %ebp
40000259:	c3                   	ret
4000025a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000260:	0f b6 46 01          	movzbl 0x1(%esi),%eax
40000264:	8d 50 d0             	lea    -0x30(%eax),%edx
40000267:	80 fa 09             	cmp    $0x9,%dl
4000026a:	77 30                	ja     4000029c <atoi+0xbc>
		negative = 1;
4000026c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		loc++;
40000273:	bf 01 00 00 00       	mov    $0x1,%edi
40000278:	eb 96                	jmp    40000210 <atoi+0x30>
4000027a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000280:	0f b6 46 01          	movzbl 0x1(%esi),%eax
	int negative = 0;
40000284:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		loc++;
4000028b:	bf 01 00 00 00       	mov    $0x1,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000290:	8d 50 d0             	lea    -0x30(%eax),%edx
40000293:	80 fa 09             	cmp    $0x9,%dl
40000296:	0f 86 74 ff ff ff    	jbe    40000210 <atoi+0x30>
}
4000029c:	83 c4 04             	add    $0x4,%esp
		return 0;
4000029f:	31 c9                	xor    %ecx,%ecx
}
400002a1:	5b                   	pop    %ebx
400002a2:	89 c8                	mov    %ecx,%eax
400002a4:	5e                   	pop    %esi
400002a5:	5f                   	pop    %edi
400002a6:	5d                   	pop    %ebp
400002a7:	c3                   	ret
400002a8:	66 90                	xchg   %ax,%ax
400002aa:	66 90                	xchg   %ax,%ax
400002ac:	66 90                	xchg   %ax,%ax
400002ae:	66 90                	xchg   %ax,%ax

400002b0 <putch>:
	char buf[MAX_BUF];
};

static void
putch(int ch, struct printbuf *b)
{
400002b0:	55                   	push   %ebp
400002b1:	89 e5                	mov    %esp,%ebp
400002b3:	56                   	push   %esi
400002b4:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
400002b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
400002ba:	53                   	push   %ebx
	b->buf[b->idx++] = ch;
400002bb:	8b 06                	mov    (%esi),%eax
400002bd:	8d 50 01             	lea    0x1(%eax),%edx
400002c0:	89 16                	mov    %edx,(%esi)
400002c2:	88 4c 06 08          	mov    %cl,0x8(%esi,%eax,1)
	if (b->idx == MAX_BUF-1) {
400002c6:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
400002cc:	75 1c                	jne    400002ea <putch+0x3a>
		b->buf[b->idx] = 0;
400002ce:	c6 86 07 10 00 00 00 	movb   $0x0,0x1007(%esi)
		puts(b->buf, b->idx);
400002d5:	8d 4e 08             	lea    0x8(%esi),%ecx
	asm volatile("int %2"
400002d8:	b8 08 00 00 00       	mov    $0x8,%eax
400002dd:	bb 01 00 00 00       	mov    $0x1,%ebx
400002e2:	cd 30                	int    $0x30
		b->idx = 0;
400002e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	}
	b->cnt++;
400002ea:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
400002ee:	5b                   	pop    %ebx
400002ef:	5e                   	pop    %esi
400002f0:	5d                   	pop    %ebp
400002f1:	c3                   	ret
400002f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400002f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400002ff:	00 

40000300 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
40000300:	55                   	push   %ebp
40000301:	89 e5                	mov    %esp,%ebp
40000303:	53                   	push   %ebx
40000304:	bb 01 00 00 00       	mov    $0x1,%ebx
	struct printbuf b;

	b.idx = 0;
	b.cnt = 0;
	vprintfmt((void*)putch, &b, fmt, ap);
40000309:	8d 85 f0 ef ff ff    	lea    -0x1010(%ebp),%eax
{
4000030f:	81 ec 14 10 00 00    	sub    $0x1014,%esp
	vprintfmt((void*)putch, &b, fmt, ap);
40000315:	ff 75 0c             	push   0xc(%ebp)
40000318:	ff 75 08             	push   0x8(%ebp)
4000031b:	50                   	push   %eax
4000031c:	68 b0 02 00 40       	push   $0x400002b0
	b.idx = 0;
40000321:	c7 85 f0 ef ff ff 00 	movl   $0x0,-0x1010(%ebp)
40000328:	00 00 00 
	b.cnt = 0;
4000032b:	c7 85 f4 ef ff ff 00 	movl   $0x0,-0x100c(%ebp)
40000332:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
40000335:	e8 26 01 00 00       	call   40000460 <vprintfmt>

	b.buf[b.idx] = 0;
4000033a:	8b 95 f0 ef ff ff    	mov    -0x1010(%ebp),%edx
40000340:	8d 8d f8 ef ff ff    	lea    -0x1008(%ebp),%ecx
40000346:	b8 08 00 00 00       	mov    $0x8,%eax
4000034b:	c6 84 15 f8 ef ff ff 	movb   $0x0,-0x1008(%ebp,%edx,1)
40000352:	00 
40000353:	cd 30                	int    $0x30
	puts(b.buf, b.idx);

	return b.cnt;
}
40000355:	8b 85 f4 ef ff ff    	mov    -0x100c(%ebp),%eax
4000035b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
4000035e:	c9                   	leave
4000035f:	c3                   	ret

40000360 <printf>:

int
printf(const char *fmt, ...)
{
40000360:	55                   	push   %ebp
40000361:	89 e5                	mov    %esp,%ebp
40000363:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
40000366:	8d 45 0c             	lea    0xc(%ebp),%eax
40000369:	50                   	push   %eax
4000036a:	ff 75 08             	push   0x8(%ebp)
4000036d:	e8 8e ff ff ff       	call   40000300 <vcprintf>
	va_end(ap);

	return cnt;
}
40000372:	c9                   	leave
40000373:	c3                   	ret
40000374:	66 90                	xchg   %ax,%ax
40000376:	66 90                	xchg   %ax,%ax
40000378:	66 90                	xchg   %ax,%ax
4000037a:	66 90                	xchg   %ax,%ax
4000037c:	66 90                	xchg   %ax,%ax
4000037e:	66 90                	xchg   %ax,%ax

40000380 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
40000380:	55                   	push   %ebp
40000381:	89 e5                	mov    %esp,%ebp
40000383:	57                   	push   %edi
40000384:	89 c7                	mov    %eax,%edi
40000386:	56                   	push   %esi
40000387:	89 d6                	mov    %edx,%esi
40000389:	53                   	push   %ebx
4000038a:	83 ec 2c             	sub    $0x2c,%esp
4000038d:	8b 45 08             	mov    0x8(%ebp),%eax
40000390:	8b 55 0c             	mov    0xc(%ebp),%edx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
40000393:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
{
4000039a:	8b 4d 18             	mov    0x18(%ebp),%ecx
4000039d:	89 45 d8             	mov    %eax,-0x28(%ebp)
400003a0:	8b 45 10             	mov    0x10(%ebp),%eax
400003a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
400003a6:	8b 55 14             	mov    0x14(%ebp),%edx
400003a9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	if (num >= base) {
400003ac:	39 45 d8             	cmp    %eax,-0x28(%ebp)
400003af:	8b 4d dc             	mov    -0x24(%ebp),%ecx
400003b2:	1b 4d d4             	sbb    -0x2c(%ebp),%ecx
400003b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
400003b8:	8d 5a ff             	lea    -0x1(%edx),%ebx
	if (num >= base) {
400003bb:	73 53                	jae    40000410 <printnum+0x90>
		while (--width > 0)
400003bd:	83 fa 01             	cmp    $0x1,%edx
400003c0:	7e 1f                	jle    400003e1 <printnum+0x61>
400003c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400003c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400003cf:	00 
			putch(padc, putdat);
400003d0:	83 ec 08             	sub    $0x8,%esp
400003d3:	56                   	push   %esi
400003d4:	ff 75 e4             	push   -0x1c(%ebp)
400003d7:	ff d7                	call   *%edi
		while (--width > 0)
400003d9:	83 c4 10             	add    $0x10,%esp
400003dc:	83 eb 01             	sub    $0x1,%ebx
400003df:	75 ef                	jne    400003d0 <printnum+0x50>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
400003e1:	89 75 0c             	mov    %esi,0xc(%ebp)
400003e4:	ff 75 d4             	push   -0x2c(%ebp)
400003e7:	ff 75 d0             	push   -0x30(%ebp)
400003ea:	ff 75 dc             	push   -0x24(%ebp)
400003ed:	ff 75 d8             	push   -0x28(%ebp)
400003f0:	e8 6b 0d 00 00       	call   40001160 <__umoddi3>
400003f5:	83 c4 10             	add    $0x10,%esp
400003f8:	0f be 80 bc 12 00 40 	movsbl 0x400012bc(%eax),%eax
400003ff:	89 45 08             	mov    %eax,0x8(%ebp)
}
40000402:	8d 65 f4             	lea    -0xc(%ebp),%esp
	putch("0123456789abcdef"[num % base], putdat);
40000405:	89 f8                	mov    %edi,%eax
}
40000407:	5b                   	pop    %ebx
40000408:	5e                   	pop    %esi
40000409:	5f                   	pop    %edi
4000040a:	5d                   	pop    %ebp
	putch("0123456789abcdef"[num % base], putdat);
4000040b:	ff e0                	jmp    *%eax
4000040d:	8d 76 00             	lea    0x0(%esi),%esi
		printnum(putch, putdat, num / base, base, width - 1, padc);
40000410:	83 ec 0c             	sub    $0xc,%esp
40000413:	ff 75 e4             	push   -0x1c(%ebp)
40000416:	53                   	push   %ebx
40000417:	50                   	push   %eax
40000418:	83 ec 08             	sub    $0x8,%esp
4000041b:	ff 75 d4             	push   -0x2c(%ebp)
4000041e:	ff 75 d0             	push   -0x30(%ebp)
40000421:	ff 75 dc             	push   -0x24(%ebp)
40000424:	ff 75 d8             	push   -0x28(%ebp)
40000427:	e8 14 0c 00 00       	call   40001040 <__udivdi3>
4000042c:	83 c4 18             	add    $0x18,%esp
4000042f:	52                   	push   %edx
40000430:	89 f2                	mov    %esi,%edx
40000432:	50                   	push   %eax
40000433:	89 f8                	mov    %edi,%eax
40000435:	e8 46 ff ff ff       	call   40000380 <printnum>
4000043a:	83 c4 20             	add    $0x20,%esp
4000043d:	eb a2                	jmp    400003e1 <printnum+0x61>
4000043f:	90                   	nop

40000440 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
40000440:	55                   	push   %ebp
40000441:	89 e5                	mov    %esp,%ebp
40000443:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
40000446:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
4000044a:	8b 10                	mov    (%eax),%edx
4000044c:	3b 50 04             	cmp    0x4(%eax),%edx
4000044f:	73 0a                	jae    4000045b <sprintputch+0x1b>
		*b->buf++ = ch;
40000451:	8d 4a 01             	lea    0x1(%edx),%ecx
40000454:	89 08                	mov    %ecx,(%eax)
40000456:	8b 45 08             	mov    0x8(%ebp),%eax
40000459:	88 02                	mov    %al,(%edx)
}
4000045b:	5d                   	pop    %ebp
4000045c:	c3                   	ret
4000045d:	8d 76 00             	lea    0x0(%esi),%esi

40000460 <vprintfmt>:
{
40000460:	55                   	push   %ebp
40000461:	89 e5                	mov    %esp,%ebp
40000463:	57                   	push   %edi
40000464:	56                   	push   %esi
40000465:	53                   	push   %ebx
40000466:	83 ec 2c             	sub    $0x2c,%esp
40000469:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000046c:	8b 75 0c             	mov    0xc(%ebp),%esi
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000046f:	8b 45 10             	mov    0x10(%ebp),%eax
40000472:	8d 78 01             	lea    0x1(%eax),%edi
40000475:	0f b6 00             	movzbl (%eax),%eax
40000478:	83 f8 25             	cmp    $0x25,%eax
4000047b:	75 19                	jne    40000496 <vprintfmt+0x36>
4000047d:	eb 29                	jmp    400004a8 <vprintfmt+0x48>
4000047f:	90                   	nop
			putch(ch, putdat);
40000480:	83 ec 08             	sub    $0x8,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
40000483:	83 c7 01             	add    $0x1,%edi
			putch(ch, putdat);
40000486:	56                   	push   %esi
40000487:	50                   	push   %eax
40000488:	ff d3                	call   *%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000048a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
4000048e:	83 c4 10             	add    $0x10,%esp
40000491:	83 f8 25             	cmp    $0x25,%eax
40000494:	74 12                	je     400004a8 <vprintfmt+0x48>
			if (ch == '\0')
40000496:	85 c0                	test   %eax,%eax
40000498:	75 e6                	jne    40000480 <vprintfmt+0x20>
}
4000049a:	8d 65 f4             	lea    -0xc(%ebp),%esp
4000049d:	5b                   	pop    %ebx
4000049e:	5e                   	pop    %esi
4000049f:	5f                   	pop    %edi
400004a0:	5d                   	pop    %ebp
400004a1:	c3                   	ret
400004a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		padc = ' ';
400004a8:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
		precision = -1;
400004ac:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		altflag = 0;
400004b1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		width = -1;
400004b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		lflag = 0;
400004bf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400004c6:	0f b6 17             	movzbl (%edi),%edx
400004c9:	8d 47 01             	lea    0x1(%edi),%eax
400004cc:	89 45 10             	mov    %eax,0x10(%ebp)
400004cf:	8d 42 dd             	lea    -0x23(%edx),%eax
400004d2:	3c 55                	cmp    $0x55,%al
400004d4:	77 0a                	ja     400004e0 <vprintfmt+0x80>
400004d6:	0f b6 c0             	movzbl %al,%eax
400004d9:	ff 24 85 ec 12 00 40 	jmp    *0x400012ec(,%eax,4)
			putch('%', putdat);
400004e0:	83 ec 08             	sub    $0x8,%esp
400004e3:	56                   	push   %esi
400004e4:	6a 25                	push   $0x25
400004e6:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
400004e8:	83 c4 10             	add    $0x10,%esp
400004eb:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
400004ef:	89 7d 10             	mov    %edi,0x10(%ebp)
400004f2:	0f 84 77 ff ff ff    	je     4000046f <vprintfmt+0xf>
400004f8:	89 f8                	mov    %edi,%eax
400004fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000500:	83 e8 01             	sub    $0x1,%eax
40000503:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
40000507:	75 f7                	jne    40000500 <vprintfmt+0xa0>
40000509:	89 45 10             	mov    %eax,0x10(%ebp)
4000050c:	e9 5e ff ff ff       	jmp    4000046f <vprintfmt+0xf>
40000511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				if (ch < '0' || ch > '9')
40000518:	0f be 47 01          	movsbl 0x1(%edi),%eax
				precision = precision * 10 + ch - '0';
4000051c:	8d 4a d0             	lea    -0x30(%edx),%ecx
		switch (ch = *(unsigned char *) fmt++) {
4000051f:	8b 7d 10             	mov    0x10(%ebp),%edi
				if (ch < '0' || ch > '9')
40000522:	8d 50 d0             	lea    -0x30(%eax),%edx
40000525:	83 fa 09             	cmp    $0x9,%edx
40000528:	77 2b                	ja     40000555 <vprintfmt+0xf5>
4000052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000530:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000537:	00 
40000538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000053f:	00 
				precision = precision * 10 + ch - '0';
40000540:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
			for (precision = 0; ; ++fmt) {
40000543:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
40000546:	8d 4c 50 d0          	lea    -0x30(%eax,%edx,2),%ecx
				ch = *fmt;
4000054a:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
4000054d:	8d 50 d0             	lea    -0x30(%eax),%edx
40000550:	83 fa 09             	cmp    $0x9,%edx
40000553:	76 eb                	jbe    40000540 <vprintfmt+0xe0>
			if (width < 0)
40000555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000558:	85 c0                	test   %eax,%eax
				width = precision, precision = -1;
4000055a:	0f 48 c1             	cmovs  %ecx,%eax
4000055d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
40000560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000565:	0f 48 c8             	cmovs  %eax,%ecx
40000568:	e9 59 ff ff ff       	jmp    400004c6 <vprintfmt+0x66>
			altflag = 1;
4000056d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000574:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000577:	e9 4a ff ff ff       	jmp    400004c6 <vprintfmt+0x66>
			putch(ch, putdat);
4000057c:	83 ec 08             	sub    $0x8,%esp
4000057f:	56                   	push   %esi
40000580:	6a 25                	push   $0x25
40000582:	ff d3                	call   *%ebx
			break;
40000584:	83 c4 10             	add    $0x10,%esp
40000587:	e9 e3 fe ff ff       	jmp    4000046f <vprintfmt+0xf>
			precision = va_arg(ap, int);
4000058c:	8b 45 14             	mov    0x14(%ebp),%eax
		switch (ch = *(unsigned char *) fmt++) {
4000058f:	8b 7d 10             	mov    0x10(%ebp),%edi
			precision = va_arg(ap, int);
40000592:	8b 08                	mov    (%eax),%ecx
40000594:	83 c0 04             	add    $0x4,%eax
40000597:	89 45 14             	mov    %eax,0x14(%ebp)
			goto process_precision;
4000059a:	eb b9                	jmp    40000555 <vprintfmt+0xf5>
			if (width < 0)
4000059c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
4000059f:	31 c0                	xor    %eax,%eax
		switch (ch = *(unsigned char *) fmt++) {
400005a1:	8b 7d 10             	mov    0x10(%ebp),%edi
			if (width < 0)
400005a4:	85 d2                	test   %edx,%edx
400005a6:	0f 49 c2             	cmovns %edx,%eax
400005a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			goto reswitch;
400005ac:	e9 15 ff ff ff       	jmp    400004c6 <vprintfmt+0x66>
			putch(va_arg(ap, int), putdat);
400005b1:	83 ec 08             	sub    $0x8,%esp
400005b4:	56                   	push   %esi
400005b5:	8b 45 14             	mov    0x14(%ebp),%eax
400005b8:	ff 30                	push   (%eax)
400005ba:	ff d3                	call   *%ebx
400005bc:	8b 45 14             	mov    0x14(%ebp),%eax
400005bf:	83 c0 04             	add    $0x4,%eax
			break;
400005c2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
400005c5:	89 45 14             	mov    %eax,0x14(%ebp)
			break;
400005c8:	e9 a2 fe ff ff       	jmp    4000046f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
400005cd:	8b 45 14             	mov    0x14(%ebp),%eax
400005d0:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
400005d2:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
400005d6:	0f 8f af 01 00 00    	jg     4000078b <vprintfmt+0x32b>
		return va_arg(*ap, unsigned long);
400005dc:	83 c0 04             	add    $0x4,%eax
400005df:	31 c9                	xor    %ecx,%ecx
400005e1:	bf 0a 00 00 00       	mov    $0xa,%edi
400005e6:	89 45 14             	mov    %eax,0x14(%ebp)
400005e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			printnum(putch, putdat, num, base, width, padc);
400005f0:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
400005f4:	83 ec 0c             	sub    $0xc,%esp
400005f7:	50                   	push   %eax
400005f8:	89 d8                	mov    %ebx,%eax
400005fa:	ff 75 e4             	push   -0x1c(%ebp)
400005fd:	57                   	push   %edi
400005fe:	51                   	push   %ecx
400005ff:	52                   	push   %edx
40000600:	89 f2                	mov    %esi,%edx
40000602:	e8 79 fd ff ff       	call   40000380 <printnum>
			break;
40000607:	83 c4 20             	add    $0x20,%esp
4000060a:	e9 60 fe ff ff       	jmp    4000046f <vprintfmt+0xf>
			putch('0', putdat);
4000060f:	83 ec 08             	sub    $0x8,%esp
			goto number;
40000612:	bf 10 00 00 00       	mov    $0x10,%edi
			putch('0', putdat);
40000617:	56                   	push   %esi
40000618:	6a 30                	push   $0x30
4000061a:	ff d3                	call   *%ebx
			putch('x', putdat);
4000061c:	58                   	pop    %eax
4000061d:	5a                   	pop    %edx
4000061e:	56                   	push   %esi
4000061f:	6a 78                	push   $0x78
40000621:	ff d3                	call   *%ebx
			num = (unsigned long long)
40000623:	8b 45 14             	mov    0x14(%ebp),%eax
40000626:	31 c9                	xor    %ecx,%ecx
40000628:	8b 10                	mov    (%eax),%edx
				(uintptr_t) va_arg(ap, void *);
4000062a:	83 c0 04             	add    $0x4,%eax
			goto number;
4000062d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
40000630:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;
40000633:	eb bb                	jmp    400005f0 <vprintfmt+0x190>
		return va_arg(*ap, unsigned long long);
40000635:	8b 45 14             	mov    0x14(%ebp),%eax
40000638:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
4000063a:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
4000063e:	0f 8f 5a 01 00 00    	jg     4000079e <vprintfmt+0x33e>
		return va_arg(*ap, unsigned long);
40000644:	83 c0 04             	add    $0x4,%eax
40000647:	31 c9                	xor    %ecx,%ecx
40000649:	bf 10 00 00 00       	mov    $0x10,%edi
4000064e:	89 45 14             	mov    %eax,0x14(%ebp)
40000651:	eb 9d                	jmp    400005f0 <vprintfmt+0x190>
		return va_arg(*ap, long long);
40000653:	8b 45 14             	mov    0x14(%ebp),%eax
	if (lflag >= 2)
40000656:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
4000065a:	0f 8f 51 01 00 00    	jg     400007b1 <vprintfmt+0x351>
		return va_arg(*ap, long);
40000660:	8b 4d 14             	mov    0x14(%ebp),%ecx
40000663:	8b 00                	mov    (%eax),%eax
40000665:	83 c1 04             	add    $0x4,%ecx
40000668:	99                   	cltd
40000669:	89 4d 14             	mov    %ecx,0x14(%ebp)
			if ((long long) num < 0) {
4000066c:	85 d2                	test   %edx,%edx
4000066e:	0f 88 68 01 00 00    	js     400007dc <vprintfmt+0x37c>
			num = getint(&ap, lflag);
40000674:	89 d1                	mov    %edx,%ecx
40000676:	bf 0a 00 00 00       	mov    $0xa,%edi
4000067b:	89 c2                	mov    %eax,%edx
4000067d:	e9 6e ff ff ff       	jmp    400005f0 <vprintfmt+0x190>
			lflag++;
40000682:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000686:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000689:	e9 38 fe ff ff       	jmp    400004c6 <vprintfmt+0x66>
			putch('X', putdat);
4000068e:	83 ec 08             	sub    $0x8,%esp
40000691:	56                   	push   %esi
40000692:	6a 58                	push   $0x58
40000694:	ff d3                	call   *%ebx
			putch('X', putdat);
40000696:	59                   	pop    %ecx
40000697:	5f                   	pop    %edi
40000698:	56                   	push   %esi
40000699:	6a 58                	push   $0x58
4000069b:	ff d3                	call   *%ebx
			putch('X', putdat);
4000069d:	58                   	pop    %eax
4000069e:	5a                   	pop    %edx
4000069f:	56                   	push   %esi
400006a0:	6a 58                	push   $0x58
400006a2:	ff d3                	call   *%ebx
			break;
400006a4:	83 c4 10             	add    $0x10,%esp
400006a7:	e9 c3 fd ff ff       	jmp    4000046f <vprintfmt+0xf>
			if ((p = va_arg(ap, char *)) == NULL)
400006ac:	8b 45 14             	mov    0x14(%ebp),%eax
400006af:	83 c0 04             	add    $0x4,%eax
400006b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
400006b5:	8b 45 14             	mov    0x14(%ebp),%eax
400006b8:	8b 38                	mov    (%eax),%edi
			if (width > 0 && padc != '-')
400006ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400006bd:	85 c0                	test   %eax,%eax
400006bf:	0f 9f c0             	setg   %al
400006c2:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
400006c6:	0f 95 c2             	setne  %dl
400006c9:	21 d0                	and    %edx,%eax
			if ((p = va_arg(ap, char *)) == NULL)
400006cb:	85 ff                	test   %edi,%edi
400006cd:	0f 84 32 01 00 00    	je     40000805 <vprintfmt+0x3a5>
			if (width > 0 && padc != '-')
400006d3:	84 c0                	test   %al,%al
400006d5:	0f 85 4d 01 00 00    	jne    40000828 <vprintfmt+0x3c8>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006db:	0f be 07             	movsbl (%edi),%eax
400006de:	89 c2                	mov    %eax,%edx
400006e0:	85 c0                	test   %eax,%eax
400006e2:	74 7b                	je     4000075f <vprintfmt+0x2ff>
400006e4:	89 5d 08             	mov    %ebx,0x8(%ebp)
400006e7:	83 c7 01             	add    $0x1,%edi
400006ea:	89 cb                	mov    %ecx,%ebx
400006ec:	89 75 0c             	mov    %esi,0xc(%ebp)
400006ef:	8b 75 e4             	mov    -0x1c(%ebp),%esi
400006f2:	eb 21                	jmp    40000715 <vprintfmt+0x2b5>
400006f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					putch(ch, putdat);
400006f8:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006fb:	83 c7 01             	add    $0x1,%edi
					putch(ch, putdat);
400006fe:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000701:	83 ee 01             	sub    $0x1,%esi
					putch(ch, putdat);
40000704:	50                   	push   %eax
40000705:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000708:	0f be 47 ff          	movsbl -0x1(%edi),%eax
4000070c:	83 c4 10             	add    $0x10,%esp
4000070f:	89 c2                	mov    %eax,%edx
40000711:	85 c0                	test   %eax,%eax
40000713:	74 41                	je     40000756 <vprintfmt+0x2f6>
40000715:	85 db                	test   %ebx,%ebx
40000717:	78 05                	js     4000071e <vprintfmt+0x2be>
40000719:	83 eb 01             	sub    $0x1,%ebx
4000071c:	72 38                	jb     40000756 <vprintfmt+0x2f6>
				if (altflag && (ch < ' ' || ch > '~'))
4000071e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
40000721:	85 c9                	test   %ecx,%ecx
40000723:	74 d3                	je     400006f8 <vprintfmt+0x298>
40000725:	0f be ca             	movsbl %dl,%ecx
40000728:	83 e9 20             	sub    $0x20,%ecx
4000072b:	83 f9 5e             	cmp    $0x5e,%ecx
4000072e:	76 c8                	jbe    400006f8 <vprintfmt+0x298>
					putch('?', putdat);
40000730:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000733:	83 c7 01             	add    $0x1,%edi
					putch('?', putdat);
40000736:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000739:	83 ee 01             	sub    $0x1,%esi
					putch('?', putdat);
4000073c:	6a 3f                	push   $0x3f
4000073e:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000741:	0f be 4f ff          	movsbl -0x1(%edi),%ecx
40000745:	83 c4 10             	add    $0x10,%esp
40000748:	89 ca                	mov    %ecx,%edx
4000074a:	89 c8                	mov    %ecx,%eax
4000074c:	85 c9                	test   %ecx,%ecx
4000074e:	74 06                	je     40000756 <vprintfmt+0x2f6>
40000750:	85 db                	test   %ebx,%ebx
40000752:	79 c5                	jns    40000719 <vprintfmt+0x2b9>
40000754:	eb d2                	jmp    40000728 <vprintfmt+0x2c8>
40000756:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40000759:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000075c:	8b 75 0c             	mov    0xc(%ebp),%esi
			for (; width > 0; width--)
4000075f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000762:	85 c0                	test   %eax,%eax
40000764:	7e 1a                	jle    40000780 <vprintfmt+0x320>
40000766:	89 c7                	mov    %eax,%edi
40000768:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000076f:	00 
				putch(' ', putdat);
40000770:	83 ec 08             	sub    $0x8,%esp
40000773:	56                   	push   %esi
40000774:	6a 20                	push   $0x20
40000776:	ff d3                	call   *%ebx
			for (; width > 0; width--)
40000778:	83 c4 10             	add    $0x10,%esp
4000077b:	83 ef 01             	sub    $0x1,%edi
4000077e:	75 f0                	jne    40000770 <vprintfmt+0x310>
			if ((p = va_arg(ap, char *)) == NULL)
40000780:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40000783:	89 45 14             	mov    %eax,0x14(%ebp)
40000786:	e9 e4 fc ff ff       	jmp    4000046f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
4000078b:	8b 48 04             	mov    0x4(%eax),%ecx
4000078e:	83 c0 08             	add    $0x8,%eax
40000791:	bf 0a 00 00 00       	mov    $0xa,%edi
40000796:	89 45 14             	mov    %eax,0x14(%ebp)
40000799:	e9 52 fe ff ff       	jmp    400005f0 <vprintfmt+0x190>
4000079e:	8b 48 04             	mov    0x4(%eax),%ecx
400007a1:	83 c0 08             	add    $0x8,%eax
400007a4:	bf 10 00 00 00       	mov    $0x10,%edi
400007a9:	89 45 14             	mov    %eax,0x14(%ebp)
400007ac:	e9 3f fe ff ff       	jmp    400005f0 <vprintfmt+0x190>
		return va_arg(*ap, long long);
400007b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
400007b4:	8b 50 04             	mov    0x4(%eax),%edx
400007b7:	8b 00                	mov    (%eax),%eax
400007b9:	83 c1 08             	add    $0x8,%ecx
400007bc:	89 4d 14             	mov    %ecx,0x14(%ebp)
400007bf:	e9 a8 fe ff ff       	jmp    4000066c <vprintfmt+0x20c>
		switch (ch = *(unsigned char *) fmt++) {
400007c4:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
400007c8:	8b 7d 10             	mov    0x10(%ebp),%edi
400007cb:	e9 f6 fc ff ff       	jmp    400004c6 <vprintfmt+0x66>
			padc = '-';
400007d0:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400007d4:	8b 7d 10             	mov    0x10(%ebp),%edi
400007d7:	e9 ea fc ff ff       	jmp    400004c6 <vprintfmt+0x66>
				putch('-', putdat);
400007dc:	83 ec 08             	sub    $0x8,%esp
400007df:	89 45 d8             	mov    %eax,-0x28(%ebp)
				num = -(long long) num;
400007e2:	bf 0a 00 00 00       	mov    $0xa,%edi
400007e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch('-', putdat);
400007ea:	56                   	push   %esi
400007eb:	6a 2d                	push   $0x2d
400007ed:	ff d3                	call   *%ebx
				num = -(long long) num;
400007ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
400007f2:	31 d2                	xor    %edx,%edx
400007f4:	f7 d8                	neg    %eax
400007f6:	1b 55 dc             	sbb    -0x24(%ebp),%edx
400007f9:	83 c4 10             	add    $0x10,%esp
400007fc:	89 d1                	mov    %edx,%ecx
400007fe:	89 c2                	mov    %eax,%edx
40000800:	e9 eb fd ff ff       	jmp    400005f0 <vprintfmt+0x190>
			if (width > 0 && padc != '-')
40000805:	84 c0                	test   %al,%al
40000807:	75 78                	jne    40000881 <vprintfmt+0x421>
40000809:	89 5d 08             	mov    %ebx,0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000080c:	bf ce 12 00 40       	mov    $0x400012ce,%edi
40000811:	ba 28 00 00 00       	mov    $0x28,%edx
40000816:	89 cb                	mov    %ecx,%ebx
40000818:	89 75 0c             	mov    %esi,0xc(%ebp)
4000081b:	b8 28 00 00 00       	mov    $0x28,%eax
40000820:	8b 75 e4             	mov    -0x1c(%ebp),%esi
40000823:	e9 ed fe ff ff       	jmp    40000715 <vprintfmt+0x2b5>
				for (width -= strnlen(p, precision); width > 0; width--)
40000828:	83 ec 08             	sub    $0x8,%esp
4000082b:	51                   	push   %ecx
4000082c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
4000082f:	57                   	push   %edi
40000830:	e8 eb 02 00 00       	call   40000b20 <strnlen>
40000835:	29 45 e4             	sub    %eax,-0x1c(%ebp)
40000838:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
4000083b:	83 c4 10             	add    $0x10,%esp
4000083e:	85 c9                	test   %ecx,%ecx
40000840:	8b 4d d0             	mov    -0x30(%ebp),%ecx
40000843:	7e 71                	jle    400008b6 <vprintfmt+0x456>
					putch(padc, putdat);
40000845:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
40000849:	89 4d cc             	mov    %ecx,-0x34(%ebp)
4000084c:	89 7d d0             	mov    %edi,-0x30(%ebp)
4000084f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
40000852:	89 45 e0             	mov    %eax,-0x20(%ebp)
40000855:	83 ec 08             	sub    $0x8,%esp
40000858:	56                   	push   %esi
40000859:	ff 75 e0             	push   -0x20(%ebp)
4000085c:	ff d3                	call   *%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
4000085e:	83 c4 10             	add    $0x10,%esp
40000861:	83 ef 01             	sub    $0x1,%edi
40000864:	75 ef                	jne    40000855 <vprintfmt+0x3f5>
40000866:	89 7d e4             	mov    %edi,-0x1c(%ebp)
40000869:	8b 7d d0             	mov    -0x30(%ebp),%edi
4000086c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000086f:	0f be 07             	movsbl (%edi),%eax
40000872:	89 c2                	mov    %eax,%edx
40000874:	85 c0                	test   %eax,%eax
40000876:	0f 85 68 fe ff ff    	jne    400006e4 <vprintfmt+0x284>
4000087c:	e9 ff fe ff ff       	jmp    40000780 <vprintfmt+0x320>
				for (width -= strnlen(p, precision); width > 0; width--)
40000881:	83 ec 08             	sub    $0x8,%esp
				p = "(null)";
40000884:	bf cd 12 00 40       	mov    $0x400012cd,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
40000889:	51                   	push   %ecx
4000088a:	89 4d d0             	mov    %ecx,-0x30(%ebp)
4000088d:	68 cd 12 00 40       	push   $0x400012cd
40000892:	e8 89 02 00 00       	call   40000b20 <strnlen>
40000897:	29 45 e4             	sub    %eax,-0x1c(%ebp)
4000089a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
4000089d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400008a0:	ba 28 00 00 00       	mov    $0x28,%edx
400008a5:	b8 28 00 00 00       	mov    $0x28,%eax
				for (width -= strnlen(p, precision); width > 0; width--)
400008aa:	85 c9                	test   %ecx,%ecx
400008ac:	8b 4d d0             	mov    -0x30(%ebp),%ecx
400008af:	7f 94                	jg     40000845 <vprintfmt+0x3e5>
400008b1:	e9 2e fe ff ff       	jmp    400006e4 <vprintfmt+0x284>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400008b6:	0f be 07             	movsbl (%edi),%eax
400008b9:	89 c2                	mov    %eax,%edx
400008bb:	85 c0                	test   %eax,%eax
400008bd:	0f 85 21 fe ff ff    	jne    400006e4 <vprintfmt+0x284>
400008c3:	e9 b8 fe ff ff       	jmp    40000780 <vprintfmt+0x320>
400008c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400008cf:	00 

400008d0 <printfmt>:
{
400008d0:	55                   	push   %ebp
400008d1:	89 e5                	mov    %esp,%ebp
400008d3:	83 ec 08             	sub    $0x8,%esp
	vprintfmt(putch, putdat, fmt, ap);
400008d6:	8d 45 14             	lea    0x14(%ebp),%eax
400008d9:	50                   	push   %eax
400008da:	ff 75 10             	push   0x10(%ebp)
400008dd:	ff 75 0c             	push   0xc(%ebp)
400008e0:	ff 75 08             	push   0x8(%ebp)
400008e3:	e8 78 fb ff ff       	call   40000460 <vprintfmt>
}
400008e8:	83 c4 10             	add    $0x10,%esp
400008eb:	c9                   	leave
400008ec:	c3                   	ret
400008ed:	8d 76 00             	lea    0x0(%esi),%esi

400008f0 <vsprintf>:

int
vsprintf(char *buf, const char *fmt, va_list ap)
{
400008f0:	55                   	push   %ebp
400008f1:	89 e5                	mov    %esp,%ebp
400008f3:	83 ec 18             	sub    $0x18,%esp
	//assert(buf != NULL);
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400008f6:	8b 45 08             	mov    0x8(%ebp),%eax

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400008f9:	ff 75 10             	push   0x10(%ebp)
400008fc:	ff 75 0c             	push   0xc(%ebp)
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400008ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000902:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000905:	50                   	push   %eax
40000906:	68 40 04 00 40       	push   $0x40000440
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
4000090b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
40000912:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000919:	e8 42 fb ff ff       	call   40000460 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
4000091e:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000921:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000924:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000927:	c9                   	leave
40000928:	c3                   	ret
40000929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000930 <sprintf>:

int
sprintf(char *buf, const char *fmt, ...)
{
40000930:	55                   	push   %ebp
40000931:	89 e5                	mov    %esp,%ebp
40000933:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
40000936:	8b 45 08             	mov    0x8(%ebp),%eax
40000939:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
40000940:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
40000947:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000094a:	8d 45 10             	lea    0x10(%ebp),%eax
4000094d:	50                   	push   %eax
4000094e:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000951:	ff 75 0c             	push   0xc(%ebp)
40000954:	50                   	push   %eax
40000955:	68 40 04 00 40       	push   $0x40000440
4000095a:	e8 01 fb ff ff       	call   40000460 <vprintfmt>
	*b.buf = '\0';
4000095f:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000962:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsprintf(buf, fmt, ap);
	va_end(ap);

	return rc;
}
40000965:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000968:	c9                   	leave
40000969:	c3                   	ret
4000096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000970 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
40000970:	55                   	push   %ebp
40000971:	89 e5                	mov    %esp,%ebp
40000973:	83 ec 18             	sub    $0x18,%esp
40000976:	8b 45 08             	mov    0x8(%ebp),%eax
	//assert(buf != NULL && n > 0);
	struct sprintbuf b = {buf, buf+n-1, 0};
40000979:	8b 55 0c             	mov    0xc(%ebp),%edx

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000097c:	ff 75 14             	push   0x14(%ebp)
4000097f:	ff 75 10             	push   0x10(%ebp)
	struct sprintbuf b = {buf, buf+n-1, 0};
40000982:	89 45 ec             	mov    %eax,-0x14(%ebp)
40000985:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
40000989:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000098c:	8d 45 ec             	lea    -0x14(%ebp),%eax
4000098f:	50                   	push   %eax
40000990:	68 40 04 00 40       	push   $0x40000440
	struct sprintbuf b = {buf, buf+n-1, 0};
40000995:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000099c:	e8 bf fa ff ff       	call   40000460 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
400009a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
400009a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
400009a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
400009aa:	c9                   	leave
400009ab:	c3                   	ret
400009ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

400009b0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
400009b0:	55                   	push   %ebp
400009b1:	89 e5                	mov    %esp,%ebp
400009b3:	83 ec 18             	sub    $0x18,%esp
400009b6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
400009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
400009bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
400009c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
400009c6:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
400009ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400009cd:	8d 45 14             	lea    0x14(%ebp),%eax
400009d0:	50                   	push   %eax
400009d1:	8d 45 ec             	lea    -0x14(%ebp),%eax
400009d4:	ff 75 10             	push   0x10(%ebp)
400009d7:	50                   	push   %eax
400009d8:	68 40 04 00 40       	push   $0x40000440
400009dd:	e8 7e fa ff ff       	call   40000460 <vprintfmt>
	*b.buf = '\0';
400009e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
400009e5:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
	va_end(ap);

	return rc;
}
400009e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
400009eb:	c9                   	leave
400009ec:	c3                   	ret
400009ed:	66 90                	xchg   %ax,%ax
400009ef:	90                   	nop

400009f0 <spawn>:
#include <syscall.h>
#include <types.h>

pid_t
spawn(uintptr_t exec, unsigned int quota)
{
400009f0:	55                   	push   %ebp
	asm volatile("int %2"
400009f1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
400009f6:	b8 01 00 00 00       	mov    $0x1,%eax
400009fb:	89 e5                	mov    %esp,%ebp
400009fd:	56                   	push   %esi
400009fe:	89 d6                	mov    %edx,%esi
40000a00:	53                   	push   %ebx
40000a01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000a04:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000a07:	cd 30                	int    $0x30
	return errno ? -1 : pid;
40000a09:	85 c0                	test   %eax,%eax
40000a0b:	75 0b                	jne    40000a18 <spawn+0x28>
40000a0d:	89 da                	mov    %ebx,%edx
	// Default: inherit console stdin/stdout
	return sys_spawn(exec, quota, -1, -1);
}
40000a0f:	5b                   	pop    %ebx
40000a10:	89 d0                	mov    %edx,%eax
40000a12:	5e                   	pop    %esi
40000a13:	5d                   	pop    %ebp
40000a14:	c3                   	ret
40000a15:	8d 76 00             	lea    0x0(%esi),%esi
40000a18:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, -1, -1);
40000a1d:	eb f0                	jmp    40000a0f <spawn+0x1f>
40000a1f:	90                   	nop

40000a20 <spawn_with_fds>:

pid_t
spawn_with_fds(uintptr_t exec, unsigned int quota, int stdin_fd, int stdout_fd)
{
40000a20:	55                   	push   %ebp
	asm volatile("int %2"
40000a21:	b8 01 00 00 00       	mov    $0x1,%eax
40000a26:	89 e5                	mov    %esp,%ebp
40000a28:	56                   	push   %esi
40000a29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000a2c:	8b 55 10             	mov    0x10(%ebp),%edx
40000a2f:	53                   	push   %ebx
40000a30:	8b 75 14             	mov    0x14(%ebp),%esi
40000a33:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000a36:	cd 30                	int    $0x30
	return errno ? -1 : pid;
40000a38:	85 c0                	test   %eax,%eax
40000a3a:	75 0c                	jne    40000a48 <spawn_with_fds+0x28>
40000a3c:	89 da                	mov    %ebx,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
}
40000a3e:	5b                   	pop    %ebx
40000a3f:	89 d0                	mov    %edx,%eax
40000a41:	5e                   	pop    %esi
40000a42:	5d                   	pop    %ebp
40000a43:	c3                   	ret
40000a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000a48:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
40000a4d:	eb ef                	jmp    40000a3e <spawn_with_fds+0x1e>
40000a4f:	90                   	nop

40000a50 <yield>:
	asm volatile("int %0" :
40000a50:	b8 02 00 00 00       	mov    $0x2,%eax
40000a55:	cd 30                	int    $0x30

void
yield(void)
{
	sys_yield();
}
40000a57:	c3                   	ret
40000a58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a5f:	00 

40000a60 <produce>:
	asm volatile("int %0" :
40000a60:	b8 03 00 00 00       	mov    $0x3,%eax
40000a65:	cd 30                	int    $0x30

void
produce(void)
{
	sys_produce();
}
40000a67:	c3                   	ret
40000a68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a6f:	00 

40000a70 <consume>:
	asm volatile("int %0" :
40000a70:	b8 04 00 00 00       	mov    $0x4,%eax
40000a75:	cd 30                	int    $0x30

void
consume(void)
{
	sys_consume();
}
40000a77:	c3                   	ret
40000a78:	66 90                	xchg   %ax,%ax
40000a7a:	66 90                	xchg   %ax,%ax
40000a7c:	66 90                	xchg   %ax,%ax
40000a7e:	66 90                	xchg   %ax,%ax

40000a80 <spinlock_init>:
	return result;
}

void
spinlock_init(spinlock_t *lk)
{
40000a80:	55                   	push   %ebp
40000a81:	89 e5                	mov    %esp,%ebp
	*lk = 0;
40000a83:	8b 45 08             	mov    0x8(%ebp),%eax
40000a86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
40000a8c:	5d                   	pop    %ebp
40000a8d:	c3                   	ret
40000a8e:	66 90                	xchg   %ax,%ax

40000a90 <spinlock_acquire>:

void
spinlock_acquire(spinlock_t *lk)
{
40000a90:	55                   	push   %ebp
	asm volatile("lock; xchgl %0, %1" :
40000a91:	b8 01 00 00 00       	mov    $0x1,%eax
{
40000a96:	89 e5                	mov    %esp,%ebp
40000a98:	8b 55 08             	mov    0x8(%ebp),%edx
	asm volatile("lock; xchgl %0, %1" :
40000a9b:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000a9e:	85 c0                	test   %eax,%eax
40000aa0:	74 1c                	je     40000abe <spinlock_acquire+0x2e>
40000aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000aa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000aaf:	00 
		asm volatile("pause");
40000ab0:	f3 90                	pause
	asm volatile("lock; xchgl %0, %1" :
40000ab2:	b8 01 00 00 00       	mov    $0x1,%eax
40000ab7:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000aba:	85 c0                	test   %eax,%eax
40000abc:	75 f2                	jne    40000ab0 <spinlock_acquire+0x20>
}
40000abe:	5d                   	pop    %ebp
40000abf:	c3                   	ret

40000ac0 <spinlock_release>:

// Release the lock.
void
spinlock_release(spinlock_t *lk)
{
40000ac0:	55                   	push   %ebp
40000ac1:	89 e5                	mov    %esp,%ebp
40000ac3:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
bool
spinlock_holding(spinlock_t *lock)
{
	return *lock;
40000ac6:	8b 02                	mov    (%edx),%eax
	if (spinlock_holding(lk) == FALSE)
40000ac8:	84 c0                	test   %al,%al
40000aca:	74 05                	je     40000ad1 <spinlock_release+0x11>
	asm volatile("lock; xchgl %0, %1" :
40000acc:	31 c0                	xor    %eax,%eax
40000ace:	f0 87 02             	lock xchg %eax,(%edx)
}
40000ad1:	5d                   	pop    %ebp
40000ad2:	c3                   	ret
40000ad3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ad8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000adf:	00 

40000ae0 <spinlock_holding>:
{
40000ae0:	55                   	push   %ebp
40000ae1:	89 e5                	mov    %esp,%ebp
	return *lock;
40000ae3:	8b 45 08             	mov    0x8(%ebp),%eax
}
40000ae6:	5d                   	pop    %ebp
	return *lock;
40000ae7:	8b 00                	mov    (%eax),%eax
}
40000ae9:	c3                   	ret
40000aea:	66 90                	xchg   %ax,%ax
40000aec:	66 90                	xchg   %ax,%ax
40000aee:	66 90                	xchg   %ax,%ax
40000af0:	66 90                	xchg   %ax,%ax
40000af2:	66 90                	xchg   %ax,%ax
40000af4:	66 90                	xchg   %ax,%ax
40000af6:	66 90                	xchg   %ax,%ax
40000af8:	66 90                	xchg   %ax,%ax
40000afa:	66 90                	xchg   %ax,%ax
40000afc:	66 90                	xchg   %ax,%ax
40000afe:	66 90                	xchg   %ax,%ax

40000b00 <strlen>:
#include <string.h>
#include <types.h>

int
strlen(const char *s)
{
40000b00:	55                   	push   %ebp
	int n;

	for (n = 0; *s != '\0'; s++)
40000b01:	31 c0                	xor    %eax,%eax
{
40000b03:	89 e5                	mov    %esp,%ebp
40000b05:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; *s != '\0'; s++)
40000b08:	80 3a 00             	cmpb   $0x0,(%edx)
40000b0b:	74 0c                	je     40000b19 <strlen+0x19>
40000b0d:	8d 76 00             	lea    0x0(%esi),%esi
		n++;
40000b10:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
40000b13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
40000b17:	75 f7                	jne    40000b10 <strlen+0x10>
	return n;
}
40000b19:	5d                   	pop    %ebp
40000b1a:	c3                   	ret
40000b1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

40000b20 <strnlen>:

int
strnlen(const char *s, size_t size)
{
40000b20:	55                   	push   %ebp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000b21:	31 c0                	xor    %eax,%eax
{
40000b23:	89 e5                	mov    %esp,%ebp
40000b25:	8b 55 0c             	mov    0xc(%ebp),%edx
40000b28:	8b 4d 08             	mov    0x8(%ebp),%ecx
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000b2b:	85 d2                	test   %edx,%edx
40000b2d:	75 18                	jne    40000b47 <strnlen+0x27>
40000b2f:	eb 1c                	jmp    40000b4d <strnlen+0x2d>
40000b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b3f:	00 
		n++;
40000b40:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000b43:	39 c2                	cmp    %eax,%edx
40000b45:	74 06                	je     40000b4d <strnlen+0x2d>
40000b47:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
40000b4b:	75 f3                	jne    40000b40 <strnlen+0x20>
	return n;
}
40000b4d:	5d                   	pop    %ebp
40000b4e:	c3                   	ret
40000b4f:	90                   	nop

40000b50 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
40000b50:	55                   	push   %ebp
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
40000b51:	31 c0                	xor    %eax,%eax
{
40000b53:	89 e5                	mov    %esp,%ebp
40000b55:	53                   	push   %ebx
40000b56:	8b 4d 08             	mov    0x8(%ebp),%ecx
40000b59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while ((*dst++ = *src++) != '\0')
40000b60:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000b64:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000b67:	83 c0 01             	add    $0x1,%eax
40000b6a:	84 d2                	test   %dl,%dl
40000b6c:	75 f2                	jne    40000b60 <strcpy+0x10>
		/* do nothing */;
	return ret;
}
40000b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000b71:	89 c8                	mov    %ecx,%eax
40000b73:	c9                   	leave
40000b74:	c3                   	ret
40000b75:	8d 76 00             	lea    0x0(%esi),%esi
40000b78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b7f:	00 

40000b80 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size)
{
40000b80:	55                   	push   %ebp
40000b81:	89 e5                	mov    %esp,%ebp
40000b83:	56                   	push   %esi
40000b84:	8b 55 0c             	mov    0xc(%ebp),%edx
40000b87:	8b 75 08             	mov    0x8(%ebp),%esi
40000b8a:	53                   	push   %ebx
40000b8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
40000b8e:	85 db                	test   %ebx,%ebx
40000b90:	74 21                	je     40000bb3 <strncpy+0x33>
40000b92:	01 f3                	add    %esi,%ebx
40000b94:	89 f0                	mov    %esi,%eax
40000b96:	66 90                	xchg   %ax,%ax
40000b98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b9f:	00 
		*dst++ = *src;
40000ba0:	0f b6 0a             	movzbl (%edx),%ecx
40000ba3:	83 c0 01             	add    $0x1,%eax
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
40000ba6:	80 f9 01             	cmp    $0x1,%cl
		*dst++ = *src;
40000ba9:	88 48 ff             	mov    %cl,-0x1(%eax)
			src++;
40000bac:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
40000baf:	39 c3                	cmp    %eax,%ebx
40000bb1:	75 ed                	jne    40000ba0 <strncpy+0x20>
	}
	return ret;
}
40000bb3:	89 f0                	mov    %esi,%eax
40000bb5:	5b                   	pop    %ebx
40000bb6:	5e                   	pop    %esi
40000bb7:	5d                   	pop    %ebp
40000bb8:	c3                   	ret
40000bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000bc0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
40000bc0:	55                   	push   %ebp
40000bc1:	89 e5                	mov    %esp,%ebp
40000bc3:	53                   	push   %ebx
40000bc4:	8b 45 10             	mov    0x10(%ebp),%eax
40000bc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
40000bca:	85 c0                	test   %eax,%eax
40000bcc:	74 2e                	je     40000bfc <strlcpy+0x3c>
		while (--size > 0 && *src != '\0')
40000bce:	8b 55 08             	mov    0x8(%ebp),%edx
40000bd1:	83 e8 01             	sub    $0x1,%eax
40000bd4:	74 23                	je     40000bf9 <strlcpy+0x39>
40000bd6:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
40000bd9:	eb 12                	jmp    40000bed <strlcpy+0x2d>
40000bdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
			*dst++ = *src++;
40000be0:	83 c2 01             	add    $0x1,%edx
40000be3:	83 c1 01             	add    $0x1,%ecx
40000be6:	88 42 ff             	mov    %al,-0x1(%edx)
		while (--size > 0 && *src != '\0')
40000be9:	39 da                	cmp    %ebx,%edx
40000beb:	74 07                	je     40000bf4 <strlcpy+0x34>
40000bed:	0f b6 01             	movzbl (%ecx),%eax
40000bf0:	84 c0                	test   %al,%al
40000bf2:	75 ec                	jne    40000be0 <strlcpy+0x20>
		*dst = '\0';
	}
	return dst - dst_in;
40000bf4:	89 d0                	mov    %edx,%eax
40000bf6:	2b 45 08             	sub    0x8(%ebp),%eax
		*dst = '\0';
40000bf9:	c6 02 00             	movb   $0x0,(%edx)
}
40000bfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000bff:	c9                   	leave
40000c00:	c3                   	ret
40000c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c0f:	00 

40000c10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
40000c10:	55                   	push   %ebp
40000c11:	89 e5                	mov    %esp,%ebp
40000c13:	53                   	push   %ebx
40000c14:	8b 55 08             	mov    0x8(%ebp),%edx
40000c17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
40000c1a:	0f b6 02             	movzbl (%edx),%eax
40000c1d:	84 c0                	test   %al,%al
40000c1f:	75 2d                	jne    40000c4e <strcmp+0x3e>
40000c21:	eb 4a                	jmp    40000c6d <strcmp+0x5d>
40000c23:	eb 1b                	jmp    40000c40 <strcmp+0x30>
40000c25:	8d 76 00             	lea    0x0(%esi),%esi
40000c28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c2f:	00 
40000c30:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c37:	00 
40000c38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c3f:	00 
40000c40:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		p++, q++;
40000c44:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
40000c47:	84 c0                	test   %al,%al
40000c49:	74 15                	je     40000c60 <strcmp+0x50>
40000c4b:	83 c1 01             	add    $0x1,%ecx
40000c4e:	0f b6 19             	movzbl (%ecx),%ebx
40000c51:	38 c3                	cmp    %al,%bl
40000c53:	74 eb                	je     40000c40 <strcmp+0x30>
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c55:	29 d8                	sub    %ebx,%eax
}
40000c57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c5a:	c9                   	leave
40000c5b:	c3                   	ret
40000c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c60:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
40000c64:	31 c0                	xor    %eax,%eax
40000c66:	29 d8                	sub    %ebx,%eax
}
40000c68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c6b:	c9                   	leave
40000c6c:	c3                   	ret
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c6d:	0f b6 19             	movzbl (%ecx),%ebx
40000c70:	31 c0                	xor    %eax,%eax
40000c72:	eb e1                	jmp    40000c55 <strcmp+0x45>
40000c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000c78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c7f:	00 

40000c80 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
40000c80:	55                   	push   %ebp
40000c81:	89 e5                	mov    %esp,%ebp
40000c83:	53                   	push   %ebx
40000c84:	8b 55 10             	mov    0x10(%ebp),%edx
40000c87:	8b 45 08             	mov    0x8(%ebp),%eax
40000c8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
40000c8d:	85 d2                	test   %edx,%edx
40000c8f:	75 16                	jne    40000ca7 <strncmp+0x27>
40000c91:	eb 2d                	jmp    40000cc0 <strncmp+0x40>
40000c93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c98:	3a 19                	cmp    (%ecx),%bl
40000c9a:	75 12                	jne    40000cae <strncmp+0x2e>
		n--, p++, q++;
40000c9c:	83 c0 01             	add    $0x1,%eax
40000c9f:	83 c1 01             	add    $0x1,%ecx
	while (n > 0 && *p && *p == *q)
40000ca2:	83 ea 01             	sub    $0x1,%edx
40000ca5:	74 19                	je     40000cc0 <strncmp+0x40>
40000ca7:	0f b6 18             	movzbl (%eax),%ebx
40000caa:	84 db                	test   %bl,%bl
40000cac:	75 ea                	jne    40000c98 <strncmp+0x18>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000cae:	0f b6 00             	movzbl (%eax),%eax
40000cb1:	0f b6 11             	movzbl (%ecx),%edx
}
40000cb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000cb7:	c9                   	leave
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000cb8:	29 d0                	sub    %edx,%eax
}
40000cba:	c3                   	ret
40000cbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000cc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
		return 0;
40000cc3:	31 c0                	xor    %eax,%eax
}
40000cc5:	c9                   	leave
40000cc6:	c3                   	ret
40000cc7:	90                   	nop
40000cc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ccf:	00 

40000cd0 <strchr>:

char *
strchr(const char *s, char c)
{
40000cd0:	55                   	push   %ebp
40000cd1:	89 e5                	mov    %esp,%ebp
40000cd3:	8b 45 08             	mov    0x8(%ebp),%eax
40000cd6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
40000cda:	0f b6 10             	movzbl (%eax),%edx
40000cdd:	84 d2                	test   %dl,%dl
40000cdf:	75 1a                	jne    40000cfb <strchr+0x2b>
40000ce1:	eb 25                	jmp    40000d08 <strchr+0x38>
40000ce3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ce8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000cef:	00 
40000cf0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000cf4:	83 c0 01             	add    $0x1,%eax
40000cf7:	84 d2                	test   %dl,%dl
40000cf9:	74 0d                	je     40000d08 <strchr+0x38>
		if (*s == c)
40000cfb:	38 d1                	cmp    %dl,%cl
40000cfd:	75 f1                	jne    40000cf0 <strchr+0x20>
			return (char *) s;
	return 0;
}
40000cff:	5d                   	pop    %ebp
40000d00:	c3                   	ret
40000d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return 0;
40000d08:	31 c0                	xor    %eax,%eax
}
40000d0a:	5d                   	pop    %ebp
40000d0b:	c3                   	ret
40000d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000d10 <strfind>:

char *
strfind(const char *s, char c)
{
40000d10:	55                   	push   %ebp
40000d11:	89 e5                	mov    %esp,%ebp
40000d13:	8b 45 08             	mov    0x8(%ebp),%eax
40000d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	for (; *s; s++)
40000d19:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
40000d1c:	38 ca                	cmp    %cl,%dl
40000d1e:	75 1b                	jne    40000d3b <strfind+0x2b>
40000d20:	eb 1d                	jmp    40000d3f <strfind+0x2f>
40000d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000d28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d2f:	00 
	for (; *s; s++)
40000d30:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000d34:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
40000d37:	38 ca                	cmp    %cl,%dl
40000d39:	74 04                	je     40000d3f <strfind+0x2f>
40000d3b:	84 d2                	test   %dl,%dl
40000d3d:	75 f1                	jne    40000d30 <strfind+0x20>
			break;
	return (char *) s;
}
40000d3f:	5d                   	pop    %ebp
40000d40:	c3                   	ret
40000d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d4f:	00 

40000d50 <strtol>:


long
strtol(const char *s, char **endptr, int base)
{
40000d50:	55                   	push   %ebp
40000d51:	89 e5                	mov    %esp,%ebp
40000d53:	57                   	push   %edi
40000d54:	8b 55 08             	mov    0x8(%ebp),%edx
40000d57:	56                   	push   %esi
40000d58:	53                   	push   %ebx
40000d59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
40000d5c:	0f b6 02             	movzbl (%edx),%eax
40000d5f:	3c 09                	cmp    $0x9,%al
40000d61:	74 0d                	je     40000d70 <strtol+0x20>
40000d63:	3c 20                	cmp    $0x20,%al
40000d65:	75 18                	jne    40000d7f <strtol+0x2f>
40000d67:	90                   	nop
40000d68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d6f:	00 
40000d70:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		s++;
40000d74:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
40000d77:	3c 20                	cmp    $0x20,%al
40000d79:	74 f5                	je     40000d70 <strtol+0x20>
40000d7b:	3c 09                	cmp    $0x9,%al
40000d7d:	74 f1                	je     40000d70 <strtol+0x20>

	// plus/minus sign
	if (*s == '+')
40000d7f:	3c 2b                	cmp    $0x2b,%al
40000d81:	0f 84 89 00 00 00    	je     40000e10 <strtol+0xc0>
		s++;
	else if (*s == '-')
		s++, neg = 1;
40000d87:	3c 2d                	cmp    $0x2d,%al
40000d89:	8d 4a 01             	lea    0x1(%edx),%ecx
40000d8c:	0f 94 c0             	sete   %al
40000d8f:	0f 44 d1             	cmove  %ecx,%edx
40000d92:	0f b6 c0             	movzbl %al,%eax

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000d95:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
40000d9b:	75 10                	jne    40000dad <strtol+0x5d>
40000d9d:	80 3a 30             	cmpb   $0x30,(%edx)
40000da0:	74 7e                	je     40000e20 <strtol+0xd0>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
40000da2:	83 fb 01             	cmp    $0x1,%ebx
40000da5:	19 db                	sbb    %ebx,%ebx
40000da7:	83 e3 fa             	and    $0xfffffffa,%ebx
40000daa:	83 c3 10             	add    $0x10,%ebx
40000dad:	89 5d 10             	mov    %ebx,0x10(%ebp)
40000db0:	31 c9                	xor    %ecx,%ecx
40000db2:	89 c7                	mov    %eax,%edi
40000db4:	eb 13                	jmp    40000dc9 <strtol+0x79>
40000db6:	66 90                	xchg   %ax,%ax
40000db8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000dbf:	00 
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
		s++, val = (val * base) + dig;
40000dc0:	0f af 4d 10          	imul   0x10(%ebp),%ecx
40000dc4:	83 c2 01             	add    $0x1,%edx
40000dc7:	01 f1                	add    %esi,%ecx
		if (*s >= '0' && *s <= '9')
40000dc9:	0f be 1a             	movsbl (%edx),%ebx
40000dcc:	8d 43 d0             	lea    -0x30(%ebx),%eax
			dig = *s - '0';
40000dcf:	8d 73 d0             	lea    -0x30(%ebx),%esi
		if (*s >= '0' && *s <= '9')
40000dd2:	3c 09                	cmp    $0x9,%al
40000dd4:	76 14                	jbe    40000dea <strtol+0x9a>
		else if (*s >= 'a' && *s <= 'z')
40000dd6:	8d 43 9f             	lea    -0x61(%ebx),%eax
			dig = *s - 'a' + 10;
40000dd9:	8d 73 a9             	lea    -0x57(%ebx),%esi
		else if (*s >= 'a' && *s <= 'z')
40000ddc:	3c 19                	cmp    $0x19,%al
40000dde:	76 0a                	jbe    40000dea <strtol+0x9a>
		else if (*s >= 'A' && *s <= 'Z')
40000de0:	8d 43 bf             	lea    -0x41(%ebx),%eax
40000de3:	3c 19                	cmp    $0x19,%al
40000de5:	77 08                	ja     40000def <strtol+0x9f>
			dig = *s - 'A' + 10;
40000de7:	8d 73 c9             	lea    -0x37(%ebx),%esi
		if (dig >= base)
40000dea:	3b 75 10             	cmp    0x10(%ebp),%esi
40000ded:	7c d1                	jl     40000dc0 <strtol+0x70>
		// we don't properly detect overflow!
	}

	if (endptr)
40000def:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000df2:	89 f8                	mov    %edi,%eax
40000df4:	85 db                	test   %ebx,%ebx
40000df6:	74 05                	je     40000dfd <strtol+0xad>
		*endptr = (char *) s;
40000df8:	8b 7d 0c             	mov    0xc(%ebp),%edi
40000dfb:	89 17                	mov    %edx,(%edi)
	return (neg ? -val : val);
40000dfd:	89 ca                	mov    %ecx,%edx
}
40000dff:	5b                   	pop    %ebx
40000e00:	5e                   	pop    %esi
	return (neg ? -val : val);
40000e01:	f7 da                	neg    %edx
40000e03:	85 c0                	test   %eax,%eax
}
40000e05:	5f                   	pop    %edi
40000e06:	5d                   	pop    %ebp
	return (neg ? -val : val);
40000e07:	0f 45 ca             	cmovne %edx,%ecx
}
40000e0a:	89 c8                	mov    %ecx,%eax
40000e0c:	c3                   	ret
40000e0d:	8d 76 00             	lea    0x0(%esi),%esi
		s++;
40000e10:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
40000e13:	31 c0                	xor    %eax,%eax
40000e15:	e9 7b ff ff ff       	jmp    40000d95 <strtol+0x45>
40000e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000e20:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
40000e24:	74 1b                	je     40000e41 <strtol+0xf1>
	else if (base == 0 && s[0] == '0')
40000e26:	85 db                	test   %ebx,%ebx
40000e28:	74 0a                	je     40000e34 <strtol+0xe4>
40000e2a:	bb 10 00 00 00       	mov    $0x10,%ebx
40000e2f:	e9 79 ff ff ff       	jmp    40000dad <strtol+0x5d>
		s++, base = 8;
40000e34:	83 c2 01             	add    $0x1,%edx
40000e37:	bb 08 00 00 00       	mov    $0x8,%ebx
40000e3c:	e9 6c ff ff ff       	jmp    40000dad <strtol+0x5d>
		s += 2, base = 16;
40000e41:	83 c2 02             	add    $0x2,%edx
40000e44:	bb 10 00 00 00       	mov    $0x10,%ebx
40000e49:	e9 5f ff ff ff       	jmp    40000dad <strtol+0x5d>
40000e4e:	66 90                	xchg   %ax,%ax

40000e50 <memset>:

void *
memset(void *v, int c, size_t n)
{
40000e50:	55                   	push   %ebp
40000e51:	89 e5                	mov    %esp,%ebp
40000e53:	57                   	push   %edi
40000e54:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000e57:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000e5a:	85 c9                	test   %ecx,%ecx
40000e5c:	74 1a                	je     40000e78 <memset+0x28>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
40000e5e:	89 d0                	mov    %edx,%eax
40000e60:	09 c8                	or     %ecx,%eax
40000e62:	a8 03                	test   $0x3,%al
40000e64:	75 1a                	jne    40000e80 <memset+0x30>
		c &= 0xFF;
40000e66:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
40000e6a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000e6d:	89 d7                	mov    %edx,%edi
40000e6f:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
40000e75:	fc                   	cld
40000e76:	f3 ab                	rep stos %eax,%es:(%edi)
	} else
		asm volatile("cld; rep stosb\n"
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
}
40000e78:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000e7b:	89 d0                	mov    %edx,%eax
40000e7d:	c9                   	leave
40000e7e:	c3                   	ret
40000e7f:	90                   	nop
		asm volatile("cld; rep stosb\n"
40000e80:	8b 45 0c             	mov    0xc(%ebp),%eax
40000e83:	89 d7                	mov    %edx,%edi
40000e85:	fc                   	cld
40000e86:	f3 aa                	rep stos %al,%es:(%edi)
}
40000e88:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000e8b:	89 d0                	mov    %edx,%eax
40000e8d:	c9                   	leave
40000e8e:	c3                   	ret
40000e8f:	90                   	nop

40000e90 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
40000e90:	55                   	push   %ebp
40000e91:	89 e5                	mov    %esp,%ebp
40000e93:	57                   	push   %edi
40000e94:	8b 45 08             	mov    0x8(%ebp),%eax
40000e97:	8b 55 0c             	mov    0xc(%ebp),%edx
40000e9a:	56                   	push   %esi
40000e9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000e9e:	53                   	push   %ebx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
40000e9f:	39 c2                	cmp    %eax,%edx
40000ea1:	73 2d                	jae    40000ed0 <memmove+0x40>
40000ea3:	8d 1c 0a             	lea    (%edx,%ecx,1),%ebx
40000ea6:	39 d8                	cmp    %ebx,%eax
40000ea8:	73 26                	jae    40000ed0 <memmove+0x40>
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000eaa:	8d 14 08             	lea    (%eax,%ecx,1),%edx
40000ead:	09 ca                	or     %ecx,%edx
40000eaf:	09 da                	or     %ebx,%edx
40000eb1:	83 e2 03             	and    $0x3,%edx
40000eb4:	74 4a                	je     40000f00 <memmove+0x70>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
				     : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
40000eb6:	8d 7c 08 ff          	lea    -0x1(%eax,%ecx,1),%edi
40000eba:	8d 73 ff             	lea    -0x1(%ebx),%esi
40000ebd:	fd                   	std
40000ebe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				     :: "D" (d-1), "S" (s-1), "c" (n)
				     : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
40000ec0:	fc                   	cld
			asm volatile("cld; rep movsb\n"
				     :: "D" (d), "S" (s), "c" (n)
				     : "cc", "memory");
	}
	return dst;
}
40000ec1:	5b                   	pop    %ebx
40000ec2:	5e                   	pop    %esi
40000ec3:	5f                   	pop    %edi
40000ec4:	5d                   	pop    %ebp
40000ec5:	c3                   	ret
40000ec6:	66 90                	xchg   %ax,%ax
40000ec8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ecf:	00 
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000ed0:	89 c3                	mov    %eax,%ebx
40000ed2:	09 cb                	or     %ecx,%ebx
40000ed4:	09 d3                	or     %edx,%ebx
40000ed6:	83 e3 03             	and    $0x3,%ebx
40000ed9:	74 15                	je     40000ef0 <memmove+0x60>
			asm volatile("cld; rep movsb\n"
40000edb:	89 c7                	mov    %eax,%edi
40000edd:	89 d6                	mov    %edx,%esi
40000edf:	fc                   	cld
40000ee0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000ee2:	5b                   	pop    %ebx
40000ee3:	5e                   	pop    %esi
40000ee4:	5f                   	pop    %edi
40000ee5:	5d                   	pop    %ebp
40000ee6:	c3                   	ret
40000ee7:	90                   	nop
40000ee8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000eef:	00 
				     :: "D" (d), "S" (s), "c" (n/4)
40000ef0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
40000ef3:	89 c7                	mov    %eax,%edi
40000ef5:	89 d6                	mov    %edx,%esi
40000ef7:	fc                   	cld
40000ef8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000efa:	eb e6                	jmp    40000ee2 <memmove+0x52>
40000efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			asm volatile("std; rep movsl\n"
40000f00:	8d 7c 08 fc          	lea    -0x4(%eax,%ecx,1),%edi
40000f04:	8d 73 fc             	lea    -0x4(%ebx),%esi
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
40000f07:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
40000f0a:	fd                   	std
40000f0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000f0d:	eb b1                	jmp    40000ec0 <memmove+0x30>
40000f0f:	90                   	nop

40000f10 <memcpy>:

void *
memcpy(void *dst, const void *src, size_t n)
{
	return memmove(dst, src, n);
40000f10:	e9 7b ff ff ff       	jmp    40000e90 <memmove>
40000f15:	8d 76 00             	lea    0x0(%esi),%esi
40000f18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f1f:	00 

40000f20 <memcmp>:
}

int
memcmp(const void *v1, const void *v2, size_t n)
{
40000f20:	55                   	push   %ebp
40000f21:	89 e5                	mov    %esp,%ebp
40000f23:	56                   	push   %esi
40000f24:	8b 75 10             	mov    0x10(%ebp),%esi
40000f27:	8b 45 08             	mov    0x8(%ebp),%eax
40000f2a:	53                   	push   %ebx
40000f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
40000f2e:	85 f6                	test   %esi,%esi
40000f30:	74 2e                	je     40000f60 <memcmp+0x40>
40000f32:	01 c6                	add    %eax,%esi
40000f34:	eb 14                	jmp    40000f4a <memcmp+0x2a>
40000f36:	66 90                	xchg   %ax,%ax
40000f38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f3f:	00 
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
40000f40:	83 c0 01             	add    $0x1,%eax
40000f43:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
40000f46:	39 f0                	cmp    %esi,%eax
40000f48:	74 16                	je     40000f60 <memcmp+0x40>
		if (*s1 != *s2)
40000f4a:	0f b6 08             	movzbl (%eax),%ecx
40000f4d:	0f b6 1a             	movzbl (%edx),%ebx
40000f50:	38 d9                	cmp    %bl,%cl
40000f52:	74 ec                	je     40000f40 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
40000f54:	0f b6 c1             	movzbl %cl,%eax
40000f57:	29 d8                	sub    %ebx,%eax
	}

	return 0;
}
40000f59:	5b                   	pop    %ebx
40000f5a:	5e                   	pop    %esi
40000f5b:	5d                   	pop    %ebp
40000f5c:	c3                   	ret
40000f5d:	8d 76 00             	lea    0x0(%esi),%esi
40000f60:	5b                   	pop    %ebx
	return 0;
40000f61:	31 c0                	xor    %eax,%eax
}
40000f63:	5e                   	pop    %esi
40000f64:	5d                   	pop    %ebp
40000f65:	c3                   	ret
40000f66:	66 90                	xchg   %ax,%ax
40000f68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f6f:	00 

40000f70 <memchr>:

void *
memchr(const void *s, int c, size_t n)
{
40000f70:	55                   	push   %ebp
40000f71:	89 e5                	mov    %esp,%ebp
40000f73:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
40000f76:	8b 55 10             	mov    0x10(%ebp),%edx
40000f79:	01 c2                	add    %eax,%edx
	for (; s < ends; s++)
40000f7b:	39 d0                	cmp    %edx,%eax
40000f7d:	73 21                	jae    40000fa0 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000f7f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
40000f83:	eb 12                	jmp    40000f97 <memchr+0x27>
40000f85:	8d 76 00             	lea    0x0(%esi),%esi
40000f88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f8f:	00 
	for (; s < ends; s++)
40000f90:	83 c0 01             	add    $0x1,%eax
40000f93:	39 c2                	cmp    %eax,%edx
40000f95:	74 09                	je     40000fa0 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000f97:	38 08                	cmp    %cl,(%eax)
40000f99:	75 f5                	jne    40000f90 <memchr+0x20>
			return (void *) s;
	return NULL;
}
40000f9b:	5d                   	pop    %ebp
40000f9c:	c3                   	ret
40000f9d:	8d 76 00             	lea    0x0(%esi),%esi
	return NULL;
40000fa0:	31 c0                	xor    %eax,%eax
}
40000fa2:	5d                   	pop    %ebp
40000fa3:	c3                   	ret
40000fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000fa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000faf:	00 

40000fb0 <memzero>:

void *
memzero(void *v, size_t n)
{
40000fb0:	55                   	push   %ebp
40000fb1:	89 e5                	mov    %esp,%ebp
40000fb3:	57                   	push   %edi
40000fb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000fb7:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000fba:	85 c9                	test   %ecx,%ecx
40000fbc:	74 11                	je     40000fcf <memzero+0x1f>
	if ((int)v%4 == 0 && n%4 == 0) {
40000fbe:	89 d0                	mov    %edx,%eax
40000fc0:	09 c8                	or     %ecx,%eax
40000fc2:	83 e0 03             	and    $0x3,%eax
40000fc5:	75 19                	jne    40000fe0 <memzero+0x30>
			     :: "D" (v), "a" (c), "c" (n/4)
40000fc7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000fca:	89 d7                	mov    %edx,%edi
40000fcc:	fc                   	cld
40000fcd:	f3 ab                	rep stos %eax,%es:(%edi)
	return memset(v, 0, n);
}
40000fcf:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000fd2:	89 d0                	mov    %edx,%eax
40000fd4:	c9                   	leave
40000fd5:	c3                   	ret
40000fd6:	66 90                	xchg   %ax,%ax
40000fd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000fdf:	00 
		asm volatile("cld; rep stosb\n"
40000fe0:	89 d7                	mov    %edx,%edi
40000fe2:	31 c0                	xor    %eax,%eax
40000fe4:	fc                   	cld
40000fe5:	f3 aa                	rep stos %al,%es:(%edi)
}
40000fe7:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000fea:	89 d0                	mov    %edx,%eax
40000fec:	c9                   	leave
40000fed:	c3                   	ret
40000fee:	66 90                	xchg   %ax,%ax

40000ff0 <sigaction>:
#include <signal.h>
#include <syscall.h>

int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
40000ff0:	55                   	push   %ebp

static gcc_inline int
sys_sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
	int errno;
	asm volatile ("int %1"
40000ff1:	b8 1a 00 00 00       	mov    $0x1a,%eax
40000ff6:	89 e5                	mov    %esp,%ebp
40000ff8:	53                   	push   %ebx
40000ff9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000ffc:	8b 55 10             	mov    0x10(%ebp),%edx
40000fff:	8b 5d 08             	mov    0x8(%ebp),%ebx
40001002:	cd 30                	int    $0x30
		        "a" (SYS_sigaction),
		        "b" (signum),
		        "c" (act),
		        "d" (oldact)
		      : "cc", "memory");
	return errno ? -1 : 0;
40001004:	f7 d8                	neg    %eax
    return sys_sigaction(signum, act, oldact);
}
40001006:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40001009:	c9                   	leave
4000100a:	19 c0                	sbb    %eax,%eax
4000100c:	c3                   	ret
4000100d:	8d 76 00             	lea    0x0(%esi),%esi

40001010 <kill>:

int kill(int pid, int signum)
{
40001010:	55                   	push   %ebp

static gcc_inline int
sys_kill(int pid, int signum)
{
	int errno;
	asm volatile ("int %1"
40001011:	b8 1b 00 00 00       	mov    $0x1b,%eax
40001016:	89 e5                	mov    %esp,%ebp
40001018:	53                   	push   %ebx
40001019:	8b 4d 0c             	mov    0xc(%ebp),%ecx
4000101c:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000101f:	cd 30                	int    $0x30
		      : "i" (T_SYSCALL),
		        "a" (SYS_kill),
		        "b" (pid),
		        "c" (signum)
		      : "cc", "memory");
	return errno ? -1 : 0;
40001021:	f7 d8                	neg    %eax
    return sys_kill(pid, signum);
}
40001023:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40001026:	c9                   	leave
40001027:	19 c0                	sbb    %eax,%eax
40001029:	c3                   	ret
4000102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40001030 <pause>:

static gcc_inline int
sys_pause(void)
{
	int errno;
	asm volatile ("int %1"
40001030:	b8 1c 00 00 00       	mov    $0x1c,%eax
40001035:	cd 30                	int    $0x30
		      : "=a" (errno)
		      : "i" (T_SYSCALL),
		        "a" (SYS_pause)
		      : "cc", "memory");
	return errno ? -1 : 0;
40001037:	f7 d8                	neg    %eax
40001039:	19 c0                	sbb    %eax,%eax

int pause(void)
{
    return sys_pause();
}
4000103b:	c3                   	ret
4000103c:	66 90                	xchg   %ax,%ax
4000103e:	66 90                	xchg   %ax,%ax

40001040 <__udivdi3>:
40001040:	55                   	push   %ebp
40001041:	89 e5                	mov    %esp,%ebp
40001043:	57                   	push   %edi
40001044:	56                   	push   %esi
40001045:	53                   	push   %ebx
40001046:	83 ec 1c             	sub    $0x1c,%esp
40001049:	8b 75 08             	mov    0x8(%ebp),%esi
4000104c:	8b 45 14             	mov    0x14(%ebp),%eax
4000104f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40001052:	8b 7d 10             	mov    0x10(%ebp),%edi
40001055:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40001058:	85 c0                	test   %eax,%eax
4000105a:	75 1c                	jne    40001078 <__udivdi3+0x38>
4000105c:	39 fb                	cmp    %edi,%ebx
4000105e:	73 50                	jae    400010b0 <__udivdi3+0x70>
40001060:	89 f0                	mov    %esi,%eax
40001062:	31 f6                	xor    %esi,%esi
40001064:	89 da                	mov    %ebx,%edx
40001066:	f7 f7                	div    %edi
40001068:	89 f2                	mov    %esi,%edx
4000106a:	83 c4 1c             	add    $0x1c,%esp
4000106d:	5b                   	pop    %ebx
4000106e:	5e                   	pop    %esi
4000106f:	5f                   	pop    %edi
40001070:	5d                   	pop    %ebp
40001071:	c3                   	ret
40001072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001078:	39 c3                	cmp    %eax,%ebx
4000107a:	73 14                	jae    40001090 <__udivdi3+0x50>
4000107c:	31 f6                	xor    %esi,%esi
4000107e:	31 c0                	xor    %eax,%eax
40001080:	89 f2                	mov    %esi,%edx
40001082:	83 c4 1c             	add    $0x1c,%esp
40001085:	5b                   	pop    %ebx
40001086:	5e                   	pop    %esi
40001087:	5f                   	pop    %edi
40001088:	5d                   	pop    %ebp
40001089:	c3                   	ret
4000108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001090:	0f bd f0             	bsr    %eax,%esi
40001093:	83 f6 1f             	xor    $0x1f,%esi
40001096:	75 48                	jne    400010e0 <__udivdi3+0xa0>
40001098:	39 d8                	cmp    %ebx,%eax
4000109a:	72 07                	jb     400010a3 <__udivdi3+0x63>
4000109c:	31 c0                	xor    %eax,%eax
4000109e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
400010a1:	72 dd                	jb     40001080 <__udivdi3+0x40>
400010a3:	b8 01 00 00 00       	mov    $0x1,%eax
400010a8:	eb d6                	jmp    40001080 <__udivdi3+0x40>
400010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400010b0:	89 f9                	mov    %edi,%ecx
400010b2:	85 ff                	test   %edi,%edi
400010b4:	75 0b                	jne    400010c1 <__udivdi3+0x81>
400010b6:	b8 01 00 00 00       	mov    $0x1,%eax
400010bb:	31 d2                	xor    %edx,%edx
400010bd:	f7 f7                	div    %edi
400010bf:	89 c1                	mov    %eax,%ecx
400010c1:	31 d2                	xor    %edx,%edx
400010c3:	89 d8                	mov    %ebx,%eax
400010c5:	f7 f1                	div    %ecx
400010c7:	89 c6                	mov    %eax,%esi
400010c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400010cc:	f7 f1                	div    %ecx
400010ce:	89 f2                	mov    %esi,%edx
400010d0:	83 c4 1c             	add    $0x1c,%esp
400010d3:	5b                   	pop    %ebx
400010d4:	5e                   	pop    %esi
400010d5:	5f                   	pop    %edi
400010d6:	5d                   	pop    %ebp
400010d7:	c3                   	ret
400010d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400010df:	00 
400010e0:	89 f1                	mov    %esi,%ecx
400010e2:	ba 20 00 00 00       	mov    $0x20,%edx
400010e7:	29 f2                	sub    %esi,%edx
400010e9:	d3 e0                	shl    %cl,%eax
400010eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
400010ee:	89 d1                	mov    %edx,%ecx
400010f0:	89 f8                	mov    %edi,%eax
400010f2:	d3 e8                	shr    %cl,%eax
400010f4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
400010f7:	09 c1                	or     %eax,%ecx
400010f9:	89 d8                	mov    %ebx,%eax
400010fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
400010fe:	89 f1                	mov    %esi,%ecx
40001100:	d3 e7                	shl    %cl,%edi
40001102:	89 d1                	mov    %edx,%ecx
40001104:	d3 e8                	shr    %cl,%eax
40001106:	89 f1                	mov    %esi,%ecx
40001108:	89 7d dc             	mov    %edi,-0x24(%ebp)
4000110b:	89 45 d8             	mov    %eax,-0x28(%ebp)
4000110e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40001111:	d3 e3                	shl    %cl,%ebx
40001113:	89 d1                	mov    %edx,%ecx
40001115:	8b 55 d8             	mov    -0x28(%ebp),%edx
40001118:	d3 e8                	shr    %cl,%eax
4000111a:	09 d8                	or     %ebx,%eax
4000111c:	f7 75 e0             	divl   -0x20(%ebp)
4000111f:	89 d3                	mov    %edx,%ebx
40001121:	89 c7                	mov    %eax,%edi
40001123:	f7 65 dc             	mull   -0x24(%ebp)
40001126:	89 45 e0             	mov    %eax,-0x20(%ebp)
40001129:	39 d3                	cmp    %edx,%ebx
4000112b:	72 23                	jb     40001150 <__udivdi3+0x110>
4000112d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40001130:	89 f1                	mov    %esi,%ecx
40001132:	d3 e0                	shl    %cl,%eax
40001134:	3b 45 e0             	cmp    -0x20(%ebp),%eax
40001137:	73 04                	jae    4000113d <__udivdi3+0xfd>
40001139:	39 d3                	cmp    %edx,%ebx
4000113b:	74 13                	je     40001150 <__udivdi3+0x110>
4000113d:	89 f8                	mov    %edi,%eax
4000113f:	31 f6                	xor    %esi,%esi
40001141:	e9 3a ff ff ff       	jmp    40001080 <__udivdi3+0x40>
40001146:	66 90                	xchg   %ax,%ax
40001148:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000114f:	00 
40001150:	8d 47 ff             	lea    -0x1(%edi),%eax
40001153:	31 f6                	xor    %esi,%esi
40001155:	e9 26 ff ff ff       	jmp    40001080 <__udivdi3+0x40>
4000115a:	66 90                	xchg   %ax,%ax
4000115c:	66 90                	xchg   %ax,%ax
4000115e:	66 90                	xchg   %ax,%ax

40001160 <__umoddi3>:
40001160:	55                   	push   %ebp
40001161:	89 e5                	mov    %esp,%ebp
40001163:	57                   	push   %edi
40001164:	56                   	push   %esi
40001165:	53                   	push   %ebx
40001166:	83 ec 2c             	sub    $0x2c,%esp
40001169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
4000116c:	8b 45 14             	mov    0x14(%ebp),%eax
4000116f:	8b 75 08             	mov    0x8(%ebp),%esi
40001172:	8b 7d 10             	mov    0x10(%ebp),%edi
40001175:	89 da                	mov    %ebx,%edx
40001177:	85 c0                	test   %eax,%eax
40001179:	75 15                	jne    40001190 <__umoddi3+0x30>
4000117b:	39 fb                	cmp    %edi,%ebx
4000117d:	73 51                	jae    400011d0 <__umoddi3+0x70>
4000117f:	89 f0                	mov    %esi,%eax
40001181:	f7 f7                	div    %edi
40001183:	89 d0                	mov    %edx,%eax
40001185:	31 d2                	xor    %edx,%edx
40001187:	83 c4 2c             	add    $0x2c,%esp
4000118a:	5b                   	pop    %ebx
4000118b:	5e                   	pop    %esi
4000118c:	5f                   	pop    %edi
4000118d:	5d                   	pop    %ebp
4000118e:	c3                   	ret
4000118f:	90                   	nop
40001190:	89 75 e0             	mov    %esi,-0x20(%ebp)
40001193:	39 c3                	cmp    %eax,%ebx
40001195:	73 11                	jae    400011a8 <__umoddi3+0x48>
40001197:	89 f0                	mov    %esi,%eax
40001199:	83 c4 2c             	add    $0x2c,%esp
4000119c:	5b                   	pop    %ebx
4000119d:	5e                   	pop    %esi
4000119e:	5f                   	pop    %edi
4000119f:	5d                   	pop    %ebp
400011a0:	c3                   	ret
400011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400011a8:	0f bd c8             	bsr    %eax,%ecx
400011ab:	83 f1 1f             	xor    $0x1f,%ecx
400011ae:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
400011b1:	75 3d                	jne    400011f0 <__umoddi3+0x90>
400011b3:	39 d8                	cmp    %ebx,%eax
400011b5:	0f 82 cd 00 00 00    	jb     40001288 <__umoddi3+0x128>
400011bb:	39 fe                	cmp    %edi,%esi
400011bd:	0f 83 c5 00 00 00    	jae    40001288 <__umoddi3+0x128>
400011c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
400011c6:	83 c4 2c             	add    $0x2c,%esp
400011c9:	5b                   	pop    %ebx
400011ca:	5e                   	pop    %esi
400011cb:	5f                   	pop    %edi
400011cc:	5d                   	pop    %ebp
400011cd:	c3                   	ret
400011ce:	66 90                	xchg   %ax,%ax
400011d0:	89 f9                	mov    %edi,%ecx
400011d2:	85 ff                	test   %edi,%edi
400011d4:	75 0b                	jne    400011e1 <__umoddi3+0x81>
400011d6:	b8 01 00 00 00       	mov    $0x1,%eax
400011db:	31 d2                	xor    %edx,%edx
400011dd:	f7 f7                	div    %edi
400011df:	89 c1                	mov    %eax,%ecx
400011e1:	89 d8                	mov    %ebx,%eax
400011e3:	31 d2                	xor    %edx,%edx
400011e5:	f7 f1                	div    %ecx
400011e7:	89 f0                	mov    %esi,%eax
400011e9:	f7 f1                	div    %ecx
400011eb:	eb 96                	jmp    40001183 <__umoddi3+0x23>
400011ed:	8d 76 00             	lea    0x0(%esi),%esi
400011f0:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
400011f4:	ba 20 00 00 00       	mov    $0x20,%edx
400011f9:	2b 55 e4             	sub    -0x1c(%ebp),%edx
400011fc:	89 55 e0             	mov    %edx,-0x20(%ebp)
400011ff:	d3 e0                	shl    %cl,%eax
40001201:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
40001205:	89 45 dc             	mov    %eax,-0x24(%ebp)
40001208:	89 f8                	mov    %edi,%eax
4000120a:	8b 55 dc             	mov    -0x24(%ebp),%edx
4000120d:	d3 e8                	shr    %cl,%eax
4000120f:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001213:	09 c2                	or     %eax,%edx
40001215:	d3 e7                	shl    %cl,%edi
40001217:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
4000121b:	89 55 dc             	mov    %edx,-0x24(%ebp)
4000121e:	89 da                	mov    %ebx,%edx
40001220:	89 7d d8             	mov    %edi,-0x28(%ebp)
40001223:	89 f7                	mov    %esi,%edi
40001225:	d3 ea                	shr    %cl,%edx
40001227:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
4000122b:	d3 e3                	shl    %cl,%ebx
4000122d:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
40001231:	d3 ef                	shr    %cl,%edi
40001233:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001237:	89 f8                	mov    %edi,%eax
40001239:	d3 e6                	shl    %cl,%esi
4000123b:	09 d8                	or     %ebx,%eax
4000123d:	f7 75 dc             	divl   -0x24(%ebp)
40001240:	89 d3                	mov    %edx,%ebx
40001242:	89 75 d4             	mov    %esi,-0x2c(%ebp)
40001245:	89 f7                	mov    %esi,%edi
40001247:	f7 65 d8             	mull   -0x28(%ebp)
4000124a:	89 c6                	mov    %eax,%esi
4000124c:	89 d1                	mov    %edx,%ecx
4000124e:	39 d3                	cmp    %edx,%ebx
40001250:	72 06                	jb     40001258 <__umoddi3+0xf8>
40001252:	75 0e                	jne    40001262 <__umoddi3+0x102>
40001254:	39 c7                	cmp    %eax,%edi
40001256:	73 0a                	jae    40001262 <__umoddi3+0x102>
40001258:	2b 45 d8             	sub    -0x28(%ebp),%eax
4000125b:	1b 55 dc             	sbb    -0x24(%ebp),%edx
4000125e:	89 d1                	mov    %edx,%ecx
40001260:	89 c6                	mov    %eax,%esi
40001262:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40001265:	29 f0                	sub    %esi,%eax
40001267:	19 cb                	sbb    %ecx,%ebx
40001269:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
4000126d:	89 da                	mov    %ebx,%edx
4000126f:	d3 e2                	shl    %cl,%edx
40001271:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001275:	d3 e8                	shr    %cl,%eax
40001277:	d3 eb                	shr    %cl,%ebx
40001279:	09 d0                	or     %edx,%eax
4000127b:	89 da                	mov    %ebx,%edx
4000127d:	83 c4 2c             	add    $0x2c,%esp
40001280:	5b                   	pop    %ebx
40001281:	5e                   	pop    %esi
40001282:	5f                   	pop    %edi
40001283:	5d                   	pop    %ebp
40001284:	c3                   	ret
40001285:	8d 76 00             	lea    0x0(%esi),%esi
40001288:	89 da                	mov    %ebx,%edx
4000128a:	29 fe                	sub    %edi,%esi
4000128c:	19 c2                	sbb    %eax,%edx
4000128e:	89 75 e0             	mov    %esi,-0x20(%ebp)
40001291:	e9 2d ff ff ff       	jmp    400011c3 <__umoddi3+0x63>
