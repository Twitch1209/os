
obj/user/yield.debug：     文件格式 elf32-i386


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
  80002c:	e8 69 00 00 00       	call   80009a <libmain>
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
  800037:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 04 40 80 00       	mov    0x804004,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 60 1d 80 00       	push   $0x801d60
  800048:	e8 42 01 00 00       	call   80018f <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 f9 0a 00 00       	call   800b53 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 80 1d 80 00       	push   $0x801d80
  80006c:	e8 1e 01 00 00       	call   80018f <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	83 c3 01             	add    $0x1,%ebx
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	83 fb 05             	cmp    $0x5,%ebx
  80007a:	75 d9                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007c:	a1 04 40 80 00       	mov    0x804004,%eax
  800081:	8b 40 48             	mov    0x48(%eax),%eax
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	50                   	push   %eax
  800088:	68 ac 1d 80 00       	push   $0x801dac
  80008d:	e8 fd 00 00 00       	call   80018f <cprintf>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
  80009f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a5:	e8 8a 0a 00 00       	call   800b34 <sys_getenvid>
  8000aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000af:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b7:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bc:	85 db                	test   %ebx,%ebx
  8000be:	7e 07                	jle    8000c7 <libmain+0x2d>
		binaryname = argv[0];
  8000c0:	8b 06                	mov    (%esi),%eax
  8000c2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	56                   	push   %esi
  8000cb:	53                   	push   %ebx
  8000cc:	e8 62 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d1:	e8 0a 00 00 00       	call   8000e0 <exit>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000dc:	5b                   	pop    %ebx
  8000dd:	5e                   	pop    %esi
  8000de:	5d                   	pop    %ebp
  8000df:	c3                   	ret    

008000e0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000e6:	e8 4e 0e 00 00       	call   800f39 <close_all>
	sys_env_destroy(0);
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	6a 00                	push   $0x0
  8000f0:	e8 fe 09 00 00       	call   800af3 <sys_env_destroy>
}
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	c9                   	leave  
  8000f9:	c3                   	ret    

008000fa <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	53                   	push   %ebx
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800104:	8b 13                	mov    (%ebx),%edx
  800106:	8d 42 01             	lea    0x1(%edx),%eax
  800109:	89 03                	mov    %eax,(%ebx)
  80010b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800112:	3d ff 00 00 00       	cmp    $0xff,%eax
  800117:	74 09                	je     800122 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800119:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80011d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800120:	c9                   	leave  
  800121:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800122:	83 ec 08             	sub    $0x8,%esp
  800125:	68 ff 00 00 00       	push   $0xff
  80012a:	8d 43 08             	lea    0x8(%ebx),%eax
  80012d:	50                   	push   %eax
  80012e:	e8 83 09 00 00       	call   800ab6 <sys_cputs>
		b->idx = 0;
  800133:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	eb db                	jmp    800119 <putch+0x1f>

0080013e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800147:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014e:	00 00 00 
	b.cnt = 0;
  800151:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800158:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015b:	ff 75 0c             	pushl  0xc(%ebp)
  80015e:	ff 75 08             	pushl  0x8(%ebp)
  800161:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800167:	50                   	push   %eax
  800168:	68 fa 00 80 00       	push   $0x8000fa
  80016d:	e8 1a 01 00 00       	call   80028c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800172:	83 c4 08             	add    $0x8,%esp
  800175:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	e8 2f 09 00 00       	call   800ab6 <sys_cputs>

	return b.cnt;
}
  800187:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800195:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800198:	50                   	push   %eax
  800199:	ff 75 08             	pushl  0x8(%ebp)
  80019c:	e8 9d ff ff ff       	call   80013e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	57                   	push   %edi
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
  8001a9:	83 ec 1c             	sub    $0x1c,%esp
  8001ac:	89 c7                	mov    %eax,%edi
  8001ae:	89 d6                	mov    %edx,%esi
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001c4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001c7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001ca:	39 d3                	cmp    %edx,%ebx
  8001cc:	72 05                	jb     8001d3 <printnum+0x30>
  8001ce:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001d1:	77 7a                	ja     80024d <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	ff 75 18             	pushl  0x18(%ebp)
  8001d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8001dc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001df:	53                   	push   %ebx
  8001e0:	ff 75 10             	pushl  0x10(%ebp)
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e9:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ec:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f2:	e8 19 19 00 00       	call   801b10 <__udivdi3>
  8001f7:	83 c4 18             	add    $0x18,%esp
  8001fa:	52                   	push   %edx
  8001fb:	50                   	push   %eax
  8001fc:	89 f2                	mov    %esi,%edx
  8001fe:	89 f8                	mov    %edi,%eax
  800200:	e8 9e ff ff ff       	call   8001a3 <printnum>
  800205:	83 c4 20             	add    $0x20,%esp
  800208:	eb 13                	jmp    80021d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	56                   	push   %esi
  80020e:	ff 75 18             	pushl  0x18(%ebp)
  800211:	ff d7                	call   *%edi
  800213:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800216:	83 eb 01             	sub    $0x1,%ebx
  800219:	85 db                	test   %ebx,%ebx
  80021b:	7f ed                	jg     80020a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	56                   	push   %esi
  800221:	83 ec 04             	sub    $0x4,%esp
  800224:	ff 75 e4             	pushl  -0x1c(%ebp)
  800227:	ff 75 e0             	pushl  -0x20(%ebp)
  80022a:	ff 75 dc             	pushl  -0x24(%ebp)
  80022d:	ff 75 d8             	pushl  -0x28(%ebp)
  800230:	e8 fb 19 00 00       	call   801c30 <__umoddi3>
  800235:	83 c4 14             	add    $0x14,%esp
  800238:	0f be 80 d5 1d 80 00 	movsbl 0x801dd5(%eax),%eax
  80023f:	50                   	push   %eax
  800240:	ff d7                	call   *%edi
}
  800242:	83 c4 10             	add    $0x10,%esp
  800245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800248:	5b                   	pop    %ebx
  800249:	5e                   	pop    %esi
  80024a:	5f                   	pop    %edi
  80024b:	5d                   	pop    %ebp
  80024c:	c3                   	ret    
  80024d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800250:	eb c4                	jmp    800216 <printnum+0x73>

00800252 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800258:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80025c:	8b 10                	mov    (%eax),%edx
  80025e:	3b 50 04             	cmp    0x4(%eax),%edx
  800261:	73 0a                	jae    80026d <sprintputch+0x1b>
		*b->buf++ = ch;
  800263:	8d 4a 01             	lea    0x1(%edx),%ecx
  800266:	89 08                	mov    %ecx,(%eax)
  800268:	8b 45 08             	mov    0x8(%ebp),%eax
  80026b:	88 02                	mov    %al,(%edx)
}
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <printfmt>:
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800275:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800278:	50                   	push   %eax
  800279:	ff 75 10             	pushl  0x10(%ebp)
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	ff 75 08             	pushl  0x8(%ebp)
  800282:	e8 05 00 00 00       	call   80028c <vprintfmt>
}
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <vprintfmt>:
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	57                   	push   %edi
  800290:	56                   	push   %esi
  800291:	53                   	push   %ebx
  800292:	83 ec 2c             	sub    $0x2c,%esp
  800295:	8b 75 08             	mov    0x8(%ebp),%esi
  800298:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80029b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80029e:	e9 8c 03 00 00       	jmp    80062f <vprintfmt+0x3a3>
		padc = ' ';
  8002a3:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002a7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002ae:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c1:	8d 47 01             	lea    0x1(%edi),%eax
  8002c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002c7:	0f b6 17             	movzbl (%edi),%edx
  8002ca:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002cd:	3c 55                	cmp    $0x55,%al
  8002cf:	0f 87 dd 03 00 00    	ja     8006b2 <vprintfmt+0x426>
  8002d5:	0f b6 c0             	movzbl %al,%eax
  8002d8:	ff 24 85 20 1f 80 00 	jmp    *0x801f20(,%eax,4)
  8002df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e2:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002e6:	eb d9                	jmp    8002c1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002eb:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002ef:	eb d0                	jmp    8002c1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002f1:	0f b6 d2             	movzbl %dl,%edx
  8002f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002ff:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800302:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800306:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800309:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80030c:	83 f9 09             	cmp    $0x9,%ecx
  80030f:	77 55                	ja     800366 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800311:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800314:	eb e9                	jmp    8002ff <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800316:	8b 45 14             	mov    0x14(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80031e:	8b 45 14             	mov    0x14(%ebp),%eax
  800321:	8d 40 04             	lea    0x4(%eax),%eax
  800324:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800327:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80032a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80032e:	79 91                	jns    8002c1 <vprintfmt+0x35>
				width = precision, precision = -1;
  800330:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800333:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800336:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80033d:	eb 82                	jmp    8002c1 <vprintfmt+0x35>
  80033f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800342:	85 c0                	test   %eax,%eax
  800344:	ba 00 00 00 00       	mov    $0x0,%edx
  800349:	0f 49 d0             	cmovns %eax,%edx
  80034c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800352:	e9 6a ff ff ff       	jmp    8002c1 <vprintfmt+0x35>
  800357:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80035a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800361:	e9 5b ff ff ff       	jmp    8002c1 <vprintfmt+0x35>
  800366:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800369:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80036c:	eb bc                	jmp    80032a <vprintfmt+0x9e>
			lflag++;
  80036e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800374:	e9 48 ff ff ff       	jmp    8002c1 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800379:	8b 45 14             	mov    0x14(%ebp),%eax
  80037c:	8d 78 04             	lea    0x4(%eax),%edi
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	53                   	push   %ebx
  800383:	ff 30                	pushl  (%eax)
  800385:	ff d6                	call   *%esi
			break;
  800387:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80038a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80038d:	e9 9a 02 00 00       	jmp    80062c <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800392:	8b 45 14             	mov    0x14(%ebp),%eax
  800395:	8d 78 04             	lea    0x4(%eax),%edi
  800398:	8b 00                	mov    (%eax),%eax
  80039a:	99                   	cltd   
  80039b:	31 d0                	xor    %edx,%eax
  80039d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80039f:	83 f8 0f             	cmp    $0xf,%eax
  8003a2:	7f 23                	jg     8003c7 <vprintfmt+0x13b>
  8003a4:	8b 14 85 80 20 80 00 	mov    0x802080(,%eax,4),%edx
  8003ab:	85 d2                	test   %edx,%edx
  8003ad:	74 18                	je     8003c7 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003af:	52                   	push   %edx
  8003b0:	68 b1 21 80 00       	push   $0x8021b1
  8003b5:	53                   	push   %ebx
  8003b6:	56                   	push   %esi
  8003b7:	e8 b3 fe ff ff       	call   80026f <printfmt>
  8003bc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bf:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c2:	e9 65 02 00 00       	jmp    80062c <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8003c7:	50                   	push   %eax
  8003c8:	68 ed 1d 80 00       	push   $0x801ded
  8003cd:	53                   	push   %ebx
  8003ce:	56                   	push   %esi
  8003cf:	e8 9b fe ff ff       	call   80026f <printfmt>
  8003d4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003da:	e9 4d 02 00 00       	jmp    80062c <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  8003df:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e2:	83 c0 04             	add    $0x4,%eax
  8003e5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003eb:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003ed:	85 ff                	test   %edi,%edi
  8003ef:	b8 e6 1d 80 00       	mov    $0x801de6,%eax
  8003f4:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003fb:	0f 8e bd 00 00 00    	jle    8004be <vprintfmt+0x232>
  800401:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800405:	75 0e                	jne    800415 <vprintfmt+0x189>
  800407:	89 75 08             	mov    %esi,0x8(%ebp)
  80040a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80040d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800410:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800413:	eb 6d                	jmp    800482 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800415:	83 ec 08             	sub    $0x8,%esp
  800418:	ff 75 d0             	pushl  -0x30(%ebp)
  80041b:	57                   	push   %edi
  80041c:	e8 39 03 00 00       	call   80075a <strnlen>
  800421:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800424:	29 c1                	sub    %eax,%ecx
  800426:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800429:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80042c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800433:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800436:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800438:	eb 0f                	jmp    800449 <vprintfmt+0x1bd>
					putch(padc, putdat);
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	53                   	push   %ebx
  80043e:	ff 75 e0             	pushl  -0x20(%ebp)
  800441:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800443:	83 ef 01             	sub    $0x1,%edi
  800446:	83 c4 10             	add    $0x10,%esp
  800449:	85 ff                	test   %edi,%edi
  80044b:	7f ed                	jg     80043a <vprintfmt+0x1ae>
  80044d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800450:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800453:	85 c9                	test   %ecx,%ecx
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	0f 49 c1             	cmovns %ecx,%eax
  80045d:	29 c1                	sub    %eax,%ecx
  80045f:	89 75 08             	mov    %esi,0x8(%ebp)
  800462:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800465:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800468:	89 cb                	mov    %ecx,%ebx
  80046a:	eb 16                	jmp    800482 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80046c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800470:	75 31                	jne    8004a3 <vprintfmt+0x217>
					putch(ch, putdat);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	50                   	push   %eax
  800479:	ff 55 08             	call   *0x8(%ebp)
  80047c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80047f:	83 eb 01             	sub    $0x1,%ebx
  800482:	83 c7 01             	add    $0x1,%edi
  800485:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800489:	0f be c2             	movsbl %dl,%eax
  80048c:	85 c0                	test   %eax,%eax
  80048e:	74 59                	je     8004e9 <vprintfmt+0x25d>
  800490:	85 f6                	test   %esi,%esi
  800492:	78 d8                	js     80046c <vprintfmt+0x1e0>
  800494:	83 ee 01             	sub    $0x1,%esi
  800497:	79 d3                	jns    80046c <vprintfmt+0x1e0>
  800499:	89 df                	mov    %ebx,%edi
  80049b:	8b 75 08             	mov    0x8(%ebp),%esi
  80049e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a1:	eb 37                	jmp    8004da <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a3:	0f be d2             	movsbl %dl,%edx
  8004a6:	83 ea 20             	sub    $0x20,%edx
  8004a9:	83 fa 5e             	cmp    $0x5e,%edx
  8004ac:	76 c4                	jbe    800472 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	ff 75 0c             	pushl  0xc(%ebp)
  8004b4:	6a 3f                	push   $0x3f
  8004b6:	ff 55 08             	call   *0x8(%ebp)
  8004b9:	83 c4 10             	add    $0x10,%esp
  8004bc:	eb c1                	jmp    80047f <vprintfmt+0x1f3>
  8004be:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004c7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004ca:	eb b6                	jmp    800482 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	53                   	push   %ebx
  8004d0:	6a 20                	push   $0x20
  8004d2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004d4:	83 ef 01             	sub    $0x1,%edi
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	85 ff                	test   %edi,%edi
  8004dc:	7f ee                	jg     8004cc <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e4:	e9 43 01 00 00       	jmp    80062c <vprintfmt+0x3a0>
  8004e9:	89 df                	mov    %ebx,%edi
  8004eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004f1:	eb e7                	jmp    8004da <vprintfmt+0x24e>
	if (lflag >= 2)
  8004f3:	83 f9 01             	cmp    $0x1,%ecx
  8004f6:	7e 3f                	jle    800537 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	8b 50 04             	mov    0x4(%eax),%edx
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800503:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8d 40 08             	lea    0x8(%eax),%eax
  80050c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80050f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800513:	79 5c                	jns    800571 <vprintfmt+0x2e5>
				putch('-', putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	53                   	push   %ebx
  800519:	6a 2d                	push   $0x2d
  80051b:	ff d6                	call   *%esi
				num = -(long long) num;
  80051d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800520:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800523:	f7 da                	neg    %edx
  800525:	83 d1 00             	adc    $0x0,%ecx
  800528:	f7 d9                	neg    %ecx
  80052a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80052d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800532:	e9 db 00 00 00       	jmp    800612 <vprintfmt+0x386>
	else if (lflag)
  800537:	85 c9                	test   %ecx,%ecx
  800539:	75 1b                	jne    800556 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800543:	89 c1                	mov    %eax,%ecx
  800545:	c1 f9 1f             	sar    $0x1f,%ecx
  800548:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8d 40 04             	lea    0x4(%eax),%eax
  800551:	89 45 14             	mov    %eax,0x14(%ebp)
  800554:	eb b9                	jmp    80050f <vprintfmt+0x283>
		return va_arg(*ap, long);
  800556:	8b 45 14             	mov    0x14(%ebp),%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055e:	89 c1                	mov    %eax,%ecx
  800560:	c1 f9 1f             	sar    $0x1f,%ecx
  800563:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8d 40 04             	lea    0x4(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
  80056f:	eb 9e                	jmp    80050f <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800571:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800574:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800577:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057c:	e9 91 00 00 00       	jmp    800612 <vprintfmt+0x386>
	if (lflag >= 2)
  800581:	83 f9 01             	cmp    $0x1,%ecx
  800584:	7e 15                	jle    80059b <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8b 10                	mov    (%eax),%edx
  80058b:	8b 48 04             	mov    0x4(%eax),%ecx
  80058e:	8d 40 08             	lea    0x8(%eax),%eax
  800591:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800594:	b8 0a 00 00 00       	mov    $0xa,%eax
  800599:	eb 77                	jmp    800612 <vprintfmt+0x386>
	else if (lflag)
  80059b:	85 c9                	test   %ecx,%ecx
  80059d:	75 17                	jne    8005b6 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8b 10                	mov    (%eax),%edx
  8005a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a9:	8d 40 04             	lea    0x4(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b4:	eb 5c                	jmp    800612 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8b 10                	mov    (%eax),%edx
  8005bb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c0:	8d 40 04             	lea    0x4(%eax),%eax
  8005c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cb:	eb 45                	jmp    800612 <vprintfmt+0x386>
			putch('X', putdat);
  8005cd:	83 ec 08             	sub    $0x8,%esp
  8005d0:	53                   	push   %ebx
  8005d1:	6a 58                	push   $0x58
  8005d3:	ff d6                	call   *%esi
			putch('X', putdat);
  8005d5:	83 c4 08             	add    $0x8,%esp
  8005d8:	53                   	push   %ebx
  8005d9:	6a 58                	push   $0x58
  8005db:	ff d6                	call   *%esi
			putch('X', putdat);
  8005dd:	83 c4 08             	add    $0x8,%esp
  8005e0:	53                   	push   %ebx
  8005e1:	6a 58                	push   $0x58
  8005e3:	ff d6                	call   *%esi
			break;
  8005e5:	83 c4 10             	add    $0x10,%esp
  8005e8:	eb 42                	jmp    80062c <vprintfmt+0x3a0>
			putch('0', putdat);
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	53                   	push   %ebx
  8005ee:	6a 30                	push   $0x30
  8005f0:	ff d6                	call   *%esi
			putch('x', putdat);
  8005f2:	83 c4 08             	add    $0x8,%esp
  8005f5:	53                   	push   %ebx
  8005f6:	6a 78                	push   $0x78
  8005f8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 10                	mov    (%eax),%edx
  8005ff:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800604:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800607:	8d 40 04             	lea    0x4(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80060d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800612:	83 ec 0c             	sub    $0xc,%esp
  800615:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800619:	57                   	push   %edi
  80061a:	ff 75 e0             	pushl  -0x20(%ebp)
  80061d:	50                   	push   %eax
  80061e:	51                   	push   %ecx
  80061f:	52                   	push   %edx
  800620:	89 da                	mov    %ebx,%edx
  800622:	89 f0                	mov    %esi,%eax
  800624:	e8 7a fb ff ff       	call   8001a3 <printnum>
			break;
  800629:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80062c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80062f:	83 c7 01             	add    $0x1,%edi
  800632:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800636:	83 f8 25             	cmp    $0x25,%eax
  800639:	0f 84 64 fc ff ff    	je     8002a3 <vprintfmt+0x17>
			if (ch == '\0')
  80063f:	85 c0                	test   %eax,%eax
  800641:	0f 84 8b 00 00 00    	je     8006d2 <vprintfmt+0x446>
			putch(ch, putdat);
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	53                   	push   %ebx
  80064b:	50                   	push   %eax
  80064c:	ff d6                	call   *%esi
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	eb dc                	jmp    80062f <vprintfmt+0x3a3>
	if (lflag >= 2)
  800653:	83 f9 01             	cmp    $0x1,%ecx
  800656:	7e 15                	jle    80066d <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 10                	mov    (%eax),%edx
  80065d:	8b 48 04             	mov    0x4(%eax),%ecx
  800660:	8d 40 08             	lea    0x8(%eax),%eax
  800663:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800666:	b8 10 00 00 00       	mov    $0x10,%eax
  80066b:	eb a5                	jmp    800612 <vprintfmt+0x386>
	else if (lflag)
  80066d:	85 c9                	test   %ecx,%ecx
  80066f:	75 17                	jne    800688 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800681:	b8 10 00 00 00       	mov    $0x10,%eax
  800686:	eb 8a                	jmp    800612 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 10                	mov    (%eax),%edx
  80068d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800692:	8d 40 04             	lea    0x4(%eax),%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800698:	b8 10 00 00 00       	mov    $0x10,%eax
  80069d:	e9 70 ff ff ff       	jmp    800612 <vprintfmt+0x386>
			putch(ch, putdat);
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	53                   	push   %ebx
  8006a6:	6a 25                	push   $0x25
  8006a8:	ff d6                	call   *%esi
			break;
  8006aa:	83 c4 10             	add    $0x10,%esp
  8006ad:	e9 7a ff ff ff       	jmp    80062c <vprintfmt+0x3a0>
			putch('%', putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	6a 25                	push   $0x25
  8006b8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	89 f8                	mov    %edi,%eax
  8006bf:	eb 03                	jmp    8006c4 <vprintfmt+0x438>
  8006c1:	83 e8 01             	sub    $0x1,%eax
  8006c4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006c8:	75 f7                	jne    8006c1 <vprintfmt+0x435>
  8006ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006cd:	e9 5a ff ff ff       	jmp    80062c <vprintfmt+0x3a0>
}
  8006d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d5:	5b                   	pop    %ebx
  8006d6:	5e                   	pop    %esi
  8006d7:	5f                   	pop    %edi
  8006d8:	5d                   	pop    %ebp
  8006d9:	c3                   	ret    

008006da <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006da:	55                   	push   %ebp
  8006db:	89 e5                	mov    %esp,%ebp
  8006dd:	83 ec 18             	sub    $0x18,%esp
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006e9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006ed:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006f7:	85 c0                	test   %eax,%eax
  8006f9:	74 26                	je     800721 <vsnprintf+0x47>
  8006fb:	85 d2                	test   %edx,%edx
  8006fd:	7e 22                	jle    800721 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006ff:	ff 75 14             	pushl  0x14(%ebp)
  800702:	ff 75 10             	pushl  0x10(%ebp)
  800705:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800708:	50                   	push   %eax
  800709:	68 52 02 80 00       	push   $0x800252
  80070e:	e8 79 fb ff ff       	call   80028c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800713:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800716:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80071c:	83 c4 10             	add    $0x10,%esp
}
  80071f:	c9                   	leave  
  800720:	c3                   	ret    
		return -E_INVAL;
  800721:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800726:	eb f7                	jmp    80071f <vsnprintf+0x45>

00800728 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800728:	55                   	push   %ebp
  800729:	89 e5                	mov    %esp,%ebp
  80072b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80072e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800731:	50                   	push   %eax
  800732:	ff 75 10             	pushl  0x10(%ebp)
  800735:	ff 75 0c             	pushl  0xc(%ebp)
  800738:	ff 75 08             	pushl  0x8(%ebp)
  80073b:	e8 9a ff ff ff       	call   8006da <vsnprintf>
	va_end(ap);

	return rc;
}
  800740:	c9                   	leave  
  800741:	c3                   	ret    

00800742 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800748:	b8 00 00 00 00       	mov    $0x0,%eax
  80074d:	eb 03                	jmp    800752 <strlen+0x10>
		n++;
  80074f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800752:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800756:	75 f7                	jne    80074f <strlen+0xd>
	return n;
}
  800758:	5d                   	pop    %ebp
  800759:	c3                   	ret    

0080075a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800760:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800763:	b8 00 00 00 00       	mov    $0x0,%eax
  800768:	eb 03                	jmp    80076d <strnlen+0x13>
		n++;
  80076a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80076d:	39 d0                	cmp    %edx,%eax
  80076f:	74 06                	je     800777 <strnlen+0x1d>
  800771:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800775:	75 f3                	jne    80076a <strnlen+0x10>
	return n;
}
  800777:	5d                   	pop    %ebp
  800778:	c3                   	ret    

00800779 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	53                   	push   %ebx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800783:	89 c2                	mov    %eax,%edx
  800785:	83 c1 01             	add    $0x1,%ecx
  800788:	83 c2 01             	add    $0x1,%edx
  80078b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80078f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800792:	84 db                	test   %bl,%bl
  800794:	75 ef                	jne    800785 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800796:	5b                   	pop    %ebx
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	53                   	push   %ebx
  80079d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007a0:	53                   	push   %ebx
  8007a1:	e8 9c ff ff ff       	call   800742 <strlen>
  8007a6:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007a9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ac:	01 d8                	add    %ebx,%eax
  8007ae:	50                   	push   %eax
  8007af:	e8 c5 ff ff ff       	call   800779 <strcpy>
	return dst;
}
  8007b4:	89 d8                	mov    %ebx,%eax
  8007b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	56                   	push   %esi
  8007bf:	53                   	push   %ebx
  8007c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c6:	89 f3                	mov    %esi,%ebx
  8007c8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007cb:	89 f2                	mov    %esi,%edx
  8007cd:	eb 0f                	jmp    8007de <strncpy+0x23>
		*dst++ = *src;
  8007cf:	83 c2 01             	add    $0x1,%edx
  8007d2:	0f b6 01             	movzbl (%ecx),%eax
  8007d5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007d8:	80 39 01             	cmpb   $0x1,(%ecx)
  8007db:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007de:	39 da                	cmp    %ebx,%edx
  8007e0:	75 ed                	jne    8007cf <strncpy+0x14>
	}
	return ret;
}
  8007e2:	89 f0                	mov    %esi,%eax
  8007e4:	5b                   	pop    %ebx
  8007e5:	5e                   	pop    %esi
  8007e6:	5d                   	pop    %ebp
  8007e7:	c3                   	ret    

008007e8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	56                   	push   %esi
  8007ec:	53                   	push   %ebx
  8007ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007f6:	89 f0                	mov    %esi,%eax
  8007f8:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007fc:	85 c9                	test   %ecx,%ecx
  8007fe:	75 0b                	jne    80080b <strlcpy+0x23>
  800800:	eb 17                	jmp    800819 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800802:	83 c2 01             	add    $0x1,%edx
  800805:	83 c0 01             	add    $0x1,%eax
  800808:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80080b:	39 d8                	cmp    %ebx,%eax
  80080d:	74 07                	je     800816 <strlcpy+0x2e>
  80080f:	0f b6 0a             	movzbl (%edx),%ecx
  800812:	84 c9                	test   %cl,%cl
  800814:	75 ec                	jne    800802 <strlcpy+0x1a>
		*dst = '\0';
  800816:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800819:	29 f0                	sub    %esi,%eax
}
  80081b:	5b                   	pop    %ebx
  80081c:	5e                   	pop    %esi
  80081d:	5d                   	pop    %ebp
  80081e:	c3                   	ret    

0080081f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80081f:	55                   	push   %ebp
  800820:	89 e5                	mov    %esp,%ebp
  800822:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800825:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800828:	eb 06                	jmp    800830 <strcmp+0x11>
		p++, q++;
  80082a:	83 c1 01             	add    $0x1,%ecx
  80082d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800830:	0f b6 01             	movzbl (%ecx),%eax
  800833:	84 c0                	test   %al,%al
  800835:	74 04                	je     80083b <strcmp+0x1c>
  800837:	3a 02                	cmp    (%edx),%al
  800839:	74 ef                	je     80082a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80083b:	0f b6 c0             	movzbl %al,%eax
  80083e:	0f b6 12             	movzbl (%edx),%edx
  800841:	29 d0                	sub    %edx,%eax
}
  800843:	5d                   	pop    %ebp
  800844:	c3                   	ret    

00800845 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	53                   	push   %ebx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084f:	89 c3                	mov    %eax,%ebx
  800851:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800854:	eb 06                	jmp    80085c <strncmp+0x17>
		n--, p++, q++;
  800856:	83 c0 01             	add    $0x1,%eax
  800859:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80085c:	39 d8                	cmp    %ebx,%eax
  80085e:	74 16                	je     800876 <strncmp+0x31>
  800860:	0f b6 08             	movzbl (%eax),%ecx
  800863:	84 c9                	test   %cl,%cl
  800865:	74 04                	je     80086b <strncmp+0x26>
  800867:	3a 0a                	cmp    (%edx),%cl
  800869:	74 eb                	je     800856 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80086b:	0f b6 00             	movzbl (%eax),%eax
  80086e:	0f b6 12             	movzbl (%edx),%edx
  800871:	29 d0                	sub    %edx,%eax
}
  800873:	5b                   	pop    %ebx
  800874:	5d                   	pop    %ebp
  800875:	c3                   	ret    
		return 0;
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	eb f6                	jmp    800873 <strncmp+0x2e>

0080087d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800887:	0f b6 10             	movzbl (%eax),%edx
  80088a:	84 d2                	test   %dl,%dl
  80088c:	74 09                	je     800897 <strchr+0x1a>
		if (*s == c)
  80088e:	38 ca                	cmp    %cl,%dl
  800890:	74 0a                	je     80089c <strchr+0x1f>
	for (; *s; s++)
  800892:	83 c0 01             	add    $0x1,%eax
  800895:	eb f0                	jmp    800887 <strchr+0xa>
			return (char *) s;
	return 0;
  800897:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80089c:	5d                   	pop    %ebp
  80089d:	c3                   	ret    

0080089e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a8:	eb 03                	jmp    8008ad <strfind+0xf>
  8008aa:	83 c0 01             	add    $0x1,%eax
  8008ad:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008b0:	38 ca                	cmp    %cl,%dl
  8008b2:	74 04                	je     8008b8 <strfind+0x1a>
  8008b4:	84 d2                	test   %dl,%dl
  8008b6:	75 f2                	jne    8008aa <strfind+0xc>
			break;
	return (char *) s;
}
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	57                   	push   %edi
  8008be:	56                   	push   %esi
  8008bf:	53                   	push   %ebx
  8008c0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008c6:	85 c9                	test   %ecx,%ecx
  8008c8:	74 13                	je     8008dd <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008ca:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008d0:	75 05                	jne    8008d7 <memset+0x1d>
  8008d2:	f6 c1 03             	test   $0x3,%cl
  8008d5:	74 0d                	je     8008e4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008da:	fc                   	cld    
  8008db:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008dd:	89 f8                	mov    %edi,%eax
  8008df:	5b                   	pop    %ebx
  8008e0:	5e                   	pop    %esi
  8008e1:	5f                   	pop    %edi
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    
		c &= 0xFF;
  8008e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008e8:	89 d3                	mov    %edx,%ebx
  8008ea:	c1 e3 08             	shl    $0x8,%ebx
  8008ed:	89 d0                	mov    %edx,%eax
  8008ef:	c1 e0 18             	shl    $0x18,%eax
  8008f2:	89 d6                	mov    %edx,%esi
  8008f4:	c1 e6 10             	shl    $0x10,%esi
  8008f7:	09 f0                	or     %esi,%eax
  8008f9:	09 c2                	or     %eax,%edx
  8008fb:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008fd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800900:	89 d0                	mov    %edx,%eax
  800902:	fc                   	cld    
  800903:	f3 ab                	rep stos %eax,%es:(%edi)
  800905:	eb d6                	jmp    8008dd <memset+0x23>

00800907 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	57                   	push   %edi
  80090b:	56                   	push   %esi
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800912:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800915:	39 c6                	cmp    %eax,%esi
  800917:	73 35                	jae    80094e <memmove+0x47>
  800919:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80091c:	39 c2                	cmp    %eax,%edx
  80091e:	76 2e                	jbe    80094e <memmove+0x47>
		s += n;
		d += n;
  800920:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800923:	89 d6                	mov    %edx,%esi
  800925:	09 fe                	or     %edi,%esi
  800927:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80092d:	74 0c                	je     80093b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80092f:	83 ef 01             	sub    $0x1,%edi
  800932:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800935:	fd                   	std    
  800936:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800938:	fc                   	cld    
  800939:	eb 21                	jmp    80095c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093b:	f6 c1 03             	test   $0x3,%cl
  80093e:	75 ef                	jne    80092f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800940:	83 ef 04             	sub    $0x4,%edi
  800943:	8d 72 fc             	lea    -0x4(%edx),%esi
  800946:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800949:	fd                   	std    
  80094a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80094c:	eb ea                	jmp    800938 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80094e:	89 f2                	mov    %esi,%edx
  800950:	09 c2                	or     %eax,%edx
  800952:	f6 c2 03             	test   $0x3,%dl
  800955:	74 09                	je     800960 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800957:	89 c7                	mov    %eax,%edi
  800959:	fc                   	cld    
  80095a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80095c:	5e                   	pop    %esi
  80095d:	5f                   	pop    %edi
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800960:	f6 c1 03             	test   $0x3,%cl
  800963:	75 f2                	jne    800957 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800965:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800968:	89 c7                	mov    %eax,%edi
  80096a:	fc                   	cld    
  80096b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80096d:	eb ed                	jmp    80095c <memmove+0x55>

0080096f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800972:	ff 75 10             	pushl  0x10(%ebp)
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	ff 75 08             	pushl  0x8(%ebp)
  80097b:	e8 87 ff ff ff       	call   800907 <memmove>
}
  800980:	c9                   	leave  
  800981:	c3                   	ret    

00800982 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	56                   	push   %esi
  800986:	53                   	push   %ebx
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098d:	89 c6                	mov    %eax,%esi
  80098f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800992:	39 f0                	cmp    %esi,%eax
  800994:	74 1c                	je     8009b2 <memcmp+0x30>
		if (*s1 != *s2)
  800996:	0f b6 08             	movzbl (%eax),%ecx
  800999:	0f b6 1a             	movzbl (%edx),%ebx
  80099c:	38 d9                	cmp    %bl,%cl
  80099e:	75 08                	jne    8009a8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009a0:	83 c0 01             	add    $0x1,%eax
  8009a3:	83 c2 01             	add    $0x1,%edx
  8009a6:	eb ea                	jmp    800992 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009a8:	0f b6 c1             	movzbl %cl,%eax
  8009ab:	0f b6 db             	movzbl %bl,%ebx
  8009ae:	29 d8                	sub    %ebx,%eax
  8009b0:	eb 05                	jmp    8009b7 <memcmp+0x35>
	}

	return 0;
  8009b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b7:	5b                   	pop    %ebx
  8009b8:	5e                   	pop    %esi
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009c4:	89 c2                	mov    %eax,%edx
  8009c6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009c9:	39 d0                	cmp    %edx,%eax
  8009cb:	73 09                	jae    8009d6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009cd:	38 08                	cmp    %cl,(%eax)
  8009cf:	74 05                	je     8009d6 <memfind+0x1b>
	for (; s < ends; s++)
  8009d1:	83 c0 01             	add    $0x1,%eax
  8009d4:	eb f3                	jmp    8009c9 <memfind+0xe>
			break;
	return (void *) s;
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	57                   	push   %edi
  8009dc:	56                   	push   %esi
  8009dd:	53                   	push   %ebx
  8009de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009e4:	eb 03                	jmp    8009e9 <strtol+0x11>
		s++;
  8009e6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009e9:	0f b6 01             	movzbl (%ecx),%eax
  8009ec:	3c 20                	cmp    $0x20,%al
  8009ee:	74 f6                	je     8009e6 <strtol+0xe>
  8009f0:	3c 09                	cmp    $0x9,%al
  8009f2:	74 f2                	je     8009e6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009f4:	3c 2b                	cmp    $0x2b,%al
  8009f6:	74 2e                	je     800a26 <strtol+0x4e>
	int neg = 0;
  8009f8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009fd:	3c 2d                	cmp    $0x2d,%al
  8009ff:	74 2f                	je     800a30 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a01:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a07:	75 05                	jne    800a0e <strtol+0x36>
  800a09:	80 39 30             	cmpb   $0x30,(%ecx)
  800a0c:	74 2c                	je     800a3a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a0e:	85 db                	test   %ebx,%ebx
  800a10:	75 0a                	jne    800a1c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a12:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a17:	80 39 30             	cmpb   $0x30,(%ecx)
  800a1a:	74 28                	je     800a44 <strtol+0x6c>
		base = 10;
  800a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a21:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a24:	eb 50                	jmp    800a76 <strtol+0x9e>
		s++;
  800a26:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a29:	bf 00 00 00 00       	mov    $0x0,%edi
  800a2e:	eb d1                	jmp    800a01 <strtol+0x29>
		s++, neg = 1;
  800a30:	83 c1 01             	add    $0x1,%ecx
  800a33:	bf 01 00 00 00       	mov    $0x1,%edi
  800a38:	eb c7                	jmp    800a01 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a3a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a3e:	74 0e                	je     800a4e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a40:	85 db                	test   %ebx,%ebx
  800a42:	75 d8                	jne    800a1c <strtol+0x44>
		s++, base = 8;
  800a44:	83 c1 01             	add    $0x1,%ecx
  800a47:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a4c:	eb ce                	jmp    800a1c <strtol+0x44>
		s += 2, base = 16;
  800a4e:	83 c1 02             	add    $0x2,%ecx
  800a51:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a56:	eb c4                	jmp    800a1c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a58:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a5b:	89 f3                	mov    %esi,%ebx
  800a5d:	80 fb 19             	cmp    $0x19,%bl
  800a60:	77 29                	ja     800a8b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a62:	0f be d2             	movsbl %dl,%edx
  800a65:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a68:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a6b:	7d 30                	jge    800a9d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a6d:	83 c1 01             	add    $0x1,%ecx
  800a70:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a74:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a76:	0f b6 11             	movzbl (%ecx),%edx
  800a79:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a7c:	89 f3                	mov    %esi,%ebx
  800a7e:	80 fb 09             	cmp    $0x9,%bl
  800a81:	77 d5                	ja     800a58 <strtol+0x80>
			dig = *s - '0';
  800a83:	0f be d2             	movsbl %dl,%edx
  800a86:	83 ea 30             	sub    $0x30,%edx
  800a89:	eb dd                	jmp    800a68 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a8b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a8e:	89 f3                	mov    %esi,%ebx
  800a90:	80 fb 19             	cmp    $0x19,%bl
  800a93:	77 08                	ja     800a9d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a95:	0f be d2             	movsbl %dl,%edx
  800a98:	83 ea 37             	sub    $0x37,%edx
  800a9b:	eb cb                	jmp    800a68 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa1:	74 05                	je     800aa8 <strtol+0xd0>
		*endptr = (char *) s;
  800aa3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800aa8:	89 c2                	mov    %eax,%edx
  800aaa:	f7 da                	neg    %edx
  800aac:	85 ff                	test   %edi,%edi
  800aae:	0f 45 c2             	cmovne %edx,%eax
}
  800ab1:	5b                   	pop    %ebx
  800ab2:	5e                   	pop    %esi
  800ab3:	5f                   	pop    %edi
  800ab4:	5d                   	pop    %ebp
  800ab5:	c3                   	ret    

00800ab6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	57                   	push   %edi
  800aba:	56                   	push   %esi
  800abb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800abc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac7:	89 c3                	mov    %eax,%ebx
  800ac9:	89 c7                	mov    %eax,%edi
  800acb:	89 c6                	mov    %eax,%esi
  800acd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800acf:	5b                   	pop    %ebx
  800ad0:	5e                   	pop    %esi
  800ad1:	5f                   	pop    %edi
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	57                   	push   %edi
  800ad8:	56                   	push   %esi
  800ad9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ada:	ba 00 00 00 00       	mov    $0x0,%edx
  800adf:	b8 01 00 00 00       	mov    $0x1,%eax
  800ae4:	89 d1                	mov    %edx,%ecx
  800ae6:	89 d3                	mov    %edx,%ebx
  800ae8:	89 d7                	mov    %edx,%edi
  800aea:	89 d6                	mov    %edx,%esi
  800aec:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800aee:	5b                   	pop    %ebx
  800aef:	5e                   	pop    %esi
  800af0:	5f                   	pop    %edi
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	57                   	push   %edi
  800af7:	56                   	push   %esi
  800af8:	53                   	push   %ebx
  800af9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800afc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b01:	8b 55 08             	mov    0x8(%ebp),%edx
  800b04:	b8 03 00 00 00       	mov    $0x3,%eax
  800b09:	89 cb                	mov    %ecx,%ebx
  800b0b:	89 cf                	mov    %ecx,%edi
  800b0d:	89 ce                	mov    %ecx,%esi
  800b0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b11:	85 c0                	test   %eax,%eax
  800b13:	7f 08                	jg     800b1d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b18:	5b                   	pop    %ebx
  800b19:	5e                   	pop    %esi
  800b1a:	5f                   	pop    %edi
  800b1b:	5d                   	pop    %ebp
  800b1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b1d:	83 ec 0c             	sub    $0xc,%esp
  800b20:	50                   	push   %eax
  800b21:	6a 03                	push   $0x3
  800b23:	68 df 20 80 00       	push   $0x8020df
  800b28:	6a 23                	push   $0x23
  800b2a:	68 fc 20 80 00       	push   $0x8020fc
  800b2f:	e8 ea 0e 00 00       	call   801a1e <_panic>

00800b34 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	57                   	push   %edi
  800b38:	56                   	push   %esi
  800b39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3f:	b8 02 00 00 00       	mov    $0x2,%eax
  800b44:	89 d1                	mov    %edx,%ecx
  800b46:	89 d3                	mov    %edx,%ebx
  800b48:	89 d7                	mov    %edx,%edi
  800b4a:	89 d6                	mov    %edx,%esi
  800b4c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b4e:	5b                   	pop    %ebx
  800b4f:	5e                   	pop    %esi
  800b50:	5f                   	pop    %edi
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <sys_yield>:

void
sys_yield(void)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b59:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b63:	89 d1                	mov    %edx,%ecx
  800b65:	89 d3                	mov    %edx,%ebx
  800b67:	89 d7                	mov    %edx,%edi
  800b69:	89 d6                	mov    %edx,%esi
  800b6b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b6d:	5b                   	pop    %ebx
  800b6e:	5e                   	pop    %esi
  800b6f:	5f                   	pop    %edi
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	57                   	push   %edi
  800b76:	56                   	push   %esi
  800b77:	53                   	push   %ebx
  800b78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b7b:	be 00 00 00 00       	mov    $0x0,%esi
  800b80:	8b 55 08             	mov    0x8(%ebp),%edx
  800b83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b86:	b8 04 00 00 00       	mov    $0x4,%eax
  800b8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b8e:	89 f7                	mov    %esi,%edi
  800b90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b92:	85 c0                	test   %eax,%eax
  800b94:	7f 08                	jg     800b9e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b99:	5b                   	pop    %ebx
  800b9a:	5e                   	pop    %esi
  800b9b:	5f                   	pop    %edi
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b9e:	83 ec 0c             	sub    $0xc,%esp
  800ba1:	50                   	push   %eax
  800ba2:	6a 04                	push   $0x4
  800ba4:	68 df 20 80 00       	push   $0x8020df
  800ba9:	6a 23                	push   $0x23
  800bab:	68 fc 20 80 00       	push   $0x8020fc
  800bb0:	e8 69 0e 00 00       	call   801a1e <_panic>

00800bb5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	57                   	push   %edi
  800bb9:	56                   	push   %esi
  800bba:	53                   	push   %ebx
  800bbb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc4:	b8 05 00 00 00       	mov    $0x5,%eax
  800bc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bcc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bcf:	8b 75 18             	mov    0x18(%ebp),%esi
  800bd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd4:	85 c0                	test   %eax,%eax
  800bd6:	7f 08                	jg     800be0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bdb:	5b                   	pop    %ebx
  800bdc:	5e                   	pop    %esi
  800bdd:	5f                   	pop    %edi
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be0:	83 ec 0c             	sub    $0xc,%esp
  800be3:	50                   	push   %eax
  800be4:	6a 05                	push   $0x5
  800be6:	68 df 20 80 00       	push   $0x8020df
  800beb:	6a 23                	push   $0x23
  800bed:	68 fc 20 80 00       	push   $0x8020fc
  800bf2:	e8 27 0e 00 00       	call   801a1e <_panic>

00800bf7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c00:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c05:	8b 55 08             	mov    0x8(%ebp),%edx
  800c08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0b:	b8 06 00 00 00       	mov    $0x6,%eax
  800c10:	89 df                	mov    %ebx,%edi
  800c12:	89 de                	mov    %ebx,%esi
  800c14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c16:	85 c0                	test   %eax,%eax
  800c18:	7f 08                	jg     800c22 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c1d:	5b                   	pop    %ebx
  800c1e:	5e                   	pop    %esi
  800c1f:	5f                   	pop    %edi
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c22:	83 ec 0c             	sub    $0xc,%esp
  800c25:	50                   	push   %eax
  800c26:	6a 06                	push   $0x6
  800c28:	68 df 20 80 00       	push   $0x8020df
  800c2d:	6a 23                	push   $0x23
  800c2f:	68 fc 20 80 00       	push   $0x8020fc
  800c34:	e8 e5 0d 00 00       	call   801a1e <_panic>

00800c39 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
  800c3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c42:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c47:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4d:	b8 08 00 00 00       	mov    $0x8,%eax
  800c52:	89 df                	mov    %ebx,%edi
  800c54:	89 de                	mov    %ebx,%esi
  800c56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	7f 08                	jg     800c64 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c64:	83 ec 0c             	sub    $0xc,%esp
  800c67:	50                   	push   %eax
  800c68:	6a 08                	push   $0x8
  800c6a:	68 df 20 80 00       	push   $0x8020df
  800c6f:	6a 23                	push   $0x23
  800c71:	68 fc 20 80 00       	push   $0x8020fc
  800c76:	e8 a3 0d 00 00       	call   801a1e <_panic>

00800c7b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	57                   	push   %edi
  800c7f:	56                   	push   %esi
  800c80:	53                   	push   %ebx
  800c81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c89:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8f:	b8 09 00 00 00       	mov    $0x9,%eax
  800c94:	89 df                	mov    %ebx,%edi
  800c96:	89 de                	mov    %ebx,%esi
  800c98:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9a:	85 c0                	test   %eax,%eax
  800c9c:	7f 08                	jg     800ca6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5f                   	pop    %edi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	50                   	push   %eax
  800caa:	6a 09                	push   $0x9
  800cac:	68 df 20 80 00       	push   $0x8020df
  800cb1:	6a 23                	push   $0x23
  800cb3:	68 fc 20 80 00       	push   $0x8020fc
  800cb8:	e8 61 0d 00 00       	call   801a1e <_panic>

00800cbd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	57                   	push   %edi
  800cc1:	56                   	push   %esi
  800cc2:	53                   	push   %ebx
  800cc3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd6:	89 df                	mov    %ebx,%edi
  800cd8:	89 de                	mov    %ebx,%esi
  800cda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdc:	85 c0                	test   %eax,%eax
  800cde:	7f 08                	jg     800ce8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce8:	83 ec 0c             	sub    $0xc,%esp
  800ceb:	50                   	push   %eax
  800cec:	6a 0a                	push   $0xa
  800cee:	68 df 20 80 00       	push   $0x8020df
  800cf3:	6a 23                	push   $0x23
  800cf5:	68 fc 20 80 00       	push   $0x8020fc
  800cfa:	e8 1f 0d 00 00       	call   801a1e <_panic>

00800cff <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	57                   	push   %edi
  800d03:	56                   	push   %esi
  800d04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d05:	8b 55 08             	mov    0x8(%ebp),%edx
  800d08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d10:	be 00 00 00 00       	mov    $0x0,%esi
  800d15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d18:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d1b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5f                   	pop    %edi
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	57                   	push   %edi
  800d26:	56                   	push   %esi
  800d27:	53                   	push   %ebx
  800d28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d30:	8b 55 08             	mov    0x8(%ebp),%edx
  800d33:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d38:	89 cb                	mov    %ecx,%ebx
  800d3a:	89 cf                	mov    %ecx,%edi
  800d3c:	89 ce                	mov    %ecx,%esi
  800d3e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d40:	85 c0                	test   %eax,%eax
  800d42:	7f 08                	jg     800d4c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d47:	5b                   	pop    %ebx
  800d48:	5e                   	pop    %esi
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4c:	83 ec 0c             	sub    $0xc,%esp
  800d4f:	50                   	push   %eax
  800d50:	6a 0d                	push   $0xd
  800d52:	68 df 20 80 00       	push   $0x8020df
  800d57:	6a 23                	push   $0x23
  800d59:	68 fc 20 80 00       	push   $0x8020fc
  800d5e:	e8 bb 0c 00 00       	call   801a1e <_panic>

00800d63 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	05 00 00 00 30       	add    $0x30000000,%eax
  800d6e:	c1 e8 0c             	shr    $0xc,%eax
}
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d7e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d83:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d90:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d95:	89 c2                	mov    %eax,%edx
  800d97:	c1 ea 16             	shr    $0x16,%edx
  800d9a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800da1:	f6 c2 01             	test   $0x1,%dl
  800da4:	74 2a                	je     800dd0 <fd_alloc+0x46>
  800da6:	89 c2                	mov    %eax,%edx
  800da8:	c1 ea 0c             	shr    $0xc,%edx
  800dab:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800db2:	f6 c2 01             	test   $0x1,%dl
  800db5:	74 19                	je     800dd0 <fd_alloc+0x46>
  800db7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800dbc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800dc1:	75 d2                	jne    800d95 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800dc3:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800dc9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800dce:	eb 07                	jmp    800dd7 <fd_alloc+0x4d>
			*fd_store = fd;
  800dd0:	89 01                	mov    %eax,(%ecx)
			return 0;
  800dd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ddf:	83 f8 1f             	cmp    $0x1f,%eax
  800de2:	77 36                	ja     800e1a <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800de4:	c1 e0 0c             	shl    $0xc,%eax
  800de7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800dec:	89 c2                	mov    %eax,%edx
  800dee:	c1 ea 16             	shr    $0x16,%edx
  800df1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800df8:	f6 c2 01             	test   $0x1,%dl
  800dfb:	74 24                	je     800e21 <fd_lookup+0x48>
  800dfd:	89 c2                	mov    %eax,%edx
  800dff:	c1 ea 0c             	shr    $0xc,%edx
  800e02:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e09:	f6 c2 01             	test   $0x1,%dl
  800e0c:	74 1a                	je     800e28 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e11:	89 02                	mov    %eax,(%edx)
	return 0;
  800e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
		return -E_INVAL;
  800e1a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e1f:	eb f7                	jmp    800e18 <fd_lookup+0x3f>
		return -E_INVAL;
  800e21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e26:	eb f0                	jmp    800e18 <fd_lookup+0x3f>
  800e28:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e2d:	eb e9                	jmp    800e18 <fd_lookup+0x3f>

00800e2f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 08             	sub    $0x8,%esp
  800e35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e38:	ba 88 21 80 00       	mov    $0x802188,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e3d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e42:	39 08                	cmp    %ecx,(%eax)
  800e44:	74 33                	je     800e79 <dev_lookup+0x4a>
  800e46:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800e49:	8b 02                	mov    (%edx),%eax
  800e4b:	85 c0                	test   %eax,%eax
  800e4d:	75 f3                	jne    800e42 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e4f:	a1 04 40 80 00       	mov    0x804004,%eax
  800e54:	8b 40 48             	mov    0x48(%eax),%eax
  800e57:	83 ec 04             	sub    $0x4,%esp
  800e5a:	51                   	push   %ecx
  800e5b:	50                   	push   %eax
  800e5c:	68 0c 21 80 00       	push   $0x80210c
  800e61:	e8 29 f3 ff ff       	call   80018f <cprintf>
	*dev = 0;
  800e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e6f:	83 c4 10             	add    $0x10,%esp
  800e72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    
			*dev = devtab[i];
  800e79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7c:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e83:	eb f2                	jmp    800e77 <dev_lookup+0x48>

00800e85 <fd_close>:
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	57                   	push   %edi
  800e89:	56                   	push   %esi
  800e8a:	53                   	push   %ebx
  800e8b:	83 ec 1c             	sub    $0x1c,%esp
  800e8e:	8b 75 08             	mov    0x8(%ebp),%esi
  800e91:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e97:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e98:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800e9e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ea1:	50                   	push   %eax
  800ea2:	e8 32 ff ff ff       	call   800dd9 <fd_lookup>
  800ea7:	89 c3                	mov    %eax,%ebx
  800ea9:	83 c4 08             	add    $0x8,%esp
  800eac:	85 c0                	test   %eax,%eax
  800eae:	78 05                	js     800eb5 <fd_close+0x30>
	    || fd != fd2)
  800eb0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800eb3:	74 16                	je     800ecb <fd_close+0x46>
		return (must_exist ? r : 0);
  800eb5:	89 f8                	mov    %edi,%eax
  800eb7:	84 c0                	test   %al,%al
  800eb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ebe:	0f 44 d8             	cmove  %eax,%ebx
}
  800ec1:	89 d8                	mov    %ebx,%eax
  800ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ecb:	83 ec 08             	sub    $0x8,%esp
  800ece:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ed1:	50                   	push   %eax
  800ed2:	ff 36                	pushl  (%esi)
  800ed4:	e8 56 ff ff ff       	call   800e2f <dev_lookup>
  800ed9:	89 c3                	mov    %eax,%ebx
  800edb:	83 c4 10             	add    $0x10,%esp
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	78 15                	js     800ef7 <fd_close+0x72>
		if (dev->dev_close)
  800ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee5:	8b 40 10             	mov    0x10(%eax),%eax
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	74 1b                	je     800f07 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800eec:	83 ec 0c             	sub    $0xc,%esp
  800eef:	56                   	push   %esi
  800ef0:	ff d0                	call   *%eax
  800ef2:	89 c3                	mov    %eax,%ebx
  800ef4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	56                   	push   %esi
  800efb:	6a 00                	push   $0x0
  800efd:	e8 f5 fc ff ff       	call   800bf7 <sys_page_unmap>
	return r;
  800f02:	83 c4 10             	add    $0x10,%esp
  800f05:	eb ba                	jmp    800ec1 <fd_close+0x3c>
			r = 0;
  800f07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0c:	eb e9                	jmp    800ef7 <fd_close+0x72>

00800f0e <close>:

int
close(int fdnum)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f17:	50                   	push   %eax
  800f18:	ff 75 08             	pushl  0x8(%ebp)
  800f1b:	e8 b9 fe ff ff       	call   800dd9 <fd_lookup>
  800f20:	83 c4 08             	add    $0x8,%esp
  800f23:	85 c0                	test   %eax,%eax
  800f25:	78 10                	js     800f37 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f27:	83 ec 08             	sub    $0x8,%esp
  800f2a:	6a 01                	push   $0x1
  800f2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f2f:	e8 51 ff ff ff       	call   800e85 <fd_close>
  800f34:	83 c4 10             	add    $0x10,%esp
}
  800f37:	c9                   	leave  
  800f38:	c3                   	ret    

00800f39 <close_all>:

void
close_all(void)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	53                   	push   %ebx
  800f3d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f40:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f45:	83 ec 0c             	sub    $0xc,%esp
  800f48:	53                   	push   %ebx
  800f49:	e8 c0 ff ff ff       	call   800f0e <close>
	for (i = 0; i < MAXFD; i++)
  800f4e:	83 c3 01             	add    $0x1,%ebx
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	83 fb 20             	cmp    $0x20,%ebx
  800f57:	75 ec                	jne    800f45 <close_all+0xc>
}
  800f59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
  800f64:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f67:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f6a:	50                   	push   %eax
  800f6b:	ff 75 08             	pushl  0x8(%ebp)
  800f6e:	e8 66 fe ff ff       	call   800dd9 <fd_lookup>
  800f73:	89 c3                	mov    %eax,%ebx
  800f75:	83 c4 08             	add    $0x8,%esp
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	0f 88 81 00 00 00    	js     801001 <dup+0xa3>
		return r;
	close(newfdnum);
  800f80:	83 ec 0c             	sub    $0xc,%esp
  800f83:	ff 75 0c             	pushl  0xc(%ebp)
  800f86:	e8 83 ff ff ff       	call   800f0e <close>

	newfd = INDEX2FD(newfdnum);
  800f8b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f8e:	c1 e6 0c             	shl    $0xc,%esi
  800f91:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f97:	83 c4 04             	add    $0x4,%esp
  800f9a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f9d:	e8 d1 fd ff ff       	call   800d73 <fd2data>
  800fa2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800fa4:	89 34 24             	mov    %esi,(%esp)
  800fa7:	e8 c7 fd ff ff       	call   800d73 <fd2data>
  800fac:	83 c4 10             	add    $0x10,%esp
  800faf:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800fb1:	89 d8                	mov    %ebx,%eax
  800fb3:	c1 e8 16             	shr    $0x16,%eax
  800fb6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fbd:	a8 01                	test   $0x1,%al
  800fbf:	74 11                	je     800fd2 <dup+0x74>
  800fc1:	89 d8                	mov    %ebx,%eax
  800fc3:	c1 e8 0c             	shr    $0xc,%eax
  800fc6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fcd:	f6 c2 01             	test   $0x1,%dl
  800fd0:	75 39                	jne    80100b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fd2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fd5:	89 d0                	mov    %edx,%eax
  800fd7:	c1 e8 0c             	shr    $0xc,%eax
  800fda:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fe1:	83 ec 0c             	sub    $0xc,%esp
  800fe4:	25 07 0e 00 00       	and    $0xe07,%eax
  800fe9:	50                   	push   %eax
  800fea:	56                   	push   %esi
  800feb:	6a 00                	push   $0x0
  800fed:	52                   	push   %edx
  800fee:	6a 00                	push   $0x0
  800ff0:	e8 c0 fb ff ff       	call   800bb5 <sys_page_map>
  800ff5:	89 c3                	mov    %eax,%ebx
  800ff7:	83 c4 20             	add    $0x20,%esp
  800ffa:	85 c0                	test   %eax,%eax
  800ffc:	78 31                	js     80102f <dup+0xd1>
		goto err;

	return newfdnum;
  800ffe:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801001:	89 d8                	mov    %ebx,%eax
  801003:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801006:	5b                   	pop    %ebx
  801007:	5e                   	pop    %esi
  801008:	5f                   	pop    %edi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80100b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801012:	83 ec 0c             	sub    $0xc,%esp
  801015:	25 07 0e 00 00       	and    $0xe07,%eax
  80101a:	50                   	push   %eax
  80101b:	57                   	push   %edi
  80101c:	6a 00                	push   $0x0
  80101e:	53                   	push   %ebx
  80101f:	6a 00                	push   $0x0
  801021:	e8 8f fb ff ff       	call   800bb5 <sys_page_map>
  801026:	89 c3                	mov    %eax,%ebx
  801028:	83 c4 20             	add    $0x20,%esp
  80102b:	85 c0                	test   %eax,%eax
  80102d:	79 a3                	jns    800fd2 <dup+0x74>
	sys_page_unmap(0, newfd);
  80102f:	83 ec 08             	sub    $0x8,%esp
  801032:	56                   	push   %esi
  801033:	6a 00                	push   $0x0
  801035:	e8 bd fb ff ff       	call   800bf7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80103a:	83 c4 08             	add    $0x8,%esp
  80103d:	57                   	push   %edi
  80103e:	6a 00                	push   $0x0
  801040:	e8 b2 fb ff ff       	call   800bf7 <sys_page_unmap>
	return r;
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	eb b7                	jmp    801001 <dup+0xa3>

0080104a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	53                   	push   %ebx
  80104e:	83 ec 14             	sub    $0x14,%esp
  801051:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801054:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801057:	50                   	push   %eax
  801058:	53                   	push   %ebx
  801059:	e8 7b fd ff ff       	call   800dd9 <fd_lookup>
  80105e:	83 c4 08             	add    $0x8,%esp
  801061:	85 c0                	test   %eax,%eax
  801063:	78 3f                	js     8010a4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80106b:	50                   	push   %eax
  80106c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106f:	ff 30                	pushl  (%eax)
  801071:	e8 b9 fd ff ff       	call   800e2f <dev_lookup>
  801076:	83 c4 10             	add    $0x10,%esp
  801079:	85 c0                	test   %eax,%eax
  80107b:	78 27                	js     8010a4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80107d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801080:	8b 42 08             	mov    0x8(%edx),%eax
  801083:	83 e0 03             	and    $0x3,%eax
  801086:	83 f8 01             	cmp    $0x1,%eax
  801089:	74 1e                	je     8010a9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80108b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108e:	8b 40 08             	mov    0x8(%eax),%eax
  801091:	85 c0                	test   %eax,%eax
  801093:	74 35                	je     8010ca <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	ff 75 10             	pushl  0x10(%ebp)
  80109b:	ff 75 0c             	pushl  0xc(%ebp)
  80109e:	52                   	push   %edx
  80109f:	ff d0                	call   *%eax
  8010a1:	83 c4 10             	add    $0x10,%esp
}
  8010a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010a7:	c9                   	leave  
  8010a8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010a9:	a1 04 40 80 00       	mov    0x804004,%eax
  8010ae:	8b 40 48             	mov    0x48(%eax),%eax
  8010b1:	83 ec 04             	sub    $0x4,%esp
  8010b4:	53                   	push   %ebx
  8010b5:	50                   	push   %eax
  8010b6:	68 4d 21 80 00       	push   $0x80214d
  8010bb:	e8 cf f0 ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  8010c0:	83 c4 10             	add    $0x10,%esp
  8010c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c8:	eb da                	jmp    8010a4 <read+0x5a>
		return -E_NOT_SUPP;
  8010ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8010cf:	eb d3                	jmp    8010a4 <read+0x5a>

008010d1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	57                   	push   %edi
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010dd:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e5:	39 f3                	cmp    %esi,%ebx
  8010e7:	73 25                	jae    80110e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010e9:	83 ec 04             	sub    $0x4,%esp
  8010ec:	89 f0                	mov    %esi,%eax
  8010ee:	29 d8                	sub    %ebx,%eax
  8010f0:	50                   	push   %eax
  8010f1:	89 d8                	mov    %ebx,%eax
  8010f3:	03 45 0c             	add    0xc(%ebp),%eax
  8010f6:	50                   	push   %eax
  8010f7:	57                   	push   %edi
  8010f8:	e8 4d ff ff ff       	call   80104a <read>
		if (m < 0)
  8010fd:	83 c4 10             	add    $0x10,%esp
  801100:	85 c0                	test   %eax,%eax
  801102:	78 08                	js     80110c <readn+0x3b>
			return m;
		if (m == 0)
  801104:	85 c0                	test   %eax,%eax
  801106:	74 06                	je     80110e <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801108:	01 c3                	add    %eax,%ebx
  80110a:	eb d9                	jmp    8010e5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80110c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80110e:	89 d8                	mov    %ebx,%eax
  801110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5f                   	pop    %edi
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    

00801118 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
  80111b:	53                   	push   %ebx
  80111c:	83 ec 14             	sub    $0x14,%esp
  80111f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801122:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801125:	50                   	push   %eax
  801126:	53                   	push   %ebx
  801127:	e8 ad fc ff ff       	call   800dd9 <fd_lookup>
  80112c:	83 c4 08             	add    $0x8,%esp
  80112f:	85 c0                	test   %eax,%eax
  801131:	78 3a                	js     80116d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801139:	50                   	push   %eax
  80113a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80113d:	ff 30                	pushl  (%eax)
  80113f:	e8 eb fc ff ff       	call   800e2f <dev_lookup>
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	85 c0                	test   %eax,%eax
  801149:	78 22                	js     80116d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80114b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801152:	74 1e                	je     801172 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801157:	8b 52 0c             	mov    0xc(%edx),%edx
  80115a:	85 d2                	test   %edx,%edx
  80115c:	74 35                	je     801193 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80115e:	83 ec 04             	sub    $0x4,%esp
  801161:	ff 75 10             	pushl  0x10(%ebp)
  801164:	ff 75 0c             	pushl  0xc(%ebp)
  801167:	50                   	push   %eax
  801168:	ff d2                	call   *%edx
  80116a:	83 c4 10             	add    $0x10,%esp
}
  80116d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801170:	c9                   	leave  
  801171:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801172:	a1 04 40 80 00       	mov    0x804004,%eax
  801177:	8b 40 48             	mov    0x48(%eax),%eax
  80117a:	83 ec 04             	sub    $0x4,%esp
  80117d:	53                   	push   %ebx
  80117e:	50                   	push   %eax
  80117f:	68 69 21 80 00       	push   $0x802169
  801184:	e8 06 f0 ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  801189:	83 c4 10             	add    $0x10,%esp
  80118c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801191:	eb da                	jmp    80116d <write+0x55>
		return -E_NOT_SUPP;
  801193:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801198:	eb d3                	jmp    80116d <write+0x55>

0080119a <seek>:

int
seek(int fdnum, off_t offset)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011a0:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011a3:	50                   	push   %eax
  8011a4:	ff 75 08             	pushl  0x8(%ebp)
  8011a7:	e8 2d fc ff ff       	call   800dd9 <fd_lookup>
  8011ac:	83 c4 08             	add    $0x8,%esp
  8011af:	85 c0                	test   %eax,%eax
  8011b1:	78 0e                	js     8011c1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

008011c3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	53                   	push   %ebx
  8011c7:	83 ec 14             	sub    $0x14,%esp
  8011ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011d0:	50                   	push   %eax
  8011d1:	53                   	push   %ebx
  8011d2:	e8 02 fc ff ff       	call   800dd9 <fd_lookup>
  8011d7:	83 c4 08             	add    $0x8,%esp
  8011da:	85 c0                	test   %eax,%eax
  8011dc:	78 37                	js     801215 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011de:	83 ec 08             	sub    $0x8,%esp
  8011e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e4:	50                   	push   %eax
  8011e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e8:	ff 30                	pushl  (%eax)
  8011ea:	e8 40 fc ff ff       	call   800e2f <dev_lookup>
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	78 1f                	js     801215 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011fd:	74 1b                	je     80121a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8011ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801202:	8b 52 18             	mov    0x18(%edx),%edx
  801205:	85 d2                	test   %edx,%edx
  801207:	74 32                	je     80123b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801209:	83 ec 08             	sub    $0x8,%esp
  80120c:	ff 75 0c             	pushl  0xc(%ebp)
  80120f:	50                   	push   %eax
  801210:	ff d2                	call   *%edx
  801212:	83 c4 10             	add    $0x10,%esp
}
  801215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801218:	c9                   	leave  
  801219:	c3                   	ret    
			thisenv->env_id, fdnum);
  80121a:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80121f:	8b 40 48             	mov    0x48(%eax),%eax
  801222:	83 ec 04             	sub    $0x4,%esp
  801225:	53                   	push   %ebx
  801226:	50                   	push   %eax
  801227:	68 2c 21 80 00       	push   $0x80212c
  80122c:	e8 5e ef ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  801231:	83 c4 10             	add    $0x10,%esp
  801234:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801239:	eb da                	jmp    801215 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80123b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801240:	eb d3                	jmp    801215 <ftruncate+0x52>

00801242 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	53                   	push   %ebx
  801246:	83 ec 14             	sub    $0x14,%esp
  801249:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80124c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80124f:	50                   	push   %eax
  801250:	ff 75 08             	pushl  0x8(%ebp)
  801253:	e8 81 fb ff ff       	call   800dd9 <fd_lookup>
  801258:	83 c4 08             	add    $0x8,%esp
  80125b:	85 c0                	test   %eax,%eax
  80125d:	78 4b                	js     8012aa <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80125f:	83 ec 08             	sub    $0x8,%esp
  801262:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801265:	50                   	push   %eax
  801266:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801269:	ff 30                	pushl  (%eax)
  80126b:	e8 bf fb ff ff       	call   800e2f <dev_lookup>
  801270:	83 c4 10             	add    $0x10,%esp
  801273:	85 c0                	test   %eax,%eax
  801275:	78 33                	js     8012aa <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80127e:	74 2f                	je     8012af <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801280:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801283:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80128a:	00 00 00 
	stat->st_isdir = 0;
  80128d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801294:	00 00 00 
	stat->st_dev = dev;
  801297:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	53                   	push   %ebx
  8012a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8012a4:	ff 50 14             	call   *0x14(%eax)
  8012a7:	83 c4 10             	add    $0x10,%esp
}
  8012aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    
		return -E_NOT_SUPP;
  8012af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012b4:	eb f4                	jmp    8012aa <fstat+0x68>

008012b6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
  8012b9:	56                   	push   %esi
  8012ba:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012bb:	83 ec 08             	sub    $0x8,%esp
  8012be:	6a 00                	push   $0x0
  8012c0:	ff 75 08             	pushl  0x8(%ebp)
  8012c3:	e8 e7 01 00 00       	call   8014af <open>
  8012c8:	89 c3                	mov    %eax,%ebx
  8012ca:	83 c4 10             	add    $0x10,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	78 1b                	js     8012ec <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012d1:	83 ec 08             	sub    $0x8,%esp
  8012d4:	ff 75 0c             	pushl  0xc(%ebp)
  8012d7:	50                   	push   %eax
  8012d8:	e8 65 ff ff ff       	call   801242 <fstat>
  8012dd:	89 c6                	mov    %eax,%esi
	close(fd);
  8012df:	89 1c 24             	mov    %ebx,(%esp)
  8012e2:	e8 27 fc ff ff       	call   800f0e <close>
	return r;
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	89 f3                	mov    %esi,%ebx
}
  8012ec:	89 d8                	mov    %ebx,%eax
  8012ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012f1:	5b                   	pop    %ebx
  8012f2:	5e                   	pop    %esi
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    

008012f5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	56                   	push   %esi
  8012f9:	53                   	push   %ebx
  8012fa:	89 c6                	mov    %eax,%esi
  8012fc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8012fe:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801305:	74 27                	je     80132e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801307:	6a 07                	push   $0x7
  801309:	68 00 50 80 00       	push   $0x805000
  80130e:	56                   	push   %esi
  80130f:	ff 35 00 40 80 00    	pushl  0x804000
  801315:	e8 61 07 00 00       	call   801a7b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80131a:	83 c4 0c             	add    $0xc,%esp
  80131d:	6a 00                	push   $0x0
  80131f:	53                   	push   %ebx
  801320:	6a 00                	push   $0x0
  801322:	e8 3d 07 00 00       	call   801a64 <ipc_recv>
}
  801327:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80132a:	5b                   	pop    %ebx
  80132b:	5e                   	pop    %esi
  80132c:	5d                   	pop    %ebp
  80132d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80132e:	83 ec 0c             	sub    $0xc,%esp
  801331:	6a 01                	push   $0x1
  801333:	e8 5a 07 00 00       	call   801a92 <ipc_find_env>
  801338:	a3 00 40 80 00       	mov    %eax,0x804000
  80133d:	83 c4 10             	add    $0x10,%esp
  801340:	eb c5                	jmp    801307 <fsipc+0x12>

00801342 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8b 40 0c             	mov    0xc(%eax),%eax
  80134e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80135b:	ba 00 00 00 00       	mov    $0x0,%edx
  801360:	b8 02 00 00 00       	mov    $0x2,%eax
  801365:	e8 8b ff ff ff       	call   8012f5 <fsipc>
}
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <devfile_flush>:
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8b 40 0c             	mov    0xc(%eax),%eax
  801378:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80137d:	ba 00 00 00 00       	mov    $0x0,%edx
  801382:	b8 06 00 00 00       	mov    $0x6,%eax
  801387:	e8 69 ff ff ff       	call   8012f5 <fsipc>
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <devfile_stat>:
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	53                   	push   %ebx
  801392:	83 ec 04             	sub    $0x4,%esp
  801395:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	8b 40 0c             	mov    0xc(%eax),%eax
  80139e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a8:	b8 05 00 00 00       	mov    $0x5,%eax
  8013ad:	e8 43 ff ff ff       	call   8012f5 <fsipc>
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	78 2c                	js     8013e2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	68 00 50 80 00       	push   $0x805000
  8013be:	53                   	push   %ebx
  8013bf:	e8 b5 f3 ff ff       	call   800779 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013c4:	a1 80 50 80 00       	mov    0x805080,%eax
  8013c9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013cf:	a1 84 50 80 00       	mov    0x805084,%eax
  8013d4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013da:	83 c4 10             	add    $0x10,%esp
  8013dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <devfile_write>:
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 0c             	sub    $0xc,%esp
  8013ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f0:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8013f5:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8013fa:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801400:	8b 52 0c             	mov    0xc(%edx),%edx
  801403:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801409:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  80140e:	50                   	push   %eax
  80140f:	ff 75 0c             	pushl  0xc(%ebp)
  801412:	68 08 50 80 00       	push   $0x805008
  801417:	e8 eb f4 ff ff       	call   800907 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80141c:	ba 00 00 00 00       	mov    $0x0,%edx
  801421:	b8 04 00 00 00       	mov    $0x4,%eax
  801426:	e8 ca fe ff ff       	call   8012f5 <fsipc>
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <devfile_read>:
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	56                   	push   %esi
  801431:	53                   	push   %ebx
  801432:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8b 40 0c             	mov    0xc(%eax),%eax
  80143b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801440:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801446:	ba 00 00 00 00       	mov    $0x0,%edx
  80144b:	b8 03 00 00 00       	mov    $0x3,%eax
  801450:	e8 a0 fe ff ff       	call   8012f5 <fsipc>
  801455:	89 c3                	mov    %eax,%ebx
  801457:	85 c0                	test   %eax,%eax
  801459:	78 1f                	js     80147a <devfile_read+0x4d>
	assert(r <= n);
  80145b:	39 f0                	cmp    %esi,%eax
  80145d:	77 24                	ja     801483 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80145f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801464:	7f 33                	jg     801499 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801466:	83 ec 04             	sub    $0x4,%esp
  801469:	50                   	push   %eax
  80146a:	68 00 50 80 00       	push   $0x805000
  80146f:	ff 75 0c             	pushl  0xc(%ebp)
  801472:	e8 90 f4 ff ff       	call   800907 <memmove>
	return r;
  801477:	83 c4 10             	add    $0x10,%esp
}
  80147a:	89 d8                	mov    %ebx,%eax
  80147c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80147f:	5b                   	pop    %ebx
  801480:	5e                   	pop    %esi
  801481:	5d                   	pop    %ebp
  801482:	c3                   	ret    
	assert(r <= n);
  801483:	68 98 21 80 00       	push   $0x802198
  801488:	68 9f 21 80 00       	push   $0x80219f
  80148d:	6a 7c                	push   $0x7c
  80148f:	68 b4 21 80 00       	push   $0x8021b4
  801494:	e8 85 05 00 00       	call   801a1e <_panic>
	assert(r <= PGSIZE);
  801499:	68 bf 21 80 00       	push   $0x8021bf
  80149e:	68 9f 21 80 00       	push   $0x80219f
  8014a3:	6a 7d                	push   $0x7d
  8014a5:	68 b4 21 80 00       	push   $0x8021b4
  8014aa:	e8 6f 05 00 00       	call   801a1e <_panic>

008014af <open>:
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	56                   	push   %esi
  8014b3:	53                   	push   %ebx
  8014b4:	83 ec 1c             	sub    $0x1c,%esp
  8014b7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014ba:	56                   	push   %esi
  8014bb:	e8 82 f2 ff ff       	call   800742 <strlen>
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014c8:	7f 6c                	jg     801536 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8014ca:	83 ec 0c             	sub    $0xc,%esp
  8014cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d0:	50                   	push   %eax
  8014d1:	e8 b4 f8 ff ff       	call   800d8a <fd_alloc>
  8014d6:	89 c3                	mov    %eax,%ebx
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	78 3c                	js     80151b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8014df:	83 ec 08             	sub    $0x8,%esp
  8014e2:	56                   	push   %esi
  8014e3:	68 00 50 80 00       	push   $0x805000
  8014e8:	e8 8c f2 ff ff       	call   800779 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8014ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8014f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8014fd:	e8 f3 fd ff ff       	call   8012f5 <fsipc>
  801502:	89 c3                	mov    %eax,%ebx
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	85 c0                	test   %eax,%eax
  801509:	78 19                	js     801524 <open+0x75>
	return fd2num(fd);
  80150b:	83 ec 0c             	sub    $0xc,%esp
  80150e:	ff 75 f4             	pushl  -0xc(%ebp)
  801511:	e8 4d f8 ff ff       	call   800d63 <fd2num>
  801516:	89 c3                	mov    %eax,%ebx
  801518:	83 c4 10             	add    $0x10,%esp
}
  80151b:	89 d8                	mov    %ebx,%eax
  80151d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801520:	5b                   	pop    %ebx
  801521:	5e                   	pop    %esi
  801522:	5d                   	pop    %ebp
  801523:	c3                   	ret    
		fd_close(fd, 0);
  801524:	83 ec 08             	sub    $0x8,%esp
  801527:	6a 00                	push   $0x0
  801529:	ff 75 f4             	pushl  -0xc(%ebp)
  80152c:	e8 54 f9 ff ff       	call   800e85 <fd_close>
		return r;
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	eb e5                	jmp    80151b <open+0x6c>
		return -E_BAD_PATH;
  801536:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80153b:	eb de                	jmp    80151b <open+0x6c>

0080153d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801543:	ba 00 00 00 00       	mov    $0x0,%edx
  801548:	b8 08 00 00 00       	mov    $0x8,%eax
  80154d:	e8 a3 fd ff ff       	call   8012f5 <fsipc>
}
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	56                   	push   %esi
  801558:	53                   	push   %ebx
  801559:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80155c:	83 ec 0c             	sub    $0xc,%esp
  80155f:	ff 75 08             	pushl  0x8(%ebp)
  801562:	e8 0c f8 ff ff       	call   800d73 <fd2data>
  801567:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801569:	83 c4 08             	add    $0x8,%esp
  80156c:	68 cb 21 80 00       	push   $0x8021cb
  801571:	53                   	push   %ebx
  801572:	e8 02 f2 ff ff       	call   800779 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801577:	8b 46 04             	mov    0x4(%esi),%eax
  80157a:	2b 06                	sub    (%esi),%eax
  80157c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801582:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801589:	00 00 00 
	stat->st_dev = &devpipe;
  80158c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801593:	30 80 00 
	return 0;
}
  801596:	b8 00 00 00 00       	mov    $0x0,%eax
  80159b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80159e:	5b                   	pop    %ebx
  80159f:	5e                   	pop    %esi
  8015a0:	5d                   	pop    %ebp
  8015a1:	c3                   	ret    

008015a2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	53                   	push   %ebx
  8015a6:	83 ec 0c             	sub    $0xc,%esp
  8015a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8015ac:	53                   	push   %ebx
  8015ad:	6a 00                	push   $0x0
  8015af:	e8 43 f6 ff ff       	call   800bf7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8015b4:	89 1c 24             	mov    %ebx,(%esp)
  8015b7:	e8 b7 f7 ff ff       	call   800d73 <fd2data>
  8015bc:	83 c4 08             	add    $0x8,%esp
  8015bf:	50                   	push   %eax
  8015c0:	6a 00                	push   $0x0
  8015c2:	e8 30 f6 ff ff       	call   800bf7 <sys_page_unmap>
}
  8015c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <_pipeisclosed>:
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	57                   	push   %edi
  8015d0:	56                   	push   %esi
  8015d1:	53                   	push   %ebx
  8015d2:	83 ec 1c             	sub    $0x1c,%esp
  8015d5:	89 c7                	mov    %eax,%edi
  8015d7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8015d9:	a1 04 40 80 00       	mov    0x804004,%eax
  8015de:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8015e1:	83 ec 0c             	sub    $0xc,%esp
  8015e4:	57                   	push   %edi
  8015e5:	e8 e1 04 00 00       	call   801acb <pageref>
  8015ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015ed:	89 34 24             	mov    %esi,(%esp)
  8015f0:	e8 d6 04 00 00       	call   801acb <pageref>
		nn = thisenv->env_runs;
  8015f5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8015fb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	39 cb                	cmp    %ecx,%ebx
  801603:	74 1b                	je     801620 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801605:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801608:	75 cf                	jne    8015d9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80160a:	8b 42 58             	mov    0x58(%edx),%eax
  80160d:	6a 01                	push   $0x1
  80160f:	50                   	push   %eax
  801610:	53                   	push   %ebx
  801611:	68 d2 21 80 00       	push   $0x8021d2
  801616:	e8 74 eb ff ff       	call   80018f <cprintf>
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	eb b9                	jmp    8015d9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801620:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801623:	0f 94 c0             	sete   %al
  801626:	0f b6 c0             	movzbl %al,%eax
}
  801629:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162c:	5b                   	pop    %ebx
  80162d:	5e                   	pop    %esi
  80162e:	5f                   	pop    %edi
  80162f:	5d                   	pop    %ebp
  801630:	c3                   	ret    

00801631 <devpipe_write>:
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	57                   	push   %edi
  801635:	56                   	push   %esi
  801636:	53                   	push   %ebx
  801637:	83 ec 28             	sub    $0x28,%esp
  80163a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80163d:	56                   	push   %esi
  80163e:	e8 30 f7 ff ff       	call   800d73 <fd2data>
  801643:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801645:	83 c4 10             	add    $0x10,%esp
  801648:	bf 00 00 00 00       	mov    $0x0,%edi
  80164d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801650:	74 4f                	je     8016a1 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801652:	8b 43 04             	mov    0x4(%ebx),%eax
  801655:	8b 0b                	mov    (%ebx),%ecx
  801657:	8d 51 20             	lea    0x20(%ecx),%edx
  80165a:	39 d0                	cmp    %edx,%eax
  80165c:	72 14                	jb     801672 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80165e:	89 da                	mov    %ebx,%edx
  801660:	89 f0                	mov    %esi,%eax
  801662:	e8 65 ff ff ff       	call   8015cc <_pipeisclosed>
  801667:	85 c0                	test   %eax,%eax
  801669:	75 3a                	jne    8016a5 <devpipe_write+0x74>
			sys_yield();
  80166b:	e8 e3 f4 ff ff       	call   800b53 <sys_yield>
  801670:	eb e0                	jmp    801652 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801672:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801675:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801679:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80167c:	89 c2                	mov    %eax,%edx
  80167e:	c1 fa 1f             	sar    $0x1f,%edx
  801681:	89 d1                	mov    %edx,%ecx
  801683:	c1 e9 1b             	shr    $0x1b,%ecx
  801686:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801689:	83 e2 1f             	and    $0x1f,%edx
  80168c:	29 ca                	sub    %ecx,%edx
  80168e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801692:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801696:	83 c0 01             	add    $0x1,%eax
  801699:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80169c:	83 c7 01             	add    $0x1,%edi
  80169f:	eb ac                	jmp    80164d <devpipe_write+0x1c>
	return i;
  8016a1:	89 f8                	mov    %edi,%eax
  8016a3:	eb 05                	jmp    8016aa <devpipe_write+0x79>
				return 0;
  8016a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ad:	5b                   	pop    %ebx
  8016ae:	5e                   	pop    %esi
  8016af:	5f                   	pop    %edi
  8016b0:	5d                   	pop    %ebp
  8016b1:	c3                   	ret    

008016b2 <devpipe_read>:
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	57                   	push   %edi
  8016b6:	56                   	push   %esi
  8016b7:	53                   	push   %ebx
  8016b8:	83 ec 18             	sub    $0x18,%esp
  8016bb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8016be:	57                   	push   %edi
  8016bf:	e8 af f6 ff ff       	call   800d73 <fd2data>
  8016c4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	be 00 00 00 00       	mov    $0x0,%esi
  8016ce:	3b 75 10             	cmp    0x10(%ebp),%esi
  8016d1:	74 47                	je     80171a <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8016d3:	8b 03                	mov    (%ebx),%eax
  8016d5:	3b 43 04             	cmp    0x4(%ebx),%eax
  8016d8:	75 22                	jne    8016fc <devpipe_read+0x4a>
			if (i > 0)
  8016da:	85 f6                	test   %esi,%esi
  8016dc:	75 14                	jne    8016f2 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8016de:	89 da                	mov    %ebx,%edx
  8016e0:	89 f8                	mov    %edi,%eax
  8016e2:	e8 e5 fe ff ff       	call   8015cc <_pipeisclosed>
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	75 33                	jne    80171e <devpipe_read+0x6c>
			sys_yield();
  8016eb:	e8 63 f4 ff ff       	call   800b53 <sys_yield>
  8016f0:	eb e1                	jmp    8016d3 <devpipe_read+0x21>
				return i;
  8016f2:	89 f0                	mov    %esi,%eax
}
  8016f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f7:	5b                   	pop    %ebx
  8016f8:	5e                   	pop    %esi
  8016f9:	5f                   	pop    %edi
  8016fa:	5d                   	pop    %ebp
  8016fb:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8016fc:	99                   	cltd   
  8016fd:	c1 ea 1b             	shr    $0x1b,%edx
  801700:	01 d0                	add    %edx,%eax
  801702:	83 e0 1f             	and    $0x1f,%eax
  801705:	29 d0                	sub    %edx,%eax
  801707:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80170c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80170f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801712:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801715:	83 c6 01             	add    $0x1,%esi
  801718:	eb b4                	jmp    8016ce <devpipe_read+0x1c>
	return i;
  80171a:	89 f0                	mov    %esi,%eax
  80171c:	eb d6                	jmp    8016f4 <devpipe_read+0x42>
				return 0;
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
  801723:	eb cf                	jmp    8016f4 <devpipe_read+0x42>

00801725 <pipe>:
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	56                   	push   %esi
  801729:	53                   	push   %ebx
  80172a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80172d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801730:	50                   	push   %eax
  801731:	e8 54 f6 ff ff       	call   800d8a <fd_alloc>
  801736:	89 c3                	mov    %eax,%ebx
  801738:	83 c4 10             	add    $0x10,%esp
  80173b:	85 c0                	test   %eax,%eax
  80173d:	78 5b                	js     80179a <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	68 07 04 00 00       	push   $0x407
  801747:	ff 75 f4             	pushl  -0xc(%ebp)
  80174a:	6a 00                	push   $0x0
  80174c:	e8 21 f4 ff ff       	call   800b72 <sys_page_alloc>
  801751:	89 c3                	mov    %eax,%ebx
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	85 c0                	test   %eax,%eax
  801758:	78 40                	js     80179a <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80175a:	83 ec 0c             	sub    $0xc,%esp
  80175d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801760:	50                   	push   %eax
  801761:	e8 24 f6 ff ff       	call   800d8a <fd_alloc>
  801766:	89 c3                	mov    %eax,%ebx
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	85 c0                	test   %eax,%eax
  80176d:	78 1b                	js     80178a <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	68 07 04 00 00       	push   $0x407
  801777:	ff 75 f0             	pushl  -0x10(%ebp)
  80177a:	6a 00                	push   $0x0
  80177c:	e8 f1 f3 ff ff       	call   800b72 <sys_page_alloc>
  801781:	89 c3                	mov    %eax,%ebx
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	85 c0                	test   %eax,%eax
  801788:	79 19                	jns    8017a3 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	ff 75 f4             	pushl  -0xc(%ebp)
  801790:	6a 00                	push   $0x0
  801792:	e8 60 f4 ff ff       	call   800bf7 <sys_page_unmap>
  801797:	83 c4 10             	add    $0x10,%esp
}
  80179a:	89 d8                	mov    %ebx,%eax
  80179c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80179f:	5b                   	pop    %ebx
  8017a0:	5e                   	pop    %esi
  8017a1:	5d                   	pop    %ebp
  8017a2:	c3                   	ret    
	va = fd2data(fd0);
  8017a3:	83 ec 0c             	sub    $0xc,%esp
  8017a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a9:	e8 c5 f5 ff ff       	call   800d73 <fd2data>
  8017ae:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017b0:	83 c4 0c             	add    $0xc,%esp
  8017b3:	68 07 04 00 00       	push   $0x407
  8017b8:	50                   	push   %eax
  8017b9:	6a 00                	push   $0x0
  8017bb:	e8 b2 f3 ff ff       	call   800b72 <sys_page_alloc>
  8017c0:	89 c3                	mov    %eax,%ebx
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	0f 88 8c 00 00 00    	js     801859 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017cd:	83 ec 0c             	sub    $0xc,%esp
  8017d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8017d3:	e8 9b f5 ff ff       	call   800d73 <fd2data>
  8017d8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017df:	50                   	push   %eax
  8017e0:	6a 00                	push   $0x0
  8017e2:	56                   	push   %esi
  8017e3:	6a 00                	push   $0x0
  8017e5:	e8 cb f3 ff ff       	call   800bb5 <sys_page_map>
  8017ea:	89 c3                	mov    %eax,%ebx
  8017ec:	83 c4 20             	add    $0x20,%esp
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	78 58                	js     80184b <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f6:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017fc:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8017fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801801:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801811:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801816:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80181d:	83 ec 0c             	sub    $0xc,%esp
  801820:	ff 75 f4             	pushl  -0xc(%ebp)
  801823:	e8 3b f5 ff ff       	call   800d63 <fd2num>
  801828:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80182b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80182d:	83 c4 04             	add    $0x4,%esp
  801830:	ff 75 f0             	pushl  -0x10(%ebp)
  801833:	e8 2b f5 ff ff       	call   800d63 <fd2num>
  801838:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80183b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	bb 00 00 00 00       	mov    $0x0,%ebx
  801846:	e9 4f ff ff ff       	jmp    80179a <pipe+0x75>
	sys_page_unmap(0, va);
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	56                   	push   %esi
  80184f:	6a 00                	push   $0x0
  801851:	e8 a1 f3 ff ff       	call   800bf7 <sys_page_unmap>
  801856:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	ff 75 f0             	pushl  -0x10(%ebp)
  80185f:	6a 00                	push   $0x0
  801861:	e8 91 f3 ff ff       	call   800bf7 <sys_page_unmap>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	e9 1c ff ff ff       	jmp    80178a <pipe+0x65>

0080186e <pipeisclosed>:
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801874:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801877:	50                   	push   %eax
  801878:	ff 75 08             	pushl  0x8(%ebp)
  80187b:	e8 59 f5 ff ff       	call   800dd9 <fd_lookup>
  801880:	83 c4 10             	add    $0x10,%esp
  801883:	85 c0                	test   %eax,%eax
  801885:	78 18                	js     80189f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801887:	83 ec 0c             	sub    $0xc,%esp
  80188a:	ff 75 f4             	pushl  -0xc(%ebp)
  80188d:	e8 e1 f4 ff ff       	call   800d73 <fd2data>
	return _pipeisclosed(fd, p);
  801892:	89 c2                	mov    %eax,%edx
  801894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801897:	e8 30 fd ff ff       	call   8015cc <_pipeisclosed>
  80189c:	83 c4 10             	add    $0x10,%esp
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8018a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a9:	5d                   	pop    %ebp
  8018aa:	c3                   	ret    

008018ab <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8018b1:	68 ea 21 80 00       	push   $0x8021ea
  8018b6:	ff 75 0c             	pushl  0xc(%ebp)
  8018b9:	e8 bb ee ff ff       	call   800779 <strcpy>
	return 0;
}
  8018be:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <devcons_write>:
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	57                   	push   %edi
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
  8018cb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8018d1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8018d6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8018dc:	eb 2f                	jmp    80190d <devcons_write+0x48>
		m = n - tot;
  8018de:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018e1:	29 f3                	sub    %esi,%ebx
  8018e3:	83 fb 7f             	cmp    $0x7f,%ebx
  8018e6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8018eb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	53                   	push   %ebx
  8018f2:	89 f0                	mov    %esi,%eax
  8018f4:	03 45 0c             	add    0xc(%ebp),%eax
  8018f7:	50                   	push   %eax
  8018f8:	57                   	push   %edi
  8018f9:	e8 09 f0 ff ff       	call   800907 <memmove>
		sys_cputs(buf, m);
  8018fe:	83 c4 08             	add    $0x8,%esp
  801901:	53                   	push   %ebx
  801902:	57                   	push   %edi
  801903:	e8 ae f1 ff ff       	call   800ab6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801908:	01 de                	add    %ebx,%esi
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801910:	72 cc                	jb     8018de <devcons_write+0x19>
}
  801912:	89 f0                	mov    %esi,%eax
  801914:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801917:	5b                   	pop    %ebx
  801918:	5e                   	pop    %esi
  801919:	5f                   	pop    %edi
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    

0080191c <devcons_read>:
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
  801922:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801927:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192b:	75 07                	jne    801934 <devcons_read+0x18>
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    
		sys_yield();
  80192f:	e8 1f f2 ff ff       	call   800b53 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801934:	e8 9b f1 ff ff       	call   800ad4 <sys_cgetc>
  801939:	85 c0                	test   %eax,%eax
  80193b:	74 f2                	je     80192f <devcons_read+0x13>
	if (c < 0)
  80193d:	85 c0                	test   %eax,%eax
  80193f:	78 ec                	js     80192d <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801941:	83 f8 04             	cmp    $0x4,%eax
  801944:	74 0c                	je     801952 <devcons_read+0x36>
	*(char*)vbuf = c;
  801946:	8b 55 0c             	mov    0xc(%ebp),%edx
  801949:	88 02                	mov    %al,(%edx)
	return 1;
  80194b:	b8 01 00 00 00       	mov    $0x1,%eax
  801950:	eb db                	jmp    80192d <devcons_read+0x11>
		return 0;
  801952:	b8 00 00 00 00       	mov    $0x0,%eax
  801957:	eb d4                	jmp    80192d <devcons_read+0x11>

00801959 <cputchar>:
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801965:	6a 01                	push   $0x1
  801967:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80196a:	50                   	push   %eax
  80196b:	e8 46 f1 ff ff       	call   800ab6 <sys_cputs>
}
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <getchar>:
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80197b:	6a 01                	push   $0x1
  80197d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801980:	50                   	push   %eax
  801981:	6a 00                	push   $0x0
  801983:	e8 c2 f6 ff ff       	call   80104a <read>
	if (r < 0)
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	85 c0                	test   %eax,%eax
  80198d:	78 08                	js     801997 <getchar+0x22>
	if (r < 1)
  80198f:	85 c0                	test   %eax,%eax
  801991:	7e 06                	jle    801999 <getchar+0x24>
	return c;
  801993:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    
		return -E_EOF;
  801999:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80199e:	eb f7                	jmp    801997 <getchar+0x22>

008019a0 <iscons>:
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a9:	50                   	push   %eax
  8019aa:	ff 75 08             	pushl  0x8(%ebp)
  8019ad:	e8 27 f4 ff ff       	call   800dd9 <fd_lookup>
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	78 11                	js     8019ca <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8019b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bc:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019c2:	39 10                	cmp    %edx,(%eax)
  8019c4:	0f 94 c0             	sete   %al
  8019c7:	0f b6 c0             	movzbl %al,%eax
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <opencons>:
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8019d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d5:	50                   	push   %eax
  8019d6:	e8 af f3 ff ff       	call   800d8a <fd_alloc>
  8019db:	83 c4 10             	add    $0x10,%esp
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 3a                	js     801a1c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019e2:	83 ec 04             	sub    $0x4,%esp
  8019e5:	68 07 04 00 00       	push   $0x407
  8019ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ed:	6a 00                	push   $0x0
  8019ef:	e8 7e f1 ff ff       	call   800b72 <sys_page_alloc>
  8019f4:	83 c4 10             	add    $0x10,%esp
  8019f7:	85 c0                	test   %eax,%eax
  8019f9:	78 21                	js     801a1c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8019fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fe:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a04:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a09:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a10:	83 ec 0c             	sub    $0xc,%esp
  801a13:	50                   	push   %eax
  801a14:	e8 4a f3 ff ff       	call   800d63 <fd2num>
  801a19:	83 c4 10             	add    $0x10,%esp
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	56                   	push   %esi
  801a22:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801a23:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a26:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801a2c:	e8 03 f1 ff ff       	call   800b34 <sys_getenvid>
  801a31:	83 ec 0c             	sub    $0xc,%esp
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	56                   	push   %esi
  801a3b:	50                   	push   %eax
  801a3c:	68 f8 21 80 00       	push   $0x8021f8
  801a41:	e8 49 e7 ff ff       	call   80018f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a46:	83 c4 18             	add    $0x18,%esp
  801a49:	53                   	push   %ebx
  801a4a:	ff 75 10             	pushl  0x10(%ebp)
  801a4d:	e8 ec e6 ff ff       	call   80013e <vcprintf>
	cprintf("\n");
  801a52:	c7 04 24 e3 21 80 00 	movl   $0x8021e3,(%esp)
  801a59:	e8 31 e7 ff ff       	call   80018f <cprintf>
  801a5e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a61:	cc                   	int3   
  801a62:	eb fd                	jmp    801a61 <_panic+0x43>

00801a64 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801a6a:	68 1c 22 80 00       	push   $0x80221c
  801a6f:	6a 1a                	push   $0x1a
  801a71:	68 35 22 80 00       	push   $0x802235
  801a76:	e8 a3 ff ff ff       	call   801a1e <_panic>

00801a7b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801a81:	68 3f 22 80 00       	push   $0x80223f
  801a86:	6a 2a                	push   $0x2a
  801a88:	68 35 22 80 00       	push   $0x802235
  801a8d:	e8 8c ff ff ff       	call   801a1e <_panic>

00801a92 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a98:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a9d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801aa0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801aa6:	8b 52 50             	mov    0x50(%edx),%edx
  801aa9:	39 ca                	cmp    %ecx,%edx
  801aab:	74 11                	je     801abe <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801aad:	83 c0 01             	add    $0x1,%eax
  801ab0:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ab5:	75 e6                	jne    801a9d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801ab7:	b8 00 00 00 00       	mov    $0x0,%eax
  801abc:	eb 0b                	jmp    801ac9 <ipc_find_env+0x37>
			return envs[i].env_id;
  801abe:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ac1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ac6:	8b 40 48             	mov    0x48(%eax),%eax
}
  801ac9:	5d                   	pop    %ebp
  801aca:	c3                   	ret    

00801acb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ad1:	89 d0                	mov    %edx,%eax
  801ad3:	c1 e8 16             	shr    $0x16,%eax
  801ad6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801add:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ae2:	f6 c1 01             	test   $0x1,%cl
  801ae5:	74 1d                	je     801b04 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ae7:	c1 ea 0c             	shr    $0xc,%edx
  801aea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801af1:	f6 c2 01             	test   $0x1,%dl
  801af4:	74 0e                	je     801b04 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801af6:	c1 ea 0c             	shr    $0xc,%edx
  801af9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801b00:	ef 
  801b01:	0f b7 c0             	movzwl %ax,%eax
}
  801b04:	5d                   	pop    %ebp
  801b05:	c3                   	ret    
  801b06:	66 90                	xchg   %ax,%ax
  801b08:	66 90                	xchg   %ax,%ax
  801b0a:	66 90                	xchg   %ax,%ax
  801b0c:	66 90                	xchg   %ax,%ax
  801b0e:	66 90                	xchg   %ax,%ax

00801b10 <__udivdi3>:
  801b10:	55                   	push   %ebp
  801b11:	57                   	push   %edi
  801b12:	56                   	push   %esi
  801b13:	53                   	push   %ebx
  801b14:	83 ec 1c             	sub    $0x1c,%esp
  801b17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801b1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801b1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801b27:	85 d2                	test   %edx,%edx
  801b29:	75 35                	jne    801b60 <__udivdi3+0x50>
  801b2b:	39 f3                	cmp    %esi,%ebx
  801b2d:	0f 87 bd 00 00 00    	ja     801bf0 <__udivdi3+0xe0>
  801b33:	85 db                	test   %ebx,%ebx
  801b35:	89 d9                	mov    %ebx,%ecx
  801b37:	75 0b                	jne    801b44 <__udivdi3+0x34>
  801b39:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3e:	31 d2                	xor    %edx,%edx
  801b40:	f7 f3                	div    %ebx
  801b42:	89 c1                	mov    %eax,%ecx
  801b44:	31 d2                	xor    %edx,%edx
  801b46:	89 f0                	mov    %esi,%eax
  801b48:	f7 f1                	div    %ecx
  801b4a:	89 c6                	mov    %eax,%esi
  801b4c:	89 e8                	mov    %ebp,%eax
  801b4e:	89 f7                	mov    %esi,%edi
  801b50:	f7 f1                	div    %ecx
  801b52:	89 fa                	mov    %edi,%edx
  801b54:	83 c4 1c             	add    $0x1c,%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5f                   	pop    %edi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    
  801b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801b60:	39 f2                	cmp    %esi,%edx
  801b62:	77 7c                	ja     801be0 <__udivdi3+0xd0>
  801b64:	0f bd fa             	bsr    %edx,%edi
  801b67:	83 f7 1f             	xor    $0x1f,%edi
  801b6a:	0f 84 98 00 00 00    	je     801c08 <__udivdi3+0xf8>
  801b70:	89 f9                	mov    %edi,%ecx
  801b72:	b8 20 00 00 00       	mov    $0x20,%eax
  801b77:	29 f8                	sub    %edi,%eax
  801b79:	d3 e2                	shl    %cl,%edx
  801b7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b7f:	89 c1                	mov    %eax,%ecx
  801b81:	89 da                	mov    %ebx,%edx
  801b83:	d3 ea                	shr    %cl,%edx
  801b85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801b89:	09 d1                	or     %edx,%ecx
  801b8b:	89 f2                	mov    %esi,%edx
  801b8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b91:	89 f9                	mov    %edi,%ecx
  801b93:	d3 e3                	shl    %cl,%ebx
  801b95:	89 c1                	mov    %eax,%ecx
  801b97:	d3 ea                	shr    %cl,%edx
  801b99:	89 f9                	mov    %edi,%ecx
  801b9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801b9f:	d3 e6                	shl    %cl,%esi
  801ba1:	89 eb                	mov    %ebp,%ebx
  801ba3:	89 c1                	mov    %eax,%ecx
  801ba5:	d3 eb                	shr    %cl,%ebx
  801ba7:	09 de                	or     %ebx,%esi
  801ba9:	89 f0                	mov    %esi,%eax
  801bab:	f7 74 24 08          	divl   0x8(%esp)
  801baf:	89 d6                	mov    %edx,%esi
  801bb1:	89 c3                	mov    %eax,%ebx
  801bb3:	f7 64 24 0c          	mull   0xc(%esp)
  801bb7:	39 d6                	cmp    %edx,%esi
  801bb9:	72 0c                	jb     801bc7 <__udivdi3+0xb7>
  801bbb:	89 f9                	mov    %edi,%ecx
  801bbd:	d3 e5                	shl    %cl,%ebp
  801bbf:	39 c5                	cmp    %eax,%ebp
  801bc1:	73 5d                	jae    801c20 <__udivdi3+0x110>
  801bc3:	39 d6                	cmp    %edx,%esi
  801bc5:	75 59                	jne    801c20 <__udivdi3+0x110>
  801bc7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bca:	31 ff                	xor    %edi,%edi
  801bcc:	89 fa                	mov    %edi,%edx
  801bce:	83 c4 1c             	add    $0x1c,%esp
  801bd1:	5b                   	pop    %ebx
  801bd2:	5e                   	pop    %esi
  801bd3:	5f                   	pop    %edi
  801bd4:	5d                   	pop    %ebp
  801bd5:	c3                   	ret    
  801bd6:	8d 76 00             	lea    0x0(%esi),%esi
  801bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801be0:	31 ff                	xor    %edi,%edi
  801be2:	31 c0                	xor    %eax,%eax
  801be4:	89 fa                	mov    %edi,%edx
  801be6:	83 c4 1c             	add    $0x1c,%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5e                   	pop    %esi
  801beb:	5f                   	pop    %edi
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    
  801bee:	66 90                	xchg   %ax,%ax
  801bf0:	31 ff                	xor    %edi,%edi
  801bf2:	89 e8                	mov    %ebp,%eax
  801bf4:	89 f2                	mov    %esi,%edx
  801bf6:	f7 f3                	div    %ebx
  801bf8:	89 fa                	mov    %edi,%edx
  801bfa:	83 c4 1c             	add    $0x1c,%esp
  801bfd:	5b                   	pop    %ebx
  801bfe:	5e                   	pop    %esi
  801bff:	5f                   	pop    %edi
  801c00:	5d                   	pop    %ebp
  801c01:	c3                   	ret    
  801c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c08:	39 f2                	cmp    %esi,%edx
  801c0a:	72 06                	jb     801c12 <__udivdi3+0x102>
  801c0c:	31 c0                	xor    %eax,%eax
  801c0e:	39 eb                	cmp    %ebp,%ebx
  801c10:	77 d2                	ja     801be4 <__udivdi3+0xd4>
  801c12:	b8 01 00 00 00       	mov    $0x1,%eax
  801c17:	eb cb                	jmp    801be4 <__udivdi3+0xd4>
  801c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c20:	89 d8                	mov    %ebx,%eax
  801c22:	31 ff                	xor    %edi,%edi
  801c24:	eb be                	jmp    801be4 <__udivdi3+0xd4>
  801c26:	66 90                	xchg   %ax,%ax
  801c28:	66 90                	xchg   %ax,%ax
  801c2a:	66 90                	xchg   %ax,%ax
  801c2c:	66 90                	xchg   %ax,%ax
  801c2e:	66 90                	xchg   %ax,%ax

00801c30 <__umoddi3>:
  801c30:	55                   	push   %ebp
  801c31:	57                   	push   %edi
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	83 ec 1c             	sub    $0x1c,%esp
  801c37:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801c3b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801c3f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801c43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c47:	85 ed                	test   %ebp,%ebp
  801c49:	89 f0                	mov    %esi,%eax
  801c4b:	89 da                	mov    %ebx,%edx
  801c4d:	75 19                	jne    801c68 <__umoddi3+0x38>
  801c4f:	39 df                	cmp    %ebx,%edi
  801c51:	0f 86 b1 00 00 00    	jbe    801d08 <__umoddi3+0xd8>
  801c57:	f7 f7                	div    %edi
  801c59:	89 d0                	mov    %edx,%eax
  801c5b:	31 d2                	xor    %edx,%edx
  801c5d:	83 c4 1c             	add    $0x1c,%esp
  801c60:	5b                   	pop    %ebx
  801c61:	5e                   	pop    %esi
  801c62:	5f                   	pop    %edi
  801c63:	5d                   	pop    %ebp
  801c64:	c3                   	ret    
  801c65:	8d 76 00             	lea    0x0(%esi),%esi
  801c68:	39 dd                	cmp    %ebx,%ebp
  801c6a:	77 f1                	ja     801c5d <__umoddi3+0x2d>
  801c6c:	0f bd cd             	bsr    %ebp,%ecx
  801c6f:	83 f1 1f             	xor    $0x1f,%ecx
  801c72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c76:	0f 84 b4 00 00 00    	je     801d30 <__umoddi3+0x100>
  801c7c:	b8 20 00 00 00       	mov    $0x20,%eax
  801c81:	89 c2                	mov    %eax,%edx
  801c83:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c87:	29 c2                	sub    %eax,%edx
  801c89:	89 c1                	mov    %eax,%ecx
  801c8b:	89 f8                	mov    %edi,%eax
  801c8d:	d3 e5                	shl    %cl,%ebp
  801c8f:	89 d1                	mov    %edx,%ecx
  801c91:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c95:	d3 e8                	shr    %cl,%eax
  801c97:	09 c5                	or     %eax,%ebp
  801c99:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c9d:	89 c1                	mov    %eax,%ecx
  801c9f:	d3 e7                	shl    %cl,%edi
  801ca1:	89 d1                	mov    %edx,%ecx
  801ca3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801ca7:	89 df                	mov    %ebx,%edi
  801ca9:	d3 ef                	shr    %cl,%edi
  801cab:	89 c1                	mov    %eax,%ecx
  801cad:	89 f0                	mov    %esi,%eax
  801caf:	d3 e3                	shl    %cl,%ebx
  801cb1:	89 d1                	mov    %edx,%ecx
  801cb3:	89 fa                	mov    %edi,%edx
  801cb5:	d3 e8                	shr    %cl,%eax
  801cb7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801cbc:	09 d8                	or     %ebx,%eax
  801cbe:	f7 f5                	div    %ebp
  801cc0:	d3 e6                	shl    %cl,%esi
  801cc2:	89 d1                	mov    %edx,%ecx
  801cc4:	f7 64 24 08          	mull   0x8(%esp)
  801cc8:	39 d1                	cmp    %edx,%ecx
  801cca:	89 c3                	mov    %eax,%ebx
  801ccc:	89 d7                	mov    %edx,%edi
  801cce:	72 06                	jb     801cd6 <__umoddi3+0xa6>
  801cd0:	75 0e                	jne    801ce0 <__umoddi3+0xb0>
  801cd2:	39 c6                	cmp    %eax,%esi
  801cd4:	73 0a                	jae    801ce0 <__umoddi3+0xb0>
  801cd6:	2b 44 24 08          	sub    0x8(%esp),%eax
  801cda:	19 ea                	sbb    %ebp,%edx
  801cdc:	89 d7                	mov    %edx,%edi
  801cde:	89 c3                	mov    %eax,%ebx
  801ce0:	89 ca                	mov    %ecx,%edx
  801ce2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801ce7:	29 de                	sub    %ebx,%esi
  801ce9:	19 fa                	sbb    %edi,%edx
  801ceb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801cef:	89 d0                	mov    %edx,%eax
  801cf1:	d3 e0                	shl    %cl,%eax
  801cf3:	89 d9                	mov    %ebx,%ecx
  801cf5:	d3 ee                	shr    %cl,%esi
  801cf7:	d3 ea                	shr    %cl,%edx
  801cf9:	09 f0                	or     %esi,%eax
  801cfb:	83 c4 1c             	add    $0x1c,%esp
  801cfe:	5b                   	pop    %ebx
  801cff:	5e                   	pop    %esi
  801d00:	5f                   	pop    %edi
  801d01:	5d                   	pop    %ebp
  801d02:	c3                   	ret    
  801d03:	90                   	nop
  801d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d08:	85 ff                	test   %edi,%edi
  801d0a:	89 f9                	mov    %edi,%ecx
  801d0c:	75 0b                	jne    801d19 <__umoddi3+0xe9>
  801d0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d13:	31 d2                	xor    %edx,%edx
  801d15:	f7 f7                	div    %edi
  801d17:	89 c1                	mov    %eax,%ecx
  801d19:	89 d8                	mov    %ebx,%eax
  801d1b:	31 d2                	xor    %edx,%edx
  801d1d:	f7 f1                	div    %ecx
  801d1f:	89 f0                	mov    %esi,%eax
  801d21:	f7 f1                	div    %ecx
  801d23:	e9 31 ff ff ff       	jmp    801c59 <__umoddi3+0x29>
  801d28:	90                   	nop
  801d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d30:	39 dd                	cmp    %ebx,%ebp
  801d32:	72 08                	jb     801d3c <__umoddi3+0x10c>
  801d34:	39 f7                	cmp    %esi,%edi
  801d36:	0f 87 21 ff ff ff    	ja     801c5d <__umoddi3+0x2d>
  801d3c:	89 da                	mov    %ebx,%edx
  801d3e:	89 f0                	mov    %esi,%eax
  801d40:	29 f8                	sub    %edi,%eax
  801d42:	19 ea                	sbb    %ebp,%edx
  801d44:	e9 14 ff ff ff       	jmp    801c5d <__umoddi3+0x2d>
