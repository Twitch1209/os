
obj/user/stresssched.debug：     文件格式 elf32-i386


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
  80002c:	e8 b7 00 00 00       	call   8000e8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 8b 0b 00 00       	call   800bc8 <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 c5 0d 00 00       	call   800e0e <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 8d 0b 00 00       	call   800be7 <sys_yield>
		return;
  80005a:	eb 6e                	jmp    8000ca <umain+0x97>
	if (i == 20) {
  80005c:	83 fb 14             	cmp    $0x14,%ebx
  80005f:	74 f4                	je     800055 <umain+0x22>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800061:	89 f0                	mov    %esi,%eax
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	eb 02                	jmp    800074 <umain+0x41>
		asm volatile("pause");
  800072:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800074:	8b 50 54             	mov    0x54(%eax),%edx
  800077:	85 d2                	test   %edx,%edx
  800079:	75 f7                	jne    800072 <umain+0x3f>
  80007b:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  800080:	e8 62 0b 00 00       	call   800be7 <sys_yield>
  800085:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  80008a:	a1 04 40 80 00       	mov    0x804004,%eax
  80008f:	83 c0 01             	add    $0x1,%eax
  800092:	a3 04 40 80 00       	mov    %eax,0x804004
		for (j = 0; j < 10000; j++)
  800097:	83 ea 01             	sub    $0x1,%edx
  80009a:	75 ee                	jne    80008a <umain+0x57>
	for (i = 0; i < 10; i++) {
  80009c:	83 eb 01             	sub    $0x1,%ebx
  80009f:	75 df                	jne    800080 <umain+0x4d>
	}

	if (counter != 10*10000)
  8000a1:	a1 04 40 80 00       	mov    0x804004,%eax
  8000a6:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000ab:	75 24                	jne    8000d1 <umain+0x9e>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ad:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b2:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b5:	8b 40 48             	mov    0x48(%eax),%eax
  8000b8:	83 ec 04             	sub    $0x4,%esp
  8000bb:	52                   	push   %edx
  8000bc:	50                   	push   %eax
  8000bd:	68 bb 20 80 00       	push   $0x8020bb
  8000c2:	e8 5c 01 00 00       	call   800223 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp

}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d1:	a1 04 40 80 00       	mov    0x804004,%eax
  8000d6:	50                   	push   %eax
  8000d7:	68 80 20 80 00       	push   $0x802080
  8000dc:	6a 21                	push   $0x21
  8000de:	68 a8 20 80 00       	push   $0x8020a8
  8000e3:	e8 60 00 00 00       	call   800148 <_panic>

008000e8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e8:	55                   	push   %ebp
  8000e9:	89 e5                	mov    %esp,%ebp
  8000eb:	56                   	push   %esi
  8000ec:	53                   	push   %ebx
  8000ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f3:	e8 d0 0a 00 00       	call   800bc8 <sys_getenvid>
  8000f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800100:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800105:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010a:	85 db                	test   %ebx,%ebx
  80010c:	7e 07                	jle    800115 <libmain+0x2d>
		binaryname = argv[0];
  80010e:	8b 06                	mov    (%esi),%eax
  800110:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
  80011a:	e8 14 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011f:	e8 0a 00 00 00       	call   80012e <exit>
}
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5d                   	pop    %ebp
  80012d:	c3                   	ret    

0080012e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800134:	e8 cd 10 00 00       	call   801206 <close_all>
	sys_env_destroy(0);
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 00                	push   $0x0
  80013e:	e8 44 0a 00 00       	call   800b87 <sys_env_destroy>
}
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	c9                   	leave  
  800147:	c3                   	ret    

00800148 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	56                   	push   %esi
  80014c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80014d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800150:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800156:	e8 6d 0a 00 00       	call   800bc8 <sys_getenvid>
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	ff 75 0c             	pushl  0xc(%ebp)
  800161:	ff 75 08             	pushl  0x8(%ebp)
  800164:	56                   	push   %esi
  800165:	50                   	push   %eax
  800166:	68 e4 20 80 00       	push   $0x8020e4
  80016b:	e8 b3 00 00 00       	call   800223 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800170:	83 c4 18             	add    $0x18,%esp
  800173:	53                   	push   %ebx
  800174:	ff 75 10             	pushl  0x10(%ebp)
  800177:	e8 56 00 00 00       	call   8001d2 <vcprintf>
	cprintf("\n");
  80017c:	c7 04 24 d7 20 80 00 	movl   $0x8020d7,(%esp)
  800183:	e8 9b 00 00 00       	call   800223 <cprintf>
  800188:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80018b:	cc                   	int3   
  80018c:	eb fd                	jmp    80018b <_panic+0x43>

0080018e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	53                   	push   %ebx
  800192:	83 ec 04             	sub    $0x4,%esp
  800195:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800198:	8b 13                	mov    (%ebx),%edx
  80019a:	8d 42 01             	lea    0x1(%edx),%eax
  80019d:	89 03                	mov    %eax,(%ebx)
  80019f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ab:	74 09                	je     8001b6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ad:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	68 ff 00 00 00       	push   $0xff
  8001be:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c1:	50                   	push   %eax
  8001c2:	e8 83 09 00 00       	call   800b4a <sys_cputs>
		b->idx = 0;
  8001c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001cd:	83 c4 10             	add    $0x10,%esp
  8001d0:	eb db                	jmp    8001ad <putch+0x1f>

008001d2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e2:	00 00 00 
	b.cnt = 0;
  8001e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ef:	ff 75 0c             	pushl  0xc(%ebp)
  8001f2:	ff 75 08             	pushl  0x8(%ebp)
  8001f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001fb:	50                   	push   %eax
  8001fc:	68 8e 01 80 00       	push   $0x80018e
  800201:	e8 1a 01 00 00       	call   800320 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800206:	83 c4 08             	add    $0x8,%esp
  800209:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80020f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800215:	50                   	push   %eax
  800216:	e8 2f 09 00 00       	call   800b4a <sys_cputs>

	return b.cnt;
}
  80021b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800221:	c9                   	leave  
  800222:	c3                   	ret    

00800223 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800229:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80022c:	50                   	push   %eax
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 9d ff ff ff       	call   8001d2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	57                   	push   %edi
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 1c             	sub    $0x1c,%esp
  800240:	89 c7                	mov    %eax,%edi
  800242:	89 d6                	mov    %edx,%esi
  800244:	8b 45 08             	mov    0x8(%ebp),%eax
  800247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80024d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800250:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800253:	bb 00 00 00 00       	mov    $0x0,%ebx
  800258:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80025b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80025e:	39 d3                	cmp    %edx,%ebx
  800260:	72 05                	jb     800267 <printnum+0x30>
  800262:	39 45 10             	cmp    %eax,0x10(%ebp)
  800265:	77 7a                	ja     8002e1 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	ff 75 18             	pushl  0x18(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800273:	53                   	push   %ebx
  800274:	ff 75 10             	pushl  0x10(%ebp)
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027d:	ff 75 e0             	pushl  -0x20(%ebp)
  800280:	ff 75 dc             	pushl  -0x24(%ebp)
  800283:	ff 75 d8             	pushl  -0x28(%ebp)
  800286:	e8 a5 1b 00 00       	call   801e30 <__udivdi3>
  80028b:	83 c4 18             	add    $0x18,%esp
  80028e:	52                   	push   %edx
  80028f:	50                   	push   %eax
  800290:	89 f2                	mov    %esi,%edx
  800292:	89 f8                	mov    %edi,%eax
  800294:	e8 9e ff ff ff       	call   800237 <printnum>
  800299:	83 c4 20             	add    $0x20,%esp
  80029c:	eb 13                	jmp    8002b1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80029e:	83 ec 08             	sub    $0x8,%esp
  8002a1:	56                   	push   %esi
  8002a2:	ff 75 18             	pushl  0x18(%ebp)
  8002a5:	ff d7                	call   *%edi
  8002a7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002aa:	83 eb 01             	sub    $0x1,%ebx
  8002ad:	85 db                	test   %ebx,%ebx
  8002af:	7f ed                	jg     80029e <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	56                   	push   %esi
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8002be:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c4:	e8 87 1c 00 00       	call   801f50 <__umoddi3>
  8002c9:	83 c4 14             	add    $0x14,%esp
  8002cc:	0f be 80 07 21 80 00 	movsbl 0x802107(%eax),%eax
  8002d3:	50                   	push   %eax
  8002d4:	ff d7                	call   *%edi
}
  8002d6:	83 c4 10             	add    $0x10,%esp
  8002d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002dc:	5b                   	pop    %ebx
  8002dd:	5e                   	pop    %esi
  8002de:	5f                   	pop    %edi
  8002df:	5d                   	pop    %ebp
  8002e0:	c3                   	ret    
  8002e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002e4:	eb c4                	jmp    8002aa <printnum+0x73>

008002e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ec:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f0:	8b 10                	mov    (%eax),%edx
  8002f2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f5:	73 0a                	jae    800301 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fa:	89 08                	mov    %ecx,(%eax)
  8002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ff:	88 02                	mov    %al,(%edx)
}
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <printfmt>:
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800309:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030c:	50                   	push   %eax
  80030d:	ff 75 10             	pushl  0x10(%ebp)
  800310:	ff 75 0c             	pushl  0xc(%ebp)
  800313:	ff 75 08             	pushl  0x8(%ebp)
  800316:	e8 05 00 00 00       	call   800320 <vprintfmt>
}
  80031b:	83 c4 10             	add    $0x10,%esp
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <vprintfmt>:
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 2c             	sub    $0x2c,%esp
  800329:	8b 75 08             	mov    0x8(%ebp),%esi
  80032c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800332:	e9 8c 03 00 00       	jmp    8006c3 <vprintfmt+0x3a3>
		padc = ' ';
  800337:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80033b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800342:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800349:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800350:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800355:	8d 47 01             	lea    0x1(%edi),%eax
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035b:	0f b6 17             	movzbl (%edi),%edx
  80035e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800361:	3c 55                	cmp    $0x55,%al
  800363:	0f 87 dd 03 00 00    	ja     800746 <vprintfmt+0x426>
  800369:	0f b6 c0             	movzbl %al,%eax
  80036c:	ff 24 85 40 22 80 00 	jmp    *0x802240(,%eax,4)
  800373:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800376:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80037a:	eb d9                	jmp    800355 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80037f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800383:	eb d0                	jmp    800355 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800385:	0f b6 d2             	movzbl %dl,%edx
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80038b:	b8 00 00 00 00       	mov    $0x0,%eax
  800390:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800393:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800396:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80039a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80039d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a0:	83 f9 09             	cmp    $0x9,%ecx
  8003a3:	77 55                	ja     8003fa <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003a5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a8:	eb e9                	jmp    800393 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	8d 40 04             	lea    0x4(%eax),%eax
  8003b8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c2:	79 91                	jns    800355 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ca:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003d1:	eb 82                	jmp    800355 <vprintfmt+0x35>
  8003d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d6:	85 c0                	test   %eax,%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	0f 49 d0             	cmovns %eax,%edx
  8003e0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e6:	e9 6a ff ff ff       	jmp    800355 <vprintfmt+0x35>
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ee:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003f5:	e9 5b ff ff ff       	jmp    800355 <vprintfmt+0x35>
  8003fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800400:	eb bc                	jmp    8003be <vprintfmt+0x9e>
			lflag++;
  800402:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800405:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800408:	e9 48 ff ff ff       	jmp    800355 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	8d 78 04             	lea    0x4(%eax),%edi
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	53                   	push   %ebx
  800417:	ff 30                	pushl  (%eax)
  800419:	ff d6                	call   *%esi
			break;
  80041b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80041e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800421:	e9 9a 02 00 00       	jmp    8006c0 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800426:	8b 45 14             	mov    0x14(%ebp),%eax
  800429:	8d 78 04             	lea    0x4(%eax),%edi
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	99                   	cltd   
  80042f:	31 d0                	xor    %edx,%eax
  800431:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800433:	83 f8 0f             	cmp    $0xf,%eax
  800436:	7f 23                	jg     80045b <vprintfmt+0x13b>
  800438:	8b 14 85 a0 23 80 00 	mov    0x8023a0(,%eax,4),%edx
  80043f:	85 d2                	test   %edx,%edx
  800441:	74 18                	je     80045b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800443:	52                   	push   %edx
  800444:	68 95 25 80 00       	push   $0x802595
  800449:	53                   	push   %ebx
  80044a:	56                   	push   %esi
  80044b:	e8 b3 fe ff ff       	call   800303 <printfmt>
  800450:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800453:	89 7d 14             	mov    %edi,0x14(%ebp)
  800456:	e9 65 02 00 00       	jmp    8006c0 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  80045b:	50                   	push   %eax
  80045c:	68 1f 21 80 00       	push   $0x80211f
  800461:	53                   	push   %ebx
  800462:	56                   	push   %esi
  800463:	e8 9b fe ff ff       	call   800303 <printfmt>
  800468:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80046e:	e9 4d 02 00 00       	jmp    8006c0 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	83 c0 04             	add    $0x4,%eax
  800479:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800481:	85 ff                	test   %edi,%edi
  800483:	b8 18 21 80 00       	mov    $0x802118,%eax
  800488:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80048b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048f:	0f 8e bd 00 00 00    	jle    800552 <vprintfmt+0x232>
  800495:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800499:	75 0e                	jne    8004a9 <vprintfmt+0x189>
  80049b:	89 75 08             	mov    %esi,0x8(%ebp)
  80049e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004a1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004a4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004a7:	eb 6d                	jmp    800516 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	ff 75 d0             	pushl  -0x30(%ebp)
  8004af:	57                   	push   %edi
  8004b0:	e8 39 03 00 00       	call   8007ee <strnlen>
  8004b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b8:	29 c1                	sub    %eax,%ecx
  8004ba:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004bd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004c0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004ca:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cc:	eb 0f                	jmp    8004dd <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d7:	83 ef 01             	sub    $0x1,%edi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	85 ff                	test   %edi,%edi
  8004df:	7f ed                	jg     8004ce <vprintfmt+0x1ae>
  8004e1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004e4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004e7:	85 c9                	test   %ecx,%ecx
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	0f 49 c1             	cmovns %ecx,%eax
  8004f1:	29 c1                	sub    %eax,%ecx
  8004f3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004fc:	89 cb                	mov    %ecx,%ebx
  8004fe:	eb 16                	jmp    800516 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800500:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800504:	75 31                	jne    800537 <vprintfmt+0x217>
					putch(ch, putdat);
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	50                   	push   %eax
  80050d:	ff 55 08             	call   *0x8(%ebp)
  800510:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800513:	83 eb 01             	sub    $0x1,%ebx
  800516:	83 c7 01             	add    $0x1,%edi
  800519:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80051d:	0f be c2             	movsbl %dl,%eax
  800520:	85 c0                	test   %eax,%eax
  800522:	74 59                	je     80057d <vprintfmt+0x25d>
  800524:	85 f6                	test   %esi,%esi
  800526:	78 d8                	js     800500 <vprintfmt+0x1e0>
  800528:	83 ee 01             	sub    $0x1,%esi
  80052b:	79 d3                	jns    800500 <vprintfmt+0x1e0>
  80052d:	89 df                	mov    %ebx,%edi
  80052f:	8b 75 08             	mov    0x8(%ebp),%esi
  800532:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800535:	eb 37                	jmp    80056e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800537:	0f be d2             	movsbl %dl,%edx
  80053a:	83 ea 20             	sub    $0x20,%edx
  80053d:	83 fa 5e             	cmp    $0x5e,%edx
  800540:	76 c4                	jbe    800506 <vprintfmt+0x1e6>
					putch('?', putdat);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	ff 75 0c             	pushl  0xc(%ebp)
  800548:	6a 3f                	push   $0x3f
  80054a:	ff 55 08             	call   *0x8(%ebp)
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	eb c1                	jmp    800513 <vprintfmt+0x1f3>
  800552:	89 75 08             	mov    %esi,0x8(%ebp)
  800555:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800558:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80055b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80055e:	eb b6                	jmp    800516 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	53                   	push   %ebx
  800564:	6a 20                	push   $0x20
  800566:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800568:	83 ef 01             	sub    $0x1,%edi
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	85 ff                	test   %edi,%edi
  800570:	7f ee                	jg     800560 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800572:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
  800578:	e9 43 01 00 00       	jmp    8006c0 <vprintfmt+0x3a0>
  80057d:	89 df                	mov    %ebx,%edi
  80057f:	8b 75 08             	mov    0x8(%ebp),%esi
  800582:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800585:	eb e7                	jmp    80056e <vprintfmt+0x24e>
	if (lflag >= 2)
  800587:	83 f9 01             	cmp    $0x1,%ecx
  80058a:	7e 3f                	jle    8005cb <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8b 50 04             	mov    0x4(%eax),%edx
  800592:	8b 00                	mov    (%eax),%eax
  800594:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800597:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8d 40 08             	lea    0x8(%eax),%eax
  8005a0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005a7:	79 5c                	jns    800605 <vprintfmt+0x2e5>
				putch('-', putdat);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	53                   	push   %ebx
  8005ad:	6a 2d                	push   $0x2d
  8005af:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005b7:	f7 da                	neg    %edx
  8005b9:	83 d1 00             	adc    $0x0,%ecx
  8005bc:	f7 d9                	neg    %ecx
  8005be:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c6:	e9 db 00 00 00       	jmp    8006a6 <vprintfmt+0x386>
	else if (lflag)
  8005cb:	85 c9                	test   %ecx,%ecx
  8005cd:	75 1b                	jne    8005ea <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d7:	89 c1                	mov    %eax,%ecx
  8005d9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005dc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	eb b9                	jmp    8005a3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f2:	89 c1                	mov    %eax,%ecx
  8005f4:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8d 40 04             	lea    0x4(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
  800603:	eb 9e                	jmp    8005a3 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800605:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800608:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80060b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800610:	e9 91 00 00 00       	jmp    8006a6 <vprintfmt+0x386>
	if (lflag >= 2)
  800615:	83 f9 01             	cmp    $0x1,%ecx
  800618:	7e 15                	jle    80062f <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 10                	mov    (%eax),%edx
  80061f:	8b 48 04             	mov    0x4(%eax),%ecx
  800622:	8d 40 08             	lea    0x8(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800628:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062d:	eb 77                	jmp    8006a6 <vprintfmt+0x386>
	else if (lflag)
  80062f:	85 c9                	test   %ecx,%ecx
  800631:	75 17                	jne    80064a <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8b 10                	mov    (%eax),%edx
  800638:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063d:	8d 40 04             	lea    0x4(%eax),%eax
  800640:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800643:	b8 0a 00 00 00       	mov    $0xa,%eax
  800648:	eb 5c                	jmp    8006a6 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8b 10                	mov    (%eax),%edx
  80064f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800654:	8d 40 04             	lea    0x4(%eax),%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065f:	eb 45                	jmp    8006a6 <vprintfmt+0x386>
			putch('X', putdat);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	53                   	push   %ebx
  800665:	6a 58                	push   $0x58
  800667:	ff d6                	call   *%esi
			putch('X', putdat);
  800669:	83 c4 08             	add    $0x8,%esp
  80066c:	53                   	push   %ebx
  80066d:	6a 58                	push   $0x58
  80066f:	ff d6                	call   *%esi
			putch('X', putdat);
  800671:	83 c4 08             	add    $0x8,%esp
  800674:	53                   	push   %ebx
  800675:	6a 58                	push   $0x58
  800677:	ff d6                	call   *%esi
			break;
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	eb 42                	jmp    8006c0 <vprintfmt+0x3a0>
			putch('0', putdat);
  80067e:	83 ec 08             	sub    $0x8,%esp
  800681:	53                   	push   %ebx
  800682:	6a 30                	push   $0x30
  800684:	ff d6                	call   *%esi
			putch('x', putdat);
  800686:	83 c4 08             	add    $0x8,%esp
  800689:	53                   	push   %ebx
  80068a:	6a 78                	push   $0x78
  80068c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8b 10                	mov    (%eax),%edx
  800693:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800698:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80069b:	8d 40 04             	lea    0x4(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a6:	83 ec 0c             	sub    $0xc,%esp
  8006a9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006ad:	57                   	push   %edi
  8006ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b1:	50                   	push   %eax
  8006b2:	51                   	push   %ecx
  8006b3:	52                   	push   %edx
  8006b4:	89 da                	mov    %ebx,%edx
  8006b6:	89 f0                	mov    %esi,%eax
  8006b8:	e8 7a fb ff ff       	call   800237 <printnum>
			break;
  8006bd:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c3:	83 c7 01             	add    $0x1,%edi
  8006c6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ca:	83 f8 25             	cmp    $0x25,%eax
  8006cd:	0f 84 64 fc ff ff    	je     800337 <vprintfmt+0x17>
			if (ch == '\0')
  8006d3:	85 c0                	test   %eax,%eax
  8006d5:	0f 84 8b 00 00 00    	je     800766 <vprintfmt+0x446>
			putch(ch, putdat);
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	53                   	push   %ebx
  8006df:	50                   	push   %eax
  8006e0:	ff d6                	call   *%esi
  8006e2:	83 c4 10             	add    $0x10,%esp
  8006e5:	eb dc                	jmp    8006c3 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8006e7:	83 f9 01             	cmp    $0x1,%ecx
  8006ea:	7e 15                	jle    800701 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	8b 10                	mov    (%eax),%edx
  8006f1:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f4:	8d 40 08             	lea    0x8(%eax),%eax
  8006f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fa:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ff:	eb a5                	jmp    8006a6 <vprintfmt+0x386>
	else if (lflag)
  800701:	85 c9                	test   %ecx,%ecx
  800703:	75 17                	jne    80071c <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8b 10                	mov    (%eax),%edx
  80070a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80070f:	8d 40 04             	lea    0x4(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800715:	b8 10 00 00 00       	mov    $0x10,%eax
  80071a:	eb 8a                	jmp    8006a6 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 10                	mov    (%eax),%edx
  800721:	b9 00 00 00 00       	mov    $0x0,%ecx
  800726:	8d 40 04             	lea    0x4(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072c:	b8 10 00 00 00       	mov    $0x10,%eax
  800731:	e9 70 ff ff ff       	jmp    8006a6 <vprintfmt+0x386>
			putch(ch, putdat);
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	53                   	push   %ebx
  80073a:	6a 25                	push   $0x25
  80073c:	ff d6                	call   *%esi
			break;
  80073e:	83 c4 10             	add    $0x10,%esp
  800741:	e9 7a ff ff ff       	jmp    8006c0 <vprintfmt+0x3a0>
			putch('%', putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	53                   	push   %ebx
  80074a:	6a 25                	push   $0x25
  80074c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	89 f8                	mov    %edi,%eax
  800753:	eb 03                	jmp    800758 <vprintfmt+0x438>
  800755:	83 e8 01             	sub    $0x1,%eax
  800758:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80075c:	75 f7                	jne    800755 <vprintfmt+0x435>
  80075e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800761:	e9 5a ff ff ff       	jmp    8006c0 <vprintfmt+0x3a0>
}
  800766:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800769:	5b                   	pop    %ebx
  80076a:	5e                   	pop    %esi
  80076b:	5f                   	pop    %edi
  80076c:	5d                   	pop    %ebp
  80076d:	c3                   	ret    

0080076e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80076e:	55                   	push   %ebp
  80076f:	89 e5                	mov    %esp,%ebp
  800771:	83 ec 18             	sub    $0x18,%esp
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80077a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80077d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800781:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800784:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80078b:	85 c0                	test   %eax,%eax
  80078d:	74 26                	je     8007b5 <vsnprintf+0x47>
  80078f:	85 d2                	test   %edx,%edx
  800791:	7e 22                	jle    8007b5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800793:	ff 75 14             	pushl  0x14(%ebp)
  800796:	ff 75 10             	pushl  0x10(%ebp)
  800799:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80079c:	50                   	push   %eax
  80079d:	68 e6 02 80 00       	push   $0x8002e6
  8007a2:	e8 79 fb ff ff       	call   800320 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007aa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b0:	83 c4 10             	add    $0x10,%esp
}
  8007b3:	c9                   	leave  
  8007b4:	c3                   	ret    
		return -E_INVAL;
  8007b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ba:	eb f7                	jmp    8007b3 <vsnprintf+0x45>

008007bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c5:	50                   	push   %eax
  8007c6:	ff 75 10             	pushl  0x10(%ebp)
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	ff 75 08             	pushl  0x8(%ebp)
  8007cf:	e8 9a ff ff ff       	call   80076e <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d4:	c9                   	leave  
  8007d5:	c3                   	ret    

008007d6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e1:	eb 03                	jmp    8007e6 <strlen+0x10>
		n++;
  8007e3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007e6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007ea:	75 f7                	jne    8007e3 <strlen+0xd>
	return n;
}
  8007ec:	5d                   	pop    %ebp
  8007ed:	c3                   	ret    

008007ee <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
  8007f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f4:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fc:	eb 03                	jmp    800801 <strnlen+0x13>
		n++;
  8007fe:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800801:	39 d0                	cmp    %edx,%eax
  800803:	74 06                	je     80080b <strnlen+0x1d>
  800805:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800809:	75 f3                	jne    8007fe <strnlen+0x10>
	return n;
}
  80080b:	5d                   	pop    %ebp
  80080c:	c3                   	ret    

0080080d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	53                   	push   %ebx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800817:	89 c2                	mov    %eax,%edx
  800819:	83 c1 01             	add    $0x1,%ecx
  80081c:	83 c2 01             	add    $0x1,%edx
  80081f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800823:	88 5a ff             	mov    %bl,-0x1(%edx)
  800826:	84 db                	test   %bl,%bl
  800828:	75 ef                	jne    800819 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80082a:	5b                   	pop    %ebx
  80082b:	5d                   	pop    %ebp
  80082c:	c3                   	ret    

0080082d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	53                   	push   %ebx
  800831:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800834:	53                   	push   %ebx
  800835:	e8 9c ff ff ff       	call   8007d6 <strlen>
  80083a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80083d:	ff 75 0c             	pushl  0xc(%ebp)
  800840:	01 d8                	add    %ebx,%eax
  800842:	50                   	push   %eax
  800843:	e8 c5 ff ff ff       	call   80080d <strcpy>
	return dst;
}
  800848:	89 d8                	mov    %ebx,%eax
  80084a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084d:	c9                   	leave  
  80084e:	c3                   	ret    

0080084f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	56                   	push   %esi
  800853:	53                   	push   %ebx
  800854:	8b 75 08             	mov    0x8(%ebp),%esi
  800857:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085a:	89 f3                	mov    %esi,%ebx
  80085c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80085f:	89 f2                	mov    %esi,%edx
  800861:	eb 0f                	jmp    800872 <strncpy+0x23>
		*dst++ = *src;
  800863:	83 c2 01             	add    $0x1,%edx
  800866:	0f b6 01             	movzbl (%ecx),%eax
  800869:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80086c:	80 39 01             	cmpb   $0x1,(%ecx)
  80086f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800872:	39 da                	cmp    %ebx,%edx
  800874:	75 ed                	jne    800863 <strncpy+0x14>
	}
	return ret;
}
  800876:	89 f0                	mov    %esi,%eax
  800878:	5b                   	pop    %ebx
  800879:	5e                   	pop    %esi
  80087a:	5d                   	pop    %ebp
  80087b:	c3                   	ret    

0080087c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	56                   	push   %esi
  800880:	53                   	push   %ebx
  800881:	8b 75 08             	mov    0x8(%ebp),%esi
  800884:	8b 55 0c             	mov    0xc(%ebp),%edx
  800887:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80088a:	89 f0                	mov    %esi,%eax
  80088c:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800890:	85 c9                	test   %ecx,%ecx
  800892:	75 0b                	jne    80089f <strlcpy+0x23>
  800894:	eb 17                	jmp    8008ad <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800896:	83 c2 01             	add    $0x1,%edx
  800899:	83 c0 01             	add    $0x1,%eax
  80089c:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80089f:	39 d8                	cmp    %ebx,%eax
  8008a1:	74 07                	je     8008aa <strlcpy+0x2e>
  8008a3:	0f b6 0a             	movzbl (%edx),%ecx
  8008a6:	84 c9                	test   %cl,%cl
  8008a8:	75 ec                	jne    800896 <strlcpy+0x1a>
		*dst = '\0';
  8008aa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ad:	29 f0                	sub    %esi,%eax
}
  8008af:	5b                   	pop    %ebx
  8008b0:	5e                   	pop    %esi
  8008b1:	5d                   	pop    %ebp
  8008b2:	c3                   	ret    

008008b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008bc:	eb 06                	jmp    8008c4 <strcmp+0x11>
		p++, q++;
  8008be:	83 c1 01             	add    $0x1,%ecx
  8008c1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008c4:	0f b6 01             	movzbl (%ecx),%eax
  8008c7:	84 c0                	test   %al,%al
  8008c9:	74 04                	je     8008cf <strcmp+0x1c>
  8008cb:	3a 02                	cmp    (%edx),%al
  8008cd:	74 ef                	je     8008be <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008cf:	0f b6 c0             	movzbl %al,%eax
  8008d2:	0f b6 12             	movzbl (%edx),%edx
  8008d5:	29 d0                	sub    %edx,%eax
}
  8008d7:	5d                   	pop    %ebp
  8008d8:	c3                   	ret    

008008d9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	53                   	push   %ebx
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e3:	89 c3                	mov    %eax,%ebx
  8008e5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008e8:	eb 06                	jmp    8008f0 <strncmp+0x17>
		n--, p++, q++;
  8008ea:	83 c0 01             	add    $0x1,%eax
  8008ed:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008f0:	39 d8                	cmp    %ebx,%eax
  8008f2:	74 16                	je     80090a <strncmp+0x31>
  8008f4:	0f b6 08             	movzbl (%eax),%ecx
  8008f7:	84 c9                	test   %cl,%cl
  8008f9:	74 04                	je     8008ff <strncmp+0x26>
  8008fb:	3a 0a                	cmp    (%edx),%cl
  8008fd:	74 eb                	je     8008ea <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ff:	0f b6 00             	movzbl (%eax),%eax
  800902:	0f b6 12             	movzbl (%edx),%edx
  800905:	29 d0                	sub    %edx,%eax
}
  800907:	5b                   	pop    %ebx
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    
		return 0;
  80090a:	b8 00 00 00 00       	mov    $0x0,%eax
  80090f:	eb f6                	jmp    800907 <strncmp+0x2e>

00800911 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80091b:	0f b6 10             	movzbl (%eax),%edx
  80091e:	84 d2                	test   %dl,%dl
  800920:	74 09                	je     80092b <strchr+0x1a>
		if (*s == c)
  800922:	38 ca                	cmp    %cl,%dl
  800924:	74 0a                	je     800930 <strchr+0x1f>
	for (; *s; s++)
  800926:	83 c0 01             	add    $0x1,%eax
  800929:	eb f0                	jmp    80091b <strchr+0xa>
			return (char *) s;
	return 0;
  80092b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80093c:	eb 03                	jmp    800941 <strfind+0xf>
  80093e:	83 c0 01             	add    $0x1,%eax
  800941:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800944:	38 ca                	cmp    %cl,%dl
  800946:	74 04                	je     80094c <strfind+0x1a>
  800948:	84 d2                	test   %dl,%dl
  80094a:	75 f2                	jne    80093e <strfind+0xc>
			break;
	return (char *) s;
}
  80094c:	5d                   	pop    %ebp
  80094d:	c3                   	ret    

0080094e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	57                   	push   %edi
  800952:	56                   	push   %esi
  800953:	53                   	push   %ebx
  800954:	8b 7d 08             	mov    0x8(%ebp),%edi
  800957:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80095a:	85 c9                	test   %ecx,%ecx
  80095c:	74 13                	je     800971 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80095e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800964:	75 05                	jne    80096b <memset+0x1d>
  800966:	f6 c1 03             	test   $0x3,%cl
  800969:	74 0d                	je     800978 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80096b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096e:	fc                   	cld    
  80096f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800971:	89 f8                	mov    %edi,%eax
  800973:	5b                   	pop    %ebx
  800974:	5e                   	pop    %esi
  800975:	5f                   	pop    %edi
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    
		c &= 0xFF;
  800978:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80097c:	89 d3                	mov    %edx,%ebx
  80097e:	c1 e3 08             	shl    $0x8,%ebx
  800981:	89 d0                	mov    %edx,%eax
  800983:	c1 e0 18             	shl    $0x18,%eax
  800986:	89 d6                	mov    %edx,%esi
  800988:	c1 e6 10             	shl    $0x10,%esi
  80098b:	09 f0                	or     %esi,%eax
  80098d:	09 c2                	or     %eax,%edx
  80098f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800991:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800994:	89 d0                	mov    %edx,%eax
  800996:	fc                   	cld    
  800997:	f3 ab                	rep stos %eax,%es:(%edi)
  800999:	eb d6                	jmp    800971 <memset+0x23>

0080099b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	57                   	push   %edi
  80099f:	56                   	push   %esi
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009a9:	39 c6                	cmp    %eax,%esi
  8009ab:	73 35                	jae    8009e2 <memmove+0x47>
  8009ad:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009b0:	39 c2                	cmp    %eax,%edx
  8009b2:	76 2e                	jbe    8009e2 <memmove+0x47>
		s += n;
		d += n;
  8009b4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b7:	89 d6                	mov    %edx,%esi
  8009b9:	09 fe                	or     %edi,%esi
  8009bb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009c1:	74 0c                	je     8009cf <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009c3:	83 ef 01             	sub    $0x1,%edi
  8009c6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009c9:	fd                   	std    
  8009ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009cc:	fc                   	cld    
  8009cd:	eb 21                	jmp    8009f0 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009cf:	f6 c1 03             	test   $0x3,%cl
  8009d2:	75 ef                	jne    8009c3 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d4:	83 ef 04             	sub    $0x4,%edi
  8009d7:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009da:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009dd:	fd                   	std    
  8009de:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e0:	eb ea                	jmp    8009cc <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e2:	89 f2                	mov    %esi,%edx
  8009e4:	09 c2                	or     %eax,%edx
  8009e6:	f6 c2 03             	test   $0x3,%dl
  8009e9:	74 09                	je     8009f4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009eb:	89 c7                	mov    %eax,%edi
  8009ed:	fc                   	cld    
  8009ee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f0:	5e                   	pop    %esi
  8009f1:	5f                   	pop    %edi
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f4:	f6 c1 03             	test   $0x3,%cl
  8009f7:	75 f2                	jne    8009eb <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009f9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009fc:	89 c7                	mov    %eax,%edi
  8009fe:	fc                   	cld    
  8009ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a01:	eb ed                	jmp    8009f0 <memmove+0x55>

00800a03 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a06:	ff 75 10             	pushl  0x10(%ebp)
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	ff 75 08             	pushl  0x8(%ebp)
  800a0f:	e8 87 ff ff ff       	call   80099b <memmove>
}
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    

00800a16 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	56                   	push   %esi
  800a1a:	53                   	push   %ebx
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a21:	89 c6                	mov    %eax,%esi
  800a23:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a26:	39 f0                	cmp    %esi,%eax
  800a28:	74 1c                	je     800a46 <memcmp+0x30>
		if (*s1 != *s2)
  800a2a:	0f b6 08             	movzbl (%eax),%ecx
  800a2d:	0f b6 1a             	movzbl (%edx),%ebx
  800a30:	38 d9                	cmp    %bl,%cl
  800a32:	75 08                	jne    800a3c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a34:	83 c0 01             	add    $0x1,%eax
  800a37:	83 c2 01             	add    $0x1,%edx
  800a3a:	eb ea                	jmp    800a26 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a3c:	0f b6 c1             	movzbl %cl,%eax
  800a3f:	0f b6 db             	movzbl %bl,%ebx
  800a42:	29 d8                	sub    %ebx,%eax
  800a44:	eb 05                	jmp    800a4b <memcmp+0x35>
	}

	return 0;
  800a46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4b:	5b                   	pop    %ebx
  800a4c:	5e                   	pop    %esi
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a58:	89 c2                	mov    %eax,%edx
  800a5a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a5d:	39 d0                	cmp    %edx,%eax
  800a5f:	73 09                	jae    800a6a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a61:	38 08                	cmp    %cl,(%eax)
  800a63:	74 05                	je     800a6a <memfind+0x1b>
	for (; s < ends; s++)
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	eb f3                	jmp    800a5d <memfind+0xe>
			break;
	return (void *) s;
}
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	57                   	push   %edi
  800a70:	56                   	push   %esi
  800a71:	53                   	push   %ebx
  800a72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a75:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a78:	eb 03                	jmp    800a7d <strtol+0x11>
		s++;
  800a7a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a7d:	0f b6 01             	movzbl (%ecx),%eax
  800a80:	3c 20                	cmp    $0x20,%al
  800a82:	74 f6                	je     800a7a <strtol+0xe>
  800a84:	3c 09                	cmp    $0x9,%al
  800a86:	74 f2                	je     800a7a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a88:	3c 2b                	cmp    $0x2b,%al
  800a8a:	74 2e                	je     800aba <strtol+0x4e>
	int neg = 0;
  800a8c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a91:	3c 2d                	cmp    $0x2d,%al
  800a93:	74 2f                	je     800ac4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a95:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a9b:	75 05                	jne    800aa2 <strtol+0x36>
  800a9d:	80 39 30             	cmpb   $0x30,(%ecx)
  800aa0:	74 2c                	je     800ace <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa2:	85 db                	test   %ebx,%ebx
  800aa4:	75 0a                	jne    800ab0 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800aab:	80 39 30             	cmpb   $0x30,(%ecx)
  800aae:	74 28                	je     800ad8 <strtol+0x6c>
		base = 10;
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ab8:	eb 50                	jmp    800b0a <strtol+0x9e>
		s++;
  800aba:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800abd:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac2:	eb d1                	jmp    800a95 <strtol+0x29>
		s++, neg = 1;
  800ac4:	83 c1 01             	add    $0x1,%ecx
  800ac7:	bf 01 00 00 00       	mov    $0x1,%edi
  800acc:	eb c7                	jmp    800a95 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ace:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ad2:	74 0e                	je     800ae2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ad4:	85 db                	test   %ebx,%ebx
  800ad6:	75 d8                	jne    800ab0 <strtol+0x44>
		s++, base = 8;
  800ad8:	83 c1 01             	add    $0x1,%ecx
  800adb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ae0:	eb ce                	jmp    800ab0 <strtol+0x44>
		s += 2, base = 16;
  800ae2:	83 c1 02             	add    $0x2,%ecx
  800ae5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aea:	eb c4                	jmp    800ab0 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aec:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aef:	89 f3                	mov    %esi,%ebx
  800af1:	80 fb 19             	cmp    $0x19,%bl
  800af4:	77 29                	ja     800b1f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800af6:	0f be d2             	movsbl %dl,%edx
  800af9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800afc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aff:	7d 30                	jge    800b31 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b01:	83 c1 01             	add    $0x1,%ecx
  800b04:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b08:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b0a:	0f b6 11             	movzbl (%ecx),%edx
  800b0d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b10:	89 f3                	mov    %esi,%ebx
  800b12:	80 fb 09             	cmp    $0x9,%bl
  800b15:	77 d5                	ja     800aec <strtol+0x80>
			dig = *s - '0';
  800b17:	0f be d2             	movsbl %dl,%edx
  800b1a:	83 ea 30             	sub    $0x30,%edx
  800b1d:	eb dd                	jmp    800afc <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b1f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b22:	89 f3                	mov    %esi,%ebx
  800b24:	80 fb 19             	cmp    $0x19,%bl
  800b27:	77 08                	ja     800b31 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b29:	0f be d2             	movsbl %dl,%edx
  800b2c:	83 ea 37             	sub    $0x37,%edx
  800b2f:	eb cb                	jmp    800afc <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b35:	74 05                	je     800b3c <strtol+0xd0>
		*endptr = (char *) s;
  800b37:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b3c:	89 c2                	mov    %eax,%edx
  800b3e:	f7 da                	neg    %edx
  800b40:	85 ff                	test   %edi,%edi
  800b42:	0f 45 c2             	cmovne %edx,%eax
}
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5f                   	pop    %edi
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	57                   	push   %edi
  800b4e:	56                   	push   %esi
  800b4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b50:	b8 00 00 00 00       	mov    $0x0,%eax
  800b55:	8b 55 08             	mov    0x8(%ebp),%edx
  800b58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5b:	89 c3                	mov    %eax,%ebx
  800b5d:	89 c7                	mov    %eax,%edi
  800b5f:	89 c6                	mov    %eax,%esi
  800b61:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b63:	5b                   	pop    %ebx
  800b64:	5e                   	pop    %esi
  800b65:	5f                   	pop    %edi
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	57                   	push   %edi
  800b6c:	56                   	push   %esi
  800b6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b73:	b8 01 00 00 00       	mov    $0x1,%eax
  800b78:	89 d1                	mov    %edx,%ecx
  800b7a:	89 d3                	mov    %edx,%ebx
  800b7c:	89 d7                	mov    %edx,%edi
  800b7e:	89 d6                	mov    %edx,%esi
  800b80:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5f                   	pop    %edi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	57                   	push   %edi
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
  800b8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9d:	89 cb                	mov    %ecx,%ebx
  800b9f:	89 cf                	mov    %ecx,%edi
  800ba1:	89 ce                	mov    %ecx,%esi
  800ba3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba5:	85 c0                	test   %eax,%eax
  800ba7:	7f 08                	jg     800bb1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ba9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bac:	5b                   	pop    %ebx
  800bad:	5e                   	pop    %esi
  800bae:	5f                   	pop    %edi
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb1:	83 ec 0c             	sub    $0xc,%esp
  800bb4:	50                   	push   %eax
  800bb5:	6a 03                	push   $0x3
  800bb7:	68 ff 23 80 00       	push   $0x8023ff
  800bbc:	6a 23                	push   $0x23
  800bbe:	68 1c 24 80 00       	push   $0x80241c
  800bc3:	e8 80 f5 ff ff       	call   800148 <_panic>

00800bc8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bce:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd3:	b8 02 00 00 00       	mov    $0x2,%eax
  800bd8:	89 d1                	mov    %edx,%ecx
  800bda:	89 d3                	mov    %edx,%ebx
  800bdc:	89 d7                	mov    %edx,%edi
  800bde:	89 d6                	mov    %edx,%esi
  800be0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5f                   	pop    %edi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <sys_yield>:

void
sys_yield(void)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bed:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bf7:	89 d1                	mov    %edx,%ecx
  800bf9:	89 d3                	mov    %edx,%ebx
  800bfb:	89 d7                	mov    %edx,%edi
  800bfd:	89 d6                	mov    %edx,%esi
  800bff:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5f                   	pop    %edi
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	57                   	push   %edi
  800c0a:	56                   	push   %esi
  800c0b:	53                   	push   %ebx
  800c0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c0f:	be 00 00 00 00       	mov    $0x0,%esi
  800c14:	8b 55 08             	mov    0x8(%ebp),%edx
  800c17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c22:	89 f7                	mov    %esi,%edi
  800c24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c26:	85 c0                	test   %eax,%eax
  800c28:	7f 08                	jg     800c32 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5f                   	pop    %edi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c32:	83 ec 0c             	sub    $0xc,%esp
  800c35:	50                   	push   %eax
  800c36:	6a 04                	push   $0x4
  800c38:	68 ff 23 80 00       	push   $0x8023ff
  800c3d:	6a 23                	push   $0x23
  800c3f:	68 1c 24 80 00       	push   $0x80241c
  800c44:	e8 ff f4 ff ff       	call   800148 <_panic>

00800c49 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c58:	b8 05 00 00 00       	mov    $0x5,%eax
  800c5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c60:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c63:	8b 75 18             	mov    0x18(%ebp),%esi
  800c66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c68:	85 c0                	test   %eax,%eax
  800c6a:	7f 08                	jg     800c74 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c74:	83 ec 0c             	sub    $0xc,%esp
  800c77:	50                   	push   %eax
  800c78:	6a 05                	push   $0x5
  800c7a:	68 ff 23 80 00       	push   $0x8023ff
  800c7f:	6a 23                	push   $0x23
  800c81:	68 1c 24 80 00       	push   $0x80241c
  800c86:	e8 bd f4 ff ff       	call   800148 <_panic>

00800c8b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
  800c91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c99:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9f:	b8 06 00 00 00       	mov    $0x6,%eax
  800ca4:	89 df                	mov    %ebx,%edi
  800ca6:	89 de                	mov    %ebx,%esi
  800ca8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800caa:	85 c0                	test   %eax,%eax
  800cac:	7f 08                	jg     800cb6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb6:	83 ec 0c             	sub    $0xc,%esp
  800cb9:	50                   	push   %eax
  800cba:	6a 06                	push   $0x6
  800cbc:	68 ff 23 80 00       	push   $0x8023ff
  800cc1:	6a 23                	push   $0x23
  800cc3:	68 1c 24 80 00       	push   $0x80241c
  800cc8:	e8 7b f4 ff ff       	call   800148 <_panic>

00800ccd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce6:	89 df                	mov    %ebx,%edi
  800ce8:	89 de                	mov    %ebx,%esi
  800cea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7f 08                	jg     800cf8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf8:	83 ec 0c             	sub    $0xc,%esp
  800cfb:	50                   	push   %eax
  800cfc:	6a 08                	push   $0x8
  800cfe:	68 ff 23 80 00       	push   $0x8023ff
  800d03:	6a 23                	push   $0x23
  800d05:	68 1c 24 80 00       	push   $0x80241c
  800d0a:	e8 39 f4 ff ff       	call   800148 <_panic>

00800d0f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	57                   	push   %edi
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
  800d15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d23:	b8 09 00 00 00       	mov    $0x9,%eax
  800d28:	89 df                	mov    %ebx,%edi
  800d2a:	89 de                	mov    %ebx,%esi
  800d2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	7f 08                	jg     800d3a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3a:	83 ec 0c             	sub    $0xc,%esp
  800d3d:	50                   	push   %eax
  800d3e:	6a 09                	push   $0x9
  800d40:	68 ff 23 80 00       	push   $0x8023ff
  800d45:	6a 23                	push   $0x23
  800d47:	68 1c 24 80 00       	push   $0x80241c
  800d4c:	e8 f7 f3 ff ff       	call   800148 <_panic>

00800d51 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
  800d57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d65:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d6a:	89 df                	mov    %ebx,%edi
  800d6c:	89 de                	mov    %ebx,%esi
  800d6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d70:	85 c0                	test   %eax,%eax
  800d72:	7f 08                	jg     800d7c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d77:	5b                   	pop    %ebx
  800d78:	5e                   	pop    %esi
  800d79:	5f                   	pop    %edi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7c:	83 ec 0c             	sub    $0xc,%esp
  800d7f:	50                   	push   %eax
  800d80:	6a 0a                	push   $0xa
  800d82:	68 ff 23 80 00       	push   $0x8023ff
  800d87:	6a 23                	push   $0x23
  800d89:	68 1c 24 80 00       	push   $0x80241c
  800d8e:	e8 b5 f3 ff ff       	call   800148 <_panic>

00800d93 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800da4:	be 00 00 00 00       	mov    $0x0,%esi
  800da9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dac:	8b 7d 14             	mov    0x14(%ebp),%edi
  800daf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    

00800db6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	57                   	push   %edi
  800dba:	56                   	push   %esi
  800dbb:	53                   	push   %ebx
  800dbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dcc:	89 cb                	mov    %ecx,%ebx
  800dce:	89 cf                	mov    %ecx,%edi
  800dd0:	89 ce                	mov    %ecx,%esi
  800dd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd4:	85 c0                	test   %eax,%eax
  800dd6:	7f 08                	jg     800de0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de0:	83 ec 0c             	sub    $0xc,%esp
  800de3:	50                   	push   %eax
  800de4:	6a 0d                	push   $0xd
  800de6:	68 ff 23 80 00       	push   $0x8023ff
  800deb:	6a 23                	push   $0x23
  800ded:	68 1c 24 80 00       	push   $0x80241c
  800df2:	e8 51 f3 ff ff       	call   800148 <_panic>

00800df7 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800dfd:	68 2a 24 80 00       	push   $0x80242a
  800e02:	6a 25                	push   $0x25
  800e04:	68 42 24 80 00       	push   $0x802442
  800e09:	e8 3a f3 ff ff       	call   800148 <_panic>

00800e0e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
  800e14:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  800e17:	68 f7 0d 80 00       	push   $0x800df7
  800e1c:	e8 ca 0e 00 00       	call   801ceb <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800e21:	b8 07 00 00 00       	mov    $0x7,%eax
  800e26:	cd 30                	int    $0x30
  800e28:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  800e2e:	83 c4 10             	add    $0x10,%esp
  800e31:	85 c0                	test   %eax,%eax
  800e33:	78 27                	js     800e5c <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800e35:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  800e3a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e3e:	75 65                	jne    800ea5 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800e40:	e8 83 fd ff ff       	call   800bc8 <sys_getenvid>
  800e45:	25 ff 03 00 00       	and    $0x3ff,%eax
  800e4a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800e4d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e52:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800e57:	e9 11 01 00 00       	jmp    800f6d <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  800e5c:	50                   	push   %eax
  800e5d:	68 4d 24 80 00       	push   $0x80244d
  800e62:	6a 6f                	push   $0x6f
  800e64:	68 42 24 80 00       	push   $0x802442
  800e69:	e8 da f2 ff ff       	call   800148 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  800e6e:	e8 55 fd ff ff       	call   800bc8 <sys_getenvid>
  800e73:	83 ec 0c             	sub    $0xc,%esp
  800e76:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800e7c:	56                   	push   %esi
  800e7d:	57                   	push   %edi
  800e7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e81:	57                   	push   %edi
  800e82:	50                   	push   %eax
  800e83:	e8 c1 fd ff ff       	call   800c49 <sys_page_map>
  800e88:	83 c4 20             	add    $0x20,%esp
  800e8b:	85 c0                	test   %eax,%eax
  800e8d:	0f 88 84 00 00 00    	js     800f17 <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800e93:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800e99:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800e9f:	0f 84 84 00 00 00    	je     800f29 <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  800ea5:	89 d8                	mov    %ebx,%eax
  800ea7:	c1 e8 16             	shr    $0x16,%eax
  800eaa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800eb1:	a8 01                	test   $0x1,%al
  800eb3:	74 de                	je     800e93 <fork+0x85>
  800eb5:	89 d8                	mov    %ebx,%eax
  800eb7:	c1 e8 0c             	shr    $0xc,%eax
  800eba:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ec1:	f6 c2 01             	test   $0x1,%dl
  800ec4:	74 cd                	je     800e93 <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  800ec6:	89 c7                	mov    %eax,%edi
  800ec8:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  800ecb:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  800ed2:	f7 c6 00 04 00 00    	test   $0x400,%esi
  800ed8:	75 94                	jne    800e6e <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  800eda:	f7 c6 02 08 00 00    	test   $0x802,%esi
  800ee0:	0f 85 d1 00 00 00    	jne    800fb7 <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800ee6:	a1 08 40 80 00       	mov    0x804008,%eax
  800eeb:	8b 40 48             	mov    0x48(%eax),%eax
  800eee:	83 ec 0c             	sub    $0xc,%esp
  800ef1:	6a 05                	push   $0x5
  800ef3:	57                   	push   %edi
  800ef4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ef7:	57                   	push   %edi
  800ef8:	50                   	push   %eax
  800ef9:	e8 4b fd ff ff       	call   800c49 <sys_page_map>
  800efe:	83 c4 20             	add    $0x20,%esp
  800f01:	85 c0                	test   %eax,%eax
  800f03:	79 8e                	jns    800e93 <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  800f05:	50                   	push   %eax
  800f06:	68 a4 24 80 00       	push   $0x8024a4
  800f0b:	6a 4a                	push   $0x4a
  800f0d:	68 42 24 80 00       	push   $0x802442
  800f12:	e8 31 f2 ff ff       	call   800148 <_panic>
                        panic("duppage: page mapping failed %e", r);
  800f17:	50                   	push   %eax
  800f18:	68 84 24 80 00       	push   $0x802484
  800f1d:	6a 41                	push   $0x41
  800f1f:	68 42 24 80 00       	push   $0x802442
  800f24:	e8 1f f2 ff ff       	call   800148 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  800f29:	83 ec 04             	sub    $0x4,%esp
  800f2c:	6a 07                	push   $0x7
  800f2e:	68 00 f0 bf ee       	push   $0xeebff000
  800f33:	ff 75 e0             	pushl  -0x20(%ebp)
  800f36:	e8 cb fc ff ff       	call   800c06 <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  800f3b:	83 c4 10             	add    $0x10,%esp
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	78 36                	js     800f78 <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  800f42:	83 ec 08             	sub    $0x8,%esp
  800f45:	68 5f 1d 80 00       	push   $0x801d5f
  800f4a:	ff 75 e0             	pushl  -0x20(%ebp)
  800f4d:	e8 ff fd ff ff       	call   800d51 <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800f52:	83 c4 10             	add    $0x10,%esp
  800f55:	85 c0                	test   %eax,%eax
  800f57:	78 34                	js     800f8d <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  800f59:	83 ec 08             	sub    $0x8,%esp
  800f5c:	6a 02                	push   $0x2
  800f5e:	ff 75 e0             	pushl  -0x20(%ebp)
  800f61:	e8 67 fd ff ff       	call   800ccd <sys_env_set_status>
  800f66:	83 c4 10             	add    $0x10,%esp
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	78 35                	js     800fa2 <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  800f6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f73:	5b                   	pop    %ebx
  800f74:	5e                   	pop    %esi
  800f75:	5f                   	pop    %edi
  800f76:	5d                   	pop    %ebp
  800f77:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  800f78:	50                   	push   %eax
  800f79:	68 4d 24 80 00       	push   $0x80244d
  800f7e:	68 82 00 00 00       	push   $0x82
  800f83:	68 42 24 80 00       	push   $0x802442
  800f88:	e8 bb f1 ff ff       	call   800148 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800f8d:	50                   	push   %eax
  800f8e:	68 c8 24 80 00       	push   $0x8024c8
  800f93:	68 87 00 00 00       	push   $0x87
  800f98:	68 42 24 80 00       	push   $0x802442
  800f9d:	e8 a6 f1 ff ff       	call   800148 <_panic>
        	panic("sys_env_set_status: %e", r);
  800fa2:	50                   	push   %eax
  800fa3:	68 56 24 80 00       	push   $0x802456
  800fa8:	68 8b 00 00 00       	push   $0x8b
  800fad:	68 42 24 80 00       	push   $0x802442
  800fb2:	e8 91 f1 ff ff       	call   800148 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800fb7:	a1 08 40 80 00       	mov    0x804008,%eax
  800fbc:	8b 40 48             	mov    0x48(%eax),%eax
  800fbf:	83 ec 0c             	sub    $0xc,%esp
  800fc2:	68 05 08 00 00       	push   $0x805
  800fc7:	57                   	push   %edi
  800fc8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fcb:	57                   	push   %edi
  800fcc:	50                   	push   %eax
  800fcd:	e8 77 fc ff ff       	call   800c49 <sys_page_map>
  800fd2:	83 c4 20             	add    $0x20,%esp
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	0f 88 28 ff ff ff    	js     800f05 <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  800fdd:	a1 08 40 80 00       	mov    0x804008,%eax
  800fe2:	8b 50 48             	mov    0x48(%eax),%edx
  800fe5:	8b 40 48             	mov    0x48(%eax),%eax
  800fe8:	83 ec 0c             	sub    $0xc,%esp
  800feb:	68 05 08 00 00       	push   $0x805
  800ff0:	57                   	push   %edi
  800ff1:	52                   	push   %edx
  800ff2:	57                   	push   %edi
  800ff3:	50                   	push   %eax
  800ff4:	e8 50 fc ff ff       	call   800c49 <sys_page_map>
  800ff9:	83 c4 20             	add    $0x20,%esp
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	0f 89 8f fe ff ff    	jns    800e93 <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  801004:	50                   	push   %eax
  801005:	68 a4 24 80 00       	push   $0x8024a4
  80100a:	6a 4f                	push   $0x4f
  80100c:	68 42 24 80 00       	push   $0x802442
  801011:	e8 32 f1 ff ff       	call   800148 <_panic>

00801016 <sfork>:

// Challenge!
int
sfork(void)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80101c:	68 6d 24 80 00       	push   $0x80246d
  801021:	68 94 00 00 00       	push   $0x94
  801026:	68 42 24 80 00       	push   $0x802442
  80102b:	e8 18 f1 ff ff       	call   800148 <_panic>

00801030 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	05 00 00 00 30       	add    $0x30000000,%eax
  80103b:	c1 e8 0c             	shr    $0xc,%eax
}
  80103e:	5d                   	pop    %ebp
  80103f:	c3                   	ret    

00801040 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80104b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801050:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80105d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801062:	89 c2                	mov    %eax,%edx
  801064:	c1 ea 16             	shr    $0x16,%edx
  801067:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80106e:	f6 c2 01             	test   $0x1,%dl
  801071:	74 2a                	je     80109d <fd_alloc+0x46>
  801073:	89 c2                	mov    %eax,%edx
  801075:	c1 ea 0c             	shr    $0xc,%edx
  801078:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80107f:	f6 c2 01             	test   $0x1,%dl
  801082:	74 19                	je     80109d <fd_alloc+0x46>
  801084:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801089:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80108e:	75 d2                	jne    801062 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801090:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801096:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80109b:	eb 07                	jmp    8010a4 <fd_alloc+0x4d>
			*fd_store = fd;
  80109d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80109f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    

008010a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010ac:	83 f8 1f             	cmp    $0x1f,%eax
  8010af:	77 36                	ja     8010e7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010b1:	c1 e0 0c             	shl    $0xc,%eax
  8010b4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010b9:	89 c2                	mov    %eax,%edx
  8010bb:	c1 ea 16             	shr    $0x16,%edx
  8010be:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010c5:	f6 c2 01             	test   $0x1,%dl
  8010c8:	74 24                	je     8010ee <fd_lookup+0x48>
  8010ca:	89 c2                	mov    %eax,%edx
  8010cc:	c1 ea 0c             	shr    $0xc,%edx
  8010cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010d6:	f6 c2 01             	test   $0x1,%dl
  8010d9:	74 1a                	je     8010f5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010de:	89 02                	mov    %eax,(%edx)
	return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    
		return -E_INVAL;
  8010e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ec:	eb f7                	jmp    8010e5 <fd_lookup+0x3f>
		return -E_INVAL;
  8010ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f3:	eb f0                	jmp    8010e5 <fd_lookup+0x3f>
  8010f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010fa:	eb e9                	jmp    8010e5 <fd_lookup+0x3f>

008010fc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 08             	sub    $0x8,%esp
  801102:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801105:	ba 6c 25 80 00       	mov    $0x80256c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80110a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80110f:	39 08                	cmp    %ecx,(%eax)
  801111:	74 33                	je     801146 <dev_lookup+0x4a>
  801113:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801116:	8b 02                	mov    (%edx),%eax
  801118:	85 c0                	test   %eax,%eax
  80111a:	75 f3                	jne    80110f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80111c:	a1 08 40 80 00       	mov    0x804008,%eax
  801121:	8b 40 48             	mov    0x48(%eax),%eax
  801124:	83 ec 04             	sub    $0x4,%esp
  801127:	51                   	push   %ecx
  801128:	50                   	push   %eax
  801129:	68 ec 24 80 00       	push   $0x8024ec
  80112e:	e8 f0 f0 ff ff       	call   800223 <cprintf>
	*dev = 0;
  801133:	8b 45 0c             	mov    0xc(%ebp),%eax
  801136:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80113c:	83 c4 10             	add    $0x10,%esp
  80113f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    
			*dev = devtab[i];
  801146:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801149:	89 01                	mov    %eax,(%ecx)
			return 0;
  80114b:	b8 00 00 00 00       	mov    $0x0,%eax
  801150:	eb f2                	jmp    801144 <dev_lookup+0x48>

00801152 <fd_close>:
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	57                   	push   %edi
  801156:	56                   	push   %esi
  801157:	53                   	push   %ebx
  801158:	83 ec 1c             	sub    $0x1c,%esp
  80115b:	8b 75 08             	mov    0x8(%ebp),%esi
  80115e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801161:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801164:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801165:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80116b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80116e:	50                   	push   %eax
  80116f:	e8 32 ff ff ff       	call   8010a6 <fd_lookup>
  801174:	89 c3                	mov    %eax,%ebx
  801176:	83 c4 08             	add    $0x8,%esp
  801179:	85 c0                	test   %eax,%eax
  80117b:	78 05                	js     801182 <fd_close+0x30>
	    || fd != fd2)
  80117d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801180:	74 16                	je     801198 <fd_close+0x46>
		return (must_exist ? r : 0);
  801182:	89 f8                	mov    %edi,%eax
  801184:	84 c0                	test   %al,%al
  801186:	b8 00 00 00 00       	mov    $0x0,%eax
  80118b:	0f 44 d8             	cmove  %eax,%ebx
}
  80118e:	89 d8                	mov    %ebx,%eax
  801190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801193:	5b                   	pop    %ebx
  801194:	5e                   	pop    %esi
  801195:	5f                   	pop    %edi
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801198:	83 ec 08             	sub    $0x8,%esp
  80119b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80119e:	50                   	push   %eax
  80119f:	ff 36                	pushl  (%esi)
  8011a1:	e8 56 ff ff ff       	call   8010fc <dev_lookup>
  8011a6:	89 c3                	mov    %eax,%ebx
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	78 15                	js     8011c4 <fd_close+0x72>
		if (dev->dev_close)
  8011af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011b2:	8b 40 10             	mov    0x10(%eax),%eax
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	74 1b                	je     8011d4 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8011b9:	83 ec 0c             	sub    $0xc,%esp
  8011bc:	56                   	push   %esi
  8011bd:	ff d0                	call   *%eax
  8011bf:	89 c3                	mov    %eax,%ebx
  8011c1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011c4:	83 ec 08             	sub    $0x8,%esp
  8011c7:	56                   	push   %esi
  8011c8:	6a 00                	push   $0x0
  8011ca:	e8 bc fa ff ff       	call   800c8b <sys_page_unmap>
	return r;
  8011cf:	83 c4 10             	add    $0x10,%esp
  8011d2:	eb ba                	jmp    80118e <fd_close+0x3c>
			r = 0;
  8011d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d9:	eb e9                	jmp    8011c4 <fd_close+0x72>

008011db <close>:

int
close(int fdnum)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e4:	50                   	push   %eax
  8011e5:	ff 75 08             	pushl  0x8(%ebp)
  8011e8:	e8 b9 fe ff ff       	call   8010a6 <fd_lookup>
  8011ed:	83 c4 08             	add    $0x8,%esp
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	78 10                	js     801204 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8011f4:	83 ec 08             	sub    $0x8,%esp
  8011f7:	6a 01                	push   $0x1
  8011f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011fc:	e8 51 ff ff ff       	call   801152 <fd_close>
  801201:	83 c4 10             	add    $0x10,%esp
}
  801204:	c9                   	leave  
  801205:	c3                   	ret    

00801206 <close_all>:

void
close_all(void)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	53                   	push   %ebx
  80120a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80120d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	53                   	push   %ebx
  801216:	e8 c0 ff ff ff       	call   8011db <close>
	for (i = 0; i < MAXFD; i++)
  80121b:	83 c3 01             	add    $0x1,%ebx
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	83 fb 20             	cmp    $0x20,%ebx
  801224:	75 ec                	jne    801212 <close_all+0xc>
}
  801226:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801229:	c9                   	leave  
  80122a:	c3                   	ret    

0080122b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	57                   	push   %edi
  80122f:	56                   	push   %esi
  801230:	53                   	push   %ebx
  801231:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801234:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801237:	50                   	push   %eax
  801238:	ff 75 08             	pushl  0x8(%ebp)
  80123b:	e8 66 fe ff ff       	call   8010a6 <fd_lookup>
  801240:	89 c3                	mov    %eax,%ebx
  801242:	83 c4 08             	add    $0x8,%esp
  801245:	85 c0                	test   %eax,%eax
  801247:	0f 88 81 00 00 00    	js     8012ce <dup+0xa3>
		return r;
	close(newfdnum);
  80124d:	83 ec 0c             	sub    $0xc,%esp
  801250:	ff 75 0c             	pushl  0xc(%ebp)
  801253:	e8 83 ff ff ff       	call   8011db <close>

	newfd = INDEX2FD(newfdnum);
  801258:	8b 75 0c             	mov    0xc(%ebp),%esi
  80125b:	c1 e6 0c             	shl    $0xc,%esi
  80125e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801264:	83 c4 04             	add    $0x4,%esp
  801267:	ff 75 e4             	pushl  -0x1c(%ebp)
  80126a:	e8 d1 fd ff ff       	call   801040 <fd2data>
  80126f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801271:	89 34 24             	mov    %esi,(%esp)
  801274:	e8 c7 fd ff ff       	call   801040 <fd2data>
  801279:	83 c4 10             	add    $0x10,%esp
  80127c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80127e:	89 d8                	mov    %ebx,%eax
  801280:	c1 e8 16             	shr    $0x16,%eax
  801283:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80128a:	a8 01                	test   $0x1,%al
  80128c:	74 11                	je     80129f <dup+0x74>
  80128e:	89 d8                	mov    %ebx,%eax
  801290:	c1 e8 0c             	shr    $0xc,%eax
  801293:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80129a:	f6 c2 01             	test   $0x1,%dl
  80129d:	75 39                	jne    8012d8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80129f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012a2:	89 d0                	mov    %edx,%eax
  8012a4:	c1 e8 0c             	shr    $0xc,%eax
  8012a7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b6:	50                   	push   %eax
  8012b7:	56                   	push   %esi
  8012b8:	6a 00                	push   $0x0
  8012ba:	52                   	push   %edx
  8012bb:	6a 00                	push   $0x0
  8012bd:	e8 87 f9 ff ff       	call   800c49 <sys_page_map>
  8012c2:	89 c3                	mov    %eax,%ebx
  8012c4:	83 c4 20             	add    $0x20,%esp
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	78 31                	js     8012fc <dup+0xd1>
		goto err;

	return newfdnum;
  8012cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012ce:	89 d8                	mov    %ebx,%eax
  8012d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d3:	5b                   	pop    %ebx
  8012d4:	5e                   	pop    %esi
  8012d5:	5f                   	pop    %edi
  8012d6:	5d                   	pop    %ebp
  8012d7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012d8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012df:	83 ec 0c             	sub    $0xc,%esp
  8012e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012e7:	50                   	push   %eax
  8012e8:	57                   	push   %edi
  8012e9:	6a 00                	push   $0x0
  8012eb:	53                   	push   %ebx
  8012ec:	6a 00                	push   $0x0
  8012ee:	e8 56 f9 ff ff       	call   800c49 <sys_page_map>
  8012f3:	89 c3                	mov    %eax,%ebx
  8012f5:	83 c4 20             	add    $0x20,%esp
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	79 a3                	jns    80129f <dup+0x74>
	sys_page_unmap(0, newfd);
  8012fc:	83 ec 08             	sub    $0x8,%esp
  8012ff:	56                   	push   %esi
  801300:	6a 00                	push   $0x0
  801302:	e8 84 f9 ff ff       	call   800c8b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801307:	83 c4 08             	add    $0x8,%esp
  80130a:	57                   	push   %edi
  80130b:	6a 00                	push   $0x0
  80130d:	e8 79 f9 ff ff       	call   800c8b <sys_page_unmap>
	return r;
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	eb b7                	jmp    8012ce <dup+0xa3>

00801317 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	53                   	push   %ebx
  80131b:	83 ec 14             	sub    $0x14,%esp
  80131e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801321:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801324:	50                   	push   %eax
  801325:	53                   	push   %ebx
  801326:	e8 7b fd ff ff       	call   8010a6 <fd_lookup>
  80132b:	83 c4 08             	add    $0x8,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	78 3f                	js     801371 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801332:	83 ec 08             	sub    $0x8,%esp
  801335:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801338:	50                   	push   %eax
  801339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133c:	ff 30                	pushl  (%eax)
  80133e:	e8 b9 fd ff ff       	call   8010fc <dev_lookup>
  801343:	83 c4 10             	add    $0x10,%esp
  801346:	85 c0                	test   %eax,%eax
  801348:	78 27                	js     801371 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80134a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80134d:	8b 42 08             	mov    0x8(%edx),%eax
  801350:	83 e0 03             	and    $0x3,%eax
  801353:	83 f8 01             	cmp    $0x1,%eax
  801356:	74 1e                	je     801376 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135b:	8b 40 08             	mov    0x8(%eax),%eax
  80135e:	85 c0                	test   %eax,%eax
  801360:	74 35                	je     801397 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801362:	83 ec 04             	sub    $0x4,%esp
  801365:	ff 75 10             	pushl  0x10(%ebp)
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	52                   	push   %edx
  80136c:	ff d0                	call   *%eax
  80136e:	83 c4 10             	add    $0x10,%esp
}
  801371:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801374:	c9                   	leave  
  801375:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801376:	a1 08 40 80 00       	mov    0x804008,%eax
  80137b:	8b 40 48             	mov    0x48(%eax),%eax
  80137e:	83 ec 04             	sub    $0x4,%esp
  801381:	53                   	push   %ebx
  801382:	50                   	push   %eax
  801383:	68 30 25 80 00       	push   $0x802530
  801388:	e8 96 ee ff ff       	call   800223 <cprintf>
		return -E_INVAL;
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801395:	eb da                	jmp    801371 <read+0x5a>
		return -E_NOT_SUPP;
  801397:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139c:	eb d3                	jmp    801371 <read+0x5a>

0080139e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	57                   	push   %edi
  8013a2:	56                   	push   %esi
  8013a3:	53                   	push   %ebx
  8013a4:	83 ec 0c             	sub    $0xc,%esp
  8013a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013aa:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b2:	39 f3                	cmp    %esi,%ebx
  8013b4:	73 25                	jae    8013db <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013b6:	83 ec 04             	sub    $0x4,%esp
  8013b9:	89 f0                	mov    %esi,%eax
  8013bb:	29 d8                	sub    %ebx,%eax
  8013bd:	50                   	push   %eax
  8013be:	89 d8                	mov    %ebx,%eax
  8013c0:	03 45 0c             	add    0xc(%ebp),%eax
  8013c3:	50                   	push   %eax
  8013c4:	57                   	push   %edi
  8013c5:	e8 4d ff ff ff       	call   801317 <read>
		if (m < 0)
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 08                	js     8013d9 <readn+0x3b>
			return m;
		if (m == 0)
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	74 06                	je     8013db <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8013d5:	01 c3                	add    %eax,%ebx
  8013d7:	eb d9                	jmp    8013b2 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013d9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013db:	89 d8                	mov    %ebx,%eax
  8013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e0:	5b                   	pop    %ebx
  8013e1:	5e                   	pop    %esi
  8013e2:	5f                   	pop    %edi
  8013e3:	5d                   	pop    %ebp
  8013e4:	c3                   	ret    

008013e5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	53                   	push   %ebx
  8013e9:	83 ec 14             	sub    $0x14,%esp
  8013ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f2:	50                   	push   %eax
  8013f3:	53                   	push   %ebx
  8013f4:	e8 ad fc ff ff       	call   8010a6 <fd_lookup>
  8013f9:	83 c4 08             	add    $0x8,%esp
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	78 3a                	js     80143a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801406:	50                   	push   %eax
  801407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140a:	ff 30                	pushl  (%eax)
  80140c:	e8 eb fc ff ff       	call   8010fc <dev_lookup>
  801411:	83 c4 10             	add    $0x10,%esp
  801414:	85 c0                	test   %eax,%eax
  801416:	78 22                	js     80143a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80141f:	74 1e                	je     80143f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801421:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801424:	8b 52 0c             	mov    0xc(%edx),%edx
  801427:	85 d2                	test   %edx,%edx
  801429:	74 35                	je     801460 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80142b:	83 ec 04             	sub    $0x4,%esp
  80142e:	ff 75 10             	pushl  0x10(%ebp)
  801431:	ff 75 0c             	pushl  0xc(%ebp)
  801434:	50                   	push   %eax
  801435:	ff d2                	call   *%edx
  801437:	83 c4 10             	add    $0x10,%esp
}
  80143a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80143f:	a1 08 40 80 00       	mov    0x804008,%eax
  801444:	8b 40 48             	mov    0x48(%eax),%eax
  801447:	83 ec 04             	sub    $0x4,%esp
  80144a:	53                   	push   %ebx
  80144b:	50                   	push   %eax
  80144c:	68 4c 25 80 00       	push   $0x80254c
  801451:	e8 cd ed ff ff       	call   800223 <cprintf>
		return -E_INVAL;
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145e:	eb da                	jmp    80143a <write+0x55>
		return -E_NOT_SUPP;
  801460:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801465:	eb d3                	jmp    80143a <write+0x55>

00801467 <seek>:

int
seek(int fdnum, off_t offset)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80146d:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801470:	50                   	push   %eax
  801471:	ff 75 08             	pushl  0x8(%ebp)
  801474:	e8 2d fc ff ff       	call   8010a6 <fd_lookup>
  801479:	83 c4 08             	add    $0x8,%esp
  80147c:	85 c0                	test   %eax,%eax
  80147e:	78 0e                	js     80148e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801480:	8b 55 0c             	mov    0xc(%ebp),%edx
  801483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801486:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	53                   	push   %ebx
  801494:	83 ec 14             	sub    $0x14,%esp
  801497:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149d:	50                   	push   %eax
  80149e:	53                   	push   %ebx
  80149f:	e8 02 fc ff ff       	call   8010a6 <fd_lookup>
  8014a4:	83 c4 08             	add    $0x8,%esp
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	78 37                	js     8014e2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ab:	83 ec 08             	sub    $0x8,%esp
  8014ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b1:	50                   	push   %eax
  8014b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b5:	ff 30                	pushl  (%eax)
  8014b7:	e8 40 fc ff ff       	call   8010fc <dev_lookup>
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 1f                	js     8014e2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ca:	74 1b                	je     8014e7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cf:	8b 52 18             	mov    0x18(%edx),%edx
  8014d2:	85 d2                	test   %edx,%edx
  8014d4:	74 32                	je     801508 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014d6:	83 ec 08             	sub    $0x8,%esp
  8014d9:	ff 75 0c             	pushl  0xc(%ebp)
  8014dc:	50                   	push   %eax
  8014dd:	ff d2                	call   *%edx
  8014df:	83 c4 10             	add    $0x10,%esp
}
  8014e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014e7:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014ec:	8b 40 48             	mov    0x48(%eax),%eax
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	53                   	push   %ebx
  8014f3:	50                   	push   %eax
  8014f4:	68 0c 25 80 00       	push   $0x80250c
  8014f9:	e8 25 ed ff ff       	call   800223 <cprintf>
		return -E_INVAL;
  8014fe:	83 c4 10             	add    $0x10,%esp
  801501:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801506:	eb da                	jmp    8014e2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801508:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80150d:	eb d3                	jmp    8014e2 <ftruncate+0x52>

0080150f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	53                   	push   %ebx
  801513:	83 ec 14             	sub    $0x14,%esp
  801516:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801519:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	ff 75 08             	pushl  0x8(%ebp)
  801520:	e8 81 fb ff ff       	call   8010a6 <fd_lookup>
  801525:	83 c4 08             	add    $0x8,%esp
  801528:	85 c0                	test   %eax,%eax
  80152a:	78 4b                	js     801577 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152c:	83 ec 08             	sub    $0x8,%esp
  80152f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801532:	50                   	push   %eax
  801533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801536:	ff 30                	pushl  (%eax)
  801538:	e8 bf fb ff ff       	call   8010fc <dev_lookup>
  80153d:	83 c4 10             	add    $0x10,%esp
  801540:	85 c0                	test   %eax,%eax
  801542:	78 33                	js     801577 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801547:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80154b:	74 2f                	je     80157c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80154d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801550:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801557:	00 00 00 
	stat->st_isdir = 0;
  80155a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801561:	00 00 00 
	stat->st_dev = dev;
  801564:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80156a:	83 ec 08             	sub    $0x8,%esp
  80156d:	53                   	push   %ebx
  80156e:	ff 75 f0             	pushl  -0x10(%ebp)
  801571:	ff 50 14             	call   *0x14(%eax)
  801574:	83 c4 10             	add    $0x10,%esp
}
  801577:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    
		return -E_NOT_SUPP;
  80157c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801581:	eb f4                	jmp    801577 <fstat+0x68>

00801583 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	56                   	push   %esi
  801587:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	6a 00                	push   $0x0
  80158d:	ff 75 08             	pushl  0x8(%ebp)
  801590:	e8 e7 01 00 00       	call   80177c <open>
  801595:	89 c3                	mov    %eax,%ebx
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	85 c0                	test   %eax,%eax
  80159c:	78 1b                	js     8015b9 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80159e:	83 ec 08             	sub    $0x8,%esp
  8015a1:	ff 75 0c             	pushl  0xc(%ebp)
  8015a4:	50                   	push   %eax
  8015a5:	e8 65 ff ff ff       	call   80150f <fstat>
  8015aa:	89 c6                	mov    %eax,%esi
	close(fd);
  8015ac:	89 1c 24             	mov    %ebx,(%esp)
  8015af:	e8 27 fc ff ff       	call   8011db <close>
	return r;
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	89 f3                	mov    %esi,%ebx
}
  8015b9:	89 d8                	mov    %ebx,%eax
  8015bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015be:	5b                   	pop    %ebx
  8015bf:	5e                   	pop    %esi
  8015c0:	5d                   	pop    %ebp
  8015c1:	c3                   	ret    

008015c2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	56                   	push   %esi
  8015c6:	53                   	push   %ebx
  8015c7:	89 c6                	mov    %eax,%esi
  8015c9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015cb:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015d2:	74 27                	je     8015fb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015d4:	6a 07                	push   $0x7
  8015d6:	68 00 50 80 00       	push   $0x805000
  8015db:	56                   	push   %esi
  8015dc:	ff 35 00 40 80 00    	pushl  0x804000
  8015e2:	e8 b6 07 00 00       	call   801d9d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015e7:	83 c4 0c             	add    $0xc,%esp
  8015ea:	6a 00                	push   $0x0
  8015ec:	53                   	push   %ebx
  8015ed:	6a 00                	push   $0x0
  8015ef:	e8 92 07 00 00       	call   801d86 <ipc_recv>
}
  8015f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f7:	5b                   	pop    %ebx
  8015f8:	5e                   	pop    %esi
  8015f9:	5d                   	pop    %ebp
  8015fa:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015fb:	83 ec 0c             	sub    $0xc,%esp
  8015fe:	6a 01                	push   $0x1
  801600:	e8 af 07 00 00       	call   801db4 <ipc_find_env>
  801605:	a3 00 40 80 00       	mov    %eax,0x804000
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	eb c5                	jmp    8015d4 <fsipc+0x12>

0080160f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	8b 40 0c             	mov    0xc(%eax),%eax
  80161b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801620:	8b 45 0c             	mov    0xc(%ebp),%eax
  801623:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801628:	ba 00 00 00 00       	mov    $0x0,%edx
  80162d:	b8 02 00 00 00       	mov    $0x2,%eax
  801632:	e8 8b ff ff ff       	call   8015c2 <fsipc>
}
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <devfile_flush>:
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8b 40 0c             	mov    0xc(%eax),%eax
  801645:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80164a:	ba 00 00 00 00       	mov    $0x0,%edx
  80164f:	b8 06 00 00 00       	mov    $0x6,%eax
  801654:	e8 69 ff ff ff       	call   8015c2 <fsipc>
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <devfile_stat>:
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	53                   	push   %ebx
  80165f:	83 ec 04             	sub    $0x4,%esp
  801662:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	8b 40 0c             	mov    0xc(%eax),%eax
  80166b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801670:	ba 00 00 00 00       	mov    $0x0,%edx
  801675:	b8 05 00 00 00       	mov    $0x5,%eax
  80167a:	e8 43 ff ff ff       	call   8015c2 <fsipc>
  80167f:	85 c0                	test   %eax,%eax
  801681:	78 2c                	js     8016af <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801683:	83 ec 08             	sub    $0x8,%esp
  801686:	68 00 50 80 00       	push   $0x805000
  80168b:	53                   	push   %ebx
  80168c:	e8 7c f1 ff ff       	call   80080d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801691:	a1 80 50 80 00       	mov    0x805080,%eax
  801696:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80169c:	a1 84 50 80 00       	mov    0x805084,%eax
  8016a1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <devfile_write>:
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	83 ec 0c             	sub    $0xc,%esp
  8016ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bd:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016c2:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8016c7:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8016cd:	8b 52 0c             	mov    0xc(%edx),%edx
  8016d0:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8016d6:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8016db:	50                   	push   %eax
  8016dc:	ff 75 0c             	pushl  0xc(%ebp)
  8016df:	68 08 50 80 00       	push   $0x805008
  8016e4:	e8 b2 f2 ff ff       	call   80099b <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ee:	b8 04 00 00 00       	mov    $0x4,%eax
  8016f3:	e8 ca fe ff ff       	call   8015c2 <fsipc>
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <devfile_read>:
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	56                   	push   %esi
  8016fe:	53                   	push   %ebx
  8016ff:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	8b 40 0c             	mov    0xc(%eax),%eax
  801708:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80170d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801713:	ba 00 00 00 00       	mov    $0x0,%edx
  801718:	b8 03 00 00 00       	mov    $0x3,%eax
  80171d:	e8 a0 fe ff ff       	call   8015c2 <fsipc>
  801722:	89 c3                	mov    %eax,%ebx
  801724:	85 c0                	test   %eax,%eax
  801726:	78 1f                	js     801747 <devfile_read+0x4d>
	assert(r <= n);
  801728:	39 f0                	cmp    %esi,%eax
  80172a:	77 24                	ja     801750 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80172c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801731:	7f 33                	jg     801766 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801733:	83 ec 04             	sub    $0x4,%esp
  801736:	50                   	push   %eax
  801737:	68 00 50 80 00       	push   $0x805000
  80173c:	ff 75 0c             	pushl  0xc(%ebp)
  80173f:	e8 57 f2 ff ff       	call   80099b <memmove>
	return r;
  801744:	83 c4 10             	add    $0x10,%esp
}
  801747:	89 d8                	mov    %ebx,%eax
  801749:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174c:	5b                   	pop    %ebx
  80174d:	5e                   	pop    %esi
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    
	assert(r <= n);
  801750:	68 7c 25 80 00       	push   $0x80257c
  801755:	68 83 25 80 00       	push   $0x802583
  80175a:	6a 7c                	push   $0x7c
  80175c:	68 98 25 80 00       	push   $0x802598
  801761:	e8 e2 e9 ff ff       	call   800148 <_panic>
	assert(r <= PGSIZE);
  801766:	68 a3 25 80 00       	push   $0x8025a3
  80176b:	68 83 25 80 00       	push   $0x802583
  801770:	6a 7d                	push   $0x7d
  801772:	68 98 25 80 00       	push   $0x802598
  801777:	e8 cc e9 ff ff       	call   800148 <_panic>

0080177c <open>:
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	56                   	push   %esi
  801780:	53                   	push   %ebx
  801781:	83 ec 1c             	sub    $0x1c,%esp
  801784:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801787:	56                   	push   %esi
  801788:	e8 49 f0 ff ff       	call   8007d6 <strlen>
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801795:	7f 6c                	jg     801803 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801797:	83 ec 0c             	sub    $0xc,%esp
  80179a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179d:	50                   	push   %eax
  80179e:	e8 b4 f8 ff ff       	call   801057 <fd_alloc>
  8017a3:	89 c3                	mov    %eax,%ebx
  8017a5:	83 c4 10             	add    $0x10,%esp
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	78 3c                	js     8017e8 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017ac:	83 ec 08             	sub    $0x8,%esp
  8017af:	56                   	push   %esi
  8017b0:	68 00 50 80 00       	push   $0x805000
  8017b5:	e8 53 f0 ff ff       	call   80080d <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ca:	e8 f3 fd ff ff       	call   8015c2 <fsipc>
  8017cf:	89 c3                	mov    %eax,%ebx
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	78 19                	js     8017f1 <open+0x75>
	return fd2num(fd);
  8017d8:	83 ec 0c             	sub    $0xc,%esp
  8017db:	ff 75 f4             	pushl  -0xc(%ebp)
  8017de:	e8 4d f8 ff ff       	call   801030 <fd2num>
  8017e3:	89 c3                	mov    %eax,%ebx
  8017e5:	83 c4 10             	add    $0x10,%esp
}
  8017e8:	89 d8                	mov    %ebx,%eax
  8017ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ed:	5b                   	pop    %ebx
  8017ee:	5e                   	pop    %esi
  8017ef:	5d                   	pop    %ebp
  8017f0:	c3                   	ret    
		fd_close(fd, 0);
  8017f1:	83 ec 08             	sub    $0x8,%esp
  8017f4:	6a 00                	push   $0x0
  8017f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f9:	e8 54 f9 ff ff       	call   801152 <fd_close>
		return r;
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	eb e5                	jmp    8017e8 <open+0x6c>
		return -E_BAD_PATH;
  801803:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801808:	eb de                	jmp    8017e8 <open+0x6c>

0080180a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801810:	ba 00 00 00 00       	mov    $0x0,%edx
  801815:	b8 08 00 00 00       	mov    $0x8,%eax
  80181a:	e8 a3 fd ff ff       	call   8015c2 <fsipc>
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	56                   	push   %esi
  801825:	53                   	push   %ebx
  801826:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801829:	83 ec 0c             	sub    $0xc,%esp
  80182c:	ff 75 08             	pushl  0x8(%ebp)
  80182f:	e8 0c f8 ff ff       	call   801040 <fd2data>
  801834:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801836:	83 c4 08             	add    $0x8,%esp
  801839:	68 af 25 80 00       	push   $0x8025af
  80183e:	53                   	push   %ebx
  80183f:	e8 c9 ef ff ff       	call   80080d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801844:	8b 46 04             	mov    0x4(%esi),%eax
  801847:	2b 06                	sub    (%esi),%eax
  801849:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80184f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801856:	00 00 00 
	stat->st_dev = &devpipe;
  801859:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801860:	30 80 00 
	return 0;
}
  801863:	b8 00 00 00 00       	mov    $0x0,%eax
  801868:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186b:	5b                   	pop    %ebx
  80186c:	5e                   	pop    %esi
  80186d:	5d                   	pop    %ebp
  80186e:	c3                   	ret    

0080186f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	53                   	push   %ebx
  801873:	83 ec 0c             	sub    $0xc,%esp
  801876:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801879:	53                   	push   %ebx
  80187a:	6a 00                	push   $0x0
  80187c:	e8 0a f4 ff ff       	call   800c8b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801881:	89 1c 24             	mov    %ebx,(%esp)
  801884:	e8 b7 f7 ff ff       	call   801040 <fd2data>
  801889:	83 c4 08             	add    $0x8,%esp
  80188c:	50                   	push   %eax
  80188d:	6a 00                	push   $0x0
  80188f:	e8 f7 f3 ff ff       	call   800c8b <sys_page_unmap>
}
  801894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <_pipeisclosed>:
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	57                   	push   %edi
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
  80189f:	83 ec 1c             	sub    $0x1c,%esp
  8018a2:	89 c7                	mov    %eax,%edi
  8018a4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8018a6:	a1 08 40 80 00       	mov    0x804008,%eax
  8018ab:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8018ae:	83 ec 0c             	sub    $0xc,%esp
  8018b1:	57                   	push   %edi
  8018b2:	e8 36 05 00 00       	call   801ded <pageref>
  8018b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018ba:	89 34 24             	mov    %esi,(%esp)
  8018bd:	e8 2b 05 00 00       	call   801ded <pageref>
		nn = thisenv->env_runs;
  8018c2:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8018c8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	39 cb                	cmp    %ecx,%ebx
  8018d0:	74 1b                	je     8018ed <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8018d2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018d5:	75 cf                	jne    8018a6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8018d7:	8b 42 58             	mov    0x58(%edx),%eax
  8018da:	6a 01                	push   $0x1
  8018dc:	50                   	push   %eax
  8018dd:	53                   	push   %ebx
  8018de:	68 b6 25 80 00       	push   $0x8025b6
  8018e3:	e8 3b e9 ff ff       	call   800223 <cprintf>
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	eb b9                	jmp    8018a6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8018ed:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018f0:	0f 94 c0             	sete   %al
  8018f3:	0f b6 c0             	movzbl %al,%eax
}
  8018f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018f9:	5b                   	pop    %ebx
  8018fa:	5e                   	pop    %esi
  8018fb:	5f                   	pop    %edi
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    

008018fe <devpipe_write>:
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	57                   	push   %edi
  801902:	56                   	push   %esi
  801903:	53                   	push   %ebx
  801904:	83 ec 28             	sub    $0x28,%esp
  801907:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80190a:	56                   	push   %esi
  80190b:	e8 30 f7 ff ff       	call   801040 <fd2data>
  801910:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801912:	83 c4 10             	add    $0x10,%esp
  801915:	bf 00 00 00 00       	mov    $0x0,%edi
  80191a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80191d:	74 4f                	je     80196e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80191f:	8b 43 04             	mov    0x4(%ebx),%eax
  801922:	8b 0b                	mov    (%ebx),%ecx
  801924:	8d 51 20             	lea    0x20(%ecx),%edx
  801927:	39 d0                	cmp    %edx,%eax
  801929:	72 14                	jb     80193f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80192b:	89 da                	mov    %ebx,%edx
  80192d:	89 f0                	mov    %esi,%eax
  80192f:	e8 65 ff ff ff       	call   801899 <_pipeisclosed>
  801934:	85 c0                	test   %eax,%eax
  801936:	75 3a                	jne    801972 <devpipe_write+0x74>
			sys_yield();
  801938:	e8 aa f2 ff ff       	call   800be7 <sys_yield>
  80193d:	eb e0                	jmp    80191f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80193f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801942:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801946:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801949:	89 c2                	mov    %eax,%edx
  80194b:	c1 fa 1f             	sar    $0x1f,%edx
  80194e:	89 d1                	mov    %edx,%ecx
  801950:	c1 e9 1b             	shr    $0x1b,%ecx
  801953:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801956:	83 e2 1f             	and    $0x1f,%edx
  801959:	29 ca                	sub    %ecx,%edx
  80195b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80195f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801963:	83 c0 01             	add    $0x1,%eax
  801966:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801969:	83 c7 01             	add    $0x1,%edi
  80196c:	eb ac                	jmp    80191a <devpipe_write+0x1c>
	return i;
  80196e:	89 f8                	mov    %edi,%eax
  801970:	eb 05                	jmp    801977 <devpipe_write+0x79>
				return 0;
  801972:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801977:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80197a:	5b                   	pop    %ebx
  80197b:	5e                   	pop    %esi
  80197c:	5f                   	pop    %edi
  80197d:	5d                   	pop    %ebp
  80197e:	c3                   	ret    

0080197f <devpipe_read>:
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	57                   	push   %edi
  801983:	56                   	push   %esi
  801984:	53                   	push   %ebx
  801985:	83 ec 18             	sub    $0x18,%esp
  801988:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80198b:	57                   	push   %edi
  80198c:	e8 af f6 ff ff       	call   801040 <fd2data>
  801991:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	be 00 00 00 00       	mov    $0x0,%esi
  80199b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80199e:	74 47                	je     8019e7 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8019a0:	8b 03                	mov    (%ebx),%eax
  8019a2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8019a5:	75 22                	jne    8019c9 <devpipe_read+0x4a>
			if (i > 0)
  8019a7:	85 f6                	test   %esi,%esi
  8019a9:	75 14                	jne    8019bf <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8019ab:	89 da                	mov    %ebx,%edx
  8019ad:	89 f8                	mov    %edi,%eax
  8019af:	e8 e5 fe ff ff       	call   801899 <_pipeisclosed>
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	75 33                	jne    8019eb <devpipe_read+0x6c>
			sys_yield();
  8019b8:	e8 2a f2 ff ff       	call   800be7 <sys_yield>
  8019bd:	eb e1                	jmp    8019a0 <devpipe_read+0x21>
				return i;
  8019bf:	89 f0                	mov    %esi,%eax
}
  8019c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019c4:	5b                   	pop    %ebx
  8019c5:	5e                   	pop    %esi
  8019c6:	5f                   	pop    %edi
  8019c7:	5d                   	pop    %ebp
  8019c8:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019c9:	99                   	cltd   
  8019ca:	c1 ea 1b             	shr    $0x1b,%edx
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	83 e0 1f             	and    $0x1f,%eax
  8019d2:	29 d0                	sub    %edx,%eax
  8019d4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8019d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019dc:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8019df:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8019e2:	83 c6 01             	add    $0x1,%esi
  8019e5:	eb b4                	jmp    80199b <devpipe_read+0x1c>
	return i;
  8019e7:	89 f0                	mov    %esi,%eax
  8019e9:	eb d6                	jmp    8019c1 <devpipe_read+0x42>
				return 0;
  8019eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f0:	eb cf                	jmp    8019c1 <devpipe_read+0x42>

008019f2 <pipe>:
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	56                   	push   %esi
  8019f6:	53                   	push   %ebx
  8019f7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8019fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019fd:	50                   	push   %eax
  8019fe:	e8 54 f6 ff ff       	call   801057 <fd_alloc>
  801a03:	89 c3                	mov    %eax,%ebx
  801a05:	83 c4 10             	add    $0x10,%esp
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	78 5b                	js     801a67 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	68 07 04 00 00       	push   $0x407
  801a14:	ff 75 f4             	pushl  -0xc(%ebp)
  801a17:	6a 00                	push   $0x0
  801a19:	e8 e8 f1 ff ff       	call   800c06 <sys_page_alloc>
  801a1e:	89 c3                	mov    %eax,%ebx
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	85 c0                	test   %eax,%eax
  801a25:	78 40                	js     801a67 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801a27:	83 ec 0c             	sub    $0xc,%esp
  801a2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a2d:	50                   	push   %eax
  801a2e:	e8 24 f6 ff ff       	call   801057 <fd_alloc>
  801a33:	89 c3                	mov    %eax,%ebx
  801a35:	83 c4 10             	add    $0x10,%esp
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	78 1b                	js     801a57 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a3c:	83 ec 04             	sub    $0x4,%esp
  801a3f:	68 07 04 00 00       	push   $0x407
  801a44:	ff 75 f0             	pushl  -0x10(%ebp)
  801a47:	6a 00                	push   $0x0
  801a49:	e8 b8 f1 ff ff       	call   800c06 <sys_page_alloc>
  801a4e:	89 c3                	mov    %eax,%ebx
  801a50:	83 c4 10             	add    $0x10,%esp
  801a53:	85 c0                	test   %eax,%eax
  801a55:	79 19                	jns    801a70 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801a57:	83 ec 08             	sub    $0x8,%esp
  801a5a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a5d:	6a 00                	push   $0x0
  801a5f:	e8 27 f2 ff ff       	call   800c8b <sys_page_unmap>
  801a64:	83 c4 10             	add    $0x10,%esp
}
  801a67:	89 d8                	mov    %ebx,%eax
  801a69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a6c:	5b                   	pop    %ebx
  801a6d:	5e                   	pop    %esi
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    
	va = fd2data(fd0);
  801a70:	83 ec 0c             	sub    $0xc,%esp
  801a73:	ff 75 f4             	pushl  -0xc(%ebp)
  801a76:	e8 c5 f5 ff ff       	call   801040 <fd2data>
  801a7b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a7d:	83 c4 0c             	add    $0xc,%esp
  801a80:	68 07 04 00 00       	push   $0x407
  801a85:	50                   	push   %eax
  801a86:	6a 00                	push   $0x0
  801a88:	e8 79 f1 ff ff       	call   800c06 <sys_page_alloc>
  801a8d:	89 c3                	mov    %eax,%ebx
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	85 c0                	test   %eax,%eax
  801a94:	0f 88 8c 00 00 00    	js     801b26 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a9a:	83 ec 0c             	sub    $0xc,%esp
  801a9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801aa0:	e8 9b f5 ff ff       	call   801040 <fd2data>
  801aa5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801aac:	50                   	push   %eax
  801aad:	6a 00                	push   $0x0
  801aaf:	56                   	push   %esi
  801ab0:	6a 00                	push   $0x0
  801ab2:	e8 92 f1 ff ff       	call   800c49 <sys_page_map>
  801ab7:	89 c3                	mov    %eax,%ebx
  801ab9:	83 c4 20             	add    $0x20,%esp
  801abc:	85 c0                	test   %eax,%eax
  801abe:	78 58                	js     801b18 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ac9:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ace:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ade:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801aea:	83 ec 0c             	sub    $0xc,%esp
  801aed:	ff 75 f4             	pushl  -0xc(%ebp)
  801af0:	e8 3b f5 ff ff       	call   801030 <fd2num>
  801af5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801afa:	83 c4 04             	add    $0x4,%esp
  801afd:	ff 75 f0             	pushl  -0x10(%ebp)
  801b00:	e8 2b f5 ff ff       	call   801030 <fd2num>
  801b05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b08:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b0b:	83 c4 10             	add    $0x10,%esp
  801b0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b13:	e9 4f ff ff ff       	jmp    801a67 <pipe+0x75>
	sys_page_unmap(0, va);
  801b18:	83 ec 08             	sub    $0x8,%esp
  801b1b:	56                   	push   %esi
  801b1c:	6a 00                	push   $0x0
  801b1e:	e8 68 f1 ff ff       	call   800c8b <sys_page_unmap>
  801b23:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b26:	83 ec 08             	sub    $0x8,%esp
  801b29:	ff 75 f0             	pushl  -0x10(%ebp)
  801b2c:	6a 00                	push   $0x0
  801b2e:	e8 58 f1 ff ff       	call   800c8b <sys_page_unmap>
  801b33:	83 c4 10             	add    $0x10,%esp
  801b36:	e9 1c ff ff ff       	jmp    801a57 <pipe+0x65>

00801b3b <pipeisclosed>:
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b44:	50                   	push   %eax
  801b45:	ff 75 08             	pushl  0x8(%ebp)
  801b48:	e8 59 f5 ff ff       	call   8010a6 <fd_lookup>
  801b4d:	83 c4 10             	add    $0x10,%esp
  801b50:	85 c0                	test   %eax,%eax
  801b52:	78 18                	js     801b6c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b54:	83 ec 0c             	sub    $0xc,%esp
  801b57:	ff 75 f4             	pushl  -0xc(%ebp)
  801b5a:	e8 e1 f4 ff ff       	call   801040 <fd2data>
	return _pipeisclosed(fd, p);
  801b5f:	89 c2                	mov    %eax,%edx
  801b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b64:	e8 30 fd ff ff       	call   801899 <_pipeisclosed>
  801b69:	83 c4 10             	add    $0x10,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b71:	b8 00 00 00 00       	mov    $0x0,%eax
  801b76:	5d                   	pop    %ebp
  801b77:	c3                   	ret    

00801b78 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
  801b7b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801b7e:	68 ce 25 80 00       	push   $0x8025ce
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	e8 82 ec ff ff       	call   80080d <strcpy>
	return 0;
}
  801b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <devcons_write>:
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	57                   	push   %edi
  801b96:	56                   	push   %esi
  801b97:	53                   	push   %ebx
  801b98:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b9e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ba3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ba9:	eb 2f                	jmp    801bda <devcons_write+0x48>
		m = n - tot;
  801bab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bae:	29 f3                	sub    %esi,%ebx
  801bb0:	83 fb 7f             	cmp    $0x7f,%ebx
  801bb3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801bb8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801bbb:	83 ec 04             	sub    $0x4,%esp
  801bbe:	53                   	push   %ebx
  801bbf:	89 f0                	mov    %esi,%eax
  801bc1:	03 45 0c             	add    0xc(%ebp),%eax
  801bc4:	50                   	push   %eax
  801bc5:	57                   	push   %edi
  801bc6:	e8 d0 ed ff ff       	call   80099b <memmove>
		sys_cputs(buf, m);
  801bcb:	83 c4 08             	add    $0x8,%esp
  801bce:	53                   	push   %ebx
  801bcf:	57                   	push   %edi
  801bd0:	e8 75 ef ff ff       	call   800b4a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801bd5:	01 de                	add    %ebx,%esi
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bdd:	72 cc                	jb     801bab <devcons_write+0x19>
}
  801bdf:	89 f0                	mov    %esi,%eax
  801be1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be4:	5b                   	pop    %ebx
  801be5:	5e                   	pop    %esi
  801be6:	5f                   	pop    %edi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    

00801be9 <devcons_read>:
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 08             	sub    $0x8,%esp
  801bef:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801bf4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bf8:	75 07                	jne    801c01 <devcons_read+0x18>
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    
		sys_yield();
  801bfc:	e8 e6 ef ff ff       	call   800be7 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801c01:	e8 62 ef ff ff       	call   800b68 <sys_cgetc>
  801c06:	85 c0                	test   %eax,%eax
  801c08:	74 f2                	je     801bfc <devcons_read+0x13>
	if (c < 0)
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	78 ec                	js     801bfa <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801c0e:	83 f8 04             	cmp    $0x4,%eax
  801c11:	74 0c                	je     801c1f <devcons_read+0x36>
	*(char*)vbuf = c;
  801c13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c16:	88 02                	mov    %al,(%edx)
	return 1;
  801c18:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1d:	eb db                	jmp    801bfa <devcons_read+0x11>
		return 0;
  801c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c24:	eb d4                	jmp    801bfa <devcons_read+0x11>

00801c26 <cputchar>:
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c32:	6a 01                	push   $0x1
  801c34:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c37:	50                   	push   %eax
  801c38:	e8 0d ef ff ff       	call   800b4a <sys_cputs>
}
  801c3d:	83 c4 10             	add    $0x10,%esp
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <getchar>:
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801c48:	6a 01                	push   $0x1
  801c4a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c4d:	50                   	push   %eax
  801c4e:	6a 00                	push   $0x0
  801c50:	e8 c2 f6 ff ff       	call   801317 <read>
	if (r < 0)
  801c55:	83 c4 10             	add    $0x10,%esp
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	78 08                	js     801c64 <getchar+0x22>
	if (r < 1)
  801c5c:	85 c0                	test   %eax,%eax
  801c5e:	7e 06                	jle    801c66 <getchar+0x24>
	return c;
  801c60:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    
		return -E_EOF;
  801c66:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c6b:	eb f7                	jmp    801c64 <getchar+0x22>

00801c6d <iscons>:
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c76:	50                   	push   %eax
  801c77:	ff 75 08             	pushl  0x8(%ebp)
  801c7a:	e8 27 f4 ff ff       	call   8010a6 <fd_lookup>
  801c7f:	83 c4 10             	add    $0x10,%esp
  801c82:	85 c0                	test   %eax,%eax
  801c84:	78 11                	js     801c97 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c89:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c8f:	39 10                	cmp    %edx,(%eax)
  801c91:	0f 94 c0             	sete   %al
  801c94:	0f b6 c0             	movzbl %al,%eax
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <opencons>:
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca2:	50                   	push   %eax
  801ca3:	e8 af f3 ff ff       	call   801057 <fd_alloc>
  801ca8:	83 c4 10             	add    $0x10,%esp
  801cab:	85 c0                	test   %eax,%eax
  801cad:	78 3a                	js     801ce9 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801caf:	83 ec 04             	sub    $0x4,%esp
  801cb2:	68 07 04 00 00       	push   $0x407
  801cb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801cba:	6a 00                	push   $0x0
  801cbc:	e8 45 ef ff ff       	call   800c06 <sys_page_alloc>
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	78 21                	js     801ce9 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cd1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	50                   	push   %eax
  801ce1:	e8 4a f3 ff ff       	call   801030 <fd2num>
  801ce6:	83 c4 10             	add    $0x10,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	53                   	push   %ebx
  801cef:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801cf2:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801cf9:	74 0d                	je     801d08 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801d03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801d08:	e8 bb ee ff ff       	call   800bc8 <sys_getenvid>
  801d0d:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801d0f:	83 ec 04             	sub    $0x4,%esp
  801d12:	6a 07                	push   $0x7
  801d14:	68 00 f0 bf ee       	push   $0xeebff000
  801d19:	50                   	push   %eax
  801d1a:	e8 e7 ee ff ff       	call   800c06 <sys_page_alloc>
        	if (r < 0) {
  801d1f:	83 c4 10             	add    $0x10,%esp
  801d22:	85 c0                	test   %eax,%eax
  801d24:	78 27                	js     801d4d <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801d26:	83 ec 08             	sub    $0x8,%esp
  801d29:	68 5f 1d 80 00       	push   $0x801d5f
  801d2e:	53                   	push   %ebx
  801d2f:	e8 1d f0 ff ff       	call   800d51 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	85 c0                	test   %eax,%eax
  801d39:	79 c0                	jns    801cfb <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801d3b:	50                   	push   %eax
  801d3c:	68 da 25 80 00       	push   $0x8025da
  801d41:	6a 28                	push   $0x28
  801d43:	68 ee 25 80 00       	push   $0x8025ee
  801d48:	e8 fb e3 ff ff       	call   800148 <_panic>
            		panic("pgfault_handler: %e", r);
  801d4d:	50                   	push   %eax
  801d4e:	68 da 25 80 00       	push   $0x8025da
  801d53:	6a 24                	push   $0x24
  801d55:	68 ee 25 80 00       	push   $0x8025ee
  801d5a:	e8 e9 e3 ff ff       	call   800148 <_panic>

00801d5f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801d5f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801d60:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801d65:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801d67:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  801d6a:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801d6e:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801d71:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801d75:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  801d79:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801d7c:	83 c4 08             	add    $0x8,%esp
	popal
  801d7f:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801d80:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801d83:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801d84:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801d85:	c3                   	ret    

00801d86 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801d8c:	68 fc 25 80 00       	push   $0x8025fc
  801d91:	6a 1a                	push   $0x1a
  801d93:	68 15 26 80 00       	push   $0x802615
  801d98:	e8 ab e3 ff ff       	call   800148 <_panic>

00801d9d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801da3:	68 1f 26 80 00       	push   $0x80261f
  801da8:	6a 2a                	push   $0x2a
  801daa:	68 15 26 80 00       	push   $0x802615
  801daf:	e8 94 e3 ff ff       	call   800148 <_panic>

00801db4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801dbf:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801dc2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801dc8:	8b 52 50             	mov    0x50(%edx),%edx
  801dcb:	39 ca                	cmp    %ecx,%edx
  801dcd:	74 11                	je     801de0 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801dcf:	83 c0 01             	add    $0x1,%eax
  801dd2:	3d 00 04 00 00       	cmp    $0x400,%eax
  801dd7:	75 e6                	jne    801dbf <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dde:	eb 0b                	jmp    801deb <ipc_find_env+0x37>
			return envs[i].env_id;
  801de0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801de3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801de8:	8b 40 48             	mov    0x48(%eax),%eax
}
  801deb:	5d                   	pop    %ebp
  801dec:	c3                   	ret    

00801ded <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801df3:	89 d0                	mov    %edx,%eax
  801df5:	c1 e8 16             	shr    $0x16,%eax
  801df8:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801dff:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801e04:	f6 c1 01             	test   $0x1,%cl
  801e07:	74 1d                	je     801e26 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801e09:	c1 ea 0c             	shr    $0xc,%edx
  801e0c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e13:	f6 c2 01             	test   $0x1,%dl
  801e16:	74 0e                	je     801e26 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e18:	c1 ea 0c             	shr    $0xc,%edx
  801e1b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e22:	ef 
  801e23:	0f b7 c0             	movzwl %ax,%eax
}
  801e26:	5d                   	pop    %ebp
  801e27:	c3                   	ret    
  801e28:	66 90                	xchg   %ax,%ax
  801e2a:	66 90                	xchg   %ax,%ax
  801e2c:	66 90                	xchg   %ax,%ax
  801e2e:	66 90                	xchg   %ax,%ax

00801e30 <__udivdi3>:
  801e30:	55                   	push   %ebp
  801e31:	57                   	push   %edi
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	83 ec 1c             	sub    $0x1c,%esp
  801e37:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801e3b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801e3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e43:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e47:	85 d2                	test   %edx,%edx
  801e49:	75 35                	jne    801e80 <__udivdi3+0x50>
  801e4b:	39 f3                	cmp    %esi,%ebx
  801e4d:	0f 87 bd 00 00 00    	ja     801f10 <__udivdi3+0xe0>
  801e53:	85 db                	test   %ebx,%ebx
  801e55:	89 d9                	mov    %ebx,%ecx
  801e57:	75 0b                	jne    801e64 <__udivdi3+0x34>
  801e59:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5e:	31 d2                	xor    %edx,%edx
  801e60:	f7 f3                	div    %ebx
  801e62:	89 c1                	mov    %eax,%ecx
  801e64:	31 d2                	xor    %edx,%edx
  801e66:	89 f0                	mov    %esi,%eax
  801e68:	f7 f1                	div    %ecx
  801e6a:	89 c6                	mov    %eax,%esi
  801e6c:	89 e8                	mov    %ebp,%eax
  801e6e:	89 f7                	mov    %esi,%edi
  801e70:	f7 f1                	div    %ecx
  801e72:	89 fa                	mov    %edi,%edx
  801e74:	83 c4 1c             	add    $0x1c,%esp
  801e77:	5b                   	pop    %ebx
  801e78:	5e                   	pop    %esi
  801e79:	5f                   	pop    %edi
  801e7a:	5d                   	pop    %ebp
  801e7b:	c3                   	ret    
  801e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e80:	39 f2                	cmp    %esi,%edx
  801e82:	77 7c                	ja     801f00 <__udivdi3+0xd0>
  801e84:	0f bd fa             	bsr    %edx,%edi
  801e87:	83 f7 1f             	xor    $0x1f,%edi
  801e8a:	0f 84 98 00 00 00    	je     801f28 <__udivdi3+0xf8>
  801e90:	89 f9                	mov    %edi,%ecx
  801e92:	b8 20 00 00 00       	mov    $0x20,%eax
  801e97:	29 f8                	sub    %edi,%eax
  801e99:	d3 e2                	shl    %cl,%edx
  801e9b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e9f:	89 c1                	mov    %eax,%ecx
  801ea1:	89 da                	mov    %ebx,%edx
  801ea3:	d3 ea                	shr    %cl,%edx
  801ea5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801ea9:	09 d1                	or     %edx,%ecx
  801eab:	89 f2                	mov    %esi,%edx
  801ead:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801eb1:	89 f9                	mov    %edi,%ecx
  801eb3:	d3 e3                	shl    %cl,%ebx
  801eb5:	89 c1                	mov    %eax,%ecx
  801eb7:	d3 ea                	shr    %cl,%edx
  801eb9:	89 f9                	mov    %edi,%ecx
  801ebb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801ebf:	d3 e6                	shl    %cl,%esi
  801ec1:	89 eb                	mov    %ebp,%ebx
  801ec3:	89 c1                	mov    %eax,%ecx
  801ec5:	d3 eb                	shr    %cl,%ebx
  801ec7:	09 de                	or     %ebx,%esi
  801ec9:	89 f0                	mov    %esi,%eax
  801ecb:	f7 74 24 08          	divl   0x8(%esp)
  801ecf:	89 d6                	mov    %edx,%esi
  801ed1:	89 c3                	mov    %eax,%ebx
  801ed3:	f7 64 24 0c          	mull   0xc(%esp)
  801ed7:	39 d6                	cmp    %edx,%esi
  801ed9:	72 0c                	jb     801ee7 <__udivdi3+0xb7>
  801edb:	89 f9                	mov    %edi,%ecx
  801edd:	d3 e5                	shl    %cl,%ebp
  801edf:	39 c5                	cmp    %eax,%ebp
  801ee1:	73 5d                	jae    801f40 <__udivdi3+0x110>
  801ee3:	39 d6                	cmp    %edx,%esi
  801ee5:	75 59                	jne    801f40 <__udivdi3+0x110>
  801ee7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801eea:	31 ff                	xor    %edi,%edi
  801eec:	89 fa                	mov    %edi,%edx
  801eee:	83 c4 1c             	add    $0x1c,%esp
  801ef1:	5b                   	pop    %ebx
  801ef2:	5e                   	pop    %esi
  801ef3:	5f                   	pop    %edi
  801ef4:	5d                   	pop    %ebp
  801ef5:	c3                   	ret    
  801ef6:	8d 76 00             	lea    0x0(%esi),%esi
  801ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801f00:	31 ff                	xor    %edi,%edi
  801f02:	31 c0                	xor    %eax,%eax
  801f04:	89 fa                	mov    %edi,%edx
  801f06:	83 c4 1c             	add    $0x1c,%esp
  801f09:	5b                   	pop    %ebx
  801f0a:	5e                   	pop    %esi
  801f0b:	5f                   	pop    %edi
  801f0c:	5d                   	pop    %ebp
  801f0d:	c3                   	ret    
  801f0e:	66 90                	xchg   %ax,%ax
  801f10:	31 ff                	xor    %edi,%edi
  801f12:	89 e8                	mov    %ebp,%eax
  801f14:	89 f2                	mov    %esi,%edx
  801f16:	f7 f3                	div    %ebx
  801f18:	89 fa                	mov    %edi,%edx
  801f1a:	83 c4 1c             	add    $0x1c,%esp
  801f1d:	5b                   	pop    %ebx
  801f1e:	5e                   	pop    %esi
  801f1f:	5f                   	pop    %edi
  801f20:	5d                   	pop    %ebp
  801f21:	c3                   	ret    
  801f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f28:	39 f2                	cmp    %esi,%edx
  801f2a:	72 06                	jb     801f32 <__udivdi3+0x102>
  801f2c:	31 c0                	xor    %eax,%eax
  801f2e:	39 eb                	cmp    %ebp,%ebx
  801f30:	77 d2                	ja     801f04 <__udivdi3+0xd4>
  801f32:	b8 01 00 00 00       	mov    $0x1,%eax
  801f37:	eb cb                	jmp    801f04 <__udivdi3+0xd4>
  801f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f40:	89 d8                	mov    %ebx,%eax
  801f42:	31 ff                	xor    %edi,%edi
  801f44:	eb be                	jmp    801f04 <__udivdi3+0xd4>
  801f46:	66 90                	xchg   %ax,%ax
  801f48:	66 90                	xchg   %ax,%ax
  801f4a:	66 90                	xchg   %ax,%ax
  801f4c:	66 90                	xchg   %ax,%ax
  801f4e:	66 90                	xchg   %ax,%ax

00801f50 <__umoddi3>:
  801f50:	55                   	push   %ebp
  801f51:	57                   	push   %edi
  801f52:	56                   	push   %esi
  801f53:	53                   	push   %ebx
  801f54:	83 ec 1c             	sub    $0x1c,%esp
  801f57:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801f5b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801f5f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801f63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f67:	85 ed                	test   %ebp,%ebp
  801f69:	89 f0                	mov    %esi,%eax
  801f6b:	89 da                	mov    %ebx,%edx
  801f6d:	75 19                	jne    801f88 <__umoddi3+0x38>
  801f6f:	39 df                	cmp    %ebx,%edi
  801f71:	0f 86 b1 00 00 00    	jbe    802028 <__umoddi3+0xd8>
  801f77:	f7 f7                	div    %edi
  801f79:	89 d0                	mov    %edx,%eax
  801f7b:	31 d2                	xor    %edx,%edx
  801f7d:	83 c4 1c             	add    $0x1c,%esp
  801f80:	5b                   	pop    %ebx
  801f81:	5e                   	pop    %esi
  801f82:	5f                   	pop    %edi
  801f83:	5d                   	pop    %ebp
  801f84:	c3                   	ret    
  801f85:	8d 76 00             	lea    0x0(%esi),%esi
  801f88:	39 dd                	cmp    %ebx,%ebp
  801f8a:	77 f1                	ja     801f7d <__umoddi3+0x2d>
  801f8c:	0f bd cd             	bsr    %ebp,%ecx
  801f8f:	83 f1 1f             	xor    $0x1f,%ecx
  801f92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f96:	0f 84 b4 00 00 00    	je     802050 <__umoddi3+0x100>
  801f9c:	b8 20 00 00 00       	mov    $0x20,%eax
  801fa1:	89 c2                	mov    %eax,%edx
  801fa3:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fa7:	29 c2                	sub    %eax,%edx
  801fa9:	89 c1                	mov    %eax,%ecx
  801fab:	89 f8                	mov    %edi,%eax
  801fad:	d3 e5                	shl    %cl,%ebp
  801faf:	89 d1                	mov    %edx,%ecx
  801fb1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fb5:	d3 e8                	shr    %cl,%eax
  801fb7:	09 c5                	or     %eax,%ebp
  801fb9:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fbd:	89 c1                	mov    %eax,%ecx
  801fbf:	d3 e7                	shl    %cl,%edi
  801fc1:	89 d1                	mov    %edx,%ecx
  801fc3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801fc7:	89 df                	mov    %ebx,%edi
  801fc9:	d3 ef                	shr    %cl,%edi
  801fcb:	89 c1                	mov    %eax,%ecx
  801fcd:	89 f0                	mov    %esi,%eax
  801fcf:	d3 e3                	shl    %cl,%ebx
  801fd1:	89 d1                	mov    %edx,%ecx
  801fd3:	89 fa                	mov    %edi,%edx
  801fd5:	d3 e8                	shr    %cl,%eax
  801fd7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fdc:	09 d8                	or     %ebx,%eax
  801fde:	f7 f5                	div    %ebp
  801fe0:	d3 e6                	shl    %cl,%esi
  801fe2:	89 d1                	mov    %edx,%ecx
  801fe4:	f7 64 24 08          	mull   0x8(%esp)
  801fe8:	39 d1                	cmp    %edx,%ecx
  801fea:	89 c3                	mov    %eax,%ebx
  801fec:	89 d7                	mov    %edx,%edi
  801fee:	72 06                	jb     801ff6 <__umoddi3+0xa6>
  801ff0:	75 0e                	jne    802000 <__umoddi3+0xb0>
  801ff2:	39 c6                	cmp    %eax,%esi
  801ff4:	73 0a                	jae    802000 <__umoddi3+0xb0>
  801ff6:	2b 44 24 08          	sub    0x8(%esp),%eax
  801ffa:	19 ea                	sbb    %ebp,%edx
  801ffc:	89 d7                	mov    %edx,%edi
  801ffe:	89 c3                	mov    %eax,%ebx
  802000:	89 ca                	mov    %ecx,%edx
  802002:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802007:	29 de                	sub    %ebx,%esi
  802009:	19 fa                	sbb    %edi,%edx
  80200b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80200f:	89 d0                	mov    %edx,%eax
  802011:	d3 e0                	shl    %cl,%eax
  802013:	89 d9                	mov    %ebx,%ecx
  802015:	d3 ee                	shr    %cl,%esi
  802017:	d3 ea                	shr    %cl,%edx
  802019:	09 f0                	or     %esi,%eax
  80201b:	83 c4 1c             	add    $0x1c,%esp
  80201e:	5b                   	pop    %ebx
  80201f:	5e                   	pop    %esi
  802020:	5f                   	pop    %edi
  802021:	5d                   	pop    %ebp
  802022:	c3                   	ret    
  802023:	90                   	nop
  802024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802028:	85 ff                	test   %edi,%edi
  80202a:	89 f9                	mov    %edi,%ecx
  80202c:	75 0b                	jne    802039 <__umoddi3+0xe9>
  80202e:	b8 01 00 00 00       	mov    $0x1,%eax
  802033:	31 d2                	xor    %edx,%edx
  802035:	f7 f7                	div    %edi
  802037:	89 c1                	mov    %eax,%ecx
  802039:	89 d8                	mov    %ebx,%eax
  80203b:	31 d2                	xor    %edx,%edx
  80203d:	f7 f1                	div    %ecx
  80203f:	89 f0                	mov    %esi,%eax
  802041:	f7 f1                	div    %ecx
  802043:	e9 31 ff ff ff       	jmp    801f79 <__umoddi3+0x29>
  802048:	90                   	nop
  802049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802050:	39 dd                	cmp    %ebx,%ebp
  802052:	72 08                	jb     80205c <__umoddi3+0x10c>
  802054:	39 f7                	cmp    %esi,%edi
  802056:	0f 87 21 ff ff ff    	ja     801f7d <__umoddi3+0x2d>
  80205c:	89 da                	mov    %ebx,%edx
  80205e:	89 f0                	mov    %esi,%eax
  802060:	29 f8                	sub    %edi,%eax
  802062:	19 ea                	sbb    %ebp,%edx
  802064:	e9 14 ff ff ff       	jmp    801f7d <__umoddi3+0x2d>
