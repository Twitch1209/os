
obj/user/primes.debug：     文件格式 elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	6a 00                	push   $0x0
  800044:	6a 00                	push   $0x0
  800046:	56                   	push   %esi
  800047:	e8 f4 0f 00 00       	call   801040 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 04 40 80 00       	mov    0x804004,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 80 20 80 00       	push   $0x802080
  800060:	e8 ce 01 00 00       	call   800233 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 b4 0d 00 00       	call   800e1e <fork>
  80006a:	89 c7                	mov    %eax,%edi
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	85 c0                	test   %eax,%eax
  800071:	78 30                	js     8000a3 <primeproc+0x70>
		panic("fork: %e", id);
	if (id == 0)
  800073:	85 c0                	test   %eax,%eax
  800075:	74 c8                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800077:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	6a 00                	push   $0x0
  80007f:	6a 00                	push   $0x0
  800081:	56                   	push   %esi
  800082:	e8 b9 0f 00 00       	call   801040 <ipc_recv>
  800087:	89 c1                	mov    %eax,%ecx
		if (i % p)
  800089:	99                   	cltd   
  80008a:	f7 fb                	idiv   %ebx
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	85 d2                	test   %edx,%edx
  800091:	74 e7                	je     80007a <primeproc+0x47>
			ipc_send(id, i, 0, 0);
  800093:	6a 00                	push   $0x0
  800095:	6a 00                	push   $0x0
  800097:	51                   	push   %ecx
  800098:	57                   	push   %edi
  800099:	e8 b9 0f 00 00       	call   801057 <ipc_send>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	eb d7                	jmp    80007a <primeproc+0x47>
		panic("fork: %e", id);
  8000a3:	50                   	push   %eax
  8000a4:	68 8c 20 80 00       	push   $0x80208c
  8000a9:	6a 1a                	push   $0x1a
  8000ab:	68 95 20 80 00       	push   $0x802095
  8000b0:	e8 a3 00 00 00       	call   800158 <_panic>

008000b5 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ba:	e8 5f 0d 00 00       	call   800e1e <fork>
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 1c                	js     8000e1 <umain+0x2c>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000c5:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	74 25                	je     8000f3 <umain+0x3e>
		ipc_send(id, i, 0, 0);
  8000ce:	6a 00                	push   $0x0
  8000d0:	6a 00                	push   $0x0
  8000d2:	53                   	push   %ebx
  8000d3:	56                   	push   %esi
  8000d4:	e8 7e 0f 00 00       	call   801057 <ipc_send>
	for (i = 2; ; i++)
  8000d9:	83 c3 01             	add    $0x1,%ebx
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	eb ed                	jmp    8000ce <umain+0x19>
		panic("fork: %e", id);
  8000e1:	50                   	push   %eax
  8000e2:	68 8c 20 80 00       	push   $0x80208c
  8000e7:	6a 2d                	push   $0x2d
  8000e9:	68 95 20 80 00       	push   $0x802095
  8000ee:	e8 65 00 00 00       	call   800158 <_panic>
		primeproc();
  8000f3:	e8 3b ff ff ff       	call   800033 <primeproc>

008000f8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800100:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800103:	e8 d0 0a 00 00       	call   800bd8 <sys_getenvid>
  800108:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800110:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800115:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011a:	85 db                	test   %ebx,%ebx
  80011c:	7e 07                	jle    800125 <libmain+0x2d>
		binaryname = argv[0];
  80011e:	8b 06                	mov    (%esi),%eax
  800120:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800125:	83 ec 08             	sub    $0x8,%esp
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	e8 86 ff ff ff       	call   8000b5 <umain>

	// exit gracefully
	exit();
  80012f:	e8 0a 00 00 00       	call   80013e <exit>
}
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5d                   	pop    %ebp
  80013d:	c3                   	ret    

0080013e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800144:	e8 34 11 00 00       	call   80127d <close_all>
	sys_env_destroy(0);
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	6a 00                	push   $0x0
  80014e:	e8 44 0a 00 00       	call   800b97 <sys_env_destroy>
}
  800153:	83 c4 10             	add    $0x10,%esp
  800156:	c9                   	leave  
  800157:	c3                   	ret    

00800158 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80015d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800160:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800166:	e8 6d 0a 00 00       	call   800bd8 <sys_getenvid>
  80016b:	83 ec 0c             	sub    $0xc,%esp
  80016e:	ff 75 0c             	pushl  0xc(%ebp)
  800171:	ff 75 08             	pushl  0x8(%ebp)
  800174:	56                   	push   %esi
  800175:	50                   	push   %eax
  800176:	68 b0 20 80 00       	push   $0x8020b0
  80017b:	e8 b3 00 00 00       	call   800233 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800180:	83 c4 18             	add    $0x18,%esp
  800183:	53                   	push   %ebx
  800184:	ff 75 10             	pushl  0x10(%ebp)
  800187:	e8 56 00 00 00       	call   8001e2 <vcprintf>
	cprintf("\n");
  80018c:	c7 04 24 db 25 80 00 	movl   $0x8025db,(%esp)
  800193:	e8 9b 00 00 00       	call   800233 <cprintf>
  800198:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80019b:	cc                   	int3   
  80019c:	eb fd                	jmp    80019b <_panic+0x43>

0080019e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	53                   	push   %ebx
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a8:	8b 13                	mov    (%ebx),%edx
  8001aa:	8d 42 01             	lea    0x1(%edx),%eax
  8001ad:	89 03                	mov    %eax,(%ebx)
  8001af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001bb:	74 09                	je     8001c6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001bd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c6:	83 ec 08             	sub    $0x8,%esp
  8001c9:	68 ff 00 00 00       	push   $0xff
  8001ce:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d1:	50                   	push   %eax
  8001d2:	e8 83 09 00 00       	call   800b5a <sys_cputs>
		b->idx = 0;
  8001d7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001dd:	83 c4 10             	add    $0x10,%esp
  8001e0:	eb db                	jmp    8001bd <putch+0x1f>

008001e2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f2:	00 00 00 
	b.cnt = 0;
  8001f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001fc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ff:	ff 75 0c             	pushl  0xc(%ebp)
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020b:	50                   	push   %eax
  80020c:	68 9e 01 80 00       	push   $0x80019e
  800211:	e8 1a 01 00 00       	call   800330 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800216:	83 c4 08             	add    $0x8,%esp
  800219:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80021f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800225:	50                   	push   %eax
  800226:	e8 2f 09 00 00       	call   800b5a <sys_cputs>

	return b.cnt;
}
  80022b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800239:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023c:	50                   	push   %eax
  80023d:	ff 75 08             	pushl  0x8(%ebp)
  800240:	e8 9d ff ff ff       	call   8001e2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	57                   	push   %edi
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	83 ec 1c             	sub    $0x1c,%esp
  800250:	89 c7                	mov    %eax,%edi
  800252:	89 d6                	mov    %edx,%esi
  800254:	8b 45 08             	mov    0x8(%ebp),%eax
  800257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80025d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800260:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800263:	bb 00 00 00 00       	mov    $0x0,%ebx
  800268:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80026b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80026e:	39 d3                	cmp    %edx,%ebx
  800270:	72 05                	jb     800277 <printnum+0x30>
  800272:	39 45 10             	cmp    %eax,0x10(%ebp)
  800275:	77 7a                	ja     8002f1 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	ff 75 18             	pushl  0x18(%ebp)
  80027d:	8b 45 14             	mov    0x14(%ebp),%eax
  800280:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800283:	53                   	push   %ebx
  800284:	ff 75 10             	pushl  0x10(%ebp)
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028d:	ff 75 e0             	pushl  -0x20(%ebp)
  800290:	ff 75 dc             	pushl  -0x24(%ebp)
  800293:	ff 75 d8             	pushl  -0x28(%ebp)
  800296:	e8 a5 1b 00 00       	call   801e40 <__udivdi3>
  80029b:	83 c4 18             	add    $0x18,%esp
  80029e:	52                   	push   %edx
  80029f:	50                   	push   %eax
  8002a0:	89 f2                	mov    %esi,%edx
  8002a2:	89 f8                	mov    %edi,%eax
  8002a4:	e8 9e ff ff ff       	call   800247 <printnum>
  8002a9:	83 c4 20             	add    $0x20,%esp
  8002ac:	eb 13                	jmp    8002c1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	56                   	push   %esi
  8002b2:	ff 75 18             	pushl  0x18(%ebp)
  8002b5:	ff d7                	call   *%edi
  8002b7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002ba:	83 eb 01             	sub    $0x1,%ebx
  8002bd:	85 db                	test   %ebx,%ebx
  8002bf:	7f ed                	jg     8002ae <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	56                   	push   %esi
  8002c5:	83 ec 04             	sub    $0x4,%esp
  8002c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d4:	e8 87 1c 00 00       	call   801f60 <__umoddi3>
  8002d9:	83 c4 14             	add    $0x14,%esp
  8002dc:	0f be 80 d3 20 80 00 	movsbl 0x8020d3(%eax),%eax
  8002e3:	50                   	push   %eax
  8002e4:	ff d7                	call   *%edi
}
  8002e6:	83 c4 10             	add    $0x10,%esp
  8002e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ec:	5b                   	pop    %ebx
  8002ed:	5e                   	pop    %esi
  8002ee:	5f                   	pop    %edi
  8002ef:	5d                   	pop    %ebp
  8002f0:	c3                   	ret    
  8002f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002f4:	eb c4                	jmp    8002ba <printnum+0x73>

008002f6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f6:	55                   	push   %ebp
  8002f7:	89 e5                	mov    %esp,%ebp
  8002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002fc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800300:	8b 10                	mov    (%eax),%edx
  800302:	3b 50 04             	cmp    0x4(%eax),%edx
  800305:	73 0a                	jae    800311 <sprintputch+0x1b>
		*b->buf++ = ch;
  800307:	8d 4a 01             	lea    0x1(%edx),%ecx
  80030a:	89 08                	mov    %ecx,(%eax)
  80030c:	8b 45 08             	mov    0x8(%ebp),%eax
  80030f:	88 02                	mov    %al,(%edx)
}
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <printfmt>:
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800319:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031c:	50                   	push   %eax
  80031d:	ff 75 10             	pushl  0x10(%ebp)
  800320:	ff 75 0c             	pushl  0xc(%ebp)
  800323:	ff 75 08             	pushl  0x8(%ebp)
  800326:	e8 05 00 00 00       	call   800330 <vprintfmt>
}
  80032b:	83 c4 10             	add    $0x10,%esp
  80032e:	c9                   	leave  
  80032f:	c3                   	ret    

00800330 <vprintfmt>:
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	57                   	push   %edi
  800334:	56                   	push   %esi
  800335:	53                   	push   %ebx
  800336:	83 ec 2c             	sub    $0x2c,%esp
  800339:	8b 75 08             	mov    0x8(%ebp),%esi
  80033c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800342:	e9 8c 03 00 00       	jmp    8006d3 <vprintfmt+0x3a3>
		padc = ' ';
  800347:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80034b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800352:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800359:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800360:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800365:	8d 47 01             	lea    0x1(%edi),%eax
  800368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036b:	0f b6 17             	movzbl (%edi),%edx
  80036e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800371:	3c 55                	cmp    $0x55,%al
  800373:	0f 87 dd 03 00 00    	ja     800756 <vprintfmt+0x426>
  800379:	0f b6 c0             	movzbl %al,%eax
  80037c:	ff 24 85 20 22 80 00 	jmp    *0x802220(,%eax,4)
  800383:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800386:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80038a:	eb d9                	jmp    800365 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80038f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800393:	eb d0                	jmp    800365 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800395:	0f b6 d2             	movzbl %dl,%edx
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80039b:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003a3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003aa:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ad:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003b0:	83 f9 09             	cmp    $0x9,%ecx
  8003b3:	77 55                	ja     80040a <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003b5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b8:	eb e9                	jmp    8003a3 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c5:	8d 40 04             	lea    0x4(%eax),%eax
  8003c8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d2:	79 91                	jns    800365 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003da:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003e1:	eb 82                	jmp    800365 <vprintfmt+0x35>
  8003e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e6:	85 c0                	test   %eax,%eax
  8003e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ed:	0f 49 d0             	cmovns %eax,%edx
  8003f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f6:	e9 6a ff ff ff       	jmp    800365 <vprintfmt+0x35>
  8003fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003fe:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800405:	e9 5b ff ff ff       	jmp    800365 <vprintfmt+0x35>
  80040a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80040d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800410:	eb bc                	jmp    8003ce <vprintfmt+0x9e>
			lflag++;
  800412:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800415:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800418:	e9 48 ff ff ff       	jmp    800365 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80041d:	8b 45 14             	mov    0x14(%ebp),%eax
  800420:	8d 78 04             	lea    0x4(%eax),%edi
  800423:	83 ec 08             	sub    $0x8,%esp
  800426:	53                   	push   %ebx
  800427:	ff 30                	pushl  (%eax)
  800429:	ff d6                	call   *%esi
			break;
  80042b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80042e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800431:	e9 9a 02 00 00       	jmp    8006d0 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800436:	8b 45 14             	mov    0x14(%ebp),%eax
  800439:	8d 78 04             	lea    0x4(%eax),%edi
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	99                   	cltd   
  80043f:	31 d0                	xor    %edx,%eax
  800441:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800443:	83 f8 0f             	cmp    $0xf,%eax
  800446:	7f 23                	jg     80046b <vprintfmt+0x13b>
  800448:	8b 14 85 80 23 80 00 	mov    0x802380(,%eax,4),%edx
  80044f:	85 d2                	test   %edx,%edx
  800451:	74 18                	je     80046b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800453:	52                   	push   %edx
  800454:	68 a9 25 80 00       	push   $0x8025a9
  800459:	53                   	push   %ebx
  80045a:	56                   	push   %esi
  80045b:	e8 b3 fe ff ff       	call   800313 <printfmt>
  800460:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800463:	89 7d 14             	mov    %edi,0x14(%ebp)
  800466:	e9 65 02 00 00       	jmp    8006d0 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  80046b:	50                   	push   %eax
  80046c:	68 eb 20 80 00       	push   $0x8020eb
  800471:	53                   	push   %ebx
  800472:	56                   	push   %esi
  800473:	e8 9b fe ff ff       	call   800313 <printfmt>
  800478:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80047e:	e9 4d 02 00 00       	jmp    8006d0 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800483:	8b 45 14             	mov    0x14(%ebp),%eax
  800486:	83 c0 04             	add    $0x4,%eax
  800489:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80048c:	8b 45 14             	mov    0x14(%ebp),%eax
  80048f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800491:	85 ff                	test   %edi,%edi
  800493:	b8 e4 20 80 00       	mov    $0x8020e4,%eax
  800498:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80049b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049f:	0f 8e bd 00 00 00    	jle    800562 <vprintfmt+0x232>
  8004a5:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004a9:	75 0e                	jne    8004b9 <vprintfmt+0x189>
  8004ab:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ae:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004b1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004b4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004b7:	eb 6d                	jmp    800526 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	ff 75 d0             	pushl  -0x30(%ebp)
  8004bf:	57                   	push   %edi
  8004c0:	e8 39 03 00 00       	call   8007fe <strnlen>
  8004c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c8:	29 c1                	sub    %eax,%ecx
  8004ca:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004cd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004d0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004da:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004dc:	eb 0f                	jmp    8004ed <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	53                   	push   %ebx
  8004e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e7:	83 ef 01             	sub    $0x1,%edi
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	85 ff                	test   %edi,%edi
  8004ef:	7f ed                	jg     8004de <vprintfmt+0x1ae>
  8004f1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004f4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004f7:	85 c9                	test   %ecx,%ecx
  8004f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fe:	0f 49 c1             	cmovns %ecx,%eax
  800501:	29 c1                	sub    %eax,%ecx
  800503:	89 75 08             	mov    %esi,0x8(%ebp)
  800506:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800509:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80050c:	89 cb                	mov    %ecx,%ebx
  80050e:	eb 16                	jmp    800526 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800510:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800514:	75 31                	jne    800547 <vprintfmt+0x217>
					putch(ch, putdat);
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	ff 75 0c             	pushl  0xc(%ebp)
  80051c:	50                   	push   %eax
  80051d:	ff 55 08             	call   *0x8(%ebp)
  800520:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800523:	83 eb 01             	sub    $0x1,%ebx
  800526:	83 c7 01             	add    $0x1,%edi
  800529:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80052d:	0f be c2             	movsbl %dl,%eax
  800530:	85 c0                	test   %eax,%eax
  800532:	74 59                	je     80058d <vprintfmt+0x25d>
  800534:	85 f6                	test   %esi,%esi
  800536:	78 d8                	js     800510 <vprintfmt+0x1e0>
  800538:	83 ee 01             	sub    $0x1,%esi
  80053b:	79 d3                	jns    800510 <vprintfmt+0x1e0>
  80053d:	89 df                	mov    %ebx,%edi
  80053f:	8b 75 08             	mov    0x8(%ebp),%esi
  800542:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800545:	eb 37                	jmp    80057e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800547:	0f be d2             	movsbl %dl,%edx
  80054a:	83 ea 20             	sub    $0x20,%edx
  80054d:	83 fa 5e             	cmp    $0x5e,%edx
  800550:	76 c4                	jbe    800516 <vprintfmt+0x1e6>
					putch('?', putdat);
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	ff 75 0c             	pushl  0xc(%ebp)
  800558:	6a 3f                	push   $0x3f
  80055a:	ff 55 08             	call   *0x8(%ebp)
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	eb c1                	jmp    800523 <vprintfmt+0x1f3>
  800562:	89 75 08             	mov    %esi,0x8(%ebp)
  800565:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800568:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80056b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80056e:	eb b6                	jmp    800526 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	53                   	push   %ebx
  800574:	6a 20                	push   $0x20
  800576:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800578:	83 ef 01             	sub    $0x1,%edi
  80057b:	83 c4 10             	add    $0x10,%esp
  80057e:	85 ff                	test   %edi,%edi
  800580:	7f ee                	jg     800570 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800582:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800585:	89 45 14             	mov    %eax,0x14(%ebp)
  800588:	e9 43 01 00 00       	jmp    8006d0 <vprintfmt+0x3a0>
  80058d:	89 df                	mov    %ebx,%edi
  80058f:	8b 75 08             	mov    0x8(%ebp),%esi
  800592:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800595:	eb e7                	jmp    80057e <vprintfmt+0x24e>
	if (lflag >= 2)
  800597:	83 f9 01             	cmp    $0x1,%ecx
  80059a:	7e 3f                	jle    8005db <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 50 04             	mov    0x4(%eax),%edx
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 08             	lea    0x8(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005b7:	79 5c                	jns    800615 <vprintfmt+0x2e5>
				putch('-', putdat);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	53                   	push   %ebx
  8005bd:	6a 2d                	push   $0x2d
  8005bf:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005c7:	f7 da                	neg    %edx
  8005c9:	83 d1 00             	adc    $0x0,%ecx
  8005cc:	f7 d9                	neg    %ecx
  8005ce:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d6:	e9 db 00 00 00       	jmp    8006b6 <vprintfmt+0x386>
	else if (lflag)
  8005db:	85 c9                	test   %ecx,%ecx
  8005dd:	75 1b                	jne    8005fa <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e7:	89 c1                	mov    %eax,%ecx
  8005e9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ec:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8d 40 04             	lea    0x4(%eax),%eax
  8005f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f8:	eb b9                	jmp    8005b3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800602:	89 c1                	mov    %eax,%ecx
  800604:	c1 f9 1f             	sar    $0x1f,%ecx
  800607:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8d 40 04             	lea    0x4(%eax),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	eb 9e                	jmp    8005b3 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800615:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800618:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80061b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800620:	e9 91 00 00 00       	jmp    8006b6 <vprintfmt+0x386>
	if (lflag >= 2)
  800625:	83 f9 01             	cmp    $0x1,%ecx
  800628:	7e 15                	jle    80063f <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8b 10                	mov    (%eax),%edx
  80062f:	8b 48 04             	mov    0x4(%eax),%ecx
  800632:	8d 40 08             	lea    0x8(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800638:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063d:	eb 77                	jmp    8006b6 <vprintfmt+0x386>
	else if (lflag)
  80063f:	85 c9                	test   %ecx,%ecx
  800641:	75 17                	jne    80065a <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8b 10                	mov    (%eax),%edx
  800648:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064d:	8d 40 04             	lea    0x4(%eax),%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800653:	b8 0a 00 00 00       	mov    $0xa,%eax
  800658:	eb 5c                	jmp    8006b6 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 10                	mov    (%eax),%edx
  80065f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066f:	eb 45                	jmp    8006b6 <vprintfmt+0x386>
			putch('X', putdat);
  800671:	83 ec 08             	sub    $0x8,%esp
  800674:	53                   	push   %ebx
  800675:	6a 58                	push   $0x58
  800677:	ff d6                	call   *%esi
			putch('X', putdat);
  800679:	83 c4 08             	add    $0x8,%esp
  80067c:	53                   	push   %ebx
  80067d:	6a 58                	push   $0x58
  80067f:	ff d6                	call   *%esi
			putch('X', putdat);
  800681:	83 c4 08             	add    $0x8,%esp
  800684:	53                   	push   %ebx
  800685:	6a 58                	push   $0x58
  800687:	ff d6                	call   *%esi
			break;
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	eb 42                	jmp    8006d0 <vprintfmt+0x3a0>
			putch('0', putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	53                   	push   %ebx
  800692:	6a 30                	push   $0x30
  800694:	ff d6                	call   *%esi
			putch('x', putdat);
  800696:	83 c4 08             	add    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	6a 78                	push   $0x78
  80069c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8b 10                	mov    (%eax),%edx
  8006a3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006a8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ab:	8d 40 04             	lea    0x4(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006b6:	83 ec 0c             	sub    $0xc,%esp
  8006b9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006bd:	57                   	push   %edi
  8006be:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c1:	50                   	push   %eax
  8006c2:	51                   	push   %ecx
  8006c3:	52                   	push   %edx
  8006c4:	89 da                	mov    %ebx,%edx
  8006c6:	89 f0                	mov    %esi,%eax
  8006c8:	e8 7a fb ff ff       	call   800247 <printnum>
			break;
  8006cd:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d3:	83 c7 01             	add    $0x1,%edi
  8006d6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006da:	83 f8 25             	cmp    $0x25,%eax
  8006dd:	0f 84 64 fc ff ff    	je     800347 <vprintfmt+0x17>
			if (ch == '\0')
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	0f 84 8b 00 00 00    	je     800776 <vprintfmt+0x446>
			putch(ch, putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	53                   	push   %ebx
  8006ef:	50                   	push   %eax
  8006f0:	ff d6                	call   *%esi
  8006f2:	83 c4 10             	add    $0x10,%esp
  8006f5:	eb dc                	jmp    8006d3 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8006f7:	83 f9 01             	cmp    $0x1,%ecx
  8006fa:	7e 15                	jle    800711 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	8b 48 04             	mov    0x4(%eax),%ecx
  800704:	8d 40 08             	lea    0x8(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	b8 10 00 00 00       	mov    $0x10,%eax
  80070f:	eb a5                	jmp    8006b6 <vprintfmt+0x386>
	else if (lflag)
  800711:	85 c9                	test   %ecx,%ecx
  800713:	75 17                	jne    80072c <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 10                	mov    (%eax),%edx
  80071a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071f:	8d 40 04             	lea    0x4(%eax),%eax
  800722:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800725:	b8 10 00 00 00       	mov    $0x10,%eax
  80072a:	eb 8a                	jmp    8006b6 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 10                	mov    (%eax),%edx
  800731:	b9 00 00 00 00       	mov    $0x0,%ecx
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073c:	b8 10 00 00 00       	mov    $0x10,%eax
  800741:	e9 70 ff ff ff       	jmp    8006b6 <vprintfmt+0x386>
			putch(ch, putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	53                   	push   %ebx
  80074a:	6a 25                	push   $0x25
  80074c:	ff d6                	call   *%esi
			break;
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	e9 7a ff ff ff       	jmp    8006d0 <vprintfmt+0x3a0>
			putch('%', putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	53                   	push   %ebx
  80075a:	6a 25                	push   $0x25
  80075c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	89 f8                	mov    %edi,%eax
  800763:	eb 03                	jmp    800768 <vprintfmt+0x438>
  800765:	83 e8 01             	sub    $0x1,%eax
  800768:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80076c:	75 f7                	jne    800765 <vprintfmt+0x435>
  80076e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800771:	e9 5a ff ff ff       	jmp    8006d0 <vprintfmt+0x3a0>
}
  800776:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800779:	5b                   	pop    %ebx
  80077a:	5e                   	pop    %esi
  80077b:	5f                   	pop    %edi
  80077c:	5d                   	pop    %ebp
  80077d:	c3                   	ret    

0080077e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	83 ec 18             	sub    $0x18,%esp
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80078a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80078d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800791:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800794:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80079b:	85 c0                	test   %eax,%eax
  80079d:	74 26                	je     8007c5 <vsnprintf+0x47>
  80079f:	85 d2                	test   %edx,%edx
  8007a1:	7e 22                	jle    8007c5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007a3:	ff 75 14             	pushl  0x14(%ebp)
  8007a6:	ff 75 10             	pushl  0x10(%ebp)
  8007a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007ac:	50                   	push   %eax
  8007ad:	68 f6 02 80 00       	push   $0x8002f6
  8007b2:	e8 79 fb ff ff       	call   800330 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c0:	83 c4 10             	add    $0x10,%esp
}
  8007c3:	c9                   	leave  
  8007c4:	c3                   	ret    
		return -E_INVAL;
  8007c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ca:	eb f7                	jmp    8007c3 <vsnprintf+0x45>

008007cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007d5:	50                   	push   %eax
  8007d6:	ff 75 10             	pushl  0x10(%ebp)
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	ff 75 08             	pushl  0x8(%ebp)
  8007df:	e8 9a ff ff ff       	call   80077e <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f1:	eb 03                	jmp    8007f6 <strlen+0x10>
		n++;
  8007f3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007f6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007fa:	75 f7                	jne    8007f3 <strlen+0xd>
	return n;
}
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800804:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800807:	b8 00 00 00 00       	mov    $0x0,%eax
  80080c:	eb 03                	jmp    800811 <strnlen+0x13>
		n++;
  80080e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800811:	39 d0                	cmp    %edx,%eax
  800813:	74 06                	je     80081b <strnlen+0x1d>
  800815:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800819:	75 f3                	jne    80080e <strnlen+0x10>
	return n;
}
  80081b:	5d                   	pop    %ebp
  80081c:	c3                   	ret    

0080081d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	53                   	push   %ebx
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800827:	89 c2                	mov    %eax,%edx
  800829:	83 c1 01             	add    $0x1,%ecx
  80082c:	83 c2 01             	add    $0x1,%edx
  80082f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800833:	88 5a ff             	mov    %bl,-0x1(%edx)
  800836:	84 db                	test   %bl,%bl
  800838:	75 ef                	jne    800829 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80083a:	5b                   	pop    %ebx
  80083b:	5d                   	pop    %ebp
  80083c:	c3                   	ret    

0080083d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	53                   	push   %ebx
  800841:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800844:	53                   	push   %ebx
  800845:	e8 9c ff ff ff       	call   8007e6 <strlen>
  80084a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	01 d8                	add    %ebx,%eax
  800852:	50                   	push   %eax
  800853:	e8 c5 ff ff ff       	call   80081d <strcpy>
	return dst;
}
  800858:	89 d8                	mov    %ebx,%eax
  80085a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085d:	c9                   	leave  
  80085e:	c3                   	ret    

0080085f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	56                   	push   %esi
  800863:	53                   	push   %ebx
  800864:	8b 75 08             	mov    0x8(%ebp),%esi
  800867:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80086a:	89 f3                	mov    %esi,%ebx
  80086c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80086f:	89 f2                	mov    %esi,%edx
  800871:	eb 0f                	jmp    800882 <strncpy+0x23>
		*dst++ = *src;
  800873:	83 c2 01             	add    $0x1,%edx
  800876:	0f b6 01             	movzbl (%ecx),%eax
  800879:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80087c:	80 39 01             	cmpb   $0x1,(%ecx)
  80087f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800882:	39 da                	cmp    %ebx,%edx
  800884:	75 ed                	jne    800873 <strncpy+0x14>
	}
	return ret;
}
  800886:	89 f0                	mov    %esi,%eax
  800888:	5b                   	pop    %ebx
  800889:	5e                   	pop    %esi
  80088a:	5d                   	pop    %ebp
  80088b:	c3                   	ret    

0080088c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	56                   	push   %esi
  800890:	53                   	push   %ebx
  800891:	8b 75 08             	mov    0x8(%ebp),%esi
  800894:	8b 55 0c             	mov    0xc(%ebp),%edx
  800897:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80089a:	89 f0                	mov    %esi,%eax
  80089c:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008a0:	85 c9                	test   %ecx,%ecx
  8008a2:	75 0b                	jne    8008af <strlcpy+0x23>
  8008a4:	eb 17                	jmp    8008bd <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a6:	83 c2 01             	add    $0x1,%edx
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008af:	39 d8                	cmp    %ebx,%eax
  8008b1:	74 07                	je     8008ba <strlcpy+0x2e>
  8008b3:	0f b6 0a             	movzbl (%edx),%ecx
  8008b6:	84 c9                	test   %cl,%cl
  8008b8:	75 ec                	jne    8008a6 <strlcpy+0x1a>
		*dst = '\0';
  8008ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008bd:	29 f0                	sub    %esi,%eax
}
  8008bf:	5b                   	pop    %ebx
  8008c0:	5e                   	pop    %esi
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008cc:	eb 06                	jmp    8008d4 <strcmp+0x11>
		p++, q++;
  8008ce:	83 c1 01             	add    $0x1,%ecx
  8008d1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008d4:	0f b6 01             	movzbl (%ecx),%eax
  8008d7:	84 c0                	test   %al,%al
  8008d9:	74 04                	je     8008df <strcmp+0x1c>
  8008db:	3a 02                	cmp    (%edx),%al
  8008dd:	74 ef                	je     8008ce <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008df:	0f b6 c0             	movzbl %al,%eax
  8008e2:	0f b6 12             	movzbl (%edx),%edx
  8008e5:	29 d0                	sub    %edx,%eax
}
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	53                   	push   %ebx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f3:	89 c3                	mov    %eax,%ebx
  8008f5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008f8:	eb 06                	jmp    800900 <strncmp+0x17>
		n--, p++, q++;
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800900:	39 d8                	cmp    %ebx,%eax
  800902:	74 16                	je     80091a <strncmp+0x31>
  800904:	0f b6 08             	movzbl (%eax),%ecx
  800907:	84 c9                	test   %cl,%cl
  800909:	74 04                	je     80090f <strncmp+0x26>
  80090b:	3a 0a                	cmp    (%edx),%cl
  80090d:	74 eb                	je     8008fa <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80090f:	0f b6 00             	movzbl (%eax),%eax
  800912:	0f b6 12             	movzbl (%edx),%edx
  800915:	29 d0                	sub    %edx,%eax
}
  800917:	5b                   	pop    %ebx
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    
		return 0;
  80091a:	b8 00 00 00 00       	mov    $0x0,%eax
  80091f:	eb f6                	jmp    800917 <strncmp+0x2e>

00800921 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092b:	0f b6 10             	movzbl (%eax),%edx
  80092e:	84 d2                	test   %dl,%dl
  800930:	74 09                	je     80093b <strchr+0x1a>
		if (*s == c)
  800932:	38 ca                	cmp    %cl,%dl
  800934:	74 0a                	je     800940 <strchr+0x1f>
	for (; *s; s++)
  800936:	83 c0 01             	add    $0x1,%eax
  800939:	eb f0                	jmp    80092b <strchr+0xa>
			return (char *) s;
	return 0;
  80093b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80094c:	eb 03                	jmp    800951 <strfind+0xf>
  80094e:	83 c0 01             	add    $0x1,%eax
  800951:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800954:	38 ca                	cmp    %cl,%dl
  800956:	74 04                	je     80095c <strfind+0x1a>
  800958:	84 d2                	test   %dl,%dl
  80095a:	75 f2                	jne    80094e <strfind+0xc>
			break;
	return (char *) s;
}
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    

0080095e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	57                   	push   %edi
  800962:	56                   	push   %esi
  800963:	53                   	push   %ebx
  800964:	8b 7d 08             	mov    0x8(%ebp),%edi
  800967:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80096a:	85 c9                	test   %ecx,%ecx
  80096c:	74 13                	je     800981 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80096e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800974:	75 05                	jne    80097b <memset+0x1d>
  800976:	f6 c1 03             	test   $0x3,%cl
  800979:	74 0d                	je     800988 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80097b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097e:	fc                   	cld    
  80097f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800981:	89 f8                	mov    %edi,%eax
  800983:	5b                   	pop    %ebx
  800984:	5e                   	pop    %esi
  800985:	5f                   	pop    %edi
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    
		c &= 0xFF;
  800988:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80098c:	89 d3                	mov    %edx,%ebx
  80098e:	c1 e3 08             	shl    $0x8,%ebx
  800991:	89 d0                	mov    %edx,%eax
  800993:	c1 e0 18             	shl    $0x18,%eax
  800996:	89 d6                	mov    %edx,%esi
  800998:	c1 e6 10             	shl    $0x10,%esi
  80099b:	09 f0                	or     %esi,%eax
  80099d:	09 c2                	or     %eax,%edx
  80099f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009a1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	fc                   	cld    
  8009a7:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a9:	eb d6                	jmp    800981 <memset+0x23>

008009ab <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	57                   	push   %edi
  8009af:	56                   	push   %esi
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009b9:	39 c6                	cmp    %eax,%esi
  8009bb:	73 35                	jae    8009f2 <memmove+0x47>
  8009bd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009c0:	39 c2                	cmp    %eax,%edx
  8009c2:	76 2e                	jbe    8009f2 <memmove+0x47>
		s += n;
		d += n;
  8009c4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c7:	89 d6                	mov    %edx,%esi
  8009c9:	09 fe                	or     %edi,%esi
  8009cb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009d1:	74 0c                	je     8009df <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009d3:	83 ef 01             	sub    $0x1,%edi
  8009d6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009d9:	fd                   	std    
  8009da:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009dc:	fc                   	cld    
  8009dd:	eb 21                	jmp    800a00 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009df:	f6 c1 03             	test   $0x3,%cl
  8009e2:	75 ef                	jne    8009d3 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009e4:	83 ef 04             	sub    $0x4,%edi
  8009e7:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009ea:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009ed:	fd                   	std    
  8009ee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f0:	eb ea                	jmp    8009dc <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f2:	89 f2                	mov    %esi,%edx
  8009f4:	09 c2                	or     %eax,%edx
  8009f6:	f6 c2 03             	test   $0x3,%dl
  8009f9:	74 09                	je     800a04 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009fb:	89 c7                	mov    %eax,%edi
  8009fd:	fc                   	cld    
  8009fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a00:	5e                   	pop    %esi
  800a01:	5f                   	pop    %edi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a04:	f6 c1 03             	test   $0x3,%cl
  800a07:	75 f2                	jne    8009fb <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a09:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a0c:	89 c7                	mov    %eax,%edi
  800a0e:	fc                   	cld    
  800a0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a11:	eb ed                	jmp    800a00 <memmove+0x55>

00800a13 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a16:	ff 75 10             	pushl  0x10(%ebp)
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	ff 75 08             	pushl  0x8(%ebp)
  800a1f:	e8 87 ff ff ff       	call   8009ab <memmove>
}
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	56                   	push   %esi
  800a2a:	53                   	push   %ebx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a31:	89 c6                	mov    %eax,%esi
  800a33:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a36:	39 f0                	cmp    %esi,%eax
  800a38:	74 1c                	je     800a56 <memcmp+0x30>
		if (*s1 != *s2)
  800a3a:	0f b6 08             	movzbl (%eax),%ecx
  800a3d:	0f b6 1a             	movzbl (%edx),%ebx
  800a40:	38 d9                	cmp    %bl,%cl
  800a42:	75 08                	jne    800a4c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a44:	83 c0 01             	add    $0x1,%eax
  800a47:	83 c2 01             	add    $0x1,%edx
  800a4a:	eb ea                	jmp    800a36 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a4c:	0f b6 c1             	movzbl %cl,%eax
  800a4f:	0f b6 db             	movzbl %bl,%ebx
  800a52:	29 d8                	sub    %ebx,%eax
  800a54:	eb 05                	jmp    800a5b <memcmp+0x35>
	}

	return 0;
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5b:	5b                   	pop    %ebx
  800a5c:	5e                   	pop    %esi
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a68:	89 c2                	mov    %eax,%edx
  800a6a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a6d:	39 d0                	cmp    %edx,%eax
  800a6f:	73 09                	jae    800a7a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a71:	38 08                	cmp    %cl,(%eax)
  800a73:	74 05                	je     800a7a <memfind+0x1b>
	for (; s < ends; s++)
  800a75:	83 c0 01             	add    $0x1,%eax
  800a78:	eb f3                	jmp    800a6d <memfind+0xe>
			break;
	return (void *) s;
}
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	57                   	push   %edi
  800a80:	56                   	push   %esi
  800a81:	53                   	push   %ebx
  800a82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a88:	eb 03                	jmp    800a8d <strtol+0x11>
		s++;
  800a8a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a8d:	0f b6 01             	movzbl (%ecx),%eax
  800a90:	3c 20                	cmp    $0x20,%al
  800a92:	74 f6                	je     800a8a <strtol+0xe>
  800a94:	3c 09                	cmp    $0x9,%al
  800a96:	74 f2                	je     800a8a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a98:	3c 2b                	cmp    $0x2b,%al
  800a9a:	74 2e                	je     800aca <strtol+0x4e>
	int neg = 0;
  800a9c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aa1:	3c 2d                	cmp    $0x2d,%al
  800aa3:	74 2f                	je     800ad4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aa5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aab:	75 05                	jne    800ab2 <strtol+0x36>
  800aad:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab0:	74 2c                	je     800ade <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ab2:	85 db                	test   %ebx,%ebx
  800ab4:	75 0a                	jne    800ac0 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ab6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800abb:	80 39 30             	cmpb   $0x30,(%ecx)
  800abe:	74 28                	je     800ae8 <strtol+0x6c>
		base = 10;
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ac8:	eb 50                	jmp    800b1a <strtol+0x9e>
		s++;
  800aca:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800acd:	bf 00 00 00 00       	mov    $0x0,%edi
  800ad2:	eb d1                	jmp    800aa5 <strtol+0x29>
		s++, neg = 1;
  800ad4:	83 c1 01             	add    $0x1,%ecx
  800ad7:	bf 01 00 00 00       	mov    $0x1,%edi
  800adc:	eb c7                	jmp    800aa5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ade:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ae2:	74 0e                	je     800af2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ae4:	85 db                	test   %ebx,%ebx
  800ae6:	75 d8                	jne    800ac0 <strtol+0x44>
		s++, base = 8;
  800ae8:	83 c1 01             	add    $0x1,%ecx
  800aeb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800af0:	eb ce                	jmp    800ac0 <strtol+0x44>
		s += 2, base = 16;
  800af2:	83 c1 02             	add    $0x2,%ecx
  800af5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800afa:	eb c4                	jmp    800ac0 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800afc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aff:	89 f3                	mov    %esi,%ebx
  800b01:	80 fb 19             	cmp    $0x19,%bl
  800b04:	77 29                	ja     800b2f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b06:	0f be d2             	movsbl %dl,%edx
  800b09:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b0c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b0f:	7d 30                	jge    800b41 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b11:	83 c1 01             	add    $0x1,%ecx
  800b14:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b18:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b1a:	0f b6 11             	movzbl (%ecx),%edx
  800b1d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b20:	89 f3                	mov    %esi,%ebx
  800b22:	80 fb 09             	cmp    $0x9,%bl
  800b25:	77 d5                	ja     800afc <strtol+0x80>
			dig = *s - '0';
  800b27:	0f be d2             	movsbl %dl,%edx
  800b2a:	83 ea 30             	sub    $0x30,%edx
  800b2d:	eb dd                	jmp    800b0c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b2f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b32:	89 f3                	mov    %esi,%ebx
  800b34:	80 fb 19             	cmp    $0x19,%bl
  800b37:	77 08                	ja     800b41 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b39:	0f be d2             	movsbl %dl,%edx
  800b3c:	83 ea 37             	sub    $0x37,%edx
  800b3f:	eb cb                	jmp    800b0c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b45:	74 05                	je     800b4c <strtol+0xd0>
		*endptr = (char *) s;
  800b47:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b4a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b4c:	89 c2                	mov    %eax,%edx
  800b4e:	f7 da                	neg    %edx
  800b50:	85 ff                	test   %edi,%edi
  800b52:	0f 45 c2             	cmovne %edx,%eax
}
  800b55:	5b                   	pop    %ebx
  800b56:	5e                   	pop    %esi
  800b57:	5f                   	pop    %edi
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	57                   	push   %edi
  800b5e:	56                   	push   %esi
  800b5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b60:	b8 00 00 00 00       	mov    $0x0,%eax
  800b65:	8b 55 08             	mov    0x8(%ebp),%edx
  800b68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6b:	89 c3                	mov    %eax,%ebx
  800b6d:	89 c7                	mov    %eax,%edi
  800b6f:	89 c6                	mov    %eax,%esi
  800b71:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b73:	5b                   	pop    %ebx
  800b74:	5e                   	pop    %esi
  800b75:	5f                   	pop    %edi
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	57                   	push   %edi
  800b7c:	56                   	push   %esi
  800b7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b83:	b8 01 00 00 00       	mov    $0x1,%eax
  800b88:	89 d1                	mov    %edx,%ecx
  800b8a:	89 d3                	mov    %edx,%ebx
  800b8c:	89 d7                	mov    %edx,%edi
  800b8e:	89 d6                	mov    %edx,%esi
  800b90:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b92:	5b                   	pop    %ebx
  800b93:	5e                   	pop    %esi
  800b94:	5f                   	pop    %edi
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	57                   	push   %edi
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
  800b9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bad:	89 cb                	mov    %ecx,%ebx
  800baf:	89 cf                	mov    %ecx,%edi
  800bb1:	89 ce                	mov    %ecx,%esi
  800bb3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bb5:	85 c0                	test   %eax,%eax
  800bb7:	7f 08                	jg     800bc1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bbc:	5b                   	pop    %ebx
  800bbd:	5e                   	pop    %esi
  800bbe:	5f                   	pop    %edi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	50                   	push   %eax
  800bc5:	6a 03                	push   $0x3
  800bc7:	68 df 23 80 00       	push   $0x8023df
  800bcc:	6a 23                	push   $0x23
  800bce:	68 fc 23 80 00       	push   $0x8023fc
  800bd3:	e8 80 f5 ff ff       	call   800158 <_panic>

00800bd8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bde:	ba 00 00 00 00       	mov    $0x0,%edx
  800be3:	b8 02 00 00 00       	mov    $0x2,%eax
  800be8:	89 d1                	mov    %edx,%ecx
  800bea:	89 d3                	mov    %edx,%ebx
  800bec:	89 d7                	mov    %edx,%edi
  800bee:	89 d6                	mov    %edx,%esi
  800bf0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <sys_yield>:

void
sys_yield(void)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800c02:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c07:	89 d1                	mov    %edx,%ecx
  800c09:	89 d3                	mov    %edx,%ebx
  800c0b:	89 d7                	mov    %edx,%edi
  800c0d:	89 d6                	mov    %edx,%esi
  800c0f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c11:	5b                   	pop    %ebx
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
  800c1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c1f:	be 00 00 00 00       	mov    $0x0,%esi
  800c24:	8b 55 08             	mov    0x8(%ebp),%edx
  800c27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c32:	89 f7                	mov    %esi,%edi
  800c34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c36:	85 c0                	test   %eax,%eax
  800c38:	7f 08                	jg     800c42 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c3d:	5b                   	pop    %ebx
  800c3e:	5e                   	pop    %esi
  800c3f:	5f                   	pop    %edi
  800c40:	5d                   	pop    %ebp
  800c41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c42:	83 ec 0c             	sub    $0xc,%esp
  800c45:	50                   	push   %eax
  800c46:	6a 04                	push   $0x4
  800c48:	68 df 23 80 00       	push   $0x8023df
  800c4d:	6a 23                	push   $0x23
  800c4f:	68 fc 23 80 00       	push   $0x8023fc
  800c54:	e8 ff f4 ff ff       	call   800158 <_panic>

00800c59 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	57                   	push   %edi
  800c5d:	56                   	push   %esi
  800c5e:	53                   	push   %ebx
  800c5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c62:	8b 55 08             	mov    0x8(%ebp),%edx
  800c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c68:	b8 05 00 00 00       	mov    $0x5,%eax
  800c6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c70:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c73:	8b 75 18             	mov    0x18(%ebp),%esi
  800c76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c78:	85 c0                	test   %eax,%eax
  800c7a:	7f 08                	jg     800c84 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c84:	83 ec 0c             	sub    $0xc,%esp
  800c87:	50                   	push   %eax
  800c88:	6a 05                	push   $0x5
  800c8a:	68 df 23 80 00       	push   $0x8023df
  800c8f:	6a 23                	push   $0x23
  800c91:	68 fc 23 80 00       	push   $0x8023fc
  800c96:	e8 bd f4 ff ff       	call   800158 <_panic>

00800c9b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	b8 06 00 00 00       	mov    $0x6,%eax
  800cb4:	89 df                	mov    %ebx,%edi
  800cb6:	89 de                	mov    %ebx,%esi
  800cb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	7f 08                	jg     800cc6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	50                   	push   %eax
  800cca:	6a 06                	push   $0x6
  800ccc:	68 df 23 80 00       	push   $0x8023df
  800cd1:	6a 23                	push   $0x23
  800cd3:	68 fc 23 80 00       	push   $0x8023fc
  800cd8:	e8 7b f4 ff ff       	call   800158 <_panic>

00800cdd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	57                   	push   %edi
  800ce1:	56                   	push   %esi
  800ce2:	53                   	push   %ebx
  800ce3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf1:	b8 08 00 00 00       	mov    $0x8,%eax
  800cf6:	89 df                	mov    %ebx,%edi
  800cf8:	89 de                	mov    %ebx,%esi
  800cfa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cfc:	85 c0                	test   %eax,%eax
  800cfe:	7f 08                	jg     800d08 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5f                   	pop    %edi
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d08:	83 ec 0c             	sub    $0xc,%esp
  800d0b:	50                   	push   %eax
  800d0c:	6a 08                	push   $0x8
  800d0e:	68 df 23 80 00       	push   $0x8023df
  800d13:	6a 23                	push   $0x23
  800d15:	68 fc 23 80 00       	push   $0x8023fc
  800d1a:	e8 39 f4 ff ff       	call   800158 <_panic>

00800d1f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	57                   	push   %edi
  800d23:	56                   	push   %esi
  800d24:	53                   	push   %ebx
  800d25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d33:	b8 09 00 00 00       	mov    $0x9,%eax
  800d38:	89 df                	mov    %ebx,%edi
  800d3a:	89 de                	mov    %ebx,%esi
  800d3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3e:	85 c0                	test   %eax,%eax
  800d40:	7f 08                	jg     800d4a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4a:	83 ec 0c             	sub    $0xc,%esp
  800d4d:	50                   	push   %eax
  800d4e:	6a 09                	push   $0x9
  800d50:	68 df 23 80 00       	push   $0x8023df
  800d55:	6a 23                	push   $0x23
  800d57:	68 fc 23 80 00       	push   $0x8023fc
  800d5c:	e8 f7 f3 ff ff       	call   800158 <_panic>

00800d61 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	57                   	push   %edi
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
  800d67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d75:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d7a:	89 df                	mov    %ebx,%edi
  800d7c:	89 de                	mov    %ebx,%esi
  800d7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d80:	85 c0                	test   %eax,%eax
  800d82:	7f 08                	jg     800d8c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8c:	83 ec 0c             	sub    $0xc,%esp
  800d8f:	50                   	push   %eax
  800d90:	6a 0a                	push   $0xa
  800d92:	68 df 23 80 00       	push   $0x8023df
  800d97:	6a 23                	push   $0x23
  800d99:	68 fc 23 80 00       	push   $0x8023fc
  800d9e:	e8 b5 f3 ff ff       	call   800158 <_panic>

00800da3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	57                   	push   %edi
  800da7:	56                   	push   %esi
  800da8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800db4:	be 00 00 00 00       	mov    $0x0,%esi
  800db9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dbc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dbf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    

00800dc6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
  800dcc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ddc:	89 cb                	mov    %ecx,%ebx
  800dde:	89 cf                	mov    %ecx,%edi
  800de0:	89 ce                	mov    %ecx,%esi
  800de2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de4:	85 c0                	test   %eax,%eax
  800de6:	7f 08                	jg     800df0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df0:	83 ec 0c             	sub    $0xc,%esp
  800df3:	50                   	push   %eax
  800df4:	6a 0d                	push   $0xd
  800df6:	68 df 23 80 00       	push   $0x8023df
  800dfb:	6a 23                	push   $0x23
  800dfd:	68 fc 23 80 00       	push   $0x8023fc
  800e02:	e8 51 f3 ff ff       	call   800158 <_panic>

00800e07 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800e0d:	68 0a 24 80 00       	push   $0x80240a
  800e12:	6a 25                	push   $0x25
  800e14:	68 22 24 80 00       	push   $0x802422
  800e19:	e8 3a f3 ff ff       	call   800158 <_panic>

00800e1e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  800e27:	68 07 0e 80 00       	push   $0x800e07
  800e2c:	e8 31 0f 00 00       	call   801d62 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800e31:	b8 07 00 00 00       	mov    $0x7,%eax
  800e36:	cd 30                	int    $0x30
  800e38:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  800e3e:	83 c4 10             	add    $0x10,%esp
  800e41:	85 c0                	test   %eax,%eax
  800e43:	78 27                	js     800e6c <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800e45:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  800e4a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e4e:	75 65                	jne    800eb5 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800e50:	e8 83 fd ff ff       	call   800bd8 <sys_getenvid>
  800e55:	25 ff 03 00 00       	and    $0x3ff,%eax
  800e5a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800e5d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e62:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800e67:	e9 11 01 00 00       	jmp    800f7d <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  800e6c:	50                   	push   %eax
  800e6d:	68 8c 20 80 00       	push   $0x80208c
  800e72:	6a 6f                	push   $0x6f
  800e74:	68 22 24 80 00       	push   $0x802422
  800e79:	e8 da f2 ff ff       	call   800158 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  800e7e:	e8 55 fd ff ff       	call   800bd8 <sys_getenvid>
  800e83:	83 ec 0c             	sub    $0xc,%esp
  800e86:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800e8c:	56                   	push   %esi
  800e8d:	57                   	push   %edi
  800e8e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e91:	57                   	push   %edi
  800e92:	50                   	push   %eax
  800e93:	e8 c1 fd ff ff       	call   800c59 <sys_page_map>
  800e98:	83 c4 20             	add    $0x20,%esp
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	0f 88 84 00 00 00    	js     800f27 <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800ea3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800ea9:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800eaf:	0f 84 84 00 00 00    	je     800f39 <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  800eb5:	89 d8                	mov    %ebx,%eax
  800eb7:	c1 e8 16             	shr    $0x16,%eax
  800eba:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ec1:	a8 01                	test   $0x1,%al
  800ec3:	74 de                	je     800ea3 <fork+0x85>
  800ec5:	89 d8                	mov    %ebx,%eax
  800ec7:	c1 e8 0c             	shr    $0xc,%eax
  800eca:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ed1:	f6 c2 01             	test   $0x1,%dl
  800ed4:	74 cd                	je     800ea3 <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  800ed6:	89 c7                	mov    %eax,%edi
  800ed8:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  800edb:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  800ee2:	f7 c6 00 04 00 00    	test   $0x400,%esi
  800ee8:	75 94                	jne    800e7e <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  800eea:	f7 c6 02 08 00 00    	test   $0x802,%esi
  800ef0:	0f 85 d1 00 00 00    	jne    800fc7 <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800ef6:	a1 04 40 80 00       	mov    0x804004,%eax
  800efb:	8b 40 48             	mov    0x48(%eax),%eax
  800efe:	83 ec 0c             	sub    $0xc,%esp
  800f01:	6a 05                	push   $0x5
  800f03:	57                   	push   %edi
  800f04:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f07:	57                   	push   %edi
  800f08:	50                   	push   %eax
  800f09:	e8 4b fd ff ff       	call   800c59 <sys_page_map>
  800f0e:	83 c4 20             	add    $0x20,%esp
  800f11:	85 c0                	test   %eax,%eax
  800f13:	79 8e                	jns    800ea3 <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  800f15:	50                   	push   %eax
  800f16:	68 7c 24 80 00       	push   $0x80247c
  800f1b:	6a 4a                	push   $0x4a
  800f1d:	68 22 24 80 00       	push   $0x802422
  800f22:	e8 31 f2 ff ff       	call   800158 <_panic>
                        panic("duppage: page mapping failed %e", r);
  800f27:	50                   	push   %eax
  800f28:	68 5c 24 80 00       	push   $0x80245c
  800f2d:	6a 41                	push   $0x41
  800f2f:	68 22 24 80 00       	push   $0x802422
  800f34:	e8 1f f2 ff ff       	call   800158 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  800f39:	83 ec 04             	sub    $0x4,%esp
  800f3c:	6a 07                	push   $0x7
  800f3e:	68 00 f0 bf ee       	push   $0xeebff000
  800f43:	ff 75 e0             	pushl  -0x20(%ebp)
  800f46:	e8 cb fc ff ff       	call   800c16 <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  800f4b:	83 c4 10             	add    $0x10,%esp
  800f4e:	85 c0                	test   %eax,%eax
  800f50:	78 36                	js     800f88 <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	68 d6 1d 80 00       	push   $0x801dd6
  800f5a:	ff 75 e0             	pushl  -0x20(%ebp)
  800f5d:	e8 ff fd ff ff       	call   800d61 <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800f62:	83 c4 10             	add    $0x10,%esp
  800f65:	85 c0                	test   %eax,%eax
  800f67:	78 34                	js     800f9d <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  800f69:	83 ec 08             	sub    $0x8,%esp
  800f6c:	6a 02                	push   $0x2
  800f6e:	ff 75 e0             	pushl  -0x20(%ebp)
  800f71:	e8 67 fd ff ff       	call   800cdd <sys_env_set_status>
  800f76:	83 c4 10             	add    $0x10,%esp
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	78 35                	js     800fb2 <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  800f7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f83:	5b                   	pop    %ebx
  800f84:	5e                   	pop    %esi
  800f85:	5f                   	pop    %edi
  800f86:	5d                   	pop    %ebp
  800f87:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  800f88:	50                   	push   %eax
  800f89:	68 8c 20 80 00       	push   $0x80208c
  800f8e:	68 82 00 00 00       	push   $0x82
  800f93:	68 22 24 80 00       	push   $0x802422
  800f98:	e8 bb f1 ff ff       	call   800158 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800f9d:	50                   	push   %eax
  800f9e:	68 a0 24 80 00       	push   $0x8024a0
  800fa3:	68 87 00 00 00       	push   $0x87
  800fa8:	68 22 24 80 00       	push   $0x802422
  800fad:	e8 a6 f1 ff ff       	call   800158 <_panic>
        	panic("sys_env_set_status: %e", r);
  800fb2:	50                   	push   %eax
  800fb3:	68 2d 24 80 00       	push   $0x80242d
  800fb8:	68 8b 00 00 00       	push   $0x8b
  800fbd:	68 22 24 80 00       	push   $0x802422
  800fc2:	e8 91 f1 ff ff       	call   800158 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800fc7:	a1 04 40 80 00       	mov    0x804004,%eax
  800fcc:	8b 40 48             	mov    0x48(%eax),%eax
  800fcf:	83 ec 0c             	sub    $0xc,%esp
  800fd2:	68 05 08 00 00       	push   $0x805
  800fd7:	57                   	push   %edi
  800fd8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fdb:	57                   	push   %edi
  800fdc:	50                   	push   %eax
  800fdd:	e8 77 fc ff ff       	call   800c59 <sys_page_map>
  800fe2:	83 c4 20             	add    $0x20,%esp
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	0f 88 28 ff ff ff    	js     800f15 <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  800fed:	a1 04 40 80 00       	mov    0x804004,%eax
  800ff2:	8b 50 48             	mov    0x48(%eax),%edx
  800ff5:	8b 40 48             	mov    0x48(%eax),%eax
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	68 05 08 00 00       	push   $0x805
  801000:	57                   	push   %edi
  801001:	52                   	push   %edx
  801002:	57                   	push   %edi
  801003:	50                   	push   %eax
  801004:	e8 50 fc ff ff       	call   800c59 <sys_page_map>
  801009:	83 c4 20             	add    $0x20,%esp
  80100c:	85 c0                	test   %eax,%eax
  80100e:	0f 89 8f fe ff ff    	jns    800ea3 <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  801014:	50                   	push   %eax
  801015:	68 7c 24 80 00       	push   $0x80247c
  80101a:	6a 4f                	push   $0x4f
  80101c:	68 22 24 80 00       	push   $0x802422
  801021:	e8 32 f1 ff ff       	call   800158 <_panic>

00801026 <sfork>:

// Challenge!
int
sfork(void)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80102c:	68 44 24 80 00       	push   $0x802444
  801031:	68 94 00 00 00       	push   $0x94
  801036:	68 22 24 80 00       	push   $0x802422
  80103b:	e8 18 f1 ff ff       	call   800158 <_panic>

00801040 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801046:	68 c4 24 80 00       	push   $0x8024c4
  80104b:	6a 1a                	push   $0x1a
  80104d:	68 dd 24 80 00       	push   $0x8024dd
  801052:	e8 01 f1 ff ff       	call   800158 <_panic>

00801057 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  80105d:	68 e7 24 80 00       	push   $0x8024e7
  801062:	6a 2a                	push   $0x2a
  801064:	68 dd 24 80 00       	push   $0x8024dd
  801069:	e8 ea f0 ff ff       	call   800158 <_panic>

0080106e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801074:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801079:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80107c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801082:	8b 52 50             	mov    0x50(%edx),%edx
  801085:	39 ca                	cmp    %ecx,%edx
  801087:	74 11                	je     80109a <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801089:	83 c0 01             	add    $0x1,%eax
  80108c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801091:	75 e6                	jne    801079 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801093:	b8 00 00 00 00       	mov    $0x0,%eax
  801098:	eb 0b                	jmp    8010a5 <ipc_find_env+0x37>
			return envs[i].env_id;
  80109a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80109d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010a2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    

008010a7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	05 00 00 00 30       	add    $0x30000000,%eax
  8010b2:	c1 e8 0c             	shr    $0xc,%eax
}
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    

008010b7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010b7:	55                   	push   %ebp
  8010b8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010c7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010cc:	5d                   	pop    %ebp
  8010cd:	c3                   	ret    

008010ce <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010d9:	89 c2                	mov    %eax,%edx
  8010db:	c1 ea 16             	shr    $0x16,%edx
  8010de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010e5:	f6 c2 01             	test   $0x1,%dl
  8010e8:	74 2a                	je     801114 <fd_alloc+0x46>
  8010ea:	89 c2                	mov    %eax,%edx
  8010ec:	c1 ea 0c             	shr    $0xc,%edx
  8010ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f6:	f6 c2 01             	test   $0x1,%dl
  8010f9:	74 19                	je     801114 <fd_alloc+0x46>
  8010fb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801100:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801105:	75 d2                	jne    8010d9 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801107:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80110d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801112:	eb 07                	jmp    80111b <fd_alloc+0x4d>
			*fd_store = fd;
  801114:	89 01                	mov    %eax,(%ecx)
			return 0;
  801116:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    

0080111d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801123:	83 f8 1f             	cmp    $0x1f,%eax
  801126:	77 36                	ja     80115e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801128:	c1 e0 0c             	shl    $0xc,%eax
  80112b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801130:	89 c2                	mov    %eax,%edx
  801132:	c1 ea 16             	shr    $0x16,%edx
  801135:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80113c:	f6 c2 01             	test   $0x1,%dl
  80113f:	74 24                	je     801165 <fd_lookup+0x48>
  801141:	89 c2                	mov    %eax,%edx
  801143:	c1 ea 0c             	shr    $0xc,%edx
  801146:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80114d:	f6 c2 01             	test   $0x1,%dl
  801150:	74 1a                	je     80116c <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801152:	8b 55 0c             	mov    0xc(%ebp),%edx
  801155:	89 02                	mov    %eax,(%edx)
	return 0;
  801157:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    
		return -E_INVAL;
  80115e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801163:	eb f7                	jmp    80115c <fd_lookup+0x3f>
		return -E_INVAL;
  801165:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116a:	eb f0                	jmp    80115c <fd_lookup+0x3f>
  80116c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801171:	eb e9                	jmp    80115c <fd_lookup+0x3f>

00801173 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80117c:	ba 80 25 80 00       	mov    $0x802580,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801181:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801186:	39 08                	cmp    %ecx,(%eax)
  801188:	74 33                	je     8011bd <dev_lookup+0x4a>
  80118a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80118d:	8b 02                	mov    (%edx),%eax
  80118f:	85 c0                	test   %eax,%eax
  801191:	75 f3                	jne    801186 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801193:	a1 04 40 80 00       	mov    0x804004,%eax
  801198:	8b 40 48             	mov    0x48(%eax),%eax
  80119b:	83 ec 04             	sub    $0x4,%esp
  80119e:	51                   	push   %ecx
  80119f:	50                   	push   %eax
  8011a0:	68 00 25 80 00       	push   $0x802500
  8011a5:	e8 89 f0 ff ff       	call   800233 <cprintf>
	*dev = 0;
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    
			*dev = devtab[i];
  8011bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c7:	eb f2                	jmp    8011bb <dev_lookup+0x48>

008011c9 <fd_close>:
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	57                   	push   %edi
  8011cd:	56                   	push   %esi
  8011ce:	53                   	push   %ebx
  8011cf:	83 ec 1c             	sub    $0x1c,%esp
  8011d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011db:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011dc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011e2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e5:	50                   	push   %eax
  8011e6:	e8 32 ff ff ff       	call   80111d <fd_lookup>
  8011eb:	89 c3                	mov    %eax,%ebx
  8011ed:	83 c4 08             	add    $0x8,%esp
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	78 05                	js     8011f9 <fd_close+0x30>
	    || fd != fd2)
  8011f4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011f7:	74 16                	je     80120f <fd_close+0x46>
		return (must_exist ? r : 0);
  8011f9:	89 f8                	mov    %edi,%eax
  8011fb:	84 c0                	test   %al,%al
  8011fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801202:	0f 44 d8             	cmove  %eax,%ebx
}
  801205:	89 d8                	mov    %ebx,%eax
  801207:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120a:	5b                   	pop    %ebx
  80120b:	5e                   	pop    %esi
  80120c:	5f                   	pop    %edi
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80120f:	83 ec 08             	sub    $0x8,%esp
  801212:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801215:	50                   	push   %eax
  801216:	ff 36                	pushl  (%esi)
  801218:	e8 56 ff ff ff       	call   801173 <dev_lookup>
  80121d:	89 c3                	mov    %eax,%ebx
  80121f:	83 c4 10             	add    $0x10,%esp
  801222:	85 c0                	test   %eax,%eax
  801224:	78 15                	js     80123b <fd_close+0x72>
		if (dev->dev_close)
  801226:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801229:	8b 40 10             	mov    0x10(%eax),%eax
  80122c:	85 c0                	test   %eax,%eax
  80122e:	74 1b                	je     80124b <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801230:	83 ec 0c             	sub    $0xc,%esp
  801233:	56                   	push   %esi
  801234:	ff d0                	call   *%eax
  801236:	89 c3                	mov    %eax,%ebx
  801238:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80123b:	83 ec 08             	sub    $0x8,%esp
  80123e:	56                   	push   %esi
  80123f:	6a 00                	push   $0x0
  801241:	e8 55 fa ff ff       	call   800c9b <sys_page_unmap>
	return r;
  801246:	83 c4 10             	add    $0x10,%esp
  801249:	eb ba                	jmp    801205 <fd_close+0x3c>
			r = 0;
  80124b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801250:	eb e9                	jmp    80123b <fd_close+0x72>

00801252 <close>:

int
close(int fdnum)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801258:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80125b:	50                   	push   %eax
  80125c:	ff 75 08             	pushl  0x8(%ebp)
  80125f:	e8 b9 fe ff ff       	call   80111d <fd_lookup>
  801264:	83 c4 08             	add    $0x8,%esp
  801267:	85 c0                	test   %eax,%eax
  801269:	78 10                	js     80127b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80126b:	83 ec 08             	sub    $0x8,%esp
  80126e:	6a 01                	push   $0x1
  801270:	ff 75 f4             	pushl  -0xc(%ebp)
  801273:	e8 51 ff ff ff       	call   8011c9 <fd_close>
  801278:	83 c4 10             	add    $0x10,%esp
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <close_all>:

void
close_all(void)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	53                   	push   %ebx
  801281:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801284:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801289:	83 ec 0c             	sub    $0xc,%esp
  80128c:	53                   	push   %ebx
  80128d:	e8 c0 ff ff ff       	call   801252 <close>
	for (i = 0; i < MAXFD; i++)
  801292:	83 c3 01             	add    $0x1,%ebx
  801295:	83 c4 10             	add    $0x10,%esp
  801298:	83 fb 20             	cmp    $0x20,%ebx
  80129b:	75 ec                	jne    801289 <close_all+0xc>
}
  80129d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	57                   	push   %edi
  8012a6:	56                   	push   %esi
  8012a7:	53                   	push   %ebx
  8012a8:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012ae:	50                   	push   %eax
  8012af:	ff 75 08             	pushl  0x8(%ebp)
  8012b2:	e8 66 fe ff ff       	call   80111d <fd_lookup>
  8012b7:	89 c3                	mov    %eax,%ebx
  8012b9:	83 c4 08             	add    $0x8,%esp
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	0f 88 81 00 00 00    	js     801345 <dup+0xa3>
		return r;
	close(newfdnum);
  8012c4:	83 ec 0c             	sub    $0xc,%esp
  8012c7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ca:	e8 83 ff ff ff       	call   801252 <close>

	newfd = INDEX2FD(newfdnum);
  8012cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012d2:	c1 e6 0c             	shl    $0xc,%esi
  8012d5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012db:	83 c4 04             	add    $0x4,%esp
  8012de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012e1:	e8 d1 fd ff ff       	call   8010b7 <fd2data>
  8012e6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012e8:	89 34 24             	mov    %esi,(%esp)
  8012eb:	e8 c7 fd ff ff       	call   8010b7 <fd2data>
  8012f0:	83 c4 10             	add    $0x10,%esp
  8012f3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012f5:	89 d8                	mov    %ebx,%eax
  8012f7:	c1 e8 16             	shr    $0x16,%eax
  8012fa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801301:	a8 01                	test   $0x1,%al
  801303:	74 11                	je     801316 <dup+0x74>
  801305:	89 d8                	mov    %ebx,%eax
  801307:	c1 e8 0c             	shr    $0xc,%eax
  80130a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801311:	f6 c2 01             	test   $0x1,%dl
  801314:	75 39                	jne    80134f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801316:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801319:	89 d0                	mov    %edx,%eax
  80131b:	c1 e8 0c             	shr    $0xc,%eax
  80131e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801325:	83 ec 0c             	sub    $0xc,%esp
  801328:	25 07 0e 00 00       	and    $0xe07,%eax
  80132d:	50                   	push   %eax
  80132e:	56                   	push   %esi
  80132f:	6a 00                	push   $0x0
  801331:	52                   	push   %edx
  801332:	6a 00                	push   $0x0
  801334:	e8 20 f9 ff ff       	call   800c59 <sys_page_map>
  801339:	89 c3                	mov    %eax,%ebx
  80133b:	83 c4 20             	add    $0x20,%esp
  80133e:	85 c0                	test   %eax,%eax
  801340:	78 31                	js     801373 <dup+0xd1>
		goto err;

	return newfdnum;
  801342:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801345:	89 d8                	mov    %ebx,%eax
  801347:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134a:	5b                   	pop    %ebx
  80134b:	5e                   	pop    %esi
  80134c:	5f                   	pop    %edi
  80134d:	5d                   	pop    %ebp
  80134e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80134f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801356:	83 ec 0c             	sub    $0xc,%esp
  801359:	25 07 0e 00 00       	and    $0xe07,%eax
  80135e:	50                   	push   %eax
  80135f:	57                   	push   %edi
  801360:	6a 00                	push   $0x0
  801362:	53                   	push   %ebx
  801363:	6a 00                	push   $0x0
  801365:	e8 ef f8 ff ff       	call   800c59 <sys_page_map>
  80136a:	89 c3                	mov    %eax,%ebx
  80136c:	83 c4 20             	add    $0x20,%esp
  80136f:	85 c0                	test   %eax,%eax
  801371:	79 a3                	jns    801316 <dup+0x74>
	sys_page_unmap(0, newfd);
  801373:	83 ec 08             	sub    $0x8,%esp
  801376:	56                   	push   %esi
  801377:	6a 00                	push   $0x0
  801379:	e8 1d f9 ff ff       	call   800c9b <sys_page_unmap>
	sys_page_unmap(0, nva);
  80137e:	83 c4 08             	add    $0x8,%esp
  801381:	57                   	push   %edi
  801382:	6a 00                	push   $0x0
  801384:	e8 12 f9 ff ff       	call   800c9b <sys_page_unmap>
	return r;
  801389:	83 c4 10             	add    $0x10,%esp
  80138c:	eb b7                	jmp    801345 <dup+0xa3>

0080138e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	53                   	push   %ebx
  801392:	83 ec 14             	sub    $0x14,%esp
  801395:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801398:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139b:	50                   	push   %eax
  80139c:	53                   	push   %ebx
  80139d:	e8 7b fd ff ff       	call   80111d <fd_lookup>
  8013a2:	83 c4 08             	add    $0x8,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	78 3f                	js     8013e8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a9:	83 ec 08             	sub    $0x8,%esp
  8013ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013af:	50                   	push   %eax
  8013b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b3:	ff 30                	pushl  (%eax)
  8013b5:	e8 b9 fd ff ff       	call   801173 <dev_lookup>
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 27                	js     8013e8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013c4:	8b 42 08             	mov    0x8(%edx),%eax
  8013c7:	83 e0 03             	and    $0x3,%eax
  8013ca:	83 f8 01             	cmp    $0x1,%eax
  8013cd:	74 1e                	je     8013ed <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d2:	8b 40 08             	mov    0x8(%eax),%eax
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	74 35                	je     80140e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013d9:	83 ec 04             	sub    $0x4,%esp
  8013dc:	ff 75 10             	pushl  0x10(%ebp)
  8013df:	ff 75 0c             	pushl  0xc(%ebp)
  8013e2:	52                   	push   %edx
  8013e3:	ff d0                	call   *%eax
  8013e5:	83 c4 10             	add    $0x10,%esp
}
  8013e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ed:	a1 04 40 80 00       	mov    0x804004,%eax
  8013f2:	8b 40 48             	mov    0x48(%eax),%eax
  8013f5:	83 ec 04             	sub    $0x4,%esp
  8013f8:	53                   	push   %ebx
  8013f9:	50                   	push   %eax
  8013fa:	68 44 25 80 00       	push   $0x802544
  8013ff:	e8 2f ee ff ff       	call   800233 <cprintf>
		return -E_INVAL;
  801404:	83 c4 10             	add    $0x10,%esp
  801407:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140c:	eb da                	jmp    8013e8 <read+0x5a>
		return -E_NOT_SUPP;
  80140e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801413:	eb d3                	jmp    8013e8 <read+0x5a>

00801415 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	57                   	push   %edi
  801419:	56                   	push   %esi
  80141a:	53                   	push   %ebx
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801421:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801424:	bb 00 00 00 00       	mov    $0x0,%ebx
  801429:	39 f3                	cmp    %esi,%ebx
  80142b:	73 25                	jae    801452 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80142d:	83 ec 04             	sub    $0x4,%esp
  801430:	89 f0                	mov    %esi,%eax
  801432:	29 d8                	sub    %ebx,%eax
  801434:	50                   	push   %eax
  801435:	89 d8                	mov    %ebx,%eax
  801437:	03 45 0c             	add    0xc(%ebp),%eax
  80143a:	50                   	push   %eax
  80143b:	57                   	push   %edi
  80143c:	e8 4d ff ff ff       	call   80138e <read>
		if (m < 0)
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 08                	js     801450 <readn+0x3b>
			return m;
		if (m == 0)
  801448:	85 c0                	test   %eax,%eax
  80144a:	74 06                	je     801452 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80144c:	01 c3                	add    %eax,%ebx
  80144e:	eb d9                	jmp    801429 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801450:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801452:	89 d8                	mov    %ebx,%eax
  801454:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801457:	5b                   	pop    %ebx
  801458:	5e                   	pop    %esi
  801459:	5f                   	pop    %edi
  80145a:	5d                   	pop    %ebp
  80145b:	c3                   	ret    

0080145c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	53                   	push   %ebx
  801460:	83 ec 14             	sub    $0x14,%esp
  801463:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801466:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801469:	50                   	push   %eax
  80146a:	53                   	push   %ebx
  80146b:	e8 ad fc ff ff       	call   80111d <fd_lookup>
  801470:	83 c4 08             	add    $0x8,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	78 3a                	js     8014b1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801477:	83 ec 08             	sub    $0x8,%esp
  80147a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147d:	50                   	push   %eax
  80147e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801481:	ff 30                	pushl  (%eax)
  801483:	e8 eb fc ff ff       	call   801173 <dev_lookup>
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	85 c0                	test   %eax,%eax
  80148d:	78 22                	js     8014b1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80148f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801492:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801496:	74 1e                	je     8014b6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801498:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149b:	8b 52 0c             	mov    0xc(%edx),%edx
  80149e:	85 d2                	test   %edx,%edx
  8014a0:	74 35                	je     8014d7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	ff 75 10             	pushl  0x10(%ebp)
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	50                   	push   %eax
  8014ac:	ff d2                	call   *%edx
  8014ae:	83 c4 10             	add    $0x10,%esp
}
  8014b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014b6:	a1 04 40 80 00       	mov    0x804004,%eax
  8014bb:	8b 40 48             	mov    0x48(%eax),%eax
  8014be:	83 ec 04             	sub    $0x4,%esp
  8014c1:	53                   	push   %ebx
  8014c2:	50                   	push   %eax
  8014c3:	68 60 25 80 00       	push   $0x802560
  8014c8:	e8 66 ed ff ff       	call   800233 <cprintf>
		return -E_INVAL;
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d5:	eb da                	jmp    8014b1 <write+0x55>
		return -E_NOT_SUPP;
  8014d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014dc:	eb d3                	jmp    8014b1 <write+0x55>

008014de <seek>:

int
seek(int fdnum, off_t offset)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014e4:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014e7:	50                   	push   %eax
  8014e8:	ff 75 08             	pushl  0x8(%ebp)
  8014eb:	e8 2d fc ff ff       	call   80111d <fd_lookup>
  8014f0:	83 c4 08             	add    $0x8,%esp
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	78 0e                	js     801505 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	53                   	push   %ebx
  80150b:	83 ec 14             	sub    $0x14,%esp
  80150e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801511:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801514:	50                   	push   %eax
  801515:	53                   	push   %ebx
  801516:	e8 02 fc ff ff       	call   80111d <fd_lookup>
  80151b:	83 c4 08             	add    $0x8,%esp
  80151e:	85 c0                	test   %eax,%eax
  801520:	78 37                	js     801559 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801522:	83 ec 08             	sub    $0x8,%esp
  801525:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801528:	50                   	push   %eax
  801529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152c:	ff 30                	pushl  (%eax)
  80152e:	e8 40 fc ff ff       	call   801173 <dev_lookup>
  801533:	83 c4 10             	add    $0x10,%esp
  801536:	85 c0                	test   %eax,%eax
  801538:	78 1f                	js     801559 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80153a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801541:	74 1b                	je     80155e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801546:	8b 52 18             	mov    0x18(%edx),%edx
  801549:	85 d2                	test   %edx,%edx
  80154b:	74 32                	je     80157f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	ff 75 0c             	pushl  0xc(%ebp)
  801553:	50                   	push   %eax
  801554:	ff d2                	call   *%edx
  801556:	83 c4 10             	add    $0x10,%esp
}
  801559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80155e:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801563:	8b 40 48             	mov    0x48(%eax),%eax
  801566:	83 ec 04             	sub    $0x4,%esp
  801569:	53                   	push   %ebx
  80156a:	50                   	push   %eax
  80156b:	68 20 25 80 00       	push   $0x802520
  801570:	e8 be ec ff ff       	call   800233 <cprintf>
		return -E_INVAL;
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157d:	eb da                	jmp    801559 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80157f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801584:	eb d3                	jmp    801559 <ftruncate+0x52>

00801586 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	53                   	push   %ebx
  80158a:	83 ec 14             	sub    $0x14,%esp
  80158d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801590:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801593:	50                   	push   %eax
  801594:	ff 75 08             	pushl  0x8(%ebp)
  801597:	e8 81 fb ff ff       	call   80111d <fd_lookup>
  80159c:	83 c4 08             	add    $0x8,%esp
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	78 4b                	js     8015ee <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a3:	83 ec 08             	sub    $0x8,%esp
  8015a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a9:	50                   	push   %eax
  8015aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ad:	ff 30                	pushl  (%eax)
  8015af:	e8 bf fb ff ff       	call   801173 <dev_lookup>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	78 33                	js     8015ee <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015be:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015c2:	74 2f                	je     8015f3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015c4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015c7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015ce:	00 00 00 
	stat->st_isdir = 0;
  8015d1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015d8:	00 00 00 
	stat->st_dev = dev;
  8015db:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015e1:	83 ec 08             	sub    $0x8,%esp
  8015e4:	53                   	push   %ebx
  8015e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8015e8:	ff 50 14             	call   *0x14(%eax)
  8015eb:	83 c4 10             	add    $0x10,%esp
}
  8015ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    
		return -E_NOT_SUPP;
  8015f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f8:	eb f4                	jmp    8015ee <fstat+0x68>

008015fa <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	56                   	push   %esi
  8015fe:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015ff:	83 ec 08             	sub    $0x8,%esp
  801602:	6a 00                	push   $0x0
  801604:	ff 75 08             	pushl  0x8(%ebp)
  801607:	e8 e7 01 00 00       	call   8017f3 <open>
  80160c:	89 c3                	mov    %eax,%ebx
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	85 c0                	test   %eax,%eax
  801613:	78 1b                	js     801630 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801615:	83 ec 08             	sub    $0x8,%esp
  801618:	ff 75 0c             	pushl  0xc(%ebp)
  80161b:	50                   	push   %eax
  80161c:	e8 65 ff ff ff       	call   801586 <fstat>
  801621:	89 c6                	mov    %eax,%esi
	close(fd);
  801623:	89 1c 24             	mov    %ebx,(%esp)
  801626:	e8 27 fc ff ff       	call   801252 <close>
	return r;
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	89 f3                	mov    %esi,%ebx
}
  801630:	89 d8                	mov    %ebx,%eax
  801632:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801635:	5b                   	pop    %ebx
  801636:	5e                   	pop    %esi
  801637:	5d                   	pop    %ebp
  801638:	c3                   	ret    

00801639 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	56                   	push   %esi
  80163d:	53                   	push   %ebx
  80163e:	89 c6                	mov    %eax,%esi
  801640:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801642:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801649:	74 27                	je     801672 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80164b:	6a 07                	push   $0x7
  80164d:	68 00 50 80 00       	push   $0x805000
  801652:	56                   	push   %esi
  801653:	ff 35 00 40 80 00    	pushl  0x804000
  801659:	e8 f9 f9 ff ff       	call   801057 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80165e:	83 c4 0c             	add    $0xc,%esp
  801661:	6a 00                	push   $0x0
  801663:	53                   	push   %ebx
  801664:	6a 00                	push   $0x0
  801666:	e8 d5 f9 ff ff       	call   801040 <ipc_recv>
}
  80166b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166e:	5b                   	pop    %ebx
  80166f:	5e                   	pop    %esi
  801670:	5d                   	pop    %ebp
  801671:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801672:	83 ec 0c             	sub    $0xc,%esp
  801675:	6a 01                	push   $0x1
  801677:	e8 f2 f9 ff ff       	call   80106e <ipc_find_env>
  80167c:	a3 00 40 80 00       	mov    %eax,0x804000
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	eb c5                	jmp    80164b <fsipc+0x12>

00801686 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	8b 40 0c             	mov    0xc(%eax),%eax
  801692:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801697:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80169f:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a4:	b8 02 00 00 00       	mov    $0x2,%eax
  8016a9:	e8 8b ff ff ff       	call   801639 <fsipc>
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <devfile_flush>:
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8016bc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c6:	b8 06 00 00 00       	mov    $0x6,%eax
  8016cb:	e8 69 ff ff ff       	call   801639 <fsipc>
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <devfile_stat>:
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	53                   	push   %ebx
  8016d6:	83 ec 04             	sub    $0x4,%esp
  8016d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ec:	b8 05 00 00 00       	mov    $0x5,%eax
  8016f1:	e8 43 ff ff ff       	call   801639 <fsipc>
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	78 2c                	js     801726 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	68 00 50 80 00       	push   $0x805000
  801702:	53                   	push   %ebx
  801703:	e8 15 f1 ff ff       	call   80081d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801708:	a1 80 50 80 00       	mov    0x805080,%eax
  80170d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801713:	a1 84 50 80 00       	mov    0x805084,%eax
  801718:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801726:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <devfile_write>:
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 0c             	sub    $0xc,%esp
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801739:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80173e:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801741:	8b 55 08             	mov    0x8(%ebp),%edx
  801744:	8b 52 0c             	mov    0xc(%edx),%edx
  801747:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  80174d:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  801752:	50                   	push   %eax
  801753:	ff 75 0c             	pushl  0xc(%ebp)
  801756:	68 08 50 80 00       	push   $0x805008
  80175b:	e8 4b f2 ff ff       	call   8009ab <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801760:	ba 00 00 00 00       	mov    $0x0,%edx
  801765:	b8 04 00 00 00       	mov    $0x4,%eax
  80176a:	e8 ca fe ff ff       	call   801639 <fsipc>
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <devfile_read>:
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	56                   	push   %esi
  801775:	53                   	push   %ebx
  801776:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	8b 40 0c             	mov    0xc(%eax),%eax
  80177f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801784:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80178a:	ba 00 00 00 00       	mov    $0x0,%edx
  80178f:	b8 03 00 00 00       	mov    $0x3,%eax
  801794:	e8 a0 fe ff ff       	call   801639 <fsipc>
  801799:	89 c3                	mov    %eax,%ebx
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 1f                	js     8017be <devfile_read+0x4d>
	assert(r <= n);
  80179f:	39 f0                	cmp    %esi,%eax
  8017a1:	77 24                	ja     8017c7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017a3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017a8:	7f 33                	jg     8017dd <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	50                   	push   %eax
  8017ae:	68 00 50 80 00       	push   $0x805000
  8017b3:	ff 75 0c             	pushl  0xc(%ebp)
  8017b6:	e8 f0 f1 ff ff       	call   8009ab <memmove>
	return r;
  8017bb:	83 c4 10             	add    $0x10,%esp
}
  8017be:	89 d8                	mov    %ebx,%eax
  8017c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c3:	5b                   	pop    %ebx
  8017c4:	5e                   	pop    %esi
  8017c5:	5d                   	pop    %ebp
  8017c6:	c3                   	ret    
	assert(r <= n);
  8017c7:	68 90 25 80 00       	push   $0x802590
  8017cc:	68 97 25 80 00       	push   $0x802597
  8017d1:	6a 7c                	push   $0x7c
  8017d3:	68 ac 25 80 00       	push   $0x8025ac
  8017d8:	e8 7b e9 ff ff       	call   800158 <_panic>
	assert(r <= PGSIZE);
  8017dd:	68 b7 25 80 00       	push   $0x8025b7
  8017e2:	68 97 25 80 00       	push   $0x802597
  8017e7:	6a 7d                	push   $0x7d
  8017e9:	68 ac 25 80 00       	push   $0x8025ac
  8017ee:	e8 65 e9 ff ff       	call   800158 <_panic>

008017f3 <open>:
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	56                   	push   %esi
  8017f7:	53                   	push   %ebx
  8017f8:	83 ec 1c             	sub    $0x1c,%esp
  8017fb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017fe:	56                   	push   %esi
  8017ff:	e8 e2 ef ff ff       	call   8007e6 <strlen>
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80180c:	7f 6c                	jg     80187a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80180e:	83 ec 0c             	sub    $0xc,%esp
  801811:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801814:	50                   	push   %eax
  801815:	e8 b4 f8 ff ff       	call   8010ce <fd_alloc>
  80181a:	89 c3                	mov    %eax,%ebx
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	85 c0                	test   %eax,%eax
  801821:	78 3c                	js     80185f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801823:	83 ec 08             	sub    $0x8,%esp
  801826:	56                   	push   %esi
  801827:	68 00 50 80 00       	push   $0x805000
  80182c:	e8 ec ef ff ff       	call   80081d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801839:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183c:	b8 01 00 00 00       	mov    $0x1,%eax
  801841:	e8 f3 fd ff ff       	call   801639 <fsipc>
  801846:	89 c3                	mov    %eax,%ebx
  801848:	83 c4 10             	add    $0x10,%esp
  80184b:	85 c0                	test   %eax,%eax
  80184d:	78 19                	js     801868 <open+0x75>
	return fd2num(fd);
  80184f:	83 ec 0c             	sub    $0xc,%esp
  801852:	ff 75 f4             	pushl  -0xc(%ebp)
  801855:	e8 4d f8 ff ff       	call   8010a7 <fd2num>
  80185a:	89 c3                	mov    %eax,%ebx
  80185c:	83 c4 10             	add    $0x10,%esp
}
  80185f:	89 d8                	mov    %ebx,%eax
  801861:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801864:	5b                   	pop    %ebx
  801865:	5e                   	pop    %esi
  801866:	5d                   	pop    %ebp
  801867:	c3                   	ret    
		fd_close(fd, 0);
  801868:	83 ec 08             	sub    $0x8,%esp
  80186b:	6a 00                	push   $0x0
  80186d:	ff 75 f4             	pushl  -0xc(%ebp)
  801870:	e8 54 f9 ff ff       	call   8011c9 <fd_close>
		return r;
  801875:	83 c4 10             	add    $0x10,%esp
  801878:	eb e5                	jmp    80185f <open+0x6c>
		return -E_BAD_PATH;
  80187a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80187f:	eb de                	jmp    80185f <open+0x6c>

00801881 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801887:	ba 00 00 00 00       	mov    $0x0,%edx
  80188c:	b8 08 00 00 00       	mov    $0x8,%eax
  801891:	e8 a3 fd ff ff       	call   801639 <fsipc>
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	56                   	push   %esi
  80189c:	53                   	push   %ebx
  80189d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018a0:	83 ec 0c             	sub    $0xc,%esp
  8018a3:	ff 75 08             	pushl  0x8(%ebp)
  8018a6:	e8 0c f8 ff ff       	call   8010b7 <fd2data>
  8018ab:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8018ad:	83 c4 08             	add    $0x8,%esp
  8018b0:	68 c3 25 80 00       	push   $0x8025c3
  8018b5:	53                   	push   %ebx
  8018b6:	e8 62 ef ff ff       	call   80081d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8018bb:	8b 46 04             	mov    0x4(%esi),%eax
  8018be:	2b 06                	sub    (%esi),%eax
  8018c0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8018c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018cd:	00 00 00 
	stat->st_dev = &devpipe;
  8018d0:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8018d7:	30 80 00 
	return 0;
}
  8018da:	b8 00 00 00 00       	mov    $0x0,%eax
  8018df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	53                   	push   %ebx
  8018ea:	83 ec 0c             	sub    $0xc,%esp
  8018ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018f0:	53                   	push   %ebx
  8018f1:	6a 00                	push   $0x0
  8018f3:	e8 a3 f3 ff ff       	call   800c9b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018f8:	89 1c 24             	mov    %ebx,(%esp)
  8018fb:	e8 b7 f7 ff ff       	call   8010b7 <fd2data>
  801900:	83 c4 08             	add    $0x8,%esp
  801903:	50                   	push   %eax
  801904:	6a 00                	push   $0x0
  801906:	e8 90 f3 ff ff       	call   800c9b <sys_page_unmap>
}
  80190b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <_pipeisclosed>:
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	57                   	push   %edi
  801914:	56                   	push   %esi
  801915:	53                   	push   %ebx
  801916:	83 ec 1c             	sub    $0x1c,%esp
  801919:	89 c7                	mov    %eax,%edi
  80191b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80191d:	a1 04 40 80 00       	mov    0x804004,%eax
  801922:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801925:	83 ec 0c             	sub    $0xc,%esp
  801928:	57                   	push   %edi
  801929:	e8 cf 04 00 00       	call   801dfd <pageref>
  80192e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801931:	89 34 24             	mov    %esi,(%esp)
  801934:	e8 c4 04 00 00       	call   801dfd <pageref>
		nn = thisenv->env_runs;
  801939:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80193f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	39 cb                	cmp    %ecx,%ebx
  801947:	74 1b                	je     801964 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801949:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80194c:	75 cf                	jne    80191d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80194e:	8b 42 58             	mov    0x58(%edx),%eax
  801951:	6a 01                	push   $0x1
  801953:	50                   	push   %eax
  801954:	53                   	push   %ebx
  801955:	68 ca 25 80 00       	push   $0x8025ca
  80195a:	e8 d4 e8 ff ff       	call   800233 <cprintf>
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	eb b9                	jmp    80191d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801964:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801967:	0f 94 c0             	sete   %al
  80196a:	0f b6 c0             	movzbl %al,%eax
}
  80196d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801970:	5b                   	pop    %ebx
  801971:	5e                   	pop    %esi
  801972:	5f                   	pop    %edi
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    

00801975 <devpipe_write>:
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	57                   	push   %edi
  801979:	56                   	push   %esi
  80197a:	53                   	push   %ebx
  80197b:	83 ec 28             	sub    $0x28,%esp
  80197e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801981:	56                   	push   %esi
  801982:	e8 30 f7 ff ff       	call   8010b7 <fd2data>
  801987:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801989:	83 c4 10             	add    $0x10,%esp
  80198c:	bf 00 00 00 00       	mov    $0x0,%edi
  801991:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801994:	74 4f                	je     8019e5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801996:	8b 43 04             	mov    0x4(%ebx),%eax
  801999:	8b 0b                	mov    (%ebx),%ecx
  80199b:	8d 51 20             	lea    0x20(%ecx),%edx
  80199e:	39 d0                	cmp    %edx,%eax
  8019a0:	72 14                	jb     8019b6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8019a2:	89 da                	mov    %ebx,%edx
  8019a4:	89 f0                	mov    %esi,%eax
  8019a6:	e8 65 ff ff ff       	call   801910 <_pipeisclosed>
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	75 3a                	jne    8019e9 <devpipe_write+0x74>
			sys_yield();
  8019af:	e8 43 f2 ff ff       	call   800bf7 <sys_yield>
  8019b4:	eb e0                	jmp    801996 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019b9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8019bd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8019c0:	89 c2                	mov    %eax,%edx
  8019c2:	c1 fa 1f             	sar    $0x1f,%edx
  8019c5:	89 d1                	mov    %edx,%ecx
  8019c7:	c1 e9 1b             	shr    $0x1b,%ecx
  8019ca:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8019cd:	83 e2 1f             	and    $0x1f,%edx
  8019d0:	29 ca                	sub    %ecx,%edx
  8019d2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8019d6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8019da:	83 c0 01             	add    $0x1,%eax
  8019dd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8019e0:	83 c7 01             	add    $0x1,%edi
  8019e3:	eb ac                	jmp    801991 <devpipe_write+0x1c>
	return i;
  8019e5:	89 f8                	mov    %edi,%eax
  8019e7:	eb 05                	jmp    8019ee <devpipe_write+0x79>
				return 0;
  8019e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019f1:	5b                   	pop    %ebx
  8019f2:	5e                   	pop    %esi
  8019f3:	5f                   	pop    %edi
  8019f4:	5d                   	pop    %ebp
  8019f5:	c3                   	ret    

008019f6 <devpipe_read>:
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	57                   	push   %edi
  8019fa:	56                   	push   %esi
  8019fb:	53                   	push   %ebx
  8019fc:	83 ec 18             	sub    $0x18,%esp
  8019ff:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a02:	57                   	push   %edi
  801a03:	e8 af f6 ff ff       	call   8010b7 <fd2data>
  801a08:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a0a:	83 c4 10             	add    $0x10,%esp
  801a0d:	be 00 00 00 00       	mov    $0x0,%esi
  801a12:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a15:	74 47                	je     801a5e <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801a17:	8b 03                	mov    (%ebx),%eax
  801a19:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a1c:	75 22                	jne    801a40 <devpipe_read+0x4a>
			if (i > 0)
  801a1e:	85 f6                	test   %esi,%esi
  801a20:	75 14                	jne    801a36 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801a22:	89 da                	mov    %ebx,%edx
  801a24:	89 f8                	mov    %edi,%eax
  801a26:	e8 e5 fe ff ff       	call   801910 <_pipeisclosed>
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	75 33                	jne    801a62 <devpipe_read+0x6c>
			sys_yield();
  801a2f:	e8 c3 f1 ff ff       	call   800bf7 <sys_yield>
  801a34:	eb e1                	jmp    801a17 <devpipe_read+0x21>
				return i;
  801a36:	89 f0                	mov    %esi,%eax
}
  801a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5f                   	pop    %edi
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a40:	99                   	cltd   
  801a41:	c1 ea 1b             	shr    $0x1b,%edx
  801a44:	01 d0                	add    %edx,%eax
  801a46:	83 e0 1f             	and    $0x1f,%eax
  801a49:	29 d0                	sub    %edx,%eax
  801a4b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a53:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801a56:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801a59:	83 c6 01             	add    $0x1,%esi
  801a5c:	eb b4                	jmp    801a12 <devpipe_read+0x1c>
	return i;
  801a5e:	89 f0                	mov    %esi,%eax
  801a60:	eb d6                	jmp    801a38 <devpipe_read+0x42>
				return 0;
  801a62:	b8 00 00 00 00       	mov    $0x0,%eax
  801a67:	eb cf                	jmp    801a38 <devpipe_read+0x42>

00801a69 <pipe>:
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	56                   	push   %esi
  801a6d:	53                   	push   %ebx
  801a6e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801a71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a74:	50                   	push   %eax
  801a75:	e8 54 f6 ff ff       	call   8010ce <fd_alloc>
  801a7a:	89 c3                	mov    %eax,%ebx
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	78 5b                	js     801ade <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a83:	83 ec 04             	sub    $0x4,%esp
  801a86:	68 07 04 00 00       	push   $0x407
  801a8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8e:	6a 00                	push   $0x0
  801a90:	e8 81 f1 ff ff       	call   800c16 <sys_page_alloc>
  801a95:	89 c3                	mov    %eax,%ebx
  801a97:	83 c4 10             	add    $0x10,%esp
  801a9a:	85 c0                	test   %eax,%eax
  801a9c:	78 40                	js     801ade <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801a9e:	83 ec 0c             	sub    $0xc,%esp
  801aa1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa4:	50                   	push   %eax
  801aa5:	e8 24 f6 ff ff       	call   8010ce <fd_alloc>
  801aaa:	89 c3                	mov    %eax,%ebx
  801aac:	83 c4 10             	add    $0x10,%esp
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	78 1b                	js     801ace <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ab3:	83 ec 04             	sub    $0x4,%esp
  801ab6:	68 07 04 00 00       	push   $0x407
  801abb:	ff 75 f0             	pushl  -0x10(%ebp)
  801abe:	6a 00                	push   $0x0
  801ac0:	e8 51 f1 ff ff       	call   800c16 <sys_page_alloc>
  801ac5:	89 c3                	mov    %eax,%ebx
  801ac7:	83 c4 10             	add    $0x10,%esp
  801aca:	85 c0                	test   %eax,%eax
  801acc:	79 19                	jns    801ae7 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801ace:	83 ec 08             	sub    $0x8,%esp
  801ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad4:	6a 00                	push   $0x0
  801ad6:	e8 c0 f1 ff ff       	call   800c9b <sys_page_unmap>
  801adb:	83 c4 10             	add    $0x10,%esp
}
  801ade:	89 d8                	mov    %ebx,%eax
  801ae0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5e                   	pop    %esi
  801ae5:	5d                   	pop    %ebp
  801ae6:	c3                   	ret    
	va = fd2data(fd0);
  801ae7:	83 ec 0c             	sub    $0xc,%esp
  801aea:	ff 75 f4             	pushl  -0xc(%ebp)
  801aed:	e8 c5 f5 ff ff       	call   8010b7 <fd2data>
  801af2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801af4:	83 c4 0c             	add    $0xc,%esp
  801af7:	68 07 04 00 00       	push   $0x407
  801afc:	50                   	push   %eax
  801afd:	6a 00                	push   $0x0
  801aff:	e8 12 f1 ff ff       	call   800c16 <sys_page_alloc>
  801b04:	89 c3                	mov    %eax,%ebx
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	0f 88 8c 00 00 00    	js     801b9d <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b11:	83 ec 0c             	sub    $0xc,%esp
  801b14:	ff 75 f0             	pushl  -0x10(%ebp)
  801b17:	e8 9b f5 ff ff       	call   8010b7 <fd2data>
  801b1c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b23:	50                   	push   %eax
  801b24:	6a 00                	push   $0x0
  801b26:	56                   	push   %esi
  801b27:	6a 00                	push   $0x0
  801b29:	e8 2b f1 ff ff       	call   800c59 <sys_page_map>
  801b2e:	89 c3                	mov    %eax,%ebx
  801b30:	83 c4 20             	add    $0x20,%esp
  801b33:	85 c0                	test   %eax,%eax
  801b35:	78 58                	js     801b8f <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b40:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b45:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b55:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b5a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b61:	83 ec 0c             	sub    $0xc,%esp
  801b64:	ff 75 f4             	pushl  -0xc(%ebp)
  801b67:	e8 3b f5 ff ff       	call   8010a7 <fd2num>
  801b6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b6f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801b71:	83 c4 04             	add    $0x4,%esp
  801b74:	ff 75 f0             	pushl  -0x10(%ebp)
  801b77:	e8 2b f5 ff ff       	call   8010a7 <fd2num>
  801b7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b7f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b8a:	e9 4f ff ff ff       	jmp    801ade <pipe+0x75>
	sys_page_unmap(0, va);
  801b8f:	83 ec 08             	sub    $0x8,%esp
  801b92:	56                   	push   %esi
  801b93:	6a 00                	push   $0x0
  801b95:	e8 01 f1 ff ff       	call   800c9b <sys_page_unmap>
  801b9a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b9d:	83 ec 08             	sub    $0x8,%esp
  801ba0:	ff 75 f0             	pushl  -0x10(%ebp)
  801ba3:	6a 00                	push   $0x0
  801ba5:	e8 f1 f0 ff ff       	call   800c9b <sys_page_unmap>
  801baa:	83 c4 10             	add    $0x10,%esp
  801bad:	e9 1c ff ff ff       	jmp    801ace <pipe+0x65>

00801bb2 <pipeisclosed>:
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bbb:	50                   	push   %eax
  801bbc:	ff 75 08             	pushl  0x8(%ebp)
  801bbf:	e8 59 f5 ff ff       	call   80111d <fd_lookup>
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	78 18                	js     801be3 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801bcb:	83 ec 0c             	sub    $0xc,%esp
  801bce:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd1:	e8 e1 f4 ff ff       	call   8010b7 <fd2data>
	return _pipeisclosed(fd, p);
  801bd6:	89 c2                	mov    %eax,%edx
  801bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdb:	e8 30 fd ff ff       	call   801910 <_pipeisclosed>
  801be0:	83 c4 10             	add    $0x10,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801be8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    

00801bef <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801bf5:	68 e2 25 80 00       	push   $0x8025e2
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	e8 1b ec ff ff       	call   80081d <strcpy>
	return 0;
}
  801c02:	b8 00 00 00 00       	mov    $0x0,%eax
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <devcons_write>:
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	57                   	push   %edi
  801c0d:	56                   	push   %esi
  801c0e:	53                   	push   %ebx
  801c0f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801c15:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801c1a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801c20:	eb 2f                	jmp    801c51 <devcons_write+0x48>
		m = n - tot;
  801c22:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c25:	29 f3                	sub    %esi,%ebx
  801c27:	83 fb 7f             	cmp    $0x7f,%ebx
  801c2a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801c2f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	53                   	push   %ebx
  801c36:	89 f0                	mov    %esi,%eax
  801c38:	03 45 0c             	add    0xc(%ebp),%eax
  801c3b:	50                   	push   %eax
  801c3c:	57                   	push   %edi
  801c3d:	e8 69 ed ff ff       	call   8009ab <memmove>
		sys_cputs(buf, m);
  801c42:	83 c4 08             	add    $0x8,%esp
  801c45:	53                   	push   %ebx
  801c46:	57                   	push   %edi
  801c47:	e8 0e ef ff ff       	call   800b5a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801c4c:	01 de                	add    %ebx,%esi
  801c4e:	83 c4 10             	add    $0x10,%esp
  801c51:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c54:	72 cc                	jb     801c22 <devcons_write+0x19>
}
  801c56:	89 f0                	mov    %esi,%eax
  801c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5f                   	pop    %edi
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    

00801c60 <devcons_read>:
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 08             	sub    $0x8,%esp
  801c66:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801c6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c6f:	75 07                	jne    801c78 <devcons_read+0x18>
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    
		sys_yield();
  801c73:	e8 7f ef ff ff       	call   800bf7 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801c78:	e8 fb ee ff ff       	call   800b78 <sys_cgetc>
  801c7d:	85 c0                	test   %eax,%eax
  801c7f:	74 f2                	je     801c73 <devcons_read+0x13>
	if (c < 0)
  801c81:	85 c0                	test   %eax,%eax
  801c83:	78 ec                	js     801c71 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801c85:	83 f8 04             	cmp    $0x4,%eax
  801c88:	74 0c                	je     801c96 <devcons_read+0x36>
	*(char*)vbuf = c;
  801c8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8d:	88 02                	mov    %al,(%edx)
	return 1;
  801c8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c94:	eb db                	jmp    801c71 <devcons_read+0x11>
		return 0;
  801c96:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9b:	eb d4                	jmp    801c71 <devcons_read+0x11>

00801c9d <cputchar>:
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ca9:	6a 01                	push   $0x1
  801cab:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cae:	50                   	push   %eax
  801caf:	e8 a6 ee ff ff       	call   800b5a <sys_cputs>
}
  801cb4:	83 c4 10             	add    $0x10,%esp
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <getchar>:
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801cbf:	6a 01                	push   $0x1
  801cc1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cc4:	50                   	push   %eax
  801cc5:	6a 00                	push   $0x0
  801cc7:	e8 c2 f6 ff ff       	call   80138e <read>
	if (r < 0)
  801ccc:	83 c4 10             	add    $0x10,%esp
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	78 08                	js     801cdb <getchar+0x22>
	if (r < 1)
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	7e 06                	jle    801cdd <getchar+0x24>
	return c;
  801cd7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    
		return -E_EOF;
  801cdd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ce2:	eb f7                	jmp    801cdb <getchar+0x22>

00801ce4 <iscons>:
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ced:	50                   	push   %eax
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	e8 27 f4 ff ff       	call   80111d <fd_lookup>
  801cf6:	83 c4 10             	add    $0x10,%esp
  801cf9:	85 c0                	test   %eax,%eax
  801cfb:	78 11                	js     801d0e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d00:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d06:	39 10                	cmp    %edx,(%eax)
  801d08:	0f 94 c0             	sete   %al
  801d0b:	0f b6 c0             	movzbl %al,%eax
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <opencons>:
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801d16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d19:	50                   	push   %eax
  801d1a:	e8 af f3 ff ff       	call   8010ce <fd_alloc>
  801d1f:	83 c4 10             	add    $0x10,%esp
  801d22:	85 c0                	test   %eax,%eax
  801d24:	78 3a                	js     801d60 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d26:	83 ec 04             	sub    $0x4,%esp
  801d29:	68 07 04 00 00       	push   $0x407
  801d2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d31:	6a 00                	push   $0x0
  801d33:	e8 de ee ff ff       	call   800c16 <sys_page_alloc>
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	78 21                	js     801d60 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d42:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d48:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d54:	83 ec 0c             	sub    $0xc,%esp
  801d57:	50                   	push   %eax
  801d58:	e8 4a f3 ff ff       	call   8010a7 <fd2num>
  801d5d:	83 c4 10             	add    $0x10,%esp
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	53                   	push   %ebx
  801d66:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801d69:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801d70:	74 0d                	je     801d7f <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801d7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801d7f:	e8 54 ee ff ff       	call   800bd8 <sys_getenvid>
  801d84:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801d86:	83 ec 04             	sub    $0x4,%esp
  801d89:	6a 07                	push   $0x7
  801d8b:	68 00 f0 bf ee       	push   $0xeebff000
  801d90:	50                   	push   %eax
  801d91:	e8 80 ee ff ff       	call   800c16 <sys_page_alloc>
        	if (r < 0) {
  801d96:	83 c4 10             	add    $0x10,%esp
  801d99:	85 c0                	test   %eax,%eax
  801d9b:	78 27                	js     801dc4 <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801d9d:	83 ec 08             	sub    $0x8,%esp
  801da0:	68 d6 1d 80 00       	push   $0x801dd6
  801da5:	53                   	push   %ebx
  801da6:	e8 b6 ef ff ff       	call   800d61 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801dab:	83 c4 10             	add    $0x10,%esp
  801dae:	85 c0                	test   %eax,%eax
  801db0:	79 c0                	jns    801d72 <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801db2:	50                   	push   %eax
  801db3:	68 ee 25 80 00       	push   $0x8025ee
  801db8:	6a 28                	push   $0x28
  801dba:	68 02 26 80 00       	push   $0x802602
  801dbf:	e8 94 e3 ff ff       	call   800158 <_panic>
            		panic("pgfault_handler: %e", r);
  801dc4:	50                   	push   %eax
  801dc5:	68 ee 25 80 00       	push   $0x8025ee
  801dca:	6a 24                	push   $0x24
  801dcc:	68 02 26 80 00       	push   $0x802602
  801dd1:	e8 82 e3 ff ff       	call   800158 <_panic>

00801dd6 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801dd6:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801dd7:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801ddc:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801dde:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  801de1:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801de5:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801de8:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801dec:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  801df0:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801df3:	83 c4 08             	add    $0x8,%esp
	popal
  801df6:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801df7:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801dfa:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801dfb:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801dfc:	c3                   	ret    

00801dfd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e03:	89 d0                	mov    %edx,%eax
  801e05:	c1 e8 16             	shr    $0x16,%eax
  801e08:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801e14:	f6 c1 01             	test   $0x1,%cl
  801e17:	74 1d                	je     801e36 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801e19:	c1 ea 0c             	shr    $0xc,%edx
  801e1c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e23:	f6 c2 01             	test   $0x1,%dl
  801e26:	74 0e                	je     801e36 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e28:	c1 ea 0c             	shr    $0xc,%edx
  801e2b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e32:	ef 
  801e33:	0f b7 c0             	movzwl %ax,%eax
}
  801e36:	5d                   	pop    %ebp
  801e37:	c3                   	ret    
  801e38:	66 90                	xchg   %ax,%ax
  801e3a:	66 90                	xchg   %ax,%ax
  801e3c:	66 90                	xchg   %ax,%ax
  801e3e:	66 90                	xchg   %ax,%ax

00801e40 <__udivdi3>:
  801e40:	55                   	push   %ebp
  801e41:	57                   	push   %edi
  801e42:	56                   	push   %esi
  801e43:	53                   	push   %ebx
  801e44:	83 ec 1c             	sub    $0x1c,%esp
  801e47:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801e4b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801e4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e53:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e57:	85 d2                	test   %edx,%edx
  801e59:	75 35                	jne    801e90 <__udivdi3+0x50>
  801e5b:	39 f3                	cmp    %esi,%ebx
  801e5d:	0f 87 bd 00 00 00    	ja     801f20 <__udivdi3+0xe0>
  801e63:	85 db                	test   %ebx,%ebx
  801e65:	89 d9                	mov    %ebx,%ecx
  801e67:	75 0b                	jne    801e74 <__udivdi3+0x34>
  801e69:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6e:	31 d2                	xor    %edx,%edx
  801e70:	f7 f3                	div    %ebx
  801e72:	89 c1                	mov    %eax,%ecx
  801e74:	31 d2                	xor    %edx,%edx
  801e76:	89 f0                	mov    %esi,%eax
  801e78:	f7 f1                	div    %ecx
  801e7a:	89 c6                	mov    %eax,%esi
  801e7c:	89 e8                	mov    %ebp,%eax
  801e7e:	89 f7                	mov    %esi,%edi
  801e80:	f7 f1                	div    %ecx
  801e82:	89 fa                	mov    %edi,%edx
  801e84:	83 c4 1c             	add    $0x1c,%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5f                   	pop    %edi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    
  801e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e90:	39 f2                	cmp    %esi,%edx
  801e92:	77 7c                	ja     801f10 <__udivdi3+0xd0>
  801e94:	0f bd fa             	bsr    %edx,%edi
  801e97:	83 f7 1f             	xor    $0x1f,%edi
  801e9a:	0f 84 98 00 00 00    	je     801f38 <__udivdi3+0xf8>
  801ea0:	89 f9                	mov    %edi,%ecx
  801ea2:	b8 20 00 00 00       	mov    $0x20,%eax
  801ea7:	29 f8                	sub    %edi,%eax
  801ea9:	d3 e2                	shl    %cl,%edx
  801eab:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eaf:	89 c1                	mov    %eax,%ecx
  801eb1:	89 da                	mov    %ebx,%edx
  801eb3:	d3 ea                	shr    %cl,%edx
  801eb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801eb9:	09 d1                	or     %edx,%ecx
  801ebb:	89 f2                	mov    %esi,%edx
  801ebd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ec1:	89 f9                	mov    %edi,%ecx
  801ec3:	d3 e3                	shl    %cl,%ebx
  801ec5:	89 c1                	mov    %eax,%ecx
  801ec7:	d3 ea                	shr    %cl,%edx
  801ec9:	89 f9                	mov    %edi,%ecx
  801ecb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801ecf:	d3 e6                	shl    %cl,%esi
  801ed1:	89 eb                	mov    %ebp,%ebx
  801ed3:	89 c1                	mov    %eax,%ecx
  801ed5:	d3 eb                	shr    %cl,%ebx
  801ed7:	09 de                	or     %ebx,%esi
  801ed9:	89 f0                	mov    %esi,%eax
  801edb:	f7 74 24 08          	divl   0x8(%esp)
  801edf:	89 d6                	mov    %edx,%esi
  801ee1:	89 c3                	mov    %eax,%ebx
  801ee3:	f7 64 24 0c          	mull   0xc(%esp)
  801ee7:	39 d6                	cmp    %edx,%esi
  801ee9:	72 0c                	jb     801ef7 <__udivdi3+0xb7>
  801eeb:	89 f9                	mov    %edi,%ecx
  801eed:	d3 e5                	shl    %cl,%ebp
  801eef:	39 c5                	cmp    %eax,%ebp
  801ef1:	73 5d                	jae    801f50 <__udivdi3+0x110>
  801ef3:	39 d6                	cmp    %edx,%esi
  801ef5:	75 59                	jne    801f50 <__udivdi3+0x110>
  801ef7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801efa:	31 ff                	xor    %edi,%edi
  801efc:	89 fa                	mov    %edi,%edx
  801efe:	83 c4 1c             	add    $0x1c,%esp
  801f01:	5b                   	pop    %ebx
  801f02:	5e                   	pop    %esi
  801f03:	5f                   	pop    %edi
  801f04:	5d                   	pop    %ebp
  801f05:	c3                   	ret    
  801f06:	8d 76 00             	lea    0x0(%esi),%esi
  801f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801f10:	31 ff                	xor    %edi,%edi
  801f12:	31 c0                	xor    %eax,%eax
  801f14:	89 fa                	mov    %edi,%edx
  801f16:	83 c4 1c             	add    $0x1c,%esp
  801f19:	5b                   	pop    %ebx
  801f1a:	5e                   	pop    %esi
  801f1b:	5f                   	pop    %edi
  801f1c:	5d                   	pop    %ebp
  801f1d:	c3                   	ret    
  801f1e:	66 90                	xchg   %ax,%ax
  801f20:	31 ff                	xor    %edi,%edi
  801f22:	89 e8                	mov    %ebp,%eax
  801f24:	89 f2                	mov    %esi,%edx
  801f26:	f7 f3                	div    %ebx
  801f28:	89 fa                	mov    %edi,%edx
  801f2a:	83 c4 1c             	add    $0x1c,%esp
  801f2d:	5b                   	pop    %ebx
  801f2e:	5e                   	pop    %esi
  801f2f:	5f                   	pop    %edi
  801f30:	5d                   	pop    %ebp
  801f31:	c3                   	ret    
  801f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f38:	39 f2                	cmp    %esi,%edx
  801f3a:	72 06                	jb     801f42 <__udivdi3+0x102>
  801f3c:	31 c0                	xor    %eax,%eax
  801f3e:	39 eb                	cmp    %ebp,%ebx
  801f40:	77 d2                	ja     801f14 <__udivdi3+0xd4>
  801f42:	b8 01 00 00 00       	mov    $0x1,%eax
  801f47:	eb cb                	jmp    801f14 <__udivdi3+0xd4>
  801f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f50:	89 d8                	mov    %ebx,%eax
  801f52:	31 ff                	xor    %edi,%edi
  801f54:	eb be                	jmp    801f14 <__udivdi3+0xd4>
  801f56:	66 90                	xchg   %ax,%ax
  801f58:	66 90                	xchg   %ax,%ax
  801f5a:	66 90                	xchg   %ax,%ax
  801f5c:	66 90                	xchg   %ax,%ax
  801f5e:	66 90                	xchg   %ax,%ax

00801f60 <__umoddi3>:
  801f60:	55                   	push   %ebp
  801f61:	57                   	push   %edi
  801f62:	56                   	push   %esi
  801f63:	53                   	push   %ebx
  801f64:	83 ec 1c             	sub    $0x1c,%esp
  801f67:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801f6b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801f6f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801f73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f77:	85 ed                	test   %ebp,%ebp
  801f79:	89 f0                	mov    %esi,%eax
  801f7b:	89 da                	mov    %ebx,%edx
  801f7d:	75 19                	jne    801f98 <__umoddi3+0x38>
  801f7f:	39 df                	cmp    %ebx,%edi
  801f81:	0f 86 b1 00 00 00    	jbe    802038 <__umoddi3+0xd8>
  801f87:	f7 f7                	div    %edi
  801f89:	89 d0                	mov    %edx,%eax
  801f8b:	31 d2                	xor    %edx,%edx
  801f8d:	83 c4 1c             	add    $0x1c,%esp
  801f90:	5b                   	pop    %ebx
  801f91:	5e                   	pop    %esi
  801f92:	5f                   	pop    %edi
  801f93:	5d                   	pop    %ebp
  801f94:	c3                   	ret    
  801f95:	8d 76 00             	lea    0x0(%esi),%esi
  801f98:	39 dd                	cmp    %ebx,%ebp
  801f9a:	77 f1                	ja     801f8d <__umoddi3+0x2d>
  801f9c:	0f bd cd             	bsr    %ebp,%ecx
  801f9f:	83 f1 1f             	xor    $0x1f,%ecx
  801fa2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fa6:	0f 84 b4 00 00 00    	je     802060 <__umoddi3+0x100>
  801fac:	b8 20 00 00 00       	mov    $0x20,%eax
  801fb1:	89 c2                	mov    %eax,%edx
  801fb3:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fb7:	29 c2                	sub    %eax,%edx
  801fb9:	89 c1                	mov    %eax,%ecx
  801fbb:	89 f8                	mov    %edi,%eax
  801fbd:	d3 e5                	shl    %cl,%ebp
  801fbf:	89 d1                	mov    %edx,%ecx
  801fc1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fc5:	d3 e8                	shr    %cl,%eax
  801fc7:	09 c5                	or     %eax,%ebp
  801fc9:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fcd:	89 c1                	mov    %eax,%ecx
  801fcf:	d3 e7                	shl    %cl,%edi
  801fd1:	89 d1                	mov    %edx,%ecx
  801fd3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801fd7:	89 df                	mov    %ebx,%edi
  801fd9:	d3 ef                	shr    %cl,%edi
  801fdb:	89 c1                	mov    %eax,%ecx
  801fdd:	89 f0                	mov    %esi,%eax
  801fdf:	d3 e3                	shl    %cl,%ebx
  801fe1:	89 d1                	mov    %edx,%ecx
  801fe3:	89 fa                	mov    %edi,%edx
  801fe5:	d3 e8                	shr    %cl,%eax
  801fe7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fec:	09 d8                	or     %ebx,%eax
  801fee:	f7 f5                	div    %ebp
  801ff0:	d3 e6                	shl    %cl,%esi
  801ff2:	89 d1                	mov    %edx,%ecx
  801ff4:	f7 64 24 08          	mull   0x8(%esp)
  801ff8:	39 d1                	cmp    %edx,%ecx
  801ffa:	89 c3                	mov    %eax,%ebx
  801ffc:	89 d7                	mov    %edx,%edi
  801ffe:	72 06                	jb     802006 <__umoddi3+0xa6>
  802000:	75 0e                	jne    802010 <__umoddi3+0xb0>
  802002:	39 c6                	cmp    %eax,%esi
  802004:	73 0a                	jae    802010 <__umoddi3+0xb0>
  802006:	2b 44 24 08          	sub    0x8(%esp),%eax
  80200a:	19 ea                	sbb    %ebp,%edx
  80200c:	89 d7                	mov    %edx,%edi
  80200e:	89 c3                	mov    %eax,%ebx
  802010:	89 ca                	mov    %ecx,%edx
  802012:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802017:	29 de                	sub    %ebx,%esi
  802019:	19 fa                	sbb    %edi,%edx
  80201b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80201f:	89 d0                	mov    %edx,%eax
  802021:	d3 e0                	shl    %cl,%eax
  802023:	89 d9                	mov    %ebx,%ecx
  802025:	d3 ee                	shr    %cl,%esi
  802027:	d3 ea                	shr    %cl,%edx
  802029:	09 f0                	or     %esi,%eax
  80202b:	83 c4 1c             	add    $0x1c,%esp
  80202e:	5b                   	pop    %ebx
  80202f:	5e                   	pop    %esi
  802030:	5f                   	pop    %edi
  802031:	5d                   	pop    %ebp
  802032:	c3                   	ret    
  802033:	90                   	nop
  802034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802038:	85 ff                	test   %edi,%edi
  80203a:	89 f9                	mov    %edi,%ecx
  80203c:	75 0b                	jne    802049 <__umoddi3+0xe9>
  80203e:	b8 01 00 00 00       	mov    $0x1,%eax
  802043:	31 d2                	xor    %edx,%edx
  802045:	f7 f7                	div    %edi
  802047:	89 c1                	mov    %eax,%ecx
  802049:	89 d8                	mov    %ebx,%eax
  80204b:	31 d2                	xor    %edx,%edx
  80204d:	f7 f1                	div    %ecx
  80204f:	89 f0                	mov    %esi,%eax
  802051:	f7 f1                	div    %ecx
  802053:	e9 31 ff ff ff       	jmp    801f89 <__umoddi3+0x29>
  802058:	90                   	nop
  802059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802060:	39 dd                	cmp    %ebx,%ebp
  802062:	72 08                	jb     80206c <__umoddi3+0x10c>
  802064:	39 f7                	cmp    %esi,%edi
  802066:	0f 87 21 ff ff ff    	ja     801f8d <__umoddi3+0x2d>
  80206c:	89 da                	mov    %ebx,%edx
  80206e:	89 f0                	mov    %esi,%eax
  802070:	29 f8                	sub    %edi,%eax
  802072:	19 ea                	sbb    %ebp,%edx
  802074:	e9 14 ff ff ff       	jmp    801f8d <__umoddi3+0x2d>
