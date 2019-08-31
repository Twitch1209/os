
obj/user/sendpage.debug：     文件格式 elf32-i386


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
  80002c:	e8 6e 01 00 00       	call   80019f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 41 0e 00 00       	call   800e7f <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 85 9e 00 00 00    	jne    8000e7 <umain+0xb4>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	68 00 00 b0 00       	push   $0xb00000
  800053:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800056:	50                   	push   %eax
  800057:	e8 45 10 00 00       	call   8010a1 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  80005c:	83 c4 0c             	add    $0xc,%esp
  80005f:	68 00 00 b0 00       	push   $0xb00000
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	68 20 21 80 00       	push   $0x802120
  80006c:	e8 23 02 00 00       	call   800294 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800071:	83 c4 04             	add    $0x4,%esp
  800074:	ff 35 04 30 80 00    	pushl  0x803004
  80007a:	e8 c8 07 00 00       	call   800847 <strlen>
  80007f:	83 c4 0c             	add    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	ff 35 04 30 80 00    	pushl  0x803004
  800089:	68 00 00 b0 00       	push   $0xb00000
  80008e:	e8 b7 08 00 00       	call   80094a <strncmp>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	85 c0                	test   %eax,%eax
  800098:	74 3b                	je     8000d5 <umain+0xa2>
			cprintf("child received correct message\n");

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	ff 35 00 30 80 00    	pushl  0x803000
  8000a3:	e8 9f 07 00 00       	call   800847 <strlen>
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	83 c0 01             	add    $0x1,%eax
  8000ae:	50                   	push   %eax
  8000af:	ff 35 00 30 80 00    	pushl  0x803000
  8000b5:	68 00 00 b0 00       	push   $0xb00000
  8000ba:	e8 b5 09 00 00       	call   800a74 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  8000bf:	6a 07                	push   $0x7
  8000c1:	68 00 00 b0 00       	push   $0xb00000
  8000c6:	6a 00                	push   $0x0
  8000c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8000cb:	e8 e8 0f 00 00       	call   8010b8 <ipc_send>
		return;
  8000d0:	83 c4 20             	add    $0x20,%esp
	ipc_recv(&who, TEMP_ADDR, 0);
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
		cprintf("parent received correct message\n");
	return;
}
  8000d3:	c9                   	leave  
  8000d4:	c3                   	ret    
			cprintf("child received correct message\n");
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 34 21 80 00       	push   $0x802134
  8000dd:	e8 b2 01 00 00       	call   800294 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb b3                	jmp    80009a <umain+0x67>
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8000e7:	a1 04 40 80 00       	mov    0x804004,%eax
  8000ec:	8b 40 48             	mov    0x48(%eax),%eax
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	6a 07                	push   $0x7
  8000f4:	68 00 00 a0 00       	push   $0xa00000
  8000f9:	50                   	push   %eax
  8000fa:	e8 78 0b 00 00       	call   800c77 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8000ff:	83 c4 04             	add    $0x4,%esp
  800102:	ff 35 04 30 80 00    	pushl  0x803004
  800108:	e8 3a 07 00 00       	call   800847 <strlen>
  80010d:	83 c4 0c             	add    $0xc,%esp
  800110:	83 c0 01             	add    $0x1,%eax
  800113:	50                   	push   %eax
  800114:	ff 35 04 30 80 00    	pushl  0x803004
  80011a:	68 00 00 a0 00       	push   $0xa00000
  80011f:	e8 50 09 00 00       	call   800a74 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800124:	6a 07                	push   $0x7
  800126:	68 00 00 a0 00       	push   $0xa00000
  80012b:	6a 00                	push   $0x0
  80012d:	ff 75 f4             	pushl  -0xc(%ebp)
  800130:	e8 83 0f 00 00       	call   8010b8 <ipc_send>
	ipc_recv(&who, TEMP_ADDR, 0);
  800135:	83 c4 1c             	add    $0x1c,%esp
  800138:	6a 00                	push   $0x0
  80013a:	68 00 00 a0 00       	push   $0xa00000
  80013f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800142:	50                   	push   %eax
  800143:	e8 59 0f 00 00       	call   8010a1 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  800148:	83 c4 0c             	add    $0xc,%esp
  80014b:	68 00 00 a0 00       	push   $0xa00000
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	68 20 21 80 00       	push   $0x802120
  800158:	e8 37 01 00 00       	call   800294 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  80015d:	83 c4 04             	add    $0x4,%esp
  800160:	ff 35 00 30 80 00    	pushl  0x803000
  800166:	e8 dc 06 00 00       	call   800847 <strlen>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	50                   	push   %eax
  80016f:	ff 35 00 30 80 00    	pushl  0x803000
  800175:	68 00 00 a0 00       	push   $0xa00000
  80017a:	e8 cb 07 00 00       	call   80094a <strncmp>
  80017f:	83 c4 10             	add    $0x10,%esp
  800182:	85 c0                	test   %eax,%eax
  800184:	0f 85 49 ff ff ff    	jne    8000d3 <umain+0xa0>
		cprintf("parent received correct message\n");
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	68 54 21 80 00       	push   $0x802154
  800192:	e8 fd 00 00 00       	call   800294 <cprintf>
  800197:	83 c4 10             	add    $0x10,%esp
  80019a:	e9 34 ff ff ff       	jmp    8000d3 <umain+0xa0>

0080019f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	56                   	push   %esi
  8001a3:	53                   	push   %ebx
  8001a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001a7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001aa:	e8 8a 0a 00 00       	call   800c39 <sys_getenvid>
  8001af:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001b7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bc:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c1:	85 db                	test   %ebx,%ebx
  8001c3:	7e 07                	jle    8001cc <libmain+0x2d>
		binaryname = argv[0];
  8001c5:	8b 06                	mov    (%esi),%eax
  8001c7:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	e8 5d fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001d6:	e8 0a 00 00 00       	call   8001e5 <exit>
}
  8001db:	83 c4 10             	add    $0x10,%esp
  8001de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e1:	5b                   	pop    %ebx
  8001e2:	5e                   	pop    %esi
  8001e3:	5d                   	pop    %ebp
  8001e4:	c3                   	ret    

008001e5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001eb:	e8 ee 10 00 00       	call   8012de <close_all>
	sys_env_destroy(0);
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	6a 00                	push   $0x0
  8001f5:	e8 fe 09 00 00       	call   800bf8 <sys_env_destroy>
}
  8001fa:	83 c4 10             	add    $0x10,%esp
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	53                   	push   %ebx
  800203:	83 ec 04             	sub    $0x4,%esp
  800206:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800209:	8b 13                	mov    (%ebx),%edx
  80020b:	8d 42 01             	lea    0x1(%edx),%eax
  80020e:	89 03                	mov    %eax,(%ebx)
  800210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800213:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800217:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021c:	74 09                	je     800227 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80021e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800222:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800225:	c9                   	leave  
  800226:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	68 ff 00 00 00       	push   $0xff
  80022f:	8d 43 08             	lea    0x8(%ebx),%eax
  800232:	50                   	push   %eax
  800233:	e8 83 09 00 00       	call   800bbb <sys_cputs>
		b->idx = 0;
  800238:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80023e:	83 c4 10             	add    $0x10,%esp
  800241:	eb db                	jmp    80021e <putch+0x1f>

00800243 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80024c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800253:	00 00 00 
	b.cnt = 0;
  800256:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800260:	ff 75 0c             	pushl  0xc(%ebp)
  800263:	ff 75 08             	pushl  0x8(%ebp)
  800266:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026c:	50                   	push   %eax
  80026d:	68 ff 01 80 00       	push   $0x8001ff
  800272:	e8 1a 01 00 00       	call   800391 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800277:	83 c4 08             	add    $0x8,%esp
  80027a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800280:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800286:	50                   	push   %eax
  800287:	e8 2f 09 00 00       	call   800bbb <sys_cputs>

	return b.cnt;
}
  80028c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80029a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80029d:	50                   	push   %eax
  80029e:	ff 75 08             	pushl  0x8(%ebp)
  8002a1:	e8 9d ff ff ff       	call   800243 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	57                   	push   %edi
  8002ac:	56                   	push   %esi
  8002ad:	53                   	push   %ebx
  8002ae:	83 ec 1c             	sub    $0x1c,%esp
  8002b1:	89 c7                	mov    %eax,%edi
  8002b3:	89 d6                	mov    %edx,%esi
  8002b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002be:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002cc:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002cf:	39 d3                	cmp    %edx,%ebx
  8002d1:	72 05                	jb     8002d8 <printnum+0x30>
  8002d3:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002d6:	77 7a                	ja     800352 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	ff 75 18             	pushl  0x18(%ebp)
  8002de:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002e4:	53                   	push   %ebx
  8002e5:	ff 75 10             	pushl  0x10(%ebp)
  8002e8:	83 ec 08             	sub    $0x8,%esp
  8002eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f7:	e8 e4 1b 00 00       	call   801ee0 <__udivdi3>
  8002fc:	83 c4 18             	add    $0x18,%esp
  8002ff:	52                   	push   %edx
  800300:	50                   	push   %eax
  800301:	89 f2                	mov    %esi,%edx
  800303:	89 f8                	mov    %edi,%eax
  800305:	e8 9e ff ff ff       	call   8002a8 <printnum>
  80030a:	83 c4 20             	add    $0x20,%esp
  80030d:	eb 13                	jmp    800322 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	56                   	push   %esi
  800313:	ff 75 18             	pushl  0x18(%ebp)
  800316:	ff d7                	call   *%edi
  800318:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80031b:	83 eb 01             	sub    $0x1,%ebx
  80031e:	85 db                	test   %ebx,%ebx
  800320:	7f ed                	jg     80030f <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800322:	83 ec 08             	sub    $0x8,%esp
  800325:	56                   	push   %esi
  800326:	83 ec 04             	sub    $0x4,%esp
  800329:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032c:	ff 75 e0             	pushl  -0x20(%ebp)
  80032f:	ff 75 dc             	pushl  -0x24(%ebp)
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 c6 1c 00 00       	call   802000 <__umoddi3>
  80033a:	83 c4 14             	add    $0x14,%esp
  80033d:	0f be 80 cc 21 80 00 	movsbl 0x8021cc(%eax),%eax
  800344:	50                   	push   %eax
  800345:	ff d7                	call   *%edi
}
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034d:	5b                   	pop    %ebx
  80034e:	5e                   	pop    %esi
  80034f:	5f                   	pop    %edi
  800350:	5d                   	pop    %ebp
  800351:	c3                   	ret    
  800352:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800355:	eb c4                	jmp    80031b <printnum+0x73>

00800357 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800361:	8b 10                	mov    (%eax),%edx
  800363:	3b 50 04             	cmp    0x4(%eax),%edx
  800366:	73 0a                	jae    800372 <sprintputch+0x1b>
		*b->buf++ = ch;
  800368:	8d 4a 01             	lea    0x1(%edx),%ecx
  80036b:	89 08                	mov    %ecx,(%eax)
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	88 02                	mov    %al,(%edx)
}
  800372:	5d                   	pop    %ebp
  800373:	c3                   	ret    

00800374 <printfmt>:
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80037a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80037d:	50                   	push   %eax
  80037e:	ff 75 10             	pushl  0x10(%ebp)
  800381:	ff 75 0c             	pushl  0xc(%ebp)
  800384:	ff 75 08             	pushl  0x8(%ebp)
  800387:	e8 05 00 00 00       	call   800391 <vprintfmt>
}
  80038c:	83 c4 10             	add    $0x10,%esp
  80038f:	c9                   	leave  
  800390:	c3                   	ret    

00800391 <vprintfmt>:
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	57                   	push   %edi
  800395:	56                   	push   %esi
  800396:	53                   	push   %ebx
  800397:	83 ec 2c             	sub    $0x2c,%esp
  80039a:	8b 75 08             	mov    0x8(%ebp),%esi
  80039d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003a0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a3:	e9 8c 03 00 00       	jmp    800734 <vprintfmt+0x3a3>
		padc = ' ';
  8003a8:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003ac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003b3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003ba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003c1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c6:	8d 47 01             	lea    0x1(%edi),%eax
  8003c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003cc:	0f b6 17             	movzbl (%edi),%edx
  8003cf:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003d2:	3c 55                	cmp    $0x55,%al
  8003d4:	0f 87 dd 03 00 00    	ja     8007b7 <vprintfmt+0x426>
  8003da:	0f b6 c0             	movzbl %al,%eax
  8003dd:	ff 24 85 00 23 80 00 	jmp    *0x802300(,%eax,4)
  8003e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e7:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003eb:	eb d9                	jmp    8003c6 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003f0:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003f4:	eb d0                	jmp    8003c6 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	0f b6 d2             	movzbl %dl,%edx
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800401:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800404:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800407:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80040b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80040e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800411:	83 f9 09             	cmp    $0x9,%ecx
  800414:	77 55                	ja     80046b <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800416:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800419:	eb e9                	jmp    800404 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80041b:	8b 45 14             	mov    0x14(%ebp),%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800423:	8b 45 14             	mov    0x14(%ebp),%eax
  800426:	8d 40 04             	lea    0x4(%eax),%eax
  800429:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800433:	79 91                	jns    8003c6 <vprintfmt+0x35>
				width = precision, precision = -1;
  800435:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800438:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800442:	eb 82                	jmp    8003c6 <vprintfmt+0x35>
  800444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800447:	85 c0                	test   %eax,%eax
  800449:	ba 00 00 00 00       	mov    $0x0,%edx
  80044e:	0f 49 d0             	cmovns %eax,%edx
  800451:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800454:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800457:	e9 6a ff ff ff       	jmp    8003c6 <vprintfmt+0x35>
  80045c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800466:	e9 5b ff ff ff       	jmp    8003c6 <vprintfmt+0x35>
  80046b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80046e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800471:	eb bc                	jmp    80042f <vprintfmt+0x9e>
			lflag++;
  800473:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800476:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800479:	e9 48 ff ff ff       	jmp    8003c6 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80047e:	8b 45 14             	mov    0x14(%ebp),%eax
  800481:	8d 78 04             	lea    0x4(%eax),%edi
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	53                   	push   %ebx
  800488:	ff 30                	pushl  (%eax)
  80048a:	ff d6                	call   *%esi
			break;
  80048c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80048f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800492:	e9 9a 02 00 00       	jmp    800731 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8d 78 04             	lea    0x4(%eax),%edi
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	99                   	cltd   
  8004a0:	31 d0                	xor    %edx,%eax
  8004a2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a4:	83 f8 0f             	cmp    $0xf,%eax
  8004a7:	7f 23                	jg     8004cc <vprintfmt+0x13b>
  8004a9:	8b 14 85 60 24 80 00 	mov    0x802460(,%eax,4),%edx
  8004b0:	85 d2                	test   %edx,%edx
  8004b2:	74 18                	je     8004cc <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8004b4:	52                   	push   %edx
  8004b5:	68 8d 26 80 00       	push   $0x80268d
  8004ba:	53                   	push   %ebx
  8004bb:	56                   	push   %esi
  8004bc:	e8 b3 fe ff ff       	call   800374 <printfmt>
  8004c1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c7:	e9 65 02 00 00       	jmp    800731 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8004cc:	50                   	push   %eax
  8004cd:	68 e4 21 80 00       	push   $0x8021e4
  8004d2:	53                   	push   %ebx
  8004d3:	56                   	push   %esi
  8004d4:	e8 9b fe ff ff       	call   800374 <printfmt>
  8004d9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004dc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004df:	e9 4d 02 00 00       	jmp    800731 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e7:	83 c0 04             	add    $0x4,%eax
  8004ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f0:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004f2:	85 ff                	test   %edi,%edi
  8004f4:	b8 dd 21 80 00       	mov    $0x8021dd,%eax
  8004f9:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800500:	0f 8e bd 00 00 00    	jle    8005c3 <vprintfmt+0x232>
  800506:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80050a:	75 0e                	jne    80051a <vprintfmt+0x189>
  80050c:	89 75 08             	mov    %esi,0x8(%ebp)
  80050f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800512:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800515:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800518:	eb 6d                	jmp    800587 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	ff 75 d0             	pushl  -0x30(%ebp)
  800520:	57                   	push   %edi
  800521:	e8 39 03 00 00       	call   80085f <strnlen>
  800526:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800529:	29 c1                	sub    %eax,%ecx
  80052b:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80052e:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800531:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800535:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800538:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80053b:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80053d:	eb 0f                	jmp    80054e <vprintfmt+0x1bd>
					putch(padc, putdat);
  80053f:	83 ec 08             	sub    $0x8,%esp
  800542:	53                   	push   %ebx
  800543:	ff 75 e0             	pushl  -0x20(%ebp)
  800546:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800548:	83 ef 01             	sub    $0x1,%edi
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	85 ff                	test   %edi,%edi
  800550:	7f ed                	jg     80053f <vprintfmt+0x1ae>
  800552:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800555:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800558:	85 c9                	test   %ecx,%ecx
  80055a:	b8 00 00 00 00       	mov    $0x0,%eax
  80055f:	0f 49 c1             	cmovns %ecx,%eax
  800562:	29 c1                	sub    %eax,%ecx
  800564:	89 75 08             	mov    %esi,0x8(%ebp)
  800567:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80056a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80056d:	89 cb                	mov    %ecx,%ebx
  80056f:	eb 16                	jmp    800587 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800571:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800575:	75 31                	jne    8005a8 <vprintfmt+0x217>
					putch(ch, putdat);
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 0c             	pushl  0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	ff 55 08             	call   *0x8(%ebp)
  800581:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800584:	83 eb 01             	sub    $0x1,%ebx
  800587:	83 c7 01             	add    $0x1,%edi
  80058a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80058e:	0f be c2             	movsbl %dl,%eax
  800591:	85 c0                	test   %eax,%eax
  800593:	74 59                	je     8005ee <vprintfmt+0x25d>
  800595:	85 f6                	test   %esi,%esi
  800597:	78 d8                	js     800571 <vprintfmt+0x1e0>
  800599:	83 ee 01             	sub    $0x1,%esi
  80059c:	79 d3                	jns    800571 <vprintfmt+0x1e0>
  80059e:	89 df                	mov    %ebx,%edi
  8005a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005a6:	eb 37                	jmp    8005df <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a8:	0f be d2             	movsbl %dl,%edx
  8005ab:	83 ea 20             	sub    $0x20,%edx
  8005ae:	83 fa 5e             	cmp    $0x5e,%edx
  8005b1:	76 c4                	jbe    800577 <vprintfmt+0x1e6>
					putch('?', putdat);
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 0c             	pushl  0xc(%ebp)
  8005b9:	6a 3f                	push   $0x3f
  8005bb:	ff 55 08             	call   *0x8(%ebp)
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	eb c1                	jmp    800584 <vprintfmt+0x1f3>
  8005c3:	89 75 08             	mov    %esi,0x8(%ebp)
  8005c6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005c9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005cc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005cf:	eb b6                	jmp    800587 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005d1:	83 ec 08             	sub    $0x8,%esp
  8005d4:	53                   	push   %ebx
  8005d5:	6a 20                	push   $0x20
  8005d7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d9:	83 ef 01             	sub    $0x1,%edi
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	85 ff                	test   %edi,%edi
  8005e1:	7f ee                	jg     8005d1 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	e9 43 01 00 00       	jmp    800731 <vprintfmt+0x3a0>
  8005ee:	89 df                	mov    %ebx,%edi
  8005f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005f6:	eb e7                	jmp    8005df <vprintfmt+0x24e>
	if (lflag >= 2)
  8005f8:	83 f9 01             	cmp    $0x1,%ecx
  8005fb:	7e 3f                	jle    80063c <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 50 04             	mov    0x4(%eax),%edx
  800603:	8b 00                	mov    (%eax),%eax
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 40 08             	lea    0x8(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800614:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800618:	79 5c                	jns    800676 <vprintfmt+0x2e5>
				putch('-', putdat);
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	53                   	push   %ebx
  80061e:	6a 2d                	push   $0x2d
  800620:	ff d6                	call   *%esi
				num = -(long long) num;
  800622:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800625:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800628:	f7 da                	neg    %edx
  80062a:	83 d1 00             	adc    $0x0,%ecx
  80062d:	f7 d9                	neg    %ecx
  80062f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800632:	b8 0a 00 00 00       	mov    $0xa,%eax
  800637:	e9 db 00 00 00       	jmp    800717 <vprintfmt+0x386>
	else if (lflag)
  80063c:	85 c9                	test   %ecx,%ecx
  80063e:	75 1b                	jne    80065b <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800648:	89 c1                	mov    %eax,%ecx
  80064a:	c1 f9 1f             	sar    $0x1f,%ecx
  80064d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8d 40 04             	lea    0x4(%eax),%eax
  800656:	89 45 14             	mov    %eax,0x14(%ebp)
  800659:	eb b9                	jmp    800614 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800663:	89 c1                	mov    %eax,%ecx
  800665:	c1 f9 1f             	sar    $0x1f,%ecx
  800668:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
  800674:	eb 9e                	jmp    800614 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800676:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800679:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80067c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800681:	e9 91 00 00 00       	jmp    800717 <vprintfmt+0x386>
	if (lflag >= 2)
  800686:	83 f9 01             	cmp    $0x1,%ecx
  800689:	7e 15                	jle    8006a0 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 10                	mov    (%eax),%edx
  800690:	8b 48 04             	mov    0x4(%eax),%ecx
  800693:	8d 40 08             	lea    0x8(%eax),%eax
  800696:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800699:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069e:	eb 77                	jmp    800717 <vprintfmt+0x386>
	else if (lflag)
  8006a0:	85 c9                	test   %ecx,%ecx
  8006a2:	75 17                	jne    8006bb <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	8b 10                	mov    (%eax),%edx
  8006a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ae:	8d 40 04             	lea    0x4(%eax),%eax
  8006b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b9:	eb 5c                	jmp    800717 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8b 10                	mov    (%eax),%edx
  8006c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c5:	8d 40 04             	lea    0x4(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d0:	eb 45                	jmp    800717 <vprintfmt+0x386>
			putch('X', putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	6a 58                	push   $0x58
  8006d8:	ff d6                	call   *%esi
			putch('X', putdat);
  8006da:	83 c4 08             	add    $0x8,%esp
  8006dd:	53                   	push   %ebx
  8006de:	6a 58                	push   $0x58
  8006e0:	ff d6                	call   *%esi
			putch('X', putdat);
  8006e2:	83 c4 08             	add    $0x8,%esp
  8006e5:	53                   	push   %ebx
  8006e6:	6a 58                	push   $0x58
  8006e8:	ff d6                	call   *%esi
			break;
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	eb 42                	jmp    800731 <vprintfmt+0x3a0>
			putch('0', putdat);
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	53                   	push   %ebx
  8006f3:	6a 30                	push   $0x30
  8006f5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f7:	83 c4 08             	add    $0x8,%esp
  8006fa:	53                   	push   %ebx
  8006fb:	6a 78                	push   $0x78
  8006fd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8b 10                	mov    (%eax),%edx
  800704:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800709:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80070c:	8d 40 04             	lea    0x4(%eax),%eax
  80070f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800712:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800717:	83 ec 0c             	sub    $0xc,%esp
  80071a:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80071e:	57                   	push   %edi
  80071f:	ff 75 e0             	pushl  -0x20(%ebp)
  800722:	50                   	push   %eax
  800723:	51                   	push   %ecx
  800724:	52                   	push   %edx
  800725:	89 da                	mov    %ebx,%edx
  800727:	89 f0                	mov    %esi,%eax
  800729:	e8 7a fb ff ff       	call   8002a8 <printnum>
			break;
  80072e:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800731:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800734:	83 c7 01             	add    $0x1,%edi
  800737:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80073b:	83 f8 25             	cmp    $0x25,%eax
  80073e:	0f 84 64 fc ff ff    	je     8003a8 <vprintfmt+0x17>
			if (ch == '\0')
  800744:	85 c0                	test   %eax,%eax
  800746:	0f 84 8b 00 00 00    	je     8007d7 <vprintfmt+0x446>
			putch(ch, putdat);
  80074c:	83 ec 08             	sub    $0x8,%esp
  80074f:	53                   	push   %ebx
  800750:	50                   	push   %eax
  800751:	ff d6                	call   *%esi
  800753:	83 c4 10             	add    $0x10,%esp
  800756:	eb dc                	jmp    800734 <vprintfmt+0x3a3>
	if (lflag >= 2)
  800758:	83 f9 01             	cmp    $0x1,%ecx
  80075b:	7e 15                	jle    800772 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8b 10                	mov    (%eax),%edx
  800762:	8b 48 04             	mov    0x4(%eax),%ecx
  800765:	8d 40 08             	lea    0x8(%eax),%eax
  800768:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076b:	b8 10 00 00 00       	mov    $0x10,%eax
  800770:	eb a5                	jmp    800717 <vprintfmt+0x386>
	else if (lflag)
  800772:	85 c9                	test   %ecx,%ecx
  800774:	75 17                	jne    80078d <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8b 10                	mov    (%eax),%edx
  80077b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800780:	8d 40 04             	lea    0x4(%eax),%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800786:	b8 10 00 00 00       	mov    $0x10,%eax
  80078b:	eb 8a                	jmp    800717 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8b 10                	mov    (%eax),%edx
  800792:	b9 00 00 00 00       	mov    $0x0,%ecx
  800797:	8d 40 04             	lea    0x4(%eax),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079d:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a2:	e9 70 ff ff ff       	jmp    800717 <vprintfmt+0x386>
			putch(ch, putdat);
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	53                   	push   %ebx
  8007ab:	6a 25                	push   $0x25
  8007ad:	ff d6                	call   *%esi
			break;
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	e9 7a ff ff ff       	jmp    800731 <vprintfmt+0x3a0>
			putch('%', putdat);
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	53                   	push   %ebx
  8007bb:	6a 25                	push   $0x25
  8007bd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	89 f8                	mov    %edi,%eax
  8007c4:	eb 03                	jmp    8007c9 <vprintfmt+0x438>
  8007c6:	83 e8 01             	sub    $0x1,%eax
  8007c9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007cd:	75 f7                	jne    8007c6 <vprintfmt+0x435>
  8007cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d2:	e9 5a ff ff ff       	jmp    800731 <vprintfmt+0x3a0>
}
  8007d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007da:	5b                   	pop    %ebx
  8007db:	5e                   	pop    %esi
  8007dc:	5f                   	pop    %edi
  8007dd:	5d                   	pop    %ebp
  8007de:	c3                   	ret    

008007df <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	83 ec 18             	sub    $0x18,%esp
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007ee:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007fc:	85 c0                	test   %eax,%eax
  8007fe:	74 26                	je     800826 <vsnprintf+0x47>
  800800:	85 d2                	test   %edx,%edx
  800802:	7e 22                	jle    800826 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800804:	ff 75 14             	pushl  0x14(%ebp)
  800807:	ff 75 10             	pushl  0x10(%ebp)
  80080a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80080d:	50                   	push   %eax
  80080e:	68 57 03 80 00       	push   $0x800357
  800813:	e8 79 fb ff ff       	call   800391 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80081e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800821:	83 c4 10             	add    $0x10,%esp
}
  800824:	c9                   	leave  
  800825:	c3                   	ret    
		return -E_INVAL;
  800826:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80082b:	eb f7                	jmp    800824 <vsnprintf+0x45>

0080082d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800833:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800836:	50                   	push   %eax
  800837:	ff 75 10             	pushl  0x10(%ebp)
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	ff 75 08             	pushl  0x8(%ebp)
  800840:	e8 9a ff ff ff       	call   8007df <vsnprintf>
	va_end(ap);

	return rc;
}
  800845:	c9                   	leave  
  800846:	c3                   	ret    

00800847 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80084d:	b8 00 00 00 00       	mov    $0x0,%eax
  800852:	eb 03                	jmp    800857 <strlen+0x10>
		n++;
  800854:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800857:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80085b:	75 f7                	jne    800854 <strlen+0xd>
	return n;
}
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    

0080085f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800865:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800868:	b8 00 00 00 00       	mov    $0x0,%eax
  80086d:	eb 03                	jmp    800872 <strnlen+0x13>
		n++;
  80086f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800872:	39 d0                	cmp    %edx,%eax
  800874:	74 06                	je     80087c <strnlen+0x1d>
  800876:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80087a:	75 f3                	jne    80086f <strnlen+0x10>
	return n;
}
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	53                   	push   %ebx
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800888:	89 c2                	mov    %eax,%edx
  80088a:	83 c1 01             	add    $0x1,%ecx
  80088d:	83 c2 01             	add    $0x1,%edx
  800890:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800894:	88 5a ff             	mov    %bl,-0x1(%edx)
  800897:	84 db                	test   %bl,%bl
  800899:	75 ef                	jne    80088a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80089b:	5b                   	pop    %ebx
  80089c:	5d                   	pop    %ebp
  80089d:	c3                   	ret    

0080089e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	53                   	push   %ebx
  8008a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a5:	53                   	push   %ebx
  8008a6:	e8 9c ff ff ff       	call   800847 <strlen>
  8008ab:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008ae:	ff 75 0c             	pushl  0xc(%ebp)
  8008b1:	01 d8                	add    %ebx,%eax
  8008b3:	50                   	push   %eax
  8008b4:	e8 c5 ff ff ff       	call   80087e <strcpy>
	return dst;
}
  8008b9:	89 d8                	mov    %ebx,%eax
  8008bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	56                   	push   %esi
  8008c4:	53                   	push   %ebx
  8008c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cb:	89 f3                	mov    %esi,%ebx
  8008cd:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d0:	89 f2                	mov    %esi,%edx
  8008d2:	eb 0f                	jmp    8008e3 <strncpy+0x23>
		*dst++ = *src;
  8008d4:	83 c2 01             	add    $0x1,%edx
  8008d7:	0f b6 01             	movzbl (%ecx),%eax
  8008da:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008dd:	80 39 01             	cmpb   $0x1,(%ecx)
  8008e0:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008e3:	39 da                	cmp    %ebx,%edx
  8008e5:	75 ed                	jne    8008d4 <strncpy+0x14>
	}
	return ret;
}
  8008e7:	89 f0                	mov    %esi,%eax
  8008e9:	5b                   	pop    %ebx
  8008ea:	5e                   	pop    %esi
  8008eb:	5d                   	pop    %ebp
  8008ec:	c3                   	ret    

008008ed <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	56                   	push   %esi
  8008f1:	53                   	push   %ebx
  8008f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008fb:	89 f0                	mov    %esi,%eax
  8008fd:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800901:	85 c9                	test   %ecx,%ecx
  800903:	75 0b                	jne    800910 <strlcpy+0x23>
  800905:	eb 17                	jmp    80091e <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800907:	83 c2 01             	add    $0x1,%edx
  80090a:	83 c0 01             	add    $0x1,%eax
  80090d:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800910:	39 d8                	cmp    %ebx,%eax
  800912:	74 07                	je     80091b <strlcpy+0x2e>
  800914:	0f b6 0a             	movzbl (%edx),%ecx
  800917:	84 c9                	test   %cl,%cl
  800919:	75 ec                	jne    800907 <strlcpy+0x1a>
		*dst = '\0';
  80091b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80091e:	29 f0                	sub    %esi,%eax
}
  800920:	5b                   	pop    %ebx
  800921:	5e                   	pop    %esi
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80092d:	eb 06                	jmp    800935 <strcmp+0x11>
		p++, q++;
  80092f:	83 c1 01             	add    $0x1,%ecx
  800932:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800935:	0f b6 01             	movzbl (%ecx),%eax
  800938:	84 c0                	test   %al,%al
  80093a:	74 04                	je     800940 <strcmp+0x1c>
  80093c:	3a 02                	cmp    (%edx),%al
  80093e:	74 ef                	je     80092f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800940:	0f b6 c0             	movzbl %al,%eax
  800943:	0f b6 12             	movzbl (%edx),%edx
  800946:	29 d0                	sub    %edx,%eax
}
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	89 c3                	mov    %eax,%ebx
  800956:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800959:	eb 06                	jmp    800961 <strncmp+0x17>
		n--, p++, q++;
  80095b:	83 c0 01             	add    $0x1,%eax
  80095e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800961:	39 d8                	cmp    %ebx,%eax
  800963:	74 16                	je     80097b <strncmp+0x31>
  800965:	0f b6 08             	movzbl (%eax),%ecx
  800968:	84 c9                	test   %cl,%cl
  80096a:	74 04                	je     800970 <strncmp+0x26>
  80096c:	3a 0a                	cmp    (%edx),%cl
  80096e:	74 eb                	je     80095b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800970:	0f b6 00             	movzbl (%eax),%eax
  800973:	0f b6 12             	movzbl (%edx),%edx
  800976:	29 d0                	sub    %edx,%eax
}
  800978:	5b                   	pop    %ebx
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    
		return 0;
  80097b:	b8 00 00 00 00       	mov    $0x0,%eax
  800980:	eb f6                	jmp    800978 <strncmp+0x2e>

00800982 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80098c:	0f b6 10             	movzbl (%eax),%edx
  80098f:	84 d2                	test   %dl,%dl
  800991:	74 09                	je     80099c <strchr+0x1a>
		if (*s == c)
  800993:	38 ca                	cmp    %cl,%dl
  800995:	74 0a                	je     8009a1 <strchr+0x1f>
	for (; *s; s++)
  800997:	83 c0 01             	add    $0x1,%eax
  80099a:	eb f0                	jmp    80098c <strchr+0xa>
			return (char *) s;
	return 0;
  80099c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a1:	5d                   	pop    %ebp
  8009a2:	c3                   	ret    

008009a3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ad:	eb 03                	jmp    8009b2 <strfind+0xf>
  8009af:	83 c0 01             	add    $0x1,%eax
  8009b2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009b5:	38 ca                	cmp    %cl,%dl
  8009b7:	74 04                	je     8009bd <strfind+0x1a>
  8009b9:	84 d2                	test   %dl,%dl
  8009bb:	75 f2                	jne    8009af <strfind+0xc>
			break;
	return (char *) s;
}
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	57                   	push   %edi
  8009c3:	56                   	push   %esi
  8009c4:	53                   	push   %ebx
  8009c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009cb:	85 c9                	test   %ecx,%ecx
  8009cd:	74 13                	je     8009e2 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009cf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009d5:	75 05                	jne    8009dc <memset+0x1d>
  8009d7:	f6 c1 03             	test   $0x3,%cl
  8009da:	74 0d                	je     8009e9 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009df:	fc                   	cld    
  8009e0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009e2:	89 f8                	mov    %edi,%eax
  8009e4:	5b                   	pop    %ebx
  8009e5:	5e                   	pop    %esi
  8009e6:	5f                   	pop    %edi
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    
		c &= 0xFF;
  8009e9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ed:	89 d3                	mov    %edx,%ebx
  8009ef:	c1 e3 08             	shl    $0x8,%ebx
  8009f2:	89 d0                	mov    %edx,%eax
  8009f4:	c1 e0 18             	shl    $0x18,%eax
  8009f7:	89 d6                	mov    %edx,%esi
  8009f9:	c1 e6 10             	shl    $0x10,%esi
  8009fc:	09 f0                	or     %esi,%eax
  8009fe:	09 c2                	or     %eax,%edx
  800a00:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a02:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a05:	89 d0                	mov    %edx,%eax
  800a07:	fc                   	cld    
  800a08:	f3 ab                	rep stos %eax,%es:(%edi)
  800a0a:	eb d6                	jmp    8009e2 <memset+0x23>

00800a0c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	57                   	push   %edi
  800a10:	56                   	push   %esi
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a17:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a1a:	39 c6                	cmp    %eax,%esi
  800a1c:	73 35                	jae    800a53 <memmove+0x47>
  800a1e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a21:	39 c2                	cmp    %eax,%edx
  800a23:	76 2e                	jbe    800a53 <memmove+0x47>
		s += n;
		d += n;
  800a25:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a28:	89 d6                	mov    %edx,%esi
  800a2a:	09 fe                	or     %edi,%esi
  800a2c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a32:	74 0c                	je     800a40 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a34:	83 ef 01             	sub    $0x1,%edi
  800a37:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a3a:	fd                   	std    
  800a3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a3d:	fc                   	cld    
  800a3e:	eb 21                	jmp    800a61 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a40:	f6 c1 03             	test   $0x3,%cl
  800a43:	75 ef                	jne    800a34 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a45:	83 ef 04             	sub    $0x4,%edi
  800a48:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a4b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a4e:	fd                   	std    
  800a4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a51:	eb ea                	jmp    800a3d <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a53:	89 f2                	mov    %esi,%edx
  800a55:	09 c2                	or     %eax,%edx
  800a57:	f6 c2 03             	test   $0x3,%dl
  800a5a:	74 09                	je     800a65 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a5c:	89 c7                	mov    %eax,%edi
  800a5e:	fc                   	cld    
  800a5f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a61:	5e                   	pop    %esi
  800a62:	5f                   	pop    %edi
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a65:	f6 c1 03             	test   $0x3,%cl
  800a68:	75 f2                	jne    800a5c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a6a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a6d:	89 c7                	mov    %eax,%edi
  800a6f:	fc                   	cld    
  800a70:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a72:	eb ed                	jmp    800a61 <memmove+0x55>

00800a74 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a77:	ff 75 10             	pushl  0x10(%ebp)
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	ff 75 08             	pushl  0x8(%ebp)
  800a80:	e8 87 ff ff ff       	call   800a0c <memmove>
}
  800a85:	c9                   	leave  
  800a86:	c3                   	ret    

00800a87 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	56                   	push   %esi
  800a8b:	53                   	push   %ebx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a92:	89 c6                	mov    %eax,%esi
  800a94:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a97:	39 f0                	cmp    %esi,%eax
  800a99:	74 1c                	je     800ab7 <memcmp+0x30>
		if (*s1 != *s2)
  800a9b:	0f b6 08             	movzbl (%eax),%ecx
  800a9e:	0f b6 1a             	movzbl (%edx),%ebx
  800aa1:	38 d9                	cmp    %bl,%cl
  800aa3:	75 08                	jne    800aad <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aa5:	83 c0 01             	add    $0x1,%eax
  800aa8:	83 c2 01             	add    $0x1,%edx
  800aab:	eb ea                	jmp    800a97 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aad:	0f b6 c1             	movzbl %cl,%eax
  800ab0:	0f b6 db             	movzbl %bl,%ebx
  800ab3:	29 d8                	sub    %ebx,%eax
  800ab5:	eb 05                	jmp    800abc <memcmp+0x35>
	}

	return 0;
  800ab7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800abc:	5b                   	pop    %ebx
  800abd:	5e                   	pop    %esi
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac9:	89 c2                	mov    %eax,%edx
  800acb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ace:	39 d0                	cmp    %edx,%eax
  800ad0:	73 09                	jae    800adb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad2:	38 08                	cmp    %cl,(%eax)
  800ad4:	74 05                	je     800adb <memfind+0x1b>
	for (; s < ends; s++)
  800ad6:	83 c0 01             	add    $0x1,%eax
  800ad9:	eb f3                	jmp    800ace <memfind+0xe>
			break;
	return (void *) s;
}
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    

00800add <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	57                   	push   %edi
  800ae1:	56                   	push   %esi
  800ae2:	53                   	push   %ebx
  800ae3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae9:	eb 03                	jmp    800aee <strtol+0x11>
		s++;
  800aeb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800aee:	0f b6 01             	movzbl (%ecx),%eax
  800af1:	3c 20                	cmp    $0x20,%al
  800af3:	74 f6                	je     800aeb <strtol+0xe>
  800af5:	3c 09                	cmp    $0x9,%al
  800af7:	74 f2                	je     800aeb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800af9:	3c 2b                	cmp    $0x2b,%al
  800afb:	74 2e                	je     800b2b <strtol+0x4e>
	int neg = 0;
  800afd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b02:	3c 2d                	cmp    $0x2d,%al
  800b04:	74 2f                	je     800b35 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b06:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b0c:	75 05                	jne    800b13 <strtol+0x36>
  800b0e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b11:	74 2c                	je     800b3f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b13:	85 db                	test   %ebx,%ebx
  800b15:	75 0a                	jne    800b21 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b17:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b1c:	80 39 30             	cmpb   $0x30,(%ecx)
  800b1f:	74 28                	je     800b49 <strtol+0x6c>
		base = 10;
  800b21:	b8 00 00 00 00       	mov    $0x0,%eax
  800b26:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b29:	eb 50                	jmp    800b7b <strtol+0x9e>
		s++;
  800b2b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b2e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b33:	eb d1                	jmp    800b06 <strtol+0x29>
		s++, neg = 1;
  800b35:	83 c1 01             	add    $0x1,%ecx
  800b38:	bf 01 00 00 00       	mov    $0x1,%edi
  800b3d:	eb c7                	jmp    800b06 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b3f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b43:	74 0e                	je     800b53 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b45:	85 db                	test   %ebx,%ebx
  800b47:	75 d8                	jne    800b21 <strtol+0x44>
		s++, base = 8;
  800b49:	83 c1 01             	add    $0x1,%ecx
  800b4c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b51:	eb ce                	jmp    800b21 <strtol+0x44>
		s += 2, base = 16;
  800b53:	83 c1 02             	add    $0x2,%ecx
  800b56:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b5b:	eb c4                	jmp    800b21 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b5d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b60:	89 f3                	mov    %esi,%ebx
  800b62:	80 fb 19             	cmp    $0x19,%bl
  800b65:	77 29                	ja     800b90 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b67:	0f be d2             	movsbl %dl,%edx
  800b6a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b6d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b70:	7d 30                	jge    800ba2 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b72:	83 c1 01             	add    $0x1,%ecx
  800b75:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b79:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b7b:	0f b6 11             	movzbl (%ecx),%edx
  800b7e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b81:	89 f3                	mov    %esi,%ebx
  800b83:	80 fb 09             	cmp    $0x9,%bl
  800b86:	77 d5                	ja     800b5d <strtol+0x80>
			dig = *s - '0';
  800b88:	0f be d2             	movsbl %dl,%edx
  800b8b:	83 ea 30             	sub    $0x30,%edx
  800b8e:	eb dd                	jmp    800b6d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b90:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b93:	89 f3                	mov    %esi,%ebx
  800b95:	80 fb 19             	cmp    $0x19,%bl
  800b98:	77 08                	ja     800ba2 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b9a:	0f be d2             	movsbl %dl,%edx
  800b9d:	83 ea 37             	sub    $0x37,%edx
  800ba0:	eb cb                	jmp    800b6d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ba2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba6:	74 05                	je     800bad <strtol+0xd0>
		*endptr = (char *) s;
  800ba8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bab:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bad:	89 c2                	mov    %eax,%edx
  800baf:	f7 da                	neg    %edx
  800bb1:	85 ff                	test   %edi,%edi
  800bb3:	0f 45 c2             	cmovne %edx,%eax
}
  800bb6:	5b                   	pop    %ebx
  800bb7:	5e                   	pop    %esi
  800bb8:	5f                   	pop    %edi
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	57                   	push   %edi
  800bbf:	56                   	push   %esi
  800bc0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bcc:	89 c3                	mov    %eax,%ebx
  800bce:	89 c7                	mov    %eax,%edi
  800bd0:	89 c6                	mov    %eax,%esi
  800bd2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5f                   	pop    %edi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	57                   	push   %edi
  800bdd:	56                   	push   %esi
  800bde:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bdf:	ba 00 00 00 00       	mov    $0x0,%edx
  800be4:	b8 01 00 00 00       	mov    $0x1,%eax
  800be9:	89 d1                	mov    %edx,%ecx
  800beb:	89 d3                	mov    %edx,%ebx
  800bed:	89 d7                	mov    %edx,%edi
  800bef:	89 d6                	mov    %edx,%esi
  800bf1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bf3:	5b                   	pop    %ebx
  800bf4:	5e                   	pop    %esi
  800bf5:	5f                   	pop    %edi
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	57                   	push   %edi
  800bfc:	56                   	push   %esi
  800bfd:	53                   	push   %ebx
  800bfe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c01:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c06:	8b 55 08             	mov    0x8(%ebp),%edx
  800c09:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0e:	89 cb                	mov    %ecx,%ebx
  800c10:	89 cf                	mov    %ecx,%edi
  800c12:	89 ce                	mov    %ecx,%esi
  800c14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c16:	85 c0                	test   %eax,%eax
  800c18:	7f 08                	jg     800c22 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800c26:	6a 03                	push   $0x3
  800c28:	68 bf 24 80 00       	push   $0x8024bf
  800c2d:	6a 23                	push   $0x23
  800c2f:	68 dc 24 80 00       	push   $0x8024dc
  800c34:	e8 8a 11 00 00       	call   801dc3 <_panic>

00800c39 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c44:	b8 02 00 00 00       	mov    $0x2,%eax
  800c49:	89 d1                	mov    %edx,%ecx
  800c4b:	89 d3                	mov    %edx,%ebx
  800c4d:	89 d7                	mov    %edx,%edi
  800c4f:	89 d6                	mov    %edx,%esi
  800c51:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <sys_yield>:

void
sys_yield(void)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c63:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c68:	89 d1                	mov    %edx,%ecx
  800c6a:	89 d3                	mov    %edx,%ebx
  800c6c:	89 d7                	mov    %edx,%edi
  800c6e:	89 d6                	mov    %edx,%esi
  800c70:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	57                   	push   %edi
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
  800c7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c80:	be 00 00 00 00       	mov    $0x0,%esi
  800c85:	8b 55 08             	mov    0x8(%ebp),%edx
  800c88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8b:	b8 04 00 00 00       	mov    $0x4,%eax
  800c90:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c93:	89 f7                	mov    %esi,%edi
  800c95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c97:	85 c0                	test   %eax,%eax
  800c99:	7f 08                	jg     800ca3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5f                   	pop    %edi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca3:	83 ec 0c             	sub    $0xc,%esp
  800ca6:	50                   	push   %eax
  800ca7:	6a 04                	push   $0x4
  800ca9:	68 bf 24 80 00       	push   $0x8024bf
  800cae:	6a 23                	push   $0x23
  800cb0:	68 dc 24 80 00       	push   $0x8024dc
  800cb5:	e8 09 11 00 00       	call   801dc3 <_panic>

00800cba <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
  800cc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc9:	b8 05 00 00 00       	mov    $0x5,%eax
  800cce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cd4:	8b 75 18             	mov    0x18(%ebp),%esi
  800cd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd9:	85 c0                	test   %eax,%eax
  800cdb:	7f 08                	jg     800ce5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5f                   	pop    %edi
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce5:	83 ec 0c             	sub    $0xc,%esp
  800ce8:	50                   	push   %eax
  800ce9:	6a 05                	push   $0x5
  800ceb:	68 bf 24 80 00       	push   $0x8024bf
  800cf0:	6a 23                	push   $0x23
  800cf2:	68 dc 24 80 00       	push   $0x8024dc
  800cf7:	e8 c7 10 00 00       	call   801dc3 <_panic>

00800cfc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	57                   	push   %edi
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
  800d02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d10:	b8 06 00 00 00       	mov    $0x6,%eax
  800d15:	89 df                	mov    %ebx,%edi
  800d17:	89 de                	mov    %ebx,%esi
  800d19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	7f 08                	jg     800d27 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5f                   	pop    %edi
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d27:	83 ec 0c             	sub    $0xc,%esp
  800d2a:	50                   	push   %eax
  800d2b:	6a 06                	push   $0x6
  800d2d:	68 bf 24 80 00       	push   $0x8024bf
  800d32:	6a 23                	push   $0x23
  800d34:	68 dc 24 80 00       	push   $0x8024dc
  800d39:	e8 85 10 00 00       	call   801dc3 <_panic>

00800d3e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	57                   	push   %edi
  800d42:	56                   	push   %esi
  800d43:	53                   	push   %ebx
  800d44:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d52:	b8 08 00 00 00       	mov    $0x8,%eax
  800d57:	89 df                	mov    %ebx,%edi
  800d59:	89 de                	mov    %ebx,%esi
  800d5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	7f 08                	jg     800d69 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d69:	83 ec 0c             	sub    $0xc,%esp
  800d6c:	50                   	push   %eax
  800d6d:	6a 08                	push   $0x8
  800d6f:	68 bf 24 80 00       	push   $0x8024bf
  800d74:	6a 23                	push   $0x23
  800d76:	68 dc 24 80 00       	push   $0x8024dc
  800d7b:	e8 43 10 00 00       	call   801dc3 <_panic>

00800d80 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d94:	b8 09 00 00 00       	mov    $0x9,%eax
  800d99:	89 df                	mov    %ebx,%edi
  800d9b:	89 de                	mov    %ebx,%esi
  800d9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	7f 08                	jg     800dab <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dab:	83 ec 0c             	sub    $0xc,%esp
  800dae:	50                   	push   %eax
  800daf:	6a 09                	push   $0x9
  800db1:	68 bf 24 80 00       	push   $0x8024bf
  800db6:	6a 23                	push   $0x23
  800db8:	68 dc 24 80 00       	push   $0x8024dc
  800dbd:	e8 01 10 00 00       	call   801dc3 <_panic>

00800dc2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ddb:	89 df                	mov    %ebx,%edi
  800ddd:	89 de                	mov    %ebx,%esi
  800ddf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de1:	85 c0                	test   %eax,%eax
  800de3:	7f 08                	jg     800ded <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5f                   	pop    %edi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ded:	83 ec 0c             	sub    $0xc,%esp
  800df0:	50                   	push   %eax
  800df1:	6a 0a                	push   $0xa
  800df3:	68 bf 24 80 00       	push   $0x8024bf
  800df8:	6a 23                	push   $0x23
  800dfa:	68 dc 24 80 00       	push   $0x8024dc
  800dff:	e8 bf 0f 00 00       	call   801dc3 <_panic>

00800e04 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e15:	be 00 00 00 00       	mov    $0x0,%esi
  800e1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e20:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    

00800e27 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	53                   	push   %ebx
  800e2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e30:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e35:	8b 55 08             	mov    0x8(%ebp),%edx
  800e38:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e3d:	89 cb                	mov    %ecx,%ebx
  800e3f:	89 cf                	mov    %ecx,%edi
  800e41:	89 ce                	mov    %ecx,%esi
  800e43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e45:	85 c0                	test   %eax,%eax
  800e47:	7f 08                	jg     800e51 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4c:	5b                   	pop    %ebx
  800e4d:	5e                   	pop    %esi
  800e4e:	5f                   	pop    %edi
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e51:	83 ec 0c             	sub    $0xc,%esp
  800e54:	50                   	push   %eax
  800e55:	6a 0d                	push   $0xd
  800e57:	68 bf 24 80 00       	push   $0x8024bf
  800e5c:	6a 23                	push   $0x23
  800e5e:	68 dc 24 80 00       	push   $0x8024dc
  800e63:	e8 5b 0f 00 00       	call   801dc3 <_panic>

00800e68 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	83 ec 0c             	sub    $0xc,%esp
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.

	panic("pgfault not implemented");
  800e6e:	68 ea 24 80 00       	push   $0x8024ea
  800e73:	6a 25                	push   $0x25
  800e75:	68 02 25 80 00       	push   $0x802502
  800e7a:	e8 44 0f 00 00       	call   801dc3 <_panic>

00800e7f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
  800e85:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	//panic("fork not implemented");
	set_pgfault_handler(pgfault);
  800e88:	68 68 0e 80 00       	push   $0x800e68
  800e8d:	e8 77 0f 00 00       	call   801e09 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800e92:	b8 07 00 00 00       	mov    $0x7,%eax
  800e97:	cd 30                	int    $0x30
  800e99:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t e_id = sys_exofork();
	if (e_id < 0) panic("fork: %e", e_id);
  800e9f:	83 c4 10             	add    $0x10,%esp
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	78 27                	js     800ecd <fork+0x4e>
	}

    	// parent
    	// extern unsigned char end[];
    	// for ((uint8_t *) addr = UTEXT; addr < end; addr += PGSIZE)
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800ea6:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if (e_id == 0) {
  800eab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800eaf:	75 65                	jne    800f16 <fork+0x97>
		thisenv = &envs[ENVX(sys_getenvid())];
  800eb1:	e8 83 fd ff ff       	call   800c39 <sys_getenvid>
  800eb6:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ebb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ebe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ec3:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800ec8:	e9 11 01 00 00       	jmp    800fde <fork+0x15f>
	if (e_id < 0) panic("fork: %e", e_id);
  800ecd:	50                   	push   %eax
  800ece:	68 0d 25 80 00       	push   $0x80250d
  800ed3:	6a 6f                	push   $0x6f
  800ed5:	68 02 25 80 00       	push   $0x802502
  800eda:	e8 e4 0e 00 00       	call   801dc3 <_panic>
            if ((r = sys_page_map(sys_getenvid(), addr, envid, addr, pte & PTE_SYSCALL)) < 0) {
  800edf:	e8 55 fd ff ff       	call   800c39 <sys_getenvid>
  800ee4:	83 ec 0c             	sub    $0xc,%esp
  800ee7:	81 e6 07 0e 00 00    	and    $0xe07,%esi
  800eed:	56                   	push   %esi
  800eee:	57                   	push   %edi
  800eef:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ef2:	57                   	push   %edi
  800ef3:	50                   	push   %eax
  800ef4:	e8 c1 fd ff ff       	call   800cba <sys_page_map>
  800ef9:	83 c4 20             	add    $0x20,%esp
  800efc:	85 c0                	test   %eax,%eax
  800efe:	0f 88 84 00 00 00    	js     800f88 <fork+0x109>
	for (uintptr_t addr = UTEXT; addr < USTACKTOP; addr += PGSIZE) {
  800f04:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800f0a:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800f10:	0f 84 84 00 00 00    	je     800f9a <fork+0x11b>
		if ( (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) ) 
  800f16:	89 d8                	mov    %ebx,%eax
  800f18:	c1 e8 16             	shr    $0x16,%eax
  800f1b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f22:	a8 01                	test   $0x1,%al
  800f24:	74 de                	je     800f04 <fork+0x85>
  800f26:	89 d8                	mov    %ebx,%eax
  800f28:	c1 e8 0c             	shr    $0xc,%eax
  800f2b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800f32:	f6 c2 01             	test   $0x1,%dl
  800f35:	74 cd                	je     800f04 <fork+0x85>
        addr = (void *)((uint32_t)pn * PGSIZE);
  800f37:	89 c7                	mov    %eax,%edi
  800f39:	c1 e7 0c             	shl    $0xc,%edi
        pte = uvpt[pn];
  800f3c:	8b 34 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%esi
        if (pte & PTE_SHARE) {
  800f43:	f7 c6 00 04 00 00    	test   $0x400,%esi
  800f49:	75 94                	jne    800edf <fork+0x60>
                if ((pte & PTE_W) || (pte & PTE_COW))
  800f4b:	f7 c6 02 08 00 00    	test   $0x802,%esi
  800f51:	0f 85 d1 00 00 00    	jne    801028 <fork+0x1a9>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  800f57:	a1 04 40 80 00       	mov    0x804004,%eax
  800f5c:	8b 40 48             	mov    0x48(%eax),%eax
  800f5f:	83 ec 0c             	sub    $0xc,%esp
  800f62:	6a 05                	push   $0x5
  800f64:	57                   	push   %edi
  800f65:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f68:	57                   	push   %edi
  800f69:	50                   	push   %eax
  800f6a:	e8 4b fd ff ff       	call   800cba <sys_page_map>
  800f6f:	83 c4 20             	add    $0x20,%esp
  800f72:	85 c0                	test   %eax,%eax
  800f74:	79 8e                	jns    800f04 <fork+0x85>
                        panic("duppage: page remapping failed %e", r);
  800f76:	50                   	push   %eax
  800f77:	68 64 25 80 00       	push   $0x802564
  800f7c:	6a 4a                	push   $0x4a
  800f7e:	68 02 25 80 00       	push   $0x802502
  800f83:	e8 3b 0e 00 00       	call   801dc3 <_panic>
                        panic("duppage: page mapping failed %e", r);
  800f88:	50                   	push   %eax
  800f89:	68 44 25 80 00       	push   $0x802544
  800f8e:	6a 41                	push   $0x41
  800f90:	68 02 25 80 00       	push   $0x802502
  800f95:	e8 29 0e 00 00       	call   801dc3 <_panic>
			// dup page to child
			duppage(e_id, PGNUM(addr));
		}
	}
    	// alloc page for exception stack
    	int r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  800f9a:	83 ec 04             	sub    $0x4,%esp
  800f9d:	6a 07                	push   $0x7
  800f9f:	68 00 f0 bf ee       	push   $0xeebff000
  800fa4:	ff 75 e0             	pushl  -0x20(%ebp)
  800fa7:	e8 cb fc ff ff       	call   800c77 <sys_page_alloc>
    	if (r < 0) panic("fork: %e",r);
  800fac:	83 c4 10             	add    $0x10,%esp
  800faf:	85 c0                	test   %eax,%eax
  800fb1:	78 36                	js     800fe9 <fork+0x16a>

    	// DO NOT FORGET
    	extern void _pgfault_upcall();
    	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  800fb3:	83 ec 08             	sub    $0x8,%esp
  800fb6:	68 7d 1e 80 00       	push   $0x801e7d
  800fbb:	ff 75 e0             	pushl  -0x20(%ebp)
  800fbe:	e8 ff fd ff ff       	call   800dc2 <sys_env_set_pgfault_upcall>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800fc3:	83 c4 10             	add    $0x10,%esp
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	78 34                	js     800ffe <fork+0x17f>

    	// mark the child environment runnable
    	if ((r = sys_env_set_status(e_id, ENV_RUNNABLE)) < 0)
  800fca:	83 ec 08             	sub    $0x8,%esp
  800fcd:	6a 02                	push   $0x2
  800fcf:	ff 75 e0             	pushl  -0x20(%ebp)
  800fd2:	e8 67 fd ff ff       	call   800d3e <sys_env_set_status>
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	78 35                	js     801013 <fork+0x194>
        	panic("sys_env_set_status: %e", r);

    	return e_id;
}
  800fde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5f                   	pop    %edi
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    
    	if (r < 0) panic("fork: %e",r);
  800fe9:	50                   	push   %eax
  800fea:	68 0d 25 80 00       	push   $0x80250d
  800fef:	68 82 00 00 00       	push   $0x82
  800ff4:	68 02 25 80 00       	push   $0x802502
  800ff9:	e8 c5 0d 00 00       	call   801dc3 <_panic>
    	if (r < 0) panic("fork: set upcall for child fail, %e", r);
  800ffe:	50                   	push   %eax
  800fff:	68 88 25 80 00       	push   $0x802588
  801004:	68 87 00 00 00       	push   $0x87
  801009:	68 02 25 80 00       	push   $0x802502
  80100e:	e8 b0 0d 00 00       	call   801dc3 <_panic>
        	panic("sys_env_set_status: %e", r);
  801013:	50                   	push   %eax
  801014:	68 16 25 80 00       	push   $0x802516
  801019:	68 8b 00 00 00       	push   $0x8b
  80101e:	68 02 25 80 00       	push   $0x802502
  801023:	e8 9b 0d 00 00       	call   801dc3 <_panic>
                if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) {
  801028:	a1 04 40 80 00       	mov    0x804004,%eax
  80102d:	8b 40 48             	mov    0x48(%eax),%eax
  801030:	83 ec 0c             	sub    $0xc,%esp
  801033:	68 05 08 00 00       	push   $0x805
  801038:	57                   	push   %edi
  801039:	ff 75 e4             	pushl  -0x1c(%ebp)
  80103c:	57                   	push   %edi
  80103d:	50                   	push   %eax
  80103e:	e8 77 fc ff ff       	call   800cba <sys_page_map>
  801043:	83 c4 20             	add    $0x20,%esp
  801046:	85 c0                	test   %eax,%eax
  801048:	0f 88 28 ff ff ff    	js     800f76 <fork+0xf7>
                        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) {
  80104e:	a1 04 40 80 00       	mov    0x804004,%eax
  801053:	8b 50 48             	mov    0x48(%eax),%edx
  801056:	8b 40 48             	mov    0x48(%eax),%eax
  801059:	83 ec 0c             	sub    $0xc,%esp
  80105c:	68 05 08 00 00       	push   $0x805
  801061:	57                   	push   %edi
  801062:	52                   	push   %edx
  801063:	57                   	push   %edi
  801064:	50                   	push   %eax
  801065:	e8 50 fc ff ff       	call   800cba <sys_page_map>
  80106a:	83 c4 20             	add    $0x20,%esp
  80106d:	85 c0                	test   %eax,%eax
  80106f:	0f 89 8f fe ff ff    	jns    800f04 <fork+0x85>
                                panic("duppage: page remapping failed %e", r);
  801075:	50                   	push   %eax
  801076:	68 64 25 80 00       	push   $0x802564
  80107b:	6a 4f                	push   $0x4f
  80107d:	68 02 25 80 00       	push   $0x802502
  801082:	e8 3c 0d 00 00       	call   801dc3 <_panic>

00801087 <sfork>:

// Challenge!
int
sfork(void)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80108d:	68 2d 25 80 00       	push   $0x80252d
  801092:	68 94 00 00 00       	push   $0x94
  801097:	68 02 25 80 00       	push   $0x802502
  80109c:	e8 22 0d 00 00       	call   801dc3 <_panic>

008010a1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  8010a7:	68 ac 25 80 00       	push   $0x8025ac
  8010ac:	6a 1a                	push   $0x1a
  8010ae:	68 c5 25 80 00       	push   $0x8025c5
  8010b3:	e8 0b 0d 00 00       	call   801dc3 <_panic>

008010b8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  8010be:	68 cf 25 80 00       	push   $0x8025cf
  8010c3:	6a 2a                	push   $0x2a
  8010c5:	68 c5 25 80 00       	push   $0x8025c5
  8010ca:	e8 f4 0c 00 00       	call   801dc3 <_panic>

008010cf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8010d5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8010da:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8010dd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8010e3:	8b 52 50             	mov    0x50(%edx),%edx
  8010e6:	39 ca                	cmp    %ecx,%edx
  8010e8:	74 11                	je     8010fb <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8010ea:	83 c0 01             	add    $0x1,%eax
  8010ed:	3d 00 04 00 00       	cmp    $0x400,%eax
  8010f2:	75 e6                	jne    8010da <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8010f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f9:	eb 0b                	jmp    801106 <ipc_find_env+0x37>
			return envs[i].env_id;
  8010fb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801103:	8b 40 48             	mov    0x48(%eax),%eax
}
  801106:	5d                   	pop    %ebp
  801107:	c3                   	ret    

00801108 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	05 00 00 00 30       	add    $0x30000000,%eax
  801113:	c1 e8 0c             	shr    $0xc,%eax
}
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    

00801118 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801123:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801128:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80112d:	5d                   	pop    %ebp
  80112e:	c3                   	ret    

0080112f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801135:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80113a:	89 c2                	mov    %eax,%edx
  80113c:	c1 ea 16             	shr    $0x16,%edx
  80113f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801146:	f6 c2 01             	test   $0x1,%dl
  801149:	74 2a                	je     801175 <fd_alloc+0x46>
  80114b:	89 c2                	mov    %eax,%edx
  80114d:	c1 ea 0c             	shr    $0xc,%edx
  801150:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801157:	f6 c2 01             	test   $0x1,%dl
  80115a:	74 19                	je     801175 <fd_alloc+0x46>
  80115c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801161:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801166:	75 d2                	jne    80113a <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801168:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80116e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801173:	eb 07                	jmp    80117c <fd_alloc+0x4d>
			*fd_store = fd;
  801175:	89 01                	mov    %eax,(%ecx)
			return 0;
  801177:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117c:	5d                   	pop    %ebp
  80117d:	c3                   	ret    

0080117e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801184:	83 f8 1f             	cmp    $0x1f,%eax
  801187:	77 36                	ja     8011bf <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801189:	c1 e0 0c             	shl    $0xc,%eax
  80118c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801191:	89 c2                	mov    %eax,%edx
  801193:	c1 ea 16             	shr    $0x16,%edx
  801196:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80119d:	f6 c2 01             	test   $0x1,%dl
  8011a0:	74 24                	je     8011c6 <fd_lookup+0x48>
  8011a2:	89 c2                	mov    %eax,%edx
  8011a4:	c1 ea 0c             	shr    $0xc,%edx
  8011a7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011ae:	f6 c2 01             	test   $0x1,%dl
  8011b1:	74 1a                	je     8011cd <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b6:	89 02                	mov    %eax,(%edx)
	return 0;
  8011b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011bd:	5d                   	pop    %ebp
  8011be:	c3                   	ret    
		return -E_INVAL;
  8011bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c4:	eb f7                	jmp    8011bd <fd_lookup+0x3f>
		return -E_INVAL;
  8011c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011cb:	eb f0                	jmp    8011bd <fd_lookup+0x3f>
  8011cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d2:	eb e9                	jmp    8011bd <fd_lookup+0x3f>

008011d4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
  8011d7:	83 ec 08             	sub    $0x8,%esp
  8011da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011dd:	ba 64 26 80 00       	mov    $0x802664,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8011e2:	b8 0c 30 80 00       	mov    $0x80300c,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011e7:	39 08                	cmp    %ecx,(%eax)
  8011e9:	74 33                	je     80121e <dev_lookup+0x4a>
  8011eb:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8011ee:	8b 02                	mov    (%edx),%eax
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	75 f3                	jne    8011e7 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011f4:	a1 04 40 80 00       	mov    0x804004,%eax
  8011f9:	8b 40 48             	mov    0x48(%eax),%eax
  8011fc:	83 ec 04             	sub    $0x4,%esp
  8011ff:	51                   	push   %ecx
  801200:	50                   	push   %eax
  801201:	68 e8 25 80 00       	push   $0x8025e8
  801206:	e8 89 f0 ff ff       	call   800294 <cprintf>
	*dev = 0;
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801214:	83 c4 10             	add    $0x10,%esp
  801217:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80121c:	c9                   	leave  
  80121d:	c3                   	ret    
			*dev = devtab[i];
  80121e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801221:	89 01                	mov    %eax,(%ecx)
			return 0;
  801223:	b8 00 00 00 00       	mov    $0x0,%eax
  801228:	eb f2                	jmp    80121c <dev_lookup+0x48>

0080122a <fd_close>:
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	57                   	push   %edi
  80122e:	56                   	push   %esi
  80122f:	53                   	push   %ebx
  801230:	83 ec 1c             	sub    $0x1c,%esp
  801233:	8b 75 08             	mov    0x8(%ebp),%esi
  801236:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801239:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80123c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80123d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801243:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801246:	50                   	push   %eax
  801247:	e8 32 ff ff ff       	call   80117e <fd_lookup>
  80124c:	89 c3                	mov    %eax,%ebx
  80124e:	83 c4 08             	add    $0x8,%esp
  801251:	85 c0                	test   %eax,%eax
  801253:	78 05                	js     80125a <fd_close+0x30>
	    || fd != fd2)
  801255:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801258:	74 16                	je     801270 <fd_close+0x46>
		return (must_exist ? r : 0);
  80125a:	89 f8                	mov    %edi,%eax
  80125c:	84 c0                	test   %al,%al
  80125e:	b8 00 00 00 00       	mov    $0x0,%eax
  801263:	0f 44 d8             	cmove  %eax,%ebx
}
  801266:	89 d8                	mov    %ebx,%eax
  801268:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126b:	5b                   	pop    %ebx
  80126c:	5e                   	pop    %esi
  80126d:	5f                   	pop    %edi
  80126e:	5d                   	pop    %ebp
  80126f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801270:	83 ec 08             	sub    $0x8,%esp
  801273:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801276:	50                   	push   %eax
  801277:	ff 36                	pushl  (%esi)
  801279:	e8 56 ff ff ff       	call   8011d4 <dev_lookup>
  80127e:	89 c3                	mov    %eax,%ebx
  801280:	83 c4 10             	add    $0x10,%esp
  801283:	85 c0                	test   %eax,%eax
  801285:	78 15                	js     80129c <fd_close+0x72>
		if (dev->dev_close)
  801287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80128a:	8b 40 10             	mov    0x10(%eax),%eax
  80128d:	85 c0                	test   %eax,%eax
  80128f:	74 1b                	je     8012ac <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801291:	83 ec 0c             	sub    $0xc,%esp
  801294:	56                   	push   %esi
  801295:	ff d0                	call   *%eax
  801297:	89 c3                	mov    %eax,%ebx
  801299:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80129c:	83 ec 08             	sub    $0x8,%esp
  80129f:	56                   	push   %esi
  8012a0:	6a 00                	push   $0x0
  8012a2:	e8 55 fa ff ff       	call   800cfc <sys_page_unmap>
	return r;
  8012a7:	83 c4 10             	add    $0x10,%esp
  8012aa:	eb ba                	jmp    801266 <fd_close+0x3c>
			r = 0;
  8012ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b1:	eb e9                	jmp    80129c <fd_close+0x72>

008012b3 <close>:

int
close(int fdnum)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012bc:	50                   	push   %eax
  8012bd:	ff 75 08             	pushl  0x8(%ebp)
  8012c0:	e8 b9 fe ff ff       	call   80117e <fd_lookup>
  8012c5:	83 c4 08             	add    $0x8,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	78 10                	js     8012dc <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8012cc:	83 ec 08             	sub    $0x8,%esp
  8012cf:	6a 01                	push   $0x1
  8012d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d4:	e8 51 ff ff ff       	call   80122a <fd_close>
  8012d9:	83 c4 10             	add    $0x10,%esp
}
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <close_all>:

void
close_all(void)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	53                   	push   %ebx
  8012e2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012e5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012ea:	83 ec 0c             	sub    $0xc,%esp
  8012ed:	53                   	push   %ebx
  8012ee:	e8 c0 ff ff ff       	call   8012b3 <close>
	for (i = 0; i < MAXFD; i++)
  8012f3:	83 c3 01             	add    $0x1,%ebx
  8012f6:	83 c4 10             	add    $0x10,%esp
  8012f9:	83 fb 20             	cmp    $0x20,%ebx
  8012fc:	75 ec                	jne    8012ea <close_all+0xc>
}
  8012fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	57                   	push   %edi
  801307:	56                   	push   %esi
  801308:	53                   	push   %ebx
  801309:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80130c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80130f:	50                   	push   %eax
  801310:	ff 75 08             	pushl  0x8(%ebp)
  801313:	e8 66 fe ff ff       	call   80117e <fd_lookup>
  801318:	89 c3                	mov    %eax,%ebx
  80131a:	83 c4 08             	add    $0x8,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	0f 88 81 00 00 00    	js     8013a6 <dup+0xa3>
		return r;
	close(newfdnum);
  801325:	83 ec 0c             	sub    $0xc,%esp
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	e8 83 ff ff ff       	call   8012b3 <close>

	newfd = INDEX2FD(newfdnum);
  801330:	8b 75 0c             	mov    0xc(%ebp),%esi
  801333:	c1 e6 0c             	shl    $0xc,%esi
  801336:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80133c:	83 c4 04             	add    $0x4,%esp
  80133f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801342:	e8 d1 fd ff ff       	call   801118 <fd2data>
  801347:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801349:	89 34 24             	mov    %esi,(%esp)
  80134c:	e8 c7 fd ff ff       	call   801118 <fd2data>
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801356:	89 d8                	mov    %ebx,%eax
  801358:	c1 e8 16             	shr    $0x16,%eax
  80135b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801362:	a8 01                	test   $0x1,%al
  801364:	74 11                	je     801377 <dup+0x74>
  801366:	89 d8                	mov    %ebx,%eax
  801368:	c1 e8 0c             	shr    $0xc,%eax
  80136b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801372:	f6 c2 01             	test   $0x1,%dl
  801375:	75 39                	jne    8013b0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801377:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80137a:	89 d0                	mov    %edx,%eax
  80137c:	c1 e8 0c             	shr    $0xc,%eax
  80137f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801386:	83 ec 0c             	sub    $0xc,%esp
  801389:	25 07 0e 00 00       	and    $0xe07,%eax
  80138e:	50                   	push   %eax
  80138f:	56                   	push   %esi
  801390:	6a 00                	push   $0x0
  801392:	52                   	push   %edx
  801393:	6a 00                	push   $0x0
  801395:	e8 20 f9 ff ff       	call   800cba <sys_page_map>
  80139a:	89 c3                	mov    %eax,%ebx
  80139c:	83 c4 20             	add    $0x20,%esp
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	78 31                	js     8013d4 <dup+0xd1>
		goto err;

	return newfdnum;
  8013a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013a6:	89 d8                	mov    %ebx,%eax
  8013a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ab:	5b                   	pop    %ebx
  8013ac:	5e                   	pop    %esi
  8013ad:	5f                   	pop    %edi
  8013ae:	5d                   	pop    %ebp
  8013af:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b7:	83 ec 0c             	sub    $0xc,%esp
  8013ba:	25 07 0e 00 00       	and    $0xe07,%eax
  8013bf:	50                   	push   %eax
  8013c0:	57                   	push   %edi
  8013c1:	6a 00                	push   $0x0
  8013c3:	53                   	push   %ebx
  8013c4:	6a 00                	push   $0x0
  8013c6:	e8 ef f8 ff ff       	call   800cba <sys_page_map>
  8013cb:	89 c3                	mov    %eax,%ebx
  8013cd:	83 c4 20             	add    $0x20,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	79 a3                	jns    801377 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013d4:	83 ec 08             	sub    $0x8,%esp
  8013d7:	56                   	push   %esi
  8013d8:	6a 00                	push   $0x0
  8013da:	e8 1d f9 ff ff       	call   800cfc <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013df:	83 c4 08             	add    $0x8,%esp
  8013e2:	57                   	push   %edi
  8013e3:	6a 00                	push   $0x0
  8013e5:	e8 12 f9 ff ff       	call   800cfc <sys_page_unmap>
	return r;
  8013ea:	83 c4 10             	add    $0x10,%esp
  8013ed:	eb b7                	jmp    8013a6 <dup+0xa3>

008013ef <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	53                   	push   %ebx
  8013f3:	83 ec 14             	sub    $0x14,%esp
  8013f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013fc:	50                   	push   %eax
  8013fd:	53                   	push   %ebx
  8013fe:	e8 7b fd ff ff       	call   80117e <fd_lookup>
  801403:	83 c4 08             	add    $0x8,%esp
  801406:	85 c0                	test   %eax,%eax
  801408:	78 3f                	js     801449 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80140a:	83 ec 08             	sub    $0x8,%esp
  80140d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801410:	50                   	push   %eax
  801411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801414:	ff 30                	pushl  (%eax)
  801416:	e8 b9 fd ff ff       	call   8011d4 <dev_lookup>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	85 c0                	test   %eax,%eax
  801420:	78 27                	js     801449 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801422:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801425:	8b 42 08             	mov    0x8(%edx),%eax
  801428:	83 e0 03             	and    $0x3,%eax
  80142b:	83 f8 01             	cmp    $0x1,%eax
  80142e:	74 1e                	je     80144e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801433:	8b 40 08             	mov    0x8(%eax),%eax
  801436:	85 c0                	test   %eax,%eax
  801438:	74 35                	je     80146f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80143a:	83 ec 04             	sub    $0x4,%esp
  80143d:	ff 75 10             	pushl  0x10(%ebp)
  801440:	ff 75 0c             	pushl  0xc(%ebp)
  801443:	52                   	push   %edx
  801444:	ff d0                	call   *%eax
  801446:	83 c4 10             	add    $0x10,%esp
}
  801449:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80144e:	a1 04 40 80 00       	mov    0x804004,%eax
  801453:	8b 40 48             	mov    0x48(%eax),%eax
  801456:	83 ec 04             	sub    $0x4,%esp
  801459:	53                   	push   %ebx
  80145a:	50                   	push   %eax
  80145b:	68 29 26 80 00       	push   $0x802629
  801460:	e8 2f ee ff ff       	call   800294 <cprintf>
		return -E_INVAL;
  801465:	83 c4 10             	add    $0x10,%esp
  801468:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80146d:	eb da                	jmp    801449 <read+0x5a>
		return -E_NOT_SUPP;
  80146f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801474:	eb d3                	jmp    801449 <read+0x5a>

00801476 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	57                   	push   %edi
  80147a:	56                   	push   %esi
  80147b:	53                   	push   %ebx
  80147c:	83 ec 0c             	sub    $0xc,%esp
  80147f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801482:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801485:	bb 00 00 00 00       	mov    $0x0,%ebx
  80148a:	39 f3                	cmp    %esi,%ebx
  80148c:	73 25                	jae    8014b3 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80148e:	83 ec 04             	sub    $0x4,%esp
  801491:	89 f0                	mov    %esi,%eax
  801493:	29 d8                	sub    %ebx,%eax
  801495:	50                   	push   %eax
  801496:	89 d8                	mov    %ebx,%eax
  801498:	03 45 0c             	add    0xc(%ebp),%eax
  80149b:	50                   	push   %eax
  80149c:	57                   	push   %edi
  80149d:	e8 4d ff ff ff       	call   8013ef <read>
		if (m < 0)
  8014a2:	83 c4 10             	add    $0x10,%esp
  8014a5:	85 c0                	test   %eax,%eax
  8014a7:	78 08                	js     8014b1 <readn+0x3b>
			return m;
		if (m == 0)
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	74 06                	je     8014b3 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8014ad:	01 c3                	add    %eax,%ebx
  8014af:	eb d9                	jmp    80148a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014b1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014b3:	89 d8                	mov    %ebx,%eax
  8014b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b8:	5b                   	pop    %ebx
  8014b9:	5e                   	pop    %esi
  8014ba:	5f                   	pop    %edi
  8014bb:	5d                   	pop    %ebp
  8014bc:	c3                   	ret    

008014bd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	53                   	push   %ebx
  8014c1:	83 ec 14             	sub    $0x14,%esp
  8014c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ca:	50                   	push   %eax
  8014cb:	53                   	push   %ebx
  8014cc:	e8 ad fc ff ff       	call   80117e <fd_lookup>
  8014d1:	83 c4 08             	add    $0x8,%esp
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 3a                	js     801512 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d8:	83 ec 08             	sub    $0x8,%esp
  8014db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014de:	50                   	push   %eax
  8014df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e2:	ff 30                	pushl  (%eax)
  8014e4:	e8 eb fc ff ff       	call   8011d4 <dev_lookup>
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 22                	js     801512 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014f7:	74 1e                	je     801517 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fc:	8b 52 0c             	mov    0xc(%edx),%edx
  8014ff:	85 d2                	test   %edx,%edx
  801501:	74 35                	je     801538 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	ff 75 10             	pushl  0x10(%ebp)
  801509:	ff 75 0c             	pushl  0xc(%ebp)
  80150c:	50                   	push   %eax
  80150d:	ff d2                	call   *%edx
  80150f:	83 c4 10             	add    $0x10,%esp
}
  801512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801515:	c9                   	leave  
  801516:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801517:	a1 04 40 80 00       	mov    0x804004,%eax
  80151c:	8b 40 48             	mov    0x48(%eax),%eax
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	53                   	push   %ebx
  801523:	50                   	push   %eax
  801524:	68 45 26 80 00       	push   $0x802645
  801529:	e8 66 ed ff ff       	call   800294 <cprintf>
		return -E_INVAL;
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801536:	eb da                	jmp    801512 <write+0x55>
		return -E_NOT_SUPP;
  801538:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80153d:	eb d3                	jmp    801512 <write+0x55>

0080153f <seek>:

int
seek(int fdnum, off_t offset)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801545:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801548:	50                   	push   %eax
  801549:	ff 75 08             	pushl  0x8(%ebp)
  80154c:	e8 2d fc ff ff       	call   80117e <fd_lookup>
  801551:	83 c4 08             	add    $0x8,%esp
  801554:	85 c0                	test   %eax,%eax
  801556:	78 0e                	js     801566 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801561:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	53                   	push   %ebx
  80156c:	83 ec 14             	sub    $0x14,%esp
  80156f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801572:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801575:	50                   	push   %eax
  801576:	53                   	push   %ebx
  801577:	e8 02 fc ff ff       	call   80117e <fd_lookup>
  80157c:	83 c4 08             	add    $0x8,%esp
  80157f:	85 c0                	test   %eax,%eax
  801581:	78 37                	js     8015ba <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801583:	83 ec 08             	sub    $0x8,%esp
  801586:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801589:	50                   	push   %eax
  80158a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158d:	ff 30                	pushl  (%eax)
  80158f:	e8 40 fc ff ff       	call   8011d4 <dev_lookup>
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	85 c0                	test   %eax,%eax
  801599:	78 1f                	js     8015ba <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015a2:	74 1b                	je     8015bf <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a7:	8b 52 18             	mov    0x18(%edx),%edx
  8015aa:	85 d2                	test   %edx,%edx
  8015ac:	74 32                	je     8015e0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015ae:	83 ec 08             	sub    $0x8,%esp
  8015b1:	ff 75 0c             	pushl  0xc(%ebp)
  8015b4:	50                   	push   %eax
  8015b5:	ff d2                	call   *%edx
  8015b7:	83 c4 10             	add    $0x10,%esp
}
  8015ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015bf:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015c4:	8b 40 48             	mov    0x48(%eax),%eax
  8015c7:	83 ec 04             	sub    $0x4,%esp
  8015ca:	53                   	push   %ebx
  8015cb:	50                   	push   %eax
  8015cc:	68 08 26 80 00       	push   $0x802608
  8015d1:	e8 be ec ff ff       	call   800294 <cprintf>
		return -E_INVAL;
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015de:	eb da                	jmp    8015ba <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015e0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015e5:	eb d3                	jmp    8015ba <ftruncate+0x52>

008015e7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	53                   	push   %ebx
  8015eb:	83 ec 14             	sub    $0x14,%esp
  8015ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f4:	50                   	push   %eax
  8015f5:	ff 75 08             	pushl  0x8(%ebp)
  8015f8:	e8 81 fb ff ff       	call   80117e <fd_lookup>
  8015fd:	83 c4 08             	add    $0x8,%esp
  801600:	85 c0                	test   %eax,%eax
  801602:	78 4b                	js     80164f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801604:	83 ec 08             	sub    $0x8,%esp
  801607:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160a:	50                   	push   %eax
  80160b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160e:	ff 30                	pushl  (%eax)
  801610:	e8 bf fb ff ff       	call   8011d4 <dev_lookup>
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	85 c0                	test   %eax,%eax
  80161a:	78 33                	js     80164f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801623:	74 2f                	je     801654 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801625:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801628:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80162f:	00 00 00 
	stat->st_isdir = 0;
  801632:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801639:	00 00 00 
	stat->st_dev = dev;
  80163c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801642:	83 ec 08             	sub    $0x8,%esp
  801645:	53                   	push   %ebx
  801646:	ff 75 f0             	pushl  -0x10(%ebp)
  801649:	ff 50 14             	call   *0x14(%eax)
  80164c:	83 c4 10             	add    $0x10,%esp
}
  80164f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801652:	c9                   	leave  
  801653:	c3                   	ret    
		return -E_NOT_SUPP;
  801654:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801659:	eb f4                	jmp    80164f <fstat+0x68>

0080165b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	56                   	push   %esi
  80165f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801660:	83 ec 08             	sub    $0x8,%esp
  801663:	6a 00                	push   $0x0
  801665:	ff 75 08             	pushl  0x8(%ebp)
  801668:	e8 e7 01 00 00       	call   801854 <open>
  80166d:	89 c3                	mov    %eax,%ebx
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	85 c0                	test   %eax,%eax
  801674:	78 1b                	js     801691 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	ff 75 0c             	pushl  0xc(%ebp)
  80167c:	50                   	push   %eax
  80167d:	e8 65 ff ff ff       	call   8015e7 <fstat>
  801682:	89 c6                	mov    %eax,%esi
	close(fd);
  801684:	89 1c 24             	mov    %ebx,(%esp)
  801687:	e8 27 fc ff ff       	call   8012b3 <close>
	return r;
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	89 f3                	mov    %esi,%ebx
}
  801691:	89 d8                	mov    %ebx,%eax
  801693:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801696:	5b                   	pop    %ebx
  801697:	5e                   	pop    %esi
  801698:	5d                   	pop    %ebp
  801699:	c3                   	ret    

0080169a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	56                   	push   %esi
  80169e:	53                   	push   %ebx
  80169f:	89 c6                	mov    %eax,%esi
  8016a1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016a3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016aa:	74 27                	je     8016d3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016ac:	6a 07                	push   $0x7
  8016ae:	68 00 50 80 00       	push   $0x805000
  8016b3:	56                   	push   %esi
  8016b4:	ff 35 00 40 80 00    	pushl  0x804000
  8016ba:	e8 f9 f9 ff ff       	call   8010b8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016bf:	83 c4 0c             	add    $0xc,%esp
  8016c2:	6a 00                	push   $0x0
  8016c4:	53                   	push   %ebx
  8016c5:	6a 00                	push   $0x0
  8016c7:	e8 d5 f9 ff ff       	call   8010a1 <ipc_recv>
}
  8016cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016cf:	5b                   	pop    %ebx
  8016d0:	5e                   	pop    %esi
  8016d1:	5d                   	pop    %ebp
  8016d2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016d3:	83 ec 0c             	sub    $0xc,%esp
  8016d6:	6a 01                	push   $0x1
  8016d8:	e8 f2 f9 ff ff       	call   8010cf <ipc_find_env>
  8016dd:	a3 00 40 80 00       	mov    %eax,0x804000
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	eb c5                	jmp    8016ac <fsipc+0x12>

008016e7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801700:	ba 00 00 00 00       	mov    $0x0,%edx
  801705:	b8 02 00 00 00       	mov    $0x2,%eax
  80170a:	e8 8b ff ff ff       	call   80169a <fsipc>
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <devfile_flush>:
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8b 40 0c             	mov    0xc(%eax),%eax
  80171d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801722:	ba 00 00 00 00       	mov    $0x0,%edx
  801727:	b8 06 00 00 00       	mov    $0x6,%eax
  80172c:	e8 69 ff ff ff       	call   80169a <fsipc>
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <devfile_stat>:
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	53                   	push   %ebx
  801737:	83 ec 04             	sub    $0x4,%esp
  80173a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8b 40 0c             	mov    0xc(%eax),%eax
  801743:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801748:	ba 00 00 00 00       	mov    $0x0,%edx
  80174d:	b8 05 00 00 00       	mov    $0x5,%eax
  801752:	e8 43 ff ff ff       	call   80169a <fsipc>
  801757:	85 c0                	test   %eax,%eax
  801759:	78 2c                	js     801787 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80175b:	83 ec 08             	sub    $0x8,%esp
  80175e:	68 00 50 80 00       	push   $0x805000
  801763:	53                   	push   %ebx
  801764:	e8 15 f1 ff ff       	call   80087e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801769:	a1 80 50 80 00       	mov    0x805080,%eax
  80176e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801774:	a1 84 50 80 00       	mov    0x805084,%eax
  801779:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <devfile_write>:
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 0c             	sub    $0xc,%esp
  801792:	8b 45 10             	mov    0x10(%ebp),%eax
  801795:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80179a:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80179f:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a5:	8b 52 0c             	mov    0xc(%edx),%edx
  8017a8:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  8017ae:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8017b3:	50                   	push   %eax
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	68 08 50 80 00       	push   $0x805008
  8017bc:	e8 4b f2 ff ff       	call   800a0c <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c6:	b8 04 00 00 00       	mov    $0x4,%eax
  8017cb:	e8 ca fe ff ff       	call   80169a <fsipc>
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <devfile_read>:
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	56                   	push   %esi
  8017d6:	53                   	push   %ebx
  8017d7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017e5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8017f5:	e8 a0 fe ff ff       	call   80169a <fsipc>
  8017fa:	89 c3                	mov    %eax,%ebx
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	78 1f                	js     80181f <devfile_read+0x4d>
	assert(r <= n);
  801800:	39 f0                	cmp    %esi,%eax
  801802:	77 24                	ja     801828 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801804:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801809:	7f 33                	jg     80183e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80180b:	83 ec 04             	sub    $0x4,%esp
  80180e:	50                   	push   %eax
  80180f:	68 00 50 80 00       	push   $0x805000
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	e8 f0 f1 ff ff       	call   800a0c <memmove>
	return r;
  80181c:	83 c4 10             	add    $0x10,%esp
}
  80181f:	89 d8                	mov    %ebx,%eax
  801821:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801824:	5b                   	pop    %ebx
  801825:	5e                   	pop    %esi
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    
	assert(r <= n);
  801828:	68 74 26 80 00       	push   $0x802674
  80182d:	68 7b 26 80 00       	push   $0x80267b
  801832:	6a 7c                	push   $0x7c
  801834:	68 90 26 80 00       	push   $0x802690
  801839:	e8 85 05 00 00       	call   801dc3 <_panic>
	assert(r <= PGSIZE);
  80183e:	68 9b 26 80 00       	push   $0x80269b
  801843:	68 7b 26 80 00       	push   $0x80267b
  801848:	6a 7d                	push   $0x7d
  80184a:	68 90 26 80 00       	push   $0x802690
  80184f:	e8 6f 05 00 00       	call   801dc3 <_panic>

00801854 <open>:
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	56                   	push   %esi
  801858:	53                   	push   %ebx
  801859:	83 ec 1c             	sub    $0x1c,%esp
  80185c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80185f:	56                   	push   %esi
  801860:	e8 e2 ef ff ff       	call   800847 <strlen>
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80186d:	7f 6c                	jg     8018db <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80186f:	83 ec 0c             	sub    $0xc,%esp
  801872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801875:	50                   	push   %eax
  801876:	e8 b4 f8 ff ff       	call   80112f <fd_alloc>
  80187b:	89 c3                	mov    %eax,%ebx
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	85 c0                	test   %eax,%eax
  801882:	78 3c                	js     8018c0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801884:	83 ec 08             	sub    $0x8,%esp
  801887:	56                   	push   %esi
  801888:	68 00 50 80 00       	push   $0x805000
  80188d:	e8 ec ef ff ff       	call   80087e <strcpy>
	fsipcbuf.open.req_omode = mode;
  801892:	8b 45 0c             	mov    0xc(%ebp),%eax
  801895:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80189a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189d:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a2:	e8 f3 fd ff ff       	call   80169a <fsipc>
  8018a7:	89 c3                	mov    %eax,%ebx
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 19                	js     8018c9 <open+0x75>
	return fd2num(fd);
  8018b0:	83 ec 0c             	sub    $0xc,%esp
  8018b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b6:	e8 4d f8 ff ff       	call   801108 <fd2num>
  8018bb:	89 c3                	mov    %eax,%ebx
  8018bd:	83 c4 10             	add    $0x10,%esp
}
  8018c0:	89 d8                	mov    %ebx,%eax
  8018c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c5:	5b                   	pop    %ebx
  8018c6:	5e                   	pop    %esi
  8018c7:	5d                   	pop    %ebp
  8018c8:	c3                   	ret    
		fd_close(fd, 0);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	6a 00                	push   $0x0
  8018ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d1:	e8 54 f9 ff ff       	call   80122a <fd_close>
		return r;
  8018d6:	83 c4 10             	add    $0x10,%esp
  8018d9:	eb e5                	jmp    8018c0 <open+0x6c>
		return -E_BAD_PATH;
  8018db:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018e0:	eb de                	jmp    8018c0 <open+0x6c>

008018e2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ed:	b8 08 00 00 00       	mov    $0x8,%eax
  8018f2:	e8 a3 fd ff ff       	call   80169a <fsipc>
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	56                   	push   %esi
  8018fd:	53                   	push   %ebx
  8018fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801901:	83 ec 0c             	sub    $0xc,%esp
  801904:	ff 75 08             	pushl  0x8(%ebp)
  801907:	e8 0c f8 ff ff       	call   801118 <fd2data>
  80190c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80190e:	83 c4 08             	add    $0x8,%esp
  801911:	68 a7 26 80 00       	push   $0x8026a7
  801916:	53                   	push   %ebx
  801917:	e8 62 ef ff ff       	call   80087e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80191c:	8b 46 04             	mov    0x4(%esi),%eax
  80191f:	2b 06                	sub    (%esi),%eax
  801921:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801927:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80192e:	00 00 00 
	stat->st_dev = &devpipe;
  801931:	c7 83 88 00 00 00 28 	movl   $0x803028,0x88(%ebx)
  801938:	30 80 00 
	return 0;
}
  80193b:	b8 00 00 00 00       	mov    $0x0,%eax
  801940:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801943:	5b                   	pop    %ebx
  801944:	5e                   	pop    %esi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	53                   	push   %ebx
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801951:	53                   	push   %ebx
  801952:	6a 00                	push   $0x0
  801954:	e8 a3 f3 ff ff       	call   800cfc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801959:	89 1c 24             	mov    %ebx,(%esp)
  80195c:	e8 b7 f7 ff ff       	call   801118 <fd2data>
  801961:	83 c4 08             	add    $0x8,%esp
  801964:	50                   	push   %eax
  801965:	6a 00                	push   $0x0
  801967:	e8 90 f3 ff ff       	call   800cfc <sys_page_unmap>
}
  80196c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <_pipeisclosed>:
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	57                   	push   %edi
  801975:	56                   	push   %esi
  801976:	53                   	push   %ebx
  801977:	83 ec 1c             	sub    $0x1c,%esp
  80197a:	89 c7                	mov    %eax,%edi
  80197c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80197e:	a1 04 40 80 00       	mov    0x804004,%eax
  801983:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801986:	83 ec 0c             	sub    $0xc,%esp
  801989:	57                   	push   %edi
  80198a:	e8 15 05 00 00       	call   801ea4 <pageref>
  80198f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801992:	89 34 24             	mov    %esi,(%esp)
  801995:	e8 0a 05 00 00       	call   801ea4 <pageref>
		nn = thisenv->env_runs;
  80199a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019a0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8019a3:	83 c4 10             	add    $0x10,%esp
  8019a6:	39 cb                	cmp    %ecx,%ebx
  8019a8:	74 1b                	je     8019c5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8019aa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019ad:	75 cf                	jne    80197e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019af:	8b 42 58             	mov    0x58(%edx),%eax
  8019b2:	6a 01                	push   $0x1
  8019b4:	50                   	push   %eax
  8019b5:	53                   	push   %ebx
  8019b6:	68 ae 26 80 00       	push   $0x8026ae
  8019bb:	e8 d4 e8 ff ff       	call   800294 <cprintf>
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	eb b9                	jmp    80197e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8019c5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019c8:	0f 94 c0             	sete   %al
  8019cb:	0f b6 c0             	movzbl %al,%eax
}
  8019ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019d1:	5b                   	pop    %ebx
  8019d2:	5e                   	pop    %esi
  8019d3:	5f                   	pop    %edi
  8019d4:	5d                   	pop    %ebp
  8019d5:	c3                   	ret    

008019d6 <devpipe_write>:
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	57                   	push   %edi
  8019da:	56                   	push   %esi
  8019db:	53                   	push   %ebx
  8019dc:	83 ec 28             	sub    $0x28,%esp
  8019df:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8019e2:	56                   	push   %esi
  8019e3:	e8 30 f7 ff ff       	call   801118 <fd2data>
  8019e8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8019f2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8019f5:	74 4f                	je     801a46 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019f7:	8b 43 04             	mov    0x4(%ebx),%eax
  8019fa:	8b 0b                	mov    (%ebx),%ecx
  8019fc:	8d 51 20             	lea    0x20(%ecx),%edx
  8019ff:	39 d0                	cmp    %edx,%eax
  801a01:	72 14                	jb     801a17 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a03:	89 da                	mov    %ebx,%edx
  801a05:	89 f0                	mov    %esi,%eax
  801a07:	e8 65 ff ff ff       	call   801971 <_pipeisclosed>
  801a0c:	85 c0                	test   %eax,%eax
  801a0e:	75 3a                	jne    801a4a <devpipe_write+0x74>
			sys_yield();
  801a10:	e8 43 f2 ff ff       	call   800c58 <sys_yield>
  801a15:	eb e0                	jmp    8019f7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a1a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a1e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a21:	89 c2                	mov    %eax,%edx
  801a23:	c1 fa 1f             	sar    $0x1f,%edx
  801a26:	89 d1                	mov    %edx,%ecx
  801a28:	c1 e9 1b             	shr    $0x1b,%ecx
  801a2b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a2e:	83 e2 1f             	and    $0x1f,%edx
  801a31:	29 ca                	sub    %ecx,%edx
  801a33:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801a37:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801a3b:	83 c0 01             	add    $0x1,%eax
  801a3e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a41:	83 c7 01             	add    $0x1,%edi
  801a44:	eb ac                	jmp    8019f2 <devpipe_write+0x1c>
	return i;
  801a46:	89 f8                	mov    %edi,%eax
  801a48:	eb 05                	jmp    801a4f <devpipe_write+0x79>
				return 0;
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a52:	5b                   	pop    %ebx
  801a53:	5e                   	pop    %esi
  801a54:	5f                   	pop    %edi
  801a55:	5d                   	pop    %ebp
  801a56:	c3                   	ret    

00801a57 <devpipe_read>:
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	57                   	push   %edi
  801a5b:	56                   	push   %esi
  801a5c:	53                   	push   %ebx
  801a5d:	83 ec 18             	sub    $0x18,%esp
  801a60:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a63:	57                   	push   %edi
  801a64:	e8 af f6 ff ff       	call   801118 <fd2data>
  801a69:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	be 00 00 00 00       	mov    $0x0,%esi
  801a73:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a76:	74 47                	je     801abf <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801a78:	8b 03                	mov    (%ebx),%eax
  801a7a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a7d:	75 22                	jne    801aa1 <devpipe_read+0x4a>
			if (i > 0)
  801a7f:	85 f6                	test   %esi,%esi
  801a81:	75 14                	jne    801a97 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801a83:	89 da                	mov    %ebx,%edx
  801a85:	89 f8                	mov    %edi,%eax
  801a87:	e8 e5 fe ff ff       	call   801971 <_pipeisclosed>
  801a8c:	85 c0                	test   %eax,%eax
  801a8e:	75 33                	jne    801ac3 <devpipe_read+0x6c>
			sys_yield();
  801a90:	e8 c3 f1 ff ff       	call   800c58 <sys_yield>
  801a95:	eb e1                	jmp    801a78 <devpipe_read+0x21>
				return i;
  801a97:	89 f0                	mov    %esi,%eax
}
  801a99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a9c:	5b                   	pop    %ebx
  801a9d:	5e                   	pop    %esi
  801a9e:	5f                   	pop    %edi
  801a9f:	5d                   	pop    %ebp
  801aa0:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801aa1:	99                   	cltd   
  801aa2:	c1 ea 1b             	shr    $0x1b,%edx
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	83 e0 1f             	and    $0x1f,%eax
  801aaa:	29 d0                	sub    %edx,%eax
  801aac:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ab1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ab7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801aba:	83 c6 01             	add    $0x1,%esi
  801abd:	eb b4                	jmp    801a73 <devpipe_read+0x1c>
	return i;
  801abf:	89 f0                	mov    %esi,%eax
  801ac1:	eb d6                	jmp    801a99 <devpipe_read+0x42>
				return 0;
  801ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac8:	eb cf                	jmp    801a99 <devpipe_read+0x42>

00801aca <pipe>:
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	56                   	push   %esi
  801ace:	53                   	push   %ebx
  801acf:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ad2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad5:	50                   	push   %eax
  801ad6:	e8 54 f6 ff ff       	call   80112f <fd_alloc>
  801adb:	89 c3                	mov    %eax,%ebx
  801add:	83 c4 10             	add    $0x10,%esp
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	78 5b                	js     801b3f <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ae4:	83 ec 04             	sub    $0x4,%esp
  801ae7:	68 07 04 00 00       	push   $0x407
  801aec:	ff 75 f4             	pushl  -0xc(%ebp)
  801aef:	6a 00                	push   $0x0
  801af1:	e8 81 f1 ff ff       	call   800c77 <sys_page_alloc>
  801af6:	89 c3                	mov    %eax,%ebx
  801af8:	83 c4 10             	add    $0x10,%esp
  801afb:	85 c0                	test   %eax,%eax
  801afd:	78 40                	js     801b3f <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801aff:	83 ec 0c             	sub    $0xc,%esp
  801b02:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b05:	50                   	push   %eax
  801b06:	e8 24 f6 ff ff       	call   80112f <fd_alloc>
  801b0b:	89 c3                	mov    %eax,%ebx
  801b0d:	83 c4 10             	add    $0x10,%esp
  801b10:	85 c0                	test   %eax,%eax
  801b12:	78 1b                	js     801b2f <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b14:	83 ec 04             	sub    $0x4,%esp
  801b17:	68 07 04 00 00       	push   $0x407
  801b1c:	ff 75 f0             	pushl  -0x10(%ebp)
  801b1f:	6a 00                	push   $0x0
  801b21:	e8 51 f1 ff ff       	call   800c77 <sys_page_alloc>
  801b26:	89 c3                	mov    %eax,%ebx
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	79 19                	jns    801b48 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	ff 75 f4             	pushl  -0xc(%ebp)
  801b35:	6a 00                	push   $0x0
  801b37:	e8 c0 f1 ff ff       	call   800cfc <sys_page_unmap>
  801b3c:	83 c4 10             	add    $0x10,%esp
}
  801b3f:	89 d8                	mov    %ebx,%eax
  801b41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b44:	5b                   	pop    %ebx
  801b45:	5e                   	pop    %esi
  801b46:	5d                   	pop    %ebp
  801b47:	c3                   	ret    
	va = fd2data(fd0);
  801b48:	83 ec 0c             	sub    $0xc,%esp
  801b4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4e:	e8 c5 f5 ff ff       	call   801118 <fd2data>
  801b53:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b55:	83 c4 0c             	add    $0xc,%esp
  801b58:	68 07 04 00 00       	push   $0x407
  801b5d:	50                   	push   %eax
  801b5e:	6a 00                	push   $0x0
  801b60:	e8 12 f1 ff ff       	call   800c77 <sys_page_alloc>
  801b65:	89 c3                	mov    %eax,%ebx
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	0f 88 8c 00 00 00    	js     801bfe <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b72:	83 ec 0c             	sub    $0xc,%esp
  801b75:	ff 75 f0             	pushl  -0x10(%ebp)
  801b78:	e8 9b f5 ff ff       	call   801118 <fd2data>
  801b7d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b84:	50                   	push   %eax
  801b85:	6a 00                	push   $0x0
  801b87:	56                   	push   %esi
  801b88:	6a 00                	push   $0x0
  801b8a:	e8 2b f1 ff ff       	call   800cba <sys_page_map>
  801b8f:	89 c3                	mov    %eax,%ebx
  801b91:	83 c4 20             	add    $0x20,%esp
  801b94:	85 c0                	test   %eax,%eax
  801b96:	78 58                	js     801bf0 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9b:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801ba1:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb0:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801bb6:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801bc2:	83 ec 0c             	sub    $0xc,%esp
  801bc5:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc8:	e8 3b f5 ff ff       	call   801108 <fd2num>
  801bcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bd0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801bd2:	83 c4 04             	add    $0x4,%esp
  801bd5:	ff 75 f0             	pushl  -0x10(%ebp)
  801bd8:	e8 2b f5 ff ff       	call   801108 <fd2num>
  801bdd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801be0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801be3:	83 c4 10             	add    $0x10,%esp
  801be6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801beb:	e9 4f ff ff ff       	jmp    801b3f <pipe+0x75>
	sys_page_unmap(0, va);
  801bf0:	83 ec 08             	sub    $0x8,%esp
  801bf3:	56                   	push   %esi
  801bf4:	6a 00                	push   $0x0
  801bf6:	e8 01 f1 ff ff       	call   800cfc <sys_page_unmap>
  801bfb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801bfe:	83 ec 08             	sub    $0x8,%esp
  801c01:	ff 75 f0             	pushl  -0x10(%ebp)
  801c04:	6a 00                	push   $0x0
  801c06:	e8 f1 f0 ff ff       	call   800cfc <sys_page_unmap>
  801c0b:	83 c4 10             	add    $0x10,%esp
  801c0e:	e9 1c ff ff ff       	jmp    801b2f <pipe+0x65>

00801c13 <pipeisclosed>:
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c1c:	50                   	push   %eax
  801c1d:	ff 75 08             	pushl  0x8(%ebp)
  801c20:	e8 59 f5 ff ff       	call   80117e <fd_lookup>
  801c25:	83 c4 10             	add    $0x10,%esp
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	78 18                	js     801c44 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c2c:	83 ec 0c             	sub    $0xc,%esp
  801c2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c32:	e8 e1 f4 ff ff       	call   801118 <fd2data>
	return _pipeisclosed(fd, p);
  801c37:	89 c2                	mov    %eax,%edx
  801c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3c:	e8 30 fd ff ff       	call   801971 <_pipeisclosed>
  801c41:	83 c4 10             	add    $0x10,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    

00801c50 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801c56:	68 c6 26 80 00       	push   $0x8026c6
  801c5b:	ff 75 0c             	pushl  0xc(%ebp)
  801c5e:	e8 1b ec ff ff       	call   80087e <strcpy>
	return 0;
}
  801c63:	b8 00 00 00 00       	mov    $0x0,%eax
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <devcons_write>:
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	57                   	push   %edi
  801c6e:	56                   	push   %esi
  801c6f:	53                   	push   %ebx
  801c70:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801c76:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801c7b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801c81:	eb 2f                	jmp    801cb2 <devcons_write+0x48>
		m = n - tot;
  801c83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c86:	29 f3                	sub    %esi,%ebx
  801c88:	83 fb 7f             	cmp    $0x7f,%ebx
  801c8b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801c90:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	53                   	push   %ebx
  801c97:	89 f0                	mov    %esi,%eax
  801c99:	03 45 0c             	add    0xc(%ebp),%eax
  801c9c:	50                   	push   %eax
  801c9d:	57                   	push   %edi
  801c9e:	e8 69 ed ff ff       	call   800a0c <memmove>
		sys_cputs(buf, m);
  801ca3:	83 c4 08             	add    $0x8,%esp
  801ca6:	53                   	push   %ebx
  801ca7:	57                   	push   %edi
  801ca8:	e8 0e ef ff ff       	call   800bbb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801cad:	01 de                	add    %ebx,%esi
  801caf:	83 c4 10             	add    $0x10,%esp
  801cb2:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cb5:	72 cc                	jb     801c83 <devcons_write+0x19>
}
  801cb7:	89 f0                	mov    %esi,%eax
  801cb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cbc:	5b                   	pop    %ebx
  801cbd:	5e                   	pop    %esi
  801cbe:	5f                   	pop    %edi
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    

00801cc1 <devcons_read>:
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 08             	sub    $0x8,%esp
  801cc7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ccc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cd0:	75 07                	jne    801cd9 <devcons_read+0x18>
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    
		sys_yield();
  801cd4:	e8 7f ef ff ff       	call   800c58 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801cd9:	e8 fb ee ff ff       	call   800bd9 <sys_cgetc>
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	74 f2                	je     801cd4 <devcons_read+0x13>
	if (c < 0)
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	78 ec                	js     801cd2 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801ce6:	83 f8 04             	cmp    $0x4,%eax
  801ce9:	74 0c                	je     801cf7 <devcons_read+0x36>
	*(char*)vbuf = c;
  801ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cee:	88 02                	mov    %al,(%edx)
	return 1;
  801cf0:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf5:	eb db                	jmp    801cd2 <devcons_read+0x11>
		return 0;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfc:	eb d4                	jmp    801cd2 <devcons_read+0x11>

00801cfe <cputchar>:
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d0a:	6a 01                	push   $0x1
  801d0c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d0f:	50                   	push   %eax
  801d10:	e8 a6 ee ff ff       	call   800bbb <sys_cputs>
}
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <getchar>:
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d20:	6a 01                	push   $0x1
  801d22:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d25:	50                   	push   %eax
  801d26:	6a 00                	push   $0x0
  801d28:	e8 c2 f6 ff ff       	call   8013ef <read>
	if (r < 0)
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	85 c0                	test   %eax,%eax
  801d32:	78 08                	js     801d3c <getchar+0x22>
	if (r < 1)
  801d34:	85 c0                	test   %eax,%eax
  801d36:	7e 06                	jle    801d3e <getchar+0x24>
	return c;
  801d38:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    
		return -E_EOF;
  801d3e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d43:	eb f7                	jmp    801d3c <getchar+0x22>

00801d45 <iscons>:
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d4e:	50                   	push   %eax
  801d4f:	ff 75 08             	pushl  0x8(%ebp)
  801d52:	e8 27 f4 ff ff       	call   80117e <fd_lookup>
  801d57:	83 c4 10             	add    $0x10,%esp
  801d5a:	85 c0                	test   %eax,%eax
  801d5c:	78 11                	js     801d6f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d61:	8b 15 44 30 80 00    	mov    0x803044,%edx
  801d67:	39 10                	cmp    %edx,(%eax)
  801d69:	0f 94 c0             	sete   %al
  801d6c:	0f b6 c0             	movzbl %al,%eax
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <opencons>:
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801d77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d7a:	50                   	push   %eax
  801d7b:	e8 af f3 ff ff       	call   80112f <fd_alloc>
  801d80:	83 c4 10             	add    $0x10,%esp
  801d83:	85 c0                	test   %eax,%eax
  801d85:	78 3a                	js     801dc1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d87:	83 ec 04             	sub    $0x4,%esp
  801d8a:	68 07 04 00 00       	push   $0x407
  801d8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d92:	6a 00                	push   $0x0
  801d94:	e8 de ee ff ff       	call   800c77 <sys_page_alloc>
  801d99:	83 c4 10             	add    $0x10,%esp
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	78 21                	js     801dc1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da3:	8b 15 44 30 80 00    	mov    0x803044,%edx
  801da9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801db5:	83 ec 0c             	sub    $0xc,%esp
  801db8:	50                   	push   %eax
  801db9:	e8 4a f3 ff ff       	call   801108 <fd2num>
  801dbe:	83 c4 10             	add    $0x10,%esp
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	56                   	push   %esi
  801dc7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801dc8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801dcb:	8b 35 08 30 80 00    	mov    0x803008,%esi
  801dd1:	e8 63 ee ff ff       	call   800c39 <sys_getenvid>
  801dd6:	83 ec 0c             	sub    $0xc,%esp
  801dd9:	ff 75 0c             	pushl  0xc(%ebp)
  801ddc:	ff 75 08             	pushl  0x8(%ebp)
  801ddf:	56                   	push   %esi
  801de0:	50                   	push   %eax
  801de1:	68 d4 26 80 00       	push   $0x8026d4
  801de6:	e8 a9 e4 ff ff       	call   800294 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801deb:	83 c4 18             	add    $0x18,%esp
  801dee:	53                   	push   %ebx
  801def:	ff 75 10             	pushl  0x10(%ebp)
  801df2:	e8 4c e4 ff ff       	call   800243 <vcprintf>
	cprintf("\n");
  801df7:	c7 04 24 bf 26 80 00 	movl   $0x8026bf,(%esp)
  801dfe:	e8 91 e4 ff ff       	call   800294 <cprintf>
  801e03:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e06:	cc                   	int3   
  801e07:	eb fd                	jmp    801e06 <_panic+0x43>

00801e09 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	53                   	push   %ebx
  801e0d:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (_pgfault_handler == 0) {
  801e10:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801e17:	74 0d                	je     801e26 <set_pgfault_handler+0x1d>
            		panic("pgfault_handler: %e", r);
        	}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801e21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    
		envid_t e_id = sys_getenvid();
  801e26:	e8 0e ee ff ff       	call   800c39 <sys_getenvid>
  801e2b:	89 c3                	mov    %eax,%ebx
        	r = sys_page_alloc(e_id, (void *)(UXSTACKTOP-PGSIZE), PTE_U | PTE_W | PTE_P);
  801e2d:	83 ec 04             	sub    $0x4,%esp
  801e30:	6a 07                	push   $0x7
  801e32:	68 00 f0 bf ee       	push   $0xeebff000
  801e37:	50                   	push   %eax
  801e38:	e8 3a ee ff ff       	call   800c77 <sys_page_alloc>
        	if (r < 0) {
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	85 c0                	test   %eax,%eax
  801e42:	78 27                	js     801e6b <set_pgfault_handler+0x62>
        	r = sys_env_set_pgfault_upcall(e_id, _pgfault_upcall);
  801e44:	83 ec 08             	sub    $0x8,%esp
  801e47:	68 7d 1e 80 00       	push   $0x801e7d
  801e4c:	53                   	push   %ebx
  801e4d:	e8 70 ef ff ff       	call   800dc2 <sys_env_set_pgfault_upcall>
        	if (r < 0) {
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	85 c0                	test   %eax,%eax
  801e57:	79 c0                	jns    801e19 <set_pgfault_handler+0x10>
            		panic("pgfault_handler: %e", r);
  801e59:	50                   	push   %eax
  801e5a:	68 f8 26 80 00       	push   $0x8026f8
  801e5f:	6a 28                	push   $0x28
  801e61:	68 0c 27 80 00       	push   $0x80270c
  801e66:	e8 58 ff ff ff       	call   801dc3 <_panic>
            		panic("pgfault_handler: %e", r);
  801e6b:	50                   	push   %eax
  801e6c:	68 f8 26 80 00       	push   $0x8026f8
  801e71:	6a 24                	push   $0x24
  801e73:	68 0c 27 80 00       	push   $0x80270c
  801e78:	e8 46 ff ff ff       	call   801dc3 <_panic>

00801e7d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801e7d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801e7e:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801e83:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801e85:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %ebp
  801e88:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	subl $4, %ebp
  801e8c:	83 ed 04             	sub    $0x4,%ebp
	movl %ebp, 48(%esp)
  801e8f:	89 6c 24 30          	mov    %ebp,0x30(%esp)
	movl 40(%esp), %eax
  801e93:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %eax, (%ebp)
  801e97:	89 45 00             	mov    %eax,0x0(%ebp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8, %esp
  801e9a:	83 c4 08             	add    $0x8,%esp
	popal
  801e9d:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	// 跳过 utf_eip
	addl $4, %esp
  801e9e:	83 c4 04             	add    $0x4,%esp
	// 恢复 eflags
	popfl
  801ea1:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	// 恢复 trap-time 的栈顶
	popl %esp
  801ea2:	5c                   	pop    %esp


	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	// ret 指令相当于 popl %eip
	ret
  801ea3:	c3                   	ret    

00801ea4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801eaa:	89 d0                	mov    %edx,%eax
  801eac:	c1 e8 16             	shr    $0x16,%eax
  801eaf:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ebb:	f6 c1 01             	test   $0x1,%cl
  801ebe:	74 1d                	je     801edd <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ec0:	c1 ea 0c             	shr    $0xc,%edx
  801ec3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801eca:	f6 c2 01             	test   $0x1,%dl
  801ecd:	74 0e                	je     801edd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ecf:	c1 ea 0c             	shr    $0xc,%edx
  801ed2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ed9:	ef 
  801eda:	0f b7 c0             	movzwl %ax,%eax
}
  801edd:	5d                   	pop    %ebp
  801ede:	c3                   	ret    
  801edf:	90                   	nop

00801ee0 <__udivdi3>:
  801ee0:	55                   	push   %ebp
  801ee1:	57                   	push   %edi
  801ee2:	56                   	push   %esi
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 1c             	sub    $0x1c,%esp
  801ee7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801eeb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801eef:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ef3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801ef7:	85 d2                	test   %edx,%edx
  801ef9:	75 35                	jne    801f30 <__udivdi3+0x50>
  801efb:	39 f3                	cmp    %esi,%ebx
  801efd:	0f 87 bd 00 00 00    	ja     801fc0 <__udivdi3+0xe0>
  801f03:	85 db                	test   %ebx,%ebx
  801f05:	89 d9                	mov    %ebx,%ecx
  801f07:	75 0b                	jne    801f14 <__udivdi3+0x34>
  801f09:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0e:	31 d2                	xor    %edx,%edx
  801f10:	f7 f3                	div    %ebx
  801f12:	89 c1                	mov    %eax,%ecx
  801f14:	31 d2                	xor    %edx,%edx
  801f16:	89 f0                	mov    %esi,%eax
  801f18:	f7 f1                	div    %ecx
  801f1a:	89 c6                	mov    %eax,%esi
  801f1c:	89 e8                	mov    %ebp,%eax
  801f1e:	89 f7                	mov    %esi,%edi
  801f20:	f7 f1                	div    %ecx
  801f22:	89 fa                	mov    %edi,%edx
  801f24:	83 c4 1c             	add    $0x1c,%esp
  801f27:	5b                   	pop    %ebx
  801f28:	5e                   	pop    %esi
  801f29:	5f                   	pop    %edi
  801f2a:	5d                   	pop    %ebp
  801f2b:	c3                   	ret    
  801f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f30:	39 f2                	cmp    %esi,%edx
  801f32:	77 7c                	ja     801fb0 <__udivdi3+0xd0>
  801f34:	0f bd fa             	bsr    %edx,%edi
  801f37:	83 f7 1f             	xor    $0x1f,%edi
  801f3a:	0f 84 98 00 00 00    	je     801fd8 <__udivdi3+0xf8>
  801f40:	89 f9                	mov    %edi,%ecx
  801f42:	b8 20 00 00 00       	mov    $0x20,%eax
  801f47:	29 f8                	sub    %edi,%eax
  801f49:	d3 e2                	shl    %cl,%edx
  801f4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f4f:	89 c1                	mov    %eax,%ecx
  801f51:	89 da                	mov    %ebx,%edx
  801f53:	d3 ea                	shr    %cl,%edx
  801f55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f59:	09 d1                	or     %edx,%ecx
  801f5b:	89 f2                	mov    %esi,%edx
  801f5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f61:	89 f9                	mov    %edi,%ecx
  801f63:	d3 e3                	shl    %cl,%ebx
  801f65:	89 c1                	mov    %eax,%ecx
  801f67:	d3 ea                	shr    %cl,%edx
  801f69:	89 f9                	mov    %edi,%ecx
  801f6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f6f:	d3 e6                	shl    %cl,%esi
  801f71:	89 eb                	mov    %ebp,%ebx
  801f73:	89 c1                	mov    %eax,%ecx
  801f75:	d3 eb                	shr    %cl,%ebx
  801f77:	09 de                	or     %ebx,%esi
  801f79:	89 f0                	mov    %esi,%eax
  801f7b:	f7 74 24 08          	divl   0x8(%esp)
  801f7f:	89 d6                	mov    %edx,%esi
  801f81:	89 c3                	mov    %eax,%ebx
  801f83:	f7 64 24 0c          	mull   0xc(%esp)
  801f87:	39 d6                	cmp    %edx,%esi
  801f89:	72 0c                	jb     801f97 <__udivdi3+0xb7>
  801f8b:	89 f9                	mov    %edi,%ecx
  801f8d:	d3 e5                	shl    %cl,%ebp
  801f8f:	39 c5                	cmp    %eax,%ebp
  801f91:	73 5d                	jae    801ff0 <__udivdi3+0x110>
  801f93:	39 d6                	cmp    %edx,%esi
  801f95:	75 59                	jne    801ff0 <__udivdi3+0x110>
  801f97:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f9a:	31 ff                	xor    %edi,%edi
  801f9c:	89 fa                	mov    %edi,%edx
  801f9e:	83 c4 1c             	add    $0x1c,%esp
  801fa1:	5b                   	pop    %ebx
  801fa2:	5e                   	pop    %esi
  801fa3:	5f                   	pop    %edi
  801fa4:	5d                   	pop    %ebp
  801fa5:	c3                   	ret    
  801fa6:	8d 76 00             	lea    0x0(%esi),%esi
  801fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801fb0:	31 ff                	xor    %edi,%edi
  801fb2:	31 c0                	xor    %eax,%eax
  801fb4:	89 fa                	mov    %edi,%edx
  801fb6:	83 c4 1c             	add    $0x1c,%esp
  801fb9:	5b                   	pop    %ebx
  801fba:	5e                   	pop    %esi
  801fbb:	5f                   	pop    %edi
  801fbc:	5d                   	pop    %ebp
  801fbd:	c3                   	ret    
  801fbe:	66 90                	xchg   %ax,%ax
  801fc0:	31 ff                	xor    %edi,%edi
  801fc2:	89 e8                	mov    %ebp,%eax
  801fc4:	89 f2                	mov    %esi,%edx
  801fc6:	f7 f3                	div    %ebx
  801fc8:	89 fa                	mov    %edi,%edx
  801fca:	83 c4 1c             	add    $0x1c,%esp
  801fcd:	5b                   	pop    %ebx
  801fce:	5e                   	pop    %esi
  801fcf:	5f                   	pop    %edi
  801fd0:	5d                   	pop    %ebp
  801fd1:	c3                   	ret    
  801fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801fd8:	39 f2                	cmp    %esi,%edx
  801fda:	72 06                	jb     801fe2 <__udivdi3+0x102>
  801fdc:	31 c0                	xor    %eax,%eax
  801fde:	39 eb                	cmp    %ebp,%ebx
  801fe0:	77 d2                	ja     801fb4 <__udivdi3+0xd4>
  801fe2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe7:	eb cb                	jmp    801fb4 <__udivdi3+0xd4>
  801fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ff0:	89 d8                	mov    %ebx,%eax
  801ff2:	31 ff                	xor    %edi,%edi
  801ff4:	eb be                	jmp    801fb4 <__udivdi3+0xd4>
  801ff6:	66 90                	xchg   %ax,%ax
  801ff8:	66 90                	xchg   %ax,%ax
  801ffa:	66 90                	xchg   %ax,%ax
  801ffc:	66 90                	xchg   %ax,%ax
  801ffe:	66 90                	xchg   %ax,%ax

00802000 <__umoddi3>:
  802000:	55                   	push   %ebp
  802001:	57                   	push   %edi
  802002:	56                   	push   %esi
  802003:	53                   	push   %ebx
  802004:	83 ec 1c             	sub    $0x1c,%esp
  802007:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80200b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80200f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802013:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802017:	85 ed                	test   %ebp,%ebp
  802019:	89 f0                	mov    %esi,%eax
  80201b:	89 da                	mov    %ebx,%edx
  80201d:	75 19                	jne    802038 <__umoddi3+0x38>
  80201f:	39 df                	cmp    %ebx,%edi
  802021:	0f 86 b1 00 00 00    	jbe    8020d8 <__umoddi3+0xd8>
  802027:	f7 f7                	div    %edi
  802029:	89 d0                	mov    %edx,%eax
  80202b:	31 d2                	xor    %edx,%edx
  80202d:	83 c4 1c             	add    $0x1c,%esp
  802030:	5b                   	pop    %ebx
  802031:	5e                   	pop    %esi
  802032:	5f                   	pop    %edi
  802033:	5d                   	pop    %ebp
  802034:	c3                   	ret    
  802035:	8d 76 00             	lea    0x0(%esi),%esi
  802038:	39 dd                	cmp    %ebx,%ebp
  80203a:	77 f1                	ja     80202d <__umoddi3+0x2d>
  80203c:	0f bd cd             	bsr    %ebp,%ecx
  80203f:	83 f1 1f             	xor    $0x1f,%ecx
  802042:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802046:	0f 84 b4 00 00 00    	je     802100 <__umoddi3+0x100>
  80204c:	b8 20 00 00 00       	mov    $0x20,%eax
  802051:	89 c2                	mov    %eax,%edx
  802053:	8b 44 24 04          	mov    0x4(%esp),%eax
  802057:	29 c2                	sub    %eax,%edx
  802059:	89 c1                	mov    %eax,%ecx
  80205b:	89 f8                	mov    %edi,%eax
  80205d:	d3 e5                	shl    %cl,%ebp
  80205f:	89 d1                	mov    %edx,%ecx
  802061:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802065:	d3 e8                	shr    %cl,%eax
  802067:	09 c5                	or     %eax,%ebp
  802069:	8b 44 24 04          	mov    0x4(%esp),%eax
  80206d:	89 c1                	mov    %eax,%ecx
  80206f:	d3 e7                	shl    %cl,%edi
  802071:	89 d1                	mov    %edx,%ecx
  802073:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802077:	89 df                	mov    %ebx,%edi
  802079:	d3 ef                	shr    %cl,%edi
  80207b:	89 c1                	mov    %eax,%ecx
  80207d:	89 f0                	mov    %esi,%eax
  80207f:	d3 e3                	shl    %cl,%ebx
  802081:	89 d1                	mov    %edx,%ecx
  802083:	89 fa                	mov    %edi,%edx
  802085:	d3 e8                	shr    %cl,%eax
  802087:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80208c:	09 d8                	or     %ebx,%eax
  80208e:	f7 f5                	div    %ebp
  802090:	d3 e6                	shl    %cl,%esi
  802092:	89 d1                	mov    %edx,%ecx
  802094:	f7 64 24 08          	mull   0x8(%esp)
  802098:	39 d1                	cmp    %edx,%ecx
  80209a:	89 c3                	mov    %eax,%ebx
  80209c:	89 d7                	mov    %edx,%edi
  80209e:	72 06                	jb     8020a6 <__umoddi3+0xa6>
  8020a0:	75 0e                	jne    8020b0 <__umoddi3+0xb0>
  8020a2:	39 c6                	cmp    %eax,%esi
  8020a4:	73 0a                	jae    8020b0 <__umoddi3+0xb0>
  8020a6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8020aa:	19 ea                	sbb    %ebp,%edx
  8020ac:	89 d7                	mov    %edx,%edi
  8020ae:	89 c3                	mov    %eax,%ebx
  8020b0:	89 ca                	mov    %ecx,%edx
  8020b2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8020b7:	29 de                	sub    %ebx,%esi
  8020b9:	19 fa                	sbb    %edi,%edx
  8020bb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8020bf:	89 d0                	mov    %edx,%eax
  8020c1:	d3 e0                	shl    %cl,%eax
  8020c3:	89 d9                	mov    %ebx,%ecx
  8020c5:	d3 ee                	shr    %cl,%esi
  8020c7:	d3 ea                	shr    %cl,%edx
  8020c9:	09 f0                	or     %esi,%eax
  8020cb:	83 c4 1c             	add    $0x1c,%esp
  8020ce:	5b                   	pop    %ebx
  8020cf:	5e                   	pop    %esi
  8020d0:	5f                   	pop    %edi
  8020d1:	5d                   	pop    %ebp
  8020d2:	c3                   	ret    
  8020d3:	90                   	nop
  8020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020d8:	85 ff                	test   %edi,%edi
  8020da:	89 f9                	mov    %edi,%ecx
  8020dc:	75 0b                	jne    8020e9 <__umoddi3+0xe9>
  8020de:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e3:	31 d2                	xor    %edx,%edx
  8020e5:	f7 f7                	div    %edi
  8020e7:	89 c1                	mov    %eax,%ecx
  8020e9:	89 d8                	mov    %ebx,%eax
  8020eb:	31 d2                	xor    %edx,%edx
  8020ed:	f7 f1                	div    %ecx
  8020ef:	89 f0                	mov    %esi,%eax
  8020f1:	f7 f1                	div    %ecx
  8020f3:	e9 31 ff ff ff       	jmp    802029 <__umoddi3+0x29>
  8020f8:	90                   	nop
  8020f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802100:	39 dd                	cmp    %ebx,%ebp
  802102:	72 08                	jb     80210c <__umoddi3+0x10c>
  802104:	39 f7                	cmp    %esi,%edi
  802106:	0f 87 21 ff ff ff    	ja     80202d <__umoddi3+0x2d>
  80210c:	89 da                	mov    %ebx,%edx
  80210e:	89 f0                	mov    %esi,%eax
  802110:	29 f8                	sub    %edi,%eax
  802112:	19 ea                	sbb    %ebp,%edx
  802114:	e9 14 ff ff ff       	jmp    80202d <__umoddi3+0x2d>
