
obj/kern/kernel：     文件格式 elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 f0 11 00       	mov    $0x11f000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 f0 11 f0       	mov    $0xf011f000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 5e 00 00 00       	call   f010009c <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100048:	83 3d 80 3e 21 f0 00 	cmpl   $0x0,0xf0213e80
f010004f:	74 0f                	je     f0100060 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100051:	83 ec 0c             	sub    $0xc,%esp
f0100054:	6a 00                	push   $0x0
f0100056:	e8 67 08 00 00       	call   f01008c2 <monitor>
f010005b:	83 c4 10             	add    $0x10,%esp
f010005e:	eb f1                	jmp    f0100051 <_panic+0x11>
	panicstr = fmt;
f0100060:	89 35 80 3e 21 f0    	mov    %esi,0xf0213e80
	asm volatile("cli; cld");
f0100066:	fa                   	cli    
f0100067:	fc                   	cld    
	va_start(ap, fmt);
f0100068:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006b:	e8 67 5b 00 00       	call   f0105bd7 <cpunum>
f0100070:	ff 75 0c             	pushl  0xc(%ebp)
f0100073:	ff 75 08             	pushl  0x8(%ebp)
f0100076:	50                   	push   %eax
f0100077:	68 20 62 10 f0       	push   $0xf0106220
f010007c:	e8 92 38 00 00       	call   f0103913 <cprintf>
	vcprintf(fmt, ap);
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	53                   	push   %ebx
f0100085:	56                   	push   %esi
f0100086:	e8 62 38 00 00       	call   f01038ed <vcprintf>
	cprintf("\n");
f010008b:	c7 04 24 05 6a 10 f0 	movl   $0xf0106a05,(%esp)
f0100092:	e8 7c 38 00 00       	call   f0103913 <cprintf>
f0100097:	83 c4 10             	add    $0x10,%esp
f010009a:	eb b5                	jmp    f0100051 <_panic+0x11>

f010009c <i386_init>:
{
f010009c:	55                   	push   %ebp
f010009d:	89 e5                	mov    %esp,%ebp
f010009f:	53                   	push   %ebx
f01000a0:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000a3:	e8 c1 05 00 00       	call   f0100669 <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000a8:	83 ec 08             	sub    $0x8,%esp
f01000ab:	68 ac 1a 00 00       	push   $0x1aac
f01000b0:	68 8c 62 10 f0       	push   $0xf010628c
f01000b5:	e8 59 38 00 00       	call   f0103913 <cprintf>
	mem_init();
f01000ba:	e8 37 12 00 00       	call   f01012f6 <mem_init>
	env_init();
f01000bf:	e8 5b 30 00 00       	call   f010311f <env_init>
	cprintf("\n\nenv_init finished\n");
f01000c4:	c7 04 24 a7 62 10 f0 	movl   $0xf01062a7,(%esp)
f01000cb:	e8 43 38 00 00       	call   f0103913 <cprintf>
	trap_init();
f01000d0:	e8 fb 38 00 00       	call   f01039d0 <trap_init>
	cprintf("\n\ntrap_init finished\n");
f01000d5:	c7 04 24 bc 62 10 f0 	movl   $0xf01062bc,(%esp)
f01000dc:	e8 32 38 00 00       	call   f0103913 <cprintf>
	mp_init();
f01000e1:	e8 df 57 00 00       	call   f01058c5 <mp_init>
	lapic_init();
f01000e6:	e8 06 5b 00 00       	call   f0105bf1 <lapic_init>
	pic_init();
f01000eb:	e8 46 37 00 00       	call   f0103836 <pic_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000f0:	c7 04 24 80 14 12 f0 	movl   $0xf0121480,(%esp)
f01000f7:	e8 4b 5d 00 00       	call   f0105e47 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000fc:	83 c4 10             	add    $0x10,%esp
f01000ff:	83 3d 88 3e 21 f0 07 	cmpl   $0x7,0xf0213e88
f0100106:	76 27                	jbe    f010012f <i386_init+0x93>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f0100108:	83 ec 04             	sub    $0x4,%esp
f010010b:	b8 2a 58 10 f0       	mov    $0xf010582a,%eax
f0100110:	2d b0 57 10 f0       	sub    $0xf01057b0,%eax
f0100115:	50                   	push   %eax
f0100116:	68 b0 57 10 f0       	push   $0xf01057b0
f010011b:	68 00 70 00 f0       	push   $0xf0007000
f0100120:	e8 da 54 00 00       	call   f01055ff <memmove>
f0100125:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++)
f0100128:	bb 20 40 21 f0       	mov    $0xf0214020,%ebx
f010012d:	eb 19                	jmp    f0100148 <i386_init+0xac>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010012f:	68 00 70 00 00       	push   $0x7000
f0100134:	68 44 62 10 f0       	push   $0xf0106244
f0100139:	6a 50                	push   $0x50
f010013b:	68 d2 62 10 f0       	push   $0xf01062d2
f0100140:	e8 fb fe ff ff       	call   f0100040 <_panic>
f0100145:	83 c3 74             	add    $0x74,%ebx
f0100148:	6b 05 c4 43 21 f0 74 	imul   $0x74,0xf02143c4,%eax
f010014f:	05 20 40 21 f0       	add    $0xf0214020,%eax
f0100154:	39 c3                	cmp    %eax,%ebx
f0100156:	73 4c                	jae    f01001a4 <i386_init+0x108>
		if (c == cpus + cpunum()) // We've started already.
f0100158:	e8 7a 5a 00 00       	call   f0105bd7 <cpunum>
f010015d:	6b c0 74             	imul   $0x74,%eax,%eax
f0100160:	05 20 40 21 f0       	add    $0xf0214020,%eax
f0100165:	39 c3                	cmp    %eax,%ebx
f0100167:	74 dc                	je     f0100145 <i386_init+0xa9>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f0100169:	89 d8                	mov    %ebx,%eax
f010016b:	2d 20 40 21 f0       	sub    $0xf0214020,%eax
f0100170:	c1 f8 02             	sar    $0x2,%eax
f0100173:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100179:	c1 e0 0f             	shl    $0xf,%eax
f010017c:	05 00 d0 21 f0       	add    $0xf021d000,%eax
f0100181:	a3 84 3e 21 f0       	mov    %eax,0xf0213e84
		lapic_startap(c->cpu_id, PADDR(code));
f0100186:	83 ec 08             	sub    $0x8,%esp
f0100189:	68 00 70 00 00       	push   $0x7000
f010018e:	0f b6 03             	movzbl (%ebx),%eax
f0100191:	50                   	push   %eax
f0100192:	e8 ab 5b 00 00       	call   f0105d42 <lapic_startap>
f0100197:	83 c4 10             	add    $0x10,%esp
		while (c->cpu_status != CPU_STARTED)
f010019a:	8b 43 04             	mov    0x4(%ebx),%eax
f010019d:	83 f8 01             	cmp    $0x1,%eax
f01001a0:	75 f8                	jne    f010019a <i386_init+0xfe>
f01001a2:	eb a1                	jmp    f0100145 <i386_init+0xa9>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f01001a4:	83 ec 08             	sub    $0x8,%esp
f01001a7:	6a 01                	push   $0x1
f01001a9:	68 68 19 1d f0       	push   $0xf01d1968
f01001ae:	e8 43 31 00 00       	call   f01032f6 <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001b3:	83 c4 08             	add    $0x8,%esp
f01001b6:	6a 00                	push   $0x0
f01001b8:	68 10 29 20 f0       	push   $0xf0202910
f01001bd:	e8 34 31 00 00       	call   f01032f6 <env_create>
	sched_yield();
f01001c2:	e8 0a 42 00 00       	call   f01043d1 <sched_yield>

f01001c7 <mp_main>:
{
f01001c7:	55                   	push   %ebp
f01001c8:	89 e5                	mov    %esp,%ebp
f01001ca:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001cd:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f01001d2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001d7:	77 12                	ja     f01001eb <mp_main+0x24>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01001d9:	50                   	push   %eax
f01001da:	68 68 62 10 f0       	push   $0xf0106268
f01001df:	6a 68                	push   $0x68
f01001e1:	68 d2 62 10 f0       	push   $0xf01062d2
f01001e6:	e8 55 fe ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01001eb:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001f0:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001f3:	e8 df 59 00 00       	call   f0105bd7 <cpunum>
f01001f8:	83 ec 08             	sub    $0x8,%esp
f01001fb:	50                   	push   %eax
f01001fc:	68 de 62 10 f0       	push   $0xf01062de
f0100201:	e8 0d 37 00 00       	call   f0103913 <cprintf>
	lapic_init();
f0100206:	e8 e6 59 00 00       	call   f0105bf1 <lapic_init>
	env_init_percpu();
f010020b:	e8 df 2e 00 00       	call   f01030ef <env_init_percpu>
	trap_init_percpu();
f0100210:	e8 12 37 00 00       	call   f0103927 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100215:	e8 bd 59 00 00       	call   f0105bd7 <cpunum>
f010021a:	6b d0 74             	imul   $0x74,%eax,%edx
f010021d:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100220:	b8 01 00 00 00       	mov    $0x1,%eax
f0100225:	f0 87 82 20 40 21 f0 	lock xchg %eax,-0xfdebfe0(%edx)
f010022c:	c7 04 24 80 14 12 f0 	movl   $0xf0121480,(%esp)
f0100233:	e8 0f 5c 00 00       	call   f0105e47 <spin_lock>
	sched_yield();
f0100238:	e8 94 41 00 00       	call   f01043d1 <sched_yield>

f010023d <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f010023d:	55                   	push   %ebp
f010023e:	89 e5                	mov    %esp,%ebp
f0100240:	53                   	push   %ebx
f0100241:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100244:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100247:	ff 75 0c             	pushl  0xc(%ebp)
f010024a:	ff 75 08             	pushl  0x8(%ebp)
f010024d:	68 f4 62 10 f0       	push   $0xf01062f4
f0100252:	e8 bc 36 00 00       	call   f0103913 <cprintf>
	vcprintf(fmt, ap);
f0100257:	83 c4 08             	add    $0x8,%esp
f010025a:	53                   	push   %ebx
f010025b:	ff 75 10             	pushl  0x10(%ebp)
f010025e:	e8 8a 36 00 00       	call   f01038ed <vcprintf>
	cprintf("\n");
f0100263:	c7 04 24 05 6a 10 f0 	movl   $0xf0106a05,(%esp)
f010026a:	e8 a4 36 00 00       	call   f0103913 <cprintf>
	va_end(ap);
}
f010026f:	83 c4 10             	add    $0x10,%esp
f0100272:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100275:	c9                   	leave  
f0100276:	c3                   	ret    

f0100277 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100277:	55                   	push   %ebp
f0100278:	89 e5                	mov    %esp,%ebp
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010027a:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010027f:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100280:	a8 01                	test   $0x1,%al
f0100282:	74 0b                	je     f010028f <serial_proc_data+0x18>
f0100284:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100289:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f010028a:	0f b6 c0             	movzbl %al,%eax
}
f010028d:	5d                   	pop    %ebp
f010028e:	c3                   	ret    
		return -1;
f010028f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100294:	eb f7                	jmp    f010028d <serial_proc_data+0x16>

f0100296 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100296:	55                   	push   %ebp
f0100297:	89 e5                	mov    %esp,%ebp
f0100299:	53                   	push   %ebx
f010029a:	83 ec 04             	sub    $0x4,%esp
f010029d:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f010029f:	ff d3                	call   *%ebx
f01002a1:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002a4:	74 2d                	je     f01002d3 <cons_intr+0x3d>
		if (c == 0)
f01002a6:	85 c0                	test   %eax,%eax
f01002a8:	74 f5                	je     f010029f <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01002aa:	8b 0d 24 32 21 f0    	mov    0xf0213224,%ecx
f01002b0:	8d 51 01             	lea    0x1(%ecx),%edx
f01002b3:	89 15 24 32 21 f0    	mov    %edx,0xf0213224
f01002b9:	88 81 20 30 21 f0    	mov    %al,-0xfdecfe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002bf:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01002c5:	75 d8                	jne    f010029f <cons_intr+0x9>
			cons.wpos = 0;
f01002c7:	c7 05 24 32 21 f0 00 	movl   $0x0,0xf0213224
f01002ce:	00 00 00 
f01002d1:	eb cc                	jmp    f010029f <cons_intr+0x9>
	}
}
f01002d3:	83 c4 04             	add    $0x4,%esp
f01002d6:	5b                   	pop    %ebx
f01002d7:	5d                   	pop    %ebp
f01002d8:	c3                   	ret    

f01002d9 <kbd_proc_data>:
{
f01002d9:	55                   	push   %ebp
f01002da:	89 e5                	mov    %esp,%ebp
f01002dc:	53                   	push   %ebx
f01002dd:	83 ec 04             	sub    $0x4,%esp
f01002e0:	ba 64 00 00 00       	mov    $0x64,%edx
f01002e5:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002e6:	a8 01                	test   $0x1,%al
f01002e8:	0f 84 fa 00 00 00    	je     f01003e8 <kbd_proc_data+0x10f>
	if (stat & KBS_TERR)
f01002ee:	a8 20                	test   $0x20,%al
f01002f0:	0f 85 f9 00 00 00    	jne    f01003ef <kbd_proc_data+0x116>
f01002f6:	ba 60 00 00 00       	mov    $0x60,%edx
f01002fb:	ec                   	in     (%dx),%al
f01002fc:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f01002fe:	3c e0                	cmp    $0xe0,%al
f0100300:	0f 84 8e 00 00 00    	je     f0100394 <kbd_proc_data+0xbb>
	} else if (data & 0x80) {
f0100306:	84 c0                	test   %al,%al
f0100308:	0f 88 99 00 00 00    	js     f01003a7 <kbd_proc_data+0xce>
	} else if (shift & E0ESC) {
f010030e:	8b 0d 00 30 21 f0    	mov    0xf0213000,%ecx
f0100314:	f6 c1 40             	test   $0x40,%cl
f0100317:	74 0e                	je     f0100327 <kbd_proc_data+0x4e>
		data |= 0x80;
f0100319:	83 c8 80             	or     $0xffffff80,%eax
f010031c:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f010031e:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100321:	89 0d 00 30 21 f0    	mov    %ecx,0xf0213000
	shift |= shiftcode[data];
f0100327:	0f b6 d2             	movzbl %dl,%edx
f010032a:	0f b6 82 60 64 10 f0 	movzbl -0xfef9ba0(%edx),%eax
f0100331:	0b 05 00 30 21 f0    	or     0xf0213000,%eax
	shift ^= togglecode[data];
f0100337:	0f b6 8a 60 63 10 f0 	movzbl -0xfef9ca0(%edx),%ecx
f010033e:	31 c8                	xor    %ecx,%eax
f0100340:	a3 00 30 21 f0       	mov    %eax,0xf0213000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100345:	89 c1                	mov    %eax,%ecx
f0100347:	83 e1 03             	and    $0x3,%ecx
f010034a:	8b 0c 8d 40 63 10 f0 	mov    -0xfef9cc0(,%ecx,4),%ecx
f0100351:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100355:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100358:	a8 08                	test   $0x8,%al
f010035a:	74 0d                	je     f0100369 <kbd_proc_data+0x90>
		if ('a' <= c && c <= 'z')
f010035c:	89 da                	mov    %ebx,%edx
f010035e:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100361:	83 f9 19             	cmp    $0x19,%ecx
f0100364:	77 74                	ja     f01003da <kbd_proc_data+0x101>
			c += 'A' - 'a';
f0100366:	83 eb 20             	sub    $0x20,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100369:	f7 d0                	not    %eax
f010036b:	a8 06                	test   $0x6,%al
f010036d:	75 31                	jne    f01003a0 <kbd_proc_data+0xc7>
f010036f:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100375:	75 29                	jne    f01003a0 <kbd_proc_data+0xc7>
		cprintf("Rebooting!\n");
f0100377:	83 ec 0c             	sub    $0xc,%esp
f010037a:	68 0e 63 10 f0       	push   $0xf010630e
f010037f:	e8 8f 35 00 00       	call   f0103913 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100384:	b8 03 00 00 00       	mov    $0x3,%eax
f0100389:	ba 92 00 00 00       	mov    $0x92,%edx
f010038e:	ee                   	out    %al,(%dx)
f010038f:	83 c4 10             	add    $0x10,%esp
f0100392:	eb 0c                	jmp    f01003a0 <kbd_proc_data+0xc7>
		shift |= E0ESC;
f0100394:	83 0d 00 30 21 f0 40 	orl    $0x40,0xf0213000
		return 0;
f010039b:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01003a0:	89 d8                	mov    %ebx,%eax
f01003a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01003a5:	c9                   	leave  
f01003a6:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f01003a7:	8b 0d 00 30 21 f0    	mov    0xf0213000,%ecx
f01003ad:	89 cb                	mov    %ecx,%ebx
f01003af:	83 e3 40             	and    $0x40,%ebx
f01003b2:	83 e0 7f             	and    $0x7f,%eax
f01003b5:	85 db                	test   %ebx,%ebx
f01003b7:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01003ba:	0f b6 d2             	movzbl %dl,%edx
f01003bd:	0f b6 82 60 64 10 f0 	movzbl -0xfef9ba0(%edx),%eax
f01003c4:	83 c8 40             	or     $0x40,%eax
f01003c7:	0f b6 c0             	movzbl %al,%eax
f01003ca:	f7 d0                	not    %eax
f01003cc:	21 c8                	and    %ecx,%eax
f01003ce:	a3 00 30 21 f0       	mov    %eax,0xf0213000
		return 0;
f01003d3:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003d8:	eb c6                	jmp    f01003a0 <kbd_proc_data+0xc7>
		else if ('A' <= c && c <= 'Z')
f01003da:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003dd:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003e0:	83 fa 1a             	cmp    $0x1a,%edx
f01003e3:	0f 42 d9             	cmovb  %ecx,%ebx
f01003e6:	eb 81                	jmp    f0100369 <kbd_proc_data+0x90>
		return -1;
f01003e8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003ed:	eb b1                	jmp    f01003a0 <kbd_proc_data+0xc7>
		return -1;
f01003ef:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003f4:	eb aa                	jmp    f01003a0 <kbd_proc_data+0xc7>

f01003f6 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003f6:	55                   	push   %ebp
f01003f7:	89 e5                	mov    %esp,%ebp
f01003f9:	57                   	push   %edi
f01003fa:	56                   	push   %esi
f01003fb:	53                   	push   %ebx
f01003fc:	83 ec 1c             	sub    $0x1c,%esp
f01003ff:	89 c7                	mov    %eax,%edi
	for (i = 0;
f0100401:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100406:	be fd 03 00 00       	mov    $0x3fd,%esi
f010040b:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100410:	eb 09                	jmp    f010041b <cons_putc+0x25>
f0100412:	89 ca                	mov    %ecx,%edx
f0100414:	ec                   	in     (%dx),%al
f0100415:	ec                   	in     (%dx),%al
f0100416:	ec                   	in     (%dx),%al
f0100417:	ec                   	in     (%dx),%al
	     i++)
f0100418:	83 c3 01             	add    $0x1,%ebx
f010041b:	89 f2                	mov    %esi,%edx
f010041d:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f010041e:	a8 20                	test   $0x20,%al
f0100420:	75 08                	jne    f010042a <cons_putc+0x34>
f0100422:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f0100428:	7e e8                	jle    f0100412 <cons_putc+0x1c>
	outb(COM1 + COM_TX, c);
f010042a:	89 f8                	mov    %edi,%eax
f010042c:	88 45 e7             	mov    %al,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010042f:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100434:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100435:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010043a:	be 79 03 00 00       	mov    $0x379,%esi
f010043f:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100444:	eb 09                	jmp    f010044f <cons_putc+0x59>
f0100446:	89 ca                	mov    %ecx,%edx
f0100448:	ec                   	in     (%dx),%al
f0100449:	ec                   	in     (%dx),%al
f010044a:	ec                   	in     (%dx),%al
f010044b:	ec                   	in     (%dx),%al
f010044c:	83 c3 01             	add    $0x1,%ebx
f010044f:	89 f2                	mov    %esi,%edx
f0100451:	ec                   	in     (%dx),%al
f0100452:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f0100458:	7f 04                	jg     f010045e <cons_putc+0x68>
f010045a:	84 c0                	test   %al,%al
f010045c:	79 e8                	jns    f0100446 <cons_putc+0x50>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010045e:	ba 78 03 00 00       	mov    $0x378,%edx
f0100463:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100467:	ee                   	out    %al,(%dx)
f0100468:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010046d:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100472:	ee                   	out    %al,(%dx)
f0100473:	b8 08 00 00 00       	mov    $0x8,%eax
f0100478:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f0100479:	89 fa                	mov    %edi,%edx
f010047b:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f0100481:	89 f8                	mov    %edi,%eax
f0100483:	80 cc 07             	or     $0x7,%ah
f0100486:	85 d2                	test   %edx,%edx
f0100488:	0f 44 f8             	cmove  %eax,%edi
	switch (c & 0xff) {
f010048b:	89 f8                	mov    %edi,%eax
f010048d:	0f b6 c0             	movzbl %al,%eax
f0100490:	83 f8 09             	cmp    $0x9,%eax
f0100493:	0f 84 b6 00 00 00    	je     f010054f <cons_putc+0x159>
f0100499:	83 f8 09             	cmp    $0x9,%eax
f010049c:	7e 73                	jle    f0100511 <cons_putc+0x11b>
f010049e:	83 f8 0a             	cmp    $0xa,%eax
f01004a1:	0f 84 9b 00 00 00    	je     f0100542 <cons_putc+0x14c>
f01004a7:	83 f8 0d             	cmp    $0xd,%eax
f01004aa:	0f 85 d6 00 00 00    	jne    f0100586 <cons_putc+0x190>
		crt_pos -= (crt_pos % CRT_COLS);
f01004b0:	0f b7 05 28 32 21 f0 	movzwl 0xf0213228,%eax
f01004b7:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004bd:	c1 e8 16             	shr    $0x16,%eax
f01004c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004c3:	c1 e0 04             	shl    $0x4,%eax
f01004c6:	66 a3 28 32 21 f0    	mov    %ax,0xf0213228
	if (crt_pos >= CRT_SIZE) {
f01004cc:	66 81 3d 28 32 21 f0 	cmpw   $0x7cf,0xf0213228
f01004d3:	cf 07 
f01004d5:	0f 87 ce 00 00 00    	ja     f01005a9 <cons_putc+0x1b3>
	outb(addr_6845, 14);
f01004db:	8b 0d 30 32 21 f0    	mov    0xf0213230,%ecx
f01004e1:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004e6:	89 ca                	mov    %ecx,%edx
f01004e8:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004e9:	0f b7 1d 28 32 21 f0 	movzwl 0xf0213228,%ebx
f01004f0:	8d 71 01             	lea    0x1(%ecx),%esi
f01004f3:	89 d8                	mov    %ebx,%eax
f01004f5:	66 c1 e8 08          	shr    $0x8,%ax
f01004f9:	89 f2                	mov    %esi,%edx
f01004fb:	ee                   	out    %al,(%dx)
f01004fc:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100501:	89 ca                	mov    %ecx,%edx
f0100503:	ee                   	out    %al,(%dx)
f0100504:	89 d8                	mov    %ebx,%eax
f0100506:	89 f2                	mov    %esi,%edx
f0100508:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100509:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010050c:	5b                   	pop    %ebx
f010050d:	5e                   	pop    %esi
f010050e:	5f                   	pop    %edi
f010050f:	5d                   	pop    %ebp
f0100510:	c3                   	ret    
	switch (c & 0xff) {
f0100511:	83 f8 08             	cmp    $0x8,%eax
f0100514:	75 70                	jne    f0100586 <cons_putc+0x190>
		if (crt_pos > 0) {
f0100516:	0f b7 05 28 32 21 f0 	movzwl 0xf0213228,%eax
f010051d:	66 85 c0             	test   %ax,%ax
f0100520:	74 b9                	je     f01004db <cons_putc+0xe5>
			crt_pos--;
f0100522:	83 e8 01             	sub    $0x1,%eax
f0100525:	66 a3 28 32 21 f0    	mov    %ax,0xf0213228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f010052b:	0f b7 c0             	movzwl %ax,%eax
f010052e:	66 81 e7 00 ff       	and    $0xff00,%di
f0100533:	83 cf 20             	or     $0x20,%edi
f0100536:	8b 15 2c 32 21 f0    	mov    0xf021322c,%edx
f010053c:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100540:	eb 8a                	jmp    f01004cc <cons_putc+0xd6>
		crt_pos += CRT_COLS;
f0100542:	66 83 05 28 32 21 f0 	addw   $0x50,0xf0213228
f0100549:	50 
f010054a:	e9 61 ff ff ff       	jmp    f01004b0 <cons_putc+0xba>
		cons_putc(' ');
f010054f:	b8 20 00 00 00       	mov    $0x20,%eax
f0100554:	e8 9d fe ff ff       	call   f01003f6 <cons_putc>
		cons_putc(' ');
f0100559:	b8 20 00 00 00       	mov    $0x20,%eax
f010055e:	e8 93 fe ff ff       	call   f01003f6 <cons_putc>
		cons_putc(' ');
f0100563:	b8 20 00 00 00       	mov    $0x20,%eax
f0100568:	e8 89 fe ff ff       	call   f01003f6 <cons_putc>
		cons_putc(' ');
f010056d:	b8 20 00 00 00       	mov    $0x20,%eax
f0100572:	e8 7f fe ff ff       	call   f01003f6 <cons_putc>
		cons_putc(' ');
f0100577:	b8 20 00 00 00       	mov    $0x20,%eax
f010057c:	e8 75 fe ff ff       	call   f01003f6 <cons_putc>
f0100581:	e9 46 ff ff ff       	jmp    f01004cc <cons_putc+0xd6>
		crt_buf[crt_pos++] = c;		/* write the character */
f0100586:	0f b7 05 28 32 21 f0 	movzwl 0xf0213228,%eax
f010058d:	8d 50 01             	lea    0x1(%eax),%edx
f0100590:	66 89 15 28 32 21 f0 	mov    %dx,0xf0213228
f0100597:	0f b7 c0             	movzwl %ax,%eax
f010059a:	8b 15 2c 32 21 f0    	mov    0xf021322c,%edx
f01005a0:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f01005a4:	e9 23 ff ff ff       	jmp    f01004cc <cons_putc+0xd6>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005a9:	a1 2c 32 21 f0       	mov    0xf021322c,%eax
f01005ae:	83 ec 04             	sub    $0x4,%esp
f01005b1:	68 00 0f 00 00       	push   $0xf00
f01005b6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005bc:	52                   	push   %edx
f01005bd:	50                   	push   %eax
f01005be:	e8 3c 50 00 00       	call   f01055ff <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005c3:	8b 15 2c 32 21 f0    	mov    0xf021322c,%edx
f01005c9:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005cf:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005d5:	83 c4 10             	add    $0x10,%esp
f01005d8:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005dd:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005e0:	39 d0                	cmp    %edx,%eax
f01005e2:	75 f4                	jne    f01005d8 <cons_putc+0x1e2>
		crt_pos -= CRT_COLS;
f01005e4:	66 83 2d 28 32 21 f0 	subw   $0x50,0xf0213228
f01005eb:	50 
f01005ec:	e9 ea fe ff ff       	jmp    f01004db <cons_putc+0xe5>

f01005f1 <serial_intr>:
	if (serial_exists)
f01005f1:	80 3d 34 32 21 f0 00 	cmpb   $0x0,0xf0213234
f01005f8:	75 02                	jne    f01005fc <serial_intr+0xb>
f01005fa:	f3 c3                	repz ret 
{
f01005fc:	55                   	push   %ebp
f01005fd:	89 e5                	mov    %esp,%ebp
f01005ff:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100602:	b8 77 02 10 f0       	mov    $0xf0100277,%eax
f0100607:	e8 8a fc ff ff       	call   f0100296 <cons_intr>
}
f010060c:	c9                   	leave  
f010060d:	c3                   	ret    

f010060e <kbd_intr>:
{
f010060e:	55                   	push   %ebp
f010060f:	89 e5                	mov    %esp,%ebp
f0100611:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100614:	b8 d9 02 10 f0       	mov    $0xf01002d9,%eax
f0100619:	e8 78 fc ff ff       	call   f0100296 <cons_intr>
}
f010061e:	c9                   	leave  
f010061f:	c3                   	ret    

f0100620 <cons_getc>:
{
f0100620:	55                   	push   %ebp
f0100621:	89 e5                	mov    %esp,%ebp
f0100623:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f0100626:	e8 c6 ff ff ff       	call   f01005f1 <serial_intr>
	kbd_intr();
f010062b:	e8 de ff ff ff       	call   f010060e <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100630:	8b 15 20 32 21 f0    	mov    0xf0213220,%edx
	return 0;
f0100636:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f010063b:	3b 15 24 32 21 f0    	cmp    0xf0213224,%edx
f0100641:	74 18                	je     f010065b <cons_getc+0x3b>
		c = cons.buf[cons.rpos++];
f0100643:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100646:	89 0d 20 32 21 f0    	mov    %ecx,0xf0213220
f010064c:	0f b6 82 20 30 21 f0 	movzbl -0xfdecfe0(%edx),%eax
		if (cons.rpos == CONSBUFSIZE)
f0100653:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0100659:	74 02                	je     f010065d <cons_getc+0x3d>
}
f010065b:	c9                   	leave  
f010065c:	c3                   	ret    
			cons.rpos = 0;
f010065d:	c7 05 20 32 21 f0 00 	movl   $0x0,0xf0213220
f0100664:	00 00 00 
f0100667:	eb f2                	jmp    f010065b <cons_getc+0x3b>

f0100669 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100669:	55                   	push   %ebp
f010066a:	89 e5                	mov    %esp,%ebp
f010066c:	57                   	push   %edi
f010066d:	56                   	push   %esi
f010066e:	53                   	push   %ebx
f010066f:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100672:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f0100679:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100680:	5a a5 
	if (*cp != 0xA55A) {
f0100682:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f0100689:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010068d:	0f 84 de 00 00 00    	je     f0100771 <cons_init+0x108>
		addr_6845 = MONO_BASE;
f0100693:	c7 05 30 32 21 f0 b4 	movl   $0x3b4,0xf0213230
f010069a:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010069d:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01006a2:	8b 3d 30 32 21 f0    	mov    0xf0213230,%edi
f01006a8:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006ad:	89 fa                	mov    %edi,%edx
f01006af:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01006b0:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006b3:	89 ca                	mov    %ecx,%edx
f01006b5:	ec                   	in     (%dx),%al
f01006b6:	0f b6 c0             	movzbl %al,%eax
f01006b9:	c1 e0 08             	shl    $0x8,%eax
f01006bc:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006be:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006c3:	89 fa                	mov    %edi,%edx
f01006c5:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006c6:	89 ca                	mov    %ecx,%edx
f01006c8:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006c9:	89 35 2c 32 21 f0    	mov    %esi,0xf021322c
	pos |= inb(addr_6845 + 1);
f01006cf:	0f b6 c0             	movzbl %al,%eax
f01006d2:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006d4:	66 a3 28 32 21 f0    	mov    %ax,0xf0213228
	kbd_intr();
f01006da:	e8 2f ff ff ff       	call   f010060e <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006df:	83 ec 0c             	sub    $0xc,%esp
f01006e2:	0f b7 05 a8 13 12 f0 	movzwl 0xf01213a8,%eax
f01006e9:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006ee:	50                   	push   %eax
f01006ef:	e8 c4 30 00 00       	call   f01037b8 <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006f4:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006f9:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f01006fe:	89 d8                	mov    %ebx,%eax
f0100700:	89 ca                	mov    %ecx,%edx
f0100702:	ee                   	out    %al,(%dx)
f0100703:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100708:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010070d:	89 fa                	mov    %edi,%edx
f010070f:	ee                   	out    %al,(%dx)
f0100710:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100715:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010071a:	ee                   	out    %al,(%dx)
f010071b:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100720:	89 d8                	mov    %ebx,%eax
f0100722:	89 f2                	mov    %esi,%edx
f0100724:	ee                   	out    %al,(%dx)
f0100725:	b8 03 00 00 00       	mov    $0x3,%eax
f010072a:	89 fa                	mov    %edi,%edx
f010072c:	ee                   	out    %al,(%dx)
f010072d:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100732:	89 d8                	mov    %ebx,%eax
f0100734:	ee                   	out    %al,(%dx)
f0100735:	b8 01 00 00 00       	mov    $0x1,%eax
f010073a:	89 f2                	mov    %esi,%edx
f010073c:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010073d:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100742:	ec                   	in     (%dx),%al
f0100743:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100745:	83 c4 10             	add    $0x10,%esp
f0100748:	3c ff                	cmp    $0xff,%al
f010074a:	0f 95 05 34 32 21 f0 	setne  0xf0213234
f0100751:	89 ca                	mov    %ecx,%edx
f0100753:	ec                   	in     (%dx),%al
f0100754:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100759:	ec                   	in     (%dx),%al
	if (serial_exists)
f010075a:	80 fb ff             	cmp    $0xff,%bl
f010075d:	75 2d                	jne    f010078c <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f010075f:	83 ec 0c             	sub    $0xc,%esp
f0100762:	68 1a 63 10 f0       	push   $0xf010631a
f0100767:	e8 a7 31 00 00       	call   f0103913 <cprintf>
f010076c:	83 c4 10             	add    $0x10,%esp
}
f010076f:	eb 3c                	jmp    f01007ad <cons_init+0x144>
		*cp = was;
f0100771:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f0100778:	c7 05 30 32 21 f0 d4 	movl   $0x3d4,0xf0213230
f010077f:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100782:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f0100787:	e9 16 ff ff ff       	jmp    f01006a2 <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f010078c:	83 ec 0c             	sub    $0xc,%esp
f010078f:	0f b7 05 a8 13 12 f0 	movzwl 0xf01213a8,%eax
f0100796:	25 ef ff 00 00       	and    $0xffef,%eax
f010079b:	50                   	push   %eax
f010079c:	e8 17 30 00 00       	call   f01037b8 <irq_setmask_8259A>
	if (!serial_exists)
f01007a1:	83 c4 10             	add    $0x10,%esp
f01007a4:	80 3d 34 32 21 f0 00 	cmpb   $0x0,0xf0213234
f01007ab:	74 b2                	je     f010075f <cons_init+0xf6>
}
f01007ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007b0:	5b                   	pop    %ebx
f01007b1:	5e                   	pop    %esi
f01007b2:	5f                   	pop    %edi
f01007b3:	5d                   	pop    %ebp
f01007b4:	c3                   	ret    

f01007b5 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007b5:	55                   	push   %ebp
f01007b6:	89 e5                	mov    %esp,%ebp
f01007b8:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007bb:	8b 45 08             	mov    0x8(%ebp),%eax
f01007be:	e8 33 fc ff ff       	call   f01003f6 <cons_putc>
}
f01007c3:	c9                   	leave  
f01007c4:	c3                   	ret    

f01007c5 <getchar>:

int
getchar(void)
{
f01007c5:	55                   	push   %ebp
f01007c6:	89 e5                	mov    %esp,%ebp
f01007c8:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007cb:	e8 50 fe ff ff       	call   f0100620 <cons_getc>
f01007d0:	85 c0                	test   %eax,%eax
f01007d2:	74 f7                	je     f01007cb <getchar+0x6>
		/* do nothing */;
	return c;
}
f01007d4:	c9                   	leave  
f01007d5:	c3                   	ret    

f01007d6 <iscons>:

int
iscons(int fdnum)
{
f01007d6:	55                   	push   %ebp
f01007d7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f01007d9:	b8 01 00 00 00       	mov    $0x1,%eax
f01007de:	5d                   	pop    %ebp
f01007df:	c3                   	ret    

f01007e0 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007e0:	55                   	push   %ebp
f01007e1:	89 e5                	mov    %esp,%ebp
f01007e3:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007e6:	68 60 65 10 f0       	push   $0xf0106560
f01007eb:	68 7e 65 10 f0       	push   $0xf010657e
f01007f0:	68 83 65 10 f0       	push   $0xf0106583
f01007f5:	e8 19 31 00 00       	call   f0103913 <cprintf>
f01007fa:	83 c4 0c             	add    $0xc,%esp
f01007fd:	68 ec 65 10 f0       	push   $0xf01065ec
f0100802:	68 8c 65 10 f0       	push   $0xf010658c
f0100807:	68 83 65 10 f0       	push   $0xf0106583
f010080c:	e8 02 31 00 00       	call   f0103913 <cprintf>
	return 0;
}
f0100811:	b8 00 00 00 00       	mov    $0x0,%eax
f0100816:	c9                   	leave  
f0100817:	c3                   	ret    

f0100818 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100818:	55                   	push   %ebp
f0100819:	89 e5                	mov    %esp,%ebp
f010081b:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010081e:	68 95 65 10 f0       	push   $0xf0106595
f0100823:	e8 eb 30 00 00       	call   f0103913 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100828:	83 c4 08             	add    $0x8,%esp
f010082b:	68 0c 00 10 00       	push   $0x10000c
f0100830:	68 14 66 10 f0       	push   $0xf0106614
f0100835:	e8 d9 30 00 00       	call   f0103913 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010083a:	83 c4 0c             	add    $0xc,%esp
f010083d:	68 0c 00 10 00       	push   $0x10000c
f0100842:	68 0c 00 10 f0       	push   $0xf010000c
f0100847:	68 3c 66 10 f0       	push   $0xf010663c
f010084c:	e8 c2 30 00 00       	call   f0103913 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100851:	83 c4 0c             	add    $0xc,%esp
f0100854:	68 09 62 10 00       	push   $0x106209
f0100859:	68 09 62 10 f0       	push   $0xf0106209
f010085e:	68 60 66 10 f0       	push   $0xf0106660
f0100863:	e8 ab 30 00 00       	call   f0103913 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100868:	83 c4 0c             	add    $0xc,%esp
f010086b:	68 00 30 21 00       	push   $0x213000
f0100870:	68 00 30 21 f0       	push   $0xf0213000
f0100875:	68 84 66 10 f0       	push   $0xf0106684
f010087a:	e8 94 30 00 00       	call   f0103913 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010087f:	83 c4 0c             	add    $0xc,%esp
f0100882:	68 08 50 25 00       	push   $0x255008
f0100887:	68 08 50 25 f0       	push   $0xf0255008
f010088c:	68 a8 66 10 f0       	push   $0xf01066a8
f0100891:	e8 7d 30 00 00       	call   f0103913 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100896:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f0100899:	b8 07 54 25 f0       	mov    $0xf0255407,%eax
f010089e:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008a3:	c1 f8 0a             	sar    $0xa,%eax
f01008a6:	50                   	push   %eax
f01008a7:	68 cc 66 10 f0       	push   $0xf01066cc
f01008ac:	e8 62 30 00 00       	call   f0103913 <cprintf>
	return 0;
}
f01008b1:	b8 00 00 00 00       	mov    $0x0,%eax
f01008b6:	c9                   	leave  
f01008b7:	c3                   	ret    

f01008b8 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01008b8:	55                   	push   %ebp
f01008b9:	89 e5                	mov    %esp,%ebp
	// Your code here.
	return 0;
}
f01008bb:	b8 00 00 00 00       	mov    $0x0,%eax
f01008c0:	5d                   	pop    %ebp
f01008c1:	c3                   	ret    

f01008c2 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f01008c2:	55                   	push   %ebp
f01008c3:	89 e5                	mov    %esp,%ebp
f01008c5:	57                   	push   %edi
f01008c6:	56                   	push   %esi
f01008c7:	53                   	push   %ebx
f01008c8:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f01008cb:	68 f8 66 10 f0       	push   $0xf01066f8
f01008d0:	e8 3e 30 00 00       	call   f0103913 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01008d5:	c7 04 24 1c 67 10 f0 	movl   $0xf010671c,(%esp)
f01008dc:	e8 32 30 00 00       	call   f0103913 <cprintf>

	if (tf != NULL)
f01008e1:	83 c4 10             	add    $0x10,%esp
f01008e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f01008e8:	74 57                	je     f0100941 <monitor+0x7f>
		print_trapframe(tf);
f01008ea:	83 ec 0c             	sub    $0xc,%esp
f01008ed:	ff 75 08             	pushl  0x8(%ebp)
f01008f0:	e8 e4 33 00 00       	call   f0103cd9 <print_trapframe>
f01008f5:	83 c4 10             	add    $0x10,%esp
f01008f8:	eb 47                	jmp    f0100941 <monitor+0x7f>
		while (*buf && strchr(WHITESPACE, *buf))
f01008fa:	83 ec 08             	sub    $0x8,%esp
f01008fd:	0f be c0             	movsbl %al,%eax
f0100900:	50                   	push   %eax
f0100901:	68 b2 65 10 f0       	push   $0xf01065b2
f0100906:	e8 6a 4c 00 00       	call   f0105575 <strchr>
f010090b:	83 c4 10             	add    $0x10,%esp
f010090e:	85 c0                	test   %eax,%eax
f0100910:	74 0a                	je     f010091c <monitor+0x5a>
			*buf++ = 0;
f0100912:	c6 03 00             	movb   $0x0,(%ebx)
f0100915:	89 f7                	mov    %esi,%edi
f0100917:	8d 5b 01             	lea    0x1(%ebx),%ebx
f010091a:	eb 6b                	jmp    f0100987 <monitor+0xc5>
		if (*buf == 0)
f010091c:	80 3b 00             	cmpb   $0x0,(%ebx)
f010091f:	74 73                	je     f0100994 <monitor+0xd2>
		if (argc == MAXARGS-1) {
f0100921:	83 fe 0f             	cmp    $0xf,%esi
f0100924:	74 09                	je     f010092f <monitor+0x6d>
		argv[argc++] = buf;
f0100926:	8d 7e 01             	lea    0x1(%esi),%edi
f0100929:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f010092d:	eb 39                	jmp    f0100968 <monitor+0xa6>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f010092f:	83 ec 08             	sub    $0x8,%esp
f0100932:	6a 10                	push   $0x10
f0100934:	68 b7 65 10 f0       	push   $0xf01065b7
f0100939:	e8 d5 2f 00 00       	call   f0103913 <cprintf>
f010093e:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100941:	83 ec 0c             	sub    $0xc,%esp
f0100944:	68 ae 65 10 f0       	push   $0xf01065ae
f0100949:	e8 fe 49 00 00       	call   f010534c <readline>
f010094e:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100950:	83 c4 10             	add    $0x10,%esp
f0100953:	85 c0                	test   %eax,%eax
f0100955:	74 ea                	je     f0100941 <monitor+0x7f>
	argv[argc] = 0;
f0100957:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f010095e:	be 00 00 00 00       	mov    $0x0,%esi
f0100963:	eb 24                	jmp    f0100989 <monitor+0xc7>
			buf++;
f0100965:	83 c3 01             	add    $0x1,%ebx
		while (*buf && !strchr(WHITESPACE, *buf))
f0100968:	0f b6 03             	movzbl (%ebx),%eax
f010096b:	84 c0                	test   %al,%al
f010096d:	74 18                	je     f0100987 <monitor+0xc5>
f010096f:	83 ec 08             	sub    $0x8,%esp
f0100972:	0f be c0             	movsbl %al,%eax
f0100975:	50                   	push   %eax
f0100976:	68 b2 65 10 f0       	push   $0xf01065b2
f010097b:	e8 f5 4b 00 00       	call   f0105575 <strchr>
f0100980:	83 c4 10             	add    $0x10,%esp
f0100983:	85 c0                	test   %eax,%eax
f0100985:	74 de                	je     f0100965 <monitor+0xa3>
			*buf++ = 0;
f0100987:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100989:	0f b6 03             	movzbl (%ebx),%eax
f010098c:	84 c0                	test   %al,%al
f010098e:	0f 85 66 ff ff ff    	jne    f01008fa <monitor+0x38>
	argv[argc] = 0;
f0100994:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f010099b:	00 
	if (argc == 0)
f010099c:	85 f6                	test   %esi,%esi
f010099e:	74 a1                	je     f0100941 <monitor+0x7f>
		if (strcmp(argv[0], commands[i].name) == 0)
f01009a0:	83 ec 08             	sub    $0x8,%esp
f01009a3:	68 7e 65 10 f0       	push   $0xf010657e
f01009a8:	ff 75 a8             	pushl  -0x58(%ebp)
f01009ab:	e8 67 4b 00 00       	call   f0105517 <strcmp>
f01009b0:	83 c4 10             	add    $0x10,%esp
f01009b3:	85 c0                	test   %eax,%eax
f01009b5:	74 34                	je     f01009eb <monitor+0x129>
f01009b7:	83 ec 08             	sub    $0x8,%esp
f01009ba:	68 8c 65 10 f0       	push   $0xf010658c
f01009bf:	ff 75 a8             	pushl  -0x58(%ebp)
f01009c2:	e8 50 4b 00 00       	call   f0105517 <strcmp>
f01009c7:	83 c4 10             	add    $0x10,%esp
f01009ca:	85 c0                	test   %eax,%eax
f01009cc:	74 18                	je     f01009e6 <monitor+0x124>
	cprintf("Unknown command '%s'\n", argv[0]);
f01009ce:	83 ec 08             	sub    $0x8,%esp
f01009d1:	ff 75 a8             	pushl  -0x58(%ebp)
f01009d4:	68 d4 65 10 f0       	push   $0xf01065d4
f01009d9:	e8 35 2f 00 00       	call   f0103913 <cprintf>
f01009de:	83 c4 10             	add    $0x10,%esp
f01009e1:	e9 5b ff ff ff       	jmp    f0100941 <monitor+0x7f>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009e6:	b8 01 00 00 00       	mov    $0x1,%eax
			return commands[i].func(argc, argv, tf);
f01009eb:	83 ec 04             	sub    $0x4,%esp
f01009ee:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01009f1:	ff 75 08             	pushl  0x8(%ebp)
f01009f4:	8d 55 a8             	lea    -0x58(%ebp),%edx
f01009f7:	52                   	push   %edx
f01009f8:	56                   	push   %esi
f01009f9:	ff 14 85 4c 67 10 f0 	call   *-0xfef98b4(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100a00:	83 c4 10             	add    $0x10,%esp
f0100a03:	85 c0                	test   %eax,%eax
f0100a05:	0f 89 36 ff ff ff    	jns    f0100941 <monitor+0x7f>
				break;
	}
}
f0100a0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a0e:	5b                   	pop    %ebx
f0100a0f:	5e                   	pop    %esi
f0100a10:	5f                   	pop    %edi
f0100a11:	5d                   	pop    %ebp
f0100a12:	c3                   	ret    

f0100a13 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100a13:	55                   	push   %ebp
f0100a14:	89 e5                	mov    %esp,%ebp
f0100a16:	56                   	push   %esi
f0100a17:	53                   	push   %ebx
f0100a18:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100a1a:	83 ec 0c             	sub    $0xc,%esp
f0100a1d:	50                   	push   %eax
f0100a1e:	e8 67 2d 00 00       	call   f010378a <mc146818_read>
f0100a23:	89 c3                	mov    %eax,%ebx
f0100a25:	83 c6 01             	add    $0x1,%esi
f0100a28:	89 34 24             	mov    %esi,(%esp)
f0100a2b:	e8 5a 2d 00 00       	call   f010378a <mc146818_read>
f0100a30:	c1 e0 08             	shl    $0x8,%eax
f0100a33:	09 d8                	or     %ebx,%eax
}
f0100a35:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100a38:	5b                   	pop    %ebx
f0100a39:	5e                   	pop    %esi
f0100a3a:	5d                   	pop    %ebp
f0100a3b:	c3                   	ret    

f0100a3c <boot_alloc>:
// before the page_free_list list has been set up.
// Note that when this function is called, we are still using entry_pgdir,
// which only maps the first 4MB of physical memory.
static void *
boot_alloc(uint32_t n)
{
f0100a3c:	55                   	push   %ebp
f0100a3d:	89 e5                	mov    %esp,%ebp
f0100a3f:	53                   	push   %ebx
f0100a40:	83 ec 04             	sub    $0x4,%esp
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree)
f0100a43:	83 3d 38 32 21 f0 00 	cmpl   $0x0,0xf0213238
f0100a4a:	74 33                	je     f0100a7f <boot_alloc+0x43>
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	result = nextfree;
f0100a4c:	8b 1d 38 32 21 f0    	mov    0xf0213238,%ebx
	nextfree = ROUNDUP(nextfree + n, PGSIZE);
f0100a52:	8d 94 03 ff 0f 00 00 	lea    0xfff(%ebx,%eax,1),%edx
f0100a59:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100a5f:	89 15 38 32 21 f0    	mov    %edx,0xf0213238
	if ((uint32_t)nextfree - KERNBASE > npages * PGSIZE)
f0100a65:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f0100a6b:	8b 0d 88 3e 21 f0    	mov    0xf0213e88,%ecx
f0100a71:	c1 e1 0c             	shl    $0xc,%ecx
f0100a74:	39 ca                	cmp    %ecx,%edx
f0100a76:	77 1a                	ja     f0100a92 <boot_alloc+0x56>
	{
		panic("out of memory\n");
	}
	return result;
}
f0100a78:	89 d8                	mov    %ebx,%eax
f0100a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100a7d:	c9                   	leave  
f0100a7e:	c3                   	ret    
		nextfree = ROUNDUP((char *)end, PGSIZE);
f0100a7f:	ba 07 60 25 f0       	mov    $0xf0256007,%edx
f0100a84:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100a8a:	89 15 38 32 21 f0    	mov    %edx,0xf0213238
f0100a90:	eb ba                	jmp    f0100a4c <boot_alloc+0x10>
		panic("out of memory\n");
f0100a92:	83 ec 04             	sub    $0x4,%esp
f0100a95:	68 5c 67 10 f0       	push   $0xf010675c
f0100a9a:	6a 71                	push   $0x71
f0100a9c:	68 6b 67 10 f0       	push   $0xf010676b
f0100aa1:	e8 9a f5 ff ff       	call   f0100040 <_panic>

f0100aa6 <check_va2pa>:

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;
	pgdir = &pgdir[PDX(va)];
f0100aa6:	89 d1                	mov    %edx,%ecx
f0100aa8:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100aab:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100aae:	a8 01                	test   $0x1,%al
f0100ab0:	74 52                	je     f0100b04 <check_va2pa+0x5e>
		return ~0;
	p = (pte_t *)KADDR(PTE_ADDR(*pgdir));
f0100ab2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100ab7:	89 c1                	mov    %eax,%ecx
f0100ab9:	c1 e9 0c             	shr    $0xc,%ecx
f0100abc:	3b 0d 88 3e 21 f0    	cmp    0xf0213e88,%ecx
f0100ac2:	73 25                	jae    f0100ae9 <check_va2pa+0x43>
	if (!(p[PTX(va)] & PTE_P))
f0100ac4:	c1 ea 0c             	shr    $0xc,%edx
f0100ac7:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100acd:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100ad4:	89 c2                	mov    %eax,%edx
f0100ad6:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100ad9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ade:	85 d2                	test   %edx,%edx
f0100ae0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100ae5:	0f 44 c2             	cmove  %edx,%eax
f0100ae8:	c3                   	ret    
{
f0100ae9:	55                   	push   %ebp
f0100aea:	89 e5                	mov    %esp,%ebp
f0100aec:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100aef:	50                   	push   %eax
f0100af0:	68 44 62 10 f0       	push   $0xf0106244
f0100af5:	68 9e 03 00 00       	push   $0x39e
f0100afa:	68 6b 67 10 f0       	push   $0xf010676b
f0100aff:	e8 3c f5 ff ff       	call   f0100040 <_panic>
		return ~0;
f0100b04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100b09:	c3                   	ret    

f0100b0a <check_page_free_list>:
{
f0100b0a:	55                   	push   %ebp
f0100b0b:	89 e5                	mov    %esp,%ebp
f0100b0d:	57                   	push   %edi
f0100b0e:	56                   	push   %esi
f0100b0f:	53                   	push   %ebx
f0100b10:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b13:	84 c0                	test   %al,%al
f0100b15:	0f 85 86 02 00 00    	jne    f0100da1 <check_page_free_list+0x297>
	if (!page_free_list)
f0100b1b:	83 3d 40 32 21 f0 00 	cmpl   $0x0,0xf0213240
f0100b22:	74 0a                	je     f0100b2e <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100b24:	be 00 04 00 00       	mov    $0x400,%esi
f0100b29:	e9 ce 02 00 00       	jmp    f0100dfc <check_page_free_list+0x2f2>
		panic("'page_free_list' is a null pointer!");
f0100b2e:	83 ec 04             	sub    $0x4,%esp
f0100b31:	68 38 6a 10 f0       	push   $0xf0106a38
f0100b36:	68 c7 02 00 00       	push   $0x2c7
f0100b3b:	68 6b 67 10 f0       	push   $0xf010676b
f0100b40:	e8 fb f4 ff ff       	call   f0100040 <_panic>
f0100b45:	50                   	push   %eax
f0100b46:	68 44 62 10 f0       	push   $0xf0106244
f0100b4b:	6a 58                	push   $0x58
f0100b4d:	68 77 67 10 f0       	push   $0xf0106777
f0100b52:	e8 e9 f4 ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100b57:	8b 1b                	mov    (%ebx),%ebx
f0100b59:	85 db                	test   %ebx,%ebx
f0100b5b:	74 41                	je     f0100b9e <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100b5d:	89 d8                	mov    %ebx,%eax
f0100b5f:	2b 05 90 3e 21 f0    	sub    0xf0213e90,%eax
f0100b65:	c1 f8 03             	sar    $0x3,%eax
f0100b68:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100b6b:	89 c2                	mov    %eax,%edx
f0100b6d:	c1 ea 16             	shr    $0x16,%edx
f0100b70:	39 f2                	cmp    %esi,%edx
f0100b72:	73 e3                	jae    f0100b57 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100b74:	89 c2                	mov    %eax,%edx
f0100b76:	c1 ea 0c             	shr    $0xc,%edx
f0100b79:	3b 15 88 3e 21 f0    	cmp    0xf0213e88,%edx
f0100b7f:	73 c4                	jae    f0100b45 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100b81:	83 ec 04             	sub    $0x4,%esp
f0100b84:	68 80 00 00 00       	push   $0x80
f0100b89:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100b8e:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100b93:	50                   	push   %eax
f0100b94:	e8 19 4a 00 00       	call   f01055b2 <memset>
f0100b99:	83 c4 10             	add    $0x10,%esp
f0100b9c:	eb b9                	jmp    f0100b57 <check_page_free_list+0x4d>
	first_free_page = (char *)boot_alloc(0);
f0100b9e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ba3:	e8 94 fe ff ff       	call   f0100a3c <boot_alloc>
f0100ba8:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100bab:	8b 15 40 32 21 f0    	mov    0xf0213240,%edx
		assert(pp >= pages);
f0100bb1:	8b 0d 90 3e 21 f0    	mov    0xf0213e90,%ecx
		assert(pp < pages + npages);
f0100bb7:	a1 88 3e 21 f0       	mov    0xf0213e88,%eax
f0100bbc:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100bbf:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
f0100bc2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(((char *)pp - (char *)pages) % sizeof(*pp) == 0);
f0100bc5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
	int nfree_basemem = 0, nfree_extmem = 0;
f0100bc8:	be 00 00 00 00       	mov    $0x0,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100bcd:	e9 04 01 00 00       	jmp    f0100cd6 <check_page_free_list+0x1cc>
		assert(pp >= pages);
f0100bd2:	68 85 67 10 f0       	push   $0xf0106785
f0100bd7:	68 91 67 10 f0       	push   $0xf0106791
f0100bdc:	68 e4 02 00 00       	push   $0x2e4
f0100be1:	68 6b 67 10 f0       	push   $0xf010676b
f0100be6:	e8 55 f4 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100beb:	68 a6 67 10 f0       	push   $0xf01067a6
f0100bf0:	68 91 67 10 f0       	push   $0xf0106791
f0100bf5:	68 e5 02 00 00       	push   $0x2e5
f0100bfa:	68 6b 67 10 f0       	push   $0xf010676b
f0100bff:	e8 3c f4 ff ff       	call   f0100040 <_panic>
		assert(((char *)pp - (char *)pages) % sizeof(*pp) == 0);
f0100c04:	68 5c 6a 10 f0       	push   $0xf0106a5c
f0100c09:	68 91 67 10 f0       	push   $0xf0106791
f0100c0e:	68 e6 02 00 00       	push   $0x2e6
f0100c13:	68 6b 67 10 f0       	push   $0xf010676b
f0100c18:	e8 23 f4 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0100c1d:	68 ba 67 10 f0       	push   $0xf01067ba
f0100c22:	68 91 67 10 f0       	push   $0xf0106791
f0100c27:	68 e9 02 00 00       	push   $0x2e9
f0100c2c:	68 6b 67 10 f0       	push   $0xf010676b
f0100c31:	e8 0a f4 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100c36:	68 cb 67 10 f0       	push   $0xf01067cb
f0100c3b:	68 91 67 10 f0       	push   $0xf0106791
f0100c40:	68 ea 02 00 00       	push   $0x2ea
f0100c45:	68 6b 67 10 f0       	push   $0xf010676b
f0100c4a:	e8 f1 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100c4f:	68 8c 6a 10 f0       	push   $0xf0106a8c
f0100c54:	68 91 67 10 f0       	push   $0xf0106791
f0100c59:	68 eb 02 00 00       	push   $0x2eb
f0100c5e:	68 6b 67 10 f0       	push   $0xf010676b
f0100c63:	e8 d8 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100c68:	68 e4 67 10 f0       	push   $0xf01067e4
f0100c6d:	68 91 67 10 f0       	push   $0xf0106791
f0100c72:	68 ec 02 00 00       	push   $0x2ec
f0100c77:	68 6b 67 10 f0       	push   $0xf010676b
f0100c7c:	e8 bf f3 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100c81:	89 c7                	mov    %eax,%edi
f0100c83:	c1 ef 0c             	shr    $0xc,%edi
f0100c86:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0100c89:	76 1b                	jbe    f0100ca6 <check_page_free_list+0x19c>
	return (void *)(pa + KERNBASE);
f0100c8b:	8d b8 00 00 00 f0    	lea    -0x10000000(%eax),%edi
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100c91:	39 7d c8             	cmp    %edi,-0x38(%ebp)
f0100c94:	77 22                	ja     f0100cb8 <check_page_free_list+0x1ae>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100c96:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100c9b:	0f 84 98 00 00 00    	je     f0100d39 <check_page_free_list+0x22f>
			++nfree_extmem;
f0100ca1:	83 c3 01             	add    $0x1,%ebx
f0100ca4:	eb 2e                	jmp    f0100cd4 <check_page_free_list+0x1ca>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100ca6:	50                   	push   %eax
f0100ca7:	68 44 62 10 f0       	push   $0xf0106244
f0100cac:	6a 58                	push   $0x58
f0100cae:	68 77 67 10 f0       	push   $0xf0106777
f0100cb3:	e8 88 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100cb8:	68 b0 6a 10 f0       	push   $0xf0106ab0
f0100cbd:	68 91 67 10 f0       	push   $0xf0106791
f0100cc2:	68 ed 02 00 00       	push   $0x2ed
f0100cc7:	68 6b 67 10 f0       	push   $0xf010676b
f0100ccc:	e8 6f f3 ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f0100cd1:	83 c6 01             	add    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100cd4:	8b 12                	mov    (%edx),%edx
f0100cd6:	85 d2                	test   %edx,%edx
f0100cd8:	74 78                	je     f0100d52 <check_page_free_list+0x248>
		assert(pp >= pages);
f0100cda:	39 d1                	cmp    %edx,%ecx
f0100cdc:	0f 87 f0 fe ff ff    	ja     f0100bd2 <check_page_free_list+0xc8>
		assert(pp < pages + npages);
f0100ce2:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
f0100ce5:	0f 86 00 ff ff ff    	jbe    f0100beb <check_page_free_list+0xe1>
		assert(((char *)pp - (char *)pages) % sizeof(*pp) == 0);
f0100ceb:	89 d0                	mov    %edx,%eax
f0100ced:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0100cf0:	a8 07                	test   $0x7,%al
f0100cf2:	0f 85 0c ff ff ff    	jne    f0100c04 <check_page_free_list+0xfa>
	return (pp - pages) << PGSHIFT;
f0100cf8:	c1 f8 03             	sar    $0x3,%eax
f0100cfb:	c1 e0 0c             	shl    $0xc,%eax
		assert(page2pa(pp) != 0);
f0100cfe:	85 c0                	test   %eax,%eax
f0100d00:	0f 84 17 ff ff ff    	je     f0100c1d <check_page_free_list+0x113>
		assert(page2pa(pp) != IOPHYSMEM);
f0100d06:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100d0b:	0f 84 25 ff ff ff    	je     f0100c36 <check_page_free_list+0x12c>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100d11:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100d16:	0f 84 33 ff ff ff    	je     f0100c4f <check_page_free_list+0x145>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d1c:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100d21:	0f 84 41 ff ff ff    	je     f0100c68 <check_page_free_list+0x15e>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d27:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100d2c:	0f 87 4f ff ff ff    	ja     f0100c81 <check_page_free_list+0x177>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100d32:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100d37:	75 98                	jne    f0100cd1 <check_page_free_list+0x1c7>
f0100d39:	68 fe 67 10 f0       	push   $0xf01067fe
f0100d3e:	68 91 67 10 f0       	push   $0xf0106791
f0100d43:	68 ef 02 00 00       	push   $0x2ef
f0100d48:	68 6b 67 10 f0       	push   $0xf010676b
f0100d4d:	e8 ee f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_basemem > 0);
f0100d52:	85 f6                	test   %esi,%esi
f0100d54:	7e 19                	jle    f0100d6f <check_page_free_list+0x265>
	assert(nfree_extmem > 0);
f0100d56:	85 db                	test   %ebx,%ebx
f0100d58:	7e 2e                	jle    f0100d88 <check_page_free_list+0x27e>
	cprintf("check_page_free_list() succeeded!\n");
f0100d5a:	83 ec 0c             	sub    $0xc,%esp
f0100d5d:	68 f8 6a 10 f0       	push   $0xf0106af8
f0100d62:	e8 ac 2b 00 00       	call   f0103913 <cprintf>
}
f0100d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100d6a:	5b                   	pop    %ebx
f0100d6b:	5e                   	pop    %esi
f0100d6c:	5f                   	pop    %edi
f0100d6d:	5d                   	pop    %ebp
f0100d6e:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100d6f:	68 1b 68 10 f0       	push   $0xf010681b
f0100d74:	68 91 67 10 f0       	push   $0xf0106791
f0100d79:	68 f7 02 00 00       	push   $0x2f7
f0100d7e:	68 6b 67 10 f0       	push   $0xf010676b
f0100d83:	e8 b8 f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0100d88:	68 2d 68 10 f0       	push   $0xf010682d
f0100d8d:	68 91 67 10 f0       	push   $0xf0106791
f0100d92:	68 f8 02 00 00       	push   $0x2f8
f0100d97:	68 6b 67 10 f0       	push   $0xf010676b
f0100d9c:	e8 9f f2 ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f0100da1:	a1 40 32 21 f0       	mov    0xf0213240,%eax
f0100da6:	85 c0                	test   %eax,%eax
f0100da8:	0f 84 80 fd ff ff    	je     f0100b2e <check_page_free_list+0x24>
		struct PageInfo **tp[2] = {&pp1, &pp2};
f0100dae:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100db1:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100db4:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100db7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100dba:	89 c2                	mov    %eax,%edx
f0100dbc:	2b 15 90 3e 21 f0    	sub    0xf0213e90,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100dc2:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100dc8:	0f 95 c2             	setne  %dl
f0100dcb:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100dce:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100dd2:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100dd4:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link)
f0100dd8:	8b 00                	mov    (%eax),%eax
f0100dda:	85 c0                	test   %eax,%eax
f0100ddc:	75 dc                	jne    f0100dba <check_page_free_list+0x2b0>
		*tp[1] = 0;
f0100dde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100de1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100de7:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100dea:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100ded:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100def:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100df2:	a3 40 32 21 f0       	mov    %eax,0xf0213240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100df7:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100dfc:	8b 1d 40 32 21 f0    	mov    0xf0213240,%ebx
f0100e02:	e9 52 fd ff ff       	jmp    f0100b59 <check_page_free_list+0x4f>

f0100e07 <page_init>:
{
f0100e07:	55                   	push   %ebp
f0100e08:	89 e5                	mov    %esp,%ebp
f0100e0a:	56                   	push   %esi
f0100e0b:	53                   	push   %ebx
	pages[0].pp_ref = 1;
f0100e0c:	a1 90 3e 21 f0       	mov    0xf0213e90,%eax
f0100e11:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
f0100e17:	8b 1d 40 32 21 f0    	mov    0xf0213240,%ebx
	for (i = 1; i != IOPHYSMEM / PGSIZE; ++i)
f0100e1d:	b8 01 00 00 00       	mov    $0x1,%eax
f0100e22:	eb 0f                	jmp    f0100e33 <page_init+0x2c>
			pages[i].pp_ref = 1;
f0100e24:	8b 15 90 3e 21 f0    	mov    0xf0213e90,%edx
f0100e2a:	66 c7 42 3c 01 00    	movw   $0x1,0x3c(%edx)
	for (i = 1; i != IOPHYSMEM / PGSIZE; ++i)
f0100e30:	83 c0 01             	add    $0x1,%eax
		if (i == mp_page)
f0100e33:	83 f8 07             	cmp    $0x7,%eax
f0100e36:	74 ec                	je     f0100e24 <page_init+0x1d>
f0100e38:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100e3f:	89 d1                	mov    %edx,%ecx
f0100e41:	03 0d 90 3e 21 f0    	add    0xf0213e90,%ecx
f0100e47:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100e4d:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f0100e4f:	89 d3                	mov    %edx,%ebx
f0100e51:	03 1d 90 3e 21 f0    	add    0xf0213e90,%ebx
	for (i = 1; i != IOPHYSMEM / PGSIZE; ++i)
f0100e57:	83 c0 01             	add    $0x1,%eax
f0100e5a:	3d a0 00 00 00       	cmp    $0xa0,%eax
f0100e5f:	75 d2                	jne    f0100e33 <page_init+0x2c>
f0100e61:	89 1d 40 32 21 f0    	mov    %ebx,0xf0213240
		pages[i].pp_ref = 1;
f0100e67:	8b 15 90 3e 21 f0    	mov    0xf0213e90,%edx
f0100e6d:	8d 82 04 05 00 00    	lea    0x504(%edx),%eax
f0100e73:	81 c2 04 08 00 00    	add    $0x804,%edx
f0100e79:	66 c7 00 01 00       	movw   $0x1,(%eax)
f0100e7e:	83 c0 08             	add    $0x8,%eax
	for (; i < EXTPHYSMEM / PGSIZE; i++)
f0100e81:	39 d0                	cmp    %edx,%eax
f0100e83:	75 f4                	jne    f0100e79 <page_init+0x72>
	size_t first_free_address = PADDR(boot_alloc(0));
f0100e85:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e8a:	e8 ad fb ff ff       	call   f0100a3c <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100e8f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e94:	76 15                	jbe    f0100eab <page_init+0xa4>
	return (physaddr_t)kva - KERNBASE;
f0100e96:	05 00 00 00 10       	add    $0x10000000,%eax
	for (i = EXTPHYSMEM / PGSIZE; i < first_free_address / PGSIZE; i++)
f0100e9b:	c1 e8 0c             	shr    $0xc,%eax
		pages[i].pp_ref = 1;
f0100e9e:	8b 0d 90 3e 21 f0    	mov    0xf0213e90,%ecx
	for (i = EXTPHYSMEM / PGSIZE; i < first_free_address / PGSIZE; i++)
f0100ea4:	ba 00 01 00 00       	mov    $0x100,%edx
f0100ea9:	eb 1f                	jmp    f0100eca <page_init+0xc3>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100eab:	50                   	push   %eax
f0100eac:	68 68 62 10 f0       	push   $0xf0106268
f0100eb1:	68 40 01 00 00       	push   $0x140
f0100eb6:	68 6b 67 10 f0       	push   $0xf010676b
f0100ebb:	e8 80 f1 ff ff       	call   f0100040 <_panic>
		pages[i].pp_ref = 1;
f0100ec0:	66 c7 44 d1 04 01 00 	movw   $0x1,0x4(%ecx,%edx,8)
	for (i = EXTPHYSMEM / PGSIZE; i < first_free_address / PGSIZE; i++)
f0100ec7:	83 c2 01             	add    $0x1,%edx
f0100eca:	39 d0                	cmp    %edx,%eax
f0100ecc:	77 f2                	ja     f0100ec0 <page_init+0xb9>
f0100ece:	8b 1d 40 32 21 f0    	mov    0xf0213240,%ebx
	for (i = first_free_address / PGSIZE; i < npages; i++)
f0100ed4:	ba 00 00 00 00       	mov    $0x0,%edx
f0100ed9:	be 01 00 00 00       	mov    $0x1,%esi
f0100ede:	eb 24                	jmp    f0100f04 <page_init+0xfd>
f0100ee0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		pages[i].pp_ref = 0;
f0100ee7:	89 d1                	mov    %edx,%ecx
f0100ee9:	03 0d 90 3e 21 f0    	add    0xf0213e90,%ecx
f0100eef:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0100ef5:	89 19                	mov    %ebx,(%ecx)
	for (i = first_free_address / PGSIZE; i < npages; i++)
f0100ef7:	83 c0 01             	add    $0x1,%eax
		page_free_list = &pages[i];
f0100efa:	03 15 90 3e 21 f0    	add    0xf0213e90,%edx
f0100f00:	89 d3                	mov    %edx,%ebx
f0100f02:	89 f2                	mov    %esi,%edx
	for (i = first_free_address / PGSIZE; i < npages; i++)
f0100f04:	3b 05 88 3e 21 f0    	cmp    0xf0213e88,%eax
f0100f0a:	72 d4                	jb     f0100ee0 <page_init+0xd9>
f0100f0c:	84 d2                	test   %dl,%dl
f0100f0e:	75 07                	jne    f0100f17 <page_init+0x110>
}
f0100f10:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100f13:	5b                   	pop    %ebx
f0100f14:	5e                   	pop    %esi
f0100f15:	5d                   	pop    %ebp
f0100f16:	c3                   	ret    
f0100f17:	89 1d 40 32 21 f0    	mov    %ebx,0xf0213240
f0100f1d:	eb f1                	jmp    f0100f10 <page_init+0x109>

f0100f1f <page_alloc>:
{
f0100f1f:	55                   	push   %ebp
f0100f20:	89 e5                	mov    %esp,%ebp
f0100f22:	53                   	push   %ebx
f0100f23:	83 ec 04             	sub    $0x4,%esp
	if (page_free_list == NULL)
f0100f26:	8b 1d 40 32 21 f0    	mov    0xf0213240,%ebx
f0100f2c:	85 db                	test   %ebx,%ebx
f0100f2e:	74 13                	je     f0100f43 <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f0100f30:	8b 03                	mov    (%ebx),%eax
f0100f32:	a3 40 32 21 f0       	mov    %eax,0xf0213240
	allocated_page->pp_link = NULL;
f0100f37:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if (alloc_flags & ALLOC_ZERO)
f0100f3d:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0100f41:	75 07                	jne    f0100f4a <page_alloc+0x2b>
}
f0100f43:	89 d8                	mov    %ebx,%eax
f0100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100f48:	c9                   	leave  
f0100f49:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0100f4a:	89 d8                	mov    %ebx,%eax
f0100f4c:	2b 05 90 3e 21 f0    	sub    0xf0213e90,%eax
f0100f52:	c1 f8 03             	sar    $0x3,%eax
f0100f55:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0100f58:	89 c2                	mov    %eax,%edx
f0100f5a:	c1 ea 0c             	shr    $0xc,%edx
f0100f5d:	3b 15 88 3e 21 f0    	cmp    0xf0213e88,%edx
f0100f63:	73 1a                	jae    f0100f7f <page_alloc+0x60>
		memset(page2kva(allocated_page), '\0', PGSIZE);
f0100f65:	83 ec 04             	sub    $0x4,%esp
f0100f68:	68 00 10 00 00       	push   $0x1000
f0100f6d:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0100f6f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100f74:	50                   	push   %eax
f0100f75:	e8 38 46 00 00       	call   f01055b2 <memset>
f0100f7a:	83 c4 10             	add    $0x10,%esp
f0100f7d:	eb c4                	jmp    f0100f43 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100f7f:	50                   	push   %eax
f0100f80:	68 44 62 10 f0       	push   $0xf0106244
f0100f85:	6a 58                	push   $0x58
f0100f87:	68 77 67 10 f0       	push   $0xf0106777
f0100f8c:	e8 af f0 ff ff       	call   f0100040 <_panic>

f0100f91 <page_free>:
{
f0100f91:	55                   	push   %ebp
f0100f92:	89 e5                	mov    %esp,%ebp
f0100f94:	83 ec 08             	sub    $0x8,%esp
f0100f97:	8b 45 08             	mov    0x8(%ebp),%eax
	if (pp->pp_ref > 0 || pp->pp_link != NULL)
f0100f9a:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0100f9f:	75 14                	jne    f0100fb5 <page_free+0x24>
f0100fa1:	83 38 00             	cmpl   $0x0,(%eax)
f0100fa4:	75 0f                	jne    f0100fb5 <page_free+0x24>
	pp->pp_link = page_free_list;
f0100fa6:	8b 15 40 32 21 f0    	mov    0xf0213240,%edx
f0100fac:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0100fae:	a3 40 32 21 f0       	mov    %eax,0xf0213240
}
f0100fb3:	c9                   	leave  
f0100fb4:	c3                   	ret    
		panic("Double check failed when dealloc page");
f0100fb5:	83 ec 04             	sub    $0x4,%esp
f0100fb8:	68 1c 6b 10 f0       	push   $0xf0106b1c
f0100fbd:	68 7a 01 00 00       	push   $0x17a
f0100fc2:	68 6b 67 10 f0       	push   $0xf010676b
f0100fc7:	e8 74 f0 ff ff       	call   f0100040 <_panic>

f0100fcc <page_decref>:
{
f0100fcc:	55                   	push   %ebp
f0100fcd:	89 e5                	mov    %esp,%ebp
f0100fcf:	83 ec 08             	sub    $0x8,%esp
f0100fd2:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f0100fd5:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f0100fd9:	83 e8 01             	sub    $0x1,%eax
f0100fdc:	66 89 42 04          	mov    %ax,0x4(%edx)
f0100fe0:	66 85 c0             	test   %ax,%ax
f0100fe3:	74 02                	je     f0100fe7 <page_decref+0x1b>
}
f0100fe5:	c9                   	leave  
f0100fe6:	c3                   	ret    
		page_free(pp);
f0100fe7:	83 ec 0c             	sub    $0xc,%esp
f0100fea:	52                   	push   %edx
f0100feb:	e8 a1 ff ff ff       	call   f0100f91 <page_free>
f0100ff0:	83 c4 10             	add    $0x10,%esp
}
f0100ff3:	eb f0                	jmp    f0100fe5 <page_decref+0x19>

f0100ff5 <pgdir_walk>:
{
f0100ff5:	55                   	push   %ebp
f0100ff6:	89 e5                	mov    %esp,%ebp
f0100ff8:	56                   	push   %esi
f0100ff9:	53                   	push   %ebx
f0100ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
	uint32_t page_tab_idx = PTX(va);
f0100ffd:	89 c6                	mov    %eax,%esi
f0100fff:	c1 ee 0c             	shr    $0xc,%esi
f0101002:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	uint32_t page_dir_idx = PDX(va);
f0101008:	c1 e8 16             	shr    $0x16,%eax
	if (pgdir[page_dir_idx] & PTE_P)
f010100b:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
f0101012:	03 5d 08             	add    0x8(%ebp),%ebx
f0101015:	8b 03                	mov    (%ebx),%eax
f0101017:	a8 01                	test   $0x1,%al
f0101019:	74 37                	je     f0101052 <pgdir_walk+0x5d>
		pgtab = KADDR(PTE_ADDR(pgdir[page_dir_idx]));
f010101b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101020:	89 c2                	mov    %eax,%edx
f0101022:	c1 ea 0c             	shr    $0xc,%edx
f0101025:	39 15 88 3e 21 f0    	cmp    %edx,0xf0213e88
f010102b:	76 10                	jbe    f010103d <pgdir_walk+0x48>
	return (void *)(pa + KERNBASE);
f010102d:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
	return &pgtab[page_tab_idx];
f0101033:	8d 04 b2             	lea    (%edx,%esi,4),%eax
}
f0101036:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101039:	5b                   	pop    %ebx
f010103a:	5e                   	pop    %esi
f010103b:	5d                   	pop    %ebp
f010103c:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010103d:	50                   	push   %eax
f010103e:	68 44 62 10 f0       	push   $0xf0106244
f0101043:	68 ac 01 00 00       	push   $0x1ac
f0101048:	68 6b 67 10 f0       	push   $0xf010676b
f010104d:	e8 ee ef ff ff       	call   f0100040 <_panic>
		if (create)
f0101052:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101056:	74 6d                	je     f01010c5 <pgdir_walk+0xd0>
			struct PageInfo *new_pageInfo = page_alloc(ALLOC_ZERO);
f0101058:	83 ec 0c             	sub    $0xc,%esp
f010105b:	6a 01                	push   $0x1
f010105d:	e8 bd fe ff ff       	call   f0100f1f <page_alloc>
			if (new_pageInfo)
f0101062:	83 c4 10             	add    $0x10,%esp
f0101065:	85 c0                	test   %eax,%eax
f0101067:	74 66                	je     f01010cf <pgdir_walk+0xda>
				new_pageInfo->pp_ref += 1;
f0101069:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f010106e:	2b 05 90 3e 21 f0    	sub    0xf0213e90,%eax
f0101074:	c1 f8 03             	sar    $0x3,%eax
f0101077:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010107a:	89 c2                	mov    %eax,%edx
f010107c:	c1 ea 0c             	shr    $0xc,%edx
f010107f:	3b 15 88 3e 21 f0    	cmp    0xf0213e88,%edx
f0101085:	73 17                	jae    f010109e <pgdir_walk+0xa9>
	return (void *)(pa + KERNBASE);
f0101087:	8d 88 00 00 00 f0    	lea    -0x10000000(%eax),%ecx
f010108d:	89 ca                	mov    %ecx,%edx
	if ((uint32_t)kva < KERNBASE)
f010108f:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0101095:	76 19                	jbe    f01010b0 <pgdir_walk+0xbb>
				pgdir[page_dir_idx] = PADDR(pgtab) | PTE_P | PTE_W | PTE_U;
f0101097:	83 c8 07             	or     $0x7,%eax
f010109a:	89 03                	mov    %eax,(%ebx)
f010109c:	eb 95                	jmp    f0101033 <pgdir_walk+0x3e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010109e:	50                   	push   %eax
f010109f:	68 44 62 10 f0       	push   $0xf0106244
f01010a4:	6a 58                	push   $0x58
f01010a6:	68 77 67 10 f0       	push   $0xf0106777
f01010ab:	e8 90 ef ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01010b0:	51                   	push   %ecx
f01010b1:	68 68 62 10 f0       	push   $0xf0106268
f01010b6:	68 b9 01 00 00       	push   $0x1b9
f01010bb:	68 6b 67 10 f0       	push   $0xf010676b
f01010c0:	e8 7b ef ff ff       	call   f0100040 <_panic>
			return NULL;
f01010c5:	b8 00 00 00 00       	mov    $0x0,%eax
f01010ca:	e9 67 ff ff ff       	jmp    f0101036 <pgdir_walk+0x41>
				return NULL;
f01010cf:	b8 00 00 00 00       	mov    $0x0,%eax
f01010d4:	e9 5d ff ff ff       	jmp    f0101036 <pgdir_walk+0x41>

f01010d9 <boot_map_region>:
{
f01010d9:	55                   	push   %ebp
f01010da:	89 e5                	mov    %esp,%ebp
f01010dc:	57                   	push   %edi
f01010dd:	56                   	push   %esi
f01010de:	53                   	push   %ebx
f01010df:	83 ec 20             	sub    $0x20,%esp
f01010e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01010e5:	89 d7                	mov    %edx,%edi
	size_t pg_num = PGNUM(size);
f01010e7:	89 c8                	mov    %ecx,%eax
f01010e9:	c1 e8 0c             	shr    $0xc,%eax
f01010ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("map region size = %d, %d pages\n", size, pg_num);
f01010ef:	50                   	push   %eax
f01010f0:	51                   	push   %ecx
f01010f1:	68 44 6b 10 f0       	push   $0xf0106b44
f01010f6:	e8 18 28 00 00       	call   f0103913 <cprintf>
	for (size_t i = 0; i < pg_num; i++)
f01010fb:	83 c4 10             	add    $0x10,%esp
f01010fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101101:	be 00 00 00 00       	mov    $0x0,%esi
		pgtab = pgdir_walk(pgdir, (void *)va, 1);
f0101106:	29 df                	sub    %ebx,%edi
		*pgtab = pa | perm | PTE_P;
f0101108:	8b 45 0c             	mov    0xc(%ebp),%eax
f010110b:	83 c8 01             	or     $0x1,%eax
f010110e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	for (size_t i = 0; i < pg_num; i++)
f0101111:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
f0101114:	74 2a                	je     f0101140 <boot_map_region+0x67>
		pgtab = pgdir_walk(pgdir, (void *)va, 1);
f0101116:	83 ec 04             	sub    $0x4,%esp
f0101119:	6a 01                	push   $0x1
f010111b:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
f010111e:	50                   	push   %eax
f010111f:	ff 75 e0             	pushl  -0x20(%ebp)
f0101122:	e8 ce fe ff ff       	call   f0100ff5 <pgdir_walk>
		if (!pgtab)
f0101127:	83 c4 10             	add    $0x10,%esp
f010112a:	85 c0                	test   %eax,%eax
f010112c:	74 12                	je     f0101140 <boot_map_region+0x67>
		*pgtab = pa | perm | PTE_P;
f010112e:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101131:	09 da                	or     %ebx,%edx
f0101133:	89 10                	mov    %edx,(%eax)
		pa += PGSIZE;
f0101135:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (size_t i = 0; i < pg_num; i++)
f010113b:	83 c6 01             	add    $0x1,%esi
f010113e:	eb d1                	jmp    f0101111 <boot_map_region+0x38>
}
f0101140:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101143:	5b                   	pop    %ebx
f0101144:	5e                   	pop    %esi
f0101145:	5f                   	pop    %edi
f0101146:	5d                   	pop    %ebp
f0101147:	c3                   	ret    

f0101148 <page_lookup>:
{
f0101148:	55                   	push   %ebp
f0101149:	89 e5                	mov    %esp,%ebp
f010114b:	53                   	push   %ebx
f010114c:	83 ec 08             	sub    $0x8,%esp
f010114f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *pte = pgdir_walk(pgdir, va, 0);
f0101152:	6a 00                	push   $0x0
f0101154:	ff 75 0c             	pushl  0xc(%ebp)
f0101157:	ff 75 08             	pushl  0x8(%ebp)
f010115a:	e8 96 fe ff ff       	call   f0100ff5 <pgdir_walk>
	if (!pte || !(*pte & PTE_P)) {
f010115f:	83 c4 10             	add    $0x10,%esp
f0101162:	85 c0                	test   %eax,%eax
f0101164:	74 3a                	je     f01011a0 <page_lookup+0x58>
f0101166:	f6 00 01             	testb  $0x1,(%eax)
f0101169:	74 3c                	je     f01011a7 <page_lookup+0x5f>
	if (pte_store) {
f010116b:	85 db                	test   %ebx,%ebx
f010116d:	74 02                	je     f0101171 <page_lookup+0x29>
		*pte_store = pte;
f010116f:	89 03                	mov    %eax,(%ebx)
f0101171:	8b 00                	mov    (%eax),%eax
f0101173:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101176:	39 05 88 3e 21 f0    	cmp    %eax,0xf0213e88
f010117c:	76 0e                	jbe    f010118c <page_lookup+0x44>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f010117e:	8b 15 90 3e 21 f0    	mov    0xf0213e90,%edx
f0101184:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f0101187:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010118a:	c9                   	leave  
f010118b:	c3                   	ret    
		panic("pa2page called with invalid pa");
f010118c:	83 ec 04             	sub    $0x4,%esp
f010118f:	68 64 6b 10 f0       	push   $0xf0106b64
f0101194:	6a 51                	push   $0x51
f0101196:	68 77 67 10 f0       	push   $0xf0106777
f010119b:	e8 a0 ee ff ff       	call   f0100040 <_panic>
		return NULL;
f01011a0:	b8 00 00 00 00       	mov    $0x0,%eax
f01011a5:	eb e0                	jmp    f0101187 <page_lookup+0x3f>
f01011a7:	b8 00 00 00 00       	mov    $0x0,%eax
f01011ac:	eb d9                	jmp    f0101187 <page_lookup+0x3f>

f01011ae <tlb_invalidate>:
{
f01011ae:	55                   	push   %ebp
f01011af:	89 e5                	mov    %esp,%ebp
f01011b1:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f01011b4:	e8 1e 4a 00 00       	call   f0105bd7 <cpunum>
f01011b9:	6b c0 74             	imul   $0x74,%eax,%eax
f01011bc:	83 b8 28 40 21 f0 00 	cmpl   $0x0,-0xfdebfd8(%eax)
f01011c3:	74 16                	je     f01011db <tlb_invalidate+0x2d>
f01011c5:	e8 0d 4a 00 00       	call   f0105bd7 <cpunum>
f01011ca:	6b c0 74             	imul   $0x74,%eax,%eax
f01011cd:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f01011d3:	8b 55 08             	mov    0x8(%ebp),%edx
f01011d6:	39 50 60             	cmp    %edx,0x60(%eax)
f01011d9:	75 06                	jne    f01011e1 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01011db:	8b 45 0c             	mov    0xc(%ebp),%eax
f01011de:	0f 01 38             	invlpg (%eax)
}
f01011e1:	c9                   	leave  
f01011e2:	c3                   	ret    

f01011e3 <page_remove>:
{
f01011e3:	55                   	push   %ebp
f01011e4:	89 e5                	mov    %esp,%ebp
f01011e6:	56                   	push   %esi
f01011e7:	53                   	push   %ebx
f01011e8:	83 ec 14             	sub    $0x14,%esp
f01011eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01011ee:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *pInfo = page_lookup(pgdir, va, pte_store);
f01011f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01011f4:	50                   	push   %eax
f01011f5:	56                   	push   %esi
f01011f6:	53                   	push   %ebx
f01011f7:	e8 4c ff ff ff       	call   f0101148 <page_lookup>
	if (!pInfo)
f01011fc:	83 c4 10             	add    $0x10,%esp
f01011ff:	85 c0                	test   %eax,%eax
f0101201:	75 07                	jne    f010120a <page_remove+0x27>
}
f0101203:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101206:	5b                   	pop    %ebx
f0101207:	5e                   	pop    %esi
f0101208:	5d                   	pop    %ebp
f0101209:	c3                   	ret    
	page_decref(pInfo);
f010120a:	83 ec 0c             	sub    $0xc,%esp
f010120d:	50                   	push   %eax
f010120e:	e8 b9 fd ff ff       	call   f0100fcc <page_decref>
	*pgtab = 0;				   // 将内容清0，即无法再根据页表内容得到物理地址。
f0101213:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101216:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate(pgdir, va); // 通知tlb失效。tlb是个高速缓存，用来缓存查找记录增加查找速度。
f010121c:	83 c4 08             	add    $0x8,%esp
f010121f:	56                   	push   %esi
f0101220:	53                   	push   %ebx
f0101221:	e8 88 ff ff ff       	call   f01011ae <tlb_invalidate>
f0101226:	83 c4 10             	add    $0x10,%esp
f0101229:	eb d8                	jmp    f0101203 <page_remove+0x20>

f010122b <page_insert>:
{
f010122b:	55                   	push   %ebp
f010122c:	89 e5                	mov    %esp,%ebp
f010122e:	57                   	push   %edi
f010122f:	56                   	push   %esi
f0101230:	53                   	push   %ebx
f0101231:	83 ec 10             	sub    $0x10,%esp
f0101234:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101237:	8b 7d 10             	mov    0x10(%ebp),%edi
	pte_t *pgtab = pgdir_walk(pgdir, va, 1); // 查找该虚拟地址对应的页表项，不存在则建立。
f010123a:	6a 01                	push   $0x1
f010123c:	57                   	push   %edi
f010123d:	ff 75 08             	pushl  0x8(%ebp)
f0101240:	e8 b0 fd ff ff       	call   f0100ff5 <pgdir_walk>
	if (!pgtab)
f0101245:	83 c4 10             	add    $0x10,%esp
f0101248:	85 c0                	test   %eax,%eax
f010124a:	74 40                	je     f010128c <page_insert+0x61>
f010124c:	89 c6                	mov    %eax,%esi
	pp->pp_ref++;
f010124e:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
	if (*pgtab & PTE_P)
f0101253:	f6 00 01             	testb  $0x1,(%eax)
f0101256:	75 23                	jne    f010127b <page_insert+0x50>
	return (pp - pages) << PGSHIFT;
f0101258:	2b 1d 90 3e 21 f0    	sub    0xf0213e90,%ebx
f010125e:	c1 fb 03             	sar    $0x3,%ebx
f0101261:	c1 e3 0c             	shl    $0xc,%ebx
	*pgtab = page2pa(pp) | perm | PTE_P;
f0101264:	8b 45 14             	mov    0x14(%ebp),%eax
f0101267:	83 c8 01             	or     $0x1,%eax
f010126a:	09 c3                	or     %eax,%ebx
f010126c:	89 1e                	mov    %ebx,(%esi)
	return 0;
f010126e:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101273:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101276:	5b                   	pop    %ebx
f0101277:	5e                   	pop    %esi
f0101278:	5f                   	pop    %edi
f0101279:	5d                   	pop    %ebp
f010127a:	c3                   	ret    
		page_remove(pgdir, va);
f010127b:	83 ec 08             	sub    $0x8,%esp
f010127e:	57                   	push   %edi
f010127f:	ff 75 08             	pushl  0x8(%ebp)
f0101282:	e8 5c ff ff ff       	call   f01011e3 <page_remove>
f0101287:	83 c4 10             	add    $0x10,%esp
f010128a:	eb cc                	jmp    f0101258 <page_insert+0x2d>
		return -E_NO_MEM; // 空间不足
f010128c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101291:	eb e0                	jmp    f0101273 <page_insert+0x48>

f0101293 <mmio_map_region>:
{
f0101293:	55                   	push   %ebp
f0101294:	89 e5                	mov    %esp,%ebp
f0101296:	53                   	push   %ebx
f0101297:	83 ec 04             	sub    $0x4,%esp
    size_t rounded_size = ROUNDUP(size, PGSIZE);
f010129a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010129d:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f01012a3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if (base + rounded_size > MMIOLIM) panic("overflow MMIOLIM");
f01012a9:	8b 15 00 13 12 f0    	mov    0xf0121300,%edx
f01012af:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
f01012b2:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f01012b7:	77 26                	ja     f01012df <mmio_map_region+0x4c>
    boot_map_region(kern_pgdir, base, rounded_size, pa, PTE_W|PTE_PCD|PTE_PWT);
f01012b9:	83 ec 08             	sub    $0x8,%esp
f01012bc:	6a 1a                	push   $0x1a
f01012be:	ff 75 08             	pushl  0x8(%ebp)
f01012c1:	89 d9                	mov    %ebx,%ecx
f01012c3:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
f01012c8:	e8 0c fe ff ff       	call   f01010d9 <boot_map_region>
    uintptr_t res_region_base = base;   
f01012cd:	a1 00 13 12 f0       	mov    0xf0121300,%eax
    base += rounded_size;       
f01012d2:	01 c3                	add    %eax,%ebx
f01012d4:	89 1d 00 13 12 f0    	mov    %ebx,0xf0121300
}
f01012da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012dd:	c9                   	leave  
f01012de:	c3                   	ret    
    if (base + rounded_size > MMIOLIM) panic("overflow MMIOLIM");
f01012df:	83 ec 04             	sub    $0x4,%esp
f01012e2:	68 3e 68 10 f0       	push   $0xf010683e
f01012e7:	68 77 02 00 00       	push   $0x277
f01012ec:	68 6b 67 10 f0       	push   $0xf010676b
f01012f1:	e8 4a ed ff ff       	call   f0100040 <_panic>

f01012f6 <mem_init>:
{
f01012f6:	55                   	push   %ebp
f01012f7:	89 e5                	mov    %esp,%ebp
f01012f9:	57                   	push   %edi
f01012fa:	56                   	push   %esi
f01012fb:	53                   	push   %ebx
f01012fc:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f01012ff:	b8 15 00 00 00       	mov    $0x15,%eax
f0101304:	e8 0a f7 ff ff       	call   f0100a13 <nvram_read>
f0101309:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f010130b:	b8 17 00 00 00       	mov    $0x17,%eax
f0101310:	e8 fe f6 ff ff       	call   f0100a13 <nvram_read>
f0101315:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101317:	b8 34 00 00 00       	mov    $0x34,%eax
f010131c:	e8 f2 f6 ff ff       	call   f0100a13 <nvram_read>
f0101321:	c1 e0 06             	shl    $0x6,%eax
	if (ext16mem)
f0101324:	85 c0                	test   %eax,%eax
f0101326:	0f 85 d9 00 00 00    	jne    f0101405 <mem_init+0x10f>
		totalmem = 1 * 1024 + extmem;
f010132c:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0101332:	85 f6                	test   %esi,%esi
f0101334:	0f 44 c3             	cmove  %ebx,%eax
	npages = totalmem / (PGSIZE / 1024);
f0101337:	89 c2                	mov    %eax,%edx
f0101339:	c1 ea 02             	shr    $0x2,%edx
f010133c:	89 15 88 3e 21 f0    	mov    %edx,0xf0213e88
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101342:	89 c2                	mov    %eax,%edx
f0101344:	29 da                	sub    %ebx,%edx
f0101346:	52                   	push   %edx
f0101347:	53                   	push   %ebx
f0101348:	50                   	push   %eax
f0101349:	68 84 6b 10 f0       	push   $0xf0106b84
f010134e:	e8 c0 25 00 00       	call   f0103913 <cprintf>
	kern_pgdir = (pde_t *)boot_alloc(PGSIZE);
f0101353:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101358:	e8 df f6 ff ff       	call   f0100a3c <boot_alloc>
f010135d:	a3 8c 3e 21 f0       	mov    %eax,0xf0213e8c
	memset(kern_pgdir, 0, PGSIZE);
f0101362:	83 c4 0c             	add    $0xc,%esp
f0101365:	68 00 10 00 00       	push   $0x1000
f010136a:	6a 00                	push   $0x0
f010136c:	50                   	push   %eax
f010136d:	e8 40 42 00 00       	call   f01055b2 <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101372:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0101377:	83 c4 10             	add    $0x10,%esp
f010137a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010137f:	0f 86 8a 00 00 00    	jbe    f010140f <mem_init+0x119>
	return (physaddr_t)kva - KERNBASE;
f0101385:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010138b:	83 ca 05             	or     $0x5,%edx
f010138e:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo *)boot_alloc(npages * sizeof(struct PageInfo));
f0101394:	a1 88 3e 21 f0       	mov    0xf0213e88,%eax
f0101399:	c1 e0 03             	shl    $0x3,%eax
f010139c:	e8 9b f6 ff ff       	call   f0100a3c <boot_alloc>
f01013a1:	a3 90 3e 21 f0       	mov    %eax,0xf0213e90
	memset(pages, 0, npages * sizeof(struct PageInfo));
f01013a6:	83 ec 04             	sub    $0x4,%esp
f01013a9:	8b 0d 88 3e 21 f0    	mov    0xf0213e88,%ecx
f01013af:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f01013b6:	52                   	push   %edx
f01013b7:	6a 00                	push   $0x0
f01013b9:	50                   	push   %eax
f01013ba:	e8 f3 41 00 00       	call   f01055b2 <memset>
	envs = (struct Env *)boot_alloc(NENV * sizeof(struct Env));
f01013bf:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f01013c4:	e8 73 f6 ff ff       	call   f0100a3c <boot_alloc>
f01013c9:	a3 44 32 21 f0       	mov    %eax,0xf0213244
	memset(envs, 0, NENV * sizeof(struct Env));
f01013ce:	83 c4 0c             	add    $0xc,%esp
f01013d1:	68 00 f0 01 00       	push   $0x1f000
f01013d6:	6a 00                	push   $0x0
f01013d8:	50                   	push   %eax
f01013d9:	e8 d4 41 00 00       	call   f01055b2 <memset>
	page_init();
f01013de:	e8 24 fa ff ff       	call   f0100e07 <page_init>
	check_page_free_list(1);
f01013e3:	b8 01 00 00 00       	mov    $0x1,%eax
f01013e8:	e8 1d f7 ff ff       	call   f0100b0a <check_page_free_list>
	if (!pages)
f01013ed:	83 c4 10             	add    $0x10,%esp
f01013f0:	83 3d 90 3e 21 f0 00 	cmpl   $0x0,0xf0213e90
f01013f7:	74 2b                	je     f0101424 <mem_init+0x12e>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01013f9:	a1 40 32 21 f0       	mov    0xf0213240,%eax
f01013fe:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101403:	eb 3b                	jmp    f0101440 <mem_init+0x14a>
		totalmem = 16 * 1024 + ext16mem;
f0101405:	05 00 40 00 00       	add    $0x4000,%eax
f010140a:	e9 28 ff ff ff       	jmp    f0101337 <mem_init+0x41>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010140f:	50                   	push   %eax
f0101410:	68 68 62 10 f0       	push   $0xf0106268
f0101415:	68 99 00 00 00       	push   $0x99
f010141a:	68 6b 67 10 f0       	push   $0xf010676b
f010141f:	e8 1c ec ff ff       	call   f0100040 <_panic>
		panic("'pages' is a null pointer!");
f0101424:	83 ec 04             	sub    $0x4,%esp
f0101427:	68 4f 68 10 f0       	push   $0xf010684f
f010142c:	68 0b 03 00 00       	push   $0x30b
f0101431:	68 6b 67 10 f0       	push   $0xf010676b
f0101436:	e8 05 ec ff ff       	call   f0100040 <_panic>
		++nfree;
f010143b:	83 c3 01             	add    $0x1,%ebx
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010143e:	8b 00                	mov    (%eax),%eax
f0101440:	85 c0                	test   %eax,%eax
f0101442:	75 f7                	jne    f010143b <mem_init+0x145>
	assert((pp0 = page_alloc(0)));
f0101444:	83 ec 0c             	sub    $0xc,%esp
f0101447:	6a 00                	push   $0x0
f0101449:	e8 d1 fa ff ff       	call   f0100f1f <page_alloc>
f010144e:	89 c7                	mov    %eax,%edi
f0101450:	83 c4 10             	add    $0x10,%esp
f0101453:	85 c0                	test   %eax,%eax
f0101455:	0f 84 12 02 00 00    	je     f010166d <mem_init+0x377>
	assert((pp1 = page_alloc(0)));
f010145b:	83 ec 0c             	sub    $0xc,%esp
f010145e:	6a 00                	push   $0x0
f0101460:	e8 ba fa ff ff       	call   f0100f1f <page_alloc>
f0101465:	89 c6                	mov    %eax,%esi
f0101467:	83 c4 10             	add    $0x10,%esp
f010146a:	85 c0                	test   %eax,%eax
f010146c:	0f 84 14 02 00 00    	je     f0101686 <mem_init+0x390>
	assert((pp2 = page_alloc(0)));
f0101472:	83 ec 0c             	sub    $0xc,%esp
f0101475:	6a 00                	push   $0x0
f0101477:	e8 a3 fa ff ff       	call   f0100f1f <page_alloc>
f010147c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010147f:	83 c4 10             	add    $0x10,%esp
f0101482:	85 c0                	test   %eax,%eax
f0101484:	0f 84 15 02 00 00    	je     f010169f <mem_init+0x3a9>
	assert(pp1 && pp1 != pp0);
f010148a:	39 f7                	cmp    %esi,%edi
f010148c:	0f 84 26 02 00 00    	je     f01016b8 <mem_init+0x3c2>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101492:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101495:	39 c7                	cmp    %eax,%edi
f0101497:	0f 84 34 02 00 00    	je     f01016d1 <mem_init+0x3db>
f010149d:	39 c6                	cmp    %eax,%esi
f010149f:	0f 84 2c 02 00 00    	je     f01016d1 <mem_init+0x3db>
	return (pp - pages) << PGSHIFT;
f01014a5:	8b 0d 90 3e 21 f0    	mov    0xf0213e90,%ecx
	assert(page2pa(pp0) < npages * PGSIZE);
f01014ab:	8b 15 88 3e 21 f0    	mov    0xf0213e88,%edx
f01014b1:	c1 e2 0c             	shl    $0xc,%edx
f01014b4:	89 f8                	mov    %edi,%eax
f01014b6:	29 c8                	sub    %ecx,%eax
f01014b8:	c1 f8 03             	sar    $0x3,%eax
f01014bb:	c1 e0 0c             	shl    $0xc,%eax
f01014be:	39 d0                	cmp    %edx,%eax
f01014c0:	0f 83 24 02 00 00    	jae    f01016ea <mem_init+0x3f4>
f01014c6:	89 f0                	mov    %esi,%eax
f01014c8:	29 c8                	sub    %ecx,%eax
f01014ca:	c1 f8 03             	sar    $0x3,%eax
f01014cd:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages * PGSIZE);
f01014d0:	39 c2                	cmp    %eax,%edx
f01014d2:	0f 86 2b 02 00 00    	jbe    f0101703 <mem_init+0x40d>
f01014d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01014db:	29 c8                	sub    %ecx,%eax
f01014dd:	c1 f8 03             	sar    $0x3,%eax
f01014e0:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages * PGSIZE);
f01014e3:	39 c2                	cmp    %eax,%edx
f01014e5:	0f 86 31 02 00 00    	jbe    f010171c <mem_init+0x426>
	fl = page_free_list;
f01014eb:	a1 40 32 21 f0       	mov    0xf0213240,%eax
f01014f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f01014f3:	c7 05 40 32 21 f0 00 	movl   $0x0,0xf0213240
f01014fa:	00 00 00 
	assert(!page_alloc(0));
f01014fd:	83 ec 0c             	sub    $0xc,%esp
f0101500:	6a 00                	push   $0x0
f0101502:	e8 18 fa ff ff       	call   f0100f1f <page_alloc>
f0101507:	83 c4 10             	add    $0x10,%esp
f010150a:	85 c0                	test   %eax,%eax
f010150c:	0f 85 23 02 00 00    	jne    f0101735 <mem_init+0x43f>
	page_free(pp0);
f0101512:	83 ec 0c             	sub    $0xc,%esp
f0101515:	57                   	push   %edi
f0101516:	e8 76 fa ff ff       	call   f0100f91 <page_free>
	page_free(pp1);
f010151b:	89 34 24             	mov    %esi,(%esp)
f010151e:	e8 6e fa ff ff       	call   f0100f91 <page_free>
	page_free(pp2);
f0101523:	83 c4 04             	add    $0x4,%esp
f0101526:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101529:	e8 63 fa ff ff       	call   f0100f91 <page_free>
	assert((pp0 = page_alloc(0)));
f010152e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101535:	e8 e5 f9 ff ff       	call   f0100f1f <page_alloc>
f010153a:	89 c6                	mov    %eax,%esi
f010153c:	83 c4 10             	add    $0x10,%esp
f010153f:	85 c0                	test   %eax,%eax
f0101541:	0f 84 07 02 00 00    	je     f010174e <mem_init+0x458>
	assert((pp1 = page_alloc(0)));
f0101547:	83 ec 0c             	sub    $0xc,%esp
f010154a:	6a 00                	push   $0x0
f010154c:	e8 ce f9 ff ff       	call   f0100f1f <page_alloc>
f0101551:	89 c7                	mov    %eax,%edi
f0101553:	83 c4 10             	add    $0x10,%esp
f0101556:	85 c0                	test   %eax,%eax
f0101558:	0f 84 09 02 00 00    	je     f0101767 <mem_init+0x471>
	assert((pp2 = page_alloc(0)));
f010155e:	83 ec 0c             	sub    $0xc,%esp
f0101561:	6a 00                	push   $0x0
f0101563:	e8 b7 f9 ff ff       	call   f0100f1f <page_alloc>
f0101568:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010156b:	83 c4 10             	add    $0x10,%esp
f010156e:	85 c0                	test   %eax,%eax
f0101570:	0f 84 0a 02 00 00    	je     f0101780 <mem_init+0x48a>
	assert(pp1 && pp1 != pp0);
f0101576:	39 fe                	cmp    %edi,%esi
f0101578:	0f 84 1b 02 00 00    	je     f0101799 <mem_init+0x4a3>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010157e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101581:	39 c7                	cmp    %eax,%edi
f0101583:	0f 84 29 02 00 00    	je     f01017b2 <mem_init+0x4bc>
f0101589:	39 c6                	cmp    %eax,%esi
f010158b:	0f 84 21 02 00 00    	je     f01017b2 <mem_init+0x4bc>
	assert(!page_alloc(0));
f0101591:	83 ec 0c             	sub    $0xc,%esp
f0101594:	6a 00                	push   $0x0
f0101596:	e8 84 f9 ff ff       	call   f0100f1f <page_alloc>
f010159b:	83 c4 10             	add    $0x10,%esp
f010159e:	85 c0                	test   %eax,%eax
f01015a0:	0f 85 25 02 00 00    	jne    f01017cb <mem_init+0x4d5>
f01015a6:	89 f0                	mov    %esi,%eax
f01015a8:	2b 05 90 3e 21 f0    	sub    0xf0213e90,%eax
f01015ae:	c1 f8 03             	sar    $0x3,%eax
f01015b1:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01015b4:	89 c2                	mov    %eax,%edx
f01015b6:	c1 ea 0c             	shr    $0xc,%edx
f01015b9:	3b 15 88 3e 21 f0    	cmp    0xf0213e88,%edx
f01015bf:	0f 83 1f 02 00 00    	jae    f01017e4 <mem_init+0x4ee>
	memset(page2kva(pp0), 1, PGSIZE);
f01015c5:	83 ec 04             	sub    $0x4,%esp
f01015c8:	68 00 10 00 00       	push   $0x1000
f01015cd:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f01015cf:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01015d4:	50                   	push   %eax
f01015d5:	e8 d8 3f 00 00       	call   f01055b2 <memset>
	page_free(pp0);
f01015da:	89 34 24             	mov    %esi,(%esp)
f01015dd:	e8 af f9 ff ff       	call   f0100f91 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01015e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01015e9:	e8 31 f9 ff ff       	call   f0100f1f <page_alloc>
f01015ee:	83 c4 10             	add    $0x10,%esp
f01015f1:	85 c0                	test   %eax,%eax
f01015f3:	0f 84 fd 01 00 00    	je     f01017f6 <mem_init+0x500>
	assert(pp && pp0 == pp);
f01015f9:	39 c6                	cmp    %eax,%esi
f01015fb:	0f 85 0e 02 00 00    	jne    f010180f <mem_init+0x519>
	return (pp - pages) << PGSHIFT;
f0101601:	89 f2                	mov    %esi,%edx
f0101603:	2b 15 90 3e 21 f0    	sub    0xf0213e90,%edx
f0101609:	c1 fa 03             	sar    $0x3,%edx
f010160c:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010160f:	89 d0                	mov    %edx,%eax
f0101611:	c1 e8 0c             	shr    $0xc,%eax
f0101614:	3b 05 88 3e 21 f0    	cmp    0xf0213e88,%eax
f010161a:	0f 83 08 02 00 00    	jae    f0101828 <mem_init+0x532>
	return (void *)(pa + KERNBASE);
f0101620:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101626:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f010162c:	80 38 00             	cmpb   $0x0,(%eax)
f010162f:	0f 85 05 02 00 00    	jne    f010183a <mem_init+0x544>
f0101635:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f0101638:	39 d0                	cmp    %edx,%eax
f010163a:	75 f0                	jne    f010162c <mem_init+0x336>
	page_free_list = fl;
f010163c:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010163f:	a3 40 32 21 f0       	mov    %eax,0xf0213240
	page_free(pp0);
f0101644:	83 ec 0c             	sub    $0xc,%esp
f0101647:	56                   	push   %esi
f0101648:	e8 44 f9 ff ff       	call   f0100f91 <page_free>
	page_free(pp1);
f010164d:	89 3c 24             	mov    %edi,(%esp)
f0101650:	e8 3c f9 ff ff       	call   f0100f91 <page_free>
	page_free(pp2);
f0101655:	83 c4 04             	add    $0x4,%esp
f0101658:	ff 75 d4             	pushl  -0x2c(%ebp)
f010165b:	e8 31 f9 ff ff       	call   f0100f91 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101660:	a1 40 32 21 f0       	mov    0xf0213240,%eax
f0101665:	83 c4 10             	add    $0x10,%esp
f0101668:	e9 eb 01 00 00       	jmp    f0101858 <mem_init+0x562>
	assert((pp0 = page_alloc(0)));
f010166d:	68 6a 68 10 f0       	push   $0xf010686a
f0101672:	68 91 67 10 f0       	push   $0xf0106791
f0101677:	68 13 03 00 00       	push   $0x313
f010167c:	68 6b 67 10 f0       	push   $0xf010676b
f0101681:	e8 ba e9 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101686:	68 80 68 10 f0       	push   $0xf0106880
f010168b:	68 91 67 10 f0       	push   $0xf0106791
f0101690:	68 14 03 00 00       	push   $0x314
f0101695:	68 6b 67 10 f0       	push   $0xf010676b
f010169a:	e8 a1 e9 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f010169f:	68 96 68 10 f0       	push   $0xf0106896
f01016a4:	68 91 67 10 f0       	push   $0xf0106791
f01016a9:	68 15 03 00 00       	push   $0x315
f01016ae:	68 6b 67 10 f0       	push   $0xf010676b
f01016b3:	e8 88 e9 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01016b8:	68 ac 68 10 f0       	push   $0xf01068ac
f01016bd:	68 91 67 10 f0       	push   $0xf0106791
f01016c2:	68 18 03 00 00       	push   $0x318
f01016c7:	68 6b 67 10 f0       	push   $0xf010676b
f01016cc:	e8 6f e9 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01016d1:	68 c0 6b 10 f0       	push   $0xf0106bc0
f01016d6:	68 91 67 10 f0       	push   $0xf0106791
f01016db:	68 19 03 00 00       	push   $0x319
f01016e0:	68 6b 67 10 f0       	push   $0xf010676b
f01016e5:	e8 56 e9 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp0) < npages * PGSIZE);
f01016ea:	68 e0 6b 10 f0       	push   $0xf0106be0
f01016ef:	68 91 67 10 f0       	push   $0xf0106791
f01016f4:	68 1a 03 00 00       	push   $0x31a
f01016f9:	68 6b 67 10 f0       	push   $0xf010676b
f01016fe:	e8 3d e9 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp1) < npages * PGSIZE);
f0101703:	68 00 6c 10 f0       	push   $0xf0106c00
f0101708:	68 91 67 10 f0       	push   $0xf0106791
f010170d:	68 1b 03 00 00       	push   $0x31b
f0101712:	68 6b 67 10 f0       	push   $0xf010676b
f0101717:	e8 24 e9 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp2) < npages * PGSIZE);
f010171c:	68 20 6c 10 f0       	push   $0xf0106c20
f0101721:	68 91 67 10 f0       	push   $0xf0106791
f0101726:	68 1c 03 00 00       	push   $0x31c
f010172b:	68 6b 67 10 f0       	push   $0xf010676b
f0101730:	e8 0b e9 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101735:	68 be 68 10 f0       	push   $0xf01068be
f010173a:	68 91 67 10 f0       	push   $0xf0106791
f010173f:	68 23 03 00 00       	push   $0x323
f0101744:	68 6b 67 10 f0       	push   $0xf010676b
f0101749:	e8 f2 e8 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f010174e:	68 6a 68 10 f0       	push   $0xf010686a
f0101753:	68 91 67 10 f0       	push   $0xf0106791
f0101758:	68 2a 03 00 00       	push   $0x32a
f010175d:	68 6b 67 10 f0       	push   $0xf010676b
f0101762:	e8 d9 e8 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101767:	68 80 68 10 f0       	push   $0xf0106880
f010176c:	68 91 67 10 f0       	push   $0xf0106791
f0101771:	68 2b 03 00 00       	push   $0x32b
f0101776:	68 6b 67 10 f0       	push   $0xf010676b
f010177b:	e8 c0 e8 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101780:	68 96 68 10 f0       	push   $0xf0106896
f0101785:	68 91 67 10 f0       	push   $0xf0106791
f010178a:	68 2c 03 00 00       	push   $0x32c
f010178f:	68 6b 67 10 f0       	push   $0xf010676b
f0101794:	e8 a7 e8 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101799:	68 ac 68 10 f0       	push   $0xf01068ac
f010179e:	68 91 67 10 f0       	push   $0xf0106791
f01017a3:	68 2e 03 00 00       	push   $0x32e
f01017a8:	68 6b 67 10 f0       	push   $0xf010676b
f01017ad:	e8 8e e8 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01017b2:	68 c0 6b 10 f0       	push   $0xf0106bc0
f01017b7:	68 91 67 10 f0       	push   $0xf0106791
f01017bc:	68 2f 03 00 00       	push   $0x32f
f01017c1:	68 6b 67 10 f0       	push   $0xf010676b
f01017c6:	e8 75 e8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01017cb:	68 be 68 10 f0       	push   $0xf01068be
f01017d0:	68 91 67 10 f0       	push   $0xf0106791
f01017d5:	68 30 03 00 00       	push   $0x330
f01017da:	68 6b 67 10 f0       	push   $0xf010676b
f01017df:	e8 5c e8 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01017e4:	50                   	push   %eax
f01017e5:	68 44 62 10 f0       	push   $0xf0106244
f01017ea:	6a 58                	push   $0x58
f01017ec:	68 77 67 10 f0       	push   $0xf0106777
f01017f1:	e8 4a e8 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01017f6:	68 cd 68 10 f0       	push   $0xf01068cd
f01017fb:	68 91 67 10 f0       	push   $0xf0106791
f0101800:	68 35 03 00 00       	push   $0x335
f0101805:	68 6b 67 10 f0       	push   $0xf010676b
f010180a:	e8 31 e8 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f010180f:	68 eb 68 10 f0       	push   $0xf01068eb
f0101814:	68 91 67 10 f0       	push   $0xf0106791
f0101819:	68 36 03 00 00       	push   $0x336
f010181e:	68 6b 67 10 f0       	push   $0xf010676b
f0101823:	e8 18 e8 ff ff       	call   f0100040 <_panic>
f0101828:	52                   	push   %edx
f0101829:	68 44 62 10 f0       	push   $0xf0106244
f010182e:	6a 58                	push   $0x58
f0101830:	68 77 67 10 f0       	push   $0xf0106777
f0101835:	e8 06 e8 ff ff       	call   f0100040 <_panic>
		assert(c[i] == 0);
f010183a:	68 fb 68 10 f0       	push   $0xf01068fb
f010183f:	68 91 67 10 f0       	push   $0xf0106791
f0101844:	68 39 03 00 00       	push   $0x339
f0101849:	68 6b 67 10 f0       	push   $0xf010676b
f010184e:	e8 ed e7 ff ff       	call   f0100040 <_panic>
		--nfree;
f0101853:	83 eb 01             	sub    $0x1,%ebx
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101856:	8b 00                	mov    (%eax),%eax
f0101858:	85 c0                	test   %eax,%eax
f010185a:	75 f7                	jne    f0101853 <mem_init+0x55d>
	assert(nfree == 0);
f010185c:	85 db                	test   %ebx,%ebx
f010185e:	0f 85 67 09 00 00    	jne    f01021cb <mem_init+0xed5>
	cprintf("check_page_alloc() succeeded!\n");
f0101864:	83 ec 0c             	sub    $0xc,%esp
f0101867:	68 40 6c 10 f0       	push   $0xf0106c40
f010186c:	e8 a2 20 00 00       	call   f0103913 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101871:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101878:	e8 a2 f6 ff ff       	call   f0100f1f <page_alloc>
f010187d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101880:	83 c4 10             	add    $0x10,%esp
f0101883:	85 c0                	test   %eax,%eax
f0101885:	0f 84 59 09 00 00    	je     f01021e4 <mem_init+0xeee>
	assert((pp1 = page_alloc(0)));
f010188b:	83 ec 0c             	sub    $0xc,%esp
f010188e:	6a 00                	push   $0x0
f0101890:	e8 8a f6 ff ff       	call   f0100f1f <page_alloc>
f0101895:	89 c3                	mov    %eax,%ebx
f0101897:	83 c4 10             	add    $0x10,%esp
f010189a:	85 c0                	test   %eax,%eax
f010189c:	0f 84 5b 09 00 00    	je     f01021fd <mem_init+0xf07>
	assert((pp2 = page_alloc(0)));
f01018a2:	83 ec 0c             	sub    $0xc,%esp
f01018a5:	6a 00                	push   $0x0
f01018a7:	e8 73 f6 ff ff       	call   f0100f1f <page_alloc>
f01018ac:	89 c6                	mov    %eax,%esi
f01018ae:	83 c4 10             	add    $0x10,%esp
f01018b1:	85 c0                	test   %eax,%eax
f01018b3:	0f 84 5d 09 00 00    	je     f0102216 <mem_init+0xf20>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f01018b9:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f01018bc:	0f 84 6d 09 00 00    	je     f010222f <mem_init+0xf39>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01018c2:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f01018c5:	0f 84 7d 09 00 00    	je     f0102248 <mem_init+0xf52>
f01018cb:	39 c3                	cmp    %eax,%ebx
f01018cd:	0f 84 75 09 00 00    	je     f0102248 <mem_init+0xf52>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f01018d3:	a1 40 32 21 f0       	mov    0xf0213240,%eax
f01018d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f01018db:	c7 05 40 32 21 f0 00 	movl   $0x0,0xf0213240
f01018e2:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f01018e5:	83 ec 0c             	sub    $0xc,%esp
f01018e8:	6a 00                	push   $0x0
f01018ea:	e8 30 f6 ff ff       	call   f0100f1f <page_alloc>
f01018ef:	83 c4 10             	add    $0x10,%esp
f01018f2:	85 c0                	test   %eax,%eax
f01018f4:	0f 85 67 09 00 00    	jne    f0102261 <mem_init+0xf6b>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *)0x0, &ptep) == NULL);
f01018fa:	83 ec 04             	sub    $0x4,%esp
f01018fd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101900:	50                   	push   %eax
f0101901:	6a 00                	push   $0x0
f0101903:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101909:	e8 3a f8 ff ff       	call   f0101148 <page_lookup>
f010190e:	83 c4 10             	add    $0x10,%esp
f0101911:	85 c0                	test   %eax,%eax
f0101913:	0f 85 61 09 00 00    	jne    f010227a <mem_init+0xf84>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101919:	6a 02                	push   $0x2
f010191b:	6a 00                	push   $0x0
f010191d:	53                   	push   %ebx
f010191e:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101924:	e8 02 f9 ff ff       	call   f010122b <page_insert>
f0101929:	83 c4 10             	add    $0x10,%esp
f010192c:	85 c0                	test   %eax,%eax
f010192e:	0f 89 5f 09 00 00    	jns    f0102293 <mem_init+0xf9d>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101934:	83 ec 0c             	sub    $0xc,%esp
f0101937:	ff 75 d4             	pushl  -0x2c(%ebp)
f010193a:	e8 52 f6 ff ff       	call   f0100f91 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f010193f:	6a 02                	push   $0x2
f0101941:	6a 00                	push   $0x0
f0101943:	53                   	push   %ebx
f0101944:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f010194a:	e8 dc f8 ff ff       	call   f010122b <page_insert>
f010194f:	83 c4 20             	add    $0x20,%esp
f0101952:	85 c0                	test   %eax,%eax
f0101954:	0f 85 52 09 00 00    	jne    f01022ac <mem_init+0xfb6>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010195a:	8b 3d 8c 3e 21 f0    	mov    0xf0213e8c,%edi
	return (pp - pages) << PGSHIFT;
f0101960:	8b 0d 90 3e 21 f0    	mov    0xf0213e90,%ecx
f0101966:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101969:	8b 17                	mov    (%edi),%edx
f010196b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101971:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101974:	29 c8                	sub    %ecx,%eax
f0101976:	c1 f8 03             	sar    $0x3,%eax
f0101979:	c1 e0 0c             	shl    $0xc,%eax
f010197c:	39 c2                	cmp    %eax,%edx
f010197e:	0f 85 41 09 00 00    	jne    f01022c5 <mem_init+0xfcf>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101984:	ba 00 00 00 00       	mov    $0x0,%edx
f0101989:	89 f8                	mov    %edi,%eax
f010198b:	e8 16 f1 ff ff       	call   f0100aa6 <check_va2pa>
f0101990:	89 da                	mov    %ebx,%edx
f0101992:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101995:	c1 fa 03             	sar    $0x3,%edx
f0101998:	c1 e2 0c             	shl    $0xc,%edx
f010199b:	39 d0                	cmp    %edx,%eax
f010199d:	0f 85 3b 09 00 00    	jne    f01022de <mem_init+0xfe8>
	assert(pp1->pp_ref == 1);
f01019a3:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01019a8:	0f 85 49 09 00 00    	jne    f01022f7 <mem_init+0x1001>
	assert(pp0->pp_ref == 1);
f01019ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01019b1:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f01019b6:	0f 85 54 09 00 00    	jne    f0102310 <mem_init+0x101a>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W) == 0);
f01019bc:	6a 02                	push   $0x2
f01019be:	68 00 10 00 00       	push   $0x1000
f01019c3:	56                   	push   %esi
f01019c4:	57                   	push   %edi
f01019c5:	e8 61 f8 ff ff       	call   f010122b <page_insert>
f01019ca:	83 c4 10             	add    $0x10,%esp
f01019cd:	85 c0                	test   %eax,%eax
f01019cf:	0f 85 54 09 00 00    	jne    f0102329 <mem_init+0x1033>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01019d5:	ba 00 10 00 00       	mov    $0x1000,%edx
f01019da:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
f01019df:	e8 c2 f0 ff ff       	call   f0100aa6 <check_va2pa>
f01019e4:	89 f2                	mov    %esi,%edx
f01019e6:	2b 15 90 3e 21 f0    	sub    0xf0213e90,%edx
f01019ec:	c1 fa 03             	sar    $0x3,%edx
f01019ef:	c1 e2 0c             	shl    $0xc,%edx
f01019f2:	39 d0                	cmp    %edx,%eax
f01019f4:	0f 85 48 09 00 00    	jne    f0102342 <mem_init+0x104c>
	assert(pp2->pp_ref == 1);
f01019fa:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01019ff:	0f 85 56 09 00 00    	jne    f010235b <mem_init+0x1065>

	// should be no free memory
	assert(!page_alloc(0));
f0101a05:	83 ec 0c             	sub    $0xc,%esp
f0101a08:	6a 00                	push   $0x0
f0101a0a:	e8 10 f5 ff ff       	call   f0100f1f <page_alloc>
f0101a0f:	83 c4 10             	add    $0x10,%esp
f0101a12:	85 c0                	test   %eax,%eax
f0101a14:	0f 85 5a 09 00 00    	jne    f0102374 <mem_init+0x107e>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W) == 0);
f0101a1a:	6a 02                	push   $0x2
f0101a1c:	68 00 10 00 00       	push   $0x1000
f0101a21:	56                   	push   %esi
f0101a22:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101a28:	e8 fe f7 ff ff       	call   f010122b <page_insert>
f0101a2d:	83 c4 10             	add    $0x10,%esp
f0101a30:	85 c0                	test   %eax,%eax
f0101a32:	0f 85 55 09 00 00    	jne    f010238d <mem_init+0x1097>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101a38:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101a3d:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
f0101a42:	e8 5f f0 ff ff       	call   f0100aa6 <check_va2pa>
f0101a47:	89 f2                	mov    %esi,%edx
f0101a49:	2b 15 90 3e 21 f0    	sub    0xf0213e90,%edx
f0101a4f:	c1 fa 03             	sar    $0x3,%edx
f0101a52:	c1 e2 0c             	shl    $0xc,%edx
f0101a55:	39 d0                	cmp    %edx,%eax
f0101a57:	0f 85 49 09 00 00    	jne    f01023a6 <mem_init+0x10b0>
	assert(pp2->pp_ref == 1);
f0101a5d:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101a62:	0f 85 57 09 00 00    	jne    f01023bf <mem_init+0x10c9>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101a68:	83 ec 0c             	sub    $0xc,%esp
f0101a6b:	6a 00                	push   $0x0
f0101a6d:	e8 ad f4 ff ff       	call   f0100f1f <page_alloc>
f0101a72:	83 c4 10             	add    $0x10,%esp
f0101a75:	85 c0                	test   %eax,%eax
f0101a77:	0f 85 5b 09 00 00    	jne    f01023d8 <mem_init+0x10e2>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *)KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101a7d:	8b 15 8c 3e 21 f0    	mov    0xf0213e8c,%edx
f0101a83:	8b 02                	mov    (%edx),%eax
f0101a85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101a8a:	89 c1                	mov    %eax,%ecx
f0101a8c:	c1 e9 0c             	shr    $0xc,%ecx
f0101a8f:	3b 0d 88 3e 21 f0    	cmp    0xf0213e88,%ecx
f0101a95:	0f 83 56 09 00 00    	jae    f01023f1 <mem_init+0x10fb>
	return (void *)(pa + KERNBASE);
f0101a9b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101aa0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) == ptep + PTX(PGSIZE));
f0101aa3:	83 ec 04             	sub    $0x4,%esp
f0101aa6:	6a 00                	push   $0x0
f0101aa8:	68 00 10 00 00       	push   $0x1000
f0101aad:	52                   	push   %edx
f0101aae:	e8 42 f5 ff ff       	call   f0100ff5 <pgdir_walk>
f0101ab3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101ab6:	8d 51 04             	lea    0x4(%ecx),%edx
f0101ab9:	83 c4 10             	add    $0x10,%esp
f0101abc:	39 d0                	cmp    %edx,%eax
f0101abe:	0f 85 42 09 00 00    	jne    f0102406 <mem_init+0x1110>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W | PTE_U) == 0);
f0101ac4:	6a 06                	push   $0x6
f0101ac6:	68 00 10 00 00       	push   $0x1000
f0101acb:	56                   	push   %esi
f0101acc:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101ad2:	e8 54 f7 ff ff       	call   f010122b <page_insert>
f0101ad7:	83 c4 10             	add    $0x10,%esp
f0101ada:	85 c0                	test   %eax,%eax
f0101adc:	0f 85 3d 09 00 00    	jne    f010241f <mem_init+0x1129>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101ae2:	8b 3d 8c 3e 21 f0    	mov    0xf0213e8c,%edi
f0101ae8:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101aed:	89 f8                	mov    %edi,%eax
f0101aef:	e8 b2 ef ff ff       	call   f0100aa6 <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101af4:	89 f2                	mov    %esi,%edx
f0101af6:	2b 15 90 3e 21 f0    	sub    0xf0213e90,%edx
f0101afc:	c1 fa 03             	sar    $0x3,%edx
f0101aff:	c1 e2 0c             	shl    $0xc,%edx
f0101b02:	39 d0                	cmp    %edx,%eax
f0101b04:	0f 85 2e 09 00 00    	jne    f0102438 <mem_init+0x1142>
	assert(pp2->pp_ref == 1);
f0101b0a:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101b0f:	0f 85 3c 09 00 00    	jne    f0102451 <mem_init+0x115b>
	assert(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_U);
f0101b15:	83 ec 04             	sub    $0x4,%esp
f0101b18:	6a 00                	push   $0x0
f0101b1a:	68 00 10 00 00       	push   $0x1000
f0101b1f:	57                   	push   %edi
f0101b20:	e8 d0 f4 ff ff       	call   f0100ff5 <pgdir_walk>
f0101b25:	83 c4 10             	add    $0x10,%esp
f0101b28:	f6 00 04             	testb  $0x4,(%eax)
f0101b2b:	0f 84 39 09 00 00    	je     f010246a <mem_init+0x1174>
	assert(kern_pgdir[0] & PTE_U);
f0101b31:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
f0101b36:	f6 00 04             	testb  $0x4,(%eax)
f0101b39:	0f 84 44 09 00 00    	je     f0102483 <mem_init+0x118d>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W) == 0);
f0101b3f:	6a 02                	push   $0x2
f0101b41:	68 00 10 00 00       	push   $0x1000
f0101b46:	56                   	push   %esi
f0101b47:	50                   	push   %eax
f0101b48:	e8 de f6 ff ff       	call   f010122b <page_insert>
f0101b4d:	83 c4 10             	add    $0x10,%esp
f0101b50:	85 c0                	test   %eax,%eax
f0101b52:	0f 85 44 09 00 00    	jne    f010249c <mem_init+0x11a6>
	assert(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_W);
f0101b58:	83 ec 04             	sub    $0x4,%esp
f0101b5b:	6a 00                	push   $0x0
f0101b5d:	68 00 10 00 00       	push   $0x1000
f0101b62:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101b68:	e8 88 f4 ff ff       	call   f0100ff5 <pgdir_walk>
f0101b6d:	83 c4 10             	add    $0x10,%esp
f0101b70:	f6 00 02             	testb  $0x2,(%eax)
f0101b73:	0f 84 3c 09 00 00    	je     f01024b5 <mem_init+0x11bf>
	assert(!(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_U));
f0101b79:	83 ec 04             	sub    $0x4,%esp
f0101b7c:	6a 00                	push   $0x0
f0101b7e:	68 00 10 00 00       	push   $0x1000
f0101b83:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101b89:	e8 67 f4 ff ff       	call   f0100ff5 <pgdir_walk>
f0101b8e:	83 c4 10             	add    $0x10,%esp
f0101b91:	f6 00 04             	testb  $0x4,(%eax)
f0101b94:	0f 85 34 09 00 00    	jne    f01024ce <mem_init+0x11d8>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void *)PTSIZE, PTE_W) < 0);
f0101b9a:	6a 02                	push   $0x2
f0101b9c:	68 00 00 40 00       	push   $0x400000
f0101ba1:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101ba4:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101baa:	e8 7c f6 ff ff       	call   f010122b <page_insert>
f0101baf:	83 c4 10             	add    $0x10,%esp
f0101bb2:	85 c0                	test   %eax,%eax
f0101bb4:	0f 89 2d 09 00 00    	jns    f01024e7 <mem_init+0x11f1>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void *)PGSIZE, PTE_W) == 0);
f0101bba:	6a 02                	push   $0x2
f0101bbc:	68 00 10 00 00       	push   $0x1000
f0101bc1:	53                   	push   %ebx
f0101bc2:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101bc8:	e8 5e f6 ff ff       	call   f010122b <page_insert>
f0101bcd:	83 c4 10             	add    $0x10,%esp
f0101bd0:	85 c0                	test   %eax,%eax
f0101bd2:	0f 85 28 09 00 00    	jne    f0102500 <mem_init+0x120a>
	assert(!(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_U));
f0101bd8:	83 ec 04             	sub    $0x4,%esp
f0101bdb:	6a 00                	push   $0x0
f0101bdd:	68 00 10 00 00       	push   $0x1000
f0101be2:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101be8:	e8 08 f4 ff ff       	call   f0100ff5 <pgdir_walk>
f0101bed:	83 c4 10             	add    $0x10,%esp
f0101bf0:	f6 00 04             	testb  $0x4,(%eax)
f0101bf3:	0f 85 20 09 00 00    	jne    f0102519 <mem_init+0x1223>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101bf9:	8b 3d 8c 3e 21 f0    	mov    0xf0213e8c,%edi
f0101bff:	ba 00 00 00 00       	mov    $0x0,%edx
f0101c04:	89 f8                	mov    %edi,%eax
f0101c06:	e8 9b ee ff ff       	call   f0100aa6 <check_va2pa>
f0101c0b:	89 c1                	mov    %eax,%ecx
f0101c0d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101c10:	89 d8                	mov    %ebx,%eax
f0101c12:	2b 05 90 3e 21 f0    	sub    0xf0213e90,%eax
f0101c18:	c1 f8 03             	sar    $0x3,%eax
f0101c1b:	c1 e0 0c             	shl    $0xc,%eax
f0101c1e:	39 c1                	cmp    %eax,%ecx
f0101c20:	0f 85 0c 09 00 00    	jne    f0102532 <mem_init+0x123c>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101c26:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c2b:	89 f8                	mov    %edi,%eax
f0101c2d:	e8 74 ee ff ff       	call   f0100aa6 <check_va2pa>
f0101c32:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101c35:	0f 85 10 09 00 00    	jne    f010254b <mem_init+0x1255>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101c3b:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f0101c40:	0f 85 1e 09 00 00    	jne    f0102564 <mem_init+0x126e>
	assert(pp2->pp_ref == 0);
f0101c46:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101c4b:	0f 85 2c 09 00 00    	jne    f010257d <mem_init+0x1287>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101c51:	83 ec 0c             	sub    $0xc,%esp
f0101c54:	6a 00                	push   $0x0
f0101c56:	e8 c4 f2 ff ff       	call   f0100f1f <page_alloc>
f0101c5b:	83 c4 10             	add    $0x10,%esp
f0101c5e:	39 c6                	cmp    %eax,%esi
f0101c60:	0f 85 30 09 00 00    	jne    f0102596 <mem_init+0x12a0>
f0101c66:	85 c0                	test   %eax,%eax
f0101c68:	0f 84 28 09 00 00    	je     f0102596 <mem_init+0x12a0>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101c6e:	83 ec 08             	sub    $0x8,%esp
f0101c71:	6a 00                	push   $0x0
f0101c73:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101c79:	e8 65 f5 ff ff       	call   f01011e3 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101c7e:	8b 3d 8c 3e 21 f0    	mov    0xf0213e8c,%edi
f0101c84:	ba 00 00 00 00       	mov    $0x0,%edx
f0101c89:	89 f8                	mov    %edi,%eax
f0101c8b:	e8 16 ee ff ff       	call   f0100aa6 <check_va2pa>
f0101c90:	83 c4 10             	add    $0x10,%esp
f0101c93:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101c96:	0f 85 13 09 00 00    	jne    f01025af <mem_init+0x12b9>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101c9c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101ca1:	89 f8                	mov    %edi,%eax
f0101ca3:	e8 fe ed ff ff       	call   f0100aa6 <check_va2pa>
f0101ca8:	89 da                	mov    %ebx,%edx
f0101caa:	2b 15 90 3e 21 f0    	sub    0xf0213e90,%edx
f0101cb0:	c1 fa 03             	sar    $0x3,%edx
f0101cb3:	c1 e2 0c             	shl    $0xc,%edx
f0101cb6:	39 d0                	cmp    %edx,%eax
f0101cb8:	0f 85 0a 09 00 00    	jne    f01025c8 <mem_init+0x12d2>
	assert(pp1->pp_ref == 1);
f0101cbe:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101cc3:	0f 85 18 09 00 00    	jne    f01025e1 <mem_init+0x12eb>
	assert(pp2->pp_ref == 0);
f0101cc9:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101cce:	0f 85 26 09 00 00    	jne    f01025fa <mem_init+0x1304>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void *)PGSIZE, 0) == 0);
f0101cd4:	6a 00                	push   $0x0
f0101cd6:	68 00 10 00 00       	push   $0x1000
f0101cdb:	53                   	push   %ebx
f0101cdc:	57                   	push   %edi
f0101cdd:	e8 49 f5 ff ff       	call   f010122b <page_insert>
f0101ce2:	83 c4 10             	add    $0x10,%esp
f0101ce5:	85 c0                	test   %eax,%eax
f0101ce7:	0f 85 26 09 00 00    	jne    f0102613 <mem_init+0x131d>
	assert(pp1->pp_ref);
f0101ced:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101cf2:	0f 84 34 09 00 00    	je     f010262c <mem_init+0x1336>
	assert(pp1->pp_link == NULL);
f0101cf8:	83 3b 00             	cmpl   $0x0,(%ebx)
f0101cfb:	0f 85 44 09 00 00    	jne    f0102645 <mem_init+0x134f>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void *)PGSIZE);
f0101d01:	83 ec 08             	sub    $0x8,%esp
f0101d04:	68 00 10 00 00       	push   $0x1000
f0101d09:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101d0f:	e8 cf f4 ff ff       	call   f01011e3 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101d14:	8b 3d 8c 3e 21 f0    	mov    0xf0213e8c,%edi
f0101d1a:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d1f:	89 f8                	mov    %edi,%eax
f0101d21:	e8 80 ed ff ff       	call   f0100aa6 <check_va2pa>
f0101d26:	83 c4 10             	add    $0x10,%esp
f0101d29:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d2c:	0f 85 2c 09 00 00    	jne    f010265e <mem_init+0x1368>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101d32:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d37:	89 f8                	mov    %edi,%eax
f0101d39:	e8 68 ed ff ff       	call   f0100aa6 <check_va2pa>
f0101d3e:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d41:	0f 85 30 09 00 00    	jne    f0102677 <mem_init+0x1381>
	assert(pp1->pp_ref == 0);
f0101d47:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101d4c:	0f 85 3e 09 00 00    	jne    f0102690 <mem_init+0x139a>
	assert(pp2->pp_ref == 0);
f0101d52:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101d57:	0f 85 4c 09 00 00    	jne    f01026a9 <mem_init+0x13b3>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101d5d:	83 ec 0c             	sub    $0xc,%esp
f0101d60:	6a 00                	push   $0x0
f0101d62:	e8 b8 f1 ff ff       	call   f0100f1f <page_alloc>
f0101d67:	83 c4 10             	add    $0x10,%esp
f0101d6a:	85 c0                	test   %eax,%eax
f0101d6c:	0f 84 50 09 00 00    	je     f01026c2 <mem_init+0x13cc>
f0101d72:	39 c3                	cmp    %eax,%ebx
f0101d74:	0f 85 48 09 00 00    	jne    f01026c2 <mem_init+0x13cc>

	// should be no free memory
	assert(!page_alloc(0));
f0101d7a:	83 ec 0c             	sub    $0xc,%esp
f0101d7d:	6a 00                	push   $0x0
f0101d7f:	e8 9b f1 ff ff       	call   f0100f1f <page_alloc>
f0101d84:	83 c4 10             	add    $0x10,%esp
f0101d87:	85 c0                	test   %eax,%eax
f0101d89:	0f 85 4c 09 00 00    	jne    f01026db <mem_init+0x13e5>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101d8f:	8b 0d 8c 3e 21 f0    	mov    0xf0213e8c,%ecx
f0101d95:	8b 11                	mov    (%ecx),%edx
f0101d97:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101d9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101da0:	2b 05 90 3e 21 f0    	sub    0xf0213e90,%eax
f0101da6:	c1 f8 03             	sar    $0x3,%eax
f0101da9:	c1 e0 0c             	shl    $0xc,%eax
f0101dac:	39 c2                	cmp    %eax,%edx
f0101dae:	0f 85 40 09 00 00    	jne    f01026f4 <mem_init+0x13fe>
	kern_pgdir[0] = 0;
f0101db4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101dba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101dbd:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101dc2:	0f 85 45 09 00 00    	jne    f010270d <mem_init+0x1417>
	pp0->pp_ref = 0;
f0101dc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101dcb:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101dd1:	83 ec 0c             	sub    $0xc,%esp
f0101dd4:	50                   	push   %eax
f0101dd5:	e8 b7 f1 ff ff       	call   f0100f91 <page_free>
	va = (void *)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101dda:	83 c4 0c             	add    $0xc,%esp
f0101ddd:	6a 01                	push   $0x1
f0101ddf:	68 00 10 40 00       	push   $0x401000
f0101de4:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101dea:	e8 06 f2 ff ff       	call   f0100ff5 <pgdir_walk>
f0101def:	89 c7                	mov    %eax,%edi
f0101df1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *)KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101df4:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
f0101df9:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101dfc:	8b 40 04             	mov    0x4(%eax),%eax
f0101dff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101e04:	8b 0d 88 3e 21 f0    	mov    0xf0213e88,%ecx
f0101e0a:	89 c2                	mov    %eax,%edx
f0101e0c:	c1 ea 0c             	shr    $0xc,%edx
f0101e0f:	83 c4 10             	add    $0x10,%esp
f0101e12:	39 ca                	cmp    %ecx,%edx
f0101e14:	0f 83 0c 09 00 00    	jae    f0102726 <mem_init+0x1430>
	assert(ptep == ptep1 + PTX(va));
f0101e1a:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f0101e1f:	39 c7                	cmp    %eax,%edi
f0101e21:	0f 85 14 09 00 00    	jne    f010273b <mem_init+0x1445>
	kern_pgdir[PDX(va)] = 0;
f0101e27:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101e2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f0101e31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e34:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101e3a:	2b 05 90 3e 21 f0    	sub    0xf0213e90,%eax
f0101e40:	c1 f8 03             	sar    $0x3,%eax
f0101e43:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101e46:	89 c2                	mov    %eax,%edx
f0101e48:	c1 ea 0c             	shr    $0xc,%edx
f0101e4b:	39 d1                	cmp    %edx,%ecx
f0101e4d:	0f 86 01 09 00 00    	jbe    f0102754 <mem_init+0x145e>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0101e53:	83 ec 04             	sub    $0x4,%esp
f0101e56:	68 00 10 00 00       	push   $0x1000
f0101e5b:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0101e60:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101e65:	50                   	push   %eax
f0101e66:	e8 47 37 00 00       	call   f01055b2 <memset>
	page_free(pp0);
f0101e6b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0101e6e:	89 3c 24             	mov    %edi,(%esp)
f0101e71:	e8 1b f1 ff ff       	call   f0100f91 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0101e76:	83 c4 0c             	add    $0xc,%esp
f0101e79:	6a 01                	push   $0x1
f0101e7b:	6a 00                	push   $0x0
f0101e7d:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101e83:	e8 6d f1 ff ff       	call   f0100ff5 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0101e88:	89 fa                	mov    %edi,%edx
f0101e8a:	2b 15 90 3e 21 f0    	sub    0xf0213e90,%edx
f0101e90:	c1 fa 03             	sar    $0x3,%edx
f0101e93:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101e96:	89 d0                	mov    %edx,%eax
f0101e98:	c1 e8 0c             	shr    $0xc,%eax
f0101e9b:	83 c4 10             	add    $0x10,%esp
f0101e9e:	3b 05 88 3e 21 f0    	cmp    0xf0213e88,%eax
f0101ea4:	0f 83 bc 08 00 00    	jae    f0102766 <mem_init+0x1470>
	return (void *)(pa + KERNBASE);
f0101eaa:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *)page2kva(pp0);
f0101eb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101eb3:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for (i = 0; i < NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0101eb9:	f6 00 01             	testb  $0x1,(%eax)
f0101ebc:	0f 85 b6 08 00 00    	jne    f0102778 <mem_init+0x1482>
f0101ec2:	83 c0 04             	add    $0x4,%eax
	for (i = 0; i < NPTENTRIES; i++)
f0101ec5:	39 d0                	cmp    %edx,%eax
f0101ec7:	75 f0                	jne    f0101eb9 <mem_init+0xbc3>
	kern_pgdir[0] = 0;
f0101ec9:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
f0101ece:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0101ed4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ed7:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0101edd:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101ee0:	89 0d 40 32 21 f0    	mov    %ecx,0xf0213240

	// free the pages we took
	page_free(pp0);
f0101ee6:	83 ec 0c             	sub    $0xc,%esp
f0101ee9:	50                   	push   %eax
f0101eea:	e8 a2 f0 ff ff       	call   f0100f91 <page_free>
	page_free(pp1);
f0101eef:	89 1c 24             	mov    %ebx,(%esp)
f0101ef2:	e8 9a f0 ff ff       	call   f0100f91 <page_free>
	page_free(pp2);
f0101ef7:	89 34 24             	mov    %esi,(%esp)
f0101efa:	e8 92 f0 ff ff       	call   f0100f91 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0101eff:	83 c4 08             	add    $0x8,%esp
f0101f02:	68 01 10 00 00       	push   $0x1001
f0101f07:	6a 00                	push   $0x0
f0101f09:	e8 85 f3 ff ff       	call   f0101293 <mmio_map_region>
f0101f0e:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0101f10:	83 c4 08             	add    $0x8,%esp
f0101f13:	68 00 10 00 00       	push   $0x1000
f0101f18:	6a 00                	push   $0x0
f0101f1a:	e8 74 f3 ff ff       	call   f0101293 <mmio_map_region>
f0101f1f:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0101f21:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0101f27:	83 c4 10             	add    $0x10,%esp
f0101f2a:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0101f30:	0f 86 5b 08 00 00    	jbe    f0102791 <mem_init+0x149b>
f0101f36:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0101f3b:	0f 87 50 08 00 00    	ja     f0102791 <mem_init+0x149b>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0101f41:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0101f47:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0101f4d:	0f 87 57 08 00 00    	ja     f01027aa <mem_init+0x14b4>
f0101f53:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0101f59:	0f 86 4b 08 00 00    	jbe    f01027aa <mem_init+0x14b4>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0101f5f:	89 da                	mov    %ebx,%edx
f0101f61:	09 f2                	or     %esi,%edx
f0101f63:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0101f69:	0f 85 54 08 00 00    	jne    f01027c3 <mem_init+0x14cd>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f0101f6f:	39 c6                	cmp    %eax,%esi
f0101f71:	0f 82 65 08 00 00    	jb     f01027dc <mem_init+0x14e6>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0101f77:	8b 3d 8c 3e 21 f0    	mov    0xf0213e8c,%edi
f0101f7d:	89 da                	mov    %ebx,%edx
f0101f7f:	89 f8                	mov    %edi,%eax
f0101f81:	e8 20 eb ff ff       	call   f0100aa6 <check_va2pa>
f0101f86:	85 c0                	test   %eax,%eax
f0101f88:	0f 85 67 08 00 00    	jne    f01027f5 <mem_init+0x14ff>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0101f8e:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0101f94:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101f97:	89 c2                	mov    %eax,%edx
f0101f99:	89 f8                	mov    %edi,%eax
f0101f9b:	e8 06 eb ff ff       	call   f0100aa6 <check_va2pa>
f0101fa0:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0101fa5:	0f 85 63 08 00 00    	jne    f010280e <mem_init+0x1518>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0101fab:	89 f2                	mov    %esi,%edx
f0101fad:	89 f8                	mov    %edi,%eax
f0101faf:	e8 f2 ea ff ff       	call   f0100aa6 <check_va2pa>
f0101fb4:	85 c0                	test   %eax,%eax
f0101fb6:	0f 85 6b 08 00 00    	jne    f0102827 <mem_init+0x1531>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0101fbc:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0101fc2:	89 f8                	mov    %edi,%eax
f0101fc4:	e8 dd ea ff ff       	call   f0100aa6 <check_va2pa>
f0101fc9:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101fcc:	0f 85 6e 08 00 00    	jne    f0102840 <mem_init+0x154a>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0101fd2:	83 ec 04             	sub    $0x4,%esp
f0101fd5:	6a 00                	push   $0x0
f0101fd7:	53                   	push   %ebx
f0101fd8:	57                   	push   %edi
f0101fd9:	e8 17 f0 ff ff       	call   f0100ff5 <pgdir_walk>
f0101fde:	83 c4 10             	add    $0x10,%esp
f0101fe1:	f6 00 1a             	testb  $0x1a,(%eax)
f0101fe4:	0f 84 6f 08 00 00    	je     f0102859 <mem_init+0x1563>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0101fea:	83 ec 04             	sub    $0x4,%esp
f0101fed:	6a 00                	push   $0x0
f0101fef:	53                   	push   %ebx
f0101ff0:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0101ff6:	e8 fa ef ff ff       	call   f0100ff5 <pgdir_walk>
f0101ffb:	83 c4 10             	add    $0x10,%esp
f0101ffe:	f6 00 04             	testb  $0x4,(%eax)
f0102001:	0f 85 6b 08 00 00    	jne    f0102872 <mem_init+0x157c>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102007:	83 ec 04             	sub    $0x4,%esp
f010200a:	6a 00                	push   $0x0
f010200c:	53                   	push   %ebx
f010200d:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0102013:	e8 dd ef ff ff       	call   f0100ff5 <pgdir_walk>
f0102018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f010201e:	83 c4 0c             	add    $0xc,%esp
f0102021:	6a 00                	push   $0x0
f0102023:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102026:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f010202c:	e8 c4 ef ff ff       	call   f0100ff5 <pgdir_walk>
f0102031:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102037:	83 c4 0c             	add    $0xc,%esp
f010203a:	6a 00                	push   $0x0
f010203c:	56                   	push   %esi
f010203d:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0102043:	e8 ad ef ff ff       	call   f0100ff5 <pgdir_walk>
f0102048:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f010204e:	c7 04 24 ee 69 10 f0 	movl   $0xf01069ee,(%esp)
f0102055:	e8 b9 18 00 00       	call   f0103913 <cprintf>
	boot_map_region(kern_pgdir, (uintptr_t)UPAGES, npages * sizeof(struct PageInfo), PADDR(pages), PTE_U);
f010205a:	a1 90 3e 21 f0       	mov    0xf0213e90,%eax
	if ((uint32_t)kva < KERNBASE)
f010205f:	83 c4 10             	add    $0x10,%esp
f0102062:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102067:	0f 86 1e 08 00 00    	jbe    f010288b <mem_init+0x1595>
f010206d:	8b 0d 88 3e 21 f0    	mov    0xf0213e88,%ecx
f0102073:	c1 e1 03             	shl    $0x3,%ecx
f0102076:	83 ec 08             	sub    $0x8,%esp
f0102079:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f010207b:	05 00 00 00 10       	add    $0x10000000,%eax
f0102080:	50                   	push   %eax
f0102081:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102086:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
f010208b:	e8 49 f0 ff ff       	call   f01010d9 <boot_map_region>
	boot_map_region(kern_pgdir, (uintptr_t)UENVS, ROUNDUP(NENV * sizeof(struct Env), PGSIZE), PADDR(envs), PTE_U | PTE_P);
f0102090:	a1 44 32 21 f0       	mov    0xf0213244,%eax
	if ((uint32_t)kva < KERNBASE)
f0102095:	83 c4 10             	add    $0x10,%esp
f0102098:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010209d:	0f 86 fd 07 00 00    	jbe    f01028a0 <mem_init+0x15aa>
f01020a3:	83 ec 08             	sub    $0x8,%esp
f01020a6:	6a 05                	push   $0x5
	return (physaddr_t)kva - KERNBASE;
f01020a8:	05 00 00 00 10       	add    $0x10000000,%eax
f01020ad:	50                   	push   %eax
f01020ae:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f01020b3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01020b8:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
f01020bd:	e8 17 f0 ff ff       	call   f01010d9 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f01020c2:	83 c4 10             	add    $0x10,%esp
f01020c5:	b8 00 70 11 f0       	mov    $0xf0117000,%eax
f01020ca:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01020cf:	0f 86 e0 07 00 00    	jbe    f01028b5 <mem_init+0x15bf>
	boot_map_region(kern_pgdir, (uintptr_t)(KSTACKTOP - KSTKSIZE), KSTKSIZE, PADDR(bootstack), PTE_W | PTE_P);
f01020d5:	83 ec 08             	sub    $0x8,%esp
f01020d8:	6a 03                	push   $0x3
f01020da:	68 00 70 11 00       	push   $0x117000
f01020df:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01020e4:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01020e9:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
f01020ee:	e8 e6 ef ff ff       	call   f01010d9 <boot_map_region>
	boot_map_region(kern_pgdir, (uintptr_t)KERNBASE, ROUNDUP(0xffffffff - KERNBASE, PGSIZE), 0, PTE_W | PTE_P);
f01020f3:	83 c4 08             	add    $0x8,%esp
f01020f6:	6a 03                	push   $0x3
f01020f8:	6a 00                	push   $0x0
f01020fa:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f01020ff:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102104:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
f0102109:	e8 cb ef ff ff       	call   f01010d9 <boot_map_region>
f010210e:	c7 45 cc 00 50 21 f0 	movl   $0xf0215000,-0x34(%ebp)
f0102115:	83 c4 10             	add    $0x10,%esp
f0102118:	bb 00 50 21 f0       	mov    $0xf0215000,%ebx
	uintptr_t start_addr = KSTACKTOP - KSTKSIZE;
f010211d:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102122:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102128:	0f 86 9c 07 00 00    	jbe    f01028ca <mem_init+0x15d4>
		boot_map_region(kern_pgdir, (uintptr_t)start_addr, KSTKSIZE, PADDR(percpu_kstacks[i]), PTE_W | PTE_P);
f010212e:	83 ec 08             	sub    $0x8,%esp
f0102131:	6a 03                	push   $0x3
f0102133:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0102139:	50                   	push   %eax
f010213a:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010213f:	89 f2                	mov    %esi,%edx
f0102141:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
f0102146:	e8 8e ef ff ff       	call   f01010d9 <boot_map_region>
		start_addr -= KSTKSIZE + KSTKGAP;
f010214b:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102151:	81 c3 00 80 00 00    	add    $0x8000,%ebx
	for (size_t i = 0; i < NCPU; i++)
f0102157:	83 c4 10             	add    $0x10,%esp
f010215a:	81 fe 00 80 f7 ef    	cmp    $0xeff78000,%esi
f0102160:	75 c0                	jne    f0102122 <mem_init+0xe2c>
	pgdir = kern_pgdir;
f0102162:	8b 3d 8c 3e 21 f0    	mov    0xf0213e8c,%edi
	n = ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE);
f0102168:	a1 88 3e 21 f0       	mov    0xf0213e88,%eax
f010216d:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0102170:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102177:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010217c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010217f:	a1 90 3e 21 f0       	mov    0xf0213e90,%eax
f0102184:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102187:	89 45 d0             	mov    %eax,-0x30(%ebp)
	return (physaddr_t)kva - KERNBASE;
f010218a:	8d b0 00 00 00 10    	lea    0x10000000(%eax),%esi
	for (i = 0; i < n; i += PGSIZE)
f0102190:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102195:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0102198:	0f 86 71 07 00 00    	jbe    f010290f <mem_init+0x1619>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010219e:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f01021a4:	89 f8                	mov    %edi,%eax
f01021a6:	e8 fb e8 ff ff       	call   f0100aa6 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01021ab:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f01021b2:	0f 86 27 07 00 00    	jbe    f01028df <mem_init+0x15e9>
f01021b8:	8d 14 33             	lea    (%ebx,%esi,1),%edx
f01021bb:	39 d0                	cmp    %edx,%eax
f01021bd:	0f 85 33 07 00 00    	jne    f01028f6 <mem_init+0x1600>
	for (i = 0; i < n; i += PGSIZE)
f01021c3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01021c9:	eb ca                	jmp    f0102195 <mem_init+0xe9f>
	assert(nfree == 0);
f01021cb:	68 05 69 10 f0       	push   $0xf0106905
f01021d0:	68 91 67 10 f0       	push   $0xf0106791
f01021d5:	68 46 03 00 00       	push   $0x346
f01021da:	68 6b 67 10 f0       	push   $0xf010676b
f01021df:	e8 5c de ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f01021e4:	68 6a 68 10 f0       	push   $0xf010686a
f01021e9:	68 91 67 10 f0       	push   $0xf0106791
f01021ee:	68 b2 03 00 00       	push   $0x3b2
f01021f3:	68 6b 67 10 f0       	push   $0xf010676b
f01021f8:	e8 43 de ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01021fd:	68 80 68 10 f0       	push   $0xf0106880
f0102202:	68 91 67 10 f0       	push   $0xf0106791
f0102207:	68 b3 03 00 00       	push   $0x3b3
f010220c:	68 6b 67 10 f0       	push   $0xf010676b
f0102211:	e8 2a de ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102216:	68 96 68 10 f0       	push   $0xf0106896
f010221b:	68 91 67 10 f0       	push   $0xf0106791
f0102220:	68 b4 03 00 00       	push   $0x3b4
f0102225:	68 6b 67 10 f0       	push   $0xf010676b
f010222a:	e8 11 de ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f010222f:	68 ac 68 10 f0       	push   $0xf01068ac
f0102234:	68 91 67 10 f0       	push   $0xf0106791
f0102239:	68 b7 03 00 00       	push   $0x3b7
f010223e:	68 6b 67 10 f0       	push   $0xf010676b
f0102243:	e8 f8 dd ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102248:	68 c0 6b 10 f0       	push   $0xf0106bc0
f010224d:	68 91 67 10 f0       	push   $0xf0106791
f0102252:	68 b8 03 00 00       	push   $0x3b8
f0102257:	68 6b 67 10 f0       	push   $0xf010676b
f010225c:	e8 df dd ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102261:	68 be 68 10 f0       	push   $0xf01068be
f0102266:	68 91 67 10 f0       	push   $0xf0106791
f010226b:	68 bf 03 00 00       	push   $0x3bf
f0102270:	68 6b 67 10 f0       	push   $0xf010676b
f0102275:	e8 c6 dd ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *)0x0, &ptep) == NULL);
f010227a:	68 60 6c 10 f0       	push   $0xf0106c60
f010227f:	68 91 67 10 f0       	push   $0xf0106791
f0102284:	68 c2 03 00 00       	push   $0x3c2
f0102289:	68 6b 67 10 f0       	push   $0xf010676b
f010228e:	e8 ad dd ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102293:	68 94 6c 10 f0       	push   $0xf0106c94
f0102298:	68 91 67 10 f0       	push   $0xf0106791
f010229d:	68 c5 03 00 00       	push   $0x3c5
f01022a2:	68 6b 67 10 f0       	push   $0xf010676b
f01022a7:	e8 94 dd ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01022ac:	68 c4 6c 10 f0       	push   $0xf0106cc4
f01022b1:	68 91 67 10 f0       	push   $0xf0106791
f01022b6:	68 c9 03 00 00       	push   $0x3c9
f01022bb:	68 6b 67 10 f0       	push   $0xf010676b
f01022c0:	e8 7b dd ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01022c5:	68 f4 6c 10 f0       	push   $0xf0106cf4
f01022ca:	68 91 67 10 f0       	push   $0xf0106791
f01022cf:	68 ca 03 00 00       	push   $0x3ca
f01022d4:	68 6b 67 10 f0       	push   $0xf010676b
f01022d9:	e8 62 dd ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01022de:	68 1c 6d 10 f0       	push   $0xf0106d1c
f01022e3:	68 91 67 10 f0       	push   $0xf0106791
f01022e8:	68 cb 03 00 00       	push   $0x3cb
f01022ed:	68 6b 67 10 f0       	push   $0xf010676b
f01022f2:	e8 49 dd ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01022f7:	68 10 69 10 f0       	push   $0xf0106910
f01022fc:	68 91 67 10 f0       	push   $0xf0106791
f0102301:	68 cc 03 00 00       	push   $0x3cc
f0102306:	68 6b 67 10 f0       	push   $0xf010676b
f010230b:	e8 30 dd ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102310:	68 21 69 10 f0       	push   $0xf0106921
f0102315:	68 91 67 10 f0       	push   $0xf0106791
f010231a:	68 cd 03 00 00       	push   $0x3cd
f010231f:	68 6b 67 10 f0       	push   $0xf010676b
f0102324:	e8 17 dd ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W) == 0);
f0102329:	68 4c 6d 10 f0       	push   $0xf0106d4c
f010232e:	68 91 67 10 f0       	push   $0xf0106791
f0102333:	68 d0 03 00 00       	push   $0x3d0
f0102338:	68 6b 67 10 f0       	push   $0xf010676b
f010233d:	e8 fe dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102342:	68 88 6d 10 f0       	push   $0xf0106d88
f0102347:	68 91 67 10 f0       	push   $0xf0106791
f010234c:	68 d1 03 00 00       	push   $0x3d1
f0102351:	68 6b 67 10 f0       	push   $0xf010676b
f0102356:	e8 e5 dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010235b:	68 32 69 10 f0       	push   $0xf0106932
f0102360:	68 91 67 10 f0       	push   $0xf0106791
f0102365:	68 d2 03 00 00       	push   $0x3d2
f010236a:	68 6b 67 10 f0       	push   $0xf010676b
f010236f:	e8 cc dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102374:	68 be 68 10 f0       	push   $0xf01068be
f0102379:	68 91 67 10 f0       	push   $0xf0106791
f010237e:	68 d5 03 00 00       	push   $0x3d5
f0102383:	68 6b 67 10 f0       	push   $0xf010676b
f0102388:	e8 b3 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W) == 0);
f010238d:	68 4c 6d 10 f0       	push   $0xf0106d4c
f0102392:	68 91 67 10 f0       	push   $0xf0106791
f0102397:	68 d8 03 00 00       	push   $0x3d8
f010239c:	68 6b 67 10 f0       	push   $0xf010676b
f01023a1:	e8 9a dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01023a6:	68 88 6d 10 f0       	push   $0xf0106d88
f01023ab:	68 91 67 10 f0       	push   $0xf0106791
f01023b0:	68 d9 03 00 00       	push   $0x3d9
f01023b5:	68 6b 67 10 f0       	push   $0xf010676b
f01023ba:	e8 81 dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01023bf:	68 32 69 10 f0       	push   $0xf0106932
f01023c4:	68 91 67 10 f0       	push   $0xf0106791
f01023c9:	68 da 03 00 00       	push   $0x3da
f01023ce:	68 6b 67 10 f0       	push   $0xf010676b
f01023d3:	e8 68 dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01023d8:	68 be 68 10 f0       	push   $0xf01068be
f01023dd:	68 91 67 10 f0       	push   $0xf0106791
f01023e2:	68 de 03 00 00       	push   $0x3de
f01023e7:	68 6b 67 10 f0       	push   $0xf010676b
f01023ec:	e8 4f dc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01023f1:	50                   	push   %eax
f01023f2:	68 44 62 10 f0       	push   $0xf0106244
f01023f7:	68 e1 03 00 00       	push   $0x3e1
f01023fc:	68 6b 67 10 f0       	push   $0xf010676b
f0102401:	e8 3a dc ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) == ptep + PTX(PGSIZE));
f0102406:	68 b8 6d 10 f0       	push   $0xf0106db8
f010240b:	68 91 67 10 f0       	push   $0xf0106791
f0102410:	68 e2 03 00 00       	push   $0x3e2
f0102415:	68 6b 67 10 f0       	push   $0xf010676b
f010241a:	e8 21 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W | PTE_U) == 0);
f010241f:	68 f8 6d 10 f0       	push   $0xf0106df8
f0102424:	68 91 67 10 f0       	push   $0xf0106791
f0102429:	68 e5 03 00 00       	push   $0x3e5
f010242e:	68 6b 67 10 f0       	push   $0xf010676b
f0102433:	e8 08 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102438:	68 88 6d 10 f0       	push   $0xf0106d88
f010243d:	68 91 67 10 f0       	push   $0xf0106791
f0102442:	68 e6 03 00 00       	push   $0x3e6
f0102447:	68 6b 67 10 f0       	push   $0xf010676b
f010244c:	e8 ef db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102451:	68 32 69 10 f0       	push   $0xf0106932
f0102456:	68 91 67 10 f0       	push   $0xf0106791
f010245b:	68 e7 03 00 00       	push   $0x3e7
f0102460:	68 6b 67 10 f0       	push   $0xf010676b
f0102465:	e8 d6 db ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_U);
f010246a:	68 3c 6e 10 f0       	push   $0xf0106e3c
f010246f:	68 91 67 10 f0       	push   $0xf0106791
f0102474:	68 e8 03 00 00       	push   $0x3e8
f0102479:	68 6b 67 10 f0       	push   $0xf010676b
f010247e:	e8 bd db ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102483:	68 43 69 10 f0       	push   $0xf0106943
f0102488:	68 91 67 10 f0       	push   $0xf0106791
f010248d:	68 e9 03 00 00       	push   $0x3e9
f0102492:	68 6b 67 10 f0       	push   $0xf010676b
f0102497:	e8 a4 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W) == 0);
f010249c:	68 4c 6d 10 f0       	push   $0xf0106d4c
f01024a1:	68 91 67 10 f0       	push   $0xf0106791
f01024a6:	68 ec 03 00 00       	push   $0x3ec
f01024ab:	68 6b 67 10 f0       	push   $0xf010676b
f01024b0:	e8 8b db ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_W);
f01024b5:	68 70 6e 10 f0       	push   $0xf0106e70
f01024ba:	68 91 67 10 f0       	push   $0xf0106791
f01024bf:	68 ed 03 00 00       	push   $0x3ed
f01024c4:	68 6b 67 10 f0       	push   $0xf010676b
f01024c9:	e8 72 db ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_U));
f01024ce:	68 a4 6e 10 f0       	push   $0xf0106ea4
f01024d3:	68 91 67 10 f0       	push   $0xf0106791
f01024d8:	68 ee 03 00 00       	push   $0x3ee
f01024dd:	68 6b 67 10 f0       	push   $0xf010676b
f01024e2:	e8 59 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void *)PTSIZE, PTE_W) < 0);
f01024e7:	68 dc 6e 10 f0       	push   $0xf0106edc
f01024ec:	68 91 67 10 f0       	push   $0xf0106791
f01024f1:	68 f1 03 00 00       	push   $0x3f1
f01024f6:	68 6b 67 10 f0       	push   $0xf010676b
f01024fb:	e8 40 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void *)PGSIZE, PTE_W) == 0);
f0102500:	68 14 6f 10 f0       	push   $0xf0106f14
f0102505:	68 91 67 10 f0       	push   $0xf0106791
f010250a:	68 f4 03 00 00       	push   $0x3f4
f010250f:	68 6b 67 10 f0       	push   $0xf010676b
f0102514:	e8 27 db ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_U));
f0102519:	68 a4 6e 10 f0       	push   $0xf0106ea4
f010251e:	68 91 67 10 f0       	push   $0xf0106791
f0102523:	68 f5 03 00 00       	push   $0x3f5
f0102528:	68 6b 67 10 f0       	push   $0xf010676b
f010252d:	e8 0e db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102532:	68 50 6f 10 f0       	push   $0xf0106f50
f0102537:	68 91 67 10 f0       	push   $0xf0106791
f010253c:	68 f8 03 00 00       	push   $0x3f8
f0102541:	68 6b 67 10 f0       	push   $0xf010676b
f0102546:	e8 f5 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010254b:	68 7c 6f 10 f0       	push   $0xf0106f7c
f0102550:	68 91 67 10 f0       	push   $0xf0106791
f0102555:	68 f9 03 00 00       	push   $0x3f9
f010255a:	68 6b 67 10 f0       	push   $0xf010676b
f010255f:	e8 dc da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f0102564:	68 59 69 10 f0       	push   $0xf0106959
f0102569:	68 91 67 10 f0       	push   $0xf0106791
f010256e:	68 fb 03 00 00       	push   $0x3fb
f0102573:	68 6b 67 10 f0       	push   $0xf010676b
f0102578:	e8 c3 da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f010257d:	68 6a 69 10 f0       	push   $0xf010696a
f0102582:	68 91 67 10 f0       	push   $0xf0106791
f0102587:	68 fc 03 00 00       	push   $0x3fc
f010258c:	68 6b 67 10 f0       	push   $0xf010676b
f0102591:	e8 aa da ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f0102596:	68 ac 6f 10 f0       	push   $0xf0106fac
f010259b:	68 91 67 10 f0       	push   $0xf0106791
f01025a0:	68 ff 03 00 00       	push   $0x3ff
f01025a5:	68 6b 67 10 f0       	push   $0xf010676b
f01025aa:	e8 91 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01025af:	68 d0 6f 10 f0       	push   $0xf0106fd0
f01025b4:	68 91 67 10 f0       	push   $0xf0106791
f01025b9:	68 03 04 00 00       	push   $0x403
f01025be:	68 6b 67 10 f0       	push   $0xf010676b
f01025c3:	e8 78 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01025c8:	68 7c 6f 10 f0       	push   $0xf0106f7c
f01025cd:	68 91 67 10 f0       	push   $0xf0106791
f01025d2:	68 04 04 00 00       	push   $0x404
f01025d7:	68 6b 67 10 f0       	push   $0xf010676b
f01025dc:	e8 5f da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01025e1:	68 10 69 10 f0       	push   $0xf0106910
f01025e6:	68 91 67 10 f0       	push   $0xf0106791
f01025eb:	68 05 04 00 00       	push   $0x405
f01025f0:	68 6b 67 10 f0       	push   $0xf010676b
f01025f5:	e8 46 da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01025fa:	68 6a 69 10 f0       	push   $0xf010696a
f01025ff:	68 91 67 10 f0       	push   $0xf0106791
f0102604:	68 06 04 00 00       	push   $0x406
f0102609:	68 6b 67 10 f0       	push   $0xf010676b
f010260e:	e8 2d da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void *)PGSIZE, 0) == 0);
f0102613:	68 f4 6f 10 f0       	push   $0xf0106ff4
f0102618:	68 91 67 10 f0       	push   $0xf0106791
f010261d:	68 09 04 00 00       	push   $0x409
f0102622:	68 6b 67 10 f0       	push   $0xf010676b
f0102627:	e8 14 da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f010262c:	68 7b 69 10 f0       	push   $0xf010697b
f0102631:	68 91 67 10 f0       	push   $0xf0106791
f0102636:	68 0a 04 00 00       	push   $0x40a
f010263b:	68 6b 67 10 f0       	push   $0xf010676b
f0102640:	e8 fb d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f0102645:	68 87 69 10 f0       	push   $0xf0106987
f010264a:	68 91 67 10 f0       	push   $0xf0106791
f010264f:	68 0b 04 00 00       	push   $0x40b
f0102654:	68 6b 67 10 f0       	push   $0xf010676b
f0102659:	e8 e2 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010265e:	68 d0 6f 10 f0       	push   $0xf0106fd0
f0102663:	68 91 67 10 f0       	push   $0xf0106791
f0102668:	68 0f 04 00 00       	push   $0x40f
f010266d:	68 6b 67 10 f0       	push   $0xf010676b
f0102672:	e8 c9 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102677:	68 2c 70 10 f0       	push   $0xf010702c
f010267c:	68 91 67 10 f0       	push   $0xf0106791
f0102681:	68 10 04 00 00       	push   $0x410
f0102686:	68 6b 67 10 f0       	push   $0xf010676b
f010268b:	e8 b0 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102690:	68 9c 69 10 f0       	push   $0xf010699c
f0102695:	68 91 67 10 f0       	push   $0xf0106791
f010269a:	68 11 04 00 00       	push   $0x411
f010269f:	68 6b 67 10 f0       	push   $0xf010676b
f01026a4:	e8 97 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01026a9:	68 6a 69 10 f0       	push   $0xf010696a
f01026ae:	68 91 67 10 f0       	push   $0xf0106791
f01026b3:	68 12 04 00 00       	push   $0x412
f01026b8:	68 6b 67 10 f0       	push   $0xf010676b
f01026bd:	e8 7e d9 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f01026c2:	68 54 70 10 f0       	push   $0xf0107054
f01026c7:	68 91 67 10 f0       	push   $0xf0106791
f01026cc:	68 15 04 00 00       	push   $0x415
f01026d1:	68 6b 67 10 f0       	push   $0xf010676b
f01026d6:	e8 65 d9 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01026db:	68 be 68 10 f0       	push   $0xf01068be
f01026e0:	68 91 67 10 f0       	push   $0xf0106791
f01026e5:	68 18 04 00 00       	push   $0x418
f01026ea:	68 6b 67 10 f0       	push   $0xf010676b
f01026ef:	e8 4c d9 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01026f4:	68 f4 6c 10 f0       	push   $0xf0106cf4
f01026f9:	68 91 67 10 f0       	push   $0xf0106791
f01026fe:	68 1b 04 00 00       	push   $0x41b
f0102703:	68 6b 67 10 f0       	push   $0xf010676b
f0102708:	e8 33 d9 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f010270d:	68 21 69 10 f0       	push   $0xf0106921
f0102712:	68 91 67 10 f0       	push   $0xf0106791
f0102717:	68 1d 04 00 00       	push   $0x41d
f010271c:	68 6b 67 10 f0       	push   $0xf010676b
f0102721:	e8 1a d9 ff ff       	call   f0100040 <_panic>
f0102726:	50                   	push   %eax
f0102727:	68 44 62 10 f0       	push   $0xf0106244
f010272c:	68 24 04 00 00       	push   $0x424
f0102731:	68 6b 67 10 f0       	push   $0xf010676b
f0102736:	e8 05 d9 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f010273b:	68 ad 69 10 f0       	push   $0xf01069ad
f0102740:	68 91 67 10 f0       	push   $0xf0106791
f0102745:	68 25 04 00 00       	push   $0x425
f010274a:	68 6b 67 10 f0       	push   $0xf010676b
f010274f:	e8 ec d8 ff ff       	call   f0100040 <_panic>
f0102754:	50                   	push   %eax
f0102755:	68 44 62 10 f0       	push   $0xf0106244
f010275a:	6a 58                	push   $0x58
f010275c:	68 77 67 10 f0       	push   $0xf0106777
f0102761:	e8 da d8 ff ff       	call   f0100040 <_panic>
f0102766:	52                   	push   %edx
f0102767:	68 44 62 10 f0       	push   $0xf0106244
f010276c:	6a 58                	push   $0x58
f010276e:	68 77 67 10 f0       	push   $0xf0106777
f0102773:	e8 c8 d8 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102778:	68 c5 69 10 f0       	push   $0xf01069c5
f010277d:	68 91 67 10 f0       	push   $0xf0106791
f0102782:	68 2f 04 00 00       	push   $0x42f
f0102787:	68 6b 67 10 f0       	push   $0xf010676b
f010278c:	e8 af d8 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102791:	68 78 70 10 f0       	push   $0xf0107078
f0102796:	68 91 67 10 f0       	push   $0xf0106791
f010279b:	68 3f 04 00 00       	push   $0x43f
f01027a0:	68 6b 67 10 f0       	push   $0xf010676b
f01027a5:	e8 96 d8 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f01027aa:	68 a0 70 10 f0       	push   $0xf01070a0
f01027af:	68 91 67 10 f0       	push   $0xf0106791
f01027b4:	68 40 04 00 00       	push   $0x440
f01027b9:	68 6b 67 10 f0       	push   $0xf010676b
f01027be:	e8 7d d8 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f01027c3:	68 c8 70 10 f0       	push   $0xf01070c8
f01027c8:	68 91 67 10 f0       	push   $0xf0106791
f01027cd:	68 42 04 00 00       	push   $0x442
f01027d2:	68 6b 67 10 f0       	push   $0xf010676b
f01027d7:	e8 64 d8 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f01027dc:	68 dc 69 10 f0       	push   $0xf01069dc
f01027e1:	68 91 67 10 f0       	push   $0xf0106791
f01027e6:	68 44 04 00 00       	push   $0x444
f01027eb:	68 6b 67 10 f0       	push   $0xf010676b
f01027f0:	e8 4b d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01027f5:	68 f0 70 10 f0       	push   $0xf01070f0
f01027fa:	68 91 67 10 f0       	push   $0xf0106791
f01027ff:	68 46 04 00 00       	push   $0x446
f0102804:	68 6b 67 10 f0       	push   $0xf010676b
f0102809:	e8 32 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f010280e:	68 14 71 10 f0       	push   $0xf0107114
f0102813:	68 91 67 10 f0       	push   $0xf0106791
f0102818:	68 47 04 00 00       	push   $0x447
f010281d:	68 6b 67 10 f0       	push   $0xf010676b
f0102822:	e8 19 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102827:	68 44 71 10 f0       	push   $0xf0107144
f010282c:	68 91 67 10 f0       	push   $0xf0106791
f0102831:	68 48 04 00 00       	push   $0x448
f0102836:	68 6b 67 10 f0       	push   $0xf010676b
f010283b:	e8 00 d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102840:	68 68 71 10 f0       	push   $0xf0107168
f0102845:	68 91 67 10 f0       	push   $0xf0106791
f010284a:	68 49 04 00 00       	push   $0x449
f010284f:	68 6b 67 10 f0       	push   $0xf010676b
f0102854:	e8 e7 d7 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102859:	68 94 71 10 f0       	push   $0xf0107194
f010285e:	68 91 67 10 f0       	push   $0xf0106791
f0102863:	68 4b 04 00 00       	push   $0x44b
f0102868:	68 6b 67 10 f0       	push   $0xf010676b
f010286d:	e8 ce d7 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102872:	68 d8 71 10 f0       	push   $0xf01071d8
f0102877:	68 91 67 10 f0       	push   $0xf0106791
f010287c:	68 4c 04 00 00       	push   $0x44c
f0102881:	68 6b 67 10 f0       	push   $0xf010676b
f0102886:	e8 b5 d7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010288b:	50                   	push   %eax
f010288c:	68 68 62 10 f0       	push   $0xf0106268
f0102891:	68 c1 00 00 00       	push   $0xc1
f0102896:	68 6b 67 10 f0       	push   $0xf010676b
f010289b:	e8 a0 d7 ff ff       	call   f0100040 <_panic>
f01028a0:	50                   	push   %eax
f01028a1:	68 68 62 10 f0       	push   $0xf0106268
f01028a6:	68 c9 00 00 00       	push   $0xc9
f01028ab:	68 6b 67 10 f0       	push   $0xf010676b
f01028b0:	e8 8b d7 ff ff       	call   f0100040 <_panic>
f01028b5:	50                   	push   %eax
f01028b6:	68 68 62 10 f0       	push   $0xf0106268
f01028bb:	68 d5 00 00 00       	push   $0xd5
f01028c0:	68 6b 67 10 f0       	push   $0xf010676b
f01028c5:	e8 76 d7 ff ff       	call   f0100040 <_panic>
f01028ca:	53                   	push   %ebx
f01028cb:	68 68 62 10 f0       	push   $0xf0106268
f01028d0:	68 04 01 00 00       	push   $0x104
f01028d5:	68 6b 67 10 f0       	push   $0xf010676b
f01028da:	e8 61 d7 ff ff       	call   f0100040 <_panic>
f01028df:	ff 75 c4             	pushl  -0x3c(%ebp)
f01028e2:	68 68 62 10 f0       	push   $0xf0106268
f01028e7:	68 5e 03 00 00       	push   $0x35e
f01028ec:	68 6b 67 10 f0       	push   $0xf010676b
f01028f1:	e8 4a d7 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01028f6:	68 0c 72 10 f0       	push   $0xf010720c
f01028fb:	68 91 67 10 f0       	push   $0xf0106791
f0102900:	68 5e 03 00 00       	push   $0x35e
f0102905:	68 6b 67 10 f0       	push   $0xf010676b
f010290a:	e8 31 d7 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f010290f:	a1 44 32 21 f0       	mov    0xf0213244,%eax
f0102914:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((uint32_t)kva < KERNBASE)
f0102917:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010291a:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f010291f:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f0102925:	89 da                	mov    %ebx,%edx
f0102927:	89 f8                	mov    %edi,%eax
f0102929:	e8 78 e1 ff ff       	call   f0100aa6 <check_va2pa>
f010292e:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f0102935:	76 25                	jbe    f010295c <mem_init+0x1666>
f0102937:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f010293a:	39 d0                	cmp    %edx,%eax
f010293c:	75 35                	jne    f0102973 <mem_init+0x167d>
f010293e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102944:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f010294a:	75 d9                	jne    f0102925 <mem_init+0x162f>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f010294c:	8b 45 c8             	mov    -0x38(%ebp),%eax
f010294f:	c1 e0 0c             	shl    $0xc,%eax
f0102952:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102955:	bb 00 00 00 00       	mov    $0x0,%ebx
f010295a:	eb 56                	jmp    f01029b2 <mem_init+0x16bc>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010295c:	ff 75 d0             	pushl  -0x30(%ebp)
f010295f:	68 68 62 10 f0       	push   $0xf0106268
f0102964:	68 63 03 00 00       	push   $0x363
f0102969:	68 6b 67 10 f0       	push   $0xf010676b
f010296e:	e8 cd d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102973:	68 40 72 10 f0       	push   $0xf0107240
f0102978:	68 91 67 10 f0       	push   $0xf0106791
f010297d:	68 63 03 00 00       	push   $0x363
f0102982:	68 6b 67 10 f0       	push   $0xf010676b
f0102987:	e8 b4 d6 ff ff       	call   f0100040 <_panic>
f010298c:	8d b3 00 00 00 f0    	lea    -0x10000000(%ebx),%esi
		check_va2pa(pgdir, KERNBASE + i);
f0102992:	89 f2                	mov    %esi,%edx
f0102994:	89 f8                	mov    %edi,%eax
f0102996:	e8 0b e1 ff ff       	call   f0100aa6 <check_va2pa>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f010299b:	89 f2                	mov    %esi,%edx
f010299d:	89 f8                	mov    %edi,%eax
f010299f:	e8 02 e1 ff ff       	call   f0100aa6 <check_va2pa>
f01029a4:	39 c3                	cmp    %eax,%ebx
f01029a6:	0f 85 fa 00 00 00    	jne    f0102aa6 <mem_init+0x17b0>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01029ac:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01029b2:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f01029b5:	72 d5                	jb     f010298c <mem_init+0x1696>
f01029b7:	c7 45 d4 00 50 21 f0 	movl   $0xf0215000,-0x2c(%ebp)
f01029be:	be 00 80 ff ef       	mov    $0xefff8000,%esi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f01029c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01029c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f01029c9:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f01029cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01029d2:	89 f3                	mov    %esi,%ebx
f01029d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01029d7:	05 00 80 00 20       	add    $0x20008000,%eax
f01029dc:	89 75 c8             	mov    %esi,-0x38(%ebp)
f01029df:	89 c6                	mov    %eax,%esi
f01029e1:	89 da                	mov    %ebx,%edx
f01029e3:	89 f8                	mov    %edi,%eax
f01029e5:	e8 bc e0 ff ff       	call   f0100aa6 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01029ea:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f01029f1:	0f 86 c8 00 00 00    	jbe    f0102abf <mem_init+0x17c9>
f01029f7:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f01029fa:	39 d0                	cmp    %edx,%eax
f01029fc:	0f 85 d4 00 00 00    	jne    f0102ad6 <mem_init+0x17e0>
f0102a02:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102a08:	3b 5d d0             	cmp    -0x30(%ebp),%ebx
f0102a0b:	75 d4                	jne    f01029e1 <mem_init+0x16eb>
f0102a0d:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0102a10:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102a16:	89 da                	mov    %ebx,%edx
f0102a18:	89 f8                	mov    %edi,%eax
f0102a1a:	e8 87 e0 ff ff       	call   f0100aa6 <check_va2pa>
f0102a1f:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102a22:	0f 85 c7 00 00 00    	jne    f0102aef <mem_init+0x17f9>
f0102a28:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102a2e:	39 f3                	cmp    %esi,%ebx
f0102a30:	75 e4                	jne    f0102a16 <mem_init+0x1720>
f0102a32:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102a38:	81 45 cc 00 80 01 00 	addl   $0x18000,-0x34(%ebp)
f0102a3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102a42:	81 45 d4 00 80 00 00 	addl   $0x8000,-0x2c(%ebp)
	for (n = 0; n < NCPU; n++) {
f0102a49:	3d 00 50 2d f0       	cmp    $0xf02d5000,%eax
f0102a4e:	0f 85 6f ff ff ff    	jne    f01029c3 <mem_init+0x16cd>
	for (i = 0; i < NPDENTRIES; i++)
f0102a54:	b8 00 00 00 00       	mov    $0x0,%eax
			if (i >= PDX(KERNBASE))
f0102a59:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0102a5e:	0f 87 a4 00 00 00    	ja     f0102b08 <mem_init+0x1812>
				assert(pgdir[i] == 0);
f0102a64:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0102a68:	0f 85 dd 00 00 00    	jne    f0102b4b <mem_init+0x1855>
	for (i = 0; i < NPDENTRIES; i++)
f0102a6e:	83 c0 01             	add    $0x1,%eax
f0102a71:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0102a76:	0f 87 e8 00 00 00    	ja     f0102b64 <mem_init+0x186e>
		switch (i)
f0102a7c:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0102a82:	83 fa 04             	cmp    $0x4,%edx
f0102a85:	77 d2                	ja     f0102a59 <mem_init+0x1763>
			assert(pgdir[i] & PTE_P);
f0102a87:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f0102a8b:	75 e1                	jne    f0102a6e <mem_init+0x1778>
f0102a8d:	68 07 6a 10 f0       	push   $0xf0106a07
f0102a92:	68 91 67 10 f0       	push   $0xf0106791
f0102a97:	68 82 03 00 00       	push   $0x382
f0102a9c:	68 6b 67 10 f0       	push   $0xf010676b
f0102aa1:	e8 9a d5 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102aa6:	68 74 72 10 f0       	push   $0xf0107274
f0102aab:	68 91 67 10 f0       	push   $0xf0106791
f0102ab0:	68 6a 03 00 00       	push   $0x36a
f0102ab5:	68 6b 67 10 f0       	push   $0xf010676b
f0102aba:	e8 81 d5 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102abf:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102ac2:	68 68 62 10 f0       	push   $0xf0106268
f0102ac7:	68 73 03 00 00       	push   $0x373
f0102acc:	68 6b 67 10 f0       	push   $0xf010676b
f0102ad1:	e8 6a d5 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102ad6:	68 9c 72 10 f0       	push   $0xf010729c
f0102adb:	68 91 67 10 f0       	push   $0xf0106791
f0102ae0:	68 73 03 00 00       	push   $0x373
f0102ae5:	68 6b 67 10 f0       	push   $0xf010676b
f0102aea:	e8 51 d5 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102aef:	68 e4 72 10 f0       	push   $0xf01072e4
f0102af4:	68 91 67 10 f0       	push   $0xf0106791
f0102af9:	68 75 03 00 00       	push   $0x375
f0102afe:	68 6b 67 10 f0       	push   $0xf010676b
f0102b03:	e8 38 d5 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102b08:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0102b0b:	f6 c2 01             	test   $0x1,%dl
f0102b0e:	74 22                	je     f0102b32 <mem_init+0x183c>
				assert(pgdir[i] & PTE_W);
f0102b10:	f6 c2 02             	test   $0x2,%dl
f0102b13:	0f 85 55 ff ff ff    	jne    f0102a6e <mem_init+0x1778>
f0102b19:	68 18 6a 10 f0       	push   $0xf0106a18
f0102b1e:	68 91 67 10 f0       	push   $0xf0106791
f0102b23:	68 88 03 00 00       	push   $0x388
f0102b28:	68 6b 67 10 f0       	push   $0xf010676b
f0102b2d:	e8 0e d5 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102b32:	68 07 6a 10 f0       	push   $0xf0106a07
f0102b37:	68 91 67 10 f0       	push   $0xf0106791
f0102b3c:	68 87 03 00 00       	push   $0x387
f0102b41:	68 6b 67 10 f0       	push   $0xf010676b
f0102b46:	e8 f5 d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0102b4b:	68 29 6a 10 f0       	push   $0xf0106a29
f0102b50:	68 91 67 10 f0       	push   $0xf0106791
f0102b55:	68 8b 03 00 00       	push   $0x38b
f0102b5a:	68 6b 67 10 f0       	push   $0xf010676b
f0102b5f:	e8 dc d4 ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102b64:	83 ec 0c             	sub    $0xc,%esp
f0102b67:	68 08 73 10 f0       	push   $0xf0107308
f0102b6c:	e8 a2 0d 00 00       	call   f0103913 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102b71:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0102b76:	83 c4 10             	add    $0x10,%esp
f0102b79:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102b7e:	0f 86 fe 01 00 00    	jbe    f0102d82 <mem_init+0x1a8c>
	return (physaddr_t)kva - KERNBASE;
f0102b84:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102b89:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102b8c:	b8 00 00 00 00       	mov    $0x0,%eax
f0102b91:	e8 74 df ff ff       	call   f0100b0a <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102b96:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS | CR0_EM);
f0102b99:	83 e0 f3             	and    $0xfffffff3,%eax
f0102b9c:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102ba1:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102ba4:	83 ec 0c             	sub    $0xc,%esp
f0102ba7:	6a 00                	push   $0x0
f0102ba9:	e8 71 e3 ff ff       	call   f0100f1f <page_alloc>
f0102bae:	89 c3                	mov    %eax,%ebx
f0102bb0:	83 c4 10             	add    $0x10,%esp
f0102bb3:	85 c0                	test   %eax,%eax
f0102bb5:	0f 84 dc 01 00 00    	je     f0102d97 <mem_init+0x1aa1>
	assert((pp1 = page_alloc(0)));
f0102bbb:	83 ec 0c             	sub    $0xc,%esp
f0102bbe:	6a 00                	push   $0x0
f0102bc0:	e8 5a e3 ff ff       	call   f0100f1f <page_alloc>
f0102bc5:	89 c7                	mov    %eax,%edi
f0102bc7:	83 c4 10             	add    $0x10,%esp
f0102bca:	85 c0                	test   %eax,%eax
f0102bcc:	0f 84 de 01 00 00    	je     f0102db0 <mem_init+0x1aba>
	assert((pp2 = page_alloc(0)));
f0102bd2:	83 ec 0c             	sub    $0xc,%esp
f0102bd5:	6a 00                	push   $0x0
f0102bd7:	e8 43 e3 ff ff       	call   f0100f1f <page_alloc>
f0102bdc:	89 c6                	mov    %eax,%esi
f0102bde:	83 c4 10             	add    $0x10,%esp
f0102be1:	85 c0                	test   %eax,%eax
f0102be3:	0f 84 e0 01 00 00    	je     f0102dc9 <mem_init+0x1ad3>
	page_free(pp0);
f0102be9:	83 ec 0c             	sub    $0xc,%esp
f0102bec:	53                   	push   %ebx
f0102bed:	e8 9f e3 ff ff       	call   f0100f91 <page_free>
	return (pp - pages) << PGSHIFT;
f0102bf2:	89 f8                	mov    %edi,%eax
f0102bf4:	2b 05 90 3e 21 f0    	sub    0xf0213e90,%eax
f0102bfa:	c1 f8 03             	sar    $0x3,%eax
f0102bfd:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102c00:	89 c2                	mov    %eax,%edx
f0102c02:	c1 ea 0c             	shr    $0xc,%edx
f0102c05:	83 c4 10             	add    $0x10,%esp
f0102c08:	3b 15 88 3e 21 f0    	cmp    0xf0213e88,%edx
f0102c0e:	0f 83 ce 01 00 00    	jae    f0102de2 <mem_init+0x1aec>
	memset(page2kva(pp1), 1, PGSIZE);
f0102c14:	83 ec 04             	sub    $0x4,%esp
f0102c17:	68 00 10 00 00       	push   $0x1000
f0102c1c:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102c1e:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102c23:	50                   	push   %eax
f0102c24:	e8 89 29 00 00       	call   f01055b2 <memset>
	return (pp - pages) << PGSHIFT;
f0102c29:	89 f0                	mov    %esi,%eax
f0102c2b:	2b 05 90 3e 21 f0    	sub    0xf0213e90,%eax
f0102c31:	c1 f8 03             	sar    $0x3,%eax
f0102c34:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102c37:	89 c2                	mov    %eax,%edx
f0102c39:	c1 ea 0c             	shr    $0xc,%edx
f0102c3c:	83 c4 10             	add    $0x10,%esp
f0102c3f:	3b 15 88 3e 21 f0    	cmp    0xf0213e88,%edx
f0102c45:	0f 83 a9 01 00 00    	jae    f0102df4 <mem_init+0x1afe>
	memset(page2kva(pp2), 2, PGSIZE);
f0102c4b:	83 ec 04             	sub    $0x4,%esp
f0102c4e:	68 00 10 00 00       	push   $0x1000
f0102c53:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102c55:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102c5a:	50                   	push   %eax
f0102c5b:	e8 52 29 00 00       	call   f01055b2 <memset>
	page_insert(kern_pgdir, pp1, (void *)PGSIZE, PTE_W);
f0102c60:	6a 02                	push   $0x2
f0102c62:	68 00 10 00 00       	push   $0x1000
f0102c67:	57                   	push   %edi
f0102c68:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0102c6e:	e8 b8 e5 ff ff       	call   f010122b <page_insert>
	assert(pp1->pp_ref == 1);
f0102c73:	83 c4 20             	add    $0x20,%esp
f0102c76:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102c7b:	0f 85 85 01 00 00    	jne    f0102e06 <mem_init+0x1b10>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102c81:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102c88:	01 01 01 
f0102c8b:	0f 85 8e 01 00 00    	jne    f0102e1f <mem_init+0x1b29>
	page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W);
f0102c91:	6a 02                	push   $0x2
f0102c93:	68 00 10 00 00       	push   $0x1000
f0102c98:	56                   	push   %esi
f0102c99:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0102c9f:	e8 87 e5 ff ff       	call   f010122b <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102ca4:	83 c4 10             	add    $0x10,%esp
f0102ca7:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102cae:	02 02 02 
f0102cb1:	0f 85 81 01 00 00    	jne    f0102e38 <mem_init+0x1b42>
	assert(pp2->pp_ref == 1);
f0102cb7:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102cbc:	0f 85 8f 01 00 00    	jne    f0102e51 <mem_init+0x1b5b>
	assert(pp1->pp_ref == 0);
f0102cc2:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102cc7:	0f 85 9d 01 00 00    	jne    f0102e6a <mem_init+0x1b74>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102ccd:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102cd4:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102cd7:	89 f0                	mov    %esi,%eax
f0102cd9:	2b 05 90 3e 21 f0    	sub    0xf0213e90,%eax
f0102cdf:	c1 f8 03             	sar    $0x3,%eax
f0102ce2:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102ce5:	89 c2                	mov    %eax,%edx
f0102ce7:	c1 ea 0c             	shr    $0xc,%edx
f0102cea:	3b 15 88 3e 21 f0    	cmp    0xf0213e88,%edx
f0102cf0:	0f 83 8d 01 00 00    	jae    f0102e83 <mem_init+0x1b8d>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102cf6:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0102cfd:	03 03 03 
f0102d00:	0f 85 8f 01 00 00    	jne    f0102e95 <mem_init+0x1b9f>
	page_remove(kern_pgdir, (void *)PGSIZE);
f0102d06:	83 ec 08             	sub    $0x8,%esp
f0102d09:	68 00 10 00 00       	push   $0x1000
f0102d0e:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f0102d14:	e8 ca e4 ff ff       	call   f01011e3 <page_remove>
		assert(pp2->pp_ref == 0);
f0102d19:	83 c4 10             	add    $0x10,%esp
f0102d1c:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102d21:	0f 85 87 01 00 00    	jne    f0102eae <mem_init+0x1bb8>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102d27:	8b 0d 8c 3e 21 f0    	mov    0xf0213e8c,%ecx
f0102d2d:	8b 11                	mov    (%ecx),%edx
f0102d2f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102d35:	89 d8                	mov    %ebx,%eax
f0102d37:	2b 05 90 3e 21 f0    	sub    0xf0213e90,%eax
f0102d3d:	c1 f8 03             	sar    $0x3,%eax
f0102d40:	c1 e0 0c             	shl    $0xc,%eax
f0102d43:	39 c2                	cmp    %eax,%edx
f0102d45:	0f 85 7c 01 00 00    	jne    f0102ec7 <mem_init+0x1bd1>
	kern_pgdir[0] = 0;
f0102d4b:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102d51:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102d56:	0f 85 84 01 00 00    	jne    f0102ee0 <mem_init+0x1bea>
	pp0->pp_ref = 0;
f0102d5c:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// free the pages we took
	page_free(pp0);
f0102d62:	83 ec 0c             	sub    $0xc,%esp
f0102d65:	53                   	push   %ebx
f0102d66:	e8 26 e2 ff ff       	call   f0100f91 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102d6b:	c7 04 24 9c 73 10 f0 	movl   $0xf010739c,(%esp)
f0102d72:	e8 9c 0b 00 00       	call   f0103913 <cprintf>
}
f0102d77:	83 c4 10             	add    $0x10,%esp
f0102d7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102d7d:	5b                   	pop    %ebx
f0102d7e:	5e                   	pop    %esi
f0102d7f:	5f                   	pop    %edi
f0102d80:	5d                   	pop    %ebp
f0102d81:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102d82:	50                   	push   %eax
f0102d83:	68 68 62 10 f0       	push   $0xf0106268
f0102d88:	68 ec 00 00 00       	push   $0xec
f0102d8d:	68 6b 67 10 f0       	push   $0xf010676b
f0102d92:	e8 a9 d2 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102d97:	68 6a 68 10 f0       	push   $0xf010686a
f0102d9c:	68 91 67 10 f0       	push   $0xf0106791
f0102da1:	68 61 04 00 00       	push   $0x461
f0102da6:	68 6b 67 10 f0       	push   $0xf010676b
f0102dab:	e8 90 d2 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0102db0:	68 80 68 10 f0       	push   $0xf0106880
f0102db5:	68 91 67 10 f0       	push   $0xf0106791
f0102dba:	68 62 04 00 00       	push   $0x462
f0102dbf:	68 6b 67 10 f0       	push   $0xf010676b
f0102dc4:	e8 77 d2 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102dc9:	68 96 68 10 f0       	push   $0xf0106896
f0102dce:	68 91 67 10 f0       	push   $0xf0106791
f0102dd3:	68 63 04 00 00       	push   $0x463
f0102dd8:	68 6b 67 10 f0       	push   $0xf010676b
f0102ddd:	e8 5e d2 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102de2:	50                   	push   %eax
f0102de3:	68 44 62 10 f0       	push   $0xf0106244
f0102de8:	6a 58                	push   $0x58
f0102dea:	68 77 67 10 f0       	push   $0xf0106777
f0102def:	e8 4c d2 ff ff       	call   f0100040 <_panic>
f0102df4:	50                   	push   %eax
f0102df5:	68 44 62 10 f0       	push   $0xf0106244
f0102dfa:	6a 58                	push   $0x58
f0102dfc:	68 77 67 10 f0       	push   $0xf0106777
f0102e01:	e8 3a d2 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102e06:	68 10 69 10 f0       	push   $0xf0106910
f0102e0b:	68 91 67 10 f0       	push   $0xf0106791
f0102e10:	68 68 04 00 00       	push   $0x468
f0102e15:	68 6b 67 10 f0       	push   $0xf010676b
f0102e1a:	e8 21 d2 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102e1f:	68 28 73 10 f0       	push   $0xf0107328
f0102e24:	68 91 67 10 f0       	push   $0xf0106791
f0102e29:	68 69 04 00 00       	push   $0x469
f0102e2e:	68 6b 67 10 f0       	push   $0xf010676b
f0102e33:	e8 08 d2 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102e38:	68 4c 73 10 f0       	push   $0xf010734c
f0102e3d:	68 91 67 10 f0       	push   $0xf0106791
f0102e42:	68 6b 04 00 00       	push   $0x46b
f0102e47:	68 6b 67 10 f0       	push   $0xf010676b
f0102e4c:	e8 ef d1 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102e51:	68 32 69 10 f0       	push   $0xf0106932
f0102e56:	68 91 67 10 f0       	push   $0xf0106791
f0102e5b:	68 6c 04 00 00       	push   $0x46c
f0102e60:	68 6b 67 10 f0       	push   $0xf010676b
f0102e65:	e8 d6 d1 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102e6a:	68 9c 69 10 f0       	push   $0xf010699c
f0102e6f:	68 91 67 10 f0       	push   $0xf0106791
f0102e74:	68 6d 04 00 00       	push   $0x46d
f0102e79:	68 6b 67 10 f0       	push   $0xf010676b
f0102e7e:	e8 bd d1 ff ff       	call   f0100040 <_panic>
f0102e83:	50                   	push   %eax
f0102e84:	68 44 62 10 f0       	push   $0xf0106244
f0102e89:	6a 58                	push   $0x58
f0102e8b:	68 77 67 10 f0       	push   $0xf0106777
f0102e90:	e8 ab d1 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102e95:	68 70 73 10 f0       	push   $0xf0107370
f0102e9a:	68 91 67 10 f0       	push   $0xf0106791
f0102e9f:	68 6f 04 00 00       	push   $0x46f
f0102ea4:	68 6b 67 10 f0       	push   $0xf010676b
f0102ea9:	e8 92 d1 ff ff       	call   f0100040 <_panic>
		assert(pp2->pp_ref == 0);
f0102eae:	68 6a 69 10 f0       	push   $0xf010696a
f0102eb3:	68 91 67 10 f0       	push   $0xf0106791
f0102eb8:	68 71 04 00 00       	push   $0x471
f0102ebd:	68 6b 67 10 f0       	push   $0xf010676b
f0102ec2:	e8 79 d1 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102ec7:	68 f4 6c 10 f0       	push   $0xf0106cf4
f0102ecc:	68 91 67 10 f0       	push   $0xf0106791
f0102ed1:	68 74 04 00 00       	push   $0x474
f0102ed6:	68 6b 67 10 f0       	push   $0xf010676b
f0102edb:	e8 60 d1 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102ee0:	68 21 69 10 f0       	push   $0xf0106921
f0102ee5:	68 91 67 10 f0       	push   $0xf0106791
f0102eea:	68 76 04 00 00       	push   $0x476
f0102eef:	68 6b 67 10 f0       	push   $0xf010676b
f0102ef4:	e8 47 d1 ff ff       	call   f0100040 <_panic>

f0102ef9 <user_mem_check>:
{
f0102ef9:	55                   	push   %ebp
f0102efa:	89 e5                	mov    %esp,%ebp
f0102efc:	57                   	push   %edi
f0102efd:	56                   	push   %esi
f0102efe:	53                   	push   %ebx
f0102eff:	83 ec 1c             	sub    $0x1c,%esp
    uintptr_t start_va = ROUNDDOWN((uintptr_t)va, PGSIZE);
f0102f02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102f05:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0102f0b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    uintptr_t end_va = ROUNDUP((uintptr_t)va + len, PGSIZE);
f0102f0e:	8b 45 10             	mov    0x10(%ebp),%eax
f0102f11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0102f14:	8d bc 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edi
f0102f1b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        if (cur_pte == NULL || (*cur_pte & (perm|PTE_P)) != (perm|PTE_P) || cur_va >= ULIM) {
f0102f21:	8b 75 14             	mov    0x14(%ebp),%esi
f0102f24:	83 ce 01             	or     $0x1,%esi
    for (uintptr_t cur_va=start_va; cur_va<end_va; cur_va+=PGSIZE) {
f0102f27:	39 fb                	cmp    %edi,%ebx
f0102f29:	73 57                	jae    f0102f82 <user_mem_check+0x89>
        pte_t *cur_pte = pgdir_walk(env->env_pgdir, (void *)cur_va, 0);
f0102f2b:	83 ec 04             	sub    $0x4,%esp
f0102f2e:	6a 00                	push   $0x0
f0102f30:	53                   	push   %ebx
f0102f31:	8b 45 08             	mov    0x8(%ebp),%eax
f0102f34:	ff 70 60             	pushl  0x60(%eax)
f0102f37:	e8 b9 e0 ff ff       	call   f0100ff5 <pgdir_walk>
        if (cur_pte == NULL || (*cur_pte & (perm|PTE_P)) != (perm|PTE_P) || cur_va >= ULIM) {
f0102f3c:	83 c4 10             	add    $0x10,%esp
f0102f3f:	85 c0                	test   %eax,%eax
f0102f41:	74 18                	je     f0102f5b <user_mem_check+0x62>
f0102f43:	89 f2                	mov    %esi,%edx
f0102f45:	23 10                	and    (%eax),%edx
f0102f47:	39 f2                	cmp    %esi,%edx
f0102f49:	75 10                	jne    f0102f5b <user_mem_check+0x62>
f0102f4b:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102f51:	77 08                	ja     f0102f5b <user_mem_check+0x62>
    for (uintptr_t cur_va=start_va; cur_va<end_va; cur_va+=PGSIZE) {
f0102f53:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102f59:	eb cc                	jmp    f0102f27 <user_mem_check+0x2e>
            if (cur_va == start_va) {
f0102f5b:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0102f5e:	74 13                	je     f0102f73 <user_mem_check+0x7a>
                user_mem_check_addr = cur_va;
f0102f60:	89 1d 3c 32 21 f0    	mov    %ebx,0xf021323c
            return -E_FAULT;
f0102f66:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f0102f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102f6e:	5b                   	pop    %ebx
f0102f6f:	5e                   	pop    %esi
f0102f70:	5f                   	pop    %edi
f0102f71:	5d                   	pop    %ebp
f0102f72:	c3                   	ret    
                user_mem_check_addr = (uintptr_t)va;
f0102f73:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102f76:	a3 3c 32 21 f0       	mov    %eax,0xf021323c
            return -E_FAULT;
f0102f7b:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0102f80:	eb e9                	jmp    f0102f6b <user_mem_check+0x72>
    return 0;
f0102f82:	b8 00 00 00 00       	mov    $0x0,%eax
f0102f87:	eb e2                	jmp    f0102f6b <user_mem_check+0x72>

f0102f89 <user_mem_assert>:
{
f0102f89:	55                   	push   %ebp
f0102f8a:	89 e5                	mov    %esp,%ebp
f0102f8c:	53                   	push   %ebx
f0102f8d:	83 ec 04             	sub    $0x4,%esp
f0102f90:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0)
f0102f93:	8b 45 14             	mov    0x14(%ebp),%eax
f0102f96:	83 c8 04             	or     $0x4,%eax
f0102f99:	50                   	push   %eax
f0102f9a:	ff 75 10             	pushl  0x10(%ebp)
f0102f9d:	ff 75 0c             	pushl  0xc(%ebp)
f0102fa0:	53                   	push   %ebx
f0102fa1:	e8 53 ff ff ff       	call   f0102ef9 <user_mem_check>
f0102fa6:	83 c4 10             	add    $0x10,%esp
f0102fa9:	85 c0                	test   %eax,%eax
f0102fab:	78 05                	js     f0102fb2 <user_mem_assert+0x29>
}
f0102fad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102fb0:	c9                   	leave  
f0102fb1:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0102fb2:	83 ec 04             	sub    $0x4,%esp
f0102fb5:	ff 35 3c 32 21 f0    	pushl  0xf021323c
f0102fbb:	ff 73 48             	pushl  0x48(%ebx)
f0102fbe:	68 c8 73 10 f0       	push   $0xf01073c8
f0102fc3:	e8 4b 09 00 00       	call   f0103913 <cprintf>
		env_destroy(env); // may not return
f0102fc8:	89 1c 24             	mov    %ebx,(%esp)
f0102fcb:	e8 6e 06 00 00       	call   f010363e <env_destroy>
f0102fd0:	83 c4 10             	add    $0x10,%esp
}
f0102fd3:	eb d8                	jmp    f0102fad <user_mem_assert+0x24>

f0102fd5 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0102fd5:	55                   	push   %ebp
f0102fd6:	89 e5                	mov    %esp,%ebp
f0102fd8:	57                   	push   %edi
f0102fd9:	56                   	push   %esi
f0102fda:	53                   	push   %ebx
f0102fdb:	83 ec 1c             	sub    $0x1c,%esp
f0102fde:	89 c7                	mov    %eax,%edi
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
    uintptr_t va_start = ROUNDDOWN((uintptr_t)va, PGSIZE);
    uintptr_t va_end = ROUNDUP((uintptr_t)va + len, PGSIZE);
f0102fe0:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f0102fe7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102fec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    uintptr_t va_start = ROUNDDOWN((uintptr_t)va, PGSIZE);
f0102fef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102ff5:	89 d3                	mov    %edx,%ebx
    struct PageInfo *pginfo = NULL;
    for (int cur_va=va_start; cur_va<va_end; cur_va+=PGSIZE) {
f0102ff7:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0102ffa:	73 4e                	jae    f010304a <region_alloc+0x75>
        pginfo = page_alloc(0);
f0102ffc:	83 ec 0c             	sub    $0xc,%esp
f0102fff:	6a 00                	push   $0x0
f0103001:	e8 19 df ff ff       	call   f0100f1f <page_alloc>
f0103006:	89 c6                	mov    %eax,%esi
        if (!pginfo) {
f0103008:	83 c4 10             	add    $0x10,%esp
f010300b:	85 c0                	test   %eax,%eax
f010300d:	74 25                	je     f0103034 <region_alloc+0x5f>
            int r = -E_NO_MEM;
            panic("region_alloc: %e" , r);
        }
        cprintf("insert page at %08x\n",cur_va);
f010300f:	83 ec 08             	sub    $0x8,%esp
f0103012:	53                   	push   %ebx
f0103013:	68 19 74 10 f0       	push   $0xf0107419
f0103018:	e8 f6 08 00 00       	call   f0103913 <cprintf>
        page_insert(e->env_pgdir, pginfo, (void *)cur_va, PTE_U | PTE_W | PTE_P);
f010301d:	6a 07                	push   $0x7
f010301f:	53                   	push   %ebx
f0103020:	56                   	push   %esi
f0103021:	ff 77 60             	pushl  0x60(%edi)
f0103024:	e8 02 e2 ff ff       	call   f010122b <page_insert>
    for (int cur_va=va_start; cur_va<va_end; cur_va+=PGSIZE) {
f0103029:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010302f:	83 c4 20             	add    $0x20,%esp
f0103032:	eb c3                	jmp    f0102ff7 <region_alloc+0x22>
            panic("region_alloc: %e" , r);
f0103034:	6a fc                	push   $0xfffffffc
f0103036:	68 fd 73 10 f0       	push   $0xf01073fd
f010303b:	68 2e 01 00 00       	push   $0x12e
f0103040:	68 0e 74 10 f0       	push   $0xf010740e
f0103045:	e8 f6 cf ff ff       	call   f0100040 <_panic>
    }
}
f010304a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010304d:	5b                   	pop    %ebx
f010304e:	5e                   	pop    %esi
f010304f:	5f                   	pop    %edi
f0103050:	5d                   	pop    %ebp
f0103051:	c3                   	ret    

f0103052 <envid2env>:
{
f0103052:	55                   	push   %ebp
f0103053:	89 e5                	mov    %esp,%ebp
f0103055:	56                   	push   %esi
f0103056:	53                   	push   %ebx
f0103057:	8b 45 08             	mov    0x8(%ebp),%eax
f010305a:	8b 55 10             	mov    0x10(%ebp),%edx
	if (envid == 0) {
f010305d:	85 c0                	test   %eax,%eax
f010305f:	74 2e                	je     f010308f <envid2env+0x3d>
	e = &envs[ENVX(envid)];
f0103061:	89 c3                	mov    %eax,%ebx
f0103063:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103069:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f010306c:	03 1d 44 32 21 f0    	add    0xf0213244,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103072:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103076:	74 31                	je     f01030a9 <envid2env+0x57>
f0103078:	39 43 48             	cmp    %eax,0x48(%ebx)
f010307b:	75 2c                	jne    f01030a9 <envid2env+0x57>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f010307d:	84 d2                	test   %dl,%dl
f010307f:	75 38                	jne    f01030b9 <envid2env+0x67>
	*env_store = e;
f0103081:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103084:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103086:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010308b:	5b                   	pop    %ebx
f010308c:	5e                   	pop    %esi
f010308d:	5d                   	pop    %ebp
f010308e:	c3                   	ret    
		*env_store = curenv;
f010308f:	e8 43 2b 00 00       	call   f0105bd7 <cpunum>
f0103094:	6b c0 74             	imul   $0x74,%eax,%eax
f0103097:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f010309d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01030a0:	89 01                	mov    %eax,(%ecx)
		return 0;
f01030a2:	b8 00 00 00 00       	mov    $0x0,%eax
f01030a7:	eb e2                	jmp    f010308b <envid2env+0x39>
		*env_store = 0;
f01030a9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01030ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01030b2:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01030b7:	eb d2                	jmp    f010308b <envid2env+0x39>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01030b9:	e8 19 2b 00 00       	call   f0105bd7 <cpunum>
f01030be:	6b c0 74             	imul   $0x74,%eax,%eax
f01030c1:	39 98 28 40 21 f0    	cmp    %ebx,-0xfdebfd8(%eax)
f01030c7:	74 b8                	je     f0103081 <envid2env+0x2f>
f01030c9:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01030cc:	e8 06 2b 00 00       	call   f0105bd7 <cpunum>
f01030d1:	6b c0 74             	imul   $0x74,%eax,%eax
f01030d4:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f01030da:	3b 70 48             	cmp    0x48(%eax),%esi
f01030dd:	74 a2                	je     f0103081 <envid2env+0x2f>
		*env_store = 0;
f01030df:	8b 45 0c             	mov    0xc(%ebp),%eax
f01030e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01030e8:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01030ed:	eb 9c                	jmp    f010308b <envid2env+0x39>

f01030ef <env_init_percpu>:
{
f01030ef:	55                   	push   %ebp
f01030f0:	89 e5                	mov    %esp,%ebp
	asm volatile("lgdt (%0)" : : "r" (p));
f01030f2:	b8 20 13 12 f0       	mov    $0xf0121320,%eax
f01030f7:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f01030fa:	b8 23 00 00 00       	mov    $0x23,%eax
f01030ff:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f0103101:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f0103103:	b8 10 00 00 00       	mov    $0x10,%eax
f0103108:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f010310a:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f010310c:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f010310e:	ea 15 31 10 f0 08 00 	ljmp   $0x8,$0xf0103115
	asm volatile("lldt %0" : : "r" (sel));
f0103115:	b8 00 00 00 00       	mov    $0x0,%eax
f010311a:	0f 00 d0             	lldt   %ax
}
f010311d:	5d                   	pop    %ebp
f010311e:	c3                   	ret    

f010311f <env_init>:
{
f010311f:	55                   	push   %ebp
f0103120:	89 e5                	mov    %esp,%ebp
f0103122:	56                   	push   %esi
f0103123:	53                   	push   %ebx
        envs[i].env_id = 0;
f0103124:	8b 35 44 32 21 f0    	mov    0xf0213244,%esi
f010312a:	8b 15 48 32 21 f0    	mov    0xf0213248,%edx
f0103130:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f0103136:	8d 5e 84             	lea    -0x7c(%esi),%ebx
f0103139:	89 c1                	mov    %eax,%ecx
f010313b:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
        envs[i].env_link = env_free_list;
f0103142:	89 50 44             	mov    %edx,0x44(%eax)
f0103145:	83 e8 7c             	sub    $0x7c,%eax
        env_free_list = &envs[i];
f0103148:	89 ca                	mov    %ecx,%edx
    while (i>0) {
f010314a:	39 d8                	cmp    %ebx,%eax
f010314c:	75 eb                	jne    f0103139 <env_init+0x1a>
f010314e:	89 35 48 32 21 f0    	mov    %esi,0xf0213248
	env_init_percpu();
f0103154:	e8 96 ff ff ff       	call   f01030ef <env_init_percpu>
}
f0103159:	5b                   	pop    %ebx
f010315a:	5e                   	pop    %esi
f010315b:	5d                   	pop    %ebp
f010315c:	c3                   	ret    

f010315d <env_alloc>:
{
f010315d:	55                   	push   %ebp
f010315e:	89 e5                	mov    %esp,%ebp
f0103160:	56                   	push   %esi
f0103161:	53                   	push   %ebx
	if (!(e = env_free_list))
f0103162:	8b 1d 48 32 21 f0    	mov    0xf0213248,%ebx
f0103168:	85 db                	test   %ebx,%ebx
f010316a:	0f 84 78 01 00 00    	je     f01032e8 <env_alloc+0x18b>
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103170:	83 ec 0c             	sub    $0xc,%esp
f0103173:	6a 01                	push   $0x1
f0103175:	e8 a5 dd ff ff       	call   f0100f1f <page_alloc>
f010317a:	89 c6                	mov    %eax,%esi
f010317c:	83 c4 10             	add    $0x10,%esp
f010317f:	85 c0                	test   %eax,%eax
f0103181:	0f 84 68 01 00 00    	je     f01032ef <env_alloc+0x192>
	return (pp - pages) << PGSHIFT;
f0103187:	2b 05 90 3e 21 f0    	sub    0xf0213e90,%eax
f010318d:	c1 f8 03             	sar    $0x3,%eax
f0103190:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0103193:	89 c2                	mov    %eax,%edx
f0103195:	c1 ea 0c             	shr    $0xc,%edx
f0103198:	3b 15 88 3e 21 f0    	cmp    0xf0213e88,%edx
f010319e:	0f 83 1d 01 00 00    	jae    f01032c1 <env_alloc+0x164>
	return (void *)(pa + KERNBASE);
f01031a4:	2d 00 00 00 10       	sub    $0x10000000,%eax
	e->env_pgdir = page2kva(p);
f01031a9:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE); // use kern_pgdir as template 
f01031ac:	83 ec 04             	sub    $0x4,%esp
f01031af:	68 00 10 00 00       	push   $0x1000
f01031b4:	ff 35 8c 3e 21 f0    	pushl  0xf0213e8c
f01031ba:	50                   	push   %eax
f01031bb:	e8 a7 24 00 00       	call   f0105667 <memcpy>
    p->pp_ref++;
f01031c0:	66 83 46 04 01       	addw   $0x1,0x4(%esi)
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f01031c5:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01031c8:	83 c4 10             	add    $0x10,%esp
f01031cb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01031d0:	0f 86 fd 00 00 00    	jbe    f01032d3 <env_alloc+0x176>
	return (physaddr_t)kva - KERNBASE;
f01031d6:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01031dc:	83 ca 05             	or     $0x5,%edx
f01031df:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f01031e5:	8b 43 48             	mov    0x48(%ebx),%eax
f01031e8:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f01031ed:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f01031f2:	ba 00 10 00 00       	mov    $0x1000,%edx
f01031f7:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01031fa:	89 da                	mov    %ebx,%edx
f01031fc:	2b 15 44 32 21 f0    	sub    0xf0213244,%edx
f0103202:	c1 fa 02             	sar    $0x2,%edx
f0103205:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f010320b:	09 d0                	or     %edx,%eax
f010320d:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f0103210:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103213:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103216:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f010321d:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103224:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f010322b:	83 ec 04             	sub    $0x4,%esp
f010322e:	6a 44                	push   $0x44
f0103230:	6a 00                	push   $0x0
f0103232:	53                   	push   %ebx
f0103233:	e8 7a 23 00 00       	call   f01055b2 <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f0103238:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f010323e:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103244:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f010324a:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103251:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f0103257:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f010325e:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f0103265:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f0103269:	8b 43 44             	mov    0x44(%ebx),%eax
f010326c:	a3 48 32 21 f0       	mov    %eax,0xf0213248
	*newenv_store = e;
f0103271:	8b 45 08             	mov    0x8(%ebp),%eax
f0103274:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103276:	8b 5b 48             	mov    0x48(%ebx),%ebx
f0103279:	e8 59 29 00 00       	call   f0105bd7 <cpunum>
f010327e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103281:	83 c4 10             	add    $0x10,%esp
f0103284:	ba 00 00 00 00       	mov    $0x0,%edx
f0103289:	83 b8 28 40 21 f0 00 	cmpl   $0x0,-0xfdebfd8(%eax)
f0103290:	74 11                	je     f01032a3 <env_alloc+0x146>
f0103292:	e8 40 29 00 00       	call   f0105bd7 <cpunum>
f0103297:	6b c0 74             	imul   $0x74,%eax,%eax
f010329a:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f01032a0:	8b 50 48             	mov    0x48(%eax),%edx
f01032a3:	83 ec 04             	sub    $0x4,%esp
f01032a6:	53                   	push   %ebx
f01032a7:	52                   	push   %edx
f01032a8:	68 2e 74 10 f0       	push   $0xf010742e
f01032ad:	e8 61 06 00 00       	call   f0103913 <cprintf>
	return 0;
f01032b2:	83 c4 10             	add    $0x10,%esp
f01032b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01032ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01032bd:	5b                   	pop    %ebx
f01032be:	5e                   	pop    %esi
f01032bf:	5d                   	pop    %ebp
f01032c0:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01032c1:	50                   	push   %eax
f01032c2:	68 44 62 10 f0       	push   $0xf0106244
f01032c7:	6a 58                	push   $0x58
f01032c9:	68 77 67 10 f0       	push   $0xf0106777
f01032ce:	e8 6d cd ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01032d3:	50                   	push   %eax
f01032d4:	68 68 62 10 f0       	push   $0xf0106268
f01032d9:	68 c9 00 00 00       	push   $0xc9
f01032de:	68 0e 74 10 f0       	push   $0xf010740e
f01032e3:	e8 58 cd ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f01032e8:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f01032ed:	eb cb                	jmp    f01032ba <env_alloc+0x15d>
		return -E_NO_MEM;
f01032ef:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01032f4:	eb c4                	jmp    f01032ba <env_alloc+0x15d>

f01032f6 <env_create>:
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void env_create(uint8_t *binary, enum EnvType type)
{
f01032f6:	55                   	push   %ebp
f01032f7:	89 e5                	mov    %esp,%ebp
f01032f9:	57                   	push   %edi
f01032fa:	56                   	push   %esi
f01032fb:	53                   	push   %ebx
f01032fc:	83 ec 34             	sub    $0x34,%esp
f01032ff:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103302:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// LAB 3: Your code here.
	struct Env *e;
	int r = env_alloc(&e, 0);
f0103305:	6a 00                	push   $0x0
f0103307:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010330a:	50                   	push   %eax
f010330b:	e8 4d fe ff ff       	call   f010315d <env_alloc>
	if (r < 0)
f0103310:	83 c4 10             	add    $0x10,%esp
f0103313:	85 c0                	test   %eax,%eax
f0103315:	78 3b                	js     f0103352 <env_create+0x5c>
	{
		panic("env_create: %e", r);
	}
	if (type == ENV_TYPE_FS)
f0103317:	83 fb 01             	cmp    $0x1,%ebx
f010331a:	74 4b                	je     f0103367 <env_create+0x71>
	{
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
	}
	e->env_type = type;
f010331c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010331f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103322:	89 58 50             	mov    %ebx,0x50(%eax)
    if (elf->e_magic != ELF_MAGIC) {
f0103325:	81 3f 7f 45 4c 46    	cmpl   $0x464c457f,(%edi)
f010332b:	75 46                	jne    f0103373 <env_create+0x7d>
    ph = (struct Proghdr *)(binary + elf->e_phoff);
f010332d:	89 fb                	mov    %edi,%ebx
f010332f:	03 5f 1c             	add    0x1c(%edi),%ebx
    eph = ph + elf->e_phnum;
f0103332:	0f b7 77 2c          	movzwl 0x2c(%edi),%esi
f0103336:	c1 e6 05             	shl    $0x5,%esi
f0103339:	01 de                	add    %ebx,%esi
    lcr3(PADDR(e->env_pgdir));
f010333b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010333e:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103341:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103346:	76 42                	jbe    f010338a <env_create+0x94>
	return (physaddr_t)kva - KERNBASE;
f0103348:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010334d:	0f 22 d8             	mov    %eax,%cr3
f0103350:	eb 67                	jmp    f01033b9 <env_create+0xc3>
		panic("env_create: %e", r);
f0103352:	50                   	push   %eax
f0103353:	68 43 74 10 f0       	push   $0xf0107443
f0103358:	68 93 01 00 00       	push   $0x193
f010335d:	68 0e 74 10 f0       	push   $0xf010740e
f0103362:	e8 d9 cc ff ff       	call   f0100040 <_panic>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
f0103367:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010336a:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
f0103371:	eb a9                	jmp    f010331c <env_create+0x26>
        panic("load_icode: not an ELF file");
f0103373:	83 ec 04             	sub    $0x4,%esp
f0103376:	68 52 74 10 f0       	push   $0xf0107452
f010337b:	68 6d 01 00 00       	push   $0x16d
f0103380:	68 0e 74 10 f0       	push   $0xf010740e
f0103385:	e8 b6 cc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010338a:	50                   	push   %eax
f010338b:	68 68 62 10 f0       	push   $0xf0106268
f0103390:	68 72 01 00 00       	push   $0x172
f0103395:	68 0e 74 10 f0       	push   $0xf010740e
f010339a:	e8 a1 cc ff ff       	call   f0100040 <_panic>
                panic("load_icode: file size is greater than memory size");
f010339f:	83 ec 04             	sub    $0x4,%esp
f01033a2:	68 90 74 10 f0       	push   $0xf0107490
f01033a7:	68 76 01 00 00       	push   $0x176
f01033ac:	68 0e 74 10 f0       	push   $0xf010740e
f01033b1:	e8 8a cc ff ff       	call   f0100040 <_panic>
    for (; ph<eph; ph++) {
f01033b6:	83 c3 20             	add    $0x20,%ebx
f01033b9:	39 de                	cmp    %ebx,%esi
f01033bb:	76 48                	jbe    f0103405 <env_create+0x10f>
        if (ph->p_type == ELF_PROG_LOAD) {
f01033bd:	83 3b 01             	cmpl   $0x1,(%ebx)
f01033c0:	75 f4                	jne    f01033b6 <env_create+0xc0>
            if (ph->p_filesz > ph->p_memsz) {
f01033c2:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01033c5:	39 4b 10             	cmp    %ecx,0x10(%ebx)
f01033c8:	77 d5                	ja     f010339f <env_create+0xa9>
            region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f01033ca:	8b 53 08             	mov    0x8(%ebx),%edx
f01033cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01033d0:	e8 00 fc ff ff       	call   f0102fd5 <region_alloc>
            memcpy((void *)ph->p_va, binary + ph->p_offset, ph->p_filesz);
f01033d5:	83 ec 04             	sub    $0x4,%esp
f01033d8:	ff 73 10             	pushl  0x10(%ebx)
f01033db:	89 f8                	mov    %edi,%eax
f01033dd:	03 43 04             	add    0x4(%ebx),%eax
f01033e0:	50                   	push   %eax
f01033e1:	ff 73 08             	pushl  0x8(%ebx)
f01033e4:	e8 7e 22 00 00       	call   f0105667 <memcpy>
            memset((void *)ph->p_va + ph->p_filesz, 0, ph->p_memsz - ph->p_filesz);
f01033e9:	8b 43 10             	mov    0x10(%ebx),%eax
f01033ec:	83 c4 0c             	add    $0xc,%esp
f01033ef:	8b 53 14             	mov    0x14(%ebx),%edx
f01033f2:	29 c2                	sub    %eax,%edx
f01033f4:	52                   	push   %edx
f01033f5:	6a 00                	push   $0x0
f01033f7:	03 43 08             	add    0x8(%ebx),%eax
f01033fa:	50                   	push   %eax
f01033fb:	e8 b2 21 00 00       	call   f01055b2 <memset>
f0103400:	83 c4 10             	add    $0x10,%esp
f0103403:	eb b1                	jmp    f01033b6 <env_create+0xc0>
    e->env_tf.tf_eip = elf->e_entry;
f0103405:	8b 47 18             	mov    0x18(%edi),%eax
f0103408:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f010340b:	89 47 30             	mov    %eax,0x30(%edi)
    region_alloc(e, (void *) USTACKTOP-PGSIZE, PGSIZE);
f010340e:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103413:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103418:	89 f8                	mov    %edi,%eax
f010341a:	e8 b6 fb ff ff       	call   f0102fd5 <region_alloc>
    lcr3(PADDR(kern_pgdir));
f010341f:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0103424:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103429:	76 10                	jbe    f010343b <env_create+0x145>
	return (physaddr_t)kva - KERNBASE;
f010342b:	05 00 00 00 10       	add    $0x10000000,%eax
f0103430:	0f 22 d8             	mov    %eax,%cr3
	load_icode(e, binary);
}
f0103433:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103436:	5b                   	pop    %ebx
f0103437:	5e                   	pop    %esi
f0103438:	5f                   	pop    %edi
f0103439:	5d                   	pop    %ebp
f010343a:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010343b:	50                   	push   %eax
f010343c:	68 68 62 10 f0       	push   $0xf0106268
f0103441:	68 82 01 00 00       	push   $0x182
f0103446:	68 0e 74 10 f0       	push   $0xf010740e
f010344b:	e8 f0 cb ff ff       	call   f0100040 <_panic>

f0103450 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103450:	55                   	push   %ebp
f0103451:	89 e5                	mov    %esp,%ebp
f0103453:	57                   	push   %edi
f0103454:	56                   	push   %esi
f0103455:	53                   	push   %ebx
f0103456:	83 ec 1c             	sub    $0x1c,%esp
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103459:	e8 79 27 00 00       	call   f0105bd7 <cpunum>
f010345e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103461:	8b 55 08             	mov    0x8(%ebp),%edx
f0103464:	39 90 28 40 21 f0    	cmp    %edx,-0xfdebfd8(%eax)
f010346a:	75 14                	jne    f0103480 <env_free+0x30>
		lcr3(PADDR(kern_pgdir));
f010346c:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0103471:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103476:	76 56                	jbe    f01034ce <env_free+0x7e>
	return (physaddr_t)kva - KERNBASE;
f0103478:	05 00 00 00 10       	add    $0x10000000,%eax
f010347d:	0f 22 d8             	mov    %eax,%cr3

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103480:	8b 45 08             	mov    0x8(%ebp),%eax
f0103483:	8b 58 48             	mov    0x48(%eax),%ebx
f0103486:	e8 4c 27 00 00       	call   f0105bd7 <cpunum>
f010348b:	6b c0 74             	imul   $0x74,%eax,%eax
f010348e:	ba 00 00 00 00       	mov    $0x0,%edx
f0103493:	83 b8 28 40 21 f0 00 	cmpl   $0x0,-0xfdebfd8(%eax)
f010349a:	74 11                	je     f01034ad <env_free+0x5d>
f010349c:	e8 36 27 00 00       	call   f0105bd7 <cpunum>
f01034a1:	6b c0 74             	imul   $0x74,%eax,%eax
f01034a4:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f01034aa:	8b 50 48             	mov    0x48(%eax),%edx
f01034ad:	83 ec 04             	sub    $0x4,%esp
f01034b0:	53                   	push   %ebx
f01034b1:	52                   	push   %edx
f01034b2:	68 6e 74 10 f0       	push   $0xf010746e
f01034b7:	e8 57 04 00 00       	call   f0103913 <cprintf>
f01034bc:	83 c4 10             	add    $0x10,%esp
f01034bf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f01034c6:	8b 7d 08             	mov    0x8(%ebp),%edi
f01034c9:	e9 8f 00 00 00       	jmp    f010355d <env_free+0x10d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01034ce:	50                   	push   %eax
f01034cf:	68 68 62 10 f0       	push   $0xf0106268
f01034d4:	68 ab 01 00 00       	push   $0x1ab
f01034d9:	68 0e 74 10 f0       	push   $0xf010740e
f01034de:	e8 5d cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01034e3:	50                   	push   %eax
f01034e4:	68 44 62 10 f0       	push   $0xf0106244
f01034e9:	68 ba 01 00 00       	push   $0x1ba
f01034ee:	68 0e 74 10 f0       	push   $0xf010740e
f01034f3:	e8 48 cb ff ff       	call   f0100040 <_panic>
f01034f8:	83 c3 04             	add    $0x4,%ebx
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01034fb:	39 f3                	cmp    %esi,%ebx
f01034fd:	74 21                	je     f0103520 <env_free+0xd0>
			if (pt[pteno] & PTE_P)
f01034ff:	f6 03 01             	testb  $0x1,(%ebx)
f0103502:	74 f4                	je     f01034f8 <env_free+0xa8>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103504:	83 ec 08             	sub    $0x8,%esp
f0103507:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010350a:	01 d8                	add    %ebx,%eax
f010350c:	c1 e0 0a             	shl    $0xa,%eax
f010350f:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103512:	50                   	push   %eax
f0103513:	ff 77 60             	pushl  0x60(%edi)
f0103516:	e8 c8 dc ff ff       	call   f01011e3 <page_remove>
f010351b:	83 c4 10             	add    $0x10,%esp
f010351e:	eb d8                	jmp    f01034f8 <env_free+0xa8>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103520:	8b 47 60             	mov    0x60(%edi),%eax
f0103523:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103526:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f010352d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103530:	3b 05 88 3e 21 f0    	cmp    0xf0213e88,%eax
f0103536:	73 6a                	jae    f01035a2 <env_free+0x152>
		page_decref(pa2page(pa));
f0103538:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010353b:	a1 90 3e 21 f0       	mov    0xf0213e90,%eax
f0103540:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103543:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103546:	50                   	push   %eax
f0103547:	e8 80 da ff ff       	call   f0100fcc <page_decref>
f010354c:	83 c4 10             	add    $0x10,%esp
f010354f:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
f0103553:	8b 45 dc             	mov    -0x24(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103556:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f010355b:	74 59                	je     f01035b6 <env_free+0x166>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f010355d:	8b 47 60             	mov    0x60(%edi),%eax
f0103560:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103563:	8b 04 10             	mov    (%eax,%edx,1),%eax
f0103566:	a8 01                	test   $0x1,%al
f0103568:	74 e5                	je     f010354f <env_free+0xff>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f010356a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f010356f:	89 c2                	mov    %eax,%edx
f0103571:	c1 ea 0c             	shr    $0xc,%edx
f0103574:	89 55 d8             	mov    %edx,-0x28(%ebp)
f0103577:	39 15 88 3e 21 f0    	cmp    %edx,0xf0213e88
f010357d:	0f 86 60 ff ff ff    	jbe    f01034e3 <env_free+0x93>
	return (void *)(pa + KERNBASE);
f0103583:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103589:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010358c:	c1 e2 14             	shl    $0x14,%edx
f010358f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0103592:	8d b0 00 10 00 f0    	lea    -0xffff000(%eax),%esi
f0103598:	f7 d8                	neg    %eax
f010359a:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010359d:	e9 5d ff ff ff       	jmp    f01034ff <env_free+0xaf>
		panic("pa2page called with invalid pa");
f01035a2:	83 ec 04             	sub    $0x4,%esp
f01035a5:	68 64 6b 10 f0       	push   $0xf0106b64
f01035aa:	6a 51                	push   $0x51
f01035ac:	68 77 67 10 f0       	push   $0xf0106777
f01035b1:	e8 8a ca ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01035b6:	8b 45 08             	mov    0x8(%ebp),%eax
f01035b9:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01035bc:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01035c1:	76 52                	jbe    f0103615 <env_free+0x1c5>
	e->env_pgdir = 0;
f01035c3:	8b 55 08             	mov    0x8(%ebp),%edx
f01035c6:	c7 42 60 00 00 00 00 	movl   $0x0,0x60(%edx)
	return (physaddr_t)kva - KERNBASE;
f01035cd:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01035d2:	c1 e8 0c             	shr    $0xc,%eax
f01035d5:	3b 05 88 3e 21 f0    	cmp    0xf0213e88,%eax
f01035db:	73 4d                	jae    f010362a <env_free+0x1da>
	page_decref(pa2page(pa));
f01035dd:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01035e0:	8b 15 90 3e 21 f0    	mov    0xf0213e90,%edx
f01035e6:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01035e9:	50                   	push   %eax
f01035ea:	e8 dd d9 ff ff       	call   f0100fcc <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01035ef:	8b 45 08             	mov    0x8(%ebp),%eax
f01035f2:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	e->env_link = env_free_list;
f01035f9:	a1 48 32 21 f0       	mov    0xf0213248,%eax
f01035fe:	8b 55 08             	mov    0x8(%ebp),%edx
f0103601:	89 42 44             	mov    %eax,0x44(%edx)
	env_free_list = e;
f0103604:	89 15 48 32 21 f0    	mov    %edx,0xf0213248
}
f010360a:	83 c4 10             	add    $0x10,%esp
f010360d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103610:	5b                   	pop    %ebx
f0103611:	5e                   	pop    %esi
f0103612:	5f                   	pop    %edi
f0103613:	5d                   	pop    %ebp
f0103614:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103615:	50                   	push   %eax
f0103616:	68 68 62 10 f0       	push   $0xf0106268
f010361b:	68 c8 01 00 00       	push   $0x1c8
f0103620:	68 0e 74 10 f0       	push   $0xf010740e
f0103625:	e8 16 ca ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f010362a:	83 ec 04             	sub    $0x4,%esp
f010362d:	68 64 6b 10 f0       	push   $0xf0106b64
f0103632:	6a 51                	push   $0x51
f0103634:	68 77 67 10 f0       	push   $0xf0106777
f0103639:	e8 02 ca ff ff       	call   f0100040 <_panic>

f010363e <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f010363e:	55                   	push   %ebp
f010363f:	89 e5                	mov    %esp,%ebp
f0103641:	53                   	push   %ebx
f0103642:	83 ec 04             	sub    $0x4,%esp
f0103645:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103648:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f010364c:	74 21                	je     f010366f <env_destroy+0x31>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f010364e:	83 ec 0c             	sub    $0xc,%esp
f0103651:	53                   	push   %ebx
f0103652:	e8 f9 fd ff ff       	call   f0103450 <env_free>

	if (curenv == e) {
f0103657:	e8 7b 25 00 00       	call   f0105bd7 <cpunum>
f010365c:	6b c0 74             	imul   $0x74,%eax,%eax
f010365f:	83 c4 10             	add    $0x10,%esp
f0103662:	39 98 28 40 21 f0    	cmp    %ebx,-0xfdebfd8(%eax)
f0103668:	74 1e                	je     f0103688 <env_destroy+0x4a>
		curenv = NULL;
		sched_yield();
	}
}
f010366a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010366d:	c9                   	leave  
f010366e:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010366f:	e8 63 25 00 00       	call   f0105bd7 <cpunum>
f0103674:	6b c0 74             	imul   $0x74,%eax,%eax
f0103677:	39 98 28 40 21 f0    	cmp    %ebx,-0xfdebfd8(%eax)
f010367d:	74 cf                	je     f010364e <env_destroy+0x10>
		e->env_status = ENV_DYING;
f010367f:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103686:	eb e2                	jmp    f010366a <env_destroy+0x2c>
		curenv = NULL;
f0103688:	e8 4a 25 00 00       	call   f0105bd7 <cpunum>
f010368d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103690:	c7 80 28 40 21 f0 00 	movl   $0x0,-0xfdebfd8(%eax)
f0103697:	00 00 00 
		sched_yield();
f010369a:	e8 32 0d 00 00       	call   f01043d1 <sched_yield>

f010369f <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f010369f:	55                   	push   %ebp
f01036a0:	89 e5                	mov    %esp,%ebp
f01036a2:	53                   	push   %ebx
f01036a3:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f01036a6:	e8 2c 25 00 00       	call   f0105bd7 <cpunum>
f01036ab:	6b c0 74             	imul   $0x74,%eax,%eax
f01036ae:	8b 98 28 40 21 f0    	mov    -0xfdebfd8(%eax),%ebx
f01036b4:	e8 1e 25 00 00       	call   f0105bd7 <cpunum>
f01036b9:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f01036bc:	8b 65 08             	mov    0x8(%ebp),%esp
f01036bf:	61                   	popa   
f01036c0:	07                   	pop    %es
f01036c1:	1f                   	pop    %ds
f01036c2:	83 c4 08             	add    $0x8,%esp
f01036c5:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f01036c6:	83 ec 04             	sub    $0x4,%esp
f01036c9:	68 84 74 10 f0       	push   $0xf0107484
f01036ce:	68 ff 01 00 00       	push   $0x1ff
f01036d3:	68 0e 74 10 f0       	push   $0xf010740e
f01036d8:	e8 63 c9 ff ff       	call   f0100040 <_panic>

f01036dd <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01036dd:	55                   	push   %ebp
f01036de:	89 e5                	mov    %esp,%ebp
f01036e0:	53                   	push   %ebx
f01036e1:	83 ec 04             	sub    $0x4,%esp
f01036e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Hint: This function loads the new environment's state from
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.
	// LAB 3: Your code here.
	if (curenv != e) {
f01036e7:	e8 eb 24 00 00       	call   f0105bd7 <cpunum>
f01036ec:	6b c0 74             	imul   $0x74,%eax,%eax
f01036ef:	39 98 28 40 21 f0    	cmp    %ebx,-0xfdebfd8(%eax)
f01036f5:	74 50                	je     f0103747 <env_run+0x6a>
		if (curenv && curenv->env_status == ENV_RUNNING)
f01036f7:	e8 db 24 00 00       	call   f0105bd7 <cpunum>
f01036fc:	6b c0 74             	imul   $0x74,%eax,%eax
f01036ff:	83 b8 28 40 21 f0 00 	cmpl   $0x0,-0xfdebfd8(%eax)
f0103706:	74 14                	je     f010371c <env_run+0x3f>
f0103708:	e8 ca 24 00 00       	call   f0105bd7 <cpunum>
f010370d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103710:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0103716:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010371a:	74 42                	je     f010375e <env_run+0x81>
			curenv->env_status = ENV_RUNNABLE;
		curenv = e;
f010371c:	e8 b6 24 00 00       	call   f0105bd7 <cpunum>
f0103721:	6b c0 74             	imul   $0x74,%eax,%eax
f0103724:	89 98 28 40 21 f0    	mov    %ebx,-0xfdebfd8(%eax)
		e->env_status = ENV_RUNNING;
f010372a:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
		e->env_runs++;
f0103731:	83 43 58 01          	addl   $0x1,0x58(%ebx)
		lcr3(PADDR(e->env_pgdir));
f0103735:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103738:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010373d:	76 36                	jbe    f0103775 <env_run+0x98>
	return (physaddr_t)kva - KERNBASE;
f010373f:	05 00 00 00 10       	add    $0x10000000,%eax
f0103744:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103747:	83 ec 0c             	sub    $0xc,%esp
f010374a:	68 80 14 12 f0       	push   $0xf0121480
f010374f:	e8 90 27 00 00       	call   f0105ee4 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103754:	f3 90                	pause  
	}
    unlock_kernel();
    env_pop_tf(&e->env_tf);
f0103756:	89 1c 24             	mov    %ebx,(%esp)
f0103759:	e8 41 ff ff ff       	call   f010369f <env_pop_tf>
			curenv->env_status = ENV_RUNNABLE;
f010375e:	e8 74 24 00 00       	call   f0105bd7 <cpunum>
f0103763:	6b c0 74             	imul   $0x74,%eax,%eax
f0103766:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f010376c:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103773:	eb a7                	jmp    f010371c <env_run+0x3f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103775:	50                   	push   %eax
f0103776:	68 68 62 10 f0       	push   $0xf0106268
f010377b:	68 22 02 00 00       	push   $0x222
f0103780:	68 0e 74 10 f0       	push   $0xf010740e
f0103785:	e8 b6 c8 ff ff       	call   f0100040 <_panic>

f010378a <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f010378a:	55                   	push   %ebp
f010378b:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010378d:	8b 45 08             	mov    0x8(%ebp),%eax
f0103790:	ba 70 00 00 00       	mov    $0x70,%edx
f0103795:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103796:	ba 71 00 00 00       	mov    $0x71,%edx
f010379b:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f010379c:	0f b6 c0             	movzbl %al,%eax
}
f010379f:	5d                   	pop    %ebp
f01037a0:	c3                   	ret    

f01037a1 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01037a1:	55                   	push   %ebp
f01037a2:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01037a4:	8b 45 08             	mov    0x8(%ebp),%eax
f01037a7:	ba 70 00 00 00       	mov    $0x70,%edx
f01037ac:	ee                   	out    %al,(%dx)
f01037ad:	8b 45 0c             	mov    0xc(%ebp),%eax
f01037b0:	ba 71 00 00 00       	mov    $0x71,%edx
f01037b5:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01037b6:	5d                   	pop    %ebp
f01037b7:	c3                   	ret    

f01037b8 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01037b8:	55                   	push   %ebp
f01037b9:	89 e5                	mov    %esp,%ebp
f01037bb:	56                   	push   %esi
f01037bc:	53                   	push   %ebx
f01037bd:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f01037c0:	66 a3 a8 13 12 f0    	mov    %ax,0xf01213a8
	if (!didinit)
f01037c6:	80 3d 4c 32 21 f0 00 	cmpb   $0x0,0xf021324c
f01037cd:	75 07                	jne    f01037d6 <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f01037cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01037d2:	5b                   	pop    %ebx
f01037d3:	5e                   	pop    %esi
f01037d4:	5d                   	pop    %ebp
f01037d5:	c3                   	ret    
f01037d6:	89 c6                	mov    %eax,%esi
f01037d8:	ba 21 00 00 00       	mov    $0x21,%edx
f01037dd:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f01037de:	66 c1 e8 08          	shr    $0x8,%ax
f01037e2:	ba a1 00 00 00       	mov    $0xa1,%edx
f01037e7:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01037e8:	83 ec 0c             	sub    $0xc,%esp
f01037eb:	68 c2 74 10 f0       	push   $0xf01074c2
f01037f0:	e8 1e 01 00 00       	call   f0103913 <cprintf>
f01037f5:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01037f8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f01037fd:	0f b7 f6             	movzwl %si,%esi
f0103800:	f7 d6                	not    %esi
f0103802:	eb 08                	jmp    f010380c <irq_setmask_8259A+0x54>
	for (i = 0; i < 16; i++)
f0103804:	83 c3 01             	add    $0x1,%ebx
f0103807:	83 fb 10             	cmp    $0x10,%ebx
f010380a:	74 18                	je     f0103824 <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f010380c:	0f a3 de             	bt     %ebx,%esi
f010380f:	73 f3                	jae    f0103804 <irq_setmask_8259A+0x4c>
			cprintf(" %d", i);
f0103811:	83 ec 08             	sub    $0x8,%esp
f0103814:	53                   	push   %ebx
f0103815:	68 7f 79 10 f0       	push   $0xf010797f
f010381a:	e8 f4 00 00 00       	call   f0103913 <cprintf>
f010381f:	83 c4 10             	add    $0x10,%esp
f0103822:	eb e0                	jmp    f0103804 <irq_setmask_8259A+0x4c>
	cprintf("\n");
f0103824:	83 ec 0c             	sub    $0xc,%esp
f0103827:	68 05 6a 10 f0       	push   $0xf0106a05
f010382c:	e8 e2 00 00 00       	call   f0103913 <cprintf>
f0103831:	83 c4 10             	add    $0x10,%esp
f0103834:	eb 99                	jmp    f01037cf <irq_setmask_8259A+0x17>

f0103836 <pic_init>:
{
f0103836:	55                   	push   %ebp
f0103837:	89 e5                	mov    %esp,%ebp
f0103839:	57                   	push   %edi
f010383a:	56                   	push   %esi
f010383b:	53                   	push   %ebx
f010383c:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f010383f:	c6 05 4c 32 21 f0 01 	movb   $0x1,0xf021324c
f0103846:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010384b:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103850:	89 da                	mov    %ebx,%edx
f0103852:	ee                   	out    %al,(%dx)
f0103853:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0103858:	89 ca                	mov    %ecx,%edx
f010385a:	ee                   	out    %al,(%dx)
f010385b:	bf 11 00 00 00       	mov    $0x11,%edi
f0103860:	be 20 00 00 00       	mov    $0x20,%esi
f0103865:	89 f8                	mov    %edi,%eax
f0103867:	89 f2                	mov    %esi,%edx
f0103869:	ee                   	out    %al,(%dx)
f010386a:	b8 20 00 00 00       	mov    $0x20,%eax
f010386f:	89 da                	mov    %ebx,%edx
f0103871:	ee                   	out    %al,(%dx)
f0103872:	b8 04 00 00 00       	mov    $0x4,%eax
f0103877:	ee                   	out    %al,(%dx)
f0103878:	b8 03 00 00 00       	mov    $0x3,%eax
f010387d:	ee                   	out    %al,(%dx)
f010387e:	bb a0 00 00 00       	mov    $0xa0,%ebx
f0103883:	89 f8                	mov    %edi,%eax
f0103885:	89 da                	mov    %ebx,%edx
f0103887:	ee                   	out    %al,(%dx)
f0103888:	b8 28 00 00 00       	mov    $0x28,%eax
f010388d:	89 ca                	mov    %ecx,%edx
f010388f:	ee                   	out    %al,(%dx)
f0103890:	b8 02 00 00 00       	mov    $0x2,%eax
f0103895:	ee                   	out    %al,(%dx)
f0103896:	b8 01 00 00 00       	mov    $0x1,%eax
f010389b:	ee                   	out    %al,(%dx)
f010389c:	bf 68 00 00 00       	mov    $0x68,%edi
f01038a1:	89 f8                	mov    %edi,%eax
f01038a3:	89 f2                	mov    %esi,%edx
f01038a5:	ee                   	out    %al,(%dx)
f01038a6:	b9 0a 00 00 00       	mov    $0xa,%ecx
f01038ab:	89 c8                	mov    %ecx,%eax
f01038ad:	ee                   	out    %al,(%dx)
f01038ae:	89 f8                	mov    %edi,%eax
f01038b0:	89 da                	mov    %ebx,%edx
f01038b2:	ee                   	out    %al,(%dx)
f01038b3:	89 c8                	mov    %ecx,%eax
f01038b5:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f01038b6:	0f b7 05 a8 13 12 f0 	movzwl 0xf01213a8,%eax
f01038bd:	66 83 f8 ff          	cmp    $0xffff,%ax
f01038c1:	74 0f                	je     f01038d2 <pic_init+0x9c>
		irq_setmask_8259A(irq_mask_8259A);
f01038c3:	83 ec 0c             	sub    $0xc,%esp
f01038c6:	0f b7 c0             	movzwl %ax,%eax
f01038c9:	50                   	push   %eax
f01038ca:	e8 e9 fe ff ff       	call   f01037b8 <irq_setmask_8259A>
f01038cf:	83 c4 10             	add    $0x10,%esp
}
f01038d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01038d5:	5b                   	pop    %ebx
f01038d6:	5e                   	pop    %esi
f01038d7:	5f                   	pop    %edi
f01038d8:	5d                   	pop    %ebp
f01038d9:	c3                   	ret    

f01038da <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01038da:	55                   	push   %ebp
f01038db:	89 e5                	mov    %esp,%ebp
f01038dd:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f01038e0:	ff 75 08             	pushl  0x8(%ebp)
f01038e3:	e8 cd ce ff ff       	call   f01007b5 <cputchar>
	*cnt++;
}
f01038e8:	83 c4 10             	add    $0x10,%esp
f01038eb:	c9                   	leave  
f01038ec:	c3                   	ret    

f01038ed <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01038ed:	55                   	push   %ebp
f01038ee:	89 e5                	mov    %esp,%ebp
f01038f0:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f01038f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01038fa:	ff 75 0c             	pushl  0xc(%ebp)
f01038fd:	ff 75 08             	pushl  0x8(%ebp)
f0103900:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103903:	50                   	push   %eax
f0103904:	68 da 38 10 f0       	push   $0xf01038da
f0103909:	e8 88 15 00 00       	call   f0104e96 <vprintfmt>
	return cnt;
}
f010390e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103911:	c9                   	leave  
f0103912:	c3                   	ret    

f0103913 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103913:	55                   	push   %ebp
f0103914:	89 e5                	mov    %esp,%ebp
f0103916:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103919:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f010391c:	50                   	push   %eax
f010391d:	ff 75 08             	pushl  0x8(%ebp)
f0103920:	e8 c8 ff ff ff       	call   f01038ed <vcprintf>
	va_end(ap);

	return cnt;
}
f0103925:	c9                   	leave  
f0103926:	c3                   	ret    

f0103927 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103927:	55                   	push   %ebp
f0103928:	89 e5                	mov    %esp,%ebp
f010392a:	57                   	push   %edi
f010392b:	56                   	push   %esi
f010392c:	53                   	push   %ebx
f010392d:	83 ec 0c             	sub    $0xc,%esp
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	int cpu_id = thiscpu->cpu_id;
f0103930:	e8 a2 22 00 00       	call   f0105bd7 <cpunum>
f0103935:	6b c0 74             	imul   $0x74,%eax,%eax
f0103938:	0f b6 b0 20 40 21 f0 	movzbl -0xfdebfe0(%eax),%esi
f010393f:	89 f0                	mov    %esi,%eax
f0103941:	0f b6 d8             	movzbl %al,%ebx
	struct Taskstate *this_ts = &thiscpu->cpu_ts;
f0103944:	e8 8e 22 00 00       	call   f0105bd7 <cpunum>
f0103949:	6b c0 74             	imul   $0x74,%eax,%eax
f010394c:	8d 90 2c 40 21 f0    	lea    -0xfdebfd4(%eax),%edx

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	this_ts->ts_esp0 = KSTACKTOP - cpu_id * (KSTKSIZE + KSTKGAP);
f0103952:	89 df                	mov    %ebx,%edi
f0103954:	c1 e7 10             	shl    $0x10,%edi
f0103957:	b9 00 00 00 f0       	mov    $0xf0000000,%ecx
f010395c:	29 f9                	sub    %edi,%ecx
f010395e:	89 88 30 40 21 f0    	mov    %ecx,-0xfdebfd0(%eax)
	this_ts->ts_ss0 = GD_KD;
f0103964:	66 c7 80 34 40 21 f0 	movw   $0x10,-0xfdebfcc(%eax)
f010396b:	10 00 
	this_ts->ts_iomb = sizeof(struct Taskstate);
f010396d:	66 c7 80 92 40 21 f0 	movw   $0x68,-0xfdebf6e(%eax)
f0103974:	68 00 

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3) + cpu_id] = SEG16(STS_T32A, (uint32_t) (this_ts),
f0103976:	8d 43 05             	lea    0x5(%ebx),%eax
f0103979:	66 c7 04 c5 40 13 12 	movw   $0x67,-0xfedecc0(,%eax,8)
f0103980:	f0 67 00 
f0103983:	66 89 14 c5 42 13 12 	mov    %dx,-0xfedecbe(,%eax,8)
f010398a:	f0 
f010398b:	89 d1                	mov    %edx,%ecx
f010398d:	c1 e9 10             	shr    $0x10,%ecx
f0103990:	88 0c c5 44 13 12 f0 	mov    %cl,-0xfedecbc(,%eax,8)
f0103997:	c6 04 c5 46 13 12 f0 	movb   $0x40,-0xfedecba(,%eax,8)
f010399e:	40 
f010399f:	c1 ea 18             	shr    $0x18,%edx
f01039a2:	88 14 c5 47 13 12 f0 	mov    %dl,-0xfedecb9(,%eax,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + cpu_id].sd_s = 0;
f01039a9:	c6 04 c5 45 13 12 f0 	movb   $0x89,-0xfedecbb(,%eax,8)
f01039b0:	89 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0 + (cpu_id << 3));
f01039b1:	89 f0                	mov    %esi,%eax
f01039b3:	0f b6 f0             	movzbl %al,%esi
f01039b6:	8d 34 f5 28 00 00 00 	lea    0x28(,%esi,8),%esi
	asm volatile("ltr %0" : : "r" (sel));
f01039bd:	0f 00 de             	ltr    %si
	asm volatile("lidt (%0)" : : "r" (p));
f01039c0:	b8 ac 13 12 f0       	mov    $0xf01213ac,%eax
f01039c5:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f01039c8:	83 c4 0c             	add    $0xc,%esp
f01039cb:	5b                   	pop    %ebx
f01039cc:	5e                   	pop    %esi
f01039cd:	5f                   	pop    %edi
f01039ce:	5d                   	pop    %ebp
f01039cf:	c3                   	ret    

f01039d0 <trap_init>:
{
f01039d0:	55                   	push   %ebp
f01039d1:	89 e5                	mov    %esp,%ebp
f01039d3:	57                   	push   %edi
f01039d4:	56                   	push   %esi
f01039d5:	53                   	push   %ebx
f01039d6:	83 ec 1c             	sub    $0x1c,%esp
	for (i = 0; i <= 16; ++i)
f01039d9:	b8 00 00 00 00       	mov    $0x0,%eax
		else if (i!=2 && i!=15) {
f01039de:	83 f8 02             	cmp    $0x2,%eax
f01039e1:	74 39                	je     f0103a1c <trap_init+0x4c>
f01039e3:	83 f8 0f             	cmp    $0xf,%eax
f01039e6:	74 34                	je     f0103a1c <trap_init+0x4c>
			SETGATE(idt[i], 0, GD_KT, funs[i], 0);
f01039e8:	8b 14 85 b4 13 12 f0 	mov    -0xfedec4c(,%eax,4),%edx
f01039ef:	66 89 14 c5 60 32 21 	mov    %dx,-0xfdecda0(,%eax,8)
f01039f6:	f0 
f01039f7:	66 c7 04 c5 62 32 21 	movw   $0x8,-0xfdecd9e(,%eax,8)
f01039fe:	f0 08 00 
f0103a01:	c6 04 c5 64 32 21 f0 	movb   $0x0,-0xfdecd9c(,%eax,8)
f0103a08:	00 
f0103a09:	c6 04 c5 65 32 21 f0 	movb   $0x8e,-0xfdecd9b(,%eax,8)
f0103a10:	8e 
f0103a11:	c1 ea 10             	shr    $0x10,%edx
f0103a14:	66 89 14 c5 66 32 21 	mov    %dx,-0xfdecd9a(,%eax,8)
f0103a1b:	f0 
f0103a1c:	0f b7 3d 78 32 21 f0 	movzwl 0xf0213278,%edi
f0103a23:	0f b7 35 7a 32 21 f0 	movzwl 0xf021327a,%esi
f0103a2a:	66 89 75 e6          	mov    %si,-0x1a(%ebp)
f0103a2e:	0f b6 15 7c 32 21 f0 	movzbl 0xf021327c,%edx
f0103a35:	89 d1                	mov    %edx,%ecx
f0103a37:	83 e1 1f             	and    $0x1f,%ecx
f0103a3a:	88 4d e5             	mov    %cl,-0x1b(%ebp)
f0103a3d:	c0 ea 05             	shr    $0x5,%dl
f0103a40:	88 55 e4             	mov    %dl,-0x1c(%ebp)
f0103a43:	0f b6 1d 7d 32 21 f0 	movzbl 0xf021327d,%ebx
f0103a4a:	89 d9                	mov    %ebx,%ecx
f0103a4c:	83 e1 0f             	and    $0xf,%ecx
f0103a4f:	88 4d e3             	mov    %cl,-0x1d(%ebp)
f0103a52:	89 d9                	mov    %ebx,%ecx
f0103a54:	c0 e9 04             	shr    $0x4,%cl
f0103a57:	83 e1 01             	and    $0x1,%ecx
f0103a5a:	89 da                	mov    %ebx,%edx
f0103a5c:	c0 ea 05             	shr    $0x5,%dl
f0103a5f:	83 e2 03             	and    $0x3,%edx
f0103a62:	c0 eb 07             	shr    $0x7,%bl
f0103a65:	88 5d e2             	mov    %bl,-0x1e(%ebp)
f0103a68:	0f b7 35 7e 32 21 f0 	movzwl 0xf021327e,%esi
	for (i = 0; i <= 16; ++i)
f0103a6f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103a74:	83 c0 01             	add    $0x1,%eax
f0103a77:	83 f8 10             	cmp    $0x10,%eax
f0103a7a:	0f 8f c0 00 00 00    	jg     f0103b40 <trap_init+0x170>
		if (i==T_BRKPT)
f0103a80:	83 f8 03             	cmp    $0x3,%eax
f0103a83:	74 1d                	je     f0103aa2 <trap_init+0xd2>
f0103a85:	84 db                	test   %bl,%bl
f0103a87:	75 4b                	jne    f0103ad4 <trap_init+0x104>
f0103a89:	84 db                	test   %bl,%bl
f0103a8b:	75 59                	jne    f0103ae6 <trap_init+0x116>
f0103a8d:	84 db                	test   %bl,%bl
f0103a8f:	75 65                	jne    f0103af6 <trap_init+0x126>
f0103a91:	84 db                	test   %bl,%bl
f0103a93:	75 7c                	jne    f0103b11 <trap_init+0x141>
f0103a95:	84 db                	test   %bl,%bl
f0103a97:	0f 84 41 ff ff ff    	je     f01039de <trap_init+0xe>
f0103a9d:	e9 92 00 00 00       	jmp    f0103b34 <trap_init+0x164>
			SETGATE(idt[i], 0, GD_KT, funs[i], 3)
f0103aa2:	8b 35 c0 13 12 f0    	mov    0xf01213c0,%esi
f0103aa8:	89 f7                	mov    %esi,%edi
f0103aaa:	bb 01 00 00 00       	mov    $0x1,%ebx
f0103aaf:	66 c7 45 e6 08 00    	movw   $0x8,-0x1a(%ebp)
f0103ab5:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
f0103ab9:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
f0103abd:	c6 45 e3 0e          	movb   $0xe,-0x1d(%ebp)
f0103ac1:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103ac6:	ba 03 00 00 00       	mov    $0x3,%edx
f0103acb:	c6 45 e2 01          	movb   $0x1,-0x1e(%ebp)
f0103acf:	c1 ee 10             	shr    $0x10,%esi
f0103ad2:	eb a0                	jmp    f0103a74 <trap_init+0xa4>
f0103ad4:	66 89 3d 78 32 21 f0 	mov    %di,0xf0213278
f0103adb:	0f b7 7d e6          	movzwl -0x1a(%ebp),%edi
f0103adf:	66 89 3d 7a 32 21 f0 	mov    %di,0xf021327a
f0103ae6:	0f b6 5d e4          	movzbl -0x1c(%ebp),%ebx
f0103aea:	c1 e3 05             	shl    $0x5,%ebx
f0103aed:	0a 5d e5             	or     -0x1b(%ebp),%bl
f0103af0:	88 1d 7c 32 21 f0    	mov    %bl,0xf021327c
f0103af6:	0f b6 1d 7d 32 21 f0 	movzbl 0xf021327d,%ebx
f0103afd:	83 e3 e0             	and    $0xffffffe0,%ebx
f0103b00:	83 e1 01             	and    $0x1,%ecx
f0103b03:	c1 e1 04             	shl    $0x4,%ecx
f0103b06:	0a 5d e3             	or     -0x1d(%ebp),%bl
f0103b09:	09 d9                	or     %ebx,%ecx
f0103b0b:	88 0d 7d 32 21 f0    	mov    %cl,0xf021327d
f0103b11:	83 e2 03             	and    $0x3,%edx
f0103b14:	89 d1                	mov    %edx,%ecx
f0103b16:	c1 e1 05             	shl    $0x5,%ecx
f0103b19:	0f b6 15 7d 32 21 f0 	movzbl 0xf021327d,%edx
f0103b20:	83 e2 1f             	and    $0x1f,%edx
f0103b23:	0f b6 5d e2          	movzbl -0x1e(%ebp),%ebx
f0103b27:	c1 e3 07             	shl    $0x7,%ebx
f0103b2a:	09 ca                	or     %ecx,%edx
f0103b2c:	09 da                	or     %ebx,%edx
f0103b2e:	88 15 7d 32 21 f0    	mov    %dl,0xf021327d
f0103b34:	66 89 35 7e 32 21 f0 	mov    %si,0xf021327e
f0103b3b:	e9 9e fe ff ff       	jmp    f01039de <trap_init+0xe>
f0103b40:	84 db                	test   %bl,%bl
f0103b42:	0f 85 99 00 00 00    	jne    f0103be1 <trap_init+0x211>
f0103b48:	84 db                	test   %bl,%bl
f0103b4a:	0f 85 a2 00 00 00    	jne    f0103bf2 <trap_init+0x222>
f0103b50:	84 db                	test   %bl,%bl
f0103b52:	0f 85 a9 00 00 00    	jne    f0103c01 <trap_init+0x231>
f0103b58:	84 db                	test   %bl,%bl
f0103b5a:	0f 85 bc 00 00 00    	jne    f0103c1c <trap_init+0x24c>
f0103b60:	84 db                	test   %bl,%bl
f0103b62:	0f 85 d7 00 00 00    	jne    f0103c3f <trap_init+0x26f>
	SETGATE(idt[48], 0, GD_KT, funs[48], 3);
f0103b68:	a1 74 14 12 f0       	mov    0xf0121474,%eax
f0103b6d:	66 a3 e0 33 21 f0    	mov    %ax,0xf02133e0
f0103b73:	66 c7 05 e2 33 21 f0 	movw   $0x8,0xf02133e2
f0103b7a:	08 00 
f0103b7c:	c6 05 e4 33 21 f0 00 	movb   $0x0,0xf02133e4
f0103b83:	c6 05 e5 33 21 f0 ee 	movb   $0xee,0xf02133e5
f0103b8a:	c1 e8 10             	shr    $0x10,%eax
f0103b8d:	66 a3 e6 33 21 f0    	mov    %ax,0xf02133e6
f0103b93:	b8 20 00 00 00       	mov    $0x20,%eax
		SETGATE(idt[IRQ_OFFSET+i], 0, GD_KT, funs[IRQ_OFFSET+i], 0);
f0103b98:	8b 14 85 b4 13 12 f0 	mov    -0xfedec4c(,%eax,4),%edx
f0103b9f:	66 89 14 c5 60 32 21 	mov    %dx,-0xfdecda0(,%eax,8)
f0103ba6:	f0 
f0103ba7:	66 c7 04 c5 62 32 21 	movw   $0x8,-0xfdecd9e(,%eax,8)
f0103bae:	f0 08 00 
f0103bb1:	c6 04 c5 64 32 21 f0 	movb   $0x0,-0xfdecd9c(,%eax,8)
f0103bb8:	00 
f0103bb9:	c6 04 c5 65 32 21 f0 	movb   $0x8e,-0xfdecd9b(,%eax,8)
f0103bc0:	8e 
f0103bc1:	c1 ea 10             	shr    $0x10,%edx
f0103bc4:	66 89 14 c5 66 32 21 	mov    %dx,-0xfdecd9a(,%eax,8)
f0103bcb:	f0 
f0103bcc:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < 16; ++i)
f0103bcf:	83 f8 30             	cmp    $0x30,%eax
f0103bd2:	75 c4                	jne    f0103b98 <trap_init+0x1c8>
	trap_init_percpu();
f0103bd4:	e8 4e fd ff ff       	call   f0103927 <trap_init_percpu>
}
f0103bd9:	83 c4 1c             	add    $0x1c,%esp
f0103bdc:	5b                   	pop    %ebx
f0103bdd:	5e                   	pop    %esi
f0103bde:	5f                   	pop    %edi
f0103bdf:	5d                   	pop    %ebp
f0103be0:	c3                   	ret    
f0103be1:	66 89 3d 78 32 21 f0 	mov    %di,0xf0213278
f0103be8:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
f0103bec:	66 a3 7a 32 21 f0    	mov    %ax,0xf021327a
f0103bf2:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
f0103bf6:	c1 e0 05             	shl    $0x5,%eax
f0103bf9:	0a 45 e5             	or     -0x1b(%ebp),%al
f0103bfc:	a2 7c 32 21 f0       	mov    %al,0xf021327c
f0103c01:	0f b6 05 7d 32 21 f0 	movzbl 0xf021327d,%eax
f0103c08:	83 e0 e0             	and    $0xffffffe0,%eax
f0103c0b:	83 e1 01             	and    $0x1,%ecx
f0103c0e:	c1 e1 04             	shl    $0x4,%ecx
f0103c11:	0a 45 e3             	or     -0x1d(%ebp),%al
f0103c14:	09 c1                	or     %eax,%ecx
f0103c16:	88 0d 7d 32 21 f0    	mov    %cl,0xf021327d
f0103c1c:	89 d0                	mov    %edx,%eax
f0103c1e:	83 e0 03             	and    $0x3,%eax
f0103c21:	c1 e0 05             	shl    $0x5,%eax
f0103c24:	0f b6 15 7d 32 21 f0 	movzbl 0xf021327d,%edx
f0103c2b:	83 e2 1f             	and    $0x1f,%edx
f0103c2e:	0f b6 5d e2          	movzbl -0x1e(%ebp),%ebx
f0103c32:	c1 e3 07             	shl    $0x7,%ebx
f0103c35:	09 d0                	or     %edx,%eax
f0103c37:	09 c3                	or     %eax,%ebx
f0103c39:	88 1d 7d 32 21 f0    	mov    %bl,0xf021327d
f0103c3f:	66 89 35 7e 32 21 f0 	mov    %si,0xf021327e
f0103c46:	e9 1d ff ff ff       	jmp    f0103b68 <trap_init+0x198>

f0103c4b <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0103c4b:	55                   	push   %ebp
f0103c4c:	89 e5                	mov    %esp,%ebp
f0103c4e:	53                   	push   %ebx
f0103c4f:	83 ec 0c             	sub    $0xc,%esp
f0103c52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103c55:	ff 33                	pushl  (%ebx)
f0103c57:	68 d6 74 10 f0       	push   $0xf01074d6
f0103c5c:	e8 b2 fc ff ff       	call   f0103913 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103c61:	83 c4 08             	add    $0x8,%esp
f0103c64:	ff 73 04             	pushl  0x4(%ebx)
f0103c67:	68 e5 74 10 f0       	push   $0xf01074e5
f0103c6c:	e8 a2 fc ff ff       	call   f0103913 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103c71:	83 c4 08             	add    $0x8,%esp
f0103c74:	ff 73 08             	pushl  0x8(%ebx)
f0103c77:	68 f4 74 10 f0       	push   $0xf01074f4
f0103c7c:	e8 92 fc ff ff       	call   f0103913 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103c81:	83 c4 08             	add    $0x8,%esp
f0103c84:	ff 73 0c             	pushl  0xc(%ebx)
f0103c87:	68 03 75 10 f0       	push   $0xf0107503
f0103c8c:	e8 82 fc ff ff       	call   f0103913 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103c91:	83 c4 08             	add    $0x8,%esp
f0103c94:	ff 73 10             	pushl  0x10(%ebx)
f0103c97:	68 12 75 10 f0       	push   $0xf0107512
f0103c9c:	e8 72 fc ff ff       	call   f0103913 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103ca1:	83 c4 08             	add    $0x8,%esp
f0103ca4:	ff 73 14             	pushl  0x14(%ebx)
f0103ca7:	68 21 75 10 f0       	push   $0xf0107521
f0103cac:	e8 62 fc ff ff       	call   f0103913 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103cb1:	83 c4 08             	add    $0x8,%esp
f0103cb4:	ff 73 18             	pushl  0x18(%ebx)
f0103cb7:	68 30 75 10 f0       	push   $0xf0107530
f0103cbc:	e8 52 fc ff ff       	call   f0103913 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103cc1:	83 c4 08             	add    $0x8,%esp
f0103cc4:	ff 73 1c             	pushl  0x1c(%ebx)
f0103cc7:	68 3f 75 10 f0       	push   $0xf010753f
f0103ccc:	e8 42 fc ff ff       	call   f0103913 <cprintf>
}
f0103cd1:	83 c4 10             	add    $0x10,%esp
f0103cd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103cd7:	c9                   	leave  
f0103cd8:	c3                   	ret    

f0103cd9 <print_trapframe>:
{
f0103cd9:	55                   	push   %ebp
f0103cda:	89 e5                	mov    %esp,%ebp
f0103cdc:	56                   	push   %esi
f0103cdd:	53                   	push   %ebx
f0103cde:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0103ce1:	e8 f1 1e 00 00       	call   f0105bd7 <cpunum>
f0103ce6:	83 ec 04             	sub    $0x4,%esp
f0103ce9:	50                   	push   %eax
f0103cea:	53                   	push   %ebx
f0103ceb:	68 a3 75 10 f0       	push   $0xf01075a3
f0103cf0:	e8 1e fc ff ff       	call   f0103913 <cprintf>
	print_regs(&tf->tf_regs);
f0103cf5:	89 1c 24             	mov    %ebx,(%esp)
f0103cf8:	e8 4e ff ff ff       	call   f0103c4b <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103cfd:	83 c4 08             	add    $0x8,%esp
f0103d00:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103d04:	50                   	push   %eax
f0103d05:	68 c1 75 10 f0       	push   $0xf01075c1
f0103d0a:	e8 04 fc ff ff       	call   f0103913 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103d0f:	83 c4 08             	add    $0x8,%esp
f0103d12:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103d16:	50                   	push   %eax
f0103d17:	68 d4 75 10 f0       	push   $0xf01075d4
f0103d1c:	e8 f2 fb ff ff       	call   f0103913 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103d21:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f0103d24:	83 c4 10             	add    $0x10,%esp
f0103d27:	83 f8 13             	cmp    $0x13,%eax
f0103d2a:	76 1f                	jbe    f0103d4b <print_trapframe+0x72>
		return "System call";
f0103d2c:	ba 4e 75 10 f0       	mov    $0xf010754e,%edx
	if (trapno == T_SYSCALL)
f0103d31:	83 f8 30             	cmp    $0x30,%eax
f0103d34:	74 1c                	je     f0103d52 <print_trapframe+0x79>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0103d36:	8d 50 e0             	lea    -0x20(%eax),%edx
	return "(unknown trap)";
f0103d39:	83 fa 10             	cmp    $0x10,%edx
f0103d3c:	ba 5a 75 10 f0       	mov    $0xf010755a,%edx
f0103d41:	b9 6d 75 10 f0       	mov    $0xf010756d,%ecx
f0103d46:	0f 43 d1             	cmovae %ecx,%edx
f0103d49:	eb 07                	jmp    f0103d52 <print_trapframe+0x79>
		return excnames[trapno];
f0103d4b:	8b 14 85 60 78 10 f0 	mov    -0xfef87a0(,%eax,4),%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103d52:	83 ec 04             	sub    $0x4,%esp
f0103d55:	52                   	push   %edx
f0103d56:	50                   	push   %eax
f0103d57:	68 e7 75 10 f0       	push   $0xf01075e7
f0103d5c:	e8 b2 fb ff ff       	call   f0103913 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103d61:	83 c4 10             	add    $0x10,%esp
f0103d64:	39 1d 60 3a 21 f0    	cmp    %ebx,0xf0213a60
f0103d6a:	0f 84 a6 00 00 00    	je     f0103e16 <print_trapframe+0x13d>
	cprintf("  err  0x%08x", tf->tf_err);
f0103d70:	83 ec 08             	sub    $0x8,%esp
f0103d73:	ff 73 2c             	pushl  0x2c(%ebx)
f0103d76:	68 08 76 10 f0       	push   $0xf0107608
f0103d7b:	e8 93 fb ff ff       	call   f0103913 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0103d80:	83 c4 10             	add    $0x10,%esp
f0103d83:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103d87:	0f 85 ac 00 00 00    	jne    f0103e39 <print_trapframe+0x160>
			tf->tf_err & 1 ? "protection" : "not-present");
f0103d8d:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0103d90:	89 c2                	mov    %eax,%edx
f0103d92:	83 e2 01             	and    $0x1,%edx
f0103d95:	b9 7c 75 10 f0       	mov    $0xf010757c,%ecx
f0103d9a:	ba 87 75 10 f0       	mov    $0xf0107587,%edx
f0103d9f:	0f 44 ca             	cmove  %edx,%ecx
f0103da2:	89 c2                	mov    %eax,%edx
f0103da4:	83 e2 02             	and    $0x2,%edx
f0103da7:	be 93 75 10 f0       	mov    $0xf0107593,%esi
f0103dac:	ba 99 75 10 f0       	mov    $0xf0107599,%edx
f0103db1:	0f 45 d6             	cmovne %esi,%edx
f0103db4:	83 e0 04             	and    $0x4,%eax
f0103db7:	b8 9e 75 10 f0       	mov    $0xf010759e,%eax
f0103dbc:	be e6 76 10 f0       	mov    $0xf01076e6,%esi
f0103dc1:	0f 44 c6             	cmove  %esi,%eax
f0103dc4:	51                   	push   %ecx
f0103dc5:	52                   	push   %edx
f0103dc6:	50                   	push   %eax
f0103dc7:	68 16 76 10 f0       	push   $0xf0107616
f0103dcc:	e8 42 fb ff ff       	call   f0103913 <cprintf>
f0103dd1:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0103dd4:	83 ec 08             	sub    $0x8,%esp
f0103dd7:	ff 73 30             	pushl  0x30(%ebx)
f0103dda:	68 25 76 10 f0       	push   $0xf0107625
f0103ddf:	e8 2f fb ff ff       	call   f0103913 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0103de4:	83 c4 08             	add    $0x8,%esp
f0103de7:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0103deb:	50                   	push   %eax
f0103dec:	68 34 76 10 f0       	push   $0xf0107634
f0103df1:	e8 1d fb ff ff       	call   f0103913 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0103df6:	83 c4 08             	add    $0x8,%esp
f0103df9:	ff 73 38             	pushl  0x38(%ebx)
f0103dfc:	68 47 76 10 f0       	push   $0xf0107647
f0103e01:	e8 0d fb ff ff       	call   f0103913 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0103e06:	83 c4 10             	add    $0x10,%esp
f0103e09:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103e0d:	75 3c                	jne    f0103e4b <print_trapframe+0x172>
}
f0103e0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103e12:	5b                   	pop    %ebx
f0103e13:	5e                   	pop    %esi
f0103e14:	5d                   	pop    %ebp
f0103e15:	c3                   	ret    
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103e16:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103e1a:	0f 85 50 ff ff ff    	jne    f0103d70 <print_trapframe+0x97>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0103e20:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0103e23:	83 ec 08             	sub    $0x8,%esp
f0103e26:	50                   	push   %eax
f0103e27:	68 f9 75 10 f0       	push   $0xf01075f9
f0103e2c:	e8 e2 fa ff ff       	call   f0103913 <cprintf>
f0103e31:	83 c4 10             	add    $0x10,%esp
f0103e34:	e9 37 ff ff ff       	jmp    f0103d70 <print_trapframe+0x97>
		cprintf("\n");
f0103e39:	83 ec 0c             	sub    $0xc,%esp
f0103e3c:	68 05 6a 10 f0       	push   $0xf0106a05
f0103e41:	e8 cd fa ff ff       	call   f0103913 <cprintf>
f0103e46:	83 c4 10             	add    $0x10,%esp
f0103e49:	eb 89                	jmp    f0103dd4 <print_trapframe+0xfb>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0103e4b:	83 ec 08             	sub    $0x8,%esp
f0103e4e:	ff 73 3c             	pushl  0x3c(%ebx)
f0103e51:	68 56 76 10 f0       	push   $0xf0107656
f0103e56:	e8 b8 fa ff ff       	call   f0103913 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0103e5b:	83 c4 08             	add    $0x8,%esp
f0103e5e:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0103e62:	50                   	push   %eax
f0103e63:	68 65 76 10 f0       	push   $0xf0107665
f0103e68:	e8 a6 fa ff ff       	call   f0103913 <cprintf>
f0103e6d:	83 c4 10             	add    $0x10,%esp
}
f0103e70:	eb 9d                	jmp    f0103e0f <print_trapframe+0x136>

f0103e72 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0103e72:	55                   	push   %ebp
f0103e73:	89 e5                	mov    %esp,%ebp
f0103e75:	57                   	push   %edi
f0103e76:	56                   	push   %esi
f0103e77:	53                   	push   %ebx
f0103e78:	83 ec 0c             	sub    $0xc,%esp
f0103e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0103e7e:	0f 20 d6             	mov    %cr2,%esi
	// cprintf("fault_va: %x\n", fault_va);

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if ((tf->tf_cs&3) == 0) {
f0103e81:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103e85:	74 5d                	je     f0103ee4 <page_fault_handler+0x72>
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	if (curenv->env_pgfault_upcall) {
f0103e87:	e8 4b 1d 00 00       	call   f0105bd7 <cpunum>
f0103e8c:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e8f:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0103e95:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0103e99:	75 60                	jne    f0103efb <page_fault_handler+0x89>
		curenv->env_tf.tf_esp = utf_addr;
		env_run(curenv);
	}

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0103e9b:	8b 7b 30             	mov    0x30(%ebx),%edi
		curenv->env_id, fault_va, tf->tf_eip);
f0103e9e:	e8 34 1d 00 00       	call   f0105bd7 <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0103ea3:	57                   	push   %edi
f0103ea4:	56                   	push   %esi
		curenv->env_id, fault_va, tf->tf_eip);
f0103ea5:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0103ea8:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0103eae:	ff 70 48             	pushl  0x48(%eax)
f0103eb1:	68 30 78 10 f0       	push   $0xf0107830
f0103eb6:	e8 58 fa ff ff       	call   f0103913 <cprintf>
	print_trapframe(tf);
f0103ebb:	89 1c 24             	mov    %ebx,(%esp)
f0103ebe:	e8 16 fe ff ff       	call   f0103cd9 <print_trapframe>
	env_destroy(curenv);
f0103ec3:	e8 0f 1d 00 00       	call   f0105bd7 <cpunum>
f0103ec8:	83 c4 04             	add    $0x4,%esp
f0103ecb:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ece:	ff b0 28 40 21 f0    	pushl  -0xfdebfd8(%eax)
f0103ed4:	e8 65 f7 ff ff       	call   f010363e <env_destroy>
}
f0103ed9:	83 c4 10             	add    $0x10,%esp
f0103edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103edf:	5b                   	pop    %ebx
f0103ee0:	5e                   	pop    %esi
f0103ee1:	5f                   	pop    %edi
f0103ee2:	5d                   	pop    %ebp
f0103ee3:	c3                   	ret    
		panic("Kernel page fault!");
f0103ee4:	83 ec 04             	sub    $0x4,%esp
f0103ee7:	68 78 76 10 f0       	push   $0xf0107678
f0103eec:	68 4b 01 00 00       	push   $0x14b
f0103ef1:	68 8b 76 10 f0       	push   $0xf010768b
f0103ef6:	e8 45 c1 ff ff       	call   f0100040 <_panic>
		if (UXSTACKTOP-PGSIZE<=tf->tf_esp && tf->tf_esp<=UXSTACKTOP-1)
f0103efb:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0103efe:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
			utf_addr = UXSTACKTOP - sizeof(struct UTrapframe);
f0103f04:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if (UXSTACKTOP-PGSIZE<=tf->tf_esp && tf->tf_esp<=UXSTACKTOP-1)
f0103f09:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f0103f0f:	77 05                	ja     f0103f16 <page_fault_handler+0xa4>
			utf_addr = tf->tf_esp - sizeof(struct UTrapframe) - 4;
f0103f11:	83 e8 38             	sub    $0x38,%eax
f0103f14:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (void*)utf_addr, sizeof(struct UTrapframe), PTE_W);//1 is enough
f0103f16:	e8 bc 1c 00 00       	call   f0105bd7 <cpunum>
f0103f1b:	6a 02                	push   $0x2
f0103f1d:	6a 34                	push   $0x34
f0103f1f:	57                   	push   %edi
f0103f20:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f23:	ff b0 28 40 21 f0    	pushl  -0xfdebfd8(%eax)
f0103f29:	e8 5b f0 ff ff       	call   f0102f89 <user_mem_assert>
		utf->utf_fault_va = fault_va;
f0103f2e:	89 fa                	mov    %edi,%edx
f0103f30:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_err;
f0103f32:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0103f35:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f0103f38:	8d 7f 08             	lea    0x8(%edi),%edi
f0103f3b:	b9 08 00 00 00       	mov    $0x8,%ecx
f0103f40:	89 de                	mov    %ebx,%esi
f0103f42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f0103f44:	8b 43 30             	mov    0x30(%ebx),%eax
f0103f47:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f0103f4a:	8b 43 38             	mov    0x38(%ebx),%eax
f0103f4d:	89 d7                	mov    %edx,%edi
f0103f4f:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f0103f52:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0103f55:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0103f58:	e8 7a 1c 00 00       	call   f0105bd7 <cpunum>
f0103f5d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f60:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0103f66:	8b 58 64             	mov    0x64(%eax),%ebx
f0103f69:	e8 69 1c 00 00       	call   f0105bd7 <cpunum>
f0103f6e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f71:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0103f77:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = utf_addr;
f0103f7a:	e8 58 1c 00 00       	call   f0105bd7 <cpunum>
f0103f7f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f82:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0103f88:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f0103f8b:	e8 47 1c 00 00       	call   f0105bd7 <cpunum>
f0103f90:	83 c4 04             	add    $0x4,%esp
f0103f93:	6b c0 74             	imul   $0x74,%eax,%eax
f0103f96:	ff b0 28 40 21 f0    	pushl  -0xfdebfd8(%eax)
f0103f9c:	e8 3c f7 ff ff       	call   f01036dd <env_run>

f0103fa1 <trap>:
{
f0103fa1:	55                   	push   %ebp
f0103fa2:	89 e5                	mov    %esp,%ebp
f0103fa4:	57                   	push   %edi
f0103fa5:	56                   	push   %esi
f0103fa6:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0103fa9:	fc                   	cld    
	if (panicstr)
f0103faa:	83 3d 80 3e 21 f0 00 	cmpl   $0x0,0xf0213e80
f0103fb1:	74 01                	je     f0103fb4 <trap+0x13>
		asm volatile("hlt");
f0103fb3:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0103fb4:	e8 1e 1c 00 00       	call   f0105bd7 <cpunum>
f0103fb9:	6b d0 74             	imul   $0x74,%eax,%edx
f0103fbc:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0103fbf:	b8 01 00 00 00       	mov    $0x1,%eax
f0103fc4:	f0 87 82 20 40 21 f0 	lock xchg %eax,-0xfdebfe0(%edx)
f0103fcb:	83 f8 02             	cmp    $0x2,%eax
f0103fce:	0f 84 c2 00 00 00    	je     f0104096 <trap+0xf5>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0103fd4:	9c                   	pushf  
f0103fd5:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f0103fd6:	f6 c4 02             	test   $0x2,%ah
f0103fd9:	0f 85 cc 00 00 00    	jne    f01040ab <trap+0x10a>
	if ((tf->tf_cs & 3) == 3) {
f0103fdf:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0103fe3:	83 e0 03             	and    $0x3,%eax
f0103fe6:	66 83 f8 03          	cmp    $0x3,%ax
f0103fea:	0f 84 d4 00 00 00    	je     f01040c4 <trap+0x123>
	last_tf = tf;
f0103ff0:	89 35 60 3a 21 f0    	mov    %esi,0xf0213a60
	if (tf->tf_trapno == T_PGFLT) {
f0103ff6:	8b 46 28             	mov    0x28(%esi),%eax
f0103ff9:	83 f8 0e             	cmp    $0xe,%eax
f0103ffc:	0f 84 67 01 00 00    	je     f0104169 <trap+0x1c8>
	if (tf->tf_trapno == T_BRKPT) {
f0104002:	83 f8 03             	cmp    $0x3,%eax
f0104005:	0f 84 6f 01 00 00    	je     f010417a <trap+0x1d9>
	if (tf->tf_trapno == T_SYSCALL) {
f010400b:	83 f8 30             	cmp    $0x30,%eax
f010400e:	0f 84 77 01 00 00    	je     f010418b <trap+0x1ea>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0104014:	83 f8 27             	cmp    $0x27,%eax
f0104017:	0f 84 92 01 00 00    	je     f01041af <trap+0x20e>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f010401d:	83 f8 20             	cmp    $0x20,%eax
f0104020:	0f 84 a6 01 00 00    	je     f01041cc <trap+0x22b>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD)
f0104026:	83 f8 21             	cmp    $0x21,%eax
f0104029:	0f 84 a7 01 00 00    	je     f01041d6 <trap+0x235>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL)
f010402f:	83 f8 24             	cmp    $0x24,%eax
f0104032:	0f 84 a8 01 00 00    	je     f01041e0 <trap+0x23f>
	print_trapframe(tf);
f0104038:	83 ec 0c             	sub    $0xc,%esp
f010403b:	56                   	push   %esi
f010403c:	e8 98 fc ff ff       	call   f0103cd9 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0104041:	83 c4 10             	add    $0x10,%esp
f0104044:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104049:	0f 84 9b 01 00 00    	je     f01041ea <trap+0x249>
		env_destroy(curenv);
f010404f:	e8 83 1b 00 00       	call   f0105bd7 <cpunum>
f0104054:	83 ec 0c             	sub    $0xc,%esp
f0104057:	6b c0 74             	imul   $0x74,%eax,%eax
f010405a:	ff b0 28 40 21 f0    	pushl  -0xfdebfd8(%eax)
f0104060:	e8 d9 f5 ff ff       	call   f010363e <env_destroy>
f0104065:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104068:	e8 6a 1b 00 00       	call   f0105bd7 <cpunum>
f010406d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104070:	83 b8 28 40 21 f0 00 	cmpl   $0x0,-0xfdebfd8(%eax)
f0104077:	74 18                	je     f0104091 <trap+0xf0>
f0104079:	e8 59 1b 00 00       	call   f0105bd7 <cpunum>
f010407e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104081:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0104087:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010408b:	0f 84 70 01 00 00    	je     f0104201 <trap+0x260>
		sched_yield();
f0104091:	e8 3b 03 00 00       	call   f01043d1 <sched_yield>
	spin_lock(&kernel_lock);
f0104096:	83 ec 0c             	sub    $0xc,%esp
f0104099:	68 80 14 12 f0       	push   $0xf0121480
f010409e:	e8 a4 1d 00 00       	call   f0105e47 <spin_lock>
f01040a3:	83 c4 10             	add    $0x10,%esp
f01040a6:	e9 29 ff ff ff       	jmp    f0103fd4 <trap+0x33>
	assert(!(read_eflags() & FL_IF));
f01040ab:	68 97 76 10 f0       	push   $0xf0107697
f01040b0:	68 91 67 10 f0       	push   $0xf0106791
f01040b5:	68 13 01 00 00       	push   $0x113
f01040ba:	68 8b 76 10 f0       	push   $0xf010768b
f01040bf:	e8 7c bf ff ff       	call   f0100040 <_panic>
f01040c4:	83 ec 0c             	sub    $0xc,%esp
f01040c7:	68 80 14 12 f0       	push   $0xf0121480
f01040cc:	e8 76 1d 00 00       	call   f0105e47 <spin_lock>
		assert(curenv);
f01040d1:	e8 01 1b 00 00       	call   f0105bd7 <cpunum>
f01040d6:	6b c0 74             	imul   $0x74,%eax,%eax
f01040d9:	83 c4 10             	add    $0x10,%esp
f01040dc:	83 b8 28 40 21 f0 00 	cmpl   $0x0,-0xfdebfd8(%eax)
f01040e3:	74 3e                	je     f0104123 <trap+0x182>
		if (curenv->env_status == ENV_DYING) {
f01040e5:	e8 ed 1a 00 00       	call   f0105bd7 <cpunum>
f01040ea:	6b c0 74             	imul   $0x74,%eax,%eax
f01040ed:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f01040f3:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01040f7:	74 43                	je     f010413c <trap+0x19b>
		curenv->env_tf = *tf;
f01040f9:	e8 d9 1a 00 00       	call   f0105bd7 <cpunum>
f01040fe:	6b c0 74             	imul   $0x74,%eax,%eax
f0104101:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0104107:	b9 11 00 00 00       	mov    $0x11,%ecx
f010410c:	89 c7                	mov    %eax,%edi
f010410e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104110:	e8 c2 1a 00 00       	call   f0105bd7 <cpunum>
f0104115:	6b c0 74             	imul   $0x74,%eax,%eax
f0104118:	8b b0 28 40 21 f0    	mov    -0xfdebfd8(%eax),%esi
f010411e:	e9 cd fe ff ff       	jmp    f0103ff0 <trap+0x4f>
		assert(curenv);
f0104123:	68 b0 76 10 f0       	push   $0xf01076b0
f0104128:	68 91 67 10 f0       	push   $0xf0106791
f010412d:	68 1c 01 00 00       	push   $0x11c
f0104132:	68 8b 76 10 f0       	push   $0xf010768b
f0104137:	e8 04 bf ff ff       	call   f0100040 <_panic>
			env_free(curenv);
f010413c:	e8 96 1a 00 00       	call   f0105bd7 <cpunum>
f0104141:	83 ec 0c             	sub    $0xc,%esp
f0104144:	6b c0 74             	imul   $0x74,%eax,%eax
f0104147:	ff b0 28 40 21 f0    	pushl  -0xfdebfd8(%eax)
f010414d:	e8 fe f2 ff ff       	call   f0103450 <env_free>
			curenv = NULL;
f0104152:	e8 80 1a 00 00       	call   f0105bd7 <cpunum>
f0104157:	6b c0 74             	imul   $0x74,%eax,%eax
f010415a:	c7 80 28 40 21 f0 00 	movl   $0x0,-0xfdebfd8(%eax)
f0104161:	00 00 00 
			sched_yield();
f0104164:	e8 68 02 00 00       	call   f01043d1 <sched_yield>
		page_fault_handler(tf);
f0104169:	83 ec 0c             	sub    $0xc,%esp
f010416c:	56                   	push   %esi
f010416d:	e8 00 fd ff ff       	call   f0103e72 <page_fault_handler>
f0104172:	83 c4 10             	add    $0x10,%esp
f0104175:	e9 ee fe ff ff       	jmp    f0104068 <trap+0xc7>
		monitor(tf);
f010417a:	83 ec 0c             	sub    $0xc,%esp
f010417d:	56                   	push   %esi
f010417e:	e8 3f c7 ff ff       	call   f01008c2 <monitor>
f0104183:	83 c4 10             	add    $0x10,%esp
f0104186:	e9 dd fe ff ff       	jmp    f0104068 <trap+0xc7>
			syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx,
f010418b:	83 ec 08             	sub    $0x8,%esp
f010418e:	ff 76 04             	pushl  0x4(%esi)
f0104191:	ff 36                	pushl  (%esi)
f0104193:	ff 76 10             	pushl  0x10(%esi)
f0104196:	ff 76 18             	pushl  0x18(%esi)
f0104199:	ff 76 14             	pushl  0x14(%esi)
f010419c:	ff 76 1c             	pushl  0x1c(%esi)
f010419f:	e8 e1 02 00 00       	call   f0104485 <syscall>
		tf->tf_regs.reg_eax = 
f01041a4:	89 46 1c             	mov    %eax,0x1c(%esi)
f01041a7:	83 c4 20             	add    $0x20,%esp
f01041aa:	e9 b9 fe ff ff       	jmp    f0104068 <trap+0xc7>
		cprintf("Spurious interrupt on irq 7\n");
f01041af:	83 ec 0c             	sub    $0xc,%esp
f01041b2:	68 b7 76 10 f0       	push   $0xf01076b7
f01041b7:	e8 57 f7 ff ff       	call   f0103913 <cprintf>
		print_trapframe(tf);
f01041bc:	89 34 24             	mov    %esi,(%esp)
f01041bf:	e8 15 fb ff ff       	call   f0103cd9 <print_trapframe>
f01041c4:	83 c4 10             	add    $0x10,%esp
f01041c7:	e9 9c fe ff ff       	jmp    f0104068 <trap+0xc7>
		lapic_eoi();
f01041cc:	e8 52 1b 00 00       	call   f0105d23 <lapic_eoi>
		sched_yield();
f01041d1:	e8 fb 01 00 00       	call   f01043d1 <sched_yield>
		kbd_intr();
f01041d6:	e8 33 c4 ff ff       	call   f010060e <kbd_intr>
f01041db:	e9 88 fe ff ff       	jmp    f0104068 <trap+0xc7>
		serial_intr();
f01041e0:	e8 0c c4 ff ff       	call   f01005f1 <serial_intr>
f01041e5:	e9 7e fe ff ff       	jmp    f0104068 <trap+0xc7>
		panic("unhandled trap in kernel");
f01041ea:	83 ec 04             	sub    $0x4,%esp
f01041ed:	68 d4 76 10 f0       	push   $0xf01076d4
f01041f2:	68 f9 00 00 00       	push   $0xf9
f01041f7:	68 8b 76 10 f0       	push   $0xf010768b
f01041fc:	e8 3f be ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f0104201:	e8 d1 19 00 00       	call   f0105bd7 <cpunum>
f0104206:	83 ec 0c             	sub    $0xc,%esp
f0104209:	6b c0 74             	imul   $0x74,%eax,%eax
f010420c:	ff b0 28 40 21 f0    	pushl  -0xfdebfd8(%eax)
f0104212:	e8 c6 f4 ff ff       	call   f01036dd <env_run>
f0104217:	90                   	nop

f0104218 <th0>:
funs:
.text
/*
 * Challenge: my code here
 */
	noec(th0, 0)
f0104218:	6a 00                	push   $0x0
f010421a:	6a 00                	push   $0x0
f010421c:	e9 cf 00 00 00       	jmp    f01042f0 <_alltraps>
f0104221:	90                   	nop

f0104222 <th1>:
	noec(th1, 1)
f0104222:	6a 00                	push   $0x0
f0104224:	6a 01                	push   $0x1
f0104226:	e9 c5 00 00 00       	jmp    f01042f0 <_alltraps>
f010422b:	90                   	nop

f010422c <th3>:
	fun()
	noec(th3, 3)
f010422c:	6a 00                	push   $0x0
f010422e:	6a 03                	push   $0x3
f0104230:	e9 bb 00 00 00       	jmp    f01042f0 <_alltraps>
f0104235:	90                   	nop

f0104236 <th4>:
	noec(th4, 4)
f0104236:	6a 00                	push   $0x0
f0104238:	6a 04                	push   $0x4
f010423a:	e9 b1 00 00 00       	jmp    f01042f0 <_alltraps>
f010423f:	90                   	nop

f0104240 <th5>:
	noec(th5, 5)
f0104240:	6a 00                	push   $0x0
f0104242:	6a 05                	push   $0x5
f0104244:	e9 a7 00 00 00       	jmp    f01042f0 <_alltraps>
f0104249:	90                   	nop

f010424a <th6>:
	noec(th6, 6)
f010424a:	6a 00                	push   $0x0
f010424c:	6a 06                	push   $0x6
f010424e:	e9 9d 00 00 00       	jmp    f01042f0 <_alltraps>
f0104253:	90                   	nop

f0104254 <th7>:
	noec(th7, 7)
f0104254:	6a 00                	push   $0x0
f0104256:	6a 07                	push   $0x7
f0104258:	e9 93 00 00 00       	jmp    f01042f0 <_alltraps>
f010425d:	90                   	nop

f010425e <th8>:
	ec(th8, 8)
f010425e:	6a 08                	push   $0x8
f0104260:	e9 8b 00 00 00       	jmp    f01042f0 <_alltraps>
f0104265:	90                   	nop

f0104266 <th9>:
	noec(th9, 9)
f0104266:	6a 00                	push   $0x0
f0104268:	6a 09                	push   $0x9
f010426a:	e9 81 00 00 00       	jmp    f01042f0 <_alltraps>
f010426f:	90                   	nop

f0104270 <th10>:
	ec(th10, 10)
f0104270:	6a 0a                	push   $0xa
f0104272:	eb 7c                	jmp    f01042f0 <_alltraps>

f0104274 <th11>:
	ec(th11, 11)
f0104274:	6a 0b                	push   $0xb
f0104276:	eb 78                	jmp    f01042f0 <_alltraps>

f0104278 <th12>:
	ec(th12, 12)
f0104278:	6a 0c                	push   $0xc
f010427a:	eb 74                	jmp    f01042f0 <_alltraps>

f010427c <th13>:
	ec(th13, 13)
f010427c:	6a 0d                	push   $0xd
f010427e:	eb 70                	jmp    f01042f0 <_alltraps>

f0104280 <th14>:
	ec(th14, 14)
f0104280:	6a 0e                	push   $0xe
f0104282:	eb 6c                	jmp    f01042f0 <_alltraps>

f0104284 <th16>:
	fun()
	noec(th16, 16)
f0104284:	6a 00                	push   $0x0
f0104286:	6a 10                	push   $0x10
f0104288:	eb 66                	jmp    f01042f0 <_alltraps>

f010428a <th32>:
.data
	.space 60
.text
	noec(th32, 32)
f010428a:	6a 00                	push   $0x0
f010428c:	6a 20                	push   $0x20
f010428e:	eb 60                	jmp    f01042f0 <_alltraps>

f0104290 <th33>:
	noec(th33, 33)
f0104290:	6a 00                	push   $0x0
f0104292:	6a 21                	push   $0x21
f0104294:	eb 5a                	jmp    f01042f0 <_alltraps>

f0104296 <th34>:
	noec(th34, 34)
f0104296:	6a 00                	push   $0x0
f0104298:	6a 22                	push   $0x22
f010429a:	eb 54                	jmp    f01042f0 <_alltraps>

f010429c <th35>:
	noec(th35, 35)
f010429c:	6a 00                	push   $0x0
f010429e:	6a 23                	push   $0x23
f01042a0:	eb 4e                	jmp    f01042f0 <_alltraps>

f01042a2 <th36>:
	noec(th36, 36)
f01042a2:	6a 00                	push   $0x0
f01042a4:	6a 24                	push   $0x24
f01042a6:	eb 48                	jmp    f01042f0 <_alltraps>

f01042a8 <th37>:
	noec(th37, 37)
f01042a8:	6a 00                	push   $0x0
f01042aa:	6a 25                	push   $0x25
f01042ac:	eb 42                	jmp    f01042f0 <_alltraps>

f01042ae <th38>:
	noec(th38, 38)
f01042ae:	6a 00                	push   $0x0
f01042b0:	6a 26                	push   $0x26
f01042b2:	eb 3c                	jmp    f01042f0 <_alltraps>

f01042b4 <th39>:
	noec(th39, 39)
f01042b4:	6a 00                	push   $0x0
f01042b6:	6a 27                	push   $0x27
f01042b8:	eb 36                	jmp    f01042f0 <_alltraps>

f01042ba <th40>:
	noec(th40, 40)
f01042ba:	6a 00                	push   $0x0
f01042bc:	6a 28                	push   $0x28
f01042be:	eb 30                	jmp    f01042f0 <_alltraps>

f01042c0 <th41>:
	noec(th41, 41)
f01042c0:	6a 00                	push   $0x0
f01042c2:	6a 29                	push   $0x29
f01042c4:	eb 2a                	jmp    f01042f0 <_alltraps>

f01042c6 <th42>:
	noec(th42, 42)
f01042c6:	6a 00                	push   $0x0
f01042c8:	6a 2a                	push   $0x2a
f01042ca:	eb 24                	jmp    f01042f0 <_alltraps>

f01042cc <th43>:
	noec(th43, 43)
f01042cc:	6a 00                	push   $0x0
f01042ce:	6a 2b                	push   $0x2b
f01042d0:	eb 1e                	jmp    f01042f0 <_alltraps>

f01042d2 <th44>:
	noec(th44, 44)
f01042d2:	6a 00                	push   $0x0
f01042d4:	6a 2c                	push   $0x2c
f01042d6:	eb 18                	jmp    f01042f0 <_alltraps>

f01042d8 <th45>:
	noec(th45, 45)
f01042d8:	6a 00                	push   $0x0
f01042da:	6a 2d                	push   $0x2d
f01042dc:	eb 12                	jmp    f01042f0 <_alltraps>

f01042de <th46>:
	noec(th46, 46)
f01042de:	6a 00                	push   $0x0
f01042e0:	6a 2e                	push   $0x2e
f01042e2:	eb 0c                	jmp    f01042f0 <_alltraps>

f01042e4 <th47>:
	noec(th47, 47)
f01042e4:	6a 00                	push   $0x0
f01042e6:	6a 2f                	push   $0x2f
f01042e8:	eb 06                	jmp    f01042f0 <_alltraps>

f01042ea <th48>:
	noec(th48, 48)
f01042ea:	6a 00                	push   $0x0
f01042ec:	6a 30                	push   $0x30
f01042ee:	eb 00                	jmp    f01042f0 <_alltraps>

f01042f0 <_alltraps>:

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl %ds
f01042f0:	1e                   	push   %ds
	pushl %es
f01042f1:	06                   	push   %es
	pushal
f01042f2:	60                   	pusha  
	pushl $GD_KD
f01042f3:	6a 10                	push   $0x10
	popl %ds
f01042f5:	1f                   	pop    %ds
	pushl $GD_KD
f01042f6:	6a 10                	push   $0x10
	popl %es
f01042f8:	07                   	pop    %es
	pushl %esp
f01042f9:	54                   	push   %esp
	call trap
f01042fa:	e8 a2 fc ff ff       	call   f0103fa1 <trap>

f01042ff <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f01042ff:	55                   	push   %ebp
f0104300:	89 e5                	mov    %esp,%ebp
f0104302:	83 ec 08             	sub    $0x8,%esp
f0104305:	a1 44 32 21 f0       	mov    0xf0213244,%eax
f010430a:	83 c0 54             	add    $0x54,%eax
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f010430d:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f0104312:	8b 10                	mov    (%eax),%edx
f0104314:	83 ea 01             	sub    $0x1,%edx
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104317:	83 fa 02             	cmp    $0x2,%edx
f010431a:	76 2d                	jbe    f0104349 <sched_halt+0x4a>
	for (i = 0; i < NENV; i++) {
f010431c:	83 c1 01             	add    $0x1,%ecx
f010431f:	83 c0 7c             	add    $0x7c,%eax
f0104322:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f0104328:	75 e8                	jne    f0104312 <sched_halt+0x13>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f010432a:	83 ec 0c             	sub    $0xc,%esp
f010432d:	68 b0 78 10 f0       	push   $0xf01078b0
f0104332:	e8 dc f5 ff ff       	call   f0103913 <cprintf>
f0104337:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f010433a:	83 ec 0c             	sub    $0xc,%esp
f010433d:	6a 00                	push   $0x0
f010433f:	e8 7e c5 ff ff       	call   f01008c2 <monitor>
f0104344:	83 c4 10             	add    $0x10,%esp
f0104347:	eb f1                	jmp    f010433a <sched_halt+0x3b>
	if (i == NENV) {
f0104349:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f010434f:	74 d9                	je     f010432a <sched_halt+0x2b>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104351:	e8 81 18 00 00       	call   f0105bd7 <cpunum>
f0104356:	6b c0 74             	imul   $0x74,%eax,%eax
f0104359:	c7 80 28 40 21 f0 00 	movl   $0x0,-0xfdebfd8(%eax)
f0104360:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104363:	a1 8c 3e 21 f0       	mov    0xf0213e8c,%eax
	if ((uint32_t)kva < KERNBASE)
f0104368:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010436d:	76 50                	jbe    f01043bf <sched_halt+0xc0>
	return (physaddr_t)kva - KERNBASE;
f010436f:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104374:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104377:	e8 5b 18 00 00       	call   f0105bd7 <cpunum>
f010437c:	6b d0 74             	imul   $0x74,%eax,%edx
f010437f:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104382:	b8 02 00 00 00       	mov    $0x2,%eax
f0104387:	f0 87 82 20 40 21 f0 	lock xchg %eax,-0xfdebfe0(%edx)
	spin_unlock(&kernel_lock);
f010438e:	83 ec 0c             	sub    $0xc,%esp
f0104391:	68 80 14 12 f0       	push   $0xf0121480
f0104396:	e8 49 1b 00 00       	call   f0105ee4 <spin_unlock>
	asm volatile("pause");
f010439b:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f010439d:	e8 35 18 00 00       	call   f0105bd7 <cpunum>
f01043a2:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f01043a5:	8b 80 30 40 21 f0    	mov    -0xfdebfd0(%eax),%eax
f01043ab:	bd 00 00 00 00       	mov    $0x0,%ebp
f01043b0:	89 c4                	mov    %eax,%esp
f01043b2:	6a 00                	push   $0x0
f01043b4:	6a 00                	push   $0x0
f01043b6:	fb                   	sti    
f01043b7:	f4                   	hlt    
f01043b8:	eb fd                	jmp    f01043b7 <sched_halt+0xb8>
}
f01043ba:	83 c4 10             	add    $0x10,%esp
f01043bd:	c9                   	leave  
f01043be:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01043bf:	50                   	push   %eax
f01043c0:	68 68 62 10 f0       	push   $0xf0106268
f01043c5:	6a 50                	push   $0x50
f01043c7:	68 d9 78 10 f0       	push   $0xf01078d9
f01043cc:	e8 6f bc ff ff       	call   f0100040 <_panic>

f01043d1 <sched_yield>:
{
f01043d1:	55                   	push   %ebp
f01043d2:	89 e5                	mov    %esp,%ebp
f01043d4:	56                   	push   %esi
f01043d5:	53                   	push   %ebx
	if (curenv) cur=ENVX(curenv->env_id);
f01043d6:	e8 fc 17 00 00       	call   f0105bd7 <cpunum>
f01043db:	6b c0 74             	imul   $0x74,%eax,%eax
		else cur = 0;
f01043de:	b9 00 00 00 00       	mov    $0x0,%ecx
	if (curenv) cur=ENVX(curenv->env_id);
f01043e3:	83 b8 28 40 21 f0 00 	cmpl   $0x0,-0xfdebfd8(%eax)
f01043ea:	74 17                	je     f0104403 <sched_yield+0x32>
f01043ec:	e8 e6 17 00 00       	call   f0105bd7 <cpunum>
f01043f1:	6b c0 74             	imul   $0x74,%eax,%eax
f01043f4:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f01043fa:	8b 48 48             	mov    0x48(%eax),%ecx
f01043fd:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		if (envs[j].env_status == ENV_RUNNABLE) {
f0104403:	8b 1d 44 32 21 f0    	mov    0xf0213244,%ebx
f0104409:	89 ca                	mov    %ecx,%edx
f010440b:	81 c1 00 04 00 00    	add    $0x400,%ecx
		int j = (cur+i) % NENV;
f0104411:	89 d6                	mov    %edx,%esi
f0104413:	c1 fe 1f             	sar    $0x1f,%esi
f0104416:	c1 ee 16             	shr    $0x16,%esi
f0104419:	8d 04 32             	lea    (%edx,%esi,1),%eax
f010441c:	25 ff 03 00 00       	and    $0x3ff,%eax
f0104421:	29 f0                	sub    %esi,%eax
		if (envs[j].env_status == ENV_RUNNABLE) {
f0104423:	6b c0 7c             	imul   $0x7c,%eax,%eax
f0104426:	01 d8                	add    %ebx,%eax
f0104428:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f010442c:	74 38                	je     f0104466 <sched_yield+0x95>
f010442e:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < NENV; ++i) {
f0104431:	39 ca                	cmp    %ecx,%edx
f0104433:	75 dc                	jne    f0104411 <sched_yield+0x40>
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104435:	e8 9d 17 00 00       	call   f0105bd7 <cpunum>
f010443a:	6b c0 74             	imul   $0x74,%eax,%eax
f010443d:	83 b8 28 40 21 f0 00 	cmpl   $0x0,-0xfdebfd8(%eax)
f0104444:	74 14                	je     f010445a <sched_yield+0x89>
f0104446:	e8 8c 17 00 00       	call   f0105bd7 <cpunum>
f010444b:	6b c0 74             	imul   $0x74,%eax,%eax
f010444e:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0104454:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104458:	74 15                	je     f010446f <sched_yield+0x9e>
	sched_halt();
f010445a:	e8 a0 fe ff ff       	call   f01042ff <sched_halt>
}
f010445f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104462:	5b                   	pop    %ebx
f0104463:	5e                   	pop    %esi
f0104464:	5d                   	pop    %ebp
f0104465:	c3                   	ret    
			env_run(envs + j);
f0104466:	83 ec 0c             	sub    $0xc,%esp
f0104469:	50                   	push   %eax
f010446a:	e8 6e f2 ff ff       	call   f01036dd <env_run>
		env_run(curenv);
f010446f:	e8 63 17 00 00       	call   f0105bd7 <cpunum>
f0104474:	83 ec 0c             	sub    $0xc,%esp
f0104477:	6b c0 74             	imul   $0x74,%eax,%eax
f010447a:	ff b0 28 40 21 f0    	pushl  -0xfdebfd8(%eax)
f0104480:	e8 58 f2 ff ff       	call   f01036dd <env_run>

f0104485 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104485:	55                   	push   %ebp
f0104486:	89 e5                	mov    %esp,%ebp
f0104488:	57                   	push   %edi
f0104489:	56                   	push   %esi
f010448a:	53                   	push   %ebx
f010448b:	83 ec 1c             	sub    $0x1c,%esp
f010448e:	8b 45 08             	mov    0x8(%ebp),%eax
	// LAB 3: Your code here.

	//panic("syscall not implemented");

	int32_t retVal = 0;
	switch (syscallno)
f0104491:	83 f8 0d             	cmp    $0xd,%eax
f0104494:	0f 87 97 05 00 00    	ja     f0104a31 <syscall+0x5ac>
f010449a:	ff 24 85 20 79 10 f0 	jmp    *-0xfef86e0(,%eax,4)
    user_mem_assert(curenv, s, len, PTE_U);
f01044a1:	e8 31 17 00 00       	call   f0105bd7 <cpunum>
f01044a6:	6a 04                	push   $0x4
f01044a8:	ff 75 10             	pushl  0x10(%ebp)
f01044ab:	ff 75 0c             	pushl  0xc(%ebp)
f01044ae:	6b c0 74             	imul   $0x74,%eax,%eax
f01044b1:	ff b0 28 40 21 f0    	pushl  -0xfdebfd8(%eax)
f01044b7:	e8 cd ea ff ff       	call   f0102f89 <user_mem_assert>
    cprintf("%.*s", len, s);
f01044bc:	83 c4 0c             	add    $0xc,%esp
f01044bf:	ff 75 0c             	pushl  0xc(%ebp)
f01044c2:	ff 75 10             	pushl  0x10(%ebp)
f01044c5:	68 e6 78 10 f0       	push   $0xf01078e6
f01044ca:	e8 44 f4 ff ff       	call   f0103913 <cprintf>
f01044cf:	83 c4 10             	add    $0x10,%esp
	int32_t retVal = 0;
f01044d2:	bb 00 00 00 00       	mov    $0x0,%ebx
		return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
	default:
		retVal = -E_INVAL;
	}
	return retVal;
}
f01044d7:	89 d8                	mov    %ebx,%eax
f01044d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01044dc:	5b                   	pop    %ebx
f01044dd:	5e                   	pop    %esi
f01044de:	5f                   	pop    %edi
f01044df:	5d                   	pop    %ebp
f01044e0:	c3                   	ret    
	return cons_getc();
f01044e1:	e8 3a c1 ff ff       	call   f0100620 <cons_getc>
f01044e6:	89 c3                	mov    %eax,%ebx
		break;
f01044e8:	eb ed                	jmp    f01044d7 <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f01044ea:	83 ec 04             	sub    $0x4,%esp
f01044ed:	6a 01                	push   $0x1
f01044ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01044f2:	50                   	push   %eax
f01044f3:	ff 75 0c             	pushl  0xc(%ebp)
f01044f6:	e8 57 eb ff ff       	call   f0103052 <envid2env>
f01044fb:	89 c3                	mov    %eax,%ebx
f01044fd:	83 c4 10             	add    $0x10,%esp
f0104500:	85 c0                	test   %eax,%eax
f0104502:	78 d3                	js     f01044d7 <syscall+0x52>
	if (e == curenv)
f0104504:	e8 ce 16 00 00       	call   f0105bd7 <cpunum>
f0104509:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010450c:	6b c0 74             	imul   $0x74,%eax,%eax
f010450f:	39 90 28 40 21 f0    	cmp    %edx,-0xfdebfd8(%eax)
f0104515:	74 3a                	je     f0104551 <syscall+0xcc>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f0104517:	8b 5a 48             	mov    0x48(%edx),%ebx
f010451a:	e8 b8 16 00 00       	call   f0105bd7 <cpunum>
f010451f:	83 ec 04             	sub    $0x4,%esp
f0104522:	53                   	push   %ebx
f0104523:	6b c0 74             	imul   $0x74,%eax,%eax
f0104526:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f010452c:	ff 70 48             	pushl  0x48(%eax)
f010452f:	68 06 79 10 f0       	push   $0xf0107906
f0104534:	e8 da f3 ff ff       	call   f0103913 <cprintf>
f0104539:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f010453c:	83 ec 0c             	sub    $0xc,%esp
f010453f:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104542:	e8 f7 f0 ff ff       	call   f010363e <env_destroy>
f0104547:	83 c4 10             	add    $0x10,%esp
	return 0;
f010454a:	bb 00 00 00 00       	mov    $0x0,%ebx
		break;
f010454f:	eb 86                	jmp    f01044d7 <syscall+0x52>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f0104551:	e8 81 16 00 00       	call   f0105bd7 <cpunum>
f0104556:	83 ec 08             	sub    $0x8,%esp
f0104559:	6b c0 74             	imul   $0x74,%eax,%eax
f010455c:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0104562:	ff 70 48             	pushl  0x48(%eax)
f0104565:	68 eb 78 10 f0       	push   $0xf01078eb
f010456a:	e8 a4 f3 ff ff       	call   f0103913 <cprintf>
f010456f:	83 c4 10             	add    $0x10,%esp
f0104572:	eb c8                	jmp    f010453c <syscall+0xb7>
	return curenv->env_id;
f0104574:	e8 5e 16 00 00       	call   f0105bd7 <cpunum>
f0104579:	6b c0 74             	imul   $0x74,%eax,%eax
f010457c:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0104582:	8b 58 48             	mov    0x48(%eax),%ebx
		break;
f0104585:	e9 4d ff ff ff       	jmp    f01044d7 <syscall+0x52>
	sched_yield();
f010458a:	e8 42 fe ff ff       	call   f01043d1 <sched_yield>
	int r = env_alloc(&e, curenv->env_id);
f010458f:	e8 43 16 00 00       	call   f0105bd7 <cpunum>
f0104594:	83 ec 08             	sub    $0x8,%esp
f0104597:	6b c0 74             	imul   $0x74,%eax,%eax
f010459a:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f01045a0:	ff 70 48             	pushl  0x48(%eax)
f01045a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01045a6:	50                   	push   %eax
f01045a7:	e8 b1 eb ff ff       	call   f010315d <env_alloc>
f01045ac:	89 c3                	mov    %eax,%ebx
	if (r < 0)
f01045ae:	83 c4 10             	add    $0x10,%esp
f01045b1:	85 c0                	test   %eax,%eax
f01045b3:	0f 88 1e ff ff ff    	js     f01044d7 <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f01045b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01045bc:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f01045c3:	e8 0f 16 00 00       	call   f0105bd7 <cpunum>
f01045c8:	6b c0 74             	imul   $0x74,%eax,%eax
f01045cb:	8b b0 28 40 21 f0    	mov    -0xfdebfd8(%eax),%esi
f01045d1:	b9 11 00 00 00       	mov    $0x11,%ecx
f01045d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01045d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f01045db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01045de:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f01045e5:	8b 58 48             	mov    0x48(%eax),%ebx
		break;
f01045e8:	e9 ea fe ff ff       	jmp    f01044d7 <syscall+0x52>
	if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE) return -E_INVAL;  
f01045ed:	8b 45 10             	mov    0x10(%ebp),%eax
f01045f0:	83 e8 02             	sub    $0x2,%eax
f01045f3:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f01045f8:	75 2b                	jne    f0104625 <syscall+0x1a0>
    if (envid2env(envid, &e, 1) < 0) return -E_BAD_ENV;
f01045fa:	83 ec 04             	sub    $0x4,%esp
f01045fd:	6a 01                	push   $0x1
f01045ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104602:	50                   	push   %eax
f0104603:	ff 75 0c             	pushl  0xc(%ebp)
f0104606:	e8 47 ea ff ff       	call   f0103052 <envid2env>
f010460b:	83 c4 10             	add    $0x10,%esp
f010460e:	85 c0                	test   %eax,%eax
f0104610:	78 1d                	js     f010462f <syscall+0x1aa>
    e->env_status = status;
f0104612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104615:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104618:	89 78 54             	mov    %edi,0x54(%eax)
    return 0;
f010461b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104620:	e9 b2 fe ff ff       	jmp    f01044d7 <syscall+0x52>
	if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE) return -E_INVAL;  
f0104625:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010462a:	e9 a8 fe ff ff       	jmp    f01044d7 <syscall+0x52>
    if (envid2env(envid, &e, 1) < 0) return -E_BAD_ENV;
f010462f:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
		break;
f0104634:	e9 9e fe ff ff       	jmp    f01044d7 <syscall+0x52>
	if ((~perm & (PTE_U|PTE_P)) != 0) return -E_INVAL;
f0104639:	8b 5d 14             	mov    0x14(%ebp),%ebx
f010463c:	f7 d3                	not    %ebx
f010463e:	83 e3 05             	and    $0x5,%ebx
f0104641:	75 79                	jne    f01046bc <syscall+0x237>
    if ((uintptr_t)va >= UTOP || PGOFF(va) != 0) return -E_INVAL; 
f0104643:	f7 45 14 f8 f1 ff ff 	testl  $0xfffff1f8,0x14(%ebp)
f010464a:	75 7a                	jne    f01046c6 <syscall+0x241>
f010464c:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104653:	77 71                	ja     f01046c6 <syscall+0x241>
f0104655:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f010465c:	75 72                	jne    f01046d0 <syscall+0x24b>
    struct PageInfo *pginfo = page_alloc(ALLOC_ZERO);
f010465e:	83 ec 0c             	sub    $0xc,%esp
f0104661:	6a 01                	push   $0x1
f0104663:	e8 b7 c8 ff ff       	call   f0100f1f <page_alloc>
f0104668:	89 c6                	mov    %eax,%esi
    if (!pginfo) return -E_NO_MEM;
f010466a:	83 c4 10             	add    $0x10,%esp
f010466d:	85 c0                	test   %eax,%eax
f010466f:	74 69                	je     f01046da <syscall+0x255>
    int r = envid2env(envid, &e, 1);
f0104671:	83 ec 04             	sub    $0x4,%esp
f0104674:	6a 01                	push   $0x1
f0104676:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104679:	50                   	push   %eax
f010467a:	ff 75 0c             	pushl  0xc(%ebp)
f010467d:	e8 d0 e9 ff ff       	call   f0103052 <envid2env>
    if (r < 0) return -E_BAD_ENV;
f0104682:	83 c4 10             	add    $0x10,%esp
f0104685:	85 c0                	test   %eax,%eax
f0104687:	78 5b                	js     f01046e4 <syscall+0x25f>
    r = page_insert(e->env_pgdir, pginfo, va, perm);
f0104689:	ff 75 14             	pushl  0x14(%ebp)
f010468c:	ff 75 10             	pushl  0x10(%ebp)
f010468f:	56                   	push   %esi
f0104690:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104693:	ff 70 60             	pushl  0x60(%eax)
f0104696:	e8 90 cb ff ff       	call   f010122b <page_insert>
    if (r < 0) {
f010469b:	83 c4 10             	add    $0x10,%esp
f010469e:	85 c0                	test   %eax,%eax
f01046a0:	0f 89 31 fe ff ff    	jns    f01044d7 <syscall+0x52>
        page_free(pginfo);
f01046a6:	83 ec 0c             	sub    $0xc,%esp
f01046a9:	56                   	push   %esi
f01046aa:	e8 e2 c8 ff ff       	call   f0100f91 <page_free>
f01046af:	83 c4 10             	add    $0x10,%esp
        return -E_NO_MEM;
f01046b2:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01046b7:	e9 1b fe ff ff       	jmp    f01044d7 <syscall+0x52>
	if ((~perm & (PTE_U|PTE_P)) != 0) return -E_INVAL;
f01046bc:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01046c1:	e9 11 fe ff ff       	jmp    f01044d7 <syscall+0x52>
    if ((uintptr_t)va >= UTOP || PGOFF(va) != 0) return -E_INVAL; 
f01046c6:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01046cb:	e9 07 fe ff ff       	jmp    f01044d7 <syscall+0x52>
f01046d0:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01046d5:	e9 fd fd ff ff       	jmp    f01044d7 <syscall+0x52>
    if (!pginfo) return -E_NO_MEM;
f01046da:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01046df:	e9 f3 fd ff ff       	jmp    f01044d7 <syscall+0x52>
    if (r < 0) return -E_BAD_ENV;
f01046e4:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
		break;
f01046e9:	e9 e9 fd ff ff       	jmp    f01044d7 <syscall+0x52>
	if ((uintptr_t)srcva >= UTOP || PGOFF(srcva) != 0) return -E_INVAL;
f01046ee:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f01046f5:	0f 87 9f 00 00 00    	ja     f010479a <syscall+0x315>
    if ((uintptr_t)dstva >= UTOP || PGOFF(dstva) != 0) return -E_INVAL;
f01046fb:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104702:	0f 85 9c 00 00 00    	jne    f01047a4 <syscall+0x31f>
f0104708:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f010470f:	0f 87 8f 00 00 00    	ja     f01047a4 <syscall+0x31f>
f0104715:	f7 45 18 ff 0f 00 00 	testl  $0xfff,0x18(%ebp)
f010471c:	0f 85 8c 00 00 00    	jne    f01047ae <syscall+0x329>
    if ((perm & PTE_U) == 0 || (perm & PTE_P) == 0 || (perm & ~PTE_SYSCALL) != 0) return -E_INVAL;
f0104722:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0104725:	25 fd f1 ff ff       	and    $0xfffff1fd,%eax
f010472a:	83 f8 05             	cmp    $0x5,%eax
f010472d:	0f 85 85 00 00 00    	jne    f01047b8 <syscall+0x333>
    if (envid2env(srcenvid, &src_e, 1)<0 || envid2env(dstenvid, &dst_e, 1)<0) return -E_BAD_ENV;
f0104733:	83 ec 04             	sub    $0x4,%esp
f0104736:	6a 01                	push   $0x1
f0104738:	8d 45 dc             	lea    -0x24(%ebp),%eax
f010473b:	50                   	push   %eax
f010473c:	ff 75 0c             	pushl  0xc(%ebp)
f010473f:	e8 0e e9 ff ff       	call   f0103052 <envid2env>
f0104744:	83 c4 10             	add    $0x10,%esp
f0104747:	85 c0                	test   %eax,%eax
f0104749:	78 77                	js     f01047c2 <syscall+0x33d>
f010474b:	83 ec 04             	sub    $0x4,%esp
f010474e:	6a 01                	push   $0x1
f0104750:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104753:	50                   	push   %eax
f0104754:	ff 75 14             	pushl  0x14(%ebp)
f0104757:	e8 f6 e8 ff ff       	call   f0103052 <envid2env>
f010475c:	83 c4 10             	add    $0x10,%esp
f010475f:	85 c0                	test   %eax,%eax
f0104761:	78 69                	js     f01047cc <syscall+0x347>
    struct PageInfo *pp = page_lookup(src_e->env_pgdir, srcva, &src_ptab);
f0104763:	83 ec 04             	sub    $0x4,%esp
f0104766:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104769:	50                   	push   %eax
f010476a:	ff 75 10             	pushl  0x10(%ebp)
f010476d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104770:	ff 70 60             	pushl  0x60(%eax)
f0104773:	e8 d0 c9 ff ff       	call   f0101148 <page_lookup>
    if (page_insert(dst_e->env_pgdir, pp, dstva, perm) < 0) return -E_NO_MEM;
f0104778:	ff 75 1c             	pushl  0x1c(%ebp)
f010477b:	ff 75 18             	pushl  0x18(%ebp)
f010477e:	50                   	push   %eax
f010477f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104782:	ff 70 60             	pushl  0x60(%eax)
f0104785:	e8 a1 ca ff ff       	call   f010122b <page_insert>
f010478a:	83 c4 20             	add    $0x20,%esp
    return 0;
f010478d:	c1 f8 1f             	sar    $0x1f,%eax
f0104790:	89 c3                	mov    %eax,%ebx
f0104792:	83 e3 fc             	and    $0xfffffffc,%ebx
f0104795:	e9 3d fd ff ff       	jmp    f01044d7 <syscall+0x52>
	if ((uintptr_t)srcva >= UTOP || PGOFF(srcva) != 0) return -E_INVAL;
f010479a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010479f:	e9 33 fd ff ff       	jmp    f01044d7 <syscall+0x52>
    if ((uintptr_t)dstva >= UTOP || PGOFF(dstva) != 0) return -E_INVAL;
f01047a4:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01047a9:	e9 29 fd ff ff       	jmp    f01044d7 <syscall+0x52>
f01047ae:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01047b3:	e9 1f fd ff ff       	jmp    f01044d7 <syscall+0x52>
    if ((perm & PTE_U) == 0 || (perm & PTE_P) == 0 || (perm & ~PTE_SYSCALL) != 0) return -E_INVAL;
f01047b8:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01047bd:	e9 15 fd ff ff       	jmp    f01044d7 <syscall+0x52>
    if (envid2env(srcenvid, &src_e, 1)<0 || envid2env(dstenvid, &dst_e, 1)<0) return -E_BAD_ENV;
f01047c2:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f01047c7:	e9 0b fd ff ff       	jmp    f01044d7 <syscall+0x52>
f01047cc:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f01047d1:	e9 01 fd ff ff       	jmp    f01044d7 <syscall+0x52>
	if ((uintptr_t)va >= UTOP || PGOFF(va) != 0) return -E_INVAL;
f01047d6:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f01047dd:	77 3f                	ja     f010481e <syscall+0x399>
f01047df:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f01047e6:	75 40                	jne    f0104828 <syscall+0x3a3>
    if (envid2env(envid, &e, 1) < 0) return -E_BAD_ENV;
f01047e8:	83 ec 04             	sub    $0x4,%esp
f01047eb:	6a 01                	push   $0x1
f01047ed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01047f0:	50                   	push   %eax
f01047f1:	ff 75 0c             	pushl  0xc(%ebp)
f01047f4:	e8 59 e8 ff ff       	call   f0103052 <envid2env>
f01047f9:	83 c4 10             	add    $0x10,%esp
f01047fc:	85 c0                	test   %eax,%eax
f01047fe:	78 32                	js     f0104832 <syscall+0x3ad>
    page_remove(e->env_pgdir, va);
f0104800:	83 ec 08             	sub    $0x8,%esp
f0104803:	ff 75 10             	pushl  0x10(%ebp)
f0104806:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104809:	ff 70 60             	pushl  0x60(%eax)
f010480c:	e8 d2 c9 ff ff       	call   f01011e3 <page_remove>
f0104811:	83 c4 10             	add    $0x10,%esp
    return 0;
f0104814:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104819:	e9 b9 fc ff ff       	jmp    f01044d7 <syscall+0x52>
	if ((uintptr_t)va >= UTOP || PGOFF(va) != 0) return -E_INVAL;
f010481e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104823:	e9 af fc ff ff       	jmp    f01044d7 <syscall+0x52>
f0104828:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010482d:	e9 a5 fc ff ff       	jmp    f01044d7 <syscall+0x52>
    if (envid2env(envid, &e, 1) < 0) return -E_BAD_ENV;
f0104832:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
		break;
f0104837:	e9 9b fc ff ff       	jmp    f01044d7 <syscall+0x52>
	int ret = envid2env(envid, &e, 1);
f010483c:	83 ec 04             	sub    $0x4,%esp
f010483f:	6a 01                	push   $0x1
f0104841:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104844:	50                   	push   %eax
f0104845:	ff 75 0c             	pushl  0xc(%ebp)
f0104848:	e8 05 e8 ff ff       	call   f0103052 <envid2env>
f010484d:	89 c3                	mov    %eax,%ebx
	if (ret) return ret;	//bad_env
f010484f:	83 c4 10             	add    $0x10,%esp
f0104852:	85 c0                	test   %eax,%eax
f0104854:	0f 85 7d fc ff ff    	jne    f01044d7 <syscall+0x52>
	e->env_pgfault_upcall = func;
f010485a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010485d:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104860:	89 48 64             	mov    %ecx,0x64(%eax)
		return sys_env_set_pgfault_upcall(a1, (void *)a2);
f0104863:	e9 6f fc ff ff       	jmp    f01044d7 <syscall+0x52>
	if (dstva < (void*)UTOP) 
f0104868:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f010486f:	77 13                	ja     f0104884 <syscall+0x3ff>
		if (dstva != ROUNDDOWN(dstva, PGSIZE)) 
f0104871:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0104878:	74 0a                	je     f0104884 <syscall+0x3ff>
		return sys_ipc_recv((void *)a1);
f010487a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f010487f:	e9 53 fc ff ff       	jmp    f01044d7 <syscall+0x52>
	curenv->env_ipc_recving = 1;
f0104884:	e8 4e 13 00 00       	call   f0105bd7 <cpunum>
f0104889:	6b c0 74             	imul   $0x74,%eax,%eax
f010488c:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0104892:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0104896:	e8 3c 13 00 00       	call   f0105bd7 <cpunum>
f010489b:	6b c0 74             	imul   $0x74,%eax,%eax
f010489e:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f01048a4:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	curenv->env_ipc_dstva = dstva;
f01048ab:	e8 27 13 00 00       	call   f0105bd7 <cpunum>
f01048b0:	6b c0 74             	imul   $0x74,%eax,%eax
f01048b3:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f01048b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01048bc:	89 48 6c             	mov    %ecx,0x6c(%eax)
	sched_yield();
f01048bf:	e8 0d fb ff ff       	call   f01043d1 <sched_yield>
	if (envid2env(envid, &e, 0)) return -E_BAD_ENV;
f01048c4:	83 ec 04             	sub    $0x4,%esp
f01048c7:	6a 00                	push   $0x0
f01048c9:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01048cc:	50                   	push   %eax
f01048cd:	ff 75 0c             	pushl  0xc(%ebp)
f01048d0:	e8 7d e7 ff ff       	call   f0103052 <envid2env>
f01048d5:	89 c3                	mov    %eax,%ebx
f01048d7:	83 c4 10             	add    $0x10,%esp
f01048da:	85 c0                	test   %eax,%eax
f01048dc:	0f 85 f6 00 00 00    	jne    f01049d8 <syscall+0x553>
	if (!e->env_ipc_recving) return -E_IPC_NOT_RECV;
f01048e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01048e5:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01048e9:	0f 84 f3 00 00 00    	je     f01049e2 <syscall+0x55d>
	if (srcva < (void *) UTOP) {
f01048ef:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01048f6:	77 6f                	ja     f0104967 <syscall+0x4e2>
		if(PGOFF(srcva)) return -E_INVAL;
f01048f8:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f01048ff:	74 0a                	je     f010490b <syscall+0x486>
f0104901:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104906:	e9 cc fb ff ff       	jmp    f01044d7 <syscall+0x52>
		struct PageInfo *p = page_lookup(curenv->env_pgdir, srcva, &pte);
f010490b:	e8 c7 12 00 00       	call   f0105bd7 <cpunum>
f0104910:	83 ec 04             	sub    $0x4,%esp
f0104913:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104916:	52                   	push   %edx
f0104917:	ff 75 14             	pushl  0x14(%ebp)
f010491a:	6b c0 74             	imul   $0x74,%eax,%eax
f010491d:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f0104923:	ff 70 60             	pushl  0x60(%eax)
f0104926:	e8 1d c8 ff ff       	call   f0101148 <page_lookup>
		if (!p) return -E_INVAL;
f010492b:	83 c4 10             	add    $0x10,%esp
f010492e:	85 c0                	test   %eax,%eax
f0104930:	0f 84 87 00 00 00    	je     f01049bd <syscall+0x538>
		if ((perm & valid_perm) != valid_perm) {
f0104936:	8b 55 18             	mov    0x18(%ebp),%edx
f0104939:	83 e2 05             	and    $0x5,%edx
f010493c:	83 fa 05             	cmp    $0x5,%edx
f010493f:	74 0a                	je     f010494b <syscall+0x4c6>
			return -E_INVAL;
f0104941:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104946:	e9 8c fb ff ff       	jmp    f01044d7 <syscall+0x52>
		if ((perm & PTE_W) && !(*pte & PTE_W)) return -E_INVAL;
f010494b:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f010494f:	74 08                	je     f0104959 <syscall+0x4d4>
f0104951:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104954:	f6 02 02             	testb  $0x2,(%edx)
f0104957:	74 6e                	je     f01049c7 <syscall+0x542>
		if (e->env_ipc_dstva < (void *)UTOP) {
f0104959:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010495c:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f010495f:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f0104965:	76 37                	jbe    f010499e <syscall+0x519>
	e->env_ipc_recving = 0;
f0104967:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010496a:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	e->env_ipc_from = curenv->env_id;
f010496e:	e8 64 12 00 00       	call   f0105bd7 <cpunum>
f0104973:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104976:	6b c0 74             	imul   $0x74,%eax,%eax
f0104979:	8b 80 28 40 21 f0    	mov    -0xfdebfd8(%eax),%eax
f010497f:	8b 40 48             	mov    0x48(%eax),%eax
f0104982:	89 42 74             	mov    %eax,0x74(%edx)
	e->env_ipc_value = value;
f0104985:	8b 45 10             	mov    0x10(%ebp),%eax
f0104988:	89 42 70             	mov    %eax,0x70(%edx)
	e->env_status = ENV_RUNNABLE;
f010498b:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	e->env_tf.tf_regs.reg_eax = 0;
f0104992:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
f0104999:	e9 39 fb ff ff       	jmp    f01044d7 <syscall+0x52>
			int ret = page_insert(e->env_pgdir, p, e->env_ipc_dstva, perm);
f010499e:	ff 75 18             	pushl  0x18(%ebp)
f01049a1:	51                   	push   %ecx
f01049a2:	50                   	push   %eax
f01049a3:	ff 72 60             	pushl  0x60(%edx)
f01049a6:	e8 80 c8 ff ff       	call   f010122b <page_insert>
			if (ret) return ret;
f01049ab:	83 c4 10             	add    $0x10,%esp
f01049ae:	85 c0                	test   %eax,%eax
f01049b0:	75 1f                	jne    f01049d1 <syscall+0x54c>
			e->env_ipc_perm = perm;
f01049b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01049b5:	8b 4d 18             	mov    0x18(%ebp),%ecx
f01049b8:	89 48 78             	mov    %ecx,0x78(%eax)
f01049bb:	eb aa                	jmp    f0104967 <syscall+0x4e2>
		if (!p) return -E_INVAL;
f01049bd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01049c2:	e9 10 fb ff ff       	jmp    f01044d7 <syscall+0x52>
		if ((perm & PTE_W) && !(*pte & PTE_W)) return -E_INVAL;
f01049c7:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01049cc:	e9 06 fb ff ff       	jmp    f01044d7 <syscall+0x52>
			if (ret) return ret;
f01049d1:	89 c3                	mov    %eax,%ebx
f01049d3:	e9 ff fa ff ff       	jmp    f01044d7 <syscall+0x52>
	if (envid2env(envid, &e, 0)) return -E_BAD_ENV;
f01049d8:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f01049dd:	e9 f5 fa ff ff       	jmp    f01044d7 <syscall+0x52>
	if (!e->env_ipc_recving) return -E_IPC_NOT_RECV;
f01049e2:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
		return sys_ipc_try_send(a1, a2, (void *)a3, a4);
f01049e7:	e9 eb fa ff ff       	jmp    f01044d7 <syscall+0x52>
		return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
f01049ec:	8b 75 10             	mov    0x10(%ebp),%esi
	if (envid2env(envid, &e, 1)) {
f01049ef:	83 ec 04             	sub    $0x4,%esp
f01049f2:	6a 01                	push   $0x1
f01049f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01049f7:	50                   	push   %eax
f01049f8:	ff 75 0c             	pushl  0xc(%ebp)
f01049fb:	e8 52 e6 ff ff       	call   f0103052 <envid2env>
f0104a00:	89 c3                	mov    %eax,%ebx
f0104a02:	83 c4 10             	add    $0x10,%esp
f0104a05:	85 c0                	test   %eax,%eax
f0104a07:	75 1e                	jne    f0104a27 <syscall+0x5a2>
	e->env_tf = *tf;
f0104a09:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104a0e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104a11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_eflags |= FL_IF;
f0104a13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	e->env_tf.tf_eflags &= ~FL_IOPL_MASK;
f0104a16:	8b 42 38             	mov    0x38(%edx),%eax
f0104a19:	80 e4 cf             	and    $0xcf,%ah
f0104a1c:	80 cc 02             	or     $0x2,%ah
f0104a1f:	89 42 38             	mov    %eax,0x38(%edx)
f0104a22:	e9 b0 fa ff ff       	jmp    f01044d7 <syscall+0x52>
		return -E_BAD_ENV;
f0104a27:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
		return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
f0104a2c:	e9 a6 fa ff ff       	jmp    f01044d7 <syscall+0x52>
		retVal = -E_INVAL;
f0104a31:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a36:	e9 9c fa ff ff       	jmp    f01044d7 <syscall+0x52>

f0104a3b <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0104a3b:	55                   	push   %ebp
f0104a3c:	89 e5                	mov    %esp,%ebp
f0104a3e:	57                   	push   %edi
f0104a3f:	56                   	push   %esi
f0104a40:	53                   	push   %ebx
f0104a41:	83 ec 14             	sub    $0x14,%esp
f0104a44:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104a47:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104a4a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104a4d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104a50:	8b 32                	mov    (%edx),%esi
f0104a52:	8b 01                	mov    (%ecx),%eax
f0104a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104a57:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104a5e:	eb 2f                	jmp    f0104a8f <stab_binsearch+0x54>
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f0104a60:	83 e8 01             	sub    $0x1,%eax
		while (m >= l && stabs[m].n_type != type)
f0104a63:	39 c6                	cmp    %eax,%esi
f0104a65:	7f 49                	jg     f0104ab0 <stab_binsearch+0x75>
f0104a67:	0f b6 0a             	movzbl (%edx),%ecx
f0104a6a:	83 ea 0c             	sub    $0xc,%edx
f0104a6d:	39 f9                	cmp    %edi,%ecx
f0104a6f:	75 ef                	jne    f0104a60 <stab_binsearch+0x25>
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104a71:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104a74:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104a77:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104a7b:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104a7e:	73 35                	jae    f0104ab5 <stab_binsearch+0x7a>
			*region_left = m;
f0104a80:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104a83:	89 06                	mov    %eax,(%esi)
			l = true_m + 1;
f0104a85:	8d 73 01             	lea    0x1(%ebx),%esi
		any_matches = 1;
f0104a88:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0104a8f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0104a92:	7f 4e                	jg     f0104ae2 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f0104a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104a97:	01 f0                	add    %esi,%eax
f0104a99:	89 c3                	mov    %eax,%ebx
f0104a9b:	c1 eb 1f             	shr    $0x1f,%ebx
f0104a9e:	01 c3                	add    %eax,%ebx
f0104aa0:	d1 fb                	sar    %ebx
f0104aa2:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104aa5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104aa8:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104aac:	89 d8                	mov    %ebx,%eax
		while (m >= l && stabs[m].n_type != type)
f0104aae:	eb b3                	jmp    f0104a63 <stab_binsearch+0x28>
			l = true_m + 1;
f0104ab0:	8d 73 01             	lea    0x1(%ebx),%esi
			continue;
f0104ab3:	eb da                	jmp    f0104a8f <stab_binsearch+0x54>
		} else if (stabs[m].n_value > addr) {
f0104ab5:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104ab8:	76 14                	jbe    f0104ace <stab_binsearch+0x93>
			*region_right = m - 1;
f0104aba:	83 e8 01             	sub    $0x1,%eax
f0104abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104ac0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104ac3:	89 03                	mov    %eax,(%ebx)
		any_matches = 1;
f0104ac5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104acc:	eb c1                	jmp    f0104a8f <stab_binsearch+0x54>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104ace:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104ad1:	89 06                	mov    %eax,(%esi)
			l = m;
			addr++;
f0104ad3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104ad7:	89 c6                	mov    %eax,%esi
		any_matches = 1;
f0104ad9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104ae0:	eb ad                	jmp    f0104a8f <stab_binsearch+0x54>
		}
	}

	if (!any_matches)
f0104ae2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104ae6:	74 16                	je     f0104afe <stab_binsearch+0xc3>
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0104ae8:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104aeb:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0104aed:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104af0:	8b 0e                	mov    (%esi),%ecx
f0104af2:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104af5:	8b 75 ec             	mov    -0x14(%ebp),%esi
f0104af8:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
		for (l = *region_right;
f0104afc:	eb 12                	jmp    f0104b10 <stab_binsearch+0xd5>
		*region_right = *region_left - 1;
f0104afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104b01:	8b 00                	mov    (%eax),%eax
f0104b03:	83 e8 01             	sub    $0x1,%eax
f0104b06:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104b09:	89 07                	mov    %eax,(%edi)
f0104b0b:	eb 16                	jmp    f0104b23 <stab_binsearch+0xe8>
		     l--)
f0104b0d:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0104b10:	39 c1                	cmp    %eax,%ecx
f0104b12:	7d 0a                	jge    f0104b1e <stab_binsearch+0xe3>
		     l > *region_left && stabs[l].n_type != type;
f0104b14:	0f b6 1a             	movzbl (%edx),%ebx
f0104b17:	83 ea 0c             	sub    $0xc,%edx
f0104b1a:	39 fb                	cmp    %edi,%ebx
f0104b1c:	75 ef                	jne    f0104b0d <stab_binsearch+0xd2>
			/* do nothing */;
		*region_left = l;
f0104b1e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104b21:	89 07                	mov    %eax,(%edi)
	}
}
f0104b23:	83 c4 14             	add    $0x14,%esp
f0104b26:	5b                   	pop    %ebx
f0104b27:	5e                   	pop    %esi
f0104b28:	5f                   	pop    %edi
f0104b29:	5d                   	pop    %ebp
f0104b2a:	c3                   	ret    

f0104b2b <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104b2b:	55                   	push   %ebp
f0104b2c:	89 e5                	mov    %esp,%ebp
f0104b2e:	57                   	push   %edi
f0104b2f:	56                   	push   %esi
f0104b30:	53                   	push   %ebx
f0104b31:	83 ec 2c             	sub    $0x2c,%esp
f0104b34:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104b37:	8b 75 0c             	mov    0xc(%ebp),%esi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104b3a:	c7 06 58 79 10 f0    	movl   $0xf0107958,(%esi)
	info->eip_line = 0;
f0104b40:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
	info->eip_fn_name = "<unknown>";
f0104b47:	c7 46 08 58 79 10 f0 	movl   $0xf0107958,0x8(%esi)
	info->eip_fn_namelen = 9;
f0104b4e:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
	info->eip_fn_addr = addr;
f0104b55:	89 7e 10             	mov    %edi,0x10(%esi)
	info->eip_fn_narg = 0;
f0104b58:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0104b5f:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104b65:	0f 86 e9 00 00 00    	jbe    f0104c54 <debuginfo_eip+0x129>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0104b6b:	c7 45 d0 04 6e 11 f0 	movl   $0xf0116e04,-0x30(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0104b72:	c7 45 cc cd 35 11 f0 	movl   $0xf01135cd,-0x34(%ebp)
		stab_end = __STAB_END__;
f0104b79:	bb cc 35 11 f0       	mov    $0xf01135cc,%ebx
		stabs = __STAB_BEGIN__;
f0104b7e:	c7 45 d4 f0 7e 10 f0 	movl   $0xf0107ef0,-0x2c(%ebp)
			return -1;
		}
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104b85:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0104b88:	39 4d cc             	cmp    %ecx,-0x34(%ebp)
f0104b8b:	0f 83 fa 01 00 00    	jae    f0104d8b <debuginfo_eip+0x260>
f0104b91:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f0104b95:	0f 85 f7 01 00 00    	jne    f0104d92 <debuginfo_eip+0x267>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104b9b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104ba2:	2b 5d d4             	sub    -0x2c(%ebp),%ebx
f0104ba5:	c1 fb 02             	sar    $0x2,%ebx
f0104ba8:	69 c3 ab aa aa aa    	imul   $0xaaaaaaab,%ebx,%eax
f0104bae:	83 e8 01             	sub    $0x1,%eax
f0104bb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104bb4:	83 ec 08             	sub    $0x8,%esp
f0104bb7:	57                   	push   %edi
f0104bb8:	6a 64                	push   $0x64
f0104bba:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104bbd:	89 d1                	mov    %edx,%ecx
f0104bbf:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104bc2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0104bc5:	89 d8                	mov    %ebx,%eax
f0104bc7:	e8 6f fe ff ff       	call   f0104a3b <stab_binsearch>
	if (lfile == 0)
f0104bcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104bcf:	83 c4 10             	add    $0x10,%esp
f0104bd2:	85 c0                	test   %eax,%eax
f0104bd4:	0f 84 bf 01 00 00    	je     f0104d99 <debuginfo_eip+0x26e>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0104bda:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0104bdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104be0:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104be3:	83 ec 08             	sub    $0x8,%esp
f0104be6:	57                   	push   %edi
f0104be7:	6a 24                	push   $0x24
f0104be9:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0104bec:	89 d1                	mov    %edx,%ecx
f0104bee:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104bf1:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0104bf4:	89 d8                	mov    %ebx,%eax
f0104bf6:	e8 40 fe ff ff       	call   f0104a3b <stab_binsearch>

	if (lfun <= rfun) {
f0104bfb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0104bfe:	83 c4 10             	add    $0x10,%esp
f0104c01:	3b 5d d8             	cmp    -0x28(%ebp),%ebx
f0104c04:	0f 8f f7 00 00 00    	jg     f0104d01 <debuginfo_eip+0x1d6>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104c0a:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104c0d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0104c10:	8d 14 87             	lea    (%edi,%eax,4),%edx
f0104c13:	8b 02                	mov    (%edx),%eax
f0104c15:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0104c18:	8b 7d cc             	mov    -0x34(%ebp),%edi
f0104c1b:	29 f9                	sub    %edi,%ecx
f0104c1d:	39 c8                	cmp    %ecx,%eax
f0104c1f:	73 05                	jae    f0104c26 <debuginfo_eip+0xfb>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104c21:	01 f8                	add    %edi,%eax
f0104c23:	89 46 08             	mov    %eax,0x8(%esi)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104c26:	8b 42 08             	mov    0x8(%edx),%eax
f0104c29:	89 46 10             	mov    %eax,0x10(%esi)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104c2c:	83 ec 08             	sub    $0x8,%esp
f0104c2f:	6a 3a                	push   $0x3a
f0104c31:	ff 76 08             	pushl  0x8(%esi)
f0104c34:	e8 5d 09 00 00       	call   f0105596 <strfind>
f0104c39:	2b 46 08             	sub    0x8(%esi),%eax
f0104c3c:	89 46 0c             	mov    %eax,0xc(%esi)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0104c3f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104c42:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104c45:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0104c48:	8d 44 81 04          	lea    0x4(%ecx,%eax,4),%eax
f0104c4c:	83 c4 10             	add    $0x10,%esp
f0104c4f:	e9 be 00 00 00       	jmp    f0104d12 <debuginfo_eip+0x1e7>
		if (user_mem_check(curenv, (void *)usd, sizeof(struct UserStabData), PTE_U) < 0)
f0104c54:	e8 7e 0f 00 00       	call   f0105bd7 <cpunum>
f0104c59:	6a 04                	push   $0x4
f0104c5b:	6a 10                	push   $0x10
f0104c5d:	68 00 00 20 00       	push   $0x200000
f0104c62:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c65:	ff b0 28 40 21 f0    	pushl  -0xfdebfd8(%eax)
f0104c6b:	e8 89 e2 ff ff       	call   f0102ef9 <user_mem_check>
f0104c70:	83 c4 10             	add    $0x10,%esp
f0104c73:	85 c0                	test   %eax,%eax
f0104c75:	0f 88 02 01 00 00    	js     f0104d7d <debuginfo_eip+0x252>
		stabs = usd->stabs;
f0104c7b:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f0104c81:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		stab_end = usd->stab_end;
f0104c84:	8b 1d 04 00 20 00    	mov    0x200004,%ebx
		stabstr = usd->stabstr;
f0104c8a:	a1 08 00 20 00       	mov    0x200008,%eax
f0104c8f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		stabstr_end = usd->stabstr_end;
f0104c92:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0104c98:	89 55 d0             	mov    %edx,-0x30(%ebp)
		if (user_mem_check(curenv, (void *)stabs, stab_end - stabs, PTE_U) < 0)
f0104c9b:	e8 37 0f 00 00       	call   f0105bd7 <cpunum>
f0104ca0:	6a 04                	push   $0x4
f0104ca2:	89 da                	mov    %ebx,%edx
f0104ca4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0104ca7:	29 ca                	sub    %ecx,%edx
f0104ca9:	c1 fa 02             	sar    $0x2,%edx
f0104cac:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0104cb2:	52                   	push   %edx
f0104cb3:	51                   	push   %ecx
f0104cb4:	6b c0 74             	imul   $0x74,%eax,%eax
f0104cb7:	ff b0 28 40 21 f0    	pushl  -0xfdebfd8(%eax)
f0104cbd:	e8 37 e2 ff ff       	call   f0102ef9 <user_mem_check>
f0104cc2:	83 c4 10             	add    $0x10,%esp
f0104cc5:	85 c0                	test   %eax,%eax
f0104cc7:	0f 88 b7 00 00 00    	js     f0104d84 <debuginfo_eip+0x259>
		if (user_mem_check(curenv, (void *)stabstr, stabstr_end - stabstr, PTE_U) < 0)
f0104ccd:	e8 05 0f 00 00       	call   f0105bd7 <cpunum>
f0104cd2:	6a 04                	push   $0x4
f0104cd4:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0104cd7:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0104cda:	29 ca                	sub    %ecx,%edx
f0104cdc:	52                   	push   %edx
f0104cdd:	51                   	push   %ecx
f0104cde:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ce1:	ff b0 28 40 21 f0    	pushl  -0xfdebfd8(%eax)
f0104ce7:	e8 0d e2 ff ff       	call   f0102ef9 <user_mem_check>
f0104cec:	83 c4 10             	add    $0x10,%esp
f0104cef:	85 c0                	test   %eax,%eax
f0104cf1:	0f 89 8e fe ff ff    	jns    f0104b85 <debuginfo_eip+0x5a>
			return -1;
f0104cf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104cfc:	e9 a4 00 00 00       	jmp    f0104da5 <debuginfo_eip+0x27a>
		info->eip_fn_addr = addr;
f0104d01:	89 7e 10             	mov    %edi,0x10(%esi)
		lline = lfile;
f0104d04:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104d07:	e9 20 ff ff ff       	jmp    f0104c2c <debuginfo_eip+0x101>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f0104d0c:	83 eb 01             	sub    $0x1,%ebx
f0104d0f:	83 e8 0c             	sub    $0xc,%eax
	while (lline >= lfile
f0104d12:	39 df                	cmp    %ebx,%edi
f0104d14:	7f 2e                	jg     f0104d44 <debuginfo_eip+0x219>
	       && stabs[lline].n_type != N_SOL
f0104d16:	0f b6 10             	movzbl (%eax),%edx
f0104d19:	80 fa 84             	cmp    $0x84,%dl
f0104d1c:	74 0b                	je     f0104d29 <debuginfo_eip+0x1fe>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104d1e:	80 fa 64             	cmp    $0x64,%dl
f0104d21:	75 e9                	jne    f0104d0c <debuginfo_eip+0x1e1>
f0104d23:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f0104d27:	74 e3                	je     f0104d0c <debuginfo_eip+0x1e1>
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104d29:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104d2c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0104d2f:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0104d32:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0104d35:	8b 7d cc             	mov    -0x34(%ebp),%edi
f0104d38:	29 f8                	sub    %edi,%eax
f0104d3a:	39 c2                	cmp    %eax,%edx
f0104d3c:	73 06                	jae    f0104d44 <debuginfo_eip+0x219>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0104d3e:	89 f8                	mov    %edi,%eax
f0104d40:	01 d0                	add    %edx,%eax
f0104d42:	89 06                	mov    %eax,(%esi)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0104d44:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0104d47:	8b 4d d8             	mov    -0x28(%ebp),%ecx
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0104d4a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0104d4f:	39 cb                	cmp    %ecx,%ebx
f0104d51:	7d 52                	jge    f0104da5 <debuginfo_eip+0x27a>
		for (lline = lfun + 1;
f0104d53:	8d 53 01             	lea    0x1(%ebx),%edx
f0104d56:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104d59:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0104d5c:	8d 44 87 10          	lea    0x10(%edi,%eax,4),%eax
f0104d60:	eb 07                	jmp    f0104d69 <debuginfo_eip+0x23e>
			info->eip_fn_narg++;
f0104d62:	83 46 14 01          	addl   $0x1,0x14(%esi)
		     lline++)
f0104d66:	83 c2 01             	add    $0x1,%edx
		for (lline = lfun + 1;
f0104d69:	39 d1                	cmp    %edx,%ecx
f0104d6b:	74 33                	je     f0104da0 <debuginfo_eip+0x275>
f0104d6d:	83 c0 0c             	add    $0xc,%eax
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0104d70:	80 78 f4 a0          	cmpb   $0xa0,-0xc(%eax)
f0104d74:	74 ec                	je     f0104d62 <debuginfo_eip+0x237>
	return 0;
f0104d76:	b8 00 00 00 00       	mov    $0x0,%eax
f0104d7b:	eb 28                	jmp    f0104da5 <debuginfo_eip+0x27a>
			return -1;
f0104d7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d82:	eb 21                	jmp    f0104da5 <debuginfo_eip+0x27a>
			return -1;
f0104d84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d89:	eb 1a                	jmp    f0104da5 <debuginfo_eip+0x27a>
		return -1;
f0104d8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d90:	eb 13                	jmp    f0104da5 <debuginfo_eip+0x27a>
f0104d92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d97:	eb 0c                	jmp    f0104da5 <debuginfo_eip+0x27a>
		return -1;
f0104d99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104d9e:	eb 05                	jmp    f0104da5 <debuginfo_eip+0x27a>
	return 0;
f0104da0:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104da8:	5b                   	pop    %ebx
f0104da9:	5e                   	pop    %esi
f0104daa:	5f                   	pop    %edi
f0104dab:	5d                   	pop    %ebp
f0104dac:	c3                   	ret    

f0104dad <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0104dad:	55                   	push   %ebp
f0104dae:	89 e5                	mov    %esp,%ebp
f0104db0:	57                   	push   %edi
f0104db1:	56                   	push   %esi
f0104db2:	53                   	push   %ebx
f0104db3:	83 ec 1c             	sub    $0x1c,%esp
f0104db6:	89 c7                	mov    %eax,%edi
f0104db8:	89 d6                	mov    %edx,%esi
f0104dba:	8b 45 08             	mov    0x8(%ebp),%eax
f0104dbd:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104dc0:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104dc3:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0104dc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104dc9:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104dce:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104dd1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0104dd4:	39 d3                	cmp    %edx,%ebx
f0104dd6:	72 05                	jb     f0104ddd <printnum+0x30>
f0104dd8:	39 45 10             	cmp    %eax,0x10(%ebp)
f0104ddb:	77 7a                	ja     f0104e57 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0104ddd:	83 ec 0c             	sub    $0xc,%esp
f0104de0:	ff 75 18             	pushl  0x18(%ebp)
f0104de3:	8b 45 14             	mov    0x14(%ebp),%eax
f0104de6:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0104de9:	53                   	push   %ebx
f0104dea:	ff 75 10             	pushl  0x10(%ebp)
f0104ded:	83 ec 08             	sub    $0x8,%esp
f0104df0:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104df3:	ff 75 e0             	pushl  -0x20(%ebp)
f0104df6:	ff 75 dc             	pushl  -0x24(%ebp)
f0104df9:	ff 75 d8             	pushl  -0x28(%ebp)
f0104dfc:	e8 cf 11 00 00       	call   f0105fd0 <__udivdi3>
f0104e01:	83 c4 18             	add    $0x18,%esp
f0104e04:	52                   	push   %edx
f0104e05:	50                   	push   %eax
f0104e06:	89 f2                	mov    %esi,%edx
f0104e08:	89 f8                	mov    %edi,%eax
f0104e0a:	e8 9e ff ff ff       	call   f0104dad <printnum>
f0104e0f:	83 c4 20             	add    $0x20,%esp
f0104e12:	eb 13                	jmp    f0104e27 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104e14:	83 ec 08             	sub    $0x8,%esp
f0104e17:	56                   	push   %esi
f0104e18:	ff 75 18             	pushl  0x18(%ebp)
f0104e1b:	ff d7                	call   *%edi
f0104e1d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0104e20:	83 eb 01             	sub    $0x1,%ebx
f0104e23:	85 db                	test   %ebx,%ebx
f0104e25:	7f ed                	jg     f0104e14 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0104e27:	83 ec 08             	sub    $0x8,%esp
f0104e2a:	56                   	push   %esi
f0104e2b:	83 ec 04             	sub    $0x4,%esp
f0104e2e:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104e31:	ff 75 e0             	pushl  -0x20(%ebp)
f0104e34:	ff 75 dc             	pushl  -0x24(%ebp)
f0104e37:	ff 75 d8             	pushl  -0x28(%ebp)
f0104e3a:	e8 b1 12 00 00       	call   f01060f0 <__umoddi3>
f0104e3f:	83 c4 14             	add    $0x14,%esp
f0104e42:	0f be 80 62 79 10 f0 	movsbl -0xfef869e(%eax),%eax
f0104e49:	50                   	push   %eax
f0104e4a:	ff d7                	call   *%edi
}
f0104e4c:	83 c4 10             	add    $0x10,%esp
f0104e4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104e52:	5b                   	pop    %ebx
f0104e53:	5e                   	pop    %esi
f0104e54:	5f                   	pop    %edi
f0104e55:	5d                   	pop    %ebp
f0104e56:	c3                   	ret    
f0104e57:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0104e5a:	eb c4                	jmp    f0104e20 <printnum+0x73>

f0104e5c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0104e5c:	55                   	push   %ebp
f0104e5d:	89 e5                	mov    %esp,%ebp
f0104e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0104e62:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0104e66:	8b 10                	mov    (%eax),%edx
f0104e68:	3b 50 04             	cmp    0x4(%eax),%edx
f0104e6b:	73 0a                	jae    f0104e77 <sprintputch+0x1b>
		*b->buf++ = ch;
f0104e6d:	8d 4a 01             	lea    0x1(%edx),%ecx
f0104e70:	89 08                	mov    %ecx,(%eax)
f0104e72:	8b 45 08             	mov    0x8(%ebp),%eax
f0104e75:	88 02                	mov    %al,(%edx)
}
f0104e77:	5d                   	pop    %ebp
f0104e78:	c3                   	ret    

f0104e79 <printfmt>:
{
f0104e79:	55                   	push   %ebp
f0104e7a:	89 e5                	mov    %esp,%ebp
f0104e7c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0104e7f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0104e82:	50                   	push   %eax
f0104e83:	ff 75 10             	pushl  0x10(%ebp)
f0104e86:	ff 75 0c             	pushl  0xc(%ebp)
f0104e89:	ff 75 08             	pushl  0x8(%ebp)
f0104e8c:	e8 05 00 00 00       	call   f0104e96 <vprintfmt>
}
f0104e91:	83 c4 10             	add    $0x10,%esp
f0104e94:	c9                   	leave  
f0104e95:	c3                   	ret    

f0104e96 <vprintfmt>:
{
f0104e96:	55                   	push   %ebp
f0104e97:	89 e5                	mov    %esp,%ebp
f0104e99:	57                   	push   %edi
f0104e9a:	56                   	push   %esi
f0104e9b:	53                   	push   %ebx
f0104e9c:	83 ec 2c             	sub    $0x2c,%esp
f0104e9f:	8b 75 08             	mov    0x8(%ebp),%esi
f0104ea2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104ea5:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104ea8:	e9 8c 03 00 00       	jmp    f0105239 <vprintfmt+0x3a3>
		padc = ' ';
f0104ead:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
f0104eb1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f0104eb8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
f0104ebf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0104ec6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0104ecb:	8d 47 01             	lea    0x1(%edi),%eax
f0104ece:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0104ed1:	0f b6 17             	movzbl (%edi),%edx
f0104ed4:	8d 42 dd             	lea    -0x23(%edx),%eax
f0104ed7:	3c 55                	cmp    $0x55,%al
f0104ed9:	0f 87 dd 03 00 00    	ja     f01052bc <vprintfmt+0x426>
f0104edf:	0f b6 c0             	movzbl %al,%eax
f0104ee2:	ff 24 85 a0 7a 10 f0 	jmp    *-0xfef8560(,%eax,4)
f0104ee9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0104eec:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f0104ef0:	eb d9                	jmp    f0104ecb <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f0104ef2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0104ef5:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0104ef9:	eb d0                	jmp    f0104ecb <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f0104efb:	0f b6 d2             	movzbl %dl,%edx
f0104efe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0104f01:	b8 00 00 00 00       	mov    $0x0,%eax
f0104f06:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f0104f09:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0104f0c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0104f10:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0104f13:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0104f16:	83 f9 09             	cmp    $0x9,%ecx
f0104f19:	77 55                	ja     f0104f70 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
f0104f1b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0104f1e:	eb e9                	jmp    f0104f09 <vprintfmt+0x73>
			precision = va_arg(ap, int);
f0104f20:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f23:	8b 00                	mov    (%eax),%eax
f0104f25:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104f28:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f2b:	8d 40 04             	lea    0x4(%eax),%eax
f0104f2e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104f31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0104f34:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0104f38:	79 91                	jns    f0104ecb <vprintfmt+0x35>
				width = precision, precision = -1;
f0104f3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0104f3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104f40:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f0104f47:	eb 82                	jmp    f0104ecb <vprintfmt+0x35>
f0104f49:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104f4c:	85 c0                	test   %eax,%eax
f0104f4e:	ba 00 00 00 00       	mov    $0x0,%edx
f0104f53:	0f 49 d0             	cmovns %eax,%edx
f0104f56:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0104f59:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104f5c:	e9 6a ff ff ff       	jmp    f0104ecb <vprintfmt+0x35>
f0104f61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0104f64:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f0104f6b:	e9 5b ff ff ff       	jmp    f0104ecb <vprintfmt+0x35>
f0104f70:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0104f73:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104f76:	eb bc                	jmp    f0104f34 <vprintfmt+0x9e>
			lflag++;
f0104f78:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0104f7b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0104f7e:	e9 48 ff ff ff       	jmp    f0104ecb <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
f0104f83:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f86:	8d 78 04             	lea    0x4(%eax),%edi
f0104f89:	83 ec 08             	sub    $0x8,%esp
f0104f8c:	53                   	push   %ebx
f0104f8d:	ff 30                	pushl  (%eax)
f0104f8f:	ff d6                	call   *%esi
			break;
f0104f91:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0104f94:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0104f97:	e9 9a 02 00 00       	jmp    f0105236 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
f0104f9c:	8b 45 14             	mov    0x14(%ebp),%eax
f0104f9f:	8d 78 04             	lea    0x4(%eax),%edi
f0104fa2:	8b 00                	mov    (%eax),%eax
f0104fa4:	99                   	cltd   
f0104fa5:	31 d0                	xor    %edx,%eax
f0104fa7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0104fa9:	83 f8 0f             	cmp    $0xf,%eax
f0104fac:	7f 23                	jg     f0104fd1 <vprintfmt+0x13b>
f0104fae:	8b 14 85 00 7c 10 f0 	mov    -0xfef8400(,%eax,4),%edx
f0104fb5:	85 d2                	test   %edx,%edx
f0104fb7:	74 18                	je     f0104fd1 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
f0104fb9:	52                   	push   %edx
f0104fba:	68 a3 67 10 f0       	push   $0xf01067a3
f0104fbf:	53                   	push   %ebx
f0104fc0:	56                   	push   %esi
f0104fc1:	e8 b3 fe ff ff       	call   f0104e79 <printfmt>
f0104fc6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104fc9:	89 7d 14             	mov    %edi,0x14(%ebp)
f0104fcc:	e9 65 02 00 00       	jmp    f0105236 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
f0104fd1:	50                   	push   %eax
f0104fd2:	68 7a 79 10 f0       	push   $0xf010797a
f0104fd7:	53                   	push   %ebx
f0104fd8:	56                   	push   %esi
f0104fd9:	e8 9b fe ff ff       	call   f0104e79 <printfmt>
f0104fde:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0104fe1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0104fe4:	e9 4d 02 00 00       	jmp    f0105236 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
f0104fe9:	8b 45 14             	mov    0x14(%ebp),%eax
f0104fec:	83 c0 04             	add    $0x4,%eax
f0104fef:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0104ff2:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ff5:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f0104ff7:	85 ff                	test   %edi,%edi
f0104ff9:	b8 73 79 10 f0       	mov    $0xf0107973,%eax
f0104ffe:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f0105001:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105005:	0f 8e bd 00 00 00    	jle    f01050c8 <vprintfmt+0x232>
f010500b:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f010500f:	75 0e                	jne    f010501f <vprintfmt+0x189>
f0105011:	89 75 08             	mov    %esi,0x8(%ebp)
f0105014:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0105017:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f010501a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f010501d:	eb 6d                	jmp    f010508c <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
f010501f:	83 ec 08             	sub    $0x8,%esp
f0105022:	ff 75 d0             	pushl  -0x30(%ebp)
f0105025:	57                   	push   %edi
f0105026:	e8 27 04 00 00       	call   f0105452 <strnlen>
f010502b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010502e:	29 c1                	sub    %eax,%ecx
f0105030:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f0105033:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f0105036:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f010503a:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010503d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105040:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105042:	eb 0f                	jmp    f0105053 <vprintfmt+0x1bd>
					putch(padc, putdat);
f0105044:	83 ec 08             	sub    $0x8,%esp
f0105047:	53                   	push   %ebx
f0105048:	ff 75 e0             	pushl  -0x20(%ebp)
f010504b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f010504d:	83 ef 01             	sub    $0x1,%edi
f0105050:	83 c4 10             	add    $0x10,%esp
f0105053:	85 ff                	test   %edi,%edi
f0105055:	7f ed                	jg     f0105044 <vprintfmt+0x1ae>
f0105057:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f010505a:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f010505d:	85 c9                	test   %ecx,%ecx
f010505f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105064:	0f 49 c1             	cmovns %ecx,%eax
f0105067:	29 c1                	sub    %eax,%ecx
f0105069:	89 75 08             	mov    %esi,0x8(%ebp)
f010506c:	8b 75 d0             	mov    -0x30(%ebp),%esi
f010506f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0105072:	89 cb                	mov    %ecx,%ebx
f0105074:	eb 16                	jmp    f010508c <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
f0105076:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f010507a:	75 31                	jne    f01050ad <vprintfmt+0x217>
					putch(ch, putdat);
f010507c:	83 ec 08             	sub    $0x8,%esp
f010507f:	ff 75 0c             	pushl  0xc(%ebp)
f0105082:	50                   	push   %eax
f0105083:	ff 55 08             	call   *0x8(%ebp)
f0105086:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105089:	83 eb 01             	sub    $0x1,%ebx
f010508c:	83 c7 01             	add    $0x1,%edi
f010508f:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
f0105093:	0f be c2             	movsbl %dl,%eax
f0105096:	85 c0                	test   %eax,%eax
f0105098:	74 59                	je     f01050f3 <vprintfmt+0x25d>
f010509a:	85 f6                	test   %esi,%esi
f010509c:	78 d8                	js     f0105076 <vprintfmt+0x1e0>
f010509e:	83 ee 01             	sub    $0x1,%esi
f01050a1:	79 d3                	jns    f0105076 <vprintfmt+0x1e0>
f01050a3:	89 df                	mov    %ebx,%edi
f01050a5:	8b 75 08             	mov    0x8(%ebp),%esi
f01050a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01050ab:	eb 37                	jmp    f01050e4 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
f01050ad:	0f be d2             	movsbl %dl,%edx
f01050b0:	83 ea 20             	sub    $0x20,%edx
f01050b3:	83 fa 5e             	cmp    $0x5e,%edx
f01050b6:	76 c4                	jbe    f010507c <vprintfmt+0x1e6>
					putch('?', putdat);
f01050b8:	83 ec 08             	sub    $0x8,%esp
f01050bb:	ff 75 0c             	pushl  0xc(%ebp)
f01050be:	6a 3f                	push   $0x3f
f01050c0:	ff 55 08             	call   *0x8(%ebp)
f01050c3:	83 c4 10             	add    $0x10,%esp
f01050c6:	eb c1                	jmp    f0105089 <vprintfmt+0x1f3>
f01050c8:	89 75 08             	mov    %esi,0x8(%ebp)
f01050cb:	8b 75 d0             	mov    -0x30(%ebp),%esi
f01050ce:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f01050d1:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f01050d4:	eb b6                	jmp    f010508c <vprintfmt+0x1f6>
				putch(' ', putdat);
f01050d6:	83 ec 08             	sub    $0x8,%esp
f01050d9:	53                   	push   %ebx
f01050da:	6a 20                	push   $0x20
f01050dc:	ff d6                	call   *%esi
			for (; width > 0; width--)
f01050de:	83 ef 01             	sub    $0x1,%edi
f01050e1:	83 c4 10             	add    $0x10,%esp
f01050e4:	85 ff                	test   %edi,%edi
f01050e6:	7f ee                	jg     f01050d6 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
f01050e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01050eb:	89 45 14             	mov    %eax,0x14(%ebp)
f01050ee:	e9 43 01 00 00       	jmp    f0105236 <vprintfmt+0x3a0>
f01050f3:	89 df                	mov    %ebx,%edi
f01050f5:	8b 75 08             	mov    0x8(%ebp),%esi
f01050f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01050fb:	eb e7                	jmp    f01050e4 <vprintfmt+0x24e>
	if (lflag >= 2)
f01050fd:	83 f9 01             	cmp    $0x1,%ecx
f0105100:	7e 3f                	jle    f0105141 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
f0105102:	8b 45 14             	mov    0x14(%ebp),%eax
f0105105:	8b 50 04             	mov    0x4(%eax),%edx
f0105108:	8b 00                	mov    (%eax),%eax
f010510a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010510d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105110:	8b 45 14             	mov    0x14(%ebp),%eax
f0105113:	8d 40 08             	lea    0x8(%eax),%eax
f0105116:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f0105119:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f010511d:	79 5c                	jns    f010517b <vprintfmt+0x2e5>
				putch('-', putdat);
f010511f:	83 ec 08             	sub    $0x8,%esp
f0105122:	53                   	push   %ebx
f0105123:	6a 2d                	push   $0x2d
f0105125:	ff d6                	call   *%esi
				num = -(long long) num;
f0105127:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010512a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010512d:	f7 da                	neg    %edx
f010512f:	83 d1 00             	adc    $0x0,%ecx
f0105132:	f7 d9                	neg    %ecx
f0105134:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0105137:	b8 0a 00 00 00       	mov    $0xa,%eax
f010513c:	e9 db 00 00 00       	jmp    f010521c <vprintfmt+0x386>
	else if (lflag)
f0105141:	85 c9                	test   %ecx,%ecx
f0105143:	75 1b                	jne    f0105160 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
f0105145:	8b 45 14             	mov    0x14(%ebp),%eax
f0105148:	8b 00                	mov    (%eax),%eax
f010514a:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010514d:	89 c1                	mov    %eax,%ecx
f010514f:	c1 f9 1f             	sar    $0x1f,%ecx
f0105152:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105155:	8b 45 14             	mov    0x14(%ebp),%eax
f0105158:	8d 40 04             	lea    0x4(%eax),%eax
f010515b:	89 45 14             	mov    %eax,0x14(%ebp)
f010515e:	eb b9                	jmp    f0105119 <vprintfmt+0x283>
		return va_arg(*ap, long);
f0105160:	8b 45 14             	mov    0x14(%ebp),%eax
f0105163:	8b 00                	mov    (%eax),%eax
f0105165:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105168:	89 c1                	mov    %eax,%ecx
f010516a:	c1 f9 1f             	sar    $0x1f,%ecx
f010516d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105170:	8b 45 14             	mov    0x14(%ebp),%eax
f0105173:	8d 40 04             	lea    0x4(%eax),%eax
f0105176:	89 45 14             	mov    %eax,0x14(%ebp)
f0105179:	eb 9e                	jmp    f0105119 <vprintfmt+0x283>
			num = getint(&ap, lflag);
f010517b:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010517e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f0105181:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105186:	e9 91 00 00 00       	jmp    f010521c <vprintfmt+0x386>
	if (lflag >= 2)
f010518b:	83 f9 01             	cmp    $0x1,%ecx
f010518e:	7e 15                	jle    f01051a5 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
f0105190:	8b 45 14             	mov    0x14(%ebp),%eax
f0105193:	8b 10                	mov    (%eax),%edx
f0105195:	8b 48 04             	mov    0x4(%eax),%ecx
f0105198:	8d 40 08             	lea    0x8(%eax),%eax
f010519b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010519e:	b8 0a 00 00 00       	mov    $0xa,%eax
f01051a3:	eb 77                	jmp    f010521c <vprintfmt+0x386>
	else if (lflag)
f01051a5:	85 c9                	test   %ecx,%ecx
f01051a7:	75 17                	jne    f01051c0 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
f01051a9:	8b 45 14             	mov    0x14(%ebp),%eax
f01051ac:	8b 10                	mov    (%eax),%edx
f01051ae:	b9 00 00 00 00       	mov    $0x0,%ecx
f01051b3:	8d 40 04             	lea    0x4(%eax),%eax
f01051b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01051b9:	b8 0a 00 00 00       	mov    $0xa,%eax
f01051be:	eb 5c                	jmp    f010521c <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
f01051c0:	8b 45 14             	mov    0x14(%ebp),%eax
f01051c3:	8b 10                	mov    (%eax),%edx
f01051c5:	b9 00 00 00 00       	mov    $0x0,%ecx
f01051ca:	8d 40 04             	lea    0x4(%eax),%eax
f01051cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01051d0:	b8 0a 00 00 00       	mov    $0xa,%eax
f01051d5:	eb 45                	jmp    f010521c <vprintfmt+0x386>
			putch('X', putdat);
f01051d7:	83 ec 08             	sub    $0x8,%esp
f01051da:	53                   	push   %ebx
f01051db:	6a 58                	push   $0x58
f01051dd:	ff d6                	call   *%esi
			putch('X', putdat);
f01051df:	83 c4 08             	add    $0x8,%esp
f01051e2:	53                   	push   %ebx
f01051e3:	6a 58                	push   $0x58
f01051e5:	ff d6                	call   *%esi
			putch('X', putdat);
f01051e7:	83 c4 08             	add    $0x8,%esp
f01051ea:	53                   	push   %ebx
f01051eb:	6a 58                	push   $0x58
f01051ed:	ff d6                	call   *%esi
			break;
f01051ef:	83 c4 10             	add    $0x10,%esp
f01051f2:	eb 42                	jmp    f0105236 <vprintfmt+0x3a0>
			putch('0', putdat);
f01051f4:	83 ec 08             	sub    $0x8,%esp
f01051f7:	53                   	push   %ebx
f01051f8:	6a 30                	push   $0x30
f01051fa:	ff d6                	call   *%esi
			putch('x', putdat);
f01051fc:	83 c4 08             	add    $0x8,%esp
f01051ff:	53                   	push   %ebx
f0105200:	6a 78                	push   $0x78
f0105202:	ff d6                	call   *%esi
			num = (unsigned long long)
f0105204:	8b 45 14             	mov    0x14(%ebp),%eax
f0105207:	8b 10                	mov    (%eax),%edx
f0105209:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f010520e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f0105211:	8d 40 04             	lea    0x4(%eax),%eax
f0105214:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105217:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f010521c:	83 ec 0c             	sub    $0xc,%esp
f010521f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
f0105223:	57                   	push   %edi
f0105224:	ff 75 e0             	pushl  -0x20(%ebp)
f0105227:	50                   	push   %eax
f0105228:	51                   	push   %ecx
f0105229:	52                   	push   %edx
f010522a:	89 da                	mov    %ebx,%edx
f010522c:	89 f0                	mov    %esi,%eax
f010522e:	e8 7a fb ff ff       	call   f0104dad <printnum>
			break;
f0105233:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f0105236:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105239:	83 c7 01             	add    $0x1,%edi
f010523c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105240:	83 f8 25             	cmp    $0x25,%eax
f0105243:	0f 84 64 fc ff ff    	je     f0104ead <vprintfmt+0x17>
			if (ch == '\0')
f0105249:	85 c0                	test   %eax,%eax
f010524b:	0f 84 8b 00 00 00    	je     f01052dc <vprintfmt+0x446>
			putch(ch, putdat);
f0105251:	83 ec 08             	sub    $0x8,%esp
f0105254:	53                   	push   %ebx
f0105255:	50                   	push   %eax
f0105256:	ff d6                	call   *%esi
f0105258:	83 c4 10             	add    $0x10,%esp
f010525b:	eb dc                	jmp    f0105239 <vprintfmt+0x3a3>
	if (lflag >= 2)
f010525d:	83 f9 01             	cmp    $0x1,%ecx
f0105260:	7e 15                	jle    f0105277 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
f0105262:	8b 45 14             	mov    0x14(%ebp),%eax
f0105265:	8b 10                	mov    (%eax),%edx
f0105267:	8b 48 04             	mov    0x4(%eax),%ecx
f010526a:	8d 40 08             	lea    0x8(%eax),%eax
f010526d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105270:	b8 10 00 00 00       	mov    $0x10,%eax
f0105275:	eb a5                	jmp    f010521c <vprintfmt+0x386>
	else if (lflag)
f0105277:	85 c9                	test   %ecx,%ecx
f0105279:	75 17                	jne    f0105292 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
f010527b:	8b 45 14             	mov    0x14(%ebp),%eax
f010527e:	8b 10                	mov    (%eax),%edx
f0105280:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105285:	8d 40 04             	lea    0x4(%eax),%eax
f0105288:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010528b:	b8 10 00 00 00       	mov    $0x10,%eax
f0105290:	eb 8a                	jmp    f010521c <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
f0105292:	8b 45 14             	mov    0x14(%ebp),%eax
f0105295:	8b 10                	mov    (%eax),%edx
f0105297:	b9 00 00 00 00       	mov    $0x0,%ecx
f010529c:	8d 40 04             	lea    0x4(%eax),%eax
f010529f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01052a2:	b8 10 00 00 00       	mov    $0x10,%eax
f01052a7:	e9 70 ff ff ff       	jmp    f010521c <vprintfmt+0x386>
			putch(ch, putdat);
f01052ac:	83 ec 08             	sub    $0x8,%esp
f01052af:	53                   	push   %ebx
f01052b0:	6a 25                	push   $0x25
f01052b2:	ff d6                	call   *%esi
			break;
f01052b4:	83 c4 10             	add    $0x10,%esp
f01052b7:	e9 7a ff ff ff       	jmp    f0105236 <vprintfmt+0x3a0>
			putch('%', putdat);
f01052bc:	83 ec 08             	sub    $0x8,%esp
f01052bf:	53                   	push   %ebx
f01052c0:	6a 25                	push   $0x25
f01052c2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01052c4:	83 c4 10             	add    $0x10,%esp
f01052c7:	89 f8                	mov    %edi,%eax
f01052c9:	eb 03                	jmp    f01052ce <vprintfmt+0x438>
f01052cb:	83 e8 01             	sub    $0x1,%eax
f01052ce:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01052d2:	75 f7                	jne    f01052cb <vprintfmt+0x435>
f01052d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01052d7:	e9 5a ff ff ff       	jmp    f0105236 <vprintfmt+0x3a0>
}
f01052dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01052df:	5b                   	pop    %ebx
f01052e0:	5e                   	pop    %esi
f01052e1:	5f                   	pop    %edi
f01052e2:	5d                   	pop    %ebp
f01052e3:	c3                   	ret    

f01052e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01052e4:	55                   	push   %ebp
f01052e5:	89 e5                	mov    %esp,%ebp
f01052e7:	83 ec 18             	sub    $0x18,%esp
f01052ea:	8b 45 08             	mov    0x8(%ebp),%eax
f01052ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01052f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01052f3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01052f7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01052fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0105301:	85 c0                	test   %eax,%eax
f0105303:	74 26                	je     f010532b <vsnprintf+0x47>
f0105305:	85 d2                	test   %edx,%edx
f0105307:	7e 22                	jle    f010532b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0105309:	ff 75 14             	pushl  0x14(%ebp)
f010530c:	ff 75 10             	pushl  0x10(%ebp)
f010530f:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105312:	50                   	push   %eax
f0105313:	68 5c 4e 10 f0       	push   $0xf0104e5c
f0105318:	e8 79 fb ff ff       	call   f0104e96 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010531d:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105320:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0105323:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105326:	83 c4 10             	add    $0x10,%esp
}
f0105329:	c9                   	leave  
f010532a:	c3                   	ret    
		return -E_INVAL;
f010532b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105330:	eb f7                	jmp    f0105329 <vsnprintf+0x45>

f0105332 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0105332:	55                   	push   %ebp
f0105333:	89 e5                	mov    %esp,%ebp
f0105335:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0105338:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f010533b:	50                   	push   %eax
f010533c:	ff 75 10             	pushl  0x10(%ebp)
f010533f:	ff 75 0c             	pushl  0xc(%ebp)
f0105342:	ff 75 08             	pushl  0x8(%ebp)
f0105345:	e8 9a ff ff ff       	call   f01052e4 <vsnprintf>
	va_end(ap);

	return rc;
}
f010534a:	c9                   	leave  
f010534b:	c3                   	ret    

f010534c <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010534c:	55                   	push   %ebp
f010534d:	89 e5                	mov    %esp,%ebp
f010534f:	57                   	push   %edi
f0105350:	56                   	push   %esi
f0105351:	53                   	push   %ebx
f0105352:	83 ec 0c             	sub    $0xc,%esp
f0105355:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0105358:	85 c0                	test   %eax,%eax
f010535a:	74 11                	je     f010536d <readline+0x21>
		cprintf("%s", prompt);
f010535c:	83 ec 08             	sub    $0x8,%esp
f010535f:	50                   	push   %eax
f0105360:	68 a3 67 10 f0       	push   $0xf01067a3
f0105365:	e8 a9 e5 ff ff       	call   f0103913 <cprintf>
f010536a:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f010536d:	83 ec 0c             	sub    $0xc,%esp
f0105370:	6a 00                	push   $0x0
f0105372:	e8 5f b4 ff ff       	call   f01007d6 <iscons>
f0105377:	89 c7                	mov    %eax,%edi
f0105379:	83 c4 10             	add    $0x10,%esp
	i = 0;
f010537c:	be 00 00 00 00       	mov    $0x0,%esi
f0105381:	eb 4b                	jmp    f01053ce <readline+0x82>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0105383:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f0105388:	83 fb f8             	cmp    $0xfffffff8,%ebx
f010538b:	75 08                	jne    f0105395 <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f010538d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105390:	5b                   	pop    %ebx
f0105391:	5e                   	pop    %esi
f0105392:	5f                   	pop    %edi
f0105393:	5d                   	pop    %ebp
f0105394:	c3                   	ret    
				cprintf("read error: %e\n", c);
f0105395:	83 ec 08             	sub    $0x8,%esp
f0105398:	53                   	push   %ebx
f0105399:	68 5f 7c 10 f0       	push   $0xf0107c5f
f010539e:	e8 70 e5 ff ff       	call   f0103913 <cprintf>
f01053a3:	83 c4 10             	add    $0x10,%esp
			return NULL;
f01053a6:	b8 00 00 00 00       	mov    $0x0,%eax
f01053ab:	eb e0                	jmp    f010538d <readline+0x41>
			if (echoing)
f01053ad:	85 ff                	test   %edi,%edi
f01053af:	75 05                	jne    f01053b6 <readline+0x6a>
			i--;
f01053b1:	83 ee 01             	sub    $0x1,%esi
f01053b4:	eb 18                	jmp    f01053ce <readline+0x82>
				cputchar('\b');
f01053b6:	83 ec 0c             	sub    $0xc,%esp
f01053b9:	6a 08                	push   $0x8
f01053bb:	e8 f5 b3 ff ff       	call   f01007b5 <cputchar>
f01053c0:	83 c4 10             	add    $0x10,%esp
f01053c3:	eb ec                	jmp    f01053b1 <readline+0x65>
			buf[i++] = c;
f01053c5:	88 9e 80 3a 21 f0    	mov    %bl,-0xfdec580(%esi)
f01053cb:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01053ce:	e8 f2 b3 ff ff       	call   f01007c5 <getchar>
f01053d3:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01053d5:	85 c0                	test   %eax,%eax
f01053d7:	78 aa                	js     f0105383 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01053d9:	83 f8 08             	cmp    $0x8,%eax
f01053dc:	0f 94 c2             	sete   %dl
f01053df:	83 f8 7f             	cmp    $0x7f,%eax
f01053e2:	0f 94 c0             	sete   %al
f01053e5:	08 c2                	or     %al,%dl
f01053e7:	74 04                	je     f01053ed <readline+0xa1>
f01053e9:	85 f6                	test   %esi,%esi
f01053eb:	7f c0                	jg     f01053ad <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01053ed:	83 fb 1f             	cmp    $0x1f,%ebx
f01053f0:	7e 1a                	jle    f010540c <readline+0xc0>
f01053f2:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01053f8:	7f 12                	jg     f010540c <readline+0xc0>
			if (echoing)
f01053fa:	85 ff                	test   %edi,%edi
f01053fc:	74 c7                	je     f01053c5 <readline+0x79>
				cputchar(c);
f01053fe:	83 ec 0c             	sub    $0xc,%esp
f0105401:	53                   	push   %ebx
f0105402:	e8 ae b3 ff ff       	call   f01007b5 <cputchar>
f0105407:	83 c4 10             	add    $0x10,%esp
f010540a:	eb b9                	jmp    f01053c5 <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f010540c:	83 fb 0a             	cmp    $0xa,%ebx
f010540f:	74 05                	je     f0105416 <readline+0xca>
f0105411:	83 fb 0d             	cmp    $0xd,%ebx
f0105414:	75 b8                	jne    f01053ce <readline+0x82>
			if (echoing)
f0105416:	85 ff                	test   %edi,%edi
f0105418:	75 11                	jne    f010542b <readline+0xdf>
			buf[i] = 0;
f010541a:	c6 86 80 3a 21 f0 00 	movb   $0x0,-0xfdec580(%esi)
			return buf;
f0105421:	b8 80 3a 21 f0       	mov    $0xf0213a80,%eax
f0105426:	e9 62 ff ff ff       	jmp    f010538d <readline+0x41>
				cputchar('\n');
f010542b:	83 ec 0c             	sub    $0xc,%esp
f010542e:	6a 0a                	push   $0xa
f0105430:	e8 80 b3 ff ff       	call   f01007b5 <cputchar>
f0105435:	83 c4 10             	add    $0x10,%esp
f0105438:	eb e0                	jmp    f010541a <readline+0xce>

f010543a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f010543a:	55                   	push   %ebp
f010543b:	89 e5                	mov    %esp,%ebp
f010543d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0105440:	b8 00 00 00 00       	mov    $0x0,%eax
f0105445:	eb 03                	jmp    f010544a <strlen+0x10>
		n++;
f0105447:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f010544a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f010544e:	75 f7                	jne    f0105447 <strlen+0xd>
	return n;
}
f0105450:	5d                   	pop    %ebp
f0105451:	c3                   	ret    

f0105452 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105452:	55                   	push   %ebp
f0105453:	89 e5                	mov    %esp,%ebp
f0105455:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105458:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010545b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105460:	eb 03                	jmp    f0105465 <strnlen+0x13>
		n++;
f0105462:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105465:	39 d0                	cmp    %edx,%eax
f0105467:	74 06                	je     f010546f <strnlen+0x1d>
f0105469:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f010546d:	75 f3                	jne    f0105462 <strnlen+0x10>
	return n;
}
f010546f:	5d                   	pop    %ebp
f0105470:	c3                   	ret    

f0105471 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105471:	55                   	push   %ebp
f0105472:	89 e5                	mov    %esp,%ebp
f0105474:	53                   	push   %ebx
f0105475:	8b 45 08             	mov    0x8(%ebp),%eax
f0105478:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f010547b:	89 c2                	mov    %eax,%edx
f010547d:	83 c1 01             	add    $0x1,%ecx
f0105480:	83 c2 01             	add    $0x1,%edx
f0105483:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f0105487:	88 5a ff             	mov    %bl,-0x1(%edx)
f010548a:	84 db                	test   %bl,%bl
f010548c:	75 ef                	jne    f010547d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f010548e:	5b                   	pop    %ebx
f010548f:	5d                   	pop    %ebp
f0105490:	c3                   	ret    

f0105491 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105491:	55                   	push   %ebp
f0105492:	89 e5                	mov    %esp,%ebp
f0105494:	53                   	push   %ebx
f0105495:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105498:	53                   	push   %ebx
f0105499:	e8 9c ff ff ff       	call   f010543a <strlen>
f010549e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f01054a1:	ff 75 0c             	pushl  0xc(%ebp)
f01054a4:	01 d8                	add    %ebx,%eax
f01054a6:	50                   	push   %eax
f01054a7:	e8 c5 ff ff ff       	call   f0105471 <strcpy>
	return dst;
}
f01054ac:	89 d8                	mov    %ebx,%eax
f01054ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01054b1:	c9                   	leave  
f01054b2:	c3                   	ret    

f01054b3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01054b3:	55                   	push   %ebp
f01054b4:	89 e5                	mov    %esp,%ebp
f01054b6:	56                   	push   %esi
f01054b7:	53                   	push   %ebx
f01054b8:	8b 75 08             	mov    0x8(%ebp),%esi
f01054bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01054be:	89 f3                	mov    %esi,%ebx
f01054c0:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01054c3:	89 f2                	mov    %esi,%edx
f01054c5:	eb 0f                	jmp    f01054d6 <strncpy+0x23>
		*dst++ = *src;
f01054c7:	83 c2 01             	add    $0x1,%edx
f01054ca:	0f b6 01             	movzbl (%ecx),%eax
f01054cd:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01054d0:	80 39 01             	cmpb   $0x1,(%ecx)
f01054d3:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
f01054d6:	39 da                	cmp    %ebx,%edx
f01054d8:	75 ed                	jne    f01054c7 <strncpy+0x14>
	}
	return ret;
}
f01054da:	89 f0                	mov    %esi,%eax
f01054dc:	5b                   	pop    %ebx
f01054dd:	5e                   	pop    %esi
f01054de:	5d                   	pop    %ebp
f01054df:	c3                   	ret    

f01054e0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01054e0:	55                   	push   %ebp
f01054e1:	89 e5                	mov    %esp,%ebp
f01054e3:	56                   	push   %esi
f01054e4:	53                   	push   %ebx
f01054e5:	8b 75 08             	mov    0x8(%ebp),%esi
f01054e8:	8b 55 0c             	mov    0xc(%ebp),%edx
f01054eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01054ee:	89 f0                	mov    %esi,%eax
f01054f0:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01054f4:	85 c9                	test   %ecx,%ecx
f01054f6:	75 0b                	jne    f0105503 <strlcpy+0x23>
f01054f8:	eb 17                	jmp    f0105511 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f01054fa:	83 c2 01             	add    $0x1,%edx
f01054fd:	83 c0 01             	add    $0x1,%eax
f0105500:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
f0105503:	39 d8                	cmp    %ebx,%eax
f0105505:	74 07                	je     f010550e <strlcpy+0x2e>
f0105507:	0f b6 0a             	movzbl (%edx),%ecx
f010550a:	84 c9                	test   %cl,%cl
f010550c:	75 ec                	jne    f01054fa <strlcpy+0x1a>
		*dst = '\0';
f010550e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0105511:	29 f0                	sub    %esi,%eax
}
f0105513:	5b                   	pop    %ebx
f0105514:	5e                   	pop    %esi
f0105515:	5d                   	pop    %ebp
f0105516:	c3                   	ret    

f0105517 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105517:	55                   	push   %ebp
f0105518:	89 e5                	mov    %esp,%ebp
f010551a:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010551d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105520:	eb 06                	jmp    f0105528 <strcmp+0x11>
		p++, q++;
f0105522:	83 c1 01             	add    $0x1,%ecx
f0105525:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f0105528:	0f b6 01             	movzbl (%ecx),%eax
f010552b:	84 c0                	test   %al,%al
f010552d:	74 04                	je     f0105533 <strcmp+0x1c>
f010552f:	3a 02                	cmp    (%edx),%al
f0105531:	74 ef                	je     f0105522 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105533:	0f b6 c0             	movzbl %al,%eax
f0105536:	0f b6 12             	movzbl (%edx),%edx
f0105539:	29 d0                	sub    %edx,%eax
}
f010553b:	5d                   	pop    %ebp
f010553c:	c3                   	ret    

f010553d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010553d:	55                   	push   %ebp
f010553e:	89 e5                	mov    %esp,%ebp
f0105540:	53                   	push   %ebx
f0105541:	8b 45 08             	mov    0x8(%ebp),%eax
f0105544:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105547:	89 c3                	mov    %eax,%ebx
f0105549:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f010554c:	eb 06                	jmp    f0105554 <strncmp+0x17>
		n--, p++, q++;
f010554e:	83 c0 01             	add    $0x1,%eax
f0105551:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105554:	39 d8                	cmp    %ebx,%eax
f0105556:	74 16                	je     f010556e <strncmp+0x31>
f0105558:	0f b6 08             	movzbl (%eax),%ecx
f010555b:	84 c9                	test   %cl,%cl
f010555d:	74 04                	je     f0105563 <strncmp+0x26>
f010555f:	3a 0a                	cmp    (%edx),%cl
f0105561:	74 eb                	je     f010554e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105563:	0f b6 00             	movzbl (%eax),%eax
f0105566:	0f b6 12             	movzbl (%edx),%edx
f0105569:	29 d0                	sub    %edx,%eax
}
f010556b:	5b                   	pop    %ebx
f010556c:	5d                   	pop    %ebp
f010556d:	c3                   	ret    
		return 0;
f010556e:	b8 00 00 00 00       	mov    $0x0,%eax
f0105573:	eb f6                	jmp    f010556b <strncmp+0x2e>

f0105575 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105575:	55                   	push   %ebp
f0105576:	89 e5                	mov    %esp,%ebp
f0105578:	8b 45 08             	mov    0x8(%ebp),%eax
f010557b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010557f:	0f b6 10             	movzbl (%eax),%edx
f0105582:	84 d2                	test   %dl,%dl
f0105584:	74 09                	je     f010558f <strchr+0x1a>
		if (*s == c)
f0105586:	38 ca                	cmp    %cl,%dl
f0105588:	74 0a                	je     f0105594 <strchr+0x1f>
	for (; *s; s++)
f010558a:	83 c0 01             	add    $0x1,%eax
f010558d:	eb f0                	jmp    f010557f <strchr+0xa>
			return (char *) s;
	return 0;
f010558f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105594:	5d                   	pop    %ebp
f0105595:	c3                   	ret    

f0105596 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105596:	55                   	push   %ebp
f0105597:	89 e5                	mov    %esp,%ebp
f0105599:	8b 45 08             	mov    0x8(%ebp),%eax
f010559c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01055a0:	eb 03                	jmp    f01055a5 <strfind+0xf>
f01055a2:	83 c0 01             	add    $0x1,%eax
f01055a5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f01055a8:	38 ca                	cmp    %cl,%dl
f01055aa:	74 04                	je     f01055b0 <strfind+0x1a>
f01055ac:	84 d2                	test   %dl,%dl
f01055ae:	75 f2                	jne    f01055a2 <strfind+0xc>
			break;
	return (char *) s;
}
f01055b0:	5d                   	pop    %ebp
f01055b1:	c3                   	ret    

f01055b2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01055b2:	55                   	push   %ebp
f01055b3:	89 e5                	mov    %esp,%ebp
f01055b5:	57                   	push   %edi
f01055b6:	56                   	push   %esi
f01055b7:	53                   	push   %ebx
f01055b8:	8b 7d 08             	mov    0x8(%ebp),%edi
f01055bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01055be:	85 c9                	test   %ecx,%ecx
f01055c0:	74 13                	je     f01055d5 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01055c2:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01055c8:	75 05                	jne    f01055cf <memset+0x1d>
f01055ca:	f6 c1 03             	test   $0x3,%cl
f01055cd:	74 0d                	je     f01055dc <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01055cf:	8b 45 0c             	mov    0xc(%ebp),%eax
f01055d2:	fc                   	cld    
f01055d3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01055d5:	89 f8                	mov    %edi,%eax
f01055d7:	5b                   	pop    %ebx
f01055d8:	5e                   	pop    %esi
f01055d9:	5f                   	pop    %edi
f01055da:	5d                   	pop    %ebp
f01055db:	c3                   	ret    
		c &= 0xFF;
f01055dc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01055e0:	89 d3                	mov    %edx,%ebx
f01055e2:	c1 e3 08             	shl    $0x8,%ebx
f01055e5:	89 d0                	mov    %edx,%eax
f01055e7:	c1 e0 18             	shl    $0x18,%eax
f01055ea:	89 d6                	mov    %edx,%esi
f01055ec:	c1 e6 10             	shl    $0x10,%esi
f01055ef:	09 f0                	or     %esi,%eax
f01055f1:	09 c2                	or     %eax,%edx
f01055f3:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
f01055f5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01055f8:	89 d0                	mov    %edx,%eax
f01055fa:	fc                   	cld    
f01055fb:	f3 ab                	rep stos %eax,%es:(%edi)
f01055fd:	eb d6                	jmp    f01055d5 <memset+0x23>

f01055ff <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01055ff:	55                   	push   %ebp
f0105600:	89 e5                	mov    %esp,%ebp
f0105602:	57                   	push   %edi
f0105603:	56                   	push   %esi
f0105604:	8b 45 08             	mov    0x8(%ebp),%eax
f0105607:	8b 75 0c             	mov    0xc(%ebp),%esi
f010560a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f010560d:	39 c6                	cmp    %eax,%esi
f010560f:	73 35                	jae    f0105646 <memmove+0x47>
f0105611:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0105614:	39 c2                	cmp    %eax,%edx
f0105616:	76 2e                	jbe    f0105646 <memmove+0x47>
		s += n;
		d += n;
f0105618:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010561b:	89 d6                	mov    %edx,%esi
f010561d:	09 fe                	or     %edi,%esi
f010561f:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105625:	74 0c                	je     f0105633 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105627:	83 ef 01             	sub    $0x1,%edi
f010562a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f010562d:	fd                   	std    
f010562e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105630:	fc                   	cld    
f0105631:	eb 21                	jmp    f0105654 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105633:	f6 c1 03             	test   $0x3,%cl
f0105636:	75 ef                	jne    f0105627 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105638:	83 ef 04             	sub    $0x4,%edi
f010563b:	8d 72 fc             	lea    -0x4(%edx),%esi
f010563e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105641:	fd                   	std    
f0105642:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105644:	eb ea                	jmp    f0105630 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105646:	89 f2                	mov    %esi,%edx
f0105648:	09 c2                	or     %eax,%edx
f010564a:	f6 c2 03             	test   $0x3,%dl
f010564d:	74 09                	je     f0105658 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f010564f:	89 c7                	mov    %eax,%edi
f0105651:	fc                   	cld    
f0105652:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105654:	5e                   	pop    %esi
f0105655:	5f                   	pop    %edi
f0105656:	5d                   	pop    %ebp
f0105657:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105658:	f6 c1 03             	test   $0x3,%cl
f010565b:	75 f2                	jne    f010564f <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010565d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0105660:	89 c7                	mov    %eax,%edi
f0105662:	fc                   	cld    
f0105663:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105665:	eb ed                	jmp    f0105654 <memmove+0x55>

f0105667 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105667:	55                   	push   %ebp
f0105668:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f010566a:	ff 75 10             	pushl  0x10(%ebp)
f010566d:	ff 75 0c             	pushl  0xc(%ebp)
f0105670:	ff 75 08             	pushl  0x8(%ebp)
f0105673:	e8 87 ff ff ff       	call   f01055ff <memmove>
}
f0105678:	c9                   	leave  
f0105679:	c3                   	ret    

f010567a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f010567a:	55                   	push   %ebp
f010567b:	89 e5                	mov    %esp,%ebp
f010567d:	56                   	push   %esi
f010567e:	53                   	push   %ebx
f010567f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105682:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105685:	89 c6                	mov    %eax,%esi
f0105687:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010568a:	39 f0                	cmp    %esi,%eax
f010568c:	74 1c                	je     f01056aa <memcmp+0x30>
		if (*s1 != *s2)
f010568e:	0f b6 08             	movzbl (%eax),%ecx
f0105691:	0f b6 1a             	movzbl (%edx),%ebx
f0105694:	38 d9                	cmp    %bl,%cl
f0105696:	75 08                	jne    f01056a0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0105698:	83 c0 01             	add    $0x1,%eax
f010569b:	83 c2 01             	add    $0x1,%edx
f010569e:	eb ea                	jmp    f010568a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f01056a0:	0f b6 c1             	movzbl %cl,%eax
f01056a3:	0f b6 db             	movzbl %bl,%ebx
f01056a6:	29 d8                	sub    %ebx,%eax
f01056a8:	eb 05                	jmp    f01056af <memcmp+0x35>
	}

	return 0;
f01056aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01056af:	5b                   	pop    %ebx
f01056b0:	5e                   	pop    %esi
f01056b1:	5d                   	pop    %ebp
f01056b2:	c3                   	ret    

f01056b3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01056b3:	55                   	push   %ebp
f01056b4:	89 e5                	mov    %esp,%ebp
f01056b6:	8b 45 08             	mov    0x8(%ebp),%eax
f01056b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01056bc:	89 c2                	mov    %eax,%edx
f01056be:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01056c1:	39 d0                	cmp    %edx,%eax
f01056c3:	73 09                	jae    f01056ce <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f01056c5:	38 08                	cmp    %cl,(%eax)
f01056c7:	74 05                	je     f01056ce <memfind+0x1b>
	for (; s < ends; s++)
f01056c9:	83 c0 01             	add    $0x1,%eax
f01056cc:	eb f3                	jmp    f01056c1 <memfind+0xe>
			break;
	return (void *) s;
}
f01056ce:	5d                   	pop    %ebp
f01056cf:	c3                   	ret    

f01056d0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01056d0:	55                   	push   %ebp
f01056d1:	89 e5                	mov    %esp,%ebp
f01056d3:	57                   	push   %edi
f01056d4:	56                   	push   %esi
f01056d5:	53                   	push   %ebx
f01056d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01056d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01056dc:	eb 03                	jmp    f01056e1 <strtol+0x11>
		s++;
f01056de:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01056e1:	0f b6 01             	movzbl (%ecx),%eax
f01056e4:	3c 20                	cmp    $0x20,%al
f01056e6:	74 f6                	je     f01056de <strtol+0xe>
f01056e8:	3c 09                	cmp    $0x9,%al
f01056ea:	74 f2                	je     f01056de <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f01056ec:	3c 2b                	cmp    $0x2b,%al
f01056ee:	74 2e                	je     f010571e <strtol+0x4e>
	int neg = 0;
f01056f0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f01056f5:	3c 2d                	cmp    $0x2d,%al
f01056f7:	74 2f                	je     f0105728 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01056f9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01056ff:	75 05                	jne    f0105706 <strtol+0x36>
f0105701:	80 39 30             	cmpb   $0x30,(%ecx)
f0105704:	74 2c                	je     f0105732 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0105706:	85 db                	test   %ebx,%ebx
f0105708:	75 0a                	jne    f0105714 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f010570a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
f010570f:	80 39 30             	cmpb   $0x30,(%ecx)
f0105712:	74 28                	je     f010573c <strtol+0x6c>
		base = 10;
f0105714:	b8 00 00 00 00       	mov    $0x0,%eax
f0105719:	89 5d 10             	mov    %ebx,0x10(%ebp)
f010571c:	eb 50                	jmp    f010576e <strtol+0x9e>
		s++;
f010571e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105721:	bf 00 00 00 00       	mov    $0x0,%edi
f0105726:	eb d1                	jmp    f01056f9 <strtol+0x29>
		s++, neg = 1;
f0105728:	83 c1 01             	add    $0x1,%ecx
f010572b:	bf 01 00 00 00       	mov    $0x1,%edi
f0105730:	eb c7                	jmp    f01056f9 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105732:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0105736:	74 0e                	je     f0105746 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0105738:	85 db                	test   %ebx,%ebx
f010573a:	75 d8                	jne    f0105714 <strtol+0x44>
		s++, base = 8;
f010573c:	83 c1 01             	add    $0x1,%ecx
f010573f:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105744:	eb ce                	jmp    f0105714 <strtol+0x44>
		s += 2, base = 16;
f0105746:	83 c1 02             	add    $0x2,%ecx
f0105749:	bb 10 00 00 00       	mov    $0x10,%ebx
f010574e:	eb c4                	jmp    f0105714 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0105750:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105753:	89 f3                	mov    %esi,%ebx
f0105755:	80 fb 19             	cmp    $0x19,%bl
f0105758:	77 29                	ja     f0105783 <strtol+0xb3>
			dig = *s - 'a' + 10;
f010575a:	0f be d2             	movsbl %dl,%edx
f010575d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105760:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105763:	7d 30                	jge    f0105795 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0105765:	83 c1 01             	add    $0x1,%ecx
f0105768:	0f af 45 10          	imul   0x10(%ebp),%eax
f010576c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f010576e:	0f b6 11             	movzbl (%ecx),%edx
f0105771:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105774:	89 f3                	mov    %esi,%ebx
f0105776:	80 fb 09             	cmp    $0x9,%bl
f0105779:	77 d5                	ja     f0105750 <strtol+0x80>
			dig = *s - '0';
f010577b:	0f be d2             	movsbl %dl,%edx
f010577e:	83 ea 30             	sub    $0x30,%edx
f0105781:	eb dd                	jmp    f0105760 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
f0105783:	8d 72 bf             	lea    -0x41(%edx),%esi
f0105786:	89 f3                	mov    %esi,%ebx
f0105788:	80 fb 19             	cmp    $0x19,%bl
f010578b:	77 08                	ja     f0105795 <strtol+0xc5>
			dig = *s - 'A' + 10;
f010578d:	0f be d2             	movsbl %dl,%edx
f0105790:	83 ea 37             	sub    $0x37,%edx
f0105793:	eb cb                	jmp    f0105760 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105795:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0105799:	74 05                	je     f01057a0 <strtol+0xd0>
		*endptr = (char *) s;
f010579b:	8b 75 0c             	mov    0xc(%ebp),%esi
f010579e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f01057a0:	89 c2                	mov    %eax,%edx
f01057a2:	f7 da                	neg    %edx
f01057a4:	85 ff                	test   %edi,%edi
f01057a6:	0f 45 c2             	cmovne %edx,%eax
}
f01057a9:	5b                   	pop    %ebx
f01057aa:	5e                   	pop    %esi
f01057ab:	5f                   	pop    %edi
f01057ac:	5d                   	pop    %ebp
f01057ad:	c3                   	ret    
f01057ae:	66 90                	xchg   %ax,%ax

f01057b0 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01057b0:	fa                   	cli    

	xorw    %ax, %ax
f01057b1:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01057b3:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01057b5:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01057b7:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01057b9:	0f 01 16             	lgdtl  (%esi)
f01057bc:	74 70                	je     f010582e <mpsearch1+0x3>
	movl    %cr0, %eax
f01057be:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01057c1:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01057c5:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01057c8:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01057ce:	08 00                	or     %al,(%eax)

f01057d0 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01057d0:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01057d4:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01057d6:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01057d8:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01057da:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01057de:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01057e0:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01057e2:	b8 00 f0 11 00       	mov    $0x11f000,%eax
	movl    %eax, %cr3
f01057e7:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f01057ea:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01057ed:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01057f2:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f01057f5:	8b 25 84 3e 21 f0    	mov    0xf0213e84,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f01057fb:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105800:	b8 c7 01 10 f0       	mov    $0xf01001c7,%eax
	call    *%eax
f0105805:	ff d0                	call   *%eax

f0105807 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0105807:	eb fe                	jmp    f0105807 <spin>
f0105809:	8d 76 00             	lea    0x0(%esi),%esi

f010580c <gdt>:
	...
f0105814:	ff                   	(bad)  
f0105815:	ff 00                	incl   (%eax)
f0105817:	00 00                	add    %al,(%eax)
f0105819:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105820:	00                   	.byte 0x0
f0105821:	92                   	xchg   %eax,%edx
f0105822:	cf                   	iret   
	...

f0105824 <gdtdesc>:
f0105824:	17                   	pop    %ss
f0105825:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f010582a <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f010582a:	90                   	nop

f010582b <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f010582b:	55                   	push   %ebp
f010582c:	89 e5                	mov    %esp,%ebp
f010582e:	57                   	push   %edi
f010582f:	56                   	push   %esi
f0105830:	53                   	push   %ebx
f0105831:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0105834:	8b 0d 88 3e 21 f0    	mov    0xf0213e88,%ecx
f010583a:	89 c3                	mov    %eax,%ebx
f010583c:	c1 eb 0c             	shr    $0xc,%ebx
f010583f:	39 cb                	cmp    %ecx,%ebx
f0105841:	73 1a                	jae    f010585d <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0105843:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105849:	8d 34 02             	lea    (%edx,%eax,1),%esi
	if (PGNUM(pa) >= npages)
f010584c:	89 f0                	mov    %esi,%eax
f010584e:	c1 e8 0c             	shr    $0xc,%eax
f0105851:	39 c8                	cmp    %ecx,%eax
f0105853:	73 1a                	jae    f010586f <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0105855:	81 ee 00 00 00 10    	sub    $0x10000000,%esi

	for (; mp < end; mp++)
f010585b:	eb 27                	jmp    f0105884 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010585d:	50                   	push   %eax
f010585e:	68 44 62 10 f0       	push   $0xf0106244
f0105863:	6a 57                	push   $0x57
f0105865:	68 fd 7d 10 f0       	push   $0xf0107dfd
f010586a:	e8 d1 a7 ff ff       	call   f0100040 <_panic>
f010586f:	56                   	push   %esi
f0105870:	68 44 62 10 f0       	push   $0xf0106244
f0105875:	6a 57                	push   $0x57
f0105877:	68 fd 7d 10 f0       	push   $0xf0107dfd
f010587c:	e8 bf a7 ff ff       	call   f0100040 <_panic>
f0105881:	83 c3 10             	add    $0x10,%ebx
f0105884:	39 f3                	cmp    %esi,%ebx
f0105886:	73 2e                	jae    f01058b6 <mpsearch1+0x8b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105888:	83 ec 04             	sub    $0x4,%esp
f010588b:	6a 04                	push   $0x4
f010588d:	68 0d 7e 10 f0       	push   $0xf0107e0d
f0105892:	53                   	push   %ebx
f0105893:	e8 e2 fd ff ff       	call   f010567a <memcmp>
f0105898:	83 c4 10             	add    $0x10,%esp
f010589b:	85 c0                	test   %eax,%eax
f010589d:	75 e2                	jne    f0105881 <mpsearch1+0x56>
f010589f:	89 da                	mov    %ebx,%edx
f01058a1:	8d 7b 10             	lea    0x10(%ebx),%edi
		sum += ((uint8_t *)addr)[i];
f01058a4:	0f b6 0a             	movzbl (%edx),%ecx
f01058a7:	01 c8                	add    %ecx,%eax
f01058a9:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f01058ac:	39 fa                	cmp    %edi,%edx
f01058ae:	75 f4                	jne    f01058a4 <mpsearch1+0x79>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f01058b0:	84 c0                	test   %al,%al
f01058b2:	75 cd                	jne    f0105881 <mpsearch1+0x56>
f01058b4:	eb 05                	jmp    f01058bb <mpsearch1+0x90>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f01058b6:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01058bb:	89 d8                	mov    %ebx,%eax
f01058bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01058c0:	5b                   	pop    %ebx
f01058c1:	5e                   	pop    %esi
f01058c2:	5f                   	pop    %edi
f01058c3:	5d                   	pop    %ebp
f01058c4:	c3                   	ret    

f01058c5 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f01058c5:	55                   	push   %ebp
f01058c6:	89 e5                	mov    %esp,%ebp
f01058c8:	57                   	push   %edi
f01058c9:	56                   	push   %esi
f01058ca:	53                   	push   %ebx
f01058cb:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f01058ce:	c7 05 c0 43 21 f0 20 	movl   $0xf0214020,0xf02143c0
f01058d5:	40 21 f0 
	if (PGNUM(pa) >= npages)
f01058d8:	83 3d 88 3e 21 f0 00 	cmpl   $0x0,0xf0213e88
f01058df:	0f 84 87 00 00 00    	je     f010596c <mp_init+0xa7>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01058e5:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f01058ec:	85 c0                	test   %eax,%eax
f01058ee:	0f 84 8e 00 00 00    	je     f0105982 <mp_init+0xbd>
		p <<= 4;	// Translate from segment to PA
f01058f4:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f01058f7:	ba 00 04 00 00       	mov    $0x400,%edx
f01058fc:	e8 2a ff ff ff       	call   f010582b <mpsearch1>
f0105901:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105904:	85 c0                	test   %eax,%eax
f0105906:	0f 84 9a 00 00 00    	je     f01059a6 <mp_init+0xe1>
	if (mp->physaddr == 0 || mp->type != 0) {
f010590c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010590f:	8b 41 04             	mov    0x4(%ecx),%eax
f0105912:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105915:	85 c0                	test   %eax,%eax
f0105917:	0f 84 a8 00 00 00    	je     f01059c5 <mp_init+0x100>
f010591d:	80 79 0b 00          	cmpb   $0x0,0xb(%ecx)
f0105921:	0f 85 9e 00 00 00    	jne    f01059c5 <mp_init+0x100>
f0105927:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010592a:	c1 e8 0c             	shr    $0xc,%eax
f010592d:	3b 05 88 3e 21 f0    	cmp    0xf0213e88,%eax
f0105933:	0f 83 a1 00 00 00    	jae    f01059da <mp_init+0x115>
	return (void *)(pa + KERNBASE);
f0105939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010593c:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
f0105942:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105944:	83 ec 04             	sub    $0x4,%esp
f0105947:	6a 04                	push   $0x4
f0105949:	68 12 7e 10 f0       	push   $0xf0107e12
f010594e:	53                   	push   %ebx
f010594f:	e8 26 fd ff ff       	call   f010567a <memcmp>
f0105954:	83 c4 10             	add    $0x10,%esp
f0105957:	85 c0                	test   %eax,%eax
f0105959:	0f 85 92 00 00 00    	jne    f01059f1 <mp_init+0x12c>
f010595f:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105963:	01 df                	add    %ebx,%edi
	sum = 0;
f0105965:	89 c2                	mov    %eax,%edx
f0105967:	e9 a2 00 00 00       	jmp    f0105a0e <mp_init+0x149>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010596c:	68 00 04 00 00       	push   $0x400
f0105971:	68 44 62 10 f0       	push   $0xf0106244
f0105976:	6a 6f                	push   $0x6f
f0105978:	68 fd 7d 10 f0       	push   $0xf0107dfd
f010597d:	e8 be a6 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105982:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105989:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f010598c:	2d 00 04 00 00       	sub    $0x400,%eax
f0105991:	ba 00 04 00 00       	mov    $0x400,%edx
f0105996:	e8 90 fe ff ff       	call   f010582b <mpsearch1>
f010599b:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010599e:	85 c0                	test   %eax,%eax
f01059a0:	0f 85 66 ff ff ff    	jne    f010590c <mp_init+0x47>
	return mpsearch1(0xF0000, 0x10000);
f01059a6:	ba 00 00 01 00       	mov    $0x10000,%edx
f01059ab:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f01059b0:	e8 76 fe ff ff       	call   f010582b <mpsearch1>
f01059b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if ((mp = mpsearch()) == 0)
f01059b8:	85 c0                	test   %eax,%eax
f01059ba:	0f 85 4c ff ff ff    	jne    f010590c <mp_init+0x47>
f01059c0:	e9 a8 01 00 00       	jmp    f0105b6d <mp_init+0x2a8>
		cprintf("SMP: Default configurations not implemented\n");
f01059c5:	83 ec 0c             	sub    $0xc,%esp
f01059c8:	68 70 7c 10 f0       	push   $0xf0107c70
f01059cd:	e8 41 df ff ff       	call   f0103913 <cprintf>
f01059d2:	83 c4 10             	add    $0x10,%esp
f01059d5:	e9 93 01 00 00       	jmp    f0105b6d <mp_init+0x2a8>
f01059da:	ff 75 e4             	pushl  -0x1c(%ebp)
f01059dd:	68 44 62 10 f0       	push   $0xf0106244
f01059e2:	68 90 00 00 00       	push   $0x90
f01059e7:	68 fd 7d 10 f0       	push   $0xf0107dfd
f01059ec:	e8 4f a6 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f01059f1:	83 ec 0c             	sub    $0xc,%esp
f01059f4:	68 a0 7c 10 f0       	push   $0xf0107ca0
f01059f9:	e8 15 df ff ff       	call   f0103913 <cprintf>
f01059fe:	83 c4 10             	add    $0x10,%esp
f0105a01:	e9 67 01 00 00       	jmp    f0105b6d <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f0105a06:	0f b6 0b             	movzbl (%ebx),%ecx
f0105a09:	01 ca                	add    %ecx,%edx
f0105a0b:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0105a0e:	39 fb                	cmp    %edi,%ebx
f0105a10:	75 f4                	jne    f0105a06 <mp_init+0x141>
	if (sum(conf, conf->length) != 0) {
f0105a12:	84 d2                	test   %dl,%dl
f0105a14:	75 16                	jne    f0105a2c <mp_init+0x167>
	if (conf->version != 1 && conf->version != 4) {
f0105a16:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0105a1a:	80 fa 01             	cmp    $0x1,%dl
f0105a1d:	74 05                	je     f0105a24 <mp_init+0x15f>
f0105a1f:	80 fa 04             	cmp    $0x4,%dl
f0105a22:	75 1d                	jne    f0105a41 <mp_init+0x17c>
f0105a24:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0105a28:	01 d9                	add    %ebx,%ecx
f0105a2a:	eb 36                	jmp    f0105a62 <mp_init+0x19d>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105a2c:	83 ec 0c             	sub    $0xc,%esp
f0105a2f:	68 d4 7c 10 f0       	push   $0xf0107cd4
f0105a34:	e8 da de ff ff       	call   f0103913 <cprintf>
f0105a39:	83 c4 10             	add    $0x10,%esp
f0105a3c:	e9 2c 01 00 00       	jmp    f0105b6d <mp_init+0x2a8>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105a41:	83 ec 08             	sub    $0x8,%esp
f0105a44:	0f b6 d2             	movzbl %dl,%edx
f0105a47:	52                   	push   %edx
f0105a48:	68 f8 7c 10 f0       	push   $0xf0107cf8
f0105a4d:	e8 c1 de ff ff       	call   f0103913 <cprintf>
f0105a52:	83 c4 10             	add    $0x10,%esp
f0105a55:	e9 13 01 00 00       	jmp    f0105b6d <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f0105a5a:	0f b6 13             	movzbl (%ebx),%edx
f0105a5d:	01 d0                	add    %edx,%eax
f0105a5f:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0105a62:	39 d9                	cmp    %ebx,%ecx
f0105a64:	75 f4                	jne    f0105a5a <mp_init+0x195>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105a66:	02 46 2a             	add    0x2a(%esi),%al
f0105a69:	75 29                	jne    f0105a94 <mp_init+0x1cf>
	if ((conf = mpconfig(&mp)) == 0)
f0105a6b:	81 7d e4 00 00 00 10 	cmpl   $0x10000000,-0x1c(%ebp)
f0105a72:	0f 84 f5 00 00 00    	je     f0105b6d <mp_init+0x2a8>
		return;
	ismp = 1;
f0105a78:	c7 05 00 40 21 f0 01 	movl   $0x1,0xf0214000
f0105a7f:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105a82:	8b 46 24             	mov    0x24(%esi),%eax
f0105a85:	a3 00 50 25 f0       	mov    %eax,0xf0255000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105a8a:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0105a8d:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105a92:	eb 4d                	jmp    f0105ae1 <mp_init+0x21c>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105a94:	83 ec 0c             	sub    $0xc,%esp
f0105a97:	68 18 7d 10 f0       	push   $0xf0107d18
f0105a9c:	e8 72 de ff ff       	call   f0103913 <cprintf>
f0105aa1:	83 c4 10             	add    $0x10,%esp
f0105aa4:	e9 c4 00 00 00       	jmp    f0105b6d <mp_init+0x2a8>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105aa9:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0105aad:	74 11                	je     f0105ac0 <mp_init+0x1fb>
				bootcpu = &cpus[ncpu];
f0105aaf:	6b 05 c4 43 21 f0 74 	imul   $0x74,0xf02143c4,%eax
f0105ab6:	05 20 40 21 f0       	add    $0xf0214020,%eax
f0105abb:	a3 c0 43 21 f0       	mov    %eax,0xf02143c0
			if (ncpu < NCPU) {
f0105ac0:	a1 c4 43 21 f0       	mov    0xf02143c4,%eax
f0105ac5:	83 f8 07             	cmp    $0x7,%eax
f0105ac8:	7f 2f                	jg     f0105af9 <mp_init+0x234>
				cpus[ncpu].cpu_id = ncpu;
f0105aca:	6b d0 74             	imul   $0x74,%eax,%edx
f0105acd:	88 82 20 40 21 f0    	mov    %al,-0xfdebfe0(%edx)
				ncpu++;
f0105ad3:	83 c0 01             	add    $0x1,%eax
f0105ad6:	a3 c4 43 21 f0       	mov    %eax,0xf02143c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105adb:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105ade:	83 c3 01             	add    $0x1,%ebx
f0105ae1:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0105ae5:	39 d8                	cmp    %ebx,%eax
f0105ae7:	76 4b                	jbe    f0105b34 <mp_init+0x26f>
		switch (*p) {
f0105ae9:	0f b6 07             	movzbl (%edi),%eax
f0105aec:	84 c0                	test   %al,%al
f0105aee:	74 b9                	je     f0105aa9 <mp_init+0x1e4>
f0105af0:	3c 04                	cmp    $0x4,%al
f0105af2:	77 1c                	ja     f0105b10 <mp_init+0x24b>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105af4:	83 c7 08             	add    $0x8,%edi
			continue;
f0105af7:	eb e5                	jmp    f0105ade <mp_init+0x219>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105af9:	83 ec 08             	sub    $0x8,%esp
f0105afc:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0105b00:	50                   	push   %eax
f0105b01:	68 48 7d 10 f0       	push   $0xf0107d48
f0105b06:	e8 08 de ff ff       	call   f0103913 <cprintf>
f0105b0b:	83 c4 10             	add    $0x10,%esp
f0105b0e:	eb cb                	jmp    f0105adb <mp_init+0x216>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0105b10:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0105b13:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0105b16:	50                   	push   %eax
f0105b17:	68 70 7d 10 f0       	push   $0xf0107d70
f0105b1c:	e8 f2 dd ff ff       	call   f0103913 <cprintf>
			ismp = 0;
f0105b21:	c7 05 00 40 21 f0 00 	movl   $0x0,0xf0214000
f0105b28:	00 00 00 
			i = conf->entry;
f0105b2b:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0105b2f:	83 c4 10             	add    $0x10,%esp
f0105b32:	eb aa                	jmp    f0105ade <mp_init+0x219>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105b34:	a1 c0 43 21 f0       	mov    0xf02143c0,%eax
f0105b39:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105b40:	83 3d 00 40 21 f0 00 	cmpl   $0x0,0xf0214000
f0105b47:	75 2c                	jne    f0105b75 <mp_init+0x2b0>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f0105b49:	c7 05 c4 43 21 f0 01 	movl   $0x1,0xf02143c4
f0105b50:	00 00 00 
		lapicaddr = 0;
f0105b53:	c7 05 00 50 25 f0 00 	movl   $0x0,0xf0255000
f0105b5a:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0105b5d:	83 ec 0c             	sub    $0xc,%esp
f0105b60:	68 90 7d 10 f0       	push   $0xf0107d90
f0105b65:	e8 a9 dd ff ff       	call   f0103913 <cprintf>
		return;
f0105b6a:	83 c4 10             	add    $0x10,%esp
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0105b6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105b70:	5b                   	pop    %ebx
f0105b71:	5e                   	pop    %esi
f0105b72:	5f                   	pop    %edi
f0105b73:	5d                   	pop    %ebp
f0105b74:	c3                   	ret    
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0105b75:	83 ec 04             	sub    $0x4,%esp
f0105b78:	ff 35 c4 43 21 f0    	pushl  0xf02143c4
f0105b7e:	0f b6 00             	movzbl (%eax),%eax
f0105b81:	50                   	push   %eax
f0105b82:	68 17 7e 10 f0       	push   $0xf0107e17
f0105b87:	e8 87 dd ff ff       	call   f0103913 <cprintf>
	if (mp->imcrp) {
f0105b8c:	83 c4 10             	add    $0x10,%esp
f0105b8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105b92:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0105b96:	74 d5                	je     f0105b6d <mp_init+0x2a8>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0105b98:	83 ec 0c             	sub    $0xc,%esp
f0105b9b:	68 bc 7d 10 f0       	push   $0xf0107dbc
f0105ba0:	e8 6e dd ff ff       	call   f0103913 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105ba5:	b8 70 00 00 00       	mov    $0x70,%eax
f0105baa:	ba 22 00 00 00       	mov    $0x22,%edx
f0105baf:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105bb0:	ba 23 00 00 00       	mov    $0x23,%edx
f0105bb5:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0105bb6:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105bb9:	ee                   	out    %al,(%dx)
f0105bba:	83 c4 10             	add    $0x10,%esp
f0105bbd:	eb ae                	jmp    f0105b6d <mp_init+0x2a8>

f0105bbf <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f0105bbf:	55                   	push   %ebp
f0105bc0:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f0105bc2:	8b 0d 04 50 25 f0    	mov    0xf0255004,%ecx
f0105bc8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0105bcb:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0105bcd:	a1 04 50 25 f0       	mov    0xf0255004,%eax
f0105bd2:	8b 40 20             	mov    0x20(%eax),%eax
}
f0105bd5:	5d                   	pop    %ebp
f0105bd6:	c3                   	ret    

f0105bd7 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0105bd7:	55                   	push   %ebp
f0105bd8:	89 e5                	mov    %esp,%ebp
	if (lapic)
f0105bda:	8b 15 04 50 25 f0    	mov    0xf0255004,%edx
		return lapic[ID] >> 24;
	return 0;
f0105be0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f0105be5:	85 d2                	test   %edx,%edx
f0105be7:	74 06                	je     f0105bef <cpunum+0x18>
		return lapic[ID] >> 24;
f0105be9:	8b 42 20             	mov    0x20(%edx),%eax
f0105bec:	c1 e8 18             	shr    $0x18,%eax
}
f0105bef:	5d                   	pop    %ebp
f0105bf0:	c3                   	ret    

f0105bf1 <lapic_init>:
	if (!lapicaddr)
f0105bf1:	a1 00 50 25 f0       	mov    0xf0255000,%eax
f0105bf6:	85 c0                	test   %eax,%eax
f0105bf8:	75 02                	jne    f0105bfc <lapic_init+0xb>
f0105bfa:	f3 c3                	repz ret 
{
f0105bfc:	55                   	push   %ebp
f0105bfd:	89 e5                	mov    %esp,%ebp
f0105bff:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0105c02:	68 00 10 00 00       	push   $0x1000
f0105c07:	50                   	push   %eax
f0105c08:	e8 86 b6 ff ff       	call   f0101293 <mmio_map_region>
f0105c0d:	a3 04 50 25 f0       	mov    %eax,0xf0255004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0105c12:	ba 27 01 00 00       	mov    $0x127,%edx
f0105c17:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0105c1c:	e8 9e ff ff ff       	call   f0105bbf <lapicw>
	lapicw(TDCR, X1);
f0105c21:	ba 0b 00 00 00       	mov    $0xb,%edx
f0105c26:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0105c2b:	e8 8f ff ff ff       	call   f0105bbf <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0105c30:	ba 20 00 02 00       	mov    $0x20020,%edx
f0105c35:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0105c3a:	e8 80 ff ff ff       	call   f0105bbf <lapicw>
	lapicw(TICR, 10000000); 
f0105c3f:	ba 80 96 98 00       	mov    $0x989680,%edx
f0105c44:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0105c49:	e8 71 ff ff ff       	call   f0105bbf <lapicw>
	if (thiscpu != bootcpu)
f0105c4e:	e8 84 ff ff ff       	call   f0105bd7 <cpunum>
f0105c53:	6b c0 74             	imul   $0x74,%eax,%eax
f0105c56:	05 20 40 21 f0       	add    $0xf0214020,%eax
f0105c5b:	83 c4 10             	add    $0x10,%esp
f0105c5e:	39 05 c0 43 21 f0    	cmp    %eax,0xf02143c0
f0105c64:	74 0f                	je     f0105c75 <lapic_init+0x84>
		lapicw(LINT0, MASKED);
f0105c66:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105c6b:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0105c70:	e8 4a ff ff ff       	call   f0105bbf <lapicw>
	lapicw(LINT1, MASKED);
f0105c75:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105c7a:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0105c7f:	e8 3b ff ff ff       	call   f0105bbf <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0105c84:	a1 04 50 25 f0       	mov    0xf0255004,%eax
f0105c89:	8b 40 30             	mov    0x30(%eax),%eax
f0105c8c:	c1 e8 10             	shr    $0x10,%eax
f0105c8f:	3c 03                	cmp    $0x3,%al
f0105c91:	77 7c                	ja     f0105d0f <lapic_init+0x11e>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0105c93:	ba 33 00 00 00       	mov    $0x33,%edx
f0105c98:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0105c9d:	e8 1d ff ff ff       	call   f0105bbf <lapicw>
	lapicw(ESR, 0);
f0105ca2:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ca7:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105cac:	e8 0e ff ff ff       	call   f0105bbf <lapicw>
	lapicw(ESR, 0);
f0105cb1:	ba 00 00 00 00       	mov    $0x0,%edx
f0105cb6:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105cbb:	e8 ff fe ff ff       	call   f0105bbf <lapicw>
	lapicw(EOI, 0);
f0105cc0:	ba 00 00 00 00       	mov    $0x0,%edx
f0105cc5:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105cca:	e8 f0 fe ff ff       	call   f0105bbf <lapicw>
	lapicw(ICRHI, 0);
f0105ccf:	ba 00 00 00 00       	mov    $0x0,%edx
f0105cd4:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105cd9:	e8 e1 fe ff ff       	call   f0105bbf <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0105cde:	ba 00 85 08 00       	mov    $0x88500,%edx
f0105ce3:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105ce8:	e8 d2 fe ff ff       	call   f0105bbf <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0105ced:	8b 15 04 50 25 f0    	mov    0xf0255004,%edx
f0105cf3:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105cf9:	f6 c4 10             	test   $0x10,%ah
f0105cfc:	75 f5                	jne    f0105cf3 <lapic_init+0x102>
	lapicw(TPR, 0);
f0105cfe:	ba 00 00 00 00       	mov    $0x0,%edx
f0105d03:	b8 20 00 00 00       	mov    $0x20,%eax
f0105d08:	e8 b2 fe ff ff       	call   f0105bbf <lapicw>
}
f0105d0d:	c9                   	leave  
f0105d0e:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0105d0f:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105d14:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0105d19:	e8 a1 fe ff ff       	call   f0105bbf <lapicw>
f0105d1e:	e9 70 ff ff ff       	jmp    f0105c93 <lapic_init+0xa2>

f0105d23 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0105d23:	83 3d 04 50 25 f0 00 	cmpl   $0x0,0xf0255004
f0105d2a:	74 14                	je     f0105d40 <lapic_eoi+0x1d>
{
f0105d2c:	55                   	push   %ebp
f0105d2d:	89 e5                	mov    %esp,%ebp
		lapicw(EOI, 0);
f0105d2f:	ba 00 00 00 00       	mov    $0x0,%edx
f0105d34:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105d39:	e8 81 fe ff ff       	call   f0105bbf <lapicw>
}
f0105d3e:	5d                   	pop    %ebp
f0105d3f:	c3                   	ret    
f0105d40:	f3 c3                	repz ret 

f0105d42 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0105d42:	55                   	push   %ebp
f0105d43:	89 e5                	mov    %esp,%ebp
f0105d45:	56                   	push   %esi
f0105d46:	53                   	push   %ebx
f0105d47:	8b 75 08             	mov    0x8(%ebp),%esi
f0105d4a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105d4d:	b8 0f 00 00 00       	mov    $0xf,%eax
f0105d52:	ba 70 00 00 00       	mov    $0x70,%edx
f0105d57:	ee                   	out    %al,(%dx)
f0105d58:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105d5d:	ba 71 00 00 00       	mov    $0x71,%edx
f0105d62:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0105d63:	83 3d 88 3e 21 f0 00 	cmpl   $0x0,0xf0213e88
f0105d6a:	74 7e                	je     f0105dea <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0105d6c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0105d73:	00 00 
	wrv[1] = addr >> 4;
f0105d75:	89 d8                	mov    %ebx,%eax
f0105d77:	c1 e8 04             	shr    $0x4,%eax
f0105d7a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0105d80:	c1 e6 18             	shl    $0x18,%esi
f0105d83:	89 f2                	mov    %esi,%edx
f0105d85:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105d8a:	e8 30 fe ff ff       	call   f0105bbf <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0105d8f:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0105d94:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105d99:	e8 21 fe ff ff       	call   f0105bbf <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0105d9e:	ba 00 85 00 00       	mov    $0x8500,%edx
f0105da3:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105da8:	e8 12 fe ff ff       	call   f0105bbf <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105dad:	c1 eb 0c             	shr    $0xc,%ebx
f0105db0:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0105db3:	89 f2                	mov    %esi,%edx
f0105db5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105dba:	e8 00 fe ff ff       	call   f0105bbf <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105dbf:	89 da                	mov    %ebx,%edx
f0105dc1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105dc6:	e8 f4 fd ff ff       	call   f0105bbf <lapicw>
		lapicw(ICRHI, apicid << 24);
f0105dcb:	89 f2                	mov    %esi,%edx
f0105dcd:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105dd2:	e8 e8 fd ff ff       	call   f0105bbf <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105dd7:	89 da                	mov    %ebx,%edx
f0105dd9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105dde:	e8 dc fd ff ff       	call   f0105bbf <lapicw>
		microdelay(200);
	}
}
f0105de3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0105de6:	5b                   	pop    %ebx
f0105de7:	5e                   	pop    %esi
f0105de8:	5d                   	pop    %ebp
f0105de9:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105dea:	68 67 04 00 00       	push   $0x467
f0105def:	68 44 62 10 f0       	push   $0xf0106244
f0105df4:	68 98 00 00 00       	push   $0x98
f0105df9:	68 34 7e 10 f0       	push   $0xf0107e34
f0105dfe:	e8 3d a2 ff ff       	call   f0100040 <_panic>

f0105e03 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0105e03:	55                   	push   %ebp
f0105e04:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0105e06:	8b 55 08             	mov    0x8(%ebp),%edx
f0105e09:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0105e0f:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105e14:	e8 a6 fd ff ff       	call   f0105bbf <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0105e19:	8b 15 04 50 25 f0    	mov    0xf0255004,%edx
f0105e1f:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105e25:	f6 c4 10             	test   $0x10,%ah
f0105e28:	75 f5                	jne    f0105e1f <lapic_ipi+0x1c>
		;
}
f0105e2a:	5d                   	pop    %ebp
f0105e2b:	c3                   	ret    

f0105e2c <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0105e2c:	55                   	push   %ebp
f0105e2d:	89 e5                	mov    %esp,%ebp
f0105e2f:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0105e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0105e38:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105e3b:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0105e3e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0105e45:	5d                   	pop    %ebp
f0105e46:	c3                   	ret    

f0105e47 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0105e47:	55                   	push   %ebp
f0105e48:	89 e5                	mov    %esp,%ebp
f0105e4a:	56                   	push   %esi
f0105e4b:	53                   	push   %ebx
f0105e4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0105e4f:	83 3b 00             	cmpl   $0x0,(%ebx)
f0105e52:	75 07                	jne    f0105e5b <spin_lock+0x14>
	asm volatile("lock; xchgl %0, %1"
f0105e54:	ba 01 00 00 00       	mov    $0x1,%edx
f0105e59:	eb 34                	jmp    f0105e8f <spin_lock+0x48>
f0105e5b:	8b 73 08             	mov    0x8(%ebx),%esi
f0105e5e:	e8 74 fd ff ff       	call   f0105bd7 <cpunum>
f0105e63:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e66:	05 20 40 21 f0       	add    $0xf0214020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f0105e6b:	39 c6                	cmp    %eax,%esi
f0105e6d:	75 e5                	jne    f0105e54 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0105e6f:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0105e72:	e8 60 fd ff ff       	call   f0105bd7 <cpunum>
f0105e77:	83 ec 0c             	sub    $0xc,%esp
f0105e7a:	53                   	push   %ebx
f0105e7b:	50                   	push   %eax
f0105e7c:	68 44 7e 10 f0       	push   $0xf0107e44
f0105e81:	6a 41                	push   $0x41
f0105e83:	68 a8 7e 10 f0       	push   $0xf0107ea8
f0105e88:	e8 b3 a1 ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0105e8d:	f3 90                	pause  
f0105e8f:	89 d0                	mov    %edx,%eax
f0105e91:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f0105e94:	85 c0                	test   %eax,%eax
f0105e96:	75 f5                	jne    f0105e8d <spin_lock+0x46>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0105e98:	e8 3a fd ff ff       	call   f0105bd7 <cpunum>
f0105e9d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105ea0:	05 20 40 21 f0       	add    $0xf0214020,%eax
f0105ea5:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f0105ea8:	83 c3 0c             	add    $0xc,%ebx
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0105eab:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0105ead:	b8 00 00 00 00       	mov    $0x0,%eax
f0105eb2:	eb 0b                	jmp    f0105ebf <spin_lock+0x78>
		pcs[i] = ebp[1];          // saved %eip
f0105eb4:	8b 4a 04             	mov    0x4(%edx),%ecx
f0105eb7:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0105eba:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0105ebc:	83 c0 01             	add    $0x1,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0105ebf:	83 f8 09             	cmp    $0x9,%eax
f0105ec2:	7f 14                	jg     f0105ed8 <spin_lock+0x91>
f0105ec4:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0105eca:	77 e8                	ja     f0105eb4 <spin_lock+0x6d>
f0105ecc:	eb 0a                	jmp    f0105ed8 <spin_lock+0x91>
		pcs[i] = 0;
f0105ece:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
	for (; i < 10; i++)
f0105ed5:	83 c0 01             	add    $0x1,%eax
f0105ed8:	83 f8 09             	cmp    $0x9,%eax
f0105edb:	7e f1                	jle    f0105ece <spin_lock+0x87>
#endif
}
f0105edd:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0105ee0:	5b                   	pop    %ebx
f0105ee1:	5e                   	pop    %esi
f0105ee2:	5d                   	pop    %ebp
f0105ee3:	c3                   	ret    

f0105ee4 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0105ee4:	55                   	push   %ebp
f0105ee5:	89 e5                	mov    %esp,%ebp
f0105ee7:	57                   	push   %edi
f0105ee8:	56                   	push   %esi
f0105ee9:	53                   	push   %ebx
f0105eea:	83 ec 4c             	sub    $0x4c,%esp
f0105eed:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0105ef0:	83 3e 00             	cmpl   $0x0,(%esi)
f0105ef3:	75 35                	jne    f0105f2a <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0105ef5:	83 ec 04             	sub    $0x4,%esp
f0105ef8:	6a 28                	push   $0x28
f0105efa:	8d 46 0c             	lea    0xc(%esi),%eax
f0105efd:	50                   	push   %eax
f0105efe:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0105f01:	53                   	push   %ebx
f0105f02:	e8 f8 f6 ff ff       	call   f01055ff <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0105f07:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0105f0a:	0f b6 38             	movzbl (%eax),%edi
f0105f0d:	8b 76 04             	mov    0x4(%esi),%esi
f0105f10:	e8 c2 fc ff ff       	call   f0105bd7 <cpunum>
f0105f15:	57                   	push   %edi
f0105f16:	56                   	push   %esi
f0105f17:	50                   	push   %eax
f0105f18:	68 70 7e 10 f0       	push   $0xf0107e70
f0105f1d:	e8 f1 d9 ff ff       	call   f0103913 <cprintf>
f0105f22:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0105f25:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0105f28:	eb 61                	jmp    f0105f8b <spin_unlock+0xa7>
	return lock->locked && lock->cpu == thiscpu;
f0105f2a:	8b 5e 08             	mov    0x8(%esi),%ebx
f0105f2d:	e8 a5 fc ff ff       	call   f0105bd7 <cpunum>
f0105f32:	6b c0 74             	imul   $0x74,%eax,%eax
f0105f35:	05 20 40 21 f0       	add    $0xf0214020,%eax
	if (!holding(lk)) {
f0105f3a:	39 c3                	cmp    %eax,%ebx
f0105f3c:	75 b7                	jne    f0105ef5 <spin_unlock+0x11>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f0105f3e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0105f45:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0105f4c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f51:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0105f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105f57:	5b                   	pop    %ebx
f0105f58:	5e                   	pop    %esi
f0105f59:	5f                   	pop    %edi
f0105f5a:	5d                   	pop    %ebp
f0105f5b:	c3                   	ret    
					pcs[i] - info.eip_fn_addr);
f0105f5c:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0105f5e:	83 ec 04             	sub    $0x4,%esp
f0105f61:	89 c2                	mov    %eax,%edx
f0105f63:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0105f66:	52                   	push   %edx
f0105f67:	ff 75 b0             	pushl  -0x50(%ebp)
f0105f6a:	ff 75 b4             	pushl  -0x4c(%ebp)
f0105f6d:	ff 75 ac             	pushl  -0x54(%ebp)
f0105f70:	ff 75 a8             	pushl  -0x58(%ebp)
f0105f73:	50                   	push   %eax
f0105f74:	68 b8 7e 10 f0       	push   $0xf0107eb8
f0105f79:	e8 95 d9 ff ff       	call   f0103913 <cprintf>
f0105f7e:	83 c4 20             	add    $0x20,%esp
f0105f81:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0105f84:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0105f87:	39 c3                	cmp    %eax,%ebx
f0105f89:	74 2d                	je     f0105fb8 <spin_unlock+0xd4>
f0105f8b:	89 de                	mov    %ebx,%esi
f0105f8d:	8b 03                	mov    (%ebx),%eax
f0105f8f:	85 c0                	test   %eax,%eax
f0105f91:	74 25                	je     f0105fb8 <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0105f93:	83 ec 08             	sub    $0x8,%esp
f0105f96:	57                   	push   %edi
f0105f97:	50                   	push   %eax
f0105f98:	e8 8e eb ff ff       	call   f0104b2b <debuginfo_eip>
f0105f9d:	83 c4 10             	add    $0x10,%esp
f0105fa0:	85 c0                	test   %eax,%eax
f0105fa2:	79 b8                	jns    f0105f5c <spin_unlock+0x78>
				cprintf("  %08x\n", pcs[i]);
f0105fa4:	83 ec 08             	sub    $0x8,%esp
f0105fa7:	ff 36                	pushl  (%esi)
f0105fa9:	68 cf 7e 10 f0       	push   $0xf0107ecf
f0105fae:	e8 60 d9 ff ff       	call   f0103913 <cprintf>
f0105fb3:	83 c4 10             	add    $0x10,%esp
f0105fb6:	eb c9                	jmp    f0105f81 <spin_unlock+0x9d>
		panic("spin_unlock");
f0105fb8:	83 ec 04             	sub    $0x4,%esp
f0105fbb:	68 d7 7e 10 f0       	push   $0xf0107ed7
f0105fc0:	6a 67                	push   $0x67
f0105fc2:	68 a8 7e 10 f0       	push   $0xf0107ea8
f0105fc7:	e8 74 a0 ff ff       	call   f0100040 <_panic>
f0105fcc:	66 90                	xchg   %ax,%ax
f0105fce:	66 90                	xchg   %ax,%ax

f0105fd0 <__udivdi3>:
f0105fd0:	55                   	push   %ebp
f0105fd1:	57                   	push   %edi
f0105fd2:	56                   	push   %esi
f0105fd3:	53                   	push   %ebx
f0105fd4:	83 ec 1c             	sub    $0x1c,%esp
f0105fd7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f0105fdb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0105fdf:	8b 74 24 34          	mov    0x34(%esp),%esi
f0105fe3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0105fe7:	85 d2                	test   %edx,%edx
f0105fe9:	75 35                	jne    f0106020 <__udivdi3+0x50>
f0105feb:	39 f3                	cmp    %esi,%ebx
f0105fed:	0f 87 bd 00 00 00    	ja     f01060b0 <__udivdi3+0xe0>
f0105ff3:	85 db                	test   %ebx,%ebx
f0105ff5:	89 d9                	mov    %ebx,%ecx
f0105ff7:	75 0b                	jne    f0106004 <__udivdi3+0x34>
f0105ff9:	b8 01 00 00 00       	mov    $0x1,%eax
f0105ffe:	31 d2                	xor    %edx,%edx
f0106000:	f7 f3                	div    %ebx
f0106002:	89 c1                	mov    %eax,%ecx
f0106004:	31 d2                	xor    %edx,%edx
f0106006:	89 f0                	mov    %esi,%eax
f0106008:	f7 f1                	div    %ecx
f010600a:	89 c6                	mov    %eax,%esi
f010600c:	89 e8                	mov    %ebp,%eax
f010600e:	89 f7                	mov    %esi,%edi
f0106010:	f7 f1                	div    %ecx
f0106012:	89 fa                	mov    %edi,%edx
f0106014:	83 c4 1c             	add    $0x1c,%esp
f0106017:	5b                   	pop    %ebx
f0106018:	5e                   	pop    %esi
f0106019:	5f                   	pop    %edi
f010601a:	5d                   	pop    %ebp
f010601b:	c3                   	ret    
f010601c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106020:	39 f2                	cmp    %esi,%edx
f0106022:	77 7c                	ja     f01060a0 <__udivdi3+0xd0>
f0106024:	0f bd fa             	bsr    %edx,%edi
f0106027:	83 f7 1f             	xor    $0x1f,%edi
f010602a:	0f 84 98 00 00 00    	je     f01060c8 <__udivdi3+0xf8>
f0106030:	89 f9                	mov    %edi,%ecx
f0106032:	b8 20 00 00 00       	mov    $0x20,%eax
f0106037:	29 f8                	sub    %edi,%eax
f0106039:	d3 e2                	shl    %cl,%edx
f010603b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010603f:	89 c1                	mov    %eax,%ecx
f0106041:	89 da                	mov    %ebx,%edx
f0106043:	d3 ea                	shr    %cl,%edx
f0106045:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106049:	09 d1                	or     %edx,%ecx
f010604b:	89 f2                	mov    %esi,%edx
f010604d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106051:	89 f9                	mov    %edi,%ecx
f0106053:	d3 e3                	shl    %cl,%ebx
f0106055:	89 c1                	mov    %eax,%ecx
f0106057:	d3 ea                	shr    %cl,%edx
f0106059:	89 f9                	mov    %edi,%ecx
f010605b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010605f:	d3 e6                	shl    %cl,%esi
f0106061:	89 eb                	mov    %ebp,%ebx
f0106063:	89 c1                	mov    %eax,%ecx
f0106065:	d3 eb                	shr    %cl,%ebx
f0106067:	09 de                	or     %ebx,%esi
f0106069:	89 f0                	mov    %esi,%eax
f010606b:	f7 74 24 08          	divl   0x8(%esp)
f010606f:	89 d6                	mov    %edx,%esi
f0106071:	89 c3                	mov    %eax,%ebx
f0106073:	f7 64 24 0c          	mull   0xc(%esp)
f0106077:	39 d6                	cmp    %edx,%esi
f0106079:	72 0c                	jb     f0106087 <__udivdi3+0xb7>
f010607b:	89 f9                	mov    %edi,%ecx
f010607d:	d3 e5                	shl    %cl,%ebp
f010607f:	39 c5                	cmp    %eax,%ebp
f0106081:	73 5d                	jae    f01060e0 <__udivdi3+0x110>
f0106083:	39 d6                	cmp    %edx,%esi
f0106085:	75 59                	jne    f01060e0 <__udivdi3+0x110>
f0106087:	8d 43 ff             	lea    -0x1(%ebx),%eax
f010608a:	31 ff                	xor    %edi,%edi
f010608c:	89 fa                	mov    %edi,%edx
f010608e:	83 c4 1c             	add    $0x1c,%esp
f0106091:	5b                   	pop    %ebx
f0106092:	5e                   	pop    %esi
f0106093:	5f                   	pop    %edi
f0106094:	5d                   	pop    %ebp
f0106095:	c3                   	ret    
f0106096:	8d 76 00             	lea    0x0(%esi),%esi
f0106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f01060a0:	31 ff                	xor    %edi,%edi
f01060a2:	31 c0                	xor    %eax,%eax
f01060a4:	89 fa                	mov    %edi,%edx
f01060a6:	83 c4 1c             	add    $0x1c,%esp
f01060a9:	5b                   	pop    %ebx
f01060aa:	5e                   	pop    %esi
f01060ab:	5f                   	pop    %edi
f01060ac:	5d                   	pop    %ebp
f01060ad:	c3                   	ret    
f01060ae:	66 90                	xchg   %ax,%ax
f01060b0:	31 ff                	xor    %edi,%edi
f01060b2:	89 e8                	mov    %ebp,%eax
f01060b4:	89 f2                	mov    %esi,%edx
f01060b6:	f7 f3                	div    %ebx
f01060b8:	89 fa                	mov    %edi,%edx
f01060ba:	83 c4 1c             	add    $0x1c,%esp
f01060bd:	5b                   	pop    %ebx
f01060be:	5e                   	pop    %esi
f01060bf:	5f                   	pop    %edi
f01060c0:	5d                   	pop    %ebp
f01060c1:	c3                   	ret    
f01060c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01060c8:	39 f2                	cmp    %esi,%edx
f01060ca:	72 06                	jb     f01060d2 <__udivdi3+0x102>
f01060cc:	31 c0                	xor    %eax,%eax
f01060ce:	39 eb                	cmp    %ebp,%ebx
f01060d0:	77 d2                	ja     f01060a4 <__udivdi3+0xd4>
f01060d2:	b8 01 00 00 00       	mov    $0x1,%eax
f01060d7:	eb cb                	jmp    f01060a4 <__udivdi3+0xd4>
f01060d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01060e0:	89 d8                	mov    %ebx,%eax
f01060e2:	31 ff                	xor    %edi,%edi
f01060e4:	eb be                	jmp    f01060a4 <__udivdi3+0xd4>
f01060e6:	66 90                	xchg   %ax,%ax
f01060e8:	66 90                	xchg   %ax,%ax
f01060ea:	66 90                	xchg   %ax,%ax
f01060ec:	66 90                	xchg   %ax,%ax
f01060ee:	66 90                	xchg   %ax,%ax

f01060f0 <__umoddi3>:
f01060f0:	55                   	push   %ebp
f01060f1:	57                   	push   %edi
f01060f2:	56                   	push   %esi
f01060f3:	53                   	push   %ebx
f01060f4:	83 ec 1c             	sub    $0x1c,%esp
f01060f7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
f01060fb:	8b 74 24 30          	mov    0x30(%esp),%esi
f01060ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0106103:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0106107:	85 ed                	test   %ebp,%ebp
f0106109:	89 f0                	mov    %esi,%eax
f010610b:	89 da                	mov    %ebx,%edx
f010610d:	75 19                	jne    f0106128 <__umoddi3+0x38>
f010610f:	39 df                	cmp    %ebx,%edi
f0106111:	0f 86 b1 00 00 00    	jbe    f01061c8 <__umoddi3+0xd8>
f0106117:	f7 f7                	div    %edi
f0106119:	89 d0                	mov    %edx,%eax
f010611b:	31 d2                	xor    %edx,%edx
f010611d:	83 c4 1c             	add    $0x1c,%esp
f0106120:	5b                   	pop    %ebx
f0106121:	5e                   	pop    %esi
f0106122:	5f                   	pop    %edi
f0106123:	5d                   	pop    %ebp
f0106124:	c3                   	ret    
f0106125:	8d 76 00             	lea    0x0(%esi),%esi
f0106128:	39 dd                	cmp    %ebx,%ebp
f010612a:	77 f1                	ja     f010611d <__umoddi3+0x2d>
f010612c:	0f bd cd             	bsr    %ebp,%ecx
f010612f:	83 f1 1f             	xor    $0x1f,%ecx
f0106132:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106136:	0f 84 b4 00 00 00    	je     f01061f0 <__umoddi3+0x100>
f010613c:	b8 20 00 00 00       	mov    $0x20,%eax
f0106141:	89 c2                	mov    %eax,%edx
f0106143:	8b 44 24 04          	mov    0x4(%esp),%eax
f0106147:	29 c2                	sub    %eax,%edx
f0106149:	89 c1                	mov    %eax,%ecx
f010614b:	89 f8                	mov    %edi,%eax
f010614d:	d3 e5                	shl    %cl,%ebp
f010614f:	89 d1                	mov    %edx,%ecx
f0106151:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106155:	d3 e8                	shr    %cl,%eax
f0106157:	09 c5                	or     %eax,%ebp
f0106159:	8b 44 24 04          	mov    0x4(%esp),%eax
f010615d:	89 c1                	mov    %eax,%ecx
f010615f:	d3 e7                	shl    %cl,%edi
f0106161:	89 d1                	mov    %edx,%ecx
f0106163:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0106167:	89 df                	mov    %ebx,%edi
f0106169:	d3 ef                	shr    %cl,%edi
f010616b:	89 c1                	mov    %eax,%ecx
f010616d:	89 f0                	mov    %esi,%eax
f010616f:	d3 e3                	shl    %cl,%ebx
f0106171:	89 d1                	mov    %edx,%ecx
f0106173:	89 fa                	mov    %edi,%edx
f0106175:	d3 e8                	shr    %cl,%eax
f0106177:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f010617c:	09 d8                	or     %ebx,%eax
f010617e:	f7 f5                	div    %ebp
f0106180:	d3 e6                	shl    %cl,%esi
f0106182:	89 d1                	mov    %edx,%ecx
f0106184:	f7 64 24 08          	mull   0x8(%esp)
f0106188:	39 d1                	cmp    %edx,%ecx
f010618a:	89 c3                	mov    %eax,%ebx
f010618c:	89 d7                	mov    %edx,%edi
f010618e:	72 06                	jb     f0106196 <__umoddi3+0xa6>
f0106190:	75 0e                	jne    f01061a0 <__umoddi3+0xb0>
f0106192:	39 c6                	cmp    %eax,%esi
f0106194:	73 0a                	jae    f01061a0 <__umoddi3+0xb0>
f0106196:	2b 44 24 08          	sub    0x8(%esp),%eax
f010619a:	19 ea                	sbb    %ebp,%edx
f010619c:	89 d7                	mov    %edx,%edi
f010619e:	89 c3                	mov    %eax,%ebx
f01061a0:	89 ca                	mov    %ecx,%edx
f01061a2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f01061a7:	29 de                	sub    %ebx,%esi
f01061a9:	19 fa                	sbb    %edi,%edx
f01061ab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
f01061af:	89 d0                	mov    %edx,%eax
f01061b1:	d3 e0                	shl    %cl,%eax
f01061b3:	89 d9                	mov    %ebx,%ecx
f01061b5:	d3 ee                	shr    %cl,%esi
f01061b7:	d3 ea                	shr    %cl,%edx
f01061b9:	09 f0                	or     %esi,%eax
f01061bb:	83 c4 1c             	add    $0x1c,%esp
f01061be:	5b                   	pop    %ebx
f01061bf:	5e                   	pop    %esi
f01061c0:	5f                   	pop    %edi
f01061c1:	5d                   	pop    %ebp
f01061c2:	c3                   	ret    
f01061c3:	90                   	nop
f01061c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01061c8:	85 ff                	test   %edi,%edi
f01061ca:	89 f9                	mov    %edi,%ecx
f01061cc:	75 0b                	jne    f01061d9 <__umoddi3+0xe9>
f01061ce:	b8 01 00 00 00       	mov    $0x1,%eax
f01061d3:	31 d2                	xor    %edx,%edx
f01061d5:	f7 f7                	div    %edi
f01061d7:	89 c1                	mov    %eax,%ecx
f01061d9:	89 d8                	mov    %ebx,%eax
f01061db:	31 d2                	xor    %edx,%edx
f01061dd:	f7 f1                	div    %ecx
f01061df:	89 f0                	mov    %esi,%eax
f01061e1:	f7 f1                	div    %ecx
f01061e3:	e9 31 ff ff ff       	jmp    f0106119 <__umoddi3+0x29>
f01061e8:	90                   	nop
f01061e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01061f0:	39 dd                	cmp    %ebx,%ebp
f01061f2:	72 08                	jb     f01061fc <__umoddi3+0x10c>
f01061f4:	39 f7                	cmp    %esi,%edi
f01061f6:	0f 87 21 ff ff ff    	ja     f010611d <__umoddi3+0x2d>
f01061fc:	89 da                	mov    %ebx,%edx
f01061fe:	89 f0                	mov    %esi,%eax
f0106200:	29 f8                	sub    %edi,%eax
f0106202:	19 ea                	sbb    %ebp,%edx
f0106204:	e9 14 ff ff ff       	jmp    f010611d <__umoddi3+0x2d>
