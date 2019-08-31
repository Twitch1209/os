
obj/user/testpteshare.debug：     文件格式 elf32-i386


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
  80002c:	e8 65 01 00 00       	call   800196 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  800039:	ff 35 00 30 80 00    	pushl  0x803000
  80003f:	68 00 00 00 a0       	push   $0xa0000000
  800044:	e8 72 08 00 00       	call   8008bb <strcpy>
	exit();
  800049:	e8 8e 01 00 00       	call   8001dc <exit>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <umain>:
{
  800053:	55                   	push   %ebp
  800054:	89 e5                	mov    %esp,%ebp
  800056:	53                   	push   %ebx
  800057:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	0f 85 d2 00 00 00    	jne    800136 <umain+0xe3>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 07 04 00 00       	push   $0x407
  80006c:	68 00 00 00 a0       	push   $0xa0000000
  800071:	6a 00                	push   $0x0
  800073:	e8 3c 0c 00 00       	call   800cb4 <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bd 00 00 00    	js     800140 <umain+0xed>
	if ((r = fork()) < 0)
  800083:	e8 34 0e 00 00       	call   800ebc <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 c0 00 00 00    	js     800152 <umain+0xff>
	if (r == 0) {
  800092:	85 c0                	test   %eax,%eax
  800094:	0f 84 ca 00 00 00    	je     800164 <umain+0x111>
	wait(r);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	53                   	push   %ebx
  80009e:	e8 8f 21 00 00       	call   802232 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a3:	83 c4 08             	add    $0x8,%esp
  8000a6:	ff 35 04 30 80 00    	pushl  0x803004
  8000ac:	68 00 00 00 a0       	push   $0xa0000000
  8000b1:	e8 ab 08 00 00       	call   800961 <strcmp>
  8000b6:	83 c4 08             	add    $0x8,%esp
  8000b9:	85 c0                	test   %eax,%eax
  8000bb:	b8 80 27 80 00       	mov    $0x802780,%eax
  8000c0:	ba 86 27 80 00       	mov    $0x802786,%edx
  8000c5:	0f 45 c2             	cmovne %edx,%eax
  8000c8:	50                   	push   %eax
  8000c9:	68 bc 27 80 00       	push   $0x8027bc
  8000ce:	e8 fe 01 00 00       	call   8002d1 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d3:	6a 00                	push   $0x0
  8000d5:	68 d7 27 80 00       	push   $0x8027d7
  8000da:	68 dc 27 80 00       	push   $0x8027dc
  8000df:	68 db 27 80 00       	push   $0x8027db
  8000e4:	e8 7f 1d 00 00       	call   801e68 <spawnl>
  8000e9:	83 c4 20             	add    $0x20,%esp
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	0f 88 90 00 00 00    	js     800184 <umain+0x131>
	wait(r);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 35 21 00 00       	call   802232 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fd:	83 c4 08             	add    $0x8,%esp
  800100:	ff 35 00 30 80 00    	pushl  0x803000
  800106:	68 00 00 00 a0       	push   $0xa0000000
  80010b:	e8 51 08 00 00       	call   800961 <strcmp>
  800110:	83 c4 08             	add    $0x8,%esp
  800113:	85 c0                	test   %eax,%eax
  800115:	b8 80 27 80 00       	mov    $0x802780,%eax
  80011a:	ba 86 27 80 00       	mov    $0x802786,%edx
  80011f:	0f 45 c2             	cmovne %edx,%eax
  800122:	50                   	push   %eax
  800123:	68 f3 27 80 00       	push   $0x8027f3
  800128:	e8 a4 01 00 00       	call   8002d1 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80012d:	cc                   	int3   
}
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800134:	c9                   	leave  
  800135:	c3                   	ret    
		childofspawn();
  800136:	e8 f8 fe ff ff       	call   800033 <childofspawn>
  80013b:	e9 24 ff ff ff       	jmp    800064 <umain+0x11>
		panic("sys_page_alloc: %e", r);
  800140:	50                   	push   %eax
  800141:	68 8c 27 80 00       	push   $0x80278c
  800146:	6a 13                	push   $0x13
  800148:	68 9f 27 80 00       	push   $0x80279f
  80014d:	e8 a4 00 00 00       	call   8001f6 <_panic>
		panic("fork: %e", r);
  800152:	50                   	push   %eax
  800153:	68 b3 27 80 00       	push   $0x8027b3
  800158:	6a 17                	push   $0x17
  80015a:	68 9f 27 80 00       	push   $0x80279f
  80015f:	e8 92 00 00 00       	call   8001f6 <_panic>
		strcpy(VA, msg);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	ff 35 04 30 80 00    	pushl  0x803004
  80016d:	68 00 00 00 a0       	push   $0xa0000000
  800172:	e8 44 07 00 00       	call   8008bb <strcpy>
		exit();
  800177:	e8 60 00 00 00       	call   8001dc <exit>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	e9 16 ff ff ff       	jmp    80009a <umain+0x47>
		panic("spawn: %e", r);
  800184:	50                   	push   %eax
  800185:	68 e9 27 80 00       	push   $0x8027e9
  80018a:	6a 21                	push   $0x21
  80018c:	68 9f 27 80 00       	push   $0x80279f
  800191:	e8 60 00 00 00       	call   8001f6 <_panic>

00800196 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	56                   	push   %esi
  80019a:	53                   	push   %ebx
  80019b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80019e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001a1:	e8 d0 0a 00 00       	call   800c76 <sys_getenvid>
  8001a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ab:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001b3:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b8:	85 db                	test   %ebx,%ebx
  8001ba:	7e 07                	jle    8001c3 <libmain+0x2d>
		binaryname = argv[0];
  8001bc:	8b 06                	mov    (%esi),%eax
  8001be:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	56                   	push   %esi
  8001c7:	53                   	push   %ebx
  8001c8:	e8 86 fe ff ff       	call   800053 <umain>

	// exit gracefully
	exit();
  8001cd:	e8 0a 00 00 00       	call   8001dc <exit>
}
  8001d2:	83 c4 10             	add    $0x10,%esp
  8001d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001d8:	5b                   	pop    %ebx
  8001d9:	5e                   	pop    %esi
  8001da:	5d                   	pop    %ebp
  8001db:	c3                   	ret    

008001dc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001e2:	e8 cd 10 00 00       	call   8012b4 <close_all>
	sys_env_destroy(0);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	6a 00                	push   $0x0
  8001ec:	e8 44 0a 00 00       	call   800c35 <sys_env_destroy>
}
  8001f1:	83 c4 10             	add    $0x10,%esp
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001fb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001fe:	8b 35 08 30 80 00    	mov    0x803008,%esi
  800204:	e8 6d 0a 00 00       	call   800c76 <sys_getenvid>
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	ff 75 0c             	pushl  0xc(%ebp)
  80020f:	ff 75 08             	pushl  0x8(%ebp)
  800212:	56                   	push   %esi
  800213:	50                   	push   %eax
  800214:	68 38 28 80 00       	push   $0x802838
  800219:	e8 b3 00 00 00       	call   8002d1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80021e:	83 c4 18             	add    $0x18,%esp
  800221:	53                   	push   %ebx
  800222:	ff 75 10             	pushl  0x10(%ebp)
  800225:	e8 56 00 00 00       	call   800280 <vcprintf>
	cprintf("\n");
  80022a:	c7 04 24 b8 2d 80 00 	movl   $0x802db8,(%esp)
  800231:	e8 9b 00 00 00       	call   8002d1 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800239:	cc                   	int3   
  80023a:	eb fd                	jmp    800239 <_panic+0x43>

0080023c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	53                   	push   %ebx
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800246:	8b 13                	mov    (%ebx),%edx
  800248:	8d 42 01             	lea    0x1(%edx),%eax
  80024b:	89 03                	mov    %eax,(%ebx)
  80024d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800250:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800254:	3d ff 00 00 00       	cmp    $0xff,%eax
  800259:	74 09                	je     800264 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80025b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80025f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800262:	c9                   	leave  
  800263:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	68 ff 00 00 00       	push   $0xff
  80026c:	8d 43 08             	lea    0x8(%ebx),%eax
  80026f:	50                   	push   %eax
  800270:	e8 83 09 00 00       	call   800bf8 <sys_cputs>
		b->idx = 0;
  800275:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80027b:	83 c4 10             	add    $0x10,%esp
  80027e:	eb db                	jmp    80025b <putch+0x1f>

00800280 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800289:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800290:	00 00 00 
	b.cnt = 0;
  800293:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80029d:	ff 75 0c             	pushl  0xc(%ebp)
  8002a0:	ff 75 08             	pushl  0x8(%ebp)
  8002a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a9:	50                   	push   %eax
  8002aa:	68 3c 02 80 00       	push   $0x80023c
  8002af:	e8 1a 01 00 00       	call   8003ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002b4:	83 c4 08             	add    $0x8,%esp
  8002b7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002bd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	e8 2f 09 00 00       	call   800bf8 <sys_cputs>

	return b.cnt;
}
  8002c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002da:	50                   	push   %eax
  8002db:	ff 75 08             	pushl  0x8(%ebp)
  8002de:	e8 9d ff ff ff       	call   800280 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002e3:	c9                   	leave  
  8002e4:	c3                   	ret    

008002e5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	57                   	push   %edi
  8002e9:	56                   	push   %esi
  8002ea:	53                   	push   %ebx
  8002eb:	83 ec 1c             	sub    $0x1c,%esp
  8002ee:	89 c7                	mov    %eax,%edi
  8002f0:	89 d6                	mov    %edx,%esi
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800301:	bb 00 00 00 00       	mov    $0x0,%ebx
  800306:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800309:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80030c:	39 d3                	cmp    %edx,%ebx
  80030e:	72 05                	jb     800315 <printnum+0x30>
  800310:	39 45 10             	cmp    %eax,0x10(%ebp)
  800313:	77 7a                	ja     80038f <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	ff 75 18             	pushl  0x18(%ebp)
  80031b:	8b 45 14             	mov    0x14(%ebp),%eax
  80031e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800321:	53                   	push   %ebx
  800322:	ff 75 10             	pushl  0x10(%ebp)
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032b:	ff 75 e0             	pushl  -0x20(%ebp)
  80032e:	ff 75 dc             	pushl  -0x24(%ebp)
  800331:	ff 75 d8             	pushl  -0x28(%ebp)
  800334:	e8 07 22 00 00       	call   802540 <__udivdi3>
  800339:	83 c4 18             	add    $0x18,%esp
  80033c:	52                   	push   %edx
  80033d:	50                   	push   %eax
  80033e:	89 f2                	mov    %esi,%edx
  800340:	89 f8                	mov    %edi,%eax
  800342:	e8 9e ff ff ff       	call   8002e5 <printnum>
  800347:	83 c4 20             	add    $0x20,%esp
  80034a:	eb 13                	jmp    80035f <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	56                   	push   %esi
  800350:	ff 75 18             	pushl  0x18(%ebp)
  800353:	ff d7                	call   *%edi
  800355:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800358:	83 eb 01             	sub    $0x1,%ebx
  80035b:	85 db                	test   %ebx,%ebx
  80035d:	7f ed                	jg     80034c <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	56                   	push   %esi
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	ff 75 e4             	pushl  -0x1c(%ebp)
  800369:	ff 75 e0             	pushl  -0x20(%ebp)
  80036c:	ff 75 dc             	pushl  -0x24(%ebp)
  80036f:	ff 75 d8             	pushl  -0x28(%ebp)
  800372:	e8 e9 22 00 00       	call   802660 <__umoddi3>
  800377:	83 c4 14             	add    $0x14,%esp
  80037a:	0f be 80 5b 28 80 00 	movsbl 0x80285b(%eax),%eax
  800381:	50                   	push   %eax
  800382:	ff d7                	call   *%edi
}
  800384:	83 c4 10             	add    $0x10,%esp
  800387:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80038a:	5b                   	pop    %ebx
  80038b:	5e                   	pop    %esi
  80038c:	5f                   	pop    %edi
  80038d:	5d                   	pop    %ebp
  80038e:	c3                   	ret    
  80038f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800392:	eb c4                	jmp    800358 <printnum+0x73>

00800394 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80039a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80039e:	8b 10                	mov    (%eax),%edx
  8003a0:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a3:	73 0a                	jae    8003af <sprintputch+0x1b>
		*b->buf++ = ch;
  8003a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003a8:	89 08                	mov    %ecx,(%eax)
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	88 02                	mov    %al,(%edx)
}
  8003af:	5d                   	pop    %ebp
  8003b0:	c3                   	ret    

008003b1 <printfmt>:
{
  8003b1:	55                   	push   %ebp
  8003b2:	89 e5                	mov    %esp,%ebp
  8003b4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003b7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ba:	50                   	push   %eax
  8003bb:	ff 75 10             	pushl  0x10(%ebp)
  8003be:	ff 75 0c             	pushl  0xc(%ebp)
  8003c1:	ff 75 08             	pushl  0x8(%ebp)
  8003c4:	e8 05 00 00 00       	call   8003ce <vprintfmt>
}
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <vprintfmt>:
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	57                   	push   %edi
  8003d2:	56                   	push   %esi
  8003d3:	53                   	push   %ebx
  8003d4:	83 ec 2c             	sub    $0x2c,%esp
  8003d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8003da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003dd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003e0:	e9 8c 03 00 00       	jmp    800771 <vprintfmt+0x3a3>
		padc = ' ';
  8003e5:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003e9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003f0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003f7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003fe:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800403:	8d 47 01             	lea    0x1(%edi),%eax
  800406:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800409:	0f b6 17             	movzbl (%edi),%edx
  80040c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80040f:	3c 55                	cmp    $0x55,%al
  800411:	0f 87 dd 03 00 00    	ja     8007f4 <vprintfmt+0x426>
  800417:	0f b6 c0             	movzbl %al,%eax
  80041a:	ff 24 85 a0 29 80 00 	jmp    *0x8029a0(,%eax,4)
  800421:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800424:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800428:	eb d9                	jmp    800403 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80042d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800431:	eb d0                	jmp    800403 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800433:	0f b6 d2             	movzbl %dl,%edx
  800436:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800439:	b8 00 00 00 00       	mov    $0x0,%eax
  80043e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800441:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800444:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800448:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80044b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80044e:	83 f9 09             	cmp    $0x9,%ecx
  800451:	77 55                	ja     8004a8 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800453:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800456:	eb e9                	jmp    800441 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800460:	8b 45 14             	mov    0x14(%ebp),%eax
  800463:	8d 40 04             	lea    0x4(%eax),%eax
  800466:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800469:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80046c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800470:	79 91                	jns    800403 <vprintfmt+0x35>
				width = precision, precision = -1;
  800472:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800475:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800478:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80047f:	eb 82                	jmp    800403 <vprintfmt+0x35>
  800481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800484:	85 c0                	test   %eax,%eax
  800486:	ba 00 00 00 00       	mov    $0x0,%edx
  80048b:	0f 49 d0             	cmovns %eax,%edx
  80048e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800491:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800494:	e9 6a ff ff ff       	jmp    800403 <vprintfmt+0x35>
  800499:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80049c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004a3:	e9 5b ff ff ff       	jmp    800403 <vprintfmt+0x35>
  8004a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004ab:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ae:	eb bc                	jmp    80046c <vprintfmt+0x9e>
			lflag++;
  8004b0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004b6:	e9 48 ff ff ff       	jmp    800403 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8d 78 04             	lea    0x4(%eax),%edi
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	ff 30                	pushl  (%eax)
  8004c7:	ff d6                	call   *%esi
			break;
  8004c9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004cc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004cf:	e9 9a 02 00 00       	jmp    80076e <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8d 78 04             	lea    0x4(%eax),%edi
  8004da:	8b 00                	mov    (%eax),%eax
  8004dc:	99                   	cltd   
  8004dd:	31 d0                	xor    %edx,%eax
  8004df:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004e1:	83 f8 0f             	cmp    $0xf,%eax
  8004e4:	7f 23                	jg     800509 <vprintfmt+0x13b>
  8004e6:	8b 14 85 00 2b 80 00 	mov    0x802b00(,%eax,4),%edx
  8004ed:	85 d2                	test   %edx,%edx
  8004ef:	74 18                	je     800509 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8004f1:	52                   	push   %edx
  8004f2:	68 e9 2c 80 00       	push   $0x802ce9
  8004f7:	53                   	push   %ebx
  8004f8:	56                   	push   %esi
  8004f9:	e8 b3 fe ff ff       	call   8003b1 <printfmt>
  8004fe:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800501:	89 7d 14             	mov    %edi,0x14(%ebp)
  800504:	e9 65 02 00 00       	jmp    80076e <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  800509:	50                   	push   %eax
  80050a:	68 73 28 80 00       	push   $0x802873
  80050f:	53                   	push   %ebx
  800510:	56                   	push   %esi
  800511:	e8 9b fe ff ff       	call   8003b1 <printfmt>
  800516:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800519:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80051c:	e9 4d 02 00 00       	jmp    80076e <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	83 c0 04             	add    $0x4,%eax
  800527:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80052f:	85 ff                	test   %edi,%edi
  800531:	b8 6c 28 80 00       	mov    $0x80286c,%eax
  800536:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800539:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80053d:	0f 8e bd 00 00 00    	jle    800600 <vprintfmt+0x232>
  800543:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800547:	75 0e                	jne    800557 <vprintfmt+0x189>
  800549:	89 75 08             	mov    %esi,0x8(%ebp)
  80054c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80054f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800552:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800555:	eb 6d                	jmp    8005c4 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	ff 75 d0             	pushl  -0x30(%ebp)
  80055d:	57                   	push   %edi
  80055e:	e8 39 03 00 00       	call   80089c <strnlen>
  800563:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800566:	29 c1                	sub    %eax,%ecx
  800568:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80056b:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80056e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800572:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800575:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800578:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80057a:	eb 0f                	jmp    80058b <vprintfmt+0x1bd>
					putch(padc, putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	53                   	push   %ebx
  800580:	ff 75 e0             	pushl  -0x20(%ebp)
  800583:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800585:	83 ef 01             	sub    $0x1,%edi
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	85 ff                	test   %edi,%edi
  80058d:	7f ed                	jg     80057c <vprintfmt+0x1ae>
  80058f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800592:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800595:	85 c9                	test   %ecx,%ecx
  800597:	b8 00 00 00 00       	mov    $0x0,%eax
  80059c:	0f 49 c1             	cmovns %ecx,%eax
  80059f:	29 c1                	sub    %eax,%ecx
  8005a1:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005aa:	89 cb                	mov    %ecx,%ebx
  8005ac:	eb 16                	jmp    8005c4 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005b2:	75 31                	jne    8005e5 <vprintfmt+0x217>
					putch(ch, putdat);
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ba:	50                   	push   %eax
  8005bb:	ff 55 08             	call   *0x8(%ebp)
  8005be:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c1:	83 eb 01             	sub    $0x1,%ebx
  8005c4:	83 c7 01             	add    $0x1,%edi
  8005c7:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005cb:	0f be c2             	movsbl %dl,%eax
  8005ce:	85 c0                	test   %eax,%eax
  8005d0:	74 59                	je     80062b <vprintfmt+0x25d>
  8005d2:	85 f6                	test   %esi,%esi
  8005d4:	78 d8                	js     8005ae <vprintfmt+0x1e0>
  8005d6:	83 ee 01             	sub    $0x1,%esi
  8005d9:	79 d3                	jns    8005ae <vprintfmt+0x1e0>
  8005db:	89 df                	mov    %ebx,%edi
  8005dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005e3:	eb 37                	jmp    80061c <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e5:	0f be d2             	movsbl %dl,%edx
  8005e8:	83 ea 20             	sub    $0x20,%edx
  8005eb:	83 fa 5e             	cmp    $0x5e,%edx
  8005ee:	76 c4                	jbe    8005b4 <vprintfmt+0x1e6>
					putch('?', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	6a 3f                	push   $0x3f
  8005f8:	ff 55 08             	call   *0x8(%ebp)
  8005fb:	83 c4 10             	add    $0x10,%esp
  8005fe:	eb c1                	jmp    8005c1 <vprintfmt+0x1f3>
  800600:	89 75 08             	mov    %esi,0x8(%ebp)
  800603:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800606:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800609:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80060c:	eb b6                	jmp    8005c4 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	53                   	push   %ebx
  800612:	6a 20                	push   $0x20
  800614:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800616:	83 ef 01             	sub    $0x1,%edi
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	85 ff                	test   %edi,%edi
  80061e:	7f ee                	jg     80060e <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800620:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800623:	89 45 14             	mov    %eax,0x14(%ebp)
  800626:	e9 43 01 00 00       	jmp    80076e <vprintfmt+0x3a0>
  80062b:	89 df                	mov    %ebx,%edi
  80062d:	8b 75 08             	mov    0x8(%ebp),%esi
  800630:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800633:	eb e7                	jmp    80061c <vprintfmt+0x24e>
	if (lflag >= 2)
  800635:	83 f9 01             	cmp    $0x1,%ecx
  800638:	7e 3f                	jle    800679 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 50 04             	mov    0x4(%eax),%edx
  800640:	8b 00                	mov    (%eax),%eax
  800642:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800645:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 40 08             	lea    0x8(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800651:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800655:	79 5c                	jns    8006b3 <vprintfmt+0x2e5>
				putch('-', putdat);
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	53                   	push   %ebx
  80065b:	6a 2d                	push   $0x2d
  80065d:	ff d6                	call   *%esi
				num = -(long long) num;
  80065f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800662:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800665:	f7 da                	neg    %edx
  800667:	83 d1 00             	adc    $0x0,%ecx
  80066a:	f7 d9                	neg    %ecx
  80066c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80066f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800674:	e9 db 00 00 00       	jmp    800754 <vprintfmt+0x386>
	else if (lflag)
  800679:	85 c9                	test   %ecx,%ecx
  80067b:	75 1b                	jne    800698 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800685:	89 c1                	mov    %eax,%ecx
  800687:	c1 f9 1f             	sar    $0x1f,%ecx
  80068a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
  800696:	eb b9                	jmp    800651 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a0:	89 c1                	mov    %eax,%ecx
  8006a2:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8d 40 04             	lea    0x4(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b1:	eb 9e                	jmp    800651 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006b3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006be:	e9 91 00 00 00       	jmp    800754 <vprintfmt+0x386>
	if (lflag >= 2)
  8006c3:	83 f9 01             	cmp    $0x1,%ecx
  8006c6:	7e 15                	jle    8006dd <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 10                	mov    (%eax),%edx
  8006cd:	8b 48 04             	mov    0x4(%eax),%ecx
  8006d0:	8d 40 08             	lea    0x8(%eax),%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006db:	eb 77                	jmp    800754 <vprintfmt+0x386>
	else if (lflag)
  8006dd:	85 c9                	test   %ecx,%ecx
  8006df:	75 17                	jne    8006f8 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8b 10                	mov    (%eax),%edx
  8006e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006eb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f6:	eb 5c                	jmp    800754 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 10                	mov    (%eax),%edx
  8006fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800702:	8d 40 04             	lea    0x4(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800708:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070d:	eb 45                	jmp    800754 <vprintfmt+0x386>
			putch('X', putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	53                   	push   %ebx
  800713:	6a 58                	push   $0x58
  800715:	ff d6                	call   *%esi
			putch('X', putdat);
  800717:	83 c4 08             	add    $0x8,%esp
  80071a:	53                   	push   %ebx
  80071b:	6a 58                	push   $0x58
  80071d:	ff d6                	call   *%esi
			putch('X', putdat);
  80071f:	83 c4 08             	add    $0x8,%esp
  800722:	53                   	push   %ebx
  800723:	6a 58                	push   $0x58
  800725:	ff d6                	call   *%esi
			break;
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	eb 42                	jmp    80076e <vprintfmt+0x3a0>
			putch('0', putdat);
  80072c:	83 ec 08             	sub    $0x8,%esp
  80072f:	53                   	push   %ebx
  800730:	6a 30                	push   $0x30
  800732:	ff d6                	call   *%esi
			putch('x', putdat);
  800734:	83 c4 08             	add    $0x8,%esp
  800737:	53                   	push   %ebx
  800738:	6a 78                	push   $0x78
  80073a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8b 10                	mov    (%eax),%edx
  800741:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800746:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800749:	8d 40 04             	lea    0x4(%eax),%eax
  80074c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800754:	83 ec 0c             	sub    $0xc,%esp
  800757:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80075b:	57                   	push   %edi
  80075c:	ff 75 e0             	pushl  -0x20(%ebp)
  80075f:	50                   	push   %eax
  800760:	51                   	push   %ecx
  800761:	52                   	push   %edx
  800762:	89 da                	mov    %ebx,%edx
  800764:	89 f0                	mov    %esi,%eax
  800766:	e8 7a fb ff ff       	call   8002e5 <printnum>
			break;
  80076b:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80076e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800771:	83 c7 01             	add    $0x1,%edi
  800774:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800778:	83 f8 25             	cmp    $0x25,%eax
  80077b:	0f 84 64 fc ff ff    	je     8003e5 <vprintfmt+0x17>
			if (ch == '\0')
  800781:	85 c0                	test   %eax,%eax
  800783:	0f 84 8b 00 00 00    	je     800814 <vprintfmt+0x446>
			putch(ch, putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	53                   	push   %ebx
  80078d:	50                   	push   %eax
  80078e:	ff d6                	call   *%esi
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	eb dc                	jmp    800771 <vprintfmt+0x3a3>
	if (lflag >= 2)
  800795:	83 f9 01             	cmp    $0x1,%ecx
  800798:	7e 15                	jle    8007af <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8b 10                	mov    (%eax),%edx
  80079f:	8b 48 04             	mov    0x4(%eax),%ecx
  8007a2:	8d 40 08             	lea    0x8(%eax),%eax
  8007a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a8:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ad:	eb a5                	jmp    800754 <vprintfmt+0x386>
	else if (lflag)
  8007af:	85 c9                	test   %ecx,%ecx
  8007b1:	75 17                	jne    8007ca <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	8b 10                	mov    (%eax),%edx
  8007b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bd:	8d 40 04             	lea    0x4(%eax),%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c3:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c8:	eb 8a                	jmp    800754 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 10                	mov    (%eax),%edx
  8007cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d4:	8d 40 04             	lea    0x4(%eax),%eax
  8007d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007da:	b8 10 00 00 00       	mov    $0x10,%eax
  8007df:	e9 70 ff ff ff       	jmp    800754 <vprintfmt+0x386>
			putch(ch, putdat);
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	53                   	push   %ebx
  8007e8:	6a 25                	push   $0x25
  8007ea:	ff d6                	call   *%esi
			break;
  8007ec:	83 c4 10             	add    $0x10,%esp
  8007ef:	e9 7a ff ff ff       	jmp    80076e <vprintfmt+0x3a0>
			putch('%', putdat);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	53                   	push   %ebx
  8007f8:	6a 25                	push   $0x25
  8007fa:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007fc:	83 c4 10             	add    $0x10,%esp
  8007ff:	89 f8                	mov    %edi,%eax
  800801:	eb 03                	jmp    800806 <vprintfmt+0x438>
  800803:	83 e8 01             	sub    $0x1,%eax
  800806:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80080a:	75 f7                	jne    800803 <vprintfmt+0x435>
  80080c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080f:	e9 5a ff ff ff       	jmp    80076e <vprintfmt+0x3a0>
}
  800814:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800817:	5b                   	pop    %ebx
  800818:	5e                   	pop    %esi
  800819:	5f                   	pop    %edi
  80081a:	5d                   	pop    %ebp
  80081b:	c3                   	ret    

0080081c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	83 ec 18             	sub    $0x18,%esp
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800828:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80082b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80082f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800832:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800839:	85 c0                	test   %eax,%eax
  80083b:	74 26                	je     800863 <vsnprintf+0x47>
  80083d:	85 d2                	test   %edx,%edx
  80083f:	7e 22                	jle    800863 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800841:	ff 75 14             	pushl  0x14(%ebp)
  800844:	ff 75 10             	pushl  0x10(%ebp)
  800847:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80084a:	50                   	push   %eax
  80084b:	68 94 03 80 00       	push   $0x800394
  800850:	e8 79 fb ff ff       	call   8003ce <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800855:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800858:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80085e:	83 c4 10             	add    $0x10,%esp
}
  800861:	c9                   	leave  
  800862:	c3                   	ret    
		return -E_INVAL;
  800863:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800868:	eb f7                	jmp    800861 <vsnprintf+0x45>

0080086a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800870:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800873:	50                   	push   %eax
  800874:	ff 75 10             	pushl  0x10(%ebp)
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	ff 75 08             	pushl  0x8(%ebp)
  80087d:	e8 9a ff ff ff       	call   80081c <vsnprintf>
	va_end(ap);

	return rc;
}
  800882:	c9                   	leave  
  800883:	c3                   	ret    

00800884 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80088a:	b8 00 00 00 00       	mov    $0x0,%eax
  80088f:	eb 03                	jmp    800894 <strlen+0x10>
		n++;
  800891:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800894:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800898:	75 f7                	jne    800891 <strlen+0xd>
	return n;
}
  80089a:	5d                   	pop    %ebp
  80089b:	c3                   	ret    

0080089c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008aa:	eb 03                	jmp    8008af <strnlen+0x13>
		n++;
  8008ac:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008af:	39 d0                	cmp    %edx,%eax
  8008b1:	74 06                	je     8008b9 <strnlen+0x1d>
  8008b3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008b7:	75 f3                	jne    8008ac <strnlen+0x10>
	return n;
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c5:	89 c2                	mov    %eax,%edx
  8008c7:	83 c1 01             	add    $0x1,%ecx
  8008ca:	83 c2 01             	add    $0x1,%edx
  8008cd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008d1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008d4:	84 db                	test   %bl,%bl
  8008d6:	75 ef                	jne    8008c7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008d8:	5b                   	pop    %ebx
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	53                   	push   %ebx
  8008df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008e2:	53                   	push   %ebx
  8008e3:	e8 9c ff ff ff       	call   800884 <strlen>
  8008e8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	01 d8                	add    %ebx,%eax
  8008f0:	50                   	push   %eax
  8008f1:	e8 c5 ff ff ff       	call   8008bb <strcpy>
	return dst;
}
  8008f6:	89 d8                	mov    %ebx,%eax
  8008f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008fb:	c9                   	leave  
  8008fc:	c3                   	ret    

008008fd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	56                   	push   %esi
  800901:	53                   	push   %ebx
  800902:	8b 75 08             	mov    0x8(%ebp),%esi
  800905:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800908:	89 f3                	mov    %esi,%ebx
  80090a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80090d:	89 f2                	mov    %esi,%edx
  80090f:	eb 0f                	jmp    800920 <strncpy+0x23>
		*dst++ = *src;
  800911:	83 c2 01             	add    $0x1,%edx
  800914:	0f b6 01             	movzbl (%ecx),%eax
  800917:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80091a:	80 39 01             	cmpb   $0x1,(%ecx)
  80091d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800920:	39 da                	cmp    %ebx,%edx
  800922:	75 ed                	jne    800911 <strncpy+0x14>
	}
	return ret;
}
  800924:	89 f0                	mov    %esi,%eax
  800926:	5b                   	pop    %ebx
  800927:	5e                   	pop    %esi
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	56                   	push   %esi
  80092e:	53                   	push   %ebx
  80092f:	8b 75 08             	mov    0x8(%ebp),%esi
  800932:	8b 55 0c             	mov    0xc(%ebp),%edx
  800935:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800938:	89 f0                	mov    %esi,%eax
  80093a:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80093e:	85 c9                	test   %ecx,%ecx
  800940:	75 0b                	jne    80094d <strlcpy+0x23>
  800942:	eb 17                	jmp    80095b <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800944:	83 c2 01             	add    $0x1,%edx
  800947:	83 c0 01             	add    $0x1,%eax
  80094a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80094d:	39 d8                	cmp    %ebx,%eax
  80094f:	74 07                	je     800958 <strlcpy+0x2e>
  800951:	0f b6 0a             	movzbl (%edx),%ecx
  800954:	84 c9                	test   %cl,%cl
  800956:	75 ec                	jne    800944 <strlcpy+0x1a>
		*dst = '\0';
  800958:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80095b:	29 f0                	sub    %esi,%eax
}
  80095d:	5b                   	pop    %ebx
  80095e:	5e                   	pop    %esi
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    

00800961 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800967:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80096a:	eb 06                	jmp    800972 <strcmp+0x11>
		p++, q++;
  80096c:	83 c1 01             	add    $0x1,%ecx
  80096f:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800972:	0f b6 01             	movzbl (%ecx),%eax
  800975:	84 c0                	test   %al,%al
  800977:	74 04                	je     80097d <strcmp+0x1c>
  800979:	3a 02                	cmp    (%edx),%al
  80097b:	74 ef                	je     80096c <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80097d:	0f b6 c0             	movzbl %al,%eax
  800980:	0f b6 12             	movzbl (%edx),%edx
  800983:	29 d0                	sub    %edx,%eax
}
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	53                   	push   %ebx
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800991:	89 c3                	mov    %eax,%ebx
  800993:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800996:	eb 06                	jmp    80099e <strncmp+0x17>
		n--, p++, q++;
  800998:	83 c0 01             	add    $0x1,%eax
  80099b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80099e:	39 d8                	cmp    %ebx,%eax
  8009a0:	74 16                	je     8009b8 <strncmp+0x31>
  8009a2:	0f b6 08             	movzbl (%eax),%ecx
  8009a5:	84 c9                	test   %cl,%cl
  8009a7:	74 04                	je     8009ad <strncmp+0x26>
  8009a9:	3a 0a                	cmp    (%edx),%cl
  8009ab:	74 eb                	je     800998 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ad:	0f b6 00             	movzbl (%eax),%eax
  8009b0:	0f b6 12             	movzbl (%edx),%edx
  8009b3:	29 d0                	sub    %edx,%eax
}
  8009b5:	5b                   	pop    %ebx
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    
		return 0;
  8009b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bd:	eb f6                	jmp    8009b5 <strncmp+0x2e>

008009bf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c9:	0f b6 10             	movzbl (%eax),%edx
  8009cc:	84 d2                	test   %dl,%dl
  8009ce:	74 09                	je     8009d9 <strchr+0x1a>
		if (*s == c)
  8009d0:	38 ca                	cmp    %cl,%dl
  8009d2:	74 0a                	je     8009de <strchr+0x1f>
	for (; *s; s++)
  8009d4:	83 c0 01             	add    $0x1,%eax
  8009d7:	eb f0                	jmp    8009c9 <strchr+0xa>
			return (char *) s;
	return 0;
  8009d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009de:	5d                   	pop    %ebp
  8009df:	c3                   	ret    

008009e0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ea:	eb 03                	jmp    8009ef <strfind+0xf>
  8009ec:	83 c0 01             	add    $0x1,%eax
  8009ef:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009f2:	38 ca                	cmp    %cl,%dl
  8009f4:	74 04                	je     8009fa <strfind+0x1a>
  8009f6:	84 d2                	test   %dl,%dl
  8009f8:	75 f2                	jne    8009ec <strfind+0xc>
			break;
	return (char *) s;
}
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	57                   	push   %edi
  800a00:	56                   	push   %esi
  800a01:	53                   	push   %ebx
  800a02:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a05:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a08:	85 c9                	test   %ecx,%ecx
  800a0a:	74 13                	je     800a1f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a0c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a12:	75 05                	jne    800a19 <memset+0x1d>
  800a14:	f6 c1 03             	test   $0x3,%cl
  800a17:	74 0d                	je     800a26 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1c:	fc                   	cld    
  800a1d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a1f:	89 f8                	mov    %edi,%eax
  800a21:	5b                   	pop    %ebx
  800a22:	5e                   	pop    %esi
  800a23:	5f                   	pop    %edi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    
		c &= 0xFF;
  800a26:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a2a:	89 d3                	mov    %edx,%ebx
  800a2c:	c1 e3 08             	shl    $0x8,%ebx
  800a2f:	89 d0                	mov    %edx,%eax
  800a31:	c1 e0 18             	shl    $0x18,%eax
  800a34:	89 d6                	mov    %edx,%esi
  800a36:	c1 e6 10             	shl    $0x10,%esi
  800a39:	09 f0                	or     %esi,%eax
  800a3b:	09 c2                	or     %eax,%edx
  800a3d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a3f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a42:	89 d0                	mov    %edx,%eax
  800a44:	fc                   	cld    
  800a45:	f3 ab                	rep stos %eax,%es:(%edi)
  800a47:	eb d6                	jmp    800a1f <memset+0x23>

00800a49 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	57                   	push   %edi
  800a4d:	56                   	push   %esi
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a54:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a57:	39 c6                	cmp    %eax,%esi
  800a59:	73 35                	jae    800a90 <memmove+0x47>
  800a5b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a5e:	39 c2                	cmp    %eax,%edx
  800a60:	76 2e                	jbe    800a90 <memmove+0x47>
		s += n;
		d += n;
  800a62:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a65:	89 d6                	mov    %edx,%esi
  800a67:	09 fe                	or     %edi,%esi
  800a69:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a6f:	74 0c                	je     800a7d <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a71:	83 ef 01             	sub    $0x1,%edi
  800a74:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a77:	fd                   	std    
  800a78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a7a:	fc                   	cld    
  800a7b:	eb 21                	jmp    800a9e <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7d:	f6 c1 03             	test   $0x3,%cl
  800a80:	75 ef                	jne    800a71 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a82:	83 ef 04             	sub    $0x4,%edi
  800a85:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a88:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a8b:	fd                   	std    
  800a8c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a8e:	eb ea                	jmp    800a7a <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a90:	89 f2                	mov    %esi,%edx
  800a92:	09 c2                	or     %eax,%edx
  800a94:	f6 c2 03             	test   $0x3,%dl
  800a97:	74 09                	je     800aa2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a99:	89 c7                	mov    %eax,%edi
  800a9b:	fc                   	cld    
  800a9c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a9e:	5e                   	pop    %esi
  800a9f:	5f                   	pop    %edi
  800aa0:	5d                   	pop    %ebp
  800aa1:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa2:	f6 c1 03             	test   $0x3,%cl
  800aa5:	75 f2                	jne    800a99 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aa7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aaa:	89 c7                	mov    %eax,%edi
  800aac:	fc                   	cld    
  800aad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aaf:	eb ed                	jmp    800a9e <memmove+0x55>

00800ab1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ab4:	ff 75 10             	pushl  0x10(%ebp)
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	ff 75 08             	pushl  0x8(%ebp)
  800abd:	e8 87 ff ff ff       	call   800a49 <memmove>
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	56                   	push   %esi
  800ac8:	53                   	push   %ebx
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acf:	89 c6                	mov    %eax,%esi
  800ad1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad4:	39 f0                	cmp    %esi,%eax
  800ad6:	74 1c                	je     800af4 <memcmp+0x30>
		if (*s1 != *s2)
  800ad8:	0f b6 08             	movzbl (%eax),%ecx
  800adb:	0f b6 1a             	movzbl (%edx),%ebx
  800ade:	38 d9                	cmp    %bl,%cl
  800ae0:	75 08                	jne    800aea <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae2:	83 c0 01             	add    $0x1,%eax
  800ae5:	83 c2 01             	add    $0x1,%edx
  800ae8:	eb ea                	jmp    800ad4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aea:	0f b6 c1             	movzbl %cl,%eax
  800aed:	0f b6 db             	movzbl %bl,%ebx
  800af0:	29 d8                	sub    %ebx,%eax
  800af2:	eb 05                	jmp    800af9 <memcmp+0x35>
	}

	return 0;
  800af4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af9:	5b                   	pop    %ebx
  800afa:	5e                   	pop    %esi
  800afb:	5d                   	pop    %ebp
  800afc:	c3                   	ret    

00800afd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b0b:	39 d0                	cmp    %edx,%eax
  800b0d:	73 09                	jae    800b18 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b0f:	38 08                	cmp    %cl,(%eax)
  800b11:	74 05                	je     800b18 <memfind+0x1b>
	for (; s < ends; s++)
  800b13:	83 c0 01             	add    $0x1,%eax
  800b16:	eb f3                	jmp    800b0b <memfind+0xe>
			break;
	return (void *) s;
}
  800b18:	5d                   	pop    %ebp
  800b19:	c3                   	ret    

00800b1a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	57                   	push   %edi
  800b1e:	56                   	push   %esi
  800b1f:	53                   	push   %ebx
  800b20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b26:	eb 03                	jmp    800b2b <strtol+0x11>
		s++;
  800b28:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b2b:	0f b6 01             	movzbl (%ecx),%eax
  800b2e:	3c 20                	cmp    $0x20,%al
  800b30:	74 f6                	je     800b28 <strtol+0xe>
  800b32:	3c 09                	cmp    $0x9,%al
  800b34:	74 f2                	je     800b28 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b36:	3c 2b                	cmp    $0x2b,%al
  800b38:	74 2e                	je     800b68 <strtol+0x4e>
	int neg = 0;
  800b3a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b3f:	3c 2d                	cmp    $0x2d,%al
  800b41:	74 2f                	je     800b72 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b43:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b49:	75 05                	jne    800b50 <strtol+0x36>
  800b4b:	80 39 30             	cmpb   $0x30,(%ecx)
  800b4e:	74 2c                	je     800b7c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b50:	85 db                	test   %ebx,%ebx
  800b52:	75 0a                	jne    800b5e <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b54:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b59:	80 39 30             	cmpb   $0x30,(%ecx)
  800b5c:	74 28                	je     800b86 <strtol+0x6c>
		base = 10;
  800b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b63:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b66:	eb 50                	jmp    800bb8 <strtol+0x9e>
		s++;
  800b68:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b6b:	bf 00 00 00 00       	mov    $0x0,%edi
  800b70:	eb d1                	jmp    800b43 <strtol+0x29>
		s++, neg = 1;
  800b72:	83 c1 01             	add    $0x1,%ecx
  800b75:	bf 01 00 00 00       	mov    $0x1,%edi
  800b7a:	eb c7                	jmp    800b43 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b7c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b80:	74 0e                	je     800b90 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b82:	85 db                	test   %ebx,%ebx
  800b84:	75 d8                	jne    800b5e <strtol+0x44>
		s++, base = 8;
  800b86:	83 c1 01             	add    $0x1,%ecx
  800b89:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b8e:	eb ce                	jmp    800b5e <strtol+0x44>
		s += 2, base = 16;
  800b90:	83 c1 02             	add    $0x2,%ecx
  800b93:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b98:	eb c4                	jmp    800b5e <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b9a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b9d:	89 f3                	mov    %esi,%ebx
  800b9f:	80 fb 19             	cmp    $0x19,%bl
  800ba2:	77 29                	ja     800bcd <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ba4:	0f be d2             	movsbl %dl,%edx
  800ba7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800baa:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bad:	7d 30                	jge    800bdf <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800baf:	83 c1 01             	add    $0x1,%ecx
  800bb2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bb6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bb8:	0f b6 11             	movzbl (%ecx),%edx
  800bbb:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bbe:	89 f3                	mov    %esi,%ebx
  800bc0:	80 fb 09             	cmp    $0x9,%bl
  800bc3:	77 d5                	ja     800b9a <strtol+0x80>
			dig = *s - '0';
  800bc5:	0f be d2             	movsbl %dl,%edx
  800bc8:	83 ea 30             	sub    $0x30,%edx
  800bcb:	eb dd                	jmp    800baa <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800bcd:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bd0:	89 f3                	mov    %esi,%ebx
  800bd2:	80 fb 19             	cmp    $0x19,%bl
  800bd5:	77 08                	ja     800bdf <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bd7:	0f be d2             	movsbl %dl,%edx
  800bda:	83 ea 37             	sub    $0x37,%edx
  800bdd:	eb cb                	jmp    800baa <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be3:	74 05                	je     800bea <strtol+0xd0>
		*endptr = (char *) s;
  800be5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bea:	89 c2                	mov    %eax,%edx
  800bec:	f7 da                	neg    %edx
  800bee:	85 ff                	test   %edi,%edi
  800bf0:	0f 45 c2             	cmovne %edx,%eax
}
  800bf3:	5b                   	pop    %ebx
  800bf4:	5e                   	pop    %esi
  800bf5:	5f                   	pop    %edi
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	57                   	push   %edi
  800bfc:	56                   	push   %esi
  800bfd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  800c03:	8b 55 08             	mov    0x8(%ebp),%edx
  800c06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c09:	89 c3                	mov    %eax,%ebx
  800c0b:	89 c7                	mov    %eax,%edi
  800c0d:	89 c6                	mov    %eax,%esi
  800c0f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c11:	5b                   	pop    %ebx
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c21:	b8 01 00 00 00       	mov    $0x1,%eax
  800c26:	89 d1                	mov    %edx,%ecx
  800c28:	89 d3                	mov    %edx,%ebx
  800c2a:	89 d7                	mov    %edx,%edi
  800c2c:	89 d6                	mov    %edx,%esi
  800c2e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	57                   	push   %edi
  800c39:	56                   	push   %esi
  800c3a:	53                   	push   %ebx
  800c3b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c43:	8b 55 08             	mov    0x8(%ebp),%edx
  800c46:	b8 03 00 00 00       	mov    $0x3,%eax
  800c4b:	89 cb                	mov    %ecx,%ebx
  800c4d:	89 cf                	mov    %ecx,%edi
  800c4f:	89 ce                	mov    %ecx,%esi
  800c51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c53:	85 c0                	test   %eax,%eax
  800c55:	7f 08                	jg     800c5f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5f                   	pop    %edi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5f:	83 ec 0c             	sub    $0xc,%esp
  800c62:	50                   	push   %eax
  800c63:	6a 03                	push   $0x3
  800c65:	68 5f 2b 80 00       	push   $0x802b5f
  800c6a:	6a 23                	push   $0x23
  800c6c:	68 7c 2b 80 00       	push   $0x802b7c
  800c71:	e8 80 f5 ff ff       	call   8001f6 <_panic>

00800c76 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	57                   	push   %edi
  800c7a:	56                   	push   %esi
  800c7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c7c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c81:	b8 02 00 00 00       	mov    $0x2,%eax
  800c86:	89 d1                	mov    %edx,%ecx
  800c88:	89 d3                	mov    %edx,%ebx
  800c8a:	89 d7                	mov    %edx,%edi
  800c8c:	89 d6                	mov    %edx,%esi
  800c8e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <sys_yield>:

void
sys_yield(void)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ca5:	89 d1                	mov    %edx,%ecx
  800ca7:	89 d3                	mov    %edx,%ebx
  800ca9:	89 d7                	mov    %edx,%edi
  800cab:	89 d6                	mov    %edx,%esi
  800cad:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
  800cba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbd:	be 00 00 00 00       	mov    $0x0,%esi
  800cc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc8:	b8 04 00 00 00       	mov    $0x4,%eax
  800ccd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd0:	89 f7                	mov    %esi,%edi
  800cd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd4:	85 c0                	test   %eax,%eax
  800cd6:	7f 08                	jg     800ce0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5f                   	pop    %edi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce0:	83 ec 0c             	sub    $0xc,%esp
  800ce3:	50                   	push   %eax
  800ce4:	6a 04                	push   $0x4
  800ce6:	68 5f 2b 80 00       	push   $0x802b5f
  800ceb:	6a 23                	push   $0x23
  800ced:	68 7c 2b 80 00       	push   $0x802b7c
  800cf2:	e8 ff f4 ff ff       	call   8001f6 <_panic>

00800cf7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
  800cfd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d06:	b8 05 00 00 00       	mov    $0x5,%eax
  800d0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d11:	8b 75 18             	mov    0x18(%ebp),%esi
  800d14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d16:	85 c0                	test   %eax,%eax
  800d18:	7f 08                	jg     800d22 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5f                   	pop    %edi
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d22:	83 ec 0c             	sub    $0xc,%esp
  800d25:	50                   	push   %eax
  800d26:	6a 05                	push   $0x5
  800d28:	68 5f 2b 80 00       	push   $0x802b5f
  800d2d:	6a 23                	push   $0x23
  800d2f:	68 7c 2b 80 00       	push   $0x802b7c
  800d34:	e8 bd f4 ff ff       	call   8001f6 <_panic>

00800d39 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d42:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d47:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4d:	b8 06 00 00 00       	mov    $0x6,%eax
  800d52:	89 df                	mov    %ebx,%edi
  800d54:	89 de                	mov    %ebx,%esi
  800d56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d58:	85 c0                	test   %eax,%eax
  800d5a:	7f 08                	jg     800d64 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5f:	5b                   	pop    %ebx
  800d60:	5e                   	pop    %esi
  800d61:	5f                   	pop    %edi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d64:	83 ec 0c             	sub    $0xc,%esp
  800d67:	50                   	push   %eax
  800d68:	6a 06                	push   $0x6
  800d6a:	68 5f 2b 80 00       	push   $0x802b5f
  800d6f:	6a 23                	push   $0x23
  800d71:	68 7c 2b 80 00       	push   $0x802b7c
  800d76:	e8 7b f4 ff ff       	call   8001f6 <_panic>

00800d7b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	57                   	push   %edi
  800d7f:	56                   	push   %esi
  800d80:	53                   	push   %ebx
  800d81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d89:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8f:	b8 08 00 00 00       	mov    $0x8,%eax
  800d94:	89 df                	mov    %ebx,%edi
  800d96:	89 de                	mov    %ebx,%esi
  800d98:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9a:	85 c0                	test   %eax,%eax
  800d9c:	7f 08                	jg     800da6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da1:	5b                   	pop    %ebx
  800da2:	5e                   	pop    %esi
  800da3:	5f                   	pop    %edi
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da6:	83 ec 0c             	sub    $0xc,%esp
  800da9:	50                   	push   %eax
  800daa:	6a 08                	push   $0x8
  800dac:	68 5f 2b 80 00       	push   $0x802b5f
  800db1:	6a 23                	push   $0x23
  800db3:	68 7c 2b 80 00       	push   $0x802b7c
  800db8:	e8 39 f4 ff ff       	call   8001f6 <_panic>

00800dbd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	57                   	push   %edi
  800dc1:	56                   	push   %esi
  800dc2:	53                   	push   %ebx
  800dc3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd1:	b8 09 00 00 00       	mov    $0x9,%eax
  800dd6:	89 df                	mov    %ebx,%edi
  800dd8:	89 de                	mov    %ebx,%esi
  800dda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	7f 08                	jg     800de8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de3:	5b                   	pop    %ebx
  800de4:	5e                   	pop    %esi
  800de5:	5f                   	pop    %edi
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de8:	83 ec 0c             	sub    $0xc,%esp
  800deb:	50                   	push   %eax
  800dec:	6a 09                	push   $0x9
  800dee:	68 5f 2b 80 00       	push   $0x802b5f
  800df3:	6a 23                	push   $0x23
  800df5:	68 7c 2b 80 00       	push   $0x802b7c
  800dfa:	e8 f7 f3 ff ff       	call   8001f6 <_panic>

00800dff <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	57                   	push   %edi
  800e03:	56                   	push   %esi
  800e04:	53                   	push   %ebx
  800e05:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e08:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e13:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e18:	89 df                	mov    %ebx,%edi
  800e1a:	89 de                	mov    %ebx,%esi
  800e1c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1e:	85 c0                	test   %eax,%eax
  800e20:	7f 08                	jg     800e2a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2a:	83 ec 0c             	sub    $0xc,%esp
  800e2d:	50                   	push   %eax
  800e2e:	6a 0a                	push   $0xa
  800e30:	68 5f 2b 80 00       	push   $0x802b5f
  800e35:	6a 23                	push   $0x23
  800e37:	68 7c 2b 80 00       	push   $0x802b7c
  800e3c:	e8 b5 f3 ff ff       	call   8001f6 <_panic>

00800e41 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	57                   	push   %edi
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e47:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e52:	be 00 00 00 00       	mov    $0x0,%esi
  800e57:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
  800e6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e72:	8b 55 08             	mov    0x8(%ebp),%edx
  800e75:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e7a:	89 cb                	mov    %ecx,%ebx
  800e7c:	89 cf                	mov    %ecx,%edi
  800e7e:	89 ce                	mov    %ecx,%esi
  800e80:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	7f 08                	jg     800e8e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e89:	5b                   	pop    %ebx
  800e8a:	5e                   	pop    %esi
  800e8b:	5f                   	pop    %edi
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8e:	83 ec 0c             	sub    $0xc,%esp
  800e91:	50                   	push   %eax
  800e92:	6a 0d                	push   $0xd
  800e94:	68 5f 2b 80 00       	push   $0x802b5f
  800e99:	6a 23                	push   $0x23
  800e9b:	68 7c 2b 80 00       	push   $0x802b7c
  800ea0:	e8 51 f3 ff ff       	call   8001f6 <_panic>

00800ea5 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800eab:	68 8a 2b 80 00       	push   $0x802b8a
  800eb0:	6a 25                	push   $0x25
  800eb2:	68 a2 2b 80 00       	push   $0x802ba2
  800eb7:	e8 3a f3 ff ff       	call   8001f6 <_panic>

00800ebc <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
  800ec2:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  800ec5:	68 a5 0e 80 00       	push   $0x800ea5
  800eca:	e8 2f 15 00 00       	call   8023fe <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800ecf:	b8 07 00 00 00       	mov    $0x7,%eax
  800ed4:	cd 30                	int    $0x30
  800ed6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ed9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  800edc:	83 c4 10             	add    $0x10,%esp
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	78 27                	js     800f0a <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800ee3:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  800ee8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800eec:	75 65                	jne    800f53 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800eee:	e8 83 fd ff ff       	call   800c76 <sys_getenvid>
  800ef3:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ef8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800efb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f00:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f05:	e9 11 01 00 00       	jmp    80101b <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  800f0a:	50                   	push   %eax
  800f0b:	68 b3 27 80 00       	push   $0x8027b3
  800f10:	6a 6f                	push   $0x6f
  800f12:	68 a2 2b 80 00       	push   $0x802ba2
  800f17:	e8 da f2 ff ff       	call   8001f6 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  800f1c:	e8 55 fd ff ff       	call   800c76 <sys_getenvid>
  800f21:	83 ec 0c             	sub    $0xc,%esp
  800f24:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800f2a:	56                   	push   %esi
  800f2b:	57                   	push   %edi
  800f2c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f2f:	57                   	push   %edi
  800f30:	50                   	push   %eax
  800f31:	e8 c1 fd ff ff       	call   800cf7 <sys_page_map>
  800f36:	83 c4 20             	add    $0x20,%esp
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	0f 88 84 00 00 00    	js     800fc5 <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800f41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800f47:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800f4d:	0f 84 84 00 00 00    	je     800fd7 <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  800f53:	89 d8                	mov    %ebx,%eax
  800f55:	c1 e8 16             	shr    $0x16,%eax
  800f58:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f5f:	a8 01                	test   $0x1,%al
  800f61:	74 de                	je     800f41 <fork+0x85>
  800f63:	89 d8                	mov    %ebx,%eax
  800f65:	c1 e8 0c             	shr    $0xc,%eax
  800f68:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f6f:	f6 c2 01             	test   $0x1,%dl
  800f72:	74 cd                	je     800f41 <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  800f74:	89 c7                	mov    %eax,%edi
  800f76:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  800f79:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  800f80:	f7 c6 00 04 00 00    	test   $0x400,%esi
  800f86:	75 94                	jne    800f1c <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  800f88:	f7 c6 02 08 00 00    	test   $0x802,%esi
  800f8e:	0f 85 d1 00 00 00    	jne    801065 <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800f94:	a1 04 40 80 00       	mov    0x804004,%eax
  800f99:	8b 40 48             	mov    0x48(%eax),%eax
  800f9c:	83 ec 0c             	sub    $0xc,%esp
  800f9f:	6a 05                	push   $0x5
  800fa1:	57                   	push   %edi
  800fa2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fa5:	57                   	push   %edi
  800fa6:	50                   	push   %eax
  800fa7:	e8 4b fd ff ff       	call   800cf7 <sys_page_map>
  800fac:	83 c4 20             	add    $0x20,%esp
  800faf:	85 c0                	test   %eax,%eax
  800fb1:	79 8e                	jns    800f41 <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  800fb3:	50                   	push   %eax
  800fb4:	68 fc 2b 80 00       	push   $0x802bfc
  800fb9:	6a 4a                	push   $0x4a
  800fbb:	68 a2 2b 80 00       	push   $0x802ba2
  800fc0:	e8 31 f2 ff ff       	call   8001f6 <_panic>
                        panic("duppage: page mapping failed %e", r);
  800fc5:	50                   	push   %eax
  800fc6:	68 dc 2b 80 00       	push   $0x802bdc
  800fcb:	6a 41                	push   $0x41
  800fcd:	68 a2 2b 80 00       	push   $0x802ba2
  800fd2:	e8 1f f2 ff ff       	call   8001f6 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  800fd7:	83 ec 04             	sub    $0x4,%esp
  800fda:	6a 07                	push   $0x7
  800fdc:	68 00 f0 bf ee       	push   $0xeebff000
  800fe1:	ff 75 e0             	pushl  -0x20(%ebp)
  800fe4:	e8 cb fc ff ff       	call   800cb4 <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  800fe9:	83 c4 10             	add    $0x10,%esp
  800fec:	85 c0                	test   %eax,%eax
  800fee:	78 36                	js     801026 <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	68 72 24 80 00       	push   $0x802472
  800ff8:	ff 75 e0             	pushl  -0x20(%ebp)
  800ffb:	e8 ff fd ff ff       	call   800dff <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  801000:	83 c4 10             	add    $0x10,%esp
  801003:	85 c0                	test   %eax,%eax
  801005:	78 34                	js     80103b <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	6a 02                	push   $0x2
  80100c:	ff 75 e0             	pushl  -0x20(%ebp)
  80100f:	e8 67 fd ff ff       	call   800d7b <sys_env_set_status>
  801014:	83 c4 10             	add    $0x10,%esp
  801017:	85 c0                	test   %eax,%eax
  801019:	78 35                	js     801050 <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  80101b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80101e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  801026:	50                   	push   %eax
  801027:	68 b3 27 80 00       	push   $0x8027b3
  80102c:	68 82 00 00 00       	push   $0x82
  801031:	68 a2 2b 80 00       	push   $0x802ba2
  801036:	e8 bb f1 ff ff       	call   8001f6 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  80103b:	50                   	push   %eax
  80103c:	68 20 2c 80 00       	push   $0x802c20
  801041:	68 87 00 00 00       	push   $0x87
  801046:	68 a2 2b 80 00       	push   $0x802ba2
  80104b:	e8 a6 f1 ff ff       	call   8001f6 <_panic>
        	panic("sys_env_set_status: %e", r);
  801050:	50                   	push   %eax
  801051:	68 ad 2b 80 00       	push   $0x802bad
  801056:	68 8b 00 00 00       	push   $0x8b
  80105b:	68 a2 2b 80 00       	push   $0x802ba2
  801060:	e8 91 f1 ff ff       	call   8001f6 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  801065:	a1 04 40 80 00       	mov    0x804004,%eax
  80106a:	8b 40 48             	mov    0x48(%eax),%eax
  80106d:	83 ec 0c             	sub    $0xc,%esp
  801070:	68 05 08 00 00       	push   $0x805
  801075:	57                   	push   %edi
  801076:	ff 75 e4             	pushl  -0x1c(%ebp)
  801079:	57                   	push   %edi
  80107a:	50                   	push   %eax
  80107b:	e8 77 fc ff ff       	call   800cf7 <sys_page_map>
  801080:	83 c4 20             	add    $0x20,%esp
  801083:	85 c0                	test   %eax,%eax
  801085:	0f 88 28 ff ff ff    	js     800fb3 <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  80108b:	a1 04 40 80 00       	mov    0x804004,%eax
  801090:	8b 50 48             	mov    0x48(%eax),%edx
  801093:	8b 40 48             	mov    0x48(%eax),%eax
  801096:	83 ec 0c             	sub    $0xc,%esp
  801099:	68 05 08 00 00       	push   $0x805
  80109e:	57                   	push   %edi
  80109f:	52                   	push   %edx
  8010a0:	57                   	push   %edi
  8010a1:	50                   	push   %eax
  8010a2:	e8 50 fc ff ff       	call   800cf7 <sys_page_map>
  8010a7:	83 c4 20             	add    $0x20,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	0f 89 8f fe ff ff    	jns    800f41 <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  8010b2:	50                   	push   %eax
  8010b3:	68 fc 2b 80 00       	push   $0x802bfc
  8010b8:	6a 4f                	push   $0x4f
  8010ba:	68 a2 2b 80 00       	push   $0x802ba2
  8010bf:	e8 32 f1 ff ff       	call   8001f6 <_panic>

008010c4 <sfork>:

// Challenge!
int
sfork(void)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010ca:	68 c4 2b 80 00       	push   $0x802bc4
  8010cf:	68 94 00 00 00       	push   $0x94
  8010d4:	68 a2 2b 80 00       	push   $0x802ba2
  8010d9:	e8 18 f1 ff ff       	call   8001f6 <_panic>

008010de <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	05 00 00 00 30       	add    $0x30000000,%eax
  8010e9:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ec:	5d                   	pop    %ebp
  8010ed:	c3                   	ret    

008010ee <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010fe:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    

00801105 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80110b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801110:	89 c2                	mov    %eax,%edx
  801112:	c1 ea 16             	shr    $0x16,%edx
  801115:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80111c:	f6 c2 01             	test   $0x1,%dl
  80111f:	74 2a                	je     80114b <fd_alloc+0x46>
  801121:	89 c2                	mov    %eax,%edx
  801123:	c1 ea 0c             	shr    $0xc,%edx
  801126:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80112d:	f6 c2 01             	test   $0x1,%dl
  801130:	74 19                	je     80114b <fd_alloc+0x46>
  801132:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801137:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80113c:	75 d2                	jne    801110 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80113e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801144:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801149:	eb 07                	jmp    801152 <fd_alloc+0x4d>
			*fd_store = fd;
  80114b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80114d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801152:	5d                   	pop    %ebp
  801153:	c3                   	ret    

00801154 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80115a:	83 f8 1f             	cmp    $0x1f,%eax
  80115d:	77 36                	ja     801195 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80115f:	c1 e0 0c             	shl    $0xc,%eax
  801162:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801167:	89 c2                	mov    %eax,%edx
  801169:	c1 ea 16             	shr    $0x16,%edx
  80116c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801173:	f6 c2 01             	test   $0x1,%dl
  801176:	74 24                	je     80119c <fd_lookup+0x48>
  801178:	89 c2                	mov    %eax,%edx
  80117a:	c1 ea 0c             	shr    $0xc,%edx
  80117d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801184:	f6 c2 01             	test   $0x1,%dl
  801187:	74 1a                	je     8011a3 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801189:	8b 55 0c             	mov    0xc(%ebp),%edx
  80118c:	89 02                	mov    %eax,(%edx)
	return 0;
  80118e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    
		return -E_INVAL;
  801195:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80119a:	eb f7                	jmp    801193 <fd_lookup+0x3f>
		return -E_INVAL;
  80119c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a1:	eb f0                	jmp    801193 <fd_lookup+0x3f>
  8011a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a8:	eb e9                	jmp    801193 <fd_lookup+0x3f>

008011aa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	83 ec 08             	sub    $0x8,%esp
  8011b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b3:	ba c0 2c 80 00       	mov    $0x802cc0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8011b8:	b8 0c 30 80 00       	mov    $0x80300c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011bd:	39 08                	cmp    %ecx,(%eax)
  8011bf:	74 33                	je     8011f4 <dev_lookup+0x4a>
  8011c1:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8011c4:	8b 02                	mov    (%edx),%eax
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	75 f3                	jne    8011bd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011ca:	a1 04 40 80 00       	mov    0x804004,%eax
  8011cf:	8b 40 48             	mov    0x48(%eax),%eax
  8011d2:	83 ec 04             	sub    $0x4,%esp
  8011d5:	51                   	push   %ecx
  8011d6:	50                   	push   %eax
  8011d7:	68 44 2c 80 00       	push   $0x802c44
  8011dc:	e8 f0 f0 ff ff       	call   8002d1 <cprintf>
	*dev = 0;
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011ea:	83 c4 10             	add    $0x10,%esp
  8011ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    
			*dev = devtab[i];
  8011f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fe:	eb f2                	jmp    8011f2 <dev_lookup+0x48>

00801200 <fd_close>:
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	57                   	push   %edi
  801204:	56                   	push   %esi
  801205:	53                   	push   %ebx
  801206:	83 ec 1c             	sub    $0x1c,%esp
  801209:	8b 75 08             	mov    0x8(%ebp),%esi
  80120c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80120f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801212:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801213:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801219:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80121c:	50                   	push   %eax
  80121d:	e8 32 ff ff ff       	call   801154 <fd_lookup>
  801222:	89 c3                	mov    %eax,%ebx
  801224:	83 c4 08             	add    $0x8,%esp
  801227:	85 c0                	test   %eax,%eax
  801229:	78 05                	js     801230 <fd_close+0x30>
	    || fd != fd2)
  80122b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80122e:	74 16                	je     801246 <fd_close+0x46>
		return (must_exist ? r : 0);
  801230:	89 f8                	mov    %edi,%eax
  801232:	84 c0                	test   %al,%al
  801234:	b8 00 00 00 00       	mov    $0x0,%eax
  801239:	0f 44 d8             	cmove  %eax,%ebx
}
  80123c:	89 d8                	mov    %ebx,%eax
  80123e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801241:	5b                   	pop    %ebx
  801242:	5e                   	pop    %esi
  801243:	5f                   	pop    %edi
  801244:	5d                   	pop    %ebp
  801245:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801246:	83 ec 08             	sub    $0x8,%esp
  801249:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80124c:	50                   	push   %eax
  80124d:	ff 36                	pushl  (%esi)
  80124f:	e8 56 ff ff ff       	call   8011aa <dev_lookup>
  801254:	89 c3                	mov    %eax,%ebx
  801256:	83 c4 10             	add    $0x10,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	78 15                	js     801272 <fd_close+0x72>
		if (dev->dev_close)
  80125d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801260:	8b 40 10             	mov    0x10(%eax),%eax
  801263:	85 c0                	test   %eax,%eax
  801265:	74 1b                	je     801282 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801267:	83 ec 0c             	sub    $0xc,%esp
  80126a:	56                   	push   %esi
  80126b:	ff d0                	call   *%eax
  80126d:	89 c3                	mov    %eax,%ebx
  80126f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801272:	83 ec 08             	sub    $0x8,%esp
  801275:	56                   	push   %esi
  801276:	6a 00                	push   $0x0
  801278:	e8 bc fa ff ff       	call   800d39 <sys_page_unmap>
	return r;
  80127d:	83 c4 10             	add    $0x10,%esp
  801280:	eb ba                	jmp    80123c <fd_close+0x3c>
			r = 0;
  801282:	bb 00 00 00 00       	mov    $0x0,%ebx
  801287:	eb e9                	jmp    801272 <fd_close+0x72>

00801289 <close>:

int
close(int fdnum)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80128f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801292:	50                   	push   %eax
  801293:	ff 75 08             	pushl  0x8(%ebp)
  801296:	e8 b9 fe ff ff       	call   801154 <fd_lookup>
  80129b:	83 c4 08             	add    $0x8,%esp
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	78 10                	js     8012b2 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8012a2:	83 ec 08             	sub    $0x8,%esp
  8012a5:	6a 01                	push   $0x1
  8012a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012aa:	e8 51 ff ff ff       	call   801200 <fd_close>
  8012af:	83 c4 10             	add    $0x10,%esp
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <close_all>:

void
close_all(void)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	53                   	push   %ebx
  8012b8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012bb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012c0:	83 ec 0c             	sub    $0xc,%esp
  8012c3:	53                   	push   %ebx
  8012c4:	e8 c0 ff ff ff       	call   801289 <close>
	for (i = 0; i < MAXFD; i++)
  8012c9:	83 c3 01             	add    $0x1,%ebx
  8012cc:	83 c4 10             	add    $0x10,%esp
  8012cf:	83 fb 20             	cmp    $0x20,%ebx
  8012d2:	75 ec                	jne    8012c0 <close_all+0xc>
}
  8012d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    

008012d9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	57                   	push   %edi
  8012dd:	56                   	push   %esi
  8012de:	53                   	push   %ebx
  8012df:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012e5:	50                   	push   %eax
  8012e6:	ff 75 08             	pushl  0x8(%ebp)
  8012e9:	e8 66 fe ff ff       	call   801154 <fd_lookup>
  8012ee:	89 c3                	mov    %eax,%ebx
  8012f0:	83 c4 08             	add    $0x8,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	0f 88 81 00 00 00    	js     80137c <dup+0xa3>
		return r;
	close(newfdnum);
  8012fb:	83 ec 0c             	sub    $0xc,%esp
  8012fe:	ff 75 0c             	pushl  0xc(%ebp)
  801301:	e8 83 ff ff ff       	call   801289 <close>

	newfd = INDEX2FD(newfdnum);
  801306:	8b 75 0c             	mov    0xc(%ebp),%esi
  801309:	c1 e6 0c             	shl    $0xc,%esi
  80130c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801312:	83 c4 04             	add    $0x4,%esp
  801315:	ff 75 e4             	pushl  -0x1c(%ebp)
  801318:	e8 d1 fd ff ff       	call   8010ee <fd2data>
  80131d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80131f:	89 34 24             	mov    %esi,(%esp)
  801322:	e8 c7 fd ff ff       	call   8010ee <fd2data>
  801327:	83 c4 10             	add    $0x10,%esp
  80132a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80132c:	89 d8                	mov    %ebx,%eax
  80132e:	c1 e8 16             	shr    $0x16,%eax
  801331:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801338:	a8 01                	test   $0x1,%al
  80133a:	74 11                	je     80134d <dup+0x74>
  80133c:	89 d8                	mov    %ebx,%eax
  80133e:	c1 e8 0c             	shr    $0xc,%eax
  801341:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801348:	f6 c2 01             	test   $0x1,%dl
  80134b:	75 39                	jne    801386 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80134d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801350:	89 d0                	mov    %edx,%eax
  801352:	c1 e8 0c             	shr    $0xc,%eax
  801355:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80135c:	83 ec 0c             	sub    $0xc,%esp
  80135f:	25 07 0e 00 00       	and    $0xe07,%eax
  801364:	50                   	push   %eax
  801365:	56                   	push   %esi
  801366:	6a 00                	push   $0x0
  801368:	52                   	push   %edx
  801369:	6a 00                	push   $0x0
  80136b:	e8 87 f9 ff ff       	call   800cf7 <sys_page_map>
  801370:	89 c3                	mov    %eax,%ebx
  801372:	83 c4 20             	add    $0x20,%esp
  801375:	85 c0                	test   %eax,%eax
  801377:	78 31                	js     8013aa <dup+0xd1>
		goto err;

	return newfdnum;
  801379:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80137c:	89 d8                	mov    %ebx,%eax
  80137e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801381:	5b                   	pop    %ebx
  801382:	5e                   	pop    %esi
  801383:	5f                   	pop    %edi
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801386:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80138d:	83 ec 0c             	sub    $0xc,%esp
  801390:	25 07 0e 00 00       	and    $0xe07,%eax
  801395:	50                   	push   %eax
  801396:	57                   	push   %edi
  801397:	6a 00                	push   $0x0
  801399:	53                   	push   %ebx
  80139a:	6a 00                	push   $0x0
  80139c:	e8 56 f9 ff ff       	call   800cf7 <sys_page_map>
  8013a1:	89 c3                	mov    %eax,%ebx
  8013a3:	83 c4 20             	add    $0x20,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	79 a3                	jns    80134d <dup+0x74>
	sys_page_unmap(0, newfd);
  8013aa:	83 ec 08             	sub    $0x8,%esp
  8013ad:	56                   	push   %esi
  8013ae:	6a 00                	push   $0x0
  8013b0:	e8 84 f9 ff ff       	call   800d39 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013b5:	83 c4 08             	add    $0x8,%esp
  8013b8:	57                   	push   %edi
  8013b9:	6a 00                	push   $0x0
  8013bb:	e8 79 f9 ff ff       	call   800d39 <sys_page_unmap>
	return r;
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	eb b7                	jmp    80137c <dup+0xa3>

008013c5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	53                   	push   %ebx
  8013c9:	83 ec 14             	sub    $0x14,%esp
  8013cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d2:	50                   	push   %eax
  8013d3:	53                   	push   %ebx
  8013d4:	e8 7b fd ff ff       	call   801154 <fd_lookup>
  8013d9:	83 c4 08             	add    $0x8,%esp
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	78 3f                	js     80141f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e6:	50                   	push   %eax
  8013e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ea:	ff 30                	pushl  (%eax)
  8013ec:	e8 b9 fd ff ff       	call   8011aa <dev_lookup>
  8013f1:	83 c4 10             	add    $0x10,%esp
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	78 27                	js     80141f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013fb:	8b 42 08             	mov    0x8(%edx),%eax
  8013fe:	83 e0 03             	and    $0x3,%eax
  801401:	83 f8 01             	cmp    $0x1,%eax
  801404:	74 1e                	je     801424 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801409:	8b 40 08             	mov    0x8(%eax),%eax
  80140c:	85 c0                	test   %eax,%eax
  80140e:	74 35                	je     801445 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801410:	83 ec 04             	sub    $0x4,%esp
  801413:	ff 75 10             	pushl  0x10(%ebp)
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	52                   	push   %edx
  80141a:	ff d0                	call   *%eax
  80141c:	83 c4 10             	add    $0x10,%esp
}
  80141f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801422:	c9                   	leave  
  801423:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801424:	a1 04 40 80 00       	mov    0x804004,%eax
  801429:	8b 40 48             	mov    0x48(%eax),%eax
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	53                   	push   %ebx
  801430:	50                   	push   %eax
  801431:	68 85 2c 80 00       	push   $0x802c85
  801436:	e8 96 ee ff ff       	call   8002d1 <cprintf>
		return -E_INVAL;
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801443:	eb da                	jmp    80141f <read+0x5a>
		return -E_NOT_SUPP;
  801445:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80144a:	eb d3                	jmp    80141f <read+0x5a>

0080144c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	57                   	push   %edi
  801450:	56                   	push   %esi
  801451:	53                   	push   %ebx
  801452:	83 ec 0c             	sub    $0xc,%esp
  801455:	8b 7d 08             	mov    0x8(%ebp),%edi
  801458:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80145b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801460:	39 f3                	cmp    %esi,%ebx
  801462:	73 25                	jae    801489 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	89 f0                	mov    %esi,%eax
  801469:	29 d8                	sub    %ebx,%eax
  80146b:	50                   	push   %eax
  80146c:	89 d8                	mov    %ebx,%eax
  80146e:	03 45 0c             	add    0xc(%ebp),%eax
  801471:	50                   	push   %eax
  801472:	57                   	push   %edi
  801473:	e8 4d ff ff ff       	call   8013c5 <read>
		if (m < 0)
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 08                	js     801487 <readn+0x3b>
			return m;
		if (m == 0)
  80147f:	85 c0                	test   %eax,%eax
  801481:	74 06                	je     801489 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801483:	01 c3                	add    %eax,%ebx
  801485:	eb d9                	jmp    801460 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801487:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801489:	89 d8                	mov    %ebx,%eax
  80148b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80148e:	5b                   	pop    %ebx
  80148f:	5e                   	pop    %esi
  801490:	5f                   	pop    %edi
  801491:	5d                   	pop    %ebp
  801492:	c3                   	ret    

00801493 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	53                   	push   %ebx
  801497:	83 ec 14             	sub    $0x14,%esp
  80149a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a0:	50                   	push   %eax
  8014a1:	53                   	push   %ebx
  8014a2:	e8 ad fc ff ff       	call   801154 <fd_lookup>
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	78 3a                	js     8014e8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b4:	50                   	push   %eax
  8014b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b8:	ff 30                	pushl  (%eax)
  8014ba:	e8 eb fc ff ff       	call   8011aa <dev_lookup>
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	78 22                	js     8014e8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014cd:	74 1e                	je     8014ed <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d2:	8b 52 0c             	mov    0xc(%edx),%edx
  8014d5:	85 d2                	test   %edx,%edx
  8014d7:	74 35                	je     80150e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014d9:	83 ec 04             	sub    $0x4,%esp
  8014dc:	ff 75 10             	pushl  0x10(%ebp)
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	50                   	push   %eax
  8014e3:	ff d2                	call   *%edx
  8014e5:	83 c4 10             	add    $0x10,%esp
}
  8014e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014ed:	a1 04 40 80 00       	mov    0x804004,%eax
  8014f2:	8b 40 48             	mov    0x48(%eax),%eax
  8014f5:	83 ec 04             	sub    $0x4,%esp
  8014f8:	53                   	push   %ebx
  8014f9:	50                   	push   %eax
  8014fa:	68 a1 2c 80 00       	push   $0x802ca1
  8014ff:	e8 cd ed ff ff       	call   8002d1 <cprintf>
		return -E_INVAL;
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150c:	eb da                	jmp    8014e8 <write+0x55>
		return -E_NOT_SUPP;
  80150e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801513:	eb d3                	jmp    8014e8 <write+0x55>

00801515 <seek>:

int
seek(int fdnum, off_t offset)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80151b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80151e:	50                   	push   %eax
  80151f:	ff 75 08             	pushl  0x8(%ebp)
  801522:	e8 2d fc ff ff       	call   801154 <fd_lookup>
  801527:	83 c4 08             	add    $0x8,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 0e                	js     80153c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80152e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801534:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801537:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	53                   	push   %ebx
  801542:	83 ec 14             	sub    $0x14,%esp
  801545:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801548:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80154b:	50                   	push   %eax
  80154c:	53                   	push   %ebx
  80154d:	e8 02 fc ff ff       	call   801154 <fd_lookup>
  801552:	83 c4 08             	add    $0x8,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	78 37                	js     801590 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801559:	83 ec 08             	sub    $0x8,%esp
  80155c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155f:	50                   	push   %eax
  801560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801563:	ff 30                	pushl  (%eax)
  801565:	e8 40 fc ff ff       	call   8011aa <dev_lookup>
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	85 c0                	test   %eax,%eax
  80156f:	78 1f                	js     801590 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801574:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801578:	74 1b                	je     801595 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80157a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157d:	8b 52 18             	mov    0x18(%edx),%edx
  801580:	85 d2                	test   %edx,%edx
  801582:	74 32                	je     8015b6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801584:	83 ec 08             	sub    $0x8,%esp
  801587:	ff 75 0c             	pushl  0xc(%ebp)
  80158a:	50                   	push   %eax
  80158b:	ff d2                	call   *%edx
  80158d:	83 c4 10             	add    $0x10,%esp
}
  801590:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801593:	c9                   	leave  
  801594:	c3                   	ret    
			thisenv->env_id, fdnum);
  801595:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80159a:	8b 40 48             	mov    0x48(%eax),%eax
  80159d:	83 ec 04             	sub    $0x4,%esp
  8015a0:	53                   	push   %ebx
  8015a1:	50                   	push   %eax
  8015a2:	68 64 2c 80 00       	push   $0x802c64
  8015a7:	e8 25 ed ff ff       	call   8002d1 <cprintf>
		return -E_INVAL;
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b4:	eb da                	jmp    801590 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015bb:	eb d3                	jmp    801590 <ftruncate+0x52>

008015bd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	53                   	push   %ebx
  8015c1:	83 ec 14             	sub    $0x14,%esp
  8015c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ca:	50                   	push   %eax
  8015cb:	ff 75 08             	pushl  0x8(%ebp)
  8015ce:	e8 81 fb ff ff       	call   801154 <fd_lookup>
  8015d3:	83 c4 08             	add    $0x8,%esp
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	78 4b                	js     801625 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e0:	50                   	push   %eax
  8015e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e4:	ff 30                	pushl  (%eax)
  8015e6:	e8 bf fb ff ff       	call   8011aa <dev_lookup>
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	78 33                	js     801625 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015f9:	74 2f                	je     80162a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015fb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015fe:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801605:	00 00 00 
	stat->st_isdir = 0;
  801608:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80160f:	00 00 00 
	stat->st_dev = dev;
  801612:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801618:	83 ec 08             	sub    $0x8,%esp
  80161b:	53                   	push   %ebx
  80161c:	ff 75 f0             	pushl  -0x10(%ebp)
  80161f:	ff 50 14             	call   *0x14(%eax)
  801622:	83 c4 10             	add    $0x10,%esp
}
  801625:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801628:	c9                   	leave  
  801629:	c3                   	ret    
		return -E_NOT_SUPP;
  80162a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80162f:	eb f4                	jmp    801625 <fstat+0x68>

00801631 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	56                   	push   %esi
  801635:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801636:	83 ec 08             	sub    $0x8,%esp
  801639:	6a 00                	push   $0x0
  80163b:	ff 75 08             	pushl  0x8(%ebp)
  80163e:	e8 e7 01 00 00       	call   80182a <open>
  801643:	89 c3                	mov    %eax,%ebx
  801645:	83 c4 10             	add    $0x10,%esp
  801648:	85 c0                	test   %eax,%eax
  80164a:	78 1b                	js     801667 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	ff 75 0c             	pushl  0xc(%ebp)
  801652:	50                   	push   %eax
  801653:	e8 65 ff ff ff       	call   8015bd <fstat>
  801658:	89 c6                	mov    %eax,%esi
	close(fd);
  80165a:	89 1c 24             	mov    %ebx,(%esp)
  80165d:	e8 27 fc ff ff       	call   801289 <close>
	return r;
  801662:	83 c4 10             	add    $0x10,%esp
  801665:	89 f3                	mov    %esi,%ebx
}
  801667:	89 d8                	mov    %ebx,%eax
  801669:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166c:	5b                   	pop    %ebx
  80166d:	5e                   	pop    %esi
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
  801675:	89 c6                	mov    %eax,%esi
  801677:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801679:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801680:	74 27                	je     8016a9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801682:	6a 07                	push   $0x7
  801684:	68 00 50 80 00       	push   $0x805000
  801689:	56                   	push   %esi
  80168a:	ff 35 00 40 80 00    	pushl  0x804000
  801690:	e8 1b 0e 00 00       	call   8024b0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801695:	83 c4 0c             	add    $0xc,%esp
  801698:	6a 00                	push   $0x0
  80169a:	53                   	push   %ebx
  80169b:	6a 00                	push   $0x0
  80169d:	e8 f7 0d 00 00       	call   802499 <ipc_recv>
}
  8016a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016a9:	83 ec 0c             	sub    $0xc,%esp
  8016ac:	6a 01                	push   $0x1
  8016ae:	e8 14 0e 00 00       	call   8024c7 <ipc_find_env>
  8016b3:	a3 00 40 80 00       	mov    %eax,0x804000
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	eb c5                	jmp    801682 <fsipc+0x12>

008016bd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016db:	b8 02 00 00 00       	mov    $0x2,%eax
  8016e0:	e8 8b ff ff ff       	call   801670 <fsipc>
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <devfile_flush>:
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fd:	b8 06 00 00 00       	mov    $0x6,%eax
  801702:	e8 69 ff ff ff       	call   801670 <fsipc>
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <devfile_stat>:
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	53                   	push   %ebx
  80170d:	83 ec 04             	sub    $0x4,%esp
  801710:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	8b 40 0c             	mov    0xc(%eax),%eax
  801719:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80171e:	ba 00 00 00 00       	mov    $0x0,%edx
  801723:	b8 05 00 00 00       	mov    $0x5,%eax
  801728:	e8 43 ff ff ff       	call   801670 <fsipc>
  80172d:	85 c0                	test   %eax,%eax
  80172f:	78 2c                	js     80175d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801731:	83 ec 08             	sub    $0x8,%esp
  801734:	68 00 50 80 00       	push   $0x805000
  801739:	53                   	push   %ebx
  80173a:	e8 7c f1 ff ff       	call   8008bb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80173f:	a1 80 50 80 00       	mov    0x805080,%eax
  801744:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80174a:	a1 84 50 80 00       	mov    0x805084,%eax
  80174f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <devfile_write>:
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 0c             	sub    $0xc,%esp
  801768:	8b 45 10             	mov    0x10(%ebp),%eax
  80176b:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801770:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801775:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801778:	8b 55 08             	mov    0x8(%ebp),%edx
  80177b:	8b 52 0c             	mov    0xc(%edx),%edx
  80177e:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801784:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  801789:	50                   	push   %eax
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	68 08 50 80 00       	push   $0x805008
  801792:	e8 b2 f2 ff ff       	call   800a49 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	b8 04 00 00 00       	mov    $0x4,%eax
  8017a1:	e8 ca fe ff ff       	call   801670 <fsipc>
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <devfile_read>:
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	56                   	push   %esi
  8017ac:	53                   	push   %ebx
  8017ad:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017bb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c6:	b8 03 00 00 00       	mov    $0x3,%eax
  8017cb:	e8 a0 fe ff ff       	call   801670 <fsipc>
  8017d0:	89 c3                	mov    %eax,%ebx
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	78 1f                	js     8017f5 <devfile_read+0x4d>
	assert(r <= n);
  8017d6:	39 f0                	cmp    %esi,%eax
  8017d8:	77 24                	ja     8017fe <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017da:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017df:	7f 33                	jg     801814 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	50                   	push   %eax
  8017e5:	68 00 50 80 00       	push   $0x805000
  8017ea:	ff 75 0c             	pushl  0xc(%ebp)
  8017ed:	e8 57 f2 ff ff       	call   800a49 <memmove>
	return r;
  8017f2:	83 c4 10             	add    $0x10,%esp
}
  8017f5:	89 d8                	mov    %ebx,%eax
  8017f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fa:	5b                   	pop    %ebx
  8017fb:	5e                   	pop    %esi
  8017fc:	5d                   	pop    %ebp
  8017fd:	c3                   	ret    
	assert(r <= n);
  8017fe:	68 d0 2c 80 00       	push   $0x802cd0
  801803:	68 d7 2c 80 00       	push   $0x802cd7
  801808:	6a 7c                	push   $0x7c
  80180a:	68 ec 2c 80 00       	push   $0x802cec
  80180f:	e8 e2 e9 ff ff       	call   8001f6 <_panic>
	assert(r <= PGSIZE);
  801814:	68 f7 2c 80 00       	push   $0x802cf7
  801819:	68 d7 2c 80 00       	push   $0x802cd7
  80181e:	6a 7d                	push   $0x7d
  801820:	68 ec 2c 80 00       	push   $0x802cec
  801825:	e8 cc e9 ff ff       	call   8001f6 <_panic>

0080182a <open>:
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	56                   	push   %esi
  80182e:	53                   	push   %ebx
  80182f:	83 ec 1c             	sub    $0x1c,%esp
  801832:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801835:	56                   	push   %esi
  801836:	e8 49 f0 ff ff       	call   800884 <strlen>
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801843:	7f 6c                	jg     8018b1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801845:	83 ec 0c             	sub    $0xc,%esp
  801848:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184b:	50                   	push   %eax
  80184c:	e8 b4 f8 ff ff       	call   801105 <fd_alloc>
  801851:	89 c3                	mov    %eax,%ebx
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	85 c0                	test   %eax,%eax
  801858:	78 3c                	js     801896 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80185a:	83 ec 08             	sub    $0x8,%esp
  80185d:	56                   	push   %esi
  80185e:	68 00 50 80 00       	push   $0x805000
  801863:	e8 53 f0 ff ff       	call   8008bb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801870:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801873:	b8 01 00 00 00       	mov    $0x1,%eax
  801878:	e8 f3 fd ff ff       	call   801670 <fsipc>
  80187d:	89 c3                	mov    %eax,%ebx
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	85 c0                	test   %eax,%eax
  801884:	78 19                	js     80189f <open+0x75>
	return fd2num(fd);
  801886:	83 ec 0c             	sub    $0xc,%esp
  801889:	ff 75 f4             	pushl  -0xc(%ebp)
  80188c:	e8 4d f8 ff ff       	call   8010de <fd2num>
  801891:	89 c3                	mov    %eax,%ebx
  801893:	83 c4 10             	add    $0x10,%esp
}
  801896:	89 d8                	mov    %ebx,%eax
  801898:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189b:	5b                   	pop    %ebx
  80189c:	5e                   	pop    %esi
  80189d:	5d                   	pop    %ebp
  80189e:	c3                   	ret    
		fd_close(fd, 0);
  80189f:	83 ec 08             	sub    $0x8,%esp
  8018a2:	6a 00                	push   $0x0
  8018a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a7:	e8 54 f9 ff ff       	call   801200 <fd_close>
		return r;
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	eb e5                	jmp    801896 <open+0x6c>
		return -E_BAD_PATH;
  8018b1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018b6:	eb de                	jmp    801896 <open+0x6c>

008018b8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018be:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c3:	b8 08 00 00 00       	mov    $0x8,%eax
  8018c8:	e8 a3 fd ff ff       	call   801670 <fsipc>
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	57                   	push   %edi
  8018d3:	56                   	push   %esi
  8018d4:	53                   	push   %ebx
  8018d5:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8018db:	6a 00                	push   $0x0
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	e8 45 ff ff ff       	call   80182a <open>
  8018e5:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8018eb:	83 c4 10             	add    $0x10,%esp
  8018ee:	85 c0                	test   %eax,%eax
  8018f0:	0f 88 40 03 00 00    	js     801c36 <spawn+0x367>
  8018f6:	89 c7                	mov    %eax,%edi
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8018f8:	83 ec 04             	sub    $0x4,%esp
  8018fb:	68 00 02 00 00       	push   $0x200
  801900:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801906:	50                   	push   %eax
  801907:	57                   	push   %edi
  801908:	e8 3f fb ff ff       	call   80144c <readn>
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	3d 00 02 00 00       	cmp    $0x200,%eax
  801915:	75 5d                	jne    801974 <spawn+0xa5>
	    || elf->e_magic != ELF_MAGIC) {
  801917:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80191e:	45 4c 46 
  801921:	75 51                	jne    801974 <spawn+0xa5>
  801923:	b8 07 00 00 00       	mov    $0x7,%eax
  801928:	cd 30                	int    $0x30
  80192a:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801930:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801936:	85 c0                	test   %eax,%eax
  801938:	0f 88 81 04 00 00    	js     801dbf <spawn+0x4f0>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80193e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801943:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801946:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80194c:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801952:	b9 11 00 00 00       	mov    $0x11,%ecx
  801957:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801959:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80195f:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801965:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  80196a:	be 00 00 00 00       	mov    $0x0,%esi
  80196f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801972:	eb 4b                	jmp    8019bf <spawn+0xf0>
		close(fd);
  801974:	83 ec 0c             	sub    $0xc,%esp
  801977:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80197d:	e8 07 f9 ff ff       	call   801289 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801982:	83 c4 0c             	add    $0xc,%esp
  801985:	68 7f 45 4c 46       	push   $0x464c457f
  80198a:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801990:	68 03 2d 80 00       	push   $0x802d03
  801995:	e8 37 e9 ff ff       	call   8002d1 <cprintf>
		return -E_NOT_EXEC;
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  8019a4:	ff ff ff 
  8019a7:	e9 8a 02 00 00       	jmp    801c36 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  8019ac:	83 ec 0c             	sub    $0xc,%esp
  8019af:	50                   	push   %eax
  8019b0:	e8 cf ee ff ff       	call   800884 <strlen>
  8019b5:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8019b9:	83 c3 01             	add    $0x1,%ebx
  8019bc:	83 c4 10             	add    $0x10,%esp
  8019bf:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8019c6:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	75 df                	jne    8019ac <spawn+0xdd>
  8019cd:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8019d3:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8019d9:	bf 00 10 40 00       	mov    $0x401000,%edi
  8019de:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8019e0:	89 fa                	mov    %edi,%edx
  8019e2:	83 e2 fc             	and    $0xfffffffc,%edx
  8019e5:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8019ec:	29 c2                	sub    %eax,%edx
  8019ee:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8019f4:	8d 42 f8             	lea    -0x8(%edx),%eax
  8019f7:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8019fc:	0f 86 ce 03 00 00    	jbe    801dd0 <spawn+0x501>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	6a 07                	push   $0x7
  801a07:	68 00 00 40 00       	push   $0x400000
  801a0c:	6a 00                	push   $0x0
  801a0e:	e8 a1 f2 ff ff       	call   800cb4 <sys_page_alloc>
  801a13:	83 c4 10             	add    $0x10,%esp
  801a16:	85 c0                	test   %eax,%eax
  801a18:	0f 88 b7 03 00 00    	js     801dd5 <spawn+0x506>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a1e:	be 00 00 00 00       	mov    $0x0,%esi
  801a23:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801a29:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a2c:	eb 30                	jmp    801a5e <spawn+0x18f>
		argv_store[i] = UTEMP2USTACK(string_store);
  801a2e:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a34:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801a3a:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801a3d:	83 ec 08             	sub    $0x8,%esp
  801a40:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a43:	57                   	push   %edi
  801a44:	e8 72 ee ff ff       	call   8008bb <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a49:	83 c4 04             	add    $0x4,%esp
  801a4c:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a4f:	e8 30 ee ff ff       	call   800884 <strlen>
  801a54:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801a58:	83 c6 01             	add    $0x1,%esi
  801a5b:	83 c4 10             	add    $0x10,%esp
  801a5e:	39 b5 88 fd ff ff    	cmp    %esi,-0x278(%ebp)
  801a64:	7f c8                	jg     801a2e <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801a66:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801a6c:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801a72:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801a79:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801a7f:	0f 85 8c 00 00 00    	jne    801b11 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801a85:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801a8b:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a91:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801a94:	89 f8                	mov    %edi,%eax
  801a96:	8b bd 84 fd ff ff    	mov    -0x27c(%ebp),%edi
  801a9c:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801a9f:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801aa4:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801aaa:	83 ec 0c             	sub    $0xc,%esp
  801aad:	6a 07                	push   $0x7
  801aaf:	68 00 d0 bf ee       	push   $0xeebfd000
  801ab4:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801aba:	68 00 00 40 00       	push   $0x400000
  801abf:	6a 00                	push   $0x0
  801ac1:	e8 31 f2 ff ff       	call   800cf7 <sys_page_map>
  801ac6:	89 c3                	mov    %eax,%ebx
  801ac8:	83 c4 20             	add    $0x20,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	0f 88 78 03 00 00    	js     801e4b <spawn+0x57c>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801ad3:	83 ec 08             	sub    $0x8,%esp
  801ad6:	68 00 00 40 00       	push   $0x400000
  801adb:	6a 00                	push   $0x0
  801add:	e8 57 f2 ff ff       	call   800d39 <sys_page_unmap>
  801ae2:	89 c3                	mov    %eax,%ebx
  801ae4:	83 c4 10             	add    $0x10,%esp
  801ae7:	85 c0                	test   %eax,%eax
  801ae9:	0f 88 5c 03 00 00    	js     801e4b <spawn+0x57c>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801aef:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801af5:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801afc:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b02:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801b09:	00 00 00 
  801b0c:	e9 56 01 00 00       	jmp    801c67 <spawn+0x398>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b11:	68 78 2d 80 00       	push   $0x802d78
  801b16:	68 d7 2c 80 00       	push   $0x802cd7
  801b1b:	68 f2 00 00 00       	push   $0xf2
  801b20:	68 1d 2d 80 00       	push   $0x802d1d
  801b25:	e8 cc e6 ff ff       	call   8001f6 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	6a 07                	push   $0x7
  801b2f:	68 00 00 40 00       	push   $0x400000
  801b34:	6a 00                	push   $0x0
  801b36:	e8 79 f1 ff ff       	call   800cb4 <sys_page_alloc>
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	0f 88 9a 02 00 00    	js     801de0 <spawn+0x511>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801b46:	83 ec 08             	sub    $0x8,%esp
  801b49:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b4f:	01 f0                	add    %esi,%eax
  801b51:	50                   	push   %eax
  801b52:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801b58:	e8 b8 f9 ff ff       	call   801515 <seek>
  801b5d:	83 c4 10             	add    $0x10,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	0f 88 7f 02 00 00    	js     801de7 <spawn+0x518>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b71:	29 f0                	sub    %esi,%eax
  801b73:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b78:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801b7d:	0f 47 c1             	cmova  %ecx,%eax
  801b80:	50                   	push   %eax
  801b81:	68 00 00 40 00       	push   $0x400000
  801b86:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801b8c:	e8 bb f8 ff ff       	call   80144c <readn>
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	85 c0                	test   %eax,%eax
  801b96:	0f 88 52 02 00 00    	js     801dee <spawn+0x51f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801b9c:	83 ec 0c             	sub    $0xc,%esp
  801b9f:	57                   	push   %edi
  801ba0:	03 b5 84 fd ff ff    	add    -0x27c(%ebp),%esi
  801ba6:	56                   	push   %esi
  801ba7:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801bad:	68 00 00 40 00       	push   $0x400000
  801bb2:	6a 00                	push   $0x0
  801bb4:	e8 3e f1 ff ff       	call   800cf7 <sys_page_map>
  801bb9:	83 c4 20             	add    $0x20,%esp
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	0f 88 80 00 00 00    	js     801c44 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801bc4:	83 ec 08             	sub    $0x8,%esp
  801bc7:	68 00 00 40 00       	push   $0x400000
  801bcc:	6a 00                	push   $0x0
  801bce:	e8 66 f1 ff ff       	call   800d39 <sys_page_unmap>
  801bd3:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801bd6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801bdc:	89 de                	mov    %ebx,%esi
  801bde:	39 9d 88 fd ff ff    	cmp    %ebx,-0x278(%ebp)
  801be4:	76 73                	jbe    801c59 <spawn+0x38a>
		if (i >= filesz) {
  801be6:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801bec:	0f 87 38 ff ff ff    	ja     801b2a <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	57                   	push   %edi
  801bf6:	03 b5 84 fd ff ff    	add    -0x27c(%ebp),%esi
  801bfc:	56                   	push   %esi
  801bfd:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c03:	e8 ac f0 ff ff       	call   800cb4 <sys_page_alloc>
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	79 c7                	jns    801bd6 <spawn+0x307>
  801c0f:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801c11:	83 ec 0c             	sub    $0xc,%esp
  801c14:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c1a:	e8 16 f0 ff ff       	call   800c35 <sys_env_destroy>
	close(fd);
  801c1f:	83 c4 04             	add    $0x4,%esp
  801c22:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801c28:	e8 5c f6 ff ff       	call   801289 <close>
	return r;
  801c2d:	83 c4 10             	add    $0x10,%esp
  801c30:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  801c36:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5f                   	pop    %edi
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801c44:	50                   	push   %eax
  801c45:	68 29 2d 80 00       	push   $0x802d29
  801c4a:	68 25 01 00 00       	push   $0x125
  801c4f:	68 1d 2d 80 00       	push   $0x802d1d
  801c54:	e8 9d e5 ff ff       	call   8001f6 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c59:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801c60:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801c67:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801c6e:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801c74:	7e 71                	jle    801ce7 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801c76:	8b 8d 78 fd ff ff    	mov    -0x288(%ebp),%ecx
  801c7c:	83 39 01             	cmpl   $0x1,(%ecx)
  801c7f:	75 d8                	jne    801c59 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801c81:	8b 41 18             	mov    0x18(%ecx),%eax
  801c84:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801c87:	83 f8 01             	cmp    $0x1,%eax
  801c8a:	19 ff                	sbb    %edi,%edi
  801c8c:	83 e7 fe             	and    $0xfffffffe,%edi
  801c8f:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801c92:	8b 71 04             	mov    0x4(%ecx),%esi
  801c95:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801c9b:	8b 59 10             	mov    0x10(%ecx),%ebx
  801c9e:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801ca4:	8b 41 14             	mov    0x14(%ecx),%eax
  801ca7:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801cad:	8b 51 08             	mov    0x8(%ecx),%edx
  801cb0:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
	if ((i = PGOFF(va))) {
  801cb6:	89 d0                	mov    %edx,%eax
  801cb8:	25 ff 0f 00 00       	and    $0xfff,%eax
  801cbd:	74 1e                	je     801cdd <spawn+0x40e>
		va -= i;
  801cbf:	29 c2                	sub    %eax,%edx
  801cc1:	89 95 84 fd ff ff    	mov    %edx,-0x27c(%ebp)
		memsz += i;
  801cc7:	01 85 88 fd ff ff    	add    %eax,-0x278(%ebp)
		filesz += i;
  801ccd:	01 c3                	add    %eax,%ebx
  801ccf:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  801cd5:	29 c6                	sub    %eax,%esi
  801cd7:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801cdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ce2:	e9 f5 fe ff ff       	jmp    801bdc <spawn+0x30d>
	close(fd);
  801ce7:	83 ec 0c             	sub    $0xc,%esp
  801cea:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801cf0:	e8 94 f5 ff ff       	call   801289 <close>
  801cf5:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i, j, pn, r;

        for (i = PDX(UTEXT); i < PDX(UXSTACKTOP); i++) {
  801cf8:	bf 02 00 00 00       	mov    $0x2,%edi
  801cfd:	eb 7c                	jmp    801d7b <spawn+0x4ac>
  801cff:	81 c3 00 10 00 00    	add    $0x1000,%ebx
                if (uvpd[i] & PTE_P) {
                        for (j = 0; j < NPTENTRIES; j++) {
  801d05:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801d0b:	74 63                	je     801d70 <spawn+0x4a1>
                                pn = PGNUM(PGADDR(i, j, 0));
  801d0d:	89 da                	mov    %ebx,%edx
  801d0f:	09 f2                	or     %esi,%edx
  801d11:	89 d0                	mov    %edx,%eax
  801d13:	c1 e8 0c             	shr    $0xc,%eax
                                if (pn == PGNUM(UXSTACKTOP - PGSIZE))
  801d16:	3d ff eb 0e 00       	cmp    $0xeebff,%eax
  801d1b:	74 53                	je     801d70 <spawn+0x4a1>
                                        break;
                                if ((uvpt[pn] & PTE_P) && (uvpt[pn] & PTE_SHARE)) {
  801d1d:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  801d24:	f6 c1 01             	test   $0x1,%cl
  801d27:	74 d6                	je     801cff <spawn+0x430>
  801d29:	8b 0c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%ecx
  801d30:	f6 c5 04             	test   $0x4,%ch
  801d33:	74 ca                	je     801cff <spawn+0x430>
                                        if ((r = sys_page_map(0, (void *)PGADDR(i, j, 0), child, (void *)PGADDR(i, j, 0), uvpt[pn] & PTE_SYSCALL)) < 0)
  801d35:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d3c:	83 ec 0c             	sub    $0xc,%esp
  801d3f:	25 07 0e 00 00       	and    $0xe07,%eax
  801d44:	50                   	push   %eax
  801d45:	52                   	push   %edx
  801d46:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d4c:	52                   	push   %edx
  801d4d:	6a 00                	push   $0x0
  801d4f:	e8 a3 ef ff ff       	call   800cf7 <sys_page_map>
  801d54:	83 c4 20             	add    $0x20,%esp
  801d57:	85 c0                	test   %eax,%eax
  801d59:	79 a4                	jns    801cff <spawn+0x430>
		panic("copy_shared_pages: %e", r);
  801d5b:	50                   	push   %eax
  801d5c:	68 60 2d 80 00       	push   $0x802d60
  801d61:	68 82 00 00 00       	push   $0x82
  801d66:	68 1d 2d 80 00       	push   $0x802d1d
  801d6b:	e8 86 e4 ff ff       	call   8001f6 <_panic>
        for (i = PDX(UTEXT); i < PDX(UXSTACKTOP); i++) {
  801d70:	83 c7 01             	add    $0x1,%edi
  801d73:	81 ff bb 03 00 00    	cmp    $0x3bb,%edi
  801d79:	74 7a                	je     801df5 <spawn+0x526>
                if (uvpd[i] & PTE_P) {
  801d7b:	8b 04 bd 00 d0 7b ef 	mov    -0x10843000(,%edi,4),%eax
  801d82:	a8 01                	test   $0x1,%al
  801d84:	74 ea                	je     801d70 <spawn+0x4a1>
  801d86:	89 fe                	mov    %edi,%esi
  801d88:	c1 e6 16             	shl    $0x16,%esi
  801d8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d90:	e9 78 ff ff ff       	jmp    801d0d <spawn+0x43e>
		panic("sys_env_set_trapframe: %e", r);
  801d95:	50                   	push   %eax
  801d96:	68 46 2d 80 00       	push   $0x802d46
  801d9b:	68 86 00 00 00       	push   $0x86
  801da0:	68 1d 2d 80 00       	push   $0x802d1d
  801da5:	e8 4c e4 ff ff       	call   8001f6 <_panic>
		panic("sys_env_set_status: %e", r);
  801daa:	50                   	push   %eax
  801dab:	68 ad 2b 80 00       	push   $0x802bad
  801db0:	68 89 00 00 00       	push   $0x89
  801db5:	68 1d 2d 80 00       	push   $0x802d1d
  801dba:	e8 37 e4 ff ff       	call   8001f6 <_panic>
		return r;
  801dbf:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801dc5:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801dcb:	e9 66 fe ff ff       	jmp    801c36 <spawn+0x367>
		return -E_NO_MEM;
  801dd0:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801dd5:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801ddb:	e9 56 fe ff ff       	jmp    801c36 <spawn+0x367>
  801de0:	89 c7                	mov    %eax,%edi
  801de2:	e9 2a fe ff ff       	jmp    801c11 <spawn+0x342>
  801de7:	89 c7                	mov    %eax,%edi
  801de9:	e9 23 fe ff ff       	jmp    801c11 <spawn+0x342>
  801dee:	89 c7                	mov    %eax,%edi
  801df0:	e9 1c fe ff ff       	jmp    801c11 <spawn+0x342>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801df5:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801dfc:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801dff:	83 ec 08             	sub    $0x8,%esp
  801e02:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e08:	50                   	push   %eax
  801e09:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e0f:	e8 a9 ef ff ff       	call   800dbd <sys_env_set_trapframe>
  801e14:	83 c4 10             	add    $0x10,%esp
  801e17:	85 c0                	test   %eax,%eax
  801e19:	0f 88 76 ff ff ff    	js     801d95 <spawn+0x4c6>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e1f:	83 ec 08             	sub    $0x8,%esp
  801e22:	6a 02                	push   $0x2
  801e24:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e2a:	e8 4c ef ff ff       	call   800d7b <sys_env_set_status>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	85 c0                	test   %eax,%eax
  801e34:	0f 88 70 ff ff ff    	js     801daa <spawn+0x4db>
	return child;
  801e3a:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e40:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801e46:	e9 eb fd ff ff       	jmp    801c36 <spawn+0x367>
	sys_page_unmap(0, UTEMP);
  801e4b:	83 ec 08             	sub    $0x8,%esp
  801e4e:	68 00 00 40 00       	push   $0x400000
  801e53:	6a 00                	push   $0x0
  801e55:	e8 df ee ff ff       	call   800d39 <sys_page_unmap>
  801e5a:	83 c4 10             	add    $0x10,%esp
  801e5d:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801e63:	e9 ce fd ff ff       	jmp    801c36 <spawn+0x367>

00801e68 <spawnl>:
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	57                   	push   %edi
  801e6c:	56                   	push   %esi
  801e6d:	53                   	push   %ebx
  801e6e:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801e71:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801e74:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801e79:	eb 05                	jmp    801e80 <spawnl+0x18>
		argc++;
  801e7b:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801e7e:	89 ca                	mov    %ecx,%edx
  801e80:	8d 4a 04             	lea    0x4(%edx),%ecx
  801e83:	83 3a 00             	cmpl   $0x0,(%edx)
  801e86:	75 f3                	jne    801e7b <spawnl+0x13>
	const char *argv[argc+2];
  801e88:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801e8f:	83 e2 f0             	and    $0xfffffff0,%edx
  801e92:	29 d4                	sub    %edx,%esp
  801e94:	8d 54 24 03          	lea    0x3(%esp),%edx
  801e98:	c1 ea 02             	shr    $0x2,%edx
  801e9b:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801ea2:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801ea4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ea7:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801eae:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801eb5:	00 
	va_start(vl, arg0);
  801eb6:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801eb9:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec0:	eb 0b                	jmp    801ecd <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801ec2:	83 c0 01             	add    $0x1,%eax
  801ec5:	8b 39                	mov    (%ecx),%edi
  801ec7:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801eca:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801ecd:	39 d0                	cmp    %edx,%eax
  801ecf:	75 f1                	jne    801ec2 <spawnl+0x5a>
	return spawn(prog, argv);
  801ed1:	83 ec 08             	sub    $0x8,%esp
  801ed4:	56                   	push   %esi
  801ed5:	ff 75 08             	pushl  0x8(%ebp)
  801ed8:	e8 f2 f9 ff ff       	call   8018cf <spawn>
}
  801edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee0:	5b                   	pop    %ebx
  801ee1:	5e                   	pop    %esi
  801ee2:	5f                   	pop    %edi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    

00801ee5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	56                   	push   %esi
  801ee9:	53                   	push   %ebx
  801eea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801eed:	83 ec 0c             	sub    $0xc,%esp
  801ef0:	ff 75 08             	pushl  0x8(%ebp)
  801ef3:	e8 f6 f1 ff ff       	call   8010ee <fd2data>
  801ef8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801efa:	83 c4 08             	add    $0x8,%esp
  801efd:	68 a0 2d 80 00       	push   $0x802da0
  801f02:	53                   	push   %ebx
  801f03:	e8 b3 e9 ff ff       	call   8008bb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f08:	8b 46 04             	mov    0x4(%esi),%eax
  801f0b:	2b 06                	sub    (%esi),%eax
  801f0d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f13:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f1a:	00 00 00 
	stat->st_dev = &devpipe;
  801f1d:	c7 83 88 00 00 00 28 	movl   $0x803028,0x88(%ebx)
  801f24:	30 80 00 
	return 0;
}
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f2f:	5b                   	pop    %ebx
  801f30:	5e                   	pop    %esi
  801f31:	5d                   	pop    %ebp
  801f32:	c3                   	ret    

00801f33 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	53                   	push   %ebx
  801f37:	83 ec 0c             	sub    $0xc,%esp
  801f3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f3d:	53                   	push   %ebx
  801f3e:	6a 00                	push   $0x0
  801f40:	e8 f4 ed ff ff       	call   800d39 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f45:	89 1c 24             	mov    %ebx,(%esp)
  801f48:	e8 a1 f1 ff ff       	call   8010ee <fd2data>
  801f4d:	83 c4 08             	add    $0x8,%esp
  801f50:	50                   	push   %eax
  801f51:	6a 00                	push   $0x0
  801f53:	e8 e1 ed ff ff       	call   800d39 <sys_page_unmap>
}
  801f58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <_pipeisclosed>:
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	57                   	push   %edi
  801f61:	56                   	push   %esi
  801f62:	53                   	push   %ebx
  801f63:	83 ec 1c             	sub    $0x1c,%esp
  801f66:	89 c7                	mov    %eax,%edi
  801f68:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f6a:	a1 04 40 80 00       	mov    0x804004,%eax
  801f6f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f72:	83 ec 0c             	sub    $0xc,%esp
  801f75:	57                   	push   %edi
  801f76:	e8 85 05 00 00       	call   802500 <pageref>
  801f7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f7e:	89 34 24             	mov    %esi,(%esp)
  801f81:	e8 7a 05 00 00       	call   802500 <pageref>
		nn = thisenv->env_runs;
  801f86:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f8c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	39 cb                	cmp    %ecx,%ebx
  801f94:	74 1b                	je     801fb1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f96:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f99:	75 cf                	jne    801f6a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f9b:	8b 42 58             	mov    0x58(%edx),%eax
  801f9e:	6a 01                	push   $0x1
  801fa0:	50                   	push   %eax
  801fa1:	53                   	push   %ebx
  801fa2:	68 a7 2d 80 00       	push   $0x802da7
  801fa7:	e8 25 e3 ff ff       	call   8002d1 <cprintf>
  801fac:	83 c4 10             	add    $0x10,%esp
  801faf:	eb b9                	jmp    801f6a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801fb1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fb4:	0f 94 c0             	sete   %al
  801fb7:	0f b6 c0             	movzbl %al,%eax
}
  801fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fbd:	5b                   	pop    %ebx
  801fbe:	5e                   	pop    %esi
  801fbf:	5f                   	pop    %edi
  801fc0:	5d                   	pop    %ebp
  801fc1:	c3                   	ret    

00801fc2 <devpipe_write>:
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	57                   	push   %edi
  801fc6:	56                   	push   %esi
  801fc7:	53                   	push   %ebx
  801fc8:	83 ec 28             	sub    $0x28,%esp
  801fcb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801fce:	56                   	push   %esi
  801fcf:	e8 1a f1 ff ff       	call   8010ee <fd2data>
  801fd4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fd6:	83 c4 10             	add    $0x10,%esp
  801fd9:	bf 00 00 00 00       	mov    $0x0,%edi
  801fde:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fe1:	74 4f                	je     802032 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fe3:	8b 43 04             	mov    0x4(%ebx),%eax
  801fe6:	8b 0b                	mov    (%ebx),%ecx
  801fe8:	8d 51 20             	lea    0x20(%ecx),%edx
  801feb:	39 d0                	cmp    %edx,%eax
  801fed:	72 14                	jb     802003 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801fef:	89 da                	mov    %ebx,%edx
  801ff1:	89 f0                	mov    %esi,%eax
  801ff3:	e8 65 ff ff ff       	call   801f5d <_pipeisclosed>
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	75 3a                	jne    802036 <devpipe_write+0x74>
			sys_yield();
  801ffc:	e8 94 ec ff ff       	call   800c95 <sys_yield>
  802001:	eb e0                	jmp    801fe3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802003:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802006:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80200a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80200d:	89 c2                	mov    %eax,%edx
  80200f:	c1 fa 1f             	sar    $0x1f,%edx
  802012:	89 d1                	mov    %edx,%ecx
  802014:	c1 e9 1b             	shr    $0x1b,%ecx
  802017:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80201a:	83 e2 1f             	and    $0x1f,%edx
  80201d:	29 ca                	sub    %ecx,%edx
  80201f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802023:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802027:	83 c0 01             	add    $0x1,%eax
  80202a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80202d:	83 c7 01             	add    $0x1,%edi
  802030:	eb ac                	jmp    801fde <devpipe_write+0x1c>
	return i;
  802032:	89 f8                	mov    %edi,%eax
  802034:	eb 05                	jmp    80203b <devpipe_write+0x79>
				return 0;
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80203e:	5b                   	pop    %ebx
  80203f:	5e                   	pop    %esi
  802040:	5f                   	pop    %edi
  802041:	5d                   	pop    %ebp
  802042:	c3                   	ret    

00802043 <devpipe_read>:
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	57                   	push   %edi
  802047:	56                   	push   %esi
  802048:	53                   	push   %ebx
  802049:	83 ec 18             	sub    $0x18,%esp
  80204c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80204f:	57                   	push   %edi
  802050:	e8 99 f0 ff ff       	call   8010ee <fd2data>
  802055:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802057:	83 c4 10             	add    $0x10,%esp
  80205a:	be 00 00 00 00       	mov    $0x0,%esi
  80205f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802062:	74 47                	je     8020ab <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802064:	8b 03                	mov    (%ebx),%eax
  802066:	3b 43 04             	cmp    0x4(%ebx),%eax
  802069:	75 22                	jne    80208d <devpipe_read+0x4a>
			if (i > 0)
  80206b:	85 f6                	test   %esi,%esi
  80206d:	75 14                	jne    802083 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80206f:	89 da                	mov    %ebx,%edx
  802071:	89 f8                	mov    %edi,%eax
  802073:	e8 e5 fe ff ff       	call   801f5d <_pipeisclosed>
  802078:	85 c0                	test   %eax,%eax
  80207a:	75 33                	jne    8020af <devpipe_read+0x6c>
			sys_yield();
  80207c:	e8 14 ec ff ff       	call   800c95 <sys_yield>
  802081:	eb e1                	jmp    802064 <devpipe_read+0x21>
				return i;
  802083:	89 f0                	mov    %esi,%eax
}
  802085:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802088:	5b                   	pop    %ebx
  802089:	5e                   	pop    %esi
  80208a:	5f                   	pop    %edi
  80208b:	5d                   	pop    %ebp
  80208c:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80208d:	99                   	cltd   
  80208e:	c1 ea 1b             	shr    $0x1b,%edx
  802091:	01 d0                	add    %edx,%eax
  802093:	83 e0 1f             	and    $0x1f,%eax
  802096:	29 d0                	sub    %edx,%eax
  802098:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80209d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020a0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020a3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020a6:	83 c6 01             	add    $0x1,%esi
  8020a9:	eb b4                	jmp    80205f <devpipe_read+0x1c>
	return i;
  8020ab:	89 f0                	mov    %esi,%eax
  8020ad:	eb d6                	jmp    802085 <devpipe_read+0x42>
				return 0;
  8020af:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b4:	eb cf                	jmp    802085 <devpipe_read+0x42>

008020b6 <pipe>:
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	56                   	push   %esi
  8020ba:	53                   	push   %ebx
  8020bb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020c1:	50                   	push   %eax
  8020c2:	e8 3e f0 ff ff       	call   801105 <fd_alloc>
  8020c7:	89 c3                	mov    %eax,%ebx
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	85 c0                	test   %eax,%eax
  8020ce:	78 5b                	js     80212b <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020d0:	83 ec 04             	sub    $0x4,%esp
  8020d3:	68 07 04 00 00       	push   $0x407
  8020d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8020db:	6a 00                	push   $0x0
  8020dd:	e8 d2 eb ff ff       	call   800cb4 <sys_page_alloc>
  8020e2:	89 c3                	mov    %eax,%ebx
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	78 40                	js     80212b <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8020eb:	83 ec 0c             	sub    $0xc,%esp
  8020ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020f1:	50                   	push   %eax
  8020f2:	e8 0e f0 ff ff       	call   801105 <fd_alloc>
  8020f7:	89 c3                	mov    %eax,%ebx
  8020f9:	83 c4 10             	add    $0x10,%esp
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	78 1b                	js     80211b <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802100:	83 ec 04             	sub    $0x4,%esp
  802103:	68 07 04 00 00       	push   $0x407
  802108:	ff 75 f0             	pushl  -0x10(%ebp)
  80210b:	6a 00                	push   $0x0
  80210d:	e8 a2 eb ff ff       	call   800cb4 <sys_page_alloc>
  802112:	89 c3                	mov    %eax,%ebx
  802114:	83 c4 10             	add    $0x10,%esp
  802117:	85 c0                	test   %eax,%eax
  802119:	79 19                	jns    802134 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80211b:	83 ec 08             	sub    $0x8,%esp
  80211e:	ff 75 f4             	pushl  -0xc(%ebp)
  802121:	6a 00                	push   $0x0
  802123:	e8 11 ec ff ff       	call   800d39 <sys_page_unmap>
  802128:	83 c4 10             	add    $0x10,%esp
}
  80212b:	89 d8                	mov    %ebx,%eax
  80212d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802130:	5b                   	pop    %ebx
  802131:	5e                   	pop    %esi
  802132:	5d                   	pop    %ebp
  802133:	c3                   	ret    
	va = fd2data(fd0);
  802134:	83 ec 0c             	sub    $0xc,%esp
  802137:	ff 75 f4             	pushl  -0xc(%ebp)
  80213a:	e8 af ef ff ff       	call   8010ee <fd2data>
  80213f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802141:	83 c4 0c             	add    $0xc,%esp
  802144:	68 07 04 00 00       	push   $0x407
  802149:	50                   	push   %eax
  80214a:	6a 00                	push   $0x0
  80214c:	e8 63 eb ff ff       	call   800cb4 <sys_page_alloc>
  802151:	89 c3                	mov    %eax,%ebx
  802153:	83 c4 10             	add    $0x10,%esp
  802156:	85 c0                	test   %eax,%eax
  802158:	0f 88 8c 00 00 00    	js     8021ea <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80215e:	83 ec 0c             	sub    $0xc,%esp
  802161:	ff 75 f0             	pushl  -0x10(%ebp)
  802164:	e8 85 ef ff ff       	call   8010ee <fd2data>
  802169:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802170:	50                   	push   %eax
  802171:	6a 00                	push   $0x0
  802173:	56                   	push   %esi
  802174:	6a 00                	push   $0x0
  802176:	e8 7c eb ff ff       	call   800cf7 <sys_page_map>
  80217b:	89 c3                	mov    %eax,%ebx
  80217d:	83 c4 20             	add    $0x20,%esp
  802180:	85 c0                	test   %eax,%eax
  802182:	78 58                	js     8021dc <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802187:	8b 15 28 30 80 00    	mov    0x803028,%edx
  80218d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219c:	8b 15 28 30 80 00    	mov    0x803028,%edx
  8021a2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8021ae:	83 ec 0c             	sub    $0xc,%esp
  8021b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8021b4:	e8 25 ef ff ff       	call   8010de <fd2num>
  8021b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021bc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021be:	83 c4 04             	add    $0x4,%esp
  8021c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8021c4:	e8 15 ef ff ff       	call   8010de <fd2num>
  8021c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021cc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021cf:	83 c4 10             	add    $0x10,%esp
  8021d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021d7:	e9 4f ff ff ff       	jmp    80212b <pipe+0x75>
	sys_page_unmap(0, va);
  8021dc:	83 ec 08             	sub    $0x8,%esp
  8021df:	56                   	push   %esi
  8021e0:	6a 00                	push   $0x0
  8021e2:	e8 52 eb ff ff       	call   800d39 <sys_page_unmap>
  8021e7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021ea:	83 ec 08             	sub    $0x8,%esp
  8021ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f0:	6a 00                	push   $0x0
  8021f2:	e8 42 eb ff ff       	call   800d39 <sys_page_unmap>
  8021f7:	83 c4 10             	add    $0x10,%esp
  8021fa:	e9 1c ff ff ff       	jmp    80211b <pipe+0x65>

008021ff <pipeisclosed>:
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
  802202:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802205:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802208:	50                   	push   %eax
  802209:	ff 75 08             	pushl  0x8(%ebp)
  80220c:	e8 43 ef ff ff       	call   801154 <fd_lookup>
  802211:	83 c4 10             	add    $0x10,%esp
  802214:	85 c0                	test   %eax,%eax
  802216:	78 18                	js     802230 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802218:	83 ec 0c             	sub    $0xc,%esp
  80221b:	ff 75 f4             	pushl  -0xc(%ebp)
  80221e:	e8 cb ee ff ff       	call   8010ee <fd2data>
	return _pipeisclosed(fd, p);
  802223:	89 c2                	mov    %eax,%edx
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	e8 30 fd ff ff       	call   801f5d <_pipeisclosed>
  80222d:	83 c4 10             	add    $0x10,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	56                   	push   %esi
  802236:	53                   	push   %ebx
  802237:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80223a:	85 f6                	test   %esi,%esi
  80223c:	74 13                	je     802251 <wait+0x1f>
	e = &envs[ENVX(envid)];
  80223e:	89 f3                	mov    %esi,%ebx
  802240:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802246:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802249:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80224f:	eb 1b                	jmp    80226c <wait+0x3a>
	assert(envid != 0);
  802251:	68 bf 2d 80 00       	push   $0x802dbf
  802256:	68 d7 2c 80 00       	push   $0x802cd7
  80225b:	6a 09                	push   $0x9
  80225d:	68 ca 2d 80 00       	push   $0x802dca
  802262:	e8 8f df ff ff       	call   8001f6 <_panic>
		sys_yield();
  802267:	e8 29 ea ff ff       	call   800c95 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80226c:	8b 43 48             	mov    0x48(%ebx),%eax
  80226f:	39 f0                	cmp    %esi,%eax
  802271:	75 07                	jne    80227a <wait+0x48>
  802273:	8b 43 54             	mov    0x54(%ebx),%eax
  802276:	85 c0                	test   %eax,%eax
  802278:	75 ed                	jne    802267 <wait+0x35>
}
  80227a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80227d:	5b                   	pop    %ebx
  80227e:	5e                   	pop    %esi
  80227f:	5d                   	pop    %ebp
  802280:	c3                   	ret    

00802281 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
  802289:	5d                   	pop    %ebp
  80228a:	c3                   	ret    

0080228b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802291:	68 d5 2d 80 00       	push   $0x802dd5
  802296:	ff 75 0c             	pushl  0xc(%ebp)
  802299:	e8 1d e6 ff ff       	call   8008bb <strcpy>
	return 0;
}
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <devcons_write>:
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	57                   	push   %edi
  8022a9:	56                   	push   %esi
  8022aa:	53                   	push   %ebx
  8022ab:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022b1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022b6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022bc:	eb 2f                	jmp    8022ed <devcons_write+0x48>
		m = n - tot;
  8022be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022c1:	29 f3                	sub    %esi,%ebx
  8022c3:	83 fb 7f             	cmp    $0x7f,%ebx
  8022c6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022cb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8022ce:	83 ec 04             	sub    $0x4,%esp
  8022d1:	53                   	push   %ebx
  8022d2:	89 f0                	mov    %esi,%eax
  8022d4:	03 45 0c             	add    0xc(%ebp),%eax
  8022d7:	50                   	push   %eax
  8022d8:	57                   	push   %edi
  8022d9:	e8 6b e7 ff ff       	call   800a49 <memmove>
		sys_cputs(buf, m);
  8022de:	83 c4 08             	add    $0x8,%esp
  8022e1:	53                   	push   %ebx
  8022e2:	57                   	push   %edi
  8022e3:	e8 10 e9 ff ff       	call   800bf8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022e8:	01 de                	add    %ebx,%esi
  8022ea:	83 c4 10             	add    $0x10,%esp
  8022ed:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022f0:	72 cc                	jb     8022be <devcons_write+0x19>
}
  8022f2:	89 f0                	mov    %esi,%eax
  8022f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5f                   	pop    %edi
  8022fa:	5d                   	pop    %ebp
  8022fb:	c3                   	ret    

008022fc <devcons_read>:
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	83 ec 08             	sub    $0x8,%esp
  802302:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802307:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80230b:	75 07                	jne    802314 <devcons_read+0x18>
}
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    
		sys_yield();
  80230f:	e8 81 e9 ff ff       	call   800c95 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802314:	e8 fd e8 ff ff       	call   800c16 <sys_cgetc>
  802319:	85 c0                	test   %eax,%eax
  80231b:	74 f2                	je     80230f <devcons_read+0x13>
	if (c < 0)
  80231d:	85 c0                	test   %eax,%eax
  80231f:	78 ec                	js     80230d <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802321:	83 f8 04             	cmp    $0x4,%eax
  802324:	74 0c                	je     802332 <devcons_read+0x36>
	*(char*)vbuf = c;
  802326:	8b 55 0c             	mov    0xc(%ebp),%edx
  802329:	88 02                	mov    %al,(%edx)
	return 1;
  80232b:	b8 01 00 00 00       	mov    $0x1,%eax
  802330:	eb db                	jmp    80230d <devcons_read+0x11>
		return 0;
  802332:	b8 00 00 00 00       	mov    $0x0,%eax
  802337:	eb d4                	jmp    80230d <devcons_read+0x11>

00802339 <cputchar>:
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802345:	6a 01                	push   $0x1
  802347:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80234a:	50                   	push   %eax
  80234b:	e8 a8 e8 ff ff       	call   800bf8 <sys_cputs>
}
  802350:	83 c4 10             	add    $0x10,%esp
  802353:	c9                   	leave  
  802354:	c3                   	ret    

00802355 <getchar>:
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
  802358:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80235b:	6a 01                	push   $0x1
  80235d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802360:	50                   	push   %eax
  802361:	6a 00                	push   $0x0
  802363:	e8 5d f0 ff ff       	call   8013c5 <read>
	if (r < 0)
  802368:	83 c4 10             	add    $0x10,%esp
  80236b:	85 c0                	test   %eax,%eax
  80236d:	78 08                	js     802377 <getchar+0x22>
	if (r < 1)
  80236f:	85 c0                	test   %eax,%eax
  802371:	7e 06                	jle    802379 <getchar+0x24>
	return c;
  802373:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    
		return -E_EOF;
  802379:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80237e:	eb f7                	jmp    802377 <getchar+0x22>

00802380 <iscons>:
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802386:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802389:	50                   	push   %eax
  80238a:	ff 75 08             	pushl  0x8(%ebp)
  80238d:	e8 c2 ed ff ff       	call   801154 <fd_lookup>
  802392:	83 c4 10             	add    $0x10,%esp
  802395:	85 c0                	test   %eax,%eax
  802397:	78 11                	js     8023aa <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 15 44 30 80 00    	mov    0x803044,%edx
  8023a2:	39 10                	cmp    %edx,(%eax)
  8023a4:	0f 94 c0             	sete   %al
  8023a7:	0f b6 c0             	movzbl %al,%eax
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <opencons>:
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
  8023af:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023b5:	50                   	push   %eax
  8023b6:	e8 4a ed ff ff       	call   801105 <fd_alloc>
  8023bb:	83 c4 10             	add    $0x10,%esp
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	78 3a                	js     8023fc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023c2:	83 ec 04             	sub    $0x4,%esp
  8023c5:	68 07 04 00 00       	push   $0x407
  8023ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8023cd:	6a 00                	push   $0x0
  8023cf:	e8 e0 e8 ff ff       	call   800cb4 <sys_page_alloc>
  8023d4:	83 c4 10             	add    $0x10,%esp
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	78 21                	js     8023fc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 15 44 30 80 00    	mov    0x803044,%edx
  8023e4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023f0:	83 ec 0c             	sub    $0xc,%esp
  8023f3:	50                   	push   %eax
  8023f4:	e8 e5 ec ff ff       	call   8010de <fd2num>
  8023f9:	83 c4 10             	add    $0x10,%esp
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	53                   	push   %ebx
  802402:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  802405:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80240c:	74 0d                	je     80241b <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802416:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802419:	c9                   	leave  
  80241a:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  80241b:	e8 56 e8 ff ff       	call   800c76 <sys_getenvid>
  802420:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  802422:	83 ec 04             	sub    $0x4,%esp
  802425:	6a 07                	push   $0x7
  802427:	68 00 f0 bf ee       	push   $0xeebff000
  80242c:	50                   	push   %eax
  80242d:	e8 82 e8 ff ff       	call   800cb4 <sys_page_alloc>
        	if (r < 0) {
  802432:	83 c4 10             	add    $0x10,%esp
  802435:	85 c0                	test   %eax,%eax
  802437:	78 27                	js     802460 <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  802439:	83 ec 08             	sub    $0x8,%esp
  80243c:	68 72 24 80 00       	push   $0x802472
  802441:	53                   	push   %ebx
  802442:	e8 b8 e9 ff ff       	call   800dff <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  802447:	83 c4 10             	add    $0x10,%esp
  80244a:	85 c0                	test   %eax,%eax
  80244c:	79 c0                	jns    80240e <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  80244e:	50                   	push   %eax
  80244f:	68 e1 2d 80 00       	push   $0x802de1
  802454:	6a 28                	push   $0x28
  802456:	68 f5 2d 80 00       	push   $0x802df5
  80245b:	e8 96 dd ff ff       	call   8001f6 <_panic>
            		panic("pgfault_handler: %e", r);
  802460:	50                   	push   %eax
  802461:	68 e1 2d 80 00       	push   $0x802de1
  802466:	6a 24                	push   $0x24
  802468:	68 f5 2d 80 00       	push   $0x802df5
  80246d:	e8 84 dd ff ff       	call   8001f6 <_panic>

00802472 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802472:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802473:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802478:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80247a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  80247d:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  802481:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  802484:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  802488:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  80248c:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  80248f:	83 c4 08             	add    $0x8,%esp
	popal
  802492:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  802493:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  802496:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  802497:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  802498:	c3                   	ret    

00802499 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
  80249c:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  80249f:	68 03 2e 80 00       	push   $0x802e03
  8024a4:	6a 1a                	push   $0x1a
  8024a6:	68 1c 2e 80 00       	push   $0x802e1c
  8024ab:	e8 46 dd ff ff       	call   8001f6 <_panic>

008024b0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  8024b6:	68 26 2e 80 00       	push   $0x802e26
  8024bb:	6a 2a                	push   $0x2a
  8024bd:	68 1c 2e 80 00       	push   $0x802e1c
  8024c2:	e8 2f dd ff ff       	call   8001f6 <_panic>

008024c7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
  8024ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024cd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024d2:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8024d5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024db:	8b 52 50             	mov    0x50(%edx),%edx
  8024de:	39 ca                	cmp    %ecx,%edx
  8024e0:	74 11                	je     8024f3 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8024e2:	83 c0 01             	add    $0x1,%eax
  8024e5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024ea:	75 e6                	jne    8024d2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f1:	eb 0b                	jmp    8024fe <ipc_find_env+0x37>
			return envs[i].env_id;
  8024f3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024fb:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024fe:	5d                   	pop    %ebp
  8024ff:	c3                   	ret    

00802500 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802506:	89 d0                	mov    %edx,%eax
  802508:	c1 e8 16             	shr    $0x16,%eax
  80250b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802512:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802517:	f6 c1 01             	test   $0x1,%cl
  80251a:	74 1d                	je     802539 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80251c:	c1 ea 0c             	shr    $0xc,%edx
  80251f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802526:	f6 c2 01             	test   $0x1,%dl
  802529:	74 0e                	je     802539 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80252b:	c1 ea 0c             	shr    $0xc,%edx
  80252e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802535:	ef 
  802536:	0f b7 c0             	movzwl %ax,%eax
}
  802539:	5d                   	pop    %ebp
  80253a:	c3                   	ret    
  80253b:	66 90                	xchg   %ax,%ax
  80253d:	66 90                	xchg   %ax,%ax
  80253f:	90                   	nop

00802540 <__udivdi3>:
  802540:	55                   	push   %ebp
  802541:	57                   	push   %edi
  802542:	56                   	push   %esi
  802543:	53                   	push   %ebx
  802544:	83 ec 1c             	sub    $0x1c,%esp
  802547:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80254b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80254f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802553:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802557:	85 d2                	test   %edx,%edx
  802559:	75 35                	jne    802590 <__udivdi3+0x50>
  80255b:	39 f3                	cmp    %esi,%ebx
  80255d:	0f 87 bd 00 00 00    	ja     802620 <__udivdi3+0xe0>
  802563:	85 db                	test   %ebx,%ebx
  802565:	89 d9                	mov    %ebx,%ecx
  802567:	75 0b                	jne    802574 <__udivdi3+0x34>
  802569:	b8 01 00 00 00       	mov    $0x1,%eax
  80256e:	31 d2                	xor    %edx,%edx
  802570:	f7 f3                	div    %ebx
  802572:	89 c1                	mov    %eax,%ecx
  802574:	31 d2                	xor    %edx,%edx
  802576:	89 f0                	mov    %esi,%eax
  802578:	f7 f1                	div    %ecx
  80257a:	89 c6                	mov    %eax,%esi
  80257c:	89 e8                	mov    %ebp,%eax
  80257e:	89 f7                	mov    %esi,%edi
  802580:	f7 f1                	div    %ecx
  802582:	89 fa                	mov    %edi,%edx
  802584:	83 c4 1c             	add    $0x1c,%esp
  802587:	5b                   	pop    %ebx
  802588:	5e                   	pop    %esi
  802589:	5f                   	pop    %edi
  80258a:	5d                   	pop    %ebp
  80258b:	c3                   	ret    
  80258c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802590:	39 f2                	cmp    %esi,%edx
  802592:	77 7c                	ja     802610 <__udivdi3+0xd0>
  802594:	0f bd fa             	bsr    %edx,%edi
  802597:	83 f7 1f             	xor    $0x1f,%edi
  80259a:	0f 84 98 00 00 00    	je     802638 <__udivdi3+0xf8>
  8025a0:	89 f9                	mov    %edi,%ecx
  8025a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025a7:	29 f8                	sub    %edi,%eax
  8025a9:	d3 e2                	shl    %cl,%edx
  8025ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025af:	89 c1                	mov    %eax,%ecx
  8025b1:	89 da                	mov    %ebx,%edx
  8025b3:	d3 ea                	shr    %cl,%edx
  8025b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025b9:	09 d1                	or     %edx,%ecx
  8025bb:	89 f2                	mov    %esi,%edx
  8025bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025c1:	89 f9                	mov    %edi,%ecx
  8025c3:	d3 e3                	shl    %cl,%ebx
  8025c5:	89 c1                	mov    %eax,%ecx
  8025c7:	d3 ea                	shr    %cl,%edx
  8025c9:	89 f9                	mov    %edi,%ecx
  8025cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025cf:	d3 e6                	shl    %cl,%esi
  8025d1:	89 eb                	mov    %ebp,%ebx
  8025d3:	89 c1                	mov    %eax,%ecx
  8025d5:	d3 eb                	shr    %cl,%ebx
  8025d7:	09 de                	or     %ebx,%esi
  8025d9:	89 f0                	mov    %esi,%eax
  8025db:	f7 74 24 08          	divl   0x8(%esp)
  8025df:	89 d6                	mov    %edx,%esi
  8025e1:	89 c3                	mov    %eax,%ebx
  8025e3:	f7 64 24 0c          	mull   0xc(%esp)
  8025e7:	39 d6                	cmp    %edx,%esi
  8025e9:	72 0c                	jb     8025f7 <__udivdi3+0xb7>
  8025eb:	89 f9                	mov    %edi,%ecx
  8025ed:	d3 e5                	shl    %cl,%ebp
  8025ef:	39 c5                	cmp    %eax,%ebp
  8025f1:	73 5d                	jae    802650 <__udivdi3+0x110>
  8025f3:	39 d6                	cmp    %edx,%esi
  8025f5:	75 59                	jne    802650 <__udivdi3+0x110>
  8025f7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025fa:	31 ff                	xor    %edi,%edi
  8025fc:	89 fa                	mov    %edi,%edx
  8025fe:	83 c4 1c             	add    $0x1c,%esp
  802601:	5b                   	pop    %ebx
  802602:	5e                   	pop    %esi
  802603:	5f                   	pop    %edi
  802604:	5d                   	pop    %ebp
  802605:	c3                   	ret    
  802606:	8d 76 00             	lea    0x0(%esi),%esi
  802609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802610:	31 ff                	xor    %edi,%edi
  802612:	31 c0                	xor    %eax,%eax
  802614:	89 fa                	mov    %edi,%edx
  802616:	83 c4 1c             	add    $0x1c,%esp
  802619:	5b                   	pop    %ebx
  80261a:	5e                   	pop    %esi
  80261b:	5f                   	pop    %edi
  80261c:	5d                   	pop    %ebp
  80261d:	c3                   	ret    
  80261e:	66 90                	xchg   %ax,%ax
  802620:	31 ff                	xor    %edi,%edi
  802622:	89 e8                	mov    %ebp,%eax
  802624:	89 f2                	mov    %esi,%edx
  802626:	f7 f3                	div    %ebx
  802628:	89 fa                	mov    %edi,%edx
  80262a:	83 c4 1c             	add    $0x1c,%esp
  80262d:	5b                   	pop    %ebx
  80262e:	5e                   	pop    %esi
  80262f:	5f                   	pop    %edi
  802630:	5d                   	pop    %ebp
  802631:	c3                   	ret    
  802632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802638:	39 f2                	cmp    %esi,%edx
  80263a:	72 06                	jb     802642 <__udivdi3+0x102>
  80263c:	31 c0                	xor    %eax,%eax
  80263e:	39 eb                	cmp    %ebp,%ebx
  802640:	77 d2                	ja     802614 <__udivdi3+0xd4>
  802642:	b8 01 00 00 00       	mov    $0x1,%eax
  802647:	eb cb                	jmp    802614 <__udivdi3+0xd4>
  802649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802650:	89 d8                	mov    %ebx,%eax
  802652:	31 ff                	xor    %edi,%edi
  802654:	eb be                	jmp    802614 <__udivdi3+0xd4>
  802656:	66 90                	xchg   %ax,%ax
  802658:	66 90                	xchg   %ax,%ax
  80265a:	66 90                	xchg   %ax,%ax
  80265c:	66 90                	xchg   %ax,%ax
  80265e:	66 90                	xchg   %ax,%ax

00802660 <__umoddi3>:
  802660:	55                   	push   %ebp
  802661:	57                   	push   %edi
  802662:	56                   	push   %esi
  802663:	53                   	push   %ebx
  802664:	83 ec 1c             	sub    $0x1c,%esp
  802667:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80266b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80266f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802673:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802677:	85 ed                	test   %ebp,%ebp
  802679:	89 f0                	mov    %esi,%eax
  80267b:	89 da                	mov    %ebx,%edx
  80267d:	75 19                	jne    802698 <__umoddi3+0x38>
  80267f:	39 df                	cmp    %ebx,%edi
  802681:	0f 86 b1 00 00 00    	jbe    802738 <__umoddi3+0xd8>
  802687:	f7 f7                	div    %edi
  802689:	89 d0                	mov    %edx,%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	83 c4 1c             	add    $0x1c,%esp
  802690:	5b                   	pop    %ebx
  802691:	5e                   	pop    %esi
  802692:	5f                   	pop    %edi
  802693:	5d                   	pop    %ebp
  802694:	c3                   	ret    
  802695:	8d 76 00             	lea    0x0(%esi),%esi
  802698:	39 dd                	cmp    %ebx,%ebp
  80269a:	77 f1                	ja     80268d <__umoddi3+0x2d>
  80269c:	0f bd cd             	bsr    %ebp,%ecx
  80269f:	83 f1 1f             	xor    $0x1f,%ecx
  8026a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8026a6:	0f 84 b4 00 00 00    	je     802760 <__umoddi3+0x100>
  8026ac:	b8 20 00 00 00       	mov    $0x20,%eax
  8026b1:	89 c2                	mov    %eax,%edx
  8026b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026b7:	29 c2                	sub    %eax,%edx
  8026b9:	89 c1                	mov    %eax,%ecx
  8026bb:	89 f8                	mov    %edi,%eax
  8026bd:	d3 e5                	shl    %cl,%ebp
  8026bf:	89 d1                	mov    %edx,%ecx
  8026c1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026c5:	d3 e8                	shr    %cl,%eax
  8026c7:	09 c5                	or     %eax,%ebp
  8026c9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026cd:	89 c1                	mov    %eax,%ecx
  8026cf:	d3 e7                	shl    %cl,%edi
  8026d1:	89 d1                	mov    %edx,%ecx
  8026d3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026d7:	89 df                	mov    %ebx,%edi
  8026d9:	d3 ef                	shr    %cl,%edi
  8026db:	89 c1                	mov    %eax,%ecx
  8026dd:	89 f0                	mov    %esi,%eax
  8026df:	d3 e3                	shl    %cl,%ebx
  8026e1:	89 d1                	mov    %edx,%ecx
  8026e3:	89 fa                	mov    %edi,%edx
  8026e5:	d3 e8                	shr    %cl,%eax
  8026e7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ec:	09 d8                	or     %ebx,%eax
  8026ee:	f7 f5                	div    %ebp
  8026f0:	d3 e6                	shl    %cl,%esi
  8026f2:	89 d1                	mov    %edx,%ecx
  8026f4:	f7 64 24 08          	mull   0x8(%esp)
  8026f8:	39 d1                	cmp    %edx,%ecx
  8026fa:	89 c3                	mov    %eax,%ebx
  8026fc:	89 d7                	mov    %edx,%edi
  8026fe:	72 06                	jb     802706 <__umoddi3+0xa6>
  802700:	75 0e                	jne    802710 <__umoddi3+0xb0>
  802702:	39 c6                	cmp    %eax,%esi
  802704:	73 0a                	jae    802710 <__umoddi3+0xb0>
  802706:	2b 44 24 08          	sub    0x8(%esp),%eax
  80270a:	19 ea                	sbb    %ebp,%edx
  80270c:	89 d7                	mov    %edx,%edi
  80270e:	89 c3                	mov    %eax,%ebx
  802710:	89 ca                	mov    %ecx,%edx
  802712:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802717:	29 de                	sub    %ebx,%esi
  802719:	19 fa                	sbb    %edi,%edx
  80271b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80271f:	89 d0                	mov    %edx,%eax
  802721:	d3 e0                	shl    %cl,%eax
  802723:	89 d9                	mov    %ebx,%ecx
  802725:	d3 ee                	shr    %cl,%esi
  802727:	d3 ea                	shr    %cl,%edx
  802729:	09 f0                	or     %esi,%eax
  80272b:	83 c4 1c             	add    $0x1c,%esp
  80272e:	5b                   	pop    %ebx
  80272f:	5e                   	pop    %esi
  802730:	5f                   	pop    %edi
  802731:	5d                   	pop    %ebp
  802732:	c3                   	ret    
  802733:	90                   	nop
  802734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802738:	85 ff                	test   %edi,%edi
  80273a:	89 f9                	mov    %edi,%ecx
  80273c:	75 0b                	jne    802749 <__umoddi3+0xe9>
  80273e:	b8 01 00 00 00       	mov    $0x1,%eax
  802743:	31 d2                	xor    %edx,%edx
  802745:	f7 f7                	div    %edi
  802747:	89 c1                	mov    %eax,%ecx
  802749:	89 d8                	mov    %ebx,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	f7 f1                	div    %ecx
  80274f:	89 f0                	mov    %esi,%eax
  802751:	f7 f1                	div    %ecx
  802753:	e9 31 ff ff ff       	jmp    802689 <__umoddi3+0x29>
  802758:	90                   	nop
  802759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802760:	39 dd                	cmp    %ebx,%ebp
  802762:	72 08                	jb     80276c <__umoddi3+0x10c>
  802764:	39 f7                	cmp    %esi,%edi
  802766:	0f 87 21 ff ff ff    	ja     80268d <__umoddi3+0x2d>
  80276c:	89 da                	mov    %ebx,%edx
  80276e:	89 f0                	mov    %esi,%eax
  802770:	29 f8                	sub    %edi,%eax
  802772:	19 ea                	sbb    %ebp,%edx
  802774:	e9 14 ff ff ff       	jmp    80268d <__umoddi3+0x2d>
