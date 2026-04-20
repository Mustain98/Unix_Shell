
obj/user/ls/ls:     file format elf32-i386


Disassembly of section .text:

40000000 <main>:
#include <syscall.h>

#define BUFSIZE 1024

int main(int argc, char **argv)
{
40000000:	55                   	push   %ebp

static gcc_inline int
sys_ls(char * buf, int buf_len)
{
	int errno, len;
	asm volatile("int %2"
40000001:	b8 12 00 00 00       	mov    $0x12,%eax
40000006:	b9 ff 03 00 00       	mov    $0x3ff,%ecx
4000000b:	89 e5                	mov    %esp,%ebp
4000000d:	57                   	push   %edi
4000000e:	56                   	push   %esi
4000000f:	53                   	push   %ebx
40000010:	8d 9d f4 fb ff ff    	lea    -0x40c(%ebp),%ebx
40000016:	81 ec 00 04 00 00    	sub    $0x400,%esp
4000001c:	cd 30                	int    $0x30
    char buf[BUFSIZE];
    int  n, i;

    n = sys_ls(buf, sizeof(buf) - 1);
    if (n <= 0) {
4000001e:	85 c0                	test   %eax,%eax
40000020:	0f 85 c4 00 00 00    	jne    400000ea <main+0xea>
40000026:	89 df                	mov    %ebx,%edi
40000028:	85 db                	test   %ebx,%ebx
4000002a:	0f 8e ba 00 00 00    	jle    400000ea <main+0xea>
    /* sys_ls returns space-separated names; write one per line */
    i = 0;
    while (i < n) {
        int start = i;
        /* find end of this token */
        while (i < n && buf[i] != ' ' && buf[i] != '\0')
40000030:	39 c3                	cmp    %eax,%ebx
40000032:	0f 8e 9f 00 00 00    	jle    400000d7 <main+0xd7>
40000038:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000003f:	00 
40000040:	89 c6                	mov    %eax,%esi
40000042:	eb 23                	jmp    40000067 <main+0x67>
40000044:	eb 1a                	jmp    40000060 <main+0x60>
40000046:	66 90                	xchg   %ax,%ax
40000048:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000004f:	00 
40000050:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000057:	00 
40000058:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000005f:	00 
            i++;
40000060:	83 c6 01             	add    $0x1,%esi
        while (i < n && buf[i] != ' ' && buf[i] != '\0')
40000063:	39 fe                	cmp    %edi,%esi
40000065:	74 59                	je     400000c0 <main+0xc0>
40000067:	f6 84 35 f4 fb ff ff 	testb  $0xdf,-0x40c(%ebp,%esi,1)
4000006e:	df 
4000006f:	75 ef                	jne    40000060 <main+0x60>
        /* write the token */
        if (i > start)
40000071:	39 c6                	cmp    %eax,%esi
40000073:	0f 8f 8f 00 00 00    	jg     40000108 <main+0x108>
	asm volatile("int %2"
40000079:	bb 01 00 00 00       	mov    $0x1,%ebx
4000007e:	b8 08 00 00 00       	mov    $0x8,%eax
40000083:	b9 f4 12 00 40       	mov    $0x400012f4,%ecx
40000088:	89 da                	mov    %ebx,%edx
4000008a:	cd 30                	int    $0x30
            sys_write(1, buf + start, i - start);
        /* newline after each entry */
        sys_write(1, "\n", 1);
        /* skip the space separator */
        while (i < n && (buf[i] == ' ' || buf[i] == '\0'))
4000008c:	39 f7                	cmp    %esi,%edi
4000008e:	7e 5a                	jle    400000ea <main+0xea>
40000090:	89 f0                	mov    %esi,%eax
40000092:	eb 13                	jmp    400000a7 <main+0xa7>
40000094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000098:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000009f:	00 
            i++;
400000a0:	83 c0 01             	add    $0x1,%eax
        while (i < n && (buf[i] == ' ' || buf[i] == '\0'))
400000a3:	39 f8                	cmp    %edi,%eax
400000a5:	74 43                	je     400000ea <main+0xea>
400000a7:	f6 84 05 f4 fb ff ff 	testb  $0xdf,-0x40c(%ebp,%eax,1)
400000ae:	df 
400000af:	74 ef                	je     400000a0 <main+0xa0>
    while (i < n) {
400000b1:	39 c7                	cmp    %eax,%edi
400000b3:	7f 8b                	jg     40000040 <main+0x40>
400000b5:	eb 33                	jmp    400000ea <main+0xea>
400000b7:	90                   	nop
400000b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400000bf:	00 
            sys_write(1, buf + start, i - start);
400000c0:	89 f2                	mov    %esi,%edx
400000c2:	8d 8c 05 f4 fb ff ff 	lea    -0x40c(%ebp,%eax,1),%ecx
400000c9:	bb 01 00 00 00       	mov    $0x1,%ebx
400000ce:	29 c2                	sub    %eax,%edx
400000d0:	b8 08 00 00 00       	mov    $0x8,%eax
400000d5:	cd 30                	int    $0x30
400000d7:	bb 01 00 00 00       	mov    $0x1,%ebx
400000dc:	b8 08 00 00 00       	mov    $0x8,%eax
400000e1:	b9 f4 12 00 40       	mov    $0x400012f4,%ecx
400000e6:	89 da                	mov    %ebx,%edx
400000e8:	cd 30                	int    $0x30
	asm volatile("int %2"
400000ea:	b8 06 00 00 00       	mov    $0x6,%eax
400000ef:	bb 01 00 00 00       	mov    $0x1,%ebx
400000f4:	cd 30                	int    $0x30
     * CRITICAL: close stdout (the pipe write-end) so the next pipeline
     * stage (e.g. ROT13) receives EOF and terminates cleanly.
     */
    sys_close(1);
    return 0;
}
400000f6:	81 c4 00 04 00 00    	add    $0x400,%esp
400000fc:	31 c0                	xor    %eax,%eax
400000fe:	5b                   	pop    %ebx
400000ff:	5e                   	pop    %esi
40000100:	5f                   	pop    %edi
40000101:	5d                   	pop    %ebp
40000102:	c3                   	ret
40000103:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
            sys_write(1, buf + start, i - start);
40000108:	89 f2                	mov    %esi,%edx
4000010a:	8d 8c 05 f4 fb ff ff 	lea    -0x40c(%ebp,%eax,1),%ecx
	asm volatile("int %2"
40000111:	bb 01 00 00 00       	mov    $0x1,%ebx
40000116:	29 c2                	sub    %eax,%edx
40000118:	b8 08 00 00 00       	mov    $0x8,%eax
4000011d:	cd 30                	int    $0x30
	return errno ? -1 : ret;
4000011f:	e9 55 ff ff ff       	jmp    40000079 <main+0x79>

40000124 <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary/
	 */
	testl	$0x0fffffff, %esp
40000124:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
4000012a:	75 04                	jne    40000130 <args_exist>

4000012c <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
4000012c:	6a 00                	push   $0x0
	pushl	$0
4000012e:	6a 00                	push   $0x0

40000130 <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
40000130:	e8 cb fe ff ff       	call   40000000 <main>

	/* When returning, save return value */
	pushl	%eax
40000135:	50                   	push   %eax

	/* Syscall SYS_exit (30) */
	movl	$30, %eax
40000136:	b8 1e 00 00 00       	mov    $0x1e,%eax
	int	$48
4000013b:	cd 30                	int    $0x30

4000013d <spin>:

spin:
	call	yield
4000013d:	e8 2e 09 00 00       	call   40000a70 <yield>
	jmp	spin
40000142:	eb f9                	jmp    4000013d <spin>
40000144:	66 90                	xchg   %ax,%ax
40000146:	66 90                	xchg   %ax,%ax
40000148:	66 90                	xchg   %ax,%ax
4000014a:	66 90                	xchg   %ax,%ax
4000014c:	66 90                	xchg   %ax,%ax
4000014e:	66 90                	xchg   %ax,%ax

40000150 <debug>:
#include <stdarg.h>
#include <stdio.h>

void
debug(const char *file, int line, const char *fmt, ...)
{
40000150:	55                   	push   %ebp
40000151:	89 e5                	mov    %esp,%ebp
40000153:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[D] %s:%d: ", file, line);
40000156:	ff 75 0c             	push   0xc(%ebp)
40000159:	ff 75 08             	push   0x8(%ebp)
4000015c:	68 b8 12 00 40       	push   $0x400012b8
40000161:	e8 1a 02 00 00       	call   40000380 <printf>
	vcprintf(fmt, ap);
40000166:	58                   	pop    %eax
40000167:	8d 45 14             	lea    0x14(%ebp),%eax
4000016a:	5a                   	pop    %edx
4000016b:	50                   	push   %eax
4000016c:	ff 75 10             	push   0x10(%ebp)
4000016f:	e8 ac 01 00 00       	call   40000320 <vcprintf>
	va_end(ap);
}
40000174:	83 c4 10             	add    $0x10,%esp
40000177:	c9                   	leave
40000178:	c3                   	ret
40000179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000180 <warn>:

void
warn(const char *file, int line, const char *fmt, ...)
{
40000180:	55                   	push   %ebp
40000181:	89 e5                	mov    %esp,%ebp
40000183:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[W] %s:%d: ", file, line);
40000186:	ff 75 0c             	push   0xc(%ebp)
40000189:	ff 75 08             	push   0x8(%ebp)
4000018c:	68 c4 12 00 40       	push   $0x400012c4
40000191:	e8 ea 01 00 00       	call   40000380 <printf>
	vcprintf(fmt, ap);
40000196:	58                   	pop    %eax
40000197:	8d 45 14             	lea    0x14(%ebp),%eax
4000019a:	5a                   	pop    %edx
4000019b:	50                   	push   %eax
4000019c:	ff 75 10             	push   0x10(%ebp)
4000019f:	e8 7c 01 00 00       	call   40000320 <vcprintf>
	va_end(ap);
}
400001a4:	83 c4 10             	add    $0x10,%esp
400001a7:	c9                   	leave
400001a8:	c3                   	ret
400001a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400001b0 <panic>:

void
panic(const char *file, int line, const char *fmt, ...)
{
400001b0:	55                   	push   %ebp
400001b1:	89 e5                	mov    %esp,%ebp
400001b3:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[P] %s:%d: ", file, line);
400001b6:	ff 75 0c             	push   0xc(%ebp)
400001b9:	ff 75 08             	push   0x8(%ebp)
400001bc:	68 d0 12 00 40       	push   $0x400012d0
400001c1:	e8 ba 01 00 00       	call   40000380 <printf>
	vcprintf(fmt, ap);
400001c6:	58                   	pop    %eax
400001c7:	8d 45 14             	lea    0x14(%ebp),%eax
400001ca:	5a                   	pop    %edx
400001cb:	50                   	push   %eax
400001cc:	ff 75 10             	push   0x10(%ebp)
400001cf:	e8 4c 01 00 00       	call   40000320 <vcprintf>
400001d4:	83 c4 10             	add    $0x10,%esp
400001d7:	90                   	nop
400001d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400001df:	00 
	va_end(ap);

	while (1)
		yield();
400001e0:	e8 8b 08 00 00       	call   40000a70 <yield>
	while (1)
400001e5:	eb f9                	jmp    400001e0 <panic+0x30>
400001e7:	66 90                	xchg   %ax,%ax
400001e9:	66 90                	xchg   %ax,%ax
400001eb:	66 90                	xchg   %ax,%ax
400001ed:	66 90                	xchg   %ax,%ax
400001ef:	66 90                	xchg   %ax,%ax
400001f1:	66 90                	xchg   %ax,%ax
400001f3:	66 90                	xchg   %ax,%ax
400001f5:	66 90                	xchg   %ax,%ax
400001f7:	66 90                	xchg   %ax,%ax
400001f9:	66 90                	xchg   %ax,%ax
400001fb:	66 90                	xchg   %ax,%ax
400001fd:	66 90                	xchg   %ax,%ax
400001ff:	90                   	nop

40000200 <atoi>:
#include <stdlib.h>

int
atoi(const char *buf, int *i)
{
40000200:	55                   	push   %ebp
40000201:	89 e5                	mov    %esp,%ebp
40000203:	57                   	push   %edi
40000204:	56                   	push   %esi
40000205:	53                   	push   %ebx
40000206:	83 ec 04             	sub    $0x4,%esp
40000209:	8b 75 08             	mov    0x8(%ebp),%esi
	int loc = 0;
	int numstart = 0;
	int acc = 0;
	int negative = 0;
	if (buf[loc] == '+')
4000020c:	0f b6 06             	movzbl (%esi),%eax
4000020f:	3c 2b                	cmp    $0x2b,%al
40000211:	0f 84 89 00 00 00    	je     400002a0 <atoi+0xa0>
		loc++;
	else if (buf[loc] == '-') {
40000217:	3c 2d                	cmp    $0x2d,%al
40000219:	74 65                	je     40000280 <atoi+0x80>
		negative = 1;
		loc++;
	}
	numstart = loc;
	// no grab the numbers
	while ('0' <= buf[loc] && buf[loc] <= '9') {
4000021b:	8d 50 d0             	lea    -0x30(%eax),%edx
	int negative = 0;
4000021e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int loc = 0;
40000225:	31 ff                	xor    %edi,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000227:	80 fa 09             	cmp    $0x9,%dl
4000022a:	0f 87 8c 00 00 00    	ja     400002bc <atoi+0xbc>
	int loc = 0;
40000230:	89 f9                	mov    %edi,%ecx
	int acc = 0;
40000232:	31 d2                	xor    %edx,%edx
40000234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000238:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000023f:	00 
		acc = acc*10 + (buf[loc]-'0');
40000240:	83 e8 30             	sub    $0x30,%eax
40000243:	8d 14 92             	lea    (%edx,%edx,4),%edx
		loc++;
40000246:	83 c1 01             	add    $0x1,%ecx
		acc = acc*10 + (buf[loc]-'0');
40000249:	0f be c0             	movsbl %al,%eax
4000024c:	8d 14 50             	lea    (%eax,%edx,2),%edx
	while ('0' <= buf[loc] && buf[loc] <= '9') {
4000024f:	0f b6 04 0e          	movzbl (%esi,%ecx,1),%eax
40000253:	8d 58 d0             	lea    -0x30(%eax),%ebx
40000256:	80 fb 09             	cmp    $0x9,%bl
40000259:	76 e5                	jbe    40000240 <atoi+0x40>
	}
	if (numstart == loc) {
4000025b:	39 f9                	cmp    %edi,%ecx
4000025d:	74 5d                	je     400002bc <atoi+0xbc>
		// no numbers have actually been scanned
		return 0;
	}
	if (negative)
		acc = - acc;
4000025f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
40000262:	89 d0                	mov    %edx,%eax
40000264:	f7 d8                	neg    %eax
40000266:	85 db                	test   %ebx,%ebx
40000268:	0f 45 d0             	cmovne %eax,%edx
	*i = acc;
4000026b:	8b 45 0c             	mov    0xc(%ebp),%eax
4000026e:	89 10                	mov    %edx,(%eax)
	return loc;
}
40000270:	83 c4 04             	add    $0x4,%esp
40000273:	89 c8                	mov    %ecx,%eax
40000275:	5b                   	pop    %ebx
40000276:	5e                   	pop    %esi
40000277:	5f                   	pop    %edi
40000278:	5d                   	pop    %ebp
40000279:	c3                   	ret
4000027a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000280:	0f b6 46 01          	movzbl 0x1(%esi),%eax
40000284:	8d 50 d0             	lea    -0x30(%eax),%edx
40000287:	80 fa 09             	cmp    $0x9,%dl
4000028a:	77 30                	ja     400002bc <atoi+0xbc>
		negative = 1;
4000028c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		loc++;
40000293:	bf 01 00 00 00       	mov    $0x1,%edi
40000298:	eb 96                	jmp    40000230 <atoi+0x30>
4000029a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400002a0:	0f b6 46 01          	movzbl 0x1(%esi),%eax
	int negative = 0;
400002a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		loc++;
400002ab:	bf 01 00 00 00       	mov    $0x1,%edi
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400002b0:	8d 50 d0             	lea    -0x30(%eax),%edx
400002b3:	80 fa 09             	cmp    $0x9,%dl
400002b6:	0f 86 74 ff ff ff    	jbe    40000230 <atoi+0x30>
}
400002bc:	83 c4 04             	add    $0x4,%esp
		return 0;
400002bf:	31 c9                	xor    %ecx,%ecx
}
400002c1:	5b                   	pop    %ebx
400002c2:	89 c8                	mov    %ecx,%eax
400002c4:	5e                   	pop    %esi
400002c5:	5f                   	pop    %edi
400002c6:	5d                   	pop    %ebp
400002c7:	c3                   	ret
400002c8:	66 90                	xchg   %ax,%ax
400002ca:	66 90                	xchg   %ax,%ax
400002cc:	66 90                	xchg   %ax,%ax
400002ce:	66 90                	xchg   %ax,%ax

400002d0 <putch>:
	char buf[MAX_BUF];
};

static void
putch(int ch, struct printbuf *b)
{
400002d0:	55                   	push   %ebp
400002d1:	89 e5                	mov    %esp,%ebp
400002d3:	56                   	push   %esi
400002d4:	8b 75 0c             	mov    0xc(%ebp),%esi
	b->buf[b->idx++] = ch;
400002d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
400002da:	53                   	push   %ebx
	b->buf[b->idx++] = ch;
400002db:	8b 06                	mov    (%esi),%eax
400002dd:	8d 50 01             	lea    0x1(%eax),%edx
400002e0:	89 16                	mov    %edx,(%esi)
400002e2:	88 4c 06 08          	mov    %cl,0x8(%esi,%eax,1)
	if (b->idx == MAX_BUF-1) {
400002e6:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
400002ec:	75 1c                	jne    4000030a <putch+0x3a>
		b->buf[b->idx] = 0;
400002ee:	c6 86 07 10 00 00 00 	movb   $0x0,0x1007(%esi)
		puts(b->buf, b->idx);
400002f5:	8d 4e 08             	lea    0x8(%esi),%ecx
	asm volatile("int %2"
400002f8:	b8 08 00 00 00       	mov    $0x8,%eax
400002fd:	bb 01 00 00 00       	mov    $0x1,%ebx
40000302:	cd 30                	int    $0x30
		b->idx = 0;
40000304:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	}
	b->cnt++;
4000030a:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
4000030e:	5b                   	pop    %ebx
4000030f:	5e                   	pop    %esi
40000310:	5d                   	pop    %ebp
40000311:	c3                   	ret
40000312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000318:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000031f:	00 

40000320 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
40000320:	55                   	push   %ebp
40000321:	89 e5                	mov    %esp,%ebp
40000323:	53                   	push   %ebx
40000324:	bb 01 00 00 00       	mov    $0x1,%ebx
	struct printbuf b;

	b.idx = 0;
	b.cnt = 0;
	vprintfmt((void*)putch, &b, fmt, ap);
40000329:	8d 85 f0 ef ff ff    	lea    -0x1010(%ebp),%eax
{
4000032f:	81 ec 14 10 00 00    	sub    $0x1014,%esp
	vprintfmt((void*)putch, &b, fmt, ap);
40000335:	ff 75 0c             	push   0xc(%ebp)
40000338:	ff 75 08             	push   0x8(%ebp)
4000033b:	50                   	push   %eax
4000033c:	68 d0 02 00 40       	push   $0x400002d0
	b.idx = 0;
40000341:	c7 85 f0 ef ff ff 00 	movl   $0x0,-0x1010(%ebp)
40000348:	00 00 00 
	b.cnt = 0;
4000034b:	c7 85 f4 ef ff ff 00 	movl   $0x0,-0x100c(%ebp)
40000352:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
40000355:	e8 26 01 00 00       	call   40000480 <vprintfmt>

	b.buf[b.idx] = 0;
4000035a:	8b 95 f0 ef ff ff    	mov    -0x1010(%ebp),%edx
40000360:	8d 8d f8 ef ff ff    	lea    -0x1008(%ebp),%ecx
40000366:	b8 08 00 00 00       	mov    $0x8,%eax
4000036b:	c6 84 15 f8 ef ff ff 	movb   $0x0,-0x1008(%ebp,%edx,1)
40000372:	00 
40000373:	cd 30                	int    $0x30
	puts(b.buf, b.idx);

	return b.cnt;
}
40000375:	8b 85 f4 ef ff ff    	mov    -0x100c(%ebp),%eax
4000037b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
4000037e:	c9                   	leave
4000037f:	c3                   	ret

40000380 <printf>:

int
printf(const char *fmt, ...)
{
40000380:	55                   	push   %ebp
40000381:	89 e5                	mov    %esp,%ebp
40000383:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
40000386:	8d 45 0c             	lea    0xc(%ebp),%eax
40000389:	50                   	push   %eax
4000038a:	ff 75 08             	push   0x8(%ebp)
4000038d:	e8 8e ff ff ff       	call   40000320 <vcprintf>
	va_end(ap);

	return cnt;
}
40000392:	c9                   	leave
40000393:	c3                   	ret
40000394:	66 90                	xchg   %ax,%ax
40000396:	66 90                	xchg   %ax,%ax
40000398:	66 90                	xchg   %ax,%ax
4000039a:	66 90                	xchg   %ax,%ax
4000039c:	66 90                	xchg   %ax,%ax
4000039e:	66 90                	xchg   %ax,%ax

400003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
400003a0:	55                   	push   %ebp
400003a1:	89 e5                	mov    %esp,%ebp
400003a3:	57                   	push   %edi
400003a4:	89 c7                	mov    %eax,%edi
400003a6:	56                   	push   %esi
400003a7:	89 d6                	mov    %edx,%esi
400003a9:	53                   	push   %ebx
400003aa:	83 ec 2c             	sub    $0x2c,%esp
400003ad:	8b 45 08             	mov    0x8(%ebp),%eax
400003b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
400003b3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
{
400003ba:	8b 4d 18             	mov    0x18(%ebp),%ecx
400003bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
400003c0:	8b 45 10             	mov    0x10(%ebp),%eax
400003c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
400003c6:	8b 55 14             	mov    0x14(%ebp),%edx
400003c9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	if (num >= base) {
400003cc:	39 45 d8             	cmp    %eax,-0x28(%ebp)
400003cf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
400003d2:	1b 4d d4             	sbb    -0x2c(%ebp),%ecx
400003d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
400003d8:	8d 5a ff             	lea    -0x1(%edx),%ebx
	if (num >= base) {
400003db:	73 53                	jae    40000430 <printnum+0x90>
		while (--width > 0)
400003dd:	83 fa 01             	cmp    $0x1,%edx
400003e0:	7e 1f                	jle    40000401 <printnum+0x61>
400003e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400003e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400003ef:	00 
			putch(padc, putdat);
400003f0:	83 ec 08             	sub    $0x8,%esp
400003f3:	56                   	push   %esi
400003f4:	ff 75 e4             	push   -0x1c(%ebp)
400003f7:	ff d7                	call   *%edi
		while (--width > 0)
400003f9:	83 c4 10             	add    $0x10,%esp
400003fc:	83 eb 01             	sub    $0x1,%ebx
400003ff:	75 ef                	jne    400003f0 <printnum+0x50>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
40000401:	89 75 0c             	mov    %esi,0xc(%ebp)
40000404:	ff 75 d4             	push   -0x2c(%ebp)
40000407:	ff 75 d0             	push   -0x30(%ebp)
4000040a:	ff 75 dc             	push   -0x24(%ebp)
4000040d:	ff 75 d8             	push   -0x28(%ebp)
40000410:	e8 6b 0d 00 00       	call   40001180 <__umoddi3>
40000415:	83 c4 10             	add    $0x10,%esp
40000418:	0f be 80 dc 12 00 40 	movsbl 0x400012dc(%eax),%eax
4000041f:	89 45 08             	mov    %eax,0x8(%ebp)
}
40000422:	8d 65 f4             	lea    -0xc(%ebp),%esp
	putch("0123456789abcdef"[num % base], putdat);
40000425:	89 f8                	mov    %edi,%eax
}
40000427:	5b                   	pop    %ebx
40000428:	5e                   	pop    %esi
40000429:	5f                   	pop    %edi
4000042a:	5d                   	pop    %ebp
	putch("0123456789abcdef"[num % base], putdat);
4000042b:	ff e0                	jmp    *%eax
4000042d:	8d 76 00             	lea    0x0(%esi),%esi
		printnum(putch, putdat, num / base, base, width - 1, padc);
40000430:	83 ec 0c             	sub    $0xc,%esp
40000433:	ff 75 e4             	push   -0x1c(%ebp)
40000436:	53                   	push   %ebx
40000437:	50                   	push   %eax
40000438:	83 ec 08             	sub    $0x8,%esp
4000043b:	ff 75 d4             	push   -0x2c(%ebp)
4000043e:	ff 75 d0             	push   -0x30(%ebp)
40000441:	ff 75 dc             	push   -0x24(%ebp)
40000444:	ff 75 d8             	push   -0x28(%ebp)
40000447:	e8 14 0c 00 00       	call   40001060 <__udivdi3>
4000044c:	83 c4 18             	add    $0x18,%esp
4000044f:	52                   	push   %edx
40000450:	89 f2                	mov    %esi,%edx
40000452:	50                   	push   %eax
40000453:	89 f8                	mov    %edi,%eax
40000455:	e8 46 ff ff ff       	call   400003a0 <printnum>
4000045a:	83 c4 20             	add    $0x20,%esp
4000045d:	eb a2                	jmp    40000401 <printnum+0x61>
4000045f:	90                   	nop

40000460 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
40000460:	55                   	push   %ebp
40000461:	89 e5                	mov    %esp,%ebp
40000463:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
40000466:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
4000046a:	8b 10                	mov    (%eax),%edx
4000046c:	3b 50 04             	cmp    0x4(%eax),%edx
4000046f:	73 0a                	jae    4000047b <sprintputch+0x1b>
		*b->buf++ = ch;
40000471:	8d 4a 01             	lea    0x1(%edx),%ecx
40000474:	89 08                	mov    %ecx,(%eax)
40000476:	8b 45 08             	mov    0x8(%ebp),%eax
40000479:	88 02                	mov    %al,(%edx)
}
4000047b:	5d                   	pop    %ebp
4000047c:	c3                   	ret
4000047d:	8d 76 00             	lea    0x0(%esi),%esi

40000480 <vprintfmt>:
{
40000480:	55                   	push   %ebp
40000481:	89 e5                	mov    %esp,%ebp
40000483:	57                   	push   %edi
40000484:	56                   	push   %esi
40000485:	53                   	push   %ebx
40000486:	83 ec 2c             	sub    $0x2c,%esp
40000489:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000048c:	8b 75 0c             	mov    0xc(%ebp),%esi
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000048f:	8b 45 10             	mov    0x10(%ebp),%eax
40000492:	8d 78 01             	lea    0x1(%eax),%edi
40000495:	0f b6 00             	movzbl (%eax),%eax
40000498:	83 f8 25             	cmp    $0x25,%eax
4000049b:	75 19                	jne    400004b6 <vprintfmt+0x36>
4000049d:	eb 29                	jmp    400004c8 <vprintfmt+0x48>
4000049f:	90                   	nop
			putch(ch, putdat);
400004a0:	83 ec 08             	sub    $0x8,%esp
		while ((ch = *(unsigned char *) fmt++) != '%') {
400004a3:	83 c7 01             	add    $0x1,%edi
			putch(ch, putdat);
400004a6:	56                   	push   %esi
400004a7:	50                   	push   %eax
400004a8:	ff d3                	call   *%ebx
		while ((ch = *(unsigned char *) fmt++) != '%') {
400004aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
400004ae:	83 c4 10             	add    $0x10,%esp
400004b1:	83 f8 25             	cmp    $0x25,%eax
400004b4:	74 12                	je     400004c8 <vprintfmt+0x48>
			if (ch == '\0')
400004b6:	85 c0                	test   %eax,%eax
400004b8:	75 e6                	jne    400004a0 <vprintfmt+0x20>
}
400004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
400004bd:	5b                   	pop    %ebx
400004be:	5e                   	pop    %esi
400004bf:	5f                   	pop    %edi
400004c0:	5d                   	pop    %ebp
400004c1:	c3                   	ret
400004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		padc = ' ';
400004c8:	c6 45 e0 20          	movb   $0x20,-0x20(%ebp)
		precision = -1;
400004cc:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		altflag = 0;
400004d1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		width = -1;
400004d8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		lflag = 0;
400004df:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400004e6:	0f b6 17             	movzbl (%edi),%edx
400004e9:	8d 47 01             	lea    0x1(%edi),%eax
400004ec:	89 45 10             	mov    %eax,0x10(%ebp)
400004ef:	8d 42 dd             	lea    -0x23(%edx),%eax
400004f2:	3c 55                	cmp    $0x55,%al
400004f4:	77 0a                	ja     40000500 <vprintfmt+0x80>
400004f6:	0f b6 c0             	movzbl %al,%eax
400004f9:	ff 24 85 f8 12 00 40 	jmp    *0x400012f8(,%eax,4)
			putch('%', putdat);
40000500:	83 ec 08             	sub    $0x8,%esp
40000503:	56                   	push   %esi
40000504:	6a 25                	push   $0x25
40000506:	ff d3                	call   *%ebx
			for (fmt--; fmt[-1] != '%'; fmt--)
40000508:	83 c4 10             	add    $0x10,%esp
4000050b:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
4000050f:	89 7d 10             	mov    %edi,0x10(%ebp)
40000512:	0f 84 77 ff ff ff    	je     4000048f <vprintfmt+0xf>
40000518:	89 f8                	mov    %edi,%eax
4000051a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000520:	83 e8 01             	sub    $0x1,%eax
40000523:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
40000527:	75 f7                	jne    40000520 <vprintfmt+0xa0>
40000529:	89 45 10             	mov    %eax,0x10(%ebp)
4000052c:	e9 5e ff ff ff       	jmp    4000048f <vprintfmt+0xf>
40000531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				if (ch < '0' || ch > '9')
40000538:	0f be 47 01          	movsbl 0x1(%edi),%eax
				precision = precision * 10 + ch - '0';
4000053c:	8d 4a d0             	lea    -0x30(%edx),%ecx
		switch (ch = *(unsigned char *) fmt++) {
4000053f:	8b 7d 10             	mov    0x10(%ebp),%edi
				if (ch < '0' || ch > '9')
40000542:	8d 50 d0             	lea    -0x30(%eax),%edx
40000545:	83 fa 09             	cmp    $0x9,%edx
40000548:	77 2b                	ja     40000575 <vprintfmt+0xf5>
4000054a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000550:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000557:	00 
40000558:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000055f:	00 
				precision = precision * 10 + ch - '0';
40000560:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
			for (precision = 0; ; ++fmt) {
40000563:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
40000566:	8d 4c 50 d0          	lea    -0x30(%eax,%edx,2),%ecx
				ch = *fmt;
4000056a:	0f be 07             	movsbl (%edi),%eax
				if (ch < '0' || ch > '9')
4000056d:	8d 50 d0             	lea    -0x30(%eax),%edx
40000570:	83 fa 09             	cmp    $0x9,%edx
40000573:	76 eb                	jbe    40000560 <vprintfmt+0xe0>
			if (width < 0)
40000575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000578:	85 c0                	test   %eax,%eax
				width = precision, precision = -1;
4000057a:	0f 48 c1             	cmovs  %ecx,%eax
4000057d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
40000580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000585:	0f 48 c8             	cmovs  %eax,%ecx
40000588:	e9 59 ff ff ff       	jmp    400004e6 <vprintfmt+0x66>
			altflag = 1;
4000058d:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
40000594:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
40000597:	e9 4a ff ff ff       	jmp    400004e6 <vprintfmt+0x66>
			putch(ch, putdat);
4000059c:	83 ec 08             	sub    $0x8,%esp
4000059f:	56                   	push   %esi
400005a0:	6a 25                	push   $0x25
400005a2:	ff d3                	call   *%ebx
			break;
400005a4:	83 c4 10             	add    $0x10,%esp
400005a7:	e9 e3 fe ff ff       	jmp    4000048f <vprintfmt+0xf>
			precision = va_arg(ap, int);
400005ac:	8b 45 14             	mov    0x14(%ebp),%eax
		switch (ch = *(unsigned char *) fmt++) {
400005af:	8b 7d 10             	mov    0x10(%ebp),%edi
			precision = va_arg(ap, int);
400005b2:	8b 08                	mov    (%eax),%ecx
400005b4:	83 c0 04             	add    $0x4,%eax
400005b7:	89 45 14             	mov    %eax,0x14(%ebp)
			goto process_precision;
400005ba:	eb b9                	jmp    40000575 <vprintfmt+0xf5>
			if (width < 0)
400005bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
400005bf:	31 c0                	xor    %eax,%eax
		switch (ch = *(unsigned char *) fmt++) {
400005c1:	8b 7d 10             	mov    0x10(%ebp),%edi
			if (width < 0)
400005c4:	85 d2                	test   %edx,%edx
400005c6:	0f 49 c2             	cmovns %edx,%eax
400005c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			goto reswitch;
400005cc:	e9 15 ff ff ff       	jmp    400004e6 <vprintfmt+0x66>
			putch(va_arg(ap, int), putdat);
400005d1:	83 ec 08             	sub    $0x8,%esp
400005d4:	56                   	push   %esi
400005d5:	8b 45 14             	mov    0x14(%ebp),%eax
400005d8:	ff 30                	push   (%eax)
400005da:	ff d3                	call   *%ebx
400005dc:	8b 45 14             	mov    0x14(%ebp),%eax
400005df:	83 c0 04             	add    $0x4,%eax
			break;
400005e2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
400005e5:	89 45 14             	mov    %eax,0x14(%ebp)
			break;
400005e8:	e9 a2 fe ff ff       	jmp    4000048f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
400005ed:	8b 45 14             	mov    0x14(%ebp),%eax
400005f0:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
400005f2:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
400005f6:	0f 8f af 01 00 00    	jg     400007ab <vprintfmt+0x32b>
		return va_arg(*ap, unsigned long);
400005fc:	83 c0 04             	add    $0x4,%eax
400005ff:	31 c9                	xor    %ecx,%ecx
40000601:	bf 0a 00 00 00       	mov    $0xa,%edi
40000606:	89 45 14             	mov    %eax,0x14(%ebp)
40000609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			printnum(putch, putdat, num, base, width, padc);
40000610:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
40000614:	83 ec 0c             	sub    $0xc,%esp
40000617:	50                   	push   %eax
40000618:	89 d8                	mov    %ebx,%eax
4000061a:	ff 75 e4             	push   -0x1c(%ebp)
4000061d:	57                   	push   %edi
4000061e:	51                   	push   %ecx
4000061f:	52                   	push   %edx
40000620:	89 f2                	mov    %esi,%edx
40000622:	e8 79 fd ff ff       	call   400003a0 <printnum>
			break;
40000627:	83 c4 20             	add    $0x20,%esp
4000062a:	e9 60 fe ff ff       	jmp    4000048f <vprintfmt+0xf>
			putch('0', putdat);
4000062f:	83 ec 08             	sub    $0x8,%esp
			goto number;
40000632:	bf 10 00 00 00       	mov    $0x10,%edi
			putch('0', putdat);
40000637:	56                   	push   %esi
40000638:	6a 30                	push   $0x30
4000063a:	ff d3                	call   *%ebx
			putch('x', putdat);
4000063c:	58                   	pop    %eax
4000063d:	5a                   	pop    %edx
4000063e:	56                   	push   %esi
4000063f:	6a 78                	push   $0x78
40000641:	ff d3                	call   *%ebx
			num = (unsigned long long)
40000643:	8b 45 14             	mov    0x14(%ebp),%eax
40000646:	31 c9                	xor    %ecx,%ecx
40000648:	8b 10                	mov    (%eax),%edx
				(uintptr_t) va_arg(ap, void *);
4000064a:	83 c0 04             	add    $0x4,%eax
			goto number;
4000064d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
40000650:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;
40000653:	eb bb                	jmp    40000610 <vprintfmt+0x190>
		return va_arg(*ap, unsigned long long);
40000655:	8b 45 14             	mov    0x14(%ebp),%eax
40000658:	8b 10                	mov    (%eax),%edx
	if (lflag >= 2)
4000065a:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
4000065e:	0f 8f 5a 01 00 00    	jg     400007be <vprintfmt+0x33e>
		return va_arg(*ap, unsigned long);
40000664:	83 c0 04             	add    $0x4,%eax
40000667:	31 c9                	xor    %ecx,%ecx
40000669:	bf 10 00 00 00       	mov    $0x10,%edi
4000066e:	89 45 14             	mov    %eax,0x14(%ebp)
40000671:	eb 9d                	jmp    40000610 <vprintfmt+0x190>
		return va_arg(*ap, long long);
40000673:	8b 45 14             	mov    0x14(%ebp),%eax
	if (lflag >= 2)
40000676:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
4000067a:	0f 8f 51 01 00 00    	jg     400007d1 <vprintfmt+0x351>
		return va_arg(*ap, long);
40000680:	8b 4d 14             	mov    0x14(%ebp),%ecx
40000683:	8b 00                	mov    (%eax),%eax
40000685:	83 c1 04             	add    $0x4,%ecx
40000688:	99                   	cltd
40000689:	89 4d 14             	mov    %ecx,0x14(%ebp)
			if ((long long) num < 0) {
4000068c:	85 d2                	test   %edx,%edx
4000068e:	0f 88 68 01 00 00    	js     400007fc <vprintfmt+0x37c>
			num = getint(&ap, lflag);
40000694:	89 d1                	mov    %edx,%ecx
40000696:	bf 0a 00 00 00       	mov    $0xa,%edi
4000069b:	89 c2                	mov    %eax,%edx
4000069d:	e9 6e ff ff ff       	jmp    40000610 <vprintfmt+0x190>
			lflag++;
400006a2:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400006a6:	8b 7d 10             	mov    0x10(%ebp),%edi
			goto reswitch;
400006a9:	e9 38 fe ff ff       	jmp    400004e6 <vprintfmt+0x66>
			putch('X', putdat);
400006ae:	83 ec 08             	sub    $0x8,%esp
400006b1:	56                   	push   %esi
400006b2:	6a 58                	push   $0x58
400006b4:	ff d3                	call   *%ebx
			putch('X', putdat);
400006b6:	59                   	pop    %ecx
400006b7:	5f                   	pop    %edi
400006b8:	56                   	push   %esi
400006b9:	6a 58                	push   $0x58
400006bb:	ff d3                	call   *%ebx
			putch('X', putdat);
400006bd:	58                   	pop    %eax
400006be:	5a                   	pop    %edx
400006bf:	56                   	push   %esi
400006c0:	6a 58                	push   $0x58
400006c2:	ff d3                	call   *%ebx
			break;
400006c4:	83 c4 10             	add    $0x10,%esp
400006c7:	e9 c3 fd ff ff       	jmp    4000048f <vprintfmt+0xf>
			if ((p = va_arg(ap, char *)) == NULL)
400006cc:	8b 45 14             	mov    0x14(%ebp),%eax
400006cf:	83 c0 04             	add    $0x4,%eax
400006d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
400006d5:	8b 45 14             	mov    0x14(%ebp),%eax
400006d8:	8b 38                	mov    (%eax),%edi
			if (width > 0 && padc != '-')
400006da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400006dd:	85 c0                	test   %eax,%eax
400006df:	0f 9f c0             	setg   %al
400006e2:	80 7d e0 2d          	cmpb   $0x2d,-0x20(%ebp)
400006e6:	0f 95 c2             	setne  %dl
400006e9:	21 d0                	and    %edx,%eax
			if ((p = va_arg(ap, char *)) == NULL)
400006eb:	85 ff                	test   %edi,%edi
400006ed:	0f 84 32 01 00 00    	je     40000825 <vprintfmt+0x3a5>
			if (width > 0 && padc != '-')
400006f3:	84 c0                	test   %al,%al
400006f5:	0f 85 4d 01 00 00    	jne    40000848 <vprintfmt+0x3c8>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400006fb:	0f be 07             	movsbl (%edi),%eax
400006fe:	89 c2                	mov    %eax,%edx
40000700:	85 c0                	test   %eax,%eax
40000702:	74 7b                	je     4000077f <vprintfmt+0x2ff>
40000704:	89 5d 08             	mov    %ebx,0x8(%ebp)
40000707:	83 c7 01             	add    $0x1,%edi
4000070a:	89 cb                	mov    %ecx,%ebx
4000070c:	89 75 0c             	mov    %esi,0xc(%ebp)
4000070f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
40000712:	eb 21                	jmp    40000735 <vprintfmt+0x2b5>
40000714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
					putch(ch, putdat);
40000718:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000071b:	83 c7 01             	add    $0x1,%edi
					putch(ch, putdat);
4000071e:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000721:	83 ee 01             	sub    $0x1,%esi
					putch(ch, putdat);
40000724:	50                   	push   %eax
40000725:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000728:	0f be 47 ff          	movsbl -0x1(%edi),%eax
4000072c:	83 c4 10             	add    $0x10,%esp
4000072f:	89 c2                	mov    %eax,%edx
40000731:	85 c0                	test   %eax,%eax
40000733:	74 41                	je     40000776 <vprintfmt+0x2f6>
40000735:	85 db                	test   %ebx,%ebx
40000737:	78 05                	js     4000073e <vprintfmt+0x2be>
40000739:	83 eb 01             	sub    $0x1,%ebx
4000073c:	72 38                	jb     40000776 <vprintfmt+0x2f6>
				if (altflag && (ch < ' ' || ch > '~'))
4000073e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
40000741:	85 c9                	test   %ecx,%ecx
40000743:	74 d3                	je     40000718 <vprintfmt+0x298>
40000745:	0f be ca             	movsbl %dl,%ecx
40000748:	83 e9 20             	sub    $0x20,%ecx
4000074b:	83 f9 5e             	cmp    $0x5e,%ecx
4000074e:	76 c8                	jbe    40000718 <vprintfmt+0x298>
					putch('?', putdat);
40000750:	83 ec 08             	sub    $0x8,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000753:	83 c7 01             	add    $0x1,%edi
					putch('?', putdat);
40000756:	ff 75 0c             	push   0xc(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000759:	83 ee 01             	sub    $0x1,%esi
					putch('?', putdat);
4000075c:	6a 3f                	push   $0x3f
4000075e:	ff 55 08             	call   *0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000761:	0f be 4f ff          	movsbl -0x1(%edi),%ecx
40000765:	83 c4 10             	add    $0x10,%esp
40000768:	89 ca                	mov    %ecx,%edx
4000076a:	89 c8                	mov    %ecx,%eax
4000076c:	85 c9                	test   %ecx,%ecx
4000076e:	74 06                	je     40000776 <vprintfmt+0x2f6>
40000770:	85 db                	test   %ebx,%ebx
40000772:	79 c5                	jns    40000739 <vprintfmt+0x2b9>
40000774:	eb d2                	jmp    40000748 <vprintfmt+0x2c8>
40000776:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40000779:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000077c:	8b 75 0c             	mov    0xc(%ebp),%esi
			for (; width > 0; width--)
4000077f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40000782:	85 c0                	test   %eax,%eax
40000784:	7e 1a                	jle    400007a0 <vprintfmt+0x320>
40000786:	89 c7                	mov    %eax,%edi
40000788:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000078f:	00 
				putch(' ', putdat);
40000790:	83 ec 08             	sub    $0x8,%esp
40000793:	56                   	push   %esi
40000794:	6a 20                	push   $0x20
40000796:	ff d3                	call   *%ebx
			for (; width > 0; width--)
40000798:	83 c4 10             	add    $0x10,%esp
4000079b:	83 ef 01             	sub    $0x1,%edi
4000079e:	75 f0                	jne    40000790 <vprintfmt+0x310>
			if ((p = va_arg(ap, char *)) == NULL)
400007a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
400007a3:	89 45 14             	mov    %eax,0x14(%ebp)
400007a6:	e9 e4 fc ff ff       	jmp    4000048f <vprintfmt+0xf>
		return va_arg(*ap, unsigned long long);
400007ab:	8b 48 04             	mov    0x4(%eax),%ecx
400007ae:	83 c0 08             	add    $0x8,%eax
400007b1:	bf 0a 00 00 00       	mov    $0xa,%edi
400007b6:	89 45 14             	mov    %eax,0x14(%ebp)
400007b9:	e9 52 fe ff ff       	jmp    40000610 <vprintfmt+0x190>
400007be:	8b 48 04             	mov    0x4(%eax),%ecx
400007c1:	83 c0 08             	add    $0x8,%eax
400007c4:	bf 10 00 00 00       	mov    $0x10,%edi
400007c9:	89 45 14             	mov    %eax,0x14(%ebp)
400007cc:	e9 3f fe ff ff       	jmp    40000610 <vprintfmt+0x190>
		return va_arg(*ap, long long);
400007d1:	8b 4d 14             	mov    0x14(%ebp),%ecx
400007d4:	8b 50 04             	mov    0x4(%eax),%edx
400007d7:	8b 00                	mov    (%eax),%eax
400007d9:	83 c1 08             	add    $0x8,%ecx
400007dc:	89 4d 14             	mov    %ecx,0x14(%ebp)
400007df:	e9 a8 fe ff ff       	jmp    4000068c <vprintfmt+0x20c>
		switch (ch = *(unsigned char *) fmt++) {
400007e4:	c6 45 e0 30          	movb   $0x30,-0x20(%ebp)
400007e8:	8b 7d 10             	mov    0x10(%ebp),%edi
400007eb:	e9 f6 fc ff ff       	jmp    400004e6 <vprintfmt+0x66>
			padc = '-';
400007f0:	c6 45 e0 2d          	movb   $0x2d,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
400007f4:	8b 7d 10             	mov    0x10(%ebp),%edi
400007f7:	e9 ea fc ff ff       	jmp    400004e6 <vprintfmt+0x66>
				putch('-', putdat);
400007fc:	83 ec 08             	sub    $0x8,%esp
400007ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
				num = -(long long) num;
40000802:	bf 0a 00 00 00       	mov    $0xa,%edi
40000807:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch('-', putdat);
4000080a:	56                   	push   %esi
4000080b:	6a 2d                	push   $0x2d
4000080d:	ff d3                	call   *%ebx
				num = -(long long) num;
4000080f:	8b 45 d8             	mov    -0x28(%ebp),%eax
40000812:	31 d2                	xor    %edx,%edx
40000814:	f7 d8                	neg    %eax
40000816:	1b 55 dc             	sbb    -0x24(%ebp),%edx
40000819:	83 c4 10             	add    $0x10,%esp
4000081c:	89 d1                	mov    %edx,%ecx
4000081e:	89 c2                	mov    %eax,%edx
40000820:	e9 eb fd ff ff       	jmp    40000610 <vprintfmt+0x190>
			if (width > 0 && padc != '-')
40000825:	84 c0                	test   %al,%al
40000827:	75 78                	jne    400008a1 <vprintfmt+0x421>
40000829:	89 5d 08             	mov    %ebx,0x8(%ebp)
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000082c:	bf ee 12 00 40       	mov    $0x400012ee,%edi
40000831:	ba 28 00 00 00       	mov    $0x28,%edx
40000836:	89 cb                	mov    %ecx,%ebx
40000838:	89 75 0c             	mov    %esi,0xc(%ebp)
4000083b:	b8 28 00 00 00       	mov    $0x28,%eax
40000840:	8b 75 e4             	mov    -0x1c(%ebp),%esi
40000843:	e9 ed fe ff ff       	jmp    40000735 <vprintfmt+0x2b5>
				for (width -= strnlen(p, precision); width > 0; width--)
40000848:	83 ec 08             	sub    $0x8,%esp
4000084b:	51                   	push   %ecx
4000084c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
4000084f:	57                   	push   %edi
40000850:	e8 eb 02 00 00       	call   40000b40 <strnlen>
40000855:	29 45 e4             	sub    %eax,-0x1c(%ebp)
40000858:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
4000085b:	83 c4 10             	add    $0x10,%esp
4000085e:	85 c9                	test   %ecx,%ecx
40000860:	8b 4d d0             	mov    -0x30(%ebp),%ecx
40000863:	7e 71                	jle    400008d6 <vprintfmt+0x456>
					putch(padc, putdat);
40000865:	0f be 45 e0          	movsbl -0x20(%ebp),%eax
40000869:	89 4d cc             	mov    %ecx,-0x34(%ebp)
4000086c:	89 7d d0             	mov    %edi,-0x30(%ebp)
4000086f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
40000872:	89 45 e0             	mov    %eax,-0x20(%ebp)
40000875:	83 ec 08             	sub    $0x8,%esp
40000878:	56                   	push   %esi
40000879:	ff 75 e0             	push   -0x20(%ebp)
4000087c:	ff d3                	call   *%ebx
				for (width -= strnlen(p, precision); width > 0; width--)
4000087e:	83 c4 10             	add    $0x10,%esp
40000881:	83 ef 01             	sub    $0x1,%edi
40000884:	75 ef                	jne    40000875 <vprintfmt+0x3f5>
40000886:	89 7d e4             	mov    %edi,-0x1c(%ebp)
40000889:	8b 7d d0             	mov    -0x30(%ebp),%edi
4000088c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
4000088f:	0f be 07             	movsbl (%edi),%eax
40000892:	89 c2                	mov    %eax,%edx
40000894:	85 c0                	test   %eax,%eax
40000896:	0f 85 68 fe ff ff    	jne    40000704 <vprintfmt+0x284>
4000089c:	e9 ff fe ff ff       	jmp    400007a0 <vprintfmt+0x320>
				for (width -= strnlen(p, precision); width > 0; width--)
400008a1:	83 ec 08             	sub    $0x8,%esp
				p = "(null)";
400008a4:	bf ed 12 00 40       	mov    $0x400012ed,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
400008a9:	51                   	push   %ecx
400008aa:	89 4d d0             	mov    %ecx,-0x30(%ebp)
400008ad:	68 ed 12 00 40       	push   $0x400012ed
400008b2:	e8 89 02 00 00       	call   40000b40 <strnlen>
400008b7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
400008ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
400008bd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400008c0:	ba 28 00 00 00       	mov    $0x28,%edx
400008c5:	b8 28 00 00 00       	mov    $0x28,%eax
				for (width -= strnlen(p, precision); width > 0; width--)
400008ca:	85 c9                	test   %ecx,%ecx
400008cc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
400008cf:	7f 94                	jg     40000865 <vprintfmt+0x3e5>
400008d1:	e9 2e fe ff ff       	jmp    40000704 <vprintfmt+0x284>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400008d6:	0f be 07             	movsbl (%edi),%eax
400008d9:	89 c2                	mov    %eax,%edx
400008db:	85 c0                	test   %eax,%eax
400008dd:	0f 85 21 fe ff ff    	jne    40000704 <vprintfmt+0x284>
400008e3:	e9 b8 fe ff ff       	jmp    400007a0 <vprintfmt+0x320>
400008e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400008ef:	00 

400008f0 <printfmt>:
{
400008f0:	55                   	push   %ebp
400008f1:	89 e5                	mov    %esp,%ebp
400008f3:	83 ec 08             	sub    $0x8,%esp
	vprintfmt(putch, putdat, fmt, ap);
400008f6:	8d 45 14             	lea    0x14(%ebp),%eax
400008f9:	50                   	push   %eax
400008fa:	ff 75 10             	push   0x10(%ebp)
400008fd:	ff 75 0c             	push   0xc(%ebp)
40000900:	ff 75 08             	push   0x8(%ebp)
40000903:	e8 78 fb ff ff       	call   40000480 <vprintfmt>
}
40000908:	83 c4 10             	add    $0x10,%esp
4000090b:	c9                   	leave
4000090c:	c3                   	ret
4000090d:	8d 76 00             	lea    0x0(%esi),%esi

40000910 <vsprintf>:

int
vsprintf(char *buf, const char *fmt, va_list ap)
{
40000910:	55                   	push   %ebp
40000911:	89 e5                	mov    %esp,%ebp
40000913:	83 ec 18             	sub    $0x18,%esp
	//assert(buf != NULL);
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
40000916:	8b 45 08             	mov    0x8(%ebp),%eax

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000919:	ff 75 10             	push   0x10(%ebp)
4000091c:	ff 75 0c             	push   0xc(%ebp)
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
4000091f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000922:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000925:	50                   	push   %eax
40000926:	68 60 04 00 40       	push   $0x40000460
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
4000092b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
40000932:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000939:	e8 42 fb ff ff       	call   40000480 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
4000093e:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000941:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000944:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000947:	c9                   	leave
40000948:	c3                   	ret
40000949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000950 <sprintf>:

int
sprintf(char *buf, const char *fmt, ...)
{
40000950:	55                   	push   %ebp
40000951:	89 e5                	mov    %esp,%ebp
40000953:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
40000956:	8b 45 08             	mov    0x8(%ebp),%eax
40000959:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
40000960:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
40000967:	89 45 ec             	mov    %eax,-0x14(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000096a:	8d 45 10             	lea    0x10(%ebp),%eax
4000096d:	50                   	push   %eax
4000096e:	8d 45 ec             	lea    -0x14(%ebp),%eax
40000971:	ff 75 0c             	push   0xc(%ebp)
40000974:	50                   	push   %eax
40000975:	68 60 04 00 40       	push   $0x40000460
4000097a:	e8 01 fb ff ff       	call   40000480 <vprintfmt>
	*b.buf = '\0';
4000097f:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000982:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsprintf(buf, fmt, ap);
	va_end(ap);

	return rc;
}
40000985:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000988:	c9                   	leave
40000989:	c3                   	ret
4000098a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000990 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
40000990:	55                   	push   %ebp
40000991:	89 e5                	mov    %esp,%ebp
40000993:	83 ec 18             	sub    $0x18,%esp
40000996:	8b 45 08             	mov    0x8(%ebp),%eax
	//assert(buf != NULL && n > 0);
	struct sprintbuf b = {buf, buf+n-1, 0};
40000999:	8b 55 0c             	mov    0xc(%ebp),%edx

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000099c:	ff 75 14             	push   0x14(%ebp)
4000099f:	ff 75 10             	push   0x10(%ebp)
	struct sprintbuf b = {buf, buf+n-1, 0};
400009a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
400009a5:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
400009a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400009ac:	8d 45 ec             	lea    -0x14(%ebp),%eax
400009af:	50                   	push   %eax
400009b0:	68 60 04 00 40       	push   $0x40000460
	struct sprintbuf b = {buf, buf+n-1, 0};
400009b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400009bc:	e8 bf fa ff ff       	call   40000480 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
400009c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
400009c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
400009c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
400009ca:	c9                   	leave
400009cb:	c3                   	ret
400009cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

400009d0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
400009d0:	55                   	push   %ebp
400009d1:	89 e5                	mov    %esp,%ebp
400009d3:	83 ec 18             	sub    $0x18,%esp
400009d6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct sprintbuf b = {buf, buf+n-1, 0};
400009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
400009dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
400009e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
400009e6:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
400009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400009ed:	8d 45 14             	lea    0x14(%ebp),%eax
400009f0:	50                   	push   %eax
400009f1:	8d 45 ec             	lea    -0x14(%ebp),%eax
400009f4:	ff 75 10             	push   0x10(%ebp)
400009f7:	50                   	push   %eax
400009f8:	68 60 04 00 40       	push   $0x40000460
400009fd:	e8 7e fa ff ff       	call   40000480 <vprintfmt>
	*b.buf = '\0';
40000a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
40000a05:	c6 00 00             	movb   $0x0,(%eax)
	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
	va_end(ap);

	return rc;
}
40000a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
40000a0b:	c9                   	leave
40000a0c:	c3                   	ret
40000a0d:	66 90                	xchg   %ax,%ax
40000a0f:	90                   	nop

40000a10 <spawn>:
#include <syscall.h>
#include <types.h>

pid_t
spawn(uintptr_t exec, unsigned int quota)
{
40000a10:	55                   	push   %ebp
	asm volatile("int %2"
40000a11:	ba ff ff ff ff       	mov    $0xffffffff,%edx
40000a16:	b8 01 00 00 00       	mov    $0x1,%eax
40000a1b:	89 e5                	mov    %esp,%ebp
40000a1d:	56                   	push   %esi
40000a1e:	89 d6                	mov    %edx,%esi
40000a20:	53                   	push   %ebx
40000a21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000a24:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000a27:	cd 30                	int    $0x30
	return errno ? -1 : pid;
40000a29:	85 c0                	test   %eax,%eax
40000a2b:	75 0b                	jne    40000a38 <spawn+0x28>
40000a2d:	89 da                	mov    %ebx,%edx
	// Default: inherit console stdin/stdout
	return sys_spawn(exec, quota, -1, -1);
}
40000a2f:	5b                   	pop    %ebx
40000a30:	89 d0                	mov    %edx,%eax
40000a32:	5e                   	pop    %esi
40000a33:	5d                   	pop    %ebp
40000a34:	c3                   	ret
40000a35:	8d 76 00             	lea    0x0(%esi),%esi
40000a38:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, -1, -1);
40000a3d:	eb f0                	jmp    40000a2f <spawn+0x1f>
40000a3f:	90                   	nop

40000a40 <spawn_with_fds>:

pid_t
spawn_with_fds(uintptr_t exec, unsigned int quota, int stdin_fd, int stdout_fd)
{
40000a40:	55                   	push   %ebp
	asm volatile("int %2"
40000a41:	b8 01 00 00 00       	mov    $0x1,%eax
40000a46:	89 e5                	mov    %esp,%ebp
40000a48:	56                   	push   %esi
40000a49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000a4c:	8b 55 10             	mov    0x10(%ebp),%edx
40000a4f:	53                   	push   %ebx
40000a50:	8b 75 14             	mov    0x14(%ebp),%esi
40000a53:	8b 5d 08             	mov    0x8(%ebp),%ebx
40000a56:	cd 30                	int    $0x30
	return errno ? -1 : pid;
40000a58:	85 c0                	test   %eax,%eax
40000a5a:	75 0c                	jne    40000a68 <spawn_with_fds+0x28>
40000a5c:	89 da                	mov    %ebx,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
}
40000a5e:	5b                   	pop    %ebx
40000a5f:	89 d0                	mov    %edx,%eax
40000a61:	5e                   	pop    %esi
40000a62:	5d                   	pop    %ebp
40000a63:	c3                   	ret
40000a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000a68:	ba ff ff ff ff       	mov    $0xffffffff,%edx
	return sys_spawn(exec, quota, stdin_fd, stdout_fd);
40000a6d:	eb ef                	jmp    40000a5e <spawn_with_fds+0x1e>
40000a6f:	90                   	nop

40000a70 <yield>:
	asm volatile("int %0" :
40000a70:	b8 02 00 00 00       	mov    $0x2,%eax
40000a75:	cd 30                	int    $0x30

void
yield(void)
{
	sys_yield();
}
40000a77:	c3                   	ret
40000a78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a7f:	00 

40000a80 <produce>:
	asm volatile("int %0" :
40000a80:	b8 03 00 00 00       	mov    $0x3,%eax
40000a85:	cd 30                	int    $0x30

void
produce(void)
{
	sys_produce();
}
40000a87:	c3                   	ret
40000a88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a8f:	00 

40000a90 <consume>:
	asm volatile("int %0" :
40000a90:	b8 04 00 00 00       	mov    $0x4,%eax
40000a95:	cd 30                	int    $0x30

void
consume(void)
{
	sys_consume();
}
40000a97:	c3                   	ret
40000a98:	66 90                	xchg   %ax,%ax
40000a9a:	66 90                	xchg   %ax,%ax
40000a9c:	66 90                	xchg   %ax,%ax
40000a9e:	66 90                	xchg   %ax,%ax

40000aa0 <spinlock_init>:
	return result;
}

void
spinlock_init(spinlock_t *lk)
{
40000aa0:	55                   	push   %ebp
40000aa1:	89 e5                	mov    %esp,%ebp
	*lk = 0;
40000aa3:	8b 45 08             	mov    0x8(%ebp),%eax
40000aa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
40000aac:	5d                   	pop    %ebp
40000aad:	c3                   	ret
40000aae:	66 90                	xchg   %ax,%ax

40000ab0 <spinlock_acquire>:

void
spinlock_acquire(spinlock_t *lk)
{
40000ab0:	55                   	push   %ebp
	asm volatile("lock; xchgl %0, %1" :
40000ab1:	b8 01 00 00 00       	mov    $0x1,%eax
{
40000ab6:	89 e5                	mov    %esp,%ebp
40000ab8:	8b 55 08             	mov    0x8(%ebp),%edx
	asm volatile("lock; xchgl %0, %1" :
40000abb:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000abe:	85 c0                	test   %eax,%eax
40000ac0:	74 1c                	je     40000ade <spinlock_acquire+0x2e>
40000ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000ac8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000acf:	00 
		asm volatile("pause");
40000ad0:	f3 90                	pause
	asm volatile("lock; xchgl %0, %1" :
40000ad2:	b8 01 00 00 00       	mov    $0x1,%eax
40000ad7:	f0 87 02             	lock xchg %eax,(%edx)
	while(xchg(lk, 1) != 0)
40000ada:	85 c0                	test   %eax,%eax
40000adc:	75 f2                	jne    40000ad0 <spinlock_acquire+0x20>
}
40000ade:	5d                   	pop    %ebp
40000adf:	c3                   	ret

40000ae0 <spinlock_release>:

// Release the lock.
void
spinlock_release(spinlock_t *lk)
{
40000ae0:	55                   	push   %ebp
40000ae1:	89 e5                	mov    %esp,%ebp
40000ae3:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
bool
spinlock_holding(spinlock_t *lock)
{
	return *lock;
40000ae6:	8b 02                	mov    (%edx),%eax
	if (spinlock_holding(lk) == FALSE)
40000ae8:	84 c0                	test   %al,%al
40000aea:	74 05                	je     40000af1 <spinlock_release+0x11>
	asm volatile("lock; xchgl %0, %1" :
40000aec:	31 c0                	xor    %eax,%eax
40000aee:	f0 87 02             	lock xchg %eax,(%edx)
}
40000af1:	5d                   	pop    %ebp
40000af2:	c3                   	ret
40000af3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000af8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000aff:	00 

40000b00 <spinlock_holding>:
{
40000b00:	55                   	push   %ebp
40000b01:	89 e5                	mov    %esp,%ebp
	return *lock;
40000b03:	8b 45 08             	mov    0x8(%ebp),%eax
}
40000b06:	5d                   	pop    %ebp
	return *lock;
40000b07:	8b 00                	mov    (%eax),%eax
}
40000b09:	c3                   	ret
40000b0a:	66 90                	xchg   %ax,%ax
40000b0c:	66 90                	xchg   %ax,%ax
40000b0e:	66 90                	xchg   %ax,%ax
40000b10:	66 90                	xchg   %ax,%ax
40000b12:	66 90                	xchg   %ax,%ax
40000b14:	66 90                	xchg   %ax,%ax
40000b16:	66 90                	xchg   %ax,%ax
40000b18:	66 90                	xchg   %ax,%ax
40000b1a:	66 90                	xchg   %ax,%ax
40000b1c:	66 90                	xchg   %ax,%ax
40000b1e:	66 90                	xchg   %ax,%ax

40000b20 <strlen>:
#include <string.h>
#include <types.h>

int
strlen(const char *s)
{
40000b20:	55                   	push   %ebp
	int n;

	for (n = 0; *s != '\0'; s++)
40000b21:	31 c0                	xor    %eax,%eax
{
40000b23:	89 e5                	mov    %esp,%ebp
40000b25:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; *s != '\0'; s++)
40000b28:	80 3a 00             	cmpb   $0x0,(%edx)
40000b2b:	74 0c                	je     40000b39 <strlen+0x19>
40000b2d:	8d 76 00             	lea    0x0(%esi),%esi
		n++;
40000b30:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
40000b33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
40000b37:	75 f7                	jne    40000b30 <strlen+0x10>
	return n;
}
40000b39:	5d                   	pop    %ebp
40000b3a:	c3                   	ret
40000b3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

40000b40 <strnlen>:

int
strnlen(const char *s, size_t size)
{
40000b40:	55                   	push   %ebp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000b41:	31 c0                	xor    %eax,%eax
{
40000b43:	89 e5                	mov    %esp,%ebp
40000b45:	8b 55 0c             	mov    0xc(%ebp),%edx
40000b48:	8b 4d 08             	mov    0x8(%ebp),%ecx
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000b4b:	85 d2                	test   %edx,%edx
40000b4d:	75 18                	jne    40000b67 <strnlen+0x27>
40000b4f:	eb 1c                	jmp    40000b6d <strnlen+0x2d>
40000b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b5f:	00 
		n++;
40000b60:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000b63:	39 c2                	cmp    %eax,%edx
40000b65:	74 06                	je     40000b6d <strnlen+0x2d>
40000b67:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
40000b6b:	75 f3                	jne    40000b60 <strnlen+0x20>
	return n;
}
40000b6d:	5d                   	pop    %ebp
40000b6e:	c3                   	ret
40000b6f:	90                   	nop

40000b70 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
40000b70:	55                   	push   %ebp
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
40000b71:	31 c0                	xor    %eax,%eax
{
40000b73:	89 e5                	mov    %esp,%ebp
40000b75:	53                   	push   %ebx
40000b76:	8b 4d 08             	mov    0x8(%ebp),%ecx
40000b79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while ((*dst++ = *src++) != '\0')
40000b80:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000b84:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000b87:	83 c0 01             	add    $0x1,%eax
40000b8a:	84 d2                	test   %dl,%dl
40000b8c:	75 f2                	jne    40000b80 <strcpy+0x10>
		/* do nothing */;
	return ret;
}
40000b8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000b91:	89 c8                	mov    %ecx,%eax
40000b93:	c9                   	leave
40000b94:	c3                   	ret
40000b95:	8d 76 00             	lea    0x0(%esi),%esi
40000b98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000b9f:	00 

40000ba0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size)
{
40000ba0:	55                   	push   %ebp
40000ba1:	89 e5                	mov    %esp,%ebp
40000ba3:	56                   	push   %esi
40000ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
40000ba7:	8b 75 08             	mov    0x8(%ebp),%esi
40000baa:	53                   	push   %ebx
40000bab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
40000bae:	85 db                	test   %ebx,%ebx
40000bb0:	74 21                	je     40000bd3 <strncpy+0x33>
40000bb2:	01 f3                	add    %esi,%ebx
40000bb4:	89 f0                	mov    %esi,%eax
40000bb6:	66 90                	xchg   %ax,%ax
40000bb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000bbf:	00 
		*dst++ = *src;
40000bc0:	0f b6 0a             	movzbl (%edx),%ecx
40000bc3:	83 c0 01             	add    $0x1,%eax
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
40000bc6:	80 f9 01             	cmp    $0x1,%cl
		*dst++ = *src;
40000bc9:	88 48 ff             	mov    %cl,-0x1(%eax)
			src++;
40000bcc:	83 da ff             	sbb    $0xffffffff,%edx
	for (i = 0; i < size; i++) {
40000bcf:	39 c3                	cmp    %eax,%ebx
40000bd1:	75 ed                	jne    40000bc0 <strncpy+0x20>
	}
	return ret;
}
40000bd3:	89 f0                	mov    %esi,%eax
40000bd5:	5b                   	pop    %ebx
40000bd6:	5e                   	pop    %esi
40000bd7:	5d                   	pop    %ebp
40000bd8:	c3                   	ret
40000bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000be0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
40000be0:	55                   	push   %ebp
40000be1:	89 e5                	mov    %esp,%ebp
40000be3:	53                   	push   %ebx
40000be4:	8b 45 10             	mov    0x10(%ebp),%eax
40000be7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
40000bea:	85 c0                	test   %eax,%eax
40000bec:	74 2e                	je     40000c1c <strlcpy+0x3c>
		while (--size > 0 && *src != '\0')
40000bee:	8b 55 08             	mov    0x8(%ebp),%edx
40000bf1:	83 e8 01             	sub    $0x1,%eax
40000bf4:	74 23                	je     40000c19 <strlcpy+0x39>
40000bf6:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
40000bf9:	eb 12                	jmp    40000c0d <strlcpy+0x2d>
40000bfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
			*dst++ = *src++;
40000c00:	83 c2 01             	add    $0x1,%edx
40000c03:	83 c1 01             	add    $0x1,%ecx
40000c06:	88 42 ff             	mov    %al,-0x1(%edx)
		while (--size > 0 && *src != '\0')
40000c09:	39 da                	cmp    %ebx,%edx
40000c0b:	74 07                	je     40000c14 <strlcpy+0x34>
40000c0d:	0f b6 01             	movzbl (%ecx),%eax
40000c10:	84 c0                	test   %al,%al
40000c12:	75 ec                	jne    40000c00 <strlcpy+0x20>
		*dst = '\0';
	}
	return dst - dst_in;
40000c14:	89 d0                	mov    %edx,%eax
40000c16:	2b 45 08             	sub    0x8(%ebp),%eax
		*dst = '\0';
40000c19:	c6 02 00             	movb   $0x0,(%edx)
}
40000c1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c1f:	c9                   	leave
40000c20:	c3                   	ret
40000c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c2f:	00 

40000c30 <strcmp>:

int
strcmp(const char *p, const char *q)
{
40000c30:	55                   	push   %ebp
40000c31:	89 e5                	mov    %esp,%ebp
40000c33:	53                   	push   %ebx
40000c34:	8b 55 08             	mov    0x8(%ebp),%edx
40000c37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
40000c3a:	0f b6 02             	movzbl (%edx),%eax
40000c3d:	84 c0                	test   %al,%al
40000c3f:	75 2d                	jne    40000c6e <strcmp+0x3e>
40000c41:	eb 4a                	jmp    40000c8d <strcmp+0x5d>
40000c43:	eb 1b                	jmp    40000c60 <strcmp+0x30>
40000c45:	8d 76 00             	lea    0x0(%esi),%esi
40000c48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c4f:	00 
40000c50:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c57:	00 
40000c58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c5f:	00 
40000c60:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		p++, q++;
40000c64:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
40000c67:	84 c0                	test   %al,%al
40000c69:	74 15                	je     40000c80 <strcmp+0x50>
40000c6b:	83 c1 01             	add    $0x1,%ecx
40000c6e:	0f b6 19             	movzbl (%ecx),%ebx
40000c71:	38 c3                	cmp    %al,%bl
40000c73:	74 eb                	je     40000c60 <strcmp+0x30>
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c75:	29 d8                	sub    %ebx,%eax
}
40000c77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c7a:	c9                   	leave
40000c7b:	c3                   	ret
40000c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c80:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
40000c84:	31 c0                	xor    %eax,%eax
40000c86:	29 d8                	sub    %ebx,%eax
}
40000c88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000c8b:	c9                   	leave
40000c8c:	c3                   	ret
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000c8d:	0f b6 19             	movzbl (%ecx),%ebx
40000c90:	31 c0                	xor    %eax,%eax
40000c92:	eb e1                	jmp    40000c75 <strcmp+0x45>
40000c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000c98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c9f:	00 

40000ca0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
40000ca0:	55                   	push   %ebp
40000ca1:	89 e5                	mov    %esp,%ebp
40000ca3:	53                   	push   %ebx
40000ca4:	8b 55 10             	mov    0x10(%ebp),%edx
40000ca7:	8b 45 08             	mov    0x8(%ebp),%eax
40000caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
40000cad:	85 d2                	test   %edx,%edx
40000caf:	75 16                	jne    40000cc7 <strncmp+0x27>
40000cb1:	eb 2d                	jmp    40000ce0 <strncmp+0x40>
40000cb3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000cb8:	3a 19                	cmp    (%ecx),%bl
40000cba:	75 12                	jne    40000cce <strncmp+0x2e>
		n--, p++, q++;
40000cbc:	83 c0 01             	add    $0x1,%eax
40000cbf:	83 c1 01             	add    $0x1,%ecx
	while (n > 0 && *p && *p == *q)
40000cc2:	83 ea 01             	sub    $0x1,%edx
40000cc5:	74 19                	je     40000ce0 <strncmp+0x40>
40000cc7:	0f b6 18             	movzbl (%eax),%ebx
40000cca:	84 db                	test   %bl,%bl
40000ccc:	75 ea                	jne    40000cb8 <strncmp+0x18>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000cce:	0f b6 00             	movzbl (%eax),%eax
40000cd1:	0f b6 11             	movzbl (%ecx),%edx
}
40000cd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40000cd7:	c9                   	leave
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000cd8:	29 d0                	sub    %edx,%eax
}
40000cda:	c3                   	ret
40000cdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ce0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
		return 0;
40000ce3:	31 c0                	xor    %eax,%eax
}
40000ce5:	c9                   	leave
40000ce6:	c3                   	ret
40000ce7:	90                   	nop
40000ce8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000cef:	00 

40000cf0 <strchr>:

char *
strchr(const char *s, char c)
{
40000cf0:	55                   	push   %ebp
40000cf1:	89 e5                	mov    %esp,%ebp
40000cf3:	8b 45 08             	mov    0x8(%ebp),%eax
40000cf6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
40000cfa:	0f b6 10             	movzbl (%eax),%edx
40000cfd:	84 d2                	test   %dl,%dl
40000cff:	75 1a                	jne    40000d1b <strchr+0x2b>
40000d01:	eb 25                	jmp    40000d28 <strchr+0x38>
40000d03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d0f:	00 
40000d10:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000d14:	83 c0 01             	add    $0x1,%eax
40000d17:	84 d2                	test   %dl,%dl
40000d19:	74 0d                	je     40000d28 <strchr+0x38>
		if (*s == c)
40000d1b:	38 d1                	cmp    %dl,%cl
40000d1d:	75 f1                	jne    40000d10 <strchr+0x20>
			return (char *) s;
	return 0;
}
40000d1f:	5d                   	pop    %ebp
40000d20:	c3                   	ret
40000d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return 0;
40000d28:	31 c0                	xor    %eax,%eax
}
40000d2a:	5d                   	pop    %ebp
40000d2b:	c3                   	ret
40000d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000d30 <strfind>:

char *
strfind(const char *s, char c)
{
40000d30:	55                   	push   %ebp
40000d31:	89 e5                	mov    %esp,%ebp
40000d33:	8b 45 08             	mov    0x8(%ebp),%eax
40000d36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	for (; *s; s++)
40000d39:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
40000d3c:	38 ca                	cmp    %cl,%dl
40000d3e:	75 1b                	jne    40000d5b <strfind+0x2b>
40000d40:	eb 1d                	jmp    40000d5f <strfind+0x2f>
40000d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000d48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d4f:	00 
	for (; *s; s++)
40000d50:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000d54:	83 c0 01             	add    $0x1,%eax
		if (*s == c)
40000d57:	38 ca                	cmp    %cl,%dl
40000d59:	74 04                	je     40000d5f <strfind+0x2f>
40000d5b:	84 d2                	test   %dl,%dl
40000d5d:	75 f1                	jne    40000d50 <strfind+0x20>
			break;
	return (char *) s;
}
40000d5f:	5d                   	pop    %ebp
40000d60:	c3                   	ret
40000d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d6f:	00 

40000d70 <strtol>:


long
strtol(const char *s, char **endptr, int base)
{
40000d70:	55                   	push   %ebp
40000d71:	89 e5                	mov    %esp,%ebp
40000d73:	57                   	push   %edi
40000d74:	8b 55 08             	mov    0x8(%ebp),%edx
40000d77:	56                   	push   %esi
40000d78:	53                   	push   %ebx
40000d79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
40000d7c:	0f b6 02             	movzbl (%edx),%eax
40000d7f:	3c 09                	cmp    $0x9,%al
40000d81:	74 0d                	je     40000d90 <strtol+0x20>
40000d83:	3c 20                	cmp    $0x20,%al
40000d85:	75 18                	jne    40000d9f <strtol+0x2f>
40000d87:	90                   	nop
40000d88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000d8f:	00 
40000d90:	0f b6 42 01          	movzbl 0x1(%edx),%eax
		s++;
40000d94:	83 c2 01             	add    $0x1,%edx
	while (*s == ' ' || *s == '\t')
40000d97:	3c 20                	cmp    $0x20,%al
40000d99:	74 f5                	je     40000d90 <strtol+0x20>
40000d9b:	3c 09                	cmp    $0x9,%al
40000d9d:	74 f1                	je     40000d90 <strtol+0x20>

	// plus/minus sign
	if (*s == '+')
40000d9f:	3c 2b                	cmp    $0x2b,%al
40000da1:	0f 84 89 00 00 00    	je     40000e30 <strtol+0xc0>
		s++;
	else if (*s == '-')
		s++, neg = 1;
40000da7:	3c 2d                	cmp    $0x2d,%al
40000da9:	8d 4a 01             	lea    0x1(%edx),%ecx
40000dac:	0f 94 c0             	sete   %al
40000daf:	0f 44 d1             	cmove  %ecx,%edx
40000db2:	0f b6 c0             	movzbl %al,%eax

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000db5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
40000dbb:	75 10                	jne    40000dcd <strtol+0x5d>
40000dbd:	80 3a 30             	cmpb   $0x30,(%edx)
40000dc0:	74 7e                	je     40000e40 <strtol+0xd0>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
40000dc2:	83 fb 01             	cmp    $0x1,%ebx
40000dc5:	19 db                	sbb    %ebx,%ebx
40000dc7:	83 e3 fa             	and    $0xfffffffa,%ebx
40000dca:	83 c3 10             	add    $0x10,%ebx
40000dcd:	89 5d 10             	mov    %ebx,0x10(%ebp)
40000dd0:	31 c9                	xor    %ecx,%ecx
40000dd2:	89 c7                	mov    %eax,%edi
40000dd4:	eb 13                	jmp    40000de9 <strtol+0x79>
40000dd6:	66 90                	xchg   %ax,%ax
40000dd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000ddf:	00 
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
		s++, val = (val * base) + dig;
40000de0:	0f af 4d 10          	imul   0x10(%ebp),%ecx
40000de4:	83 c2 01             	add    $0x1,%edx
40000de7:	01 f1                	add    %esi,%ecx
		if (*s >= '0' && *s <= '9')
40000de9:	0f be 1a             	movsbl (%edx),%ebx
40000dec:	8d 43 d0             	lea    -0x30(%ebx),%eax
			dig = *s - '0';
40000def:	8d 73 d0             	lea    -0x30(%ebx),%esi
		if (*s >= '0' && *s <= '9')
40000df2:	3c 09                	cmp    $0x9,%al
40000df4:	76 14                	jbe    40000e0a <strtol+0x9a>
		else if (*s >= 'a' && *s <= 'z')
40000df6:	8d 43 9f             	lea    -0x61(%ebx),%eax
			dig = *s - 'a' + 10;
40000df9:	8d 73 a9             	lea    -0x57(%ebx),%esi
		else if (*s >= 'a' && *s <= 'z')
40000dfc:	3c 19                	cmp    $0x19,%al
40000dfe:	76 0a                	jbe    40000e0a <strtol+0x9a>
		else if (*s >= 'A' && *s <= 'Z')
40000e00:	8d 43 bf             	lea    -0x41(%ebx),%eax
40000e03:	3c 19                	cmp    $0x19,%al
40000e05:	77 08                	ja     40000e0f <strtol+0x9f>
			dig = *s - 'A' + 10;
40000e07:	8d 73 c9             	lea    -0x37(%ebx),%esi
		if (dig >= base)
40000e0a:	3b 75 10             	cmp    0x10(%ebp),%esi
40000e0d:	7c d1                	jl     40000de0 <strtol+0x70>
		// we don't properly detect overflow!
	}

	if (endptr)
40000e0f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40000e12:	89 f8                	mov    %edi,%eax
40000e14:	85 db                	test   %ebx,%ebx
40000e16:	74 05                	je     40000e1d <strtol+0xad>
		*endptr = (char *) s;
40000e18:	8b 7d 0c             	mov    0xc(%ebp),%edi
40000e1b:	89 17                	mov    %edx,(%edi)
	return (neg ? -val : val);
40000e1d:	89 ca                	mov    %ecx,%edx
}
40000e1f:	5b                   	pop    %ebx
40000e20:	5e                   	pop    %esi
	return (neg ? -val : val);
40000e21:	f7 da                	neg    %edx
40000e23:	85 c0                	test   %eax,%eax
}
40000e25:	5f                   	pop    %edi
40000e26:	5d                   	pop    %ebp
	return (neg ? -val : val);
40000e27:	0f 45 ca             	cmovne %edx,%ecx
}
40000e2a:	89 c8                	mov    %ecx,%eax
40000e2c:	c3                   	ret
40000e2d:	8d 76 00             	lea    0x0(%esi),%esi
		s++;
40000e30:	83 c2 01             	add    $0x1,%edx
	int neg = 0;
40000e33:	31 c0                	xor    %eax,%eax
40000e35:	e9 7b ff ff ff       	jmp    40000db5 <strtol+0x45>
40000e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000e40:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
40000e44:	74 1b                	je     40000e61 <strtol+0xf1>
	else if (base == 0 && s[0] == '0')
40000e46:	85 db                	test   %ebx,%ebx
40000e48:	74 0a                	je     40000e54 <strtol+0xe4>
40000e4a:	bb 10 00 00 00       	mov    $0x10,%ebx
40000e4f:	e9 79 ff ff ff       	jmp    40000dcd <strtol+0x5d>
		s++, base = 8;
40000e54:	83 c2 01             	add    $0x1,%edx
40000e57:	bb 08 00 00 00       	mov    $0x8,%ebx
40000e5c:	e9 6c ff ff ff       	jmp    40000dcd <strtol+0x5d>
		s += 2, base = 16;
40000e61:	83 c2 02             	add    $0x2,%edx
40000e64:	bb 10 00 00 00       	mov    $0x10,%ebx
40000e69:	e9 5f ff ff ff       	jmp    40000dcd <strtol+0x5d>
40000e6e:	66 90                	xchg   %ax,%ax

40000e70 <memset>:

void *
memset(void *v, int c, size_t n)
{
40000e70:	55                   	push   %ebp
40000e71:	89 e5                	mov    %esp,%ebp
40000e73:	57                   	push   %edi
40000e74:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000e77:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000e7a:	85 c9                	test   %ecx,%ecx
40000e7c:	74 1a                	je     40000e98 <memset+0x28>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
40000e7e:	89 d0                	mov    %edx,%eax
40000e80:	09 c8                	or     %ecx,%eax
40000e82:	a8 03                	test   $0x3,%al
40000e84:	75 1a                	jne    40000ea0 <memset+0x30>
		c &= 0xFF;
40000e86:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
40000e8a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000e8d:	89 d7                	mov    %edx,%edi
40000e8f:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
40000e95:	fc                   	cld
40000e96:	f3 ab                	rep stos %eax,%es:(%edi)
	} else
		asm volatile("cld; rep stosb\n"
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
}
40000e98:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000e9b:	89 d0                	mov    %edx,%eax
40000e9d:	c9                   	leave
40000e9e:	c3                   	ret
40000e9f:	90                   	nop
		asm volatile("cld; rep stosb\n"
40000ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
40000ea3:	89 d7                	mov    %edx,%edi
40000ea5:	fc                   	cld
40000ea6:	f3 aa                	rep stos %al,%es:(%edi)
}
40000ea8:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000eab:	89 d0                	mov    %edx,%eax
40000ead:	c9                   	leave
40000eae:	c3                   	ret
40000eaf:	90                   	nop

40000eb0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
40000eb0:	55                   	push   %ebp
40000eb1:	89 e5                	mov    %esp,%ebp
40000eb3:	57                   	push   %edi
40000eb4:	8b 45 08             	mov    0x8(%ebp),%eax
40000eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
40000eba:	56                   	push   %esi
40000ebb:	8b 4d 10             	mov    0x10(%ebp),%ecx
40000ebe:	53                   	push   %ebx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
40000ebf:	39 c2                	cmp    %eax,%edx
40000ec1:	73 2d                	jae    40000ef0 <memmove+0x40>
40000ec3:	8d 1c 0a             	lea    (%edx,%ecx,1),%ebx
40000ec6:	39 d8                	cmp    %ebx,%eax
40000ec8:	73 26                	jae    40000ef0 <memmove+0x40>
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000eca:	8d 14 08             	lea    (%eax,%ecx,1),%edx
40000ecd:	09 ca                	or     %ecx,%edx
40000ecf:	09 da                	or     %ebx,%edx
40000ed1:	83 e2 03             	and    $0x3,%edx
40000ed4:	74 4a                	je     40000f20 <memmove+0x70>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
				     : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
40000ed6:	8d 7c 08 ff          	lea    -0x1(%eax,%ecx,1),%edi
40000eda:	8d 73 ff             	lea    -0x1(%ebx),%esi
40000edd:	fd                   	std
40000ede:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				     :: "D" (d-1), "S" (s-1), "c" (n)
				     : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
40000ee0:	fc                   	cld
			asm volatile("cld; rep movsb\n"
				     :: "D" (d), "S" (s), "c" (n)
				     : "cc", "memory");
	}
	return dst;
}
40000ee1:	5b                   	pop    %ebx
40000ee2:	5e                   	pop    %esi
40000ee3:	5f                   	pop    %edi
40000ee4:	5d                   	pop    %ebp
40000ee5:	c3                   	ret
40000ee6:	66 90                	xchg   %ax,%ax
40000ee8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000eef:	00 
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000ef0:	89 c3                	mov    %eax,%ebx
40000ef2:	09 cb                	or     %ecx,%ebx
40000ef4:	09 d3                	or     %edx,%ebx
40000ef6:	83 e3 03             	and    $0x3,%ebx
40000ef9:	74 15                	je     40000f10 <memmove+0x60>
			asm volatile("cld; rep movsb\n"
40000efb:	89 c7                	mov    %eax,%edi
40000efd:	89 d6                	mov    %edx,%esi
40000eff:	fc                   	cld
40000f00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000f02:	5b                   	pop    %ebx
40000f03:	5e                   	pop    %esi
40000f04:	5f                   	pop    %edi
40000f05:	5d                   	pop    %ebp
40000f06:	c3                   	ret
40000f07:	90                   	nop
40000f08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f0f:	00 
				     :: "D" (d), "S" (s), "c" (n/4)
40000f10:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
40000f13:	89 c7                	mov    %eax,%edi
40000f15:	89 d6                	mov    %edx,%esi
40000f17:	fc                   	cld
40000f18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000f1a:	eb e6                	jmp    40000f02 <memmove+0x52>
40000f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			asm volatile("std; rep movsl\n"
40000f20:	8d 7c 08 fc          	lea    -0x4(%eax,%ecx,1),%edi
40000f24:	8d 73 fc             	lea    -0x4(%ebx),%esi
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
40000f27:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
40000f2a:	fd                   	std
40000f2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000f2d:	eb b1                	jmp    40000ee0 <memmove+0x30>
40000f2f:	90                   	nop

40000f30 <memcpy>:

void *
memcpy(void *dst, const void *src, size_t n)
{
	return memmove(dst, src, n);
40000f30:	e9 7b ff ff ff       	jmp    40000eb0 <memmove>
40000f35:	8d 76 00             	lea    0x0(%esi),%esi
40000f38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f3f:	00 

40000f40 <memcmp>:
}

int
memcmp(const void *v1, const void *v2, size_t n)
{
40000f40:	55                   	push   %ebp
40000f41:	89 e5                	mov    %esp,%ebp
40000f43:	56                   	push   %esi
40000f44:	8b 75 10             	mov    0x10(%ebp),%esi
40000f47:	8b 45 08             	mov    0x8(%ebp),%eax
40000f4a:	53                   	push   %ebx
40000f4b:	8b 55 0c             	mov    0xc(%ebp),%edx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
40000f4e:	85 f6                	test   %esi,%esi
40000f50:	74 2e                	je     40000f80 <memcmp+0x40>
40000f52:	01 c6                	add    %eax,%esi
40000f54:	eb 14                	jmp    40000f6a <memcmp+0x2a>
40000f56:	66 90                	xchg   %ax,%ax
40000f58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f5f:	00 
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
40000f60:	83 c0 01             	add    $0x1,%eax
40000f63:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
40000f66:	39 f0                	cmp    %esi,%eax
40000f68:	74 16                	je     40000f80 <memcmp+0x40>
		if (*s1 != *s2)
40000f6a:	0f b6 08             	movzbl (%eax),%ecx
40000f6d:	0f b6 1a             	movzbl (%edx),%ebx
40000f70:	38 d9                	cmp    %bl,%cl
40000f72:	74 ec                	je     40000f60 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
40000f74:	0f b6 c1             	movzbl %cl,%eax
40000f77:	29 d8                	sub    %ebx,%eax
	}

	return 0;
}
40000f79:	5b                   	pop    %ebx
40000f7a:	5e                   	pop    %esi
40000f7b:	5d                   	pop    %ebp
40000f7c:	c3                   	ret
40000f7d:	8d 76 00             	lea    0x0(%esi),%esi
40000f80:	5b                   	pop    %ebx
	return 0;
40000f81:	31 c0                	xor    %eax,%eax
}
40000f83:	5e                   	pop    %esi
40000f84:	5d                   	pop    %ebp
40000f85:	c3                   	ret
40000f86:	66 90                	xchg   %ax,%ax
40000f88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f8f:	00 

40000f90 <memchr>:

void *
memchr(const void *s, int c, size_t n)
{
40000f90:	55                   	push   %ebp
40000f91:	89 e5                	mov    %esp,%ebp
40000f93:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
40000f96:	8b 55 10             	mov    0x10(%ebp),%edx
40000f99:	01 c2                	add    %eax,%edx
	for (; s < ends; s++)
40000f9b:	39 d0                	cmp    %edx,%eax
40000f9d:	73 21                	jae    40000fc0 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000f9f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
40000fa3:	eb 12                	jmp    40000fb7 <memchr+0x27>
40000fa5:	8d 76 00             	lea    0x0(%esi),%esi
40000fa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000faf:	00 
	for (; s < ends; s++)
40000fb0:	83 c0 01             	add    $0x1,%eax
40000fb3:	39 c2                	cmp    %eax,%edx
40000fb5:	74 09                	je     40000fc0 <memchr+0x30>
		if (*(const unsigned char *) s == (unsigned char) c)
40000fb7:	38 08                	cmp    %cl,(%eax)
40000fb9:	75 f5                	jne    40000fb0 <memchr+0x20>
			return (void *) s;
	return NULL;
}
40000fbb:	5d                   	pop    %ebp
40000fbc:	c3                   	ret
40000fbd:	8d 76 00             	lea    0x0(%esi),%esi
	return NULL;
40000fc0:	31 c0                	xor    %eax,%eax
}
40000fc2:	5d                   	pop    %ebp
40000fc3:	c3                   	ret
40000fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000fc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000fcf:	00 

40000fd0 <memzero>:

void *
memzero(void *v, size_t n)
{
40000fd0:	55                   	push   %ebp
40000fd1:	89 e5                	mov    %esp,%ebp
40000fd3:	57                   	push   %edi
40000fd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
40000fd7:	8b 55 08             	mov    0x8(%ebp),%edx
	if (n == 0)
40000fda:	85 c9                	test   %ecx,%ecx
40000fdc:	74 11                	je     40000fef <memzero+0x1f>
	if ((int)v%4 == 0 && n%4 == 0) {
40000fde:	89 d0                	mov    %edx,%eax
40000fe0:	09 c8                	or     %ecx,%eax
40000fe2:	83 e0 03             	and    $0x3,%eax
40000fe5:	75 19                	jne    40001000 <memzero+0x30>
			     :: "D" (v), "a" (c), "c" (n/4)
40000fe7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000fea:	89 d7                	mov    %edx,%edi
40000fec:	fc                   	cld
40000fed:	f3 ab                	rep stos %eax,%es:(%edi)
	return memset(v, 0, n);
}
40000fef:	8b 7d fc             	mov    -0x4(%ebp),%edi
40000ff2:	89 d0                	mov    %edx,%eax
40000ff4:	c9                   	leave
40000ff5:	c3                   	ret
40000ff6:	66 90                	xchg   %ax,%ax
40000ff8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000fff:	00 
		asm volatile("cld; rep stosb\n"
40001000:	89 d7                	mov    %edx,%edi
40001002:	31 c0                	xor    %eax,%eax
40001004:	fc                   	cld
40001005:	f3 aa                	rep stos %al,%es:(%edi)
}
40001007:	8b 7d fc             	mov    -0x4(%ebp),%edi
4000100a:	89 d0                	mov    %edx,%eax
4000100c:	c9                   	leave
4000100d:	c3                   	ret
4000100e:	66 90                	xchg   %ax,%ax

40001010 <sigaction>:
#include <signal.h>
#include <syscall.h>

int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
40001010:	55                   	push   %ebp

static gcc_inline int
sys_sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
	int errno;
	asm volatile ("int %1"
40001011:	b8 1a 00 00 00       	mov    $0x1a,%eax
40001016:	89 e5                	mov    %esp,%ebp
40001018:	53                   	push   %ebx
40001019:	8b 4d 0c             	mov    0xc(%ebp),%ecx
4000101c:	8b 55 10             	mov    0x10(%ebp),%edx
4000101f:	8b 5d 08             	mov    0x8(%ebp),%ebx
40001022:	cd 30                	int    $0x30
		        "a" (SYS_sigaction),
		        "b" (signum),
		        "c" (act),
		        "d" (oldact)
		      : "cc", "memory");
	return errno ? -1 : 0;
40001024:	f7 d8                	neg    %eax
    return sys_sigaction(signum, act, oldact);
}
40001026:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40001029:	c9                   	leave
4000102a:	19 c0                	sbb    %eax,%eax
4000102c:	c3                   	ret
4000102d:	8d 76 00             	lea    0x0(%esi),%esi

40001030 <kill>:

int kill(int pid, int signum)
{
40001030:	55                   	push   %ebp

static gcc_inline int
sys_kill(int pid, int signum)
{
	int errno;
	asm volatile ("int %1"
40001031:	b8 1b 00 00 00       	mov    $0x1b,%eax
40001036:	89 e5                	mov    %esp,%ebp
40001038:	53                   	push   %ebx
40001039:	8b 4d 0c             	mov    0xc(%ebp),%ecx
4000103c:	8b 5d 08             	mov    0x8(%ebp),%ebx
4000103f:	cd 30                	int    $0x30
		      : "i" (T_SYSCALL),
		        "a" (SYS_kill),
		        "b" (pid),
		        "c" (signum)
		      : "cc", "memory");
	return errno ? -1 : 0;
40001041:	f7 d8                	neg    %eax
    return sys_kill(pid, signum);
}
40001043:	8b 5d fc             	mov    -0x4(%ebp),%ebx
40001046:	c9                   	leave
40001047:	19 c0                	sbb    %eax,%eax
40001049:	c3                   	ret
4000104a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40001050 <pause>:

static gcc_inline int
sys_pause(void)
{
	int errno;
	asm volatile ("int %1"
40001050:	b8 1c 00 00 00       	mov    $0x1c,%eax
40001055:	cd 30                	int    $0x30
		      : "=a" (errno)
		      : "i" (T_SYSCALL),
		        "a" (SYS_pause)
		      : "cc", "memory");
	return errno ? -1 : 0;
40001057:	f7 d8                	neg    %eax
40001059:	19 c0                	sbb    %eax,%eax

int pause(void)
{
    return sys_pause();
}
4000105b:	c3                   	ret
4000105c:	66 90                	xchg   %ax,%ax
4000105e:	66 90                	xchg   %ax,%ax

40001060 <__udivdi3>:
40001060:	55                   	push   %ebp
40001061:	89 e5                	mov    %esp,%ebp
40001063:	57                   	push   %edi
40001064:	56                   	push   %esi
40001065:	53                   	push   %ebx
40001066:	83 ec 1c             	sub    $0x1c,%esp
40001069:	8b 75 08             	mov    0x8(%ebp),%esi
4000106c:	8b 45 14             	mov    0x14(%ebp),%eax
4000106f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
40001072:	8b 7d 10             	mov    0x10(%ebp),%edi
40001075:	89 75 e4             	mov    %esi,-0x1c(%ebp)
40001078:	85 c0                	test   %eax,%eax
4000107a:	75 1c                	jne    40001098 <__udivdi3+0x38>
4000107c:	39 fb                	cmp    %edi,%ebx
4000107e:	73 50                	jae    400010d0 <__udivdi3+0x70>
40001080:	89 f0                	mov    %esi,%eax
40001082:	31 f6                	xor    %esi,%esi
40001084:	89 da                	mov    %ebx,%edx
40001086:	f7 f7                	div    %edi
40001088:	89 f2                	mov    %esi,%edx
4000108a:	83 c4 1c             	add    $0x1c,%esp
4000108d:	5b                   	pop    %ebx
4000108e:	5e                   	pop    %esi
4000108f:	5f                   	pop    %edi
40001090:	5d                   	pop    %ebp
40001091:	c3                   	ret
40001092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001098:	39 c3                	cmp    %eax,%ebx
4000109a:	73 14                	jae    400010b0 <__udivdi3+0x50>
4000109c:	31 f6                	xor    %esi,%esi
4000109e:	31 c0                	xor    %eax,%eax
400010a0:	89 f2                	mov    %esi,%edx
400010a2:	83 c4 1c             	add    $0x1c,%esp
400010a5:	5b                   	pop    %ebx
400010a6:	5e                   	pop    %esi
400010a7:	5f                   	pop    %edi
400010a8:	5d                   	pop    %ebp
400010a9:	c3                   	ret
400010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400010b0:	0f bd f0             	bsr    %eax,%esi
400010b3:	83 f6 1f             	xor    $0x1f,%esi
400010b6:	75 48                	jne    40001100 <__udivdi3+0xa0>
400010b8:	39 d8                	cmp    %ebx,%eax
400010ba:	72 07                	jb     400010c3 <__udivdi3+0x63>
400010bc:	31 c0                	xor    %eax,%eax
400010be:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
400010c1:	72 dd                	jb     400010a0 <__udivdi3+0x40>
400010c3:	b8 01 00 00 00       	mov    $0x1,%eax
400010c8:	eb d6                	jmp    400010a0 <__udivdi3+0x40>
400010ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
400010d0:	89 f9                	mov    %edi,%ecx
400010d2:	85 ff                	test   %edi,%edi
400010d4:	75 0b                	jne    400010e1 <__udivdi3+0x81>
400010d6:	b8 01 00 00 00       	mov    $0x1,%eax
400010db:	31 d2                	xor    %edx,%edx
400010dd:	f7 f7                	div    %edi
400010df:	89 c1                	mov    %eax,%ecx
400010e1:	31 d2                	xor    %edx,%edx
400010e3:	89 d8                	mov    %ebx,%eax
400010e5:	f7 f1                	div    %ecx
400010e7:	89 c6                	mov    %eax,%esi
400010e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
400010ec:	f7 f1                	div    %ecx
400010ee:	89 f2                	mov    %esi,%edx
400010f0:	83 c4 1c             	add    $0x1c,%esp
400010f3:	5b                   	pop    %ebx
400010f4:	5e                   	pop    %esi
400010f5:	5f                   	pop    %edi
400010f6:	5d                   	pop    %ebp
400010f7:	c3                   	ret
400010f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400010ff:	00 
40001100:	89 f1                	mov    %esi,%ecx
40001102:	ba 20 00 00 00       	mov    $0x20,%edx
40001107:	29 f2                	sub    %esi,%edx
40001109:	d3 e0                	shl    %cl,%eax
4000110b:	89 45 e0             	mov    %eax,-0x20(%ebp)
4000110e:	89 d1                	mov    %edx,%ecx
40001110:	89 f8                	mov    %edi,%eax
40001112:	d3 e8                	shr    %cl,%eax
40001114:	8b 4d e0             	mov    -0x20(%ebp),%ecx
40001117:	09 c1                	or     %eax,%ecx
40001119:	89 d8                	mov    %ebx,%eax
4000111b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
4000111e:	89 f1                	mov    %esi,%ecx
40001120:	d3 e7                	shl    %cl,%edi
40001122:	89 d1                	mov    %edx,%ecx
40001124:	d3 e8                	shr    %cl,%eax
40001126:	89 f1                	mov    %esi,%ecx
40001128:	89 7d dc             	mov    %edi,-0x24(%ebp)
4000112b:	89 45 d8             	mov    %eax,-0x28(%ebp)
4000112e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40001131:	d3 e3                	shl    %cl,%ebx
40001133:	89 d1                	mov    %edx,%ecx
40001135:	8b 55 d8             	mov    -0x28(%ebp),%edx
40001138:	d3 e8                	shr    %cl,%eax
4000113a:	09 d8                	or     %ebx,%eax
4000113c:	f7 75 e0             	divl   -0x20(%ebp)
4000113f:	89 d3                	mov    %edx,%ebx
40001141:	89 c7                	mov    %eax,%edi
40001143:	f7 65 dc             	mull   -0x24(%ebp)
40001146:	89 45 e0             	mov    %eax,-0x20(%ebp)
40001149:	39 d3                	cmp    %edx,%ebx
4000114b:	72 23                	jb     40001170 <__udivdi3+0x110>
4000114d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
40001150:	89 f1                	mov    %esi,%ecx
40001152:	d3 e0                	shl    %cl,%eax
40001154:	3b 45 e0             	cmp    -0x20(%ebp),%eax
40001157:	73 04                	jae    4000115d <__udivdi3+0xfd>
40001159:	39 d3                	cmp    %edx,%ebx
4000115b:	74 13                	je     40001170 <__udivdi3+0x110>
4000115d:	89 f8                	mov    %edi,%eax
4000115f:	31 f6                	xor    %esi,%esi
40001161:	e9 3a ff ff ff       	jmp    400010a0 <__udivdi3+0x40>
40001166:	66 90                	xchg   %ax,%ax
40001168:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000116f:	00 
40001170:	8d 47 ff             	lea    -0x1(%edi),%eax
40001173:	31 f6                	xor    %esi,%esi
40001175:	e9 26 ff ff ff       	jmp    400010a0 <__udivdi3+0x40>
4000117a:	66 90                	xchg   %ax,%ax
4000117c:	66 90                	xchg   %ax,%ax
4000117e:	66 90                	xchg   %ax,%ax

40001180 <__umoddi3>:
40001180:	55                   	push   %ebp
40001181:	89 e5                	mov    %esp,%ebp
40001183:	57                   	push   %edi
40001184:	56                   	push   %esi
40001185:	53                   	push   %ebx
40001186:	83 ec 2c             	sub    $0x2c,%esp
40001189:	8b 5d 0c             	mov    0xc(%ebp),%ebx
4000118c:	8b 45 14             	mov    0x14(%ebp),%eax
4000118f:	8b 75 08             	mov    0x8(%ebp),%esi
40001192:	8b 7d 10             	mov    0x10(%ebp),%edi
40001195:	89 da                	mov    %ebx,%edx
40001197:	85 c0                	test   %eax,%eax
40001199:	75 15                	jne    400011b0 <__umoddi3+0x30>
4000119b:	39 fb                	cmp    %edi,%ebx
4000119d:	73 51                	jae    400011f0 <__umoddi3+0x70>
4000119f:	89 f0                	mov    %esi,%eax
400011a1:	f7 f7                	div    %edi
400011a3:	89 d0                	mov    %edx,%eax
400011a5:	31 d2                	xor    %edx,%edx
400011a7:	83 c4 2c             	add    $0x2c,%esp
400011aa:	5b                   	pop    %ebx
400011ab:	5e                   	pop    %esi
400011ac:	5f                   	pop    %edi
400011ad:	5d                   	pop    %ebp
400011ae:	c3                   	ret
400011af:	90                   	nop
400011b0:	89 75 e0             	mov    %esi,-0x20(%ebp)
400011b3:	39 c3                	cmp    %eax,%ebx
400011b5:	73 11                	jae    400011c8 <__umoddi3+0x48>
400011b7:	89 f0                	mov    %esi,%eax
400011b9:	83 c4 2c             	add    $0x2c,%esp
400011bc:	5b                   	pop    %ebx
400011bd:	5e                   	pop    %esi
400011be:	5f                   	pop    %edi
400011bf:	5d                   	pop    %ebp
400011c0:	c3                   	ret
400011c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400011c8:	0f bd c8             	bsr    %eax,%ecx
400011cb:	83 f1 1f             	xor    $0x1f,%ecx
400011ce:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
400011d1:	75 3d                	jne    40001210 <__umoddi3+0x90>
400011d3:	39 d8                	cmp    %ebx,%eax
400011d5:	0f 82 cd 00 00 00    	jb     400012a8 <__umoddi3+0x128>
400011db:	39 fe                	cmp    %edi,%esi
400011dd:	0f 83 c5 00 00 00    	jae    400012a8 <__umoddi3+0x128>
400011e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
400011e6:	83 c4 2c             	add    $0x2c,%esp
400011e9:	5b                   	pop    %ebx
400011ea:	5e                   	pop    %esi
400011eb:	5f                   	pop    %edi
400011ec:	5d                   	pop    %ebp
400011ed:	c3                   	ret
400011ee:	66 90                	xchg   %ax,%ax
400011f0:	89 f9                	mov    %edi,%ecx
400011f2:	85 ff                	test   %edi,%edi
400011f4:	75 0b                	jne    40001201 <__umoddi3+0x81>
400011f6:	b8 01 00 00 00       	mov    $0x1,%eax
400011fb:	31 d2                	xor    %edx,%edx
400011fd:	f7 f7                	div    %edi
400011ff:	89 c1                	mov    %eax,%ecx
40001201:	89 d8                	mov    %ebx,%eax
40001203:	31 d2                	xor    %edx,%edx
40001205:	f7 f1                	div    %ecx
40001207:	89 f0                	mov    %esi,%eax
40001209:	f7 f1                	div    %ecx
4000120b:	eb 96                	jmp    400011a3 <__umoddi3+0x23>
4000120d:	8d 76 00             	lea    0x0(%esi),%esi
40001210:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001214:	ba 20 00 00 00       	mov    $0x20,%edx
40001219:	2b 55 e4             	sub    -0x1c(%ebp),%edx
4000121c:	89 55 e0             	mov    %edx,-0x20(%ebp)
4000121f:	d3 e0                	shl    %cl,%eax
40001221:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
40001225:	89 45 dc             	mov    %eax,-0x24(%ebp)
40001228:	89 f8                	mov    %edi,%eax
4000122a:	8b 55 dc             	mov    -0x24(%ebp),%edx
4000122d:	d3 e8                	shr    %cl,%eax
4000122f:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001233:	09 c2                	or     %eax,%edx
40001235:	d3 e7                	shl    %cl,%edi
40001237:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
4000123b:	89 55 dc             	mov    %edx,-0x24(%ebp)
4000123e:	89 da                	mov    %ebx,%edx
40001240:	89 7d d8             	mov    %edi,-0x28(%ebp)
40001243:	89 f7                	mov    %esi,%edi
40001245:	d3 ea                	shr    %cl,%edx
40001247:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
4000124b:	d3 e3                	shl    %cl,%ebx
4000124d:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
40001251:	d3 ef                	shr    %cl,%edi
40001253:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001257:	89 f8                	mov    %edi,%eax
40001259:	d3 e6                	shl    %cl,%esi
4000125b:	09 d8                	or     %ebx,%eax
4000125d:	f7 75 dc             	divl   -0x24(%ebp)
40001260:	89 d3                	mov    %edx,%ebx
40001262:	89 75 d4             	mov    %esi,-0x2c(%ebp)
40001265:	89 f7                	mov    %esi,%edi
40001267:	f7 65 d8             	mull   -0x28(%ebp)
4000126a:	89 c6                	mov    %eax,%esi
4000126c:	89 d1                	mov    %edx,%ecx
4000126e:	39 d3                	cmp    %edx,%ebx
40001270:	72 06                	jb     40001278 <__umoddi3+0xf8>
40001272:	75 0e                	jne    40001282 <__umoddi3+0x102>
40001274:	39 c7                	cmp    %eax,%edi
40001276:	73 0a                	jae    40001282 <__umoddi3+0x102>
40001278:	2b 45 d8             	sub    -0x28(%ebp),%eax
4000127b:	1b 55 dc             	sbb    -0x24(%ebp),%edx
4000127e:	89 d1                	mov    %edx,%ecx
40001280:	89 c6                	mov    %eax,%esi
40001282:	8b 45 d4             	mov    -0x2c(%ebp),%eax
40001285:	29 f0                	sub    %esi,%eax
40001287:	19 cb                	sbb    %ecx,%ebx
40001289:	0f b6 4d e0          	movzbl -0x20(%ebp),%ecx
4000128d:	89 da                	mov    %ebx,%edx
4000128f:	d3 e2                	shl    %cl,%edx
40001291:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
40001295:	d3 e8                	shr    %cl,%eax
40001297:	d3 eb                	shr    %cl,%ebx
40001299:	09 d0                	or     %edx,%eax
4000129b:	89 da                	mov    %ebx,%edx
4000129d:	83 c4 2c             	add    $0x2c,%esp
400012a0:	5b                   	pop    %ebx
400012a1:	5e                   	pop    %esi
400012a2:	5f                   	pop    %edi
400012a3:	5d                   	pop    %ebp
400012a4:	c3                   	ret
400012a5:	8d 76 00             	lea    0x0(%esi),%esi
400012a8:	89 da                	mov    %ebx,%edx
400012aa:	29 fe                	sub    %edi,%esi
400012ac:	19 c2                	sbb    %eax,%edx
400012ae:	89 75 e0             	mov    %esi,-0x20(%ebp)
400012b1:	e9 2d ff ff ff       	jmp    400011e3 <__umoddi3+0x63>
