
obj/user/dumbfork.debug：     文件格式 elf32-i386


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
  80002c:	e8 a3 01 00 00       	call   8001d4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 07                	push   $0x7
  800043:	53                   	push   %ebx
  800044:	56                   	push   %esi
  800045:	e8 a8 0c 00 00       	call   800cf2 <sys_page_alloc>
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	78 4a                	js     80009b <duppage+0x68>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 40 00       	push   $0x400000
  80005b:	6a 00                	push   $0x0
  80005d:	53                   	push   %ebx
  80005e:	56                   	push   %esi
  80005f:	e8 d1 0c 00 00       	call   800d35 <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 09 0a 00 00       	call   800a87 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 ea 0c 00 00       	call   800d77 <sys_page_unmap>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	78 2b                	js     8000bf <duppage+0x8c>
		panic("sys_page_unmap: %e", r);
}
  800094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800097:	5b                   	pop    %ebx
  800098:	5e                   	pop    %esi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80009b:	50                   	push   %eax
  80009c:	68 80 1e 80 00       	push   $0x801e80
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 93 1e 80 00       	push   $0x801e93
  8000a8:	e8 87 01 00 00       	call   800234 <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 a3 1e 80 00       	push   $0x801ea3
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 93 1e 80 00       	push   $0x801e93
  8000ba:	e8 75 01 00 00       	call   800234 <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 b4 1e 80 00       	push   $0x801eb4
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 93 1e 80 00       	push   $0x801e93
  8000cc:	e8 63 01 00 00       	call   800234 <_panic>

008000d1 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8000de:	cd 30                	int    $0x30
  8000e0:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	78 0f                	js     8000f5 <dumbfork+0x24>
  8000e6:	89 c6                	mov    %eax,%esi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	74 1b                	je     800107 <dumbfork+0x36>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8000ec:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8000f3:	eb 3f                	jmp    800134 <dumbfork+0x63>
		panic("sys_exofork: %e", envid);
  8000f5:	50                   	push   %eax
  8000f6:	68 c7 1e 80 00       	push   $0x801ec7
  8000fb:	6a 37                	push   $0x37
  8000fd:	68 93 1e 80 00       	push   $0x801e93
  800102:	e8 2d 01 00 00       	call   800234 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  800107:	e8 a8 0b 00 00       	call   800cb4 <sys_getenvid>
  80010c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800111:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800114:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800119:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80011e:	eb 43                	jmp    800163 <dumbfork+0x92>
		duppage(envid, addr);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	52                   	push   %edx
  800124:	56                   	push   %esi
  800125:	e8 09 ff ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80012a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800137:	81 fa 00 60 80 00    	cmp    $0x806000,%edx
  80013d:	72 e1                	jb     800120 <dumbfork+0x4f>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  80013f:	83 ec 08             	sub    $0x8,%esp
  800142:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800145:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80014a:	50                   	push   %eax
  80014b:	53                   	push   %ebx
  80014c:	e8 e2 fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800151:	83 c4 08             	add    $0x8,%esp
  800154:	6a 02                	push   $0x2
  800156:	53                   	push   %ebx
  800157:	e8 5d 0c 00 00       	call   800db9 <sys_env_set_status>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	85 c0                	test   %eax,%eax
  800161:	78 09                	js     80016c <dumbfork+0x9b>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800163:	89 d8                	mov    %ebx,%eax
  800165:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800168:	5b                   	pop    %ebx
  800169:	5e                   	pop    %esi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  80016c:	50                   	push   %eax
  80016d:	68 d7 1e 80 00       	push   $0x801ed7
  800172:	6a 4c                	push   $0x4c
  800174:	68 93 1e 80 00       	push   $0x801e93
  800179:	e8 b6 00 00 00       	call   800234 <_panic>

0080017e <umain>:
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	57                   	push   %edi
  800182:	56                   	push   %esi
  800183:	53                   	push   %ebx
  800184:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  800187:	e8 45 ff ff ff       	call   8000d1 <dumbfork>
  80018c:	89 c7                	mov    %eax,%edi
  80018e:	85 c0                	test   %eax,%eax
  800190:	be ee 1e 80 00       	mov    $0x801eee,%esi
  800195:	b8 f5 1e 80 00       	mov    $0x801ef5,%eax
  80019a:	0f 44 f0             	cmove  %eax,%esi
	for (i = 0; i < (who ? 10 : 20); i++) {
  80019d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a2:	eb 1f                	jmp    8001c3 <umain+0x45>
  8001a4:	83 fb 13             	cmp    $0x13,%ebx
  8001a7:	7f 23                	jg     8001cc <umain+0x4e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	56                   	push   %esi
  8001ad:	53                   	push   %ebx
  8001ae:	68 fb 1e 80 00       	push   $0x801efb
  8001b3:	e8 57 01 00 00       	call   80030f <cprintf>
		sys_yield();
  8001b8:	e8 16 0b 00 00       	call   800cd3 <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001bd:	83 c3 01             	add    $0x1,%ebx
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	85 ff                	test   %edi,%edi
  8001c5:	74 dd                	je     8001a4 <umain+0x26>
  8001c7:	83 fb 09             	cmp    $0x9,%ebx
  8001ca:	7e dd                	jle    8001a9 <umain+0x2b>
}
  8001cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cf:	5b                   	pop    %ebx
  8001d0:	5e                   	pop    %esi
  8001d1:	5f                   	pop    %edi
  8001d2:	5d                   	pop    %ebp
  8001d3:	c3                   	ret    

008001d4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001dc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001df:	e8 d0 0a 00 00       	call   800cb4 <sys_getenvid>
  8001e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ec:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f1:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f6:	85 db                	test   %ebx,%ebx
  8001f8:	7e 07                	jle    800201 <libmain+0x2d>
		binaryname = argv[0];
  8001fa:	8b 06                	mov    (%esi),%eax
  8001fc:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	56                   	push   %esi
  800205:	53                   	push   %ebx
  800206:	e8 73 ff ff ff       	call   80017e <umain>

	// exit gracefully
	exit();
  80020b:	e8 0a 00 00 00       	call   80021a <exit>
}
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800216:	5b                   	pop    %ebx
  800217:	5e                   	pop    %esi
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    

0080021a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800220:	e8 94 0e 00 00       	call   8010b9 <close_all>
	sys_env_destroy(0);
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	6a 00                	push   $0x0
  80022a:	e8 44 0a 00 00       	call   800c73 <sys_env_destroy>
}
  80022f:	83 c4 10             	add    $0x10,%esp
  800232:	c9                   	leave  
  800233:	c3                   	ret    

00800234 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	56                   	push   %esi
  800238:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800239:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80023c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800242:	e8 6d 0a 00 00       	call   800cb4 <sys_getenvid>
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 0c             	pushl  0xc(%ebp)
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	56                   	push   %esi
  800251:	50                   	push   %eax
  800252:	68 18 1f 80 00       	push   $0x801f18
  800257:	e8 b3 00 00 00       	call   80030f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025c:	83 c4 18             	add    $0x18,%esp
  80025f:	53                   	push   %ebx
  800260:	ff 75 10             	pushl  0x10(%ebp)
  800263:	e8 56 00 00 00       	call   8002be <vcprintf>
	cprintf("\n");
  800268:	c7 04 24 0b 1f 80 00 	movl   $0x801f0b,(%esp)
  80026f:	e8 9b 00 00 00       	call   80030f <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800277:	cc                   	int3   
  800278:	eb fd                	jmp    800277 <_panic+0x43>

0080027a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	53                   	push   %ebx
  80027e:	83 ec 04             	sub    $0x4,%esp
  800281:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800284:	8b 13                	mov    (%ebx),%edx
  800286:	8d 42 01             	lea    0x1(%edx),%eax
  800289:	89 03                	mov    %eax,(%ebx)
  80028b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800292:	3d ff 00 00 00       	cmp    $0xff,%eax
  800297:	74 09                	je     8002a2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800299:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80029d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	68 ff 00 00 00       	push   $0xff
  8002aa:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ad:	50                   	push   %eax
  8002ae:	e8 83 09 00 00       	call   800c36 <sys_cputs>
		b->idx = 0;
  8002b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	eb db                	jmp    800299 <putch+0x1f>

008002be <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ce:	00 00 00 
	b.cnt = 0;
  8002d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002db:	ff 75 0c             	pushl  0xc(%ebp)
  8002de:	ff 75 08             	pushl  0x8(%ebp)
  8002e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e7:	50                   	push   %eax
  8002e8:	68 7a 02 80 00       	push   $0x80027a
  8002ed:	e8 1a 01 00 00       	call   80040c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f2:	83 c4 08             	add    $0x8,%esp
  8002f5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800301:	50                   	push   %eax
  800302:	e8 2f 09 00 00       	call   800c36 <sys_cputs>

	return b.cnt;
}
  800307:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800315:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800318:	50                   	push   %eax
  800319:	ff 75 08             	pushl  0x8(%ebp)
  80031c:	e8 9d ff ff ff       	call   8002be <vcprintf>
	va_end(ap);

	return cnt;
}
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	57                   	push   %edi
  800327:	56                   	push   %esi
  800328:	53                   	push   %ebx
  800329:	83 ec 1c             	sub    $0x1c,%esp
  80032c:	89 c7                	mov    %eax,%edi
  80032e:	89 d6                	mov    %edx,%esi
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	8b 55 0c             	mov    0xc(%ebp),%edx
  800336:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800339:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80033f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800344:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800347:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80034a:	39 d3                	cmp    %edx,%ebx
  80034c:	72 05                	jb     800353 <printnum+0x30>
  80034e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800351:	77 7a                	ja     8003cd <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 18             	pushl  0x18(%ebp)
  800359:	8b 45 14             	mov    0x14(%ebp),%eax
  80035c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80035f:	53                   	push   %ebx
  800360:	ff 75 10             	pushl  0x10(%ebp)
  800363:	83 ec 08             	sub    $0x8,%esp
  800366:	ff 75 e4             	pushl  -0x1c(%ebp)
  800369:	ff 75 e0             	pushl  -0x20(%ebp)
  80036c:	ff 75 dc             	pushl  -0x24(%ebp)
  80036f:	ff 75 d8             	pushl  -0x28(%ebp)
  800372:	e8 c9 18 00 00       	call   801c40 <__udivdi3>
  800377:	83 c4 18             	add    $0x18,%esp
  80037a:	52                   	push   %edx
  80037b:	50                   	push   %eax
  80037c:	89 f2                	mov    %esi,%edx
  80037e:	89 f8                	mov    %edi,%eax
  800380:	e8 9e ff ff ff       	call   800323 <printnum>
  800385:	83 c4 20             	add    $0x20,%esp
  800388:	eb 13                	jmp    80039d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	56                   	push   %esi
  80038e:	ff 75 18             	pushl  0x18(%ebp)
  800391:	ff d7                	call   *%edi
  800393:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800396:	83 eb 01             	sub    $0x1,%ebx
  800399:	85 db                	test   %ebx,%ebx
  80039b:	7f ed                	jg     80038a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	56                   	push   %esi
  8003a1:	83 ec 04             	sub    $0x4,%esp
  8003a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b0:	e8 ab 19 00 00       	call   801d60 <__umoddi3>
  8003b5:	83 c4 14             	add    $0x14,%esp
  8003b8:	0f be 80 3b 1f 80 00 	movsbl 0x801f3b(%eax),%eax
  8003bf:	50                   	push   %eax
  8003c0:	ff d7                	call   *%edi
}
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c8:	5b                   	pop    %ebx
  8003c9:	5e                   	pop    %esi
  8003ca:	5f                   	pop    %edi
  8003cb:	5d                   	pop    %ebp
  8003cc:	c3                   	ret    
  8003cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003d0:	eb c4                	jmp    800396 <printnum+0x73>

008003d2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003d2:	55                   	push   %ebp
  8003d3:	89 e5                	mov    %esp,%ebp
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003dc:	8b 10                	mov    (%eax),%edx
  8003de:	3b 50 04             	cmp    0x4(%eax),%edx
  8003e1:	73 0a                	jae    8003ed <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e6:	89 08                	mov    %ecx,(%eax)
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	88 02                	mov    %al,(%edx)
}
  8003ed:	5d                   	pop    %ebp
  8003ee:	c3                   	ret    

008003ef <printfmt>:
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 10             	pushl  0x10(%ebp)
  8003fc:	ff 75 0c             	pushl  0xc(%ebp)
  8003ff:	ff 75 08             	pushl  0x8(%ebp)
  800402:	e8 05 00 00 00       	call   80040c <vprintfmt>
}
  800407:	83 c4 10             	add    $0x10,%esp
  80040a:	c9                   	leave  
  80040b:	c3                   	ret    

0080040c <vprintfmt>:
{
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
  80040f:	57                   	push   %edi
  800410:	56                   	push   %esi
  800411:	53                   	push   %ebx
  800412:	83 ec 2c             	sub    $0x2c,%esp
  800415:	8b 75 08             	mov    0x8(%ebp),%esi
  800418:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80041b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80041e:	e9 8c 03 00 00       	jmp    8007af <vprintfmt+0x3a3>
		padc = ' ';
  800423:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800427:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80042e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800435:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80043c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800441:	8d 47 01             	lea    0x1(%edi),%eax
  800444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800447:	0f b6 17             	movzbl (%edi),%edx
  80044a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80044d:	3c 55                	cmp    $0x55,%al
  80044f:	0f 87 dd 03 00 00    	ja     800832 <vprintfmt+0x426>
  800455:	0f b6 c0             	movzbl %al,%eax
  800458:	ff 24 85 80 20 80 00 	jmp    *0x802080(,%eax,4)
  80045f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800462:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800466:	eb d9                	jmp    800441 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800468:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80046b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80046f:	eb d0                	jmp    800441 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800471:	0f b6 d2             	movzbl %dl,%edx
  800474:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800477:	b8 00 00 00 00       	mov    $0x0,%eax
  80047c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80047f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800482:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800486:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800489:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80048c:	83 f9 09             	cmp    $0x9,%ecx
  80048f:	77 55                	ja     8004e6 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800491:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800494:	eb e9                	jmp    80047f <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800496:	8b 45 14             	mov    0x14(%ebp),%eax
  800499:	8b 00                	mov    (%eax),%eax
  80049b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80049e:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a1:	8d 40 04             	lea    0x4(%eax),%eax
  8004a4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ae:	79 91                	jns    800441 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004bd:	eb 82                	jmp    800441 <vprintfmt+0x35>
  8004bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c2:	85 c0                	test   %eax,%eax
  8004c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c9:	0f 49 d0             	cmovns %eax,%edx
  8004cc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d2:	e9 6a ff ff ff       	jmp    800441 <vprintfmt+0x35>
  8004d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004da:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004e1:	e9 5b ff ff ff       	jmp    800441 <vprintfmt+0x35>
  8004e6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ec:	eb bc                	jmp    8004aa <vprintfmt+0x9e>
			lflag++;
  8004ee:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f4:	e9 48 ff ff ff       	jmp    800441 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8d 78 04             	lea    0x4(%eax),%edi
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	53                   	push   %ebx
  800503:	ff 30                	pushl  (%eax)
  800505:	ff d6                	call   *%esi
			break;
  800507:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80050a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80050d:	e9 9a 02 00 00       	jmp    8007ac <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8d 78 04             	lea    0x4(%eax),%edi
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	99                   	cltd   
  80051b:	31 d0                	xor    %edx,%eax
  80051d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051f:	83 f8 0f             	cmp    $0xf,%eax
  800522:	7f 23                	jg     800547 <vprintfmt+0x13b>
  800524:	8b 14 85 e0 21 80 00 	mov    0x8021e0(,%eax,4),%edx
  80052b:	85 d2                	test   %edx,%edx
  80052d:	74 18                	je     800547 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80052f:	52                   	push   %edx
  800530:	68 15 23 80 00       	push   $0x802315
  800535:	53                   	push   %ebx
  800536:	56                   	push   %esi
  800537:	e8 b3 fe ff ff       	call   8003ef <printfmt>
  80053c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800542:	e9 65 02 00 00       	jmp    8007ac <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  800547:	50                   	push   %eax
  800548:	68 53 1f 80 00       	push   $0x801f53
  80054d:	53                   	push   %ebx
  80054e:	56                   	push   %esi
  80054f:	e8 9b fe ff ff       	call   8003ef <printfmt>
  800554:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800557:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80055a:	e9 4d 02 00 00       	jmp    8007ac <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	83 c0 04             	add    $0x4,%eax
  800565:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80056d:	85 ff                	test   %edi,%edi
  80056f:	b8 4c 1f 80 00       	mov    $0x801f4c,%eax
  800574:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800577:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057b:	0f 8e bd 00 00 00    	jle    80063e <vprintfmt+0x232>
  800581:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800585:	75 0e                	jne    800595 <vprintfmt+0x189>
  800587:	89 75 08             	mov    %esi,0x8(%ebp)
  80058a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80058d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800590:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800593:	eb 6d                	jmp    800602 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	ff 75 d0             	pushl  -0x30(%ebp)
  80059b:	57                   	push   %edi
  80059c:	e8 39 03 00 00       	call   8008da <strnlen>
  8005a1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a4:	29 c1                	sub    %eax,%ecx
  8005a6:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005a9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005ac:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005b6:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b8:	eb 0f                	jmp    8005c9 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005ba:	83 ec 08             	sub    $0x8,%esp
  8005bd:	53                   	push   %ebx
  8005be:	ff 75 e0             	pushl  -0x20(%ebp)
  8005c1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	83 ef 01             	sub    $0x1,%edi
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	85 ff                	test   %edi,%edi
  8005cb:	7f ed                	jg     8005ba <vprintfmt+0x1ae>
  8005cd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005d0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005d3:	85 c9                	test   %ecx,%ecx
  8005d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005da:	0f 49 c1             	cmovns %ecx,%eax
  8005dd:	29 c1                	sub    %eax,%ecx
  8005df:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005e5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005e8:	89 cb                	mov    %ecx,%ebx
  8005ea:	eb 16                	jmp    800602 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f0:	75 31                	jne    800623 <vprintfmt+0x217>
					putch(ch, putdat);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	50                   	push   %eax
  8005f9:	ff 55 08             	call   *0x8(%ebp)
  8005fc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ff:	83 eb 01             	sub    $0x1,%ebx
  800602:	83 c7 01             	add    $0x1,%edi
  800605:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800609:	0f be c2             	movsbl %dl,%eax
  80060c:	85 c0                	test   %eax,%eax
  80060e:	74 59                	je     800669 <vprintfmt+0x25d>
  800610:	85 f6                	test   %esi,%esi
  800612:	78 d8                	js     8005ec <vprintfmt+0x1e0>
  800614:	83 ee 01             	sub    $0x1,%esi
  800617:	79 d3                	jns    8005ec <vprintfmt+0x1e0>
  800619:	89 df                	mov    %ebx,%edi
  80061b:	8b 75 08             	mov    0x8(%ebp),%esi
  80061e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800621:	eb 37                	jmp    80065a <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800623:	0f be d2             	movsbl %dl,%edx
  800626:	83 ea 20             	sub    $0x20,%edx
  800629:	83 fa 5e             	cmp    $0x5e,%edx
  80062c:	76 c4                	jbe    8005f2 <vprintfmt+0x1e6>
					putch('?', putdat);
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	ff 75 0c             	pushl  0xc(%ebp)
  800634:	6a 3f                	push   $0x3f
  800636:	ff 55 08             	call   *0x8(%ebp)
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	eb c1                	jmp    8005ff <vprintfmt+0x1f3>
  80063e:	89 75 08             	mov    %esi,0x8(%ebp)
  800641:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800644:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800647:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80064a:	eb b6                	jmp    800602 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80064c:	83 ec 08             	sub    $0x8,%esp
  80064f:	53                   	push   %ebx
  800650:	6a 20                	push   $0x20
  800652:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800654:	83 ef 01             	sub    $0x1,%edi
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	85 ff                	test   %edi,%edi
  80065c:	7f ee                	jg     80064c <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80065e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
  800664:	e9 43 01 00 00       	jmp    8007ac <vprintfmt+0x3a0>
  800669:	89 df                	mov    %ebx,%edi
  80066b:	8b 75 08             	mov    0x8(%ebp),%esi
  80066e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800671:	eb e7                	jmp    80065a <vprintfmt+0x24e>
	if (lflag >= 2)
  800673:	83 f9 01             	cmp    $0x1,%ecx
  800676:	7e 3f                	jle    8006b7 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8b 50 04             	mov    0x4(%eax),%edx
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800683:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8d 40 08             	lea    0x8(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80068f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800693:	79 5c                	jns    8006f1 <vprintfmt+0x2e5>
				putch('-', putdat);
  800695:	83 ec 08             	sub    $0x8,%esp
  800698:	53                   	push   %ebx
  800699:	6a 2d                	push   $0x2d
  80069b:	ff d6                	call   *%esi
				num = -(long long) num;
  80069d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006a3:	f7 da                	neg    %edx
  8006a5:	83 d1 00             	adc    $0x0,%ecx
  8006a8:	f7 d9                	neg    %ecx
  8006aa:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b2:	e9 db 00 00 00       	jmp    800792 <vprintfmt+0x386>
	else if (lflag)
  8006b7:	85 c9                	test   %ecx,%ecx
  8006b9:	75 1b                	jne    8006d6 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c3:	89 c1                	mov    %eax,%ecx
  8006c5:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8d 40 04             	lea    0x4(%eax),%eax
  8006d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d4:	eb b9                	jmp    80068f <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006de:	89 c1                	mov    %eax,%ecx
  8006e0:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8d 40 04             	lea    0x4(%eax),%eax
  8006ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ef:	eb 9e                	jmp    80068f <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006f4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fc:	e9 91 00 00 00       	jmp    800792 <vprintfmt+0x386>
	if (lflag >= 2)
  800701:	83 f9 01             	cmp    $0x1,%ecx
  800704:	7e 15                	jle    80071b <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8b 10                	mov    (%eax),%edx
  80070b:	8b 48 04             	mov    0x4(%eax),%ecx
  80070e:	8d 40 08             	lea    0x8(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800714:	b8 0a 00 00 00       	mov    $0xa,%eax
  800719:	eb 77                	jmp    800792 <vprintfmt+0x386>
	else if (lflag)
  80071b:	85 c9                	test   %ecx,%ecx
  80071d:	75 17                	jne    800736 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8b 10                	mov    (%eax),%edx
  800724:	b9 00 00 00 00       	mov    $0x0,%ecx
  800729:	8d 40 04             	lea    0x4(%eax),%eax
  80072c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800734:	eb 5c                	jmp    800792 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	8b 10                	mov    (%eax),%edx
  80073b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800740:	8d 40 04             	lea    0x4(%eax),%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800746:	b8 0a 00 00 00       	mov    $0xa,%eax
  80074b:	eb 45                	jmp    800792 <vprintfmt+0x386>
			putch('X', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	6a 58                	push   $0x58
  800753:	ff d6                	call   *%esi
			putch('X', putdat);
  800755:	83 c4 08             	add    $0x8,%esp
  800758:	53                   	push   %ebx
  800759:	6a 58                	push   $0x58
  80075b:	ff d6                	call   *%esi
			putch('X', putdat);
  80075d:	83 c4 08             	add    $0x8,%esp
  800760:	53                   	push   %ebx
  800761:	6a 58                	push   $0x58
  800763:	ff d6                	call   *%esi
			break;
  800765:	83 c4 10             	add    $0x10,%esp
  800768:	eb 42                	jmp    8007ac <vprintfmt+0x3a0>
			putch('0', putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	53                   	push   %ebx
  80076e:	6a 30                	push   $0x30
  800770:	ff d6                	call   *%esi
			putch('x', putdat);
  800772:	83 c4 08             	add    $0x8,%esp
  800775:	53                   	push   %ebx
  800776:	6a 78                	push   $0x78
  800778:	ff d6                	call   *%esi
			num = (unsigned long long)
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 10                	mov    (%eax),%edx
  80077f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800784:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800787:	8d 40 04             	lea    0x4(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800799:	57                   	push   %edi
  80079a:	ff 75 e0             	pushl  -0x20(%ebp)
  80079d:	50                   	push   %eax
  80079e:	51                   	push   %ecx
  80079f:	52                   	push   %edx
  8007a0:	89 da                	mov    %ebx,%edx
  8007a2:	89 f0                	mov    %esi,%eax
  8007a4:	e8 7a fb ff ff       	call   800323 <printnum>
			break;
  8007a9:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007af:	83 c7 01             	add    $0x1,%edi
  8007b2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007b6:	83 f8 25             	cmp    $0x25,%eax
  8007b9:	0f 84 64 fc ff ff    	je     800423 <vprintfmt+0x17>
			if (ch == '\0')
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	0f 84 8b 00 00 00    	je     800852 <vprintfmt+0x446>
			putch(ch, putdat);
  8007c7:	83 ec 08             	sub    $0x8,%esp
  8007ca:	53                   	push   %ebx
  8007cb:	50                   	push   %eax
  8007cc:	ff d6                	call   *%esi
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	eb dc                	jmp    8007af <vprintfmt+0x3a3>
	if (lflag >= 2)
  8007d3:	83 f9 01             	cmp    $0x1,%ecx
  8007d6:	7e 15                	jle    8007ed <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8b 10                	mov    (%eax),%edx
  8007dd:	8b 48 04             	mov    0x4(%eax),%ecx
  8007e0:	8d 40 08             	lea    0x8(%eax),%eax
  8007e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e6:	b8 10 00 00 00       	mov    $0x10,%eax
  8007eb:	eb a5                	jmp    800792 <vprintfmt+0x386>
	else if (lflag)
  8007ed:	85 c9                	test   %ecx,%ecx
  8007ef:	75 17                	jne    800808 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8b 10                	mov    (%eax),%edx
  8007f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fb:	8d 40 04             	lea    0x4(%eax),%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800801:	b8 10 00 00 00       	mov    $0x10,%eax
  800806:	eb 8a                	jmp    800792 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 10                	mov    (%eax),%edx
  80080d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800812:	8d 40 04             	lea    0x4(%eax),%eax
  800815:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800818:	b8 10 00 00 00       	mov    $0x10,%eax
  80081d:	e9 70 ff ff ff       	jmp    800792 <vprintfmt+0x386>
			putch(ch, putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	53                   	push   %ebx
  800826:	6a 25                	push   $0x25
  800828:	ff d6                	call   *%esi
			break;
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	e9 7a ff ff ff       	jmp    8007ac <vprintfmt+0x3a0>
			putch('%', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	53                   	push   %ebx
  800836:	6a 25                	push   $0x25
  800838:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80083a:	83 c4 10             	add    $0x10,%esp
  80083d:	89 f8                	mov    %edi,%eax
  80083f:	eb 03                	jmp    800844 <vprintfmt+0x438>
  800841:	83 e8 01             	sub    $0x1,%eax
  800844:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800848:	75 f7                	jne    800841 <vprintfmt+0x435>
  80084a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80084d:	e9 5a ff ff ff       	jmp    8007ac <vprintfmt+0x3a0>
}
  800852:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800855:	5b                   	pop    %ebx
  800856:	5e                   	pop    %esi
  800857:	5f                   	pop    %edi
  800858:	5d                   	pop    %ebp
  800859:	c3                   	ret    

0080085a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	83 ec 18             	sub    $0x18,%esp
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800866:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800869:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800870:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800877:	85 c0                	test   %eax,%eax
  800879:	74 26                	je     8008a1 <vsnprintf+0x47>
  80087b:	85 d2                	test   %edx,%edx
  80087d:	7e 22                	jle    8008a1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80087f:	ff 75 14             	pushl  0x14(%ebp)
  800882:	ff 75 10             	pushl  0x10(%ebp)
  800885:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800888:	50                   	push   %eax
  800889:	68 d2 03 80 00       	push   $0x8003d2
  80088e:	e8 79 fb ff ff       	call   80040c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800896:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089c:	83 c4 10             	add    $0x10,%esp
}
  80089f:	c9                   	leave  
  8008a0:	c3                   	ret    
		return -E_INVAL;
  8008a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a6:	eb f7                	jmp    80089f <vsnprintf+0x45>

008008a8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ae:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008b1:	50                   	push   %eax
  8008b2:	ff 75 10             	pushl  0x10(%ebp)
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	ff 75 08             	pushl  0x8(%ebp)
  8008bb:	e8 9a ff ff ff       	call   80085a <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    

008008c2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cd:	eb 03                	jmp    8008d2 <strlen+0x10>
		n++;
  8008cf:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008d2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008d6:	75 f7                	jne    8008cf <strlen+0xd>
	return n;
}
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e0:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e8:	eb 03                	jmp    8008ed <strnlen+0x13>
		n++;
  8008ea:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ed:	39 d0                	cmp    %edx,%eax
  8008ef:	74 06                	je     8008f7 <strnlen+0x1d>
  8008f1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008f5:	75 f3                	jne    8008ea <strnlen+0x10>
	return n;
}
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	53                   	push   %ebx
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800903:	89 c2                	mov    %eax,%edx
  800905:	83 c1 01             	add    $0x1,%ecx
  800908:	83 c2 01             	add    $0x1,%edx
  80090b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80090f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800912:	84 db                	test   %bl,%bl
  800914:	75 ef                	jne    800905 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800916:	5b                   	pop    %ebx
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	53                   	push   %ebx
  80091d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800920:	53                   	push   %ebx
  800921:	e8 9c ff ff ff       	call   8008c2 <strlen>
  800926:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	01 d8                	add    %ebx,%eax
  80092e:	50                   	push   %eax
  80092f:	e8 c5 ff ff ff       	call   8008f9 <strcpy>
	return dst;
}
  800934:	89 d8                	mov    %ebx,%eax
  800936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800939:	c9                   	leave  
  80093a:	c3                   	ret    

0080093b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	56                   	push   %esi
  80093f:	53                   	push   %ebx
  800940:	8b 75 08             	mov    0x8(%ebp),%esi
  800943:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800946:	89 f3                	mov    %esi,%ebx
  800948:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80094b:	89 f2                	mov    %esi,%edx
  80094d:	eb 0f                	jmp    80095e <strncpy+0x23>
		*dst++ = *src;
  80094f:	83 c2 01             	add    $0x1,%edx
  800952:	0f b6 01             	movzbl (%ecx),%eax
  800955:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800958:	80 39 01             	cmpb   $0x1,(%ecx)
  80095b:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80095e:	39 da                	cmp    %ebx,%edx
  800960:	75 ed                	jne    80094f <strncpy+0x14>
	}
	return ret;
}
  800962:	89 f0                	mov    %esi,%eax
  800964:	5b                   	pop    %ebx
  800965:	5e                   	pop    %esi
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	56                   	push   %esi
  80096c:	53                   	push   %ebx
  80096d:	8b 75 08             	mov    0x8(%ebp),%esi
  800970:	8b 55 0c             	mov    0xc(%ebp),%edx
  800973:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800976:	89 f0                	mov    %esi,%eax
  800978:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80097c:	85 c9                	test   %ecx,%ecx
  80097e:	75 0b                	jne    80098b <strlcpy+0x23>
  800980:	eb 17                	jmp    800999 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800982:	83 c2 01             	add    $0x1,%edx
  800985:	83 c0 01             	add    $0x1,%eax
  800988:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80098b:	39 d8                	cmp    %ebx,%eax
  80098d:	74 07                	je     800996 <strlcpy+0x2e>
  80098f:	0f b6 0a             	movzbl (%edx),%ecx
  800992:	84 c9                	test   %cl,%cl
  800994:	75 ec                	jne    800982 <strlcpy+0x1a>
		*dst = '\0';
  800996:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800999:	29 f0                	sub    %esi,%eax
}
  80099b:	5b                   	pop    %ebx
  80099c:	5e                   	pop    %esi
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a8:	eb 06                	jmp    8009b0 <strcmp+0x11>
		p++, q++;
  8009aa:	83 c1 01             	add    $0x1,%ecx
  8009ad:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009b0:	0f b6 01             	movzbl (%ecx),%eax
  8009b3:	84 c0                	test   %al,%al
  8009b5:	74 04                	je     8009bb <strcmp+0x1c>
  8009b7:	3a 02                	cmp    (%edx),%al
  8009b9:	74 ef                	je     8009aa <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009bb:	0f b6 c0             	movzbl %al,%eax
  8009be:	0f b6 12             	movzbl (%edx),%edx
  8009c1:	29 d0                	sub    %edx,%eax
}
  8009c3:	5d                   	pop    %ebp
  8009c4:	c3                   	ret    

008009c5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	53                   	push   %ebx
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cf:	89 c3                	mov    %eax,%ebx
  8009d1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d4:	eb 06                	jmp    8009dc <strncmp+0x17>
		n--, p++, q++;
  8009d6:	83 c0 01             	add    $0x1,%eax
  8009d9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009dc:	39 d8                	cmp    %ebx,%eax
  8009de:	74 16                	je     8009f6 <strncmp+0x31>
  8009e0:	0f b6 08             	movzbl (%eax),%ecx
  8009e3:	84 c9                	test   %cl,%cl
  8009e5:	74 04                	je     8009eb <strncmp+0x26>
  8009e7:	3a 0a                	cmp    (%edx),%cl
  8009e9:	74 eb                	je     8009d6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009eb:	0f b6 00             	movzbl (%eax),%eax
  8009ee:	0f b6 12             	movzbl (%edx),%edx
  8009f1:	29 d0                	sub    %edx,%eax
}
  8009f3:	5b                   	pop    %ebx
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    
		return 0;
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	eb f6                	jmp    8009f3 <strncmp+0x2e>

008009fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a07:	0f b6 10             	movzbl (%eax),%edx
  800a0a:	84 d2                	test   %dl,%dl
  800a0c:	74 09                	je     800a17 <strchr+0x1a>
		if (*s == c)
  800a0e:	38 ca                	cmp    %cl,%dl
  800a10:	74 0a                	je     800a1c <strchr+0x1f>
	for (; *s; s++)
  800a12:	83 c0 01             	add    $0x1,%eax
  800a15:	eb f0                	jmp    800a07 <strchr+0xa>
			return (char *) s;
	return 0;
  800a17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    

00800a1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a28:	eb 03                	jmp    800a2d <strfind+0xf>
  800a2a:	83 c0 01             	add    $0x1,%eax
  800a2d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a30:	38 ca                	cmp    %cl,%dl
  800a32:	74 04                	je     800a38 <strfind+0x1a>
  800a34:	84 d2                	test   %dl,%dl
  800a36:	75 f2                	jne    800a2a <strfind+0xc>
			break;
	return (char *) s;
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	57                   	push   %edi
  800a3e:	56                   	push   %esi
  800a3f:	53                   	push   %ebx
  800a40:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a43:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a46:	85 c9                	test   %ecx,%ecx
  800a48:	74 13                	je     800a5d <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a4a:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a50:	75 05                	jne    800a57 <memset+0x1d>
  800a52:	f6 c1 03             	test   $0x3,%cl
  800a55:	74 0d                	je     800a64 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5a:	fc                   	cld    
  800a5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a5d:	89 f8                	mov    %edi,%eax
  800a5f:	5b                   	pop    %ebx
  800a60:	5e                   	pop    %esi
  800a61:	5f                   	pop    %edi
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    
		c &= 0xFF;
  800a64:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a68:	89 d3                	mov    %edx,%ebx
  800a6a:	c1 e3 08             	shl    $0x8,%ebx
  800a6d:	89 d0                	mov    %edx,%eax
  800a6f:	c1 e0 18             	shl    $0x18,%eax
  800a72:	89 d6                	mov    %edx,%esi
  800a74:	c1 e6 10             	shl    $0x10,%esi
  800a77:	09 f0                	or     %esi,%eax
  800a79:	09 c2                	or     %eax,%edx
  800a7b:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a7d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a80:	89 d0                	mov    %edx,%eax
  800a82:	fc                   	cld    
  800a83:	f3 ab                	rep stos %eax,%es:(%edi)
  800a85:	eb d6                	jmp    800a5d <memset+0x23>

00800a87 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	57                   	push   %edi
  800a8b:	56                   	push   %esi
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a92:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a95:	39 c6                	cmp    %eax,%esi
  800a97:	73 35                	jae    800ace <memmove+0x47>
  800a99:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9c:	39 c2                	cmp    %eax,%edx
  800a9e:	76 2e                	jbe    800ace <memmove+0x47>
		s += n;
		d += n;
  800aa0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa3:	89 d6                	mov    %edx,%esi
  800aa5:	09 fe                	or     %edi,%esi
  800aa7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aad:	74 0c                	je     800abb <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aaf:	83 ef 01             	sub    $0x1,%edi
  800ab2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ab5:	fd                   	std    
  800ab6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab8:	fc                   	cld    
  800ab9:	eb 21                	jmp    800adc <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abb:	f6 c1 03             	test   $0x3,%cl
  800abe:	75 ef                	jne    800aaf <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac0:	83 ef 04             	sub    $0x4,%edi
  800ac3:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ac6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ac9:	fd                   	std    
  800aca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800acc:	eb ea                	jmp    800ab8 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ace:	89 f2                	mov    %esi,%edx
  800ad0:	09 c2                	or     %eax,%edx
  800ad2:	f6 c2 03             	test   $0x3,%dl
  800ad5:	74 09                	je     800ae0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ad7:	89 c7                	mov    %eax,%edi
  800ad9:	fc                   	cld    
  800ada:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800adc:	5e                   	pop    %esi
  800add:	5f                   	pop    %edi
  800ade:	5d                   	pop    %ebp
  800adf:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae0:	f6 c1 03             	test   $0x3,%cl
  800ae3:	75 f2                	jne    800ad7 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ae5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ae8:	89 c7                	mov    %eax,%edi
  800aea:	fc                   	cld    
  800aeb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aed:	eb ed                	jmp    800adc <memmove+0x55>

00800aef <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800af2:	ff 75 10             	pushl  0x10(%ebp)
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	ff 75 08             	pushl  0x8(%ebp)
  800afb:	e8 87 ff ff ff       	call   800a87 <memmove>
}
  800b00:	c9                   	leave  
  800b01:	c3                   	ret    

00800b02 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	56                   	push   %esi
  800b06:	53                   	push   %ebx
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0d:	89 c6                	mov    %eax,%esi
  800b0f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b12:	39 f0                	cmp    %esi,%eax
  800b14:	74 1c                	je     800b32 <memcmp+0x30>
		if (*s1 != *s2)
  800b16:	0f b6 08             	movzbl (%eax),%ecx
  800b19:	0f b6 1a             	movzbl (%edx),%ebx
  800b1c:	38 d9                	cmp    %bl,%cl
  800b1e:	75 08                	jne    800b28 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b20:	83 c0 01             	add    $0x1,%eax
  800b23:	83 c2 01             	add    $0x1,%edx
  800b26:	eb ea                	jmp    800b12 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b28:	0f b6 c1             	movzbl %cl,%eax
  800b2b:	0f b6 db             	movzbl %bl,%ebx
  800b2e:	29 d8                	sub    %ebx,%eax
  800b30:	eb 05                	jmp    800b37 <memcmp+0x35>
	}

	return 0;
  800b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b37:	5b                   	pop    %ebx
  800b38:	5e                   	pop    %esi
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b44:	89 c2                	mov    %eax,%edx
  800b46:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b49:	39 d0                	cmp    %edx,%eax
  800b4b:	73 09                	jae    800b56 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b4d:	38 08                	cmp    %cl,(%eax)
  800b4f:	74 05                	je     800b56 <memfind+0x1b>
	for (; s < ends; s++)
  800b51:	83 c0 01             	add    $0x1,%eax
  800b54:	eb f3                	jmp    800b49 <memfind+0xe>
			break;
	return (void *) s;
}
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	57                   	push   %edi
  800b5c:	56                   	push   %esi
  800b5d:	53                   	push   %ebx
  800b5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b64:	eb 03                	jmp    800b69 <strtol+0x11>
		s++;
  800b66:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b69:	0f b6 01             	movzbl (%ecx),%eax
  800b6c:	3c 20                	cmp    $0x20,%al
  800b6e:	74 f6                	je     800b66 <strtol+0xe>
  800b70:	3c 09                	cmp    $0x9,%al
  800b72:	74 f2                	je     800b66 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b74:	3c 2b                	cmp    $0x2b,%al
  800b76:	74 2e                	je     800ba6 <strtol+0x4e>
	int neg = 0;
  800b78:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b7d:	3c 2d                	cmp    $0x2d,%al
  800b7f:	74 2f                	je     800bb0 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b81:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b87:	75 05                	jne    800b8e <strtol+0x36>
  800b89:	80 39 30             	cmpb   $0x30,(%ecx)
  800b8c:	74 2c                	je     800bba <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b8e:	85 db                	test   %ebx,%ebx
  800b90:	75 0a                	jne    800b9c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b92:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b97:	80 39 30             	cmpb   $0x30,(%ecx)
  800b9a:	74 28                	je     800bc4 <strtol+0x6c>
		base = 10;
  800b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ba4:	eb 50                	jmp    800bf6 <strtol+0x9e>
		s++;
  800ba6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ba9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bae:	eb d1                	jmp    800b81 <strtol+0x29>
		s++, neg = 1;
  800bb0:	83 c1 01             	add    $0x1,%ecx
  800bb3:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb8:	eb c7                	jmp    800b81 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bba:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bbe:	74 0e                	je     800bce <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bc0:	85 db                	test   %ebx,%ebx
  800bc2:	75 d8                	jne    800b9c <strtol+0x44>
		s++, base = 8;
  800bc4:	83 c1 01             	add    $0x1,%ecx
  800bc7:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bcc:	eb ce                	jmp    800b9c <strtol+0x44>
		s += 2, base = 16;
  800bce:	83 c1 02             	add    $0x2,%ecx
  800bd1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bd6:	eb c4                	jmp    800b9c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bd8:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bdb:	89 f3                	mov    %esi,%ebx
  800bdd:	80 fb 19             	cmp    $0x19,%bl
  800be0:	77 29                	ja     800c0b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800be2:	0f be d2             	movsbl %dl,%edx
  800be5:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be8:	3b 55 10             	cmp    0x10(%ebp),%edx
  800beb:	7d 30                	jge    800c1d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bed:	83 c1 01             	add    $0x1,%ecx
  800bf0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bf4:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bf6:	0f b6 11             	movzbl (%ecx),%edx
  800bf9:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bfc:	89 f3                	mov    %esi,%ebx
  800bfe:	80 fb 09             	cmp    $0x9,%bl
  800c01:	77 d5                	ja     800bd8 <strtol+0x80>
			dig = *s - '0';
  800c03:	0f be d2             	movsbl %dl,%edx
  800c06:	83 ea 30             	sub    $0x30,%edx
  800c09:	eb dd                	jmp    800be8 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c0b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c0e:	89 f3                	mov    %esi,%ebx
  800c10:	80 fb 19             	cmp    $0x19,%bl
  800c13:	77 08                	ja     800c1d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c15:	0f be d2             	movsbl %dl,%edx
  800c18:	83 ea 37             	sub    $0x37,%edx
  800c1b:	eb cb                	jmp    800be8 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c21:	74 05                	je     800c28 <strtol+0xd0>
		*endptr = (char *) s;
  800c23:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c26:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c28:	89 c2                	mov    %eax,%edx
  800c2a:	f7 da                	neg    %edx
  800c2c:	85 ff                	test   %edi,%edi
  800c2e:	0f 45 c2             	cmovne %edx,%eax
}
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5f                   	pop    %edi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	57                   	push   %edi
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c41:	8b 55 08             	mov    0x8(%ebp),%edx
  800c44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c47:	89 c3                	mov    %eax,%ebx
  800c49:	89 c7                	mov    %eax,%edi
  800c4b:	89 c6                	mov    %eax,%esi
  800c4d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c64:	89 d1                	mov    %edx,%ecx
  800c66:	89 d3                	mov    %edx,%ebx
  800c68:	89 d7                	mov    %edx,%edi
  800c6a:	89 d6                	mov    %edx,%esi
  800c6c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
  800c79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c81:	8b 55 08             	mov    0x8(%ebp),%edx
  800c84:	b8 03 00 00 00       	mov    $0x3,%eax
  800c89:	89 cb                	mov    %ecx,%ebx
  800c8b:	89 cf                	mov    %ecx,%edi
  800c8d:	89 ce                	mov    %ecx,%esi
  800c8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c91:	85 c0                	test   %eax,%eax
  800c93:	7f 08                	jg     800c9d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	50                   	push   %eax
  800ca1:	6a 03                	push   $0x3
  800ca3:	68 3f 22 80 00       	push   $0x80223f
  800ca8:	6a 23                	push   $0x23
  800caa:	68 5c 22 80 00       	push   $0x80225c
  800caf:	e8 80 f5 ff ff       	call   800234 <_panic>

00800cb4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 02 00 00 00       	mov    $0x2,%eax
  800cc4:	89 d1                	mov    %edx,%ecx
  800cc6:	89 d3                	mov    %edx,%ebx
  800cc8:	89 d7                	mov    %edx,%edi
  800cca:	89 d6                	mov    %edx,%esi
  800ccc:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_yield>:

void
sys_yield(void)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cde:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ce3:	89 d1                	mov    %edx,%ecx
  800ce5:	89 d3                	mov    %edx,%ebx
  800ce7:	89 d7                	mov    %edx,%edi
  800ce9:	89 d6                	mov    %edx,%esi
  800ceb:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ced:	5b                   	pop    %ebx
  800cee:	5e                   	pop    %esi
  800cef:	5f                   	pop    %edi
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    

00800cf2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfb:	be 00 00 00 00       	mov    $0x0,%esi
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d06:	b8 04 00 00 00       	mov    $0x4,%eax
  800d0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0e:	89 f7                	mov    %esi,%edi
  800d10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d12:	85 c0                	test   %eax,%eax
  800d14:	7f 08                	jg     800d1e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1e:	83 ec 0c             	sub    $0xc,%esp
  800d21:	50                   	push   %eax
  800d22:	6a 04                	push   $0x4
  800d24:	68 3f 22 80 00       	push   $0x80223f
  800d29:	6a 23                	push   $0x23
  800d2b:	68 5c 22 80 00       	push   $0x80225c
  800d30:	e8 ff f4 ff ff       	call   800234 <_panic>

00800d35 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
  800d3b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d44:	b8 05 00 00 00       	mov    $0x5,%eax
  800d49:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d4f:	8b 75 18             	mov    0x18(%ebp),%esi
  800d52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d54:	85 c0                	test   %eax,%eax
  800d56:	7f 08                	jg     800d60 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5b:	5b                   	pop    %ebx
  800d5c:	5e                   	pop    %esi
  800d5d:	5f                   	pop    %edi
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d60:	83 ec 0c             	sub    $0xc,%esp
  800d63:	50                   	push   %eax
  800d64:	6a 05                	push   $0x5
  800d66:	68 3f 22 80 00       	push   $0x80223f
  800d6b:	6a 23                	push   $0x23
  800d6d:	68 5c 22 80 00       	push   $0x80225c
  800d72:	e8 bd f4 ff ff       	call   800234 <_panic>

00800d77 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	57                   	push   %edi
  800d7b:	56                   	push   %esi
  800d7c:	53                   	push   %ebx
  800d7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d80:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d85:	8b 55 08             	mov    0x8(%ebp),%edx
  800d88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8b:	b8 06 00 00 00       	mov    $0x6,%eax
  800d90:	89 df                	mov    %ebx,%edi
  800d92:	89 de                	mov    %ebx,%esi
  800d94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d96:	85 c0                	test   %eax,%eax
  800d98:	7f 08                	jg     800da2 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da2:	83 ec 0c             	sub    $0xc,%esp
  800da5:	50                   	push   %eax
  800da6:	6a 06                	push   $0x6
  800da8:	68 3f 22 80 00       	push   $0x80223f
  800dad:	6a 23                	push   $0x23
  800daf:	68 5c 22 80 00       	push   $0x80225c
  800db4:	e8 7b f4 ff ff       	call   800234 <_panic>

00800db9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcd:	b8 08 00 00 00       	mov    $0x8,%eax
  800dd2:	89 df                	mov    %ebx,%edi
  800dd4:	89 de                	mov    %ebx,%esi
  800dd6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	7f 08                	jg     800de4 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de4:	83 ec 0c             	sub    $0xc,%esp
  800de7:	50                   	push   %eax
  800de8:	6a 08                	push   $0x8
  800dea:	68 3f 22 80 00       	push   $0x80223f
  800def:	6a 23                	push   $0x23
  800df1:	68 5c 22 80 00       	push   $0x80225c
  800df6:	e8 39 f4 ff ff       	call   800234 <_panic>

00800dfb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
  800e01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0f:	b8 09 00 00 00       	mov    $0x9,%eax
  800e14:	89 df                	mov    %ebx,%edi
  800e16:	89 de                	mov    %ebx,%esi
  800e18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	7f 08                	jg     800e26 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	50                   	push   %eax
  800e2a:	6a 09                	push   $0x9
  800e2c:	68 3f 22 80 00       	push   $0x80223f
  800e31:	6a 23                	push   $0x23
  800e33:	68 5c 22 80 00       	push   $0x80225c
  800e38:	e8 f7 f3 ff ff       	call   800234 <_panic>

00800e3d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	57                   	push   %edi
  800e41:	56                   	push   %esi
  800e42:	53                   	push   %ebx
  800e43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e51:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e56:	89 df                	mov    %ebx,%edi
  800e58:	89 de                	mov    %ebx,%esi
  800e5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	7f 08                	jg     800e68 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e63:	5b                   	pop    %ebx
  800e64:	5e                   	pop    %esi
  800e65:	5f                   	pop    %edi
  800e66:	5d                   	pop    %ebp
  800e67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e68:	83 ec 0c             	sub    $0xc,%esp
  800e6b:	50                   	push   %eax
  800e6c:	6a 0a                	push   $0xa
  800e6e:	68 3f 22 80 00       	push   $0x80223f
  800e73:	6a 23                	push   $0x23
  800e75:	68 5c 22 80 00       	push   $0x80225c
  800e7a:	e8 b5 f3 ff ff       	call   800234 <_panic>

00800e7f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e85:	8b 55 08             	mov    0x8(%ebp),%edx
  800e88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e90:	be 00 00 00 00       	mov    $0x0,%esi
  800e95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e98:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e9b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5f                   	pop    %edi
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    

00800ea2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
  800ea8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eab:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb8:	89 cb                	mov    %ecx,%ebx
  800eba:	89 cf                	mov    %ecx,%edi
  800ebc:	89 ce                	mov    %ecx,%esi
  800ebe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	7f 08                	jg     800ecc <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecc:	83 ec 0c             	sub    $0xc,%esp
  800ecf:	50                   	push   %eax
  800ed0:	6a 0d                	push   $0xd
  800ed2:	68 3f 22 80 00       	push   $0x80223f
  800ed7:	6a 23                	push   $0x23
  800ed9:	68 5c 22 80 00       	push   $0x80225c
  800ede:	e8 51 f3 ff ff       	call   800234 <_panic>

00800ee3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	05 00 00 00 30       	add    $0x30000000,%eax
  800eee:	c1 e8 0c             	shr    $0xc,%eax
}
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    

00800ef3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800efe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f03:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f10:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f15:	89 c2                	mov    %eax,%edx
  800f17:	c1 ea 16             	shr    $0x16,%edx
  800f1a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f21:	f6 c2 01             	test   $0x1,%dl
  800f24:	74 2a                	je     800f50 <fd_alloc+0x46>
  800f26:	89 c2                	mov    %eax,%edx
  800f28:	c1 ea 0c             	shr    $0xc,%edx
  800f2b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f32:	f6 c2 01             	test   $0x1,%dl
  800f35:	74 19                	je     800f50 <fd_alloc+0x46>
  800f37:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f3c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f41:	75 d2                	jne    800f15 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f43:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f49:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f4e:	eb 07                	jmp    800f57 <fd_alloc+0x4d>
			*fd_store = fd;
  800f50:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f5f:	83 f8 1f             	cmp    $0x1f,%eax
  800f62:	77 36                	ja     800f9a <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f64:	c1 e0 0c             	shl    $0xc,%eax
  800f67:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f6c:	89 c2                	mov    %eax,%edx
  800f6e:	c1 ea 16             	shr    $0x16,%edx
  800f71:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f78:	f6 c2 01             	test   $0x1,%dl
  800f7b:	74 24                	je     800fa1 <fd_lookup+0x48>
  800f7d:	89 c2                	mov    %eax,%edx
  800f7f:	c1 ea 0c             	shr    $0xc,%edx
  800f82:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f89:	f6 c2 01             	test   $0x1,%dl
  800f8c:	74 1a                	je     800fa8 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f91:	89 02                	mov    %eax,(%edx)
	return 0;
  800f93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    
		return -E_INVAL;
  800f9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f9f:	eb f7                	jmp    800f98 <fd_lookup+0x3f>
		return -E_INVAL;
  800fa1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fa6:	eb f0                	jmp    800f98 <fd_lookup+0x3f>
  800fa8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fad:	eb e9                	jmp    800f98 <fd_lookup+0x3f>

00800faf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 08             	sub    $0x8,%esp
  800fb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fb8:	ba ec 22 80 00       	mov    $0x8022ec,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800fbd:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fc2:	39 08                	cmp    %ecx,(%eax)
  800fc4:	74 33                	je     800ff9 <dev_lookup+0x4a>
  800fc6:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800fc9:	8b 02                	mov    (%edx),%eax
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	75 f3                	jne    800fc2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fcf:	a1 04 40 80 00       	mov    0x804004,%eax
  800fd4:	8b 40 48             	mov    0x48(%eax),%eax
  800fd7:	83 ec 04             	sub    $0x4,%esp
  800fda:	51                   	push   %ecx
  800fdb:	50                   	push   %eax
  800fdc:	68 6c 22 80 00       	push   $0x80226c
  800fe1:	e8 29 f3 ff ff       	call   80030f <cprintf>
	*dev = 0;
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fef:	83 c4 10             	add    $0x10,%esp
  800ff2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ff7:	c9                   	leave  
  800ff8:	c3                   	ret    
			*dev = devtab[i];
  800ff9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffc:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  801003:	eb f2                	jmp    800ff7 <dev_lookup+0x48>

00801005 <fd_close>:
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	57                   	push   %edi
  801009:	56                   	push   %esi
  80100a:	53                   	push   %ebx
  80100b:	83 ec 1c             	sub    $0x1c,%esp
  80100e:	8b 75 08             	mov    0x8(%ebp),%esi
  801011:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801014:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801017:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801018:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80101e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801021:	50                   	push   %eax
  801022:	e8 32 ff ff ff       	call   800f59 <fd_lookup>
  801027:	89 c3                	mov    %eax,%ebx
  801029:	83 c4 08             	add    $0x8,%esp
  80102c:	85 c0                	test   %eax,%eax
  80102e:	78 05                	js     801035 <fd_close+0x30>
	    || fd != fd2)
  801030:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801033:	74 16                	je     80104b <fd_close+0x46>
		return (must_exist ? r : 0);
  801035:	89 f8                	mov    %edi,%eax
  801037:	84 c0                	test   %al,%al
  801039:	b8 00 00 00 00       	mov    $0x0,%eax
  80103e:	0f 44 d8             	cmove  %eax,%ebx
}
  801041:	89 d8                	mov    %ebx,%eax
  801043:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801046:	5b                   	pop    %ebx
  801047:	5e                   	pop    %esi
  801048:	5f                   	pop    %edi
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80104b:	83 ec 08             	sub    $0x8,%esp
  80104e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801051:	50                   	push   %eax
  801052:	ff 36                	pushl  (%esi)
  801054:	e8 56 ff ff ff       	call   800faf <dev_lookup>
  801059:	89 c3                	mov    %eax,%ebx
  80105b:	83 c4 10             	add    $0x10,%esp
  80105e:	85 c0                	test   %eax,%eax
  801060:	78 15                	js     801077 <fd_close+0x72>
		if (dev->dev_close)
  801062:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801065:	8b 40 10             	mov    0x10(%eax),%eax
  801068:	85 c0                	test   %eax,%eax
  80106a:	74 1b                	je     801087 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80106c:	83 ec 0c             	sub    $0xc,%esp
  80106f:	56                   	push   %esi
  801070:	ff d0                	call   *%eax
  801072:	89 c3                	mov    %eax,%ebx
  801074:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801077:	83 ec 08             	sub    $0x8,%esp
  80107a:	56                   	push   %esi
  80107b:	6a 00                	push   $0x0
  80107d:	e8 f5 fc ff ff       	call   800d77 <sys_page_unmap>
	return r;
  801082:	83 c4 10             	add    $0x10,%esp
  801085:	eb ba                	jmp    801041 <fd_close+0x3c>
			r = 0;
  801087:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108c:	eb e9                	jmp    801077 <fd_close+0x72>

0080108e <close>:

int
close(int fdnum)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801094:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801097:	50                   	push   %eax
  801098:	ff 75 08             	pushl  0x8(%ebp)
  80109b:	e8 b9 fe ff ff       	call   800f59 <fd_lookup>
  8010a0:	83 c4 08             	add    $0x8,%esp
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	78 10                	js     8010b7 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8010a7:	83 ec 08             	sub    $0x8,%esp
  8010aa:	6a 01                	push   $0x1
  8010ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8010af:	e8 51 ff ff ff       	call   801005 <fd_close>
  8010b4:	83 c4 10             	add    $0x10,%esp
}
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <close_all>:

void
close_all(void)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	53                   	push   %ebx
  8010bd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010c0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010c5:	83 ec 0c             	sub    $0xc,%esp
  8010c8:	53                   	push   %ebx
  8010c9:	e8 c0 ff ff ff       	call   80108e <close>
	for (i = 0; i < MAXFD; i++)
  8010ce:	83 c3 01             	add    $0x1,%ebx
  8010d1:	83 c4 10             	add    $0x10,%esp
  8010d4:	83 fb 20             	cmp    $0x20,%ebx
  8010d7:	75 ec                	jne    8010c5 <close_all+0xc>
}
  8010d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	57                   	push   %edi
  8010e2:	56                   	push   %esi
  8010e3:	53                   	push   %ebx
  8010e4:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010e7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010ea:	50                   	push   %eax
  8010eb:	ff 75 08             	pushl  0x8(%ebp)
  8010ee:	e8 66 fe ff ff       	call   800f59 <fd_lookup>
  8010f3:	89 c3                	mov    %eax,%ebx
  8010f5:	83 c4 08             	add    $0x8,%esp
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	0f 88 81 00 00 00    	js     801181 <dup+0xa3>
		return r;
	close(newfdnum);
  801100:	83 ec 0c             	sub    $0xc,%esp
  801103:	ff 75 0c             	pushl  0xc(%ebp)
  801106:	e8 83 ff ff ff       	call   80108e <close>

	newfd = INDEX2FD(newfdnum);
  80110b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80110e:	c1 e6 0c             	shl    $0xc,%esi
  801111:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801117:	83 c4 04             	add    $0x4,%esp
  80111a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80111d:	e8 d1 fd ff ff       	call   800ef3 <fd2data>
  801122:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801124:	89 34 24             	mov    %esi,(%esp)
  801127:	e8 c7 fd ff ff       	call   800ef3 <fd2data>
  80112c:	83 c4 10             	add    $0x10,%esp
  80112f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801131:	89 d8                	mov    %ebx,%eax
  801133:	c1 e8 16             	shr    $0x16,%eax
  801136:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80113d:	a8 01                	test   $0x1,%al
  80113f:	74 11                	je     801152 <dup+0x74>
  801141:	89 d8                	mov    %ebx,%eax
  801143:	c1 e8 0c             	shr    $0xc,%eax
  801146:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80114d:	f6 c2 01             	test   $0x1,%dl
  801150:	75 39                	jne    80118b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801152:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801155:	89 d0                	mov    %edx,%eax
  801157:	c1 e8 0c             	shr    $0xc,%eax
  80115a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801161:	83 ec 0c             	sub    $0xc,%esp
  801164:	25 07 0e 00 00       	and    $0xe07,%eax
  801169:	50                   	push   %eax
  80116a:	56                   	push   %esi
  80116b:	6a 00                	push   $0x0
  80116d:	52                   	push   %edx
  80116e:	6a 00                	push   $0x0
  801170:	e8 c0 fb ff ff       	call   800d35 <sys_page_map>
  801175:	89 c3                	mov    %eax,%ebx
  801177:	83 c4 20             	add    $0x20,%esp
  80117a:	85 c0                	test   %eax,%eax
  80117c:	78 31                	js     8011af <dup+0xd1>
		goto err;

	return newfdnum;
  80117e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801181:	89 d8                	mov    %ebx,%eax
  801183:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801186:	5b                   	pop    %ebx
  801187:	5e                   	pop    %esi
  801188:	5f                   	pop    %edi
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80118b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801192:	83 ec 0c             	sub    $0xc,%esp
  801195:	25 07 0e 00 00       	and    $0xe07,%eax
  80119a:	50                   	push   %eax
  80119b:	57                   	push   %edi
  80119c:	6a 00                	push   $0x0
  80119e:	53                   	push   %ebx
  80119f:	6a 00                	push   $0x0
  8011a1:	e8 8f fb ff ff       	call   800d35 <sys_page_map>
  8011a6:	89 c3                	mov    %eax,%ebx
  8011a8:	83 c4 20             	add    $0x20,%esp
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	79 a3                	jns    801152 <dup+0x74>
	sys_page_unmap(0, newfd);
  8011af:	83 ec 08             	sub    $0x8,%esp
  8011b2:	56                   	push   %esi
  8011b3:	6a 00                	push   $0x0
  8011b5:	e8 bd fb ff ff       	call   800d77 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011ba:	83 c4 08             	add    $0x8,%esp
  8011bd:	57                   	push   %edi
  8011be:	6a 00                	push   $0x0
  8011c0:	e8 b2 fb ff ff       	call   800d77 <sys_page_unmap>
	return r;
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	eb b7                	jmp    801181 <dup+0xa3>

008011ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	53                   	push   %ebx
  8011ce:	83 ec 14             	sub    $0x14,%esp
  8011d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011d7:	50                   	push   %eax
  8011d8:	53                   	push   %ebx
  8011d9:	e8 7b fd ff ff       	call   800f59 <fd_lookup>
  8011de:	83 c4 08             	add    $0x8,%esp
  8011e1:	85 c0                	test   %eax,%eax
  8011e3:	78 3f                	js     801224 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011e5:	83 ec 08             	sub    $0x8,%esp
  8011e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011eb:	50                   	push   %eax
  8011ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ef:	ff 30                	pushl  (%eax)
  8011f1:	e8 b9 fd ff ff       	call   800faf <dev_lookup>
  8011f6:	83 c4 10             	add    $0x10,%esp
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	78 27                	js     801224 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801200:	8b 42 08             	mov    0x8(%edx),%eax
  801203:	83 e0 03             	and    $0x3,%eax
  801206:	83 f8 01             	cmp    $0x1,%eax
  801209:	74 1e                	je     801229 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80120b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80120e:	8b 40 08             	mov    0x8(%eax),%eax
  801211:	85 c0                	test   %eax,%eax
  801213:	74 35                	je     80124a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801215:	83 ec 04             	sub    $0x4,%esp
  801218:	ff 75 10             	pushl  0x10(%ebp)
  80121b:	ff 75 0c             	pushl  0xc(%ebp)
  80121e:	52                   	push   %edx
  80121f:	ff d0                	call   *%eax
  801221:	83 c4 10             	add    $0x10,%esp
}
  801224:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801227:	c9                   	leave  
  801228:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801229:	a1 04 40 80 00       	mov    0x804004,%eax
  80122e:	8b 40 48             	mov    0x48(%eax),%eax
  801231:	83 ec 04             	sub    $0x4,%esp
  801234:	53                   	push   %ebx
  801235:	50                   	push   %eax
  801236:	68 b0 22 80 00       	push   $0x8022b0
  80123b:	e8 cf f0 ff ff       	call   80030f <cprintf>
		return -E_INVAL;
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801248:	eb da                	jmp    801224 <read+0x5a>
		return -E_NOT_SUPP;
  80124a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80124f:	eb d3                	jmp    801224 <read+0x5a>

00801251 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	57                   	push   %edi
  801255:	56                   	push   %esi
  801256:	53                   	push   %ebx
  801257:	83 ec 0c             	sub    $0xc,%esp
  80125a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80125d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801260:	bb 00 00 00 00       	mov    $0x0,%ebx
  801265:	39 f3                	cmp    %esi,%ebx
  801267:	73 25                	jae    80128e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801269:	83 ec 04             	sub    $0x4,%esp
  80126c:	89 f0                	mov    %esi,%eax
  80126e:	29 d8                	sub    %ebx,%eax
  801270:	50                   	push   %eax
  801271:	89 d8                	mov    %ebx,%eax
  801273:	03 45 0c             	add    0xc(%ebp),%eax
  801276:	50                   	push   %eax
  801277:	57                   	push   %edi
  801278:	e8 4d ff ff ff       	call   8011ca <read>
		if (m < 0)
  80127d:	83 c4 10             	add    $0x10,%esp
  801280:	85 c0                	test   %eax,%eax
  801282:	78 08                	js     80128c <readn+0x3b>
			return m;
		if (m == 0)
  801284:	85 c0                	test   %eax,%eax
  801286:	74 06                	je     80128e <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801288:	01 c3                	add    %eax,%ebx
  80128a:	eb d9                	jmp    801265 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80128c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80128e:	89 d8                	mov    %ebx,%eax
  801290:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801293:	5b                   	pop    %ebx
  801294:	5e                   	pop    %esi
  801295:	5f                   	pop    %edi
  801296:	5d                   	pop    %ebp
  801297:	c3                   	ret    

00801298 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
  80129b:	53                   	push   %ebx
  80129c:	83 ec 14             	sub    $0x14,%esp
  80129f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a5:	50                   	push   %eax
  8012a6:	53                   	push   %ebx
  8012a7:	e8 ad fc ff ff       	call   800f59 <fd_lookup>
  8012ac:	83 c4 08             	add    $0x8,%esp
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	78 3a                	js     8012ed <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b3:	83 ec 08             	sub    $0x8,%esp
  8012b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b9:	50                   	push   %eax
  8012ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bd:	ff 30                	pushl  (%eax)
  8012bf:	e8 eb fc ff ff       	call   800faf <dev_lookup>
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	78 22                	js     8012ed <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ce:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012d2:	74 1e                	je     8012f2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d7:	8b 52 0c             	mov    0xc(%edx),%edx
  8012da:	85 d2                	test   %edx,%edx
  8012dc:	74 35                	je     801313 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012de:	83 ec 04             	sub    $0x4,%esp
  8012e1:	ff 75 10             	pushl  0x10(%ebp)
  8012e4:	ff 75 0c             	pushl  0xc(%ebp)
  8012e7:	50                   	push   %eax
  8012e8:	ff d2                	call   *%edx
  8012ea:	83 c4 10             	add    $0x10,%esp
}
  8012ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f2:	a1 04 40 80 00       	mov    0x804004,%eax
  8012f7:	8b 40 48             	mov    0x48(%eax),%eax
  8012fa:	83 ec 04             	sub    $0x4,%esp
  8012fd:	53                   	push   %ebx
  8012fe:	50                   	push   %eax
  8012ff:	68 cc 22 80 00       	push   $0x8022cc
  801304:	e8 06 f0 ff ff       	call   80030f <cprintf>
		return -E_INVAL;
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801311:	eb da                	jmp    8012ed <write+0x55>
		return -E_NOT_SUPP;
  801313:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801318:	eb d3                	jmp    8012ed <write+0x55>

0080131a <seek>:

int
seek(int fdnum, off_t offset)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801320:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801323:	50                   	push   %eax
  801324:	ff 75 08             	pushl  0x8(%ebp)
  801327:	e8 2d fc ff ff       	call   800f59 <fd_lookup>
  80132c:	83 c4 08             	add    $0x8,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	78 0e                	js     801341 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801333:	8b 55 0c             	mov    0xc(%ebp),%edx
  801336:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801339:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80133c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801341:	c9                   	leave  
  801342:	c3                   	ret    

00801343 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	53                   	push   %ebx
  801347:	83 ec 14             	sub    $0x14,%esp
  80134a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80134d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801350:	50                   	push   %eax
  801351:	53                   	push   %ebx
  801352:	e8 02 fc ff ff       	call   800f59 <fd_lookup>
  801357:	83 c4 08             	add    $0x8,%esp
  80135a:	85 c0                	test   %eax,%eax
  80135c:	78 37                	js     801395 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80135e:	83 ec 08             	sub    $0x8,%esp
  801361:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801364:	50                   	push   %eax
  801365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801368:	ff 30                	pushl  (%eax)
  80136a:	e8 40 fc ff ff       	call   800faf <dev_lookup>
  80136f:	83 c4 10             	add    $0x10,%esp
  801372:	85 c0                	test   %eax,%eax
  801374:	78 1f                	js     801395 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801379:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80137d:	74 1b                	je     80139a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80137f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801382:	8b 52 18             	mov    0x18(%edx),%edx
  801385:	85 d2                	test   %edx,%edx
  801387:	74 32                	je     8013bb <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801389:	83 ec 08             	sub    $0x8,%esp
  80138c:	ff 75 0c             	pushl  0xc(%ebp)
  80138f:	50                   	push   %eax
  801390:	ff d2                	call   *%edx
  801392:	83 c4 10             	add    $0x10,%esp
}
  801395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801398:	c9                   	leave  
  801399:	c3                   	ret    
			thisenv->env_id, fdnum);
  80139a:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80139f:	8b 40 48             	mov    0x48(%eax),%eax
  8013a2:	83 ec 04             	sub    $0x4,%esp
  8013a5:	53                   	push   %ebx
  8013a6:	50                   	push   %eax
  8013a7:	68 8c 22 80 00       	push   $0x80228c
  8013ac:	e8 5e ef ff ff       	call   80030f <cprintf>
		return -E_INVAL;
  8013b1:	83 c4 10             	add    $0x10,%esp
  8013b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b9:	eb da                	jmp    801395 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8013bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c0:	eb d3                	jmp    801395 <ftruncate+0x52>

008013c2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	53                   	push   %ebx
  8013c6:	83 ec 14             	sub    $0x14,%esp
  8013c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013cf:	50                   	push   %eax
  8013d0:	ff 75 08             	pushl  0x8(%ebp)
  8013d3:	e8 81 fb ff ff       	call   800f59 <fd_lookup>
  8013d8:	83 c4 08             	add    $0x8,%esp
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	78 4b                	js     80142a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e5:	50                   	push   %eax
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e9:	ff 30                	pushl  (%eax)
  8013eb:	e8 bf fb ff ff       	call   800faf <dev_lookup>
  8013f0:	83 c4 10             	add    $0x10,%esp
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	78 33                	js     80142a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fa:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013fe:	74 2f                	je     80142f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801400:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801403:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80140a:	00 00 00 
	stat->st_isdir = 0;
  80140d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801414:	00 00 00 
	stat->st_dev = dev;
  801417:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80141d:	83 ec 08             	sub    $0x8,%esp
  801420:	53                   	push   %ebx
  801421:	ff 75 f0             	pushl  -0x10(%ebp)
  801424:	ff 50 14             	call   *0x14(%eax)
  801427:	83 c4 10             	add    $0x10,%esp
}
  80142a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    
		return -E_NOT_SUPP;
  80142f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801434:	eb f4                	jmp    80142a <fstat+0x68>

00801436 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	56                   	push   %esi
  80143a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80143b:	83 ec 08             	sub    $0x8,%esp
  80143e:	6a 00                	push   $0x0
  801440:	ff 75 08             	pushl  0x8(%ebp)
  801443:	e8 e7 01 00 00       	call   80162f <open>
  801448:	89 c3                	mov    %eax,%ebx
  80144a:	83 c4 10             	add    $0x10,%esp
  80144d:	85 c0                	test   %eax,%eax
  80144f:	78 1b                	js     80146c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801451:	83 ec 08             	sub    $0x8,%esp
  801454:	ff 75 0c             	pushl  0xc(%ebp)
  801457:	50                   	push   %eax
  801458:	e8 65 ff ff ff       	call   8013c2 <fstat>
  80145d:	89 c6                	mov    %eax,%esi
	close(fd);
  80145f:	89 1c 24             	mov    %ebx,(%esp)
  801462:	e8 27 fc ff ff       	call   80108e <close>
	return r;
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	89 f3                	mov    %esi,%ebx
}
  80146c:	89 d8                	mov    %ebx,%eax
  80146e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801471:	5b                   	pop    %ebx
  801472:	5e                   	pop    %esi
  801473:	5d                   	pop    %ebp
  801474:	c3                   	ret    

00801475 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	56                   	push   %esi
  801479:	53                   	push   %ebx
  80147a:	89 c6                	mov    %eax,%esi
  80147c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80147e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801485:	74 27                	je     8014ae <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801487:	6a 07                	push   $0x7
  801489:	68 00 50 80 00       	push   $0x805000
  80148e:	56                   	push   %esi
  80148f:	ff 35 00 40 80 00    	pushl  0x804000
  801495:	e8 1b 07 00 00       	call   801bb5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80149a:	83 c4 0c             	add    $0xc,%esp
  80149d:	6a 00                	push   $0x0
  80149f:	53                   	push   %ebx
  8014a0:	6a 00                	push   $0x0
  8014a2:	e8 f7 06 00 00       	call   801b9e <ipc_recv>
}
  8014a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014aa:	5b                   	pop    %ebx
  8014ab:	5e                   	pop    %esi
  8014ac:	5d                   	pop    %ebp
  8014ad:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014ae:	83 ec 0c             	sub    $0xc,%esp
  8014b1:	6a 01                	push   $0x1
  8014b3:	e8 14 07 00 00       	call   801bcc <ipc_find_env>
  8014b8:	a3 00 40 80 00       	mov    %eax,0x804000
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	eb c5                	jmp    801487 <fsipc+0x12>

008014c2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ce:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d6:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014db:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e0:	b8 02 00 00 00       	mov    $0x2,%eax
  8014e5:	e8 8b ff ff ff       	call   801475 <fsipc>
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <devfile_flush>:
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8014f8:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801502:	b8 06 00 00 00       	mov    $0x6,%eax
  801507:	e8 69 ff ff ff       	call   801475 <fsipc>
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <devfile_stat>:
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	53                   	push   %ebx
  801512:	83 ec 04             	sub    $0x4,%esp
  801515:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	8b 40 0c             	mov    0xc(%eax),%eax
  80151e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801523:	ba 00 00 00 00       	mov    $0x0,%edx
  801528:	b8 05 00 00 00       	mov    $0x5,%eax
  80152d:	e8 43 ff ff ff       	call   801475 <fsipc>
  801532:	85 c0                	test   %eax,%eax
  801534:	78 2c                	js     801562 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801536:	83 ec 08             	sub    $0x8,%esp
  801539:	68 00 50 80 00       	push   $0x805000
  80153e:	53                   	push   %ebx
  80153f:	e8 b5 f3 ff ff       	call   8008f9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801544:	a1 80 50 80 00       	mov    0x805080,%eax
  801549:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80154f:	a1 84 50 80 00       	mov    0x805084,%eax
  801554:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <devfile_write>:
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	8b 45 10             	mov    0x10(%ebp),%eax
  801570:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801575:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80157a:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80157d:	8b 55 08             	mov    0x8(%ebp),%edx
  801580:	8b 52 0c             	mov    0xc(%edx),%edx
  801583:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801589:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  80158e:	50                   	push   %eax
  80158f:	ff 75 0c             	pushl  0xc(%ebp)
  801592:	68 08 50 80 00       	push   $0x805008
  801597:	e8 eb f4 ff ff       	call   800a87 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80159c:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a1:	b8 04 00 00 00       	mov    $0x4,%eax
  8015a6:	e8 ca fe ff ff       	call   801475 <fsipc>
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <devfile_read>:
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	56                   	push   %esi
  8015b1:	53                   	push   %ebx
  8015b2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8015bb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015c0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cb:	b8 03 00 00 00       	mov    $0x3,%eax
  8015d0:	e8 a0 fe ff ff       	call   801475 <fsipc>
  8015d5:	89 c3                	mov    %eax,%ebx
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	78 1f                	js     8015fa <devfile_read+0x4d>
	assert(r <= n);
  8015db:	39 f0                	cmp    %esi,%eax
  8015dd:	77 24                	ja     801603 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015df:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015e4:	7f 33                	jg     801619 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015e6:	83 ec 04             	sub    $0x4,%esp
  8015e9:	50                   	push   %eax
  8015ea:	68 00 50 80 00       	push   $0x805000
  8015ef:	ff 75 0c             	pushl  0xc(%ebp)
  8015f2:	e8 90 f4 ff ff       	call   800a87 <memmove>
	return r;
  8015f7:	83 c4 10             	add    $0x10,%esp
}
  8015fa:	89 d8                	mov    %ebx,%eax
  8015fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ff:	5b                   	pop    %ebx
  801600:	5e                   	pop    %esi
  801601:	5d                   	pop    %ebp
  801602:	c3                   	ret    
	assert(r <= n);
  801603:	68 fc 22 80 00       	push   $0x8022fc
  801608:	68 03 23 80 00       	push   $0x802303
  80160d:	6a 7c                	push   $0x7c
  80160f:	68 18 23 80 00       	push   $0x802318
  801614:	e8 1b ec ff ff       	call   800234 <_panic>
	assert(r <= PGSIZE);
  801619:	68 23 23 80 00       	push   $0x802323
  80161e:	68 03 23 80 00       	push   $0x802303
  801623:	6a 7d                	push   $0x7d
  801625:	68 18 23 80 00       	push   $0x802318
  80162a:	e8 05 ec ff ff       	call   800234 <_panic>

0080162f <open>:
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	56                   	push   %esi
  801633:	53                   	push   %ebx
  801634:	83 ec 1c             	sub    $0x1c,%esp
  801637:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80163a:	56                   	push   %esi
  80163b:	e8 82 f2 ff ff       	call   8008c2 <strlen>
  801640:	83 c4 10             	add    $0x10,%esp
  801643:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801648:	7f 6c                	jg     8016b6 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80164a:	83 ec 0c             	sub    $0xc,%esp
  80164d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801650:	50                   	push   %eax
  801651:	e8 b4 f8 ff ff       	call   800f0a <fd_alloc>
  801656:	89 c3                	mov    %eax,%ebx
  801658:	83 c4 10             	add    $0x10,%esp
  80165b:	85 c0                	test   %eax,%eax
  80165d:	78 3c                	js     80169b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80165f:	83 ec 08             	sub    $0x8,%esp
  801662:	56                   	push   %esi
  801663:	68 00 50 80 00       	push   $0x805000
  801668:	e8 8c f2 ff ff       	call   8008f9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80166d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801670:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801675:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801678:	b8 01 00 00 00       	mov    $0x1,%eax
  80167d:	e8 f3 fd ff ff       	call   801475 <fsipc>
  801682:	89 c3                	mov    %eax,%ebx
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	78 19                	js     8016a4 <open+0x75>
	return fd2num(fd);
  80168b:	83 ec 0c             	sub    $0xc,%esp
  80168e:	ff 75 f4             	pushl  -0xc(%ebp)
  801691:	e8 4d f8 ff ff       	call   800ee3 <fd2num>
  801696:	89 c3                	mov    %eax,%ebx
  801698:	83 c4 10             	add    $0x10,%esp
}
  80169b:	89 d8                	mov    %ebx,%eax
  80169d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a0:	5b                   	pop    %ebx
  8016a1:	5e                   	pop    %esi
  8016a2:	5d                   	pop    %ebp
  8016a3:	c3                   	ret    
		fd_close(fd, 0);
  8016a4:	83 ec 08             	sub    $0x8,%esp
  8016a7:	6a 00                	push   $0x0
  8016a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8016ac:	e8 54 f9 ff ff       	call   801005 <fd_close>
		return r;
  8016b1:	83 c4 10             	add    $0x10,%esp
  8016b4:	eb e5                	jmp    80169b <open+0x6c>
		return -E_BAD_PATH;
  8016b6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016bb:	eb de                	jmp    80169b <open+0x6c>

008016bd <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8016cd:	e8 a3 fd ff ff       	call   801475 <fsipc>
}
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	56                   	push   %esi
  8016d8:	53                   	push   %ebx
  8016d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8016dc:	83 ec 0c             	sub    $0xc,%esp
  8016df:	ff 75 08             	pushl  0x8(%ebp)
  8016e2:	e8 0c f8 ff ff       	call   800ef3 <fd2data>
  8016e7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8016e9:	83 c4 08             	add    $0x8,%esp
  8016ec:	68 2f 23 80 00       	push   $0x80232f
  8016f1:	53                   	push   %ebx
  8016f2:	e8 02 f2 ff ff       	call   8008f9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8016f7:	8b 46 04             	mov    0x4(%esi),%eax
  8016fa:	2b 06                	sub    (%esi),%eax
  8016fc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801702:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801709:	00 00 00 
	stat->st_dev = &devpipe;
  80170c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801713:	30 80 00 
	return 0;
}
  801716:	b8 00 00 00 00       	mov    $0x0,%eax
  80171b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80171e:	5b                   	pop    %ebx
  80171f:	5e                   	pop    %esi
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    

00801722 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	53                   	push   %ebx
  801726:	83 ec 0c             	sub    $0xc,%esp
  801729:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80172c:	53                   	push   %ebx
  80172d:	6a 00                	push   $0x0
  80172f:	e8 43 f6 ff ff       	call   800d77 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801734:	89 1c 24             	mov    %ebx,(%esp)
  801737:	e8 b7 f7 ff ff       	call   800ef3 <fd2data>
  80173c:	83 c4 08             	add    $0x8,%esp
  80173f:	50                   	push   %eax
  801740:	6a 00                	push   $0x0
  801742:	e8 30 f6 ff ff       	call   800d77 <sys_page_unmap>
}
  801747:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <_pipeisclosed>:
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	57                   	push   %edi
  801750:	56                   	push   %esi
  801751:	53                   	push   %ebx
  801752:	83 ec 1c             	sub    $0x1c,%esp
  801755:	89 c7                	mov    %eax,%edi
  801757:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801759:	a1 04 40 80 00       	mov    0x804004,%eax
  80175e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801761:	83 ec 0c             	sub    $0xc,%esp
  801764:	57                   	push   %edi
  801765:	e8 9b 04 00 00       	call   801c05 <pageref>
  80176a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80176d:	89 34 24             	mov    %esi,(%esp)
  801770:	e8 90 04 00 00       	call   801c05 <pageref>
		nn = thisenv->env_runs;
  801775:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80177b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	39 cb                	cmp    %ecx,%ebx
  801783:	74 1b                	je     8017a0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801785:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801788:	75 cf                	jne    801759 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80178a:	8b 42 58             	mov    0x58(%edx),%eax
  80178d:	6a 01                	push   $0x1
  80178f:	50                   	push   %eax
  801790:	53                   	push   %ebx
  801791:	68 36 23 80 00       	push   $0x802336
  801796:	e8 74 eb ff ff       	call   80030f <cprintf>
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	eb b9                	jmp    801759 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8017a0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017a3:	0f 94 c0             	sete   %al
  8017a6:	0f b6 c0             	movzbl %al,%eax
}
  8017a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ac:	5b                   	pop    %ebx
  8017ad:	5e                   	pop    %esi
  8017ae:	5f                   	pop    %edi
  8017af:	5d                   	pop    %ebp
  8017b0:	c3                   	ret    

008017b1 <devpipe_write>:
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	57                   	push   %edi
  8017b5:	56                   	push   %esi
  8017b6:	53                   	push   %ebx
  8017b7:	83 ec 28             	sub    $0x28,%esp
  8017ba:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8017bd:	56                   	push   %esi
  8017be:	e8 30 f7 ff ff       	call   800ef3 <fd2data>
  8017c3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017c5:	83 c4 10             	add    $0x10,%esp
  8017c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8017cd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8017d0:	74 4f                	je     801821 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017d2:	8b 43 04             	mov    0x4(%ebx),%eax
  8017d5:	8b 0b                	mov    (%ebx),%ecx
  8017d7:	8d 51 20             	lea    0x20(%ecx),%edx
  8017da:	39 d0                	cmp    %edx,%eax
  8017dc:	72 14                	jb     8017f2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8017de:	89 da                	mov    %ebx,%edx
  8017e0:	89 f0                	mov    %esi,%eax
  8017e2:	e8 65 ff ff ff       	call   80174c <_pipeisclosed>
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	75 3a                	jne    801825 <devpipe_write+0x74>
			sys_yield();
  8017eb:	e8 e3 f4 ff ff       	call   800cd3 <sys_yield>
  8017f0:	eb e0                	jmp    8017d2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8017f9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8017fc:	89 c2                	mov    %eax,%edx
  8017fe:	c1 fa 1f             	sar    $0x1f,%edx
  801801:	89 d1                	mov    %edx,%ecx
  801803:	c1 e9 1b             	shr    $0x1b,%ecx
  801806:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801809:	83 e2 1f             	and    $0x1f,%edx
  80180c:	29 ca                	sub    %ecx,%edx
  80180e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801812:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801816:	83 c0 01             	add    $0x1,%eax
  801819:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80181c:	83 c7 01             	add    $0x1,%edi
  80181f:	eb ac                	jmp    8017cd <devpipe_write+0x1c>
	return i;
  801821:	89 f8                	mov    %edi,%eax
  801823:	eb 05                	jmp    80182a <devpipe_write+0x79>
				return 0;
  801825:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80182d:	5b                   	pop    %ebx
  80182e:	5e                   	pop    %esi
  80182f:	5f                   	pop    %edi
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    

00801832 <devpipe_read>:
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	57                   	push   %edi
  801836:	56                   	push   %esi
  801837:	53                   	push   %ebx
  801838:	83 ec 18             	sub    $0x18,%esp
  80183b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80183e:	57                   	push   %edi
  80183f:	e8 af f6 ff ff       	call   800ef3 <fd2data>
  801844:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	be 00 00 00 00       	mov    $0x0,%esi
  80184e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801851:	74 47                	je     80189a <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801853:	8b 03                	mov    (%ebx),%eax
  801855:	3b 43 04             	cmp    0x4(%ebx),%eax
  801858:	75 22                	jne    80187c <devpipe_read+0x4a>
			if (i > 0)
  80185a:	85 f6                	test   %esi,%esi
  80185c:	75 14                	jne    801872 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80185e:	89 da                	mov    %ebx,%edx
  801860:	89 f8                	mov    %edi,%eax
  801862:	e8 e5 fe ff ff       	call   80174c <_pipeisclosed>
  801867:	85 c0                	test   %eax,%eax
  801869:	75 33                	jne    80189e <devpipe_read+0x6c>
			sys_yield();
  80186b:	e8 63 f4 ff ff       	call   800cd3 <sys_yield>
  801870:	eb e1                	jmp    801853 <devpipe_read+0x21>
				return i;
  801872:	89 f0                	mov    %esi,%eax
}
  801874:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801877:	5b                   	pop    %ebx
  801878:	5e                   	pop    %esi
  801879:	5f                   	pop    %edi
  80187a:	5d                   	pop    %ebp
  80187b:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80187c:	99                   	cltd   
  80187d:	c1 ea 1b             	shr    $0x1b,%edx
  801880:	01 d0                	add    %edx,%eax
  801882:	83 e0 1f             	and    $0x1f,%eax
  801885:	29 d0                	sub    %edx,%eax
  801887:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80188c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80188f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801892:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801895:	83 c6 01             	add    $0x1,%esi
  801898:	eb b4                	jmp    80184e <devpipe_read+0x1c>
	return i;
  80189a:	89 f0                	mov    %esi,%eax
  80189c:	eb d6                	jmp    801874 <devpipe_read+0x42>
				return 0;
  80189e:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a3:	eb cf                	jmp    801874 <devpipe_read+0x42>

008018a5 <pipe>:
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	56                   	push   %esi
  8018a9:	53                   	push   %ebx
  8018aa:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8018ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b0:	50                   	push   %eax
  8018b1:	e8 54 f6 ff ff       	call   800f0a <fd_alloc>
  8018b6:	89 c3                	mov    %eax,%ebx
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 5b                	js     80191a <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	68 07 04 00 00       	push   $0x407
  8018c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ca:	6a 00                	push   $0x0
  8018cc:	e8 21 f4 ff ff       	call   800cf2 <sys_page_alloc>
  8018d1:	89 c3                	mov    %eax,%ebx
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	78 40                	js     80191a <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e0:	50                   	push   %eax
  8018e1:	e8 24 f6 ff ff       	call   800f0a <fd_alloc>
  8018e6:	89 c3                	mov    %eax,%ebx
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	78 1b                	js     80190a <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018ef:	83 ec 04             	sub    $0x4,%esp
  8018f2:	68 07 04 00 00       	push   $0x407
  8018f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8018fa:	6a 00                	push   $0x0
  8018fc:	e8 f1 f3 ff ff       	call   800cf2 <sys_page_alloc>
  801901:	89 c3                	mov    %eax,%ebx
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	85 c0                	test   %eax,%eax
  801908:	79 19                	jns    801923 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80190a:	83 ec 08             	sub    $0x8,%esp
  80190d:	ff 75 f4             	pushl  -0xc(%ebp)
  801910:	6a 00                	push   $0x0
  801912:	e8 60 f4 ff ff       	call   800d77 <sys_page_unmap>
  801917:	83 c4 10             	add    $0x10,%esp
}
  80191a:	89 d8                	mov    %ebx,%eax
  80191c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191f:	5b                   	pop    %ebx
  801920:	5e                   	pop    %esi
  801921:	5d                   	pop    %ebp
  801922:	c3                   	ret    
	va = fd2data(fd0);
  801923:	83 ec 0c             	sub    $0xc,%esp
  801926:	ff 75 f4             	pushl  -0xc(%ebp)
  801929:	e8 c5 f5 ff ff       	call   800ef3 <fd2data>
  80192e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801930:	83 c4 0c             	add    $0xc,%esp
  801933:	68 07 04 00 00       	push   $0x407
  801938:	50                   	push   %eax
  801939:	6a 00                	push   $0x0
  80193b:	e8 b2 f3 ff ff       	call   800cf2 <sys_page_alloc>
  801940:	89 c3                	mov    %eax,%ebx
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	85 c0                	test   %eax,%eax
  801947:	0f 88 8c 00 00 00    	js     8019d9 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80194d:	83 ec 0c             	sub    $0xc,%esp
  801950:	ff 75 f0             	pushl  -0x10(%ebp)
  801953:	e8 9b f5 ff ff       	call   800ef3 <fd2data>
  801958:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80195f:	50                   	push   %eax
  801960:	6a 00                	push   $0x0
  801962:	56                   	push   %esi
  801963:	6a 00                	push   $0x0
  801965:	e8 cb f3 ff ff       	call   800d35 <sys_page_map>
  80196a:	89 c3                	mov    %eax,%ebx
  80196c:	83 c4 20             	add    $0x20,%esp
  80196f:	85 c0                	test   %eax,%eax
  801971:	78 58                	js     8019cb <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801976:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80197c:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80197e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801981:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801991:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801996:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80199d:	83 ec 0c             	sub    $0xc,%esp
  8019a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a3:	e8 3b f5 ff ff       	call   800ee3 <fd2num>
  8019a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ab:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8019ad:	83 c4 04             	add    $0x4,%esp
  8019b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8019b3:	e8 2b f5 ff ff       	call   800ee3 <fd2num>
  8019b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019bb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019c6:	e9 4f ff ff ff       	jmp    80191a <pipe+0x75>
	sys_page_unmap(0, va);
  8019cb:	83 ec 08             	sub    $0x8,%esp
  8019ce:	56                   	push   %esi
  8019cf:	6a 00                	push   $0x0
  8019d1:	e8 a1 f3 ff ff       	call   800d77 <sys_page_unmap>
  8019d6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8019d9:	83 ec 08             	sub    $0x8,%esp
  8019dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8019df:	6a 00                	push   $0x0
  8019e1:	e8 91 f3 ff ff       	call   800d77 <sys_page_unmap>
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	e9 1c ff ff ff       	jmp    80190a <pipe+0x65>

008019ee <pipeisclosed>:
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f7:	50                   	push   %eax
  8019f8:	ff 75 08             	pushl  0x8(%ebp)
  8019fb:	e8 59 f5 ff ff       	call   800f59 <fd_lookup>
  801a00:	83 c4 10             	add    $0x10,%esp
  801a03:	85 c0                	test   %eax,%eax
  801a05:	78 18                	js     801a1f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801a07:	83 ec 0c             	sub    $0xc,%esp
  801a0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a0d:	e8 e1 f4 ff ff       	call   800ef3 <fd2data>
	return _pipeisclosed(fd, p);
  801a12:	89 c2                	mov    %eax,%edx
  801a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a17:	e8 30 fd ff ff       	call   80174c <_pipeisclosed>
  801a1c:	83 c4 10             	add    $0x10,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801a24:	b8 00 00 00 00       	mov    $0x0,%eax
  801a29:	5d                   	pop    %ebp
  801a2a:	c3                   	ret    

00801a2b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801a31:	68 4e 23 80 00       	push   $0x80234e
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	e8 bb ee ff ff       	call   8008f9 <strcpy>
	return 0;
}
  801a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <devcons_write>:
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	57                   	push   %edi
  801a49:	56                   	push   %esi
  801a4a:	53                   	push   %ebx
  801a4b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801a51:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801a56:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801a5c:	eb 2f                	jmp    801a8d <devcons_write+0x48>
		m = n - tot;
  801a5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a61:	29 f3                	sub    %esi,%ebx
  801a63:	83 fb 7f             	cmp    $0x7f,%ebx
  801a66:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801a6b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	53                   	push   %ebx
  801a72:	89 f0                	mov    %esi,%eax
  801a74:	03 45 0c             	add    0xc(%ebp),%eax
  801a77:	50                   	push   %eax
  801a78:	57                   	push   %edi
  801a79:	e8 09 f0 ff ff       	call   800a87 <memmove>
		sys_cputs(buf, m);
  801a7e:	83 c4 08             	add    $0x8,%esp
  801a81:	53                   	push   %ebx
  801a82:	57                   	push   %edi
  801a83:	e8 ae f1 ff ff       	call   800c36 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801a88:	01 de                	add    %ebx,%esi
  801a8a:	83 c4 10             	add    $0x10,%esp
  801a8d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a90:	72 cc                	jb     801a5e <devcons_write+0x19>
}
  801a92:	89 f0                	mov    %esi,%eax
  801a94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a97:	5b                   	pop    %ebx
  801a98:	5e                   	pop    %esi
  801a99:	5f                   	pop    %edi
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    

00801a9c <devcons_read>:
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 08             	sub    $0x8,%esp
  801aa2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801aa7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801aab:	75 07                	jne    801ab4 <devcons_read+0x18>
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    
		sys_yield();
  801aaf:	e8 1f f2 ff ff       	call   800cd3 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801ab4:	e8 9b f1 ff ff       	call   800c54 <sys_cgetc>
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	74 f2                	je     801aaf <devcons_read+0x13>
	if (c < 0)
  801abd:	85 c0                	test   %eax,%eax
  801abf:	78 ec                	js     801aad <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801ac1:	83 f8 04             	cmp    $0x4,%eax
  801ac4:	74 0c                	je     801ad2 <devcons_read+0x36>
	*(char*)vbuf = c;
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	88 02                	mov    %al,(%edx)
	return 1;
  801acb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad0:	eb db                	jmp    801aad <devcons_read+0x11>
		return 0;
  801ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad7:	eb d4                	jmp    801aad <devcons_read+0x11>

00801ad9 <cputchar>:
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ae5:	6a 01                	push   $0x1
  801ae7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801aea:	50                   	push   %eax
  801aeb:	e8 46 f1 ff ff       	call   800c36 <sys_cputs>
}
  801af0:	83 c4 10             	add    $0x10,%esp
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <getchar>:
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801afb:	6a 01                	push   $0x1
  801afd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b00:	50                   	push   %eax
  801b01:	6a 00                	push   $0x0
  801b03:	e8 c2 f6 ff ff       	call   8011ca <read>
	if (r < 0)
  801b08:	83 c4 10             	add    $0x10,%esp
  801b0b:	85 c0                	test   %eax,%eax
  801b0d:	78 08                	js     801b17 <getchar+0x22>
	if (r < 1)
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	7e 06                	jle    801b19 <getchar+0x24>
	return c;
  801b13:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    
		return -E_EOF;
  801b19:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801b1e:	eb f7                	jmp    801b17 <getchar+0x22>

00801b20 <iscons>:
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b29:	50                   	push   %eax
  801b2a:	ff 75 08             	pushl  0x8(%ebp)
  801b2d:	e8 27 f4 ff ff       	call   800f59 <fd_lookup>
  801b32:	83 c4 10             	add    $0x10,%esp
  801b35:	85 c0                	test   %eax,%eax
  801b37:	78 11                	js     801b4a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b42:	39 10                	cmp    %edx,(%eax)
  801b44:	0f 94 c0             	sete   %al
  801b47:	0f b6 c0             	movzbl %al,%eax
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <opencons>:
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801b52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b55:	50                   	push   %eax
  801b56:	e8 af f3 ff ff       	call   800f0a <fd_alloc>
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	78 3a                	js     801b9c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b62:	83 ec 04             	sub    $0x4,%esp
  801b65:	68 07 04 00 00       	push   $0x407
  801b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b6d:	6a 00                	push   $0x0
  801b6f:	e8 7e f1 ff ff       	call   800cf2 <sys_page_alloc>
  801b74:	83 c4 10             	add    $0x10,%esp
  801b77:	85 c0                	test   %eax,%eax
  801b79:	78 21                	js     801b9c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b84:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b89:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801b90:	83 ec 0c             	sub    $0xc,%esp
  801b93:	50                   	push   %eax
  801b94:	e8 4a f3 ff ff       	call   800ee3 <fd2num>
  801b99:	83 c4 10             	add    $0x10,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801ba4:	68 5a 23 80 00       	push   $0x80235a
  801ba9:	6a 1a                	push   $0x1a
  801bab:	68 73 23 80 00       	push   $0x802373
  801bb0:	e8 7f e6 ff ff       	call   800234 <_panic>

00801bb5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801bbb:	68 7d 23 80 00       	push   $0x80237d
  801bc0:	6a 2a                	push   $0x2a
  801bc2:	68 73 23 80 00       	push   $0x802373
  801bc7:	e8 68 e6 ff ff       	call   800234 <_panic>

00801bcc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801bd2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801bd7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801bda:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801be0:	8b 52 50             	mov    0x50(%edx),%edx
  801be3:	39 ca                	cmp    %ecx,%edx
  801be5:	74 11                	je     801bf8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801be7:	83 c0 01             	add    $0x1,%eax
  801bea:	3d 00 04 00 00       	cmp    $0x400,%eax
  801bef:	75 e6                	jne    801bd7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf6:	eb 0b                	jmp    801c03 <ipc_find_env+0x37>
			return envs[i].env_id;
  801bf8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801bfb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c00:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    

00801c05 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c0b:	89 d0                	mov    %edx,%eax
  801c0d:	c1 e8 16             	shr    $0x16,%eax
  801c10:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801c17:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801c1c:	f6 c1 01             	test   $0x1,%cl
  801c1f:	74 1d                	je     801c3e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801c21:	c1 ea 0c             	shr    $0xc,%edx
  801c24:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801c2b:	f6 c2 01             	test   $0x1,%dl
  801c2e:	74 0e                	je     801c3e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c30:	c1 ea 0c             	shr    $0xc,%edx
  801c33:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801c3a:	ef 
  801c3b:	0f b7 c0             	movzwl %ax,%eax
}
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    

00801c40 <__udivdi3>:
  801c40:	55                   	push   %ebp
  801c41:	57                   	push   %edi
  801c42:	56                   	push   %esi
  801c43:	53                   	push   %ebx
  801c44:	83 ec 1c             	sub    $0x1c,%esp
  801c47:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801c4b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801c4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c53:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801c57:	85 d2                	test   %edx,%edx
  801c59:	75 35                	jne    801c90 <__udivdi3+0x50>
  801c5b:	39 f3                	cmp    %esi,%ebx
  801c5d:	0f 87 bd 00 00 00    	ja     801d20 <__udivdi3+0xe0>
  801c63:	85 db                	test   %ebx,%ebx
  801c65:	89 d9                	mov    %ebx,%ecx
  801c67:	75 0b                	jne    801c74 <__udivdi3+0x34>
  801c69:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6e:	31 d2                	xor    %edx,%edx
  801c70:	f7 f3                	div    %ebx
  801c72:	89 c1                	mov    %eax,%ecx
  801c74:	31 d2                	xor    %edx,%edx
  801c76:	89 f0                	mov    %esi,%eax
  801c78:	f7 f1                	div    %ecx
  801c7a:	89 c6                	mov    %eax,%esi
  801c7c:	89 e8                	mov    %ebp,%eax
  801c7e:	89 f7                	mov    %esi,%edi
  801c80:	f7 f1                	div    %ecx
  801c82:	89 fa                	mov    %edi,%edx
  801c84:	83 c4 1c             	add    $0x1c,%esp
  801c87:	5b                   	pop    %ebx
  801c88:	5e                   	pop    %esi
  801c89:	5f                   	pop    %edi
  801c8a:	5d                   	pop    %ebp
  801c8b:	c3                   	ret    
  801c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801c90:	39 f2                	cmp    %esi,%edx
  801c92:	77 7c                	ja     801d10 <__udivdi3+0xd0>
  801c94:	0f bd fa             	bsr    %edx,%edi
  801c97:	83 f7 1f             	xor    $0x1f,%edi
  801c9a:	0f 84 98 00 00 00    	je     801d38 <__udivdi3+0xf8>
  801ca0:	89 f9                	mov    %edi,%ecx
  801ca2:	b8 20 00 00 00       	mov    $0x20,%eax
  801ca7:	29 f8                	sub    %edi,%eax
  801ca9:	d3 e2                	shl    %cl,%edx
  801cab:	89 54 24 08          	mov    %edx,0x8(%esp)
  801caf:	89 c1                	mov    %eax,%ecx
  801cb1:	89 da                	mov    %ebx,%edx
  801cb3:	d3 ea                	shr    %cl,%edx
  801cb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801cb9:	09 d1                	or     %edx,%ecx
  801cbb:	89 f2                	mov    %esi,%edx
  801cbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cc1:	89 f9                	mov    %edi,%ecx
  801cc3:	d3 e3                	shl    %cl,%ebx
  801cc5:	89 c1                	mov    %eax,%ecx
  801cc7:	d3 ea                	shr    %cl,%edx
  801cc9:	89 f9                	mov    %edi,%ecx
  801ccb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801ccf:	d3 e6                	shl    %cl,%esi
  801cd1:	89 eb                	mov    %ebp,%ebx
  801cd3:	89 c1                	mov    %eax,%ecx
  801cd5:	d3 eb                	shr    %cl,%ebx
  801cd7:	09 de                	or     %ebx,%esi
  801cd9:	89 f0                	mov    %esi,%eax
  801cdb:	f7 74 24 08          	divl   0x8(%esp)
  801cdf:	89 d6                	mov    %edx,%esi
  801ce1:	89 c3                	mov    %eax,%ebx
  801ce3:	f7 64 24 0c          	mull   0xc(%esp)
  801ce7:	39 d6                	cmp    %edx,%esi
  801ce9:	72 0c                	jb     801cf7 <__udivdi3+0xb7>
  801ceb:	89 f9                	mov    %edi,%ecx
  801ced:	d3 e5                	shl    %cl,%ebp
  801cef:	39 c5                	cmp    %eax,%ebp
  801cf1:	73 5d                	jae    801d50 <__udivdi3+0x110>
  801cf3:	39 d6                	cmp    %edx,%esi
  801cf5:	75 59                	jne    801d50 <__udivdi3+0x110>
  801cf7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cfa:	31 ff                	xor    %edi,%edi
  801cfc:	89 fa                	mov    %edi,%edx
  801cfe:	83 c4 1c             	add    $0x1c,%esp
  801d01:	5b                   	pop    %ebx
  801d02:	5e                   	pop    %esi
  801d03:	5f                   	pop    %edi
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    
  801d06:	8d 76 00             	lea    0x0(%esi),%esi
  801d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801d10:	31 ff                	xor    %edi,%edi
  801d12:	31 c0                	xor    %eax,%eax
  801d14:	89 fa                	mov    %edi,%edx
  801d16:	83 c4 1c             	add    $0x1c,%esp
  801d19:	5b                   	pop    %ebx
  801d1a:	5e                   	pop    %esi
  801d1b:	5f                   	pop    %edi
  801d1c:	5d                   	pop    %ebp
  801d1d:	c3                   	ret    
  801d1e:	66 90                	xchg   %ax,%ax
  801d20:	31 ff                	xor    %edi,%edi
  801d22:	89 e8                	mov    %ebp,%eax
  801d24:	89 f2                	mov    %esi,%edx
  801d26:	f7 f3                	div    %ebx
  801d28:	89 fa                	mov    %edi,%edx
  801d2a:	83 c4 1c             	add    $0x1c,%esp
  801d2d:	5b                   	pop    %ebx
  801d2e:	5e                   	pop    %esi
  801d2f:	5f                   	pop    %edi
  801d30:	5d                   	pop    %ebp
  801d31:	c3                   	ret    
  801d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801d38:	39 f2                	cmp    %esi,%edx
  801d3a:	72 06                	jb     801d42 <__udivdi3+0x102>
  801d3c:	31 c0                	xor    %eax,%eax
  801d3e:	39 eb                	cmp    %ebp,%ebx
  801d40:	77 d2                	ja     801d14 <__udivdi3+0xd4>
  801d42:	b8 01 00 00 00       	mov    $0x1,%eax
  801d47:	eb cb                	jmp    801d14 <__udivdi3+0xd4>
  801d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d50:	89 d8                	mov    %ebx,%eax
  801d52:	31 ff                	xor    %edi,%edi
  801d54:	eb be                	jmp    801d14 <__udivdi3+0xd4>
  801d56:	66 90                	xchg   %ax,%ax
  801d58:	66 90                	xchg   %ax,%ax
  801d5a:	66 90                	xchg   %ax,%ax
  801d5c:	66 90                	xchg   %ax,%ax
  801d5e:	66 90                	xchg   %ax,%ax

00801d60 <__umoddi3>:
  801d60:	55                   	push   %ebp
  801d61:	57                   	push   %edi
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
  801d64:	83 ec 1c             	sub    $0x1c,%esp
  801d67:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801d6b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801d6f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801d73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d77:	85 ed                	test   %ebp,%ebp
  801d79:	89 f0                	mov    %esi,%eax
  801d7b:	89 da                	mov    %ebx,%edx
  801d7d:	75 19                	jne    801d98 <__umoddi3+0x38>
  801d7f:	39 df                	cmp    %ebx,%edi
  801d81:	0f 86 b1 00 00 00    	jbe    801e38 <__umoddi3+0xd8>
  801d87:	f7 f7                	div    %edi
  801d89:	89 d0                	mov    %edx,%eax
  801d8b:	31 d2                	xor    %edx,%edx
  801d8d:	83 c4 1c             	add    $0x1c,%esp
  801d90:	5b                   	pop    %ebx
  801d91:	5e                   	pop    %esi
  801d92:	5f                   	pop    %edi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    
  801d95:	8d 76 00             	lea    0x0(%esi),%esi
  801d98:	39 dd                	cmp    %ebx,%ebp
  801d9a:	77 f1                	ja     801d8d <__umoddi3+0x2d>
  801d9c:	0f bd cd             	bsr    %ebp,%ecx
  801d9f:	83 f1 1f             	xor    $0x1f,%ecx
  801da2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801da6:	0f 84 b4 00 00 00    	je     801e60 <__umoddi3+0x100>
  801dac:	b8 20 00 00 00       	mov    $0x20,%eax
  801db1:	89 c2                	mov    %eax,%edx
  801db3:	8b 44 24 04          	mov    0x4(%esp),%eax
  801db7:	29 c2                	sub    %eax,%edx
  801db9:	89 c1                	mov    %eax,%ecx
  801dbb:	89 f8                	mov    %edi,%eax
  801dbd:	d3 e5                	shl    %cl,%ebp
  801dbf:	89 d1                	mov    %edx,%ecx
  801dc1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801dc5:	d3 e8                	shr    %cl,%eax
  801dc7:	09 c5                	or     %eax,%ebp
  801dc9:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dcd:	89 c1                	mov    %eax,%ecx
  801dcf:	d3 e7                	shl    %cl,%edi
  801dd1:	89 d1                	mov    %edx,%ecx
  801dd3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801dd7:	89 df                	mov    %ebx,%edi
  801dd9:	d3 ef                	shr    %cl,%edi
  801ddb:	89 c1                	mov    %eax,%ecx
  801ddd:	89 f0                	mov    %esi,%eax
  801ddf:	d3 e3                	shl    %cl,%ebx
  801de1:	89 d1                	mov    %edx,%ecx
  801de3:	89 fa                	mov    %edi,%edx
  801de5:	d3 e8                	shr    %cl,%eax
  801de7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801dec:	09 d8                	or     %ebx,%eax
  801dee:	f7 f5                	div    %ebp
  801df0:	d3 e6                	shl    %cl,%esi
  801df2:	89 d1                	mov    %edx,%ecx
  801df4:	f7 64 24 08          	mull   0x8(%esp)
  801df8:	39 d1                	cmp    %edx,%ecx
  801dfa:	89 c3                	mov    %eax,%ebx
  801dfc:	89 d7                	mov    %edx,%edi
  801dfe:	72 06                	jb     801e06 <__umoddi3+0xa6>
  801e00:	75 0e                	jne    801e10 <__umoddi3+0xb0>
  801e02:	39 c6                	cmp    %eax,%esi
  801e04:	73 0a                	jae    801e10 <__umoddi3+0xb0>
  801e06:	2b 44 24 08          	sub    0x8(%esp),%eax
  801e0a:	19 ea                	sbb    %ebp,%edx
  801e0c:	89 d7                	mov    %edx,%edi
  801e0e:	89 c3                	mov    %eax,%ebx
  801e10:	89 ca                	mov    %ecx,%edx
  801e12:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801e17:	29 de                	sub    %ebx,%esi
  801e19:	19 fa                	sbb    %edi,%edx
  801e1b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801e1f:	89 d0                	mov    %edx,%eax
  801e21:	d3 e0                	shl    %cl,%eax
  801e23:	89 d9                	mov    %ebx,%ecx
  801e25:	d3 ee                	shr    %cl,%esi
  801e27:	d3 ea                	shr    %cl,%edx
  801e29:	09 f0                	or     %esi,%eax
  801e2b:	83 c4 1c             	add    $0x1c,%esp
  801e2e:	5b                   	pop    %ebx
  801e2f:	5e                   	pop    %esi
  801e30:	5f                   	pop    %edi
  801e31:	5d                   	pop    %ebp
  801e32:	c3                   	ret    
  801e33:	90                   	nop
  801e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e38:	85 ff                	test   %edi,%edi
  801e3a:	89 f9                	mov    %edi,%ecx
  801e3c:	75 0b                	jne    801e49 <__umoddi3+0xe9>
  801e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e43:	31 d2                	xor    %edx,%edx
  801e45:	f7 f7                	div    %edi
  801e47:	89 c1                	mov    %eax,%ecx
  801e49:	89 d8                	mov    %ebx,%eax
  801e4b:	31 d2                	xor    %edx,%edx
  801e4d:	f7 f1                	div    %ecx
  801e4f:	89 f0                	mov    %esi,%eax
  801e51:	f7 f1                	div    %ecx
  801e53:	e9 31 ff ff ff       	jmp    801d89 <__umoddi3+0x29>
  801e58:	90                   	nop
  801e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e60:	39 dd                	cmp    %ebx,%ebp
  801e62:	72 08                	jb     801e6c <__umoddi3+0x10c>
  801e64:	39 f7                	cmp    %esi,%edi
  801e66:	0f 87 21 ff ff ff    	ja     801d8d <__umoddi3+0x2d>
  801e6c:	89 da                	mov    %ebx,%edx
  801e6e:	89 f0                	mov    %esi,%eax
  801e70:	29 f8                	sub    %edi,%eax
  801e72:	19 ea                	sbb    %ebp,%edx
  801e74:	e9 14 ff ff ff       	jmp    801d8d <__umoddi3+0x2d>
