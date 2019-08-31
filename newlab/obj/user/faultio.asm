
obj/user/faultio.debug：     文件格式 elf32-i386


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
  80002c:	e8 3e 00 00 00       	call   80006f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  800039:	9c                   	pushf  
  80003a:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80003b:	f6 c4 30             	test   $0x30,%ah
  80003e:	75 1d                	jne    80005d <umain+0x2a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800040:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800045:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80004a:	ee                   	out    %al,(%dx)

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

        cprintf("%s: made it here --- bug\n");
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	68 2e 1d 80 00       	push   $0x801d2e
  800053:	e8 0c 01 00 00       	call   800164 <cprintf>
}
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    
		cprintf("eflags wrong\n");
  80005d:	83 ec 0c             	sub    $0xc,%esp
  800060:	68 20 1d 80 00       	push   $0x801d20
  800065:	e8 fa 00 00 00       	call   800164 <cprintf>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	eb d1                	jmp    800040 <umain+0xd>

0080006f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800077:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80007a:	e8 8a 0a 00 00       	call   800b09 <sys_getenvid>
  80007f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800084:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800087:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008c:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800091:	85 db                	test   %ebx,%ebx
  800093:	7e 07                	jle    80009c <libmain+0x2d>
		binaryname = argv[0];
  800095:	8b 06                	mov    (%esi),%eax
  800097:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	56                   	push   %esi
  8000a0:	53                   	push   %ebx
  8000a1:	e8 8d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a6:	e8 0a 00 00 00       	call   8000b5 <exit>
}
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000b1:	5b                   	pop    %ebx
  8000b2:	5e                   	pop    %esi
  8000b3:	5d                   	pop    %ebp
  8000b4:	c3                   	ret    

008000b5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000bb:	e8 4e 0e 00 00       	call   800f0e <close_all>
	sys_env_destroy(0);
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	6a 00                	push   $0x0
  8000c5:	e8 fe 09 00 00       	call   800ac8 <sys_env_destroy>
}
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	c9                   	leave  
  8000ce:	c3                   	ret    

008000cf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000cf:	55                   	push   %ebp
  8000d0:	89 e5                	mov    %esp,%ebp
  8000d2:	53                   	push   %ebx
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d9:	8b 13                	mov    (%ebx),%edx
  8000db:	8d 42 01             	lea    0x1(%edx),%eax
  8000de:	89 03                	mov    %eax,(%ebx)
  8000e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000e3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000ec:	74 09                	je     8000f7 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ee:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f5:	c9                   	leave  
  8000f6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	68 ff 00 00 00       	push   $0xff
  8000ff:	8d 43 08             	lea    0x8(%ebx),%eax
  800102:	50                   	push   %eax
  800103:	e8 83 09 00 00       	call   800a8b <sys_cputs>
		b->idx = 0;
  800108:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	eb db                	jmp    8000ee <putch+0x1f>

00800113 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80011c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800123:	00 00 00 
	b.cnt = 0;
  800126:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80012d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800130:	ff 75 0c             	pushl  0xc(%ebp)
  800133:	ff 75 08             	pushl  0x8(%ebp)
  800136:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80013c:	50                   	push   %eax
  80013d:	68 cf 00 80 00       	push   $0x8000cf
  800142:	e8 1a 01 00 00       	call   800261 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800147:	83 c4 08             	add    $0x8,%esp
  80014a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800150:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800156:	50                   	push   %eax
  800157:	e8 2f 09 00 00       	call   800a8b <sys_cputs>

	return b.cnt;
}
  80015c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80016a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80016d:	50                   	push   %eax
  80016e:	ff 75 08             	pushl  0x8(%ebp)
  800171:	e8 9d ff ff ff       	call   800113 <vcprintf>
	va_end(ap);

	return cnt;
}
  800176:	c9                   	leave  
  800177:	c3                   	ret    

00800178 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	57                   	push   %edi
  80017c:	56                   	push   %esi
  80017d:	53                   	push   %ebx
  80017e:	83 ec 1c             	sub    $0x1c,%esp
  800181:	89 c7                	mov    %eax,%edi
  800183:	89 d6                	mov    %edx,%esi
  800185:	8b 45 08             	mov    0x8(%ebp),%eax
  800188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80018e:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800191:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800194:	bb 00 00 00 00       	mov    $0x0,%ebx
  800199:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80019c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80019f:	39 d3                	cmp    %edx,%ebx
  8001a1:	72 05                	jb     8001a8 <printnum+0x30>
  8001a3:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001a6:	77 7a                	ja     800222 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	ff 75 18             	pushl  0x18(%ebp)
  8001ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8001b1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001b4:	53                   	push   %ebx
  8001b5:	ff 75 10             	pushl  0x10(%ebp)
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001be:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001c7:	e8 14 19 00 00       	call   801ae0 <__udivdi3>
  8001cc:	83 c4 18             	add    $0x18,%esp
  8001cf:	52                   	push   %edx
  8001d0:	50                   	push   %eax
  8001d1:	89 f2                	mov    %esi,%edx
  8001d3:	89 f8                	mov    %edi,%eax
  8001d5:	e8 9e ff ff ff       	call   800178 <printnum>
  8001da:	83 c4 20             	add    $0x20,%esp
  8001dd:	eb 13                	jmp    8001f2 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001df:	83 ec 08             	sub    $0x8,%esp
  8001e2:	56                   	push   %esi
  8001e3:	ff 75 18             	pushl  0x18(%ebp)
  8001e6:	ff d7                	call   *%edi
  8001e8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001eb:	83 eb 01             	sub    $0x1,%ebx
  8001ee:	85 db                	test   %ebx,%ebx
  8001f0:	7f ed                	jg     8001df <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	56                   	push   %esi
  8001f6:	83 ec 04             	sub    $0x4,%esp
  8001f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ff:	ff 75 dc             	pushl  -0x24(%ebp)
  800202:	ff 75 d8             	pushl  -0x28(%ebp)
  800205:	e8 f6 19 00 00       	call   801c00 <__umoddi3>
  80020a:	83 c4 14             	add    $0x14,%esp
  80020d:	0f be 80 52 1d 80 00 	movsbl 0x801d52(%eax),%eax
  800214:	50                   	push   %eax
  800215:	ff d7                	call   *%edi
}
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80021d:	5b                   	pop    %ebx
  80021e:	5e                   	pop    %esi
  80021f:	5f                   	pop    %edi
  800220:	5d                   	pop    %ebp
  800221:	c3                   	ret    
  800222:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800225:	eb c4                	jmp    8001eb <printnum+0x73>

00800227 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80022d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800231:	8b 10                	mov    (%eax),%edx
  800233:	3b 50 04             	cmp    0x4(%eax),%edx
  800236:	73 0a                	jae    800242 <sprintputch+0x1b>
		*b->buf++ = ch;
  800238:	8d 4a 01             	lea    0x1(%edx),%ecx
  80023b:	89 08                	mov    %ecx,(%eax)
  80023d:	8b 45 08             	mov    0x8(%ebp),%eax
  800240:	88 02                	mov    %al,(%edx)
}
  800242:	5d                   	pop    %ebp
  800243:	c3                   	ret    

00800244 <printfmt>:
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80024a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80024d:	50                   	push   %eax
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	ff 75 0c             	pushl  0xc(%ebp)
  800254:	ff 75 08             	pushl  0x8(%ebp)
  800257:	e8 05 00 00 00       	call   800261 <vprintfmt>
}
  80025c:	83 c4 10             	add    $0x10,%esp
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <vprintfmt>:
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	57                   	push   %edi
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
  800267:	83 ec 2c             	sub    $0x2c,%esp
  80026a:	8b 75 08             	mov    0x8(%ebp),%esi
  80026d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800270:	8b 7d 10             	mov    0x10(%ebp),%edi
  800273:	e9 8c 03 00 00       	jmp    800604 <vprintfmt+0x3a3>
		padc = ' ';
  800278:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80027c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800283:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80028a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800291:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800296:	8d 47 01             	lea    0x1(%edi),%eax
  800299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80029c:	0f b6 17             	movzbl (%edi),%edx
  80029f:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002a2:	3c 55                	cmp    $0x55,%al
  8002a4:	0f 87 dd 03 00 00    	ja     800687 <vprintfmt+0x426>
  8002aa:	0f b6 c0             	movzbl %al,%eax
  8002ad:	ff 24 85 a0 1e 80 00 	jmp    *0x801ea0(,%eax,4)
  8002b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002b7:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002bb:	eb d9                	jmp    800296 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002c0:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002c4:	eb d0                	jmp    800296 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002c6:	0f b6 d2             	movzbl %dl,%edx
  8002c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002d4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002d7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002db:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002de:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002e1:	83 f9 09             	cmp    $0x9,%ecx
  8002e4:	77 55                	ja     80033b <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002e6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002e9:	eb e9                	jmp    8002d4 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ee:	8b 00                	mov    (%eax),%eax
  8002f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f6:	8d 40 04             	lea    0x4(%eax),%eax
  8002f9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800303:	79 91                	jns    800296 <vprintfmt+0x35>
				width = precision, precision = -1;
  800305:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800308:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80030b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800312:	eb 82                	jmp    800296 <vprintfmt+0x35>
  800314:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800317:	85 c0                	test   %eax,%eax
  800319:	ba 00 00 00 00       	mov    $0x0,%edx
  80031e:	0f 49 d0             	cmovns %eax,%edx
  800321:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800324:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800327:	e9 6a ff ff ff       	jmp    800296 <vprintfmt+0x35>
  80032c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80032f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800336:	e9 5b ff ff ff       	jmp    800296 <vprintfmt+0x35>
  80033b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80033e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800341:	eb bc                	jmp    8002ff <vprintfmt+0x9e>
			lflag++;
  800343:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800346:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800349:	e9 48 ff ff ff       	jmp    800296 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80034e:	8b 45 14             	mov    0x14(%ebp),%eax
  800351:	8d 78 04             	lea    0x4(%eax),%edi
  800354:	83 ec 08             	sub    $0x8,%esp
  800357:	53                   	push   %ebx
  800358:	ff 30                	pushl  (%eax)
  80035a:	ff d6                	call   *%esi
			break;
  80035c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80035f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800362:	e9 9a 02 00 00       	jmp    800601 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800367:	8b 45 14             	mov    0x14(%ebp),%eax
  80036a:	8d 78 04             	lea    0x4(%eax),%edi
  80036d:	8b 00                	mov    (%eax),%eax
  80036f:	99                   	cltd   
  800370:	31 d0                	xor    %edx,%eax
  800372:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800374:	83 f8 0f             	cmp    $0xf,%eax
  800377:	7f 23                	jg     80039c <vprintfmt+0x13b>
  800379:	8b 14 85 00 20 80 00 	mov    0x802000(,%eax,4),%edx
  800380:	85 d2                	test   %edx,%edx
  800382:	74 18                	je     80039c <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800384:	52                   	push   %edx
  800385:	68 31 21 80 00       	push   $0x802131
  80038a:	53                   	push   %ebx
  80038b:	56                   	push   %esi
  80038c:	e8 b3 fe ff ff       	call   800244 <printfmt>
  800391:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800394:	89 7d 14             	mov    %edi,0x14(%ebp)
  800397:	e9 65 02 00 00       	jmp    800601 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  80039c:	50                   	push   %eax
  80039d:	68 6a 1d 80 00       	push   $0x801d6a
  8003a2:	53                   	push   %ebx
  8003a3:	56                   	push   %esi
  8003a4:	e8 9b fe ff ff       	call   800244 <printfmt>
  8003a9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ac:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003af:	e9 4d 02 00 00       	jmp    800601 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  8003b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b7:	83 c0 04             	add    $0x4,%eax
  8003ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c0:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003c2:	85 ff                	test   %edi,%edi
  8003c4:	b8 63 1d 80 00       	mov    $0x801d63,%eax
  8003c9:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d0:	0f 8e bd 00 00 00    	jle    800493 <vprintfmt+0x232>
  8003d6:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003da:	75 0e                	jne    8003ea <vprintfmt+0x189>
  8003dc:	89 75 08             	mov    %esi,0x8(%ebp)
  8003df:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003e2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003e5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003e8:	eb 6d                	jmp    800457 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ea:	83 ec 08             	sub    $0x8,%esp
  8003ed:	ff 75 d0             	pushl  -0x30(%ebp)
  8003f0:	57                   	push   %edi
  8003f1:	e8 39 03 00 00       	call   80072f <strnlen>
  8003f6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003f9:	29 c1                	sub    %eax,%ecx
  8003fb:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003fe:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800401:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800405:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800408:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80040b:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80040d:	eb 0f                	jmp    80041e <vprintfmt+0x1bd>
					putch(padc, putdat);
  80040f:	83 ec 08             	sub    $0x8,%esp
  800412:	53                   	push   %ebx
  800413:	ff 75 e0             	pushl  -0x20(%ebp)
  800416:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800418:	83 ef 01             	sub    $0x1,%edi
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	85 ff                	test   %edi,%edi
  800420:	7f ed                	jg     80040f <vprintfmt+0x1ae>
  800422:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800425:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800428:	85 c9                	test   %ecx,%ecx
  80042a:	b8 00 00 00 00       	mov    $0x0,%eax
  80042f:	0f 49 c1             	cmovns %ecx,%eax
  800432:	29 c1                	sub    %eax,%ecx
  800434:	89 75 08             	mov    %esi,0x8(%ebp)
  800437:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80043a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80043d:	89 cb                	mov    %ecx,%ebx
  80043f:	eb 16                	jmp    800457 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800441:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800445:	75 31                	jne    800478 <vprintfmt+0x217>
					putch(ch, putdat);
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 0c             	pushl  0xc(%ebp)
  80044d:	50                   	push   %eax
  80044e:	ff 55 08             	call   *0x8(%ebp)
  800451:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800454:	83 eb 01             	sub    $0x1,%ebx
  800457:	83 c7 01             	add    $0x1,%edi
  80045a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80045e:	0f be c2             	movsbl %dl,%eax
  800461:	85 c0                	test   %eax,%eax
  800463:	74 59                	je     8004be <vprintfmt+0x25d>
  800465:	85 f6                	test   %esi,%esi
  800467:	78 d8                	js     800441 <vprintfmt+0x1e0>
  800469:	83 ee 01             	sub    $0x1,%esi
  80046c:	79 d3                	jns    800441 <vprintfmt+0x1e0>
  80046e:	89 df                	mov    %ebx,%edi
  800470:	8b 75 08             	mov    0x8(%ebp),%esi
  800473:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800476:	eb 37                	jmp    8004af <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800478:	0f be d2             	movsbl %dl,%edx
  80047b:	83 ea 20             	sub    $0x20,%edx
  80047e:	83 fa 5e             	cmp    $0x5e,%edx
  800481:	76 c4                	jbe    800447 <vprintfmt+0x1e6>
					putch('?', putdat);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	ff 75 0c             	pushl  0xc(%ebp)
  800489:	6a 3f                	push   $0x3f
  80048b:	ff 55 08             	call   *0x8(%ebp)
  80048e:	83 c4 10             	add    $0x10,%esp
  800491:	eb c1                	jmp    800454 <vprintfmt+0x1f3>
  800493:	89 75 08             	mov    %esi,0x8(%ebp)
  800496:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800499:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80049c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80049f:	eb b6                	jmp    800457 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	53                   	push   %ebx
  8004a5:	6a 20                	push   $0x20
  8004a7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004a9:	83 ef 01             	sub    $0x1,%edi
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	85 ff                	test   %edi,%edi
  8004b1:	7f ee                	jg     8004a1 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b9:	e9 43 01 00 00       	jmp    800601 <vprintfmt+0x3a0>
  8004be:	89 df                	mov    %ebx,%edi
  8004c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c6:	eb e7                	jmp    8004af <vprintfmt+0x24e>
	if (lflag >= 2)
  8004c8:	83 f9 01             	cmp    $0x1,%ecx
  8004cb:	7e 3f                	jle    80050c <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	8b 50 04             	mov    0x4(%eax),%edx
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 40 08             	lea    0x8(%eax),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004e8:	79 5c                	jns    800546 <vprintfmt+0x2e5>
				putch('-', putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	53                   	push   %ebx
  8004ee:	6a 2d                	push   $0x2d
  8004f0:	ff d6                	call   *%esi
				num = -(long long) num;
  8004f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004f8:	f7 da                	neg    %edx
  8004fa:	83 d1 00             	adc    $0x0,%ecx
  8004fd:	f7 d9                	neg    %ecx
  8004ff:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800502:	b8 0a 00 00 00       	mov    $0xa,%eax
  800507:	e9 db 00 00 00       	jmp    8005e7 <vprintfmt+0x386>
	else if (lflag)
  80050c:	85 c9                	test   %ecx,%ecx
  80050e:	75 1b                	jne    80052b <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800518:	89 c1                	mov    %eax,%ecx
  80051a:	c1 f9 1f             	sar    $0x1f,%ecx
  80051d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	8d 40 04             	lea    0x4(%eax),%eax
  800526:	89 45 14             	mov    %eax,0x14(%ebp)
  800529:	eb b9                	jmp    8004e4 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80052b:	8b 45 14             	mov    0x14(%ebp),%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800533:	89 c1                	mov    %eax,%ecx
  800535:	c1 f9 1f             	sar    $0x1f,%ecx
  800538:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8d 40 04             	lea    0x4(%eax),%eax
  800541:	89 45 14             	mov    %eax,0x14(%ebp)
  800544:	eb 9e                	jmp    8004e4 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800546:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800549:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80054c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800551:	e9 91 00 00 00       	jmp    8005e7 <vprintfmt+0x386>
	if (lflag >= 2)
  800556:	83 f9 01             	cmp    $0x1,%ecx
  800559:	7e 15                	jle    800570 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 10                	mov    (%eax),%edx
  800560:	8b 48 04             	mov    0x4(%eax),%ecx
  800563:	8d 40 08             	lea    0x8(%eax),%eax
  800566:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800569:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056e:	eb 77                	jmp    8005e7 <vprintfmt+0x386>
	else if (lflag)
  800570:	85 c9                	test   %ecx,%ecx
  800572:	75 17                	jne    80058b <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8b 10                	mov    (%eax),%edx
  800579:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057e:	8d 40 04             	lea    0x4(%eax),%eax
  800581:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800584:	b8 0a 00 00 00       	mov    $0xa,%eax
  800589:	eb 5c                	jmp    8005e7 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80058b:	8b 45 14             	mov    0x14(%ebp),%eax
  80058e:	8b 10                	mov    (%eax),%edx
  800590:	b9 00 00 00 00       	mov    $0x0,%ecx
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a0:	eb 45                	jmp    8005e7 <vprintfmt+0x386>
			putch('X', putdat);
  8005a2:	83 ec 08             	sub    $0x8,%esp
  8005a5:	53                   	push   %ebx
  8005a6:	6a 58                	push   $0x58
  8005a8:	ff d6                	call   *%esi
			putch('X', putdat);
  8005aa:	83 c4 08             	add    $0x8,%esp
  8005ad:	53                   	push   %ebx
  8005ae:	6a 58                	push   $0x58
  8005b0:	ff d6                	call   *%esi
			putch('X', putdat);
  8005b2:	83 c4 08             	add    $0x8,%esp
  8005b5:	53                   	push   %ebx
  8005b6:	6a 58                	push   $0x58
  8005b8:	ff d6                	call   *%esi
			break;
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	eb 42                	jmp    800601 <vprintfmt+0x3a0>
			putch('0', putdat);
  8005bf:	83 ec 08             	sub    $0x8,%esp
  8005c2:	53                   	push   %ebx
  8005c3:	6a 30                	push   $0x30
  8005c5:	ff d6                	call   *%esi
			putch('x', putdat);
  8005c7:	83 c4 08             	add    $0x8,%esp
  8005ca:	53                   	push   %ebx
  8005cb:	6a 78                	push   $0x78
  8005cd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 10                	mov    (%eax),%edx
  8005d4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005d9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005dc:	8d 40 04             	lea    0x4(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005e2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005ee:	57                   	push   %edi
  8005ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f2:	50                   	push   %eax
  8005f3:	51                   	push   %ecx
  8005f4:	52                   	push   %edx
  8005f5:	89 da                	mov    %ebx,%edx
  8005f7:	89 f0                	mov    %esi,%eax
  8005f9:	e8 7a fb ff ff       	call   800178 <printnum>
			break;
  8005fe:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800601:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800604:	83 c7 01             	add    $0x1,%edi
  800607:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80060b:	83 f8 25             	cmp    $0x25,%eax
  80060e:	0f 84 64 fc ff ff    	je     800278 <vprintfmt+0x17>
			if (ch == '\0')
  800614:	85 c0                	test   %eax,%eax
  800616:	0f 84 8b 00 00 00    	je     8006a7 <vprintfmt+0x446>
			putch(ch, putdat);
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	53                   	push   %ebx
  800620:	50                   	push   %eax
  800621:	ff d6                	call   *%esi
  800623:	83 c4 10             	add    $0x10,%esp
  800626:	eb dc                	jmp    800604 <vprintfmt+0x3a3>
	if (lflag >= 2)
  800628:	83 f9 01             	cmp    $0x1,%ecx
  80062b:	7e 15                	jle    800642 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	8b 10                	mov    (%eax),%edx
  800632:	8b 48 04             	mov    0x4(%eax),%ecx
  800635:	8d 40 08             	lea    0x8(%eax),%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80063b:	b8 10 00 00 00       	mov    $0x10,%eax
  800640:	eb a5                	jmp    8005e7 <vprintfmt+0x386>
	else if (lflag)
  800642:	85 c9                	test   %ecx,%ecx
  800644:	75 17                	jne    80065d <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 10                	mov    (%eax),%edx
  80064b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800650:	8d 40 04             	lea    0x4(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800656:	b8 10 00 00 00       	mov    $0x10,%eax
  80065b:	eb 8a                	jmp    8005e7 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 10                	mov    (%eax),%edx
  800662:	b9 00 00 00 00       	mov    $0x0,%ecx
  800667:	8d 40 04             	lea    0x4(%eax),%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80066d:	b8 10 00 00 00       	mov    $0x10,%eax
  800672:	e9 70 ff ff ff       	jmp    8005e7 <vprintfmt+0x386>
			putch(ch, putdat);
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	53                   	push   %ebx
  80067b:	6a 25                	push   $0x25
  80067d:	ff d6                	call   *%esi
			break;
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	e9 7a ff ff ff       	jmp    800601 <vprintfmt+0x3a0>
			putch('%', putdat);
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	53                   	push   %ebx
  80068b:	6a 25                	push   $0x25
  80068d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	89 f8                	mov    %edi,%eax
  800694:	eb 03                	jmp    800699 <vprintfmt+0x438>
  800696:	83 e8 01             	sub    $0x1,%eax
  800699:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80069d:	75 f7                	jne    800696 <vprintfmt+0x435>
  80069f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a2:	e9 5a ff ff ff       	jmp    800601 <vprintfmt+0x3a0>
}
  8006a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006aa:	5b                   	pop    %ebx
  8006ab:	5e                   	pop    %esi
  8006ac:	5f                   	pop    %edi
  8006ad:	5d                   	pop    %ebp
  8006ae:	c3                   	ret    

008006af <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006af:	55                   	push   %ebp
  8006b0:	89 e5                	mov    %esp,%ebp
  8006b2:	83 ec 18             	sub    $0x18,%esp
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006be:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006c2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006cc:	85 c0                	test   %eax,%eax
  8006ce:	74 26                	je     8006f6 <vsnprintf+0x47>
  8006d0:	85 d2                	test   %edx,%edx
  8006d2:	7e 22                	jle    8006f6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006d4:	ff 75 14             	pushl  0x14(%ebp)
  8006d7:	ff 75 10             	pushl  0x10(%ebp)
  8006da:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006dd:	50                   	push   %eax
  8006de:	68 27 02 80 00       	push   $0x800227
  8006e3:	e8 79 fb ff ff       	call   800261 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006eb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
}
  8006f4:	c9                   	leave  
  8006f5:	c3                   	ret    
		return -E_INVAL;
  8006f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006fb:	eb f7                	jmp    8006f4 <vsnprintf+0x45>

008006fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800703:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800706:	50                   	push   %eax
  800707:	ff 75 10             	pushl  0x10(%ebp)
  80070a:	ff 75 0c             	pushl  0xc(%ebp)
  80070d:	ff 75 08             	pushl  0x8(%ebp)
  800710:	e8 9a ff ff ff       	call   8006af <vsnprintf>
	va_end(ap);

	return rc;
}
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80071d:	b8 00 00 00 00       	mov    $0x0,%eax
  800722:	eb 03                	jmp    800727 <strlen+0x10>
		n++;
  800724:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800727:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80072b:	75 f7                	jne    800724 <strlen+0xd>
	return n;
}
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800735:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800738:	b8 00 00 00 00       	mov    $0x0,%eax
  80073d:	eb 03                	jmp    800742 <strnlen+0x13>
		n++;
  80073f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800742:	39 d0                	cmp    %edx,%eax
  800744:	74 06                	je     80074c <strnlen+0x1d>
  800746:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80074a:	75 f3                	jne    80073f <strnlen+0x10>
	return n;
}
  80074c:	5d                   	pop    %ebp
  80074d:	c3                   	ret    

0080074e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	53                   	push   %ebx
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800758:	89 c2                	mov    %eax,%edx
  80075a:	83 c1 01             	add    $0x1,%ecx
  80075d:	83 c2 01             	add    $0x1,%edx
  800760:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800764:	88 5a ff             	mov    %bl,-0x1(%edx)
  800767:	84 db                	test   %bl,%bl
  800769:	75 ef                	jne    80075a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80076b:	5b                   	pop    %ebx
  80076c:	5d                   	pop    %ebp
  80076d:	c3                   	ret    

0080076e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80076e:	55                   	push   %ebp
  80076f:	89 e5                	mov    %esp,%ebp
  800771:	53                   	push   %ebx
  800772:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800775:	53                   	push   %ebx
  800776:	e8 9c ff ff ff       	call   800717 <strlen>
  80077b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	01 d8                	add    %ebx,%eax
  800783:	50                   	push   %eax
  800784:	e8 c5 ff ff ff       	call   80074e <strcpy>
	return dst;
}
  800789:	89 d8                	mov    %ebx,%eax
  80078b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80078e:	c9                   	leave  
  80078f:	c3                   	ret    

00800790 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	56                   	push   %esi
  800794:	53                   	push   %ebx
  800795:	8b 75 08             	mov    0x8(%ebp),%esi
  800798:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80079b:	89 f3                	mov    %esi,%ebx
  80079d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007a0:	89 f2                	mov    %esi,%edx
  8007a2:	eb 0f                	jmp    8007b3 <strncpy+0x23>
		*dst++ = *src;
  8007a4:	83 c2 01             	add    $0x1,%edx
  8007a7:	0f b6 01             	movzbl (%ecx),%eax
  8007aa:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007ad:	80 39 01             	cmpb   $0x1,(%ecx)
  8007b0:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007b3:	39 da                	cmp    %ebx,%edx
  8007b5:	75 ed                	jne    8007a4 <strncpy+0x14>
	}
	return ret;
}
  8007b7:	89 f0                	mov    %esi,%eax
  8007b9:	5b                   	pop    %ebx
  8007ba:	5e                   	pop    %esi
  8007bb:	5d                   	pop    %ebp
  8007bc:	c3                   	ret    

008007bd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	56                   	push   %esi
  8007c1:	53                   	push   %ebx
  8007c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007cb:	89 f0                	mov    %esi,%eax
  8007cd:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007d1:	85 c9                	test   %ecx,%ecx
  8007d3:	75 0b                	jne    8007e0 <strlcpy+0x23>
  8007d5:	eb 17                	jmp    8007ee <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007d7:	83 c2 01             	add    $0x1,%edx
  8007da:	83 c0 01             	add    $0x1,%eax
  8007dd:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8007e0:	39 d8                	cmp    %ebx,%eax
  8007e2:	74 07                	je     8007eb <strlcpy+0x2e>
  8007e4:	0f b6 0a             	movzbl (%edx),%ecx
  8007e7:	84 c9                	test   %cl,%cl
  8007e9:	75 ec                	jne    8007d7 <strlcpy+0x1a>
		*dst = '\0';
  8007eb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007ee:	29 f0                	sub    %esi,%eax
}
  8007f0:	5b                   	pop    %ebx
  8007f1:	5e                   	pop    %esi
  8007f2:	5d                   	pop    %ebp
  8007f3:	c3                   	ret    

008007f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007f4:	55                   	push   %ebp
  8007f5:	89 e5                	mov    %esp,%ebp
  8007f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007fd:	eb 06                	jmp    800805 <strcmp+0x11>
		p++, q++;
  8007ff:	83 c1 01             	add    $0x1,%ecx
  800802:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800805:	0f b6 01             	movzbl (%ecx),%eax
  800808:	84 c0                	test   %al,%al
  80080a:	74 04                	je     800810 <strcmp+0x1c>
  80080c:	3a 02                	cmp    (%edx),%al
  80080e:	74 ef                	je     8007ff <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800810:	0f b6 c0             	movzbl %al,%eax
  800813:	0f b6 12             	movzbl (%edx),%edx
  800816:	29 d0                	sub    %edx,%eax
}
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	53                   	push   %ebx
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 55 0c             	mov    0xc(%ebp),%edx
  800824:	89 c3                	mov    %eax,%ebx
  800826:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800829:	eb 06                	jmp    800831 <strncmp+0x17>
		n--, p++, q++;
  80082b:	83 c0 01             	add    $0x1,%eax
  80082e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800831:	39 d8                	cmp    %ebx,%eax
  800833:	74 16                	je     80084b <strncmp+0x31>
  800835:	0f b6 08             	movzbl (%eax),%ecx
  800838:	84 c9                	test   %cl,%cl
  80083a:	74 04                	je     800840 <strncmp+0x26>
  80083c:	3a 0a                	cmp    (%edx),%cl
  80083e:	74 eb                	je     80082b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800840:	0f b6 00             	movzbl (%eax),%eax
  800843:	0f b6 12             	movzbl (%edx),%edx
  800846:	29 d0                	sub    %edx,%eax
}
  800848:	5b                   	pop    %ebx
  800849:	5d                   	pop    %ebp
  80084a:	c3                   	ret    
		return 0;
  80084b:	b8 00 00 00 00       	mov    $0x0,%eax
  800850:	eb f6                	jmp    800848 <strncmp+0x2e>

00800852 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80085c:	0f b6 10             	movzbl (%eax),%edx
  80085f:	84 d2                	test   %dl,%dl
  800861:	74 09                	je     80086c <strchr+0x1a>
		if (*s == c)
  800863:	38 ca                	cmp    %cl,%dl
  800865:	74 0a                	je     800871 <strchr+0x1f>
	for (; *s; s++)
  800867:	83 c0 01             	add    $0x1,%eax
  80086a:	eb f0                	jmp    80085c <strchr+0xa>
			return (char *) s;
	return 0;
  80086c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80087d:	eb 03                	jmp    800882 <strfind+0xf>
  80087f:	83 c0 01             	add    $0x1,%eax
  800882:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800885:	38 ca                	cmp    %cl,%dl
  800887:	74 04                	je     80088d <strfind+0x1a>
  800889:	84 d2                	test   %dl,%dl
  80088b:	75 f2                	jne    80087f <strfind+0xc>
			break;
	return (char *) s;
}
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	57                   	push   %edi
  800893:	56                   	push   %esi
  800894:	53                   	push   %ebx
  800895:	8b 7d 08             	mov    0x8(%ebp),%edi
  800898:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80089b:	85 c9                	test   %ecx,%ecx
  80089d:	74 13                	je     8008b2 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80089f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008a5:	75 05                	jne    8008ac <memset+0x1d>
  8008a7:	f6 c1 03             	test   $0x3,%cl
  8008aa:	74 0d                	je     8008b9 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008af:	fc                   	cld    
  8008b0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008b2:	89 f8                	mov    %edi,%eax
  8008b4:	5b                   	pop    %ebx
  8008b5:	5e                   	pop    %esi
  8008b6:	5f                   	pop    %edi
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    
		c &= 0xFF;
  8008b9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008bd:	89 d3                	mov    %edx,%ebx
  8008bf:	c1 e3 08             	shl    $0x8,%ebx
  8008c2:	89 d0                	mov    %edx,%eax
  8008c4:	c1 e0 18             	shl    $0x18,%eax
  8008c7:	89 d6                	mov    %edx,%esi
  8008c9:	c1 e6 10             	shl    $0x10,%esi
  8008cc:	09 f0                	or     %esi,%eax
  8008ce:	09 c2                	or     %eax,%edx
  8008d0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008d2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008d5:	89 d0                	mov    %edx,%eax
  8008d7:	fc                   	cld    
  8008d8:	f3 ab                	rep stos %eax,%es:(%edi)
  8008da:	eb d6                	jmp    8008b2 <memset+0x23>

008008dc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
  8008df:	57                   	push   %edi
  8008e0:	56                   	push   %esi
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008ea:	39 c6                	cmp    %eax,%esi
  8008ec:	73 35                	jae    800923 <memmove+0x47>
  8008ee:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008f1:	39 c2                	cmp    %eax,%edx
  8008f3:	76 2e                	jbe    800923 <memmove+0x47>
		s += n;
		d += n;
  8008f5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008f8:	89 d6                	mov    %edx,%esi
  8008fa:	09 fe                	or     %edi,%esi
  8008fc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800902:	74 0c                	je     800910 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800904:	83 ef 01             	sub    $0x1,%edi
  800907:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80090a:	fd                   	std    
  80090b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80090d:	fc                   	cld    
  80090e:	eb 21                	jmp    800931 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800910:	f6 c1 03             	test   $0x3,%cl
  800913:	75 ef                	jne    800904 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800915:	83 ef 04             	sub    $0x4,%edi
  800918:	8d 72 fc             	lea    -0x4(%edx),%esi
  80091b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80091e:	fd                   	std    
  80091f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800921:	eb ea                	jmp    80090d <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800923:	89 f2                	mov    %esi,%edx
  800925:	09 c2                	or     %eax,%edx
  800927:	f6 c2 03             	test   $0x3,%dl
  80092a:	74 09                	je     800935 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80092c:	89 c7                	mov    %eax,%edi
  80092e:	fc                   	cld    
  80092f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800931:	5e                   	pop    %esi
  800932:	5f                   	pop    %edi
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800935:	f6 c1 03             	test   $0x3,%cl
  800938:	75 f2                	jne    80092c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80093a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80093d:	89 c7                	mov    %eax,%edi
  80093f:	fc                   	cld    
  800940:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800942:	eb ed                	jmp    800931 <memmove+0x55>

00800944 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800947:	ff 75 10             	pushl  0x10(%ebp)
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	ff 75 08             	pushl  0x8(%ebp)
  800950:	e8 87 ff ff ff       	call   8008dc <memmove>
}
  800955:	c9                   	leave  
  800956:	c3                   	ret    

00800957 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	56                   	push   %esi
  80095b:	53                   	push   %ebx
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800962:	89 c6                	mov    %eax,%esi
  800964:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800967:	39 f0                	cmp    %esi,%eax
  800969:	74 1c                	je     800987 <memcmp+0x30>
		if (*s1 != *s2)
  80096b:	0f b6 08             	movzbl (%eax),%ecx
  80096e:	0f b6 1a             	movzbl (%edx),%ebx
  800971:	38 d9                	cmp    %bl,%cl
  800973:	75 08                	jne    80097d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800975:	83 c0 01             	add    $0x1,%eax
  800978:	83 c2 01             	add    $0x1,%edx
  80097b:	eb ea                	jmp    800967 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80097d:	0f b6 c1             	movzbl %cl,%eax
  800980:	0f b6 db             	movzbl %bl,%ebx
  800983:	29 d8                	sub    %ebx,%eax
  800985:	eb 05                	jmp    80098c <memcmp+0x35>
	}

	return 0;
  800987:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80098c:	5b                   	pop    %ebx
  80098d:	5e                   	pop    %esi
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800999:	89 c2                	mov    %eax,%edx
  80099b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80099e:	39 d0                	cmp    %edx,%eax
  8009a0:	73 09                	jae    8009ab <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009a2:	38 08                	cmp    %cl,(%eax)
  8009a4:	74 05                	je     8009ab <memfind+0x1b>
	for (; s < ends; s++)
  8009a6:	83 c0 01             	add    $0x1,%eax
  8009a9:	eb f3                	jmp    80099e <memfind+0xe>
			break;
	return (void *) s;
}
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    

008009ad <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	57                   	push   %edi
  8009b1:	56                   	push   %esi
  8009b2:	53                   	push   %ebx
  8009b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009b9:	eb 03                	jmp    8009be <strtol+0x11>
		s++;
  8009bb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009be:	0f b6 01             	movzbl (%ecx),%eax
  8009c1:	3c 20                	cmp    $0x20,%al
  8009c3:	74 f6                	je     8009bb <strtol+0xe>
  8009c5:	3c 09                	cmp    $0x9,%al
  8009c7:	74 f2                	je     8009bb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009c9:	3c 2b                	cmp    $0x2b,%al
  8009cb:	74 2e                	je     8009fb <strtol+0x4e>
	int neg = 0;
  8009cd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009d2:	3c 2d                	cmp    $0x2d,%al
  8009d4:	74 2f                	je     800a05 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009d6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009dc:	75 05                	jne    8009e3 <strtol+0x36>
  8009de:	80 39 30             	cmpb   $0x30,(%ecx)
  8009e1:	74 2c                	je     800a0f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009e3:	85 db                	test   %ebx,%ebx
  8009e5:	75 0a                	jne    8009f1 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009e7:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8009ec:	80 39 30             	cmpb   $0x30,(%ecx)
  8009ef:	74 28                	je     800a19 <strtol+0x6c>
		base = 10;
  8009f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009f9:	eb 50                	jmp    800a4b <strtol+0x9e>
		s++;
  8009fb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8009fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800a03:	eb d1                	jmp    8009d6 <strtol+0x29>
		s++, neg = 1;
  800a05:	83 c1 01             	add    $0x1,%ecx
  800a08:	bf 01 00 00 00       	mov    $0x1,%edi
  800a0d:	eb c7                	jmp    8009d6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a0f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a13:	74 0e                	je     800a23 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a15:	85 db                	test   %ebx,%ebx
  800a17:	75 d8                	jne    8009f1 <strtol+0x44>
		s++, base = 8;
  800a19:	83 c1 01             	add    $0x1,%ecx
  800a1c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a21:	eb ce                	jmp    8009f1 <strtol+0x44>
		s += 2, base = 16;
  800a23:	83 c1 02             	add    $0x2,%ecx
  800a26:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a2b:	eb c4                	jmp    8009f1 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a2d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a30:	89 f3                	mov    %esi,%ebx
  800a32:	80 fb 19             	cmp    $0x19,%bl
  800a35:	77 29                	ja     800a60 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a37:	0f be d2             	movsbl %dl,%edx
  800a3a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a3d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a40:	7d 30                	jge    800a72 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a42:	83 c1 01             	add    $0x1,%ecx
  800a45:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a49:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a4b:	0f b6 11             	movzbl (%ecx),%edx
  800a4e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a51:	89 f3                	mov    %esi,%ebx
  800a53:	80 fb 09             	cmp    $0x9,%bl
  800a56:	77 d5                	ja     800a2d <strtol+0x80>
			dig = *s - '0';
  800a58:	0f be d2             	movsbl %dl,%edx
  800a5b:	83 ea 30             	sub    $0x30,%edx
  800a5e:	eb dd                	jmp    800a3d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a60:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a63:	89 f3                	mov    %esi,%ebx
  800a65:	80 fb 19             	cmp    $0x19,%bl
  800a68:	77 08                	ja     800a72 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a6a:	0f be d2             	movsbl %dl,%edx
  800a6d:	83 ea 37             	sub    $0x37,%edx
  800a70:	eb cb                	jmp    800a3d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a76:	74 05                	je     800a7d <strtol+0xd0>
		*endptr = (char *) s;
  800a78:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a7d:	89 c2                	mov    %eax,%edx
  800a7f:	f7 da                	neg    %edx
  800a81:	85 ff                	test   %edi,%edi
  800a83:	0f 45 c2             	cmovne %edx,%eax
}
  800a86:	5b                   	pop    %ebx
  800a87:	5e                   	pop    %esi
  800a88:	5f                   	pop    %edi
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	57                   	push   %edi
  800a8f:	56                   	push   %esi
  800a90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a91:	b8 00 00 00 00       	mov    $0x0,%eax
  800a96:	8b 55 08             	mov    0x8(%ebp),%edx
  800a99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a9c:	89 c3                	mov    %eax,%ebx
  800a9e:	89 c7                	mov    %eax,%edi
  800aa0:	89 c6                	mov    %eax,%esi
  800aa2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aa4:	5b                   	pop    %ebx
  800aa5:	5e                   	pop    %esi
  800aa6:	5f                   	pop    %edi
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	57                   	push   %edi
  800aad:	56                   	push   %esi
  800aae:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aaf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab4:	b8 01 00 00 00       	mov    $0x1,%eax
  800ab9:	89 d1                	mov    %edx,%ecx
  800abb:	89 d3                	mov    %edx,%ebx
  800abd:	89 d7                	mov    %edx,%edi
  800abf:	89 d6                	mov    %edx,%esi
  800ac1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ac3:	5b                   	pop    %ebx
  800ac4:	5e                   	pop    %esi
  800ac5:	5f                   	pop    %edi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	57                   	push   %edi
  800acc:	56                   	push   %esi
  800acd:	53                   	push   %ebx
  800ace:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ad1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ad6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad9:	b8 03 00 00 00       	mov    $0x3,%eax
  800ade:	89 cb                	mov    %ecx,%ebx
  800ae0:	89 cf                	mov    %ecx,%edi
  800ae2:	89 ce                	mov    %ecx,%esi
  800ae4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ae6:	85 c0                	test   %eax,%eax
  800ae8:	7f 08                	jg     800af2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aed:	5b                   	pop    %ebx
  800aee:	5e                   	pop    %esi
  800aef:	5f                   	pop    %edi
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800af2:	83 ec 0c             	sub    $0xc,%esp
  800af5:	50                   	push   %eax
  800af6:	6a 03                	push   $0x3
  800af8:	68 5f 20 80 00       	push   $0x80205f
  800afd:	6a 23                	push   $0x23
  800aff:	68 7c 20 80 00       	push   $0x80207c
  800b04:	e8 ea 0e 00 00       	call   8019f3 <_panic>

00800b09 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	57                   	push   %edi
  800b0d:	56                   	push   %esi
  800b0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b14:	b8 02 00 00 00       	mov    $0x2,%eax
  800b19:	89 d1                	mov    %edx,%ecx
  800b1b:	89 d3                	mov    %edx,%ebx
  800b1d:	89 d7                	mov    %edx,%edi
  800b1f:	89 d6                	mov    %edx,%esi
  800b21:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b23:	5b                   	pop    %ebx
  800b24:	5e                   	pop    %esi
  800b25:	5f                   	pop    %edi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <sys_yield>:

void
sys_yield(void)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	57                   	push   %edi
  800b2c:	56                   	push   %esi
  800b2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b33:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b38:	89 d1                	mov    %edx,%ecx
  800b3a:	89 d3                	mov    %edx,%ebx
  800b3c:	89 d7                	mov    %edx,%edi
  800b3e:	89 d6                	mov    %edx,%esi
  800b40:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b42:	5b                   	pop    %ebx
  800b43:	5e                   	pop    %esi
  800b44:	5f                   	pop    %edi
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	57                   	push   %edi
  800b4b:	56                   	push   %esi
  800b4c:	53                   	push   %ebx
  800b4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b50:	be 00 00 00 00       	mov    $0x0,%esi
  800b55:	8b 55 08             	mov    0x8(%ebp),%edx
  800b58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5b:	b8 04 00 00 00       	mov    $0x4,%eax
  800b60:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b63:	89 f7                	mov    %esi,%edi
  800b65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b67:	85 c0                	test   %eax,%eax
  800b69:	7f 08                	jg     800b73 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b6e:	5b                   	pop    %ebx
  800b6f:	5e                   	pop    %esi
  800b70:	5f                   	pop    %edi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b73:	83 ec 0c             	sub    $0xc,%esp
  800b76:	50                   	push   %eax
  800b77:	6a 04                	push   $0x4
  800b79:	68 5f 20 80 00       	push   $0x80205f
  800b7e:	6a 23                	push   $0x23
  800b80:	68 7c 20 80 00       	push   $0x80207c
  800b85:	e8 69 0e 00 00       	call   8019f3 <_panic>

00800b8a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	57                   	push   %edi
  800b8e:	56                   	push   %esi
  800b8f:	53                   	push   %ebx
  800b90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b93:	8b 55 08             	mov    0x8(%ebp),%edx
  800b96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b99:	b8 05 00 00 00       	mov    $0x5,%eax
  800b9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ba1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ba4:	8b 75 18             	mov    0x18(%ebp),%esi
  800ba7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba9:	85 c0                	test   %eax,%eax
  800bab:	7f 08                	jg     800bb5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb5:	83 ec 0c             	sub    $0xc,%esp
  800bb8:	50                   	push   %eax
  800bb9:	6a 05                	push   $0x5
  800bbb:	68 5f 20 80 00       	push   $0x80205f
  800bc0:	6a 23                	push   $0x23
  800bc2:	68 7c 20 80 00       	push   $0x80207c
  800bc7:	e8 27 0e 00 00       	call   8019f3 <_panic>

00800bcc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
  800bd2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bda:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be0:	b8 06 00 00 00       	mov    $0x6,%eax
  800be5:	89 df                	mov    %ebx,%edi
  800be7:	89 de                	mov    %ebx,%esi
  800be9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800beb:	85 c0                	test   %eax,%eax
  800bed:	7f 08                	jg     800bf7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf7:	83 ec 0c             	sub    $0xc,%esp
  800bfa:	50                   	push   %eax
  800bfb:	6a 06                	push   $0x6
  800bfd:	68 5f 20 80 00       	push   $0x80205f
  800c02:	6a 23                	push   $0x23
  800c04:	68 7c 20 80 00       	push   $0x80207c
  800c09:	e8 e5 0d 00 00       	call   8019f3 <_panic>

00800c0e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	57                   	push   %edi
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
  800c14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c22:	b8 08 00 00 00       	mov    $0x8,%eax
  800c27:	89 df                	mov    %ebx,%edi
  800c29:	89 de                	mov    %ebx,%esi
  800c2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2d:	85 c0                	test   %eax,%eax
  800c2f:	7f 08                	jg     800c39 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c34:	5b                   	pop    %ebx
  800c35:	5e                   	pop    %esi
  800c36:	5f                   	pop    %edi
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c39:	83 ec 0c             	sub    $0xc,%esp
  800c3c:	50                   	push   %eax
  800c3d:	6a 08                	push   $0x8
  800c3f:	68 5f 20 80 00       	push   $0x80205f
  800c44:	6a 23                	push   $0x23
  800c46:	68 7c 20 80 00       	push   $0x80207c
  800c4b:	e8 a3 0d 00 00       	call   8019f3 <_panic>

00800c50 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	57                   	push   %edi
  800c54:	56                   	push   %esi
  800c55:	53                   	push   %ebx
  800c56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c64:	b8 09 00 00 00       	mov    $0x9,%eax
  800c69:	89 df                	mov    %ebx,%edi
  800c6b:	89 de                	mov    %ebx,%esi
  800c6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6f:	85 c0                	test   %eax,%eax
  800c71:	7f 08                	jg     800c7b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c76:	5b                   	pop    %ebx
  800c77:	5e                   	pop    %esi
  800c78:	5f                   	pop    %edi
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7b:	83 ec 0c             	sub    $0xc,%esp
  800c7e:	50                   	push   %eax
  800c7f:	6a 09                	push   $0x9
  800c81:	68 5f 20 80 00       	push   $0x80205f
  800c86:	6a 23                	push   $0x23
  800c88:	68 7c 20 80 00       	push   $0x80207c
  800c8d:	e8 61 0d 00 00       	call   8019f3 <_panic>

00800c92 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	57                   	push   %edi
  800c96:	56                   	push   %esi
  800c97:	53                   	push   %ebx
  800c98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cab:	89 df                	mov    %ebx,%edi
  800cad:	89 de                	mov    %ebx,%esi
  800caf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb1:	85 c0                	test   %eax,%eax
  800cb3:	7f 08                	jg     800cbd <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb8:	5b                   	pop    %ebx
  800cb9:	5e                   	pop    %esi
  800cba:	5f                   	pop    %edi
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbd:	83 ec 0c             	sub    $0xc,%esp
  800cc0:	50                   	push   %eax
  800cc1:	6a 0a                	push   $0xa
  800cc3:	68 5f 20 80 00       	push   $0x80205f
  800cc8:	6a 23                	push   $0x23
  800cca:	68 7c 20 80 00       	push   $0x80207c
  800ccf:	e8 1f 0d 00 00       	call   8019f3 <_panic>

00800cd4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cda:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ce5:	be 00 00 00 00       	mov    $0x0,%esi
  800cea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ced:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
  800cfd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d00:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d05:	8b 55 08             	mov    0x8(%ebp),%edx
  800d08:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d0d:	89 cb                	mov    %ecx,%ebx
  800d0f:	89 cf                	mov    %ecx,%edi
  800d11:	89 ce                	mov    %ecx,%esi
  800d13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d15:	85 c0                	test   %eax,%eax
  800d17:	7f 08                	jg     800d21 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d21:	83 ec 0c             	sub    $0xc,%esp
  800d24:	50                   	push   %eax
  800d25:	6a 0d                	push   $0xd
  800d27:	68 5f 20 80 00       	push   $0x80205f
  800d2c:	6a 23                	push   $0x23
  800d2e:	68 7c 20 80 00       	push   $0x80207c
  800d33:	e8 bb 0c 00 00       	call   8019f3 <_panic>

00800d38 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	05 00 00 00 30       	add    $0x30000000,%eax
  800d43:	c1 e8 0c             	shr    $0xc,%eax
}
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d58:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d65:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d6a:	89 c2                	mov    %eax,%edx
  800d6c:	c1 ea 16             	shr    $0x16,%edx
  800d6f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800d76:	f6 c2 01             	test   $0x1,%dl
  800d79:	74 2a                	je     800da5 <fd_alloc+0x46>
  800d7b:	89 c2                	mov    %eax,%edx
  800d7d:	c1 ea 0c             	shr    $0xc,%edx
  800d80:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800d87:	f6 c2 01             	test   $0x1,%dl
  800d8a:	74 19                	je     800da5 <fd_alloc+0x46>
  800d8c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800d91:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800d96:	75 d2                	jne    800d6a <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800d98:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800d9e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800da3:	eb 07                	jmp    800dac <fd_alloc+0x4d>
			*fd_store = fd;
  800da5:	89 01                	mov    %eax,(%ecx)
			return 0;
  800da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    

00800dae <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800db4:	83 f8 1f             	cmp    $0x1f,%eax
  800db7:	77 36                	ja     800def <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800db9:	c1 e0 0c             	shl    $0xc,%eax
  800dbc:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800dc1:	89 c2                	mov    %eax,%edx
  800dc3:	c1 ea 16             	shr    $0x16,%edx
  800dc6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dcd:	f6 c2 01             	test   $0x1,%dl
  800dd0:	74 24                	je     800df6 <fd_lookup+0x48>
  800dd2:	89 c2                	mov    %eax,%edx
  800dd4:	c1 ea 0c             	shr    $0xc,%edx
  800dd7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dde:	f6 c2 01             	test   $0x1,%dl
  800de1:	74 1a                	je     800dfd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de6:	89 02                	mov    %eax,(%edx)
	return 0;
  800de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    
		return -E_INVAL;
  800def:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800df4:	eb f7                	jmp    800ded <fd_lookup+0x3f>
		return -E_INVAL;
  800df6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dfb:	eb f0                	jmp    800ded <fd_lookup+0x3f>
  800dfd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e02:	eb e9                	jmp    800ded <fd_lookup+0x3f>

00800e04 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 08             	sub    $0x8,%esp
  800e0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0d:	ba 08 21 80 00       	mov    $0x802108,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e12:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e17:	39 08                	cmp    %ecx,(%eax)
  800e19:	74 33                	je     800e4e <dev_lookup+0x4a>
  800e1b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800e1e:	8b 02                	mov    (%edx),%eax
  800e20:	85 c0                	test   %eax,%eax
  800e22:	75 f3                	jne    800e17 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e24:	a1 04 40 80 00       	mov    0x804004,%eax
  800e29:	8b 40 48             	mov    0x48(%eax),%eax
  800e2c:	83 ec 04             	sub    $0x4,%esp
  800e2f:	51                   	push   %ecx
  800e30:	50                   	push   %eax
  800e31:	68 8c 20 80 00       	push   $0x80208c
  800e36:	e8 29 f3 ff ff       	call   800164 <cprintf>
	*dev = 0;
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e44:	83 c4 10             	add    $0x10,%esp
  800e47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    
			*dev = devtab[i];
  800e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e51:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e53:	b8 00 00 00 00       	mov    $0x0,%eax
  800e58:	eb f2                	jmp    800e4c <dev_lookup+0x48>

00800e5a <fd_close>:
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	57                   	push   %edi
  800e5e:	56                   	push   %esi
  800e5f:	53                   	push   %ebx
  800e60:	83 ec 1c             	sub    $0x1c,%esp
  800e63:	8b 75 08             	mov    0x8(%ebp),%esi
  800e66:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e69:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e6c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e6d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800e73:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e76:	50                   	push   %eax
  800e77:	e8 32 ff ff ff       	call   800dae <fd_lookup>
  800e7c:	89 c3                	mov    %eax,%ebx
  800e7e:	83 c4 08             	add    $0x8,%esp
  800e81:	85 c0                	test   %eax,%eax
  800e83:	78 05                	js     800e8a <fd_close+0x30>
	    || fd != fd2)
  800e85:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800e88:	74 16                	je     800ea0 <fd_close+0x46>
		return (must_exist ? r : 0);
  800e8a:	89 f8                	mov    %edi,%eax
  800e8c:	84 c0                	test   %al,%al
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800e93:	0f 44 d8             	cmove  %eax,%ebx
}
  800e96:	89 d8                	mov    %ebx,%eax
  800e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ea6:	50                   	push   %eax
  800ea7:	ff 36                	pushl  (%esi)
  800ea9:	e8 56 ff ff ff       	call   800e04 <dev_lookup>
  800eae:	89 c3                	mov    %eax,%ebx
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	78 15                	js     800ecc <fd_close+0x72>
		if (dev->dev_close)
  800eb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eba:	8b 40 10             	mov    0x10(%eax),%eax
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	74 1b                	je     800edc <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800ec1:	83 ec 0c             	sub    $0xc,%esp
  800ec4:	56                   	push   %esi
  800ec5:	ff d0                	call   *%eax
  800ec7:	89 c3                	mov    %eax,%ebx
  800ec9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800ecc:	83 ec 08             	sub    $0x8,%esp
  800ecf:	56                   	push   %esi
  800ed0:	6a 00                	push   $0x0
  800ed2:	e8 f5 fc ff ff       	call   800bcc <sys_page_unmap>
	return r;
  800ed7:	83 c4 10             	add    $0x10,%esp
  800eda:	eb ba                	jmp    800e96 <fd_close+0x3c>
			r = 0;
  800edc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee1:	eb e9                	jmp    800ecc <fd_close+0x72>

00800ee3 <close>:

int
close(int fdnum)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ee9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800eec:	50                   	push   %eax
  800eed:	ff 75 08             	pushl  0x8(%ebp)
  800ef0:	e8 b9 fe ff ff       	call   800dae <fd_lookup>
  800ef5:	83 c4 08             	add    $0x8,%esp
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	78 10                	js     800f0c <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800efc:	83 ec 08             	sub    $0x8,%esp
  800eff:	6a 01                	push   $0x1
  800f01:	ff 75 f4             	pushl  -0xc(%ebp)
  800f04:	e8 51 ff ff ff       	call   800e5a <fd_close>
  800f09:	83 c4 10             	add    $0x10,%esp
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <close_all>:

void
close_all(void)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	53                   	push   %ebx
  800f12:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f15:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f1a:	83 ec 0c             	sub    $0xc,%esp
  800f1d:	53                   	push   %ebx
  800f1e:	e8 c0 ff ff ff       	call   800ee3 <close>
	for (i = 0; i < MAXFD; i++)
  800f23:	83 c3 01             	add    $0x1,%ebx
  800f26:	83 c4 10             	add    $0x10,%esp
  800f29:	83 fb 20             	cmp    $0x20,%ebx
  800f2c:	75 ec                	jne    800f1a <close_all+0xc>
}
  800f2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f31:	c9                   	leave  
  800f32:	c3                   	ret    

00800f33 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	57                   	push   %edi
  800f37:	56                   	push   %esi
  800f38:	53                   	push   %ebx
  800f39:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f3c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f3f:	50                   	push   %eax
  800f40:	ff 75 08             	pushl  0x8(%ebp)
  800f43:	e8 66 fe ff ff       	call   800dae <fd_lookup>
  800f48:	89 c3                	mov    %eax,%ebx
  800f4a:	83 c4 08             	add    $0x8,%esp
  800f4d:	85 c0                	test   %eax,%eax
  800f4f:	0f 88 81 00 00 00    	js     800fd6 <dup+0xa3>
		return r;
	close(newfdnum);
  800f55:	83 ec 0c             	sub    $0xc,%esp
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	e8 83 ff ff ff       	call   800ee3 <close>

	newfd = INDEX2FD(newfdnum);
  800f60:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f63:	c1 e6 0c             	shl    $0xc,%esi
  800f66:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f6c:	83 c4 04             	add    $0x4,%esp
  800f6f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f72:	e8 d1 fd ff ff       	call   800d48 <fd2data>
  800f77:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f79:	89 34 24             	mov    %esi,(%esp)
  800f7c:	e8 c7 fd ff ff       	call   800d48 <fd2data>
  800f81:	83 c4 10             	add    $0x10,%esp
  800f84:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800f86:	89 d8                	mov    %ebx,%eax
  800f88:	c1 e8 16             	shr    $0x16,%eax
  800f8b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f92:	a8 01                	test   $0x1,%al
  800f94:	74 11                	je     800fa7 <dup+0x74>
  800f96:	89 d8                	mov    %ebx,%eax
  800f98:	c1 e8 0c             	shr    $0xc,%eax
  800f9b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fa2:	f6 c2 01             	test   $0x1,%dl
  800fa5:	75 39                	jne    800fe0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fa7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800faa:	89 d0                	mov    %edx,%eax
  800fac:	c1 e8 0c             	shr    $0xc,%eax
  800faf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fb6:	83 ec 0c             	sub    $0xc,%esp
  800fb9:	25 07 0e 00 00       	and    $0xe07,%eax
  800fbe:	50                   	push   %eax
  800fbf:	56                   	push   %esi
  800fc0:	6a 00                	push   $0x0
  800fc2:	52                   	push   %edx
  800fc3:	6a 00                	push   $0x0
  800fc5:	e8 c0 fb ff ff       	call   800b8a <sys_page_map>
  800fca:	89 c3                	mov    %eax,%ebx
  800fcc:	83 c4 20             	add    $0x20,%esp
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	78 31                	js     801004 <dup+0xd1>
		goto err;

	return newfdnum;
  800fd3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800fd6:	89 d8                	mov    %ebx,%eax
  800fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800fe0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fe7:	83 ec 0c             	sub    $0xc,%esp
  800fea:	25 07 0e 00 00       	and    $0xe07,%eax
  800fef:	50                   	push   %eax
  800ff0:	57                   	push   %edi
  800ff1:	6a 00                	push   $0x0
  800ff3:	53                   	push   %ebx
  800ff4:	6a 00                	push   $0x0
  800ff6:	e8 8f fb ff ff       	call   800b8a <sys_page_map>
  800ffb:	89 c3                	mov    %eax,%ebx
  800ffd:	83 c4 20             	add    $0x20,%esp
  801000:	85 c0                	test   %eax,%eax
  801002:	79 a3                	jns    800fa7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801004:	83 ec 08             	sub    $0x8,%esp
  801007:	56                   	push   %esi
  801008:	6a 00                	push   $0x0
  80100a:	e8 bd fb ff ff       	call   800bcc <sys_page_unmap>
	sys_page_unmap(0, nva);
  80100f:	83 c4 08             	add    $0x8,%esp
  801012:	57                   	push   %edi
  801013:	6a 00                	push   $0x0
  801015:	e8 b2 fb ff ff       	call   800bcc <sys_page_unmap>
	return r;
  80101a:	83 c4 10             	add    $0x10,%esp
  80101d:	eb b7                	jmp    800fd6 <dup+0xa3>

0080101f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	53                   	push   %ebx
  801023:	83 ec 14             	sub    $0x14,%esp
  801026:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801029:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80102c:	50                   	push   %eax
  80102d:	53                   	push   %ebx
  80102e:	e8 7b fd ff ff       	call   800dae <fd_lookup>
  801033:	83 c4 08             	add    $0x8,%esp
  801036:	85 c0                	test   %eax,%eax
  801038:	78 3f                	js     801079 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801040:	50                   	push   %eax
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	ff 30                	pushl  (%eax)
  801046:	e8 b9 fd ff ff       	call   800e04 <dev_lookup>
  80104b:	83 c4 10             	add    $0x10,%esp
  80104e:	85 c0                	test   %eax,%eax
  801050:	78 27                	js     801079 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801052:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801055:	8b 42 08             	mov    0x8(%edx),%eax
  801058:	83 e0 03             	and    $0x3,%eax
  80105b:	83 f8 01             	cmp    $0x1,%eax
  80105e:	74 1e                	je     80107e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801063:	8b 40 08             	mov    0x8(%eax),%eax
  801066:	85 c0                	test   %eax,%eax
  801068:	74 35                	je     80109f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80106a:	83 ec 04             	sub    $0x4,%esp
  80106d:	ff 75 10             	pushl  0x10(%ebp)
  801070:	ff 75 0c             	pushl  0xc(%ebp)
  801073:	52                   	push   %edx
  801074:	ff d0                	call   *%eax
  801076:	83 c4 10             	add    $0x10,%esp
}
  801079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80107e:	a1 04 40 80 00       	mov    0x804004,%eax
  801083:	8b 40 48             	mov    0x48(%eax),%eax
  801086:	83 ec 04             	sub    $0x4,%esp
  801089:	53                   	push   %ebx
  80108a:	50                   	push   %eax
  80108b:	68 cd 20 80 00       	push   $0x8020cd
  801090:	e8 cf f0 ff ff       	call   800164 <cprintf>
		return -E_INVAL;
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80109d:	eb da                	jmp    801079 <read+0x5a>
		return -E_NOT_SUPP;
  80109f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8010a4:	eb d3                	jmp    801079 <read+0x5a>

008010a6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	57                   	push   %edi
  8010aa:	56                   	push   %esi
  8010ab:	53                   	push   %ebx
  8010ac:	83 ec 0c             	sub    $0xc,%esp
  8010af:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010b2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ba:	39 f3                	cmp    %esi,%ebx
  8010bc:	73 25                	jae    8010e3 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010be:	83 ec 04             	sub    $0x4,%esp
  8010c1:	89 f0                	mov    %esi,%eax
  8010c3:	29 d8                	sub    %ebx,%eax
  8010c5:	50                   	push   %eax
  8010c6:	89 d8                	mov    %ebx,%eax
  8010c8:	03 45 0c             	add    0xc(%ebp),%eax
  8010cb:	50                   	push   %eax
  8010cc:	57                   	push   %edi
  8010cd:	e8 4d ff ff ff       	call   80101f <read>
		if (m < 0)
  8010d2:	83 c4 10             	add    $0x10,%esp
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	78 08                	js     8010e1 <readn+0x3b>
			return m;
		if (m == 0)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	74 06                	je     8010e3 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8010dd:	01 c3                	add    %eax,%ebx
  8010df:	eb d9                	jmp    8010ba <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010e1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8010e3:	89 d8                	mov    %ebx,%eax
  8010e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e8:	5b                   	pop    %ebx
  8010e9:	5e                   	pop    %esi
  8010ea:	5f                   	pop    %edi
  8010eb:	5d                   	pop    %ebp
  8010ec:	c3                   	ret    

008010ed <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	53                   	push   %ebx
  8010f1:	83 ec 14             	sub    $0x14,%esp
  8010f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010fa:	50                   	push   %eax
  8010fb:	53                   	push   %ebx
  8010fc:	e8 ad fc ff ff       	call   800dae <fd_lookup>
  801101:	83 c4 08             	add    $0x8,%esp
  801104:	85 c0                	test   %eax,%eax
  801106:	78 3a                	js     801142 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801108:	83 ec 08             	sub    $0x8,%esp
  80110b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80110e:	50                   	push   %eax
  80110f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801112:	ff 30                	pushl  (%eax)
  801114:	e8 eb fc ff ff       	call   800e04 <dev_lookup>
  801119:	83 c4 10             	add    $0x10,%esp
  80111c:	85 c0                	test   %eax,%eax
  80111e:	78 22                	js     801142 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801123:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801127:	74 1e                	je     801147 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801129:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112c:	8b 52 0c             	mov    0xc(%edx),%edx
  80112f:	85 d2                	test   %edx,%edx
  801131:	74 35                	je     801168 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801133:	83 ec 04             	sub    $0x4,%esp
  801136:	ff 75 10             	pushl  0x10(%ebp)
  801139:	ff 75 0c             	pushl  0xc(%ebp)
  80113c:	50                   	push   %eax
  80113d:	ff d2                	call   *%edx
  80113f:	83 c4 10             	add    $0x10,%esp
}
  801142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801145:	c9                   	leave  
  801146:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801147:	a1 04 40 80 00       	mov    0x804004,%eax
  80114c:	8b 40 48             	mov    0x48(%eax),%eax
  80114f:	83 ec 04             	sub    $0x4,%esp
  801152:	53                   	push   %ebx
  801153:	50                   	push   %eax
  801154:	68 e9 20 80 00       	push   $0x8020e9
  801159:	e8 06 f0 ff ff       	call   800164 <cprintf>
		return -E_INVAL;
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801166:	eb da                	jmp    801142 <write+0x55>
		return -E_NOT_SUPP;
  801168:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80116d:	eb d3                	jmp    801142 <write+0x55>

0080116f <seek>:

int
seek(int fdnum, off_t offset)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801175:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801178:	50                   	push   %eax
  801179:	ff 75 08             	pushl  0x8(%ebp)
  80117c:	e8 2d fc ff ff       	call   800dae <fd_lookup>
  801181:	83 c4 08             	add    $0x8,%esp
  801184:	85 c0                	test   %eax,%eax
  801186:	78 0e                	js     801196 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80118b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801191:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801196:	c9                   	leave  
  801197:	c3                   	ret    

00801198 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	53                   	push   %ebx
  80119c:	83 ec 14             	sub    $0x14,%esp
  80119f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a5:	50                   	push   %eax
  8011a6:	53                   	push   %ebx
  8011a7:	e8 02 fc ff ff       	call   800dae <fd_lookup>
  8011ac:	83 c4 08             	add    $0x8,%esp
  8011af:	85 c0                	test   %eax,%eax
  8011b1:	78 37                	js     8011ea <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011b3:	83 ec 08             	sub    $0x8,%esp
  8011b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b9:	50                   	push   %eax
  8011ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bd:	ff 30                	pushl  (%eax)
  8011bf:	e8 40 fc ff ff       	call   800e04 <dev_lookup>
  8011c4:	83 c4 10             	add    $0x10,%esp
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	78 1f                	js     8011ea <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ce:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011d2:	74 1b                	je     8011ef <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8011d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d7:	8b 52 18             	mov    0x18(%edx),%edx
  8011da:	85 d2                	test   %edx,%edx
  8011dc:	74 32                	je     801210 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8011de:	83 ec 08             	sub    $0x8,%esp
  8011e1:	ff 75 0c             	pushl  0xc(%ebp)
  8011e4:	50                   	push   %eax
  8011e5:	ff d2                	call   *%edx
  8011e7:	83 c4 10             	add    $0x10,%esp
}
  8011ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    
			thisenv->env_id, fdnum);
  8011ef:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8011f4:	8b 40 48             	mov    0x48(%eax),%eax
  8011f7:	83 ec 04             	sub    $0x4,%esp
  8011fa:	53                   	push   %ebx
  8011fb:	50                   	push   %eax
  8011fc:	68 ac 20 80 00       	push   $0x8020ac
  801201:	e8 5e ef ff ff       	call   800164 <cprintf>
		return -E_INVAL;
  801206:	83 c4 10             	add    $0x10,%esp
  801209:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80120e:	eb da                	jmp    8011ea <ftruncate+0x52>
		return -E_NOT_SUPP;
  801210:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801215:	eb d3                	jmp    8011ea <ftruncate+0x52>

00801217 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	53                   	push   %ebx
  80121b:	83 ec 14             	sub    $0x14,%esp
  80121e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801221:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801224:	50                   	push   %eax
  801225:	ff 75 08             	pushl  0x8(%ebp)
  801228:	e8 81 fb ff ff       	call   800dae <fd_lookup>
  80122d:	83 c4 08             	add    $0x8,%esp
  801230:	85 c0                	test   %eax,%eax
  801232:	78 4b                	js     80127f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801234:	83 ec 08             	sub    $0x8,%esp
  801237:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80123a:	50                   	push   %eax
  80123b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123e:	ff 30                	pushl  (%eax)
  801240:	e8 bf fb ff ff       	call   800e04 <dev_lookup>
  801245:	83 c4 10             	add    $0x10,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	78 33                	js     80127f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80124c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801253:	74 2f                	je     801284 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801255:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801258:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80125f:	00 00 00 
	stat->st_isdir = 0;
  801262:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801269:	00 00 00 
	stat->st_dev = dev;
  80126c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801272:	83 ec 08             	sub    $0x8,%esp
  801275:	53                   	push   %ebx
  801276:	ff 75 f0             	pushl  -0x10(%ebp)
  801279:	ff 50 14             	call   *0x14(%eax)
  80127c:	83 c4 10             	add    $0x10,%esp
}
  80127f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801282:	c9                   	leave  
  801283:	c3                   	ret    
		return -E_NOT_SUPP;
  801284:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801289:	eb f4                	jmp    80127f <fstat+0x68>

0080128b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	56                   	push   %esi
  80128f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801290:	83 ec 08             	sub    $0x8,%esp
  801293:	6a 00                	push   $0x0
  801295:	ff 75 08             	pushl  0x8(%ebp)
  801298:	e8 e7 01 00 00       	call   801484 <open>
  80129d:	89 c3                	mov    %eax,%ebx
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	85 c0                	test   %eax,%eax
  8012a4:	78 1b                	js     8012c1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	ff 75 0c             	pushl  0xc(%ebp)
  8012ac:	50                   	push   %eax
  8012ad:	e8 65 ff ff ff       	call   801217 <fstat>
  8012b2:	89 c6                	mov    %eax,%esi
	close(fd);
  8012b4:	89 1c 24             	mov    %ebx,(%esp)
  8012b7:	e8 27 fc ff ff       	call   800ee3 <close>
	return r;
  8012bc:	83 c4 10             	add    $0x10,%esp
  8012bf:	89 f3                	mov    %esi,%ebx
}
  8012c1:	89 d8                	mov    %ebx,%eax
  8012c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012c6:	5b                   	pop    %ebx
  8012c7:	5e                   	pop    %esi
  8012c8:	5d                   	pop    %ebp
  8012c9:	c3                   	ret    

008012ca <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	56                   	push   %esi
  8012ce:	53                   	push   %ebx
  8012cf:	89 c6                	mov    %eax,%esi
  8012d1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8012d3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8012da:	74 27                	je     801303 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8012dc:	6a 07                	push   $0x7
  8012de:	68 00 50 80 00       	push   $0x805000
  8012e3:	56                   	push   %esi
  8012e4:	ff 35 00 40 80 00    	pushl  0x804000
  8012ea:	e8 61 07 00 00       	call   801a50 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8012ef:	83 c4 0c             	add    $0xc,%esp
  8012f2:	6a 00                	push   $0x0
  8012f4:	53                   	push   %ebx
  8012f5:	6a 00                	push   $0x0
  8012f7:	e8 3d 07 00 00       	call   801a39 <ipc_recv>
}
  8012fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ff:	5b                   	pop    %ebx
  801300:	5e                   	pop    %esi
  801301:	5d                   	pop    %ebp
  801302:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801303:	83 ec 0c             	sub    $0xc,%esp
  801306:	6a 01                	push   $0x1
  801308:	e8 5a 07 00 00       	call   801a67 <ipc_find_env>
  80130d:	a3 00 40 80 00       	mov    %eax,0x804000
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	eb c5                	jmp    8012dc <fsipc+0x12>

00801317 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8b 40 0c             	mov    0xc(%eax),%eax
  801323:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801330:	ba 00 00 00 00       	mov    $0x0,%edx
  801335:	b8 02 00 00 00       	mov    $0x2,%eax
  80133a:	e8 8b ff ff ff       	call   8012ca <fsipc>
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <devfile_flush>:
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	8b 40 0c             	mov    0xc(%eax),%eax
  80134d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801352:	ba 00 00 00 00       	mov    $0x0,%edx
  801357:	b8 06 00 00 00       	mov    $0x6,%eax
  80135c:	e8 69 ff ff ff       	call   8012ca <fsipc>
}
  801361:	c9                   	leave  
  801362:	c3                   	ret    

00801363 <devfile_stat>:
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	53                   	push   %ebx
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	8b 40 0c             	mov    0xc(%eax),%eax
  801373:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801378:	ba 00 00 00 00       	mov    $0x0,%edx
  80137d:	b8 05 00 00 00       	mov    $0x5,%eax
  801382:	e8 43 ff ff ff       	call   8012ca <fsipc>
  801387:	85 c0                	test   %eax,%eax
  801389:	78 2c                	js     8013b7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80138b:	83 ec 08             	sub    $0x8,%esp
  80138e:	68 00 50 80 00       	push   $0x805000
  801393:	53                   	push   %ebx
  801394:	e8 b5 f3 ff ff       	call   80074e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801399:	a1 80 50 80 00       	mov    0x805080,%eax
  80139e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013a4:	a1 84 50 80 00       	mov    0x805084,%eax
  8013a9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <devfile_write>:
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 0c             	sub    $0xc,%esp
  8013c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c5:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8013ca:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8013cf:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8013d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d5:	8b 52 0c             	mov    0xc(%edx),%edx
  8013d8:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8013de:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8013e3:	50                   	push   %eax
  8013e4:	ff 75 0c             	pushl  0xc(%ebp)
  8013e7:	68 08 50 80 00       	push   $0x805008
  8013ec:	e8 eb f4 ff ff       	call   8008dc <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8013f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f6:	b8 04 00 00 00       	mov    $0x4,%eax
  8013fb:	e8 ca fe ff ff       	call   8012ca <fsipc>
}
  801400:	c9                   	leave  
  801401:	c3                   	ret    

00801402 <devfile_read>:
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	56                   	push   %esi
  801406:	53                   	push   %ebx
  801407:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8b 40 0c             	mov    0xc(%eax),%eax
  801410:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801415:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80141b:	ba 00 00 00 00       	mov    $0x0,%edx
  801420:	b8 03 00 00 00       	mov    $0x3,%eax
  801425:	e8 a0 fe ff ff       	call   8012ca <fsipc>
  80142a:	89 c3                	mov    %eax,%ebx
  80142c:	85 c0                	test   %eax,%eax
  80142e:	78 1f                	js     80144f <devfile_read+0x4d>
	assert(r <= n);
  801430:	39 f0                	cmp    %esi,%eax
  801432:	77 24                	ja     801458 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801434:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801439:	7f 33                	jg     80146e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80143b:	83 ec 04             	sub    $0x4,%esp
  80143e:	50                   	push   %eax
  80143f:	68 00 50 80 00       	push   $0x805000
  801444:	ff 75 0c             	pushl  0xc(%ebp)
  801447:	e8 90 f4 ff ff       	call   8008dc <memmove>
	return r;
  80144c:	83 c4 10             	add    $0x10,%esp
}
  80144f:	89 d8                	mov    %ebx,%eax
  801451:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801454:	5b                   	pop    %ebx
  801455:	5e                   	pop    %esi
  801456:	5d                   	pop    %ebp
  801457:	c3                   	ret    
	assert(r <= n);
  801458:	68 18 21 80 00       	push   $0x802118
  80145d:	68 1f 21 80 00       	push   $0x80211f
  801462:	6a 7c                	push   $0x7c
  801464:	68 34 21 80 00       	push   $0x802134
  801469:	e8 85 05 00 00       	call   8019f3 <_panic>
	assert(r <= PGSIZE);
  80146e:	68 3f 21 80 00       	push   $0x80213f
  801473:	68 1f 21 80 00       	push   $0x80211f
  801478:	6a 7d                	push   $0x7d
  80147a:	68 34 21 80 00       	push   $0x802134
  80147f:	e8 6f 05 00 00       	call   8019f3 <_panic>

00801484 <open>:
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	56                   	push   %esi
  801488:	53                   	push   %ebx
  801489:	83 ec 1c             	sub    $0x1c,%esp
  80148c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80148f:	56                   	push   %esi
  801490:	e8 82 f2 ff ff       	call   800717 <strlen>
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80149d:	7f 6c                	jg     80150b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80149f:	83 ec 0c             	sub    $0xc,%esp
  8014a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a5:	50                   	push   %eax
  8014a6:	e8 b4 f8 ff ff       	call   800d5f <fd_alloc>
  8014ab:	89 c3                	mov    %eax,%ebx
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	78 3c                	js     8014f0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8014b4:	83 ec 08             	sub    $0x8,%esp
  8014b7:	56                   	push   %esi
  8014b8:	68 00 50 80 00       	push   $0x805000
  8014bd:	e8 8c f2 ff ff       	call   80074e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8014c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8014ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8014d2:	e8 f3 fd ff ff       	call   8012ca <fsipc>
  8014d7:	89 c3                	mov    %eax,%ebx
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 19                	js     8014f9 <open+0x75>
	return fd2num(fd);
  8014e0:	83 ec 0c             	sub    $0xc,%esp
  8014e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8014e6:	e8 4d f8 ff ff       	call   800d38 <fd2num>
  8014eb:	89 c3                	mov    %eax,%ebx
  8014ed:	83 c4 10             	add    $0x10,%esp
}
  8014f0:	89 d8                	mov    %ebx,%eax
  8014f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014f5:	5b                   	pop    %ebx
  8014f6:	5e                   	pop    %esi
  8014f7:	5d                   	pop    %ebp
  8014f8:	c3                   	ret    
		fd_close(fd, 0);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	6a 00                	push   $0x0
  8014fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801501:	e8 54 f9 ff ff       	call   800e5a <fd_close>
		return r;
  801506:	83 c4 10             	add    $0x10,%esp
  801509:	eb e5                	jmp    8014f0 <open+0x6c>
		return -E_BAD_PATH;
  80150b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801510:	eb de                	jmp    8014f0 <open+0x6c>

00801512 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801518:	ba 00 00 00 00       	mov    $0x0,%edx
  80151d:	b8 08 00 00 00       	mov    $0x8,%eax
  801522:	e8 a3 fd ff ff       	call   8012ca <fsipc>
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	56                   	push   %esi
  80152d:	53                   	push   %ebx
  80152e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801531:	83 ec 0c             	sub    $0xc,%esp
  801534:	ff 75 08             	pushl  0x8(%ebp)
  801537:	e8 0c f8 ff ff       	call   800d48 <fd2data>
  80153c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80153e:	83 c4 08             	add    $0x8,%esp
  801541:	68 4b 21 80 00       	push   $0x80214b
  801546:	53                   	push   %ebx
  801547:	e8 02 f2 ff ff       	call   80074e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80154c:	8b 46 04             	mov    0x4(%esi),%eax
  80154f:	2b 06                	sub    (%esi),%eax
  801551:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801557:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80155e:	00 00 00 
	stat->st_dev = &devpipe;
  801561:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801568:	30 80 00 
	return 0;
}
  80156b:	b8 00 00 00 00       	mov    $0x0,%eax
  801570:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801573:	5b                   	pop    %ebx
  801574:	5e                   	pop    %esi
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    

00801577 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	53                   	push   %ebx
  80157b:	83 ec 0c             	sub    $0xc,%esp
  80157e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801581:	53                   	push   %ebx
  801582:	6a 00                	push   $0x0
  801584:	e8 43 f6 ff ff       	call   800bcc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801589:	89 1c 24             	mov    %ebx,(%esp)
  80158c:	e8 b7 f7 ff ff       	call   800d48 <fd2data>
  801591:	83 c4 08             	add    $0x8,%esp
  801594:	50                   	push   %eax
  801595:	6a 00                	push   $0x0
  801597:	e8 30 f6 ff ff       	call   800bcc <sys_page_unmap>
}
  80159c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <_pipeisclosed>:
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	57                   	push   %edi
  8015a5:	56                   	push   %esi
  8015a6:	53                   	push   %ebx
  8015a7:	83 ec 1c             	sub    $0x1c,%esp
  8015aa:	89 c7                	mov    %eax,%edi
  8015ac:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8015ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8015b3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8015b6:	83 ec 0c             	sub    $0xc,%esp
  8015b9:	57                   	push   %edi
  8015ba:	e8 e1 04 00 00       	call   801aa0 <pageref>
  8015bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015c2:	89 34 24             	mov    %esi,(%esp)
  8015c5:	e8 d6 04 00 00       	call   801aa0 <pageref>
		nn = thisenv->env_runs;
  8015ca:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8015d0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8015d3:	83 c4 10             	add    $0x10,%esp
  8015d6:	39 cb                	cmp    %ecx,%ebx
  8015d8:	74 1b                	je     8015f5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8015da:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015dd:	75 cf                	jne    8015ae <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8015df:	8b 42 58             	mov    0x58(%edx),%eax
  8015e2:	6a 01                	push   $0x1
  8015e4:	50                   	push   %eax
  8015e5:	53                   	push   %ebx
  8015e6:	68 52 21 80 00       	push   $0x802152
  8015eb:	e8 74 eb ff ff       	call   800164 <cprintf>
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	eb b9                	jmp    8015ae <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8015f5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015f8:	0f 94 c0             	sete   %al
  8015fb:	0f b6 c0             	movzbl %al,%eax
}
  8015fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801601:	5b                   	pop    %ebx
  801602:	5e                   	pop    %esi
  801603:	5f                   	pop    %edi
  801604:	5d                   	pop    %ebp
  801605:	c3                   	ret    

00801606 <devpipe_write>:
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	57                   	push   %edi
  80160a:	56                   	push   %esi
  80160b:	53                   	push   %ebx
  80160c:	83 ec 28             	sub    $0x28,%esp
  80160f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801612:	56                   	push   %esi
  801613:	e8 30 f7 ff ff       	call   800d48 <fd2data>
  801618:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	bf 00 00 00 00       	mov    $0x0,%edi
  801622:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801625:	74 4f                	je     801676 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801627:	8b 43 04             	mov    0x4(%ebx),%eax
  80162a:	8b 0b                	mov    (%ebx),%ecx
  80162c:	8d 51 20             	lea    0x20(%ecx),%edx
  80162f:	39 d0                	cmp    %edx,%eax
  801631:	72 14                	jb     801647 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801633:	89 da                	mov    %ebx,%edx
  801635:	89 f0                	mov    %esi,%eax
  801637:	e8 65 ff ff ff       	call   8015a1 <_pipeisclosed>
  80163c:	85 c0                	test   %eax,%eax
  80163e:	75 3a                	jne    80167a <devpipe_write+0x74>
			sys_yield();
  801640:	e8 e3 f4 ff ff       	call   800b28 <sys_yield>
  801645:	eb e0                	jmp    801627 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801647:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80164a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80164e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801651:	89 c2                	mov    %eax,%edx
  801653:	c1 fa 1f             	sar    $0x1f,%edx
  801656:	89 d1                	mov    %edx,%ecx
  801658:	c1 e9 1b             	shr    $0x1b,%ecx
  80165b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80165e:	83 e2 1f             	and    $0x1f,%edx
  801661:	29 ca                	sub    %ecx,%edx
  801663:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801667:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80166b:	83 c0 01             	add    $0x1,%eax
  80166e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801671:	83 c7 01             	add    $0x1,%edi
  801674:	eb ac                	jmp    801622 <devpipe_write+0x1c>
	return i;
  801676:	89 f8                	mov    %edi,%eax
  801678:	eb 05                	jmp    80167f <devpipe_write+0x79>
				return 0;
  80167a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801682:	5b                   	pop    %ebx
  801683:	5e                   	pop    %esi
  801684:	5f                   	pop    %edi
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    

00801687 <devpipe_read>:
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	57                   	push   %edi
  80168b:	56                   	push   %esi
  80168c:	53                   	push   %ebx
  80168d:	83 ec 18             	sub    $0x18,%esp
  801690:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801693:	57                   	push   %edi
  801694:	e8 af f6 ff ff       	call   800d48 <fd2data>
  801699:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	be 00 00 00 00       	mov    $0x0,%esi
  8016a3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8016a6:	74 47                	je     8016ef <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8016a8:	8b 03                	mov    (%ebx),%eax
  8016aa:	3b 43 04             	cmp    0x4(%ebx),%eax
  8016ad:	75 22                	jne    8016d1 <devpipe_read+0x4a>
			if (i > 0)
  8016af:	85 f6                	test   %esi,%esi
  8016b1:	75 14                	jne    8016c7 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8016b3:	89 da                	mov    %ebx,%edx
  8016b5:	89 f8                	mov    %edi,%eax
  8016b7:	e8 e5 fe ff ff       	call   8015a1 <_pipeisclosed>
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	75 33                	jne    8016f3 <devpipe_read+0x6c>
			sys_yield();
  8016c0:	e8 63 f4 ff ff       	call   800b28 <sys_yield>
  8016c5:	eb e1                	jmp    8016a8 <devpipe_read+0x21>
				return i;
  8016c7:	89 f0                	mov    %esi,%eax
}
  8016c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016cc:	5b                   	pop    %ebx
  8016cd:	5e                   	pop    %esi
  8016ce:	5f                   	pop    %edi
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8016d1:	99                   	cltd   
  8016d2:	c1 ea 1b             	shr    $0x1b,%edx
  8016d5:	01 d0                	add    %edx,%eax
  8016d7:	83 e0 1f             	and    $0x1f,%eax
  8016da:	29 d0                	sub    %edx,%eax
  8016dc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8016e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8016e7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8016ea:	83 c6 01             	add    $0x1,%esi
  8016ed:	eb b4                	jmp    8016a3 <devpipe_read+0x1c>
	return i;
  8016ef:	89 f0                	mov    %esi,%eax
  8016f1:	eb d6                	jmp    8016c9 <devpipe_read+0x42>
				return 0;
  8016f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f8:	eb cf                	jmp    8016c9 <devpipe_read+0x42>

008016fa <pipe>:
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	56                   	push   %esi
  8016fe:	53                   	push   %ebx
  8016ff:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801702:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801705:	50                   	push   %eax
  801706:	e8 54 f6 ff ff       	call   800d5f <fd_alloc>
  80170b:	89 c3                	mov    %eax,%ebx
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	85 c0                	test   %eax,%eax
  801712:	78 5b                	js     80176f <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801714:	83 ec 04             	sub    $0x4,%esp
  801717:	68 07 04 00 00       	push   $0x407
  80171c:	ff 75 f4             	pushl  -0xc(%ebp)
  80171f:	6a 00                	push   $0x0
  801721:	e8 21 f4 ff ff       	call   800b47 <sys_page_alloc>
  801726:	89 c3                	mov    %eax,%ebx
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 40                	js     80176f <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80172f:	83 ec 0c             	sub    $0xc,%esp
  801732:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801735:	50                   	push   %eax
  801736:	e8 24 f6 ff ff       	call   800d5f <fd_alloc>
  80173b:	89 c3                	mov    %eax,%ebx
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	78 1b                	js     80175f <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801744:	83 ec 04             	sub    $0x4,%esp
  801747:	68 07 04 00 00       	push   $0x407
  80174c:	ff 75 f0             	pushl  -0x10(%ebp)
  80174f:	6a 00                	push   $0x0
  801751:	e8 f1 f3 ff ff       	call   800b47 <sys_page_alloc>
  801756:	89 c3                	mov    %eax,%ebx
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	85 c0                	test   %eax,%eax
  80175d:	79 19                	jns    801778 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80175f:	83 ec 08             	sub    $0x8,%esp
  801762:	ff 75 f4             	pushl  -0xc(%ebp)
  801765:	6a 00                	push   $0x0
  801767:	e8 60 f4 ff ff       	call   800bcc <sys_page_unmap>
  80176c:	83 c4 10             	add    $0x10,%esp
}
  80176f:	89 d8                	mov    %ebx,%eax
  801771:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801774:	5b                   	pop    %ebx
  801775:	5e                   	pop    %esi
  801776:	5d                   	pop    %ebp
  801777:	c3                   	ret    
	va = fd2data(fd0);
  801778:	83 ec 0c             	sub    $0xc,%esp
  80177b:	ff 75 f4             	pushl  -0xc(%ebp)
  80177e:	e8 c5 f5 ff ff       	call   800d48 <fd2data>
  801783:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801785:	83 c4 0c             	add    $0xc,%esp
  801788:	68 07 04 00 00       	push   $0x407
  80178d:	50                   	push   %eax
  80178e:	6a 00                	push   $0x0
  801790:	e8 b2 f3 ff ff       	call   800b47 <sys_page_alloc>
  801795:	89 c3                	mov    %eax,%ebx
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	85 c0                	test   %eax,%eax
  80179c:	0f 88 8c 00 00 00    	js     80182e <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017a2:	83 ec 0c             	sub    $0xc,%esp
  8017a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8017a8:	e8 9b f5 ff ff       	call   800d48 <fd2data>
  8017ad:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017b4:	50                   	push   %eax
  8017b5:	6a 00                	push   $0x0
  8017b7:	56                   	push   %esi
  8017b8:	6a 00                	push   $0x0
  8017ba:	e8 cb f3 ff ff       	call   800b8a <sys_page_map>
  8017bf:	89 c3                	mov    %eax,%ebx
  8017c1:	83 c4 20             	add    $0x20,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 58                	js     801820 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8017c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cb:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017d1:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8017d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8017dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8017e6:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017eb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8017f2:	83 ec 0c             	sub    $0xc,%esp
  8017f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f8:	e8 3b f5 ff ff       	call   800d38 <fd2num>
  8017fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801800:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801802:	83 c4 04             	add    $0x4,%esp
  801805:	ff 75 f0             	pushl  -0x10(%ebp)
  801808:	e8 2b f5 ff ff       	call   800d38 <fd2num>
  80180d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801810:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	bb 00 00 00 00       	mov    $0x0,%ebx
  80181b:	e9 4f ff ff ff       	jmp    80176f <pipe+0x75>
	sys_page_unmap(0, va);
  801820:	83 ec 08             	sub    $0x8,%esp
  801823:	56                   	push   %esi
  801824:	6a 00                	push   $0x0
  801826:	e8 a1 f3 ff ff       	call   800bcc <sys_page_unmap>
  80182b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80182e:	83 ec 08             	sub    $0x8,%esp
  801831:	ff 75 f0             	pushl  -0x10(%ebp)
  801834:	6a 00                	push   $0x0
  801836:	e8 91 f3 ff ff       	call   800bcc <sys_page_unmap>
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	e9 1c ff ff ff       	jmp    80175f <pipe+0x65>

00801843 <pipeisclosed>:
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801849:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184c:	50                   	push   %eax
  80184d:	ff 75 08             	pushl  0x8(%ebp)
  801850:	e8 59 f5 ff ff       	call   800dae <fd_lookup>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	85 c0                	test   %eax,%eax
  80185a:	78 18                	js     801874 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80185c:	83 ec 0c             	sub    $0xc,%esp
  80185f:	ff 75 f4             	pushl  -0xc(%ebp)
  801862:	e8 e1 f4 ff ff       	call   800d48 <fd2data>
	return _pipeisclosed(fd, p);
  801867:	89 c2                	mov    %eax,%edx
  801869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186c:	e8 30 fd ff ff       	call   8015a1 <_pipeisclosed>
  801871:	83 c4 10             	add    $0x10,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801879:	b8 00 00 00 00       	mov    $0x0,%eax
  80187e:	5d                   	pop    %ebp
  80187f:	c3                   	ret    

00801880 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801886:	68 6a 21 80 00       	push   $0x80216a
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	e8 bb ee ff ff       	call   80074e <strcpy>
	return 0;
}
  801893:	b8 00 00 00 00       	mov    $0x0,%eax
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <devcons_write>:
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	57                   	push   %edi
  80189e:	56                   	push   %esi
  80189f:	53                   	push   %ebx
  8018a0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8018a6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8018ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8018b1:	eb 2f                	jmp    8018e2 <devcons_write+0x48>
		m = n - tot;
  8018b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018b6:	29 f3                	sub    %esi,%ebx
  8018b8:	83 fb 7f             	cmp    $0x7f,%ebx
  8018bb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8018c0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	53                   	push   %ebx
  8018c7:	89 f0                	mov    %esi,%eax
  8018c9:	03 45 0c             	add    0xc(%ebp),%eax
  8018cc:	50                   	push   %eax
  8018cd:	57                   	push   %edi
  8018ce:	e8 09 f0 ff ff       	call   8008dc <memmove>
		sys_cputs(buf, m);
  8018d3:	83 c4 08             	add    $0x8,%esp
  8018d6:	53                   	push   %ebx
  8018d7:	57                   	push   %edi
  8018d8:	e8 ae f1 ff ff       	call   800a8b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8018dd:	01 de                	add    %ebx,%esi
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018e5:	72 cc                	jb     8018b3 <devcons_write+0x19>
}
  8018e7:	89 f0                	mov    %esi,%eax
  8018e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ec:	5b                   	pop    %ebx
  8018ed:	5e                   	pop    %esi
  8018ee:	5f                   	pop    %edi
  8018ef:	5d                   	pop    %ebp
  8018f0:	c3                   	ret    

008018f1 <devcons_read>:
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 08             	sub    $0x8,%esp
  8018f7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8018fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801900:	75 07                	jne    801909 <devcons_read+0x18>
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    
		sys_yield();
  801904:	e8 1f f2 ff ff       	call   800b28 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801909:	e8 9b f1 ff ff       	call   800aa9 <sys_cgetc>
  80190e:	85 c0                	test   %eax,%eax
  801910:	74 f2                	je     801904 <devcons_read+0x13>
	if (c < 0)
  801912:	85 c0                	test   %eax,%eax
  801914:	78 ec                	js     801902 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801916:	83 f8 04             	cmp    $0x4,%eax
  801919:	74 0c                	je     801927 <devcons_read+0x36>
	*(char*)vbuf = c;
  80191b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191e:	88 02                	mov    %al,(%edx)
	return 1;
  801920:	b8 01 00 00 00       	mov    $0x1,%eax
  801925:	eb db                	jmp    801902 <devcons_read+0x11>
		return 0;
  801927:	b8 00 00 00 00       	mov    $0x0,%eax
  80192c:	eb d4                	jmp    801902 <devcons_read+0x11>

0080192e <cputchar>:
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80193a:	6a 01                	push   $0x1
  80193c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80193f:	50                   	push   %eax
  801940:	e8 46 f1 ff ff       	call   800a8b <sys_cputs>
}
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <getchar>:
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801950:	6a 01                	push   $0x1
  801952:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801955:	50                   	push   %eax
  801956:	6a 00                	push   $0x0
  801958:	e8 c2 f6 ff ff       	call   80101f <read>
	if (r < 0)
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	85 c0                	test   %eax,%eax
  801962:	78 08                	js     80196c <getchar+0x22>
	if (r < 1)
  801964:	85 c0                	test   %eax,%eax
  801966:	7e 06                	jle    80196e <getchar+0x24>
	return c;
  801968:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    
		return -E_EOF;
  80196e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801973:	eb f7                	jmp    80196c <getchar+0x22>

00801975 <iscons>:
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80197b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197e:	50                   	push   %eax
  80197f:	ff 75 08             	pushl  0x8(%ebp)
  801982:	e8 27 f4 ff ff       	call   800dae <fd_lookup>
  801987:	83 c4 10             	add    $0x10,%esp
  80198a:	85 c0                	test   %eax,%eax
  80198c:	78 11                	js     80199f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80198e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801991:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801997:	39 10                	cmp    %edx,(%eax)
  801999:	0f 94 c0             	sete   %al
  80199c:	0f b6 c0             	movzbl %al,%eax
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <opencons>:
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8019a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019aa:	50                   	push   %eax
  8019ab:	e8 af f3 ff ff       	call   800d5f <fd_alloc>
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	78 3a                	js     8019f1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	68 07 04 00 00       	push   $0x407
  8019bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c2:	6a 00                	push   $0x0
  8019c4:	e8 7e f1 ff ff       	call   800b47 <sys_page_alloc>
  8019c9:	83 c4 10             	add    $0x10,%esp
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	78 21                	js     8019f1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8019d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019d9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8019db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019de:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8019e5:	83 ec 0c             	sub    $0xc,%esp
  8019e8:	50                   	push   %eax
  8019e9:	e8 4a f3 ff ff       	call   800d38 <fd2num>
  8019ee:	83 c4 10             	add    $0x10,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	56                   	push   %esi
  8019f7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8019f8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8019fb:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801a01:	e8 03 f1 ff ff       	call   800b09 <sys_getenvid>
  801a06:	83 ec 0c             	sub    $0xc,%esp
  801a09:	ff 75 0c             	pushl  0xc(%ebp)
  801a0c:	ff 75 08             	pushl  0x8(%ebp)
  801a0f:	56                   	push   %esi
  801a10:	50                   	push   %eax
  801a11:	68 78 21 80 00       	push   $0x802178
  801a16:	e8 49 e7 ff ff       	call   800164 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a1b:	83 c4 18             	add    $0x18,%esp
  801a1e:	53                   	push   %ebx
  801a1f:	ff 75 10             	pushl  0x10(%ebp)
  801a22:	e8 ec e6 ff ff       	call   800113 <vcprintf>
	cprintf("\n");
  801a27:	c7 04 24 63 21 80 00 	movl   $0x802163,(%esp)
  801a2e:	e8 31 e7 ff ff       	call   800164 <cprintf>
  801a33:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a36:	cc                   	int3   
  801a37:	eb fd                	jmp    801a36 <_panic+0x43>

00801a39 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801a3f:	68 9c 21 80 00       	push   $0x80219c
  801a44:	6a 1a                	push   $0x1a
  801a46:	68 b5 21 80 00       	push   $0x8021b5
  801a4b:	e8 a3 ff ff ff       	call   8019f3 <_panic>

00801a50 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801a56:	68 bf 21 80 00       	push   $0x8021bf
  801a5b:	6a 2a                	push   $0x2a
  801a5d:	68 b5 21 80 00       	push   $0x8021b5
  801a62:	e8 8c ff ff ff       	call   8019f3 <_panic>

00801a67 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801a6d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801a72:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801a75:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801a7b:	8b 52 50             	mov    0x50(%edx),%edx
  801a7e:	39 ca                	cmp    %ecx,%edx
  801a80:	74 11                	je     801a93 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801a82:	83 c0 01             	add    $0x1,%eax
  801a85:	3d 00 04 00 00       	cmp    $0x400,%eax
  801a8a:	75 e6                	jne    801a72 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801a8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a91:	eb 0b                	jmp    801a9e <ipc_find_env+0x37>
			return envs[i].env_id;
  801a93:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801a96:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801a9b:	8b 40 48             	mov    0x48(%eax),%eax
}
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    

00801aa0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801aa6:	89 d0                	mov    %edx,%eax
  801aa8:	c1 e8 16             	shr    $0x16,%eax
  801aab:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ab2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ab7:	f6 c1 01             	test   $0x1,%cl
  801aba:	74 1d                	je     801ad9 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801abc:	c1 ea 0c             	shr    $0xc,%edx
  801abf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ac6:	f6 c2 01             	test   $0x1,%dl
  801ac9:	74 0e                	je     801ad9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801acb:	c1 ea 0c             	shr    $0xc,%edx
  801ace:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ad5:	ef 
  801ad6:	0f b7 c0             	movzwl %ax,%eax
}
  801ad9:	5d                   	pop    %ebp
  801ada:	c3                   	ret    
  801adb:	66 90                	xchg   %ax,%ax
  801add:	66 90                	xchg   %ax,%ax
  801adf:	90                   	nop

00801ae0 <__udivdi3>:
  801ae0:	55                   	push   %ebp
  801ae1:	57                   	push   %edi
  801ae2:	56                   	push   %esi
  801ae3:	53                   	push   %ebx
  801ae4:	83 ec 1c             	sub    $0x1c,%esp
  801ae7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801aeb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801aef:	8b 74 24 34          	mov    0x34(%esp),%esi
  801af3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801af7:	85 d2                	test   %edx,%edx
  801af9:	75 35                	jne    801b30 <__udivdi3+0x50>
  801afb:	39 f3                	cmp    %esi,%ebx
  801afd:	0f 87 bd 00 00 00    	ja     801bc0 <__udivdi3+0xe0>
  801b03:	85 db                	test   %ebx,%ebx
  801b05:	89 d9                	mov    %ebx,%ecx
  801b07:	75 0b                	jne    801b14 <__udivdi3+0x34>
  801b09:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0e:	31 d2                	xor    %edx,%edx
  801b10:	f7 f3                	div    %ebx
  801b12:	89 c1                	mov    %eax,%ecx
  801b14:	31 d2                	xor    %edx,%edx
  801b16:	89 f0                	mov    %esi,%eax
  801b18:	f7 f1                	div    %ecx
  801b1a:	89 c6                	mov    %eax,%esi
  801b1c:	89 e8                	mov    %ebp,%eax
  801b1e:	89 f7                	mov    %esi,%edi
  801b20:	f7 f1                	div    %ecx
  801b22:	89 fa                	mov    %edi,%edx
  801b24:	83 c4 1c             	add    $0x1c,%esp
  801b27:	5b                   	pop    %ebx
  801b28:	5e                   	pop    %esi
  801b29:	5f                   	pop    %edi
  801b2a:	5d                   	pop    %ebp
  801b2b:	c3                   	ret    
  801b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801b30:	39 f2                	cmp    %esi,%edx
  801b32:	77 7c                	ja     801bb0 <__udivdi3+0xd0>
  801b34:	0f bd fa             	bsr    %edx,%edi
  801b37:	83 f7 1f             	xor    $0x1f,%edi
  801b3a:	0f 84 98 00 00 00    	je     801bd8 <__udivdi3+0xf8>
  801b40:	89 f9                	mov    %edi,%ecx
  801b42:	b8 20 00 00 00       	mov    $0x20,%eax
  801b47:	29 f8                	sub    %edi,%eax
  801b49:	d3 e2                	shl    %cl,%edx
  801b4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b4f:	89 c1                	mov    %eax,%ecx
  801b51:	89 da                	mov    %ebx,%edx
  801b53:	d3 ea                	shr    %cl,%edx
  801b55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801b59:	09 d1                	or     %edx,%ecx
  801b5b:	89 f2                	mov    %esi,%edx
  801b5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b61:	89 f9                	mov    %edi,%ecx
  801b63:	d3 e3                	shl    %cl,%ebx
  801b65:	89 c1                	mov    %eax,%ecx
  801b67:	d3 ea                	shr    %cl,%edx
  801b69:	89 f9                	mov    %edi,%ecx
  801b6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801b6f:	d3 e6                	shl    %cl,%esi
  801b71:	89 eb                	mov    %ebp,%ebx
  801b73:	89 c1                	mov    %eax,%ecx
  801b75:	d3 eb                	shr    %cl,%ebx
  801b77:	09 de                	or     %ebx,%esi
  801b79:	89 f0                	mov    %esi,%eax
  801b7b:	f7 74 24 08          	divl   0x8(%esp)
  801b7f:	89 d6                	mov    %edx,%esi
  801b81:	89 c3                	mov    %eax,%ebx
  801b83:	f7 64 24 0c          	mull   0xc(%esp)
  801b87:	39 d6                	cmp    %edx,%esi
  801b89:	72 0c                	jb     801b97 <__udivdi3+0xb7>
  801b8b:	89 f9                	mov    %edi,%ecx
  801b8d:	d3 e5                	shl    %cl,%ebp
  801b8f:	39 c5                	cmp    %eax,%ebp
  801b91:	73 5d                	jae    801bf0 <__udivdi3+0x110>
  801b93:	39 d6                	cmp    %edx,%esi
  801b95:	75 59                	jne    801bf0 <__udivdi3+0x110>
  801b97:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b9a:	31 ff                	xor    %edi,%edi
  801b9c:	89 fa                	mov    %edi,%edx
  801b9e:	83 c4 1c             	add    $0x1c,%esp
  801ba1:	5b                   	pop    %ebx
  801ba2:	5e                   	pop    %esi
  801ba3:	5f                   	pop    %edi
  801ba4:	5d                   	pop    %ebp
  801ba5:	c3                   	ret    
  801ba6:	8d 76 00             	lea    0x0(%esi),%esi
  801ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801bb0:	31 ff                	xor    %edi,%edi
  801bb2:	31 c0                	xor    %eax,%eax
  801bb4:	89 fa                	mov    %edi,%edx
  801bb6:	83 c4 1c             	add    $0x1c,%esp
  801bb9:	5b                   	pop    %ebx
  801bba:	5e                   	pop    %esi
  801bbb:	5f                   	pop    %edi
  801bbc:	5d                   	pop    %ebp
  801bbd:	c3                   	ret    
  801bbe:	66 90                	xchg   %ax,%ax
  801bc0:	31 ff                	xor    %edi,%edi
  801bc2:	89 e8                	mov    %ebp,%eax
  801bc4:	89 f2                	mov    %esi,%edx
  801bc6:	f7 f3                	div    %ebx
  801bc8:	89 fa                	mov    %edi,%edx
  801bca:	83 c4 1c             	add    $0x1c,%esp
  801bcd:	5b                   	pop    %ebx
  801bce:	5e                   	pop    %esi
  801bcf:	5f                   	pop    %edi
  801bd0:	5d                   	pop    %ebp
  801bd1:	c3                   	ret    
  801bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801bd8:	39 f2                	cmp    %esi,%edx
  801bda:	72 06                	jb     801be2 <__udivdi3+0x102>
  801bdc:	31 c0                	xor    %eax,%eax
  801bde:	39 eb                	cmp    %ebp,%ebx
  801be0:	77 d2                	ja     801bb4 <__udivdi3+0xd4>
  801be2:	b8 01 00 00 00       	mov    $0x1,%eax
  801be7:	eb cb                	jmp    801bb4 <__udivdi3+0xd4>
  801be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801bf0:	89 d8                	mov    %ebx,%eax
  801bf2:	31 ff                	xor    %edi,%edi
  801bf4:	eb be                	jmp    801bb4 <__udivdi3+0xd4>
  801bf6:	66 90                	xchg   %ax,%ax
  801bf8:	66 90                	xchg   %ax,%ax
  801bfa:	66 90                	xchg   %ax,%ax
  801bfc:	66 90                	xchg   %ax,%ax
  801bfe:	66 90                	xchg   %ax,%ax

00801c00 <__umoddi3>:
  801c00:	55                   	push   %ebp
  801c01:	57                   	push   %edi
  801c02:	56                   	push   %esi
  801c03:	53                   	push   %ebx
  801c04:	83 ec 1c             	sub    $0x1c,%esp
  801c07:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801c0b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801c0f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c17:	85 ed                	test   %ebp,%ebp
  801c19:	89 f0                	mov    %esi,%eax
  801c1b:	89 da                	mov    %ebx,%edx
  801c1d:	75 19                	jne    801c38 <__umoddi3+0x38>
  801c1f:	39 df                	cmp    %ebx,%edi
  801c21:	0f 86 b1 00 00 00    	jbe    801cd8 <__umoddi3+0xd8>
  801c27:	f7 f7                	div    %edi
  801c29:	89 d0                	mov    %edx,%eax
  801c2b:	31 d2                	xor    %edx,%edx
  801c2d:	83 c4 1c             	add    $0x1c,%esp
  801c30:	5b                   	pop    %ebx
  801c31:	5e                   	pop    %esi
  801c32:	5f                   	pop    %edi
  801c33:	5d                   	pop    %ebp
  801c34:	c3                   	ret    
  801c35:	8d 76 00             	lea    0x0(%esi),%esi
  801c38:	39 dd                	cmp    %ebx,%ebp
  801c3a:	77 f1                	ja     801c2d <__umoddi3+0x2d>
  801c3c:	0f bd cd             	bsr    %ebp,%ecx
  801c3f:	83 f1 1f             	xor    $0x1f,%ecx
  801c42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c46:	0f 84 b4 00 00 00    	je     801d00 <__umoddi3+0x100>
  801c4c:	b8 20 00 00 00       	mov    $0x20,%eax
  801c51:	89 c2                	mov    %eax,%edx
  801c53:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c57:	29 c2                	sub    %eax,%edx
  801c59:	89 c1                	mov    %eax,%ecx
  801c5b:	89 f8                	mov    %edi,%eax
  801c5d:	d3 e5                	shl    %cl,%ebp
  801c5f:	89 d1                	mov    %edx,%ecx
  801c61:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c65:	d3 e8                	shr    %cl,%eax
  801c67:	09 c5                	or     %eax,%ebp
  801c69:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c6d:	89 c1                	mov    %eax,%ecx
  801c6f:	d3 e7                	shl    %cl,%edi
  801c71:	89 d1                	mov    %edx,%ecx
  801c73:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801c77:	89 df                	mov    %ebx,%edi
  801c79:	d3 ef                	shr    %cl,%edi
  801c7b:	89 c1                	mov    %eax,%ecx
  801c7d:	89 f0                	mov    %esi,%eax
  801c7f:	d3 e3                	shl    %cl,%ebx
  801c81:	89 d1                	mov    %edx,%ecx
  801c83:	89 fa                	mov    %edi,%edx
  801c85:	d3 e8                	shr    %cl,%eax
  801c87:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801c8c:	09 d8                	or     %ebx,%eax
  801c8e:	f7 f5                	div    %ebp
  801c90:	d3 e6                	shl    %cl,%esi
  801c92:	89 d1                	mov    %edx,%ecx
  801c94:	f7 64 24 08          	mull   0x8(%esp)
  801c98:	39 d1                	cmp    %edx,%ecx
  801c9a:	89 c3                	mov    %eax,%ebx
  801c9c:	89 d7                	mov    %edx,%edi
  801c9e:	72 06                	jb     801ca6 <__umoddi3+0xa6>
  801ca0:	75 0e                	jne    801cb0 <__umoddi3+0xb0>
  801ca2:	39 c6                	cmp    %eax,%esi
  801ca4:	73 0a                	jae    801cb0 <__umoddi3+0xb0>
  801ca6:	2b 44 24 08          	sub    0x8(%esp),%eax
  801caa:	19 ea                	sbb    %ebp,%edx
  801cac:	89 d7                	mov    %edx,%edi
  801cae:	89 c3                	mov    %eax,%ebx
  801cb0:	89 ca                	mov    %ecx,%edx
  801cb2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801cb7:	29 de                	sub    %ebx,%esi
  801cb9:	19 fa                	sbb    %edi,%edx
  801cbb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801cbf:	89 d0                	mov    %edx,%eax
  801cc1:	d3 e0                	shl    %cl,%eax
  801cc3:	89 d9                	mov    %ebx,%ecx
  801cc5:	d3 ee                	shr    %cl,%esi
  801cc7:	d3 ea                	shr    %cl,%edx
  801cc9:	09 f0                	or     %esi,%eax
  801ccb:	83 c4 1c             	add    $0x1c,%esp
  801cce:	5b                   	pop    %ebx
  801ccf:	5e                   	pop    %esi
  801cd0:	5f                   	pop    %edi
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    
  801cd3:	90                   	nop
  801cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801cd8:	85 ff                	test   %edi,%edi
  801cda:	89 f9                	mov    %edi,%ecx
  801cdc:	75 0b                	jne    801ce9 <__umoddi3+0xe9>
  801cde:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce3:	31 d2                	xor    %edx,%edx
  801ce5:	f7 f7                	div    %edi
  801ce7:	89 c1                	mov    %eax,%ecx
  801ce9:	89 d8                	mov    %ebx,%eax
  801ceb:	31 d2                	xor    %edx,%edx
  801ced:	f7 f1                	div    %ecx
  801cef:	89 f0                	mov    %esi,%eax
  801cf1:	f7 f1                	div    %ecx
  801cf3:	e9 31 ff ff ff       	jmp    801c29 <__umoddi3+0x29>
  801cf8:	90                   	nop
  801cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d00:	39 dd                	cmp    %ebx,%ebp
  801d02:	72 08                	jb     801d0c <__umoddi3+0x10c>
  801d04:	39 f7                	cmp    %esi,%edi
  801d06:	0f 87 21 ff ff ff    	ja     801c2d <__umoddi3+0x2d>
  801d0c:	89 da                	mov    %ebx,%edx
  801d0e:	89 f0                	mov    %esi,%eax
  801d10:	29 f8                	sub    %edi,%eax
  801d12:	19 ea                	sbb    %ebp,%edx
  801d14:	e9 14 ff ff ff       	jmp    801c2d <__umoddi3+0x2d>
