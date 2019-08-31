
obj/user/faultread.debug：     文件格式 elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
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
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
  800039:	ff 35 00 00 00 00    	pushl  0x0
  80003f:	68 00 1d 80 00       	push   $0x801d00
  800044:	e8 fa 00 00 00       	call   800143 <cprintf>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 8a 0a 00 00       	call   800ae8 <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 db                	test   %ebx,%ebx
  800072:	7e 07                	jle    80007b <libmain+0x2d>
		binaryname = argv[0];
  800074:	8b 06                	mov    (%esi),%eax
  800076:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	e8 ae ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800085:	e8 0a 00 00 00       	call   800094 <exit>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    

00800094 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009a:	e8 4e 0e 00 00       	call   800eed <close_all>
	sys_env_destroy(0);
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	6a 00                	push   $0x0
  8000a4:	e8 fe 09 00 00       	call   800aa7 <sys_env_destroy>
}
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	c9                   	leave  
  8000ad:	c3                   	ret    

008000ae <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	53                   	push   %ebx
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000b8:	8b 13                	mov    (%ebx),%edx
  8000ba:	8d 42 01             	lea    0x1(%edx),%eax
  8000bd:	89 03                	mov    %eax,(%ebx)
  8000bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000cb:	74 09                	je     8000d6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000cd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	68 ff 00 00 00       	push   $0xff
  8000de:	8d 43 08             	lea    0x8(%ebx),%eax
  8000e1:	50                   	push   %eax
  8000e2:	e8 83 09 00 00       	call   800a6a <sys_cputs>
		b->idx = 0;
  8000e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb db                	jmp    8000cd <putch+0x1f>

008000f2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8000fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800102:	00 00 00 
	b.cnt = 0;
  800105:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80010c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80010f:	ff 75 0c             	pushl  0xc(%ebp)
  800112:	ff 75 08             	pushl  0x8(%ebp)
  800115:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80011b:	50                   	push   %eax
  80011c:	68 ae 00 80 00       	push   $0x8000ae
  800121:	e8 1a 01 00 00       	call   800240 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800126:	83 c4 08             	add    $0x8,%esp
  800129:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80012f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800135:	50                   	push   %eax
  800136:	e8 2f 09 00 00       	call   800a6a <sys_cputs>

	return b.cnt;
}
  80013b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800149:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80014c:	50                   	push   %eax
  80014d:	ff 75 08             	pushl  0x8(%ebp)
  800150:	e8 9d ff ff ff       	call   8000f2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	57                   	push   %edi
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
  80015d:	83 ec 1c             	sub    $0x1c,%esp
  800160:	89 c7                	mov    %eax,%edi
  800162:	89 d6                	mov    %edx,%esi
  800164:	8b 45 08             	mov    0x8(%ebp),%eax
  800167:	8b 55 0c             	mov    0xc(%ebp),%edx
  80016a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80016d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800170:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800173:	bb 00 00 00 00       	mov    $0x0,%ebx
  800178:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80017b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80017e:	39 d3                	cmp    %edx,%ebx
  800180:	72 05                	jb     800187 <printnum+0x30>
  800182:	39 45 10             	cmp    %eax,0x10(%ebp)
  800185:	77 7a                	ja     800201 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	ff 75 18             	pushl  0x18(%ebp)
  80018d:	8b 45 14             	mov    0x14(%ebp),%eax
  800190:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800193:	53                   	push   %ebx
  800194:	ff 75 10             	pushl  0x10(%ebp)
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80019d:	ff 75 e0             	pushl  -0x20(%ebp)
  8001a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8001a6:	e8 15 19 00 00       	call   801ac0 <__udivdi3>
  8001ab:	83 c4 18             	add    $0x18,%esp
  8001ae:	52                   	push   %edx
  8001af:	50                   	push   %eax
  8001b0:	89 f2                	mov    %esi,%edx
  8001b2:	89 f8                	mov    %edi,%eax
  8001b4:	e8 9e ff ff ff       	call   800157 <printnum>
  8001b9:	83 c4 20             	add    $0x20,%esp
  8001bc:	eb 13                	jmp    8001d1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	56                   	push   %esi
  8001c2:	ff 75 18             	pushl  0x18(%ebp)
  8001c5:	ff d7                	call   *%edi
  8001c7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001ca:	83 eb 01             	sub    $0x1,%ebx
  8001cd:	85 db                	test   %ebx,%ebx
  8001cf:	7f ed                	jg     8001be <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001d1:	83 ec 08             	sub    $0x8,%esp
  8001d4:	56                   	push   %esi
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001db:	ff 75 e0             	pushl  -0x20(%ebp)
  8001de:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8001e4:	e8 f7 19 00 00       	call   801be0 <__umoddi3>
  8001e9:	83 c4 14             	add    $0x14,%esp
  8001ec:	0f be 80 28 1d 80 00 	movsbl 0x801d28(%eax),%eax
  8001f3:	50                   	push   %eax
  8001f4:	ff d7                	call   *%edi
}
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fc:	5b                   	pop    %ebx
  8001fd:	5e                   	pop    %esi
  8001fe:	5f                   	pop    %edi
  8001ff:	5d                   	pop    %ebp
  800200:	c3                   	ret    
  800201:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800204:	eb c4                	jmp    8001ca <printnum+0x73>

00800206 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80020c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800210:	8b 10                	mov    (%eax),%edx
  800212:	3b 50 04             	cmp    0x4(%eax),%edx
  800215:	73 0a                	jae    800221 <sprintputch+0x1b>
		*b->buf++ = ch;
  800217:	8d 4a 01             	lea    0x1(%edx),%ecx
  80021a:	89 08                	mov    %ecx,(%eax)
  80021c:	8b 45 08             	mov    0x8(%ebp),%eax
  80021f:	88 02                	mov    %al,(%edx)
}
  800221:	5d                   	pop    %ebp
  800222:	c3                   	ret    

00800223 <printfmt>:
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800229:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80022c:	50                   	push   %eax
  80022d:	ff 75 10             	pushl  0x10(%ebp)
  800230:	ff 75 0c             	pushl  0xc(%ebp)
  800233:	ff 75 08             	pushl  0x8(%ebp)
  800236:	e8 05 00 00 00       	call   800240 <vprintfmt>
}
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <vprintfmt>:
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	57                   	push   %edi
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
  800246:	83 ec 2c             	sub    $0x2c,%esp
  800249:	8b 75 08             	mov    0x8(%ebp),%esi
  80024c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80024f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800252:	e9 8c 03 00 00       	jmp    8005e3 <vprintfmt+0x3a3>
		padc = ' ';
  800257:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80025b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800262:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800269:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800270:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800275:	8d 47 01             	lea    0x1(%edi),%eax
  800278:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027b:	0f b6 17             	movzbl (%edi),%edx
  80027e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800281:	3c 55                	cmp    $0x55,%al
  800283:	0f 87 dd 03 00 00    	ja     800666 <vprintfmt+0x426>
  800289:	0f b6 c0             	movzbl %al,%eax
  80028c:	ff 24 85 60 1e 80 00 	jmp    *0x801e60(,%eax,4)
  800293:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800296:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80029a:	eb d9                	jmp    800275 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80029c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80029f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002a3:	eb d0                	jmp    800275 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002a5:	0f b6 d2             	movzbl %dl,%edx
  8002a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002b3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002ba:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002bd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002c0:	83 f9 09             	cmp    $0x9,%ecx
  8002c3:	77 55                	ja     80031a <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002c5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002c8:	eb e9                	jmp    8002b3 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8002cd:	8b 00                	mov    (%eax),%eax
  8002cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d5:	8d 40 04             	lea    0x4(%eax),%eax
  8002d8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002e2:	79 91                	jns    800275 <vprintfmt+0x35>
				width = precision, precision = -1;
  8002e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ea:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002f1:	eb 82                	jmp    800275 <vprintfmt+0x35>
  8002f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f6:	85 c0                	test   %eax,%eax
  8002f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002fd:	0f 49 d0             	cmovns %eax,%edx
  800300:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800306:	e9 6a ff ff ff       	jmp    800275 <vprintfmt+0x35>
  80030b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80030e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800315:	e9 5b ff ff ff       	jmp    800275 <vprintfmt+0x35>
  80031a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80031d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800320:	eb bc                	jmp    8002de <vprintfmt+0x9e>
			lflag++;
  800322:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800325:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800328:	e9 48 ff ff ff       	jmp    800275 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80032d:	8b 45 14             	mov    0x14(%ebp),%eax
  800330:	8d 78 04             	lea    0x4(%eax),%edi
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	53                   	push   %ebx
  800337:	ff 30                	pushl  (%eax)
  800339:	ff d6                	call   *%esi
			break;
  80033b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80033e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800341:	e9 9a 02 00 00       	jmp    8005e0 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800346:	8b 45 14             	mov    0x14(%ebp),%eax
  800349:	8d 78 04             	lea    0x4(%eax),%edi
  80034c:	8b 00                	mov    (%eax),%eax
  80034e:	99                   	cltd   
  80034f:	31 d0                	xor    %edx,%eax
  800351:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800353:	83 f8 0f             	cmp    $0xf,%eax
  800356:	7f 23                	jg     80037b <vprintfmt+0x13b>
  800358:	8b 14 85 c0 1f 80 00 	mov    0x801fc0(,%eax,4),%edx
  80035f:	85 d2                	test   %edx,%edx
  800361:	74 18                	je     80037b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800363:	52                   	push   %edx
  800364:	68 f1 20 80 00       	push   $0x8020f1
  800369:	53                   	push   %ebx
  80036a:	56                   	push   %esi
  80036b:	e8 b3 fe ff ff       	call   800223 <printfmt>
  800370:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800373:	89 7d 14             	mov    %edi,0x14(%ebp)
  800376:	e9 65 02 00 00       	jmp    8005e0 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  80037b:	50                   	push   %eax
  80037c:	68 40 1d 80 00       	push   $0x801d40
  800381:	53                   	push   %ebx
  800382:	56                   	push   %esi
  800383:	e8 9b fe ff ff       	call   800223 <printfmt>
  800388:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80038b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80038e:	e9 4d 02 00 00       	jmp    8005e0 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800393:	8b 45 14             	mov    0x14(%ebp),%eax
  800396:	83 c0 04             	add    $0x4,%eax
  800399:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80039c:	8b 45 14             	mov    0x14(%ebp),%eax
  80039f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003a1:	85 ff                	test   %edi,%edi
  8003a3:	b8 39 1d 80 00       	mov    $0x801d39,%eax
  8003a8:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003af:	0f 8e bd 00 00 00    	jle    800472 <vprintfmt+0x232>
  8003b5:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003b9:	75 0e                	jne    8003c9 <vprintfmt+0x189>
  8003bb:	89 75 08             	mov    %esi,0x8(%ebp)
  8003be:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003c1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003c4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003c7:	eb 6d                	jmp    800436 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003c9:	83 ec 08             	sub    $0x8,%esp
  8003cc:	ff 75 d0             	pushl  -0x30(%ebp)
  8003cf:	57                   	push   %edi
  8003d0:	e8 39 03 00 00       	call   80070e <strnlen>
  8003d5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003d8:	29 c1                	sub    %eax,%ecx
  8003da:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003dd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003e0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003ea:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ec:	eb 0f                	jmp    8003fd <vprintfmt+0x1bd>
					putch(padc, putdat);
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	53                   	push   %ebx
  8003f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003f7:	83 ef 01             	sub    $0x1,%edi
  8003fa:	83 c4 10             	add    $0x10,%esp
  8003fd:	85 ff                	test   %edi,%edi
  8003ff:	7f ed                	jg     8003ee <vprintfmt+0x1ae>
  800401:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800404:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800407:	85 c9                	test   %ecx,%ecx
  800409:	b8 00 00 00 00       	mov    $0x0,%eax
  80040e:	0f 49 c1             	cmovns %ecx,%eax
  800411:	29 c1                	sub    %eax,%ecx
  800413:	89 75 08             	mov    %esi,0x8(%ebp)
  800416:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800419:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80041c:	89 cb                	mov    %ecx,%ebx
  80041e:	eb 16                	jmp    800436 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800420:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800424:	75 31                	jne    800457 <vprintfmt+0x217>
					putch(ch, putdat);
  800426:	83 ec 08             	sub    $0x8,%esp
  800429:	ff 75 0c             	pushl  0xc(%ebp)
  80042c:	50                   	push   %eax
  80042d:	ff 55 08             	call   *0x8(%ebp)
  800430:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800433:	83 eb 01             	sub    $0x1,%ebx
  800436:	83 c7 01             	add    $0x1,%edi
  800439:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80043d:	0f be c2             	movsbl %dl,%eax
  800440:	85 c0                	test   %eax,%eax
  800442:	74 59                	je     80049d <vprintfmt+0x25d>
  800444:	85 f6                	test   %esi,%esi
  800446:	78 d8                	js     800420 <vprintfmt+0x1e0>
  800448:	83 ee 01             	sub    $0x1,%esi
  80044b:	79 d3                	jns    800420 <vprintfmt+0x1e0>
  80044d:	89 df                	mov    %ebx,%edi
  80044f:	8b 75 08             	mov    0x8(%ebp),%esi
  800452:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800455:	eb 37                	jmp    80048e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800457:	0f be d2             	movsbl %dl,%edx
  80045a:	83 ea 20             	sub    $0x20,%edx
  80045d:	83 fa 5e             	cmp    $0x5e,%edx
  800460:	76 c4                	jbe    800426 <vprintfmt+0x1e6>
					putch('?', putdat);
  800462:	83 ec 08             	sub    $0x8,%esp
  800465:	ff 75 0c             	pushl  0xc(%ebp)
  800468:	6a 3f                	push   $0x3f
  80046a:	ff 55 08             	call   *0x8(%ebp)
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	eb c1                	jmp    800433 <vprintfmt+0x1f3>
  800472:	89 75 08             	mov    %esi,0x8(%ebp)
  800475:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800478:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80047b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80047e:	eb b6                	jmp    800436 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	53                   	push   %ebx
  800484:	6a 20                	push   $0x20
  800486:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800488:	83 ef 01             	sub    $0x1,%edi
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	85 ff                	test   %edi,%edi
  800490:	7f ee                	jg     800480 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800492:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800495:	89 45 14             	mov    %eax,0x14(%ebp)
  800498:	e9 43 01 00 00       	jmp    8005e0 <vprintfmt+0x3a0>
  80049d:	89 df                	mov    %ebx,%edi
  80049f:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a5:	eb e7                	jmp    80048e <vprintfmt+0x24e>
	if (lflag >= 2)
  8004a7:	83 f9 01             	cmp    $0x1,%ecx
  8004aa:	7e 3f                	jle    8004eb <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8004af:	8b 50 04             	mov    0x4(%eax),%edx
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8d 40 08             	lea    0x8(%eax),%eax
  8004c0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004c7:	79 5c                	jns    800525 <vprintfmt+0x2e5>
				putch('-', putdat);
  8004c9:	83 ec 08             	sub    $0x8,%esp
  8004cc:	53                   	push   %ebx
  8004cd:	6a 2d                	push   $0x2d
  8004cf:	ff d6                	call   *%esi
				num = -(long long) num;
  8004d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004d4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004d7:	f7 da                	neg    %edx
  8004d9:	83 d1 00             	adc    $0x0,%ecx
  8004dc:	f7 d9                	neg    %ecx
  8004de:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004e6:	e9 db 00 00 00       	jmp    8005c6 <vprintfmt+0x386>
	else if (lflag)
  8004eb:	85 c9                	test   %ecx,%ecx
  8004ed:	75 1b                	jne    80050a <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f7:	89 c1                	mov    %eax,%ecx
  8004f9:	c1 f9 1f             	sar    $0x1f,%ecx
  8004fc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8d 40 04             	lea    0x4(%eax),%eax
  800505:	89 45 14             	mov    %eax,0x14(%ebp)
  800508:	eb b9                	jmp    8004c3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	8b 00                	mov    (%eax),%eax
  80050f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800512:	89 c1                	mov    %eax,%ecx
  800514:	c1 f9 1f             	sar    $0x1f,%ecx
  800517:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80051a:	8b 45 14             	mov    0x14(%ebp),%eax
  80051d:	8d 40 04             	lea    0x4(%eax),%eax
  800520:	89 45 14             	mov    %eax,0x14(%ebp)
  800523:	eb 9e                	jmp    8004c3 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800525:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800528:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80052b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800530:	e9 91 00 00 00       	jmp    8005c6 <vprintfmt+0x386>
	if (lflag >= 2)
  800535:	83 f9 01             	cmp    $0x1,%ecx
  800538:	7e 15                	jle    80054f <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8b 10                	mov    (%eax),%edx
  80053f:	8b 48 04             	mov    0x4(%eax),%ecx
  800542:	8d 40 08             	lea    0x8(%eax),%eax
  800545:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800548:	b8 0a 00 00 00       	mov    $0xa,%eax
  80054d:	eb 77                	jmp    8005c6 <vprintfmt+0x386>
	else if (lflag)
  80054f:	85 c9                	test   %ecx,%ecx
  800551:	75 17                	jne    80056a <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8b 10                	mov    (%eax),%edx
  800558:	b9 00 00 00 00       	mov    $0x0,%ecx
  80055d:	8d 40 04             	lea    0x4(%eax),%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800563:	b8 0a 00 00 00       	mov    $0xa,%eax
  800568:	eb 5c                	jmp    8005c6 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	8b 10                	mov    (%eax),%edx
  80056f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800574:	8d 40 04             	lea    0x4(%eax),%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057f:	eb 45                	jmp    8005c6 <vprintfmt+0x386>
			putch('X', putdat);
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	53                   	push   %ebx
  800585:	6a 58                	push   $0x58
  800587:	ff d6                	call   *%esi
			putch('X', putdat);
  800589:	83 c4 08             	add    $0x8,%esp
  80058c:	53                   	push   %ebx
  80058d:	6a 58                	push   $0x58
  80058f:	ff d6                	call   *%esi
			putch('X', putdat);
  800591:	83 c4 08             	add    $0x8,%esp
  800594:	53                   	push   %ebx
  800595:	6a 58                	push   $0x58
  800597:	ff d6                	call   *%esi
			break;
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	eb 42                	jmp    8005e0 <vprintfmt+0x3a0>
			putch('0', putdat);
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	53                   	push   %ebx
  8005a2:	6a 30                	push   $0x30
  8005a4:	ff d6                	call   *%esi
			putch('x', putdat);
  8005a6:	83 c4 08             	add    $0x8,%esp
  8005a9:	53                   	push   %ebx
  8005aa:	6a 78                	push   $0x78
  8005ac:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 10                	mov    (%eax),%edx
  8005b3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005b8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005bb:	8d 40 04             	lea    0x4(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005c1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005c6:	83 ec 0c             	sub    $0xc,%esp
  8005c9:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005cd:	57                   	push   %edi
  8005ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d1:	50                   	push   %eax
  8005d2:	51                   	push   %ecx
  8005d3:	52                   	push   %edx
  8005d4:	89 da                	mov    %ebx,%edx
  8005d6:	89 f0                	mov    %esi,%eax
  8005d8:	e8 7a fb ff ff       	call   800157 <printnum>
			break;
  8005dd:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8005e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005e3:	83 c7 01             	add    $0x1,%edi
  8005e6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005ea:	83 f8 25             	cmp    $0x25,%eax
  8005ed:	0f 84 64 fc ff ff    	je     800257 <vprintfmt+0x17>
			if (ch == '\0')
  8005f3:	85 c0                	test   %eax,%eax
  8005f5:	0f 84 8b 00 00 00    	je     800686 <vprintfmt+0x446>
			putch(ch, putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	50                   	push   %eax
  800600:	ff d6                	call   *%esi
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	eb dc                	jmp    8005e3 <vprintfmt+0x3a3>
	if (lflag >= 2)
  800607:	83 f9 01             	cmp    $0x1,%ecx
  80060a:	7e 15                	jle    800621 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8b 10                	mov    (%eax),%edx
  800611:	8b 48 04             	mov    0x4(%eax),%ecx
  800614:	8d 40 08             	lea    0x8(%eax),%eax
  800617:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80061a:	b8 10 00 00 00       	mov    $0x10,%eax
  80061f:	eb a5                	jmp    8005c6 <vprintfmt+0x386>
	else if (lflag)
  800621:	85 c9                	test   %ecx,%ecx
  800623:	75 17                	jne    80063c <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8b 10                	mov    (%eax),%edx
  80062a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062f:	8d 40 04             	lea    0x4(%eax),%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800635:	b8 10 00 00 00       	mov    $0x10,%eax
  80063a:	eb 8a                	jmp    8005c6 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8b 10                	mov    (%eax),%edx
  800641:	b9 00 00 00 00       	mov    $0x0,%ecx
  800646:	8d 40 04             	lea    0x4(%eax),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80064c:	b8 10 00 00 00       	mov    $0x10,%eax
  800651:	e9 70 ff ff ff       	jmp    8005c6 <vprintfmt+0x386>
			putch(ch, putdat);
  800656:	83 ec 08             	sub    $0x8,%esp
  800659:	53                   	push   %ebx
  80065a:	6a 25                	push   $0x25
  80065c:	ff d6                	call   *%esi
			break;
  80065e:	83 c4 10             	add    $0x10,%esp
  800661:	e9 7a ff ff ff       	jmp    8005e0 <vprintfmt+0x3a0>
			putch('%', putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	6a 25                	push   $0x25
  80066c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	89 f8                	mov    %edi,%eax
  800673:	eb 03                	jmp    800678 <vprintfmt+0x438>
  800675:	83 e8 01             	sub    $0x1,%eax
  800678:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80067c:	75 f7                	jne    800675 <vprintfmt+0x435>
  80067e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800681:	e9 5a ff ff ff       	jmp    8005e0 <vprintfmt+0x3a0>
}
  800686:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800689:	5b                   	pop    %ebx
  80068a:	5e                   	pop    %esi
  80068b:	5f                   	pop    %edi
  80068c:	5d                   	pop    %ebp
  80068d:	c3                   	ret    

0080068e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	83 ec 18             	sub    $0x18,%esp
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80069a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80069d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006a1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006ab:	85 c0                	test   %eax,%eax
  8006ad:	74 26                	je     8006d5 <vsnprintf+0x47>
  8006af:	85 d2                	test   %edx,%edx
  8006b1:	7e 22                	jle    8006d5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006b3:	ff 75 14             	pushl  0x14(%ebp)
  8006b6:	ff 75 10             	pushl  0x10(%ebp)
  8006b9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006bc:	50                   	push   %eax
  8006bd:	68 06 02 80 00       	push   $0x800206
  8006c2:	e8 79 fb ff ff       	call   800240 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006ca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d0:	83 c4 10             	add    $0x10,%esp
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    
		return -E_INVAL;
  8006d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006da:	eb f7                	jmp    8006d3 <vsnprintf+0x45>

008006dc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006dc:	55                   	push   %ebp
  8006dd:	89 e5                	mov    %esp,%ebp
  8006df:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006e2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006e5:	50                   	push   %eax
  8006e6:	ff 75 10             	pushl  0x10(%ebp)
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	ff 75 08             	pushl  0x8(%ebp)
  8006ef:	e8 9a ff ff ff       	call   80068e <vsnprintf>
	va_end(ap);

	return rc;
}
  8006f4:	c9                   	leave  
  8006f5:	c3                   	ret    

008006f6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8006fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800701:	eb 03                	jmp    800706 <strlen+0x10>
		n++;
  800703:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800706:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80070a:	75 f7                	jne    800703 <strlen+0xd>
	return n;
}
  80070c:	5d                   	pop    %ebp
  80070d:	c3                   	ret    

0080070e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80070e:	55                   	push   %ebp
  80070f:	89 e5                	mov    %esp,%ebp
  800711:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800714:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800717:	b8 00 00 00 00       	mov    $0x0,%eax
  80071c:	eb 03                	jmp    800721 <strnlen+0x13>
		n++;
  80071e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800721:	39 d0                	cmp    %edx,%eax
  800723:	74 06                	je     80072b <strnlen+0x1d>
  800725:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800729:	75 f3                	jne    80071e <strnlen+0x10>
	return n;
}
  80072b:	5d                   	pop    %ebp
  80072c:	c3                   	ret    

0080072d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
  800730:	53                   	push   %ebx
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800737:	89 c2                	mov    %eax,%edx
  800739:	83 c1 01             	add    $0x1,%ecx
  80073c:	83 c2 01             	add    $0x1,%edx
  80073f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800743:	88 5a ff             	mov    %bl,-0x1(%edx)
  800746:	84 db                	test   %bl,%bl
  800748:	75 ef                	jne    800739 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80074a:	5b                   	pop    %ebx
  80074b:	5d                   	pop    %ebp
  80074c:	c3                   	ret    

0080074d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	53                   	push   %ebx
  800751:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800754:	53                   	push   %ebx
  800755:	e8 9c ff ff ff       	call   8006f6 <strlen>
  80075a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	01 d8                	add    %ebx,%eax
  800762:	50                   	push   %eax
  800763:	e8 c5 ff ff ff       	call   80072d <strcpy>
	return dst;
}
  800768:	89 d8                	mov    %ebx,%eax
  80076a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80076d:	c9                   	leave  
  80076e:	c3                   	ret    

0080076f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	56                   	push   %esi
  800773:	53                   	push   %ebx
  800774:	8b 75 08             	mov    0x8(%ebp),%esi
  800777:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80077a:	89 f3                	mov    %esi,%ebx
  80077c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80077f:	89 f2                	mov    %esi,%edx
  800781:	eb 0f                	jmp    800792 <strncpy+0x23>
		*dst++ = *src;
  800783:	83 c2 01             	add    $0x1,%edx
  800786:	0f b6 01             	movzbl (%ecx),%eax
  800789:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80078c:	80 39 01             	cmpb   $0x1,(%ecx)
  80078f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800792:	39 da                	cmp    %ebx,%edx
  800794:	75 ed                	jne    800783 <strncpy+0x14>
	}
	return ret;
}
  800796:	89 f0                	mov    %esi,%eax
  800798:	5b                   	pop    %ebx
  800799:	5e                   	pop    %esi
  80079a:	5d                   	pop    %ebp
  80079b:	c3                   	ret    

0080079c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	56                   	push   %esi
  8007a0:	53                   	push   %ebx
  8007a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007aa:	89 f0                	mov    %esi,%eax
  8007ac:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007b0:	85 c9                	test   %ecx,%ecx
  8007b2:	75 0b                	jne    8007bf <strlcpy+0x23>
  8007b4:	eb 17                	jmp    8007cd <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007b6:	83 c2 01             	add    $0x1,%edx
  8007b9:	83 c0 01             	add    $0x1,%eax
  8007bc:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8007bf:	39 d8                	cmp    %ebx,%eax
  8007c1:	74 07                	je     8007ca <strlcpy+0x2e>
  8007c3:	0f b6 0a             	movzbl (%edx),%ecx
  8007c6:	84 c9                	test   %cl,%cl
  8007c8:	75 ec                	jne    8007b6 <strlcpy+0x1a>
		*dst = '\0';
  8007ca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007cd:	29 f0                	sub    %esi,%eax
}
  8007cf:	5b                   	pop    %ebx
  8007d0:	5e                   	pop    %esi
  8007d1:	5d                   	pop    %ebp
  8007d2:	c3                   	ret    

008007d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007dc:	eb 06                	jmp    8007e4 <strcmp+0x11>
		p++, q++;
  8007de:	83 c1 01             	add    $0x1,%ecx
  8007e1:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8007e4:	0f b6 01             	movzbl (%ecx),%eax
  8007e7:	84 c0                	test   %al,%al
  8007e9:	74 04                	je     8007ef <strcmp+0x1c>
  8007eb:	3a 02                	cmp    (%edx),%al
  8007ed:	74 ef                	je     8007de <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007ef:	0f b6 c0             	movzbl %al,%eax
  8007f2:	0f b6 12             	movzbl (%edx),%edx
  8007f5:	29 d0                	sub    %edx,%eax
}
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    

008007f9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	53                   	push   %ebx
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 55 0c             	mov    0xc(%ebp),%edx
  800803:	89 c3                	mov    %eax,%ebx
  800805:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800808:	eb 06                	jmp    800810 <strncmp+0x17>
		n--, p++, q++;
  80080a:	83 c0 01             	add    $0x1,%eax
  80080d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800810:	39 d8                	cmp    %ebx,%eax
  800812:	74 16                	je     80082a <strncmp+0x31>
  800814:	0f b6 08             	movzbl (%eax),%ecx
  800817:	84 c9                	test   %cl,%cl
  800819:	74 04                	je     80081f <strncmp+0x26>
  80081b:	3a 0a                	cmp    (%edx),%cl
  80081d:	74 eb                	je     80080a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80081f:	0f b6 00             	movzbl (%eax),%eax
  800822:	0f b6 12             	movzbl (%edx),%edx
  800825:	29 d0                	sub    %edx,%eax
}
  800827:	5b                   	pop    %ebx
  800828:	5d                   	pop    %ebp
  800829:	c3                   	ret    
		return 0;
  80082a:	b8 00 00 00 00       	mov    $0x0,%eax
  80082f:	eb f6                	jmp    800827 <strncmp+0x2e>

00800831 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80083b:	0f b6 10             	movzbl (%eax),%edx
  80083e:	84 d2                	test   %dl,%dl
  800840:	74 09                	je     80084b <strchr+0x1a>
		if (*s == c)
  800842:	38 ca                	cmp    %cl,%dl
  800844:	74 0a                	je     800850 <strchr+0x1f>
	for (; *s; s++)
  800846:	83 c0 01             	add    $0x1,%eax
  800849:	eb f0                	jmp    80083b <strchr+0xa>
			return (char *) s;
	return 0;
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80085c:	eb 03                	jmp    800861 <strfind+0xf>
  80085e:	83 c0 01             	add    $0x1,%eax
  800861:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800864:	38 ca                	cmp    %cl,%dl
  800866:	74 04                	je     80086c <strfind+0x1a>
  800868:	84 d2                	test   %dl,%dl
  80086a:	75 f2                	jne    80085e <strfind+0xc>
			break;
	return (char *) s;
}
  80086c:	5d                   	pop    %ebp
  80086d:	c3                   	ret    

0080086e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	57                   	push   %edi
  800872:	56                   	push   %esi
  800873:	53                   	push   %ebx
  800874:	8b 7d 08             	mov    0x8(%ebp),%edi
  800877:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80087a:	85 c9                	test   %ecx,%ecx
  80087c:	74 13                	je     800891 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80087e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800884:	75 05                	jne    80088b <memset+0x1d>
  800886:	f6 c1 03             	test   $0x3,%cl
  800889:	74 0d                	je     800898 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80088b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088e:	fc                   	cld    
  80088f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800891:	89 f8                	mov    %edi,%eax
  800893:	5b                   	pop    %ebx
  800894:	5e                   	pop    %esi
  800895:	5f                   	pop    %edi
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    
		c &= 0xFF;
  800898:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80089c:	89 d3                	mov    %edx,%ebx
  80089e:	c1 e3 08             	shl    $0x8,%ebx
  8008a1:	89 d0                	mov    %edx,%eax
  8008a3:	c1 e0 18             	shl    $0x18,%eax
  8008a6:	89 d6                	mov    %edx,%esi
  8008a8:	c1 e6 10             	shl    $0x10,%esi
  8008ab:	09 f0                	or     %esi,%eax
  8008ad:	09 c2                	or     %eax,%edx
  8008af:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008b1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008b4:	89 d0                	mov    %edx,%eax
  8008b6:	fc                   	cld    
  8008b7:	f3 ab                	rep stos %eax,%es:(%edi)
  8008b9:	eb d6                	jmp    800891 <memset+0x23>

008008bb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	57                   	push   %edi
  8008bf:	56                   	push   %esi
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008c9:	39 c6                	cmp    %eax,%esi
  8008cb:	73 35                	jae    800902 <memmove+0x47>
  8008cd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008d0:	39 c2                	cmp    %eax,%edx
  8008d2:	76 2e                	jbe    800902 <memmove+0x47>
		s += n;
		d += n;
  8008d4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008d7:	89 d6                	mov    %edx,%esi
  8008d9:	09 fe                	or     %edi,%esi
  8008db:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008e1:	74 0c                	je     8008ef <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8008e3:	83 ef 01             	sub    $0x1,%edi
  8008e6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8008e9:	fd                   	std    
  8008ea:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008ec:	fc                   	cld    
  8008ed:	eb 21                	jmp    800910 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008ef:	f6 c1 03             	test   $0x3,%cl
  8008f2:	75 ef                	jne    8008e3 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8008f4:	83 ef 04             	sub    $0x4,%edi
  8008f7:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008fa:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8008fd:	fd                   	std    
  8008fe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800900:	eb ea                	jmp    8008ec <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800902:	89 f2                	mov    %esi,%edx
  800904:	09 c2                	or     %eax,%edx
  800906:	f6 c2 03             	test   $0x3,%dl
  800909:	74 09                	je     800914 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80090b:	89 c7                	mov    %eax,%edi
  80090d:	fc                   	cld    
  80090e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800910:	5e                   	pop    %esi
  800911:	5f                   	pop    %edi
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800914:	f6 c1 03             	test   $0x3,%cl
  800917:	75 f2                	jne    80090b <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800919:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80091c:	89 c7                	mov    %eax,%edi
  80091e:	fc                   	cld    
  80091f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800921:	eb ed                	jmp    800910 <memmove+0x55>

00800923 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800926:	ff 75 10             	pushl  0x10(%ebp)
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	ff 75 08             	pushl  0x8(%ebp)
  80092f:	e8 87 ff ff ff       	call   8008bb <memmove>
}
  800934:	c9                   	leave  
  800935:	c3                   	ret    

00800936 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	56                   	push   %esi
  80093a:	53                   	push   %ebx
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800941:	89 c6                	mov    %eax,%esi
  800943:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800946:	39 f0                	cmp    %esi,%eax
  800948:	74 1c                	je     800966 <memcmp+0x30>
		if (*s1 != *s2)
  80094a:	0f b6 08             	movzbl (%eax),%ecx
  80094d:	0f b6 1a             	movzbl (%edx),%ebx
  800950:	38 d9                	cmp    %bl,%cl
  800952:	75 08                	jne    80095c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800954:	83 c0 01             	add    $0x1,%eax
  800957:	83 c2 01             	add    $0x1,%edx
  80095a:	eb ea                	jmp    800946 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80095c:	0f b6 c1             	movzbl %cl,%eax
  80095f:	0f b6 db             	movzbl %bl,%ebx
  800962:	29 d8                	sub    %ebx,%eax
  800964:	eb 05                	jmp    80096b <memcmp+0x35>
	}

	return 0;
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096b:	5b                   	pop    %ebx
  80096c:	5e                   	pop    %esi
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800978:	89 c2                	mov    %eax,%edx
  80097a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80097d:	39 d0                	cmp    %edx,%eax
  80097f:	73 09                	jae    80098a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800981:	38 08                	cmp    %cl,(%eax)
  800983:	74 05                	je     80098a <memfind+0x1b>
	for (; s < ends; s++)
  800985:	83 c0 01             	add    $0x1,%eax
  800988:	eb f3                	jmp    80097d <memfind+0xe>
			break;
	return (void *) s;
}
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	57                   	push   %edi
  800990:	56                   	push   %esi
  800991:	53                   	push   %ebx
  800992:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800995:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800998:	eb 03                	jmp    80099d <strtol+0x11>
		s++;
  80099a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80099d:	0f b6 01             	movzbl (%ecx),%eax
  8009a0:	3c 20                	cmp    $0x20,%al
  8009a2:	74 f6                	je     80099a <strtol+0xe>
  8009a4:	3c 09                	cmp    $0x9,%al
  8009a6:	74 f2                	je     80099a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009a8:	3c 2b                	cmp    $0x2b,%al
  8009aa:	74 2e                	je     8009da <strtol+0x4e>
	int neg = 0;
  8009ac:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009b1:	3c 2d                	cmp    $0x2d,%al
  8009b3:	74 2f                	je     8009e4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009b5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009bb:	75 05                	jne    8009c2 <strtol+0x36>
  8009bd:	80 39 30             	cmpb   $0x30,(%ecx)
  8009c0:	74 2c                	je     8009ee <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009c2:	85 db                	test   %ebx,%ebx
  8009c4:	75 0a                	jne    8009d0 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009c6:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8009cb:	80 39 30             	cmpb   $0x30,(%ecx)
  8009ce:	74 28                	je     8009f8 <strtol+0x6c>
		base = 10;
  8009d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009d8:	eb 50                	jmp    800a2a <strtol+0x9e>
		s++;
  8009da:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8009e2:	eb d1                	jmp    8009b5 <strtol+0x29>
		s++, neg = 1;
  8009e4:	83 c1 01             	add    $0x1,%ecx
  8009e7:	bf 01 00 00 00       	mov    $0x1,%edi
  8009ec:	eb c7                	jmp    8009b5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009ee:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009f2:	74 0e                	je     800a02 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8009f4:	85 db                	test   %ebx,%ebx
  8009f6:	75 d8                	jne    8009d0 <strtol+0x44>
		s++, base = 8;
  8009f8:	83 c1 01             	add    $0x1,%ecx
  8009fb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a00:	eb ce                	jmp    8009d0 <strtol+0x44>
		s += 2, base = 16;
  800a02:	83 c1 02             	add    $0x2,%ecx
  800a05:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a0a:	eb c4                	jmp    8009d0 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a0c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a0f:	89 f3                	mov    %esi,%ebx
  800a11:	80 fb 19             	cmp    $0x19,%bl
  800a14:	77 29                	ja     800a3f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a16:	0f be d2             	movsbl %dl,%edx
  800a19:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a1c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a1f:	7d 30                	jge    800a51 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a21:	83 c1 01             	add    $0x1,%ecx
  800a24:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a28:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a2a:	0f b6 11             	movzbl (%ecx),%edx
  800a2d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a30:	89 f3                	mov    %esi,%ebx
  800a32:	80 fb 09             	cmp    $0x9,%bl
  800a35:	77 d5                	ja     800a0c <strtol+0x80>
			dig = *s - '0';
  800a37:	0f be d2             	movsbl %dl,%edx
  800a3a:	83 ea 30             	sub    $0x30,%edx
  800a3d:	eb dd                	jmp    800a1c <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a3f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a42:	89 f3                	mov    %esi,%ebx
  800a44:	80 fb 19             	cmp    $0x19,%bl
  800a47:	77 08                	ja     800a51 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a49:	0f be d2             	movsbl %dl,%edx
  800a4c:	83 ea 37             	sub    $0x37,%edx
  800a4f:	eb cb                	jmp    800a1c <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a55:	74 05                	je     800a5c <strtol+0xd0>
		*endptr = (char *) s;
  800a57:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a5a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a5c:	89 c2                	mov    %eax,%edx
  800a5e:	f7 da                	neg    %edx
  800a60:	85 ff                	test   %edi,%edi
  800a62:	0f 45 c2             	cmovne %edx,%eax
}
  800a65:	5b                   	pop    %ebx
  800a66:	5e                   	pop    %esi
  800a67:	5f                   	pop    %edi
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	57                   	push   %edi
  800a6e:	56                   	push   %esi
  800a6f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
  800a75:	8b 55 08             	mov    0x8(%ebp),%edx
  800a78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a7b:	89 c3                	mov    %eax,%ebx
  800a7d:	89 c7                	mov    %eax,%edi
  800a7f:	89 c6                	mov    %eax,%esi
  800a81:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800a83:	5b                   	pop    %ebx
  800a84:	5e                   	pop    %esi
  800a85:	5f                   	pop    %edi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	57                   	push   %edi
  800a8c:	56                   	push   %esi
  800a8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a93:	b8 01 00 00 00       	mov    $0x1,%eax
  800a98:	89 d1                	mov    %edx,%ecx
  800a9a:	89 d3                	mov    %edx,%ebx
  800a9c:	89 d7                	mov    %edx,%edi
  800a9e:	89 d6                	mov    %edx,%esi
  800aa0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800aa2:	5b                   	pop    %ebx
  800aa3:	5e                   	pop    %esi
  800aa4:	5f                   	pop    %edi
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	57                   	push   %edi
  800aab:	56                   	push   %esi
  800aac:	53                   	push   %ebx
  800aad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ab0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ab5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ab8:	b8 03 00 00 00       	mov    $0x3,%eax
  800abd:	89 cb                	mov    %ecx,%ebx
  800abf:	89 cf                	mov    %ecx,%edi
  800ac1:	89 ce                	mov    %ecx,%esi
  800ac3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ac5:	85 c0                	test   %eax,%eax
  800ac7:	7f 08                	jg     800ad1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ac9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800acc:	5b                   	pop    %ebx
  800acd:	5e                   	pop    %esi
  800ace:	5f                   	pop    %edi
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ad1:	83 ec 0c             	sub    $0xc,%esp
  800ad4:	50                   	push   %eax
  800ad5:	6a 03                	push   $0x3
  800ad7:	68 1f 20 80 00       	push   $0x80201f
  800adc:	6a 23                	push   $0x23
  800ade:	68 3c 20 80 00       	push   $0x80203c
  800ae3:	e8 ea 0e 00 00       	call   8019d2 <_panic>

00800ae8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	57                   	push   %edi
  800aec:	56                   	push   %esi
  800aed:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aee:	ba 00 00 00 00       	mov    $0x0,%edx
  800af3:	b8 02 00 00 00       	mov    $0x2,%eax
  800af8:	89 d1                	mov    %edx,%ecx
  800afa:	89 d3                	mov    %edx,%ebx
  800afc:	89 d7                	mov    %edx,%edi
  800afe:	89 d6                	mov    %edx,%esi
  800b00:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b02:	5b                   	pop    %ebx
  800b03:	5e                   	pop    %esi
  800b04:	5f                   	pop    %edi
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <sys_yield>:

void
sys_yield(void)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	57                   	push   %edi
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b12:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b17:	89 d1                	mov    %edx,%ecx
  800b19:	89 d3                	mov    %edx,%ebx
  800b1b:	89 d7                	mov    %edx,%edi
  800b1d:	89 d6                	mov    %edx,%esi
  800b1f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5f                   	pop    %edi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	57                   	push   %edi
  800b2a:	56                   	push   %esi
  800b2b:	53                   	push   %ebx
  800b2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b2f:	be 00 00 00 00       	mov    $0x0,%esi
  800b34:	8b 55 08             	mov    0x8(%ebp),%edx
  800b37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3a:	b8 04 00 00 00       	mov    $0x4,%eax
  800b3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b42:	89 f7                	mov    %esi,%edi
  800b44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b46:	85 c0                	test   %eax,%eax
  800b48:	7f 08                	jg     800b52 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b4d:	5b                   	pop    %ebx
  800b4e:	5e                   	pop    %esi
  800b4f:	5f                   	pop    %edi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b52:	83 ec 0c             	sub    $0xc,%esp
  800b55:	50                   	push   %eax
  800b56:	6a 04                	push   $0x4
  800b58:	68 1f 20 80 00       	push   $0x80201f
  800b5d:	6a 23                	push   $0x23
  800b5f:	68 3c 20 80 00       	push   $0x80203c
  800b64:	e8 69 0e 00 00       	call   8019d2 <_panic>

00800b69 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	57                   	push   %edi
  800b6d:	56                   	push   %esi
  800b6e:	53                   	push   %ebx
  800b6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b72:	8b 55 08             	mov    0x8(%ebp),%edx
  800b75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b78:	b8 05 00 00 00       	mov    $0x5,%eax
  800b7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b80:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b83:	8b 75 18             	mov    0x18(%ebp),%esi
  800b86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b88:	85 c0                	test   %eax,%eax
  800b8a:	7f 08                	jg     800b94 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b94:	83 ec 0c             	sub    $0xc,%esp
  800b97:	50                   	push   %eax
  800b98:	6a 05                	push   $0x5
  800b9a:	68 1f 20 80 00       	push   $0x80201f
  800b9f:	6a 23                	push   $0x23
  800ba1:	68 3c 20 80 00       	push   $0x80203c
  800ba6:	e8 27 0e 00 00       	call   8019d2 <_panic>

00800bab <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	57                   	push   %edi
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbf:	b8 06 00 00 00       	mov    $0x6,%eax
  800bc4:	89 df                	mov    %ebx,%edi
  800bc6:	89 de                	mov    %ebx,%esi
  800bc8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bca:	85 c0                	test   %eax,%eax
  800bcc:	7f 08                	jg     800bd6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5f                   	pop    %edi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd6:	83 ec 0c             	sub    $0xc,%esp
  800bd9:	50                   	push   %eax
  800bda:	6a 06                	push   $0x6
  800bdc:	68 1f 20 80 00       	push   $0x80201f
  800be1:	6a 23                	push   $0x23
  800be3:	68 3c 20 80 00       	push   $0x80203c
  800be8:	e8 e5 0d 00 00       	call   8019d2 <_panic>

00800bed <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	57                   	push   %edi
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
  800bf3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c01:	b8 08 00 00 00       	mov    $0x8,%eax
  800c06:	89 df                	mov    %ebx,%edi
  800c08:	89 de                	mov    %ebx,%esi
  800c0a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0c:	85 c0                	test   %eax,%eax
  800c0e:	7f 08                	jg     800c18 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c13:	5b                   	pop    %ebx
  800c14:	5e                   	pop    %esi
  800c15:	5f                   	pop    %edi
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c18:	83 ec 0c             	sub    $0xc,%esp
  800c1b:	50                   	push   %eax
  800c1c:	6a 08                	push   $0x8
  800c1e:	68 1f 20 80 00       	push   $0x80201f
  800c23:	6a 23                	push   $0x23
  800c25:	68 3c 20 80 00       	push   $0x80203c
  800c2a:	e8 a3 0d 00 00       	call   8019d2 <_panic>

00800c2f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	57                   	push   %edi
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
  800c35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c43:	b8 09 00 00 00       	mov    $0x9,%eax
  800c48:	89 df                	mov    %ebx,%edi
  800c4a:	89 de                	mov    %ebx,%esi
  800c4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4e:	85 c0                	test   %eax,%eax
  800c50:	7f 08                	jg     800c5a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c55:	5b                   	pop    %ebx
  800c56:	5e                   	pop    %esi
  800c57:	5f                   	pop    %edi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5a:	83 ec 0c             	sub    $0xc,%esp
  800c5d:	50                   	push   %eax
  800c5e:	6a 09                	push   $0x9
  800c60:	68 1f 20 80 00       	push   $0x80201f
  800c65:	6a 23                	push   $0x23
  800c67:	68 3c 20 80 00       	push   $0x80203c
  800c6c:	e8 61 0d 00 00       	call   8019d2 <_panic>

00800c71 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	53                   	push   %ebx
  800c77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c85:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c8a:	89 df                	mov    %ebx,%edi
  800c8c:	89 de                	mov    %ebx,%esi
  800c8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c90:	85 c0                	test   %eax,%eax
  800c92:	7f 08                	jg     800c9c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9c:	83 ec 0c             	sub    $0xc,%esp
  800c9f:	50                   	push   %eax
  800ca0:	6a 0a                	push   $0xa
  800ca2:	68 1f 20 80 00       	push   $0x80201f
  800ca7:	6a 23                	push   $0x23
  800ca9:	68 3c 20 80 00       	push   $0x80203c
  800cae:	e8 1f 0d 00 00       	call   8019d2 <_panic>

00800cb3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	57                   	push   %edi
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cc4:	be 00 00 00 00       	mov    $0x0,%esi
  800cc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ccf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	57                   	push   %edi
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
  800cdc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cec:	89 cb                	mov    %ecx,%ebx
  800cee:	89 cf                	mov    %ecx,%edi
  800cf0:	89 ce                	mov    %ecx,%esi
  800cf2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	7f 08                	jg     800d00 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	83 ec 0c             	sub    $0xc,%esp
  800d03:	50                   	push   %eax
  800d04:	6a 0d                	push   $0xd
  800d06:	68 1f 20 80 00       	push   $0x80201f
  800d0b:	6a 23                	push   $0x23
  800d0d:	68 3c 20 80 00       	push   $0x80203c
  800d12:	e8 bb 0c 00 00       	call   8019d2 <_panic>

00800d17 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	05 00 00 00 30       	add    $0x30000000,%eax
  800d22:	c1 e8 0c             	shr    $0xc,%eax
}
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d37:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    

00800d3e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d44:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d49:	89 c2                	mov    %eax,%edx
  800d4b:	c1 ea 16             	shr    $0x16,%edx
  800d4e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d55:	f6 c2 01             	test   $0x1,%dl
  800d58:	74 2a                	je     800d84 <fd_alloc+0x46>
  800d5a:	89 c2                	mov    %eax,%edx
  800d5c:	c1 ea 0c             	shr    $0xc,%edx
  800d5f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d66:	f6 c2 01             	test   $0x1,%dl
  800d69:	74 19                	je     800d84 <fd_alloc+0x46>
  800d6b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800d70:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d75:	75 d2                	jne    800d49 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d77:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800d7d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800d82:	eb 07                	jmp    800d8b <fd_alloc+0x4d>
			*fd_store = fd;
  800d84:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800d93:	83 f8 1f             	cmp    $0x1f,%eax
  800d96:	77 36                	ja     800dce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800d98:	c1 e0 0c             	shl    $0xc,%eax
  800d9b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800da0:	89 c2                	mov    %eax,%edx
  800da2:	c1 ea 16             	shr    $0x16,%edx
  800da5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dac:	f6 c2 01             	test   $0x1,%dl
  800daf:	74 24                	je     800dd5 <fd_lookup+0x48>
  800db1:	89 c2                	mov    %eax,%edx
  800db3:	c1 ea 0c             	shr    $0xc,%edx
  800db6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dbd:	f6 c2 01             	test   $0x1,%dl
  800dc0:	74 1a                	je     800ddc <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800dc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc5:	89 02                	mov    %eax,(%edx)
	return 0;
  800dc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    
		return -E_INVAL;
  800dce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dd3:	eb f7                	jmp    800dcc <fd_lookup+0x3f>
		return -E_INVAL;
  800dd5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dda:	eb f0                	jmp    800dcc <fd_lookup+0x3f>
  800ddc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800de1:	eb e9                	jmp    800dcc <fd_lookup+0x3f>

00800de3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 08             	sub    $0x8,%esp
  800de9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dec:	ba c8 20 80 00       	mov    $0x8020c8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800df1:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800df6:	39 08                	cmp    %ecx,(%eax)
  800df8:	74 33                	je     800e2d <dev_lookup+0x4a>
  800dfa:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800dfd:	8b 02                	mov    (%edx),%eax
  800dff:	85 c0                	test   %eax,%eax
  800e01:	75 f3                	jne    800df6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e03:	a1 04 40 80 00       	mov    0x804004,%eax
  800e08:	8b 40 48             	mov    0x48(%eax),%eax
  800e0b:	83 ec 04             	sub    $0x4,%esp
  800e0e:	51                   	push   %ecx
  800e0f:	50                   	push   %eax
  800e10:	68 4c 20 80 00       	push   $0x80204c
  800e15:	e8 29 f3 ff ff       	call   800143 <cprintf>
	*dev = 0;
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e23:	83 c4 10             	add    $0x10,%esp
  800e26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    
			*dev = devtab[i];
  800e2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e30:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e32:	b8 00 00 00 00       	mov    $0x0,%eax
  800e37:	eb f2                	jmp    800e2b <dev_lookup+0x48>

00800e39 <fd_close>:
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	57                   	push   %edi
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
  800e3f:	83 ec 1c             	sub    $0x1c,%esp
  800e42:	8b 75 08             	mov    0x8(%ebp),%esi
  800e45:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e48:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e4b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e4c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800e52:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e55:	50                   	push   %eax
  800e56:	e8 32 ff ff ff       	call   800d8d <fd_lookup>
  800e5b:	89 c3                	mov    %eax,%ebx
  800e5d:	83 c4 08             	add    $0x8,%esp
  800e60:	85 c0                	test   %eax,%eax
  800e62:	78 05                	js     800e69 <fd_close+0x30>
	    || fd != fd2)
  800e64:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800e67:	74 16                	je     800e7f <fd_close+0x46>
		return (must_exist ? r : 0);
  800e69:	89 f8                	mov    %edi,%eax
  800e6b:	84 c0                	test   %al,%al
  800e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e72:	0f 44 d8             	cmove  %eax,%ebx
}
  800e75:	89 d8                	mov    %ebx,%eax
  800e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800e85:	50                   	push   %eax
  800e86:	ff 36                	pushl  (%esi)
  800e88:	e8 56 ff ff ff       	call   800de3 <dev_lookup>
  800e8d:	89 c3                	mov    %eax,%ebx
  800e8f:	83 c4 10             	add    $0x10,%esp
  800e92:	85 c0                	test   %eax,%eax
  800e94:	78 15                	js     800eab <fd_close+0x72>
		if (dev->dev_close)
  800e96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e99:	8b 40 10             	mov    0x10(%eax),%eax
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	74 1b                	je     800ebb <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800ea0:	83 ec 0c             	sub    $0xc,%esp
  800ea3:	56                   	push   %esi
  800ea4:	ff d0                	call   *%eax
  800ea6:	89 c3                	mov    %eax,%ebx
  800ea8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800eab:	83 ec 08             	sub    $0x8,%esp
  800eae:	56                   	push   %esi
  800eaf:	6a 00                	push   $0x0
  800eb1:	e8 f5 fc ff ff       	call   800bab <sys_page_unmap>
	return r;
  800eb6:	83 c4 10             	add    $0x10,%esp
  800eb9:	eb ba                	jmp    800e75 <fd_close+0x3c>
			r = 0;
  800ebb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec0:	eb e9                	jmp    800eab <fd_close+0x72>

00800ec2 <close>:

int
close(int fdnum)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ec8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ecb:	50                   	push   %eax
  800ecc:	ff 75 08             	pushl  0x8(%ebp)
  800ecf:	e8 b9 fe ff ff       	call   800d8d <fd_lookup>
  800ed4:	83 c4 08             	add    $0x8,%esp
  800ed7:	85 c0                	test   %eax,%eax
  800ed9:	78 10                	js     800eeb <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800edb:	83 ec 08             	sub    $0x8,%esp
  800ede:	6a 01                	push   $0x1
  800ee0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee3:	e8 51 ff ff ff       	call   800e39 <fd_close>
  800ee8:	83 c4 10             	add    $0x10,%esp
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <close_all>:

void
close_all(void)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	53                   	push   %ebx
  800ef1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800ef4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800ef9:	83 ec 0c             	sub    $0xc,%esp
  800efc:	53                   	push   %ebx
  800efd:	e8 c0 ff ff ff       	call   800ec2 <close>
	for (i = 0; i < MAXFD; i++)
  800f02:	83 c3 01             	add    $0x1,%ebx
  800f05:	83 c4 10             	add    $0x10,%esp
  800f08:	83 fb 20             	cmp    $0x20,%ebx
  800f0b:	75 ec                	jne    800ef9 <close_all+0xc>
}
  800f0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
  800f18:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f1b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f1e:	50                   	push   %eax
  800f1f:	ff 75 08             	pushl  0x8(%ebp)
  800f22:	e8 66 fe ff ff       	call   800d8d <fd_lookup>
  800f27:	89 c3                	mov    %eax,%ebx
  800f29:	83 c4 08             	add    $0x8,%esp
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	0f 88 81 00 00 00    	js     800fb5 <dup+0xa3>
		return r;
	close(newfdnum);
  800f34:	83 ec 0c             	sub    $0xc,%esp
  800f37:	ff 75 0c             	pushl  0xc(%ebp)
  800f3a:	e8 83 ff ff ff       	call   800ec2 <close>

	newfd = INDEX2FD(newfdnum);
  800f3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f42:	c1 e6 0c             	shl    $0xc,%esi
  800f45:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f4b:	83 c4 04             	add    $0x4,%esp
  800f4e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f51:	e8 d1 fd ff ff       	call   800d27 <fd2data>
  800f56:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f58:	89 34 24             	mov    %esi,(%esp)
  800f5b:	e8 c7 fd ff ff       	call   800d27 <fd2data>
  800f60:	83 c4 10             	add    $0x10,%esp
  800f63:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f65:	89 d8                	mov    %ebx,%eax
  800f67:	c1 e8 16             	shr    $0x16,%eax
  800f6a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f71:	a8 01                	test   $0x1,%al
  800f73:	74 11                	je     800f86 <dup+0x74>
  800f75:	89 d8                	mov    %ebx,%eax
  800f77:	c1 e8 0c             	shr    $0xc,%eax
  800f7a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f81:	f6 c2 01             	test   $0x1,%dl
  800f84:	75 39                	jne    800fbf <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f89:	89 d0                	mov    %edx,%eax
  800f8b:	c1 e8 0c             	shr    $0xc,%eax
  800f8e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f95:	83 ec 0c             	sub    $0xc,%esp
  800f98:	25 07 0e 00 00       	and    $0xe07,%eax
  800f9d:	50                   	push   %eax
  800f9e:	56                   	push   %esi
  800f9f:	6a 00                	push   $0x0
  800fa1:	52                   	push   %edx
  800fa2:	6a 00                	push   $0x0
  800fa4:	e8 c0 fb ff ff       	call   800b69 <sys_page_map>
  800fa9:	89 c3                	mov    %eax,%ebx
  800fab:	83 c4 20             	add    $0x20,%esp
  800fae:	85 c0                	test   %eax,%eax
  800fb0:	78 31                	js     800fe3 <dup+0xd1>
		goto err;

	return newfdnum;
  800fb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800fb5:	89 d8                	mov    %ebx,%eax
  800fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fba:	5b                   	pop    %ebx
  800fbb:	5e                   	pop    %esi
  800fbc:	5f                   	pop    %edi
  800fbd:	5d                   	pop    %ebp
  800fbe:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fbf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fc6:	83 ec 0c             	sub    $0xc,%esp
  800fc9:	25 07 0e 00 00       	and    $0xe07,%eax
  800fce:	50                   	push   %eax
  800fcf:	57                   	push   %edi
  800fd0:	6a 00                	push   $0x0
  800fd2:	53                   	push   %ebx
  800fd3:	6a 00                	push   $0x0
  800fd5:	e8 8f fb ff ff       	call   800b69 <sys_page_map>
  800fda:	89 c3                	mov    %eax,%ebx
  800fdc:	83 c4 20             	add    $0x20,%esp
  800fdf:	85 c0                	test   %eax,%eax
  800fe1:	79 a3                	jns    800f86 <dup+0x74>
	sys_page_unmap(0, newfd);
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	56                   	push   %esi
  800fe7:	6a 00                	push   $0x0
  800fe9:	e8 bd fb ff ff       	call   800bab <sys_page_unmap>
	sys_page_unmap(0, nva);
  800fee:	83 c4 08             	add    $0x8,%esp
  800ff1:	57                   	push   %edi
  800ff2:	6a 00                	push   $0x0
  800ff4:	e8 b2 fb ff ff       	call   800bab <sys_page_unmap>
	return r;
  800ff9:	83 c4 10             	add    $0x10,%esp
  800ffc:	eb b7                	jmp    800fb5 <dup+0xa3>

00800ffe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	53                   	push   %ebx
  801002:	83 ec 14             	sub    $0x14,%esp
  801005:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801008:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80100b:	50                   	push   %eax
  80100c:	53                   	push   %ebx
  80100d:	e8 7b fd ff ff       	call   800d8d <fd_lookup>
  801012:	83 c4 08             	add    $0x8,%esp
  801015:	85 c0                	test   %eax,%eax
  801017:	78 3f                	js     801058 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801019:	83 ec 08             	sub    $0x8,%esp
  80101c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80101f:	50                   	push   %eax
  801020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801023:	ff 30                	pushl  (%eax)
  801025:	e8 b9 fd ff ff       	call   800de3 <dev_lookup>
  80102a:	83 c4 10             	add    $0x10,%esp
  80102d:	85 c0                	test   %eax,%eax
  80102f:	78 27                	js     801058 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801031:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801034:	8b 42 08             	mov    0x8(%edx),%eax
  801037:	83 e0 03             	and    $0x3,%eax
  80103a:	83 f8 01             	cmp    $0x1,%eax
  80103d:	74 1e                	je     80105d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80103f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801042:	8b 40 08             	mov    0x8(%eax),%eax
  801045:	85 c0                	test   %eax,%eax
  801047:	74 35                	je     80107e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801049:	83 ec 04             	sub    $0x4,%esp
  80104c:	ff 75 10             	pushl  0x10(%ebp)
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	52                   	push   %edx
  801053:	ff d0                	call   *%eax
  801055:	83 c4 10             	add    $0x10,%esp
}
  801058:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80105d:	a1 04 40 80 00       	mov    0x804004,%eax
  801062:	8b 40 48             	mov    0x48(%eax),%eax
  801065:	83 ec 04             	sub    $0x4,%esp
  801068:	53                   	push   %ebx
  801069:	50                   	push   %eax
  80106a:	68 8d 20 80 00       	push   $0x80208d
  80106f:	e8 cf f0 ff ff       	call   800143 <cprintf>
		return -E_INVAL;
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107c:	eb da                	jmp    801058 <read+0x5a>
		return -E_NOT_SUPP;
  80107e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801083:	eb d3                	jmp    801058 <read+0x5a>

00801085 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	57                   	push   %edi
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
  80108b:	83 ec 0c             	sub    $0xc,%esp
  80108e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801091:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801094:	bb 00 00 00 00       	mov    $0x0,%ebx
  801099:	39 f3                	cmp    %esi,%ebx
  80109b:	73 25                	jae    8010c2 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	89 f0                	mov    %esi,%eax
  8010a2:	29 d8                	sub    %ebx,%eax
  8010a4:	50                   	push   %eax
  8010a5:	89 d8                	mov    %ebx,%eax
  8010a7:	03 45 0c             	add    0xc(%ebp),%eax
  8010aa:	50                   	push   %eax
  8010ab:	57                   	push   %edi
  8010ac:	e8 4d ff ff ff       	call   800ffe <read>
		if (m < 0)
  8010b1:	83 c4 10             	add    $0x10,%esp
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	78 08                	js     8010c0 <readn+0x3b>
			return m;
		if (m == 0)
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	74 06                	je     8010c2 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8010bc:	01 c3                	add    %eax,%ebx
  8010be:	eb d9                	jmp    801099 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010c0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8010c2:	89 d8                	mov    %ebx,%eax
  8010c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c7:	5b                   	pop    %ebx
  8010c8:	5e                   	pop    %esi
  8010c9:	5f                   	pop    %edi
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    

008010cc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	53                   	push   %ebx
  8010d0:	83 ec 14             	sub    $0x14,%esp
  8010d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010d9:	50                   	push   %eax
  8010da:	53                   	push   %ebx
  8010db:	e8 ad fc ff ff       	call   800d8d <fd_lookup>
  8010e0:	83 c4 08             	add    $0x8,%esp
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	78 3a                	js     801121 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010e7:	83 ec 08             	sub    $0x8,%esp
  8010ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ed:	50                   	push   %eax
  8010ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f1:	ff 30                	pushl  (%eax)
  8010f3:	e8 eb fc ff ff       	call   800de3 <dev_lookup>
  8010f8:	83 c4 10             	add    $0x10,%esp
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	78 22                	js     801121 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8010ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801102:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801106:	74 1e                	je     801126 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110b:	8b 52 0c             	mov    0xc(%edx),%edx
  80110e:	85 d2                	test   %edx,%edx
  801110:	74 35                	je     801147 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801112:	83 ec 04             	sub    $0x4,%esp
  801115:	ff 75 10             	pushl  0x10(%ebp)
  801118:	ff 75 0c             	pushl  0xc(%ebp)
  80111b:	50                   	push   %eax
  80111c:	ff d2                	call   *%edx
  80111e:	83 c4 10             	add    $0x10,%esp
}
  801121:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801124:	c9                   	leave  
  801125:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801126:	a1 04 40 80 00       	mov    0x804004,%eax
  80112b:	8b 40 48             	mov    0x48(%eax),%eax
  80112e:	83 ec 04             	sub    $0x4,%esp
  801131:	53                   	push   %ebx
  801132:	50                   	push   %eax
  801133:	68 a9 20 80 00       	push   $0x8020a9
  801138:	e8 06 f0 ff ff       	call   800143 <cprintf>
		return -E_INVAL;
  80113d:	83 c4 10             	add    $0x10,%esp
  801140:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801145:	eb da                	jmp    801121 <write+0x55>
		return -E_NOT_SUPP;
  801147:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80114c:	eb d3                	jmp    801121 <write+0x55>

0080114e <seek>:

int
seek(int fdnum, off_t offset)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801154:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801157:	50                   	push   %eax
  801158:	ff 75 08             	pushl  0x8(%ebp)
  80115b:	e8 2d fc ff ff       	call   800d8d <fd_lookup>
  801160:	83 c4 08             	add    $0x8,%esp
  801163:	85 c0                	test   %eax,%eax
  801165:	78 0e                	js     801175 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801167:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801170:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	53                   	push   %ebx
  80117b:	83 ec 14             	sub    $0x14,%esp
  80117e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801181:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801184:	50                   	push   %eax
  801185:	53                   	push   %ebx
  801186:	e8 02 fc ff ff       	call   800d8d <fd_lookup>
  80118b:	83 c4 08             	add    $0x8,%esp
  80118e:	85 c0                	test   %eax,%eax
  801190:	78 37                	js     8011c9 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801192:	83 ec 08             	sub    $0x8,%esp
  801195:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801198:	50                   	push   %eax
  801199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80119c:	ff 30                	pushl  (%eax)
  80119e:	e8 40 fc ff ff       	call   800de3 <dev_lookup>
  8011a3:	83 c4 10             	add    $0x10,%esp
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	78 1f                	js     8011c9 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ad:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011b1:	74 1b                	je     8011ce <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8011b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b6:	8b 52 18             	mov    0x18(%edx),%edx
  8011b9:	85 d2                	test   %edx,%edx
  8011bb:	74 32                	je     8011ef <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8011bd:	83 ec 08             	sub    $0x8,%esp
  8011c0:	ff 75 0c             	pushl  0xc(%ebp)
  8011c3:	50                   	push   %eax
  8011c4:	ff d2                	call   *%edx
  8011c6:	83 c4 10             	add    $0x10,%esp
}
  8011c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    
			thisenv->env_id, fdnum);
  8011ce:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011d3:	8b 40 48             	mov    0x48(%eax),%eax
  8011d6:	83 ec 04             	sub    $0x4,%esp
  8011d9:	53                   	push   %ebx
  8011da:	50                   	push   %eax
  8011db:	68 6c 20 80 00       	push   $0x80206c
  8011e0:	e8 5e ef ff ff       	call   800143 <cprintf>
		return -E_INVAL;
  8011e5:	83 c4 10             	add    $0x10,%esp
  8011e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ed:	eb da                	jmp    8011c9 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8011ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011f4:	eb d3                	jmp    8011c9 <ftruncate+0x52>

008011f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	53                   	push   %ebx
  8011fa:	83 ec 14             	sub    $0x14,%esp
  8011fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801200:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801203:	50                   	push   %eax
  801204:	ff 75 08             	pushl  0x8(%ebp)
  801207:	e8 81 fb ff ff       	call   800d8d <fd_lookup>
  80120c:	83 c4 08             	add    $0x8,%esp
  80120f:	85 c0                	test   %eax,%eax
  801211:	78 4b                	js     80125e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801213:	83 ec 08             	sub    $0x8,%esp
  801216:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801219:	50                   	push   %eax
  80121a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80121d:	ff 30                	pushl  (%eax)
  80121f:	e8 bf fb ff ff       	call   800de3 <dev_lookup>
  801224:	83 c4 10             	add    $0x10,%esp
  801227:	85 c0                	test   %eax,%eax
  801229:	78 33                	js     80125e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80122b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801232:	74 2f                	je     801263 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801234:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801237:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80123e:	00 00 00 
	stat->st_isdir = 0;
  801241:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801248:	00 00 00 
	stat->st_dev = dev;
  80124b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801251:	83 ec 08             	sub    $0x8,%esp
  801254:	53                   	push   %ebx
  801255:	ff 75 f0             	pushl  -0x10(%ebp)
  801258:	ff 50 14             	call   *0x14(%eax)
  80125b:	83 c4 10             	add    $0x10,%esp
}
  80125e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801261:	c9                   	leave  
  801262:	c3                   	ret    
		return -E_NOT_SUPP;
  801263:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801268:	eb f4                	jmp    80125e <fstat+0x68>

0080126a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	56                   	push   %esi
  80126e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80126f:	83 ec 08             	sub    $0x8,%esp
  801272:	6a 00                	push   $0x0
  801274:	ff 75 08             	pushl  0x8(%ebp)
  801277:	e8 e7 01 00 00       	call   801463 <open>
  80127c:	89 c3                	mov    %eax,%ebx
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	78 1b                	js     8012a0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	ff 75 0c             	pushl  0xc(%ebp)
  80128b:	50                   	push   %eax
  80128c:	e8 65 ff ff ff       	call   8011f6 <fstat>
  801291:	89 c6                	mov    %eax,%esi
	close(fd);
  801293:	89 1c 24             	mov    %ebx,(%esp)
  801296:	e8 27 fc ff ff       	call   800ec2 <close>
	return r;
  80129b:	83 c4 10             	add    $0x10,%esp
  80129e:	89 f3                	mov    %esi,%ebx
}
  8012a0:	89 d8                	mov    %ebx,%eax
  8012a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012a5:	5b                   	pop    %ebx
  8012a6:	5e                   	pop    %esi
  8012a7:	5d                   	pop    %ebp
  8012a8:	c3                   	ret    

008012a9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	89 c6                	mov    %eax,%esi
  8012b0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8012b2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012b9:	74 27                	je     8012e2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012bb:	6a 07                	push   $0x7
  8012bd:	68 00 50 80 00       	push   $0x805000
  8012c2:	56                   	push   %esi
  8012c3:	ff 35 00 40 80 00    	pushl  0x804000
  8012c9:	e8 61 07 00 00       	call   801a2f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012ce:	83 c4 0c             	add    $0xc,%esp
  8012d1:	6a 00                	push   $0x0
  8012d3:	53                   	push   %ebx
  8012d4:	6a 00                	push   $0x0
  8012d6:	e8 3d 07 00 00       	call   801a18 <ipc_recv>
}
  8012db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012de:	5b                   	pop    %ebx
  8012df:	5e                   	pop    %esi
  8012e0:	5d                   	pop    %ebp
  8012e1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	6a 01                	push   $0x1
  8012e7:	e8 5a 07 00 00       	call   801a46 <ipc_find_env>
  8012ec:	a3 00 40 80 00       	mov    %eax,0x804000
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	eb c5                	jmp    8012bb <fsipc+0x12>

008012f6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8b 40 0c             	mov    0xc(%eax),%eax
  801302:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80130f:	ba 00 00 00 00       	mov    $0x0,%edx
  801314:	b8 02 00 00 00       	mov    $0x2,%eax
  801319:	e8 8b ff ff ff       	call   8012a9 <fsipc>
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <devfile_flush>:
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8b 40 0c             	mov    0xc(%eax),%eax
  80132c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801331:	ba 00 00 00 00       	mov    $0x0,%edx
  801336:	b8 06 00 00 00       	mov    $0x6,%eax
  80133b:	e8 69 ff ff ff       	call   8012a9 <fsipc>
}
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <devfile_stat>:
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	53                   	push   %ebx
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8b 40 0c             	mov    0xc(%eax),%eax
  801352:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801357:	ba 00 00 00 00       	mov    $0x0,%edx
  80135c:	b8 05 00 00 00       	mov    $0x5,%eax
  801361:	e8 43 ff ff ff       	call   8012a9 <fsipc>
  801366:	85 c0                	test   %eax,%eax
  801368:	78 2c                	js     801396 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80136a:	83 ec 08             	sub    $0x8,%esp
  80136d:	68 00 50 80 00       	push   $0x805000
  801372:	53                   	push   %ebx
  801373:	e8 b5 f3 ff ff       	call   80072d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801378:	a1 80 50 80 00       	mov    0x805080,%eax
  80137d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801383:	a1 84 50 80 00       	mov    0x805084,%eax
  801388:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80138e:	83 c4 10             	add    $0x10,%esp
  801391:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801396:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <devfile_write>:
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a4:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8013a9:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8013ae:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b4:	8b 52 0c             	mov    0xc(%edx),%edx
  8013b7:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8013bd:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8013c2:	50                   	push   %eax
  8013c3:	ff 75 0c             	pushl  0xc(%ebp)
  8013c6:	68 08 50 80 00       	push   $0x805008
  8013cb:	e8 eb f4 ff ff       	call   8008bb <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8013d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d5:	b8 04 00 00 00       	mov    $0x4,%eax
  8013da:	e8 ca fe ff ff       	call   8012a9 <fsipc>
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <devfile_read>:
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	56                   	push   %esi
  8013e5:	53                   	push   %ebx
  8013e6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8013ef:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8013f4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8013fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ff:	b8 03 00 00 00       	mov    $0x3,%eax
  801404:	e8 a0 fe ff ff       	call   8012a9 <fsipc>
  801409:	89 c3                	mov    %eax,%ebx
  80140b:	85 c0                	test   %eax,%eax
  80140d:	78 1f                	js     80142e <devfile_read+0x4d>
	assert(r <= n);
  80140f:	39 f0                	cmp    %esi,%eax
  801411:	77 24                	ja     801437 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801413:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801418:	7f 33                	jg     80144d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80141a:	83 ec 04             	sub    $0x4,%esp
  80141d:	50                   	push   %eax
  80141e:	68 00 50 80 00       	push   $0x805000
  801423:	ff 75 0c             	pushl  0xc(%ebp)
  801426:	e8 90 f4 ff ff       	call   8008bb <memmove>
	return r;
  80142b:	83 c4 10             	add    $0x10,%esp
}
  80142e:	89 d8                	mov    %ebx,%eax
  801430:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801433:	5b                   	pop    %ebx
  801434:	5e                   	pop    %esi
  801435:	5d                   	pop    %ebp
  801436:	c3                   	ret    
	assert(r <= n);
  801437:	68 d8 20 80 00       	push   $0x8020d8
  80143c:	68 df 20 80 00       	push   $0x8020df
  801441:	6a 7c                	push   $0x7c
  801443:	68 f4 20 80 00       	push   $0x8020f4
  801448:	e8 85 05 00 00       	call   8019d2 <_panic>
	assert(r <= PGSIZE);
  80144d:	68 ff 20 80 00       	push   $0x8020ff
  801452:	68 df 20 80 00       	push   $0x8020df
  801457:	6a 7d                	push   $0x7d
  801459:	68 f4 20 80 00       	push   $0x8020f4
  80145e:	e8 6f 05 00 00       	call   8019d2 <_panic>

00801463 <open>:
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	56                   	push   %esi
  801467:	53                   	push   %ebx
  801468:	83 ec 1c             	sub    $0x1c,%esp
  80146b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80146e:	56                   	push   %esi
  80146f:	e8 82 f2 ff ff       	call   8006f6 <strlen>
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80147c:	7f 6c                	jg     8014ea <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80147e:	83 ec 0c             	sub    $0xc,%esp
  801481:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801484:	50                   	push   %eax
  801485:	e8 b4 f8 ff ff       	call   800d3e <fd_alloc>
  80148a:	89 c3                	mov    %eax,%ebx
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	85 c0                	test   %eax,%eax
  801491:	78 3c                	js     8014cf <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801493:	83 ec 08             	sub    $0x8,%esp
  801496:	56                   	push   %esi
  801497:	68 00 50 80 00       	push   $0x805000
  80149c:	e8 8c f2 ff ff       	call   80072d <strcpy>
	fsipcbuf.open.req_omode = mode;
  8014a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8014a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8014b1:	e8 f3 fd ff ff       	call   8012a9 <fsipc>
  8014b6:	89 c3                	mov    %eax,%ebx
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	78 19                	js     8014d8 <open+0x75>
	return fd2num(fd);
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8014c5:	e8 4d f8 ff ff       	call   800d17 <fd2num>
  8014ca:	89 c3                	mov    %eax,%ebx
  8014cc:	83 c4 10             	add    $0x10,%esp
}
  8014cf:	89 d8                	mov    %ebx,%eax
  8014d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d4:	5b                   	pop    %ebx
  8014d5:	5e                   	pop    %esi
  8014d6:	5d                   	pop    %ebp
  8014d7:	c3                   	ret    
		fd_close(fd, 0);
  8014d8:	83 ec 08             	sub    $0x8,%esp
  8014db:	6a 00                	push   $0x0
  8014dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8014e0:	e8 54 f9 ff ff       	call   800e39 <fd_close>
		return r;
  8014e5:	83 c4 10             	add    $0x10,%esp
  8014e8:	eb e5                	jmp    8014cf <open+0x6c>
		return -E_BAD_PATH;
  8014ea:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8014ef:	eb de                	jmp    8014cf <open+0x6c>

008014f1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8014f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fc:	b8 08 00 00 00       	mov    $0x8,%eax
  801501:	e8 a3 fd ff ff       	call   8012a9 <fsipc>
}
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	56                   	push   %esi
  80150c:	53                   	push   %ebx
  80150d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801510:	83 ec 0c             	sub    $0xc,%esp
  801513:	ff 75 08             	pushl  0x8(%ebp)
  801516:	e8 0c f8 ff ff       	call   800d27 <fd2data>
  80151b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80151d:	83 c4 08             	add    $0x8,%esp
  801520:	68 0b 21 80 00       	push   $0x80210b
  801525:	53                   	push   %ebx
  801526:	e8 02 f2 ff ff       	call   80072d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80152b:	8b 46 04             	mov    0x4(%esi),%eax
  80152e:	2b 06                	sub    (%esi),%eax
  801530:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801536:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80153d:	00 00 00 
	stat->st_dev = &devpipe;
  801540:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801547:	30 80 00 
	return 0;
}
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
  80154f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801552:	5b                   	pop    %ebx
  801553:	5e                   	pop    %esi
  801554:	5d                   	pop    %ebp
  801555:	c3                   	ret    

00801556 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	53                   	push   %ebx
  80155a:	83 ec 0c             	sub    $0xc,%esp
  80155d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801560:	53                   	push   %ebx
  801561:	6a 00                	push   $0x0
  801563:	e8 43 f6 ff ff       	call   800bab <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801568:	89 1c 24             	mov    %ebx,(%esp)
  80156b:	e8 b7 f7 ff ff       	call   800d27 <fd2data>
  801570:	83 c4 08             	add    $0x8,%esp
  801573:	50                   	push   %eax
  801574:	6a 00                	push   $0x0
  801576:	e8 30 f6 ff ff       	call   800bab <sys_page_unmap>
}
  80157b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <_pipeisclosed>:
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	57                   	push   %edi
  801584:	56                   	push   %esi
  801585:	53                   	push   %ebx
  801586:	83 ec 1c             	sub    $0x1c,%esp
  801589:	89 c7                	mov    %eax,%edi
  80158b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80158d:	a1 04 40 80 00       	mov    0x804004,%eax
  801592:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801595:	83 ec 0c             	sub    $0xc,%esp
  801598:	57                   	push   %edi
  801599:	e8 e1 04 00 00       	call   801a7f <pageref>
  80159e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015a1:	89 34 24             	mov    %esi,(%esp)
  8015a4:	e8 d6 04 00 00       	call   801a7f <pageref>
		nn = thisenv->env_runs;
  8015a9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8015af:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	39 cb                	cmp    %ecx,%ebx
  8015b7:	74 1b                	je     8015d4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8015b9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015bc:	75 cf                	jne    80158d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8015be:	8b 42 58             	mov    0x58(%edx),%eax
  8015c1:	6a 01                	push   $0x1
  8015c3:	50                   	push   %eax
  8015c4:	53                   	push   %ebx
  8015c5:	68 12 21 80 00       	push   $0x802112
  8015ca:	e8 74 eb ff ff       	call   800143 <cprintf>
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	eb b9                	jmp    80158d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8015d4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015d7:	0f 94 c0             	sete   %al
  8015da:	0f b6 c0             	movzbl %al,%eax
}
  8015dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015e0:	5b                   	pop    %ebx
  8015e1:	5e                   	pop    %esi
  8015e2:	5f                   	pop    %edi
  8015e3:	5d                   	pop    %ebp
  8015e4:	c3                   	ret    

008015e5 <devpipe_write>:
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	57                   	push   %edi
  8015e9:	56                   	push   %esi
  8015ea:	53                   	push   %ebx
  8015eb:	83 ec 28             	sub    $0x28,%esp
  8015ee:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8015f1:	56                   	push   %esi
  8015f2:	e8 30 f7 ff ff       	call   800d27 <fd2data>
  8015f7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8015f9:	83 c4 10             	add    $0x10,%esp
  8015fc:	bf 00 00 00 00       	mov    $0x0,%edi
  801601:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801604:	74 4f                	je     801655 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801606:	8b 43 04             	mov    0x4(%ebx),%eax
  801609:	8b 0b                	mov    (%ebx),%ecx
  80160b:	8d 51 20             	lea    0x20(%ecx),%edx
  80160e:	39 d0                	cmp    %edx,%eax
  801610:	72 14                	jb     801626 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801612:	89 da                	mov    %ebx,%edx
  801614:	89 f0                	mov    %esi,%eax
  801616:	e8 65 ff ff ff       	call   801580 <_pipeisclosed>
  80161b:	85 c0                	test   %eax,%eax
  80161d:	75 3a                	jne    801659 <devpipe_write+0x74>
			sys_yield();
  80161f:	e8 e3 f4 ff ff       	call   800b07 <sys_yield>
  801624:	eb e0                	jmp    801606 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801626:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801629:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80162d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801630:	89 c2                	mov    %eax,%edx
  801632:	c1 fa 1f             	sar    $0x1f,%edx
  801635:	89 d1                	mov    %edx,%ecx
  801637:	c1 e9 1b             	shr    $0x1b,%ecx
  80163a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80163d:	83 e2 1f             	and    $0x1f,%edx
  801640:	29 ca                	sub    %ecx,%edx
  801642:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801646:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80164a:	83 c0 01             	add    $0x1,%eax
  80164d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801650:	83 c7 01             	add    $0x1,%edi
  801653:	eb ac                	jmp    801601 <devpipe_write+0x1c>
	return i;
  801655:	89 f8                	mov    %edi,%eax
  801657:	eb 05                	jmp    80165e <devpipe_write+0x79>
				return 0;
  801659:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801661:	5b                   	pop    %ebx
  801662:	5e                   	pop    %esi
  801663:	5f                   	pop    %edi
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    

00801666 <devpipe_read>:
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	57                   	push   %edi
  80166a:	56                   	push   %esi
  80166b:	53                   	push   %ebx
  80166c:	83 ec 18             	sub    $0x18,%esp
  80166f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801672:	57                   	push   %edi
  801673:	e8 af f6 ff ff       	call   800d27 <fd2data>
  801678:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	be 00 00 00 00       	mov    $0x0,%esi
  801682:	3b 75 10             	cmp    0x10(%ebp),%esi
  801685:	74 47                	je     8016ce <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801687:	8b 03                	mov    (%ebx),%eax
  801689:	3b 43 04             	cmp    0x4(%ebx),%eax
  80168c:	75 22                	jne    8016b0 <devpipe_read+0x4a>
			if (i > 0)
  80168e:	85 f6                	test   %esi,%esi
  801690:	75 14                	jne    8016a6 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801692:	89 da                	mov    %ebx,%edx
  801694:	89 f8                	mov    %edi,%eax
  801696:	e8 e5 fe ff ff       	call   801580 <_pipeisclosed>
  80169b:	85 c0                	test   %eax,%eax
  80169d:	75 33                	jne    8016d2 <devpipe_read+0x6c>
			sys_yield();
  80169f:	e8 63 f4 ff ff       	call   800b07 <sys_yield>
  8016a4:	eb e1                	jmp    801687 <devpipe_read+0x21>
				return i;
  8016a6:	89 f0                	mov    %esi,%eax
}
  8016a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ab:	5b                   	pop    %ebx
  8016ac:	5e                   	pop    %esi
  8016ad:	5f                   	pop    %edi
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8016b0:	99                   	cltd   
  8016b1:	c1 ea 1b             	shr    $0x1b,%edx
  8016b4:	01 d0                	add    %edx,%eax
  8016b6:	83 e0 1f             	and    $0x1f,%eax
  8016b9:	29 d0                	sub    %edx,%eax
  8016bb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8016c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016c3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8016c6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8016c9:	83 c6 01             	add    $0x1,%esi
  8016cc:	eb b4                	jmp    801682 <devpipe_read+0x1c>
	return i;
  8016ce:	89 f0                	mov    %esi,%eax
  8016d0:	eb d6                	jmp    8016a8 <devpipe_read+0x42>
				return 0;
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d7:	eb cf                	jmp    8016a8 <devpipe_read+0x42>

008016d9 <pipe>:
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	56                   	push   %esi
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8016e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	e8 54 f6 ff ff       	call   800d3e <fd_alloc>
  8016ea:	89 c3                	mov    %eax,%ebx
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	78 5b                	js     80174e <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8016f3:	83 ec 04             	sub    $0x4,%esp
  8016f6:	68 07 04 00 00       	push   $0x407
  8016fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8016fe:	6a 00                	push   $0x0
  801700:	e8 21 f4 ff ff       	call   800b26 <sys_page_alloc>
  801705:	89 c3                	mov    %eax,%ebx
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 40                	js     80174e <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80170e:	83 ec 0c             	sub    $0xc,%esp
  801711:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801714:	50                   	push   %eax
  801715:	e8 24 f6 ff ff       	call   800d3e <fd_alloc>
  80171a:	89 c3                	mov    %eax,%ebx
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	85 c0                	test   %eax,%eax
  801721:	78 1b                	js     80173e <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801723:	83 ec 04             	sub    $0x4,%esp
  801726:	68 07 04 00 00       	push   $0x407
  80172b:	ff 75 f0             	pushl  -0x10(%ebp)
  80172e:	6a 00                	push   $0x0
  801730:	e8 f1 f3 ff ff       	call   800b26 <sys_page_alloc>
  801735:	89 c3                	mov    %eax,%ebx
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	85 c0                	test   %eax,%eax
  80173c:	79 19                	jns    801757 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80173e:	83 ec 08             	sub    $0x8,%esp
  801741:	ff 75 f4             	pushl  -0xc(%ebp)
  801744:	6a 00                	push   $0x0
  801746:	e8 60 f4 ff ff       	call   800bab <sys_page_unmap>
  80174b:	83 c4 10             	add    $0x10,%esp
}
  80174e:	89 d8                	mov    %ebx,%eax
  801750:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801753:	5b                   	pop    %ebx
  801754:	5e                   	pop    %esi
  801755:	5d                   	pop    %ebp
  801756:	c3                   	ret    
	va = fd2data(fd0);
  801757:	83 ec 0c             	sub    $0xc,%esp
  80175a:	ff 75 f4             	pushl  -0xc(%ebp)
  80175d:	e8 c5 f5 ff ff       	call   800d27 <fd2data>
  801762:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801764:	83 c4 0c             	add    $0xc,%esp
  801767:	68 07 04 00 00       	push   $0x407
  80176c:	50                   	push   %eax
  80176d:	6a 00                	push   $0x0
  80176f:	e8 b2 f3 ff ff       	call   800b26 <sys_page_alloc>
  801774:	89 c3                	mov    %eax,%ebx
  801776:	83 c4 10             	add    $0x10,%esp
  801779:	85 c0                	test   %eax,%eax
  80177b:	0f 88 8c 00 00 00    	js     80180d <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801781:	83 ec 0c             	sub    $0xc,%esp
  801784:	ff 75 f0             	pushl  -0x10(%ebp)
  801787:	e8 9b f5 ff ff       	call   800d27 <fd2data>
  80178c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801793:	50                   	push   %eax
  801794:	6a 00                	push   $0x0
  801796:	56                   	push   %esi
  801797:	6a 00                	push   $0x0
  801799:	e8 cb f3 ff ff       	call   800b69 <sys_page_map>
  80179e:	89 c3                	mov    %eax,%ebx
  8017a0:	83 c4 20             	add    $0x20,%esp
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 58                	js     8017ff <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8017a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017aa:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017b0:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8017b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8017bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bf:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017c5:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8017c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ca:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8017d1:	83 ec 0c             	sub    $0xc,%esp
  8017d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d7:	e8 3b f5 ff ff       	call   800d17 <fd2num>
  8017dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017df:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8017e1:	83 c4 04             	add    $0x4,%esp
  8017e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e7:	e8 2b f5 ff ff       	call   800d17 <fd2num>
  8017ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ef:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017fa:	e9 4f ff ff ff       	jmp    80174e <pipe+0x75>
	sys_page_unmap(0, va);
  8017ff:	83 ec 08             	sub    $0x8,%esp
  801802:	56                   	push   %esi
  801803:	6a 00                	push   $0x0
  801805:	e8 a1 f3 ff ff       	call   800bab <sys_page_unmap>
  80180a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80180d:	83 ec 08             	sub    $0x8,%esp
  801810:	ff 75 f0             	pushl  -0x10(%ebp)
  801813:	6a 00                	push   $0x0
  801815:	e8 91 f3 ff ff       	call   800bab <sys_page_unmap>
  80181a:	83 c4 10             	add    $0x10,%esp
  80181d:	e9 1c ff ff ff       	jmp    80173e <pipe+0x65>

00801822 <pipeisclosed>:
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801828:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182b:	50                   	push   %eax
  80182c:	ff 75 08             	pushl  0x8(%ebp)
  80182f:	e8 59 f5 ff ff       	call   800d8d <fd_lookup>
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	85 c0                	test   %eax,%eax
  801839:	78 18                	js     801853 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80183b:	83 ec 0c             	sub    $0xc,%esp
  80183e:	ff 75 f4             	pushl  -0xc(%ebp)
  801841:	e8 e1 f4 ff ff       	call   800d27 <fd2data>
	return _pipeisclosed(fd, p);
  801846:	89 c2                	mov    %eax,%edx
  801848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184b:	e8 30 fd ff ff       	call   801580 <_pipeisclosed>
  801850:	83 c4 10             	add    $0x10,%esp
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801858:	b8 00 00 00 00       	mov    $0x0,%eax
  80185d:	5d                   	pop    %ebp
  80185e:	c3                   	ret    

0080185f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801865:	68 2a 21 80 00       	push   $0x80212a
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	e8 bb ee ff ff       	call   80072d <strcpy>
	return 0;
}
  801872:	b8 00 00 00 00       	mov    $0x0,%eax
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <devcons_write>:
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	57                   	push   %edi
  80187d:	56                   	push   %esi
  80187e:	53                   	push   %ebx
  80187f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801885:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80188a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801890:	eb 2f                	jmp    8018c1 <devcons_write+0x48>
		m = n - tot;
  801892:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801895:	29 f3                	sub    %esi,%ebx
  801897:	83 fb 7f             	cmp    $0x7f,%ebx
  80189a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80189f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	53                   	push   %ebx
  8018a6:	89 f0                	mov    %esi,%eax
  8018a8:	03 45 0c             	add    0xc(%ebp),%eax
  8018ab:	50                   	push   %eax
  8018ac:	57                   	push   %edi
  8018ad:	e8 09 f0 ff ff       	call   8008bb <memmove>
		sys_cputs(buf, m);
  8018b2:	83 c4 08             	add    $0x8,%esp
  8018b5:	53                   	push   %ebx
  8018b6:	57                   	push   %edi
  8018b7:	e8 ae f1 ff ff       	call   800a6a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8018bc:	01 de                	add    %ebx,%esi
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018c4:	72 cc                	jb     801892 <devcons_write+0x19>
}
  8018c6:	89 f0                	mov    %esi,%eax
  8018c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018cb:	5b                   	pop    %ebx
  8018cc:	5e                   	pop    %esi
  8018cd:	5f                   	pop    %edi
  8018ce:	5d                   	pop    %ebp
  8018cf:	c3                   	ret    

008018d0 <devcons_read>:
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 08             	sub    $0x8,%esp
  8018d6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8018db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018df:	75 07                	jne    8018e8 <devcons_read+0x18>
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    
		sys_yield();
  8018e3:	e8 1f f2 ff ff       	call   800b07 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8018e8:	e8 9b f1 ff ff       	call   800a88 <sys_cgetc>
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	74 f2                	je     8018e3 <devcons_read+0x13>
	if (c < 0)
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	78 ec                	js     8018e1 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8018f5:	83 f8 04             	cmp    $0x4,%eax
  8018f8:	74 0c                	je     801906 <devcons_read+0x36>
	*(char*)vbuf = c;
  8018fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fd:	88 02                	mov    %al,(%edx)
	return 1;
  8018ff:	b8 01 00 00 00       	mov    $0x1,%eax
  801904:	eb db                	jmp    8018e1 <devcons_read+0x11>
		return 0;
  801906:	b8 00 00 00 00       	mov    $0x0,%eax
  80190b:	eb d4                	jmp    8018e1 <devcons_read+0x11>

0080190d <cputchar>:
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801919:	6a 01                	push   $0x1
  80191b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80191e:	50                   	push   %eax
  80191f:	e8 46 f1 ff ff       	call   800a6a <sys_cputs>
}
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <getchar>:
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80192f:	6a 01                	push   $0x1
  801931:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801934:	50                   	push   %eax
  801935:	6a 00                	push   $0x0
  801937:	e8 c2 f6 ff ff       	call   800ffe <read>
	if (r < 0)
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	85 c0                	test   %eax,%eax
  801941:	78 08                	js     80194b <getchar+0x22>
	if (r < 1)
  801943:	85 c0                	test   %eax,%eax
  801945:	7e 06                	jle    80194d <getchar+0x24>
	return c;
  801947:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    
		return -E_EOF;
  80194d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801952:	eb f7                	jmp    80194b <getchar+0x22>

00801954 <iscons>:
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80195a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195d:	50                   	push   %eax
  80195e:	ff 75 08             	pushl  0x8(%ebp)
  801961:	e8 27 f4 ff ff       	call   800d8d <fd_lookup>
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	85 c0                	test   %eax,%eax
  80196b:	78 11                	js     80197e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801970:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801976:	39 10                	cmp    %edx,(%eax)
  801978:	0f 94 c0             	sete   %al
  80197b:	0f b6 c0             	movzbl %al,%eax
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <opencons>:
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801986:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801989:	50                   	push   %eax
  80198a:	e8 af f3 ff ff       	call   800d3e <fd_alloc>
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	85 c0                	test   %eax,%eax
  801994:	78 3a                	js     8019d0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801996:	83 ec 04             	sub    $0x4,%esp
  801999:	68 07 04 00 00       	push   $0x407
  80199e:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a1:	6a 00                	push   $0x0
  8019a3:	e8 7e f1 ff ff       	call   800b26 <sys_page_alloc>
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	78 21                	js     8019d0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8019af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019b8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8019ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8019c4:	83 ec 0c             	sub    $0xc,%esp
  8019c7:	50                   	push   %eax
  8019c8:	e8 4a f3 ff ff       	call   800d17 <fd2num>
  8019cd:	83 c4 10             	add    $0x10,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	56                   	push   %esi
  8019d6:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8019d7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8019da:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8019e0:	e8 03 f1 ff ff       	call   800ae8 <sys_getenvid>
  8019e5:	83 ec 0c             	sub    $0xc,%esp
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	ff 75 08             	pushl  0x8(%ebp)
  8019ee:	56                   	push   %esi
  8019ef:	50                   	push   %eax
  8019f0:	68 38 21 80 00       	push   $0x802138
  8019f5:	e8 49 e7 ff ff       	call   800143 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8019fa:	83 c4 18             	add    $0x18,%esp
  8019fd:	53                   	push   %ebx
  8019fe:	ff 75 10             	pushl  0x10(%ebp)
  801a01:	e8 ec e6 ff ff       	call   8000f2 <vcprintf>
	cprintf("\n");
  801a06:	c7 04 24 1c 1d 80 00 	movl   $0x801d1c,(%esp)
  801a0d:	e8 31 e7 ff ff       	call   800143 <cprintf>
  801a12:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a15:	cc                   	int3   
  801a16:	eb fd                	jmp    801a15 <_panic+0x43>

00801a18 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801a1e:	68 5c 21 80 00       	push   $0x80215c
  801a23:	6a 1a                	push   $0x1a
  801a25:	68 75 21 80 00       	push   $0x802175
  801a2a:	e8 a3 ff ff ff       	call   8019d2 <_panic>

00801a2f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801a35:	68 7f 21 80 00       	push   $0x80217f
  801a3a:	6a 2a                	push   $0x2a
  801a3c:	68 75 21 80 00       	push   $0x802175
  801a41:	e8 8c ff ff ff       	call   8019d2 <_panic>

00801a46 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a4c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a51:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a54:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a5a:	8b 52 50             	mov    0x50(%edx),%edx
  801a5d:	39 ca                	cmp    %ecx,%edx
  801a5f:	74 11                	je     801a72 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801a61:	83 c0 01             	add    $0x1,%eax
  801a64:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a69:	75 e6                	jne    801a51 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a70:	eb 0b                	jmp    801a7d <ipc_find_env+0x37>
			return envs[i].env_id;
  801a72:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a75:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a7a:	8b 40 48             	mov    0x48(%eax),%eax
}
  801a7d:	5d                   	pop    %ebp
  801a7e:	c3                   	ret    

00801a7f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a85:	89 d0                	mov    %edx,%eax
  801a87:	c1 e8 16             	shr    $0x16,%eax
  801a8a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801a91:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801a96:	f6 c1 01             	test   $0x1,%cl
  801a99:	74 1d                	je     801ab8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801a9b:	c1 ea 0c             	shr    $0xc,%edx
  801a9e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801aa5:	f6 c2 01             	test   $0x1,%dl
  801aa8:	74 0e                	je     801ab8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801aaa:	c1 ea 0c             	shr    $0xc,%edx
  801aad:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ab4:	ef 
  801ab5:	0f b7 c0             	movzwl %ax,%eax
}
  801ab8:	5d                   	pop    %ebp
  801ab9:	c3                   	ret    
  801aba:	66 90                	xchg   %ax,%ax
  801abc:	66 90                	xchg   %ax,%ax
  801abe:	66 90                	xchg   %ax,%ax

00801ac0 <__udivdi3>:
  801ac0:	55                   	push   %ebp
  801ac1:	57                   	push   %edi
  801ac2:	56                   	push   %esi
  801ac3:	53                   	push   %ebx
  801ac4:	83 ec 1c             	sub    $0x1c,%esp
  801ac7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801acb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801acf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ad3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ad7:	85 d2                	test   %edx,%edx
  801ad9:	75 35                	jne    801b10 <__udivdi3+0x50>
  801adb:	39 f3                	cmp    %esi,%ebx
  801add:	0f 87 bd 00 00 00    	ja     801ba0 <__udivdi3+0xe0>
  801ae3:	85 db                	test   %ebx,%ebx
  801ae5:	89 d9                	mov    %ebx,%ecx
  801ae7:	75 0b                	jne    801af4 <__udivdi3+0x34>
  801ae9:	b8 01 00 00 00       	mov    $0x1,%eax
  801aee:	31 d2                	xor    %edx,%edx
  801af0:	f7 f3                	div    %ebx
  801af2:	89 c1                	mov    %eax,%ecx
  801af4:	31 d2                	xor    %edx,%edx
  801af6:	89 f0                	mov    %esi,%eax
  801af8:	f7 f1                	div    %ecx
  801afa:	89 c6                	mov    %eax,%esi
  801afc:	89 e8                	mov    %ebp,%eax
  801afe:	89 f7                	mov    %esi,%edi
  801b00:	f7 f1                	div    %ecx
  801b02:	89 fa                	mov    %edi,%edx
  801b04:	83 c4 1c             	add    $0x1c,%esp
  801b07:	5b                   	pop    %ebx
  801b08:	5e                   	pop    %esi
  801b09:	5f                   	pop    %edi
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    
  801b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801b10:	39 f2                	cmp    %esi,%edx
  801b12:	77 7c                	ja     801b90 <__udivdi3+0xd0>
  801b14:	0f bd fa             	bsr    %edx,%edi
  801b17:	83 f7 1f             	xor    $0x1f,%edi
  801b1a:	0f 84 98 00 00 00    	je     801bb8 <__udivdi3+0xf8>
  801b20:	89 f9                	mov    %edi,%ecx
  801b22:	b8 20 00 00 00       	mov    $0x20,%eax
  801b27:	29 f8                	sub    %edi,%eax
  801b29:	d3 e2                	shl    %cl,%edx
  801b2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b2f:	89 c1                	mov    %eax,%ecx
  801b31:	89 da                	mov    %ebx,%edx
  801b33:	d3 ea                	shr    %cl,%edx
  801b35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801b39:	09 d1                	or     %edx,%ecx
  801b3b:	89 f2                	mov    %esi,%edx
  801b3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b41:	89 f9                	mov    %edi,%ecx
  801b43:	d3 e3                	shl    %cl,%ebx
  801b45:	89 c1                	mov    %eax,%ecx
  801b47:	d3 ea                	shr    %cl,%edx
  801b49:	89 f9                	mov    %edi,%ecx
  801b4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801b4f:	d3 e6                	shl    %cl,%esi
  801b51:	89 eb                	mov    %ebp,%ebx
  801b53:	89 c1                	mov    %eax,%ecx
  801b55:	d3 eb                	shr    %cl,%ebx
  801b57:	09 de                	or     %ebx,%esi
  801b59:	89 f0                	mov    %esi,%eax
  801b5b:	f7 74 24 08          	divl   0x8(%esp)
  801b5f:	89 d6                	mov    %edx,%esi
  801b61:	89 c3                	mov    %eax,%ebx
  801b63:	f7 64 24 0c          	mull   0xc(%esp)
  801b67:	39 d6                	cmp    %edx,%esi
  801b69:	72 0c                	jb     801b77 <__udivdi3+0xb7>
  801b6b:	89 f9                	mov    %edi,%ecx
  801b6d:	d3 e5                	shl    %cl,%ebp
  801b6f:	39 c5                	cmp    %eax,%ebp
  801b71:	73 5d                	jae    801bd0 <__udivdi3+0x110>
  801b73:	39 d6                	cmp    %edx,%esi
  801b75:	75 59                	jne    801bd0 <__udivdi3+0x110>
  801b77:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b7a:	31 ff                	xor    %edi,%edi
  801b7c:	89 fa                	mov    %edi,%edx
  801b7e:	83 c4 1c             	add    $0x1c,%esp
  801b81:	5b                   	pop    %ebx
  801b82:	5e                   	pop    %esi
  801b83:	5f                   	pop    %edi
  801b84:	5d                   	pop    %ebp
  801b85:	c3                   	ret    
  801b86:	8d 76 00             	lea    0x0(%esi),%esi
  801b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801b90:	31 ff                	xor    %edi,%edi
  801b92:	31 c0                	xor    %eax,%eax
  801b94:	89 fa                	mov    %edi,%edx
  801b96:	83 c4 1c             	add    $0x1c,%esp
  801b99:	5b                   	pop    %ebx
  801b9a:	5e                   	pop    %esi
  801b9b:	5f                   	pop    %edi
  801b9c:	5d                   	pop    %ebp
  801b9d:	c3                   	ret    
  801b9e:	66 90                	xchg   %ax,%ax
  801ba0:	31 ff                	xor    %edi,%edi
  801ba2:	89 e8                	mov    %ebp,%eax
  801ba4:	89 f2                	mov    %esi,%edx
  801ba6:	f7 f3                	div    %ebx
  801ba8:	89 fa                	mov    %edi,%edx
  801baa:	83 c4 1c             	add    $0x1c,%esp
  801bad:	5b                   	pop    %ebx
  801bae:	5e                   	pop    %esi
  801baf:	5f                   	pop    %edi
  801bb0:	5d                   	pop    %ebp
  801bb1:	c3                   	ret    
  801bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801bb8:	39 f2                	cmp    %esi,%edx
  801bba:	72 06                	jb     801bc2 <__udivdi3+0x102>
  801bbc:	31 c0                	xor    %eax,%eax
  801bbe:	39 eb                	cmp    %ebp,%ebx
  801bc0:	77 d2                	ja     801b94 <__udivdi3+0xd4>
  801bc2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc7:	eb cb                	jmp    801b94 <__udivdi3+0xd4>
  801bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801bd0:	89 d8                	mov    %ebx,%eax
  801bd2:	31 ff                	xor    %edi,%edi
  801bd4:	eb be                	jmp    801b94 <__udivdi3+0xd4>
  801bd6:	66 90                	xchg   %ax,%ax
  801bd8:	66 90                	xchg   %ax,%ax
  801bda:	66 90                	xchg   %ax,%ax
  801bdc:	66 90                	xchg   %ax,%ax
  801bde:	66 90                	xchg   %ax,%ax

00801be0 <__umoddi3>:
  801be0:	55                   	push   %ebp
  801be1:	57                   	push   %edi
  801be2:	56                   	push   %esi
  801be3:	53                   	push   %ebx
  801be4:	83 ec 1c             	sub    $0x1c,%esp
  801be7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801beb:	8b 74 24 30          	mov    0x30(%esp),%esi
  801bef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801bf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bf7:	85 ed                	test   %ebp,%ebp
  801bf9:	89 f0                	mov    %esi,%eax
  801bfb:	89 da                	mov    %ebx,%edx
  801bfd:	75 19                	jne    801c18 <__umoddi3+0x38>
  801bff:	39 df                	cmp    %ebx,%edi
  801c01:	0f 86 b1 00 00 00    	jbe    801cb8 <__umoddi3+0xd8>
  801c07:	f7 f7                	div    %edi
  801c09:	89 d0                	mov    %edx,%eax
  801c0b:	31 d2                	xor    %edx,%edx
  801c0d:	83 c4 1c             	add    $0x1c,%esp
  801c10:	5b                   	pop    %ebx
  801c11:	5e                   	pop    %esi
  801c12:	5f                   	pop    %edi
  801c13:	5d                   	pop    %ebp
  801c14:	c3                   	ret    
  801c15:	8d 76 00             	lea    0x0(%esi),%esi
  801c18:	39 dd                	cmp    %ebx,%ebp
  801c1a:	77 f1                	ja     801c0d <__umoddi3+0x2d>
  801c1c:	0f bd cd             	bsr    %ebp,%ecx
  801c1f:	83 f1 1f             	xor    $0x1f,%ecx
  801c22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c26:	0f 84 b4 00 00 00    	je     801ce0 <__umoddi3+0x100>
  801c2c:	b8 20 00 00 00       	mov    $0x20,%eax
  801c31:	89 c2                	mov    %eax,%edx
  801c33:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c37:	29 c2                	sub    %eax,%edx
  801c39:	89 c1                	mov    %eax,%ecx
  801c3b:	89 f8                	mov    %edi,%eax
  801c3d:	d3 e5                	shl    %cl,%ebp
  801c3f:	89 d1                	mov    %edx,%ecx
  801c41:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c45:	d3 e8                	shr    %cl,%eax
  801c47:	09 c5                	or     %eax,%ebp
  801c49:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c4d:	89 c1                	mov    %eax,%ecx
  801c4f:	d3 e7                	shl    %cl,%edi
  801c51:	89 d1                	mov    %edx,%ecx
  801c53:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801c57:	89 df                	mov    %ebx,%edi
  801c59:	d3 ef                	shr    %cl,%edi
  801c5b:	89 c1                	mov    %eax,%ecx
  801c5d:	89 f0                	mov    %esi,%eax
  801c5f:	d3 e3                	shl    %cl,%ebx
  801c61:	89 d1                	mov    %edx,%ecx
  801c63:	89 fa                	mov    %edi,%edx
  801c65:	d3 e8                	shr    %cl,%eax
  801c67:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801c6c:	09 d8                	or     %ebx,%eax
  801c6e:	f7 f5                	div    %ebp
  801c70:	d3 e6                	shl    %cl,%esi
  801c72:	89 d1                	mov    %edx,%ecx
  801c74:	f7 64 24 08          	mull   0x8(%esp)
  801c78:	39 d1                	cmp    %edx,%ecx
  801c7a:	89 c3                	mov    %eax,%ebx
  801c7c:	89 d7                	mov    %edx,%edi
  801c7e:	72 06                	jb     801c86 <__umoddi3+0xa6>
  801c80:	75 0e                	jne    801c90 <__umoddi3+0xb0>
  801c82:	39 c6                	cmp    %eax,%esi
  801c84:	73 0a                	jae    801c90 <__umoddi3+0xb0>
  801c86:	2b 44 24 08          	sub    0x8(%esp),%eax
  801c8a:	19 ea                	sbb    %ebp,%edx
  801c8c:	89 d7                	mov    %edx,%edi
  801c8e:	89 c3                	mov    %eax,%ebx
  801c90:	89 ca                	mov    %ecx,%edx
  801c92:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801c97:	29 de                	sub    %ebx,%esi
  801c99:	19 fa                	sbb    %edi,%edx
  801c9b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801c9f:	89 d0                	mov    %edx,%eax
  801ca1:	d3 e0                	shl    %cl,%eax
  801ca3:	89 d9                	mov    %ebx,%ecx
  801ca5:	d3 ee                	shr    %cl,%esi
  801ca7:	d3 ea                	shr    %cl,%edx
  801ca9:	09 f0                	or     %esi,%eax
  801cab:	83 c4 1c             	add    $0x1c,%esp
  801cae:	5b                   	pop    %ebx
  801caf:	5e                   	pop    %esi
  801cb0:	5f                   	pop    %edi
  801cb1:	5d                   	pop    %ebp
  801cb2:	c3                   	ret    
  801cb3:	90                   	nop
  801cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801cb8:	85 ff                	test   %edi,%edi
  801cba:	89 f9                	mov    %edi,%ecx
  801cbc:	75 0b                	jne    801cc9 <__umoddi3+0xe9>
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc3:	31 d2                	xor    %edx,%edx
  801cc5:	f7 f7                	div    %edi
  801cc7:	89 c1                	mov    %eax,%ecx
  801cc9:	89 d8                	mov    %ebx,%eax
  801ccb:	31 d2                	xor    %edx,%edx
  801ccd:	f7 f1                	div    %ecx
  801ccf:	89 f0                	mov    %esi,%eax
  801cd1:	f7 f1                	div    %ecx
  801cd3:	e9 31 ff ff ff       	jmp    801c09 <__umoddi3+0x29>
  801cd8:	90                   	nop
  801cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ce0:	39 dd                	cmp    %ebx,%ebp
  801ce2:	72 08                	jb     801cec <__umoddi3+0x10c>
  801ce4:	39 f7                	cmp    %esi,%edi
  801ce6:	0f 87 21 ff ff ff    	ja     801c0d <__umoddi3+0x2d>
  801cec:	89 da                	mov    %ebx,%edx
  801cee:	89 f0                	mov    %esi,%eax
  801cf0:	29 f8                	sub    %edi,%eax
  801cf2:	19 ea                	sbb    %ebp,%edx
  801cf4:	e9 14 ff ff ff       	jmp    801c0d <__umoddi3+0x2d>
