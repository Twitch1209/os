
obj/user/hello.debug：     文件格式 elf32-i386


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
  80002c:	e8 2d 00 00 00       	call   80005e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  800039:	68 20 1d 80 00       	push   $0x801d20
  80003e:	e8 10 01 00 00       	call   800153 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800043:	a1 04 40 80 00       	mov    0x804004,%eax
  800048:	8b 40 48             	mov    0x48(%eax),%eax
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	50                   	push   %eax
  80004f:	68 2e 1d 80 00       	push   $0x801d2e
  800054:	e8 fa 00 00 00       	call   800153 <cprintf>
}
  800059:	83 c4 10             	add    $0x10,%esp
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800066:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800069:	e8 8a 0a 00 00       	call   800af8 <sys_getenvid>
  80006e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800073:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800076:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007b:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800080:	85 db                	test   %ebx,%ebx
  800082:	7e 07                	jle    80008b <libmain+0x2d>
		binaryname = argv[0];
  800084:	8b 06                	mov    (%esi),%eax
  800086:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008b:	83 ec 08             	sub    $0x8,%esp
  80008e:	56                   	push   %esi
  80008f:	53                   	push   %ebx
  800090:	e8 9e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800095:	e8 0a 00 00 00       	call   8000a4 <exit>
}
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a0:	5b                   	pop    %ebx
  8000a1:	5e                   	pop    %esi
  8000a2:	5d                   	pop    %ebp
  8000a3:	c3                   	ret    

008000a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000aa:	e8 4e 0e 00 00       	call   800efd <close_all>
	sys_env_destroy(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 fe 09 00 00       	call   800ab7 <sys_env_destroy>
}
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	c9                   	leave  
  8000bd:	c3                   	ret    

008000be <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	53                   	push   %ebx
  8000c2:	83 ec 04             	sub    $0x4,%esp
  8000c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c8:	8b 13                	mov    (%ebx),%edx
  8000ca:	8d 42 01             	lea    0x1(%edx),%eax
  8000cd:	89 03                	mov    %eax,(%ebx)
  8000cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000db:	74 09                	je     8000e6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000dd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e4:	c9                   	leave  
  8000e5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e6:	83 ec 08             	sub    $0x8,%esp
  8000e9:	68 ff 00 00 00       	push   $0xff
  8000ee:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f1:	50                   	push   %eax
  8000f2:	e8 83 09 00 00       	call   800a7a <sys_cputs>
		b->idx = 0;
  8000f7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	eb db                	jmp    8000dd <putch+0x1f>

00800102 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80010b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800112:	00 00 00 
	b.cnt = 0;
  800115:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011f:	ff 75 0c             	pushl  0xc(%ebp)
  800122:	ff 75 08             	pushl  0x8(%ebp)
  800125:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80012b:	50                   	push   %eax
  80012c:	68 be 00 80 00       	push   $0x8000be
  800131:	e8 1a 01 00 00       	call   800250 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800136:	83 c4 08             	add    $0x8,%esp
  800139:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80013f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800145:	50                   	push   %eax
  800146:	e8 2f 09 00 00       	call   800a7a <sys_cputs>

	return b.cnt;
}
  80014b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800151:	c9                   	leave  
  800152:	c3                   	ret    

00800153 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800159:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80015c:	50                   	push   %eax
  80015d:	ff 75 08             	pushl  0x8(%ebp)
  800160:	e8 9d ff ff ff       	call   800102 <vcprintf>
	va_end(ap);

	return cnt;
}
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	57                   	push   %edi
  80016b:	56                   	push   %esi
  80016c:	53                   	push   %ebx
  80016d:	83 ec 1c             	sub    $0x1c,%esp
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 d6                	mov    %edx,%esi
  800174:	8b 45 08             	mov    0x8(%ebp),%eax
  800177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80017d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800180:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800183:	bb 00 00 00 00       	mov    $0x0,%ebx
  800188:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80018b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80018e:	39 d3                	cmp    %edx,%ebx
  800190:	72 05                	jb     800197 <printnum+0x30>
  800192:	39 45 10             	cmp    %eax,0x10(%ebp)
  800195:	77 7a                	ja     800211 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	ff 75 18             	pushl  0x18(%ebp)
  80019d:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001a3:	53                   	push   %ebx
  8001a4:	ff 75 10             	pushl  0x10(%ebp)
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b0:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8001b6:	e8 15 19 00 00       	call   801ad0 <__udivdi3>
  8001bb:	83 c4 18             	add    $0x18,%esp
  8001be:	52                   	push   %edx
  8001bf:	50                   	push   %eax
  8001c0:	89 f2                	mov    %esi,%edx
  8001c2:	89 f8                	mov    %edi,%eax
  8001c4:	e8 9e ff ff ff       	call   800167 <printnum>
  8001c9:	83 c4 20             	add    $0x20,%esp
  8001cc:	eb 13                	jmp    8001e1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	56                   	push   %esi
  8001d2:	ff 75 18             	pushl  0x18(%ebp)
  8001d5:	ff d7                	call   *%edi
  8001d7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001da:	83 eb 01             	sub    $0x1,%ebx
  8001dd:	85 db                	test   %ebx,%ebx
  8001df:	7f ed                	jg     8001ce <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	56                   	push   %esi
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ee:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f4:	e8 f7 19 00 00       	call   801bf0 <__umoddi3>
  8001f9:	83 c4 14             	add    $0x14,%esp
  8001fc:	0f be 80 4f 1d 80 00 	movsbl 0x801d4f(%eax),%eax
  800203:	50                   	push   %eax
  800204:	ff d7                	call   *%edi
}
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020c:	5b                   	pop    %ebx
  80020d:	5e                   	pop    %esi
  80020e:	5f                   	pop    %edi
  80020f:	5d                   	pop    %ebp
  800210:	c3                   	ret    
  800211:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800214:	eb c4                	jmp    8001da <printnum+0x73>

00800216 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80021c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800220:	8b 10                	mov    (%eax),%edx
  800222:	3b 50 04             	cmp    0x4(%eax),%edx
  800225:	73 0a                	jae    800231 <sprintputch+0x1b>
		*b->buf++ = ch;
  800227:	8d 4a 01             	lea    0x1(%edx),%ecx
  80022a:	89 08                	mov    %ecx,(%eax)
  80022c:	8b 45 08             	mov    0x8(%ebp),%eax
  80022f:	88 02                	mov    %al,(%edx)
}
  800231:	5d                   	pop    %ebp
  800232:	c3                   	ret    

00800233 <printfmt>:
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800239:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80023c:	50                   	push   %eax
  80023d:	ff 75 10             	pushl  0x10(%ebp)
  800240:	ff 75 0c             	pushl  0xc(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 05 00 00 00       	call   800250 <vprintfmt>
}
  80024b:	83 c4 10             	add    $0x10,%esp
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <vprintfmt>:
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	57                   	push   %edi
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 2c             	sub    $0x2c,%esp
  800259:	8b 75 08             	mov    0x8(%ebp),%esi
  80025c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80025f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800262:	e9 8c 03 00 00       	jmp    8005f3 <vprintfmt+0x3a3>
		padc = ' ';
  800267:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80026b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800272:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800279:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800280:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800285:	8d 47 01             	lea    0x1(%edi),%eax
  800288:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028b:	0f b6 17             	movzbl (%edi),%edx
  80028e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800291:	3c 55                	cmp    $0x55,%al
  800293:	0f 87 dd 03 00 00    	ja     800676 <vprintfmt+0x426>
  800299:	0f b6 c0             	movzbl %al,%eax
  80029c:	ff 24 85 a0 1e 80 00 	jmp    *0x801ea0(,%eax,4)
  8002a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002a6:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002aa:	eb d9                	jmp    800285 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002af:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002b3:	eb d0                	jmp    800285 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002b5:	0f b6 d2             	movzbl %dl,%edx
  8002b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002c3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002ca:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002cd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002d0:	83 f9 09             	cmp    $0x9,%ecx
  8002d3:	77 55                	ja     80032a <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002d5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002d8:	eb e9                	jmp    8002c3 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002da:	8b 45 14             	mov    0x14(%ebp),%eax
  8002dd:	8b 00                	mov    (%eax),%eax
  8002df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e5:	8d 40 04             	lea    0x4(%eax),%eax
  8002e8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002f2:	79 91                	jns    800285 <vprintfmt+0x35>
				width = precision, precision = -1;
  8002f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002fa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800301:	eb 82                	jmp    800285 <vprintfmt+0x35>
  800303:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	ba 00 00 00 00       	mov    $0x0,%edx
  80030d:	0f 49 d0             	cmovns %eax,%edx
  800310:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800313:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800316:	e9 6a ff ff ff       	jmp    800285 <vprintfmt+0x35>
  80031b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80031e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800325:	e9 5b ff ff ff       	jmp    800285 <vprintfmt+0x35>
  80032a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80032d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800330:	eb bc                	jmp    8002ee <vprintfmt+0x9e>
			lflag++;
  800332:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800338:	e9 48 ff ff ff       	jmp    800285 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80033d:	8b 45 14             	mov    0x14(%ebp),%eax
  800340:	8d 78 04             	lea    0x4(%eax),%edi
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	53                   	push   %ebx
  800347:	ff 30                	pushl  (%eax)
  800349:	ff d6                	call   *%esi
			break;
  80034b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80034e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800351:	e9 9a 02 00 00       	jmp    8005f0 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800356:	8b 45 14             	mov    0x14(%ebp),%eax
  800359:	8d 78 04             	lea    0x4(%eax),%edi
  80035c:	8b 00                	mov    (%eax),%eax
  80035e:	99                   	cltd   
  80035f:	31 d0                	xor    %edx,%eax
  800361:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800363:	83 f8 0f             	cmp    $0xf,%eax
  800366:	7f 23                	jg     80038b <vprintfmt+0x13b>
  800368:	8b 14 85 00 20 80 00 	mov    0x802000(,%eax,4),%edx
  80036f:	85 d2                	test   %edx,%edx
  800371:	74 18                	je     80038b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800373:	52                   	push   %edx
  800374:	68 31 21 80 00       	push   $0x802131
  800379:	53                   	push   %ebx
  80037a:	56                   	push   %esi
  80037b:	e8 b3 fe ff ff       	call   800233 <printfmt>
  800380:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800383:	89 7d 14             	mov    %edi,0x14(%ebp)
  800386:	e9 65 02 00 00       	jmp    8005f0 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  80038b:	50                   	push   %eax
  80038c:	68 67 1d 80 00       	push   $0x801d67
  800391:	53                   	push   %ebx
  800392:	56                   	push   %esi
  800393:	e8 9b fe ff ff       	call   800233 <printfmt>
  800398:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80039b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80039e:	e9 4d 02 00 00       	jmp    8005f0 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  8003a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a6:	83 c0 04             	add    $0x4,%eax
  8003a9:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8003af:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003b1:	85 ff                	test   %edi,%edi
  8003b3:	b8 60 1d 80 00       	mov    $0x801d60,%eax
  8003b8:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003bf:	0f 8e bd 00 00 00    	jle    800482 <vprintfmt+0x232>
  8003c5:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003c9:	75 0e                	jne    8003d9 <vprintfmt+0x189>
  8003cb:	89 75 08             	mov    %esi,0x8(%ebp)
  8003ce:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003d1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003d4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003d7:	eb 6d                	jmp    800446 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003d9:	83 ec 08             	sub    $0x8,%esp
  8003dc:	ff 75 d0             	pushl  -0x30(%ebp)
  8003df:	57                   	push   %edi
  8003e0:	e8 39 03 00 00       	call   80071e <strnlen>
  8003e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003e8:	29 c1                	sub    %eax,%ecx
  8003ea:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003ed:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003f0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003fa:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fc:	eb 0f                	jmp    80040d <vprintfmt+0x1bd>
					putch(padc, putdat);
  8003fe:	83 ec 08             	sub    $0x8,%esp
  800401:	53                   	push   %ebx
  800402:	ff 75 e0             	pushl  -0x20(%ebp)
  800405:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800407:	83 ef 01             	sub    $0x1,%edi
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	85 ff                	test   %edi,%edi
  80040f:	7f ed                	jg     8003fe <vprintfmt+0x1ae>
  800411:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800414:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800417:	85 c9                	test   %ecx,%ecx
  800419:	b8 00 00 00 00       	mov    $0x0,%eax
  80041e:	0f 49 c1             	cmovns %ecx,%eax
  800421:	29 c1                	sub    %eax,%ecx
  800423:	89 75 08             	mov    %esi,0x8(%ebp)
  800426:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800429:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80042c:	89 cb                	mov    %ecx,%ebx
  80042e:	eb 16                	jmp    800446 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800430:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800434:	75 31                	jne    800467 <vprintfmt+0x217>
					putch(ch, putdat);
  800436:	83 ec 08             	sub    $0x8,%esp
  800439:	ff 75 0c             	pushl  0xc(%ebp)
  80043c:	50                   	push   %eax
  80043d:	ff 55 08             	call   *0x8(%ebp)
  800440:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800443:	83 eb 01             	sub    $0x1,%ebx
  800446:	83 c7 01             	add    $0x1,%edi
  800449:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80044d:	0f be c2             	movsbl %dl,%eax
  800450:	85 c0                	test   %eax,%eax
  800452:	74 59                	je     8004ad <vprintfmt+0x25d>
  800454:	85 f6                	test   %esi,%esi
  800456:	78 d8                	js     800430 <vprintfmt+0x1e0>
  800458:	83 ee 01             	sub    $0x1,%esi
  80045b:	79 d3                	jns    800430 <vprintfmt+0x1e0>
  80045d:	89 df                	mov    %ebx,%edi
  80045f:	8b 75 08             	mov    0x8(%ebp),%esi
  800462:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800465:	eb 37                	jmp    80049e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800467:	0f be d2             	movsbl %dl,%edx
  80046a:	83 ea 20             	sub    $0x20,%edx
  80046d:	83 fa 5e             	cmp    $0x5e,%edx
  800470:	76 c4                	jbe    800436 <vprintfmt+0x1e6>
					putch('?', putdat);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	6a 3f                	push   $0x3f
  80047a:	ff 55 08             	call   *0x8(%ebp)
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	eb c1                	jmp    800443 <vprintfmt+0x1f3>
  800482:	89 75 08             	mov    %esi,0x8(%ebp)
  800485:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800488:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80048e:	eb b6                	jmp    800446 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	53                   	push   %ebx
  800494:	6a 20                	push   $0x20
  800496:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800498:	83 ef 01             	sub    $0x1,%edi
  80049b:	83 c4 10             	add    $0x10,%esp
  80049e:	85 ff                	test   %edi,%edi
  8004a0:	7f ee                	jg     800490 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a8:	e9 43 01 00 00       	jmp    8005f0 <vprintfmt+0x3a0>
  8004ad:	89 df                	mov    %ebx,%edi
  8004af:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004b5:	eb e7                	jmp    80049e <vprintfmt+0x24e>
	if (lflag >= 2)
  8004b7:	83 f9 01             	cmp    $0x1,%ecx
  8004ba:	7e 3f                	jle    8004fb <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bf:	8b 50 04             	mov    0x4(%eax),%edx
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cd:	8d 40 08             	lea    0x8(%eax),%eax
  8004d0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004d7:	79 5c                	jns    800535 <vprintfmt+0x2e5>
				putch('-', putdat);
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	53                   	push   %ebx
  8004dd:	6a 2d                	push   $0x2d
  8004df:	ff d6                	call   *%esi
				num = -(long long) num;
  8004e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004e7:	f7 da                	neg    %edx
  8004e9:	83 d1 00             	adc    $0x0,%ecx
  8004ec:	f7 d9                	neg    %ecx
  8004ee:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004f6:	e9 db 00 00 00       	jmp    8005d6 <vprintfmt+0x386>
	else if (lflag)
  8004fb:	85 c9                	test   %ecx,%ecx
  8004fd:	75 1b                	jne    80051a <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800507:	89 c1                	mov    %eax,%ecx
  800509:	c1 f9 1f             	sar    $0x1f,%ecx
  80050c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	8d 40 04             	lea    0x4(%eax),%eax
  800515:	89 45 14             	mov    %eax,0x14(%ebp)
  800518:	eb b9                	jmp    8004d3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80051a:	8b 45 14             	mov    0x14(%ebp),%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800522:	89 c1                	mov    %eax,%ecx
  800524:	c1 f9 1f             	sar    $0x1f,%ecx
  800527:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8d 40 04             	lea    0x4(%eax),%eax
  800530:	89 45 14             	mov    %eax,0x14(%ebp)
  800533:	eb 9e                	jmp    8004d3 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800535:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800538:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80053b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800540:	e9 91 00 00 00       	jmp    8005d6 <vprintfmt+0x386>
	if (lflag >= 2)
  800545:	83 f9 01             	cmp    $0x1,%ecx
  800548:	7e 15                	jle    80055f <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8b 10                	mov    (%eax),%edx
  80054f:	8b 48 04             	mov    0x4(%eax),%ecx
  800552:	8d 40 08             	lea    0x8(%eax),%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800558:	b8 0a 00 00 00       	mov    $0xa,%eax
  80055d:	eb 77                	jmp    8005d6 <vprintfmt+0x386>
	else if (lflag)
  80055f:	85 c9                	test   %ecx,%ecx
  800561:	75 17                	jne    80057a <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800563:	8b 45 14             	mov    0x14(%ebp),%eax
  800566:	8b 10                	mov    (%eax),%edx
  800568:	b9 00 00 00 00       	mov    $0x0,%ecx
  80056d:	8d 40 04             	lea    0x4(%eax),%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800573:	b8 0a 00 00 00       	mov    $0xa,%eax
  800578:	eb 5c                	jmp    8005d6 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	8b 10                	mov    (%eax),%edx
  80057f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800584:	8d 40 04             	lea    0x4(%eax),%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058f:	eb 45                	jmp    8005d6 <vprintfmt+0x386>
			putch('X', putdat);
  800591:	83 ec 08             	sub    $0x8,%esp
  800594:	53                   	push   %ebx
  800595:	6a 58                	push   $0x58
  800597:	ff d6                	call   *%esi
			putch('X', putdat);
  800599:	83 c4 08             	add    $0x8,%esp
  80059c:	53                   	push   %ebx
  80059d:	6a 58                	push   $0x58
  80059f:	ff d6                	call   *%esi
			putch('X', putdat);
  8005a1:	83 c4 08             	add    $0x8,%esp
  8005a4:	53                   	push   %ebx
  8005a5:	6a 58                	push   $0x58
  8005a7:	ff d6                	call   *%esi
			break;
  8005a9:	83 c4 10             	add    $0x10,%esp
  8005ac:	eb 42                	jmp    8005f0 <vprintfmt+0x3a0>
			putch('0', putdat);
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	53                   	push   %ebx
  8005b2:	6a 30                	push   $0x30
  8005b4:	ff d6                	call   *%esi
			putch('x', putdat);
  8005b6:	83 c4 08             	add    $0x8,%esp
  8005b9:	53                   	push   %ebx
  8005ba:	6a 78                	push   $0x78
  8005bc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 10                	mov    (%eax),%edx
  8005c3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005c8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005cb:	8d 40 04             	lea    0x4(%eax),%eax
  8005ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005d1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005d6:	83 ec 0c             	sub    $0xc,%esp
  8005d9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005dd:	57                   	push   %edi
  8005de:	ff 75 e0             	pushl  -0x20(%ebp)
  8005e1:	50                   	push   %eax
  8005e2:	51                   	push   %ecx
  8005e3:	52                   	push   %edx
  8005e4:	89 da                	mov    %ebx,%edx
  8005e6:	89 f0                	mov    %esi,%eax
  8005e8:	e8 7a fb ff ff       	call   800167 <printnum>
			break;
  8005ed:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8005f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005f3:	83 c7 01             	add    $0x1,%edi
  8005f6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005fa:	83 f8 25             	cmp    $0x25,%eax
  8005fd:	0f 84 64 fc ff ff    	je     800267 <vprintfmt+0x17>
			if (ch == '\0')
  800603:	85 c0                	test   %eax,%eax
  800605:	0f 84 8b 00 00 00    	je     800696 <vprintfmt+0x446>
			putch(ch, putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	53                   	push   %ebx
  80060f:	50                   	push   %eax
  800610:	ff d6                	call   *%esi
  800612:	83 c4 10             	add    $0x10,%esp
  800615:	eb dc                	jmp    8005f3 <vprintfmt+0x3a3>
	if (lflag >= 2)
  800617:	83 f9 01             	cmp    $0x1,%ecx
  80061a:	7e 15                	jle    800631 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8b 10                	mov    (%eax),%edx
  800621:	8b 48 04             	mov    0x4(%eax),%ecx
  800624:	8d 40 08             	lea    0x8(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80062a:	b8 10 00 00 00       	mov    $0x10,%eax
  80062f:	eb a5                	jmp    8005d6 <vprintfmt+0x386>
	else if (lflag)
  800631:	85 c9                	test   %ecx,%ecx
  800633:	75 17                	jne    80064c <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 10                	mov    (%eax),%edx
  80063a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063f:	8d 40 04             	lea    0x4(%eax),%eax
  800642:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800645:	b8 10 00 00 00       	mov    $0x10,%eax
  80064a:	eb 8a                	jmp    8005d6 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 10                	mov    (%eax),%edx
  800651:	b9 00 00 00 00       	mov    $0x0,%ecx
  800656:	8d 40 04             	lea    0x4(%eax),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80065c:	b8 10 00 00 00       	mov    $0x10,%eax
  800661:	e9 70 ff ff ff       	jmp    8005d6 <vprintfmt+0x386>
			putch(ch, putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	6a 25                	push   $0x25
  80066c:	ff d6                	call   *%esi
			break;
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	e9 7a ff ff ff       	jmp    8005f0 <vprintfmt+0x3a0>
			putch('%', putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	53                   	push   %ebx
  80067a:	6a 25                	push   $0x25
  80067c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	89 f8                	mov    %edi,%eax
  800683:	eb 03                	jmp    800688 <vprintfmt+0x438>
  800685:	83 e8 01             	sub    $0x1,%eax
  800688:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80068c:	75 f7                	jne    800685 <vprintfmt+0x435>
  80068e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800691:	e9 5a ff ff ff       	jmp    8005f0 <vprintfmt+0x3a0>
}
  800696:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800699:	5b                   	pop    %ebx
  80069a:	5e                   	pop    %esi
  80069b:	5f                   	pop    %edi
  80069c:	5d                   	pop    %ebp
  80069d:	c3                   	ret    

0080069e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80069e:	55                   	push   %ebp
  80069f:	89 e5                	mov    %esp,%ebp
  8006a1:	83 ec 18             	sub    $0x18,%esp
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006ad:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006b1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006bb:	85 c0                	test   %eax,%eax
  8006bd:	74 26                	je     8006e5 <vsnprintf+0x47>
  8006bf:	85 d2                	test   %edx,%edx
  8006c1:	7e 22                	jle    8006e5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006c3:	ff 75 14             	pushl  0x14(%ebp)
  8006c6:	ff 75 10             	pushl  0x10(%ebp)
  8006c9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006cc:	50                   	push   %eax
  8006cd:	68 16 02 80 00       	push   $0x800216
  8006d2:	e8 79 fb ff ff       	call   800250 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006da:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006e0:	83 c4 10             	add    $0x10,%esp
}
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    
		return -E_INVAL;
  8006e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006ea:	eb f7                	jmp    8006e3 <vsnprintf+0x45>

008006ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
  8006ef:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006f2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006f5:	50                   	push   %eax
  8006f6:	ff 75 10             	pushl  0x10(%ebp)
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	ff 75 08             	pushl  0x8(%ebp)
  8006ff:	e8 9a ff ff ff       	call   80069e <vsnprintf>
	va_end(ap);

	return rc;
}
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80070c:	b8 00 00 00 00       	mov    $0x0,%eax
  800711:	eb 03                	jmp    800716 <strlen+0x10>
		n++;
  800713:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800716:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80071a:	75 f7                	jne    800713 <strlen+0xd>
	return n;
}
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800724:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800727:	b8 00 00 00 00       	mov    $0x0,%eax
  80072c:	eb 03                	jmp    800731 <strnlen+0x13>
		n++;
  80072e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800731:	39 d0                	cmp    %edx,%eax
  800733:	74 06                	je     80073b <strnlen+0x1d>
  800735:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800739:	75 f3                	jne    80072e <strnlen+0x10>
	return n;
}
  80073b:	5d                   	pop    %ebp
  80073c:	c3                   	ret    

0080073d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	53                   	push   %ebx
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800747:	89 c2                	mov    %eax,%edx
  800749:	83 c1 01             	add    $0x1,%ecx
  80074c:	83 c2 01             	add    $0x1,%edx
  80074f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800753:	88 5a ff             	mov    %bl,-0x1(%edx)
  800756:	84 db                	test   %bl,%bl
  800758:	75 ef                	jne    800749 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80075a:	5b                   	pop    %ebx
  80075b:	5d                   	pop    %ebp
  80075c:	c3                   	ret    

0080075d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80075d:	55                   	push   %ebp
  80075e:	89 e5                	mov    %esp,%ebp
  800760:	53                   	push   %ebx
  800761:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800764:	53                   	push   %ebx
  800765:	e8 9c ff ff ff       	call   800706 <strlen>
  80076a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	01 d8                	add    %ebx,%eax
  800772:	50                   	push   %eax
  800773:	e8 c5 ff ff ff       	call   80073d <strcpy>
	return dst;
}
  800778:	89 d8                	mov    %ebx,%eax
  80077a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80077d:	c9                   	leave  
  80077e:	c3                   	ret    

0080077f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80077f:	55                   	push   %ebp
  800780:	89 e5                	mov    %esp,%ebp
  800782:	56                   	push   %esi
  800783:	53                   	push   %ebx
  800784:	8b 75 08             	mov    0x8(%ebp),%esi
  800787:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80078a:	89 f3                	mov    %esi,%ebx
  80078c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80078f:	89 f2                	mov    %esi,%edx
  800791:	eb 0f                	jmp    8007a2 <strncpy+0x23>
		*dst++ = *src;
  800793:	83 c2 01             	add    $0x1,%edx
  800796:	0f b6 01             	movzbl (%ecx),%eax
  800799:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80079c:	80 39 01             	cmpb   $0x1,(%ecx)
  80079f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007a2:	39 da                	cmp    %ebx,%edx
  8007a4:	75 ed                	jne    800793 <strncpy+0x14>
	}
	return ret;
}
  8007a6:	89 f0                	mov    %esi,%eax
  8007a8:	5b                   	pop    %ebx
  8007a9:	5e                   	pop    %esi
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
  8007af:	56                   	push   %esi
  8007b0:	53                   	push   %ebx
  8007b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007ba:	89 f0                	mov    %esi,%eax
  8007bc:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007c0:	85 c9                	test   %ecx,%ecx
  8007c2:	75 0b                	jne    8007cf <strlcpy+0x23>
  8007c4:	eb 17                	jmp    8007dd <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007c6:	83 c2 01             	add    $0x1,%edx
  8007c9:	83 c0 01             	add    $0x1,%eax
  8007cc:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8007cf:	39 d8                	cmp    %ebx,%eax
  8007d1:	74 07                	je     8007da <strlcpy+0x2e>
  8007d3:	0f b6 0a             	movzbl (%edx),%ecx
  8007d6:	84 c9                	test   %cl,%cl
  8007d8:	75 ec                	jne    8007c6 <strlcpy+0x1a>
		*dst = '\0';
  8007da:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007dd:	29 f0                	sub    %esi,%eax
}
  8007df:	5b                   	pop    %ebx
  8007e0:	5e                   	pop    %esi
  8007e1:	5d                   	pop    %ebp
  8007e2:	c3                   	ret    

008007e3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007e3:	55                   	push   %ebp
  8007e4:	89 e5                	mov    %esp,%ebp
  8007e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007ec:	eb 06                	jmp    8007f4 <strcmp+0x11>
		p++, q++;
  8007ee:	83 c1 01             	add    $0x1,%ecx
  8007f1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8007f4:	0f b6 01             	movzbl (%ecx),%eax
  8007f7:	84 c0                	test   %al,%al
  8007f9:	74 04                	je     8007ff <strcmp+0x1c>
  8007fb:	3a 02                	cmp    (%edx),%al
  8007fd:	74 ef                	je     8007ee <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007ff:	0f b6 c0             	movzbl %al,%eax
  800802:	0f b6 12             	movzbl (%edx),%edx
  800805:	29 d0                	sub    %edx,%eax
}
  800807:	5d                   	pop    %ebp
  800808:	c3                   	ret    

00800809 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800809:	55                   	push   %ebp
  80080a:	89 e5                	mov    %esp,%ebp
  80080c:	53                   	push   %ebx
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	8b 55 0c             	mov    0xc(%ebp),%edx
  800813:	89 c3                	mov    %eax,%ebx
  800815:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800818:	eb 06                	jmp    800820 <strncmp+0x17>
		n--, p++, q++;
  80081a:	83 c0 01             	add    $0x1,%eax
  80081d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800820:	39 d8                	cmp    %ebx,%eax
  800822:	74 16                	je     80083a <strncmp+0x31>
  800824:	0f b6 08             	movzbl (%eax),%ecx
  800827:	84 c9                	test   %cl,%cl
  800829:	74 04                	je     80082f <strncmp+0x26>
  80082b:	3a 0a                	cmp    (%edx),%cl
  80082d:	74 eb                	je     80081a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80082f:	0f b6 00             	movzbl (%eax),%eax
  800832:	0f b6 12             	movzbl (%edx),%edx
  800835:	29 d0                	sub    %edx,%eax
}
  800837:	5b                   	pop    %ebx
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    
		return 0;
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	eb f6                	jmp    800837 <strncmp+0x2e>

00800841 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800841:	55                   	push   %ebp
  800842:	89 e5                	mov    %esp,%ebp
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80084b:	0f b6 10             	movzbl (%eax),%edx
  80084e:	84 d2                	test   %dl,%dl
  800850:	74 09                	je     80085b <strchr+0x1a>
		if (*s == c)
  800852:	38 ca                	cmp    %cl,%dl
  800854:	74 0a                	je     800860 <strchr+0x1f>
	for (; *s; s++)
  800856:	83 c0 01             	add    $0x1,%eax
  800859:	eb f0                	jmp    80084b <strchr+0xa>
			return (char *) s;
	return 0;
  80085b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80086c:	eb 03                	jmp    800871 <strfind+0xf>
  80086e:	83 c0 01             	add    $0x1,%eax
  800871:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800874:	38 ca                	cmp    %cl,%dl
  800876:	74 04                	je     80087c <strfind+0x1a>
  800878:	84 d2                	test   %dl,%dl
  80087a:	75 f2                	jne    80086e <strfind+0xc>
			break;
	return (char *) s;
}
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	57                   	push   %edi
  800882:	56                   	push   %esi
  800883:	53                   	push   %ebx
  800884:	8b 7d 08             	mov    0x8(%ebp),%edi
  800887:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80088a:	85 c9                	test   %ecx,%ecx
  80088c:	74 13                	je     8008a1 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80088e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800894:	75 05                	jne    80089b <memset+0x1d>
  800896:	f6 c1 03             	test   $0x3,%cl
  800899:	74 0d                	je     8008a8 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80089b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089e:	fc                   	cld    
  80089f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008a1:	89 f8                	mov    %edi,%eax
  8008a3:	5b                   	pop    %ebx
  8008a4:	5e                   	pop    %esi
  8008a5:	5f                   	pop    %edi
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    
		c &= 0xFF;
  8008a8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ac:	89 d3                	mov    %edx,%ebx
  8008ae:	c1 e3 08             	shl    $0x8,%ebx
  8008b1:	89 d0                	mov    %edx,%eax
  8008b3:	c1 e0 18             	shl    $0x18,%eax
  8008b6:	89 d6                	mov    %edx,%esi
  8008b8:	c1 e6 10             	shl    $0x10,%esi
  8008bb:	09 f0                	or     %esi,%eax
  8008bd:	09 c2                	or     %eax,%edx
  8008bf:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008c1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008c4:	89 d0                	mov    %edx,%eax
  8008c6:	fc                   	cld    
  8008c7:	f3 ab                	rep stos %eax,%es:(%edi)
  8008c9:	eb d6                	jmp    8008a1 <memset+0x23>

008008cb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	57                   	push   %edi
  8008cf:	56                   	push   %esi
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008d9:	39 c6                	cmp    %eax,%esi
  8008db:	73 35                	jae    800912 <memmove+0x47>
  8008dd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008e0:	39 c2                	cmp    %eax,%edx
  8008e2:	76 2e                	jbe    800912 <memmove+0x47>
		s += n;
		d += n;
  8008e4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008e7:	89 d6                	mov    %edx,%esi
  8008e9:	09 fe                	or     %edi,%esi
  8008eb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008f1:	74 0c                	je     8008ff <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8008f3:	83 ef 01             	sub    $0x1,%edi
  8008f6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8008f9:	fd                   	std    
  8008fa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008fc:	fc                   	cld    
  8008fd:	eb 21                	jmp    800920 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008ff:	f6 c1 03             	test   $0x3,%cl
  800902:	75 ef                	jne    8008f3 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800904:	83 ef 04             	sub    $0x4,%edi
  800907:	8d 72 fc             	lea    -0x4(%edx),%esi
  80090a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80090d:	fd                   	std    
  80090e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800910:	eb ea                	jmp    8008fc <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800912:	89 f2                	mov    %esi,%edx
  800914:	09 c2                	or     %eax,%edx
  800916:	f6 c2 03             	test   $0x3,%dl
  800919:	74 09                	je     800924 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80091b:	89 c7                	mov    %eax,%edi
  80091d:	fc                   	cld    
  80091e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800920:	5e                   	pop    %esi
  800921:	5f                   	pop    %edi
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800924:	f6 c1 03             	test   $0x3,%cl
  800927:	75 f2                	jne    80091b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800929:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80092c:	89 c7                	mov    %eax,%edi
  80092e:	fc                   	cld    
  80092f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800931:	eb ed                	jmp    800920 <memmove+0x55>

00800933 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800936:	ff 75 10             	pushl  0x10(%ebp)
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	ff 75 08             	pushl  0x8(%ebp)
  80093f:	e8 87 ff ff ff       	call   8008cb <memmove>
}
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	56                   	push   %esi
  80094a:	53                   	push   %ebx
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800951:	89 c6                	mov    %eax,%esi
  800953:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800956:	39 f0                	cmp    %esi,%eax
  800958:	74 1c                	je     800976 <memcmp+0x30>
		if (*s1 != *s2)
  80095a:	0f b6 08             	movzbl (%eax),%ecx
  80095d:	0f b6 1a             	movzbl (%edx),%ebx
  800960:	38 d9                	cmp    %bl,%cl
  800962:	75 08                	jne    80096c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800964:	83 c0 01             	add    $0x1,%eax
  800967:	83 c2 01             	add    $0x1,%edx
  80096a:	eb ea                	jmp    800956 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80096c:	0f b6 c1             	movzbl %cl,%eax
  80096f:	0f b6 db             	movzbl %bl,%ebx
  800972:	29 d8                	sub    %ebx,%eax
  800974:	eb 05                	jmp    80097b <memcmp+0x35>
	}

	return 0;
  800976:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80097b:	5b                   	pop    %ebx
  80097c:	5e                   	pop    %esi
  80097d:	5d                   	pop    %ebp
  80097e:	c3                   	ret    

0080097f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800988:	89 c2                	mov    %eax,%edx
  80098a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80098d:	39 d0                	cmp    %edx,%eax
  80098f:	73 09                	jae    80099a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800991:	38 08                	cmp    %cl,(%eax)
  800993:	74 05                	je     80099a <memfind+0x1b>
	for (; s < ends; s++)
  800995:	83 c0 01             	add    $0x1,%eax
  800998:	eb f3                	jmp    80098d <memfind+0xe>
			break;
	return (void *) s;
}
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	57                   	push   %edi
  8009a0:	56                   	push   %esi
  8009a1:	53                   	push   %ebx
  8009a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009a8:	eb 03                	jmp    8009ad <strtol+0x11>
		s++;
  8009aa:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009ad:	0f b6 01             	movzbl (%ecx),%eax
  8009b0:	3c 20                	cmp    $0x20,%al
  8009b2:	74 f6                	je     8009aa <strtol+0xe>
  8009b4:	3c 09                	cmp    $0x9,%al
  8009b6:	74 f2                	je     8009aa <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009b8:	3c 2b                	cmp    $0x2b,%al
  8009ba:	74 2e                	je     8009ea <strtol+0x4e>
	int neg = 0;
  8009bc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009c1:	3c 2d                	cmp    $0x2d,%al
  8009c3:	74 2f                	je     8009f4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009c5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009cb:	75 05                	jne    8009d2 <strtol+0x36>
  8009cd:	80 39 30             	cmpb   $0x30,(%ecx)
  8009d0:	74 2c                	je     8009fe <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009d2:	85 db                	test   %ebx,%ebx
  8009d4:	75 0a                	jne    8009e0 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009d6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8009db:	80 39 30             	cmpb   $0x30,(%ecx)
  8009de:	74 28                	je     800a08 <strtol+0x6c>
		base = 10;
  8009e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009e8:	eb 50                	jmp    800a3a <strtol+0x9e>
		s++;
  8009ea:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8009f2:	eb d1                	jmp    8009c5 <strtol+0x29>
		s++, neg = 1;
  8009f4:	83 c1 01             	add    $0x1,%ecx
  8009f7:	bf 01 00 00 00       	mov    $0x1,%edi
  8009fc:	eb c7                	jmp    8009c5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009fe:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a02:	74 0e                	je     800a12 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a04:	85 db                	test   %ebx,%ebx
  800a06:	75 d8                	jne    8009e0 <strtol+0x44>
		s++, base = 8;
  800a08:	83 c1 01             	add    $0x1,%ecx
  800a0b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a10:	eb ce                	jmp    8009e0 <strtol+0x44>
		s += 2, base = 16;
  800a12:	83 c1 02             	add    $0x2,%ecx
  800a15:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a1a:	eb c4                	jmp    8009e0 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a1c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a1f:	89 f3                	mov    %esi,%ebx
  800a21:	80 fb 19             	cmp    $0x19,%bl
  800a24:	77 29                	ja     800a4f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a26:	0f be d2             	movsbl %dl,%edx
  800a29:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a2c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a2f:	7d 30                	jge    800a61 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a31:	83 c1 01             	add    $0x1,%ecx
  800a34:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a38:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a3a:	0f b6 11             	movzbl (%ecx),%edx
  800a3d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a40:	89 f3                	mov    %esi,%ebx
  800a42:	80 fb 09             	cmp    $0x9,%bl
  800a45:	77 d5                	ja     800a1c <strtol+0x80>
			dig = *s - '0';
  800a47:	0f be d2             	movsbl %dl,%edx
  800a4a:	83 ea 30             	sub    $0x30,%edx
  800a4d:	eb dd                	jmp    800a2c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a4f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a52:	89 f3                	mov    %esi,%ebx
  800a54:	80 fb 19             	cmp    $0x19,%bl
  800a57:	77 08                	ja     800a61 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a59:	0f be d2             	movsbl %dl,%edx
  800a5c:	83 ea 37             	sub    $0x37,%edx
  800a5f:	eb cb                	jmp    800a2c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a65:	74 05                	je     800a6c <strtol+0xd0>
		*endptr = (char *) s;
  800a67:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a6c:	89 c2                	mov    %eax,%edx
  800a6e:	f7 da                	neg    %edx
  800a70:	85 ff                	test   %edi,%edi
  800a72:	0f 45 c2             	cmovne %edx,%eax
}
  800a75:	5b                   	pop    %ebx
  800a76:	5e                   	pop    %esi
  800a77:	5f                   	pop    %edi
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    

00800a7a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	57                   	push   %edi
  800a7e:	56                   	push   %esi
  800a7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
  800a85:	8b 55 08             	mov    0x8(%ebp),%edx
  800a88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a8b:	89 c3                	mov    %eax,%ebx
  800a8d:	89 c7                	mov    %eax,%edi
  800a8f:	89 c6                	mov    %eax,%esi
  800a91:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800a93:	5b                   	pop    %ebx
  800a94:	5e                   	pop    %esi
  800a95:	5f                   	pop    %edi
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	57                   	push   %edi
  800a9c:	56                   	push   %esi
  800a9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa3:	b8 01 00 00 00       	mov    $0x1,%eax
  800aa8:	89 d1                	mov    %edx,%ecx
  800aaa:	89 d3                	mov    %edx,%ebx
  800aac:	89 d7                	mov    %edx,%edi
  800aae:	89 d6                	mov    %edx,%esi
  800ab0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ab2:	5b                   	pop    %ebx
  800ab3:	5e                   	pop    %esi
  800ab4:	5f                   	pop    %edi
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	57                   	push   %edi
  800abb:	56                   	push   %esi
  800abc:	53                   	push   %ebx
  800abd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ac0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ac5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac8:	b8 03 00 00 00       	mov    $0x3,%eax
  800acd:	89 cb                	mov    %ecx,%ebx
  800acf:	89 cf                	mov    %ecx,%edi
  800ad1:	89 ce                	mov    %ecx,%esi
  800ad3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ad5:	85 c0                	test   %eax,%eax
  800ad7:	7f 08                	jg     800ae1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ad9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800adc:	5b                   	pop    %ebx
  800add:	5e                   	pop    %esi
  800ade:	5f                   	pop    %edi
  800adf:	5d                   	pop    %ebp
  800ae0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ae1:	83 ec 0c             	sub    $0xc,%esp
  800ae4:	50                   	push   %eax
  800ae5:	6a 03                	push   $0x3
  800ae7:	68 5f 20 80 00       	push   $0x80205f
  800aec:	6a 23                	push   $0x23
  800aee:	68 7c 20 80 00       	push   $0x80207c
  800af3:	e8 ea 0e 00 00       	call   8019e2 <_panic>

00800af8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	57                   	push   %edi
  800afc:	56                   	push   %esi
  800afd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800afe:	ba 00 00 00 00       	mov    $0x0,%edx
  800b03:	b8 02 00 00 00       	mov    $0x2,%eax
  800b08:	89 d1                	mov    %edx,%ecx
  800b0a:	89 d3                	mov    %edx,%ebx
  800b0c:	89 d7                	mov    %edx,%edi
  800b0e:	89 d6                	mov    %edx,%esi
  800b10:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b12:	5b                   	pop    %ebx
  800b13:	5e                   	pop    %esi
  800b14:	5f                   	pop    %edi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <sys_yield>:

void
sys_yield(void)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	57                   	push   %edi
  800b1b:	56                   	push   %esi
  800b1c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b22:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b27:	89 d1                	mov    %edx,%ecx
  800b29:	89 d3                	mov    %edx,%ebx
  800b2b:	89 d7                	mov    %edx,%edi
  800b2d:	89 d6                	mov    %edx,%esi
  800b2f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b31:	5b                   	pop    %ebx
  800b32:	5e                   	pop    %esi
  800b33:	5f                   	pop    %edi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	57                   	push   %edi
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
  800b3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b3f:	be 00 00 00 00       	mov    $0x0,%esi
  800b44:	8b 55 08             	mov    0x8(%ebp),%edx
  800b47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4a:	b8 04 00 00 00       	mov    $0x4,%eax
  800b4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b52:	89 f7                	mov    %esi,%edi
  800b54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b56:	85 c0                	test   %eax,%eax
  800b58:	7f 08                	jg     800b62 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b5d:	5b                   	pop    %ebx
  800b5e:	5e                   	pop    %esi
  800b5f:	5f                   	pop    %edi
  800b60:	5d                   	pop    %ebp
  800b61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b62:	83 ec 0c             	sub    $0xc,%esp
  800b65:	50                   	push   %eax
  800b66:	6a 04                	push   $0x4
  800b68:	68 5f 20 80 00       	push   $0x80205f
  800b6d:	6a 23                	push   $0x23
  800b6f:	68 7c 20 80 00       	push   $0x80207c
  800b74:	e8 69 0e 00 00       	call   8019e2 <_panic>

00800b79 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	57                   	push   %edi
  800b7d:	56                   	push   %esi
  800b7e:	53                   	push   %ebx
  800b7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b82:	8b 55 08             	mov    0x8(%ebp),%edx
  800b85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b88:	b8 05 00 00 00       	mov    $0x5,%eax
  800b8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b90:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b93:	8b 75 18             	mov    0x18(%ebp),%esi
  800b96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b98:	85 c0                	test   %eax,%eax
  800b9a:	7f 08                	jg     800ba4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800b9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b9f:	5b                   	pop    %ebx
  800ba0:	5e                   	pop    %esi
  800ba1:	5f                   	pop    %edi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba4:	83 ec 0c             	sub    $0xc,%esp
  800ba7:	50                   	push   %eax
  800ba8:	6a 05                	push   $0x5
  800baa:	68 5f 20 80 00       	push   $0x80205f
  800baf:	6a 23                	push   $0x23
  800bb1:	68 7c 20 80 00       	push   $0x80207c
  800bb6:	e8 27 0e 00 00       	call   8019e2 <_panic>

00800bbb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	57                   	push   %edi
  800bbf:	56                   	push   %esi
  800bc0:	53                   	push   %ebx
  800bc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bcf:	b8 06 00 00 00       	mov    $0x6,%eax
  800bd4:	89 df                	mov    %ebx,%edi
  800bd6:	89 de                	mov    %ebx,%esi
  800bd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bda:	85 c0                	test   %eax,%eax
  800bdc:	7f 08                	jg     800be6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be1:	5b                   	pop    %ebx
  800be2:	5e                   	pop    %esi
  800be3:	5f                   	pop    %edi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be6:	83 ec 0c             	sub    $0xc,%esp
  800be9:	50                   	push   %eax
  800bea:	6a 06                	push   $0x6
  800bec:	68 5f 20 80 00       	push   $0x80205f
  800bf1:	6a 23                	push   $0x23
  800bf3:	68 7c 20 80 00       	push   $0x80207c
  800bf8:	e8 e5 0d 00 00       	call   8019e2 <_panic>

00800bfd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	57                   	push   %edi
  800c01:	56                   	push   %esi
  800c02:	53                   	push   %ebx
  800c03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c11:	b8 08 00 00 00       	mov    $0x8,%eax
  800c16:	89 df                	mov    %ebx,%edi
  800c18:	89 de                	mov    %ebx,%esi
  800c1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1c:	85 c0                	test   %eax,%eax
  800c1e:	7f 08                	jg     800c28 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c23:	5b                   	pop    %ebx
  800c24:	5e                   	pop    %esi
  800c25:	5f                   	pop    %edi
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c28:	83 ec 0c             	sub    $0xc,%esp
  800c2b:	50                   	push   %eax
  800c2c:	6a 08                	push   $0x8
  800c2e:	68 5f 20 80 00       	push   $0x80205f
  800c33:	6a 23                	push   $0x23
  800c35:	68 7c 20 80 00       	push   $0x80207c
  800c3a:	e8 a3 0d 00 00       	call   8019e2 <_panic>

00800c3f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	57                   	push   %edi
  800c43:	56                   	push   %esi
  800c44:	53                   	push   %ebx
  800c45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c53:	b8 09 00 00 00       	mov    $0x9,%eax
  800c58:	89 df                	mov    %ebx,%edi
  800c5a:	89 de                	mov    %ebx,%esi
  800c5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5e:	85 c0                	test   %eax,%eax
  800c60:	7f 08                	jg     800c6a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	6a 09                	push   $0x9
  800c70:	68 5f 20 80 00       	push   $0x80205f
  800c75:	6a 23                	push   $0x23
  800c77:	68 7c 20 80 00       	push   $0x80207c
  800c7c:	e8 61 0d 00 00       	call   8019e2 <_panic>

00800c81 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c95:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c9a:	89 df                	mov    %ebx,%edi
  800c9c:	89 de                	mov    %ebx,%esi
  800c9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	7f 08                	jg     800cac <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	50                   	push   %eax
  800cb0:	6a 0a                	push   $0xa
  800cb2:	68 5f 20 80 00       	push   $0x80205f
  800cb7:	6a 23                	push   $0x23
  800cb9:	68 7c 20 80 00       	push   $0x80207c
  800cbe:	e8 1f 0d 00 00       	call   8019e2 <_panic>

00800cc3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cd4:	be 00 00 00 00       	mov    $0x0,%esi
  800cd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cdc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cdf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ce1:	5b                   	pop    %ebx
  800ce2:	5e                   	pop    %esi
  800ce3:	5f                   	pop    %edi
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    

00800ce6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	57                   	push   %edi
  800cea:	56                   	push   %esi
  800ceb:	53                   	push   %ebx
  800cec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cef:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cfc:	89 cb                	mov    %ecx,%ebx
  800cfe:	89 cf                	mov    %ecx,%edi
  800d00:	89 ce                	mov    %ecx,%esi
  800d02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d04:	85 c0                	test   %eax,%eax
  800d06:	7f 08                	jg     800d10 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0b:	5b                   	pop    %ebx
  800d0c:	5e                   	pop    %esi
  800d0d:	5f                   	pop    %edi
  800d0e:	5d                   	pop    %ebp
  800d0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d10:	83 ec 0c             	sub    $0xc,%esp
  800d13:	50                   	push   %eax
  800d14:	6a 0d                	push   $0xd
  800d16:	68 5f 20 80 00       	push   $0x80205f
  800d1b:	6a 23                	push   $0x23
  800d1d:	68 7c 20 80 00       	push   $0x80207c
  800d22:	e8 bb 0c 00 00       	call   8019e2 <_panic>

00800d27 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	05 00 00 00 30       	add    $0x30000000,%eax
  800d32:	c1 e8 0c             	shr    $0xc,%eax
}
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d47:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    

00800d4e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d54:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d59:	89 c2                	mov    %eax,%edx
  800d5b:	c1 ea 16             	shr    $0x16,%edx
  800d5e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d65:	f6 c2 01             	test   $0x1,%dl
  800d68:	74 2a                	je     800d94 <fd_alloc+0x46>
  800d6a:	89 c2                	mov    %eax,%edx
  800d6c:	c1 ea 0c             	shr    $0xc,%edx
  800d6f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d76:	f6 c2 01             	test   $0x1,%dl
  800d79:	74 19                	je     800d94 <fd_alloc+0x46>
  800d7b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800d80:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d85:	75 d2                	jne    800d59 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d87:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800d8d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800d92:	eb 07                	jmp    800d9b <fd_alloc+0x4d>
			*fd_store = fd;
  800d94:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    

00800d9d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800da3:	83 f8 1f             	cmp    $0x1f,%eax
  800da6:	77 36                	ja     800dde <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800da8:	c1 e0 0c             	shl    $0xc,%eax
  800dab:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800db0:	89 c2                	mov    %eax,%edx
  800db2:	c1 ea 16             	shr    $0x16,%edx
  800db5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dbc:	f6 c2 01             	test   $0x1,%dl
  800dbf:	74 24                	je     800de5 <fd_lookup+0x48>
  800dc1:	89 c2                	mov    %eax,%edx
  800dc3:	c1 ea 0c             	shr    $0xc,%edx
  800dc6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dcd:	f6 c2 01             	test   $0x1,%dl
  800dd0:	74 1a                	je     800dec <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd5:	89 02                	mov    %eax,(%edx)
	return 0;
  800dd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    
		return -E_INVAL;
  800dde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800de3:	eb f7                	jmp    800ddc <fd_lookup+0x3f>
		return -E_INVAL;
  800de5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dea:	eb f0                	jmp    800ddc <fd_lookup+0x3f>
  800dec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800df1:	eb e9                	jmp    800ddc <fd_lookup+0x3f>

00800df3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 08             	sub    $0x8,%esp
  800df9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dfc:	ba 08 21 80 00       	mov    $0x802108,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e01:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e06:	39 08                	cmp    %ecx,(%eax)
  800e08:	74 33                	je     800e3d <dev_lookup+0x4a>
  800e0a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800e0d:	8b 02                	mov    (%edx),%eax
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	75 f3                	jne    800e06 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e13:	a1 04 40 80 00       	mov    0x804004,%eax
  800e18:	8b 40 48             	mov    0x48(%eax),%eax
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	51                   	push   %ecx
  800e1f:	50                   	push   %eax
  800e20:	68 8c 20 80 00       	push   $0x80208c
  800e25:	e8 29 f3 ff ff       	call   800153 <cprintf>
	*dev = 0;
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e33:	83 c4 10             	add    $0x10,%esp
  800e36:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    
			*dev = devtab[i];
  800e3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e40:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e42:	b8 00 00 00 00       	mov    $0x0,%eax
  800e47:	eb f2                	jmp    800e3b <dev_lookup+0x48>

00800e49 <fd_close>:
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	83 ec 1c             	sub    $0x1c,%esp
  800e52:	8b 75 08             	mov    0x8(%ebp),%esi
  800e55:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e58:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e5b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e5c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800e62:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e65:	50                   	push   %eax
  800e66:	e8 32 ff ff ff       	call   800d9d <fd_lookup>
  800e6b:	89 c3                	mov    %eax,%ebx
  800e6d:	83 c4 08             	add    $0x8,%esp
  800e70:	85 c0                	test   %eax,%eax
  800e72:	78 05                	js     800e79 <fd_close+0x30>
	    || fd != fd2)
  800e74:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800e77:	74 16                	je     800e8f <fd_close+0x46>
		return (must_exist ? r : 0);
  800e79:	89 f8                	mov    %edi,%eax
  800e7b:	84 c0                	test   %al,%al
  800e7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e82:	0f 44 d8             	cmove  %eax,%ebx
}
  800e85:	89 d8                	mov    %ebx,%eax
  800e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5f                   	pop    %edi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e8f:	83 ec 08             	sub    $0x8,%esp
  800e92:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800e95:	50                   	push   %eax
  800e96:	ff 36                	pushl  (%esi)
  800e98:	e8 56 ff ff ff       	call   800df3 <dev_lookup>
  800e9d:	89 c3                	mov    %eax,%ebx
  800e9f:	83 c4 10             	add    $0x10,%esp
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	78 15                	js     800ebb <fd_close+0x72>
		if (dev->dev_close)
  800ea6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ea9:	8b 40 10             	mov    0x10(%eax),%eax
  800eac:	85 c0                	test   %eax,%eax
  800eae:	74 1b                	je     800ecb <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	56                   	push   %esi
  800eb4:	ff d0                	call   *%eax
  800eb6:	89 c3                	mov    %eax,%ebx
  800eb8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800ebb:	83 ec 08             	sub    $0x8,%esp
  800ebe:	56                   	push   %esi
  800ebf:	6a 00                	push   $0x0
  800ec1:	e8 f5 fc ff ff       	call   800bbb <sys_page_unmap>
	return r;
  800ec6:	83 c4 10             	add    $0x10,%esp
  800ec9:	eb ba                	jmp    800e85 <fd_close+0x3c>
			r = 0;
  800ecb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed0:	eb e9                	jmp    800ebb <fd_close+0x72>

00800ed2 <close>:

int
close(int fdnum)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ed8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800edb:	50                   	push   %eax
  800edc:	ff 75 08             	pushl  0x8(%ebp)
  800edf:	e8 b9 fe ff ff       	call   800d9d <fd_lookup>
  800ee4:	83 c4 08             	add    $0x8,%esp
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	78 10                	js     800efb <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800eeb:	83 ec 08             	sub    $0x8,%esp
  800eee:	6a 01                	push   $0x1
  800ef0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef3:	e8 51 ff ff ff       	call   800e49 <fd_close>
  800ef8:	83 c4 10             	add    $0x10,%esp
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <close_all>:

void
close_all(void)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	53                   	push   %ebx
  800f01:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f04:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f09:	83 ec 0c             	sub    $0xc,%esp
  800f0c:	53                   	push   %ebx
  800f0d:	e8 c0 ff ff ff       	call   800ed2 <close>
	for (i = 0; i < MAXFD; i++)
  800f12:	83 c3 01             	add    $0x1,%ebx
  800f15:	83 c4 10             	add    $0x10,%esp
  800f18:	83 fb 20             	cmp    $0x20,%ebx
  800f1b:	75 ec                	jne    800f09 <close_all+0xc>
}
  800f1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f20:	c9                   	leave  
  800f21:	c3                   	ret    

00800f22 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	57                   	push   %edi
  800f26:	56                   	push   %esi
  800f27:	53                   	push   %ebx
  800f28:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f2b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f2e:	50                   	push   %eax
  800f2f:	ff 75 08             	pushl  0x8(%ebp)
  800f32:	e8 66 fe ff ff       	call   800d9d <fd_lookup>
  800f37:	89 c3                	mov    %eax,%ebx
  800f39:	83 c4 08             	add    $0x8,%esp
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	0f 88 81 00 00 00    	js     800fc5 <dup+0xa3>
		return r;
	close(newfdnum);
  800f44:	83 ec 0c             	sub    $0xc,%esp
  800f47:	ff 75 0c             	pushl  0xc(%ebp)
  800f4a:	e8 83 ff ff ff       	call   800ed2 <close>

	newfd = INDEX2FD(newfdnum);
  800f4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f52:	c1 e6 0c             	shl    $0xc,%esi
  800f55:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f5b:	83 c4 04             	add    $0x4,%esp
  800f5e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f61:	e8 d1 fd ff ff       	call   800d37 <fd2data>
  800f66:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f68:	89 34 24             	mov    %esi,(%esp)
  800f6b:	e8 c7 fd ff ff       	call   800d37 <fd2data>
  800f70:	83 c4 10             	add    $0x10,%esp
  800f73:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f75:	89 d8                	mov    %ebx,%eax
  800f77:	c1 e8 16             	shr    $0x16,%eax
  800f7a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f81:	a8 01                	test   $0x1,%al
  800f83:	74 11                	je     800f96 <dup+0x74>
  800f85:	89 d8                	mov    %ebx,%eax
  800f87:	c1 e8 0c             	shr    $0xc,%eax
  800f8a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f91:	f6 c2 01             	test   $0x1,%dl
  800f94:	75 39                	jne    800fcf <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f99:	89 d0                	mov    %edx,%eax
  800f9b:	c1 e8 0c             	shr    $0xc,%eax
  800f9e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fa5:	83 ec 0c             	sub    $0xc,%esp
  800fa8:	25 07 0e 00 00       	and    $0xe07,%eax
  800fad:	50                   	push   %eax
  800fae:	56                   	push   %esi
  800faf:	6a 00                	push   $0x0
  800fb1:	52                   	push   %edx
  800fb2:	6a 00                	push   $0x0
  800fb4:	e8 c0 fb ff ff       	call   800b79 <sys_page_map>
  800fb9:	89 c3                	mov    %eax,%ebx
  800fbb:	83 c4 20             	add    $0x20,%esp
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	78 31                	js     800ff3 <dup+0xd1>
		goto err;

	return newfdnum;
  800fc2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800fc5:	89 d8                	mov    %ebx,%eax
  800fc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fca:	5b                   	pop    %ebx
  800fcb:	5e                   	pop    %esi
  800fcc:	5f                   	pop    %edi
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fcf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fd6:	83 ec 0c             	sub    $0xc,%esp
  800fd9:	25 07 0e 00 00       	and    $0xe07,%eax
  800fde:	50                   	push   %eax
  800fdf:	57                   	push   %edi
  800fe0:	6a 00                	push   $0x0
  800fe2:	53                   	push   %ebx
  800fe3:	6a 00                	push   $0x0
  800fe5:	e8 8f fb ff ff       	call   800b79 <sys_page_map>
  800fea:	89 c3                	mov    %eax,%ebx
  800fec:	83 c4 20             	add    $0x20,%esp
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	79 a3                	jns    800f96 <dup+0x74>
	sys_page_unmap(0, newfd);
  800ff3:	83 ec 08             	sub    $0x8,%esp
  800ff6:	56                   	push   %esi
  800ff7:	6a 00                	push   $0x0
  800ff9:	e8 bd fb ff ff       	call   800bbb <sys_page_unmap>
	sys_page_unmap(0, nva);
  800ffe:	83 c4 08             	add    $0x8,%esp
  801001:	57                   	push   %edi
  801002:	6a 00                	push   $0x0
  801004:	e8 b2 fb ff ff       	call   800bbb <sys_page_unmap>
	return r;
  801009:	83 c4 10             	add    $0x10,%esp
  80100c:	eb b7                	jmp    800fc5 <dup+0xa3>

0080100e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	53                   	push   %ebx
  801012:	83 ec 14             	sub    $0x14,%esp
  801015:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801018:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80101b:	50                   	push   %eax
  80101c:	53                   	push   %ebx
  80101d:	e8 7b fd ff ff       	call   800d9d <fd_lookup>
  801022:	83 c4 08             	add    $0x8,%esp
  801025:	85 c0                	test   %eax,%eax
  801027:	78 3f                	js     801068 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801029:	83 ec 08             	sub    $0x8,%esp
  80102c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80102f:	50                   	push   %eax
  801030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801033:	ff 30                	pushl  (%eax)
  801035:	e8 b9 fd ff ff       	call   800df3 <dev_lookup>
  80103a:	83 c4 10             	add    $0x10,%esp
  80103d:	85 c0                	test   %eax,%eax
  80103f:	78 27                	js     801068 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801041:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801044:	8b 42 08             	mov    0x8(%edx),%eax
  801047:	83 e0 03             	and    $0x3,%eax
  80104a:	83 f8 01             	cmp    $0x1,%eax
  80104d:	74 1e                	je     80106d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80104f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801052:	8b 40 08             	mov    0x8(%eax),%eax
  801055:	85 c0                	test   %eax,%eax
  801057:	74 35                	je     80108e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801059:	83 ec 04             	sub    $0x4,%esp
  80105c:	ff 75 10             	pushl  0x10(%ebp)
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	52                   	push   %edx
  801063:	ff d0                	call   *%eax
  801065:	83 c4 10             	add    $0x10,%esp
}
  801068:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80106d:	a1 04 40 80 00       	mov    0x804004,%eax
  801072:	8b 40 48             	mov    0x48(%eax),%eax
  801075:	83 ec 04             	sub    $0x4,%esp
  801078:	53                   	push   %ebx
  801079:	50                   	push   %eax
  80107a:	68 cd 20 80 00       	push   $0x8020cd
  80107f:	e8 cf f0 ff ff       	call   800153 <cprintf>
		return -E_INVAL;
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80108c:	eb da                	jmp    801068 <read+0x5a>
		return -E_NOT_SUPP;
  80108e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801093:	eb d3                	jmp    801068 <read+0x5a>

00801095 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	57                   	push   %edi
  801099:	56                   	push   %esi
  80109a:	53                   	push   %ebx
  80109b:	83 ec 0c             	sub    $0xc,%esp
  80109e:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010a1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a9:	39 f3                	cmp    %esi,%ebx
  8010ab:	73 25                	jae    8010d2 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010ad:	83 ec 04             	sub    $0x4,%esp
  8010b0:	89 f0                	mov    %esi,%eax
  8010b2:	29 d8                	sub    %ebx,%eax
  8010b4:	50                   	push   %eax
  8010b5:	89 d8                	mov    %ebx,%eax
  8010b7:	03 45 0c             	add    0xc(%ebp),%eax
  8010ba:	50                   	push   %eax
  8010bb:	57                   	push   %edi
  8010bc:	e8 4d ff ff ff       	call   80100e <read>
		if (m < 0)
  8010c1:	83 c4 10             	add    $0x10,%esp
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	78 08                	js     8010d0 <readn+0x3b>
			return m;
		if (m == 0)
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	74 06                	je     8010d2 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8010cc:	01 c3                	add    %eax,%ebx
  8010ce:	eb d9                	jmp    8010a9 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010d0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8010d2:	89 d8                	mov    %ebx,%eax
  8010d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d7:	5b                   	pop    %ebx
  8010d8:	5e                   	pop    %esi
  8010d9:	5f                   	pop    %edi
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    

008010dc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	53                   	push   %ebx
  8010e0:	83 ec 14             	sub    $0x14,%esp
  8010e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010e9:	50                   	push   %eax
  8010ea:	53                   	push   %ebx
  8010eb:	e8 ad fc ff ff       	call   800d9d <fd_lookup>
  8010f0:	83 c4 08             	add    $0x8,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	78 3a                	js     801131 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010f7:	83 ec 08             	sub    $0x8,%esp
  8010fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010fd:	50                   	push   %eax
  8010fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801101:	ff 30                	pushl  (%eax)
  801103:	e8 eb fc ff ff       	call   800df3 <dev_lookup>
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	85 c0                	test   %eax,%eax
  80110d:	78 22                	js     801131 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80110f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801112:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801116:	74 1e                	je     801136 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801118:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111b:	8b 52 0c             	mov    0xc(%edx),%edx
  80111e:	85 d2                	test   %edx,%edx
  801120:	74 35                	je     801157 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801122:	83 ec 04             	sub    $0x4,%esp
  801125:	ff 75 10             	pushl  0x10(%ebp)
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	50                   	push   %eax
  80112c:	ff d2                	call   *%edx
  80112e:	83 c4 10             	add    $0x10,%esp
}
  801131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801134:	c9                   	leave  
  801135:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801136:	a1 04 40 80 00       	mov    0x804004,%eax
  80113b:	8b 40 48             	mov    0x48(%eax),%eax
  80113e:	83 ec 04             	sub    $0x4,%esp
  801141:	53                   	push   %ebx
  801142:	50                   	push   %eax
  801143:	68 e9 20 80 00       	push   $0x8020e9
  801148:	e8 06 f0 ff ff       	call   800153 <cprintf>
		return -E_INVAL;
  80114d:	83 c4 10             	add    $0x10,%esp
  801150:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801155:	eb da                	jmp    801131 <write+0x55>
		return -E_NOT_SUPP;
  801157:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80115c:	eb d3                	jmp    801131 <write+0x55>

0080115e <seek>:

int
seek(int fdnum, off_t offset)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801164:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801167:	50                   	push   %eax
  801168:	ff 75 08             	pushl  0x8(%ebp)
  80116b:	e8 2d fc ff ff       	call   800d9d <fd_lookup>
  801170:	83 c4 08             	add    $0x8,%esp
  801173:	85 c0                	test   %eax,%eax
  801175:	78 0e                	js     801185 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801185:	c9                   	leave  
  801186:	c3                   	ret    

00801187 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	53                   	push   %ebx
  80118b:	83 ec 14             	sub    $0x14,%esp
  80118e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801191:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801194:	50                   	push   %eax
  801195:	53                   	push   %ebx
  801196:	e8 02 fc ff ff       	call   800d9d <fd_lookup>
  80119b:	83 c4 08             	add    $0x8,%esp
  80119e:	85 c0                	test   %eax,%eax
  8011a0:	78 37                	js     8011d9 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011a2:	83 ec 08             	sub    $0x8,%esp
  8011a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a8:	50                   	push   %eax
  8011a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ac:	ff 30                	pushl  (%eax)
  8011ae:	e8 40 fc ff ff       	call   800df3 <dev_lookup>
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	78 1f                	js     8011d9 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011c1:	74 1b                	je     8011de <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8011c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c6:	8b 52 18             	mov    0x18(%edx),%edx
  8011c9:	85 d2                	test   %edx,%edx
  8011cb:	74 32                	je     8011ff <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8011cd:	83 ec 08             	sub    $0x8,%esp
  8011d0:	ff 75 0c             	pushl  0xc(%ebp)
  8011d3:	50                   	push   %eax
  8011d4:	ff d2                	call   *%edx
  8011d6:	83 c4 10             	add    $0x10,%esp
}
  8011d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011dc:	c9                   	leave  
  8011dd:	c3                   	ret    
			thisenv->env_id, fdnum);
  8011de:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011e3:	8b 40 48             	mov    0x48(%eax),%eax
  8011e6:	83 ec 04             	sub    $0x4,%esp
  8011e9:	53                   	push   %ebx
  8011ea:	50                   	push   %eax
  8011eb:	68 ac 20 80 00       	push   $0x8020ac
  8011f0:	e8 5e ef ff ff       	call   800153 <cprintf>
		return -E_INVAL;
  8011f5:	83 c4 10             	add    $0x10,%esp
  8011f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011fd:	eb da                	jmp    8011d9 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8011ff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801204:	eb d3                	jmp    8011d9 <ftruncate+0x52>

00801206 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	53                   	push   %ebx
  80120a:	83 ec 14             	sub    $0x14,%esp
  80120d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801210:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801213:	50                   	push   %eax
  801214:	ff 75 08             	pushl  0x8(%ebp)
  801217:	e8 81 fb ff ff       	call   800d9d <fd_lookup>
  80121c:	83 c4 08             	add    $0x8,%esp
  80121f:	85 c0                	test   %eax,%eax
  801221:	78 4b                	js     80126e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801223:	83 ec 08             	sub    $0x8,%esp
  801226:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801229:	50                   	push   %eax
  80122a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122d:	ff 30                	pushl  (%eax)
  80122f:	e8 bf fb ff ff       	call   800df3 <dev_lookup>
  801234:	83 c4 10             	add    $0x10,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	78 33                	js     80126e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80123b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801242:	74 2f                	je     801273 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801244:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801247:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80124e:	00 00 00 
	stat->st_isdir = 0;
  801251:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801258:	00 00 00 
	stat->st_dev = dev;
  80125b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801261:	83 ec 08             	sub    $0x8,%esp
  801264:	53                   	push   %ebx
  801265:	ff 75 f0             	pushl  -0x10(%ebp)
  801268:	ff 50 14             	call   *0x14(%eax)
  80126b:	83 c4 10             	add    $0x10,%esp
}
  80126e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801271:	c9                   	leave  
  801272:	c3                   	ret    
		return -E_NOT_SUPP;
  801273:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801278:	eb f4                	jmp    80126e <fstat+0x68>

0080127a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	56                   	push   %esi
  80127e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80127f:	83 ec 08             	sub    $0x8,%esp
  801282:	6a 00                	push   $0x0
  801284:	ff 75 08             	pushl  0x8(%ebp)
  801287:	e8 e7 01 00 00       	call   801473 <open>
  80128c:	89 c3                	mov    %eax,%ebx
  80128e:	83 c4 10             	add    $0x10,%esp
  801291:	85 c0                	test   %eax,%eax
  801293:	78 1b                	js     8012b0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801295:	83 ec 08             	sub    $0x8,%esp
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	50                   	push   %eax
  80129c:	e8 65 ff ff ff       	call   801206 <fstat>
  8012a1:	89 c6                	mov    %eax,%esi
	close(fd);
  8012a3:	89 1c 24             	mov    %ebx,(%esp)
  8012a6:	e8 27 fc ff ff       	call   800ed2 <close>
	return r;
  8012ab:	83 c4 10             	add    $0x10,%esp
  8012ae:	89 f3                	mov    %esi,%ebx
}
  8012b0:	89 d8                	mov    %ebx,%eax
  8012b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b5:	5b                   	pop    %ebx
  8012b6:	5e                   	pop    %esi
  8012b7:	5d                   	pop    %ebp
  8012b8:	c3                   	ret    

008012b9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	56                   	push   %esi
  8012bd:	53                   	push   %ebx
  8012be:	89 c6                	mov    %eax,%esi
  8012c0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8012c2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012c9:	74 27                	je     8012f2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012cb:	6a 07                	push   $0x7
  8012cd:	68 00 50 80 00       	push   $0x805000
  8012d2:	56                   	push   %esi
  8012d3:	ff 35 00 40 80 00    	pushl  0x804000
  8012d9:	e8 61 07 00 00       	call   801a3f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012de:	83 c4 0c             	add    $0xc,%esp
  8012e1:	6a 00                	push   $0x0
  8012e3:	53                   	push   %ebx
  8012e4:	6a 00                	push   $0x0
  8012e6:	e8 3d 07 00 00       	call   801a28 <ipc_recv>
}
  8012eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ee:	5b                   	pop    %ebx
  8012ef:	5e                   	pop    %esi
  8012f0:	5d                   	pop    %ebp
  8012f1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8012f2:	83 ec 0c             	sub    $0xc,%esp
  8012f5:	6a 01                	push   $0x1
  8012f7:	e8 5a 07 00 00       	call   801a56 <ipc_find_env>
  8012fc:	a3 00 40 80 00       	mov    %eax,0x804000
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	eb c5                	jmp    8012cb <fsipc+0x12>

00801306 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	8b 40 0c             	mov    0xc(%eax),%eax
  801312:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80131f:	ba 00 00 00 00       	mov    $0x0,%edx
  801324:	b8 02 00 00 00       	mov    $0x2,%eax
  801329:	e8 8b ff ff ff       	call   8012b9 <fsipc>
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <devfile_flush>:
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8b 40 0c             	mov    0xc(%eax),%eax
  80133c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801341:	ba 00 00 00 00       	mov    $0x0,%edx
  801346:	b8 06 00 00 00       	mov    $0x6,%eax
  80134b:	e8 69 ff ff ff       	call   8012b9 <fsipc>
}
  801350:	c9                   	leave  
  801351:	c3                   	ret    

00801352 <devfile_stat>:
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
  801355:	53                   	push   %ebx
  801356:	83 ec 04             	sub    $0x4,%esp
  801359:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8b 40 0c             	mov    0xc(%eax),%eax
  801362:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801367:	ba 00 00 00 00       	mov    $0x0,%edx
  80136c:	b8 05 00 00 00       	mov    $0x5,%eax
  801371:	e8 43 ff ff ff       	call   8012b9 <fsipc>
  801376:	85 c0                	test   %eax,%eax
  801378:	78 2c                	js     8013a6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80137a:	83 ec 08             	sub    $0x8,%esp
  80137d:	68 00 50 80 00       	push   $0x805000
  801382:	53                   	push   %ebx
  801383:	e8 b5 f3 ff ff       	call   80073d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801388:	a1 80 50 80 00       	mov    0x805080,%eax
  80138d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801393:	a1 84 50 80 00       	mov    0x805084,%eax
  801398:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    

008013ab <devfile_write>:
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	83 ec 0c             	sub    $0xc,%esp
  8013b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b4:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8013b9:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8013be:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c4:	8b 52 0c             	mov    0xc(%edx),%edx
  8013c7:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8013cd:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8013d2:	50                   	push   %eax
  8013d3:	ff 75 0c             	pushl  0xc(%ebp)
  8013d6:	68 08 50 80 00       	push   $0x805008
  8013db:	e8 eb f4 ff ff       	call   8008cb <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8013e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e5:	b8 04 00 00 00       	mov    $0x4,%eax
  8013ea:	e8 ca fe ff ff       	call   8012b9 <fsipc>
}
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <devfile_read>:
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	56                   	push   %esi
  8013f5:	53                   	push   %ebx
  8013f6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8013ff:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801404:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80140a:	ba 00 00 00 00       	mov    $0x0,%edx
  80140f:	b8 03 00 00 00       	mov    $0x3,%eax
  801414:	e8 a0 fe ff ff       	call   8012b9 <fsipc>
  801419:	89 c3                	mov    %eax,%ebx
  80141b:	85 c0                	test   %eax,%eax
  80141d:	78 1f                	js     80143e <devfile_read+0x4d>
	assert(r <= n);
  80141f:	39 f0                	cmp    %esi,%eax
  801421:	77 24                	ja     801447 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801423:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801428:	7f 33                	jg     80145d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	50                   	push   %eax
  80142e:	68 00 50 80 00       	push   $0x805000
  801433:	ff 75 0c             	pushl  0xc(%ebp)
  801436:	e8 90 f4 ff ff       	call   8008cb <memmove>
	return r;
  80143b:	83 c4 10             	add    $0x10,%esp
}
  80143e:	89 d8                	mov    %ebx,%eax
  801440:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801443:	5b                   	pop    %ebx
  801444:	5e                   	pop    %esi
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    
	assert(r <= n);
  801447:	68 18 21 80 00       	push   $0x802118
  80144c:	68 1f 21 80 00       	push   $0x80211f
  801451:	6a 7c                	push   $0x7c
  801453:	68 34 21 80 00       	push   $0x802134
  801458:	e8 85 05 00 00       	call   8019e2 <_panic>
	assert(r <= PGSIZE);
  80145d:	68 3f 21 80 00       	push   $0x80213f
  801462:	68 1f 21 80 00       	push   $0x80211f
  801467:	6a 7d                	push   $0x7d
  801469:	68 34 21 80 00       	push   $0x802134
  80146e:	e8 6f 05 00 00       	call   8019e2 <_panic>

00801473 <open>:
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	56                   	push   %esi
  801477:	53                   	push   %ebx
  801478:	83 ec 1c             	sub    $0x1c,%esp
  80147b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80147e:	56                   	push   %esi
  80147f:	e8 82 f2 ff ff       	call   800706 <strlen>
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80148c:	7f 6c                	jg     8014fa <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801494:	50                   	push   %eax
  801495:	e8 b4 f8 ff ff       	call   800d4e <fd_alloc>
  80149a:	89 c3                	mov    %eax,%ebx
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 3c                	js     8014df <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8014a3:	83 ec 08             	sub    $0x8,%esp
  8014a6:	56                   	push   %esi
  8014a7:	68 00 50 80 00       	push   $0x805000
  8014ac:	e8 8c f2 ff ff       	call   80073d <strcpy>
	fsipcbuf.open.req_omode = mode;
  8014b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8014b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8014c1:	e8 f3 fd ff ff       	call   8012b9 <fsipc>
  8014c6:	89 c3                	mov    %eax,%ebx
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	78 19                	js     8014e8 <open+0x75>
	return fd2num(fd);
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d5:	e8 4d f8 ff ff       	call   800d27 <fd2num>
  8014da:	89 c3                	mov    %eax,%ebx
  8014dc:	83 c4 10             	add    $0x10,%esp
}
  8014df:	89 d8                	mov    %ebx,%eax
  8014e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e4:	5b                   	pop    %ebx
  8014e5:	5e                   	pop    %esi
  8014e6:	5d                   	pop    %ebp
  8014e7:	c3                   	ret    
		fd_close(fd, 0);
  8014e8:	83 ec 08             	sub    $0x8,%esp
  8014eb:	6a 00                	push   $0x0
  8014ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f0:	e8 54 f9 ff ff       	call   800e49 <fd_close>
		return r;
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	eb e5                	jmp    8014df <open+0x6c>
		return -E_BAD_PATH;
  8014fa:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8014ff:	eb de                	jmp    8014df <open+0x6c>

00801501 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801507:	ba 00 00 00 00       	mov    $0x0,%edx
  80150c:	b8 08 00 00 00       	mov    $0x8,%eax
  801511:	e8 a3 fd ff ff       	call   8012b9 <fsipc>
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	56                   	push   %esi
  80151c:	53                   	push   %ebx
  80151d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801520:	83 ec 0c             	sub    $0xc,%esp
  801523:	ff 75 08             	pushl  0x8(%ebp)
  801526:	e8 0c f8 ff ff       	call   800d37 <fd2data>
  80152b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80152d:	83 c4 08             	add    $0x8,%esp
  801530:	68 4b 21 80 00       	push   $0x80214b
  801535:	53                   	push   %ebx
  801536:	e8 02 f2 ff ff       	call   80073d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80153b:	8b 46 04             	mov    0x4(%esi),%eax
  80153e:	2b 06                	sub    (%esi),%eax
  801540:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801546:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80154d:	00 00 00 
	stat->st_dev = &devpipe;
  801550:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801557:	30 80 00 
	return 0;
}
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
  80155f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801562:	5b                   	pop    %ebx
  801563:	5e                   	pop    %esi
  801564:	5d                   	pop    %ebp
  801565:	c3                   	ret    

00801566 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	53                   	push   %ebx
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801570:	53                   	push   %ebx
  801571:	6a 00                	push   $0x0
  801573:	e8 43 f6 ff ff       	call   800bbb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801578:	89 1c 24             	mov    %ebx,(%esp)
  80157b:	e8 b7 f7 ff ff       	call   800d37 <fd2data>
  801580:	83 c4 08             	add    $0x8,%esp
  801583:	50                   	push   %eax
  801584:	6a 00                	push   $0x0
  801586:	e8 30 f6 ff ff       	call   800bbb <sys_page_unmap>
}
  80158b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <_pipeisclosed>:
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	57                   	push   %edi
  801594:	56                   	push   %esi
  801595:	53                   	push   %ebx
  801596:	83 ec 1c             	sub    $0x1c,%esp
  801599:	89 c7                	mov    %eax,%edi
  80159b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80159d:	a1 04 40 80 00       	mov    0x804004,%eax
  8015a2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8015a5:	83 ec 0c             	sub    $0xc,%esp
  8015a8:	57                   	push   %edi
  8015a9:	e8 e1 04 00 00       	call   801a8f <pageref>
  8015ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015b1:	89 34 24             	mov    %esi,(%esp)
  8015b4:	e8 d6 04 00 00       	call   801a8f <pageref>
		nn = thisenv->env_runs;
  8015b9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8015bf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	39 cb                	cmp    %ecx,%ebx
  8015c7:	74 1b                	je     8015e4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8015c9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015cc:	75 cf                	jne    80159d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8015ce:	8b 42 58             	mov    0x58(%edx),%eax
  8015d1:	6a 01                	push   $0x1
  8015d3:	50                   	push   %eax
  8015d4:	53                   	push   %ebx
  8015d5:	68 52 21 80 00       	push   $0x802152
  8015da:	e8 74 eb ff ff       	call   800153 <cprintf>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	eb b9                	jmp    80159d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8015e4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015e7:	0f 94 c0             	sete   %al
  8015ea:	0f b6 c0             	movzbl %al,%eax
}
  8015ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5f                   	pop    %edi
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    

008015f5 <devpipe_write>:
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	57                   	push   %edi
  8015f9:	56                   	push   %esi
  8015fa:	53                   	push   %ebx
  8015fb:	83 ec 28             	sub    $0x28,%esp
  8015fe:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801601:	56                   	push   %esi
  801602:	e8 30 f7 ff ff       	call   800d37 <fd2data>
  801607:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	bf 00 00 00 00       	mov    $0x0,%edi
  801611:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801614:	74 4f                	je     801665 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801616:	8b 43 04             	mov    0x4(%ebx),%eax
  801619:	8b 0b                	mov    (%ebx),%ecx
  80161b:	8d 51 20             	lea    0x20(%ecx),%edx
  80161e:	39 d0                	cmp    %edx,%eax
  801620:	72 14                	jb     801636 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801622:	89 da                	mov    %ebx,%edx
  801624:	89 f0                	mov    %esi,%eax
  801626:	e8 65 ff ff ff       	call   801590 <_pipeisclosed>
  80162b:	85 c0                	test   %eax,%eax
  80162d:	75 3a                	jne    801669 <devpipe_write+0x74>
			sys_yield();
  80162f:	e8 e3 f4 ff ff       	call   800b17 <sys_yield>
  801634:	eb e0                	jmp    801616 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801636:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801639:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80163d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801640:	89 c2                	mov    %eax,%edx
  801642:	c1 fa 1f             	sar    $0x1f,%edx
  801645:	89 d1                	mov    %edx,%ecx
  801647:	c1 e9 1b             	shr    $0x1b,%ecx
  80164a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80164d:	83 e2 1f             	and    $0x1f,%edx
  801650:	29 ca                	sub    %ecx,%edx
  801652:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801656:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80165a:	83 c0 01             	add    $0x1,%eax
  80165d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801660:	83 c7 01             	add    $0x1,%edi
  801663:	eb ac                	jmp    801611 <devpipe_write+0x1c>
	return i;
  801665:	89 f8                	mov    %edi,%eax
  801667:	eb 05                	jmp    80166e <devpipe_write+0x79>
				return 0;
  801669:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801671:	5b                   	pop    %ebx
  801672:	5e                   	pop    %esi
  801673:	5f                   	pop    %edi
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    

00801676 <devpipe_read>:
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	57                   	push   %edi
  80167a:	56                   	push   %esi
  80167b:	53                   	push   %ebx
  80167c:	83 ec 18             	sub    $0x18,%esp
  80167f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801682:	57                   	push   %edi
  801683:	e8 af f6 ff ff       	call   800d37 <fd2data>
  801688:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	be 00 00 00 00       	mov    $0x0,%esi
  801692:	3b 75 10             	cmp    0x10(%ebp),%esi
  801695:	74 47                	je     8016de <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801697:	8b 03                	mov    (%ebx),%eax
  801699:	3b 43 04             	cmp    0x4(%ebx),%eax
  80169c:	75 22                	jne    8016c0 <devpipe_read+0x4a>
			if (i > 0)
  80169e:	85 f6                	test   %esi,%esi
  8016a0:	75 14                	jne    8016b6 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8016a2:	89 da                	mov    %ebx,%edx
  8016a4:	89 f8                	mov    %edi,%eax
  8016a6:	e8 e5 fe ff ff       	call   801590 <_pipeisclosed>
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	75 33                	jne    8016e2 <devpipe_read+0x6c>
			sys_yield();
  8016af:	e8 63 f4 ff ff       	call   800b17 <sys_yield>
  8016b4:	eb e1                	jmp    801697 <devpipe_read+0x21>
				return i;
  8016b6:	89 f0                	mov    %esi,%eax
}
  8016b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016bb:	5b                   	pop    %ebx
  8016bc:	5e                   	pop    %esi
  8016bd:	5f                   	pop    %edi
  8016be:	5d                   	pop    %ebp
  8016bf:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8016c0:	99                   	cltd   
  8016c1:	c1 ea 1b             	shr    $0x1b,%edx
  8016c4:	01 d0                	add    %edx,%eax
  8016c6:	83 e0 1f             	and    $0x1f,%eax
  8016c9:	29 d0                	sub    %edx,%eax
  8016cb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8016d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016d3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8016d6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8016d9:	83 c6 01             	add    $0x1,%esi
  8016dc:	eb b4                	jmp    801692 <devpipe_read+0x1c>
	return i;
  8016de:	89 f0                	mov    %esi,%eax
  8016e0:	eb d6                	jmp    8016b8 <devpipe_read+0x42>
				return 0;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e7:	eb cf                	jmp    8016b8 <devpipe_read+0x42>

008016e9 <pipe>:
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	56                   	push   %esi
  8016ed:	53                   	push   %ebx
  8016ee:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8016f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f4:	50                   	push   %eax
  8016f5:	e8 54 f6 ff ff       	call   800d4e <fd_alloc>
  8016fa:	89 c3                	mov    %eax,%ebx
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	85 c0                	test   %eax,%eax
  801701:	78 5b                	js     80175e <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801703:	83 ec 04             	sub    $0x4,%esp
  801706:	68 07 04 00 00       	push   $0x407
  80170b:	ff 75 f4             	pushl  -0xc(%ebp)
  80170e:	6a 00                	push   $0x0
  801710:	e8 21 f4 ff ff       	call   800b36 <sys_page_alloc>
  801715:	89 c3                	mov    %eax,%ebx
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	85 c0                	test   %eax,%eax
  80171c:	78 40                	js     80175e <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80171e:	83 ec 0c             	sub    $0xc,%esp
  801721:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801724:	50                   	push   %eax
  801725:	e8 24 f6 ff ff       	call   800d4e <fd_alloc>
  80172a:	89 c3                	mov    %eax,%ebx
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	85 c0                	test   %eax,%eax
  801731:	78 1b                	js     80174e <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801733:	83 ec 04             	sub    $0x4,%esp
  801736:	68 07 04 00 00       	push   $0x407
  80173b:	ff 75 f0             	pushl  -0x10(%ebp)
  80173e:	6a 00                	push   $0x0
  801740:	e8 f1 f3 ff ff       	call   800b36 <sys_page_alloc>
  801745:	89 c3                	mov    %eax,%ebx
  801747:	83 c4 10             	add    $0x10,%esp
  80174a:	85 c0                	test   %eax,%eax
  80174c:	79 19                	jns    801767 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80174e:	83 ec 08             	sub    $0x8,%esp
  801751:	ff 75 f4             	pushl  -0xc(%ebp)
  801754:	6a 00                	push   $0x0
  801756:	e8 60 f4 ff ff       	call   800bbb <sys_page_unmap>
  80175b:	83 c4 10             	add    $0x10,%esp
}
  80175e:	89 d8                	mov    %ebx,%eax
  801760:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801763:	5b                   	pop    %ebx
  801764:	5e                   	pop    %esi
  801765:	5d                   	pop    %ebp
  801766:	c3                   	ret    
	va = fd2data(fd0);
  801767:	83 ec 0c             	sub    $0xc,%esp
  80176a:	ff 75 f4             	pushl  -0xc(%ebp)
  80176d:	e8 c5 f5 ff ff       	call   800d37 <fd2data>
  801772:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801774:	83 c4 0c             	add    $0xc,%esp
  801777:	68 07 04 00 00       	push   $0x407
  80177c:	50                   	push   %eax
  80177d:	6a 00                	push   $0x0
  80177f:	e8 b2 f3 ff ff       	call   800b36 <sys_page_alloc>
  801784:	89 c3                	mov    %eax,%ebx
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	85 c0                	test   %eax,%eax
  80178b:	0f 88 8c 00 00 00    	js     80181d <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801791:	83 ec 0c             	sub    $0xc,%esp
  801794:	ff 75 f0             	pushl  -0x10(%ebp)
  801797:	e8 9b f5 ff ff       	call   800d37 <fd2data>
  80179c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017a3:	50                   	push   %eax
  8017a4:	6a 00                	push   $0x0
  8017a6:	56                   	push   %esi
  8017a7:	6a 00                	push   $0x0
  8017a9:	e8 cb f3 ff ff       	call   800b79 <sys_page_map>
  8017ae:	89 c3                	mov    %eax,%ebx
  8017b0:	83 c4 20             	add    $0x20,%esp
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	78 58                	js     80180f <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8017b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ba:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017c0:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8017c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8017cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cf:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017d5:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8017d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017da:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8017e1:	83 ec 0c             	sub    $0xc,%esp
  8017e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e7:	e8 3b f5 ff ff       	call   800d27 <fd2num>
  8017ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ef:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8017f1:	83 c4 04             	add    $0x4,%esp
  8017f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f7:	e8 2b f5 ff ff       	call   800d27 <fd2num>
  8017fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ff:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	bb 00 00 00 00       	mov    $0x0,%ebx
  80180a:	e9 4f ff ff ff       	jmp    80175e <pipe+0x75>
	sys_page_unmap(0, va);
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	56                   	push   %esi
  801813:	6a 00                	push   $0x0
  801815:	e8 a1 f3 ff ff       	call   800bbb <sys_page_unmap>
  80181a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80181d:	83 ec 08             	sub    $0x8,%esp
  801820:	ff 75 f0             	pushl  -0x10(%ebp)
  801823:	6a 00                	push   $0x0
  801825:	e8 91 f3 ff ff       	call   800bbb <sys_page_unmap>
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	e9 1c ff ff ff       	jmp    80174e <pipe+0x65>

00801832 <pipeisclosed>:
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801838:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183b:	50                   	push   %eax
  80183c:	ff 75 08             	pushl  0x8(%ebp)
  80183f:	e8 59 f5 ff ff       	call   800d9d <fd_lookup>
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	85 c0                	test   %eax,%eax
  801849:	78 18                	js     801863 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80184b:	83 ec 0c             	sub    $0xc,%esp
  80184e:	ff 75 f4             	pushl  -0xc(%ebp)
  801851:	e8 e1 f4 ff ff       	call   800d37 <fd2data>
	return _pipeisclosed(fd, p);
  801856:	89 c2                	mov    %eax,%edx
  801858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185b:	e8 30 fd ff ff       	call   801590 <_pipeisclosed>
  801860:	83 c4 10             	add    $0x10,%esp
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801868:	b8 00 00 00 00       	mov    $0x0,%eax
  80186d:	5d                   	pop    %ebp
  80186e:	c3                   	ret    

0080186f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801875:	68 6a 21 80 00       	push   $0x80216a
  80187a:	ff 75 0c             	pushl  0xc(%ebp)
  80187d:	e8 bb ee ff ff       	call   80073d <strcpy>
	return 0;
}
  801882:	b8 00 00 00 00       	mov    $0x0,%eax
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <devcons_write>:
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	57                   	push   %edi
  80188d:	56                   	push   %esi
  80188e:	53                   	push   %ebx
  80188f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801895:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80189a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8018a0:	eb 2f                	jmp    8018d1 <devcons_write+0x48>
		m = n - tot;
  8018a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018a5:	29 f3                	sub    %esi,%ebx
  8018a7:	83 fb 7f             	cmp    $0x7f,%ebx
  8018aa:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8018af:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8018b2:	83 ec 04             	sub    $0x4,%esp
  8018b5:	53                   	push   %ebx
  8018b6:	89 f0                	mov    %esi,%eax
  8018b8:	03 45 0c             	add    0xc(%ebp),%eax
  8018bb:	50                   	push   %eax
  8018bc:	57                   	push   %edi
  8018bd:	e8 09 f0 ff ff       	call   8008cb <memmove>
		sys_cputs(buf, m);
  8018c2:	83 c4 08             	add    $0x8,%esp
  8018c5:	53                   	push   %ebx
  8018c6:	57                   	push   %edi
  8018c7:	e8 ae f1 ff ff       	call   800a7a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8018cc:	01 de                	add    %ebx,%esi
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018d4:	72 cc                	jb     8018a2 <devcons_write+0x19>
}
  8018d6:	89 f0                	mov    %esi,%eax
  8018d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018db:	5b                   	pop    %ebx
  8018dc:	5e                   	pop    %esi
  8018dd:	5f                   	pop    %edi
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    

008018e0 <devcons_read>:
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 08             	sub    $0x8,%esp
  8018e6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8018eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ef:	75 07                	jne    8018f8 <devcons_read+0x18>
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    
		sys_yield();
  8018f3:	e8 1f f2 ff ff       	call   800b17 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8018f8:	e8 9b f1 ff ff       	call   800a98 <sys_cgetc>
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	74 f2                	je     8018f3 <devcons_read+0x13>
	if (c < 0)
  801901:	85 c0                	test   %eax,%eax
  801903:	78 ec                	js     8018f1 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801905:	83 f8 04             	cmp    $0x4,%eax
  801908:	74 0c                	je     801916 <devcons_read+0x36>
	*(char*)vbuf = c;
  80190a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190d:	88 02                	mov    %al,(%edx)
	return 1;
  80190f:	b8 01 00 00 00       	mov    $0x1,%eax
  801914:	eb db                	jmp    8018f1 <devcons_read+0x11>
		return 0;
  801916:	b8 00 00 00 00       	mov    $0x0,%eax
  80191b:	eb d4                	jmp    8018f1 <devcons_read+0x11>

0080191d <cputchar>:
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801929:	6a 01                	push   $0x1
  80192b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80192e:	50                   	push   %eax
  80192f:	e8 46 f1 ff ff       	call   800a7a <sys_cputs>
}
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <getchar>:
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80193f:	6a 01                	push   $0x1
  801941:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801944:	50                   	push   %eax
  801945:	6a 00                	push   $0x0
  801947:	e8 c2 f6 ff ff       	call   80100e <read>
	if (r < 0)
  80194c:	83 c4 10             	add    $0x10,%esp
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 08                	js     80195b <getchar+0x22>
	if (r < 1)
  801953:	85 c0                	test   %eax,%eax
  801955:	7e 06                	jle    80195d <getchar+0x24>
	return c;
  801957:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    
		return -E_EOF;
  80195d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801962:	eb f7                	jmp    80195b <getchar+0x22>

00801964 <iscons>:
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80196a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196d:	50                   	push   %eax
  80196e:	ff 75 08             	pushl  0x8(%ebp)
  801971:	e8 27 f4 ff ff       	call   800d9d <fd_lookup>
  801976:	83 c4 10             	add    $0x10,%esp
  801979:	85 c0                	test   %eax,%eax
  80197b:	78 11                	js     80198e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80197d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801980:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801986:	39 10                	cmp    %edx,(%eax)
  801988:	0f 94 c0             	sete   %al
  80198b:	0f b6 c0             	movzbl %al,%eax
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <opencons>:
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801996:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801999:	50                   	push   %eax
  80199a:	e8 af f3 ff ff       	call   800d4e <fd_alloc>
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	78 3a                	js     8019e0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	68 07 04 00 00       	push   $0x407
  8019ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b1:	6a 00                	push   $0x0
  8019b3:	e8 7e f1 ff ff       	call   800b36 <sys_page_alloc>
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 21                	js     8019e0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8019bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019c8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8019ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8019d4:	83 ec 0c             	sub    $0xc,%esp
  8019d7:	50                   	push   %eax
  8019d8:	e8 4a f3 ff ff       	call   800d27 <fd2num>
  8019dd:	83 c4 10             	add    $0x10,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	56                   	push   %esi
  8019e6:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8019e7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8019ea:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8019f0:	e8 03 f1 ff ff       	call   800af8 <sys_getenvid>
  8019f5:	83 ec 0c             	sub    $0xc,%esp
  8019f8:	ff 75 0c             	pushl  0xc(%ebp)
  8019fb:	ff 75 08             	pushl  0x8(%ebp)
  8019fe:	56                   	push   %esi
  8019ff:	50                   	push   %eax
  801a00:	68 78 21 80 00       	push   $0x802178
  801a05:	e8 49 e7 ff ff       	call   800153 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a0a:	83 c4 18             	add    $0x18,%esp
  801a0d:	53                   	push   %ebx
  801a0e:	ff 75 10             	pushl  0x10(%ebp)
  801a11:	e8 ec e6 ff ff       	call   800102 <vcprintf>
	cprintf("\n");
  801a16:	c7 04 24 63 21 80 00 	movl   $0x802163,(%esp)
  801a1d:	e8 31 e7 ff ff       	call   800153 <cprintf>
  801a22:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a25:	cc                   	int3   
  801a26:	eb fd                	jmp    801a25 <_panic+0x43>

00801a28 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801a2e:	68 9c 21 80 00       	push   $0x80219c
  801a33:	6a 1a                	push   $0x1a
  801a35:	68 b5 21 80 00       	push   $0x8021b5
  801a3a:	e8 a3 ff ff ff       	call   8019e2 <_panic>

00801a3f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801a45:	68 bf 21 80 00       	push   $0x8021bf
  801a4a:	6a 2a                	push   $0x2a
  801a4c:	68 b5 21 80 00       	push   $0x8021b5
  801a51:	e8 8c ff ff ff       	call   8019e2 <_panic>

00801a56 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a5c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a61:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a64:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a6a:	8b 52 50             	mov    0x50(%edx),%edx
  801a6d:	39 ca                	cmp    %ecx,%edx
  801a6f:	74 11                	je     801a82 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801a71:	83 c0 01             	add    $0x1,%eax
  801a74:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a79:	75 e6                	jne    801a61 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801a7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a80:	eb 0b                	jmp    801a8d <ipc_find_env+0x37>
			return envs[i].env_id;
  801a82:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a85:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a8a:	8b 40 48             	mov    0x48(%eax),%eax
}
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    

00801a8f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a95:	89 d0                	mov    %edx,%eax
  801a97:	c1 e8 16             	shr    $0x16,%eax
  801a9a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801aa1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801aa6:	f6 c1 01             	test   $0x1,%cl
  801aa9:	74 1d                	je     801ac8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801aab:	c1 ea 0c             	shr    $0xc,%edx
  801aae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ab5:	f6 c2 01             	test   $0x1,%dl
  801ab8:	74 0e                	je     801ac8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801aba:	c1 ea 0c             	shr    $0xc,%edx
  801abd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ac4:	ef 
  801ac5:	0f b7 c0             	movzwl %ax,%eax
}
  801ac8:	5d                   	pop    %ebp
  801ac9:	c3                   	ret    
  801aca:	66 90                	xchg   %ax,%ax
  801acc:	66 90                	xchg   %ax,%ax
  801ace:	66 90                	xchg   %ax,%ax

00801ad0 <__udivdi3>:
  801ad0:	55                   	push   %ebp
  801ad1:	57                   	push   %edi
  801ad2:	56                   	push   %esi
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 1c             	sub    $0x1c,%esp
  801ad7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801adb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801adf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ae3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ae7:	85 d2                	test   %edx,%edx
  801ae9:	75 35                	jne    801b20 <__udivdi3+0x50>
  801aeb:	39 f3                	cmp    %esi,%ebx
  801aed:	0f 87 bd 00 00 00    	ja     801bb0 <__udivdi3+0xe0>
  801af3:	85 db                	test   %ebx,%ebx
  801af5:	89 d9                	mov    %ebx,%ecx
  801af7:	75 0b                	jne    801b04 <__udivdi3+0x34>
  801af9:	b8 01 00 00 00       	mov    $0x1,%eax
  801afe:	31 d2                	xor    %edx,%edx
  801b00:	f7 f3                	div    %ebx
  801b02:	89 c1                	mov    %eax,%ecx
  801b04:	31 d2                	xor    %edx,%edx
  801b06:	89 f0                	mov    %esi,%eax
  801b08:	f7 f1                	div    %ecx
  801b0a:	89 c6                	mov    %eax,%esi
  801b0c:	89 e8                	mov    %ebp,%eax
  801b0e:	89 f7                	mov    %esi,%edi
  801b10:	f7 f1                	div    %ecx
  801b12:	89 fa                	mov    %edi,%edx
  801b14:	83 c4 1c             	add    $0x1c,%esp
  801b17:	5b                   	pop    %ebx
  801b18:	5e                   	pop    %esi
  801b19:	5f                   	pop    %edi
  801b1a:	5d                   	pop    %ebp
  801b1b:	c3                   	ret    
  801b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801b20:	39 f2                	cmp    %esi,%edx
  801b22:	77 7c                	ja     801ba0 <__udivdi3+0xd0>
  801b24:	0f bd fa             	bsr    %edx,%edi
  801b27:	83 f7 1f             	xor    $0x1f,%edi
  801b2a:	0f 84 98 00 00 00    	je     801bc8 <__udivdi3+0xf8>
  801b30:	89 f9                	mov    %edi,%ecx
  801b32:	b8 20 00 00 00       	mov    $0x20,%eax
  801b37:	29 f8                	sub    %edi,%eax
  801b39:	d3 e2                	shl    %cl,%edx
  801b3b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b3f:	89 c1                	mov    %eax,%ecx
  801b41:	89 da                	mov    %ebx,%edx
  801b43:	d3 ea                	shr    %cl,%edx
  801b45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801b49:	09 d1                	or     %edx,%ecx
  801b4b:	89 f2                	mov    %esi,%edx
  801b4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b51:	89 f9                	mov    %edi,%ecx
  801b53:	d3 e3                	shl    %cl,%ebx
  801b55:	89 c1                	mov    %eax,%ecx
  801b57:	d3 ea                	shr    %cl,%edx
  801b59:	89 f9                	mov    %edi,%ecx
  801b5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801b5f:	d3 e6                	shl    %cl,%esi
  801b61:	89 eb                	mov    %ebp,%ebx
  801b63:	89 c1                	mov    %eax,%ecx
  801b65:	d3 eb                	shr    %cl,%ebx
  801b67:	09 de                	or     %ebx,%esi
  801b69:	89 f0                	mov    %esi,%eax
  801b6b:	f7 74 24 08          	divl   0x8(%esp)
  801b6f:	89 d6                	mov    %edx,%esi
  801b71:	89 c3                	mov    %eax,%ebx
  801b73:	f7 64 24 0c          	mull   0xc(%esp)
  801b77:	39 d6                	cmp    %edx,%esi
  801b79:	72 0c                	jb     801b87 <__udivdi3+0xb7>
  801b7b:	89 f9                	mov    %edi,%ecx
  801b7d:	d3 e5                	shl    %cl,%ebp
  801b7f:	39 c5                	cmp    %eax,%ebp
  801b81:	73 5d                	jae    801be0 <__udivdi3+0x110>
  801b83:	39 d6                	cmp    %edx,%esi
  801b85:	75 59                	jne    801be0 <__udivdi3+0x110>
  801b87:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b8a:	31 ff                	xor    %edi,%edi
  801b8c:	89 fa                	mov    %edi,%edx
  801b8e:	83 c4 1c             	add    $0x1c,%esp
  801b91:	5b                   	pop    %ebx
  801b92:	5e                   	pop    %esi
  801b93:	5f                   	pop    %edi
  801b94:	5d                   	pop    %ebp
  801b95:	c3                   	ret    
  801b96:	8d 76 00             	lea    0x0(%esi),%esi
  801b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801ba0:	31 ff                	xor    %edi,%edi
  801ba2:	31 c0                	xor    %eax,%eax
  801ba4:	89 fa                	mov    %edi,%edx
  801ba6:	83 c4 1c             	add    $0x1c,%esp
  801ba9:	5b                   	pop    %ebx
  801baa:	5e                   	pop    %esi
  801bab:	5f                   	pop    %edi
  801bac:	5d                   	pop    %ebp
  801bad:	c3                   	ret    
  801bae:	66 90                	xchg   %ax,%ax
  801bb0:	31 ff                	xor    %edi,%edi
  801bb2:	89 e8                	mov    %ebp,%eax
  801bb4:	89 f2                	mov    %esi,%edx
  801bb6:	f7 f3                	div    %ebx
  801bb8:	89 fa                	mov    %edi,%edx
  801bba:	83 c4 1c             	add    $0x1c,%esp
  801bbd:	5b                   	pop    %ebx
  801bbe:	5e                   	pop    %esi
  801bbf:	5f                   	pop    %edi
  801bc0:	5d                   	pop    %ebp
  801bc1:	c3                   	ret    
  801bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801bc8:	39 f2                	cmp    %esi,%edx
  801bca:	72 06                	jb     801bd2 <__udivdi3+0x102>
  801bcc:	31 c0                	xor    %eax,%eax
  801bce:	39 eb                	cmp    %ebp,%ebx
  801bd0:	77 d2                	ja     801ba4 <__udivdi3+0xd4>
  801bd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd7:	eb cb                	jmp    801ba4 <__udivdi3+0xd4>
  801bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801be0:	89 d8                	mov    %ebx,%eax
  801be2:	31 ff                	xor    %edi,%edi
  801be4:	eb be                	jmp    801ba4 <__udivdi3+0xd4>
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	66 90                	xchg   %ax,%ax
  801bea:	66 90                	xchg   %ax,%ax
  801bec:	66 90                	xchg   %ax,%ax
  801bee:	66 90                	xchg   %ax,%ax

00801bf0 <__umoddi3>:
  801bf0:	55                   	push   %ebp
  801bf1:	57                   	push   %edi
  801bf2:	56                   	push   %esi
  801bf3:	53                   	push   %ebx
  801bf4:	83 ec 1c             	sub    $0x1c,%esp
  801bf7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801bfb:	8b 74 24 30          	mov    0x30(%esp),%esi
  801bff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801c03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c07:	85 ed                	test   %ebp,%ebp
  801c09:	89 f0                	mov    %esi,%eax
  801c0b:	89 da                	mov    %ebx,%edx
  801c0d:	75 19                	jne    801c28 <__umoddi3+0x38>
  801c0f:	39 df                	cmp    %ebx,%edi
  801c11:	0f 86 b1 00 00 00    	jbe    801cc8 <__umoddi3+0xd8>
  801c17:	f7 f7                	div    %edi
  801c19:	89 d0                	mov    %edx,%eax
  801c1b:	31 d2                	xor    %edx,%edx
  801c1d:	83 c4 1c             	add    $0x1c,%esp
  801c20:	5b                   	pop    %ebx
  801c21:	5e                   	pop    %esi
  801c22:	5f                   	pop    %edi
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    
  801c25:	8d 76 00             	lea    0x0(%esi),%esi
  801c28:	39 dd                	cmp    %ebx,%ebp
  801c2a:	77 f1                	ja     801c1d <__umoddi3+0x2d>
  801c2c:	0f bd cd             	bsr    %ebp,%ecx
  801c2f:	83 f1 1f             	xor    $0x1f,%ecx
  801c32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c36:	0f 84 b4 00 00 00    	je     801cf0 <__umoddi3+0x100>
  801c3c:	b8 20 00 00 00       	mov    $0x20,%eax
  801c41:	89 c2                	mov    %eax,%edx
  801c43:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c47:	29 c2                	sub    %eax,%edx
  801c49:	89 c1                	mov    %eax,%ecx
  801c4b:	89 f8                	mov    %edi,%eax
  801c4d:	d3 e5                	shl    %cl,%ebp
  801c4f:	89 d1                	mov    %edx,%ecx
  801c51:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c55:	d3 e8                	shr    %cl,%eax
  801c57:	09 c5                	or     %eax,%ebp
  801c59:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c5d:	89 c1                	mov    %eax,%ecx
  801c5f:	d3 e7                	shl    %cl,%edi
  801c61:	89 d1                	mov    %edx,%ecx
  801c63:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801c67:	89 df                	mov    %ebx,%edi
  801c69:	d3 ef                	shr    %cl,%edi
  801c6b:	89 c1                	mov    %eax,%ecx
  801c6d:	89 f0                	mov    %esi,%eax
  801c6f:	d3 e3                	shl    %cl,%ebx
  801c71:	89 d1                	mov    %edx,%ecx
  801c73:	89 fa                	mov    %edi,%edx
  801c75:	d3 e8                	shr    %cl,%eax
  801c77:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801c7c:	09 d8                	or     %ebx,%eax
  801c7e:	f7 f5                	div    %ebp
  801c80:	d3 e6                	shl    %cl,%esi
  801c82:	89 d1                	mov    %edx,%ecx
  801c84:	f7 64 24 08          	mull   0x8(%esp)
  801c88:	39 d1                	cmp    %edx,%ecx
  801c8a:	89 c3                	mov    %eax,%ebx
  801c8c:	89 d7                	mov    %edx,%edi
  801c8e:	72 06                	jb     801c96 <__umoddi3+0xa6>
  801c90:	75 0e                	jne    801ca0 <__umoddi3+0xb0>
  801c92:	39 c6                	cmp    %eax,%esi
  801c94:	73 0a                	jae    801ca0 <__umoddi3+0xb0>
  801c96:	2b 44 24 08          	sub    0x8(%esp),%eax
  801c9a:	19 ea                	sbb    %ebp,%edx
  801c9c:	89 d7                	mov    %edx,%edi
  801c9e:	89 c3                	mov    %eax,%ebx
  801ca0:	89 ca                	mov    %ecx,%edx
  801ca2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801ca7:	29 de                	sub    %ebx,%esi
  801ca9:	19 fa                	sbb    %edi,%edx
  801cab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801caf:	89 d0                	mov    %edx,%eax
  801cb1:	d3 e0                	shl    %cl,%eax
  801cb3:	89 d9                	mov    %ebx,%ecx
  801cb5:	d3 ee                	shr    %cl,%esi
  801cb7:	d3 ea                	shr    %cl,%edx
  801cb9:	09 f0                	or     %esi,%eax
  801cbb:	83 c4 1c             	add    $0x1c,%esp
  801cbe:	5b                   	pop    %ebx
  801cbf:	5e                   	pop    %esi
  801cc0:	5f                   	pop    %edi
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    
  801cc3:	90                   	nop
  801cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801cc8:	85 ff                	test   %edi,%edi
  801cca:	89 f9                	mov    %edi,%ecx
  801ccc:	75 0b                	jne    801cd9 <__umoddi3+0xe9>
  801cce:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd3:	31 d2                	xor    %edx,%edx
  801cd5:	f7 f7                	div    %edi
  801cd7:	89 c1                	mov    %eax,%ecx
  801cd9:	89 d8                	mov    %ebx,%eax
  801cdb:	31 d2                	xor    %edx,%edx
  801cdd:	f7 f1                	div    %ecx
  801cdf:	89 f0                	mov    %esi,%eax
  801ce1:	f7 f1                	div    %ecx
  801ce3:	e9 31 ff ff ff       	jmp    801c19 <__umoddi3+0x29>
  801ce8:	90                   	nop
  801ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801cf0:	39 dd                	cmp    %ebx,%ebp
  801cf2:	72 08                	jb     801cfc <__umoddi3+0x10c>
  801cf4:	39 f7                	cmp    %esi,%edi
  801cf6:	0f 87 21 ff ff ff    	ja     801c1d <__umoddi3+0x2d>
  801cfc:	89 da                	mov    %ebx,%edx
  801cfe:	89 f0                	mov    %esi,%eax
  801d00:	29 f8                	sub    %edi,%eax
  801d02:	19 ea                	sbb    %ebp,%edx
  801d04:	e9 14 ff ff ff       	jmp    801c1d <__umoddi3+0x2d>
