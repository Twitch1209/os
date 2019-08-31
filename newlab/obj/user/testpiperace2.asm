
obj/user/testpiperace2.debug：     文件格式 elf32-i386


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
  80002c:	e8 a1 01 00 00       	call   8001d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 60 21 80 00       	push   $0x802160
  800041:	e8 c7 02 00 00       	call   80030d <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 8b 1a 00 00       	call   801adc <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 5d                	js     8000b5 <umain+0x82>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 9b 0e 00 00       	call   800ef8 <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 64                	js     8000c7 <umain+0x94>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	85 c0                	test   %eax,%eax
  800065:	74 72                	je     8000d9 <umain+0xa6>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800067:	89 fb                	mov    %edi,%ebx
  800069:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80006f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800072:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800078:	8b 43 54             	mov    0x54(%ebx),%eax
  80007b:	83 f8 02             	cmp    $0x2,%eax
  80007e:	0f 85 d1 00 00 00    	jne    800155 <umain+0x122>
		if (pipeisclosed(p[0]) != 0) {
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	ff 75 e0             	pushl  -0x20(%ebp)
  80008a:	e8 96 1b 00 00       	call   801c25 <pipeisclosed>
  80008f:	83 c4 10             	add    $0x10,%esp
  800092:	85 c0                	test   %eax,%eax
  800094:	74 e2                	je     800078 <umain+0x45>
			cprintf("\nRACE: pipe appears closed\n");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 d9 21 80 00       	push   $0x8021d9
  80009e:	e8 6a 02 00 00       	call   80030d <cprintf>
			sys_env_destroy(r);
  8000a3:	89 3c 24             	mov    %edi,(%esp)
  8000a6:	e8 c6 0b 00 00       	call   800c71 <sys_env_destroy>
			exit();
  8000ab:	e8 68 01 00 00       	call   800218 <exit>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	eb c3                	jmp    800078 <umain+0x45>
		panic("pipe: %e", r);
  8000b5:	50                   	push   %eax
  8000b6:	68 ae 21 80 00       	push   $0x8021ae
  8000bb:	6a 0d                	push   $0xd
  8000bd:	68 b7 21 80 00       	push   $0x8021b7
  8000c2:	e8 6b 01 00 00       	call   800232 <_panic>
		panic("fork: %e", r);
  8000c7:	50                   	push   %eax
  8000c8:	68 cc 21 80 00       	push   $0x8021cc
  8000cd:	6a 0f                	push   $0xf
  8000cf:	68 b7 21 80 00       	push   $0x8021b7
  8000d4:	e8 59 01 00 00       	call   800232 <_panic>
		close(p[1]);
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000df:	e8 e1 11 00 00       	call   8012c5 <close>
  8000e4:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e7:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000e9:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000ee:	eb 31                	jmp    800121 <umain+0xee>
			dup(p[0], 10);
  8000f0:	83 ec 08             	sub    $0x8,%esp
  8000f3:	6a 0a                	push   $0xa
  8000f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f8:	e8 18 12 00 00       	call   801315 <dup>
			sys_yield();
  8000fd:	e8 cf 0b 00 00       	call   800cd1 <sys_yield>
			close(10);
  800102:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800109:	e8 b7 11 00 00       	call   8012c5 <close>
			sys_yield();
  80010e:	e8 be 0b 00 00       	call   800cd1 <sys_yield>
		for (i = 0; i < 200; i++) {
  800113:	83 c3 01             	add    $0x1,%ebx
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  80011f:	74 2a                	je     80014b <umain+0x118>
			if (i % 10 == 0)
  800121:	89 d8                	mov    %ebx,%eax
  800123:	f7 ee                	imul   %esi
  800125:	c1 fa 02             	sar    $0x2,%edx
  800128:	89 d8                	mov    %ebx,%eax
  80012a:	c1 f8 1f             	sar    $0x1f,%eax
  80012d:	29 c2                	sub    %eax,%edx
  80012f:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800132:	01 c0                	add    %eax,%eax
  800134:	39 c3                	cmp    %eax,%ebx
  800136:	75 b8                	jne    8000f0 <umain+0xbd>
				cprintf("%d.", i);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	53                   	push   %ebx
  80013c:	68 d5 21 80 00       	push   $0x8021d5
  800141:	e8 c7 01 00 00       	call   80030d <cprintf>
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	eb a5                	jmp    8000f0 <umain+0xbd>
		exit();
  80014b:	e8 c8 00 00 00       	call   800218 <exit>
  800150:	e9 12 ff ff ff       	jmp    800067 <umain+0x34>
		}
	cprintf("child done with loop\n");
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	68 f5 21 80 00       	push   $0x8021f5
  80015d:	e8 ab 01 00 00       	call   80030d <cprintf>
	if (pipeisclosed(p[0]))
  800162:	83 c4 04             	add    $0x4,%esp
  800165:	ff 75 e0             	pushl  -0x20(%ebp)
  800168:	e8 b8 1a 00 00       	call   801c25 <pipeisclosed>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	85 c0                	test   %eax,%eax
  800172:	75 38                	jne    8001ac <umain+0x179>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800174:	83 ec 08             	sub    $0x8,%esp
  800177:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80017a:	50                   	push   %eax
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 0d 10 00 00       	call   801190 <fd_lookup>
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	85 c0                	test   %eax,%eax
  800188:	78 36                	js     8001c0 <umain+0x18d>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	ff 75 dc             	pushl  -0x24(%ebp)
  800190:	e8 95 0f 00 00       	call   80112a <fd2data>
	cprintf("race didn't happen\n");
  800195:	c7 04 24 23 22 80 00 	movl   $0x802223,(%esp)
  80019c:	e8 6c 01 00 00       	call   80030d <cprintf>
}
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a7:	5b                   	pop    %ebx
  8001a8:	5e                   	pop    %esi
  8001a9:	5f                   	pop    %edi
  8001aa:	5d                   	pop    %ebp
  8001ab:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 84 21 80 00       	push   $0x802184
  8001b4:	6a 40                	push   $0x40
  8001b6:	68 b7 21 80 00       	push   $0x8021b7
  8001bb:	e8 72 00 00 00       	call   800232 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c0:	50                   	push   %eax
  8001c1:	68 0b 22 80 00       	push   $0x80220b
  8001c6:	6a 42                	push   $0x42
  8001c8:	68 b7 21 80 00       	push   $0x8021b7
  8001cd:	e8 60 00 00 00       	call   800232 <_panic>

008001d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001dd:	e8 d0 0a 00 00       	call   800cb2 <sys_getenvid>
  8001e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ef:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7e 07                	jle    8001ff <libmain+0x2d>
		binaryname = argv[0];
  8001f8:	8b 06                	mov    (%esi),%eax
  8001fa:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001ff:	83 ec 08             	sub    $0x8,%esp
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	e8 2a fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800209:	e8 0a 00 00 00       	call   800218 <exit>
}
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80021e:	e8 cd 10 00 00       	call   8012f0 <close_all>
	sys_env_destroy(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 44 0a 00 00       	call   800c71 <sys_env_destroy>
}
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	c9                   	leave  
  800231:	c3                   	ret    

00800232 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	56                   	push   %esi
  800236:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800237:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80023a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800240:	e8 6d 0a 00 00       	call   800cb2 <sys_getenvid>
  800245:	83 ec 0c             	sub    $0xc,%esp
  800248:	ff 75 0c             	pushl  0xc(%ebp)
  80024b:	ff 75 08             	pushl  0x8(%ebp)
  80024e:	56                   	push   %esi
  80024f:	50                   	push   %eax
  800250:	68 44 22 80 00       	push   $0x802244
  800255:	e8 b3 00 00 00       	call   80030d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025a:	83 c4 18             	add    $0x18,%esp
  80025d:	53                   	push   %ebx
  80025e:	ff 75 10             	pushl  0x10(%ebp)
  800261:	e8 56 00 00 00       	call   8002bc <vcprintf>
	cprintf("\n");
  800266:	c7 04 24 1f 27 80 00 	movl   $0x80271f,(%esp)
  80026d:	e8 9b 00 00 00       	call   80030d <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800275:	cc                   	int3   
  800276:	eb fd                	jmp    800275 <_panic+0x43>

00800278 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	53                   	push   %ebx
  80027c:	83 ec 04             	sub    $0x4,%esp
  80027f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800282:	8b 13                	mov    (%ebx),%edx
  800284:	8d 42 01             	lea    0x1(%edx),%eax
  800287:	89 03                	mov    %eax,(%ebx)
  800289:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800290:	3d ff 00 00 00       	cmp    $0xff,%eax
  800295:	74 09                	je     8002a0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800297:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80029b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	68 ff 00 00 00       	push   $0xff
  8002a8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ab:	50                   	push   %eax
  8002ac:	e8 83 09 00 00       	call   800c34 <sys_cputs>
		b->idx = 0;
  8002b1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	eb db                	jmp    800297 <putch+0x1f>

008002bc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002cc:	00 00 00 
	b.cnt = 0;
  8002cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d9:	ff 75 0c             	pushl  0xc(%ebp)
  8002dc:	ff 75 08             	pushl  0x8(%ebp)
  8002df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e5:	50                   	push   %eax
  8002e6:	68 78 02 80 00       	push   $0x800278
  8002eb:	e8 1a 01 00 00       	call   80040a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f0:	83 c4 08             	add    $0x8,%esp
  8002f3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ff:	50                   	push   %eax
  800300:	e8 2f 09 00 00       	call   800c34 <sys_cputs>

	return b.cnt;
}
  800305:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800313:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800316:	50                   	push   %eax
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	e8 9d ff ff ff       	call   8002bc <vcprintf>
	va_end(ap);

	return cnt;
}
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	57                   	push   %edi
  800325:	56                   	push   %esi
  800326:	53                   	push   %ebx
  800327:	83 ec 1c             	sub    $0x1c,%esp
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	89 d6                	mov    %edx,%esi
  80032e:	8b 45 08             	mov    0x8(%ebp),%eax
  800331:	8b 55 0c             	mov    0xc(%ebp),%edx
  800334:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800337:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80033d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800342:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800345:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800348:	39 d3                	cmp    %edx,%ebx
  80034a:	72 05                	jb     800351 <printnum+0x30>
  80034c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80034f:	77 7a                	ja     8003cb <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800351:	83 ec 0c             	sub    $0xc,%esp
  800354:	ff 75 18             	pushl  0x18(%ebp)
  800357:	8b 45 14             	mov    0x14(%ebp),%eax
  80035a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80035d:	53                   	push   %ebx
  80035e:	ff 75 10             	pushl  0x10(%ebp)
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	ff 75 e4             	pushl  -0x1c(%ebp)
  800367:	ff 75 e0             	pushl  -0x20(%ebp)
  80036a:	ff 75 dc             	pushl  -0x24(%ebp)
  80036d:	ff 75 d8             	pushl  -0x28(%ebp)
  800370:	e8 ab 1b 00 00       	call   801f20 <__udivdi3>
  800375:	83 c4 18             	add    $0x18,%esp
  800378:	52                   	push   %edx
  800379:	50                   	push   %eax
  80037a:	89 f2                	mov    %esi,%edx
  80037c:	89 f8                	mov    %edi,%eax
  80037e:	e8 9e ff ff ff       	call   800321 <printnum>
  800383:	83 c4 20             	add    $0x20,%esp
  800386:	eb 13                	jmp    80039b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	56                   	push   %esi
  80038c:	ff 75 18             	pushl  0x18(%ebp)
  80038f:	ff d7                	call   *%edi
  800391:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800394:	83 eb 01             	sub    $0x1,%ebx
  800397:	85 db                	test   %ebx,%ebx
  800399:	7f ed                	jg     800388 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	56                   	push   %esi
  80039f:	83 ec 04             	sub    $0x4,%esp
  8003a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ae:	e8 8d 1c 00 00       	call   802040 <__umoddi3>
  8003b3:	83 c4 14             	add    $0x14,%esp
  8003b6:	0f be 80 67 22 80 00 	movsbl 0x802267(%eax),%eax
  8003bd:	50                   	push   %eax
  8003be:	ff d7                	call   *%edi
}
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c6:	5b                   	pop    %ebx
  8003c7:	5e                   	pop    %esi
  8003c8:	5f                   	pop    %edi
  8003c9:	5d                   	pop    %ebp
  8003ca:	c3                   	ret    
  8003cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003ce:	eb c4                	jmp    800394 <printnum+0x73>

008003d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003da:	8b 10                	mov    (%eax),%edx
  8003dc:	3b 50 04             	cmp    0x4(%eax),%edx
  8003df:	73 0a                	jae    8003eb <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e4:	89 08                	mov    %ecx,(%eax)
  8003e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e9:	88 02                	mov    %al,(%edx)
}
  8003eb:	5d                   	pop    %ebp
  8003ec:	c3                   	ret    

008003ed <printfmt>:
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
  8003f0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f6:	50                   	push   %eax
  8003f7:	ff 75 10             	pushl  0x10(%ebp)
  8003fa:	ff 75 0c             	pushl  0xc(%ebp)
  8003fd:	ff 75 08             	pushl  0x8(%ebp)
  800400:	e8 05 00 00 00       	call   80040a <vprintfmt>
}
  800405:	83 c4 10             	add    $0x10,%esp
  800408:	c9                   	leave  
  800409:	c3                   	ret    

0080040a <vprintfmt>:
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	57                   	push   %edi
  80040e:	56                   	push   %esi
  80040f:	53                   	push   %ebx
  800410:	83 ec 2c             	sub    $0x2c,%esp
  800413:	8b 75 08             	mov    0x8(%ebp),%esi
  800416:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800419:	8b 7d 10             	mov    0x10(%ebp),%edi
  80041c:	e9 8c 03 00 00       	jmp    8007ad <vprintfmt+0x3a3>
		padc = ' ';
  800421:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800425:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80042c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800433:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80043a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80043f:	8d 47 01             	lea    0x1(%edi),%eax
  800442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800445:	0f b6 17             	movzbl (%edi),%edx
  800448:	8d 42 dd             	lea    -0x23(%edx),%eax
  80044b:	3c 55                	cmp    $0x55,%al
  80044d:	0f 87 dd 03 00 00    	ja     800830 <vprintfmt+0x426>
  800453:	0f b6 c0             	movzbl %al,%eax
  800456:	ff 24 85 a0 23 80 00 	jmp    *0x8023a0(,%eax,4)
  80045d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800460:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800464:	eb d9                	jmp    80043f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800466:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800469:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80046d:	eb d0                	jmp    80043f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80046f:	0f b6 d2             	movzbl %dl,%edx
  800472:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800475:	b8 00 00 00 00       	mov    $0x0,%eax
  80047a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80047d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800480:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800484:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800487:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80048a:	83 f9 09             	cmp    $0x9,%ecx
  80048d:	77 55                	ja     8004e4 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80048f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800492:	eb e9                	jmp    80047d <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800494:	8b 45 14             	mov    0x14(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80049c:	8b 45 14             	mov    0x14(%ebp),%eax
  80049f:	8d 40 04             	lea    0x4(%eax),%eax
  8004a2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ac:	79 91                	jns    80043f <vprintfmt+0x35>
				width = precision, precision = -1;
  8004ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004bb:	eb 82                	jmp    80043f <vprintfmt+0x35>
  8004bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c0:	85 c0                	test   %eax,%eax
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c7:	0f 49 d0             	cmovns %eax,%edx
  8004ca:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d0:	e9 6a ff ff ff       	jmp    80043f <vprintfmt+0x35>
  8004d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004d8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004df:	e9 5b ff ff ff       	jmp    80043f <vprintfmt+0x35>
  8004e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ea:	eb bc                	jmp    8004a8 <vprintfmt+0x9e>
			lflag++;
  8004ec:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f2:	e9 48 ff ff ff       	jmp    80043f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8d 78 04             	lea    0x4(%eax),%edi
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	53                   	push   %ebx
  800501:	ff 30                	pushl  (%eax)
  800503:	ff d6                	call   *%esi
			break;
  800505:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800508:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80050b:	e9 9a 02 00 00       	jmp    8007aa <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8d 78 04             	lea    0x4(%eax),%edi
  800516:	8b 00                	mov    (%eax),%eax
  800518:	99                   	cltd   
  800519:	31 d0                	xor    %edx,%eax
  80051b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051d:	83 f8 0f             	cmp    $0xf,%eax
  800520:	7f 23                	jg     800545 <vprintfmt+0x13b>
  800522:	8b 14 85 00 25 80 00 	mov    0x802500(,%eax,4),%edx
  800529:	85 d2                	test   %edx,%edx
  80052b:	74 18                	je     800545 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80052d:	52                   	push   %edx
  80052e:	68 ed 26 80 00       	push   $0x8026ed
  800533:	53                   	push   %ebx
  800534:	56                   	push   %esi
  800535:	e8 b3 fe ff ff       	call   8003ed <printfmt>
  80053a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800540:	e9 65 02 00 00       	jmp    8007aa <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  800545:	50                   	push   %eax
  800546:	68 7f 22 80 00       	push   $0x80227f
  80054b:	53                   	push   %ebx
  80054c:	56                   	push   %esi
  80054d:	e8 9b fe ff ff       	call   8003ed <printfmt>
  800552:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800555:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800558:	e9 4d 02 00 00       	jmp    8007aa <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	83 c0 04             	add    $0x4,%eax
  800563:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80056b:	85 ff                	test   %edi,%edi
  80056d:	b8 78 22 80 00       	mov    $0x802278,%eax
  800572:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800575:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800579:	0f 8e bd 00 00 00    	jle    80063c <vprintfmt+0x232>
  80057f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800583:	75 0e                	jne    800593 <vprintfmt+0x189>
  800585:	89 75 08             	mov    %esi,0x8(%ebp)
  800588:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80058b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80058e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800591:	eb 6d                	jmp    800600 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	ff 75 d0             	pushl  -0x30(%ebp)
  800599:	57                   	push   %edi
  80059a:	e8 39 03 00 00       	call   8008d8 <strnlen>
  80059f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a2:	29 c1                	sub    %eax,%ecx
  8005a4:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005a7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005aa:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005b4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b6:	eb 0f                	jmp    8005c7 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	53                   	push   %ebx
  8005bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8005bf:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c1:	83 ef 01             	sub    $0x1,%edi
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	85 ff                	test   %edi,%edi
  8005c9:	7f ed                	jg     8005b8 <vprintfmt+0x1ae>
  8005cb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005ce:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005d1:	85 c9                	test   %ecx,%ecx
  8005d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d8:	0f 49 c1             	cmovns %ecx,%eax
  8005db:	29 c1                	sub    %eax,%ecx
  8005dd:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005e3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005e6:	89 cb                	mov    %ecx,%ebx
  8005e8:	eb 16                	jmp    800600 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ea:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005ee:	75 31                	jne    800621 <vprintfmt+0x217>
					putch(ch, putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	ff 55 08             	call   *0x8(%ebp)
  8005fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005fd:	83 eb 01             	sub    $0x1,%ebx
  800600:	83 c7 01             	add    $0x1,%edi
  800603:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800607:	0f be c2             	movsbl %dl,%eax
  80060a:	85 c0                	test   %eax,%eax
  80060c:	74 59                	je     800667 <vprintfmt+0x25d>
  80060e:	85 f6                	test   %esi,%esi
  800610:	78 d8                	js     8005ea <vprintfmt+0x1e0>
  800612:	83 ee 01             	sub    $0x1,%esi
  800615:	79 d3                	jns    8005ea <vprintfmt+0x1e0>
  800617:	89 df                	mov    %ebx,%edi
  800619:	8b 75 08             	mov    0x8(%ebp),%esi
  80061c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80061f:	eb 37                	jmp    800658 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800621:	0f be d2             	movsbl %dl,%edx
  800624:	83 ea 20             	sub    $0x20,%edx
  800627:	83 fa 5e             	cmp    $0x5e,%edx
  80062a:	76 c4                	jbe    8005f0 <vprintfmt+0x1e6>
					putch('?', putdat);
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	ff 75 0c             	pushl  0xc(%ebp)
  800632:	6a 3f                	push   $0x3f
  800634:	ff 55 08             	call   *0x8(%ebp)
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	eb c1                	jmp    8005fd <vprintfmt+0x1f3>
  80063c:	89 75 08             	mov    %esi,0x8(%ebp)
  80063f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800642:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800645:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800648:	eb b6                	jmp    800600 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	6a 20                	push   $0x20
  800650:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800652:	83 ef 01             	sub    $0x1,%edi
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	85 ff                	test   %edi,%edi
  80065a:	7f ee                	jg     80064a <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80065c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
  800662:	e9 43 01 00 00       	jmp    8007aa <vprintfmt+0x3a0>
  800667:	89 df                	mov    %ebx,%edi
  800669:	8b 75 08             	mov    0x8(%ebp),%esi
  80066c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80066f:	eb e7                	jmp    800658 <vprintfmt+0x24e>
	if (lflag >= 2)
  800671:	83 f9 01             	cmp    $0x1,%ecx
  800674:	7e 3f                	jle    8006b5 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8b 50 04             	mov    0x4(%eax),%edx
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800681:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 40 08             	lea    0x8(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80068d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800691:	79 5c                	jns    8006ef <vprintfmt+0x2e5>
				putch('-', putdat);
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	53                   	push   %ebx
  800697:	6a 2d                	push   $0x2d
  800699:	ff d6                	call   *%esi
				num = -(long long) num;
  80069b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80069e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006a1:	f7 da                	neg    %edx
  8006a3:	83 d1 00             	adc    $0x0,%ecx
  8006a6:	f7 d9                	neg    %ecx
  8006a8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b0:	e9 db 00 00 00       	jmp    800790 <vprintfmt+0x386>
	else if (lflag)
  8006b5:	85 c9                	test   %ecx,%ecx
  8006b7:	75 1b                	jne    8006d4 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c1:	89 c1                	mov    %eax,%ecx
  8006c3:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8d 40 04             	lea    0x4(%eax),%eax
  8006cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d2:	eb b9                	jmp    80068d <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dc:	89 c1                	mov    %eax,%ecx
  8006de:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ed:	eb 9e                	jmp    80068d <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fa:	e9 91 00 00 00       	jmp    800790 <vprintfmt+0x386>
	if (lflag >= 2)
  8006ff:	83 f9 01             	cmp    $0x1,%ecx
  800702:	7e 15                	jle    800719 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8b 10                	mov    (%eax),%edx
  800709:	8b 48 04             	mov    0x4(%eax),%ecx
  80070c:	8d 40 08             	lea    0x8(%eax),%eax
  80070f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800712:	b8 0a 00 00 00       	mov    $0xa,%eax
  800717:	eb 77                	jmp    800790 <vprintfmt+0x386>
	else if (lflag)
  800719:	85 c9                	test   %ecx,%ecx
  80071b:	75 17                	jne    800734 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8b 10                	mov    (%eax),%edx
  800722:	b9 00 00 00 00       	mov    $0x0,%ecx
  800727:	8d 40 04             	lea    0x4(%eax),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800732:	eb 5c                	jmp    800790 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 10                	mov    (%eax),%edx
  800739:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073e:	8d 40 04             	lea    0x4(%eax),%eax
  800741:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800744:	b8 0a 00 00 00       	mov    $0xa,%eax
  800749:	eb 45                	jmp    800790 <vprintfmt+0x386>
			putch('X', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	6a 58                	push   $0x58
  800751:	ff d6                	call   *%esi
			putch('X', putdat);
  800753:	83 c4 08             	add    $0x8,%esp
  800756:	53                   	push   %ebx
  800757:	6a 58                	push   $0x58
  800759:	ff d6                	call   *%esi
			putch('X', putdat);
  80075b:	83 c4 08             	add    $0x8,%esp
  80075e:	53                   	push   %ebx
  80075f:	6a 58                	push   $0x58
  800761:	ff d6                	call   *%esi
			break;
  800763:	83 c4 10             	add    $0x10,%esp
  800766:	eb 42                	jmp    8007aa <vprintfmt+0x3a0>
			putch('0', putdat);
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	53                   	push   %ebx
  80076c:	6a 30                	push   $0x30
  80076e:	ff d6                	call   *%esi
			putch('x', putdat);
  800770:	83 c4 08             	add    $0x8,%esp
  800773:	53                   	push   %ebx
  800774:	6a 78                	push   $0x78
  800776:	ff d6                	call   *%esi
			num = (unsigned long long)
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 10                	mov    (%eax),%edx
  80077d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800782:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800785:	8d 40 04             	lea    0x4(%eax),%eax
  800788:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800790:	83 ec 0c             	sub    $0xc,%esp
  800793:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800797:	57                   	push   %edi
  800798:	ff 75 e0             	pushl  -0x20(%ebp)
  80079b:	50                   	push   %eax
  80079c:	51                   	push   %ecx
  80079d:	52                   	push   %edx
  80079e:	89 da                	mov    %ebx,%edx
  8007a0:	89 f0                	mov    %esi,%eax
  8007a2:	e8 7a fb ff ff       	call   800321 <printnum>
			break;
  8007a7:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ad:	83 c7 01             	add    $0x1,%edi
  8007b0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007b4:	83 f8 25             	cmp    $0x25,%eax
  8007b7:	0f 84 64 fc ff ff    	je     800421 <vprintfmt+0x17>
			if (ch == '\0')
  8007bd:	85 c0                	test   %eax,%eax
  8007bf:	0f 84 8b 00 00 00    	je     800850 <vprintfmt+0x446>
			putch(ch, putdat);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	53                   	push   %ebx
  8007c9:	50                   	push   %eax
  8007ca:	ff d6                	call   *%esi
  8007cc:	83 c4 10             	add    $0x10,%esp
  8007cf:	eb dc                	jmp    8007ad <vprintfmt+0x3a3>
	if (lflag >= 2)
  8007d1:	83 f9 01             	cmp    $0x1,%ecx
  8007d4:	7e 15                	jle    8007eb <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	8b 10                	mov    (%eax),%edx
  8007db:	8b 48 04             	mov    0x4(%eax),%ecx
  8007de:	8d 40 08             	lea    0x8(%eax),%eax
  8007e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e4:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e9:	eb a5                	jmp    800790 <vprintfmt+0x386>
	else if (lflag)
  8007eb:	85 c9                	test   %ecx,%ecx
  8007ed:	75 17                	jne    800806 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8b 10                	mov    (%eax),%edx
  8007f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f9:	8d 40 04             	lea    0x4(%eax),%eax
  8007fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ff:	b8 10 00 00 00       	mov    $0x10,%eax
  800804:	eb 8a                	jmp    800790 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8b 10                	mov    (%eax),%edx
  80080b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800810:	8d 40 04             	lea    0x4(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800816:	b8 10 00 00 00       	mov    $0x10,%eax
  80081b:	e9 70 ff ff ff       	jmp    800790 <vprintfmt+0x386>
			putch(ch, putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	53                   	push   %ebx
  800824:	6a 25                	push   $0x25
  800826:	ff d6                	call   *%esi
			break;
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	e9 7a ff ff ff       	jmp    8007aa <vprintfmt+0x3a0>
			putch('%', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	53                   	push   %ebx
  800834:	6a 25                	push   $0x25
  800836:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	89 f8                	mov    %edi,%eax
  80083d:	eb 03                	jmp    800842 <vprintfmt+0x438>
  80083f:	83 e8 01             	sub    $0x1,%eax
  800842:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800846:	75 f7                	jne    80083f <vprintfmt+0x435>
  800848:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80084b:	e9 5a ff ff ff       	jmp    8007aa <vprintfmt+0x3a0>
}
  800850:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800853:	5b                   	pop    %ebx
  800854:	5e                   	pop    %esi
  800855:	5f                   	pop    %edi
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	83 ec 18             	sub    $0x18,%esp
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800864:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800867:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80086b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80086e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800875:	85 c0                	test   %eax,%eax
  800877:	74 26                	je     80089f <vsnprintf+0x47>
  800879:	85 d2                	test   %edx,%edx
  80087b:	7e 22                	jle    80089f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80087d:	ff 75 14             	pushl  0x14(%ebp)
  800880:	ff 75 10             	pushl  0x10(%ebp)
  800883:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800886:	50                   	push   %eax
  800887:	68 d0 03 80 00       	push   $0x8003d0
  80088c:	e8 79 fb ff ff       	call   80040a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800894:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80089a:	83 c4 10             	add    $0x10,%esp
}
  80089d:	c9                   	leave  
  80089e:	c3                   	ret    
		return -E_INVAL;
  80089f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a4:	eb f7                	jmp    80089d <vsnprintf+0x45>

008008a6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ac:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008af:	50                   	push   %eax
  8008b0:	ff 75 10             	pushl  0x10(%ebp)
  8008b3:	ff 75 0c             	pushl  0xc(%ebp)
  8008b6:	ff 75 08             	pushl  0x8(%ebp)
  8008b9:	e8 9a ff ff ff       	call   800858 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cb:	eb 03                	jmp    8008d0 <strlen+0x10>
		n++;
  8008cd:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008d0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008d4:	75 f7                	jne    8008cd <strlen+0xd>
	return n;
}
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008de:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e6:	eb 03                	jmp    8008eb <strnlen+0x13>
		n++;
  8008e8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008eb:	39 d0                	cmp    %edx,%eax
  8008ed:	74 06                	je     8008f5 <strnlen+0x1d>
  8008ef:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008f3:	75 f3                	jne    8008e8 <strnlen+0x10>
	return n;
}
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	53                   	push   %ebx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800901:	89 c2                	mov    %eax,%edx
  800903:	83 c1 01             	add    $0x1,%ecx
  800906:	83 c2 01             	add    $0x1,%edx
  800909:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80090d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800910:	84 db                	test   %bl,%bl
  800912:	75 ef                	jne    800903 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800914:	5b                   	pop    %ebx
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	53                   	push   %ebx
  80091b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80091e:	53                   	push   %ebx
  80091f:	e8 9c ff ff ff       	call   8008c0 <strlen>
  800924:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	01 d8                	add    %ebx,%eax
  80092c:	50                   	push   %eax
  80092d:	e8 c5 ff ff ff       	call   8008f7 <strcpy>
	return dst;
}
  800932:	89 d8                	mov    %ebx,%eax
  800934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	56                   	push   %esi
  80093d:	53                   	push   %ebx
  80093e:	8b 75 08             	mov    0x8(%ebp),%esi
  800941:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800944:	89 f3                	mov    %esi,%ebx
  800946:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800949:	89 f2                	mov    %esi,%edx
  80094b:	eb 0f                	jmp    80095c <strncpy+0x23>
		*dst++ = *src;
  80094d:	83 c2 01             	add    $0x1,%edx
  800950:	0f b6 01             	movzbl (%ecx),%eax
  800953:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800956:	80 39 01             	cmpb   $0x1,(%ecx)
  800959:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80095c:	39 da                	cmp    %ebx,%edx
  80095e:	75 ed                	jne    80094d <strncpy+0x14>
	}
	return ret;
}
  800960:	89 f0                	mov    %esi,%eax
  800962:	5b                   	pop    %ebx
  800963:	5e                   	pop    %esi
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	56                   	push   %esi
  80096a:	53                   	push   %ebx
  80096b:	8b 75 08             	mov    0x8(%ebp),%esi
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800974:	89 f0                	mov    %esi,%eax
  800976:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80097a:	85 c9                	test   %ecx,%ecx
  80097c:	75 0b                	jne    800989 <strlcpy+0x23>
  80097e:	eb 17                	jmp    800997 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800980:	83 c2 01             	add    $0x1,%edx
  800983:	83 c0 01             	add    $0x1,%eax
  800986:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800989:	39 d8                	cmp    %ebx,%eax
  80098b:	74 07                	je     800994 <strlcpy+0x2e>
  80098d:	0f b6 0a             	movzbl (%edx),%ecx
  800990:	84 c9                	test   %cl,%cl
  800992:	75 ec                	jne    800980 <strlcpy+0x1a>
		*dst = '\0';
  800994:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800997:	29 f0                	sub    %esi,%eax
}
  800999:	5b                   	pop    %ebx
  80099a:	5e                   	pop    %esi
  80099b:	5d                   	pop    %ebp
  80099c:	c3                   	ret    

0080099d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a6:	eb 06                	jmp    8009ae <strcmp+0x11>
		p++, q++;
  8009a8:	83 c1 01             	add    $0x1,%ecx
  8009ab:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009ae:	0f b6 01             	movzbl (%ecx),%eax
  8009b1:	84 c0                	test   %al,%al
  8009b3:	74 04                	je     8009b9 <strcmp+0x1c>
  8009b5:	3a 02                	cmp    (%edx),%al
  8009b7:	74 ef                	je     8009a8 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b9:	0f b6 c0             	movzbl %al,%eax
  8009bc:	0f b6 12             	movzbl (%edx),%edx
  8009bf:	29 d0                	sub    %edx,%eax
}
  8009c1:	5d                   	pop    %ebp
  8009c2:	c3                   	ret    

008009c3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	53                   	push   %ebx
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cd:	89 c3                	mov    %eax,%ebx
  8009cf:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d2:	eb 06                	jmp    8009da <strncmp+0x17>
		n--, p++, q++;
  8009d4:	83 c0 01             	add    $0x1,%eax
  8009d7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009da:	39 d8                	cmp    %ebx,%eax
  8009dc:	74 16                	je     8009f4 <strncmp+0x31>
  8009de:	0f b6 08             	movzbl (%eax),%ecx
  8009e1:	84 c9                	test   %cl,%cl
  8009e3:	74 04                	je     8009e9 <strncmp+0x26>
  8009e5:	3a 0a                	cmp    (%edx),%cl
  8009e7:	74 eb                	je     8009d4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e9:	0f b6 00             	movzbl (%eax),%eax
  8009ec:	0f b6 12             	movzbl (%edx),%edx
  8009ef:	29 d0                	sub    %edx,%eax
}
  8009f1:	5b                   	pop    %ebx
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    
		return 0;
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f9:	eb f6                	jmp    8009f1 <strncmp+0x2e>

008009fb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a05:	0f b6 10             	movzbl (%eax),%edx
  800a08:	84 d2                	test   %dl,%dl
  800a0a:	74 09                	je     800a15 <strchr+0x1a>
		if (*s == c)
  800a0c:	38 ca                	cmp    %cl,%dl
  800a0e:	74 0a                	je     800a1a <strchr+0x1f>
	for (; *s; s++)
  800a10:	83 c0 01             	add    $0x1,%eax
  800a13:	eb f0                	jmp    800a05 <strchr+0xa>
			return (char *) s;
	return 0;
  800a15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a26:	eb 03                	jmp    800a2b <strfind+0xf>
  800a28:	83 c0 01             	add    $0x1,%eax
  800a2b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a2e:	38 ca                	cmp    %cl,%dl
  800a30:	74 04                	je     800a36 <strfind+0x1a>
  800a32:	84 d2                	test   %dl,%dl
  800a34:	75 f2                	jne    800a28 <strfind+0xc>
			break;
	return (char *) s;
}
  800a36:	5d                   	pop    %ebp
  800a37:	c3                   	ret    

00800a38 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	57                   	push   %edi
  800a3c:	56                   	push   %esi
  800a3d:	53                   	push   %ebx
  800a3e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a41:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a44:	85 c9                	test   %ecx,%ecx
  800a46:	74 13                	je     800a5b <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a48:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4e:	75 05                	jne    800a55 <memset+0x1d>
  800a50:	f6 c1 03             	test   $0x3,%cl
  800a53:	74 0d                	je     800a62 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a58:	fc                   	cld    
  800a59:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a5b:	89 f8                	mov    %edi,%eax
  800a5d:	5b                   	pop    %ebx
  800a5e:	5e                   	pop    %esi
  800a5f:	5f                   	pop    %edi
  800a60:	5d                   	pop    %ebp
  800a61:	c3                   	ret    
		c &= 0xFF;
  800a62:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a66:	89 d3                	mov    %edx,%ebx
  800a68:	c1 e3 08             	shl    $0x8,%ebx
  800a6b:	89 d0                	mov    %edx,%eax
  800a6d:	c1 e0 18             	shl    $0x18,%eax
  800a70:	89 d6                	mov    %edx,%esi
  800a72:	c1 e6 10             	shl    $0x10,%esi
  800a75:	09 f0                	or     %esi,%eax
  800a77:	09 c2                	or     %eax,%edx
  800a79:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a7b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	fc                   	cld    
  800a81:	f3 ab                	rep stos %eax,%es:(%edi)
  800a83:	eb d6                	jmp    800a5b <memset+0x23>

00800a85 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	57                   	push   %edi
  800a89:	56                   	push   %esi
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a93:	39 c6                	cmp    %eax,%esi
  800a95:	73 35                	jae    800acc <memmove+0x47>
  800a97:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9a:	39 c2                	cmp    %eax,%edx
  800a9c:	76 2e                	jbe    800acc <memmove+0x47>
		s += n;
		d += n;
  800a9e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa1:	89 d6                	mov    %edx,%esi
  800aa3:	09 fe                	or     %edi,%esi
  800aa5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aab:	74 0c                	je     800ab9 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aad:	83 ef 01             	sub    $0x1,%edi
  800ab0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ab3:	fd                   	std    
  800ab4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab6:	fc                   	cld    
  800ab7:	eb 21                	jmp    800ada <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab9:	f6 c1 03             	test   $0x3,%cl
  800abc:	75 ef                	jne    800aad <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800abe:	83 ef 04             	sub    $0x4,%edi
  800ac1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ac4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ac7:	fd                   	std    
  800ac8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aca:	eb ea                	jmp    800ab6 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acc:	89 f2                	mov    %esi,%edx
  800ace:	09 c2                	or     %eax,%edx
  800ad0:	f6 c2 03             	test   $0x3,%dl
  800ad3:	74 09                	je     800ade <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ad5:	89 c7                	mov    %eax,%edi
  800ad7:	fc                   	cld    
  800ad8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ada:	5e                   	pop    %esi
  800adb:	5f                   	pop    %edi
  800adc:	5d                   	pop    %ebp
  800add:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ade:	f6 c1 03             	test   $0x3,%cl
  800ae1:	75 f2                	jne    800ad5 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ae3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ae6:	89 c7                	mov    %eax,%edi
  800ae8:	fc                   	cld    
  800ae9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aeb:	eb ed                	jmp    800ada <memmove+0x55>

00800aed <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800af0:	ff 75 10             	pushl  0x10(%ebp)
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	ff 75 08             	pushl  0x8(%ebp)
  800af9:	e8 87 ff ff ff       	call   800a85 <memmove>
}
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	56                   	push   %esi
  800b04:	53                   	push   %ebx
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0b:	89 c6                	mov    %eax,%esi
  800b0d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b10:	39 f0                	cmp    %esi,%eax
  800b12:	74 1c                	je     800b30 <memcmp+0x30>
		if (*s1 != *s2)
  800b14:	0f b6 08             	movzbl (%eax),%ecx
  800b17:	0f b6 1a             	movzbl (%edx),%ebx
  800b1a:	38 d9                	cmp    %bl,%cl
  800b1c:	75 08                	jne    800b26 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b1e:	83 c0 01             	add    $0x1,%eax
  800b21:	83 c2 01             	add    $0x1,%edx
  800b24:	eb ea                	jmp    800b10 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b26:	0f b6 c1             	movzbl %cl,%eax
  800b29:	0f b6 db             	movzbl %bl,%ebx
  800b2c:	29 d8                	sub    %ebx,%eax
  800b2e:	eb 05                	jmp    800b35 <memcmp+0x35>
	}

	return 0;
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b35:	5b                   	pop    %ebx
  800b36:	5e                   	pop    %esi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b42:	89 c2                	mov    %eax,%edx
  800b44:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b47:	39 d0                	cmp    %edx,%eax
  800b49:	73 09                	jae    800b54 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b4b:	38 08                	cmp    %cl,(%eax)
  800b4d:	74 05                	je     800b54 <memfind+0x1b>
	for (; s < ends; s++)
  800b4f:	83 c0 01             	add    $0x1,%eax
  800b52:	eb f3                	jmp    800b47 <memfind+0xe>
			break;
	return (void *) s;
}
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	57                   	push   %edi
  800b5a:	56                   	push   %esi
  800b5b:	53                   	push   %ebx
  800b5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b62:	eb 03                	jmp    800b67 <strtol+0x11>
		s++;
  800b64:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b67:	0f b6 01             	movzbl (%ecx),%eax
  800b6a:	3c 20                	cmp    $0x20,%al
  800b6c:	74 f6                	je     800b64 <strtol+0xe>
  800b6e:	3c 09                	cmp    $0x9,%al
  800b70:	74 f2                	je     800b64 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b72:	3c 2b                	cmp    $0x2b,%al
  800b74:	74 2e                	je     800ba4 <strtol+0x4e>
	int neg = 0;
  800b76:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b7b:	3c 2d                	cmp    $0x2d,%al
  800b7d:	74 2f                	je     800bae <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b7f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b85:	75 05                	jne    800b8c <strtol+0x36>
  800b87:	80 39 30             	cmpb   $0x30,(%ecx)
  800b8a:	74 2c                	je     800bb8 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b8c:	85 db                	test   %ebx,%ebx
  800b8e:	75 0a                	jne    800b9a <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b90:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b95:	80 39 30             	cmpb   $0x30,(%ecx)
  800b98:	74 28                	je     800bc2 <strtol+0x6c>
		base = 10;
  800b9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ba2:	eb 50                	jmp    800bf4 <strtol+0x9e>
		s++;
  800ba4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ba7:	bf 00 00 00 00       	mov    $0x0,%edi
  800bac:	eb d1                	jmp    800b7f <strtol+0x29>
		s++, neg = 1;
  800bae:	83 c1 01             	add    $0x1,%ecx
  800bb1:	bf 01 00 00 00       	mov    $0x1,%edi
  800bb6:	eb c7                	jmp    800b7f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bbc:	74 0e                	je     800bcc <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	75 d8                	jne    800b9a <strtol+0x44>
		s++, base = 8;
  800bc2:	83 c1 01             	add    $0x1,%ecx
  800bc5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bca:	eb ce                	jmp    800b9a <strtol+0x44>
		s += 2, base = 16;
  800bcc:	83 c1 02             	add    $0x2,%ecx
  800bcf:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bd4:	eb c4                	jmp    800b9a <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bd6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bd9:	89 f3                	mov    %esi,%ebx
  800bdb:	80 fb 19             	cmp    $0x19,%bl
  800bde:	77 29                	ja     800c09 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800be0:	0f be d2             	movsbl %dl,%edx
  800be3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800be6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800be9:	7d 30                	jge    800c1b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800beb:	83 c1 01             	add    $0x1,%ecx
  800bee:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bf2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bf4:	0f b6 11             	movzbl (%ecx),%edx
  800bf7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bfa:	89 f3                	mov    %esi,%ebx
  800bfc:	80 fb 09             	cmp    $0x9,%bl
  800bff:	77 d5                	ja     800bd6 <strtol+0x80>
			dig = *s - '0';
  800c01:	0f be d2             	movsbl %dl,%edx
  800c04:	83 ea 30             	sub    $0x30,%edx
  800c07:	eb dd                	jmp    800be6 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c09:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c0c:	89 f3                	mov    %esi,%ebx
  800c0e:	80 fb 19             	cmp    $0x19,%bl
  800c11:	77 08                	ja     800c1b <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c13:	0f be d2             	movsbl %dl,%edx
  800c16:	83 ea 37             	sub    $0x37,%edx
  800c19:	eb cb                	jmp    800be6 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1f:	74 05                	je     800c26 <strtol+0xd0>
		*endptr = (char *) s;
  800c21:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c24:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c26:	89 c2                	mov    %eax,%edx
  800c28:	f7 da                	neg    %edx
  800c2a:	85 ff                	test   %edi,%edi
  800c2c:	0f 45 c2             	cmovne %edx,%eax
}
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c45:	89 c3                	mov    %eax,%ebx
  800c47:	89 c7                	mov    %eax,%edi
  800c49:	89 c6                	mov    %eax,%esi
  800c4b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	57                   	push   %edi
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c58:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c62:	89 d1                	mov    %edx,%ecx
  800c64:	89 d3                	mov    %edx,%ebx
  800c66:	89 d7                	mov    %edx,%edi
  800c68:	89 d6                	mov    %edx,%esi
  800c6a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c6c:	5b                   	pop    %ebx
  800c6d:	5e                   	pop    %esi
  800c6e:	5f                   	pop    %edi
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	53                   	push   %ebx
  800c77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c82:	b8 03 00 00 00       	mov    $0x3,%eax
  800c87:	89 cb                	mov    %ecx,%ebx
  800c89:	89 cf                	mov    %ecx,%edi
  800c8b:	89 ce                	mov    %ecx,%esi
  800c8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	7f 08                	jg     800c9b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c96:	5b                   	pop    %ebx
  800c97:	5e                   	pop    %esi
  800c98:	5f                   	pop    %edi
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9b:	83 ec 0c             	sub    $0xc,%esp
  800c9e:	50                   	push   %eax
  800c9f:	6a 03                	push   $0x3
  800ca1:	68 5f 25 80 00       	push   $0x80255f
  800ca6:	6a 23                	push   $0x23
  800ca8:	68 7c 25 80 00       	push   $0x80257c
  800cad:	e8 80 f5 ff ff       	call   800232 <_panic>

00800cb2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	57                   	push   %edi
  800cb6:	56                   	push   %esi
  800cb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbd:	b8 02 00 00 00       	mov    $0x2,%eax
  800cc2:	89 d1                	mov    %edx,%ecx
  800cc4:	89 d3                	mov    %edx,%ebx
  800cc6:	89 d7                	mov    %edx,%edi
  800cc8:	89 d6                	mov    %edx,%esi
  800cca:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <sys_yield>:

void
sys_yield(void)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdc:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ce1:	89 d1                	mov    %edx,%ecx
  800ce3:	89 d3                	mov    %edx,%ebx
  800ce5:	89 d7                	mov    %edx,%edi
  800ce7:	89 d6                	mov    %edx,%esi
  800ce9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5f                   	pop    %edi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	57                   	push   %edi
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
  800cf6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf9:	be 00 00 00 00       	mov    $0x0,%esi
  800cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800d01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d04:	b8 04 00 00 00       	mov    $0x4,%eax
  800d09:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0c:	89 f7                	mov    %esi,%edi
  800d0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d10:	85 c0                	test   %eax,%eax
  800d12:	7f 08                	jg     800d1c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800d20:	6a 04                	push   $0x4
  800d22:	68 5f 25 80 00       	push   $0x80255f
  800d27:	6a 23                	push   $0x23
  800d29:	68 7c 25 80 00       	push   $0x80257c
  800d2e:	e8 ff f4 ff ff       	call   800232 <_panic>

00800d33 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d42:	b8 05 00 00 00       	mov    $0x5,%eax
  800d47:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d4d:	8b 75 18             	mov    0x18(%ebp),%esi
  800d50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d52:	85 c0                	test   %eax,%eax
  800d54:	7f 08                	jg     800d5e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d62:	6a 05                	push   $0x5
  800d64:	68 5f 25 80 00       	push   $0x80255f
  800d69:	6a 23                	push   $0x23
  800d6b:	68 7c 25 80 00       	push   $0x80257c
  800d70:	e8 bd f4 ff ff       	call   800232 <_panic>

00800d75 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d89:	b8 06 00 00 00       	mov    $0x6,%eax
  800d8e:	89 df                	mov    %ebx,%edi
  800d90:	89 de                	mov    %ebx,%esi
  800d92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d94:	85 c0                	test   %eax,%eax
  800d96:	7f 08                	jg     800da0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	50                   	push   %eax
  800da4:	6a 06                	push   $0x6
  800da6:	68 5f 25 80 00       	push   $0x80255f
  800dab:	6a 23                	push   $0x23
  800dad:	68 7c 25 80 00       	push   $0x80257c
  800db2:	e8 7b f4 ff ff       	call   800232 <_panic>

00800db7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
  800dbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dd0:	89 df                	mov    %ebx,%edi
  800dd2:	89 de                	mov    %ebx,%esi
  800dd4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	7f 08                	jg     800de2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddd:	5b                   	pop    %ebx
  800dde:	5e                   	pop    %esi
  800ddf:	5f                   	pop    %edi
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de2:	83 ec 0c             	sub    $0xc,%esp
  800de5:	50                   	push   %eax
  800de6:	6a 08                	push   $0x8
  800de8:	68 5f 25 80 00       	push   $0x80255f
  800ded:	6a 23                	push   $0x23
  800def:	68 7c 25 80 00       	push   $0x80257c
  800df4:	e8 39 f4 ff ff       	call   800232 <_panic>

00800df9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
  800dff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e02:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e07:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0d:	b8 09 00 00 00       	mov    $0x9,%eax
  800e12:	89 df                	mov    %ebx,%edi
  800e14:	89 de                	mov    %ebx,%esi
  800e16:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	7f 08                	jg     800e24 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e24:	83 ec 0c             	sub    $0xc,%esp
  800e27:	50                   	push   %eax
  800e28:	6a 09                	push   $0x9
  800e2a:	68 5f 25 80 00       	push   $0x80255f
  800e2f:	6a 23                	push   $0x23
  800e31:	68 7c 25 80 00       	push   $0x80257c
  800e36:	e8 f7 f3 ff ff       	call   800232 <_panic>

00800e3b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	57                   	push   %edi
  800e3f:	56                   	push   %esi
  800e40:	53                   	push   %ebx
  800e41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e54:	89 df                	mov    %ebx,%edi
  800e56:	89 de                	mov    %ebx,%esi
  800e58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	7f 08                	jg     800e66 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5f                   	pop    %edi
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e66:	83 ec 0c             	sub    $0xc,%esp
  800e69:	50                   	push   %eax
  800e6a:	6a 0a                	push   $0xa
  800e6c:	68 5f 25 80 00       	push   $0x80255f
  800e71:	6a 23                	push   $0x23
  800e73:	68 7c 25 80 00       	push   $0x80257c
  800e78:	e8 b5 f3 ff ff       	call   800232 <_panic>

00800e7d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	57                   	push   %edi
  800e81:	56                   	push   %esi
  800e82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8e:	be 00 00 00 00       	mov    $0x0,%esi
  800e93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e96:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e99:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb6:	89 cb                	mov    %ecx,%ebx
  800eb8:	89 cf                	mov    %ecx,%edi
  800eba:	89 ce                	mov    %ecx,%esi
  800ebc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7f 08                	jg     800eca <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eca:	83 ec 0c             	sub    $0xc,%esp
  800ecd:	50                   	push   %eax
  800ece:	6a 0d                	push   $0xd
  800ed0:	68 5f 25 80 00       	push   $0x80255f
  800ed5:	6a 23                	push   $0x23
  800ed7:	68 7c 25 80 00       	push   $0x80257c
  800edc:	e8 51 f3 ff ff       	call   800232 <_panic>

00800ee1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800ee7:	68 8a 25 80 00       	push   $0x80258a
  800eec:	6a 25                	push   $0x25
  800eee:	68 a2 25 80 00       	push   $0x8025a2
  800ef3:	e8 3a f3 ff ff       	call   800232 <_panic>

00800ef8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
  800efe:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  800f01:	68 e1 0e 80 00       	push   $0x800ee1
  800f06:	e8 ca 0e 00 00       	call   801dd5 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f0b:	b8 07 00 00 00       	mov    $0x7,%eax
  800f10:	cd 30                	int    $0x30
  800f12:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  800f18:	83 c4 10             	add    $0x10,%esp
  800f1b:	85 c0                	test   %eax,%eax
  800f1d:	78 27                	js     800f46 <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800f1f:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  800f24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f28:	75 65                	jne    800f8f <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f2a:	e8 83 fd ff ff       	call   800cb2 <sys_getenvid>
  800f2f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f34:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f37:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f3c:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f41:	e9 11 01 00 00       	jmp    801057 <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  800f46:	50                   	push   %eax
  800f47:	68 cc 21 80 00       	push   $0x8021cc
  800f4c:	6a 6f                	push   $0x6f
  800f4e:	68 a2 25 80 00       	push   $0x8025a2
  800f53:	e8 da f2 ff ff       	call   800232 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  800f58:	e8 55 fd ff ff       	call   800cb2 <sys_getenvid>
  800f5d:	83 ec 0c             	sub    $0xc,%esp
  800f60:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800f66:	56                   	push   %esi
  800f67:	57                   	push   %edi
  800f68:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f6b:	57                   	push   %edi
  800f6c:	50                   	push   %eax
  800f6d:	e8 c1 fd ff ff       	call   800d33 <sys_page_map>
  800f72:	83 c4 20             	add    $0x20,%esp
  800f75:	85 c0                	test   %eax,%eax
  800f77:	0f 88 84 00 00 00    	js     801001 <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800f7d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800f83:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800f89:	0f 84 84 00 00 00    	je     801013 <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  800f8f:	89 d8                	mov    %ebx,%eax
  800f91:	c1 e8 16             	shr    $0x16,%eax
  800f94:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f9b:	a8 01                	test   $0x1,%al
  800f9d:	74 de                	je     800f7d <fork+0x85>
  800f9f:	89 d8                	mov    %ebx,%eax
  800fa1:	c1 e8 0c             	shr    $0xc,%eax
  800fa4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fab:	f6 c2 01             	test   $0x1,%dl
  800fae:	74 cd                	je     800f7d <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  800fb0:	89 c7                	mov    %eax,%edi
  800fb2:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  800fb5:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  800fbc:	f7 c6 00 04 00 00    	test   $0x400,%esi
  800fc2:	75 94                	jne    800f58 <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  800fc4:	f7 c6 02 08 00 00    	test   $0x802,%esi
  800fca:	0f 85 d1 00 00 00    	jne    8010a1 <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800fd0:	a1 04 40 80 00       	mov    0x804004,%eax
  800fd5:	8b 40 48             	mov    0x48(%eax),%eax
  800fd8:	83 ec 0c             	sub    $0xc,%esp
  800fdb:	6a 05                	push   $0x5
  800fdd:	57                   	push   %edi
  800fde:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fe1:	57                   	push   %edi
  800fe2:	50                   	push   %eax
  800fe3:	e8 4b fd ff ff       	call   800d33 <sys_page_map>
  800fe8:	83 c4 20             	add    $0x20,%esp
  800feb:	85 c0                	test   %eax,%eax
  800fed:	79 8e                	jns    800f7d <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  800fef:	50                   	push   %eax
  800ff0:	68 fc 25 80 00       	push   $0x8025fc
  800ff5:	6a 4a                	push   $0x4a
  800ff7:	68 a2 25 80 00       	push   $0x8025a2
  800ffc:	e8 31 f2 ff ff       	call   800232 <_panic>
                        panic("duppage: page mapping failed %e", r);
  801001:	50                   	push   %eax
  801002:	68 dc 25 80 00       	push   $0x8025dc
  801007:	6a 41                	push   $0x41
  801009:	68 a2 25 80 00       	push   $0x8025a2
  80100e:	e8 1f f2 ff ff       	call   800232 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	6a 07                	push   $0x7
  801018:	68 00 f0 bf ee       	push   $0xeebff000
  80101d:	ff 75 e0             	pushl  -0x20(%ebp)
  801020:	e8 cb fc ff ff       	call   800cf0 <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  801025:	83 c4 10             	add    $0x10,%esp
  801028:	85 c0                	test   %eax,%eax
  80102a:	78 36                	js     801062 <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  80102c:	83 ec 08             	sub    $0x8,%esp
  80102f:	68 49 1e 80 00       	push   $0x801e49
  801034:	ff 75 e0             	pushl  -0x20(%ebp)
  801037:	e8 ff fd ff ff       	call   800e3b <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80103c:	83 c4 10             	add    $0x10,%esp
  80103f:	85 c0                	test   %eax,%eax
  801041:	78 34                	js     801077 <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801043:	83 ec 08             	sub    $0x8,%esp
  801046:	6a 02                	push   $0x2
  801048:	ff 75 e0             	pushl  -0x20(%ebp)
  80104b:	e8 67 fd ff ff       	call   800db7 <sys_env_set_status>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	85 c0                	test   %eax,%eax
  801055:	78 35                	js     80108c <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  801057:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105d:	5b                   	pop    %ebx
  80105e:	5e                   	pop    %esi
  80105f:	5f                   	pop    %edi
  801060:	5d                   	pop    %ebp
  801061:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  801062:	50                   	push   %eax
  801063:	68 cc 21 80 00       	push   $0x8021cc
  801068:	68 82 00 00 00       	push   $0x82
  80106d:	68 a2 25 80 00       	push   $0x8025a2
  801072:	e8 bb f1 ff ff       	call   800232 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801077:	50                   	push   %eax
  801078:	68 20 26 80 00       	push   $0x802620
  80107d:	68 87 00 00 00       	push   $0x87
  801082:	68 a2 25 80 00       	push   $0x8025a2
  801087:	e8 a6 f1 ff ff       	call   800232 <_panic>
        	panic("sys_env_set_status: %e", r);
  80108c:	50                   	push   %eax
  80108d:	68 ad 25 80 00       	push   $0x8025ad
  801092:	68 8b 00 00 00       	push   $0x8b
  801097:	68 a2 25 80 00       	push   $0x8025a2
  80109c:	e8 91 f1 ff ff       	call   800232 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  8010a1:	a1 04 40 80 00       	mov    0x804004,%eax
  8010a6:	8b 40 48             	mov    0x48(%eax),%eax
  8010a9:	83 ec 0c             	sub    $0xc,%esp
  8010ac:	68 05 08 00 00       	push   $0x805
  8010b1:	57                   	push   %edi
  8010b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010b5:	57                   	push   %edi
  8010b6:	50                   	push   %eax
  8010b7:	e8 77 fc ff ff       	call   800d33 <sys_page_map>
  8010bc:	83 c4 20             	add    $0x20,%esp
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	0f 88 28 ff ff ff    	js     800fef <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  8010c7:	a1 04 40 80 00       	mov    0x804004,%eax
  8010cc:	8b 50 48             	mov    0x48(%eax),%edx
  8010cf:	8b 40 48             	mov    0x48(%eax),%eax
  8010d2:	83 ec 0c             	sub    $0xc,%esp
  8010d5:	68 05 08 00 00       	push   $0x805
  8010da:	57                   	push   %edi
  8010db:	52                   	push   %edx
  8010dc:	57                   	push   %edi
  8010dd:	50                   	push   %eax
  8010de:	e8 50 fc ff ff       	call   800d33 <sys_page_map>
  8010e3:	83 c4 20             	add    $0x20,%esp
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	0f 89 8f fe ff ff    	jns    800f7d <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  8010ee:	50                   	push   %eax
  8010ef:	68 fc 25 80 00       	push   $0x8025fc
  8010f4:	6a 4f                	push   $0x4f
  8010f6:	68 a2 25 80 00       	push   $0x8025a2
  8010fb:	e8 32 f1 ff ff       	call   800232 <_panic>

00801100 <sfork>:

// Challenge!
int
sfork(void)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801106:	68 c4 25 80 00       	push   $0x8025c4
  80110b:	68 94 00 00 00       	push   $0x94
  801110:	68 a2 25 80 00       	push   $0x8025a2
  801115:	e8 18 f1 ff ff       	call   800232 <_panic>

0080111a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	05 00 00 00 30       	add    $0x30000000,%eax
  801125:	c1 e8 0c             	shr    $0xc,%eax
}
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    

0080112a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801135:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80113a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    

00801141 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801147:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80114c:	89 c2                	mov    %eax,%edx
  80114e:	c1 ea 16             	shr    $0x16,%edx
  801151:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801158:	f6 c2 01             	test   $0x1,%dl
  80115b:	74 2a                	je     801187 <fd_alloc+0x46>
  80115d:	89 c2                	mov    %eax,%edx
  80115f:	c1 ea 0c             	shr    $0xc,%edx
  801162:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801169:	f6 c2 01             	test   $0x1,%dl
  80116c:	74 19                	je     801187 <fd_alloc+0x46>
  80116e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801173:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801178:	75 d2                	jne    80114c <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80117a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801180:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801185:	eb 07                	jmp    80118e <fd_alloc+0x4d>
			*fd_store = fd;
  801187:	89 01                	mov    %eax,(%ecx)
			return 0;
  801189:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801196:	83 f8 1f             	cmp    $0x1f,%eax
  801199:	77 36                	ja     8011d1 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80119b:	c1 e0 0c             	shl    $0xc,%eax
  80119e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011a3:	89 c2                	mov    %eax,%edx
  8011a5:	c1 ea 16             	shr    $0x16,%edx
  8011a8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011af:	f6 c2 01             	test   $0x1,%dl
  8011b2:	74 24                	je     8011d8 <fd_lookup+0x48>
  8011b4:	89 c2                	mov    %eax,%edx
  8011b6:	c1 ea 0c             	shr    $0xc,%edx
  8011b9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c0:	f6 c2 01             	test   $0x1,%dl
  8011c3:	74 1a                	je     8011df <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c8:	89 02                	mov    %eax,(%edx)
	return 0;
  8011ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011cf:	5d                   	pop    %ebp
  8011d0:	c3                   	ret    
		return -E_INVAL;
  8011d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d6:	eb f7                	jmp    8011cf <fd_lookup+0x3f>
		return -E_INVAL;
  8011d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011dd:	eb f0                	jmp    8011cf <fd_lookup+0x3f>
  8011df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e4:	eb e9                	jmp    8011cf <fd_lookup+0x3f>

008011e6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 08             	sub    $0x8,%esp
  8011ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ef:	ba c4 26 80 00       	mov    $0x8026c4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8011f4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011f9:	39 08                	cmp    %ecx,(%eax)
  8011fb:	74 33                	je     801230 <dev_lookup+0x4a>
  8011fd:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801200:	8b 02                	mov    (%edx),%eax
  801202:	85 c0                	test   %eax,%eax
  801204:	75 f3                	jne    8011f9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801206:	a1 04 40 80 00       	mov    0x804004,%eax
  80120b:	8b 40 48             	mov    0x48(%eax),%eax
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	51                   	push   %ecx
  801212:	50                   	push   %eax
  801213:	68 44 26 80 00       	push   $0x802644
  801218:	e8 f0 f0 ff ff       	call   80030d <cprintf>
	*dev = 0;
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    
			*dev = devtab[i];
  801230:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801233:	89 01                	mov    %eax,(%ecx)
			return 0;
  801235:	b8 00 00 00 00       	mov    $0x0,%eax
  80123a:	eb f2                	jmp    80122e <dev_lookup+0x48>

0080123c <fd_close>:
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	57                   	push   %edi
  801240:	56                   	push   %esi
  801241:	53                   	push   %ebx
  801242:	83 ec 1c             	sub    $0x1c,%esp
  801245:	8b 75 08             	mov    0x8(%ebp),%esi
  801248:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80124b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80124e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80124f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801255:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801258:	50                   	push   %eax
  801259:	e8 32 ff ff ff       	call   801190 <fd_lookup>
  80125e:	89 c3                	mov    %eax,%ebx
  801260:	83 c4 08             	add    $0x8,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	78 05                	js     80126c <fd_close+0x30>
	    || fd != fd2)
  801267:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80126a:	74 16                	je     801282 <fd_close+0x46>
		return (must_exist ? r : 0);
  80126c:	89 f8                	mov    %edi,%eax
  80126e:	84 c0                	test   %al,%al
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
  801275:	0f 44 d8             	cmove  %eax,%ebx
}
  801278:	89 d8                	mov    %ebx,%eax
  80127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127d:	5b                   	pop    %ebx
  80127e:	5e                   	pop    %esi
  80127f:	5f                   	pop    %edi
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801282:	83 ec 08             	sub    $0x8,%esp
  801285:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801288:	50                   	push   %eax
  801289:	ff 36                	pushl  (%esi)
  80128b:	e8 56 ff ff ff       	call   8011e6 <dev_lookup>
  801290:	89 c3                	mov    %eax,%ebx
  801292:	83 c4 10             	add    $0x10,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	78 15                	js     8012ae <fd_close+0x72>
		if (dev->dev_close)
  801299:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80129c:	8b 40 10             	mov    0x10(%eax),%eax
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	74 1b                	je     8012be <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8012a3:	83 ec 0c             	sub    $0xc,%esp
  8012a6:	56                   	push   %esi
  8012a7:	ff d0                	call   *%eax
  8012a9:	89 c3                	mov    %eax,%ebx
  8012ab:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012ae:	83 ec 08             	sub    $0x8,%esp
  8012b1:	56                   	push   %esi
  8012b2:	6a 00                	push   $0x0
  8012b4:	e8 bc fa ff ff       	call   800d75 <sys_page_unmap>
	return r;
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	eb ba                	jmp    801278 <fd_close+0x3c>
			r = 0;
  8012be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c3:	eb e9                	jmp    8012ae <fd_close+0x72>

008012c5 <close>:

int
close(int fdnum)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ce:	50                   	push   %eax
  8012cf:	ff 75 08             	pushl  0x8(%ebp)
  8012d2:	e8 b9 fe ff ff       	call   801190 <fd_lookup>
  8012d7:	83 c4 08             	add    $0x8,%esp
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	78 10                	js     8012ee <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8012de:	83 ec 08             	sub    $0x8,%esp
  8012e1:	6a 01                	push   $0x1
  8012e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e6:	e8 51 ff ff ff       	call   80123c <fd_close>
  8012eb:	83 c4 10             	add    $0x10,%esp
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <close_all>:

void
close_all(void)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	53                   	push   %ebx
  8012f4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012f7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	53                   	push   %ebx
  801300:	e8 c0 ff ff ff       	call   8012c5 <close>
	for (i = 0; i < MAXFD; i++)
  801305:	83 c3 01             	add    $0x1,%ebx
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	83 fb 20             	cmp    $0x20,%ebx
  80130e:	75 ec                	jne    8012fc <close_all+0xc>
}
  801310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	57                   	push   %edi
  801319:	56                   	push   %esi
  80131a:	53                   	push   %ebx
  80131b:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80131e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801321:	50                   	push   %eax
  801322:	ff 75 08             	pushl  0x8(%ebp)
  801325:	e8 66 fe ff ff       	call   801190 <fd_lookup>
  80132a:	89 c3                	mov    %eax,%ebx
  80132c:	83 c4 08             	add    $0x8,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	0f 88 81 00 00 00    	js     8013b8 <dup+0xa3>
		return r;
	close(newfdnum);
  801337:	83 ec 0c             	sub    $0xc,%esp
  80133a:	ff 75 0c             	pushl  0xc(%ebp)
  80133d:	e8 83 ff ff ff       	call   8012c5 <close>

	newfd = INDEX2FD(newfdnum);
  801342:	8b 75 0c             	mov    0xc(%ebp),%esi
  801345:	c1 e6 0c             	shl    $0xc,%esi
  801348:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80134e:	83 c4 04             	add    $0x4,%esp
  801351:	ff 75 e4             	pushl  -0x1c(%ebp)
  801354:	e8 d1 fd ff ff       	call   80112a <fd2data>
  801359:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80135b:	89 34 24             	mov    %esi,(%esp)
  80135e:	e8 c7 fd ff ff       	call   80112a <fd2data>
  801363:	83 c4 10             	add    $0x10,%esp
  801366:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801368:	89 d8                	mov    %ebx,%eax
  80136a:	c1 e8 16             	shr    $0x16,%eax
  80136d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801374:	a8 01                	test   $0x1,%al
  801376:	74 11                	je     801389 <dup+0x74>
  801378:	89 d8                	mov    %ebx,%eax
  80137a:	c1 e8 0c             	shr    $0xc,%eax
  80137d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801384:	f6 c2 01             	test   $0x1,%dl
  801387:	75 39                	jne    8013c2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801389:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80138c:	89 d0                	mov    %edx,%eax
  80138e:	c1 e8 0c             	shr    $0xc,%eax
  801391:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801398:	83 ec 0c             	sub    $0xc,%esp
  80139b:	25 07 0e 00 00       	and    $0xe07,%eax
  8013a0:	50                   	push   %eax
  8013a1:	56                   	push   %esi
  8013a2:	6a 00                	push   $0x0
  8013a4:	52                   	push   %edx
  8013a5:	6a 00                	push   $0x0
  8013a7:	e8 87 f9 ff ff       	call   800d33 <sys_page_map>
  8013ac:	89 c3                	mov    %eax,%ebx
  8013ae:	83 c4 20             	add    $0x20,%esp
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	78 31                	js     8013e6 <dup+0xd1>
		goto err;

	return newfdnum;
  8013b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013b8:	89 d8                	mov    %ebx,%eax
  8013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013bd:	5b                   	pop    %ebx
  8013be:	5e                   	pop    %esi
  8013bf:	5f                   	pop    %edi
  8013c0:	5d                   	pop    %ebp
  8013c1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013c2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013c9:	83 ec 0c             	sub    $0xc,%esp
  8013cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8013d1:	50                   	push   %eax
  8013d2:	57                   	push   %edi
  8013d3:	6a 00                	push   $0x0
  8013d5:	53                   	push   %ebx
  8013d6:	6a 00                	push   $0x0
  8013d8:	e8 56 f9 ff ff       	call   800d33 <sys_page_map>
  8013dd:	89 c3                	mov    %eax,%ebx
  8013df:	83 c4 20             	add    $0x20,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	79 a3                	jns    801389 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013e6:	83 ec 08             	sub    $0x8,%esp
  8013e9:	56                   	push   %esi
  8013ea:	6a 00                	push   $0x0
  8013ec:	e8 84 f9 ff ff       	call   800d75 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013f1:	83 c4 08             	add    $0x8,%esp
  8013f4:	57                   	push   %edi
  8013f5:	6a 00                	push   $0x0
  8013f7:	e8 79 f9 ff ff       	call   800d75 <sys_page_unmap>
	return r;
  8013fc:	83 c4 10             	add    $0x10,%esp
  8013ff:	eb b7                	jmp    8013b8 <dup+0xa3>

00801401 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	53                   	push   %ebx
  801405:	83 ec 14             	sub    $0x14,%esp
  801408:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80140b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80140e:	50                   	push   %eax
  80140f:	53                   	push   %ebx
  801410:	e8 7b fd ff ff       	call   801190 <fd_lookup>
  801415:	83 c4 08             	add    $0x8,%esp
  801418:	85 c0                	test   %eax,%eax
  80141a:	78 3f                	js     80145b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141c:	83 ec 08             	sub    $0x8,%esp
  80141f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801422:	50                   	push   %eax
  801423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801426:	ff 30                	pushl  (%eax)
  801428:	e8 b9 fd ff ff       	call   8011e6 <dev_lookup>
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	78 27                	js     80145b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801434:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801437:	8b 42 08             	mov    0x8(%edx),%eax
  80143a:	83 e0 03             	and    $0x3,%eax
  80143d:	83 f8 01             	cmp    $0x1,%eax
  801440:	74 1e                	je     801460 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801445:	8b 40 08             	mov    0x8(%eax),%eax
  801448:	85 c0                	test   %eax,%eax
  80144a:	74 35                	je     801481 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	ff 75 10             	pushl  0x10(%ebp)
  801452:	ff 75 0c             	pushl  0xc(%ebp)
  801455:	52                   	push   %edx
  801456:	ff d0                	call   *%eax
  801458:	83 c4 10             	add    $0x10,%esp
}
  80145b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801460:	a1 04 40 80 00       	mov    0x804004,%eax
  801465:	8b 40 48             	mov    0x48(%eax),%eax
  801468:	83 ec 04             	sub    $0x4,%esp
  80146b:	53                   	push   %ebx
  80146c:	50                   	push   %eax
  80146d:	68 88 26 80 00       	push   $0x802688
  801472:	e8 96 ee ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  801477:	83 c4 10             	add    $0x10,%esp
  80147a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147f:	eb da                	jmp    80145b <read+0x5a>
		return -E_NOT_SUPP;
  801481:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801486:	eb d3                	jmp    80145b <read+0x5a>

00801488 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	57                   	push   %edi
  80148c:	56                   	push   %esi
  80148d:	53                   	push   %ebx
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	8b 7d 08             	mov    0x8(%ebp),%edi
  801494:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801497:	bb 00 00 00 00       	mov    $0x0,%ebx
  80149c:	39 f3                	cmp    %esi,%ebx
  80149e:	73 25                	jae    8014c5 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	89 f0                	mov    %esi,%eax
  8014a5:	29 d8                	sub    %ebx,%eax
  8014a7:	50                   	push   %eax
  8014a8:	89 d8                	mov    %ebx,%eax
  8014aa:	03 45 0c             	add    0xc(%ebp),%eax
  8014ad:	50                   	push   %eax
  8014ae:	57                   	push   %edi
  8014af:	e8 4d ff ff ff       	call   801401 <read>
		if (m < 0)
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	78 08                	js     8014c3 <readn+0x3b>
			return m;
		if (m == 0)
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	74 06                	je     8014c5 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8014bf:	01 c3                	add    %eax,%ebx
  8014c1:	eb d9                	jmp    80149c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014c5:	89 d8                	mov    %ebx,%eax
  8014c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ca:	5b                   	pop    %ebx
  8014cb:	5e                   	pop    %esi
  8014cc:	5f                   	pop    %edi
  8014cd:	5d                   	pop    %ebp
  8014ce:	c3                   	ret    

008014cf <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	53                   	push   %ebx
  8014d3:	83 ec 14             	sub    $0x14,%esp
  8014d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014dc:	50                   	push   %eax
  8014dd:	53                   	push   %ebx
  8014de:	e8 ad fc ff ff       	call   801190 <fd_lookup>
  8014e3:	83 c4 08             	add    $0x8,%esp
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	78 3a                	js     801524 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ea:	83 ec 08             	sub    $0x8,%esp
  8014ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f0:	50                   	push   %eax
  8014f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f4:	ff 30                	pushl  (%eax)
  8014f6:	e8 eb fc ff ff       	call   8011e6 <dev_lookup>
  8014fb:	83 c4 10             	add    $0x10,%esp
  8014fe:	85 c0                	test   %eax,%eax
  801500:	78 22                	js     801524 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801505:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801509:	74 1e                	je     801529 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80150b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150e:	8b 52 0c             	mov    0xc(%edx),%edx
  801511:	85 d2                	test   %edx,%edx
  801513:	74 35                	je     80154a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801515:	83 ec 04             	sub    $0x4,%esp
  801518:	ff 75 10             	pushl  0x10(%ebp)
  80151b:	ff 75 0c             	pushl  0xc(%ebp)
  80151e:	50                   	push   %eax
  80151f:	ff d2                	call   *%edx
  801521:	83 c4 10             	add    $0x10,%esp
}
  801524:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801527:	c9                   	leave  
  801528:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801529:	a1 04 40 80 00       	mov    0x804004,%eax
  80152e:	8b 40 48             	mov    0x48(%eax),%eax
  801531:	83 ec 04             	sub    $0x4,%esp
  801534:	53                   	push   %ebx
  801535:	50                   	push   %eax
  801536:	68 a4 26 80 00       	push   $0x8026a4
  80153b:	e8 cd ed ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801548:	eb da                	jmp    801524 <write+0x55>
		return -E_NOT_SUPP;
  80154a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80154f:	eb d3                	jmp    801524 <write+0x55>

00801551 <seek>:

int
seek(int fdnum, off_t offset)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801557:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80155a:	50                   	push   %eax
  80155b:	ff 75 08             	pushl  0x8(%ebp)
  80155e:	e8 2d fc ff ff       	call   801190 <fd_lookup>
  801563:	83 c4 08             	add    $0x8,%esp
  801566:	85 c0                	test   %eax,%eax
  801568:	78 0e                	js     801578 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80156a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801570:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801573:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	53                   	push   %ebx
  80157e:	83 ec 14             	sub    $0x14,%esp
  801581:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801584:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801587:	50                   	push   %eax
  801588:	53                   	push   %ebx
  801589:	e8 02 fc ff ff       	call   801190 <fd_lookup>
  80158e:	83 c4 08             	add    $0x8,%esp
  801591:	85 c0                	test   %eax,%eax
  801593:	78 37                	js     8015cc <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801595:	83 ec 08             	sub    $0x8,%esp
  801598:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159f:	ff 30                	pushl  (%eax)
  8015a1:	e8 40 fc ff ff       	call   8011e6 <dev_lookup>
  8015a6:	83 c4 10             	add    $0x10,%esp
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	78 1f                	js     8015cc <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015b4:	74 1b                	je     8015d1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b9:	8b 52 18             	mov    0x18(%edx),%edx
  8015bc:	85 d2                	test   %edx,%edx
  8015be:	74 32                	je     8015f2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015c0:	83 ec 08             	sub    $0x8,%esp
  8015c3:	ff 75 0c             	pushl  0xc(%ebp)
  8015c6:	50                   	push   %eax
  8015c7:	ff d2                	call   *%edx
  8015c9:	83 c4 10             	add    $0x10,%esp
}
  8015cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015d1:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015d6:	8b 40 48             	mov    0x48(%eax),%eax
  8015d9:	83 ec 04             	sub    $0x4,%esp
  8015dc:	53                   	push   %ebx
  8015dd:	50                   	push   %eax
  8015de:	68 64 26 80 00       	push   $0x802664
  8015e3:	e8 25 ed ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  8015e8:	83 c4 10             	add    $0x10,%esp
  8015eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f0:	eb da                	jmp    8015cc <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f7:	eb d3                	jmp    8015cc <ftruncate+0x52>

008015f9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	53                   	push   %ebx
  8015fd:	83 ec 14             	sub    $0x14,%esp
  801600:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801603:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801606:	50                   	push   %eax
  801607:	ff 75 08             	pushl  0x8(%ebp)
  80160a:	e8 81 fb ff ff       	call   801190 <fd_lookup>
  80160f:	83 c4 08             	add    $0x8,%esp
  801612:	85 c0                	test   %eax,%eax
  801614:	78 4b                	js     801661 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161c:	50                   	push   %eax
  80161d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801620:	ff 30                	pushl  (%eax)
  801622:	e8 bf fb ff ff       	call   8011e6 <dev_lookup>
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	85 c0                	test   %eax,%eax
  80162c:	78 33                	js     801661 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801631:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801635:	74 2f                	je     801666 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801637:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80163a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801641:	00 00 00 
	stat->st_isdir = 0;
  801644:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80164b:	00 00 00 
	stat->st_dev = dev;
  80164e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801654:	83 ec 08             	sub    $0x8,%esp
  801657:	53                   	push   %ebx
  801658:	ff 75 f0             	pushl  -0x10(%ebp)
  80165b:	ff 50 14             	call   *0x14(%eax)
  80165e:	83 c4 10             	add    $0x10,%esp
}
  801661:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801664:	c9                   	leave  
  801665:	c3                   	ret    
		return -E_NOT_SUPP;
  801666:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80166b:	eb f4                	jmp    801661 <fstat+0x68>

0080166d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	56                   	push   %esi
  801671:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801672:	83 ec 08             	sub    $0x8,%esp
  801675:	6a 00                	push   $0x0
  801677:	ff 75 08             	pushl  0x8(%ebp)
  80167a:	e8 e7 01 00 00       	call   801866 <open>
  80167f:	89 c3                	mov    %eax,%ebx
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	78 1b                	js     8016a3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801688:	83 ec 08             	sub    $0x8,%esp
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	50                   	push   %eax
  80168f:	e8 65 ff ff ff       	call   8015f9 <fstat>
  801694:	89 c6                	mov    %eax,%esi
	close(fd);
  801696:	89 1c 24             	mov    %ebx,(%esp)
  801699:	e8 27 fc ff ff       	call   8012c5 <close>
	return r;
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	89 f3                	mov    %esi,%ebx
}
  8016a3:	89 d8                	mov    %ebx,%eax
  8016a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a8:	5b                   	pop    %ebx
  8016a9:	5e                   	pop    %esi
  8016aa:	5d                   	pop    %ebp
  8016ab:	c3                   	ret    

008016ac <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	56                   	push   %esi
  8016b0:	53                   	push   %ebx
  8016b1:	89 c6                	mov    %eax,%esi
  8016b3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016b5:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016bc:	74 27                	je     8016e5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016be:	6a 07                	push   $0x7
  8016c0:	68 00 50 80 00       	push   $0x805000
  8016c5:	56                   	push   %esi
  8016c6:	ff 35 00 40 80 00    	pushl  0x804000
  8016cc:	e8 b6 07 00 00       	call   801e87 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016d1:	83 c4 0c             	add    $0xc,%esp
  8016d4:	6a 00                	push   $0x0
  8016d6:	53                   	push   %ebx
  8016d7:	6a 00                	push   $0x0
  8016d9:	e8 92 07 00 00       	call   801e70 <ipc_recv>
}
  8016de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e1:	5b                   	pop    %ebx
  8016e2:	5e                   	pop    %esi
  8016e3:	5d                   	pop    %ebp
  8016e4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016e5:	83 ec 0c             	sub    $0xc,%esp
  8016e8:	6a 01                	push   $0x1
  8016ea:	e8 af 07 00 00       	call   801e9e <ipc_find_env>
  8016ef:	a3 00 40 80 00       	mov    %eax,0x804000
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	eb c5                	jmp    8016be <fsipc+0x12>

008016f9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8b 40 0c             	mov    0xc(%eax),%eax
  801705:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80170a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801712:	ba 00 00 00 00       	mov    $0x0,%edx
  801717:	b8 02 00 00 00       	mov    $0x2,%eax
  80171c:	e8 8b ff ff ff       	call   8016ac <fsipc>
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <devfile_flush>:
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	8b 40 0c             	mov    0xc(%eax),%eax
  80172f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801734:	ba 00 00 00 00       	mov    $0x0,%edx
  801739:	b8 06 00 00 00       	mov    $0x6,%eax
  80173e:	e8 69 ff ff ff       	call   8016ac <fsipc>
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <devfile_stat>:
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	53                   	push   %ebx
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	8b 40 0c             	mov    0xc(%eax),%eax
  801755:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80175a:	ba 00 00 00 00       	mov    $0x0,%edx
  80175f:	b8 05 00 00 00       	mov    $0x5,%eax
  801764:	e8 43 ff ff ff       	call   8016ac <fsipc>
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 2c                	js     801799 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80176d:	83 ec 08             	sub    $0x8,%esp
  801770:	68 00 50 80 00       	push   $0x805000
  801775:	53                   	push   %ebx
  801776:	e8 7c f1 ff ff       	call   8008f7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80177b:	a1 80 50 80 00       	mov    0x805080,%eax
  801780:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801786:	a1 84 50 80 00       	mov    0x805084,%eax
  80178b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801791:	83 c4 10             	add    $0x10,%esp
  801794:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <devfile_write>:
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	83 ec 0c             	sub    $0xc,%esp
  8017a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a7:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8017ac:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8017b1:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b7:	8b 52 0c             	mov    0xc(%edx),%edx
  8017ba:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8017c0:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8017c5:	50                   	push   %eax
  8017c6:	ff 75 0c             	pushl  0xc(%ebp)
  8017c9:	68 08 50 80 00       	push   $0x805008
  8017ce:	e8 b2 f2 ff ff       	call   800a85 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d8:	b8 04 00 00 00       	mov    $0x4,%eax
  8017dd:	e8 ca fe ff ff       	call   8016ac <fsipc>
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <devfile_read>:
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	56                   	push   %esi
  8017e8:	53                   	push   %ebx
  8017e9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017f7:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801802:	b8 03 00 00 00       	mov    $0x3,%eax
  801807:	e8 a0 fe ff ff       	call   8016ac <fsipc>
  80180c:	89 c3                	mov    %eax,%ebx
  80180e:	85 c0                	test   %eax,%eax
  801810:	78 1f                	js     801831 <devfile_read+0x4d>
	assert(r <= n);
  801812:	39 f0                	cmp    %esi,%eax
  801814:	77 24                	ja     80183a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801816:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80181b:	7f 33                	jg     801850 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	50                   	push   %eax
  801821:	68 00 50 80 00       	push   $0x805000
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	e8 57 f2 ff ff       	call   800a85 <memmove>
	return r;
  80182e:	83 c4 10             	add    $0x10,%esp
}
  801831:	89 d8                	mov    %ebx,%eax
  801833:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801836:	5b                   	pop    %ebx
  801837:	5e                   	pop    %esi
  801838:	5d                   	pop    %ebp
  801839:	c3                   	ret    
	assert(r <= n);
  80183a:	68 d4 26 80 00       	push   $0x8026d4
  80183f:	68 db 26 80 00       	push   $0x8026db
  801844:	6a 7c                	push   $0x7c
  801846:	68 f0 26 80 00       	push   $0x8026f0
  80184b:	e8 e2 e9 ff ff       	call   800232 <_panic>
	assert(r <= PGSIZE);
  801850:	68 fb 26 80 00       	push   $0x8026fb
  801855:	68 db 26 80 00       	push   $0x8026db
  80185a:	6a 7d                	push   $0x7d
  80185c:	68 f0 26 80 00       	push   $0x8026f0
  801861:	e8 cc e9 ff ff       	call   800232 <_panic>

00801866 <open>:
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	56                   	push   %esi
  80186a:	53                   	push   %ebx
  80186b:	83 ec 1c             	sub    $0x1c,%esp
  80186e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801871:	56                   	push   %esi
  801872:	e8 49 f0 ff ff       	call   8008c0 <strlen>
  801877:	83 c4 10             	add    $0x10,%esp
  80187a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80187f:	7f 6c                	jg     8018ed <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801881:	83 ec 0c             	sub    $0xc,%esp
  801884:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801887:	50                   	push   %eax
  801888:	e8 b4 f8 ff ff       	call   801141 <fd_alloc>
  80188d:	89 c3                	mov    %eax,%ebx
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	85 c0                	test   %eax,%eax
  801894:	78 3c                	js     8018d2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801896:	83 ec 08             	sub    $0x8,%esp
  801899:	56                   	push   %esi
  80189a:	68 00 50 80 00       	push   $0x805000
  80189f:	e8 53 f0 ff ff       	call   8008f7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018af:	b8 01 00 00 00       	mov    $0x1,%eax
  8018b4:	e8 f3 fd ff ff       	call   8016ac <fsipc>
  8018b9:	89 c3                	mov    %eax,%ebx
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	78 19                	js     8018db <open+0x75>
	return fd2num(fd);
  8018c2:	83 ec 0c             	sub    $0xc,%esp
  8018c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c8:	e8 4d f8 ff ff       	call   80111a <fd2num>
  8018cd:	89 c3                	mov    %eax,%ebx
  8018cf:	83 c4 10             	add    $0x10,%esp
}
  8018d2:	89 d8                	mov    %ebx,%eax
  8018d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d7:	5b                   	pop    %ebx
  8018d8:	5e                   	pop    %esi
  8018d9:	5d                   	pop    %ebp
  8018da:	c3                   	ret    
		fd_close(fd, 0);
  8018db:	83 ec 08             	sub    $0x8,%esp
  8018de:	6a 00                	push   $0x0
  8018e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e3:	e8 54 f9 ff ff       	call   80123c <fd_close>
		return r;
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	eb e5                	jmp    8018d2 <open+0x6c>
		return -E_BAD_PATH;
  8018ed:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018f2:	eb de                	jmp    8018d2 <open+0x6c>

008018f4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ff:	b8 08 00 00 00       	mov    $0x8,%eax
  801904:	e8 a3 fd ff ff       	call   8016ac <fsipc>
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	56                   	push   %esi
  80190f:	53                   	push   %ebx
  801910:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801913:	83 ec 0c             	sub    $0xc,%esp
  801916:	ff 75 08             	pushl  0x8(%ebp)
  801919:	e8 0c f8 ff ff       	call   80112a <fd2data>
  80191e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801920:	83 c4 08             	add    $0x8,%esp
  801923:	68 07 27 80 00       	push   $0x802707
  801928:	53                   	push   %ebx
  801929:	e8 c9 ef ff ff       	call   8008f7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80192e:	8b 46 04             	mov    0x4(%esi),%eax
  801931:	2b 06                	sub    (%esi),%eax
  801933:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801939:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801940:	00 00 00 
	stat->st_dev = &devpipe;
  801943:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80194a:	30 80 00 
	return 0;
}
  80194d:	b8 00 00 00 00       	mov    $0x0,%eax
  801952:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801955:	5b                   	pop    %ebx
  801956:	5e                   	pop    %esi
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    

00801959 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	53                   	push   %ebx
  80195d:	83 ec 0c             	sub    $0xc,%esp
  801960:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801963:	53                   	push   %ebx
  801964:	6a 00                	push   $0x0
  801966:	e8 0a f4 ff ff       	call   800d75 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80196b:	89 1c 24             	mov    %ebx,(%esp)
  80196e:	e8 b7 f7 ff ff       	call   80112a <fd2data>
  801973:	83 c4 08             	add    $0x8,%esp
  801976:	50                   	push   %eax
  801977:	6a 00                	push   $0x0
  801979:	e8 f7 f3 ff ff       	call   800d75 <sys_page_unmap>
}
  80197e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <_pipeisclosed>:
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	57                   	push   %edi
  801987:	56                   	push   %esi
  801988:	53                   	push   %ebx
  801989:	83 ec 1c             	sub    $0x1c,%esp
  80198c:	89 c7                	mov    %eax,%edi
  80198e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801990:	a1 04 40 80 00       	mov    0x804004,%eax
  801995:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801998:	83 ec 0c             	sub    $0xc,%esp
  80199b:	57                   	push   %edi
  80199c:	e8 36 05 00 00       	call   801ed7 <pageref>
  8019a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019a4:	89 34 24             	mov    %esi,(%esp)
  8019a7:	e8 2b 05 00 00       	call   801ed7 <pageref>
		nn = thisenv->env_runs;
  8019ac:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019b2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	39 cb                	cmp    %ecx,%ebx
  8019ba:	74 1b                	je     8019d7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8019bc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019bf:	75 cf                	jne    801990 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019c1:	8b 42 58             	mov    0x58(%edx),%eax
  8019c4:	6a 01                	push   $0x1
  8019c6:	50                   	push   %eax
  8019c7:	53                   	push   %ebx
  8019c8:	68 0e 27 80 00       	push   $0x80270e
  8019cd:	e8 3b e9 ff ff       	call   80030d <cprintf>
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	eb b9                	jmp    801990 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8019d7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019da:	0f 94 c0             	sete   %al
  8019dd:	0f b6 c0             	movzbl %al,%eax
}
  8019e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019e3:	5b                   	pop    %ebx
  8019e4:	5e                   	pop    %esi
  8019e5:	5f                   	pop    %edi
  8019e6:	5d                   	pop    %ebp
  8019e7:	c3                   	ret    

008019e8 <devpipe_write>:
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	57                   	push   %edi
  8019ec:	56                   	push   %esi
  8019ed:	53                   	push   %ebx
  8019ee:	83 ec 28             	sub    $0x28,%esp
  8019f1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8019f4:	56                   	push   %esi
  8019f5:	e8 30 f7 ff ff       	call   80112a <fd2data>
  8019fa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	bf 00 00 00 00       	mov    $0x0,%edi
  801a04:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a07:	74 4f                	je     801a58 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a09:	8b 43 04             	mov    0x4(%ebx),%eax
  801a0c:	8b 0b                	mov    (%ebx),%ecx
  801a0e:	8d 51 20             	lea    0x20(%ecx),%edx
  801a11:	39 d0                	cmp    %edx,%eax
  801a13:	72 14                	jb     801a29 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a15:	89 da                	mov    %ebx,%edx
  801a17:	89 f0                	mov    %esi,%eax
  801a19:	e8 65 ff ff ff       	call   801983 <_pipeisclosed>
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	75 3a                	jne    801a5c <devpipe_write+0x74>
			sys_yield();
  801a22:	e8 aa f2 ff ff       	call   800cd1 <sys_yield>
  801a27:	eb e0                	jmp    801a09 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a2c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a30:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	c1 fa 1f             	sar    $0x1f,%edx
  801a38:	89 d1                	mov    %edx,%ecx
  801a3a:	c1 e9 1b             	shr    $0x1b,%ecx
  801a3d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a40:	83 e2 1f             	and    $0x1f,%edx
  801a43:	29 ca                	sub    %ecx,%edx
  801a45:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801a49:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801a4d:	83 c0 01             	add    $0x1,%eax
  801a50:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a53:	83 c7 01             	add    $0x1,%edi
  801a56:	eb ac                	jmp    801a04 <devpipe_write+0x1c>
	return i;
  801a58:	89 f8                	mov    %edi,%eax
  801a5a:	eb 05                	jmp    801a61 <devpipe_write+0x79>
				return 0;
  801a5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a64:	5b                   	pop    %ebx
  801a65:	5e                   	pop    %esi
  801a66:	5f                   	pop    %edi
  801a67:	5d                   	pop    %ebp
  801a68:	c3                   	ret    

00801a69 <devpipe_read>:
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	57                   	push   %edi
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
  801a6f:	83 ec 18             	sub    $0x18,%esp
  801a72:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a75:	57                   	push   %edi
  801a76:	e8 af f6 ff ff       	call   80112a <fd2data>
  801a7b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	be 00 00 00 00       	mov    $0x0,%esi
  801a85:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a88:	74 47                	je     801ad1 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801a8a:	8b 03                	mov    (%ebx),%eax
  801a8c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a8f:	75 22                	jne    801ab3 <devpipe_read+0x4a>
			if (i > 0)
  801a91:	85 f6                	test   %esi,%esi
  801a93:	75 14                	jne    801aa9 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801a95:	89 da                	mov    %ebx,%edx
  801a97:	89 f8                	mov    %edi,%eax
  801a99:	e8 e5 fe ff ff       	call   801983 <_pipeisclosed>
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	75 33                	jne    801ad5 <devpipe_read+0x6c>
			sys_yield();
  801aa2:	e8 2a f2 ff ff       	call   800cd1 <sys_yield>
  801aa7:	eb e1                	jmp    801a8a <devpipe_read+0x21>
				return i;
  801aa9:	89 f0                	mov    %esi,%eax
}
  801aab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aae:	5b                   	pop    %ebx
  801aaf:	5e                   	pop    %esi
  801ab0:	5f                   	pop    %edi
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ab3:	99                   	cltd   
  801ab4:	c1 ea 1b             	shr    $0x1b,%edx
  801ab7:	01 d0                	add    %edx,%eax
  801ab9:	83 e0 1f             	and    $0x1f,%eax
  801abc:	29 d0                	sub    %edx,%eax
  801abe:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ac3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ac6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ac9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801acc:	83 c6 01             	add    $0x1,%esi
  801acf:	eb b4                	jmp    801a85 <devpipe_read+0x1c>
	return i;
  801ad1:	89 f0                	mov    %esi,%eax
  801ad3:	eb d6                	jmp    801aab <devpipe_read+0x42>
				return 0;
  801ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  801ada:	eb cf                	jmp    801aab <devpipe_read+0x42>

00801adc <pipe>:
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	56                   	push   %esi
  801ae0:	53                   	push   %ebx
  801ae1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ae4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae7:	50                   	push   %eax
  801ae8:	e8 54 f6 ff ff       	call   801141 <fd_alloc>
  801aed:	89 c3                	mov    %eax,%ebx
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	85 c0                	test   %eax,%eax
  801af4:	78 5b                	js     801b51 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801af6:	83 ec 04             	sub    $0x4,%esp
  801af9:	68 07 04 00 00       	push   $0x407
  801afe:	ff 75 f4             	pushl  -0xc(%ebp)
  801b01:	6a 00                	push   $0x0
  801b03:	e8 e8 f1 ff ff       	call   800cf0 <sys_page_alloc>
  801b08:	89 c3                	mov    %eax,%ebx
  801b0a:	83 c4 10             	add    $0x10,%esp
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	78 40                	js     801b51 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801b11:	83 ec 0c             	sub    $0xc,%esp
  801b14:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b17:	50                   	push   %eax
  801b18:	e8 24 f6 ff ff       	call   801141 <fd_alloc>
  801b1d:	89 c3                	mov    %eax,%ebx
  801b1f:	83 c4 10             	add    $0x10,%esp
  801b22:	85 c0                	test   %eax,%eax
  801b24:	78 1b                	js     801b41 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b26:	83 ec 04             	sub    $0x4,%esp
  801b29:	68 07 04 00 00       	push   $0x407
  801b2e:	ff 75 f0             	pushl  -0x10(%ebp)
  801b31:	6a 00                	push   $0x0
  801b33:	e8 b8 f1 ff ff       	call   800cf0 <sys_page_alloc>
  801b38:	89 c3                	mov    %eax,%ebx
  801b3a:	83 c4 10             	add    $0x10,%esp
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	79 19                	jns    801b5a <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801b41:	83 ec 08             	sub    $0x8,%esp
  801b44:	ff 75 f4             	pushl  -0xc(%ebp)
  801b47:	6a 00                	push   $0x0
  801b49:	e8 27 f2 ff ff       	call   800d75 <sys_page_unmap>
  801b4e:	83 c4 10             	add    $0x10,%esp
}
  801b51:	89 d8                	mov    %ebx,%eax
  801b53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b56:	5b                   	pop    %ebx
  801b57:	5e                   	pop    %esi
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    
	va = fd2data(fd0);
  801b5a:	83 ec 0c             	sub    $0xc,%esp
  801b5d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b60:	e8 c5 f5 ff ff       	call   80112a <fd2data>
  801b65:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b67:	83 c4 0c             	add    $0xc,%esp
  801b6a:	68 07 04 00 00       	push   $0x407
  801b6f:	50                   	push   %eax
  801b70:	6a 00                	push   $0x0
  801b72:	e8 79 f1 ff ff       	call   800cf0 <sys_page_alloc>
  801b77:	89 c3                	mov    %eax,%ebx
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	0f 88 8c 00 00 00    	js     801c10 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b84:	83 ec 0c             	sub    $0xc,%esp
  801b87:	ff 75 f0             	pushl  -0x10(%ebp)
  801b8a:	e8 9b f5 ff ff       	call   80112a <fd2data>
  801b8f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b96:	50                   	push   %eax
  801b97:	6a 00                	push   $0x0
  801b99:	56                   	push   %esi
  801b9a:	6a 00                	push   $0x0
  801b9c:	e8 92 f1 ff ff       	call   800d33 <sys_page_map>
  801ba1:	89 c3                	mov    %eax,%ebx
  801ba3:	83 c4 20             	add    $0x20,%esp
  801ba6:	85 c0                	test   %eax,%eax
  801ba8:	78 58                	js     801c02 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bad:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bb3:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bc8:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bcd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801bd4:	83 ec 0c             	sub    $0xc,%esp
  801bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bda:	e8 3b f5 ff ff       	call   80111a <fd2num>
  801bdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801be2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801be4:	83 c4 04             	add    $0x4,%esp
  801be7:	ff 75 f0             	pushl  -0x10(%ebp)
  801bea:	e8 2b f5 ff ff       	call   80111a <fd2num>
  801bef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bf2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801bf5:	83 c4 10             	add    $0x10,%esp
  801bf8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bfd:	e9 4f ff ff ff       	jmp    801b51 <pipe+0x75>
	sys_page_unmap(0, va);
  801c02:	83 ec 08             	sub    $0x8,%esp
  801c05:	56                   	push   %esi
  801c06:	6a 00                	push   $0x0
  801c08:	e8 68 f1 ff ff       	call   800d75 <sys_page_unmap>
  801c0d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c10:	83 ec 08             	sub    $0x8,%esp
  801c13:	ff 75 f0             	pushl  -0x10(%ebp)
  801c16:	6a 00                	push   $0x0
  801c18:	e8 58 f1 ff ff       	call   800d75 <sys_page_unmap>
  801c1d:	83 c4 10             	add    $0x10,%esp
  801c20:	e9 1c ff ff ff       	jmp    801b41 <pipe+0x65>

00801c25 <pipeisclosed>:
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c2e:	50                   	push   %eax
  801c2f:	ff 75 08             	pushl  0x8(%ebp)
  801c32:	e8 59 f5 ff ff       	call   801190 <fd_lookup>
  801c37:	83 c4 10             	add    $0x10,%esp
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	78 18                	js     801c56 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c3e:	83 ec 0c             	sub    $0xc,%esp
  801c41:	ff 75 f4             	pushl  -0xc(%ebp)
  801c44:	e8 e1 f4 ff ff       	call   80112a <fd2data>
	return _pipeisclosed(fd, p);
  801c49:	89 c2                	mov    %eax,%edx
  801c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4e:	e8 30 fd ff ff       	call   801983 <_pipeisclosed>
  801c53:	83 c4 10             	add    $0x10,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c60:	5d                   	pop    %ebp
  801c61:	c3                   	ret    

00801c62 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801c68:	68 26 27 80 00       	push   $0x802726
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	e8 82 ec ff ff       	call   8008f7 <strcpy>
	return 0;
}
  801c75:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <devcons_write>:
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	57                   	push   %edi
  801c80:	56                   	push   %esi
  801c81:	53                   	push   %ebx
  801c82:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801c88:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801c8d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801c93:	eb 2f                	jmp    801cc4 <devcons_write+0x48>
		m = n - tot;
  801c95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c98:	29 f3                	sub    %esi,%ebx
  801c9a:	83 fb 7f             	cmp    $0x7f,%ebx
  801c9d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ca2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ca5:	83 ec 04             	sub    $0x4,%esp
  801ca8:	53                   	push   %ebx
  801ca9:	89 f0                	mov    %esi,%eax
  801cab:	03 45 0c             	add    0xc(%ebp),%eax
  801cae:	50                   	push   %eax
  801caf:	57                   	push   %edi
  801cb0:	e8 d0 ed ff ff       	call   800a85 <memmove>
		sys_cputs(buf, m);
  801cb5:	83 c4 08             	add    $0x8,%esp
  801cb8:	53                   	push   %ebx
  801cb9:	57                   	push   %edi
  801cba:	e8 75 ef ff ff       	call   800c34 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801cbf:	01 de                	add    %ebx,%esi
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cc7:	72 cc                	jb     801c95 <devcons_write+0x19>
}
  801cc9:	89 f0                	mov    %esi,%eax
  801ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cce:	5b                   	pop    %ebx
  801ccf:	5e                   	pop    %esi
  801cd0:	5f                   	pop    %edi
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <devcons_read>:
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	83 ec 08             	sub    $0x8,%esp
  801cd9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ce2:	75 07                	jne    801ceb <devcons_read+0x18>
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    
		sys_yield();
  801ce6:	e8 e6 ef ff ff       	call   800cd1 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801ceb:	e8 62 ef ff ff       	call   800c52 <sys_cgetc>
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	74 f2                	je     801ce6 <devcons_read+0x13>
	if (c < 0)
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	78 ec                	js     801ce4 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801cf8:	83 f8 04             	cmp    $0x4,%eax
  801cfb:	74 0c                	je     801d09 <devcons_read+0x36>
	*(char*)vbuf = c;
  801cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d00:	88 02                	mov    %al,(%edx)
	return 1;
  801d02:	b8 01 00 00 00       	mov    $0x1,%eax
  801d07:	eb db                	jmp    801ce4 <devcons_read+0x11>
		return 0;
  801d09:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0e:	eb d4                	jmp    801ce4 <devcons_read+0x11>

00801d10 <cputchar>:
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d1c:	6a 01                	push   $0x1
  801d1e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d21:	50                   	push   %eax
  801d22:	e8 0d ef ff ff       	call   800c34 <sys_cputs>
}
  801d27:	83 c4 10             	add    $0x10,%esp
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <getchar>:
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d32:	6a 01                	push   $0x1
  801d34:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d37:	50                   	push   %eax
  801d38:	6a 00                	push   $0x0
  801d3a:	e8 c2 f6 ff ff       	call   801401 <read>
	if (r < 0)
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	85 c0                	test   %eax,%eax
  801d44:	78 08                	js     801d4e <getchar+0x22>
	if (r < 1)
  801d46:	85 c0                	test   %eax,%eax
  801d48:	7e 06                	jle    801d50 <getchar+0x24>
	return c;
  801d4a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    
		return -E_EOF;
  801d50:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d55:	eb f7                	jmp    801d4e <getchar+0x22>

00801d57 <iscons>:
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d5d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d60:	50                   	push   %eax
  801d61:	ff 75 08             	pushl  0x8(%ebp)
  801d64:	e8 27 f4 ff ff       	call   801190 <fd_lookup>
  801d69:	83 c4 10             	add    $0x10,%esp
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	78 11                	js     801d81 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d73:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d79:	39 10                	cmp    %edx,(%eax)
  801d7b:	0f 94 c0             	sete   %al
  801d7e:	0f b6 c0             	movzbl %al,%eax
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <opencons>:
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801d89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d8c:	50                   	push   %eax
  801d8d:	e8 af f3 ff ff       	call   801141 <fd_alloc>
  801d92:	83 c4 10             	add    $0x10,%esp
  801d95:	85 c0                	test   %eax,%eax
  801d97:	78 3a                	js     801dd3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d99:	83 ec 04             	sub    $0x4,%esp
  801d9c:	68 07 04 00 00       	push   $0x407
  801da1:	ff 75 f4             	pushl  -0xc(%ebp)
  801da4:	6a 00                	push   $0x0
  801da6:	e8 45 ef ff ff       	call   800cf0 <sys_page_alloc>
  801dab:	83 c4 10             	add    $0x10,%esp
  801dae:	85 c0                	test   %eax,%eax
  801db0:	78 21                	js     801dd3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dbb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801dc7:	83 ec 0c             	sub    $0xc,%esp
  801dca:	50                   	push   %eax
  801dcb:	e8 4a f3 ff ff       	call   80111a <fd2num>
  801dd0:	83 c4 10             	add    $0x10,%esp
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	53                   	push   %ebx
  801dd9:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801ddc:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801de3:	74 0d                	je     801df2 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
  801de8:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801ded:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801df2:	e8 bb ee ff ff       	call   800cb2 <sys_getenvid>
  801df7:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801df9:	83 ec 04             	sub    $0x4,%esp
  801dfc:	6a 07                	push   $0x7
  801dfe:	68 00 f0 bf ee       	push   $0xeebff000
  801e03:	50                   	push   %eax
  801e04:	e8 e7 ee ff ff       	call   800cf0 <sys_page_alloc>
        	if (r < 0) {
  801e09:	83 c4 10             	add    $0x10,%esp
  801e0c:	85 c0                	test   %eax,%eax
  801e0e:	78 27                	js     801e37 <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801e10:	83 ec 08             	sub    $0x8,%esp
  801e13:	68 49 1e 80 00       	push   $0x801e49
  801e18:	53                   	push   %ebx
  801e19:	e8 1d f0 ff ff       	call   800e3b <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801e1e:	83 c4 10             	add    $0x10,%esp
  801e21:	85 c0                	test   %eax,%eax
  801e23:	79 c0                	jns    801de5 <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801e25:	50                   	push   %eax
  801e26:	68 32 27 80 00       	push   $0x802732
  801e2b:	6a 28                	push   $0x28
  801e2d:	68 46 27 80 00       	push   $0x802746
  801e32:	e8 fb e3 ff ff       	call   800232 <_panic>
            		panic("pgfault_handler: %e", r);
  801e37:	50                   	push   %eax
  801e38:	68 32 27 80 00       	push   $0x802732
  801e3d:	6a 24                	push   $0x24
  801e3f:	68 46 27 80 00       	push   $0x802746
  801e44:	e8 e9 e3 ff ff       	call   800232 <_panic>

00801e49 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801e49:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801e4a:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801e4f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801e51:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  801e54:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801e58:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801e5b:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801e5f:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  801e63:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801e66:	83 c4 08             	add    $0x8,%esp
	popal
  801e69:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801e6a:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801e6d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801e6e:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801e6f:	c3                   	ret    

00801e70 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801e76:	68 54 27 80 00       	push   $0x802754
  801e7b:	6a 1a                	push   $0x1a
  801e7d:	68 6d 27 80 00       	push   $0x80276d
  801e82:	e8 ab e3 ff ff       	call   800232 <_panic>

00801e87 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801e8d:	68 77 27 80 00       	push   $0x802777
  801e92:	6a 2a                	push   $0x2a
  801e94:	68 6d 27 80 00       	push   $0x80276d
  801e99:	e8 94 e3 ff ff       	call   800232 <_panic>

00801e9e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801ea9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801eac:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801eb2:	8b 52 50             	mov    0x50(%edx),%edx
  801eb5:	39 ca                	cmp    %ecx,%edx
  801eb7:	74 11                	je     801eca <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801eb9:	83 c0 01             	add    $0x1,%eax
  801ebc:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ec1:	75 e6                	jne    801ea9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec8:	eb 0b                	jmp    801ed5 <ipc_find_env+0x37>
			return envs[i].env_id;
  801eca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ecd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ed2:	8b 40 48             	mov    0x48(%eax),%eax
}
  801ed5:	5d                   	pop    %ebp
  801ed6:	c3                   	ret    

00801ed7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801edd:	89 d0                	mov    %edx,%eax
  801edf:	c1 e8 16             	shr    $0x16,%eax
  801ee2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ee9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801eee:	f6 c1 01             	test   $0x1,%cl
  801ef1:	74 1d                	je     801f10 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ef3:	c1 ea 0c             	shr    $0xc,%edx
  801ef6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801efd:	f6 c2 01             	test   $0x1,%dl
  801f00:	74 0e                	je     801f10 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f02:	c1 ea 0c             	shr    $0xc,%edx
  801f05:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f0c:	ef 
  801f0d:	0f b7 c0             	movzwl %ax,%eax
}
  801f10:	5d                   	pop    %ebp
  801f11:	c3                   	ret    
  801f12:	66 90                	xchg   %ax,%ax
  801f14:	66 90                	xchg   %ax,%ax
  801f16:	66 90                	xchg   %ax,%ax
  801f18:	66 90                	xchg   %ax,%ax
  801f1a:	66 90                	xchg   %ax,%ax
  801f1c:	66 90                	xchg   %ax,%ax
  801f1e:	66 90                	xchg   %ax,%ax

00801f20 <__udivdi3>:
  801f20:	55                   	push   %ebp
  801f21:	57                   	push   %edi
  801f22:	56                   	push   %esi
  801f23:	53                   	push   %ebx
  801f24:	83 ec 1c             	sub    $0x1c,%esp
  801f27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801f2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f37:	85 d2                	test   %edx,%edx
  801f39:	75 35                	jne    801f70 <__udivdi3+0x50>
  801f3b:	39 f3                	cmp    %esi,%ebx
  801f3d:	0f 87 bd 00 00 00    	ja     802000 <__udivdi3+0xe0>
  801f43:	85 db                	test   %ebx,%ebx
  801f45:	89 d9                	mov    %ebx,%ecx
  801f47:	75 0b                	jne    801f54 <__udivdi3+0x34>
  801f49:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4e:	31 d2                	xor    %edx,%edx
  801f50:	f7 f3                	div    %ebx
  801f52:	89 c1                	mov    %eax,%ecx
  801f54:	31 d2                	xor    %edx,%edx
  801f56:	89 f0                	mov    %esi,%eax
  801f58:	f7 f1                	div    %ecx
  801f5a:	89 c6                	mov    %eax,%esi
  801f5c:	89 e8                	mov    %ebp,%eax
  801f5e:	89 f7                	mov    %esi,%edi
  801f60:	f7 f1                	div    %ecx
  801f62:	89 fa                	mov    %edi,%edx
  801f64:	83 c4 1c             	add    $0x1c,%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5f                   	pop    %edi
  801f6a:	5d                   	pop    %ebp
  801f6b:	c3                   	ret    
  801f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f70:	39 f2                	cmp    %esi,%edx
  801f72:	77 7c                	ja     801ff0 <__udivdi3+0xd0>
  801f74:	0f bd fa             	bsr    %edx,%edi
  801f77:	83 f7 1f             	xor    $0x1f,%edi
  801f7a:	0f 84 98 00 00 00    	je     802018 <__udivdi3+0xf8>
  801f80:	89 f9                	mov    %edi,%ecx
  801f82:	b8 20 00 00 00       	mov    $0x20,%eax
  801f87:	29 f8                	sub    %edi,%eax
  801f89:	d3 e2                	shl    %cl,%edx
  801f8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f8f:	89 c1                	mov    %eax,%ecx
  801f91:	89 da                	mov    %ebx,%edx
  801f93:	d3 ea                	shr    %cl,%edx
  801f95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f99:	09 d1                	or     %edx,%ecx
  801f9b:	89 f2                	mov    %esi,%edx
  801f9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fa1:	89 f9                	mov    %edi,%ecx
  801fa3:	d3 e3                	shl    %cl,%ebx
  801fa5:	89 c1                	mov    %eax,%ecx
  801fa7:	d3 ea                	shr    %cl,%edx
  801fa9:	89 f9                	mov    %edi,%ecx
  801fab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801faf:	d3 e6                	shl    %cl,%esi
  801fb1:	89 eb                	mov    %ebp,%ebx
  801fb3:	89 c1                	mov    %eax,%ecx
  801fb5:	d3 eb                	shr    %cl,%ebx
  801fb7:	09 de                	or     %ebx,%esi
  801fb9:	89 f0                	mov    %esi,%eax
  801fbb:	f7 74 24 08          	divl   0x8(%esp)
  801fbf:	89 d6                	mov    %edx,%esi
  801fc1:	89 c3                	mov    %eax,%ebx
  801fc3:	f7 64 24 0c          	mull   0xc(%esp)
  801fc7:	39 d6                	cmp    %edx,%esi
  801fc9:	72 0c                	jb     801fd7 <__udivdi3+0xb7>
  801fcb:	89 f9                	mov    %edi,%ecx
  801fcd:	d3 e5                	shl    %cl,%ebp
  801fcf:	39 c5                	cmp    %eax,%ebp
  801fd1:	73 5d                	jae    802030 <__udivdi3+0x110>
  801fd3:	39 d6                	cmp    %edx,%esi
  801fd5:	75 59                	jne    802030 <__udivdi3+0x110>
  801fd7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fda:	31 ff                	xor    %edi,%edi
  801fdc:	89 fa                	mov    %edi,%edx
  801fde:	83 c4 1c             	add    $0x1c,%esp
  801fe1:	5b                   	pop    %ebx
  801fe2:	5e                   	pop    %esi
  801fe3:	5f                   	pop    %edi
  801fe4:	5d                   	pop    %ebp
  801fe5:	c3                   	ret    
  801fe6:	8d 76 00             	lea    0x0(%esi),%esi
  801fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801ff0:	31 ff                	xor    %edi,%edi
  801ff2:	31 c0                	xor    %eax,%eax
  801ff4:	89 fa                	mov    %edi,%edx
  801ff6:	83 c4 1c             	add    $0x1c,%esp
  801ff9:	5b                   	pop    %ebx
  801ffa:	5e                   	pop    %esi
  801ffb:	5f                   	pop    %edi
  801ffc:	5d                   	pop    %ebp
  801ffd:	c3                   	ret    
  801ffe:	66 90                	xchg   %ax,%ax
  802000:	31 ff                	xor    %edi,%edi
  802002:	89 e8                	mov    %ebp,%eax
  802004:	89 f2                	mov    %esi,%edx
  802006:	f7 f3                	div    %ebx
  802008:	89 fa                	mov    %edi,%edx
  80200a:	83 c4 1c             	add    $0x1c,%esp
  80200d:	5b                   	pop    %ebx
  80200e:	5e                   	pop    %esi
  80200f:	5f                   	pop    %edi
  802010:	5d                   	pop    %ebp
  802011:	c3                   	ret    
  802012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802018:	39 f2                	cmp    %esi,%edx
  80201a:	72 06                	jb     802022 <__udivdi3+0x102>
  80201c:	31 c0                	xor    %eax,%eax
  80201e:	39 eb                	cmp    %ebp,%ebx
  802020:	77 d2                	ja     801ff4 <__udivdi3+0xd4>
  802022:	b8 01 00 00 00       	mov    $0x1,%eax
  802027:	eb cb                	jmp    801ff4 <__udivdi3+0xd4>
  802029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802030:	89 d8                	mov    %ebx,%eax
  802032:	31 ff                	xor    %edi,%edi
  802034:	eb be                	jmp    801ff4 <__udivdi3+0xd4>
  802036:	66 90                	xchg   %ax,%ax
  802038:	66 90                	xchg   %ax,%ax
  80203a:	66 90                	xchg   %ax,%ax
  80203c:	66 90                	xchg   %ax,%ax
  80203e:	66 90                	xchg   %ax,%ax

00802040 <__umoddi3>:
  802040:	55                   	push   %ebp
  802041:	57                   	push   %edi
  802042:	56                   	push   %esi
  802043:	53                   	push   %ebx
  802044:	83 ec 1c             	sub    $0x1c,%esp
  802047:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80204b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80204f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802053:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802057:	85 ed                	test   %ebp,%ebp
  802059:	89 f0                	mov    %esi,%eax
  80205b:	89 da                	mov    %ebx,%edx
  80205d:	75 19                	jne    802078 <__umoddi3+0x38>
  80205f:	39 df                	cmp    %ebx,%edi
  802061:	0f 86 b1 00 00 00    	jbe    802118 <__umoddi3+0xd8>
  802067:	f7 f7                	div    %edi
  802069:	89 d0                	mov    %edx,%eax
  80206b:	31 d2                	xor    %edx,%edx
  80206d:	83 c4 1c             	add    $0x1c,%esp
  802070:	5b                   	pop    %ebx
  802071:	5e                   	pop    %esi
  802072:	5f                   	pop    %edi
  802073:	5d                   	pop    %ebp
  802074:	c3                   	ret    
  802075:	8d 76 00             	lea    0x0(%esi),%esi
  802078:	39 dd                	cmp    %ebx,%ebp
  80207a:	77 f1                	ja     80206d <__umoddi3+0x2d>
  80207c:	0f bd cd             	bsr    %ebp,%ecx
  80207f:	83 f1 1f             	xor    $0x1f,%ecx
  802082:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802086:	0f 84 b4 00 00 00    	je     802140 <__umoddi3+0x100>
  80208c:	b8 20 00 00 00       	mov    $0x20,%eax
  802091:	89 c2                	mov    %eax,%edx
  802093:	8b 44 24 04          	mov    0x4(%esp),%eax
  802097:	29 c2                	sub    %eax,%edx
  802099:	89 c1                	mov    %eax,%ecx
  80209b:	89 f8                	mov    %edi,%eax
  80209d:	d3 e5                	shl    %cl,%ebp
  80209f:	89 d1                	mov    %edx,%ecx
  8020a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8020a5:	d3 e8                	shr    %cl,%eax
  8020a7:	09 c5                	or     %eax,%ebp
  8020a9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020ad:	89 c1                	mov    %eax,%ecx
  8020af:	d3 e7                	shl    %cl,%edi
  8020b1:	89 d1                	mov    %edx,%ecx
  8020b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8020b7:	89 df                	mov    %ebx,%edi
  8020b9:	d3 ef                	shr    %cl,%edi
  8020bb:	89 c1                	mov    %eax,%ecx
  8020bd:	89 f0                	mov    %esi,%eax
  8020bf:	d3 e3                	shl    %cl,%ebx
  8020c1:	89 d1                	mov    %edx,%ecx
  8020c3:	89 fa                	mov    %edi,%edx
  8020c5:	d3 e8                	shr    %cl,%eax
  8020c7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8020cc:	09 d8                	or     %ebx,%eax
  8020ce:	f7 f5                	div    %ebp
  8020d0:	d3 e6                	shl    %cl,%esi
  8020d2:	89 d1                	mov    %edx,%ecx
  8020d4:	f7 64 24 08          	mull   0x8(%esp)
  8020d8:	39 d1                	cmp    %edx,%ecx
  8020da:	89 c3                	mov    %eax,%ebx
  8020dc:	89 d7                	mov    %edx,%edi
  8020de:	72 06                	jb     8020e6 <__umoddi3+0xa6>
  8020e0:	75 0e                	jne    8020f0 <__umoddi3+0xb0>
  8020e2:	39 c6                	cmp    %eax,%esi
  8020e4:	73 0a                	jae    8020f0 <__umoddi3+0xb0>
  8020e6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8020ea:	19 ea                	sbb    %ebp,%edx
  8020ec:	89 d7                	mov    %edx,%edi
  8020ee:	89 c3                	mov    %eax,%ebx
  8020f0:	89 ca                	mov    %ecx,%edx
  8020f2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8020f7:	29 de                	sub    %ebx,%esi
  8020f9:	19 fa                	sbb    %edi,%edx
  8020fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8020ff:	89 d0                	mov    %edx,%eax
  802101:	d3 e0                	shl    %cl,%eax
  802103:	89 d9                	mov    %ebx,%ecx
  802105:	d3 ee                	shr    %cl,%esi
  802107:	d3 ea                	shr    %cl,%edx
  802109:	09 f0                	or     %esi,%eax
  80210b:	83 c4 1c             	add    $0x1c,%esp
  80210e:	5b                   	pop    %ebx
  80210f:	5e                   	pop    %esi
  802110:	5f                   	pop    %edi
  802111:	5d                   	pop    %ebp
  802112:	c3                   	ret    
  802113:	90                   	nop
  802114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802118:	85 ff                	test   %edi,%edi
  80211a:	89 f9                	mov    %edi,%ecx
  80211c:	75 0b                	jne    802129 <__umoddi3+0xe9>
  80211e:	b8 01 00 00 00       	mov    $0x1,%eax
  802123:	31 d2                	xor    %edx,%edx
  802125:	f7 f7                	div    %edi
  802127:	89 c1                	mov    %eax,%ecx
  802129:	89 d8                	mov    %ebx,%eax
  80212b:	31 d2                	xor    %edx,%edx
  80212d:	f7 f1                	div    %ecx
  80212f:	89 f0                	mov    %esi,%eax
  802131:	f7 f1                	div    %ecx
  802133:	e9 31 ff ff ff       	jmp    802069 <__umoddi3+0x29>
  802138:	90                   	nop
  802139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802140:	39 dd                	cmp    %ebx,%ebp
  802142:	72 08                	jb     80214c <__umoddi3+0x10c>
  802144:	39 f7                	cmp    %esi,%edi
  802146:	0f 87 21 ff ff ff    	ja     80206d <__umoddi3+0x2d>
  80214c:	89 da                	mov    %ebx,%edx
  80214e:	89 f0                	mov    %esi,%eax
  802150:	29 f8                	sub    %edi,%eax
  802152:	19 ea                	sbb    %ebp,%edx
  802154:	e9 14 ff ff ff       	jmp    80206d <__umoddi3+0x2d>
