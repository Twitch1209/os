
obj/user/fairness.debug：     文件格式 elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 fb 0a 00 00       	call   800b3b <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 04 40 80 00 7c 	cmpl   $0xeec0007c,0x804004
  800049:	00 c0 ee 
  80004c:	75 26                	jne    800074 <umain+0x41>
		while (1) {
			ipc_recv(&who, 0, 0);
  80004e:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	6a 00                	push   $0x0
  800056:	6a 00                	push   $0x0
  800058:	56                   	push   %esi
  800059:	e8 0c 0d 00 00       	call   800d6a <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80005e:	83 c4 0c             	add    $0xc,%esp
  800061:	ff 75 f4             	pushl  -0xc(%ebp)
  800064:	53                   	push   %ebx
  800065:	68 60 1d 80 00       	push   $0x801d60
  80006a:	e8 27 01 00 00       	call   800196 <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	eb dd                	jmp    800051 <umain+0x1e>
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800074:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	68 71 1d 80 00       	push   $0x801d71
  800083:	e8 0e 01 00 00       	call   800196 <cprintf>
  800088:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  80008b:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800090:	6a 00                	push   $0x0
  800092:	6a 00                	push   $0x0
  800094:	6a 00                	push   $0x0
  800096:	50                   	push   %eax
  800097:	e8 e5 0c 00 00       	call   800d81 <ipc_send>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb ea                	jmp    80008b <umain+0x58>

008000a1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ac:	e8 8a 0a 00 00       	call   800b3b <sys_getenvid>
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000be:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c3:	85 db                	test   %ebx,%ebx
  8000c5:	7e 07                	jle    8000ce <libmain+0x2d>
		binaryname = argv[0];
  8000c7:	8b 06                	mov    (%esi),%eax
  8000c9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ce:	83 ec 08             	sub    $0x8,%esp
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
  8000d3:	e8 5b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d8:	e8 0a 00 00 00       	call   8000e7 <exit>
}
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e3:	5b                   	pop    %ebx
  8000e4:	5e                   	pop    %esi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ed:	e8 b5 0e 00 00       	call   800fa7 <close_all>
	sys_env_destroy(0);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	6a 00                	push   $0x0
  8000f7:	e8 fe 09 00 00       	call   800afa <sys_env_destroy>
}
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    

00800101 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	53                   	push   %ebx
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80010b:	8b 13                	mov    (%ebx),%edx
  80010d:	8d 42 01             	lea    0x1(%edx),%eax
  800110:	89 03                	mov    %eax,(%ebx)
  800112:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800115:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800119:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011e:	74 09                	je     800129 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800120:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800124:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800127:	c9                   	leave  
  800128:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800129:	83 ec 08             	sub    $0x8,%esp
  80012c:	68 ff 00 00 00       	push   $0xff
  800131:	8d 43 08             	lea    0x8(%ebx),%eax
  800134:	50                   	push   %eax
  800135:	e8 83 09 00 00       	call   800abd <sys_cputs>
		b->idx = 0;
  80013a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800140:	83 c4 10             	add    $0x10,%esp
  800143:	eb db                	jmp    800120 <putch+0x1f>

00800145 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80014e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800155:	00 00 00 
	b.cnt = 0;
  800158:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800162:	ff 75 0c             	pushl  0xc(%ebp)
  800165:	ff 75 08             	pushl  0x8(%ebp)
  800168:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80016e:	50                   	push   %eax
  80016f:	68 01 01 80 00       	push   $0x800101
  800174:	e8 1a 01 00 00       	call   800293 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800179:	83 c4 08             	add    $0x8,%esp
  80017c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800182:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 2f 09 00 00       	call   800abd <sys_cputs>

	return b.cnt;
}
  80018e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80019c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019f:	50                   	push   %eax
  8001a0:	ff 75 08             	pushl  0x8(%ebp)
  8001a3:	e8 9d ff ff ff       	call   800145 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	57                   	push   %edi
  8001ae:	56                   	push   %esi
  8001af:	53                   	push   %ebx
  8001b0:	83 ec 1c             	sub    $0x1c,%esp
  8001b3:	89 c7                	mov    %eax,%edi
  8001b5:	89 d6                	mov    %edx,%esi
  8001b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ce:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001d1:	39 d3                	cmp    %edx,%ebx
  8001d3:	72 05                	jb     8001da <printnum+0x30>
  8001d5:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001d8:	77 7a                	ja     800254 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	ff 75 18             	pushl  0x18(%ebp)
  8001e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8001e3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001e6:	53                   	push   %ebx
  8001e7:	ff 75 10             	pushl  0x10(%ebp)
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f3:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f9:	e8 12 19 00 00       	call   801b10 <__udivdi3>
  8001fe:	83 c4 18             	add    $0x18,%esp
  800201:	52                   	push   %edx
  800202:	50                   	push   %eax
  800203:	89 f2                	mov    %esi,%edx
  800205:	89 f8                	mov    %edi,%eax
  800207:	e8 9e ff ff ff       	call   8001aa <printnum>
  80020c:	83 c4 20             	add    $0x20,%esp
  80020f:	eb 13                	jmp    800224 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	56                   	push   %esi
  800215:	ff 75 18             	pushl  0x18(%ebp)
  800218:	ff d7                	call   *%edi
  80021a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80021d:	83 eb 01             	sub    $0x1,%ebx
  800220:	85 db                	test   %ebx,%ebx
  800222:	7f ed                	jg     800211 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	56                   	push   %esi
  800228:	83 ec 04             	sub    $0x4,%esp
  80022b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022e:	ff 75 e0             	pushl  -0x20(%ebp)
  800231:	ff 75 dc             	pushl  -0x24(%ebp)
  800234:	ff 75 d8             	pushl  -0x28(%ebp)
  800237:	e8 f4 19 00 00       	call   801c30 <__umoddi3>
  80023c:	83 c4 14             	add    $0x14,%esp
  80023f:	0f be 80 92 1d 80 00 	movsbl 0x801d92(%eax),%eax
  800246:	50                   	push   %eax
  800247:	ff d7                	call   *%edi
}
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024f:	5b                   	pop    %ebx
  800250:	5e                   	pop    %esi
  800251:	5f                   	pop    %edi
  800252:	5d                   	pop    %ebp
  800253:	c3                   	ret    
  800254:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800257:	eb c4                	jmp    80021d <printnum+0x73>

00800259 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80025f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800263:	8b 10                	mov    (%eax),%edx
  800265:	3b 50 04             	cmp    0x4(%eax),%edx
  800268:	73 0a                	jae    800274 <sprintputch+0x1b>
		*b->buf++ = ch;
  80026a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80026d:	89 08                	mov    %ecx,(%eax)
  80026f:	8b 45 08             	mov    0x8(%ebp),%eax
  800272:	88 02                	mov    %al,(%edx)
}
  800274:	5d                   	pop    %ebp
  800275:	c3                   	ret    

00800276 <printfmt>:
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80027c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80027f:	50                   	push   %eax
  800280:	ff 75 10             	pushl  0x10(%ebp)
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	e8 05 00 00 00       	call   800293 <vprintfmt>
}
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <vprintfmt>:
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	57                   	push   %edi
  800297:	56                   	push   %esi
  800298:	53                   	push   %ebx
  800299:	83 ec 2c             	sub    $0x2c,%esp
  80029c:	8b 75 08             	mov    0x8(%ebp),%esi
  80029f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002a2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002a5:	e9 8c 03 00 00       	jmp    800636 <vprintfmt+0x3a3>
		padc = ' ';
  8002aa:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002ae:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002b5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002bc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002c3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c8:	8d 47 01             	lea    0x1(%edi),%eax
  8002cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ce:	0f b6 17             	movzbl (%edi),%edx
  8002d1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002d4:	3c 55                	cmp    $0x55,%al
  8002d6:	0f 87 dd 03 00 00    	ja     8006b9 <vprintfmt+0x426>
  8002dc:	0f b6 c0             	movzbl %al,%eax
  8002df:	ff 24 85 e0 1e 80 00 	jmp    *0x801ee0(,%eax,4)
  8002e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e9:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002ed:	eb d9                	jmp    8002c8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002f2:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002f6:	eb d0                	jmp    8002c8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002f8:	0f b6 d2             	movzbl %dl,%edx
  8002fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800303:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800306:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800309:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80030d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800310:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800313:	83 f9 09             	cmp    $0x9,%ecx
  800316:	77 55                	ja     80036d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800318:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80031b:	eb e9                	jmp    800306 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80031d:	8b 45 14             	mov    0x14(%ebp),%eax
  800320:	8b 00                	mov    (%eax),%eax
  800322:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800325:	8b 45 14             	mov    0x14(%ebp),%eax
  800328:	8d 40 04             	lea    0x4(%eax),%eax
  80032b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80032e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800331:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800335:	79 91                	jns    8002c8 <vprintfmt+0x35>
				width = precision, precision = -1;
  800337:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80033a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80033d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800344:	eb 82                	jmp    8002c8 <vprintfmt+0x35>
  800346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	ba 00 00 00 00       	mov    $0x0,%edx
  800350:	0f 49 d0             	cmovns %eax,%edx
  800353:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800359:	e9 6a ff ff ff       	jmp    8002c8 <vprintfmt+0x35>
  80035e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800361:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800368:	e9 5b ff ff ff       	jmp    8002c8 <vprintfmt+0x35>
  80036d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800370:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800373:	eb bc                	jmp    800331 <vprintfmt+0x9e>
			lflag++;
  800375:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800378:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80037b:	e9 48 ff ff ff       	jmp    8002c8 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800380:	8b 45 14             	mov    0x14(%ebp),%eax
  800383:	8d 78 04             	lea    0x4(%eax),%edi
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	53                   	push   %ebx
  80038a:	ff 30                	pushl  (%eax)
  80038c:	ff d6                	call   *%esi
			break;
  80038e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800391:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800394:	e9 9a 02 00 00       	jmp    800633 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800399:	8b 45 14             	mov    0x14(%ebp),%eax
  80039c:	8d 78 04             	lea    0x4(%eax),%edi
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	99                   	cltd   
  8003a2:	31 d0                	xor    %edx,%eax
  8003a4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a6:	83 f8 0f             	cmp    $0xf,%eax
  8003a9:	7f 23                	jg     8003ce <vprintfmt+0x13b>
  8003ab:	8b 14 85 40 20 80 00 	mov    0x802040(,%eax,4),%edx
  8003b2:	85 d2                	test   %edx,%edx
  8003b4:	74 18                	je     8003ce <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003b6:	52                   	push   %edx
  8003b7:	68 ad 21 80 00       	push   $0x8021ad
  8003bc:	53                   	push   %ebx
  8003bd:	56                   	push   %esi
  8003be:	e8 b3 fe ff ff       	call   800276 <printfmt>
  8003c3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c9:	e9 65 02 00 00       	jmp    800633 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8003ce:	50                   	push   %eax
  8003cf:	68 aa 1d 80 00       	push   $0x801daa
  8003d4:	53                   	push   %ebx
  8003d5:	56                   	push   %esi
  8003d6:	e8 9b fe ff ff       	call   800276 <printfmt>
  8003db:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003de:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e1:	e9 4d 02 00 00       	jmp    800633 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	83 c0 04             	add    $0x4,%eax
  8003ec:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f2:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003f4:	85 ff                	test   %edi,%edi
  8003f6:	b8 a3 1d 80 00       	mov    $0x801da3,%eax
  8003fb:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800402:	0f 8e bd 00 00 00    	jle    8004c5 <vprintfmt+0x232>
  800408:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80040c:	75 0e                	jne    80041c <vprintfmt+0x189>
  80040e:	89 75 08             	mov    %esi,0x8(%ebp)
  800411:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800414:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800417:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80041a:	eb 6d                	jmp    800489 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	ff 75 d0             	pushl  -0x30(%ebp)
  800422:	57                   	push   %edi
  800423:	e8 39 03 00 00       	call   800761 <strnlen>
  800428:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80042b:	29 c1                	sub    %eax,%ecx
  80042d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800430:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800433:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800437:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80043d:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80043f:	eb 0f                	jmp    800450 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	53                   	push   %ebx
  800445:	ff 75 e0             	pushl  -0x20(%ebp)
  800448:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80044a:	83 ef 01             	sub    $0x1,%edi
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	85 ff                	test   %edi,%edi
  800452:	7f ed                	jg     800441 <vprintfmt+0x1ae>
  800454:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800457:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80045a:	85 c9                	test   %ecx,%ecx
  80045c:	b8 00 00 00 00       	mov    $0x0,%eax
  800461:	0f 49 c1             	cmovns %ecx,%eax
  800464:	29 c1                	sub    %eax,%ecx
  800466:	89 75 08             	mov    %esi,0x8(%ebp)
  800469:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80046c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80046f:	89 cb                	mov    %ecx,%ebx
  800471:	eb 16                	jmp    800489 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800473:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800477:	75 31                	jne    8004aa <vprintfmt+0x217>
					putch(ch, putdat);
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	ff 75 0c             	pushl  0xc(%ebp)
  80047f:	50                   	push   %eax
  800480:	ff 55 08             	call   *0x8(%ebp)
  800483:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800486:	83 eb 01             	sub    $0x1,%ebx
  800489:	83 c7 01             	add    $0x1,%edi
  80048c:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800490:	0f be c2             	movsbl %dl,%eax
  800493:	85 c0                	test   %eax,%eax
  800495:	74 59                	je     8004f0 <vprintfmt+0x25d>
  800497:	85 f6                	test   %esi,%esi
  800499:	78 d8                	js     800473 <vprintfmt+0x1e0>
  80049b:	83 ee 01             	sub    $0x1,%esi
  80049e:	79 d3                	jns    800473 <vprintfmt+0x1e0>
  8004a0:	89 df                	mov    %ebx,%edi
  8004a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a8:	eb 37                	jmp    8004e1 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004aa:	0f be d2             	movsbl %dl,%edx
  8004ad:	83 ea 20             	sub    $0x20,%edx
  8004b0:	83 fa 5e             	cmp    $0x5e,%edx
  8004b3:	76 c4                	jbe    800479 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	ff 75 0c             	pushl  0xc(%ebp)
  8004bb:	6a 3f                	push   $0x3f
  8004bd:	ff 55 08             	call   *0x8(%ebp)
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	eb c1                	jmp    800486 <vprintfmt+0x1f3>
  8004c5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004cb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ce:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004d1:	eb b6                	jmp    800489 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	53                   	push   %ebx
  8004d7:	6a 20                	push   $0x20
  8004d9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004db:	83 ef 01             	sub    $0x1,%edi
  8004de:	83 c4 10             	add    $0x10,%esp
  8004e1:	85 ff                	test   %edi,%edi
  8004e3:	7f ee                	jg     8004d3 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004eb:	e9 43 01 00 00       	jmp    800633 <vprintfmt+0x3a0>
  8004f0:	89 df                	mov    %ebx,%edi
  8004f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004f8:	eb e7                	jmp    8004e1 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004fa:	83 f9 01             	cmp    $0x1,%ecx
  8004fd:	7e 3f                	jle    80053e <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8b 50 04             	mov    0x4(%eax),%edx
  800505:	8b 00                	mov    (%eax),%eax
  800507:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8d 40 08             	lea    0x8(%eax),%eax
  800513:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800516:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80051a:	79 5c                	jns    800578 <vprintfmt+0x2e5>
				putch('-', putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	53                   	push   %ebx
  800520:	6a 2d                	push   $0x2d
  800522:	ff d6                	call   *%esi
				num = -(long long) num;
  800524:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800527:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80052a:	f7 da                	neg    %edx
  80052c:	83 d1 00             	adc    $0x0,%ecx
  80052f:	f7 d9                	neg    %ecx
  800531:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800534:	b8 0a 00 00 00       	mov    $0xa,%eax
  800539:	e9 db 00 00 00       	jmp    800619 <vprintfmt+0x386>
	else if (lflag)
  80053e:	85 c9                	test   %ecx,%ecx
  800540:	75 1b                	jne    80055d <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054a:	89 c1                	mov    %eax,%ecx
  80054c:	c1 f9 1f             	sar    $0x1f,%ecx
  80054f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8d 40 04             	lea    0x4(%eax),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	eb b9                	jmp    800516 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800565:	89 c1                	mov    %eax,%ecx
  800567:	c1 f9 1f             	sar    $0x1f,%ecx
  80056a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8d 40 04             	lea    0x4(%eax),%eax
  800573:	89 45 14             	mov    %eax,0x14(%ebp)
  800576:	eb 9e                	jmp    800516 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800578:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80057b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80057e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800583:	e9 91 00 00 00       	jmp    800619 <vprintfmt+0x386>
	if (lflag >= 2)
  800588:	83 f9 01             	cmp    $0x1,%ecx
  80058b:	7e 15                	jle    8005a2 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8b 10                	mov    (%eax),%edx
  800592:	8b 48 04             	mov    0x4(%eax),%ecx
  800595:	8d 40 08             	lea    0x8(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a0:	eb 77                	jmp    800619 <vprintfmt+0x386>
	else if (lflag)
  8005a2:	85 c9                	test   %ecx,%ecx
  8005a4:	75 17                	jne    8005bd <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 10                	mov    (%eax),%edx
  8005ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b0:	8d 40 04             	lea    0x4(%eax),%eax
  8005b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005bb:	eb 5c                	jmp    800619 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8b 10                	mov    (%eax),%edx
  8005c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d2:	eb 45                	jmp    800619 <vprintfmt+0x386>
			putch('X', putdat);
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	53                   	push   %ebx
  8005d8:	6a 58                	push   $0x58
  8005da:	ff d6                	call   *%esi
			putch('X', putdat);
  8005dc:	83 c4 08             	add    $0x8,%esp
  8005df:	53                   	push   %ebx
  8005e0:	6a 58                	push   $0x58
  8005e2:	ff d6                	call   *%esi
			putch('X', putdat);
  8005e4:	83 c4 08             	add    $0x8,%esp
  8005e7:	53                   	push   %ebx
  8005e8:	6a 58                	push   $0x58
  8005ea:	ff d6                	call   *%esi
			break;
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	eb 42                	jmp    800633 <vprintfmt+0x3a0>
			putch('0', putdat);
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	53                   	push   %ebx
  8005f5:	6a 30                	push   $0x30
  8005f7:	ff d6                	call   *%esi
			putch('x', putdat);
  8005f9:	83 c4 08             	add    $0x8,%esp
  8005fc:	53                   	push   %ebx
  8005fd:	6a 78                	push   $0x78
  8005ff:	ff d6                	call   *%esi
			num = (unsigned long long)
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8b 10                	mov    (%eax),%edx
  800606:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80060b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80060e:	8d 40 04             	lea    0x4(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800614:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800620:	57                   	push   %edi
  800621:	ff 75 e0             	pushl  -0x20(%ebp)
  800624:	50                   	push   %eax
  800625:	51                   	push   %ecx
  800626:	52                   	push   %edx
  800627:	89 da                	mov    %ebx,%edx
  800629:	89 f0                	mov    %esi,%eax
  80062b:	e8 7a fb ff ff       	call   8001aa <printnum>
			break;
  800630:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800633:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800636:	83 c7 01             	add    $0x1,%edi
  800639:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80063d:	83 f8 25             	cmp    $0x25,%eax
  800640:	0f 84 64 fc ff ff    	je     8002aa <vprintfmt+0x17>
			if (ch == '\0')
  800646:	85 c0                	test   %eax,%eax
  800648:	0f 84 8b 00 00 00    	je     8006d9 <vprintfmt+0x446>
			putch(ch, putdat);
  80064e:	83 ec 08             	sub    $0x8,%esp
  800651:	53                   	push   %ebx
  800652:	50                   	push   %eax
  800653:	ff d6                	call   *%esi
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	eb dc                	jmp    800636 <vprintfmt+0x3a3>
	if (lflag >= 2)
  80065a:	83 f9 01             	cmp    $0x1,%ecx
  80065d:	7e 15                	jle    800674 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8b 10                	mov    (%eax),%edx
  800664:	8b 48 04             	mov    0x4(%eax),%ecx
  800667:	8d 40 08             	lea    0x8(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80066d:	b8 10 00 00 00       	mov    $0x10,%eax
  800672:	eb a5                	jmp    800619 <vprintfmt+0x386>
	else if (lflag)
  800674:	85 c9                	test   %ecx,%ecx
  800676:	75 17                	jne    80068f <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8b 10                	mov    (%eax),%edx
  80067d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800682:	8d 40 04             	lea    0x4(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800688:	b8 10 00 00 00       	mov    $0x10,%eax
  80068d:	eb 8a                	jmp    800619 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8b 10                	mov    (%eax),%edx
  800694:	b9 00 00 00 00       	mov    $0x0,%ecx
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069f:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a4:	e9 70 ff ff ff       	jmp    800619 <vprintfmt+0x386>
			putch(ch, putdat);
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	53                   	push   %ebx
  8006ad:	6a 25                	push   $0x25
  8006af:	ff d6                	call   *%esi
			break;
  8006b1:	83 c4 10             	add    $0x10,%esp
  8006b4:	e9 7a ff ff ff       	jmp    800633 <vprintfmt+0x3a0>
			putch('%', putdat);
  8006b9:	83 ec 08             	sub    $0x8,%esp
  8006bc:	53                   	push   %ebx
  8006bd:	6a 25                	push   $0x25
  8006bf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	89 f8                	mov    %edi,%eax
  8006c6:	eb 03                	jmp    8006cb <vprintfmt+0x438>
  8006c8:	83 e8 01             	sub    $0x1,%eax
  8006cb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006cf:	75 f7                	jne    8006c8 <vprintfmt+0x435>
  8006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006d4:	e9 5a ff ff ff       	jmp    800633 <vprintfmt+0x3a0>
}
  8006d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006dc:	5b                   	pop    %ebx
  8006dd:	5e                   	pop    %esi
  8006de:	5f                   	pop    %edi
  8006df:	5d                   	pop    %ebp
  8006e0:	c3                   	ret    

008006e1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006f0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006f4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006fe:	85 c0                	test   %eax,%eax
  800700:	74 26                	je     800728 <vsnprintf+0x47>
  800702:	85 d2                	test   %edx,%edx
  800704:	7e 22                	jle    800728 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800706:	ff 75 14             	pushl  0x14(%ebp)
  800709:	ff 75 10             	pushl  0x10(%ebp)
  80070c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80070f:	50                   	push   %eax
  800710:	68 59 02 80 00       	push   $0x800259
  800715:	e8 79 fb ff ff       	call   800293 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80071a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800723:	83 c4 10             	add    $0x10,%esp
}
  800726:	c9                   	leave  
  800727:	c3                   	ret    
		return -E_INVAL;
  800728:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80072d:	eb f7                	jmp    800726 <vsnprintf+0x45>

0080072f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800735:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800738:	50                   	push   %eax
  800739:	ff 75 10             	pushl  0x10(%ebp)
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	ff 75 08             	pushl  0x8(%ebp)
  800742:	e8 9a ff ff ff       	call   8006e1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800747:	c9                   	leave  
  800748:	c3                   	ret    

00800749 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800749:	55                   	push   %ebp
  80074a:	89 e5                	mov    %esp,%ebp
  80074c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80074f:	b8 00 00 00 00       	mov    $0x0,%eax
  800754:	eb 03                	jmp    800759 <strlen+0x10>
		n++;
  800756:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800759:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80075d:	75 f7                	jne    800756 <strlen+0xd>
	return n;
}
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800767:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80076a:	b8 00 00 00 00       	mov    $0x0,%eax
  80076f:	eb 03                	jmp    800774 <strnlen+0x13>
		n++;
  800771:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800774:	39 d0                	cmp    %edx,%eax
  800776:	74 06                	je     80077e <strnlen+0x1d>
  800778:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80077c:	75 f3                	jne    800771 <strnlen+0x10>
	return n;
}
  80077e:	5d                   	pop    %ebp
  80077f:	c3                   	ret    

00800780 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	53                   	push   %ebx
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80078a:	89 c2                	mov    %eax,%edx
  80078c:	83 c1 01             	add    $0x1,%ecx
  80078f:	83 c2 01             	add    $0x1,%edx
  800792:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800796:	88 5a ff             	mov    %bl,-0x1(%edx)
  800799:	84 db                	test   %bl,%bl
  80079b:	75 ef                	jne    80078c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80079d:	5b                   	pop    %ebx
  80079e:	5d                   	pop    %ebp
  80079f:	c3                   	ret    

008007a0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	53                   	push   %ebx
  8007a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007a7:	53                   	push   %ebx
  8007a8:	e8 9c ff ff ff       	call   800749 <strlen>
  8007ad:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	01 d8                	add    %ebx,%eax
  8007b5:	50                   	push   %eax
  8007b6:	e8 c5 ff ff ff       	call   800780 <strcpy>
	return dst;
}
  8007bb:	89 d8                	mov    %ebx,%eax
  8007bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	56                   	push   %esi
  8007c6:	53                   	push   %ebx
  8007c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007cd:	89 f3                	mov    %esi,%ebx
  8007cf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007d2:	89 f2                	mov    %esi,%edx
  8007d4:	eb 0f                	jmp    8007e5 <strncpy+0x23>
		*dst++ = *src;
  8007d6:	83 c2 01             	add    $0x1,%edx
  8007d9:	0f b6 01             	movzbl (%ecx),%eax
  8007dc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007df:	80 39 01             	cmpb   $0x1,(%ecx)
  8007e2:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007e5:	39 da                	cmp    %ebx,%edx
  8007e7:	75 ed                	jne    8007d6 <strncpy+0x14>
	}
	return ret;
}
  8007e9:	89 f0                	mov    %esi,%eax
  8007eb:	5b                   	pop    %ebx
  8007ec:	5e                   	pop    %esi
  8007ed:	5d                   	pop    %ebp
  8007ee:	c3                   	ret    

008007ef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	56                   	push   %esi
  8007f3:	53                   	push   %ebx
  8007f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007fd:	89 f0                	mov    %esi,%eax
  8007ff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800803:	85 c9                	test   %ecx,%ecx
  800805:	75 0b                	jne    800812 <strlcpy+0x23>
  800807:	eb 17                	jmp    800820 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800809:	83 c2 01             	add    $0x1,%edx
  80080c:	83 c0 01             	add    $0x1,%eax
  80080f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800812:	39 d8                	cmp    %ebx,%eax
  800814:	74 07                	je     80081d <strlcpy+0x2e>
  800816:	0f b6 0a             	movzbl (%edx),%ecx
  800819:	84 c9                	test   %cl,%cl
  80081b:	75 ec                	jne    800809 <strlcpy+0x1a>
		*dst = '\0';
  80081d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800820:	29 f0                	sub    %esi,%eax
}
  800822:	5b                   	pop    %ebx
  800823:	5e                   	pop    %esi
  800824:	5d                   	pop    %ebp
  800825:	c3                   	ret    

00800826 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
  800829:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80082c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80082f:	eb 06                	jmp    800837 <strcmp+0x11>
		p++, q++;
  800831:	83 c1 01             	add    $0x1,%ecx
  800834:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800837:	0f b6 01             	movzbl (%ecx),%eax
  80083a:	84 c0                	test   %al,%al
  80083c:	74 04                	je     800842 <strcmp+0x1c>
  80083e:	3a 02                	cmp    (%edx),%al
  800840:	74 ef                	je     800831 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800842:	0f b6 c0             	movzbl %al,%eax
  800845:	0f b6 12             	movzbl (%edx),%edx
  800848:	29 d0                	sub    %edx,%eax
}
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	53                   	push   %ebx
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 55 0c             	mov    0xc(%ebp),%edx
  800856:	89 c3                	mov    %eax,%ebx
  800858:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80085b:	eb 06                	jmp    800863 <strncmp+0x17>
		n--, p++, q++;
  80085d:	83 c0 01             	add    $0x1,%eax
  800860:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800863:	39 d8                	cmp    %ebx,%eax
  800865:	74 16                	je     80087d <strncmp+0x31>
  800867:	0f b6 08             	movzbl (%eax),%ecx
  80086a:	84 c9                	test   %cl,%cl
  80086c:	74 04                	je     800872 <strncmp+0x26>
  80086e:	3a 0a                	cmp    (%edx),%cl
  800870:	74 eb                	je     80085d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800872:	0f b6 00             	movzbl (%eax),%eax
  800875:	0f b6 12             	movzbl (%edx),%edx
  800878:	29 d0                	sub    %edx,%eax
}
  80087a:	5b                   	pop    %ebx
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    
		return 0;
  80087d:	b8 00 00 00 00       	mov    $0x0,%eax
  800882:	eb f6                	jmp    80087a <strncmp+0x2e>

00800884 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80088e:	0f b6 10             	movzbl (%eax),%edx
  800891:	84 d2                	test   %dl,%dl
  800893:	74 09                	je     80089e <strchr+0x1a>
		if (*s == c)
  800895:	38 ca                	cmp    %cl,%dl
  800897:	74 0a                	je     8008a3 <strchr+0x1f>
	for (; *s; s++)
  800899:	83 c0 01             	add    $0x1,%eax
  80089c:	eb f0                	jmp    80088e <strchr+0xa>
			return (char *) s;
	return 0;
  80089e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008a3:	5d                   	pop    %ebp
  8008a4:	c3                   	ret    

008008a5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008af:	eb 03                	jmp    8008b4 <strfind+0xf>
  8008b1:	83 c0 01             	add    $0x1,%eax
  8008b4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008b7:	38 ca                	cmp    %cl,%dl
  8008b9:	74 04                	je     8008bf <strfind+0x1a>
  8008bb:	84 d2                	test   %dl,%dl
  8008bd:	75 f2                	jne    8008b1 <strfind+0xc>
			break;
	return (char *) s;
}
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	57                   	push   %edi
  8008c5:	56                   	push   %esi
  8008c6:	53                   	push   %ebx
  8008c7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008cd:	85 c9                	test   %ecx,%ecx
  8008cf:	74 13                	je     8008e4 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008d1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008d7:	75 05                	jne    8008de <memset+0x1d>
  8008d9:	f6 c1 03             	test   $0x3,%cl
  8008dc:	74 0d                	je     8008eb <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e1:	fc                   	cld    
  8008e2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008e4:	89 f8                	mov    %edi,%eax
  8008e6:	5b                   	pop    %ebx
  8008e7:	5e                   	pop    %esi
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    
		c &= 0xFF;
  8008eb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ef:	89 d3                	mov    %edx,%ebx
  8008f1:	c1 e3 08             	shl    $0x8,%ebx
  8008f4:	89 d0                	mov    %edx,%eax
  8008f6:	c1 e0 18             	shl    $0x18,%eax
  8008f9:	89 d6                	mov    %edx,%esi
  8008fb:	c1 e6 10             	shl    $0x10,%esi
  8008fe:	09 f0                	or     %esi,%eax
  800900:	09 c2                	or     %eax,%edx
  800902:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800904:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800907:	89 d0                	mov    %edx,%eax
  800909:	fc                   	cld    
  80090a:	f3 ab                	rep stos %eax,%es:(%edi)
  80090c:	eb d6                	jmp    8008e4 <memset+0x23>

0080090e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	57                   	push   %edi
  800912:	56                   	push   %esi
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8b 75 0c             	mov    0xc(%ebp),%esi
  800919:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80091c:	39 c6                	cmp    %eax,%esi
  80091e:	73 35                	jae    800955 <memmove+0x47>
  800920:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800923:	39 c2                	cmp    %eax,%edx
  800925:	76 2e                	jbe    800955 <memmove+0x47>
		s += n;
		d += n;
  800927:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80092a:	89 d6                	mov    %edx,%esi
  80092c:	09 fe                	or     %edi,%esi
  80092e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800934:	74 0c                	je     800942 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800936:	83 ef 01             	sub    $0x1,%edi
  800939:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80093c:	fd                   	std    
  80093d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80093f:	fc                   	cld    
  800940:	eb 21                	jmp    800963 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800942:	f6 c1 03             	test   $0x3,%cl
  800945:	75 ef                	jne    800936 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800947:	83 ef 04             	sub    $0x4,%edi
  80094a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80094d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800950:	fd                   	std    
  800951:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800953:	eb ea                	jmp    80093f <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800955:	89 f2                	mov    %esi,%edx
  800957:	09 c2                	or     %eax,%edx
  800959:	f6 c2 03             	test   $0x3,%dl
  80095c:	74 09                	je     800967 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80095e:	89 c7                	mov    %eax,%edi
  800960:	fc                   	cld    
  800961:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800963:	5e                   	pop    %esi
  800964:	5f                   	pop    %edi
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800967:	f6 c1 03             	test   $0x3,%cl
  80096a:	75 f2                	jne    80095e <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80096c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80096f:	89 c7                	mov    %eax,%edi
  800971:	fc                   	cld    
  800972:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800974:	eb ed                	jmp    800963 <memmove+0x55>

00800976 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800979:	ff 75 10             	pushl  0x10(%ebp)
  80097c:	ff 75 0c             	pushl  0xc(%ebp)
  80097f:	ff 75 08             	pushl  0x8(%ebp)
  800982:	e8 87 ff ff ff       	call   80090e <memmove>
}
  800987:	c9                   	leave  
  800988:	c3                   	ret    

00800989 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	56                   	push   %esi
  80098d:	53                   	push   %ebx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 55 0c             	mov    0xc(%ebp),%edx
  800994:	89 c6                	mov    %eax,%esi
  800996:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800999:	39 f0                	cmp    %esi,%eax
  80099b:	74 1c                	je     8009b9 <memcmp+0x30>
		if (*s1 != *s2)
  80099d:	0f b6 08             	movzbl (%eax),%ecx
  8009a0:	0f b6 1a             	movzbl (%edx),%ebx
  8009a3:	38 d9                	cmp    %bl,%cl
  8009a5:	75 08                	jne    8009af <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009a7:	83 c0 01             	add    $0x1,%eax
  8009aa:	83 c2 01             	add    $0x1,%edx
  8009ad:	eb ea                	jmp    800999 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009af:	0f b6 c1             	movzbl %cl,%eax
  8009b2:	0f b6 db             	movzbl %bl,%ebx
  8009b5:	29 d8                	sub    %ebx,%eax
  8009b7:	eb 05                	jmp    8009be <memcmp+0x35>
	}

	return 0;
  8009b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009be:	5b                   	pop    %ebx
  8009bf:	5e                   	pop    %esi
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009cb:	89 c2                	mov    %eax,%edx
  8009cd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009d0:	39 d0                	cmp    %edx,%eax
  8009d2:	73 09                	jae    8009dd <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009d4:	38 08                	cmp    %cl,(%eax)
  8009d6:	74 05                	je     8009dd <memfind+0x1b>
	for (; s < ends; s++)
  8009d8:	83 c0 01             	add    $0x1,%eax
  8009db:	eb f3                	jmp    8009d0 <memfind+0xe>
			break;
	return (void *) s;
}
  8009dd:	5d                   	pop    %ebp
  8009de:	c3                   	ret    

008009df <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	57                   	push   %edi
  8009e3:	56                   	push   %esi
  8009e4:	53                   	push   %ebx
  8009e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009eb:	eb 03                	jmp    8009f0 <strtol+0x11>
		s++;
  8009ed:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009f0:	0f b6 01             	movzbl (%ecx),%eax
  8009f3:	3c 20                	cmp    $0x20,%al
  8009f5:	74 f6                	je     8009ed <strtol+0xe>
  8009f7:	3c 09                	cmp    $0x9,%al
  8009f9:	74 f2                	je     8009ed <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009fb:	3c 2b                	cmp    $0x2b,%al
  8009fd:	74 2e                	je     800a2d <strtol+0x4e>
	int neg = 0;
  8009ff:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a04:	3c 2d                	cmp    $0x2d,%al
  800a06:	74 2f                	je     800a37 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a08:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a0e:	75 05                	jne    800a15 <strtol+0x36>
  800a10:	80 39 30             	cmpb   $0x30,(%ecx)
  800a13:	74 2c                	je     800a41 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a15:	85 db                	test   %ebx,%ebx
  800a17:	75 0a                	jne    800a23 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a19:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a1e:	80 39 30             	cmpb   $0x30,(%ecx)
  800a21:	74 28                	je     800a4b <strtol+0x6c>
		base = 10;
  800a23:	b8 00 00 00 00       	mov    $0x0,%eax
  800a28:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a2b:	eb 50                	jmp    800a7d <strtol+0x9e>
		s++;
  800a2d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a30:	bf 00 00 00 00       	mov    $0x0,%edi
  800a35:	eb d1                	jmp    800a08 <strtol+0x29>
		s++, neg = 1;
  800a37:	83 c1 01             	add    $0x1,%ecx
  800a3a:	bf 01 00 00 00       	mov    $0x1,%edi
  800a3f:	eb c7                	jmp    800a08 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a41:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a45:	74 0e                	je     800a55 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a47:	85 db                	test   %ebx,%ebx
  800a49:	75 d8                	jne    800a23 <strtol+0x44>
		s++, base = 8;
  800a4b:	83 c1 01             	add    $0x1,%ecx
  800a4e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a53:	eb ce                	jmp    800a23 <strtol+0x44>
		s += 2, base = 16;
  800a55:	83 c1 02             	add    $0x2,%ecx
  800a58:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a5d:	eb c4                	jmp    800a23 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a5f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a62:	89 f3                	mov    %esi,%ebx
  800a64:	80 fb 19             	cmp    $0x19,%bl
  800a67:	77 29                	ja     800a92 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a69:	0f be d2             	movsbl %dl,%edx
  800a6c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a6f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a72:	7d 30                	jge    800aa4 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a74:	83 c1 01             	add    $0x1,%ecx
  800a77:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a7b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a7d:	0f b6 11             	movzbl (%ecx),%edx
  800a80:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a83:	89 f3                	mov    %esi,%ebx
  800a85:	80 fb 09             	cmp    $0x9,%bl
  800a88:	77 d5                	ja     800a5f <strtol+0x80>
			dig = *s - '0';
  800a8a:	0f be d2             	movsbl %dl,%edx
  800a8d:	83 ea 30             	sub    $0x30,%edx
  800a90:	eb dd                	jmp    800a6f <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a92:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a95:	89 f3                	mov    %esi,%ebx
  800a97:	80 fb 19             	cmp    $0x19,%bl
  800a9a:	77 08                	ja     800aa4 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a9c:	0f be d2             	movsbl %dl,%edx
  800a9f:	83 ea 37             	sub    $0x37,%edx
  800aa2:	eb cb                	jmp    800a6f <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aa4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa8:	74 05                	je     800aaf <strtol+0xd0>
		*endptr = (char *) s;
  800aaa:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aad:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800aaf:	89 c2                	mov    %eax,%edx
  800ab1:	f7 da                	neg    %edx
  800ab3:	85 ff                	test   %edi,%edi
  800ab5:	0f 45 c2             	cmovne %edx,%eax
}
  800ab8:	5b                   	pop    %ebx
  800ab9:	5e                   	pop    %esi
  800aba:	5f                   	pop    %edi
  800abb:	5d                   	pop    %ebp
  800abc:	c3                   	ret    

00800abd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	57                   	push   %edi
  800ac1:	56                   	push   %esi
  800ac2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac8:	8b 55 08             	mov    0x8(%ebp),%edx
  800acb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ace:	89 c3                	mov    %eax,%ebx
  800ad0:	89 c7                	mov    %eax,%edi
  800ad2:	89 c6                	mov    %eax,%esi
  800ad4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ad6:	5b                   	pop    %ebx
  800ad7:	5e                   	pop    %esi
  800ad8:	5f                   	pop    %edi
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <sys_cgetc>:

int
sys_cgetc(void)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	57                   	push   %edi
  800adf:	56                   	push   %esi
  800ae0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ae1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae6:	b8 01 00 00 00       	mov    $0x1,%eax
  800aeb:	89 d1                	mov    %edx,%ecx
  800aed:	89 d3                	mov    %edx,%ebx
  800aef:	89 d7                	mov    %edx,%edi
  800af1:	89 d6                	mov    %edx,%esi
  800af3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5f                   	pop    %edi
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	57                   	push   %edi
  800afe:	56                   	push   %esi
  800aff:	53                   	push   %ebx
  800b00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b03:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b08:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b10:	89 cb                	mov    %ecx,%ebx
  800b12:	89 cf                	mov    %ecx,%edi
  800b14:	89 ce                	mov    %ecx,%esi
  800b16:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b18:	85 c0                	test   %eax,%eax
  800b1a:	7f 08                	jg     800b24 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b1f:	5b                   	pop    %ebx
  800b20:	5e                   	pop    %esi
  800b21:	5f                   	pop    %edi
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b24:	83 ec 0c             	sub    $0xc,%esp
  800b27:	50                   	push   %eax
  800b28:	6a 03                	push   $0x3
  800b2a:	68 9f 20 80 00       	push   $0x80209f
  800b2f:	6a 23                	push   $0x23
  800b31:	68 bc 20 80 00       	push   $0x8020bc
  800b36:	e8 51 0f 00 00       	call   801a8c <_panic>

00800b3b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	57                   	push   %edi
  800b3f:	56                   	push   %esi
  800b40:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b41:	ba 00 00 00 00       	mov    $0x0,%edx
  800b46:	b8 02 00 00 00       	mov    $0x2,%eax
  800b4b:	89 d1                	mov    %edx,%ecx
  800b4d:	89 d3                	mov    %edx,%ebx
  800b4f:	89 d7                	mov    %edx,%edi
  800b51:	89 d6                	mov    %edx,%esi
  800b53:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b55:	5b                   	pop    %ebx
  800b56:	5e                   	pop    %esi
  800b57:	5f                   	pop    %edi
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <sys_yield>:

void
sys_yield(void)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	57                   	push   %edi
  800b5e:	56                   	push   %esi
  800b5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b60:	ba 00 00 00 00       	mov    $0x0,%edx
  800b65:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b6a:	89 d1                	mov    %edx,%ecx
  800b6c:	89 d3                	mov    %edx,%ebx
  800b6e:	89 d7                	mov    %edx,%edi
  800b70:	89 d6                	mov    %edx,%esi
  800b72:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b74:	5b                   	pop    %ebx
  800b75:	5e                   	pop    %esi
  800b76:	5f                   	pop    %edi
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	57                   	push   %edi
  800b7d:	56                   	push   %esi
  800b7e:	53                   	push   %ebx
  800b7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b82:	be 00 00 00 00       	mov    $0x0,%esi
  800b87:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b8d:	b8 04 00 00 00       	mov    $0x4,%eax
  800b92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b95:	89 f7                	mov    %esi,%edi
  800b97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b99:	85 c0                	test   %eax,%eax
  800b9b:	7f 08                	jg     800ba5 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba5:	83 ec 0c             	sub    $0xc,%esp
  800ba8:	50                   	push   %eax
  800ba9:	6a 04                	push   $0x4
  800bab:	68 9f 20 80 00       	push   $0x80209f
  800bb0:	6a 23                	push   $0x23
  800bb2:	68 bc 20 80 00       	push   $0x8020bc
  800bb7:	e8 d0 0e 00 00       	call   801a8c <_panic>

00800bbc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	57                   	push   %edi
  800bc0:	56                   	push   %esi
  800bc1:	53                   	push   %ebx
  800bc2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bcb:	b8 05 00 00 00       	mov    $0x5,%eax
  800bd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bd3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bd6:	8b 75 18             	mov    0x18(%ebp),%esi
  800bd9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bdb:	85 c0                	test   %eax,%eax
  800bdd:	7f 08                	jg     800be7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5f                   	pop    %edi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	50                   	push   %eax
  800beb:	6a 05                	push   $0x5
  800bed:	68 9f 20 80 00       	push   $0x80209f
  800bf2:	6a 23                	push   $0x23
  800bf4:	68 bc 20 80 00       	push   $0x8020bc
  800bf9:	e8 8e 0e 00 00       	call   801a8c <_panic>

00800bfe <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c12:	b8 06 00 00 00       	mov    $0x6,%eax
  800c17:	89 df                	mov    %ebx,%edi
  800c19:	89 de                	mov    %ebx,%esi
  800c1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1d:	85 c0                	test   %eax,%eax
  800c1f:	7f 08                	jg     800c29 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c24:	5b                   	pop    %ebx
  800c25:	5e                   	pop    %esi
  800c26:	5f                   	pop    %edi
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c29:	83 ec 0c             	sub    $0xc,%esp
  800c2c:	50                   	push   %eax
  800c2d:	6a 06                	push   $0x6
  800c2f:	68 9f 20 80 00       	push   $0x80209f
  800c34:	6a 23                	push   $0x23
  800c36:	68 bc 20 80 00       	push   $0x8020bc
  800c3b:	e8 4c 0e 00 00       	call   801a8c <_panic>

00800c40 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	57                   	push   %edi
  800c44:	56                   	push   %esi
  800c45:	53                   	push   %ebx
  800c46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c54:	b8 08 00 00 00       	mov    $0x8,%eax
  800c59:	89 df                	mov    %ebx,%edi
  800c5b:	89 de                	mov    %ebx,%esi
  800c5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5f:	85 c0                	test   %eax,%eax
  800c61:	7f 08                	jg     800c6b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c66:	5b                   	pop    %ebx
  800c67:	5e                   	pop    %esi
  800c68:	5f                   	pop    %edi
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6b:	83 ec 0c             	sub    $0xc,%esp
  800c6e:	50                   	push   %eax
  800c6f:	6a 08                	push   $0x8
  800c71:	68 9f 20 80 00       	push   $0x80209f
  800c76:	6a 23                	push   $0x23
  800c78:	68 bc 20 80 00       	push   $0x8020bc
  800c7d:	e8 0a 0e 00 00       	call   801a8c <_panic>

00800c82 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
  800c88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c90:	8b 55 08             	mov    0x8(%ebp),%edx
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	b8 09 00 00 00       	mov    $0x9,%eax
  800c9b:	89 df                	mov    %ebx,%edi
  800c9d:	89 de                	mov    %ebx,%esi
  800c9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca1:	85 c0                	test   %eax,%eax
  800ca3:	7f 08                	jg     800cad <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cad:	83 ec 0c             	sub    $0xc,%esp
  800cb0:	50                   	push   %eax
  800cb1:	6a 09                	push   $0x9
  800cb3:	68 9f 20 80 00       	push   $0x80209f
  800cb8:	6a 23                	push   $0x23
  800cba:	68 bc 20 80 00       	push   $0x8020bc
  800cbf:	e8 c8 0d 00 00       	call   801a8c <_panic>

00800cc4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
  800cca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cdd:	89 df                	mov    %ebx,%edi
  800cdf:	89 de                	mov    %ebx,%esi
  800ce1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	7f 08                	jg     800cef <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cea:	5b                   	pop    %ebx
  800ceb:	5e                   	pop    %esi
  800cec:	5f                   	pop    %edi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cef:	83 ec 0c             	sub    $0xc,%esp
  800cf2:	50                   	push   %eax
  800cf3:	6a 0a                	push   $0xa
  800cf5:	68 9f 20 80 00       	push   $0x80209f
  800cfa:	6a 23                	push   $0x23
  800cfc:	68 bc 20 80 00       	push   $0x8020bc
  800d01:	e8 86 0d 00 00       	call   801a8c <_panic>

00800d06 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d12:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d17:	be 00 00 00 00       	mov    $0x0,%esi
  800d1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d22:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
  800d2f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d3f:	89 cb                	mov    %ecx,%ebx
  800d41:	89 cf                	mov    %ecx,%edi
  800d43:	89 ce                	mov    %ecx,%esi
  800d45:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d47:	85 c0                	test   %eax,%eax
  800d49:	7f 08                	jg     800d53 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d53:	83 ec 0c             	sub    $0xc,%esp
  800d56:	50                   	push   %eax
  800d57:	6a 0d                	push   $0xd
  800d59:	68 9f 20 80 00       	push   $0x80209f
  800d5e:	6a 23                	push   $0x23
  800d60:	68 bc 20 80 00       	push   $0x8020bc
  800d65:	e8 22 0d 00 00       	call   801a8c <_panic>

00800d6a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  800d70:	68 ca 20 80 00       	push   $0x8020ca
  800d75:	6a 1a                	push   $0x1a
  800d77:	68 e3 20 80 00       	push   $0x8020e3
  800d7c:	e8 0b 0d 00 00       	call   801a8c <_panic>

00800d81 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  800d87:	68 ed 20 80 00       	push   $0x8020ed
  800d8c:	6a 2a                	push   $0x2a
  800d8e:	68 e3 20 80 00       	push   $0x8020e3
  800d93:	e8 f4 0c 00 00       	call   801a8c <_panic>

00800d98 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800d9e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800da3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800da6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800dac:	8b 52 50             	mov    0x50(%edx),%edx
  800daf:	39 ca                	cmp    %ecx,%edx
  800db1:	74 11                	je     800dc4 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  800db3:	83 c0 01             	add    $0x1,%eax
  800db6:	3d 00 04 00 00       	cmp    $0x400,%eax
  800dbb:	75 e6                	jne    800da3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc2:	eb 0b                	jmp    800dcf <ipc_find_env+0x37>
			return envs[i].env_id;
  800dc4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800dc7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800dcc:	8b 40 48             	mov    0x48(%eax),%eax
}
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	05 00 00 00 30       	add    $0x30000000,%eax
  800ddc:	c1 e8 0c             	shr    $0xc,%eax
}
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800dec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800df1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dfe:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e03:	89 c2                	mov    %eax,%edx
  800e05:	c1 ea 16             	shr    $0x16,%edx
  800e08:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e0f:	f6 c2 01             	test   $0x1,%dl
  800e12:	74 2a                	je     800e3e <fd_alloc+0x46>
  800e14:	89 c2                	mov    %eax,%edx
  800e16:	c1 ea 0c             	shr    $0xc,%edx
  800e19:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e20:	f6 c2 01             	test   $0x1,%dl
  800e23:	74 19                	je     800e3e <fd_alloc+0x46>
  800e25:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e2a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e2f:	75 d2                	jne    800e03 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e31:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e37:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e3c:	eb 07                	jmp    800e45 <fd_alloc+0x4d>
			*fd_store = fd;
  800e3e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e4d:	83 f8 1f             	cmp    $0x1f,%eax
  800e50:	77 36                	ja     800e88 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e52:	c1 e0 0c             	shl    $0xc,%eax
  800e55:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e5a:	89 c2                	mov    %eax,%edx
  800e5c:	c1 ea 16             	shr    $0x16,%edx
  800e5f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e66:	f6 c2 01             	test   $0x1,%dl
  800e69:	74 24                	je     800e8f <fd_lookup+0x48>
  800e6b:	89 c2                	mov    %eax,%edx
  800e6d:	c1 ea 0c             	shr    $0xc,%edx
  800e70:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e77:	f6 c2 01             	test   $0x1,%dl
  800e7a:	74 1a                	je     800e96 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7f:	89 02                	mov    %eax,(%edx)
	return 0;
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    
		return -E_INVAL;
  800e88:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e8d:	eb f7                	jmp    800e86 <fd_lookup+0x3f>
		return -E_INVAL;
  800e8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e94:	eb f0                	jmp    800e86 <fd_lookup+0x3f>
  800e96:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e9b:	eb e9                	jmp    800e86 <fd_lookup+0x3f>

00800e9d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea6:	ba 84 21 80 00       	mov    $0x802184,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800eab:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800eb0:	39 08                	cmp    %ecx,(%eax)
  800eb2:	74 33                	je     800ee7 <dev_lookup+0x4a>
  800eb4:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800eb7:	8b 02                	mov    (%edx),%eax
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	75 f3                	jne    800eb0 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ebd:	a1 04 40 80 00       	mov    0x804004,%eax
  800ec2:	8b 40 48             	mov    0x48(%eax),%eax
  800ec5:	83 ec 04             	sub    $0x4,%esp
  800ec8:	51                   	push   %ecx
  800ec9:	50                   	push   %eax
  800eca:	68 08 21 80 00       	push   $0x802108
  800ecf:	e8 c2 f2 ff ff       	call   800196 <cprintf>
	*dev = 0;
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800edd:	83 c4 10             	add    $0x10,%esp
  800ee0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    
			*dev = devtab[i];
  800ee7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eea:	89 01                	mov    %eax,(%ecx)
			return 0;
  800eec:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef1:	eb f2                	jmp    800ee5 <dev_lookup+0x48>

00800ef3 <fd_close>:
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	57                   	push   %edi
  800ef7:	56                   	push   %esi
  800ef8:	53                   	push   %ebx
  800ef9:	83 ec 1c             	sub    $0x1c,%esp
  800efc:	8b 75 08             	mov    0x8(%ebp),%esi
  800eff:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f02:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f05:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f06:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f0c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f0f:	50                   	push   %eax
  800f10:	e8 32 ff ff ff       	call   800e47 <fd_lookup>
  800f15:	89 c3                	mov    %eax,%ebx
  800f17:	83 c4 08             	add    $0x8,%esp
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	78 05                	js     800f23 <fd_close+0x30>
	    || fd != fd2)
  800f1e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f21:	74 16                	je     800f39 <fd_close+0x46>
		return (must_exist ? r : 0);
  800f23:	89 f8                	mov    %edi,%eax
  800f25:	84 c0                	test   %al,%al
  800f27:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2c:	0f 44 d8             	cmove  %eax,%ebx
}
  800f2f:	89 d8                	mov    %ebx,%eax
  800f31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5f                   	pop    %edi
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f3f:	50                   	push   %eax
  800f40:	ff 36                	pushl  (%esi)
  800f42:	e8 56 ff ff ff       	call   800e9d <dev_lookup>
  800f47:	89 c3                	mov    %eax,%ebx
  800f49:	83 c4 10             	add    $0x10,%esp
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	78 15                	js     800f65 <fd_close+0x72>
		if (dev->dev_close)
  800f50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f53:	8b 40 10             	mov    0x10(%eax),%eax
  800f56:	85 c0                	test   %eax,%eax
  800f58:	74 1b                	je     800f75 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f5a:	83 ec 0c             	sub    $0xc,%esp
  800f5d:	56                   	push   %esi
  800f5e:	ff d0                	call   *%eax
  800f60:	89 c3                	mov    %eax,%ebx
  800f62:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	56                   	push   %esi
  800f69:	6a 00                	push   $0x0
  800f6b:	e8 8e fc ff ff       	call   800bfe <sys_page_unmap>
	return r;
  800f70:	83 c4 10             	add    $0x10,%esp
  800f73:	eb ba                	jmp    800f2f <fd_close+0x3c>
			r = 0;
  800f75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7a:	eb e9                	jmp    800f65 <fd_close+0x72>

00800f7c <close>:

int
close(int fdnum)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f85:	50                   	push   %eax
  800f86:	ff 75 08             	pushl  0x8(%ebp)
  800f89:	e8 b9 fe ff ff       	call   800e47 <fd_lookup>
  800f8e:	83 c4 08             	add    $0x8,%esp
  800f91:	85 c0                	test   %eax,%eax
  800f93:	78 10                	js     800fa5 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f95:	83 ec 08             	sub    $0x8,%esp
  800f98:	6a 01                	push   $0x1
  800f9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9d:	e8 51 ff ff ff       	call   800ef3 <fd_close>
  800fa2:	83 c4 10             	add    $0x10,%esp
}
  800fa5:	c9                   	leave  
  800fa6:	c3                   	ret    

00800fa7 <close_all>:

void
close_all(void)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	53                   	push   %ebx
  800fab:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fae:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	53                   	push   %ebx
  800fb7:	e8 c0 ff ff ff       	call   800f7c <close>
	for (i = 0; i < MAXFD; i++)
  800fbc:	83 c3 01             	add    $0x1,%ebx
  800fbf:	83 c4 10             	add    $0x10,%esp
  800fc2:	83 fb 20             	cmp    $0x20,%ebx
  800fc5:	75 ec                	jne    800fb3 <close_all+0xc>
}
  800fc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	57                   	push   %edi
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
  800fd2:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fd5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fd8:	50                   	push   %eax
  800fd9:	ff 75 08             	pushl  0x8(%ebp)
  800fdc:	e8 66 fe ff ff       	call   800e47 <fd_lookup>
  800fe1:	89 c3                	mov    %eax,%ebx
  800fe3:	83 c4 08             	add    $0x8,%esp
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	0f 88 81 00 00 00    	js     80106f <dup+0xa3>
		return r;
	close(newfdnum);
  800fee:	83 ec 0c             	sub    $0xc,%esp
  800ff1:	ff 75 0c             	pushl  0xc(%ebp)
  800ff4:	e8 83 ff ff ff       	call   800f7c <close>

	newfd = INDEX2FD(newfdnum);
  800ff9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ffc:	c1 e6 0c             	shl    $0xc,%esi
  800fff:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801005:	83 c4 04             	add    $0x4,%esp
  801008:	ff 75 e4             	pushl  -0x1c(%ebp)
  80100b:	e8 d1 fd ff ff       	call   800de1 <fd2data>
  801010:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801012:	89 34 24             	mov    %esi,(%esp)
  801015:	e8 c7 fd ff ff       	call   800de1 <fd2data>
  80101a:	83 c4 10             	add    $0x10,%esp
  80101d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80101f:	89 d8                	mov    %ebx,%eax
  801021:	c1 e8 16             	shr    $0x16,%eax
  801024:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80102b:	a8 01                	test   $0x1,%al
  80102d:	74 11                	je     801040 <dup+0x74>
  80102f:	89 d8                	mov    %ebx,%eax
  801031:	c1 e8 0c             	shr    $0xc,%eax
  801034:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80103b:	f6 c2 01             	test   $0x1,%dl
  80103e:	75 39                	jne    801079 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801040:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801043:	89 d0                	mov    %edx,%eax
  801045:	c1 e8 0c             	shr    $0xc,%eax
  801048:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80104f:	83 ec 0c             	sub    $0xc,%esp
  801052:	25 07 0e 00 00       	and    $0xe07,%eax
  801057:	50                   	push   %eax
  801058:	56                   	push   %esi
  801059:	6a 00                	push   $0x0
  80105b:	52                   	push   %edx
  80105c:	6a 00                	push   $0x0
  80105e:	e8 59 fb ff ff       	call   800bbc <sys_page_map>
  801063:	89 c3                	mov    %eax,%ebx
  801065:	83 c4 20             	add    $0x20,%esp
  801068:	85 c0                	test   %eax,%eax
  80106a:	78 31                	js     80109d <dup+0xd1>
		goto err;

	return newfdnum;
  80106c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80106f:	89 d8                	mov    %ebx,%eax
  801071:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801079:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801080:	83 ec 0c             	sub    $0xc,%esp
  801083:	25 07 0e 00 00       	and    $0xe07,%eax
  801088:	50                   	push   %eax
  801089:	57                   	push   %edi
  80108a:	6a 00                	push   $0x0
  80108c:	53                   	push   %ebx
  80108d:	6a 00                	push   $0x0
  80108f:	e8 28 fb ff ff       	call   800bbc <sys_page_map>
  801094:	89 c3                	mov    %eax,%ebx
  801096:	83 c4 20             	add    $0x20,%esp
  801099:	85 c0                	test   %eax,%eax
  80109b:	79 a3                	jns    801040 <dup+0x74>
	sys_page_unmap(0, newfd);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	56                   	push   %esi
  8010a1:	6a 00                	push   $0x0
  8010a3:	e8 56 fb ff ff       	call   800bfe <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010a8:	83 c4 08             	add    $0x8,%esp
  8010ab:	57                   	push   %edi
  8010ac:	6a 00                	push   $0x0
  8010ae:	e8 4b fb ff ff       	call   800bfe <sys_page_unmap>
	return r;
  8010b3:	83 c4 10             	add    $0x10,%esp
  8010b6:	eb b7                	jmp    80106f <dup+0xa3>

008010b8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	53                   	push   %ebx
  8010bc:	83 ec 14             	sub    $0x14,%esp
  8010bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010c5:	50                   	push   %eax
  8010c6:	53                   	push   %ebx
  8010c7:	e8 7b fd ff ff       	call   800e47 <fd_lookup>
  8010cc:	83 c4 08             	add    $0x8,%esp
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	78 3f                	js     801112 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010d9:	50                   	push   %eax
  8010da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010dd:	ff 30                	pushl  (%eax)
  8010df:	e8 b9 fd ff ff       	call   800e9d <dev_lookup>
  8010e4:	83 c4 10             	add    $0x10,%esp
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	78 27                	js     801112 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010ee:	8b 42 08             	mov    0x8(%edx),%eax
  8010f1:	83 e0 03             	and    $0x3,%eax
  8010f4:	83 f8 01             	cmp    $0x1,%eax
  8010f7:	74 1e                	je     801117 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8010f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010fc:	8b 40 08             	mov    0x8(%eax),%eax
  8010ff:	85 c0                	test   %eax,%eax
  801101:	74 35                	je     801138 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801103:	83 ec 04             	sub    $0x4,%esp
  801106:	ff 75 10             	pushl  0x10(%ebp)
  801109:	ff 75 0c             	pushl  0xc(%ebp)
  80110c:	52                   	push   %edx
  80110d:	ff d0                	call   *%eax
  80110f:	83 c4 10             	add    $0x10,%esp
}
  801112:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801115:	c9                   	leave  
  801116:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801117:	a1 04 40 80 00       	mov    0x804004,%eax
  80111c:	8b 40 48             	mov    0x48(%eax),%eax
  80111f:	83 ec 04             	sub    $0x4,%esp
  801122:	53                   	push   %ebx
  801123:	50                   	push   %eax
  801124:	68 49 21 80 00       	push   $0x802149
  801129:	e8 68 f0 ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  80112e:	83 c4 10             	add    $0x10,%esp
  801131:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801136:	eb da                	jmp    801112 <read+0x5a>
		return -E_NOT_SUPP;
  801138:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80113d:	eb d3                	jmp    801112 <read+0x5a>

0080113f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	57                   	push   %edi
  801143:	56                   	push   %esi
  801144:	53                   	push   %ebx
  801145:	83 ec 0c             	sub    $0xc,%esp
  801148:	8b 7d 08             	mov    0x8(%ebp),%edi
  80114b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80114e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801153:	39 f3                	cmp    %esi,%ebx
  801155:	73 25                	jae    80117c <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801157:	83 ec 04             	sub    $0x4,%esp
  80115a:	89 f0                	mov    %esi,%eax
  80115c:	29 d8                	sub    %ebx,%eax
  80115e:	50                   	push   %eax
  80115f:	89 d8                	mov    %ebx,%eax
  801161:	03 45 0c             	add    0xc(%ebp),%eax
  801164:	50                   	push   %eax
  801165:	57                   	push   %edi
  801166:	e8 4d ff ff ff       	call   8010b8 <read>
		if (m < 0)
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	85 c0                	test   %eax,%eax
  801170:	78 08                	js     80117a <readn+0x3b>
			return m;
		if (m == 0)
  801172:	85 c0                	test   %eax,%eax
  801174:	74 06                	je     80117c <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801176:	01 c3                	add    %eax,%ebx
  801178:	eb d9                	jmp    801153 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80117a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80117c:	89 d8                	mov    %ebx,%eax
  80117e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801181:	5b                   	pop    %ebx
  801182:	5e                   	pop    %esi
  801183:	5f                   	pop    %edi
  801184:	5d                   	pop    %ebp
  801185:	c3                   	ret    

00801186 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	53                   	push   %ebx
  80118a:	83 ec 14             	sub    $0x14,%esp
  80118d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801190:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801193:	50                   	push   %eax
  801194:	53                   	push   %ebx
  801195:	e8 ad fc ff ff       	call   800e47 <fd_lookup>
  80119a:	83 c4 08             	add    $0x8,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	78 3a                	js     8011db <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011a1:	83 ec 08             	sub    $0x8,%esp
  8011a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a7:	50                   	push   %eax
  8011a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ab:	ff 30                	pushl  (%eax)
  8011ad:	e8 eb fc ff ff       	call   800e9d <dev_lookup>
  8011b2:	83 c4 10             	add    $0x10,%esp
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	78 22                	js     8011db <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011c0:	74 1e                	je     8011e0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c5:	8b 52 0c             	mov    0xc(%edx),%edx
  8011c8:	85 d2                	test   %edx,%edx
  8011ca:	74 35                	je     801201 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011cc:	83 ec 04             	sub    $0x4,%esp
  8011cf:	ff 75 10             	pushl  0x10(%ebp)
  8011d2:	ff 75 0c             	pushl  0xc(%ebp)
  8011d5:	50                   	push   %eax
  8011d6:	ff d2                	call   *%edx
  8011d8:	83 c4 10             	add    $0x10,%esp
}
  8011db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011e0:	a1 04 40 80 00       	mov    0x804004,%eax
  8011e5:	8b 40 48             	mov    0x48(%eax),%eax
  8011e8:	83 ec 04             	sub    $0x4,%esp
  8011eb:	53                   	push   %ebx
  8011ec:	50                   	push   %eax
  8011ed:	68 65 21 80 00       	push   $0x802165
  8011f2:	e8 9f ef ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ff:	eb da                	jmp    8011db <write+0x55>
		return -E_NOT_SUPP;
  801201:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801206:	eb d3                	jmp    8011db <write+0x55>

00801208 <seek>:

int
seek(int fdnum, off_t offset)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80120e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801211:	50                   	push   %eax
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	e8 2d fc ff ff       	call   800e47 <fd_lookup>
  80121a:	83 c4 08             	add    $0x8,%esp
  80121d:	85 c0                	test   %eax,%eax
  80121f:	78 0e                	js     80122f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801221:	8b 55 0c             	mov    0xc(%ebp),%edx
  801224:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801227:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80122f:	c9                   	leave  
  801230:	c3                   	ret    

00801231 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	53                   	push   %ebx
  801235:	83 ec 14             	sub    $0x14,%esp
  801238:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80123b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80123e:	50                   	push   %eax
  80123f:	53                   	push   %ebx
  801240:	e8 02 fc ff ff       	call   800e47 <fd_lookup>
  801245:	83 c4 08             	add    $0x8,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	78 37                	js     801283 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80124c:	83 ec 08             	sub    $0x8,%esp
  80124f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801252:	50                   	push   %eax
  801253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801256:	ff 30                	pushl  (%eax)
  801258:	e8 40 fc ff ff       	call   800e9d <dev_lookup>
  80125d:	83 c4 10             	add    $0x10,%esp
  801260:	85 c0                	test   %eax,%eax
  801262:	78 1f                	js     801283 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801267:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80126b:	74 1b                	je     801288 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80126d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801270:	8b 52 18             	mov    0x18(%edx),%edx
  801273:	85 d2                	test   %edx,%edx
  801275:	74 32                	je     8012a9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801277:	83 ec 08             	sub    $0x8,%esp
  80127a:	ff 75 0c             	pushl  0xc(%ebp)
  80127d:	50                   	push   %eax
  80127e:	ff d2                	call   *%edx
  801280:	83 c4 10             	add    $0x10,%esp
}
  801283:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801286:	c9                   	leave  
  801287:	c3                   	ret    
			thisenv->env_id, fdnum);
  801288:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80128d:	8b 40 48             	mov    0x48(%eax),%eax
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	53                   	push   %ebx
  801294:	50                   	push   %eax
  801295:	68 28 21 80 00       	push   $0x802128
  80129a:	e8 f7 ee ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a7:	eb da                	jmp    801283 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012ae:	eb d3                	jmp    801283 <ftruncate+0x52>

008012b0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	53                   	push   %ebx
  8012b4:	83 ec 14             	sub    $0x14,%esp
  8012b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012bd:	50                   	push   %eax
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 81 fb ff ff       	call   800e47 <fd_lookup>
  8012c6:	83 c4 08             	add    $0x8,%esp
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	78 4b                	js     801318 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012cd:	83 ec 08             	sub    $0x8,%esp
  8012d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d3:	50                   	push   %eax
  8012d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d7:	ff 30                	pushl  (%eax)
  8012d9:	e8 bf fb ff ff       	call   800e9d <dev_lookup>
  8012de:	83 c4 10             	add    $0x10,%esp
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	78 33                	js     801318 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8012e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012ec:	74 2f                	je     80131d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012ee:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012f1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012f8:	00 00 00 
	stat->st_isdir = 0;
  8012fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801302:	00 00 00 
	stat->st_dev = dev;
  801305:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80130b:	83 ec 08             	sub    $0x8,%esp
  80130e:	53                   	push   %ebx
  80130f:	ff 75 f0             	pushl  -0x10(%ebp)
  801312:	ff 50 14             	call   *0x14(%eax)
  801315:	83 c4 10             	add    $0x10,%esp
}
  801318:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    
		return -E_NOT_SUPP;
  80131d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801322:	eb f4                	jmp    801318 <fstat+0x68>

00801324 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	56                   	push   %esi
  801328:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801329:	83 ec 08             	sub    $0x8,%esp
  80132c:	6a 00                	push   $0x0
  80132e:	ff 75 08             	pushl  0x8(%ebp)
  801331:	e8 e7 01 00 00       	call   80151d <open>
  801336:	89 c3                	mov    %eax,%ebx
  801338:	83 c4 10             	add    $0x10,%esp
  80133b:	85 c0                	test   %eax,%eax
  80133d:	78 1b                	js     80135a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80133f:	83 ec 08             	sub    $0x8,%esp
  801342:	ff 75 0c             	pushl  0xc(%ebp)
  801345:	50                   	push   %eax
  801346:	e8 65 ff ff ff       	call   8012b0 <fstat>
  80134b:	89 c6                	mov    %eax,%esi
	close(fd);
  80134d:	89 1c 24             	mov    %ebx,(%esp)
  801350:	e8 27 fc ff ff       	call   800f7c <close>
	return r;
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	89 f3                	mov    %esi,%ebx
}
  80135a:	89 d8                	mov    %ebx,%eax
  80135c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80135f:	5b                   	pop    %ebx
  801360:	5e                   	pop    %esi
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    

00801363 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	56                   	push   %esi
  801367:	53                   	push   %ebx
  801368:	89 c6                	mov    %eax,%esi
  80136a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80136c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801373:	74 27                	je     80139c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801375:	6a 07                	push   $0x7
  801377:	68 00 50 80 00       	push   $0x805000
  80137c:	56                   	push   %esi
  80137d:	ff 35 00 40 80 00    	pushl  0x804000
  801383:	e8 f9 f9 ff ff       	call   800d81 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801388:	83 c4 0c             	add    $0xc,%esp
  80138b:	6a 00                	push   $0x0
  80138d:	53                   	push   %ebx
  80138e:	6a 00                	push   $0x0
  801390:	e8 d5 f9 ff ff       	call   800d6a <ipc_recv>
}
  801395:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801398:	5b                   	pop    %ebx
  801399:	5e                   	pop    %esi
  80139a:	5d                   	pop    %ebp
  80139b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	6a 01                	push   $0x1
  8013a1:	e8 f2 f9 ff ff       	call   800d98 <ipc_find_env>
  8013a6:	a3 00 40 80 00       	mov    %eax,0x804000
  8013ab:	83 c4 10             	add    $0x10,%esp
  8013ae:	eb c5                	jmp    801375 <fsipc+0x12>

008013b0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8013bc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8013d3:	e8 8b ff ff ff       	call   801363 <fsipc>
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <devfile_flush>:
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8013e6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f0:	b8 06 00 00 00       	mov    $0x6,%eax
  8013f5:	e8 69 ff ff ff       	call   801363 <fsipc>
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <devfile_stat>:
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	53                   	push   %ebx
  801400:	83 ec 04             	sub    $0x4,%esp
  801403:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8b 40 0c             	mov    0xc(%eax),%eax
  80140c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801411:	ba 00 00 00 00       	mov    $0x0,%edx
  801416:	b8 05 00 00 00       	mov    $0x5,%eax
  80141b:	e8 43 ff ff ff       	call   801363 <fsipc>
  801420:	85 c0                	test   %eax,%eax
  801422:	78 2c                	js     801450 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801424:	83 ec 08             	sub    $0x8,%esp
  801427:	68 00 50 80 00       	push   $0x805000
  80142c:	53                   	push   %ebx
  80142d:	e8 4e f3 ff ff       	call   800780 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801432:	a1 80 50 80 00       	mov    0x805080,%eax
  801437:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80143d:	a1 84 50 80 00       	mov    0x805084,%eax
  801442:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801448:	83 c4 10             	add    $0x10,%esp
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801450:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <devfile_write>:
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	83 ec 0c             	sub    $0xc,%esp
  80145b:	8b 45 10             	mov    0x10(%ebp),%eax
  80145e:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801463:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801468:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80146b:	8b 55 08             	mov    0x8(%ebp),%edx
  80146e:	8b 52 0c             	mov    0xc(%edx),%edx
  801471:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801477:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  80147c:	50                   	push   %eax
  80147d:	ff 75 0c             	pushl  0xc(%ebp)
  801480:	68 08 50 80 00       	push   $0x805008
  801485:	e8 84 f4 ff ff       	call   80090e <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80148a:	ba 00 00 00 00       	mov    $0x0,%edx
  80148f:	b8 04 00 00 00       	mov    $0x4,%eax
  801494:	e8 ca fe ff ff       	call   801363 <fsipc>
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <devfile_read>:
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	56                   	push   %esi
  80149f:	53                   	push   %ebx
  8014a0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8014ae:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8014be:	e8 a0 fe ff ff       	call   801363 <fsipc>
  8014c3:	89 c3                	mov    %eax,%ebx
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 1f                	js     8014e8 <devfile_read+0x4d>
	assert(r <= n);
  8014c9:	39 f0                	cmp    %esi,%eax
  8014cb:	77 24                	ja     8014f1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8014cd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014d2:	7f 33                	jg     801507 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014d4:	83 ec 04             	sub    $0x4,%esp
  8014d7:	50                   	push   %eax
  8014d8:	68 00 50 80 00       	push   $0x805000
  8014dd:	ff 75 0c             	pushl  0xc(%ebp)
  8014e0:	e8 29 f4 ff ff       	call   80090e <memmove>
	return r;
  8014e5:	83 c4 10             	add    $0x10,%esp
}
  8014e8:	89 d8                	mov    %ebx,%eax
  8014ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ed:	5b                   	pop    %ebx
  8014ee:	5e                   	pop    %esi
  8014ef:	5d                   	pop    %ebp
  8014f0:	c3                   	ret    
	assert(r <= n);
  8014f1:	68 94 21 80 00       	push   $0x802194
  8014f6:	68 9b 21 80 00       	push   $0x80219b
  8014fb:	6a 7c                	push   $0x7c
  8014fd:	68 b0 21 80 00       	push   $0x8021b0
  801502:	e8 85 05 00 00       	call   801a8c <_panic>
	assert(r <= PGSIZE);
  801507:	68 bb 21 80 00       	push   $0x8021bb
  80150c:	68 9b 21 80 00       	push   $0x80219b
  801511:	6a 7d                	push   $0x7d
  801513:	68 b0 21 80 00       	push   $0x8021b0
  801518:	e8 6f 05 00 00       	call   801a8c <_panic>

0080151d <open>:
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	56                   	push   %esi
  801521:	53                   	push   %ebx
  801522:	83 ec 1c             	sub    $0x1c,%esp
  801525:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801528:	56                   	push   %esi
  801529:	e8 1b f2 ff ff       	call   800749 <strlen>
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801536:	7f 6c                	jg     8015a4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801538:	83 ec 0c             	sub    $0xc,%esp
  80153b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153e:	50                   	push   %eax
  80153f:	e8 b4 f8 ff ff       	call   800df8 <fd_alloc>
  801544:	89 c3                	mov    %eax,%ebx
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	78 3c                	js     801589 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	56                   	push   %esi
  801551:	68 00 50 80 00       	push   $0x805000
  801556:	e8 25 f2 ff ff       	call   800780 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80155b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801566:	b8 01 00 00 00       	mov    $0x1,%eax
  80156b:	e8 f3 fd ff ff       	call   801363 <fsipc>
  801570:	89 c3                	mov    %eax,%ebx
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	85 c0                	test   %eax,%eax
  801577:	78 19                	js     801592 <open+0x75>
	return fd2num(fd);
  801579:	83 ec 0c             	sub    $0xc,%esp
  80157c:	ff 75 f4             	pushl  -0xc(%ebp)
  80157f:	e8 4d f8 ff ff       	call   800dd1 <fd2num>
  801584:	89 c3                	mov    %eax,%ebx
  801586:	83 c4 10             	add    $0x10,%esp
}
  801589:	89 d8                	mov    %ebx,%eax
  80158b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80158e:	5b                   	pop    %ebx
  80158f:	5e                   	pop    %esi
  801590:	5d                   	pop    %ebp
  801591:	c3                   	ret    
		fd_close(fd, 0);
  801592:	83 ec 08             	sub    $0x8,%esp
  801595:	6a 00                	push   $0x0
  801597:	ff 75 f4             	pushl  -0xc(%ebp)
  80159a:	e8 54 f9 ff ff       	call   800ef3 <fd_close>
		return r;
  80159f:	83 c4 10             	add    $0x10,%esp
  8015a2:	eb e5                	jmp    801589 <open+0x6c>
		return -E_BAD_PATH;
  8015a4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015a9:	eb de                	jmp    801589 <open+0x6c>

008015ab <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8015bb:	e8 a3 fd ff ff       	call   801363 <fsipc>
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	56                   	push   %esi
  8015c6:	53                   	push   %ebx
  8015c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8015ca:	83 ec 0c             	sub    $0xc,%esp
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	e8 0c f8 ff ff       	call   800de1 <fd2data>
  8015d5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8015d7:	83 c4 08             	add    $0x8,%esp
  8015da:	68 c7 21 80 00       	push   $0x8021c7
  8015df:	53                   	push   %ebx
  8015e0:	e8 9b f1 ff ff       	call   800780 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8015e5:	8b 46 04             	mov    0x4(%esi),%eax
  8015e8:	2b 06                	sub    (%esi),%eax
  8015ea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8015f0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015f7:	00 00 00 
	stat->st_dev = &devpipe;
  8015fa:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801601:	30 80 00 
	return 0;
}
  801604:	b8 00 00 00 00       	mov    $0x0,%eax
  801609:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80160c:	5b                   	pop    %ebx
  80160d:	5e                   	pop    %esi
  80160e:	5d                   	pop    %ebp
  80160f:	c3                   	ret    

00801610 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	53                   	push   %ebx
  801614:	83 ec 0c             	sub    $0xc,%esp
  801617:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80161a:	53                   	push   %ebx
  80161b:	6a 00                	push   $0x0
  80161d:	e8 dc f5 ff ff       	call   800bfe <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801622:	89 1c 24             	mov    %ebx,(%esp)
  801625:	e8 b7 f7 ff ff       	call   800de1 <fd2data>
  80162a:	83 c4 08             	add    $0x8,%esp
  80162d:	50                   	push   %eax
  80162e:	6a 00                	push   $0x0
  801630:	e8 c9 f5 ff ff       	call   800bfe <sys_page_unmap>
}
  801635:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <_pipeisclosed>:
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	57                   	push   %edi
  80163e:	56                   	push   %esi
  80163f:	53                   	push   %ebx
  801640:	83 ec 1c             	sub    $0x1c,%esp
  801643:	89 c7                	mov    %eax,%edi
  801645:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801647:	a1 04 40 80 00       	mov    0x804004,%eax
  80164c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80164f:	83 ec 0c             	sub    $0xc,%esp
  801652:	57                   	push   %edi
  801653:	e8 7a 04 00 00       	call   801ad2 <pageref>
  801658:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80165b:	89 34 24             	mov    %esi,(%esp)
  80165e:	e8 6f 04 00 00       	call   801ad2 <pageref>
		nn = thisenv->env_runs;
  801663:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801669:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	39 cb                	cmp    %ecx,%ebx
  801671:	74 1b                	je     80168e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801673:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801676:	75 cf                	jne    801647 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801678:	8b 42 58             	mov    0x58(%edx),%eax
  80167b:	6a 01                	push   $0x1
  80167d:	50                   	push   %eax
  80167e:	53                   	push   %ebx
  80167f:	68 ce 21 80 00       	push   $0x8021ce
  801684:	e8 0d eb ff ff       	call   800196 <cprintf>
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	eb b9                	jmp    801647 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80168e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801691:	0f 94 c0             	sete   %al
  801694:	0f b6 c0             	movzbl %al,%eax
}
  801697:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80169a:	5b                   	pop    %ebx
  80169b:	5e                   	pop    %esi
  80169c:	5f                   	pop    %edi
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    

0080169f <devpipe_write>:
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	57                   	push   %edi
  8016a3:	56                   	push   %esi
  8016a4:	53                   	push   %ebx
  8016a5:	83 ec 28             	sub    $0x28,%esp
  8016a8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8016ab:	56                   	push   %esi
  8016ac:	e8 30 f7 ff ff       	call   800de1 <fd2data>
  8016b1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8016bb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8016be:	74 4f                	je     80170f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8016c0:	8b 43 04             	mov    0x4(%ebx),%eax
  8016c3:	8b 0b                	mov    (%ebx),%ecx
  8016c5:	8d 51 20             	lea    0x20(%ecx),%edx
  8016c8:	39 d0                	cmp    %edx,%eax
  8016ca:	72 14                	jb     8016e0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8016cc:	89 da                	mov    %ebx,%edx
  8016ce:	89 f0                	mov    %esi,%eax
  8016d0:	e8 65 ff ff ff       	call   80163a <_pipeisclosed>
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	75 3a                	jne    801713 <devpipe_write+0x74>
			sys_yield();
  8016d9:	e8 7c f4 ff ff       	call   800b5a <sys_yield>
  8016de:	eb e0                	jmp    8016c0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8016e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8016e7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8016ea:	89 c2                	mov    %eax,%edx
  8016ec:	c1 fa 1f             	sar    $0x1f,%edx
  8016ef:	89 d1                	mov    %edx,%ecx
  8016f1:	c1 e9 1b             	shr    $0x1b,%ecx
  8016f4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8016f7:	83 e2 1f             	and    $0x1f,%edx
  8016fa:	29 ca                	sub    %ecx,%edx
  8016fc:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801700:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801704:	83 c0 01             	add    $0x1,%eax
  801707:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80170a:	83 c7 01             	add    $0x1,%edi
  80170d:	eb ac                	jmp    8016bb <devpipe_write+0x1c>
	return i;
  80170f:	89 f8                	mov    %edi,%eax
  801711:	eb 05                	jmp    801718 <devpipe_write+0x79>
				return 0;
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801718:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80171b:	5b                   	pop    %ebx
  80171c:	5e                   	pop    %esi
  80171d:	5f                   	pop    %edi
  80171e:	5d                   	pop    %ebp
  80171f:	c3                   	ret    

00801720 <devpipe_read>:
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	57                   	push   %edi
  801724:	56                   	push   %esi
  801725:	53                   	push   %ebx
  801726:	83 ec 18             	sub    $0x18,%esp
  801729:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80172c:	57                   	push   %edi
  80172d:	e8 af f6 ff ff       	call   800de1 <fd2data>
  801732:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	be 00 00 00 00       	mov    $0x0,%esi
  80173c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80173f:	74 47                	je     801788 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801741:	8b 03                	mov    (%ebx),%eax
  801743:	3b 43 04             	cmp    0x4(%ebx),%eax
  801746:	75 22                	jne    80176a <devpipe_read+0x4a>
			if (i > 0)
  801748:	85 f6                	test   %esi,%esi
  80174a:	75 14                	jne    801760 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80174c:	89 da                	mov    %ebx,%edx
  80174e:	89 f8                	mov    %edi,%eax
  801750:	e8 e5 fe ff ff       	call   80163a <_pipeisclosed>
  801755:	85 c0                	test   %eax,%eax
  801757:	75 33                	jne    80178c <devpipe_read+0x6c>
			sys_yield();
  801759:	e8 fc f3 ff ff       	call   800b5a <sys_yield>
  80175e:	eb e1                	jmp    801741 <devpipe_read+0x21>
				return i;
  801760:	89 f0                	mov    %esi,%eax
}
  801762:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801765:	5b                   	pop    %ebx
  801766:	5e                   	pop    %esi
  801767:	5f                   	pop    %edi
  801768:	5d                   	pop    %ebp
  801769:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80176a:	99                   	cltd   
  80176b:	c1 ea 1b             	shr    $0x1b,%edx
  80176e:	01 d0                	add    %edx,%eax
  801770:	83 e0 1f             	and    $0x1f,%eax
  801773:	29 d0                	sub    %edx,%eax
  801775:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80177a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80177d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801780:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801783:	83 c6 01             	add    $0x1,%esi
  801786:	eb b4                	jmp    80173c <devpipe_read+0x1c>
	return i;
  801788:	89 f0                	mov    %esi,%eax
  80178a:	eb d6                	jmp    801762 <devpipe_read+0x42>
				return 0;
  80178c:	b8 00 00 00 00       	mov    $0x0,%eax
  801791:	eb cf                	jmp    801762 <devpipe_read+0x42>

00801793 <pipe>:
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	56                   	push   %esi
  801797:	53                   	push   %ebx
  801798:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80179b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179e:	50                   	push   %eax
  80179f:	e8 54 f6 ff ff       	call   800df8 <fd_alloc>
  8017a4:	89 c3                	mov    %eax,%ebx
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	78 5b                	js     801808 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017ad:	83 ec 04             	sub    $0x4,%esp
  8017b0:	68 07 04 00 00       	push   $0x407
  8017b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b8:	6a 00                	push   $0x0
  8017ba:	e8 ba f3 ff ff       	call   800b79 <sys_page_alloc>
  8017bf:	89 c3                	mov    %eax,%ebx
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 40                	js     801808 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8017c8:	83 ec 0c             	sub    $0xc,%esp
  8017cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ce:	50                   	push   %eax
  8017cf:	e8 24 f6 ff ff       	call   800df8 <fd_alloc>
  8017d4:	89 c3                	mov    %eax,%ebx
  8017d6:	83 c4 10             	add    $0x10,%esp
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	78 1b                	js     8017f8 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017dd:	83 ec 04             	sub    $0x4,%esp
  8017e0:	68 07 04 00 00       	push   $0x407
  8017e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e8:	6a 00                	push   $0x0
  8017ea:	e8 8a f3 ff ff       	call   800b79 <sys_page_alloc>
  8017ef:	89 c3                	mov    %eax,%ebx
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	85 c0                	test   %eax,%eax
  8017f6:	79 19                	jns    801811 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8017f8:	83 ec 08             	sub    $0x8,%esp
  8017fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fe:	6a 00                	push   $0x0
  801800:	e8 f9 f3 ff ff       	call   800bfe <sys_page_unmap>
  801805:	83 c4 10             	add    $0x10,%esp
}
  801808:	89 d8                	mov    %ebx,%eax
  80180a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180d:	5b                   	pop    %ebx
  80180e:	5e                   	pop    %esi
  80180f:	5d                   	pop    %ebp
  801810:	c3                   	ret    
	va = fd2data(fd0);
  801811:	83 ec 0c             	sub    $0xc,%esp
  801814:	ff 75 f4             	pushl  -0xc(%ebp)
  801817:	e8 c5 f5 ff ff       	call   800de1 <fd2data>
  80181c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80181e:	83 c4 0c             	add    $0xc,%esp
  801821:	68 07 04 00 00       	push   $0x407
  801826:	50                   	push   %eax
  801827:	6a 00                	push   $0x0
  801829:	e8 4b f3 ff ff       	call   800b79 <sys_page_alloc>
  80182e:	89 c3                	mov    %eax,%ebx
  801830:	83 c4 10             	add    $0x10,%esp
  801833:	85 c0                	test   %eax,%eax
  801835:	0f 88 8c 00 00 00    	js     8018c7 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80183b:	83 ec 0c             	sub    $0xc,%esp
  80183e:	ff 75 f0             	pushl  -0x10(%ebp)
  801841:	e8 9b f5 ff ff       	call   800de1 <fd2data>
  801846:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80184d:	50                   	push   %eax
  80184e:	6a 00                	push   $0x0
  801850:	56                   	push   %esi
  801851:	6a 00                	push   $0x0
  801853:	e8 64 f3 ff ff       	call   800bbc <sys_page_map>
  801858:	89 c3                	mov    %eax,%ebx
  80185a:	83 c4 20             	add    $0x20,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	78 58                	js     8018b9 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801864:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80186a:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801879:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80187f:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801884:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80188b:	83 ec 0c             	sub    $0xc,%esp
  80188e:	ff 75 f4             	pushl  -0xc(%ebp)
  801891:	e8 3b f5 ff ff       	call   800dd1 <fd2num>
  801896:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801899:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80189b:	83 c4 04             	add    $0x4,%esp
  80189e:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a1:	e8 2b f5 ff ff       	call   800dd1 <fd2num>
  8018a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018a9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018b4:	e9 4f ff ff ff       	jmp    801808 <pipe+0x75>
	sys_page_unmap(0, va);
  8018b9:	83 ec 08             	sub    $0x8,%esp
  8018bc:	56                   	push   %esi
  8018bd:	6a 00                	push   $0x0
  8018bf:	e8 3a f3 ff ff       	call   800bfe <sys_page_unmap>
  8018c4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8018c7:	83 ec 08             	sub    $0x8,%esp
  8018ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8018cd:	6a 00                	push   $0x0
  8018cf:	e8 2a f3 ff ff       	call   800bfe <sys_page_unmap>
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	e9 1c ff ff ff       	jmp    8017f8 <pipe+0x65>

008018dc <pipeisclosed>:
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e5:	50                   	push   %eax
  8018e6:	ff 75 08             	pushl  0x8(%ebp)
  8018e9:	e8 59 f5 ff ff       	call   800e47 <fd_lookup>
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	78 18                	js     80190d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8018f5:	83 ec 0c             	sub    $0xc,%esp
  8018f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fb:	e8 e1 f4 ff ff       	call   800de1 <fd2data>
	return _pipeisclosed(fd, p);
  801900:	89 c2                	mov    %eax,%edx
  801902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801905:	e8 30 fd ff ff       	call   80163a <_pipeisclosed>
  80190a:	83 c4 10             	add    $0x10,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801912:	b8 00 00 00 00       	mov    $0x0,%eax
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    

00801919 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80191f:	68 e6 21 80 00       	push   $0x8021e6
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	e8 54 ee ff ff       	call   800780 <strcpy>
	return 0;
}
  80192c:	b8 00 00 00 00       	mov    $0x0,%eax
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <devcons_write>:
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	57                   	push   %edi
  801937:	56                   	push   %esi
  801938:	53                   	push   %ebx
  801939:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80193f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801944:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80194a:	eb 2f                	jmp    80197b <devcons_write+0x48>
		m = n - tot;
  80194c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80194f:	29 f3                	sub    %esi,%ebx
  801951:	83 fb 7f             	cmp    $0x7f,%ebx
  801954:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801959:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	53                   	push   %ebx
  801960:	89 f0                	mov    %esi,%eax
  801962:	03 45 0c             	add    0xc(%ebp),%eax
  801965:	50                   	push   %eax
  801966:	57                   	push   %edi
  801967:	e8 a2 ef ff ff       	call   80090e <memmove>
		sys_cputs(buf, m);
  80196c:	83 c4 08             	add    $0x8,%esp
  80196f:	53                   	push   %ebx
  801970:	57                   	push   %edi
  801971:	e8 47 f1 ff ff       	call   800abd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801976:	01 de                	add    %ebx,%esi
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80197e:	72 cc                	jb     80194c <devcons_write+0x19>
}
  801980:	89 f0                	mov    %esi,%eax
  801982:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801985:	5b                   	pop    %ebx
  801986:	5e                   	pop    %esi
  801987:	5f                   	pop    %edi
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <devcons_read>:
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 08             	sub    $0x8,%esp
  801990:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801995:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801999:	75 07                	jne    8019a2 <devcons_read+0x18>
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    
		sys_yield();
  80199d:	e8 b8 f1 ff ff       	call   800b5a <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8019a2:	e8 34 f1 ff ff       	call   800adb <sys_cgetc>
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	74 f2                	je     80199d <devcons_read+0x13>
	if (c < 0)
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	78 ec                	js     80199b <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8019af:	83 f8 04             	cmp    $0x4,%eax
  8019b2:	74 0c                	je     8019c0 <devcons_read+0x36>
	*(char*)vbuf = c;
  8019b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b7:	88 02                	mov    %al,(%edx)
	return 1;
  8019b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019be:	eb db                	jmp    80199b <devcons_read+0x11>
		return 0;
  8019c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c5:	eb d4                	jmp    80199b <devcons_read+0x11>

008019c7 <cputchar>:
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8019d3:	6a 01                	push   $0x1
  8019d5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019d8:	50                   	push   %eax
  8019d9:	e8 df f0 ff ff       	call   800abd <sys_cputs>
}
  8019de:	83 c4 10             	add    $0x10,%esp
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <getchar>:
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8019e9:	6a 01                	push   $0x1
  8019eb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019ee:	50                   	push   %eax
  8019ef:	6a 00                	push   $0x0
  8019f1:	e8 c2 f6 ff ff       	call   8010b8 <read>
	if (r < 0)
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	78 08                	js     801a05 <getchar+0x22>
	if (r < 1)
  8019fd:	85 c0                	test   %eax,%eax
  8019ff:	7e 06                	jle    801a07 <getchar+0x24>
	return c;
  801a01:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    
		return -E_EOF;
  801a07:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a0c:	eb f7                	jmp    801a05 <getchar+0x22>

00801a0e <iscons>:
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a17:	50                   	push   %eax
  801a18:	ff 75 08             	pushl  0x8(%ebp)
  801a1b:	e8 27 f4 ff ff       	call   800e47 <fd_lookup>
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	85 c0                	test   %eax,%eax
  801a25:	78 11                	js     801a38 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a30:	39 10                	cmp    %edx,(%eax)
  801a32:	0f 94 c0             	sete   %al
  801a35:	0f b6 c0             	movzbl %al,%eax
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <opencons>:
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801a40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a43:	50                   	push   %eax
  801a44:	e8 af f3 ff ff       	call   800df8 <fd_alloc>
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	78 3a                	js     801a8a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a50:	83 ec 04             	sub    $0x4,%esp
  801a53:	68 07 04 00 00       	push   $0x407
  801a58:	ff 75 f4             	pushl  -0xc(%ebp)
  801a5b:	6a 00                	push   $0x0
  801a5d:	e8 17 f1 ff ff       	call   800b79 <sys_page_alloc>
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	85 c0                	test   %eax,%eax
  801a67:	78 21                	js     801a8a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a72:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a77:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a7e:	83 ec 0c             	sub    $0xc,%esp
  801a81:	50                   	push   %eax
  801a82:	e8 4a f3 ff ff       	call   800dd1 <fd2num>
  801a87:	83 c4 10             	add    $0x10,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	56                   	push   %esi
  801a90:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801a91:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a94:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801a9a:	e8 9c f0 ff ff       	call   800b3b <sys_getenvid>
  801a9f:	83 ec 0c             	sub    $0xc,%esp
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	ff 75 08             	pushl  0x8(%ebp)
  801aa8:	56                   	push   %esi
  801aa9:	50                   	push   %eax
  801aaa:	68 f4 21 80 00       	push   $0x8021f4
  801aaf:	e8 e2 e6 ff ff       	call   800196 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ab4:	83 c4 18             	add    $0x18,%esp
  801ab7:	53                   	push   %ebx
  801ab8:	ff 75 10             	pushl  0x10(%ebp)
  801abb:	e8 85 e6 ff ff       	call   800145 <vcprintf>
	cprintf("\n");
  801ac0:	c7 04 24 df 21 80 00 	movl   $0x8021df,(%esp)
  801ac7:	e8 ca e6 ff ff       	call   800196 <cprintf>
  801acc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801acf:	cc                   	int3   
  801ad0:	eb fd                	jmp    801acf <_panic+0x43>

00801ad2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ad8:	89 d0                	mov    %edx,%eax
  801ada:	c1 e8 16             	shr    $0x16,%eax
  801add:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ae4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ae9:	f6 c1 01             	test   $0x1,%cl
  801aec:	74 1d                	je     801b0b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801aee:	c1 ea 0c             	shr    $0xc,%edx
  801af1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801af8:	f6 c2 01             	test   $0x1,%dl
  801afb:	74 0e                	je     801b0b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801afd:	c1 ea 0c             	shr    $0xc,%edx
  801b00:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801b07:	ef 
  801b08:	0f b7 c0             	movzwl %ax,%eax
}
  801b0b:	5d                   	pop    %ebp
  801b0c:	c3                   	ret    
  801b0d:	66 90                	xchg   %ax,%ax
  801b0f:	90                   	nop

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
