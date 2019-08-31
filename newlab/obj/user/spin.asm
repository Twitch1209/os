
obj/user/spin.debug：     文件格式 elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003a:	68 40 20 80 00       	push   $0x802040
  80003f:	e8 66 01 00 00       	call   8001aa <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 4c 0d 00 00       	call   800d95 <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 b8 20 80 00       	push   $0x8020b8
  800058:	e8 4d 01 00 00       	call   8001aa <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 68 20 80 00       	push   $0x802068
  80006c:	e8 39 01 00 00       	call   8001aa <cprintf>
	sys_yield();
  800071:	e8 f8 0a 00 00       	call   800b6e <sys_yield>
	sys_yield();
  800076:	e8 f3 0a 00 00       	call   800b6e <sys_yield>
	sys_yield();
  80007b:	e8 ee 0a 00 00       	call   800b6e <sys_yield>
	sys_yield();
  800080:	e8 e9 0a 00 00       	call   800b6e <sys_yield>
	sys_yield();
  800085:	e8 e4 0a 00 00       	call   800b6e <sys_yield>
	sys_yield();
  80008a:	e8 df 0a 00 00       	call   800b6e <sys_yield>
	sys_yield();
  80008f:	e8 da 0a 00 00       	call   800b6e <sys_yield>
	sys_yield();
  800094:	e8 d5 0a 00 00       	call   800b6e <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 90 20 80 00 	movl   $0x802090,(%esp)
  8000a0:	e8 05 01 00 00       	call   8001aa <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 61 0a 00 00       	call   800b0e <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 8a 0a 00 00       	call   800b4f <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d2:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d7:	85 db                	test   %ebx,%ebx
  8000d9:	7e 07                	jle    8000e2 <libmain+0x2d>
		binaryname = argv[0];
  8000db:	8b 06                	mov    (%esi),%eax
  8000dd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000e2:	83 ec 08             	sub    $0x8,%esp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	e8 47 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ec:	e8 0a 00 00 00       	call   8000fb <exit>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800101:	e8 87 10 00 00       	call   80118d <close_all>
	sys_env_destroy(0);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	6a 00                	push   $0x0
  80010b:	e8 fe 09 00 00       	call   800b0e <sys_env_destroy>
}
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	c9                   	leave  
  800114:	c3                   	ret    

00800115 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	53                   	push   %ebx
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80011f:	8b 13                	mov    (%ebx),%edx
  800121:	8d 42 01             	lea    0x1(%edx),%eax
  800124:	89 03                	mov    %eax,(%ebx)
  800126:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800129:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80012d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800132:	74 09                	je     80013d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800134:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800138:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013b:	c9                   	leave  
  80013c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80013d:	83 ec 08             	sub    $0x8,%esp
  800140:	68 ff 00 00 00       	push   $0xff
  800145:	8d 43 08             	lea    0x8(%ebx),%eax
  800148:	50                   	push   %eax
  800149:	e8 83 09 00 00       	call   800ad1 <sys_cputs>
		b->idx = 0;
  80014e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	eb db                	jmp    800134 <putch+0x1f>

00800159 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800162:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800169:	00 00 00 
	b.cnt = 0;
  80016c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800173:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800176:	ff 75 0c             	pushl  0xc(%ebp)
  800179:	ff 75 08             	pushl  0x8(%ebp)
  80017c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800182:	50                   	push   %eax
  800183:	68 15 01 80 00       	push   $0x800115
  800188:	e8 1a 01 00 00       	call   8002a7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018d:	83 c4 08             	add    $0x8,%esp
  800190:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800196:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019c:	50                   	push   %eax
  80019d:	e8 2f 09 00 00       	call   800ad1 <sys_cputs>

	return b.cnt;
}
  8001a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b3:	50                   	push   %eax
  8001b4:	ff 75 08             	pushl  0x8(%ebp)
  8001b7:	e8 9d ff ff ff       	call   800159 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    

008001be <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001be:	55                   	push   %ebp
  8001bf:	89 e5                	mov    %esp,%ebp
  8001c1:	57                   	push   %edi
  8001c2:	56                   	push   %esi
  8001c3:	53                   	push   %ebx
  8001c4:	83 ec 1c             	sub    $0x1c,%esp
  8001c7:	89 c7                	mov    %eax,%edi
  8001c9:	89 d6                	mov    %edx,%esi
  8001cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001df:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001e2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001e5:	39 d3                	cmp    %edx,%ebx
  8001e7:	72 05                	jb     8001ee <printnum+0x30>
  8001e9:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001ec:	77 7a                	ja     800268 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	ff 75 18             	pushl  0x18(%ebp)
  8001f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8001f7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001fa:	53                   	push   %ebx
  8001fb:	ff 75 10             	pushl  0x10(%ebp)
  8001fe:	83 ec 08             	sub    $0x8,%esp
  800201:	ff 75 e4             	pushl  -0x1c(%ebp)
  800204:	ff 75 e0             	pushl  -0x20(%ebp)
  800207:	ff 75 dc             	pushl  -0x24(%ebp)
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	e8 ee 1b 00 00       	call   801e00 <__udivdi3>
  800212:	83 c4 18             	add    $0x18,%esp
  800215:	52                   	push   %edx
  800216:	50                   	push   %eax
  800217:	89 f2                	mov    %esi,%edx
  800219:	89 f8                	mov    %edi,%eax
  80021b:	e8 9e ff ff ff       	call   8001be <printnum>
  800220:	83 c4 20             	add    $0x20,%esp
  800223:	eb 13                	jmp    800238 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	56                   	push   %esi
  800229:	ff 75 18             	pushl  0x18(%ebp)
  80022c:	ff d7                	call   *%edi
  80022e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800231:	83 eb 01             	sub    $0x1,%ebx
  800234:	85 db                	test   %ebx,%ebx
  800236:	7f ed                	jg     800225 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800238:	83 ec 08             	sub    $0x8,%esp
  80023b:	56                   	push   %esi
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800242:	ff 75 e0             	pushl  -0x20(%ebp)
  800245:	ff 75 dc             	pushl  -0x24(%ebp)
  800248:	ff 75 d8             	pushl  -0x28(%ebp)
  80024b:	e8 d0 1c 00 00       	call   801f20 <__umoddi3>
  800250:	83 c4 14             	add    $0x14,%esp
  800253:	0f be 80 e0 20 80 00 	movsbl 0x8020e0(%eax),%eax
  80025a:	50                   	push   %eax
  80025b:	ff d7                	call   *%edi
}
  80025d:	83 c4 10             	add    $0x10,%esp
  800260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800263:	5b                   	pop    %ebx
  800264:	5e                   	pop    %esi
  800265:	5f                   	pop    %edi
  800266:	5d                   	pop    %ebp
  800267:	c3                   	ret    
  800268:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80026b:	eb c4                	jmp    800231 <printnum+0x73>

0080026d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800273:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800277:	8b 10                	mov    (%eax),%edx
  800279:	3b 50 04             	cmp    0x4(%eax),%edx
  80027c:	73 0a                	jae    800288 <sprintputch+0x1b>
		*b->buf++ = ch;
  80027e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800281:	89 08                	mov    %ecx,(%eax)
  800283:	8b 45 08             	mov    0x8(%ebp),%eax
  800286:	88 02                	mov    %al,(%edx)
}
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    

0080028a <printfmt>:
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800290:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800293:	50                   	push   %eax
  800294:	ff 75 10             	pushl  0x10(%ebp)
  800297:	ff 75 0c             	pushl  0xc(%ebp)
  80029a:	ff 75 08             	pushl  0x8(%ebp)
  80029d:	e8 05 00 00 00       	call   8002a7 <vprintfmt>
}
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <vprintfmt>:
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	57                   	push   %edi
  8002ab:	56                   	push   %esi
  8002ac:	53                   	push   %ebx
  8002ad:	83 ec 2c             	sub    $0x2c,%esp
  8002b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002b9:	e9 8c 03 00 00       	jmp    80064a <vprintfmt+0x3a3>
		padc = ' ';
  8002be:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002c2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002c9:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002d0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002d7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002dc:	8d 47 01             	lea    0x1(%edi),%eax
  8002df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e2:	0f b6 17             	movzbl (%edi),%edx
  8002e5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002e8:	3c 55                	cmp    $0x55,%al
  8002ea:	0f 87 dd 03 00 00    	ja     8006cd <vprintfmt+0x426>
  8002f0:	0f b6 c0             	movzbl %al,%eax
  8002f3:	ff 24 85 20 22 80 00 	jmp    *0x802220(,%eax,4)
  8002fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002fd:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800301:	eb d9                	jmp    8002dc <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800306:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80030a:	eb d0                	jmp    8002dc <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030c:	0f b6 d2             	movzbl %dl,%edx
  80030f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800312:	b8 00 00 00 00       	mov    $0x0,%eax
  800317:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80031a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80031d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800321:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800324:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800327:	83 f9 09             	cmp    $0x9,%ecx
  80032a:	77 55                	ja     800381 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80032c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80032f:	eb e9                	jmp    80031a <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800331:	8b 45 14             	mov    0x14(%ebp),%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800339:	8b 45 14             	mov    0x14(%ebp),%eax
  80033c:	8d 40 04             	lea    0x4(%eax),%eax
  80033f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800342:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800345:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800349:	79 91                	jns    8002dc <vprintfmt+0x35>
				width = precision, precision = -1;
  80034b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80034e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800351:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800358:	eb 82                	jmp    8002dc <vprintfmt+0x35>
  80035a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80035d:	85 c0                	test   %eax,%eax
  80035f:	ba 00 00 00 00       	mov    $0x0,%edx
  800364:	0f 49 d0             	cmovns %eax,%edx
  800367:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80036d:	e9 6a ff ff ff       	jmp    8002dc <vprintfmt+0x35>
  800372:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800375:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80037c:	e9 5b ff ff ff       	jmp    8002dc <vprintfmt+0x35>
  800381:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800384:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800387:	eb bc                	jmp    800345 <vprintfmt+0x9e>
			lflag++;
  800389:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80038f:	e9 48 ff ff ff       	jmp    8002dc <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800394:	8b 45 14             	mov    0x14(%ebp),%eax
  800397:	8d 78 04             	lea    0x4(%eax),%edi
  80039a:	83 ec 08             	sub    $0x8,%esp
  80039d:	53                   	push   %ebx
  80039e:	ff 30                	pushl  (%eax)
  8003a0:	ff d6                	call   *%esi
			break;
  8003a2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003a8:	e9 9a 02 00 00       	jmp    800647 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8003ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b0:	8d 78 04             	lea    0x4(%eax),%edi
  8003b3:	8b 00                	mov    (%eax),%eax
  8003b5:	99                   	cltd   
  8003b6:	31 d0                	xor    %edx,%eax
  8003b8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ba:	83 f8 0f             	cmp    $0xf,%eax
  8003bd:	7f 23                	jg     8003e2 <vprintfmt+0x13b>
  8003bf:	8b 14 85 80 23 80 00 	mov    0x802380(,%eax,4),%edx
  8003c6:	85 d2                	test   %edx,%edx
  8003c8:	74 18                	je     8003e2 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003ca:	52                   	push   %edx
  8003cb:	68 71 25 80 00       	push   $0x802571
  8003d0:	53                   	push   %ebx
  8003d1:	56                   	push   %esi
  8003d2:	e8 b3 fe ff ff       	call   80028a <printfmt>
  8003d7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003da:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003dd:	e9 65 02 00 00       	jmp    800647 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8003e2:	50                   	push   %eax
  8003e3:	68 f8 20 80 00       	push   $0x8020f8
  8003e8:	53                   	push   %ebx
  8003e9:	56                   	push   %esi
  8003ea:	e8 9b fe ff ff       	call   80028a <printfmt>
  8003ef:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f5:	e9 4d 02 00 00       	jmp    800647 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fd:	83 c0 04             	add    $0x4,%eax
  800400:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800403:	8b 45 14             	mov    0x14(%ebp),%eax
  800406:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800408:	85 ff                	test   %edi,%edi
  80040a:	b8 f1 20 80 00       	mov    $0x8020f1,%eax
  80040f:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800412:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800416:	0f 8e bd 00 00 00    	jle    8004d9 <vprintfmt+0x232>
  80041c:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800420:	75 0e                	jne    800430 <vprintfmt+0x189>
  800422:	89 75 08             	mov    %esi,0x8(%ebp)
  800425:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800428:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80042b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80042e:	eb 6d                	jmp    80049d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	ff 75 d0             	pushl  -0x30(%ebp)
  800436:	57                   	push   %edi
  800437:	e8 39 03 00 00       	call   800775 <strnlen>
  80043c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80043f:	29 c1                	sub    %eax,%ecx
  800441:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800444:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800447:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80044b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800451:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800453:	eb 0f                	jmp    800464 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	53                   	push   %ebx
  800459:	ff 75 e0             	pushl  -0x20(%ebp)
  80045c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045e:	83 ef 01             	sub    $0x1,%edi
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	85 ff                	test   %edi,%edi
  800466:	7f ed                	jg     800455 <vprintfmt+0x1ae>
  800468:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80046b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80046e:	85 c9                	test   %ecx,%ecx
  800470:	b8 00 00 00 00       	mov    $0x0,%eax
  800475:	0f 49 c1             	cmovns %ecx,%eax
  800478:	29 c1                	sub    %eax,%ecx
  80047a:	89 75 08             	mov    %esi,0x8(%ebp)
  80047d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800480:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800483:	89 cb                	mov    %ecx,%ebx
  800485:	eb 16                	jmp    80049d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800487:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80048b:	75 31                	jne    8004be <vprintfmt+0x217>
					putch(ch, putdat);
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	ff 75 0c             	pushl  0xc(%ebp)
  800493:	50                   	push   %eax
  800494:	ff 55 08             	call   *0x8(%ebp)
  800497:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049a:	83 eb 01             	sub    $0x1,%ebx
  80049d:	83 c7 01             	add    $0x1,%edi
  8004a0:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004a4:	0f be c2             	movsbl %dl,%eax
  8004a7:	85 c0                	test   %eax,%eax
  8004a9:	74 59                	je     800504 <vprintfmt+0x25d>
  8004ab:	85 f6                	test   %esi,%esi
  8004ad:	78 d8                	js     800487 <vprintfmt+0x1e0>
  8004af:	83 ee 01             	sub    $0x1,%esi
  8004b2:	79 d3                	jns    800487 <vprintfmt+0x1e0>
  8004b4:	89 df                	mov    %ebx,%edi
  8004b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004bc:	eb 37                	jmp    8004f5 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004be:	0f be d2             	movsbl %dl,%edx
  8004c1:	83 ea 20             	sub    $0x20,%edx
  8004c4:	83 fa 5e             	cmp    $0x5e,%edx
  8004c7:	76 c4                	jbe    80048d <vprintfmt+0x1e6>
					putch('?', putdat);
  8004c9:	83 ec 08             	sub    $0x8,%esp
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	6a 3f                	push   $0x3f
  8004d1:	ff 55 08             	call   *0x8(%ebp)
  8004d4:	83 c4 10             	add    $0x10,%esp
  8004d7:	eb c1                	jmp    80049a <vprintfmt+0x1f3>
  8004d9:	89 75 08             	mov    %esi,0x8(%ebp)
  8004dc:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004df:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004e2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e5:	eb b6                	jmp    80049d <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	53                   	push   %ebx
  8004eb:	6a 20                	push   $0x20
  8004ed:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ef:	83 ef 01             	sub    $0x1,%edi
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	85 ff                	test   %edi,%edi
  8004f7:	7f ee                	jg     8004e7 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ff:	e9 43 01 00 00       	jmp    800647 <vprintfmt+0x3a0>
  800504:	89 df                	mov    %ebx,%edi
  800506:	8b 75 08             	mov    0x8(%ebp),%esi
  800509:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050c:	eb e7                	jmp    8004f5 <vprintfmt+0x24e>
	if (lflag >= 2)
  80050e:	83 f9 01             	cmp    $0x1,%ecx
  800511:	7e 3f                	jle    800552 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800513:	8b 45 14             	mov    0x14(%ebp),%eax
  800516:	8b 50 04             	mov    0x4(%eax),%edx
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8d 40 08             	lea    0x8(%eax),%eax
  800527:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80052a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80052e:	79 5c                	jns    80058c <vprintfmt+0x2e5>
				putch('-', putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	53                   	push   %ebx
  800534:	6a 2d                	push   $0x2d
  800536:	ff d6                	call   *%esi
				num = -(long long) num;
  800538:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80053e:	f7 da                	neg    %edx
  800540:	83 d1 00             	adc    $0x0,%ecx
  800543:	f7 d9                	neg    %ecx
  800545:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800548:	b8 0a 00 00 00       	mov    $0xa,%eax
  80054d:	e9 db 00 00 00       	jmp    80062d <vprintfmt+0x386>
	else if (lflag)
  800552:	85 c9                	test   %ecx,%ecx
  800554:	75 1b                	jne    800571 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800556:	8b 45 14             	mov    0x14(%ebp),%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055e:	89 c1                	mov    %eax,%ecx
  800560:	c1 f9 1f             	sar    $0x1f,%ecx
  800563:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8d 40 04             	lea    0x4(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
  80056f:	eb b9                	jmp    80052a <vprintfmt+0x283>
		return va_arg(*ap, long);
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800579:	89 c1                	mov    %eax,%ecx
  80057b:	c1 f9 1f             	sar    $0x1f,%ecx
  80057e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8d 40 04             	lea    0x4(%eax),%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
  80058a:	eb 9e                	jmp    80052a <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80058c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800592:	b8 0a 00 00 00       	mov    $0xa,%eax
  800597:	e9 91 00 00 00       	jmp    80062d <vprintfmt+0x386>
	if (lflag >= 2)
  80059c:	83 f9 01             	cmp    $0x1,%ecx
  80059f:	7e 15                	jle    8005b6 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8b 10                	mov    (%eax),%edx
  8005a6:	8b 48 04             	mov    0x4(%eax),%ecx
  8005a9:	8d 40 08             	lea    0x8(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b4:	eb 77                	jmp    80062d <vprintfmt+0x386>
	else if (lflag)
  8005b6:	85 c9                	test   %ecx,%ecx
  8005b8:	75 17                	jne    8005d1 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8b 10                	mov    (%eax),%edx
  8005bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c4:	8d 40 04             	lea    0x4(%eax),%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cf:	eb 5c                	jmp    80062d <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8b 10                	mov    (%eax),%edx
  8005d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005db:	8d 40 04             	lea    0x4(%eax),%eax
  8005de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e6:	eb 45                	jmp    80062d <vprintfmt+0x386>
			putch('X', putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	53                   	push   %ebx
  8005ec:	6a 58                	push   $0x58
  8005ee:	ff d6                	call   *%esi
			putch('X', putdat);
  8005f0:	83 c4 08             	add    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	6a 58                	push   $0x58
  8005f6:	ff d6                	call   *%esi
			putch('X', putdat);
  8005f8:	83 c4 08             	add    $0x8,%esp
  8005fb:	53                   	push   %ebx
  8005fc:	6a 58                	push   $0x58
  8005fe:	ff d6                	call   *%esi
			break;
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	eb 42                	jmp    800647 <vprintfmt+0x3a0>
			putch('0', putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	53                   	push   %ebx
  800609:	6a 30                	push   $0x30
  80060b:	ff d6                	call   *%esi
			putch('x', putdat);
  80060d:	83 c4 08             	add    $0x8,%esp
  800610:	53                   	push   %ebx
  800611:	6a 78                	push   $0x78
  800613:	ff d6                	call   *%esi
			num = (unsigned long long)
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8b 10                	mov    (%eax),%edx
  80061a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80061f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800628:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80062d:	83 ec 0c             	sub    $0xc,%esp
  800630:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800634:	57                   	push   %edi
  800635:	ff 75 e0             	pushl  -0x20(%ebp)
  800638:	50                   	push   %eax
  800639:	51                   	push   %ecx
  80063a:	52                   	push   %edx
  80063b:	89 da                	mov    %ebx,%edx
  80063d:	89 f0                	mov    %esi,%eax
  80063f:	e8 7a fb ff ff       	call   8001be <printnum>
			break;
  800644:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800647:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064a:	83 c7 01             	add    $0x1,%edi
  80064d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800651:	83 f8 25             	cmp    $0x25,%eax
  800654:	0f 84 64 fc ff ff    	je     8002be <vprintfmt+0x17>
			if (ch == '\0')
  80065a:	85 c0                	test   %eax,%eax
  80065c:	0f 84 8b 00 00 00    	je     8006ed <vprintfmt+0x446>
			putch(ch, putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	53                   	push   %ebx
  800666:	50                   	push   %eax
  800667:	ff d6                	call   *%esi
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	eb dc                	jmp    80064a <vprintfmt+0x3a3>
	if (lflag >= 2)
  80066e:	83 f9 01             	cmp    $0x1,%ecx
  800671:	7e 15                	jle    800688 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8b 10                	mov    (%eax),%edx
  800678:	8b 48 04             	mov    0x4(%eax),%ecx
  80067b:	8d 40 08             	lea    0x8(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800681:	b8 10 00 00 00       	mov    $0x10,%eax
  800686:	eb a5                	jmp    80062d <vprintfmt+0x386>
	else if (lflag)
  800688:	85 c9                	test   %ecx,%ecx
  80068a:	75 17                	jne    8006a3 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8b 10                	mov    (%eax),%edx
  800691:	b9 00 00 00 00       	mov    $0x0,%ecx
  800696:	8d 40 04             	lea    0x4(%eax),%eax
  800699:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069c:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a1:	eb 8a                	jmp    80062d <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8b 10                	mov    (%eax),%edx
  8006a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ad:	8d 40 04             	lea    0x4(%eax),%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b3:	b8 10 00 00 00       	mov    $0x10,%eax
  8006b8:	e9 70 ff ff ff       	jmp    80062d <vprintfmt+0x386>
			putch(ch, putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	53                   	push   %ebx
  8006c1:	6a 25                	push   $0x25
  8006c3:	ff d6                	call   *%esi
			break;
  8006c5:	83 c4 10             	add    $0x10,%esp
  8006c8:	e9 7a ff ff ff       	jmp    800647 <vprintfmt+0x3a0>
			putch('%', putdat);
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	53                   	push   %ebx
  8006d1:	6a 25                	push   $0x25
  8006d3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006d5:	83 c4 10             	add    $0x10,%esp
  8006d8:	89 f8                	mov    %edi,%eax
  8006da:	eb 03                	jmp    8006df <vprintfmt+0x438>
  8006dc:	83 e8 01             	sub    $0x1,%eax
  8006df:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006e3:	75 f7                	jne    8006dc <vprintfmt+0x435>
  8006e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e8:	e9 5a ff ff ff       	jmp    800647 <vprintfmt+0x3a0>
}
  8006ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f0:	5b                   	pop    %ebx
  8006f1:	5e                   	pop    %esi
  8006f2:	5f                   	pop    %edi
  8006f3:	5d                   	pop    %ebp
  8006f4:	c3                   	ret    

008006f5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	83 ec 18             	sub    $0x18,%esp
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800701:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800704:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800708:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80070b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800712:	85 c0                	test   %eax,%eax
  800714:	74 26                	je     80073c <vsnprintf+0x47>
  800716:	85 d2                	test   %edx,%edx
  800718:	7e 22                	jle    80073c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80071a:	ff 75 14             	pushl  0x14(%ebp)
  80071d:	ff 75 10             	pushl  0x10(%ebp)
  800720:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800723:	50                   	push   %eax
  800724:	68 6d 02 80 00       	push   $0x80026d
  800729:	e8 79 fb ff ff       	call   8002a7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80072e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800731:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800737:	83 c4 10             	add    $0x10,%esp
}
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    
		return -E_INVAL;
  80073c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800741:	eb f7                	jmp    80073a <vsnprintf+0x45>

00800743 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800749:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80074c:	50                   	push   %eax
  80074d:	ff 75 10             	pushl  0x10(%ebp)
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	ff 75 08             	pushl  0x8(%ebp)
  800756:	e8 9a ff ff ff       	call   8006f5 <vsnprintf>
	va_end(ap);

	return rc;
}
  80075b:	c9                   	leave  
  80075c:	c3                   	ret    

0080075d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80075d:	55                   	push   %ebp
  80075e:	89 e5                	mov    %esp,%ebp
  800760:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800763:	b8 00 00 00 00       	mov    $0x0,%eax
  800768:	eb 03                	jmp    80076d <strlen+0x10>
		n++;
  80076a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80076d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800771:	75 f7                	jne    80076a <strlen+0xd>
	return n;
}
  800773:	5d                   	pop    %ebp
  800774:	c3                   	ret    

00800775 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80077b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80077e:	b8 00 00 00 00       	mov    $0x0,%eax
  800783:	eb 03                	jmp    800788 <strnlen+0x13>
		n++;
  800785:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800788:	39 d0                	cmp    %edx,%eax
  80078a:	74 06                	je     800792 <strnlen+0x1d>
  80078c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800790:	75 f3                	jne    800785 <strnlen+0x10>
	return n;
}
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	53                   	push   %ebx
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	83 c1 01             	add    $0x1,%ecx
  8007a3:	83 c2 01             	add    $0x1,%edx
  8007a6:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007aa:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007ad:	84 db                	test   %bl,%bl
  8007af:	75 ef                	jne    8007a0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007b1:	5b                   	pop    %ebx
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	53                   	push   %ebx
  8007b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007bb:	53                   	push   %ebx
  8007bc:	e8 9c ff ff ff       	call   80075d <strlen>
  8007c1:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	01 d8                	add    %ebx,%eax
  8007c9:	50                   	push   %eax
  8007ca:	e8 c5 ff ff ff       	call   800794 <strcpy>
	return dst;
}
  8007cf:	89 d8                	mov    %ebx,%eax
  8007d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d4:	c9                   	leave  
  8007d5:	c3                   	ret    

008007d6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	56                   	push   %esi
  8007da:	53                   	push   %ebx
  8007db:	8b 75 08             	mov    0x8(%ebp),%esi
  8007de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e1:	89 f3                	mov    %esi,%ebx
  8007e3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e6:	89 f2                	mov    %esi,%edx
  8007e8:	eb 0f                	jmp    8007f9 <strncpy+0x23>
		*dst++ = *src;
  8007ea:	83 c2 01             	add    $0x1,%edx
  8007ed:	0f b6 01             	movzbl (%ecx),%eax
  8007f0:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007f3:	80 39 01             	cmpb   $0x1,(%ecx)
  8007f6:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007f9:	39 da                	cmp    %ebx,%edx
  8007fb:	75 ed                	jne    8007ea <strncpy+0x14>
	}
	return ret;
}
  8007fd:	89 f0                	mov    %esi,%eax
  8007ff:	5b                   	pop    %ebx
  800800:	5e                   	pop    %esi
  800801:	5d                   	pop    %ebp
  800802:	c3                   	ret    

00800803 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	56                   	push   %esi
  800807:	53                   	push   %ebx
  800808:	8b 75 08             	mov    0x8(%ebp),%esi
  80080b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800811:	89 f0                	mov    %esi,%eax
  800813:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800817:	85 c9                	test   %ecx,%ecx
  800819:	75 0b                	jne    800826 <strlcpy+0x23>
  80081b:	eb 17                	jmp    800834 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80081d:	83 c2 01             	add    $0x1,%edx
  800820:	83 c0 01             	add    $0x1,%eax
  800823:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800826:	39 d8                	cmp    %ebx,%eax
  800828:	74 07                	je     800831 <strlcpy+0x2e>
  80082a:	0f b6 0a             	movzbl (%edx),%ecx
  80082d:	84 c9                	test   %cl,%cl
  80082f:	75 ec                	jne    80081d <strlcpy+0x1a>
		*dst = '\0';
  800831:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800834:	29 f0                	sub    %esi,%eax
}
  800836:	5b                   	pop    %ebx
  800837:	5e                   	pop    %esi
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800840:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800843:	eb 06                	jmp    80084b <strcmp+0x11>
		p++, q++;
  800845:	83 c1 01             	add    $0x1,%ecx
  800848:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80084b:	0f b6 01             	movzbl (%ecx),%eax
  80084e:	84 c0                	test   %al,%al
  800850:	74 04                	je     800856 <strcmp+0x1c>
  800852:	3a 02                	cmp    (%edx),%al
  800854:	74 ef                	je     800845 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800856:	0f b6 c0             	movzbl %al,%eax
  800859:	0f b6 12             	movzbl (%edx),%edx
  80085c:	29 d0                	sub    %edx,%eax
}
  80085e:	5d                   	pop    %ebp
  80085f:	c3                   	ret    

00800860 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	53                   	push   %ebx
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086a:	89 c3                	mov    %eax,%ebx
  80086c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80086f:	eb 06                	jmp    800877 <strncmp+0x17>
		n--, p++, q++;
  800871:	83 c0 01             	add    $0x1,%eax
  800874:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800877:	39 d8                	cmp    %ebx,%eax
  800879:	74 16                	je     800891 <strncmp+0x31>
  80087b:	0f b6 08             	movzbl (%eax),%ecx
  80087e:	84 c9                	test   %cl,%cl
  800880:	74 04                	je     800886 <strncmp+0x26>
  800882:	3a 0a                	cmp    (%edx),%cl
  800884:	74 eb                	je     800871 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800886:	0f b6 00             	movzbl (%eax),%eax
  800889:	0f b6 12             	movzbl (%edx),%edx
  80088c:	29 d0                	sub    %edx,%eax
}
  80088e:	5b                   	pop    %ebx
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    
		return 0;
  800891:	b8 00 00 00 00       	mov    $0x0,%eax
  800896:	eb f6                	jmp    80088e <strncmp+0x2e>

00800898 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a2:	0f b6 10             	movzbl (%eax),%edx
  8008a5:	84 d2                	test   %dl,%dl
  8008a7:	74 09                	je     8008b2 <strchr+0x1a>
		if (*s == c)
  8008a9:	38 ca                	cmp    %cl,%dl
  8008ab:	74 0a                	je     8008b7 <strchr+0x1f>
	for (; *s; s++)
  8008ad:	83 c0 01             	add    $0x1,%eax
  8008b0:	eb f0                	jmp    8008a2 <strchr+0xa>
			return (char *) s;
	return 0;
  8008b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c3:	eb 03                	jmp    8008c8 <strfind+0xf>
  8008c5:	83 c0 01             	add    $0x1,%eax
  8008c8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008cb:	38 ca                	cmp    %cl,%dl
  8008cd:	74 04                	je     8008d3 <strfind+0x1a>
  8008cf:	84 d2                	test   %dl,%dl
  8008d1:	75 f2                	jne    8008c5 <strfind+0xc>
			break;
	return (char *) s;
}
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	57                   	push   %edi
  8008d9:	56                   	push   %esi
  8008da:	53                   	push   %ebx
  8008db:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008de:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008e1:	85 c9                	test   %ecx,%ecx
  8008e3:	74 13                	je     8008f8 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008e5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008eb:	75 05                	jne    8008f2 <memset+0x1d>
  8008ed:	f6 c1 03             	test   $0x3,%cl
  8008f0:	74 0d                	je     8008ff <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f5:	fc                   	cld    
  8008f6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008f8:	89 f8                	mov    %edi,%eax
  8008fa:	5b                   	pop    %ebx
  8008fb:	5e                   	pop    %esi
  8008fc:	5f                   	pop    %edi
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    
		c &= 0xFF;
  8008ff:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800903:	89 d3                	mov    %edx,%ebx
  800905:	c1 e3 08             	shl    $0x8,%ebx
  800908:	89 d0                	mov    %edx,%eax
  80090a:	c1 e0 18             	shl    $0x18,%eax
  80090d:	89 d6                	mov    %edx,%esi
  80090f:	c1 e6 10             	shl    $0x10,%esi
  800912:	09 f0                	or     %esi,%eax
  800914:	09 c2                	or     %eax,%edx
  800916:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800918:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80091b:	89 d0                	mov    %edx,%eax
  80091d:	fc                   	cld    
  80091e:	f3 ab                	rep stos %eax,%es:(%edi)
  800920:	eb d6                	jmp    8008f8 <memset+0x23>

00800922 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	57                   	push   %edi
  800926:	56                   	push   %esi
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80092d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800930:	39 c6                	cmp    %eax,%esi
  800932:	73 35                	jae    800969 <memmove+0x47>
  800934:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800937:	39 c2                	cmp    %eax,%edx
  800939:	76 2e                	jbe    800969 <memmove+0x47>
		s += n;
		d += n;
  80093b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093e:	89 d6                	mov    %edx,%esi
  800940:	09 fe                	or     %edi,%esi
  800942:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800948:	74 0c                	je     800956 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80094a:	83 ef 01             	sub    $0x1,%edi
  80094d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800950:	fd                   	std    
  800951:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800953:	fc                   	cld    
  800954:	eb 21                	jmp    800977 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800956:	f6 c1 03             	test   $0x3,%cl
  800959:	75 ef                	jne    80094a <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80095b:	83 ef 04             	sub    $0x4,%edi
  80095e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800961:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800964:	fd                   	std    
  800965:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800967:	eb ea                	jmp    800953 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800969:	89 f2                	mov    %esi,%edx
  80096b:	09 c2                	or     %eax,%edx
  80096d:	f6 c2 03             	test   $0x3,%dl
  800970:	74 09                	je     80097b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800972:	89 c7                	mov    %eax,%edi
  800974:	fc                   	cld    
  800975:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800977:	5e                   	pop    %esi
  800978:	5f                   	pop    %edi
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097b:	f6 c1 03             	test   $0x3,%cl
  80097e:	75 f2                	jne    800972 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800980:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800983:	89 c7                	mov    %eax,%edi
  800985:	fc                   	cld    
  800986:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800988:	eb ed                	jmp    800977 <memmove+0x55>

0080098a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80098d:	ff 75 10             	pushl  0x10(%ebp)
  800990:	ff 75 0c             	pushl  0xc(%ebp)
  800993:	ff 75 08             	pushl  0x8(%ebp)
  800996:	e8 87 ff ff ff       	call   800922 <memmove>
}
  80099b:	c9                   	leave  
  80099c:	c3                   	ret    

0080099d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	56                   	push   %esi
  8009a1:	53                   	push   %ebx
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a8:	89 c6                	mov    %eax,%esi
  8009aa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ad:	39 f0                	cmp    %esi,%eax
  8009af:	74 1c                	je     8009cd <memcmp+0x30>
		if (*s1 != *s2)
  8009b1:	0f b6 08             	movzbl (%eax),%ecx
  8009b4:	0f b6 1a             	movzbl (%edx),%ebx
  8009b7:	38 d9                	cmp    %bl,%cl
  8009b9:	75 08                	jne    8009c3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009bb:	83 c0 01             	add    $0x1,%eax
  8009be:	83 c2 01             	add    $0x1,%edx
  8009c1:	eb ea                	jmp    8009ad <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009c3:	0f b6 c1             	movzbl %cl,%eax
  8009c6:	0f b6 db             	movzbl %bl,%ebx
  8009c9:	29 d8                	sub    %ebx,%eax
  8009cb:	eb 05                	jmp    8009d2 <memcmp+0x35>
	}

	return 0;
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d2:	5b                   	pop    %ebx
  8009d3:	5e                   	pop    %esi
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    

008009d6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009df:	89 c2                	mov    %eax,%edx
  8009e1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009e4:	39 d0                	cmp    %edx,%eax
  8009e6:	73 09                	jae    8009f1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009e8:	38 08                	cmp    %cl,(%eax)
  8009ea:	74 05                	je     8009f1 <memfind+0x1b>
	for (; s < ends; s++)
  8009ec:	83 c0 01             	add    $0x1,%eax
  8009ef:	eb f3                	jmp    8009e4 <memfind+0xe>
			break;
	return (void *) s;
}
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	57                   	push   %edi
  8009f7:	56                   	push   %esi
  8009f8:	53                   	push   %ebx
  8009f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009ff:	eb 03                	jmp    800a04 <strtol+0x11>
		s++;
  800a01:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a04:	0f b6 01             	movzbl (%ecx),%eax
  800a07:	3c 20                	cmp    $0x20,%al
  800a09:	74 f6                	je     800a01 <strtol+0xe>
  800a0b:	3c 09                	cmp    $0x9,%al
  800a0d:	74 f2                	je     800a01 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a0f:	3c 2b                	cmp    $0x2b,%al
  800a11:	74 2e                	je     800a41 <strtol+0x4e>
	int neg = 0;
  800a13:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a18:	3c 2d                	cmp    $0x2d,%al
  800a1a:	74 2f                	je     800a4b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a1c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a22:	75 05                	jne    800a29 <strtol+0x36>
  800a24:	80 39 30             	cmpb   $0x30,(%ecx)
  800a27:	74 2c                	je     800a55 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a29:	85 db                	test   %ebx,%ebx
  800a2b:	75 0a                	jne    800a37 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a2d:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a32:	80 39 30             	cmpb   $0x30,(%ecx)
  800a35:	74 28                	je     800a5f <strtol+0x6c>
		base = 10;
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a3f:	eb 50                	jmp    800a91 <strtol+0x9e>
		s++;
  800a41:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a44:	bf 00 00 00 00       	mov    $0x0,%edi
  800a49:	eb d1                	jmp    800a1c <strtol+0x29>
		s++, neg = 1;
  800a4b:	83 c1 01             	add    $0x1,%ecx
  800a4e:	bf 01 00 00 00       	mov    $0x1,%edi
  800a53:	eb c7                	jmp    800a1c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a55:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a59:	74 0e                	je     800a69 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a5b:	85 db                	test   %ebx,%ebx
  800a5d:	75 d8                	jne    800a37 <strtol+0x44>
		s++, base = 8;
  800a5f:	83 c1 01             	add    $0x1,%ecx
  800a62:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a67:	eb ce                	jmp    800a37 <strtol+0x44>
		s += 2, base = 16;
  800a69:	83 c1 02             	add    $0x2,%ecx
  800a6c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a71:	eb c4                	jmp    800a37 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a73:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a76:	89 f3                	mov    %esi,%ebx
  800a78:	80 fb 19             	cmp    $0x19,%bl
  800a7b:	77 29                	ja     800aa6 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a7d:	0f be d2             	movsbl %dl,%edx
  800a80:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a83:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a86:	7d 30                	jge    800ab8 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a88:	83 c1 01             	add    $0x1,%ecx
  800a8b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a8f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a91:	0f b6 11             	movzbl (%ecx),%edx
  800a94:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a97:	89 f3                	mov    %esi,%ebx
  800a99:	80 fb 09             	cmp    $0x9,%bl
  800a9c:	77 d5                	ja     800a73 <strtol+0x80>
			dig = *s - '0';
  800a9e:	0f be d2             	movsbl %dl,%edx
  800aa1:	83 ea 30             	sub    $0x30,%edx
  800aa4:	eb dd                	jmp    800a83 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800aa6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aa9:	89 f3                	mov    %esi,%ebx
  800aab:	80 fb 19             	cmp    $0x19,%bl
  800aae:	77 08                	ja     800ab8 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ab0:	0f be d2             	movsbl %dl,%edx
  800ab3:	83 ea 37             	sub    $0x37,%edx
  800ab6:	eb cb                	jmp    800a83 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ab8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800abc:	74 05                	je     800ac3 <strtol+0xd0>
		*endptr = (char *) s;
  800abe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ac3:	89 c2                	mov    %eax,%edx
  800ac5:	f7 da                	neg    %edx
  800ac7:	85 ff                	test   %edi,%edi
  800ac9:	0f 45 c2             	cmovne %edx,%eax
}
  800acc:	5b                   	pop    %ebx
  800acd:	5e                   	pop    %esi
  800ace:	5f                   	pop    %edi
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	57                   	push   %edi
  800ad5:	56                   	push   %esi
  800ad6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  800adc:	8b 55 08             	mov    0x8(%ebp),%edx
  800adf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae2:	89 c3                	mov    %eax,%ebx
  800ae4:	89 c7                	mov    %eax,%edi
  800ae6:	89 c6                	mov    %eax,%esi
  800ae8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aea:	5b                   	pop    %ebx
  800aeb:	5e                   	pop    %esi
  800aec:	5f                   	pop    %edi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <sys_cgetc>:

int
sys_cgetc(void)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	57                   	push   %edi
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800af5:	ba 00 00 00 00       	mov    $0x0,%edx
  800afa:	b8 01 00 00 00       	mov    $0x1,%eax
  800aff:	89 d1                	mov    %edx,%ecx
  800b01:	89 d3                	mov    %edx,%ebx
  800b03:	89 d7                	mov    %edx,%edi
  800b05:	89 d6                	mov    %edx,%esi
  800b07:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b09:	5b                   	pop    %ebx
  800b0a:	5e                   	pop    %esi
  800b0b:	5f                   	pop    %edi
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	57                   	push   %edi
  800b12:	56                   	push   %esi
  800b13:	53                   	push   %ebx
  800b14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b17:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b24:	89 cb                	mov    %ecx,%ebx
  800b26:	89 cf                	mov    %ecx,%edi
  800b28:	89 ce                	mov    %ecx,%esi
  800b2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b2c:	85 c0                	test   %eax,%eax
  800b2e:	7f 08                	jg     800b38 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b33:	5b                   	pop    %ebx
  800b34:	5e                   	pop    %esi
  800b35:	5f                   	pop    %edi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	50                   	push   %eax
  800b3c:	6a 03                	push   $0x3
  800b3e:	68 df 23 80 00       	push   $0x8023df
  800b43:	6a 23                	push   $0x23
  800b45:	68 fc 23 80 00       	push   $0x8023fc
  800b4a:	e8 23 11 00 00       	call   801c72 <_panic>

00800b4f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b55:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5a:	b8 02 00 00 00       	mov    $0x2,%eax
  800b5f:	89 d1                	mov    %edx,%ecx
  800b61:	89 d3                	mov    %edx,%ebx
  800b63:	89 d7                	mov    %edx,%edi
  800b65:	89 d6                	mov    %edx,%esi
  800b67:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b69:	5b                   	pop    %ebx
  800b6a:	5e                   	pop    %esi
  800b6b:	5f                   	pop    %edi
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    

00800b6e <sys_yield>:

void
sys_yield(void)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	57                   	push   %edi
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b74:	ba 00 00 00 00       	mov    $0x0,%edx
  800b79:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b7e:	89 d1                	mov    %edx,%ecx
  800b80:	89 d3                	mov    %edx,%ebx
  800b82:	89 d7                	mov    %edx,%edi
  800b84:	89 d6                	mov    %edx,%esi
  800b86:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5f                   	pop    %edi
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	57                   	push   %edi
  800b91:	56                   	push   %esi
  800b92:	53                   	push   %ebx
  800b93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b96:	be 00 00 00 00       	mov    $0x0,%esi
  800b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ba6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ba9:	89 f7                	mov    %esi,%edi
  800bab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bad:	85 c0                	test   %eax,%eax
  800baf:	7f 08                	jg     800bb9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb4:	5b                   	pop    %ebx
  800bb5:	5e                   	pop    %esi
  800bb6:	5f                   	pop    %edi
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb9:	83 ec 0c             	sub    $0xc,%esp
  800bbc:	50                   	push   %eax
  800bbd:	6a 04                	push   $0x4
  800bbf:	68 df 23 80 00       	push   $0x8023df
  800bc4:	6a 23                	push   $0x23
  800bc6:	68 fc 23 80 00       	push   $0x8023fc
  800bcb:	e8 a2 10 00 00       	call   801c72 <_panic>

00800bd0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	57                   	push   %edi
  800bd4:	56                   	push   %esi
  800bd5:	53                   	push   %ebx
  800bd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdf:	b8 05 00 00 00       	mov    $0x5,%eax
  800be4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800be7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bea:	8b 75 18             	mov    0x18(%ebp),%esi
  800bed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bef:	85 c0                	test   %eax,%eax
  800bf1:	7f 08                	jg     800bfb <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5f                   	pop    %edi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bfb:	83 ec 0c             	sub    $0xc,%esp
  800bfe:	50                   	push   %eax
  800bff:	6a 05                	push   $0x5
  800c01:	68 df 23 80 00       	push   $0x8023df
  800c06:	6a 23                	push   $0x23
  800c08:	68 fc 23 80 00       	push   $0x8023fc
  800c0d:	e8 60 10 00 00       	call   801c72 <_panic>

00800c12 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c20:	8b 55 08             	mov    0x8(%ebp),%edx
  800c23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c26:	b8 06 00 00 00       	mov    $0x6,%eax
  800c2b:	89 df                	mov    %ebx,%edi
  800c2d:	89 de                	mov    %ebx,%esi
  800c2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c31:	85 c0                	test   %eax,%eax
  800c33:	7f 08                	jg     800c3d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5f                   	pop    %edi
  800c3b:	5d                   	pop    %ebp
  800c3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3d:	83 ec 0c             	sub    $0xc,%esp
  800c40:	50                   	push   %eax
  800c41:	6a 06                	push   $0x6
  800c43:	68 df 23 80 00       	push   $0x8023df
  800c48:	6a 23                	push   $0x23
  800c4a:	68 fc 23 80 00       	push   $0x8023fc
  800c4f:	e8 1e 10 00 00       	call   801c72 <_panic>

00800c54 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
  800c5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c62:	8b 55 08             	mov    0x8(%ebp),%edx
  800c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c68:	b8 08 00 00 00       	mov    $0x8,%eax
  800c6d:	89 df                	mov    %ebx,%edi
  800c6f:	89 de                	mov    %ebx,%esi
  800c71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c73:	85 c0                	test   %eax,%eax
  800c75:	7f 08                	jg     800c7f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7a:	5b                   	pop    %ebx
  800c7b:	5e                   	pop    %esi
  800c7c:	5f                   	pop    %edi
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7f:	83 ec 0c             	sub    $0xc,%esp
  800c82:	50                   	push   %eax
  800c83:	6a 08                	push   $0x8
  800c85:	68 df 23 80 00       	push   $0x8023df
  800c8a:	6a 23                	push   $0x23
  800c8c:	68 fc 23 80 00       	push   $0x8023fc
  800c91:	e8 dc 0f 00 00       	call   801c72 <_panic>

00800c96 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	57                   	push   %edi
  800c9a:	56                   	push   %esi
  800c9b:	53                   	push   %ebx
  800c9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caa:	b8 09 00 00 00       	mov    $0x9,%eax
  800caf:	89 df                	mov    %ebx,%edi
  800cb1:	89 de                	mov    %ebx,%esi
  800cb3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb5:	85 c0                	test   %eax,%eax
  800cb7:	7f 08                	jg     800cc1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5f                   	pop    %edi
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc1:	83 ec 0c             	sub    $0xc,%esp
  800cc4:	50                   	push   %eax
  800cc5:	6a 09                	push   $0x9
  800cc7:	68 df 23 80 00       	push   $0x8023df
  800ccc:	6a 23                	push   $0x23
  800cce:	68 fc 23 80 00       	push   $0x8023fc
  800cd3:	e8 9a 0f 00 00       	call   801c72 <_panic>

00800cd8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	57                   	push   %edi
  800cdc:	56                   	push   %esi
  800cdd:	53                   	push   %ebx
  800cde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cf1:	89 df                	mov    %ebx,%edi
  800cf3:	89 de                	mov    %ebx,%esi
  800cf5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	7f 08                	jg     800d03 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d03:	83 ec 0c             	sub    $0xc,%esp
  800d06:	50                   	push   %eax
  800d07:	6a 0a                	push   $0xa
  800d09:	68 df 23 80 00       	push   $0x8023df
  800d0e:	6a 23                	push   $0x23
  800d10:	68 fc 23 80 00       	push   $0x8023fc
  800d15:	e8 58 0f 00 00       	call   801c72 <_panic>

00800d1a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	57                   	push   %edi
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d20:	8b 55 08             	mov    0x8(%ebp),%edx
  800d23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d26:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d2b:	be 00 00 00 00       	mov    $0x0,%esi
  800d30:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d33:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d36:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
  800d43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d53:	89 cb                	mov    %ecx,%ebx
  800d55:	89 cf                	mov    %ecx,%edi
  800d57:	89 ce                	mov    %ecx,%esi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d67:	83 ec 0c             	sub    $0xc,%esp
  800d6a:	50                   	push   %eax
  800d6b:	6a 0d                	push   $0xd
  800d6d:	68 df 23 80 00       	push   $0x8023df
  800d72:	6a 23                	push   $0x23
  800d74:	68 fc 23 80 00       	push   $0x8023fc
  800d79:	e8 f4 0e 00 00       	call   801c72 <_panic>

00800d7e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800d84:	68 0a 24 80 00       	push   $0x80240a
  800d89:	6a 25                	push   $0x25
  800d8b:	68 22 24 80 00       	push   $0x802422
  800d90:	e8 dd 0e 00 00       	call   801c72 <_panic>

00800d95 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
  800d9b:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  800d9e:	68 7e 0d 80 00       	push   $0x800d7e
  800da3:	e8 10 0f 00 00       	call   801cb8 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800da8:	b8 07 00 00 00       	mov    $0x7,%eax
  800dad:	cd 30                	int    $0x30
  800daf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800db2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  800db5:	83 c4 10             	add    $0x10,%esp
  800db8:	85 c0                	test   %eax,%eax
  800dba:	78 27                	js     800de3 <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800dbc:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  800dc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dc5:	75 65                	jne    800e2c <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800dc7:	e8 83 fd ff ff       	call   800b4f <sys_getenvid>
  800dcc:	25 ff 03 00 00       	and    $0x3ff,%eax
  800dd1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800dd4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800dd9:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800dde:	e9 11 01 00 00       	jmp    800ef4 <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  800de3:	50                   	push   %eax
  800de4:	68 2d 24 80 00       	push   $0x80242d
  800de9:	6a 6f                	push   $0x6f
  800deb:	68 22 24 80 00       	push   $0x802422
  800df0:	e8 7d 0e 00 00       	call   801c72 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  800df5:	e8 55 fd ff ff       	call   800b4f <sys_getenvid>
  800dfa:	83 ec 0c             	sub    $0xc,%esp
  800dfd:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800e03:	56                   	push   %esi
  800e04:	57                   	push   %edi
  800e05:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e08:	57                   	push   %edi
  800e09:	50                   	push   %eax
  800e0a:	e8 c1 fd ff ff       	call   800bd0 <sys_page_map>
  800e0f:	83 c4 20             	add    $0x20,%esp
  800e12:	85 c0                	test   %eax,%eax
  800e14:	0f 88 84 00 00 00    	js     800e9e <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800e1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800e20:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800e26:	0f 84 84 00 00 00    	je     800eb0 <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  800e2c:	89 d8                	mov    %ebx,%eax
  800e2e:	c1 e8 16             	shr    $0x16,%eax
  800e31:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e38:	a8 01                	test   $0x1,%al
  800e3a:	74 de                	je     800e1a <fork+0x85>
  800e3c:	89 d8                	mov    %ebx,%eax
  800e3e:	c1 e8 0c             	shr    $0xc,%eax
  800e41:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800e48:	f6 c2 01             	test   $0x1,%dl
  800e4b:	74 cd                	je     800e1a <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  800e4d:	89 c7                	mov    %eax,%edi
  800e4f:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  800e52:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  800e59:	f7 c6 00 04 00 00    	test   $0x400,%esi
  800e5f:	75 94                	jne    800df5 <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  800e61:	f7 c6 02 08 00 00    	test   $0x802,%esi
  800e67:	0f 85 d1 00 00 00    	jne    800f3e <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800e6d:	a1 04 40 80 00       	mov    0x804004,%eax
  800e72:	8b 40 48             	mov    0x48(%eax),%eax
  800e75:	83 ec 0c             	sub    $0xc,%esp
  800e78:	6a 05                	push   $0x5
  800e7a:	57                   	push   %edi
  800e7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e7e:	57                   	push   %edi
  800e7f:	50                   	push   %eax
  800e80:	e8 4b fd ff ff       	call   800bd0 <sys_page_map>
  800e85:	83 c4 20             	add    $0x20,%esp
  800e88:	85 c0                	test   %eax,%eax
  800e8a:	79 8e                	jns    800e1a <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  800e8c:	50                   	push   %eax
  800e8d:	68 84 24 80 00       	push   $0x802484
  800e92:	6a 4a                	push   $0x4a
  800e94:	68 22 24 80 00       	push   $0x802422
  800e99:	e8 d4 0d 00 00       	call   801c72 <_panic>
                        panic("duppage: page mapping failed %e", r);
  800e9e:	50                   	push   %eax
  800e9f:	68 64 24 80 00       	push   $0x802464
  800ea4:	6a 41                	push   $0x41
  800ea6:	68 22 24 80 00       	push   $0x802422
  800eab:	e8 c2 0d 00 00       	call   801c72 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  800eb0:	83 ec 04             	sub    $0x4,%esp
  800eb3:	6a 07                	push   $0x7
  800eb5:	68 00 f0 bf ee       	push   $0xeebff000
  800eba:	ff 75 e0             	pushl  -0x20(%ebp)
  800ebd:	e8 cb fc ff ff       	call   800b8d <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	78 36                	js     800eff <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	68 2c 1d 80 00       	push   $0x801d2c
  800ed1:	ff 75 e0             	pushl  -0x20(%ebp)
  800ed4:	e8 ff fd ff ff       	call   800cd8 <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800ed9:	83 c4 10             	add    $0x10,%esp
  800edc:	85 c0                	test   %eax,%eax
  800ede:	78 34                	js     800f14 <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	6a 02                	push   $0x2
  800ee5:	ff 75 e0             	pushl  -0x20(%ebp)
  800ee8:	e8 67 fd ff ff       	call   800c54 <sys_env_set_status>
  800eed:	83 c4 10             	add    $0x10,%esp
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	78 35                	js     800f29 <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  800ef4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ef7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efa:	5b                   	pop    %ebx
  800efb:	5e                   	pop    %esi
  800efc:	5f                   	pop    %edi
  800efd:	5d                   	pop    %ebp
  800efe:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  800eff:	50                   	push   %eax
  800f00:	68 2d 24 80 00       	push   $0x80242d
  800f05:	68 82 00 00 00       	push   $0x82
  800f0a:	68 22 24 80 00       	push   $0x802422
  800f0f:	e8 5e 0d 00 00       	call   801c72 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800f14:	50                   	push   %eax
  800f15:	68 a8 24 80 00       	push   $0x8024a8
  800f1a:	68 87 00 00 00       	push   $0x87
  800f1f:	68 22 24 80 00       	push   $0x802422
  800f24:	e8 49 0d 00 00       	call   801c72 <_panic>
        	panic("sys_env_set_status: %e", r);
  800f29:	50                   	push   %eax
  800f2a:	68 36 24 80 00       	push   $0x802436
  800f2f:	68 8b 00 00 00       	push   $0x8b
  800f34:	68 22 24 80 00       	push   $0x802422
  800f39:	e8 34 0d 00 00       	call   801c72 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800f3e:	a1 04 40 80 00       	mov    0x804004,%eax
  800f43:	8b 40 48             	mov    0x48(%eax),%eax
  800f46:	83 ec 0c             	sub    $0xc,%esp
  800f49:	68 05 08 00 00       	push   $0x805
  800f4e:	57                   	push   %edi
  800f4f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f52:	57                   	push   %edi
  800f53:	50                   	push   %eax
  800f54:	e8 77 fc ff ff       	call   800bd0 <sys_page_map>
  800f59:	83 c4 20             	add    $0x20,%esp
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	0f 88 28 ff ff ff    	js     800e8c <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  800f64:	a1 04 40 80 00       	mov    0x804004,%eax
  800f69:	8b 50 48             	mov    0x48(%eax),%edx
  800f6c:	8b 40 48             	mov    0x48(%eax),%eax
  800f6f:	83 ec 0c             	sub    $0xc,%esp
  800f72:	68 05 08 00 00       	push   $0x805
  800f77:	57                   	push   %edi
  800f78:	52                   	push   %edx
  800f79:	57                   	push   %edi
  800f7a:	50                   	push   %eax
  800f7b:	e8 50 fc ff ff       	call   800bd0 <sys_page_map>
  800f80:	83 c4 20             	add    $0x20,%esp
  800f83:	85 c0                	test   %eax,%eax
  800f85:	0f 89 8f fe ff ff    	jns    800e1a <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  800f8b:	50                   	push   %eax
  800f8c:	68 84 24 80 00       	push   $0x802484
  800f91:	6a 4f                	push   $0x4f
  800f93:	68 22 24 80 00       	push   $0x802422
  800f98:	e8 d5 0c 00 00       	call   801c72 <_panic>

00800f9d <sfork>:

// Challenge!
int
sfork(void)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  800fa3:	68 4d 24 80 00       	push   $0x80244d
  800fa8:	68 94 00 00 00       	push   $0x94
  800fad:	68 22 24 80 00       	push   $0x802422
  800fb2:	e8 bb 0c 00 00       	call   801c72 <_panic>

00800fb7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	05 00 00 00 30       	add    $0x30000000,%eax
  800fc2:	c1 e8 0c             	shr    $0xc,%eax
}
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fdc:	5d                   	pop    %ebp
  800fdd:	c3                   	ret    

00800fde <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fe9:	89 c2                	mov    %eax,%edx
  800feb:	c1 ea 16             	shr    $0x16,%edx
  800fee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff5:	f6 c2 01             	test   $0x1,%dl
  800ff8:	74 2a                	je     801024 <fd_alloc+0x46>
  800ffa:	89 c2                	mov    %eax,%edx
  800ffc:	c1 ea 0c             	shr    $0xc,%edx
  800fff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801006:	f6 c2 01             	test   $0x1,%dl
  801009:	74 19                	je     801024 <fd_alloc+0x46>
  80100b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801010:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801015:	75 d2                	jne    800fe9 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801017:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80101d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801022:	eb 07                	jmp    80102b <fd_alloc+0x4d>
			*fd_store = fd;
  801024:	89 01                	mov    %eax,(%ecx)
			return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102b:	5d                   	pop    %ebp
  80102c:	c3                   	ret    

0080102d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801033:	83 f8 1f             	cmp    $0x1f,%eax
  801036:	77 36                	ja     80106e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801038:	c1 e0 0c             	shl    $0xc,%eax
  80103b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801040:	89 c2                	mov    %eax,%edx
  801042:	c1 ea 16             	shr    $0x16,%edx
  801045:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80104c:	f6 c2 01             	test   $0x1,%dl
  80104f:	74 24                	je     801075 <fd_lookup+0x48>
  801051:	89 c2                	mov    %eax,%edx
  801053:	c1 ea 0c             	shr    $0xc,%edx
  801056:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80105d:	f6 c2 01             	test   $0x1,%dl
  801060:	74 1a                	je     80107c <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801062:	8b 55 0c             	mov    0xc(%ebp),%edx
  801065:	89 02                	mov    %eax,(%edx)
	return 0;
  801067:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106c:	5d                   	pop    %ebp
  80106d:	c3                   	ret    
		return -E_INVAL;
  80106e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801073:	eb f7                	jmp    80106c <fd_lookup+0x3f>
		return -E_INVAL;
  801075:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107a:	eb f0                	jmp    80106c <fd_lookup+0x3f>
  80107c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801081:	eb e9                	jmp    80106c <fd_lookup+0x3f>

00801083 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108c:	ba 48 25 80 00       	mov    $0x802548,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801091:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801096:	39 08                	cmp    %ecx,(%eax)
  801098:	74 33                	je     8010cd <dev_lookup+0x4a>
  80109a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80109d:	8b 02                	mov    (%edx),%eax
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	75 f3                	jne    801096 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010a3:	a1 04 40 80 00       	mov    0x804004,%eax
  8010a8:	8b 40 48             	mov    0x48(%eax),%eax
  8010ab:	83 ec 04             	sub    $0x4,%esp
  8010ae:	51                   	push   %ecx
  8010af:	50                   	push   %eax
  8010b0:	68 cc 24 80 00       	push   $0x8024cc
  8010b5:	e8 f0 f0 ff ff       	call   8001aa <cprintf>
	*dev = 0;
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010c3:	83 c4 10             	add    $0x10,%esp
  8010c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    
			*dev = devtab[i];
  8010cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d7:	eb f2                	jmp    8010cb <dev_lookup+0x48>

008010d9 <fd_close>:
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	57                   	push   %edi
  8010dd:	56                   	push   %esi
  8010de:	53                   	push   %ebx
  8010df:	83 ec 1c             	sub    $0x1c,%esp
  8010e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8010e5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010eb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010ec:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010f2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f5:	50                   	push   %eax
  8010f6:	e8 32 ff ff ff       	call   80102d <fd_lookup>
  8010fb:	89 c3                	mov    %eax,%ebx
  8010fd:	83 c4 08             	add    $0x8,%esp
  801100:	85 c0                	test   %eax,%eax
  801102:	78 05                	js     801109 <fd_close+0x30>
	    || fd != fd2)
  801104:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801107:	74 16                	je     80111f <fd_close+0x46>
		return (must_exist ? r : 0);
  801109:	89 f8                	mov    %edi,%eax
  80110b:	84 c0                	test   %al,%al
  80110d:	b8 00 00 00 00       	mov    $0x0,%eax
  801112:	0f 44 d8             	cmove  %eax,%ebx
}
  801115:	89 d8                	mov    %ebx,%eax
  801117:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111a:	5b                   	pop    %ebx
  80111b:	5e                   	pop    %esi
  80111c:	5f                   	pop    %edi
  80111d:	5d                   	pop    %ebp
  80111e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80111f:	83 ec 08             	sub    $0x8,%esp
  801122:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801125:	50                   	push   %eax
  801126:	ff 36                	pushl  (%esi)
  801128:	e8 56 ff ff ff       	call   801083 <dev_lookup>
  80112d:	89 c3                	mov    %eax,%ebx
  80112f:	83 c4 10             	add    $0x10,%esp
  801132:	85 c0                	test   %eax,%eax
  801134:	78 15                	js     80114b <fd_close+0x72>
		if (dev->dev_close)
  801136:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801139:	8b 40 10             	mov    0x10(%eax),%eax
  80113c:	85 c0                	test   %eax,%eax
  80113e:	74 1b                	je     80115b <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801140:	83 ec 0c             	sub    $0xc,%esp
  801143:	56                   	push   %esi
  801144:	ff d0                	call   *%eax
  801146:	89 c3                	mov    %eax,%ebx
  801148:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80114b:	83 ec 08             	sub    $0x8,%esp
  80114e:	56                   	push   %esi
  80114f:	6a 00                	push   $0x0
  801151:	e8 bc fa ff ff       	call   800c12 <sys_page_unmap>
	return r;
  801156:	83 c4 10             	add    $0x10,%esp
  801159:	eb ba                	jmp    801115 <fd_close+0x3c>
			r = 0;
  80115b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801160:	eb e9                	jmp    80114b <fd_close+0x72>

00801162 <close>:

int
close(int fdnum)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801168:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80116b:	50                   	push   %eax
  80116c:	ff 75 08             	pushl  0x8(%ebp)
  80116f:	e8 b9 fe ff ff       	call   80102d <fd_lookup>
  801174:	83 c4 08             	add    $0x8,%esp
  801177:	85 c0                	test   %eax,%eax
  801179:	78 10                	js     80118b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	6a 01                	push   $0x1
  801180:	ff 75 f4             	pushl  -0xc(%ebp)
  801183:	e8 51 ff ff ff       	call   8010d9 <fd_close>
  801188:	83 c4 10             	add    $0x10,%esp
}
  80118b:	c9                   	leave  
  80118c:	c3                   	ret    

0080118d <close_all>:

void
close_all(void)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	53                   	push   %ebx
  801191:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801194:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801199:	83 ec 0c             	sub    $0xc,%esp
  80119c:	53                   	push   %ebx
  80119d:	e8 c0 ff ff ff       	call   801162 <close>
	for (i = 0; i < MAXFD; i++)
  8011a2:	83 c3 01             	add    $0x1,%ebx
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	83 fb 20             	cmp    $0x20,%ebx
  8011ab:	75 ec                	jne    801199 <close_all+0xc>
}
  8011ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    

008011b2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	57                   	push   %edi
  8011b6:	56                   	push   %esi
  8011b7:	53                   	push   %ebx
  8011b8:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011be:	50                   	push   %eax
  8011bf:	ff 75 08             	pushl  0x8(%ebp)
  8011c2:	e8 66 fe ff ff       	call   80102d <fd_lookup>
  8011c7:	89 c3                	mov    %eax,%ebx
  8011c9:	83 c4 08             	add    $0x8,%esp
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	0f 88 81 00 00 00    	js     801255 <dup+0xa3>
		return r;
	close(newfdnum);
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	ff 75 0c             	pushl  0xc(%ebp)
  8011da:	e8 83 ff ff ff       	call   801162 <close>

	newfd = INDEX2FD(newfdnum);
  8011df:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011e2:	c1 e6 0c             	shl    $0xc,%esi
  8011e5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011eb:	83 c4 04             	add    $0x4,%esp
  8011ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f1:	e8 d1 fd ff ff       	call   800fc7 <fd2data>
  8011f6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011f8:	89 34 24             	mov    %esi,(%esp)
  8011fb:	e8 c7 fd ff ff       	call   800fc7 <fd2data>
  801200:	83 c4 10             	add    $0x10,%esp
  801203:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801205:	89 d8                	mov    %ebx,%eax
  801207:	c1 e8 16             	shr    $0x16,%eax
  80120a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801211:	a8 01                	test   $0x1,%al
  801213:	74 11                	je     801226 <dup+0x74>
  801215:	89 d8                	mov    %ebx,%eax
  801217:	c1 e8 0c             	shr    $0xc,%eax
  80121a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801221:	f6 c2 01             	test   $0x1,%dl
  801224:	75 39                	jne    80125f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801226:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801229:	89 d0                	mov    %edx,%eax
  80122b:	c1 e8 0c             	shr    $0xc,%eax
  80122e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	25 07 0e 00 00       	and    $0xe07,%eax
  80123d:	50                   	push   %eax
  80123e:	56                   	push   %esi
  80123f:	6a 00                	push   $0x0
  801241:	52                   	push   %edx
  801242:	6a 00                	push   $0x0
  801244:	e8 87 f9 ff ff       	call   800bd0 <sys_page_map>
  801249:	89 c3                	mov    %eax,%ebx
  80124b:	83 c4 20             	add    $0x20,%esp
  80124e:	85 c0                	test   %eax,%eax
  801250:	78 31                	js     801283 <dup+0xd1>
		goto err;

	return newfdnum;
  801252:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801255:	89 d8                	mov    %ebx,%eax
  801257:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125a:	5b                   	pop    %ebx
  80125b:	5e                   	pop    %esi
  80125c:	5f                   	pop    %edi
  80125d:	5d                   	pop    %ebp
  80125e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80125f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	25 07 0e 00 00       	and    $0xe07,%eax
  80126e:	50                   	push   %eax
  80126f:	57                   	push   %edi
  801270:	6a 00                	push   $0x0
  801272:	53                   	push   %ebx
  801273:	6a 00                	push   $0x0
  801275:	e8 56 f9 ff ff       	call   800bd0 <sys_page_map>
  80127a:	89 c3                	mov    %eax,%ebx
  80127c:	83 c4 20             	add    $0x20,%esp
  80127f:	85 c0                	test   %eax,%eax
  801281:	79 a3                	jns    801226 <dup+0x74>
	sys_page_unmap(0, newfd);
  801283:	83 ec 08             	sub    $0x8,%esp
  801286:	56                   	push   %esi
  801287:	6a 00                	push   $0x0
  801289:	e8 84 f9 ff ff       	call   800c12 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80128e:	83 c4 08             	add    $0x8,%esp
  801291:	57                   	push   %edi
  801292:	6a 00                	push   $0x0
  801294:	e8 79 f9 ff ff       	call   800c12 <sys_page_unmap>
	return r;
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	eb b7                	jmp    801255 <dup+0xa3>

0080129e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 14             	sub    $0x14,%esp
  8012a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ab:	50                   	push   %eax
  8012ac:	53                   	push   %ebx
  8012ad:	e8 7b fd ff ff       	call   80102d <fd_lookup>
  8012b2:	83 c4 08             	add    $0x8,%esp
  8012b5:	85 c0                	test   %eax,%eax
  8012b7:	78 3f                	js     8012f8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b9:	83 ec 08             	sub    $0x8,%esp
  8012bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012bf:	50                   	push   %eax
  8012c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c3:	ff 30                	pushl  (%eax)
  8012c5:	e8 b9 fd ff ff       	call   801083 <dev_lookup>
  8012ca:	83 c4 10             	add    $0x10,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	78 27                	js     8012f8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012d4:	8b 42 08             	mov    0x8(%edx),%eax
  8012d7:	83 e0 03             	and    $0x3,%eax
  8012da:	83 f8 01             	cmp    $0x1,%eax
  8012dd:	74 1e                	je     8012fd <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e2:	8b 40 08             	mov    0x8(%eax),%eax
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	74 35                	je     80131e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012e9:	83 ec 04             	sub    $0x4,%esp
  8012ec:	ff 75 10             	pushl  0x10(%ebp)
  8012ef:	ff 75 0c             	pushl  0xc(%ebp)
  8012f2:	52                   	push   %edx
  8012f3:	ff d0                	call   *%eax
  8012f5:	83 c4 10             	add    $0x10,%esp
}
  8012f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012fd:	a1 04 40 80 00       	mov    0x804004,%eax
  801302:	8b 40 48             	mov    0x48(%eax),%eax
  801305:	83 ec 04             	sub    $0x4,%esp
  801308:	53                   	push   %ebx
  801309:	50                   	push   %eax
  80130a:	68 0d 25 80 00       	push   $0x80250d
  80130f:	e8 96 ee ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131c:	eb da                	jmp    8012f8 <read+0x5a>
		return -E_NOT_SUPP;
  80131e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801323:	eb d3                	jmp    8012f8 <read+0x5a>

00801325 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	57                   	push   %edi
  801329:	56                   	push   %esi
  80132a:	53                   	push   %ebx
  80132b:	83 ec 0c             	sub    $0xc,%esp
  80132e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801331:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801334:	bb 00 00 00 00       	mov    $0x0,%ebx
  801339:	39 f3                	cmp    %esi,%ebx
  80133b:	73 25                	jae    801362 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80133d:	83 ec 04             	sub    $0x4,%esp
  801340:	89 f0                	mov    %esi,%eax
  801342:	29 d8                	sub    %ebx,%eax
  801344:	50                   	push   %eax
  801345:	89 d8                	mov    %ebx,%eax
  801347:	03 45 0c             	add    0xc(%ebp),%eax
  80134a:	50                   	push   %eax
  80134b:	57                   	push   %edi
  80134c:	e8 4d ff ff ff       	call   80129e <read>
		if (m < 0)
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	85 c0                	test   %eax,%eax
  801356:	78 08                	js     801360 <readn+0x3b>
			return m;
		if (m == 0)
  801358:	85 c0                	test   %eax,%eax
  80135a:	74 06                	je     801362 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80135c:	01 c3                	add    %eax,%ebx
  80135e:	eb d9                	jmp    801339 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801360:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801362:	89 d8                	mov    %ebx,%eax
  801364:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801367:	5b                   	pop    %ebx
  801368:	5e                   	pop    %esi
  801369:	5f                   	pop    %edi
  80136a:	5d                   	pop    %ebp
  80136b:	c3                   	ret    

0080136c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	53                   	push   %ebx
  801370:	83 ec 14             	sub    $0x14,%esp
  801373:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801376:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801379:	50                   	push   %eax
  80137a:	53                   	push   %ebx
  80137b:	e8 ad fc ff ff       	call   80102d <fd_lookup>
  801380:	83 c4 08             	add    $0x8,%esp
  801383:	85 c0                	test   %eax,%eax
  801385:	78 3a                	js     8013c1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138d:	50                   	push   %eax
  80138e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801391:	ff 30                	pushl  (%eax)
  801393:	e8 eb fc ff ff       	call   801083 <dev_lookup>
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	85 c0                	test   %eax,%eax
  80139d:	78 22                	js     8013c1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80139f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013a6:	74 1e                	je     8013c6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ab:	8b 52 0c             	mov    0xc(%edx),%edx
  8013ae:	85 d2                	test   %edx,%edx
  8013b0:	74 35                	je     8013e7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013b2:	83 ec 04             	sub    $0x4,%esp
  8013b5:	ff 75 10             	pushl  0x10(%ebp)
  8013b8:	ff 75 0c             	pushl  0xc(%ebp)
  8013bb:	50                   	push   %eax
  8013bc:	ff d2                	call   *%edx
  8013be:	83 c4 10             	add    $0x10,%esp
}
  8013c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8013cb:	8b 40 48             	mov    0x48(%eax),%eax
  8013ce:	83 ec 04             	sub    $0x4,%esp
  8013d1:	53                   	push   %ebx
  8013d2:	50                   	push   %eax
  8013d3:	68 29 25 80 00       	push   $0x802529
  8013d8:	e8 cd ed ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e5:	eb da                	jmp    8013c1 <write+0x55>
		return -E_NOT_SUPP;
  8013e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013ec:	eb d3                	jmp    8013c1 <write+0x55>

008013ee <seek>:

int
seek(int fdnum, off_t offset)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013f4:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013f7:	50                   	push   %eax
  8013f8:	ff 75 08             	pushl  0x8(%ebp)
  8013fb:	e8 2d fc ff ff       	call   80102d <fd_lookup>
  801400:	83 c4 08             	add    $0x8,%esp
  801403:	85 c0                	test   %eax,%eax
  801405:	78 0e                	js     801415 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801407:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	53                   	push   %ebx
  80141b:	83 ec 14             	sub    $0x14,%esp
  80141e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801421:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801424:	50                   	push   %eax
  801425:	53                   	push   %ebx
  801426:	e8 02 fc ff ff       	call   80102d <fd_lookup>
  80142b:	83 c4 08             	add    $0x8,%esp
  80142e:	85 c0                	test   %eax,%eax
  801430:	78 37                	js     801469 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801432:	83 ec 08             	sub    $0x8,%esp
  801435:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801438:	50                   	push   %eax
  801439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143c:	ff 30                	pushl  (%eax)
  80143e:	e8 40 fc ff ff       	call   801083 <dev_lookup>
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	85 c0                	test   %eax,%eax
  801448:	78 1f                	js     801469 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80144a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801451:	74 1b                	je     80146e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801453:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801456:	8b 52 18             	mov    0x18(%edx),%edx
  801459:	85 d2                	test   %edx,%edx
  80145b:	74 32                	je     80148f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	ff 75 0c             	pushl  0xc(%ebp)
  801463:	50                   	push   %eax
  801464:	ff d2                	call   *%edx
  801466:	83 c4 10             	add    $0x10,%esp
}
  801469:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80146e:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801473:	8b 40 48             	mov    0x48(%eax),%eax
  801476:	83 ec 04             	sub    $0x4,%esp
  801479:	53                   	push   %ebx
  80147a:	50                   	push   %eax
  80147b:	68 ec 24 80 00       	push   $0x8024ec
  801480:	e8 25 ed ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148d:	eb da                	jmp    801469 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80148f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801494:	eb d3                	jmp    801469 <ftruncate+0x52>

00801496 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	53                   	push   %ebx
  80149a:	83 ec 14             	sub    $0x14,%esp
  80149d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a3:	50                   	push   %eax
  8014a4:	ff 75 08             	pushl  0x8(%ebp)
  8014a7:	e8 81 fb ff ff       	call   80102d <fd_lookup>
  8014ac:	83 c4 08             	add    $0x8,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 4b                	js     8014fe <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b3:	83 ec 08             	sub    $0x8,%esp
  8014b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b9:	50                   	push   %eax
  8014ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bd:	ff 30                	pushl  (%eax)
  8014bf:	e8 bf fb ff ff       	call   801083 <dev_lookup>
  8014c4:	83 c4 10             	add    $0x10,%esp
  8014c7:	85 c0                	test   %eax,%eax
  8014c9:	78 33                	js     8014fe <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ce:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014d2:	74 2f                	je     801503 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014d4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014d7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014de:	00 00 00 
	stat->st_isdir = 0;
  8014e1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014e8:	00 00 00 
	stat->st_dev = dev;
  8014eb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014f1:	83 ec 08             	sub    $0x8,%esp
  8014f4:	53                   	push   %ebx
  8014f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8014f8:	ff 50 14             	call   *0x14(%eax)
  8014fb:	83 c4 10             	add    $0x10,%esp
}
  8014fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801501:	c9                   	leave  
  801502:	c3                   	ret    
		return -E_NOT_SUPP;
  801503:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801508:	eb f4                	jmp    8014fe <fstat+0x68>

0080150a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	56                   	push   %esi
  80150e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	6a 00                	push   $0x0
  801514:	ff 75 08             	pushl  0x8(%ebp)
  801517:	e8 e7 01 00 00       	call   801703 <open>
  80151c:	89 c3                	mov    %eax,%ebx
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	85 c0                	test   %eax,%eax
  801523:	78 1b                	js     801540 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801525:	83 ec 08             	sub    $0x8,%esp
  801528:	ff 75 0c             	pushl  0xc(%ebp)
  80152b:	50                   	push   %eax
  80152c:	e8 65 ff ff ff       	call   801496 <fstat>
  801531:	89 c6                	mov    %eax,%esi
	close(fd);
  801533:	89 1c 24             	mov    %ebx,(%esp)
  801536:	e8 27 fc ff ff       	call   801162 <close>
	return r;
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	89 f3                	mov    %esi,%ebx
}
  801540:	89 d8                	mov    %ebx,%eax
  801542:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801545:	5b                   	pop    %ebx
  801546:	5e                   	pop    %esi
  801547:	5d                   	pop    %ebp
  801548:	c3                   	ret    

00801549 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	56                   	push   %esi
  80154d:	53                   	push   %ebx
  80154e:	89 c6                	mov    %eax,%esi
  801550:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801552:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801559:	74 27                	je     801582 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80155b:	6a 07                	push   $0x7
  80155d:	68 00 50 80 00       	push   $0x805000
  801562:	56                   	push   %esi
  801563:	ff 35 00 40 80 00    	pushl  0x804000
  801569:	e8 fc 07 00 00       	call   801d6a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80156e:	83 c4 0c             	add    $0xc,%esp
  801571:	6a 00                	push   $0x0
  801573:	53                   	push   %ebx
  801574:	6a 00                	push   $0x0
  801576:	e8 d8 07 00 00       	call   801d53 <ipc_recv>
}
  80157b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157e:	5b                   	pop    %ebx
  80157f:	5e                   	pop    %esi
  801580:	5d                   	pop    %ebp
  801581:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801582:	83 ec 0c             	sub    $0xc,%esp
  801585:	6a 01                	push   $0x1
  801587:	e8 f5 07 00 00       	call   801d81 <ipc_find_env>
  80158c:	a3 00 40 80 00       	mov    %eax,0x804000
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	eb c5                	jmp    80155b <fsipc+0x12>

00801596 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015aa:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015af:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b4:	b8 02 00 00 00       	mov    $0x2,%eax
  8015b9:	e8 8b ff ff ff       	call   801549 <fsipc>
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <devfile_flush>:
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015cc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d6:	b8 06 00 00 00       	mov    $0x6,%eax
  8015db:	e8 69 ff ff ff       	call   801549 <fsipc>
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <devfile_stat>:
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	53                   	push   %ebx
  8015e6:	83 ec 04             	sub    $0x4,%esp
  8015e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fc:	b8 05 00 00 00       	mov    $0x5,%eax
  801601:	e8 43 ff ff ff       	call   801549 <fsipc>
  801606:	85 c0                	test   %eax,%eax
  801608:	78 2c                	js     801636 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80160a:	83 ec 08             	sub    $0x8,%esp
  80160d:	68 00 50 80 00       	push   $0x805000
  801612:	53                   	push   %ebx
  801613:	e8 7c f1 ff ff       	call   800794 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801618:	a1 80 50 80 00       	mov    0x805080,%eax
  80161d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801623:	a1 84 50 80 00       	mov    0x805084,%eax
  801628:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801636:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <devfile_write>:
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	83 ec 0c             	sub    $0xc,%esp
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801649:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80164e:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801651:	8b 55 08             	mov    0x8(%ebp),%edx
  801654:	8b 52 0c             	mov    0xc(%edx),%edx
  801657:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  80165d:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  801662:	50                   	push   %eax
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	68 08 50 80 00       	push   $0x805008
  80166b:	e8 b2 f2 ff ff       	call   800922 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801670:	ba 00 00 00 00       	mov    $0x0,%edx
  801675:	b8 04 00 00 00       	mov    $0x4,%eax
  80167a:	e8 ca fe ff ff       	call   801549 <fsipc>
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <devfile_read>:
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	56                   	push   %esi
  801685:	53                   	push   %ebx
  801686:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	8b 40 0c             	mov    0xc(%eax),%eax
  80168f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801694:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80169a:	ba 00 00 00 00       	mov    $0x0,%edx
  80169f:	b8 03 00 00 00       	mov    $0x3,%eax
  8016a4:	e8 a0 fe ff ff       	call   801549 <fsipc>
  8016a9:	89 c3                	mov    %eax,%ebx
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	78 1f                	js     8016ce <devfile_read+0x4d>
	assert(r <= n);
  8016af:	39 f0                	cmp    %esi,%eax
  8016b1:	77 24                	ja     8016d7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016b3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016b8:	7f 33                	jg     8016ed <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016ba:	83 ec 04             	sub    $0x4,%esp
  8016bd:	50                   	push   %eax
  8016be:	68 00 50 80 00       	push   $0x805000
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	e8 57 f2 ff ff       	call   800922 <memmove>
	return r;
  8016cb:	83 c4 10             	add    $0x10,%esp
}
  8016ce:	89 d8                	mov    %ebx,%eax
  8016d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d3:	5b                   	pop    %ebx
  8016d4:	5e                   	pop    %esi
  8016d5:	5d                   	pop    %ebp
  8016d6:	c3                   	ret    
	assert(r <= n);
  8016d7:	68 58 25 80 00       	push   $0x802558
  8016dc:	68 5f 25 80 00       	push   $0x80255f
  8016e1:	6a 7c                	push   $0x7c
  8016e3:	68 74 25 80 00       	push   $0x802574
  8016e8:	e8 85 05 00 00       	call   801c72 <_panic>
	assert(r <= PGSIZE);
  8016ed:	68 7f 25 80 00       	push   $0x80257f
  8016f2:	68 5f 25 80 00       	push   $0x80255f
  8016f7:	6a 7d                	push   $0x7d
  8016f9:	68 74 25 80 00       	push   $0x802574
  8016fe:	e8 6f 05 00 00       	call   801c72 <_panic>

00801703 <open>:
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	56                   	push   %esi
  801707:	53                   	push   %ebx
  801708:	83 ec 1c             	sub    $0x1c,%esp
  80170b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80170e:	56                   	push   %esi
  80170f:	e8 49 f0 ff ff       	call   80075d <strlen>
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80171c:	7f 6c                	jg     80178a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80171e:	83 ec 0c             	sub    $0xc,%esp
  801721:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801724:	50                   	push   %eax
  801725:	e8 b4 f8 ff ff       	call   800fde <fd_alloc>
  80172a:	89 c3                	mov    %eax,%ebx
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	85 c0                	test   %eax,%eax
  801731:	78 3c                	js     80176f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801733:	83 ec 08             	sub    $0x8,%esp
  801736:	56                   	push   %esi
  801737:	68 00 50 80 00       	push   $0x805000
  80173c:	e8 53 f0 ff ff       	call   800794 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801749:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174c:	b8 01 00 00 00       	mov    $0x1,%eax
  801751:	e8 f3 fd ff ff       	call   801549 <fsipc>
  801756:	89 c3                	mov    %eax,%ebx
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	85 c0                	test   %eax,%eax
  80175d:	78 19                	js     801778 <open+0x75>
	return fd2num(fd);
  80175f:	83 ec 0c             	sub    $0xc,%esp
  801762:	ff 75 f4             	pushl  -0xc(%ebp)
  801765:	e8 4d f8 ff ff       	call   800fb7 <fd2num>
  80176a:	89 c3                	mov    %eax,%ebx
  80176c:	83 c4 10             	add    $0x10,%esp
}
  80176f:	89 d8                	mov    %ebx,%eax
  801771:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801774:	5b                   	pop    %ebx
  801775:	5e                   	pop    %esi
  801776:	5d                   	pop    %ebp
  801777:	c3                   	ret    
		fd_close(fd, 0);
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	6a 00                	push   $0x0
  80177d:	ff 75 f4             	pushl  -0xc(%ebp)
  801780:	e8 54 f9 ff ff       	call   8010d9 <fd_close>
		return r;
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	eb e5                	jmp    80176f <open+0x6c>
		return -E_BAD_PATH;
  80178a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80178f:	eb de                	jmp    80176f <open+0x6c>

00801791 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	b8 08 00 00 00       	mov    $0x8,%eax
  8017a1:	e8 a3 fd ff ff       	call   801549 <fsipc>
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	56                   	push   %esi
  8017ac:	53                   	push   %ebx
  8017ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017b0:	83 ec 0c             	sub    $0xc,%esp
  8017b3:	ff 75 08             	pushl  0x8(%ebp)
  8017b6:	e8 0c f8 ff ff       	call   800fc7 <fd2data>
  8017bb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8017bd:	83 c4 08             	add    $0x8,%esp
  8017c0:	68 8b 25 80 00       	push   $0x80258b
  8017c5:	53                   	push   %ebx
  8017c6:	e8 c9 ef ff ff       	call   800794 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017cb:	8b 46 04             	mov    0x4(%esi),%eax
  8017ce:	2b 06                	sub    (%esi),%eax
  8017d0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8017d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017dd:	00 00 00 
	stat->st_dev = &devpipe;
  8017e0:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017e7:	30 80 00 
	return 0;
}
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f2:	5b                   	pop    %ebx
  8017f3:	5e                   	pop    %esi
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    

008017f6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	53                   	push   %ebx
  8017fa:	83 ec 0c             	sub    $0xc,%esp
  8017fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801800:	53                   	push   %ebx
  801801:	6a 00                	push   $0x0
  801803:	e8 0a f4 ff ff       	call   800c12 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801808:	89 1c 24             	mov    %ebx,(%esp)
  80180b:	e8 b7 f7 ff ff       	call   800fc7 <fd2data>
  801810:	83 c4 08             	add    $0x8,%esp
  801813:	50                   	push   %eax
  801814:	6a 00                	push   $0x0
  801816:	e8 f7 f3 ff ff       	call   800c12 <sys_page_unmap>
}
  80181b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <_pipeisclosed>:
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	57                   	push   %edi
  801824:	56                   	push   %esi
  801825:	53                   	push   %ebx
  801826:	83 ec 1c             	sub    $0x1c,%esp
  801829:	89 c7                	mov    %eax,%edi
  80182b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80182d:	a1 04 40 80 00       	mov    0x804004,%eax
  801832:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801835:	83 ec 0c             	sub    $0xc,%esp
  801838:	57                   	push   %edi
  801839:	e8 7c 05 00 00       	call   801dba <pageref>
  80183e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801841:	89 34 24             	mov    %esi,(%esp)
  801844:	e8 71 05 00 00       	call   801dba <pageref>
		nn = thisenv->env_runs;
  801849:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80184f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	39 cb                	cmp    %ecx,%ebx
  801857:	74 1b                	je     801874 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801859:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80185c:	75 cf                	jne    80182d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80185e:	8b 42 58             	mov    0x58(%edx),%eax
  801861:	6a 01                	push   $0x1
  801863:	50                   	push   %eax
  801864:	53                   	push   %ebx
  801865:	68 92 25 80 00       	push   $0x802592
  80186a:	e8 3b e9 ff ff       	call   8001aa <cprintf>
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	eb b9                	jmp    80182d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801874:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801877:	0f 94 c0             	sete   %al
  80187a:	0f b6 c0             	movzbl %al,%eax
}
  80187d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801880:	5b                   	pop    %ebx
  801881:	5e                   	pop    %esi
  801882:	5f                   	pop    %edi
  801883:	5d                   	pop    %ebp
  801884:	c3                   	ret    

00801885 <devpipe_write>:
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	57                   	push   %edi
  801889:	56                   	push   %esi
  80188a:	53                   	push   %ebx
  80188b:	83 ec 28             	sub    $0x28,%esp
  80188e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801891:	56                   	push   %esi
  801892:	e8 30 f7 ff ff       	call   800fc7 <fd2data>
  801897:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018a4:	74 4f                	je     8018f5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018a6:	8b 43 04             	mov    0x4(%ebx),%eax
  8018a9:	8b 0b                	mov    (%ebx),%ecx
  8018ab:	8d 51 20             	lea    0x20(%ecx),%edx
  8018ae:	39 d0                	cmp    %edx,%eax
  8018b0:	72 14                	jb     8018c6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8018b2:	89 da                	mov    %ebx,%edx
  8018b4:	89 f0                	mov    %esi,%eax
  8018b6:	e8 65 ff ff ff       	call   801820 <_pipeisclosed>
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	75 3a                	jne    8018f9 <devpipe_write+0x74>
			sys_yield();
  8018bf:	e8 aa f2 ff ff       	call   800b6e <sys_yield>
  8018c4:	eb e0                	jmp    8018a6 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8018cd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8018d0:	89 c2                	mov    %eax,%edx
  8018d2:	c1 fa 1f             	sar    $0x1f,%edx
  8018d5:	89 d1                	mov    %edx,%ecx
  8018d7:	c1 e9 1b             	shr    $0x1b,%ecx
  8018da:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8018dd:	83 e2 1f             	and    $0x1f,%edx
  8018e0:	29 ca                	sub    %ecx,%edx
  8018e2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8018e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018ea:	83 c0 01             	add    $0x1,%eax
  8018ed:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018f0:	83 c7 01             	add    $0x1,%edi
  8018f3:	eb ac                	jmp    8018a1 <devpipe_write+0x1c>
	return i;
  8018f5:	89 f8                	mov    %edi,%eax
  8018f7:	eb 05                	jmp    8018fe <devpipe_write+0x79>
				return 0;
  8018f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801901:	5b                   	pop    %ebx
  801902:	5e                   	pop    %esi
  801903:	5f                   	pop    %edi
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    

00801906 <devpipe_read>:
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	57                   	push   %edi
  80190a:	56                   	push   %esi
  80190b:	53                   	push   %ebx
  80190c:	83 ec 18             	sub    $0x18,%esp
  80190f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801912:	57                   	push   %edi
  801913:	e8 af f6 ff ff       	call   800fc7 <fd2data>
  801918:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	be 00 00 00 00       	mov    $0x0,%esi
  801922:	3b 75 10             	cmp    0x10(%ebp),%esi
  801925:	74 47                	je     80196e <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801927:	8b 03                	mov    (%ebx),%eax
  801929:	3b 43 04             	cmp    0x4(%ebx),%eax
  80192c:	75 22                	jne    801950 <devpipe_read+0x4a>
			if (i > 0)
  80192e:	85 f6                	test   %esi,%esi
  801930:	75 14                	jne    801946 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801932:	89 da                	mov    %ebx,%edx
  801934:	89 f8                	mov    %edi,%eax
  801936:	e8 e5 fe ff ff       	call   801820 <_pipeisclosed>
  80193b:	85 c0                	test   %eax,%eax
  80193d:	75 33                	jne    801972 <devpipe_read+0x6c>
			sys_yield();
  80193f:	e8 2a f2 ff ff       	call   800b6e <sys_yield>
  801944:	eb e1                	jmp    801927 <devpipe_read+0x21>
				return i;
  801946:	89 f0                	mov    %esi,%eax
}
  801948:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80194b:	5b                   	pop    %ebx
  80194c:	5e                   	pop    %esi
  80194d:	5f                   	pop    %edi
  80194e:	5d                   	pop    %ebp
  80194f:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801950:	99                   	cltd   
  801951:	c1 ea 1b             	shr    $0x1b,%edx
  801954:	01 d0                	add    %edx,%eax
  801956:	83 e0 1f             	and    $0x1f,%eax
  801959:	29 d0                	sub    %edx,%eax
  80195b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801960:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801963:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801966:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801969:	83 c6 01             	add    $0x1,%esi
  80196c:	eb b4                	jmp    801922 <devpipe_read+0x1c>
	return i;
  80196e:	89 f0                	mov    %esi,%eax
  801970:	eb d6                	jmp    801948 <devpipe_read+0x42>
				return 0;
  801972:	b8 00 00 00 00       	mov    $0x0,%eax
  801977:	eb cf                	jmp    801948 <devpipe_read+0x42>

00801979 <pipe>:
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	56                   	push   %esi
  80197d:	53                   	push   %ebx
  80197e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801981:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801984:	50                   	push   %eax
  801985:	e8 54 f6 ff ff       	call   800fde <fd_alloc>
  80198a:	89 c3                	mov    %eax,%ebx
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	85 c0                	test   %eax,%eax
  801991:	78 5b                	js     8019ee <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801993:	83 ec 04             	sub    $0x4,%esp
  801996:	68 07 04 00 00       	push   $0x407
  80199b:	ff 75 f4             	pushl  -0xc(%ebp)
  80199e:	6a 00                	push   $0x0
  8019a0:	e8 e8 f1 ff ff       	call   800b8d <sys_page_alloc>
  8019a5:	89 c3                	mov    %eax,%ebx
  8019a7:	83 c4 10             	add    $0x10,%esp
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	78 40                	js     8019ee <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8019ae:	83 ec 0c             	sub    $0xc,%esp
  8019b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b4:	50                   	push   %eax
  8019b5:	e8 24 f6 ff ff       	call   800fde <fd_alloc>
  8019ba:	89 c3                	mov    %eax,%ebx
  8019bc:	83 c4 10             	add    $0x10,%esp
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	78 1b                	js     8019de <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	68 07 04 00 00       	push   $0x407
  8019cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8019ce:	6a 00                	push   $0x0
  8019d0:	e8 b8 f1 ff ff       	call   800b8d <sys_page_alloc>
  8019d5:	89 c3                	mov    %eax,%ebx
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	79 19                	jns    8019f7 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8019de:	83 ec 08             	sub    $0x8,%esp
  8019e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e4:	6a 00                	push   $0x0
  8019e6:	e8 27 f2 ff ff       	call   800c12 <sys_page_unmap>
  8019eb:	83 c4 10             	add    $0x10,%esp
}
  8019ee:	89 d8                	mov    %ebx,%eax
  8019f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5e                   	pop    %esi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    
	va = fd2data(fd0);
  8019f7:	83 ec 0c             	sub    $0xc,%esp
  8019fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8019fd:	e8 c5 f5 ff ff       	call   800fc7 <fd2data>
  801a02:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a04:	83 c4 0c             	add    $0xc,%esp
  801a07:	68 07 04 00 00       	push   $0x407
  801a0c:	50                   	push   %eax
  801a0d:	6a 00                	push   $0x0
  801a0f:	e8 79 f1 ff ff       	call   800b8d <sys_page_alloc>
  801a14:	89 c3                	mov    %eax,%ebx
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	0f 88 8c 00 00 00    	js     801aad <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a21:	83 ec 0c             	sub    $0xc,%esp
  801a24:	ff 75 f0             	pushl  -0x10(%ebp)
  801a27:	e8 9b f5 ff ff       	call   800fc7 <fd2data>
  801a2c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a33:	50                   	push   %eax
  801a34:	6a 00                	push   $0x0
  801a36:	56                   	push   %esi
  801a37:	6a 00                	push   $0x0
  801a39:	e8 92 f1 ff ff       	call   800bd0 <sys_page_map>
  801a3e:	89 c3                	mov    %eax,%ebx
  801a40:	83 c4 20             	add    $0x20,%esp
  801a43:	85 c0                	test   %eax,%eax
  801a45:	78 58                	js     801a9f <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4a:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a50:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a55:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a65:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a71:	83 ec 0c             	sub    $0xc,%esp
  801a74:	ff 75 f4             	pushl  -0xc(%ebp)
  801a77:	e8 3b f5 ff ff       	call   800fb7 <fd2num>
  801a7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a7f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a81:	83 c4 04             	add    $0x4,%esp
  801a84:	ff 75 f0             	pushl  -0x10(%ebp)
  801a87:	e8 2b f5 ff ff       	call   800fb7 <fd2num>
  801a8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a8f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a9a:	e9 4f ff ff ff       	jmp    8019ee <pipe+0x75>
	sys_page_unmap(0, va);
  801a9f:	83 ec 08             	sub    $0x8,%esp
  801aa2:	56                   	push   %esi
  801aa3:	6a 00                	push   $0x0
  801aa5:	e8 68 f1 ff ff       	call   800c12 <sys_page_unmap>
  801aaa:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801aad:	83 ec 08             	sub    $0x8,%esp
  801ab0:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab3:	6a 00                	push   $0x0
  801ab5:	e8 58 f1 ff ff       	call   800c12 <sys_page_unmap>
  801aba:	83 c4 10             	add    $0x10,%esp
  801abd:	e9 1c ff ff ff       	jmp    8019de <pipe+0x65>

00801ac2 <pipeisclosed>:
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ac8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801acb:	50                   	push   %eax
  801acc:	ff 75 08             	pushl  0x8(%ebp)
  801acf:	e8 59 f5 ff ff       	call   80102d <fd_lookup>
  801ad4:	83 c4 10             	add    $0x10,%esp
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	78 18                	js     801af3 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801adb:	83 ec 0c             	sub    $0xc,%esp
  801ade:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae1:	e8 e1 f4 ff ff       	call   800fc7 <fd2data>
	return _pipeisclosed(fd, p);
  801ae6:	89 c2                	mov    %eax,%edx
  801ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aeb:	e8 30 fd ff ff       	call   801820 <_pipeisclosed>
  801af0:	83 c4 10             	add    $0x10,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801af8:	b8 00 00 00 00       	mov    $0x0,%eax
  801afd:	5d                   	pop    %ebp
  801afe:	c3                   	ret    

00801aff <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801b05:	68 aa 25 80 00       	push   $0x8025aa
  801b0a:	ff 75 0c             	pushl  0xc(%ebp)
  801b0d:	e8 82 ec ff ff       	call   800794 <strcpy>
	return 0;
}
  801b12:	b8 00 00 00 00       	mov    $0x0,%eax
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <devcons_write>:
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	57                   	push   %edi
  801b1d:	56                   	push   %esi
  801b1e:	53                   	push   %ebx
  801b1f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b25:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b2a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b30:	eb 2f                	jmp    801b61 <devcons_write+0x48>
		m = n - tot;
  801b32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b35:	29 f3                	sub    %esi,%ebx
  801b37:	83 fb 7f             	cmp    $0x7f,%ebx
  801b3a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801b3f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801b42:	83 ec 04             	sub    $0x4,%esp
  801b45:	53                   	push   %ebx
  801b46:	89 f0                	mov    %esi,%eax
  801b48:	03 45 0c             	add    0xc(%ebp),%eax
  801b4b:	50                   	push   %eax
  801b4c:	57                   	push   %edi
  801b4d:	e8 d0 ed ff ff       	call   800922 <memmove>
		sys_cputs(buf, m);
  801b52:	83 c4 08             	add    $0x8,%esp
  801b55:	53                   	push   %ebx
  801b56:	57                   	push   %edi
  801b57:	e8 75 ef ff ff       	call   800ad1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b5c:	01 de                	add    %ebx,%esi
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b64:	72 cc                	jb     801b32 <devcons_write+0x19>
}
  801b66:	89 f0                	mov    %esi,%eax
  801b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5f                   	pop    %edi
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    

00801b70 <devcons_read>:
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 08             	sub    $0x8,%esp
  801b76:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801b7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b7f:	75 07                	jne    801b88 <devcons_read+0x18>
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    
		sys_yield();
  801b83:	e8 e6 ef ff ff       	call   800b6e <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801b88:	e8 62 ef ff ff       	call   800aef <sys_cgetc>
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	74 f2                	je     801b83 <devcons_read+0x13>
	if (c < 0)
  801b91:	85 c0                	test   %eax,%eax
  801b93:	78 ec                	js     801b81 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801b95:	83 f8 04             	cmp    $0x4,%eax
  801b98:	74 0c                	je     801ba6 <devcons_read+0x36>
	*(char*)vbuf = c;
  801b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9d:	88 02                	mov    %al,(%edx)
	return 1;
  801b9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba4:	eb db                	jmp    801b81 <devcons_read+0x11>
		return 0;
  801ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bab:	eb d4                	jmp    801b81 <devcons_read+0x11>

00801bad <cputchar>:
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801bb9:	6a 01                	push   $0x1
  801bbb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bbe:	50                   	push   %eax
  801bbf:	e8 0d ef ff ff       	call   800ad1 <sys_cputs>
}
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <getchar>:
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801bcf:	6a 01                	push   $0x1
  801bd1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bd4:	50                   	push   %eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	e8 c2 f6 ff ff       	call   80129e <read>
	if (r < 0)
  801bdc:	83 c4 10             	add    $0x10,%esp
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	78 08                	js     801beb <getchar+0x22>
	if (r < 1)
  801be3:	85 c0                	test   %eax,%eax
  801be5:	7e 06                	jle    801bed <getchar+0x24>
	return c;
  801be7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    
		return -E_EOF;
  801bed:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801bf2:	eb f7                	jmp    801beb <getchar+0x22>

00801bf4 <iscons>:
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bfa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfd:	50                   	push   %eax
  801bfe:	ff 75 08             	pushl  0x8(%ebp)
  801c01:	e8 27 f4 ff ff       	call   80102d <fd_lookup>
  801c06:	83 c4 10             	add    $0x10,%esp
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	78 11                	js     801c1e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c10:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c16:	39 10                	cmp    %edx,(%eax)
  801c18:	0f 94 c0             	sete   %al
  801c1b:	0f b6 c0             	movzbl %al,%eax
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <opencons>:
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c29:	50                   	push   %eax
  801c2a:	e8 af f3 ff ff       	call   800fde <fd_alloc>
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	85 c0                	test   %eax,%eax
  801c34:	78 3a                	js     801c70 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c36:	83 ec 04             	sub    $0x4,%esp
  801c39:	68 07 04 00 00       	push   $0x407
  801c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c41:	6a 00                	push   $0x0
  801c43:	e8 45 ef ff ff       	call   800b8d <sys_page_alloc>
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	78 21                	js     801c70 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c52:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c58:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c64:	83 ec 0c             	sub    $0xc,%esp
  801c67:	50                   	push   %eax
  801c68:	e8 4a f3 ff ff       	call   800fb7 <fd2num>
  801c6d:	83 c4 10             	add    $0x10,%esp
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	56                   	push   %esi
  801c76:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801c77:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c7a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801c80:	e8 ca ee ff ff       	call   800b4f <sys_getenvid>
  801c85:	83 ec 0c             	sub    $0xc,%esp
  801c88:	ff 75 0c             	pushl  0xc(%ebp)
  801c8b:	ff 75 08             	pushl  0x8(%ebp)
  801c8e:	56                   	push   %esi
  801c8f:	50                   	push   %eax
  801c90:	68 b8 25 80 00       	push   $0x8025b8
  801c95:	e8 10 e5 ff ff       	call   8001aa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c9a:	83 c4 18             	add    $0x18,%esp
  801c9d:	53                   	push   %ebx
  801c9e:	ff 75 10             	pushl  0x10(%ebp)
  801ca1:	e8 b3 e4 ff ff       	call   800159 <vcprintf>
	cprintf("\n");
  801ca6:	c7 04 24 d4 20 80 00 	movl   $0x8020d4,(%esp)
  801cad:	e8 f8 e4 ff ff       	call   8001aa <cprintf>
  801cb2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801cb5:	cc                   	int3   
  801cb6:	eb fd                	jmp    801cb5 <_panic+0x43>

00801cb8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	53                   	push   %ebx
  801cbc:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801cbf:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801cc6:	74 0d                	je     801cd5 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccb:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801cd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801cd5:	e8 75 ee ff ff       	call   800b4f <sys_getenvid>
  801cda:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801cdc:	83 ec 04             	sub    $0x4,%esp
  801cdf:	6a 07                	push   $0x7
  801ce1:	68 00 f0 bf ee       	push   $0xeebff000
  801ce6:	50                   	push   %eax
  801ce7:	e8 a1 ee ff ff       	call   800b8d <sys_page_alloc>
        	if (r < 0) {
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	78 27                	js     801d1a <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801cf3:	83 ec 08             	sub    $0x8,%esp
  801cf6:	68 2c 1d 80 00       	push   $0x801d2c
  801cfb:	53                   	push   %ebx
  801cfc:	e8 d7 ef ff ff       	call   800cd8 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801d01:	83 c4 10             	add    $0x10,%esp
  801d04:	85 c0                	test   %eax,%eax
  801d06:	79 c0                	jns    801cc8 <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801d08:	50                   	push   %eax
  801d09:	68 dc 25 80 00       	push   $0x8025dc
  801d0e:	6a 28                	push   $0x28
  801d10:	68 f0 25 80 00       	push   $0x8025f0
  801d15:	e8 58 ff ff ff       	call   801c72 <_panic>
            		panic("pgfault_handler: %e", r);
  801d1a:	50                   	push   %eax
  801d1b:	68 dc 25 80 00       	push   $0x8025dc
  801d20:	6a 24                	push   $0x24
  801d22:	68 f0 25 80 00       	push   $0x8025f0
  801d27:	e8 46 ff ff ff       	call   801c72 <_panic>

00801d2c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801d2c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801d2d:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801d32:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801d34:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  801d37:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801d3b:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801d3e:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801d42:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  801d46:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801d49:	83 c4 08             	add    $0x8,%esp
	popal
  801d4c:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801d4d:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801d50:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801d51:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801d52:	c3                   	ret    

00801d53 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801d59:	68 fe 25 80 00       	push   $0x8025fe
  801d5e:	6a 1a                	push   $0x1a
  801d60:	68 17 26 80 00       	push   $0x802617
  801d65:	e8 08 ff ff ff       	call   801c72 <_panic>

00801d6a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801d70:	68 21 26 80 00       	push   $0x802621
  801d75:	6a 2a                	push   $0x2a
  801d77:	68 17 26 80 00       	push   $0x802617
  801d7c:	e8 f1 fe ff ff       	call   801c72 <_panic>

00801d81 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d87:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d8c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801d8f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801d95:	8b 52 50             	mov    0x50(%edx),%edx
  801d98:	39 ca                	cmp    %ecx,%edx
  801d9a:	74 11                	je     801dad <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801d9c:	83 c0 01             	add    $0x1,%eax
  801d9f:	3d 00 04 00 00       	cmp    $0x400,%eax
  801da4:	75 e6                	jne    801d8c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801da6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dab:	eb 0b                	jmp    801db8 <ipc_find_env+0x37>
			return envs[i].env_id;
  801dad:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801db0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801db5:	8b 40 48             	mov    0x48(%eax),%eax
}
  801db8:	5d                   	pop    %ebp
  801db9:	c3                   	ret    

00801dba <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801dc0:	89 d0                	mov    %edx,%eax
  801dc2:	c1 e8 16             	shr    $0x16,%eax
  801dc5:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801dd1:	f6 c1 01             	test   $0x1,%cl
  801dd4:	74 1d                	je     801df3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801dd6:	c1 ea 0c             	shr    $0xc,%edx
  801dd9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801de0:	f6 c2 01             	test   $0x1,%dl
  801de3:	74 0e                	je     801df3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801de5:	c1 ea 0c             	shr    $0xc,%edx
  801de8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801def:	ef 
  801df0:	0f b7 c0             	movzwl %ax,%eax
}
  801df3:	5d                   	pop    %ebp
  801df4:	c3                   	ret    
  801df5:	66 90                	xchg   %ax,%ax
  801df7:	66 90                	xchg   %ax,%ax
  801df9:	66 90                	xchg   %ax,%ax
  801dfb:	66 90                	xchg   %ax,%ax
  801dfd:	66 90                	xchg   %ax,%ax
  801dff:	90                   	nop

00801e00 <__udivdi3>:
  801e00:	55                   	push   %ebp
  801e01:	57                   	push   %edi
  801e02:	56                   	push   %esi
  801e03:	53                   	push   %ebx
  801e04:	83 ec 1c             	sub    $0x1c,%esp
  801e07:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801e0b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801e0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e13:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801e17:	85 d2                	test   %edx,%edx
  801e19:	75 35                	jne    801e50 <__udivdi3+0x50>
  801e1b:	39 f3                	cmp    %esi,%ebx
  801e1d:	0f 87 bd 00 00 00    	ja     801ee0 <__udivdi3+0xe0>
  801e23:	85 db                	test   %ebx,%ebx
  801e25:	89 d9                	mov    %ebx,%ecx
  801e27:	75 0b                	jne    801e34 <__udivdi3+0x34>
  801e29:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2e:	31 d2                	xor    %edx,%edx
  801e30:	f7 f3                	div    %ebx
  801e32:	89 c1                	mov    %eax,%ecx
  801e34:	31 d2                	xor    %edx,%edx
  801e36:	89 f0                	mov    %esi,%eax
  801e38:	f7 f1                	div    %ecx
  801e3a:	89 c6                	mov    %eax,%esi
  801e3c:	89 e8                	mov    %ebp,%eax
  801e3e:	89 f7                	mov    %esi,%edi
  801e40:	f7 f1                	div    %ecx
  801e42:	89 fa                	mov    %edi,%edx
  801e44:	83 c4 1c             	add    $0x1c,%esp
  801e47:	5b                   	pop    %ebx
  801e48:	5e                   	pop    %esi
  801e49:	5f                   	pop    %edi
  801e4a:	5d                   	pop    %ebp
  801e4b:	c3                   	ret    
  801e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e50:	39 f2                	cmp    %esi,%edx
  801e52:	77 7c                	ja     801ed0 <__udivdi3+0xd0>
  801e54:	0f bd fa             	bsr    %edx,%edi
  801e57:	83 f7 1f             	xor    $0x1f,%edi
  801e5a:	0f 84 98 00 00 00    	je     801ef8 <__udivdi3+0xf8>
  801e60:	89 f9                	mov    %edi,%ecx
  801e62:	b8 20 00 00 00       	mov    $0x20,%eax
  801e67:	29 f8                	sub    %edi,%eax
  801e69:	d3 e2                	shl    %cl,%edx
  801e6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e6f:	89 c1                	mov    %eax,%ecx
  801e71:	89 da                	mov    %ebx,%edx
  801e73:	d3 ea                	shr    %cl,%edx
  801e75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e79:	09 d1                	or     %edx,%ecx
  801e7b:	89 f2                	mov    %esi,%edx
  801e7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e81:	89 f9                	mov    %edi,%ecx
  801e83:	d3 e3                	shl    %cl,%ebx
  801e85:	89 c1                	mov    %eax,%ecx
  801e87:	d3 ea                	shr    %cl,%edx
  801e89:	89 f9                	mov    %edi,%ecx
  801e8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e8f:	d3 e6                	shl    %cl,%esi
  801e91:	89 eb                	mov    %ebp,%ebx
  801e93:	89 c1                	mov    %eax,%ecx
  801e95:	d3 eb                	shr    %cl,%ebx
  801e97:	09 de                	or     %ebx,%esi
  801e99:	89 f0                	mov    %esi,%eax
  801e9b:	f7 74 24 08          	divl   0x8(%esp)
  801e9f:	89 d6                	mov    %edx,%esi
  801ea1:	89 c3                	mov    %eax,%ebx
  801ea3:	f7 64 24 0c          	mull   0xc(%esp)
  801ea7:	39 d6                	cmp    %edx,%esi
  801ea9:	72 0c                	jb     801eb7 <__udivdi3+0xb7>
  801eab:	89 f9                	mov    %edi,%ecx
  801ead:	d3 e5                	shl    %cl,%ebp
  801eaf:	39 c5                	cmp    %eax,%ebp
  801eb1:	73 5d                	jae    801f10 <__udivdi3+0x110>
  801eb3:	39 d6                	cmp    %edx,%esi
  801eb5:	75 59                	jne    801f10 <__udivdi3+0x110>
  801eb7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801eba:	31 ff                	xor    %edi,%edi
  801ebc:	89 fa                	mov    %edi,%edx
  801ebe:	83 c4 1c             	add    $0x1c,%esp
  801ec1:	5b                   	pop    %ebx
  801ec2:	5e                   	pop    %esi
  801ec3:	5f                   	pop    %edi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    
  801ec6:	8d 76 00             	lea    0x0(%esi),%esi
  801ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801ed0:	31 ff                	xor    %edi,%edi
  801ed2:	31 c0                	xor    %eax,%eax
  801ed4:	89 fa                	mov    %edi,%edx
  801ed6:	83 c4 1c             	add    $0x1c,%esp
  801ed9:	5b                   	pop    %ebx
  801eda:	5e                   	pop    %esi
  801edb:	5f                   	pop    %edi
  801edc:	5d                   	pop    %ebp
  801edd:	c3                   	ret    
  801ede:	66 90                	xchg   %ax,%ax
  801ee0:	31 ff                	xor    %edi,%edi
  801ee2:	89 e8                	mov    %ebp,%eax
  801ee4:	89 f2                	mov    %esi,%edx
  801ee6:	f7 f3                	div    %ebx
  801ee8:	89 fa                	mov    %edi,%edx
  801eea:	83 c4 1c             	add    $0x1c,%esp
  801eed:	5b                   	pop    %ebx
  801eee:	5e                   	pop    %esi
  801eef:	5f                   	pop    %edi
  801ef0:	5d                   	pop    %ebp
  801ef1:	c3                   	ret    
  801ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801ef8:	39 f2                	cmp    %esi,%edx
  801efa:	72 06                	jb     801f02 <__udivdi3+0x102>
  801efc:	31 c0                	xor    %eax,%eax
  801efe:	39 eb                	cmp    %ebp,%ebx
  801f00:	77 d2                	ja     801ed4 <__udivdi3+0xd4>
  801f02:	b8 01 00 00 00       	mov    $0x1,%eax
  801f07:	eb cb                	jmp    801ed4 <__udivdi3+0xd4>
  801f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f10:	89 d8                	mov    %ebx,%eax
  801f12:	31 ff                	xor    %edi,%edi
  801f14:	eb be                	jmp    801ed4 <__udivdi3+0xd4>
  801f16:	66 90                	xchg   %ax,%ax
  801f18:	66 90                	xchg   %ax,%ax
  801f1a:	66 90                	xchg   %ax,%ax
  801f1c:	66 90                	xchg   %ax,%ax
  801f1e:	66 90                	xchg   %ax,%ax

00801f20 <__umoddi3>:
  801f20:	55                   	push   %ebp
  801f21:	57                   	push   %edi
  801f22:	56                   	push   %esi
  801f23:	53                   	push   %ebx
  801f24:	83 ec 1c             	sub    $0x1c,%esp
  801f27:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801f2b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801f2f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801f33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f37:	85 ed                	test   %ebp,%ebp
  801f39:	89 f0                	mov    %esi,%eax
  801f3b:	89 da                	mov    %ebx,%edx
  801f3d:	75 19                	jne    801f58 <__umoddi3+0x38>
  801f3f:	39 df                	cmp    %ebx,%edi
  801f41:	0f 86 b1 00 00 00    	jbe    801ff8 <__umoddi3+0xd8>
  801f47:	f7 f7                	div    %edi
  801f49:	89 d0                	mov    %edx,%eax
  801f4b:	31 d2                	xor    %edx,%edx
  801f4d:	83 c4 1c             	add    $0x1c,%esp
  801f50:	5b                   	pop    %ebx
  801f51:	5e                   	pop    %esi
  801f52:	5f                   	pop    %edi
  801f53:	5d                   	pop    %ebp
  801f54:	c3                   	ret    
  801f55:	8d 76 00             	lea    0x0(%esi),%esi
  801f58:	39 dd                	cmp    %ebx,%ebp
  801f5a:	77 f1                	ja     801f4d <__umoddi3+0x2d>
  801f5c:	0f bd cd             	bsr    %ebp,%ecx
  801f5f:	83 f1 1f             	xor    $0x1f,%ecx
  801f62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f66:	0f 84 b4 00 00 00    	je     802020 <__umoddi3+0x100>
  801f6c:	b8 20 00 00 00       	mov    $0x20,%eax
  801f71:	89 c2                	mov    %eax,%edx
  801f73:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f77:	29 c2                	sub    %eax,%edx
  801f79:	89 c1                	mov    %eax,%ecx
  801f7b:	89 f8                	mov    %edi,%eax
  801f7d:	d3 e5                	shl    %cl,%ebp
  801f7f:	89 d1                	mov    %edx,%ecx
  801f81:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f85:	d3 e8                	shr    %cl,%eax
  801f87:	09 c5                	or     %eax,%ebp
  801f89:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f8d:	89 c1                	mov    %eax,%ecx
  801f8f:	d3 e7                	shl    %cl,%edi
  801f91:	89 d1                	mov    %edx,%ecx
  801f93:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f97:	89 df                	mov    %ebx,%edi
  801f99:	d3 ef                	shr    %cl,%edi
  801f9b:	89 c1                	mov    %eax,%ecx
  801f9d:	89 f0                	mov    %esi,%eax
  801f9f:	d3 e3                	shl    %cl,%ebx
  801fa1:	89 d1                	mov    %edx,%ecx
  801fa3:	89 fa                	mov    %edi,%edx
  801fa5:	d3 e8                	shr    %cl,%eax
  801fa7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801fac:	09 d8                	or     %ebx,%eax
  801fae:	f7 f5                	div    %ebp
  801fb0:	d3 e6                	shl    %cl,%esi
  801fb2:	89 d1                	mov    %edx,%ecx
  801fb4:	f7 64 24 08          	mull   0x8(%esp)
  801fb8:	39 d1                	cmp    %edx,%ecx
  801fba:	89 c3                	mov    %eax,%ebx
  801fbc:	89 d7                	mov    %edx,%edi
  801fbe:	72 06                	jb     801fc6 <__umoddi3+0xa6>
  801fc0:	75 0e                	jne    801fd0 <__umoddi3+0xb0>
  801fc2:	39 c6                	cmp    %eax,%esi
  801fc4:	73 0a                	jae    801fd0 <__umoddi3+0xb0>
  801fc6:	2b 44 24 08          	sub    0x8(%esp),%eax
  801fca:	19 ea                	sbb    %ebp,%edx
  801fcc:	89 d7                	mov    %edx,%edi
  801fce:	89 c3                	mov    %eax,%ebx
  801fd0:	89 ca                	mov    %ecx,%edx
  801fd2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801fd7:	29 de                	sub    %ebx,%esi
  801fd9:	19 fa                	sbb    %edi,%edx
  801fdb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801fdf:	89 d0                	mov    %edx,%eax
  801fe1:	d3 e0                	shl    %cl,%eax
  801fe3:	89 d9                	mov    %ebx,%ecx
  801fe5:	d3 ee                	shr    %cl,%esi
  801fe7:	d3 ea                	shr    %cl,%edx
  801fe9:	09 f0                	or     %esi,%eax
  801feb:	83 c4 1c             	add    $0x1c,%esp
  801fee:	5b                   	pop    %ebx
  801fef:	5e                   	pop    %esi
  801ff0:	5f                   	pop    %edi
  801ff1:	5d                   	pop    %ebp
  801ff2:	c3                   	ret    
  801ff3:	90                   	nop
  801ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ff8:	85 ff                	test   %edi,%edi
  801ffa:	89 f9                	mov    %edi,%ecx
  801ffc:	75 0b                	jne    802009 <__umoddi3+0xe9>
  801ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  802003:	31 d2                	xor    %edx,%edx
  802005:	f7 f7                	div    %edi
  802007:	89 c1                	mov    %eax,%ecx
  802009:	89 d8                	mov    %ebx,%eax
  80200b:	31 d2                	xor    %edx,%edx
  80200d:	f7 f1                	div    %ecx
  80200f:	89 f0                	mov    %esi,%eax
  802011:	f7 f1                	div    %ecx
  802013:	e9 31 ff ff ff       	jmp    801f49 <__umoddi3+0x29>
  802018:	90                   	nop
  802019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802020:	39 dd                	cmp    %ebx,%ebp
  802022:	72 08                	jb     80202c <__umoddi3+0x10c>
  802024:	39 f7                	cmp    %esi,%edi
  802026:	0f 87 21 ff ff ff    	ja     801f4d <__umoddi3+0x2d>
  80202c:	89 da                	mov    %ebx,%edx
  80202e:	89 f0                	mov    %esi,%eax
  802030:	29 f8                	sub    %edi,%eax
  802032:	19 ea                	sbb    %ebp,%edx
  802034:	e9 14 ff ff ff       	jmp    801f4d <__umoddi3+0x2d>
