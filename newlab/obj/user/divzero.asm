
obj/user/divzero.debug：     文件格式 elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  800039:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 20 1d 80 00       	push   $0x801d20
  800056:	e8 fa 00 00 00       	call   800155 <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	56                   	push   %esi
  800064:	53                   	push   %ebx
  800065:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800068:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80006b:	e8 8a 0a 00 00       	call   800afa <sys_getenvid>
  800070:	25 ff 03 00 00       	and    $0x3ff,%eax
  800075:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800078:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007d:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800082:	85 db                	test   %ebx,%ebx
  800084:	7e 07                	jle    80008d <libmain+0x2d>
		binaryname = argv[0];
  800086:	8b 06                	mov    (%esi),%eax
  800088:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008d:	83 ec 08             	sub    $0x8,%esp
  800090:	56                   	push   %esi
  800091:	53                   	push   %ebx
  800092:	e8 9c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800097:	e8 0a 00 00 00       	call   8000a6 <exit>
}
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a2:	5b                   	pop    %ebx
  8000a3:	5e                   	pop    %esi
  8000a4:	5d                   	pop    %ebp
  8000a5:	c3                   	ret    

008000a6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ac:	e8 4e 0e 00 00       	call   800eff <close_all>
	sys_env_destroy(0);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	6a 00                	push   $0x0
  8000b6:	e8 fe 09 00 00       	call   800ab9 <sys_env_destroy>
}
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 04             	sub    $0x4,%esp
  8000c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ca:	8b 13                	mov    (%ebx),%edx
  8000cc:	8d 42 01             	lea    0x1(%edx),%eax
  8000cf:	89 03                	mov    %eax,(%ebx)
  8000d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000dd:	74 09                	je     8000e8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000df:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e6:	c9                   	leave  
  8000e7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e8:	83 ec 08             	sub    $0x8,%esp
  8000eb:	68 ff 00 00 00       	push   $0xff
  8000f0:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f3:	50                   	push   %eax
  8000f4:	e8 83 09 00 00       	call   800a7c <sys_cputs>
		b->idx = 0;
  8000f9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	eb db                	jmp    8000df <putch+0x1f>

00800104 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80010d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800114:	00 00 00 
	b.cnt = 0;
  800117:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800121:	ff 75 0c             	pushl  0xc(%ebp)
  800124:	ff 75 08             	pushl  0x8(%ebp)
  800127:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80012d:	50                   	push   %eax
  80012e:	68 c0 00 80 00       	push   $0x8000c0
  800133:	e8 1a 01 00 00       	call   800252 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800138:	83 c4 08             	add    $0x8,%esp
  80013b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800141:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800147:	50                   	push   %eax
  800148:	e8 2f 09 00 00       	call   800a7c <sys_cputs>

	return b.cnt;
}
  80014d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800153:	c9                   	leave  
  800154:	c3                   	ret    

00800155 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80015b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80015e:	50                   	push   %eax
  80015f:	ff 75 08             	pushl  0x8(%ebp)
  800162:	e8 9d ff ff ff       	call   800104 <vcprintf>
	va_end(ap);

	return cnt;
}
  800167:	c9                   	leave  
  800168:	c3                   	ret    

00800169 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	57                   	push   %edi
  80016d:	56                   	push   %esi
  80016e:	53                   	push   %ebx
  80016f:	83 ec 1c             	sub    $0x1c,%esp
  800172:	89 c7                	mov    %eax,%edi
  800174:	89 d6                	mov    %edx,%esi
  800176:	8b 45 08             	mov    0x8(%ebp),%eax
  800179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80017f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800182:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80018a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80018d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800190:	39 d3                	cmp    %edx,%ebx
  800192:	72 05                	jb     800199 <printnum+0x30>
  800194:	39 45 10             	cmp    %eax,0x10(%ebp)
  800197:	77 7a                	ja     800213 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800199:	83 ec 0c             	sub    $0xc,%esp
  80019c:	ff 75 18             	pushl  0x18(%ebp)
  80019f:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001a5:	53                   	push   %ebx
  8001a6:	ff 75 10             	pushl  0x10(%ebp)
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001af:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001b8:	e8 13 19 00 00       	call   801ad0 <__udivdi3>
  8001bd:	83 c4 18             	add    $0x18,%esp
  8001c0:	52                   	push   %edx
  8001c1:	50                   	push   %eax
  8001c2:	89 f2                	mov    %esi,%edx
  8001c4:	89 f8                	mov    %edi,%eax
  8001c6:	e8 9e ff ff ff       	call   800169 <printnum>
  8001cb:	83 c4 20             	add    $0x20,%esp
  8001ce:	eb 13                	jmp    8001e3 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	56                   	push   %esi
  8001d4:	ff 75 18             	pushl  0x18(%ebp)
  8001d7:	ff d7                	call   *%edi
  8001d9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001dc:	83 eb 01             	sub    $0x1,%ebx
  8001df:	85 db                	test   %ebx,%ebx
  8001e1:	7f ed                	jg     8001d0 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	56                   	push   %esi
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f3:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f6:	e8 f5 19 00 00       	call   801bf0 <__umoddi3>
  8001fb:	83 c4 14             	add    $0x14,%esp
  8001fe:	0f be 80 38 1d 80 00 	movsbl 0x801d38(%eax),%eax
  800205:	50                   	push   %eax
  800206:	ff d7                	call   *%edi
}
  800208:	83 c4 10             	add    $0x10,%esp
  80020b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020e:	5b                   	pop    %ebx
  80020f:	5e                   	pop    %esi
  800210:	5f                   	pop    %edi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    
  800213:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800216:	eb c4                	jmp    8001dc <printnum+0x73>

00800218 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80021e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800222:	8b 10                	mov    (%eax),%edx
  800224:	3b 50 04             	cmp    0x4(%eax),%edx
  800227:	73 0a                	jae    800233 <sprintputch+0x1b>
		*b->buf++ = ch;
  800229:	8d 4a 01             	lea    0x1(%edx),%ecx
  80022c:	89 08                	mov    %ecx,(%eax)
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	88 02                	mov    %al,(%edx)
}
  800233:	5d                   	pop    %ebp
  800234:	c3                   	ret    

00800235 <printfmt>:
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80023b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80023e:	50                   	push   %eax
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	e8 05 00 00 00       	call   800252 <vprintfmt>
}
  80024d:	83 c4 10             	add    $0x10,%esp
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <vprintfmt>:
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	57                   	push   %edi
  800256:	56                   	push   %esi
  800257:	53                   	push   %ebx
  800258:	83 ec 2c             	sub    $0x2c,%esp
  80025b:	8b 75 08             	mov    0x8(%ebp),%esi
  80025e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800261:	8b 7d 10             	mov    0x10(%ebp),%edi
  800264:	e9 8c 03 00 00       	jmp    8005f5 <vprintfmt+0x3a3>
		padc = ' ';
  800269:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80026d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800274:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80027b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800282:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800287:	8d 47 01             	lea    0x1(%edi),%eax
  80028a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028d:	0f b6 17             	movzbl (%edi),%edx
  800290:	8d 42 dd             	lea    -0x23(%edx),%eax
  800293:	3c 55                	cmp    $0x55,%al
  800295:	0f 87 dd 03 00 00    	ja     800678 <vprintfmt+0x426>
  80029b:	0f b6 c0             	movzbl %al,%eax
  80029e:	ff 24 85 80 1e 80 00 	jmp    *0x801e80(,%eax,4)
  8002a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002a8:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002ac:	eb d9                	jmp    800287 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002b1:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002b5:	eb d0                	jmp    800287 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002b7:	0f b6 d2             	movzbl %dl,%edx
  8002ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002c5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002c8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002cc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002cf:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002d2:	83 f9 09             	cmp    $0x9,%ecx
  8002d5:	77 55                	ja     80032c <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002d7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002da:	eb e9                	jmp    8002c5 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002df:	8b 00                	mov    (%eax),%eax
  8002e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e7:	8d 40 04             	lea    0x4(%eax),%eax
  8002ea:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002f4:	79 91                	jns    800287 <vprintfmt+0x35>
				width = precision, precision = -1;
  8002f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002fc:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800303:	eb 82                	jmp    800287 <vprintfmt+0x35>
  800305:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800308:	85 c0                	test   %eax,%eax
  80030a:	ba 00 00 00 00       	mov    $0x0,%edx
  80030f:	0f 49 d0             	cmovns %eax,%edx
  800312:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800315:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800318:	e9 6a ff ff ff       	jmp    800287 <vprintfmt+0x35>
  80031d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800320:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800327:	e9 5b ff ff ff       	jmp    800287 <vprintfmt+0x35>
  80032c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80032f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800332:	eb bc                	jmp    8002f0 <vprintfmt+0x9e>
			lflag++;
  800334:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800337:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80033a:	e9 48 ff ff ff       	jmp    800287 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80033f:	8b 45 14             	mov    0x14(%ebp),%eax
  800342:	8d 78 04             	lea    0x4(%eax),%edi
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	53                   	push   %ebx
  800349:	ff 30                	pushl  (%eax)
  80034b:	ff d6                	call   *%esi
			break;
  80034d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800350:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800353:	e9 9a 02 00 00       	jmp    8005f2 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800358:	8b 45 14             	mov    0x14(%ebp),%eax
  80035b:	8d 78 04             	lea    0x4(%eax),%edi
  80035e:	8b 00                	mov    (%eax),%eax
  800360:	99                   	cltd   
  800361:	31 d0                	xor    %edx,%eax
  800363:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800365:	83 f8 0f             	cmp    $0xf,%eax
  800368:	7f 23                	jg     80038d <vprintfmt+0x13b>
  80036a:	8b 14 85 e0 1f 80 00 	mov    0x801fe0(,%eax,4),%edx
  800371:	85 d2                	test   %edx,%edx
  800373:	74 18                	je     80038d <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800375:	52                   	push   %edx
  800376:	68 11 21 80 00       	push   $0x802111
  80037b:	53                   	push   %ebx
  80037c:	56                   	push   %esi
  80037d:	e8 b3 fe ff ff       	call   800235 <printfmt>
  800382:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800385:	89 7d 14             	mov    %edi,0x14(%ebp)
  800388:	e9 65 02 00 00       	jmp    8005f2 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  80038d:	50                   	push   %eax
  80038e:	68 50 1d 80 00       	push   $0x801d50
  800393:	53                   	push   %ebx
  800394:	56                   	push   %esi
  800395:	e8 9b fe ff ff       	call   800235 <printfmt>
  80039a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80039d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003a0:	e9 4d 02 00 00       	jmp    8005f2 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  8003a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a8:	83 c0 04             	add    $0x4,%eax
  8003ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b1:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003b3:	85 ff                	test   %edi,%edi
  8003b5:	b8 49 1d 80 00       	mov    $0x801d49,%eax
  8003ba:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c1:	0f 8e bd 00 00 00    	jle    800484 <vprintfmt+0x232>
  8003c7:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003cb:	75 0e                	jne    8003db <vprintfmt+0x189>
  8003cd:	89 75 08             	mov    %esi,0x8(%ebp)
  8003d0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003d3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003d6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003d9:	eb 6d                	jmp    800448 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e1:	57                   	push   %edi
  8003e2:	e8 39 03 00 00       	call   800720 <strnlen>
  8003e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003ea:	29 c1                	sub    %eax,%ecx
  8003ec:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003ef:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003f2:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003fc:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fe:	eb 0f                	jmp    80040f <vprintfmt+0x1bd>
					putch(padc, putdat);
  800400:	83 ec 08             	sub    $0x8,%esp
  800403:	53                   	push   %ebx
  800404:	ff 75 e0             	pushl  -0x20(%ebp)
  800407:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800409:	83 ef 01             	sub    $0x1,%edi
  80040c:	83 c4 10             	add    $0x10,%esp
  80040f:	85 ff                	test   %edi,%edi
  800411:	7f ed                	jg     800400 <vprintfmt+0x1ae>
  800413:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800416:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800419:	85 c9                	test   %ecx,%ecx
  80041b:	b8 00 00 00 00       	mov    $0x0,%eax
  800420:	0f 49 c1             	cmovns %ecx,%eax
  800423:	29 c1                	sub    %eax,%ecx
  800425:	89 75 08             	mov    %esi,0x8(%ebp)
  800428:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80042b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80042e:	89 cb                	mov    %ecx,%ebx
  800430:	eb 16                	jmp    800448 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800432:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800436:	75 31                	jne    800469 <vprintfmt+0x217>
					putch(ch, putdat);
  800438:	83 ec 08             	sub    $0x8,%esp
  80043b:	ff 75 0c             	pushl  0xc(%ebp)
  80043e:	50                   	push   %eax
  80043f:	ff 55 08             	call   *0x8(%ebp)
  800442:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800445:	83 eb 01             	sub    $0x1,%ebx
  800448:	83 c7 01             	add    $0x1,%edi
  80044b:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80044f:	0f be c2             	movsbl %dl,%eax
  800452:	85 c0                	test   %eax,%eax
  800454:	74 59                	je     8004af <vprintfmt+0x25d>
  800456:	85 f6                	test   %esi,%esi
  800458:	78 d8                	js     800432 <vprintfmt+0x1e0>
  80045a:	83 ee 01             	sub    $0x1,%esi
  80045d:	79 d3                	jns    800432 <vprintfmt+0x1e0>
  80045f:	89 df                	mov    %ebx,%edi
  800461:	8b 75 08             	mov    0x8(%ebp),%esi
  800464:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800467:	eb 37                	jmp    8004a0 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800469:	0f be d2             	movsbl %dl,%edx
  80046c:	83 ea 20             	sub    $0x20,%edx
  80046f:	83 fa 5e             	cmp    $0x5e,%edx
  800472:	76 c4                	jbe    800438 <vprintfmt+0x1e6>
					putch('?', putdat);
  800474:	83 ec 08             	sub    $0x8,%esp
  800477:	ff 75 0c             	pushl  0xc(%ebp)
  80047a:	6a 3f                	push   $0x3f
  80047c:	ff 55 08             	call   *0x8(%ebp)
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	eb c1                	jmp    800445 <vprintfmt+0x1f3>
  800484:	89 75 08             	mov    %esi,0x8(%ebp)
  800487:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80048a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800490:	eb b6                	jmp    800448 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	53                   	push   %ebx
  800496:	6a 20                	push   $0x20
  800498:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80049a:	83 ef 01             	sub    $0x1,%edi
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	85 ff                	test   %edi,%edi
  8004a2:	7f ee                	jg     800492 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004aa:	e9 43 01 00 00       	jmp    8005f2 <vprintfmt+0x3a0>
  8004af:	89 df                	mov    %ebx,%edi
  8004b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004b7:	eb e7                	jmp    8004a0 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004b9:	83 f9 01             	cmp    $0x1,%ecx
  8004bc:	7e 3f                	jle    8004fd <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004be:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c1:	8b 50 04             	mov    0x4(%eax),%edx
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cf:	8d 40 08             	lea    0x8(%eax),%eax
  8004d2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004d9:	79 5c                	jns    800537 <vprintfmt+0x2e5>
				putch('-', putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	53                   	push   %ebx
  8004df:	6a 2d                	push   $0x2d
  8004e1:	ff d6                	call   *%esi
				num = -(long long) num;
  8004e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004e9:	f7 da                	neg    %edx
  8004eb:	83 d1 00             	adc    $0x0,%ecx
  8004ee:	f7 d9                	neg    %ecx
  8004f0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004f8:	e9 db 00 00 00       	jmp    8005d8 <vprintfmt+0x386>
	else if (lflag)
  8004fd:	85 c9                	test   %ecx,%ecx
  8004ff:	75 1b                	jne    80051c <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800509:	89 c1                	mov    %eax,%ecx
  80050b:	c1 f9 1f             	sar    $0x1f,%ecx
  80050e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	8d 40 04             	lea    0x4(%eax),%eax
  800517:	89 45 14             	mov    %eax,0x14(%ebp)
  80051a:	eb b9                	jmp    8004d5 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80051c:	8b 45 14             	mov    0x14(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800524:	89 c1                	mov    %eax,%ecx
  800526:	c1 f9 1f             	sar    $0x1f,%ecx
  800529:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	8d 40 04             	lea    0x4(%eax),%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
  800535:	eb 9e                	jmp    8004d5 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800537:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80053d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800542:	e9 91 00 00 00       	jmp    8005d8 <vprintfmt+0x386>
	if (lflag >= 2)
  800547:	83 f9 01             	cmp    $0x1,%ecx
  80054a:	7e 15                	jle    800561 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	8b 10                	mov    (%eax),%edx
  800551:	8b 48 04             	mov    0x4(%eax),%ecx
  800554:	8d 40 08             	lea    0x8(%eax),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80055a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80055f:	eb 77                	jmp    8005d8 <vprintfmt+0x386>
	else if (lflag)
  800561:	85 c9                	test   %ecx,%ecx
  800563:	75 17                	jne    80057c <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	8b 10                	mov    (%eax),%edx
  80056a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80056f:	8d 40 04             	lea    0x4(%eax),%eax
  800572:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800575:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057a:	eb 5c                	jmp    8005d8 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 10                	mov    (%eax),%edx
  800581:	b9 00 00 00 00       	mov    $0x0,%ecx
  800586:	8d 40 04             	lea    0x4(%eax),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800591:	eb 45                	jmp    8005d8 <vprintfmt+0x386>
			putch('X', putdat);
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	53                   	push   %ebx
  800597:	6a 58                	push   $0x58
  800599:	ff d6                	call   *%esi
			putch('X', putdat);
  80059b:	83 c4 08             	add    $0x8,%esp
  80059e:	53                   	push   %ebx
  80059f:	6a 58                	push   $0x58
  8005a1:	ff d6                	call   *%esi
			putch('X', putdat);
  8005a3:	83 c4 08             	add    $0x8,%esp
  8005a6:	53                   	push   %ebx
  8005a7:	6a 58                	push   $0x58
  8005a9:	ff d6                	call   *%esi
			break;
  8005ab:	83 c4 10             	add    $0x10,%esp
  8005ae:	eb 42                	jmp    8005f2 <vprintfmt+0x3a0>
			putch('0', putdat);
  8005b0:	83 ec 08             	sub    $0x8,%esp
  8005b3:	53                   	push   %ebx
  8005b4:	6a 30                	push   $0x30
  8005b6:	ff d6                	call   *%esi
			putch('x', putdat);
  8005b8:	83 c4 08             	add    $0x8,%esp
  8005bb:	53                   	push   %ebx
  8005bc:	6a 78                	push   $0x78
  8005be:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	8b 10                	mov    (%eax),%edx
  8005c5:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005ca:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005cd:	8d 40 04             	lea    0x4(%eax),%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005d3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005df:	57                   	push   %edi
  8005e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8005e3:	50                   	push   %eax
  8005e4:	51                   	push   %ecx
  8005e5:	52                   	push   %edx
  8005e6:	89 da                	mov    %ebx,%edx
  8005e8:	89 f0                	mov    %esi,%eax
  8005ea:	e8 7a fb ff ff       	call   800169 <printnum>
			break;
  8005ef:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8005f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005f5:	83 c7 01             	add    $0x1,%edi
  8005f8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005fc:	83 f8 25             	cmp    $0x25,%eax
  8005ff:	0f 84 64 fc ff ff    	je     800269 <vprintfmt+0x17>
			if (ch == '\0')
  800605:	85 c0                	test   %eax,%eax
  800607:	0f 84 8b 00 00 00    	je     800698 <vprintfmt+0x446>
			putch(ch, putdat);
  80060d:	83 ec 08             	sub    $0x8,%esp
  800610:	53                   	push   %ebx
  800611:	50                   	push   %eax
  800612:	ff d6                	call   *%esi
  800614:	83 c4 10             	add    $0x10,%esp
  800617:	eb dc                	jmp    8005f5 <vprintfmt+0x3a3>
	if (lflag >= 2)
  800619:	83 f9 01             	cmp    $0x1,%ecx
  80061c:	7e 15                	jle    800633 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8b 10                	mov    (%eax),%edx
  800623:	8b 48 04             	mov    0x4(%eax),%ecx
  800626:	8d 40 08             	lea    0x8(%eax),%eax
  800629:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80062c:	b8 10 00 00 00       	mov    $0x10,%eax
  800631:	eb a5                	jmp    8005d8 <vprintfmt+0x386>
	else if (lflag)
  800633:	85 c9                	test   %ecx,%ecx
  800635:	75 17                	jne    80064e <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8b 10                	mov    (%eax),%edx
  80063c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800641:	8d 40 04             	lea    0x4(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800647:	b8 10 00 00 00       	mov    $0x10,%eax
  80064c:	eb 8a                	jmp    8005d8 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8b 10                	mov    (%eax),%edx
  800653:	b9 00 00 00 00       	mov    $0x0,%ecx
  800658:	8d 40 04             	lea    0x4(%eax),%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80065e:	b8 10 00 00 00       	mov    $0x10,%eax
  800663:	e9 70 ff ff ff       	jmp    8005d8 <vprintfmt+0x386>
			putch(ch, putdat);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	53                   	push   %ebx
  80066c:	6a 25                	push   $0x25
  80066e:	ff d6                	call   *%esi
			break;
  800670:	83 c4 10             	add    $0x10,%esp
  800673:	e9 7a ff ff ff       	jmp    8005f2 <vprintfmt+0x3a0>
			putch('%', putdat);
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	53                   	push   %ebx
  80067c:	6a 25                	push   $0x25
  80067e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800680:	83 c4 10             	add    $0x10,%esp
  800683:	89 f8                	mov    %edi,%eax
  800685:	eb 03                	jmp    80068a <vprintfmt+0x438>
  800687:	83 e8 01             	sub    $0x1,%eax
  80068a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80068e:	75 f7                	jne    800687 <vprintfmt+0x435>
  800690:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800693:	e9 5a ff ff ff       	jmp    8005f2 <vprintfmt+0x3a0>
}
  800698:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80069b:	5b                   	pop    %ebx
  80069c:	5e                   	pop    %esi
  80069d:	5f                   	pop    %edi
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    

008006a0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
  8006a3:	83 ec 18             	sub    $0x18,%esp
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006af:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006b3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006bd:	85 c0                	test   %eax,%eax
  8006bf:	74 26                	je     8006e7 <vsnprintf+0x47>
  8006c1:	85 d2                	test   %edx,%edx
  8006c3:	7e 22                	jle    8006e7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006c5:	ff 75 14             	pushl  0x14(%ebp)
  8006c8:	ff 75 10             	pushl  0x10(%ebp)
  8006cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006ce:	50                   	push   %eax
  8006cf:	68 18 02 80 00       	push   $0x800218
  8006d4:	e8 79 fb ff ff       	call   800252 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006dc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006e2:	83 c4 10             	add    $0x10,%esp
}
  8006e5:	c9                   	leave  
  8006e6:	c3                   	ret    
		return -E_INVAL;
  8006e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006ec:	eb f7                	jmp    8006e5 <vsnprintf+0x45>

008006ee <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006f4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006f7:	50                   	push   %eax
  8006f8:	ff 75 10             	pushl  0x10(%ebp)
  8006fb:	ff 75 0c             	pushl  0xc(%ebp)
  8006fe:	ff 75 08             	pushl  0x8(%ebp)
  800701:	e8 9a ff ff ff       	call   8006a0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800706:	c9                   	leave  
  800707:	c3                   	ret    

00800708 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800708:	55                   	push   %ebp
  800709:	89 e5                	mov    %esp,%ebp
  80070b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80070e:	b8 00 00 00 00       	mov    $0x0,%eax
  800713:	eb 03                	jmp    800718 <strlen+0x10>
		n++;
  800715:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800718:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80071c:	75 f7                	jne    800715 <strlen+0xd>
	return n;
}
  80071e:	5d                   	pop    %ebp
  80071f:	c3                   	ret    

00800720 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800720:	55                   	push   %ebp
  800721:	89 e5                	mov    %esp,%ebp
  800723:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800726:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800729:	b8 00 00 00 00       	mov    $0x0,%eax
  80072e:	eb 03                	jmp    800733 <strnlen+0x13>
		n++;
  800730:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800733:	39 d0                	cmp    %edx,%eax
  800735:	74 06                	je     80073d <strnlen+0x1d>
  800737:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80073b:	75 f3                	jne    800730 <strnlen+0x10>
	return n;
}
  80073d:	5d                   	pop    %ebp
  80073e:	c3                   	ret    

0080073f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
  800742:	53                   	push   %ebx
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800749:	89 c2                	mov    %eax,%edx
  80074b:	83 c1 01             	add    $0x1,%ecx
  80074e:	83 c2 01             	add    $0x1,%edx
  800751:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800755:	88 5a ff             	mov    %bl,-0x1(%edx)
  800758:	84 db                	test   %bl,%bl
  80075a:	75 ef                	jne    80074b <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80075c:	5b                   	pop    %ebx
  80075d:	5d                   	pop    %ebp
  80075e:	c3                   	ret    

0080075f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	53                   	push   %ebx
  800763:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800766:	53                   	push   %ebx
  800767:	e8 9c ff ff ff       	call   800708 <strlen>
  80076c:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80076f:	ff 75 0c             	pushl  0xc(%ebp)
  800772:	01 d8                	add    %ebx,%eax
  800774:	50                   	push   %eax
  800775:	e8 c5 ff ff ff       	call   80073f <strcpy>
	return dst;
}
  80077a:	89 d8                	mov    %ebx,%eax
  80077c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80077f:	c9                   	leave  
  800780:	c3                   	ret    

00800781 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	56                   	push   %esi
  800785:	53                   	push   %ebx
  800786:	8b 75 08             	mov    0x8(%ebp),%esi
  800789:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80078c:	89 f3                	mov    %esi,%ebx
  80078e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800791:	89 f2                	mov    %esi,%edx
  800793:	eb 0f                	jmp    8007a4 <strncpy+0x23>
		*dst++ = *src;
  800795:	83 c2 01             	add    $0x1,%edx
  800798:	0f b6 01             	movzbl (%ecx),%eax
  80079b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80079e:	80 39 01             	cmpb   $0x1,(%ecx)
  8007a1:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007a4:	39 da                	cmp    %ebx,%edx
  8007a6:	75 ed                	jne    800795 <strncpy+0x14>
	}
	return ret;
}
  8007a8:	89 f0                	mov    %esi,%eax
  8007aa:	5b                   	pop    %ebx
  8007ab:	5e                   	pop    %esi
  8007ac:	5d                   	pop    %ebp
  8007ad:	c3                   	ret    

008007ae <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	56                   	push   %esi
  8007b2:	53                   	push   %ebx
  8007b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007bc:	89 f0                	mov    %esi,%eax
  8007be:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007c2:	85 c9                	test   %ecx,%ecx
  8007c4:	75 0b                	jne    8007d1 <strlcpy+0x23>
  8007c6:	eb 17                	jmp    8007df <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007c8:	83 c2 01             	add    $0x1,%edx
  8007cb:	83 c0 01             	add    $0x1,%eax
  8007ce:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8007d1:	39 d8                	cmp    %ebx,%eax
  8007d3:	74 07                	je     8007dc <strlcpy+0x2e>
  8007d5:	0f b6 0a             	movzbl (%edx),%ecx
  8007d8:	84 c9                	test   %cl,%cl
  8007da:	75 ec                	jne    8007c8 <strlcpy+0x1a>
		*dst = '\0';
  8007dc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007df:	29 f0                	sub    %esi,%eax
}
  8007e1:	5b                   	pop    %ebx
  8007e2:	5e                   	pop    %esi
  8007e3:	5d                   	pop    %ebp
  8007e4:	c3                   	ret    

008007e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007ee:	eb 06                	jmp    8007f6 <strcmp+0x11>
		p++, q++;
  8007f0:	83 c1 01             	add    $0x1,%ecx
  8007f3:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8007f6:	0f b6 01             	movzbl (%ecx),%eax
  8007f9:	84 c0                	test   %al,%al
  8007fb:	74 04                	je     800801 <strcmp+0x1c>
  8007fd:	3a 02                	cmp    (%edx),%al
  8007ff:	74 ef                	je     8007f0 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800801:	0f b6 c0             	movzbl %al,%eax
  800804:	0f b6 12             	movzbl (%edx),%edx
  800807:	29 d0                	sub    %edx,%eax
}
  800809:	5d                   	pop    %ebp
  80080a:	c3                   	ret    

0080080b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	53                   	push   %ebx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	8b 55 0c             	mov    0xc(%ebp),%edx
  800815:	89 c3                	mov    %eax,%ebx
  800817:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80081a:	eb 06                	jmp    800822 <strncmp+0x17>
		n--, p++, q++;
  80081c:	83 c0 01             	add    $0x1,%eax
  80081f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800822:	39 d8                	cmp    %ebx,%eax
  800824:	74 16                	je     80083c <strncmp+0x31>
  800826:	0f b6 08             	movzbl (%eax),%ecx
  800829:	84 c9                	test   %cl,%cl
  80082b:	74 04                	je     800831 <strncmp+0x26>
  80082d:	3a 0a                	cmp    (%edx),%cl
  80082f:	74 eb                	je     80081c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800831:	0f b6 00             	movzbl (%eax),%eax
  800834:	0f b6 12             	movzbl (%edx),%edx
  800837:	29 d0                	sub    %edx,%eax
}
  800839:	5b                   	pop    %ebx
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    
		return 0;
  80083c:	b8 00 00 00 00       	mov    $0x0,%eax
  800841:	eb f6                	jmp    800839 <strncmp+0x2e>

00800843 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80084d:	0f b6 10             	movzbl (%eax),%edx
  800850:	84 d2                	test   %dl,%dl
  800852:	74 09                	je     80085d <strchr+0x1a>
		if (*s == c)
  800854:	38 ca                	cmp    %cl,%dl
  800856:	74 0a                	je     800862 <strchr+0x1f>
	for (; *s; s++)
  800858:	83 c0 01             	add    $0x1,%eax
  80085b:	eb f0                	jmp    80084d <strchr+0xa>
			return (char *) s;
	return 0;
  80085d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80086e:	eb 03                	jmp    800873 <strfind+0xf>
  800870:	83 c0 01             	add    $0x1,%eax
  800873:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800876:	38 ca                	cmp    %cl,%dl
  800878:	74 04                	je     80087e <strfind+0x1a>
  80087a:	84 d2                	test   %dl,%dl
  80087c:	75 f2                	jne    800870 <strfind+0xc>
			break;
	return (char *) s;
}
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	57                   	push   %edi
  800884:	56                   	push   %esi
  800885:	53                   	push   %ebx
  800886:	8b 7d 08             	mov    0x8(%ebp),%edi
  800889:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80088c:	85 c9                	test   %ecx,%ecx
  80088e:	74 13                	je     8008a3 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800890:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800896:	75 05                	jne    80089d <memset+0x1d>
  800898:	f6 c1 03             	test   $0x3,%cl
  80089b:	74 0d                	je     8008aa <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80089d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a0:	fc                   	cld    
  8008a1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008a3:	89 f8                	mov    %edi,%eax
  8008a5:	5b                   	pop    %ebx
  8008a6:	5e                   	pop    %esi
  8008a7:	5f                   	pop    %edi
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    
		c &= 0xFF;
  8008aa:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008ae:	89 d3                	mov    %edx,%ebx
  8008b0:	c1 e3 08             	shl    $0x8,%ebx
  8008b3:	89 d0                	mov    %edx,%eax
  8008b5:	c1 e0 18             	shl    $0x18,%eax
  8008b8:	89 d6                	mov    %edx,%esi
  8008ba:	c1 e6 10             	shl    $0x10,%esi
  8008bd:	09 f0                	or     %esi,%eax
  8008bf:	09 c2                	or     %eax,%edx
  8008c1:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008c3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008c6:	89 d0                	mov    %edx,%eax
  8008c8:	fc                   	cld    
  8008c9:	f3 ab                	rep stos %eax,%es:(%edi)
  8008cb:	eb d6                	jmp    8008a3 <memset+0x23>

008008cd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	57                   	push   %edi
  8008d1:	56                   	push   %esi
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008db:	39 c6                	cmp    %eax,%esi
  8008dd:	73 35                	jae    800914 <memmove+0x47>
  8008df:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008e2:	39 c2                	cmp    %eax,%edx
  8008e4:	76 2e                	jbe    800914 <memmove+0x47>
		s += n;
		d += n;
  8008e6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008e9:	89 d6                	mov    %edx,%esi
  8008eb:	09 fe                	or     %edi,%esi
  8008ed:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008f3:	74 0c                	je     800901 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8008f5:	83 ef 01             	sub    $0x1,%edi
  8008f8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8008fb:	fd                   	std    
  8008fc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8008fe:	fc                   	cld    
  8008ff:	eb 21                	jmp    800922 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800901:	f6 c1 03             	test   $0x3,%cl
  800904:	75 ef                	jne    8008f5 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800906:	83 ef 04             	sub    $0x4,%edi
  800909:	8d 72 fc             	lea    -0x4(%edx),%esi
  80090c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80090f:	fd                   	std    
  800910:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800912:	eb ea                	jmp    8008fe <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800914:	89 f2                	mov    %esi,%edx
  800916:	09 c2                	or     %eax,%edx
  800918:	f6 c2 03             	test   $0x3,%dl
  80091b:	74 09                	je     800926 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80091d:	89 c7                	mov    %eax,%edi
  80091f:	fc                   	cld    
  800920:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800922:	5e                   	pop    %esi
  800923:	5f                   	pop    %edi
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800926:	f6 c1 03             	test   $0x3,%cl
  800929:	75 f2                	jne    80091d <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80092b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80092e:	89 c7                	mov    %eax,%edi
  800930:	fc                   	cld    
  800931:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800933:	eb ed                	jmp    800922 <memmove+0x55>

00800935 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800938:	ff 75 10             	pushl  0x10(%ebp)
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	ff 75 08             	pushl  0x8(%ebp)
  800941:	e8 87 ff ff ff       	call   8008cd <memmove>
}
  800946:	c9                   	leave  
  800947:	c3                   	ret    

00800948 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	56                   	push   %esi
  80094c:	53                   	push   %ebx
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8b 55 0c             	mov    0xc(%ebp),%edx
  800953:	89 c6                	mov    %eax,%esi
  800955:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800958:	39 f0                	cmp    %esi,%eax
  80095a:	74 1c                	je     800978 <memcmp+0x30>
		if (*s1 != *s2)
  80095c:	0f b6 08             	movzbl (%eax),%ecx
  80095f:	0f b6 1a             	movzbl (%edx),%ebx
  800962:	38 d9                	cmp    %bl,%cl
  800964:	75 08                	jne    80096e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800966:	83 c0 01             	add    $0x1,%eax
  800969:	83 c2 01             	add    $0x1,%edx
  80096c:	eb ea                	jmp    800958 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80096e:	0f b6 c1             	movzbl %cl,%eax
  800971:	0f b6 db             	movzbl %bl,%ebx
  800974:	29 d8                	sub    %ebx,%eax
  800976:	eb 05                	jmp    80097d <memcmp+0x35>
	}

	return 0;
  800978:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80097d:	5b                   	pop    %ebx
  80097e:	5e                   	pop    %esi
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80098a:	89 c2                	mov    %eax,%edx
  80098c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80098f:	39 d0                	cmp    %edx,%eax
  800991:	73 09                	jae    80099c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800993:	38 08                	cmp    %cl,(%eax)
  800995:	74 05                	je     80099c <memfind+0x1b>
	for (; s < ends; s++)
  800997:	83 c0 01             	add    $0x1,%eax
  80099a:	eb f3                	jmp    80098f <memfind+0xe>
			break;
	return (void *) s;
}
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    

0080099e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	57                   	push   %edi
  8009a2:	56                   	push   %esi
  8009a3:	53                   	push   %ebx
  8009a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009aa:	eb 03                	jmp    8009af <strtol+0x11>
		s++;
  8009ac:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009af:	0f b6 01             	movzbl (%ecx),%eax
  8009b2:	3c 20                	cmp    $0x20,%al
  8009b4:	74 f6                	je     8009ac <strtol+0xe>
  8009b6:	3c 09                	cmp    $0x9,%al
  8009b8:	74 f2                	je     8009ac <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009ba:	3c 2b                	cmp    $0x2b,%al
  8009bc:	74 2e                	je     8009ec <strtol+0x4e>
	int neg = 0;
  8009be:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009c3:	3c 2d                	cmp    $0x2d,%al
  8009c5:	74 2f                	je     8009f6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009c7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009cd:	75 05                	jne    8009d4 <strtol+0x36>
  8009cf:	80 39 30             	cmpb   $0x30,(%ecx)
  8009d2:	74 2c                	je     800a00 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009d4:	85 db                	test   %ebx,%ebx
  8009d6:	75 0a                	jne    8009e2 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009d8:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8009dd:	80 39 30             	cmpb   $0x30,(%ecx)
  8009e0:	74 28                	je     800a0a <strtol+0x6c>
		base = 10;
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009ea:	eb 50                	jmp    800a3c <strtol+0x9e>
		s++;
  8009ec:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8009f4:	eb d1                	jmp    8009c7 <strtol+0x29>
		s++, neg = 1;
  8009f6:	83 c1 01             	add    $0x1,%ecx
  8009f9:	bf 01 00 00 00       	mov    $0x1,%edi
  8009fe:	eb c7                	jmp    8009c7 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a00:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a04:	74 0e                	je     800a14 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a06:	85 db                	test   %ebx,%ebx
  800a08:	75 d8                	jne    8009e2 <strtol+0x44>
		s++, base = 8;
  800a0a:	83 c1 01             	add    $0x1,%ecx
  800a0d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a12:	eb ce                	jmp    8009e2 <strtol+0x44>
		s += 2, base = 16;
  800a14:	83 c1 02             	add    $0x2,%ecx
  800a17:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a1c:	eb c4                	jmp    8009e2 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a1e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a21:	89 f3                	mov    %esi,%ebx
  800a23:	80 fb 19             	cmp    $0x19,%bl
  800a26:	77 29                	ja     800a51 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a28:	0f be d2             	movsbl %dl,%edx
  800a2b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a2e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a31:	7d 30                	jge    800a63 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a33:	83 c1 01             	add    $0x1,%ecx
  800a36:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a3a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a3c:	0f b6 11             	movzbl (%ecx),%edx
  800a3f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a42:	89 f3                	mov    %esi,%ebx
  800a44:	80 fb 09             	cmp    $0x9,%bl
  800a47:	77 d5                	ja     800a1e <strtol+0x80>
			dig = *s - '0';
  800a49:	0f be d2             	movsbl %dl,%edx
  800a4c:	83 ea 30             	sub    $0x30,%edx
  800a4f:	eb dd                	jmp    800a2e <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a51:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a54:	89 f3                	mov    %esi,%ebx
  800a56:	80 fb 19             	cmp    $0x19,%bl
  800a59:	77 08                	ja     800a63 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a5b:	0f be d2             	movsbl %dl,%edx
  800a5e:	83 ea 37             	sub    $0x37,%edx
  800a61:	eb cb                	jmp    800a2e <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a67:	74 05                	je     800a6e <strtol+0xd0>
		*endptr = (char *) s;
  800a69:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a6e:	89 c2                	mov    %eax,%edx
  800a70:	f7 da                	neg    %edx
  800a72:	85 ff                	test   %edi,%edi
  800a74:	0f 45 c2             	cmovne %edx,%eax
}
  800a77:	5b                   	pop    %ebx
  800a78:	5e                   	pop    %esi
  800a79:	5f                   	pop    %edi
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	57                   	push   %edi
  800a80:	56                   	push   %esi
  800a81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a82:	b8 00 00 00 00       	mov    $0x0,%eax
  800a87:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a8d:	89 c3                	mov    %eax,%ebx
  800a8f:	89 c7                	mov    %eax,%edi
  800a91:	89 c6                	mov    %eax,%esi
  800a93:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800a95:	5b                   	pop    %ebx
  800a96:	5e                   	pop    %esi
  800a97:	5f                   	pop    %edi
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    

00800a9a <sys_cgetc>:

int
sys_cgetc(void)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	57                   	push   %edi
  800a9e:	56                   	push   %esi
  800a9f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aa0:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa5:	b8 01 00 00 00       	mov    $0x1,%eax
  800aaa:	89 d1                	mov    %edx,%ecx
  800aac:	89 d3                	mov    %edx,%ebx
  800aae:	89 d7                	mov    %edx,%edi
  800ab0:	89 d6                	mov    %edx,%esi
  800ab2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ab4:	5b                   	pop    %ebx
  800ab5:	5e                   	pop    %esi
  800ab6:	5f                   	pop    %edi
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	57                   	push   %edi
  800abd:	56                   	push   %esi
  800abe:	53                   	push   %ebx
  800abf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ac2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ac7:	8b 55 08             	mov    0x8(%ebp),%edx
  800aca:	b8 03 00 00 00       	mov    $0x3,%eax
  800acf:	89 cb                	mov    %ecx,%ebx
  800ad1:	89 cf                	mov    %ecx,%edi
  800ad3:	89 ce                	mov    %ecx,%esi
  800ad5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ad7:	85 c0                	test   %eax,%eax
  800ad9:	7f 08                	jg     800ae3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800adb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ade:	5b                   	pop    %ebx
  800adf:	5e                   	pop    %esi
  800ae0:	5f                   	pop    %edi
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ae3:	83 ec 0c             	sub    $0xc,%esp
  800ae6:	50                   	push   %eax
  800ae7:	6a 03                	push   $0x3
  800ae9:	68 3f 20 80 00       	push   $0x80203f
  800aee:	6a 23                	push   $0x23
  800af0:	68 5c 20 80 00       	push   $0x80205c
  800af5:	e8 ea 0e 00 00       	call   8019e4 <_panic>

00800afa <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	57                   	push   %edi
  800afe:	56                   	push   %esi
  800aff:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b00:	ba 00 00 00 00       	mov    $0x0,%edx
  800b05:	b8 02 00 00 00       	mov    $0x2,%eax
  800b0a:	89 d1                	mov    %edx,%ecx
  800b0c:	89 d3                	mov    %edx,%ebx
  800b0e:	89 d7                	mov    %edx,%edi
  800b10:	89 d6                	mov    %edx,%esi
  800b12:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b14:	5b                   	pop    %ebx
  800b15:	5e                   	pop    %esi
  800b16:	5f                   	pop    %edi
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <sys_yield>:

void
sys_yield(void)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	57                   	push   %edi
  800b1d:	56                   	push   %esi
  800b1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b24:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b29:	89 d1                	mov    %edx,%ecx
  800b2b:	89 d3                	mov    %edx,%ebx
  800b2d:	89 d7                	mov    %edx,%edi
  800b2f:	89 d6                	mov    %edx,%esi
  800b31:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b33:	5b                   	pop    %ebx
  800b34:	5e                   	pop    %esi
  800b35:	5f                   	pop    %edi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	57                   	push   %edi
  800b3c:	56                   	push   %esi
  800b3d:	53                   	push   %ebx
  800b3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b41:	be 00 00 00 00       	mov    $0x0,%esi
  800b46:	8b 55 08             	mov    0x8(%ebp),%edx
  800b49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4c:	b8 04 00 00 00       	mov    $0x4,%eax
  800b51:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b54:	89 f7                	mov    %esi,%edi
  800b56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b58:	85 c0                	test   %eax,%eax
  800b5a:	7f 08                	jg     800b64 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b5f:	5b                   	pop    %ebx
  800b60:	5e                   	pop    %esi
  800b61:	5f                   	pop    %edi
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b64:	83 ec 0c             	sub    $0xc,%esp
  800b67:	50                   	push   %eax
  800b68:	6a 04                	push   $0x4
  800b6a:	68 3f 20 80 00       	push   $0x80203f
  800b6f:	6a 23                	push   $0x23
  800b71:	68 5c 20 80 00       	push   $0x80205c
  800b76:	e8 69 0e 00 00       	call   8019e4 <_panic>

00800b7b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	57                   	push   %edi
  800b7f:	56                   	push   %esi
  800b80:	53                   	push   %ebx
  800b81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b84:	8b 55 08             	mov    0x8(%ebp),%edx
  800b87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b8a:	b8 05 00 00 00       	mov    $0x5,%eax
  800b8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b92:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b95:	8b 75 18             	mov    0x18(%ebp),%esi
  800b98:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b9a:	85 c0                	test   %eax,%eax
  800b9c:	7f 08                	jg     800ba6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba1:	5b                   	pop    %ebx
  800ba2:	5e                   	pop    %esi
  800ba3:	5f                   	pop    %edi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba6:	83 ec 0c             	sub    $0xc,%esp
  800ba9:	50                   	push   %eax
  800baa:	6a 05                	push   $0x5
  800bac:	68 3f 20 80 00       	push   $0x80203f
  800bb1:	6a 23                	push   $0x23
  800bb3:	68 5c 20 80 00       	push   $0x80205c
  800bb8:	e8 27 0e 00 00       	call   8019e4 <_panic>

00800bbd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	57                   	push   %edi
  800bc1:	56                   	push   %esi
  800bc2:	53                   	push   %ebx
  800bc3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd1:	b8 06 00 00 00       	mov    $0x6,%eax
  800bd6:	89 df                	mov    %ebx,%edi
  800bd8:	89 de                	mov    %ebx,%esi
  800bda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bdc:	85 c0                	test   %eax,%eax
  800bde:	7f 08                	jg     800be8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5f                   	pop    %edi
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be8:	83 ec 0c             	sub    $0xc,%esp
  800beb:	50                   	push   %eax
  800bec:	6a 06                	push   $0x6
  800bee:	68 3f 20 80 00       	push   $0x80203f
  800bf3:	6a 23                	push   $0x23
  800bf5:	68 5c 20 80 00       	push   $0x80205c
  800bfa:	e8 e5 0d 00 00       	call   8019e4 <_panic>

00800bff <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	57                   	push   %edi
  800c03:	56                   	push   %esi
  800c04:	53                   	push   %ebx
  800c05:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c08:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c13:	b8 08 00 00 00       	mov    $0x8,%eax
  800c18:	89 df                	mov    %ebx,%edi
  800c1a:	89 de                	mov    %ebx,%esi
  800c1c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1e:	85 c0                	test   %eax,%eax
  800c20:	7f 08                	jg     800c2a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c25:	5b                   	pop    %ebx
  800c26:	5e                   	pop    %esi
  800c27:	5f                   	pop    %edi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2a:	83 ec 0c             	sub    $0xc,%esp
  800c2d:	50                   	push   %eax
  800c2e:	6a 08                	push   $0x8
  800c30:	68 3f 20 80 00       	push   $0x80203f
  800c35:	6a 23                	push   $0x23
  800c37:	68 5c 20 80 00       	push   $0x80205c
  800c3c:	e8 a3 0d 00 00       	call   8019e4 <_panic>

00800c41 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	57                   	push   %edi
  800c45:	56                   	push   %esi
  800c46:	53                   	push   %ebx
  800c47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c55:	b8 09 00 00 00       	mov    $0x9,%eax
  800c5a:	89 df                	mov    %ebx,%edi
  800c5c:	89 de                	mov    %ebx,%esi
  800c5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c60:	85 c0                	test   %eax,%eax
  800c62:	7f 08                	jg     800c6c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6c:	83 ec 0c             	sub    $0xc,%esp
  800c6f:	50                   	push   %eax
  800c70:	6a 09                	push   $0x9
  800c72:	68 3f 20 80 00       	push   $0x80203f
  800c77:	6a 23                	push   $0x23
  800c79:	68 5c 20 80 00       	push   $0x80205c
  800c7e:	e8 61 0d 00 00       	call   8019e4 <_panic>

00800c83 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
  800c89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c91:	8b 55 08             	mov    0x8(%ebp),%edx
  800c94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c97:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c9c:	89 df                	mov    %ebx,%edi
  800c9e:	89 de                	mov    %ebx,%esi
  800ca0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca2:	85 c0                	test   %eax,%eax
  800ca4:	7f 08                	jg     800cae <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca9:	5b                   	pop    %ebx
  800caa:	5e                   	pop    %esi
  800cab:	5f                   	pop    %edi
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cae:	83 ec 0c             	sub    $0xc,%esp
  800cb1:	50                   	push   %eax
  800cb2:	6a 0a                	push   $0xa
  800cb4:	68 3f 20 80 00       	push   $0x80203f
  800cb9:	6a 23                	push   $0x23
  800cbb:	68 5c 20 80 00       	push   $0x80205c
  800cc0:	e8 1f 0d 00 00       	call   8019e4 <_panic>

00800cc5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cd6:	be 00 00 00 00       	mov    $0x0,%esi
  800cdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cde:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
  800cee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cfe:	89 cb                	mov    %ecx,%ebx
  800d00:	89 cf                	mov    %ecx,%edi
  800d02:	89 ce                	mov    %ecx,%esi
  800d04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7f 08                	jg     800d12 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d12:	83 ec 0c             	sub    $0xc,%esp
  800d15:	50                   	push   %eax
  800d16:	6a 0d                	push   $0xd
  800d18:	68 3f 20 80 00       	push   $0x80203f
  800d1d:	6a 23                	push   $0x23
  800d1f:	68 5c 20 80 00       	push   $0x80205c
  800d24:	e8 bb 0c 00 00       	call   8019e4 <_panic>

00800d29 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	05 00 00 00 30       	add    $0x30000000,%eax
  800d34:	c1 e8 0c             	shr    $0xc,%eax
}
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d49:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d56:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d5b:	89 c2                	mov    %eax,%edx
  800d5d:	c1 ea 16             	shr    $0x16,%edx
  800d60:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d67:	f6 c2 01             	test   $0x1,%dl
  800d6a:	74 2a                	je     800d96 <fd_alloc+0x46>
  800d6c:	89 c2                	mov    %eax,%edx
  800d6e:	c1 ea 0c             	shr    $0xc,%edx
  800d71:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d78:	f6 c2 01             	test   $0x1,%dl
  800d7b:	74 19                	je     800d96 <fd_alloc+0x46>
  800d7d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800d82:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d87:	75 d2                	jne    800d5b <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d89:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800d8f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800d94:	eb 07                	jmp    800d9d <fd_alloc+0x4d>
			*fd_store = fd;
  800d96:	89 01                	mov    %eax,(%ecx)
			return 0;
  800d98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    

00800d9f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800da5:	83 f8 1f             	cmp    $0x1f,%eax
  800da8:	77 36                	ja     800de0 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800daa:	c1 e0 0c             	shl    $0xc,%eax
  800dad:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800db2:	89 c2                	mov    %eax,%edx
  800db4:	c1 ea 16             	shr    $0x16,%edx
  800db7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dbe:	f6 c2 01             	test   $0x1,%dl
  800dc1:	74 24                	je     800de7 <fd_lookup+0x48>
  800dc3:	89 c2                	mov    %eax,%edx
  800dc5:	c1 ea 0c             	shr    $0xc,%edx
  800dc8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dcf:	f6 c2 01             	test   $0x1,%dl
  800dd2:	74 1a                	je     800dee <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd7:	89 02                	mov    %eax,(%edx)
	return 0;
  800dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    
		return -E_INVAL;
  800de0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800de5:	eb f7                	jmp    800dde <fd_lookup+0x3f>
		return -E_INVAL;
  800de7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dec:	eb f0                	jmp    800dde <fd_lookup+0x3f>
  800dee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800df3:	eb e9                	jmp    800dde <fd_lookup+0x3f>

00800df5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 08             	sub    $0x8,%esp
  800dfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dfe:	ba e8 20 80 00       	mov    $0x8020e8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e03:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e08:	39 08                	cmp    %ecx,(%eax)
  800e0a:	74 33                	je     800e3f <dev_lookup+0x4a>
  800e0c:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800e0f:	8b 02                	mov    (%edx),%eax
  800e11:	85 c0                	test   %eax,%eax
  800e13:	75 f3                	jne    800e08 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e15:	a1 08 40 80 00       	mov    0x804008,%eax
  800e1a:	8b 40 48             	mov    0x48(%eax),%eax
  800e1d:	83 ec 04             	sub    $0x4,%esp
  800e20:	51                   	push   %ecx
  800e21:	50                   	push   %eax
  800e22:	68 6c 20 80 00       	push   $0x80206c
  800e27:	e8 29 f3 ff ff       	call   800155 <cprintf>
	*dev = 0;
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e35:	83 c4 10             	add    $0x10,%esp
  800e38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e3d:	c9                   	leave  
  800e3e:	c3                   	ret    
			*dev = devtab[i];
  800e3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e42:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e44:	b8 00 00 00 00       	mov    $0x0,%eax
  800e49:	eb f2                	jmp    800e3d <dev_lookup+0x48>

00800e4b <fd_close>:
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
  800e51:	83 ec 1c             	sub    $0x1c,%esp
  800e54:	8b 75 08             	mov    0x8(%ebp),%esi
  800e57:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e5a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e5d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e5e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800e64:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e67:	50                   	push   %eax
  800e68:	e8 32 ff ff ff       	call   800d9f <fd_lookup>
  800e6d:	89 c3                	mov    %eax,%ebx
  800e6f:	83 c4 08             	add    $0x8,%esp
  800e72:	85 c0                	test   %eax,%eax
  800e74:	78 05                	js     800e7b <fd_close+0x30>
	    || fd != fd2)
  800e76:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800e79:	74 16                	je     800e91 <fd_close+0x46>
		return (must_exist ? r : 0);
  800e7b:	89 f8                	mov    %edi,%eax
  800e7d:	84 c0                	test   %al,%al
  800e7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e84:	0f 44 d8             	cmove  %eax,%ebx
}
  800e87:	89 d8                	mov    %ebx,%eax
  800e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8c:	5b                   	pop    %ebx
  800e8d:	5e                   	pop    %esi
  800e8e:	5f                   	pop    %edi
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e91:	83 ec 08             	sub    $0x8,%esp
  800e94:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800e97:	50                   	push   %eax
  800e98:	ff 36                	pushl  (%esi)
  800e9a:	e8 56 ff ff ff       	call   800df5 <dev_lookup>
  800e9f:	89 c3                	mov    %eax,%ebx
  800ea1:	83 c4 10             	add    $0x10,%esp
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	78 15                	js     800ebd <fd_close+0x72>
		if (dev->dev_close)
  800ea8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eab:	8b 40 10             	mov    0x10(%eax),%eax
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	74 1b                	je     800ecd <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	56                   	push   %esi
  800eb6:	ff d0                	call   *%eax
  800eb8:	89 c3                	mov    %eax,%ebx
  800eba:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800ebd:	83 ec 08             	sub    $0x8,%esp
  800ec0:	56                   	push   %esi
  800ec1:	6a 00                	push   $0x0
  800ec3:	e8 f5 fc ff ff       	call   800bbd <sys_page_unmap>
	return r;
  800ec8:	83 c4 10             	add    $0x10,%esp
  800ecb:	eb ba                	jmp    800e87 <fd_close+0x3c>
			r = 0;
  800ecd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed2:	eb e9                	jmp    800ebd <fd_close+0x72>

00800ed4 <close>:

int
close(int fdnum)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800eda:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800edd:	50                   	push   %eax
  800ede:	ff 75 08             	pushl  0x8(%ebp)
  800ee1:	e8 b9 fe ff ff       	call   800d9f <fd_lookup>
  800ee6:	83 c4 08             	add    $0x8,%esp
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	78 10                	js     800efd <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800eed:	83 ec 08             	sub    $0x8,%esp
  800ef0:	6a 01                	push   $0x1
  800ef2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef5:	e8 51 ff ff ff       	call   800e4b <fd_close>
  800efa:	83 c4 10             	add    $0x10,%esp
}
  800efd:	c9                   	leave  
  800efe:	c3                   	ret    

00800eff <close_all>:

void
close_all(void)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	53                   	push   %ebx
  800f03:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f06:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f0b:	83 ec 0c             	sub    $0xc,%esp
  800f0e:	53                   	push   %ebx
  800f0f:	e8 c0 ff ff ff       	call   800ed4 <close>
	for (i = 0; i < MAXFD; i++)
  800f14:	83 c3 01             	add    $0x1,%ebx
  800f17:	83 c4 10             	add    $0x10,%esp
  800f1a:	83 fb 20             	cmp    $0x20,%ebx
  800f1d:	75 ec                	jne    800f0b <close_all+0xc>
}
  800f1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f22:	c9                   	leave  
  800f23:	c3                   	ret    

00800f24 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	57                   	push   %edi
  800f28:	56                   	push   %esi
  800f29:	53                   	push   %ebx
  800f2a:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f2d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f30:	50                   	push   %eax
  800f31:	ff 75 08             	pushl  0x8(%ebp)
  800f34:	e8 66 fe ff ff       	call   800d9f <fd_lookup>
  800f39:	89 c3                	mov    %eax,%ebx
  800f3b:	83 c4 08             	add    $0x8,%esp
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	0f 88 81 00 00 00    	js     800fc7 <dup+0xa3>
		return r;
	close(newfdnum);
  800f46:	83 ec 0c             	sub    $0xc,%esp
  800f49:	ff 75 0c             	pushl  0xc(%ebp)
  800f4c:	e8 83 ff ff ff       	call   800ed4 <close>

	newfd = INDEX2FD(newfdnum);
  800f51:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f54:	c1 e6 0c             	shl    $0xc,%esi
  800f57:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f5d:	83 c4 04             	add    $0x4,%esp
  800f60:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f63:	e8 d1 fd ff ff       	call   800d39 <fd2data>
  800f68:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f6a:	89 34 24             	mov    %esi,(%esp)
  800f6d:	e8 c7 fd ff ff       	call   800d39 <fd2data>
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f77:	89 d8                	mov    %ebx,%eax
  800f79:	c1 e8 16             	shr    $0x16,%eax
  800f7c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f83:	a8 01                	test   $0x1,%al
  800f85:	74 11                	je     800f98 <dup+0x74>
  800f87:	89 d8                	mov    %ebx,%eax
  800f89:	c1 e8 0c             	shr    $0xc,%eax
  800f8c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f93:	f6 c2 01             	test   $0x1,%dl
  800f96:	75 39                	jne    800fd1 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800f98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f9b:	89 d0                	mov    %edx,%eax
  800f9d:	c1 e8 0c             	shr    $0xc,%eax
  800fa0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fa7:	83 ec 0c             	sub    $0xc,%esp
  800faa:	25 07 0e 00 00       	and    $0xe07,%eax
  800faf:	50                   	push   %eax
  800fb0:	56                   	push   %esi
  800fb1:	6a 00                	push   $0x0
  800fb3:	52                   	push   %edx
  800fb4:	6a 00                	push   $0x0
  800fb6:	e8 c0 fb ff ff       	call   800b7b <sys_page_map>
  800fbb:	89 c3                	mov    %eax,%ebx
  800fbd:	83 c4 20             	add    $0x20,%esp
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	78 31                	js     800ff5 <dup+0xd1>
		goto err;

	return newfdnum;
  800fc4:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800fc7:	89 d8                	mov    %ebx,%eax
  800fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fd1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fd8:	83 ec 0c             	sub    $0xc,%esp
  800fdb:	25 07 0e 00 00       	and    $0xe07,%eax
  800fe0:	50                   	push   %eax
  800fe1:	57                   	push   %edi
  800fe2:	6a 00                	push   $0x0
  800fe4:	53                   	push   %ebx
  800fe5:	6a 00                	push   $0x0
  800fe7:	e8 8f fb ff ff       	call   800b7b <sys_page_map>
  800fec:	89 c3                	mov    %eax,%ebx
  800fee:	83 c4 20             	add    $0x20,%esp
  800ff1:	85 c0                	test   %eax,%eax
  800ff3:	79 a3                	jns    800f98 <dup+0x74>
	sys_page_unmap(0, newfd);
  800ff5:	83 ec 08             	sub    $0x8,%esp
  800ff8:	56                   	push   %esi
  800ff9:	6a 00                	push   $0x0
  800ffb:	e8 bd fb ff ff       	call   800bbd <sys_page_unmap>
	sys_page_unmap(0, nva);
  801000:	83 c4 08             	add    $0x8,%esp
  801003:	57                   	push   %edi
  801004:	6a 00                	push   $0x0
  801006:	e8 b2 fb ff ff       	call   800bbd <sys_page_unmap>
	return r;
  80100b:	83 c4 10             	add    $0x10,%esp
  80100e:	eb b7                	jmp    800fc7 <dup+0xa3>

00801010 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	53                   	push   %ebx
  801014:	83 ec 14             	sub    $0x14,%esp
  801017:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80101a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80101d:	50                   	push   %eax
  80101e:	53                   	push   %ebx
  80101f:	e8 7b fd ff ff       	call   800d9f <fd_lookup>
  801024:	83 c4 08             	add    $0x8,%esp
  801027:	85 c0                	test   %eax,%eax
  801029:	78 3f                	js     80106a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801031:	50                   	push   %eax
  801032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801035:	ff 30                	pushl  (%eax)
  801037:	e8 b9 fd ff ff       	call   800df5 <dev_lookup>
  80103c:	83 c4 10             	add    $0x10,%esp
  80103f:	85 c0                	test   %eax,%eax
  801041:	78 27                	js     80106a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801043:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801046:	8b 42 08             	mov    0x8(%edx),%eax
  801049:	83 e0 03             	and    $0x3,%eax
  80104c:	83 f8 01             	cmp    $0x1,%eax
  80104f:	74 1e                	je     80106f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801054:	8b 40 08             	mov    0x8(%eax),%eax
  801057:	85 c0                	test   %eax,%eax
  801059:	74 35                	je     801090 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80105b:	83 ec 04             	sub    $0x4,%esp
  80105e:	ff 75 10             	pushl  0x10(%ebp)
  801061:	ff 75 0c             	pushl  0xc(%ebp)
  801064:	52                   	push   %edx
  801065:	ff d0                	call   *%eax
  801067:	83 c4 10             	add    $0x10,%esp
}
  80106a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80106d:	c9                   	leave  
  80106e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80106f:	a1 08 40 80 00       	mov    0x804008,%eax
  801074:	8b 40 48             	mov    0x48(%eax),%eax
  801077:	83 ec 04             	sub    $0x4,%esp
  80107a:	53                   	push   %ebx
  80107b:	50                   	push   %eax
  80107c:	68 ad 20 80 00       	push   $0x8020ad
  801081:	e8 cf f0 ff ff       	call   800155 <cprintf>
		return -E_INVAL;
  801086:	83 c4 10             	add    $0x10,%esp
  801089:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80108e:	eb da                	jmp    80106a <read+0x5a>
		return -E_NOT_SUPP;
  801090:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801095:	eb d3                	jmp    80106a <read+0x5a>

00801097 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	57                   	push   %edi
  80109b:	56                   	push   %esi
  80109c:	53                   	push   %ebx
  80109d:	83 ec 0c             	sub    $0xc,%esp
  8010a0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010a3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ab:	39 f3                	cmp    %esi,%ebx
  8010ad:	73 25                	jae    8010d4 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010af:	83 ec 04             	sub    $0x4,%esp
  8010b2:	89 f0                	mov    %esi,%eax
  8010b4:	29 d8                	sub    %ebx,%eax
  8010b6:	50                   	push   %eax
  8010b7:	89 d8                	mov    %ebx,%eax
  8010b9:	03 45 0c             	add    0xc(%ebp),%eax
  8010bc:	50                   	push   %eax
  8010bd:	57                   	push   %edi
  8010be:	e8 4d ff ff ff       	call   801010 <read>
		if (m < 0)
  8010c3:	83 c4 10             	add    $0x10,%esp
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	78 08                	js     8010d2 <readn+0x3b>
			return m;
		if (m == 0)
  8010ca:	85 c0                	test   %eax,%eax
  8010cc:	74 06                	je     8010d4 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8010ce:	01 c3                	add    %eax,%ebx
  8010d0:	eb d9                	jmp    8010ab <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010d2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8010d4:	89 d8                	mov    %ebx,%eax
  8010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d9:	5b                   	pop    %ebx
  8010da:	5e                   	pop    %esi
  8010db:	5f                   	pop    %edi
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    

008010de <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	53                   	push   %ebx
  8010e2:	83 ec 14             	sub    $0x14,%esp
  8010e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010eb:	50                   	push   %eax
  8010ec:	53                   	push   %ebx
  8010ed:	e8 ad fc ff ff       	call   800d9f <fd_lookup>
  8010f2:	83 c4 08             	add    $0x8,%esp
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	78 3a                	js     801133 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010f9:	83 ec 08             	sub    $0x8,%esp
  8010fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ff:	50                   	push   %eax
  801100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801103:	ff 30                	pushl  (%eax)
  801105:	e8 eb fc ff ff       	call   800df5 <dev_lookup>
  80110a:	83 c4 10             	add    $0x10,%esp
  80110d:	85 c0                	test   %eax,%eax
  80110f:	78 22                	js     801133 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801114:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801118:	74 1e                	je     801138 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	8b 52 0c             	mov    0xc(%edx),%edx
  801120:	85 d2                	test   %edx,%edx
  801122:	74 35                	je     801159 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801124:	83 ec 04             	sub    $0x4,%esp
  801127:	ff 75 10             	pushl  0x10(%ebp)
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	50                   	push   %eax
  80112e:	ff d2                	call   *%edx
  801130:	83 c4 10             	add    $0x10,%esp
}
  801133:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801136:	c9                   	leave  
  801137:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801138:	a1 08 40 80 00       	mov    0x804008,%eax
  80113d:	8b 40 48             	mov    0x48(%eax),%eax
  801140:	83 ec 04             	sub    $0x4,%esp
  801143:	53                   	push   %ebx
  801144:	50                   	push   %eax
  801145:	68 c9 20 80 00       	push   $0x8020c9
  80114a:	e8 06 f0 ff ff       	call   800155 <cprintf>
		return -E_INVAL;
  80114f:	83 c4 10             	add    $0x10,%esp
  801152:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801157:	eb da                	jmp    801133 <write+0x55>
		return -E_NOT_SUPP;
  801159:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80115e:	eb d3                	jmp    801133 <write+0x55>

00801160 <seek>:

int
seek(int fdnum, off_t offset)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801166:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801169:	50                   	push   %eax
  80116a:	ff 75 08             	pushl  0x8(%ebp)
  80116d:	e8 2d fc ff ff       	call   800d9f <fd_lookup>
  801172:	83 c4 08             	add    $0x8,%esp
  801175:	85 c0                	test   %eax,%eax
  801177:	78 0e                	js     801187 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801182:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801187:	c9                   	leave  
  801188:	c3                   	ret    

00801189 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	53                   	push   %ebx
  80118d:	83 ec 14             	sub    $0x14,%esp
  801190:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801193:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801196:	50                   	push   %eax
  801197:	53                   	push   %ebx
  801198:	e8 02 fc ff ff       	call   800d9f <fd_lookup>
  80119d:	83 c4 08             	add    $0x8,%esp
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	78 37                	js     8011db <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011a4:	83 ec 08             	sub    $0x8,%esp
  8011a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011aa:	50                   	push   %eax
  8011ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ae:	ff 30                	pushl  (%eax)
  8011b0:	e8 40 fc ff ff       	call   800df5 <dev_lookup>
  8011b5:	83 c4 10             	add    $0x10,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	78 1f                	js     8011db <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bf:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011c3:	74 1b                	je     8011e0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8011c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c8:	8b 52 18             	mov    0x18(%edx),%edx
  8011cb:	85 d2                	test   %edx,%edx
  8011cd:	74 32                	je     801201 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8011cf:	83 ec 08             	sub    $0x8,%esp
  8011d2:	ff 75 0c             	pushl  0xc(%ebp)
  8011d5:	50                   	push   %eax
  8011d6:	ff d2                	call   *%edx
  8011d8:	83 c4 10             	add    $0x10,%esp
}
  8011db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    
			thisenv->env_id, fdnum);
  8011e0:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011e5:	8b 40 48             	mov    0x48(%eax),%eax
  8011e8:	83 ec 04             	sub    $0x4,%esp
  8011eb:	53                   	push   %ebx
  8011ec:	50                   	push   %eax
  8011ed:	68 8c 20 80 00       	push   $0x80208c
  8011f2:	e8 5e ef ff ff       	call   800155 <cprintf>
		return -E_INVAL;
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ff:	eb da                	jmp    8011db <ftruncate+0x52>
		return -E_NOT_SUPP;
  801201:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801206:	eb d3                	jmp    8011db <ftruncate+0x52>

00801208 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	53                   	push   %ebx
  80120c:	83 ec 14             	sub    $0x14,%esp
  80120f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801212:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801215:	50                   	push   %eax
  801216:	ff 75 08             	pushl  0x8(%ebp)
  801219:	e8 81 fb ff ff       	call   800d9f <fd_lookup>
  80121e:	83 c4 08             	add    $0x8,%esp
  801221:	85 c0                	test   %eax,%eax
  801223:	78 4b                	js     801270 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801225:	83 ec 08             	sub    $0x8,%esp
  801228:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80122b:	50                   	push   %eax
  80122c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122f:	ff 30                	pushl  (%eax)
  801231:	e8 bf fb ff ff       	call   800df5 <dev_lookup>
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	85 c0                	test   %eax,%eax
  80123b:	78 33                	js     801270 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80123d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801240:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801244:	74 2f                	je     801275 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801246:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801249:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801250:	00 00 00 
	stat->st_isdir = 0;
  801253:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80125a:	00 00 00 
	stat->st_dev = dev;
  80125d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801263:	83 ec 08             	sub    $0x8,%esp
  801266:	53                   	push   %ebx
  801267:	ff 75 f0             	pushl  -0x10(%ebp)
  80126a:	ff 50 14             	call   *0x14(%eax)
  80126d:	83 c4 10             	add    $0x10,%esp
}
  801270:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801273:	c9                   	leave  
  801274:	c3                   	ret    
		return -E_NOT_SUPP;
  801275:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80127a:	eb f4                	jmp    801270 <fstat+0x68>

0080127c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	56                   	push   %esi
  801280:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801281:	83 ec 08             	sub    $0x8,%esp
  801284:	6a 00                	push   $0x0
  801286:	ff 75 08             	pushl  0x8(%ebp)
  801289:	e8 e7 01 00 00       	call   801475 <open>
  80128e:	89 c3                	mov    %eax,%ebx
  801290:	83 c4 10             	add    $0x10,%esp
  801293:	85 c0                	test   %eax,%eax
  801295:	78 1b                	js     8012b2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801297:	83 ec 08             	sub    $0x8,%esp
  80129a:	ff 75 0c             	pushl  0xc(%ebp)
  80129d:	50                   	push   %eax
  80129e:	e8 65 ff ff ff       	call   801208 <fstat>
  8012a3:	89 c6                	mov    %eax,%esi
	close(fd);
  8012a5:	89 1c 24             	mov    %ebx,(%esp)
  8012a8:	e8 27 fc ff ff       	call   800ed4 <close>
	return r;
  8012ad:	83 c4 10             	add    $0x10,%esp
  8012b0:	89 f3                	mov    %esi,%ebx
}
  8012b2:	89 d8                	mov    %ebx,%eax
  8012b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b7:	5b                   	pop    %ebx
  8012b8:	5e                   	pop    %esi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    

008012bb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	56                   	push   %esi
  8012bf:	53                   	push   %ebx
  8012c0:	89 c6                	mov    %eax,%esi
  8012c2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8012c4:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012cb:	74 27                	je     8012f4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012cd:	6a 07                	push   $0x7
  8012cf:	68 00 50 80 00       	push   $0x805000
  8012d4:	56                   	push   %esi
  8012d5:	ff 35 00 40 80 00    	pushl  0x804000
  8012db:	e8 61 07 00 00       	call   801a41 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012e0:	83 c4 0c             	add    $0xc,%esp
  8012e3:	6a 00                	push   $0x0
  8012e5:	53                   	push   %ebx
  8012e6:	6a 00                	push   $0x0
  8012e8:	e8 3d 07 00 00       	call   801a2a <ipc_recv>
}
  8012ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012f0:	5b                   	pop    %ebx
  8012f1:	5e                   	pop    %esi
  8012f2:	5d                   	pop    %ebp
  8012f3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8012f4:	83 ec 0c             	sub    $0xc,%esp
  8012f7:	6a 01                	push   $0x1
  8012f9:	e8 5a 07 00 00       	call   801a58 <ipc_find_env>
  8012fe:	a3 00 40 80 00       	mov    %eax,0x804000
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	eb c5                	jmp    8012cd <fsipc+0x12>

00801308 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8b 40 0c             	mov    0xc(%eax),%eax
  801314:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801321:	ba 00 00 00 00       	mov    $0x0,%edx
  801326:	b8 02 00 00 00       	mov    $0x2,%eax
  80132b:	e8 8b ff ff ff       	call   8012bb <fsipc>
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <devfile_flush>:
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8b 40 0c             	mov    0xc(%eax),%eax
  80133e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801343:	ba 00 00 00 00       	mov    $0x0,%edx
  801348:	b8 06 00 00 00       	mov    $0x6,%eax
  80134d:	e8 69 ff ff ff       	call   8012bb <fsipc>
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <devfile_stat>:
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	53                   	push   %ebx
  801358:	83 ec 04             	sub    $0x4,%esp
  80135b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8b 40 0c             	mov    0xc(%eax),%eax
  801364:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801369:	ba 00 00 00 00       	mov    $0x0,%edx
  80136e:	b8 05 00 00 00       	mov    $0x5,%eax
  801373:	e8 43 ff ff ff       	call   8012bb <fsipc>
  801378:	85 c0                	test   %eax,%eax
  80137a:	78 2c                	js     8013a8 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80137c:	83 ec 08             	sub    $0x8,%esp
  80137f:	68 00 50 80 00       	push   $0x805000
  801384:	53                   	push   %ebx
  801385:	e8 b5 f3 ff ff       	call   80073f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80138a:	a1 80 50 80 00       	mov    0x805080,%eax
  80138f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801395:	a1 84 50 80 00       	mov    0x805084,%eax
  80139a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <devfile_write>:
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	83 ec 0c             	sub    $0xc,%esp
  8013b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b6:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8013bb:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8013c0:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c6:	8b 52 0c             	mov    0xc(%edx),%edx
  8013c9:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8013cf:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8013d4:	50                   	push   %eax
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	68 08 50 80 00       	push   $0x805008
  8013dd:	e8 eb f4 ff ff       	call   8008cd <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8013e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e7:	b8 04 00 00 00       	mov    $0x4,%eax
  8013ec:	e8 ca fe ff ff       	call   8012bb <fsipc>
}
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <devfile_read>:
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	56                   	push   %esi
  8013f7:	53                   	push   %ebx
  8013f8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8b 40 0c             	mov    0xc(%eax),%eax
  801401:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801406:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80140c:	ba 00 00 00 00       	mov    $0x0,%edx
  801411:	b8 03 00 00 00       	mov    $0x3,%eax
  801416:	e8 a0 fe ff ff       	call   8012bb <fsipc>
  80141b:	89 c3                	mov    %eax,%ebx
  80141d:	85 c0                	test   %eax,%eax
  80141f:	78 1f                	js     801440 <devfile_read+0x4d>
	assert(r <= n);
  801421:	39 f0                	cmp    %esi,%eax
  801423:	77 24                	ja     801449 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801425:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80142a:	7f 33                	jg     80145f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	50                   	push   %eax
  801430:	68 00 50 80 00       	push   $0x805000
  801435:	ff 75 0c             	pushl  0xc(%ebp)
  801438:	e8 90 f4 ff ff       	call   8008cd <memmove>
	return r;
  80143d:	83 c4 10             	add    $0x10,%esp
}
  801440:	89 d8                	mov    %ebx,%eax
  801442:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801445:	5b                   	pop    %ebx
  801446:	5e                   	pop    %esi
  801447:	5d                   	pop    %ebp
  801448:	c3                   	ret    
	assert(r <= n);
  801449:	68 f8 20 80 00       	push   $0x8020f8
  80144e:	68 ff 20 80 00       	push   $0x8020ff
  801453:	6a 7c                	push   $0x7c
  801455:	68 14 21 80 00       	push   $0x802114
  80145a:	e8 85 05 00 00       	call   8019e4 <_panic>
	assert(r <= PGSIZE);
  80145f:	68 1f 21 80 00       	push   $0x80211f
  801464:	68 ff 20 80 00       	push   $0x8020ff
  801469:	6a 7d                	push   $0x7d
  80146b:	68 14 21 80 00       	push   $0x802114
  801470:	e8 6f 05 00 00       	call   8019e4 <_panic>

00801475 <open>:
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	56                   	push   %esi
  801479:	53                   	push   %ebx
  80147a:	83 ec 1c             	sub    $0x1c,%esp
  80147d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801480:	56                   	push   %esi
  801481:	e8 82 f2 ff ff       	call   800708 <strlen>
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80148e:	7f 6c                	jg     8014fc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801490:	83 ec 0c             	sub    $0xc,%esp
  801493:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801496:	50                   	push   %eax
  801497:	e8 b4 f8 ff ff       	call   800d50 <fd_alloc>
  80149c:	89 c3                	mov    %eax,%ebx
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	78 3c                	js     8014e1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8014a5:	83 ec 08             	sub    $0x8,%esp
  8014a8:	56                   	push   %esi
  8014a9:	68 00 50 80 00       	push   $0x805000
  8014ae:	e8 8c f2 ff ff       	call   80073f <strcpy>
	fsipcbuf.open.req_omode = mode;
  8014b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b6:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8014bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014be:	b8 01 00 00 00       	mov    $0x1,%eax
  8014c3:	e8 f3 fd ff ff       	call   8012bb <fsipc>
  8014c8:	89 c3                	mov    %eax,%ebx
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	78 19                	js     8014ea <open+0x75>
	return fd2num(fd);
  8014d1:	83 ec 0c             	sub    $0xc,%esp
  8014d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d7:	e8 4d f8 ff ff       	call   800d29 <fd2num>
  8014dc:	89 c3                	mov    %eax,%ebx
  8014de:	83 c4 10             	add    $0x10,%esp
}
  8014e1:	89 d8                	mov    %ebx,%eax
  8014e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e6:	5b                   	pop    %ebx
  8014e7:	5e                   	pop    %esi
  8014e8:	5d                   	pop    %ebp
  8014e9:	c3                   	ret    
		fd_close(fd, 0);
  8014ea:	83 ec 08             	sub    $0x8,%esp
  8014ed:	6a 00                	push   $0x0
  8014ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f2:	e8 54 f9 ff ff       	call   800e4b <fd_close>
		return r;
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	eb e5                	jmp    8014e1 <open+0x6c>
		return -E_BAD_PATH;
  8014fc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801501:	eb de                	jmp    8014e1 <open+0x6c>

00801503 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801509:	ba 00 00 00 00       	mov    $0x0,%edx
  80150e:	b8 08 00 00 00       	mov    $0x8,%eax
  801513:	e8 a3 fd ff ff       	call   8012bb <fsipc>
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	56                   	push   %esi
  80151e:	53                   	push   %ebx
  80151f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801522:	83 ec 0c             	sub    $0xc,%esp
  801525:	ff 75 08             	pushl  0x8(%ebp)
  801528:	e8 0c f8 ff ff       	call   800d39 <fd2data>
  80152d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80152f:	83 c4 08             	add    $0x8,%esp
  801532:	68 2b 21 80 00       	push   $0x80212b
  801537:	53                   	push   %ebx
  801538:	e8 02 f2 ff ff       	call   80073f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80153d:	8b 46 04             	mov    0x4(%esi),%eax
  801540:	2b 06                	sub    (%esi),%eax
  801542:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801548:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80154f:	00 00 00 
	stat->st_dev = &devpipe;
  801552:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801559:	30 80 00 
	return 0;
}
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
  801561:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801564:	5b                   	pop    %ebx
  801565:	5e                   	pop    %esi
  801566:	5d                   	pop    %ebp
  801567:	c3                   	ret    

00801568 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	53                   	push   %ebx
  80156c:	83 ec 0c             	sub    $0xc,%esp
  80156f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801572:	53                   	push   %ebx
  801573:	6a 00                	push   $0x0
  801575:	e8 43 f6 ff ff       	call   800bbd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80157a:	89 1c 24             	mov    %ebx,(%esp)
  80157d:	e8 b7 f7 ff ff       	call   800d39 <fd2data>
  801582:	83 c4 08             	add    $0x8,%esp
  801585:	50                   	push   %eax
  801586:	6a 00                	push   $0x0
  801588:	e8 30 f6 ff ff       	call   800bbd <sys_page_unmap>
}
  80158d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <_pipeisclosed>:
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	57                   	push   %edi
  801596:	56                   	push   %esi
  801597:	53                   	push   %ebx
  801598:	83 ec 1c             	sub    $0x1c,%esp
  80159b:	89 c7                	mov    %eax,%edi
  80159d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80159f:	a1 08 40 80 00       	mov    0x804008,%eax
  8015a4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8015a7:	83 ec 0c             	sub    $0xc,%esp
  8015aa:	57                   	push   %edi
  8015ab:	e8 e1 04 00 00       	call   801a91 <pageref>
  8015b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015b3:	89 34 24             	mov    %esi,(%esp)
  8015b6:	e8 d6 04 00 00       	call   801a91 <pageref>
		nn = thisenv->env_runs;
  8015bb:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8015c1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8015c4:	83 c4 10             	add    $0x10,%esp
  8015c7:	39 cb                	cmp    %ecx,%ebx
  8015c9:	74 1b                	je     8015e6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8015cb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015ce:	75 cf                	jne    80159f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8015d0:	8b 42 58             	mov    0x58(%edx),%eax
  8015d3:	6a 01                	push   $0x1
  8015d5:	50                   	push   %eax
  8015d6:	53                   	push   %ebx
  8015d7:	68 32 21 80 00       	push   $0x802132
  8015dc:	e8 74 eb ff ff       	call   800155 <cprintf>
  8015e1:	83 c4 10             	add    $0x10,%esp
  8015e4:	eb b9                	jmp    80159f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8015e6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015e9:	0f 94 c0             	sete   %al
  8015ec:	0f b6 c0             	movzbl %al,%eax
}
  8015ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f2:	5b                   	pop    %ebx
  8015f3:	5e                   	pop    %esi
  8015f4:	5f                   	pop    %edi
  8015f5:	5d                   	pop    %ebp
  8015f6:	c3                   	ret    

008015f7 <devpipe_write>:
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	57                   	push   %edi
  8015fb:	56                   	push   %esi
  8015fc:	53                   	push   %ebx
  8015fd:	83 ec 28             	sub    $0x28,%esp
  801600:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801603:	56                   	push   %esi
  801604:	e8 30 f7 ff ff       	call   800d39 <fd2data>
  801609:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	bf 00 00 00 00       	mov    $0x0,%edi
  801613:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801616:	74 4f                	je     801667 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801618:	8b 43 04             	mov    0x4(%ebx),%eax
  80161b:	8b 0b                	mov    (%ebx),%ecx
  80161d:	8d 51 20             	lea    0x20(%ecx),%edx
  801620:	39 d0                	cmp    %edx,%eax
  801622:	72 14                	jb     801638 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801624:	89 da                	mov    %ebx,%edx
  801626:	89 f0                	mov    %esi,%eax
  801628:	e8 65 ff ff ff       	call   801592 <_pipeisclosed>
  80162d:	85 c0                	test   %eax,%eax
  80162f:	75 3a                	jne    80166b <devpipe_write+0x74>
			sys_yield();
  801631:	e8 e3 f4 ff ff       	call   800b19 <sys_yield>
  801636:	eb e0                	jmp    801618 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801638:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80163b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80163f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801642:	89 c2                	mov    %eax,%edx
  801644:	c1 fa 1f             	sar    $0x1f,%edx
  801647:	89 d1                	mov    %edx,%ecx
  801649:	c1 e9 1b             	shr    $0x1b,%ecx
  80164c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80164f:	83 e2 1f             	and    $0x1f,%edx
  801652:	29 ca                	sub    %ecx,%edx
  801654:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801658:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80165c:	83 c0 01             	add    $0x1,%eax
  80165f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801662:	83 c7 01             	add    $0x1,%edi
  801665:	eb ac                	jmp    801613 <devpipe_write+0x1c>
	return i;
  801667:	89 f8                	mov    %edi,%eax
  801669:	eb 05                	jmp    801670 <devpipe_write+0x79>
				return 0;
  80166b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801670:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801673:	5b                   	pop    %ebx
  801674:	5e                   	pop    %esi
  801675:	5f                   	pop    %edi
  801676:	5d                   	pop    %ebp
  801677:	c3                   	ret    

00801678 <devpipe_read>:
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	57                   	push   %edi
  80167c:	56                   	push   %esi
  80167d:	53                   	push   %ebx
  80167e:	83 ec 18             	sub    $0x18,%esp
  801681:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801684:	57                   	push   %edi
  801685:	e8 af f6 ff ff       	call   800d39 <fd2data>
  80168a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	be 00 00 00 00       	mov    $0x0,%esi
  801694:	3b 75 10             	cmp    0x10(%ebp),%esi
  801697:	74 47                	je     8016e0 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801699:	8b 03                	mov    (%ebx),%eax
  80169b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80169e:	75 22                	jne    8016c2 <devpipe_read+0x4a>
			if (i > 0)
  8016a0:	85 f6                	test   %esi,%esi
  8016a2:	75 14                	jne    8016b8 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8016a4:	89 da                	mov    %ebx,%edx
  8016a6:	89 f8                	mov    %edi,%eax
  8016a8:	e8 e5 fe ff ff       	call   801592 <_pipeisclosed>
  8016ad:	85 c0                	test   %eax,%eax
  8016af:	75 33                	jne    8016e4 <devpipe_read+0x6c>
			sys_yield();
  8016b1:	e8 63 f4 ff ff       	call   800b19 <sys_yield>
  8016b6:	eb e1                	jmp    801699 <devpipe_read+0x21>
				return i;
  8016b8:	89 f0                	mov    %esi,%eax
}
  8016ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016bd:	5b                   	pop    %ebx
  8016be:	5e                   	pop    %esi
  8016bf:	5f                   	pop    %edi
  8016c0:	5d                   	pop    %ebp
  8016c1:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8016c2:	99                   	cltd   
  8016c3:	c1 ea 1b             	shr    $0x1b,%edx
  8016c6:	01 d0                	add    %edx,%eax
  8016c8:	83 e0 1f             	and    $0x1f,%eax
  8016cb:	29 d0                	sub    %edx,%eax
  8016cd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8016d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016d5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8016d8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8016db:	83 c6 01             	add    $0x1,%esi
  8016de:	eb b4                	jmp    801694 <devpipe_read+0x1c>
	return i;
  8016e0:	89 f0                	mov    %esi,%eax
  8016e2:	eb d6                	jmp    8016ba <devpipe_read+0x42>
				return 0;
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e9:	eb cf                	jmp    8016ba <devpipe_read+0x42>

008016eb <pipe>:
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	56                   	push   %esi
  8016ef:	53                   	push   %ebx
  8016f0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8016f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f6:	50                   	push   %eax
  8016f7:	e8 54 f6 ff ff       	call   800d50 <fd_alloc>
  8016fc:	89 c3                	mov    %eax,%ebx
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	85 c0                	test   %eax,%eax
  801703:	78 5b                	js     801760 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	68 07 04 00 00       	push   $0x407
  80170d:	ff 75 f4             	pushl  -0xc(%ebp)
  801710:	6a 00                	push   $0x0
  801712:	e8 21 f4 ff ff       	call   800b38 <sys_page_alloc>
  801717:	89 c3                	mov    %eax,%ebx
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	85 c0                	test   %eax,%eax
  80171e:	78 40                	js     801760 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801720:	83 ec 0c             	sub    $0xc,%esp
  801723:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801726:	50                   	push   %eax
  801727:	e8 24 f6 ff ff       	call   800d50 <fd_alloc>
  80172c:	89 c3                	mov    %eax,%ebx
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	85 c0                	test   %eax,%eax
  801733:	78 1b                	js     801750 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801735:	83 ec 04             	sub    $0x4,%esp
  801738:	68 07 04 00 00       	push   $0x407
  80173d:	ff 75 f0             	pushl  -0x10(%ebp)
  801740:	6a 00                	push   $0x0
  801742:	e8 f1 f3 ff ff       	call   800b38 <sys_page_alloc>
  801747:	89 c3                	mov    %eax,%ebx
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	85 c0                	test   %eax,%eax
  80174e:	79 19                	jns    801769 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801750:	83 ec 08             	sub    $0x8,%esp
  801753:	ff 75 f4             	pushl  -0xc(%ebp)
  801756:	6a 00                	push   $0x0
  801758:	e8 60 f4 ff ff       	call   800bbd <sys_page_unmap>
  80175d:	83 c4 10             	add    $0x10,%esp
}
  801760:	89 d8                	mov    %ebx,%eax
  801762:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801765:	5b                   	pop    %ebx
  801766:	5e                   	pop    %esi
  801767:	5d                   	pop    %ebp
  801768:	c3                   	ret    
	va = fd2data(fd0);
  801769:	83 ec 0c             	sub    $0xc,%esp
  80176c:	ff 75 f4             	pushl  -0xc(%ebp)
  80176f:	e8 c5 f5 ff ff       	call   800d39 <fd2data>
  801774:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801776:	83 c4 0c             	add    $0xc,%esp
  801779:	68 07 04 00 00       	push   $0x407
  80177e:	50                   	push   %eax
  80177f:	6a 00                	push   $0x0
  801781:	e8 b2 f3 ff ff       	call   800b38 <sys_page_alloc>
  801786:	89 c3                	mov    %eax,%ebx
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	85 c0                	test   %eax,%eax
  80178d:	0f 88 8c 00 00 00    	js     80181f <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801793:	83 ec 0c             	sub    $0xc,%esp
  801796:	ff 75 f0             	pushl  -0x10(%ebp)
  801799:	e8 9b f5 ff ff       	call   800d39 <fd2data>
  80179e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017a5:	50                   	push   %eax
  8017a6:	6a 00                	push   $0x0
  8017a8:	56                   	push   %esi
  8017a9:	6a 00                	push   $0x0
  8017ab:	e8 cb f3 ff ff       	call   800b7b <sys_page_map>
  8017b0:	89 c3                	mov    %eax,%ebx
  8017b2:	83 c4 20             	add    $0x20,%esp
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	78 58                	js     801811 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8017b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bc:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017c2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8017c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8017ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017d7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8017d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017dc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8017e3:	83 ec 0c             	sub    $0xc,%esp
  8017e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e9:	e8 3b f5 ff ff       	call   800d29 <fd2num>
  8017ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017f1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8017f3:	83 c4 04             	add    $0x4,%esp
  8017f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f9:	e8 2b f5 ff ff       	call   800d29 <fd2num>
  8017fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801801:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	bb 00 00 00 00       	mov    $0x0,%ebx
  80180c:	e9 4f ff ff ff       	jmp    801760 <pipe+0x75>
	sys_page_unmap(0, va);
  801811:	83 ec 08             	sub    $0x8,%esp
  801814:	56                   	push   %esi
  801815:	6a 00                	push   $0x0
  801817:	e8 a1 f3 ff ff       	call   800bbd <sys_page_unmap>
  80181c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80181f:	83 ec 08             	sub    $0x8,%esp
  801822:	ff 75 f0             	pushl  -0x10(%ebp)
  801825:	6a 00                	push   $0x0
  801827:	e8 91 f3 ff ff       	call   800bbd <sys_page_unmap>
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	e9 1c ff ff ff       	jmp    801750 <pipe+0x65>

00801834 <pipeisclosed>:
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80183a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183d:	50                   	push   %eax
  80183e:	ff 75 08             	pushl  0x8(%ebp)
  801841:	e8 59 f5 ff ff       	call   800d9f <fd_lookup>
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	85 c0                	test   %eax,%eax
  80184b:	78 18                	js     801865 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80184d:	83 ec 0c             	sub    $0xc,%esp
  801850:	ff 75 f4             	pushl  -0xc(%ebp)
  801853:	e8 e1 f4 ff ff       	call   800d39 <fd2data>
	return _pipeisclosed(fd, p);
  801858:	89 c2                	mov    %eax,%edx
  80185a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185d:	e8 30 fd ff ff       	call   801592 <_pipeisclosed>
  801862:	83 c4 10             	add    $0x10,%esp
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80186a:	b8 00 00 00 00       	mov    $0x0,%eax
  80186f:	5d                   	pop    %ebp
  801870:	c3                   	ret    

00801871 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801877:	68 4a 21 80 00       	push   $0x80214a
  80187c:	ff 75 0c             	pushl  0xc(%ebp)
  80187f:	e8 bb ee ff ff       	call   80073f <strcpy>
	return 0;
}
  801884:	b8 00 00 00 00       	mov    $0x0,%eax
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <devcons_write>:
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	57                   	push   %edi
  80188f:	56                   	push   %esi
  801890:	53                   	push   %ebx
  801891:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801897:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80189c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8018a2:	eb 2f                	jmp    8018d3 <devcons_write+0x48>
		m = n - tot;
  8018a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018a7:	29 f3                	sub    %esi,%ebx
  8018a9:	83 fb 7f             	cmp    $0x7f,%ebx
  8018ac:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8018b1:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	53                   	push   %ebx
  8018b8:	89 f0                	mov    %esi,%eax
  8018ba:	03 45 0c             	add    0xc(%ebp),%eax
  8018bd:	50                   	push   %eax
  8018be:	57                   	push   %edi
  8018bf:	e8 09 f0 ff ff       	call   8008cd <memmove>
		sys_cputs(buf, m);
  8018c4:	83 c4 08             	add    $0x8,%esp
  8018c7:	53                   	push   %ebx
  8018c8:	57                   	push   %edi
  8018c9:	e8 ae f1 ff ff       	call   800a7c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8018ce:	01 de                	add    %ebx,%esi
  8018d0:	83 c4 10             	add    $0x10,%esp
  8018d3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018d6:	72 cc                	jb     8018a4 <devcons_write+0x19>
}
  8018d8:	89 f0                	mov    %esi,%eax
  8018da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018dd:	5b                   	pop    %ebx
  8018de:	5e                   	pop    %esi
  8018df:	5f                   	pop    %edi
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    

008018e2 <devcons_read>:
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 08             	sub    $0x8,%esp
  8018e8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8018ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018f1:	75 07                	jne    8018fa <devcons_read+0x18>
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    
		sys_yield();
  8018f5:	e8 1f f2 ff ff       	call   800b19 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8018fa:	e8 9b f1 ff ff       	call   800a9a <sys_cgetc>
  8018ff:	85 c0                	test   %eax,%eax
  801901:	74 f2                	je     8018f5 <devcons_read+0x13>
	if (c < 0)
  801903:	85 c0                	test   %eax,%eax
  801905:	78 ec                	js     8018f3 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801907:	83 f8 04             	cmp    $0x4,%eax
  80190a:	74 0c                	je     801918 <devcons_read+0x36>
	*(char*)vbuf = c;
  80190c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190f:	88 02                	mov    %al,(%edx)
	return 1;
  801911:	b8 01 00 00 00       	mov    $0x1,%eax
  801916:	eb db                	jmp    8018f3 <devcons_read+0x11>
		return 0;
  801918:	b8 00 00 00 00       	mov    $0x0,%eax
  80191d:	eb d4                	jmp    8018f3 <devcons_read+0x11>

0080191f <cputchar>:
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80192b:	6a 01                	push   $0x1
  80192d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801930:	50                   	push   %eax
  801931:	e8 46 f1 ff ff       	call   800a7c <sys_cputs>
}
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <getchar>:
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801941:	6a 01                	push   $0x1
  801943:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801946:	50                   	push   %eax
  801947:	6a 00                	push   $0x0
  801949:	e8 c2 f6 ff ff       	call   801010 <read>
	if (r < 0)
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	85 c0                	test   %eax,%eax
  801953:	78 08                	js     80195d <getchar+0x22>
	if (r < 1)
  801955:	85 c0                	test   %eax,%eax
  801957:	7e 06                	jle    80195f <getchar+0x24>
	return c;
  801959:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    
		return -E_EOF;
  80195f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801964:	eb f7                	jmp    80195d <getchar+0x22>

00801966 <iscons>:
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80196c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196f:	50                   	push   %eax
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	e8 27 f4 ff ff       	call   800d9f <fd_lookup>
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	85 c0                	test   %eax,%eax
  80197d:	78 11                	js     801990 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80197f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801982:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801988:	39 10                	cmp    %edx,(%eax)
  80198a:	0f 94 c0             	sete   %al
  80198d:	0f b6 c0             	movzbl %al,%eax
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <opencons>:
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801998:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199b:	50                   	push   %eax
  80199c:	e8 af f3 ff ff       	call   800d50 <fd_alloc>
  8019a1:	83 c4 10             	add    $0x10,%esp
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 3a                	js     8019e2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019a8:	83 ec 04             	sub    $0x4,%esp
  8019ab:	68 07 04 00 00       	push   $0x407
  8019b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b3:	6a 00                	push   $0x0
  8019b5:	e8 7e f1 ff ff       	call   800b38 <sys_page_alloc>
  8019ba:	83 c4 10             	add    $0x10,%esp
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	78 21                	js     8019e2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8019c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019ca:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8019cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8019d6:	83 ec 0c             	sub    $0xc,%esp
  8019d9:	50                   	push   %eax
  8019da:	e8 4a f3 ff ff       	call   800d29 <fd2num>
  8019df:	83 c4 10             	add    $0x10,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	56                   	push   %esi
  8019e8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8019e9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8019ec:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8019f2:	e8 03 f1 ff ff       	call   800afa <sys_getenvid>
  8019f7:	83 ec 0c             	sub    $0xc,%esp
  8019fa:	ff 75 0c             	pushl  0xc(%ebp)
  8019fd:	ff 75 08             	pushl  0x8(%ebp)
  801a00:	56                   	push   %esi
  801a01:	50                   	push   %eax
  801a02:	68 58 21 80 00       	push   $0x802158
  801a07:	e8 49 e7 ff ff       	call   800155 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a0c:	83 c4 18             	add    $0x18,%esp
  801a0f:	53                   	push   %ebx
  801a10:	ff 75 10             	pushl  0x10(%ebp)
  801a13:	e8 ec e6 ff ff       	call   800104 <vcprintf>
	cprintf("\n");
  801a18:	c7 04 24 2c 1d 80 00 	movl   $0x801d2c,(%esp)
  801a1f:	e8 31 e7 ff ff       	call   800155 <cprintf>
  801a24:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a27:	cc                   	int3   
  801a28:	eb fd                	jmp    801a27 <_panic+0x43>

00801a2a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801a30:	68 7c 21 80 00       	push   $0x80217c
  801a35:	6a 1a                	push   $0x1a
  801a37:	68 95 21 80 00       	push   $0x802195
  801a3c:	e8 a3 ff ff ff       	call   8019e4 <_panic>

00801a41 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801a47:	68 9f 21 80 00       	push   $0x80219f
  801a4c:	6a 2a                	push   $0x2a
  801a4e:	68 95 21 80 00       	push   $0x802195
  801a53:	e8 8c ff ff ff       	call   8019e4 <_panic>

00801a58 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a5e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a63:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a66:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a6c:	8b 52 50             	mov    0x50(%edx),%edx
  801a6f:	39 ca                	cmp    %ecx,%edx
  801a71:	74 11                	je     801a84 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801a73:	83 c0 01             	add    $0x1,%eax
  801a76:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a7b:	75 e6                	jne    801a63 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a82:	eb 0b                	jmp    801a8f <ipc_find_env+0x37>
			return envs[i].env_id;
  801a84:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a87:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a8c:	8b 40 48             	mov    0x48(%eax),%eax
}
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    

00801a91 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801a97:	89 d0                	mov    %edx,%eax
  801a99:	c1 e8 16             	shr    $0x16,%eax
  801a9c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801aa3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801aa8:	f6 c1 01             	test   $0x1,%cl
  801aab:	74 1d                	je     801aca <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801aad:	c1 ea 0c             	shr    $0xc,%edx
  801ab0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ab7:	f6 c2 01             	test   $0x1,%dl
  801aba:	74 0e                	je     801aca <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801abc:	c1 ea 0c             	shr    $0xc,%edx
  801abf:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ac6:	ef 
  801ac7:	0f b7 c0             	movzwl %ax,%eax
}
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    
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
