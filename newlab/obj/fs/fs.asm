
obj/fs/fs：     文件格式 elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 cd 1a 00 00       	call   801afe <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800075:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007a:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007b:	b9 00 00 00 00       	mov    $0x0,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800080:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800085:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800086:	a8 a1                	test   $0xa1,%al
  800088:	74 0b                	je     800095 <ide_probe_disk1+0x36>
	     x++)
  80008a:	83 c1 01             	add    $0x1,%ecx
	for (x = 0;
  80008d:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800093:	75 f0                	jne    800085 <ide_probe_disk1+0x26>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800095:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009a:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80009f:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a0:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a6:	0f 9e c3             	setle  %bl
  8000a9:	83 ec 08             	sub    $0x8,%esp
  8000ac:	0f b6 c3             	movzbl %bl,%eax
  8000af:	50                   	push   %eax
  8000b0:	68 60 38 80 00       	push   $0x803860
  8000b5:	e8 7f 1b 00 00       	call   801c39 <cprintf>
	return (x < 1000);
}
  8000ba:	89 d8                	mov    %ebx,%eax
  8000bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000bf:	c9                   	leave  
  8000c0:	c3                   	ret    

008000c1 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000ca:	83 f8 01             	cmp    $0x1,%eax
  8000cd:	77 07                	ja     8000d6 <ide_set_disk+0x15>
		panic("bad disk number");
	diskno = d;
  8000cf:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		panic("bad disk number");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 77 38 80 00       	push   $0x803877
  8000de:	6a 3a                	push   $0x3a
  8000e0:	68 87 38 80 00       	push   $0x803887
  8000e5:	e8 74 1a 00 00       	call   801b5e <_panic>

008000ea <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8000f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  8000fc:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800102:	0f 87 87 00 00 00    	ja     80018f <ide_read+0xa5>

	ide_wait_ready(0);
  800108:	b8 00 00 00 00       	mov    $0x0,%eax
  80010d:	e8 21 ff ff ff       	call   800033 <ide_wait_ready>
  800112:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800117:	89 f0                	mov    %esi,%eax
  800119:	ee                   	out    %al,(%dx)
  80011a:	ba f3 01 00 00       	mov    $0x1f3,%edx
  80011f:	89 f8                	mov    %edi,%eax
  800121:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  800122:	89 f8                	mov    %edi,%eax
  800124:	c1 e8 08             	shr    $0x8,%eax
  800127:	ba f4 01 00 00       	mov    $0x1f4,%edx
  80012c:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  80012d:	89 f8                	mov    %edi,%eax
  80012f:	c1 e8 10             	shr    $0x10,%eax
  800132:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800137:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800138:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  80013f:	c1 e0 04             	shl    $0x4,%eax
  800142:	83 e0 10             	and    $0x10,%eax
  800145:	83 c8 e0             	or     $0xffffffe0,%eax
  800148:	c1 ef 18             	shr    $0x18,%edi
  80014b:	83 e7 0f             	and    $0xf,%edi
  80014e:	09 f8                	or     %edi,%eax
  800150:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800155:	ee                   	out    %al,(%dx)
  800156:	b8 20 00 00 00       	mov    $0x20,%eax
  80015b:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800160:	ee                   	out    %al,(%dx)
  800161:	c1 e6 09             	shl    $0x9,%esi
  800164:	01 de                	add    %ebx,%esi
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800166:	39 f3                	cmp    %esi,%ebx
  800168:	74 3b                	je     8001a5 <ide_read+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  80016a:	b8 01 00 00 00       	mov    $0x1,%eax
  80016f:	e8 bf fe ff ff       	call   800033 <ide_wait_ready>
  800174:	85 c0                	test   %eax,%eax
  800176:	78 32                	js     8001aa <ide_read+0xc0>
	asm volatile("cld\n\trepne\n\tinsl"
  800178:	89 df                	mov    %ebx,%edi
  80017a:	b9 80 00 00 00       	mov    $0x80,%ecx
  80017f:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800184:	fc                   	cld    
  800185:	f2 6d                	repnz insl (%dx),%es:(%edi)
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800187:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80018d:	eb d7                	jmp    800166 <ide_read+0x7c>
	assert(nsecs <= 256);
  80018f:	68 90 38 80 00       	push   $0x803890
  800194:	68 9d 38 80 00       	push   $0x80389d
  800199:	6a 44                	push   $0x44
  80019b:	68 87 38 80 00       	push   $0x803887
  8001a0:	e8 b9 19 00 00       	call   801b5e <_panic>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5f                   	pop    %edi
  8001b0:	5d                   	pop    %ebp
  8001b1:	c3                   	ret    

008001b2 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	57                   	push   %edi
  8001b6:	56                   	push   %esi
  8001b7:	53                   	push   %ebx
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8001be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c1:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c4:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001ca:	0f 87 87 00 00 00    	ja     800257 <ide_write+0xa5>

	ide_wait_ready(0);
  8001d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d5:	e8 59 fe ff ff       	call   800033 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001da:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8001df:	89 f8                	mov    %edi,%eax
  8001e1:	ee                   	out    %al,(%dx)
  8001e2:	ba f3 01 00 00       	mov    $0x1f3,%edx
  8001e7:	89 f0                	mov    %esi,%eax
  8001e9:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001ea:	89 f0                	mov    %esi,%eax
  8001ec:	c1 e8 08             	shr    $0x8,%eax
  8001ef:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8001f4:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001f5:	89 f0                	mov    %esi,%eax
  8001f7:	c1 e8 10             	shr    $0x10,%eax
  8001fa:	ba f5 01 00 00       	mov    $0x1f5,%edx
  8001ff:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800200:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800207:	c1 e0 04             	shl    $0x4,%eax
  80020a:	83 e0 10             	and    $0x10,%eax
  80020d:	83 c8 e0             	or     $0xffffffe0,%eax
  800210:	c1 ee 18             	shr    $0x18,%esi
  800213:	83 e6 0f             	and    $0xf,%esi
  800216:	09 f0                	or     %esi,%eax
  800218:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80021d:	ee                   	out    %al,(%dx)
  80021e:	b8 30 00 00 00       	mov    $0x30,%eax
  800223:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800228:	ee                   	out    %al,(%dx)
  800229:	c1 e7 09             	shl    $0x9,%edi
  80022c:	01 df                	add    %ebx,%edi
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80022e:	39 fb                	cmp    %edi,%ebx
  800230:	74 3b                	je     80026d <ide_write+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  800232:	b8 01 00 00 00       	mov    $0x1,%eax
  800237:	e8 f7 fd ff ff       	call   800033 <ide_wait_ready>
  80023c:	85 c0                	test   %eax,%eax
  80023e:	78 32                	js     800272 <ide_write+0xc0>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800240:	89 de                	mov    %ebx,%esi
  800242:	b9 80 00 00 00       	mov    $0x80,%ecx
  800247:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80024c:	fc                   	cld    
  80024d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80024f:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800255:	eb d7                	jmp    80022e <ide_write+0x7c>
	assert(nsecs <= 256);
  800257:	68 90 38 80 00       	push   $0x803890
  80025c:	68 9d 38 80 00       	push   $0x80389d
  800261:	6a 5d                	push   $0x5d
  800263:	68 87 38 80 00       	push   $0x803887
  800268:	e8 f1 18 00 00       	call   801b5e <_panic>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800282:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800284:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80028a:	89 c6                	mov    %eax,%esi
  80028c:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80028f:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800294:	0f 87 95 00 00 00    	ja     80032f <bc_pgfault+0xb5>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80029a:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	74 09                	je     8002ac <bc_pgfault+0x32>
  8002a3:	39 70 04             	cmp    %esi,0x4(%eax)
  8002a6:	0f 86 9e 00 00 00    	jbe    80034a <bc_pgfault+0xd0>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	addr = ROUNDDOWN(addr, PGSIZE);
  8002ac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
        if ((r = sys_page_alloc(0, addr, PTE_U | PTE_P | PTE_W)) < 0)
  8002b2:	83 ec 04             	sub    $0x4,%esp
  8002b5:	6a 07                	push   $0x7
  8002b7:	53                   	push   %ebx
  8002b8:	6a 00                	push   $0x0
  8002ba:	e8 5d 23 00 00       	call   80261c <sys_page_alloc>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	85 c0                	test   %eax,%eax
  8002c4:	0f 88 92 00 00 00    	js     80035c <bc_pgfault+0xe2>
                panic("in bc_pgfault, sys_page_alloc: %e", r);

        if ((r = ide_read(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	6a 08                	push   $0x8
  8002cf:	53                   	push   %ebx
  8002d0:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  8002d7:	50                   	push   %eax
  8002d8:	e8 0d fe ff ff       	call   8000ea <ide_read>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	85 c0                	test   %eax,%eax
  8002e2:	0f 88 86 00 00 00    	js     80036e <bc_pgfault+0xf4>
                panic("in bc_pgfault, ide_read: %e", r);

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8002e8:	89 d8                	mov    %ebx,%eax
  8002ea:	c1 e8 0c             	shr    $0xc,%eax
  8002ed:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8002fc:	50                   	push   %eax
  8002fd:	53                   	push   %ebx
  8002fe:	6a 00                	push   $0x0
  800300:	53                   	push   %ebx
  800301:	6a 00                	push   $0x0
  800303:	e8 57 23 00 00       	call   80265f <sys_page_map>
  800308:	83 c4 20             	add    $0x20,%esp
  80030b:	85 c0                	test   %eax,%eax
  80030d:	78 71                	js     800380 <bc_pgfault+0x106>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  80030f:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  800316:	74 10                	je     800328 <bc_pgfault+0xae>
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	56                   	push   %esi
  80031c:	e8 df 04 00 00       	call   800800 <block_is_free>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	84 c0                	test   %al,%al
  800326:	75 6a                	jne    800392 <bc_pgfault+0x118>
		panic("reading free block %08x\n", blockno);
}
  800328:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	ff 72 04             	pushl  0x4(%edx)
  800335:	53                   	push   %ebx
  800336:	ff 72 28             	pushl  0x28(%edx)
  800339:	68 b4 38 80 00       	push   $0x8038b4
  80033e:	6a 27                	push   $0x27
  800340:	68 94 39 80 00       	push   $0x803994
  800345:	e8 14 18 00 00       	call   801b5e <_panic>
		panic("reading non-existent block %08x\n", blockno);
  80034a:	56                   	push   %esi
  80034b:	68 e4 38 80 00       	push   $0x8038e4
  800350:	6a 2b                	push   $0x2b
  800352:	68 94 39 80 00       	push   $0x803994
  800357:	e8 02 18 00 00       	call   801b5e <_panic>
                panic("in bc_pgfault, sys_page_alloc: %e", r);
  80035c:	50                   	push   %eax
  80035d:	68 08 39 80 00       	push   $0x803908
  800362:	6a 35                	push   $0x35
  800364:	68 94 39 80 00       	push   $0x803994
  800369:	e8 f0 17 00 00       	call   801b5e <_panic>
                panic("in bc_pgfault, ide_read: %e", r);
  80036e:	50                   	push   %eax
  80036f:	68 9c 39 80 00       	push   $0x80399c
  800374:	6a 38                	push   $0x38
  800376:	68 94 39 80 00       	push   $0x803994
  80037b:	e8 de 17 00 00       	call   801b5e <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800380:	50                   	push   %eax
  800381:	68 2c 39 80 00       	push   $0x80392c
  800386:	6a 3d                	push   $0x3d
  800388:	68 94 39 80 00       	push   $0x803994
  80038d:	e8 cc 17 00 00       	call   801b5e <_panic>
		panic("reading free block %08x\n", blockno);
  800392:	56                   	push   %esi
  800393:	68 b8 39 80 00       	push   $0x8039b8
  800398:	6a 43                	push   $0x43
  80039a:	68 94 39 80 00       	push   $0x803994
  80039f:	e8 ba 17 00 00       	call   801b5e <_panic>

008003a4 <diskaddr>:
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 08             	sub    $0x8,%esp
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8003ad:	85 c0                	test   %eax,%eax
  8003af:	74 19                	je     8003ca <diskaddr+0x26>
  8003b1:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  8003b7:	85 d2                	test   %edx,%edx
  8003b9:	74 05                	je     8003c0 <diskaddr+0x1c>
  8003bb:	39 42 04             	cmp    %eax,0x4(%edx)
  8003be:	76 0a                	jbe    8003ca <diskaddr+0x26>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  8003c0:	05 00 00 01 00       	add    $0x10000,%eax
  8003c5:	c1 e0 0c             	shl    $0xc,%eax
}
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  8003ca:	50                   	push   %eax
  8003cb:	68 4c 39 80 00       	push   $0x80394c
  8003d0:	6a 09                	push   $0x9
  8003d2:	68 94 39 80 00       	push   $0x803994
  8003d7:	e8 82 17 00 00       	call   801b5e <_panic>

008003dc <va_is_mapped>:
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  8003e2:	89 d0                	mov    %edx,%eax
  8003e4:	c1 e8 16             	shr    $0x16,%eax
  8003e7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  8003ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f3:	f6 c1 01             	test   $0x1,%cl
  8003f6:	74 0d                	je     800405 <va_is_mapped+0x29>
  8003f8:	c1 ea 0c             	shr    $0xc,%edx
  8003fb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800402:	83 e0 01             	and    $0x1,%eax
  800405:	83 e0 01             	and    $0x1,%eax
}
  800408:	5d                   	pop    %ebp
  800409:	c3                   	ret    

0080040a <va_is_dirty>:
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	c1 e8 0c             	shr    $0xc,%eax
  800413:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80041a:	c1 e8 06             	shr    $0x6,%eax
  80041d:	83 e0 01             	and    $0x1,%eax
}
  800420:	5d                   	pop    %ebp
  800421:	c3                   	ret    

00800422 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	56                   	push   %esi
  800426:	53                   	push   %ebx
  800427:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t r;
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80042a:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  800430:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800435:	77 1f                	ja     800456 <flush_block+0x34>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	//panic("flush_block not implemented");
	addr = ROUNDDOWN(addr, PGSIZE);
  800437:	89 de                	mov    %ebx,%esi
  800439:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        if (va_is_mapped(addr) && va_is_dirty(addr)) {
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	56                   	push   %esi
  800443:	e8 94 ff ff ff       	call   8003dc <va_is_mapped>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	84 c0                	test   %al,%al
  80044d:	75 19                	jne    800468 <flush_block+0x46>
                        panic("in flush_block, ide_write: %e", r);
                if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
                        panic("in flush_block, sys_page_map: %e", r);
        }

}
  80044f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800452:	5b                   	pop    %ebx
  800453:	5e                   	pop    %esi
  800454:	5d                   	pop    %ebp
  800455:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  800456:	53                   	push   %ebx
  800457:	68 d1 39 80 00       	push   $0x8039d1
  80045c:	6a 54                	push   $0x54
  80045e:	68 94 39 80 00       	push   $0x803994
  800463:	e8 f6 16 00 00       	call   801b5e <_panic>
        if (va_is_mapped(addr) && va_is_dirty(addr)) {
  800468:	83 ec 0c             	sub    $0xc,%esp
  80046b:	56                   	push   %esi
  80046c:	e8 99 ff ff ff       	call   80040a <va_is_dirty>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	84 c0                	test   %al,%al
  800476:	74 d7                	je     80044f <flush_block+0x2d>
                if ((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	6a 08                	push   $0x8
  80047d:	56                   	push   %esi
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  80047e:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
  800484:	c1 eb 0c             	shr    $0xc,%ebx
                if ((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  800487:	c1 e3 03             	shl    $0x3,%ebx
  80048a:	53                   	push   %ebx
  80048b:	e8 22 fd ff ff       	call   8001b2 <ide_write>
                if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800490:	89 f0                	mov    %esi,%eax
  800492:	c1 e8 0c             	shr    $0xc,%eax
  800495:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80049c:	25 07 0e 00 00       	and    $0xe07,%eax
  8004a1:	89 04 24             	mov    %eax,(%esp)
  8004a4:	56                   	push   %esi
  8004a5:	6a 00                	push   $0x0
  8004a7:	56                   	push   %esi
  8004a8:	6a 00                	push   $0x0
  8004aa:	e8 b0 21 00 00       	call   80265f <sys_page_map>
  8004af:	83 c4 20             	add    $0x20,%esp
}
  8004b2:	eb 9b                	jmp    80044f <flush_block+0x2d>

008004b4 <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	53                   	push   %ebx
  8004b8:	81 ec 20 02 00 00    	sub    $0x220,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  8004be:	68 7a 02 80 00       	push   $0x80027a
  8004c3:	e8 45 23 00 00       	call   80280d <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  8004c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8004cf:	e8 d0 fe ff ff       	call   8003a4 <diskaddr>
  8004d4:	83 c4 0c             	add    $0xc,%esp
  8004d7:	68 08 01 00 00       	push   $0x108
  8004dc:	50                   	push   %eax
  8004dd:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	e8 c8 1e 00 00       	call   8023b1 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  8004e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8004f0:	e8 af fe ff ff       	call   8003a4 <diskaddr>
  8004f5:	83 c4 08             	add    $0x8,%esp
  8004f8:	68 ec 39 80 00       	push   $0x8039ec
  8004fd:	50                   	push   %eax
  8004fe:	e8 20 1d 00 00       	call   802223 <strcpy>
	flush_block(diskaddr(1));
  800503:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80050a:	e8 95 fe ff ff       	call   8003a4 <diskaddr>
  80050f:	89 04 24             	mov    %eax,(%esp)
  800512:	e8 0b ff ff ff       	call   800422 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800517:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80051e:	e8 81 fe ff ff       	call   8003a4 <diskaddr>
  800523:	89 04 24             	mov    %eax,(%esp)
  800526:	e8 b1 fe ff ff       	call   8003dc <va_is_mapped>
  80052b:	83 c4 10             	add    $0x10,%esp
  80052e:	84 c0                	test   %al,%al
  800530:	0f 84 d1 01 00 00    	je     800707 <bc_init+0x253>
	assert(!va_is_dirty(diskaddr(1)));
  800536:	83 ec 0c             	sub    $0xc,%esp
  800539:	6a 01                	push   $0x1
  80053b:	e8 64 fe ff ff       	call   8003a4 <diskaddr>
  800540:	89 04 24             	mov    %eax,(%esp)
  800543:	e8 c2 fe ff ff       	call   80040a <va_is_dirty>
  800548:	83 c4 10             	add    $0x10,%esp
  80054b:	84 c0                	test   %al,%al
  80054d:	0f 85 ca 01 00 00    	jne    80071d <bc_init+0x269>
	sys_page_unmap(0, diskaddr(1));
  800553:	83 ec 0c             	sub    $0xc,%esp
  800556:	6a 01                	push   $0x1
  800558:	e8 47 fe ff ff       	call   8003a4 <diskaddr>
  80055d:	83 c4 08             	add    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	6a 00                	push   $0x0
  800563:	e8 39 21 00 00       	call   8026a1 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800568:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80056f:	e8 30 fe ff ff       	call   8003a4 <diskaddr>
  800574:	89 04 24             	mov    %eax,(%esp)
  800577:	e8 60 fe ff ff       	call   8003dc <va_is_mapped>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	84 c0                	test   %al,%al
  800581:	0f 85 ac 01 00 00    	jne    800733 <bc_init+0x27f>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800587:	83 ec 0c             	sub    $0xc,%esp
  80058a:	6a 01                	push   $0x1
  80058c:	e8 13 fe ff ff       	call   8003a4 <diskaddr>
  800591:	83 c4 08             	add    $0x8,%esp
  800594:	68 ec 39 80 00       	push   $0x8039ec
  800599:	50                   	push   %eax
  80059a:	e8 2a 1d 00 00       	call   8022c9 <strcmp>
  80059f:	83 c4 10             	add    $0x10,%esp
  8005a2:	85 c0                	test   %eax,%eax
  8005a4:	0f 85 9f 01 00 00    	jne    800749 <bc_init+0x295>
	memmove(diskaddr(1), &backup, sizeof backup);
  8005aa:	83 ec 0c             	sub    $0xc,%esp
  8005ad:	6a 01                	push   $0x1
  8005af:	e8 f0 fd ff ff       	call   8003a4 <diskaddr>
  8005b4:	83 c4 0c             	add    $0xc,%esp
  8005b7:	68 08 01 00 00       	push   $0x108
  8005bc:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  8005c2:	53                   	push   %ebx
  8005c3:	50                   	push   %eax
  8005c4:	e8 e8 1d 00 00       	call   8023b1 <memmove>
	flush_block(diskaddr(1));
  8005c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005d0:	e8 cf fd ff ff       	call   8003a4 <diskaddr>
  8005d5:	89 04 24             	mov    %eax,(%esp)
  8005d8:	e8 45 fe ff ff       	call   800422 <flush_block>
	memmove(&backup, diskaddr(1), sizeof backup);
  8005dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005e4:	e8 bb fd ff ff       	call   8003a4 <diskaddr>
  8005e9:	83 c4 0c             	add    $0xc,%esp
  8005ec:	68 08 01 00 00       	push   $0x108
  8005f1:	50                   	push   %eax
  8005f2:	53                   	push   %ebx
  8005f3:	e8 b9 1d 00 00       	call   8023b1 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  8005f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005ff:	e8 a0 fd ff ff       	call   8003a4 <diskaddr>
  800604:	83 c4 08             	add    $0x8,%esp
  800607:	68 ec 39 80 00       	push   $0x8039ec
  80060c:	50                   	push   %eax
  80060d:	e8 11 1c 00 00       	call   802223 <strcpy>
	flush_block(diskaddr(1) + 20);
  800612:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800619:	e8 86 fd ff ff       	call   8003a4 <diskaddr>
  80061e:	83 c0 14             	add    $0x14,%eax
  800621:	89 04 24             	mov    %eax,(%esp)
  800624:	e8 f9 fd ff ff       	call   800422 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800629:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800630:	e8 6f fd ff ff       	call   8003a4 <diskaddr>
  800635:	89 04 24             	mov    %eax,(%esp)
  800638:	e8 9f fd ff ff       	call   8003dc <va_is_mapped>
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	84 c0                	test   %al,%al
  800642:	0f 84 17 01 00 00    	je     80075f <bc_init+0x2ab>
	sys_page_unmap(0, diskaddr(1));
  800648:	83 ec 0c             	sub    $0xc,%esp
  80064b:	6a 01                	push   $0x1
  80064d:	e8 52 fd ff ff       	call   8003a4 <diskaddr>
  800652:	83 c4 08             	add    $0x8,%esp
  800655:	50                   	push   %eax
  800656:	6a 00                	push   $0x0
  800658:	e8 44 20 00 00       	call   8026a1 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  80065d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800664:	e8 3b fd ff ff       	call   8003a4 <diskaddr>
  800669:	89 04 24             	mov    %eax,(%esp)
  80066c:	e8 6b fd ff ff       	call   8003dc <va_is_mapped>
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	84 c0                	test   %al,%al
  800676:	0f 85 fc 00 00 00    	jne    800778 <bc_init+0x2c4>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80067c:	83 ec 0c             	sub    $0xc,%esp
  80067f:	6a 01                	push   $0x1
  800681:	e8 1e fd ff ff       	call   8003a4 <diskaddr>
  800686:	83 c4 08             	add    $0x8,%esp
  800689:	68 ec 39 80 00       	push   $0x8039ec
  80068e:	50                   	push   %eax
  80068f:	e8 35 1c 00 00       	call   8022c9 <strcmp>
  800694:	83 c4 10             	add    $0x10,%esp
  800697:	85 c0                	test   %eax,%eax
  800699:	0f 85 f2 00 00 00    	jne    800791 <bc_init+0x2dd>
	memmove(diskaddr(1), &backup, sizeof backup);
  80069f:	83 ec 0c             	sub    $0xc,%esp
  8006a2:	6a 01                	push   $0x1
  8006a4:	e8 fb fc ff ff       	call   8003a4 <diskaddr>
  8006a9:	83 c4 0c             	add    $0xc,%esp
  8006ac:	68 08 01 00 00       	push   $0x108
  8006b1:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	e8 f3 1c 00 00       	call   8023b1 <memmove>
	flush_block(diskaddr(1));
  8006be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006c5:	e8 da fc ff ff       	call   8003a4 <diskaddr>
  8006ca:	89 04 24             	mov    %eax,(%esp)
  8006cd:	e8 50 fd ff ff       	call   800422 <flush_block>
	cprintf("block cache is good\n");
  8006d2:	c7 04 24 28 3a 80 00 	movl   $0x803a28,(%esp)
  8006d9:	e8 5b 15 00 00       	call   801c39 <cprintf>
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  8006de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006e5:	e8 ba fc ff ff       	call   8003a4 <diskaddr>
  8006ea:	83 c4 0c             	add    $0xc,%esp
  8006ed:	68 08 01 00 00       	push   $0x108
  8006f2:	50                   	push   %eax
  8006f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f9:	50                   	push   %eax
  8006fa:	e8 b2 1c 00 00       	call   8023b1 <memmove>
}
  8006ff:	83 c4 10             	add    $0x10,%esp
  800702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800705:	c9                   	leave  
  800706:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  800707:	68 0e 3a 80 00       	push   $0x803a0e
  80070c:	68 9d 38 80 00       	push   $0x80389d
  800711:	6a 6f                	push   $0x6f
  800713:	68 94 39 80 00       	push   $0x803994
  800718:	e8 41 14 00 00       	call   801b5e <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  80071d:	68 f3 39 80 00       	push   $0x8039f3
  800722:	68 9d 38 80 00       	push   $0x80389d
  800727:	6a 70                	push   $0x70
  800729:	68 94 39 80 00       	push   $0x803994
  80072e:	e8 2b 14 00 00       	call   801b5e <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800733:	68 0d 3a 80 00       	push   $0x803a0d
  800738:	68 9d 38 80 00       	push   $0x80389d
  80073d:	6a 74                	push   $0x74
  80073f:	68 94 39 80 00       	push   $0x803994
  800744:	e8 15 14 00 00       	call   801b5e <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800749:	68 70 39 80 00       	push   $0x803970
  80074e:	68 9d 38 80 00       	push   $0x80389d
  800753:	6a 77                	push   $0x77
  800755:	68 94 39 80 00       	push   $0x803994
  80075a:	e8 ff 13 00 00       	call   801b5e <_panic>
	assert(va_is_mapped(diskaddr(1)));
  80075f:	68 0e 3a 80 00       	push   $0x803a0e
  800764:	68 9d 38 80 00       	push   $0x80389d
  800769:	68 88 00 00 00       	push   $0x88
  80076e:	68 94 39 80 00       	push   $0x803994
  800773:	e8 e6 13 00 00       	call   801b5e <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800778:	68 0d 3a 80 00       	push   $0x803a0d
  80077d:	68 9d 38 80 00       	push   $0x80389d
  800782:	68 90 00 00 00       	push   $0x90
  800787:	68 94 39 80 00       	push   $0x803994
  80078c:	e8 cd 13 00 00       	call   801b5e <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800791:	68 70 39 80 00       	push   $0x803970
  800796:	68 9d 38 80 00       	push   $0x80389d
  80079b:	68 93 00 00 00       	push   $0x93
  8007a0:	68 94 39 80 00       	push   $0x803994
  8007a5:	e8 b4 13 00 00       	call   801b5e <_panic>

008007aa <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  8007b0:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8007b5:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8007bb:	75 1b                	jne    8007d8 <check_super+0x2e>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  8007bd:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8007c4:	77 26                	ja     8007ec <check_super+0x42>
		panic("file system is too large");

	cprintf("superblock is good\n");
  8007c6:	83 ec 0c             	sub    $0xc,%esp
  8007c9:	68 7b 3a 80 00       	push   $0x803a7b
  8007ce:	e8 66 14 00 00       	call   801c39 <cprintf>
}
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    
		panic("bad file system magic number");
  8007d8:	83 ec 04             	sub    $0x4,%esp
  8007db:	68 3d 3a 80 00       	push   $0x803a3d
  8007e0:	6a 0f                	push   $0xf
  8007e2:	68 5a 3a 80 00       	push   $0x803a5a
  8007e7:	e8 72 13 00 00       	call   801b5e <_panic>
		panic("file system is too large");
  8007ec:	83 ec 04             	sub    $0x4,%esp
  8007ef:	68 62 3a 80 00       	push   $0x803a62
  8007f4:	6a 12                	push   $0x12
  8007f6:	68 5a 3a 80 00       	push   $0x803a5a
  8007fb:	e8 5e 13 00 00       	call   801b5e <_panic>

00800800 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	53                   	push   %ebx
  800804:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  800807:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
		return 0;
  80080d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (super == 0 || blockno >= super->s_nblocks)
  800812:	85 d2                	test   %edx,%edx
  800814:	74 1d                	je     800833 <block_is_free+0x33>
  800816:	39 4a 04             	cmp    %ecx,0x4(%edx)
  800819:	76 18                	jbe    800833 <block_is_free+0x33>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  80081b:	89 cb                	mov    %ecx,%ebx
  80081d:	c1 eb 05             	shr    $0x5,%ebx
  800820:	b8 01 00 00 00       	mov    $0x1,%eax
  800825:	d3 e0                	shl    %cl,%eax
  800827:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  80082d:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  800830:	0f 95 c0             	setne  %al
		return 1;
	return 0;
}
  800833:	5b                   	pop    %ebx
  800834:	5d                   	pop    %ebp
  800835:	c3                   	ret    

00800836 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	53                   	push   %ebx
  80083a:	83 ec 04             	sub    $0x4,%esp
  80083d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800840:	85 c9                	test   %ecx,%ecx
  800842:	74 1a                	je     80085e <free_block+0x28>
		panic("attempt to free zero block");
	bitmap[blockno/32] |= 1<<(blockno%32);
  800844:	89 cb                	mov    %ecx,%ebx
  800846:	c1 eb 05             	shr    $0x5,%ebx
  800849:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  80084f:	b8 01 00 00 00       	mov    $0x1,%eax
  800854:	d3 e0                	shl    %cl,%eax
  800856:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  800859:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085c:	c9                   	leave  
  80085d:	c3                   	ret    
		panic("attempt to free zero block");
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	68 8f 3a 80 00       	push   $0x803a8f
  800866:	6a 2d                	push   $0x2d
  800868:	68 5a 3a 80 00       	push   $0x803a5a
  80086d:	e8 ec 12 00 00       	call   801b5e <_panic>

00800872 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	56                   	push   %esi
  800876:	53                   	push   %ebx

	// LAB 5: Your code here.
	//panic("alloc_block not implemented");
	uint32_t blockno;

        for (blockno = 0; blockno < super->s_nblocks; blockno++) {
  800877:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80087c:	8b 70 04             	mov    0x4(%eax),%esi
  80087f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800884:	39 de                	cmp    %ebx,%esi
  800886:	74 3e                	je     8008c6 <alloc_block+0x54>
                if (block_is_free(blockno)) {
  800888:	53                   	push   %ebx
  800889:	e8 72 ff ff ff       	call   800800 <block_is_free>
  80088e:	83 c4 04             	add    $0x4,%esp
  800891:	84 c0                	test   %al,%al
  800893:	75 05                	jne    80089a <alloc_block+0x28>
        for (blockno = 0; blockno < super->s_nblocks; blockno++) {
  800895:	83 c3 01             	add    $0x1,%ebx
  800898:	eb ea                	jmp    800884 <alloc_block+0x12>
                        bitmap[blockno/32] ^= 1<<(blockno%32);
  80089a:	89 de                	mov    %ebx,%esi
  80089c:	c1 ee 05             	shr    $0x5,%esi
  80089f:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  8008a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8008aa:	89 d9                	mov    %ebx,%ecx
  8008ac:	d3 e0                	shl    %cl,%eax
  8008ae:	31 04 b2             	xor    %eax,(%edx,%esi,4)
                        flush_block(bitmap);
  8008b1:	83 ec 0c             	sub    $0xc,%esp
  8008b4:	ff 35 04 a0 80 00    	pushl  0x80a004
  8008ba:	e8 63 fb ff ff       	call   800422 <flush_block>
                        return blockno;
  8008bf:	89 d8                	mov    %ebx,%eax
  8008c1:	83 c4 10             	add    $0x10,%esp
  8008c4:	eb 05                	jmp    8008cb <alloc_block+0x59>
                }
        }

	return -E_NO_DISK;
  8008c6:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
}
  8008cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ce:	5b                   	pop    %ebx
  8008cf:	5e                   	pop    %esi
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	57                   	push   %edi
  8008d6:	56                   	push   %esi
  8008d7:	53                   	push   %ebx
  8008d8:	83 ec 1c             	sub    $0x1c,%esp
  8008db:	89 c6                	mov    %eax,%esi
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
       // LAB 5: Your code here.
       //panic("file_block_walk not implemented");
	int r;

       if (filebno >= NDIRECT + NINDIRECT)
  8008e0:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  8008e6:	0f 87 a8 00 00 00    	ja     800994 <file_block_walk+0xc2>
               return -E_INVAL;
       if (filebno < NDIRECT) {
  8008ec:	83 fa 09             	cmp    $0x9,%edx
  8008ef:	77 1f                	ja     800910 <file_block_walk+0x3e>
               if (ppdiskbno)
                       *ppdiskbno = f->f_direct + filebno;
               return 0;
  8008f1:	b8 00 00 00 00       	mov    $0x0,%eax
               if (ppdiskbno)
  8008f6:	85 c9                	test   %ecx,%ecx
  8008f8:	74 0e                	je     800908 <file_block_walk+0x36>
                       *ppdiskbno = f->f_direct + filebno;
  8008fa:	8d 84 96 88 00 00 00 	lea    0x88(%esi,%edx,4),%eax
  800901:	89 01                	mov    %eax,(%ecx)
               return 0;
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
       }
       if (ppdiskbno)
               *ppdiskbno = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
       return 0;

}
  800908:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80090b:	5b                   	pop    %ebx
  80090c:	5e                   	pop    %esi
  80090d:	5f                   	pop    %edi
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    
  800910:	89 cb                	mov    %ecx,%ebx
  800912:	89 55 e4             	mov    %edx,-0x1c(%ebp)
       if (!alloc && !f->f_indirect)
  800915:	84 c0                	test   %al,%al
  800917:	75 33                	jne    80094c <file_block_walk+0x7a>
  800919:	83 be b0 00 00 00 00 	cmpl   $0x0,0xb0(%esi)
  800920:	74 7c                	je     80099e <file_block_walk+0xcc>
       return 0;
  800922:	b8 00 00 00 00       	mov    $0x0,%eax
       if (ppdiskbno)
  800927:	85 db                	test   %ebx,%ebx
  800929:	74 dd                	je     800908 <file_block_walk+0x36>
               *ppdiskbno = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
  80092b:	83 ec 0c             	sub    $0xc,%esp
  80092e:	ff b6 b0 00 00 00    	pushl  0xb0(%esi)
  800934:	e8 6b fa ff ff       	call   8003a4 <diskaddr>
  800939:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80093c:	8d 44 b8 d8          	lea    -0x28(%eax,%edi,4),%eax
  800940:	89 03                	mov    %eax,(%ebx)
  800942:	83 c4 10             	add    $0x10,%esp
       return 0;
  800945:	b8 00 00 00 00       	mov    $0x0,%eax
  80094a:	eb bc                	jmp    800908 <file_block_walk+0x36>
       if (!f->f_indirect) {
  80094c:	83 be b0 00 00 00 00 	cmpl   $0x0,0xb0(%esi)
  800953:	75 cd                	jne    800922 <file_block_walk+0x50>
               if ((r = alloc_block()) < 0)
  800955:	e8 18 ff ff ff       	call   800872 <alloc_block>
  80095a:	89 c7                	mov    %eax,%edi
  80095c:	85 c0                	test   %eax,%eax
  80095e:	78 48                	js     8009a8 <file_block_walk+0xd6>
               f->f_indirect = r;
  800960:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
               memset(diskaddr(r), 0, BLKSIZE);
  800966:	83 ec 0c             	sub    $0xc,%esp
  800969:	50                   	push   %eax
  80096a:	e8 35 fa ff ff       	call   8003a4 <diskaddr>
  80096f:	83 c4 0c             	add    $0xc,%esp
  800972:	68 00 10 00 00       	push   $0x1000
  800977:	6a 00                	push   $0x0
  800979:	50                   	push   %eax
  80097a:	e8 e5 19 00 00       	call   802364 <memset>
               flush_block(diskaddr(r));
  80097f:	89 3c 24             	mov    %edi,(%esp)
  800982:	e8 1d fa ff ff       	call   8003a4 <diskaddr>
  800987:	89 04 24             	mov    %eax,(%esp)
  80098a:	e8 93 fa ff ff       	call   800422 <flush_block>
  80098f:	83 c4 10             	add    $0x10,%esp
  800992:	eb 8e                	jmp    800922 <file_block_walk+0x50>
               return -E_INVAL;
  800994:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800999:	e9 6a ff ff ff       	jmp    800908 <file_block_walk+0x36>
               return -E_NOT_FOUND;
  80099e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8009a3:	e9 60 ff ff ff       	jmp    800908 <file_block_walk+0x36>
                       return -E_NO_DISK;
  8009a8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8009ad:	e9 56 ff ff ff       	jmp    800908 <file_block_walk+0x36>

008009b2 <check_bitmap>:
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	56                   	push   %esi
  8009b6:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8009b7:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8009bc:	8b 70 04             	mov    0x4(%eax),%esi
  8009bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009c4:	89 d8                	mov    %ebx,%eax
  8009c6:	c1 e0 0f             	shl    $0xf,%eax
  8009c9:	39 c6                	cmp    %eax,%esi
  8009cb:	76 2b                	jbe    8009f8 <check_bitmap+0x46>
		assert(!block_is_free(2+i));
  8009cd:	8d 43 02             	lea    0x2(%ebx),%eax
  8009d0:	50                   	push   %eax
  8009d1:	e8 2a fe ff ff       	call   800800 <block_is_free>
  8009d6:	83 c4 04             	add    $0x4,%esp
  8009d9:	84 c0                	test   %al,%al
  8009db:	75 05                	jne    8009e2 <check_bitmap+0x30>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8009dd:	83 c3 01             	add    $0x1,%ebx
  8009e0:	eb e2                	jmp    8009c4 <check_bitmap+0x12>
		assert(!block_is_free(2+i));
  8009e2:	68 aa 3a 80 00       	push   $0x803aaa
  8009e7:	68 9d 38 80 00       	push   $0x80389d
  8009ec:	6a 5a                	push   $0x5a
  8009ee:	68 5a 3a 80 00       	push   $0x803a5a
  8009f3:	e8 66 11 00 00       	call   801b5e <_panic>
	assert(!block_is_free(0));
  8009f8:	83 ec 0c             	sub    $0xc,%esp
  8009fb:	6a 00                	push   $0x0
  8009fd:	e8 fe fd ff ff       	call   800800 <block_is_free>
  800a02:	83 c4 10             	add    $0x10,%esp
  800a05:	84 c0                	test   %al,%al
  800a07:	75 28                	jne    800a31 <check_bitmap+0x7f>
	assert(!block_is_free(1));
  800a09:	83 ec 0c             	sub    $0xc,%esp
  800a0c:	6a 01                	push   $0x1
  800a0e:	e8 ed fd ff ff       	call   800800 <block_is_free>
  800a13:	83 c4 10             	add    $0x10,%esp
  800a16:	84 c0                	test   %al,%al
  800a18:	75 2d                	jne    800a47 <check_bitmap+0x95>
	cprintf("bitmap is good\n");
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	68 e2 3a 80 00       	push   $0x803ae2
  800a22:	e8 12 12 00 00       	call   801c39 <cprintf>
}
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a2d:	5b                   	pop    %ebx
  800a2e:	5e                   	pop    %esi
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    
	assert(!block_is_free(0));
  800a31:	68 be 3a 80 00       	push   $0x803abe
  800a36:	68 9d 38 80 00       	push   $0x80389d
  800a3b:	6a 5d                	push   $0x5d
  800a3d:	68 5a 3a 80 00       	push   $0x803a5a
  800a42:	e8 17 11 00 00       	call   801b5e <_panic>
	assert(!block_is_free(1));
  800a47:	68 d0 3a 80 00       	push   $0x803ad0
  800a4c:	68 9d 38 80 00       	push   $0x80389d
  800a51:	6a 5e                	push   $0x5e
  800a53:	68 5a 3a 80 00       	push   $0x803a5a
  800a58:	e8 01 11 00 00       	call   801b5e <_panic>

00800a5d <fs_init>:
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800a63:	e8 f7 f5 ff ff       	call   80005f <ide_probe_disk1>
  800a68:	84 c0                	test   %al,%al
  800a6a:	75 41                	jne    800aad <fs_init+0x50>
		ide_set_disk(0);
  800a6c:	83 ec 0c             	sub    $0xc,%esp
  800a6f:	6a 00                	push   $0x0
  800a71:	e8 4b f6 ff ff       	call   8000c1 <ide_set_disk>
  800a76:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800a79:	e8 36 fa ff ff       	call   8004b4 <bc_init>
	super = diskaddr(1);
  800a7e:	83 ec 0c             	sub    $0xc,%esp
  800a81:	6a 01                	push   $0x1
  800a83:	e8 1c f9 ff ff       	call   8003a4 <diskaddr>
  800a88:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_super();
  800a8d:	e8 18 fd ff ff       	call   8007aa <check_super>
	bitmap = diskaddr(2);
  800a92:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800a99:	e8 06 f9 ff ff       	call   8003a4 <diskaddr>
  800a9e:	a3 04 a0 80 00       	mov    %eax,0x80a004
	check_bitmap();
  800aa3:	e8 0a ff ff ff       	call   8009b2 <check_bitmap>
}
  800aa8:	83 c4 10             	add    $0x10,%esp
  800aab:	c9                   	leave  
  800aac:	c3                   	ret    
		ide_set_disk(1);
  800aad:	83 ec 0c             	sub    $0xc,%esp
  800ab0:	6a 01                	push   $0x1
  800ab2:	e8 0a f6 ff ff       	call   8000c1 <ide_set_disk>
  800ab7:	83 c4 10             	add    $0x10,%esp
  800aba:	eb bd                	jmp    800a79 <fs_init+0x1c>

00800abc <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	53                   	push   %ebx
  800ac0:	83 ec 20             	sub    $0x20,%esp
       // LAB 5: Your code here.
       //panic("file_get_block not implemented");
       int r;
       uint32_t *ppdiskbno;

       if ((r = file_block_walk(f, filebno, &ppdiskbno, 1)) < 0)
  800ac3:	6a 01                	push   $0x1
  800ac5:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	e8 ff fd ff ff       	call   8008d2 <file_block_walk>
  800ad3:	83 c4 10             	add    $0x10,%esp
  800ad6:	85 c0                	test   %eax,%eax
  800ad8:	78 5e                	js     800b38 <file_get_block+0x7c>
               return r;
       if (*ppdiskbno == 0) {
  800ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800add:	83 38 00             	cmpl   $0x0,(%eax)
  800ae0:	75 3c                	jne    800b1e <file_get_block+0x62>
               if ((r = alloc_block()) < 0)
  800ae2:	e8 8b fd ff ff       	call   800872 <alloc_block>
  800ae7:	89 c3                	mov    %eax,%ebx
  800ae9:	85 c0                	test   %eax,%eax
  800aeb:	78 50                	js     800b3d <file_get_block+0x81>
                       return -E_NO_DISK;
                *ppdiskbno = r;
  800aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af0:	89 18                	mov    %ebx,(%eax)
                memset(diskaddr(r), 0, BLKSIZE);
  800af2:	83 ec 0c             	sub    $0xc,%esp
  800af5:	53                   	push   %ebx
  800af6:	e8 a9 f8 ff ff       	call   8003a4 <diskaddr>
  800afb:	83 c4 0c             	add    $0xc,%esp
  800afe:	68 00 10 00 00       	push   $0x1000
  800b03:	6a 00                	push   $0x0
  800b05:	50                   	push   %eax
  800b06:	e8 59 18 00 00       	call   802364 <memset>
                flush_block(diskaddr(r));
  800b0b:	89 1c 24             	mov    %ebx,(%esp)
  800b0e:	e8 91 f8 ff ff       	call   8003a4 <diskaddr>
  800b13:	89 04 24             	mov    %eax,(%esp)
  800b16:	e8 07 f9 ff ff       	call   800422 <flush_block>
  800b1b:	83 c4 10             	add    $0x10,%esp

       }
       *blk = diskaddr(*ppdiskbno);
  800b1e:	83 ec 0c             	sub    $0xc,%esp
  800b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b24:	ff 30                	pushl  (%eax)
  800b26:	e8 79 f8 ff ff       	call   8003a4 <diskaddr>
  800b2b:	8b 55 10             	mov    0x10(%ebp),%edx
  800b2e:	89 02                	mov    %eax,(%edx)
       return 0;
  800b30:	83 c4 10             	add    $0x10,%esp
  800b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b3b:	c9                   	leave  
  800b3c:	c3                   	ret    
                       return -E_NO_DISK;
  800b3d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800b42:	eb f4                	jmp    800b38 <file_get_block+0x7c>

00800b44 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	57                   	push   %edi
  800b48:	56                   	push   %esi
  800b49:	53                   	push   %ebx
  800b4a:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800b50:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800b56:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
  800b5c:	eb 03                	jmp    800b61 <walk_path+0x1d>
		p++;
  800b5e:	83 c0 01             	add    $0x1,%eax
	while (*p == '/')
  800b61:	80 38 2f             	cmpb   $0x2f,(%eax)
  800b64:	74 f8                	je     800b5e <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800b66:	8b 0d 08 a0 80 00    	mov    0x80a008,%ecx
  800b6c:	83 c1 08             	add    $0x8,%ecx
  800b6f:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  800b75:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800b7c:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800b82:	85 c9                	test   %ecx,%ecx
  800b84:	74 06                	je     800b8c <walk_path+0x48>
		*pdir = 0;
  800b86:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800b8c:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800b92:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	dir = 0;
  800b98:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800b9d:	e9 b4 01 00 00       	jmp    800d56 <walk_path+0x212>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800ba2:	83 c7 01             	add    $0x1,%edi
		while (*path != '/' && *path != '\0')
  800ba5:	0f b6 17             	movzbl (%edi),%edx
  800ba8:	80 fa 2f             	cmp    $0x2f,%dl
  800bab:	74 04                	je     800bb1 <walk_path+0x6d>
  800bad:	84 d2                	test   %dl,%dl
  800baf:	75 f1                	jne    800ba2 <walk_path+0x5e>
		if (path - p >= MAXNAMELEN)
  800bb1:	89 fb                	mov    %edi,%ebx
  800bb3:	29 c3                	sub    %eax,%ebx
  800bb5:	83 fb 7f             	cmp    $0x7f,%ebx
  800bb8:	0f 8f 70 01 00 00    	jg     800d2e <walk_path+0x1ea>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800bbe:	83 ec 04             	sub    $0x4,%esp
  800bc1:	53                   	push   %ebx
  800bc2:	50                   	push   %eax
  800bc3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800bc9:	50                   	push   %eax
  800bca:	e8 e2 17 00 00       	call   8023b1 <memmove>
		name[path - p] = '\0';
  800bcf:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800bd6:	00 
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	eb 03                	jmp    800bdf <walk_path+0x9b>
		p++;
  800bdc:	83 c7 01             	add    $0x1,%edi
	while (*p == '/')
  800bdf:	80 3f 2f             	cmpb   $0x2f,(%edi)
  800be2:	74 f8                	je     800bdc <walk_path+0x98>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800be4:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800bea:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800bf1:	0f 85 3e 01 00 00    	jne    800d35 <walk_path+0x1f1>
	assert((dir->f_size % BLKSIZE) == 0);
  800bf7:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800bfd:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800c02:	0f 85 98 00 00 00    	jne    800ca0 <walk_path+0x15c>
	nblock = dir->f_size / BLKSIZE;
  800c08:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800c0e:	85 c0                	test   %eax,%eax
  800c10:	0f 48 c2             	cmovs  %edx,%eax
  800c13:	c1 f8 0c             	sar    $0xc,%eax
  800c16:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	for (i = 0; i < nblock; i++) {
  800c1c:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  800c23:	00 00 00 
			if (strcmp(f[j].f_name, name) == 0) {
  800c26:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  800c2c:	89 bd 44 ff ff ff    	mov    %edi,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  800c32:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800c38:	39 8d 48 ff ff ff    	cmp    %ecx,-0xb8(%ebp)
  800c3e:	74 79                	je     800cb9 <walk_path+0x175>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800c40:	83 ec 04             	sub    $0x4,%esp
  800c43:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800c49:	50                   	push   %eax
  800c4a:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
  800c50:	ff b5 4c ff ff ff    	pushl  -0xb4(%ebp)
  800c56:	e8 61 fe ff ff       	call   800abc <file_get_block>
  800c5b:	83 c4 10             	add    $0x10,%esp
  800c5e:	85 c0                	test   %eax,%eax
  800c60:	0f 88 fc 00 00 00    	js     800d62 <walk_path+0x21e>
  800c66:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  800c6c:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
			if (strcmp(f[j].f_name, name) == 0) {
  800c72:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
  800c78:	83 ec 08             	sub    $0x8,%esp
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
  800c7d:	e8 47 16 00 00       	call   8022c9 <strcmp>
  800c82:	83 c4 10             	add    $0x10,%esp
  800c85:	85 c0                	test   %eax,%eax
  800c87:	0f 84 af 00 00 00    	je     800d3c <walk_path+0x1f8>
  800c8d:	81 c3 00 01 00 00    	add    $0x100,%ebx
		for (j = 0; j < BLKFILES; j++)
  800c93:	39 fb                	cmp    %edi,%ebx
  800c95:	75 db                	jne    800c72 <walk_path+0x12e>
	for (i = 0; i < nblock; i++) {
  800c97:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800c9e:	eb 92                	jmp    800c32 <walk_path+0xee>
	assert((dir->f_size % BLKSIZE) == 0);
  800ca0:	68 f2 3a 80 00       	push   $0x803af2
  800ca5:	68 9d 38 80 00       	push   $0x80389d
  800caa:	68 da 00 00 00       	push   $0xda
  800caf:	68 5a 3a 80 00       	push   $0x803a5a
  800cb4:	e8 a5 0e 00 00       	call   801b5e <_panic>
  800cb9:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800cbf:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0') {
  800cc4:	80 3f 00             	cmpb   $0x0,(%edi)
  800cc7:	0f 85 a4 00 00 00    	jne    800d71 <walk_path+0x22d>
				if (pdir)
  800ccd:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	74 08                	je     800cdf <walk_path+0x19b>
					*pdir = dir;
  800cd7:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800cdd:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800cdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ce3:	74 15                	je     800cfa <walk_path+0x1b6>
					strcpy(lastelem, name);
  800ce5:	83 ec 08             	sub    $0x8,%esp
  800ce8:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800cee:	50                   	push   %eax
  800cef:	ff 75 08             	pushl  0x8(%ebp)
  800cf2:	e8 2c 15 00 00       	call   802223 <strcpy>
  800cf7:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800cfa:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800d06:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d0b:	eb 64                	jmp    800d71 <walk_path+0x22d>
		}
	}

	if (pdir)
  800d0d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d13:	85 c0                	test   %eax,%eax
  800d15:	74 02                	je     800d19 <walk_path+0x1d5>
		*pdir = dir;
  800d17:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800d19:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d1f:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d25:	89 08                	mov    %ecx,(%eax)
	return 0;
  800d27:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2c:	eb 43                	jmp    800d71 <walk_path+0x22d>
			return -E_BAD_PATH;
  800d2e:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800d33:	eb 3c                	jmp    800d71 <walk_path+0x22d>
			return -E_NOT_FOUND;
  800d35:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d3a:	eb 35                	jmp    800d71 <walk_path+0x22d>
  800d3c:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
  800d42:	89 f8                	mov    %edi,%eax
  800d44:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
			if (strcmp(f[j].f_name, name) == 0) {
  800d4a:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  800d50:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	while (*path != '\0') {
  800d56:	80 38 00             	cmpb   $0x0,(%eax)
  800d59:	74 b2                	je     800d0d <walk_path+0x1c9>
  800d5b:	89 c7                	mov    %eax,%edi
  800d5d:	e9 43 fe ff ff       	jmp    800ba5 <walk_path+0x61>
  800d62:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
			if (r == -E_NOT_FOUND && *path == '\0') {
  800d68:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800d6b:	0f 84 4e ff ff ff    	je     800cbf <walk_path+0x17b>
}
  800d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    

00800d79 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  800d7f:	6a 00                	push   $0x0
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	ba 00 00 00 00       	mov    $0x0,%edx
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	e8 b3 fd ff ff       	call   800b44 <walk_path>
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	83 ec 2c             	sub    $0x2c,%esp
  800d9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d9f:	8b 4d 14             	mov    0x14(%ebp),%ecx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  800dab:	b8 00 00 00 00       	mov    $0x0,%eax
	if (offset >= f->f_size)
  800db0:	39 ca                	cmp    %ecx,%edx
  800db2:	0f 8e 80 00 00 00    	jle    800e38 <file_read+0xa5>

	count = MIN(count, f->f_size - offset);
  800db8:	29 ca                	sub    %ecx,%edx
  800dba:	3b 55 10             	cmp    0x10(%ebp),%edx
  800dbd:	89 d0                	mov    %edx,%eax
  800dbf:	0f 47 45 10          	cmova  0x10(%ebp),%eax
  800dc3:	89 45 d0             	mov    %eax,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800dc6:	89 ce                	mov    %ecx,%esi
  800dc8:	01 c1                	add    %eax,%ecx
  800dca:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800dcd:	89 f3                	mov    %esi,%ebx
  800dcf:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800dd2:	76 61                	jbe    800e35 <file_read+0xa2>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800dd4:	83 ec 04             	sub    $0x4,%esp
  800dd7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800dda:	50                   	push   %eax
  800ddb:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
  800de1:	85 f6                	test   %esi,%esi
  800de3:	0f 49 c6             	cmovns %esi,%eax
  800de6:	c1 f8 0c             	sar    $0xc,%eax
  800de9:	50                   	push   %eax
  800dea:	ff 75 08             	pushl  0x8(%ebp)
  800ded:	e8 ca fc ff ff       	call   800abc <file_get_block>
  800df2:	83 c4 10             	add    $0x10,%esp
  800df5:	85 c0                	test   %eax,%eax
  800df7:	78 3f                	js     800e38 <file_read+0xa5>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800df9:	89 f2                	mov    %esi,%edx
  800dfb:	c1 fa 1f             	sar    $0x1f,%edx
  800dfe:	c1 ea 14             	shr    $0x14,%edx
  800e01:	8d 04 16             	lea    (%esi,%edx,1),%eax
  800e04:	25 ff 0f 00 00       	and    $0xfff,%eax
  800e09:	29 d0                	sub    %edx,%eax
  800e0b:	ba 00 10 00 00       	mov    $0x1000,%edx
  800e10:	29 c2                	sub    %eax,%edx
  800e12:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e15:	29 d9                	sub    %ebx,%ecx
  800e17:	89 cb                	mov    %ecx,%ebx
  800e19:	39 ca                	cmp    %ecx,%edx
  800e1b:	0f 46 da             	cmovbe %edx,%ebx
		memmove(buf, blk + pos % BLKSIZE, bn);
  800e1e:	83 ec 04             	sub    $0x4,%esp
  800e21:	53                   	push   %ebx
  800e22:	03 45 e4             	add    -0x1c(%ebp),%eax
  800e25:	50                   	push   %eax
  800e26:	57                   	push   %edi
  800e27:	e8 85 15 00 00       	call   8023b1 <memmove>
		pos += bn;
  800e2c:	01 de                	add    %ebx,%esi
		buf += bn;
  800e2e:	01 df                	add    %ebx,%edi
  800e30:	83 c4 10             	add    $0x10,%esp
  800e33:	eb 98                	jmp    800dcd <file_read+0x3a>
	}

	return count;
  800e35:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5f                   	pop    %edi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
  800e46:	83 ec 2c             	sub    $0x2c,%esp
  800e49:	8b 75 08             	mov    0x8(%ebp),%esi
	if (f->f_size > newsize)
  800e4c:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800e52:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e55:	7f 1f                	jg     800e76 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	flush_block(f);
  800e60:	83 ec 0c             	sub    $0xc,%esp
  800e63:	56                   	push   %esi
  800e64:	e8 b9 f5 ff ff       	call   800422 <flush_block>
	return 0;
}
  800e69:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800e76:	8d b8 fe 1f 00 00    	lea    0x1ffe(%eax),%edi
  800e7c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800e81:	0f 49 f8             	cmovns %eax,%edi
  800e84:	c1 ff 0c             	sar    $0xc,%edi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	05 fe 1f 00 00       	add    $0x1ffe,%eax
  800e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e92:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800e98:	0f 49 c2             	cmovns %edx,%eax
  800e9b:	c1 f8 0c             	sar    $0xc,%eax
  800e9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800ea1:	89 c3                	mov    %eax,%ebx
  800ea3:	eb 3c                	jmp    800ee1 <file_set_size+0xa1>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800ea5:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
  800ea9:	77 ac                	ja     800e57 <file_set_size+0x17>
  800eab:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800eb1:	85 c0                	test   %eax,%eax
  800eb3:	74 a2                	je     800e57 <file_set_size+0x17>
		free_block(f->f_indirect);
  800eb5:	83 ec 0c             	sub    $0xc,%esp
  800eb8:	50                   	push   %eax
  800eb9:	e8 78 f9 ff ff       	call   800836 <free_block>
		f->f_indirect = 0;
  800ebe:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  800ec5:	00 00 00 
  800ec8:	83 c4 10             	add    $0x10,%esp
  800ecb:	eb 8a                	jmp    800e57 <file_set_size+0x17>
			cprintf("warning: file_free_block: %e", r);
  800ecd:	83 ec 08             	sub    $0x8,%esp
  800ed0:	50                   	push   %eax
  800ed1:	68 0f 3b 80 00       	push   $0x803b0f
  800ed6:	e8 5e 0d 00 00       	call   801c39 <cprintf>
  800edb:	83 c4 10             	add    $0x10,%esp
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800ede:	83 c3 01             	add    $0x1,%ebx
  800ee1:	39 df                	cmp    %ebx,%edi
  800ee3:	76 c0                	jbe    800ea5 <file_set_size+0x65>
	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800ee5:	83 ec 0c             	sub    $0xc,%esp
  800ee8:	6a 00                	push   $0x0
  800eea:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800eed:	89 da                	mov    %ebx,%edx
  800eef:	89 f0                	mov    %esi,%eax
  800ef1:	e8 dc f9 ff ff       	call   8008d2 <file_block_walk>
  800ef6:	83 c4 10             	add    $0x10,%esp
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	78 d0                	js     800ecd <file_set_size+0x8d>
	if (*ptr) {
  800efd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f00:	8b 00                	mov    (%eax),%eax
  800f02:	85 c0                	test   %eax,%eax
  800f04:	74 d8                	je     800ede <file_set_size+0x9e>
		free_block(*ptr);
  800f06:	83 ec 0c             	sub    $0xc,%esp
  800f09:	50                   	push   %eax
  800f0a:	e8 27 f9 ff ff       	call   800836 <free_block>
		*ptr = 0;
  800f0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800f18:	83 c4 10             	add    $0x10,%esp
  800f1b:	eb c1                	jmp    800ede <file_set_size+0x9e>

00800f1d <file_write>:
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	57                   	push   %edi
  800f21:	56                   	push   %esi
  800f22:	53                   	push   %ebx
  800f23:	83 ec 2c             	sub    $0x2c,%esp
  800f26:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f29:	8b 75 14             	mov    0x14(%ebp),%esi
	if (offset + count > f->f_size)
  800f2c:	89 f0                	mov    %esi,%eax
  800f2e:	03 45 10             	add    0x10(%ebp),%eax
  800f31:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800f34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f37:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  800f3d:	77 68                	ja     800fa7 <file_write+0x8a>
	for (pos = offset; pos < offset + count; ) {
  800f3f:	89 f3                	mov    %esi,%ebx
  800f41:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800f44:	76 74                	jbe    800fba <file_write+0x9d>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800f46:	83 ec 04             	sub    $0x4,%esp
  800f49:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f4c:	50                   	push   %eax
  800f4d:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
  800f53:	85 f6                	test   %esi,%esi
  800f55:	0f 49 c6             	cmovns %esi,%eax
  800f58:	c1 f8 0c             	sar    $0xc,%eax
  800f5b:	50                   	push   %eax
  800f5c:	ff 75 08             	pushl  0x8(%ebp)
  800f5f:	e8 58 fb ff ff       	call   800abc <file_get_block>
  800f64:	83 c4 10             	add    $0x10,%esp
  800f67:	85 c0                	test   %eax,%eax
  800f69:	78 52                	js     800fbd <file_write+0xa0>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800f6b:	89 f2                	mov    %esi,%edx
  800f6d:	c1 fa 1f             	sar    $0x1f,%edx
  800f70:	c1 ea 14             	shr    $0x14,%edx
  800f73:	8d 04 16             	lea    (%esi,%edx,1),%eax
  800f76:	25 ff 0f 00 00       	and    $0xfff,%eax
  800f7b:	29 d0                	sub    %edx,%eax
  800f7d:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800f82:	29 c1                	sub    %eax,%ecx
  800f84:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f87:	29 da                	sub    %ebx,%edx
  800f89:	39 d1                	cmp    %edx,%ecx
  800f8b:	89 d3                	mov    %edx,%ebx
  800f8d:	0f 46 d9             	cmovbe %ecx,%ebx
		memmove(blk + pos % BLKSIZE, buf, bn);
  800f90:	83 ec 04             	sub    $0x4,%esp
  800f93:	53                   	push   %ebx
  800f94:	57                   	push   %edi
  800f95:	03 45 e4             	add    -0x1c(%ebp),%eax
  800f98:	50                   	push   %eax
  800f99:	e8 13 14 00 00       	call   8023b1 <memmove>
		pos += bn;
  800f9e:	01 de                	add    %ebx,%esi
		buf += bn;
  800fa0:	01 df                	add    %ebx,%edi
  800fa2:	83 c4 10             	add    $0x10,%esp
  800fa5:	eb 98                	jmp    800f3f <file_write+0x22>
		if ((r = file_set_size(f, offset + count)) < 0)
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	50                   	push   %eax
  800fab:	51                   	push   %ecx
  800fac:	e8 8f fe ff ff       	call   800e40 <file_set_size>
  800fb1:	83 c4 10             	add    $0x10,%esp
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	79 87                	jns    800f3f <file_write+0x22>
  800fb8:	eb 03                	jmp    800fbd <file_write+0xa0>
	return count;
  800fba:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	56                   	push   %esi
  800fc9:	53                   	push   %ebx
  800fca:	83 ec 10             	sub    $0x10,%esp
  800fcd:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800fd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd5:	eb 03                	jmp    800fda <file_flush+0x15>
  800fd7:	83 c3 01             	add    $0x1,%ebx
  800fda:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  800fe0:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  800fe6:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  800fec:	85 c9                	test   %ecx,%ecx
  800fee:	0f 49 c1             	cmovns %ecx,%eax
  800ff1:	c1 f8 0c             	sar    $0xc,%eax
  800ff4:	39 d8                	cmp    %ebx,%eax
  800ff6:	7e 3b                	jle    801033 <file_flush+0x6e>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	6a 00                	push   $0x0
  800ffd:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  801000:	89 da                	mov    %ebx,%edx
  801002:	89 f0                	mov    %esi,%eax
  801004:	e8 c9 f8 ff ff       	call   8008d2 <file_block_walk>
  801009:	83 c4 10             	add    $0x10,%esp
  80100c:	85 c0                	test   %eax,%eax
  80100e:	78 c7                	js     800fd7 <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  801010:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801013:	85 c0                	test   %eax,%eax
  801015:	74 c0                	je     800fd7 <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  801017:	8b 00                	mov    (%eax),%eax
  801019:	85 c0                	test   %eax,%eax
  80101b:	74 ba                	je     800fd7 <file_flush+0x12>
			continue;
		flush_block(diskaddr(*pdiskbno));
  80101d:	83 ec 0c             	sub    $0xc,%esp
  801020:	50                   	push   %eax
  801021:	e8 7e f3 ff ff       	call   8003a4 <diskaddr>
  801026:	89 04 24             	mov    %eax,(%esp)
  801029:	e8 f4 f3 ff ff       	call   800422 <flush_block>
  80102e:	83 c4 10             	add    $0x10,%esp
  801031:	eb a4                	jmp    800fd7 <file_flush+0x12>
	}
	flush_block(f);
  801033:	83 ec 0c             	sub    $0xc,%esp
  801036:	56                   	push   %esi
  801037:	e8 e6 f3 ff ff       	call   800422 <flush_block>
	if (f->f_indirect)
  80103c:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	85 c0                	test   %eax,%eax
  801047:	75 07                	jne    801050 <file_flush+0x8b>
		flush_block(diskaddr(f->f_indirect));
}
  801049:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80104c:	5b                   	pop    %ebx
  80104d:	5e                   	pop    %esi
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  801050:	83 ec 0c             	sub    $0xc,%esp
  801053:	50                   	push   %eax
  801054:	e8 4b f3 ff ff       	call   8003a4 <diskaddr>
  801059:	89 04 24             	mov    %eax,(%esp)
  80105c:	e8 c1 f3 ff ff       	call   800422 <flush_block>
  801061:	83 c4 10             	add    $0x10,%esp
}
  801064:	eb e3                	jmp    801049 <file_flush+0x84>

00801066 <file_create>:
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	57                   	push   %edi
  80106a:	56                   	push   %esi
  80106b:	53                   	push   %ebx
  80106c:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801072:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801078:	50                   	push   %eax
  801079:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  80107f:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	e8 b7 fa ff ff       	call   800b44 <walk_path>
  80108d:	83 c4 10             	add    $0x10,%esp
  801090:	85 c0                	test   %eax,%eax
  801092:	0f 84 0e 01 00 00    	je     8011a6 <file_create+0x140>
	if (r != -E_NOT_FOUND || dir == 0)
  801098:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80109b:	74 08                	je     8010a5 <file_create+0x3f>
}
  80109d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    
	if (r != -E_NOT_FOUND || dir == 0)
  8010a5:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  8010ab:	85 db                	test   %ebx,%ebx
  8010ad:	74 ee                	je     80109d <file_create+0x37>
	assert((dir->f_size % BLKSIZE) == 0);
  8010af:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  8010b5:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8010ba:	75 5c                	jne    801118 <file_create+0xb2>
	nblock = dir->f_size / BLKSIZE;
  8010bc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8010c2:	85 c0                	test   %eax,%eax
  8010c4:	0f 48 c2             	cmovs  %edx,%eax
  8010c7:	c1 f8 0c             	sar    $0xc,%eax
  8010ca:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
  8010d0:	be 00 00 00 00       	mov    $0x0,%esi
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010d5:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
	for (i = 0; i < nblock; i++) {
  8010db:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  8010e1:	0f 84 8b 00 00 00    	je     801172 <file_create+0x10c>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010e7:	83 ec 04             	sub    $0x4,%esp
  8010ea:	57                   	push   %edi
  8010eb:	56                   	push   %esi
  8010ec:	53                   	push   %ebx
  8010ed:	e8 ca f9 ff ff       	call   800abc <file_get_block>
  8010f2:	83 c4 10             	add    $0x10,%esp
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	78 a4                	js     80109d <file_create+0x37>
  8010f9:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8010ff:	8d 88 00 10 00 00    	lea    0x1000(%eax),%ecx
			if (f[j].f_name[0] == '\0') {
  801105:	80 38 00             	cmpb   $0x0,(%eax)
  801108:	74 27                	je     801131 <file_create+0xcb>
  80110a:	05 00 01 00 00       	add    $0x100,%eax
		for (j = 0; j < BLKFILES; j++)
  80110f:	39 c8                	cmp    %ecx,%eax
  801111:	75 f2                	jne    801105 <file_create+0x9f>
	for (i = 0; i < nblock; i++) {
  801113:	83 c6 01             	add    $0x1,%esi
  801116:	eb c3                	jmp    8010db <file_create+0x75>
	assert((dir->f_size % BLKSIZE) == 0);
  801118:	68 f2 3a 80 00       	push   $0x803af2
  80111d:	68 9d 38 80 00       	push   $0x80389d
  801122:	68 f3 00 00 00       	push   $0xf3
  801127:	68 5a 3a 80 00       	push   $0x803a5a
  80112c:	e8 2d 0a 00 00       	call   801b5e <_panic>
				*file = &f[j];
  801131:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  801137:	83 ec 08             	sub    $0x8,%esp
  80113a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801140:	50                   	push   %eax
  801141:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  801147:	e8 d7 10 00 00       	call   802223 <strcpy>
	*pf = f;
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  801155:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  801157:	83 c4 04             	add    $0x4,%esp
  80115a:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
  801160:	e8 60 fe ff ff       	call   800fc5 <file_flush>
	return 0;
  801165:	83 c4 10             	add    $0x10,%esp
  801168:	b8 00 00 00 00       	mov    $0x0,%eax
  80116d:	e9 2b ff ff ff       	jmp    80109d <file_create+0x37>
	dir->f_size += BLKSIZE;
  801172:	81 83 80 00 00 00 00 	addl   $0x1000,0x80(%ebx)
  801179:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  80117c:	83 ec 04             	sub    $0x4,%esp
  80117f:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  801185:	50                   	push   %eax
  801186:	56                   	push   %esi
  801187:	53                   	push   %ebx
  801188:	e8 2f f9 ff ff       	call   800abc <file_get_block>
  80118d:	83 c4 10             	add    $0x10,%esp
  801190:	85 c0                	test   %eax,%eax
  801192:	0f 88 05 ff ff ff    	js     80109d <file_create+0x37>
	*file = &f[0];
  801198:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80119e:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8011a4:	eb 91                	jmp    801137 <file_create+0xd1>
		return -E_FILE_EXISTS;
  8011a6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8011ab:	e9 ed fe ff ff       	jmp    80109d <file_create+0x37>

008011b0 <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	53                   	push   %ebx
  8011b4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8011b7:	bb 01 00 00 00       	mov    $0x1,%ebx
  8011bc:	eb 17                	jmp    8011d5 <fs_sync+0x25>
		flush_block(diskaddr(i));
  8011be:	83 ec 0c             	sub    $0xc,%esp
  8011c1:	53                   	push   %ebx
  8011c2:	e8 dd f1 ff ff       	call   8003a4 <diskaddr>
  8011c7:	89 04 24             	mov    %eax,(%esp)
  8011ca:	e8 53 f2 ff ff       	call   800422 <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  8011cf:	83 c3 01             	add    $0x1,%ebx
  8011d2:	83 c4 10             	add    $0x10,%esp
  8011d5:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8011da:	39 58 04             	cmp    %ebx,0x4(%eax)
  8011dd:	77 df                	ja     8011be <fs_sync+0xe>
}
  8011df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  8011ea:	e8 c1 ff ff ff       	call   8011b0 <fs_sync>
	return 0;
}
  8011ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <serve_init>:
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	ba 60 50 80 00       	mov    $0x805060,%edx
	uintptr_t va = FILEVA;
  8011fe:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  801203:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  801208:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  80120a:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  80120d:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  801213:	83 c0 01             	add    $0x1,%eax
  801216:	83 c2 10             	add    $0x10,%edx
  801219:	3d 00 04 00 00       	cmp    $0x400,%eax
  80121e:	75 e8                	jne    801208 <serve_init+0x12>
}
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <openfile_alloc>:
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	57                   	push   %edi
  801226:	56                   	push   %esi
  801227:	53                   	push   %ebx
  801228:	83 ec 0c             	sub    $0xc,%esp
  80122b:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  80122e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801233:	89 de                	mov    %ebx,%esi
  801235:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  801238:	83 ec 0c             	sub    $0xc,%esp
  80123b:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
  801241:	e8 ba 1e 00 00       	call   803100 <pageref>
  801246:	83 c4 10             	add    $0x10,%esp
  801249:	85 c0                	test   %eax,%eax
  80124b:	74 17                	je     801264 <openfile_alloc+0x42>
  80124d:	83 f8 01             	cmp    $0x1,%eax
  801250:	74 30                	je     801282 <openfile_alloc+0x60>
	for (i = 0; i < MAXOPEN; i++) {
  801252:	83 c3 01             	add    $0x1,%ebx
  801255:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  80125b:	75 d6                	jne    801233 <openfile_alloc+0x11>
	return -E_MAX_OPEN;
  80125d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801262:	eb 4f                	jmp    8012b3 <openfile_alloc+0x91>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801264:	83 ec 04             	sub    $0x4,%esp
  801267:	6a 07                	push   $0x7
  801269:	89 d8                	mov    %ebx,%eax
  80126b:	c1 e0 04             	shl    $0x4,%eax
  80126e:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  801274:	6a 00                	push   $0x0
  801276:	e8 a1 13 00 00       	call   80261c <sys_page_alloc>
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 31                	js     8012b3 <openfile_alloc+0x91>
			opentab[i].o_fileid += MAXOPEN;
  801282:	c1 e3 04             	shl    $0x4,%ebx
  801285:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  80128c:	04 00 00 
			*o = &opentab[i];
  80128f:	81 c6 60 50 80 00    	add    $0x805060,%esi
  801295:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  801297:	83 ec 04             	sub    $0x4,%esp
  80129a:	68 00 10 00 00       	push   $0x1000
  80129f:	6a 00                	push   $0x0
  8012a1:	ff b3 6c 50 80 00    	pushl  0x80506c(%ebx)
  8012a7:	e8 b8 10 00 00       	call   802364 <memset>
			return (*o)->o_fileid;
  8012ac:	8b 07                	mov    (%edi),%eax
  8012ae:	8b 00                	mov    (%eax),%eax
  8012b0:	83 c4 10             	add    $0x10,%esp
}
  8012b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    

008012bb <openfile_lookup>:
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	57                   	push   %edi
  8012bf:	56                   	push   %esi
  8012c0:	53                   	push   %ebx
  8012c1:	83 ec 18             	sub    $0x18,%esp
  8012c4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  8012c7:	89 fb                	mov    %edi,%ebx
  8012c9:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8012cf:	89 de                	mov    %ebx,%esi
  8012d1:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012d4:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
	o = &opentab[fileid % MAXOPEN];
  8012da:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012e0:	e8 1b 1e 00 00       	call   803100 <pageref>
  8012e5:	83 c4 10             	add    $0x10,%esp
  8012e8:	83 f8 01             	cmp    $0x1,%eax
  8012eb:	7e 1d                	jle    80130a <openfile_lookup+0x4f>
  8012ed:	c1 e3 04             	shl    $0x4,%ebx
  8012f0:	39 bb 60 50 80 00    	cmp    %edi,0x805060(%ebx)
  8012f6:	75 19                	jne    801311 <openfile_lookup+0x56>
	*po = o;
  8012f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fb:	89 30                	mov    %esi,(%eax)
	return 0;
  8012fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801302:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801305:	5b                   	pop    %ebx
  801306:	5e                   	pop    %esi
  801307:	5f                   	pop    %edi
  801308:	5d                   	pop    %ebp
  801309:	c3                   	ret    
		return -E_INVAL;
  80130a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130f:	eb f1                	jmp    801302 <openfile_lookup+0x47>
  801311:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801316:	eb ea                	jmp    801302 <openfile_lookup+0x47>

00801318 <serve_set_size>:
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	53                   	push   %ebx
  80131c:	83 ec 18             	sub    $0x18,%esp
  80131f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801322:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801325:	50                   	push   %eax
  801326:	ff 33                	pushl  (%ebx)
  801328:	ff 75 08             	pushl  0x8(%ebp)
  80132b:	e8 8b ff ff ff       	call   8012bb <openfile_lookup>
  801330:	83 c4 10             	add    $0x10,%esp
  801333:	85 c0                	test   %eax,%eax
  801335:	78 14                	js     80134b <serve_set_size+0x33>
	return file_set_size(o->o_file, req->req_size);
  801337:	83 ec 08             	sub    $0x8,%esp
  80133a:	ff 73 04             	pushl  0x4(%ebx)
  80133d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801340:	ff 70 04             	pushl  0x4(%eax)
  801343:	e8 f8 fa ff ff       	call   800e40 <file_set_size>
  801348:	83 c4 10             	add    $0x10,%esp
}
  80134b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <serve_read>:
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	53                   	push   %ebx
  801354:	83 ec 18             	sub    $0x18,%esp
  801357:	8b 5d 0c             	mov    0xc(%ebp),%ebx
        if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80135a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80135d:	50                   	push   %eax
  80135e:	ff 33                	pushl  (%ebx)
  801360:	ff 75 08             	pushl  0x8(%ebp)
  801363:	e8 53 ff ff ff       	call   8012bb <openfile_lookup>
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	78 33                	js     8013a2 <serve_read+0x52>
        if ((r = file_read(o->o_file, ret->ret_buf, req_n, o->o_fd->fd_offset)) < 0)
  80136f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801372:	8b 42 0c             	mov    0xc(%edx),%eax
  801375:	ff 70 04             	pushl  0x4(%eax)
        req_n = req->req_n > PGSIZE ? PGSIZE : req->req_n;
  801378:	81 7b 04 00 10 00 00 	cmpl   $0x1000,0x4(%ebx)
  80137f:	b8 00 10 00 00       	mov    $0x1000,%eax
  801384:	0f 46 43 04          	cmovbe 0x4(%ebx),%eax
        if ((r = file_read(o->o_file, ret->ret_buf, req_n, o->o_fd->fd_offset)) < 0)
  801388:	50                   	push   %eax
  801389:	53                   	push   %ebx
  80138a:	ff 72 04             	pushl  0x4(%edx)
  80138d:	e8 01 fa ff ff       	call   800d93 <file_read>
  801392:	83 c4 10             	add    $0x10,%esp
  801395:	85 c0                	test   %eax,%eax
  801397:	78 09                	js     8013a2 <serve_read+0x52>
        o->o_fd->fd_offset += r;
  801399:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139c:	8b 52 0c             	mov    0xc(%edx),%edx
  80139f:	01 42 04             	add    %eax,0x4(%edx)
}
  8013a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <serve_write>:
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	53                   	push   %ebx
  8013ab:	83 ec 18             	sub    $0x18,%esp
  8013ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
        if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8013b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b4:	50                   	push   %eax
  8013b5:	ff 33                	pushl  (%ebx)
  8013b7:	ff 75 08             	pushl  0x8(%ebp)
  8013ba:	e8 fc fe ff ff       	call   8012bb <openfile_lookup>
  8013bf:	83 c4 10             	add    $0x10,%esp
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	78 36                	js     8013fc <serve_write+0x55>
        if ((r = file_write(o->o_file, req->req_buf, req_n, o->o_fd->fd_offset)) < 0)
  8013c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c9:	8b 42 0c             	mov    0xc(%edx),%eax
  8013cc:	ff 70 04             	pushl  0x4(%eax)
        req_n = req->req_n > PGSIZE ? PGSIZE : req->req_n;
  8013cf:	81 7b 04 00 10 00 00 	cmpl   $0x1000,0x4(%ebx)
  8013d6:	b8 00 10 00 00       	mov    $0x1000,%eax
  8013db:	0f 46 43 04          	cmovbe 0x4(%ebx),%eax
        if ((r = file_write(o->o_file, req->req_buf, req_n, o->o_fd->fd_offset)) < 0)
  8013df:	50                   	push   %eax
  8013e0:	83 c3 08             	add    $0x8,%ebx
  8013e3:	53                   	push   %ebx
  8013e4:	ff 72 04             	pushl  0x4(%edx)
  8013e7:	e8 31 fb ff ff       	call   800f1d <file_write>
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	78 09                	js     8013fc <serve_write+0x55>
        o->o_fd->fd_offset += r;
  8013f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f6:	8b 52 0c             	mov    0xc(%edx),%edx
  8013f9:	01 42 04             	add    %eax,0x4(%edx)
}
  8013fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <serve_stat>:
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	53                   	push   %ebx
  801405:	83 ec 18             	sub    $0x18,%esp
  801408:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80140b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140e:	50                   	push   %eax
  80140f:	ff 33                	pushl  (%ebx)
  801411:	ff 75 08             	pushl  0x8(%ebp)
  801414:	e8 a2 fe ff ff       	call   8012bb <openfile_lookup>
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	85 c0                	test   %eax,%eax
  80141e:	78 3f                	js     80145f <serve_stat+0x5e>
	strcpy(ret->ret_name, o->o_file->f_name);
  801420:	83 ec 08             	sub    $0x8,%esp
  801423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801426:	ff 70 04             	pushl  0x4(%eax)
  801429:	53                   	push   %ebx
  80142a:	e8 f4 0d 00 00       	call   802223 <strcpy>
	ret->ret_size = o->o_file->f_size;
  80142f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801432:	8b 50 04             	mov    0x4(%eax),%edx
  801435:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  80143b:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  801441:	8b 40 04             	mov    0x4(%eax),%eax
  801444:	83 c4 10             	add    $0x10,%esp
  801447:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  80144e:	0f 94 c0             	sete   %al
  801451:	0f b6 c0             	movzbl %al,%eax
  801454:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80145a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <serve_flush>:
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80146a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146d:	50                   	push   %eax
  80146e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801471:	ff 30                	pushl  (%eax)
  801473:	ff 75 08             	pushl  0x8(%ebp)
  801476:	e8 40 fe ff ff       	call   8012bb <openfile_lookup>
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 16                	js     801498 <serve_flush+0x34>
	file_flush(o->o_file);
  801482:	83 ec 0c             	sub    $0xc,%esp
  801485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801488:	ff 70 04             	pushl  0x4(%eax)
  80148b:	e8 35 fb ff ff       	call   800fc5 <file_flush>
	return 0;
  801490:	83 c4 10             	add    $0x10,%esp
  801493:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801498:	c9                   	leave  
  801499:	c3                   	ret    

0080149a <serve_open>:
{
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	53                   	push   %ebx
  80149e:	81 ec 18 04 00 00    	sub    $0x418,%esp
  8014a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  8014a7:	68 00 04 00 00       	push   $0x400
  8014ac:	53                   	push   %ebx
  8014ad:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014b3:	50                   	push   %eax
  8014b4:	e8 f8 0e 00 00       	call   8023b1 <memmove>
	path[MAXPATHLEN-1] = 0;
  8014b9:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  8014bd:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8014c3:	89 04 24             	mov    %eax,(%esp)
  8014c6:	e8 57 fd ff ff       	call   801222 <openfile_alloc>
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	0f 88 f0 00 00 00    	js     8015c6 <serve_open+0x12c>
	if (req->req_omode & O_CREAT) {
  8014d6:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  8014dd:	74 33                	je     801512 <serve_open+0x78>
		if ((r = file_create(path, &f)) < 0) {
  8014df:	83 ec 08             	sub    $0x8,%esp
  8014e2:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8014e8:	50                   	push   %eax
  8014e9:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014ef:	50                   	push   %eax
  8014f0:	e8 71 fb ff ff       	call   801066 <file_create>
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	79 37                	jns    801533 <serve_open+0x99>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8014fc:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  801503:	0f 85 bd 00 00 00    	jne    8015c6 <serve_open+0x12c>
  801509:	83 f8 f3             	cmp    $0xfffffff3,%eax
  80150c:	0f 85 b4 00 00 00    	jne    8015c6 <serve_open+0x12c>
		if ((r = file_open(path, &f)) < 0) {
  801512:	83 ec 08             	sub    $0x8,%esp
  801515:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80151b:	50                   	push   %eax
  80151c:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801522:	50                   	push   %eax
  801523:	e8 51 f8 ff ff       	call   800d79 <file_open>
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	0f 88 93 00 00 00    	js     8015c6 <serve_open+0x12c>
	if (req->req_omode & O_TRUNC) {
  801533:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  80153a:	74 17                	je     801553 <serve_open+0xb9>
		if ((r = file_set_size(f, 0)) < 0) {
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	6a 00                	push   $0x0
  801541:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  801547:	e8 f4 f8 ff ff       	call   800e40 <file_set_size>
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 73                	js     8015c6 <serve_open+0x12c>
	if ((r = file_open(path, &f)) < 0) {
  801553:	83 ec 08             	sub    $0x8,%esp
  801556:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80155c:	50                   	push   %eax
  80155d:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801563:	50                   	push   %eax
  801564:	e8 10 f8 ff ff       	call   800d79 <file_open>
  801569:	83 c4 10             	add    $0x10,%esp
  80156c:	85 c0                	test   %eax,%eax
  80156e:	78 56                	js     8015c6 <serve_open+0x12c>
	o->o_file = f;
  801570:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801576:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  80157c:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  80157f:	8b 50 0c             	mov    0xc(%eax),%edx
  801582:	8b 08                	mov    (%eax),%ecx
  801584:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  801587:	8b 48 0c             	mov    0xc(%eax),%ecx
  80158a:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801590:	83 e2 03             	and    $0x3,%edx
  801593:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801596:	8b 40 0c             	mov    0xc(%eax),%eax
  801599:	8b 15 64 90 80 00    	mov    0x809064,%edx
  80159f:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  8015a1:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8015a7:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  8015ad:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  8015b0:	8b 50 0c             	mov    0xc(%eax),%edx
  8015b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b6:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  8015b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bb:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	56                   	push   %esi
  8015cf:	53                   	push   %ebx
  8015d0:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8015d3:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8015d6:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8015d9:	eb 68                	jmp    801643 <serve+0x78>
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
			cprintf("Invalid request from %08x: no argument page\n",
  8015db:	83 ec 08             	sub    $0x8,%esp
  8015de:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e1:	68 2c 3b 80 00       	push   $0x803b2c
  8015e6:	e8 4e 06 00 00       	call   801c39 <cprintf>
				whom);
			continue; // just leave it hanging...
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	eb 53                	jmp    801643 <serve+0x78>
		}

		pg = NULL;
		if (req == FSREQ_OPEN) {
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8015f0:	53                   	push   %ebx
  8015f1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015f4:	50                   	push   %eax
  8015f5:	ff 35 44 50 80 00    	pushl  0x805044
  8015fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fe:	e8 97 fe ff ff       	call   80149a <serve_open>
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	eb 19                	jmp    801621 <serve+0x56>
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
			r = handlers[req](whom, fsreq);
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  801608:	83 ec 04             	sub    $0x4,%esp
  80160b:	ff 75 f4             	pushl  -0xc(%ebp)
  80160e:	50                   	push   %eax
  80160f:	68 5c 3b 80 00       	push   $0x803b5c
  801614:	e8 20 06 00 00       	call   801c39 <cprintf>
  801619:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  80161c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  801621:	ff 75 f0             	pushl  -0x10(%ebp)
  801624:	ff 75 ec             	pushl  -0x14(%ebp)
  801627:	50                   	push   %eax
  801628:	ff 75 f4             	pushl  -0xc(%ebp)
  80162b:	e8 8f 12 00 00       	call   8028bf <ipc_send>
		sys_page_unmap(0, fsreq);
  801630:	83 c4 08             	add    $0x8,%esp
  801633:	ff 35 44 50 80 00    	pushl  0x805044
  801639:	6a 00                	push   $0x0
  80163b:	e8 61 10 00 00       	call   8026a1 <sys_page_unmap>
  801640:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  801643:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	53                   	push   %ebx
  80164e:	ff 35 44 50 80 00    	pushl  0x805044
  801654:	56                   	push   %esi
  801655:	e8 4e 12 00 00       	call   8028a8 <ipc_recv>
		if (!(perm & PTE_P)) {
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  801661:	0f 84 74 ff ff ff    	je     8015db <serve+0x10>
		pg = NULL;
  801667:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  80166e:	83 f8 01             	cmp    $0x1,%eax
  801671:	0f 84 79 ff ff ff    	je     8015f0 <serve+0x25>
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  801677:	83 f8 08             	cmp    $0x8,%eax
  80167a:	77 8c                	ja     801608 <serve+0x3d>
  80167c:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  801683:	85 d2                	test   %edx,%edx
  801685:	74 81                	je     801608 <serve+0x3d>
			r = handlers[req](whom, fsreq);
  801687:	83 ec 08             	sub    $0x8,%esp
  80168a:	ff 35 44 50 80 00    	pushl  0x805044
  801690:	ff 75 f4             	pushl  -0xc(%ebp)
  801693:	ff d2                	call   *%edx
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	eb 87                	jmp    801621 <serve+0x56>

0080169a <umain>:
	}
}

void
umain(int argc, char **argv)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  8016a0:	c7 05 60 90 80 00 7f 	movl   $0x803b7f,0x809060
  8016a7:	3b 80 00 
	cprintf("FS is running\n");
  8016aa:	68 82 3b 80 00       	push   $0x803b82
  8016af:	e8 85 05 00 00       	call   801c39 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8016b4:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  8016b9:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  8016be:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8016c0:	c7 04 24 91 3b 80 00 	movl   $0x803b91,(%esp)
  8016c7:	e8 6d 05 00 00       	call   801c39 <cprintf>

	serve_init();
  8016cc:	e8 25 fb ff ff       	call   8011f6 <serve_init>
	fs_init();
  8016d1:	e8 87 f3 ff ff       	call   800a5d <fs_init>
        fs_test();
  8016d6:	e8 05 00 00 00       	call   8016e0 <fs_test>
	serve();
  8016db:	e8 eb fe ff ff       	call   8015cb <serve>

008016e0 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	53                   	push   %ebx
  8016e4:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8016e7:	6a 07                	push   $0x7
  8016e9:	68 00 10 00 00       	push   $0x1000
  8016ee:	6a 00                	push   $0x0
  8016f0:	e8 27 0f 00 00       	call   80261c <sys_page_alloc>
  8016f5:	83 c4 10             	add    $0x10,%esp
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	0f 88 6a 02 00 00    	js     80196a <fs_test+0x28a>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  801700:	83 ec 04             	sub    $0x4,%esp
  801703:	68 00 10 00 00       	push   $0x1000
  801708:	ff 35 04 a0 80 00    	pushl  0x80a004
  80170e:	68 00 10 00 00       	push   $0x1000
  801713:	e8 99 0c 00 00       	call   8023b1 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  801718:	e8 55 f1 ff ff       	call   800872 <alloc_block>
  80171d:	83 c4 10             	add    $0x10,%esp
  801720:	85 c0                	test   %eax,%eax
  801722:	0f 88 54 02 00 00    	js     80197c <fs_test+0x29c>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  801728:	8d 50 1f             	lea    0x1f(%eax),%edx
  80172b:	85 c0                	test   %eax,%eax
  80172d:	0f 49 d0             	cmovns %eax,%edx
  801730:	c1 fa 05             	sar    $0x5,%edx
  801733:	89 c3                	mov    %eax,%ebx
  801735:	c1 fb 1f             	sar    $0x1f,%ebx
  801738:	c1 eb 1b             	shr    $0x1b,%ebx
  80173b:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  80173e:	83 e1 1f             	and    $0x1f,%ecx
  801741:	29 d9                	sub    %ebx,%ecx
  801743:	b8 01 00 00 00       	mov    $0x1,%eax
  801748:	d3 e0                	shl    %cl,%eax
  80174a:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  801751:	0f 84 37 02 00 00    	je     80198e <fs_test+0x2ae>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801757:	8b 0d 04 a0 80 00    	mov    0x80a004,%ecx
  80175d:	85 04 91             	test   %eax,(%ecx,%edx,4)
  801760:	0f 85 3e 02 00 00    	jne    8019a4 <fs_test+0x2c4>
	cprintf("alloc_block is good\n");
  801766:	83 ec 0c             	sub    $0xc,%esp
  801769:	68 e8 3b 80 00       	push   $0x803be8
  80176e:	e8 c6 04 00 00       	call   801c39 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  801773:	83 c4 08             	add    $0x8,%esp
  801776:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801779:	50                   	push   %eax
  80177a:	68 fd 3b 80 00       	push   $0x803bfd
  80177f:	e8 f5 f5 ff ff       	call   800d79 <file_open>
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80178a:	74 08                	je     801794 <fs_test+0xb4>
  80178c:	85 c0                	test   %eax,%eax
  80178e:	0f 88 26 02 00 00    	js     8019ba <fs_test+0x2da>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  801794:	85 c0                	test   %eax,%eax
  801796:	0f 84 30 02 00 00    	je     8019cc <fs_test+0x2ec>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  80179c:	83 ec 08             	sub    $0x8,%esp
  80179f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a2:	50                   	push   %eax
  8017a3:	68 21 3c 80 00       	push   $0x803c21
  8017a8:	e8 cc f5 ff ff       	call   800d79 <file_open>
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	0f 88 28 02 00 00    	js     8019e0 <fs_test+0x300>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  8017b8:	83 ec 0c             	sub    $0xc,%esp
  8017bb:	68 41 3c 80 00       	push   $0x803c41
  8017c0:	e8 74 04 00 00       	call   801c39 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  8017c5:	83 c4 0c             	add    $0xc,%esp
  8017c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017cb:	50                   	push   %eax
  8017cc:	6a 00                	push   $0x0
  8017ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d1:	e8 e6 f2 ff ff       	call   800abc <file_get_block>
  8017d6:	83 c4 10             	add    $0x10,%esp
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	0f 88 11 02 00 00    	js     8019f2 <fs_test+0x312>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	68 88 3d 80 00       	push   $0x803d88
  8017e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ec:	e8 d8 0a 00 00       	call   8022c9 <strcmp>
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	85 c0                	test   %eax,%eax
  8017f6:	0f 85 08 02 00 00    	jne    801a04 <fs_test+0x324>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  8017fc:	83 ec 0c             	sub    $0xc,%esp
  8017ff:	68 67 3c 80 00       	push   $0x803c67
  801804:	e8 30 04 00 00       	call   801c39 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180c:	0f b6 10             	movzbl (%eax),%edx
  80180f:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801814:	c1 e8 0c             	shr    $0xc,%eax
  801817:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	a8 40                	test   $0x40,%al
  801823:	0f 84 ef 01 00 00    	je     801a18 <fs_test+0x338>
	file_flush(f);
  801829:	83 ec 0c             	sub    $0xc,%esp
  80182c:	ff 75 f4             	pushl  -0xc(%ebp)
  80182f:	e8 91 f7 ff ff       	call   800fc5 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801837:	c1 e8 0c             	shr    $0xc,%eax
  80183a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	a8 40                	test   $0x40,%al
  801846:	0f 85 e2 01 00 00    	jne    801a2e <fs_test+0x34e>
	cprintf("file_flush is good\n");
  80184c:	83 ec 0c             	sub    $0xc,%esp
  80184f:	68 9b 3c 80 00       	push   $0x803c9b
  801854:	e8 e0 03 00 00       	call   801c39 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801859:	83 c4 08             	add    $0x8,%esp
  80185c:	6a 00                	push   $0x0
  80185e:	ff 75 f4             	pushl  -0xc(%ebp)
  801861:	e8 da f5 ff ff       	call   800e40 <file_set_size>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	85 c0                	test   %eax,%eax
  80186b:	0f 88 d3 01 00 00    	js     801a44 <fs_test+0x364>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  801871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801874:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  80187b:	0f 85 d5 01 00 00    	jne    801a56 <fs_test+0x376>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801881:	c1 e8 0c             	shr    $0xc,%eax
  801884:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80188b:	a8 40                	test   $0x40,%al
  80188d:	0f 85 d9 01 00 00    	jne    801a6c <fs_test+0x38c>
	cprintf("file_truncate is good\n");
  801893:	83 ec 0c             	sub    $0xc,%esp
  801896:	68 ef 3c 80 00       	push   $0x803cef
  80189b:	e8 99 03 00 00       	call   801c39 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  8018a0:	c7 04 24 88 3d 80 00 	movl   $0x803d88,(%esp)
  8018a7:	e8 40 09 00 00       	call   8021ec <strlen>
  8018ac:	83 c4 08             	add    $0x8,%esp
  8018af:	50                   	push   %eax
  8018b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b3:	e8 88 f5 ff ff       	call   800e40 <file_set_size>
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	0f 88 bf 01 00 00    	js     801a82 <fs_test+0x3a2>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8018c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c6:	89 c2                	mov    %eax,%edx
  8018c8:	c1 ea 0c             	shr    $0xc,%edx
  8018cb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018d2:	f6 c2 40             	test   $0x40,%dl
  8018d5:	0f 85 b9 01 00 00    	jne    801a94 <fs_test+0x3b4>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  8018db:	83 ec 04             	sub    $0x4,%esp
  8018de:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8018e1:	52                   	push   %edx
  8018e2:	6a 00                	push   $0x0
  8018e4:	50                   	push   %eax
  8018e5:	e8 d2 f1 ff ff       	call   800abc <file_get_block>
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	0f 88 b5 01 00 00    	js     801aaa <fs_test+0x3ca>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  8018f5:	83 ec 08             	sub    $0x8,%esp
  8018f8:	68 88 3d 80 00       	push   $0x803d88
  8018fd:	ff 75 f0             	pushl  -0x10(%ebp)
  801900:	e8 1e 09 00 00       	call   802223 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801908:	c1 e8 0c             	shr    $0xc,%eax
  80190b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801912:	83 c4 10             	add    $0x10,%esp
  801915:	a8 40                	test   $0x40,%al
  801917:	0f 84 9f 01 00 00    	je     801abc <fs_test+0x3dc>
	file_flush(f);
  80191d:	83 ec 0c             	sub    $0xc,%esp
  801920:	ff 75 f4             	pushl  -0xc(%ebp)
  801923:	e8 9d f6 ff ff       	call   800fc5 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192b:	c1 e8 0c             	shr    $0xc,%eax
  80192e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	a8 40                	test   $0x40,%al
  80193a:	0f 85 92 01 00 00    	jne    801ad2 <fs_test+0x3f2>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801943:	c1 e8 0c             	shr    $0xc,%eax
  801946:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80194d:	a8 40                	test   $0x40,%al
  80194f:	0f 85 93 01 00 00    	jne    801ae8 <fs_test+0x408>
	cprintf("file rewrite is good\n");
  801955:	83 ec 0c             	sub    $0xc,%esp
  801958:	68 2f 3d 80 00       	push   $0x803d2f
  80195d:	e8 d7 02 00 00       	call   801c39 <cprintf>
}
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801968:	c9                   	leave  
  801969:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80196a:	50                   	push   %eax
  80196b:	68 a0 3b 80 00       	push   $0x803ba0
  801970:	6a 12                	push   $0x12
  801972:	68 b3 3b 80 00       	push   $0x803bb3
  801977:	e8 e2 01 00 00       	call   801b5e <_panic>
		panic("alloc_block: %e", r);
  80197c:	50                   	push   %eax
  80197d:	68 bd 3b 80 00       	push   $0x803bbd
  801982:	6a 17                	push   $0x17
  801984:	68 b3 3b 80 00       	push   $0x803bb3
  801989:	e8 d0 01 00 00       	call   801b5e <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  80198e:	68 cd 3b 80 00       	push   $0x803bcd
  801993:	68 9d 38 80 00       	push   $0x80389d
  801998:	6a 19                	push   $0x19
  80199a:	68 b3 3b 80 00       	push   $0x803bb3
  80199f:	e8 ba 01 00 00       	call   801b5e <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8019a4:	68 48 3d 80 00       	push   $0x803d48
  8019a9:	68 9d 38 80 00       	push   $0x80389d
  8019ae:	6a 1b                	push   $0x1b
  8019b0:	68 b3 3b 80 00       	push   $0x803bb3
  8019b5:	e8 a4 01 00 00       	call   801b5e <_panic>
		panic("file_open /not-found: %e", r);
  8019ba:	50                   	push   %eax
  8019bb:	68 08 3c 80 00       	push   $0x803c08
  8019c0:	6a 1f                	push   $0x1f
  8019c2:	68 b3 3b 80 00       	push   $0x803bb3
  8019c7:	e8 92 01 00 00       	call   801b5e <_panic>
		panic("file_open /not-found succeeded!");
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	68 68 3d 80 00       	push   $0x803d68
  8019d4:	6a 21                	push   $0x21
  8019d6:	68 b3 3b 80 00       	push   $0x803bb3
  8019db:	e8 7e 01 00 00       	call   801b5e <_panic>
		panic("file_open /newmotd: %e", r);
  8019e0:	50                   	push   %eax
  8019e1:	68 2a 3c 80 00       	push   $0x803c2a
  8019e6:	6a 23                	push   $0x23
  8019e8:	68 b3 3b 80 00       	push   $0x803bb3
  8019ed:	e8 6c 01 00 00       	call   801b5e <_panic>
		panic("file_get_block: %e", r);
  8019f2:	50                   	push   %eax
  8019f3:	68 54 3c 80 00       	push   $0x803c54
  8019f8:	6a 27                	push   $0x27
  8019fa:	68 b3 3b 80 00       	push   $0x803bb3
  8019ff:	e8 5a 01 00 00       	call   801b5e <_panic>
		panic("file_get_block returned wrong data");
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	68 b0 3d 80 00       	push   $0x803db0
  801a0c:	6a 29                	push   $0x29
  801a0e:	68 b3 3b 80 00       	push   $0x803bb3
  801a13:	e8 46 01 00 00       	call   801b5e <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a18:	68 80 3c 80 00       	push   $0x803c80
  801a1d:	68 9d 38 80 00       	push   $0x80389d
  801a22:	6a 2d                	push   $0x2d
  801a24:	68 b3 3b 80 00       	push   $0x803bb3
  801a29:	e8 30 01 00 00       	call   801b5e <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801a2e:	68 7f 3c 80 00       	push   $0x803c7f
  801a33:	68 9d 38 80 00       	push   $0x80389d
  801a38:	6a 2f                	push   $0x2f
  801a3a:	68 b3 3b 80 00       	push   $0x803bb3
  801a3f:	e8 1a 01 00 00       	call   801b5e <_panic>
		panic("file_set_size: %e", r);
  801a44:	50                   	push   %eax
  801a45:	68 af 3c 80 00       	push   $0x803caf
  801a4a:	6a 33                	push   $0x33
  801a4c:	68 b3 3b 80 00       	push   $0x803bb3
  801a51:	e8 08 01 00 00       	call   801b5e <_panic>
	assert(f->f_direct[0] == 0);
  801a56:	68 c1 3c 80 00       	push   $0x803cc1
  801a5b:	68 9d 38 80 00       	push   $0x80389d
  801a60:	6a 34                	push   $0x34
  801a62:	68 b3 3b 80 00       	push   $0x803bb3
  801a67:	e8 f2 00 00 00       	call   801b5e <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a6c:	68 d5 3c 80 00       	push   $0x803cd5
  801a71:	68 9d 38 80 00       	push   $0x80389d
  801a76:	6a 35                	push   $0x35
  801a78:	68 b3 3b 80 00       	push   $0x803bb3
  801a7d:	e8 dc 00 00 00       	call   801b5e <_panic>
		panic("file_set_size 2: %e", r);
  801a82:	50                   	push   %eax
  801a83:	68 06 3d 80 00       	push   $0x803d06
  801a88:	6a 39                	push   $0x39
  801a8a:	68 b3 3b 80 00       	push   $0x803bb3
  801a8f:	e8 ca 00 00 00       	call   801b5e <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a94:	68 d5 3c 80 00       	push   $0x803cd5
  801a99:	68 9d 38 80 00       	push   $0x80389d
  801a9e:	6a 3a                	push   $0x3a
  801aa0:	68 b3 3b 80 00       	push   $0x803bb3
  801aa5:	e8 b4 00 00 00       	call   801b5e <_panic>
		panic("file_get_block 2: %e", r);
  801aaa:	50                   	push   %eax
  801aab:	68 1a 3d 80 00       	push   $0x803d1a
  801ab0:	6a 3c                	push   $0x3c
  801ab2:	68 b3 3b 80 00       	push   $0x803bb3
  801ab7:	e8 a2 00 00 00       	call   801b5e <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801abc:	68 80 3c 80 00       	push   $0x803c80
  801ac1:	68 9d 38 80 00       	push   $0x80389d
  801ac6:	6a 3e                	push   $0x3e
  801ac8:	68 b3 3b 80 00       	push   $0x803bb3
  801acd:	e8 8c 00 00 00       	call   801b5e <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801ad2:	68 7f 3c 80 00       	push   $0x803c7f
  801ad7:	68 9d 38 80 00       	push   $0x80389d
  801adc:	6a 40                	push   $0x40
  801ade:	68 b3 3b 80 00       	push   $0x803bb3
  801ae3:	e8 76 00 00 00       	call   801b5e <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801ae8:	68 d5 3c 80 00       	push   $0x803cd5
  801aed:	68 9d 38 80 00       	push   $0x80389d
  801af2:	6a 41                	push   $0x41
  801af4:	68 b3 3b 80 00       	push   $0x803bb3
  801af9:	e8 60 00 00 00       	call   801b5e <_panic>

00801afe <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	56                   	push   %esi
  801b02:	53                   	push   %ebx
  801b03:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b06:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801b09:	e8 d0 0a 00 00       	call   8025de <sys_getenvid>
  801b0e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b13:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b16:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b1b:	a3 0c a0 80 00       	mov    %eax,0x80a00c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801b20:	85 db                	test   %ebx,%ebx
  801b22:	7e 07                	jle    801b2b <libmain+0x2d>
		binaryname = argv[0];
  801b24:	8b 06                	mov    (%esi),%eax
  801b26:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801b2b:	83 ec 08             	sub    $0x8,%esp
  801b2e:	56                   	push   %esi
  801b2f:	53                   	push   %ebx
  801b30:	e8 65 fb ff ff       	call   80169a <umain>

	// exit gracefully
	exit();
  801b35:	e8 0a 00 00 00       	call   801b44 <exit>
}
  801b3a:	83 c4 10             	add    $0x10,%esp
  801b3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b40:	5b                   	pop    %ebx
  801b41:	5e                   	pop    %esi
  801b42:	5d                   	pop    %ebp
  801b43:	c3                   	ret    

00801b44 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 08             	sub    $0x8,%esp
	close_all();
  801b4a:	e8 96 0f 00 00       	call   802ae5 <close_all>
	sys_env_destroy(0);
  801b4f:	83 ec 0c             	sub    $0xc,%esp
  801b52:	6a 00                	push   $0x0
  801b54:	e8 44 0a 00 00       	call   80259d <sys_env_destroy>
}
  801b59:	83 c4 10             	add    $0x10,%esp
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	56                   	push   %esi
  801b62:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801b63:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b66:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801b6c:	e8 6d 0a 00 00       	call   8025de <sys_getenvid>
  801b71:	83 ec 0c             	sub    $0xc,%esp
  801b74:	ff 75 0c             	pushl  0xc(%ebp)
  801b77:	ff 75 08             	pushl  0x8(%ebp)
  801b7a:	56                   	push   %esi
  801b7b:	50                   	push   %eax
  801b7c:	68 e0 3d 80 00       	push   $0x803de0
  801b81:	e8 b3 00 00 00       	call   801c39 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b86:	83 c4 18             	add    $0x18,%esp
  801b89:	53                   	push   %ebx
  801b8a:	ff 75 10             	pushl  0x10(%ebp)
  801b8d:	e8 56 00 00 00       	call   801be8 <vcprintf>
	cprintf("\n");
  801b92:	c7 04 24 f1 39 80 00 	movl   $0x8039f1,(%esp)
  801b99:	e8 9b 00 00 00       	call   801c39 <cprintf>
  801b9e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ba1:	cc                   	int3   
  801ba2:	eb fd                	jmp    801ba1 <_panic+0x43>

00801ba4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 04             	sub    $0x4,%esp
  801bab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801bae:	8b 13                	mov    (%ebx),%edx
  801bb0:	8d 42 01             	lea    0x1(%edx),%eax
  801bb3:	89 03                	mov    %eax,(%ebx)
  801bb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801bbc:	3d ff 00 00 00       	cmp    $0xff,%eax
  801bc1:	74 09                	je     801bcc <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801bc3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801bc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801bcc:	83 ec 08             	sub    $0x8,%esp
  801bcf:	68 ff 00 00 00       	push   $0xff
  801bd4:	8d 43 08             	lea    0x8(%ebx),%eax
  801bd7:	50                   	push   %eax
  801bd8:	e8 83 09 00 00       	call   802560 <sys_cputs>
		b->idx = 0;
  801bdd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	eb db                	jmp    801bc3 <putch+0x1f>

00801be8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801bf1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801bf8:	00 00 00 
	b.cnt = 0;
  801bfb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801c02:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801c05:	ff 75 0c             	pushl  0xc(%ebp)
  801c08:	ff 75 08             	pushl  0x8(%ebp)
  801c0b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801c11:	50                   	push   %eax
  801c12:	68 a4 1b 80 00       	push   $0x801ba4
  801c17:	e8 1a 01 00 00       	call   801d36 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801c1c:	83 c4 08             	add    $0x8,%esp
  801c1f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801c25:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801c2b:	50                   	push   %eax
  801c2c:	e8 2f 09 00 00       	call   802560 <sys_cputs>

	return b.cnt;
}
  801c31:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c3f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801c42:	50                   	push   %eax
  801c43:	ff 75 08             	pushl  0x8(%ebp)
  801c46:	e8 9d ff ff ff       	call   801be8 <vcprintf>
	va_end(ap);

	return cnt;
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	57                   	push   %edi
  801c51:	56                   	push   %esi
  801c52:	53                   	push   %ebx
  801c53:	83 ec 1c             	sub    $0x1c,%esp
  801c56:	89 c7                	mov    %eax,%edi
  801c58:	89 d6                	mov    %edx,%esi
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c60:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c63:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c69:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c6e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801c71:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801c74:	39 d3                	cmp    %edx,%ebx
  801c76:	72 05                	jb     801c7d <printnum+0x30>
  801c78:	39 45 10             	cmp    %eax,0x10(%ebp)
  801c7b:	77 7a                	ja     801cf7 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c7d:	83 ec 0c             	sub    $0xc,%esp
  801c80:	ff 75 18             	pushl  0x18(%ebp)
  801c83:	8b 45 14             	mov    0x14(%ebp),%eax
  801c86:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c89:	53                   	push   %ebx
  801c8a:	ff 75 10             	pushl  0x10(%ebp)
  801c8d:	83 ec 08             	sub    $0x8,%esp
  801c90:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c93:	ff 75 e0             	pushl  -0x20(%ebp)
  801c96:	ff 75 dc             	pushl  -0x24(%ebp)
  801c99:	ff 75 d8             	pushl  -0x28(%ebp)
  801c9c:	e8 6f 19 00 00       	call   803610 <__udivdi3>
  801ca1:	83 c4 18             	add    $0x18,%esp
  801ca4:	52                   	push   %edx
  801ca5:	50                   	push   %eax
  801ca6:	89 f2                	mov    %esi,%edx
  801ca8:	89 f8                	mov    %edi,%eax
  801caa:	e8 9e ff ff ff       	call   801c4d <printnum>
  801caf:	83 c4 20             	add    $0x20,%esp
  801cb2:	eb 13                	jmp    801cc7 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801cb4:	83 ec 08             	sub    $0x8,%esp
  801cb7:	56                   	push   %esi
  801cb8:	ff 75 18             	pushl  0x18(%ebp)
  801cbb:	ff d7                	call   *%edi
  801cbd:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801cc0:	83 eb 01             	sub    $0x1,%ebx
  801cc3:	85 db                	test   %ebx,%ebx
  801cc5:	7f ed                	jg     801cb4 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801cc7:	83 ec 08             	sub    $0x8,%esp
  801cca:	56                   	push   %esi
  801ccb:	83 ec 04             	sub    $0x4,%esp
  801cce:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cd1:	ff 75 e0             	pushl  -0x20(%ebp)
  801cd4:	ff 75 dc             	pushl  -0x24(%ebp)
  801cd7:	ff 75 d8             	pushl  -0x28(%ebp)
  801cda:	e8 51 1a 00 00       	call   803730 <__umoddi3>
  801cdf:	83 c4 14             	add    $0x14,%esp
  801ce2:	0f be 80 03 3e 80 00 	movsbl 0x803e03(%eax),%eax
  801ce9:	50                   	push   %eax
  801cea:	ff d7                	call   *%edi
}
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf2:	5b                   	pop    %ebx
  801cf3:	5e                   	pop    %esi
  801cf4:	5f                   	pop    %edi
  801cf5:	5d                   	pop    %ebp
  801cf6:	c3                   	ret    
  801cf7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cfa:	eb c4                	jmp    801cc0 <printnum+0x73>

00801cfc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801d02:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801d06:	8b 10                	mov    (%eax),%edx
  801d08:	3b 50 04             	cmp    0x4(%eax),%edx
  801d0b:	73 0a                	jae    801d17 <sprintputch+0x1b>
		*b->buf++ = ch;
  801d0d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d10:	89 08                	mov    %ecx,(%eax)
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	88 02                	mov    %al,(%edx)
}
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    

00801d19 <printfmt>:
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801d1f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801d22:	50                   	push   %eax
  801d23:	ff 75 10             	pushl  0x10(%ebp)
  801d26:	ff 75 0c             	pushl  0xc(%ebp)
  801d29:	ff 75 08             	pushl  0x8(%ebp)
  801d2c:	e8 05 00 00 00       	call   801d36 <vprintfmt>
}
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <vprintfmt>:
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	57                   	push   %edi
  801d3a:	56                   	push   %esi
  801d3b:	53                   	push   %ebx
  801d3c:	83 ec 2c             	sub    $0x2c,%esp
  801d3f:	8b 75 08             	mov    0x8(%ebp),%esi
  801d42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d45:	8b 7d 10             	mov    0x10(%ebp),%edi
  801d48:	e9 8c 03 00 00       	jmp    8020d9 <vprintfmt+0x3a3>
		padc = ' ';
  801d4d:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801d51:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801d58:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801d5f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801d66:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801d6b:	8d 47 01             	lea    0x1(%edi),%eax
  801d6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d71:	0f b6 17             	movzbl (%edi),%edx
  801d74:	8d 42 dd             	lea    -0x23(%edx),%eax
  801d77:	3c 55                	cmp    $0x55,%al
  801d79:	0f 87 dd 03 00 00    	ja     80215c <vprintfmt+0x426>
  801d7f:	0f b6 c0             	movzbl %al,%eax
  801d82:	ff 24 85 40 3f 80 00 	jmp    *0x803f40(,%eax,4)
  801d89:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801d8c:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801d90:	eb d9                	jmp    801d6b <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801d92:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801d95:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801d99:	eb d0                	jmp    801d6b <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801d9b:	0f b6 d2             	movzbl %dl,%edx
  801d9e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801da1:	b8 00 00 00 00       	mov    $0x0,%eax
  801da6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801da9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801dac:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801db0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801db3:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801db6:	83 f9 09             	cmp    $0x9,%ecx
  801db9:	77 55                	ja     801e10 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801dbb:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801dbe:	eb e9                	jmp    801da9 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801dc0:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc3:	8b 00                	mov    (%eax),%eax
  801dc5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801dc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcb:	8d 40 04             	lea    0x4(%eax),%eax
  801dce:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801dd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801dd4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dd8:	79 91                	jns    801d6b <vprintfmt+0x35>
				width = precision, precision = -1;
  801dda:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ddd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801de0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801de7:	eb 82                	jmp    801d6b <vprintfmt+0x35>
  801de9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dec:	85 c0                	test   %eax,%eax
  801dee:	ba 00 00 00 00       	mov    $0x0,%edx
  801df3:	0f 49 d0             	cmovns %eax,%edx
  801df6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801df9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801dfc:	e9 6a ff ff ff       	jmp    801d6b <vprintfmt+0x35>
  801e01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801e04:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801e0b:	e9 5b ff ff ff       	jmp    801d6b <vprintfmt+0x35>
  801e10:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801e13:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e16:	eb bc                	jmp    801dd4 <vprintfmt+0x9e>
			lflag++;
  801e18:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801e1b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801e1e:	e9 48 ff ff ff       	jmp    801d6b <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801e23:	8b 45 14             	mov    0x14(%ebp),%eax
  801e26:	8d 78 04             	lea    0x4(%eax),%edi
  801e29:	83 ec 08             	sub    $0x8,%esp
  801e2c:	53                   	push   %ebx
  801e2d:	ff 30                	pushl  (%eax)
  801e2f:	ff d6                	call   *%esi
			break;
  801e31:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801e34:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801e37:	e9 9a 02 00 00       	jmp    8020d6 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  801e3c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3f:	8d 78 04             	lea    0x4(%eax),%edi
  801e42:	8b 00                	mov    (%eax),%eax
  801e44:	99                   	cltd   
  801e45:	31 d0                	xor    %edx,%eax
  801e47:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801e49:	83 f8 0f             	cmp    $0xf,%eax
  801e4c:	7f 23                	jg     801e71 <vprintfmt+0x13b>
  801e4e:	8b 14 85 a0 40 80 00 	mov    0x8040a0(,%eax,4),%edx
  801e55:	85 d2                	test   %edx,%edx
  801e57:	74 18                	je     801e71 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801e59:	52                   	push   %edx
  801e5a:	68 af 38 80 00       	push   $0x8038af
  801e5f:	53                   	push   %ebx
  801e60:	56                   	push   %esi
  801e61:	e8 b3 fe ff ff       	call   801d19 <printfmt>
  801e66:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801e69:	89 7d 14             	mov    %edi,0x14(%ebp)
  801e6c:	e9 65 02 00 00       	jmp    8020d6 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  801e71:	50                   	push   %eax
  801e72:	68 1b 3e 80 00       	push   $0x803e1b
  801e77:	53                   	push   %ebx
  801e78:	56                   	push   %esi
  801e79:	e8 9b fe ff ff       	call   801d19 <printfmt>
  801e7e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801e81:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801e84:	e9 4d 02 00 00       	jmp    8020d6 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  801e89:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8c:	83 c0 04             	add    $0x4,%eax
  801e8f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801e92:	8b 45 14             	mov    0x14(%ebp),%eax
  801e95:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801e97:	85 ff                	test   %edi,%edi
  801e99:	b8 14 3e 80 00       	mov    $0x803e14,%eax
  801e9e:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801ea1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ea5:	0f 8e bd 00 00 00    	jle    801f68 <vprintfmt+0x232>
  801eab:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801eaf:	75 0e                	jne    801ebf <vprintfmt+0x189>
  801eb1:	89 75 08             	mov    %esi,0x8(%ebp)
  801eb4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801eb7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801eba:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801ebd:	eb 6d                	jmp    801f2c <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801ebf:	83 ec 08             	sub    $0x8,%esp
  801ec2:	ff 75 d0             	pushl  -0x30(%ebp)
  801ec5:	57                   	push   %edi
  801ec6:	e8 39 03 00 00       	call   802204 <strnlen>
  801ecb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801ece:	29 c1                	sub    %eax,%ecx
  801ed0:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801ed3:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801ed6:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801eda:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801edd:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801ee0:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801ee2:	eb 0f                	jmp    801ef3 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801ee4:	83 ec 08             	sub    $0x8,%esp
  801ee7:	53                   	push   %ebx
  801ee8:	ff 75 e0             	pushl  -0x20(%ebp)
  801eeb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801eed:	83 ef 01             	sub    $0x1,%edi
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	85 ff                	test   %edi,%edi
  801ef5:	7f ed                	jg     801ee4 <vprintfmt+0x1ae>
  801ef7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801efa:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801efd:	85 c9                	test   %ecx,%ecx
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	0f 49 c1             	cmovns %ecx,%eax
  801f07:	29 c1                	sub    %eax,%ecx
  801f09:	89 75 08             	mov    %esi,0x8(%ebp)
  801f0c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801f0f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801f12:	89 cb                	mov    %ecx,%ebx
  801f14:	eb 16                	jmp    801f2c <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801f16:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f1a:	75 31                	jne    801f4d <vprintfmt+0x217>
					putch(ch, putdat);
  801f1c:	83 ec 08             	sub    $0x8,%esp
  801f1f:	ff 75 0c             	pushl  0xc(%ebp)
  801f22:	50                   	push   %eax
  801f23:	ff 55 08             	call   *0x8(%ebp)
  801f26:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f29:	83 eb 01             	sub    $0x1,%ebx
  801f2c:	83 c7 01             	add    $0x1,%edi
  801f2f:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801f33:	0f be c2             	movsbl %dl,%eax
  801f36:	85 c0                	test   %eax,%eax
  801f38:	74 59                	je     801f93 <vprintfmt+0x25d>
  801f3a:	85 f6                	test   %esi,%esi
  801f3c:	78 d8                	js     801f16 <vprintfmt+0x1e0>
  801f3e:	83 ee 01             	sub    $0x1,%esi
  801f41:	79 d3                	jns    801f16 <vprintfmt+0x1e0>
  801f43:	89 df                	mov    %ebx,%edi
  801f45:	8b 75 08             	mov    0x8(%ebp),%esi
  801f48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f4b:	eb 37                	jmp    801f84 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801f4d:	0f be d2             	movsbl %dl,%edx
  801f50:	83 ea 20             	sub    $0x20,%edx
  801f53:	83 fa 5e             	cmp    $0x5e,%edx
  801f56:	76 c4                	jbe    801f1c <vprintfmt+0x1e6>
					putch('?', putdat);
  801f58:	83 ec 08             	sub    $0x8,%esp
  801f5b:	ff 75 0c             	pushl  0xc(%ebp)
  801f5e:	6a 3f                	push   $0x3f
  801f60:	ff 55 08             	call   *0x8(%ebp)
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	eb c1                	jmp    801f29 <vprintfmt+0x1f3>
  801f68:	89 75 08             	mov    %esi,0x8(%ebp)
  801f6b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801f6e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801f71:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801f74:	eb b6                	jmp    801f2c <vprintfmt+0x1f6>
				putch(' ', putdat);
  801f76:	83 ec 08             	sub    $0x8,%esp
  801f79:	53                   	push   %ebx
  801f7a:	6a 20                	push   $0x20
  801f7c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801f7e:	83 ef 01             	sub    $0x1,%edi
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	85 ff                	test   %edi,%edi
  801f86:	7f ee                	jg     801f76 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  801f88:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f8b:	89 45 14             	mov    %eax,0x14(%ebp)
  801f8e:	e9 43 01 00 00       	jmp    8020d6 <vprintfmt+0x3a0>
  801f93:	89 df                	mov    %ebx,%edi
  801f95:	8b 75 08             	mov    0x8(%ebp),%esi
  801f98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f9b:	eb e7                	jmp    801f84 <vprintfmt+0x24e>
	if (lflag >= 2)
  801f9d:	83 f9 01             	cmp    $0x1,%ecx
  801fa0:	7e 3f                	jle    801fe1 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  801fa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa5:	8b 50 04             	mov    0x4(%eax),%edx
  801fa8:	8b 00                	mov    (%eax),%eax
  801faa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fad:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb3:	8d 40 08             	lea    0x8(%eax),%eax
  801fb6:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801fb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fbd:	79 5c                	jns    80201b <vprintfmt+0x2e5>
				putch('-', putdat);
  801fbf:	83 ec 08             	sub    $0x8,%esp
  801fc2:	53                   	push   %ebx
  801fc3:	6a 2d                	push   $0x2d
  801fc5:	ff d6                	call   *%esi
				num = -(long long) num;
  801fc7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801fcd:	f7 da                	neg    %edx
  801fcf:	83 d1 00             	adc    $0x0,%ecx
  801fd2:	f7 d9                	neg    %ecx
  801fd4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801fd7:	b8 0a 00 00 00       	mov    $0xa,%eax
  801fdc:	e9 db 00 00 00       	jmp    8020bc <vprintfmt+0x386>
	else if (lflag)
  801fe1:	85 c9                	test   %ecx,%ecx
  801fe3:	75 1b                	jne    802000 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  801fe5:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe8:	8b 00                	mov    (%eax),%eax
  801fea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fed:	89 c1                	mov    %eax,%ecx
  801fef:	c1 f9 1f             	sar    $0x1f,%ecx
  801ff2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801ff5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff8:	8d 40 04             	lea    0x4(%eax),%eax
  801ffb:	89 45 14             	mov    %eax,0x14(%ebp)
  801ffe:	eb b9                	jmp    801fb9 <vprintfmt+0x283>
		return va_arg(*ap, long);
  802000:	8b 45 14             	mov    0x14(%ebp),%eax
  802003:	8b 00                	mov    (%eax),%eax
  802005:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802008:	89 c1                	mov    %eax,%ecx
  80200a:	c1 f9 1f             	sar    $0x1f,%ecx
  80200d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  802010:	8b 45 14             	mov    0x14(%ebp),%eax
  802013:	8d 40 04             	lea    0x4(%eax),%eax
  802016:	89 45 14             	mov    %eax,0x14(%ebp)
  802019:	eb 9e                	jmp    801fb9 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80201b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80201e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  802021:	b8 0a 00 00 00       	mov    $0xa,%eax
  802026:	e9 91 00 00 00       	jmp    8020bc <vprintfmt+0x386>
	if (lflag >= 2)
  80202b:	83 f9 01             	cmp    $0x1,%ecx
  80202e:	7e 15                	jle    802045 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  802030:	8b 45 14             	mov    0x14(%ebp),%eax
  802033:	8b 10                	mov    (%eax),%edx
  802035:	8b 48 04             	mov    0x4(%eax),%ecx
  802038:	8d 40 08             	lea    0x8(%eax),%eax
  80203b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80203e:	b8 0a 00 00 00       	mov    $0xa,%eax
  802043:	eb 77                	jmp    8020bc <vprintfmt+0x386>
	else if (lflag)
  802045:	85 c9                	test   %ecx,%ecx
  802047:	75 17                	jne    802060 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  802049:	8b 45 14             	mov    0x14(%ebp),%eax
  80204c:	8b 10                	mov    (%eax),%edx
  80204e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802053:	8d 40 04             	lea    0x4(%eax),%eax
  802056:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802059:	b8 0a 00 00 00       	mov    $0xa,%eax
  80205e:	eb 5c                	jmp    8020bc <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  802060:	8b 45 14             	mov    0x14(%ebp),%eax
  802063:	8b 10                	mov    (%eax),%edx
  802065:	b9 00 00 00 00       	mov    $0x0,%ecx
  80206a:	8d 40 04             	lea    0x4(%eax),%eax
  80206d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802070:	b8 0a 00 00 00       	mov    $0xa,%eax
  802075:	eb 45                	jmp    8020bc <vprintfmt+0x386>
			putch('X', putdat);
  802077:	83 ec 08             	sub    $0x8,%esp
  80207a:	53                   	push   %ebx
  80207b:	6a 58                	push   $0x58
  80207d:	ff d6                	call   *%esi
			putch('X', putdat);
  80207f:	83 c4 08             	add    $0x8,%esp
  802082:	53                   	push   %ebx
  802083:	6a 58                	push   $0x58
  802085:	ff d6                	call   *%esi
			putch('X', putdat);
  802087:	83 c4 08             	add    $0x8,%esp
  80208a:	53                   	push   %ebx
  80208b:	6a 58                	push   $0x58
  80208d:	ff d6                	call   *%esi
			break;
  80208f:	83 c4 10             	add    $0x10,%esp
  802092:	eb 42                	jmp    8020d6 <vprintfmt+0x3a0>
			putch('0', putdat);
  802094:	83 ec 08             	sub    $0x8,%esp
  802097:	53                   	push   %ebx
  802098:	6a 30                	push   $0x30
  80209a:	ff d6                	call   *%esi
			putch('x', putdat);
  80209c:	83 c4 08             	add    $0x8,%esp
  80209f:	53                   	push   %ebx
  8020a0:	6a 78                	push   $0x78
  8020a2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8020a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a7:	8b 10                	mov    (%eax),%edx
  8020a9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8020ae:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8020b1:	8d 40 04             	lea    0x4(%eax),%eax
  8020b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8020b7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8020c3:	57                   	push   %edi
  8020c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8020c7:	50                   	push   %eax
  8020c8:	51                   	push   %ecx
  8020c9:	52                   	push   %edx
  8020ca:	89 da                	mov    %ebx,%edx
  8020cc:	89 f0                	mov    %esi,%eax
  8020ce:	e8 7a fb ff ff       	call   801c4d <printnum>
			break;
  8020d3:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8020d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8020d9:	83 c7 01             	add    $0x1,%edi
  8020dc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8020e0:	83 f8 25             	cmp    $0x25,%eax
  8020e3:	0f 84 64 fc ff ff    	je     801d4d <vprintfmt+0x17>
			if (ch == '\0')
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	0f 84 8b 00 00 00    	je     80217c <vprintfmt+0x446>
			putch(ch, putdat);
  8020f1:	83 ec 08             	sub    $0x8,%esp
  8020f4:	53                   	push   %ebx
  8020f5:	50                   	push   %eax
  8020f6:	ff d6                	call   *%esi
  8020f8:	83 c4 10             	add    $0x10,%esp
  8020fb:	eb dc                	jmp    8020d9 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8020fd:	83 f9 01             	cmp    $0x1,%ecx
  802100:	7e 15                	jle    802117 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  802102:	8b 45 14             	mov    0x14(%ebp),%eax
  802105:	8b 10                	mov    (%eax),%edx
  802107:	8b 48 04             	mov    0x4(%eax),%ecx
  80210a:	8d 40 08             	lea    0x8(%eax),%eax
  80210d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802110:	b8 10 00 00 00       	mov    $0x10,%eax
  802115:	eb a5                	jmp    8020bc <vprintfmt+0x386>
	else if (lflag)
  802117:	85 c9                	test   %ecx,%ecx
  802119:	75 17                	jne    802132 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  80211b:	8b 45 14             	mov    0x14(%ebp),%eax
  80211e:	8b 10                	mov    (%eax),%edx
  802120:	b9 00 00 00 00       	mov    $0x0,%ecx
  802125:	8d 40 04             	lea    0x4(%eax),%eax
  802128:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80212b:	b8 10 00 00 00       	mov    $0x10,%eax
  802130:	eb 8a                	jmp    8020bc <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  802132:	8b 45 14             	mov    0x14(%ebp),%eax
  802135:	8b 10                	mov    (%eax),%edx
  802137:	b9 00 00 00 00       	mov    $0x0,%ecx
  80213c:	8d 40 04             	lea    0x4(%eax),%eax
  80213f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802142:	b8 10 00 00 00       	mov    $0x10,%eax
  802147:	e9 70 ff ff ff       	jmp    8020bc <vprintfmt+0x386>
			putch(ch, putdat);
  80214c:	83 ec 08             	sub    $0x8,%esp
  80214f:	53                   	push   %ebx
  802150:	6a 25                	push   $0x25
  802152:	ff d6                	call   *%esi
			break;
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	e9 7a ff ff ff       	jmp    8020d6 <vprintfmt+0x3a0>
			putch('%', putdat);
  80215c:	83 ec 08             	sub    $0x8,%esp
  80215f:	53                   	push   %ebx
  802160:	6a 25                	push   $0x25
  802162:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	89 f8                	mov    %edi,%eax
  802169:	eb 03                	jmp    80216e <vprintfmt+0x438>
  80216b:	83 e8 01             	sub    $0x1,%eax
  80216e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  802172:	75 f7                	jne    80216b <vprintfmt+0x435>
  802174:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802177:	e9 5a ff ff ff       	jmp    8020d6 <vprintfmt+0x3a0>
}
  80217c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217f:	5b                   	pop    %ebx
  802180:	5e                   	pop    %esi
  802181:	5f                   	pop    %edi
  802182:	5d                   	pop    %ebp
  802183:	c3                   	ret    

00802184 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 18             	sub    $0x18,%esp
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  802190:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802193:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802197:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80219a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	74 26                	je     8021cb <vsnprintf+0x47>
  8021a5:	85 d2                	test   %edx,%edx
  8021a7:	7e 22                	jle    8021cb <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8021a9:	ff 75 14             	pushl  0x14(%ebp)
  8021ac:	ff 75 10             	pushl  0x10(%ebp)
  8021af:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8021b2:	50                   	push   %eax
  8021b3:	68 fc 1c 80 00       	push   $0x801cfc
  8021b8:	e8 79 fb ff ff       	call   801d36 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8021bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	83 c4 10             	add    $0x10,%esp
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    
		return -E_INVAL;
  8021cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021d0:	eb f7                	jmp    8021c9 <vsnprintf+0x45>

008021d2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8021d8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8021db:	50                   	push   %eax
  8021dc:	ff 75 10             	pushl  0x10(%ebp)
  8021df:	ff 75 0c             	pushl  0xc(%ebp)
  8021e2:	ff 75 08             	pushl  0x8(%ebp)
  8021e5:	e8 9a ff ff ff       	call   802184 <vsnprintf>
	va_end(ap);

	return rc;
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8021f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f7:	eb 03                	jmp    8021fc <strlen+0x10>
		n++;
  8021f9:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8021fc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802200:	75 f7                	jne    8021f9 <strlen+0xd>
	return n;
}
  802202:	5d                   	pop    %ebp
  802203:	c3                   	ret    

00802204 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80220a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80220d:	b8 00 00 00 00       	mov    $0x0,%eax
  802212:	eb 03                	jmp    802217 <strnlen+0x13>
		n++;
  802214:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802217:	39 d0                	cmp    %edx,%eax
  802219:	74 06                	je     802221 <strnlen+0x1d>
  80221b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80221f:	75 f3                	jne    802214 <strnlen+0x10>
	return n;
}
  802221:	5d                   	pop    %ebp
  802222:	c3                   	ret    

00802223 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	53                   	push   %ebx
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80222d:	89 c2                	mov    %eax,%edx
  80222f:	83 c1 01             	add    $0x1,%ecx
  802232:	83 c2 01             	add    $0x1,%edx
  802235:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  802239:	88 5a ff             	mov    %bl,-0x1(%edx)
  80223c:	84 db                	test   %bl,%bl
  80223e:	75 ef                	jne    80222f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  802240:	5b                   	pop    %ebx
  802241:	5d                   	pop    %ebp
  802242:	c3                   	ret    

00802243 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	53                   	push   %ebx
  802247:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80224a:	53                   	push   %ebx
  80224b:	e8 9c ff ff ff       	call   8021ec <strlen>
  802250:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  802253:	ff 75 0c             	pushl  0xc(%ebp)
  802256:	01 d8                	add    %ebx,%eax
  802258:	50                   	push   %eax
  802259:	e8 c5 ff ff ff       	call   802223 <strcpy>
	return dst;
}
  80225e:	89 d8                	mov    %ebx,%eax
  802260:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	56                   	push   %esi
  802269:	53                   	push   %ebx
  80226a:	8b 75 08             	mov    0x8(%ebp),%esi
  80226d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802270:	89 f3                	mov    %esi,%ebx
  802272:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802275:	89 f2                	mov    %esi,%edx
  802277:	eb 0f                	jmp    802288 <strncpy+0x23>
		*dst++ = *src;
  802279:	83 c2 01             	add    $0x1,%edx
  80227c:	0f b6 01             	movzbl (%ecx),%eax
  80227f:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  802282:	80 39 01             	cmpb   $0x1,(%ecx)
  802285:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  802288:	39 da                	cmp    %ebx,%edx
  80228a:	75 ed                	jne    802279 <strncpy+0x14>
	}
	return ret;
}
  80228c:	89 f0                	mov    %esi,%eax
  80228e:	5b                   	pop    %ebx
  80228f:	5e                   	pop    %esi
  802290:	5d                   	pop    %ebp
  802291:	c3                   	ret    

00802292 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	56                   	push   %esi
  802296:	53                   	push   %ebx
  802297:	8b 75 08             	mov    0x8(%ebp),%esi
  80229a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022a0:	89 f0                	mov    %esi,%eax
  8022a2:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8022a6:	85 c9                	test   %ecx,%ecx
  8022a8:	75 0b                	jne    8022b5 <strlcpy+0x23>
  8022aa:	eb 17                	jmp    8022c3 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8022ac:	83 c2 01             	add    $0x1,%edx
  8022af:	83 c0 01             	add    $0x1,%eax
  8022b2:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8022b5:	39 d8                	cmp    %ebx,%eax
  8022b7:	74 07                	je     8022c0 <strlcpy+0x2e>
  8022b9:	0f b6 0a             	movzbl (%edx),%ecx
  8022bc:	84 c9                	test   %cl,%cl
  8022be:	75 ec                	jne    8022ac <strlcpy+0x1a>
		*dst = '\0';
  8022c0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8022c3:	29 f0                	sub    %esi,%eax
}
  8022c5:	5b                   	pop    %ebx
  8022c6:	5e                   	pop    %esi
  8022c7:	5d                   	pop    %ebp
  8022c8:	c3                   	ret    

008022c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022cf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8022d2:	eb 06                	jmp    8022da <strcmp+0x11>
		p++, q++;
  8022d4:	83 c1 01             	add    $0x1,%ecx
  8022d7:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8022da:	0f b6 01             	movzbl (%ecx),%eax
  8022dd:	84 c0                	test   %al,%al
  8022df:	74 04                	je     8022e5 <strcmp+0x1c>
  8022e1:	3a 02                	cmp    (%edx),%al
  8022e3:	74 ef                	je     8022d4 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8022e5:	0f b6 c0             	movzbl %al,%eax
  8022e8:	0f b6 12             	movzbl (%edx),%edx
  8022eb:	29 d0                	sub    %edx,%eax
}
  8022ed:	5d                   	pop    %ebp
  8022ee:	c3                   	ret    

008022ef <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	53                   	push   %ebx
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f9:	89 c3                	mov    %eax,%ebx
  8022fb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8022fe:	eb 06                	jmp    802306 <strncmp+0x17>
		n--, p++, q++;
  802300:	83 c0 01             	add    $0x1,%eax
  802303:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  802306:	39 d8                	cmp    %ebx,%eax
  802308:	74 16                	je     802320 <strncmp+0x31>
  80230a:	0f b6 08             	movzbl (%eax),%ecx
  80230d:	84 c9                	test   %cl,%cl
  80230f:	74 04                	je     802315 <strncmp+0x26>
  802311:	3a 0a                	cmp    (%edx),%cl
  802313:	74 eb                	je     802300 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802315:	0f b6 00             	movzbl (%eax),%eax
  802318:	0f b6 12             	movzbl (%edx),%edx
  80231b:	29 d0                	sub    %edx,%eax
}
  80231d:	5b                   	pop    %ebx
  80231e:	5d                   	pop    %ebp
  80231f:	c3                   	ret    
		return 0;
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
  802325:	eb f6                	jmp    80231d <strncmp+0x2e>

00802327 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802331:	0f b6 10             	movzbl (%eax),%edx
  802334:	84 d2                	test   %dl,%dl
  802336:	74 09                	je     802341 <strchr+0x1a>
		if (*s == c)
  802338:	38 ca                	cmp    %cl,%dl
  80233a:	74 0a                	je     802346 <strchr+0x1f>
	for (; *s; s++)
  80233c:	83 c0 01             	add    $0x1,%eax
  80233f:	eb f0                	jmp    802331 <strchr+0xa>
			return (char *) s;
	return 0;
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802346:	5d                   	pop    %ebp
  802347:	c3                   	ret    

00802348 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802352:	eb 03                	jmp    802357 <strfind+0xf>
  802354:	83 c0 01             	add    $0x1,%eax
  802357:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80235a:	38 ca                	cmp    %cl,%dl
  80235c:	74 04                	je     802362 <strfind+0x1a>
  80235e:	84 d2                	test   %dl,%dl
  802360:	75 f2                	jne    802354 <strfind+0xc>
			break;
	return (char *) s;
}
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    

00802364 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
  802367:	57                   	push   %edi
  802368:	56                   	push   %esi
  802369:	53                   	push   %ebx
  80236a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80236d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802370:	85 c9                	test   %ecx,%ecx
  802372:	74 13                	je     802387 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802374:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80237a:	75 05                	jne    802381 <memset+0x1d>
  80237c:	f6 c1 03             	test   $0x3,%cl
  80237f:	74 0d                	je     80238e <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802381:	8b 45 0c             	mov    0xc(%ebp),%eax
  802384:	fc                   	cld    
  802385:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  802387:	89 f8                	mov    %edi,%eax
  802389:	5b                   	pop    %ebx
  80238a:	5e                   	pop    %esi
  80238b:	5f                   	pop    %edi
  80238c:	5d                   	pop    %ebp
  80238d:	c3                   	ret    
		c &= 0xFF;
  80238e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802392:	89 d3                	mov    %edx,%ebx
  802394:	c1 e3 08             	shl    $0x8,%ebx
  802397:	89 d0                	mov    %edx,%eax
  802399:	c1 e0 18             	shl    $0x18,%eax
  80239c:	89 d6                	mov    %edx,%esi
  80239e:	c1 e6 10             	shl    $0x10,%esi
  8023a1:	09 f0                	or     %esi,%eax
  8023a3:	09 c2                	or     %eax,%edx
  8023a5:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8023a7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8023aa:	89 d0                	mov    %edx,%eax
  8023ac:	fc                   	cld    
  8023ad:	f3 ab                	rep stos %eax,%es:(%edi)
  8023af:	eb d6                	jmp    802387 <memset+0x23>

008023b1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
  8023b4:	57                   	push   %edi
  8023b5:	56                   	push   %esi
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8023bf:	39 c6                	cmp    %eax,%esi
  8023c1:	73 35                	jae    8023f8 <memmove+0x47>
  8023c3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8023c6:	39 c2                	cmp    %eax,%edx
  8023c8:	76 2e                	jbe    8023f8 <memmove+0x47>
		s += n;
		d += n;
  8023ca:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8023cd:	89 d6                	mov    %edx,%esi
  8023cf:	09 fe                	or     %edi,%esi
  8023d1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8023d7:	74 0c                	je     8023e5 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8023d9:	83 ef 01             	sub    $0x1,%edi
  8023dc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8023df:	fd                   	std    
  8023e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8023e2:	fc                   	cld    
  8023e3:	eb 21                	jmp    802406 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8023e5:	f6 c1 03             	test   $0x3,%cl
  8023e8:	75 ef                	jne    8023d9 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8023ea:	83 ef 04             	sub    $0x4,%edi
  8023ed:	8d 72 fc             	lea    -0x4(%edx),%esi
  8023f0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8023f3:	fd                   	std    
  8023f4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8023f6:	eb ea                	jmp    8023e2 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8023f8:	89 f2                	mov    %esi,%edx
  8023fa:	09 c2                	or     %eax,%edx
  8023fc:	f6 c2 03             	test   $0x3,%dl
  8023ff:	74 09                	je     80240a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802401:	89 c7                	mov    %eax,%edi
  802403:	fc                   	cld    
  802404:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802406:	5e                   	pop    %esi
  802407:	5f                   	pop    %edi
  802408:	5d                   	pop    %ebp
  802409:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80240a:	f6 c1 03             	test   $0x3,%cl
  80240d:	75 f2                	jne    802401 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80240f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  802412:	89 c7                	mov    %eax,%edi
  802414:	fc                   	cld    
  802415:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802417:	eb ed                	jmp    802406 <memmove+0x55>

00802419 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80241c:	ff 75 10             	pushl  0x10(%ebp)
  80241f:	ff 75 0c             	pushl  0xc(%ebp)
  802422:	ff 75 08             	pushl  0x8(%ebp)
  802425:	e8 87 ff ff ff       	call   8023b1 <memmove>
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
  80242f:	56                   	push   %esi
  802430:	53                   	push   %ebx
  802431:	8b 45 08             	mov    0x8(%ebp),%eax
  802434:	8b 55 0c             	mov    0xc(%ebp),%edx
  802437:	89 c6                	mov    %eax,%esi
  802439:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80243c:	39 f0                	cmp    %esi,%eax
  80243e:	74 1c                	je     80245c <memcmp+0x30>
		if (*s1 != *s2)
  802440:	0f b6 08             	movzbl (%eax),%ecx
  802443:	0f b6 1a             	movzbl (%edx),%ebx
  802446:	38 d9                	cmp    %bl,%cl
  802448:	75 08                	jne    802452 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80244a:	83 c0 01             	add    $0x1,%eax
  80244d:	83 c2 01             	add    $0x1,%edx
  802450:	eb ea                	jmp    80243c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  802452:	0f b6 c1             	movzbl %cl,%eax
  802455:	0f b6 db             	movzbl %bl,%ebx
  802458:	29 d8                	sub    %ebx,%eax
  80245a:	eb 05                	jmp    802461 <memcmp+0x35>
	}

	return 0;
  80245c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5d                   	pop    %ebp
  802464:	c3                   	ret    

00802465 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80246e:	89 c2                	mov    %eax,%edx
  802470:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802473:	39 d0                	cmp    %edx,%eax
  802475:	73 09                	jae    802480 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  802477:	38 08                	cmp    %cl,(%eax)
  802479:	74 05                	je     802480 <memfind+0x1b>
	for (; s < ends; s++)
  80247b:	83 c0 01             	add    $0x1,%eax
  80247e:	eb f3                	jmp    802473 <memfind+0xe>
			break;
	return (void *) s;
}
  802480:	5d                   	pop    %ebp
  802481:	c3                   	ret    

00802482 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	57                   	push   %edi
  802486:	56                   	push   %esi
  802487:	53                   	push   %ebx
  802488:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80248b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80248e:	eb 03                	jmp    802493 <strtol+0x11>
		s++;
  802490:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  802493:	0f b6 01             	movzbl (%ecx),%eax
  802496:	3c 20                	cmp    $0x20,%al
  802498:	74 f6                	je     802490 <strtol+0xe>
  80249a:	3c 09                	cmp    $0x9,%al
  80249c:	74 f2                	je     802490 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  80249e:	3c 2b                	cmp    $0x2b,%al
  8024a0:	74 2e                	je     8024d0 <strtol+0x4e>
	int neg = 0;
  8024a2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8024a7:	3c 2d                	cmp    $0x2d,%al
  8024a9:	74 2f                	je     8024da <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8024ab:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8024b1:	75 05                	jne    8024b8 <strtol+0x36>
  8024b3:	80 39 30             	cmpb   $0x30,(%ecx)
  8024b6:	74 2c                	je     8024e4 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8024b8:	85 db                	test   %ebx,%ebx
  8024ba:	75 0a                	jne    8024c6 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8024bc:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8024c1:	80 39 30             	cmpb   $0x30,(%ecx)
  8024c4:	74 28                	je     8024ee <strtol+0x6c>
		base = 10;
  8024c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8024ce:	eb 50                	jmp    802520 <strtol+0x9e>
		s++;
  8024d0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8024d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8024d8:	eb d1                	jmp    8024ab <strtol+0x29>
		s++, neg = 1;
  8024da:	83 c1 01             	add    $0x1,%ecx
  8024dd:	bf 01 00 00 00       	mov    $0x1,%edi
  8024e2:	eb c7                	jmp    8024ab <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8024e4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8024e8:	74 0e                	je     8024f8 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8024ea:	85 db                	test   %ebx,%ebx
  8024ec:	75 d8                	jne    8024c6 <strtol+0x44>
		s++, base = 8;
  8024ee:	83 c1 01             	add    $0x1,%ecx
  8024f1:	bb 08 00 00 00       	mov    $0x8,%ebx
  8024f6:	eb ce                	jmp    8024c6 <strtol+0x44>
		s += 2, base = 16;
  8024f8:	83 c1 02             	add    $0x2,%ecx
  8024fb:	bb 10 00 00 00       	mov    $0x10,%ebx
  802500:	eb c4                	jmp    8024c6 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  802502:	8d 72 9f             	lea    -0x61(%edx),%esi
  802505:	89 f3                	mov    %esi,%ebx
  802507:	80 fb 19             	cmp    $0x19,%bl
  80250a:	77 29                	ja     802535 <strtol+0xb3>
			dig = *s - 'a' + 10;
  80250c:	0f be d2             	movsbl %dl,%edx
  80250f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802512:	3b 55 10             	cmp    0x10(%ebp),%edx
  802515:	7d 30                	jge    802547 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802517:	83 c1 01             	add    $0x1,%ecx
  80251a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80251e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802520:	0f b6 11             	movzbl (%ecx),%edx
  802523:	8d 72 d0             	lea    -0x30(%edx),%esi
  802526:	89 f3                	mov    %esi,%ebx
  802528:	80 fb 09             	cmp    $0x9,%bl
  80252b:	77 d5                	ja     802502 <strtol+0x80>
			dig = *s - '0';
  80252d:	0f be d2             	movsbl %dl,%edx
  802530:	83 ea 30             	sub    $0x30,%edx
  802533:	eb dd                	jmp    802512 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  802535:	8d 72 bf             	lea    -0x41(%edx),%esi
  802538:	89 f3                	mov    %esi,%ebx
  80253a:	80 fb 19             	cmp    $0x19,%bl
  80253d:	77 08                	ja     802547 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80253f:	0f be d2             	movsbl %dl,%edx
  802542:	83 ea 37             	sub    $0x37,%edx
  802545:	eb cb                	jmp    802512 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  802547:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80254b:	74 05                	je     802552 <strtol+0xd0>
		*endptr = (char *) s;
  80254d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802550:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802552:	89 c2                	mov    %eax,%edx
  802554:	f7 da                	neg    %edx
  802556:	85 ff                	test   %edi,%edi
  802558:	0f 45 c2             	cmovne %edx,%eax
}
  80255b:	5b                   	pop    %ebx
  80255c:	5e                   	pop    %esi
  80255d:	5f                   	pop    %edi
  80255e:	5d                   	pop    %ebp
  80255f:	c3                   	ret    

00802560 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	57                   	push   %edi
  802564:	56                   	push   %esi
  802565:	53                   	push   %ebx
	asm volatile("int %1\n"
  802566:	b8 00 00 00 00       	mov    $0x0,%eax
  80256b:	8b 55 08             	mov    0x8(%ebp),%edx
  80256e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802571:	89 c3                	mov    %eax,%ebx
  802573:	89 c7                	mov    %eax,%edi
  802575:	89 c6                	mov    %eax,%esi
  802577:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  802579:	5b                   	pop    %ebx
  80257a:	5e                   	pop    %esi
  80257b:	5f                   	pop    %edi
  80257c:	5d                   	pop    %ebp
  80257d:	c3                   	ret    

0080257e <sys_cgetc>:

int
sys_cgetc(void)
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
  802581:	57                   	push   %edi
  802582:	56                   	push   %esi
  802583:	53                   	push   %ebx
	asm volatile("int %1\n"
  802584:	ba 00 00 00 00       	mov    $0x0,%edx
  802589:	b8 01 00 00 00       	mov    $0x1,%eax
  80258e:	89 d1                	mov    %edx,%ecx
  802590:	89 d3                	mov    %edx,%ebx
  802592:	89 d7                	mov    %edx,%edi
  802594:	89 d6                	mov    %edx,%esi
  802596:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  802598:	5b                   	pop    %ebx
  802599:	5e                   	pop    %esi
  80259a:	5f                   	pop    %edi
  80259b:	5d                   	pop    %ebp
  80259c:	c3                   	ret    

0080259d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
  8025a0:	57                   	push   %edi
  8025a1:	56                   	push   %esi
  8025a2:	53                   	push   %ebx
  8025a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8025a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8025ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ae:	b8 03 00 00 00       	mov    $0x3,%eax
  8025b3:	89 cb                	mov    %ecx,%ebx
  8025b5:	89 cf                	mov    %ecx,%edi
  8025b7:	89 ce                	mov    %ecx,%esi
  8025b9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8025bb:	85 c0                	test   %eax,%eax
  8025bd:	7f 08                	jg     8025c7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8025bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c2:	5b                   	pop    %ebx
  8025c3:	5e                   	pop    %esi
  8025c4:	5f                   	pop    %edi
  8025c5:	5d                   	pop    %ebp
  8025c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8025c7:	83 ec 0c             	sub    $0xc,%esp
  8025ca:	50                   	push   %eax
  8025cb:	6a 03                	push   $0x3
  8025cd:	68 ff 40 80 00       	push   $0x8040ff
  8025d2:	6a 23                	push   $0x23
  8025d4:	68 1c 41 80 00       	push   $0x80411c
  8025d9:	e8 80 f5 ff ff       	call   801b5e <_panic>

008025de <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8025de:	55                   	push   %ebp
  8025df:	89 e5                	mov    %esp,%ebp
  8025e1:	57                   	push   %edi
  8025e2:	56                   	push   %esi
  8025e3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8025e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8025e9:	b8 02 00 00 00       	mov    $0x2,%eax
  8025ee:	89 d1                	mov    %edx,%ecx
  8025f0:	89 d3                	mov    %edx,%ebx
  8025f2:	89 d7                	mov    %edx,%edi
  8025f4:	89 d6                	mov    %edx,%esi
  8025f6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8025f8:	5b                   	pop    %ebx
  8025f9:	5e                   	pop    %esi
  8025fa:	5f                   	pop    %edi
  8025fb:	5d                   	pop    %ebp
  8025fc:	c3                   	ret    

008025fd <sys_yield>:

void
sys_yield(void)
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
  802600:	57                   	push   %edi
  802601:	56                   	push   %esi
  802602:	53                   	push   %ebx
	asm volatile("int %1\n"
  802603:	ba 00 00 00 00       	mov    $0x0,%edx
  802608:	b8 0b 00 00 00       	mov    $0xb,%eax
  80260d:	89 d1                	mov    %edx,%ecx
  80260f:	89 d3                	mov    %edx,%ebx
  802611:	89 d7                	mov    %edx,%edi
  802613:	89 d6                	mov    %edx,%esi
  802615:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  802617:	5b                   	pop    %ebx
  802618:	5e                   	pop    %esi
  802619:	5f                   	pop    %edi
  80261a:	5d                   	pop    %ebp
  80261b:	c3                   	ret    

0080261c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
  80261f:	57                   	push   %edi
  802620:	56                   	push   %esi
  802621:	53                   	push   %ebx
  802622:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802625:	be 00 00 00 00       	mov    $0x0,%esi
  80262a:	8b 55 08             	mov    0x8(%ebp),%edx
  80262d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802630:	b8 04 00 00 00       	mov    $0x4,%eax
  802635:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802638:	89 f7                	mov    %esi,%edi
  80263a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80263c:	85 c0                	test   %eax,%eax
  80263e:	7f 08                	jg     802648 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  802640:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802643:	5b                   	pop    %ebx
  802644:	5e                   	pop    %esi
  802645:	5f                   	pop    %edi
  802646:	5d                   	pop    %ebp
  802647:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802648:	83 ec 0c             	sub    $0xc,%esp
  80264b:	50                   	push   %eax
  80264c:	6a 04                	push   $0x4
  80264e:	68 ff 40 80 00       	push   $0x8040ff
  802653:	6a 23                	push   $0x23
  802655:	68 1c 41 80 00       	push   $0x80411c
  80265a:	e8 ff f4 ff ff       	call   801b5e <_panic>

0080265f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80265f:	55                   	push   %ebp
  802660:	89 e5                	mov    %esp,%ebp
  802662:	57                   	push   %edi
  802663:	56                   	push   %esi
  802664:	53                   	push   %ebx
  802665:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802668:	8b 55 08             	mov    0x8(%ebp),%edx
  80266b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80266e:	b8 05 00 00 00       	mov    $0x5,%eax
  802673:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802676:	8b 7d 14             	mov    0x14(%ebp),%edi
  802679:	8b 75 18             	mov    0x18(%ebp),%esi
  80267c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80267e:	85 c0                	test   %eax,%eax
  802680:	7f 08                	jg     80268a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802682:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802685:	5b                   	pop    %ebx
  802686:	5e                   	pop    %esi
  802687:	5f                   	pop    %edi
  802688:	5d                   	pop    %ebp
  802689:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80268a:	83 ec 0c             	sub    $0xc,%esp
  80268d:	50                   	push   %eax
  80268e:	6a 05                	push   $0x5
  802690:	68 ff 40 80 00       	push   $0x8040ff
  802695:	6a 23                	push   $0x23
  802697:	68 1c 41 80 00       	push   $0x80411c
  80269c:	e8 bd f4 ff ff       	call   801b5e <_panic>

008026a1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8026a1:	55                   	push   %ebp
  8026a2:	89 e5                	mov    %esp,%ebp
  8026a4:	57                   	push   %edi
  8026a5:	56                   	push   %esi
  8026a6:	53                   	push   %ebx
  8026a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8026aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026af:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026b5:	b8 06 00 00 00       	mov    $0x6,%eax
  8026ba:	89 df                	mov    %ebx,%edi
  8026bc:	89 de                	mov    %ebx,%esi
  8026be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026c0:	85 c0                	test   %eax,%eax
  8026c2:	7f 08                	jg     8026cc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8026c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026c7:	5b                   	pop    %ebx
  8026c8:	5e                   	pop    %esi
  8026c9:	5f                   	pop    %edi
  8026ca:	5d                   	pop    %ebp
  8026cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026cc:	83 ec 0c             	sub    $0xc,%esp
  8026cf:	50                   	push   %eax
  8026d0:	6a 06                	push   $0x6
  8026d2:	68 ff 40 80 00       	push   $0x8040ff
  8026d7:	6a 23                	push   $0x23
  8026d9:	68 1c 41 80 00       	push   $0x80411c
  8026de:	e8 7b f4 ff ff       	call   801b5e <_panic>

008026e3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
  8026e6:	57                   	push   %edi
  8026e7:	56                   	push   %esi
  8026e8:	53                   	push   %ebx
  8026e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8026ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8026fc:	89 df                	mov    %ebx,%edi
  8026fe:	89 de                	mov    %ebx,%esi
  802700:	cd 30                	int    $0x30
	if(check && ret > 0)
  802702:	85 c0                	test   %eax,%eax
  802704:	7f 08                	jg     80270e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802706:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802709:	5b                   	pop    %ebx
  80270a:	5e                   	pop    %esi
  80270b:	5f                   	pop    %edi
  80270c:	5d                   	pop    %ebp
  80270d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80270e:	83 ec 0c             	sub    $0xc,%esp
  802711:	50                   	push   %eax
  802712:	6a 08                	push   $0x8
  802714:	68 ff 40 80 00       	push   $0x8040ff
  802719:	6a 23                	push   $0x23
  80271b:	68 1c 41 80 00       	push   $0x80411c
  802720:	e8 39 f4 ff ff       	call   801b5e <_panic>

00802725 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802725:	55                   	push   %ebp
  802726:	89 e5                	mov    %esp,%ebp
  802728:	57                   	push   %edi
  802729:	56                   	push   %esi
  80272a:	53                   	push   %ebx
  80272b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80272e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802733:	8b 55 08             	mov    0x8(%ebp),%edx
  802736:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802739:	b8 09 00 00 00       	mov    $0x9,%eax
  80273e:	89 df                	mov    %ebx,%edi
  802740:	89 de                	mov    %ebx,%esi
  802742:	cd 30                	int    $0x30
	if(check && ret > 0)
  802744:	85 c0                	test   %eax,%eax
  802746:	7f 08                	jg     802750 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802748:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80274b:	5b                   	pop    %ebx
  80274c:	5e                   	pop    %esi
  80274d:	5f                   	pop    %edi
  80274e:	5d                   	pop    %ebp
  80274f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802750:	83 ec 0c             	sub    $0xc,%esp
  802753:	50                   	push   %eax
  802754:	6a 09                	push   $0x9
  802756:	68 ff 40 80 00       	push   $0x8040ff
  80275b:	6a 23                	push   $0x23
  80275d:	68 1c 41 80 00       	push   $0x80411c
  802762:	e8 f7 f3 ff ff       	call   801b5e <_panic>

00802767 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
  80276a:	57                   	push   %edi
  80276b:	56                   	push   %esi
  80276c:	53                   	push   %ebx
  80276d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802770:	bb 00 00 00 00       	mov    $0x0,%ebx
  802775:	8b 55 08             	mov    0x8(%ebp),%edx
  802778:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80277b:	b8 0a 00 00 00       	mov    $0xa,%eax
  802780:	89 df                	mov    %ebx,%edi
  802782:	89 de                	mov    %ebx,%esi
  802784:	cd 30                	int    $0x30
	if(check && ret > 0)
  802786:	85 c0                	test   %eax,%eax
  802788:	7f 08                	jg     802792 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80278a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80278d:	5b                   	pop    %ebx
  80278e:	5e                   	pop    %esi
  80278f:	5f                   	pop    %edi
  802790:	5d                   	pop    %ebp
  802791:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802792:	83 ec 0c             	sub    $0xc,%esp
  802795:	50                   	push   %eax
  802796:	6a 0a                	push   $0xa
  802798:	68 ff 40 80 00       	push   $0x8040ff
  80279d:	6a 23                	push   $0x23
  80279f:	68 1c 41 80 00       	push   $0x80411c
  8027a4:	e8 b5 f3 ff ff       	call   801b5e <_panic>

008027a9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8027a9:	55                   	push   %ebp
  8027aa:	89 e5                	mov    %esp,%ebp
  8027ac:	57                   	push   %edi
  8027ad:	56                   	push   %esi
  8027ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8027af:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027b5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8027ba:	be 00 00 00 00       	mov    $0x0,%esi
  8027bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027c2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8027c5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8027c7:	5b                   	pop    %ebx
  8027c8:	5e                   	pop    %esi
  8027c9:	5f                   	pop    %edi
  8027ca:	5d                   	pop    %ebp
  8027cb:	c3                   	ret    

008027cc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
  8027cf:	57                   	push   %edi
  8027d0:	56                   	push   %esi
  8027d1:	53                   	push   %ebx
  8027d2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8027da:	8b 55 08             	mov    0x8(%ebp),%edx
  8027dd:	b8 0d 00 00 00       	mov    $0xd,%eax
  8027e2:	89 cb                	mov    %ecx,%ebx
  8027e4:	89 cf                	mov    %ecx,%edi
  8027e6:	89 ce                	mov    %ecx,%esi
  8027e8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8027ea:	85 c0                	test   %eax,%eax
  8027ec:	7f 08                	jg     8027f6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8027ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027f1:	5b                   	pop    %ebx
  8027f2:	5e                   	pop    %esi
  8027f3:	5f                   	pop    %edi
  8027f4:	5d                   	pop    %ebp
  8027f5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8027f6:	83 ec 0c             	sub    $0xc,%esp
  8027f9:	50                   	push   %eax
  8027fa:	6a 0d                	push   $0xd
  8027fc:	68 ff 40 80 00       	push   $0x8040ff
  802801:	6a 23                	push   $0x23
  802803:	68 1c 41 80 00       	push   $0x80411c
  802808:	e8 51 f3 ff ff       	call   801b5e <_panic>

0080280d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
  802810:	53                   	push   %ebx
  802811:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  802814:	83 3d 10 a0 80 00 00 	cmpl   $0x0,0x80a010
  80281b:	74 0d                	je     80282a <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80281d:	8b 45 08             	mov    0x8(%ebp),%eax
  802820:	a3 10 a0 80 00       	mov    %eax,0x80a010
}
  802825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802828:	c9                   	leave  
  802829:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  80282a:	e8 af fd ff ff       	call   8025de <sys_getenvid>
  80282f:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  802831:	83 ec 04             	sub    $0x4,%esp
  802834:	6a 07                	push   $0x7
  802836:	68 00 f0 bf ee       	push   $0xeebff000
  80283b:	50                   	push   %eax
  80283c:	e8 db fd ff ff       	call   80261c <sys_page_alloc>
        	if (r < 0) {
  802841:	83 c4 10             	add    $0x10,%esp
  802844:	85 c0                	test   %eax,%eax
  802846:	78 27                	js     80286f <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  802848:	83 ec 08             	sub    $0x8,%esp
  80284b:	68 81 28 80 00       	push   $0x802881
  802850:	53                   	push   %ebx
  802851:	e8 11 ff ff ff       	call   802767 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  802856:	83 c4 10             	add    $0x10,%esp
  802859:	85 c0                	test   %eax,%eax
  80285b:	79 c0                	jns    80281d <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  80285d:	50                   	push   %eax
  80285e:	68 2a 41 80 00       	push   $0x80412a
  802863:	6a 28                	push   $0x28
  802865:	68 3e 41 80 00       	push   $0x80413e
  80286a:	e8 ef f2 ff ff       	call   801b5e <_panic>
            		panic("pgfault_handler: %e", r);
  80286f:	50                   	push   %eax
  802870:	68 2a 41 80 00       	push   $0x80412a
  802875:	6a 24                	push   $0x24
  802877:	68 3e 41 80 00       	push   $0x80413e
  80287c:	e8 dd f2 ff ff       	call   801b5e <_panic>

00802881 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802881:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802882:	a1 10 a0 80 00       	mov    0x80a010,%eax
	call *%eax
  802887:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802889:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  80288c:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  802890:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  802893:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  802897:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  80289b:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80289e:	83 c4 08             	add    $0x8,%esp
	popal
  8028a1:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  8028a2:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  8028a5:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  8028a6:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  8028a7:	c3                   	ret    

008028a8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
  8028ab:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  8028ae:	68 4c 41 80 00       	push   $0x80414c
  8028b3:	6a 1a                	push   $0x1a
  8028b5:	68 65 41 80 00       	push   $0x804165
  8028ba:	e8 9f f2 ff ff       	call   801b5e <_panic>

008028bf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028bf:	55                   	push   %ebp
  8028c0:	89 e5                	mov    %esp,%ebp
  8028c2:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  8028c5:	68 6f 41 80 00       	push   $0x80416f
  8028ca:	6a 2a                	push   $0x2a
  8028cc:	68 65 41 80 00       	push   $0x804165
  8028d1:	e8 88 f2 ff ff       	call   801b5e <_panic>

008028d6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028d6:	55                   	push   %ebp
  8028d7:	89 e5                	mov    %esp,%ebp
  8028d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028dc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028e1:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8028e4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028ea:	8b 52 50             	mov    0x50(%edx),%edx
  8028ed:	39 ca                	cmp    %ecx,%edx
  8028ef:	74 11                	je     802902 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8028f1:	83 c0 01             	add    $0x1,%eax
  8028f4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028f9:	75 e6                	jne    8028e1 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8028fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802900:	eb 0b                	jmp    80290d <ipc_find_env+0x37>
			return envs[i].env_id;
  802902:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802905:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80290a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80290d:	5d                   	pop    %ebp
  80290e:	c3                   	ret    

0080290f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80290f:	55                   	push   %ebp
  802910:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	05 00 00 00 30       	add    $0x30000000,%eax
  80291a:	c1 e8 0c             	shr    $0xc,%eax
}
  80291d:	5d                   	pop    %ebp
  80291e:	c3                   	ret    

0080291f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80291f:	55                   	push   %ebp
  802920:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80292a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80292f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802934:	5d                   	pop    %ebp
  802935:	c3                   	ret    

00802936 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
  802939:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80293c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802941:	89 c2                	mov    %eax,%edx
  802943:	c1 ea 16             	shr    $0x16,%edx
  802946:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80294d:	f6 c2 01             	test   $0x1,%dl
  802950:	74 2a                	je     80297c <fd_alloc+0x46>
  802952:	89 c2                	mov    %eax,%edx
  802954:	c1 ea 0c             	shr    $0xc,%edx
  802957:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80295e:	f6 c2 01             	test   $0x1,%dl
  802961:	74 19                	je     80297c <fd_alloc+0x46>
  802963:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802968:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80296d:	75 d2                	jne    802941 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80296f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  802975:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80297a:	eb 07                	jmp    802983 <fd_alloc+0x4d>
			*fd_store = fd;
  80297c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80297e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802983:	5d                   	pop    %ebp
  802984:	c3                   	ret    

00802985 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802985:	55                   	push   %ebp
  802986:	89 e5                	mov    %esp,%ebp
  802988:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80298b:	83 f8 1f             	cmp    $0x1f,%eax
  80298e:	77 36                	ja     8029c6 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802990:	c1 e0 0c             	shl    $0xc,%eax
  802993:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802998:	89 c2                	mov    %eax,%edx
  80299a:	c1 ea 16             	shr    $0x16,%edx
  80299d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8029a4:	f6 c2 01             	test   $0x1,%dl
  8029a7:	74 24                	je     8029cd <fd_lookup+0x48>
  8029a9:	89 c2                	mov    %eax,%edx
  8029ab:	c1 ea 0c             	shr    $0xc,%edx
  8029ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8029b5:	f6 c2 01             	test   $0x1,%dl
  8029b8:	74 1a                	je     8029d4 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8029ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029bd:	89 02                	mov    %eax,(%edx)
	return 0;
  8029bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c4:	5d                   	pop    %ebp
  8029c5:	c3                   	ret    
		return -E_INVAL;
  8029c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029cb:	eb f7                	jmp    8029c4 <fd_lookup+0x3f>
		return -E_INVAL;
  8029cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029d2:	eb f0                	jmp    8029c4 <fd_lookup+0x3f>
  8029d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029d9:	eb e9                	jmp    8029c4 <fd_lookup+0x3f>

008029db <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8029db:	55                   	push   %ebp
  8029dc:	89 e5                	mov    %esp,%ebp
  8029de:	83 ec 08             	sub    $0x8,%esp
  8029e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029e4:	ba 08 42 80 00       	mov    $0x804208,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8029e9:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  8029ee:	39 08                	cmp    %ecx,(%eax)
  8029f0:	74 33                	je     802a25 <dev_lookup+0x4a>
  8029f2:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8029f5:	8b 02                	mov    (%edx),%eax
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	75 f3                	jne    8029ee <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8029fb:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802a00:	8b 40 48             	mov    0x48(%eax),%eax
  802a03:	83 ec 04             	sub    $0x4,%esp
  802a06:	51                   	push   %ecx
  802a07:	50                   	push   %eax
  802a08:	68 88 41 80 00       	push   $0x804188
  802a0d:	e8 27 f2 ff ff       	call   801c39 <cprintf>
	*dev = 0;
  802a12:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802a1b:	83 c4 10             	add    $0x10,%esp
  802a1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802a23:	c9                   	leave  
  802a24:	c3                   	ret    
			*dev = devtab[i];
  802a25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a28:	89 01                	mov    %eax,(%ecx)
			return 0;
  802a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2f:	eb f2                	jmp    802a23 <dev_lookup+0x48>

00802a31 <fd_close>:
{
  802a31:	55                   	push   %ebp
  802a32:	89 e5                	mov    %esp,%ebp
  802a34:	57                   	push   %edi
  802a35:	56                   	push   %esi
  802a36:	53                   	push   %ebx
  802a37:	83 ec 1c             	sub    $0x1c,%esp
  802a3a:	8b 75 08             	mov    0x8(%ebp),%esi
  802a3d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a40:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802a43:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802a44:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802a4a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802a4d:	50                   	push   %eax
  802a4e:	e8 32 ff ff ff       	call   802985 <fd_lookup>
  802a53:	89 c3                	mov    %eax,%ebx
  802a55:	83 c4 08             	add    $0x8,%esp
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	78 05                	js     802a61 <fd_close+0x30>
	    || fd != fd2)
  802a5c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802a5f:	74 16                	je     802a77 <fd_close+0x46>
		return (must_exist ? r : 0);
  802a61:	89 f8                	mov    %edi,%eax
  802a63:	84 c0                	test   %al,%al
  802a65:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6a:	0f 44 d8             	cmove  %eax,%ebx
}
  802a6d:	89 d8                	mov    %ebx,%eax
  802a6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a72:	5b                   	pop    %ebx
  802a73:	5e                   	pop    %esi
  802a74:	5f                   	pop    %edi
  802a75:	5d                   	pop    %ebp
  802a76:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802a77:	83 ec 08             	sub    $0x8,%esp
  802a7a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802a7d:	50                   	push   %eax
  802a7e:	ff 36                	pushl  (%esi)
  802a80:	e8 56 ff ff ff       	call   8029db <dev_lookup>
  802a85:	89 c3                	mov    %eax,%ebx
  802a87:	83 c4 10             	add    $0x10,%esp
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	78 15                	js     802aa3 <fd_close+0x72>
		if (dev->dev_close)
  802a8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a91:	8b 40 10             	mov    0x10(%eax),%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	74 1b                	je     802ab3 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  802a98:	83 ec 0c             	sub    $0xc,%esp
  802a9b:	56                   	push   %esi
  802a9c:	ff d0                	call   *%eax
  802a9e:	89 c3                	mov    %eax,%ebx
  802aa0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802aa3:	83 ec 08             	sub    $0x8,%esp
  802aa6:	56                   	push   %esi
  802aa7:	6a 00                	push   $0x0
  802aa9:	e8 f3 fb ff ff       	call   8026a1 <sys_page_unmap>
	return r;
  802aae:	83 c4 10             	add    $0x10,%esp
  802ab1:	eb ba                	jmp    802a6d <fd_close+0x3c>
			r = 0;
  802ab3:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ab8:	eb e9                	jmp    802aa3 <fd_close+0x72>

00802aba <close>:

int
close(int fdnum)
{
  802aba:	55                   	push   %ebp
  802abb:	89 e5                	mov    %esp,%ebp
  802abd:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ac0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ac3:	50                   	push   %eax
  802ac4:	ff 75 08             	pushl  0x8(%ebp)
  802ac7:	e8 b9 fe ff ff       	call   802985 <fd_lookup>
  802acc:	83 c4 08             	add    $0x8,%esp
  802acf:	85 c0                	test   %eax,%eax
  802ad1:	78 10                	js     802ae3 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  802ad3:	83 ec 08             	sub    $0x8,%esp
  802ad6:	6a 01                	push   $0x1
  802ad8:	ff 75 f4             	pushl  -0xc(%ebp)
  802adb:	e8 51 ff ff ff       	call   802a31 <fd_close>
  802ae0:	83 c4 10             	add    $0x10,%esp
}
  802ae3:	c9                   	leave  
  802ae4:	c3                   	ret    

00802ae5 <close_all>:

void
close_all(void)
{
  802ae5:	55                   	push   %ebp
  802ae6:	89 e5                	mov    %esp,%ebp
  802ae8:	53                   	push   %ebx
  802ae9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802aec:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802af1:	83 ec 0c             	sub    $0xc,%esp
  802af4:	53                   	push   %ebx
  802af5:	e8 c0 ff ff ff       	call   802aba <close>
	for (i = 0; i < MAXFD; i++)
  802afa:	83 c3 01             	add    $0x1,%ebx
  802afd:	83 c4 10             	add    $0x10,%esp
  802b00:	83 fb 20             	cmp    $0x20,%ebx
  802b03:	75 ec                	jne    802af1 <close_all+0xc>
}
  802b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b08:	c9                   	leave  
  802b09:	c3                   	ret    

00802b0a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
  802b0d:	57                   	push   %edi
  802b0e:	56                   	push   %esi
  802b0f:	53                   	push   %ebx
  802b10:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b13:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802b16:	50                   	push   %eax
  802b17:	ff 75 08             	pushl  0x8(%ebp)
  802b1a:	e8 66 fe ff ff       	call   802985 <fd_lookup>
  802b1f:	89 c3                	mov    %eax,%ebx
  802b21:	83 c4 08             	add    $0x8,%esp
  802b24:	85 c0                	test   %eax,%eax
  802b26:	0f 88 81 00 00 00    	js     802bad <dup+0xa3>
		return r;
	close(newfdnum);
  802b2c:	83 ec 0c             	sub    $0xc,%esp
  802b2f:	ff 75 0c             	pushl  0xc(%ebp)
  802b32:	e8 83 ff ff ff       	call   802aba <close>

	newfd = INDEX2FD(newfdnum);
  802b37:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b3a:	c1 e6 0c             	shl    $0xc,%esi
  802b3d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802b43:	83 c4 04             	add    $0x4,%esp
  802b46:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b49:	e8 d1 fd ff ff       	call   80291f <fd2data>
  802b4e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802b50:	89 34 24             	mov    %esi,(%esp)
  802b53:	e8 c7 fd ff ff       	call   80291f <fd2data>
  802b58:	83 c4 10             	add    $0x10,%esp
  802b5b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802b5d:	89 d8                	mov    %ebx,%eax
  802b5f:	c1 e8 16             	shr    $0x16,%eax
  802b62:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802b69:	a8 01                	test   $0x1,%al
  802b6b:	74 11                	je     802b7e <dup+0x74>
  802b6d:	89 d8                	mov    %ebx,%eax
  802b6f:	c1 e8 0c             	shr    $0xc,%eax
  802b72:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802b79:	f6 c2 01             	test   $0x1,%dl
  802b7c:	75 39                	jne    802bb7 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b81:	89 d0                	mov    %edx,%eax
  802b83:	c1 e8 0c             	shr    $0xc,%eax
  802b86:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802b8d:	83 ec 0c             	sub    $0xc,%esp
  802b90:	25 07 0e 00 00       	and    $0xe07,%eax
  802b95:	50                   	push   %eax
  802b96:	56                   	push   %esi
  802b97:	6a 00                	push   $0x0
  802b99:	52                   	push   %edx
  802b9a:	6a 00                	push   $0x0
  802b9c:	e8 be fa ff ff       	call   80265f <sys_page_map>
  802ba1:	89 c3                	mov    %eax,%ebx
  802ba3:	83 c4 20             	add    $0x20,%esp
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	78 31                	js     802bdb <dup+0xd1>
		goto err;

	return newfdnum;
  802baa:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802bad:	89 d8                	mov    %ebx,%eax
  802baf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802bb2:	5b                   	pop    %ebx
  802bb3:	5e                   	pop    %esi
  802bb4:	5f                   	pop    %edi
  802bb5:	5d                   	pop    %ebp
  802bb6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802bb7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802bbe:	83 ec 0c             	sub    $0xc,%esp
  802bc1:	25 07 0e 00 00       	and    $0xe07,%eax
  802bc6:	50                   	push   %eax
  802bc7:	57                   	push   %edi
  802bc8:	6a 00                	push   $0x0
  802bca:	53                   	push   %ebx
  802bcb:	6a 00                	push   $0x0
  802bcd:	e8 8d fa ff ff       	call   80265f <sys_page_map>
  802bd2:	89 c3                	mov    %eax,%ebx
  802bd4:	83 c4 20             	add    $0x20,%esp
  802bd7:	85 c0                	test   %eax,%eax
  802bd9:	79 a3                	jns    802b7e <dup+0x74>
	sys_page_unmap(0, newfd);
  802bdb:	83 ec 08             	sub    $0x8,%esp
  802bde:	56                   	push   %esi
  802bdf:	6a 00                	push   $0x0
  802be1:	e8 bb fa ff ff       	call   8026a1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802be6:	83 c4 08             	add    $0x8,%esp
  802be9:	57                   	push   %edi
  802bea:	6a 00                	push   $0x0
  802bec:	e8 b0 fa ff ff       	call   8026a1 <sys_page_unmap>
	return r;
  802bf1:	83 c4 10             	add    $0x10,%esp
  802bf4:	eb b7                	jmp    802bad <dup+0xa3>

00802bf6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802bf6:	55                   	push   %ebp
  802bf7:	89 e5                	mov    %esp,%ebp
  802bf9:	53                   	push   %ebx
  802bfa:	83 ec 14             	sub    $0x14,%esp
  802bfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c00:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802c03:	50                   	push   %eax
  802c04:	53                   	push   %ebx
  802c05:	e8 7b fd ff ff       	call   802985 <fd_lookup>
  802c0a:	83 c4 08             	add    $0x8,%esp
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	78 3f                	js     802c50 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c11:	83 ec 08             	sub    $0x8,%esp
  802c14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c17:	50                   	push   %eax
  802c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1b:	ff 30                	pushl  (%eax)
  802c1d:	e8 b9 fd ff ff       	call   8029db <dev_lookup>
  802c22:	83 c4 10             	add    $0x10,%esp
  802c25:	85 c0                	test   %eax,%eax
  802c27:	78 27                	js     802c50 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c2c:	8b 42 08             	mov    0x8(%edx),%eax
  802c2f:	83 e0 03             	and    $0x3,%eax
  802c32:	83 f8 01             	cmp    $0x1,%eax
  802c35:	74 1e                	je     802c55 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 40 08             	mov    0x8(%eax),%eax
  802c3d:	85 c0                	test   %eax,%eax
  802c3f:	74 35                	je     802c76 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802c41:	83 ec 04             	sub    $0x4,%esp
  802c44:	ff 75 10             	pushl  0x10(%ebp)
  802c47:	ff 75 0c             	pushl  0xc(%ebp)
  802c4a:	52                   	push   %edx
  802c4b:	ff d0                	call   *%eax
  802c4d:	83 c4 10             	add    $0x10,%esp
}
  802c50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c53:	c9                   	leave  
  802c54:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c55:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802c5a:	8b 40 48             	mov    0x48(%eax),%eax
  802c5d:	83 ec 04             	sub    $0x4,%esp
  802c60:	53                   	push   %ebx
  802c61:	50                   	push   %eax
  802c62:	68 cc 41 80 00       	push   $0x8041cc
  802c67:	e8 cd ef ff ff       	call   801c39 <cprintf>
		return -E_INVAL;
  802c6c:	83 c4 10             	add    $0x10,%esp
  802c6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c74:	eb da                	jmp    802c50 <read+0x5a>
		return -E_NOT_SUPP;
  802c76:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802c7b:	eb d3                	jmp    802c50 <read+0x5a>

00802c7d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802c7d:	55                   	push   %ebp
  802c7e:	89 e5                	mov    %esp,%ebp
  802c80:	57                   	push   %edi
  802c81:	56                   	push   %esi
  802c82:	53                   	push   %ebx
  802c83:	83 ec 0c             	sub    $0xc,%esp
  802c86:	8b 7d 08             	mov    0x8(%ebp),%edi
  802c89:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802c91:	39 f3                	cmp    %esi,%ebx
  802c93:	73 25                	jae    802cba <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802c95:	83 ec 04             	sub    $0x4,%esp
  802c98:	89 f0                	mov    %esi,%eax
  802c9a:	29 d8                	sub    %ebx,%eax
  802c9c:	50                   	push   %eax
  802c9d:	89 d8                	mov    %ebx,%eax
  802c9f:	03 45 0c             	add    0xc(%ebp),%eax
  802ca2:	50                   	push   %eax
  802ca3:	57                   	push   %edi
  802ca4:	e8 4d ff ff ff       	call   802bf6 <read>
		if (m < 0)
  802ca9:	83 c4 10             	add    $0x10,%esp
  802cac:	85 c0                	test   %eax,%eax
  802cae:	78 08                	js     802cb8 <readn+0x3b>
			return m;
		if (m == 0)
  802cb0:	85 c0                	test   %eax,%eax
  802cb2:	74 06                	je     802cba <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  802cb4:	01 c3                	add    %eax,%ebx
  802cb6:	eb d9                	jmp    802c91 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802cb8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802cba:	89 d8                	mov    %ebx,%eax
  802cbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cbf:	5b                   	pop    %ebx
  802cc0:	5e                   	pop    %esi
  802cc1:	5f                   	pop    %edi
  802cc2:	5d                   	pop    %ebp
  802cc3:	c3                   	ret    

00802cc4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802cc4:	55                   	push   %ebp
  802cc5:	89 e5                	mov    %esp,%ebp
  802cc7:	53                   	push   %ebx
  802cc8:	83 ec 14             	sub    $0x14,%esp
  802ccb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802cd1:	50                   	push   %eax
  802cd2:	53                   	push   %ebx
  802cd3:	e8 ad fc ff ff       	call   802985 <fd_lookup>
  802cd8:	83 c4 08             	add    $0x8,%esp
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	78 3a                	js     802d19 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cdf:	83 ec 08             	sub    $0x8,%esp
  802ce2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ce5:	50                   	push   %eax
  802ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce9:	ff 30                	pushl  (%eax)
  802ceb:	e8 eb fc ff ff       	call   8029db <dev_lookup>
  802cf0:	83 c4 10             	add    $0x10,%esp
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	78 22                	js     802d19 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802cfe:	74 1e                	je     802d1e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d03:	8b 52 0c             	mov    0xc(%edx),%edx
  802d06:	85 d2                	test   %edx,%edx
  802d08:	74 35                	je     802d3f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802d0a:	83 ec 04             	sub    $0x4,%esp
  802d0d:	ff 75 10             	pushl  0x10(%ebp)
  802d10:	ff 75 0c             	pushl  0xc(%ebp)
  802d13:	50                   	push   %eax
  802d14:	ff d2                	call   *%edx
  802d16:	83 c4 10             	add    $0x10,%esp
}
  802d19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d1c:	c9                   	leave  
  802d1d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d1e:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802d23:	8b 40 48             	mov    0x48(%eax),%eax
  802d26:	83 ec 04             	sub    $0x4,%esp
  802d29:	53                   	push   %ebx
  802d2a:	50                   	push   %eax
  802d2b:	68 e8 41 80 00       	push   $0x8041e8
  802d30:	e8 04 ef ff ff       	call   801c39 <cprintf>
		return -E_INVAL;
  802d35:	83 c4 10             	add    $0x10,%esp
  802d38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d3d:	eb da                	jmp    802d19 <write+0x55>
		return -E_NOT_SUPP;
  802d3f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802d44:	eb d3                	jmp    802d19 <write+0x55>

00802d46 <seek>:

int
seek(int fdnum, off_t offset)
{
  802d46:	55                   	push   %ebp
  802d47:	89 e5                	mov    %esp,%ebp
  802d49:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d4c:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802d4f:	50                   	push   %eax
  802d50:	ff 75 08             	pushl  0x8(%ebp)
  802d53:	e8 2d fc ff ff       	call   802985 <fd_lookup>
  802d58:	83 c4 08             	add    $0x8,%esp
  802d5b:	85 c0                	test   %eax,%eax
  802d5d:	78 0e                	js     802d6d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d65:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d6d:	c9                   	leave  
  802d6e:	c3                   	ret    

00802d6f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d6f:	55                   	push   %ebp
  802d70:	89 e5                	mov    %esp,%ebp
  802d72:	53                   	push   %ebx
  802d73:	83 ec 14             	sub    $0x14,%esp
  802d76:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d79:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802d7c:	50                   	push   %eax
  802d7d:	53                   	push   %ebx
  802d7e:	e8 02 fc ff ff       	call   802985 <fd_lookup>
  802d83:	83 c4 08             	add    $0x8,%esp
  802d86:	85 c0                	test   %eax,%eax
  802d88:	78 37                	js     802dc1 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d8a:	83 ec 08             	sub    $0x8,%esp
  802d8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d90:	50                   	push   %eax
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	ff 30                	pushl  (%eax)
  802d96:	e8 40 fc ff ff       	call   8029db <dev_lookup>
  802d9b:	83 c4 10             	add    $0x10,%esp
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	78 1f                	js     802dc1 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802da9:	74 1b                	je     802dc6 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802dab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dae:	8b 52 18             	mov    0x18(%edx),%edx
  802db1:	85 d2                	test   %edx,%edx
  802db3:	74 32                	je     802de7 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802db5:	83 ec 08             	sub    $0x8,%esp
  802db8:	ff 75 0c             	pushl  0xc(%ebp)
  802dbb:	50                   	push   %eax
  802dbc:	ff d2                	call   *%edx
  802dbe:	83 c4 10             	add    $0x10,%esp
}
  802dc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802dc4:	c9                   	leave  
  802dc5:	c3                   	ret    
			thisenv->env_id, fdnum);
  802dc6:	a1 0c a0 80 00       	mov    0x80a00c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802dcb:	8b 40 48             	mov    0x48(%eax),%eax
  802dce:	83 ec 04             	sub    $0x4,%esp
  802dd1:	53                   	push   %ebx
  802dd2:	50                   	push   %eax
  802dd3:	68 a8 41 80 00       	push   $0x8041a8
  802dd8:	e8 5c ee ff ff       	call   801c39 <cprintf>
		return -E_INVAL;
  802ddd:	83 c4 10             	add    $0x10,%esp
  802de0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802de5:	eb da                	jmp    802dc1 <ftruncate+0x52>
		return -E_NOT_SUPP;
  802de7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802dec:	eb d3                	jmp    802dc1 <ftruncate+0x52>

00802dee <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802dee:	55                   	push   %ebp
  802def:	89 e5                	mov    %esp,%ebp
  802df1:	53                   	push   %ebx
  802df2:	83 ec 14             	sub    $0x14,%esp
  802df5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802df8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802dfb:	50                   	push   %eax
  802dfc:	ff 75 08             	pushl  0x8(%ebp)
  802dff:	e8 81 fb ff ff       	call   802985 <fd_lookup>
  802e04:	83 c4 08             	add    $0x8,%esp
  802e07:	85 c0                	test   %eax,%eax
  802e09:	78 4b                	js     802e56 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e0b:	83 ec 08             	sub    $0x8,%esp
  802e0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e11:	50                   	push   %eax
  802e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e15:	ff 30                	pushl  (%eax)
  802e17:	e8 bf fb ff ff       	call   8029db <dev_lookup>
  802e1c:	83 c4 10             	add    $0x10,%esp
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	78 33                	js     802e56 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802e2a:	74 2f                	je     802e5b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802e2c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802e2f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802e36:	00 00 00 
	stat->st_isdir = 0;
  802e39:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802e40:	00 00 00 
	stat->st_dev = dev;
  802e43:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802e49:	83 ec 08             	sub    $0x8,%esp
  802e4c:	53                   	push   %ebx
  802e4d:	ff 75 f0             	pushl  -0x10(%ebp)
  802e50:	ff 50 14             	call   *0x14(%eax)
  802e53:	83 c4 10             	add    $0x10,%esp
}
  802e56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e59:	c9                   	leave  
  802e5a:	c3                   	ret    
		return -E_NOT_SUPP;
  802e5b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e60:	eb f4                	jmp    802e56 <fstat+0x68>

00802e62 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e62:	55                   	push   %ebp
  802e63:	89 e5                	mov    %esp,%ebp
  802e65:	56                   	push   %esi
  802e66:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e67:	83 ec 08             	sub    $0x8,%esp
  802e6a:	6a 00                	push   $0x0
  802e6c:	ff 75 08             	pushl  0x8(%ebp)
  802e6f:	e8 e7 01 00 00       	call   80305b <open>
  802e74:	89 c3                	mov    %eax,%ebx
  802e76:	83 c4 10             	add    $0x10,%esp
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	78 1b                	js     802e98 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802e7d:	83 ec 08             	sub    $0x8,%esp
  802e80:	ff 75 0c             	pushl  0xc(%ebp)
  802e83:	50                   	push   %eax
  802e84:	e8 65 ff ff ff       	call   802dee <fstat>
  802e89:	89 c6                	mov    %eax,%esi
	close(fd);
  802e8b:	89 1c 24             	mov    %ebx,(%esp)
  802e8e:	e8 27 fc ff ff       	call   802aba <close>
	return r;
  802e93:	83 c4 10             	add    $0x10,%esp
  802e96:	89 f3                	mov    %esi,%ebx
}
  802e98:	89 d8                	mov    %ebx,%eax
  802e9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e9d:	5b                   	pop    %ebx
  802e9e:	5e                   	pop    %esi
  802e9f:	5d                   	pop    %ebp
  802ea0:	c3                   	ret    

00802ea1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ea1:	55                   	push   %ebp
  802ea2:	89 e5                	mov    %esp,%ebp
  802ea4:	56                   	push   %esi
  802ea5:	53                   	push   %ebx
  802ea6:	89 c6                	mov    %eax,%esi
  802ea8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802eaa:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  802eb1:	74 27                	je     802eda <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802eb3:	6a 07                	push   $0x7
  802eb5:	68 00 b0 80 00       	push   $0x80b000
  802eba:	56                   	push   %esi
  802ebb:	ff 35 00 a0 80 00    	pushl  0x80a000
  802ec1:	e8 f9 f9 ff ff       	call   8028bf <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802ec6:	83 c4 0c             	add    $0xc,%esp
  802ec9:	6a 00                	push   $0x0
  802ecb:	53                   	push   %ebx
  802ecc:	6a 00                	push   $0x0
  802ece:	e8 d5 f9 ff ff       	call   8028a8 <ipc_recv>
}
  802ed3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ed6:	5b                   	pop    %ebx
  802ed7:	5e                   	pop    %esi
  802ed8:	5d                   	pop    %ebp
  802ed9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802eda:	83 ec 0c             	sub    $0xc,%esp
  802edd:	6a 01                	push   $0x1
  802edf:	e8 f2 f9 ff ff       	call   8028d6 <ipc_find_env>
  802ee4:	a3 00 a0 80 00       	mov    %eax,0x80a000
  802ee9:	83 c4 10             	add    $0x10,%esp
  802eec:	eb c5                	jmp    802eb3 <fsipc+0x12>

00802eee <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802eee:	55                   	push   %ebp
  802eef:	89 e5                	mov    %esp,%ebp
  802ef1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	8b 40 0c             	mov    0xc(%eax),%eax
  802efa:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  802eff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f02:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f07:	ba 00 00 00 00       	mov    $0x0,%edx
  802f0c:	b8 02 00 00 00       	mov    $0x2,%eax
  802f11:	e8 8b ff ff ff       	call   802ea1 <fsipc>
}
  802f16:	c9                   	leave  
  802f17:	c3                   	ret    

00802f18 <devfile_flush>:
{
  802f18:	55                   	push   %ebp
  802f19:	89 e5                	mov    %esp,%ebp
  802f1b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	8b 40 0c             	mov    0xc(%eax),%eax
  802f24:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  802f29:	ba 00 00 00 00       	mov    $0x0,%edx
  802f2e:	b8 06 00 00 00       	mov    $0x6,%eax
  802f33:	e8 69 ff ff ff       	call   802ea1 <fsipc>
}
  802f38:	c9                   	leave  
  802f39:	c3                   	ret    

00802f3a <devfile_stat>:
{
  802f3a:	55                   	push   %ebp
  802f3b:	89 e5                	mov    %esp,%ebp
  802f3d:	53                   	push   %ebx
  802f3e:	83 ec 04             	sub    $0x4,%esp
  802f41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4a:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802f4f:	ba 00 00 00 00       	mov    $0x0,%edx
  802f54:	b8 05 00 00 00       	mov    $0x5,%eax
  802f59:	e8 43 ff ff ff       	call   802ea1 <fsipc>
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	78 2c                	js     802f8e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f62:	83 ec 08             	sub    $0x8,%esp
  802f65:	68 00 b0 80 00       	push   $0x80b000
  802f6a:	53                   	push   %ebx
  802f6b:	e8 b3 f2 ff ff       	call   802223 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802f70:	a1 80 b0 80 00       	mov    0x80b080,%eax
  802f75:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f7b:	a1 84 b0 80 00       	mov    0x80b084,%eax
  802f80:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802f86:	83 c4 10             	add    $0x10,%esp
  802f89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f91:	c9                   	leave  
  802f92:	c3                   	ret    

00802f93 <devfile_write>:
{
  802f93:	55                   	push   %ebp
  802f94:	89 e5                	mov    %esp,%ebp
  802f96:	83 ec 0c             	sub    $0xc,%esp
  802f99:	8b 45 10             	mov    0x10(%ebp),%eax
  802f9c:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  802fa1:	ba f8 0f 00 00       	mov    $0xff8,%edx
  802fa6:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  802fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fac:	8b 52 0c             	mov    0xc(%edx),%edx
  802faf:	89 15 00 b0 80 00    	mov    %edx,0x80b000
        fsipcbuf.write.req_n = n;
  802fb5:	a3 04 b0 80 00       	mov    %eax,0x80b004
        memmove(fsipcbuf.write.req_buf, buf, n);
  802fba:	50                   	push   %eax
  802fbb:	ff 75 0c             	pushl  0xc(%ebp)
  802fbe:	68 08 b0 80 00       	push   $0x80b008
  802fc3:	e8 e9 f3 ff ff       	call   8023b1 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802fc8:	ba 00 00 00 00       	mov    $0x0,%edx
  802fcd:	b8 04 00 00 00       	mov    $0x4,%eax
  802fd2:	e8 ca fe ff ff       	call   802ea1 <fsipc>
}
  802fd7:	c9                   	leave  
  802fd8:	c3                   	ret    

00802fd9 <devfile_read>:
{
  802fd9:	55                   	push   %ebp
  802fda:	89 e5                	mov    %esp,%ebp
  802fdc:	56                   	push   %esi
  802fdd:	53                   	push   %ebx
  802fde:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe7:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  802fec:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802ff2:	ba 00 00 00 00       	mov    $0x0,%edx
  802ff7:	b8 03 00 00 00       	mov    $0x3,%eax
  802ffc:	e8 a0 fe ff ff       	call   802ea1 <fsipc>
  803001:	89 c3                	mov    %eax,%ebx
  803003:	85 c0                	test   %eax,%eax
  803005:	78 1f                	js     803026 <devfile_read+0x4d>
	assert(r <= n);
  803007:	39 f0                	cmp    %esi,%eax
  803009:	77 24                	ja     80302f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80300b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803010:	7f 33                	jg     803045 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  803012:	83 ec 04             	sub    $0x4,%esp
  803015:	50                   	push   %eax
  803016:	68 00 b0 80 00       	push   $0x80b000
  80301b:	ff 75 0c             	pushl  0xc(%ebp)
  80301e:	e8 8e f3 ff ff       	call   8023b1 <memmove>
	return r;
  803023:	83 c4 10             	add    $0x10,%esp
}
  803026:	89 d8                	mov    %ebx,%eax
  803028:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80302b:	5b                   	pop    %ebx
  80302c:	5e                   	pop    %esi
  80302d:	5d                   	pop    %ebp
  80302e:	c3                   	ret    
	assert(r <= n);
  80302f:	68 18 42 80 00       	push   $0x804218
  803034:	68 9d 38 80 00       	push   $0x80389d
  803039:	6a 7c                	push   $0x7c
  80303b:	68 1f 42 80 00       	push   $0x80421f
  803040:	e8 19 eb ff ff       	call   801b5e <_panic>
	assert(r <= PGSIZE);
  803045:	68 2a 42 80 00       	push   $0x80422a
  80304a:	68 9d 38 80 00       	push   $0x80389d
  80304f:	6a 7d                	push   $0x7d
  803051:	68 1f 42 80 00       	push   $0x80421f
  803056:	e8 03 eb ff ff       	call   801b5e <_panic>

0080305b <open>:
{
  80305b:	55                   	push   %ebp
  80305c:	89 e5                	mov    %esp,%ebp
  80305e:	56                   	push   %esi
  80305f:	53                   	push   %ebx
  803060:	83 ec 1c             	sub    $0x1c,%esp
  803063:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  803066:	56                   	push   %esi
  803067:	e8 80 f1 ff ff       	call   8021ec <strlen>
  80306c:	83 c4 10             	add    $0x10,%esp
  80306f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803074:	7f 6c                	jg     8030e2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  803076:	83 ec 0c             	sub    $0xc,%esp
  803079:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80307c:	50                   	push   %eax
  80307d:	e8 b4 f8 ff ff       	call   802936 <fd_alloc>
  803082:	89 c3                	mov    %eax,%ebx
  803084:	83 c4 10             	add    $0x10,%esp
  803087:	85 c0                	test   %eax,%eax
  803089:	78 3c                	js     8030c7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80308b:	83 ec 08             	sub    $0x8,%esp
  80308e:	56                   	push   %esi
  80308f:	68 00 b0 80 00       	push   $0x80b000
  803094:	e8 8a f1 ff ff       	call   802223 <strcpy>
	fsipcbuf.open.req_omode = mode;
  803099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309c:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8030a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8030a9:	e8 f3 fd ff ff       	call   802ea1 <fsipc>
  8030ae:	89 c3                	mov    %eax,%ebx
  8030b0:	83 c4 10             	add    $0x10,%esp
  8030b3:	85 c0                	test   %eax,%eax
  8030b5:	78 19                	js     8030d0 <open+0x75>
	return fd2num(fd);
  8030b7:	83 ec 0c             	sub    $0xc,%esp
  8030ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8030bd:	e8 4d f8 ff ff       	call   80290f <fd2num>
  8030c2:	89 c3                	mov    %eax,%ebx
  8030c4:	83 c4 10             	add    $0x10,%esp
}
  8030c7:	89 d8                	mov    %ebx,%eax
  8030c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030cc:	5b                   	pop    %ebx
  8030cd:	5e                   	pop    %esi
  8030ce:	5d                   	pop    %ebp
  8030cf:	c3                   	ret    
		fd_close(fd, 0);
  8030d0:	83 ec 08             	sub    $0x8,%esp
  8030d3:	6a 00                	push   $0x0
  8030d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8030d8:	e8 54 f9 ff ff       	call   802a31 <fd_close>
		return r;
  8030dd:	83 c4 10             	add    $0x10,%esp
  8030e0:	eb e5                	jmp    8030c7 <open+0x6c>
		return -E_BAD_PATH;
  8030e2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8030e7:	eb de                	jmp    8030c7 <open+0x6c>

008030e9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8030e9:	55                   	push   %ebp
  8030ea:	89 e5                	mov    %esp,%ebp
  8030ec:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8030ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8030f4:	b8 08 00 00 00       	mov    $0x8,%eax
  8030f9:	e8 a3 fd ff ff       	call   802ea1 <fsipc>
}
  8030fe:	c9                   	leave  
  8030ff:	c3                   	ret    

00803100 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803100:	55                   	push   %ebp
  803101:	89 e5                	mov    %esp,%ebp
  803103:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803106:	89 d0                	mov    %edx,%eax
  803108:	c1 e8 16             	shr    $0x16,%eax
  80310b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803112:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  803117:	f6 c1 01             	test   $0x1,%cl
  80311a:	74 1d                	je     803139 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80311c:	c1 ea 0c             	shr    $0xc,%edx
  80311f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803126:	f6 c2 01             	test   $0x1,%dl
  803129:	74 0e                	je     803139 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80312b:	c1 ea 0c             	shr    $0xc,%edx
  80312e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803135:	ef 
  803136:	0f b7 c0             	movzwl %ax,%eax
}
  803139:	5d                   	pop    %ebp
  80313a:	c3                   	ret    

0080313b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80313b:	55                   	push   %ebp
  80313c:	89 e5                	mov    %esp,%ebp
  80313e:	56                   	push   %esi
  80313f:	53                   	push   %ebx
  803140:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803143:	83 ec 0c             	sub    $0xc,%esp
  803146:	ff 75 08             	pushl  0x8(%ebp)
  803149:	e8 d1 f7 ff ff       	call   80291f <fd2data>
  80314e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803150:	83 c4 08             	add    $0x8,%esp
  803153:	68 36 42 80 00       	push   $0x804236
  803158:	53                   	push   %ebx
  803159:	e8 c5 f0 ff ff       	call   802223 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80315e:	8b 46 04             	mov    0x4(%esi),%eax
  803161:	2b 06                	sub    (%esi),%eax
  803163:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803169:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803170:	00 00 00 
	stat->st_dev = &devpipe;
  803173:	c7 83 88 00 00 00 80 	movl   $0x809080,0x88(%ebx)
  80317a:	90 80 00 
	return 0;
}
  80317d:	b8 00 00 00 00       	mov    $0x0,%eax
  803182:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803185:	5b                   	pop    %ebx
  803186:	5e                   	pop    %esi
  803187:	5d                   	pop    %ebp
  803188:	c3                   	ret    

00803189 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803189:	55                   	push   %ebp
  80318a:	89 e5                	mov    %esp,%ebp
  80318c:	53                   	push   %ebx
  80318d:	83 ec 0c             	sub    $0xc,%esp
  803190:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803193:	53                   	push   %ebx
  803194:	6a 00                	push   $0x0
  803196:	e8 06 f5 ff ff       	call   8026a1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80319b:	89 1c 24             	mov    %ebx,(%esp)
  80319e:	e8 7c f7 ff ff       	call   80291f <fd2data>
  8031a3:	83 c4 08             	add    $0x8,%esp
  8031a6:	50                   	push   %eax
  8031a7:	6a 00                	push   $0x0
  8031a9:	e8 f3 f4 ff ff       	call   8026a1 <sys_page_unmap>
}
  8031ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031b1:	c9                   	leave  
  8031b2:	c3                   	ret    

008031b3 <_pipeisclosed>:
{
  8031b3:	55                   	push   %ebp
  8031b4:	89 e5                	mov    %esp,%ebp
  8031b6:	57                   	push   %edi
  8031b7:	56                   	push   %esi
  8031b8:	53                   	push   %ebx
  8031b9:	83 ec 1c             	sub    $0x1c,%esp
  8031bc:	89 c7                	mov    %eax,%edi
  8031be:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8031c0:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8031c5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8031c8:	83 ec 0c             	sub    $0xc,%esp
  8031cb:	57                   	push   %edi
  8031cc:	e8 2f ff ff ff       	call   803100 <pageref>
  8031d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8031d4:	89 34 24             	mov    %esi,(%esp)
  8031d7:	e8 24 ff ff ff       	call   803100 <pageref>
		nn = thisenv->env_runs;
  8031dc:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8031e2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8031e5:	83 c4 10             	add    $0x10,%esp
  8031e8:	39 cb                	cmp    %ecx,%ebx
  8031ea:	74 1b                	je     803207 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8031ec:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8031ef:	75 cf                	jne    8031c0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8031f1:	8b 42 58             	mov    0x58(%edx),%eax
  8031f4:	6a 01                	push   $0x1
  8031f6:	50                   	push   %eax
  8031f7:	53                   	push   %ebx
  8031f8:	68 3d 42 80 00       	push   $0x80423d
  8031fd:	e8 37 ea ff ff       	call   801c39 <cprintf>
  803202:	83 c4 10             	add    $0x10,%esp
  803205:	eb b9                	jmp    8031c0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803207:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80320a:	0f 94 c0             	sete   %al
  80320d:	0f b6 c0             	movzbl %al,%eax
}
  803210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803213:	5b                   	pop    %ebx
  803214:	5e                   	pop    %esi
  803215:	5f                   	pop    %edi
  803216:	5d                   	pop    %ebp
  803217:	c3                   	ret    

00803218 <devpipe_write>:
{
  803218:	55                   	push   %ebp
  803219:	89 e5                	mov    %esp,%ebp
  80321b:	57                   	push   %edi
  80321c:	56                   	push   %esi
  80321d:	53                   	push   %ebx
  80321e:	83 ec 28             	sub    $0x28,%esp
  803221:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803224:	56                   	push   %esi
  803225:	e8 f5 f6 ff ff       	call   80291f <fd2data>
  80322a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80322c:	83 c4 10             	add    $0x10,%esp
  80322f:	bf 00 00 00 00       	mov    $0x0,%edi
  803234:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803237:	74 4f                	je     803288 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803239:	8b 43 04             	mov    0x4(%ebx),%eax
  80323c:	8b 0b                	mov    (%ebx),%ecx
  80323e:	8d 51 20             	lea    0x20(%ecx),%edx
  803241:	39 d0                	cmp    %edx,%eax
  803243:	72 14                	jb     803259 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  803245:	89 da                	mov    %ebx,%edx
  803247:	89 f0                	mov    %esi,%eax
  803249:	e8 65 ff ff ff       	call   8031b3 <_pipeisclosed>
  80324e:	85 c0                	test   %eax,%eax
  803250:	75 3a                	jne    80328c <devpipe_write+0x74>
			sys_yield();
  803252:	e8 a6 f3 ff ff       	call   8025fd <sys_yield>
  803257:	eb e0                	jmp    803239 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803259:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80325c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803260:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803263:	89 c2                	mov    %eax,%edx
  803265:	c1 fa 1f             	sar    $0x1f,%edx
  803268:	89 d1                	mov    %edx,%ecx
  80326a:	c1 e9 1b             	shr    $0x1b,%ecx
  80326d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  803270:	83 e2 1f             	and    $0x1f,%edx
  803273:	29 ca                	sub    %ecx,%edx
  803275:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803279:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80327d:	83 c0 01             	add    $0x1,%eax
  803280:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  803283:	83 c7 01             	add    $0x1,%edi
  803286:	eb ac                	jmp    803234 <devpipe_write+0x1c>
	return i;
  803288:	89 f8                	mov    %edi,%eax
  80328a:	eb 05                	jmp    803291 <devpipe_write+0x79>
				return 0;
  80328c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803291:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803294:	5b                   	pop    %ebx
  803295:	5e                   	pop    %esi
  803296:	5f                   	pop    %edi
  803297:	5d                   	pop    %ebp
  803298:	c3                   	ret    

00803299 <devpipe_read>:
{
  803299:	55                   	push   %ebp
  80329a:	89 e5                	mov    %esp,%ebp
  80329c:	57                   	push   %edi
  80329d:	56                   	push   %esi
  80329e:	53                   	push   %ebx
  80329f:	83 ec 18             	sub    $0x18,%esp
  8032a2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8032a5:	57                   	push   %edi
  8032a6:	e8 74 f6 ff ff       	call   80291f <fd2data>
  8032ab:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8032ad:	83 c4 10             	add    $0x10,%esp
  8032b0:	be 00 00 00 00       	mov    $0x0,%esi
  8032b5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8032b8:	74 47                	je     803301 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8032ba:	8b 03                	mov    (%ebx),%eax
  8032bc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8032bf:	75 22                	jne    8032e3 <devpipe_read+0x4a>
			if (i > 0)
  8032c1:	85 f6                	test   %esi,%esi
  8032c3:	75 14                	jne    8032d9 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8032c5:	89 da                	mov    %ebx,%edx
  8032c7:	89 f8                	mov    %edi,%eax
  8032c9:	e8 e5 fe ff ff       	call   8031b3 <_pipeisclosed>
  8032ce:	85 c0                	test   %eax,%eax
  8032d0:	75 33                	jne    803305 <devpipe_read+0x6c>
			sys_yield();
  8032d2:	e8 26 f3 ff ff       	call   8025fd <sys_yield>
  8032d7:	eb e1                	jmp    8032ba <devpipe_read+0x21>
				return i;
  8032d9:	89 f0                	mov    %esi,%eax
}
  8032db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8032de:	5b                   	pop    %ebx
  8032df:	5e                   	pop    %esi
  8032e0:	5f                   	pop    %edi
  8032e1:	5d                   	pop    %ebp
  8032e2:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8032e3:	99                   	cltd   
  8032e4:	c1 ea 1b             	shr    $0x1b,%edx
  8032e7:	01 d0                	add    %edx,%eax
  8032e9:	83 e0 1f             	and    $0x1f,%eax
  8032ec:	29 d0                	sub    %edx,%eax
  8032ee:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8032f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8032f6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8032f9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8032fc:	83 c6 01             	add    $0x1,%esi
  8032ff:	eb b4                	jmp    8032b5 <devpipe_read+0x1c>
	return i;
  803301:	89 f0                	mov    %esi,%eax
  803303:	eb d6                	jmp    8032db <devpipe_read+0x42>
				return 0;
  803305:	b8 00 00 00 00       	mov    $0x0,%eax
  80330a:	eb cf                	jmp    8032db <devpipe_read+0x42>

0080330c <pipe>:
{
  80330c:	55                   	push   %ebp
  80330d:	89 e5                	mov    %esp,%ebp
  80330f:	56                   	push   %esi
  803310:	53                   	push   %ebx
  803311:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803314:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803317:	50                   	push   %eax
  803318:	e8 19 f6 ff ff       	call   802936 <fd_alloc>
  80331d:	89 c3                	mov    %eax,%ebx
  80331f:	83 c4 10             	add    $0x10,%esp
  803322:	85 c0                	test   %eax,%eax
  803324:	78 5b                	js     803381 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803326:	83 ec 04             	sub    $0x4,%esp
  803329:	68 07 04 00 00       	push   $0x407
  80332e:	ff 75 f4             	pushl  -0xc(%ebp)
  803331:	6a 00                	push   $0x0
  803333:	e8 e4 f2 ff ff       	call   80261c <sys_page_alloc>
  803338:	89 c3                	mov    %eax,%ebx
  80333a:	83 c4 10             	add    $0x10,%esp
  80333d:	85 c0                	test   %eax,%eax
  80333f:	78 40                	js     803381 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  803341:	83 ec 0c             	sub    $0xc,%esp
  803344:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803347:	50                   	push   %eax
  803348:	e8 e9 f5 ff ff       	call   802936 <fd_alloc>
  80334d:	89 c3                	mov    %eax,%ebx
  80334f:	83 c4 10             	add    $0x10,%esp
  803352:	85 c0                	test   %eax,%eax
  803354:	78 1b                	js     803371 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803356:	83 ec 04             	sub    $0x4,%esp
  803359:	68 07 04 00 00       	push   $0x407
  80335e:	ff 75 f0             	pushl  -0x10(%ebp)
  803361:	6a 00                	push   $0x0
  803363:	e8 b4 f2 ff ff       	call   80261c <sys_page_alloc>
  803368:	89 c3                	mov    %eax,%ebx
  80336a:	83 c4 10             	add    $0x10,%esp
  80336d:	85 c0                	test   %eax,%eax
  80336f:	79 19                	jns    80338a <pipe+0x7e>
	sys_page_unmap(0, fd0);
  803371:	83 ec 08             	sub    $0x8,%esp
  803374:	ff 75 f4             	pushl  -0xc(%ebp)
  803377:	6a 00                	push   $0x0
  803379:	e8 23 f3 ff ff       	call   8026a1 <sys_page_unmap>
  80337e:	83 c4 10             	add    $0x10,%esp
}
  803381:	89 d8                	mov    %ebx,%eax
  803383:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803386:	5b                   	pop    %ebx
  803387:	5e                   	pop    %esi
  803388:	5d                   	pop    %ebp
  803389:	c3                   	ret    
	va = fd2data(fd0);
  80338a:	83 ec 0c             	sub    $0xc,%esp
  80338d:	ff 75 f4             	pushl  -0xc(%ebp)
  803390:	e8 8a f5 ff ff       	call   80291f <fd2data>
  803395:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803397:	83 c4 0c             	add    $0xc,%esp
  80339a:	68 07 04 00 00       	push   $0x407
  80339f:	50                   	push   %eax
  8033a0:	6a 00                	push   $0x0
  8033a2:	e8 75 f2 ff ff       	call   80261c <sys_page_alloc>
  8033a7:	89 c3                	mov    %eax,%ebx
  8033a9:	83 c4 10             	add    $0x10,%esp
  8033ac:	85 c0                	test   %eax,%eax
  8033ae:	0f 88 8c 00 00 00    	js     803440 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033b4:	83 ec 0c             	sub    $0xc,%esp
  8033b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8033ba:	e8 60 f5 ff ff       	call   80291f <fd2data>
  8033bf:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8033c6:	50                   	push   %eax
  8033c7:	6a 00                	push   $0x0
  8033c9:	56                   	push   %esi
  8033ca:	6a 00                	push   $0x0
  8033cc:	e8 8e f2 ff ff       	call   80265f <sys_page_map>
  8033d1:	89 c3                	mov    %eax,%ebx
  8033d3:	83 c4 20             	add    $0x20,%esp
  8033d6:	85 c0                	test   %eax,%eax
  8033d8:	78 58                	js     803432 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dd:	8b 15 80 90 80 00    	mov    0x809080,%edx
  8033e3:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8033e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8033ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f2:	8b 15 80 90 80 00    	mov    0x809080,%edx
  8033f8:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8033fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  803404:	83 ec 0c             	sub    $0xc,%esp
  803407:	ff 75 f4             	pushl  -0xc(%ebp)
  80340a:	e8 00 f5 ff ff       	call   80290f <fd2num>
  80340f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803412:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803414:	83 c4 04             	add    $0x4,%esp
  803417:	ff 75 f0             	pushl  -0x10(%ebp)
  80341a:	e8 f0 f4 ff ff       	call   80290f <fd2num>
  80341f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803422:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803425:	83 c4 10             	add    $0x10,%esp
  803428:	bb 00 00 00 00       	mov    $0x0,%ebx
  80342d:	e9 4f ff ff ff       	jmp    803381 <pipe+0x75>
	sys_page_unmap(0, va);
  803432:	83 ec 08             	sub    $0x8,%esp
  803435:	56                   	push   %esi
  803436:	6a 00                	push   $0x0
  803438:	e8 64 f2 ff ff       	call   8026a1 <sys_page_unmap>
  80343d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803440:	83 ec 08             	sub    $0x8,%esp
  803443:	ff 75 f0             	pushl  -0x10(%ebp)
  803446:	6a 00                	push   $0x0
  803448:	e8 54 f2 ff ff       	call   8026a1 <sys_page_unmap>
  80344d:	83 c4 10             	add    $0x10,%esp
  803450:	e9 1c ff ff ff       	jmp    803371 <pipe+0x65>

00803455 <pipeisclosed>:
{
  803455:	55                   	push   %ebp
  803456:	89 e5                	mov    %esp,%ebp
  803458:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80345b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80345e:	50                   	push   %eax
  80345f:	ff 75 08             	pushl  0x8(%ebp)
  803462:	e8 1e f5 ff ff       	call   802985 <fd_lookup>
  803467:	83 c4 10             	add    $0x10,%esp
  80346a:	85 c0                	test   %eax,%eax
  80346c:	78 18                	js     803486 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80346e:	83 ec 0c             	sub    $0xc,%esp
  803471:	ff 75 f4             	pushl  -0xc(%ebp)
  803474:	e8 a6 f4 ff ff       	call   80291f <fd2data>
	return _pipeisclosed(fd, p);
  803479:	89 c2                	mov    %eax,%edx
  80347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347e:	e8 30 fd ff ff       	call   8031b3 <_pipeisclosed>
  803483:	83 c4 10             	add    $0x10,%esp
}
  803486:	c9                   	leave  
  803487:	c3                   	ret    

00803488 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803488:	55                   	push   %ebp
  803489:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80348b:	b8 00 00 00 00       	mov    $0x0,%eax
  803490:	5d                   	pop    %ebp
  803491:	c3                   	ret    

00803492 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803492:	55                   	push   %ebp
  803493:	89 e5                	mov    %esp,%ebp
  803495:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  803498:	68 55 42 80 00       	push   $0x804255
  80349d:	ff 75 0c             	pushl  0xc(%ebp)
  8034a0:	e8 7e ed ff ff       	call   802223 <strcpy>
	return 0;
}
  8034a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034aa:	c9                   	leave  
  8034ab:	c3                   	ret    

008034ac <devcons_write>:
{
  8034ac:	55                   	push   %ebp
  8034ad:	89 e5                	mov    %esp,%ebp
  8034af:	57                   	push   %edi
  8034b0:	56                   	push   %esi
  8034b1:	53                   	push   %ebx
  8034b2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8034b8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8034bd:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8034c3:	eb 2f                	jmp    8034f4 <devcons_write+0x48>
		m = n - tot;
  8034c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8034c8:	29 f3                	sub    %esi,%ebx
  8034ca:	83 fb 7f             	cmp    $0x7f,%ebx
  8034cd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8034d2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8034d5:	83 ec 04             	sub    $0x4,%esp
  8034d8:	53                   	push   %ebx
  8034d9:	89 f0                	mov    %esi,%eax
  8034db:	03 45 0c             	add    0xc(%ebp),%eax
  8034de:	50                   	push   %eax
  8034df:	57                   	push   %edi
  8034e0:	e8 cc ee ff ff       	call   8023b1 <memmove>
		sys_cputs(buf, m);
  8034e5:	83 c4 08             	add    $0x8,%esp
  8034e8:	53                   	push   %ebx
  8034e9:	57                   	push   %edi
  8034ea:	e8 71 f0 ff ff       	call   802560 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8034ef:	01 de                	add    %ebx,%esi
  8034f1:	83 c4 10             	add    $0x10,%esp
  8034f4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8034f7:	72 cc                	jb     8034c5 <devcons_write+0x19>
}
  8034f9:	89 f0                	mov    %esi,%eax
  8034fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8034fe:	5b                   	pop    %ebx
  8034ff:	5e                   	pop    %esi
  803500:	5f                   	pop    %edi
  803501:	5d                   	pop    %ebp
  803502:	c3                   	ret    

00803503 <devcons_read>:
{
  803503:	55                   	push   %ebp
  803504:	89 e5                	mov    %esp,%ebp
  803506:	83 ec 08             	sub    $0x8,%esp
  803509:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80350e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803512:	75 07                	jne    80351b <devcons_read+0x18>
}
  803514:	c9                   	leave  
  803515:	c3                   	ret    
		sys_yield();
  803516:	e8 e2 f0 ff ff       	call   8025fd <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80351b:	e8 5e f0 ff ff       	call   80257e <sys_cgetc>
  803520:	85 c0                	test   %eax,%eax
  803522:	74 f2                	je     803516 <devcons_read+0x13>
	if (c < 0)
  803524:	85 c0                	test   %eax,%eax
  803526:	78 ec                	js     803514 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  803528:	83 f8 04             	cmp    $0x4,%eax
  80352b:	74 0c                	je     803539 <devcons_read+0x36>
	*(char*)vbuf = c;
  80352d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803530:	88 02                	mov    %al,(%edx)
	return 1;
  803532:	b8 01 00 00 00       	mov    $0x1,%eax
  803537:	eb db                	jmp    803514 <devcons_read+0x11>
		return 0;
  803539:	b8 00 00 00 00       	mov    $0x0,%eax
  80353e:	eb d4                	jmp    803514 <devcons_read+0x11>

00803540 <cputchar>:
{
  803540:	55                   	push   %ebp
  803541:	89 e5                	mov    %esp,%ebp
  803543:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80354c:	6a 01                	push   $0x1
  80354e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803551:	50                   	push   %eax
  803552:	e8 09 f0 ff ff       	call   802560 <sys_cputs>
}
  803557:	83 c4 10             	add    $0x10,%esp
  80355a:	c9                   	leave  
  80355b:	c3                   	ret    

0080355c <getchar>:
{
  80355c:	55                   	push   %ebp
  80355d:	89 e5                	mov    %esp,%ebp
  80355f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  803562:	6a 01                	push   $0x1
  803564:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803567:	50                   	push   %eax
  803568:	6a 00                	push   $0x0
  80356a:	e8 87 f6 ff ff       	call   802bf6 <read>
	if (r < 0)
  80356f:	83 c4 10             	add    $0x10,%esp
  803572:	85 c0                	test   %eax,%eax
  803574:	78 08                	js     80357e <getchar+0x22>
	if (r < 1)
  803576:	85 c0                	test   %eax,%eax
  803578:	7e 06                	jle    803580 <getchar+0x24>
	return c;
  80357a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80357e:	c9                   	leave  
  80357f:	c3                   	ret    
		return -E_EOF;
  803580:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803585:	eb f7                	jmp    80357e <getchar+0x22>

00803587 <iscons>:
{
  803587:	55                   	push   %ebp
  803588:	89 e5                	mov    %esp,%ebp
  80358a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80358d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803590:	50                   	push   %eax
  803591:	ff 75 08             	pushl  0x8(%ebp)
  803594:	e8 ec f3 ff ff       	call   802985 <fd_lookup>
  803599:	83 c4 10             	add    $0x10,%esp
  80359c:	85 c0                	test   %eax,%eax
  80359e:	78 11                	js     8035b1 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8035a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a3:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  8035a9:	39 10                	cmp    %edx,(%eax)
  8035ab:	0f 94 c0             	sete   %al
  8035ae:	0f b6 c0             	movzbl %al,%eax
}
  8035b1:	c9                   	leave  
  8035b2:	c3                   	ret    

008035b3 <opencons>:
{
  8035b3:	55                   	push   %ebp
  8035b4:	89 e5                	mov    %esp,%ebp
  8035b6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8035b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8035bc:	50                   	push   %eax
  8035bd:	e8 74 f3 ff ff       	call   802936 <fd_alloc>
  8035c2:	83 c4 10             	add    $0x10,%esp
  8035c5:	85 c0                	test   %eax,%eax
  8035c7:	78 3a                	js     803603 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8035c9:	83 ec 04             	sub    $0x4,%esp
  8035cc:	68 07 04 00 00       	push   $0x407
  8035d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8035d4:	6a 00                	push   $0x0
  8035d6:	e8 41 f0 ff ff       	call   80261c <sys_page_alloc>
  8035db:	83 c4 10             	add    $0x10,%esp
  8035de:	85 c0                	test   %eax,%eax
  8035e0:	78 21                	js     803603 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8035e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e5:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  8035eb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8035ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8035f7:	83 ec 0c             	sub    $0xc,%esp
  8035fa:	50                   	push   %eax
  8035fb:	e8 0f f3 ff ff       	call   80290f <fd2num>
  803600:	83 c4 10             	add    $0x10,%esp
}
  803603:	c9                   	leave  
  803604:	c3                   	ret    
  803605:	66 90                	xchg   %ax,%ax
  803607:	66 90                	xchg   %ax,%ax
  803609:	66 90                	xchg   %ax,%ax
  80360b:	66 90                	xchg   %ax,%ax
  80360d:	66 90                	xchg   %ax,%ax
  80360f:	90                   	nop

00803610 <__udivdi3>:
  803610:	55                   	push   %ebp
  803611:	57                   	push   %edi
  803612:	56                   	push   %esi
  803613:	53                   	push   %ebx
  803614:	83 ec 1c             	sub    $0x1c,%esp
  803617:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80361b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80361f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803623:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803627:	85 d2                	test   %edx,%edx
  803629:	75 35                	jne    803660 <__udivdi3+0x50>
  80362b:	39 f3                	cmp    %esi,%ebx
  80362d:	0f 87 bd 00 00 00    	ja     8036f0 <__udivdi3+0xe0>
  803633:	85 db                	test   %ebx,%ebx
  803635:	89 d9                	mov    %ebx,%ecx
  803637:	75 0b                	jne    803644 <__udivdi3+0x34>
  803639:	b8 01 00 00 00       	mov    $0x1,%eax
  80363e:	31 d2                	xor    %edx,%edx
  803640:	f7 f3                	div    %ebx
  803642:	89 c1                	mov    %eax,%ecx
  803644:	31 d2                	xor    %edx,%edx
  803646:	89 f0                	mov    %esi,%eax
  803648:	f7 f1                	div    %ecx
  80364a:	89 c6                	mov    %eax,%esi
  80364c:	89 e8                	mov    %ebp,%eax
  80364e:	89 f7                	mov    %esi,%edi
  803650:	f7 f1                	div    %ecx
  803652:	89 fa                	mov    %edi,%edx
  803654:	83 c4 1c             	add    $0x1c,%esp
  803657:	5b                   	pop    %ebx
  803658:	5e                   	pop    %esi
  803659:	5f                   	pop    %edi
  80365a:	5d                   	pop    %ebp
  80365b:	c3                   	ret    
  80365c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803660:	39 f2                	cmp    %esi,%edx
  803662:	77 7c                	ja     8036e0 <__udivdi3+0xd0>
  803664:	0f bd fa             	bsr    %edx,%edi
  803667:	83 f7 1f             	xor    $0x1f,%edi
  80366a:	0f 84 98 00 00 00    	je     803708 <__udivdi3+0xf8>
  803670:	89 f9                	mov    %edi,%ecx
  803672:	b8 20 00 00 00       	mov    $0x20,%eax
  803677:	29 f8                	sub    %edi,%eax
  803679:	d3 e2                	shl    %cl,%edx
  80367b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80367f:	89 c1                	mov    %eax,%ecx
  803681:	89 da                	mov    %ebx,%edx
  803683:	d3 ea                	shr    %cl,%edx
  803685:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803689:	09 d1                	or     %edx,%ecx
  80368b:	89 f2                	mov    %esi,%edx
  80368d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803691:	89 f9                	mov    %edi,%ecx
  803693:	d3 e3                	shl    %cl,%ebx
  803695:	89 c1                	mov    %eax,%ecx
  803697:	d3 ea                	shr    %cl,%edx
  803699:	89 f9                	mov    %edi,%ecx
  80369b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80369f:	d3 e6                	shl    %cl,%esi
  8036a1:	89 eb                	mov    %ebp,%ebx
  8036a3:	89 c1                	mov    %eax,%ecx
  8036a5:	d3 eb                	shr    %cl,%ebx
  8036a7:	09 de                	or     %ebx,%esi
  8036a9:	89 f0                	mov    %esi,%eax
  8036ab:	f7 74 24 08          	divl   0x8(%esp)
  8036af:	89 d6                	mov    %edx,%esi
  8036b1:	89 c3                	mov    %eax,%ebx
  8036b3:	f7 64 24 0c          	mull   0xc(%esp)
  8036b7:	39 d6                	cmp    %edx,%esi
  8036b9:	72 0c                	jb     8036c7 <__udivdi3+0xb7>
  8036bb:	89 f9                	mov    %edi,%ecx
  8036bd:	d3 e5                	shl    %cl,%ebp
  8036bf:	39 c5                	cmp    %eax,%ebp
  8036c1:	73 5d                	jae    803720 <__udivdi3+0x110>
  8036c3:	39 d6                	cmp    %edx,%esi
  8036c5:	75 59                	jne    803720 <__udivdi3+0x110>
  8036c7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036ca:	31 ff                	xor    %edi,%edi
  8036cc:	89 fa                	mov    %edi,%edx
  8036ce:	83 c4 1c             	add    $0x1c,%esp
  8036d1:	5b                   	pop    %ebx
  8036d2:	5e                   	pop    %esi
  8036d3:	5f                   	pop    %edi
  8036d4:	5d                   	pop    %ebp
  8036d5:	c3                   	ret    
  8036d6:	8d 76 00             	lea    0x0(%esi),%esi
  8036d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8036e0:	31 ff                	xor    %edi,%edi
  8036e2:	31 c0                	xor    %eax,%eax
  8036e4:	89 fa                	mov    %edi,%edx
  8036e6:	83 c4 1c             	add    $0x1c,%esp
  8036e9:	5b                   	pop    %ebx
  8036ea:	5e                   	pop    %esi
  8036eb:	5f                   	pop    %edi
  8036ec:	5d                   	pop    %ebp
  8036ed:	c3                   	ret    
  8036ee:	66 90                	xchg   %ax,%ax
  8036f0:	31 ff                	xor    %edi,%edi
  8036f2:	89 e8                	mov    %ebp,%eax
  8036f4:	89 f2                	mov    %esi,%edx
  8036f6:	f7 f3                	div    %ebx
  8036f8:	89 fa                	mov    %edi,%edx
  8036fa:	83 c4 1c             	add    $0x1c,%esp
  8036fd:	5b                   	pop    %ebx
  8036fe:	5e                   	pop    %esi
  8036ff:	5f                   	pop    %edi
  803700:	5d                   	pop    %ebp
  803701:	c3                   	ret    
  803702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803708:	39 f2                	cmp    %esi,%edx
  80370a:	72 06                	jb     803712 <__udivdi3+0x102>
  80370c:	31 c0                	xor    %eax,%eax
  80370e:	39 eb                	cmp    %ebp,%ebx
  803710:	77 d2                	ja     8036e4 <__udivdi3+0xd4>
  803712:	b8 01 00 00 00       	mov    $0x1,%eax
  803717:	eb cb                	jmp    8036e4 <__udivdi3+0xd4>
  803719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803720:	89 d8                	mov    %ebx,%eax
  803722:	31 ff                	xor    %edi,%edi
  803724:	eb be                	jmp    8036e4 <__udivdi3+0xd4>
  803726:	66 90                	xchg   %ax,%ax
  803728:	66 90                	xchg   %ax,%ax
  80372a:	66 90                	xchg   %ax,%ax
  80372c:	66 90                	xchg   %ax,%ax
  80372e:	66 90                	xchg   %ax,%ax

00803730 <__umoddi3>:
  803730:	55                   	push   %ebp
  803731:	57                   	push   %edi
  803732:	56                   	push   %esi
  803733:	53                   	push   %ebx
  803734:	83 ec 1c             	sub    $0x1c,%esp
  803737:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80373b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80373f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803743:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803747:	85 ed                	test   %ebp,%ebp
  803749:	89 f0                	mov    %esi,%eax
  80374b:	89 da                	mov    %ebx,%edx
  80374d:	75 19                	jne    803768 <__umoddi3+0x38>
  80374f:	39 df                	cmp    %ebx,%edi
  803751:	0f 86 b1 00 00 00    	jbe    803808 <__umoddi3+0xd8>
  803757:	f7 f7                	div    %edi
  803759:	89 d0                	mov    %edx,%eax
  80375b:	31 d2                	xor    %edx,%edx
  80375d:	83 c4 1c             	add    $0x1c,%esp
  803760:	5b                   	pop    %ebx
  803761:	5e                   	pop    %esi
  803762:	5f                   	pop    %edi
  803763:	5d                   	pop    %ebp
  803764:	c3                   	ret    
  803765:	8d 76 00             	lea    0x0(%esi),%esi
  803768:	39 dd                	cmp    %ebx,%ebp
  80376a:	77 f1                	ja     80375d <__umoddi3+0x2d>
  80376c:	0f bd cd             	bsr    %ebp,%ecx
  80376f:	83 f1 1f             	xor    $0x1f,%ecx
  803772:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803776:	0f 84 b4 00 00 00    	je     803830 <__umoddi3+0x100>
  80377c:	b8 20 00 00 00       	mov    $0x20,%eax
  803781:	89 c2                	mov    %eax,%edx
  803783:	8b 44 24 04          	mov    0x4(%esp),%eax
  803787:	29 c2                	sub    %eax,%edx
  803789:	89 c1                	mov    %eax,%ecx
  80378b:	89 f8                	mov    %edi,%eax
  80378d:	d3 e5                	shl    %cl,%ebp
  80378f:	89 d1                	mov    %edx,%ecx
  803791:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803795:	d3 e8                	shr    %cl,%eax
  803797:	09 c5                	or     %eax,%ebp
  803799:	8b 44 24 04          	mov    0x4(%esp),%eax
  80379d:	89 c1                	mov    %eax,%ecx
  80379f:	d3 e7                	shl    %cl,%edi
  8037a1:	89 d1                	mov    %edx,%ecx
  8037a3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8037a7:	89 df                	mov    %ebx,%edi
  8037a9:	d3 ef                	shr    %cl,%edi
  8037ab:	89 c1                	mov    %eax,%ecx
  8037ad:	89 f0                	mov    %esi,%eax
  8037af:	d3 e3                	shl    %cl,%ebx
  8037b1:	89 d1                	mov    %edx,%ecx
  8037b3:	89 fa                	mov    %edi,%edx
  8037b5:	d3 e8                	shr    %cl,%eax
  8037b7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8037bc:	09 d8                	or     %ebx,%eax
  8037be:	f7 f5                	div    %ebp
  8037c0:	d3 e6                	shl    %cl,%esi
  8037c2:	89 d1                	mov    %edx,%ecx
  8037c4:	f7 64 24 08          	mull   0x8(%esp)
  8037c8:	39 d1                	cmp    %edx,%ecx
  8037ca:	89 c3                	mov    %eax,%ebx
  8037cc:	89 d7                	mov    %edx,%edi
  8037ce:	72 06                	jb     8037d6 <__umoddi3+0xa6>
  8037d0:	75 0e                	jne    8037e0 <__umoddi3+0xb0>
  8037d2:	39 c6                	cmp    %eax,%esi
  8037d4:	73 0a                	jae    8037e0 <__umoddi3+0xb0>
  8037d6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8037da:	19 ea                	sbb    %ebp,%edx
  8037dc:	89 d7                	mov    %edx,%edi
  8037de:	89 c3                	mov    %eax,%ebx
  8037e0:	89 ca                	mov    %ecx,%edx
  8037e2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8037e7:	29 de                	sub    %ebx,%esi
  8037e9:	19 fa                	sbb    %edi,%edx
  8037eb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8037ef:	89 d0                	mov    %edx,%eax
  8037f1:	d3 e0                	shl    %cl,%eax
  8037f3:	89 d9                	mov    %ebx,%ecx
  8037f5:	d3 ee                	shr    %cl,%esi
  8037f7:	d3 ea                	shr    %cl,%edx
  8037f9:	09 f0                	or     %esi,%eax
  8037fb:	83 c4 1c             	add    $0x1c,%esp
  8037fe:	5b                   	pop    %ebx
  8037ff:	5e                   	pop    %esi
  803800:	5f                   	pop    %edi
  803801:	5d                   	pop    %ebp
  803802:	c3                   	ret    
  803803:	90                   	nop
  803804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803808:	85 ff                	test   %edi,%edi
  80380a:	89 f9                	mov    %edi,%ecx
  80380c:	75 0b                	jne    803819 <__umoddi3+0xe9>
  80380e:	b8 01 00 00 00       	mov    $0x1,%eax
  803813:	31 d2                	xor    %edx,%edx
  803815:	f7 f7                	div    %edi
  803817:	89 c1                	mov    %eax,%ecx
  803819:	89 d8                	mov    %ebx,%eax
  80381b:	31 d2                	xor    %edx,%edx
  80381d:	f7 f1                	div    %ecx
  80381f:	89 f0                	mov    %esi,%eax
  803821:	f7 f1                	div    %ecx
  803823:	e9 31 ff ff ff       	jmp    803759 <__umoddi3+0x29>
  803828:	90                   	nop
  803829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803830:	39 dd                	cmp    %ebx,%ebp
  803832:	72 08                	jb     80383c <__umoddi3+0x10c>
  803834:	39 f7                	cmp    %esi,%edi
  803836:	0f 87 21 ff ff ff    	ja     80375d <__umoddi3+0x2d>
  80383c:	89 da                	mov    %ebx,%edx
  80383e:	89 f0                	mov    %esi,%eax
  803840:	29 f8                	sub    %edi,%eax
  803842:	19 ea                	sbb    %ebp,%edx
  803844:	e9 14 ff ff ff       	jmp    80375d <__umoddi3+0x2d>
