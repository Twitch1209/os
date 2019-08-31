
obj/user/testbss.debug：     文件格式 elf32-i386


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
  80002c:	e8 ab 00 00 00       	call   8000dc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	68 a0 1d 80 00       	push   $0x801da0
  80003e:	e8 d4 01 00 00       	call   800217 <cprintf>
  800043:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004b:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  800052:	00 
  800053:	75 63                	jne    8000b8 <umain+0x85>
	for (i = 0; i < ARRAYSIZE; i++)
  800055:	83 c0 01             	add    $0x1,%eax
  800058:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80005d:	75 ec                	jne    80004b <umain+0x18>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80005f:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800064:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006b:	83 c0 01             	add    $0x1,%eax
  80006e:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800073:	75 ef                	jne    800064 <umain+0x31>
	for (i = 0; i < ARRAYSIZE; i++)
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007a:	39 04 85 20 40 80 00 	cmp    %eax,0x804020(,%eax,4)
  800081:	75 47                	jne    8000ca <umain+0x97>
	for (i = 0; i < ARRAYSIZE; i++)
  800083:	83 c0 01             	add    $0x1,%eax
  800086:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008b:	75 ed                	jne    80007a <umain+0x47>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 e8 1d 80 00       	push   $0x801de8
  800095:	e8 7d 01 00 00       	call   800217 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 47 1e 80 00       	push   $0x801e47
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 38 1e 80 00       	push   $0x801e38
  8000b3:	e8 84 00 00 00       	call   80013c <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 1b 1e 80 00       	push   $0x801e1b
  8000be:	6a 11                	push   $0x11
  8000c0:	68 38 1e 80 00       	push   $0x801e38
  8000c5:	e8 72 00 00 00       	call   80013c <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 c0 1d 80 00       	push   $0x801dc0
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 38 1e 80 00       	push   $0x801e38
  8000d7:	e8 60 00 00 00       	call   80013c <_panic>

008000dc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000e4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000e7:	e8 d0 0a 00 00       	call   800bbc <sys_getenvid>
  8000ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f9:	a3 20 40 c0 00       	mov    %eax,0xc04020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fe:	85 db                	test   %ebx,%ebx
  800100:	7e 07                	jle    800109 <libmain+0x2d>
		binaryname = argv[0];
  800102:	8b 06                	mov    (%esi),%eax
  800104:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800109:	83 ec 08             	sub    $0x8,%esp
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
  80010e:	e8 20 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800113:	e8 0a 00 00 00       	call   800122 <exit>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    

00800122 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800128:	e8 94 0e 00 00       	call   800fc1 <close_all>
	sys_env_destroy(0);
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	6a 00                	push   $0x0
  800132:	e8 44 0a 00 00       	call   800b7b <sys_env_destroy>
}
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	c9                   	leave  
  80013b:	c3                   	ret    

0080013c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800141:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800144:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80014a:	e8 6d 0a 00 00       	call   800bbc <sys_getenvid>
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	ff 75 0c             	pushl  0xc(%ebp)
  800155:	ff 75 08             	pushl  0x8(%ebp)
  800158:	56                   	push   %esi
  800159:	50                   	push   %eax
  80015a:	68 68 1e 80 00       	push   $0x801e68
  80015f:	e8 b3 00 00 00       	call   800217 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800164:	83 c4 18             	add    $0x18,%esp
  800167:	53                   	push   %ebx
  800168:	ff 75 10             	pushl  0x10(%ebp)
  80016b:	e8 56 00 00 00       	call   8001c6 <vcprintf>
	cprintf("\n");
  800170:	c7 04 24 36 1e 80 00 	movl   $0x801e36,(%esp)
  800177:	e8 9b 00 00 00       	call   800217 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80017f:	cc                   	int3   
  800180:	eb fd                	jmp    80017f <_panic+0x43>

00800182 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	53                   	push   %ebx
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80018c:	8b 13                	mov    (%ebx),%edx
  80018e:	8d 42 01             	lea    0x1(%edx),%eax
  800191:	89 03                	mov    %eax,(%ebx)
  800193:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800196:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80019a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80019f:	74 09                	je     8001aa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	68 ff 00 00 00       	push   $0xff
  8001b2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b5:	50                   	push   %eax
  8001b6:	e8 83 09 00 00       	call   800b3e <sys_cputs>
		b->idx = 0;
  8001bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	eb db                	jmp    8001a1 <putch+0x1f>

008001c6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d6:	00 00 00 
	b.cnt = 0;
  8001d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e3:	ff 75 0c             	pushl  0xc(%ebp)
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	68 82 01 80 00       	push   $0x800182
  8001f5:	e8 1a 01 00 00       	call   800314 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001fa:	83 c4 08             	add    $0x8,%esp
  8001fd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800203:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800209:	50                   	push   %eax
  80020a:	e8 2f 09 00 00       	call   800b3e <sys_cputs>

	return b.cnt;
}
  80020f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800215:	c9                   	leave  
  800216:	c3                   	ret    

00800217 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80021d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800220:	50                   	push   %eax
  800221:	ff 75 08             	pushl  0x8(%ebp)
  800224:	e8 9d ff ff ff       	call   8001c6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	57                   	push   %edi
  80022f:	56                   	push   %esi
  800230:	53                   	push   %ebx
  800231:	83 ec 1c             	sub    $0x1c,%esp
  800234:	89 c7                	mov    %eax,%edi
  800236:	89 d6                	mov    %edx,%esi
  800238:	8b 45 08             	mov    0x8(%ebp),%eax
  80023b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800241:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800244:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800247:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80024f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800252:	39 d3                	cmp    %edx,%ebx
  800254:	72 05                	jb     80025b <printnum+0x30>
  800256:	39 45 10             	cmp    %eax,0x10(%ebp)
  800259:	77 7a                	ja     8002d5 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	ff 75 18             	pushl  0x18(%ebp)
  800261:	8b 45 14             	mov    0x14(%ebp),%eax
  800264:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800267:	53                   	push   %ebx
  800268:	ff 75 10             	pushl  0x10(%ebp)
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800271:	ff 75 e0             	pushl  -0x20(%ebp)
  800274:	ff 75 dc             	pushl  -0x24(%ebp)
  800277:	ff 75 d8             	pushl  -0x28(%ebp)
  80027a:	e8 d1 18 00 00       	call   801b50 <__udivdi3>
  80027f:	83 c4 18             	add    $0x18,%esp
  800282:	52                   	push   %edx
  800283:	50                   	push   %eax
  800284:	89 f2                	mov    %esi,%edx
  800286:	89 f8                	mov    %edi,%eax
  800288:	e8 9e ff ff ff       	call   80022b <printnum>
  80028d:	83 c4 20             	add    $0x20,%esp
  800290:	eb 13                	jmp    8002a5 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	56                   	push   %esi
  800296:	ff 75 18             	pushl  0x18(%ebp)
  800299:	ff d7                	call   *%edi
  80029b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80029e:	83 eb 01             	sub    $0x1,%ebx
  8002a1:	85 db                	test   %ebx,%ebx
  8002a3:	7f ed                	jg     800292 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	56                   	push   %esi
  8002a9:	83 ec 04             	sub    $0x4,%esp
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b8:	e8 b3 19 00 00       	call   801c70 <__umoddi3>
  8002bd:	83 c4 14             	add    $0x14,%esp
  8002c0:	0f be 80 8b 1e 80 00 	movsbl 0x801e8b(%eax),%eax
  8002c7:	50                   	push   %eax
  8002c8:	ff d7                	call   *%edi
}
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d0:	5b                   	pop    %ebx
  8002d1:	5e                   	pop    %esi
  8002d2:	5f                   	pop    %edi
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    
  8002d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002d8:	eb c4                	jmp    80029e <printnum+0x73>

008002da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e4:	8b 10                	mov    (%eax),%edx
  8002e6:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e9:	73 0a                	jae    8002f5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ee:	89 08                	mov    %ecx,(%eax)
  8002f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f3:	88 02                	mov    %al,(%edx)
}
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <printfmt>:
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002fd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800300:	50                   	push   %eax
  800301:	ff 75 10             	pushl  0x10(%ebp)
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	e8 05 00 00 00       	call   800314 <vprintfmt>
}
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	c9                   	leave  
  800313:	c3                   	ret    

00800314 <vprintfmt>:
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	57                   	push   %edi
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 2c             	sub    $0x2c,%esp
  80031d:	8b 75 08             	mov    0x8(%ebp),%esi
  800320:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800323:	8b 7d 10             	mov    0x10(%ebp),%edi
  800326:	e9 8c 03 00 00       	jmp    8006b7 <vprintfmt+0x3a3>
		padc = ' ';
  80032b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80032f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800336:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80033d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800344:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8d 47 01             	lea    0x1(%edi),%eax
  80034c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034f:	0f b6 17             	movzbl (%edi),%edx
  800352:	8d 42 dd             	lea    -0x23(%edx),%eax
  800355:	3c 55                	cmp    $0x55,%al
  800357:	0f 87 dd 03 00 00    	ja     80073a <vprintfmt+0x426>
  80035d:	0f b6 c0             	movzbl %al,%eax
  800360:	ff 24 85 c0 1f 80 00 	jmp    *0x801fc0(,%eax,4)
  800367:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80036e:	eb d9                	jmp    800349 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800373:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800377:	eb d0                	jmp    800349 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800379:	0f b6 d2             	movzbl %dl,%edx
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037f:	b8 00 00 00 00       	mov    $0x0,%eax
  800384:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800387:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800391:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800394:	83 f9 09             	cmp    $0x9,%ecx
  800397:	77 55                	ja     8003ee <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800399:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039c:	eb e9                	jmp    800387 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	8d 40 04             	lea    0x4(%eax),%eax
  8003ac:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b6:	79 91                	jns    800349 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003be:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003c5:	eb 82                	jmp    800349 <vprintfmt+0x35>
  8003c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d1:	0f 49 d0             	cmovns %eax,%edx
  8003d4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003da:	e9 6a ff ff ff       	jmp    800349 <vprintfmt+0x35>
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e2:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003e9:	e9 5b ff ff ff       	jmp    800349 <vprintfmt+0x35>
  8003ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003f4:	eb bc                	jmp    8003b2 <vprintfmt+0x9e>
			lflag++;
  8003f6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fc:	e9 48 ff ff ff       	jmp    800349 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 78 04             	lea    0x4(%eax),%edi
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	53                   	push   %ebx
  80040b:	ff 30                	pushl  (%eax)
  80040d:	ff d6                	call   *%esi
			break;
  80040f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800412:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800415:	e9 9a 02 00 00       	jmp    8006b4 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8d 78 04             	lea    0x4(%eax),%edi
  800420:	8b 00                	mov    (%eax),%eax
  800422:	99                   	cltd   
  800423:	31 d0                	xor    %edx,%eax
  800425:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800427:	83 f8 0f             	cmp    $0xf,%eax
  80042a:	7f 23                	jg     80044f <vprintfmt+0x13b>
  80042c:	8b 14 85 20 21 80 00 	mov    0x802120(,%eax,4),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 18                	je     80044f <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800437:	52                   	push   %edx
  800438:	68 55 22 80 00       	push   $0x802255
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 b3 fe ff ff       	call   8002f7 <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044a:	e9 65 02 00 00       	jmp    8006b4 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  80044f:	50                   	push   %eax
  800450:	68 a3 1e 80 00       	push   $0x801ea3
  800455:	53                   	push   %ebx
  800456:	56                   	push   %esi
  800457:	e8 9b fe ff ff       	call   8002f7 <printfmt>
  80045c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800462:	e9 4d 02 00 00       	jmp    8006b4 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	83 c0 04             	add    $0x4,%eax
  80046d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800475:	85 ff                	test   %edi,%edi
  800477:	b8 9c 1e 80 00       	mov    $0x801e9c,%eax
  80047c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80047f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800483:	0f 8e bd 00 00 00    	jle    800546 <vprintfmt+0x232>
  800489:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80048d:	75 0e                	jne    80049d <vprintfmt+0x189>
  80048f:	89 75 08             	mov    %esi,0x8(%ebp)
  800492:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800495:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800498:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80049b:	eb 6d                	jmp    80050a <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	ff 75 d0             	pushl  -0x30(%ebp)
  8004a3:	57                   	push   %edi
  8004a4:	e8 39 03 00 00       	call   8007e2 <strnlen>
  8004a9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ac:	29 c1                	sub    %eax,%ecx
  8004ae:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004b1:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004b4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bb:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004be:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c0:	eb 0f                	jmp    8004d1 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	53                   	push   %ebx
  8004c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cb:	83 ef 01             	sub    $0x1,%edi
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	85 ff                	test   %edi,%edi
  8004d3:	7f ed                	jg     8004c2 <vprintfmt+0x1ae>
  8004d5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004d8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004db:	85 c9                	test   %ecx,%ecx
  8004dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e2:	0f 49 c1             	cmovns %ecx,%eax
  8004e5:	29 c1                	sub    %eax,%ecx
  8004e7:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ea:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ed:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004f0:	89 cb                	mov    %ecx,%ebx
  8004f2:	eb 16                	jmp    80050a <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f8:	75 31                	jne    80052b <vprintfmt+0x217>
					putch(ch, putdat);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	ff 75 0c             	pushl  0xc(%ebp)
  800500:	50                   	push   %eax
  800501:	ff 55 08             	call   *0x8(%ebp)
  800504:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800507:	83 eb 01             	sub    $0x1,%ebx
  80050a:	83 c7 01             	add    $0x1,%edi
  80050d:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800511:	0f be c2             	movsbl %dl,%eax
  800514:	85 c0                	test   %eax,%eax
  800516:	74 59                	je     800571 <vprintfmt+0x25d>
  800518:	85 f6                	test   %esi,%esi
  80051a:	78 d8                	js     8004f4 <vprintfmt+0x1e0>
  80051c:	83 ee 01             	sub    $0x1,%esi
  80051f:	79 d3                	jns    8004f4 <vprintfmt+0x1e0>
  800521:	89 df                	mov    %ebx,%edi
  800523:	8b 75 08             	mov    0x8(%ebp),%esi
  800526:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800529:	eb 37                	jmp    800562 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80052b:	0f be d2             	movsbl %dl,%edx
  80052e:	83 ea 20             	sub    $0x20,%edx
  800531:	83 fa 5e             	cmp    $0x5e,%edx
  800534:	76 c4                	jbe    8004fa <vprintfmt+0x1e6>
					putch('?', putdat);
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	ff 75 0c             	pushl  0xc(%ebp)
  80053c:	6a 3f                	push   $0x3f
  80053e:	ff 55 08             	call   *0x8(%ebp)
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	eb c1                	jmp    800507 <vprintfmt+0x1f3>
  800546:	89 75 08             	mov    %esi,0x8(%ebp)
  800549:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80054c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80054f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800552:	eb b6                	jmp    80050a <vprintfmt+0x1f6>
				putch(' ', putdat);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	53                   	push   %ebx
  800558:	6a 20                	push   $0x20
  80055a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80055c:	83 ef 01             	sub    $0x1,%edi
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	85 ff                	test   %edi,%edi
  800564:	7f ee                	jg     800554 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800566:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800569:	89 45 14             	mov    %eax,0x14(%ebp)
  80056c:	e9 43 01 00 00       	jmp    8006b4 <vprintfmt+0x3a0>
  800571:	89 df                	mov    %ebx,%edi
  800573:	8b 75 08             	mov    0x8(%ebp),%esi
  800576:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800579:	eb e7                	jmp    800562 <vprintfmt+0x24e>
	if (lflag >= 2)
  80057b:	83 f9 01             	cmp    $0x1,%ecx
  80057e:	7e 3f                	jle    8005bf <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 50 04             	mov    0x4(%eax),%edx
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	8d 40 08             	lea    0x8(%eax),%eax
  800594:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800597:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80059b:	79 5c                	jns    8005f9 <vprintfmt+0x2e5>
				putch('-', putdat);
  80059d:	83 ec 08             	sub    $0x8,%esp
  8005a0:	53                   	push   %ebx
  8005a1:	6a 2d                	push   $0x2d
  8005a3:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005ab:	f7 da                	neg    %edx
  8005ad:	83 d1 00             	adc    $0x0,%ecx
  8005b0:	f7 d9                	neg    %ecx
  8005b2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ba:	e9 db 00 00 00       	jmp    80069a <vprintfmt+0x386>
	else if (lflag)
  8005bf:	85 c9                	test   %ecx,%ecx
  8005c1:	75 1b                	jne    8005de <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8b 00                	mov    (%eax),%eax
  8005c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cb:	89 c1                	mov    %eax,%ecx
  8005cd:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8d 40 04             	lea    0x4(%eax),%eax
  8005d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005dc:	eb b9                	jmp    800597 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e6:	89 c1                	mov    %eax,%ecx
  8005e8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005eb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8d 40 04             	lea    0x4(%eax),%eax
  8005f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f7:	eb 9e                	jmp    800597 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005fc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800604:	e9 91 00 00 00       	jmp    80069a <vprintfmt+0x386>
	if (lflag >= 2)
  800609:	83 f9 01             	cmp    $0x1,%ecx
  80060c:	7e 15                	jle    800623 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 10                	mov    (%eax),%edx
  800613:	8b 48 04             	mov    0x4(%eax),%ecx
  800616:	8d 40 08             	lea    0x8(%eax),%eax
  800619:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800621:	eb 77                	jmp    80069a <vprintfmt+0x386>
	else if (lflag)
  800623:	85 c9                	test   %ecx,%ecx
  800625:	75 17                	jne    80063e <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8b 10                	mov    (%eax),%edx
  80062c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800631:	8d 40 04             	lea    0x4(%eax),%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800637:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063c:	eb 5c                	jmp    80069a <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8b 10                	mov    (%eax),%edx
  800643:	b9 00 00 00 00       	mov    $0x0,%ecx
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800653:	eb 45                	jmp    80069a <vprintfmt+0x386>
			putch('X', putdat);
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	53                   	push   %ebx
  800659:	6a 58                	push   $0x58
  80065b:	ff d6                	call   *%esi
			putch('X', putdat);
  80065d:	83 c4 08             	add    $0x8,%esp
  800660:	53                   	push   %ebx
  800661:	6a 58                	push   $0x58
  800663:	ff d6                	call   *%esi
			putch('X', putdat);
  800665:	83 c4 08             	add    $0x8,%esp
  800668:	53                   	push   %ebx
  800669:	6a 58                	push   $0x58
  80066b:	ff d6                	call   *%esi
			break;
  80066d:	83 c4 10             	add    $0x10,%esp
  800670:	eb 42                	jmp    8006b4 <vprintfmt+0x3a0>
			putch('0', putdat);
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	53                   	push   %ebx
  800676:	6a 30                	push   $0x30
  800678:	ff d6                	call   *%esi
			putch('x', putdat);
  80067a:	83 c4 08             	add    $0x8,%esp
  80067d:	53                   	push   %ebx
  80067e:	6a 78                	push   $0x78
  800680:	ff d6                	call   *%esi
			num = (unsigned long long)
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8b 10                	mov    (%eax),%edx
  800687:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80068c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80068f:	8d 40 04             	lea    0x4(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800695:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80069a:	83 ec 0c             	sub    $0xc,%esp
  80069d:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006a1:	57                   	push   %edi
  8006a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a5:	50                   	push   %eax
  8006a6:	51                   	push   %ecx
  8006a7:	52                   	push   %edx
  8006a8:	89 da                	mov    %ebx,%edx
  8006aa:	89 f0                	mov    %esi,%eax
  8006ac:	e8 7a fb ff ff       	call   80022b <printnum>
			break;
  8006b1:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b7:	83 c7 01             	add    $0x1,%edi
  8006ba:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006be:	83 f8 25             	cmp    $0x25,%eax
  8006c1:	0f 84 64 fc ff ff    	je     80032b <vprintfmt+0x17>
			if (ch == '\0')
  8006c7:	85 c0                	test   %eax,%eax
  8006c9:	0f 84 8b 00 00 00    	je     80075a <vprintfmt+0x446>
			putch(ch, putdat);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	53                   	push   %ebx
  8006d3:	50                   	push   %eax
  8006d4:	ff d6                	call   *%esi
  8006d6:	83 c4 10             	add    $0x10,%esp
  8006d9:	eb dc                	jmp    8006b7 <vprintfmt+0x3a3>
	if (lflag >= 2)
  8006db:	83 f9 01             	cmp    $0x1,%ecx
  8006de:	7e 15                	jle    8006f5 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8b 10                	mov    (%eax),%edx
  8006e5:	8b 48 04             	mov    0x4(%eax),%ecx
  8006e8:	8d 40 08             	lea    0x8(%eax),%eax
  8006eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ee:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f3:	eb a5                	jmp    80069a <vprintfmt+0x386>
	else if (lflag)
  8006f5:	85 c9                	test   %ecx,%ecx
  8006f7:	75 17                	jne    800710 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8b 10                	mov    (%eax),%edx
  8006fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800703:	8d 40 04             	lea    0x4(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800709:	b8 10 00 00 00       	mov    $0x10,%eax
  80070e:	eb 8a                	jmp    80069a <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8b 10                	mov    (%eax),%edx
  800715:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071a:	8d 40 04             	lea    0x4(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800720:	b8 10 00 00 00       	mov    $0x10,%eax
  800725:	e9 70 ff ff ff       	jmp    80069a <vprintfmt+0x386>
			putch(ch, putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	53                   	push   %ebx
  80072e:	6a 25                	push   $0x25
  800730:	ff d6                	call   *%esi
			break;
  800732:	83 c4 10             	add    $0x10,%esp
  800735:	e9 7a ff ff ff       	jmp    8006b4 <vprintfmt+0x3a0>
			putch('%', putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	53                   	push   %ebx
  80073e:	6a 25                	push   $0x25
  800740:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800742:	83 c4 10             	add    $0x10,%esp
  800745:	89 f8                	mov    %edi,%eax
  800747:	eb 03                	jmp    80074c <vprintfmt+0x438>
  800749:	83 e8 01             	sub    $0x1,%eax
  80074c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800750:	75 f7                	jne    800749 <vprintfmt+0x435>
  800752:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800755:	e9 5a ff ff ff       	jmp    8006b4 <vprintfmt+0x3a0>
}
  80075a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075d:	5b                   	pop    %ebx
  80075e:	5e                   	pop    %esi
  80075f:	5f                   	pop    %edi
  800760:	5d                   	pop    %ebp
  800761:	c3                   	ret    

00800762 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
  800765:	83 ec 18             	sub    $0x18,%esp
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80076e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800771:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800775:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800778:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80077f:	85 c0                	test   %eax,%eax
  800781:	74 26                	je     8007a9 <vsnprintf+0x47>
  800783:	85 d2                	test   %edx,%edx
  800785:	7e 22                	jle    8007a9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800787:	ff 75 14             	pushl  0x14(%ebp)
  80078a:	ff 75 10             	pushl  0x10(%ebp)
  80078d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800790:	50                   	push   %eax
  800791:	68 da 02 80 00       	push   $0x8002da
  800796:	e8 79 fb ff ff       	call   800314 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80079b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80079e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a4:	83 c4 10             	add    $0x10,%esp
}
  8007a7:	c9                   	leave  
  8007a8:	c3                   	ret    
		return -E_INVAL;
  8007a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ae:	eb f7                	jmp    8007a7 <vsnprintf+0x45>

008007b0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007b6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007b9:	50                   	push   %eax
  8007ba:	ff 75 10             	pushl  0x10(%ebp)
  8007bd:	ff 75 0c             	pushl  0xc(%ebp)
  8007c0:	ff 75 08             	pushl  0x8(%ebp)
  8007c3:	e8 9a ff ff ff       	call   800762 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007c8:	c9                   	leave  
  8007c9:	c3                   	ret    

008007ca <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d5:	eb 03                	jmp    8007da <strlen+0x10>
		n++;
  8007d7:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007da:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007de:	75 f7                	jne    8007d7 <strlen+0xd>
	return n;
}
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e8:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f0:	eb 03                	jmp    8007f5 <strnlen+0x13>
		n++;
  8007f2:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f5:	39 d0                	cmp    %edx,%eax
  8007f7:	74 06                	je     8007ff <strnlen+0x1d>
  8007f9:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007fd:	75 f3                	jne    8007f2 <strnlen+0x10>
	return n;
}
  8007ff:	5d                   	pop    %ebp
  800800:	c3                   	ret    

00800801 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	53                   	push   %ebx
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80080b:	89 c2                	mov    %eax,%edx
  80080d:	83 c1 01             	add    $0x1,%ecx
  800810:	83 c2 01             	add    $0x1,%edx
  800813:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800817:	88 5a ff             	mov    %bl,-0x1(%edx)
  80081a:	84 db                	test   %bl,%bl
  80081c:	75 ef                	jne    80080d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80081e:	5b                   	pop    %ebx
  80081f:	5d                   	pop    %ebp
  800820:	c3                   	ret    

00800821 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	53                   	push   %ebx
  800825:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800828:	53                   	push   %ebx
  800829:	e8 9c ff ff ff       	call   8007ca <strlen>
  80082e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800831:	ff 75 0c             	pushl  0xc(%ebp)
  800834:	01 d8                	add    %ebx,%eax
  800836:	50                   	push   %eax
  800837:	e8 c5 ff ff ff       	call   800801 <strcpy>
	return dst;
}
  80083c:	89 d8                	mov    %ebx,%eax
  80083e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800841:	c9                   	leave  
  800842:	c3                   	ret    

00800843 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
  800846:	56                   	push   %esi
  800847:	53                   	push   %ebx
  800848:	8b 75 08             	mov    0x8(%ebp),%esi
  80084b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084e:	89 f3                	mov    %esi,%ebx
  800850:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800853:	89 f2                	mov    %esi,%edx
  800855:	eb 0f                	jmp    800866 <strncpy+0x23>
		*dst++ = *src;
  800857:	83 c2 01             	add    $0x1,%edx
  80085a:	0f b6 01             	movzbl (%ecx),%eax
  80085d:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800860:	80 39 01             	cmpb   $0x1,(%ecx)
  800863:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800866:	39 da                	cmp    %ebx,%edx
  800868:	75 ed                	jne    800857 <strncpy+0x14>
	}
	return ret;
}
  80086a:	89 f0                	mov    %esi,%eax
  80086c:	5b                   	pop    %ebx
  80086d:	5e                   	pop    %esi
  80086e:	5d                   	pop    %ebp
  80086f:	c3                   	ret    

00800870 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	56                   	push   %esi
  800874:	53                   	push   %ebx
  800875:	8b 75 08             	mov    0x8(%ebp),%esi
  800878:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80087e:	89 f0                	mov    %esi,%eax
  800880:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800884:	85 c9                	test   %ecx,%ecx
  800886:	75 0b                	jne    800893 <strlcpy+0x23>
  800888:	eb 17                	jmp    8008a1 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80088a:	83 c2 01             	add    $0x1,%edx
  80088d:	83 c0 01             	add    $0x1,%eax
  800890:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800893:	39 d8                	cmp    %ebx,%eax
  800895:	74 07                	je     80089e <strlcpy+0x2e>
  800897:	0f b6 0a             	movzbl (%edx),%ecx
  80089a:	84 c9                	test   %cl,%cl
  80089c:	75 ec                	jne    80088a <strlcpy+0x1a>
		*dst = '\0';
  80089e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008a1:	29 f0                	sub    %esi,%eax
}
  8008a3:	5b                   	pop    %ebx
  8008a4:	5e                   	pop    %esi
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008b0:	eb 06                	jmp    8008b8 <strcmp+0x11>
		p++, q++;
  8008b2:	83 c1 01             	add    $0x1,%ecx
  8008b5:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008b8:	0f b6 01             	movzbl (%ecx),%eax
  8008bb:	84 c0                	test   %al,%al
  8008bd:	74 04                	je     8008c3 <strcmp+0x1c>
  8008bf:	3a 02                	cmp    (%edx),%al
  8008c1:	74 ef                	je     8008b2 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c3:	0f b6 c0             	movzbl %al,%eax
  8008c6:	0f b6 12             	movzbl (%edx),%edx
  8008c9:	29 d0                	sub    %edx,%eax
}
  8008cb:	5d                   	pop    %ebp
  8008cc:	c3                   	ret    

008008cd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	53                   	push   %ebx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d7:	89 c3                	mov    %eax,%ebx
  8008d9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008dc:	eb 06                	jmp    8008e4 <strncmp+0x17>
		n--, p++, q++;
  8008de:	83 c0 01             	add    $0x1,%eax
  8008e1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008e4:	39 d8                	cmp    %ebx,%eax
  8008e6:	74 16                	je     8008fe <strncmp+0x31>
  8008e8:	0f b6 08             	movzbl (%eax),%ecx
  8008eb:	84 c9                	test   %cl,%cl
  8008ed:	74 04                	je     8008f3 <strncmp+0x26>
  8008ef:	3a 0a                	cmp    (%edx),%cl
  8008f1:	74 eb                	je     8008de <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f3:	0f b6 00             	movzbl (%eax),%eax
  8008f6:	0f b6 12             	movzbl (%edx),%edx
  8008f9:	29 d0                	sub    %edx,%eax
}
  8008fb:	5b                   	pop    %ebx
  8008fc:	5d                   	pop    %ebp
  8008fd:	c3                   	ret    
		return 0;
  8008fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800903:	eb f6                	jmp    8008fb <strncmp+0x2e>

00800905 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80090f:	0f b6 10             	movzbl (%eax),%edx
  800912:	84 d2                	test   %dl,%dl
  800914:	74 09                	je     80091f <strchr+0x1a>
		if (*s == c)
  800916:	38 ca                	cmp    %cl,%dl
  800918:	74 0a                	je     800924 <strchr+0x1f>
	for (; *s; s++)
  80091a:	83 c0 01             	add    $0x1,%eax
  80091d:	eb f0                	jmp    80090f <strchr+0xa>
			return (char *) s;
	return 0;
  80091f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800930:	eb 03                	jmp    800935 <strfind+0xf>
  800932:	83 c0 01             	add    $0x1,%eax
  800935:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800938:	38 ca                	cmp    %cl,%dl
  80093a:	74 04                	je     800940 <strfind+0x1a>
  80093c:	84 d2                	test   %dl,%dl
  80093e:	75 f2                	jne    800932 <strfind+0xc>
			break;
	return (char *) s;
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	57                   	push   %edi
  800946:	56                   	push   %esi
  800947:	53                   	push   %ebx
  800948:	8b 7d 08             	mov    0x8(%ebp),%edi
  80094b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80094e:	85 c9                	test   %ecx,%ecx
  800950:	74 13                	je     800965 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800952:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800958:	75 05                	jne    80095f <memset+0x1d>
  80095a:	f6 c1 03             	test   $0x3,%cl
  80095d:	74 0d                	je     80096c <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80095f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800962:	fc                   	cld    
  800963:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800965:	89 f8                	mov    %edi,%eax
  800967:	5b                   	pop    %ebx
  800968:	5e                   	pop    %esi
  800969:	5f                   	pop    %edi
  80096a:	5d                   	pop    %ebp
  80096b:	c3                   	ret    
		c &= 0xFF;
  80096c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800970:	89 d3                	mov    %edx,%ebx
  800972:	c1 e3 08             	shl    $0x8,%ebx
  800975:	89 d0                	mov    %edx,%eax
  800977:	c1 e0 18             	shl    $0x18,%eax
  80097a:	89 d6                	mov    %edx,%esi
  80097c:	c1 e6 10             	shl    $0x10,%esi
  80097f:	09 f0                	or     %esi,%eax
  800981:	09 c2                	or     %eax,%edx
  800983:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800985:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800988:	89 d0                	mov    %edx,%eax
  80098a:	fc                   	cld    
  80098b:	f3 ab                	rep stos %eax,%es:(%edi)
  80098d:	eb d6                	jmp    800965 <memset+0x23>

0080098f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	57                   	push   %edi
  800993:	56                   	push   %esi
  800994:	8b 45 08             	mov    0x8(%ebp),%eax
  800997:	8b 75 0c             	mov    0xc(%ebp),%esi
  80099a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80099d:	39 c6                	cmp    %eax,%esi
  80099f:	73 35                	jae    8009d6 <memmove+0x47>
  8009a1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009a4:	39 c2                	cmp    %eax,%edx
  8009a6:	76 2e                	jbe    8009d6 <memmove+0x47>
		s += n;
		d += n;
  8009a8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ab:	89 d6                	mov    %edx,%esi
  8009ad:	09 fe                	or     %edi,%esi
  8009af:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009b5:	74 0c                	je     8009c3 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009b7:	83 ef 01             	sub    $0x1,%edi
  8009ba:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009bd:	fd                   	std    
  8009be:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009c0:	fc                   	cld    
  8009c1:	eb 21                	jmp    8009e4 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c3:	f6 c1 03             	test   $0x3,%cl
  8009c6:	75 ef                	jne    8009b7 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009c8:	83 ef 04             	sub    $0x4,%edi
  8009cb:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009ce:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009d1:	fd                   	std    
  8009d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d4:	eb ea                	jmp    8009c0 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d6:	89 f2                	mov    %esi,%edx
  8009d8:	09 c2                	or     %eax,%edx
  8009da:	f6 c2 03             	test   $0x3,%dl
  8009dd:	74 09                	je     8009e8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009df:	89 c7                	mov    %eax,%edi
  8009e1:	fc                   	cld    
  8009e2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009e4:	5e                   	pop    %esi
  8009e5:	5f                   	pop    %edi
  8009e6:	5d                   	pop    %ebp
  8009e7:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e8:	f6 c1 03             	test   $0x3,%cl
  8009eb:	75 f2                	jne    8009df <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009ed:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009f0:	89 c7                	mov    %eax,%edi
  8009f2:	fc                   	cld    
  8009f3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f5:	eb ed                	jmp    8009e4 <memmove+0x55>

008009f7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009fa:	ff 75 10             	pushl  0x10(%ebp)
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	ff 75 08             	pushl  0x8(%ebp)
  800a03:	e8 87 ff ff ff       	call   80098f <memmove>
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	56                   	push   %esi
  800a0e:	53                   	push   %ebx
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a15:	89 c6                	mov    %eax,%esi
  800a17:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a1a:	39 f0                	cmp    %esi,%eax
  800a1c:	74 1c                	je     800a3a <memcmp+0x30>
		if (*s1 != *s2)
  800a1e:	0f b6 08             	movzbl (%eax),%ecx
  800a21:	0f b6 1a             	movzbl (%edx),%ebx
  800a24:	38 d9                	cmp    %bl,%cl
  800a26:	75 08                	jne    800a30 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a28:	83 c0 01             	add    $0x1,%eax
  800a2b:	83 c2 01             	add    $0x1,%edx
  800a2e:	eb ea                	jmp    800a1a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a30:	0f b6 c1             	movzbl %cl,%eax
  800a33:	0f b6 db             	movzbl %bl,%ebx
  800a36:	29 d8                	sub    %ebx,%eax
  800a38:	eb 05                	jmp    800a3f <memcmp+0x35>
	}

	return 0;
  800a3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a3f:	5b                   	pop    %ebx
  800a40:	5e                   	pop    %esi
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a4c:	89 c2                	mov    %eax,%edx
  800a4e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a51:	39 d0                	cmp    %edx,%eax
  800a53:	73 09                	jae    800a5e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a55:	38 08                	cmp    %cl,(%eax)
  800a57:	74 05                	je     800a5e <memfind+0x1b>
	for (; s < ends; s++)
  800a59:	83 c0 01             	add    $0x1,%eax
  800a5c:	eb f3                	jmp    800a51 <memfind+0xe>
			break;
	return (void *) s;
}
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	57                   	push   %edi
  800a64:	56                   	push   %esi
  800a65:	53                   	push   %ebx
  800a66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a6c:	eb 03                	jmp    800a71 <strtol+0x11>
		s++;
  800a6e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a71:	0f b6 01             	movzbl (%ecx),%eax
  800a74:	3c 20                	cmp    $0x20,%al
  800a76:	74 f6                	je     800a6e <strtol+0xe>
  800a78:	3c 09                	cmp    $0x9,%al
  800a7a:	74 f2                	je     800a6e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a7c:	3c 2b                	cmp    $0x2b,%al
  800a7e:	74 2e                	je     800aae <strtol+0x4e>
	int neg = 0;
  800a80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a85:	3c 2d                	cmp    $0x2d,%al
  800a87:	74 2f                	je     800ab8 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a89:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a8f:	75 05                	jne    800a96 <strtol+0x36>
  800a91:	80 39 30             	cmpb   $0x30,(%ecx)
  800a94:	74 2c                	je     800ac2 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a96:	85 db                	test   %ebx,%ebx
  800a98:	75 0a                	jne    800aa4 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a9a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a9f:	80 39 30             	cmpb   $0x30,(%ecx)
  800aa2:	74 28                	je     800acc <strtol+0x6c>
		base = 10;
  800aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aac:	eb 50                	jmp    800afe <strtol+0x9e>
		s++;
  800aae:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ab1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab6:	eb d1                	jmp    800a89 <strtol+0x29>
		s++, neg = 1;
  800ab8:	83 c1 01             	add    $0x1,%ecx
  800abb:	bf 01 00 00 00       	mov    $0x1,%edi
  800ac0:	eb c7                	jmp    800a89 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ac6:	74 0e                	je     800ad6 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ac8:	85 db                	test   %ebx,%ebx
  800aca:	75 d8                	jne    800aa4 <strtol+0x44>
		s++, base = 8;
  800acc:	83 c1 01             	add    $0x1,%ecx
  800acf:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ad4:	eb ce                	jmp    800aa4 <strtol+0x44>
		s += 2, base = 16;
  800ad6:	83 c1 02             	add    $0x2,%ecx
  800ad9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ade:	eb c4                	jmp    800aa4 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ae0:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ae3:	89 f3                	mov    %esi,%ebx
  800ae5:	80 fb 19             	cmp    $0x19,%bl
  800ae8:	77 29                	ja     800b13 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800aea:	0f be d2             	movsbl %dl,%edx
  800aed:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800af0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800af3:	7d 30                	jge    800b25 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800af5:	83 c1 01             	add    $0x1,%ecx
  800af8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800afc:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800afe:	0f b6 11             	movzbl (%ecx),%edx
  800b01:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b04:	89 f3                	mov    %esi,%ebx
  800b06:	80 fb 09             	cmp    $0x9,%bl
  800b09:	77 d5                	ja     800ae0 <strtol+0x80>
			dig = *s - '0';
  800b0b:	0f be d2             	movsbl %dl,%edx
  800b0e:	83 ea 30             	sub    $0x30,%edx
  800b11:	eb dd                	jmp    800af0 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b13:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b16:	89 f3                	mov    %esi,%ebx
  800b18:	80 fb 19             	cmp    $0x19,%bl
  800b1b:	77 08                	ja     800b25 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b1d:	0f be d2             	movsbl %dl,%edx
  800b20:	83 ea 37             	sub    $0x37,%edx
  800b23:	eb cb                	jmp    800af0 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b29:	74 05                	je     800b30 <strtol+0xd0>
		*endptr = (char *) s;
  800b2b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b30:	89 c2                	mov    %eax,%edx
  800b32:	f7 da                	neg    %edx
  800b34:	85 ff                	test   %edi,%edi
  800b36:	0f 45 c2             	cmovne %edx,%eax
}
  800b39:	5b                   	pop    %ebx
  800b3a:	5e                   	pop    %esi
  800b3b:	5f                   	pop    %edi
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	57                   	push   %edi
  800b42:	56                   	push   %esi
  800b43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4f:	89 c3                	mov    %eax,%ebx
  800b51:	89 c7                	mov    %eax,%edi
  800b53:	89 c6                	mov    %eax,%esi
  800b55:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <sys_cgetc>:

int
sys_cgetc(void)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	57                   	push   %edi
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b62:	ba 00 00 00 00       	mov    $0x0,%edx
  800b67:	b8 01 00 00 00       	mov    $0x1,%eax
  800b6c:	89 d1                	mov    %edx,%ecx
  800b6e:	89 d3                	mov    %edx,%ebx
  800b70:	89 d7                	mov    %edx,%edi
  800b72:	89 d6                	mov    %edx,%esi
  800b74:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b76:	5b                   	pop    %ebx
  800b77:	5e                   	pop    %esi
  800b78:	5f                   	pop    %edi
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	57                   	push   %edi
  800b7f:	56                   	push   %esi
  800b80:	53                   	push   %ebx
  800b81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b84:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b89:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b91:	89 cb                	mov    %ecx,%ebx
  800b93:	89 cf                	mov    %ecx,%edi
  800b95:	89 ce                	mov    %ecx,%esi
  800b97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b99:	85 c0                	test   %eax,%eax
  800b9b:	7f 08                	jg     800ba5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800ba9:	6a 03                	push   $0x3
  800bab:	68 7f 21 80 00       	push   $0x80217f
  800bb0:	6a 23                	push   $0x23
  800bb2:	68 9c 21 80 00       	push   $0x80219c
  800bb7:	e8 80 f5 ff ff       	call   80013c <_panic>

00800bbc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	57                   	push   %edi
  800bc0:	56                   	push   %esi
  800bc1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc7:	b8 02 00 00 00       	mov    $0x2,%eax
  800bcc:	89 d1                	mov    %edx,%ecx
  800bce:	89 d3                	mov    %edx,%ebx
  800bd0:	89 d7                	mov    %edx,%edi
  800bd2:	89 d6                	mov    %edx,%esi
  800bd4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5f                   	pop    %edi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <sys_yield>:

void
sys_yield(void)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	57                   	push   %edi
  800bdf:	56                   	push   %esi
  800be0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
  800be6:	b8 0b 00 00 00       	mov    $0xb,%eax
  800beb:	89 d1                	mov    %edx,%ecx
  800bed:	89 d3                	mov    %edx,%ebx
  800bef:	89 d7                	mov    %edx,%edi
  800bf1:	89 d6                	mov    %edx,%esi
  800bf3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bf5:	5b                   	pop    %ebx
  800bf6:	5e                   	pop    %esi
  800bf7:	5f                   	pop    %edi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	57                   	push   %edi
  800bfe:	56                   	push   %esi
  800bff:	53                   	push   %ebx
  800c00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c03:	be 00 00 00 00       	mov    $0x0,%esi
  800c08:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0e:	b8 04 00 00 00       	mov    $0x4,%eax
  800c13:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c16:	89 f7                	mov    %esi,%edi
  800c18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1a:	85 c0                	test   %eax,%eax
  800c1c:	7f 08                	jg     800c26 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	50                   	push   %eax
  800c2a:	6a 04                	push   $0x4
  800c2c:	68 7f 21 80 00       	push   $0x80217f
  800c31:	6a 23                	push   $0x23
  800c33:	68 9c 21 80 00       	push   $0x80219c
  800c38:	e8 ff f4 ff ff       	call   80013c <_panic>

00800c3d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	57                   	push   %edi
  800c41:	56                   	push   %esi
  800c42:	53                   	push   %ebx
  800c43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c46:	8b 55 08             	mov    0x8(%ebp),%edx
  800c49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4c:	b8 05 00 00 00       	mov    $0x5,%eax
  800c51:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c54:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c57:	8b 75 18             	mov    0x18(%ebp),%esi
  800c5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5c:	85 c0                	test   %eax,%eax
  800c5e:	7f 08                	jg     800c68 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c63:	5b                   	pop    %ebx
  800c64:	5e                   	pop    %esi
  800c65:	5f                   	pop    %edi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c68:	83 ec 0c             	sub    $0xc,%esp
  800c6b:	50                   	push   %eax
  800c6c:	6a 05                	push   $0x5
  800c6e:	68 7f 21 80 00       	push   $0x80217f
  800c73:	6a 23                	push   $0x23
  800c75:	68 9c 21 80 00       	push   $0x80219c
  800c7a:	e8 bd f4 ff ff       	call   80013c <_panic>

00800c7f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c93:	b8 06 00 00 00       	mov    $0x6,%eax
  800c98:	89 df                	mov    %ebx,%edi
  800c9a:	89 de                	mov    %ebx,%esi
  800c9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9e:	85 c0                	test   %eax,%eax
  800ca0:	7f 08                	jg     800caa <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ca2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca5:	5b                   	pop    %ebx
  800ca6:	5e                   	pop    %esi
  800ca7:	5f                   	pop    %edi
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800caa:	83 ec 0c             	sub    $0xc,%esp
  800cad:	50                   	push   %eax
  800cae:	6a 06                	push   $0x6
  800cb0:	68 7f 21 80 00       	push   $0x80217f
  800cb5:	6a 23                	push   $0x23
  800cb7:	68 9c 21 80 00       	push   $0x80219c
  800cbc:	e8 7b f4 ff ff       	call   80013c <_panic>

00800cc1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	57                   	push   %edi
  800cc5:	56                   	push   %esi
  800cc6:	53                   	push   %ebx
  800cc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cca:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd5:	b8 08 00 00 00       	mov    $0x8,%eax
  800cda:	89 df                	mov    %ebx,%edi
  800cdc:	89 de                	mov    %ebx,%esi
  800cde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce0:	85 c0                	test   %eax,%eax
  800ce2:	7f 08                	jg     800cec <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5f                   	pop    %edi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cec:	83 ec 0c             	sub    $0xc,%esp
  800cef:	50                   	push   %eax
  800cf0:	6a 08                	push   $0x8
  800cf2:	68 7f 21 80 00       	push   $0x80217f
  800cf7:	6a 23                	push   $0x23
  800cf9:	68 9c 21 80 00       	push   $0x80219c
  800cfe:	e8 39 f4 ff ff       	call   80013c <_panic>

00800d03 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d11:	8b 55 08             	mov    0x8(%ebp),%edx
  800d14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d17:	b8 09 00 00 00       	mov    $0x9,%eax
  800d1c:	89 df                	mov    %ebx,%edi
  800d1e:	89 de                	mov    %ebx,%esi
  800d20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d22:	85 c0                	test   %eax,%eax
  800d24:	7f 08                	jg     800d2e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5f                   	pop    %edi
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2e:	83 ec 0c             	sub    $0xc,%esp
  800d31:	50                   	push   %eax
  800d32:	6a 09                	push   $0x9
  800d34:	68 7f 21 80 00       	push   $0x80217f
  800d39:	6a 23                	push   $0x23
  800d3b:	68 9c 21 80 00       	push   $0x80219c
  800d40:	e8 f7 f3 ff ff       	call   80013c <_panic>

00800d45 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	57                   	push   %edi
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
  800d4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d59:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d5e:	89 df                	mov    %ebx,%edi
  800d60:	89 de                	mov    %ebx,%esi
  800d62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d64:	85 c0                	test   %eax,%eax
  800d66:	7f 08                	jg     800d70 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5f                   	pop    %edi
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d70:	83 ec 0c             	sub    $0xc,%esp
  800d73:	50                   	push   %eax
  800d74:	6a 0a                	push   $0xa
  800d76:	68 7f 21 80 00       	push   $0x80217f
  800d7b:	6a 23                	push   $0x23
  800d7d:	68 9c 21 80 00       	push   $0x80219c
  800d82:	e8 b5 f3 ff ff       	call   80013c <_panic>

00800d87 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d93:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d98:	be 00 00 00 00       	mov    $0x0,%esi
  800d9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dc0:	89 cb                	mov    %ecx,%ebx
  800dc2:	89 cf                	mov    %ecx,%edi
  800dc4:	89 ce                	mov    %ecx,%esi
  800dc6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	7f 08                	jg     800dd4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd4:	83 ec 0c             	sub    $0xc,%esp
  800dd7:	50                   	push   %eax
  800dd8:	6a 0d                	push   $0xd
  800dda:	68 7f 21 80 00       	push   $0x80217f
  800ddf:	6a 23                	push   $0x23
  800de1:	68 9c 21 80 00       	push   $0x80219c
  800de6:	e8 51 f3 ff ff       	call   80013c <_panic>

00800deb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	05 00 00 00 30       	add    $0x30000000,%eax
  800df6:	c1 e8 0c             	shr    $0xc,%eax
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e0b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    

00800e12 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e18:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e1d:	89 c2                	mov    %eax,%edx
  800e1f:	c1 ea 16             	shr    $0x16,%edx
  800e22:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e29:	f6 c2 01             	test   $0x1,%dl
  800e2c:	74 2a                	je     800e58 <fd_alloc+0x46>
  800e2e:	89 c2                	mov    %eax,%edx
  800e30:	c1 ea 0c             	shr    $0xc,%edx
  800e33:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e3a:	f6 c2 01             	test   $0x1,%dl
  800e3d:	74 19                	je     800e58 <fd_alloc+0x46>
  800e3f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e44:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e49:	75 d2                	jne    800e1d <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e4b:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e51:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e56:	eb 07                	jmp    800e5f <fd_alloc+0x4d>
			*fd_store = fd;
  800e58:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    

00800e61 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e67:	83 f8 1f             	cmp    $0x1f,%eax
  800e6a:	77 36                	ja     800ea2 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e6c:	c1 e0 0c             	shl    $0xc,%eax
  800e6f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	c1 ea 16             	shr    $0x16,%edx
  800e79:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e80:	f6 c2 01             	test   $0x1,%dl
  800e83:	74 24                	je     800ea9 <fd_lookup+0x48>
  800e85:	89 c2                	mov    %eax,%edx
  800e87:	c1 ea 0c             	shr    $0xc,%edx
  800e8a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e91:	f6 c2 01             	test   $0x1,%dl
  800e94:	74 1a                	je     800eb0 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e96:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e99:	89 02                	mov    %eax,(%edx)
	return 0;
  800e9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    
		return -E_INVAL;
  800ea2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea7:	eb f7                	jmp    800ea0 <fd_lookup+0x3f>
		return -E_INVAL;
  800ea9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eae:	eb f0                	jmp    800ea0 <fd_lookup+0x3f>
  800eb0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb5:	eb e9                	jmp    800ea0 <fd_lookup+0x3f>

00800eb7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 08             	sub    $0x8,%esp
  800ebd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec0:	ba 2c 22 80 00       	mov    $0x80222c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ec5:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800eca:	39 08                	cmp    %ecx,(%eax)
  800ecc:	74 33                	je     800f01 <dev_lookup+0x4a>
  800ece:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ed1:	8b 02                	mov    (%edx),%eax
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	75 f3                	jne    800eca <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ed7:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800edc:	8b 40 48             	mov    0x48(%eax),%eax
  800edf:	83 ec 04             	sub    $0x4,%esp
  800ee2:	51                   	push   %ecx
  800ee3:	50                   	push   %eax
  800ee4:	68 ac 21 80 00       	push   $0x8021ac
  800ee9:	e8 29 f3 ff ff       	call   800217 <cprintf>
	*dev = 0;
  800eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ef7:	83 c4 10             	add    $0x10,%esp
  800efa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800eff:	c9                   	leave  
  800f00:	c3                   	ret    
			*dev = devtab[i];
  800f01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f04:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f06:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0b:	eb f2                	jmp    800eff <dev_lookup+0x48>

00800f0d <fd_close>:
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
  800f13:	83 ec 1c             	sub    $0x1c,%esp
  800f16:	8b 75 08             	mov    0x8(%ebp),%esi
  800f19:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f1c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f1f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f20:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f26:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f29:	50                   	push   %eax
  800f2a:	e8 32 ff ff ff       	call   800e61 <fd_lookup>
  800f2f:	89 c3                	mov    %eax,%ebx
  800f31:	83 c4 08             	add    $0x8,%esp
  800f34:	85 c0                	test   %eax,%eax
  800f36:	78 05                	js     800f3d <fd_close+0x30>
	    || fd != fd2)
  800f38:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f3b:	74 16                	je     800f53 <fd_close+0x46>
		return (must_exist ? r : 0);
  800f3d:	89 f8                	mov    %edi,%eax
  800f3f:	84 c0                	test   %al,%al
  800f41:	b8 00 00 00 00       	mov    $0x0,%eax
  800f46:	0f 44 d8             	cmove  %eax,%ebx
}
  800f49:	89 d8                	mov    %ebx,%eax
  800f4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4e:	5b                   	pop    %ebx
  800f4f:	5e                   	pop    %esi
  800f50:	5f                   	pop    %edi
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f53:	83 ec 08             	sub    $0x8,%esp
  800f56:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f59:	50                   	push   %eax
  800f5a:	ff 36                	pushl  (%esi)
  800f5c:	e8 56 ff ff ff       	call   800eb7 <dev_lookup>
  800f61:	89 c3                	mov    %eax,%ebx
  800f63:	83 c4 10             	add    $0x10,%esp
  800f66:	85 c0                	test   %eax,%eax
  800f68:	78 15                	js     800f7f <fd_close+0x72>
		if (dev->dev_close)
  800f6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f6d:	8b 40 10             	mov    0x10(%eax),%eax
  800f70:	85 c0                	test   %eax,%eax
  800f72:	74 1b                	je     800f8f <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f74:	83 ec 0c             	sub    $0xc,%esp
  800f77:	56                   	push   %esi
  800f78:	ff d0                	call   *%eax
  800f7a:	89 c3                	mov    %eax,%ebx
  800f7c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f7f:	83 ec 08             	sub    $0x8,%esp
  800f82:	56                   	push   %esi
  800f83:	6a 00                	push   $0x0
  800f85:	e8 f5 fc ff ff       	call   800c7f <sys_page_unmap>
	return r;
  800f8a:	83 c4 10             	add    $0x10,%esp
  800f8d:	eb ba                	jmp    800f49 <fd_close+0x3c>
			r = 0;
  800f8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f94:	eb e9                	jmp    800f7f <fd_close+0x72>

00800f96 <close>:

int
close(int fdnum)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f9f:	50                   	push   %eax
  800fa0:	ff 75 08             	pushl  0x8(%ebp)
  800fa3:	e8 b9 fe ff ff       	call   800e61 <fd_lookup>
  800fa8:	83 c4 08             	add    $0x8,%esp
  800fab:	85 c0                	test   %eax,%eax
  800fad:	78 10                	js     800fbf <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800faf:	83 ec 08             	sub    $0x8,%esp
  800fb2:	6a 01                	push   $0x1
  800fb4:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb7:	e8 51 ff ff ff       	call   800f0d <fd_close>
  800fbc:	83 c4 10             	add    $0x10,%esp
}
  800fbf:	c9                   	leave  
  800fc0:	c3                   	ret    

00800fc1 <close_all>:

void
close_all(void)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	53                   	push   %ebx
  800fc5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fc8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fcd:	83 ec 0c             	sub    $0xc,%esp
  800fd0:	53                   	push   %ebx
  800fd1:	e8 c0 ff ff ff       	call   800f96 <close>
	for (i = 0; i < MAXFD; i++)
  800fd6:	83 c3 01             	add    $0x1,%ebx
  800fd9:	83 c4 10             	add    $0x10,%esp
  800fdc:	83 fb 20             	cmp    $0x20,%ebx
  800fdf:	75 ec                	jne    800fcd <close_all+0xc>
}
  800fe1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fe4:	c9                   	leave  
  800fe5:	c3                   	ret    

00800fe6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	57                   	push   %edi
  800fea:	56                   	push   %esi
  800feb:	53                   	push   %ebx
  800fec:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ff2:	50                   	push   %eax
  800ff3:	ff 75 08             	pushl  0x8(%ebp)
  800ff6:	e8 66 fe ff ff       	call   800e61 <fd_lookup>
  800ffb:	89 c3                	mov    %eax,%ebx
  800ffd:	83 c4 08             	add    $0x8,%esp
  801000:	85 c0                	test   %eax,%eax
  801002:	0f 88 81 00 00 00    	js     801089 <dup+0xa3>
		return r;
	close(newfdnum);
  801008:	83 ec 0c             	sub    $0xc,%esp
  80100b:	ff 75 0c             	pushl  0xc(%ebp)
  80100e:	e8 83 ff ff ff       	call   800f96 <close>

	newfd = INDEX2FD(newfdnum);
  801013:	8b 75 0c             	mov    0xc(%ebp),%esi
  801016:	c1 e6 0c             	shl    $0xc,%esi
  801019:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80101f:	83 c4 04             	add    $0x4,%esp
  801022:	ff 75 e4             	pushl  -0x1c(%ebp)
  801025:	e8 d1 fd ff ff       	call   800dfb <fd2data>
  80102a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80102c:	89 34 24             	mov    %esi,(%esp)
  80102f:	e8 c7 fd ff ff       	call   800dfb <fd2data>
  801034:	83 c4 10             	add    $0x10,%esp
  801037:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801039:	89 d8                	mov    %ebx,%eax
  80103b:	c1 e8 16             	shr    $0x16,%eax
  80103e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801045:	a8 01                	test   $0x1,%al
  801047:	74 11                	je     80105a <dup+0x74>
  801049:	89 d8                	mov    %ebx,%eax
  80104b:	c1 e8 0c             	shr    $0xc,%eax
  80104e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801055:	f6 c2 01             	test   $0x1,%dl
  801058:	75 39                	jne    801093 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80105a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80105d:	89 d0                	mov    %edx,%eax
  80105f:	c1 e8 0c             	shr    $0xc,%eax
  801062:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	25 07 0e 00 00       	and    $0xe07,%eax
  801071:	50                   	push   %eax
  801072:	56                   	push   %esi
  801073:	6a 00                	push   $0x0
  801075:	52                   	push   %edx
  801076:	6a 00                	push   $0x0
  801078:	e8 c0 fb ff ff       	call   800c3d <sys_page_map>
  80107d:	89 c3                	mov    %eax,%ebx
  80107f:	83 c4 20             	add    $0x20,%esp
  801082:	85 c0                	test   %eax,%eax
  801084:	78 31                	js     8010b7 <dup+0xd1>
		goto err;

	return newfdnum;
  801086:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801089:	89 d8                	mov    %ebx,%eax
  80108b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108e:	5b                   	pop    %ebx
  80108f:	5e                   	pop    %esi
  801090:	5f                   	pop    %edi
  801091:	5d                   	pop    %ebp
  801092:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801093:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80109a:	83 ec 0c             	sub    $0xc,%esp
  80109d:	25 07 0e 00 00       	and    $0xe07,%eax
  8010a2:	50                   	push   %eax
  8010a3:	57                   	push   %edi
  8010a4:	6a 00                	push   $0x0
  8010a6:	53                   	push   %ebx
  8010a7:	6a 00                	push   $0x0
  8010a9:	e8 8f fb ff ff       	call   800c3d <sys_page_map>
  8010ae:	89 c3                	mov    %eax,%ebx
  8010b0:	83 c4 20             	add    $0x20,%esp
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	79 a3                	jns    80105a <dup+0x74>
	sys_page_unmap(0, newfd);
  8010b7:	83 ec 08             	sub    $0x8,%esp
  8010ba:	56                   	push   %esi
  8010bb:	6a 00                	push   $0x0
  8010bd:	e8 bd fb ff ff       	call   800c7f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010c2:	83 c4 08             	add    $0x8,%esp
  8010c5:	57                   	push   %edi
  8010c6:	6a 00                	push   $0x0
  8010c8:	e8 b2 fb ff ff       	call   800c7f <sys_page_unmap>
	return r;
  8010cd:	83 c4 10             	add    $0x10,%esp
  8010d0:	eb b7                	jmp    801089 <dup+0xa3>

008010d2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 14             	sub    $0x14,%esp
  8010d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010df:	50                   	push   %eax
  8010e0:	53                   	push   %ebx
  8010e1:	e8 7b fd ff ff       	call   800e61 <fd_lookup>
  8010e6:	83 c4 08             	add    $0x8,%esp
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	78 3f                	js     80112c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010f3:	50                   	push   %eax
  8010f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f7:	ff 30                	pushl  (%eax)
  8010f9:	e8 b9 fd ff ff       	call   800eb7 <dev_lookup>
  8010fe:	83 c4 10             	add    $0x10,%esp
  801101:	85 c0                	test   %eax,%eax
  801103:	78 27                	js     80112c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801105:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801108:	8b 42 08             	mov    0x8(%edx),%eax
  80110b:	83 e0 03             	and    $0x3,%eax
  80110e:	83 f8 01             	cmp    $0x1,%eax
  801111:	74 1e                	je     801131 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801116:	8b 40 08             	mov    0x8(%eax),%eax
  801119:	85 c0                	test   %eax,%eax
  80111b:	74 35                	je     801152 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80111d:	83 ec 04             	sub    $0x4,%esp
  801120:	ff 75 10             	pushl  0x10(%ebp)
  801123:	ff 75 0c             	pushl  0xc(%ebp)
  801126:	52                   	push   %edx
  801127:	ff d0                	call   *%eax
  801129:	83 c4 10             	add    $0x10,%esp
}
  80112c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112f:	c9                   	leave  
  801130:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801131:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801136:	8b 40 48             	mov    0x48(%eax),%eax
  801139:	83 ec 04             	sub    $0x4,%esp
  80113c:	53                   	push   %ebx
  80113d:	50                   	push   %eax
  80113e:	68 f0 21 80 00       	push   $0x8021f0
  801143:	e8 cf f0 ff ff       	call   800217 <cprintf>
		return -E_INVAL;
  801148:	83 c4 10             	add    $0x10,%esp
  80114b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801150:	eb da                	jmp    80112c <read+0x5a>
		return -E_NOT_SUPP;
  801152:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801157:	eb d3                	jmp    80112c <read+0x5a>

00801159 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	57                   	push   %edi
  80115d:	56                   	push   %esi
  80115e:	53                   	push   %ebx
  80115f:	83 ec 0c             	sub    $0xc,%esp
  801162:	8b 7d 08             	mov    0x8(%ebp),%edi
  801165:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801168:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116d:	39 f3                	cmp    %esi,%ebx
  80116f:	73 25                	jae    801196 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801171:	83 ec 04             	sub    $0x4,%esp
  801174:	89 f0                	mov    %esi,%eax
  801176:	29 d8                	sub    %ebx,%eax
  801178:	50                   	push   %eax
  801179:	89 d8                	mov    %ebx,%eax
  80117b:	03 45 0c             	add    0xc(%ebp),%eax
  80117e:	50                   	push   %eax
  80117f:	57                   	push   %edi
  801180:	e8 4d ff ff ff       	call   8010d2 <read>
		if (m < 0)
  801185:	83 c4 10             	add    $0x10,%esp
  801188:	85 c0                	test   %eax,%eax
  80118a:	78 08                	js     801194 <readn+0x3b>
			return m;
		if (m == 0)
  80118c:	85 c0                	test   %eax,%eax
  80118e:	74 06                	je     801196 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801190:	01 c3                	add    %eax,%ebx
  801192:	eb d9                	jmp    80116d <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801194:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801196:	89 d8                	mov    %ebx,%eax
  801198:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119b:	5b                   	pop    %ebx
  80119c:	5e                   	pop    %esi
  80119d:	5f                   	pop    %edi
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	53                   	push   %ebx
  8011a4:	83 ec 14             	sub    $0x14,%esp
  8011a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011ad:	50                   	push   %eax
  8011ae:	53                   	push   %ebx
  8011af:	e8 ad fc ff ff       	call   800e61 <fd_lookup>
  8011b4:	83 c4 08             	add    $0x8,%esp
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	78 3a                	js     8011f5 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c1:	50                   	push   %eax
  8011c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c5:	ff 30                	pushl  (%eax)
  8011c7:	e8 eb fc ff ff       	call   800eb7 <dev_lookup>
  8011cc:	83 c4 10             	add    $0x10,%esp
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	78 22                	js     8011f5 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011d6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011da:	74 1e                	je     8011fa <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011df:	8b 52 0c             	mov    0xc(%edx),%edx
  8011e2:	85 d2                	test   %edx,%edx
  8011e4:	74 35                	je     80121b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011e6:	83 ec 04             	sub    $0x4,%esp
  8011e9:	ff 75 10             	pushl  0x10(%ebp)
  8011ec:	ff 75 0c             	pushl  0xc(%ebp)
  8011ef:	50                   	push   %eax
  8011f0:	ff d2                	call   *%edx
  8011f2:	83 c4 10             	add    $0x10,%esp
}
  8011f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011fa:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8011ff:	8b 40 48             	mov    0x48(%eax),%eax
  801202:	83 ec 04             	sub    $0x4,%esp
  801205:	53                   	push   %ebx
  801206:	50                   	push   %eax
  801207:	68 0c 22 80 00       	push   $0x80220c
  80120c:	e8 06 f0 ff ff       	call   800217 <cprintf>
		return -E_INVAL;
  801211:	83 c4 10             	add    $0x10,%esp
  801214:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801219:	eb da                	jmp    8011f5 <write+0x55>
		return -E_NOT_SUPP;
  80121b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801220:	eb d3                	jmp    8011f5 <write+0x55>

00801222 <seek>:

int
seek(int fdnum, off_t offset)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801228:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80122b:	50                   	push   %eax
  80122c:	ff 75 08             	pushl  0x8(%ebp)
  80122f:	e8 2d fc ff ff       	call   800e61 <fd_lookup>
  801234:	83 c4 08             	add    $0x8,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	78 0e                	js     801249 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80123b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801241:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801244:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	53                   	push   %ebx
  80124f:	83 ec 14             	sub    $0x14,%esp
  801252:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801255:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801258:	50                   	push   %eax
  801259:	53                   	push   %ebx
  80125a:	e8 02 fc ff ff       	call   800e61 <fd_lookup>
  80125f:	83 c4 08             	add    $0x8,%esp
  801262:	85 c0                	test   %eax,%eax
  801264:	78 37                	js     80129d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801266:	83 ec 08             	sub    $0x8,%esp
  801269:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126c:	50                   	push   %eax
  80126d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801270:	ff 30                	pushl  (%eax)
  801272:	e8 40 fc ff ff       	call   800eb7 <dev_lookup>
  801277:	83 c4 10             	add    $0x10,%esp
  80127a:	85 c0                	test   %eax,%eax
  80127c:	78 1f                	js     80129d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80127e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801281:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801285:	74 1b                	je     8012a2 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801287:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128a:	8b 52 18             	mov    0x18(%edx),%edx
  80128d:	85 d2                	test   %edx,%edx
  80128f:	74 32                	je     8012c3 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801291:	83 ec 08             	sub    $0x8,%esp
  801294:	ff 75 0c             	pushl  0xc(%ebp)
  801297:	50                   	push   %eax
  801298:	ff d2                	call   *%edx
  80129a:	83 c4 10             	add    $0x10,%esp
}
  80129d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012a2:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012a7:	8b 40 48             	mov    0x48(%eax),%eax
  8012aa:	83 ec 04             	sub    $0x4,%esp
  8012ad:	53                   	push   %ebx
  8012ae:	50                   	push   %eax
  8012af:	68 cc 21 80 00       	push   $0x8021cc
  8012b4:	e8 5e ef ff ff       	call   800217 <cprintf>
		return -E_INVAL;
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c1:	eb da                	jmp    80129d <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c8:	eb d3                	jmp    80129d <ftruncate+0x52>

008012ca <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	53                   	push   %ebx
  8012ce:	83 ec 14             	sub    $0x14,%esp
  8012d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d7:	50                   	push   %eax
  8012d8:	ff 75 08             	pushl  0x8(%ebp)
  8012db:	e8 81 fb ff ff       	call   800e61 <fd_lookup>
  8012e0:	83 c4 08             	add    $0x8,%esp
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	78 4b                	js     801332 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e7:	83 ec 08             	sub    $0x8,%esp
  8012ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ed:	50                   	push   %eax
  8012ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f1:	ff 30                	pushl  (%eax)
  8012f3:	e8 bf fb ff ff       	call   800eb7 <dev_lookup>
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	78 33                	js     801332 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8012ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801302:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801306:	74 2f                	je     801337 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801308:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80130b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801312:	00 00 00 
	stat->st_isdir = 0;
  801315:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80131c:	00 00 00 
	stat->st_dev = dev;
  80131f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801325:	83 ec 08             	sub    $0x8,%esp
  801328:	53                   	push   %ebx
  801329:	ff 75 f0             	pushl  -0x10(%ebp)
  80132c:	ff 50 14             	call   *0x14(%eax)
  80132f:	83 c4 10             	add    $0x10,%esp
}
  801332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801335:	c9                   	leave  
  801336:	c3                   	ret    
		return -E_NOT_SUPP;
  801337:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80133c:	eb f4                	jmp    801332 <fstat+0x68>

0080133e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	56                   	push   %esi
  801342:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801343:	83 ec 08             	sub    $0x8,%esp
  801346:	6a 00                	push   $0x0
  801348:	ff 75 08             	pushl  0x8(%ebp)
  80134b:	e8 e7 01 00 00       	call   801537 <open>
  801350:	89 c3                	mov    %eax,%ebx
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	78 1b                	js     801374 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801359:	83 ec 08             	sub    $0x8,%esp
  80135c:	ff 75 0c             	pushl  0xc(%ebp)
  80135f:	50                   	push   %eax
  801360:	e8 65 ff ff ff       	call   8012ca <fstat>
  801365:	89 c6                	mov    %eax,%esi
	close(fd);
  801367:	89 1c 24             	mov    %ebx,(%esp)
  80136a:	e8 27 fc ff ff       	call   800f96 <close>
	return r;
  80136f:	83 c4 10             	add    $0x10,%esp
  801372:	89 f3                	mov    %esi,%ebx
}
  801374:	89 d8                	mov    %ebx,%eax
  801376:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801379:	5b                   	pop    %ebx
  80137a:	5e                   	pop    %esi
  80137b:	5d                   	pop    %ebp
  80137c:	c3                   	ret    

0080137d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	56                   	push   %esi
  801381:	53                   	push   %ebx
  801382:	89 c6                	mov    %eax,%esi
  801384:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801386:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80138d:	74 27                	je     8013b6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80138f:	6a 07                	push   $0x7
  801391:	68 00 50 c0 00       	push   $0xc05000
  801396:	56                   	push   %esi
  801397:	ff 35 00 40 80 00    	pushl  0x804000
  80139d:	e8 1b 07 00 00       	call   801abd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013a2:	83 c4 0c             	add    $0xc,%esp
  8013a5:	6a 00                	push   $0x0
  8013a7:	53                   	push   %ebx
  8013a8:	6a 00                	push   $0x0
  8013aa:	e8 f7 06 00 00       	call   801aa6 <ipc_recv>
}
  8013af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b2:	5b                   	pop    %ebx
  8013b3:	5e                   	pop    %esi
  8013b4:	5d                   	pop    %ebp
  8013b5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	6a 01                	push   $0x1
  8013bb:	e8 14 07 00 00       	call   801ad4 <ipc_find_env>
  8013c0:	a3 00 40 80 00       	mov    %eax,0x804000
  8013c5:	83 c4 10             	add    $0x10,%esp
  8013c8:	eb c5                	jmp    80138f <fsipc+0x12>

008013ca <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8013d6:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  8013db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013de:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e8:	b8 02 00 00 00       	mov    $0x2,%eax
  8013ed:	e8 8b ff ff ff       	call   80137d <fsipc>
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <devfile_flush>:
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801400:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  801405:	ba 00 00 00 00       	mov    $0x0,%edx
  80140a:	b8 06 00 00 00       	mov    $0x6,%eax
  80140f:	e8 69 ff ff ff       	call   80137d <fsipc>
}
  801414:	c9                   	leave  
  801415:	c3                   	ret    

00801416 <devfile_stat>:
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	53                   	push   %ebx
  80141a:	83 ec 04             	sub    $0x4,%esp
  80141d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8b 40 0c             	mov    0xc(%eax),%eax
  801426:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80142b:	ba 00 00 00 00       	mov    $0x0,%edx
  801430:	b8 05 00 00 00       	mov    $0x5,%eax
  801435:	e8 43 ff ff ff       	call   80137d <fsipc>
  80143a:	85 c0                	test   %eax,%eax
  80143c:	78 2c                	js     80146a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80143e:	83 ec 08             	sub    $0x8,%esp
  801441:	68 00 50 c0 00       	push   $0xc05000
  801446:	53                   	push   %ebx
  801447:	e8 b5 f3 ff ff       	call   800801 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80144c:	a1 80 50 c0 00       	mov    0xc05080,%eax
  801451:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801457:	a1 84 50 c0 00       	mov    0xc05084,%eax
  80145c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801462:	83 c4 10             	add    $0x10,%esp
  801465:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80146a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <devfile_write>:
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	83 ec 0c             	sub    $0xc,%esp
  801475:	8b 45 10             	mov    0x10(%ebp),%eax
  801478:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80147d:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801482:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801485:	8b 55 08             	mov    0x8(%ebp),%edx
  801488:	8b 52 0c             	mov    0xc(%edx),%edx
  80148b:	89 15 00 50 c0 00    	mov    %edx,0xc05000
        fsipcbuf.write.req_n = n;
  801491:	a3 04 50 c0 00       	mov    %eax,0xc05004
        memmove(fsipcbuf.write.req_buf, buf, n);
  801496:	50                   	push   %eax
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	68 08 50 c0 00       	push   $0xc05008
  80149f:	e8 eb f4 ff ff       	call   80098f <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a9:	b8 04 00 00 00       	mov    $0x4,%eax
  8014ae:	e8 ca fe ff ff       	call   80137d <fsipc>
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <devfile_read>:
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	56                   	push   %esi
  8014b9:	53                   	push   %ebx
  8014ba:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8014c3:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  8014c8:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d3:	b8 03 00 00 00       	mov    $0x3,%eax
  8014d8:	e8 a0 fe ff ff       	call   80137d <fsipc>
  8014dd:	89 c3                	mov    %eax,%ebx
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	78 1f                	js     801502 <devfile_read+0x4d>
	assert(r <= n);
  8014e3:	39 f0                	cmp    %esi,%eax
  8014e5:	77 24                	ja     80150b <devfile_read+0x56>
	assert(r <= PGSIZE);
  8014e7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014ec:	7f 33                	jg     801521 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014ee:	83 ec 04             	sub    $0x4,%esp
  8014f1:	50                   	push   %eax
  8014f2:	68 00 50 c0 00       	push   $0xc05000
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	e8 90 f4 ff ff       	call   80098f <memmove>
	return r;
  8014ff:	83 c4 10             	add    $0x10,%esp
}
  801502:	89 d8                	mov    %ebx,%eax
  801504:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801507:	5b                   	pop    %ebx
  801508:	5e                   	pop    %esi
  801509:	5d                   	pop    %ebp
  80150a:	c3                   	ret    
	assert(r <= n);
  80150b:	68 3c 22 80 00       	push   $0x80223c
  801510:	68 43 22 80 00       	push   $0x802243
  801515:	6a 7c                	push   $0x7c
  801517:	68 58 22 80 00       	push   $0x802258
  80151c:	e8 1b ec ff ff       	call   80013c <_panic>
	assert(r <= PGSIZE);
  801521:	68 63 22 80 00       	push   $0x802263
  801526:	68 43 22 80 00       	push   $0x802243
  80152b:	6a 7d                	push   $0x7d
  80152d:	68 58 22 80 00       	push   $0x802258
  801532:	e8 05 ec ff ff       	call   80013c <_panic>

00801537 <open>:
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	56                   	push   %esi
  80153b:	53                   	push   %ebx
  80153c:	83 ec 1c             	sub    $0x1c,%esp
  80153f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801542:	56                   	push   %esi
  801543:	e8 82 f2 ff ff       	call   8007ca <strlen>
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801550:	7f 6c                	jg     8015be <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801552:	83 ec 0c             	sub    $0xc,%esp
  801555:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801558:	50                   	push   %eax
  801559:	e8 b4 f8 ff ff       	call   800e12 <fd_alloc>
  80155e:	89 c3                	mov    %eax,%ebx
  801560:	83 c4 10             	add    $0x10,%esp
  801563:	85 c0                	test   %eax,%eax
  801565:	78 3c                	js     8015a3 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801567:	83 ec 08             	sub    $0x8,%esp
  80156a:	56                   	push   %esi
  80156b:	68 00 50 c0 00       	push   $0xc05000
  801570:	e8 8c f2 ff ff       	call   800801 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801575:	8b 45 0c             	mov    0xc(%ebp),%eax
  801578:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80157d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801580:	b8 01 00 00 00       	mov    $0x1,%eax
  801585:	e8 f3 fd ff ff       	call   80137d <fsipc>
  80158a:	89 c3                	mov    %eax,%ebx
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	85 c0                	test   %eax,%eax
  801591:	78 19                	js     8015ac <open+0x75>
	return fd2num(fd);
  801593:	83 ec 0c             	sub    $0xc,%esp
  801596:	ff 75 f4             	pushl  -0xc(%ebp)
  801599:	e8 4d f8 ff ff       	call   800deb <fd2num>
  80159e:	89 c3                	mov    %eax,%ebx
  8015a0:	83 c4 10             	add    $0x10,%esp
}
  8015a3:	89 d8                	mov    %ebx,%eax
  8015a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a8:	5b                   	pop    %ebx
  8015a9:	5e                   	pop    %esi
  8015aa:	5d                   	pop    %ebp
  8015ab:	c3                   	ret    
		fd_close(fd, 0);
  8015ac:	83 ec 08             	sub    $0x8,%esp
  8015af:	6a 00                	push   $0x0
  8015b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b4:	e8 54 f9 ff ff       	call   800f0d <fd_close>
		return r;
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	eb e5                	jmp    8015a3 <open+0x6c>
		return -E_BAD_PATH;
  8015be:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015c3:	eb de                	jmp    8015a3 <open+0x6c>

008015c5 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d0:	b8 08 00 00 00       	mov    $0x8,%eax
  8015d5:	e8 a3 fd ff ff       	call   80137d <fsipc>
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	56                   	push   %esi
  8015e0:	53                   	push   %ebx
  8015e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8015e4:	83 ec 0c             	sub    $0xc,%esp
  8015e7:	ff 75 08             	pushl  0x8(%ebp)
  8015ea:	e8 0c f8 ff ff       	call   800dfb <fd2data>
  8015ef:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8015f1:	83 c4 08             	add    $0x8,%esp
  8015f4:	68 6f 22 80 00       	push   $0x80226f
  8015f9:	53                   	push   %ebx
  8015fa:	e8 02 f2 ff ff       	call   800801 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8015ff:	8b 46 04             	mov    0x4(%esi),%eax
  801602:	2b 06                	sub    (%esi),%eax
  801604:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80160a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801611:	00 00 00 
	stat->st_dev = &devpipe;
  801614:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80161b:	30 80 00 
	return 0;
}
  80161e:	b8 00 00 00 00       	mov    $0x0,%eax
  801623:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801626:	5b                   	pop    %ebx
  801627:	5e                   	pop    %esi
  801628:	5d                   	pop    %ebp
  801629:	c3                   	ret    

0080162a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	53                   	push   %ebx
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801634:	53                   	push   %ebx
  801635:	6a 00                	push   $0x0
  801637:	e8 43 f6 ff ff       	call   800c7f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80163c:	89 1c 24             	mov    %ebx,(%esp)
  80163f:	e8 b7 f7 ff ff       	call   800dfb <fd2data>
  801644:	83 c4 08             	add    $0x8,%esp
  801647:	50                   	push   %eax
  801648:	6a 00                	push   $0x0
  80164a:	e8 30 f6 ff ff       	call   800c7f <sys_page_unmap>
}
  80164f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <_pipeisclosed>:
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	57                   	push   %edi
  801658:	56                   	push   %esi
  801659:	53                   	push   %ebx
  80165a:	83 ec 1c             	sub    $0x1c,%esp
  80165d:	89 c7                	mov    %eax,%edi
  80165f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801661:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801666:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801669:	83 ec 0c             	sub    $0xc,%esp
  80166c:	57                   	push   %edi
  80166d:	e8 9b 04 00 00       	call   801b0d <pageref>
  801672:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801675:	89 34 24             	mov    %esi,(%esp)
  801678:	e8 90 04 00 00       	call   801b0d <pageref>
		nn = thisenv->env_runs;
  80167d:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801683:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	39 cb                	cmp    %ecx,%ebx
  80168b:	74 1b                	je     8016a8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80168d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801690:	75 cf                	jne    801661 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801692:	8b 42 58             	mov    0x58(%edx),%eax
  801695:	6a 01                	push   $0x1
  801697:	50                   	push   %eax
  801698:	53                   	push   %ebx
  801699:	68 76 22 80 00       	push   $0x802276
  80169e:	e8 74 eb ff ff       	call   800217 <cprintf>
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	eb b9                	jmp    801661 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016a8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016ab:	0f 94 c0             	sete   %al
  8016ae:	0f b6 c0             	movzbl %al,%eax
}
  8016b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b4:	5b                   	pop    %ebx
  8016b5:	5e                   	pop    %esi
  8016b6:	5f                   	pop    %edi
  8016b7:	5d                   	pop    %ebp
  8016b8:	c3                   	ret    

008016b9 <devpipe_write>:
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	57                   	push   %edi
  8016bd:	56                   	push   %esi
  8016be:	53                   	push   %ebx
  8016bf:	83 ec 28             	sub    $0x28,%esp
  8016c2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8016c5:	56                   	push   %esi
  8016c6:	e8 30 f7 ff ff       	call   800dfb <fd2data>
  8016cb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8016d5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8016d8:	74 4f                	je     801729 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8016da:	8b 43 04             	mov    0x4(%ebx),%eax
  8016dd:	8b 0b                	mov    (%ebx),%ecx
  8016df:	8d 51 20             	lea    0x20(%ecx),%edx
  8016e2:	39 d0                	cmp    %edx,%eax
  8016e4:	72 14                	jb     8016fa <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8016e6:	89 da                	mov    %ebx,%edx
  8016e8:	89 f0                	mov    %esi,%eax
  8016ea:	e8 65 ff ff ff       	call   801654 <_pipeisclosed>
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	75 3a                	jne    80172d <devpipe_write+0x74>
			sys_yield();
  8016f3:	e8 e3 f4 ff ff       	call   800bdb <sys_yield>
  8016f8:	eb e0                	jmp    8016da <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8016fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016fd:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801701:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801704:	89 c2                	mov    %eax,%edx
  801706:	c1 fa 1f             	sar    $0x1f,%edx
  801709:	89 d1                	mov    %edx,%ecx
  80170b:	c1 e9 1b             	shr    $0x1b,%ecx
  80170e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801711:	83 e2 1f             	and    $0x1f,%edx
  801714:	29 ca                	sub    %ecx,%edx
  801716:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80171a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80171e:	83 c0 01             	add    $0x1,%eax
  801721:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801724:	83 c7 01             	add    $0x1,%edi
  801727:	eb ac                	jmp    8016d5 <devpipe_write+0x1c>
	return i;
  801729:	89 f8                	mov    %edi,%eax
  80172b:	eb 05                	jmp    801732 <devpipe_write+0x79>
				return 0;
  80172d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801732:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801735:	5b                   	pop    %ebx
  801736:	5e                   	pop    %esi
  801737:	5f                   	pop    %edi
  801738:	5d                   	pop    %ebp
  801739:	c3                   	ret    

0080173a <devpipe_read>:
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	57                   	push   %edi
  80173e:	56                   	push   %esi
  80173f:	53                   	push   %ebx
  801740:	83 ec 18             	sub    $0x18,%esp
  801743:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801746:	57                   	push   %edi
  801747:	e8 af f6 ff ff       	call   800dfb <fd2data>
  80174c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	be 00 00 00 00       	mov    $0x0,%esi
  801756:	3b 75 10             	cmp    0x10(%ebp),%esi
  801759:	74 47                	je     8017a2 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  80175b:	8b 03                	mov    (%ebx),%eax
  80175d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801760:	75 22                	jne    801784 <devpipe_read+0x4a>
			if (i > 0)
  801762:	85 f6                	test   %esi,%esi
  801764:	75 14                	jne    80177a <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801766:	89 da                	mov    %ebx,%edx
  801768:	89 f8                	mov    %edi,%eax
  80176a:	e8 e5 fe ff ff       	call   801654 <_pipeisclosed>
  80176f:	85 c0                	test   %eax,%eax
  801771:	75 33                	jne    8017a6 <devpipe_read+0x6c>
			sys_yield();
  801773:	e8 63 f4 ff ff       	call   800bdb <sys_yield>
  801778:	eb e1                	jmp    80175b <devpipe_read+0x21>
				return i;
  80177a:	89 f0                	mov    %esi,%eax
}
  80177c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177f:	5b                   	pop    %ebx
  801780:	5e                   	pop    %esi
  801781:	5f                   	pop    %edi
  801782:	5d                   	pop    %ebp
  801783:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801784:	99                   	cltd   
  801785:	c1 ea 1b             	shr    $0x1b,%edx
  801788:	01 d0                	add    %edx,%eax
  80178a:	83 e0 1f             	and    $0x1f,%eax
  80178d:	29 d0                	sub    %edx,%eax
  80178f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801794:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801797:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80179a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80179d:	83 c6 01             	add    $0x1,%esi
  8017a0:	eb b4                	jmp    801756 <devpipe_read+0x1c>
	return i;
  8017a2:	89 f0                	mov    %esi,%eax
  8017a4:	eb d6                	jmp    80177c <devpipe_read+0x42>
				return 0;
  8017a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ab:	eb cf                	jmp    80177c <devpipe_read+0x42>

008017ad <pipe>:
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	56                   	push   %esi
  8017b1:	53                   	push   %ebx
  8017b2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8017b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b8:	50                   	push   %eax
  8017b9:	e8 54 f6 ff ff       	call   800e12 <fd_alloc>
  8017be:	89 c3                	mov    %eax,%ebx
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	78 5b                	js     801822 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	68 07 04 00 00       	push   $0x407
  8017cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d2:	6a 00                	push   $0x0
  8017d4:	e8 21 f4 ff ff       	call   800bfa <sys_page_alloc>
  8017d9:	89 c3                	mov    %eax,%ebx
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	78 40                	js     801822 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8017e2:	83 ec 0c             	sub    $0xc,%esp
  8017e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017e8:	50                   	push   %eax
  8017e9:	e8 24 f6 ff ff       	call   800e12 <fd_alloc>
  8017ee:	89 c3                	mov    %eax,%ebx
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	78 1b                	js     801812 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	68 07 04 00 00       	push   $0x407
  8017ff:	ff 75 f0             	pushl  -0x10(%ebp)
  801802:	6a 00                	push   $0x0
  801804:	e8 f1 f3 ff ff       	call   800bfa <sys_page_alloc>
  801809:	89 c3                	mov    %eax,%ebx
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	85 c0                	test   %eax,%eax
  801810:	79 19                	jns    80182b <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801812:	83 ec 08             	sub    $0x8,%esp
  801815:	ff 75 f4             	pushl  -0xc(%ebp)
  801818:	6a 00                	push   $0x0
  80181a:	e8 60 f4 ff ff       	call   800c7f <sys_page_unmap>
  80181f:	83 c4 10             	add    $0x10,%esp
}
  801822:	89 d8                	mov    %ebx,%eax
  801824:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801827:	5b                   	pop    %ebx
  801828:	5e                   	pop    %esi
  801829:	5d                   	pop    %ebp
  80182a:	c3                   	ret    
	va = fd2data(fd0);
  80182b:	83 ec 0c             	sub    $0xc,%esp
  80182e:	ff 75 f4             	pushl  -0xc(%ebp)
  801831:	e8 c5 f5 ff ff       	call   800dfb <fd2data>
  801836:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801838:	83 c4 0c             	add    $0xc,%esp
  80183b:	68 07 04 00 00       	push   $0x407
  801840:	50                   	push   %eax
  801841:	6a 00                	push   $0x0
  801843:	e8 b2 f3 ff ff       	call   800bfa <sys_page_alloc>
  801848:	89 c3                	mov    %eax,%ebx
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	85 c0                	test   %eax,%eax
  80184f:	0f 88 8c 00 00 00    	js     8018e1 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801855:	83 ec 0c             	sub    $0xc,%esp
  801858:	ff 75 f0             	pushl  -0x10(%ebp)
  80185b:	e8 9b f5 ff ff       	call   800dfb <fd2data>
  801860:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801867:	50                   	push   %eax
  801868:	6a 00                	push   $0x0
  80186a:	56                   	push   %esi
  80186b:	6a 00                	push   $0x0
  80186d:	e8 cb f3 ff ff       	call   800c3d <sys_page_map>
  801872:	89 c3                	mov    %eax,%ebx
  801874:	83 c4 20             	add    $0x20,%esp
  801877:	85 c0                	test   %eax,%eax
  801879:	78 58                	js     8018d3 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80187b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801884:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801889:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801893:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801899:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018a5:	83 ec 0c             	sub    $0xc,%esp
  8018a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ab:	e8 3b f5 ff ff       	call   800deb <fd2num>
  8018b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018b5:	83 c4 04             	add    $0x4,%esp
  8018b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8018bb:	e8 2b f5 ff ff       	call   800deb <fd2num>
  8018c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018ce:	e9 4f ff ff ff       	jmp    801822 <pipe+0x75>
	sys_page_unmap(0, va);
  8018d3:	83 ec 08             	sub    $0x8,%esp
  8018d6:	56                   	push   %esi
  8018d7:	6a 00                	push   $0x0
  8018d9:	e8 a1 f3 ff ff       	call   800c7f <sys_page_unmap>
  8018de:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8018e1:	83 ec 08             	sub    $0x8,%esp
  8018e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e7:	6a 00                	push   $0x0
  8018e9:	e8 91 f3 ff ff       	call   800c7f <sys_page_unmap>
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	e9 1c ff ff ff       	jmp    801812 <pipe+0x65>

008018f6 <pipeisclosed>:
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ff:	50                   	push   %eax
  801900:	ff 75 08             	pushl  0x8(%ebp)
  801903:	e8 59 f5 ff ff       	call   800e61 <fd_lookup>
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	78 18                	js     801927 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80190f:	83 ec 0c             	sub    $0xc,%esp
  801912:	ff 75 f4             	pushl  -0xc(%ebp)
  801915:	e8 e1 f4 ff ff       	call   800dfb <fd2data>
	return _pipeisclosed(fd, p);
  80191a:	89 c2                	mov    %eax,%edx
  80191c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191f:	e8 30 fd ff ff       	call   801654 <_pipeisclosed>
  801924:	83 c4 10             	add    $0x10,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80192c:	b8 00 00 00 00       	mov    $0x0,%eax
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    

00801933 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801939:	68 8e 22 80 00       	push   $0x80228e
  80193e:	ff 75 0c             	pushl  0xc(%ebp)
  801941:	e8 bb ee ff ff       	call   800801 <strcpy>
	return 0;
}
  801946:	b8 00 00 00 00       	mov    $0x0,%eax
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <devcons_write>:
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	57                   	push   %edi
  801951:	56                   	push   %esi
  801952:	53                   	push   %ebx
  801953:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801959:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80195e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801964:	eb 2f                	jmp    801995 <devcons_write+0x48>
		m = n - tot;
  801966:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801969:	29 f3                	sub    %esi,%ebx
  80196b:	83 fb 7f             	cmp    $0x7f,%ebx
  80196e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801973:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	53                   	push   %ebx
  80197a:	89 f0                	mov    %esi,%eax
  80197c:	03 45 0c             	add    0xc(%ebp),%eax
  80197f:	50                   	push   %eax
  801980:	57                   	push   %edi
  801981:	e8 09 f0 ff ff       	call   80098f <memmove>
		sys_cputs(buf, m);
  801986:	83 c4 08             	add    $0x8,%esp
  801989:	53                   	push   %ebx
  80198a:	57                   	push   %edi
  80198b:	e8 ae f1 ff ff       	call   800b3e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801990:	01 de                	add    %ebx,%esi
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	3b 75 10             	cmp    0x10(%ebp),%esi
  801998:	72 cc                	jb     801966 <devcons_write+0x19>
}
  80199a:	89 f0                	mov    %esi,%eax
  80199c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5e                   	pop    %esi
  8019a1:	5f                   	pop    %edi
  8019a2:	5d                   	pop    %ebp
  8019a3:	c3                   	ret    

008019a4 <devcons_read>:
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 08             	sub    $0x8,%esp
  8019aa:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8019af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b3:	75 07                	jne    8019bc <devcons_read+0x18>
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    
		sys_yield();
  8019b7:	e8 1f f2 ff ff       	call   800bdb <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8019bc:	e8 9b f1 ff ff       	call   800b5c <sys_cgetc>
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	74 f2                	je     8019b7 <devcons_read+0x13>
	if (c < 0)
  8019c5:	85 c0                	test   %eax,%eax
  8019c7:	78 ec                	js     8019b5 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8019c9:	83 f8 04             	cmp    $0x4,%eax
  8019cc:	74 0c                	je     8019da <devcons_read+0x36>
	*(char*)vbuf = c;
  8019ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d1:	88 02                	mov    %al,(%edx)
	return 1;
  8019d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d8:	eb db                	jmp    8019b5 <devcons_read+0x11>
		return 0;
  8019da:	b8 00 00 00 00       	mov    $0x0,%eax
  8019df:	eb d4                	jmp    8019b5 <devcons_read+0x11>

008019e1 <cputchar>:
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8019ed:	6a 01                	push   $0x1
  8019ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8019f2:	50                   	push   %eax
  8019f3:	e8 46 f1 ff ff       	call   800b3e <sys_cputs>
}
  8019f8:	83 c4 10             	add    $0x10,%esp
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <getchar>:
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a03:	6a 01                	push   $0x1
  801a05:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a08:	50                   	push   %eax
  801a09:	6a 00                	push   $0x0
  801a0b:	e8 c2 f6 ff ff       	call   8010d2 <read>
	if (r < 0)
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 08                	js     801a1f <getchar+0x22>
	if (r < 1)
  801a17:	85 c0                	test   %eax,%eax
  801a19:	7e 06                	jle    801a21 <getchar+0x24>
	return c;
  801a1b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    
		return -E_EOF;
  801a21:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a26:	eb f7                	jmp    801a1f <getchar+0x22>

00801a28 <iscons>:
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a31:	50                   	push   %eax
  801a32:	ff 75 08             	pushl  0x8(%ebp)
  801a35:	e8 27 f4 ff ff       	call   800e61 <fd_lookup>
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	78 11                	js     801a52 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a44:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a4a:	39 10                	cmp    %edx,(%eax)
  801a4c:	0f 94 c0             	sete   %al
  801a4f:	0f b6 c0             	movzbl %al,%eax
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <opencons>:
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801a5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5d:	50                   	push   %eax
  801a5e:	e8 af f3 ff ff       	call   800e12 <fd_alloc>
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	85 c0                	test   %eax,%eax
  801a68:	78 3a                	js     801aa4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a6a:	83 ec 04             	sub    $0x4,%esp
  801a6d:	68 07 04 00 00       	push   $0x407
  801a72:	ff 75 f4             	pushl  -0xc(%ebp)
  801a75:	6a 00                	push   $0x0
  801a77:	e8 7e f1 ff ff       	call   800bfa <sys_page_alloc>
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	78 21                	js     801aa4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a86:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a8c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a91:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801a98:	83 ec 0c             	sub    $0xc,%esp
  801a9b:	50                   	push   %eax
  801a9c:	e8 4a f3 ff ff       	call   800deb <fd2num>
  801aa1:	83 c4 10             	add    $0x10,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801aac:	68 9a 22 80 00       	push   $0x80229a
  801ab1:	6a 1a                	push   $0x1a
  801ab3:	68 b3 22 80 00       	push   $0x8022b3
  801ab8:	e8 7f e6 ff ff       	call   80013c <_panic>

00801abd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801ac3:	68 bd 22 80 00       	push   $0x8022bd
  801ac8:	6a 2a                	push   $0x2a
  801aca:	68 b3 22 80 00       	push   $0x8022b3
  801acf:	e8 68 e6 ff ff       	call   80013c <_panic>

00801ad4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ada:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801adf:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801ae2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ae8:	8b 52 50             	mov    0x50(%edx),%edx
  801aeb:	39 ca                	cmp    %ecx,%edx
  801aed:	74 11                	je     801b00 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801aef:	83 c0 01             	add    $0x1,%eax
  801af2:	3d 00 04 00 00       	cmp    $0x400,%eax
  801af7:	75 e6                	jne    801adf <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801af9:	b8 00 00 00 00       	mov    $0x0,%eax
  801afe:	eb 0b                	jmp    801b0b <ipc_find_env+0x37>
			return envs[i].env_id;
  801b00:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b03:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b08:	8b 40 48             	mov    0x48(%eax),%eax
}
  801b0b:	5d                   	pop    %ebp
  801b0c:	c3                   	ret    

00801b0d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801b13:	89 d0                	mov    %edx,%eax
  801b15:	c1 e8 16             	shr    $0x16,%eax
  801b18:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801b1f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801b24:	f6 c1 01             	test   $0x1,%cl
  801b27:	74 1d                	je     801b46 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801b29:	c1 ea 0c             	shr    $0xc,%edx
  801b2c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801b33:	f6 c2 01             	test   $0x1,%dl
  801b36:	74 0e                	je     801b46 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b38:	c1 ea 0c             	shr    $0xc,%edx
  801b3b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801b42:	ef 
  801b43:	0f b7 c0             	movzwl %ax,%eax
}
  801b46:	5d                   	pop    %ebp
  801b47:	c3                   	ret    
  801b48:	66 90                	xchg   %ax,%ax
  801b4a:	66 90                	xchg   %ax,%ax
  801b4c:	66 90                	xchg   %ax,%ax
  801b4e:	66 90                	xchg   %ax,%ax

00801b50 <__udivdi3>:
  801b50:	55                   	push   %ebp
  801b51:	57                   	push   %edi
  801b52:	56                   	push   %esi
  801b53:	53                   	push   %ebx
  801b54:	83 ec 1c             	sub    $0x1c,%esp
  801b57:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801b5b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801b5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b63:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801b67:	85 d2                	test   %edx,%edx
  801b69:	75 35                	jne    801ba0 <__udivdi3+0x50>
  801b6b:	39 f3                	cmp    %esi,%ebx
  801b6d:	0f 87 bd 00 00 00    	ja     801c30 <__udivdi3+0xe0>
  801b73:	85 db                	test   %ebx,%ebx
  801b75:	89 d9                	mov    %ebx,%ecx
  801b77:	75 0b                	jne    801b84 <__udivdi3+0x34>
  801b79:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7e:	31 d2                	xor    %edx,%edx
  801b80:	f7 f3                	div    %ebx
  801b82:	89 c1                	mov    %eax,%ecx
  801b84:	31 d2                	xor    %edx,%edx
  801b86:	89 f0                	mov    %esi,%eax
  801b88:	f7 f1                	div    %ecx
  801b8a:	89 c6                	mov    %eax,%esi
  801b8c:	89 e8                	mov    %ebp,%eax
  801b8e:	89 f7                	mov    %esi,%edi
  801b90:	f7 f1                	div    %ecx
  801b92:	89 fa                	mov    %edi,%edx
  801b94:	83 c4 1c             	add    $0x1c,%esp
  801b97:	5b                   	pop    %ebx
  801b98:	5e                   	pop    %esi
  801b99:	5f                   	pop    %edi
  801b9a:	5d                   	pop    %ebp
  801b9b:	c3                   	ret    
  801b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ba0:	39 f2                	cmp    %esi,%edx
  801ba2:	77 7c                	ja     801c20 <__udivdi3+0xd0>
  801ba4:	0f bd fa             	bsr    %edx,%edi
  801ba7:	83 f7 1f             	xor    $0x1f,%edi
  801baa:	0f 84 98 00 00 00    	je     801c48 <__udivdi3+0xf8>
  801bb0:	89 f9                	mov    %edi,%ecx
  801bb2:	b8 20 00 00 00       	mov    $0x20,%eax
  801bb7:	29 f8                	sub    %edi,%eax
  801bb9:	d3 e2                	shl    %cl,%edx
  801bbb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bbf:	89 c1                	mov    %eax,%ecx
  801bc1:	89 da                	mov    %ebx,%edx
  801bc3:	d3 ea                	shr    %cl,%edx
  801bc5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801bc9:	09 d1                	or     %edx,%ecx
  801bcb:	89 f2                	mov    %esi,%edx
  801bcd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bd1:	89 f9                	mov    %edi,%ecx
  801bd3:	d3 e3                	shl    %cl,%ebx
  801bd5:	89 c1                	mov    %eax,%ecx
  801bd7:	d3 ea                	shr    %cl,%edx
  801bd9:	89 f9                	mov    %edi,%ecx
  801bdb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801bdf:	d3 e6                	shl    %cl,%esi
  801be1:	89 eb                	mov    %ebp,%ebx
  801be3:	89 c1                	mov    %eax,%ecx
  801be5:	d3 eb                	shr    %cl,%ebx
  801be7:	09 de                	or     %ebx,%esi
  801be9:	89 f0                	mov    %esi,%eax
  801beb:	f7 74 24 08          	divl   0x8(%esp)
  801bef:	89 d6                	mov    %edx,%esi
  801bf1:	89 c3                	mov    %eax,%ebx
  801bf3:	f7 64 24 0c          	mull   0xc(%esp)
  801bf7:	39 d6                	cmp    %edx,%esi
  801bf9:	72 0c                	jb     801c07 <__udivdi3+0xb7>
  801bfb:	89 f9                	mov    %edi,%ecx
  801bfd:	d3 e5                	shl    %cl,%ebp
  801bff:	39 c5                	cmp    %eax,%ebp
  801c01:	73 5d                	jae    801c60 <__udivdi3+0x110>
  801c03:	39 d6                	cmp    %edx,%esi
  801c05:	75 59                	jne    801c60 <__udivdi3+0x110>
  801c07:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c0a:	31 ff                	xor    %edi,%edi
  801c0c:	89 fa                	mov    %edi,%edx
  801c0e:	83 c4 1c             	add    $0x1c,%esp
  801c11:	5b                   	pop    %ebx
  801c12:	5e                   	pop    %esi
  801c13:	5f                   	pop    %edi
  801c14:	5d                   	pop    %ebp
  801c15:	c3                   	ret    
  801c16:	8d 76 00             	lea    0x0(%esi),%esi
  801c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801c20:	31 ff                	xor    %edi,%edi
  801c22:	31 c0                	xor    %eax,%eax
  801c24:	89 fa                	mov    %edi,%edx
  801c26:	83 c4 1c             	add    $0x1c,%esp
  801c29:	5b                   	pop    %ebx
  801c2a:	5e                   	pop    %esi
  801c2b:	5f                   	pop    %edi
  801c2c:	5d                   	pop    %ebp
  801c2d:	c3                   	ret    
  801c2e:	66 90                	xchg   %ax,%ax
  801c30:	31 ff                	xor    %edi,%edi
  801c32:	89 e8                	mov    %ebp,%eax
  801c34:	89 f2                	mov    %esi,%edx
  801c36:	f7 f3                	div    %ebx
  801c38:	89 fa                	mov    %edi,%edx
  801c3a:	83 c4 1c             	add    $0x1c,%esp
  801c3d:	5b                   	pop    %ebx
  801c3e:	5e                   	pop    %esi
  801c3f:	5f                   	pop    %edi
  801c40:	5d                   	pop    %ebp
  801c41:	c3                   	ret    
  801c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801c48:	39 f2                	cmp    %esi,%edx
  801c4a:	72 06                	jb     801c52 <__udivdi3+0x102>
  801c4c:	31 c0                	xor    %eax,%eax
  801c4e:	39 eb                	cmp    %ebp,%ebx
  801c50:	77 d2                	ja     801c24 <__udivdi3+0xd4>
  801c52:	b8 01 00 00 00       	mov    $0x1,%eax
  801c57:	eb cb                	jmp    801c24 <__udivdi3+0xd4>
  801c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801c60:	89 d8                	mov    %ebx,%eax
  801c62:	31 ff                	xor    %edi,%edi
  801c64:	eb be                	jmp    801c24 <__udivdi3+0xd4>
  801c66:	66 90                	xchg   %ax,%ax
  801c68:	66 90                	xchg   %ax,%ax
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	66 90                	xchg   %ax,%ax
  801c6e:	66 90                	xchg   %ax,%ax

00801c70 <__umoddi3>:
  801c70:	55                   	push   %ebp
  801c71:	57                   	push   %edi
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	83 ec 1c             	sub    $0x1c,%esp
  801c77:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801c7b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801c7f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801c83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c87:	85 ed                	test   %ebp,%ebp
  801c89:	89 f0                	mov    %esi,%eax
  801c8b:	89 da                	mov    %ebx,%edx
  801c8d:	75 19                	jne    801ca8 <__umoddi3+0x38>
  801c8f:	39 df                	cmp    %ebx,%edi
  801c91:	0f 86 b1 00 00 00    	jbe    801d48 <__umoddi3+0xd8>
  801c97:	f7 f7                	div    %edi
  801c99:	89 d0                	mov    %edx,%eax
  801c9b:	31 d2                	xor    %edx,%edx
  801c9d:	83 c4 1c             	add    $0x1c,%esp
  801ca0:	5b                   	pop    %ebx
  801ca1:	5e                   	pop    %esi
  801ca2:	5f                   	pop    %edi
  801ca3:	5d                   	pop    %ebp
  801ca4:	c3                   	ret    
  801ca5:	8d 76 00             	lea    0x0(%esi),%esi
  801ca8:	39 dd                	cmp    %ebx,%ebp
  801caa:	77 f1                	ja     801c9d <__umoddi3+0x2d>
  801cac:	0f bd cd             	bsr    %ebp,%ecx
  801caf:	83 f1 1f             	xor    $0x1f,%ecx
  801cb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cb6:	0f 84 b4 00 00 00    	je     801d70 <__umoddi3+0x100>
  801cbc:	b8 20 00 00 00       	mov    $0x20,%eax
  801cc1:	89 c2                	mov    %eax,%edx
  801cc3:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cc7:	29 c2                	sub    %eax,%edx
  801cc9:	89 c1                	mov    %eax,%ecx
  801ccb:	89 f8                	mov    %edi,%eax
  801ccd:	d3 e5                	shl    %cl,%ebp
  801ccf:	89 d1                	mov    %edx,%ecx
  801cd1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801cd5:	d3 e8                	shr    %cl,%eax
  801cd7:	09 c5                	or     %eax,%ebp
  801cd9:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cdd:	89 c1                	mov    %eax,%ecx
  801cdf:	d3 e7                	shl    %cl,%edi
  801ce1:	89 d1                	mov    %edx,%ecx
  801ce3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801ce7:	89 df                	mov    %ebx,%edi
  801ce9:	d3 ef                	shr    %cl,%edi
  801ceb:	89 c1                	mov    %eax,%ecx
  801ced:	89 f0                	mov    %esi,%eax
  801cef:	d3 e3                	shl    %cl,%ebx
  801cf1:	89 d1                	mov    %edx,%ecx
  801cf3:	89 fa                	mov    %edi,%edx
  801cf5:	d3 e8                	shr    %cl,%eax
  801cf7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801cfc:	09 d8                	or     %ebx,%eax
  801cfe:	f7 f5                	div    %ebp
  801d00:	d3 e6                	shl    %cl,%esi
  801d02:	89 d1                	mov    %edx,%ecx
  801d04:	f7 64 24 08          	mull   0x8(%esp)
  801d08:	39 d1                	cmp    %edx,%ecx
  801d0a:	89 c3                	mov    %eax,%ebx
  801d0c:	89 d7                	mov    %edx,%edi
  801d0e:	72 06                	jb     801d16 <__umoddi3+0xa6>
  801d10:	75 0e                	jne    801d20 <__umoddi3+0xb0>
  801d12:	39 c6                	cmp    %eax,%esi
  801d14:	73 0a                	jae    801d20 <__umoddi3+0xb0>
  801d16:	2b 44 24 08          	sub    0x8(%esp),%eax
  801d1a:	19 ea                	sbb    %ebp,%edx
  801d1c:	89 d7                	mov    %edx,%edi
  801d1e:	89 c3                	mov    %eax,%ebx
  801d20:	89 ca                	mov    %ecx,%edx
  801d22:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801d27:	29 de                	sub    %ebx,%esi
  801d29:	19 fa                	sbb    %edi,%edx
  801d2b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d2f:	89 d0                	mov    %edx,%eax
  801d31:	d3 e0                	shl    %cl,%eax
  801d33:	89 d9                	mov    %ebx,%ecx
  801d35:	d3 ee                	shr    %cl,%esi
  801d37:	d3 ea                	shr    %cl,%edx
  801d39:	09 f0                	or     %esi,%eax
  801d3b:	83 c4 1c             	add    $0x1c,%esp
  801d3e:	5b                   	pop    %ebx
  801d3f:	5e                   	pop    %esi
  801d40:	5f                   	pop    %edi
  801d41:	5d                   	pop    %ebp
  801d42:	c3                   	ret    
  801d43:	90                   	nop
  801d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d48:	85 ff                	test   %edi,%edi
  801d4a:	89 f9                	mov    %edi,%ecx
  801d4c:	75 0b                	jne    801d59 <__umoddi3+0xe9>
  801d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d53:	31 d2                	xor    %edx,%edx
  801d55:	f7 f7                	div    %edi
  801d57:	89 c1                	mov    %eax,%ecx
  801d59:	89 d8                	mov    %ebx,%eax
  801d5b:	31 d2                	xor    %edx,%edx
  801d5d:	f7 f1                	div    %ecx
  801d5f:	89 f0                	mov    %esi,%eax
  801d61:	f7 f1                	div    %ecx
  801d63:	e9 31 ff ff ff       	jmp    801c99 <__umoddi3+0x29>
  801d68:	90                   	nop
  801d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801d70:	39 dd                	cmp    %ebx,%ebp
  801d72:	72 08                	jb     801d7c <__umoddi3+0x10c>
  801d74:	39 f7                	cmp    %esi,%edi
  801d76:	0f 87 21 ff ff ff    	ja     801c9d <__umoddi3+0x2d>
  801d7c:	89 da                	mov    %ebx,%edx
  801d7e:	89 f0                	mov    %esi,%eax
  801d80:	29 f8                	sub    %edi,%eax
  801d82:	19 ea                	sbb    %ebp,%edx
  801d84:	e9 14 ff ff ff       	jmp    801c9d <__umoddi3+0x2d>
