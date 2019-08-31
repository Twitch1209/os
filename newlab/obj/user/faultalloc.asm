
obj/user/faultalloc.debug：     文件格式 elf32-i386


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
  80002c:	e8 99 00 00 00       	call   8000ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 20 1e 80 00       	push   $0x801e20
  800045:	e8 bb 01 00 00       	call   800205 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 8a 0b 00 00       	call   800be8 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 6c 1e 80 00       	push   $0x801e6c
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 2b 07 00 00       	call   80079e <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 40 1e 80 00       	push   $0x801e40
  800085:	6a 0e                	push   $0xe
  800087:	68 2a 1e 80 00       	push   $0x801e2a
  80008c:	e8 99 00 00 00       	call   80012a <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 38 0d 00 00       	call   800dd9 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 3c 1e 80 00       	push   $0x801e3c
  8000ae:	e8 52 01 00 00       	call   800205 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 3c 1e 80 00       	push   $0x801e3c
  8000c0:	e8 40 01 00 00       	call   800205 <cprintf>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000d5:	e8 d0 0a 00 00       	call   800baa <sys_getenvid>
  8000da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000df:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e7:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ec:	85 db                	test   %ebx,%ebx
  8000ee:	7e 07                	jle    8000f7 <libmain+0x2d>
		binaryname = argv[0];
  8000f0:	8b 06                	mov    (%esi),%eax
  8000f2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	e8 90 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  800101:	e8 0a 00 00 00       	call   800110 <exit>
}
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5d                   	pop    %ebp
  80010f:	c3                   	ret    

00800110 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800116:	e8 2f 0f 00 00       	call   80104a <close_all>
	sys_env_destroy(0);
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	6a 00                	push   $0x0
  800120:	e8 44 0a 00 00       	call   800b69 <sys_env_destroy>
}
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	c9                   	leave  
  800129:	c3                   	ret    

0080012a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	56                   	push   %esi
  80012e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80012f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800132:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800138:	e8 6d 0a 00 00       	call   800baa <sys_getenvid>
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 0c             	pushl  0xc(%ebp)
  800143:	ff 75 08             	pushl  0x8(%ebp)
  800146:	56                   	push   %esi
  800147:	50                   	push   %eax
  800148:	68 98 1e 80 00       	push   $0x801e98
  80014d:	e8 b3 00 00 00       	call   800205 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800152:	83 c4 18             	add    $0x18,%esp
  800155:	53                   	push   %ebx
  800156:	ff 75 10             	pushl  0x10(%ebp)
  800159:	e8 56 00 00 00       	call   8001b4 <vcprintf>
	cprintf("\n");
  80015e:	c7 04 24 e7 22 80 00 	movl   $0x8022e7,(%esp)
  800165:	e8 9b 00 00 00       	call   800205 <cprintf>
  80016a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80016d:	cc                   	int3   
  80016e:	eb fd                	jmp    80016d <_panic+0x43>

00800170 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	53                   	push   %ebx
  800174:	83 ec 04             	sub    $0x4,%esp
  800177:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017a:	8b 13                	mov    (%ebx),%edx
  80017c:	8d 42 01             	lea    0x1(%edx),%eax
  80017f:	89 03                	mov    %eax,(%ebx)
  800181:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800184:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800188:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018d:	74 09                	je     800198 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80018f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800193:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800196:	c9                   	leave  
  800197:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	68 ff 00 00 00       	push   $0xff
  8001a0:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a3:	50                   	push   %eax
  8001a4:	e8 83 09 00 00       	call   800b2c <sys_cputs>
		b->idx = 0;
  8001a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	eb db                	jmp    80018f <putch+0x1f>

008001b4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c4:	00 00 00 
	b.cnt = 0;
  8001c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ce:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d1:	ff 75 0c             	pushl  0xc(%ebp)
  8001d4:	ff 75 08             	pushl  0x8(%ebp)
  8001d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001dd:	50                   	push   %eax
  8001de:	68 70 01 80 00       	push   $0x800170
  8001e3:	e8 1a 01 00 00       	call   800302 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e8:	83 c4 08             	add    $0x8,%esp
  8001eb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f7:	50                   	push   %eax
  8001f8:	e8 2f 09 00 00       	call   800b2c <sys_cputs>

	return b.cnt;
}
  8001fd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020e:	50                   	push   %eax
  80020f:	ff 75 08             	pushl  0x8(%ebp)
  800212:	e8 9d ff ff ff       	call   8001b4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800217:	c9                   	leave  
  800218:	c3                   	ret    

00800219 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	57                   	push   %edi
  80021d:	56                   	push   %esi
  80021e:	53                   	push   %ebx
  80021f:	83 ec 1c             	sub    $0x1c,%esp
  800222:	89 c7                	mov    %eax,%edi
  800224:	89 d6                	mov    %edx,%esi
  800226:	8b 45 08             	mov    0x8(%ebp),%eax
  800229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800232:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800235:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80023d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800240:	39 d3                	cmp    %edx,%ebx
  800242:	72 05                	jb     800249 <printnum+0x30>
  800244:	39 45 10             	cmp    %eax,0x10(%ebp)
  800247:	77 7a                	ja     8002c3 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	ff 75 18             	pushl  0x18(%ebp)
  80024f:	8b 45 14             	mov    0x14(%ebp),%eax
  800252:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800255:	53                   	push   %ebx
  800256:	ff 75 10             	pushl  0x10(%ebp)
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025f:	ff 75 e0             	pushl  -0x20(%ebp)
  800262:	ff 75 dc             	pushl  -0x24(%ebp)
  800265:	ff 75 d8             	pushl  -0x28(%ebp)
  800268:	e8 73 19 00 00       	call   801be0 <__udivdi3>
  80026d:	83 c4 18             	add    $0x18,%esp
  800270:	52                   	push   %edx
  800271:	50                   	push   %eax
  800272:	89 f2                	mov    %esi,%edx
  800274:	89 f8                	mov    %edi,%eax
  800276:	e8 9e ff ff ff       	call   800219 <printnum>
  80027b:	83 c4 20             	add    $0x20,%esp
  80027e:	eb 13                	jmp    800293 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800280:	83 ec 08             	sub    $0x8,%esp
  800283:	56                   	push   %esi
  800284:	ff 75 18             	pushl  0x18(%ebp)
  800287:	ff d7                	call   *%edi
  800289:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80028c:	83 eb 01             	sub    $0x1,%ebx
  80028f:	85 db                	test   %ebx,%ebx
  800291:	7f ed                	jg     800280 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800293:	83 ec 08             	sub    $0x8,%esp
  800296:	56                   	push   %esi
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029d:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 55 1a 00 00       	call   801d00 <__umoddi3>
  8002ab:	83 c4 14             	add    $0x14,%esp
  8002ae:	0f be 80 bb 1e 80 00 	movsbl 0x801ebb(%eax),%eax
  8002b5:	50                   	push   %eax
  8002b6:	ff d7                	call   *%edi
}
  8002b8:	83 c4 10             	add    $0x10,%esp
  8002bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002be:	5b                   	pop    %ebx
  8002bf:	5e                   	pop    %esi
  8002c0:	5f                   	pop    %edi
  8002c1:	5d                   	pop    %ebp
  8002c2:	c3                   	ret    
  8002c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002c6:	eb c4                	jmp    80028c <printnum+0x73>

008002c8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ce:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d2:	8b 10                	mov    (%eax),%edx
  8002d4:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d7:	73 0a                	jae    8002e3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002dc:	89 08                	mov    %ecx,(%eax)
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	88 02                	mov    %al,(%edx)
}
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    

008002e5 <printfmt>:
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002eb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ee:	50                   	push   %eax
  8002ef:	ff 75 10             	pushl  0x10(%ebp)
  8002f2:	ff 75 0c             	pushl  0xc(%ebp)
  8002f5:	ff 75 08             	pushl  0x8(%ebp)
  8002f8:	e8 05 00 00 00       	call   800302 <vprintfmt>
}
  8002fd:	83 c4 10             	add    $0x10,%esp
  800300:	c9                   	leave  
  800301:	c3                   	ret    

00800302 <vprintfmt>:
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	57                   	push   %edi
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	83 ec 2c             	sub    $0x2c,%esp
  80030b:	8b 75 08             	mov    0x8(%ebp),%esi
  80030e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800311:	8b 7d 10             	mov    0x10(%ebp),%edi
  800314:	e9 8c 03 00 00       	jmp    8006a5 <vprintfmt+0x3a3>
		padc = ' ';
  800319:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80031d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800324:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80032b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800332:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800337:	8d 47 01             	lea    0x1(%edi),%eax
  80033a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033d:	0f b6 17             	movzbl (%edi),%edx
  800340:	8d 42 dd             	lea    -0x23(%edx),%eax
  800343:	3c 55                	cmp    $0x55,%al
  800345:	0f 87 dd 03 00 00    	ja     800728 <vprintfmt+0x426>
  80034b:	0f b6 c0             	movzbl %al,%eax
  80034e:	ff 24 85 00 20 80 00 	jmp    *0x802000(,%eax,4)
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800358:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80035c:	eb d9                	jmp    800337 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80035e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800361:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800365:	eb d0                	jmp    800337 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800367:	0f b6 d2             	movzbl %dl,%edx
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80036d:	b8 00 00 00 00       	mov    $0x0,%eax
  800372:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800375:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800378:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80037c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80037f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800382:	83 f9 09             	cmp    $0x9,%ecx
  800385:	77 55                	ja     8003dc <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800387:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038a:	eb e9                	jmp    800375 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80038c:	8b 45 14             	mov    0x14(%ebp),%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800394:	8b 45 14             	mov    0x14(%ebp),%eax
  800397:	8d 40 04             	lea    0x4(%eax),%eax
  80039a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a4:	79 91                	jns    800337 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ac:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b3:	eb 82                	jmp    800337 <vprintfmt+0x35>
  8003b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b8:	85 c0                	test   %eax,%eax
  8003ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bf:	0f 49 d0             	cmovns %eax,%edx
  8003c2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c8:	e9 6a ff ff ff       	jmp    800337 <vprintfmt+0x35>
  8003cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003d0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003d7:	e9 5b ff ff ff       	jmp    800337 <vprintfmt+0x35>
  8003dc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003e2:	eb bc                	jmp    8003a0 <vprintfmt+0x9e>
			lflag++;
  8003e4:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ea:	e9 48 ff ff ff       	jmp    800337 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f2:	8d 78 04             	lea    0x4(%eax),%edi
  8003f5:	83 ec 08             	sub    $0x8,%esp
  8003f8:	53                   	push   %ebx
  8003f9:	ff 30                	pushl  (%eax)
  8003fb:	ff d6                	call   *%esi
			break;
  8003fd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800400:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800403:	e9 9a 02 00 00       	jmp    8006a2 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800408:	8b 45 14             	mov    0x14(%ebp),%eax
  80040b:	8d 78 04             	lea    0x4(%eax),%edi
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	99                   	cltd   
  800411:	31 d0                	xor    %edx,%eax
  800413:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800415:	83 f8 0f             	cmp    $0xf,%eax
  800418:	7f 23                	jg     80043d <vprintfmt+0x13b>
  80041a:	8b 14 85 60 21 80 00 	mov    0x802160(,%eax,4),%edx
  800421:	85 d2                	test   %edx,%edx
  800423:	74 18                	je     80043d <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800425:	52                   	push   %edx
  800426:	68 b5 22 80 00       	push   $0x8022b5
  80042b:	53                   	push   %ebx
  80042c:	56                   	push   %esi
  80042d:	e8 b3 fe ff ff       	call   8002e5 <printfmt>
  800432:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800435:	89 7d 14             	mov    %edi,0x14(%ebp)
  800438:	e9 65 02 00 00       	jmp    8006a2 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  80043d:	50                   	push   %eax
  80043e:	68 d3 1e 80 00       	push   $0x801ed3
  800443:	53                   	push   %ebx
  800444:	56                   	push   %esi
  800445:	e8 9b fe ff ff       	call   8002e5 <printfmt>
  80044a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800450:	e9 4d 02 00 00       	jmp    8006a2 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800455:	8b 45 14             	mov    0x14(%ebp),%eax
  800458:	83 c0 04             	add    $0x4,%eax
  80045b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80045e:	8b 45 14             	mov    0x14(%ebp),%eax
  800461:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800463:	85 ff                	test   %edi,%edi
  800465:	b8 cc 1e 80 00       	mov    $0x801ecc,%eax
  80046a:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80046d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800471:	0f 8e bd 00 00 00    	jle    800534 <vprintfmt+0x232>
  800477:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80047b:	75 0e                	jne    80048b <vprintfmt+0x189>
  80047d:	89 75 08             	mov    %esi,0x8(%ebp)
  800480:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800483:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800486:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800489:	eb 6d                	jmp    8004f8 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	ff 75 d0             	pushl  -0x30(%ebp)
  800491:	57                   	push   %edi
  800492:	e8 39 03 00 00       	call   8007d0 <strnlen>
  800497:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80049a:	29 c1                	sub    %eax,%ecx
  80049c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80049f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004a2:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004ac:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ae:	eb 0f                	jmp    8004bf <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	53                   	push   %ebx
  8004b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b9:	83 ef 01             	sub    $0x1,%edi
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	85 ff                	test   %edi,%edi
  8004c1:	7f ed                	jg     8004b0 <vprintfmt+0x1ae>
  8004c3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004c6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004c9:	85 c9                	test   %ecx,%ecx
  8004cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d0:	0f 49 c1             	cmovns %ecx,%eax
  8004d3:	29 c1                	sub    %eax,%ecx
  8004d5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004d8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004db:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004de:	89 cb                	mov    %ecx,%ebx
  8004e0:	eb 16                	jmp    8004f8 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e6:	75 31                	jne    800519 <vprintfmt+0x217>
					putch(ch, putdat);
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	ff 75 0c             	pushl  0xc(%ebp)
  8004ee:	50                   	push   %eax
  8004ef:	ff 55 08             	call   *0x8(%ebp)
  8004f2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f5:	83 eb 01             	sub    $0x1,%ebx
  8004f8:	83 c7 01             	add    $0x1,%edi
  8004fb:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004ff:	0f be c2             	movsbl %dl,%eax
  800502:	85 c0                	test   %eax,%eax
  800504:	74 59                	je     80055f <vprintfmt+0x25d>
  800506:	85 f6                	test   %esi,%esi
  800508:	78 d8                	js     8004e2 <vprintfmt+0x1e0>
  80050a:	83 ee 01             	sub    $0x1,%esi
  80050d:	79 d3                	jns    8004e2 <vprintfmt+0x1e0>
  80050f:	89 df                	mov    %ebx,%edi
  800511:	8b 75 08             	mov    0x8(%ebp),%esi
  800514:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800517:	eb 37                	jmp    800550 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800519:	0f be d2             	movsbl %dl,%edx
  80051c:	83 ea 20             	sub    $0x20,%edx
  80051f:	83 fa 5e             	cmp    $0x5e,%edx
  800522:	76 c4                	jbe    8004e8 <vprintfmt+0x1e6>
					putch('?', putdat);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	ff 75 0c             	pushl  0xc(%ebp)
  80052a:	6a 3f                	push   $0x3f
  80052c:	ff 55 08             	call   *0x8(%ebp)
  80052f:	83 c4 10             	add    $0x10,%esp
  800532:	eb c1                	jmp    8004f5 <vprintfmt+0x1f3>
  800534:	89 75 08             	mov    %esi,0x8(%ebp)
  800537:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80053d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800540:	eb b6                	jmp    8004f8 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	53                   	push   %ebx
  800546:	6a 20                	push   $0x20
  800548:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054a:	83 ef 01             	sub    $0x1,%edi
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	85 ff                	test   %edi,%edi
  800552:	7f ee                	jg     800542 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800554:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
  80055a:	e9 43 01 00 00       	jmp    8006a2 <vprintfmt+0x3a0>
  80055f:	89 df                	mov    %ebx,%edi
  800561:	8b 75 08             	mov    0x8(%ebp),%esi
  800564:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800567:	eb e7                	jmp    800550 <vprintfmt+0x24e>
	if (lflag >= 2)
  800569:	83 f9 01             	cmp    $0x1,%ecx
  80056c:	7e 3f                	jle    8005ad <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8b 50 04             	mov    0x4(%eax),%edx
  800574:	8b 00                	mov    (%eax),%eax
  800576:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800579:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 08             	lea    0x8(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800585:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800589:	79 5c                	jns    8005e7 <vprintfmt+0x2e5>
				putch('-', putdat);
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	53                   	push   %ebx
  80058f:	6a 2d                	push   $0x2d
  800591:	ff d6                	call   *%esi
				num = -(long long) num;
  800593:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800596:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800599:	f7 da                	neg    %edx
  80059b:	83 d1 00             	adc    $0x0,%ecx
  80059e:	f7 d9                	neg    %ecx
  8005a0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a8:	e9 db 00 00 00       	jmp    800688 <vprintfmt+0x386>
	else if (lflag)
  8005ad:	85 c9                	test   %ecx,%ecx
  8005af:	75 1b                	jne    8005cc <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b9:	89 c1                	mov    %eax,%ecx
  8005bb:	c1 f9 1f             	sar    $0x1f,%ecx
  8005be:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8d 40 04             	lea    0x4(%eax),%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ca:	eb b9                	jmp    800585 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d4:	89 c1                	mov    %eax,%ecx
  8005d6:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	8d 40 04             	lea    0x4(%eax),%eax
  8005e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e5:	eb 9e                	jmp    800585 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f2:	e9 91 00 00 00       	jmp    800688 <vprintfmt+0x386>
	if (lflag >= 2)
  8005f7:	83 f9 01             	cmp    $0x1,%ecx
  8005fa:	7e 15                	jle    800611 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 10                	mov    (%eax),%edx
  800601:	8b 48 04             	mov    0x4(%eax),%ecx
  800604:	8d 40 08             	lea    0x8(%eax),%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060f:	eb 77                	jmp    800688 <vprintfmt+0x386>
	else if (lflag)
  800611:	85 c9                	test   %ecx,%ecx
  800613:	75 17                	jne    80062c <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8b 10                	mov    (%eax),%edx
  80061a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061f:	8d 40 04             	lea    0x4(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800625:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062a:	eb 5c                	jmp    800688 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8b 10                	mov    (%eax),%edx
  800631:	b9 00 00 00 00       	mov    $0x0,%ecx
  800636:	8d 40 04             	lea    0x4(%eax),%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800641:	eb 45                	jmp    800688 <vprintfmt+0x386>
			putch('X', putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	53                   	push   %ebx
  800647:	6a 58                	push   $0x58
  800649:	ff d6                	call   *%esi
			putch('X', putdat);
  80064b:	83 c4 08             	add    $0x8,%esp
  80064e:	53                   	push   %ebx
  80064f:	6a 58                	push   $0x58
  800651:	ff d6                	call   *%esi
			putch('X', putdat);
  800653:	83 c4 08             	add    $0x8,%esp
  800656:	53                   	push   %ebx
  800657:	6a 58                	push   $0x58
  800659:	ff d6                	call   *%esi
			break;
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	eb 42                	jmp    8006a2 <vprintfmt+0x3a0>
			putch('0', putdat);
  800660:	83 ec 08             	sub    $0x8,%esp
  800663:	53                   	push   %ebx
  800664:	6a 30                	push   $0x30
  800666:	ff d6                	call   *%esi
			putch('x', putdat);
  800668:	83 c4 08             	add    $0x8,%esp
  80066b:	53                   	push   %ebx
  80066c:	6a 78                	push   $0x78
  80066e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 10                	mov    (%eax),%edx
  800675:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80067a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80067d:	8d 40 04             	lea    0x4(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800683:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800688:	83 ec 0c             	sub    $0xc,%esp
  80068b:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80068f:	57                   	push   %edi
  800690:	ff 75 e0             	pushl  -0x20(%ebp)
  800693:	50                   	push   %eax
  800694:	51                   	push   %ecx
  800695:	52                   	push   %edx
  800696:	89 da                	mov    %ebx,%edx
  800698:	89 f0                	mov    %esi,%eax
  80069a:	e8 7a fb ff ff       	call   800219 <printnum>
			break;
  80069f:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a5:	83 c7 01             	add    $0x1,%edi
  8006a8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ac:	83 f8 25             	cmp    $0x25,%eax
  8006af:	0f 84 64 fc ff ff    	je     800319 <vprintfmt+0x17>
			if (ch == '\0')
  8006b5:	85 c0                	test   %eax,%eax
  8006b7:	0f 84 8b 00 00 00    	je     800748 <vprintfmt+0x446>
			putch(ch, putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	53                   	push   %ebx
  8006c1:	50                   	push   %eax
  8006c2:	ff d6                	call   *%esi
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	eb dc                	jmp    8006a5 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8006c9:	83 f9 01             	cmp    $0x1,%ecx
  8006cc:	7e 15                	jle    8006e3 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 10                	mov    (%eax),%edx
  8006d3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006d6:	8d 40 08             	lea    0x8(%eax),%eax
  8006d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006dc:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e1:	eb a5                	jmp    800688 <vprintfmt+0x386>
	else if (lflag)
  8006e3:	85 c9                	test   %ecx,%ecx
  8006e5:	75 17                	jne    8006fe <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8b 10                	mov    (%eax),%edx
  8006ec:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f1:	8d 40 04             	lea    0x4(%eax),%eax
  8006f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f7:	b8 10 00 00 00       	mov    $0x10,%eax
  8006fc:	eb 8a                	jmp    800688 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 10                	mov    (%eax),%edx
  800703:	b9 00 00 00 00       	mov    $0x0,%ecx
  800708:	8d 40 04             	lea    0x4(%eax),%eax
  80070b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070e:	b8 10 00 00 00       	mov    $0x10,%eax
  800713:	e9 70 ff ff ff       	jmp    800688 <vprintfmt+0x386>
			putch(ch, putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	6a 25                	push   $0x25
  80071e:	ff d6                	call   *%esi
			break;
  800720:	83 c4 10             	add    $0x10,%esp
  800723:	e9 7a ff ff ff       	jmp    8006a2 <vprintfmt+0x3a0>
			putch('%', putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	53                   	push   %ebx
  80072c:	6a 25                	push   $0x25
  80072e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800730:	83 c4 10             	add    $0x10,%esp
  800733:	89 f8                	mov    %edi,%eax
  800735:	eb 03                	jmp    80073a <vprintfmt+0x438>
  800737:	83 e8 01             	sub    $0x1,%eax
  80073a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80073e:	75 f7                	jne    800737 <vprintfmt+0x435>
  800740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800743:	e9 5a ff ff ff       	jmp    8006a2 <vprintfmt+0x3a0>
}
  800748:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80074b:	5b                   	pop    %ebx
  80074c:	5e                   	pop    %esi
  80074d:	5f                   	pop    %edi
  80074e:	5d                   	pop    %ebp
  80074f:	c3                   	ret    

00800750 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	83 ec 18             	sub    $0x18,%esp
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80075f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800763:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800766:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076d:	85 c0                	test   %eax,%eax
  80076f:	74 26                	je     800797 <vsnprintf+0x47>
  800771:	85 d2                	test   %edx,%edx
  800773:	7e 22                	jle    800797 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800775:	ff 75 14             	pushl  0x14(%ebp)
  800778:	ff 75 10             	pushl  0x10(%ebp)
  80077b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077e:	50                   	push   %eax
  80077f:	68 c8 02 80 00       	push   $0x8002c8
  800784:	e8 79 fb ff ff       	call   800302 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800789:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800792:	83 c4 10             	add    $0x10,%esp
}
  800795:	c9                   	leave  
  800796:	c3                   	ret    
		return -E_INVAL;
  800797:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079c:	eb f7                	jmp    800795 <vsnprintf+0x45>

0080079e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80079e:	55                   	push   %ebp
  80079f:	89 e5                	mov    %esp,%ebp
  8007a1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a7:	50                   	push   %eax
  8007a8:	ff 75 10             	pushl  0x10(%ebp)
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	ff 75 08             	pushl  0x8(%ebp)
  8007b1:	e8 9a ff ff ff       	call   800750 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007be:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c3:	eb 03                	jmp    8007c8 <strlen+0x10>
		n++;
  8007c5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007c8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007cc:	75 f7                	jne    8007c5 <strlen+0xd>
	return n;
}
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007de:	eb 03                	jmp    8007e3 <strnlen+0x13>
		n++;
  8007e0:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e3:	39 d0                	cmp    %edx,%eax
  8007e5:	74 06                	je     8007ed <strnlen+0x1d>
  8007e7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007eb:	75 f3                	jne    8007e0 <strnlen+0x10>
	return n;
}
  8007ed:	5d                   	pop    %ebp
  8007ee:	c3                   	ret    

008007ef <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	53                   	push   %ebx
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007f9:	89 c2                	mov    %eax,%edx
  8007fb:	83 c1 01             	add    $0x1,%ecx
  8007fe:	83 c2 01             	add    $0x1,%edx
  800801:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800805:	88 5a ff             	mov    %bl,-0x1(%edx)
  800808:	84 db                	test   %bl,%bl
  80080a:	75 ef                	jne    8007fb <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80080c:	5b                   	pop    %ebx
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	53                   	push   %ebx
  800813:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800816:	53                   	push   %ebx
  800817:	e8 9c ff ff ff       	call   8007b8 <strlen>
  80081c:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	01 d8                	add    %ebx,%eax
  800824:	50                   	push   %eax
  800825:	e8 c5 ff ff ff       	call   8007ef <strcpy>
	return dst;
}
  80082a:	89 d8                	mov    %ebx,%eax
  80082c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082f:	c9                   	leave  
  800830:	c3                   	ret    

00800831 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	56                   	push   %esi
  800835:	53                   	push   %ebx
  800836:	8b 75 08             	mov    0x8(%ebp),%esi
  800839:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80083c:	89 f3                	mov    %esi,%ebx
  80083e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800841:	89 f2                	mov    %esi,%edx
  800843:	eb 0f                	jmp    800854 <strncpy+0x23>
		*dst++ = *src;
  800845:	83 c2 01             	add    $0x1,%edx
  800848:	0f b6 01             	movzbl (%ecx),%eax
  80084b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80084e:	80 39 01             	cmpb   $0x1,(%ecx)
  800851:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800854:	39 da                	cmp    %ebx,%edx
  800856:	75 ed                	jne    800845 <strncpy+0x14>
	}
	return ret;
}
  800858:	89 f0                	mov    %esi,%eax
  80085a:	5b                   	pop    %ebx
  80085b:	5e                   	pop    %esi
  80085c:	5d                   	pop    %ebp
  80085d:	c3                   	ret    

0080085e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80085e:	55                   	push   %ebp
  80085f:	89 e5                	mov    %esp,%ebp
  800861:	56                   	push   %esi
  800862:	53                   	push   %ebx
  800863:	8b 75 08             	mov    0x8(%ebp),%esi
  800866:	8b 55 0c             	mov    0xc(%ebp),%edx
  800869:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80086c:	89 f0                	mov    %esi,%eax
  80086e:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800872:	85 c9                	test   %ecx,%ecx
  800874:	75 0b                	jne    800881 <strlcpy+0x23>
  800876:	eb 17                	jmp    80088f <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800878:	83 c2 01             	add    $0x1,%edx
  80087b:	83 c0 01             	add    $0x1,%eax
  80087e:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800881:	39 d8                	cmp    %ebx,%eax
  800883:	74 07                	je     80088c <strlcpy+0x2e>
  800885:	0f b6 0a             	movzbl (%edx),%ecx
  800888:	84 c9                	test   %cl,%cl
  80088a:	75 ec                	jne    800878 <strlcpy+0x1a>
		*dst = '\0';
  80088c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80088f:	29 f0                	sub    %esi,%eax
}
  800891:	5b                   	pop    %ebx
  800892:	5e                   	pop    %esi
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80089e:	eb 06                	jmp    8008a6 <strcmp+0x11>
		p++, q++;
  8008a0:	83 c1 01             	add    $0x1,%ecx
  8008a3:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008a6:	0f b6 01             	movzbl (%ecx),%eax
  8008a9:	84 c0                	test   %al,%al
  8008ab:	74 04                	je     8008b1 <strcmp+0x1c>
  8008ad:	3a 02                	cmp    (%edx),%al
  8008af:	74 ef                	je     8008a0 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b1:	0f b6 c0             	movzbl %al,%eax
  8008b4:	0f b6 12             	movzbl (%edx),%edx
  8008b7:	29 d0                	sub    %edx,%eax
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c5:	89 c3                	mov    %eax,%ebx
  8008c7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008ca:	eb 06                	jmp    8008d2 <strncmp+0x17>
		n--, p++, q++;
  8008cc:	83 c0 01             	add    $0x1,%eax
  8008cf:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008d2:	39 d8                	cmp    %ebx,%eax
  8008d4:	74 16                	je     8008ec <strncmp+0x31>
  8008d6:	0f b6 08             	movzbl (%eax),%ecx
  8008d9:	84 c9                	test   %cl,%cl
  8008db:	74 04                	je     8008e1 <strncmp+0x26>
  8008dd:	3a 0a                	cmp    (%edx),%cl
  8008df:	74 eb                	je     8008cc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e1:	0f b6 00             	movzbl (%eax),%eax
  8008e4:	0f b6 12             	movzbl (%edx),%edx
  8008e7:	29 d0                	sub    %edx,%eax
}
  8008e9:	5b                   	pop    %ebx
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    
		return 0;
  8008ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f1:	eb f6                	jmp    8008e9 <strncmp+0x2e>

008008f3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fd:	0f b6 10             	movzbl (%eax),%edx
  800900:	84 d2                	test   %dl,%dl
  800902:	74 09                	je     80090d <strchr+0x1a>
		if (*s == c)
  800904:	38 ca                	cmp    %cl,%dl
  800906:	74 0a                	je     800912 <strchr+0x1f>
	for (; *s; s++)
  800908:	83 c0 01             	add    $0x1,%eax
  80090b:	eb f0                	jmp    8008fd <strchr+0xa>
			return (char *) s;
	return 0;
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80091e:	eb 03                	jmp    800923 <strfind+0xf>
  800920:	83 c0 01             	add    $0x1,%eax
  800923:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800926:	38 ca                	cmp    %cl,%dl
  800928:	74 04                	je     80092e <strfind+0x1a>
  80092a:	84 d2                	test   %dl,%dl
  80092c:	75 f2                	jne    800920 <strfind+0xc>
			break;
	return (char *) s;
}
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	57                   	push   %edi
  800934:	56                   	push   %esi
  800935:	53                   	push   %ebx
  800936:	8b 7d 08             	mov    0x8(%ebp),%edi
  800939:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80093c:	85 c9                	test   %ecx,%ecx
  80093e:	74 13                	je     800953 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800940:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800946:	75 05                	jne    80094d <memset+0x1d>
  800948:	f6 c1 03             	test   $0x3,%cl
  80094b:	74 0d                	je     80095a <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80094d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800950:	fc                   	cld    
  800951:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800953:	89 f8                	mov    %edi,%eax
  800955:	5b                   	pop    %ebx
  800956:	5e                   	pop    %esi
  800957:	5f                   	pop    %edi
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    
		c &= 0xFF;
  80095a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095e:	89 d3                	mov    %edx,%ebx
  800960:	c1 e3 08             	shl    $0x8,%ebx
  800963:	89 d0                	mov    %edx,%eax
  800965:	c1 e0 18             	shl    $0x18,%eax
  800968:	89 d6                	mov    %edx,%esi
  80096a:	c1 e6 10             	shl    $0x10,%esi
  80096d:	09 f0                	or     %esi,%eax
  80096f:	09 c2                	or     %eax,%edx
  800971:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800973:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800976:	89 d0                	mov    %edx,%eax
  800978:	fc                   	cld    
  800979:	f3 ab                	rep stos %eax,%es:(%edi)
  80097b:	eb d6                	jmp    800953 <memset+0x23>

0080097d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	57                   	push   %edi
  800981:	56                   	push   %esi
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 75 0c             	mov    0xc(%ebp),%esi
  800988:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80098b:	39 c6                	cmp    %eax,%esi
  80098d:	73 35                	jae    8009c4 <memmove+0x47>
  80098f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800992:	39 c2                	cmp    %eax,%edx
  800994:	76 2e                	jbe    8009c4 <memmove+0x47>
		s += n;
		d += n;
  800996:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800999:	89 d6                	mov    %edx,%esi
  80099b:	09 fe                	or     %edi,%esi
  80099d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009a3:	74 0c                	je     8009b1 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009a5:	83 ef 01             	sub    $0x1,%edi
  8009a8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ab:	fd                   	std    
  8009ac:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ae:	fc                   	cld    
  8009af:	eb 21                	jmp    8009d2 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b1:	f6 c1 03             	test   $0x3,%cl
  8009b4:	75 ef                	jne    8009a5 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009b6:	83 ef 04             	sub    $0x4,%edi
  8009b9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009bc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009bf:	fd                   	std    
  8009c0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c2:	eb ea                	jmp    8009ae <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c4:	89 f2                	mov    %esi,%edx
  8009c6:	09 c2                	or     %eax,%edx
  8009c8:	f6 c2 03             	test   $0x3,%dl
  8009cb:	74 09                	je     8009d6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009cd:	89 c7                	mov    %eax,%edi
  8009cf:	fc                   	cld    
  8009d0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009d2:	5e                   	pop    %esi
  8009d3:	5f                   	pop    %edi
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d6:	f6 c1 03             	test   $0x3,%cl
  8009d9:	75 f2                	jne    8009cd <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009db:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009de:	89 c7                	mov    %eax,%edi
  8009e0:	fc                   	cld    
  8009e1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e3:	eb ed                	jmp    8009d2 <memmove+0x55>

008009e5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009e8:	ff 75 10             	pushl  0x10(%ebp)
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	ff 75 08             	pushl  0x8(%ebp)
  8009f1:	e8 87 ff ff ff       	call   80097d <memmove>
}
  8009f6:	c9                   	leave  
  8009f7:	c3                   	ret    

008009f8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	56                   	push   %esi
  8009fc:	53                   	push   %ebx
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a03:	89 c6                	mov    %eax,%esi
  800a05:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a08:	39 f0                	cmp    %esi,%eax
  800a0a:	74 1c                	je     800a28 <memcmp+0x30>
		if (*s1 != *s2)
  800a0c:	0f b6 08             	movzbl (%eax),%ecx
  800a0f:	0f b6 1a             	movzbl (%edx),%ebx
  800a12:	38 d9                	cmp    %bl,%cl
  800a14:	75 08                	jne    800a1e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a16:	83 c0 01             	add    $0x1,%eax
  800a19:	83 c2 01             	add    $0x1,%edx
  800a1c:	eb ea                	jmp    800a08 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a1e:	0f b6 c1             	movzbl %cl,%eax
  800a21:	0f b6 db             	movzbl %bl,%ebx
  800a24:	29 d8                	sub    %ebx,%eax
  800a26:	eb 05                	jmp    800a2d <memcmp+0x35>
	}

	return 0;
  800a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2d:	5b                   	pop    %ebx
  800a2e:	5e                   	pop    %esi
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    

00800a31 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a3a:	89 c2                	mov    %eax,%edx
  800a3c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a3f:	39 d0                	cmp    %edx,%eax
  800a41:	73 09                	jae    800a4c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a43:	38 08                	cmp    %cl,(%eax)
  800a45:	74 05                	je     800a4c <memfind+0x1b>
	for (; s < ends; s++)
  800a47:	83 c0 01             	add    $0x1,%eax
  800a4a:	eb f3                	jmp    800a3f <memfind+0xe>
			break;
	return (void *) s;
}
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	57                   	push   %edi
  800a52:	56                   	push   %esi
  800a53:	53                   	push   %ebx
  800a54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a5a:	eb 03                	jmp    800a5f <strtol+0x11>
		s++;
  800a5c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a5f:	0f b6 01             	movzbl (%ecx),%eax
  800a62:	3c 20                	cmp    $0x20,%al
  800a64:	74 f6                	je     800a5c <strtol+0xe>
  800a66:	3c 09                	cmp    $0x9,%al
  800a68:	74 f2                	je     800a5c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a6a:	3c 2b                	cmp    $0x2b,%al
  800a6c:	74 2e                	je     800a9c <strtol+0x4e>
	int neg = 0;
  800a6e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a73:	3c 2d                	cmp    $0x2d,%al
  800a75:	74 2f                	je     800aa6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a77:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a7d:	75 05                	jne    800a84 <strtol+0x36>
  800a7f:	80 39 30             	cmpb   $0x30,(%ecx)
  800a82:	74 2c                	je     800ab0 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a84:	85 db                	test   %ebx,%ebx
  800a86:	75 0a                	jne    800a92 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a88:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a8d:	80 39 30             	cmpb   $0x30,(%ecx)
  800a90:	74 28                	je     800aba <strtol+0x6c>
		base = 10;
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
  800a97:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a9a:	eb 50                	jmp    800aec <strtol+0x9e>
		s++;
  800a9c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a9f:	bf 00 00 00 00       	mov    $0x0,%edi
  800aa4:	eb d1                	jmp    800a77 <strtol+0x29>
		s++, neg = 1;
  800aa6:	83 c1 01             	add    $0x1,%ecx
  800aa9:	bf 01 00 00 00       	mov    $0x1,%edi
  800aae:	eb c7                	jmp    800a77 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ab4:	74 0e                	je     800ac4 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ab6:	85 db                	test   %ebx,%ebx
  800ab8:	75 d8                	jne    800a92 <strtol+0x44>
		s++, base = 8;
  800aba:	83 c1 01             	add    $0x1,%ecx
  800abd:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ac2:	eb ce                	jmp    800a92 <strtol+0x44>
		s += 2, base = 16;
  800ac4:	83 c1 02             	add    $0x2,%ecx
  800ac7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800acc:	eb c4                	jmp    800a92 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ace:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ad1:	89 f3                	mov    %esi,%ebx
  800ad3:	80 fb 19             	cmp    $0x19,%bl
  800ad6:	77 29                	ja     800b01 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ad8:	0f be d2             	movsbl %dl,%edx
  800adb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ade:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ae1:	7d 30                	jge    800b13 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ae3:	83 c1 01             	add    $0x1,%ecx
  800ae6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aea:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aec:	0f b6 11             	movzbl (%ecx),%edx
  800aef:	8d 72 d0             	lea    -0x30(%edx),%esi
  800af2:	89 f3                	mov    %esi,%ebx
  800af4:	80 fb 09             	cmp    $0x9,%bl
  800af7:	77 d5                	ja     800ace <strtol+0x80>
			dig = *s - '0';
  800af9:	0f be d2             	movsbl %dl,%edx
  800afc:	83 ea 30             	sub    $0x30,%edx
  800aff:	eb dd                	jmp    800ade <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b01:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b04:	89 f3                	mov    %esi,%ebx
  800b06:	80 fb 19             	cmp    $0x19,%bl
  800b09:	77 08                	ja     800b13 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b0b:	0f be d2             	movsbl %dl,%edx
  800b0e:	83 ea 37             	sub    $0x37,%edx
  800b11:	eb cb                	jmp    800ade <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b17:	74 05                	je     800b1e <strtol+0xd0>
		*endptr = (char *) s;
  800b19:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b1e:	89 c2                	mov    %eax,%edx
  800b20:	f7 da                	neg    %edx
  800b22:	85 ff                	test   %edi,%edi
  800b24:	0f 45 c2             	cmovne %edx,%eax
}
  800b27:	5b                   	pop    %ebx
  800b28:	5e                   	pop    %esi
  800b29:	5f                   	pop    %edi
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	57                   	push   %edi
  800b30:	56                   	push   %esi
  800b31:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b32:	b8 00 00 00 00       	mov    $0x0,%eax
  800b37:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3d:	89 c3                	mov    %eax,%ebx
  800b3f:	89 c7                	mov    %eax,%edi
  800b41:	89 c6                	mov    %eax,%esi
  800b43:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5f                   	pop    %edi
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <sys_cgetc>:

int
sys_cgetc(void)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	57                   	push   %edi
  800b4e:	56                   	push   %esi
  800b4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b50:	ba 00 00 00 00       	mov    $0x0,%edx
  800b55:	b8 01 00 00 00       	mov    $0x1,%eax
  800b5a:	89 d1                	mov    %edx,%ecx
  800b5c:	89 d3                	mov    %edx,%ebx
  800b5e:	89 d7                	mov    %edx,%edi
  800b60:	89 d6                	mov    %edx,%esi
  800b62:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b64:	5b                   	pop    %ebx
  800b65:	5e                   	pop    %esi
  800b66:	5f                   	pop    %edi
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	57                   	push   %edi
  800b6d:	56                   	push   %esi
  800b6e:	53                   	push   %ebx
  800b6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b77:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7a:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7f:	89 cb                	mov    %ecx,%ebx
  800b81:	89 cf                	mov    %ecx,%edi
  800b83:	89 ce                	mov    %ecx,%esi
  800b85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b87:	85 c0                	test   %eax,%eax
  800b89:	7f 08                	jg     800b93 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8e:	5b                   	pop    %ebx
  800b8f:	5e                   	pop    %esi
  800b90:	5f                   	pop    %edi
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b93:	83 ec 0c             	sub    $0xc,%esp
  800b96:	50                   	push   %eax
  800b97:	6a 03                	push   $0x3
  800b99:	68 bf 21 80 00       	push   $0x8021bf
  800b9e:	6a 23                	push   $0x23
  800ba0:	68 dc 21 80 00       	push   $0x8021dc
  800ba5:	e8 80 f5 ff ff       	call   80012a <_panic>

00800baa <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	57                   	push   %edi
  800bae:	56                   	push   %esi
  800baf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb5:	b8 02 00 00 00       	mov    $0x2,%eax
  800bba:	89 d1                	mov    %edx,%ecx
  800bbc:	89 d3                	mov    %edx,%ebx
  800bbe:	89 d7                	mov    %edx,%edi
  800bc0:	89 d6                	mov    %edx,%esi
  800bc2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5f                   	pop    %edi
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <sys_yield>:

void
sys_yield(void)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	57                   	push   %edi
  800bcd:	56                   	push   %esi
  800bce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bd9:	89 d1                	mov    %edx,%ecx
  800bdb:	89 d3                	mov    %edx,%ebx
  800bdd:	89 d7                	mov    %edx,%edi
  800bdf:	89 d6                	mov    %edx,%esi
  800be1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5f                   	pop    %edi
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	57                   	push   %edi
  800bec:	56                   	push   %esi
  800bed:	53                   	push   %ebx
  800bee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf1:	be 00 00 00 00       	mov    $0x0,%esi
  800bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfc:	b8 04 00 00 00       	mov    $0x4,%eax
  800c01:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c04:	89 f7                	mov    %esi,%edi
  800c06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c08:	85 c0                	test   %eax,%eax
  800c0a:	7f 08                	jg     800c14 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c14:	83 ec 0c             	sub    $0xc,%esp
  800c17:	50                   	push   %eax
  800c18:	6a 04                	push   $0x4
  800c1a:	68 bf 21 80 00       	push   $0x8021bf
  800c1f:	6a 23                	push   $0x23
  800c21:	68 dc 21 80 00       	push   $0x8021dc
  800c26:	e8 ff f4 ff ff       	call   80012a <_panic>

00800c2b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c34:	8b 55 08             	mov    0x8(%ebp),%edx
  800c37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3a:	b8 05 00 00 00       	mov    $0x5,%eax
  800c3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c42:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c45:	8b 75 18             	mov    0x18(%ebp),%esi
  800c48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4a:	85 c0                	test   %eax,%eax
  800c4c:	7f 08                	jg     800c56 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	50                   	push   %eax
  800c5a:	6a 05                	push   $0x5
  800c5c:	68 bf 21 80 00       	push   $0x8021bf
  800c61:	6a 23                	push   $0x23
  800c63:	68 dc 21 80 00       	push   $0x8021dc
  800c68:	e8 bd f4 ff ff       	call   80012a <_panic>

00800c6d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	53                   	push   %ebx
  800c73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c81:	b8 06 00 00 00       	mov    $0x6,%eax
  800c86:	89 df                	mov    %ebx,%edi
  800c88:	89 de                	mov    %ebx,%esi
  800c8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8c:	85 c0                	test   %eax,%eax
  800c8e:	7f 08                	jg     800c98 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c98:	83 ec 0c             	sub    $0xc,%esp
  800c9b:	50                   	push   %eax
  800c9c:	6a 06                	push   $0x6
  800c9e:	68 bf 21 80 00       	push   $0x8021bf
  800ca3:	6a 23                	push   $0x23
  800ca5:	68 dc 21 80 00       	push   $0x8021dc
  800caa:	e8 7b f4 ff ff       	call   80012a <_panic>

00800caf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	57                   	push   %edi
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
  800cb5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc3:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc8:	89 df                	mov    %ebx,%edi
  800cca:	89 de                	mov    %ebx,%esi
  800ccc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cce:	85 c0                	test   %eax,%eax
  800cd0:	7f 08                	jg     800cda <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cda:	83 ec 0c             	sub    $0xc,%esp
  800cdd:	50                   	push   %eax
  800cde:	6a 08                	push   $0x8
  800ce0:	68 bf 21 80 00       	push   $0x8021bf
  800ce5:	6a 23                	push   $0x23
  800ce7:	68 dc 21 80 00       	push   $0x8021dc
  800cec:	e8 39 f4 ff ff       	call   80012a <_panic>

00800cf1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	57                   	push   %edi
  800cf5:	56                   	push   %esi
  800cf6:	53                   	push   %ebx
  800cf7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cff:	8b 55 08             	mov    0x8(%ebp),%edx
  800d02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d05:	b8 09 00 00 00       	mov    $0x9,%eax
  800d0a:	89 df                	mov    %ebx,%edi
  800d0c:	89 de                	mov    %ebx,%esi
  800d0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d10:	85 c0                	test   %eax,%eax
  800d12:	7f 08                	jg     800d1c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1c:	83 ec 0c             	sub    $0xc,%esp
  800d1f:	50                   	push   %eax
  800d20:	6a 09                	push   $0x9
  800d22:	68 bf 21 80 00       	push   $0x8021bf
  800d27:	6a 23                	push   $0x23
  800d29:	68 dc 21 80 00       	push   $0x8021dc
  800d2e:	e8 f7 f3 ff ff       	call   80012a <_panic>

00800d33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d41:	8b 55 08             	mov    0x8(%ebp),%edx
  800d44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d47:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d4c:	89 df                	mov    %ebx,%edi
  800d4e:	89 de                	mov    %ebx,%esi
  800d50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d52:	85 c0                	test   %eax,%eax
  800d54:	7f 08                	jg     800d5e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d59:	5b                   	pop    %ebx
  800d5a:	5e                   	pop    %esi
  800d5b:	5f                   	pop    %edi
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5e:	83 ec 0c             	sub    $0xc,%esp
  800d61:	50                   	push   %eax
  800d62:	6a 0a                	push   $0xa
  800d64:	68 bf 21 80 00       	push   $0x8021bf
  800d69:	6a 23                	push   $0x23
  800d6b:	68 dc 21 80 00       	push   $0x8021dc
  800d70:	e8 b5 f3 ff ff       	call   80012a <_panic>

00800d75 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d81:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d86:	be 00 00 00 00       	mov    $0x0,%esi
  800d8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d91:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    

00800d98 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
  800d9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dae:	89 cb                	mov    %ecx,%ebx
  800db0:	89 cf                	mov    %ecx,%edi
  800db2:	89 ce                	mov    %ecx,%esi
  800db4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	7f 08                	jg     800dc2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc2:	83 ec 0c             	sub    $0xc,%esp
  800dc5:	50                   	push   %eax
  800dc6:	6a 0d                	push   $0xd
  800dc8:	68 bf 21 80 00       	push   $0x8021bf
  800dcd:	6a 23                	push   $0x23
  800dcf:	68 dc 21 80 00       	push   $0x8021dc
  800dd4:	e8 51 f3 ff ff       	call   80012a <_panic>

00800dd9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	53                   	push   %ebx
  800ddd:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  800de0:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800de7:	74 0d                	je     800df6 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800df1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800df4:	c9                   	leave  
  800df5:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  800df6:	e8 af fd ff ff       	call   800baa <sys_getenvid>
  800dfb:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  800dfd:	83 ec 04             	sub    $0x4,%esp
  800e00:	6a 07                	push   $0x7
  800e02:	68 00 f0 bf ee       	push   $0xeebff000
  800e07:	50                   	push   %eax
  800e08:	e8 db fd ff ff       	call   800be8 <sys_page_alloc>
        	if (r < 0) {
  800e0d:	83 c4 10             	add    $0x10,%esp
  800e10:	85 c0                	test   %eax,%eax
  800e12:	78 27                	js     800e3b <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	68 4d 0e 80 00       	push   $0x800e4d
  800e1c:	53                   	push   %ebx
  800e1d:	e8 11 ff ff ff       	call   800d33 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  800e22:	83 c4 10             	add    $0x10,%esp
  800e25:	85 c0                	test   %eax,%eax
  800e27:	79 c0                	jns    800de9 <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  800e29:	50                   	push   %eax
  800e2a:	68 ea 21 80 00       	push   $0x8021ea
  800e2f:	6a 28                	push   $0x28
  800e31:	68 fe 21 80 00       	push   $0x8021fe
  800e36:	e8 ef f2 ff ff       	call   80012a <_panic>
            		panic("pgfault_handler: %e", r);
  800e3b:	50                   	push   %eax
  800e3c:	68 ea 21 80 00       	push   $0x8021ea
  800e41:	6a 24                	push   $0x24
  800e43:	68 fe 21 80 00       	push   $0x8021fe
  800e48:	e8 dd f2 ff ff       	call   80012a <_panic>

00800e4d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e4d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e4e:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800e53:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e55:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  800e58:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  800e5c:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  800e5f:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  800e63:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  800e67:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  800e6a:	83 c4 08             	add    $0x8,%esp
	popal
  800e6d:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  800e6e:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  800e71:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  800e72:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  800e73:	c3                   	ret    

00800e74 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	05 00 00 00 30       	add    $0x30000000,%eax
  800e7f:	c1 e8 0c             	shr    $0xc,%eax
}
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    

00800e84 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e94:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ea6:	89 c2                	mov    %eax,%edx
  800ea8:	c1 ea 16             	shr    $0x16,%edx
  800eab:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800eb2:	f6 c2 01             	test   $0x1,%dl
  800eb5:	74 2a                	je     800ee1 <fd_alloc+0x46>
  800eb7:	89 c2                	mov    %eax,%edx
  800eb9:	c1 ea 0c             	shr    $0xc,%edx
  800ebc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ec3:	f6 c2 01             	test   $0x1,%dl
  800ec6:	74 19                	je     800ee1 <fd_alloc+0x46>
  800ec8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ecd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ed2:	75 d2                	jne    800ea6 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ed4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800eda:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800edf:	eb 07                	jmp    800ee8 <fd_alloc+0x4d>
			*fd_store = fd;
  800ee1:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ee3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ef0:	83 f8 1f             	cmp    $0x1f,%eax
  800ef3:	77 36                	ja     800f2b <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ef5:	c1 e0 0c             	shl    $0xc,%eax
  800ef8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800efd:	89 c2                	mov    %eax,%edx
  800eff:	c1 ea 16             	shr    $0x16,%edx
  800f02:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f09:	f6 c2 01             	test   $0x1,%dl
  800f0c:	74 24                	je     800f32 <fd_lookup+0x48>
  800f0e:	89 c2                	mov    %eax,%edx
  800f10:	c1 ea 0c             	shr    $0xc,%edx
  800f13:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f1a:	f6 c2 01             	test   $0x1,%dl
  800f1d:	74 1a                	je     800f39 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f22:	89 02                	mov    %eax,(%edx)
	return 0;
  800f24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    
		return -E_INVAL;
  800f2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f30:	eb f7                	jmp    800f29 <fd_lookup+0x3f>
		return -E_INVAL;
  800f32:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f37:	eb f0                	jmp    800f29 <fd_lookup+0x3f>
  800f39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f3e:	eb e9                	jmp    800f29 <fd_lookup+0x3f>

00800f40 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 08             	sub    $0x8,%esp
  800f46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f49:	ba 8c 22 80 00       	mov    $0x80228c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f4e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f53:	39 08                	cmp    %ecx,(%eax)
  800f55:	74 33                	je     800f8a <dev_lookup+0x4a>
  800f57:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f5a:	8b 02                	mov    (%edx),%eax
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	75 f3                	jne    800f53 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f60:	a1 04 40 80 00       	mov    0x804004,%eax
  800f65:	8b 40 48             	mov    0x48(%eax),%eax
  800f68:	83 ec 04             	sub    $0x4,%esp
  800f6b:	51                   	push   %ecx
  800f6c:	50                   	push   %eax
  800f6d:	68 0c 22 80 00       	push   $0x80220c
  800f72:	e8 8e f2 ff ff       	call   800205 <cprintf>
	*dev = 0;
  800f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f80:	83 c4 10             	add    $0x10,%esp
  800f83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    
			*dev = devtab[i];
  800f8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8d:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f94:	eb f2                	jmp    800f88 <dev_lookup+0x48>

00800f96 <fd_close>:
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	57                   	push   %edi
  800f9a:	56                   	push   %esi
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 1c             	sub    $0x1c,%esp
  800f9f:	8b 75 08             	mov    0x8(%ebp),%esi
  800fa2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fa5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fa8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800faf:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fb2:	50                   	push   %eax
  800fb3:	e8 32 ff ff ff       	call   800eea <fd_lookup>
  800fb8:	89 c3                	mov    %eax,%ebx
  800fba:	83 c4 08             	add    $0x8,%esp
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	78 05                	js     800fc6 <fd_close+0x30>
	    || fd != fd2)
  800fc1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fc4:	74 16                	je     800fdc <fd_close+0x46>
		return (must_exist ? r : 0);
  800fc6:	89 f8                	mov    %edi,%eax
  800fc8:	84 c0                	test   %al,%al
  800fca:	b8 00 00 00 00       	mov    $0x0,%eax
  800fcf:	0f 44 d8             	cmove  %eax,%ebx
}
  800fd2:	89 d8                	mov    %ebx,%eax
  800fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5f                   	pop    %edi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fdc:	83 ec 08             	sub    $0x8,%esp
  800fdf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fe2:	50                   	push   %eax
  800fe3:	ff 36                	pushl  (%esi)
  800fe5:	e8 56 ff ff ff       	call   800f40 <dev_lookup>
  800fea:	89 c3                	mov    %eax,%ebx
  800fec:	83 c4 10             	add    $0x10,%esp
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	78 15                	js     801008 <fd_close+0x72>
		if (dev->dev_close)
  800ff3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ff6:	8b 40 10             	mov    0x10(%eax),%eax
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	74 1b                	je     801018 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800ffd:	83 ec 0c             	sub    $0xc,%esp
  801000:	56                   	push   %esi
  801001:	ff d0                	call   *%eax
  801003:	89 c3                	mov    %eax,%ebx
  801005:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801008:	83 ec 08             	sub    $0x8,%esp
  80100b:	56                   	push   %esi
  80100c:	6a 00                	push   $0x0
  80100e:	e8 5a fc ff ff       	call   800c6d <sys_page_unmap>
	return r;
  801013:	83 c4 10             	add    $0x10,%esp
  801016:	eb ba                	jmp    800fd2 <fd_close+0x3c>
			r = 0;
  801018:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101d:	eb e9                	jmp    801008 <fd_close+0x72>

0080101f <close>:

int
close(int fdnum)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801025:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801028:	50                   	push   %eax
  801029:	ff 75 08             	pushl  0x8(%ebp)
  80102c:	e8 b9 fe ff ff       	call   800eea <fd_lookup>
  801031:	83 c4 08             	add    $0x8,%esp
  801034:	85 c0                	test   %eax,%eax
  801036:	78 10                	js     801048 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801038:	83 ec 08             	sub    $0x8,%esp
  80103b:	6a 01                	push   $0x1
  80103d:	ff 75 f4             	pushl  -0xc(%ebp)
  801040:	e8 51 ff ff ff       	call   800f96 <fd_close>
  801045:	83 c4 10             	add    $0x10,%esp
}
  801048:	c9                   	leave  
  801049:	c3                   	ret    

0080104a <close_all>:

void
close_all(void)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	53                   	push   %ebx
  80104e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801051:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801056:	83 ec 0c             	sub    $0xc,%esp
  801059:	53                   	push   %ebx
  80105a:	e8 c0 ff ff ff       	call   80101f <close>
	for (i = 0; i < MAXFD; i++)
  80105f:	83 c3 01             	add    $0x1,%ebx
  801062:	83 c4 10             	add    $0x10,%esp
  801065:	83 fb 20             	cmp    $0x20,%ebx
  801068:	75 ec                	jne    801056 <close_all+0xc>
}
  80106a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    

0080106f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	57                   	push   %edi
  801073:	56                   	push   %esi
  801074:	53                   	push   %ebx
  801075:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801078:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80107b:	50                   	push   %eax
  80107c:	ff 75 08             	pushl  0x8(%ebp)
  80107f:	e8 66 fe ff ff       	call   800eea <fd_lookup>
  801084:	89 c3                	mov    %eax,%ebx
  801086:	83 c4 08             	add    $0x8,%esp
  801089:	85 c0                	test   %eax,%eax
  80108b:	0f 88 81 00 00 00    	js     801112 <dup+0xa3>
		return r;
	close(newfdnum);
  801091:	83 ec 0c             	sub    $0xc,%esp
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	e8 83 ff ff ff       	call   80101f <close>

	newfd = INDEX2FD(newfdnum);
  80109c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80109f:	c1 e6 0c             	shl    $0xc,%esi
  8010a2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010a8:	83 c4 04             	add    $0x4,%esp
  8010ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010ae:	e8 d1 fd ff ff       	call   800e84 <fd2data>
  8010b3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010b5:	89 34 24             	mov    %esi,(%esp)
  8010b8:	e8 c7 fd ff ff       	call   800e84 <fd2data>
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010c2:	89 d8                	mov    %ebx,%eax
  8010c4:	c1 e8 16             	shr    $0x16,%eax
  8010c7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010ce:	a8 01                	test   $0x1,%al
  8010d0:	74 11                	je     8010e3 <dup+0x74>
  8010d2:	89 d8                	mov    %ebx,%eax
  8010d4:	c1 e8 0c             	shr    $0xc,%eax
  8010d7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010de:	f6 c2 01             	test   $0x1,%dl
  8010e1:	75 39                	jne    80111c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010e6:	89 d0                	mov    %edx,%eax
  8010e8:	c1 e8 0c             	shr    $0xc,%eax
  8010eb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8010fa:	50                   	push   %eax
  8010fb:	56                   	push   %esi
  8010fc:	6a 00                	push   $0x0
  8010fe:	52                   	push   %edx
  8010ff:	6a 00                	push   $0x0
  801101:	e8 25 fb ff ff       	call   800c2b <sys_page_map>
  801106:	89 c3                	mov    %eax,%ebx
  801108:	83 c4 20             	add    $0x20,%esp
  80110b:	85 c0                	test   %eax,%eax
  80110d:	78 31                	js     801140 <dup+0xd1>
		goto err;

	return newfdnum;
  80110f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801112:	89 d8                	mov    %ebx,%eax
  801114:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801117:	5b                   	pop    %ebx
  801118:	5e                   	pop    %esi
  801119:	5f                   	pop    %edi
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80111c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801123:	83 ec 0c             	sub    $0xc,%esp
  801126:	25 07 0e 00 00       	and    $0xe07,%eax
  80112b:	50                   	push   %eax
  80112c:	57                   	push   %edi
  80112d:	6a 00                	push   $0x0
  80112f:	53                   	push   %ebx
  801130:	6a 00                	push   $0x0
  801132:	e8 f4 fa ff ff       	call   800c2b <sys_page_map>
  801137:	89 c3                	mov    %eax,%ebx
  801139:	83 c4 20             	add    $0x20,%esp
  80113c:	85 c0                	test   %eax,%eax
  80113e:	79 a3                	jns    8010e3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	56                   	push   %esi
  801144:	6a 00                	push   $0x0
  801146:	e8 22 fb ff ff       	call   800c6d <sys_page_unmap>
	sys_page_unmap(0, nva);
  80114b:	83 c4 08             	add    $0x8,%esp
  80114e:	57                   	push   %edi
  80114f:	6a 00                	push   $0x0
  801151:	e8 17 fb ff ff       	call   800c6d <sys_page_unmap>
	return r;
  801156:	83 c4 10             	add    $0x10,%esp
  801159:	eb b7                	jmp    801112 <dup+0xa3>

0080115b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	53                   	push   %ebx
  80115f:	83 ec 14             	sub    $0x14,%esp
  801162:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801165:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801168:	50                   	push   %eax
  801169:	53                   	push   %ebx
  80116a:	e8 7b fd ff ff       	call   800eea <fd_lookup>
  80116f:	83 c4 08             	add    $0x8,%esp
  801172:	85 c0                	test   %eax,%eax
  801174:	78 3f                	js     8011b5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80117c:	50                   	push   %eax
  80117d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801180:	ff 30                	pushl  (%eax)
  801182:	e8 b9 fd ff ff       	call   800f40 <dev_lookup>
  801187:	83 c4 10             	add    $0x10,%esp
  80118a:	85 c0                	test   %eax,%eax
  80118c:	78 27                	js     8011b5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80118e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801191:	8b 42 08             	mov    0x8(%edx),%eax
  801194:	83 e0 03             	and    $0x3,%eax
  801197:	83 f8 01             	cmp    $0x1,%eax
  80119a:	74 1e                	je     8011ba <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80119c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119f:	8b 40 08             	mov    0x8(%eax),%eax
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	74 35                	je     8011db <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011a6:	83 ec 04             	sub    $0x4,%esp
  8011a9:	ff 75 10             	pushl  0x10(%ebp)
  8011ac:	ff 75 0c             	pushl  0xc(%ebp)
  8011af:	52                   	push   %edx
  8011b0:	ff d0                	call   *%eax
  8011b2:	83 c4 10             	add    $0x10,%esp
}
  8011b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011ba:	a1 04 40 80 00       	mov    0x804004,%eax
  8011bf:	8b 40 48             	mov    0x48(%eax),%eax
  8011c2:	83 ec 04             	sub    $0x4,%esp
  8011c5:	53                   	push   %ebx
  8011c6:	50                   	push   %eax
  8011c7:	68 50 22 80 00       	push   $0x802250
  8011cc:	e8 34 f0 ff ff       	call   800205 <cprintf>
		return -E_INVAL;
  8011d1:	83 c4 10             	add    $0x10,%esp
  8011d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d9:	eb da                	jmp    8011b5 <read+0x5a>
		return -E_NOT_SUPP;
  8011db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011e0:	eb d3                	jmp    8011b5 <read+0x5a>

008011e2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	57                   	push   %edi
  8011e6:	56                   	push   %esi
  8011e7:	53                   	push   %ebx
  8011e8:	83 ec 0c             	sub    $0xc,%esp
  8011eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011ee:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f6:	39 f3                	cmp    %esi,%ebx
  8011f8:	73 25                	jae    80121f <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011fa:	83 ec 04             	sub    $0x4,%esp
  8011fd:	89 f0                	mov    %esi,%eax
  8011ff:	29 d8                	sub    %ebx,%eax
  801201:	50                   	push   %eax
  801202:	89 d8                	mov    %ebx,%eax
  801204:	03 45 0c             	add    0xc(%ebp),%eax
  801207:	50                   	push   %eax
  801208:	57                   	push   %edi
  801209:	e8 4d ff ff ff       	call   80115b <read>
		if (m < 0)
  80120e:	83 c4 10             	add    $0x10,%esp
  801211:	85 c0                	test   %eax,%eax
  801213:	78 08                	js     80121d <readn+0x3b>
			return m;
		if (m == 0)
  801215:	85 c0                	test   %eax,%eax
  801217:	74 06                	je     80121f <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801219:	01 c3                	add    %eax,%ebx
  80121b:	eb d9                	jmp    8011f6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80121d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80121f:	89 d8                	mov    %ebx,%eax
  801221:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801224:	5b                   	pop    %ebx
  801225:	5e                   	pop    %esi
  801226:	5f                   	pop    %edi
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    

00801229 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	53                   	push   %ebx
  80122d:	83 ec 14             	sub    $0x14,%esp
  801230:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801233:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801236:	50                   	push   %eax
  801237:	53                   	push   %ebx
  801238:	e8 ad fc ff ff       	call   800eea <fd_lookup>
  80123d:	83 c4 08             	add    $0x8,%esp
  801240:	85 c0                	test   %eax,%eax
  801242:	78 3a                	js     80127e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801244:	83 ec 08             	sub    $0x8,%esp
  801247:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80124a:	50                   	push   %eax
  80124b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124e:	ff 30                	pushl  (%eax)
  801250:	e8 eb fc ff ff       	call   800f40 <dev_lookup>
  801255:	83 c4 10             	add    $0x10,%esp
  801258:	85 c0                	test   %eax,%eax
  80125a:	78 22                	js     80127e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80125c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801263:	74 1e                	je     801283 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801265:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801268:	8b 52 0c             	mov    0xc(%edx),%edx
  80126b:	85 d2                	test   %edx,%edx
  80126d:	74 35                	je     8012a4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80126f:	83 ec 04             	sub    $0x4,%esp
  801272:	ff 75 10             	pushl  0x10(%ebp)
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	50                   	push   %eax
  801279:	ff d2                	call   *%edx
  80127b:	83 c4 10             	add    $0x10,%esp
}
  80127e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801281:	c9                   	leave  
  801282:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801283:	a1 04 40 80 00       	mov    0x804004,%eax
  801288:	8b 40 48             	mov    0x48(%eax),%eax
  80128b:	83 ec 04             	sub    $0x4,%esp
  80128e:	53                   	push   %ebx
  80128f:	50                   	push   %eax
  801290:	68 6c 22 80 00       	push   $0x80226c
  801295:	e8 6b ef ff ff       	call   800205 <cprintf>
		return -E_INVAL;
  80129a:	83 c4 10             	add    $0x10,%esp
  80129d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a2:	eb da                	jmp    80127e <write+0x55>
		return -E_NOT_SUPP;
  8012a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a9:	eb d3                	jmp    80127e <write+0x55>

008012ab <seek>:

int
seek(int fdnum, off_t offset)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012b1:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012b4:	50                   	push   %eax
  8012b5:	ff 75 08             	pushl  0x8(%ebp)
  8012b8:	e8 2d fc ff ff       	call   800eea <fd_lookup>
  8012bd:	83 c4 08             	add    $0x8,%esp
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	78 0e                	js     8012d2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ca:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	53                   	push   %ebx
  8012d8:	83 ec 14             	sub    $0x14,%esp
  8012db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e1:	50                   	push   %eax
  8012e2:	53                   	push   %ebx
  8012e3:	e8 02 fc ff ff       	call   800eea <fd_lookup>
  8012e8:	83 c4 08             	add    $0x8,%esp
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	78 37                	js     801326 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ef:	83 ec 08             	sub    $0x8,%esp
  8012f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f5:	50                   	push   %eax
  8012f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f9:	ff 30                	pushl  (%eax)
  8012fb:	e8 40 fc ff ff       	call   800f40 <dev_lookup>
  801300:	83 c4 10             	add    $0x10,%esp
  801303:	85 c0                	test   %eax,%eax
  801305:	78 1f                	js     801326 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80130e:	74 1b                	je     80132b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801310:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801313:	8b 52 18             	mov    0x18(%edx),%edx
  801316:	85 d2                	test   %edx,%edx
  801318:	74 32                	je     80134c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80131a:	83 ec 08             	sub    $0x8,%esp
  80131d:	ff 75 0c             	pushl  0xc(%ebp)
  801320:	50                   	push   %eax
  801321:	ff d2                	call   *%edx
  801323:	83 c4 10             	add    $0x10,%esp
}
  801326:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801329:	c9                   	leave  
  80132a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80132b:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801330:	8b 40 48             	mov    0x48(%eax),%eax
  801333:	83 ec 04             	sub    $0x4,%esp
  801336:	53                   	push   %ebx
  801337:	50                   	push   %eax
  801338:	68 2c 22 80 00       	push   $0x80222c
  80133d:	e8 c3 ee ff ff       	call   800205 <cprintf>
		return -E_INVAL;
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134a:	eb da                	jmp    801326 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80134c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801351:	eb d3                	jmp    801326 <ftruncate+0x52>

00801353 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	53                   	push   %ebx
  801357:	83 ec 14             	sub    $0x14,%esp
  80135a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80135d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801360:	50                   	push   %eax
  801361:	ff 75 08             	pushl  0x8(%ebp)
  801364:	e8 81 fb ff ff       	call   800eea <fd_lookup>
  801369:	83 c4 08             	add    $0x8,%esp
  80136c:	85 c0                	test   %eax,%eax
  80136e:	78 4b                	js     8013bb <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801376:	50                   	push   %eax
  801377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137a:	ff 30                	pushl  (%eax)
  80137c:	e8 bf fb ff ff       	call   800f40 <dev_lookup>
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	78 33                	js     8013bb <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80138f:	74 2f                	je     8013c0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801391:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801394:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80139b:	00 00 00 
	stat->st_isdir = 0;
  80139e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013a5:	00 00 00 
	stat->st_dev = dev;
  8013a8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013ae:	83 ec 08             	sub    $0x8,%esp
  8013b1:	53                   	push   %ebx
  8013b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8013b5:	ff 50 14             	call   *0x14(%eax)
  8013b8:	83 c4 10             	add    $0x10,%esp
}
  8013bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    
		return -E_NOT_SUPP;
  8013c0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c5:	eb f4                	jmp    8013bb <fstat+0x68>

008013c7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	56                   	push   %esi
  8013cb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013cc:	83 ec 08             	sub    $0x8,%esp
  8013cf:	6a 00                	push   $0x0
  8013d1:	ff 75 08             	pushl  0x8(%ebp)
  8013d4:	e8 e7 01 00 00       	call   8015c0 <open>
  8013d9:	89 c3                	mov    %eax,%ebx
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 1b                	js     8013fd <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	ff 75 0c             	pushl  0xc(%ebp)
  8013e8:	50                   	push   %eax
  8013e9:	e8 65 ff ff ff       	call   801353 <fstat>
  8013ee:	89 c6                	mov    %eax,%esi
	close(fd);
  8013f0:	89 1c 24             	mov    %ebx,(%esp)
  8013f3:	e8 27 fc ff ff       	call   80101f <close>
	return r;
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	89 f3                	mov    %esi,%ebx
}
  8013fd:	89 d8                	mov    %ebx,%eax
  8013ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801402:	5b                   	pop    %ebx
  801403:	5e                   	pop    %esi
  801404:	5d                   	pop    %ebp
  801405:	c3                   	ret    

00801406 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	56                   	push   %esi
  80140a:	53                   	push   %ebx
  80140b:	89 c6                	mov    %eax,%esi
  80140d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80140f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801416:	74 27                	je     80143f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801418:	6a 07                	push   $0x7
  80141a:	68 00 50 80 00       	push   $0x805000
  80141f:	56                   	push   %esi
  801420:	ff 35 00 40 80 00    	pushl  0x804000
  801426:	e8 1b 07 00 00       	call   801b46 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80142b:	83 c4 0c             	add    $0xc,%esp
  80142e:	6a 00                	push   $0x0
  801430:	53                   	push   %ebx
  801431:	6a 00                	push   $0x0
  801433:	e8 f7 06 00 00       	call   801b2f <ipc_recv>
}
  801438:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80143b:	5b                   	pop    %ebx
  80143c:	5e                   	pop    %esi
  80143d:	5d                   	pop    %ebp
  80143e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80143f:	83 ec 0c             	sub    $0xc,%esp
  801442:	6a 01                	push   $0x1
  801444:	e8 14 07 00 00       	call   801b5d <ipc_find_env>
  801449:	a3 00 40 80 00       	mov    %eax,0x804000
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	eb c5                	jmp    801418 <fsipc+0x12>

00801453 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8b 40 0c             	mov    0xc(%eax),%eax
  80145f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801464:	8b 45 0c             	mov    0xc(%ebp),%eax
  801467:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80146c:	ba 00 00 00 00       	mov    $0x0,%edx
  801471:	b8 02 00 00 00       	mov    $0x2,%eax
  801476:	e8 8b ff ff ff       	call   801406 <fsipc>
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <devfile_flush>:
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
  801480:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	8b 40 0c             	mov    0xc(%eax),%eax
  801489:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80148e:	ba 00 00 00 00       	mov    $0x0,%edx
  801493:	b8 06 00 00 00       	mov    $0x6,%eax
  801498:	e8 69 ff ff ff       	call   801406 <fsipc>
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <devfile_stat>:
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	53                   	push   %ebx
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8014af:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b9:	b8 05 00 00 00       	mov    $0x5,%eax
  8014be:	e8 43 ff ff ff       	call   801406 <fsipc>
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	78 2c                	js     8014f3 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014c7:	83 ec 08             	sub    $0x8,%esp
  8014ca:	68 00 50 80 00       	push   $0x805000
  8014cf:	53                   	push   %ebx
  8014d0:	e8 1a f3 ff ff       	call   8007ef <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014d5:	a1 80 50 80 00       	mov    0x805080,%eax
  8014da:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014e0:	a1 84 50 80 00       	mov    0x805084,%eax
  8014e5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <devfile_write>:
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801501:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801506:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80150b:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80150e:	8b 55 08             	mov    0x8(%ebp),%edx
  801511:	8b 52 0c             	mov    0xc(%edx),%edx
  801514:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  80151a:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  80151f:	50                   	push   %eax
  801520:	ff 75 0c             	pushl  0xc(%ebp)
  801523:	68 08 50 80 00       	push   $0x805008
  801528:	e8 50 f4 ff ff       	call   80097d <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80152d:	ba 00 00 00 00       	mov    $0x0,%edx
  801532:	b8 04 00 00 00       	mov    $0x4,%eax
  801537:	e8 ca fe ff ff       	call   801406 <fsipc>
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <devfile_read>:
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	56                   	push   %esi
  801542:	53                   	push   %ebx
  801543:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8b 40 0c             	mov    0xc(%eax),%eax
  80154c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801551:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801557:	ba 00 00 00 00       	mov    $0x0,%edx
  80155c:	b8 03 00 00 00       	mov    $0x3,%eax
  801561:	e8 a0 fe ff ff       	call   801406 <fsipc>
  801566:	89 c3                	mov    %eax,%ebx
  801568:	85 c0                	test   %eax,%eax
  80156a:	78 1f                	js     80158b <devfile_read+0x4d>
	assert(r <= n);
  80156c:	39 f0                	cmp    %esi,%eax
  80156e:	77 24                	ja     801594 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801570:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801575:	7f 33                	jg     8015aa <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801577:	83 ec 04             	sub    $0x4,%esp
  80157a:	50                   	push   %eax
  80157b:	68 00 50 80 00       	push   $0x805000
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	e8 f5 f3 ff ff       	call   80097d <memmove>
	return r;
  801588:	83 c4 10             	add    $0x10,%esp
}
  80158b:	89 d8                	mov    %ebx,%eax
  80158d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801590:	5b                   	pop    %ebx
  801591:	5e                   	pop    %esi
  801592:	5d                   	pop    %ebp
  801593:	c3                   	ret    
	assert(r <= n);
  801594:	68 9c 22 80 00       	push   $0x80229c
  801599:	68 a3 22 80 00       	push   $0x8022a3
  80159e:	6a 7c                	push   $0x7c
  8015a0:	68 b8 22 80 00       	push   $0x8022b8
  8015a5:	e8 80 eb ff ff       	call   80012a <_panic>
	assert(r <= PGSIZE);
  8015aa:	68 c3 22 80 00       	push   $0x8022c3
  8015af:	68 a3 22 80 00       	push   $0x8022a3
  8015b4:	6a 7d                	push   $0x7d
  8015b6:	68 b8 22 80 00       	push   $0x8022b8
  8015bb:	e8 6a eb ff ff       	call   80012a <_panic>

008015c0 <open>:
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	56                   	push   %esi
  8015c4:	53                   	push   %ebx
  8015c5:	83 ec 1c             	sub    $0x1c,%esp
  8015c8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015cb:	56                   	push   %esi
  8015cc:	e8 e7 f1 ff ff       	call   8007b8 <strlen>
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015d9:	7f 6c                	jg     801647 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015db:	83 ec 0c             	sub    $0xc,%esp
  8015de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e1:	50                   	push   %eax
  8015e2:	e8 b4 f8 ff ff       	call   800e9b <fd_alloc>
  8015e7:	89 c3                	mov    %eax,%ebx
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	78 3c                	js     80162c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015f0:	83 ec 08             	sub    $0x8,%esp
  8015f3:	56                   	push   %esi
  8015f4:	68 00 50 80 00       	push   $0x805000
  8015f9:	e8 f1 f1 ff ff       	call   8007ef <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801601:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801606:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801609:	b8 01 00 00 00       	mov    $0x1,%eax
  80160e:	e8 f3 fd ff ff       	call   801406 <fsipc>
  801613:	89 c3                	mov    %eax,%ebx
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 19                	js     801635 <open+0x75>
	return fd2num(fd);
  80161c:	83 ec 0c             	sub    $0xc,%esp
  80161f:	ff 75 f4             	pushl  -0xc(%ebp)
  801622:	e8 4d f8 ff ff       	call   800e74 <fd2num>
  801627:	89 c3                	mov    %eax,%ebx
  801629:	83 c4 10             	add    $0x10,%esp
}
  80162c:	89 d8                	mov    %ebx,%eax
  80162e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801631:	5b                   	pop    %ebx
  801632:	5e                   	pop    %esi
  801633:	5d                   	pop    %ebp
  801634:	c3                   	ret    
		fd_close(fd, 0);
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	6a 00                	push   $0x0
  80163a:	ff 75 f4             	pushl  -0xc(%ebp)
  80163d:	e8 54 f9 ff ff       	call   800f96 <fd_close>
		return r;
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	eb e5                	jmp    80162c <open+0x6c>
		return -E_BAD_PATH;
  801647:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80164c:	eb de                	jmp    80162c <open+0x6c>

0080164e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801654:	ba 00 00 00 00       	mov    $0x0,%edx
  801659:	b8 08 00 00 00       	mov    $0x8,%eax
  80165e:	e8 a3 fd ff ff       	call   801406 <fsipc>
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	56                   	push   %esi
  801669:	53                   	push   %ebx
  80166a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80166d:	83 ec 0c             	sub    $0xc,%esp
  801670:	ff 75 08             	pushl  0x8(%ebp)
  801673:	e8 0c f8 ff ff       	call   800e84 <fd2data>
  801678:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80167a:	83 c4 08             	add    $0x8,%esp
  80167d:	68 cf 22 80 00       	push   $0x8022cf
  801682:	53                   	push   %ebx
  801683:	e8 67 f1 ff ff       	call   8007ef <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801688:	8b 46 04             	mov    0x4(%esi),%eax
  80168b:	2b 06                	sub    (%esi),%eax
  80168d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801693:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80169a:	00 00 00 
	stat->st_dev = &devpipe;
  80169d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8016a4:	30 80 00 
	return 0;
}
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016af:	5b                   	pop    %ebx
  8016b0:	5e                   	pop    %esi
  8016b1:	5d                   	pop    %ebp
  8016b2:	c3                   	ret    

008016b3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	53                   	push   %ebx
  8016b7:	83 ec 0c             	sub    $0xc,%esp
  8016ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8016bd:	53                   	push   %ebx
  8016be:	6a 00                	push   $0x0
  8016c0:	e8 a8 f5 ff ff       	call   800c6d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8016c5:	89 1c 24             	mov    %ebx,(%esp)
  8016c8:	e8 b7 f7 ff ff       	call   800e84 <fd2data>
  8016cd:	83 c4 08             	add    $0x8,%esp
  8016d0:	50                   	push   %eax
  8016d1:	6a 00                	push   $0x0
  8016d3:	e8 95 f5 ff ff       	call   800c6d <sys_page_unmap>
}
  8016d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <_pipeisclosed>:
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	57                   	push   %edi
  8016e1:	56                   	push   %esi
  8016e2:	53                   	push   %ebx
  8016e3:	83 ec 1c             	sub    $0x1c,%esp
  8016e6:	89 c7                	mov    %eax,%edi
  8016e8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8016ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8016ef:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8016f2:	83 ec 0c             	sub    $0xc,%esp
  8016f5:	57                   	push   %edi
  8016f6:	e8 9b 04 00 00       	call   801b96 <pageref>
  8016fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8016fe:	89 34 24             	mov    %esi,(%esp)
  801701:	e8 90 04 00 00       	call   801b96 <pageref>
		nn = thisenv->env_runs;
  801706:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80170c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	39 cb                	cmp    %ecx,%ebx
  801714:	74 1b                	je     801731 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801716:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801719:	75 cf                	jne    8016ea <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80171b:	8b 42 58             	mov    0x58(%edx),%eax
  80171e:	6a 01                	push   $0x1
  801720:	50                   	push   %eax
  801721:	53                   	push   %ebx
  801722:	68 d6 22 80 00       	push   $0x8022d6
  801727:	e8 d9 ea ff ff       	call   800205 <cprintf>
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	eb b9                	jmp    8016ea <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801731:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801734:	0f 94 c0             	sete   %al
  801737:	0f b6 c0             	movzbl %al,%eax
}
  80173a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5e                   	pop    %esi
  80173f:	5f                   	pop    %edi
  801740:	5d                   	pop    %ebp
  801741:	c3                   	ret    

00801742 <devpipe_write>:
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	57                   	push   %edi
  801746:	56                   	push   %esi
  801747:	53                   	push   %ebx
  801748:	83 ec 28             	sub    $0x28,%esp
  80174b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80174e:	56                   	push   %esi
  80174f:	e8 30 f7 ff ff       	call   800e84 <fd2data>
  801754:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	bf 00 00 00 00       	mov    $0x0,%edi
  80175e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801761:	74 4f                	je     8017b2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801763:	8b 43 04             	mov    0x4(%ebx),%eax
  801766:	8b 0b                	mov    (%ebx),%ecx
  801768:	8d 51 20             	lea    0x20(%ecx),%edx
  80176b:	39 d0                	cmp    %edx,%eax
  80176d:	72 14                	jb     801783 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80176f:	89 da                	mov    %ebx,%edx
  801771:	89 f0                	mov    %esi,%eax
  801773:	e8 65 ff ff ff       	call   8016dd <_pipeisclosed>
  801778:	85 c0                	test   %eax,%eax
  80177a:	75 3a                	jne    8017b6 <devpipe_write+0x74>
			sys_yield();
  80177c:	e8 48 f4 ff ff       	call   800bc9 <sys_yield>
  801781:	eb e0                	jmp    801763 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801783:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801786:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80178a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80178d:	89 c2                	mov    %eax,%edx
  80178f:	c1 fa 1f             	sar    $0x1f,%edx
  801792:	89 d1                	mov    %edx,%ecx
  801794:	c1 e9 1b             	shr    $0x1b,%ecx
  801797:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80179a:	83 e2 1f             	and    $0x1f,%edx
  80179d:	29 ca                	sub    %ecx,%edx
  80179f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8017a3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8017a7:	83 c0 01             	add    $0x1,%eax
  8017aa:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8017ad:	83 c7 01             	add    $0x1,%edi
  8017b0:	eb ac                	jmp    80175e <devpipe_write+0x1c>
	return i;
  8017b2:	89 f8                	mov    %edi,%eax
  8017b4:	eb 05                	jmp    8017bb <devpipe_write+0x79>
				return 0;
  8017b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017be:	5b                   	pop    %ebx
  8017bf:	5e                   	pop    %esi
  8017c0:	5f                   	pop    %edi
  8017c1:	5d                   	pop    %ebp
  8017c2:	c3                   	ret    

008017c3 <devpipe_read>:
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	57                   	push   %edi
  8017c7:	56                   	push   %esi
  8017c8:	53                   	push   %ebx
  8017c9:	83 ec 18             	sub    $0x18,%esp
  8017cc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8017cf:	57                   	push   %edi
  8017d0:	e8 af f6 ff ff       	call   800e84 <fd2data>
  8017d5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	be 00 00 00 00       	mov    $0x0,%esi
  8017df:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017e2:	74 47                	je     80182b <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8017e4:	8b 03                	mov    (%ebx),%eax
  8017e6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8017e9:	75 22                	jne    80180d <devpipe_read+0x4a>
			if (i > 0)
  8017eb:	85 f6                	test   %esi,%esi
  8017ed:	75 14                	jne    801803 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8017ef:	89 da                	mov    %ebx,%edx
  8017f1:	89 f8                	mov    %edi,%eax
  8017f3:	e8 e5 fe ff ff       	call   8016dd <_pipeisclosed>
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	75 33                	jne    80182f <devpipe_read+0x6c>
			sys_yield();
  8017fc:	e8 c8 f3 ff ff       	call   800bc9 <sys_yield>
  801801:	eb e1                	jmp    8017e4 <devpipe_read+0x21>
				return i;
  801803:	89 f0                	mov    %esi,%eax
}
  801805:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801808:	5b                   	pop    %ebx
  801809:	5e                   	pop    %esi
  80180a:	5f                   	pop    %edi
  80180b:	5d                   	pop    %ebp
  80180c:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80180d:	99                   	cltd   
  80180e:	c1 ea 1b             	shr    $0x1b,%edx
  801811:	01 d0                	add    %edx,%eax
  801813:	83 e0 1f             	and    $0x1f,%eax
  801816:	29 d0                	sub    %edx,%eax
  801818:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80181d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801820:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801823:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801826:	83 c6 01             	add    $0x1,%esi
  801829:	eb b4                	jmp    8017df <devpipe_read+0x1c>
	return i;
  80182b:	89 f0                	mov    %esi,%eax
  80182d:	eb d6                	jmp    801805 <devpipe_read+0x42>
				return 0;
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
  801834:	eb cf                	jmp    801805 <devpipe_read+0x42>

00801836 <pipe>:
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	56                   	push   %esi
  80183a:	53                   	push   %ebx
  80183b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80183e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801841:	50                   	push   %eax
  801842:	e8 54 f6 ff ff       	call   800e9b <fd_alloc>
  801847:	89 c3                	mov    %eax,%ebx
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	85 c0                	test   %eax,%eax
  80184e:	78 5b                	js     8018ab <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	68 07 04 00 00       	push   $0x407
  801858:	ff 75 f4             	pushl  -0xc(%ebp)
  80185b:	6a 00                	push   $0x0
  80185d:	e8 86 f3 ff ff       	call   800be8 <sys_page_alloc>
  801862:	89 c3                	mov    %eax,%ebx
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 40                	js     8018ab <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80186b:	83 ec 0c             	sub    $0xc,%esp
  80186e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801871:	50                   	push   %eax
  801872:	e8 24 f6 ff ff       	call   800e9b <fd_alloc>
  801877:	89 c3                	mov    %eax,%ebx
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	85 c0                	test   %eax,%eax
  80187e:	78 1b                	js     80189b <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801880:	83 ec 04             	sub    $0x4,%esp
  801883:	68 07 04 00 00       	push   $0x407
  801888:	ff 75 f0             	pushl  -0x10(%ebp)
  80188b:	6a 00                	push   $0x0
  80188d:	e8 56 f3 ff ff       	call   800be8 <sys_page_alloc>
  801892:	89 c3                	mov    %eax,%ebx
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	85 c0                	test   %eax,%eax
  801899:	79 19                	jns    8018b4 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80189b:	83 ec 08             	sub    $0x8,%esp
  80189e:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a1:	6a 00                	push   $0x0
  8018a3:	e8 c5 f3 ff ff       	call   800c6d <sys_page_unmap>
  8018a8:	83 c4 10             	add    $0x10,%esp
}
  8018ab:	89 d8                	mov    %ebx,%eax
  8018ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b0:	5b                   	pop    %ebx
  8018b1:	5e                   	pop    %esi
  8018b2:	5d                   	pop    %ebp
  8018b3:	c3                   	ret    
	va = fd2data(fd0);
  8018b4:	83 ec 0c             	sub    $0xc,%esp
  8018b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ba:	e8 c5 f5 ff ff       	call   800e84 <fd2data>
  8018bf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018c1:	83 c4 0c             	add    $0xc,%esp
  8018c4:	68 07 04 00 00       	push   $0x407
  8018c9:	50                   	push   %eax
  8018ca:	6a 00                	push   $0x0
  8018cc:	e8 17 f3 ff ff       	call   800be8 <sys_page_alloc>
  8018d1:	89 c3                	mov    %eax,%ebx
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	0f 88 8c 00 00 00    	js     80196a <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018de:	83 ec 0c             	sub    $0xc,%esp
  8018e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e4:	e8 9b f5 ff ff       	call   800e84 <fd2data>
  8018e9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018f0:	50                   	push   %eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	56                   	push   %esi
  8018f4:	6a 00                	push   $0x0
  8018f6:	e8 30 f3 ff ff       	call   800c2b <sys_page_map>
  8018fb:	89 c3                	mov    %eax,%ebx
  8018fd:	83 c4 20             	add    $0x20,%esp
  801900:	85 c0                	test   %eax,%eax
  801902:	78 58                	js     80195c <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801907:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80190d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80190f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801912:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801922:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801927:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	ff 75 f4             	pushl  -0xc(%ebp)
  801934:	e8 3b f5 ff ff       	call   800e74 <fd2num>
  801939:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80193e:	83 c4 04             	add    $0x4,%esp
  801941:	ff 75 f0             	pushl  -0x10(%ebp)
  801944:	e8 2b f5 ff ff       	call   800e74 <fd2num>
  801949:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80194c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80194f:	83 c4 10             	add    $0x10,%esp
  801952:	bb 00 00 00 00       	mov    $0x0,%ebx
  801957:	e9 4f ff ff ff       	jmp    8018ab <pipe+0x75>
	sys_page_unmap(0, va);
  80195c:	83 ec 08             	sub    $0x8,%esp
  80195f:	56                   	push   %esi
  801960:	6a 00                	push   $0x0
  801962:	e8 06 f3 ff ff       	call   800c6d <sys_page_unmap>
  801967:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	ff 75 f0             	pushl  -0x10(%ebp)
  801970:	6a 00                	push   $0x0
  801972:	e8 f6 f2 ff ff       	call   800c6d <sys_page_unmap>
  801977:	83 c4 10             	add    $0x10,%esp
  80197a:	e9 1c ff ff ff       	jmp    80189b <pipe+0x65>

0080197f <pipeisclosed>:
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801985:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801988:	50                   	push   %eax
  801989:	ff 75 08             	pushl  0x8(%ebp)
  80198c:	e8 59 f5 ff ff       	call   800eea <fd_lookup>
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	85 c0                	test   %eax,%eax
  801996:	78 18                	js     8019b0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801998:	83 ec 0c             	sub    $0xc,%esp
  80199b:	ff 75 f4             	pushl  -0xc(%ebp)
  80199e:	e8 e1 f4 ff ff       	call   800e84 <fd2data>
	return _pipeisclosed(fd, p);
  8019a3:	89 c2                	mov    %eax,%edx
  8019a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a8:	e8 30 fd ff ff       	call   8016dd <_pipeisclosed>
  8019ad:	83 c4 10             	add    $0x10,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8019b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    

008019bc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8019c2:	68 ee 22 80 00       	push   $0x8022ee
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	e8 20 ee ff ff       	call   8007ef <strcpy>
	return 0;
}
  8019cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <devcons_write>:
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	57                   	push   %edi
  8019da:	56                   	push   %esi
  8019db:	53                   	push   %ebx
  8019dc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8019e2:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8019e7:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8019ed:	eb 2f                	jmp    801a1e <devcons_write+0x48>
		m = n - tot;
  8019ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019f2:	29 f3                	sub    %esi,%ebx
  8019f4:	83 fb 7f             	cmp    $0x7f,%ebx
  8019f7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8019fc:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	53                   	push   %ebx
  801a03:	89 f0                	mov    %esi,%eax
  801a05:	03 45 0c             	add    0xc(%ebp),%eax
  801a08:	50                   	push   %eax
  801a09:	57                   	push   %edi
  801a0a:	e8 6e ef ff ff       	call   80097d <memmove>
		sys_cputs(buf, m);
  801a0f:	83 c4 08             	add    $0x8,%esp
  801a12:	53                   	push   %ebx
  801a13:	57                   	push   %edi
  801a14:	e8 13 f1 ff ff       	call   800b2c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801a19:	01 de                	add    %ebx,%esi
  801a1b:	83 c4 10             	add    $0x10,%esp
  801a1e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a21:	72 cc                	jb     8019ef <devcons_write+0x19>
}
  801a23:	89 f0                	mov    %esi,%eax
  801a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a28:	5b                   	pop    %ebx
  801a29:	5e                   	pop    %esi
  801a2a:	5f                   	pop    %edi
  801a2b:	5d                   	pop    %ebp
  801a2c:	c3                   	ret    

00801a2d <devcons_read>:
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	83 ec 08             	sub    $0x8,%esp
  801a33:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801a38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a3c:	75 07                	jne    801a45 <devcons_read+0x18>
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    
		sys_yield();
  801a40:	e8 84 f1 ff ff       	call   800bc9 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801a45:	e8 00 f1 ff ff       	call   800b4a <sys_cgetc>
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	74 f2                	je     801a40 <devcons_read+0x13>
	if (c < 0)
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	78 ec                	js     801a3e <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801a52:	83 f8 04             	cmp    $0x4,%eax
  801a55:	74 0c                	je     801a63 <devcons_read+0x36>
	*(char*)vbuf = c;
  801a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5a:	88 02                	mov    %al,(%edx)
	return 1;
  801a5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801a61:	eb db                	jmp    801a3e <devcons_read+0x11>
		return 0;
  801a63:	b8 00 00 00 00       	mov    $0x0,%eax
  801a68:	eb d4                	jmp    801a3e <devcons_read+0x11>

00801a6a <cputchar>:
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a76:	6a 01                	push   $0x1
  801a78:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a7b:	50                   	push   %eax
  801a7c:	e8 ab f0 ff ff       	call   800b2c <sys_cputs>
}
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <getchar>:
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a8c:	6a 01                	push   $0x1
  801a8e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a91:	50                   	push   %eax
  801a92:	6a 00                	push   $0x0
  801a94:	e8 c2 f6 ff ff       	call   80115b <read>
	if (r < 0)
  801a99:	83 c4 10             	add    $0x10,%esp
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	78 08                	js     801aa8 <getchar+0x22>
	if (r < 1)
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	7e 06                	jle    801aaa <getchar+0x24>
	return c;
  801aa4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    
		return -E_EOF;
  801aaa:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801aaf:	eb f7                	jmp    801aa8 <getchar+0x22>

00801ab1 <iscons>:
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ab7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aba:	50                   	push   %eax
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	e8 27 f4 ff ff       	call   800eea <fd_lookup>
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	78 11                	js     801adb <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ad3:	39 10                	cmp    %edx,(%eax)
  801ad5:	0f 94 c0             	sete   %al
  801ad8:	0f b6 c0             	movzbl %al,%eax
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <opencons>:
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801ae3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae6:	50                   	push   %eax
  801ae7:	e8 af f3 ff ff       	call   800e9b <fd_alloc>
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 3a                	js     801b2d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	68 07 04 00 00       	push   $0x407
  801afb:	ff 75 f4             	pushl  -0xc(%ebp)
  801afe:	6a 00                	push   $0x0
  801b00:	e8 e3 f0 ff ff       	call   800be8 <sys_page_alloc>
  801b05:	83 c4 10             	add    $0x10,%esp
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	78 21                	js     801b2d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b15:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801b21:	83 ec 0c             	sub    $0xc,%esp
  801b24:	50                   	push   %eax
  801b25:	e8 4a f3 ff ff       	call   800e74 <fd2num>
  801b2a:	83 c4 10             	add    $0x10,%esp
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801b35:	68 fa 22 80 00       	push   $0x8022fa
  801b3a:	6a 1a                	push   $0x1a
  801b3c:	68 13 23 80 00       	push   $0x802313
  801b41:	e8 e4 e5 ff ff       	call   80012a <_panic>

00801b46 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801b4c:	68 1d 23 80 00       	push   $0x80231d
  801b51:	6a 2a                	push   $0x2a
  801b53:	68 13 23 80 00       	push   $0x802313
  801b58:	e8 cd e5 ff ff       	call   80012a <_panic>

00801b5d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b63:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b68:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b6b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b71:	8b 52 50             	mov    0x50(%edx),%edx
  801b74:	39 ca                	cmp    %ecx,%edx
  801b76:	74 11                	je     801b89 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801b78:	83 c0 01             	add    $0x1,%eax
  801b7b:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b80:	75 e6                	jne    801b68 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801b82:	b8 00 00 00 00       	mov    $0x0,%eax
  801b87:	eb 0b                	jmp    801b94 <ipc_find_env+0x37>
			return envs[i].env_id;
  801b89:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b8c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b91:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b94:	5d                   	pop    %ebp
  801b95:	c3                   	ret    

00801b96 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b9c:	89 d0                	mov    %edx,%eax
  801b9e:	c1 e8 16             	shr    $0x16,%eax
  801ba1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ba8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801bad:	f6 c1 01             	test   $0x1,%cl
  801bb0:	74 1d                	je     801bcf <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801bb2:	c1 ea 0c             	shr    $0xc,%edx
  801bb5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801bbc:	f6 c2 01             	test   $0x1,%dl
  801bbf:	74 0e                	je     801bcf <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801bc1:	c1 ea 0c             	shr    $0xc,%edx
  801bc4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801bcb:	ef 
  801bcc:	0f b7 c0             	movzwl %ax,%eax
}
  801bcf:	5d                   	pop    %ebp
  801bd0:	c3                   	ret    
  801bd1:	66 90                	xchg   %ax,%ax
  801bd3:	66 90                	xchg   %ax,%ax
  801bd5:	66 90                	xchg   %ax,%ax
  801bd7:	66 90                	xchg   %ax,%ax
  801bd9:	66 90                	xchg   %ax,%ax
  801bdb:	66 90                	xchg   %ax,%ax
  801bdd:	66 90                	xchg   %ax,%ax
  801bdf:	90                   	nop

00801be0 <__udivdi3>:
  801be0:	55                   	push   %ebp
  801be1:	57                   	push   %edi
  801be2:	56                   	push   %esi
  801be3:	53                   	push   %ebx
  801be4:	83 ec 1c             	sub    $0x1c,%esp
  801be7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801beb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801bef:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bf3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801bf7:	85 d2                	test   %edx,%edx
  801bf9:	75 35                	jne    801c30 <__udivdi3+0x50>
  801bfb:	39 f3                	cmp    %esi,%ebx
  801bfd:	0f 87 bd 00 00 00    	ja     801cc0 <__udivdi3+0xe0>
  801c03:	85 db                	test   %ebx,%ebx
  801c05:	89 d9                	mov    %ebx,%ecx
  801c07:	75 0b                	jne    801c14 <__udivdi3+0x34>
  801c09:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0e:	31 d2                	xor    %edx,%edx
  801c10:	f7 f3                	div    %ebx
  801c12:	89 c1                	mov    %eax,%ecx
  801c14:	31 d2                	xor    %edx,%edx
  801c16:	89 f0                	mov    %esi,%eax
  801c18:	f7 f1                	div    %ecx
  801c1a:	89 c6                	mov    %eax,%esi
  801c1c:	89 e8                	mov    %ebp,%eax
  801c1e:	89 f7                	mov    %esi,%edi
  801c20:	f7 f1                	div    %ecx
  801c22:	89 fa                	mov    %edi,%edx
  801c24:	83 c4 1c             	add    $0x1c,%esp
  801c27:	5b                   	pop    %ebx
  801c28:	5e                   	pop    %esi
  801c29:	5f                   	pop    %edi
  801c2a:	5d                   	pop    %ebp
  801c2b:	c3                   	ret    
  801c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801c30:	39 f2                	cmp    %esi,%edx
  801c32:	77 7c                	ja     801cb0 <__udivdi3+0xd0>
  801c34:	0f bd fa             	bsr    %edx,%edi
  801c37:	83 f7 1f             	xor    $0x1f,%edi
  801c3a:	0f 84 98 00 00 00    	je     801cd8 <__udivdi3+0xf8>
  801c40:	89 f9                	mov    %edi,%ecx
  801c42:	b8 20 00 00 00       	mov    $0x20,%eax
  801c47:	29 f8                	sub    %edi,%eax
  801c49:	d3 e2                	shl    %cl,%edx
  801c4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c4f:	89 c1                	mov    %eax,%ecx
  801c51:	89 da                	mov    %ebx,%edx
  801c53:	d3 ea                	shr    %cl,%edx
  801c55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801c59:	09 d1                	or     %edx,%ecx
  801c5b:	89 f2                	mov    %esi,%edx
  801c5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c61:	89 f9                	mov    %edi,%ecx
  801c63:	d3 e3                	shl    %cl,%ebx
  801c65:	89 c1                	mov    %eax,%ecx
  801c67:	d3 ea                	shr    %cl,%edx
  801c69:	89 f9                	mov    %edi,%ecx
  801c6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801c6f:	d3 e6                	shl    %cl,%esi
  801c71:	89 eb                	mov    %ebp,%ebx
  801c73:	89 c1                	mov    %eax,%ecx
  801c75:	d3 eb                	shr    %cl,%ebx
  801c77:	09 de                	or     %ebx,%esi
  801c79:	89 f0                	mov    %esi,%eax
  801c7b:	f7 74 24 08          	divl   0x8(%esp)
  801c7f:	89 d6                	mov    %edx,%esi
  801c81:	89 c3                	mov    %eax,%ebx
  801c83:	f7 64 24 0c          	mull   0xc(%esp)
  801c87:	39 d6                	cmp    %edx,%esi
  801c89:	72 0c                	jb     801c97 <__udivdi3+0xb7>
  801c8b:	89 f9                	mov    %edi,%ecx
  801c8d:	d3 e5                	shl    %cl,%ebp
  801c8f:	39 c5                	cmp    %eax,%ebp
  801c91:	73 5d                	jae    801cf0 <__udivdi3+0x110>
  801c93:	39 d6                	cmp    %edx,%esi
  801c95:	75 59                	jne    801cf0 <__udivdi3+0x110>
  801c97:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c9a:	31 ff                	xor    %edi,%edi
  801c9c:	89 fa                	mov    %edi,%edx
  801c9e:	83 c4 1c             	add    $0x1c,%esp
  801ca1:	5b                   	pop    %ebx
  801ca2:	5e                   	pop    %esi
  801ca3:	5f                   	pop    %edi
  801ca4:	5d                   	pop    %ebp
  801ca5:	c3                   	ret    
  801ca6:	8d 76 00             	lea    0x0(%esi),%esi
  801ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801cb0:	31 ff                	xor    %edi,%edi
  801cb2:	31 c0                	xor    %eax,%eax
  801cb4:	89 fa                	mov    %edi,%edx
  801cb6:	83 c4 1c             	add    $0x1c,%esp
  801cb9:	5b                   	pop    %ebx
  801cba:	5e                   	pop    %esi
  801cbb:	5f                   	pop    %edi
  801cbc:	5d                   	pop    %ebp
  801cbd:	c3                   	ret    
  801cbe:	66 90                	xchg   %ax,%ax
  801cc0:	31 ff                	xor    %edi,%edi
  801cc2:	89 e8                	mov    %ebp,%eax
  801cc4:	89 f2                	mov    %esi,%edx
  801cc6:	f7 f3                	div    %ebx
  801cc8:	89 fa                	mov    %edi,%edx
  801cca:	83 c4 1c             	add    $0x1c,%esp
  801ccd:	5b                   	pop    %ebx
  801cce:	5e                   	pop    %esi
  801ccf:	5f                   	pop    %edi
  801cd0:	5d                   	pop    %ebp
  801cd1:	c3                   	ret    
  801cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801cd8:	39 f2                	cmp    %esi,%edx
  801cda:	72 06                	jb     801ce2 <__udivdi3+0x102>
  801cdc:	31 c0                	xor    %eax,%eax
  801cde:	39 eb                	cmp    %ebp,%ebx
  801ce0:	77 d2                	ja     801cb4 <__udivdi3+0xd4>
  801ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce7:	eb cb                	jmp    801cb4 <__udivdi3+0xd4>
  801ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cf0:	89 d8                	mov    %ebx,%eax
  801cf2:	31 ff                	xor    %edi,%edi
  801cf4:	eb be                	jmp    801cb4 <__udivdi3+0xd4>
  801cf6:	66 90                	xchg   %ax,%ax
  801cf8:	66 90                	xchg   %ax,%ax
  801cfa:	66 90                	xchg   %ax,%ax
  801cfc:	66 90                	xchg   %ax,%ax
  801cfe:	66 90                	xchg   %ax,%ax

00801d00 <__umoddi3>:
  801d00:	55                   	push   %ebp
  801d01:	57                   	push   %edi
  801d02:	56                   	push   %esi
  801d03:	53                   	push   %ebx
  801d04:	83 ec 1c             	sub    $0x1c,%esp
  801d07:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801d0b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801d0f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801d13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d17:	85 ed                	test   %ebp,%ebp
  801d19:	89 f0                	mov    %esi,%eax
  801d1b:	89 da                	mov    %ebx,%edx
  801d1d:	75 19                	jne    801d38 <__umoddi3+0x38>
  801d1f:	39 df                	cmp    %ebx,%edi
  801d21:	0f 86 b1 00 00 00    	jbe    801dd8 <__umoddi3+0xd8>
  801d27:	f7 f7                	div    %edi
  801d29:	89 d0                	mov    %edx,%eax
  801d2b:	31 d2                	xor    %edx,%edx
  801d2d:	83 c4 1c             	add    $0x1c,%esp
  801d30:	5b                   	pop    %ebx
  801d31:	5e                   	pop    %esi
  801d32:	5f                   	pop    %edi
  801d33:	5d                   	pop    %ebp
  801d34:	c3                   	ret    
  801d35:	8d 76 00             	lea    0x0(%esi),%esi
  801d38:	39 dd                	cmp    %ebx,%ebp
  801d3a:	77 f1                	ja     801d2d <__umoddi3+0x2d>
  801d3c:	0f bd cd             	bsr    %ebp,%ecx
  801d3f:	83 f1 1f             	xor    $0x1f,%ecx
  801d42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d46:	0f 84 b4 00 00 00    	je     801e00 <__umoddi3+0x100>
  801d4c:	b8 20 00 00 00       	mov    $0x20,%eax
  801d51:	89 c2                	mov    %eax,%edx
  801d53:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d57:	29 c2                	sub    %eax,%edx
  801d59:	89 c1                	mov    %eax,%ecx
  801d5b:	89 f8                	mov    %edi,%eax
  801d5d:	d3 e5                	shl    %cl,%ebp
  801d5f:	89 d1                	mov    %edx,%ecx
  801d61:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d65:	d3 e8                	shr    %cl,%eax
  801d67:	09 c5                	or     %eax,%ebp
  801d69:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d6d:	89 c1                	mov    %eax,%ecx
  801d6f:	d3 e7                	shl    %cl,%edi
  801d71:	89 d1                	mov    %edx,%ecx
  801d73:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801d77:	89 df                	mov    %ebx,%edi
  801d79:	d3 ef                	shr    %cl,%edi
  801d7b:	89 c1                	mov    %eax,%ecx
  801d7d:	89 f0                	mov    %esi,%eax
  801d7f:	d3 e3                	shl    %cl,%ebx
  801d81:	89 d1                	mov    %edx,%ecx
  801d83:	89 fa                	mov    %edi,%edx
  801d85:	d3 e8                	shr    %cl,%eax
  801d87:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801d8c:	09 d8                	or     %ebx,%eax
  801d8e:	f7 f5                	div    %ebp
  801d90:	d3 e6                	shl    %cl,%esi
  801d92:	89 d1                	mov    %edx,%ecx
  801d94:	f7 64 24 08          	mull   0x8(%esp)
  801d98:	39 d1                	cmp    %edx,%ecx
  801d9a:	89 c3                	mov    %eax,%ebx
  801d9c:	89 d7                	mov    %edx,%edi
  801d9e:	72 06                	jb     801da6 <__umoddi3+0xa6>
  801da0:	75 0e                	jne    801db0 <__umoddi3+0xb0>
  801da2:	39 c6                	cmp    %eax,%esi
  801da4:	73 0a                	jae    801db0 <__umoddi3+0xb0>
  801da6:	2b 44 24 08          	sub    0x8(%esp),%eax
  801daa:	19 ea                	sbb    %ebp,%edx
  801dac:	89 d7                	mov    %edx,%edi
  801dae:	89 c3                	mov    %eax,%ebx
  801db0:	89 ca                	mov    %ecx,%edx
  801db2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801db7:	29 de                	sub    %ebx,%esi
  801db9:	19 fa                	sbb    %edi,%edx
  801dbb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801dbf:	89 d0                	mov    %edx,%eax
  801dc1:	d3 e0                	shl    %cl,%eax
  801dc3:	89 d9                	mov    %ebx,%ecx
  801dc5:	d3 ee                	shr    %cl,%esi
  801dc7:	d3 ea                	shr    %cl,%edx
  801dc9:	09 f0                	or     %esi,%eax
  801dcb:	83 c4 1c             	add    $0x1c,%esp
  801dce:	5b                   	pop    %ebx
  801dcf:	5e                   	pop    %esi
  801dd0:	5f                   	pop    %edi
  801dd1:	5d                   	pop    %ebp
  801dd2:	c3                   	ret    
  801dd3:	90                   	nop
  801dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801dd8:	85 ff                	test   %edi,%edi
  801dda:	89 f9                	mov    %edi,%ecx
  801ddc:	75 0b                	jne    801de9 <__umoddi3+0xe9>
  801dde:	b8 01 00 00 00       	mov    $0x1,%eax
  801de3:	31 d2                	xor    %edx,%edx
  801de5:	f7 f7                	div    %edi
  801de7:	89 c1                	mov    %eax,%ecx
  801de9:	89 d8                	mov    %ebx,%eax
  801deb:	31 d2                	xor    %edx,%edx
  801ded:	f7 f1                	div    %ecx
  801def:	89 f0                	mov    %esi,%eax
  801df1:	f7 f1                	div    %ecx
  801df3:	e9 31 ff ff ff       	jmp    801d29 <__umoddi3+0x29>
  801df8:	90                   	nop
  801df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e00:	39 dd                	cmp    %ebx,%ebp
  801e02:	72 08                	jb     801e0c <__umoddi3+0x10c>
  801e04:	39 f7                	cmp    %esi,%edi
  801e06:	0f 87 21 ff ff ff    	ja     801d2d <__umoddi3+0x2d>
  801e0c:	89 da                	mov    %ebx,%edx
  801e0e:	89 f0                	mov    %esi,%eax
  801e10:	29 f8                	sub    %edi,%eax
  801e12:	19 ea                	sbb    %ebp,%edx
  801e14:	e9 14 ff ff ff       	jmp    801d2d <__umoddi3+0x2d>
