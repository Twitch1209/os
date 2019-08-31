
obj/user/cat.debug：     文件格式 elf32-i386


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
  80002c:	e8 fe 00 00 00       	call   80012f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	68 00 20 00 00       	push   $0x2000
  800043:	68 20 40 80 00       	push   $0x804020
  800048:	56                   	push   %esi
  800049:	e8 d7 10 00 00       	call   801125 <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 8c 11 00 00       	call   8011f3 <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 00 1f 80 00       	push   $0x801f00
  80007a:	6a 0d                	push   $0xd
  80007c:	68 1b 1f 80 00       	push   $0x801f1b
  800081:	e8 09 01 00 00       	call   80018f <_panic>
	if (n < 0)
  800086:	85 c0                	test   %eax,%eax
  800088:	78 07                	js     800091 <cat+0x5e>
		panic("error reading %s: %e", s, n);
}
  80008a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008d:	5b                   	pop    %ebx
  80008e:	5e                   	pop    %esi
  80008f:	5d                   	pop    %ebp
  800090:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	50                   	push   %eax
  800095:	ff 75 0c             	pushl  0xc(%ebp)
  800098:	68 26 1f 80 00       	push   $0x801f26
  80009d:	6a 0f                	push   $0xf
  80009f:	68 1b 1f 80 00       	push   $0x801f1b
  8000a4:	e8 e6 00 00 00       	call   80018f <_panic>

008000a9 <umain>:

void
umain(int argc, char **argv)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	57                   	push   %edi
  8000ad:	56                   	push   %esi
  8000ae:	53                   	push   %ebx
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b5:	c7 05 00 30 80 00 3b 	movl   $0x801f3b,0x803000
  8000bc:	1f 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000bf:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  8000c4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c8:	75 31                	jne    8000fb <umain+0x52>
		cat(0, "<stdin>");
  8000ca:	83 ec 08             	sub    $0x8,%esp
  8000cd:	68 3f 1f 80 00       	push   $0x801f3f
  8000d2:	6a 00                	push   $0x0
  8000d4:	e8 5a ff ff ff       	call   800033 <cat>
  8000d9:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5f                   	pop    %edi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	50                   	push   %eax
  8000e8:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000eb:	68 47 1f 80 00       	push   $0x801f47
  8000f0:	e8 39 16 00 00       	call   80172e <printf>
  8000f5:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f8:	83 c3 01             	add    $0x1,%ebx
  8000fb:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fe:	7d dc                	jge    8000dc <umain+0x33>
			f = open(argv[i], O_RDONLY);
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	6a 00                	push   $0x0
  800105:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800108:	e8 7d 14 00 00       	call   80158a <open>
  80010d:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	85 c0                	test   %eax,%eax
  800114:	78 ce                	js     8000e4 <umain+0x3b>
				cat(f, argv[i]);
  800116:	83 ec 08             	sub    $0x8,%esp
  800119:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80011c:	50                   	push   %eax
  80011d:	e8 11 ff ff ff       	call   800033 <cat>
				close(f);
  800122:	89 34 24             	mov    %esi,(%esp)
  800125:	e8 bf 0e 00 00       	call   800fe9 <close>
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	eb c9                	jmp    8000f8 <umain+0x4f>

0080012f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
  800134:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800137:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80013a:	e8 d0 0a 00 00       	call   800c0f <sys_getenvid>
  80013f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800144:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800147:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014c:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800151:	85 db                	test   %ebx,%ebx
  800153:	7e 07                	jle    80015c <libmain+0x2d>
		binaryname = argv[0];
  800155:	8b 06                	mov    (%esi),%eax
  800157:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
  800161:	e8 43 ff ff ff       	call   8000a9 <umain>

	// exit gracefully
	exit();
  800166:	e8 0a 00 00 00       	call   800175 <exit>
}
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800171:	5b                   	pop    %ebx
  800172:	5e                   	pop    %esi
  800173:	5d                   	pop    %ebp
  800174:	c3                   	ret    

00800175 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80017b:	e8 94 0e 00 00       	call   801014 <close_all>
	sys_env_destroy(0);
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	6a 00                	push   $0x0
  800185:	e8 44 0a 00 00       	call   800bce <sys_env_destroy>
}
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800194:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800197:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80019d:	e8 6d 0a 00 00       	call   800c0f <sys_getenvid>
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	ff 75 0c             	pushl  0xc(%ebp)
  8001a8:	ff 75 08             	pushl  0x8(%ebp)
  8001ab:	56                   	push   %esi
  8001ac:	50                   	push   %eax
  8001ad:	68 64 1f 80 00       	push   $0x801f64
  8001b2:	e8 b3 00 00 00       	call   80026a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b7:	83 c4 18             	add    $0x18,%esp
  8001ba:	53                   	push   %ebx
  8001bb:	ff 75 10             	pushl  0x10(%ebp)
  8001be:	e8 56 00 00 00       	call   800219 <vcprintf>
	cprintf("\n");
  8001c3:	c7 04 24 87 23 80 00 	movl   $0x802387,(%esp)
  8001ca:	e8 9b 00 00 00       	call   80026a <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d2:	cc                   	int3   
  8001d3:	eb fd                	jmp    8001d2 <_panic+0x43>

008001d5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	53                   	push   %ebx
  8001d9:	83 ec 04             	sub    $0x4,%esp
  8001dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001df:	8b 13                	mov    (%ebx),%edx
  8001e1:	8d 42 01             	lea    0x1(%edx),%eax
  8001e4:	89 03                	mov    %eax,(%ebx)
  8001e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f2:	74 09                	je     8001fd <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	68 ff 00 00 00       	push   $0xff
  800205:	8d 43 08             	lea    0x8(%ebx),%eax
  800208:	50                   	push   %eax
  800209:	e8 83 09 00 00       	call   800b91 <sys_cputs>
		b->idx = 0;
  80020e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	eb db                	jmp    8001f4 <putch+0x1f>

00800219 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800222:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800229:	00 00 00 
	b.cnt = 0;
  80022c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800233:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800236:	ff 75 0c             	pushl  0xc(%ebp)
  800239:	ff 75 08             	pushl  0x8(%ebp)
  80023c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800242:	50                   	push   %eax
  800243:	68 d5 01 80 00       	push   $0x8001d5
  800248:	e8 1a 01 00 00       	call   800367 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024d:	83 c4 08             	add    $0x8,%esp
  800250:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800256:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80025c:	50                   	push   %eax
  80025d:	e8 2f 09 00 00       	call   800b91 <sys_cputs>

	return b.cnt;
}
  800262:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800268:	c9                   	leave  
  800269:	c3                   	ret    

0080026a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800270:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800273:	50                   	push   %eax
  800274:	ff 75 08             	pushl  0x8(%ebp)
  800277:	e8 9d ff ff ff       	call   800219 <vcprintf>
	va_end(ap);

	return cnt;
}
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	57                   	push   %edi
  800282:	56                   	push   %esi
  800283:	53                   	push   %ebx
  800284:	83 ec 1c             	sub    $0x1c,%esp
  800287:	89 c7                	mov    %eax,%edi
  800289:	89 d6                	mov    %edx,%esi
  80028b:	8b 45 08             	mov    0x8(%ebp),%eax
  80028e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800291:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800294:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800297:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80029a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80029f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002a2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002a5:	39 d3                	cmp    %edx,%ebx
  8002a7:	72 05                	jb     8002ae <printnum+0x30>
  8002a9:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002ac:	77 7a                	ja     800328 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 18             	pushl  0x18(%ebp)
  8002b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002b7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002ba:	53                   	push   %ebx
  8002bb:	ff 75 10             	pushl  0x10(%ebp)
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8002cd:	e8 de 19 00 00       	call   801cb0 <__udivdi3>
  8002d2:	83 c4 18             	add    $0x18,%esp
  8002d5:	52                   	push   %edx
  8002d6:	50                   	push   %eax
  8002d7:	89 f2                	mov    %esi,%edx
  8002d9:	89 f8                	mov    %edi,%eax
  8002db:	e8 9e ff ff ff       	call   80027e <printnum>
  8002e0:	83 c4 20             	add    $0x20,%esp
  8002e3:	eb 13                	jmp    8002f8 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002e5:	83 ec 08             	sub    $0x8,%esp
  8002e8:	56                   	push   %esi
  8002e9:	ff 75 18             	pushl  0x18(%ebp)
  8002ec:	ff d7                	call   *%edi
  8002ee:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002f1:	83 eb 01             	sub    $0x1,%ebx
  8002f4:	85 db                	test   %ebx,%ebx
  8002f6:	7f ed                	jg     8002e5 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002f8:	83 ec 08             	sub    $0x8,%esp
  8002fb:	56                   	push   %esi
  8002fc:	83 ec 04             	sub    $0x4,%esp
  8002ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800302:	ff 75 e0             	pushl  -0x20(%ebp)
  800305:	ff 75 dc             	pushl  -0x24(%ebp)
  800308:	ff 75 d8             	pushl  -0x28(%ebp)
  80030b:	e8 c0 1a 00 00       	call   801dd0 <__umoddi3>
  800310:	83 c4 14             	add    $0x14,%esp
  800313:	0f be 80 87 1f 80 00 	movsbl 0x801f87(%eax),%eax
  80031a:	50                   	push   %eax
  80031b:	ff d7                	call   *%edi
}
  80031d:	83 c4 10             	add    $0x10,%esp
  800320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800323:	5b                   	pop    %ebx
  800324:	5e                   	pop    %esi
  800325:	5f                   	pop    %edi
  800326:	5d                   	pop    %ebp
  800327:	c3                   	ret    
  800328:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80032b:	eb c4                	jmp    8002f1 <printnum+0x73>

0080032d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800333:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800337:	8b 10                	mov    (%eax),%edx
  800339:	3b 50 04             	cmp    0x4(%eax),%edx
  80033c:	73 0a                	jae    800348 <sprintputch+0x1b>
		*b->buf++ = ch;
  80033e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800341:	89 08                	mov    %ecx,(%eax)
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	88 02                	mov    %al,(%edx)
}
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    

0080034a <printfmt>:
{
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800350:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800353:	50                   	push   %eax
  800354:	ff 75 10             	pushl  0x10(%ebp)
  800357:	ff 75 0c             	pushl  0xc(%ebp)
  80035a:	ff 75 08             	pushl  0x8(%ebp)
  80035d:	e8 05 00 00 00       	call   800367 <vprintfmt>
}
  800362:	83 c4 10             	add    $0x10,%esp
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <vprintfmt>:
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	57                   	push   %edi
  80036b:	56                   	push   %esi
  80036c:	53                   	push   %ebx
  80036d:	83 ec 2c             	sub    $0x2c,%esp
  800370:	8b 75 08             	mov    0x8(%ebp),%esi
  800373:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800376:	8b 7d 10             	mov    0x10(%ebp),%edi
  800379:	e9 8c 03 00 00       	jmp    80070a <vprintfmt+0x3a3>
		padc = ' ';
  80037e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800382:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800389:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800390:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800397:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80039c:	8d 47 01             	lea    0x1(%edi),%eax
  80039f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a2:	0f b6 17             	movzbl (%edi),%edx
  8003a5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a8:	3c 55                	cmp    $0x55,%al
  8003aa:	0f 87 dd 03 00 00    	ja     80078d <vprintfmt+0x426>
  8003b0:	0f b6 c0             	movzbl %al,%eax
  8003b3:	ff 24 85 c0 20 80 00 	jmp    *0x8020c0(,%eax,4)
  8003ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003bd:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003c1:	eb d9                	jmp    80039c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003c6:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003ca:	eb d0                	jmp    80039c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003cc:	0f b6 d2             	movzbl %dl,%edx
  8003cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003da:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003dd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003e1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003e4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003e7:	83 f9 09             	cmp    $0x9,%ecx
  8003ea:	77 55                	ja     800441 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003ec:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ef:	eb e9                	jmp    8003da <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fc:	8d 40 04             	lea    0x4(%eax),%eax
  8003ff:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800405:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800409:	79 91                	jns    80039c <vprintfmt+0x35>
				width = precision, precision = -1;
  80040b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80040e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800411:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800418:	eb 82                	jmp    80039c <vprintfmt+0x35>
  80041a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80041d:	85 c0                	test   %eax,%eax
  80041f:	ba 00 00 00 00       	mov    $0x0,%edx
  800424:	0f 49 d0             	cmovns %eax,%edx
  800427:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80042d:	e9 6a ff ff ff       	jmp    80039c <vprintfmt+0x35>
  800432:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800435:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80043c:	e9 5b ff ff ff       	jmp    80039c <vprintfmt+0x35>
  800441:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800444:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800447:	eb bc                	jmp    800405 <vprintfmt+0x9e>
			lflag++;
  800449:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80044c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80044f:	e9 48 ff ff ff       	jmp    80039c <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8d 78 04             	lea    0x4(%eax),%edi
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	53                   	push   %ebx
  80045e:	ff 30                	pushl  (%eax)
  800460:	ff d6                	call   *%esi
			break;
  800462:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800465:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800468:	e9 9a 02 00 00       	jmp    800707 <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  80046d:	8b 45 14             	mov    0x14(%ebp),%eax
  800470:	8d 78 04             	lea    0x4(%eax),%edi
  800473:	8b 00                	mov    (%eax),%eax
  800475:	99                   	cltd   
  800476:	31 d0                	xor    %edx,%eax
  800478:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047a:	83 f8 0f             	cmp    $0xf,%eax
  80047d:	7f 23                	jg     8004a2 <vprintfmt+0x13b>
  80047f:	8b 14 85 20 22 80 00 	mov    0x802220(,%eax,4),%edx
  800486:	85 d2                	test   %edx,%edx
  800488:	74 18                	je     8004a2 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80048a:	52                   	push   %edx
  80048b:	68 55 23 80 00       	push   $0x802355
  800490:	53                   	push   %ebx
  800491:	56                   	push   %esi
  800492:	e8 b3 fe ff ff       	call   80034a <printfmt>
  800497:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80049d:	e9 65 02 00 00       	jmp    800707 <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8004a2:	50                   	push   %eax
  8004a3:	68 9f 1f 80 00       	push   $0x801f9f
  8004a8:	53                   	push   %ebx
  8004a9:	56                   	push   %esi
  8004aa:	e8 9b fe ff ff       	call   80034a <printfmt>
  8004af:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004b5:	e9 4d 02 00 00       	jmp    800707 <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	83 c0 04             	add    $0x4,%eax
  8004c0:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c6:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004c8:	85 ff                	test   %edi,%edi
  8004ca:	b8 98 1f 80 00       	mov    $0x801f98,%eax
  8004cf:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d6:	0f 8e bd 00 00 00    	jle    800599 <vprintfmt+0x232>
  8004dc:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004e0:	75 0e                	jne    8004f0 <vprintfmt+0x189>
  8004e2:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004eb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004ee:	eb 6d                	jmp    80055d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	ff 75 d0             	pushl  -0x30(%ebp)
  8004f6:	57                   	push   %edi
  8004f7:	e8 39 03 00 00       	call   800835 <strnlen>
  8004fc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ff:	29 c1                	sub    %eax,%ecx
  800501:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800504:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800507:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80050b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80050e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800511:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800513:	eb 0f                	jmp    800524 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	53                   	push   %ebx
  800519:	ff 75 e0             	pushl  -0x20(%ebp)
  80051c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80051e:	83 ef 01             	sub    $0x1,%edi
  800521:	83 c4 10             	add    $0x10,%esp
  800524:	85 ff                	test   %edi,%edi
  800526:	7f ed                	jg     800515 <vprintfmt+0x1ae>
  800528:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80052b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80052e:	85 c9                	test   %ecx,%ecx
  800530:	b8 00 00 00 00       	mov    $0x0,%eax
  800535:	0f 49 c1             	cmovns %ecx,%eax
  800538:	29 c1                	sub    %eax,%ecx
  80053a:	89 75 08             	mov    %esi,0x8(%ebp)
  80053d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800540:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800543:	89 cb                	mov    %ecx,%ebx
  800545:	eb 16                	jmp    80055d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800547:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80054b:	75 31                	jne    80057e <vprintfmt+0x217>
					putch(ch, putdat);
  80054d:	83 ec 08             	sub    $0x8,%esp
  800550:	ff 75 0c             	pushl  0xc(%ebp)
  800553:	50                   	push   %eax
  800554:	ff 55 08             	call   *0x8(%ebp)
  800557:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80055a:	83 eb 01             	sub    $0x1,%ebx
  80055d:	83 c7 01             	add    $0x1,%edi
  800560:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800564:	0f be c2             	movsbl %dl,%eax
  800567:	85 c0                	test   %eax,%eax
  800569:	74 59                	je     8005c4 <vprintfmt+0x25d>
  80056b:	85 f6                	test   %esi,%esi
  80056d:	78 d8                	js     800547 <vprintfmt+0x1e0>
  80056f:	83 ee 01             	sub    $0x1,%esi
  800572:	79 d3                	jns    800547 <vprintfmt+0x1e0>
  800574:	89 df                	mov    %ebx,%edi
  800576:	8b 75 08             	mov    0x8(%ebp),%esi
  800579:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80057c:	eb 37                	jmp    8005b5 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80057e:	0f be d2             	movsbl %dl,%edx
  800581:	83 ea 20             	sub    $0x20,%edx
  800584:	83 fa 5e             	cmp    $0x5e,%edx
  800587:	76 c4                	jbe    80054d <vprintfmt+0x1e6>
					putch('?', putdat);
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	6a 3f                	push   $0x3f
  800591:	ff 55 08             	call   *0x8(%ebp)
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	eb c1                	jmp    80055a <vprintfmt+0x1f3>
  800599:	89 75 08             	mov    %esi,0x8(%ebp)
  80059c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80059f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005a2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005a5:	eb b6                	jmp    80055d <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	53                   	push   %ebx
  8005ab:	6a 20                	push   $0x20
  8005ad:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005af:	83 ef 01             	sub    $0x1,%edi
  8005b2:	83 c4 10             	add    $0x10,%esp
  8005b5:	85 ff                	test   %edi,%edi
  8005b7:	7f ee                	jg     8005a7 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bf:	e9 43 01 00 00       	jmp    800707 <vprintfmt+0x3a0>
  8005c4:	89 df                	mov    %ebx,%edi
  8005c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005cc:	eb e7                	jmp    8005b5 <vprintfmt+0x24e>
	if (lflag >= 2)
  8005ce:	83 f9 01             	cmp    $0x1,%ecx
  8005d1:	7e 3f                	jle    800612 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 50 04             	mov    0x4(%eax),%edx
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8d 40 08             	lea    0x8(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005ee:	79 5c                	jns    80064c <vprintfmt+0x2e5>
				putch('-', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	6a 2d                	push   $0x2d
  8005f6:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005fb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005fe:	f7 da                	neg    %edx
  800600:	83 d1 00             	adc    $0x0,%ecx
  800603:	f7 d9                	neg    %ecx
  800605:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800608:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060d:	e9 db 00 00 00       	jmp    8006ed <vprintfmt+0x386>
	else if (lflag)
  800612:	85 c9                	test   %ecx,%ecx
  800614:	75 1b                	jne    800631 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061e:	89 c1                	mov    %eax,%ecx
  800620:	c1 f9 1f             	sar    $0x1f,%ecx
  800623:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
  80062f:	eb b9                	jmp    8005ea <vprintfmt+0x283>
		return va_arg(*ap, long);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800639:	89 c1                	mov    %eax,%ecx
  80063b:	c1 f9 1f             	sar    $0x1f,%ecx
  80063e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
  80064a:	eb 9e                	jmp    8005ea <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80064c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80064f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800652:	b8 0a 00 00 00       	mov    $0xa,%eax
  800657:	e9 91 00 00 00       	jmp    8006ed <vprintfmt+0x386>
	if (lflag >= 2)
  80065c:	83 f9 01             	cmp    $0x1,%ecx
  80065f:	7e 15                	jle    800676 <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 10                	mov    (%eax),%edx
  800666:	8b 48 04             	mov    0x4(%eax),%ecx
  800669:	8d 40 08             	lea    0x8(%eax),%eax
  80066c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800674:	eb 77                	jmp    8006ed <vprintfmt+0x386>
	else if (lflag)
  800676:	85 c9                	test   %ecx,%ecx
  800678:	75 17                	jne    800691 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8b 10                	mov    (%eax),%edx
  80067f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800684:	8d 40 04             	lea    0x4(%eax),%eax
  800687:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068f:	eb 5c                	jmp    8006ed <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8b 10                	mov    (%eax),%edx
  800696:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069b:	8d 40 04             	lea    0x4(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a6:	eb 45                	jmp    8006ed <vprintfmt+0x386>
			putch('X', putdat);
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	53                   	push   %ebx
  8006ac:	6a 58                	push   $0x58
  8006ae:	ff d6                	call   *%esi
			putch('X', putdat);
  8006b0:	83 c4 08             	add    $0x8,%esp
  8006b3:	53                   	push   %ebx
  8006b4:	6a 58                	push   $0x58
  8006b6:	ff d6                	call   *%esi
			putch('X', putdat);
  8006b8:	83 c4 08             	add    $0x8,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	6a 58                	push   $0x58
  8006be:	ff d6                	call   *%esi
			break;
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	eb 42                	jmp    800707 <vprintfmt+0x3a0>
			putch('0', putdat);
  8006c5:	83 ec 08             	sub    $0x8,%esp
  8006c8:	53                   	push   %ebx
  8006c9:	6a 30                	push   $0x30
  8006cb:	ff d6                	call   *%esi
			putch('x', putdat);
  8006cd:	83 c4 08             	add    $0x8,%esp
  8006d0:	53                   	push   %ebx
  8006d1:	6a 78                	push   $0x78
  8006d3:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8b 10                	mov    (%eax),%edx
  8006da:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006df:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006e2:	8d 40 04             	lea    0x4(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006ed:	83 ec 0c             	sub    $0xc,%esp
  8006f0:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006f4:	57                   	push   %edi
  8006f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f8:	50                   	push   %eax
  8006f9:	51                   	push   %ecx
  8006fa:	52                   	push   %edx
  8006fb:	89 da                	mov    %ebx,%edx
  8006fd:	89 f0                	mov    %esi,%eax
  8006ff:	e8 7a fb ff ff       	call   80027e <printnum>
			break;
  800704:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800707:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070a:	83 c7 01             	add    $0x1,%edi
  80070d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800711:	83 f8 25             	cmp    $0x25,%eax
  800714:	0f 84 64 fc ff ff    	je     80037e <vprintfmt+0x17>
			if (ch == '\0')
  80071a:	85 c0                	test   %eax,%eax
  80071c:	0f 84 8b 00 00 00    	je     8007ad <vprintfmt+0x446>
			putch(ch, putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	53                   	push   %ebx
  800726:	50                   	push   %eax
  800727:	ff d6                	call   *%esi
  800729:	83 c4 10             	add    $0x10,%esp
  80072c:	eb dc                	jmp    80070a <vprintfmt+0x3a3>
	if (lflag >= 2)
  80072e:	83 f9 01             	cmp    $0x1,%ecx
  800731:	7e 15                	jle    800748 <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 10                	mov    (%eax),%edx
  800738:	8b 48 04             	mov    0x4(%eax),%ecx
  80073b:	8d 40 08             	lea    0x8(%eax),%eax
  80073e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800741:	b8 10 00 00 00       	mov    $0x10,%eax
  800746:	eb a5                	jmp    8006ed <vprintfmt+0x386>
	else if (lflag)
  800748:	85 c9                	test   %ecx,%ecx
  80074a:	75 17                	jne    800763 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 10                	mov    (%eax),%edx
  800751:	b9 00 00 00 00       	mov    $0x0,%ecx
  800756:	8d 40 04             	lea    0x4(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075c:	b8 10 00 00 00       	mov    $0x10,%eax
  800761:	eb 8a                	jmp    8006ed <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	8b 10                	mov    (%eax),%edx
  800768:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076d:	8d 40 04             	lea    0x4(%eax),%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800773:	b8 10 00 00 00       	mov    $0x10,%eax
  800778:	e9 70 ff ff ff       	jmp    8006ed <vprintfmt+0x386>
			putch(ch, putdat);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	53                   	push   %ebx
  800781:	6a 25                	push   $0x25
  800783:	ff d6                	call   *%esi
			break;
  800785:	83 c4 10             	add    $0x10,%esp
  800788:	e9 7a ff ff ff       	jmp    800707 <vprintfmt+0x3a0>
			putch('%', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	53                   	push   %ebx
  800791:	6a 25                	push   $0x25
  800793:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800795:	83 c4 10             	add    $0x10,%esp
  800798:	89 f8                	mov    %edi,%eax
  80079a:	eb 03                	jmp    80079f <vprintfmt+0x438>
  80079c:	83 e8 01             	sub    $0x1,%eax
  80079f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007a3:	75 f7                	jne    80079c <vprintfmt+0x435>
  8007a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a8:	e9 5a ff ff ff       	jmp    800707 <vprintfmt+0x3a0>
}
  8007ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007b0:	5b                   	pop    %ebx
  8007b1:	5e                   	pop    %esi
  8007b2:	5f                   	pop    %edi
  8007b3:	5d                   	pop    %ebp
  8007b4:	c3                   	ret    

008007b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	83 ec 18             	sub    $0x18,%esp
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007c4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007d2:	85 c0                	test   %eax,%eax
  8007d4:	74 26                	je     8007fc <vsnprintf+0x47>
  8007d6:	85 d2                	test   %edx,%edx
  8007d8:	7e 22                	jle    8007fc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007da:	ff 75 14             	pushl  0x14(%ebp)
  8007dd:	ff 75 10             	pushl  0x10(%ebp)
  8007e0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e3:	50                   	push   %eax
  8007e4:	68 2d 03 80 00       	push   $0x80032d
  8007e9:	e8 79 fb ff ff       	call   800367 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f7:	83 c4 10             	add    $0x10,%esp
}
  8007fa:	c9                   	leave  
  8007fb:	c3                   	ret    
		return -E_INVAL;
  8007fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800801:	eb f7                	jmp    8007fa <vsnprintf+0x45>

00800803 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800809:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80080c:	50                   	push   %eax
  80080d:	ff 75 10             	pushl  0x10(%ebp)
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	ff 75 08             	pushl  0x8(%ebp)
  800816:	e8 9a ff ff ff       	call   8007b5 <vsnprintf>
	va_end(ap);

	return rc;
}
  80081b:	c9                   	leave  
  80081c:	c3                   	ret    

0080081d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800823:	b8 00 00 00 00       	mov    $0x0,%eax
  800828:	eb 03                	jmp    80082d <strlen+0x10>
		n++;
  80082a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80082d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800831:	75 f7                	jne    80082a <strlen+0xd>
	return n;
}
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
  800843:	eb 03                	jmp    800848 <strnlen+0x13>
		n++;
  800845:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800848:	39 d0                	cmp    %edx,%eax
  80084a:	74 06                	je     800852 <strnlen+0x1d>
  80084c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800850:	75 f3                	jne    800845 <strnlen+0x10>
	return n;
}
  800852:	5d                   	pop    %ebp
  800853:	c3                   	ret    

00800854 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	53                   	push   %ebx
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80085e:	89 c2                	mov    %eax,%edx
  800860:	83 c1 01             	add    $0x1,%ecx
  800863:	83 c2 01             	add    $0x1,%edx
  800866:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80086a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80086d:	84 db                	test   %bl,%bl
  80086f:	75 ef                	jne    800860 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800871:	5b                   	pop    %ebx
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	53                   	push   %ebx
  800878:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80087b:	53                   	push   %ebx
  80087c:	e8 9c ff ff ff       	call   80081d <strlen>
  800881:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800884:	ff 75 0c             	pushl  0xc(%ebp)
  800887:	01 d8                	add    %ebx,%eax
  800889:	50                   	push   %eax
  80088a:	e8 c5 ff ff ff       	call   800854 <strcpy>
	return dst;
}
  80088f:	89 d8                	mov    %ebx,%eax
  800891:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800894:	c9                   	leave  
  800895:	c3                   	ret    

00800896 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	56                   	push   %esi
  80089a:	53                   	push   %ebx
  80089b:	8b 75 08             	mov    0x8(%ebp),%esi
  80089e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a1:	89 f3                	mov    %esi,%ebx
  8008a3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a6:	89 f2                	mov    %esi,%edx
  8008a8:	eb 0f                	jmp    8008b9 <strncpy+0x23>
		*dst++ = *src;
  8008aa:	83 c2 01             	add    $0x1,%edx
  8008ad:	0f b6 01             	movzbl (%ecx),%eax
  8008b0:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b3:	80 39 01             	cmpb   $0x1,(%ecx)
  8008b6:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008b9:	39 da                	cmp    %ebx,%edx
  8008bb:	75 ed                	jne    8008aa <strncpy+0x14>
	}
	return ret;
}
  8008bd:	89 f0                	mov    %esi,%eax
  8008bf:	5b                   	pop    %ebx
  8008c0:	5e                   	pop    %esi
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	56                   	push   %esi
  8008c7:	53                   	push   %ebx
  8008c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8008cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008d1:	89 f0                	mov    %esi,%eax
  8008d3:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d7:	85 c9                	test   %ecx,%ecx
  8008d9:	75 0b                	jne    8008e6 <strlcpy+0x23>
  8008db:	eb 17                	jmp    8008f4 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008dd:	83 c2 01             	add    $0x1,%edx
  8008e0:	83 c0 01             	add    $0x1,%eax
  8008e3:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008e6:	39 d8                	cmp    %ebx,%eax
  8008e8:	74 07                	je     8008f1 <strlcpy+0x2e>
  8008ea:	0f b6 0a             	movzbl (%edx),%ecx
  8008ed:	84 c9                	test   %cl,%cl
  8008ef:	75 ec                	jne    8008dd <strlcpy+0x1a>
		*dst = '\0';
  8008f1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f4:	29 f0                	sub    %esi,%eax
}
  8008f6:	5b                   	pop    %ebx
  8008f7:	5e                   	pop    %esi
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800900:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800903:	eb 06                	jmp    80090b <strcmp+0x11>
		p++, q++;
  800905:	83 c1 01             	add    $0x1,%ecx
  800908:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80090b:	0f b6 01             	movzbl (%ecx),%eax
  80090e:	84 c0                	test   %al,%al
  800910:	74 04                	je     800916 <strcmp+0x1c>
  800912:	3a 02                	cmp    (%edx),%al
  800914:	74 ef                	je     800905 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800916:	0f b6 c0             	movzbl %al,%eax
  800919:	0f b6 12             	movzbl (%edx),%edx
  80091c:	29 d0                	sub    %edx,%eax
}
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	53                   	push   %ebx
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092a:	89 c3                	mov    %eax,%ebx
  80092c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80092f:	eb 06                	jmp    800937 <strncmp+0x17>
		n--, p++, q++;
  800931:	83 c0 01             	add    $0x1,%eax
  800934:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800937:	39 d8                	cmp    %ebx,%eax
  800939:	74 16                	je     800951 <strncmp+0x31>
  80093b:	0f b6 08             	movzbl (%eax),%ecx
  80093e:	84 c9                	test   %cl,%cl
  800940:	74 04                	je     800946 <strncmp+0x26>
  800942:	3a 0a                	cmp    (%edx),%cl
  800944:	74 eb                	je     800931 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800946:	0f b6 00             	movzbl (%eax),%eax
  800949:	0f b6 12             	movzbl (%edx),%edx
  80094c:	29 d0                	sub    %edx,%eax
}
  80094e:	5b                   	pop    %ebx
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    
		return 0;
  800951:	b8 00 00 00 00       	mov    $0x0,%eax
  800956:	eb f6                	jmp    80094e <strncmp+0x2e>

00800958 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800962:	0f b6 10             	movzbl (%eax),%edx
  800965:	84 d2                	test   %dl,%dl
  800967:	74 09                	je     800972 <strchr+0x1a>
		if (*s == c)
  800969:	38 ca                	cmp    %cl,%dl
  80096b:	74 0a                	je     800977 <strchr+0x1f>
	for (; *s; s++)
  80096d:	83 c0 01             	add    $0x1,%eax
  800970:	eb f0                	jmp    800962 <strchr+0xa>
			return (char *) s;
	return 0;
  800972:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800983:	eb 03                	jmp    800988 <strfind+0xf>
  800985:	83 c0 01             	add    $0x1,%eax
  800988:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80098b:	38 ca                	cmp    %cl,%dl
  80098d:	74 04                	je     800993 <strfind+0x1a>
  80098f:	84 d2                	test   %dl,%dl
  800991:	75 f2                	jne    800985 <strfind+0xc>
			break;
	return (char *) s;
}
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	57                   	push   %edi
  800999:	56                   	push   %esi
  80099a:	53                   	push   %ebx
  80099b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80099e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a1:	85 c9                	test   %ecx,%ecx
  8009a3:	74 13                	je     8009b8 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ab:	75 05                	jne    8009b2 <memset+0x1d>
  8009ad:	f6 c1 03             	test   $0x3,%cl
  8009b0:	74 0d                	je     8009bf <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b5:	fc                   	cld    
  8009b6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009b8:	89 f8                	mov    %edi,%eax
  8009ba:	5b                   	pop    %ebx
  8009bb:	5e                   	pop    %esi
  8009bc:	5f                   	pop    %edi
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    
		c &= 0xFF;
  8009bf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c3:	89 d3                	mov    %edx,%ebx
  8009c5:	c1 e3 08             	shl    $0x8,%ebx
  8009c8:	89 d0                	mov    %edx,%eax
  8009ca:	c1 e0 18             	shl    $0x18,%eax
  8009cd:	89 d6                	mov    %edx,%esi
  8009cf:	c1 e6 10             	shl    $0x10,%esi
  8009d2:	09 f0                	or     %esi,%eax
  8009d4:	09 c2                	or     %eax,%edx
  8009d6:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009d8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009db:	89 d0                	mov    %edx,%eax
  8009dd:	fc                   	cld    
  8009de:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e0:	eb d6                	jmp    8009b8 <memset+0x23>

008009e2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	57                   	push   %edi
  8009e6:	56                   	push   %esi
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f0:	39 c6                	cmp    %eax,%esi
  8009f2:	73 35                	jae    800a29 <memmove+0x47>
  8009f4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f7:	39 c2                	cmp    %eax,%edx
  8009f9:	76 2e                	jbe    800a29 <memmove+0x47>
		s += n;
		d += n;
  8009fb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fe:	89 d6                	mov    %edx,%esi
  800a00:	09 fe                	or     %edi,%esi
  800a02:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a08:	74 0c                	je     800a16 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a0a:	83 ef 01             	sub    $0x1,%edi
  800a0d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a10:	fd                   	std    
  800a11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a13:	fc                   	cld    
  800a14:	eb 21                	jmp    800a37 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a16:	f6 c1 03             	test   $0x3,%cl
  800a19:	75 ef                	jne    800a0a <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a1b:	83 ef 04             	sub    $0x4,%edi
  800a1e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a21:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a24:	fd                   	std    
  800a25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a27:	eb ea                	jmp    800a13 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a29:	89 f2                	mov    %esi,%edx
  800a2b:	09 c2                	or     %eax,%edx
  800a2d:	f6 c2 03             	test   $0x3,%dl
  800a30:	74 09                	je     800a3b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a32:	89 c7                	mov    %eax,%edi
  800a34:	fc                   	cld    
  800a35:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a37:	5e                   	pop    %esi
  800a38:	5f                   	pop    %edi
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3b:	f6 c1 03             	test   $0x3,%cl
  800a3e:	75 f2                	jne    800a32 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a40:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a43:	89 c7                	mov    %eax,%edi
  800a45:	fc                   	cld    
  800a46:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a48:	eb ed                	jmp    800a37 <memmove+0x55>

00800a4a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a4d:	ff 75 10             	pushl  0x10(%ebp)
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	ff 75 08             	pushl  0x8(%ebp)
  800a56:	e8 87 ff ff ff       	call   8009e2 <memmove>
}
  800a5b:	c9                   	leave  
  800a5c:	c3                   	ret    

00800a5d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	56                   	push   %esi
  800a61:	53                   	push   %ebx
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a68:	89 c6                	mov    %eax,%esi
  800a6a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6d:	39 f0                	cmp    %esi,%eax
  800a6f:	74 1c                	je     800a8d <memcmp+0x30>
		if (*s1 != *s2)
  800a71:	0f b6 08             	movzbl (%eax),%ecx
  800a74:	0f b6 1a             	movzbl (%edx),%ebx
  800a77:	38 d9                	cmp    %bl,%cl
  800a79:	75 08                	jne    800a83 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a7b:	83 c0 01             	add    $0x1,%eax
  800a7e:	83 c2 01             	add    $0x1,%edx
  800a81:	eb ea                	jmp    800a6d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a83:	0f b6 c1             	movzbl %cl,%eax
  800a86:	0f b6 db             	movzbl %bl,%ebx
  800a89:	29 d8                	sub    %ebx,%eax
  800a8b:	eb 05                	jmp    800a92 <memcmp+0x35>
	}

	return 0;
  800a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a92:	5b                   	pop    %ebx
  800a93:	5e                   	pop    %esi
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a9f:	89 c2                	mov    %eax,%edx
  800aa1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa4:	39 d0                	cmp    %edx,%eax
  800aa6:	73 09                	jae    800ab1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aa8:	38 08                	cmp    %cl,(%eax)
  800aaa:	74 05                	je     800ab1 <memfind+0x1b>
	for (; s < ends; s++)
  800aac:	83 c0 01             	add    $0x1,%eax
  800aaf:	eb f3                	jmp    800aa4 <memfind+0xe>
			break;
	return (void *) s;
}
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	57                   	push   %edi
  800ab7:	56                   	push   %esi
  800ab8:	53                   	push   %ebx
  800ab9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800abc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800abf:	eb 03                	jmp    800ac4 <strtol+0x11>
		s++;
  800ac1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ac4:	0f b6 01             	movzbl (%ecx),%eax
  800ac7:	3c 20                	cmp    $0x20,%al
  800ac9:	74 f6                	je     800ac1 <strtol+0xe>
  800acb:	3c 09                	cmp    $0x9,%al
  800acd:	74 f2                	je     800ac1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800acf:	3c 2b                	cmp    $0x2b,%al
  800ad1:	74 2e                	je     800b01 <strtol+0x4e>
	int neg = 0;
  800ad3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ad8:	3c 2d                	cmp    $0x2d,%al
  800ada:	74 2f                	je     800b0b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800adc:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ae2:	75 05                	jne    800ae9 <strtol+0x36>
  800ae4:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae7:	74 2c                	je     800b15 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ae9:	85 db                	test   %ebx,%ebx
  800aeb:	75 0a                	jne    800af7 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aed:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800af2:	80 39 30             	cmpb   $0x30,(%ecx)
  800af5:	74 28                	je     800b1f <strtol+0x6c>
		base = 10;
  800af7:	b8 00 00 00 00       	mov    $0x0,%eax
  800afc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aff:	eb 50                	jmp    800b51 <strtol+0x9e>
		s++;
  800b01:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b04:	bf 00 00 00 00       	mov    $0x0,%edi
  800b09:	eb d1                	jmp    800adc <strtol+0x29>
		s++, neg = 1;
  800b0b:	83 c1 01             	add    $0x1,%ecx
  800b0e:	bf 01 00 00 00       	mov    $0x1,%edi
  800b13:	eb c7                	jmp    800adc <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b15:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b19:	74 0e                	je     800b29 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b1b:	85 db                	test   %ebx,%ebx
  800b1d:	75 d8                	jne    800af7 <strtol+0x44>
		s++, base = 8;
  800b1f:	83 c1 01             	add    $0x1,%ecx
  800b22:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b27:	eb ce                	jmp    800af7 <strtol+0x44>
		s += 2, base = 16;
  800b29:	83 c1 02             	add    $0x2,%ecx
  800b2c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b31:	eb c4                	jmp    800af7 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b33:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b36:	89 f3                	mov    %esi,%ebx
  800b38:	80 fb 19             	cmp    $0x19,%bl
  800b3b:	77 29                	ja     800b66 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b3d:	0f be d2             	movsbl %dl,%edx
  800b40:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b43:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b46:	7d 30                	jge    800b78 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b48:	83 c1 01             	add    $0x1,%ecx
  800b4b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b4f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b51:	0f b6 11             	movzbl (%ecx),%edx
  800b54:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b57:	89 f3                	mov    %esi,%ebx
  800b59:	80 fb 09             	cmp    $0x9,%bl
  800b5c:	77 d5                	ja     800b33 <strtol+0x80>
			dig = *s - '0';
  800b5e:	0f be d2             	movsbl %dl,%edx
  800b61:	83 ea 30             	sub    $0x30,%edx
  800b64:	eb dd                	jmp    800b43 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b66:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b69:	89 f3                	mov    %esi,%ebx
  800b6b:	80 fb 19             	cmp    $0x19,%bl
  800b6e:	77 08                	ja     800b78 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b70:	0f be d2             	movsbl %dl,%edx
  800b73:	83 ea 37             	sub    $0x37,%edx
  800b76:	eb cb                	jmp    800b43 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7c:	74 05                	je     800b83 <strtol+0xd0>
		*endptr = (char *) s;
  800b7e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b81:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b83:	89 c2                	mov    %eax,%edx
  800b85:	f7 da                	neg    %edx
  800b87:	85 ff                	test   %edi,%edi
  800b89:	0f 45 c2             	cmovne %edx,%eax
}
  800b8c:	5b                   	pop    %ebx
  800b8d:	5e                   	pop    %esi
  800b8e:	5f                   	pop    %edi
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    

00800b91 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	57                   	push   %edi
  800b95:	56                   	push   %esi
  800b96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b97:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba2:	89 c3                	mov    %eax,%ebx
  800ba4:	89 c7                	mov    %eax,%edi
  800ba6:	89 c6                	mov    %eax,%esi
  800ba8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800baa:	5b                   	pop    %ebx
  800bab:	5e                   	pop    %esi
  800bac:	5f                   	pop    %edi
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <sys_cgetc>:

int
sys_cgetc(void)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	57                   	push   %edi
  800bb3:	56                   	push   %esi
  800bb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bba:	b8 01 00 00 00       	mov    $0x1,%eax
  800bbf:	89 d1                	mov    %edx,%ecx
  800bc1:	89 d3                	mov    %edx,%ebx
  800bc3:	89 d7                	mov    %edx,%edi
  800bc5:	89 d6                	mov    %edx,%esi
  800bc7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc9:	5b                   	pop    %ebx
  800bca:	5e                   	pop    %esi
  800bcb:	5f                   	pop    %edi
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    

00800bce <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	57                   	push   %edi
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
  800bd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdf:	b8 03 00 00 00       	mov    $0x3,%eax
  800be4:	89 cb                	mov    %ecx,%ebx
  800be6:	89 cf                	mov    %ecx,%edi
  800be8:	89 ce                	mov    %ecx,%esi
  800bea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bec:	85 c0                	test   %eax,%eax
  800bee:	7f 08                	jg     800bf8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf3:	5b                   	pop    %ebx
  800bf4:	5e                   	pop    %esi
  800bf5:	5f                   	pop    %edi
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf8:	83 ec 0c             	sub    $0xc,%esp
  800bfb:	50                   	push   %eax
  800bfc:	6a 03                	push   $0x3
  800bfe:	68 7f 22 80 00       	push   $0x80227f
  800c03:	6a 23                	push   $0x23
  800c05:	68 9c 22 80 00       	push   $0x80229c
  800c0a:	e8 80 f5 ff ff       	call   80018f <_panic>

00800c0f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	57                   	push   %edi
  800c13:	56                   	push   %esi
  800c14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c15:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1a:	b8 02 00 00 00       	mov    $0x2,%eax
  800c1f:	89 d1                	mov    %edx,%ecx
  800c21:	89 d3                	mov    %edx,%ebx
  800c23:	89 d7                	mov    %edx,%edi
  800c25:	89 d6                	mov    %edx,%esi
  800c27:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c29:	5b                   	pop    %ebx
  800c2a:	5e                   	pop    %esi
  800c2b:	5f                   	pop    %edi
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <sys_yield>:

void
sys_yield(void)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	57                   	push   %edi
  800c32:	56                   	push   %esi
  800c33:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c34:	ba 00 00 00 00       	mov    $0x0,%edx
  800c39:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c3e:	89 d1                	mov    %edx,%ecx
  800c40:	89 d3                	mov    %edx,%ebx
  800c42:	89 d7                	mov    %edx,%edi
  800c44:	89 d6                	mov    %edx,%esi
  800c46:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5f                   	pop    %edi
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    

00800c4d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	57                   	push   %edi
  800c51:	56                   	push   %esi
  800c52:	53                   	push   %ebx
  800c53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c56:	be 00 00 00 00       	mov    $0x0,%esi
  800c5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c61:	b8 04 00 00 00       	mov    $0x4,%eax
  800c66:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c69:	89 f7                	mov    %esi,%edi
  800c6b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6d:	85 c0                	test   %eax,%eax
  800c6f:	7f 08                	jg     800c79 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c74:	5b                   	pop    %ebx
  800c75:	5e                   	pop    %esi
  800c76:	5f                   	pop    %edi
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c79:	83 ec 0c             	sub    $0xc,%esp
  800c7c:	50                   	push   %eax
  800c7d:	6a 04                	push   $0x4
  800c7f:	68 7f 22 80 00       	push   $0x80227f
  800c84:	6a 23                	push   $0x23
  800c86:	68 9c 22 80 00       	push   $0x80229c
  800c8b:	e8 ff f4 ff ff       	call   80018f <_panic>

00800c90 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	57                   	push   %edi
  800c94:	56                   	push   %esi
  800c95:	53                   	push   %ebx
  800c96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c99:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9f:	b8 05 00 00 00       	mov    $0x5,%eax
  800ca4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800caa:	8b 75 18             	mov    0x18(%ebp),%esi
  800cad:	cd 30                	int    $0x30
	if(check && ret > 0)
  800caf:	85 c0                	test   %eax,%eax
  800cb1:	7f 08                	jg     800cbb <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5f                   	pop    %edi
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbb:	83 ec 0c             	sub    $0xc,%esp
  800cbe:	50                   	push   %eax
  800cbf:	6a 05                	push   $0x5
  800cc1:	68 7f 22 80 00       	push   $0x80227f
  800cc6:	6a 23                	push   $0x23
  800cc8:	68 9c 22 80 00       	push   $0x80229c
  800ccd:	e8 bd f4 ff ff       	call   80018f <_panic>

00800cd2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	57                   	push   %edi
  800cd6:	56                   	push   %esi
  800cd7:	53                   	push   %ebx
  800cd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce6:	b8 06 00 00 00       	mov    $0x6,%eax
  800ceb:	89 df                	mov    %ebx,%edi
  800ced:	89 de                	mov    %ebx,%esi
  800cef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	7f 08                	jg     800cfd <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf8:	5b                   	pop    %ebx
  800cf9:	5e                   	pop    %esi
  800cfa:	5f                   	pop    %edi
  800cfb:	5d                   	pop    %ebp
  800cfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfd:	83 ec 0c             	sub    $0xc,%esp
  800d00:	50                   	push   %eax
  800d01:	6a 06                	push   $0x6
  800d03:	68 7f 22 80 00       	push   $0x80227f
  800d08:	6a 23                	push   $0x23
  800d0a:	68 9c 22 80 00       	push   $0x80229c
  800d0f:	e8 7b f4 ff ff       	call   80018f <_panic>

00800d14 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	57                   	push   %edi
  800d18:	56                   	push   %esi
  800d19:	53                   	push   %ebx
  800d1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d22:	8b 55 08             	mov    0x8(%ebp),%edx
  800d25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d28:	b8 08 00 00 00       	mov    $0x8,%eax
  800d2d:	89 df                	mov    %ebx,%edi
  800d2f:	89 de                	mov    %ebx,%esi
  800d31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d33:	85 c0                	test   %eax,%eax
  800d35:	7f 08                	jg     800d3f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3f:	83 ec 0c             	sub    $0xc,%esp
  800d42:	50                   	push   %eax
  800d43:	6a 08                	push   $0x8
  800d45:	68 7f 22 80 00       	push   $0x80227f
  800d4a:	6a 23                	push   $0x23
  800d4c:	68 9c 22 80 00       	push   $0x80229c
  800d51:	e8 39 f4 ff ff       	call   80018f <_panic>

00800d56 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	57                   	push   %edi
  800d5a:	56                   	push   %esi
  800d5b:	53                   	push   %ebx
  800d5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d6f:	89 df                	mov    %ebx,%edi
  800d71:	89 de                	mov    %ebx,%esi
  800d73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d75:	85 c0                	test   %eax,%eax
  800d77:	7f 08                	jg     800d81 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	50                   	push   %eax
  800d85:	6a 09                	push   $0x9
  800d87:	68 7f 22 80 00       	push   $0x80227f
  800d8c:	6a 23                	push   $0x23
  800d8e:	68 9c 22 80 00       	push   $0x80229c
  800d93:	e8 f7 f3 ff ff       	call   80018f <_panic>

00800d98 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
  800d9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dac:	b8 0a 00 00 00       	mov    $0xa,%eax
  800db1:	89 df                	mov    %ebx,%edi
  800db3:	89 de                	mov    %ebx,%esi
  800db5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db7:	85 c0                	test   %eax,%eax
  800db9:	7f 08                	jg     800dc3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	50                   	push   %eax
  800dc7:	6a 0a                	push   $0xa
  800dc9:	68 7f 22 80 00       	push   $0x80227f
  800dce:	6a 23                	push   $0x23
  800dd0:	68 9c 22 80 00       	push   $0x80229c
  800dd5:	e8 b5 f3 ff ff       	call   80018f <_panic>

00800dda <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de0:	8b 55 08             	mov    0x8(%ebp),%edx
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800deb:	be 00 00 00 00       	mov    $0x0,%esi
  800df0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5f                   	pop    %edi
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	57                   	push   %edi
  800e01:	56                   	push   %esi
  800e02:	53                   	push   %ebx
  800e03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e06:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e13:	89 cb                	mov    %ecx,%ebx
  800e15:	89 cf                	mov    %ecx,%edi
  800e17:	89 ce                	mov    %ecx,%esi
  800e19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	7f 08                	jg     800e27 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e27:	83 ec 0c             	sub    $0xc,%esp
  800e2a:	50                   	push   %eax
  800e2b:	6a 0d                	push   $0xd
  800e2d:	68 7f 22 80 00       	push   $0x80227f
  800e32:	6a 23                	push   $0x23
  800e34:	68 9c 22 80 00       	push   $0x80229c
  800e39:	e8 51 f3 ff ff       	call   80018f <_panic>

00800e3e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	05 00 00 00 30       	add    $0x30000000,%eax
  800e49:	c1 e8 0c             	shr    $0xc,%eax
}
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    

00800e4e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e5e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e70:	89 c2                	mov    %eax,%edx
  800e72:	c1 ea 16             	shr    $0x16,%edx
  800e75:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e7c:	f6 c2 01             	test   $0x1,%dl
  800e7f:	74 2a                	je     800eab <fd_alloc+0x46>
  800e81:	89 c2                	mov    %eax,%edx
  800e83:	c1 ea 0c             	shr    $0xc,%edx
  800e86:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e8d:	f6 c2 01             	test   $0x1,%dl
  800e90:	74 19                	je     800eab <fd_alloc+0x46>
  800e92:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e97:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e9c:	75 d2                	jne    800e70 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e9e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ea4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ea9:	eb 07                	jmp    800eb2 <fd_alloc+0x4d>
			*fd_store = fd;
  800eab:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800eba:	83 f8 1f             	cmp    $0x1f,%eax
  800ebd:	77 36                	ja     800ef5 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ebf:	c1 e0 0c             	shl    $0xc,%eax
  800ec2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ec7:	89 c2                	mov    %eax,%edx
  800ec9:	c1 ea 16             	shr    $0x16,%edx
  800ecc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ed3:	f6 c2 01             	test   $0x1,%dl
  800ed6:	74 24                	je     800efc <fd_lookup+0x48>
  800ed8:	89 c2                	mov    %eax,%edx
  800eda:	c1 ea 0c             	shr    $0xc,%edx
  800edd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ee4:	f6 c2 01             	test   $0x1,%dl
  800ee7:	74 1a                	je     800f03 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eec:	89 02                	mov    %eax,(%edx)
	return 0;
  800eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    
		return -E_INVAL;
  800ef5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800efa:	eb f7                	jmp    800ef3 <fd_lookup+0x3f>
		return -E_INVAL;
  800efc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f01:	eb f0                	jmp    800ef3 <fd_lookup+0x3f>
  800f03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f08:	eb e9                	jmp    800ef3 <fd_lookup+0x3f>

00800f0a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 08             	sub    $0x8,%esp
  800f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f13:	ba 2c 23 80 00       	mov    $0x80232c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f18:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f1d:	39 08                	cmp    %ecx,(%eax)
  800f1f:	74 33                	je     800f54 <dev_lookup+0x4a>
  800f21:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f24:	8b 02                	mov    (%edx),%eax
  800f26:	85 c0                	test   %eax,%eax
  800f28:	75 f3                	jne    800f1d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f2a:	a1 20 60 80 00       	mov    0x806020,%eax
  800f2f:	8b 40 48             	mov    0x48(%eax),%eax
  800f32:	83 ec 04             	sub    $0x4,%esp
  800f35:	51                   	push   %ecx
  800f36:	50                   	push   %eax
  800f37:	68 ac 22 80 00       	push   $0x8022ac
  800f3c:	e8 29 f3 ff ff       	call   80026a <cprintf>
	*dev = 0;
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f4a:	83 c4 10             	add    $0x10,%esp
  800f4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f52:	c9                   	leave  
  800f53:	c3                   	ret    
			*dev = devtab[i];
  800f54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f57:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f59:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5e:	eb f2                	jmp    800f52 <dev_lookup+0x48>

00800f60 <fd_close>:
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
  800f66:	83 ec 1c             	sub    $0x1c,%esp
  800f69:	8b 75 08             	mov    0x8(%ebp),%esi
  800f6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f6f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f72:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f73:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f79:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f7c:	50                   	push   %eax
  800f7d:	e8 32 ff ff ff       	call   800eb4 <fd_lookup>
  800f82:	89 c3                	mov    %eax,%ebx
  800f84:	83 c4 08             	add    $0x8,%esp
  800f87:	85 c0                	test   %eax,%eax
  800f89:	78 05                	js     800f90 <fd_close+0x30>
	    || fd != fd2)
  800f8b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f8e:	74 16                	je     800fa6 <fd_close+0x46>
		return (must_exist ? r : 0);
  800f90:	89 f8                	mov    %edi,%eax
  800f92:	84 c0                	test   %al,%al
  800f94:	b8 00 00 00 00       	mov    $0x0,%eax
  800f99:	0f 44 d8             	cmove  %eax,%ebx
}
  800f9c:	89 d8                	mov    %ebx,%eax
  800f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fa6:	83 ec 08             	sub    $0x8,%esp
  800fa9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fac:	50                   	push   %eax
  800fad:	ff 36                	pushl  (%esi)
  800faf:	e8 56 ff ff ff       	call   800f0a <dev_lookup>
  800fb4:	89 c3                	mov    %eax,%ebx
  800fb6:	83 c4 10             	add    $0x10,%esp
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	78 15                	js     800fd2 <fd_close+0x72>
		if (dev->dev_close)
  800fbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fc0:	8b 40 10             	mov    0x10(%eax),%eax
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	74 1b                	je     800fe2 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800fc7:	83 ec 0c             	sub    $0xc,%esp
  800fca:	56                   	push   %esi
  800fcb:	ff d0                	call   *%eax
  800fcd:	89 c3                	mov    %eax,%ebx
  800fcf:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	56                   	push   %esi
  800fd6:	6a 00                	push   $0x0
  800fd8:	e8 f5 fc ff ff       	call   800cd2 <sys_page_unmap>
	return r;
  800fdd:	83 c4 10             	add    $0x10,%esp
  800fe0:	eb ba                	jmp    800f9c <fd_close+0x3c>
			r = 0;
  800fe2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe7:	eb e9                	jmp    800fd2 <fd_close+0x72>

00800fe9 <close>:

int
close(int fdnum)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ff2:	50                   	push   %eax
  800ff3:	ff 75 08             	pushl  0x8(%ebp)
  800ff6:	e8 b9 fe ff ff       	call   800eb4 <fd_lookup>
  800ffb:	83 c4 08             	add    $0x8,%esp
  800ffe:	85 c0                	test   %eax,%eax
  801000:	78 10                	js     801012 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801002:	83 ec 08             	sub    $0x8,%esp
  801005:	6a 01                	push   $0x1
  801007:	ff 75 f4             	pushl  -0xc(%ebp)
  80100a:	e8 51 ff ff ff       	call   800f60 <fd_close>
  80100f:	83 c4 10             	add    $0x10,%esp
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <close_all>:

void
close_all(void)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	53                   	push   %ebx
  801018:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80101b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801020:	83 ec 0c             	sub    $0xc,%esp
  801023:	53                   	push   %ebx
  801024:	e8 c0 ff ff ff       	call   800fe9 <close>
	for (i = 0; i < MAXFD; i++)
  801029:	83 c3 01             	add    $0x1,%ebx
  80102c:	83 c4 10             	add    $0x10,%esp
  80102f:	83 fb 20             	cmp    $0x20,%ebx
  801032:	75 ec                	jne    801020 <close_all+0xc>
}
  801034:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	57                   	push   %edi
  80103d:	56                   	push   %esi
  80103e:	53                   	push   %ebx
  80103f:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801042:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801045:	50                   	push   %eax
  801046:	ff 75 08             	pushl  0x8(%ebp)
  801049:	e8 66 fe ff ff       	call   800eb4 <fd_lookup>
  80104e:	89 c3                	mov    %eax,%ebx
  801050:	83 c4 08             	add    $0x8,%esp
  801053:	85 c0                	test   %eax,%eax
  801055:	0f 88 81 00 00 00    	js     8010dc <dup+0xa3>
		return r;
	close(newfdnum);
  80105b:	83 ec 0c             	sub    $0xc,%esp
  80105e:	ff 75 0c             	pushl  0xc(%ebp)
  801061:	e8 83 ff ff ff       	call   800fe9 <close>

	newfd = INDEX2FD(newfdnum);
  801066:	8b 75 0c             	mov    0xc(%ebp),%esi
  801069:	c1 e6 0c             	shl    $0xc,%esi
  80106c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801072:	83 c4 04             	add    $0x4,%esp
  801075:	ff 75 e4             	pushl  -0x1c(%ebp)
  801078:	e8 d1 fd ff ff       	call   800e4e <fd2data>
  80107d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80107f:	89 34 24             	mov    %esi,(%esp)
  801082:	e8 c7 fd ff ff       	call   800e4e <fd2data>
  801087:	83 c4 10             	add    $0x10,%esp
  80108a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80108c:	89 d8                	mov    %ebx,%eax
  80108e:	c1 e8 16             	shr    $0x16,%eax
  801091:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801098:	a8 01                	test   $0x1,%al
  80109a:	74 11                	je     8010ad <dup+0x74>
  80109c:	89 d8                	mov    %ebx,%eax
  80109e:	c1 e8 0c             	shr    $0xc,%eax
  8010a1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010a8:	f6 c2 01             	test   $0x1,%dl
  8010ab:	75 39                	jne    8010e6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010b0:	89 d0                	mov    %edx,%eax
  8010b2:	c1 e8 0c             	shr    $0xc,%eax
  8010b5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010bc:	83 ec 0c             	sub    $0xc,%esp
  8010bf:	25 07 0e 00 00       	and    $0xe07,%eax
  8010c4:	50                   	push   %eax
  8010c5:	56                   	push   %esi
  8010c6:	6a 00                	push   $0x0
  8010c8:	52                   	push   %edx
  8010c9:	6a 00                	push   $0x0
  8010cb:	e8 c0 fb ff ff       	call   800c90 <sys_page_map>
  8010d0:	89 c3                	mov    %eax,%ebx
  8010d2:	83 c4 20             	add    $0x20,%esp
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	78 31                	js     80110a <dup+0xd1>
		goto err;

	return newfdnum;
  8010d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010dc:	89 d8                	mov    %ebx,%eax
  8010de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e1:	5b                   	pop    %ebx
  8010e2:	5e                   	pop    %esi
  8010e3:	5f                   	pop    %edi
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010e6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010ed:	83 ec 0c             	sub    $0xc,%esp
  8010f0:	25 07 0e 00 00       	and    $0xe07,%eax
  8010f5:	50                   	push   %eax
  8010f6:	57                   	push   %edi
  8010f7:	6a 00                	push   $0x0
  8010f9:	53                   	push   %ebx
  8010fa:	6a 00                	push   $0x0
  8010fc:	e8 8f fb ff ff       	call   800c90 <sys_page_map>
  801101:	89 c3                	mov    %eax,%ebx
  801103:	83 c4 20             	add    $0x20,%esp
  801106:	85 c0                	test   %eax,%eax
  801108:	79 a3                	jns    8010ad <dup+0x74>
	sys_page_unmap(0, newfd);
  80110a:	83 ec 08             	sub    $0x8,%esp
  80110d:	56                   	push   %esi
  80110e:	6a 00                	push   $0x0
  801110:	e8 bd fb ff ff       	call   800cd2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801115:	83 c4 08             	add    $0x8,%esp
  801118:	57                   	push   %edi
  801119:	6a 00                	push   $0x0
  80111b:	e8 b2 fb ff ff       	call   800cd2 <sys_page_unmap>
	return r;
  801120:	83 c4 10             	add    $0x10,%esp
  801123:	eb b7                	jmp    8010dc <dup+0xa3>

00801125 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	53                   	push   %ebx
  801129:	83 ec 14             	sub    $0x14,%esp
  80112c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80112f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801132:	50                   	push   %eax
  801133:	53                   	push   %ebx
  801134:	e8 7b fd ff ff       	call   800eb4 <fd_lookup>
  801139:	83 c4 08             	add    $0x8,%esp
  80113c:	85 c0                	test   %eax,%eax
  80113e:	78 3f                	js     80117f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801146:	50                   	push   %eax
  801147:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114a:	ff 30                	pushl  (%eax)
  80114c:	e8 b9 fd ff ff       	call   800f0a <dev_lookup>
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	85 c0                	test   %eax,%eax
  801156:	78 27                	js     80117f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801158:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80115b:	8b 42 08             	mov    0x8(%edx),%eax
  80115e:	83 e0 03             	and    $0x3,%eax
  801161:	83 f8 01             	cmp    $0x1,%eax
  801164:	74 1e                	je     801184 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801169:	8b 40 08             	mov    0x8(%eax),%eax
  80116c:	85 c0                	test   %eax,%eax
  80116e:	74 35                	je     8011a5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801170:	83 ec 04             	sub    $0x4,%esp
  801173:	ff 75 10             	pushl  0x10(%ebp)
  801176:	ff 75 0c             	pushl  0xc(%ebp)
  801179:	52                   	push   %edx
  80117a:	ff d0                	call   *%eax
  80117c:	83 c4 10             	add    $0x10,%esp
}
  80117f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801182:	c9                   	leave  
  801183:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801184:	a1 20 60 80 00       	mov    0x806020,%eax
  801189:	8b 40 48             	mov    0x48(%eax),%eax
  80118c:	83 ec 04             	sub    $0x4,%esp
  80118f:	53                   	push   %ebx
  801190:	50                   	push   %eax
  801191:	68 f0 22 80 00       	push   $0x8022f0
  801196:	e8 cf f0 ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  80119b:	83 c4 10             	add    $0x10,%esp
  80119e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a3:	eb da                	jmp    80117f <read+0x5a>
		return -E_NOT_SUPP;
  8011a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011aa:	eb d3                	jmp    80117f <read+0x5a>

008011ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
  8011b2:	83 ec 0c             	sub    $0xc,%esp
  8011b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c0:	39 f3                	cmp    %esi,%ebx
  8011c2:	73 25                	jae    8011e9 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011c4:	83 ec 04             	sub    $0x4,%esp
  8011c7:	89 f0                	mov    %esi,%eax
  8011c9:	29 d8                	sub    %ebx,%eax
  8011cb:	50                   	push   %eax
  8011cc:	89 d8                	mov    %ebx,%eax
  8011ce:	03 45 0c             	add    0xc(%ebp),%eax
  8011d1:	50                   	push   %eax
  8011d2:	57                   	push   %edi
  8011d3:	e8 4d ff ff ff       	call   801125 <read>
		if (m < 0)
  8011d8:	83 c4 10             	add    $0x10,%esp
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	78 08                	js     8011e7 <readn+0x3b>
			return m;
		if (m == 0)
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	74 06                	je     8011e9 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8011e3:	01 c3                	add    %eax,%ebx
  8011e5:	eb d9                	jmp    8011c0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011e7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011e9:	89 d8                	mov    %ebx,%eax
  8011eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ee:	5b                   	pop    %ebx
  8011ef:	5e                   	pop    %esi
  8011f0:	5f                   	pop    %edi
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    

008011f3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	53                   	push   %ebx
  8011f7:	83 ec 14             	sub    $0x14,%esp
  8011fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801200:	50                   	push   %eax
  801201:	53                   	push   %ebx
  801202:	e8 ad fc ff ff       	call   800eb4 <fd_lookup>
  801207:	83 c4 08             	add    $0x8,%esp
  80120a:	85 c0                	test   %eax,%eax
  80120c:	78 3a                	js     801248 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801214:	50                   	push   %eax
  801215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801218:	ff 30                	pushl  (%eax)
  80121a:	e8 eb fc ff ff       	call   800f0a <dev_lookup>
  80121f:	83 c4 10             	add    $0x10,%esp
  801222:	85 c0                	test   %eax,%eax
  801224:	78 22                	js     801248 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801229:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80122d:	74 1e                	je     80124d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80122f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801232:	8b 52 0c             	mov    0xc(%edx),%edx
  801235:	85 d2                	test   %edx,%edx
  801237:	74 35                	je     80126e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801239:	83 ec 04             	sub    $0x4,%esp
  80123c:	ff 75 10             	pushl  0x10(%ebp)
  80123f:	ff 75 0c             	pushl  0xc(%ebp)
  801242:	50                   	push   %eax
  801243:	ff d2                	call   *%edx
  801245:	83 c4 10             	add    $0x10,%esp
}
  801248:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80124b:	c9                   	leave  
  80124c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80124d:	a1 20 60 80 00       	mov    0x806020,%eax
  801252:	8b 40 48             	mov    0x48(%eax),%eax
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	53                   	push   %ebx
  801259:	50                   	push   %eax
  80125a:	68 0c 23 80 00       	push   $0x80230c
  80125f:	e8 06 f0 ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126c:	eb da                	jmp    801248 <write+0x55>
		return -E_NOT_SUPP;
  80126e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801273:	eb d3                	jmp    801248 <write+0x55>

00801275 <seek>:

int
seek(int fdnum, off_t offset)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80127b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80127e:	50                   	push   %eax
  80127f:	ff 75 08             	pushl  0x8(%ebp)
  801282:	e8 2d fc ff ff       	call   800eb4 <fd_lookup>
  801287:	83 c4 08             	add    $0x8,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 0e                	js     80129c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80128e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801291:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801294:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801297:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129c:	c9                   	leave  
  80129d:	c3                   	ret    

0080129e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 14             	sub    $0x14,%esp
  8012a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ab:	50                   	push   %eax
  8012ac:	53                   	push   %ebx
  8012ad:	e8 02 fc ff ff       	call   800eb4 <fd_lookup>
  8012b2:	83 c4 08             	add    $0x8,%esp
  8012b5:	85 c0                	test   %eax,%eax
  8012b7:	78 37                	js     8012f0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b9:	83 ec 08             	sub    $0x8,%esp
  8012bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012bf:	50                   	push   %eax
  8012c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c3:	ff 30                	pushl  (%eax)
  8012c5:	e8 40 fc ff ff       	call   800f0a <dev_lookup>
  8012ca:	83 c4 10             	add    $0x10,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	78 1f                	js     8012f0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012d8:	74 1b                	je     8012f5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012dd:	8b 52 18             	mov    0x18(%edx),%edx
  8012e0:	85 d2                	test   %edx,%edx
  8012e2:	74 32                	je     801316 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ea:	50                   	push   %eax
  8012eb:	ff d2                	call   *%edx
  8012ed:	83 c4 10             	add    $0x10,%esp
}
  8012f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012f5:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012fa:	8b 40 48             	mov    0x48(%eax),%eax
  8012fd:	83 ec 04             	sub    $0x4,%esp
  801300:	53                   	push   %ebx
  801301:	50                   	push   %eax
  801302:	68 cc 22 80 00       	push   $0x8022cc
  801307:	e8 5e ef ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801314:	eb da                	jmp    8012f0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801316:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80131b:	eb d3                	jmp    8012f0 <ftruncate+0x52>

0080131d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	53                   	push   %ebx
  801321:	83 ec 14             	sub    $0x14,%esp
  801324:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801327:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132a:	50                   	push   %eax
  80132b:	ff 75 08             	pushl  0x8(%ebp)
  80132e:	e8 81 fb ff ff       	call   800eb4 <fd_lookup>
  801333:	83 c4 08             	add    $0x8,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	78 4b                	js     801385 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80133a:	83 ec 08             	sub    $0x8,%esp
  80133d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801340:	50                   	push   %eax
  801341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801344:	ff 30                	pushl  (%eax)
  801346:	e8 bf fb ff ff       	call   800f0a <dev_lookup>
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 33                	js     801385 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801355:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801359:	74 2f                	je     80138a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80135b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80135e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801365:	00 00 00 
	stat->st_isdir = 0;
  801368:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80136f:	00 00 00 
	stat->st_dev = dev;
  801372:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801378:	83 ec 08             	sub    $0x8,%esp
  80137b:	53                   	push   %ebx
  80137c:	ff 75 f0             	pushl  -0x10(%ebp)
  80137f:	ff 50 14             	call   *0x14(%eax)
  801382:	83 c4 10             	add    $0x10,%esp
}
  801385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801388:	c9                   	leave  
  801389:	c3                   	ret    
		return -E_NOT_SUPP;
  80138a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80138f:	eb f4                	jmp    801385 <fstat+0x68>

00801391 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	56                   	push   %esi
  801395:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801396:	83 ec 08             	sub    $0x8,%esp
  801399:	6a 00                	push   $0x0
  80139b:	ff 75 08             	pushl  0x8(%ebp)
  80139e:	e8 e7 01 00 00       	call   80158a <open>
  8013a3:	89 c3                	mov    %eax,%ebx
  8013a5:	83 c4 10             	add    $0x10,%esp
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	78 1b                	js     8013c7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013ac:	83 ec 08             	sub    $0x8,%esp
  8013af:	ff 75 0c             	pushl  0xc(%ebp)
  8013b2:	50                   	push   %eax
  8013b3:	e8 65 ff ff ff       	call   80131d <fstat>
  8013b8:	89 c6                	mov    %eax,%esi
	close(fd);
  8013ba:	89 1c 24             	mov    %ebx,(%esp)
  8013bd:	e8 27 fc ff ff       	call   800fe9 <close>
	return r;
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	89 f3                	mov    %esi,%ebx
}
  8013c7:	89 d8                	mov    %ebx,%eax
  8013c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013cc:	5b                   	pop    %ebx
  8013cd:	5e                   	pop    %esi
  8013ce:	5d                   	pop    %ebp
  8013cf:	c3                   	ret    

008013d0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	56                   	push   %esi
  8013d4:	53                   	push   %ebx
  8013d5:	89 c6                	mov    %eax,%esi
  8013d7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013d9:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013e0:	74 27                	je     801409 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013e2:	6a 07                	push   $0x7
  8013e4:	68 00 70 80 00       	push   $0x807000
  8013e9:	56                   	push   %esi
  8013ea:	ff 35 00 40 80 00    	pushl  0x804000
  8013f0:	e8 30 08 00 00       	call   801c25 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013f5:	83 c4 0c             	add    $0xc,%esp
  8013f8:	6a 00                	push   $0x0
  8013fa:	53                   	push   %ebx
  8013fb:	6a 00                	push   $0x0
  8013fd:	e8 0c 08 00 00       	call   801c0e <ipc_recv>
}
  801402:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801405:	5b                   	pop    %ebx
  801406:	5e                   	pop    %esi
  801407:	5d                   	pop    %ebp
  801408:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801409:	83 ec 0c             	sub    $0xc,%esp
  80140c:	6a 01                	push   $0x1
  80140e:	e8 29 08 00 00       	call   801c3c <ipc_find_env>
  801413:	a3 00 40 80 00       	mov    %eax,0x804000
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	eb c5                	jmp    8013e2 <fsipc+0x12>

0080141d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8b 40 0c             	mov    0xc(%eax),%eax
  801429:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801436:	ba 00 00 00 00       	mov    $0x0,%edx
  80143b:	b8 02 00 00 00       	mov    $0x2,%eax
  801440:	e8 8b ff ff ff       	call   8013d0 <fsipc>
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <devfile_flush>:
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	8b 40 0c             	mov    0xc(%eax),%eax
  801453:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801458:	ba 00 00 00 00       	mov    $0x0,%edx
  80145d:	b8 06 00 00 00       	mov    $0x6,%eax
  801462:	e8 69 ff ff ff       	call   8013d0 <fsipc>
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <devfile_stat>:
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	53                   	push   %ebx
  80146d:	83 ec 04             	sub    $0x4,%esp
  801470:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	8b 40 0c             	mov    0xc(%eax),%eax
  801479:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80147e:	ba 00 00 00 00       	mov    $0x0,%edx
  801483:	b8 05 00 00 00       	mov    $0x5,%eax
  801488:	e8 43 ff ff ff       	call   8013d0 <fsipc>
  80148d:	85 c0                	test   %eax,%eax
  80148f:	78 2c                	js     8014bd <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	68 00 70 80 00       	push   $0x807000
  801499:	53                   	push   %ebx
  80149a:	e8 b5 f3 ff ff       	call   800854 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80149f:	a1 80 70 80 00       	mov    0x807080,%eax
  8014a4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014aa:	a1 84 70 80 00       	mov    0x807084,%eax
  8014af:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <devfile_write>:
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	83 ec 0c             	sub    $0xc,%esp
  8014c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cb:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8014d0:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8014d5:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014db:	8b 52 0c             	mov    0xc(%edx),%edx
  8014de:	89 15 00 70 80 00    	mov    %edx,0x807000
        fsipcbuf.write.req_n = n;
  8014e4:	a3 04 70 80 00       	mov    %eax,0x807004
        memmove(fsipcbuf.write.req_buf, buf, n);
  8014e9:	50                   	push   %eax
  8014ea:	ff 75 0c             	pushl  0xc(%ebp)
  8014ed:	68 08 70 80 00       	push   $0x807008
  8014f2:	e8 eb f4 ff ff       	call   8009e2 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8014f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fc:	b8 04 00 00 00       	mov    $0x4,%eax
  801501:	e8 ca fe ff ff       	call   8013d0 <fsipc>
}
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <devfile_read>:
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	56                   	push   %esi
  80150c:	53                   	push   %ebx
  80150d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	8b 40 0c             	mov    0xc(%eax),%eax
  801516:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80151b:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801521:	ba 00 00 00 00       	mov    $0x0,%edx
  801526:	b8 03 00 00 00       	mov    $0x3,%eax
  80152b:	e8 a0 fe ff ff       	call   8013d0 <fsipc>
  801530:	89 c3                	mov    %eax,%ebx
  801532:	85 c0                	test   %eax,%eax
  801534:	78 1f                	js     801555 <devfile_read+0x4d>
	assert(r <= n);
  801536:	39 f0                	cmp    %esi,%eax
  801538:	77 24                	ja     80155e <devfile_read+0x56>
	assert(r <= PGSIZE);
  80153a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80153f:	7f 33                	jg     801574 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801541:	83 ec 04             	sub    $0x4,%esp
  801544:	50                   	push   %eax
  801545:	68 00 70 80 00       	push   $0x807000
  80154a:	ff 75 0c             	pushl  0xc(%ebp)
  80154d:	e8 90 f4 ff ff       	call   8009e2 <memmove>
	return r;
  801552:	83 c4 10             	add    $0x10,%esp
}
  801555:	89 d8                	mov    %ebx,%eax
  801557:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155a:	5b                   	pop    %ebx
  80155b:	5e                   	pop    %esi
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    
	assert(r <= n);
  80155e:	68 3c 23 80 00       	push   $0x80233c
  801563:	68 43 23 80 00       	push   $0x802343
  801568:	6a 7c                	push   $0x7c
  80156a:	68 58 23 80 00       	push   $0x802358
  80156f:	e8 1b ec ff ff       	call   80018f <_panic>
	assert(r <= PGSIZE);
  801574:	68 63 23 80 00       	push   $0x802363
  801579:	68 43 23 80 00       	push   $0x802343
  80157e:	6a 7d                	push   $0x7d
  801580:	68 58 23 80 00       	push   $0x802358
  801585:	e8 05 ec ff ff       	call   80018f <_panic>

0080158a <open>:
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	56                   	push   %esi
  80158e:	53                   	push   %ebx
  80158f:	83 ec 1c             	sub    $0x1c,%esp
  801592:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801595:	56                   	push   %esi
  801596:	e8 82 f2 ff ff       	call   80081d <strlen>
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015a3:	7f 6c                	jg     801611 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015a5:	83 ec 0c             	sub    $0xc,%esp
  8015a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ab:	50                   	push   %eax
  8015ac:	e8 b4 f8 ff ff       	call   800e65 <fd_alloc>
  8015b1:	89 c3                	mov    %eax,%ebx
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	78 3c                	js     8015f6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015ba:	83 ec 08             	sub    $0x8,%esp
  8015bd:	56                   	push   %esi
  8015be:	68 00 70 80 00       	push   $0x807000
  8015c3:	e8 8c f2 ff ff       	call   800854 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cb:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d8:	e8 f3 fd ff ff       	call   8013d0 <fsipc>
  8015dd:	89 c3                	mov    %eax,%ebx
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	85 c0                	test   %eax,%eax
  8015e4:	78 19                	js     8015ff <open+0x75>
	return fd2num(fd);
  8015e6:	83 ec 0c             	sub    $0xc,%esp
  8015e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ec:	e8 4d f8 ff ff       	call   800e3e <fd2num>
  8015f1:	89 c3                	mov    %eax,%ebx
  8015f3:	83 c4 10             	add    $0x10,%esp
}
  8015f6:	89 d8                	mov    %ebx,%eax
  8015f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015fb:	5b                   	pop    %ebx
  8015fc:	5e                   	pop    %esi
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    
		fd_close(fd, 0);
  8015ff:	83 ec 08             	sub    $0x8,%esp
  801602:	6a 00                	push   $0x0
  801604:	ff 75 f4             	pushl  -0xc(%ebp)
  801607:	e8 54 f9 ff ff       	call   800f60 <fd_close>
		return r;
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	eb e5                	jmp    8015f6 <open+0x6c>
		return -E_BAD_PATH;
  801611:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801616:	eb de                	jmp    8015f6 <open+0x6c>

00801618 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
  80161b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80161e:	ba 00 00 00 00       	mov    $0x0,%edx
  801623:	b8 08 00 00 00       	mov    $0x8,%eax
  801628:	e8 a3 fd ff ff       	call   8013d0 <fsipc>
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80162f:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801633:	7e 38                	jle    80166d <writebuf+0x3e>
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	53                   	push   %ebx
  801639:	83 ec 08             	sub    $0x8,%esp
  80163c:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80163e:	ff 70 04             	pushl  0x4(%eax)
  801641:	8d 40 10             	lea    0x10(%eax),%eax
  801644:	50                   	push   %eax
  801645:	ff 33                	pushl  (%ebx)
  801647:	e8 a7 fb ff ff       	call   8011f3 <write>
		if (result > 0)
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	85 c0                	test   %eax,%eax
  801651:	7e 03                	jle    801656 <writebuf+0x27>
			b->result += result;
  801653:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801656:	39 43 04             	cmp    %eax,0x4(%ebx)
  801659:	74 0d                	je     801668 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  80165b:	85 c0                	test   %eax,%eax
  80165d:	ba 00 00 00 00       	mov    $0x0,%edx
  801662:	0f 4f c2             	cmovg  %edx,%eax
  801665:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801668:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    
  80166d:	f3 c3                	repz ret 

0080166f <putch>:

static void
putch(int ch, void *thunk)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	53                   	push   %ebx
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801679:	8b 53 04             	mov    0x4(%ebx),%edx
  80167c:	8d 42 01             	lea    0x1(%edx),%eax
  80167f:	89 43 04             	mov    %eax,0x4(%ebx)
  801682:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801685:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801689:	3d 00 01 00 00       	cmp    $0x100,%eax
  80168e:	74 06                	je     801696 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801690:	83 c4 04             	add    $0x4,%esp
  801693:	5b                   	pop    %ebx
  801694:	5d                   	pop    %ebp
  801695:	c3                   	ret    
		writebuf(b);
  801696:	89 d8                	mov    %ebx,%eax
  801698:	e8 92 ff ff ff       	call   80162f <writebuf>
		b->idx = 0;
  80169d:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8016a4:	eb ea                	jmp    801690 <putch+0x21>

008016a6 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8016b8:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8016bf:	00 00 00 
	b.result = 0;
  8016c2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8016c9:	00 00 00 
	b.error = 1;
  8016cc:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8016d3:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8016d6:	ff 75 10             	pushl  0x10(%ebp)
  8016d9:	ff 75 0c             	pushl  0xc(%ebp)
  8016dc:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8016e2:	50                   	push   %eax
  8016e3:	68 6f 16 80 00       	push   $0x80166f
  8016e8:	e8 7a ec ff ff       	call   800367 <vprintfmt>
	if (b.idx > 0)
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8016f7:	7f 11                	jg     80170a <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8016f9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8016ff:	85 c0                	test   %eax,%eax
  801701:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    
		writebuf(&b);
  80170a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801710:	e8 1a ff ff ff       	call   80162f <writebuf>
  801715:	eb e2                	jmp    8016f9 <vfprintf+0x53>

00801717 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80171d:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801720:	50                   	push   %eax
  801721:	ff 75 0c             	pushl  0xc(%ebp)
  801724:	ff 75 08             	pushl  0x8(%ebp)
  801727:	e8 7a ff ff ff       	call   8016a6 <vfprintf>
	va_end(ap);

	return cnt;
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <printf>:

int
printf(const char *fmt, ...)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801734:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801737:	50                   	push   %eax
  801738:	ff 75 08             	pushl  0x8(%ebp)
  80173b:	6a 01                	push   $0x1
  80173d:	e8 64 ff ff ff       	call   8016a6 <vfprintf>
	va_end(ap);

	return cnt;
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	56                   	push   %esi
  801748:	53                   	push   %ebx
  801749:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	ff 75 08             	pushl  0x8(%ebp)
  801752:	e8 f7 f6 ff ff       	call   800e4e <fd2data>
  801757:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801759:	83 c4 08             	add    $0x8,%esp
  80175c:	68 6f 23 80 00       	push   $0x80236f
  801761:	53                   	push   %ebx
  801762:	e8 ed f0 ff ff       	call   800854 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801767:	8b 46 04             	mov    0x4(%esi),%eax
  80176a:	2b 06                	sub    (%esi),%eax
  80176c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801772:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801779:	00 00 00 
	stat->st_dev = &devpipe;
  80177c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801783:	30 80 00 
	return 0;
}
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
  80178b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178e:	5b                   	pop    %ebx
  80178f:	5e                   	pop    %esi
  801790:	5d                   	pop    %ebp
  801791:	c3                   	ret    

00801792 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	53                   	push   %ebx
  801796:	83 ec 0c             	sub    $0xc,%esp
  801799:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80179c:	53                   	push   %ebx
  80179d:	6a 00                	push   $0x0
  80179f:	e8 2e f5 ff ff       	call   800cd2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017a4:	89 1c 24             	mov    %ebx,(%esp)
  8017a7:	e8 a2 f6 ff ff       	call   800e4e <fd2data>
  8017ac:	83 c4 08             	add    $0x8,%esp
  8017af:	50                   	push   %eax
  8017b0:	6a 00                	push   $0x0
  8017b2:	e8 1b f5 ff ff       	call   800cd2 <sys_page_unmap>
}
  8017b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <_pipeisclosed>:
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	57                   	push   %edi
  8017c0:	56                   	push   %esi
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 1c             	sub    $0x1c,%esp
  8017c5:	89 c7                	mov    %eax,%edi
  8017c7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8017c9:	a1 20 60 80 00       	mov    0x806020,%eax
  8017ce:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8017d1:	83 ec 0c             	sub    $0xc,%esp
  8017d4:	57                   	push   %edi
  8017d5:	e8 9b 04 00 00       	call   801c75 <pageref>
  8017da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017dd:	89 34 24             	mov    %esi,(%esp)
  8017e0:	e8 90 04 00 00       	call   801c75 <pageref>
		nn = thisenv->env_runs;
  8017e5:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8017eb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	39 cb                	cmp    %ecx,%ebx
  8017f3:	74 1b                	je     801810 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8017f5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017f8:	75 cf                	jne    8017c9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8017fa:	8b 42 58             	mov    0x58(%edx),%eax
  8017fd:	6a 01                	push   $0x1
  8017ff:	50                   	push   %eax
  801800:	53                   	push   %ebx
  801801:	68 76 23 80 00       	push   $0x802376
  801806:	e8 5f ea ff ff       	call   80026a <cprintf>
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	eb b9                	jmp    8017c9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801810:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801813:	0f 94 c0             	sete   %al
  801816:	0f b6 c0             	movzbl %al,%eax
}
  801819:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80181c:	5b                   	pop    %ebx
  80181d:	5e                   	pop    %esi
  80181e:	5f                   	pop    %edi
  80181f:	5d                   	pop    %ebp
  801820:	c3                   	ret    

00801821 <devpipe_write>:
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	57                   	push   %edi
  801825:	56                   	push   %esi
  801826:	53                   	push   %ebx
  801827:	83 ec 28             	sub    $0x28,%esp
  80182a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80182d:	56                   	push   %esi
  80182e:	e8 1b f6 ff ff       	call   800e4e <fd2data>
  801833:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801835:	83 c4 10             	add    $0x10,%esp
  801838:	bf 00 00 00 00       	mov    $0x0,%edi
  80183d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801840:	74 4f                	je     801891 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801842:	8b 43 04             	mov    0x4(%ebx),%eax
  801845:	8b 0b                	mov    (%ebx),%ecx
  801847:	8d 51 20             	lea    0x20(%ecx),%edx
  80184a:	39 d0                	cmp    %edx,%eax
  80184c:	72 14                	jb     801862 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80184e:	89 da                	mov    %ebx,%edx
  801850:	89 f0                	mov    %esi,%eax
  801852:	e8 65 ff ff ff       	call   8017bc <_pipeisclosed>
  801857:	85 c0                	test   %eax,%eax
  801859:	75 3a                	jne    801895 <devpipe_write+0x74>
			sys_yield();
  80185b:	e8 ce f3 ff ff       	call   800c2e <sys_yield>
  801860:	eb e0                	jmp    801842 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801862:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801865:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801869:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80186c:	89 c2                	mov    %eax,%edx
  80186e:	c1 fa 1f             	sar    $0x1f,%edx
  801871:	89 d1                	mov    %edx,%ecx
  801873:	c1 e9 1b             	shr    $0x1b,%ecx
  801876:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801879:	83 e2 1f             	and    $0x1f,%edx
  80187c:	29 ca                	sub    %ecx,%edx
  80187e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801882:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801886:	83 c0 01             	add    $0x1,%eax
  801889:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80188c:	83 c7 01             	add    $0x1,%edi
  80188f:	eb ac                	jmp    80183d <devpipe_write+0x1c>
	return i;
  801891:	89 f8                	mov    %edi,%eax
  801893:	eb 05                	jmp    80189a <devpipe_write+0x79>
				return 0;
  801895:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80189d:	5b                   	pop    %ebx
  80189e:	5e                   	pop    %esi
  80189f:	5f                   	pop    %edi
  8018a0:	5d                   	pop    %ebp
  8018a1:	c3                   	ret    

008018a2 <devpipe_read>:
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	57                   	push   %edi
  8018a6:	56                   	push   %esi
  8018a7:	53                   	push   %ebx
  8018a8:	83 ec 18             	sub    $0x18,%esp
  8018ab:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8018ae:	57                   	push   %edi
  8018af:	e8 9a f5 ff ff       	call   800e4e <fd2data>
  8018b4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	be 00 00 00 00       	mov    $0x0,%esi
  8018be:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018c1:	74 47                	je     80190a <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8018c3:	8b 03                	mov    (%ebx),%eax
  8018c5:	3b 43 04             	cmp    0x4(%ebx),%eax
  8018c8:	75 22                	jne    8018ec <devpipe_read+0x4a>
			if (i > 0)
  8018ca:	85 f6                	test   %esi,%esi
  8018cc:	75 14                	jne    8018e2 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8018ce:	89 da                	mov    %ebx,%edx
  8018d0:	89 f8                	mov    %edi,%eax
  8018d2:	e8 e5 fe ff ff       	call   8017bc <_pipeisclosed>
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	75 33                	jne    80190e <devpipe_read+0x6c>
			sys_yield();
  8018db:	e8 4e f3 ff ff       	call   800c2e <sys_yield>
  8018e0:	eb e1                	jmp    8018c3 <devpipe_read+0x21>
				return i;
  8018e2:	89 f0                	mov    %esi,%eax
}
  8018e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018e7:	5b                   	pop    %ebx
  8018e8:	5e                   	pop    %esi
  8018e9:	5f                   	pop    %edi
  8018ea:	5d                   	pop    %ebp
  8018eb:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8018ec:	99                   	cltd   
  8018ed:	c1 ea 1b             	shr    $0x1b,%edx
  8018f0:	01 d0                	add    %edx,%eax
  8018f2:	83 e0 1f             	and    $0x1f,%eax
  8018f5:	29 d0                	sub    %edx,%eax
  8018f7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8018fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ff:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801902:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801905:	83 c6 01             	add    $0x1,%esi
  801908:	eb b4                	jmp    8018be <devpipe_read+0x1c>
	return i;
  80190a:	89 f0                	mov    %esi,%eax
  80190c:	eb d6                	jmp    8018e4 <devpipe_read+0x42>
				return 0;
  80190e:	b8 00 00 00 00       	mov    $0x0,%eax
  801913:	eb cf                	jmp    8018e4 <devpipe_read+0x42>

00801915 <pipe>:
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	56                   	push   %esi
  801919:	53                   	push   %ebx
  80191a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80191d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801920:	50                   	push   %eax
  801921:	e8 3f f5 ff ff       	call   800e65 <fd_alloc>
  801926:	89 c3                	mov    %eax,%ebx
  801928:	83 c4 10             	add    $0x10,%esp
  80192b:	85 c0                	test   %eax,%eax
  80192d:	78 5b                	js     80198a <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80192f:	83 ec 04             	sub    $0x4,%esp
  801932:	68 07 04 00 00       	push   $0x407
  801937:	ff 75 f4             	pushl  -0xc(%ebp)
  80193a:	6a 00                	push   $0x0
  80193c:	e8 0c f3 ff ff       	call   800c4d <sys_page_alloc>
  801941:	89 c3                	mov    %eax,%ebx
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	85 c0                	test   %eax,%eax
  801948:	78 40                	js     80198a <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80194a:	83 ec 0c             	sub    $0xc,%esp
  80194d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801950:	50                   	push   %eax
  801951:	e8 0f f5 ff ff       	call   800e65 <fd_alloc>
  801956:	89 c3                	mov    %eax,%ebx
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	85 c0                	test   %eax,%eax
  80195d:	78 1b                	js     80197a <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80195f:	83 ec 04             	sub    $0x4,%esp
  801962:	68 07 04 00 00       	push   $0x407
  801967:	ff 75 f0             	pushl  -0x10(%ebp)
  80196a:	6a 00                	push   $0x0
  80196c:	e8 dc f2 ff ff       	call   800c4d <sys_page_alloc>
  801971:	89 c3                	mov    %eax,%ebx
  801973:	83 c4 10             	add    $0x10,%esp
  801976:	85 c0                	test   %eax,%eax
  801978:	79 19                	jns    801993 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80197a:	83 ec 08             	sub    $0x8,%esp
  80197d:	ff 75 f4             	pushl  -0xc(%ebp)
  801980:	6a 00                	push   $0x0
  801982:	e8 4b f3 ff ff       	call   800cd2 <sys_page_unmap>
  801987:	83 c4 10             	add    $0x10,%esp
}
  80198a:	89 d8                	mov    %ebx,%eax
  80198c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198f:	5b                   	pop    %ebx
  801990:	5e                   	pop    %esi
  801991:	5d                   	pop    %ebp
  801992:	c3                   	ret    
	va = fd2data(fd0);
  801993:	83 ec 0c             	sub    $0xc,%esp
  801996:	ff 75 f4             	pushl  -0xc(%ebp)
  801999:	e8 b0 f4 ff ff       	call   800e4e <fd2data>
  80199e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019a0:	83 c4 0c             	add    $0xc,%esp
  8019a3:	68 07 04 00 00       	push   $0x407
  8019a8:	50                   	push   %eax
  8019a9:	6a 00                	push   $0x0
  8019ab:	e8 9d f2 ff ff       	call   800c4d <sys_page_alloc>
  8019b0:	89 c3                	mov    %eax,%ebx
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	0f 88 8c 00 00 00    	js     801a49 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019bd:	83 ec 0c             	sub    $0xc,%esp
  8019c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8019c3:	e8 86 f4 ff ff       	call   800e4e <fd2data>
  8019c8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8019cf:	50                   	push   %eax
  8019d0:	6a 00                	push   $0x0
  8019d2:	56                   	push   %esi
  8019d3:	6a 00                	push   $0x0
  8019d5:	e8 b6 f2 ff ff       	call   800c90 <sys_page_map>
  8019da:	89 c3                	mov    %eax,%ebx
  8019dc:	83 c4 20             	add    $0x20,%esp
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	78 58                	js     801a3b <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8019e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e6:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019ec:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8019f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fb:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a01:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a06:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a0d:	83 ec 0c             	sub    $0xc,%esp
  801a10:	ff 75 f4             	pushl  -0xc(%ebp)
  801a13:	e8 26 f4 ff ff       	call   800e3e <fd2num>
  801a18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a1b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a1d:	83 c4 04             	add    $0x4,%esp
  801a20:	ff 75 f0             	pushl  -0x10(%ebp)
  801a23:	e8 16 f4 ff ff       	call   800e3e <fd2num>
  801a28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a2b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a2e:	83 c4 10             	add    $0x10,%esp
  801a31:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a36:	e9 4f ff ff ff       	jmp    80198a <pipe+0x75>
	sys_page_unmap(0, va);
  801a3b:	83 ec 08             	sub    $0x8,%esp
  801a3e:	56                   	push   %esi
  801a3f:	6a 00                	push   $0x0
  801a41:	e8 8c f2 ff ff       	call   800cd2 <sys_page_unmap>
  801a46:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a49:	83 ec 08             	sub    $0x8,%esp
  801a4c:	ff 75 f0             	pushl  -0x10(%ebp)
  801a4f:	6a 00                	push   $0x0
  801a51:	e8 7c f2 ff ff       	call   800cd2 <sys_page_unmap>
  801a56:	83 c4 10             	add    $0x10,%esp
  801a59:	e9 1c ff ff ff       	jmp    80197a <pipe+0x65>

00801a5e <pipeisclosed>:
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a67:	50                   	push   %eax
  801a68:	ff 75 08             	pushl  0x8(%ebp)
  801a6b:	e8 44 f4 ff ff       	call   800eb4 <fd_lookup>
  801a70:	83 c4 10             	add    $0x10,%esp
  801a73:	85 c0                	test   %eax,%eax
  801a75:	78 18                	js     801a8f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801a77:	83 ec 0c             	sub    $0xc,%esp
  801a7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a7d:	e8 cc f3 ff ff       	call   800e4e <fd2data>
	return _pipeisclosed(fd, p);
  801a82:	89 c2                	mov    %eax,%edx
  801a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a87:	e8 30 fd ff ff       	call   8017bc <_pipeisclosed>
  801a8c:	83 c4 10             	add    $0x10,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801a94:	b8 00 00 00 00       	mov    $0x0,%eax
  801a99:	5d                   	pop    %ebp
  801a9a:	c3                   	ret    

00801a9b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801aa1:	68 8e 23 80 00       	push   $0x80238e
  801aa6:	ff 75 0c             	pushl  0xc(%ebp)
  801aa9:	e8 a6 ed ff ff       	call   800854 <strcpy>
	return 0;
}
  801aae:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <devcons_write>:
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	57                   	push   %edi
  801ab9:	56                   	push   %esi
  801aba:	53                   	push   %ebx
  801abb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ac1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ac6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801acc:	eb 2f                	jmp    801afd <devcons_write+0x48>
		m = n - tot;
  801ace:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ad1:	29 f3                	sub    %esi,%ebx
  801ad3:	83 fb 7f             	cmp    $0x7f,%ebx
  801ad6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801adb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	53                   	push   %ebx
  801ae2:	89 f0                	mov    %esi,%eax
  801ae4:	03 45 0c             	add    0xc(%ebp),%eax
  801ae7:	50                   	push   %eax
  801ae8:	57                   	push   %edi
  801ae9:	e8 f4 ee ff ff       	call   8009e2 <memmove>
		sys_cputs(buf, m);
  801aee:	83 c4 08             	add    $0x8,%esp
  801af1:	53                   	push   %ebx
  801af2:	57                   	push   %edi
  801af3:	e8 99 f0 ff ff       	call   800b91 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801af8:	01 de                	add    %ebx,%esi
  801afa:	83 c4 10             	add    $0x10,%esp
  801afd:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b00:	72 cc                	jb     801ace <devcons_write+0x19>
}
  801b02:	89 f0                	mov    %esi,%eax
  801b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b07:	5b                   	pop    %ebx
  801b08:	5e                   	pop    %esi
  801b09:	5f                   	pop    %edi
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    

00801b0c <devcons_read>:
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	83 ec 08             	sub    $0x8,%esp
  801b12:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801b17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b1b:	75 07                	jne    801b24 <devcons_read+0x18>
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    
		sys_yield();
  801b1f:	e8 0a f1 ff ff       	call   800c2e <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801b24:	e8 86 f0 ff ff       	call   800baf <sys_cgetc>
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	74 f2                	je     801b1f <devcons_read+0x13>
	if (c < 0)
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	78 ec                	js     801b1d <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801b31:	83 f8 04             	cmp    $0x4,%eax
  801b34:	74 0c                	je     801b42 <devcons_read+0x36>
	*(char*)vbuf = c;
  801b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b39:	88 02                	mov    %al,(%edx)
	return 1;
  801b3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b40:	eb db                	jmp    801b1d <devcons_read+0x11>
		return 0;
  801b42:	b8 00 00 00 00       	mov    $0x0,%eax
  801b47:	eb d4                	jmp    801b1d <devcons_read+0x11>

00801b49 <cputchar>:
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801b55:	6a 01                	push   $0x1
  801b57:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b5a:	50                   	push   %eax
  801b5b:	e8 31 f0 ff ff       	call   800b91 <sys_cputs>
}
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <getchar>:
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801b6b:	6a 01                	push   $0x1
  801b6d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b70:	50                   	push   %eax
  801b71:	6a 00                	push   $0x0
  801b73:	e8 ad f5 ff ff       	call   801125 <read>
	if (r < 0)
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	78 08                	js     801b87 <getchar+0x22>
	if (r < 1)
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	7e 06                	jle    801b89 <getchar+0x24>
	return c;
  801b83:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    
		return -E_EOF;
  801b89:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801b8e:	eb f7                	jmp    801b87 <getchar+0x22>

00801b90 <iscons>:
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b99:	50                   	push   %eax
  801b9a:	ff 75 08             	pushl  0x8(%ebp)
  801b9d:	e8 12 f3 ff ff       	call   800eb4 <fd_lookup>
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	78 11                	js     801bba <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bac:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bb2:	39 10                	cmp    %edx,(%eax)
  801bb4:	0f 94 c0             	sete   %al
  801bb7:	0f b6 c0             	movzbl %al,%eax
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <opencons>:
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801bc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc5:	50                   	push   %eax
  801bc6:	e8 9a f2 ff ff       	call   800e65 <fd_alloc>
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	78 3a                	js     801c0c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801bd2:	83 ec 04             	sub    $0x4,%esp
  801bd5:	68 07 04 00 00       	push   $0x407
  801bda:	ff 75 f4             	pushl  -0xc(%ebp)
  801bdd:	6a 00                	push   $0x0
  801bdf:	e8 69 f0 ff ff       	call   800c4d <sys_page_alloc>
  801be4:	83 c4 10             	add    $0x10,%esp
  801be7:	85 c0                	test   %eax,%eax
  801be9:	78 21                	js     801c0c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bee:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bf4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c00:	83 ec 0c             	sub    $0xc,%esp
  801c03:	50                   	push   %eax
  801c04:	e8 35 f2 ff ff       	call   800e3e <fd2num>
  801c09:	83 c4 10             	add    $0x10,%esp
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801c14:	68 9a 23 80 00       	push   $0x80239a
  801c19:	6a 1a                	push   $0x1a
  801c1b:	68 b3 23 80 00       	push   $0x8023b3
  801c20:	e8 6a e5 ff ff       	call   80018f <_panic>

00801c25 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801c2b:	68 bd 23 80 00       	push   $0x8023bd
  801c30:	6a 2a                	push   $0x2a
  801c32:	68 b3 23 80 00       	push   $0x8023b3
  801c37:	e8 53 e5 ff ff       	call   80018f <_panic>

00801c3c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c42:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c47:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c4a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c50:	8b 52 50             	mov    0x50(%edx),%edx
  801c53:	39 ca                	cmp    %ecx,%edx
  801c55:	74 11                	je     801c68 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801c57:	83 c0 01             	add    $0x1,%eax
  801c5a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c5f:	75 e6                	jne    801c47 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c61:	b8 00 00 00 00       	mov    $0x0,%eax
  801c66:	eb 0b                	jmp    801c73 <ipc_find_env+0x37>
			return envs[i].env_id;
  801c68:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c6b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c70:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c73:	5d                   	pop    %ebp
  801c74:	c3                   	ret    

00801c75 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c7b:	89 d0                	mov    %edx,%eax
  801c7d:	c1 e8 16             	shr    $0x16,%eax
  801c80:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801c87:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801c8c:	f6 c1 01             	test   $0x1,%cl
  801c8f:	74 1d                	je     801cae <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801c91:	c1 ea 0c             	shr    $0xc,%edx
  801c94:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801c9b:	f6 c2 01             	test   $0x1,%dl
  801c9e:	74 0e                	je     801cae <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ca0:	c1 ea 0c             	shr    $0xc,%edx
  801ca3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801caa:	ef 
  801cab:	0f b7 c0             	movzwl %ax,%eax
}
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    

00801cb0 <__udivdi3>:
  801cb0:	55                   	push   %ebp
  801cb1:	57                   	push   %edi
  801cb2:	56                   	push   %esi
  801cb3:	53                   	push   %ebx
  801cb4:	83 ec 1c             	sub    $0x1c,%esp
  801cb7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801cbb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801cbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cc3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801cc7:	85 d2                	test   %edx,%edx
  801cc9:	75 35                	jne    801d00 <__udivdi3+0x50>
  801ccb:	39 f3                	cmp    %esi,%ebx
  801ccd:	0f 87 bd 00 00 00    	ja     801d90 <__udivdi3+0xe0>
  801cd3:	85 db                	test   %ebx,%ebx
  801cd5:	89 d9                	mov    %ebx,%ecx
  801cd7:	75 0b                	jne    801ce4 <__udivdi3+0x34>
  801cd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cde:	31 d2                	xor    %edx,%edx
  801ce0:	f7 f3                	div    %ebx
  801ce2:	89 c1                	mov    %eax,%ecx
  801ce4:	31 d2                	xor    %edx,%edx
  801ce6:	89 f0                	mov    %esi,%eax
  801ce8:	f7 f1                	div    %ecx
  801cea:	89 c6                	mov    %eax,%esi
  801cec:	89 e8                	mov    %ebp,%eax
  801cee:	89 f7                	mov    %esi,%edi
  801cf0:	f7 f1                	div    %ecx
  801cf2:	89 fa                	mov    %edi,%edx
  801cf4:	83 c4 1c             	add    $0x1c,%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5f                   	pop    %edi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    
  801cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d00:	39 f2                	cmp    %esi,%edx
  801d02:	77 7c                	ja     801d80 <__udivdi3+0xd0>
  801d04:	0f bd fa             	bsr    %edx,%edi
  801d07:	83 f7 1f             	xor    $0x1f,%edi
  801d0a:	0f 84 98 00 00 00    	je     801da8 <__udivdi3+0xf8>
  801d10:	89 f9                	mov    %edi,%ecx
  801d12:	b8 20 00 00 00       	mov    $0x20,%eax
  801d17:	29 f8                	sub    %edi,%eax
  801d19:	d3 e2                	shl    %cl,%edx
  801d1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d1f:	89 c1                	mov    %eax,%ecx
  801d21:	89 da                	mov    %ebx,%edx
  801d23:	d3 ea                	shr    %cl,%edx
  801d25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d29:	09 d1                	or     %edx,%ecx
  801d2b:	89 f2                	mov    %esi,%edx
  801d2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d31:	89 f9                	mov    %edi,%ecx
  801d33:	d3 e3                	shl    %cl,%ebx
  801d35:	89 c1                	mov    %eax,%ecx
  801d37:	d3 ea                	shr    %cl,%edx
  801d39:	89 f9                	mov    %edi,%ecx
  801d3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d3f:	d3 e6                	shl    %cl,%esi
  801d41:	89 eb                	mov    %ebp,%ebx
  801d43:	89 c1                	mov    %eax,%ecx
  801d45:	d3 eb                	shr    %cl,%ebx
  801d47:	09 de                	or     %ebx,%esi
  801d49:	89 f0                	mov    %esi,%eax
  801d4b:	f7 74 24 08          	divl   0x8(%esp)
  801d4f:	89 d6                	mov    %edx,%esi
  801d51:	89 c3                	mov    %eax,%ebx
  801d53:	f7 64 24 0c          	mull   0xc(%esp)
  801d57:	39 d6                	cmp    %edx,%esi
  801d59:	72 0c                	jb     801d67 <__udivdi3+0xb7>
  801d5b:	89 f9                	mov    %edi,%ecx
  801d5d:	d3 e5                	shl    %cl,%ebp
  801d5f:	39 c5                	cmp    %eax,%ebp
  801d61:	73 5d                	jae    801dc0 <__udivdi3+0x110>
  801d63:	39 d6                	cmp    %edx,%esi
  801d65:	75 59                	jne    801dc0 <__udivdi3+0x110>
  801d67:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d6a:	31 ff                	xor    %edi,%edi
  801d6c:	89 fa                	mov    %edi,%edx
  801d6e:	83 c4 1c             	add    $0x1c,%esp
  801d71:	5b                   	pop    %ebx
  801d72:	5e                   	pop    %esi
  801d73:	5f                   	pop    %edi
  801d74:	5d                   	pop    %ebp
  801d75:	c3                   	ret    
  801d76:	8d 76 00             	lea    0x0(%esi),%esi
  801d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801d80:	31 ff                	xor    %edi,%edi
  801d82:	31 c0                	xor    %eax,%eax
  801d84:	89 fa                	mov    %edi,%edx
  801d86:	83 c4 1c             	add    $0x1c,%esp
  801d89:	5b                   	pop    %ebx
  801d8a:	5e                   	pop    %esi
  801d8b:	5f                   	pop    %edi
  801d8c:	5d                   	pop    %ebp
  801d8d:	c3                   	ret    
  801d8e:	66 90                	xchg   %ax,%ax
  801d90:	31 ff                	xor    %edi,%edi
  801d92:	89 e8                	mov    %ebp,%eax
  801d94:	89 f2                	mov    %esi,%edx
  801d96:	f7 f3                	div    %ebx
  801d98:	89 fa                	mov    %edi,%edx
  801d9a:	83 c4 1c             	add    $0x1c,%esp
  801d9d:	5b                   	pop    %ebx
  801d9e:	5e                   	pop    %esi
  801d9f:	5f                   	pop    %edi
  801da0:	5d                   	pop    %ebp
  801da1:	c3                   	ret    
  801da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801da8:	39 f2                	cmp    %esi,%edx
  801daa:	72 06                	jb     801db2 <__udivdi3+0x102>
  801dac:	31 c0                	xor    %eax,%eax
  801dae:	39 eb                	cmp    %ebp,%ebx
  801db0:	77 d2                	ja     801d84 <__udivdi3+0xd4>
  801db2:	b8 01 00 00 00       	mov    $0x1,%eax
  801db7:	eb cb                	jmp    801d84 <__udivdi3+0xd4>
  801db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801dc0:	89 d8                	mov    %ebx,%eax
  801dc2:	31 ff                	xor    %edi,%edi
  801dc4:	eb be                	jmp    801d84 <__udivdi3+0xd4>
  801dc6:	66 90                	xchg   %ax,%ax
  801dc8:	66 90                	xchg   %ax,%ax
  801dca:	66 90                	xchg   %ax,%ax
  801dcc:	66 90                	xchg   %ax,%ax
  801dce:	66 90                	xchg   %ax,%ax

00801dd0 <__umoddi3>:
  801dd0:	55                   	push   %ebp
  801dd1:	57                   	push   %edi
  801dd2:	56                   	push   %esi
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 1c             	sub    $0x1c,%esp
  801dd7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801ddb:	8b 74 24 30          	mov    0x30(%esp),%esi
  801ddf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801de3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801de7:	85 ed                	test   %ebp,%ebp
  801de9:	89 f0                	mov    %esi,%eax
  801deb:	89 da                	mov    %ebx,%edx
  801ded:	75 19                	jne    801e08 <__umoddi3+0x38>
  801def:	39 df                	cmp    %ebx,%edi
  801df1:	0f 86 b1 00 00 00    	jbe    801ea8 <__umoddi3+0xd8>
  801df7:	f7 f7                	div    %edi
  801df9:	89 d0                	mov    %edx,%eax
  801dfb:	31 d2                	xor    %edx,%edx
  801dfd:	83 c4 1c             	add    $0x1c,%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5f                   	pop    %edi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    
  801e05:	8d 76 00             	lea    0x0(%esi),%esi
  801e08:	39 dd                	cmp    %ebx,%ebp
  801e0a:	77 f1                	ja     801dfd <__umoddi3+0x2d>
  801e0c:	0f bd cd             	bsr    %ebp,%ecx
  801e0f:	83 f1 1f             	xor    $0x1f,%ecx
  801e12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e16:	0f 84 b4 00 00 00    	je     801ed0 <__umoddi3+0x100>
  801e1c:	b8 20 00 00 00       	mov    $0x20,%eax
  801e21:	89 c2                	mov    %eax,%edx
  801e23:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e27:	29 c2                	sub    %eax,%edx
  801e29:	89 c1                	mov    %eax,%ecx
  801e2b:	89 f8                	mov    %edi,%eax
  801e2d:	d3 e5                	shl    %cl,%ebp
  801e2f:	89 d1                	mov    %edx,%ecx
  801e31:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e35:	d3 e8                	shr    %cl,%eax
  801e37:	09 c5                	or     %eax,%ebp
  801e39:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e3d:	89 c1                	mov    %eax,%ecx
  801e3f:	d3 e7                	shl    %cl,%edi
  801e41:	89 d1                	mov    %edx,%ecx
  801e43:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801e47:	89 df                	mov    %ebx,%edi
  801e49:	d3 ef                	shr    %cl,%edi
  801e4b:	89 c1                	mov    %eax,%ecx
  801e4d:	89 f0                	mov    %esi,%eax
  801e4f:	d3 e3                	shl    %cl,%ebx
  801e51:	89 d1                	mov    %edx,%ecx
  801e53:	89 fa                	mov    %edi,%edx
  801e55:	d3 e8                	shr    %cl,%eax
  801e57:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801e5c:	09 d8                	or     %ebx,%eax
  801e5e:	f7 f5                	div    %ebp
  801e60:	d3 e6                	shl    %cl,%esi
  801e62:	89 d1                	mov    %edx,%ecx
  801e64:	f7 64 24 08          	mull   0x8(%esp)
  801e68:	39 d1                	cmp    %edx,%ecx
  801e6a:	89 c3                	mov    %eax,%ebx
  801e6c:	89 d7                	mov    %edx,%edi
  801e6e:	72 06                	jb     801e76 <__umoddi3+0xa6>
  801e70:	75 0e                	jne    801e80 <__umoddi3+0xb0>
  801e72:	39 c6                	cmp    %eax,%esi
  801e74:	73 0a                	jae    801e80 <__umoddi3+0xb0>
  801e76:	2b 44 24 08          	sub    0x8(%esp),%eax
  801e7a:	19 ea                	sbb    %ebp,%edx
  801e7c:	89 d7                	mov    %edx,%edi
  801e7e:	89 c3                	mov    %eax,%ebx
  801e80:	89 ca                	mov    %ecx,%edx
  801e82:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801e87:	29 de                	sub    %ebx,%esi
  801e89:	19 fa                	sbb    %edi,%edx
  801e8b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801e8f:	89 d0                	mov    %edx,%eax
  801e91:	d3 e0                	shl    %cl,%eax
  801e93:	89 d9                	mov    %ebx,%ecx
  801e95:	d3 ee                	shr    %cl,%esi
  801e97:	d3 ea                	shr    %cl,%edx
  801e99:	09 f0                	or     %esi,%eax
  801e9b:	83 c4 1c             	add    $0x1c,%esp
  801e9e:	5b                   	pop    %ebx
  801e9f:	5e                   	pop    %esi
  801ea0:	5f                   	pop    %edi
  801ea1:	5d                   	pop    %ebp
  801ea2:	c3                   	ret    
  801ea3:	90                   	nop
  801ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ea8:	85 ff                	test   %edi,%edi
  801eaa:	89 f9                	mov    %edi,%ecx
  801eac:	75 0b                	jne    801eb9 <__umoddi3+0xe9>
  801eae:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb3:	31 d2                	xor    %edx,%edx
  801eb5:	f7 f7                	div    %edi
  801eb7:	89 c1                	mov    %eax,%ecx
  801eb9:	89 d8                	mov    %ebx,%eax
  801ebb:	31 d2                	xor    %edx,%edx
  801ebd:	f7 f1                	div    %ecx
  801ebf:	89 f0                	mov    %esi,%eax
  801ec1:	f7 f1                	div    %ecx
  801ec3:	e9 31 ff ff ff       	jmp    801df9 <__umoddi3+0x29>
  801ec8:	90                   	nop
  801ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ed0:	39 dd                	cmp    %ebx,%ebp
  801ed2:	72 08                	jb     801edc <__umoddi3+0x10c>
  801ed4:	39 f7                	cmp    %esi,%edi
  801ed6:	0f 87 21 ff ff ff    	ja     801dfd <__umoddi3+0x2d>
  801edc:	89 da                	mov    %ebx,%edx
  801ede:	89 f0                	mov    %esi,%eax
  801ee0:	29 f8                	sub    %edi,%eax
  801ee2:	19 ea                	sbb    %ebp,%edx
  801ee4:	e9 14 ff ff ff       	jmp    801dfd <__umoddi3+0x2d>
