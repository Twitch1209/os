
obj/user/faultdie.debug：     文件格式 elf32-i386


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
  80002c:	e8 4f 00 00 00       	call   800080 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
  800039:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  80003c:	8b 42 04             	mov    0x4(%edx),%eax
  80003f:	83 e0 07             	and    $0x7,%eax
  800042:	50                   	push   %eax
  800043:	ff 32                	pushl  (%edx)
  800045:	68 e0 1d 80 00       	push   $0x801de0
  80004a:	e8 26 01 00 00       	call   800175 <cprintf>
	sys_env_destroy(sys_getenvid());
  80004f:	e8 c6 0a 00 00       	call   800b1a <sys_getenvid>
  800054:	89 04 24             	mov    %eax,(%esp)
  800057:	e8 7d 0a 00 00       	call   800ad9 <sys_env_destroy>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    

00800061 <umain>:

void
umain(int argc, char **argv)
{
  800061:	55                   	push   %ebp
  800062:	89 e5                	mov    %esp,%ebp
  800064:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800067:	68 33 00 80 00       	push   $0x800033
  80006c:	e8 d8 0c 00 00       	call   800d49 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800071:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800078:	00 00 00 
}
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	c9                   	leave  
  80007f:	c3                   	ret    

00800080 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	56                   	push   %esi
  800084:	53                   	push   %ebx
  800085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800088:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80008b:	e8 8a 0a 00 00       	call   800b1a <sys_getenvid>
  800090:	25 ff 03 00 00       	and    $0x3ff,%eax
  800095:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800098:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009d:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a2:	85 db                	test   %ebx,%ebx
  8000a4:	7e 07                	jle    8000ad <libmain+0x2d>
		binaryname = argv[0];
  8000a6:	8b 06                	mov    (%esi),%eax
  8000a8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	56                   	push   %esi
  8000b1:	53                   	push   %ebx
  8000b2:	e8 aa ff ff ff       	call   800061 <umain>

	// exit gracefully
	exit();
  8000b7:	e8 0a 00 00 00       	call   8000c6 <exit>
}
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c2:	5b                   	pop    %ebx
  8000c3:	5e                   	pop    %esi
  8000c4:	5d                   	pop    %ebp
  8000c5:	c3                   	ret    

008000c6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000cc:	e8 e9 0e 00 00       	call   800fba <close_all>
	sys_env_destroy(0);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	6a 00                	push   $0x0
  8000d6:	e8 fe 09 00 00       	call   800ad9 <sys_env_destroy>
}
  8000db:	83 c4 10             	add    $0x10,%esp
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	53                   	push   %ebx
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ea:	8b 13                	mov    (%ebx),%edx
  8000ec:	8d 42 01             	lea    0x1(%edx),%eax
  8000ef:	89 03                	mov    %eax,(%ebx)
  8000f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000f4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000fd:	74 09                	je     800108 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ff:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800103:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800106:	c9                   	leave  
  800107:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800108:	83 ec 08             	sub    $0x8,%esp
  80010b:	68 ff 00 00 00       	push   $0xff
  800110:	8d 43 08             	lea    0x8(%ebx),%eax
  800113:	50                   	push   %eax
  800114:	e8 83 09 00 00       	call   800a9c <sys_cputs>
		b->idx = 0;
  800119:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	eb db                	jmp    8000ff <putch+0x1f>

00800124 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80012d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800134:	00 00 00 
	b.cnt = 0;
  800137:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80013e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800141:	ff 75 0c             	pushl  0xc(%ebp)
  800144:	ff 75 08             	pushl  0x8(%ebp)
  800147:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80014d:	50                   	push   %eax
  80014e:	68 e0 00 80 00       	push   $0x8000e0
  800153:	e8 1a 01 00 00       	call   800272 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800158:	83 c4 08             	add    $0x8,%esp
  80015b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800161:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800167:	50                   	push   %eax
  800168:	e8 2f 09 00 00       	call   800a9c <sys_cputs>

	return b.cnt;
}
  80016d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800173:	c9                   	leave  
  800174:	c3                   	ret    

00800175 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80017b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80017e:	50                   	push   %eax
  80017f:	ff 75 08             	pushl  0x8(%ebp)
  800182:	e8 9d ff ff ff       	call   800124 <vcprintf>
	va_end(ap);

	return cnt;
}
  800187:	c9                   	leave  
  800188:	c3                   	ret    

00800189 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800189:	55                   	push   %ebp
  80018a:	89 e5                	mov    %esp,%ebp
  80018c:	57                   	push   %edi
  80018d:	56                   	push   %esi
  80018e:	53                   	push   %ebx
  80018f:	83 ec 1c             	sub    $0x1c,%esp
  800192:	89 c7                	mov    %eax,%edi
  800194:	89 d6                	mov    %edx,%esi
  800196:	8b 45 08             	mov    0x8(%ebp),%eax
  800199:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001aa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ad:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001b0:	39 d3                	cmp    %edx,%ebx
  8001b2:	72 05                	jb     8001b9 <printnum+0x30>
  8001b4:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001b7:	77 7a                	ja     800233 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	ff 75 18             	pushl  0x18(%ebp)
  8001bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8001c2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001c5:	53                   	push   %ebx
  8001c6:	ff 75 10             	pushl  0x10(%ebp)
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8001d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001d8:	e8 b3 19 00 00       	call   801b90 <__udivdi3>
  8001dd:	83 c4 18             	add    $0x18,%esp
  8001e0:	52                   	push   %edx
  8001e1:	50                   	push   %eax
  8001e2:	89 f2                	mov    %esi,%edx
  8001e4:	89 f8                	mov    %edi,%eax
  8001e6:	e8 9e ff ff ff       	call   800189 <printnum>
  8001eb:	83 c4 20             	add    $0x20,%esp
  8001ee:	eb 13                	jmp    800203 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	56                   	push   %esi
  8001f4:	ff 75 18             	pushl  0x18(%ebp)
  8001f7:	ff d7                	call   *%edi
  8001f9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001fc:	83 eb 01             	sub    $0x1,%ebx
  8001ff:	85 db                	test   %ebx,%ebx
  800201:	7f ed                	jg     8001f0 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	56                   	push   %esi
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020d:	ff 75 e0             	pushl  -0x20(%ebp)
  800210:	ff 75 dc             	pushl  -0x24(%ebp)
  800213:	ff 75 d8             	pushl  -0x28(%ebp)
  800216:	e8 95 1a 00 00       	call   801cb0 <__umoddi3>
  80021b:	83 c4 14             	add    $0x14,%esp
  80021e:	0f be 80 06 1e 80 00 	movsbl 0x801e06(%eax),%eax
  800225:	50                   	push   %eax
  800226:	ff d7                	call   *%edi
}
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022e:	5b                   	pop    %ebx
  80022f:	5e                   	pop    %esi
  800230:	5f                   	pop    %edi
  800231:	5d                   	pop    %ebp
  800232:	c3                   	ret    
  800233:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800236:	eb c4                	jmp    8001fc <printnum+0x73>

00800238 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80023e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800242:	8b 10                	mov    (%eax),%edx
  800244:	3b 50 04             	cmp    0x4(%eax),%edx
  800247:	73 0a                	jae    800253 <sprintputch+0x1b>
		*b->buf++ = ch;
  800249:	8d 4a 01             	lea    0x1(%edx),%ecx
  80024c:	89 08                	mov    %ecx,(%eax)
  80024e:	8b 45 08             	mov    0x8(%ebp),%eax
  800251:	88 02                	mov    %al,(%edx)
}
  800253:	5d                   	pop    %ebp
  800254:	c3                   	ret    

00800255 <printfmt>:
{
  800255:	55                   	push   %ebp
  800256:	89 e5                	mov    %esp,%ebp
  800258:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80025b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80025e:	50                   	push   %eax
  80025f:	ff 75 10             	pushl  0x10(%ebp)
  800262:	ff 75 0c             	pushl  0xc(%ebp)
  800265:	ff 75 08             	pushl  0x8(%ebp)
  800268:	e8 05 00 00 00       	call   800272 <vprintfmt>
}
  80026d:	83 c4 10             	add    $0x10,%esp
  800270:	c9                   	leave  
  800271:	c3                   	ret    

00800272 <vprintfmt>:
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	57                   	push   %edi
  800276:	56                   	push   %esi
  800277:	53                   	push   %ebx
  800278:	83 ec 2c             	sub    $0x2c,%esp
  80027b:	8b 75 08             	mov    0x8(%ebp),%esi
  80027e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800281:	8b 7d 10             	mov    0x10(%ebp),%edi
  800284:	e9 8c 03 00 00       	jmp    800615 <vprintfmt+0x3a3>
		padc = ' ';
  800289:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80028d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800294:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80029b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002a2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a7:	8d 47 01             	lea    0x1(%edi),%eax
  8002aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ad:	0f b6 17             	movzbl (%edi),%edx
  8002b0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002b3:	3c 55                	cmp    $0x55,%al
  8002b5:	0f 87 dd 03 00 00    	ja     800698 <vprintfmt+0x426>
  8002bb:	0f b6 c0             	movzbl %al,%eax
  8002be:	ff 24 85 40 1f 80 00 	jmp    *0x801f40(,%eax,4)
  8002c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002c8:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002cc:	eb d9                	jmp    8002a7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002d1:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002d5:	eb d0                	jmp    8002a7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002d7:	0f b6 d2             	movzbl %dl,%edx
  8002da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002e5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002e8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002ec:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002ef:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002f2:	83 f9 09             	cmp    $0x9,%ecx
  8002f5:	77 55                	ja     80034c <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002f7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002fa:	eb e9                	jmp    8002e5 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ff:	8b 00                	mov    (%eax),%eax
  800301:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800304:	8b 45 14             	mov    0x14(%ebp),%eax
  800307:	8d 40 04             	lea    0x4(%eax),%eax
  80030a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800310:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800314:	79 91                	jns    8002a7 <vprintfmt+0x35>
				width = precision, precision = -1;
  800316:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800319:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80031c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800323:	eb 82                	jmp    8002a7 <vprintfmt+0x35>
  800325:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800328:	85 c0                	test   %eax,%eax
  80032a:	ba 00 00 00 00       	mov    $0x0,%edx
  80032f:	0f 49 d0             	cmovns %eax,%edx
  800332:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800338:	e9 6a ff ff ff       	jmp    8002a7 <vprintfmt+0x35>
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800340:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800347:	e9 5b ff ff ff       	jmp    8002a7 <vprintfmt+0x35>
  80034c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80034f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800352:	eb bc                	jmp    800310 <vprintfmt+0x9e>
			lflag++;
  800354:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800357:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80035a:	e9 48 ff ff ff       	jmp    8002a7 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	8d 78 04             	lea    0x4(%eax),%edi
  800365:	83 ec 08             	sub    $0x8,%esp
  800368:	53                   	push   %ebx
  800369:	ff 30                	pushl  (%eax)
  80036b:	ff d6                	call   *%esi
			break;
  80036d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800370:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800373:	e9 9a 02 00 00       	jmp    800612 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800378:	8b 45 14             	mov    0x14(%ebp),%eax
  80037b:	8d 78 04             	lea    0x4(%eax),%edi
  80037e:	8b 00                	mov    (%eax),%eax
  800380:	99                   	cltd   
  800381:	31 d0                	xor    %edx,%eax
  800383:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800385:	83 f8 0f             	cmp    $0xf,%eax
  800388:	7f 23                	jg     8003ad <vprintfmt+0x13b>
  80038a:	8b 14 85 a0 20 80 00 	mov    0x8020a0(,%eax,4),%edx
  800391:	85 d2                	test   %edx,%edx
  800393:	74 18                	je     8003ad <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800395:	52                   	push   %edx
  800396:	68 f1 21 80 00       	push   $0x8021f1
  80039b:	53                   	push   %ebx
  80039c:	56                   	push   %esi
  80039d:	e8 b3 fe ff ff       	call   800255 <printfmt>
  8003a2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a8:	e9 65 02 00 00       	jmp    800612 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8003ad:	50                   	push   %eax
  8003ae:	68 1e 1e 80 00       	push   $0x801e1e
  8003b3:	53                   	push   %ebx
  8003b4:	56                   	push   %esi
  8003b5:	e8 9b fe ff ff       	call   800255 <printfmt>
  8003ba:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003c0:	e9 4d 02 00 00       	jmp    800612 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  8003c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c8:	83 c0 04             	add    $0x4,%eax
  8003cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d1:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003d3:	85 ff                	test   %edi,%edi
  8003d5:	b8 17 1e 80 00       	mov    $0x801e17,%eax
  8003da:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e1:	0f 8e bd 00 00 00    	jle    8004a4 <vprintfmt+0x232>
  8003e7:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003eb:	75 0e                	jne    8003fb <vprintfmt+0x189>
  8003ed:	89 75 08             	mov    %esi,0x8(%ebp)
  8003f0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003f3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003f6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003f9:	eb 6d                	jmp    800468 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fb:	83 ec 08             	sub    $0x8,%esp
  8003fe:	ff 75 d0             	pushl  -0x30(%ebp)
  800401:	57                   	push   %edi
  800402:	e8 39 03 00 00       	call   800740 <strnlen>
  800407:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80040a:	29 c1                	sub    %eax,%ecx
  80040c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80040f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800412:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800416:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800419:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80041c:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80041e:	eb 0f                	jmp    80042f <vprintfmt+0x1bd>
					putch(padc, putdat);
  800420:	83 ec 08             	sub    $0x8,%esp
  800423:	53                   	push   %ebx
  800424:	ff 75 e0             	pushl  -0x20(%ebp)
  800427:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800429:	83 ef 01             	sub    $0x1,%edi
  80042c:	83 c4 10             	add    $0x10,%esp
  80042f:	85 ff                	test   %edi,%edi
  800431:	7f ed                	jg     800420 <vprintfmt+0x1ae>
  800433:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800436:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800439:	85 c9                	test   %ecx,%ecx
  80043b:	b8 00 00 00 00       	mov    $0x0,%eax
  800440:	0f 49 c1             	cmovns %ecx,%eax
  800443:	29 c1                	sub    %eax,%ecx
  800445:	89 75 08             	mov    %esi,0x8(%ebp)
  800448:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80044b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80044e:	89 cb                	mov    %ecx,%ebx
  800450:	eb 16                	jmp    800468 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800452:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800456:	75 31                	jne    800489 <vprintfmt+0x217>
					putch(ch, putdat);
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 0c             	pushl  0xc(%ebp)
  80045e:	50                   	push   %eax
  80045f:	ff 55 08             	call   *0x8(%ebp)
  800462:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800465:	83 eb 01             	sub    $0x1,%ebx
  800468:	83 c7 01             	add    $0x1,%edi
  80046b:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80046f:	0f be c2             	movsbl %dl,%eax
  800472:	85 c0                	test   %eax,%eax
  800474:	74 59                	je     8004cf <vprintfmt+0x25d>
  800476:	85 f6                	test   %esi,%esi
  800478:	78 d8                	js     800452 <vprintfmt+0x1e0>
  80047a:	83 ee 01             	sub    $0x1,%esi
  80047d:	79 d3                	jns    800452 <vprintfmt+0x1e0>
  80047f:	89 df                	mov    %ebx,%edi
  800481:	8b 75 08             	mov    0x8(%ebp),%esi
  800484:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800487:	eb 37                	jmp    8004c0 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800489:	0f be d2             	movsbl %dl,%edx
  80048c:	83 ea 20             	sub    $0x20,%edx
  80048f:	83 fa 5e             	cmp    $0x5e,%edx
  800492:	76 c4                	jbe    800458 <vprintfmt+0x1e6>
					putch('?', putdat);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	ff 75 0c             	pushl  0xc(%ebp)
  80049a:	6a 3f                	push   $0x3f
  80049c:	ff 55 08             	call   *0x8(%ebp)
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	eb c1                	jmp    800465 <vprintfmt+0x1f3>
  8004a4:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004aa:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ad:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004b0:	eb b6                	jmp    800468 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	53                   	push   %ebx
  8004b6:	6a 20                	push   $0x20
  8004b8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ba:	83 ef 01             	sub    $0x1,%edi
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	85 ff                	test   %edi,%edi
  8004c2:	7f ee                	jg     8004b2 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ca:	e9 43 01 00 00       	jmp    800612 <vprintfmt+0x3a0>
  8004cf:	89 df                	mov    %ebx,%edi
  8004d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004d7:	eb e7                	jmp    8004c0 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004d9:	83 f9 01             	cmp    $0x1,%ecx
  8004dc:	7e 3f                	jle    80051d <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004de:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ef:	8d 40 08             	lea    0x8(%eax),%eax
  8004f2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004f9:	79 5c                	jns    800557 <vprintfmt+0x2e5>
				putch('-', putdat);
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	53                   	push   %ebx
  8004ff:	6a 2d                	push   $0x2d
  800501:	ff d6                	call   *%esi
				num = -(long long) num;
  800503:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800506:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800509:	f7 da                	neg    %edx
  80050b:	83 d1 00             	adc    $0x0,%ecx
  80050e:	f7 d9                	neg    %ecx
  800510:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800513:	b8 0a 00 00 00       	mov    $0xa,%eax
  800518:	e9 db 00 00 00       	jmp    8005f8 <vprintfmt+0x386>
	else if (lflag)
  80051d:	85 c9                	test   %ecx,%ecx
  80051f:	75 1b                	jne    80053c <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800529:	89 c1                	mov    %eax,%ecx
  80052b:	c1 f9 1f             	sar    $0x1f,%ecx
  80052e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8d 40 04             	lea    0x4(%eax),%eax
  800537:	89 45 14             	mov    %eax,0x14(%ebp)
  80053a:	eb b9                	jmp    8004f5 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800544:	89 c1                	mov    %eax,%ecx
  800546:	c1 f9 1f             	sar    $0x1f,%ecx
  800549:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	8d 40 04             	lea    0x4(%eax),%eax
  800552:	89 45 14             	mov    %eax,0x14(%ebp)
  800555:	eb 9e                	jmp    8004f5 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800557:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80055a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80055d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800562:	e9 91 00 00 00       	jmp    8005f8 <vprintfmt+0x386>
	if (lflag >= 2)
  800567:	83 f9 01             	cmp    $0x1,%ecx
  80056a:	7e 15                	jle    800581 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	8b 10                	mov    (%eax),%edx
  800571:	8b 48 04             	mov    0x4(%eax),%ecx
  800574:	8d 40 08             	lea    0x8(%eax),%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057f:	eb 77                	jmp    8005f8 <vprintfmt+0x386>
	else if (lflag)
  800581:	85 c9                	test   %ecx,%ecx
  800583:	75 17                	jne    80059c <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8b 10                	mov    (%eax),%edx
  80058a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80058f:	8d 40 04             	lea    0x4(%eax),%eax
  800592:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800595:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059a:	eb 5c                	jmp    8005f8 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 10                	mov    (%eax),%edx
  8005a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a6:	8d 40 04             	lea    0x4(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b1:	eb 45                	jmp    8005f8 <vprintfmt+0x386>
			putch('X', putdat);
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	53                   	push   %ebx
  8005b7:	6a 58                	push   $0x58
  8005b9:	ff d6                	call   *%esi
			putch('X', putdat);
  8005bb:	83 c4 08             	add    $0x8,%esp
  8005be:	53                   	push   %ebx
  8005bf:	6a 58                	push   $0x58
  8005c1:	ff d6                	call   *%esi
			putch('X', putdat);
  8005c3:	83 c4 08             	add    $0x8,%esp
  8005c6:	53                   	push   %ebx
  8005c7:	6a 58                	push   $0x58
  8005c9:	ff d6                	call   *%esi
			break;
  8005cb:	83 c4 10             	add    $0x10,%esp
  8005ce:	eb 42                	jmp    800612 <vprintfmt+0x3a0>
			putch('0', putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	53                   	push   %ebx
  8005d4:	6a 30                	push   $0x30
  8005d6:	ff d6                	call   *%esi
			putch('x', putdat);
  8005d8:	83 c4 08             	add    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	6a 78                	push   $0x78
  8005de:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 10                	mov    (%eax),%edx
  8005e5:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005ea:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005ed:	8d 40 04             	lea    0x4(%eax),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005f3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005f8:	83 ec 0c             	sub    $0xc,%esp
  8005fb:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005ff:	57                   	push   %edi
  800600:	ff 75 e0             	pushl  -0x20(%ebp)
  800603:	50                   	push   %eax
  800604:	51                   	push   %ecx
  800605:	52                   	push   %edx
  800606:	89 da                	mov    %ebx,%edx
  800608:	89 f0                	mov    %esi,%eax
  80060a:	e8 7a fb ff ff       	call   800189 <printnum>
			break;
  80060f:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800615:	83 c7 01             	add    $0x1,%edi
  800618:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061c:	83 f8 25             	cmp    $0x25,%eax
  80061f:	0f 84 64 fc ff ff    	je     800289 <vprintfmt+0x17>
			if (ch == '\0')
  800625:	85 c0                	test   %eax,%eax
  800627:	0f 84 8b 00 00 00    	je     8006b8 <vprintfmt+0x446>
			putch(ch, putdat);
  80062d:	83 ec 08             	sub    $0x8,%esp
  800630:	53                   	push   %ebx
  800631:	50                   	push   %eax
  800632:	ff d6                	call   *%esi
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	eb dc                	jmp    800615 <vprintfmt+0x3a3>
	if (lflag >= 2)
  800639:	83 f9 01             	cmp    $0x1,%ecx
  80063c:	7e 15                	jle    800653 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8b 10                	mov    (%eax),%edx
  800643:	8b 48 04             	mov    0x4(%eax),%ecx
  800646:	8d 40 08             	lea    0x8(%eax),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80064c:	b8 10 00 00 00       	mov    $0x10,%eax
  800651:	eb a5                	jmp    8005f8 <vprintfmt+0x386>
	else if (lflag)
  800653:	85 c9                	test   %ecx,%ecx
  800655:	75 17                	jne    80066e <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 10                	mov    (%eax),%edx
  80065c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800661:	8d 40 04             	lea    0x4(%eax),%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800667:	b8 10 00 00 00       	mov    $0x10,%eax
  80066c:	eb 8a                	jmp    8005f8 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 10                	mov    (%eax),%edx
  800673:	b9 00 00 00 00       	mov    $0x0,%ecx
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067e:	b8 10 00 00 00       	mov    $0x10,%eax
  800683:	e9 70 ff ff ff       	jmp    8005f8 <vprintfmt+0x386>
			putch(ch, putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 25                	push   $0x25
  80068e:	ff d6                	call   *%esi
			break;
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	e9 7a ff ff ff       	jmp    800612 <vprintfmt+0x3a0>
			putch('%', putdat);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	53                   	push   %ebx
  80069c:	6a 25                	push   $0x25
  80069e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	89 f8                	mov    %edi,%eax
  8006a5:	eb 03                	jmp    8006aa <vprintfmt+0x438>
  8006a7:	83 e8 01             	sub    $0x1,%eax
  8006aa:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ae:	75 f7                	jne    8006a7 <vprintfmt+0x435>
  8006b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b3:	e9 5a ff ff ff       	jmp    800612 <vprintfmt+0x3a0>
}
  8006b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006bb:	5b                   	pop    %ebx
  8006bc:	5e                   	pop    %esi
  8006bd:	5f                   	pop    %edi
  8006be:	5d                   	pop    %ebp
  8006bf:	c3                   	ret    

008006c0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006c0:	55                   	push   %ebp
  8006c1:	89 e5                	mov    %esp,%ebp
  8006c3:	83 ec 18             	sub    $0x18,%esp
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006cf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006dd:	85 c0                	test   %eax,%eax
  8006df:	74 26                	je     800707 <vsnprintf+0x47>
  8006e1:	85 d2                	test   %edx,%edx
  8006e3:	7e 22                	jle    800707 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006e5:	ff 75 14             	pushl  0x14(%ebp)
  8006e8:	ff 75 10             	pushl  0x10(%ebp)
  8006eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006ee:	50                   	push   %eax
  8006ef:	68 38 02 80 00       	push   $0x800238
  8006f4:	e8 79 fb ff ff       	call   800272 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006fc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800702:	83 c4 10             	add    $0x10,%esp
}
  800705:	c9                   	leave  
  800706:	c3                   	ret    
		return -E_INVAL;
  800707:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80070c:	eb f7                	jmp    800705 <vsnprintf+0x45>

0080070e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80070e:	55                   	push   %ebp
  80070f:	89 e5                	mov    %esp,%ebp
  800711:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800714:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800717:	50                   	push   %eax
  800718:	ff 75 10             	pushl  0x10(%ebp)
  80071b:	ff 75 0c             	pushl  0xc(%ebp)
  80071e:	ff 75 08             	pushl  0x8(%ebp)
  800721:	e8 9a ff ff ff       	call   8006c0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800726:	c9                   	leave  
  800727:	c3                   	ret    

00800728 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800728:	55                   	push   %ebp
  800729:	89 e5                	mov    %esp,%ebp
  80072b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80072e:	b8 00 00 00 00       	mov    $0x0,%eax
  800733:	eb 03                	jmp    800738 <strlen+0x10>
		n++;
  800735:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800738:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80073c:	75 f7                	jne    800735 <strlen+0xd>
	return n;
}
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800746:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800749:	b8 00 00 00 00       	mov    $0x0,%eax
  80074e:	eb 03                	jmp    800753 <strnlen+0x13>
		n++;
  800750:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800753:	39 d0                	cmp    %edx,%eax
  800755:	74 06                	je     80075d <strnlen+0x1d>
  800757:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80075b:	75 f3                	jne    800750 <strnlen+0x10>
	return n;
}
  80075d:	5d                   	pop    %ebp
  80075e:	c3                   	ret    

0080075f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	53                   	push   %ebx
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800769:	89 c2                	mov    %eax,%edx
  80076b:	83 c1 01             	add    $0x1,%ecx
  80076e:	83 c2 01             	add    $0x1,%edx
  800771:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800775:	88 5a ff             	mov    %bl,-0x1(%edx)
  800778:	84 db                	test   %bl,%bl
  80077a:	75 ef                	jne    80076b <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80077c:	5b                   	pop    %ebx
  80077d:	5d                   	pop    %ebp
  80077e:	c3                   	ret    

0080077f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80077f:	55                   	push   %ebp
  800780:	89 e5                	mov    %esp,%ebp
  800782:	53                   	push   %ebx
  800783:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800786:	53                   	push   %ebx
  800787:	e8 9c ff ff ff       	call   800728 <strlen>
  80078c:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80078f:	ff 75 0c             	pushl  0xc(%ebp)
  800792:	01 d8                	add    %ebx,%eax
  800794:	50                   	push   %eax
  800795:	e8 c5 ff ff ff       	call   80075f <strcpy>
	return dst;
}
  80079a:	89 d8                	mov    %ebx,%eax
  80079c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80079f:	c9                   	leave  
  8007a0:	c3                   	ret    

008007a1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	56                   	push   %esi
  8007a5:	53                   	push   %ebx
  8007a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ac:	89 f3                	mov    %esi,%ebx
  8007ae:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007b1:	89 f2                	mov    %esi,%edx
  8007b3:	eb 0f                	jmp    8007c4 <strncpy+0x23>
		*dst++ = *src;
  8007b5:	83 c2 01             	add    $0x1,%edx
  8007b8:	0f b6 01             	movzbl (%ecx),%eax
  8007bb:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007be:	80 39 01             	cmpb   $0x1,(%ecx)
  8007c1:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007c4:	39 da                	cmp    %ebx,%edx
  8007c6:	75 ed                	jne    8007b5 <strncpy+0x14>
	}
	return ret;
}
  8007c8:	89 f0                	mov    %esi,%eax
  8007ca:	5b                   	pop    %ebx
  8007cb:	5e                   	pop    %esi
  8007cc:	5d                   	pop    %ebp
  8007cd:	c3                   	ret    

008007ce <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	56                   	push   %esi
  8007d2:	53                   	push   %ebx
  8007d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8007d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007dc:	89 f0                	mov    %esi,%eax
  8007de:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007e2:	85 c9                	test   %ecx,%ecx
  8007e4:	75 0b                	jne    8007f1 <strlcpy+0x23>
  8007e6:	eb 17                	jmp    8007ff <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007e8:	83 c2 01             	add    $0x1,%edx
  8007eb:	83 c0 01             	add    $0x1,%eax
  8007ee:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8007f1:	39 d8                	cmp    %ebx,%eax
  8007f3:	74 07                	je     8007fc <strlcpy+0x2e>
  8007f5:	0f b6 0a             	movzbl (%edx),%ecx
  8007f8:	84 c9                	test   %cl,%cl
  8007fa:	75 ec                	jne    8007e8 <strlcpy+0x1a>
		*dst = '\0';
  8007fc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007ff:	29 f0                	sub    %esi,%eax
}
  800801:	5b                   	pop    %ebx
  800802:	5e                   	pop    %esi
  800803:	5d                   	pop    %ebp
  800804:	c3                   	ret    

00800805 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80080e:	eb 06                	jmp    800816 <strcmp+0x11>
		p++, q++;
  800810:	83 c1 01             	add    $0x1,%ecx
  800813:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800816:	0f b6 01             	movzbl (%ecx),%eax
  800819:	84 c0                	test   %al,%al
  80081b:	74 04                	je     800821 <strcmp+0x1c>
  80081d:	3a 02                	cmp    (%edx),%al
  80081f:	74 ef                	je     800810 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800821:	0f b6 c0             	movzbl %al,%eax
  800824:	0f b6 12             	movzbl (%edx),%edx
  800827:	29 d0                	sub    %edx,%eax
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	53                   	push   %ebx
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	8b 55 0c             	mov    0xc(%ebp),%edx
  800835:	89 c3                	mov    %eax,%ebx
  800837:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80083a:	eb 06                	jmp    800842 <strncmp+0x17>
		n--, p++, q++;
  80083c:	83 c0 01             	add    $0x1,%eax
  80083f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800842:	39 d8                	cmp    %ebx,%eax
  800844:	74 16                	je     80085c <strncmp+0x31>
  800846:	0f b6 08             	movzbl (%eax),%ecx
  800849:	84 c9                	test   %cl,%cl
  80084b:	74 04                	je     800851 <strncmp+0x26>
  80084d:	3a 0a                	cmp    (%edx),%cl
  80084f:	74 eb                	je     80083c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800851:	0f b6 00             	movzbl (%eax),%eax
  800854:	0f b6 12             	movzbl (%edx),%edx
  800857:	29 d0                	sub    %edx,%eax
}
  800859:	5b                   	pop    %ebx
  80085a:	5d                   	pop    %ebp
  80085b:	c3                   	ret    
		return 0;
  80085c:	b8 00 00 00 00       	mov    $0x0,%eax
  800861:	eb f6                	jmp    800859 <strncmp+0x2e>

00800863 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80086d:	0f b6 10             	movzbl (%eax),%edx
  800870:	84 d2                	test   %dl,%dl
  800872:	74 09                	je     80087d <strchr+0x1a>
		if (*s == c)
  800874:	38 ca                	cmp    %cl,%dl
  800876:	74 0a                	je     800882 <strchr+0x1f>
	for (; *s; s++)
  800878:	83 c0 01             	add    $0x1,%eax
  80087b:	eb f0                	jmp    80086d <strchr+0xa>
			return (char *) s;
	return 0;
  80087d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800882:	5d                   	pop    %ebp
  800883:	c3                   	ret    

00800884 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80088e:	eb 03                	jmp    800893 <strfind+0xf>
  800890:	83 c0 01             	add    $0x1,%eax
  800893:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800896:	38 ca                	cmp    %cl,%dl
  800898:	74 04                	je     80089e <strfind+0x1a>
  80089a:	84 d2                	test   %dl,%dl
  80089c:	75 f2                	jne    800890 <strfind+0xc>
			break;
	return (char *) s;
}
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    

008008a0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	57                   	push   %edi
  8008a4:	56                   	push   %esi
  8008a5:	53                   	push   %ebx
  8008a6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008ac:	85 c9                	test   %ecx,%ecx
  8008ae:	74 13                	je     8008c3 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008b0:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008b6:	75 05                	jne    8008bd <memset+0x1d>
  8008b8:	f6 c1 03             	test   $0x3,%cl
  8008bb:	74 0d                	je     8008ca <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c0:	fc                   	cld    
  8008c1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008c3:	89 f8                	mov    %edi,%eax
  8008c5:	5b                   	pop    %ebx
  8008c6:	5e                   	pop    %esi
  8008c7:	5f                   	pop    %edi
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    
		c &= 0xFF;
  8008ca:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ce:	89 d3                	mov    %edx,%ebx
  8008d0:	c1 e3 08             	shl    $0x8,%ebx
  8008d3:	89 d0                	mov    %edx,%eax
  8008d5:	c1 e0 18             	shl    $0x18,%eax
  8008d8:	89 d6                	mov    %edx,%esi
  8008da:	c1 e6 10             	shl    $0x10,%esi
  8008dd:	09 f0                	or     %esi,%eax
  8008df:	09 c2                	or     %eax,%edx
  8008e1:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008e3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008e6:	89 d0                	mov    %edx,%eax
  8008e8:	fc                   	cld    
  8008e9:	f3 ab                	rep stos %eax,%es:(%edi)
  8008eb:	eb d6                	jmp    8008c3 <memset+0x23>

008008ed <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	57                   	push   %edi
  8008f1:	56                   	push   %esi
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008fb:	39 c6                	cmp    %eax,%esi
  8008fd:	73 35                	jae    800934 <memmove+0x47>
  8008ff:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800902:	39 c2                	cmp    %eax,%edx
  800904:	76 2e                	jbe    800934 <memmove+0x47>
		s += n;
		d += n;
  800906:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800909:	89 d6                	mov    %edx,%esi
  80090b:	09 fe                	or     %edi,%esi
  80090d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800913:	74 0c                	je     800921 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800915:	83 ef 01             	sub    $0x1,%edi
  800918:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80091b:	fd                   	std    
  80091c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80091e:	fc                   	cld    
  80091f:	eb 21                	jmp    800942 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800921:	f6 c1 03             	test   $0x3,%cl
  800924:	75 ef                	jne    800915 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800926:	83 ef 04             	sub    $0x4,%edi
  800929:	8d 72 fc             	lea    -0x4(%edx),%esi
  80092c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80092f:	fd                   	std    
  800930:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800932:	eb ea                	jmp    80091e <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800934:	89 f2                	mov    %esi,%edx
  800936:	09 c2                	or     %eax,%edx
  800938:	f6 c2 03             	test   $0x3,%dl
  80093b:	74 09                	je     800946 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80093d:	89 c7                	mov    %eax,%edi
  80093f:	fc                   	cld    
  800940:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800942:	5e                   	pop    %esi
  800943:	5f                   	pop    %edi
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800946:	f6 c1 03             	test   $0x3,%cl
  800949:	75 f2                	jne    80093d <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80094b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80094e:	89 c7                	mov    %eax,%edi
  800950:	fc                   	cld    
  800951:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800953:	eb ed                	jmp    800942 <memmove+0x55>

00800955 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800958:	ff 75 10             	pushl  0x10(%ebp)
  80095b:	ff 75 0c             	pushl  0xc(%ebp)
  80095e:	ff 75 08             	pushl  0x8(%ebp)
  800961:	e8 87 ff ff ff       	call   8008ed <memmove>
}
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	56                   	push   %esi
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	8b 55 0c             	mov    0xc(%ebp),%edx
  800973:	89 c6                	mov    %eax,%esi
  800975:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800978:	39 f0                	cmp    %esi,%eax
  80097a:	74 1c                	je     800998 <memcmp+0x30>
		if (*s1 != *s2)
  80097c:	0f b6 08             	movzbl (%eax),%ecx
  80097f:	0f b6 1a             	movzbl (%edx),%ebx
  800982:	38 d9                	cmp    %bl,%cl
  800984:	75 08                	jne    80098e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800986:	83 c0 01             	add    $0x1,%eax
  800989:	83 c2 01             	add    $0x1,%edx
  80098c:	eb ea                	jmp    800978 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80098e:	0f b6 c1             	movzbl %cl,%eax
  800991:	0f b6 db             	movzbl %bl,%ebx
  800994:	29 d8                	sub    %ebx,%eax
  800996:	eb 05                	jmp    80099d <memcmp+0x35>
	}

	return 0;
  800998:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099d:	5b                   	pop    %ebx
  80099e:	5e                   	pop    %esi
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    

008009a1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009aa:	89 c2                	mov    %eax,%edx
  8009ac:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009af:	39 d0                	cmp    %edx,%eax
  8009b1:	73 09                	jae    8009bc <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009b3:	38 08                	cmp    %cl,(%eax)
  8009b5:	74 05                	je     8009bc <memfind+0x1b>
	for (; s < ends; s++)
  8009b7:	83 c0 01             	add    $0x1,%eax
  8009ba:	eb f3                	jmp    8009af <memfind+0xe>
			break;
	return (void *) s;
}
  8009bc:	5d                   	pop    %ebp
  8009bd:	c3                   	ret    

008009be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	57                   	push   %edi
  8009c2:	56                   	push   %esi
  8009c3:	53                   	push   %ebx
  8009c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009ca:	eb 03                	jmp    8009cf <strtol+0x11>
		s++;
  8009cc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009cf:	0f b6 01             	movzbl (%ecx),%eax
  8009d2:	3c 20                	cmp    $0x20,%al
  8009d4:	74 f6                	je     8009cc <strtol+0xe>
  8009d6:	3c 09                	cmp    $0x9,%al
  8009d8:	74 f2                	je     8009cc <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009da:	3c 2b                	cmp    $0x2b,%al
  8009dc:	74 2e                	je     800a0c <strtol+0x4e>
	int neg = 0;
  8009de:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009e3:	3c 2d                	cmp    $0x2d,%al
  8009e5:	74 2f                	je     800a16 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009e7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009ed:	75 05                	jne    8009f4 <strtol+0x36>
  8009ef:	80 39 30             	cmpb   $0x30,(%ecx)
  8009f2:	74 2c                	je     800a20 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009f4:	85 db                	test   %ebx,%ebx
  8009f6:	75 0a                	jne    800a02 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009f8:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8009fd:	80 39 30             	cmpb   $0x30,(%ecx)
  800a00:	74 28                	je     800a2a <strtol+0x6c>
		base = 10;
  800a02:	b8 00 00 00 00       	mov    $0x0,%eax
  800a07:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a0a:	eb 50                	jmp    800a5c <strtol+0x9e>
		s++;
  800a0c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a0f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a14:	eb d1                	jmp    8009e7 <strtol+0x29>
		s++, neg = 1;
  800a16:	83 c1 01             	add    $0x1,%ecx
  800a19:	bf 01 00 00 00       	mov    $0x1,%edi
  800a1e:	eb c7                	jmp    8009e7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a20:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a24:	74 0e                	je     800a34 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a26:	85 db                	test   %ebx,%ebx
  800a28:	75 d8                	jne    800a02 <strtol+0x44>
		s++, base = 8;
  800a2a:	83 c1 01             	add    $0x1,%ecx
  800a2d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a32:	eb ce                	jmp    800a02 <strtol+0x44>
		s += 2, base = 16;
  800a34:	83 c1 02             	add    $0x2,%ecx
  800a37:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a3c:	eb c4                	jmp    800a02 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a3e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a41:	89 f3                	mov    %esi,%ebx
  800a43:	80 fb 19             	cmp    $0x19,%bl
  800a46:	77 29                	ja     800a71 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a48:	0f be d2             	movsbl %dl,%edx
  800a4b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a4e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a51:	7d 30                	jge    800a83 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a53:	83 c1 01             	add    $0x1,%ecx
  800a56:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a5a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a5c:	0f b6 11             	movzbl (%ecx),%edx
  800a5f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a62:	89 f3                	mov    %esi,%ebx
  800a64:	80 fb 09             	cmp    $0x9,%bl
  800a67:	77 d5                	ja     800a3e <strtol+0x80>
			dig = *s - '0';
  800a69:	0f be d2             	movsbl %dl,%edx
  800a6c:	83 ea 30             	sub    $0x30,%edx
  800a6f:	eb dd                	jmp    800a4e <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a71:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a74:	89 f3                	mov    %esi,%ebx
  800a76:	80 fb 19             	cmp    $0x19,%bl
  800a79:	77 08                	ja     800a83 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a7b:	0f be d2             	movsbl %dl,%edx
  800a7e:	83 ea 37             	sub    $0x37,%edx
  800a81:	eb cb                	jmp    800a4e <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a87:	74 05                	je     800a8e <strtol+0xd0>
		*endptr = (char *) s;
  800a89:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a8c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a8e:	89 c2                	mov    %eax,%edx
  800a90:	f7 da                	neg    %edx
  800a92:	85 ff                	test   %edi,%edi
  800a94:	0f 45 c2             	cmovne %edx,%eax
}
  800a97:	5b                   	pop    %ebx
  800a98:	5e                   	pop    %esi
  800a99:	5f                   	pop    %edi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	57                   	push   %edi
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aa2:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa7:	8b 55 08             	mov    0x8(%ebp),%edx
  800aaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aad:	89 c3                	mov    %eax,%ebx
  800aaf:	89 c7                	mov    %eax,%edi
  800ab1:	89 c6                	mov    %eax,%esi
  800ab3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ab5:	5b                   	pop    %ebx
  800ab6:	5e                   	pop    %esi
  800ab7:	5f                   	pop    %edi
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <sys_cgetc>:

int
sys_cgetc(void)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	57                   	push   %edi
  800abe:	56                   	push   %esi
  800abf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ac0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac5:	b8 01 00 00 00       	mov    $0x1,%eax
  800aca:	89 d1                	mov    %edx,%ecx
  800acc:	89 d3                	mov    %edx,%ebx
  800ace:	89 d7                	mov    %edx,%edi
  800ad0:	89 d6                	mov    %edx,%esi
  800ad2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ad4:	5b                   	pop    %ebx
  800ad5:	5e                   	pop    %esi
  800ad6:	5f                   	pop    %edi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	57                   	push   %edi
  800add:	56                   	push   %esi
  800ade:	53                   	push   %ebx
  800adf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ae2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae7:	8b 55 08             	mov    0x8(%ebp),%edx
  800aea:	b8 03 00 00 00       	mov    $0x3,%eax
  800aef:	89 cb                	mov    %ecx,%ebx
  800af1:	89 cf                	mov    %ecx,%edi
  800af3:	89 ce                	mov    %ecx,%esi
  800af5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800af7:	85 c0                	test   %eax,%eax
  800af9:	7f 08                	jg     800b03 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800afb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800afe:	5b                   	pop    %ebx
  800aff:	5e                   	pop    %esi
  800b00:	5f                   	pop    %edi
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b03:	83 ec 0c             	sub    $0xc,%esp
  800b06:	50                   	push   %eax
  800b07:	6a 03                	push   $0x3
  800b09:	68 ff 20 80 00       	push   $0x8020ff
  800b0e:	6a 23                	push   $0x23
  800b10:	68 1c 21 80 00       	push   $0x80211c
  800b15:	e8 85 0f 00 00       	call   801a9f <_panic>

00800b1a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	57                   	push   %edi
  800b1e:	56                   	push   %esi
  800b1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b20:	ba 00 00 00 00       	mov    $0x0,%edx
  800b25:	b8 02 00 00 00       	mov    $0x2,%eax
  800b2a:	89 d1                	mov    %edx,%ecx
  800b2c:	89 d3                	mov    %edx,%ebx
  800b2e:	89 d7                	mov    %edx,%edi
  800b30:	89 d6                	mov    %edx,%esi
  800b32:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5f                   	pop    %edi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <sys_yield>:

void
sys_yield(void)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	57                   	push   %edi
  800b3d:	56                   	push   %esi
  800b3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b44:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b49:	89 d1                	mov    %edx,%ecx
  800b4b:	89 d3                	mov    %edx,%ebx
  800b4d:	89 d7                	mov    %edx,%edi
  800b4f:	89 d6                	mov    %edx,%esi
  800b51:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b53:	5b                   	pop    %ebx
  800b54:	5e                   	pop    %esi
  800b55:	5f                   	pop    %edi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	57                   	push   %edi
  800b5c:	56                   	push   %esi
  800b5d:	53                   	push   %ebx
  800b5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b61:	be 00 00 00 00       	mov    $0x0,%esi
  800b66:	8b 55 08             	mov    0x8(%ebp),%edx
  800b69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6c:	b8 04 00 00 00       	mov    $0x4,%eax
  800b71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b74:	89 f7                	mov    %esi,%edi
  800b76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b78:	85 c0                	test   %eax,%eax
  800b7a:	7f 08                	jg     800b84 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b84:	83 ec 0c             	sub    $0xc,%esp
  800b87:	50                   	push   %eax
  800b88:	6a 04                	push   $0x4
  800b8a:	68 ff 20 80 00       	push   $0x8020ff
  800b8f:	6a 23                	push   $0x23
  800b91:	68 1c 21 80 00       	push   $0x80211c
  800b96:	e8 04 0f 00 00       	call   801a9f <_panic>

00800b9b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	57                   	push   %edi
  800b9f:	56                   	push   %esi
  800ba0:	53                   	push   %ebx
  800ba1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800baa:	b8 05 00 00 00       	mov    $0x5,%eax
  800baf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bb2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bb5:	8b 75 18             	mov    0x18(%ebp),%esi
  800bb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bba:	85 c0                	test   %eax,%eax
  800bbc:	7f 08                	jg     800bc6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc6:	83 ec 0c             	sub    $0xc,%esp
  800bc9:	50                   	push   %eax
  800bca:	6a 05                	push   $0x5
  800bcc:	68 ff 20 80 00       	push   $0x8020ff
  800bd1:	6a 23                	push   $0x23
  800bd3:	68 1c 21 80 00       	push   $0x80211c
  800bd8:	e8 c2 0e 00 00       	call   801a9f <_panic>

00800bdd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	57                   	push   %edi
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
  800be3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800beb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf1:	b8 06 00 00 00       	mov    $0x6,%eax
  800bf6:	89 df                	mov    %ebx,%edi
  800bf8:	89 de                	mov    %ebx,%esi
  800bfa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bfc:	85 c0                	test   %eax,%eax
  800bfe:	7f 08                	jg     800c08 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c03:	5b                   	pop    %ebx
  800c04:	5e                   	pop    %esi
  800c05:	5f                   	pop    %edi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c08:	83 ec 0c             	sub    $0xc,%esp
  800c0b:	50                   	push   %eax
  800c0c:	6a 06                	push   $0x6
  800c0e:	68 ff 20 80 00       	push   $0x8020ff
  800c13:	6a 23                	push   $0x23
  800c15:	68 1c 21 80 00       	push   $0x80211c
  800c1a:	e8 80 0e 00 00       	call   801a9f <_panic>

00800c1f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	57                   	push   %edi
  800c23:	56                   	push   %esi
  800c24:	53                   	push   %ebx
  800c25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c33:	b8 08 00 00 00       	mov    $0x8,%eax
  800c38:	89 df                	mov    %ebx,%edi
  800c3a:	89 de                	mov    %ebx,%esi
  800c3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3e:	85 c0                	test   %eax,%eax
  800c40:	7f 08                	jg     800c4a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4a:	83 ec 0c             	sub    $0xc,%esp
  800c4d:	50                   	push   %eax
  800c4e:	6a 08                	push   $0x8
  800c50:	68 ff 20 80 00       	push   $0x8020ff
  800c55:	6a 23                	push   $0x23
  800c57:	68 1c 21 80 00       	push   $0x80211c
  800c5c:	e8 3e 0e 00 00       	call   801a9f <_panic>

00800c61 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	57                   	push   %edi
  800c65:	56                   	push   %esi
  800c66:	53                   	push   %ebx
  800c67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c75:	b8 09 00 00 00       	mov    $0x9,%eax
  800c7a:	89 df                	mov    %ebx,%edi
  800c7c:	89 de                	mov    %ebx,%esi
  800c7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c80:	85 c0                	test   %eax,%eax
  800c82:	7f 08                	jg     800c8c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8c:	83 ec 0c             	sub    $0xc,%esp
  800c8f:	50                   	push   %eax
  800c90:	6a 09                	push   $0x9
  800c92:	68 ff 20 80 00       	push   $0x8020ff
  800c97:	6a 23                	push   $0x23
  800c99:	68 1c 21 80 00       	push   $0x80211c
  800c9e:	e8 fc 0d 00 00       	call   801a9f <_panic>

00800ca3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cbc:	89 df                	mov    %ebx,%edi
  800cbe:	89 de                	mov    %ebx,%esi
  800cc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	7f 08                	jg     800cce <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cce:	83 ec 0c             	sub    $0xc,%esp
  800cd1:	50                   	push   %eax
  800cd2:	6a 0a                	push   $0xa
  800cd4:	68 ff 20 80 00       	push   $0x8020ff
  800cd9:	6a 23                	push   $0x23
  800cdb:	68 1c 21 80 00       	push   $0x80211c
  800ce0:	e8 ba 0d 00 00       	call   801a9f <_panic>

00800ce5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	57                   	push   %edi
  800ce9:	56                   	push   %esi
  800cea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cf6:	be 00 00 00 00       	mov    $0x0,%esi
  800cfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d01:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5f                   	pop    %edi
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
  800d0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d11:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d16:	8b 55 08             	mov    0x8(%ebp),%edx
  800d19:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d1e:	89 cb                	mov    %ecx,%ebx
  800d20:	89 cf                	mov    %ecx,%edi
  800d22:	89 ce                	mov    %ecx,%esi
  800d24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d26:	85 c0                	test   %eax,%eax
  800d28:	7f 08                	jg     800d32 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5f                   	pop    %edi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d32:	83 ec 0c             	sub    $0xc,%esp
  800d35:	50                   	push   %eax
  800d36:	6a 0d                	push   $0xd
  800d38:	68 ff 20 80 00       	push   $0x8020ff
  800d3d:	6a 23                	push   $0x23
  800d3f:	68 1c 21 80 00       	push   $0x80211c
  800d44:	e8 56 0d 00 00       	call   801a9f <_panic>

00800d49 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	53                   	push   %ebx
  800d4d:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  800d50:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800d57:	74 0d                	je     800d66 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800d61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d64:	c9                   	leave  
  800d65:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  800d66:	e8 af fd ff ff       	call   800b1a <sys_getenvid>
  800d6b:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  800d6d:	83 ec 04             	sub    $0x4,%esp
  800d70:	6a 07                	push   $0x7
  800d72:	68 00 f0 bf ee       	push   $0xeebff000
  800d77:	50                   	push   %eax
  800d78:	e8 db fd ff ff       	call   800b58 <sys_page_alloc>
        	if (r < 0) {
  800d7d:	83 c4 10             	add    $0x10,%esp
  800d80:	85 c0                	test   %eax,%eax
  800d82:	78 27                	js     800dab <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  800d84:	83 ec 08             	sub    $0x8,%esp
  800d87:	68 bd 0d 80 00       	push   $0x800dbd
  800d8c:	53                   	push   %ebx
  800d8d:	e8 11 ff ff ff       	call   800ca3 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  800d92:	83 c4 10             	add    $0x10,%esp
  800d95:	85 c0                	test   %eax,%eax
  800d97:	79 c0                	jns    800d59 <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  800d99:	50                   	push   %eax
  800d9a:	68 2a 21 80 00       	push   $0x80212a
  800d9f:	6a 28                	push   $0x28
  800da1:	68 3e 21 80 00       	push   $0x80213e
  800da6:	e8 f4 0c 00 00       	call   801a9f <_panic>
            		panic("pgfault_handler: %e", r);
  800dab:	50                   	push   %eax
  800dac:	68 2a 21 80 00       	push   $0x80212a
  800db1:	6a 24                	push   $0x24
  800db3:	68 3e 21 80 00       	push   $0x80213e
  800db8:	e8 e2 0c 00 00       	call   801a9f <_panic>

00800dbd <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800dbd:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800dbe:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800dc3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800dc5:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  800dc8:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  800dcc:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  800dcf:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  800dd3:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  800dd7:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  800dda:	83 c4 08             	add    $0x8,%esp
	popal
  800ddd:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  800dde:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  800de1:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  800de2:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  800de3:	c3                   	ret    

00800de4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	05 00 00 00 30       	add    $0x30000000,%eax
  800def:	c1 e8 0c             	shr    $0xc,%eax
}
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800dff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e04:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e11:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e16:	89 c2                	mov    %eax,%edx
  800e18:	c1 ea 16             	shr    $0x16,%edx
  800e1b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e22:	f6 c2 01             	test   $0x1,%dl
  800e25:	74 2a                	je     800e51 <fd_alloc+0x46>
  800e27:	89 c2                	mov    %eax,%edx
  800e29:	c1 ea 0c             	shr    $0xc,%edx
  800e2c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e33:	f6 c2 01             	test   $0x1,%dl
  800e36:	74 19                	je     800e51 <fd_alloc+0x46>
  800e38:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e3d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e42:	75 d2                	jne    800e16 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e44:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e4a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e4f:	eb 07                	jmp    800e58 <fd_alloc+0x4d>
			*fd_store = fd;
  800e51:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    

00800e5a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e60:	83 f8 1f             	cmp    $0x1f,%eax
  800e63:	77 36                	ja     800e9b <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e65:	c1 e0 0c             	shl    $0xc,%eax
  800e68:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e6d:	89 c2                	mov    %eax,%edx
  800e6f:	c1 ea 16             	shr    $0x16,%edx
  800e72:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e79:	f6 c2 01             	test   $0x1,%dl
  800e7c:	74 24                	je     800ea2 <fd_lookup+0x48>
  800e7e:	89 c2                	mov    %eax,%edx
  800e80:	c1 ea 0c             	shr    $0xc,%edx
  800e83:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e8a:	f6 c2 01             	test   $0x1,%dl
  800e8d:	74 1a                	je     800ea9 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e92:	89 02                	mov    %eax,(%edx)
	return 0;
  800e94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    
		return -E_INVAL;
  800e9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea0:	eb f7                	jmp    800e99 <fd_lookup+0x3f>
		return -E_INVAL;
  800ea2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea7:	eb f0                	jmp    800e99 <fd_lookup+0x3f>
  800ea9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eae:	eb e9                	jmp    800e99 <fd_lookup+0x3f>

00800eb0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb9:	ba c8 21 80 00       	mov    $0x8021c8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ebe:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ec3:	39 08                	cmp    %ecx,(%eax)
  800ec5:	74 33                	je     800efa <dev_lookup+0x4a>
  800ec7:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800eca:	8b 02                	mov    (%edx),%eax
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	75 f3                	jne    800ec3 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ed0:	a1 04 40 80 00       	mov    0x804004,%eax
  800ed5:	8b 40 48             	mov    0x48(%eax),%eax
  800ed8:	83 ec 04             	sub    $0x4,%esp
  800edb:	51                   	push   %ecx
  800edc:	50                   	push   %eax
  800edd:	68 4c 21 80 00       	push   $0x80214c
  800ee2:	e8 8e f2 ff ff       	call   800175 <cprintf>
	*dev = 0;
  800ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ef0:	83 c4 10             	add    $0x10,%esp
  800ef3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    
			*dev = devtab[i];
  800efa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efd:	89 01                	mov    %eax,(%ecx)
			return 0;
  800eff:	b8 00 00 00 00       	mov    $0x0,%eax
  800f04:	eb f2                	jmp    800ef8 <dev_lookup+0x48>

00800f06 <fd_close>:
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	57                   	push   %edi
  800f0a:	56                   	push   %esi
  800f0b:	53                   	push   %ebx
  800f0c:	83 ec 1c             	sub    $0x1c,%esp
  800f0f:	8b 75 08             	mov    0x8(%ebp),%esi
  800f12:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f15:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f18:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f19:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f1f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f22:	50                   	push   %eax
  800f23:	e8 32 ff ff ff       	call   800e5a <fd_lookup>
  800f28:	89 c3                	mov    %eax,%ebx
  800f2a:	83 c4 08             	add    $0x8,%esp
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	78 05                	js     800f36 <fd_close+0x30>
	    || fd != fd2)
  800f31:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f34:	74 16                	je     800f4c <fd_close+0x46>
		return (must_exist ? r : 0);
  800f36:	89 f8                	mov    %edi,%eax
  800f38:	84 c0                	test   %al,%al
  800f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3f:	0f 44 d8             	cmove  %eax,%ebx
}
  800f42:	89 d8                	mov    %ebx,%eax
  800f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f47:	5b                   	pop    %ebx
  800f48:	5e                   	pop    %esi
  800f49:	5f                   	pop    %edi
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f52:	50                   	push   %eax
  800f53:	ff 36                	pushl  (%esi)
  800f55:	e8 56 ff ff ff       	call   800eb0 <dev_lookup>
  800f5a:	89 c3                	mov    %eax,%ebx
  800f5c:	83 c4 10             	add    $0x10,%esp
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	78 15                	js     800f78 <fd_close+0x72>
		if (dev->dev_close)
  800f63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f66:	8b 40 10             	mov    0x10(%eax),%eax
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	74 1b                	je     800f88 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f6d:	83 ec 0c             	sub    $0xc,%esp
  800f70:	56                   	push   %esi
  800f71:	ff d0                	call   *%eax
  800f73:	89 c3                	mov    %eax,%ebx
  800f75:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f78:	83 ec 08             	sub    $0x8,%esp
  800f7b:	56                   	push   %esi
  800f7c:	6a 00                	push   $0x0
  800f7e:	e8 5a fc ff ff       	call   800bdd <sys_page_unmap>
	return r;
  800f83:	83 c4 10             	add    $0x10,%esp
  800f86:	eb ba                	jmp    800f42 <fd_close+0x3c>
			r = 0;
  800f88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8d:	eb e9                	jmp    800f78 <fd_close+0x72>

00800f8f <close>:

int
close(int fdnum)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f98:	50                   	push   %eax
  800f99:	ff 75 08             	pushl  0x8(%ebp)
  800f9c:	e8 b9 fe ff ff       	call   800e5a <fd_lookup>
  800fa1:	83 c4 08             	add    $0x8,%esp
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	78 10                	js     800fb8 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800fa8:	83 ec 08             	sub    $0x8,%esp
  800fab:	6a 01                	push   $0x1
  800fad:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb0:	e8 51 ff ff ff       	call   800f06 <fd_close>
  800fb5:	83 c4 10             	add    $0x10,%esp
}
  800fb8:	c9                   	leave  
  800fb9:	c3                   	ret    

00800fba <close_all>:

void
close_all(void)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	53                   	push   %ebx
  800fbe:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fc1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fc6:	83 ec 0c             	sub    $0xc,%esp
  800fc9:	53                   	push   %ebx
  800fca:	e8 c0 ff ff ff       	call   800f8f <close>
	for (i = 0; i < MAXFD; i++)
  800fcf:	83 c3 01             	add    $0x1,%ebx
  800fd2:	83 c4 10             	add    $0x10,%esp
  800fd5:	83 fb 20             	cmp    $0x20,%ebx
  800fd8:	75 ec                	jne    800fc6 <close_all+0xc>
}
  800fda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	57                   	push   %edi
  800fe3:	56                   	push   %esi
  800fe4:	53                   	push   %ebx
  800fe5:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fe8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800feb:	50                   	push   %eax
  800fec:	ff 75 08             	pushl  0x8(%ebp)
  800fef:	e8 66 fe ff ff       	call   800e5a <fd_lookup>
  800ff4:	89 c3                	mov    %eax,%ebx
  800ff6:	83 c4 08             	add    $0x8,%esp
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	0f 88 81 00 00 00    	js     801082 <dup+0xa3>
		return r;
	close(newfdnum);
  801001:	83 ec 0c             	sub    $0xc,%esp
  801004:	ff 75 0c             	pushl  0xc(%ebp)
  801007:	e8 83 ff ff ff       	call   800f8f <close>

	newfd = INDEX2FD(newfdnum);
  80100c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80100f:	c1 e6 0c             	shl    $0xc,%esi
  801012:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801018:	83 c4 04             	add    $0x4,%esp
  80101b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80101e:	e8 d1 fd ff ff       	call   800df4 <fd2data>
  801023:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801025:	89 34 24             	mov    %esi,(%esp)
  801028:	e8 c7 fd ff ff       	call   800df4 <fd2data>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801032:	89 d8                	mov    %ebx,%eax
  801034:	c1 e8 16             	shr    $0x16,%eax
  801037:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80103e:	a8 01                	test   $0x1,%al
  801040:	74 11                	je     801053 <dup+0x74>
  801042:	89 d8                	mov    %ebx,%eax
  801044:	c1 e8 0c             	shr    $0xc,%eax
  801047:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80104e:	f6 c2 01             	test   $0x1,%dl
  801051:	75 39                	jne    80108c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801053:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801056:	89 d0                	mov    %edx,%eax
  801058:	c1 e8 0c             	shr    $0xc,%eax
  80105b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801062:	83 ec 0c             	sub    $0xc,%esp
  801065:	25 07 0e 00 00       	and    $0xe07,%eax
  80106a:	50                   	push   %eax
  80106b:	56                   	push   %esi
  80106c:	6a 00                	push   $0x0
  80106e:	52                   	push   %edx
  80106f:	6a 00                	push   $0x0
  801071:	e8 25 fb ff ff       	call   800b9b <sys_page_map>
  801076:	89 c3                	mov    %eax,%ebx
  801078:	83 c4 20             	add    $0x20,%esp
  80107b:	85 c0                	test   %eax,%eax
  80107d:	78 31                	js     8010b0 <dup+0xd1>
		goto err;

	return newfdnum;
  80107f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801082:	89 d8                	mov    %ebx,%eax
  801084:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801087:	5b                   	pop    %ebx
  801088:	5e                   	pop    %esi
  801089:	5f                   	pop    %edi
  80108a:	5d                   	pop    %ebp
  80108b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80108c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801093:	83 ec 0c             	sub    $0xc,%esp
  801096:	25 07 0e 00 00       	and    $0xe07,%eax
  80109b:	50                   	push   %eax
  80109c:	57                   	push   %edi
  80109d:	6a 00                	push   $0x0
  80109f:	53                   	push   %ebx
  8010a0:	6a 00                	push   $0x0
  8010a2:	e8 f4 fa ff ff       	call   800b9b <sys_page_map>
  8010a7:	89 c3                	mov    %eax,%ebx
  8010a9:	83 c4 20             	add    $0x20,%esp
  8010ac:	85 c0                	test   %eax,%eax
  8010ae:	79 a3                	jns    801053 <dup+0x74>
	sys_page_unmap(0, newfd);
  8010b0:	83 ec 08             	sub    $0x8,%esp
  8010b3:	56                   	push   %esi
  8010b4:	6a 00                	push   $0x0
  8010b6:	e8 22 fb ff ff       	call   800bdd <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010bb:	83 c4 08             	add    $0x8,%esp
  8010be:	57                   	push   %edi
  8010bf:	6a 00                	push   $0x0
  8010c1:	e8 17 fb ff ff       	call   800bdd <sys_page_unmap>
	return r;
  8010c6:	83 c4 10             	add    $0x10,%esp
  8010c9:	eb b7                	jmp    801082 <dup+0xa3>

008010cb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	53                   	push   %ebx
  8010cf:	83 ec 14             	sub    $0x14,%esp
  8010d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010d8:	50                   	push   %eax
  8010d9:	53                   	push   %ebx
  8010da:	e8 7b fd ff ff       	call   800e5a <fd_lookup>
  8010df:	83 c4 08             	add    $0x8,%esp
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	78 3f                	js     801125 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010e6:	83 ec 08             	sub    $0x8,%esp
  8010e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ec:	50                   	push   %eax
  8010ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f0:	ff 30                	pushl  (%eax)
  8010f2:	e8 b9 fd ff ff       	call   800eb0 <dev_lookup>
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	78 27                	js     801125 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801101:	8b 42 08             	mov    0x8(%edx),%eax
  801104:	83 e0 03             	and    $0x3,%eax
  801107:	83 f8 01             	cmp    $0x1,%eax
  80110a:	74 1e                	je     80112a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80110c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110f:	8b 40 08             	mov    0x8(%eax),%eax
  801112:	85 c0                	test   %eax,%eax
  801114:	74 35                	je     80114b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801116:	83 ec 04             	sub    $0x4,%esp
  801119:	ff 75 10             	pushl  0x10(%ebp)
  80111c:	ff 75 0c             	pushl  0xc(%ebp)
  80111f:	52                   	push   %edx
  801120:	ff d0                	call   *%eax
  801122:	83 c4 10             	add    $0x10,%esp
}
  801125:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801128:	c9                   	leave  
  801129:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80112a:	a1 04 40 80 00       	mov    0x804004,%eax
  80112f:	8b 40 48             	mov    0x48(%eax),%eax
  801132:	83 ec 04             	sub    $0x4,%esp
  801135:	53                   	push   %ebx
  801136:	50                   	push   %eax
  801137:	68 8d 21 80 00       	push   $0x80218d
  80113c:	e8 34 f0 ff ff       	call   800175 <cprintf>
		return -E_INVAL;
  801141:	83 c4 10             	add    $0x10,%esp
  801144:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801149:	eb da                	jmp    801125 <read+0x5a>
		return -E_NOT_SUPP;
  80114b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801150:	eb d3                	jmp    801125 <read+0x5a>

00801152 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	57                   	push   %edi
  801156:	56                   	push   %esi
  801157:	53                   	push   %ebx
  801158:	83 ec 0c             	sub    $0xc,%esp
  80115b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80115e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801161:	bb 00 00 00 00       	mov    $0x0,%ebx
  801166:	39 f3                	cmp    %esi,%ebx
  801168:	73 25                	jae    80118f <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80116a:	83 ec 04             	sub    $0x4,%esp
  80116d:	89 f0                	mov    %esi,%eax
  80116f:	29 d8                	sub    %ebx,%eax
  801171:	50                   	push   %eax
  801172:	89 d8                	mov    %ebx,%eax
  801174:	03 45 0c             	add    0xc(%ebp),%eax
  801177:	50                   	push   %eax
  801178:	57                   	push   %edi
  801179:	e8 4d ff ff ff       	call   8010cb <read>
		if (m < 0)
  80117e:	83 c4 10             	add    $0x10,%esp
  801181:	85 c0                	test   %eax,%eax
  801183:	78 08                	js     80118d <readn+0x3b>
			return m;
		if (m == 0)
  801185:	85 c0                	test   %eax,%eax
  801187:	74 06                	je     80118f <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801189:	01 c3                	add    %eax,%ebx
  80118b:	eb d9                	jmp    801166 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80118d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80118f:	89 d8                	mov    %ebx,%eax
  801191:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801194:	5b                   	pop    %ebx
  801195:	5e                   	pop    %esi
  801196:	5f                   	pop    %edi
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    

00801199 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	53                   	push   %ebx
  80119d:	83 ec 14             	sub    $0x14,%esp
  8011a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a6:	50                   	push   %eax
  8011a7:	53                   	push   %ebx
  8011a8:	e8 ad fc ff ff       	call   800e5a <fd_lookup>
  8011ad:	83 c4 08             	add    $0x8,%esp
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	78 3a                	js     8011ee <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011b4:	83 ec 08             	sub    $0x8,%esp
  8011b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ba:	50                   	push   %eax
  8011bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011be:	ff 30                	pushl  (%eax)
  8011c0:	e8 eb fc ff ff       	call   800eb0 <dev_lookup>
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	78 22                	js     8011ee <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cf:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011d3:	74 1e                	je     8011f3 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d8:	8b 52 0c             	mov    0xc(%edx),%edx
  8011db:	85 d2                	test   %edx,%edx
  8011dd:	74 35                	je     801214 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011df:	83 ec 04             	sub    $0x4,%esp
  8011e2:	ff 75 10             	pushl  0x10(%ebp)
  8011e5:	ff 75 0c             	pushl  0xc(%ebp)
  8011e8:	50                   	push   %eax
  8011e9:	ff d2                	call   *%edx
  8011eb:	83 c4 10             	add    $0x10,%esp
}
  8011ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011f3:	a1 04 40 80 00       	mov    0x804004,%eax
  8011f8:	8b 40 48             	mov    0x48(%eax),%eax
  8011fb:	83 ec 04             	sub    $0x4,%esp
  8011fe:	53                   	push   %ebx
  8011ff:	50                   	push   %eax
  801200:	68 a9 21 80 00       	push   $0x8021a9
  801205:	e8 6b ef ff ff       	call   800175 <cprintf>
		return -E_INVAL;
  80120a:	83 c4 10             	add    $0x10,%esp
  80120d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801212:	eb da                	jmp    8011ee <write+0x55>
		return -E_NOT_SUPP;
  801214:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801219:	eb d3                	jmp    8011ee <write+0x55>

0080121b <seek>:

int
seek(int fdnum, off_t offset)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801221:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801224:	50                   	push   %eax
  801225:	ff 75 08             	pushl  0x8(%ebp)
  801228:	e8 2d fc ff ff       	call   800e5a <fd_lookup>
  80122d:	83 c4 08             	add    $0x8,%esp
  801230:	85 c0                	test   %eax,%eax
  801232:	78 0e                	js     801242 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801234:	8b 55 0c             	mov    0xc(%ebp),%edx
  801237:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80123d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801242:	c9                   	leave  
  801243:	c3                   	ret    

00801244 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
  801247:	53                   	push   %ebx
  801248:	83 ec 14             	sub    $0x14,%esp
  80124b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80124e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801251:	50                   	push   %eax
  801252:	53                   	push   %ebx
  801253:	e8 02 fc ff ff       	call   800e5a <fd_lookup>
  801258:	83 c4 08             	add    $0x8,%esp
  80125b:	85 c0                	test   %eax,%eax
  80125d:	78 37                	js     801296 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80125f:	83 ec 08             	sub    $0x8,%esp
  801262:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801265:	50                   	push   %eax
  801266:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801269:	ff 30                	pushl  (%eax)
  80126b:	e8 40 fc ff ff       	call   800eb0 <dev_lookup>
  801270:	83 c4 10             	add    $0x10,%esp
  801273:	85 c0                	test   %eax,%eax
  801275:	78 1f                	js     801296 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80127e:	74 1b                	je     80129b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801280:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801283:	8b 52 18             	mov    0x18(%edx),%edx
  801286:	85 d2                	test   %edx,%edx
  801288:	74 32                	je     8012bc <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80128a:	83 ec 08             	sub    $0x8,%esp
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	50                   	push   %eax
  801291:	ff d2                	call   *%edx
  801293:	83 c4 10             	add    $0x10,%esp
}
  801296:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801299:	c9                   	leave  
  80129a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80129b:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012a0:	8b 40 48             	mov    0x48(%eax),%eax
  8012a3:	83 ec 04             	sub    $0x4,%esp
  8012a6:	53                   	push   %ebx
  8012a7:	50                   	push   %eax
  8012a8:	68 6c 21 80 00       	push   $0x80216c
  8012ad:	e8 c3 ee ff ff       	call   800175 <cprintf>
		return -E_INVAL;
  8012b2:	83 c4 10             	add    $0x10,%esp
  8012b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ba:	eb da                	jmp    801296 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c1:	eb d3                	jmp    801296 <ftruncate+0x52>

008012c3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	53                   	push   %ebx
  8012c7:	83 ec 14             	sub    $0x14,%esp
  8012ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d0:	50                   	push   %eax
  8012d1:	ff 75 08             	pushl  0x8(%ebp)
  8012d4:	e8 81 fb ff ff       	call   800e5a <fd_lookup>
  8012d9:	83 c4 08             	add    $0x8,%esp
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	78 4b                	js     80132b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e6:	50                   	push   %eax
  8012e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ea:	ff 30                	pushl  (%eax)
  8012ec:	e8 bf fb ff ff       	call   800eb0 <dev_lookup>
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	78 33                	js     80132b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012ff:	74 2f                	je     801330 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801301:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801304:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80130b:	00 00 00 
	stat->st_isdir = 0;
  80130e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801315:	00 00 00 
	stat->st_dev = dev;
  801318:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80131e:	83 ec 08             	sub    $0x8,%esp
  801321:	53                   	push   %ebx
  801322:	ff 75 f0             	pushl  -0x10(%ebp)
  801325:	ff 50 14             	call   *0x14(%eax)
  801328:	83 c4 10             	add    $0x10,%esp
}
  80132b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    
		return -E_NOT_SUPP;
  801330:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801335:	eb f4                	jmp    80132b <fstat+0x68>

00801337 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	56                   	push   %esi
  80133b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80133c:	83 ec 08             	sub    $0x8,%esp
  80133f:	6a 00                	push   $0x0
  801341:	ff 75 08             	pushl  0x8(%ebp)
  801344:	e8 e7 01 00 00       	call   801530 <open>
  801349:	89 c3                	mov    %eax,%ebx
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 1b                	js     80136d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801352:	83 ec 08             	sub    $0x8,%esp
  801355:	ff 75 0c             	pushl  0xc(%ebp)
  801358:	50                   	push   %eax
  801359:	e8 65 ff ff ff       	call   8012c3 <fstat>
  80135e:	89 c6                	mov    %eax,%esi
	close(fd);
  801360:	89 1c 24             	mov    %ebx,(%esp)
  801363:	e8 27 fc ff ff       	call   800f8f <close>
	return r;
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	89 f3                	mov    %esi,%ebx
}
  80136d:	89 d8                	mov    %ebx,%eax
  80136f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801372:	5b                   	pop    %ebx
  801373:	5e                   	pop    %esi
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    

00801376 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	56                   	push   %esi
  80137a:	53                   	push   %ebx
  80137b:	89 c6                	mov    %eax,%esi
  80137d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80137f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801386:	74 27                	je     8013af <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801388:	6a 07                	push   $0x7
  80138a:	68 00 50 80 00       	push   $0x805000
  80138f:	56                   	push   %esi
  801390:	ff 35 00 40 80 00    	pushl  0x804000
  801396:	e8 61 07 00 00       	call   801afc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80139b:	83 c4 0c             	add    $0xc,%esp
  80139e:	6a 00                	push   $0x0
  8013a0:	53                   	push   %ebx
  8013a1:	6a 00                	push   $0x0
  8013a3:	e8 3d 07 00 00       	call   801ae5 <ipc_recv>
}
  8013a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013ab:	5b                   	pop    %ebx
  8013ac:	5e                   	pop    %esi
  8013ad:	5d                   	pop    %ebp
  8013ae:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013af:	83 ec 0c             	sub    $0xc,%esp
  8013b2:	6a 01                	push   $0x1
  8013b4:	e8 5a 07 00 00       	call   801b13 <ipc_find_env>
  8013b9:	a3 00 40 80 00       	mov    %eax,0x804000
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	eb c5                	jmp    801388 <fsipc+0x12>

008013c3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8013cf:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e1:	b8 02 00 00 00       	mov    $0x2,%eax
  8013e6:	e8 8b ff ff ff       	call   801376 <fsipc>
}
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <devfile_flush>:
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f9:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801403:	b8 06 00 00 00       	mov    $0x6,%eax
  801408:	e8 69 ff ff ff       	call   801376 <fsipc>
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <devfile_stat>:
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	53                   	push   %ebx
  801413:	83 ec 04             	sub    $0x4,%esp
  801416:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	8b 40 0c             	mov    0xc(%eax),%eax
  80141f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801424:	ba 00 00 00 00       	mov    $0x0,%edx
  801429:	b8 05 00 00 00       	mov    $0x5,%eax
  80142e:	e8 43 ff ff ff       	call   801376 <fsipc>
  801433:	85 c0                	test   %eax,%eax
  801435:	78 2c                	js     801463 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801437:	83 ec 08             	sub    $0x8,%esp
  80143a:	68 00 50 80 00       	push   $0x805000
  80143f:	53                   	push   %ebx
  801440:	e8 1a f3 ff ff       	call   80075f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801445:	a1 80 50 80 00       	mov    0x805080,%eax
  80144a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801450:	a1 84 50 80 00       	mov    0x805084,%eax
  801455:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801463:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <devfile_write>:
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 0c             	sub    $0xc,%esp
  80146e:	8b 45 10             	mov    0x10(%ebp),%eax
  801471:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801476:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80147b:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80147e:	8b 55 08             	mov    0x8(%ebp),%edx
  801481:	8b 52 0c             	mov    0xc(%edx),%edx
  801484:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  80148a:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  80148f:	50                   	push   %eax
  801490:	ff 75 0c             	pushl  0xc(%ebp)
  801493:	68 08 50 80 00       	push   $0x805008
  801498:	e8 50 f4 ff ff       	call   8008ed <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80149d:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a2:	b8 04 00 00 00       	mov    $0x4,%eax
  8014a7:	e8 ca fe ff ff       	call   801376 <fsipc>
}
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <devfile_read>:
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	56                   	push   %esi
  8014b2:	53                   	push   %ebx
  8014b3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8014bc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8014c1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014cc:	b8 03 00 00 00       	mov    $0x3,%eax
  8014d1:	e8 a0 fe ff ff       	call   801376 <fsipc>
  8014d6:	89 c3                	mov    %eax,%ebx
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	78 1f                	js     8014fb <devfile_read+0x4d>
	assert(r <= n);
  8014dc:	39 f0                	cmp    %esi,%eax
  8014de:	77 24                	ja     801504 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8014e0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014e5:	7f 33                	jg     80151a <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	50                   	push   %eax
  8014eb:	68 00 50 80 00       	push   $0x805000
  8014f0:	ff 75 0c             	pushl  0xc(%ebp)
  8014f3:	e8 f5 f3 ff ff       	call   8008ed <memmove>
	return r;
  8014f8:	83 c4 10             	add    $0x10,%esp
}
  8014fb:	89 d8                	mov    %ebx,%eax
  8014fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801500:	5b                   	pop    %ebx
  801501:	5e                   	pop    %esi
  801502:	5d                   	pop    %ebp
  801503:	c3                   	ret    
	assert(r <= n);
  801504:	68 d8 21 80 00       	push   $0x8021d8
  801509:	68 df 21 80 00       	push   $0x8021df
  80150e:	6a 7c                	push   $0x7c
  801510:	68 f4 21 80 00       	push   $0x8021f4
  801515:	e8 85 05 00 00       	call   801a9f <_panic>
	assert(r <= PGSIZE);
  80151a:	68 ff 21 80 00       	push   $0x8021ff
  80151f:	68 df 21 80 00       	push   $0x8021df
  801524:	6a 7d                	push   $0x7d
  801526:	68 f4 21 80 00       	push   $0x8021f4
  80152b:	e8 6f 05 00 00       	call   801a9f <_panic>

00801530 <open>:
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	56                   	push   %esi
  801534:	53                   	push   %ebx
  801535:	83 ec 1c             	sub    $0x1c,%esp
  801538:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80153b:	56                   	push   %esi
  80153c:	e8 e7 f1 ff ff       	call   800728 <strlen>
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801549:	7f 6c                	jg     8015b7 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80154b:	83 ec 0c             	sub    $0xc,%esp
  80154e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801551:	50                   	push   %eax
  801552:	e8 b4 f8 ff ff       	call   800e0b <fd_alloc>
  801557:	89 c3                	mov    %eax,%ebx
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 3c                	js     80159c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	56                   	push   %esi
  801564:	68 00 50 80 00       	push   $0x805000
  801569:	e8 f1 f1 ff ff       	call   80075f <strcpy>
	fsipcbuf.open.req_omode = mode;
  80156e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801571:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801576:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801579:	b8 01 00 00 00       	mov    $0x1,%eax
  80157e:	e8 f3 fd ff ff       	call   801376 <fsipc>
  801583:	89 c3                	mov    %eax,%ebx
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	85 c0                	test   %eax,%eax
  80158a:	78 19                	js     8015a5 <open+0x75>
	return fd2num(fd);
  80158c:	83 ec 0c             	sub    $0xc,%esp
  80158f:	ff 75 f4             	pushl  -0xc(%ebp)
  801592:	e8 4d f8 ff ff       	call   800de4 <fd2num>
  801597:	89 c3                	mov    %eax,%ebx
  801599:	83 c4 10             	add    $0x10,%esp
}
  80159c:	89 d8                	mov    %ebx,%eax
  80159e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a1:	5b                   	pop    %ebx
  8015a2:	5e                   	pop    %esi
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    
		fd_close(fd, 0);
  8015a5:	83 ec 08             	sub    $0x8,%esp
  8015a8:	6a 00                	push   $0x0
  8015aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ad:	e8 54 f9 ff ff       	call   800f06 <fd_close>
		return r;
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	eb e5                	jmp    80159c <open+0x6c>
		return -E_BAD_PATH;
  8015b7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015bc:	eb de                	jmp    80159c <open+0x6c>

008015be <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c9:	b8 08 00 00 00       	mov    $0x8,%eax
  8015ce:	e8 a3 fd ff ff       	call   801376 <fsipc>
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	56                   	push   %esi
  8015d9:	53                   	push   %ebx
  8015da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	ff 75 08             	pushl  0x8(%ebp)
  8015e3:	e8 0c f8 ff ff       	call   800df4 <fd2data>
  8015e8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8015ea:	83 c4 08             	add    $0x8,%esp
  8015ed:	68 0b 22 80 00       	push   $0x80220b
  8015f2:	53                   	push   %ebx
  8015f3:	e8 67 f1 ff ff       	call   80075f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8015f8:	8b 46 04             	mov    0x4(%esi),%eax
  8015fb:	2b 06                	sub    (%esi),%eax
  8015fd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801603:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80160a:	00 00 00 
	stat->st_dev = &devpipe;
  80160d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801614:	30 80 00 
	return 0;
}
  801617:	b8 00 00 00 00       	mov    $0x0,%eax
  80161c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80161f:	5b                   	pop    %ebx
  801620:	5e                   	pop    %esi
  801621:	5d                   	pop    %ebp
  801622:	c3                   	ret    

00801623 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	53                   	push   %ebx
  801627:	83 ec 0c             	sub    $0xc,%esp
  80162a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80162d:	53                   	push   %ebx
  80162e:	6a 00                	push   $0x0
  801630:	e8 a8 f5 ff ff       	call   800bdd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801635:	89 1c 24             	mov    %ebx,(%esp)
  801638:	e8 b7 f7 ff ff       	call   800df4 <fd2data>
  80163d:	83 c4 08             	add    $0x8,%esp
  801640:	50                   	push   %eax
  801641:	6a 00                	push   $0x0
  801643:	e8 95 f5 ff ff       	call   800bdd <sys_page_unmap>
}
  801648:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <_pipeisclosed>:
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	57                   	push   %edi
  801651:	56                   	push   %esi
  801652:	53                   	push   %ebx
  801653:	83 ec 1c             	sub    $0x1c,%esp
  801656:	89 c7                	mov    %eax,%edi
  801658:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80165a:	a1 04 40 80 00       	mov    0x804004,%eax
  80165f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801662:	83 ec 0c             	sub    $0xc,%esp
  801665:	57                   	push   %edi
  801666:	e8 e1 04 00 00       	call   801b4c <pageref>
  80166b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80166e:	89 34 24             	mov    %esi,(%esp)
  801671:	e8 d6 04 00 00       	call   801b4c <pageref>
		nn = thisenv->env_runs;
  801676:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80167c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	39 cb                	cmp    %ecx,%ebx
  801684:	74 1b                	je     8016a1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801686:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801689:	75 cf                	jne    80165a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80168b:	8b 42 58             	mov    0x58(%edx),%eax
  80168e:	6a 01                	push   $0x1
  801690:	50                   	push   %eax
  801691:	53                   	push   %ebx
  801692:	68 12 22 80 00       	push   $0x802212
  801697:	e8 d9 ea ff ff       	call   800175 <cprintf>
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	eb b9                	jmp    80165a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016a1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016a4:	0f 94 c0             	sete   %al
  8016a7:	0f b6 c0             	movzbl %al,%eax
}
  8016aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ad:	5b                   	pop    %ebx
  8016ae:	5e                   	pop    %esi
  8016af:	5f                   	pop    %edi
  8016b0:	5d                   	pop    %ebp
  8016b1:	c3                   	ret    

008016b2 <devpipe_write>:
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	57                   	push   %edi
  8016b6:	56                   	push   %esi
  8016b7:	53                   	push   %ebx
  8016b8:	83 ec 28             	sub    $0x28,%esp
  8016bb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8016be:	56                   	push   %esi
  8016bf:	e8 30 f7 ff ff       	call   800df4 <fd2data>
  8016c4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8016d1:	74 4f                	je     801722 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8016d3:	8b 43 04             	mov    0x4(%ebx),%eax
  8016d6:	8b 0b                	mov    (%ebx),%ecx
  8016d8:	8d 51 20             	lea    0x20(%ecx),%edx
  8016db:	39 d0                	cmp    %edx,%eax
  8016dd:	72 14                	jb     8016f3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8016df:	89 da                	mov    %ebx,%edx
  8016e1:	89 f0                	mov    %esi,%eax
  8016e3:	e8 65 ff ff ff       	call   80164d <_pipeisclosed>
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	75 3a                	jne    801726 <devpipe_write+0x74>
			sys_yield();
  8016ec:	e8 48 f4 ff ff       	call   800b39 <sys_yield>
  8016f1:	eb e0                	jmp    8016d3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8016f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016f6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8016fa:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8016fd:	89 c2                	mov    %eax,%edx
  8016ff:	c1 fa 1f             	sar    $0x1f,%edx
  801702:	89 d1                	mov    %edx,%ecx
  801704:	c1 e9 1b             	shr    $0x1b,%ecx
  801707:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80170a:	83 e2 1f             	and    $0x1f,%edx
  80170d:	29 ca                	sub    %ecx,%edx
  80170f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801713:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801717:	83 c0 01             	add    $0x1,%eax
  80171a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80171d:	83 c7 01             	add    $0x1,%edi
  801720:	eb ac                	jmp    8016ce <devpipe_write+0x1c>
	return i;
  801722:	89 f8                	mov    %edi,%eax
  801724:	eb 05                	jmp    80172b <devpipe_write+0x79>
				return 0;
  801726:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80172e:	5b                   	pop    %ebx
  80172f:	5e                   	pop    %esi
  801730:	5f                   	pop    %edi
  801731:	5d                   	pop    %ebp
  801732:	c3                   	ret    

00801733 <devpipe_read>:
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	57                   	push   %edi
  801737:	56                   	push   %esi
  801738:	53                   	push   %ebx
  801739:	83 ec 18             	sub    $0x18,%esp
  80173c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80173f:	57                   	push   %edi
  801740:	e8 af f6 ff ff       	call   800df4 <fd2data>
  801745:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801747:	83 c4 10             	add    $0x10,%esp
  80174a:	be 00 00 00 00       	mov    $0x0,%esi
  80174f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801752:	74 47                	je     80179b <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801754:	8b 03                	mov    (%ebx),%eax
  801756:	3b 43 04             	cmp    0x4(%ebx),%eax
  801759:	75 22                	jne    80177d <devpipe_read+0x4a>
			if (i > 0)
  80175b:	85 f6                	test   %esi,%esi
  80175d:	75 14                	jne    801773 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80175f:	89 da                	mov    %ebx,%edx
  801761:	89 f8                	mov    %edi,%eax
  801763:	e8 e5 fe ff ff       	call   80164d <_pipeisclosed>
  801768:	85 c0                	test   %eax,%eax
  80176a:	75 33                	jne    80179f <devpipe_read+0x6c>
			sys_yield();
  80176c:	e8 c8 f3 ff ff       	call   800b39 <sys_yield>
  801771:	eb e1                	jmp    801754 <devpipe_read+0x21>
				return i;
  801773:	89 f0                	mov    %esi,%eax
}
  801775:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801778:	5b                   	pop    %ebx
  801779:	5e                   	pop    %esi
  80177a:	5f                   	pop    %edi
  80177b:	5d                   	pop    %ebp
  80177c:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80177d:	99                   	cltd   
  80177e:	c1 ea 1b             	shr    $0x1b,%edx
  801781:	01 d0                	add    %edx,%eax
  801783:	83 e0 1f             	and    $0x1f,%eax
  801786:	29 d0                	sub    %edx,%eax
  801788:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80178d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801790:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801793:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801796:	83 c6 01             	add    $0x1,%esi
  801799:	eb b4                	jmp    80174f <devpipe_read+0x1c>
	return i;
  80179b:	89 f0                	mov    %esi,%eax
  80179d:	eb d6                	jmp    801775 <devpipe_read+0x42>
				return 0;
  80179f:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a4:	eb cf                	jmp    801775 <devpipe_read+0x42>

008017a6 <pipe>:
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	56                   	push   %esi
  8017aa:	53                   	push   %ebx
  8017ab:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8017ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b1:	50                   	push   %eax
  8017b2:	e8 54 f6 ff ff       	call   800e0b <fd_alloc>
  8017b7:	89 c3                	mov    %eax,%ebx
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	85 c0                	test   %eax,%eax
  8017be:	78 5b                	js     80181b <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	68 07 04 00 00       	push   $0x407
  8017c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8017cb:	6a 00                	push   $0x0
  8017cd:	e8 86 f3 ff ff       	call   800b58 <sys_page_alloc>
  8017d2:	89 c3                	mov    %eax,%ebx
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	78 40                	js     80181b <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8017db:	83 ec 0c             	sub    $0xc,%esp
  8017de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017e1:	50                   	push   %eax
  8017e2:	e8 24 f6 ff ff       	call   800e0b <fd_alloc>
  8017e7:	89 c3                	mov    %eax,%ebx
  8017e9:	83 c4 10             	add    $0x10,%esp
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	78 1b                	js     80180b <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	68 07 04 00 00       	push   $0x407
  8017f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8017fb:	6a 00                	push   $0x0
  8017fd:	e8 56 f3 ff ff       	call   800b58 <sys_page_alloc>
  801802:	89 c3                	mov    %eax,%ebx
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	85 c0                	test   %eax,%eax
  801809:	79 19                	jns    801824 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80180b:	83 ec 08             	sub    $0x8,%esp
  80180e:	ff 75 f4             	pushl  -0xc(%ebp)
  801811:	6a 00                	push   $0x0
  801813:	e8 c5 f3 ff ff       	call   800bdd <sys_page_unmap>
  801818:	83 c4 10             	add    $0x10,%esp
}
  80181b:	89 d8                	mov    %ebx,%eax
  80181d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801820:	5b                   	pop    %ebx
  801821:	5e                   	pop    %esi
  801822:	5d                   	pop    %ebp
  801823:	c3                   	ret    
	va = fd2data(fd0);
  801824:	83 ec 0c             	sub    $0xc,%esp
  801827:	ff 75 f4             	pushl  -0xc(%ebp)
  80182a:	e8 c5 f5 ff ff       	call   800df4 <fd2data>
  80182f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801831:	83 c4 0c             	add    $0xc,%esp
  801834:	68 07 04 00 00       	push   $0x407
  801839:	50                   	push   %eax
  80183a:	6a 00                	push   $0x0
  80183c:	e8 17 f3 ff ff       	call   800b58 <sys_page_alloc>
  801841:	89 c3                	mov    %eax,%ebx
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	85 c0                	test   %eax,%eax
  801848:	0f 88 8c 00 00 00    	js     8018da <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80184e:	83 ec 0c             	sub    $0xc,%esp
  801851:	ff 75 f0             	pushl  -0x10(%ebp)
  801854:	e8 9b f5 ff ff       	call   800df4 <fd2data>
  801859:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801860:	50                   	push   %eax
  801861:	6a 00                	push   $0x0
  801863:	56                   	push   %esi
  801864:	6a 00                	push   $0x0
  801866:	e8 30 f3 ff ff       	call   800b9b <sys_page_map>
  80186b:	89 c3                	mov    %eax,%ebx
  80186d:	83 c4 20             	add    $0x20,%esp
  801870:	85 c0                	test   %eax,%eax
  801872:	78 58                	js     8018cc <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801877:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80187d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801882:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801892:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801897:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a4:	e8 3b f5 ff ff       	call   800de4 <fd2num>
  8018a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ac:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018ae:	83 c4 04             	add    $0x4,%esp
  8018b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018b4:	e8 2b f5 ff ff       	call   800de4 <fd2num>
  8018b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018bc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018c7:	e9 4f ff ff ff       	jmp    80181b <pipe+0x75>
	sys_page_unmap(0, va);
  8018cc:	83 ec 08             	sub    $0x8,%esp
  8018cf:	56                   	push   %esi
  8018d0:	6a 00                	push   $0x0
  8018d2:	e8 06 f3 ff ff       	call   800bdd <sys_page_unmap>
  8018d7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8018da:	83 ec 08             	sub    $0x8,%esp
  8018dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e0:	6a 00                	push   $0x0
  8018e2:	e8 f6 f2 ff ff       	call   800bdd <sys_page_unmap>
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	e9 1c ff ff ff       	jmp    80180b <pipe+0x65>

008018ef <pipeisclosed>:
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f8:	50                   	push   %eax
  8018f9:	ff 75 08             	pushl  0x8(%ebp)
  8018fc:	e8 59 f5 ff ff       	call   800e5a <fd_lookup>
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	85 c0                	test   %eax,%eax
  801906:	78 18                	js     801920 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	ff 75 f4             	pushl  -0xc(%ebp)
  80190e:	e8 e1 f4 ff ff       	call   800df4 <fd2data>
	return _pipeisclosed(fd, p);
  801913:	89 c2                	mov    %eax,%edx
  801915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801918:	e8 30 fd ff ff       	call   80164d <_pipeisclosed>
  80191d:	83 c4 10             	add    $0x10,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801925:	b8 00 00 00 00       	mov    $0x0,%eax
  80192a:	5d                   	pop    %ebp
  80192b:	c3                   	ret    

0080192c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801932:	68 2a 22 80 00       	push   $0x80222a
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	e8 20 ee ff ff       	call   80075f <strcpy>
	return 0;
}
  80193f:	b8 00 00 00 00       	mov    $0x0,%eax
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <devcons_write>:
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	57                   	push   %edi
  80194a:	56                   	push   %esi
  80194b:	53                   	push   %ebx
  80194c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801952:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801957:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80195d:	eb 2f                	jmp    80198e <devcons_write+0x48>
		m = n - tot;
  80195f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801962:	29 f3                	sub    %esi,%ebx
  801964:	83 fb 7f             	cmp    $0x7f,%ebx
  801967:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80196c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80196f:	83 ec 04             	sub    $0x4,%esp
  801972:	53                   	push   %ebx
  801973:	89 f0                	mov    %esi,%eax
  801975:	03 45 0c             	add    0xc(%ebp),%eax
  801978:	50                   	push   %eax
  801979:	57                   	push   %edi
  80197a:	e8 6e ef ff ff       	call   8008ed <memmove>
		sys_cputs(buf, m);
  80197f:	83 c4 08             	add    $0x8,%esp
  801982:	53                   	push   %ebx
  801983:	57                   	push   %edi
  801984:	e8 13 f1 ff ff       	call   800a9c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801989:	01 de                	add    %ebx,%esi
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801991:	72 cc                	jb     80195f <devcons_write+0x19>
}
  801993:	89 f0                	mov    %esi,%eax
  801995:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801998:	5b                   	pop    %ebx
  801999:	5e                   	pop    %esi
  80199a:	5f                   	pop    %edi
  80199b:	5d                   	pop    %ebp
  80199c:	c3                   	ret    

0080199d <devcons_read>:
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	83 ec 08             	sub    $0x8,%esp
  8019a3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8019a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019ac:	75 07                	jne    8019b5 <devcons_read+0x18>
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    
		sys_yield();
  8019b0:	e8 84 f1 ff ff       	call   800b39 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8019b5:	e8 00 f1 ff ff       	call   800aba <sys_cgetc>
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	74 f2                	je     8019b0 <devcons_read+0x13>
	if (c < 0)
  8019be:	85 c0                	test   %eax,%eax
  8019c0:	78 ec                	js     8019ae <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8019c2:	83 f8 04             	cmp    $0x4,%eax
  8019c5:	74 0c                	je     8019d3 <devcons_read+0x36>
	*(char*)vbuf = c;
  8019c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ca:	88 02                	mov    %al,(%edx)
	return 1;
  8019cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d1:	eb db                	jmp    8019ae <devcons_read+0x11>
		return 0;
  8019d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d8:	eb d4                	jmp    8019ae <devcons_read+0x11>

008019da <cputchar>:
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8019e6:	6a 01                	push   $0x1
  8019e8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019eb:	50                   	push   %eax
  8019ec:	e8 ab f0 ff ff       	call   800a9c <sys_cputs>
}
  8019f1:	83 c4 10             	add    $0x10,%esp
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <getchar>:
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8019fc:	6a 01                	push   $0x1
  8019fe:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a01:	50                   	push   %eax
  801a02:	6a 00                	push   $0x0
  801a04:	e8 c2 f6 ff ff       	call   8010cb <read>
	if (r < 0)
  801a09:	83 c4 10             	add    $0x10,%esp
  801a0c:	85 c0                	test   %eax,%eax
  801a0e:	78 08                	js     801a18 <getchar+0x22>
	if (r < 1)
  801a10:	85 c0                	test   %eax,%eax
  801a12:	7e 06                	jle    801a1a <getchar+0x24>
	return c;
  801a14:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    
		return -E_EOF;
  801a1a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a1f:	eb f7                	jmp    801a18 <getchar+0x22>

00801a21 <iscons>:
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a27:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2a:	50                   	push   %eax
  801a2b:	ff 75 08             	pushl  0x8(%ebp)
  801a2e:	e8 27 f4 ff ff       	call   800e5a <fd_lookup>
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	85 c0                	test   %eax,%eax
  801a38:	78 11                	js     801a4b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a43:	39 10                	cmp    %edx,(%eax)
  801a45:	0f 94 c0             	sete   %al
  801a48:	0f b6 c0             	movzbl %al,%eax
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <opencons>:
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801a53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a56:	50                   	push   %eax
  801a57:	e8 af f3 ff ff       	call   800e0b <fd_alloc>
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	78 3a                	js     801a9d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	68 07 04 00 00       	push   $0x407
  801a6b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a6e:	6a 00                	push   $0x0
  801a70:	e8 e3 f0 ff ff       	call   800b58 <sys_page_alloc>
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	78 21                	js     801a9d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a85:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a91:	83 ec 0c             	sub    $0xc,%esp
  801a94:	50                   	push   %eax
  801a95:	e8 4a f3 ff ff       	call   800de4 <fd2num>
  801a9a:	83 c4 10             	add    $0x10,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	56                   	push   %esi
  801aa3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801aa4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801aa7:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801aad:	e8 68 f0 ff ff       	call   800b1a <sys_getenvid>
  801ab2:	83 ec 0c             	sub    $0xc,%esp
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	ff 75 08             	pushl  0x8(%ebp)
  801abb:	56                   	push   %esi
  801abc:	50                   	push   %eax
  801abd:	68 38 22 80 00       	push   $0x802238
  801ac2:	e8 ae e6 ff ff       	call   800175 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ac7:	83 c4 18             	add    $0x18,%esp
  801aca:	53                   	push   %ebx
  801acb:	ff 75 10             	pushl  0x10(%ebp)
  801ace:	e8 51 e6 ff ff       	call   800124 <vcprintf>
	cprintf("\n");
  801ad3:	c7 04 24 23 22 80 00 	movl   $0x802223,(%esp)
  801ada:	e8 96 e6 ff ff       	call   800175 <cprintf>
  801adf:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ae2:	cc                   	int3   
  801ae3:	eb fd                	jmp    801ae2 <_panic+0x43>

00801ae5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801aeb:	68 5c 22 80 00       	push   $0x80225c
  801af0:	6a 1a                	push   $0x1a
  801af2:	68 75 22 80 00       	push   $0x802275
  801af7:	e8 a3 ff ff ff       	call   801a9f <_panic>

00801afc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801b02:	68 7f 22 80 00       	push   $0x80227f
  801b07:	6a 2a                	push   $0x2a
  801b09:	68 75 22 80 00       	push   $0x802275
  801b0e:	e8 8c ff ff ff       	call   801a9f <_panic>

00801b13 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801b1e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801b21:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801b27:	8b 52 50             	mov    0x50(%edx),%edx
  801b2a:	39 ca                	cmp    %ecx,%edx
  801b2c:	74 11                	je     801b3f <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801b2e:	83 c0 01             	add    $0x1,%eax
  801b31:	3d 00 04 00 00       	cmp    $0x400,%eax
  801b36:	75 e6                	jne    801b1e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801b38:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3d:	eb 0b                	jmp    801b4a <ipc_find_env+0x37>
			return envs[i].env_id;
  801b3f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b42:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b47:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b4a:	5d                   	pop    %ebp
  801b4b:	c3                   	ret    

00801b4c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b52:	89 d0                	mov    %edx,%eax
  801b54:	c1 e8 16             	shr    $0x16,%eax
  801b57:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801b63:	f6 c1 01             	test   $0x1,%cl
  801b66:	74 1d                	je     801b85 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801b68:	c1 ea 0c             	shr    $0xc,%edx
  801b6b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801b72:	f6 c2 01             	test   $0x1,%dl
  801b75:	74 0e                	je     801b85 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b77:	c1 ea 0c             	shr    $0xc,%edx
  801b7a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801b81:	ef 
  801b82:	0f b7 c0             	movzwl %ax,%eax
}
  801b85:	5d                   	pop    %ebp
  801b86:	c3                   	ret    
  801b87:	66 90                	xchg   %ax,%ax
  801b89:	66 90                	xchg   %ax,%ax
  801b8b:	66 90                	xchg   %ax,%ax
  801b8d:	66 90                	xchg   %ax,%ax
  801b8f:	90                   	nop

00801b90 <__udivdi3>:
  801b90:	55                   	push   %ebp
  801b91:	57                   	push   %edi
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	83 ec 1c             	sub    $0x1c,%esp
  801b97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801b9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801b9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ba3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ba7:	85 d2                	test   %edx,%edx
  801ba9:	75 35                	jne    801be0 <__udivdi3+0x50>
  801bab:	39 f3                	cmp    %esi,%ebx
  801bad:	0f 87 bd 00 00 00    	ja     801c70 <__udivdi3+0xe0>
  801bb3:	85 db                	test   %ebx,%ebx
  801bb5:	89 d9                	mov    %ebx,%ecx
  801bb7:	75 0b                	jne    801bc4 <__udivdi3+0x34>
  801bb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbe:	31 d2                	xor    %edx,%edx
  801bc0:	f7 f3                	div    %ebx
  801bc2:	89 c1                	mov    %eax,%ecx
  801bc4:	31 d2                	xor    %edx,%edx
  801bc6:	89 f0                	mov    %esi,%eax
  801bc8:	f7 f1                	div    %ecx
  801bca:	89 c6                	mov    %eax,%esi
  801bcc:	89 e8                	mov    %ebp,%eax
  801bce:	89 f7                	mov    %esi,%edi
  801bd0:	f7 f1                	div    %ecx
  801bd2:	89 fa                	mov    %edi,%edx
  801bd4:	83 c4 1c             	add    $0x1c,%esp
  801bd7:	5b                   	pop    %ebx
  801bd8:	5e                   	pop    %esi
  801bd9:	5f                   	pop    %edi
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    
  801bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801be0:	39 f2                	cmp    %esi,%edx
  801be2:	77 7c                	ja     801c60 <__udivdi3+0xd0>
  801be4:	0f bd fa             	bsr    %edx,%edi
  801be7:	83 f7 1f             	xor    $0x1f,%edi
  801bea:	0f 84 98 00 00 00    	je     801c88 <__udivdi3+0xf8>
  801bf0:	89 f9                	mov    %edi,%ecx
  801bf2:	b8 20 00 00 00       	mov    $0x20,%eax
  801bf7:	29 f8                	sub    %edi,%eax
  801bf9:	d3 e2                	shl    %cl,%edx
  801bfb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bff:	89 c1                	mov    %eax,%ecx
  801c01:	89 da                	mov    %ebx,%edx
  801c03:	d3 ea                	shr    %cl,%edx
  801c05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801c09:	09 d1                	or     %edx,%ecx
  801c0b:	89 f2                	mov    %esi,%edx
  801c0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c11:	89 f9                	mov    %edi,%ecx
  801c13:	d3 e3                	shl    %cl,%ebx
  801c15:	89 c1                	mov    %eax,%ecx
  801c17:	d3 ea                	shr    %cl,%edx
  801c19:	89 f9                	mov    %edi,%ecx
  801c1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801c1f:	d3 e6                	shl    %cl,%esi
  801c21:	89 eb                	mov    %ebp,%ebx
  801c23:	89 c1                	mov    %eax,%ecx
  801c25:	d3 eb                	shr    %cl,%ebx
  801c27:	09 de                	or     %ebx,%esi
  801c29:	89 f0                	mov    %esi,%eax
  801c2b:	f7 74 24 08          	divl   0x8(%esp)
  801c2f:	89 d6                	mov    %edx,%esi
  801c31:	89 c3                	mov    %eax,%ebx
  801c33:	f7 64 24 0c          	mull   0xc(%esp)
  801c37:	39 d6                	cmp    %edx,%esi
  801c39:	72 0c                	jb     801c47 <__udivdi3+0xb7>
  801c3b:	89 f9                	mov    %edi,%ecx
  801c3d:	d3 e5                	shl    %cl,%ebp
  801c3f:	39 c5                	cmp    %eax,%ebp
  801c41:	73 5d                	jae    801ca0 <__udivdi3+0x110>
  801c43:	39 d6                	cmp    %edx,%esi
  801c45:	75 59                	jne    801ca0 <__udivdi3+0x110>
  801c47:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c4a:	31 ff                	xor    %edi,%edi
  801c4c:	89 fa                	mov    %edi,%edx
  801c4e:	83 c4 1c             	add    $0x1c,%esp
  801c51:	5b                   	pop    %ebx
  801c52:	5e                   	pop    %esi
  801c53:	5f                   	pop    %edi
  801c54:	5d                   	pop    %ebp
  801c55:	c3                   	ret    
  801c56:	8d 76 00             	lea    0x0(%esi),%esi
  801c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801c60:	31 ff                	xor    %edi,%edi
  801c62:	31 c0                	xor    %eax,%eax
  801c64:	89 fa                	mov    %edi,%edx
  801c66:	83 c4 1c             	add    $0x1c,%esp
  801c69:	5b                   	pop    %ebx
  801c6a:	5e                   	pop    %esi
  801c6b:	5f                   	pop    %edi
  801c6c:	5d                   	pop    %ebp
  801c6d:	c3                   	ret    
  801c6e:	66 90                	xchg   %ax,%ax
  801c70:	31 ff                	xor    %edi,%edi
  801c72:	89 e8                	mov    %ebp,%eax
  801c74:	89 f2                	mov    %esi,%edx
  801c76:	f7 f3                	div    %ebx
  801c78:	89 fa                	mov    %edi,%edx
  801c7a:	83 c4 1c             	add    $0x1c,%esp
  801c7d:	5b                   	pop    %ebx
  801c7e:	5e                   	pop    %esi
  801c7f:	5f                   	pop    %edi
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    
  801c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c88:	39 f2                	cmp    %esi,%edx
  801c8a:	72 06                	jb     801c92 <__udivdi3+0x102>
  801c8c:	31 c0                	xor    %eax,%eax
  801c8e:	39 eb                	cmp    %ebp,%ebx
  801c90:	77 d2                	ja     801c64 <__udivdi3+0xd4>
  801c92:	b8 01 00 00 00       	mov    $0x1,%eax
  801c97:	eb cb                	jmp    801c64 <__udivdi3+0xd4>
  801c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ca0:	89 d8                	mov    %ebx,%eax
  801ca2:	31 ff                	xor    %edi,%edi
  801ca4:	eb be                	jmp    801c64 <__udivdi3+0xd4>
  801ca6:	66 90                	xchg   %ax,%ax
  801ca8:	66 90                	xchg   %ax,%ax
  801caa:	66 90                	xchg   %ax,%ax
  801cac:	66 90                	xchg   %ax,%ax
  801cae:	66 90                	xchg   %ax,%ax

00801cb0 <__umoddi3>:
  801cb0:	55                   	push   %ebp
  801cb1:	57                   	push   %edi
  801cb2:	56                   	push   %esi
  801cb3:	53                   	push   %ebx
  801cb4:	83 ec 1c             	sub    $0x1c,%esp
  801cb7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801cbb:	8b 74 24 30          	mov    0x30(%esp),%esi
  801cbf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801cc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cc7:	85 ed                	test   %ebp,%ebp
  801cc9:	89 f0                	mov    %esi,%eax
  801ccb:	89 da                	mov    %ebx,%edx
  801ccd:	75 19                	jne    801ce8 <__umoddi3+0x38>
  801ccf:	39 df                	cmp    %ebx,%edi
  801cd1:	0f 86 b1 00 00 00    	jbe    801d88 <__umoddi3+0xd8>
  801cd7:	f7 f7                	div    %edi
  801cd9:	89 d0                	mov    %edx,%eax
  801cdb:	31 d2                	xor    %edx,%edx
  801cdd:	83 c4 1c             	add    $0x1c,%esp
  801ce0:	5b                   	pop    %ebx
  801ce1:	5e                   	pop    %esi
  801ce2:	5f                   	pop    %edi
  801ce3:	5d                   	pop    %ebp
  801ce4:	c3                   	ret    
  801ce5:	8d 76 00             	lea    0x0(%esi),%esi
  801ce8:	39 dd                	cmp    %ebx,%ebp
  801cea:	77 f1                	ja     801cdd <__umoddi3+0x2d>
  801cec:	0f bd cd             	bsr    %ebp,%ecx
  801cef:	83 f1 1f             	xor    $0x1f,%ecx
  801cf2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cf6:	0f 84 b4 00 00 00    	je     801db0 <__umoddi3+0x100>
  801cfc:	b8 20 00 00 00       	mov    $0x20,%eax
  801d01:	89 c2                	mov    %eax,%edx
  801d03:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d07:	29 c2                	sub    %eax,%edx
  801d09:	89 c1                	mov    %eax,%ecx
  801d0b:	89 f8                	mov    %edi,%eax
  801d0d:	d3 e5                	shl    %cl,%ebp
  801d0f:	89 d1                	mov    %edx,%ecx
  801d11:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d15:	d3 e8                	shr    %cl,%eax
  801d17:	09 c5                	or     %eax,%ebp
  801d19:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d1d:	89 c1                	mov    %eax,%ecx
  801d1f:	d3 e7                	shl    %cl,%edi
  801d21:	89 d1                	mov    %edx,%ecx
  801d23:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801d27:	89 df                	mov    %ebx,%edi
  801d29:	d3 ef                	shr    %cl,%edi
  801d2b:	89 c1                	mov    %eax,%ecx
  801d2d:	89 f0                	mov    %esi,%eax
  801d2f:	d3 e3                	shl    %cl,%ebx
  801d31:	89 d1                	mov    %edx,%ecx
  801d33:	89 fa                	mov    %edi,%edx
  801d35:	d3 e8                	shr    %cl,%eax
  801d37:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801d3c:	09 d8                	or     %ebx,%eax
  801d3e:	f7 f5                	div    %ebp
  801d40:	d3 e6                	shl    %cl,%esi
  801d42:	89 d1                	mov    %edx,%ecx
  801d44:	f7 64 24 08          	mull   0x8(%esp)
  801d48:	39 d1                	cmp    %edx,%ecx
  801d4a:	89 c3                	mov    %eax,%ebx
  801d4c:	89 d7                	mov    %edx,%edi
  801d4e:	72 06                	jb     801d56 <__umoddi3+0xa6>
  801d50:	75 0e                	jne    801d60 <__umoddi3+0xb0>
  801d52:	39 c6                	cmp    %eax,%esi
  801d54:	73 0a                	jae    801d60 <__umoddi3+0xb0>
  801d56:	2b 44 24 08          	sub    0x8(%esp),%eax
  801d5a:	19 ea                	sbb    %ebp,%edx
  801d5c:	89 d7                	mov    %edx,%edi
  801d5e:	89 c3                	mov    %eax,%ebx
  801d60:	89 ca                	mov    %ecx,%edx
  801d62:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801d67:	29 de                	sub    %ebx,%esi
  801d69:	19 fa                	sbb    %edi,%edx
  801d6b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d6f:	89 d0                	mov    %edx,%eax
  801d71:	d3 e0                	shl    %cl,%eax
  801d73:	89 d9                	mov    %ebx,%ecx
  801d75:	d3 ee                	shr    %cl,%esi
  801d77:	d3 ea                	shr    %cl,%edx
  801d79:	09 f0                	or     %esi,%eax
  801d7b:	83 c4 1c             	add    $0x1c,%esp
  801d7e:	5b                   	pop    %ebx
  801d7f:	5e                   	pop    %esi
  801d80:	5f                   	pop    %edi
  801d81:	5d                   	pop    %ebp
  801d82:	c3                   	ret    
  801d83:	90                   	nop
  801d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d88:	85 ff                	test   %edi,%edi
  801d8a:	89 f9                	mov    %edi,%ecx
  801d8c:	75 0b                	jne    801d99 <__umoddi3+0xe9>
  801d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d93:	31 d2                	xor    %edx,%edx
  801d95:	f7 f7                	div    %edi
  801d97:	89 c1                	mov    %eax,%ecx
  801d99:	89 d8                	mov    %ebx,%eax
  801d9b:	31 d2                	xor    %edx,%edx
  801d9d:	f7 f1                	div    %ecx
  801d9f:	89 f0                	mov    %esi,%eax
  801da1:	f7 f1                	div    %ecx
  801da3:	e9 31 ff ff ff       	jmp    801cd9 <__umoddi3+0x29>
  801da8:	90                   	nop
  801da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801db0:	39 dd                	cmp    %ebx,%ebp
  801db2:	72 08                	jb     801dbc <__umoddi3+0x10c>
  801db4:	39 f7                	cmp    %esi,%edi
  801db6:	0f 87 21 ff ff ff    	ja     801cdd <__umoddi3+0x2d>
  801dbc:	89 da                	mov    %ebx,%edx
  801dbe:	89 f0                	mov    %esi,%eax
  801dc0:	29 f8                	sub    %edi,%eax
  801dc2:	19 ea                	sbb    %ebp,%edx
  801dc4:	e9 14 ff ff ff       	jmp    801cdd <__umoddi3+0x2d>
