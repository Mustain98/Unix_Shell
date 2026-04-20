
obj/boot/boot1.elf:     file format elf32-i386


Disassembly of section .text:

00007e00 <start>:
	.set SMAP_SIG, 0x0534D4150	# "SMAP"

	.globl start
start:
	.code16
	cli
    7e00:	fa                   	cli
	cld
    7e01:	fc                   	cld

00007e02 <seta20.1>:

	/* enable A20 */
seta20.1:
	inb	$0x64, %al
    7e02:	e4 64                	in     $0x64,%al
	testb	$0x2, %al
    7e04:	a8 02                	test   $0x2,%al
	jnz	seta20.1
    7e06:	75 fa                	jne    7e02 <seta20.1>
	movb	$0xd1, %al
    7e08:	b0 d1                	mov    $0xd1,%al
	outb	%al, $0x64
    7e0a:	e6 64                	out    %al,$0x64

00007e0c <seta20.2>:
seta20.2:
	inb	$0x64, %al
    7e0c:	e4 64                	in     $0x64,%al
	testb	$0x2, %al
    7e0e:	a8 02                	test   $0x2,%al
	jnz	seta20.2
    7e10:	75 fa                	jne    7e0c <seta20.2>
	movb	$0xdf, %al
    7e12:	b0 df                	mov    $0xdf,%al
	outb	%al, $0x60
    7e14:	e6 60                	out    %al,$0x60

00007e16 <set_video_mode.2>:

	/*
	 * print starting message
	 */
set_video_mode.2:
	movw	$STARTUP_MSG, %si
    7e16:	be ab 7e e8 81       	mov    $0x81e87eab,%esi
	call	putstr
    7e1b:	00               	add    %ah,0x31(%esi)

00007e1c <e820>:

	/*
	 * detect the physical memory map
	 */
e820:
	xorl	%ebx, %ebx		# ebx must be 0 when first calling e820
    7e1c:	66 31 db             	xor    %bx,%bx
	movl	$SMAP_SIG, %edx		# edx must be 'SMAP' when calling e820
    7e1f:	66 ba 50 41          	mov    $0x4150,%dx
    7e23:	4d                   	dec    %ebp
    7e24:	53                   	push   %ebx
	movw	$(smap+4), %di		# set the address of the output buffer
    7e25:	bf 2a 7f         	mov    $0xb9667f2a,%edi

00007e28 <e820.1>:
e820.1:
	movl	$20, %ecx		# set the size of the output buffer
    7e28:	66 b9 14 00          	mov    $0x14,%cx
    7e2c:	00 00                	add    %al,(%eax)
	movl	$0xe820, %eax		# set the BIOS service code
    7e2e:	66 b8 20 e8          	mov    $0xe820,%ax
    7e32:	00 00                	add    %al,(%eax)
	int	$0x15			# call BIOS service e820h
    7e34:	cd 15                	int    $0x15

00007e36 <e820.2>:
e820.2:
	jc	e820.fail		# error during e820h
    7e36:	72 24                	jb     7e5c <e820.fail>
	cmpl	$SMAP_SIG, %eax		# check eax, which should be 'SMAP'
    7e38:	66 3d 50 41          	cmp    $0x4150,%ax
    7e3c:	4d                   	dec    %ebp
    7e3d:	53                   	push   %ebx
	jne	e820.fail
    7e3e:	75 1c                	jne    7e5c <e820.fail>

00007e40 <e820.3>:
e820.3:
	movl	$20, -4(%di)
    7e40:	66 c7 45 fc 14 00    	movw   $0x14,-0x4(%ebp)
    7e46:	00 00                	add    %al,(%eax)
	addw	$24, %di
    7e48:	83 c7 18             	add    $0x18,%edi
	cmpl	$0x0, %ebx		# whether it's the last descriptor
    7e4b:	66 83 fb 00          	cmp    $0x0,%bx
	je	e820.4
    7e4f:	74 02                	je     7e53 <e820.4>
	jmp	e820.1
    7e51:	eb d5                	jmp    7e28 <e820.1>

00007e53 <e820.4>:
e820.4:					# zero the descriptor after the last one
	xorb	%al, %al
    7e53:	30 c0                	xor    %al,%al
	movw	$20, %cx
    7e55:	b9 14 00 f3 aa       	mov    $0xaaf30014,%ecx
	rep	stosb
	jmp	switch_prot
    7e5a:	eb 09                	jmp    7e65 <switch_prot>

00007e5c <e820.fail>:
e820.fail:
	movw	$E820_FAIL_MSG, %si
    7e5c:	be bd 7e e8 3b       	mov    $0x3be87ebd,%esi
	call	putstr
    7e61:	00 eb                	add    %ch,%bl
	jmp	spin16
    7e63:	00                 	add    %dh,%ah

00007e64 <spin16>:

spin16:
	hlt
    7e64:	f4                   	hlt

00007e65 <switch_prot>:

	/*
	 * load the bootstrap GDT
	 */
switch_prot:
	lgdt	gdtdesc
    7e65:	0f 01 16             	lgdtl  (%esi)
    7e68:	20 7f 0f             	and    %bh,0xf(%edi)
	movl	%cr0, %eax
    7e6b:	20 c0                	and    %al,%al
	orl	$CR0_PE_ON, %eax
    7e6d:	66 83 c8 01          	or     $0x1,%ax
	movl	%eax, %cr0
    7e71:	0f 22 c0             	mov    %eax,%cr0
	/*
	 * switch to the protected mode
	 */
	ljmp	$PROT_MODE_CSEG, $protcseg
    7e74:	ea 79 7e 08 00   	ljmp   $0xb866,$0x87e79

00007e79 <protcseg>:

	.code32
protcseg:
	movw	$PROT_MODE_DSEG, %ax
    7e79:	66 b8 10 00          	mov    $0x10,%ax
	movw	%ax, %ds
    7e7d:	8e d8                	mov    %eax,%ds
	movw	%ax, %es
    7e7f:	8e c0                	mov    %eax,%es
	movw	%ax, %fs
    7e81:	8e e0                	mov    %eax,%fs
	movw	%ax, %gs
    7e83:	8e e8                	mov    %eax,%gs
	movw	%ax, %ss
    7e85:	8e d0                	mov    %eax,%ss

	/*
	 * jump to the C part
	 * (dev, lba, smap)
	 */
	pushl	$smap
    7e87:	68 26 7f 00 00       	push   $0x7f26
	pushl	$BOOT0
    7e8c:	68 00 7c 00 00       	push   $0x7c00
	movl	(BOOT0-4), %eax
    7e91:	a1 fc 7b 00 00       	mov    0x7bfc,%eax
	pushl	%eax
    7e96:	50                   	push   %eax
	call	boot1main
    7e97:	e8 dd 0f 00 00       	call   8e79 <boot1main>

00007e9c <spin>:

spin:
	hlt
    7e9c:	f4                   	hlt

00007e9d <putstr>:
/*
 * print a string (@ %si) to the screen
 */
	.globl putstr
putstr:
	pusha
    7e9d:	60                   	pusha
	movb	$0xe, %ah
    7e9e:	b4 0e                	mov    $0xe,%ah

00007ea0 <putstr.1>:
putstr.1:
	lodsb
    7ea0:	ac                   	lods   %ds:(%esi),%al
	cmp	$0, %al
    7ea1:	3c 00                	cmp    $0x0,%al
	je	putstr.2
    7ea3:	74 04                	je     7ea9 <putstr.2>
	int	$0x10
    7ea5:	cd 10                	int    $0x10
	jmp	putstr.1
    7ea7:	eb f7                	jmp    7ea0 <putstr.1>

00007ea9 <putstr.2>:
putstr.2:
	popa
    7ea9:	61                   	popa
	ret
    7eaa:	c3                   	ret

00007eab <STARTUP_MSG>:
    7eab:	53                   	push   %ebx
    7eac:	74 61                	je     7f0f <gdt+0x17>
    7eae:	72 74                	jb     7f24 <gdtdesc+0x4>
    7eb0:	20 62 6f             	and    %ah,0x6f(%edx)
    7eb3:	6f                   	outsl  %ds:(%esi),(%dx)
    7eb4:	74 31                	je     7ee7 <NO_BOOTABLE_MSG+0x8>
    7eb6:	20 2e                	and    %ch,(%esi)
    7eb8:	2e 2e 0d 0a 00   	cs cs or $0x7265000a,%eax

00007ebd <E820_FAIL_MSG>:
    7ebd:	65 72 72             	gs jb  7f32 <smap+0xc>
    7ec0:	6f                   	outsl  %ds:(%esi),(%dx)
    7ec1:	72 20                	jb     7ee3 <NO_BOOTABLE_MSG+0x4>
    7ec3:	77 68                	ja     7f2d <smap+0x7>
    7ec5:	65 6e                	outsb  %gs:(%esi),(%dx)
    7ec7:	20 64 65 74          	and    %ah,0x74(%ebp,%eiz,2)
    7ecb:	65 63 74 69 6e       	arpl   %esi,%gs:0x6e(%ecx,%ebp,2)
    7ed0:	67 20 6d 65          	and    %ch,0x65(%di)
    7ed4:	6d                   	insl   (%dx),%es:(%edi)
    7ed5:	6f                   	outsl  %ds:(%esi),(%dx)
    7ed6:	72 79                	jb     7f51 <smap+0x2b>
    7ed8:	20 6d 61             	and    %ch,0x61(%ebp)
    7edb:	70 0d                	jo     7eea <NO_BOOTABLE_MSG+0xb>
    7edd:	0a 00                	or     (%eax),%al

00007edf <NO_BOOTABLE_MSG>:
    7edf:	4e                   	dec    %esi
    7ee0:	6f                   	outsl  %ds:(%esi),(%dx)
    7ee1:	20 62 6f             	and    %ah,0x6f(%edx)
    7ee4:	6f                   	outsl  %ds:(%esi),(%dx)
    7ee5:	74 61                	je     7f48 <smap+0x22>
    7ee7:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
    7eeb:	70 61                	jo     7f4e <smap+0x28>
    7eed:	72 74                	jb     7f63 <smap+0x3d>
    7eef:	69 74 69 6f 6e 2e 0d 	imul   $0xa0d2e6e,0x6f(%ecx,%ebp,2),%esi
    7ef6:	0a 
    7ef7:	00                 	add    %al,(%eax)

00007ef8 <gdt>:
    7ef8:	00 00                	add    %al,(%eax)
    7efa:	00 00                	add    %al,(%eax)
    7efc:	00 00                	add    %al,(%eax)
    7efe:	00 00                	add    %al,(%eax)
    7f00:	ff                   	(bad)
    7f01:	ff 00                	incl   (%eax)
    7f03:	00 00                	add    %al,(%eax)
    7f05:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7f0c:	00 92 cf 00 ff ff    	add    %dl,-0xff31(%edx)
    7f12:	00 00                	add    %al,(%eax)
    7f14:	00 9e 00 00 ff ff    	add    %bl,-0x10000(%esi)
    7f1a:	00 00                	add    %al,(%eax)
    7f1c:	00 92 00 00      	add    %dl,0x270000(%edx)

00007f20 <gdtdesc>:
    7f20:	27                   	daa
    7f21:	00 f8                	add    %bh,%al
    7f23:	7e 00                	jle    7f25 <gdtdesc+0x5>
    7f25:	00                 	add    %al,(%eax)

00007f26 <smap>:
    7f26:	00 00                	add    %al,(%eax)
    7f28:	00 00                	add    %al,(%eax)
    7f2a:	00 00                	add    %al,(%eax)
    7f2c:	00 00                	add    %al,(%eax)
    7f2e:	00 00                	add    %al,(%eax)
    7f30:	00 00                	add    %al,(%eax)
    7f32:	00 00                	add    %al,(%eax)
    7f34:	00 00                	add    %al,(%eax)
    7f36:	00 00                	add    %al,(%eax)
    7f38:	00 00                	add    %al,(%eax)
    7f3a:	00 00                	add    %al,(%eax)
    7f3c:	00 00                	add    %al,(%eax)
    7f3e:	00 00                	add    %al,(%eax)
    7f40:	00 00                	add    %al,(%eax)
    7f42:	00 00                	add    %al,(%eax)
    7f44:	00 00                	add    %al,(%eax)
    7f46:	00 00                	add    %al,(%eax)
    7f48:	00 00                	add    %al,(%eax)
    7f4a:	00 00                	add    %al,(%eax)
    7f4c:	00 00                	add    %al,(%eax)
    7f4e:	00 00                	add    %al,(%eax)
    7f50:	00 00                	add    %al,(%eax)
    7f52:	00 00                	add    %al,(%eax)
    7f54:	00 00                	add    %al,(%eax)
    7f56:	00 00                	add    %al,(%eax)
    7f58:	00 00                	add    %al,(%eax)
    7f5a:	00 00                	add    %al,(%eax)
    7f5c:	00 00                	add    %al,(%eax)
    7f5e:	00 00                	add    %al,(%eax)
    7f60:	00 00                	add    %al,(%eax)
    7f62:	00 00                	add    %al,(%eax)
    7f64:	00 00                	add    %al,(%eax)
    7f66:	00 00                	add    %al,(%eax)
    7f68:	00 00                	add    %al,(%eax)
    7f6a:	00 00                	add    %al,(%eax)
    7f6c:	00 00                	add    %al,(%eax)
    7f6e:	00 00                	add    %al,(%eax)
    7f70:	00 00                	add    %al,(%eax)
    7f72:	00 00                	add    %al,(%eax)
    7f74:	00 00                	add    %al,(%eax)
    7f76:	00 00                	add    %al,(%eax)
    7f78:	00 00                	add    %al,(%eax)
    7f7a:	00 00                	add    %al,(%eax)
    7f7c:	00 00                	add    %al,(%eax)
    7f7e:	00 00                	add    %al,(%eax)
    7f80:	00 00                	add    %al,(%eax)
    7f82:	00 00                	add    %al,(%eax)
    7f84:	00 00                	add    %al,(%eax)
    7f86:	00 00                	add    %al,(%eax)
    7f88:	00 00                	add    %al,(%eax)
    7f8a:	00 00                	add    %al,(%eax)
    7f8c:	00 00                	add    %al,(%eax)
    7f8e:	00 00                	add    %al,(%eax)
    7f90:	00 00                	add    %al,(%eax)
    7f92:	00 00                	add    %al,(%eax)
    7f94:	00 00                	add    %al,(%eax)
    7f96:	00 00                	add    %al,(%eax)
    7f98:	00 00                	add    %al,(%eax)
    7f9a:	00 00                	add    %al,(%eax)
    7f9c:	00 00                	add    %al,(%eax)
    7f9e:	00 00                	add    %al,(%eax)
    7fa0:	00 00                	add    %al,(%eax)
    7fa2:	00 00                	add    %al,(%eax)
    7fa4:	00 00                	add    %al,(%eax)
    7fa6:	00 00                	add    %al,(%eax)
    7fa8:	00 00                	add    %al,(%eax)
    7faa:	00 00                	add    %al,(%eax)
    7fac:	00 00                	add    %al,(%eax)
    7fae:	00 00                	add    %al,(%eax)
    7fb0:	00 00                	add    %al,(%eax)
    7fb2:	00 00                	add    %al,(%eax)
    7fb4:	00 00                	add    %al,(%eax)
    7fb6:	00 00                	add    %al,(%eax)
    7fb8:	00 00                	add    %al,(%eax)
    7fba:	00 00                	add    %al,(%eax)
    7fbc:	00 00                	add    %al,(%eax)
    7fbe:	00 00                	add    %al,(%eax)
    7fc0:	00 00                	add    %al,(%eax)
    7fc2:	00 00                	add    %al,(%eax)
    7fc4:	00 00                	add    %al,(%eax)
    7fc6:	00 00                	add    %al,(%eax)
    7fc8:	00 00                	add    %al,(%eax)
    7fca:	00 00                	add    %al,(%eax)
    7fcc:	00 00                	add    %al,(%eax)
    7fce:	00 00                	add    %al,(%eax)
    7fd0:	00 00                	add    %al,(%eax)
    7fd2:	00 00                	add    %al,(%eax)
    7fd4:	00 00                	add    %al,(%eax)
    7fd6:	00 00                	add    %al,(%eax)
    7fd8:	00 00                	add    %al,(%eax)
    7fda:	00 00                	add    %al,(%eax)
    7fdc:	00 00                	add    %al,(%eax)
    7fde:	00 00                	add    %al,(%eax)
    7fe0:	00 00                	add    %al,(%eax)
    7fe2:	00 00                	add    %al,(%eax)
    7fe4:	00 00                	add    %al,(%eax)
    7fe6:	00 00                	add    %al,(%eax)
    7fe8:	00 00                	add    %al,(%eax)
    7fea:	00 00                	add    %al,(%eax)
    7fec:	00 00                	add    %al,(%eax)
    7fee:	00 00                	add    %al,(%eax)
    7ff0:	00 00                	add    %al,(%eax)
    7ff2:	00 00                	add    %al,(%eax)
    7ff4:	00 00                	add    %al,(%eax)
    7ff6:	00 00                	add    %al,(%eax)
    7ff8:	00 00                	add    %al,(%eax)
    7ffa:	00 00                	add    %al,(%eax)
    7ffc:	00 00                	add    %al,(%eax)
    7ffe:	00 00                	add    %al,(%eax)
    8000:	00 00                	add    %al,(%eax)
    8002:	00 00                	add    %al,(%eax)
    8004:	00 00                	add    %al,(%eax)
    8006:	00 00                	add    %al,(%eax)
    8008:	00 00                	add    %al,(%eax)
    800a:	00 00                	add    %al,(%eax)
    800c:	00 00                	add    %al,(%eax)
    800e:	00 00                	add    %al,(%eax)
    8010:	00 00                	add    %al,(%eax)
    8012:	00 00                	add    %al,(%eax)
    8014:	00 00                	add    %al,(%eax)
    8016:	00 00                	add    %al,(%eax)
    8018:	00 00                	add    %al,(%eax)
    801a:	00 00                	add    %al,(%eax)
    801c:	00 00                	add    %al,(%eax)
    801e:	00 00                	add    %al,(%eax)
    8020:	00 00                	add    %al,(%eax)
    8022:	00 00                	add    %al,(%eax)
    8024:	00 00                	add    %al,(%eax)
    8026:	00 00                	add    %al,(%eax)
    8028:	00 00                	add    %al,(%eax)
    802a:	00 00                	add    %al,(%eax)
    802c:	00 00                	add    %al,(%eax)
    802e:	00 00                	add    %al,(%eax)
    8030:	00 00                	add    %al,(%eax)
    8032:	00 00                	add    %al,(%eax)
    8034:	00 00                	add    %al,(%eax)
    8036:	00 00                	add    %al,(%eax)
    8038:	00 00                	add    %al,(%eax)
    803a:	00 00                	add    %al,(%eax)
    803c:	00 00                	add    %al,(%eax)
    803e:	00 00                	add    %al,(%eax)
    8040:	00 00                	add    %al,(%eax)
    8042:	00 00                	add    %al,(%eax)
    8044:	00 00                	add    %al,(%eax)
    8046:	00 00                	add    %al,(%eax)
    8048:	00 00                	add    %al,(%eax)
    804a:	00 00                	add    %al,(%eax)
    804c:	00 00                	add    %al,(%eax)
    804e:	00 00                	add    %al,(%eax)
    8050:	00 00                	add    %al,(%eax)
    8052:	00 00                	add    %al,(%eax)
    8054:	00 00                	add    %al,(%eax)
    8056:	00 00                	add    %al,(%eax)
    8058:	00 00                	add    %al,(%eax)
    805a:	00 00                	add    %al,(%eax)
    805c:	00 00                	add    %al,(%eax)
    805e:	00 00                	add    %al,(%eax)
    8060:	00 00                	add    %al,(%eax)
    8062:	00 00                	add    %al,(%eax)
    8064:	00 00                	add    %al,(%eax)
    8066:	00 00                	add    %al,(%eax)
    8068:	00 00                	add    %al,(%eax)
    806a:	00 00                	add    %al,(%eax)
    806c:	00 00                	add    %al,(%eax)
    806e:	00 00                	add    %al,(%eax)
    8070:	00 00                	add    %al,(%eax)
    8072:	00 00                	add    %al,(%eax)
    8074:	00 00                	add    %al,(%eax)
    8076:	00 00                	add    %al,(%eax)
    8078:	00 00                	add    %al,(%eax)
    807a:	00 00                	add    %al,(%eax)
    807c:	00 00                	add    %al,(%eax)
    807e:	00 00                	add    %al,(%eax)
    8080:	00 00                	add    %al,(%eax)
    8082:	00 00                	add    %al,(%eax)
    8084:	00 00                	add    %al,(%eax)
    8086:	00 00                	add    %al,(%eax)
    8088:	00 00                	add    %al,(%eax)
    808a:	00 00                	add    %al,(%eax)
    808c:	00 00                	add    %al,(%eax)
    808e:	00 00                	add    %al,(%eax)
    8090:	00 00                	add    %al,(%eax)
    8092:	00 00                	add    %al,(%eax)
    8094:	00 00                	add    %al,(%eax)
    8096:	00 00                	add    %al,(%eax)
    8098:	00 00                	add    %al,(%eax)
    809a:	00 00                	add    %al,(%eax)
    809c:	00 00                	add    %al,(%eax)
    809e:	00 00                	add    %al,(%eax)
    80a0:	00 00                	add    %al,(%eax)
    80a2:	00 00                	add    %al,(%eax)
    80a4:	00 00                	add    %al,(%eax)
    80a6:	00 00                	add    %al,(%eax)
    80a8:	00 00                	add    %al,(%eax)
    80aa:	00 00                	add    %al,(%eax)
    80ac:	00 00                	add    %al,(%eax)
    80ae:	00 00                	add    %al,(%eax)
    80b0:	00 00                	add    %al,(%eax)
    80b2:	00 00                	add    %al,(%eax)
    80b4:	00 00                	add    %al,(%eax)
    80b6:	00 00                	add    %al,(%eax)
    80b8:	00 00                	add    %al,(%eax)
    80ba:	00 00                	add    %al,(%eax)
    80bc:	00 00                	add    %al,(%eax)
    80be:	00 00                	add    %al,(%eax)
    80c0:	00 00                	add    %al,(%eax)
    80c2:	00 00                	add    %al,(%eax)
    80c4:	00 00                	add    %al,(%eax)
    80c6:	00 00                	add    %al,(%eax)
    80c8:	00 00                	add    %al,(%eax)
    80ca:	00 00                	add    %al,(%eax)
    80cc:	00 00                	add    %al,(%eax)
    80ce:	00 00                	add    %al,(%eax)
    80d0:	00 00                	add    %al,(%eax)
    80d2:	00 00                	add    %al,(%eax)
    80d4:	00 00                	add    %al,(%eax)
    80d6:	00 00                	add    %al,(%eax)
    80d8:	00 00                	add    %al,(%eax)
    80da:	00 00                	add    %al,(%eax)
    80dc:	00 00                	add    %al,(%eax)
    80de:	00 00                	add    %al,(%eax)
    80e0:	00 00                	add    %al,(%eax)
    80e2:	00 00                	add    %al,(%eax)
    80e4:	00 00                	add    %al,(%eax)
    80e6:	00 00                	add    %al,(%eax)
    80e8:	00 00                	add    %al,(%eax)
    80ea:	00 00                	add    %al,(%eax)
    80ec:	00 00                	add    %al,(%eax)
    80ee:	00 00                	add    %al,(%eax)
    80f0:	00 00                	add    %al,(%eax)
    80f2:	00 00                	add    %al,(%eax)
    80f4:	00 00                	add    %al,(%eax)
    80f6:	00 00                	add    %al,(%eax)
    80f8:	00 00                	add    %al,(%eax)
    80fa:	00 00                	add    %al,(%eax)
    80fc:	00 00                	add    %al,(%eax)
    80fe:	00 00                	add    %al,(%eax)
    8100:	00 00                	add    %al,(%eax)
    8102:	00 00                	add    %al,(%eax)
    8104:	00 00                	add    %al,(%eax)
    8106:	00 00                	add    %al,(%eax)
    8108:	00 00                	add    %al,(%eax)
    810a:	00 00                	add    %al,(%eax)
    810c:	00 00                	add    %al,(%eax)
    810e:	00 00                	add    %al,(%eax)
    8110:	00 00                	add    %al,(%eax)
    8112:	00 00                	add    %al,(%eax)
    8114:	00 00                	add    %al,(%eax)
    8116:	00 00                	add    %al,(%eax)
    8118:	00 00                	add    %al,(%eax)
    811a:	00 00                	add    %al,(%eax)
    811c:	00 00                	add    %al,(%eax)
    811e:	00 00                	add    %al,(%eax)
    8120:	00 00                	add    %al,(%eax)
    8122:	00 00                	add    %al,(%eax)
    8124:	00 00                	add    %al,(%eax)
    8126:	00 00                	add    %al,(%eax)
    8128:	00 00                	add    %al,(%eax)
    812a:	00 00                	add    %al,(%eax)
    812c:	00 00                	add    %al,(%eax)
    812e:	00 00                	add    %al,(%eax)
    8130:	00 00                	add    %al,(%eax)
    8132:	00 00                	add    %al,(%eax)
    8134:	00 00                	add    %al,(%eax)
    8136:	00 00                	add    %al,(%eax)
    8138:	00 00                	add    %al,(%eax)
    813a:	00 00                	add    %al,(%eax)
    813c:	00 00                	add    %al,(%eax)
    813e:	00 00                	add    %al,(%eax)
    8140:	00 00                	add    %al,(%eax)
    8142:	00 00                	add    %al,(%eax)
    8144:	00 00                	add    %al,(%eax)
    8146:	00 00                	add    %al,(%eax)
    8148:	00 00                	add    %al,(%eax)
    814a:	00 00                	add    %al,(%eax)
    814c:	00 00                	add    %al,(%eax)
    814e:	00 00                	add    %al,(%eax)
    8150:	00 00                	add    %al,(%eax)
    8152:	00 00                	add    %al,(%eax)
    8154:	00 00                	add    %al,(%eax)
    8156:	00 00                	add    %al,(%eax)
    8158:	00 00                	add    %al,(%eax)
    815a:	00 00                	add    %al,(%eax)
    815c:	00 00                	add    %al,(%eax)
    815e:	00 00                	add    %al,(%eax)
    8160:	00 00                	add    %al,(%eax)
    8162:	00 00                	add    %al,(%eax)
    8164:	00 00                	add    %al,(%eax)
    8166:	00 00                	add    %al,(%eax)
    8168:	00 00                	add    %al,(%eax)
    816a:	00 00                	add    %al,(%eax)
    816c:	00 00                	add    %al,(%eax)
    816e:	00 00                	add    %al,(%eax)
    8170:	00 00                	add    %al,(%eax)
    8172:	00 00                	add    %al,(%eax)
    8174:	00 00                	add    %al,(%eax)
    8176:	00 00                	add    %al,(%eax)
    8178:	00 00                	add    %al,(%eax)
    817a:	00 00                	add    %al,(%eax)
    817c:	00 00                	add    %al,(%eax)
    817e:	00 00                	add    %al,(%eax)
    8180:	00 00                	add    %al,(%eax)
    8182:	00 00                	add    %al,(%eax)
    8184:	00 00                	add    %al,(%eax)
    8186:	00 00                	add    %al,(%eax)
    8188:	00 00                	add    %al,(%eax)
    818a:	00 00                	add    %al,(%eax)
    818c:	00 00                	add    %al,(%eax)
    818e:	00 00                	add    %al,(%eax)
    8190:	00 00                	add    %al,(%eax)
    8192:	00 00                	add    %al,(%eax)
    8194:	00 00                	add    %al,(%eax)
    8196:	00 00                	add    %al,(%eax)
    8198:	00 00                	add    %al,(%eax)
    819a:	00 00                	add    %al,(%eax)
    819c:	00 00                	add    %al,(%eax)
    819e:	00 00                	add    %al,(%eax)
    81a0:	00 00                	add    %al,(%eax)
    81a2:	00 00                	add    %al,(%eax)
    81a4:	00 00                	add    %al,(%eax)
    81a6:	00 00                	add    %al,(%eax)
    81a8:	00 00                	add    %al,(%eax)
    81aa:	00 00                	add    %al,(%eax)
    81ac:	00 00                	add    %al,(%eax)
    81ae:	00 00                	add    %al,(%eax)
    81b0:	00 00                	add    %al,(%eax)
    81b2:	00 00                	add    %al,(%eax)
    81b4:	00 00                	add    %al,(%eax)
    81b6:	00 00                	add    %al,(%eax)
    81b8:	00 00                	add    %al,(%eax)
    81ba:	00 00                	add    %al,(%eax)
    81bc:	00 00                	add    %al,(%eax)
    81be:	00 00                	add    %al,(%eax)
    81c0:	00 00                	add    %al,(%eax)
    81c2:	00 00                	add    %al,(%eax)
    81c4:	00 00                	add    %al,(%eax)
    81c6:	00 00                	add    %al,(%eax)
    81c8:	00 00                	add    %al,(%eax)
    81ca:	00 00                	add    %al,(%eax)
    81cc:	00 00                	add    %al,(%eax)
    81ce:	00 00                	add    %al,(%eax)
    81d0:	00 00                	add    %al,(%eax)
    81d2:	00 00                	add    %al,(%eax)
    81d4:	00 00                	add    %al,(%eax)
    81d6:	00 00                	add    %al,(%eax)
    81d8:	00 00                	add    %al,(%eax)
    81da:	00 00                	add    %al,(%eax)
    81dc:	00 00                	add    %al,(%eax)
    81de:	00 00                	add    %al,(%eax)
    81e0:	00 00                	add    %al,(%eax)
    81e2:	00 00                	add    %al,(%eax)
    81e4:	00 00                	add    %al,(%eax)
    81e6:	00 00                	add    %al,(%eax)
    81e8:	00 00                	add    %al,(%eax)
    81ea:	00 00                	add    %al,(%eax)
    81ec:	00 00                	add    %al,(%eax)
    81ee:	00 00                	add    %al,(%eax)
    81f0:	00 00                	add    %al,(%eax)
    81f2:	00 00                	add    %al,(%eax)
    81f4:	00 00                	add    %al,(%eax)
    81f6:	00 00                	add    %al,(%eax)
    81f8:	00 00                	add    %al,(%eax)
    81fa:	00 00                	add    %al,(%eax)
    81fc:	00 00                	add    %al,(%eax)
    81fe:	00 00                	add    %al,(%eax)
    8200:	00 00                	add    %al,(%eax)
    8202:	00 00                	add    %al,(%eax)
    8204:	00 00                	add    %al,(%eax)
    8206:	00 00                	add    %al,(%eax)
    8208:	00 00                	add    %al,(%eax)
    820a:	00 00                	add    %al,(%eax)
    820c:	00 00                	add    %al,(%eax)
    820e:	00 00                	add    %al,(%eax)
    8210:	00 00                	add    %al,(%eax)
    8212:	00 00                	add    %al,(%eax)
    8214:	00 00                	add    %al,(%eax)
    8216:	00 00                	add    %al,(%eax)
    8218:	00 00                	add    %al,(%eax)
    821a:	00 00                	add    %al,(%eax)
    821c:	00 00                	add    %al,(%eax)
    821e:	00 00                	add    %al,(%eax)
    8220:	00 00                	add    %al,(%eax)
    8222:	00 00                	add    %al,(%eax)
    8224:	00 00                	add    %al,(%eax)
    8226:	00 00                	add    %al,(%eax)
    8228:	00 00                	add    %al,(%eax)
    822a:	00 00                	add    %al,(%eax)
    822c:	00 00                	add    %al,(%eax)
    822e:	00 00                	add    %al,(%eax)
    8230:	00 00                	add    %al,(%eax)
    8232:	00 00                	add    %al,(%eax)
    8234:	00 00                	add    %al,(%eax)
    8236:	00 00                	add    %al,(%eax)
    8238:	00 00                	add    %al,(%eax)
    823a:	00 00                	add    %al,(%eax)
    823c:	00 00                	add    %al,(%eax)
    823e:	00 00                	add    %al,(%eax)
    8240:	00 00                	add    %al,(%eax)
    8242:	00 00                	add    %al,(%eax)
    8244:	00 00                	add    %al,(%eax)
    8246:	00 00                	add    %al,(%eax)
    8248:	00 00                	add    %al,(%eax)
    824a:	00 00                	add    %al,(%eax)
    824c:	00 00                	add    %al,(%eax)
    824e:	00 00                	add    %al,(%eax)
    8250:	00 00                	add    %al,(%eax)
    8252:	00 00                	add    %al,(%eax)
    8254:	00 00                	add    %al,(%eax)
    8256:	00 00                	add    %al,(%eax)
    8258:	00 00                	add    %al,(%eax)
    825a:	00 00                	add    %al,(%eax)
    825c:	00 00                	add    %al,(%eax)
    825e:	00 00                	add    %al,(%eax)
    8260:	00 00                	add    %al,(%eax)
    8262:	00 00                	add    %al,(%eax)
    8264:	00 00                	add    %al,(%eax)
    8266:	00 00                	add    %al,(%eax)
    8268:	00 00                	add    %al,(%eax)
    826a:	00 00                	add    %al,(%eax)
    826c:	00 00                	add    %al,(%eax)
    826e:	00 00                	add    %al,(%eax)
    8270:	00 00                	add    %al,(%eax)
    8272:	00 00                	add    %al,(%eax)
    8274:	00 00                	add    %al,(%eax)
    8276:	00 00                	add    %al,(%eax)
    8278:	00 00                	add    %al,(%eax)
    827a:	00 00                	add    %al,(%eax)
    827c:	00 00                	add    %al,(%eax)
    827e:	00 00                	add    %al,(%eax)
    8280:	00 00                	add    %al,(%eax)
    8282:	00 00                	add    %al,(%eax)
    8284:	00 00                	add    %al,(%eax)
    8286:	00 00                	add    %al,(%eax)
    8288:	00 00                	add    %al,(%eax)
    828a:	00 00                	add    %al,(%eax)
    828c:	00 00                	add    %al,(%eax)
    828e:	00 00                	add    %al,(%eax)
    8290:	00 00                	add    %al,(%eax)
    8292:	00 00                	add    %al,(%eax)
    8294:	00 00                	add    %al,(%eax)
    8296:	00 00                	add    %al,(%eax)
    8298:	00 00                	add    %al,(%eax)
    829a:	00 00                	add    %al,(%eax)
    829c:	00 00                	add    %al,(%eax)
    829e:	00 00                	add    %al,(%eax)
    82a0:	00 00                	add    %al,(%eax)
    82a2:	00 00                	add    %al,(%eax)
    82a4:	00 00                	add    %al,(%eax)
    82a6:	00 00                	add    %al,(%eax)
    82a8:	00 00                	add    %al,(%eax)
    82aa:	00 00                	add    %al,(%eax)
    82ac:	00 00                	add    %al,(%eax)
    82ae:	00 00                	add    %al,(%eax)
    82b0:	00 00                	add    %al,(%eax)
    82b2:	00 00                	add    %al,(%eax)
    82b4:	00 00                	add    %al,(%eax)
    82b6:	00 00                	add    %al,(%eax)
    82b8:	00 00                	add    %al,(%eax)
    82ba:	00 00                	add    %al,(%eax)
    82bc:	00 00                	add    %al,(%eax)
    82be:	00 00                	add    %al,(%eax)
    82c0:	00 00                	add    %al,(%eax)
    82c2:	00 00                	add    %al,(%eax)
    82c4:	00 00                	add    %al,(%eax)
    82c6:	00 00                	add    %al,(%eax)
    82c8:	00 00                	add    %al,(%eax)
    82ca:	00 00                	add    %al,(%eax)
    82cc:	00 00                	add    %al,(%eax)
    82ce:	00 00                	add    %al,(%eax)
    82d0:	00 00                	add    %al,(%eax)
    82d2:	00 00                	add    %al,(%eax)
    82d4:	00 00                	add    %al,(%eax)
    82d6:	00 00                	add    %al,(%eax)
    82d8:	00 00                	add    %al,(%eax)
    82da:	00 00                	add    %al,(%eax)
    82dc:	00 00                	add    %al,(%eax)
    82de:	00 00                	add    %al,(%eax)
    82e0:	00 00                	add    %al,(%eax)
    82e2:	00 00                	add    %al,(%eax)
    82e4:	00 00                	add    %al,(%eax)
    82e6:	00 00                	add    %al,(%eax)
    82e8:	00 00                	add    %al,(%eax)
    82ea:	00 00                	add    %al,(%eax)
    82ec:	00 00                	add    %al,(%eax)
    82ee:	00 00                	add    %al,(%eax)
    82f0:	00 00                	add    %al,(%eax)
    82f2:	00 00                	add    %al,(%eax)
    82f4:	00 00                	add    %al,(%eax)
    82f6:	00 00                	add    %al,(%eax)
    82f8:	00 00                	add    %al,(%eax)
    82fa:	00 00                	add    %al,(%eax)
    82fc:	00 00                	add    %al,(%eax)
    82fe:	00 00                	add    %al,(%eax)
    8300:	00 00                	add    %al,(%eax)
    8302:	00 00                	add    %al,(%eax)
    8304:	00 00                	add    %al,(%eax)
    8306:	00 00                	add    %al,(%eax)
    8308:	00 00                	add    %al,(%eax)
    830a:	00 00                	add    %al,(%eax)
    830c:	00 00                	add    %al,(%eax)
    830e:	00 00                	add    %al,(%eax)
    8310:	00 00                	add    %al,(%eax)
    8312:	00 00                	add    %al,(%eax)
    8314:	00 00                	add    %al,(%eax)
    8316:	00 00                	add    %al,(%eax)
    8318:	00 00                	add    %al,(%eax)
    831a:	00 00                	add    %al,(%eax)
    831c:	00 00                	add    %al,(%eax)
    831e:	00 00                	add    %al,(%eax)
    8320:	00 00                	add    %al,(%eax)
    8322:	00 00                	add    %al,(%eax)
    8324:	00 00                	add    %al,(%eax)
    8326:	00 00                	add    %al,(%eax)
    8328:	00 00                	add    %al,(%eax)
    832a:	00 00                	add    %al,(%eax)
    832c:	00 00                	add    %al,(%eax)
    832e:	00 00                	add    %al,(%eax)
    8330:	00 00                	add    %al,(%eax)
    8332:	00 00                	add    %al,(%eax)
    8334:	00 00                	add    %al,(%eax)
    8336:	00 00                	add    %al,(%eax)
    8338:	00 00                	add    %al,(%eax)
    833a:	00 00                	add    %al,(%eax)
    833c:	00 00                	add    %al,(%eax)
    833e:	00 00                	add    %al,(%eax)
    8340:	00 00                	add    %al,(%eax)
    8342:	00 00                	add    %al,(%eax)
    8344:	00 00                	add    %al,(%eax)
    8346:	00 00                	add    %al,(%eax)
    8348:	00 00                	add    %al,(%eax)
    834a:	00 00                	add    %al,(%eax)
    834c:	00 00                	add    %al,(%eax)
    834e:	00 00                	add    %al,(%eax)
    8350:	00 00                	add    %al,(%eax)
    8352:	00 00                	add    %al,(%eax)
    8354:	00 00                	add    %al,(%eax)
    8356:	00 00                	add    %al,(%eax)
    8358:	00 00                	add    %al,(%eax)
    835a:	00 00                	add    %al,(%eax)
    835c:	00 00                	add    %al,(%eax)
    835e:	00 00                	add    %al,(%eax)
    8360:	00 00                	add    %al,(%eax)
    8362:	00 00                	add    %al,(%eax)
    8364:	00 00                	add    %al,(%eax)
    8366:	00 00                	add    %al,(%eax)
    8368:	00 00                	add    %al,(%eax)
    836a:	00 00                	add    %al,(%eax)
    836c:	00 00                	add    %al,(%eax)
    836e:	00 00                	add    %al,(%eax)
    8370:	00 00                	add    %al,(%eax)
    8372:	00 00                	add    %al,(%eax)
    8374:	00 00                	add    %al,(%eax)
    8376:	00 00                	add    %al,(%eax)
    8378:	00 00                	add    %al,(%eax)
    837a:	00 00                	add    %al,(%eax)
    837c:	00 00                	add    %al,(%eax)
    837e:	00 00                	add    %al,(%eax)
    8380:	00 00                	add    %al,(%eax)
    8382:	00 00                	add    %al,(%eax)
    8384:	00 00                	add    %al,(%eax)
    8386:	00 00                	add    %al,(%eax)
    8388:	00 00                	add    %al,(%eax)
    838a:	00 00                	add    %al,(%eax)
    838c:	00 00                	add    %al,(%eax)
    838e:	00 00                	add    %al,(%eax)
    8390:	00 00                	add    %al,(%eax)
    8392:	00 00                	add    %al,(%eax)
    8394:	00 00                	add    %al,(%eax)
    8396:	00 00                	add    %al,(%eax)
    8398:	00 00                	add    %al,(%eax)
    839a:	00 00                	add    %al,(%eax)
    839c:	00 00                	add    %al,(%eax)
    839e:	00 00                	add    %al,(%eax)
    83a0:	00 00                	add    %al,(%eax)
    83a2:	00 00                	add    %al,(%eax)
    83a4:	00 00                	add    %al,(%eax)
    83a6:	00 00                	add    %al,(%eax)
    83a8:	00 00                	add    %al,(%eax)
    83aa:	00 00                	add    %al,(%eax)
    83ac:	00 00                	add    %al,(%eax)
    83ae:	00 00                	add    %al,(%eax)
    83b0:	00 00                	add    %al,(%eax)
    83b2:	00 00                	add    %al,(%eax)
    83b4:	00 00                	add    %al,(%eax)
    83b6:	00 00                	add    %al,(%eax)
    83b8:	00 00                	add    %al,(%eax)
    83ba:	00 00                	add    %al,(%eax)
    83bc:	00 00                	add    %al,(%eax)
    83be:	00 00                	add    %al,(%eax)
    83c0:	00 00                	add    %al,(%eax)
    83c2:	00 00                	add    %al,(%eax)
    83c4:	00 00                	add    %al,(%eax)
    83c6:	00 00                	add    %al,(%eax)
    83c8:	00 00                	add    %al,(%eax)
    83ca:	00 00                	add    %al,(%eax)
    83cc:	00 00                	add    %al,(%eax)
    83ce:	00 00                	add    %al,(%eax)
    83d0:	00 00                	add    %al,(%eax)
    83d2:	00 00                	add    %al,(%eax)
    83d4:	00 00                	add    %al,(%eax)
    83d6:	00 00                	add    %al,(%eax)
    83d8:	00 00                	add    %al,(%eax)
    83da:	00 00                	add    %al,(%eax)
    83dc:	00 00                	add    %al,(%eax)
    83de:	00 00                	add    %al,(%eax)
    83e0:	00 00                	add    %al,(%eax)
    83e2:	00 00                	add    %al,(%eax)
    83e4:	00 00                	add    %al,(%eax)
    83e6:	00 00                	add    %al,(%eax)
    83e8:	00 00                	add    %al,(%eax)
    83ea:	00 00                	add    %al,(%eax)
    83ec:	00 00                	add    %al,(%eax)
    83ee:	00 00                	add    %al,(%eax)
    83f0:	00 00                	add    %al,(%eax)
    83f2:	00 00                	add    %al,(%eax)
    83f4:	00 00                	add    %al,(%eax)
    83f6:	00 00                	add    %al,(%eax)
    83f8:	00 00                	add    %al,(%eax)
    83fa:	00 00                	add    %al,(%eax)
    83fc:	00 00                	add    %al,(%eax)
    83fe:	00 00                	add    %al,(%eax)
    8400:	00 00                	add    %al,(%eax)
    8402:	00 00                	add    %al,(%eax)
    8404:	00 00                	add    %al,(%eax)
    8406:	00 00                	add    %al,(%eax)
    8408:	00 00                	add    %al,(%eax)
    840a:	00 00                	add    %al,(%eax)
    840c:	00 00                	add    %al,(%eax)
    840e:	00 00                	add    %al,(%eax)
    8410:	00 00                	add    %al,(%eax)
    8412:	00 00                	add    %al,(%eax)
    8414:	00 00                	add    %al,(%eax)
    8416:	00 00                	add    %al,(%eax)
    8418:	00 00                	add    %al,(%eax)
    841a:	00 00                	add    %al,(%eax)
    841c:	00 00                	add    %al,(%eax)
    841e:	00 00                	add    %al,(%eax)
    8420:	00 00                	add    %al,(%eax)
    8422:	00 00                	add    %al,(%eax)
    8424:	00 00                	add    %al,(%eax)
    8426:	00 00                	add    %al,(%eax)
    8428:	00 00                	add    %al,(%eax)
    842a:	00 00                	add    %al,(%eax)
    842c:	00 00                	add    %al,(%eax)
    842e:	00 00                	add    %al,(%eax)
    8430:	00 00                	add    %al,(%eax)
    8432:	00 00                	add    %al,(%eax)
    8434:	00 00                	add    %al,(%eax)
    8436:	00 00                	add    %al,(%eax)
    8438:	00 00                	add    %al,(%eax)
    843a:	00 00                	add    %al,(%eax)
    843c:	00 00                	add    %al,(%eax)
    843e:	00 00                	add    %al,(%eax)
    8440:	00 00                	add    %al,(%eax)
    8442:	00 00                	add    %al,(%eax)
    8444:	00 00                	add    %al,(%eax)
    8446:	00 00                	add    %al,(%eax)
    8448:	00 00                	add    %al,(%eax)
    844a:	00 00                	add    %al,(%eax)
    844c:	00 00                	add    %al,(%eax)
    844e:	00 00                	add    %al,(%eax)
    8450:	00 00                	add    %al,(%eax)
    8452:	00 00                	add    %al,(%eax)
    8454:	00 00                	add    %al,(%eax)
    8456:	00 00                	add    %al,(%eax)
    8458:	00 00                	add    %al,(%eax)
    845a:	00 00                	add    %al,(%eax)
    845c:	00 00                	add    %al,(%eax)
    845e:	00 00                	add    %al,(%eax)
    8460:	00 00                	add    %al,(%eax)
    8462:	00 00                	add    %al,(%eax)
    8464:	00 00                	add    %al,(%eax)
    8466:	00 00                	add    %al,(%eax)
    8468:	00 00                	add    %al,(%eax)
    846a:	00 00                	add    %al,(%eax)
    846c:	00 00                	add    %al,(%eax)
    846e:	00 00                	add    %al,(%eax)
    8470:	00 00                	add    %al,(%eax)
    8472:	00 00                	add    %al,(%eax)
    8474:	00 00                	add    %al,(%eax)
    8476:	00 00                	add    %al,(%eax)
    8478:	00 00                	add    %al,(%eax)
    847a:	00 00                	add    %al,(%eax)
    847c:	00 00                	add    %al,(%eax)
    847e:	00 00                	add    %al,(%eax)
    8480:	00 00                	add    %al,(%eax)
    8482:	00 00                	add    %al,(%eax)
    8484:	00 00                	add    %al,(%eax)
    8486:	00 00                	add    %al,(%eax)
    8488:	00 00                	add    %al,(%eax)
    848a:	00 00                	add    %al,(%eax)
    848c:	00 00                	add    %al,(%eax)
    848e:	00 00                	add    %al,(%eax)
    8490:	00 00                	add    %al,(%eax)
    8492:	00 00                	add    %al,(%eax)
    8494:	00 00                	add    %al,(%eax)
    8496:	00 00                	add    %al,(%eax)
    8498:	00 00                	add    %al,(%eax)
    849a:	00 00                	add    %al,(%eax)
    849c:	00 00                	add    %al,(%eax)
    849e:	00 00                	add    %al,(%eax)
    84a0:	00 00                	add    %al,(%eax)
    84a2:	00 00                	add    %al,(%eax)
    84a4:	00 00                	add    %al,(%eax)
    84a6:	00 00                	add    %al,(%eax)
    84a8:	00 00                	add    %al,(%eax)
    84aa:	00 00                	add    %al,(%eax)
    84ac:	00 00                	add    %al,(%eax)
    84ae:	00 00                	add    %al,(%eax)
    84b0:	00 00                	add    %al,(%eax)
    84b2:	00 00                	add    %al,(%eax)
    84b4:	00 00                	add    %al,(%eax)
    84b6:	00 00                	add    %al,(%eax)
    84b8:	00 00                	add    %al,(%eax)
    84ba:	00 00                	add    %al,(%eax)
    84bc:	00 00                	add    %al,(%eax)
    84be:	00 00                	add    %al,(%eax)
    84c0:	00 00                	add    %al,(%eax)
    84c2:	00 00                	add    %al,(%eax)
    84c4:	00 00                	add    %al,(%eax)
    84c6:	00 00                	add    %al,(%eax)
    84c8:	00 00                	add    %al,(%eax)
    84ca:	00 00                	add    %al,(%eax)
    84cc:	00 00                	add    %al,(%eax)
    84ce:	00 00                	add    %al,(%eax)
    84d0:	00 00                	add    %al,(%eax)
    84d2:	00 00                	add    %al,(%eax)
    84d4:	00 00                	add    %al,(%eax)
    84d6:	00 00                	add    %al,(%eax)
    84d8:	00 00                	add    %al,(%eax)
    84da:	00 00                	add    %al,(%eax)
    84dc:	00 00                	add    %al,(%eax)
    84de:	00 00                	add    %al,(%eax)
    84e0:	00 00                	add    %al,(%eax)
    84e2:	00 00                	add    %al,(%eax)
    84e4:	00 00                	add    %al,(%eax)
    84e6:	00 00                	add    %al,(%eax)
    84e8:	00 00                	add    %al,(%eax)
    84ea:	00 00                	add    %al,(%eax)
    84ec:	00 00                	add    %al,(%eax)
    84ee:	00 00                	add    %al,(%eax)
    84f0:	00 00                	add    %al,(%eax)
    84f2:	00 00                	add    %al,(%eax)
    84f4:	00 00                	add    %al,(%eax)
    84f6:	00 00                	add    %al,(%eax)
    84f8:	00 00                	add    %al,(%eax)
    84fa:	00 00                	add    %al,(%eax)
    84fc:	00 00                	add    %al,(%eax)
    84fe:	00 00                	add    %al,(%eax)
    8500:	00 00                	add    %al,(%eax)
    8502:	00 00                	add    %al,(%eax)
    8504:	00 00                	add    %al,(%eax)
    8506:	00 00                	add    %al,(%eax)
    8508:	00 00                	add    %al,(%eax)
    850a:	00 00                	add    %al,(%eax)
    850c:	00 00                	add    %al,(%eax)
    850e:	00 00                	add    %al,(%eax)
    8510:	00 00                	add    %al,(%eax)
    8512:	00 00                	add    %al,(%eax)
    8514:	00 00                	add    %al,(%eax)
    8516:	00 00                	add    %al,(%eax)
    8518:	00 00                	add    %al,(%eax)
    851a:	00 00                	add    %al,(%eax)
    851c:	00 00                	add    %al,(%eax)
    851e:	00 00                	add    %al,(%eax)
    8520:	00 00                	add    %al,(%eax)
    8522:	00 00                	add    %al,(%eax)
    8524:	00 00                	add    %al,(%eax)
    8526:	00 00                	add    %al,(%eax)
    8528:	00 00                	add    %al,(%eax)
    852a:	00 00                	add    %al,(%eax)
    852c:	00 00                	add    %al,(%eax)
    852e:	00 00                	add    %al,(%eax)
    8530:	00 00                	add    %al,(%eax)
    8532:	00 00                	add    %al,(%eax)
    8534:	00 00                	add    %al,(%eax)
    8536:	00 00                	add    %al,(%eax)
    8538:	00 00                	add    %al,(%eax)
    853a:	00 00                	add    %al,(%eax)
    853c:	00 00                	add    %al,(%eax)
    853e:	00 00                	add    %al,(%eax)
    8540:	00 00                	add    %al,(%eax)
    8542:	00 00                	add    %al,(%eax)
    8544:	00 00                	add    %al,(%eax)
    8546:	00 00                	add    %al,(%eax)
    8548:	00 00                	add    %al,(%eax)
    854a:	00 00                	add    %al,(%eax)
    854c:	00 00                	add    %al,(%eax)
    854e:	00 00                	add    %al,(%eax)
    8550:	00 00                	add    %al,(%eax)
    8552:	00 00                	add    %al,(%eax)
    8554:	00 00                	add    %al,(%eax)
    8556:	00 00                	add    %al,(%eax)
    8558:	00 00                	add    %al,(%eax)
    855a:	00 00                	add    %al,(%eax)
    855c:	00 00                	add    %al,(%eax)
    855e:	00 00                	add    %al,(%eax)
    8560:	00 00                	add    %al,(%eax)
    8562:	00 00                	add    %al,(%eax)
    8564:	00 00                	add    %al,(%eax)
    8566:	00 00                	add    %al,(%eax)
    8568:	00 00                	add    %al,(%eax)
    856a:	00 00                	add    %al,(%eax)
    856c:	00 00                	add    %al,(%eax)
    856e:	00 00                	add    %al,(%eax)
    8570:	00 00                	add    %al,(%eax)
    8572:	00 00                	add    %al,(%eax)
    8574:	00 00                	add    %al,(%eax)
    8576:	00 00                	add    %al,(%eax)
    8578:	00 00                	add    %al,(%eax)
    857a:	00 00                	add    %al,(%eax)
    857c:	00 00                	add    %al,(%eax)
    857e:	00 00                	add    %al,(%eax)
    8580:	00 00                	add    %al,(%eax)
    8582:	00 00                	add    %al,(%eax)
    8584:	00 00                	add    %al,(%eax)
    8586:	00 00                	add    %al,(%eax)
    8588:	00 00                	add    %al,(%eax)
    858a:	00 00                	add    %al,(%eax)
    858c:	00 00                	add    %al,(%eax)
    858e:	00 00                	add    %al,(%eax)
    8590:	00 00                	add    %al,(%eax)
    8592:	00 00                	add    %al,(%eax)
    8594:	00 00                	add    %al,(%eax)
    8596:	00 00                	add    %al,(%eax)
    8598:	00 00                	add    %al,(%eax)
    859a:	00 00                	add    %al,(%eax)
    859c:	00 00                	add    %al,(%eax)
    859e:	00 00                	add    %al,(%eax)
    85a0:	00 00                	add    %al,(%eax)
    85a2:	00 00                	add    %al,(%eax)
    85a4:	00 00                	add    %al,(%eax)
    85a6:	00 00                	add    %al,(%eax)
    85a8:	00 00                	add    %al,(%eax)
    85aa:	00 00                	add    %al,(%eax)
    85ac:	00 00                	add    %al,(%eax)
    85ae:	00 00                	add    %al,(%eax)
    85b0:	00 00                	add    %al,(%eax)
    85b2:	00 00                	add    %al,(%eax)
    85b4:	00 00                	add    %al,(%eax)
    85b6:	00 00                	add    %al,(%eax)
    85b8:	00 00                	add    %al,(%eax)
    85ba:	00 00                	add    %al,(%eax)
    85bc:	00 00                	add    %al,(%eax)
    85be:	00 00                	add    %al,(%eax)
    85c0:	00 00                	add    %al,(%eax)
    85c2:	00 00                	add    %al,(%eax)
    85c4:	00 00                	add    %al,(%eax)
    85c6:	00 00                	add    %al,(%eax)
    85c8:	00 00                	add    %al,(%eax)
    85ca:	00 00                	add    %al,(%eax)
    85cc:	00 00                	add    %al,(%eax)
    85ce:	00 00                	add    %al,(%eax)
    85d0:	00 00                	add    %al,(%eax)
    85d2:	00 00                	add    %al,(%eax)
    85d4:	00 00                	add    %al,(%eax)
    85d6:	00 00                	add    %al,(%eax)
    85d8:	00 00                	add    %al,(%eax)
    85da:	00 00                	add    %al,(%eax)
    85dc:	00 00                	add    %al,(%eax)
    85de:	00 00                	add    %al,(%eax)
    85e0:	00 00                	add    %al,(%eax)
    85e2:	00 00                	add    %al,(%eax)
    85e4:	00 00                	add    %al,(%eax)
    85e6:	00 00                	add    %al,(%eax)
    85e8:	00 00                	add    %al,(%eax)
    85ea:	00 00                	add    %al,(%eax)
    85ec:	00 00                	add    %al,(%eax)
    85ee:	00 00                	add    %al,(%eax)
    85f0:	00 00                	add    %al,(%eax)
    85f2:	00 00                	add    %al,(%eax)
    85f4:	00 00                	add    %al,(%eax)
    85f6:	00 00                	add    %al,(%eax)
    85f8:	00 00                	add    %al,(%eax)
    85fa:	00 00                	add    %al,(%eax)
    85fc:	00 00                	add    %al,(%eax)
    85fe:	00 00                	add    %al,(%eax)
    8600:	00 00                	add    %al,(%eax)
    8602:	00 00                	add    %al,(%eax)
    8604:	00 00                	add    %al,(%eax)
    8606:	00 00                	add    %al,(%eax)
    8608:	00 00                	add    %al,(%eax)
    860a:	00 00                	add    %al,(%eax)
    860c:	00 00                	add    %al,(%eax)
    860e:	00 00                	add    %al,(%eax)
    8610:	00 00                	add    %al,(%eax)
    8612:	00 00                	add    %al,(%eax)
    8614:	00 00                	add    %al,(%eax)
    8616:	00 00                	add    %al,(%eax)
    8618:	00 00                	add    %al,(%eax)
    861a:	00 00                	add    %al,(%eax)
    861c:	00 00                	add    %al,(%eax)
    861e:	00 00                	add    %al,(%eax)
    8620:	00 00                	add    %al,(%eax)
    8622:	00 00                	add    %al,(%eax)
    8624:	00 00                	add    %al,(%eax)
    8626:	00 00                	add    %al,(%eax)
    8628:	00 00                	add    %al,(%eax)
    862a:	00 00                	add    %al,(%eax)
    862c:	00 00                	add    %al,(%eax)
    862e:	00 00                	add    %al,(%eax)
    8630:	00 00                	add    %al,(%eax)
    8632:	00 00                	add    %al,(%eax)
    8634:	00 00                	add    %al,(%eax)
    8636:	00 00                	add    %al,(%eax)
    8638:	00 00                	add    %al,(%eax)
    863a:	00 00                	add    %al,(%eax)
    863c:	00 00                	add    %al,(%eax)
    863e:	00 00                	add    %al,(%eax)
    8640:	00 00                	add    %al,(%eax)
    8642:	00 00                	add    %al,(%eax)
    8644:	00 00                	add    %al,(%eax)
    8646:	00 00                	add    %al,(%eax)
    8648:	00 00                	add    %al,(%eax)
    864a:	00 00                	add    %al,(%eax)
    864c:	00 00                	add    %al,(%eax)
    864e:	00 00                	add    %al,(%eax)
    8650:	00 00                	add    %al,(%eax)
    8652:	00 00                	add    %al,(%eax)
    8654:	00 00                	add    %al,(%eax)
    8656:	00 00                	add    %al,(%eax)
    8658:	00 00                	add    %al,(%eax)
    865a:	00 00                	add    %al,(%eax)
    865c:	00 00                	add    %al,(%eax)
    865e:	00 00                	add    %al,(%eax)
    8660:	00 00                	add    %al,(%eax)
    8662:	00 00                	add    %al,(%eax)
    8664:	00 00                	add    %al,(%eax)
    8666:	00 00                	add    %al,(%eax)
    8668:	00 00                	add    %al,(%eax)
    866a:	00 00                	add    %al,(%eax)
    866c:	00 00                	add    %al,(%eax)
    866e:	00 00                	add    %al,(%eax)
    8670:	00 00                	add    %al,(%eax)
    8672:	00 00                	add    %al,(%eax)
    8674:	00 00                	add    %al,(%eax)
    8676:	00 00                	add    %al,(%eax)
    8678:	00 00                	add    %al,(%eax)
    867a:	00 00                	add    %al,(%eax)
    867c:	00 00                	add    %al,(%eax)
    867e:	00 00                	add    %al,(%eax)
    8680:	00 00                	add    %al,(%eax)
    8682:	00 00                	add    %al,(%eax)
    8684:	00 00                	add    %al,(%eax)
    8686:	00 00                	add    %al,(%eax)
    8688:	00 00                	add    %al,(%eax)
    868a:	00 00                	add    %al,(%eax)
    868c:	00 00                	add    %al,(%eax)
    868e:	00 00                	add    %al,(%eax)
    8690:	00 00                	add    %al,(%eax)
    8692:	00 00                	add    %al,(%eax)
    8694:	00 00                	add    %al,(%eax)
    8696:	00 00                	add    %al,(%eax)
    8698:	00 00                	add    %al,(%eax)
    869a:	00 00                	add    %al,(%eax)
    869c:	00 00                	add    %al,(%eax)
    869e:	00 00                	add    %al,(%eax)
    86a0:	00 00                	add    %al,(%eax)
    86a2:	00 00                	add    %al,(%eax)
    86a4:	00 00                	add    %al,(%eax)
    86a6:	00 00                	add    %al,(%eax)
    86a8:	00 00                	add    %al,(%eax)
    86aa:	00 00                	add    %al,(%eax)
    86ac:	00 00                	add    %al,(%eax)
    86ae:	00 00                	add    %al,(%eax)
    86b0:	00 00                	add    %al,(%eax)
    86b2:	00 00                	add    %al,(%eax)
    86b4:	00 00                	add    %al,(%eax)
    86b6:	00 00                	add    %al,(%eax)
    86b8:	00 00                	add    %al,(%eax)
    86ba:	00 00                	add    %al,(%eax)
    86bc:	00 00                	add    %al,(%eax)
    86be:	00 00                	add    %al,(%eax)
    86c0:	00 00                	add    %al,(%eax)
    86c2:	00 00                	add    %al,(%eax)
    86c4:	00 00                	add    %al,(%eax)
    86c6:	00 00                	add    %al,(%eax)
    86c8:	00 00                	add    %al,(%eax)
    86ca:	00 00                	add    %al,(%eax)
    86cc:	00 00                	add    %al,(%eax)
    86ce:	00 00                	add    %al,(%eax)
    86d0:	00 00                	add    %al,(%eax)
    86d2:	00 00                	add    %al,(%eax)
    86d4:	00 00                	add    %al,(%eax)
    86d6:	00 00                	add    %al,(%eax)
    86d8:	00 00                	add    %al,(%eax)
    86da:	00 00                	add    %al,(%eax)
    86dc:	00 00                	add    %al,(%eax)
    86de:	00 00                	add    %al,(%eax)
    86e0:	00 00                	add    %al,(%eax)
    86e2:	00 00                	add    %al,(%eax)
    86e4:	00 00                	add    %al,(%eax)
    86e6:	00 00                	add    %al,(%eax)
    86e8:	00 00                	add    %al,(%eax)
    86ea:	00 00                	add    %al,(%eax)
    86ec:	00 00                	add    %al,(%eax)
    86ee:	00 00                	add    %al,(%eax)
    86f0:	00 00                	add    %al,(%eax)
    86f2:	00 00                	add    %al,(%eax)
    86f4:	00 00                	add    %al,(%eax)
    86f6:	00 00                	add    %al,(%eax)
    86f8:	00 00                	add    %al,(%eax)
    86fa:	00 00                	add    %al,(%eax)
    86fc:	00 00                	add    %al,(%eax)
    86fe:	00 00                	add    %al,(%eax)
    8700:	00 00                	add    %al,(%eax)
    8702:	00 00                	add    %al,(%eax)
    8704:	00 00                	add    %al,(%eax)
    8706:	00 00                	add    %al,(%eax)
    8708:	00 00                	add    %al,(%eax)
    870a:	00 00                	add    %al,(%eax)
    870c:	00 00                	add    %al,(%eax)
    870e:	00 00                	add    %al,(%eax)
    8710:	00 00                	add    %al,(%eax)
    8712:	00 00                	add    %al,(%eax)
    8714:	00 00                	add    %al,(%eax)
    8716:	00 00                	add    %al,(%eax)
    8718:	00 00                	add    %al,(%eax)
    871a:	00 00                	add    %al,(%eax)
    871c:	00 00                	add    %al,(%eax)
    871e:	00 00                	add    %al,(%eax)
    8720:	00 00                	add    %al,(%eax)
    8722:	00 00                	add    %al,(%eax)
    8724:	00 00                	add    %al,(%eax)
    8726:	00 00                	add    %al,(%eax)
    8728:	00 00                	add    %al,(%eax)
    872a:	00 00                	add    %al,(%eax)
    872c:	00 00                	add    %al,(%eax)
    872e:	00 00                	add    %al,(%eax)
    8730:	00 00                	add    %al,(%eax)
    8732:	00 00                	add    %al,(%eax)
    8734:	00 00                	add    %al,(%eax)
    8736:	00 00                	add    %al,(%eax)
    8738:	00 00                	add    %al,(%eax)
    873a:	00 00                	add    %al,(%eax)
    873c:	00 00                	add    %al,(%eax)
    873e:	00 00                	add    %al,(%eax)
    8740:	00 00                	add    %al,(%eax)
    8742:	00 00                	add    %al,(%eax)
    8744:	00 00                	add    %al,(%eax)
    8746:	00 00                	add    %al,(%eax)
    8748:	00 00                	add    %al,(%eax)
    874a:	00 00                	add    %al,(%eax)
    874c:	00 00                	add    %al,(%eax)
    874e:	00 00                	add    %al,(%eax)
    8750:	00 00                	add    %al,(%eax)
    8752:	00 00                	add    %al,(%eax)
    8754:	00 00                	add    %al,(%eax)
    8756:	00 00                	add    %al,(%eax)
    8758:	00 00                	add    %al,(%eax)
    875a:	00 00                	add    %al,(%eax)
    875c:	00 00                	add    %al,(%eax)
    875e:	00 00                	add    %al,(%eax)
    8760:	00 00                	add    %al,(%eax)
    8762:	00 00                	add    %al,(%eax)
    8764:	00 00                	add    %al,(%eax)
    8766:	00 00                	add    %al,(%eax)
    8768:	00 00                	add    %al,(%eax)
    876a:	00 00                	add    %al,(%eax)
    876c:	00 00                	add    %al,(%eax)
    876e:	00 00                	add    %al,(%eax)
    8770:	00 00                	add    %al,(%eax)
    8772:	00 00                	add    %al,(%eax)
    8774:	00 00                	add    %al,(%eax)
    8776:	00 00                	add    %al,(%eax)
    8778:	00 00                	add    %al,(%eax)
    877a:	00 00                	add    %al,(%eax)
    877c:	00 00                	add    %al,(%eax)
    877e:	00 00                	add    %al,(%eax)
    8780:	00 00                	add    %al,(%eax)
    8782:	00 00                	add    %al,(%eax)
    8784:	00 00                	add    %al,(%eax)
    8786:	00 00                	add    %al,(%eax)
    8788:	00 00                	add    %al,(%eax)
    878a:	00 00                	add    %al,(%eax)
    878c:	00 00                	add    %al,(%eax)
    878e:	00 00                	add    %al,(%eax)
    8790:	00 00                	add    %al,(%eax)
    8792:	00 00                	add    %al,(%eax)
    8794:	00 00                	add    %al,(%eax)
    8796:	00 00                	add    %al,(%eax)
    8798:	00 00                	add    %al,(%eax)
    879a:	00 00                	add    %al,(%eax)
    879c:	00 00                	add    %al,(%eax)
    879e:	00 00                	add    %al,(%eax)
    87a0:	00 00                	add    %al,(%eax)
    87a2:	00 00                	add    %al,(%eax)
    87a4:	00 00                	add    %al,(%eax)
    87a6:	00 00                	add    %al,(%eax)
    87a8:	00 00                	add    %al,(%eax)
    87aa:	00 00                	add    %al,(%eax)
    87ac:	00 00                	add    %al,(%eax)
    87ae:	00 00                	add    %al,(%eax)
    87b0:	00 00                	add    %al,(%eax)
    87b2:	00 00                	add    %al,(%eax)
    87b4:	00 00                	add    %al,(%eax)
    87b6:	00 00                	add    %al,(%eax)
    87b8:	00 00                	add    %al,(%eax)
    87ba:	00 00                	add    %al,(%eax)
    87bc:	00 00                	add    %al,(%eax)
    87be:	00 00                	add    %al,(%eax)
    87c0:	00 00                	add    %al,(%eax)
    87c2:	00 00                	add    %al,(%eax)
    87c4:	00 00                	add    %al,(%eax)
    87c6:	00 00                	add    %al,(%eax)
    87c8:	00 00                	add    %al,(%eax)
    87ca:	00 00                	add    %al,(%eax)
    87cc:	00 00                	add    %al,(%eax)
    87ce:	00 00                	add    %al,(%eax)
    87d0:	00 00                	add    %al,(%eax)
    87d2:	00 00                	add    %al,(%eax)
    87d4:	00 00                	add    %al,(%eax)
    87d6:	00 00                	add    %al,(%eax)
    87d8:	00 00                	add    %al,(%eax)
    87da:	00 00                	add    %al,(%eax)
    87dc:	00 00                	add    %al,(%eax)
    87de:	00 00                	add    %al,(%eax)
    87e0:	00 00                	add    %al,(%eax)
    87e2:	00 00                	add    %al,(%eax)
    87e4:	00 00                	add    %al,(%eax)
    87e6:	00 00                	add    %al,(%eax)
    87e8:	00 00                	add    %al,(%eax)
    87ea:	00 00                	add    %al,(%eax)
    87ec:	00 00                	add    %al,(%eax)
    87ee:	00 00                	add    %al,(%eax)
    87f0:	00 00                	add    %al,(%eax)
    87f2:	00 00                	add    %al,(%eax)
    87f4:	00 00                	add    %al,(%eax)
    87f6:	00 00                	add    %al,(%eax)
    87f8:	00 00                	add    %al,(%eax)
    87fa:	00 00                	add    %al,(%eax)
    87fc:	00 00                	add    %al,(%eax)
    87fe:	00 00                	add    %al,(%eax)
    8800:	00 00                	add    %al,(%eax)
    8802:	00 00                	add    %al,(%eax)
    8804:	00 00                	add    %al,(%eax)
    8806:	00 00                	add    %al,(%eax)
    8808:	00 00                	add    %al,(%eax)
    880a:	00 00                	add    %al,(%eax)
    880c:	00 00                	add    %al,(%eax)
    880e:	00 00                	add    %al,(%eax)
    8810:	00 00                	add    %al,(%eax)
    8812:	00 00                	add    %al,(%eax)
    8814:	00 00                	add    %al,(%eax)
    8816:	00 00                	add    %al,(%eax)
    8818:	00 00                	add    %al,(%eax)
    881a:	00 00                	add    %al,(%eax)
    881c:	00 00                	add    %al,(%eax)
    881e:	00 00                	add    %al,(%eax)
    8820:	00 00                	add    %al,(%eax)
    8822:	00 00                	add    %al,(%eax)
    8824:	00 00                	add    %al,(%eax)
    8826:	00 00                	add    %al,(%eax)
    8828:	00 00                	add    %al,(%eax)
    882a:	00 00                	add    %al,(%eax)
    882c:	00 00                	add    %al,(%eax)
    882e:	00 00                	add    %al,(%eax)
    8830:	00 00                	add    %al,(%eax)
    8832:	00 00                	add    %al,(%eax)
    8834:	00 00                	add    %al,(%eax)
    8836:	00 00                	add    %al,(%eax)
    8838:	00 00                	add    %al,(%eax)
    883a:	00 00                	add    %al,(%eax)
    883c:	00 00                	add    %al,(%eax)
    883e:	00 00                	add    %al,(%eax)
    8840:	00 00                	add    %al,(%eax)
    8842:	00 00                	add    %al,(%eax)
    8844:	00 00                	add    %al,(%eax)
    8846:	00 00                	add    %al,(%eax)
    8848:	00 00                	add    %al,(%eax)
    884a:	00 00                	add    %al,(%eax)
    884c:	00 00                	add    %al,(%eax)
    884e:	00 00                	add    %al,(%eax)
    8850:	00 00                	add    %al,(%eax)
    8852:	00 00                	add    %al,(%eax)
    8854:	00 00                	add    %al,(%eax)
    8856:	00 00                	add    %al,(%eax)
    8858:	00 00                	add    %al,(%eax)
    885a:	00 00                	add    %al,(%eax)
    885c:	00 00                	add    %al,(%eax)
    885e:	00 00                	add    %al,(%eax)
    8860:	00 00                	add    %al,(%eax)
    8862:	00 00                	add    %al,(%eax)
    8864:	00 00                	add    %al,(%eax)
    8866:	00 00                	add    %al,(%eax)
    8868:	00 00                	add    %al,(%eax)
    886a:	00 00                	add    %al,(%eax)
    886c:	00 00                	add    %al,(%eax)
    886e:	00 00                	add    %al,(%eax)
    8870:	00 00                	add    %al,(%eax)
    8872:	00 00                	add    %al,(%eax)
    8874:	00 00                	add    %al,(%eax)
    8876:	00 00                	add    %al,(%eax)
    8878:	00 00                	add    %al,(%eax)
    887a:	00 00                	add    %al,(%eax)
    887c:	00 00                	add    %al,(%eax)
    887e:	00 00                	add    %al,(%eax)
    8880:	00 00                	add    %al,(%eax)
    8882:	00 00                	add    %al,(%eax)
    8884:	00 00                	add    %al,(%eax)
    8886:	00 00                	add    %al,(%eax)
    8888:	00 00                	add    %al,(%eax)
    888a:	00 00                	add    %al,(%eax)
    888c:	00 00                	add    %al,(%eax)
    888e:	00 00                	add    %al,(%eax)
    8890:	00 00                	add    %al,(%eax)
    8892:	00 00                	add    %al,(%eax)
    8894:	00 00                	add    %al,(%eax)
    8896:	00 00                	add    %al,(%eax)
    8898:	00 00                	add    %al,(%eax)
    889a:	00 00                	add    %al,(%eax)
    889c:	00 00                	add    %al,(%eax)
    889e:	00 00                	add    %al,(%eax)
    88a0:	00 00                	add    %al,(%eax)
    88a2:	00 00                	add    %al,(%eax)
    88a4:	00 00                	add    %al,(%eax)
    88a6:	00 00                	add    %al,(%eax)
    88a8:	00 00                	add    %al,(%eax)
    88aa:	00 00                	add    %al,(%eax)
    88ac:	00 00                	add    %al,(%eax)
    88ae:	00 00                	add    %al,(%eax)
    88b0:	00 00                	add    %al,(%eax)
    88b2:	00 00                	add    %al,(%eax)
    88b4:	00 00                	add    %al,(%eax)
    88b6:	00 00                	add    %al,(%eax)
    88b8:	00 00                	add    %al,(%eax)
    88ba:	00 00                	add    %al,(%eax)
    88bc:	00 00                	add    %al,(%eax)
    88be:	00 00                	add    %al,(%eax)
    88c0:	00 00                	add    %al,(%eax)
    88c2:	00 00                	add    %al,(%eax)
    88c4:	00 00                	add    %al,(%eax)
    88c6:	00 00                	add    %al,(%eax)
    88c8:	00 00                	add    %al,(%eax)
    88ca:	00 00                	add    %al,(%eax)
    88cc:	00 00                	add    %al,(%eax)
    88ce:	00 00                	add    %al,(%eax)
    88d0:	00 00                	add    %al,(%eax)
    88d2:	00 00                	add    %al,(%eax)
    88d4:	00 00                	add    %al,(%eax)
    88d6:	00 00                	add    %al,(%eax)
    88d8:	00 00                	add    %al,(%eax)
    88da:	00 00                	add    %al,(%eax)
    88dc:	00 00                	add    %al,(%eax)
    88de:	00 00                	add    %al,(%eax)
    88e0:	00 00                	add    %al,(%eax)
    88e2:	00 00                	add    %al,(%eax)
    88e4:	00 00                	add    %al,(%eax)
    88e6:	00 00                	add    %al,(%eax)
    88e8:	00 00                	add    %al,(%eax)
    88ea:	00 00                	add    %al,(%eax)
    88ec:	00 00                	add    %al,(%eax)
    88ee:	00 00                	add    %al,(%eax)
    88f0:	00 00                	add    %al,(%eax)
    88f2:	00 00                	add    %al,(%eax)
    88f4:	00 00                	add    %al,(%eax)
    88f6:	00 00                	add    %al,(%eax)
    88f8:	00 00                	add    %al,(%eax)
    88fa:	00 00                	add    %al,(%eax)
    88fc:	00 00                	add    %al,(%eax)
    88fe:	00 00                	add    %al,(%eax)
    8900:	00 00                	add    %al,(%eax)
    8902:	00 00                	add    %al,(%eax)
    8904:	00 00                	add    %al,(%eax)
    8906:	00 00                	add    %al,(%eax)
    8908:	00 00                	add    %al,(%eax)
    890a:	00 00                	add    %al,(%eax)
    890c:	00 00                	add    %al,(%eax)
    890e:	00 00                	add    %al,(%eax)
    8910:	00 00                	add    %al,(%eax)
    8912:	00 00                	add    %al,(%eax)
    8914:	00 00                	add    %al,(%eax)
    8916:	00 00                	add    %al,(%eax)
    8918:	00 00                	add    %al,(%eax)
    891a:	00 00                	add    %al,(%eax)
    891c:	00 00                	add    %al,(%eax)
    891e:	00 00                	add    %al,(%eax)
    8920:	00 00                	add    %al,(%eax)
    8922:	00 00                	add    %al,(%eax)
    8924:	00 00                	add    %al,(%eax)
    8926:	00 00                	add    %al,(%eax)
    8928:	00 00                	add    %al,(%eax)
    892a:	00 00                	add    %al,(%eax)
    892c:	00 00                	add    %al,(%eax)
    892e:	00 00                	add    %al,(%eax)
    8930:	00 00                	add    %al,(%eax)
    8932:	00 00                	add    %al,(%eax)
    8934:	00 00                	add    %al,(%eax)
    8936:	00 00                	add    %al,(%eax)
    8938:	00 00                	add    %al,(%eax)
    893a:	00 00                	add    %al,(%eax)
    893c:	00 00                	add    %al,(%eax)
    893e:	00 00                	add    %al,(%eax)
    8940:	00 00                	add    %al,(%eax)
    8942:	00 00                	add    %al,(%eax)
    8944:	00 00                	add    %al,(%eax)
    8946:	00 00                	add    %al,(%eax)
    8948:	00 00                	add    %al,(%eax)
    894a:	00 00                	add    %al,(%eax)
    894c:	00 00                	add    %al,(%eax)
    894e:	00 00                	add    %al,(%eax)
    8950:	00 00                	add    %al,(%eax)
    8952:	00 00                	add    %al,(%eax)
    8954:	00 00                	add    %al,(%eax)
    8956:	00 00                	add    %al,(%eax)
    8958:	00 00                	add    %al,(%eax)
    895a:	00 00                	add    %al,(%eax)
    895c:	00 00                	add    %al,(%eax)
    895e:	00 00                	add    %al,(%eax)
    8960:	00 00                	add    %al,(%eax)
    8962:	00 00                	add    %al,(%eax)
    8964:	00 00                	add    %al,(%eax)
    8966:	00 00                	add    %al,(%eax)
    8968:	00 00                	add    %al,(%eax)
    896a:	00 00                	add    %al,(%eax)
    896c:	00 00                	add    %al,(%eax)
    896e:	00 00                	add    %al,(%eax)
    8970:	00 00                	add    %al,(%eax)
    8972:	00 00                	add    %al,(%eax)
    8974:	00 00                	add    %al,(%eax)
    8976:	00 00                	add    %al,(%eax)
    8978:	00 00                	add    %al,(%eax)
    897a:	00 00                	add    %al,(%eax)
    897c:	00 00                	add    %al,(%eax)
    897e:	00 00                	add    %al,(%eax)
    8980:	00 00                	add    %al,(%eax)
    8982:	00 00                	add    %al,(%eax)
    8984:	00 00                	add    %al,(%eax)
    8986:	00 00                	add    %al,(%eax)
    8988:	00 00                	add    %al,(%eax)
    898a:	00 00                	add    %al,(%eax)
    898c:	00 00                	add    %al,(%eax)
    898e:	00 00                	add    %al,(%eax)
    8990:	00 00                	add    %al,(%eax)
    8992:	00 00                	add    %al,(%eax)
    8994:	00 00                	add    %al,(%eax)
    8996:	00 00                	add    %al,(%eax)
    8998:	00 00                	add    %al,(%eax)
    899a:	00 00                	add    %al,(%eax)
    899c:	00 00                	add    %al,(%eax)
    899e:	00 00                	add    %al,(%eax)
    89a0:	00 00                	add    %al,(%eax)
    89a2:	00 00                	add    %al,(%eax)
    89a4:	00 00                	add    %al,(%eax)
    89a6:	00 00                	add    %al,(%eax)
    89a8:	00 00                	add    %al,(%eax)
    89aa:	00 00                	add    %al,(%eax)
    89ac:	00 00                	add    %al,(%eax)
    89ae:	00 00                	add    %al,(%eax)
    89b0:	00 00                	add    %al,(%eax)
    89b2:	00 00                	add    %al,(%eax)
    89b4:	00 00                	add    %al,(%eax)
    89b6:	00 00                	add    %al,(%eax)
    89b8:	00 00                	add    %al,(%eax)
    89ba:	00 00                	add    %al,(%eax)
    89bc:	00 00                	add    %al,(%eax)
    89be:	00 00                	add    %al,(%eax)
    89c0:	00 00                	add    %al,(%eax)
    89c2:	00 00                	add    %al,(%eax)
    89c4:	00 00                	add    %al,(%eax)
    89c6:	00 00                	add    %al,(%eax)
    89c8:	00 00                	add    %al,(%eax)
    89ca:	00 00                	add    %al,(%eax)
    89cc:	00 00                	add    %al,(%eax)
    89ce:	00 00                	add    %al,(%eax)
    89d0:	00 00                	add    %al,(%eax)
    89d2:	00 00                	add    %al,(%eax)
    89d4:	00 00                	add    %al,(%eax)
    89d6:	00 00                	add    %al,(%eax)
    89d8:	00 00                	add    %al,(%eax)
    89da:	00 00                	add    %al,(%eax)
    89dc:	00 00                	add    %al,(%eax)
    89de:	00 00                	add    %al,(%eax)
    89e0:	00 00                	add    %al,(%eax)
    89e2:	00 00                	add    %al,(%eax)
    89e4:	00 00                	add    %al,(%eax)
    89e6:	00 00                	add    %al,(%eax)
    89e8:	00 00                	add    %al,(%eax)
    89ea:	00 00                	add    %al,(%eax)
    89ec:	00 00                	add    %al,(%eax)
    89ee:	00 00                	add    %al,(%eax)
    89f0:	00 00                	add    %al,(%eax)
    89f2:	00 00                	add    %al,(%eax)
    89f4:	00 00                	add    %al,(%eax)
    89f6:	00 00                	add    %al,(%eax)
    89f8:	00 00                	add    %al,(%eax)
    89fa:	00 00                	add    %al,(%eax)
    89fc:	00 00                	add    %al,(%eax)
    89fe:	00 00                	add    %al,(%eax)
    8a00:	00 00                	add    %al,(%eax)
    8a02:	00 00                	add    %al,(%eax)
    8a04:	00 00                	add    %al,(%eax)
    8a06:	00 00                	add    %al,(%eax)
    8a08:	00 00                	add    %al,(%eax)
    8a0a:	00 00                	add    %al,(%eax)
    8a0c:	00 00                	add    %al,(%eax)
    8a0e:	00 00                	add    %al,(%eax)
    8a10:	00 00                	add    %al,(%eax)
    8a12:	00 00                	add    %al,(%eax)
    8a14:	00 00                	add    %al,(%eax)
    8a16:	00 00                	add    %al,(%eax)
    8a18:	00 00                	add    %al,(%eax)
    8a1a:	00 00                	add    %al,(%eax)
    8a1c:	00 00                	add    %al,(%eax)
    8a1e:	00 00                	add    %al,(%eax)
    8a20:	00 00                	add    %al,(%eax)
    8a22:	00 00                	add    %al,(%eax)
    8a24:	00 00                	add    %al,(%eax)
    8a26:	00 00                	add    %al,(%eax)
    8a28:	00 00                	add    %al,(%eax)
    8a2a:	00 00                	add    %al,(%eax)
    8a2c:	00 00                	add    %al,(%eax)
    8a2e:	00 00                	add    %al,(%eax)
    8a30:	00 00                	add    %al,(%eax)
    8a32:	00 00                	add    %al,(%eax)
    8a34:	00 00                	add    %al,(%eax)
    8a36:	00 00                	add    %al,(%eax)
    8a38:	00 00                	add    %al,(%eax)
    8a3a:	00 00                	add    %al,(%eax)
    8a3c:	00 00                	add    %al,(%eax)
    8a3e:	00 00                	add    %al,(%eax)
    8a40:	00 00                	add    %al,(%eax)
    8a42:	00 00                	add    %al,(%eax)
    8a44:	00 00                	add    %al,(%eax)
    8a46:	00 00                	add    %al,(%eax)
    8a48:	00 00                	add    %al,(%eax)
    8a4a:	00 00                	add    %al,(%eax)
    8a4c:	00 00                	add    %al,(%eax)
    8a4e:	00 00                	add    %al,(%eax)
    8a50:	00 00                	add    %al,(%eax)
    8a52:	00 00                	add    %al,(%eax)
    8a54:	00 00                	add    %al,(%eax)
    8a56:	00 00                	add    %al,(%eax)
    8a58:	00 00                	add    %al,(%eax)
    8a5a:	00 00                	add    %al,(%eax)
    8a5c:	00 00                	add    %al,(%eax)
    8a5e:	00 00                	add    %al,(%eax)
    8a60:	00 00                	add    %al,(%eax)
    8a62:	00 00                	add    %al,(%eax)
    8a64:	00 00                	add    %al,(%eax)
    8a66:	00 00                	add    %al,(%eax)
    8a68:	00 00                	add    %al,(%eax)
    8a6a:	00 00                	add    %al,(%eax)
    8a6c:	00 00                	add    %al,(%eax)
    8a6e:	00 00                	add    %al,(%eax)
    8a70:	00 00                	add    %al,(%eax)
    8a72:	00 00                	add    %al,(%eax)
    8a74:	00 00                	add    %al,(%eax)
    8a76:	00 00                	add    %al,(%eax)
    8a78:	00 00                	add    %al,(%eax)
    8a7a:	00 00                	add    %al,(%eax)
    8a7c:	00 00                	add    %al,(%eax)
    8a7e:	00 00                	add    %al,(%eax)
    8a80:	00 00                	add    %al,(%eax)
    8a82:	00 00                	add    %al,(%eax)
    8a84:	00 00                	add    %al,(%eax)
    8a86:	00 00                	add    %al,(%eax)
    8a88:	00 00                	add    %al,(%eax)
    8a8a:	00 00                	add    %al,(%eax)
    8a8c:	00 00                	add    %al,(%eax)
    8a8e:	00 00                	add    %al,(%eax)
    8a90:	00 00                	add    %al,(%eax)
    8a92:	00 00                	add    %al,(%eax)
    8a94:	00 00                	add    %al,(%eax)
    8a96:	00 00                	add    %al,(%eax)
    8a98:	00 00                	add    %al,(%eax)
    8a9a:	00 00                	add    %al,(%eax)
    8a9c:	00 00                	add    %al,(%eax)
    8a9e:	00 00                	add    %al,(%eax)
    8aa0:	00 00                	add    %al,(%eax)
    8aa2:	00 00                	add    %al,(%eax)
    8aa4:	00 00                	add    %al,(%eax)
    8aa6:	00 00                	add    %al,(%eax)
    8aa8:	00 00                	add    %al,(%eax)
    8aaa:	00 00                	add    %al,(%eax)
    8aac:	00 00                	add    %al,(%eax)
    8aae:	00 00                	add    %al,(%eax)
    8ab0:	00 00                	add    %al,(%eax)
    8ab2:	00 00                	add    %al,(%eax)
    8ab4:	00 00                	add    %al,(%eax)
    8ab6:	00 00                	add    %al,(%eax)
    8ab8:	00 00                	add    %al,(%eax)
    8aba:	00 00                	add    %al,(%eax)
    8abc:	00 00                	add    %al,(%eax)
    8abe:	00 00                	add    %al,(%eax)
    8ac0:	00 00                	add    %al,(%eax)
    8ac2:	00 00                	add    %al,(%eax)
    8ac4:	00 00                	add    %al,(%eax)
    8ac6:	00 00                	add    %al,(%eax)
    8ac8:	00 00                	add    %al,(%eax)
    8aca:	00 00                	add    %al,(%eax)
    8acc:	00 00                	add    %al,(%eax)
    8ace:	00 00                	add    %al,(%eax)
    8ad0:	00 00                	add    %al,(%eax)
    8ad2:	00 00                	add    %al,(%eax)
    8ad4:	00 00                	add    %al,(%eax)
    8ad6:	00 00                	add    %al,(%eax)
    8ad8:	00 00                	add    %al,(%eax)
    8ada:	00 00                	add    %al,(%eax)
    8adc:	00 00                	add    %al,(%eax)
    8ade:	00 00                	add    %al,(%eax)
    8ae0:	00 00                	add    %al,(%eax)
    8ae2:	00 00                	add    %al,(%eax)
    8ae4:	00 00                	add    %al,(%eax)
    8ae6:	00 00                	add    %al,(%eax)
    8ae8:	00 00                	add    %al,(%eax)
    8aea:	00 00                	add    %al,(%eax)
    8aec:	00 00                	add    %al,(%eax)
    8aee:	00 00                	add    %al,(%eax)
    8af0:	00 00                	add    %al,(%eax)
    8af2:	00 00                	add    %al,(%eax)
    8af4:	00 00                	add    %al,(%eax)
    8af6:	00 00                	add    %al,(%eax)
    8af8:	00 00                	add    %al,(%eax)
    8afa:	00 00                	add    %al,(%eax)
    8afc:	00 00                	add    %al,(%eax)
    8afe:	00 00                	add    %al,(%eax)
    8b00:	00 00                	add    %al,(%eax)
    8b02:	00 00                	add    %al,(%eax)
    8b04:	00 00                	add    %al,(%eax)
    8b06:	00 00                	add    %al,(%eax)
    8b08:	00 00                	add    %al,(%eax)
    8b0a:	00 00                	add    %al,(%eax)
    8b0c:	00 00                	add    %al,(%eax)
    8b0e:	00 00                	add    %al,(%eax)
    8b10:	00 00                	add    %al,(%eax)
    8b12:	00 00                	add    %al,(%eax)
    8b14:	00 00                	add    %al,(%eax)
    8b16:	00 00                	add    %al,(%eax)
    8b18:	00 00                	add    %al,(%eax)
    8b1a:	00 00                	add    %al,(%eax)
    8b1c:	00 00                	add    %al,(%eax)
    8b1e:	00 00                	add    %al,(%eax)
    8b20:	00 00                	add    %al,(%eax)
    8b22:	00 00                	add    %al,(%eax)
    8b24:	00 00                	add    %al,(%eax)

00008b26 <putc>:
 */
volatile char *video = (volatile char*) 0xB8000;

void
putc (int l, int color, char ch)
{
    8b26:	55                   	push   %ebp
    8b27:	89 e5                	mov    %esp,%ebp
    8b29:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile char * p = video + l * 2;
	* p = ch;
    8b2c:	8b 55 10             	mov    0x10(%ebp),%edx
	volatile char * p = video + l * 2;
    8b2f:	01 c0                	add    %eax,%eax
    8b31:	03 05 44 90 00 00    	add    0x9044,%eax
	* p = ch;
    8b37:	88 10                	mov    %dl,(%eax)
	* (p + 1) = color;
    8b39:	8b 55 0c             	mov    0xc(%ebp),%edx
    8b3c:	88 50 01             	mov    %dl,0x1(%eax)
}
    8b3f:	5d                   	pop    %ebp
    8b40:	c3                   	ret

00008b41 <puts>:


int
puts (int r, int c, int color, const char *string)
{
    8b41:	55                   	push   %ebp
    8b42:	89 e5                	mov    %esp,%ebp
    8b44:	53                   	push   %ebx
    8b45:	51                   	push   %ecx
	int l = r * 80 + c;
    8b46:	6b 5d 08 50          	imul   $0x50,0x8(%ebp),%ebx
    8b4a:	03 5d 0c             	add    0xc(%ebp),%ebx
    8b4d:	89 d9                	mov    %ebx,%ecx
	while (*string != 0)
    8b4f:	8b 45 14             	mov    0x14(%ebp),%eax
    8b52:	29 d8                	sub    %ebx,%eax
    8b54:	0f be 04 08          	movsbl (%eax,%ecx,1),%eax
    8b58:	84 c0                	test   %al,%al
    8b5a:	74 11                	je     8b6d <puts+0x2c>
	{
		putc (l++, color, *string++);
    8b5c:	52                   	push   %edx
    8b5d:	50                   	push   %eax
    8b5e:	ff 75 10             	push   0x10(%ebp)
    8b61:	51                   	push   %ecx
    8b62:	41                   	inc    %ecx
    8b63:	e8 be ff ff ff       	call   8b26 <putc>
    8b68:	83 c4 10             	add    $0x10,%esp
    8b6b:	eb e2                	jmp    8b4f <puts+0xe>
	}
	return l;
}
    8b6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    8b70:	89 c8                	mov    %ecx,%eax
    8b72:	c9                   	leave
    8b73:	c3                   	ret

00008b74 <putline>:
char * blank =
"                                                                                ";

void
putline (char * s)
{
    8b74:	55                   	push   %ebp
    8b75:	89 e5                	mov    %esp,%ebp
    8b77:	53                   	push   %ebx
    8b78:	50                   	push   %eax
	puts (row = (row >= CRT_ROWS) ? 0 : row + 1, 0, VGA_CLR_BLACK, blank);
    8b79:	a1 e8 90 00 00       	mov    0x90e8,%eax
    8b7e:	ff 35 40 90 00 00    	push   0x9040
    8b84:	83 f8 19             	cmp    $0x19,%eax
    8b87:	8d 58 01             	lea    0x1(%eax),%ebx
    8b8a:	b8 00 00 00 00       	mov    $0x0,%eax
    8b8f:	6a 00                	push   $0x0
    8b91:	0f 4d d8             	cmovge %eax,%ebx
    8b94:	6a 00                	push   $0x0
    8b96:	53                   	push   %ebx
    8b97:	89 1d e8 90 00 00    	mov    %ebx,0x90e8
    8b9d:	e8 9f ff ff ff       	call   8b41 <puts>
	puts (row, 0, VGA_CLR_WHITE, s);
    8ba2:	ff 75 08             	push   0x8(%ebp)
    8ba5:	6a 0f                	push   $0xf
    8ba7:	6a 00                	push   $0x0
    8ba9:	53                   	push   %ebx
    8baa:	e8 92 ff ff ff       	call   8b41 <puts>
}
    8baf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    8bb2:	83 c4 20             	add    $0x20,%esp
    8bb5:	c9                   	leave
    8bb6:	c3                   	ret

00008bb7 <roll>:

void
roll (int r)
{
    8bb7:	55                   	push   %ebp
    8bb8:	89 e5                	mov    %esp,%ebp
	row = r;
    8bba:	8b 45 08             	mov    0x8(%ebp),%eax
}
    8bbd:	5d                   	pop    %ebp
	row = r;
    8bbe:	a3 e8 90 00 00       	mov    %eax,0x90e8
}
    8bc3:	c3                   	ret

00008bc4 <panic>:

void
panic (char * m)
{
    8bc4:	55                   	push   %ebp
    8bc5:	89 e5                	mov    %esp,%ebp
    8bc7:	83 ec 08             	sub    $0x8,%esp
	puts (0, 0, VGA_CLR_RED, m);
    8bca:	ff 75 08             	push   0x8(%ebp)
    8bcd:	6a 04                	push   $0x4
    8bcf:	6a 00                	push   $0x0
    8bd1:	6a 00                	push   $0x0
    8bd3:	e8 69 ff ff ff       	call   8b41 <puts>
    8bd8:	83 c4 10             	add    $0x10,%esp
	while (1)
	{
		asm volatile("hlt");
    8bdb:	f4                   	hlt
	while (1)
    8bdc:	eb fd                	jmp    8bdb <panic+0x17>

00008bde <strlen>:
 * string
 */

int
strlen (const char *s)
{
    8bde:	55                   	push   %ebp
	int n;

	for (n = 0; *s != '\0'; s++)
    8bdf:	31 c0                	xor    %eax,%eax
{
    8be1:	89 e5                	mov    %esp,%ebp
    8be3:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; *s != '\0'; s++)
    8be6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    8bea:	74 03                	je     8bef <strlen+0x11>
		n++;
    8bec:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
    8bed:	eb f7                	jmp    8be6 <strlen+0x8>
	return n;
}
    8bef:	5d                   	pop    %ebp
    8bf0:	c3                   	ret

00008bf1 <reverse>:

/* reverse:  reverse string s in place */
void
reverse (char s[])
{
    8bf1:	55                   	push   %ebp
    8bf2:	89 e5                	mov    %esp,%ebp
    8bf4:	56                   	push   %esi
    8bf5:	53                   	push   %ebx
    8bf6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i, j;
	char c;

	for (i = 0, j = strlen (s) - 1; i < j; i++, j--)
    8bf9:	83 ec 0c             	sub    $0xc,%esp
    8bfc:	51                   	push   %ecx
    8bfd:	e8 dc ff ff ff       	call   8bde <strlen>
    8c02:	83 c4 10             	add    $0x10,%esp
    8c05:	31 d2                	xor    %edx,%edx
    8c07:	48                   	dec    %eax
    8c08:	39 c2                	cmp    %eax,%edx
    8c0a:	7d 13                	jge    8c1f <reverse+0x2e>
	{
		c = s[i];
    8c0c:	0f b6 34 11          	movzbl (%ecx,%edx,1),%esi
		s[i] = s[j];
    8c10:	8a 1c 01             	mov    (%ecx,%eax,1),%bl
    8c13:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
		s[j] = c;
    8c16:	89 f3                	mov    %esi,%ebx
	for (i = 0, j = strlen (s) - 1; i < j; i++, j--)
    8c18:	42                   	inc    %edx
		s[j] = c;
    8c19:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
	for (i = 0, j = strlen (s) - 1; i < j; i++, j--)
    8c1c:	48                   	dec    %eax
    8c1d:	eb e9                	jmp    8c08 <reverse+0x17>
	}
}
    8c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8c22:	5b                   	pop    %ebx
    8c23:	5e                   	pop    %esi
    8c24:	5d                   	pop    %ebp
    8c25:	c3                   	ret

00008c26 <itox>:

/* itoa:  convert n to characters in s */
void
itox (int n, char s[], int root, char * table)
{
    8c26:	55                   	push   %ebp
    8c27:	89 e5                	mov    %esp,%ebp
    8c29:	57                   	push   %edi
    8c2a:	56                   	push   %esi
    8c2b:	53                   	push   %ebx
    8c2c:	83 ec 1c             	sub    $0x1c,%esp
    8c2f:	8b 75 08             	mov    0x8(%ebp),%esi
    8c32:	8b 45 10             	mov    0x10(%ebp),%eax
    8c35:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    8c38:	8b 7d 14             	mov    0x14(%ebp),%edi
    8c3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i, sign;

	if ((sign = n) < 0) /* record sign */
    8c3e:	89 f0                	mov    %esi,%eax
    8c40:	f7 d8                	neg    %eax
    8c42:	0f 48 c6             	cmovs  %esi,%eax
    8c45:	31 c9                	xor    %ecx,%ecx
		n = -n; /* make n positive */
	i = 0;
	do
	{ /* generate digits in reverse order */
		s[i++] = table[n % root]; /* get next digit */
    8c47:	99                   	cltd
    8c48:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    8c4b:	41                   	inc    %ecx
	} while ((n /= root) > 0); /* delete it */
    8c4c:	f7 7d e0             	idivl  -0x20(%ebp)
		s[i++] = table[n % root]; /* get next digit */
    8c4f:	8a 14 17             	mov    (%edi,%edx,1),%dl
    8c52:	88 54 0b ff          	mov    %dl,-0x1(%ebx,%ecx,1)
    8c56:	89 ca                	mov    %ecx,%edx
	} while ((n /= root) > 0); /* delete it */
    8c58:	85 c0                	test   %eax,%eax
    8c5a:	7f eb                	jg     8c47 <itox+0x21>
	if (sign < 0)
    8c5c:	85 f6                	test   %esi,%esi
    8c5e:	79 0a                	jns    8c6a <itox+0x44>
		s[i++] = '-';
    8c60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    8c63:	c6 04 13 2d          	movb   $0x2d,(%ebx,%edx,1)
    8c67:	83 c1 02             	add    $0x2,%ecx
	s[i] = '\0';
    8c6a:	c6 04 0b 00          	movb   $0x0,(%ebx,%ecx,1)
	reverse (s);
    8c6e:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    8c71:	83 c4 1c             	add    $0x1c,%esp
    8c74:	5b                   	pop    %ebx
    8c75:	5e                   	pop    %esi
    8c76:	5f                   	pop    %edi
    8c77:	5d                   	pop    %ebp
	reverse (s);
    8c78:	e9 74 ff ff ff       	jmp    8bf1 <reverse>

00008c7d <itoa>:

void
itoa (int n, char s[])
{
    8c7d:	55                   	push   %ebp
    8c7e:	89 e5                	mov    %esp,%ebp
    8c80:	83 ec 08             	sub    $0x8,%esp
	static char dec[] = "0123456789";
	itox(n, s, 10, dec);
    8c83:	68 34 90 00 00       	push   $0x9034
    8c88:	6a 0a                	push   $0xa
    8c8a:	ff 75 0c             	push   0xc(%ebp)
    8c8d:	ff 75 08             	push   0x8(%ebp)
    8c90:	e8 91 ff ff ff       	call   8c26 <itox>
}
    8c95:	83 c4 10             	add    $0x10,%esp
    8c98:	c9                   	leave
    8c99:	c3                   	ret

00008c9a <itoh>:


void
itoh (int n, char* s)
{
    8c9a:	55                   	push   %ebp
    8c9b:	89 e5                	mov    %esp,%ebp
    8c9d:	83 ec 08             	sub    $0x8,%esp
	static char hex[] = "0123456789abcdef";
	itox(n, s, 16, hex);
    8ca0:	68 20 90 00 00       	push   $0x9020
    8ca5:	6a 10                	push   $0x10
    8ca7:	ff 75 0c             	push   0xc(%ebp)
    8caa:	ff 75 08             	push   0x8(%ebp)
    8cad:	e8 74 ff ff ff       	call   8c26 <itox>
}
    8cb2:	83 c4 10             	add    $0x10,%esp
    8cb5:	c9                   	leave
    8cb6:	c3                   	ret

00008cb7 <puti>:
{
    8cb7:	55                   	push   %ebp
    8cb8:	89 e5                	mov    %esp,%ebp
    8cba:	83 ec 10             	sub    $0x10,%esp
	itoh (i, puti_str);
    8cbd:	68 c0 90 00 00       	push   $0x90c0
    8cc2:	ff 75 08             	push   0x8(%ebp)
    8cc5:	e8 d0 ff ff ff       	call   8c9a <itoh>
	putline (puti_str);
    8cca:	83 c4 10             	add    $0x10,%esp
    8ccd:	c7 45 08 c0 90 00 00 	movl   $0x90c0,0x8(%ebp)
}
    8cd4:	c9                   	leave
	putline (puti_str);
    8cd5:	e9 9a fe ff ff       	jmp    8b74 <putline>

00008cda <readsector>:
		/* do nothing */;
}

void
readsector (void *dst, uint32_t offset)
{
    8cda:	55                   	push   %ebp
    8cdb:	89 e5                	mov    %esp,%ebp
    8cdd:	57                   	push   %edi
    8cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    8ce1:	ba f7 01 00 00       	mov    $0x1f7,%edx
    8ce6:	ec                   	in     (%dx),%al
	while ((inb (0x1F7) & 0xC0) != 0x40)
    8ce7:	83 e0 c0             	and    $0xffffffc0,%eax
    8cea:	3c 40                	cmp    $0x40,%al
    8cec:	75 f3                	jne    8ce1 <readsector+0x7>
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
    8cee:	b0 01                	mov    $0x1,%al
    8cf0:	ba f2 01 00 00       	mov    $0x1f2,%edx
    8cf5:	ee                   	out    %al,(%dx)
    8cf6:	ba f3 01 00 00       	mov    $0x1f3,%edx
    8cfb:	89 c8                	mov    %ecx,%eax
    8cfd:	ee                   	out    %al,(%dx)
	// wait for disk to be ready
	waitdisk ();

	outb (0x1F2, 1);		// count = 1
	outb (0x1F3, offset);
	outb (0x1F4, offset >> 8);
    8cfe:	89 c8                	mov    %ecx,%eax
    8d00:	ba f4 01 00 00       	mov    $0x1f4,%edx
    8d05:	c1 e8 08             	shr    $0x8,%eax
    8d08:	ee                   	out    %al,(%dx)
	outb (0x1F5, offset >> 16);
    8d09:	89 c8                	mov    %ecx,%eax
    8d0b:	ba f5 01 00 00       	mov    $0x1f5,%edx
    8d10:	c1 e8 10             	shr    $0x10,%eax
    8d13:	ee                   	out    %al,(%dx)
	outb (0x1F6, (offset >> 24) | 0xE0);
    8d14:	89 c8                	mov    %ecx,%eax
    8d16:	ba f6 01 00 00       	mov    $0x1f6,%edx
    8d1b:	c1 e8 18             	shr    $0x18,%eax
    8d1e:	83 c8 e0             	or     $0xffffffe0,%eax
    8d21:	ee                   	out    %al,(%dx)
    8d22:	b0 20                	mov    $0x20,%al
    8d24:	ba f7 01 00 00       	mov    $0x1f7,%edx
    8d29:	ee                   	out    %al,(%dx)
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    8d2a:	ba f7 01 00 00       	mov    $0x1f7,%edx
    8d2f:	ec                   	in     (%dx),%al
	while ((inb (0x1F7) & 0xC0) != 0x40)
    8d30:	83 e0 c0             	and    $0xffffffc0,%eax
    8d33:	3c 40                	cmp    $0x40,%al
    8d35:	75 f8                	jne    8d2f <readsector+0x55>
}

static inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
    8d37:	8b 7d 08             	mov    0x8(%ebp),%edi
    8d3a:	b9 80 00 00 00       	mov    $0x80,%ecx
    8d3f:	ba f0 01 00 00       	mov    $0x1f0,%edx
    8d44:	fc                   	cld
    8d45:	f2 6d                	repnz insl (%dx),%es:(%edi)
	// wait for disk to be ready
	waitdisk ();

	// read a sector
	insl (0x1F0, dst, SECTOR_SIZE / 4);
}
    8d47:	5f                   	pop    %edi
    8d48:	5d                   	pop    %ebp
    8d49:	c3                   	ret

00008d4a <readsection>:

// Read 'count' bytes at 'offset' from kernel into virtual address 'va'.
// Might copy more than asked
void
readsection (uint32_t va, uint32_t count, uint32_t offset, uint32_t lba)
{
    8d4a:	55                   	push   %ebp
    8d4b:	89 e5                	mov    %esp,%ebp
    8d4d:	57                   	push   %edi
    8d4e:	56                   	push   %esi
    8d4f:	53                   	push   %ebx
    8d50:	83 ec 0c             	sub    $0xc,%esp
    8d53:	8b 5d 08             	mov    0x8(%ebp),%ebx
	end_va = va + count;
	// round down to sector boundary
	va &= ~(SECTOR_SIZE - 1);

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTOR_SIZE) + lba;
    8d56:	8b 75 10             	mov    0x10(%ebp),%esi
	va &= 0xFFFFFF;
    8d59:	89 df                	mov    %ebx,%edi
	offset = (offset / SECTOR_SIZE) + lba;
    8d5b:	c1 ee 09             	shr    $0x9,%esi
	va &= ~(SECTOR_SIZE - 1);
    8d5e:	81 e3 00 fe ff 00    	and    $0xfffe00,%ebx
	offset = (offset / SECTOR_SIZE) + lba;
    8d64:	03 75 14             	add    0x14(%ebp),%esi
	va &= 0xFFFFFF;
    8d67:	81 e7 ff ff ff 00    	and    $0xffffff,%edi
	end_va = va + count;
    8d6d:	03 7d 0c             	add    0xc(%ebp),%edi

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (va < end_va)
    8d70:	39 fb                	cmp    %edi,%ebx
    8d72:	73 15                	jae    8d89 <readsection+0x3f>
	{
		readsector ((uint8_t*) va, offset);
    8d74:	50                   	push   %eax
    8d75:	50                   	push   %eax
    8d76:	56                   	push   %esi
		va += SECTOR_SIZE;
		offset++;
    8d77:	46                   	inc    %esi
		readsector ((uint8_t*) va, offset);
    8d78:	53                   	push   %ebx
		va += SECTOR_SIZE;
    8d79:	81 c3 00 02 00 00    	add    $0x200,%ebx
		readsector ((uint8_t*) va, offset);
    8d7f:	e8 56 ff ff ff       	call   8cda <readsector>
		offset++;
    8d84:	83 c4 10             	add    $0x10,%esp
    8d87:	eb e7                	jmp    8d70 <readsection+0x26>
	}
}
    8d89:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8d8c:	5b                   	pop    %ebx
    8d8d:	5e                   	pop    %esi
    8d8e:	5f                   	pop    %edi
    8d8f:	5d                   	pop    %ebp
    8d90:	c3                   	ret

00008d91 <load_kernel>:

#define ELFHDR		((elfhdr *) 0x20000)

uint32_t
load_kernel(uint32_t dkernel)
{
    8d91:	55                   	push   %ebp
    8d92:	89 e5                	mov    %esp,%ebp
    8d94:	57                   	push   %edi
    8d95:	56                   	push   %esi
    8d96:	53                   	push   %ebx
    8d97:	83 ec 0c             	sub    $0xc,%esp
    8d9a:	8b 7d 08             	mov    0x8(%ebp),%edi
	// load kernel from the beginning of the first bootable partition
	proghdr *ph, *eph;

	readsection((uint32_t) ELFHDR, SECTOR_SIZE * 8, 0, dkernel);
    8d9d:	57                   	push   %edi
    8d9e:	6a 00                	push   $0x0
    8da0:	68 00 10 00 00       	push   $0x1000
    8da5:	68 00 00 02 00       	push   $0x20000
    8daa:	e8 9b ff ff ff       	call   8d4a <readsection>

	// is this a valid ELF?
	if (ELFHDR->e_magic != ELF_MAGIC)
    8daf:	83 c4 10             	add    $0x10,%esp
    8db2:	81 3d 00 00 02 00 7f 	cmpl   $0x464c457f,0x20000
    8db9:	45 4c 46 
    8dbc:	74 10                	je     8dce <load_kernel+0x3d>
		panic ("Kernel is not a valid elf.");
    8dbe:	83 ec 0c             	sub    $0xc,%esp
    8dc1:	68 7d 8f 00 00       	push   $0x8f7d
    8dc6:	e8 f9 fd ff ff       	call   8bc4 <panic>
    8dcb:	83 c4 10             	add    $0x10,%esp

	// load each program segment (ignores ph flags)
	ph = (proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    8dce:	a1 1c 00 02 00       	mov    0x2001c,%eax
	eph = ph + ELFHDR->e_phnum;
    8dd3:	0f b7 35 2c 00 02 00 	movzwl 0x2002c,%esi
	ph = (proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    8dda:	8d 98 00 00 02 00    	lea    0x20000(%eax),%ebx
	eph = ph + ELFHDR->e_phnum;
    8de0:	c1 e6 05             	shl    $0x5,%esi
    8de3:	01 de                	add    %ebx,%esi

	for (; ph < eph; ph++)
    8de5:	39 f3                	cmp    %esi,%ebx
    8de7:	73 17                	jae    8e00 <load_kernel+0x6f>
	{
		readsection(ph->p_va, ph->p_memsz, ph->p_offset, dkernel);
    8de9:	57                   	push   %edi
	for (; ph < eph; ph++)
    8dea:	83 c3 20             	add    $0x20,%ebx
		readsection(ph->p_va, ph->p_memsz, ph->p_offset, dkernel);
    8ded:	ff 73 e4             	push   -0x1c(%ebx)
    8df0:	ff 73 f4             	push   -0xc(%ebx)
    8df3:	ff 73 e8             	push   -0x18(%ebx)
    8df6:	e8 4f ff ff ff       	call   8d4a <readsection>
	for (; ph < eph; ph++)
    8dfb:	83 c4 10             	add    $0x10,%esp
    8dfe:	eb e5                	jmp    8de5 <load_kernel+0x54>
	}

	return (ELFHDR->e_entry & 0xFFFFFF);
    8e00:	a1 18 00 02 00       	mov    0x20018,%eax
}
    8e05:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8e08:	5b                   	pop    %ebx
    8e09:	5e                   	pop    %esi
	return (ELFHDR->e_entry & 0xFFFFFF);
    8e0a:	25 ff ff ff 00       	and    $0xffffff,%eax
}
    8e0f:	5f                   	pop    %edi
    8e10:	5d                   	pop    %ebp
    8e11:	c3                   	ret

00008e12 <parse_e820>:

mboot_info_t *
parse_e820 (bios_smap_t *smap)
{
    8e12:	55                   	push   %ebp
    8e13:	89 e5                	mov    %esp,%ebp
    8e15:	56                   	push   %esi
    8e16:	53                   	push   %ebx
    8e17:	8b 75 08             	mov    0x8(%ebp),%esi
	bios_smap_t *p;
	uint32_t mmap_len;
	p = smap;
	mmap_len = 0;
    8e1a:	31 db                	xor    %ebx,%ebx
	putline ("* E820 Memory Map *");
    8e1c:	83 ec 0c             	sub    $0xc,%esp
    8e1f:	68 98 8f 00 00       	push   $0x8f98
    8e24:	e8 4b fd ff ff       	call   8b74 <putline>
	while (p->base_addr != 0 || p->length != 0 || p->type != 0)
    8e29:	83 c4 10             	add    $0x10,%esp
    8e2c:	8b 44 1e 04          	mov    0x4(%esi,%ebx,1),%eax
    8e30:	83 7c 1e 08 00       	cmpl   $0x0,0x8(%esi,%ebx,1)
    8e35:	74 11                	je     8e48 <parse_e820+0x36>
	{
		puti (p->base_addr);
    8e37:	83 ec 0c             	sub    $0xc,%esp
		p ++;
		mmap_len += sizeof(bios_smap_t);
    8e3a:	83 c3 18             	add    $0x18,%ebx
		puti (p->base_addr);
    8e3d:	50                   	push   %eax
    8e3e:	e8 74 fe ff ff       	call   8cb7 <puti>
		mmap_len += sizeof(bios_smap_t);
    8e43:	83 c4 10             	add    $0x10,%esp
    8e46:	eb e4                	jmp    8e2c <parse_e820+0x1a>
	while (p->base_addr != 0 || p->length != 0 || p->type != 0)
    8e48:	85 c0                	test   %eax,%eax
    8e4a:	75 eb                	jne    8e37 <parse_e820+0x25>
    8e4c:	83 7c 1e 10 00       	cmpl   $0x0,0x10(%esi,%ebx,1)
    8e51:	75 e4                	jne    8e37 <parse_e820+0x25>
    8e53:	83 7c 1e 0c 00       	cmpl   $0x0,0xc(%esi,%ebx,1)
    8e58:	75 dd                	jne    8e37 <parse_e820+0x25>
    8e5a:	83 7c 1e 14 00       	cmpl   $0x0,0x14(%esi,%ebx,1)
    8e5f:	75 d6                	jne    8e37 <parse_e820+0x25>
	}
	mboot_info.mmap_length = mmap_len;
    8e61:	89 1d 8c 90 00 00    	mov    %ebx,0x908c
	mboot_info.mmap_addr = (uint32_t) smap;
	return &mboot_info;
}
    8e67:	b8 60 90 00 00       	mov    $0x9060,%eax
	mboot_info.mmap_addr = (uint32_t) smap;
    8e6c:	89 35 90 90 00 00    	mov    %esi,0x9090
}
    8e72:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8e75:	5b                   	pop    %ebx
    8e76:	5e                   	pop    %esi
    8e77:	5d                   	pop    %ebp
    8e78:	c3                   	ret

00008e79 <boot1main>:
{
    8e79:	55                   	push   %ebp
    8e7a:	89 e5                	mov    %esp,%ebp
    8e7c:	56                   	push   %esi
    8e7d:	53                   	push   %ebx
    8e7e:	8b 75 0c             	mov    0xc(%ebp),%esi
    8e81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	roll(3); putline("Start boot1 main ...");
    8e84:	83 ec 0c             	sub    $0xc,%esp
    8e87:	6a 03                	push   $0x3
    8e89:	e8 29 fd ff ff       	call   8bb7 <roll>
    8e8e:	c7 04 24 ac 8f 00 00 	movl   $0x8fac,(%esp)
    8e95:	e8 da fc ff ff       	call   8b74 <putline>
    8e9a:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 4; i++)
    8e9d:	31 c0                	xor    %eax,%eax
		if ( mbr->partition[i].bootable == BOOTABLE_PARTITION)
    8e9f:	89 c2                	mov    %eax,%edx
    8ea1:	c1 e2 04             	shl    $0x4,%edx
    8ea4:	80 bc 16 be 01 00 00 	cmpb   $0x80,0x1be(%esi,%edx,1)
    8eab:	80 
    8eac:	75 09                	jne    8eb7 <boot1main+0x3e>
			bootable_lba = mbr->partition[i].first_lba;
    8eae:	8b b4 16 c6 01 00 00 	mov    0x1c6(%esi,%edx,1),%esi
	if (i == 4)
    8eb5:	eb 18                	jmp    8ecf <boot1main+0x56>
	for (i = 0; i < 4; i++)
    8eb7:	40                   	inc    %eax
    8eb8:	83 f8 04             	cmp    $0x4,%eax
    8ebb:	75 e2                	jne    8e9f <boot1main+0x26>
		panic ("Cannot find bootable partition!");
    8ebd:	83 ec 0c             	sub    $0xc,%esp
    8ec0:	31 f6                	xor    %esi,%esi
    8ec2:	68 c1 8f 00 00       	push   $0x8fc1
    8ec7:	e8 f8 fc ff ff       	call   8bc4 <panic>
    8ecc:	83 c4 10             	add    $0x10,%esp
	parse_e820 (smap);
    8ecf:	83 ec 0c             	sub    $0xc,%esp
    8ed2:	53                   	push   %ebx
    8ed3:	e8 3a ff ff ff       	call   8e12 <parse_e820>
	putline ("Load kernel ...\n");
    8ed8:	c7 04 24 e1 8f 00 00 	movl   $0x8fe1,(%esp)
    8edf:	e8 90 fc ff ff       	call   8b74 <putline>
	uint32_t entry = load_kernel(bootable_lba);
    8ee4:	89 34 24             	mov    %esi,(%esp)
    8ee7:	e8 a5 fe ff ff       	call   8d91 <load_kernel>
	putline ("Start kernel ...\n");
    8eec:	c7 04 24 f2 8f 00 00 	movl   $0x8ff2,(%esp)
	uint32_t entry = load_kernel(bootable_lba);
    8ef3:	89 c3                	mov    %eax,%ebx
	putline ("Start kernel ...\n");
    8ef5:	e8 7a fc ff ff       	call   8b74 <putline>
	exec_kernel (entry, &mboot_info);
    8efa:	58                   	pop    %eax
    8efb:	5a                   	pop    %edx
    8efc:	68 60 90 00 00       	push   $0x9060
    8f01:	53                   	push   %ebx
    8f02:	e8 15 00 00 00       	call   8f1c <exec_kernel>
	panic ("Fail to load kernel.");
    8f07:	83 c4 10             	add    $0x10,%esp
    8f0a:	c7 45 08 04 90 00 00 	movl   $0x9004,0x8(%ebp)
}
    8f11:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8f14:	5b                   	pop    %ebx
    8f15:	5e                   	pop    %esi
    8f16:	5d                   	pop    %ebp
	panic ("Fail to load kernel.");
    8f17:	e9 a8 fc ff ff       	jmp    8bc4 <panic>

00008f1c <exec_kernel>:
	.set  MBOOT_INFO_MAGIC, 0x2badb002

	.globl	exec_kernel
	.code32
exec_kernel:
	cli
    8f1c:	fa                   	cli
	movl	$MBOOT_INFO_MAGIC, %eax
    8f1d:	b8 02 b0 ad 2b       	mov    $0x2badb002,%eax
	movl	8(%esp), %ebx
    8f22:	8b 5c 24 08          	mov    0x8(%esp),%ebx
	movl	4(%esp), %edx
    8f26:	8b 54 24 04          	mov    0x4(%esp),%edx
	jmp	*%edx
    8f2a:	ff e2                	jmp    *%edx

Disassembly of section .rodata:

00008f2c <.rodata>:
    8f2c:	20 20                	and    %ah,(%eax)
    8f2e:	20 20                	and    %ah,(%eax)
    8f30:	20 20                	and    %ah,(%eax)
    8f32:	20 20                	and    %ah,(%eax)
    8f34:	20 20                	and    %ah,(%eax)
    8f36:	20 20                	and    %ah,(%eax)
    8f38:	20 20                	and    %ah,(%eax)
    8f3a:	20 20                	and    %ah,(%eax)
    8f3c:	20 20                	and    %ah,(%eax)
    8f3e:	20 20                	and    %ah,(%eax)
    8f40:	20 20                	and    %ah,(%eax)
    8f42:	20 20                	and    %ah,(%eax)
    8f44:	20 20                	and    %ah,(%eax)
    8f46:	20 20                	and    %ah,(%eax)
    8f48:	20 20                	and    %ah,(%eax)
    8f4a:	20 20                	and    %ah,(%eax)
    8f4c:	20 20                	and    %ah,(%eax)
    8f4e:	20 20                	and    %ah,(%eax)
    8f50:	20 20                	and    %ah,(%eax)
    8f52:	20 20                	and    %ah,(%eax)
    8f54:	20 20                	and    %ah,(%eax)
    8f56:	20 20                	and    %ah,(%eax)
    8f58:	20 20                	and    %ah,(%eax)
    8f5a:	20 20                	and    %ah,(%eax)
    8f5c:	20 20                	and    %ah,(%eax)
    8f5e:	20 20                	and    %ah,(%eax)
    8f60:	20 20                	and    %ah,(%eax)
    8f62:	20 20                	and    %ah,(%eax)
    8f64:	20 20                	and    %ah,(%eax)
    8f66:	20 20                	and    %ah,(%eax)
    8f68:	20 20                	and    %ah,(%eax)
    8f6a:	20 20                	and    %ah,(%eax)
    8f6c:	20 20                	and    %ah,(%eax)
    8f6e:	20 20                	and    %ah,(%eax)
    8f70:	20 20                	and    %ah,(%eax)
    8f72:	20 20                	and    %ah,(%eax)
    8f74:	20 20                	and    %ah,(%eax)
    8f76:	20 20                	and    %ah,(%eax)
    8f78:	20 20                	and    %ah,(%eax)
    8f7a:	20 20                	and    %ah,(%eax)
    8f7c:	00 4b 65             	add    %cl,0x65(%ebx)
    8f7f:	72 6e                	jb     8fef <exec_kernel+0xd3>
    8f81:	65 6c                	gs insb (%dx),%es:(%edi)
    8f83:	20 69 73             	and    %ch,0x73(%ecx)
    8f86:	20 6e 6f             	and    %ch,0x6f(%esi)
    8f89:	74 20                	je     8fab <exec_kernel+0x8f>
    8f8b:	61                   	popa
    8f8c:	20 76 61             	and    %dh,0x61(%esi)
    8f8f:	6c                   	insb   (%dx),%es:(%edi)
    8f90:	69 64 20 65 6c 66 2e 	imul   $0x2e666c,0x65(%eax,%eiz,1),%esp
    8f97:	00 
    8f98:	2a 20                	sub    (%eax),%ah
    8f9a:	45                   	inc    %ebp
    8f9b:	38 32                	cmp    %dh,(%edx)
    8f9d:	30 20                	xor    %ah,(%eax)
    8f9f:	4d                   	dec    %ebp
    8fa0:	65 6d                	gs insl (%dx),%es:(%edi)
    8fa2:	6f                   	outsl  %ds:(%esi),(%dx)
    8fa3:	72 79                	jb     901e <exec_kernel+0x102>
    8fa5:	20 4d 61             	and    %cl,0x61(%ebp)
    8fa8:	70 20                	jo     8fca <exec_kernel+0xae>
    8faa:	2a 00                	sub    (%eax),%al
    8fac:	53                   	push   %ebx
    8fad:	74 61                	je     9010 <exec_kernel+0xf4>
    8faf:	72 74                	jb     9025 <hex.0+0x5>
    8fb1:	20 62 6f             	and    %ah,0x6f(%edx)
    8fb4:	6f                   	outsl  %ds:(%esi),(%dx)
    8fb5:	74 31                	je     8fe8 <exec_kernel+0xcc>
    8fb7:	20 6d 61             	and    %ch,0x61(%ebp)
    8fba:	69 6e 20 2e 2e 2e 00 	imul   $0x2e2e2e,0x20(%esi),%ebp
    8fc1:	43                   	inc    %ebx
    8fc2:	61                   	popa
    8fc3:	6e                   	outsb  %ds:(%esi),(%dx)
    8fc4:	6e                   	outsb  %ds:(%esi),(%dx)
    8fc5:	6f                   	outsl  %ds:(%esi),(%dx)
    8fc6:	74 20                	je     8fe8 <exec_kernel+0xcc>
    8fc8:	66 69 6e 64 20 62    	imul   $0x6220,0x64(%esi),%bp
    8fce:	6f                   	outsl  %ds:(%esi),(%dx)
    8fcf:	6f                   	outsl  %ds:(%esi),(%dx)
    8fd0:	74 61                	je     9033 <hex.0+0x13>
    8fd2:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
    8fd6:	70 61                	jo     9039 <dec.1+0x5>
    8fd8:	72 74                	jb     904e <video+0xa>
    8fda:	69 74 69 6f 6e 21 00 	imul   $0x4c00216e,0x6f(%ecx,%ebp,2),%esi
    8fe1:	4c 
    8fe2:	6f                   	outsl  %ds:(%esi),(%dx)
    8fe3:	61                   	popa
    8fe4:	64 20 6b 65          	and    %ch,%fs:0x65(%ebx)
    8fe8:	72 6e                	jb     9058 <video+0x14>
    8fea:	65 6c                	gs insb (%dx),%es:(%edi)
    8fec:	20 2e                	and    %ch,(%esi)
    8fee:	2e 2e 0a 00          	cs or  %cs:(%eax),%al
    8ff2:	53                   	push   %ebx
    8ff3:	74 61                	je     9056 <video+0x12>
    8ff5:	72 74                	jb     906b <mboot_info+0xb>
    8ff7:	20 6b 65             	and    %ch,0x65(%ebx)
    8ffa:	72 6e                	jb     906a <mboot_info+0xa>
    8ffc:	65 6c                	gs insb (%dx),%es:(%edi)
    8ffe:	20 2e                	and    %ch,(%esi)
    9000:	2e 2e 0a 00          	cs or  %cs:(%eax),%al
    9004:	46                   	inc    %esi
    9005:	61                   	popa
    9006:	69 6c 20 74 6f 20 6c 	imul   $0x6f6c206f,0x74(%eax,%eiz,1),%ebp
    900d:	6f 
    900e:	61                   	popa
    900f:	64 20 6b 65          	and    %ch,%fs:0x65(%ebx)
    9013:	72 6e                	jb     9083 <mboot_info+0x23>
    9015:	65 6c                	gs insb (%dx),%es:(%edi)
    9017:	2e                   	cs
    9018:	00                   	.byte 0

Disassembly of section .data:

00009020 <hex.0>:
	static char hex[] = "0123456789abcdef";
    9020:	30 31                	xor    %dh,(%ecx)
    9022:	32 33                	xor    (%ebx),%dh
    9024:	34 35                	xor    $0x35,%al
    9026:	36 37                	ss aaa
    9028:	38 39                	cmp    %bh,(%ecx)
    902a:	61                   	popa
    902b:	62 63 64             	bound  %esp,0x64(%ebx)
    902e:	65 66 00 00          	data16 add %al,%gs:(%eax)
    9032:	00 00                	add    %al,(%eax)

00009034 <dec.1>:
	static char dec[] = "0123456789";
    9034:	30 31                	xor    %dh,(%ecx)
    9036:	32 33                	xor    (%ebx),%dh
    9038:	34 35                	xor    $0x35,%al
    903a:	36 37                	ss aaa
    903c:	38 39                	cmp    %bh,(%ecx)
    903e:	00 00                	add    %al,(%eax)

00009040 <blank>:
char * blank =
    9040:	2c 8f                	sub    $0x8f,%al
    9042:	00 00                	add    %al,(%eax)

00009044 <video>:
volatile char *video = (volatile char*) 0xB8000;
    9044:	00 80 0b 00 00 00    	add    %al,0xb(%eax)
    904a:	00 00                	add    %al,(%eax)
    904c:	00 00                	add    %al,(%eax)
    904e:	00 00                	add    %al,(%eax)
    9050:	00 00                	add    %al,(%eax)
    9052:	00 00                	add    %al,(%eax)
    9054:	00 00                	add    %al,(%eax)
    9056:	00 00                	add    %al,(%eax)
    9058:	00 00                	add    %al,(%eax)
    905a:	00 00                	add    %al,(%eax)
    905c:	00 00                	add    %al,(%eax)
    905e:	00 00                	add    %al,(%eax)

00009060 <mboot_info>:
mboot_info_t mboot_info =
    9060:	40                   	inc    %eax
    9061:	00 00                	add    %al,(%eax)
    9063:	00 00                	add    %al,(%eax)
    9065:	00 00                	add    %al,(%eax)
    9067:	00 00                	add    %al,(%eax)
    9069:	00 00                	add    %al,(%eax)
    906b:	00 00                	add    %al,(%eax)
    906d:	00 00                	add    %al,(%eax)
    906f:	00 00                	add    %al,(%eax)
    9071:	00 00                	add    %al,(%eax)
    9073:	00 00                	add    %al,(%eax)
    9075:	00 00                	add    %al,(%eax)
    9077:	00 00                	add    %al,(%eax)
    9079:	00 00                	add    %al,(%eax)
    907b:	00 00                	add    %al,(%eax)
    907d:	00 00                	add    %al,(%eax)
    907f:	00 00                	add    %al,(%eax)
    9081:	00 00                	add    %al,(%eax)
    9083:	00 00                	add    %al,(%eax)
    9085:	00 00                	add    %al,(%eax)
    9087:	00 00                	add    %al,(%eax)
    9089:	00 00                	add    %al,(%eax)
    908b:	00 00                	add    %al,(%eax)
    908d:	00 00                	add    %al,(%eax)
    908f:	00 00                	add    %al,(%eax)
    9091:	00 00                	add    %al,(%eax)
    9093:	00 00                	add    %al,(%eax)
    9095:	00 00                	add    %al,(%eax)
    9097:	00 00                	add    %al,(%eax)
    9099:	00 00                	add    %al,(%eax)
    909b:	00 00                	add    %al,(%eax)
    909d:	00 00                	add    %al,(%eax)
    909f:	00 00                	add    %al,(%eax)
    90a1:	00 00                	add    %al,(%eax)
    90a3:	00 00                	add    %al,(%eax)
    90a5:	00 00                	add    %al,(%eax)
    90a7:	00 00                	add    %al,(%eax)
    90a9:	00 00                	add    %al,(%eax)
    90ab:	00 00                	add    %al,(%eax)
    90ad:	00 00                	add    %al,(%eax)
    90af:	00 00                	add    %al,(%eax)
    90b1:	00 00                	add    %al,(%eax)
    90b3:	00 00                	add    %al,(%eax)
    90b5:	00 00                	add    %al,(%eax)
    90b7:	00 00                	add    %al,(%eax)
    90b9:	00 00                	add    %al,(%eax)
    90bb:	00 00                	add    %al,(%eax)
    90bd:	00 00                	add    %al,(%eax)
    90bf:	00                   	.byte 0

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    %edi
   1:	43                   	inc    %ebx
   2:	43                   	inc    %ebx
   3:	3a 20                	cmp    (%eax),%ah
   5:	28 47 4e             	sub    %al,0x4e(%edi)
   8:	55                   	push   %ebp
   9:	29 20                	sub    %esp,(%eax)
   b:	31 35 2e 32 2e 30    	xor    %esi,0x302e322e
  11:	00                   	.byte 0

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	1c 00                	sbb    $0x0,%al
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	00 00                	add    %al,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	04 00                	add    $0x0,%al
   c:	00 00                	add    %al,(%eax)
   e:	00 00                	add    %al,(%eax)
  10:	00 7e 00             	add    %bh,0x0(%esi)
  13:	00 26                	add    %ah,(%esi)
  15:	0d 00 00 00 00       	or     $0x0,%eax
  1a:	00 00                	add    %al,(%eax)
  1c:	00 00                	add    %al,(%eax)
  1e:	00 00                	add    %al,(%eax)
  20:	1c 00                	sbb    $0x0,%al
  22:	00 00                	add    %al,(%eax)
  24:	02 00                	add    (%eax),%al
  26:	25 00 00 00 04       	and    $0x4000000,%eax
  2b:	00 00                	add    %al,(%eax)
  2d:	00 00                	add    %al,(%eax)
  2f:	00 26                	add    %ah,(%esi)
  31:	8b 00                	mov    (%eax),%eax
  33:	00 6b 02             	add    %ch,0x2(%ebx)
  36:	00 00                	add    %al,(%eax)
  38:	00 00                	add    %al,(%eax)
  3a:	00 00                	add    %al,(%eax)
  3c:	00 00                	add    %al,(%eax)
  3e:	00 00                	add    %al,(%eax)
  40:	1c 00                	sbb    $0x0,%al
  42:	00 00                	add    %al,(%eax)
  44:	02 00                	add    (%eax),%al
  46:	6d                   	insl   (%dx),%es:(%edi)
  47:	07                   	pop    %es
  48:	00 00                	add    %al,(%eax)
  4a:	04 00                	add    $0x0,%al
  4c:	00 00                	add    %al,(%eax)
  4e:	00 00                	add    %al,(%eax)
  50:	91                   	xchg   %eax,%ecx
  51:	8d 00                	lea    (%eax),%eax
  53:	00 8b 01 00 00 00    	add    %cl,0x1(%ebx)
  59:	00 00                	add    %al,(%eax)
  5b:	00 00                	add    %al,(%eax)
  5d:	00 00                	add    %al,(%eax)
  5f:	00 1c 00             	add    %bl,(%eax,%eax,1)
  62:	00 00                	add    %al,(%eax)
  64:	02 00                	add    (%eax),%al
  66:	bf 0e 00 00 04       	mov    $0x400000e,%edi
  6b:	00 00                	add    %al,(%eax)
  6d:	00 00                	add    %al,(%eax)
  6f:	00 1c 8f             	add    %bl,(%edi,%ecx,4)
  72:	00 00                	add    %al,(%eax)
  74:	10 00                	adc    %al,(%eax)
  76:	00 00                	add    %al,(%eax)
  78:	00 00                	add    %al,(%eax)
  7a:	00 00                	add    %al,(%eax)
  7c:	00 00                	add    %al,(%eax)
  7e:	00 00                	add    %al,(%eax)

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	21 00                	and    %eax,(%eax)
   2:	00 00                	add    %al,(%eax)
   4:	05 00 01 04 00       	add    $0x40100,%eax
   9:	00 00                	add    %al,(%eax)
   b:	00 01                	add    %al,(%ecx)
   d:	00 00                	add    %al,(%eax)
   f:	00 00                	add    %al,(%eax)
  11:	00 7e 00             	add    %bh,0x0(%esi)
  14:	00 a6 1a 00 00 00    	add    %ah,0x1a(%esi)
  1a:	00 13                	add    %dl,(%ebx)
  1c:	00 00                	add    %al,(%eax)
  1e:	00 4a 00             	add    %cl,0x0(%edx)
  21:	00 00                	add    %al,(%eax)
  23:	01 80 44 07 00 00    	add    %eax,0x744(%eax)
  29:	05 00 01 04 14       	add    $0x14040100,%eax
  2e:	00 00                	add    %al,(%eax)
  30:	00 18                	add    %bl,(%eax)
  32:	c2 00 00             	ret    $0x0
  35:	00 01                	add    %al,(%ecx)
  37:	4a                   	dec    %edx
  38:	00 00                	add    %al,(%eax)
  3a:	00 00                	add    %al,(%eax)
  3c:	00 00                	add    %al,(%eax)
  3e:	00 26                	add    %ah,(%esi)
  40:	8b 00                	mov    (%eax),%eax
  42:	00 6b 02             	add    %ch,0x2(%ebx)
  45:	00 00                	add    %al,(%eax)
  47:	87 00                	xchg   %eax,(%eax)
  49:	00 00                	add    %al,(%eax)
  4b:	04 01                	add    $0x1,%al
  4d:	06                   	push   %es
  4e:	42                   	inc    %edx
  4f:	01 00                	add    %eax,(%eax)
  51:	00 0c a2             	add    %cl,(%edx,%eiz,4)
  54:	00 00                	add    %al,(%eax)
  56:	00 0d 17 38 00 00    	add    %cl,0x3817
  5c:	00 04 01             	add    %al,(%ecx,%eax,1)
  5f:	08 40 01             	or     %al,0x1(%eax)
  62:	00 00                	add    %al,(%eax)
  64:	04 02                	add    $0x2,%al
  66:	05 70 00 00 00       	add    $0x70,%eax
  6b:	04 02                	add    $0x2,%al
  6d:	07                   	pop    %es
  6e:	82 01 00             	addb   $0x0,(%ecx)
  71:	00 0c 70             	add    %cl,(%eax,%esi,2)
  74:	01 00                	add    %eax,(%eax)
  76:	00 10                	add    %dl,(%eax)
  78:	0d 58 00 00 00       	or     $0x58,%eax
  7d:	19 04 05 69 6e 74 00 	sbb    %eax,0x746e69(,%eax,1)
  84:	0c 6f                	or     $0x6f,%al
  86:	01 00                	add    %eax,(%eax)
  88:	00 11                	add    %dl,(%ecx)
  8a:	16                   	push   %ss
  8b:	6a 00                	push   $0x0
  8d:	00 00                	add    %al,(%eax)
  8f:	04 04                	add    $0x4,%al
  91:	07                   	pop    %es
  92:	62 01                	bound  %eax,(%ecx)
  94:	00 00                	add    %al,(%eax)
  96:	04 08                	add    $0x8,%al
  98:	05 b4 00 00 00       	add    $0xb4,%eax
  9d:	04 08                	add    $0x8,%al
  9f:	07                   	pop    %es
  a0:	58                   	pop    %eax
  a1:	01 00                	add    %eax,(%eax)
  a3:	00 04 04             	add    %al,(%esp,%eax,1)
  a6:	07                   	pop    %es
  a7:	5d                   	pop    %ebp
  a8:	01 00                	add    %eax,(%eax)
  aa:	00 12                	add    %dl,(%edx)
  ac:	c7 01 00 00 06 10    	movl   $0x10060000,(%ecx)
  b2:	97                   	xchg   %eax,%edi
  b3:	00 00                	add    %al,(%eax)
  b5:	00 05 03 44 90 00    	add    %al,0x904403
  bb:	00 0d a3 00 00 00    	add    %cl,0xa3
  c1:	04 01                	add    $0x1,%al
  c3:	06                   	push   %es
  c4:	49                   	dec    %ecx
  c5:	01 00                	add    %eax,(%eax)
  c7:	00 1a                	add    %bl,(%edx)
  c9:	9c                   	pushf
  ca:	00 00                	add    %al,(%eax)
  cc:	00 1b                	add    %bl,(%ebx)
  ce:	9c                   	pushf
  cf:	00 00                	add    %al,(%eax)
  d1:	00 0e                	add    %cl,(%esi)
  d3:	72 6f                	jb     144 <PR_BOOTABLE+0xc4>
  d5:	77 00                	ja     d7 <PR_BOOTABLE+0x57>
  d7:	1c 0c                	sbb    $0xc,%al
  d9:	58                   	pop    %eax
  da:	00 00                	add    %al,(%eax)
  dc:	00 05 03 e8 90 00    	add    %al,0x90e803
  e2:	00 12                	add    %dl,(%edx)
  e4:	bc 01 00 00 1e       	mov    $0x1e000001,%esp
  e9:	08 cf                	or     %cl,%bh
  eb:	00 00                	add    %al,(%eax)
  ed:	00 05 03 40 90 00    	add    %al,0x904003
  f3:	00 0d 9c 00 00 00    	add    %cl,0x9c
  f9:	0f 9c 00             	setl   (%eax)
  fc:	00 00                	add    %al,(%eax)
  fe:	e4 00                	in     $0x0,%al
 100:	00 00                	add    %al,(%eax)
 102:	10 7f 00             	adc    %bh,0x0(%edi)
 105:	00 00                	add    %al,(%eax)
 107:	27                   	daa
 108:	00 1c b3             	add    %bl,(%ebx,%esi,4)
 10b:	01 00                	add    %eax,(%eax)
 10d:	00 01                	add    %al,(%ecx)
 10f:	38 0d d4 00 00 00    	cmp    %cl,0xd4
 115:	05 03 c0 90 00       	add    $0x90c003,%eax
 11a:	00 02                	add    %al,(%edx)
 11c:	2f                   	das
 11d:	01 00                	add    %eax,(%eax)
 11f:	00 a4 4a 8d 00 00 47 	add    %ah,0x4700008d(%edx,%ecx,2)
 126:	00 00                	add    %al,(%eax)
 128:	00 01                	add    %al,(%ecx)
 12a:	9c                   	pushf
 12b:	72 01                	jb     12e <PR_BOOTABLE+0xae>
 12d:	00 00                	add    %al,(%eax)
 12f:	06                   	push   %es
 130:	76 61                	jbe    193 <PR_BOOTABLE+0x113>
 132:	00 a4 17 5f 00 00 00 	add    %ah,0x5f(%edi,%edx,1)
 139:	1e                   	push   %ds
 13a:	00 00                	add    %al,(%eax)
 13c:	00 0c 00             	add    %cl,(%eax,%eax,1)
 13f:	00 00                	add    %al,(%eax)
 141:	0a 6f 04             	or     0x4(%edi),%ch
 144:	00 00                	add    %al,(%eax)
 146:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 147:	24 5f                	and    $0x5f,%al
 149:	00 00                	add    %al,(%eax)
 14b:	00 80 00 00 00 7c    	add    %al,0x7c000000(%eax)
 151:	00 00                	add    %al,(%eax)
 153:	00 0a                	add    %cl,(%edx)
 155:	32 02                	xor    (%edx),%al
 157:	00 00                	add    %al,(%eax)
 159:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 15a:	34 5f                	xor    $0x5f,%al
 15c:	00 00                	add    %al,(%eax)
 15e:	00 9b 00 00 00 91    	add    %bl,-0x6f000000(%ebx)
 164:	00 00                	add    %al,(%eax)
 166:	00 06                	add    %al,(%esi)
 168:	6c                   	insb   (%dx),%es:(%edi)
 169:	62 61 00             	bound  %esp,0x0(%ecx)
 16c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 16d:	45                   	inc    %ebp
 16e:	5f                   	pop    %edi
 16f:	00 00                	add    %al,(%eax)
 171:	00 c7                	add    %al,%bh
 173:	00 00                	add    %al,(%eax)
 175:	00 c3                	add    %al,%bl
 177:	00 00                	add    %al,(%eax)
 179:	00 13                	add    %dl,(%ebx)
 17b:	58                   	pop    %eax
 17c:	00 00                	add    %al,(%eax)
 17e:	00 a6 0b 5f 00 00    	add    %ah,0x5f0b(%esi)
 184:	00 de                	add    %bl,%dh
 186:	00 00                	add    %al,(%eax)
 188:	00 d8                	add    %bl,%al
 18a:	00 00                	add    %al,(%eax)
 18c:	00 05 84 8d 00 00    	add    %al,0x8d84
 192:	72 01                	jb     195 <PR_BOOTABLE+0x115>
 194:	00 00                	add    %al,(%eax)
 196:	00 02                	add    %al,(%edx)
 198:	97                   	xchg   %eax,%edi
 199:	00 00                	add    %al,(%eax)
 19b:	00 8e da 8c 00 00    	add    %cl,0x8cda(%esi)
 1a1:	70 00                	jo     1a3 <PR_BOOTABLE+0x123>
 1a3:	00 00                	add    %al,(%eax)
 1a5:	01 9c 7a 03 00 00 03 	add    %ebx,0x3000003(%edx,%edi,2)
 1ac:	64 73 74             	fs jae 223 <PR_BOOTABLE+0x1a3>
 1af:	00 8e 13 7a 03 00    	add    %cl,0x37a13(%esi)
 1b5:	00 02                	add    %al,(%edx)
 1b7:	91                   	xchg   %eax,%ecx
 1b8:	00 0b                	add    %cl,(%ebx)
 1ba:	32 02                	xor    (%edx),%al
 1bc:	00 00                	add    %al,(%eax)
 1be:	8e 21                	mov    (%ecx),%fs
 1c0:	5f                   	pop    %edi
 1c1:	00 00                	add    %al,(%eax)
 1c3:	00 02                	add    %al,(%edx)
 1c5:	91                   	xchg   %eax,%ecx
 1c6:	04 08                	add    $0x8,%al
 1c8:	7c 03                	jl     1cd <PR_BOOTABLE+0x14d>
 1ca:	00 00                	add    %al,(%eax)
 1cc:	e1 8c                	loope  15a <PR_BOOTABLE+0xda>
 1ce:	00 00                	add    %al,(%eax)
 1d0:	01 e1                	add    %esp,%ecx
 1d2:	8c 00                	mov    %es,(%eax)
 1d4:	00 0d 00 00 00 91    	add    %cl,0x91000000
 1da:	e1 01                	loope  1dd <PR_BOOTABLE+0x15d>
 1dc:	00 00                	add    %al,(%eax)
 1de:	14 fe                	adc    $0xfe,%al
 1e0:	06                   	push   %es
 1e1:	00 00                	add    %al,(%eax)
 1e3:	e1 8c                	loope  171 <PR_BOOTABLE+0xf1>
 1e5:	00 00                	add    %al,(%eax)
 1e7:	04 e1                	add    $0xe1,%al
 1e9:	8c 00                	mov    %es,(%eax)
 1eb:	00 06                	add    %al,(%esi)
 1ed:	00 00                	add    %al,(%eax)
 1ef:	00 89 0a 01 0f 07    	add    %cl,0x70f010a(%ecx)
 1f5:	00 00                	add    %al,(%eax)
 1f7:	10 01                	adc    %al,(%ecx)
 1f9:	00 00                	add    %al,(%eax)
 1fb:	0e                   	push   %cs
 1fc:	01 00                	add    %eax,(%eax)
 1fe:	00 15 1a 07 00 00    	add    %dl,0x71a
 204:	00 00                	add    %al,(%eax)
 206:	08 27                	or     %ah,(%edi)
 208:	07                   	pop    %es
 209:	00 00                	add    %al,(%eax)
 20b:	ee                   	out    %al,(%dx)
 20c:	8c 00                	mov    %es,(%eax)
 20e:	00 01                	add    %al,(%ecx)
 210:	ee                   	out    %al,(%dx)
 211:	8c 00                	mov    %es,(%eax)
 213:	00 08                	add    %cl,(%eax)
 215:	00 00                	add    %al,(%eax)
 217:	00 93 13 02 00 00    	add    %dl,0x213(%ebx)
 21d:	01 30                	add    %esi,(%eax)
 21f:	07                   	pop    %es
 220:	00 00                	add    %al,(%eax)
 222:	1d 01 00 00 1b       	sbb    $0x1b000001,%eax
 227:	01 00                	add    %eax,(%eax)
 229:	00 01                	add    %al,(%ecx)
 22b:	3b 07                	cmp    (%edi),%eax
 22d:	00 00                	add    %al,(%eax)
 22f:	2a 01                	sub    (%ecx),%al
 231:	00 00                	add    %al,(%eax)
 233:	28 01                	sub    %al,(%ecx)
 235:	00 00                	add    %al,(%eax)
 237:	00 08                	add    %cl,(%eax)
 239:	27                   	daa
 23a:	07                   	pop    %es
 23b:	00 00                	add    %al,(%eax)
 23d:	f6 8c 00 00 02 f6 8c 	testb  $0x0,-0x7309fe00(%eax,%eax,1)
 244:	00 
 245:	00 08                	add    %cl,(%eax)
 247:	00 00                	add    %al,(%eax)
 249:	00 94 45 02 00 00 01 	add    %dl,0x1000002(%ebp,%eax,2)
 250:	30 07                	xor    %al,(%edi)
 252:	00 00                	add    %al,(%eax)
 254:	35 01 00 00 33       	xor    $0x33000001,%eax
 259:	01 00                	add    %eax,(%eax)
 25b:	00 01                	add    %al,(%ecx)
 25d:	3b 07                	cmp    (%edi),%eax
 25f:	00 00                	add    %al,(%eax)
 261:	42                   	inc    %edx
 262:	01 00                	add    %eax,(%eax)
 264:	00 40 01             	add    %al,0x1(%eax)
 267:	00 00                	add    %al,(%eax)
 269:	00 11                	add    %dl,(%ecx)
 26b:	27                   	daa
 26c:	07                   	pop    %es
 26d:	00 00                	add    %al,(%eax)
 26f:	fe 8c 00 00 02 0c 00 	decb   0xc0200(%eax,%eax,1)
 276:	00 00                	add    %al,(%eax)
 278:	95                   	xchg   %eax,%ebp
 279:	73 02                	jae    27d <PR_BOOTABLE+0x1fd>
 27b:	00 00                	add    %al,(%eax)
 27d:	01 30                	add    %esi,(%eax)
 27f:	07                   	pop    %es
 280:	00 00                	add    %al,(%eax)
 282:	4c                   	dec    %esp
 283:	01 00                	add    %eax,(%eax)
 285:	00 4a 01             	add    %cl,0x1(%edx)
 288:	00 00                	add    %al,(%eax)
 28a:	01 3b                	add    %edi,(%ebx)
 28c:	07                   	pop    %es
 28d:	00 00                	add    %al,(%eax)
 28f:	59                   	pop    %ecx
 290:	01 00                	add    %eax,(%eax)
 292:	00 57 01             	add    %dl,0x1(%edi)
 295:	00 00                	add    %al,(%eax)
 297:	00 11                	add    %dl,(%ecx)
 299:	27                   	daa
 29a:	07                   	pop    %es
 29b:	00 00                	add    %al,(%eax)
 29d:	09 8d 00 00 02 1c    	or     %ecx,0x1c020000(%ebp)
 2a3:	00 00                	add    %al,(%eax)
 2a5:	00 96 a1 02 00 00    	add    %dl,0x2a1(%esi)
 2ab:	01 30                	add    %esi,(%eax)
 2ad:	07                   	pop    %es
 2ae:	00 00                	add    %al,(%eax)
 2b0:	64 01 00             	add    %eax,%fs:(%eax)
 2b3:	00 62 01             	add    %ah,0x1(%edx)
 2b6:	00 00                	add    %al,(%eax)
 2b8:	01 3b                	add    %edi,(%ebx)
 2ba:	07                   	pop    %es
 2bb:	00 00                	add    %al,(%eax)
 2bd:	71 01                	jno    2c0 <PR_BOOTABLE+0x240>
 2bf:	00 00                	add    %al,(%eax)
 2c1:	6f                   	outsl  %ds:(%esi),(%dx)
 2c2:	01 00                	add    %eax,(%eax)
 2c4:	00 00                	add    %al,(%eax)
 2c6:	11 27                	adc    %esp,(%edi)
 2c8:	07                   	pop    %es
 2c9:	00 00                	add    %al,(%eax)
 2cb:	14 8d                	adc    $0x8d,%al
 2cd:	00 00                	add    %al,(%eax)
 2cf:	02 2c 00             	add    (%eax,%eax,1),%ch
 2d2:	00 00                	add    %al,(%eax)
 2d4:	97                   	xchg   %eax,%edi
 2d5:	cf                   	iret
 2d6:	02 00                	add    (%eax),%al
 2d8:	00 01                	add    %al,(%ecx)
 2da:	30 07                	xor    %al,(%edi)
 2dc:	00 00                	add    %al,(%eax)
 2de:	7c 01                	jl     2e1 <PR_BOOTABLE+0x261>
 2e0:	00 00                	add    %al,(%eax)
 2e2:	7a 01                	jp     2e5 <PR_BOOTABLE+0x265>
 2e4:	00 00                	add    %al,(%eax)
 2e6:	01 3b                	add    %edi,(%ebx)
 2e8:	07                   	pop    %es
 2e9:	00 00                	add    %al,(%eax)
 2eb:	89 01                	mov    %eax,(%ecx)
 2ed:	00 00                	add    %al,(%eax)
 2ef:	87 01                	xchg   %eax,(%ecx)
 2f1:	00 00                	add    %al,(%eax)
 2f3:	00 08                	add    %cl,(%eax)
 2f5:	27                   	daa
 2f6:	07                   	pop    %es
 2f7:	00 00                	add    %al,(%eax)
 2f9:	22 8d 00 00 02 22    	and    0x22020000(%ebp),%cl
 2ff:	8d 00                	lea    (%eax),%eax
 301:	00 08                	add    %cl,(%eax)
 303:	00 00                	add    %al,(%eax)
 305:	00 98 01 03 00 00    	add    %bl,0x301(%eax)
 30b:	01 30                	add    %esi,(%eax)
 30d:	07                   	pop    %es
 30e:	00 00                	add    %al,(%eax)
 310:	9a 01 00 00 98 01 00 	lcall  $0x1,$0x98000001
 317:	00 01                	add    %al,(%ecx)
 319:	3b 07                	cmp    (%edi),%eax
 31b:	00 00                	add    %al,(%eax)
 31d:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
 31e:	01 00                	add    %eax,(%eax)
 320:	00 a5 01 00 00 00    	add    %ah,0x1(%ebp)
 326:	08 7c 03 00          	or     %bh,0x0(%ebx,%eax,1)
 32a:	00 2a                	add    %ch,(%edx)
 32c:	8d 00                	lea    (%eax),%eax
 32e:	00 02                	add    %al,(%edx)
 330:	2a 8d 00 00 0d 00    	sub    0xd0000(%ebp),%cl
 336:	00 00                	add    %al,(%eax)
 338:	9b                   	fwait
 339:	3d 03 00 00 1d       	cmp    $0x1d000003,%eax
 33e:	fe 06                	incb   (%esi)
 340:	00 00                	add    %al,(%eax)
 342:	2f                   	das
 343:	8d 00                	lea    (%eax),%eax
 345:	00 01                	add    %al,(%ecx)
 347:	3c 00                	cmp    $0x0,%al
 349:	00 00                	add    %al,(%eax)
 34b:	01 89 0a 01 0f 07    	add    %ecx,0x70f010a(%ecx)
 351:	00 00                	add    %al,(%eax)
 353:	b3 01                	mov    $0x1,%bl
 355:	00 00                	add    %al,(%eax)
 357:	b1 01                	mov    $0x1,%cl
 359:	00 00                	add    %al,(%eax)
 35b:	15 1a 07 00 00       	adc    $0x71a,%eax
 360:	00 00                	add    %al,(%eax)
 362:	14 ce                	adc    $0xce,%al
 364:	06                   	push   %es
 365:	00 00                	add    %al,(%eax)
 367:	37                   	aaa
 368:	8d 00                	lea    (%eax),%eax
 36a:	00 01                	add    %al,(%ecx)
 36c:	37                   	aaa
 36d:	8d 00                	lea    (%eax),%eax
 36f:	00 10                	add    %dl,(%eax)
 371:	00 00                	add    %al,(%eax)
 373:	00 9e 02 01 db 06    	add    %bl,0x6db0102(%esi)
 379:	00 00                	add    %al,(%eax)
 37b:	c0 01 00             	rolb   $0x0,(%ecx)
 37e:	00 be 01 00 00 01    	add    %bh,0x1000001(%esi)
 384:	e6 06                	out    %al,$0x6
 386:	00 00                	add    %al,(%eax)
 388:	cd 01                	int    $0x1
 38a:	00 00                	add    %al,(%eax)
 38c:	cb                   	lret
 38d:	01 00                	add    %eax,(%eax)
 38f:	00 01                	add    %al,(%ecx)
 391:	f1                   	int1
 392:	06                   	push   %es
 393:	00 00                	add    %al,(%eax)
 395:	d8 01                	fadds  (%ecx)
 397:	00 00                	add    %al,(%eax)
 399:	d6                   	salc
 39a:	01 00                	add    %eax,(%eax)
 39c:	00 00                	add    %al,(%eax)
 39e:	00 1e                	add    %bl,(%esi)
 3a0:	04 1f                	add    $0x1f,%al
 3a2:	5f                   	pop    %edi
 3a3:	00 00                	add    %al,(%eax)
 3a5:	00 01                	add    %al,(%ecx)
 3a7:	86 01                	xchg   %al,(%ecx)
 3a9:	01 02                	add    %eax,(%edx)
 3ab:	4e                   	dec    %esi
 3ac:	01 00                	add    %eax,(%eax)
 3ae:	00 7b 9a             	add    %bh,-0x66(%ebx)
 3b1:	8c 00                	mov    %es,(%eax)
 3b3:	00 1d 00 00 00 01    	add    %bl,0x1000000
 3b9:	9c                   	pushf
 3ba:	d1 03                	roll   $1,(%ebx)
 3bc:	00 00                	add    %al,(%eax)
 3be:	03 6e 00             	add    0x0(%esi),%ebp
 3c1:	7b 0b                	jnp    3ce <PR_BOOTABLE+0x34e>
 3c3:	58                   	pop    %eax
 3c4:	00 00                	add    %al,(%eax)
 3c6:	00 02                	add    %al,(%edx)
 3c8:	91                   	xchg   %eax,%ecx
 3c9:	00 06                	add    %al,(%esi)
 3cb:	73 00                	jae    3cd <PR_BOOTABLE+0x34d>
 3cd:	7b 14                	jnp    3e3 <PR_BOOTABLE+0x363>
 3cf:	cf                   	iret
 3d0:	00 00                	add    %al,(%eax)
 3d2:	00 e6                	add    %ah,%dh
 3d4:	01 00                	add    %eax,(%eax)
 3d6:	00 e2                	add    %ah,%dl
 3d8:	01 00                	add    %eax,(%eax)
 3da:	00 0e                	add    %cl,(%esi)
 3dc:	68 65 78 00 7d       	push   $0x7d007865
 3e1:	0e                   	push   %cs
 3e2:	d1 03                	roll   $1,(%ebx)
 3e4:	00 00                	add    %al,(%eax)
 3e6:	05 03 20 90 00       	add    $0x902003,%eax
 3eb:	00 05 b2 8c 00 00    	add    %al,0x8cb2
 3f1:	3d 04 00 00 00       	cmp    $0x4,%eax
 3f6:	0f 9c 00             	setl   (%eax)
 3f9:	00 00                	add    %al,(%eax)
 3fb:	e1 03                	loope  400 <PR_BOOTABLE+0x380>
 3fd:	00 00                	add    %al,(%eax)
 3ff:	10 7f 00             	adc    %bh,0x0(%edi)
 402:	00 00                	add    %al,(%eax)
 404:	10 00                	adc    %al,(%eax)
 406:	02 3b                	add    (%ebx),%bh
 408:	01 00                	add    %eax,(%eax)
 40a:	00 73 7d             	add    %dh,0x7d(%ebx)
 40d:	8c 00                	mov    %es,(%eax)
 40f:	00 1d 00 00 00 01    	add    %bl,0x1000000
 415:	9c                   	pushf
 416:	2d 04 00 00 03       	sub    $0x3000004,%eax
 41b:	6e                   	outsb  %ds:(%esi),(%dx)
 41c:	00 73 0b             	add    %dh,0xb(%ebx)
 41f:	58                   	pop    %eax
 420:	00 00                	add    %al,(%eax)
 422:	00 02                	add    %al,(%edx)
 424:	91                   	xchg   %eax,%ecx
 425:	00 06                	add    %al,(%esi)
 427:	73 00                	jae    429 <PR_BOOTABLE+0x3a9>
 429:	73 13                	jae    43e <PR_BOOTABLE+0x3be>
 42b:	cf                   	iret
 42c:	00 00                	add    %al,(%eax)
 42e:	00 fb                	add    %bh,%bl
 430:	01 00                	add    %eax,(%eax)
 432:	00 f7                	add    %dh,%bh
 434:	01 00                	add    %eax,(%eax)
 436:	00 0e                	add    %cl,(%esi)
 438:	64 65 63 00          	fs arpl %eax,%gs:(%eax)
 43c:	75 0e                	jne    44c <PR_BOOTABLE+0x3cc>
 43e:	2d 04 00 00 05       	sub    $0x5000004,%eax
 443:	03 34 90             	add    (%eax,%edx,4),%esi
 446:	00 00                	add    %al,(%eax)
 448:	05 95 8c 00 00       	add    $0x8c95,%eax
 44d:	3d 04 00 00 00       	cmp    $0x4,%eax
 452:	0f 9c 00             	setl   (%eax)
 455:	00 00                	add    %al,(%eax)
 457:	3d 04 00 00 10       	cmp    $0x10000004,%eax
 45c:	7f 00                	jg     45e <PR_BOOTABLE+0x3de>
 45e:	00 00                	add    %al,(%eax)
 460:	0a 00                	or     (%eax),%al
 462:	02 78 01             	add    0x1(%eax),%bh
 465:	00 00                	add    %al,(%eax)
 467:	61                   	popa
 468:	26 8c 00             	mov    %es,%es:(%eax)
 46b:	00 57 00             	add    %dl,0x0(%edi)
 46e:	00 00                	add    %al,(%eax)
 470:	01 9c b8 04 00 00 06 	add    %ebx,0x6000004(%eax,%edi,4)
 477:	6e                   	outsb  %ds:(%esi),(%dx)
 478:	00 61 0b             	add    %ah,0xb(%ecx)
 47b:	58                   	pop    %eax
 47c:	00 00                	add    %al,(%eax)
 47e:	00 10                	add    %dl,(%eax)
 480:	02 00                	add    (%eax),%al
 482:	00 0c 02             	add    %cl,(%edx,%eax,1)
 485:	00 00                	add    %al,(%eax)
 487:	03 73 00             	add    0x0(%ebx),%esi
 48a:	61                   	popa
 48b:	13 cf                	adc    %edi,%ecx
 48d:	00 00                	add    %al,(%eax)
 48f:	00 02                	add    %al,(%edx)
 491:	91                   	xchg   %eax,%ecx
 492:	04 0b                	add    $0xb,%al
 494:	c2 01 00             	ret    $0x1
 497:	00 61 1c             	add    %ah,0x1c(%ecx)
 49a:	58                   	pop    %eax
 49b:	00 00                	add    %al,(%eax)
 49d:	00 02                	add    %al,(%edx)
 49f:	91                   	xchg   %eax,%ecx
 4a0:	08 0b                	or     %cl,(%ebx)
 4a2:	cb                   	lret
 4a3:	03 00                	add    (%eax),%eax
 4a5:	00 61 29             	add    %ah,0x29(%ecx)
 4a8:	cf                   	iret
 4a9:	00 00                	add    %al,(%eax)
 4ab:	00 02                	add    %al,(%edx)
 4ad:	91                   	xchg   %eax,%ecx
 4ae:	0c 07                	or     $0x7,%al
 4b0:	69 00 63 06 58 00    	imul   $0x580663,(%eax),%eax
 4b6:	00 00                	add    %al,(%eax)
 4b8:	26 02 00             	add    %es:(%eax),%al
 4bb:	00 20                	add    %ah,(%eax)
 4bd:	02 00                	add    (%eax),%al
 4bf:	00 13                	add    %dl,(%ebx)
 4c1:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
 4c2:	01 00                	add    %eax,(%eax)
 4c4:	00 63 09             	add    %ah,0x9(%ebx)
 4c7:	58                   	pop    %eax
 4c8:	00 00                	add    %al,(%eax)
 4ca:	00 3e                	add    %bh,(%esi)
 4cc:	02 00                	add    (%eax),%al
 4ce:	00 3c 02             	add    %bh,(%edx,%eax,1)
 4d1:	00 00                	add    %al,(%eax)
 4d3:	16                   	push   %ss
 4d4:	7d 8c                	jge    462 <PR_BOOTABLE+0x3e2>
 4d6:	00 00                	add    %al,(%eax)
 4d8:	b8 04 00 00 00       	mov    $0x4,%eax
 4dd:	02 ab 01 00 00 52    	add    0x52000001(%ebx),%ch
 4e3:	f1                   	int1
 4e4:	8b 00                	mov    (%eax),%eax
 4e6:	00 35 00 00 00 01    	add    %dh,0x1000000
 4ec:	9c                   	pushf
 4ed:	15 05 00 00 03       	adc    $0x3000005,%eax
 4f2:	73 00                	jae    4f4 <PR_BOOTABLE+0x474>
 4f4:	52                   	push   %edx
 4f5:	0f cf                	bswap  %edi
 4f7:	00 00                	add    %al,(%eax)
 4f9:	00 02                	add    %al,(%edx)
 4fb:	91                   	xchg   %eax,%ecx
 4fc:	00 07                	add    %al,(%edi)
 4fe:	69 00 54 06 58 00    	imul   $0x580654,(%eax),%eax
 504:	00 00                	add    %al,(%eax)
 506:	4e                   	dec    %esi
 507:	02 00                	add    (%eax),%al
 509:	00 46 02             	add    %al,0x2(%esi)
 50c:	00 00                	add    %al,(%eax)
 50e:	07                   	pop    %es
 50f:	6a 00                	push   $0x0
 511:	54                   	push   %esp
 512:	09 58 00             	or     %ebx,0x0(%eax)
 515:	00 00                	add    %al,(%eax)
 517:	74 02                	je     51b <PR_BOOTABLE+0x49b>
 519:	00 00                	add    %al,(%eax)
 51b:	6e                   	outsb  %ds:(%esi),(%dx)
 51c:	02 00                	add    (%eax),%al
 51e:	00 07                	add    %al,(%edi)
 520:	63 00                	arpl   %eax,(%eax)
 522:	55                   	push   %ebp
 523:	07                   	pop    %es
 524:	9c                   	pushf
 525:	00 00                	add    %al,(%eax)
 527:	00 8e 02 00 00 8c    	add    %cl,-0x73fffffe(%esi)
 52d:	02 00                	add    (%eax),%al
 52f:	00 05 02 8c 00 00    	add    %al,0x8c02
 535:	15 05 00 00 00       	adc    $0x5,%eax
 53a:	17                   	pop    %ss
 53b:	95                   	xchg   %eax,%ebp
 53c:	01 00                	add    %eax,(%eax)
 53e:	00 47 58             	add    %al,0x58(%edi)
 541:	00 00                	add    %al,(%eax)
 543:	00 de                	add    %bl,%dh
 545:	8b 00                	mov    (%eax),%eax
 547:	00 13                	add    %dl,(%ebx)
 549:	00 00                	add    %al,(%eax)
 54b:	00 01                	add    %al,(%ecx)
 54d:	9c                   	pushf
 54e:	50                   	push   %eax
 54f:	05 00 00 06 73       	add    $0x73060000,%eax
 554:	00 47 15             	add    %al,0x15(%edi)
 557:	50                   	push   %eax
 558:	05 00 00 9e 02       	add    $0x29e0000,%eax
 55d:	00 00                	add    %al,(%eax)
 55f:	96                   	xchg   %eax,%esi
 560:	02 00                	add    (%eax),%al
 562:	00 07                	add    %al,(%edi)
 564:	6e                   	outsb  %ds:(%esi),(%dx)
 565:	00 49 06             	add    %cl,0x6(%ecx)
 568:	58                   	pop    %eax
 569:	00 00                	add    %al,(%eax)
 56b:	00 d4                	add    %dl,%ah
 56d:	02 00                	add    (%eax),%al
 56f:	00 d0                	add    %dl,%al
 571:	02 00                	add    (%eax),%al
 573:	00 00                	add    %al,(%eax)
 575:	0d a8 00 00 00       	or     $0xa8,%eax
 57a:	02 92 00 00 00 3b    	add    0x3b000000(%edx),%dl
 580:	b7 8c                	mov    $0x8c,%bh
 582:	00 00                	add    %al,(%eax)
 584:	23 00                	and    (%eax),%eax
 586:	00 00                	add    %al,(%eax)
 588:	01 9c 8d 05 00 00 06 	add    %ebx,0x6000005(%ebp,%ecx,4)
 58f:	69 00 3b 0f 4d 00    	imul   $0x4d0f3b,(%eax),%eax
 595:	00 00                	add    %al,(%eax)
 597:	e6 02                	out    %al,$0x2
 599:	00 00                	add    %al,(%eax)
 59b:	e4 02                	in     $0x2,%al
 59d:	00 00                	add    %al,(%eax)
 59f:	05 ca 8c 00 00       	add    $0x8cca,%eax
 5a4:	85 03                	test   %eax,(%ebx)
 5a6:	00 00                	add    %al,(%eax)
 5a8:	16                   	push   %ss
 5a9:	da 8c 00 00 d8 05 00 	fimull 0x5d800(%eax,%eax,1)
 5b0:	00 00                	add    %al,(%eax)
 5b2:	02 8c 00 00 00 2f c4 	add    -0x3bd10000(%eax,%eax,1),%cl
 5b9:	8b 00                	mov    (%eax),%eax
 5bb:	00 1a                	add    %bl,(%edx)
 5bd:	00 00                	add    %al,(%eax)
 5bf:	00 01                	add    %al,(%ecx)
 5c1:	9c                   	pushf
 5c2:	b7 05                	mov    $0x5,%bh
 5c4:	00 00                	add    %al,(%eax)
 5c6:	03 6d 00             	add    0x0(%ebp),%ebp
 5c9:	2f                   	das
 5ca:	0f cf                	bswap  %edi
 5cc:	00 00                	add    %al,(%eax)
 5ce:	00 02                	add    %al,(%edx)
 5d0:	91                   	xchg   %eax,%ecx
 5d1:	00 05 d8 8b 00 00    	add    %al,0x8bd8
 5d7:	0b 06                	or     (%esi),%eax
 5d9:	00 00                	add    %al,(%eax)
 5db:	00 02                	add    %al,(%edx)
 5dd:	80 00 00             	addb   $0x0,(%eax)
 5e0:	00 29                	add    %ch,(%ecx)
 5e2:	b7 8b                	mov    $0x8b,%bh
 5e4:	00 00                	add    %al,(%eax)
 5e6:	0d 00 00 00 01       	or     $0x1000000,%eax
 5eb:	9c                   	pushf
 5ec:	d8 05 00 00 03 72    	fadds  0x72030000
 5f2:	00 29                	add    %ch,(%ecx)
 5f4:	0b 58 00             	or     0x0(%eax),%ebx
 5f7:	00 00                	add    %al,(%eax)
 5f9:	02 91 00 00 02 68    	add    0x68020000(%ecx),%dl
 5ff:	00 00                	add    %al,(%eax)
 601:	00 22                	add    %ah,(%edx)
 603:	74 8b                	je     590 <PR_BOOTABLE+0x510>
 605:	00 00                	add    %al,(%eax)
 607:	43                   	inc    %ebx
 608:	00 00                	add    %al,(%eax)
 60a:	00 01                	add    %al,(%ecx)
 60c:	9c                   	pushf
 60d:	0b 06                	or     (%esi),%eax
 60f:	00 00                	add    %al,(%eax)
 611:	03 73 00             	add    0x0(%ebx),%esi
 614:	22 11                	and    (%ecx),%dl
 616:	cf                   	iret
 617:	00 00                	add    %al,(%eax)
 619:	00 02                	add    %al,(%edx)
 61b:	91                   	xchg   %eax,%ecx
 61c:	00 05 a2 8b 00 00    	add    %al,0x8ba2
 622:	0b 06                	or     (%esi),%eax
 624:	00 00                	add    %al,(%eax)
 626:	05 af 8b 00 00       	add    $0x8baf,%eax
 62b:	0b 06                	or     (%esi),%eax
 62d:	00 00                	add    %al,(%eax)
 62f:	00 17                	add    %dl,(%edi)
 631:	7d 01                	jge    634 <PR_BOOTABLE+0x5b4>
 633:	00 00                	add    %al,(%eax)
 635:	12 58 00             	adc    0x0(%eax),%bl
 638:	00 00                	add    %al,(%eax)
 63a:	41                   	inc    %ecx
 63b:	8b 00                	mov    (%eax),%eax
 63d:	00 33                	add    %dh,(%ebx)
 63f:	00 00                	add    %al,(%eax)
 641:	00 01                	add    %al,(%ecx)
 643:	9c                   	pushf
 644:	81 06 00 00 03 72    	addl   $0x72030000,(%esi)
 64a:	00 12                	add    %dl,(%edx)
 64c:	0b 58 00             	or     0x0(%eax),%ebx
 64f:	00 00                	add    %al,(%eax)
 651:	02 91 00 06 63 00    	add    0x630600(%ecx),%dl
 657:	12 12                	adc    (%edx),%dl
 659:	58                   	pop    %eax
 65a:	00 00                	add    %al,(%eax)
 65c:	00 f3                	add    %dh,%bl
 65e:	02 00                	add    (%eax),%al
 660:	00 ef                	add    %ch,%bh
 662:	02 00                	add    (%eax),%al
 664:	00 0a                	add    %cl,(%edx)
 666:	7a 00                	jp     668 <PR_BOOTABLE+0x5e8>
 668:	00 00                	add    %al,(%eax)
 66a:	12 19                	adc    (%ecx),%bl
 66c:	58                   	pop    %eax
 66d:	00 00                	add    %al,(%eax)
 66f:	00 04 03             	add    %al,(%ebx,%eax,1)
 672:	00 00                	add    %al,(%eax)
 674:	00 03                	add    %al,(%ebx)
 676:	00 00                	add    %al,(%eax)
 678:	0a 85 00 00 00 12    	or     0x12000000(%ebp),%al
 67e:	2c 50                	sub    $0x50,%al
 680:	05 00 00 1f 03       	add    $0x31f0000,%eax
 685:	00 00                	add    %al,(%eax)
 687:	11 03                	adc    %eax,(%ebx)
 689:	00 00                	add    %al,(%eax)
 68b:	07                   	pop    %es
 68c:	6c                   	insb   (%dx),%es:(%edi)
 68d:	00 14 06             	add    %dl,(%esi,%eax,1)
 690:	58                   	pop    %eax
 691:	00 00                	add    %al,(%eax)
 693:	00 97 03 00 00 8f    	add    %dl,-0x70fffffd(%edi)
 699:	03 00                	add    (%eax),%eax
 69b:	00 05 68 8b 00 00    	add    %al,0x8b68
 6a1:	81 06 00 00 00 02    	addl   $0x2000000,(%esi)
 6a7:	53                   	push   %ebx
 6a8:	01 00                	add    %eax,(%eax)
 6aa:	00 09                	add    %cl,(%ecx)
 6ac:	26 8b 00             	mov    %es:(%eax),%eax
 6af:	00 1b                	add    %bl,(%ebx)
 6b1:	00 00                	add    %al,(%eax)
 6b3:	00 01                	add    %al,(%ecx)
 6b5:	9c                   	pushf
 6b6:	ce                   	into
 6b7:	06                   	push   %es
 6b8:	00 00                	add    %al,(%eax)
 6ba:	03 6c 00 09          	add    0x9(%eax,%eax,1),%ebp
 6be:	0b 58 00             	or     0x0(%eax),%ebx
 6c1:	00 00                	add    %al,(%eax)
 6c3:	02 91 00 0b 7a 00    	add    0x7a0b00(%ecx),%dl
 6c9:	00 00                	add    %al,(%eax)
 6cb:	09 12                	or     %edx,(%edx)
 6cd:	58                   	pop    %eax
 6ce:	00 00                	add    %al,(%eax)
 6d0:	00 02                	add    %al,(%edx)
 6d2:	91                   	xchg   %eax,%ecx
 6d3:	04 03                	add    $0x3,%al
 6d5:	63 68 00             	arpl   %ebp,0x0(%eax)
 6d8:	09 1e                	or     %ebx,(%esi)
 6da:	9c                   	pushf
 6db:	00 00                	add    %al,(%eax)
 6dd:	00 02                	add    %al,(%edx)
 6df:	91                   	xchg   %eax,%ecx
 6e0:	08 07                	or     %al,(%edi)
 6e2:	70 00                	jo     6e4 <PR_BOOTABLE+0x664>
 6e4:	0b 12                	or     (%edx),%edx
 6e6:	97                   	xchg   %eax,%edi
 6e7:	00 00                	add    %al,(%eax)
 6e9:	00 b0 03 00 00 ae    	add    %dh,-0x51fffffd(%eax)
 6ef:	03 00                	add    (%eax),%eax
 6f1:	00 00                	add    %al,(%eax)
 6f3:	20 af 00 00 00 02    	and    %ch,0x2000000(%edi)
 6f9:	2d 01 03 fe 06       	sub    $0x6fe0301,%eax
 6fe:	00 00                	add    %al,(%eax)
 700:	09 a1 01 00 00 2d    	or     %esp,0x2d000001(%ecx)
 706:	0a 58 00             	or     0x0(%eax),%bl
 709:	00 00                	add    %al,(%eax)
 70b:	09 e7                	or     %esp,%edi
 70d:	03 00                	add    (%eax),%eax
 70f:	00 2d 16 7a 03 00    	add    %ch,0x37a16
 715:	00 21                	add    %ah,(%ecx)
 717:	63 6e 74             	arpl   %ebp,0x74(%esi)
 71a:	00 02                	add    %al,(%edx)
 71c:	2d 20 58 00 00       	sub    $0x5820,%eax
 721:	00 00                	add    %al,(%eax)
 723:	22 69 6e             	and    0x6e(%ecx),%ch
 726:	62 00                	bound  %eax,(%eax)
 728:	02 25 01 2d 00 00    	add    0x2d01,%ah
 72e:	00 03                	add    %al,(%ebx)
 730:	27                   	daa
 731:	07                   	pop    %es
 732:	00 00                	add    %al,(%eax)
 734:	09 a1 01 00 00 25    	or     %esp,0x25000001(%ecx)
 73a:	09 58 00             	or     %ebx,0x0(%eax)
 73d:	00 00                	add    %al,(%eax)
 73f:	23 9c 01 00 00 02 27 	and    0x27020000(%ecx,%eax,1),%ebx
 746:	0a 2d 00 00 00 00    	or     0x0,%ch
 74c:	24 aa                	and    $0xaa,%al
 74e:	00 00                	add    %al,(%eax)
 750:	00 02                	add    %al,(%edx)
 752:	19 01                	sbb    %eax,(%ecx)
 754:	03 09                	add    (%ecx),%ecx
 756:	a1 01 00 00 19       	mov    0x19000001,%eax
 75b:	0a 58 00             	or     0x0(%eax),%bl
 75e:	00 00                	add    %al,(%eax)
 760:	09 9c 01 00 00 19 18 	or     %ebx,0x18190000(%ecx,%eax,1)
 767:	2d 00 00 00 00       	sub    $0x0,%eax
 76c:	00 4e 07             	add    %cl,0x7(%esi)
 76f:	00 00                	add    %al,(%eax)
 771:	05 00 01 04 67       	add    $0x67040100,%eax
 776:	02 00                	add    (%eax),%al
 778:	00 13                	add    %dl,(%ebx)
 77a:	c2 00 00             	ret    $0x0
 77d:	00 01                	add    %al,(%ecx)
 77f:	6b 00 00             	imul   $0x0,(%eax),%eax
 782:	00 00                	add    %al,(%eax)
 784:	00 00                	add    %al,(%eax)
 786:	00 91 8d 00 00 8b    	add    %dl,-0x74ffff73(%ecx)
 78c:	01 00                	add    %eax,(%eax)
 78e:	00 77 04             	add    %dh,0x4(%edi)
 791:	00 00                	add    %al,(%eax)
 793:	05 01 06 42 01       	add    $0x1420601,%eax
 798:	00 00                	add    %al,(%eax)
 79a:	03 a2 00 00 00 0d    	add    0xd000000(%edx),%esp
 7a0:	17                   	pop    %ss
 7a1:	38 00                	cmp    %al,(%eax)
 7a3:	00 00                	add    %al,(%eax)
 7a5:	05 01 08 40 01       	add    $0x1400801,%eax
 7aa:	00 00                	add    %al,(%eax)
 7ac:	05 02 05 70 00       	add    $0x700502,%eax
 7b1:	00 00                	add    %al,(%eax)
 7b3:	03 59 03             	add    0x3(%ecx),%ebx
 7b6:	00 00                	add    %al,(%eax)
 7b8:	0f 18 51 00          	prefetcht1 0x0(%ecx)
 7bc:	00 00                	add    %al,(%eax)
 7be:	05 02 07 82 01       	add    $0x1820702,%eax
 7c3:	00 00                	add    %al,(%eax)
 7c5:	03 70 01             	add    0x1(%eax),%esi
 7c8:	00 00                	add    %al,(%eax)
 7ca:	10 0d 63 00 00 00    	adc    %cl,0x63
 7d0:	14 04                	adc    $0x4,%al
 7d2:	05 69 6e 74 00       	add    $0x746e69,%eax
 7d7:	03 6f 01             	add    0x1(%edi),%ebp
 7da:	00 00                	add    %al,(%eax)
 7dc:	11 16                	adc    %edx,(%esi)
 7de:	75 00                	jne    7e0 <PR_BOOTABLE+0x760>
 7e0:	00 00                	add    %al,(%eax)
 7e2:	05 04 07 62 01       	add    $0x1620704,%eax
 7e7:	00 00                	add    %al,(%eax)
 7e9:	05 08 05 b4 00       	add    $0xb40508,%eax
 7ee:	00 00                	add    %al,(%eax)
 7f0:	03 13                	add    (%ebx),%edx
 7f2:	02 00                	add    (%eax),%al
 7f4:	00 13                	add    %dl,(%ebx)
 7f6:	1c 8e                	sbb    $0x8e,%al
 7f8:	00 00                	add    %al,(%eax)
 7fa:	00 05 08 07 58 01    	add    %al,0x1580708
 800:	00 00                	add    %al,(%eax)
 802:	0a 10                	or     (%eax),%dl
 804:	65 02 e5             	gs add %ch,%ah
 807:	00 00                	add    %al,(%eax)
 809:	00 01                	add    %al,(%ecx)
 80b:	4b                   	dec    %ebx
 80c:	03 00                	add    (%eax),%eax
 80e:	00 67 0b             	add    %ah,0xb(%edi)
 811:	2d 00 00 00 00       	sub    $0x0,%eax
 816:	01 2d 03 00 00 6a    	add    %ebp,0x6a000003
 81c:	0b e5                	or     %ebp,%esp
 81e:	00 00                	add    %al,(%eax)
 820:	00 01                	add    %al,(%ecx)
 822:	0f 69 64 00 6b       	punpckhwd 0x6b(%eax,%eax,1),%mm4
 827:	0b 2d 00 00 00 04    	or     0x4000000,%ebp
 82d:	01 d9                	add    %ebx,%ecx
 82f:	03 00                	add    (%eax),%eax
 831:	00 6f 0b             	add    %ch,0xb(%edi)
 834:	e5 00                	in     $0x0,%eax
 836:	00 00                	add    %al,(%eax)
 838:	05 01 1d 04 00       	add    $0x41d01,%eax
 83d:	00 70 0c             	add    %dh,0xc(%eax)
 840:	6a 00                	push   $0x0
 842:	00 00                	add    %al,(%eax)
 844:	08 01                	or     %al,(%ecx)
 846:	c2 04 00             	ret    $0x4
 849:	00 71 0c             	add    %dh,0xc(%ecx)
 84c:	6a 00                	push   $0x0
 84e:	00 00                	add    %al,(%eax)
 850:	0c 00                	or     $0x0,%al
 852:	06                   	push   %es
 853:	2d 00 00 00 f5       	sub    $0xf5000000,%eax
 858:	00 00                	add    %al,(%eax)
 85a:	00 08                	add    %cl,(%eax)
 85c:	f5                   	cmc
 85d:	00 00                	add    %al,(%eax)
 85f:	00 02                	add    %al,(%edx)
 861:	00 05 04 07 5d 01    	add    %al,0x15d0704
 867:	00 00                	add    %al,(%eax)
 869:	15 6d 62 72 00       	adc    $0x72626d,%eax
 86e:	00 02                	add    %al,(%edx)
 870:	02 61 10             	add    0x10(%ecx),%ah
 873:	3e 01 00             	add    %eax,%ds:(%eax)
 876:	00 01                	add    %al,(%ecx)
 878:	39 02                	cmp    %eax,(%edx)
 87a:	00 00                	add    %al,(%eax)
 87c:	63 0a                	arpl   %ecx,(%edx)
 87e:	3e 01 00             	add    %eax,%ds:(%eax)
 881:	00 00                	add    %al,(%eax)
 883:	0d cd 01 00 00       	or     $0x1cd,%eax
 888:	64 0a 4f 01          	or     %fs:0x1(%edi),%cl
 88c:	00 00                	add    %al,(%eax)
 88e:	b4 01                	mov    $0x1,%ah
 890:	0d d6 02 00 00       	or     $0x2d6,%eax
 895:	72 0e                	jb     8a5 <PR_BOOTABLE+0x825>
 897:	5f                   	pop    %edi
 898:	01 00                	add    %eax,(%eax)
 89a:	00 be 01 0d 46 04    	add    %bh,0x4460d01(%esi)
 8a0:	00 00                	add    %al,(%eax)
 8a2:	73 0a                	jae    8ae <PR_BOOTABLE+0x82e>
 8a4:	6f                   	outsl  %ds:(%esi),(%dx)
 8a5:	01 00                	add    %eax,(%eax)
 8a7:	00 fe                	add    %bh,%dh
 8a9:	01 00                	add    %eax,(%eax)
 8ab:	06                   	push   %es
 8ac:	2d 00 00 00 4f       	sub    $0x4f000000,%eax
 8b1:	01 00                	add    %eax,(%eax)
 8b3:	00 16                	add    %dl,(%esi)
 8b5:	f5                   	cmc
 8b6:	00 00                	add    %al,(%eax)
 8b8:	00 b3 01 00 06 2d    	add    %dh,0x2d060001(%ebx)
 8be:	00 00                	add    %al,(%eax)
 8c0:	00 5f 01             	add    %bl,0x1(%edi)
 8c3:	00 00                	add    %al,(%eax)
 8c5:	08 f5                	or     %dh,%ch
 8c7:	00 00                	add    %al,(%eax)
 8c9:	00 09                	add    %cl,(%ecx)
 8cb:	00 06                	add    %al,(%esi)
 8cd:	95                   	xchg   %eax,%ebp
 8ce:	00 00                	add    %al,(%eax)
 8d0:	00 6f 01             	add    %ch,0x1(%edi)
 8d3:	00 00                	add    %al,(%eax)
 8d5:	08 f5                	or     %dh,%ch
 8d7:	00 00                	add    %al,(%eax)
 8d9:	00 03                	add    %al,(%ebx)
 8db:	00 06                	add    %al,(%esi)
 8dd:	2d 00 00 00 7f       	sub    $0x7f000000,%eax
 8e2:	01 00                	add    %eax,(%eax)
 8e4:	00 08                	add    %cl,(%eax)
 8e6:	f5                   	cmc
 8e7:	00 00                	add    %al,(%eax)
 8e9:	00 01                	add    %al,(%ecx)
 8eb:	00 03                	add    %al,(%ebx)
 8ed:	b4 02                	mov    $0x2,%ah
 8ef:	00 00                	add    %al,(%eax)
 8f1:	74 0d                	je     900 <PR_BOOTABLE+0x880>
 8f3:	fc                   	cld
 8f4:	00 00                	add    %al,(%eax)
 8f6:	00 0b                	add    %cl,(%ebx)
 8f8:	37                   	aaa
 8f9:	03 00                	add    (%eax),%eax
 8fb:	00 18                	add    %bl,(%eax)
 8fd:	7e 08                	jle    907 <PR_BOOTABLE+0x887>
 8ff:	c7 01 00 00 01 18    	movl   $0x18010000,(%ecx)
 905:	04 00                	add    $0x0,%al
 907:	00 7f 0b             	add    %bh,0xb(%edi)
 90a:	6a 00                	push   $0x0
 90c:	00 00                	add    %al,(%eax)
 90e:	00 01                	add    %al,(%ecx)
 910:	e2 03                	loop   915 <PR_BOOTABLE+0x895>
 912:	00 00                	add    %al,(%eax)
 914:	80 0b 83             	orb    $0x83,(%ebx)
 917:	00 00                	add    %al,(%eax)
 919:	00 04 01             	add    %al,(%ecx,%eax,1)
 91c:	67 03 00             	add    (%bx,%si),%eax
 91f:	00 81 0b 83 00 00    	add    %al,0x830b(%ecx)
 925:	00 0c 01             	add    %cl,(%ecx,%eax,1)
 928:	bc 02 00 00 82       	mov    $0x82000002,%esp
 92d:	0b 6a 00             	or     0x0(%edx),%ebp
 930:	00 00                	add    %al,(%eax)
 932:	14 00                	adc    $0x0,%al
 934:	03 e0                	add    %eax,%esp
 936:	02 00                	add    (%eax),%al
 938:	00 83 0e 8a 01 00    	add    %al,0x18a0e(%ebx)
 93e:	00 0b                	add    %cl,(%ebx)
 940:	d6                   	salc
 941:	01 00                	add    %eax,(%eax)
 943:	00 34 8b             	add    %dh,(%ebx,%ecx,4)
 946:	10 93 02 00 00 01    	adc    %dl,0x1000002(%ebx)
 94c:	d1 03                	roll   $1,(%ebx)
 94e:	00 00                	add    %al,(%eax)
 950:	8c 0b                	mov    %cs,(%ebx)
 952:	6a 00                	push   $0x0
 954:	00 00                	add    %al,(%eax)
 956:	00 01                	add    %al,(%ecx)
 958:	a2 03 00 00 8d       	mov    %al,0x8d000003
 95d:	0a 93 02 00 00 04    	or     0x4000002(%ebx),%dl
 963:	01 ba 02 00 00 8e    	add    %edi,-0x71fffffe(%edx)
 969:	0b 46 00             	or     0x0(%esi),%eax
 96c:	00 00                	add    %al,(%eax)
 96e:	10 01                	adc    %al,(%ecx)
 970:	54                   	push   %esp
 971:	02 00                	add    (%eax),%al
 973:	00 8f 0b 46 00 00    	add    %cl,0x460b(%edi)
 979:	00 12                	add    %dl,(%edx)
 97b:	01 10                	add    %edx,(%eax)
 97d:	03 00                	add    (%eax),%eax
 97f:	00 90 0b 6a 00 00    	add    %dl,0x6a0b(%eax)
 985:	00 14 01             	add    %dl,(%ecx,%eax,1)
 988:	0b 02                	or     (%edx),%eax
 98a:	00 00                	add    %al,(%eax)
 98c:	91                   	xchg   %eax,%ecx
 98d:	0b 6a 00             	or     0x0(%edx),%ebp
 990:	00 00                	add    %al,(%eax)
 992:	18 01                	sbb    %al,(%ecx)
 994:	bc 03 00 00 92       	mov    $0x92000003,%esp
 999:	0b 6a 00             	or     0x0(%edx),%ebp
 99c:	00 00                	add    %al,(%eax)
 99e:	1c 01                	sbb    $0x1,%al
 9a0:	f5                   	cmc
 9a1:	03 00                	add    (%eax),%eax
 9a3:	00 93 0b 6a 00 00    	add    %dl,0x6a0b(%ebx)
 9a9:	00 20                	add    %ah,(%eax)
 9ab:	01 44 02 00          	add    %eax,0x0(%edx,%eax,1)
 9af:	00 94 0b 6a 00 00 00 	add    %dl,0x6a(%ebx,%ecx,1)
 9b6:	24 01                	and    $0x1,%al
 9b8:	cd 02                	int    $0x2
 9ba:	00 00                	add    %al,(%eax)
 9bc:	95                   	xchg   %eax,%ebp
 9bd:	0b 46 00             	or     0x0(%esi),%eax
 9c0:	00 00                	add    %al,(%eax)
 9c2:	28 01                	sub    %al,(%ecx)
 9c4:	5e                   	pop    %esi
 9c5:	02 00                	add    (%eax),%al
 9c7:	00 96 0b 46 00 00    	add    %dl,0x460b(%esi)
 9cd:	00 2a                	add    %ch,(%edx)
 9cf:	01 3e                	add    %edi,(%esi)
 9d1:	04 00                	add    $0x0,%al
 9d3:	00 97 0b 46 00 00    	add    %dl,0x460b(%edi)
 9d9:	00 2c 01             	add    %ch,(%ecx,%eax,1)
 9dc:	a2 02 00 00 98       	mov    %al,0x98000002
 9e1:	0b 46 00             	or     0x0(%esi),%eax
 9e4:	00 00                	add    %al,(%eax)
 9e6:	2e 01 62 04          	add    %esp,%cs:0x4(%edx)
 9ea:	00 00                	add    %al,(%eax)
 9ec:	99                   	cltd
 9ed:	0b 46 00             	or     0x0(%esi),%eax
 9f0:	00 00                	add    %al,(%eax)
 9f2:	30 01                	xor    %al,(%ecx)
 9f4:	dd 01                	fldl   (%ecx)
 9f6:	00 00                	add    %al,(%eax)
 9f8:	9a 0b 46 00 00 00 32 	lcall  $0x3200,$0x460b
 9ff:	00 06                	add    %al,(%esi)
 a01:	2d 00 00 00 a3       	sub    $0xa3000000,%eax
 a06:	02 00                	add    (%eax),%al
 a08:	00 08                	add    %cl,(%eax)
 a0a:	f5                   	cmc
 a0b:	00 00                	add    %al,(%eax)
 a0d:	00 0b                	add    %cl,(%ebx)
 a0f:	00 03                	add    %al,(%ebx)
 a11:	f2 01 00             	repnz add %eax,(%eax)
 a14:	00 9b 03 d2 01 00    	add    %bl,0x1d203(%ebx)
 a1a:	00 0b                	add    %cl,(%ebx)
 a1c:	9a 02 00 00 20 9e 10 	lcall  $0x109e,$0x20000002
 a23:	1b 03                	sbb    (%ebx),%eax
 a25:	00 00                	add    %al,(%eax)
 a27:	01 93 02 00 00 9f    	add    %edx,-0x60fffffe(%ebx)
 a2d:	0b 6a 00             	or     0x0(%edx),%ebp
 a30:	00 00                	add    %al,(%eax)
 a32:	00 01                	add    %al,(%ecx)
 a34:	30 02                	xor    %al,(%edx)
 a36:	00 00                	add    %al,(%eax)
 a38:	a0 0b 6a 00 00       	mov    0x6a0b,%al
 a3d:	00 04 01             	add    %al,(%ecx,%eax,1)
 a40:	79 03                	jns    a45 <PR_BOOTABLE+0x9c5>
 a42:	00 00                	add    %al,(%eax)
 a44:	a1 0b 6a 00 00       	mov    0x6a0b,%eax
 a49:	00 08                	add    %cl,(%eax)
 a4b:	01 bd 04 00 00 a2    	add    %edi,-0x5dfffffc(%ebp)
 a51:	0b 6a 00             	or     0x0(%edx),%ebp
 a54:	00 00                	add    %al,(%eax)
 a56:	0c 01                	or     $0x1,%al
 a58:	35 04 00 00 a3       	xor    $0xa3000004,%eax
 a5d:	0b 6a 00             	or     0x0(%edx),%ebp
 a60:	00 00                	add    %al,(%eax)
 a62:	10 01                	adc    %al,(%ecx)
 a64:	28 02                	sub    %al,(%edx)
 a66:	00 00                	add    %al,(%eax)
 a68:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 a69:	0b 6a 00             	or     0x0(%edx),%ebp
 a6c:	00 00                	add    %al,(%eax)
 a6e:	14 01                	adc    $0x1,%al
 a70:	8f 03                	pop    (%ebx)
 a72:	00 00                	add    %al,(%eax)
 a74:	a5                   	movsl  %ds:(%esi),%es:(%edi)
 a75:	0b 6a 00             	or     0x0(%edx),%ebp
 a78:	00 00                	add    %al,(%eax)
 a7a:	18 01                	sbb    %al,(%ecx)
 a7c:	ab                   	stos   %eax,%es:(%edi)
 a7d:	04 00                	add    $0x0,%al
 a7f:	00 a6 0b 6a 00 00    	add    %ah,0x6a0b(%esi)
 a85:	00 1c 00             	add    %bl,(%eax,%eax,1)
 a88:	03 9a 02 00 00 a7    	add    -0x58fffffe(%edx),%ebx
 a8e:	03 ae 02 00 00 0a    	add    0xa000002(%esi),%ebp
 a94:	04 b6                	add    $0xb6,%al
 a96:	02 5f 03             	add    0x3(%edi),%bl
 a99:	00 00                	add    %al,(%eax)
 a9b:	01 26                	add    %esp,(%esi)
 a9d:	03 00                	add    (%eax),%eax
 a9f:	00 b7 0b 2d 00 00    	add    %dh,0x2d0b(%edi)
 aa5:	00 00                	add    %al,(%eax)
 aa7:	01 1a                	add    %ebx,(%edx)
 aa9:	03 00                	add    (%eax),%eax
 aab:	00 b8 0b 2d 00 00    	add    %bh,0x2d0b(%eax)
 ab1:	00 01                	add    %al,(%ecx)
 ab3:	01 20                	add    %esp,(%eax)
 ab5:	03 00                	add    (%eax),%eax
 ab7:	00 b9 0b 2d 00 00    	add    %bh,0x2d0b(%ecx)
 abd:	00 02                	add    %al,(%edx)
 abf:	01 8d 02 00 00 ba    	add    %ecx,-0x45fffffe(%ebp)
 ac5:	0b 2d 00 00 00 03    	or     0x3000000,%ebp
 acb:	00 0a                	add    %cl,(%edx)
 acd:	10 c7                	adc    %al,%bh
 acf:	03 98 03 00 00 01    	add    0x1000003(%eax),%ebx
 ad5:	15 04 00 00 c8       	adc    $0xc8000004,%eax
 ada:	0d 6a 00 00 00       	or     $0x6a,%eax
 adf:	00 01                	add    %al,(%ecx)
 ae1:	85 02                	test   %eax,(%edx)
 ae3:	00 00                	add    %al,(%eax)
 ae5:	c9                   	leave
 ae6:	0d 6a 00 00 00       	or     $0x6a,%eax
 aeb:	04 01                	add    $0x1,%al
 aed:	e7 03                	out    %eax,$0x3
 aef:	00 00                	add    %al,(%eax)
 af1:	ca 0d 6a             	lret   $0x6a0d
 af4:	00 00                	add    %al,(%eax)
 af6:	00 08                	add    %cl,(%eax)
 af8:	01 75 04             	add    %esi,0x4(%ebp)
 afb:	00 00                	add    %al,(%eax)
 afd:	cb                   	lret
 afe:	0d 6a 00 00 00       	or     $0x6a,%eax
 b03:	0c 00                	or     $0x0,%al
 b05:	0a 10                	or     (%eax),%dl
 b07:	cd 03                	int    $0x3
 b09:	d1 03                	roll   $1,(%ebx)
 b0b:	00 00                	add    %al,(%eax)
 b0d:	0f 6e 75 6d          	movd   0x6d(%ebp),%mm6
 b11:	00 ce                	add    %cl,%dh
 b13:	0d 6a 00 00 00       	or     $0x6a,%eax
 b18:	00 01                	add    %al,(%ecx)
 b1a:	18 04 00             	sbb    %al,(%eax,%eax,1)
 b1d:	00 cf                	add    %cl,%bh
 b1f:	0d 6a 00 00 00       	or     $0x6a,%eax
 b24:	04 01                	add    $0x1,%al
 b26:	e7 03                	out    %eax,$0x3
 b28:	00 00                	add    %al,(%eax)
 b2a:	d0 0d 6a 00 00 00    	rorb   $1,0x6a
 b30:	08 01                	or     %al,(%ecx)
 b32:	ae                   	scas   %es:(%edi),%al
 b33:	02 00                	add    (%eax),%al
 b35:	00 d1                	add    %dl,%cl
 b37:	0d 6a 00 00 00       	or     $0x6a,%eax
 b3c:	0c 00                	or     $0x0,%al
 b3e:	17                   	pop    %ss
 b3f:	10 02                	adc    %al,(%edx)
 b41:	c6 02 f3             	movb   $0xf3,(%edx)
 b44:	03 00                	add    (%eax),%eax
 b46:	00 18                	add    %bl,(%eax)
 b48:	80 02 00             	addb   $0x0,(%edx)
 b4b:	00 02                	add    %al,(%edx)
 b4d:	cc                   	int3
 b4e:	05 5f 03 00 00       	add    $0x35f,%eax
 b53:	19 65 6c             	sbb    %esp,0x6c(%ebp)
 b56:	66 00 02             	data16 add %al,(%edx)
 b59:	d2 05 98 03 00 00    	rolb   %cl,0x398
 b5f:	00 0b                	add    %cl,(%ebx)
 b61:	6e                   	outsb  %ds:(%esi),(%dx)
 b62:	03 00                	add    (%eax),%eax
 b64:	00 60 ae             	add    %ah,-0x52(%eax)
 b67:	08 fc                	or     %bh,%ah
 b69:	04 00                	add    $0x0,%al
 b6b:	00 01                	add    %al,(%ecx)
 b6d:	46                   	inc    %esi
 b6e:	02 00                	add    (%eax),%al
 b70:	00 af 0b 6a 00 00    	add    %ch,0x6a0b(%edi)
 b76:	00 00                	add    %al,(%eax)
 b78:	01 41 03             	add    %eax,0x3(%ecx)
 b7b:	00 00                	add    %al,(%eax)
 b7d:	b2 0b                	mov    $0xb,%dl
 b7f:	6a 00                	push   $0x0
 b81:	00 00                	add    %al,(%eax)
 b83:	04 01                	add    $0x1,%al
 b85:	fd                   	std
 b86:	03 00                	add    (%eax),%eax
 b88:	00 b3 0b 6a 00 00    	add    %dh,0x6a0b(%ebx)
 b8e:	00 08                	add    %cl,(%eax)
 b90:	01 a8 03 00 00 bb    	add    %ebp,-0x44fffffd(%eax)
 b96:	04 26                	add    $0x26,%al
 b98:	03 00                	add    (%eax),%eax
 b9a:	00 0c 01             	add    %cl,(%ecx,%eax,1)
 b9d:	4c                   	dec    %esp
 b9e:	02 00                	add    (%eax),%al
 ba0:	00 be 0b 6a 00 00    	add    %bh,0x6a0b(%esi)
 ba6:	00 10                	add    %dl,(%eax)
 ba8:	01 6a 04             	add    %ebp,0x4(%edx)
 bab:	00 00                	add    %al,(%eax)
 bad:	c2 0b 6a             	ret    $0x6a0b
 bb0:	00 00                	add    %al,(%eax)
 bb2:	00 14 01             	add    %dl,(%ecx,%eax,1)
 bb5:	76 02                	jbe    bb9 <PR_BOOTABLE+0xb39>
 bb7:	00 00                	add    %al,(%eax)
 bb9:	c3                   	ret
 bba:	0b 6a 00             	or     0x0(%edx),%ebp
 bbd:	00 00                	add    %al,(%eax)
 bbf:	18 01                	sbb    %al,(%ecx)
 bc1:	54                   	push   %esp
 bc2:	03 00                	add    (%eax),%eax
 bc4:	00 d3                	add    %dl,%bl
 bc6:	04 d1                	add    $0xd1,%al
 bc8:	03 00                	add    (%eax),%eax
 bca:	00 1c 01             	add    %bl,(%ecx,%eax,1)
 bcd:	62 03                	bound  %eax,(%ebx)
 bcf:	00 00                	add    %al,(%eax)
 bd1:	d6                   	salc
 bd2:	0b 6a 00             	or     0x0(%edx),%ebp
 bd5:	00 00                	add    %al,(%eax)
 bd7:	2c 01                	sub    $0x1,%al
 bd9:	e8 01 00 00 d8       	call   d8000bdf <SMAP_SIG+0x84b2ca8f>
 bde:	0b 6a 00             	or     0x0(%edx),%ebp
 be1:	00 00                	add    %al,(%eax)
 be3:	30 01                	xor    %al,(%ecx)
 be5:	27                   	daa
 be6:	04 00                	add    $0x0,%al
 be8:	00 dc                	add    %bl,%ah
 bea:	0b 6a 00             	or     0x0(%edx),%ebp
 bed:	00 00                	add    %al,(%eax)
 bef:	34 01                	xor    $0x1,%al
 bf1:	c1 02 00             	roll   $0x0,(%edx)
 bf4:	00 dd                	add    %bl,%ch
 bf6:	0b 6a 00             	or     0x0(%edx),%ebp
 bf9:	00 00                	add    %al,(%eax)
 bfb:	38 01                	cmp    %al,(%ecx)
 bfd:	c4 03                	les    (%ebx),%eax
 bff:	00 00                	add    %al,(%eax)
 c01:	e0 0b                	loopne c0e <PR_BOOTABLE+0xb8e>
 c03:	6a 00                	push   $0x0
 c05:	00 00                	add    %al,(%eax)
 c07:	3c 01                	cmp    $0x1,%al
 c09:	7f 04                	jg     c0f <PR_BOOTABLE+0xb8f>
 c0b:	00 00                	add    %al,(%eax)
 c0d:	e3 0b                	jecxz  c1a <PR_BOOTABLE+0xb9a>
 c0f:	6a 00                	push   $0x0
 c11:	00 00                	add    %al,(%eax)
 c13:	40                   	inc    %eax
 c14:	01 b3 04 00 00 e6    	add    %esi,-0x19fffffc(%ebx)
 c1a:	0b 6a 00             	or     0x0(%edx),%ebp
 c1d:	00 00                	add    %al,(%eax)
 c1f:	44                   	inc    %esp
 c20:	01 7e 03             	add    %edi,0x3(%esi)
 c23:	00 00                	add    %al,(%eax)
 c25:	e9 0b 6a 00 00       	jmp    7635 <PR_BOOTABLE+0x75b5>
 c2a:	00 48 01             	add    %cl,0x1(%eax)
 c2d:	07                   	pop    %es
 c2e:	04 00                	add    $0x0,%al
 c30:	00 ea                	add    %ch,%dl
 c32:	0b 6a 00             	or     0x0(%edx),%ebp
 c35:	00 00                	add    %al,(%eax)
 c37:	4c                   	dec    %esp
 c38:	01 ec                	add    %ebp,%esp
 c3a:	03 00                	add    (%eax),%eax
 c3c:	00 eb                	add    %ch,%bl
 c3e:	0b 6a 00             	or     0x0(%edx),%ebp
 c41:	00 00                	add    %al,(%eax)
 c43:	50                   	push   %eax
 c44:	01 90 04 00 00 ec    	add    %edx,-0x13fffffc(%eax)
 c4a:	0b 6a 00             	or     0x0(%edx),%ebp
 c4d:	00 00                	add    %al,(%eax)
 c4f:	54                   	push   %esp
 c50:	01 f9                	add    %edi,%ecx
 c52:	01 00                	add    %eax,(%eax)
 c54:	00 ed                	add    %ch,%ch
 c56:	0b 6a 00             	or     0x0(%edx),%ebp
 c59:	00 00                	add    %al,(%eax)
 c5b:	58                   	pop    %eax
 c5c:	01 50 04             	add    %edx,0x4(%eax)
 c5f:	00 00                	add    %al,(%eax)
 c61:	ee                   	out    %al,(%dx)
 c62:	0b 6a 00             	or     0x0(%edx),%ebp
 c65:	00 00                	add    %al,(%eax)
 c67:	5c                   	pop    %esp
 c68:	00 03                	add    %al,(%ebx)
 c6a:	ec                   	in     (%dx),%al
 c6b:	02 00                	add    (%eax),%al
 c6d:	00 ef                	add    %ch,%bh
 c6f:	03 f3                	add    %ebx,%esi
 c71:	03 00                	add    (%eax),%eax
 c73:	00 1a                	add    %bl,(%edx)
 c75:	6e                   	outsb  %ds:(%esi),(%dx)
 c76:	03 00                	add    (%eax),%eax
 c78:	00 01                	add    %al,(%ecx)
 c7a:	08 0e                	or     %cl,(%esi)
 c7c:	fc                   	cld
 c7d:	04 00                	add    $0x0,%al
 c7f:	00 05 03 60 90 00    	add    %al,0x906003
 c85:	00 07                	add    %al,(%edi)
 c87:	92                   	xchg   %eax,%edx
 c88:	00 00                	add    %al,(%eax)
 c8a:	00 02                	add    %al,(%edx)
 c8c:	50                   	push   %eax
 c8d:	06                   	push   %es
 c8e:	2b 05 00 00 04 58    	sub    0x58040000,%eax
 c94:	00 00                	add    %al,(%eax)
 c96:	00 00                	add    %al,(%eax)
 c98:	07                   	pop    %es
 c99:	2f                   	das
 c9a:	01 00                	add    %eax,(%eax)
 c9c:	00 02                	add    %al,(%edx)
 c9e:	78 06                	js     ca6 <PR_BOOTABLE+0xc26>
 ca0:	4c                   	dec    %esp
 ca1:	05 00 00 04 6a       	add    $0x6a040000,%eax
 ca6:	00 00                	add    %al,(%eax)
 ca8:	00 04 6a             	add    %al,(%edx,%ebp,2)
 cab:	00 00                	add    %al,(%eax)
 cad:	00 04 6a             	add    %al,(%edx,%ebp,2)
 cb0:	00 00                	add    %al,(%eax)
 cb2:	00 04 6a             	add    %al,(%edx,%ebp,2)
 cb5:	00 00                	add    %al,(%eax)
 cb7:	00 00                	add    %al,(%eax)
 cb9:	07                   	pop    %es
 cba:	6a 02                	push   $0x2
 cbc:	00 00                	add    %al,(%eax)
 cbe:	01 06                	add    %eax,(%esi)
 cc0:	0d 63 05 00 00       	or     $0x563,%eax
 cc5:	04 6a                	add    $0x6a,%al
 cc7:	00 00                	add    %al,(%eax)
 cc9:	00 04 63             	add    %al,(%ebx,%eiz,2)
 ccc:	05 00 00 00 09       	add    $0x9000000,%eax
 cd1:	fc                   	cld
 cd2:	04 00                	add    $0x0,%al
 cd4:	00 07                	add    %al,(%edi)
 cd6:	8c 00                	mov    %es,(%eax)
 cd8:	00 00                	add    %al,(%eax)
 cda:	02 52 06             	add    0x6(%edx),%dl
 cdd:	7a 05                	jp     ce4 <PR_BOOTABLE+0xc64>
 cdf:	00 00                	add    %al,(%eax)
 ce1:	04 7a                	add    $0x7a,%al
 ce3:	05 00 00 00 09       	add    $0x9000000,%eax
 ce8:	7f 05                	jg     cef <PR_BOOTABLE+0xc6f>
 cea:	00 00                	add    %al,(%eax)
 cec:	05 01 06 49 01       	add    $0x1490601,%eax
 cf1:	00 00                	add    %al,(%eax)
 cf3:	07                   	pop    %es
 cf4:	68 00 00 00 02       	push   $0x2000000
 cf9:	4f                   	dec    %edi
 cfa:	06                   	push   %es
 cfb:	98                   	cwtl
 cfc:	05 00 00 04 7a       	add    $0x7a040000,%eax
 d01:	05 00 00 00 07       	add    $0x7000000,%eax
 d06:	80 00 00             	addb   $0x0,(%eax)
 d09:	00 02                	add    %al,(%edx)
 d0b:	51                   	push   %ecx
 d0c:	06                   	push   %es
 d0d:	aa                   	stos   %al,%es:(%edi)
 d0e:	05 00 00 04 63       	add    $0x63040000,%eax
 d13:	00 00                	add    %al,(%eax)
 d15:	00 00                	add    %al,(%eax)
 d17:	10 97 03 00 00 47    	adc    %dl,0x47000003(%edi)
 d1d:	63 05 00 00 12 8e    	arpl   %eax,0x8e120000
 d23:	00 00                	add    %al,(%eax)
 d25:	67 00 00             	add    %al,(%bx,%si)
 d28:	00 01                	add    %al,(%ecx)
 d2a:	9c                   	pushf
 d2b:	06                   	push   %es
 d2c:	06                   	push   %es
 d2d:	00 00                	add    %al,(%eax)
 d2f:	11 3c 03             	adc    %edi,(%ebx,%eax,1)
 d32:	00 00                	add    %al,(%eax)
 d34:	47                   	inc    %edi
 d35:	1a 06                	sbb    (%esi),%al
 d37:	06                   	push   %es
 d38:	00 00                	add    %al,(%eax)
 d3a:	02 91 00 0c 70 00    	add    0x700c00(%ecx),%dl
 d40:	49                   	dec    %ecx
 d41:	0f 06                	clts
 d43:	06                   	push   %es
 d44:	00 00                	add    %al,(%eax)
 d46:	ce                   	into
 d47:	03 00                	add    (%eax),%eax
 d49:	00 c2                	add    %al,%dl
 d4b:	03 00                	add    (%eax),%eax
 d4d:	00 0e                	add    %cl,(%esi)
 d4f:	a2 04 00 00 4a       	mov    %al,0x4a000004
 d54:	6a 00                	push   $0x0
 d56:	00 00                	add    %al,(%eax)
 d58:	27                   	daa
 d59:	04 00                	add    $0x0,%al
 d5b:	00 1d 04 00 00 02    	add    %bl,0x2000004
 d61:	29 8e 00 00 86 05    	sub    %ecx,0x5860000(%esi)
 d67:	00 00                	add    %al,(%eax)
 d69:	02 43 8e             	add    -0x72(%ebx),%al
 d6c:	00 00                	add    %al,(%eax)
 d6e:	19 05 00 00 00 09    	sbb    %eax,0x9000000
 d74:	c7 01 00 00 10 1c    	movl   $0x1c100000,(%ecx)
 d7a:	02 00                	add    (%eax),%al
 d7c:	00 2f                	add    %ch,(%edi)
 d7e:	6a 00                	push   $0x0
 d80:	00 00                	add    %al,(%eax)
 d82:	91                   	xchg   %eax,%ecx
 d83:	8d 00                	lea    (%eax),%eax
 d85:	00 81 00 00 00 01    	add    %al,0x1000000(%ecx)
 d8b:	9c                   	pushf
 d8c:	72 06                	jb     d94 <PR_BOOTABLE+0xd14>
 d8e:	00 00                	add    %al,(%eax)
 d90:	11 b4 03 00 00 2f 16 	adc    %esi,0x162f0000(%ebx,%eax,1)
 d97:	6a 00                	push   $0x0
 d99:	00 00                	add    %al,(%eax)
 d9b:	02 91 00 0c 70 68    	add    0x68700c00(%ecx),%dl
 da1:	00 32                	add    %dh,(%edx)
 da3:	0b 72 06             	or     0x6(%edx),%esi
 da6:	00 00                	add    %al,(%eax)
 da8:	58                   	pop    %eax
 da9:	04 00                	add    $0x0,%al
 dab:	00 52 04             	add    %dl,0x4(%edx)
 dae:	00 00                	add    %al,(%eax)
 db0:	0c 65                	or     $0x65,%al
 db2:	70 68                	jo     e1c <PR_BOOTABLE+0xd9c>
 db4:	00 32                	add    %dh,(%edx)
 db6:	10 72 06             	adc    %dh,0x6(%edx)
 db9:	00 00                	add    %al,(%eax)
 dbb:	6c                   	insb   (%dx),%es:(%edi)
 dbc:	04 00                	add    $0x0,%al
 dbe:	00 6a 04             	add    %ch,0x4(%edx)
 dc1:	00 00                	add    %al,(%eax)
 dc3:	02 af 8d 00 00 2b    	add    0x2b00008d(%edi),%ch
 dc9:	05 00 00 02 cb       	add    $0xcb020000,%eax
 dce:	8d 00                	lea    (%eax),%eax
 dd0:	00 68 05             	add    %ch,0x5(%eax)
 dd3:	00 00                	add    %al,(%eax)
 dd5:	02 fb                	add    %bl,%bh
 dd7:	8d 00                	lea    (%eax),%eax
 dd9:	00 2b                	add    %ch,(%ebx)
 ddb:	05 00 00 00 09       	add    $0x9000000,%eax
 de0:	1b 03                	sbb    (%ebx),%eax
 de2:	00 00                	add    %al,(%eax)
 de4:	1b 06                	sbb    (%esi),%eax
 de6:	03 00                	add    (%eax),%eax
 de8:	00 01                	add    %al,(%ecx)
 dea:	0c 01                	or     $0x1,%al
 dec:	79 8e                	jns    d7c <PR_BOOTABLE+0xcfc>
 dee:	00 00                	add    %al,(%eax)
 df0:	a3 00 00 00 01       	mov    %eax,0x1000000
 df5:	9c                   	pushf
 df6:	4c                   	dec    %esp
 df7:	07                   	pop    %es
 df8:	00 00                	add    %al,(%eax)
 dfa:	12 64 65 76          	adc    0x76(%ebp,%eiz,2),%ah
 dfe:	00 15 6a 00 00 00    	add    %dl,0x6a
 e04:	74 04                	je     e0a <PR_BOOTABLE+0xd8a>
 e06:	00 00                	add    %al,(%eax)
 e08:	72 04                	jb     e0e <PR_BOOTABLE+0xd8e>
 e0a:	00 00                	add    %al,(%eax)
 e0c:	12 6d 62             	adc    0x62(%ebp),%ch
 e0f:	72 00                	jb     e11 <PR_BOOTABLE+0xd91>
 e11:	22 4c 07 00          	and    0x0(%edi,%eax,1),%cl
 e15:	00 81 04 00 00 7d    	add    %al,0x7d000004(%ecx)
 e1b:	04 00                	add    $0x0,%al
 e1d:	00 1c 3c             	add    %bl,(%esp,%edi,1)
 e20:	03 00                	add    (%eax),%eax
 e22:	00 01                	add    %al,(%ecx)
 e24:	0c 34                	or     $0x34,%al
 e26:	06                   	push   %es
 e27:	06                   	push   %es
 e28:	00 00                	add    %al,(%eax)
 e2a:	96                   	xchg   %eax,%esi
 e2b:	04 00                	add    $0x0,%al
 e2d:	00 92 04 00 00 0c    	add    %dl,0xc000004(%edx)
 e33:	69 00 11 06 63 00    	imul   $0x630611,(%eax),%eax
 e39:	00 00                	add    %al,(%eax)
 e3b:	ab                   	stos   %eax,%es:(%edi)
 e3c:	04 00                	add    $0x0,%al
 e3e:	00 a7 04 00 00 0e    	add    %ah,0xe000004(%edi)
 e44:	f9                   	stc
 e45:	02 00                	add    (%eax),%al
 e47:	00 12                	add    %dl,(%edx)
 e49:	6a 00                	push   $0x0
 e4b:	00 00                	add    %al,(%eax)
 e4d:	c1 04 00 00          	roll   $0x0,(%eax,%eax,1)
 e51:	bb 04 00 00 0e       	mov    $0xe000004,%ebx
 e56:	0d 02 00 00 22       	or     $0x22000002,%eax
 e5b:	6a 00                	push   $0x0
 e5d:	00 00                	add    %al,(%eax)
 e5f:	dd 04 00             	fldl   (%eax,%eax,1)
 e62:	00 d9                	add    %bl,%cl
 e64:	04 00                	add    $0x0,%al
 e66:	00 02                	add    %al,(%edx)
 e68:	8e 8e 00 00 98 05    	mov    0x5980000(%esi),%cs
 e6e:	00 00                	add    %al,(%eax)
 e70:	02 9a 8e 00 00 86    	add    -0x79ffff72(%edx),%bl
 e76:	05 00 00 02 cc       	add    $0xcc020000,%eax
 e7b:	8e 00                	mov    (%eax),%es
 e7d:	00 68 05             	add    %ch,0x5(%eax)
 e80:	00 00                	add    %al,(%eax)
 e82:	02 d8                	add    %al,%bl
 e84:	8e 00                	mov    (%eax),%es
 e86:	00 aa 05 00 00 02    	add    %ch,0x2000005(%edx)
 e8c:	e4 8e                	in     $0x8e,%al
 e8e:	00 00                	add    %al,(%eax)
 e90:	86 05 00 00 02 ec    	xchg   %al,0xec020000
 e96:	8e 00                	mov    (%eax),%es
 e98:	00 0b                	add    %cl,(%ebx)
 e9a:	06                   	push   %es
 e9b:	00 00                	add    %al,(%eax)
 e9d:	02 fa                	add    %dl,%bh
 e9f:	8e 00                	mov    (%eax),%es
 ea1:	00 86 05 00 00 02    	add    %al,0x2000005(%esi)
 ea7:	07                   	pop    %es
 ea8:	8f 00                	pop    (%eax)
 eaa:	00 4c 05 00          	add    %cl,0x0(%ebp,%eax,1)
 eae:	00 1d 1c 8f 00 00    	add    %bl,0x8f1c
 eb4:	68 05 00 00 00       	push   $0x5
 eb9:	09 7f 01             	or     %edi,0x1(%edi)
 ebc:	00 00                	add    %al,(%eax)
 ebe:	00 20                	add    %ah,(%eax)
 ec0:	00 00                	add    %al,(%eax)
 ec2:	00 05 00 01 04 41    	add    %al,0x41040100
 ec8:	04 00                	add    $0x0,%al
 eca:	00 01                	add    %al,(%ecx)
 ecc:	19 06                	sbb    %eax,(%esi)
 ece:	00 00                	add    %al,(%eax)
 ed0:	1c 8f                	sbb    $0x8f,%al
 ed2:	00 00                	add    %al,(%eax)
 ed4:	10 d0                	adc    %dl,%al
 ed6:	04 00                	add    $0x0,%al
 ed8:	00 13                	add    %dl,(%ebx)
 eda:	00 00                	add    %al,(%eax)
 edc:	00 4a 00             	add    %cl,0x0(%edx)
 edf:	00 00                	add    %al,(%eax)
 ee1:	01                   	.byte 0x1
 ee2:	80                   	.byte 0x80

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	01 11                	add    %edx,(%ecx)
   2:	00 10                	add    %dl,(%eax)
   4:	17                   	pop    %ss
   5:	11 01                	adc    %eax,(%ecx)
   7:	12 0f                	adc    (%edi),%cl
   9:	03 0e                	add    (%esi),%ecx
   b:	1b 0e                	sbb    (%esi),%ecx
   d:	25 0e 13 05 00       	and    $0x5130e,%eax
  12:	00 00                	add    %al,(%eax)
  14:	01 05 00 31 13 02    	add    %eax,0x2133100
  1a:	17                   	pop    %ss
  1b:	b7 42                	mov    $0x42,%bh
  1d:	17                   	pop    %ss
  1e:	00 00                	add    %al,(%eax)
  20:	02 2e                	add    (%esi),%ch
  22:	01 3f                	add    %edi,(%edi)
  24:	19 03                	sbb    %eax,(%ebx)
  26:	0e                   	push   %cs
  27:	3a 21                	cmp    (%ecx),%ah
  29:	01 3b                	add    %edi,(%ebx)
  2b:	0b 39                	or     (%ecx),%edi
  2d:	21 01                	and    %eax,(%ecx)
  2f:	27                   	daa
  30:	19 11                	sbb    %edx,(%ecx)
  32:	01 12                	add    %edx,(%edx)
  34:	06                   	push   %es
  35:	40                   	inc    %eax
  36:	18 7a 19             	sbb    %bh,0x19(%edx)
  39:	01 13                	add    %edx,(%ebx)
  3b:	00 00                	add    %al,(%eax)
  3d:	03 05 00 03 08 3a    	add    0x3a080300,%eax
  43:	21 01                	and    %eax,(%ecx)
  45:	3b 0b                	cmp    (%ebx),%ecx
  47:	39 0b                	cmp    %ecx,(%ebx)
  49:	49                   	dec    %ecx
  4a:	13 02                	adc    (%edx),%eax
  4c:	18 00                	sbb    %al,(%eax)
  4e:	00 04 24             	add    %al,(%esp)
  51:	00 0b                	add    %cl,(%ebx)
  53:	0b 3e                	or     (%esi),%edi
  55:	0b 03                	or     (%ebx),%eax
  57:	0e                   	push   %cs
  58:	00 00                	add    %al,(%eax)
  5a:	05 48 00 7d 01       	add    $0x17d0048,%eax
  5f:	7f 13                	jg     74 <PROT_MODE_DSEG+0x64>
  61:	00 00                	add    %al,(%eax)
  63:	06                   	push   %es
  64:	05 00 03 08 3a       	add    $0x3a080300,%eax
  69:	21 01                	and    %eax,(%ecx)
  6b:	3b 0b                	cmp    (%ebx),%ecx
  6d:	39 0b                	cmp    %ecx,(%ebx)
  6f:	49                   	dec    %ecx
  70:	13 02                	adc    (%edx),%eax
  72:	17                   	pop    %ss
  73:	b7 42                	mov    $0x42,%bh
  75:	17                   	pop    %ss
  76:	00 00                	add    %al,(%eax)
  78:	07                   	pop    %es
  79:	34 00                	xor    $0x0,%al
  7b:	03 08                	add    (%eax),%ecx
  7d:	3a 21                	cmp    (%ecx),%ah
  7f:	01 3b                	add    %edi,(%ebx)
  81:	0b 39                	or     (%ecx),%edi
  83:	0b 49 13             	or     0x13(%ecx),%ecx
  86:	02 17                	add    (%edi),%dl
  88:	b7 42                	mov    $0x42,%bh
  8a:	17                   	pop    %ss
  8b:	00 00                	add    %al,(%eax)
  8d:	08 1d 01 31 13 52    	or     %bl,0x52133101
  93:	01 b8 42 0b 11 01    	add    %edi,0x1110b42(%eax)
  99:	12 06                	adc    (%esi),%al
  9b:	58                   	pop    %eax
  9c:	21 01                	and    %eax,(%ecx)
  9e:	59                   	pop    %ecx
  9f:	0b 57 21             	or     0x21(%edi),%edx
  a2:	02 01                	add    (%ecx),%al
  a4:	13 00                	adc    (%eax),%eax
  a6:	00 09                	add    %cl,(%ecx)
  a8:	05 00 03 0e 3a       	add    $0x3a0e0300,%eax
  ad:	21 02                	and    %eax,(%edx)
  af:	3b 0b                	cmp    (%ebx),%ecx
  b1:	39 0b                	cmp    %ecx,(%ebx)
  b3:	49                   	dec    %ecx
  b4:	13 00                	adc    (%eax),%eax
  b6:	00 0a                	add    %cl,(%edx)
  b8:	05 00 03 0e 3a       	add    $0x3a0e0300,%eax
  bd:	21 01                	and    %eax,(%ecx)
  bf:	3b 0b                	cmp    (%ebx),%ecx
  c1:	39 0b                	cmp    %ecx,(%ebx)
  c3:	49                   	dec    %ecx
  c4:	13 02                	adc    (%edx),%eax
  c6:	17                   	pop    %ss
  c7:	b7 42                	mov    $0x42,%bh
  c9:	17                   	pop    %ss
  ca:	00 00                	add    %al,(%eax)
  cc:	0b 05 00 03 0e 3a    	or     0x3a0e0300,%eax
  d2:	21 01                	and    %eax,(%ecx)
  d4:	3b 0b                	cmp    (%ebx),%ecx
  d6:	39 0b                	cmp    %ecx,(%ebx)
  d8:	49                   	dec    %ecx
  d9:	13 02                	adc    (%edx),%eax
  db:	18 00                	sbb    %al,(%eax)
  dd:	00 0c 16             	add    %cl,(%esi,%edx,1)
  e0:	00 03                	add    %al,(%ebx)
  e2:	0e                   	push   %cs
  e3:	3a 21                	cmp    (%ecx),%ah
  e5:	02 3b                	add    (%ebx),%bh
  e7:	0b 39                	or     (%ecx),%edi
  e9:	0b 49 13             	or     0x13(%ecx),%ecx
  ec:	00 00                	add    %al,(%eax)
  ee:	0d 0f 00 0b 21       	or     $0x210b000f,%eax
  f3:	04 49                	add    $0x49,%al
  f5:	13 00                	adc    (%eax),%eax
  f7:	00 0e                	add    %cl,(%esi)
  f9:	34 00                	xor    $0x0,%al
  fb:	03 08                	add    (%eax),%ecx
  fd:	3a 21                	cmp    (%ecx),%ah
  ff:	01 3b                	add    %edi,(%ebx)
 101:	0b 39                	or     (%ecx),%edi
 103:	0b 49 13             	or     0x13(%ecx),%ecx
 106:	02 18                	add    (%eax),%bl
 108:	00 00                	add    %al,(%eax)
 10a:	0f 01 01             	sgdtl  (%ecx)
 10d:	49                   	dec    %ecx
 10e:	13 01                	adc    (%ecx),%eax
 110:	13 00                	adc    (%eax),%eax
 112:	00 10                	add    %dl,(%eax)
 114:	21 00                	and    %eax,(%eax)
 116:	49                   	dec    %ecx
 117:	13 2f                	adc    (%edi),%ebp
 119:	0b 00                	or     (%eax),%eax
 11b:	00 11                	add    %dl,(%ecx)
 11d:	1d 01 31 13 52       	sbb    $0x52133101,%eax
 122:	01 b8 42 0b 55 17    	add    %edi,0x17550b42(%eax)
 128:	58                   	pop    %eax
 129:	21 01                	and    %eax,(%ecx)
 12b:	59                   	pop    %ecx
 12c:	0b 57 21             	or     0x21(%edi),%edx
 12f:	02 01                	add    (%ecx),%al
 131:	13 00                	adc    (%eax),%eax
 133:	00 12                	add    %dl,(%edx)
 135:	34 00                	xor    $0x0,%al
 137:	03 0e                	add    (%esi),%ecx
 139:	3a 21                	cmp    (%ecx),%ah
 13b:	01 3b                	add    %edi,(%ebx)
 13d:	0b 39                	or     (%ecx),%edi
 13f:	0b 49 13             	or     0x13(%ecx),%ecx
 142:	3f                   	aas
 143:	19 02                	sbb    %eax,(%edx)
 145:	18 00                	sbb    %al,(%eax)
 147:	00 13                	add    %dl,(%ebx)
 149:	34 00                	xor    $0x0,%al
 14b:	03 0e                	add    (%esi),%ecx
 14d:	3a 21                	cmp    (%ecx),%ah
 14f:	01 3b                	add    %edi,(%ebx)
 151:	0b 39                	or     (%ecx),%edi
 153:	0b 49 13             	or     0x13(%ecx),%ecx
 156:	02 17                	add    (%edi),%dl
 158:	b7 42                	mov    $0x42,%bh
 15a:	17                   	pop    %ss
 15b:	00 00                	add    %al,(%eax)
 15d:	14 1d                	adc    $0x1d,%al
 15f:	01 31                	add    %esi,(%ecx)
 161:	13 52 01             	adc    0x1(%edx),%edx
 164:	b8 42 0b 11 01       	mov    $0x1110b42,%eax
 169:	12 06                	adc    (%esi),%al
 16b:	58                   	pop    %eax
 16c:	21 01                	and    %eax,(%ecx)
 16e:	59                   	pop    %ecx
 16f:	0b 57 0b             	or     0xb(%edi),%edx
 172:	00 00                	add    %al,(%eax)
 174:	15 34 00 31 13       	adc    $0x13310034,%eax
 179:	00 00                	add    %al,(%eax)
 17b:	16                   	push   %ss
 17c:	48                   	dec    %eax
 17d:	00 7d 01             	add    %bh,0x1(%ebp)
 180:	82 01 19             	addb   $0x19,(%ecx)
 183:	7f 13                	jg     198 <PR_BOOTABLE+0x118>
 185:	00 00                	add    %al,(%eax)
 187:	17                   	pop    %ss
 188:	2e 01 3f             	add    %edi,%cs:(%edi)
 18b:	19 03                	sbb    %eax,(%ebx)
 18d:	0e                   	push   %cs
 18e:	3a 21                	cmp    (%ecx),%ah
 190:	01 3b                	add    %edi,(%ebx)
 192:	0b 39                	or     (%ecx),%edi
 194:	21 01                	and    %eax,(%ecx)
 196:	27                   	daa
 197:	19 49 13             	sbb    %ecx,0x13(%ecx)
 19a:	11 01                	adc    %eax,(%ecx)
 19c:	12 06                	adc    (%esi),%al
 19e:	40                   	inc    %eax
 19f:	18 7a 19             	sbb    %bh,0x19(%edx)
 1a2:	01 13                	add    %edx,(%ebx)
 1a4:	00 00                	add    %al,(%eax)
 1a6:	18 11                	sbb    %dl,(%ecx)
 1a8:	01 25 0e 13 0b 03    	add    %esp,0x30b130e
 1ae:	1f                   	pop    %ds
 1af:	1b 1f                	sbb    (%edi),%ebx
 1b1:	11 01                	adc    %eax,(%ecx)
 1b3:	12 06                	adc    (%esi),%al
 1b5:	10 17                	adc    %dl,(%edi)
 1b7:	00 00                	add    %al,(%eax)
 1b9:	19 24 00             	sbb    %esp,(%eax,%eax,1)
 1bc:	0b 0b                	or     (%ebx),%ecx
 1be:	3e 0b 03             	or     %ds:(%ebx),%eax
 1c1:	08 00                	or     %al,(%eax)
 1c3:	00 1a                	add    %bl,(%edx)
 1c5:	35 00 49 13 00       	xor    $0x134900,%eax
 1ca:	00 1b                	add    %bl,(%ebx)
 1cc:	26 00 49 13          	add    %cl,%es:0x13(%ecx)
 1d0:	00 00                	add    %al,(%eax)
 1d2:	1c 34                	sbb    $0x34,%al
 1d4:	00 03                	add    %al,(%ebx)
 1d6:	0e                   	push   %cs
 1d7:	3a 0b                	cmp    (%ebx),%cl
 1d9:	3b 0b                	cmp    (%ebx),%ecx
 1db:	39 0b                	cmp    %ecx,(%ebx)
 1dd:	49                   	dec    %ecx
 1de:	13 02                	adc    (%edx),%eax
 1e0:	18 00                	sbb    %al,(%eax)
 1e2:	00 1d 1d 01 31 13    	add    %bl,0x1331011d
 1e8:	52                   	push   %edx
 1e9:	01 b8 42 0b 55 17    	add    %edi,0x17550b42(%eax)
 1ef:	58                   	pop    %eax
 1f0:	0b 59 0b             	or     0xb(%ecx),%ebx
 1f3:	57                   	push   %edi
 1f4:	0b 00                	or     (%eax),%eax
 1f6:	00 1e                	add    %bl,(%esi)
 1f8:	0f 00 0b             	str    (%ebx)
 1fb:	0b 00                	or     (%eax),%eax
 1fd:	00 1f                	add    %bl,(%edi)
 1ff:	2e 00 03             	add    %al,%cs:(%ebx)
 202:	0e                   	push   %cs
 203:	3a 0b                	cmp    (%ebx),%cl
 205:	3b 0b                	cmp    (%ebx),%ecx
 207:	39 0b                	cmp    %ecx,(%ebx)
 209:	27                   	daa
 20a:	19 20                	sbb    %esp,(%eax)
 20c:	0b 00                	or     (%eax),%eax
 20e:	00 20                	add    %ah,(%eax)
 210:	2e 01 03             	add    %eax,%cs:(%ebx)
 213:	0e                   	push   %cs
 214:	3a 0b                	cmp    (%ebx),%cl
 216:	3b 0b                	cmp    (%ebx),%ecx
 218:	39 0b                	cmp    %ecx,(%ebx)
 21a:	27                   	daa
 21b:	19 20                	sbb    %esp,(%eax)
 21d:	0b 01                	or     (%ecx),%eax
 21f:	13 00                	adc    (%eax),%eax
 221:	00 21                	add    %ah,(%ecx)
 223:	05 00 03 08 3a       	add    $0x3a080300,%eax
 228:	0b 3b                	or     (%ebx),%edi
 22a:	0b 39                	or     (%ecx),%edi
 22c:	0b 49 13             	or     0x13(%ecx),%ecx
 22f:	00 00                	add    %al,(%eax)
 231:	22 2e                	and    (%esi),%ch
 233:	01 03                	add    %eax,(%ebx)
 235:	08 3a                	or     %bh,(%edx)
 237:	0b 3b                	or     (%ebx),%edi
 239:	0b 39                	or     (%ecx),%edi
 23b:	0b 27                	or     (%edi),%esp
 23d:	19 49 13             	sbb    %ecx,0x13(%ecx)
 240:	20 0b                	and    %cl,(%ebx)
 242:	01 13                	add    %edx,(%ebx)
 244:	00 00                	add    %al,(%eax)
 246:	23 34 00             	and    (%eax,%eax,1),%esi
 249:	03 0e                	add    (%esi),%ecx
 24b:	3a 0b                	cmp    (%ebx),%cl
 24d:	3b 0b                	cmp    (%ebx),%ecx
 24f:	39 0b                	cmp    %ecx,(%ebx)
 251:	49                   	dec    %ecx
 252:	13 00                	adc    (%eax),%eax
 254:	00 24 2e             	add    %ah,(%esi,%ebp,1)
 257:	01 03                	add    %eax,(%ebx)
 259:	0e                   	push   %cs
 25a:	3a 0b                	cmp    (%ebx),%cl
 25c:	3b 0b                	cmp    (%ebx),%ecx
 25e:	39 0b                	cmp    %ecx,(%ebx)
 260:	27                   	daa
 261:	19 20                	sbb    %esp,(%eax)
 263:	0b 00                	or     (%eax),%eax
 265:	00 00                	add    %al,(%eax)
 267:	01 0d 00 03 0e 3a    	add    %ecx,0x3a0e0300
 26d:	21 02                	and    %eax,(%edx)
 26f:	3b 0b                	cmp    (%ebx),%ecx
 271:	39 0b                	cmp    %ecx,(%ebx)
 273:	49                   	dec    %ecx
 274:	13 38                	adc    (%eax),%edi
 276:	0b 00                	or     (%eax),%eax
 278:	00 02                	add    %al,(%edx)
 27a:	48                   	dec    %eax
 27b:	00 7d 01             	add    %bh,0x1(%ebp)
 27e:	7f 13                	jg     293 <PR_BOOTABLE+0x213>
 280:	00 00                	add    %al,(%eax)
 282:	03 16                	add    (%esi),%edx
 284:	00 03                	add    %al,(%ebx)
 286:	0e                   	push   %cs
 287:	3a 21                	cmp    (%ecx),%ah
 289:	02 3b                	add    (%ebx),%bh
 28b:	0b 39                	or     (%ecx),%edi
 28d:	0b 49 13             	or     0x13(%ecx),%ecx
 290:	00 00                	add    %al,(%eax)
 292:	04 05                	add    $0x5,%al
 294:	00 49 13             	add    %cl,0x13(%ecx)
 297:	00 00                	add    %al,(%eax)
 299:	05 24 00 0b 0b       	add    $0xb0b0024,%eax
 29e:	3e 0b 03             	or     %ds:(%ebx),%eax
 2a1:	0e                   	push   %cs
 2a2:	00 00                	add    %al,(%eax)
 2a4:	06                   	push   %es
 2a5:	01 01                	add    %eax,(%ecx)
 2a7:	49                   	dec    %ecx
 2a8:	13 01                	adc    (%ecx),%eax
 2aa:	13 00                	adc    (%eax),%eax
 2ac:	00 07                	add    %al,(%edi)
 2ae:	2e 01 3f             	add    %edi,%cs:(%edi)
 2b1:	19 03                	sbb    %eax,(%ebx)
 2b3:	0e                   	push   %cs
 2b4:	3a 0b                	cmp    (%ebx),%cl
 2b6:	3b 0b                	cmp    (%ebx),%ecx
 2b8:	39 0b                	cmp    %ecx,(%ebx)
 2ba:	27                   	daa
 2bb:	19 3c 19             	sbb    %edi,(%ecx,%ebx,1)
 2be:	01 13                	add    %edx,(%ebx)
 2c0:	00 00                	add    %al,(%eax)
 2c2:	08 21                	or     %ah,(%ecx)
 2c4:	00 49 13             	add    %cl,0x13(%ecx)
 2c7:	2f                   	das
 2c8:	0b 00                	or     (%eax),%eax
 2ca:	00 09                	add    %cl,(%ecx)
 2cc:	0f 00 0b             	str    (%ebx)
 2cf:	21 04 49             	and    %eax,(%ecx,%ecx,2)
 2d2:	13 00                	adc    (%eax),%eax
 2d4:	00 0a                	add    %cl,(%edx)
 2d6:	13 01                	adc    (%ecx),%eax
 2d8:	0b 0b                	or     (%ebx),%ecx
 2da:	3a 21                	cmp    (%ecx),%ah
 2dc:	02 3b                	add    (%ebx),%bh
 2de:	0b 39                	or     (%ecx),%edi
 2e0:	0b 01                	or     (%ecx),%eax
 2e2:	13 00                	adc    (%eax),%eax
 2e4:	00 0b                	add    %cl,(%ebx)
 2e6:	13 01                	adc    (%ecx),%eax
 2e8:	03 0e                	add    (%esi),%ecx
 2ea:	0b 0b                	or     (%ebx),%ecx
 2ec:	3a 21                	cmp    (%ecx),%ah
 2ee:	02 3b                	add    (%ebx),%bh
 2f0:	0b 39                	or     (%ecx),%edi
 2f2:	0b 01                	or     (%ecx),%eax
 2f4:	13 00                	adc    (%eax),%eax
 2f6:	00 0c 34             	add    %cl,(%esp,%esi,1)
 2f9:	00 03                	add    %al,(%ebx)
 2fb:	08 3a                	or     %bh,(%edx)
 2fd:	21 01                	and    %eax,(%ecx)
 2ff:	3b 0b                	cmp    (%ebx),%ecx
 301:	39 0b                	cmp    %ecx,(%ebx)
 303:	49                   	dec    %ecx
 304:	13 02                	adc    (%edx),%eax
 306:	17                   	pop    %ss
 307:	b7 42                	mov    $0x42,%bh
 309:	17                   	pop    %ss
 30a:	00 00                	add    %al,(%eax)
 30c:	0d 0d 00 03 0e       	or     $0xe03000d,%eax
 311:	3a 21                	cmp    (%ecx),%ah
 313:	02 3b                	add    (%ebx),%bh
 315:	0b 39                	or     (%ecx),%edi
 317:	0b 49 13             	or     0x13(%ecx),%ecx
 31a:	38 05 00 00 0e 34    	cmp    %al,0x340e0000
 320:	00 03                	add    %al,(%ebx)
 322:	0e                   	push   %cs
 323:	3a 21                	cmp    (%ecx),%ah
 325:	01 3b                	add    %edi,(%ebx)
 327:	0b 39                	or     (%ecx),%edi
 329:	21 0b                	and    %ecx,(%ebx)
 32b:	49                   	dec    %ecx
 32c:	13 02                	adc    (%edx),%eax
 32e:	17                   	pop    %ss
 32f:	b7 42                	mov    $0x42,%bh
 331:	17                   	pop    %ss
 332:	00 00                	add    %al,(%eax)
 334:	0f 0d 00             	prefetch (%eax)
 337:	03 08                	add    (%eax),%ecx
 339:	3a 21                	cmp    (%ecx),%ah
 33b:	02 3b                	add    (%ebx),%bh
 33d:	0b 39                	or     (%ecx),%edi
 33f:	0b 49 13             	or     0x13(%ecx),%ecx
 342:	38 0b                	cmp    %cl,(%ebx)
 344:	00 00                	add    %al,(%eax)
 346:	10 2e                	adc    %ch,(%esi)
 348:	01 3f                	add    %edi,(%edi)
 34a:	19 03                	sbb    %eax,(%ebx)
 34c:	0e                   	push   %cs
 34d:	3a 21                	cmp    (%ecx),%ah
 34f:	01 3b                	add    %edi,(%ebx)
 351:	0b 39                	or     (%ecx),%edi
 353:	21 01                	and    %eax,(%ecx)
 355:	27                   	daa
 356:	19 49 13             	sbb    %ecx,0x13(%ecx)
 359:	11 01                	adc    %eax,(%ecx)
 35b:	12 06                	adc    (%esi),%al
 35d:	40                   	inc    %eax
 35e:	18 7a 19             	sbb    %bh,0x19(%edx)
 361:	01 13                	add    %edx,(%ebx)
 363:	00 00                	add    %al,(%eax)
 365:	11 05 00 03 0e 3a    	adc    %eax,0x3a0e0300
 36b:	21 01                	and    %eax,(%ecx)
 36d:	3b 0b                	cmp    (%ebx),%ecx
 36f:	39 0b                	cmp    %ecx,(%ebx)
 371:	49                   	dec    %ecx
 372:	13 02                	adc    (%edx),%eax
 374:	18 00                	sbb    %al,(%eax)
 376:	00 12                	add    %dl,(%edx)
 378:	05 00 03 08 3a       	add    $0x3a080300,%eax
 37d:	21 01                	and    %eax,(%ecx)
 37f:	3b 21                	cmp    (%ecx),%esp
 381:	0c 39                	or     $0x39,%al
 383:	0b 49 13             	or     0x13(%ecx),%ecx
 386:	02 17                	add    (%edi),%dl
 388:	b7 42                	mov    $0x42,%bh
 38a:	17                   	pop    %ss
 38b:	00 00                	add    %al,(%eax)
 38d:	13 11                	adc    (%ecx),%edx
 38f:	01 25 0e 13 0b 03    	add    %esp,0x30b130e
 395:	1f                   	pop    %ds
 396:	1b 1f                	sbb    (%edi),%ebx
 398:	11 01                	adc    %eax,(%ecx)
 39a:	12 06                	adc    (%esi),%al
 39c:	10 17                	adc    %dl,(%edi)
 39e:	00 00                	add    %al,(%eax)
 3a0:	14 24                	adc    $0x24,%al
 3a2:	00 0b                	add    %cl,(%ebx)
 3a4:	0b 3e                	or     (%esi),%edi
 3a6:	0b 03                	or     (%ebx),%eax
 3a8:	08 00                	or     %al,(%eax)
 3aa:	00 15 13 01 03 08    	add    %dl,0x8030113
 3b0:	0b 05 3a 0b 3b 0b    	or     0xb3b0b3a,%eax
 3b6:	39 0b                	cmp    %ecx,(%ebx)
 3b8:	01 13                	add    %edx,(%ebx)
 3ba:	00 00                	add    %al,(%eax)
 3bc:	16                   	push   %ss
 3bd:	21 00                	and    %eax,(%eax)
 3bf:	49                   	dec    %ecx
 3c0:	13 2f                	adc    (%edi),%ebp
 3c2:	05 00 00 17 17       	add    $0x17170000,%eax
 3c7:	01 0b                	add    %ecx,(%ebx)
 3c9:	0b 3a                	or     (%edx),%edi
 3cb:	0b 3b                	or     (%ebx),%edi
 3cd:	0b 39                	or     (%ecx),%edi
 3cf:	0b 01                	or     (%ecx),%eax
 3d1:	13 00                	adc    (%eax),%eax
 3d3:	00 18                	add    %bl,(%eax)
 3d5:	0d 00 03 0e 3a       	or     $0x3a0e0300,%eax
 3da:	0b 3b                	or     (%ebx),%edi
 3dc:	0b 39                	or     (%ecx),%edi
 3de:	0b 49 13             	or     0x13(%ecx),%ecx
 3e1:	00 00                	add    %al,(%eax)
 3e3:	19 0d 00 03 08 3a    	sbb    %ecx,0x3a080300
 3e9:	0b 3b                	or     (%ebx),%edi
 3eb:	0b 39                	or     (%ecx),%edi
 3ed:	0b 49 13             	or     0x13(%ecx),%ecx
 3f0:	00 00                	add    %al,(%eax)
 3f2:	1a 34 00             	sbb    (%eax,%eax,1),%dh
 3f5:	03 0e                	add    (%esi),%ecx
 3f7:	3a 0b                	cmp    (%ebx),%cl
 3f9:	3b 0b                	cmp    (%ebx),%ecx
 3fb:	39 0b                	cmp    %ecx,(%ebx)
 3fd:	49                   	dec    %ecx
 3fe:	13 3f                	adc    (%edi),%edi
 400:	19 02                	sbb    %eax,(%edx)
 402:	18 00                	sbb    %al,(%eax)
 404:	00 1b                	add    %bl,(%ebx)
 406:	2e 01 3f             	add    %edi,%cs:(%edi)
 409:	19 03                	sbb    %eax,(%ebx)
 40b:	0e                   	push   %cs
 40c:	3a 0b                	cmp    (%ebx),%cl
 40e:	3b 0b                	cmp    (%ebx),%ecx
 410:	39 0b                	cmp    %ecx,(%ebx)
 412:	27                   	daa
 413:	19 11                	sbb    %edx,(%ecx)
 415:	01 12                	add    %edx,(%edx)
 417:	06                   	push   %es
 418:	40                   	inc    %eax
 419:	18 7a 19             	sbb    %bh,0x19(%edx)
 41c:	01 13                	add    %edx,(%ebx)
 41e:	00 00                	add    %al,(%eax)
 420:	1c 05                	sbb    $0x5,%al
 422:	00 03                	add    %al,(%ebx)
 424:	0e                   	push   %cs
 425:	3a 0b                	cmp    (%ebx),%cl
 427:	3b 0b                	cmp    (%ebx),%ecx
 429:	39 0b                	cmp    %ecx,(%ebx)
 42b:	49                   	dec    %ecx
 42c:	13 02                	adc    (%edx),%eax
 42e:	17                   	pop    %ss
 42f:	b7 42                	mov    $0x42,%bh
 431:	17                   	pop    %ss
 432:	00 00                	add    %al,(%eax)
 434:	1d 48 00 7d 01       	sbb    $0x17d0048,%eax
 439:	82 01 19             	addb   $0x19,(%ecx)
 43c:	7f 13                	jg     451 <PR_BOOTABLE+0x3d1>
 43e:	00 00                	add    %al,(%eax)
 440:	00 01                	add    %al,(%ecx)
 442:	11 00                	adc    %eax,(%eax)
 444:	10 17                	adc    %dl,(%edi)
 446:	11 01                	adc    %eax,(%ecx)
 448:	12 0f                	adc    (%edi),%cl
 44a:	03 0e                	add    (%esi),%ecx
 44c:	1b 0e                	sbb    (%esi),%ecx
 44e:	25 0e 13 05 00       	and    $0x5130e,%eax
 453:	00 00                	add    %al,(%eax)

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	83 00 00             	addl   $0x0,(%eax)
   3:	00 05 00 04 00 2e    	add    %al,0x2e000400
   9:	00 00                	add    %al,(%eax)
   b:	00 01                	add    %al,(%ecx)
   d:	01 01                	add    %eax,(%ecx)
   f:	fb                   	sti
  10:	0e                   	push   %cs
  11:	0d 00 01 01 01       	or     $0x1010100,%eax
  16:	01 00                	add    %eax,(%eax)
  18:	00 00                	add    %al,(%eax)
  1a:	01 00                	add    %eax,(%eax)
  1c:	00 01                	add    %al,(%ecx)
  1e:	01 01                	add    %eax,(%ecx)
  20:	1f                   	pop    %ds
  21:	02 00                	add    (%eax),%al
  23:	00 00                	add    %al,(%eax)
  25:	00 37                	add    %dh,(%edi)
  27:	00 00                	add    %al,(%eax)
  29:	00 02                	add    %al,(%edx)
  2b:	01 1f                	add    %ebx,(%edi)
  2d:	02 0f                	add    (%edi),%cl
  2f:	02 42 00             	add    0x0(%edx),%al
  32:	00 00                	add    %al,(%eax)
  34:	01 42 00             	add    %eax,0x0(%edx)
  37:	00 00                	add    %al,(%eax)
  39:	01 00                	add    %eax,(%eax)
  3b:	05 02 00 7e 00       	add    $0x7e0002,%eax
  40:	00 03                	add    %al,(%ebx)
  42:	2a 01                	sub    (%ecx),%al
  44:	21 24 2f             	and    %esp,(%edi,%ebp,1)
  47:	2f                   	das
  48:	2f                   	das
  49:	2f                   	das
  4a:	30 2f                	xor    %ch,(%edi)
  4c:	2f                   	das
  4d:	2f                   	das
  4e:	2f                   	das
  4f:	34 3d                	xor    $0x3d,%al
  51:	42                   	inc    %edx
  52:	3d 67 3e 67 67       	cmp    $0x67673e67,%eax
  57:	30 2f                	xor    %ch,(%edi)
  59:	67 30 83 3d 4b       	xor    %al,0x4b3d(%bp,%di)
  5e:	2f                   	das
  5f:	30 2f                	xor    %ch,(%edi)
  61:	3d 2f 30 3d 3d       	cmp    $0x3d3d302f,%eax
  66:	31 26                	xor    %esp,(%esi)
  68:	59                   	pop    %ecx
  69:	3d 4b 40 5c 4b       	cmp    $0x4b5c404b,%eax
  6e:	2f                   	das
  6f:	2f                   	das
  70:	2f                   	das
  71:	2f                   	das
  72:	34 59                	xor    $0x59,%al
  74:	59                   	pop    %ecx
  75:	59                   	pop    %ecx
  76:	21 5b 27             	and    %ebx,0x27(%ebx)
  79:	21 30                	and    %esi,(%eax)
  7b:	21 2f                	and    %ebp,(%edi)
  7d:	2f                   	das
  7e:	2f                   	das
  7f:	30 21                	xor    %ah,(%ecx)
  81:	02 fc                	add    %ah,%bh
  83:	18 00                	sbb    %al,(%eax)
  85:	01 01                	add    %eax,(%ecx)
  87:	ec                   	in     (%dx),%al
  88:	03 00                	add    (%eax),%eax
  8a:	00 05 00 04 00 33    	add    %al,0x33000400
  90:	00 00                	add    %al,(%eax)
  92:	00 01                	add    %al,(%ecx)
  94:	01 01                	add    %eax,(%ecx)
  96:	fb                   	sti
  97:	0e                   	push   %cs
  98:	0d 00 01 01 01       	or     $0x1010100,%eax
  9d:	01 00                	add    %eax,(%eax)
  9f:	00 00                	add    %al,(%eax)
  a1:	01 00                	add    %eax,(%eax)
  a3:	00 01                	add    %al,(%ecx)
  a5:	01 01                	add    %eax,(%ecx)
  a7:	1f                   	pop    %ds
  a8:	02 00                	add    (%eax),%al
  aa:	00 00                	add    %al,(%eax)
  ac:	00 37                	add    %dh,(%edi)
  ae:	00 00                	add    %al,(%eax)
  b0:	00 02                	add    %al,(%edx)
  b2:	01 1f                	add    %ebx,(%edi)
  b4:	02 0f                	add    (%edi),%cl
  b6:	03 55 00             	add    0x0(%ebp),%edx
  b9:	00 00                	add    %al,(%eax)
  bb:	01 55 00             	add    %edx,0x0(%ebp)
  be:	00 00                	add    %al,(%eax)
  c0:	01 60 00             	add    %esp,0x0(%eax)
  c3:	00 00                	add    %al,(%eax)
  c5:	01 05 01 00 05 02    	add    %eax,0x2050001
  cb:	26 8b 00             	mov    %es:(%eax),%eax
  ce:	00 03                	add    %al,(%ebx)
  d0:	09 01                	or     %eax,(%ecx)
  d2:	05 02 13 05 01       	add    $0x1051302,%eax
  d7:	06                   	push   %es
  d8:	11 3c 05 06 3e 05 20 	adc    %edi,0x20053e06(,%eax,1)
  df:	3b 05 12 2e 05 02    	cmp    0x2052e12,%eax
  e5:	06                   	push   %es
  e6:	67 05 06 06 01 05    	addr16 add $0x5010606,%eax
  ec:	02 06                	add    (%esi),%al
  ee:	2f                   	das
  ef:	05 0c 06 01 05       	add    $0x501060c,%eax
  f4:	01 67 06             	add    %esp,0x6(%edi)
  f7:	33 05 02 13 05 01    	xor    0x1051302,%eax
  fd:	06                   	push   %es
  fe:	11 05 0c 59 05 06    	adc    %eax,0x605590c
 104:	4a                   	dec    %edx
 105:	05 02 06 3d 05       	add    $0x53d0602,%eax
 10a:	06                   	push   %es
 10b:	06                   	push   %es
 10c:	11 05 11 06 2f 05    	adc    %eax,0x52f0611
 112:	09 06                	or     %eax,(%esi)
 114:	01 05 11 90 05 03    	add    %eax,0x3059011
 11a:	06                   	push   %es
 11b:	4c                   	dec    %esp
 11c:	06                   	push   %es
 11d:	01 74 58 05          	add    %esi,0x5(%eax,%ebx,2)
 121:	02 06                	add    (%esi),%al
 123:	5a                   	pop    %edx
 124:	05 01 06 13 3c       	add    $0x3c130601,%eax
 129:	3c 06                	cmp    $0x6,%al
 12b:	03 09                	add    (%ecx),%ecx
 12d:	20 05 02 13 05 01    	and    %al,0x1051302
 133:	06                   	push   %es
 134:	11 05 13 59 05 02    	adc    %eax,0x2055913
 13a:	00 02                	add    %al,(%edx)
 13c:	04 04                	add    $0x4,%al
 13e:	58                   	pop    %eax
 13f:	05 24 00 02 04       	add    $0x4020024,%eax
 144:	01 66 05             	add    %esp,0x5(%esi)
 147:	02 00                	add    (%eax),%al
 149:	02 04 04             	add    (%esp,%eax,1),%al
 14c:	ac                   	lods   %ds:(%esi),%al
 14d:	05 24 00 02 04       	add    $0x4020024,%eax
 152:	01 2e                	add    %ebp,(%esi)
 154:	05 02 00 02 04       	add    $0x4020002,%eax
 159:	04 3c                	add    $0x3c,%al
 15b:	06                   	push   %es
 15c:	d7                   	xlat   %ds:(%ebx)
 15d:	05 01 06 c9 06       	add    $0x6c90601,%eax
 162:	86 05 02 13 05 01    	xchg   %al,0x1051302
 168:	06                   	push   %es
 169:	11 05 06 3d 05 01    	adc    %eax,0x1053d06
 16f:	3d 05 06 1f 05       	cmp    $0x51f0605,%eax
 174:	01 59 06             	add    %ebx,0x6(%ecx)
 177:	24 05                	and    $0x5,%al
 179:	02 13                	add    (%ebx),%dl
 17b:	05 01 06 11 05       	add    $0x5110601,%eax
 180:	02 67 06             	add    0x6(%edi),%ah
 183:	08 13                	or     %dl,(%ebx)
 185:	05 03 00 02 04       	add    $0x4020003,%eax
 18a:	01 14 05 08 1e 05 01 	add    %edx,0x1051e08(,%eax,1)
 191:	03 16                	add    (%esi),%edx
 193:	2e 05 02 13 14 05    	cs add $0x5141302,%eax
 199:	01 06                	add    %eax,(%esi)
 19b:	0f 05                	syscall
 19d:	09 23                	or     %esp,(%ebx)
 19f:	05 01 2b 2e 05       	add    $0x52e2b01,%eax
 1a4:	11 00                	adc    %eax,(%eax)
 1a6:	02 04 01             	add    (%ecx,%eax,1),%al
 1a9:	06                   	push   %es
 1aa:	3f                   	aas
 1ab:	05 03 67 05 04       	add    $0x4056703,%eax
 1b0:	06                   	push   %es
 1b1:	01 05 1b 00 02 04    	add    %eax,0x402001b
 1b7:	03 06                	add    (%esi),%eax
 1b9:	1f                   	pop    %ds
 1ba:	05 02 30 05 01       	add    $0x1053002,%eax
 1bf:	06                   	push   %es
 1c0:	13 06                	adc    (%esi),%eax
 1c2:	33 05 02 13 13 14    	xor    0x14131302,%eax
 1c8:	05 01 06 0e 58       	add    $0x580e0601,%eax
 1cd:	05 12 40 05 09       	add    $0x9054012,%eax
 1d2:	ba 05 10 00 02       	mov    $0x2001005,%edx
 1d7:	04 01                	add    $0x1,%al
 1d9:	2e 05 24 00 02 04    	cs add $0x4020024,%eax
 1df:	02 06                	add    (%esi),%al
 1e1:	20 05 03 4c 05 05    	and    %al,0x5054c03
 1e7:	06                   	push   %es
 1e8:	01 05 03 06 4b 05    	add    %eax,0x54b0603
 1ee:	08 06                	or     %al,(%esi)
 1f0:	01 05 03 06 67 05    	add    %eax,0x5670603
 1f6:	08 06                	or     %al,(%esi)
 1f8:	01 05 2a 00 02 04    	add    %eax,0x402002a
 1fe:	04 2a                	add    $0x2a,%al
 200:	05 08 24 05 2c       	add    $0x2c052408,%eax
 205:	00 02                	add    %al,(%edx)
 207:	04 04                	add    $0x4,%al
 209:	06                   	push   %es
 20a:	38 05 2f 00 02 04    	cmp    %al,0x402002f
 210:	04 06                	add    $0x6,%al
 212:	01 00                	add    %eax,(%eax)
 214:	02 04 04             	add    (%esp,%eax,1),%al
 217:	20 05 01 34 06 79    	and    %al,0x79063401
 21d:	05 02 13 14 05       	add    $0x5141302,%eax
 222:	01 06                	add    %eax,(%esi)
 224:	0f 90 3c 05 05 bd 05 	seto   0x205bd05(,%eax,1)
 22b:	02 
 22c:	06                   	push   %es
 22d:	93                   	xchg   %eax,%ebx
 22e:	05 03 14 05 06       	add    $0x6051403,%eax
 233:	06                   	push   %es
 234:	4a                   	dec    %edx
 235:	05 17 00 02 04       	add    $0x4020017,%eax
 23a:	01 06                	add    %eax,(%esi)
 23c:	21 05 11 06 3b 05    	and    %eax,0x53b0611
 242:	17                   	pop    %ss
 243:	00 02                	add    %al,(%edx)
 245:	04 01                	add    $0x1,%al
 247:	91                   	xchg   %eax,%ecx
 248:	05 02 06 4b 05       	add    $0x54b0602,%eax
 24d:	05 06 01 05 03       	add    $0x3050106,%eax
 252:	06                   	push   %es
 253:	4b                   	dec    %ebx
 254:	05 06 06 01 05       	add    $0x5010606,%eax
 259:	0a 3c 05 06 4a 05 02 	or     0x2054a06(,%eax,1),%bh
 260:	06                   	push   %es
 261:	3d 05 07 06 01       	cmp    $0x1060705,%eax
 266:	05 02 06 4b 05       	add    $0x54b0602,%eax
 26b:	01 06                	add    %eax,(%esi)
 26d:	3d 58 05 02 2d       	cmp    $0x2d020558,%eax
 272:	58                   	pop    %eax
 273:	05 01 06 00 05       	add    $0x5000601,%eax
 278:	02 7d 8c             	add    -0x74(%ebp),%bh
 27b:	00 00                	add    %al,(%eax)
 27d:	17                   	pop    %ss
 27e:	05 02 13 13 05       	add    $0x5131302,%eax
 283:	01 06                	add    %eax,(%esi)
 285:	10 05 02 68 05 01    	adc    %al,0x1056802
 28b:	08 21                	or     %ah,(%ecx)
 28d:	4a                   	dec    %edx
 28e:	06                   	push   %es
 28f:	25 05 02 13 13       	and    $0x13130205,%eax
 294:	05 01 06 10 05       	add    $0x5100601,%eax
 299:	02 68 05             	add    0x5(%eax),%ch
 29c:	01 08                	add    %ecx,(%eax)
 29e:	21 4a 06             	and    %ecx,0x6(%edx)
 2a1:	03 bd 7f 20 05 02    	add    0x205207f(%ebp),%edi
 2a7:	13 05 01 06 11 05    	adc    0x5110601,%eax
 2ad:	02 67 06             	add    0x6(%edi),%ah
 2b0:	c9                   	leave
 2b1:	05 01 06 9f 05       	add    $0x59f0601,%eax
 2b6:	02 1f                	add    (%edi),%bl
 2b8:	05 01 06 03 d1       	add    $0xd1030601,%eax
 2bd:	00 58 06             	add    %bl,0x6(%eax)
 2c0:	01 05 02 06 76 05    	add    %eax,0x5760602
 2c6:	01 03                	add    %eax,(%ebx)
 2c8:	75 01                	jne    2cb <PR_BOOTABLE+0x24b>
 2ca:	05 02 15 05 1e       	add    $0x1e051502,%eax
 2cf:	00 02                	add    %al,(%edx)
 2d1:	04 02                	add    $0x2,%al
 2d3:	01 04 02             	add    %eax,(%edx,%eax,1)
 2d6:	05 01 03 9c 7f       	add    $0x7f9c0301,%eax
 2db:	01 05 02 14 13 67    	add    %eax,0x67131402
 2e1:	06                   	push   %es
 2e2:	01 04 01             	add    %eax,(%ecx,%eax,1)
 2e5:	05 1e 00 02 04       	add    $0x402001e,%eax
 2ea:	02 03                	add    (%ebx),%al
 2ec:	e0 00                	loopne 2ee <PR_BOOTABLE+0x26e>
 2ee:	01 05 02 06 03 0a    	add    %eax,0xa030602
 2f4:	74 04                	je     2fa <PR_BOOTABLE+0x27a>
 2f6:	02 05 01 03 86 7f    	add    0x7f860301,%al
 2fc:	01 05 02 14 06 82    	add    %eax,0x82061402
 302:	04 01                	add    $0x1,%al
 304:	06                   	push   %es
 305:	03 f9                	add    %ecx,%edi
 307:	00 01                	add    %al,(%ecx)
 309:	04 02                	add    $0x2,%al
 30b:	05 01 03 85 7f       	add    $0x7f850301,%eax
 310:	01 05 02 14 06 82    	add    %eax,0x82061402
 316:	04 01                	add    $0x1,%al
 318:	06                   	push   %es
 319:	03 fa                	add    %edx,%edi
 31b:	00 01                	add    %al,(%ecx)
 31d:	04 02                	add    $0x2,%al
 31f:	05 01 03 84 7f       	add    $0x7f840301,%eax
 324:	01 05 02 14 04 01    	add    %eax,0x1041402
 32a:	05 16 06 03 fa       	add    $0xfa030616,%eax
 32f:	00 01                	add    %al,(%ecx)
 331:	04 02                	add    $0x2,%al
 333:	05 02 03 86 7f       	add    $0x7f860302,%eax
 338:	2e 04 01             	cs add $0x1,%al
 33b:	05 16 03 fa 00       	add    $0xfa0316,%eax
 340:	58                   	pop    %eax
 341:	04 02                	add    $0x2,%al
 343:	05 02 03 86 7f       	add    $0x7f860302,%eax
 348:	3c 20                	cmp    $0x20,%al
 34a:	04 01                	add    $0x1,%al
 34c:	06                   	push   %es
 34d:	03 fb                	add    %ebx,%edi
 34f:	00 01                	add    %al,(%ecx)
 351:	04 02                	add    $0x2,%al
 353:	05 01 03 83 7f       	add    $0x7f830301,%eax
 358:	01 05 02 14 04 01    	add    %eax,0x1041402
 35e:	05 16 06 03 fb       	add    $0xfb030616,%eax
 363:	00 01                	add    %al,(%ecx)
 365:	04 02                	add    $0x2,%al
 367:	05 02 03 85 7f       	add    $0x7f850302,%eax
 36c:	2e 04 01             	cs add $0x1,%al
 36f:	05 16 03 fb 00       	add    $0xfb0316,%eax
 374:	58                   	pop    %eax
 375:	04 02                	add    $0x2,%al
 377:	05 02 03 85 7f       	add    $0x7f850302,%eax
 37c:	3c 20                	cmp    $0x20,%al
 37e:	04 01                	add    $0x1,%al
 380:	06                   	push   %es
 381:	03 fc                	add    %esp,%edi
 383:	00 01                	add    %al,(%ecx)
 385:	04 02                	add    $0x2,%al
 387:	05 01 03 82 7f       	add    $0x7f820301,%eax
 38c:	01 05 02 14 04 01    	add    %eax,0x1041402
 392:	05 17 06 03 fc       	add    $0xfc030617,%eax
 397:	00 01                	add    %al,(%ecx)
 399:	04 02                	add    $0x2,%al
 39b:	05 02 03 84 7f       	add    $0x7f840302,%eax
 3a0:	2e 04 01             	cs add $0x1,%al
 3a3:	05 17 03 fc 00       	add    $0xfc0317,%eax
 3a8:	58                   	pop    %eax
 3a9:	05 1e 3c 04 02       	add    $0x2043c1e,%eax
 3ae:	05 02 03 84 7f       	add    $0x7f840302,%eax
 3b3:	3c 20                	cmp    $0x20,%al
 3b5:	04 01                	add    $0x1,%al
 3b7:	06                   	push   %es
 3b8:	03 fd                	add    %ebp,%edi
 3ba:	00 01                	add    %al,(%ecx)
 3bc:	04 02                	add    $0x2,%al
 3be:	05 01 03 81 7f       	add    $0x7f810301,%eax
 3c3:	01 05 02 14 06 82    	add    %eax,0x82061402
 3c9:	04 01                	add    $0x1,%al
 3cb:	06                   	push   %es
 3cc:	03 80 01 01 05 01    	add    0x1050101(%eax),%eax
 3d2:	03 6b 01             	add    0x1(%ebx),%ebp
 3d5:	05 02 15 04 02       	add    $0x2041502,%eax
 3da:	06                   	push   %es
 3db:	03 9f 7f 01 04 01    	add    0x104017f(%edi),%ebx
 3e1:	05 1e 00 02 04       	add    $0x402001e,%eax
 3e6:	02 06                	add    (%esi),%al
 3e8:	03 e1                	add    %ecx,%esp
 3ea:	00 58 04             	add    %bl,0x4(%eax)
 3ed:	02 05 01 03 9c 7f    	add    0x7f9c0301,%al
 3f3:	01 05 02 14 13 21    	add    %eax,0x21131402
 3f9:	06                   	push   %es
 3fa:	01 04 01             	add    %eax,(%ecx,%eax,1)
 3fd:	05 1e 00 02 04       	add    $0x402001e,%eax
 402:	02 03                	add    (%ebx),%al
 404:	e0 00                	loopne 406 <PR_BOOTABLE+0x386>
 406:	01 05 02 06 03 15    	add    %eax,0x15030602
 40c:	74 04                	je     412 <PR_BOOTABLE+0x392>
 40e:	02 05 01 03 8f 7f    	add    0x7f8f0301,%al
 414:	01 05 02 14 06 f2    	add    %eax,0xf2061402
 41a:	04 01                	add    $0x1,%al
 41c:	05 01 03 f0 00       	add    $0xf00301,%eax
 421:	01 06                	add    %eax,(%esi)
 423:	42                   	inc    %edx
 424:	05 02 13 14 05       	add    $0x5141302,%eax
 429:	01 06                	add    %eax,(%esi)
 42b:	0f 90 05 02 06 40 05 	seto   0x5400602
 432:	13 06                	adc    (%esi),%eax
 434:	17                   	pop    %ss
 435:	05 05 03 7a 3c       	add    $0x3c7a0305,%eax
 43a:	05 13 34 05 05       	add    $0x5053413,%eax
 43f:	39 05 09 69 05 05    	cmp    %eax,0x5056909
 445:	03 7a 3c             	add    0x3c(%edx),%edi
 448:	05 09 67 05 02       	add    $0x2056709,%eax
 44d:	06                   	push   %es
 44e:	3e 15 17 05 0c 01    	ds adc $0x10c0517,%eax
 454:	05 03 4c 05 09       	add    $0x9054c03,%eax
 459:	06                   	push   %es
 45a:	3e 05 03 1e 05 06    	ds add $0x6051e03,%eax
 460:	21 05 03 65 06 59    	and    %eax,0x59066503
 466:	13 05 09 06 01 05    	adc    0x5010609,%eax
 46c:	01 5a 4a             	add    %ebx,0x4a(%edx)
 46f:	20 20                	and    %ah,(%eax)
 471:	20 02                	and    %al,(%edx)
 473:	01 00                	add    %eax,(%eax)
 475:	01 01                	add    %eax,(%ecx)
 477:	9e                   	sahf
 478:	01 00                	add    %eax,(%eax)
 47a:	00 05 00 04 00 33    	add    %al,0x33000400
 480:	00 00                	add    %al,(%eax)
 482:	00 01                	add    %al,(%ecx)
 484:	01 01                	add    %eax,(%ecx)
 486:	fb                   	sti
 487:	0e                   	push   %cs
 488:	0d 00 01 01 01       	or     $0x1010100,%eax
 48d:	01 00                	add    %eax,(%eax)
 48f:	00 00                	add    %al,(%eax)
 491:	01 00                	add    %eax,(%eax)
 493:	00 01                	add    %al,(%ecx)
 495:	01 01                	add    %eax,(%ecx)
 497:	1f                   	pop    %ds
 498:	02 00                	add    (%eax),%al
 49a:	00 00                	add    %al,(%eax)
 49c:	00 37                	add    %dh,(%edi)
 49e:	00 00                	add    %al,(%eax)
 4a0:	00 02                	add    %al,(%edx)
 4a2:	01 1f                	add    %ebx,(%edi)
 4a4:	02 0f                	add    (%edi),%cl
 4a6:	03 76 00             	add    0x0(%esi),%esi
 4a9:	00 00                	add    %al,(%eax)
 4ab:	01 76 00             	add    %esi,0x0(%esi)
 4ae:	00 00                	add    %al,(%eax)
 4b0:	01 60 00             	add    %esp,0x0(%eax)
 4b3:	00 00                	add    %al,(%eax)
 4b5:	01 05 01 00 05 02    	add    %eax,0x2050001
 4bb:	91                   	xchg   %eax,%ecx
 4bc:	8d 00                	lea    (%eax),%eax
 4be:	00 03                	add    %al,(%ebx)
 4c0:	2f                   	das
 4c1:	01 05 02 14 14 05    	add    %eax,0x5141402
 4c7:	01 06                	add    %eax,(%esi)
 4c9:	0e                   	push   %cs
 4ca:	90                   	nop
 4cb:	05 02 40 06 08       	add    $0x8064002,%eax
 4d0:	23 05 05 06 01 05    	and    0x5010605,%eax
 4d6:	03 06                	add    (%esi),%eax
 4d8:	e5 05                	in     $0x5,%eax
 4da:	02 f5                	add    %ch,%dh
 4dc:	05 05 06 01 05       	add    $0x5010605,%eax
 4e1:	13 59 05             	adc    0x5(%ecx),%ebx
 4e4:	05 73 05 02 06       	add    $0x6020573,%eax
 4e9:	67 05 0b 06 01 05    	addr16 add $0x501060b,%eax
 4ef:	06                   	push   %es
 4f0:	3c 05                	cmp    $0x5,%al
 4f2:	02 06                	add    (%esi),%al
 4f4:	30 05 0c 00 02 04    	xor    %al,0x402000c
 4fa:	01 01                	add    %eax,(%ecx)
 4fc:	05 03 4c 05 15       	add    $0x15054c03,%eax
 501:	00 02                	add    %al,(%edx)
 503:	04 02                	add    $0x2,%al
 505:	06                   	push   %es
 506:	1e                   	push   %ds
 507:	05 03 3e 05 15       	add    $0x15053e03,%eax
 50c:	00 02                	add    %al,(%edx)
 50e:	04 02                	add    $0x2,%al
 510:	06                   	push   %es
 511:	d4 00                	aam    $0x0
 513:	02 04 02             	add    (%edx,%eax,1),%al
 516:	06                   	push   %es
 517:	01 05 02 06 5d 05    	add    %eax,0x55d0602
 51d:	1a 06                	sbb    (%esi),%al
 51f:	01 05 01 59 4a 05    	add    %eax,0x54a5901
 525:	1a 1f                	sbb    (%edi),%bl
 527:	05 01 59 06 40       	add    $0x40065901,%eax
 52c:	05 02 13 13 13       	add    $0x13131302,%eax
 531:	05 01 06 0f 58       	add    $0x580f0601,%eax
 536:	05 02 06 40 13       	add    $0x13400602,%eax
 53b:	05 0b 06 11 05       	add    $0x511060b,%eax
 540:	02 2f                	add    (%edi),%ch
 542:	06                   	push   %es
 543:	c9                   	leave
 544:	05 08 06 01 05       	add    $0x5010608,%eax
 549:	2d 06 3c 05 0a       	sub    $0xa053c06,%eax
 54e:	06                   	push   %es
 54f:	01 05 2d 4a 05 03    	add    %eax,0x3054a2d
 555:	06                   	push   %es
 556:	76 05                	jbe    55d <PR_BOOTABLE+0x4dd>
 558:	0c 06                	or     $0x6,%al
 55a:	3e 05 03 3a 06 67    	ds add $0x67063a03,%eax
 560:	13 05 0c 06 01 05    	adc    0x501060c,%eax
 566:	2d 54 05 1b 00       	sub    $0x1b0554,%eax
 56b:	02 04 01             	add    (%ecx,%eax,1),%al
 56e:	4a                   	dec    %edx
 56f:	05 2d 00 02 04       	add    $0x402002d,%eax
 574:	02 d6                	add    %dh,%dl
 576:	05 02 06 7a 05       	add    $0x57a0602,%eax
 57b:	19 06                	sbb    %eax,(%esi)
 57d:	01 05 02 06 67 05    	add    %eax,0x5670602
 583:	01 06                	add    %eax,(%esi)
 585:	14 05                	adc    $0x5,%al
 587:	17                   	pop    %ss
 588:	56                   	push   %esi
 589:	05 02 06 67 05       	add    $0x5670602,%eax
 58e:	01 06                	add    %eax,(%esi)
 590:	13 4a 20             	adc    0x20(%edx),%ecx
 593:	06                   	push   %es
 594:	03 b6 7f 2e 05 02    	add    0x2052e7f(%esi),%esi
 59a:	13 05 01 06 11 58    	adc    0x58110601,%eax
 5a0:	05 02 67 05 0b       	add    $0xb056702,%eax
 5a5:	00 02                	add    %al,(%edx)
 5a7:	04 01                	add    $0x1,%al
 5a9:	06                   	push   %es
 5aa:	9e                   	sahf
 5ab:	05 02 bd 13 13       	add    $0x1313bd02,%eax
 5b0:	05 10 00 02 04       	add    $0x4020010,%eax
 5b5:	01 01                	add    %eax,(%ecx)
 5b7:	05 0b 00 02 04       	add    $0x402000b,%eax
 5bc:	01 06                	add    %eax,(%esi)
 5be:	0d 05 09 41 05       	or     $0x5410905,%eax
 5c3:	03 06                	add    (%esi),%eax
 5c5:	30 05 19 06 01 05    	xor    %al,0x5010619
 5cb:	06                   	push   %es
 5cc:	58                   	pop    %eax
 5cd:	05 04 06 a0 05       	add    $0x5a00604,%eax
 5d2:	11 06                	adc    %eax,(%esi)
 5d4:	01 05 04 06 75 05    	add    %eax,0x5750604
 5da:	02 16                	add    (%esi),%dl
 5dc:	05 16 00 02 04       	add    $0x4020016,%eax
 5e1:	02 03                	add    (%ebx),%al
 5e3:	77 2e                	ja     613 <PR_BOOTABLE+0x593>
 5e5:	05 10 00 02 04       	add    $0x4020010,%eax
 5ea:	01 20                	add    %esp,(%eax)
 5ec:	05 02 03 09 58       	add    $0x58090302,%eax
 5f1:	05 03 13 06 e4       	add    $0xe4061303,%eax
 5f6:	05 02 06 3e 92       	add    $0x923e0602,%eax
 5fb:	bb 05 13 06 01       	mov    $0x1061305,%ebx
 600:	05 02 84 05 13       	add    $0x13058402,%eax
 605:	72 05                	jb     60c <PR_BOOTABLE+0x58c>
 607:	02 06                	add    (%esi),%al
 609:	30 5a ca             	xor    %bl,-0x36(%edx)
 60c:	05 01 06 a0 4a       	add    $0x4aa00601,%eax
 611:	05 02 2c 02 05       	add    $0x5022c02,%eax
 616:	00 01                	add    %al,(%ecx)
 618:	01 47 00             	add    %eax,0x0(%edi)
 61b:	00 00                	add    %al,(%eax)
 61d:	05 00 04 00 2e       	add    $0x2e000400,%eax
 622:	00 00                	add    %al,(%eax)
 624:	00 01                	add    %al,(%ecx)
 626:	01 01                	add    %eax,(%ecx)
 628:	fb                   	sti
 629:	0e                   	push   %cs
 62a:	0d 00 01 01 01       	or     $0x1010100,%eax
 62f:	01 00                	add    %eax,(%eax)
 631:	00 00                	add    %al,(%eax)
 633:	01 00                	add    %eax,(%eax)
 635:	00 01                	add    %al,(%ecx)
 637:	01 01                	add    %eax,(%ecx)
 639:	1f                   	pop    %ds
 63a:	02 00                	add    (%eax),%al
 63c:	00 00                	add    %al,(%eax)
 63e:	00 37                	add    %dh,(%edi)
 640:	00 00                	add    %al,(%eax)
 642:	00 02                	add    %al,(%edx)
 644:	01 1f                	add    %ebx,(%edi)
 646:	02 0f                	add    (%edi),%cl
 648:	02 82 00 00 00 01    	add    0x1000000(%edx),%al
 64e:	82 00 00             	addb   $0x0,(%eax)
 651:	00 01                	add    %al,(%ecx)
 653:	00 05 02 1c 8f 00    	add    %al,0x8f1c02
 659:	00 17                	add    %dl,(%edi)
 65b:	21 59 4b             	and    %ebx,0x4b(%ecx)
 65e:	4b                   	dec    %ebx
 65f:	02 02                	add    (%edx),%al
 661:	00 01                	add    %al,(%ecx)
 663:	01                   	.byte 0x1

Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	10 00                	adc    %al,(%eax)
   2:	00 00                	add    %al,(%eax)
   4:	ff                   	(bad)
   5:	ff                   	(bad)
   6:	ff                   	(bad)
   7:	ff 01                	incl   (%ecx)
   9:	00 01                	add    %al,(%ecx)
   b:	7c 08                	jl     15 <PROT_MODE_DSEG+0x5>
   d:	0c 04                	or     $0x4,%al
   f:	04 88                	add    $0x88,%al
  11:	01 00                	add    %eax,(%eax)
  13:	00 1c 00             	add    %bl,(%eax,%eax,1)
  16:	00 00                	add    %al,(%eax)
  18:	00 00                	add    %al,(%eax)
  1a:	00 00                	add    %al,(%eax)
  1c:	26 8b 00             	mov    %es:(%eax),%eax
  1f:	00 1b                	add    %bl,(%ebx)
  21:	00 00                	add    %al,(%eax)
  23:	00 41 0e             	add    %al,0xe(%ecx)
  26:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  2c:	57                   	push   %edi
  2d:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  30:	04 00                	add    $0x0,%al
  32:	00 00                	add    %al,(%eax)
  34:	20 00                	and    %al,(%eax)
  36:	00 00                	add    %al,(%eax)
  38:	00 00                	add    %al,(%eax)
  3a:	00 00                	add    %al,(%eax)
  3c:	41                   	inc    %ecx
  3d:	8b 00                	mov    (%eax),%eax
  3f:	00 33                	add    %dh,(%ebx)
  41:	00 00                	add    %al,(%eax)
  43:	00 41 0e             	add    %al,0xe(%ecx)
  46:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  4c:	42                   	inc    %edx
  4d:	83 03 6d             	addl   $0x6d,(%ebx)
  50:	c5 c3 0c             	(bad)
  53:	04 04                	add    $0x4,%al
  55:	00 00                	add    %al,(%eax)
  57:	00 20                	add    %ah,(%eax)
  59:	00 00                	add    %al,(%eax)
  5b:	00 00                	add    %al,(%eax)
  5d:	00 00                	add    %al,(%eax)
  5f:	00 74 8b 00          	add    %dh,0x0(%ebx,%ecx,4)
  63:	00 43 00             	add    %al,0x0(%ebx)
  66:	00 00                	add    %al,(%eax)
  68:	41                   	inc    %ecx
  69:	0e                   	push   %cs
  6a:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  70:	42                   	inc    %edx
  71:	83 03 7d             	addl   $0x7d,(%ebx)
  74:	c5 c3 0c             	(bad)
  77:	04 04                	add    $0x4,%al
  79:	00 00                	add    %al,(%eax)
  7b:	00 1c 00             	add    %bl,(%eax,%eax,1)
  7e:	00 00                	add    %al,(%eax)
  80:	00 00                	add    %al,(%eax)
  82:	00 00                	add    %al,(%eax)
  84:	b7 8b                	mov    $0x8b,%bh
  86:	00 00                	add    %al,(%eax)
  88:	0d 00 00 00 41       	or     $0x41000000,%eax
  8d:	0e                   	push   %cs
  8e:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  94:	44                   	inc    %esp
  95:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  98:	04 00                	add    $0x0,%al
  9a:	00 00                	add    %al,(%eax)
  9c:	14 00                	adc    $0x0,%al
  9e:	00 00                	add    %al,(%eax)
  a0:	00 00                	add    %al,(%eax)
  a2:	00 00                	add    %al,(%eax)
  a4:	c4 8b 00 00 1a 00    	les    0x1a0000(%ebx),%ecx
  aa:	00 00                	add    %al,(%eax)
  ac:	41                   	inc    %ecx
  ad:	0e                   	push   %cs
  ae:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  b4:	1c 00                	sbb    $0x0,%al
  b6:	00 00                	add    %al,(%eax)
  b8:	00 00                	add    %al,(%eax)
  ba:	00 00                	add    %al,(%eax)
  bc:	de 8b 00 00 13 00    	fimuls 0x130000(%ebx)
  c2:	00 00                	add    %al,(%eax)
  c4:	41                   	inc    %ecx
  c5:	0e                   	push   %cs
  c6:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
  cc:	4d                   	dec    %ebp
  cd:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
  d0:	04 00                	add    $0x0,%al
  d2:	00 00                	add    %al,(%eax)
  d4:	24 00                	and    $0x0,%al
  d6:	00 00                	add    %al,(%eax)
  d8:	00 00                	add    %al,(%eax)
  da:	00 00                	add    %al,(%eax)
  dc:	f1                   	int1
  dd:	8b 00                	mov    (%eax),%eax
  df:	00 35 00 00 00 41    	add    %dh,0x41000000
  e5:	0e                   	push   %cs
  e6:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
  ec:	42                   	inc    %edx
  ed:	86 03                	xchg   %al,(%ebx)
  ef:	83 04 6d c3 41 c6 41 	addl   $0xffffffc5,0x41c641c3(,%ebp,2)
  f6:	c5 
  f7:	0c 04                	or     $0x4,%al
  f9:	04 00                	add    $0x0,%al
  fb:	00 28                	add    %ch,(%eax)
  fd:	00 00                	add    %al,(%eax)
  ff:	00 00                	add    %al,(%eax)
 101:	00 00                	add    %al,(%eax)
 103:	00 26                	add    %ah,(%esi)
 105:	8c 00                	mov    %es,(%eax)
 107:	00 57 00             	add    %dl,0x0(%edi)
 10a:	00 00                	add    %al,(%eax)
 10c:	41                   	inc    %ecx
 10d:	0e                   	push   %cs
 10e:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 114:	46                   	inc    %esi
 115:	87 03                	xchg   %eax,(%ebx)
 117:	86 04 83             	xchg   %al,(%ebx,%eax,4)
 11a:	05 02 46 c3 41       	add    $0x41c34602,%eax
 11f:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
 123:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 126:	04 00                	add    $0x0,%al
 128:	1c 00                	sbb    $0x0,%al
 12a:	00 00                	add    %al,(%eax)
 12c:	00 00                	add    %al,(%eax)
 12e:	00 00                	add    %al,(%eax)
 130:	7d 8c                	jge    be <PR_BOOTABLE+0x3e>
 132:	00 00                	add    %al,(%eax)
 134:	1d 00 00 00 41       	sbb    $0x41000000,%eax
 139:	0e                   	push   %cs
 13a:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 140:	59                   	pop    %ecx
 141:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 144:	04 00                	add    $0x0,%al
 146:	00 00                	add    %al,(%eax)
 148:	1c 00                	sbb    $0x0,%al
 14a:	00 00                	add    %al,(%eax)
 14c:	00 00                	add    %al,(%eax)
 14e:	00 00                	add    %al,(%eax)
 150:	9a 8c 00 00 1d 00 00 	lcall  $0x0,$0x1d00008c
 157:	00 41 0e             	add    %al,0xe(%ecx)
 15a:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 160:	59                   	pop    %ecx
 161:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 164:	04 00                	add    $0x0,%al
 166:	00 00                	add    %al,(%eax)
 168:	1c 00                	sbb    $0x0,%al
 16a:	00 00                	add    %al,(%eax)
 16c:	00 00                	add    %al,(%eax)
 16e:	00 00                	add    %al,(%eax)
 170:	b7 8c                	mov    $0x8c,%bh
 172:	00 00                	add    %al,(%eax)
 174:	23 00                	and    (%eax),%eax
 176:	00 00                	add    %al,(%eax)
 178:	41                   	inc    %ecx
 179:	0e                   	push   %cs
 17a:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 180:	5b                   	pop    %ebx
 181:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 184:	04 00                	add    $0x0,%al
 186:	00 00                	add    %al,(%eax)
 188:	20 00                	and    %al,(%eax)
 18a:	00 00                	add    %al,(%eax)
 18c:	00 00                	add    %al,(%eax)
 18e:	00 00                	add    %al,(%eax)
 190:	da 8c 00 00 70 00 00 	fimull 0x7000(%eax,%eax,1)
 197:	00 41 0e             	add    %al,0xe(%ecx)
 19a:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 1a0:	41                   	inc    %ecx
 1a1:	87 03                	xchg   %eax,(%ebx)
 1a3:	02 6a c7             	add    -0x39(%edx),%ch
 1a6:	41                   	inc    %ecx
 1a7:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 1aa:	04 00                	add    $0x0,%al
 1ac:	28 00                	sub    %al,(%eax)
 1ae:	00 00                	add    %al,(%eax)
 1b0:	00 00                	add    %al,(%eax)
 1b2:	00 00                	add    %al,(%eax)
 1b4:	4a                   	dec    %edx
 1b5:	8d 00                	lea    (%eax),%eax
 1b7:	00 47 00             	add    %al,0x0(%edi)
 1ba:	00 00                	add    %al,(%eax)
 1bc:	41                   	inc    %ecx
 1bd:	0e                   	push   %cs
 1be:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 1c4:	46                   	inc    %esi
 1c5:	87 03                	xchg   %eax,(%ebx)
 1c7:	86 04 83             	xchg   %al,(%ebx,%eax,4)
 1ca:	05 7a c3 41 c6       	add    $0xc641c37a,%eax
 1cf:	41                   	inc    %ecx
 1d0:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
 1d7:	00 10                	add    %dl,(%eax)
 1d9:	00 00                	add    %al,(%eax)
 1db:	00 ff                	add    %bh,%bh
 1dd:	ff                   	(bad)
 1de:	ff                   	(bad)
 1df:	ff 01                	incl   (%ecx)
 1e1:	00 01                	add    %al,(%ecx)
 1e3:	7c 08                	jl     1ed <PR_BOOTABLE+0x16d>
 1e5:	0c 04                	or     $0x4,%al
 1e7:	04 88                	add    $0x88,%al
 1e9:	01 00                	add    %eax,(%eax)
 1eb:	00 28                	add    %ch,(%eax)
 1ed:	00 00                	add    %al,(%eax)
 1ef:	00 d8                	add    %bl,%al
 1f1:	01 00                	add    %eax,(%eax)
 1f3:	00 91 8d 00 00 81    	add    %dl,-0x7effff73(%ecx)
 1f9:	00 00                	add    %al,(%eax)
 1fb:	00 41 0e             	add    %al,0xe(%ecx)
 1fe:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 204:	46                   	inc    %esi
 205:	87 03                	xchg   %eax,(%ebx)
 207:	86 04 83             	xchg   %al,(%ebx,%eax,4)
 20a:	05 02 6f c3 41       	add    $0x41c36f02,%eax
 20f:	c6 46 c7 41          	movb   $0x41,-0x39(%esi)
 213:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 216:	04 00                	add    $0x0,%al
 218:	24 00                	and    $0x0,%al
 21a:	00 00                	add    %al,(%eax)
 21c:	d8 01                	fadds  (%ecx)
 21e:	00 00                	add    %al,(%eax)
 220:	12 8e 00 00 67 00    	adc    0x670000(%esi),%cl
 226:	00 00                	add    %al,(%eax)
 228:	41                   	inc    %ecx
 229:	0e                   	push   %cs
 22a:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 230:	42                   	inc    %edx
 231:	86 03                	xchg   %al,(%ebx)
 233:	83 04 02 5f          	addl   $0x5f,(%edx,%eax,1)
 237:	c3                   	ret
 238:	41                   	inc    %ecx
 239:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
 23d:	04 04                	add    $0x4,%al
 23f:	00 24 00             	add    %ah,(%eax,%eax,1)
 242:	00 00                	add    %al,(%eax)
 244:	d8 01                	fadds  (%ecx)
 246:	00 00                	add    %al,(%eax)
 248:	79 8e                	jns    1d8 <PR_BOOTABLE+0x158>
 24a:	00 00                	add    %al,(%eax)
 24c:	a3 00 00 00 41       	mov    %eax,0x41000000
 251:	0e                   	push   %cs
 252:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 258:	42                   	inc    %edx
 259:	86 03                	xchg   %al,(%ebx)
 25b:	83 04 02 97          	addl   $0xffffff97,(%edx,%eax,1)
 25f:	c3                   	ret
 260:	41                   	inc    %ecx
 261:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
 265:	04 04                	add    $0x4,%al
 267:	00                   	.byte 0

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   3:	74 2f                	je     34 <PROT_MODE_DSEG+0x24>
   5:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   8:	74 31                	je     3b <PROT_MODE_DSEG+0x2b>
   a:	2f                   	das
   b:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   e:	74 31                	je     41 <PROT_MODE_DSEG+0x31>
  10:	2e 53                	cs push %ebx
  12:	00 2f                	add    %ch,(%edi)
  14:	55                   	push   %ebp
  15:	73 65                	jae    7c <PROT_MODE_DSEG+0x6c>
  17:	72 73                	jb     8c <PR_BOOTABLE+0xc>
  19:	2f                   	das
  1a:	70 72                	jo     8e <PR_BOOTABLE+0xe>
  1c:	69 6e 63 65 66 61 68 	imul   $0x68616665,0x63(%esi),%ebp
  23:	69 6d 61 6c 2d 61 72 	imul   $0x72612d6c,0x61(%ebp),%ebp
  2a:	61                   	popa
  2b:	66 2f                	data16 das
  2d:	44                   	inc    %esp
  2e:	65 73 6b             	gs jae 9c <PR_BOOTABLE+0x1c>
  31:	74 6f                	je     a2 <PR_BOOTABLE+0x22>
  33:	70 2f                	jo     64 <PROT_MODE_DSEG+0x54>
  35:	6d                   	insl   (%dx),%es:(%edi)
  36:	63 65 72             	arpl   %esp,0x72(%ebp)
  39:	74 69                	je     a4 <PR_BOOTABLE+0x24>
  3b:	6b 6f 73 2f          	imul   $0x2f,0x73(%edi),%ebp
  3f:	55                   	push   %ebp
  40:	6e                   	outsb  %ds:(%esi),(%dx)
  41:	69 78 5f 53 68 65 6c 	imul   $0x6c656853,0x5f(%eax),%edi
  48:	6c                   	insb   (%dx),%es:(%edi)
  49:	00 47 4e             	add    %al,0x4e(%edi)
  4c:	55                   	push   %ebp
  4d:	20 41 53             	and    %al,0x53(%ecx)
  50:	20 32                	and    %dh,(%edx)
  52:	2e 34 36             	cs xor $0x36,%al
  55:	2e 30 00             	xor    %al,%cs:(%eax)
  58:	65 6e                	outsb  %gs:(%esi),(%dx)
  5a:	64 5f                	fs pop %edi
  5c:	76 61                	jbe    bf <PR_BOOTABLE+0x3f>
  5e:	00 77 61             	add    %dh,0x61(%edi)
  61:	69 74 64 69 73 6b 00 	imul   $0x70006b73,0x69(%esp,%eiz,2),%esi
  68:	70 
  69:	75 74                	jne    df <PR_BOOTABLE+0x5f>
  6b:	6c                   	insb   (%dx),%es:(%edi)
  6c:	69 6e 65 00 73 68 6f 	imul   $0x6f687300,0x65(%esi),%ebp
  73:	72 74                	jb     e9 <PR_BOOTABLE+0x69>
  75:	20 69 6e             	and    %ch,0x6e(%ecx)
  78:	74 00                	je     7a <PROT_MODE_DSEG+0x6a>
  7a:	63 6f 6c             	arpl   %ebp,0x6c(%edi)
  7d:	6f                   	outsl  %ds:(%esi),(%dx)
  7e:	72 00                	jb     80 <PR_BOOTABLE>
  80:	72 6f                	jb     f1 <PR_BOOTABLE+0x71>
  82:	6c                   	insb   (%dx),%es:(%edi)
  83:	6c                   	insb   (%dx),%es:(%edi)
  84:	00 73 74             	add    %dh,0x74(%ebx)
  87:	72 69                	jb     f2 <PR_BOOTABLE+0x72>
  89:	6e                   	outsb  %ds:(%esi),(%dx)
  8a:	67 00 70 61          	add    %dh,0x61(%bx,%si)
  8e:	6e                   	outsb  %ds:(%esi),(%dx)
  8f:	69 63 00 70 75 74 69 	imul   $0x69747570,0x0(%ebx),%esp
  96:	00 72 65             	add    %dh,0x65(%edx)
  99:	61                   	popa
  9a:	64 73 65             	fs jae 102 <PR_BOOTABLE+0x82>
  9d:	63 74 6f 72          	arpl   %esi,0x72(%edi,%ebp,2)
  a1:	00 75 69             	add    %dh,0x69(%ebp)
  a4:	6e                   	outsb  %ds:(%esi),(%dx)
  a5:	74 38                	je     df <PR_BOOTABLE+0x5f>
  a7:	5f                   	pop    %edi
  a8:	74 00                	je     aa <PR_BOOTABLE+0x2a>
  aa:	6f                   	outsl  %ds:(%esi),(%dx)
  ab:	75 74                	jne    121 <PR_BOOTABLE+0xa1>
  ad:	62 00                	bound  %eax,(%eax)
  af:	69 6e 73 6c 00 6c 6f 	imul   $0x6f6c006c,0x73(%esi),%ebp
  b6:	6e                   	outsb  %ds:(%esi),(%dx)
  b7:	67 20 6c 6f          	and    %ch,0x6f(%si)
  bb:	6e                   	outsb  %ds:(%esi),(%dx)
  bc:	67 20 69 6e          	and    %ch,0x6e(%bx,%di)
  c0:	74 00                	je     c2 <PR_BOOTABLE+0x42>
  c2:	47                   	inc    %edi
  c3:	4e                   	dec    %esi
  c4:	55                   	push   %ebp
  c5:	20 43 38             	and    %al,0x38(%ebx)
  c8:	39 20                	cmp    %esp,(%eax)
  ca:	31 35 2e 32 2e 30    	xor    %esi,0x302e322e
  d0:	20 2d 6d 33 32 20    	and    %ch,0x2032336d
  d6:	2d 6d 74 75 6e       	sub    $0x6e75746d,%eax
  db:	65 3d 67 65 6e 65    	gs cmp $0x656e6567,%eax
  e1:	72 69                	jb     14c <PR_BOOTABLE+0xcc>
  e3:	63 20                	arpl   %esp,(%eax)
  e5:	2d 6d 61 72 63       	sub    $0x6372616d,%eax
  ea:	68 3d 70 65 6e       	push   $0x6e65703d
  ef:	74 69                	je     15a <PR_BOOTABLE+0xda>
  f1:	75 6d                	jne    160 <PR_BOOTABLE+0xe0>
  f3:	70 72                	jo     167 <PR_BOOTABLE+0xe7>
  f5:	6f                   	outsl  %ds:(%esi),(%dx)
  f6:	20 2d 67 20 2d 4f    	and    %ch,0x4f2d2067
  fc:	73 20                	jae    11e <PR_BOOTABLE+0x9e>
  fe:	2d 4f 73 20 2d       	sub    $0x2d20734f,%eax
 103:	73 74                	jae    179 <PR_BOOTABLE+0xf9>
 105:	64 3d 67 6e 75 39    	fs cmp $0x39756e67,%eax
 10b:	30 20                	xor    %ah,(%eax)
 10d:	2d 66 6e 6f 2d       	sub    $0x2d6f6e66,%eax
 112:	62 75 69             	bound  %esi,0x69(%ebp)
 115:	6c                   	insb   (%dx),%es:(%edi)
 116:	74 69                	je     181 <PR_BOOTABLE+0x101>
 118:	6e                   	outsb  %ds:(%esi),(%dx)
 119:	20 2d 66 6e 6f 2d    	and    %ch,0x2d6f6e66
 11f:	73 74                	jae    195 <PR_BOOTABLE+0x115>
 121:	61                   	popa
 122:	63 6b 2d             	arpl   %ebp,0x2d(%ebx)
 125:	70 72                	jo     199 <PR_BOOTABLE+0x119>
 127:	6f                   	outsl  %ds:(%esi),(%dx)
 128:	74 65                	je     18f <PR_BOOTABLE+0x10f>
 12a:	63 74 6f 72          	arpl   %esi,0x72(%edi,%ebp,2)
 12e:	00 72 65             	add    %dh,0x65(%edx)
 131:	61                   	popa
 132:	64 73 65             	fs jae 19a <PR_BOOTABLE+0x11a>
 135:	63 74 69 6f          	arpl   %esi,0x6f(%ecx,%ebp,2)
 139:	6e                   	outsb  %ds:(%esi),(%dx)
 13a:	00 69 74             	add    %ch,0x74(%ecx)
 13d:	6f                   	outsl  %ds:(%esi),(%dx)
 13e:	61                   	popa
 13f:	00 75 6e             	add    %dh,0x6e(%ebp)
 142:	73 69                	jae    1ad <PR_BOOTABLE+0x12d>
 144:	67 6e                	outsb  %ds:(%si),(%dx)
 146:	65 64 20 63 68       	gs and %ah,%fs:0x68(%ebx)
 14b:	61                   	popa
 14c:	72 00                	jb     14e <PR_BOOTABLE+0xce>
 14e:	69 74 6f 68 00 70 75 	imul   $0x74757000,0x68(%edi,%ebp,2),%esi
 155:	74 
 156:	63 00                	arpl   %eax,(%eax)
 158:	6c                   	insb   (%dx),%es:(%edi)
 159:	6f                   	outsl  %ds:(%esi),(%dx)
 15a:	6e                   	outsb  %ds:(%esi),(%dx)
 15b:	67 20 6c 6f          	and    %ch,0x6f(%si)
 15f:	6e                   	outsb  %ds:(%esi),(%dx)
 160:	67 20 75 6e          	and    %dh,0x6e(%di)
 164:	73 69                	jae    1cf <PR_BOOTABLE+0x14f>
 166:	67 6e                	outsb  %ds:(%si),(%dx)
 168:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%ecx)
 16d:	74 00                	je     16f <PR_BOOTABLE+0xef>
 16f:	75 69                	jne    1da <PR_BOOTABLE+0x15a>
 171:	6e                   	outsb  %ds:(%esi),(%dx)
 172:	74 33                	je     1a7 <PR_BOOTABLE+0x127>
 174:	32 5f 74             	xor    0x74(%edi),%bl
 177:	00 69 74             	add    %ch,0x74(%ecx)
 17a:	6f                   	outsl  %ds:(%esi),(%dx)
 17b:	78 00                	js     17d <PR_BOOTABLE+0xfd>
 17d:	70 75                	jo     1f4 <PR_BOOTABLE+0x174>
 17f:	74 73                	je     1f4 <PR_BOOTABLE+0x174>
 181:	00 73 68             	add    %dh,0x68(%ebx)
 184:	6f                   	outsl  %ds:(%esi),(%dx)
 185:	72 74                	jb     1fb <PR_BOOTABLE+0x17b>
 187:	20 75 6e             	and    %dh,0x6e(%ebp)
 18a:	73 69                	jae    1f5 <PR_BOOTABLE+0x175>
 18c:	67 6e                	outsb  %ds:(%si),(%dx)
 18e:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%ecx)
 193:	74 00                	je     195 <PR_BOOTABLE+0x115>
 195:	73 74                	jae    20b <PR_BOOTABLE+0x18b>
 197:	72 6c                	jb     205 <PR_BOOTABLE+0x185>
 199:	65 6e                	outsb  %gs:(%esi),(%dx)
 19b:	00 64 61 74          	add    %ah,0x74(%ecx,%eiz,2)
 19f:	61                   	popa
 1a0:	00 70 6f             	add    %dh,0x6f(%eax)
 1a3:	72 74                	jb     219 <PR_BOOTABLE+0x199>
 1a5:	00 73 69             	add    %dh,0x69(%ebx)
 1a8:	67 6e                	outsb  %ds:(%si),(%dx)
 1aa:	00 72 65             	add    %dh,0x65(%edx)
 1ad:	76 65                	jbe    214 <PR_BOOTABLE+0x194>
 1af:	72 73                	jb     224 <PR_BOOTABLE+0x1a4>
 1b1:	65 00 70 75          	add    %dh,%gs:0x75(%eax)
 1b5:	74 69                	je     220 <PR_BOOTABLE+0x1a0>
 1b7:	5f                   	pop    %edi
 1b8:	73 74                	jae    22e <PR_BOOTABLE+0x1ae>
 1ba:	72 00                	jb     1bc <PR_BOOTABLE+0x13c>
 1bc:	62 6c 61 6e          	bound  %ebp,0x6e(%ecx,%eiz,2)
 1c0:	6b 00 72             	imul   $0x72,(%eax),%eax
 1c3:	6f                   	outsl  %ds:(%esi),(%dx)
 1c4:	6f                   	outsl  %ds:(%esi),(%dx)
 1c5:	74 00                	je     1c7 <PR_BOOTABLE+0x147>
 1c7:	76 69                	jbe    232 <PR_BOOTABLE+0x1b2>
 1c9:	64 65 6f             	fs outsl %gs:(%esi),(%dx)
 1cc:	00 64 69 73          	add    %ah,0x73(%ecx,%ebp,2)
 1d0:	6b 5f 73 69          	imul   $0x69,0x73(%edi),%ebx
 1d4:	67 00 65 6c          	add    %ah,0x6c(%di)
 1d8:	66 68 64 66          	pushw  $0x6664
 1dc:	00 65 5f             	add    %ah,0x5f(%ebp)
 1df:	73 68                	jae    249 <PR_BOOTABLE+0x1c9>
 1e1:	73 74                	jae    257 <PR_BOOTABLE+0x1d7>
 1e3:	72 6e                	jb     253 <PR_BOOTABLE+0x1d3>
 1e5:	64 78 00             	fs js  1e8 <PR_BOOTABLE+0x168>
 1e8:	6d                   	insl   (%dx),%es:(%edi)
 1e9:	6d                   	insl   (%dx),%es:(%edi)
 1ea:	61                   	popa
 1eb:	70 5f                	jo     24c <PR_BOOTABLE+0x1cc>
 1ed:	61                   	popa
 1ee:	64 64 72 00          	fs fs jb 1f2 <PR_BOOTABLE+0x172>
 1f2:	65 6c                	gs insb (%dx),%es:(%edi)
 1f4:	66 68 64 72          	pushw  $0x7264
 1f8:	00 76 62             	add    %dh,0x62(%esi)
 1fb:	65 5f                	gs pop %edi
 1fd:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 204:	63 65 5f             	arpl   %esp,0x5f(%ebp)
 207:	6f                   	outsl  %ds:(%esi),(%dx)
 208:	66 66 00 65 5f       	data16 data16 add %ah,0x5f(%ebp)
 20d:	65 6e                	outsb  %gs:(%esi),(%dx)
 20f:	74 72                	je     283 <PR_BOOTABLE+0x203>
 211:	79 00                	jns    213 <PR_BOOTABLE+0x193>
 213:	75 69                	jne    27e <PR_BOOTABLE+0x1fe>
 215:	6e                   	outsb  %ds:(%esi),(%dx)
 216:	74 36                	je     24e <PR_BOOTABLE+0x1ce>
 218:	34 5f                	xor    $0x5f,%al
 21a:	74 00                	je     21c <PR_BOOTABLE+0x19c>
 21c:	6c                   	insb   (%dx),%es:(%edi)
 21d:	6f                   	outsl  %ds:(%esi),(%dx)
 21e:	61                   	popa
 21f:	64 5f                	fs pop %edi
 221:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
 225:	65 6c                	gs insb (%dx),%es:(%edi)
 227:	00 70 5f             	add    %dh,0x5f(%eax)
 22a:	6d                   	insl   (%dx),%es:(%edi)
 22b:	65 6d                	gs insl (%dx),%es:(%edi)
 22d:	73 7a                	jae    2a9 <PR_BOOTABLE+0x229>
 22f:	00 70 5f             	add    %dh,0x5f(%eax)
 232:	6f                   	outsl  %ds:(%esi),(%dx)
 233:	66 66 73 65          	data16 data16 jae 29c <PR_BOOTABLE+0x21c>
 237:	74 00                	je     239 <PR_BOOTABLE+0x1b9>
 239:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 23c:	74 6c                	je     2aa <PR_BOOTABLE+0x22a>
 23e:	6f                   	outsl  %ds:(%esi),(%dx)
 23f:	61                   	popa
 240:	64 65 72 00          	fs gs jb 244 <PR_BOOTABLE+0x1c4>
 244:	65 5f                	gs pop %edi
 246:	66 6c                	data16 insb (%dx),%es:(%edi)
 248:	61                   	popa
 249:	67 73 00             	addr16 jae 24c <PR_BOOTABLE+0x1cc>
 24c:	63 6d 64             	arpl   %ebp,0x64(%ebp)
 24f:	6c                   	insb   (%dx),%es:(%edi)
 250:	69 6e 65 00 65 5f 6d 	imul   $0x6d5f6500,0x65(%esi),%ebp
 257:	61                   	popa
 258:	63 68 69             	arpl   %ebp,0x69(%eax)
 25b:	6e                   	outsb  %ds:(%esi),(%dx)
 25c:	65 00 65 5f          	add    %ah,%gs:0x5f(%ebp)
 260:	70 68                	jo     2ca <PR_BOOTABLE+0x24a>
 262:	65 6e                	outsb  %gs:(%esi),(%dx)
 264:	74 73                	je     2d9 <PR_BOOTABLE+0x259>
 266:	69 7a 65 00 65 78 65 	imul   $0x65786500,0x65(%edx),%edi
 26d:	63 5f 6b             	arpl   %ebx,0x6b(%edi)
 270:	65 72 6e             	gs jb  2e1 <PR_BOOTABLE+0x261>
 273:	65 6c                	gs insb (%dx),%es:(%edi)
 275:	00 6d 6f             	add    %ch,0x6f(%ebp)
 278:	64 73 5f             	fs jae 2da <PR_BOOTABLE+0x25a>
 27b:	61                   	popa
 27c:	64 64 72 00          	fs fs jb 280 <PR_BOOTABLE+0x200>
 280:	61                   	popa
 281:	6f                   	outsl  %ds:(%esi),(%dx)
 282:	75 74                	jne    2f8 <PR_BOOTABLE+0x278>
 284:	00 73 74             	add    %dh,0x74(%ebx)
 287:	72 73                	jb     2fc <PR_BOOTABLE+0x27c>
 289:	69 7a 65 00 70 61 72 	imul   $0x72617000,0x65(%edx),%edi
 290:	74 33                	je     2c5 <PR_BOOTABLE+0x245>
 292:	00 70 5f             	add    %dh,0x5f(%eax)
 295:	74 79                	je     310 <PR_BOOTABLE+0x290>
 297:	70 65                	jo     2fe <PR_BOOTABLE+0x27e>
 299:	00 70 72             	add    %dh,0x72(%eax)
 29c:	6f                   	outsl  %ds:(%esi),(%dx)
 29d:	67 68 64 72 00 65    	addr16 push $0x65007264
 2a3:	5f                   	pop    %edi
 2a4:	73 68                	jae    30e <PR_BOOTABLE+0x28e>
 2a6:	65 6e                	outsb  %gs:(%esi),(%dx)
 2a8:	74 73                	je     31d <PR_BOOTABLE+0x29d>
 2aa:	69 7a 65 00 73 68 6e 	imul   $0x6e687300,0x65(%edx),%edi
 2b1:	64 78 00             	fs js  2b4 <PR_BOOTABLE+0x234>
 2b4:	6d                   	insl   (%dx),%es:(%edi)
 2b5:	62 72 5f             	bound  %esi,0x5f(%edx)
 2b8:	74 00                	je     2ba <PR_BOOTABLE+0x23a>
 2ba:	65 5f                	gs pop %edi
 2bc:	74 79                	je     337 <PR_BOOTABLE+0x2b7>
 2be:	70 65                	jo     325 <PR_BOOTABLE+0x2a5>
 2c0:	00 64 72 69          	add    %ah,0x69(%edx,%esi,2)
 2c4:	76 65                	jbe    32b <PR_BOOTABLE+0x2ab>
 2c6:	73 5f                	jae    327 <PR_BOOTABLE+0x2a7>
 2c8:	61                   	popa
 2c9:	64 64 72 00          	fs fs jb 2cd <PR_BOOTABLE+0x24d>
 2cd:	65 5f                	gs pop %edi
 2cf:	65 68 73 69 7a 65    	gs push $0x657a6973
 2d5:	00 70 61             	add    %dh,0x61(%eax)
 2d8:	72 74                	jb     34e <PR_BOOTABLE+0x2ce>
 2da:	69 74 69 6f 6e 00 62 	imul   $0x6962006e,0x6f(%ecx,%ebp,2),%esi
 2e1:	69 
 2e2:	6f                   	outsl  %ds:(%esi),(%dx)
 2e3:	73 5f                	jae    344 <PR_BOOTABLE+0x2c4>
 2e5:	73 6d                	jae    354 <PR_BOOTABLE+0x2d4>
 2e7:	61                   	popa
 2e8:	70 5f                	jo     349 <PR_BOOTABLE+0x2c9>
 2ea:	74 00                	je     2ec <PR_BOOTABLE+0x26c>
 2ec:	6d                   	insl   (%dx),%es:(%edi)
 2ed:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2f0:	74 5f                	je     351 <PR_BOOTABLE+0x2d1>
 2f2:	69 6e 66 6f 5f 74 00 	imul   $0x745f6f,0x66(%esi),%ebp
 2f9:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2fc:	74 61                	je     35f <PR_BOOTABLE+0x2df>
 2fe:	62 6c 65 5f          	bound  %ebp,0x5f(%ebp,%eiz,2)
 302:	6c                   	insb   (%dx),%es:(%edi)
 303:	62 61 00             	bound  %esp,0x0(%ecx)
 306:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 309:	74 31                	je     33c <PR_BOOTABLE+0x2bc>
 30b:	6d                   	insl   (%dx),%es:(%edi)
 30c:	61                   	popa
 30d:	69 6e 00 65 5f 76 65 	imul   $0x65765f65,0x0(%esi),%ebp
 314:	72 73                	jb     389 <PR_BOOTABLE+0x309>
 316:	69 6f 6e 00 70 61 72 	imul   $0x72617000,0x6e(%edi),%ebp
 31d:	74 31                	je     350 <PR_BOOTABLE+0x2d0>
 31f:	00 70 61             	add    %dh,0x61(%eax)
 322:	72 74                	jb     398 <PR_BOOTABLE+0x318>
 324:	32 00                	xor    (%eax),%al
 326:	64 72 69             	fs jb  392 <PR_BOOTABLE+0x312>
 329:	76 65                	jbe    390 <PR_BOOTABLE+0x310>
 32b:	72 00                	jb     32d <PR_BOOTABLE+0x2ad>
 32d:	66 69 72 73 74 5f    	imul   $0x5f74,0x73(%edx),%si
 333:	63 68 73             	arpl   %ebp,0x73(%eax)
 336:	00 62 69             	add    %ah,0x69(%edx)
 339:	6f                   	outsl  %ds:(%esi),(%dx)
 33a:	73 5f                	jae    39b <PR_BOOTABLE+0x31b>
 33c:	73 6d                	jae    3ab <PR_BOOTABLE+0x32b>
 33e:	61                   	popa
 33f:	70 00                	jo     341 <PR_BOOTABLE+0x2c1>
 341:	6d                   	insl   (%dx),%es:(%edi)
 342:	65 6d                	gs insl (%dx),%es:(%edi)
 344:	5f                   	pop    %edi
 345:	6c                   	insb   (%dx),%es:(%edi)
 346:	6f                   	outsl  %ds:(%esi),(%dx)
 347:	77 65                	ja     3ae <PR_BOOTABLE+0x32e>
 349:	72 00                	jb     34b <PR_BOOTABLE+0x2cb>
 34b:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 34e:	74 61                	je     3b1 <PR_BOOTABLE+0x331>
 350:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 354:	73 79                	jae    3cf <PR_BOOTABLE+0x34f>
 356:	6d                   	insl   (%dx),%es:(%edi)
 357:	73 00                	jae    359 <PR_BOOTABLE+0x2d9>
 359:	75 69                	jne    3c4 <PR_BOOTABLE+0x344>
 35b:	6e                   	outsb  %ds:(%esi),(%dx)
 35c:	74 31                	je     38f <PR_BOOTABLE+0x30f>
 35e:	36 5f                	ss pop %edi
 360:	74 00                	je     362 <PR_BOOTABLE+0x2e2>
 362:	6d                   	insl   (%dx),%es:(%edi)
 363:	6d                   	insl   (%dx),%es:(%edi)
 364:	61                   	popa
 365:	70 5f                	jo     3c6 <PR_BOOTABLE+0x346>
 367:	6c                   	insb   (%dx),%es:(%edi)
 368:	65 6e                	outsb  %gs:(%esi),(%dx)
 36a:	67 74 68             	addr16 je 3d5 <PR_BOOTABLE+0x355>
 36d:	00 6d 62             	add    %ch,0x62(%ebp)
 370:	6f                   	outsl  %ds:(%esi),(%dx)
 371:	6f                   	outsl  %ds:(%esi),(%dx)
 372:	74 5f                	je     3d3 <PR_BOOTABLE+0x353>
 374:	69 6e 66 6f 00 70 5f 	imul   $0x5f70006f,0x66(%esi),%ebp
 37b:	76 61                	jbe    3de <PR_BOOTABLE+0x35e>
 37d:	00 76 62             	add    %dh,0x62(%esi)
 380:	65 5f                	gs pop %edi
 382:	63 6f 6e             	arpl   %ebp,0x6e(%edi)
 385:	74 72                	je     3f9 <PR_BOOTABLE+0x379>
 387:	6f                   	outsl  %ds:(%esi),(%dx)
 388:	6c                   	insb   (%dx),%es:(%edi)
 389:	5f                   	pop    %edi
 38a:	69 6e 66 6f 00 70 5f 	imul   $0x5f70006f,0x66(%esi),%ebp
 391:	66 6c                	data16 insb (%dx),%es:(%edi)
 393:	61                   	popa
 394:	67 73 00             	addr16 jae 397 <PR_BOOTABLE+0x317>
 397:	70 61                	jo     3fa <PR_BOOTABLE+0x37a>
 399:	72 73                	jb     40e <PR_BOOTABLE+0x38e>
 39b:	65 5f                	gs pop %edi
 39d:	65 38 32             	cmp    %dh,%gs:(%edx)
 3a0:	30 00                	xor    %al,(%eax)
 3a2:	65 5f                	gs pop %edi
 3a4:	65 6c                	gs insb (%dx),%es:(%edi)
 3a6:	66 00 62 6f          	data16 add %ah,0x6f(%edx)
 3aa:	6f                   	outsl  %ds:(%esi),(%dx)
 3ab:	74 5f                	je     40c <PR_BOOTABLE+0x38c>
 3ad:	64 65 76 69          	fs gs jbe 41a <PR_BOOTABLE+0x39a>
 3b1:	63 65 00             	arpl   %esp,0x0(%ebp)
 3b4:	64 6b 65 72 6e       	imul   $0x6e,%fs:0x72(%ebp),%esp
 3b9:	65 6c                	gs insb (%dx),%es:(%edi)
 3bb:	00 65 5f             	add    %ah,0x5f(%ebp)
 3be:	70 68                	jo     428 <PR_BOOTABLE+0x3a8>
 3c0:	6f                   	outsl  %ds:(%esi),(%dx)
 3c1:	66 66 00 63 6f       	data16 data16 add %ah,0x6f(%ebx)
 3c6:	6e                   	outsb  %ds:(%esi),(%dx)
 3c7:	66 69 67 5f 74 61    	imul   $0x6174,0x5f(%edi),%sp
 3cd:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 3d1:	65 5f                	gs pop %edi
 3d3:	6d                   	insl   (%dx),%es:(%edi)
 3d4:	61                   	popa
 3d5:	67 69 63 00 6c 61 73 	imul   $0x7473616c,0x0(%bp,%di),%esp
 3dc:	74 
 3dd:	5f                   	pop    %edi
 3de:	63 68 73             	arpl   %ebp,0x73(%eax)
 3e1:	00 62 61             	add    %ah,0x61(%edx)
 3e4:	73 65                	jae    44b <PR_BOOTABLE+0x3cb>
 3e6:	5f                   	pop    %edi
 3e7:	61                   	popa
 3e8:	64 64 72 00          	fs fs jb 3ec <PR_BOOTABLE+0x36c>
 3ec:	76 62                	jbe    450 <PR_BOOTABLE+0x3d0>
 3ee:	65 5f                	gs pop %edi
 3f0:	6d                   	insl   (%dx),%es:(%edi)
 3f1:	6f                   	outsl  %ds:(%esi),(%dx)
 3f2:	64 65 00 65 5f       	fs add %ah,%gs:0x5f(%ebp)
 3f7:	73 68                	jae    461 <PR_BOOTABLE+0x3e1>
 3f9:	6f                   	outsl  %ds:(%esi),(%dx)
 3fa:	66 66 00 6d 65       	data16 data16 add %ch,0x65(%ebp)
 3ff:	6d                   	insl   (%dx),%es:(%edi)
 400:	5f                   	pop    %edi
 401:	75 70                	jne    473 <PR_BOOTABLE+0x3f3>
 403:	70 65                	jo     46a <PR_BOOTABLE+0x3ea>
 405:	72 00                	jb     407 <PR_BOOTABLE+0x387>
 407:	76 62                	jbe    46b <PR_BOOTABLE+0x3eb>
 409:	65 5f                	gs pop %edi
 40b:	6d                   	insl   (%dx),%es:(%edi)
 40c:	6f                   	outsl  %ds:(%esi),(%dx)
 40d:	64 65 5f             	fs gs pop %edi
 410:	69 6e 66 6f 00 74 61 	imul   $0x6174006f,0x66(%esi),%ebp
 417:	62 73 69             	bound  %esi,0x69(%ebx)
 41a:	7a 65                	jp     481 <PR_BOOTABLE+0x401>
 41c:	00 66 69             	add    %ah,0x69(%esi)
 41f:	72 73                	jb     494 <PR_BOOTABLE+0x414>
 421:	74 5f                	je     482 <PR_BOOTABLE+0x402>
 423:	6c                   	insb   (%dx),%es:(%edi)
 424:	62 61 00             	bound  %esp,0x0(%ecx)
 427:	64 72 69             	fs jb  493 <PR_BOOTABLE+0x413>
 42a:	76 65                	jbe    491 <PR_BOOTABLE+0x411>
 42c:	73 5f                	jae    48d <PR_BOOTABLE+0x40d>
 42e:	6c                   	insb   (%dx),%es:(%edi)
 42f:	65 6e                	outsb  %gs:(%esi),(%dx)
 431:	67 74 68             	addr16 je 49c <PR_BOOTABLE+0x41c>
 434:	00 70 5f             	add    %dh,0x5f(%eax)
 437:	66 69 6c 65 73 7a 00 	imul   $0x7a,0x73(%ebp,%eiz,2),%bp
 43e:	65 5f                	gs pop %edi
 440:	70 68                	jo     4aa <PR_BOOTABLE+0x42a>
 442:	6e                   	outsb  %ds:(%esi),(%dx)
 443:	75 6d                	jne    4b2 <PR_BOOTABLE+0x432>
 445:	00 73 69             	add    %dh,0x69(%ebx)
 448:	67 6e                	outsb  %ds:(%si),(%dx)
 44a:	61                   	popa
 44b:	74 75                	je     4c2 <PR_BOOTABLE+0x442>
 44d:	72 65                	jb     4b4 <PR_BOOTABLE+0x434>
 44f:	00 76 62             	add    %dh,0x62(%esi)
 452:	65 5f                	gs pop %edi
 454:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 45b:	63 65 5f             	arpl   %esp,0x5f(%ebp)
 45e:	6c                   	insb   (%dx),%es:(%edi)
 45f:	65 6e                	outsb  %gs:(%esi),(%dx)
 461:	00 65 5f             	add    %ah,0x5f(%ebp)
 464:	73 68                	jae    4ce <PR_BOOTABLE+0x44e>
 466:	6e                   	outsb  %ds:(%esi),(%dx)
 467:	75 6d                	jne    4d6 <PR_BOOTABLE+0x456>
 469:	00 6d 6f             	add    %ch,0x6f(%ebp)
 46c:	64 73 5f             	fs jae 4ce <PR_BOOTABLE+0x44e>
 46f:	63 6f 75             	arpl   %ebp,0x75(%edi)
 472:	6e                   	outsb  %ds:(%esi),(%dx)
 473:	74 00                	je     475 <PR_BOOTABLE+0x3f5>
 475:	5f                   	pop    %edi
 476:	72 65                	jb     4dd <PR_BOOTABLE+0x45d>
 478:	73 65                	jae    4df <PR_BOOTABLE+0x45f>
 47a:	72 76                	jb     4f2 <PR_BOOTABLE+0x472>
 47c:	65 64 00 62 6f       	gs add %ah,%fs:0x6f(%edx)
 481:	6f                   	outsl  %ds:(%esi),(%dx)
 482:	74 5f                	je     4e3 <PR_BOOTABLE+0x463>
 484:	6c                   	insb   (%dx),%es:(%edi)
 485:	6f                   	outsl  %ds:(%esi),(%dx)
 486:	61                   	popa
 487:	64 65 72 5f          	fs gs jb 4ea <PR_BOOTABLE+0x46a>
 48b:	6e                   	outsb  %ds:(%esi),(%dx)
 48c:	61                   	popa
 48d:	6d                   	insl   (%dx),%es:(%edi)
 48e:	65 00 76 62          	add    %dh,%gs:0x62(%esi)
 492:	65 5f                	gs pop %edi
 494:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 49b:	63 65 5f             	arpl   %esp,0x5f(%ebp)
 49e:	73 65                	jae    505 <PR_BOOTABLE+0x485>
 4a0:	67 00 6d 6d          	add    %ch,0x6d(%di)
 4a4:	61                   	popa
 4a5:	70 5f                	jo     506 <PR_BOOTABLE+0x486>
 4a7:	6c                   	insb   (%dx),%es:(%edi)
 4a8:	65 6e                	outsb  %gs:(%esi),(%dx)
 4aa:	00 70 5f             	add    %dh,0x5f(%eax)
 4ad:	61                   	popa
 4ae:	6c                   	insb   (%dx),%es:(%edi)
 4af:	69 67 6e 00 61 70 6d 	imul   $0x6d706100,0x6e(%edi),%esp
 4b6:	5f                   	pop    %edi
 4b7:	74 61                	je     51a <PR_BOOTABLE+0x49a>
 4b9:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 4bd:	70 5f                	jo     51e <PR_BOOTABLE+0x49e>
 4bf:	70 61                	jo     522 <PR_BOOTABLE+0x4a2>
 4c1:	00 73 65             	add    %dh,0x65(%ebx)
 4c4:	63 74 6f 72          	arpl   %esi,0x72(%edi,%ebp,2)
 4c8:	73 5f                	jae    529 <PR_BOOTABLE+0x4a9>
 4ca:	63 6f 75             	arpl   %ebp,0x75(%edi)
 4cd:	6e                   	outsb  %ds:(%esi),(%dx)
 4ce:	74 00                	je     4d0 <PR_BOOTABLE+0x450>
 4d0:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 4d3:	74 2f                	je     504 <PR_BOOTABLE+0x484>
 4d5:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 4d8:	74 31                	je     50b <PR_BOOTABLE+0x48b>
 4da:	2f                   	das
 4db:	65 78 65             	gs js  543 <PR_BOOTABLE+0x4c3>
 4de:	63 5f 6b             	arpl   %ebx,0x6b(%edi)
 4e1:	65 72 6e             	gs jb  552 <PR_BOOTABLE+0x4d2>
 4e4:	65 6c                	gs insb (%dx),%es:(%edi)
 4e6:	2e 53                	cs push %ebx
 4e8:	00                   	.byte 0

Disassembly of section .debug_line_str:

00000000 <.debug_line_str>:
   0:	2f                   	das
   1:	55                   	push   %ebp
   2:	73 65                	jae    69 <PROT_MODE_DSEG+0x59>
   4:	72 73                	jb     79 <PROT_MODE_DSEG+0x69>
   6:	2f                   	das
   7:	70 72                	jo     7b <PROT_MODE_DSEG+0x6b>
   9:	69 6e 63 65 66 61 68 	imul   $0x68616665,0x63(%esi),%ebp
  10:	69 6d 61 6c 2d 61 72 	imul   $0x72612d6c,0x61(%ebp),%ebp
  17:	61                   	popa
  18:	66 2f                	data16 das
  1a:	44                   	inc    %esp
  1b:	65 73 6b             	gs jae 89 <PR_BOOTABLE+0x9>
  1e:	74 6f                	je     8f <PR_BOOTABLE+0xf>
  20:	70 2f                	jo     51 <PROT_MODE_DSEG+0x41>
  22:	6d                   	insl   (%dx),%es:(%edi)
  23:	63 65 72             	arpl   %esp,0x72(%ebp)
  26:	74 69                	je     91 <PR_BOOTABLE+0x11>
  28:	6b 6f 73 2f          	imul   $0x2f,0x73(%edi),%ebp
  2c:	55                   	push   %ebp
  2d:	6e                   	outsb  %ds:(%esi),(%dx)
  2e:	69 78 5f 53 68 65 6c 	imul   $0x6c656853,0x5f(%eax),%edi
  35:	6c                   	insb   (%dx),%es:(%edi)
  36:	00 62 6f             	add    %ah,0x6f(%edx)
  39:	6f                   	outsl  %ds:(%esi),(%dx)
  3a:	74 2f                	je     6b <PROT_MODE_DSEG+0x5b>
  3c:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  3f:	74 31                	je     72 <PROT_MODE_DSEG+0x62>
  41:	00 62 6f             	add    %ah,0x6f(%edx)
  44:	6f                   	outsl  %ds:(%esi),(%dx)
  45:	74 31                	je     78 <PROT_MODE_DSEG+0x68>
  47:	2e 53                	cs push %ebx
  49:	00 62 6f             	add    %ah,0x6f(%edx)
  4c:	6f                   	outsl  %ds:(%esi),(%dx)
  4d:	74 2f                	je     7e <PROT_MODE_DSEG+0x6e>
  4f:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  52:	74 31                	je     85 <PR_BOOTABLE+0x5>
  54:	2f                   	das
  55:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  58:	74 31                	je     8b <PR_BOOTABLE+0xb>
  5a:	6c                   	insb   (%dx),%es:(%edi)
  5b:	69 62 2e 63 00 62 6f 	imul   $0x6f620063,0x2e(%edx),%esp
  62:	6f                   	outsl  %ds:(%esi),(%dx)
  63:	74 31                	je     96 <PR_BOOTABLE+0x16>
  65:	6c                   	insb   (%dx),%es:(%edi)
  66:	69 62 2e 68 00 62 6f 	imul   $0x6f620068,0x2e(%edx),%esp
  6d:	6f                   	outsl  %ds:(%esi),(%dx)
  6e:	74 2f                	je     9f <PR_BOOTABLE+0x1f>
  70:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  73:	74 31                	je     a6 <PR_BOOTABLE+0x26>
  75:	2f                   	das
  76:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  79:	74 31                	je     ac <PR_BOOTABLE+0x2c>
  7b:	6d                   	insl   (%dx),%es:(%edi)
  7c:	61                   	popa
  7d:	69 6e 2e 63 00 65 78 	imul   $0x78650063,0x2e(%esi),%ebp
  84:	65 63 5f 6b          	arpl   %ebx,%gs:0x6b(%edi)
  88:	65 72 6e             	gs jb  f9 <PR_BOOTABLE+0x79>
  8b:	65 6c                	gs insb (%dx),%es:(%edi)
  8d:	2e 53                	cs push %ebx
  8f:	00                   	.byte 0

Disassembly of section .debug_loclists:

00000000 <.debug_loclists>:
   0:	b2 03                	mov    $0x3,%dl
   2:	00 00                	add    %al,(%eax)
   4:	05 00 04 00 00       	add    $0x400,%eax
   9:	00 00                	add    %al,(%eax)
   b:	00 00                	add    %al,(%eax)
   d:	00 00                	add    %al,(%eax)
   f:	00 00                	add    %al,(%eax)
  11:	00 00                	add    %al,(%eax)
  13:	00 00                	add    %al,(%eax)
  15:	01 01                	add    %eax,(%ecx)
  17:	00 00                	add    %al,(%eax)
  19:	00 00                	add    %al,(%eax)
  1b:	01 01                	add    %eax,(%ecx)
  1d:	00 04 a4             	add    %al,(%esp,%eiz,4)
  20:	04 b0                	add    $0xb0,%al
  22:	04 02                	add    $0x2,%al
  24:	91                   	xchg   %eax,%ecx
  25:	00 04 b0             	add    %al,(%eax,%esi,4)
  28:	04 be                	add    $0xbe,%al
  2a:	04 09                	add    $0x9,%al
  2c:	73 00                	jae    2e <PROT_MODE_DSEG+0x1e>
  2e:	0c ff                	or     $0xff,%al
  30:	ff                   	(bad)
  31:	ff 00                	incl   (%eax)
  33:	1a 9f 04 be 04 c7    	sbb    -0x38fb41fc(%edi),%bl
  39:	04 09                	add    $0x9,%al
  3b:	77 00                	ja     3d <PROT_MODE_DSEG+0x2d>
  3d:	0c ff                	or     $0xff,%al
  3f:	ff                   	(bad)
  40:	ff 00                	incl   (%eax)
  42:	1a 9f 04 c7 04 ca    	sbb    -0x35fb38fc(%edi),%bl
  48:	04 01                	add    $0x1,%al
  4a:	57                   	push   %edi
  4b:	04 ca                	add    $0xca,%al
  4d:	04 ca                	add    $0xca,%al
  4f:	04 0a                	add    $0xa,%al
  51:	91                   	xchg   %eax,%ecx
  52:	00 06                	add    %al,(%esi)
  54:	0c ff                	or     $0xff,%al
  56:	ff                   	(bad)
  57:	ff 00                	incl   (%eax)
  59:	1a 9f 04 ca 04 d9    	sbb    -0x26fb35fc(%edi),%bl
  5f:	04 01                	add    $0x1,%al
  61:	53                   	push   %ebx
  62:	04 d9                	add    $0xd9,%al
  64:	04 dd                	add    $0xdd,%al
  66:	04 02                	add    $0x2,%al
  68:	74 00                	je     6a <PROT_MODE_DSEG+0x5a>
  6a:	04 dd                	add    $0xdd,%al
  6c:	04 de                	add    $0xde,%al
  6e:	04 04                	add    $0x4,%al
  70:	73 80                	jae    fffffff2 <SMAP_SIG+0xacb2bea2>
  72:	7c 9f                	jl     13 <PROT_MODE_DSEG+0x3>
  74:	04 de                	add    $0xde,%al
  76:	04 e7                	add    $0xe7,%al
  78:	04 01                	add    $0x1,%al
  7a:	53                   	push   %ebx
  7b:	00 00                	add    %al,(%eax)
  7d:	00 00                	add    %al,(%eax)
  7f:	00 04 a4             	add    %al,(%esp,%eiz,4)
  82:	04 ea                	add    $0xea,%al
  84:	04 02                	add    $0x2,%al
  86:	91                   	xchg   %eax,%ecx
  87:	04 04                	add    $0x4,%al
  89:	ea 04 eb 04 02 74 08 	ljmp   $0x874,$0x204eb04
  90:	00 00                	add    %al,(%eax)
  92:	02 02                	add    (%edx),%al
  94:	00 00                	add    %al,(%eax)
  96:	00 00                	add    %al,(%eax)
  98:	02 02                	add    (%edx),%al
  9a:	00 04 a4             	add    %al,(%esp,%eiz,4)
  9d:	04 ca                	add    $0xca,%al
  9f:	04 02                	add    $0x2,%al
  a1:	91                   	xchg   %eax,%ecx
  a2:	08 04 ca             	or     %al,(%edx,%ecx,8)
  a5:	04 d2                	add    $0xd2,%al
  a7:	04 01                	add    $0x1,%al
  a9:	56                   	push   %esi
  aa:	04 d2                	add    $0xd2,%al
  ac:	04 d3                	add    $0xd3,%al
  ae:	04 02                	add    $0x2,%al
  b0:	74 00                	je     b2 <PR_BOOTABLE+0x32>
  b2:	04 d3                	add    $0xd3,%al
  b4:	04 de                	add    $0xde,%al
  b6:	04 03                	add    $0x3,%al
  b8:	76 7f                	jbe    139 <PR_BOOTABLE+0xb9>
  ba:	9f                   	lahf
  bb:	04 de                	add    $0xde,%al
  bd:	04 e8                	add    $0xe8,%al
  bf:	04 01                	add    $0x1,%al
  c1:	56                   	push   %esi
  c2:	00 00                	add    %al,(%eax)
  c4:	00 00                	add    %al,(%eax)
  c6:	00 04 a4             	add    %al,(%esp,%eiz,4)
  c9:	04 ea                	add    $0xea,%al
  cb:	04 02                	add    $0x2,%al
  cd:	91                   	xchg   %eax,%ecx
  ce:	0c 04                	or     $0x4,%al
  d0:	ea 04 eb 04 02 74 10 	ljmp   $0x1074,$0x204eb04
  d7:	00 00                	add    %al,(%eax)
  d9:	00 00                	add    %al,(%eax)
  db:	00 00                	add    %al,(%eax)
  dd:	00 04 ca             	add    %al,(%edx,%ecx,8)
  e0:	04 e9                	add    $0xe9,%al
  e2:	04 01                	add    $0x1,%al
  e4:	57                   	push   %edi
  e5:	04 e9                	add    $0xe9,%al
  e7:	04 ea                	add    $0xea,%al
  e9:	04 0e                	add    $0xe,%al
  eb:	91                   	xchg   %eax,%ecx
  ec:	00 06                	add    %al,(%esi)
  ee:	0c ff                	or     $0xff,%al
  f0:	ff                   	(bad)
  f1:	ff 00                	incl   (%eax)
  f3:	1a 91 04 06 22 9f    	sbb    -0x60ddf9fc(%ecx),%dl
  f9:	04 ea                	add    $0xea,%al
  fb:	04 eb                	add    $0xeb,%al
  fd:	04 0e                	add    $0xe,%al
  ff:	91                   	xchg   %eax,%ecx
 100:	00 06                	add    %al,(%esi)
 102:	0c ff                	or     $0xff,%al
 104:	ff                   	(bad)
 105:	ff 00                	incl   (%eax)
 107:	1a 74 08 06          	sbb    0x6(%eax,%ecx,1),%dh
 10b:	22 9f 00 04 01 04    	and    0x4010400(%edi),%bl
 111:	bb 03 c1 03 04       	mov    $0x403c103,%ebx
 116:	0a f7                	or     %bh,%dh
 118:	01 9f 00 01 00 04    	add    %ebx,0x4000100(%edi)
 11e:	c8 03 d0 03          	enter  $0xd003,$0x3
 122:	04 0a                	add    $0xa,%al
 124:	f2 01 9f 00 01 00 04 	repnz add %ebx,0x4000100(%edi)
 12b:	c8 03 d0 03          	enter  $0xd003,$0x3
 12f:	02 31                	add    (%ecx),%dh
 131:	9f                   	lahf
 132:	00 02                	add    %al,(%edx)
 134:	00 04 d0             	add    %al,(%eax,%edx,8)
 137:	03 d8                	add    %eax,%ebx
 139:	03 04 0a             	add    (%edx,%ecx,1),%eax
 13c:	f3 01 9f 00 02 00 04 	repz add %ebx,0x4000200(%edi)
 143:	d0 03                	rolb   $1,(%ebx)
 145:	d8 03                	fadds  (%ebx)
 147:	01 51 00             	add    %edx,0x0(%ecx)
 14a:	02 00                	add    (%eax),%al
 14c:	04 d8                	add    $0xd8,%al
 14e:	03 e3                	add    %ebx,%esp
 150:	03 04 0a             	add    (%edx,%ecx,1),%eax
 153:	f4                   	hlt
 154:	01 9f 00 02 00 04    	add    %ebx,0x4000200(%edi)
 15a:	d8 03                	fadds  (%ebx)
 15c:	e3 03                	jecxz  161 <PR_BOOTABLE+0xe1>
 15e:	02 91 05 00 02 00    	add    0x20005(%ecx),%dl
 164:	04 e3                	add    $0xe3,%al
 166:	03 ee                	add    %esi,%ebp
 168:	03 04 0a             	add    (%edx,%ecx,1),%eax
 16b:	f5                   	cmc
 16c:	01 9f 00 02 00 04    	add    %ebx,0x4000200(%edi)
 172:	e3 03                	jecxz  177 <PR_BOOTABLE+0xf7>
 174:	ee                   	out    %al,(%dx)
 175:	03 02                	add    (%edx),%eax
 177:	91                   	xchg   %eax,%ecx
 178:	06                   	push   %es
 179:	00 02                	add    %al,(%edx)
 17b:	00 04 ee             	add    %al,(%esi,%ebp,8)
 17e:	03 fc                	add    %esp,%edi
 180:	03 04 0a             	add    (%edx,%ecx,1),%eax
 183:	f6 01 9f             	testb  $0x9f,(%ecx)
 186:	00 02                	add    %al,(%edx)
 188:	00 04 ee             	add    %al,(%esi,%ebp,8)
 18b:	03 fc                	add    %esp,%edi
 18d:	03 08                	add    (%eax),%ecx
 18f:	91                   	xchg   %eax,%ecx
 190:	07                   	pop    %es
 191:	94                   	xchg   %eax,%esp
 192:	01 09                	add    %ecx,(%ecx)
 194:	e0 21                	loopne 1b7 <PR_BOOTABLE+0x137>
 196:	9f                   	lahf
 197:	00 02                	add    %al,(%edx)
 199:	00 04 fc             	add    %al,(%esp,%edi,8)
 19c:	03 84 04 04 0a f7 01 	add    0x1f70a04(%esp,%eax,1),%eax
 1a3:	9f                   	lahf
 1a4:	00 02                	add    %al,(%edx)
 1a6:	00 04 fc             	add    %al,(%esp,%edi,8)
 1a9:	03 84 04 03 08 20 9f 	add    -0x60dff7fd(%esp,%eax,1),%eax
 1b0:	00 01                	add    %al,(%ecx)
 1b2:	01 04 89             	add    %eax,(%ecx,%ecx,4)
 1b5:	04 8a                	add    $0x8a,%al
 1b7:	04 04                	add    $0x4,%al
 1b9:	0a f7                	or     %bh,%dh
 1bb:	01 9f 00 01 00 04    	add    %ebx,0x4000100(%edi)
 1c1:	91                   	xchg   %eax,%ecx
 1c2:	04 a1                	add    $0xa1,%al
 1c4:	04 04                	add    $0x4,%al
 1c6:	0a f0                	or     %al,%dh
 1c8:	01 9f 00 01 00 04    	add    %ebx,0x4000100(%edi)
 1ce:	91                   	xchg   %eax,%ecx
 1cf:	04 a1                	add    $0xa1,%al
 1d1:	04 02                	add    $0x2,%al
 1d3:	91                   	xchg   %eax,%ecx
 1d4:	00 00                	add    %al,(%eax)
 1d6:	01 00                	add    %eax,(%eax)
 1d8:	04 91                	add    $0x91,%al
 1da:	04 a1                	add    $0xa1,%al
 1dc:	04 03                	add    $0x3,%al
 1de:	08 80 9f 00 00 00    	or     %al,0x9f(%eax)
 1e4:	00 00                	add    %al,(%eax)
 1e6:	04 f4                	add    $0xf4,%al
 1e8:	02 90 03 02 91 04    	add    0x4910203(%eax),%dl
 1ee:	04 90                	add    $0x90,%al
 1f0:	03 91 03 02 74 08    	add    0x8740203(%ecx),%edx
 1f6:	00 00                	add    %al,(%eax)
 1f8:	00 00                	add    %al,(%eax)
 1fa:	00 04 d7             	add    %al,(%edi,%edx,8)
 1fd:	02 f3                	add    %bl,%dh
 1ff:	02 02                	add    (%edx),%al
 201:	91                   	xchg   %eax,%ecx
 202:	04 04                	add    $0x4,%al
 204:	f3 02 f4             	repz add %ah,%dh
 207:	02 02                	add    (%edx),%al
 209:	74 08                	je     213 <PR_BOOTABLE+0x193>
 20b:	00 00                	add    %al,(%eax)
 20d:	00 00                	add    %al,(%eax)
 20f:	00 04 80             	add    %al,(%eax,%eax,4)
 212:	02 a1 02 02 91 00    	add    0x910202(%ecx),%ah
 218:	04 a1                	add    $0xa1,%al
 21a:	02 d6                	add    %dh,%dl
 21c:	02 01                	add    (%ecx),%al
 21e:	50                   	push   %eax
 21f:	00 00                	add    %al,(%eax)
 221:	00 00                	add    %al,(%eax)
 223:	00 00                	add    %al,(%eax)
 225:	00 04 a1             	add    %al,(%ecx,%eiz,4)
 228:	02 bd 02 01 51 04    	add    0x4510102(%ebp),%bh
 22e:	bd 02 c4 02 01       	mov    $0x102c402,%ebp
 233:	52                   	push   %edx
 234:	04 c4                	add    $0xc4,%al
 236:	02 d6                	add    %dh,%dl
 238:	02 01                	add    (%ecx),%al
 23a:	51                   	push   %ecx
 23b:	00 00                	add    %al,(%eax)
 23d:	00 04 8c             	add    %al,(%esp,%ecx,4)
 240:	02 d0                	add    %al,%dl
 242:	02 01                	add    (%ecx),%al
 244:	56                   	push   %esi
 245:	00 04 00             	add    %al,(%eax,%eax,1)
 248:	00 00                	add    %al,(%eax)
 24a:	00 01                	add    %al,(%ecx)
 24c:	01 00                	add    %eax,(%eax)
 24e:	04 cb                	add    $0xcb,%al
 250:	01 e2                	add    %esp,%edx
 252:	01 02                	add    %eax,(%edx)
 254:	30 9f 04 e2 01 f3    	xor    %bl,-0xcfe1dfc(%edi)
 25a:	01 01                	add    %eax,(%ecx)
 25c:	52                   	push   %edx
 25d:	04 f3                	add    $0xf3,%al
 25f:	01 f6                	add    %esi,%esi
 261:	01 03                	add    %eax,(%ebx)
 263:	72 7f                	jb     2e4 <PR_BOOTABLE+0x264>
 265:	9f                   	lahf
 266:	04 f6                	add    $0xf6,%al
 268:	01 80 02 01 52 00    	add    %eax,0x520102(%eax)
 26e:	00 00                	add    %al,(%eax)
 270:	00 00                	add    %al,(%eax)
 272:	00 00                	add    %al,(%eax)
 274:	04 e2                	add    $0xe2,%al
 276:	01 f7                	add    %esi,%edi
 278:	01 01                	add    %eax,(%ecx)
 27a:	50                   	push   %eax
 27b:	04 f7                	add    $0xf7,%al
 27d:	01 f9                	add    %edi,%ecx
 27f:	01 03                	add    %eax,(%ebx)
 281:	70 01                	jo     284 <PR_BOOTABLE+0x204>
 283:	9f                   	lahf
 284:	04 f9                	add    $0xf9,%al
 286:	01 80 02 01 50 00    	add    %eax,0x500102(%eax)
 28c:	00 00                	add    %al,(%eax)
 28e:	04 ea                	add    $0xea,%al
 290:	01 f9                	add    %edi,%ecx
 292:	01 01                	add    %eax,(%ecx)
 294:	56                   	push   %esi
 295:	00 00                	add    %al,(%eax)
 297:	00 00                	add    %al,(%eax)
 299:	00 00                	add    %al,(%eax)
 29b:	00 00                	add    %al,(%eax)
 29d:	00 04 b8             	add    %al,(%eax,%edi,4)
 2a0:	01 c0                	add    %eax,%eax
 2a2:	01 02                	add    %eax,(%edx)
 2a4:	91                   	xchg   %eax,%ecx
 2a5:	00 04 c0             	add    %al,(%eax,%eax,8)
 2a8:	01 c7                	add    %eax,%edi
 2aa:	01 07                	add    %eax,(%edi)
 2ac:	91                   	xchg   %eax,%ecx
 2ad:	00 06                	add    %al,(%esi)
 2af:	70 00                	jo     2b1 <PR_BOOTABLE+0x231>
 2b1:	22 9f 04 c7 01 c9    	and    -0x36fe38fc(%edi),%bl
 2b7:	01 09                	add    %ecx,(%ecx)
 2b9:	91                   	xchg   %eax,%ecx
 2ba:	00 06                	add    %al,(%esi)
 2bc:	70 00                	jo     2be <PR_BOOTABLE+0x23e>
 2be:	22 31                	and    (%ecx),%dh
 2c0:	1c 9f                	sbb    $0x9f,%al
 2c2:	04 c9                	add    $0xc9,%al
 2c4:	01 cb                	add    %ecx,%ebx
 2c6:	01 07                	add    %eax,(%edi)
 2c8:	91                   	xchg   %eax,%ecx
 2c9:	00 06                	add    %al,(%esi)
 2cb:	70 00                	jo     2cd <PR_BOOTABLE+0x24d>
 2cd:	22 9f 00 03 00 00    	and    0x300(%edi),%bl
 2d3:	00 04 b8             	add    %al,(%eax,%edi,4)
 2d6:	01 c0                	add    %eax,%eax
 2d8:	01 02                	add    %eax,(%edx)
 2da:	30 9f 04 c0 01 cb    	xor    %bl,-0x34fe3ffc(%edi)
 2e0:	01 01                	add    %eax,(%ecx)
 2e2:	50                   	push   %eax
 2e3:	00 00                	add    %al,(%eax)
 2e5:	00 04 91             	add    %al,(%ecx,%edx,4)
 2e8:	03 ae 03 02 91 00    	add    0x910203(%esi),%ebp
 2ee:	00 00                	add    %al,(%eax)
 2f0:	00 00                	add    %al,(%eax)
 2f2:	00 04 1b             	add    %al,(%ebx,%ebx,1)
 2f5:	4d                   	dec    %ebp
 2f6:	02 91 04 04 4d 4e    	add    0x4e4d0404(%ecx),%dl
 2fc:	02 74 08 00          	add    0x0(%eax,%ecx,1),%dh
 300:	00 00                	add    %al,(%eax)
 302:	00 00                	add    %al,(%eax)
 304:	04 1b                	add    $0x1b,%al
 306:	4d                   	dec    %ebp
 307:	02 91 08 04 4d 4e    	add    0x4e4d0408(%ecx),%dl
 30d:	02 74 0c 00          	add    0x0(%esp,%ecx,1),%dh
 311:	00 00                	add    %al,(%eax)
 313:	00 01                	add    %al,(%ecx)
 315:	01 00                	add    %eax,(%eax)
 317:	00 00                	add    %al,(%eax)
 319:	00 00                	add    %al,(%eax)
 31b:	00 00                	add    %al,(%eax)
 31d:	00 00                	add    %al,(%eax)
 31f:	04 1b                	add    $0x1b,%al
 321:	29 02                	sub    %eax,(%edx)
 323:	91                   	xchg   %eax,%ecx
 324:	0c 04                	or     $0x4,%al
 326:	29 36                	sub    %esi,(%esi)
 328:	0a 91 0c 06 71 00    	or     0x71060c(%ecx),%dl
 32e:	22 73 00             	and    0x0(%ebx),%dh
 331:	1c 9f                	sbb    $0x9f,%al
 333:	04 36                	add    $0x36,%al
 335:	3d 0c 91 0c 06       	cmp    $0x60c910c,%eax
 33a:	71 00                	jno    33c <PR_BOOTABLE+0x2bc>
 33c:	22 73 00             	and    0x0(%ebx),%dh
 33f:	1c 23                	sbb    $0x23,%al
 341:	01 9f 04 3d 41 0d    	add    %ebx,0xd413d04(%edi)
 347:	91                   	xchg   %eax,%ecx
 348:	0c 06                	or     $0x6,%al
 34a:	74 00                	je     34c <PR_BOOTABLE+0x2cc>
 34c:	06                   	push   %es
 34d:	22 73 00             	and    0x0(%ebx),%dh
 350:	1c 23                	sbb    $0x23,%al
 352:	01 9f 04 41 4a 0a    	add    %ebx,0xa4a4104(%edi)
 358:	91                   	xchg   %eax,%ecx
 359:	0c 06                	or     $0x6,%al
 35b:	71 00                	jno    35d <PR_BOOTABLE+0x2dd>
 35d:	22 73 00             	and    0x0(%ebx),%dh
 360:	1c 9f                	sbb    $0x9f,%al
 362:	04 4a                	add    $0x4a,%al
 364:	4d                   	dec    %ebp
 365:	12 91 0c 06 91 00    	adc    0x91060c(%ecx),%dl
 36b:	06                   	push   %es
 36c:	08 50 1e             	or     %dl,0x1e(%eax)
 36f:	1c 71                	sbb    $0x71,%al
 371:	00 22                	add    %ah,(%edx)
 373:	91                   	xchg   %eax,%ecx
 374:	04 06                	add    $0x6,%al
 376:	1c 9f                	sbb    $0x9f,%al
 378:	04 4d                	add    $0x4d,%al
 37a:	4e                   	dec    %esi
 37b:	12 74 10 06          	adc    0x6(%eax,%edx,1),%dh
 37f:	91                   	xchg   %eax,%ecx
 380:	00 06                	add    %al,(%esi)
 382:	08 50 1e             	or     %dl,0x1e(%eax)
 385:	1c 71                	sbb    $0x71,%al
 387:	00 22                	add    %ah,(%edx)
 389:	74 08                	je     393 <PR_BOOTABLE+0x313>
 38b:	06                   	push   %es
 38c:	1c 9f                	sbb    $0x9f,%al
 38e:	00 00                	add    %al,(%eax)
 390:	00 00                	add    %al,(%eax)
 392:	01 01                	add    %eax,(%ecx)
 394:	00 00                	add    %al,(%eax)
 396:	00 04 27             	add    %al,(%edi,%eiz,1)
 399:	29 01                	sub    %eax,(%ecx)
 39b:	53                   	push   %ebx
 39c:	04 29                	add    $0x29,%al
 39e:	36 01 51 04          	add    %edx,%ss:0x4(%ecx)
 3a2:	36 3d 03 71 01 9f    	ss cmp $0x9f017103,%eax
 3a8:	04 3d                	add    $0x3d,%al
 3aa:	4e                   	dec    %esi
 3ab:	01 51 00             	add    %edx,0x0(%ecx)
 3ae:	00 00                	add    %al,(%eax)
 3b0:	04 11                	add    $0x11,%al
 3b2:	1b 01                	sbb    (%ecx),%eax
 3b4:	50                   	push   %eax
 3b5:	00 32                	add    %dh,(%edx)
 3b7:	01 00                	add    %eax,(%eax)
 3b9:	00 05 00 04 00 00    	add    %al,0x400
 3bf:	00 00                	add    %al,(%eax)
 3c1:	00 00                	add    %al,(%eax)
 3c3:	00 00                	add    %al,(%eax)
 3c5:	00 00                	add    %al,(%eax)
 3c7:	01 00                	add    %eax,(%eax)
 3c9:	00 00                	add    %al,(%eax)
 3cb:	00 00                	add    %al,(%eax)
 3cd:	00 04 89             	add    %al,(%ecx,%ecx,4)
 3d0:	01 9b 01 01 56 04    	add    %ebx,0x4560101(%ebx)
 3d6:	9b                   	fwait
 3d7:	01 ac 01 06 76 00 73 	add    %ebp,0x73007606(%ecx,%eax,1)
 3de:	00 22                	add    %ah,(%edx)
 3e0:	9f                   	lahf
 3e1:	04 ac                	add    $0xac,%al
 3e3:	01 b2 01 08 76 00    	add    %esi,0x760801(%edx)
 3e9:	73 00                	jae    3eb <PR_BOOTABLE+0x36b>
 3eb:	22 48 1c             	and    0x1c(%eax),%cl
 3ee:	9f                   	lahf
 3ef:	04 b7                	add    $0xb7,%al
 3f1:	01 e5                	add    %esp,%ebp
 3f3:	01 06                	add    %eax,(%esi)
 3f5:	76 00                	jbe    3f7 <PR_BOOTABLE+0x377>
 3f7:	73 00                	jae    3f9 <PR_BOOTABLE+0x379>
 3f9:	22 9f 04 e5 01 e6    	and    -0x19fe1afc(%edi),%bl
 3ff:	01 0a                	add    %ecx,(%edx)
 401:	76 00                	jbe    403 <PR_BOOTABLE+0x383>
 403:	03 8c 90 00 00 06 22 	add    0x22060000(%eax,%edx,4),%ecx
 40a:	9f                   	lahf
 40b:	04 e6                	add    $0xe6,%al
 40d:	01 e8                	add    %ebp,%eax
 40f:	01 0b                	add    %ecx,(%ebx)
 411:	91                   	xchg   %eax,%ecx
 412:	00 06                	add    %al,(%esi)
 414:	03 8c 90 00 00 06 22 	add    0x22060000(%eax,%edx,4),%ecx
 41b:	9f                   	lahf
 41c:	00 01                	add    %al,(%ecx)
 41e:	00 00                	add    %al,(%eax)
 420:	00 00                	add    %al,(%eax)
 422:	02 02                	add    (%edx),%al
 424:	00 00                	add    %al,(%eax)
 426:	00 04 89             	add    %al,(%ecx,%ecx,4)
 429:	01 9b 01 02 30 9f    	add    %ebx,-0x60cffdff(%ebx)
 42f:	04 9b                	add    $0x9b,%al
 431:	01 ac 01 01 53 04 ac 	add    %ebp,-0x53fbacff(%ecx,%eax,1)
 438:	01 b2 01 03 73 68    	add    %esi,0x68730301(%edx)
 43e:	9f                   	lahf
 43f:	04 b2                	add    $0xb2,%al
 441:	01 e5                	add    %esp,%ebp
 443:	01 01                	add    %eax,(%ecx)
 445:	53                   	push   %ebx
 446:	04 e5                	add    $0xe5,%al
 448:	01 e8                	add    %ebp,%eax
 44a:	01 05 03 8c 90 00    	add    %eax,0x908c03
 450:	00 00                	add    %al,(%eax)
 452:	00 00                	add    %al,(%eax)
 454:	00 01                	add    %al,(%ecx)
 456:	01 00                	add    %eax,(%eax)
 458:	04 4f                	add    $0x4f,%al
 45a:	5c                   	pop    %esp
 45b:	01 53 04             	add    %edx,0x4(%ebx)
 45e:	5c                   	pop    %esp
 45f:	6a 03                	push   $0x3
 461:	73 60                	jae    4c3 <PR_BOOTABLE+0x443>
 463:	9f                   	lahf
 464:	04 6a                	add    $0x6a,%al
 466:	78 01                	js     469 <PR_BOOTABLE+0x3e9>
 468:	53                   	push   %ebx
 469:	00 00                	add    %al,(%eax)
 46b:	00 04 54             	add    %al,(%esp,%edx,2)
 46e:	79 01                	jns    471 <PR_BOOTABLE+0x3f1>
 470:	56                   	push   %esi
 471:	00 00                	add    %al,(%eax)
 473:	00 04 e8             	add    %al,(%eax,%ebp,8)
 476:	01 80 03 02 91 00    	add    %eax,0x910203(%eax)
 47c:	00 00                	add    %al,(%eax)
 47e:	00 00                	add    %al,(%eax)
 480:	00 04 e8             	add    %al,(%eax,%ebp,8)
 483:	01 86 03 02 91 04    	add    %eax,0x4910203(%esi)
 489:	04 86                	add    $0x86,%al
 48b:	03 8b 03 02 74 08    	add    0x8740203(%ebx),%ecx
 491:	00 00                	add    %al,(%eax)
 493:	00 00                	add    %al,(%eax)
 495:	00 04 e8             	add    %al,(%eax,%ebp,8)
 498:	01 86 03 02 91 08    	add    %eax,0x8910203(%esi)
 49e:	04 86                	add    $0x86,%al
 4a0:	03 8b 03 02 74 0c    	add    0xc740203(%ebx),%ecx
 4a6:	00 03                	add    %al,(%ebx)
 4a8:	00 00                	add    %al,(%eax)
 4aa:	00 04 89             	add    %al,(%ecx,%ecx,4)
 4ad:	02 8e 02 02 30 9f    	add    -0x60cffdfe(%esi),%cl
 4b3:	04 8e                	add    $0x8e,%al
 4b5:	02 ba 02 01 50 00    	add    0x500102(%edx),%bh
 4bb:	02 01                	add    (%ecx),%al
 4bd:	01 00                	add    %eax,(%eax)
 4bf:	00 00                	add    %al,(%eax)
 4c1:	04 89                	add    $0x89,%al
 4c3:	02 a4 02 02 30 9f 04 	add    0x49f3002(%edx,%eax,1),%ah
 4ca:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 4cb:	02 a6 02 01 56 04    	add    0x4560102(%esi),%ah
 4d1:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
 4d2:	02 be 02 02 30 9f    	add    -0x60cffdfe(%esi),%bh
 4d8:	00 00                	add    %al,(%eax)
 4da:	00 00                	add    %al,(%eax)
 4dc:	00 04 e4             	add    %al,(%esp,%eiz,8)
 4df:	02 e8                	add    %al,%ch
 4e1:	02 01                	add    (%ecx),%al
 4e3:	50                   	push   %eax
 4e4:	04 e8                	add    $0xe8,%al
 4e6:	02                   	.byte 0x2
 4e7:	84 03                	test   %al,(%ebx)
 4e9:	01 53 00             	add    %edx,0x0(%ebx)

Disassembly of section .debug_rnglists:

00000000 <.debug_rnglists>:
   0:	43                   	inc    %ebx
   1:	00 00                	add    %al,(%eax)
   3:	00 05 00 04 00 00    	add    %al,0x400
   9:	00 00                	add    %al,(%eax)
   b:	00 04 d8             	add    %al,(%eax,%ebx,8)
   e:	03 d8                	add    %eax,%ebx
  10:	03 04 da             	add    (%edx,%ebx,8),%eax
  13:	03 df                	add    %edi,%ebx
  15:	03 04 e2             	add    (%edx,%eiz,8),%eax
  18:	03 e3                	add    %ebx,%esp
  1a:	03 00                	add    (%eax),%eax
  1c:	04 e3                	add    $0xe3,%al
  1e:	03 e3                	add    %ebx,%esp
  20:	03 04 e5 03 ea 03 04 	add    0x403ea03(,%eiz,8),%eax
  27:	ed                   	in     (%dx),%eax
  28:	03 ee                	add    %esi,%ebp
  2a:	03 00                	add    (%eax),%eax
  2c:	04 ee                	add    $0xee,%al
  2e:	03 ee                	add    %esi,%ebp
  30:	03 04 f0             	add    (%eax,%esi,8),%eax
  33:	03 f5                	add    %ebp,%esi
  35:	03 04 fb             	add    (%ebx,%edi,8),%eax
  38:	03 fc                	add    %esp,%edi
  3a:	03 00                	add    (%eax),%eax
  3c:	04 84                	add    $0x84,%al
  3e:	04 89                	add    $0x89,%al
  40:	04 04                	add    $0x4,%al
  42:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
  45:	04 00                	add    $0x0,%al
