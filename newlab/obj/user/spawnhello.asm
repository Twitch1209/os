
obj/user/spawnhello.debug：     文件格式 elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 04 40 80 00       	mov    0x804004,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 40 23 80 00       	push   $0x802340
  800047:	e8 6a 01 00 00       	call   8001b6 <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 5e 23 80 00       	push   $0x80235e
  800056:	68 5e 23 80 00       	push   $0x80235e
  80005b:	e8 b4 1a 00 00       	call   801b14 <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(hello) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(hello) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 64 23 80 00       	push   $0x802364
  80006f:	6a 09                	push   $0x9
  800071:	68 7c 23 80 00       	push   $0x80237c
  800076:	e8 60 00 00 00       	call   8000db <_panic>

0080007b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800083:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800086:	e8 d0 0a 00 00       	call   800b5b <sys_getenvid>
  80008b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800090:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800093:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800098:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009d:	85 db                	test   %ebx,%ebx
  80009f:	7e 07                	jle    8000a8 <libmain+0x2d>
		binaryname = argv[0];
  8000a1:	8b 06                	mov    (%esi),%eax
  8000a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000a8:	83 ec 08             	sub    $0x8,%esp
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	e8 81 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b2:	e8 0a 00 00 00       	call   8000c1 <exit>
}
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bd:	5b                   	pop    %ebx
  8000be:	5e                   	pop    %esi
  8000bf:	5d                   	pop    %ebp
  8000c0:	c3                   	ret    

008000c1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000c7:	e8 94 0e 00 00       	call   800f60 <close_all>
	sys_env_destroy(0);
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	6a 00                	push   $0x0
  8000d1:	e8 44 0a 00 00       	call   800b1a <sys_env_destroy>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	56                   	push   %esi
  8000df:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8000e0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000e3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8000e9:	e8 6d 0a 00 00       	call   800b5b <sys_getenvid>
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 0c             	pushl  0xc(%ebp)
  8000f4:	ff 75 08             	pushl  0x8(%ebp)
  8000f7:	56                   	push   %esi
  8000f8:	50                   	push   %eax
  8000f9:	68 98 23 80 00       	push   $0x802398
  8000fe:	e8 b3 00 00 00       	call   8001b6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800103:	83 c4 18             	add    $0x18,%esp
  800106:	53                   	push   %ebx
  800107:	ff 75 10             	pushl  0x10(%ebp)
  80010a:	e8 56 00 00 00       	call   800165 <vcprintf>
	cprintf("\n");
  80010f:	c7 04 24 78 28 80 00 	movl   $0x802878,(%esp)
  800116:	e8 9b 00 00 00       	call   8001b6 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80011e:	cc                   	int3   
  80011f:	eb fd                	jmp    80011e <_panic+0x43>

00800121 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800121:	55                   	push   %ebp
  800122:	89 e5                	mov    %esp,%ebp
  800124:	53                   	push   %ebx
  800125:	83 ec 04             	sub    $0x4,%esp
  800128:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012b:	8b 13                	mov    (%ebx),%edx
  80012d:	8d 42 01             	lea    0x1(%edx),%eax
  800130:	89 03                	mov    %eax,(%ebx)
  800132:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800135:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800139:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013e:	74 09                	je     800149 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800140:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800144:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800147:	c9                   	leave  
  800148:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 ff 00 00 00       	push   $0xff
  800151:	8d 43 08             	lea    0x8(%ebx),%eax
  800154:	50                   	push   %eax
  800155:	e8 83 09 00 00       	call   800add <sys_cputs>
		b->idx = 0;
  80015a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800160:	83 c4 10             	add    $0x10,%esp
  800163:	eb db                	jmp    800140 <putch+0x1f>

00800165 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80016e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800175:	00 00 00 
	b.cnt = 0;
  800178:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018e:	50                   	push   %eax
  80018f:	68 21 01 80 00       	push   $0x800121
  800194:	e8 1a 01 00 00       	call   8002b3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800199:	83 c4 08             	add    $0x8,%esp
  80019c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	e8 2f 09 00 00       	call   800add <sys_cputs>

	return b.cnt;
}
  8001ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001bc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001bf:	50                   	push   %eax
  8001c0:	ff 75 08             	pushl  0x8(%ebp)
  8001c3:	e8 9d ff ff ff       	call   800165 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	57                   	push   %edi
  8001ce:	56                   	push   %esi
  8001cf:	53                   	push   %ebx
  8001d0:	83 ec 1c             	sub    $0x1c,%esp
  8001d3:	89 c7                	mov    %eax,%edi
  8001d5:	89 d6                	mov    %edx,%esi
  8001d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001eb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ee:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001f1:	39 d3                	cmp    %edx,%ebx
  8001f3:	72 05                	jb     8001fa <printnum+0x30>
  8001f5:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001f8:	77 7a                	ja     800274 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	ff 75 18             	pushl  0x18(%ebp)
  800200:	8b 45 14             	mov    0x14(%ebp),%eax
  800203:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800206:	53                   	push   %ebx
  800207:	ff 75 10             	pushl  0x10(%ebp)
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800210:	ff 75 e0             	pushl  -0x20(%ebp)
  800213:	ff 75 dc             	pushl  -0x24(%ebp)
  800216:	ff 75 d8             	pushl  -0x28(%ebp)
  800219:	e8 e2 1e 00 00       	call   802100 <__udivdi3>
  80021e:	83 c4 18             	add    $0x18,%esp
  800221:	52                   	push   %edx
  800222:	50                   	push   %eax
  800223:	89 f2                	mov    %esi,%edx
  800225:	89 f8                	mov    %edi,%eax
  800227:	e8 9e ff ff ff       	call   8001ca <printnum>
  80022c:	83 c4 20             	add    $0x20,%esp
  80022f:	eb 13                	jmp    800244 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	56                   	push   %esi
  800235:	ff 75 18             	pushl  0x18(%ebp)
  800238:	ff d7                	call   *%edi
  80023a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80023d:	83 eb 01             	sub    $0x1,%ebx
  800240:	85 db                	test   %ebx,%ebx
  800242:	7f ed                	jg     800231 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800244:	83 ec 08             	sub    $0x8,%esp
  800247:	56                   	push   %esi
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024e:	ff 75 e0             	pushl  -0x20(%ebp)
  800251:	ff 75 dc             	pushl  -0x24(%ebp)
  800254:	ff 75 d8             	pushl  -0x28(%ebp)
  800257:	e8 c4 1f 00 00       	call   802220 <__umoddi3>
  80025c:	83 c4 14             	add    $0x14,%esp
  80025f:	0f be 80 bb 23 80 00 	movsbl 0x8023bb(%eax),%eax
  800266:	50                   	push   %eax
  800267:	ff d7                	call   *%edi
}
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026f:	5b                   	pop    %ebx
  800270:	5e                   	pop    %esi
  800271:	5f                   	pop    %edi
  800272:	5d                   	pop    %ebp
  800273:	c3                   	ret    
  800274:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800277:	eb c4                	jmp    80023d <printnum+0x73>

00800279 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800283:	8b 10                	mov    (%eax),%edx
  800285:	3b 50 04             	cmp    0x4(%eax),%edx
  800288:	73 0a                	jae    800294 <sprintputch+0x1b>
		*b->buf++ = ch;
  80028a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028d:	89 08                	mov    %ecx,(%eax)
  80028f:	8b 45 08             	mov    0x8(%ebp),%eax
  800292:	88 02                	mov    %al,(%edx)
}
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    

00800296 <printfmt>:
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80029c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029f:	50                   	push   %eax
  8002a0:	ff 75 10             	pushl  0x10(%ebp)
  8002a3:	ff 75 0c             	pushl  0xc(%ebp)
  8002a6:	ff 75 08             	pushl  0x8(%ebp)
  8002a9:	e8 05 00 00 00       	call   8002b3 <vprintfmt>
}
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	c9                   	leave  
  8002b2:	c3                   	ret    

008002b3 <vprintfmt>:
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	57                   	push   %edi
  8002b7:	56                   	push   %esi
  8002b8:	53                   	push   %ebx
  8002b9:	83 ec 2c             	sub    $0x2c,%esp
  8002bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8002bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c5:	e9 8c 03 00 00       	jmp    800656 <vprintfmt+0x3a3>
		padc = ' ';
  8002ca:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002ce:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002d5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002dc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002e3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e8:	8d 47 01             	lea    0x1(%edi),%eax
  8002eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ee:	0f b6 17             	movzbl (%edi),%edx
  8002f1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f4:	3c 55                	cmp    $0x55,%al
  8002f6:	0f 87 dd 03 00 00    	ja     8006d9 <vprintfmt+0x426>
  8002fc:	0f b6 c0             	movzbl %al,%eax
  8002ff:	ff 24 85 00 25 80 00 	jmp    *0x802500(,%eax,4)
  800306:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800309:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80030d:	eb d9                	jmp    8002e8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800312:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800316:	eb d0                	jmp    8002e8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800318:	0f b6 d2             	movzbl %dl,%edx
  80031b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80031e:	b8 00 00 00 00       	mov    $0x0,%eax
  800323:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800326:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800329:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800330:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800333:	83 f9 09             	cmp    $0x9,%ecx
  800336:	77 55                	ja     80038d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800338:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033b:	eb e9                	jmp    800326 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80033d:	8b 45 14             	mov    0x14(%ebp),%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800345:	8b 45 14             	mov    0x14(%ebp),%eax
  800348:	8d 40 04             	lea    0x4(%eax),%eax
  80034b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800351:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800355:	79 91                	jns    8002e8 <vprintfmt+0x35>
				width = precision, precision = -1;
  800357:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800364:	eb 82                	jmp    8002e8 <vprintfmt+0x35>
  800366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800369:	85 c0                	test   %eax,%eax
  80036b:	ba 00 00 00 00       	mov    $0x0,%edx
  800370:	0f 49 d0             	cmovns %eax,%edx
  800373:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800376:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800379:	e9 6a ff ff ff       	jmp    8002e8 <vprintfmt+0x35>
  80037e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800381:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800388:	e9 5b ff ff ff       	jmp    8002e8 <vprintfmt+0x35>
  80038d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800390:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800393:	eb bc                	jmp    800351 <vprintfmt+0x9e>
			lflag++;
  800395:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039b:	e9 48 ff ff ff       	jmp    8002e8 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a3:	8d 78 04             	lea    0x4(%eax),%edi
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	53                   	push   %ebx
  8003aa:	ff 30                	pushl  (%eax)
  8003ac:	ff d6                	call   *%esi
			break;
  8003ae:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b4:	e9 9a 02 00 00       	jmp    800653 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8003b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bc:	8d 78 04             	lea    0x4(%eax),%edi
  8003bf:	8b 00                	mov    (%eax),%eax
  8003c1:	99                   	cltd   
  8003c2:	31 d0                	xor    %edx,%eax
  8003c4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c6:	83 f8 0f             	cmp    $0xf,%eax
  8003c9:	7f 23                	jg     8003ee <vprintfmt+0x13b>
  8003cb:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  8003d2:	85 d2                	test   %edx,%edx
  8003d4:	74 18                	je     8003ee <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003d6:	52                   	push   %edx
  8003d7:	68 91 27 80 00       	push   $0x802791
  8003dc:	53                   	push   %ebx
  8003dd:	56                   	push   %esi
  8003de:	e8 b3 fe ff ff       	call   800296 <printfmt>
  8003e3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e9:	e9 65 02 00 00       	jmp    800653 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8003ee:	50                   	push   %eax
  8003ef:	68 d3 23 80 00       	push   $0x8023d3
  8003f4:	53                   	push   %ebx
  8003f5:	56                   	push   %esi
  8003f6:	e8 9b fe ff ff       	call   800296 <printfmt>
  8003fb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fe:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800401:	e9 4d 02 00 00       	jmp    800653 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800406:	8b 45 14             	mov    0x14(%ebp),%eax
  800409:	83 c0 04             	add    $0x4,%eax
  80040c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80040f:	8b 45 14             	mov    0x14(%ebp),%eax
  800412:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800414:	85 ff                	test   %edi,%edi
  800416:	b8 cc 23 80 00       	mov    $0x8023cc,%eax
  80041b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80041e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800422:	0f 8e bd 00 00 00    	jle    8004e5 <vprintfmt+0x232>
  800428:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80042c:	75 0e                	jne    80043c <vprintfmt+0x189>
  80042e:	89 75 08             	mov    %esi,0x8(%ebp)
  800431:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800434:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800437:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80043a:	eb 6d                	jmp    8004a9 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 d0             	pushl  -0x30(%ebp)
  800442:	57                   	push   %edi
  800443:	e8 39 03 00 00       	call   800781 <strnlen>
  800448:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80044b:	29 c1                	sub    %eax,%ecx
  80044d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800450:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800453:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800457:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80045d:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045f:	eb 0f                	jmp    800470 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800461:	83 ec 08             	sub    $0x8,%esp
  800464:	53                   	push   %ebx
  800465:	ff 75 e0             	pushl  -0x20(%ebp)
  800468:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80046a:	83 ef 01             	sub    $0x1,%edi
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	85 ff                	test   %edi,%edi
  800472:	7f ed                	jg     800461 <vprintfmt+0x1ae>
  800474:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800477:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80047a:	85 c9                	test   %ecx,%ecx
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	0f 49 c1             	cmovns %ecx,%eax
  800484:	29 c1                	sub    %eax,%ecx
  800486:	89 75 08             	mov    %esi,0x8(%ebp)
  800489:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80048c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048f:	89 cb                	mov    %ecx,%ebx
  800491:	eb 16                	jmp    8004a9 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800493:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800497:	75 31                	jne    8004ca <vprintfmt+0x217>
					putch(ch, putdat);
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	ff 75 0c             	pushl  0xc(%ebp)
  80049f:	50                   	push   %eax
  8004a0:	ff 55 08             	call   *0x8(%ebp)
  8004a3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a6:	83 eb 01             	sub    $0x1,%ebx
  8004a9:	83 c7 01             	add    $0x1,%edi
  8004ac:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004b0:	0f be c2             	movsbl %dl,%eax
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	74 59                	je     800510 <vprintfmt+0x25d>
  8004b7:	85 f6                	test   %esi,%esi
  8004b9:	78 d8                	js     800493 <vprintfmt+0x1e0>
  8004bb:	83 ee 01             	sub    $0x1,%esi
  8004be:	79 d3                	jns    800493 <vprintfmt+0x1e0>
  8004c0:	89 df                	mov    %ebx,%edi
  8004c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c8:	eb 37                	jmp    800501 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ca:	0f be d2             	movsbl %dl,%edx
  8004cd:	83 ea 20             	sub    $0x20,%edx
  8004d0:	83 fa 5e             	cmp    $0x5e,%edx
  8004d3:	76 c4                	jbe    800499 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	ff 75 0c             	pushl  0xc(%ebp)
  8004db:	6a 3f                	push   $0x3f
  8004dd:	ff 55 08             	call   *0x8(%ebp)
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	eb c1                	jmp    8004a6 <vprintfmt+0x1f3>
  8004e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004eb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ee:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004f1:	eb b6                	jmp    8004a9 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	53                   	push   %ebx
  8004f7:	6a 20                	push   $0x20
  8004f9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fb:	83 ef 01             	sub    $0x1,%edi
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	85 ff                	test   %edi,%edi
  800503:	7f ee                	jg     8004f3 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800505:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800508:	89 45 14             	mov    %eax,0x14(%ebp)
  80050b:	e9 43 01 00 00       	jmp    800653 <vprintfmt+0x3a0>
  800510:	89 df                	mov    %ebx,%edi
  800512:	8b 75 08             	mov    0x8(%ebp),%esi
  800515:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800518:	eb e7                	jmp    800501 <vprintfmt+0x24e>
	if (lflag >= 2)
  80051a:	83 f9 01             	cmp    $0x1,%ecx
  80051d:	7e 3f                	jle    80055e <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	8b 50 04             	mov    0x4(%eax),%edx
  800525:	8b 00                	mov    (%eax),%eax
  800527:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	8d 40 08             	lea    0x8(%eax),%eax
  800533:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800536:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80053a:	79 5c                	jns    800598 <vprintfmt+0x2e5>
				putch('-', putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	6a 2d                	push   $0x2d
  800542:	ff d6                	call   *%esi
				num = -(long long) num;
  800544:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800547:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80054a:	f7 da                	neg    %edx
  80054c:	83 d1 00             	adc    $0x0,%ecx
  80054f:	f7 d9                	neg    %ecx
  800551:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800554:	b8 0a 00 00 00       	mov    $0xa,%eax
  800559:	e9 db 00 00 00       	jmp    800639 <vprintfmt+0x386>
	else if (lflag)
  80055e:	85 c9                	test   %ecx,%ecx
  800560:	75 1b                	jne    80057d <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056a:	89 c1                	mov    %eax,%ecx
  80056c:	c1 f9 1f             	sar    $0x1f,%ecx
  80056f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8d 40 04             	lea    0x4(%eax),%eax
  800578:	89 45 14             	mov    %eax,0x14(%ebp)
  80057b:	eb b9                	jmp    800536 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800585:	89 c1                	mov    %eax,%ecx
  800587:	c1 f9 1f             	sar    $0x1f,%ecx
  80058a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8d 40 04             	lea    0x4(%eax),%eax
  800593:	89 45 14             	mov    %eax,0x14(%ebp)
  800596:	eb 9e                	jmp    800536 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800598:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80059e:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a3:	e9 91 00 00 00       	jmp    800639 <vprintfmt+0x386>
	if (lflag >= 2)
  8005a8:	83 f9 01             	cmp    $0x1,%ecx
  8005ab:	7e 15                	jle    8005c2 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8b 10                	mov    (%eax),%edx
  8005b2:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b5:	8d 40 08             	lea    0x8(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c0:	eb 77                	jmp    800639 <vprintfmt+0x386>
	else if (lflag)
  8005c2:	85 c9                	test   %ecx,%ecx
  8005c4:	75 17                	jne    8005dd <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d0:	8d 40 04             	lea    0x4(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005db:	eb 5c                	jmp    800639 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 10                	mov    (%eax),%edx
  8005e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f2:	eb 45                	jmp    800639 <vprintfmt+0x386>
			putch('X', putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	53                   	push   %ebx
  8005f8:	6a 58                	push   $0x58
  8005fa:	ff d6                	call   *%esi
			putch('X', putdat);
  8005fc:	83 c4 08             	add    $0x8,%esp
  8005ff:	53                   	push   %ebx
  800600:	6a 58                	push   $0x58
  800602:	ff d6                	call   *%esi
			putch('X', putdat);
  800604:	83 c4 08             	add    $0x8,%esp
  800607:	53                   	push   %ebx
  800608:	6a 58                	push   $0x58
  80060a:	ff d6                	call   *%esi
			break;
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	eb 42                	jmp    800653 <vprintfmt+0x3a0>
			putch('0', putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	53                   	push   %ebx
  800615:	6a 30                	push   $0x30
  800617:	ff d6                	call   *%esi
			putch('x', putdat);
  800619:	83 c4 08             	add    $0x8,%esp
  80061c:	53                   	push   %ebx
  80061d:	6a 78                	push   $0x78
  80061f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 10                	mov    (%eax),%edx
  800626:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80062b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80062e:	8d 40 04             	lea    0x4(%eax),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800634:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800640:	57                   	push   %edi
  800641:	ff 75 e0             	pushl  -0x20(%ebp)
  800644:	50                   	push   %eax
  800645:	51                   	push   %ecx
  800646:	52                   	push   %edx
  800647:	89 da                	mov    %ebx,%edx
  800649:	89 f0                	mov    %esi,%eax
  80064b:	e8 7a fb ff ff       	call   8001ca <printnum>
			break;
  800650:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800653:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800656:	83 c7 01             	add    $0x1,%edi
  800659:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80065d:	83 f8 25             	cmp    $0x25,%eax
  800660:	0f 84 64 fc ff ff    	je     8002ca <vprintfmt+0x17>
			if (ch == '\0')
  800666:	85 c0                	test   %eax,%eax
  800668:	0f 84 8b 00 00 00    	je     8006f9 <vprintfmt+0x446>
			putch(ch, putdat);
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	53                   	push   %ebx
  800672:	50                   	push   %eax
  800673:	ff d6                	call   *%esi
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	eb dc                	jmp    800656 <vprintfmt+0x3a3>
	if (lflag >= 2)
  80067a:	83 f9 01             	cmp    $0x1,%ecx
  80067d:	7e 15                	jle    800694 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 10                	mov    (%eax),%edx
  800684:	8b 48 04             	mov    0x4(%eax),%ecx
  800687:	8d 40 08             	lea    0x8(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068d:	b8 10 00 00 00       	mov    $0x10,%eax
  800692:	eb a5                	jmp    800639 <vprintfmt+0x386>
	else if (lflag)
  800694:	85 c9                	test   %ecx,%ecx
  800696:	75 17                	jne    8006af <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 10                	mov    (%eax),%edx
  80069d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a2:	8d 40 04             	lea    0x4(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ad:	eb 8a                	jmp    800639 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 10                	mov    (%eax),%edx
  8006b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b9:	8d 40 04             	lea    0x4(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006bf:	b8 10 00 00 00       	mov    $0x10,%eax
  8006c4:	e9 70 ff ff ff       	jmp    800639 <vprintfmt+0x386>
			putch(ch, putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	6a 25                	push   $0x25
  8006cf:	ff d6                	call   *%esi
			break;
  8006d1:	83 c4 10             	add    $0x10,%esp
  8006d4:	e9 7a ff ff ff       	jmp    800653 <vprintfmt+0x3a0>
			putch('%', putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	6a 25                	push   $0x25
  8006df:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	89 f8                	mov    %edi,%eax
  8006e6:	eb 03                	jmp    8006eb <vprintfmt+0x438>
  8006e8:	83 e8 01             	sub    $0x1,%eax
  8006eb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ef:	75 f7                	jne    8006e8 <vprintfmt+0x435>
  8006f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006f4:	e9 5a ff ff ff       	jmp    800653 <vprintfmt+0x3a0>
}
  8006f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006fc:	5b                   	pop    %ebx
  8006fd:	5e                   	pop    %esi
  8006fe:	5f                   	pop    %edi
  8006ff:	5d                   	pop    %ebp
  800700:	c3                   	ret    

00800701 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800701:	55                   	push   %ebp
  800702:	89 e5                	mov    %esp,%ebp
  800704:	83 ec 18             	sub    $0x18,%esp
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80070d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800710:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800714:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800717:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80071e:	85 c0                	test   %eax,%eax
  800720:	74 26                	je     800748 <vsnprintf+0x47>
  800722:	85 d2                	test   %edx,%edx
  800724:	7e 22                	jle    800748 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800726:	ff 75 14             	pushl  0x14(%ebp)
  800729:	ff 75 10             	pushl  0x10(%ebp)
  80072c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80072f:	50                   	push   %eax
  800730:	68 79 02 80 00       	push   $0x800279
  800735:	e8 79 fb ff ff       	call   8002b3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80073a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80073d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800743:	83 c4 10             	add    $0x10,%esp
}
  800746:	c9                   	leave  
  800747:	c3                   	ret    
		return -E_INVAL;
  800748:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80074d:	eb f7                	jmp    800746 <vsnprintf+0x45>

0080074f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800755:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800758:	50                   	push   %eax
  800759:	ff 75 10             	pushl  0x10(%ebp)
  80075c:	ff 75 0c             	pushl  0xc(%ebp)
  80075f:	ff 75 08             	pushl  0x8(%ebp)
  800762:	e8 9a ff ff ff       	call   800701 <vsnprintf>
	va_end(ap);

	return rc;
}
  800767:	c9                   	leave  
  800768:	c3                   	ret    

00800769 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80076f:	b8 00 00 00 00       	mov    $0x0,%eax
  800774:	eb 03                	jmp    800779 <strlen+0x10>
		n++;
  800776:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800779:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80077d:	75 f7                	jne    800776 <strlen+0xd>
	return n;
}
  80077f:	5d                   	pop    %ebp
  800780:	c3                   	ret    

00800781 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800787:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078a:	b8 00 00 00 00       	mov    $0x0,%eax
  80078f:	eb 03                	jmp    800794 <strnlen+0x13>
		n++;
  800791:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800794:	39 d0                	cmp    %edx,%eax
  800796:	74 06                	je     80079e <strnlen+0x1d>
  800798:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80079c:	75 f3                	jne    800791 <strnlen+0x10>
	return n;
}
  80079e:	5d                   	pop    %ebp
  80079f:	c3                   	ret    

008007a0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	53                   	push   %ebx
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007aa:	89 c2                	mov    %eax,%edx
  8007ac:	83 c1 01             	add    $0x1,%ecx
  8007af:	83 c2 01             	add    $0x1,%edx
  8007b2:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007b6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007b9:	84 db                	test   %bl,%bl
  8007bb:	75 ef                	jne    8007ac <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007bd:	5b                   	pop    %ebx
  8007be:	5d                   	pop    %ebp
  8007bf:	c3                   	ret    

008007c0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	53                   	push   %ebx
  8007c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c7:	53                   	push   %ebx
  8007c8:	e8 9c ff ff ff       	call   800769 <strlen>
  8007cd:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	01 d8                	add    %ebx,%eax
  8007d5:	50                   	push   %eax
  8007d6:	e8 c5 ff ff ff       	call   8007a0 <strcpy>
	return dst;
}
  8007db:	89 d8                	mov    %ebx,%eax
  8007dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e0:	c9                   	leave  
  8007e1:	c3                   	ret    

008007e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	56                   	push   %esi
  8007e6:	53                   	push   %ebx
  8007e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ed:	89 f3                	mov    %esi,%ebx
  8007ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f2:	89 f2                	mov    %esi,%edx
  8007f4:	eb 0f                	jmp    800805 <strncpy+0x23>
		*dst++ = *src;
  8007f6:	83 c2 01             	add    $0x1,%edx
  8007f9:	0f b6 01             	movzbl (%ecx),%eax
  8007fc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007ff:	80 39 01             	cmpb   $0x1,(%ecx)
  800802:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800805:	39 da                	cmp    %ebx,%edx
  800807:	75 ed                	jne    8007f6 <strncpy+0x14>
	}
	return ret;
}
  800809:	89 f0                	mov    %esi,%eax
  80080b:	5b                   	pop    %ebx
  80080c:	5e                   	pop    %esi
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	56                   	push   %esi
  800813:	53                   	push   %ebx
  800814:	8b 75 08             	mov    0x8(%ebp),%esi
  800817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80081d:	89 f0                	mov    %esi,%eax
  80081f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800823:	85 c9                	test   %ecx,%ecx
  800825:	75 0b                	jne    800832 <strlcpy+0x23>
  800827:	eb 17                	jmp    800840 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800829:	83 c2 01             	add    $0x1,%edx
  80082c:	83 c0 01             	add    $0x1,%eax
  80082f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800832:	39 d8                	cmp    %ebx,%eax
  800834:	74 07                	je     80083d <strlcpy+0x2e>
  800836:	0f b6 0a             	movzbl (%edx),%ecx
  800839:	84 c9                	test   %cl,%cl
  80083b:	75 ec                	jne    800829 <strlcpy+0x1a>
		*dst = '\0';
  80083d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800840:	29 f0                	sub    %esi,%eax
}
  800842:	5b                   	pop    %ebx
  800843:	5e                   	pop    %esi
  800844:	5d                   	pop    %ebp
  800845:	c3                   	ret    

00800846 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80084f:	eb 06                	jmp    800857 <strcmp+0x11>
		p++, q++;
  800851:	83 c1 01             	add    $0x1,%ecx
  800854:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800857:	0f b6 01             	movzbl (%ecx),%eax
  80085a:	84 c0                	test   %al,%al
  80085c:	74 04                	je     800862 <strcmp+0x1c>
  80085e:	3a 02                	cmp    (%edx),%al
  800860:	74 ef                	je     800851 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800862:	0f b6 c0             	movzbl %al,%eax
  800865:	0f b6 12             	movzbl (%edx),%edx
  800868:	29 d0                	sub    %edx,%eax
}
  80086a:	5d                   	pop    %ebp
  80086b:	c3                   	ret    

0080086c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	53                   	push   %ebx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 55 0c             	mov    0xc(%ebp),%edx
  800876:	89 c3                	mov    %eax,%ebx
  800878:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80087b:	eb 06                	jmp    800883 <strncmp+0x17>
		n--, p++, q++;
  80087d:	83 c0 01             	add    $0x1,%eax
  800880:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800883:	39 d8                	cmp    %ebx,%eax
  800885:	74 16                	je     80089d <strncmp+0x31>
  800887:	0f b6 08             	movzbl (%eax),%ecx
  80088a:	84 c9                	test   %cl,%cl
  80088c:	74 04                	je     800892 <strncmp+0x26>
  80088e:	3a 0a                	cmp    (%edx),%cl
  800890:	74 eb                	je     80087d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800892:	0f b6 00             	movzbl (%eax),%eax
  800895:	0f b6 12             	movzbl (%edx),%edx
  800898:	29 d0                	sub    %edx,%eax
}
  80089a:	5b                   	pop    %ebx
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    
		return 0;
  80089d:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a2:	eb f6                	jmp    80089a <strncmp+0x2e>

008008a4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ae:	0f b6 10             	movzbl (%eax),%edx
  8008b1:	84 d2                	test   %dl,%dl
  8008b3:	74 09                	je     8008be <strchr+0x1a>
		if (*s == c)
  8008b5:	38 ca                	cmp    %cl,%dl
  8008b7:	74 0a                	je     8008c3 <strchr+0x1f>
	for (; *s; s++)
  8008b9:	83 c0 01             	add    $0x1,%eax
  8008bc:	eb f0                	jmp    8008ae <strchr+0xa>
			return (char *) s;
	return 0;
  8008be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    

008008c5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008cf:	eb 03                	jmp    8008d4 <strfind+0xf>
  8008d1:	83 c0 01             	add    $0x1,%eax
  8008d4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008d7:	38 ca                	cmp    %cl,%dl
  8008d9:	74 04                	je     8008df <strfind+0x1a>
  8008db:	84 d2                	test   %dl,%dl
  8008dd:	75 f2                	jne    8008d1 <strfind+0xc>
			break;
	return (char *) s;
}
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	57                   	push   %edi
  8008e5:	56                   	push   %esi
  8008e6:	53                   	push   %ebx
  8008e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008ed:	85 c9                	test   %ecx,%ecx
  8008ef:	74 13                	je     800904 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008f1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008f7:	75 05                	jne    8008fe <memset+0x1d>
  8008f9:	f6 c1 03             	test   $0x3,%cl
  8008fc:	74 0d                	je     80090b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800901:	fc                   	cld    
  800902:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800904:	89 f8                	mov    %edi,%eax
  800906:	5b                   	pop    %ebx
  800907:	5e                   	pop    %esi
  800908:	5f                   	pop    %edi
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    
		c &= 0xFF;
  80090b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80090f:	89 d3                	mov    %edx,%ebx
  800911:	c1 e3 08             	shl    $0x8,%ebx
  800914:	89 d0                	mov    %edx,%eax
  800916:	c1 e0 18             	shl    $0x18,%eax
  800919:	89 d6                	mov    %edx,%esi
  80091b:	c1 e6 10             	shl    $0x10,%esi
  80091e:	09 f0                	or     %esi,%eax
  800920:	09 c2                	or     %eax,%edx
  800922:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800924:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800927:	89 d0                	mov    %edx,%eax
  800929:	fc                   	cld    
  80092a:	f3 ab                	rep stos %eax,%es:(%edi)
  80092c:	eb d6                	jmp    800904 <memset+0x23>

0080092e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	57                   	push   %edi
  800932:	56                   	push   %esi
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 75 0c             	mov    0xc(%ebp),%esi
  800939:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80093c:	39 c6                	cmp    %eax,%esi
  80093e:	73 35                	jae    800975 <memmove+0x47>
  800940:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800943:	39 c2                	cmp    %eax,%edx
  800945:	76 2e                	jbe    800975 <memmove+0x47>
		s += n;
		d += n;
  800947:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80094a:	89 d6                	mov    %edx,%esi
  80094c:	09 fe                	or     %edi,%esi
  80094e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800954:	74 0c                	je     800962 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800956:	83 ef 01             	sub    $0x1,%edi
  800959:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80095c:	fd                   	std    
  80095d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80095f:	fc                   	cld    
  800960:	eb 21                	jmp    800983 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800962:	f6 c1 03             	test   $0x3,%cl
  800965:	75 ef                	jne    800956 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800967:	83 ef 04             	sub    $0x4,%edi
  80096a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80096d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800970:	fd                   	std    
  800971:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800973:	eb ea                	jmp    80095f <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800975:	89 f2                	mov    %esi,%edx
  800977:	09 c2                	or     %eax,%edx
  800979:	f6 c2 03             	test   $0x3,%dl
  80097c:	74 09                	je     800987 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80097e:	89 c7                	mov    %eax,%edi
  800980:	fc                   	cld    
  800981:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800983:	5e                   	pop    %esi
  800984:	5f                   	pop    %edi
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800987:	f6 c1 03             	test   $0x3,%cl
  80098a:	75 f2                	jne    80097e <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80098c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80098f:	89 c7                	mov    %eax,%edi
  800991:	fc                   	cld    
  800992:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800994:	eb ed                	jmp    800983 <memmove+0x55>

00800996 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800999:	ff 75 10             	pushl  0x10(%ebp)
  80099c:	ff 75 0c             	pushl  0xc(%ebp)
  80099f:	ff 75 08             	pushl  0x8(%ebp)
  8009a2:	e8 87 ff ff ff       	call   80092e <memmove>
}
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    

008009a9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	56                   	push   %esi
  8009ad:	53                   	push   %ebx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b4:	89 c6                	mov    %eax,%esi
  8009b6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009b9:	39 f0                	cmp    %esi,%eax
  8009bb:	74 1c                	je     8009d9 <memcmp+0x30>
		if (*s1 != *s2)
  8009bd:	0f b6 08             	movzbl (%eax),%ecx
  8009c0:	0f b6 1a             	movzbl (%edx),%ebx
  8009c3:	38 d9                	cmp    %bl,%cl
  8009c5:	75 08                	jne    8009cf <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009c7:	83 c0 01             	add    $0x1,%eax
  8009ca:	83 c2 01             	add    $0x1,%edx
  8009cd:	eb ea                	jmp    8009b9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009cf:	0f b6 c1             	movzbl %cl,%eax
  8009d2:	0f b6 db             	movzbl %bl,%ebx
  8009d5:	29 d8                	sub    %ebx,%eax
  8009d7:	eb 05                	jmp    8009de <memcmp+0x35>
	}

	return 0;
  8009d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009de:	5b                   	pop    %ebx
  8009df:	5e                   	pop    %esi
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009eb:	89 c2                	mov    %eax,%edx
  8009ed:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009f0:	39 d0                	cmp    %edx,%eax
  8009f2:	73 09                	jae    8009fd <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009f4:	38 08                	cmp    %cl,(%eax)
  8009f6:	74 05                	je     8009fd <memfind+0x1b>
	for (; s < ends; s++)
  8009f8:	83 c0 01             	add    $0x1,%eax
  8009fb:	eb f3                	jmp    8009f0 <memfind+0xe>
			break;
	return (void *) s;
}
  8009fd:	5d                   	pop    %ebp
  8009fe:	c3                   	ret    

008009ff <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	57                   	push   %edi
  800a03:	56                   	push   %esi
  800a04:	53                   	push   %ebx
  800a05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a08:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a0b:	eb 03                	jmp    800a10 <strtol+0x11>
		s++;
  800a0d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a10:	0f b6 01             	movzbl (%ecx),%eax
  800a13:	3c 20                	cmp    $0x20,%al
  800a15:	74 f6                	je     800a0d <strtol+0xe>
  800a17:	3c 09                	cmp    $0x9,%al
  800a19:	74 f2                	je     800a0d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a1b:	3c 2b                	cmp    $0x2b,%al
  800a1d:	74 2e                	je     800a4d <strtol+0x4e>
	int neg = 0;
  800a1f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a24:	3c 2d                	cmp    $0x2d,%al
  800a26:	74 2f                	je     800a57 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a28:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a2e:	75 05                	jne    800a35 <strtol+0x36>
  800a30:	80 39 30             	cmpb   $0x30,(%ecx)
  800a33:	74 2c                	je     800a61 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a35:	85 db                	test   %ebx,%ebx
  800a37:	75 0a                	jne    800a43 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a39:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a3e:	80 39 30             	cmpb   $0x30,(%ecx)
  800a41:	74 28                	je     800a6b <strtol+0x6c>
		base = 10;
  800a43:	b8 00 00 00 00       	mov    $0x0,%eax
  800a48:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a4b:	eb 50                	jmp    800a9d <strtol+0x9e>
		s++;
  800a4d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a50:	bf 00 00 00 00       	mov    $0x0,%edi
  800a55:	eb d1                	jmp    800a28 <strtol+0x29>
		s++, neg = 1;
  800a57:	83 c1 01             	add    $0x1,%ecx
  800a5a:	bf 01 00 00 00       	mov    $0x1,%edi
  800a5f:	eb c7                	jmp    800a28 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a61:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a65:	74 0e                	je     800a75 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a67:	85 db                	test   %ebx,%ebx
  800a69:	75 d8                	jne    800a43 <strtol+0x44>
		s++, base = 8;
  800a6b:	83 c1 01             	add    $0x1,%ecx
  800a6e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a73:	eb ce                	jmp    800a43 <strtol+0x44>
		s += 2, base = 16;
  800a75:	83 c1 02             	add    $0x2,%ecx
  800a78:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a7d:	eb c4                	jmp    800a43 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a7f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a82:	89 f3                	mov    %esi,%ebx
  800a84:	80 fb 19             	cmp    $0x19,%bl
  800a87:	77 29                	ja     800ab2 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a89:	0f be d2             	movsbl %dl,%edx
  800a8c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a8f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a92:	7d 30                	jge    800ac4 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a94:	83 c1 01             	add    $0x1,%ecx
  800a97:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a9b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a9d:	0f b6 11             	movzbl (%ecx),%edx
  800aa0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800aa3:	89 f3                	mov    %esi,%ebx
  800aa5:	80 fb 09             	cmp    $0x9,%bl
  800aa8:	77 d5                	ja     800a7f <strtol+0x80>
			dig = *s - '0';
  800aaa:	0f be d2             	movsbl %dl,%edx
  800aad:	83 ea 30             	sub    $0x30,%edx
  800ab0:	eb dd                	jmp    800a8f <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ab2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ab5:	89 f3                	mov    %esi,%ebx
  800ab7:	80 fb 19             	cmp    $0x19,%bl
  800aba:	77 08                	ja     800ac4 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800abc:	0f be d2             	movsbl %dl,%edx
  800abf:	83 ea 37             	sub    $0x37,%edx
  800ac2:	eb cb                	jmp    800a8f <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ac4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac8:	74 05                	je     800acf <strtol+0xd0>
		*endptr = (char *) s;
  800aca:	8b 75 0c             	mov    0xc(%ebp),%esi
  800acd:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	f7 da                	neg    %edx
  800ad3:	85 ff                	test   %edi,%edi
  800ad5:	0f 45 c2             	cmovne %edx,%eax
}
  800ad8:	5b                   	pop    %ebx
  800ad9:	5e                   	pop    %esi
  800ada:	5f                   	pop    %edi
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    

00800add <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	57                   	push   %edi
  800ae1:	56                   	push   %esi
  800ae2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae8:	8b 55 08             	mov    0x8(%ebp),%edx
  800aeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aee:	89 c3                	mov    %eax,%ebx
  800af0:	89 c7                	mov    %eax,%edi
  800af2:	89 c6                	mov    %eax,%esi
  800af4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800af6:	5b                   	pop    %ebx
  800af7:	5e                   	pop    %esi
  800af8:	5f                   	pop    %edi
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <sys_cgetc>:

int
sys_cgetc(void)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	57                   	push   %edi
  800aff:	56                   	push   %esi
  800b00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b01:	ba 00 00 00 00       	mov    $0x0,%edx
  800b06:	b8 01 00 00 00       	mov    $0x1,%eax
  800b0b:	89 d1                	mov    %edx,%ecx
  800b0d:	89 d3                	mov    %edx,%ebx
  800b0f:	89 d7                	mov    %edx,%edi
  800b11:	89 d6                	mov    %edx,%esi
  800b13:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b15:	5b                   	pop    %ebx
  800b16:	5e                   	pop    %esi
  800b17:	5f                   	pop    %edi
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	57                   	push   %edi
  800b1e:	56                   	push   %esi
  800b1f:	53                   	push   %ebx
  800b20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b23:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b28:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b30:	89 cb                	mov    %ecx,%ebx
  800b32:	89 cf                	mov    %ecx,%edi
  800b34:	89 ce                	mov    %ecx,%esi
  800b36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b38:	85 c0                	test   %eax,%eax
  800b3a:	7f 08                	jg     800b44 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5f                   	pop    %edi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b44:	83 ec 0c             	sub    $0xc,%esp
  800b47:	50                   	push   %eax
  800b48:	6a 03                	push   $0x3
  800b4a:	68 bf 26 80 00       	push   $0x8026bf
  800b4f:	6a 23                	push   $0x23
  800b51:	68 dc 26 80 00       	push   $0x8026dc
  800b56:	e8 80 f5 ff ff       	call   8000db <_panic>

00800b5b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	57                   	push   %edi
  800b5f:	56                   	push   %esi
  800b60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b61:	ba 00 00 00 00       	mov    $0x0,%edx
  800b66:	b8 02 00 00 00       	mov    $0x2,%eax
  800b6b:	89 d1                	mov    %edx,%ecx
  800b6d:	89 d3                	mov    %edx,%ebx
  800b6f:	89 d7                	mov    %edx,%edi
  800b71:	89 d6                	mov    %edx,%esi
  800b73:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b75:	5b                   	pop    %ebx
  800b76:	5e                   	pop    %esi
  800b77:	5f                   	pop    %edi
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <sys_yield>:

void
sys_yield(void)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	57                   	push   %edi
  800b7e:	56                   	push   %esi
  800b7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b80:	ba 00 00 00 00       	mov    $0x0,%edx
  800b85:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b8a:	89 d1                	mov    %edx,%ecx
  800b8c:	89 d3                	mov    %edx,%ebx
  800b8e:	89 d7                	mov    %edx,%edi
  800b90:	89 d6                	mov    %edx,%esi
  800b92:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b94:	5b                   	pop    %ebx
  800b95:	5e                   	pop    %esi
  800b96:	5f                   	pop    %edi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	57                   	push   %edi
  800b9d:	56                   	push   %esi
  800b9e:	53                   	push   %ebx
  800b9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba2:	be 00 00 00 00       	mov    $0x0,%esi
  800ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  800baa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bad:	b8 04 00 00 00       	mov    $0x4,%eax
  800bb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bb5:	89 f7                	mov    %esi,%edi
  800bb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bb9:	85 c0                	test   %eax,%eax
  800bbb:	7f 08                	jg     800bc5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	5f                   	pop    %edi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc5:	83 ec 0c             	sub    $0xc,%esp
  800bc8:	50                   	push   %eax
  800bc9:	6a 04                	push   $0x4
  800bcb:	68 bf 26 80 00       	push   $0x8026bf
  800bd0:	6a 23                	push   $0x23
  800bd2:	68 dc 26 80 00       	push   $0x8026dc
  800bd7:	e8 ff f4 ff ff       	call   8000db <_panic>

00800bdc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	57                   	push   %edi
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
  800be2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be5:	8b 55 08             	mov    0x8(%ebp),%edx
  800be8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800beb:	b8 05 00 00 00       	mov    $0x5,%eax
  800bf0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bf6:	8b 75 18             	mov    0x18(%ebp),%esi
  800bf9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bfb:	85 c0                	test   %eax,%eax
  800bfd:	7f 08                	jg     800c07 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5f                   	pop    %edi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c07:	83 ec 0c             	sub    $0xc,%esp
  800c0a:	50                   	push   %eax
  800c0b:	6a 05                	push   $0x5
  800c0d:	68 bf 26 80 00       	push   $0x8026bf
  800c12:	6a 23                	push   $0x23
  800c14:	68 dc 26 80 00       	push   $0x8026dc
  800c19:	e8 bd f4 ff ff       	call   8000db <_panic>

00800c1e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c32:	b8 06 00 00 00       	mov    $0x6,%eax
  800c37:	89 df                	mov    %ebx,%edi
  800c39:	89 de                	mov    %ebx,%esi
  800c3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3d:	85 c0                	test   %eax,%eax
  800c3f:	7f 08                	jg     800c49 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c49:	83 ec 0c             	sub    $0xc,%esp
  800c4c:	50                   	push   %eax
  800c4d:	6a 06                	push   $0x6
  800c4f:	68 bf 26 80 00       	push   $0x8026bf
  800c54:	6a 23                	push   $0x23
  800c56:	68 dc 26 80 00       	push   $0x8026dc
  800c5b:	e8 7b f4 ff ff       	call   8000db <_panic>

00800c60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	57                   	push   %edi
  800c64:	56                   	push   %esi
  800c65:	53                   	push   %ebx
  800c66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c74:	b8 08 00 00 00       	mov    $0x8,%eax
  800c79:	89 df                	mov    %ebx,%edi
  800c7b:	89 de                	mov    %ebx,%esi
  800c7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	7f 08                	jg     800c8b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5f                   	pop    %edi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8b:	83 ec 0c             	sub    $0xc,%esp
  800c8e:	50                   	push   %eax
  800c8f:	6a 08                	push   $0x8
  800c91:	68 bf 26 80 00       	push   $0x8026bf
  800c96:	6a 23                	push   $0x23
  800c98:	68 dc 26 80 00       	push   $0x8026dc
  800c9d:	e8 39 f4 ff ff       	call   8000db <_panic>

00800ca2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	57                   	push   %edi
  800ca6:	56                   	push   %esi
  800ca7:	53                   	push   %ebx
  800ca8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb6:	b8 09 00 00 00       	mov    $0x9,%eax
  800cbb:	89 df                	mov    %ebx,%edi
  800cbd:	89 de                	mov    %ebx,%esi
  800cbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc1:	85 c0                	test   %eax,%eax
  800cc3:	7f 08                	jg     800ccd <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc8:	5b                   	pop    %ebx
  800cc9:	5e                   	pop    %esi
  800cca:	5f                   	pop    %edi
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccd:	83 ec 0c             	sub    $0xc,%esp
  800cd0:	50                   	push   %eax
  800cd1:	6a 09                	push   $0x9
  800cd3:	68 bf 26 80 00       	push   $0x8026bf
  800cd8:	6a 23                	push   $0x23
  800cda:	68 dc 26 80 00       	push   $0x8026dc
  800cdf:	e8 f7 f3 ff ff       	call   8000db <_panic>

00800ce4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ced:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cfd:	89 df                	mov    %ebx,%edi
  800cff:	89 de                	mov    %ebx,%esi
  800d01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7f 08                	jg     800d0f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	50                   	push   %eax
  800d13:	6a 0a                	push   $0xa
  800d15:	68 bf 26 80 00       	push   $0x8026bf
  800d1a:	6a 23                	push   $0x23
  800d1c:	68 dc 26 80 00       	push   $0x8026dc
  800d21:	e8 b5 f3 ff ff       	call   8000db <_panic>

00800d26 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d32:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d37:	be 00 00 00 00       	mov    $0x0,%esi
  800d3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d42:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	57                   	push   %edi
  800d4d:	56                   	push   %esi
  800d4e:	53                   	push   %ebx
  800d4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d57:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d5f:	89 cb                	mov    %ecx,%ebx
  800d61:	89 cf                	mov    %ecx,%edi
  800d63:	89 ce                	mov    %ecx,%esi
  800d65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d67:	85 c0                	test   %eax,%eax
  800d69:	7f 08                	jg     800d73 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6e:	5b                   	pop    %ebx
  800d6f:	5e                   	pop    %esi
  800d70:	5f                   	pop    %edi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d73:	83 ec 0c             	sub    $0xc,%esp
  800d76:	50                   	push   %eax
  800d77:	6a 0d                	push   $0xd
  800d79:	68 bf 26 80 00       	push   $0x8026bf
  800d7e:	6a 23                	push   $0x23
  800d80:	68 dc 26 80 00       	push   $0x8026dc
  800d85:	e8 51 f3 ff ff       	call   8000db <_panic>

00800d8a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	05 00 00 00 30       	add    $0x30000000,%eax
  800d95:	c1 e8 0c             	shr    $0xc,%eax
}
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800da5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800daa:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800dbc:	89 c2                	mov    %eax,%edx
  800dbe:	c1 ea 16             	shr    $0x16,%edx
  800dc1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dc8:	f6 c2 01             	test   $0x1,%dl
  800dcb:	74 2a                	je     800df7 <fd_alloc+0x46>
  800dcd:	89 c2                	mov    %eax,%edx
  800dcf:	c1 ea 0c             	shr    $0xc,%edx
  800dd2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dd9:	f6 c2 01             	test   $0x1,%dl
  800ddc:	74 19                	je     800df7 <fd_alloc+0x46>
  800dde:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800de3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800de8:	75 d2                	jne    800dbc <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800dea:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800df0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800df5:	eb 07                	jmp    800dfe <fd_alloc+0x4d>
			*fd_store = fd;
  800df7:	89 01                	mov    %eax,(%ecx)
			return 0;
  800df9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e06:	83 f8 1f             	cmp    $0x1f,%eax
  800e09:	77 36                	ja     800e41 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e0b:	c1 e0 0c             	shl    $0xc,%eax
  800e0e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e13:	89 c2                	mov    %eax,%edx
  800e15:	c1 ea 16             	shr    $0x16,%edx
  800e18:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e1f:	f6 c2 01             	test   $0x1,%dl
  800e22:	74 24                	je     800e48 <fd_lookup+0x48>
  800e24:	89 c2                	mov    %eax,%edx
  800e26:	c1 ea 0c             	shr    $0xc,%edx
  800e29:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e30:	f6 c2 01             	test   $0x1,%dl
  800e33:	74 1a                	je     800e4f <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e38:	89 02                	mov    %eax,(%edx)
	return 0;
  800e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    
		return -E_INVAL;
  800e41:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e46:	eb f7                	jmp    800e3f <fd_lookup+0x3f>
		return -E_INVAL;
  800e48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e4d:	eb f0                	jmp    800e3f <fd_lookup+0x3f>
  800e4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e54:	eb e9                	jmp    800e3f <fd_lookup+0x3f>

00800e56 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	83 ec 08             	sub    $0x8,%esp
  800e5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e5f:	ba 68 27 80 00       	mov    $0x802768,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e64:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e69:	39 08                	cmp    %ecx,(%eax)
  800e6b:	74 33                	je     800ea0 <dev_lookup+0x4a>
  800e6d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800e70:	8b 02                	mov    (%edx),%eax
  800e72:	85 c0                	test   %eax,%eax
  800e74:	75 f3                	jne    800e69 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e76:	a1 04 40 80 00       	mov    0x804004,%eax
  800e7b:	8b 40 48             	mov    0x48(%eax),%eax
  800e7e:	83 ec 04             	sub    $0x4,%esp
  800e81:	51                   	push   %ecx
  800e82:	50                   	push   %eax
  800e83:	68 ec 26 80 00       	push   $0x8026ec
  800e88:	e8 29 f3 ff ff       	call   8001b6 <cprintf>
	*dev = 0;
  800e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e96:	83 c4 10             	add    $0x10,%esp
  800e99:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e9e:	c9                   	leave  
  800e9f:	c3                   	ret    
			*dev = devtab[i];
  800ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea3:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eaa:	eb f2                	jmp    800e9e <dev_lookup+0x48>

00800eac <fd_close>:
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	57                   	push   %edi
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
  800eb2:	83 ec 1c             	sub    $0x1c,%esp
  800eb5:	8b 75 08             	mov    0x8(%ebp),%esi
  800eb8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ebb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ebe:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ebf:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800ec5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ec8:	50                   	push   %eax
  800ec9:	e8 32 ff ff ff       	call   800e00 <fd_lookup>
  800ece:	89 c3                	mov    %eax,%ebx
  800ed0:	83 c4 08             	add    $0x8,%esp
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	78 05                	js     800edc <fd_close+0x30>
	    || fd != fd2)
  800ed7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800eda:	74 16                	je     800ef2 <fd_close+0x46>
		return (must_exist ? r : 0);
  800edc:	89 f8                	mov    %edi,%eax
  800ede:	84 c0                	test   %al,%al
  800ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee5:	0f 44 d8             	cmove  %eax,%ebx
}
  800ee8:	89 d8                	mov    %ebx,%eax
  800eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ef2:	83 ec 08             	sub    $0x8,%esp
  800ef5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ef8:	50                   	push   %eax
  800ef9:	ff 36                	pushl  (%esi)
  800efb:	e8 56 ff ff ff       	call   800e56 <dev_lookup>
  800f00:	89 c3                	mov    %eax,%ebx
  800f02:	83 c4 10             	add    $0x10,%esp
  800f05:	85 c0                	test   %eax,%eax
  800f07:	78 15                	js     800f1e <fd_close+0x72>
		if (dev->dev_close)
  800f09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f0c:	8b 40 10             	mov    0x10(%eax),%eax
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	74 1b                	je     800f2e <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f13:	83 ec 0c             	sub    $0xc,%esp
  800f16:	56                   	push   %esi
  800f17:	ff d0                	call   *%eax
  800f19:	89 c3                	mov    %eax,%ebx
  800f1b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	56                   	push   %esi
  800f22:	6a 00                	push   $0x0
  800f24:	e8 f5 fc ff ff       	call   800c1e <sys_page_unmap>
	return r;
  800f29:	83 c4 10             	add    $0x10,%esp
  800f2c:	eb ba                	jmp    800ee8 <fd_close+0x3c>
			r = 0;
  800f2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f33:	eb e9                	jmp    800f1e <fd_close+0x72>

00800f35 <close>:

int
close(int fdnum)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f3e:	50                   	push   %eax
  800f3f:	ff 75 08             	pushl  0x8(%ebp)
  800f42:	e8 b9 fe ff ff       	call   800e00 <fd_lookup>
  800f47:	83 c4 08             	add    $0x8,%esp
  800f4a:	85 c0                	test   %eax,%eax
  800f4c:	78 10                	js     800f5e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f4e:	83 ec 08             	sub    $0x8,%esp
  800f51:	6a 01                	push   $0x1
  800f53:	ff 75 f4             	pushl  -0xc(%ebp)
  800f56:	e8 51 ff ff ff       	call   800eac <fd_close>
  800f5b:	83 c4 10             	add    $0x10,%esp
}
  800f5e:	c9                   	leave  
  800f5f:	c3                   	ret    

00800f60 <close_all>:

void
close_all(void)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	53                   	push   %ebx
  800f64:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f67:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f6c:	83 ec 0c             	sub    $0xc,%esp
  800f6f:	53                   	push   %ebx
  800f70:	e8 c0 ff ff ff       	call   800f35 <close>
	for (i = 0; i < MAXFD; i++)
  800f75:	83 c3 01             	add    $0x1,%ebx
  800f78:	83 c4 10             	add    $0x10,%esp
  800f7b:	83 fb 20             	cmp    $0x20,%ebx
  800f7e:	75 ec                	jne    800f6c <close_all+0xc>
}
  800f80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f83:	c9                   	leave  
  800f84:	c3                   	ret    

00800f85 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
  800f8b:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f8e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f91:	50                   	push   %eax
  800f92:	ff 75 08             	pushl  0x8(%ebp)
  800f95:	e8 66 fe ff ff       	call   800e00 <fd_lookup>
  800f9a:	89 c3                	mov    %eax,%ebx
  800f9c:	83 c4 08             	add    $0x8,%esp
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	0f 88 81 00 00 00    	js     801028 <dup+0xa3>
		return r;
	close(newfdnum);
  800fa7:	83 ec 0c             	sub    $0xc,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	e8 83 ff ff ff       	call   800f35 <close>

	newfd = INDEX2FD(newfdnum);
  800fb2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fb5:	c1 e6 0c             	shl    $0xc,%esi
  800fb8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800fbe:	83 c4 04             	add    $0x4,%esp
  800fc1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fc4:	e8 d1 fd ff ff       	call   800d9a <fd2data>
  800fc9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800fcb:	89 34 24             	mov    %esi,(%esp)
  800fce:	e8 c7 fd ff ff       	call   800d9a <fd2data>
  800fd3:	83 c4 10             	add    $0x10,%esp
  800fd6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800fd8:	89 d8                	mov    %ebx,%eax
  800fda:	c1 e8 16             	shr    $0x16,%eax
  800fdd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fe4:	a8 01                	test   $0x1,%al
  800fe6:	74 11                	je     800ff9 <dup+0x74>
  800fe8:	89 d8                	mov    %ebx,%eax
  800fea:	c1 e8 0c             	shr    $0xc,%eax
  800fed:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ff4:	f6 c2 01             	test   $0x1,%dl
  800ff7:	75 39                	jne    801032 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ff9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ffc:	89 d0                	mov    %edx,%eax
  800ffe:	c1 e8 0c             	shr    $0xc,%eax
  801001:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801008:	83 ec 0c             	sub    $0xc,%esp
  80100b:	25 07 0e 00 00       	and    $0xe07,%eax
  801010:	50                   	push   %eax
  801011:	56                   	push   %esi
  801012:	6a 00                	push   $0x0
  801014:	52                   	push   %edx
  801015:	6a 00                	push   $0x0
  801017:	e8 c0 fb ff ff       	call   800bdc <sys_page_map>
  80101c:	89 c3                	mov    %eax,%ebx
  80101e:	83 c4 20             	add    $0x20,%esp
  801021:	85 c0                	test   %eax,%eax
  801023:	78 31                	js     801056 <dup+0xd1>
		goto err;

	return newfdnum;
  801025:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801028:	89 d8                	mov    %ebx,%eax
  80102a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102d:	5b                   	pop    %ebx
  80102e:	5e                   	pop    %esi
  80102f:	5f                   	pop    %edi
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801032:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801039:	83 ec 0c             	sub    $0xc,%esp
  80103c:	25 07 0e 00 00       	and    $0xe07,%eax
  801041:	50                   	push   %eax
  801042:	57                   	push   %edi
  801043:	6a 00                	push   $0x0
  801045:	53                   	push   %ebx
  801046:	6a 00                	push   $0x0
  801048:	e8 8f fb ff ff       	call   800bdc <sys_page_map>
  80104d:	89 c3                	mov    %eax,%ebx
  80104f:	83 c4 20             	add    $0x20,%esp
  801052:	85 c0                	test   %eax,%eax
  801054:	79 a3                	jns    800ff9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801056:	83 ec 08             	sub    $0x8,%esp
  801059:	56                   	push   %esi
  80105a:	6a 00                	push   $0x0
  80105c:	e8 bd fb ff ff       	call   800c1e <sys_page_unmap>
	sys_page_unmap(0, nva);
  801061:	83 c4 08             	add    $0x8,%esp
  801064:	57                   	push   %edi
  801065:	6a 00                	push   $0x0
  801067:	e8 b2 fb ff ff       	call   800c1e <sys_page_unmap>
	return r;
  80106c:	83 c4 10             	add    $0x10,%esp
  80106f:	eb b7                	jmp    801028 <dup+0xa3>

00801071 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	53                   	push   %ebx
  801075:	83 ec 14             	sub    $0x14,%esp
  801078:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80107b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80107e:	50                   	push   %eax
  80107f:	53                   	push   %ebx
  801080:	e8 7b fd ff ff       	call   800e00 <fd_lookup>
  801085:	83 c4 08             	add    $0x8,%esp
  801088:	85 c0                	test   %eax,%eax
  80108a:	78 3f                	js     8010cb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80108c:	83 ec 08             	sub    $0x8,%esp
  80108f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801092:	50                   	push   %eax
  801093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801096:	ff 30                	pushl  (%eax)
  801098:	e8 b9 fd ff ff       	call   800e56 <dev_lookup>
  80109d:	83 c4 10             	add    $0x10,%esp
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	78 27                	js     8010cb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010a7:	8b 42 08             	mov    0x8(%edx),%eax
  8010aa:	83 e0 03             	and    $0x3,%eax
  8010ad:	83 f8 01             	cmp    $0x1,%eax
  8010b0:	74 1e                	je     8010d0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8010b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b5:	8b 40 08             	mov    0x8(%eax),%eax
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	74 35                	je     8010f1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010bc:	83 ec 04             	sub    $0x4,%esp
  8010bf:	ff 75 10             	pushl  0x10(%ebp)
  8010c2:	ff 75 0c             	pushl  0xc(%ebp)
  8010c5:	52                   	push   %edx
  8010c6:	ff d0                	call   *%eax
  8010c8:	83 c4 10             	add    $0x10,%esp
}
  8010cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ce:	c9                   	leave  
  8010cf:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010d0:	a1 04 40 80 00       	mov    0x804004,%eax
  8010d5:	8b 40 48             	mov    0x48(%eax),%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	53                   	push   %ebx
  8010dc:	50                   	push   %eax
  8010dd:	68 2d 27 80 00       	push   $0x80272d
  8010e2:	e8 cf f0 ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ef:	eb da                	jmp    8010cb <read+0x5a>
		return -E_NOT_SUPP;
  8010f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8010f6:	eb d3                	jmp    8010cb <read+0x5a>

008010f8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	57                   	push   %edi
  8010fc:	56                   	push   %esi
  8010fd:	53                   	push   %ebx
  8010fe:	83 ec 0c             	sub    $0xc,%esp
  801101:	8b 7d 08             	mov    0x8(%ebp),%edi
  801104:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801107:	bb 00 00 00 00       	mov    $0x0,%ebx
  80110c:	39 f3                	cmp    %esi,%ebx
  80110e:	73 25                	jae    801135 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801110:	83 ec 04             	sub    $0x4,%esp
  801113:	89 f0                	mov    %esi,%eax
  801115:	29 d8                	sub    %ebx,%eax
  801117:	50                   	push   %eax
  801118:	89 d8                	mov    %ebx,%eax
  80111a:	03 45 0c             	add    0xc(%ebp),%eax
  80111d:	50                   	push   %eax
  80111e:	57                   	push   %edi
  80111f:	e8 4d ff ff ff       	call   801071 <read>
		if (m < 0)
  801124:	83 c4 10             	add    $0x10,%esp
  801127:	85 c0                	test   %eax,%eax
  801129:	78 08                	js     801133 <readn+0x3b>
			return m;
		if (m == 0)
  80112b:	85 c0                	test   %eax,%eax
  80112d:	74 06                	je     801135 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80112f:	01 c3                	add    %eax,%ebx
  801131:	eb d9                	jmp    80110c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801133:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801135:	89 d8                	mov    %ebx,%eax
  801137:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5f                   	pop    %edi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    

0080113f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	53                   	push   %ebx
  801143:	83 ec 14             	sub    $0x14,%esp
  801146:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801149:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80114c:	50                   	push   %eax
  80114d:	53                   	push   %ebx
  80114e:	e8 ad fc ff ff       	call   800e00 <fd_lookup>
  801153:	83 c4 08             	add    $0x8,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	78 3a                	js     801194 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80115a:	83 ec 08             	sub    $0x8,%esp
  80115d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801160:	50                   	push   %eax
  801161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801164:	ff 30                	pushl  (%eax)
  801166:	e8 eb fc ff ff       	call   800e56 <dev_lookup>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	85 c0                	test   %eax,%eax
  801170:	78 22                	js     801194 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801172:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801175:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801179:	74 1e                	je     801199 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80117b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117e:	8b 52 0c             	mov    0xc(%edx),%edx
  801181:	85 d2                	test   %edx,%edx
  801183:	74 35                	je     8011ba <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801185:	83 ec 04             	sub    $0x4,%esp
  801188:	ff 75 10             	pushl  0x10(%ebp)
  80118b:	ff 75 0c             	pushl  0xc(%ebp)
  80118e:	50                   	push   %eax
  80118f:	ff d2                	call   *%edx
  801191:	83 c4 10             	add    $0x10,%esp
}
  801194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801197:	c9                   	leave  
  801198:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801199:	a1 04 40 80 00       	mov    0x804004,%eax
  80119e:	8b 40 48             	mov    0x48(%eax),%eax
  8011a1:	83 ec 04             	sub    $0x4,%esp
  8011a4:	53                   	push   %ebx
  8011a5:	50                   	push   %eax
  8011a6:	68 49 27 80 00       	push   $0x802749
  8011ab:	e8 06 f0 ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  8011b0:	83 c4 10             	add    $0x10,%esp
  8011b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b8:	eb da                	jmp    801194 <write+0x55>
		return -E_NOT_SUPP;
  8011ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011bf:	eb d3                	jmp    801194 <write+0x55>

008011c1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011c7:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011ca:	50                   	push   %eax
  8011cb:	ff 75 08             	pushl  0x8(%ebp)
  8011ce:	e8 2d fc ff ff       	call   800e00 <fd_lookup>
  8011d3:	83 c4 08             	add    $0x8,%esp
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	78 0e                	js     8011e8 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    

008011ea <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 14             	sub    $0x14,%esp
  8011f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011f7:	50                   	push   %eax
  8011f8:	53                   	push   %ebx
  8011f9:	e8 02 fc ff ff       	call   800e00 <fd_lookup>
  8011fe:	83 c4 08             	add    $0x8,%esp
  801201:	85 c0                	test   %eax,%eax
  801203:	78 37                	js     80123c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801205:	83 ec 08             	sub    $0x8,%esp
  801208:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80120b:	50                   	push   %eax
  80120c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80120f:	ff 30                	pushl  (%eax)
  801211:	e8 40 fc ff ff       	call   800e56 <dev_lookup>
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 1f                	js     80123c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80121d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801220:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801224:	74 1b                	je     801241 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801226:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801229:	8b 52 18             	mov    0x18(%edx),%edx
  80122c:	85 d2                	test   %edx,%edx
  80122e:	74 32                	je     801262 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801230:	83 ec 08             	sub    $0x8,%esp
  801233:	ff 75 0c             	pushl  0xc(%ebp)
  801236:	50                   	push   %eax
  801237:	ff d2                	call   *%edx
  801239:	83 c4 10             	add    $0x10,%esp
}
  80123c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80123f:	c9                   	leave  
  801240:	c3                   	ret    
			thisenv->env_id, fdnum);
  801241:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801246:	8b 40 48             	mov    0x48(%eax),%eax
  801249:	83 ec 04             	sub    $0x4,%esp
  80124c:	53                   	push   %ebx
  80124d:	50                   	push   %eax
  80124e:	68 0c 27 80 00       	push   $0x80270c
  801253:	e8 5e ef ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  801258:	83 c4 10             	add    $0x10,%esp
  80125b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801260:	eb da                	jmp    80123c <ftruncate+0x52>
		return -E_NOT_SUPP;
  801262:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801267:	eb d3                	jmp    80123c <ftruncate+0x52>

00801269 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	53                   	push   %ebx
  80126d:	83 ec 14             	sub    $0x14,%esp
  801270:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801273:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801276:	50                   	push   %eax
  801277:	ff 75 08             	pushl  0x8(%ebp)
  80127a:	e8 81 fb ff ff       	call   800e00 <fd_lookup>
  80127f:	83 c4 08             	add    $0x8,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	78 4b                	js     8012d1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801286:	83 ec 08             	sub    $0x8,%esp
  801289:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128c:	50                   	push   %eax
  80128d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801290:	ff 30                	pushl  (%eax)
  801292:	e8 bf fb ff ff       	call   800e56 <dev_lookup>
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	85 c0                	test   %eax,%eax
  80129c:	78 33                	js     8012d1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80129e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012a5:	74 2f                	je     8012d6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012a7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012aa:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012b1:	00 00 00 
	stat->st_isdir = 0;
  8012b4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012bb:	00 00 00 
	stat->st_dev = dev;
  8012be:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012c4:	83 ec 08             	sub    $0x8,%esp
  8012c7:	53                   	push   %ebx
  8012c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012cb:	ff 50 14             	call   *0x14(%eax)
  8012ce:	83 c4 10             	add    $0x10,%esp
}
  8012d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    
		return -E_NOT_SUPP;
  8012d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012db:	eb f4                	jmp    8012d1 <fstat+0x68>

008012dd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	56                   	push   %esi
  8012e1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	6a 00                	push   $0x0
  8012e7:	ff 75 08             	pushl  0x8(%ebp)
  8012ea:	e8 e7 01 00 00       	call   8014d6 <open>
  8012ef:	89 c3                	mov    %eax,%ebx
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	78 1b                	js     801313 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012f8:	83 ec 08             	sub    $0x8,%esp
  8012fb:	ff 75 0c             	pushl  0xc(%ebp)
  8012fe:	50                   	push   %eax
  8012ff:	e8 65 ff ff ff       	call   801269 <fstat>
  801304:	89 c6                	mov    %eax,%esi
	close(fd);
  801306:	89 1c 24             	mov    %ebx,(%esp)
  801309:	e8 27 fc ff ff       	call   800f35 <close>
	return r;
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	89 f3                	mov    %esi,%ebx
}
  801313:	89 d8                	mov    %ebx,%eax
  801315:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801318:	5b                   	pop    %ebx
  801319:	5e                   	pop    %esi
  80131a:	5d                   	pop    %ebp
  80131b:	c3                   	ret    

0080131c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	56                   	push   %esi
  801320:	53                   	push   %ebx
  801321:	89 c6                	mov    %eax,%esi
  801323:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801325:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80132c:	74 27                	je     801355 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80132e:	6a 07                	push   $0x7
  801330:	68 00 50 80 00       	push   $0x805000
  801335:	56                   	push   %esi
  801336:	ff 35 00 40 80 00    	pushl  0x804000
  80133c:	e8 31 0d 00 00       	call   802072 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801341:	83 c4 0c             	add    $0xc,%esp
  801344:	6a 00                	push   $0x0
  801346:	53                   	push   %ebx
  801347:	6a 00                	push   $0x0
  801349:	e8 0d 0d 00 00       	call   80205b <ipc_recv>
}
  80134e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801351:	5b                   	pop    %ebx
  801352:	5e                   	pop    %esi
  801353:	5d                   	pop    %ebp
  801354:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801355:	83 ec 0c             	sub    $0xc,%esp
  801358:	6a 01                	push   $0x1
  80135a:	e8 2a 0d 00 00       	call   802089 <ipc_find_env>
  80135f:	a3 00 40 80 00       	mov    %eax,0x804000
  801364:	83 c4 10             	add    $0x10,%esp
  801367:	eb c5                	jmp    80132e <fsipc+0x12>

00801369 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	8b 40 0c             	mov    0xc(%eax),%eax
  801375:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80137a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801382:	ba 00 00 00 00       	mov    $0x0,%edx
  801387:	b8 02 00 00 00       	mov    $0x2,%eax
  80138c:	e8 8b ff ff ff       	call   80131c <fsipc>
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <devfile_flush>:
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8b 40 0c             	mov    0xc(%eax),%eax
  80139f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a9:	b8 06 00 00 00       	mov    $0x6,%eax
  8013ae:	e8 69 ff ff ff       	call   80131c <fsipc>
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <devfile_stat>:
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	53                   	push   %ebx
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8013c5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8013cf:	b8 05 00 00 00       	mov    $0x5,%eax
  8013d4:	e8 43 ff ff ff       	call   80131c <fsipc>
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	78 2c                	js     801409 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013dd:	83 ec 08             	sub    $0x8,%esp
  8013e0:	68 00 50 80 00       	push   $0x805000
  8013e5:	53                   	push   %ebx
  8013e6:	e8 b5 f3 ff ff       	call   8007a0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013eb:	a1 80 50 80 00       	mov    0x805080,%eax
  8013f0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013f6:	a1 84 50 80 00       	mov    0x805084,%eax
  8013fb:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801401:	83 c4 10             	add    $0x10,%esp
  801404:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <devfile_write>:
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 0c             	sub    $0xc,%esp
  801414:	8b 45 10             	mov    0x10(%ebp),%eax
  801417:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80141c:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801421:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801424:	8b 55 08             	mov    0x8(%ebp),%edx
  801427:	8b 52 0c             	mov    0xc(%edx),%edx
  80142a:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801430:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  801435:	50                   	push   %eax
  801436:	ff 75 0c             	pushl  0xc(%ebp)
  801439:	68 08 50 80 00       	push   $0x805008
  80143e:	e8 eb f4 ff ff       	call   80092e <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801443:	ba 00 00 00 00       	mov    $0x0,%edx
  801448:	b8 04 00 00 00       	mov    $0x4,%eax
  80144d:	e8 ca fe ff ff       	call   80131c <fsipc>
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <devfile_read>:
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	56                   	push   %esi
  801458:	53                   	push   %ebx
  801459:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8b 40 0c             	mov    0xc(%eax),%eax
  801462:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801467:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80146d:	ba 00 00 00 00       	mov    $0x0,%edx
  801472:	b8 03 00 00 00       	mov    $0x3,%eax
  801477:	e8 a0 fe ff ff       	call   80131c <fsipc>
  80147c:	89 c3                	mov    %eax,%ebx
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 1f                	js     8014a1 <devfile_read+0x4d>
	assert(r <= n);
  801482:	39 f0                	cmp    %esi,%eax
  801484:	77 24                	ja     8014aa <devfile_read+0x56>
	assert(r <= PGSIZE);
  801486:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80148b:	7f 33                	jg     8014c0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	50                   	push   %eax
  801491:	68 00 50 80 00       	push   $0x805000
  801496:	ff 75 0c             	pushl  0xc(%ebp)
  801499:	e8 90 f4 ff ff       	call   80092e <memmove>
	return r;
  80149e:	83 c4 10             	add    $0x10,%esp
}
  8014a1:	89 d8                	mov    %ebx,%eax
  8014a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a6:	5b                   	pop    %ebx
  8014a7:	5e                   	pop    %esi
  8014a8:	5d                   	pop    %ebp
  8014a9:	c3                   	ret    
	assert(r <= n);
  8014aa:	68 78 27 80 00       	push   $0x802778
  8014af:	68 7f 27 80 00       	push   $0x80277f
  8014b4:	6a 7c                	push   $0x7c
  8014b6:	68 94 27 80 00       	push   $0x802794
  8014bb:	e8 1b ec ff ff       	call   8000db <_panic>
	assert(r <= PGSIZE);
  8014c0:	68 9f 27 80 00       	push   $0x80279f
  8014c5:	68 7f 27 80 00       	push   $0x80277f
  8014ca:	6a 7d                	push   $0x7d
  8014cc:	68 94 27 80 00       	push   $0x802794
  8014d1:	e8 05 ec ff ff       	call   8000db <_panic>

008014d6 <open>:
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	56                   	push   %esi
  8014da:	53                   	push   %ebx
  8014db:	83 ec 1c             	sub    $0x1c,%esp
  8014de:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014e1:	56                   	push   %esi
  8014e2:	e8 82 f2 ff ff       	call   800769 <strlen>
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014ef:	7f 6c                	jg     80155d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8014f1:	83 ec 0c             	sub    $0xc,%esp
  8014f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f7:	50                   	push   %eax
  8014f8:	e8 b4 f8 ff ff       	call   800db1 <fd_alloc>
  8014fd:	89 c3                	mov    %eax,%ebx
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	78 3c                	js     801542 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801506:	83 ec 08             	sub    $0x8,%esp
  801509:	56                   	push   %esi
  80150a:	68 00 50 80 00       	push   $0x805000
  80150f:	e8 8c f2 ff ff       	call   8007a0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80151c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151f:	b8 01 00 00 00       	mov    $0x1,%eax
  801524:	e8 f3 fd ff ff       	call   80131c <fsipc>
  801529:	89 c3                	mov    %eax,%ebx
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 19                	js     80154b <open+0x75>
	return fd2num(fd);
  801532:	83 ec 0c             	sub    $0xc,%esp
  801535:	ff 75 f4             	pushl  -0xc(%ebp)
  801538:	e8 4d f8 ff ff       	call   800d8a <fd2num>
  80153d:	89 c3                	mov    %eax,%ebx
  80153f:	83 c4 10             	add    $0x10,%esp
}
  801542:	89 d8                	mov    %ebx,%eax
  801544:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801547:	5b                   	pop    %ebx
  801548:	5e                   	pop    %esi
  801549:	5d                   	pop    %ebp
  80154a:	c3                   	ret    
		fd_close(fd, 0);
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	6a 00                	push   $0x0
  801550:	ff 75 f4             	pushl  -0xc(%ebp)
  801553:	e8 54 f9 ff ff       	call   800eac <fd_close>
		return r;
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	eb e5                	jmp    801542 <open+0x6c>
		return -E_BAD_PATH;
  80155d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801562:	eb de                	jmp    801542 <open+0x6c>

00801564 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80156a:	ba 00 00 00 00       	mov    $0x0,%edx
  80156f:	b8 08 00 00 00       	mov    $0x8,%eax
  801574:	e8 a3 fd ff ff       	call   80131c <fsipc>
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	57                   	push   %edi
  80157f:	56                   	push   %esi
  801580:	53                   	push   %ebx
  801581:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801587:	6a 00                	push   $0x0
  801589:	ff 75 08             	pushl  0x8(%ebp)
  80158c:	e8 45 ff ff ff       	call   8014d6 <open>
  801591:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	85 c0                	test   %eax,%eax
  80159c:	0f 88 40 03 00 00    	js     8018e2 <spawn+0x367>
  8015a2:	89 c7                	mov    %eax,%edi
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8015a4:	83 ec 04             	sub    $0x4,%esp
  8015a7:	68 00 02 00 00       	push   $0x200
  8015ac:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8015b2:	50                   	push   %eax
  8015b3:	57                   	push   %edi
  8015b4:	e8 3f fb ff ff       	call   8010f8 <readn>
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	3d 00 02 00 00       	cmp    $0x200,%eax
  8015c1:	75 5d                	jne    801620 <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  8015c3:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8015ca:	45 4c 46 
  8015cd:	75 51                	jne    801620 <spawn+0xa5>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8015cf:	b8 07 00 00 00       	mov    $0x7,%eax
  8015d4:	cd 30                	int    $0x30
  8015d6:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8015dc:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8015e2:	85 c0                	test   %eax,%eax
  8015e4:	0f 88 81 04 00 00    	js     801a6b <spawn+0x4f0>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8015ea:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015ef:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8015f2:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8015f8:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8015fe:	b9 11 00 00 00       	mov    $0x11,%ecx
  801603:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801605:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80160b:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801611:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801616:	be 00 00 00 00       	mov    $0x0,%esi
  80161b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80161e:	eb 4b                	jmp    80166b <spawn+0xf0>
		close(fd);
  801620:	83 ec 0c             	sub    $0xc,%esp
  801623:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801629:	e8 07 f9 ff ff       	call   800f35 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80162e:	83 c4 0c             	add    $0xc,%esp
  801631:	68 7f 45 4c 46       	push   $0x464c457f
  801636:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80163c:	68 ab 27 80 00       	push   $0x8027ab
  801641:	e8 70 eb ff ff       	call   8001b6 <cprintf>
		return -E_NOT_EXEC;
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  801650:	ff ff ff 
  801653:	e9 8a 02 00 00       	jmp    8018e2 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	50                   	push   %eax
  80165c:	e8 08 f1 ff ff       	call   800769 <strlen>
  801661:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801665:	83 c3 01             	add    $0x1,%ebx
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801672:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801675:	85 c0                	test   %eax,%eax
  801677:	75 df                	jne    801658 <spawn+0xdd>
  801679:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  80167f:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801685:	bf 00 10 40 00       	mov    $0x401000,%edi
  80168a:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80168c:	89 fa                	mov    %edi,%edx
  80168e:	83 e2 fc             	and    $0xfffffffc,%edx
  801691:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801698:	29 c2                	sub    %eax,%edx
  80169a:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8016a0:	8d 42 f8             	lea    -0x8(%edx),%eax
  8016a3:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8016a8:	0f 86 ce 03 00 00    	jbe    801a7c <spawn+0x501>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	6a 07                	push   $0x7
  8016b3:	68 00 00 40 00       	push   $0x400000
  8016b8:	6a 00                	push   $0x0
  8016ba:	e8 da f4 ff ff       	call   800b99 <sys_page_alloc>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	0f 88 b7 03 00 00    	js     801a81 <spawn+0x506>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8016ca:	be 00 00 00 00       	mov    $0x0,%esi
  8016cf:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  8016d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016d8:	eb 30                	jmp    80170a <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  8016da:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8016e0:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8016e6:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8016ef:	57                   	push   %edi
  8016f0:	e8 ab f0 ff ff       	call   8007a0 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8016f5:	83 c4 04             	add    $0x4,%esp
  8016f8:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8016fb:	e8 69 f0 ff ff       	call   800769 <strlen>
  801700:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801704:	83 c6 01             	add    $0x1,%esi
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	39 b5 88 fd ff ff    	cmp    %esi,-0x278(%ebp)
  801710:	7f c8                	jg     8016da <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801712:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801718:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80171e:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801725:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80172b:	0f 85 8c 00 00 00    	jne    8017bd <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801731:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801737:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80173d:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801740:	89 f8                	mov    %edi,%eax
  801742:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801748:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80174b:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801750:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801756:	83 ec 0c             	sub    $0xc,%esp
  801759:	6a 07                	push   $0x7
  80175b:	68 00 d0 bf ee       	push   $0xeebfd000
  801760:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801766:	68 00 00 40 00       	push   $0x400000
  80176b:	6a 00                	push   $0x0
  80176d:	e8 6a f4 ff ff       	call   800bdc <sys_page_map>
  801772:	89 c3                	mov    %eax,%ebx
  801774:	83 c4 20             	add    $0x20,%esp
  801777:	85 c0                	test   %eax,%eax
  801779:	0f 88 78 03 00 00    	js     801af7 <spawn+0x57c>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80177f:	83 ec 08             	sub    $0x8,%esp
  801782:	68 00 00 40 00       	push   $0x400000
  801787:	6a 00                	push   $0x0
  801789:	e8 90 f4 ff ff       	call   800c1e <sys_page_unmap>
  80178e:	89 c3                	mov    %eax,%ebx
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	85 c0                	test   %eax,%eax
  801795:	0f 88 5c 03 00 00    	js     801af7 <spawn+0x57c>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80179b:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8017a1:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8017a8:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8017ae:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8017b5:	00 00 00 
  8017b8:	e9 56 01 00 00       	jmp    801913 <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8017bd:	68 38 28 80 00       	push   $0x802838
  8017c2:	68 7f 27 80 00       	push   $0x80277f
  8017c7:	68 f2 00 00 00       	push   $0xf2
  8017cc:	68 c5 27 80 00       	push   $0x8027c5
  8017d1:	e8 05 e9 ff ff       	call   8000db <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8017d6:	83 ec 04             	sub    $0x4,%esp
  8017d9:	6a 07                	push   $0x7
  8017db:	68 00 00 40 00       	push   $0x400000
  8017e0:	6a 00                	push   $0x0
  8017e2:	e8 b2 f3 ff ff       	call   800b99 <sys_page_alloc>
  8017e7:	83 c4 10             	add    $0x10,%esp
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	0f 88 9a 02 00 00    	js     801a8c <spawn+0x511>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8017f2:	83 ec 08             	sub    $0x8,%esp
  8017f5:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8017fb:	01 f0                	add    %esi,%eax
  8017fd:	50                   	push   %eax
  8017fe:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801804:	e8 b8 f9 ff ff       	call   8011c1 <seek>
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	85 c0                	test   %eax,%eax
  80180e:	0f 88 7f 02 00 00    	js     801a93 <spawn+0x518>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80181d:	29 f0                	sub    %esi,%eax
  80181f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801824:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801829:	0f 47 c1             	cmova  %ecx,%eax
  80182c:	50                   	push   %eax
  80182d:	68 00 00 40 00       	push   $0x400000
  801832:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801838:	e8 bb f8 ff ff       	call   8010f8 <readn>
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	85 c0                	test   %eax,%eax
  801842:	0f 88 52 02 00 00    	js     801a9a <spawn+0x51f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801848:	83 ec 0c             	sub    $0xc,%esp
  80184b:	57                   	push   %edi
  80184c:	03 b5 84 fd ff ff    	add    -0x27c(%ebp),%esi
  801852:	56                   	push   %esi
  801853:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801859:	68 00 00 40 00       	push   $0x400000
  80185e:	6a 00                	push   $0x0
  801860:	e8 77 f3 ff ff       	call   800bdc <sys_page_map>
  801865:	83 c4 20             	add    $0x20,%esp
  801868:	85 c0                	test   %eax,%eax
  80186a:	0f 88 80 00 00 00    	js     8018f0 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801870:	83 ec 08             	sub    $0x8,%esp
  801873:	68 00 00 40 00       	push   $0x400000
  801878:	6a 00                	push   $0x0
  80187a:	e8 9f f3 ff ff       	call   800c1e <sys_page_unmap>
  80187f:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801882:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801888:	89 de                	mov    %ebx,%esi
  80188a:	39 9d 88 fd ff ff    	cmp    %ebx,-0x278(%ebp)
  801890:	76 73                	jbe    801905 <spawn+0x38a>
		if (i >= filesz) {
  801892:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801898:	0f 87 38 ff ff ff    	ja     8017d6 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	57                   	push   %edi
  8018a2:	03 b5 84 fd ff ff    	add    -0x27c(%ebp),%esi
  8018a8:	56                   	push   %esi
  8018a9:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8018af:	e8 e5 f2 ff ff       	call   800b99 <sys_page_alloc>
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	79 c7                	jns    801882 <spawn+0x307>
  8018bb:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8018bd:	83 ec 0c             	sub    $0xc,%esp
  8018c0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8018c6:	e8 4f f2 ff ff       	call   800b1a <sys_env_destroy>
	close(fd);
  8018cb:	83 c4 04             	add    $0x4,%esp
  8018ce:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8018d4:	e8 5c f6 ff ff       	call   800f35 <close>
	return r;
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  8018e2:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8018e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018eb:	5b                   	pop    %ebx
  8018ec:	5e                   	pop    %esi
  8018ed:	5f                   	pop    %edi
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  8018f0:	50                   	push   %eax
  8018f1:	68 d1 27 80 00       	push   $0x8027d1
  8018f6:	68 25 01 00 00       	push   $0x125
  8018fb:	68 c5 27 80 00       	push   $0x8027c5
  801900:	e8 d6 e7 ff ff       	call   8000db <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801905:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  80190c:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801913:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80191a:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801920:	7e 71                	jle    801993 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801922:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801928:	83 39 01             	cmpl   $0x1,(%ecx)
  80192b:	75 d8                	jne    801905 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80192d:	8b 41 18             	mov    0x18(%ecx),%eax
  801930:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801933:	83 f8 01             	cmp    $0x1,%eax
  801936:	19 ff                	sbb    %edi,%edi
  801938:	83 e7 fe             	and    $0xfffffffe,%edi
  80193b:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80193e:	8b 71 04             	mov    0x4(%ecx),%esi
  801941:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801947:	8b 59 10             	mov    0x10(%ecx),%ebx
  80194a:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801950:	8b 41 14             	mov    0x14(%ecx),%eax
  801953:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801959:	8b 51 08             	mov    0x8(%ecx),%edx
  80195c:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
	if ((i = PGOFF(va))) {
  801962:	89 d0                	mov    %edx,%eax
  801964:	25 ff 0f 00 00       	and    $0xfff,%eax
  801969:	74 1e                	je     801989 <spawn+0x40e>
		va -= i;
  80196b:	29 c2                	sub    %eax,%edx
  80196d:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
		memsz += i;
  801973:	01 85 88 fd ff ff    	add    %eax,-0x278(%ebp)
		filesz += i;
  801979:	01 c3                	add    %eax,%ebx
  80197b:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  801981:	29 c6                	sub    %eax,%esi
  801983:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801989:	bb 00 00 00 00       	mov    $0x0,%ebx
  80198e:	e9 f5 fe ff ff       	jmp    801888 <spawn+0x30d>
	close(fd);
  801993:	83 ec 0c             	sub    $0xc,%esp
  801996:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80199c:	e8 94 f5 ff ff       	call   800f35 <close>
  8019a1:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i, j, pn, r;

        for (i = PDX(UTEXT); i < PDX(UXSTACKTOP); i++) {
  8019a4:	bf 02 00 00 00       	mov    $0x2,%edi
  8019a9:	eb 7c                	jmp    801a27 <spawn+0x4ac>
  8019ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
                if (uvpd[i] & PTE_P) {
                        for (j = 0; j < NPTENTRIES; j++) {
  8019b1:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  8019b7:	74 63                	je     801a1c <spawn+0x4a1>
                                pn = PGNUM(PGADDR(i, j, 0));
  8019b9:	89 da                	mov    %ebx,%edx
  8019bb:	09 f2                	or     %esi,%edx
  8019bd:	89 d0                	mov    %edx,%eax
  8019bf:	c1 e8 0c             	shr    $0xc,%eax
                                if (pn == PGNUM(UXSTACKTOP - PGSIZE))
  8019c2:	3d ff eb 0e 00       	cmp    $0xeebff,%eax
  8019c7:	74 53                	je     801a1c <spawn+0x4a1>
                                        break;
                                if ((uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
  8019c9:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  8019d0:	f6 c1 01             	test   $0x1,%cl
  8019d3:	74 d6                	je     8019ab <spawn+0x430>
  8019d5:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  8019dc:	f6 c5 04             	test   $0x4,%ch
  8019df:	74 ca                	je     8019ab <spawn+0x430>
                                        if ((r = sys_page_map(0, (void *)PGADDR(i, j, 0), child, (void *)PGADDR(i, j, 0), uvpt[pn] & PTE_SYSCALL)) < 0)
  8019e1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019e8:	83 ec 0c             	sub    $0xc,%esp
  8019eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8019f0:	50                   	push   %eax
  8019f1:	52                   	push   %edx
  8019f2:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8019f8:	52                   	push   %edx
  8019f9:	6a 00                	push   $0x0
  8019fb:	e8 dc f1 ff ff       	call   800bdc <sys_page_map>
  801a00:	83 c4 20             	add    $0x20,%esp
  801a03:	85 c0                	test   %eax,%eax
  801a05:	79 a4                	jns    8019ab <spawn+0x430>
		panic("copy_shared_pages: %e", r);
  801a07:	50                   	push   %eax
  801a08:	68 1f 28 80 00       	push   $0x80281f
  801a0d:	68 82 00 00 00       	push   $0x82
  801a12:	68 c5 27 80 00       	push   $0x8027c5
  801a17:	e8 bf e6 ff ff       	call   8000db <_panic>
        for (i = PDX(UTEXT); i < PDX(UXSTACKTOP); i++) {
  801a1c:	83 c7 01             	add    $0x1,%edi
  801a1f:	81 ff bb 03 00 00    	cmp    $0x3bb,%edi
  801a25:	74 7a                	je     801aa1 <spawn+0x526>
                if (uvpd[i] & PTE_P) {
  801a27:	8b 04 bd 00 d0 7b ef 	mov    -0x10843000(,%edi,4),%eax
  801a2e:	a8 01                	test   $0x1,%al
  801a30:	74 ea                	je     801a1c <spawn+0x4a1>
  801a32:	89 fe                	mov    %edi,%esi
  801a34:	c1 e6 16             	shl    $0x16,%esi
  801a37:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a3c:	e9 78 ff ff ff       	jmp    8019b9 <spawn+0x43e>
		panic("sys_env_set_trapframe: %e", r);
  801a41:	50                   	push   %eax
  801a42:	68 ee 27 80 00       	push   $0x8027ee
  801a47:	68 86 00 00 00       	push   $0x86
  801a4c:	68 c5 27 80 00       	push   $0x8027c5
  801a51:	e8 85 e6 ff ff       	call   8000db <_panic>
		panic("sys_env_set_status: %e", r);
  801a56:	50                   	push   %eax
  801a57:	68 08 28 80 00       	push   $0x802808
  801a5c:	68 89 00 00 00       	push   $0x89
  801a61:	68 c5 27 80 00       	push   $0x8027c5
  801a66:	e8 70 e6 ff ff       	call   8000db <_panic>
		return r;
  801a6b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801a71:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801a77:	e9 66 fe ff ff       	jmp    8018e2 <spawn+0x367>
		return -E_NO_MEM;
  801a7c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801a81:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801a87:	e9 56 fe ff ff       	jmp    8018e2 <spawn+0x367>
  801a8c:	89 c7                	mov    %eax,%edi
  801a8e:	e9 2a fe ff ff       	jmp    8018bd <spawn+0x342>
  801a93:	89 c7                	mov    %eax,%edi
  801a95:	e9 23 fe ff ff       	jmp    8018bd <spawn+0x342>
  801a9a:	89 c7                	mov    %eax,%edi
  801a9c:	e9 1c fe ff ff       	jmp    8018bd <spawn+0x342>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801aa1:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801aa8:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801aab:	83 ec 08             	sub    $0x8,%esp
  801aae:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801ab4:	50                   	push   %eax
  801ab5:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801abb:	e8 e2 f1 ff ff       	call   800ca2 <sys_env_set_trapframe>
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	0f 88 76 ff ff ff    	js     801a41 <spawn+0x4c6>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801acb:	83 ec 08             	sub    $0x8,%esp
  801ace:	6a 02                	push   $0x2
  801ad0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ad6:	e8 85 f1 ff ff       	call   800c60 <sys_env_set_status>
  801adb:	83 c4 10             	add    $0x10,%esp
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	0f 88 70 ff ff ff    	js     801a56 <spawn+0x4db>
	return child;
  801ae6:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801aec:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801af2:	e9 eb fd ff ff       	jmp    8018e2 <spawn+0x367>
	sys_page_unmap(0, UTEMP);
  801af7:	83 ec 08             	sub    $0x8,%esp
  801afa:	68 00 00 40 00       	push   $0x400000
  801aff:	6a 00                	push   $0x0
  801b01:	e8 18 f1 ff ff       	call   800c1e <sys_page_unmap>
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801b0f:	e9 ce fd ff ff       	jmp    8018e2 <spawn+0x367>

00801b14 <spawnl>:
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	57                   	push   %edi
  801b18:	56                   	push   %esi
  801b19:	53                   	push   %ebx
  801b1a:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801b1d:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801b20:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801b25:	eb 05                	jmp    801b2c <spawnl+0x18>
		argc++;
  801b27:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801b2a:	89 ca                	mov    %ecx,%edx
  801b2c:	8d 4a 04             	lea    0x4(%edx),%ecx
  801b2f:	83 3a 00             	cmpl   $0x0,(%edx)
  801b32:	75 f3                	jne    801b27 <spawnl+0x13>
	const char *argv[argc+2];
  801b34:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801b3b:	83 e2 f0             	and    $0xfffffff0,%edx
  801b3e:	29 d4                	sub    %edx,%esp
  801b40:	8d 54 24 03          	lea    0x3(%esp),%edx
  801b44:	c1 ea 02             	shr    $0x2,%edx
  801b47:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801b4e:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801b50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b53:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801b5a:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801b61:	00 
	va_start(vl, arg0);
  801b62:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801b65:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801b67:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6c:	eb 0b                	jmp    801b79 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801b6e:	83 c0 01             	add    $0x1,%eax
  801b71:	8b 39                	mov    (%ecx),%edi
  801b73:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801b76:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801b79:	39 d0                	cmp    %edx,%eax
  801b7b:	75 f1                	jne    801b6e <spawnl+0x5a>
	return spawn(prog, argv);
  801b7d:	83 ec 08             	sub    $0x8,%esp
  801b80:	56                   	push   %esi
  801b81:	ff 75 08             	pushl  0x8(%ebp)
  801b84:	e8 f2 f9 ff ff       	call   80157b <spawn>
}
  801b89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b8c:	5b                   	pop    %ebx
  801b8d:	5e                   	pop    %esi
  801b8e:	5f                   	pop    %edi
  801b8f:	5d                   	pop    %ebp
  801b90:	c3                   	ret    

00801b91 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	56                   	push   %esi
  801b95:	53                   	push   %ebx
  801b96:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b99:	83 ec 0c             	sub    $0xc,%esp
  801b9c:	ff 75 08             	pushl  0x8(%ebp)
  801b9f:	e8 f6 f1 ff ff       	call   800d9a <fd2data>
  801ba4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ba6:	83 c4 08             	add    $0x8,%esp
  801ba9:	68 60 28 80 00       	push   $0x802860
  801bae:	53                   	push   %ebx
  801baf:	e8 ec eb ff ff       	call   8007a0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bb4:	8b 46 04             	mov    0x4(%esi),%eax
  801bb7:	2b 06                	sub    (%esi),%eax
  801bb9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bbf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bc6:	00 00 00 
	stat->st_dev = &devpipe;
  801bc9:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801bd0:	30 80 00 
	return 0;
}
  801bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5e                   	pop    %esi
  801bdd:	5d                   	pop    %ebp
  801bde:	c3                   	ret    

00801bdf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	53                   	push   %ebx
  801be3:	83 ec 0c             	sub    $0xc,%esp
  801be6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801be9:	53                   	push   %ebx
  801bea:	6a 00                	push   $0x0
  801bec:	e8 2d f0 ff ff       	call   800c1e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bf1:	89 1c 24             	mov    %ebx,(%esp)
  801bf4:	e8 a1 f1 ff ff       	call   800d9a <fd2data>
  801bf9:	83 c4 08             	add    $0x8,%esp
  801bfc:	50                   	push   %eax
  801bfd:	6a 00                	push   $0x0
  801bff:	e8 1a f0 ff ff       	call   800c1e <sys_page_unmap>
}
  801c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <_pipeisclosed>:
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	57                   	push   %edi
  801c0d:	56                   	push   %esi
  801c0e:	53                   	push   %ebx
  801c0f:	83 ec 1c             	sub    $0x1c,%esp
  801c12:	89 c7                	mov    %eax,%edi
  801c14:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c16:	a1 04 40 80 00       	mov    0x804004,%eax
  801c1b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c1e:	83 ec 0c             	sub    $0xc,%esp
  801c21:	57                   	push   %edi
  801c22:	e8 9b 04 00 00       	call   8020c2 <pageref>
  801c27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c2a:	89 34 24             	mov    %esi,(%esp)
  801c2d:	e8 90 04 00 00       	call   8020c2 <pageref>
		nn = thisenv->env_runs;
  801c32:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c38:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c3b:	83 c4 10             	add    $0x10,%esp
  801c3e:	39 cb                	cmp    %ecx,%ebx
  801c40:	74 1b                	je     801c5d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c42:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c45:	75 cf                	jne    801c16 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c47:	8b 42 58             	mov    0x58(%edx),%eax
  801c4a:	6a 01                	push   $0x1
  801c4c:	50                   	push   %eax
  801c4d:	53                   	push   %ebx
  801c4e:	68 67 28 80 00       	push   $0x802867
  801c53:	e8 5e e5 ff ff       	call   8001b6 <cprintf>
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	eb b9                	jmp    801c16 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c5d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c60:	0f 94 c0             	sete   %al
  801c63:	0f b6 c0             	movzbl %al,%eax
}
  801c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c69:	5b                   	pop    %ebx
  801c6a:	5e                   	pop    %esi
  801c6b:	5f                   	pop    %edi
  801c6c:	5d                   	pop    %ebp
  801c6d:	c3                   	ret    

00801c6e <devpipe_write>:
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	57                   	push   %edi
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	83 ec 28             	sub    $0x28,%esp
  801c77:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c7a:	56                   	push   %esi
  801c7b:	e8 1a f1 ff ff       	call   800d9a <fd2data>
  801c80:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	bf 00 00 00 00       	mov    $0x0,%edi
  801c8a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c8d:	74 4f                	je     801cde <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c8f:	8b 43 04             	mov    0x4(%ebx),%eax
  801c92:	8b 0b                	mov    (%ebx),%ecx
  801c94:	8d 51 20             	lea    0x20(%ecx),%edx
  801c97:	39 d0                	cmp    %edx,%eax
  801c99:	72 14                	jb     801caf <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c9b:	89 da                	mov    %ebx,%edx
  801c9d:	89 f0                	mov    %esi,%eax
  801c9f:	e8 65 ff ff ff       	call   801c09 <_pipeisclosed>
  801ca4:	85 c0                	test   %eax,%eax
  801ca6:	75 3a                	jne    801ce2 <devpipe_write+0x74>
			sys_yield();
  801ca8:	e8 cd ee ff ff       	call   800b7a <sys_yield>
  801cad:	eb e0                	jmp    801c8f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801caf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cb6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cb9:	89 c2                	mov    %eax,%edx
  801cbb:	c1 fa 1f             	sar    $0x1f,%edx
  801cbe:	89 d1                	mov    %edx,%ecx
  801cc0:	c1 e9 1b             	shr    $0x1b,%ecx
  801cc3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cc6:	83 e2 1f             	and    $0x1f,%edx
  801cc9:	29 ca                	sub    %ecx,%edx
  801ccb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ccf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801cd3:	83 c0 01             	add    $0x1,%eax
  801cd6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cd9:	83 c7 01             	add    $0x1,%edi
  801cdc:	eb ac                	jmp    801c8a <devpipe_write+0x1c>
	return i;
  801cde:	89 f8                	mov    %edi,%eax
  801ce0:	eb 05                	jmp    801ce7 <devpipe_write+0x79>
				return 0;
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cea:	5b                   	pop    %ebx
  801ceb:	5e                   	pop    %esi
  801cec:	5f                   	pop    %edi
  801ced:	5d                   	pop    %ebp
  801cee:	c3                   	ret    

00801cef <devpipe_read>:
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	57                   	push   %edi
  801cf3:	56                   	push   %esi
  801cf4:	53                   	push   %ebx
  801cf5:	83 ec 18             	sub    $0x18,%esp
  801cf8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cfb:	57                   	push   %edi
  801cfc:	e8 99 f0 ff ff       	call   800d9a <fd2data>
  801d01:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d03:	83 c4 10             	add    $0x10,%esp
  801d06:	be 00 00 00 00       	mov    $0x0,%esi
  801d0b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d0e:	74 47                	je     801d57 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801d10:	8b 03                	mov    (%ebx),%eax
  801d12:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d15:	75 22                	jne    801d39 <devpipe_read+0x4a>
			if (i > 0)
  801d17:	85 f6                	test   %esi,%esi
  801d19:	75 14                	jne    801d2f <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801d1b:	89 da                	mov    %ebx,%edx
  801d1d:	89 f8                	mov    %edi,%eax
  801d1f:	e8 e5 fe ff ff       	call   801c09 <_pipeisclosed>
  801d24:	85 c0                	test   %eax,%eax
  801d26:	75 33                	jne    801d5b <devpipe_read+0x6c>
			sys_yield();
  801d28:	e8 4d ee ff ff       	call   800b7a <sys_yield>
  801d2d:	eb e1                	jmp    801d10 <devpipe_read+0x21>
				return i;
  801d2f:	89 f0                	mov    %esi,%eax
}
  801d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d39:	99                   	cltd   
  801d3a:	c1 ea 1b             	shr    $0x1b,%edx
  801d3d:	01 d0                	add    %edx,%eax
  801d3f:	83 e0 1f             	and    $0x1f,%eax
  801d42:	29 d0                	sub    %edx,%eax
  801d44:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d4c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d4f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d52:	83 c6 01             	add    $0x1,%esi
  801d55:	eb b4                	jmp    801d0b <devpipe_read+0x1c>
	return i;
  801d57:	89 f0                	mov    %esi,%eax
  801d59:	eb d6                	jmp    801d31 <devpipe_read+0x42>
				return 0;
  801d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d60:	eb cf                	jmp    801d31 <devpipe_read+0x42>

00801d62 <pipe>:
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	56                   	push   %esi
  801d66:	53                   	push   %ebx
  801d67:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6d:	50                   	push   %eax
  801d6e:	e8 3e f0 ff ff       	call   800db1 <fd_alloc>
  801d73:	89 c3                	mov    %eax,%ebx
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	78 5b                	js     801dd7 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d7c:	83 ec 04             	sub    $0x4,%esp
  801d7f:	68 07 04 00 00       	push   $0x407
  801d84:	ff 75 f4             	pushl  -0xc(%ebp)
  801d87:	6a 00                	push   $0x0
  801d89:	e8 0b ee ff ff       	call   800b99 <sys_page_alloc>
  801d8e:	89 c3                	mov    %eax,%ebx
  801d90:	83 c4 10             	add    $0x10,%esp
  801d93:	85 c0                	test   %eax,%eax
  801d95:	78 40                	js     801dd7 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d97:	83 ec 0c             	sub    $0xc,%esp
  801d9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d9d:	50                   	push   %eax
  801d9e:	e8 0e f0 ff ff       	call   800db1 <fd_alloc>
  801da3:	89 c3                	mov    %eax,%ebx
  801da5:	83 c4 10             	add    $0x10,%esp
  801da8:	85 c0                	test   %eax,%eax
  801daa:	78 1b                	js     801dc7 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dac:	83 ec 04             	sub    $0x4,%esp
  801daf:	68 07 04 00 00       	push   $0x407
  801db4:	ff 75 f0             	pushl  -0x10(%ebp)
  801db7:	6a 00                	push   $0x0
  801db9:	e8 db ed ff ff       	call   800b99 <sys_page_alloc>
  801dbe:	89 c3                	mov    %eax,%ebx
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	79 19                	jns    801de0 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801dc7:	83 ec 08             	sub    $0x8,%esp
  801dca:	ff 75 f4             	pushl  -0xc(%ebp)
  801dcd:	6a 00                	push   $0x0
  801dcf:	e8 4a ee ff ff       	call   800c1e <sys_page_unmap>
  801dd4:	83 c4 10             	add    $0x10,%esp
}
  801dd7:	89 d8                	mov    %ebx,%eax
  801dd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ddc:	5b                   	pop    %ebx
  801ddd:	5e                   	pop    %esi
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    
	va = fd2data(fd0);
  801de0:	83 ec 0c             	sub    $0xc,%esp
  801de3:	ff 75 f4             	pushl  -0xc(%ebp)
  801de6:	e8 af ef ff ff       	call   800d9a <fd2data>
  801deb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ded:	83 c4 0c             	add    $0xc,%esp
  801df0:	68 07 04 00 00       	push   $0x407
  801df5:	50                   	push   %eax
  801df6:	6a 00                	push   $0x0
  801df8:	e8 9c ed ff ff       	call   800b99 <sys_page_alloc>
  801dfd:	89 c3                	mov    %eax,%ebx
  801dff:	83 c4 10             	add    $0x10,%esp
  801e02:	85 c0                	test   %eax,%eax
  801e04:	0f 88 8c 00 00 00    	js     801e96 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e0a:	83 ec 0c             	sub    $0xc,%esp
  801e0d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e10:	e8 85 ef ff ff       	call   800d9a <fd2data>
  801e15:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e1c:	50                   	push   %eax
  801e1d:	6a 00                	push   $0x0
  801e1f:	56                   	push   %esi
  801e20:	6a 00                	push   $0x0
  801e22:	e8 b5 ed ff ff       	call   800bdc <sys_page_map>
  801e27:	89 c3                	mov    %eax,%ebx
  801e29:	83 c4 20             	add    $0x20,%esp
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	78 58                	js     801e88 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e33:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e39:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e48:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801e4e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e53:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e60:	e8 25 ef ff ff       	call   800d8a <fd2num>
  801e65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e68:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e6a:	83 c4 04             	add    $0x4,%esp
  801e6d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e70:	e8 15 ef ff ff       	call   800d8a <fd2num>
  801e75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e78:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e83:	e9 4f ff ff ff       	jmp    801dd7 <pipe+0x75>
	sys_page_unmap(0, va);
  801e88:	83 ec 08             	sub    $0x8,%esp
  801e8b:	56                   	push   %esi
  801e8c:	6a 00                	push   $0x0
  801e8e:	e8 8b ed ff ff       	call   800c1e <sys_page_unmap>
  801e93:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e96:	83 ec 08             	sub    $0x8,%esp
  801e99:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9c:	6a 00                	push   $0x0
  801e9e:	e8 7b ed ff ff       	call   800c1e <sys_page_unmap>
  801ea3:	83 c4 10             	add    $0x10,%esp
  801ea6:	e9 1c ff ff ff       	jmp    801dc7 <pipe+0x65>

00801eab <pipeisclosed>:
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb4:	50                   	push   %eax
  801eb5:	ff 75 08             	pushl  0x8(%ebp)
  801eb8:	e8 43 ef ff ff       	call   800e00 <fd_lookup>
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	78 18                	js     801edc <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eca:	e8 cb ee ff ff       	call   800d9a <fd2data>
	return _pipeisclosed(fd, p);
  801ecf:	89 c2                	mov    %eax,%edx
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	e8 30 fd ff ff       	call   801c09 <_pipeisclosed>
  801ed9:	83 c4 10             	add    $0x10,%esp
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    

00801ee8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801eee:	68 7f 28 80 00       	push   $0x80287f
  801ef3:	ff 75 0c             	pushl  0xc(%ebp)
  801ef6:	e8 a5 e8 ff ff       	call   8007a0 <strcpy>
	return 0;
}
  801efb:	b8 00 00 00 00       	mov    $0x0,%eax
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <devcons_write>:
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	57                   	push   %edi
  801f06:	56                   	push   %esi
  801f07:	53                   	push   %ebx
  801f08:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f0e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f13:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f19:	eb 2f                	jmp    801f4a <devcons_write+0x48>
		m = n - tot;
  801f1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f1e:	29 f3                	sub    %esi,%ebx
  801f20:	83 fb 7f             	cmp    $0x7f,%ebx
  801f23:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f28:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f2b:	83 ec 04             	sub    $0x4,%esp
  801f2e:	53                   	push   %ebx
  801f2f:	89 f0                	mov    %esi,%eax
  801f31:	03 45 0c             	add    0xc(%ebp),%eax
  801f34:	50                   	push   %eax
  801f35:	57                   	push   %edi
  801f36:	e8 f3 e9 ff ff       	call   80092e <memmove>
		sys_cputs(buf, m);
  801f3b:	83 c4 08             	add    $0x8,%esp
  801f3e:	53                   	push   %ebx
  801f3f:	57                   	push   %edi
  801f40:	e8 98 eb ff ff       	call   800add <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f45:	01 de                	add    %ebx,%esi
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f4d:	72 cc                	jb     801f1b <devcons_write+0x19>
}
  801f4f:	89 f0                	mov    %esi,%eax
  801f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f54:	5b                   	pop    %ebx
  801f55:	5e                   	pop    %esi
  801f56:	5f                   	pop    %edi
  801f57:	5d                   	pop    %ebp
  801f58:	c3                   	ret    

00801f59 <devcons_read>:
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	83 ec 08             	sub    $0x8,%esp
  801f5f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f68:	75 07                	jne    801f71 <devcons_read+0x18>
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    
		sys_yield();
  801f6c:	e8 09 ec ff ff       	call   800b7a <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801f71:	e8 85 eb ff ff       	call   800afb <sys_cgetc>
  801f76:	85 c0                	test   %eax,%eax
  801f78:	74 f2                	je     801f6c <devcons_read+0x13>
	if (c < 0)
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	78 ec                	js     801f6a <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801f7e:	83 f8 04             	cmp    $0x4,%eax
  801f81:	74 0c                	je     801f8f <devcons_read+0x36>
	*(char*)vbuf = c;
  801f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f86:	88 02                	mov    %al,(%edx)
	return 1;
  801f88:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8d:	eb db                	jmp    801f6a <devcons_read+0x11>
		return 0;
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f94:	eb d4                	jmp    801f6a <devcons_read+0x11>

00801f96 <cputchar>:
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fa2:	6a 01                	push   $0x1
  801fa4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fa7:	50                   	push   %eax
  801fa8:	e8 30 eb ff ff       	call   800add <sys_cputs>
}
  801fad:	83 c4 10             	add    $0x10,%esp
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <getchar>:
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fb8:	6a 01                	push   $0x1
  801fba:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fbd:	50                   	push   %eax
  801fbe:	6a 00                	push   $0x0
  801fc0:	e8 ac f0 ff ff       	call   801071 <read>
	if (r < 0)
  801fc5:	83 c4 10             	add    $0x10,%esp
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	78 08                	js     801fd4 <getchar+0x22>
	if (r < 1)
  801fcc:	85 c0                	test   %eax,%eax
  801fce:	7e 06                	jle    801fd6 <getchar+0x24>
	return c;
  801fd0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    
		return -E_EOF;
  801fd6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fdb:	eb f7                	jmp    801fd4 <getchar+0x22>

00801fdd <iscons>:
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe6:	50                   	push   %eax
  801fe7:	ff 75 08             	pushl  0x8(%ebp)
  801fea:	e8 11 ee ff ff       	call   800e00 <fd_lookup>
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	78 11                	js     802007 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fff:	39 10                	cmp    %edx,(%eax)
  802001:	0f 94 c0             	sete   %al
  802004:	0f b6 c0             	movzbl %al,%eax
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <opencons>:
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80200f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802012:	50                   	push   %eax
  802013:	e8 99 ed ff ff       	call   800db1 <fd_alloc>
  802018:	83 c4 10             	add    $0x10,%esp
  80201b:	85 c0                	test   %eax,%eax
  80201d:	78 3a                	js     802059 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80201f:	83 ec 04             	sub    $0x4,%esp
  802022:	68 07 04 00 00       	push   $0x407
  802027:	ff 75 f4             	pushl  -0xc(%ebp)
  80202a:	6a 00                	push   $0x0
  80202c:	e8 68 eb ff ff       	call   800b99 <sys_page_alloc>
  802031:	83 c4 10             	add    $0x10,%esp
  802034:	85 c0                	test   %eax,%eax
  802036:	78 21                	js     802059 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802041:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802046:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80204d:	83 ec 0c             	sub    $0xc,%esp
  802050:	50                   	push   %eax
  802051:	e8 34 ed ff ff       	call   800d8a <fd2num>
  802056:	83 c4 10             	add    $0x10,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  802061:	68 8b 28 80 00       	push   $0x80288b
  802066:	6a 1a                	push   $0x1a
  802068:	68 a4 28 80 00       	push   $0x8028a4
  80206d:	e8 69 e0 ff ff       	call   8000db <_panic>

00802072 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  802078:	68 ae 28 80 00       	push   $0x8028ae
  80207d:	6a 2a                	push   $0x2a
  80207f:	68 a4 28 80 00       	push   $0x8028a4
  802084:	e8 52 e0 ff ff       	call   8000db <_panic>

00802089 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802094:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802097:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80209d:	8b 52 50             	mov    0x50(%edx),%edx
  8020a0:	39 ca                	cmp    %ecx,%edx
  8020a2:	74 11                	je     8020b5 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8020a4:	83 c0 01             	add    $0x1,%eax
  8020a7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020ac:	75 e6                	jne    802094 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8020ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b3:	eb 0b                	jmp    8020c0 <ipc_find_env+0x37>
			return envs[i].env_id;
  8020b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8020bd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020c0:	5d                   	pop    %ebp
  8020c1:	c3                   	ret    

008020c2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020c8:	89 d0                	mov    %edx,%eax
  8020ca:	c1 e8 16             	shr    $0x16,%eax
  8020cd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020d4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020d9:	f6 c1 01             	test   $0x1,%cl
  8020dc:	74 1d                	je     8020fb <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020de:	c1 ea 0c             	shr    $0xc,%edx
  8020e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020e8:	f6 c2 01             	test   $0x1,%dl
  8020eb:	74 0e                	je     8020fb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020ed:	c1 ea 0c             	shr    $0xc,%edx
  8020f0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020f7:	ef 
  8020f8:	0f b7 c0             	movzwl %ax,%eax
}
  8020fb:	5d                   	pop    %ebp
  8020fc:	c3                   	ret    
  8020fd:	66 90                	xchg   %ax,%ax
  8020ff:	90                   	nop

00802100 <__udivdi3>:
  802100:	55                   	push   %ebp
  802101:	57                   	push   %edi
  802102:	56                   	push   %esi
  802103:	53                   	push   %ebx
  802104:	83 ec 1c             	sub    $0x1c,%esp
  802107:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80210b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80210f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802113:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802117:	85 d2                	test   %edx,%edx
  802119:	75 35                	jne    802150 <__udivdi3+0x50>
  80211b:	39 f3                	cmp    %esi,%ebx
  80211d:	0f 87 bd 00 00 00    	ja     8021e0 <__udivdi3+0xe0>
  802123:	85 db                	test   %ebx,%ebx
  802125:	89 d9                	mov    %ebx,%ecx
  802127:	75 0b                	jne    802134 <__udivdi3+0x34>
  802129:	b8 01 00 00 00       	mov    $0x1,%eax
  80212e:	31 d2                	xor    %edx,%edx
  802130:	f7 f3                	div    %ebx
  802132:	89 c1                	mov    %eax,%ecx
  802134:	31 d2                	xor    %edx,%edx
  802136:	89 f0                	mov    %esi,%eax
  802138:	f7 f1                	div    %ecx
  80213a:	89 c6                	mov    %eax,%esi
  80213c:	89 e8                	mov    %ebp,%eax
  80213e:	89 f7                	mov    %esi,%edi
  802140:	f7 f1                	div    %ecx
  802142:	89 fa                	mov    %edi,%edx
  802144:	83 c4 1c             	add    $0x1c,%esp
  802147:	5b                   	pop    %ebx
  802148:	5e                   	pop    %esi
  802149:	5f                   	pop    %edi
  80214a:	5d                   	pop    %ebp
  80214b:	c3                   	ret    
  80214c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802150:	39 f2                	cmp    %esi,%edx
  802152:	77 7c                	ja     8021d0 <__udivdi3+0xd0>
  802154:	0f bd fa             	bsr    %edx,%edi
  802157:	83 f7 1f             	xor    $0x1f,%edi
  80215a:	0f 84 98 00 00 00    	je     8021f8 <__udivdi3+0xf8>
  802160:	89 f9                	mov    %edi,%ecx
  802162:	b8 20 00 00 00       	mov    $0x20,%eax
  802167:	29 f8                	sub    %edi,%eax
  802169:	d3 e2                	shl    %cl,%edx
  80216b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80216f:	89 c1                	mov    %eax,%ecx
  802171:	89 da                	mov    %ebx,%edx
  802173:	d3 ea                	shr    %cl,%edx
  802175:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802179:	09 d1                	or     %edx,%ecx
  80217b:	89 f2                	mov    %esi,%edx
  80217d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802181:	89 f9                	mov    %edi,%ecx
  802183:	d3 e3                	shl    %cl,%ebx
  802185:	89 c1                	mov    %eax,%ecx
  802187:	d3 ea                	shr    %cl,%edx
  802189:	89 f9                	mov    %edi,%ecx
  80218b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80218f:	d3 e6                	shl    %cl,%esi
  802191:	89 eb                	mov    %ebp,%ebx
  802193:	89 c1                	mov    %eax,%ecx
  802195:	d3 eb                	shr    %cl,%ebx
  802197:	09 de                	or     %ebx,%esi
  802199:	89 f0                	mov    %esi,%eax
  80219b:	f7 74 24 08          	divl   0x8(%esp)
  80219f:	89 d6                	mov    %edx,%esi
  8021a1:	89 c3                	mov    %eax,%ebx
  8021a3:	f7 64 24 0c          	mull   0xc(%esp)
  8021a7:	39 d6                	cmp    %edx,%esi
  8021a9:	72 0c                	jb     8021b7 <__udivdi3+0xb7>
  8021ab:	89 f9                	mov    %edi,%ecx
  8021ad:	d3 e5                	shl    %cl,%ebp
  8021af:	39 c5                	cmp    %eax,%ebp
  8021b1:	73 5d                	jae    802210 <__udivdi3+0x110>
  8021b3:	39 d6                	cmp    %edx,%esi
  8021b5:	75 59                	jne    802210 <__udivdi3+0x110>
  8021b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021ba:	31 ff                	xor    %edi,%edi
  8021bc:	89 fa                	mov    %edi,%edx
  8021be:	83 c4 1c             	add    $0x1c,%esp
  8021c1:	5b                   	pop    %ebx
  8021c2:	5e                   	pop    %esi
  8021c3:	5f                   	pop    %edi
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    
  8021c6:	8d 76 00             	lea    0x0(%esi),%esi
  8021c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021d0:	31 ff                	xor    %edi,%edi
  8021d2:	31 c0                	xor    %eax,%eax
  8021d4:	89 fa                	mov    %edi,%edx
  8021d6:	83 c4 1c             	add    $0x1c,%esp
  8021d9:	5b                   	pop    %ebx
  8021da:	5e                   	pop    %esi
  8021db:	5f                   	pop    %edi
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    
  8021de:	66 90                	xchg   %ax,%ax
  8021e0:	31 ff                	xor    %edi,%edi
  8021e2:	89 e8                	mov    %ebp,%eax
  8021e4:	89 f2                	mov    %esi,%edx
  8021e6:	f7 f3                	div    %ebx
  8021e8:	89 fa                	mov    %edi,%edx
  8021ea:	83 c4 1c             	add    $0x1c,%esp
  8021ed:	5b                   	pop    %ebx
  8021ee:	5e                   	pop    %esi
  8021ef:	5f                   	pop    %edi
  8021f0:	5d                   	pop    %ebp
  8021f1:	c3                   	ret    
  8021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021f8:	39 f2                	cmp    %esi,%edx
  8021fa:	72 06                	jb     802202 <__udivdi3+0x102>
  8021fc:	31 c0                	xor    %eax,%eax
  8021fe:	39 eb                	cmp    %ebp,%ebx
  802200:	77 d2                	ja     8021d4 <__udivdi3+0xd4>
  802202:	b8 01 00 00 00       	mov    $0x1,%eax
  802207:	eb cb                	jmp    8021d4 <__udivdi3+0xd4>
  802209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802210:	89 d8                	mov    %ebx,%eax
  802212:	31 ff                	xor    %edi,%edi
  802214:	eb be                	jmp    8021d4 <__udivdi3+0xd4>
  802216:	66 90                	xchg   %ax,%ax
  802218:	66 90                	xchg   %ax,%ax
  80221a:	66 90                	xchg   %ax,%ax
  80221c:	66 90                	xchg   %ax,%ax
  80221e:	66 90                	xchg   %ax,%ax

00802220 <__umoddi3>:
  802220:	55                   	push   %ebp
  802221:	57                   	push   %edi
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	83 ec 1c             	sub    $0x1c,%esp
  802227:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80222b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80222f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802233:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802237:	85 ed                	test   %ebp,%ebp
  802239:	89 f0                	mov    %esi,%eax
  80223b:	89 da                	mov    %ebx,%edx
  80223d:	75 19                	jne    802258 <__umoddi3+0x38>
  80223f:	39 df                	cmp    %ebx,%edi
  802241:	0f 86 b1 00 00 00    	jbe    8022f8 <__umoddi3+0xd8>
  802247:	f7 f7                	div    %edi
  802249:	89 d0                	mov    %edx,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	83 c4 1c             	add    $0x1c,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	39 dd                	cmp    %ebx,%ebp
  80225a:	77 f1                	ja     80224d <__umoddi3+0x2d>
  80225c:	0f bd cd             	bsr    %ebp,%ecx
  80225f:	83 f1 1f             	xor    $0x1f,%ecx
  802262:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802266:	0f 84 b4 00 00 00    	je     802320 <__umoddi3+0x100>
  80226c:	b8 20 00 00 00       	mov    $0x20,%eax
  802271:	89 c2                	mov    %eax,%edx
  802273:	8b 44 24 04          	mov    0x4(%esp),%eax
  802277:	29 c2                	sub    %eax,%edx
  802279:	89 c1                	mov    %eax,%ecx
  80227b:	89 f8                	mov    %edi,%eax
  80227d:	d3 e5                	shl    %cl,%ebp
  80227f:	89 d1                	mov    %edx,%ecx
  802281:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802285:	d3 e8                	shr    %cl,%eax
  802287:	09 c5                	or     %eax,%ebp
  802289:	8b 44 24 04          	mov    0x4(%esp),%eax
  80228d:	89 c1                	mov    %eax,%ecx
  80228f:	d3 e7                	shl    %cl,%edi
  802291:	89 d1                	mov    %edx,%ecx
  802293:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802297:	89 df                	mov    %ebx,%edi
  802299:	d3 ef                	shr    %cl,%edi
  80229b:	89 c1                	mov    %eax,%ecx
  80229d:	89 f0                	mov    %esi,%eax
  80229f:	d3 e3                	shl    %cl,%ebx
  8022a1:	89 d1                	mov    %edx,%ecx
  8022a3:	89 fa                	mov    %edi,%edx
  8022a5:	d3 e8                	shr    %cl,%eax
  8022a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022ac:	09 d8                	or     %ebx,%eax
  8022ae:	f7 f5                	div    %ebp
  8022b0:	d3 e6                	shl    %cl,%esi
  8022b2:	89 d1                	mov    %edx,%ecx
  8022b4:	f7 64 24 08          	mull   0x8(%esp)
  8022b8:	39 d1                	cmp    %edx,%ecx
  8022ba:	89 c3                	mov    %eax,%ebx
  8022bc:	89 d7                	mov    %edx,%edi
  8022be:	72 06                	jb     8022c6 <__umoddi3+0xa6>
  8022c0:	75 0e                	jne    8022d0 <__umoddi3+0xb0>
  8022c2:	39 c6                	cmp    %eax,%esi
  8022c4:	73 0a                	jae    8022d0 <__umoddi3+0xb0>
  8022c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8022ca:	19 ea                	sbb    %ebp,%edx
  8022cc:	89 d7                	mov    %edx,%edi
  8022ce:	89 c3                	mov    %eax,%ebx
  8022d0:	89 ca                	mov    %ecx,%edx
  8022d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022d7:	29 de                	sub    %ebx,%esi
  8022d9:	19 fa                	sbb    %edi,%edx
  8022db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022df:	89 d0                	mov    %edx,%eax
  8022e1:	d3 e0                	shl    %cl,%eax
  8022e3:	89 d9                	mov    %ebx,%ecx
  8022e5:	d3 ee                	shr    %cl,%esi
  8022e7:	d3 ea                	shr    %cl,%edx
  8022e9:	09 f0                	or     %esi,%eax
  8022eb:	83 c4 1c             	add    $0x1c,%esp
  8022ee:	5b                   	pop    %ebx
  8022ef:	5e                   	pop    %esi
  8022f0:	5f                   	pop    %edi
  8022f1:	5d                   	pop    %ebp
  8022f2:	c3                   	ret    
  8022f3:	90                   	nop
  8022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022f8:	85 ff                	test   %edi,%edi
  8022fa:	89 f9                	mov    %edi,%ecx
  8022fc:	75 0b                	jne    802309 <__umoddi3+0xe9>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f7                	div    %edi
  802307:	89 c1                	mov    %eax,%ecx
  802309:	89 d8                	mov    %ebx,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	f7 f1                	div    %ecx
  80230f:	89 f0                	mov    %esi,%eax
  802311:	f7 f1                	div    %ecx
  802313:	e9 31 ff ff ff       	jmp    802249 <__umoddi3+0x29>
  802318:	90                   	nop
  802319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802320:	39 dd                	cmp    %ebx,%ebp
  802322:	72 08                	jb     80232c <__umoddi3+0x10c>
  802324:	39 f7                	cmp    %esi,%edi
  802326:	0f 87 21 ff ff ff    	ja     80224d <__umoddi3+0x2d>
  80232c:	89 da                	mov    %ebx,%edx
  80232e:	89 f0                	mov    %esi,%eax
  802330:	29 f8                	sub    %edi,%eax
  802332:	19 ea                	sbb    %ebp,%edx
  802334:	e9 14 ff ff ff       	jmp    80224d <__umoddi3+0x2d>
