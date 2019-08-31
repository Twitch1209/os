
obj/user/pingpong.debug：     文件格式 elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 5f 0d 00 00       	call   800da0 <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 4f                	jne    800097 <umain+0x64>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800048:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004b:	83 ec 04             	sub    $0x4,%esp
  80004e:	6a 00                	push   $0x0
  800050:	6a 00                	push   $0x0
  800052:	56                   	push   %esi
  800053:	e8 6a 0f 00 00       	call   800fc2 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 f8 0a 00 00       	call   800b5a <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 56 20 80 00       	push   $0x802056
  80006a:	e8 46 01 00 00       	call   8001b5 <cprintf>
		if (i == 10)
  80006f:	83 c4 20             	add    $0x20,%esp
  800072:	83 fb 0a             	cmp    $0xa,%ebx
  800075:	74 18                	je     80008f <umain+0x5c>
			return;
		i++;
  800077:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007a:	6a 00                	push   $0x0
  80007c:	6a 00                	push   $0x0
  80007e:	53                   	push   %ebx
  80007f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800082:	e8 52 0f 00 00       	call   800fd9 <ipc_send>
		if (i == 10)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	83 fb 0a             	cmp    $0xa,%ebx
  80008d:	75 bc                	jne    80004b <umain+0x18>
			return;
	}

}
  80008f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800092:	5b                   	pop    %ebx
  800093:	5e                   	pop    %esi
  800094:	5f                   	pop    %edi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    
  800097:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800099:	e8 bc 0a 00 00       	call   800b5a <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 40 20 80 00       	push   $0x802040
  8000a8:	e8 08 01 00 00       	call   8001b5 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 1e 0f 00 00       	call   800fd9 <ipc_send>
  8000bb:	83 c4 20             	add    $0x20,%esp
  8000be:	eb 88                	jmp    800048 <umain+0x15>

008000c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
  8000c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000cb:	e8 8a 0a 00 00       	call   800b5a <sys_getenvid>
  8000d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000dd:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e2:	85 db                	test   %ebx,%ebx
  8000e4:	7e 07                	jle    8000ed <libmain+0x2d>
		binaryname = argv[0];
  8000e6:	8b 06                	mov    (%esi),%eax
  8000e8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	e8 3c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f7:	e8 0a 00 00 00       	call   800106 <exit>
}
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800102:	5b                   	pop    %ebx
  800103:	5e                   	pop    %esi
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    

00800106 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80010c:	e8 ee 10 00 00       	call   8011ff <close_all>
	sys_env_destroy(0);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	6a 00                	push   $0x0
  800116:	e8 fe 09 00 00       	call   800b19 <sys_env_destroy>
}
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	c9                   	leave  
  80011f:	c3                   	ret    

00800120 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	53                   	push   %ebx
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012a:	8b 13                	mov    (%ebx),%edx
  80012c:	8d 42 01             	lea    0x1(%edx),%eax
  80012f:	89 03                	mov    %eax,(%ebx)
  800131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800134:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800138:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013d:	74 09                	je     800148 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80013f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800143:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800146:	c9                   	leave  
  800147:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 ff 00 00 00       	push   $0xff
  800150:	8d 43 08             	lea    0x8(%ebx),%eax
  800153:	50                   	push   %eax
  800154:	e8 83 09 00 00       	call   800adc <sys_cputs>
		b->idx = 0;
  800159:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80015f:	83 c4 10             	add    $0x10,%esp
  800162:	eb db                	jmp    80013f <putch+0x1f>

00800164 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80016d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800174:	00 00 00 
	b.cnt = 0;
  800177:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800181:	ff 75 0c             	pushl  0xc(%ebp)
  800184:	ff 75 08             	pushl  0x8(%ebp)
  800187:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018d:	50                   	push   %eax
  80018e:	68 20 01 80 00       	push   $0x800120
  800193:	e8 1a 01 00 00       	call   8002b2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800198:	83 c4 08             	add    $0x8,%esp
  80019b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a7:	50                   	push   %eax
  8001a8:	e8 2f 09 00 00       	call   800adc <sys_cputs>

	return b.cnt;
}
  8001ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001bb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001be:	50                   	push   %eax
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	e8 9d ff ff ff       	call   800164 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	57                   	push   %edi
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	83 ec 1c             	sub    $0x1c,%esp
  8001d2:	89 c7                	mov    %eax,%edi
  8001d4:	89 d6                	mov    %edx,%esi
  8001d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001df:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ea:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001f0:	39 d3                	cmp    %edx,%ebx
  8001f2:	72 05                	jb     8001f9 <printnum+0x30>
  8001f4:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001f7:	77 7a                	ja     800273 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	ff 75 18             	pushl  0x18(%ebp)
  8001ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800202:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800205:	53                   	push   %ebx
  800206:	ff 75 10             	pushl  0x10(%ebp)
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020f:	ff 75 e0             	pushl  -0x20(%ebp)
  800212:	ff 75 dc             	pushl  -0x24(%ebp)
  800215:	ff 75 d8             	pushl  -0x28(%ebp)
  800218:	e8 e3 1b 00 00       	call   801e00 <__udivdi3>
  80021d:	83 c4 18             	add    $0x18,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	89 f2                	mov    %esi,%edx
  800224:	89 f8                	mov    %edi,%eax
  800226:	e8 9e ff ff ff       	call   8001c9 <printnum>
  80022b:	83 c4 20             	add    $0x20,%esp
  80022e:	eb 13                	jmp    800243 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	56                   	push   %esi
  800234:	ff 75 18             	pushl  0x18(%ebp)
  800237:	ff d7                	call   *%edi
  800239:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80023c:	83 eb 01             	sub    $0x1,%ebx
  80023f:	85 db                	test   %ebx,%ebx
  800241:	7f ed                	jg     800230 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	56                   	push   %esi
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024d:	ff 75 e0             	pushl  -0x20(%ebp)
  800250:	ff 75 dc             	pushl  -0x24(%ebp)
  800253:	ff 75 d8             	pushl  -0x28(%ebp)
  800256:	e8 c5 1c 00 00       	call   801f20 <__umoddi3>
  80025b:	83 c4 14             	add    $0x14,%esp
  80025e:	0f be 80 73 20 80 00 	movsbl 0x802073(%eax),%eax
  800265:	50                   	push   %eax
  800266:	ff d7                	call   *%edi
}
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5e                   	pop    %esi
  800270:	5f                   	pop    %edi
  800271:	5d                   	pop    %ebp
  800272:	c3                   	ret    
  800273:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800276:	eb c4                	jmp    80023c <printnum+0x73>

00800278 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800282:	8b 10                	mov    (%eax),%edx
  800284:	3b 50 04             	cmp    0x4(%eax),%edx
  800287:	73 0a                	jae    800293 <sprintputch+0x1b>
		*b->buf++ = ch;
  800289:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028c:	89 08                	mov    %ecx,(%eax)
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	88 02                	mov    %al,(%edx)
}
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    

00800295 <printfmt>:
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80029b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029e:	50                   	push   %eax
  80029f:	ff 75 10             	pushl  0x10(%ebp)
  8002a2:	ff 75 0c             	pushl  0xc(%ebp)
  8002a5:	ff 75 08             	pushl  0x8(%ebp)
  8002a8:	e8 05 00 00 00       	call   8002b2 <vprintfmt>
}
  8002ad:	83 c4 10             	add    $0x10,%esp
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <vprintfmt>:
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	57                   	push   %edi
  8002b6:	56                   	push   %esi
  8002b7:	53                   	push   %ebx
  8002b8:	83 ec 2c             	sub    $0x2c,%esp
  8002bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8002be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c4:	e9 8c 03 00 00       	jmp    800655 <vprintfmt+0x3a3>
		padc = ' ';
  8002c9:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002cd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002d4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002e2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e7:	8d 47 01             	lea    0x1(%edi),%eax
  8002ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ed:	0f b6 17             	movzbl (%edi),%edx
  8002f0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f3:	3c 55                	cmp    $0x55,%al
  8002f5:	0f 87 dd 03 00 00    	ja     8006d8 <vprintfmt+0x426>
  8002fb:	0f b6 c0             	movzbl %al,%eax
  8002fe:	ff 24 85 c0 21 80 00 	jmp    *0x8021c0(,%eax,4)
  800305:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800308:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80030c:	eb d9                	jmp    8002e7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800311:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800315:	eb d0                	jmp    8002e7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800317:	0f b6 d2             	movzbl %dl,%edx
  80031a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800325:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800328:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80032f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800332:	83 f9 09             	cmp    $0x9,%ecx
  800335:	77 55                	ja     80038c <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800337:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033a:	eb e9                	jmp    800325 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80033c:	8b 45 14             	mov    0x14(%ebp),%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800344:	8b 45 14             	mov    0x14(%ebp),%eax
  800347:	8d 40 04             	lea    0x4(%eax),%eax
  80034a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800350:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800354:	79 91                	jns    8002e7 <vprintfmt+0x35>
				width = precision, precision = -1;
  800356:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800359:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800363:	eb 82                	jmp    8002e7 <vprintfmt+0x35>
  800365:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800368:	85 c0                	test   %eax,%eax
  80036a:	ba 00 00 00 00       	mov    $0x0,%edx
  80036f:	0f 49 d0             	cmovns %eax,%edx
  800372:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800378:	e9 6a ff ff ff       	jmp    8002e7 <vprintfmt+0x35>
  80037d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800380:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800387:	e9 5b ff ff ff       	jmp    8002e7 <vprintfmt+0x35>
  80038c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80038f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800392:	eb bc                	jmp    800350 <vprintfmt+0x9e>
			lflag++;
  800394:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039a:	e9 48 ff ff ff       	jmp    8002e7 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80039f:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a2:	8d 78 04             	lea    0x4(%eax),%edi
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	53                   	push   %ebx
  8003a9:	ff 30                	pushl  (%eax)
  8003ab:	ff d6                	call   *%esi
			break;
  8003ad:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b3:	e9 9a 02 00 00       	jmp    800652 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8003b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bb:	8d 78 04             	lea    0x4(%eax),%edi
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	99                   	cltd   
  8003c1:	31 d0                	xor    %edx,%eax
  8003c3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c5:	83 f8 0f             	cmp    $0xf,%eax
  8003c8:	7f 23                	jg     8003ed <vprintfmt+0x13b>
  8003ca:	8b 14 85 20 23 80 00 	mov    0x802320(,%eax,4),%edx
  8003d1:	85 d2                	test   %edx,%edx
  8003d3:	74 18                	je     8003ed <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003d5:	52                   	push   %edx
  8003d6:	68 4d 25 80 00       	push   $0x80254d
  8003db:	53                   	push   %ebx
  8003dc:	56                   	push   %esi
  8003dd:	e8 b3 fe ff ff       	call   800295 <printfmt>
  8003e2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e8:	e9 65 02 00 00       	jmp    800652 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8003ed:	50                   	push   %eax
  8003ee:	68 8b 20 80 00       	push   $0x80208b
  8003f3:	53                   	push   %ebx
  8003f4:	56                   	push   %esi
  8003f5:	e8 9b fe ff ff       	call   800295 <printfmt>
  8003fa:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800400:	e9 4d 02 00 00       	jmp    800652 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	83 c0 04             	add    $0x4,%eax
  80040b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80040e:	8b 45 14             	mov    0x14(%ebp),%eax
  800411:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800413:	85 ff                	test   %edi,%edi
  800415:	b8 84 20 80 00       	mov    $0x802084,%eax
  80041a:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80041d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800421:	0f 8e bd 00 00 00    	jle    8004e4 <vprintfmt+0x232>
  800427:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80042b:	75 0e                	jne    80043b <vprintfmt+0x189>
  80042d:	89 75 08             	mov    %esi,0x8(%ebp)
  800430:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800433:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800436:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800439:	eb 6d                	jmp    8004a8 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	ff 75 d0             	pushl  -0x30(%ebp)
  800441:	57                   	push   %edi
  800442:	e8 39 03 00 00       	call   800780 <strnlen>
  800447:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80044a:	29 c1                	sub    %eax,%ecx
  80044c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80044f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800452:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800456:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800459:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80045c:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045e:	eb 0f                	jmp    80046f <vprintfmt+0x1bd>
					putch(padc, putdat);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	53                   	push   %ebx
  800464:	ff 75 e0             	pushl  -0x20(%ebp)
  800467:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800469:	83 ef 01             	sub    $0x1,%edi
  80046c:	83 c4 10             	add    $0x10,%esp
  80046f:	85 ff                	test   %edi,%edi
  800471:	7f ed                	jg     800460 <vprintfmt+0x1ae>
  800473:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800476:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800479:	85 c9                	test   %ecx,%ecx
  80047b:	b8 00 00 00 00       	mov    $0x0,%eax
  800480:	0f 49 c1             	cmovns %ecx,%eax
  800483:	29 c1                	sub    %eax,%ecx
  800485:	89 75 08             	mov    %esi,0x8(%ebp)
  800488:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80048b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048e:	89 cb                	mov    %ecx,%ebx
  800490:	eb 16                	jmp    8004a8 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800492:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800496:	75 31                	jne    8004c9 <vprintfmt+0x217>
					putch(ch, putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	ff 75 0c             	pushl  0xc(%ebp)
  80049e:	50                   	push   %eax
  80049f:	ff 55 08             	call   *0x8(%ebp)
  8004a2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a5:	83 eb 01             	sub    $0x1,%ebx
  8004a8:	83 c7 01             	add    $0x1,%edi
  8004ab:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004af:	0f be c2             	movsbl %dl,%eax
  8004b2:	85 c0                	test   %eax,%eax
  8004b4:	74 59                	je     80050f <vprintfmt+0x25d>
  8004b6:	85 f6                	test   %esi,%esi
  8004b8:	78 d8                	js     800492 <vprintfmt+0x1e0>
  8004ba:	83 ee 01             	sub    $0x1,%esi
  8004bd:	79 d3                	jns    800492 <vprintfmt+0x1e0>
  8004bf:	89 df                	mov    %ebx,%edi
  8004c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c7:	eb 37                	jmp    800500 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c9:	0f be d2             	movsbl %dl,%edx
  8004cc:	83 ea 20             	sub    $0x20,%edx
  8004cf:	83 fa 5e             	cmp    $0x5e,%edx
  8004d2:	76 c4                	jbe    800498 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004d4:	83 ec 08             	sub    $0x8,%esp
  8004d7:	ff 75 0c             	pushl  0xc(%ebp)
  8004da:	6a 3f                	push   $0x3f
  8004dc:	ff 55 08             	call   *0x8(%ebp)
  8004df:	83 c4 10             	add    $0x10,%esp
  8004e2:	eb c1                	jmp    8004a5 <vprintfmt+0x1f3>
  8004e4:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ea:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ed:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004f0:	eb b6                	jmp    8004a8 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	53                   	push   %ebx
  8004f6:	6a 20                	push   $0x20
  8004f8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fa:	83 ef 01             	sub    $0x1,%edi
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	85 ff                	test   %edi,%edi
  800502:	7f ee                	jg     8004f2 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800504:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
  80050a:	e9 43 01 00 00       	jmp    800652 <vprintfmt+0x3a0>
  80050f:	89 df                	mov    %ebx,%edi
  800511:	8b 75 08             	mov    0x8(%ebp),%esi
  800514:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800517:	eb e7                	jmp    800500 <vprintfmt+0x24e>
	if (lflag >= 2)
  800519:	83 f9 01             	cmp    $0x1,%ecx
  80051c:	7e 3f                	jle    80055d <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8b 50 04             	mov    0x4(%eax),%edx
  800524:	8b 00                	mov    (%eax),%eax
  800526:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800529:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	8d 40 08             	lea    0x8(%eax),%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800535:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800539:	79 5c                	jns    800597 <vprintfmt+0x2e5>
				putch('-', putdat);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	53                   	push   %ebx
  80053f:	6a 2d                	push   $0x2d
  800541:	ff d6                	call   *%esi
				num = -(long long) num;
  800543:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800546:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800549:	f7 da                	neg    %edx
  80054b:	83 d1 00             	adc    $0x0,%ecx
  80054e:	f7 d9                	neg    %ecx
  800550:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800553:	b8 0a 00 00 00       	mov    $0xa,%eax
  800558:	e9 db 00 00 00       	jmp    800638 <vprintfmt+0x386>
	else if (lflag)
  80055d:	85 c9                	test   %ecx,%ecx
  80055f:	75 1b                	jne    80057c <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800569:	89 c1                	mov    %eax,%ecx
  80056b:	c1 f9 1f             	sar    $0x1f,%ecx
  80056e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8d 40 04             	lea    0x4(%eax),%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
  80057a:	eb b9                	jmp    800535 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800584:	89 c1                	mov    %eax,%ecx
  800586:	c1 f9 1f             	sar    $0x1f,%ecx
  800589:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8d 40 04             	lea    0x4(%eax),%eax
  800592:	89 45 14             	mov    %eax,0x14(%ebp)
  800595:	eb 9e                	jmp    800535 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800597:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80059d:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a2:	e9 91 00 00 00       	jmp    800638 <vprintfmt+0x386>
	if (lflag >= 2)
  8005a7:	83 f9 01             	cmp    $0x1,%ecx
  8005aa:	7e 15                	jle    8005c1 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8b 10                	mov    (%eax),%edx
  8005b1:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b4:	8d 40 08             	lea    0x8(%eax),%eax
  8005b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005bf:	eb 77                	jmp    800638 <vprintfmt+0x386>
	else if (lflag)
  8005c1:	85 c9                	test   %ecx,%ecx
  8005c3:	75 17                	jne    8005dc <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8b 10                	mov    (%eax),%edx
  8005ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005cf:	8d 40 04             	lea    0x4(%eax),%eax
  8005d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005da:	eb 5c                	jmp    800638 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	8b 10                	mov    (%eax),%edx
  8005e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e6:	8d 40 04             	lea    0x4(%eax),%eax
  8005e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ec:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f1:	eb 45                	jmp    800638 <vprintfmt+0x386>
			putch('X', putdat);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	53                   	push   %ebx
  8005f7:	6a 58                	push   $0x58
  8005f9:	ff d6                	call   *%esi
			putch('X', putdat);
  8005fb:	83 c4 08             	add    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	6a 58                	push   $0x58
  800601:	ff d6                	call   *%esi
			putch('X', putdat);
  800603:	83 c4 08             	add    $0x8,%esp
  800606:	53                   	push   %ebx
  800607:	6a 58                	push   $0x58
  800609:	ff d6                	call   *%esi
			break;
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	eb 42                	jmp    800652 <vprintfmt+0x3a0>
			putch('0', putdat);
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	53                   	push   %ebx
  800614:	6a 30                	push   $0x30
  800616:	ff d6                	call   *%esi
			putch('x', putdat);
  800618:	83 c4 08             	add    $0x8,%esp
  80061b:	53                   	push   %ebx
  80061c:	6a 78                	push   $0x78
  80061e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	8b 10                	mov    (%eax),%edx
  800625:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80062a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80062d:	8d 40 04             	lea    0x4(%eax),%eax
  800630:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800633:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800638:	83 ec 0c             	sub    $0xc,%esp
  80063b:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80063f:	57                   	push   %edi
  800640:	ff 75 e0             	pushl  -0x20(%ebp)
  800643:	50                   	push   %eax
  800644:	51                   	push   %ecx
  800645:	52                   	push   %edx
  800646:	89 da                	mov    %ebx,%edx
  800648:	89 f0                	mov    %esi,%eax
  80064a:	e8 7a fb ff ff       	call   8001c9 <printnum>
			break;
  80064f:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800652:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800655:	83 c7 01             	add    $0x1,%edi
  800658:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80065c:	83 f8 25             	cmp    $0x25,%eax
  80065f:	0f 84 64 fc ff ff    	je     8002c9 <vprintfmt+0x17>
			if (ch == '\0')
  800665:	85 c0                	test   %eax,%eax
  800667:	0f 84 8b 00 00 00    	je     8006f8 <vprintfmt+0x446>
			putch(ch, putdat);
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	53                   	push   %ebx
  800671:	50                   	push   %eax
  800672:	ff d6                	call   *%esi
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	eb dc                	jmp    800655 <vprintfmt+0x3a3>
	if (lflag >= 2)
  800679:	83 f9 01             	cmp    $0x1,%ecx
  80067c:	7e 15                	jle    800693 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8b 10                	mov    (%eax),%edx
  800683:	8b 48 04             	mov    0x4(%eax),%ecx
  800686:	8d 40 08             	lea    0x8(%eax),%eax
  800689:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068c:	b8 10 00 00 00       	mov    $0x10,%eax
  800691:	eb a5                	jmp    800638 <vprintfmt+0x386>
	else if (lflag)
  800693:	85 c9                	test   %ecx,%ecx
  800695:	75 17                	jne    8006ae <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 10                	mov    (%eax),%edx
  80069c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a1:	8d 40 04             	lea    0x4(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a7:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ac:	eb 8a                	jmp    800638 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8b 10                	mov    (%eax),%edx
  8006b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b8:	8d 40 04             	lea    0x4(%eax),%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006be:	b8 10 00 00 00       	mov    $0x10,%eax
  8006c3:	e9 70 ff ff ff       	jmp    800638 <vprintfmt+0x386>
			putch(ch, putdat);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	6a 25                	push   $0x25
  8006ce:	ff d6                	call   *%esi
			break;
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	e9 7a ff ff ff       	jmp    800652 <vprintfmt+0x3a0>
			putch('%', putdat);
  8006d8:	83 ec 08             	sub    $0x8,%esp
  8006db:	53                   	push   %ebx
  8006dc:	6a 25                	push   $0x25
  8006de:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	89 f8                	mov    %edi,%eax
  8006e5:	eb 03                	jmp    8006ea <vprintfmt+0x438>
  8006e7:	83 e8 01             	sub    $0x1,%eax
  8006ea:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ee:	75 f7                	jne    8006e7 <vprintfmt+0x435>
  8006f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006f3:	e9 5a ff ff ff       	jmp    800652 <vprintfmt+0x3a0>
}
  8006f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006fb:	5b                   	pop    %ebx
  8006fc:	5e                   	pop    %esi
  8006fd:	5f                   	pop    %edi
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    

00800700 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
  800703:	83 ec 18             	sub    $0x18,%esp
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80070c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80070f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800713:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800716:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80071d:	85 c0                	test   %eax,%eax
  80071f:	74 26                	je     800747 <vsnprintf+0x47>
  800721:	85 d2                	test   %edx,%edx
  800723:	7e 22                	jle    800747 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800725:	ff 75 14             	pushl  0x14(%ebp)
  800728:	ff 75 10             	pushl  0x10(%ebp)
  80072b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80072e:	50                   	push   %eax
  80072f:	68 78 02 80 00       	push   $0x800278
  800734:	e8 79 fb ff ff       	call   8002b2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800739:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80073c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80073f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800742:	83 c4 10             	add    $0x10,%esp
}
  800745:	c9                   	leave  
  800746:	c3                   	ret    
		return -E_INVAL;
  800747:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80074c:	eb f7                	jmp    800745 <vsnprintf+0x45>

0080074e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800754:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800757:	50                   	push   %eax
  800758:	ff 75 10             	pushl  0x10(%ebp)
  80075b:	ff 75 0c             	pushl  0xc(%ebp)
  80075e:	ff 75 08             	pushl  0x8(%ebp)
  800761:	e8 9a ff ff ff       	call   800700 <vsnprintf>
	va_end(ap);

	return rc;
}
  800766:	c9                   	leave  
  800767:	c3                   	ret    

00800768 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80076e:	b8 00 00 00 00       	mov    $0x0,%eax
  800773:	eb 03                	jmp    800778 <strlen+0x10>
		n++;
  800775:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800778:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80077c:	75 f7                	jne    800775 <strlen+0xd>
	return n;
}
  80077e:	5d                   	pop    %ebp
  80077f:	c3                   	ret    

00800780 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800786:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800789:	b8 00 00 00 00       	mov    $0x0,%eax
  80078e:	eb 03                	jmp    800793 <strnlen+0x13>
		n++;
  800790:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800793:	39 d0                	cmp    %edx,%eax
  800795:	74 06                	je     80079d <strnlen+0x1d>
  800797:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80079b:	75 f3                	jne    800790 <strnlen+0x10>
	return n;
}
  80079d:	5d                   	pop    %ebp
  80079e:	c3                   	ret    

0080079f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80079f:	55                   	push   %ebp
  8007a0:	89 e5                	mov    %esp,%ebp
  8007a2:	53                   	push   %ebx
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a9:	89 c2                	mov    %eax,%edx
  8007ab:	83 c1 01             	add    $0x1,%ecx
  8007ae:	83 c2 01             	add    $0x1,%edx
  8007b1:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007b5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007b8:	84 db                	test   %bl,%bl
  8007ba:	75 ef                	jne    8007ab <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007bc:	5b                   	pop    %ebx
  8007bd:	5d                   	pop    %ebp
  8007be:	c3                   	ret    

008007bf <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
  8007c2:	53                   	push   %ebx
  8007c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c6:	53                   	push   %ebx
  8007c7:	e8 9c ff ff ff       	call   800768 <strlen>
  8007cc:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007cf:	ff 75 0c             	pushl  0xc(%ebp)
  8007d2:	01 d8                	add    %ebx,%eax
  8007d4:	50                   	push   %eax
  8007d5:	e8 c5 ff ff ff       	call   80079f <strcpy>
	return dst;
}
  8007da:	89 d8                	mov    %ebx,%eax
  8007dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007df:	c9                   	leave  
  8007e0:	c3                   	ret    

008007e1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007e1:	55                   	push   %ebp
  8007e2:	89 e5                	mov    %esp,%ebp
  8007e4:	56                   	push   %esi
  8007e5:	53                   	push   %ebx
  8007e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8007e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ec:	89 f3                	mov    %esi,%ebx
  8007ee:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f1:	89 f2                	mov    %esi,%edx
  8007f3:	eb 0f                	jmp    800804 <strncpy+0x23>
		*dst++ = *src;
  8007f5:	83 c2 01             	add    $0x1,%edx
  8007f8:	0f b6 01             	movzbl (%ecx),%eax
  8007fb:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007fe:	80 39 01             	cmpb   $0x1,(%ecx)
  800801:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800804:	39 da                	cmp    %ebx,%edx
  800806:	75 ed                	jne    8007f5 <strncpy+0x14>
	}
	return ret;
}
  800808:	89 f0                	mov    %esi,%eax
  80080a:	5b                   	pop    %ebx
  80080b:	5e                   	pop    %esi
  80080c:	5d                   	pop    %ebp
  80080d:	c3                   	ret    

0080080e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	56                   	push   %esi
  800812:	53                   	push   %ebx
  800813:	8b 75 08             	mov    0x8(%ebp),%esi
  800816:	8b 55 0c             	mov    0xc(%ebp),%edx
  800819:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80081c:	89 f0                	mov    %esi,%eax
  80081e:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800822:	85 c9                	test   %ecx,%ecx
  800824:	75 0b                	jne    800831 <strlcpy+0x23>
  800826:	eb 17                	jmp    80083f <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800828:	83 c2 01             	add    $0x1,%edx
  80082b:	83 c0 01             	add    $0x1,%eax
  80082e:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800831:	39 d8                	cmp    %ebx,%eax
  800833:	74 07                	je     80083c <strlcpy+0x2e>
  800835:	0f b6 0a             	movzbl (%edx),%ecx
  800838:	84 c9                	test   %cl,%cl
  80083a:	75 ec                	jne    800828 <strlcpy+0x1a>
		*dst = '\0';
  80083c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80083f:	29 f0                	sub    %esi,%eax
}
  800841:	5b                   	pop    %ebx
  800842:	5e                   	pop    %esi
  800843:	5d                   	pop    %ebp
  800844:	c3                   	ret    

00800845 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80084e:	eb 06                	jmp    800856 <strcmp+0x11>
		p++, q++;
  800850:	83 c1 01             	add    $0x1,%ecx
  800853:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800856:	0f b6 01             	movzbl (%ecx),%eax
  800859:	84 c0                	test   %al,%al
  80085b:	74 04                	je     800861 <strcmp+0x1c>
  80085d:	3a 02                	cmp    (%edx),%al
  80085f:	74 ef                	je     800850 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800861:	0f b6 c0             	movzbl %al,%eax
  800864:	0f b6 12             	movzbl (%edx),%edx
  800867:	29 d0                	sub    %edx,%eax
}
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	53                   	push   %ebx
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	8b 55 0c             	mov    0xc(%ebp),%edx
  800875:	89 c3                	mov    %eax,%ebx
  800877:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80087a:	eb 06                	jmp    800882 <strncmp+0x17>
		n--, p++, q++;
  80087c:	83 c0 01             	add    $0x1,%eax
  80087f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800882:	39 d8                	cmp    %ebx,%eax
  800884:	74 16                	je     80089c <strncmp+0x31>
  800886:	0f b6 08             	movzbl (%eax),%ecx
  800889:	84 c9                	test   %cl,%cl
  80088b:	74 04                	je     800891 <strncmp+0x26>
  80088d:	3a 0a                	cmp    (%edx),%cl
  80088f:	74 eb                	je     80087c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800891:	0f b6 00             	movzbl (%eax),%eax
  800894:	0f b6 12             	movzbl (%edx),%edx
  800897:	29 d0                	sub    %edx,%eax
}
  800899:	5b                   	pop    %ebx
  80089a:	5d                   	pop    %ebp
  80089b:	c3                   	ret    
		return 0;
  80089c:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a1:	eb f6                	jmp    800899 <strncmp+0x2e>

008008a3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ad:	0f b6 10             	movzbl (%eax),%edx
  8008b0:	84 d2                	test   %dl,%dl
  8008b2:	74 09                	je     8008bd <strchr+0x1a>
		if (*s == c)
  8008b4:	38 ca                	cmp    %cl,%dl
  8008b6:	74 0a                	je     8008c2 <strchr+0x1f>
	for (; *s; s++)
  8008b8:	83 c0 01             	add    $0x1,%eax
  8008bb:	eb f0                	jmp    8008ad <strchr+0xa>
			return (char *) s;
	return 0;
  8008bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ce:	eb 03                	jmp    8008d3 <strfind+0xf>
  8008d0:	83 c0 01             	add    $0x1,%eax
  8008d3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008d6:	38 ca                	cmp    %cl,%dl
  8008d8:	74 04                	je     8008de <strfind+0x1a>
  8008da:	84 d2                	test   %dl,%dl
  8008dc:	75 f2                	jne    8008d0 <strfind+0xc>
			break;
	return (char *) s;
}
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	57                   	push   %edi
  8008e4:	56                   	push   %esi
  8008e5:	53                   	push   %ebx
  8008e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008ec:	85 c9                	test   %ecx,%ecx
  8008ee:	74 13                	je     800903 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008f0:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008f6:	75 05                	jne    8008fd <memset+0x1d>
  8008f8:	f6 c1 03             	test   $0x3,%cl
  8008fb:	74 0d                	je     80090a <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	fc                   	cld    
  800901:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800903:	89 f8                	mov    %edi,%eax
  800905:	5b                   	pop    %ebx
  800906:	5e                   	pop    %esi
  800907:	5f                   	pop    %edi
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    
		c &= 0xFF;
  80090a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80090e:	89 d3                	mov    %edx,%ebx
  800910:	c1 e3 08             	shl    $0x8,%ebx
  800913:	89 d0                	mov    %edx,%eax
  800915:	c1 e0 18             	shl    $0x18,%eax
  800918:	89 d6                	mov    %edx,%esi
  80091a:	c1 e6 10             	shl    $0x10,%esi
  80091d:	09 f0                	or     %esi,%eax
  80091f:	09 c2                	or     %eax,%edx
  800921:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800923:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800926:	89 d0                	mov    %edx,%eax
  800928:	fc                   	cld    
  800929:	f3 ab                	rep stos %eax,%es:(%edi)
  80092b:	eb d6                	jmp    800903 <memset+0x23>

0080092d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	57                   	push   %edi
  800931:	56                   	push   %esi
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	8b 75 0c             	mov    0xc(%ebp),%esi
  800938:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80093b:	39 c6                	cmp    %eax,%esi
  80093d:	73 35                	jae    800974 <memmove+0x47>
  80093f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800942:	39 c2                	cmp    %eax,%edx
  800944:	76 2e                	jbe    800974 <memmove+0x47>
		s += n;
		d += n;
  800946:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800949:	89 d6                	mov    %edx,%esi
  80094b:	09 fe                	or     %edi,%esi
  80094d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800953:	74 0c                	je     800961 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800955:	83 ef 01             	sub    $0x1,%edi
  800958:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80095b:	fd                   	std    
  80095c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80095e:	fc                   	cld    
  80095f:	eb 21                	jmp    800982 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800961:	f6 c1 03             	test   $0x3,%cl
  800964:	75 ef                	jne    800955 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800966:	83 ef 04             	sub    $0x4,%edi
  800969:	8d 72 fc             	lea    -0x4(%edx),%esi
  80096c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80096f:	fd                   	std    
  800970:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800972:	eb ea                	jmp    80095e <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800974:	89 f2                	mov    %esi,%edx
  800976:	09 c2                	or     %eax,%edx
  800978:	f6 c2 03             	test   $0x3,%dl
  80097b:	74 09                	je     800986 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80097d:	89 c7                	mov    %eax,%edi
  80097f:	fc                   	cld    
  800980:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800982:	5e                   	pop    %esi
  800983:	5f                   	pop    %edi
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800986:	f6 c1 03             	test   $0x3,%cl
  800989:	75 f2                	jne    80097d <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80098b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80098e:	89 c7                	mov    %eax,%edi
  800990:	fc                   	cld    
  800991:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800993:	eb ed                	jmp    800982 <memmove+0x55>

00800995 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800998:	ff 75 10             	pushl  0x10(%ebp)
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	ff 75 08             	pushl  0x8(%ebp)
  8009a1:	e8 87 ff ff ff       	call   80092d <memmove>
}
  8009a6:	c9                   	leave  
  8009a7:	c3                   	ret    

008009a8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	56                   	push   %esi
  8009ac:	53                   	push   %ebx
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b3:	89 c6                	mov    %eax,%esi
  8009b5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009b8:	39 f0                	cmp    %esi,%eax
  8009ba:	74 1c                	je     8009d8 <memcmp+0x30>
		if (*s1 != *s2)
  8009bc:	0f b6 08             	movzbl (%eax),%ecx
  8009bf:	0f b6 1a             	movzbl (%edx),%ebx
  8009c2:	38 d9                	cmp    %bl,%cl
  8009c4:	75 08                	jne    8009ce <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009c6:	83 c0 01             	add    $0x1,%eax
  8009c9:	83 c2 01             	add    $0x1,%edx
  8009cc:	eb ea                	jmp    8009b8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009ce:	0f b6 c1             	movzbl %cl,%eax
  8009d1:	0f b6 db             	movzbl %bl,%ebx
  8009d4:	29 d8                	sub    %ebx,%eax
  8009d6:	eb 05                	jmp    8009dd <memcmp+0x35>
	}

	return 0;
  8009d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009dd:	5b                   	pop    %ebx
  8009de:	5e                   	pop    %esi
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009ea:	89 c2                	mov    %eax,%edx
  8009ec:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009ef:	39 d0                	cmp    %edx,%eax
  8009f1:	73 09                	jae    8009fc <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009f3:	38 08                	cmp    %cl,(%eax)
  8009f5:	74 05                	je     8009fc <memfind+0x1b>
	for (; s < ends; s++)
  8009f7:	83 c0 01             	add    $0x1,%eax
  8009fa:	eb f3                	jmp    8009ef <memfind+0xe>
			break;
	return (void *) s;
}
  8009fc:	5d                   	pop    %ebp
  8009fd:	c3                   	ret    

008009fe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	57                   	push   %edi
  800a02:	56                   	push   %esi
  800a03:	53                   	push   %ebx
  800a04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a0a:	eb 03                	jmp    800a0f <strtol+0x11>
		s++;
  800a0c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a0f:	0f b6 01             	movzbl (%ecx),%eax
  800a12:	3c 20                	cmp    $0x20,%al
  800a14:	74 f6                	je     800a0c <strtol+0xe>
  800a16:	3c 09                	cmp    $0x9,%al
  800a18:	74 f2                	je     800a0c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a1a:	3c 2b                	cmp    $0x2b,%al
  800a1c:	74 2e                	je     800a4c <strtol+0x4e>
	int neg = 0;
  800a1e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a23:	3c 2d                	cmp    $0x2d,%al
  800a25:	74 2f                	je     800a56 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a27:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a2d:	75 05                	jne    800a34 <strtol+0x36>
  800a2f:	80 39 30             	cmpb   $0x30,(%ecx)
  800a32:	74 2c                	je     800a60 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a34:	85 db                	test   %ebx,%ebx
  800a36:	75 0a                	jne    800a42 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a38:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a3d:	80 39 30             	cmpb   $0x30,(%ecx)
  800a40:	74 28                	je     800a6a <strtol+0x6c>
		base = 10;
  800a42:	b8 00 00 00 00       	mov    $0x0,%eax
  800a47:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a4a:	eb 50                	jmp    800a9c <strtol+0x9e>
		s++;
  800a4c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a4f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a54:	eb d1                	jmp    800a27 <strtol+0x29>
		s++, neg = 1;
  800a56:	83 c1 01             	add    $0x1,%ecx
  800a59:	bf 01 00 00 00       	mov    $0x1,%edi
  800a5e:	eb c7                	jmp    800a27 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a60:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a64:	74 0e                	je     800a74 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a66:	85 db                	test   %ebx,%ebx
  800a68:	75 d8                	jne    800a42 <strtol+0x44>
		s++, base = 8;
  800a6a:	83 c1 01             	add    $0x1,%ecx
  800a6d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a72:	eb ce                	jmp    800a42 <strtol+0x44>
		s += 2, base = 16;
  800a74:	83 c1 02             	add    $0x2,%ecx
  800a77:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a7c:	eb c4                	jmp    800a42 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a7e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a81:	89 f3                	mov    %esi,%ebx
  800a83:	80 fb 19             	cmp    $0x19,%bl
  800a86:	77 29                	ja     800ab1 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a88:	0f be d2             	movsbl %dl,%edx
  800a8b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a8e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a91:	7d 30                	jge    800ac3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a93:	83 c1 01             	add    $0x1,%ecx
  800a96:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a9a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a9c:	0f b6 11             	movzbl (%ecx),%edx
  800a9f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800aa2:	89 f3                	mov    %esi,%ebx
  800aa4:	80 fb 09             	cmp    $0x9,%bl
  800aa7:	77 d5                	ja     800a7e <strtol+0x80>
			dig = *s - '0';
  800aa9:	0f be d2             	movsbl %dl,%edx
  800aac:	83 ea 30             	sub    $0x30,%edx
  800aaf:	eb dd                	jmp    800a8e <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ab1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ab4:	89 f3                	mov    %esi,%ebx
  800ab6:	80 fb 19             	cmp    $0x19,%bl
  800ab9:	77 08                	ja     800ac3 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800abb:	0f be d2             	movsbl %dl,%edx
  800abe:	83 ea 37             	sub    $0x37,%edx
  800ac1:	eb cb                	jmp    800a8e <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ac3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac7:	74 05                	je     800ace <strtol+0xd0>
		*endptr = (char *) s;
  800ac9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800acc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ace:	89 c2                	mov    %eax,%edx
  800ad0:	f7 da                	neg    %edx
  800ad2:	85 ff                	test   %edi,%edi
  800ad4:	0f 45 c2             	cmovne %edx,%eax
}
  800ad7:	5b                   	pop    %ebx
  800ad8:	5e                   	pop    %esi
  800ad9:	5f                   	pop    %edi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	57                   	push   %edi
  800ae0:	56                   	push   %esi
  800ae1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ae2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae7:	8b 55 08             	mov    0x8(%ebp),%edx
  800aea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aed:	89 c3                	mov    %eax,%ebx
  800aef:	89 c7                	mov    %eax,%edi
  800af1:	89 c6                	mov    %eax,%esi
  800af3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5f                   	pop    %edi
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <sys_cgetc>:

int
sys_cgetc(void)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	57                   	push   %edi
  800afe:	56                   	push   %esi
  800aff:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b00:	ba 00 00 00 00       	mov    $0x0,%edx
  800b05:	b8 01 00 00 00       	mov    $0x1,%eax
  800b0a:	89 d1                	mov    %edx,%ecx
  800b0c:	89 d3                	mov    %edx,%ebx
  800b0e:	89 d7                	mov    %edx,%edi
  800b10:	89 d6                	mov    %edx,%esi
  800b12:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b14:	5b                   	pop    %ebx
  800b15:	5e                   	pop    %esi
  800b16:	5f                   	pop    %edi
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	57                   	push   %edi
  800b1d:	56                   	push   %esi
  800b1e:	53                   	push   %ebx
  800b1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b27:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2a:	b8 03 00 00 00       	mov    $0x3,%eax
  800b2f:	89 cb                	mov    %ecx,%ebx
  800b31:	89 cf                	mov    %ecx,%edi
  800b33:	89 ce                	mov    %ecx,%esi
  800b35:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b37:	85 c0                	test   %eax,%eax
  800b39:	7f 08                	jg     800b43 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3e:	5b                   	pop    %ebx
  800b3f:	5e                   	pop    %esi
  800b40:	5f                   	pop    %edi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b43:	83 ec 0c             	sub    $0xc,%esp
  800b46:	50                   	push   %eax
  800b47:	6a 03                	push   $0x3
  800b49:	68 7f 23 80 00       	push   $0x80237f
  800b4e:	6a 23                	push   $0x23
  800b50:	68 9c 23 80 00       	push   $0x80239c
  800b55:	e8 8a 11 00 00       	call   801ce4 <_panic>

00800b5a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	57                   	push   %edi
  800b5e:	56                   	push   %esi
  800b5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b60:	ba 00 00 00 00       	mov    $0x0,%edx
  800b65:	b8 02 00 00 00       	mov    $0x2,%eax
  800b6a:	89 d1                	mov    %edx,%ecx
  800b6c:	89 d3                	mov    %edx,%ebx
  800b6e:	89 d7                	mov    %edx,%edi
  800b70:	89 d6                	mov    %edx,%esi
  800b72:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b74:	5b                   	pop    %ebx
  800b75:	5e                   	pop    %esi
  800b76:	5f                   	pop    %edi
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <sys_yield>:

void
sys_yield(void)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	57                   	push   %edi
  800b7d:	56                   	push   %esi
  800b7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b84:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b89:	89 d1                	mov    %edx,%ecx
  800b8b:	89 d3                	mov    %edx,%ebx
  800b8d:	89 d7                	mov    %edx,%edi
  800b8f:	89 d6                	mov    %edx,%esi
  800b91:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b93:	5b                   	pop    %ebx
  800b94:	5e                   	pop    %esi
  800b95:	5f                   	pop    %edi
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	57                   	push   %edi
  800b9c:	56                   	push   %esi
  800b9d:	53                   	push   %ebx
  800b9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba1:	be 00 00 00 00       	mov    $0x0,%esi
  800ba6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bac:	b8 04 00 00 00       	mov    $0x4,%eax
  800bb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bb4:	89 f7                	mov    %esi,%edi
  800bb6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bb8:	85 c0                	test   %eax,%eax
  800bba:	7f 08                	jg     800bc4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	50                   	push   %eax
  800bc8:	6a 04                	push   $0x4
  800bca:	68 7f 23 80 00       	push   $0x80237f
  800bcf:	6a 23                	push   $0x23
  800bd1:	68 9c 23 80 00       	push   $0x80239c
  800bd6:	e8 09 11 00 00       	call   801ce4 <_panic>

00800bdb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	57                   	push   %edi
  800bdf:	56                   	push   %esi
  800be0:	53                   	push   %ebx
  800be1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be4:	8b 55 08             	mov    0x8(%ebp),%edx
  800be7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bea:	b8 05 00 00 00       	mov    $0x5,%eax
  800bef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bf5:	8b 75 18             	mov    0x18(%ebp),%esi
  800bf8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bfa:	85 c0                	test   %eax,%eax
  800bfc:	7f 08                	jg     800c06 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5f                   	pop    %edi
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c06:	83 ec 0c             	sub    $0xc,%esp
  800c09:	50                   	push   %eax
  800c0a:	6a 05                	push   $0x5
  800c0c:	68 7f 23 80 00       	push   $0x80237f
  800c11:	6a 23                	push   $0x23
  800c13:	68 9c 23 80 00       	push   $0x80239c
  800c18:	e8 c7 10 00 00       	call   801ce4 <_panic>

00800c1d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	57                   	push   %edi
  800c21:	56                   	push   %esi
  800c22:	53                   	push   %ebx
  800c23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c31:	b8 06 00 00 00       	mov    $0x6,%eax
  800c36:	89 df                	mov    %ebx,%edi
  800c38:	89 de                	mov    %ebx,%esi
  800c3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	7f 08                	jg     800c48 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c48:	83 ec 0c             	sub    $0xc,%esp
  800c4b:	50                   	push   %eax
  800c4c:	6a 06                	push   $0x6
  800c4e:	68 7f 23 80 00       	push   $0x80237f
  800c53:	6a 23                	push   $0x23
  800c55:	68 9c 23 80 00       	push   $0x80239c
  800c5a:	e8 85 10 00 00       	call   801ce4 <_panic>

00800c5f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	57                   	push   %edi
  800c63:	56                   	push   %esi
  800c64:	53                   	push   %ebx
  800c65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c73:	b8 08 00 00 00       	mov    $0x8,%eax
  800c78:	89 df                	mov    %ebx,%edi
  800c7a:	89 de                	mov    %ebx,%esi
  800c7c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7e:	85 c0                	test   %eax,%eax
  800c80:	7f 08                	jg     800c8a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8a:	83 ec 0c             	sub    $0xc,%esp
  800c8d:	50                   	push   %eax
  800c8e:	6a 08                	push   $0x8
  800c90:	68 7f 23 80 00       	push   $0x80237f
  800c95:	6a 23                	push   $0x23
  800c97:	68 9c 23 80 00       	push   $0x80239c
  800c9c:	e8 43 10 00 00       	call   801ce4 <_panic>

00800ca1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	57                   	push   %edi
  800ca5:	56                   	push   %esi
  800ca6:	53                   	push   %ebx
  800ca7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800caa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800caf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb5:	b8 09 00 00 00       	mov    $0x9,%eax
  800cba:	89 df                	mov    %ebx,%edi
  800cbc:	89 de                	mov    %ebx,%esi
  800cbe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc0:	85 c0                	test   %eax,%eax
  800cc2:	7f 08                	jg     800ccc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccc:	83 ec 0c             	sub    $0xc,%esp
  800ccf:	50                   	push   %eax
  800cd0:	6a 09                	push   $0x9
  800cd2:	68 7f 23 80 00       	push   $0x80237f
  800cd7:	6a 23                	push   $0x23
  800cd9:	68 9c 23 80 00       	push   $0x80239c
  800cde:	e8 01 10 00 00       	call   801ce4 <_panic>

00800ce3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
  800ce9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cfc:	89 df                	mov    %ebx,%edi
  800cfe:	89 de                	mov    %ebx,%esi
  800d00:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d02:	85 c0                	test   %eax,%eax
  800d04:	7f 08                	jg     800d0e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0e:	83 ec 0c             	sub    $0xc,%esp
  800d11:	50                   	push   %eax
  800d12:	6a 0a                	push   $0xa
  800d14:	68 7f 23 80 00       	push   $0x80237f
  800d19:	6a 23                	push   $0x23
  800d1b:	68 9c 23 80 00       	push   $0x80239c
  800d20:	e8 bf 0f 00 00       	call   801ce4 <_panic>

00800d25 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d31:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d36:	be 00 00 00 00       	mov    $0x0,%esi
  800d3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d41:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5f                   	pop    %edi
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
  800d4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d51:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d5e:	89 cb                	mov    %ecx,%ebx
  800d60:	89 cf                	mov    %ecx,%edi
  800d62:	89 ce                	mov    %ecx,%esi
  800d64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d66:	85 c0                	test   %eax,%eax
  800d68:	7f 08                	jg     800d72 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6d:	5b                   	pop    %ebx
  800d6e:	5e                   	pop    %esi
  800d6f:	5f                   	pop    %edi
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d72:	83 ec 0c             	sub    $0xc,%esp
  800d75:	50                   	push   %eax
  800d76:	6a 0d                	push   $0xd
  800d78:	68 7f 23 80 00       	push   $0x80237f
  800d7d:	6a 23                	push   $0x23
  800d7f:	68 9c 23 80 00       	push   $0x80239c
  800d84:	e8 5b 0f 00 00       	call   801ce4 <_panic>

00800d89 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800d8f:	68 aa 23 80 00       	push   $0x8023aa
  800d94:	6a 25                	push   $0x25
  800d96:	68 c2 23 80 00       	push   $0x8023c2
  800d9b:	e8 44 0f 00 00       	call   801ce4 <_panic>

00800da0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	57                   	push   %edi
  800da4:	56                   	push   %esi
  800da5:	53                   	push   %ebx
  800da6:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  800da9:	68 89 0d 80 00       	push   $0x800d89
  800dae:	e8 77 0f 00 00       	call   801d2a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800db3:	b8 07 00 00 00       	mov    $0x7,%eax
  800db8:	cd 30                	int    $0x30
  800dba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800dbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  800dc0:	83 c4 10             	add    $0x10,%esp
  800dc3:	85 c0                	test   %eax,%eax
  800dc5:	78 27                	js     800dee <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800dc7:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  800dcc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd0:	75 65                	jne    800e37 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800dd2:	e8 83 fd ff ff       	call   800b5a <sys_getenvid>
  800dd7:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ddc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ddf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800de4:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800de9:	e9 11 01 00 00       	jmp    800eff <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  800dee:	50                   	push   %eax
  800def:	68 cd 23 80 00       	push   $0x8023cd
  800df4:	6a 6f                	push   $0x6f
  800df6:	68 c2 23 80 00       	push   $0x8023c2
  800dfb:	e8 e4 0e 00 00       	call   801ce4 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  800e00:	e8 55 fd ff ff       	call   800b5a <sys_getenvid>
  800e05:	83 ec 0c             	sub    $0xc,%esp
  800e08:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800e0e:	56                   	push   %esi
  800e0f:	57                   	push   %edi
  800e10:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e13:	57                   	push   %edi
  800e14:	50                   	push   %eax
  800e15:	e8 c1 fd ff ff       	call   800bdb <sys_page_map>
  800e1a:	83 c4 20             	add    $0x20,%esp
  800e1d:	85 c0                	test   %eax,%eax
  800e1f:	0f 88 84 00 00 00    	js     800ea9 <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800e25:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800e2b:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800e31:	0f 84 84 00 00 00    	je     800ebb <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  800e37:	89 d8                	mov    %ebx,%eax
  800e39:	c1 e8 16             	shr    $0x16,%eax
  800e3c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e43:	a8 01                	test   $0x1,%al
  800e45:	74 de                	je     800e25 <fork+0x85>
  800e47:	89 d8                	mov    %ebx,%eax
  800e49:	c1 e8 0c             	shr    $0xc,%eax
  800e4c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800e53:	f6 c2 01             	test   $0x1,%dl
  800e56:	74 cd                	je     800e25 <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  800e58:	89 c7                	mov    %eax,%edi
  800e5a:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  800e5d:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  800e64:	f7 c6 00 04 00 00    	test   $0x400,%esi
  800e6a:	75 94                	jne    800e00 <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  800e6c:	f7 c6 02 08 00 00    	test   $0x802,%esi
  800e72:	0f 85 d1 00 00 00    	jne    800f49 <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800e78:	a1 04 40 80 00       	mov    0x804004,%eax
  800e7d:	8b 40 48             	mov    0x48(%eax),%eax
  800e80:	83 ec 0c             	sub    $0xc,%esp
  800e83:	6a 05                	push   $0x5
  800e85:	57                   	push   %edi
  800e86:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e89:	57                   	push   %edi
  800e8a:	50                   	push   %eax
  800e8b:	e8 4b fd ff ff       	call   800bdb <sys_page_map>
  800e90:	83 c4 20             	add    $0x20,%esp
  800e93:	85 c0                	test   %eax,%eax
  800e95:	79 8e                	jns    800e25 <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  800e97:	50                   	push   %eax
  800e98:	68 24 24 80 00       	push   $0x802424
  800e9d:	6a 4a                	push   $0x4a
  800e9f:	68 c2 23 80 00       	push   $0x8023c2
  800ea4:	e8 3b 0e 00 00       	call   801ce4 <_panic>
                        panic("duppage: page mapping failed %e", r);
  800ea9:	50                   	push   %eax
  800eaa:	68 04 24 80 00       	push   $0x802404
  800eaf:	6a 41                	push   $0x41
  800eb1:	68 c2 23 80 00       	push   $0x8023c2
  800eb6:	e8 29 0e 00 00       	call   801ce4 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  800ebb:	83 ec 04             	sub    $0x4,%esp
  800ebe:	6a 07                	push   $0x7
  800ec0:	68 00 f0 bf ee       	push   $0xeebff000
  800ec5:	ff 75 e0             	pushl  -0x20(%ebp)
  800ec8:	e8 cb fc ff ff       	call   800b98 <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  800ecd:	83 c4 10             	add    $0x10,%esp
  800ed0:	85 c0                	test   %eax,%eax
  800ed2:	78 36                	js     800f0a <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  800ed4:	83 ec 08             	sub    $0x8,%esp
  800ed7:	68 9e 1d 80 00       	push   $0x801d9e
  800edc:	ff 75 e0             	pushl  -0x20(%ebp)
  800edf:	e8 ff fd ff ff       	call   800ce3 <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800ee4:	83 c4 10             	add    $0x10,%esp
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	78 34                	js     800f1f <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  800eeb:	83 ec 08             	sub    $0x8,%esp
  800eee:	6a 02                	push   $0x2
  800ef0:	ff 75 e0             	pushl  -0x20(%ebp)
  800ef3:	e8 67 fd ff ff       	call   800c5f <sys_env_set_status>
  800ef8:	83 c4 10             	add    $0x10,%esp
  800efb:	85 c0                	test   %eax,%eax
  800efd:	78 35                	js     800f34 <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  800eff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  800f0a:	50                   	push   %eax
  800f0b:	68 cd 23 80 00       	push   $0x8023cd
  800f10:	68 82 00 00 00       	push   $0x82
  800f15:	68 c2 23 80 00       	push   $0x8023c2
  800f1a:	e8 c5 0d 00 00       	call   801ce4 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800f1f:	50                   	push   %eax
  800f20:	68 48 24 80 00       	push   $0x802448
  800f25:	68 87 00 00 00       	push   $0x87
  800f2a:	68 c2 23 80 00       	push   $0x8023c2
  800f2f:	e8 b0 0d 00 00       	call   801ce4 <_panic>
        	panic("sys_env_set_status: %e", r);
  800f34:	50                   	push   %eax
  800f35:	68 d6 23 80 00       	push   $0x8023d6
  800f3a:	68 8b 00 00 00       	push   $0x8b
  800f3f:	68 c2 23 80 00       	push   $0x8023c2
  800f44:	e8 9b 0d 00 00       	call   801ce4 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800f49:	a1 04 40 80 00       	mov    0x804004,%eax
  800f4e:	8b 40 48             	mov    0x48(%eax),%eax
  800f51:	83 ec 0c             	sub    $0xc,%esp
  800f54:	68 05 08 00 00       	push   $0x805
  800f59:	57                   	push   %edi
  800f5a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f5d:	57                   	push   %edi
  800f5e:	50                   	push   %eax
  800f5f:	e8 77 fc ff ff       	call   800bdb <sys_page_map>
  800f64:	83 c4 20             	add    $0x20,%esp
  800f67:	85 c0                	test   %eax,%eax
  800f69:	0f 88 28 ff ff ff    	js     800e97 <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  800f6f:	a1 04 40 80 00       	mov    0x804004,%eax
  800f74:	8b 50 48             	mov    0x48(%eax),%edx
  800f77:	8b 40 48             	mov    0x48(%eax),%eax
  800f7a:	83 ec 0c             	sub    $0xc,%esp
  800f7d:	68 05 08 00 00       	push   $0x805
  800f82:	57                   	push   %edi
  800f83:	52                   	push   %edx
  800f84:	57                   	push   %edi
  800f85:	50                   	push   %eax
  800f86:	e8 50 fc ff ff       	call   800bdb <sys_page_map>
  800f8b:	83 c4 20             	add    $0x20,%esp
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	0f 89 8f fe ff ff    	jns    800e25 <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  800f96:	50                   	push   %eax
  800f97:	68 24 24 80 00       	push   $0x802424
  800f9c:	6a 4f                	push   $0x4f
  800f9e:	68 c2 23 80 00       	push   $0x8023c2
  800fa3:	e8 3c 0d 00 00       	call   801ce4 <_panic>

00800fa8 <sfork>:

// Challenge!
int
sfork(void)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  800fae:	68 ed 23 80 00       	push   $0x8023ed
  800fb3:	68 94 00 00 00       	push   $0x94
  800fb8:	68 c2 23 80 00       	push   $0x8023c2
  800fbd:	e8 22 0d 00 00       	call   801ce4 <_panic>

00800fc2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  800fc8:	68 6c 24 80 00       	push   $0x80246c
  800fcd:	6a 1a                	push   $0x1a
  800fcf:	68 85 24 80 00       	push   $0x802485
  800fd4:	e8 0b 0d 00 00       	call   801ce4 <_panic>

00800fd9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  800fdf:	68 8f 24 80 00       	push   $0x80248f
  800fe4:	6a 2a                	push   $0x2a
  800fe6:	68 85 24 80 00       	push   $0x802485
  800feb:	e8 f4 0c 00 00       	call   801ce4 <_panic>

00800ff0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800ff6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800ffb:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800ffe:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801004:	8b 52 50             	mov    0x50(%edx),%edx
  801007:	39 ca                	cmp    %ecx,%edx
  801009:	74 11                	je     80101c <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80100b:	83 c0 01             	add    $0x1,%eax
  80100e:	3d 00 04 00 00       	cmp    $0x400,%eax
  801013:	75 e6                	jne    800ffb <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801015:	b8 00 00 00 00       	mov    $0x0,%eax
  80101a:	eb 0b                	jmp    801027 <ipc_find_env+0x37>
			return envs[i].env_id;
  80101c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80101f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801024:	8b 40 48             	mov    0x48(%eax),%eax
}
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	05 00 00 00 30       	add    $0x30000000,%eax
  801034:	c1 e8 0c             	shr    $0xc,%eax
}
  801037:	5d                   	pop    %ebp
  801038:	c3                   	ret    

00801039 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801044:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801049:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    

00801050 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801056:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80105b:	89 c2                	mov    %eax,%edx
  80105d:	c1 ea 16             	shr    $0x16,%edx
  801060:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801067:	f6 c2 01             	test   $0x1,%dl
  80106a:	74 2a                	je     801096 <fd_alloc+0x46>
  80106c:	89 c2                	mov    %eax,%edx
  80106e:	c1 ea 0c             	shr    $0xc,%edx
  801071:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801078:	f6 c2 01             	test   $0x1,%dl
  80107b:	74 19                	je     801096 <fd_alloc+0x46>
  80107d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801082:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801087:	75 d2                	jne    80105b <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801089:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80108f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801094:	eb 07                	jmp    80109d <fd_alloc+0x4d>
			*fd_store = fd;
  801096:	89 01                	mov    %eax,(%ecx)
			return 0;
  801098:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010a5:	83 f8 1f             	cmp    $0x1f,%eax
  8010a8:	77 36                	ja     8010e0 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010aa:	c1 e0 0c             	shl    $0xc,%eax
  8010ad:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010b2:	89 c2                	mov    %eax,%edx
  8010b4:	c1 ea 16             	shr    $0x16,%edx
  8010b7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010be:	f6 c2 01             	test   $0x1,%dl
  8010c1:	74 24                	je     8010e7 <fd_lookup+0x48>
  8010c3:	89 c2                	mov    %eax,%edx
  8010c5:	c1 ea 0c             	shr    $0xc,%edx
  8010c8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010cf:	f6 c2 01             	test   $0x1,%dl
  8010d2:	74 1a                	je     8010ee <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d7:	89 02                	mov    %eax,(%edx)
	return 0;
  8010d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    
		return -E_INVAL;
  8010e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e5:	eb f7                	jmp    8010de <fd_lookup+0x3f>
		return -E_INVAL;
  8010e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ec:	eb f0                	jmp    8010de <fd_lookup+0x3f>
  8010ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f3:	eb e9                	jmp    8010de <fd_lookup+0x3f>

008010f5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fe:	ba 24 25 80 00       	mov    $0x802524,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801103:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801108:	39 08                	cmp    %ecx,(%eax)
  80110a:	74 33                	je     80113f <dev_lookup+0x4a>
  80110c:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80110f:	8b 02                	mov    (%edx),%eax
  801111:	85 c0                	test   %eax,%eax
  801113:	75 f3                	jne    801108 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801115:	a1 04 40 80 00       	mov    0x804004,%eax
  80111a:	8b 40 48             	mov    0x48(%eax),%eax
  80111d:	83 ec 04             	sub    $0x4,%esp
  801120:	51                   	push   %ecx
  801121:	50                   	push   %eax
  801122:	68 a8 24 80 00       	push   $0x8024a8
  801127:	e8 89 f0 ff ff       	call   8001b5 <cprintf>
	*dev = 0;
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801135:	83 c4 10             	add    $0x10,%esp
  801138:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    
			*dev = devtab[i];
  80113f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801142:	89 01                	mov    %eax,(%ecx)
			return 0;
  801144:	b8 00 00 00 00       	mov    $0x0,%eax
  801149:	eb f2                	jmp    80113d <dev_lookup+0x48>

0080114b <fd_close>:
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	57                   	push   %edi
  80114f:	56                   	push   %esi
  801150:	53                   	push   %ebx
  801151:	83 ec 1c             	sub    $0x1c,%esp
  801154:	8b 75 08             	mov    0x8(%ebp),%esi
  801157:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80115a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80115d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80115e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801164:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801167:	50                   	push   %eax
  801168:	e8 32 ff ff ff       	call   80109f <fd_lookup>
  80116d:	89 c3                	mov    %eax,%ebx
  80116f:	83 c4 08             	add    $0x8,%esp
  801172:	85 c0                	test   %eax,%eax
  801174:	78 05                	js     80117b <fd_close+0x30>
	    || fd != fd2)
  801176:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801179:	74 16                	je     801191 <fd_close+0x46>
		return (must_exist ? r : 0);
  80117b:	89 f8                	mov    %edi,%eax
  80117d:	84 c0                	test   %al,%al
  80117f:	b8 00 00 00 00       	mov    $0x0,%eax
  801184:	0f 44 d8             	cmove  %eax,%ebx
}
  801187:	89 d8                	mov    %ebx,%eax
  801189:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5f                   	pop    %edi
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801191:	83 ec 08             	sub    $0x8,%esp
  801194:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801197:	50                   	push   %eax
  801198:	ff 36                	pushl  (%esi)
  80119a:	e8 56 ff ff ff       	call   8010f5 <dev_lookup>
  80119f:	89 c3                	mov    %eax,%ebx
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	78 15                	js     8011bd <fd_close+0x72>
		if (dev->dev_close)
  8011a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ab:	8b 40 10             	mov    0x10(%eax),%eax
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	74 1b                	je     8011cd <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8011b2:	83 ec 0c             	sub    $0xc,%esp
  8011b5:	56                   	push   %esi
  8011b6:	ff d0                	call   *%eax
  8011b8:	89 c3                	mov    %eax,%ebx
  8011ba:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011bd:	83 ec 08             	sub    $0x8,%esp
  8011c0:	56                   	push   %esi
  8011c1:	6a 00                	push   $0x0
  8011c3:	e8 55 fa ff ff       	call   800c1d <sys_page_unmap>
	return r;
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	eb ba                	jmp    801187 <fd_close+0x3c>
			r = 0;
  8011cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d2:	eb e9                	jmp    8011bd <fd_close+0x72>

008011d4 <close>:

int
close(int fdnum)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
  8011d7:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011dd:	50                   	push   %eax
  8011de:	ff 75 08             	pushl  0x8(%ebp)
  8011e1:	e8 b9 fe ff ff       	call   80109f <fd_lookup>
  8011e6:	83 c4 08             	add    $0x8,%esp
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	78 10                	js     8011fd <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8011ed:	83 ec 08             	sub    $0x8,%esp
  8011f0:	6a 01                	push   $0x1
  8011f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f5:	e8 51 ff ff ff       	call   80114b <fd_close>
  8011fa:	83 c4 10             	add    $0x10,%esp
}
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <close_all>:

void
close_all(void)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	53                   	push   %ebx
  801203:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801206:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80120b:	83 ec 0c             	sub    $0xc,%esp
  80120e:	53                   	push   %ebx
  80120f:	e8 c0 ff ff ff       	call   8011d4 <close>
	for (i = 0; i < MAXFD; i++)
  801214:	83 c3 01             	add    $0x1,%ebx
  801217:	83 c4 10             	add    $0x10,%esp
  80121a:	83 fb 20             	cmp    $0x20,%ebx
  80121d:	75 ec                	jne    80120b <close_all+0xc>
}
  80121f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801222:	c9                   	leave  
  801223:	c3                   	ret    

00801224 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	57                   	push   %edi
  801228:	56                   	push   %esi
  801229:	53                   	push   %ebx
  80122a:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80122d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801230:	50                   	push   %eax
  801231:	ff 75 08             	pushl  0x8(%ebp)
  801234:	e8 66 fe ff ff       	call   80109f <fd_lookup>
  801239:	89 c3                	mov    %eax,%ebx
  80123b:	83 c4 08             	add    $0x8,%esp
  80123e:	85 c0                	test   %eax,%eax
  801240:	0f 88 81 00 00 00    	js     8012c7 <dup+0xa3>
		return r;
	close(newfdnum);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	ff 75 0c             	pushl  0xc(%ebp)
  80124c:	e8 83 ff ff ff       	call   8011d4 <close>

	newfd = INDEX2FD(newfdnum);
  801251:	8b 75 0c             	mov    0xc(%ebp),%esi
  801254:	c1 e6 0c             	shl    $0xc,%esi
  801257:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80125d:	83 c4 04             	add    $0x4,%esp
  801260:	ff 75 e4             	pushl  -0x1c(%ebp)
  801263:	e8 d1 fd ff ff       	call   801039 <fd2data>
  801268:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80126a:	89 34 24             	mov    %esi,(%esp)
  80126d:	e8 c7 fd ff ff       	call   801039 <fd2data>
  801272:	83 c4 10             	add    $0x10,%esp
  801275:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801277:	89 d8                	mov    %ebx,%eax
  801279:	c1 e8 16             	shr    $0x16,%eax
  80127c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801283:	a8 01                	test   $0x1,%al
  801285:	74 11                	je     801298 <dup+0x74>
  801287:	89 d8                	mov    %ebx,%eax
  801289:	c1 e8 0c             	shr    $0xc,%eax
  80128c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801293:	f6 c2 01             	test   $0x1,%dl
  801296:	75 39                	jne    8012d1 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801298:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80129b:	89 d0                	mov    %edx,%eax
  80129d:	c1 e8 0c             	shr    $0xc,%eax
  8012a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a7:	83 ec 0c             	sub    $0xc,%esp
  8012aa:	25 07 0e 00 00       	and    $0xe07,%eax
  8012af:	50                   	push   %eax
  8012b0:	56                   	push   %esi
  8012b1:	6a 00                	push   $0x0
  8012b3:	52                   	push   %edx
  8012b4:	6a 00                	push   $0x0
  8012b6:	e8 20 f9 ff ff       	call   800bdb <sys_page_map>
  8012bb:	89 c3                	mov    %eax,%ebx
  8012bd:	83 c4 20             	add    $0x20,%esp
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	78 31                	js     8012f5 <dup+0xd1>
		goto err;

	return newfdnum;
  8012c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012c7:	89 d8                	mov    %ebx,%eax
  8012c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cc:	5b                   	pop    %ebx
  8012cd:	5e                   	pop    %esi
  8012ce:	5f                   	pop    %edi
  8012cf:	5d                   	pop    %ebp
  8012d0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012d1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d8:	83 ec 0c             	sub    $0xc,%esp
  8012db:	25 07 0e 00 00       	and    $0xe07,%eax
  8012e0:	50                   	push   %eax
  8012e1:	57                   	push   %edi
  8012e2:	6a 00                	push   $0x0
  8012e4:	53                   	push   %ebx
  8012e5:	6a 00                	push   $0x0
  8012e7:	e8 ef f8 ff ff       	call   800bdb <sys_page_map>
  8012ec:	89 c3                	mov    %eax,%ebx
  8012ee:	83 c4 20             	add    $0x20,%esp
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	79 a3                	jns    801298 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012f5:	83 ec 08             	sub    $0x8,%esp
  8012f8:	56                   	push   %esi
  8012f9:	6a 00                	push   $0x0
  8012fb:	e8 1d f9 ff ff       	call   800c1d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801300:	83 c4 08             	add    $0x8,%esp
  801303:	57                   	push   %edi
  801304:	6a 00                	push   $0x0
  801306:	e8 12 f9 ff ff       	call   800c1d <sys_page_unmap>
	return r;
  80130b:	83 c4 10             	add    $0x10,%esp
  80130e:	eb b7                	jmp    8012c7 <dup+0xa3>

00801310 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	53                   	push   %ebx
  801314:	83 ec 14             	sub    $0x14,%esp
  801317:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80131a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80131d:	50                   	push   %eax
  80131e:	53                   	push   %ebx
  80131f:	e8 7b fd ff ff       	call   80109f <fd_lookup>
  801324:	83 c4 08             	add    $0x8,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	78 3f                	js     80136a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80132b:	83 ec 08             	sub    $0x8,%esp
  80132e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801335:	ff 30                	pushl  (%eax)
  801337:	e8 b9 fd ff ff       	call   8010f5 <dev_lookup>
  80133c:	83 c4 10             	add    $0x10,%esp
  80133f:	85 c0                	test   %eax,%eax
  801341:	78 27                	js     80136a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801343:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801346:	8b 42 08             	mov    0x8(%edx),%eax
  801349:	83 e0 03             	and    $0x3,%eax
  80134c:	83 f8 01             	cmp    $0x1,%eax
  80134f:	74 1e                	je     80136f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801354:	8b 40 08             	mov    0x8(%eax),%eax
  801357:	85 c0                	test   %eax,%eax
  801359:	74 35                	je     801390 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80135b:	83 ec 04             	sub    $0x4,%esp
  80135e:	ff 75 10             	pushl  0x10(%ebp)
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	52                   	push   %edx
  801365:	ff d0                	call   *%eax
  801367:	83 c4 10             	add    $0x10,%esp
}
  80136a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80136f:	a1 04 40 80 00       	mov    0x804004,%eax
  801374:	8b 40 48             	mov    0x48(%eax),%eax
  801377:	83 ec 04             	sub    $0x4,%esp
  80137a:	53                   	push   %ebx
  80137b:	50                   	push   %eax
  80137c:	68 e9 24 80 00       	push   $0x8024e9
  801381:	e8 2f ee ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  801386:	83 c4 10             	add    $0x10,%esp
  801389:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138e:	eb da                	jmp    80136a <read+0x5a>
		return -E_NOT_SUPP;
  801390:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801395:	eb d3                	jmp    80136a <read+0x5a>

00801397 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	57                   	push   %edi
  80139b:	56                   	push   %esi
  80139c:	53                   	push   %ebx
  80139d:	83 ec 0c             	sub    $0xc,%esp
  8013a0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013a3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ab:	39 f3                	cmp    %esi,%ebx
  8013ad:	73 25                	jae    8013d4 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013af:	83 ec 04             	sub    $0x4,%esp
  8013b2:	89 f0                	mov    %esi,%eax
  8013b4:	29 d8                	sub    %ebx,%eax
  8013b6:	50                   	push   %eax
  8013b7:	89 d8                	mov    %ebx,%eax
  8013b9:	03 45 0c             	add    0xc(%ebp),%eax
  8013bc:	50                   	push   %eax
  8013bd:	57                   	push   %edi
  8013be:	e8 4d ff ff ff       	call   801310 <read>
		if (m < 0)
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 08                	js     8013d2 <readn+0x3b>
			return m;
		if (m == 0)
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	74 06                	je     8013d4 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8013ce:	01 c3                	add    %eax,%ebx
  8013d0:	eb d9                	jmp    8013ab <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013d2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013d4:	89 d8                	mov    %ebx,%eax
  8013d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d9:	5b                   	pop    %ebx
  8013da:	5e                   	pop    %esi
  8013db:	5f                   	pop    %edi
  8013dc:	5d                   	pop    %ebp
  8013dd:	c3                   	ret    

008013de <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	53                   	push   %ebx
  8013e2:	83 ec 14             	sub    $0x14,%esp
  8013e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013eb:	50                   	push   %eax
  8013ec:	53                   	push   %ebx
  8013ed:	e8 ad fc ff ff       	call   80109f <fd_lookup>
  8013f2:	83 c4 08             	add    $0x8,%esp
  8013f5:	85 c0                	test   %eax,%eax
  8013f7:	78 3a                	js     801433 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013f9:	83 ec 08             	sub    $0x8,%esp
  8013fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ff:	50                   	push   %eax
  801400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801403:	ff 30                	pushl  (%eax)
  801405:	e8 eb fc ff ff       	call   8010f5 <dev_lookup>
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	85 c0                	test   %eax,%eax
  80140f:	78 22                	js     801433 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801414:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801418:	74 1e                	je     801438 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80141a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141d:	8b 52 0c             	mov    0xc(%edx),%edx
  801420:	85 d2                	test   %edx,%edx
  801422:	74 35                	je     801459 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801424:	83 ec 04             	sub    $0x4,%esp
  801427:	ff 75 10             	pushl  0x10(%ebp)
  80142a:	ff 75 0c             	pushl  0xc(%ebp)
  80142d:	50                   	push   %eax
  80142e:	ff d2                	call   *%edx
  801430:	83 c4 10             	add    $0x10,%esp
}
  801433:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801436:	c9                   	leave  
  801437:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801438:	a1 04 40 80 00       	mov    0x804004,%eax
  80143d:	8b 40 48             	mov    0x48(%eax),%eax
  801440:	83 ec 04             	sub    $0x4,%esp
  801443:	53                   	push   %ebx
  801444:	50                   	push   %eax
  801445:	68 05 25 80 00       	push   $0x802505
  80144a:	e8 66 ed ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  80144f:	83 c4 10             	add    $0x10,%esp
  801452:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801457:	eb da                	jmp    801433 <write+0x55>
		return -E_NOT_SUPP;
  801459:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80145e:	eb d3                	jmp    801433 <write+0x55>

00801460 <seek>:

int
seek(int fdnum, off_t offset)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801466:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801469:	50                   	push   %eax
  80146a:	ff 75 08             	pushl  0x8(%ebp)
  80146d:	e8 2d fc ff ff       	call   80109f <fd_lookup>
  801472:	83 c4 08             	add    $0x8,%esp
  801475:	85 c0                	test   %eax,%eax
  801477:	78 0e                	js     801487 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801479:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80147f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801487:	c9                   	leave  
  801488:	c3                   	ret    

00801489 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	53                   	push   %ebx
  80148d:	83 ec 14             	sub    $0x14,%esp
  801490:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801493:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801496:	50                   	push   %eax
  801497:	53                   	push   %ebx
  801498:	e8 02 fc ff ff       	call   80109f <fd_lookup>
  80149d:	83 c4 08             	add    $0x8,%esp
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	78 37                	js     8014db <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a4:	83 ec 08             	sub    $0x8,%esp
  8014a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014aa:	50                   	push   %eax
  8014ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ae:	ff 30                	pushl  (%eax)
  8014b0:	e8 40 fc ff ff       	call   8010f5 <dev_lookup>
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	78 1f                	js     8014db <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bf:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014c3:	74 1b                	je     8014e0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c8:	8b 52 18             	mov    0x18(%edx),%edx
  8014cb:	85 d2                	test   %edx,%edx
  8014cd:	74 32                	je     801501 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014cf:	83 ec 08             	sub    $0x8,%esp
  8014d2:	ff 75 0c             	pushl  0xc(%ebp)
  8014d5:	50                   	push   %eax
  8014d6:	ff d2                	call   *%edx
  8014d8:	83 c4 10             	add    $0x10,%esp
}
  8014db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014e0:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014e5:	8b 40 48             	mov    0x48(%eax),%eax
  8014e8:	83 ec 04             	sub    $0x4,%esp
  8014eb:	53                   	push   %ebx
  8014ec:	50                   	push   %eax
  8014ed:	68 c8 24 80 00       	push   $0x8024c8
  8014f2:	e8 be ec ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ff:	eb da                	jmp    8014db <ftruncate+0x52>
		return -E_NOT_SUPP;
  801501:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801506:	eb d3                	jmp    8014db <ftruncate+0x52>

00801508 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	53                   	push   %ebx
  80150c:	83 ec 14             	sub    $0x14,%esp
  80150f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801512:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801515:	50                   	push   %eax
  801516:	ff 75 08             	pushl  0x8(%ebp)
  801519:	e8 81 fb ff ff       	call   80109f <fd_lookup>
  80151e:	83 c4 08             	add    $0x8,%esp
  801521:	85 c0                	test   %eax,%eax
  801523:	78 4b                	js     801570 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801525:	83 ec 08             	sub    $0x8,%esp
  801528:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152b:	50                   	push   %eax
  80152c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152f:	ff 30                	pushl  (%eax)
  801531:	e8 bf fb ff ff       	call   8010f5 <dev_lookup>
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	85 c0                	test   %eax,%eax
  80153b:	78 33                	js     801570 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80153d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801540:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801544:	74 2f                	je     801575 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801546:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801549:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801550:	00 00 00 
	stat->st_isdir = 0;
  801553:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80155a:	00 00 00 
	stat->st_dev = dev;
  80155d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801563:	83 ec 08             	sub    $0x8,%esp
  801566:	53                   	push   %ebx
  801567:	ff 75 f0             	pushl  -0x10(%ebp)
  80156a:	ff 50 14             	call   *0x14(%eax)
  80156d:	83 c4 10             	add    $0x10,%esp
}
  801570:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801573:	c9                   	leave  
  801574:	c3                   	ret    
		return -E_NOT_SUPP;
  801575:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80157a:	eb f4                	jmp    801570 <fstat+0x68>

0080157c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	56                   	push   %esi
  801580:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	6a 00                	push   $0x0
  801586:	ff 75 08             	pushl  0x8(%ebp)
  801589:	e8 e7 01 00 00       	call   801775 <open>
  80158e:	89 c3                	mov    %eax,%ebx
  801590:	83 c4 10             	add    $0x10,%esp
  801593:	85 c0                	test   %eax,%eax
  801595:	78 1b                	js     8015b2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801597:	83 ec 08             	sub    $0x8,%esp
  80159a:	ff 75 0c             	pushl  0xc(%ebp)
  80159d:	50                   	push   %eax
  80159e:	e8 65 ff ff ff       	call   801508 <fstat>
  8015a3:	89 c6                	mov    %eax,%esi
	close(fd);
  8015a5:	89 1c 24             	mov    %ebx,(%esp)
  8015a8:	e8 27 fc ff ff       	call   8011d4 <close>
	return r;
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	89 f3                	mov    %esi,%ebx
}
  8015b2:	89 d8                	mov    %ebx,%eax
  8015b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b7:	5b                   	pop    %ebx
  8015b8:	5e                   	pop    %esi
  8015b9:	5d                   	pop    %ebp
  8015ba:	c3                   	ret    

008015bb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	56                   	push   %esi
  8015bf:	53                   	push   %ebx
  8015c0:	89 c6                	mov    %eax,%esi
  8015c2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015c4:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015cb:	74 27                	je     8015f4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015cd:	6a 07                	push   $0x7
  8015cf:	68 00 50 80 00       	push   $0x805000
  8015d4:	56                   	push   %esi
  8015d5:	ff 35 00 40 80 00    	pushl  0x804000
  8015db:	e8 f9 f9 ff ff       	call   800fd9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015e0:	83 c4 0c             	add    $0xc,%esp
  8015e3:	6a 00                	push   $0x0
  8015e5:	53                   	push   %ebx
  8015e6:	6a 00                	push   $0x0
  8015e8:	e8 d5 f9 ff ff       	call   800fc2 <ipc_recv>
}
  8015ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5d                   	pop    %ebp
  8015f3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015f4:	83 ec 0c             	sub    $0xc,%esp
  8015f7:	6a 01                	push   $0x1
  8015f9:	e8 f2 f9 ff ff       	call   800ff0 <ipc_find_env>
  8015fe:	a3 00 40 80 00       	mov    %eax,0x804000
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	eb c5                	jmp    8015cd <fsipc+0x12>

00801608 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	8b 40 0c             	mov    0xc(%eax),%eax
  801614:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801619:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801621:	ba 00 00 00 00       	mov    $0x0,%edx
  801626:	b8 02 00 00 00       	mov    $0x2,%eax
  80162b:	e8 8b ff ff ff       	call   8015bb <fsipc>
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <devfile_flush>:
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	8b 40 0c             	mov    0xc(%eax),%eax
  80163e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801643:	ba 00 00 00 00       	mov    $0x0,%edx
  801648:	b8 06 00 00 00       	mov    $0x6,%eax
  80164d:	e8 69 ff ff ff       	call   8015bb <fsipc>
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <devfile_stat>:
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	53                   	push   %ebx
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8b 40 0c             	mov    0xc(%eax),%eax
  801664:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801669:	ba 00 00 00 00       	mov    $0x0,%edx
  80166e:	b8 05 00 00 00       	mov    $0x5,%eax
  801673:	e8 43 ff ff ff       	call   8015bb <fsipc>
  801678:	85 c0                	test   %eax,%eax
  80167a:	78 2c                	js     8016a8 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80167c:	83 ec 08             	sub    $0x8,%esp
  80167f:	68 00 50 80 00       	push   $0x805000
  801684:	53                   	push   %ebx
  801685:	e8 15 f1 ff ff       	call   80079f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80168a:	a1 80 50 80 00       	mov    0x805080,%eax
  80168f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801695:	a1 84 50 80 00       	mov    0x805084,%eax
  80169a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <devfile_write>:
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 0c             	sub    $0xc,%esp
  8016b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b6:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016bb:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8016c0:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c6:	8b 52 0c             	mov    0xc(%edx),%edx
  8016c9:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8016cf:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8016d4:	50                   	push   %eax
  8016d5:	ff 75 0c             	pushl  0xc(%ebp)
  8016d8:	68 08 50 80 00       	push   $0x805008
  8016dd:	e8 4b f2 ff ff       	call   80092d <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e7:	b8 04 00 00 00       	mov    $0x4,%eax
  8016ec:	e8 ca fe ff ff       	call   8015bb <fsipc>
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <devfile_read>:
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	56                   	push   %esi
  8016f7:	53                   	push   %ebx
  8016f8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8b 40 0c             	mov    0xc(%eax),%eax
  801701:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801706:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80170c:	ba 00 00 00 00       	mov    $0x0,%edx
  801711:	b8 03 00 00 00       	mov    $0x3,%eax
  801716:	e8 a0 fe ff ff       	call   8015bb <fsipc>
  80171b:	89 c3                	mov    %eax,%ebx
  80171d:	85 c0                	test   %eax,%eax
  80171f:	78 1f                	js     801740 <devfile_read+0x4d>
	assert(r <= n);
  801721:	39 f0                	cmp    %esi,%eax
  801723:	77 24                	ja     801749 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801725:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80172a:	7f 33                	jg     80175f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80172c:	83 ec 04             	sub    $0x4,%esp
  80172f:	50                   	push   %eax
  801730:	68 00 50 80 00       	push   $0x805000
  801735:	ff 75 0c             	pushl  0xc(%ebp)
  801738:	e8 f0 f1 ff ff       	call   80092d <memmove>
	return r;
  80173d:	83 c4 10             	add    $0x10,%esp
}
  801740:	89 d8                	mov    %ebx,%eax
  801742:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801745:	5b                   	pop    %ebx
  801746:	5e                   	pop    %esi
  801747:	5d                   	pop    %ebp
  801748:	c3                   	ret    
	assert(r <= n);
  801749:	68 34 25 80 00       	push   $0x802534
  80174e:	68 3b 25 80 00       	push   $0x80253b
  801753:	6a 7c                	push   $0x7c
  801755:	68 50 25 80 00       	push   $0x802550
  80175a:	e8 85 05 00 00       	call   801ce4 <_panic>
	assert(r <= PGSIZE);
  80175f:	68 5b 25 80 00       	push   $0x80255b
  801764:	68 3b 25 80 00       	push   $0x80253b
  801769:	6a 7d                	push   $0x7d
  80176b:	68 50 25 80 00       	push   $0x802550
  801770:	e8 6f 05 00 00       	call   801ce4 <_panic>

00801775 <open>:
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	56                   	push   %esi
  801779:	53                   	push   %ebx
  80177a:	83 ec 1c             	sub    $0x1c,%esp
  80177d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801780:	56                   	push   %esi
  801781:	e8 e2 ef ff ff       	call   800768 <strlen>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80178e:	7f 6c                	jg     8017fc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801790:	83 ec 0c             	sub    $0xc,%esp
  801793:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801796:	50                   	push   %eax
  801797:	e8 b4 f8 ff ff       	call   801050 <fd_alloc>
  80179c:	89 c3                	mov    %eax,%ebx
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	78 3c                	js     8017e1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017a5:	83 ec 08             	sub    $0x8,%esp
  8017a8:	56                   	push   %esi
  8017a9:	68 00 50 80 00       	push   $0x805000
  8017ae:	e8 ec ef ff ff       	call   80079f <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b6:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017be:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c3:	e8 f3 fd ff ff       	call   8015bb <fsipc>
  8017c8:	89 c3                	mov    %eax,%ebx
  8017ca:	83 c4 10             	add    $0x10,%esp
  8017cd:	85 c0                	test   %eax,%eax
  8017cf:	78 19                	js     8017ea <open+0x75>
	return fd2num(fd);
  8017d1:	83 ec 0c             	sub    $0xc,%esp
  8017d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d7:	e8 4d f8 ff ff       	call   801029 <fd2num>
  8017dc:	89 c3                	mov    %eax,%ebx
  8017de:	83 c4 10             	add    $0x10,%esp
}
  8017e1:	89 d8                	mov    %ebx,%eax
  8017e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e6:	5b                   	pop    %ebx
  8017e7:	5e                   	pop    %esi
  8017e8:	5d                   	pop    %ebp
  8017e9:	c3                   	ret    
		fd_close(fd, 0);
  8017ea:	83 ec 08             	sub    $0x8,%esp
  8017ed:	6a 00                	push   $0x0
  8017ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f2:	e8 54 f9 ff ff       	call   80114b <fd_close>
		return r;
  8017f7:	83 c4 10             	add    $0x10,%esp
  8017fa:	eb e5                	jmp    8017e1 <open+0x6c>
		return -E_BAD_PATH;
  8017fc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801801:	eb de                	jmp    8017e1 <open+0x6c>

00801803 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801809:	ba 00 00 00 00       	mov    $0x0,%edx
  80180e:	b8 08 00 00 00       	mov    $0x8,%eax
  801813:	e8 a3 fd ff ff       	call   8015bb <fsipc>
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	56                   	push   %esi
  80181e:	53                   	push   %ebx
  80181f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801822:	83 ec 0c             	sub    $0xc,%esp
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	e8 0c f8 ff ff       	call   801039 <fd2data>
  80182d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80182f:	83 c4 08             	add    $0x8,%esp
  801832:	68 67 25 80 00       	push   $0x802567
  801837:	53                   	push   %ebx
  801838:	e8 62 ef ff ff       	call   80079f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80183d:	8b 46 04             	mov    0x4(%esi),%eax
  801840:	2b 06                	sub    (%esi),%eax
  801842:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801848:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80184f:	00 00 00 
	stat->st_dev = &devpipe;
  801852:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801859:	30 80 00 
	return 0;
}
  80185c:	b8 00 00 00 00       	mov    $0x0,%eax
  801861:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801864:	5b                   	pop    %ebx
  801865:	5e                   	pop    %esi
  801866:	5d                   	pop    %ebp
  801867:	c3                   	ret    

00801868 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	53                   	push   %ebx
  80186c:	83 ec 0c             	sub    $0xc,%esp
  80186f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801872:	53                   	push   %ebx
  801873:	6a 00                	push   $0x0
  801875:	e8 a3 f3 ff ff       	call   800c1d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80187a:	89 1c 24             	mov    %ebx,(%esp)
  80187d:	e8 b7 f7 ff ff       	call   801039 <fd2data>
  801882:	83 c4 08             	add    $0x8,%esp
  801885:	50                   	push   %eax
  801886:	6a 00                	push   $0x0
  801888:	e8 90 f3 ff ff       	call   800c1d <sys_page_unmap>
}
  80188d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <_pipeisclosed>:
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	57                   	push   %edi
  801896:	56                   	push   %esi
  801897:	53                   	push   %ebx
  801898:	83 ec 1c             	sub    $0x1c,%esp
  80189b:	89 c7                	mov    %eax,%edi
  80189d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80189f:	a1 04 40 80 00       	mov    0x804004,%eax
  8018a4:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8018a7:	83 ec 0c             	sub    $0xc,%esp
  8018aa:	57                   	push   %edi
  8018ab:	e8 15 05 00 00       	call   801dc5 <pageref>
  8018b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018b3:	89 34 24             	mov    %esi,(%esp)
  8018b6:	e8 0a 05 00 00       	call   801dc5 <pageref>
		nn = thisenv->env_runs;
  8018bb:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8018c1:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8018c4:	83 c4 10             	add    $0x10,%esp
  8018c7:	39 cb                	cmp    %ecx,%ebx
  8018c9:	74 1b                	je     8018e6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8018cb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018ce:	75 cf                	jne    80189f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8018d0:	8b 42 58             	mov    0x58(%edx),%eax
  8018d3:	6a 01                	push   $0x1
  8018d5:	50                   	push   %eax
  8018d6:	53                   	push   %ebx
  8018d7:	68 6e 25 80 00       	push   $0x80256e
  8018dc:	e8 d4 e8 ff ff       	call   8001b5 <cprintf>
  8018e1:	83 c4 10             	add    $0x10,%esp
  8018e4:	eb b9                	jmp    80189f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8018e6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8018e9:	0f 94 c0             	sete   %al
  8018ec:	0f b6 c0             	movzbl %al,%eax
}
  8018ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018f2:	5b                   	pop    %ebx
  8018f3:	5e                   	pop    %esi
  8018f4:	5f                   	pop    %edi
  8018f5:	5d                   	pop    %ebp
  8018f6:	c3                   	ret    

008018f7 <devpipe_write>:
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	57                   	push   %edi
  8018fb:	56                   	push   %esi
  8018fc:	53                   	push   %ebx
  8018fd:	83 ec 28             	sub    $0x28,%esp
  801900:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801903:	56                   	push   %esi
  801904:	e8 30 f7 ff ff       	call   801039 <fd2data>
  801909:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80190b:	83 c4 10             	add    $0x10,%esp
  80190e:	bf 00 00 00 00       	mov    $0x0,%edi
  801913:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801916:	74 4f                	je     801967 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801918:	8b 43 04             	mov    0x4(%ebx),%eax
  80191b:	8b 0b                	mov    (%ebx),%ecx
  80191d:	8d 51 20             	lea    0x20(%ecx),%edx
  801920:	39 d0                	cmp    %edx,%eax
  801922:	72 14                	jb     801938 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801924:	89 da                	mov    %ebx,%edx
  801926:	89 f0                	mov    %esi,%eax
  801928:	e8 65 ff ff ff       	call   801892 <_pipeisclosed>
  80192d:	85 c0                	test   %eax,%eax
  80192f:	75 3a                	jne    80196b <devpipe_write+0x74>
			sys_yield();
  801931:	e8 43 f2 ff ff       	call   800b79 <sys_yield>
  801936:	eb e0                	jmp    801918 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801938:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80193b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80193f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801942:	89 c2                	mov    %eax,%edx
  801944:	c1 fa 1f             	sar    $0x1f,%edx
  801947:	89 d1                	mov    %edx,%ecx
  801949:	c1 e9 1b             	shr    $0x1b,%ecx
  80194c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80194f:	83 e2 1f             	and    $0x1f,%edx
  801952:	29 ca                	sub    %ecx,%edx
  801954:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801958:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80195c:	83 c0 01             	add    $0x1,%eax
  80195f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801962:	83 c7 01             	add    $0x1,%edi
  801965:	eb ac                	jmp    801913 <devpipe_write+0x1c>
	return i;
  801967:	89 f8                	mov    %edi,%eax
  801969:	eb 05                	jmp    801970 <devpipe_write+0x79>
				return 0;
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801970:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801973:	5b                   	pop    %ebx
  801974:	5e                   	pop    %esi
  801975:	5f                   	pop    %edi
  801976:	5d                   	pop    %ebp
  801977:	c3                   	ret    

00801978 <devpipe_read>:
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	57                   	push   %edi
  80197c:	56                   	push   %esi
  80197d:	53                   	push   %ebx
  80197e:	83 ec 18             	sub    $0x18,%esp
  801981:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801984:	57                   	push   %edi
  801985:	e8 af f6 ff ff       	call   801039 <fd2data>
  80198a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	be 00 00 00 00       	mov    $0x0,%esi
  801994:	3b 75 10             	cmp    0x10(%ebp),%esi
  801997:	74 47                	je     8019e0 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801999:	8b 03                	mov    (%ebx),%eax
  80199b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80199e:	75 22                	jne    8019c2 <devpipe_read+0x4a>
			if (i > 0)
  8019a0:	85 f6                	test   %esi,%esi
  8019a2:	75 14                	jne    8019b8 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8019a4:	89 da                	mov    %ebx,%edx
  8019a6:	89 f8                	mov    %edi,%eax
  8019a8:	e8 e5 fe ff ff       	call   801892 <_pipeisclosed>
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	75 33                	jne    8019e4 <devpipe_read+0x6c>
			sys_yield();
  8019b1:	e8 c3 f1 ff ff       	call   800b79 <sys_yield>
  8019b6:	eb e1                	jmp    801999 <devpipe_read+0x21>
				return i;
  8019b8:	89 f0                	mov    %esi,%eax
}
  8019ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019bd:	5b                   	pop    %ebx
  8019be:	5e                   	pop    %esi
  8019bf:	5f                   	pop    %edi
  8019c0:	5d                   	pop    %ebp
  8019c1:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8019c2:	99                   	cltd   
  8019c3:	c1 ea 1b             	shr    $0x1b,%edx
  8019c6:	01 d0                	add    %edx,%eax
  8019c8:	83 e0 1f             	and    $0x1f,%eax
  8019cb:	29 d0                	sub    %edx,%eax
  8019cd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8019d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019d5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8019d8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8019db:	83 c6 01             	add    $0x1,%esi
  8019de:	eb b4                	jmp    801994 <devpipe_read+0x1c>
	return i;
  8019e0:	89 f0                	mov    %esi,%eax
  8019e2:	eb d6                	jmp    8019ba <devpipe_read+0x42>
				return 0;
  8019e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e9:	eb cf                	jmp    8019ba <devpipe_read+0x42>

008019eb <pipe>:
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	56                   	push   %esi
  8019ef:	53                   	push   %ebx
  8019f0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8019f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f6:	50                   	push   %eax
  8019f7:	e8 54 f6 ff ff       	call   801050 <fd_alloc>
  8019fc:	89 c3                	mov    %eax,%ebx
  8019fe:	83 c4 10             	add    $0x10,%esp
  801a01:	85 c0                	test   %eax,%eax
  801a03:	78 5b                	js     801a60 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a05:	83 ec 04             	sub    $0x4,%esp
  801a08:	68 07 04 00 00       	push   $0x407
  801a0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a10:	6a 00                	push   $0x0
  801a12:	e8 81 f1 ff ff       	call   800b98 <sys_page_alloc>
  801a17:	89 c3                	mov    %eax,%ebx
  801a19:	83 c4 10             	add    $0x10,%esp
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	78 40                	js     801a60 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801a20:	83 ec 0c             	sub    $0xc,%esp
  801a23:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a26:	50                   	push   %eax
  801a27:	e8 24 f6 ff ff       	call   801050 <fd_alloc>
  801a2c:	89 c3                	mov    %eax,%ebx
  801a2e:	83 c4 10             	add    $0x10,%esp
  801a31:	85 c0                	test   %eax,%eax
  801a33:	78 1b                	js     801a50 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	68 07 04 00 00       	push   $0x407
  801a3d:	ff 75 f0             	pushl  -0x10(%ebp)
  801a40:	6a 00                	push   $0x0
  801a42:	e8 51 f1 ff ff       	call   800b98 <sys_page_alloc>
  801a47:	89 c3                	mov    %eax,%ebx
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	79 19                	jns    801a69 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801a50:	83 ec 08             	sub    $0x8,%esp
  801a53:	ff 75 f4             	pushl  -0xc(%ebp)
  801a56:	6a 00                	push   $0x0
  801a58:	e8 c0 f1 ff ff       	call   800c1d <sys_page_unmap>
  801a5d:	83 c4 10             	add    $0x10,%esp
}
  801a60:	89 d8                	mov    %ebx,%eax
  801a62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a65:	5b                   	pop    %ebx
  801a66:	5e                   	pop    %esi
  801a67:	5d                   	pop    %ebp
  801a68:	c3                   	ret    
	va = fd2data(fd0);
  801a69:	83 ec 0c             	sub    $0xc,%esp
  801a6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a6f:	e8 c5 f5 ff ff       	call   801039 <fd2data>
  801a74:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a76:	83 c4 0c             	add    $0xc,%esp
  801a79:	68 07 04 00 00       	push   $0x407
  801a7e:	50                   	push   %eax
  801a7f:	6a 00                	push   $0x0
  801a81:	e8 12 f1 ff ff       	call   800b98 <sys_page_alloc>
  801a86:	89 c3                	mov    %eax,%ebx
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	0f 88 8c 00 00 00    	js     801b1f <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a93:	83 ec 0c             	sub    $0xc,%esp
  801a96:	ff 75 f0             	pushl  -0x10(%ebp)
  801a99:	e8 9b f5 ff ff       	call   801039 <fd2data>
  801a9e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801aa5:	50                   	push   %eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	56                   	push   %esi
  801aa9:	6a 00                	push   $0x0
  801aab:	e8 2b f1 ff ff       	call   800bdb <sys_page_map>
  801ab0:	89 c3                	mov    %eax,%ebx
  801ab2:	83 c4 20             	add    $0x20,%esp
  801ab5:	85 c0                	test   %eax,%eax
  801ab7:	78 58                	js     801b11 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abc:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ac2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ad7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801adc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ae3:	83 ec 0c             	sub    $0xc,%esp
  801ae6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae9:	e8 3b f5 ff ff       	call   801029 <fd2num>
  801aee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801af3:	83 c4 04             	add    $0x4,%esp
  801af6:	ff 75 f0             	pushl  -0x10(%ebp)
  801af9:	e8 2b f5 ff ff       	call   801029 <fd2num>
  801afe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b01:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801b04:	83 c4 10             	add    $0x10,%esp
  801b07:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b0c:	e9 4f ff ff ff       	jmp    801a60 <pipe+0x75>
	sys_page_unmap(0, va);
  801b11:	83 ec 08             	sub    $0x8,%esp
  801b14:	56                   	push   %esi
  801b15:	6a 00                	push   $0x0
  801b17:	e8 01 f1 ff ff       	call   800c1d <sys_page_unmap>
  801b1c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801b1f:	83 ec 08             	sub    $0x8,%esp
  801b22:	ff 75 f0             	pushl  -0x10(%ebp)
  801b25:	6a 00                	push   $0x0
  801b27:	e8 f1 f0 ff ff       	call   800c1d <sys_page_unmap>
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	e9 1c ff ff ff       	jmp    801a50 <pipe+0x65>

00801b34 <pipeisclosed>:
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3d:	50                   	push   %eax
  801b3e:	ff 75 08             	pushl  0x8(%ebp)
  801b41:	e8 59 f5 ff ff       	call   80109f <fd_lookup>
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	85 c0                	test   %eax,%eax
  801b4b:	78 18                	js     801b65 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801b4d:	83 ec 0c             	sub    $0xc,%esp
  801b50:	ff 75 f4             	pushl  -0xc(%ebp)
  801b53:	e8 e1 f4 ff ff       	call   801039 <fd2data>
	return _pipeisclosed(fd, p);
  801b58:	89 c2                	mov    %eax,%edx
  801b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5d:	e8 30 fd ff ff       	call   801892 <_pipeisclosed>
  801b62:	83 c4 10             	add    $0x10,%esp
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    

00801b71 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801b77:	68 86 25 80 00       	push   $0x802586
  801b7c:	ff 75 0c             	pushl  0xc(%ebp)
  801b7f:	e8 1b ec ff ff       	call   80079f <strcpy>
	return 0;
}
  801b84:	b8 00 00 00 00       	mov    $0x0,%eax
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <devcons_write>:
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	57                   	push   %edi
  801b8f:	56                   	push   %esi
  801b90:	53                   	push   %ebx
  801b91:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b97:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b9c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ba2:	eb 2f                	jmp    801bd3 <devcons_write+0x48>
		m = n - tot;
  801ba4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ba7:	29 f3                	sub    %esi,%ebx
  801ba9:	83 fb 7f             	cmp    $0x7f,%ebx
  801bac:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801bb1:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	53                   	push   %ebx
  801bb8:	89 f0                	mov    %esi,%eax
  801bba:	03 45 0c             	add    0xc(%ebp),%eax
  801bbd:	50                   	push   %eax
  801bbe:	57                   	push   %edi
  801bbf:	e8 69 ed ff ff       	call   80092d <memmove>
		sys_cputs(buf, m);
  801bc4:	83 c4 08             	add    $0x8,%esp
  801bc7:	53                   	push   %ebx
  801bc8:	57                   	push   %edi
  801bc9:	e8 0e ef ff ff       	call   800adc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801bce:	01 de                	add    %ebx,%esi
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bd6:	72 cc                	jb     801ba4 <devcons_write+0x19>
}
  801bd8:	89 f0                	mov    %esi,%eax
  801bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bdd:	5b                   	pop    %ebx
  801bde:	5e                   	pop    %esi
  801bdf:	5f                   	pop    %edi
  801be0:	5d                   	pop    %ebp
  801be1:	c3                   	ret    

00801be2 <devcons_read>:
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	83 ec 08             	sub    $0x8,%esp
  801be8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801bed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bf1:	75 07                	jne    801bfa <devcons_read+0x18>
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    
		sys_yield();
  801bf5:	e8 7f ef ff ff       	call   800b79 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801bfa:	e8 fb ee ff ff       	call   800afa <sys_cgetc>
  801bff:	85 c0                	test   %eax,%eax
  801c01:	74 f2                	je     801bf5 <devcons_read+0x13>
	if (c < 0)
  801c03:	85 c0                	test   %eax,%eax
  801c05:	78 ec                	js     801bf3 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801c07:	83 f8 04             	cmp    $0x4,%eax
  801c0a:	74 0c                	je     801c18 <devcons_read+0x36>
	*(char*)vbuf = c;
  801c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0f:	88 02                	mov    %al,(%edx)
	return 1;
  801c11:	b8 01 00 00 00       	mov    $0x1,%eax
  801c16:	eb db                	jmp    801bf3 <devcons_read+0x11>
		return 0;
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1d:	eb d4                	jmp    801bf3 <devcons_read+0x11>

00801c1f <cputchar>:
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801c2b:	6a 01                	push   $0x1
  801c2d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c30:	50                   	push   %eax
  801c31:	e8 a6 ee ff ff       	call   800adc <sys_cputs>
}
  801c36:	83 c4 10             	add    $0x10,%esp
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <getchar>:
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801c41:	6a 01                	push   $0x1
  801c43:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801c46:	50                   	push   %eax
  801c47:	6a 00                	push   $0x0
  801c49:	e8 c2 f6 ff ff       	call   801310 <read>
	if (r < 0)
  801c4e:	83 c4 10             	add    $0x10,%esp
  801c51:	85 c0                	test   %eax,%eax
  801c53:	78 08                	js     801c5d <getchar+0x22>
	if (r < 1)
  801c55:	85 c0                	test   %eax,%eax
  801c57:	7e 06                	jle    801c5f <getchar+0x24>
	return c;
  801c59:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    
		return -E_EOF;
  801c5f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c64:	eb f7                	jmp    801c5d <getchar+0x22>

00801c66 <iscons>:
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c6f:	50                   	push   %eax
  801c70:	ff 75 08             	pushl  0x8(%ebp)
  801c73:	e8 27 f4 ff ff       	call   80109f <fd_lookup>
  801c78:	83 c4 10             	add    $0x10,%esp
  801c7b:	85 c0                	test   %eax,%eax
  801c7d:	78 11                	js     801c90 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c82:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c88:	39 10                	cmp    %edx,(%eax)
  801c8a:	0f 94 c0             	sete   %al
  801c8d:	0f b6 c0             	movzbl %al,%eax
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <opencons>:
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c9b:	50                   	push   %eax
  801c9c:	e8 af f3 ff ff       	call   801050 <fd_alloc>
  801ca1:	83 c4 10             	add    $0x10,%esp
  801ca4:	85 c0                	test   %eax,%eax
  801ca6:	78 3a                	js     801ce2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ca8:	83 ec 04             	sub    $0x4,%esp
  801cab:	68 07 04 00 00       	push   $0x407
  801cb0:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb3:	6a 00                	push   $0x0
  801cb5:	e8 de ee ff ff       	call   800b98 <sys_page_alloc>
  801cba:	83 c4 10             	add    $0x10,%esp
  801cbd:	85 c0                	test   %eax,%eax
  801cbf:	78 21                	js     801ce2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cca:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801cd6:	83 ec 0c             	sub    $0xc,%esp
  801cd9:	50                   	push   %eax
  801cda:	e8 4a f3 ff ff       	call   801029 <fd2num>
  801cdf:	83 c4 10             	add    $0x10,%esp
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	56                   	push   %esi
  801ce8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801ce9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801cec:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801cf2:	e8 63 ee ff ff       	call   800b5a <sys_getenvid>
  801cf7:	83 ec 0c             	sub    $0xc,%esp
  801cfa:	ff 75 0c             	pushl  0xc(%ebp)
  801cfd:	ff 75 08             	pushl  0x8(%ebp)
  801d00:	56                   	push   %esi
  801d01:	50                   	push   %eax
  801d02:	68 94 25 80 00       	push   $0x802594
  801d07:	e8 a9 e4 ff ff       	call   8001b5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801d0c:	83 c4 18             	add    $0x18,%esp
  801d0f:	53                   	push   %ebx
  801d10:	ff 75 10             	pushl  0x10(%ebp)
  801d13:	e8 4c e4 ff ff       	call   800164 <vcprintf>
	cprintf("\n");
  801d18:	c7 04 24 7f 25 80 00 	movl   $0x80257f,(%esp)
  801d1f:	e8 91 e4 ff ff       	call   8001b5 <cprintf>
  801d24:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d27:	cc                   	int3   
  801d28:	eb fd                	jmp    801d27 <_panic+0x43>

00801d2a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	53                   	push   %ebx
  801d2e:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801d31:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801d38:	74 0d                	je     801d47 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801d42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801d47:	e8 0e ee ff ff       	call   800b5a <sys_getenvid>
  801d4c:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	6a 07                	push   $0x7
  801d53:	68 00 f0 bf ee       	push   $0xeebff000
  801d58:	50                   	push   %eax
  801d59:	e8 3a ee ff ff       	call   800b98 <sys_page_alloc>
        	if (r < 0) {
  801d5e:	83 c4 10             	add    $0x10,%esp
  801d61:	85 c0                	test   %eax,%eax
  801d63:	78 27                	js     801d8c <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801d65:	83 ec 08             	sub    $0x8,%esp
  801d68:	68 9e 1d 80 00       	push   $0x801d9e
  801d6d:	53                   	push   %ebx
  801d6e:	e8 70 ef ff ff       	call   800ce3 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801d73:	83 c4 10             	add    $0x10,%esp
  801d76:	85 c0                	test   %eax,%eax
  801d78:	79 c0                	jns    801d3a <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801d7a:	50                   	push   %eax
  801d7b:	68 b8 25 80 00       	push   $0x8025b8
  801d80:	6a 28                	push   $0x28
  801d82:	68 cc 25 80 00       	push   $0x8025cc
  801d87:	e8 58 ff ff ff       	call   801ce4 <_panic>
            		panic("pgfault_handler: %e", r);
  801d8c:	50                   	push   %eax
  801d8d:	68 b8 25 80 00       	push   $0x8025b8
  801d92:	6a 24                	push   $0x24
  801d94:	68 cc 25 80 00       	push   $0x8025cc
  801d99:	e8 46 ff ff ff       	call   801ce4 <_panic>

00801d9e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801d9e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801d9f:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801da4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801da6:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  801da9:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801dad:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801db0:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801db4:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  801db8:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801dbb:	83 c4 08             	add    $0x8,%esp
	popal
  801dbe:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801dbf:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801dc2:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801dc3:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801dc4:	c3                   	ret    

00801dc5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801dcb:	89 d0                	mov    %edx,%eax
  801dcd:	c1 e8 16             	shr    $0x16,%eax
  801dd0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ddc:	f6 c1 01             	test   $0x1,%cl
  801ddf:	74 1d                	je     801dfe <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801de1:	c1 ea 0c             	shr    $0xc,%edx
  801de4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801deb:	f6 c2 01             	test   $0x1,%dl
  801dee:	74 0e                	je     801dfe <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801df0:	c1 ea 0c             	shr    $0xc,%edx
  801df3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801dfa:	ef 
  801dfb:	0f b7 c0             	movzwl %ax,%eax
}
  801dfe:	5d                   	pop    %ebp
  801dff:	c3                   	ret    

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
