
obj/user/num.debug：     文件格式 elf32-i386


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
  80002c:	e8 52 01 00 00       	call   800183 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 1b                	jmp    80005e <num+0x2b>
		if (bol) {
			printf("%5d ", ++line);
			bol = 0;
		}
		if ((r = write(1, &c, 1)) != 1)
  800043:	83 ec 04             	sub    $0x4,%esp
  800046:	6a 01                	push   $0x1
  800048:	53                   	push   %ebx
  800049:	6a 01                	push   $0x1
  80004b:	e8 f7 11 00 00       	call   801247 <write>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	83 f8 01             	cmp    $0x1,%eax
  800056:	75 4c                	jne    8000a4 <num+0x71>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800058:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  80005c:	74 5e                	je     8000bc <num+0x89>
	while ((n = read(f, &c, 1)) > 0) {
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	6a 01                	push   $0x1
  800063:	53                   	push   %ebx
  800064:	56                   	push   %esi
  800065:	e8 0f 11 00 00       	call   801179 <read>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	85 c0                	test   %eax,%eax
  80006f:	7e 57                	jle    8000c8 <num+0x95>
		if (bol) {
  800071:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  800078:	74 c9                	je     800043 <num+0x10>
			printf("%5d ", ++line);
  80007a:	a1 00 40 80 00       	mov    0x804000,%eax
  80007f:	83 c0 01             	add    $0x1,%eax
  800082:	a3 00 40 80 00       	mov    %eax,0x804000
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	50                   	push   %eax
  80008b:	68 60 1f 80 00       	push   $0x801f60
  800090:	e8 ed 16 00 00       	call   801782 <printf>
			bol = 0;
  800095:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  80009c:	00 00 00 
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	eb 9f                	jmp    800043 <num+0x10>
			panic("write error copying %s: %e", s, r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	50                   	push   %eax
  8000a8:	ff 75 0c             	pushl  0xc(%ebp)
  8000ab:	68 65 1f 80 00       	push   $0x801f65
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 80 1f 80 00       	push   $0x801f80
  8000b7:	e8 27 01 00 00       	call   8001e3 <_panic>
			bol = 1;
  8000bc:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c3:	00 00 00 
  8000c6:	eb 96                	jmp    80005e <num+0x2b>
	}
	if (n < 0)
  8000c8:	85 c0                	test   %eax,%eax
  8000ca:	78 07                	js     8000d3 <num+0xa0>
		panic("error reading %s: %e", s, n);
}
  8000cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	50                   	push   %eax
  8000d7:	ff 75 0c             	pushl  0xc(%ebp)
  8000da:	68 8b 1f 80 00       	push   $0x801f8b
  8000df:	6a 18                	push   $0x18
  8000e1:	68 80 1f 80 00       	push   $0x801f80
  8000e6:	e8 f8 00 00 00       	call   8001e3 <_panic>

008000eb <umain>:

void
umain(int argc, char **argv)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f4:	c7 05 04 30 80 00 a0 	movl   $0x801fa0,0x803004
  8000fb:	1f 80 00 
	if (argc == 1)
  8000fe:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800102:	74 46                	je     80014a <umain+0x5f>
  800104:	8b 45 0c             	mov    0xc(%ebp),%eax
  800107:	8d 58 04             	lea    0x4(%eax),%ebx
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80010a:	bf 01 00 00 00       	mov    $0x1,%edi
  80010f:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800112:	7d 48                	jge    80015c <umain+0x71>
			f = open(argv[i], O_RDONLY);
  800114:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	6a 00                	push   $0x0
  80011c:	ff 33                	pushl  (%ebx)
  80011e:	e8 bb 14 00 00       	call   8015de <open>
  800123:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	85 c0                	test   %eax,%eax
  80012a:	78 3d                	js     800169 <umain+0x7e>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  80012c:	83 ec 08             	sub    $0x8,%esp
  80012f:	ff 33                	pushl  (%ebx)
  800131:	50                   	push   %eax
  800132:	e8 fc fe ff ff       	call   800033 <num>
				close(f);
  800137:	89 34 24             	mov    %esi,(%esp)
  80013a:	e8 fe 0e 00 00       	call   80103d <close>
		for (i = 1; i < argc; i++) {
  80013f:	83 c7 01             	add    $0x1,%edi
  800142:	83 c3 04             	add    $0x4,%ebx
  800145:	83 c4 10             	add    $0x10,%esp
  800148:	eb c5                	jmp    80010f <umain+0x24>
		num(0, "<stdin>");
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	68 a4 1f 80 00       	push   $0x801fa4
  800152:	6a 00                	push   $0x0
  800154:	e8 da fe ff ff       	call   800033 <num>
  800159:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  80015c:	e8 68 00 00 00       	call   8001c9 <exit>
}
  800161:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5f                   	pop    %edi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	50                   	push   %eax
  80016d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800170:	ff 30                	pushl  (%eax)
  800172:	68 ac 1f 80 00       	push   $0x801fac
  800177:	6a 27                	push   $0x27
  800179:	68 80 1f 80 00       	push   $0x801f80
  80017e:	e8 60 00 00 00       	call   8001e3 <_panic>

00800183 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	56                   	push   %esi
  800187:	53                   	push   %ebx
  800188:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80018b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80018e:	e8 d0 0a 00 00       	call   800c63 <sys_getenvid>
  800193:	25 ff 03 00 00       	and    $0x3ff,%eax
  800198:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80019b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a0:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a5:	85 db                	test   %ebx,%ebx
  8001a7:	7e 07                	jle    8001b0 <libmain+0x2d>
		binaryname = argv[0];
  8001a9:	8b 06                	mov    (%esi),%eax
  8001ab:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	56                   	push   %esi
  8001b4:	53                   	push   %ebx
  8001b5:	e8 31 ff ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8001ba:	e8 0a 00 00 00       	call   8001c9 <exit>
}
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c5:	5b                   	pop    %ebx
  8001c6:	5e                   	pop    %esi
  8001c7:	5d                   	pop    %ebp
  8001c8:	c3                   	ret    

008001c9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001cf:	e8 94 0e 00 00       	call   801068 <close_all>
	sys_env_destroy(0);
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	6a 00                	push   $0x0
  8001d9:	e8 44 0a 00 00       	call   800c22 <sys_env_destroy>
}
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	c9                   	leave  
  8001e2:	c3                   	ret    

008001e3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	56                   	push   %esi
  8001e7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001e8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001eb:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8001f1:	e8 6d 0a 00 00       	call   800c63 <sys_getenvid>
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	ff 75 0c             	pushl  0xc(%ebp)
  8001fc:	ff 75 08             	pushl  0x8(%ebp)
  8001ff:	56                   	push   %esi
  800200:	50                   	push   %eax
  800201:	68 c8 1f 80 00       	push   $0x801fc8
  800206:	e8 b3 00 00 00       	call   8002be <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80020b:	83 c4 18             	add    $0x18,%esp
  80020e:	53                   	push   %ebx
  80020f:	ff 75 10             	pushl  0x10(%ebp)
  800212:	e8 56 00 00 00       	call   80026d <vcprintf>
	cprintf("\n");
  800217:	c7 04 24 e7 23 80 00 	movl   $0x8023e7,(%esp)
  80021e:	e8 9b 00 00 00       	call   8002be <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800226:	cc                   	int3   
  800227:	eb fd                	jmp    800226 <_panic+0x43>

00800229 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	53                   	push   %ebx
  80022d:	83 ec 04             	sub    $0x4,%esp
  800230:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800233:	8b 13                	mov    (%ebx),%edx
  800235:	8d 42 01             	lea    0x1(%edx),%eax
  800238:	89 03                	mov    %eax,(%ebx)
  80023a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80023d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800241:	3d ff 00 00 00       	cmp    $0xff,%eax
  800246:	74 09                	je     800251 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800248:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80024c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80024f:	c9                   	leave  
  800250:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800251:	83 ec 08             	sub    $0x8,%esp
  800254:	68 ff 00 00 00       	push   $0xff
  800259:	8d 43 08             	lea    0x8(%ebx),%eax
  80025c:	50                   	push   %eax
  80025d:	e8 83 09 00 00       	call   800be5 <sys_cputs>
		b->idx = 0;
  800262:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	eb db                	jmp    800248 <putch+0x1f>

0080026d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800276:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80027d:	00 00 00 
	b.cnt = 0;
  800280:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800287:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80028a:	ff 75 0c             	pushl  0xc(%ebp)
  80028d:	ff 75 08             	pushl  0x8(%ebp)
  800290:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800296:	50                   	push   %eax
  800297:	68 29 02 80 00       	push   $0x800229
  80029c:	e8 1a 01 00 00       	call   8003bb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a1:	83 c4 08             	add    $0x8,%esp
  8002a4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002aa:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b0:	50                   	push   %eax
  8002b1:	e8 2f 09 00 00       	call   800be5 <sys_cputs>

	return b.cnt;
}
  8002b6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002bc:	c9                   	leave  
  8002bd:	c3                   	ret    

008002be <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c7:	50                   	push   %eax
  8002c8:	ff 75 08             	pushl  0x8(%ebp)
  8002cb:	e8 9d ff ff ff       	call   80026d <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	57                   	push   %edi
  8002d6:	56                   	push   %esi
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 1c             	sub    $0x1c,%esp
  8002db:	89 c7                	mov    %eax,%edi
  8002dd:	89 d6                	mov    %edx,%esi
  8002df:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002f6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002f9:	39 d3                	cmp    %edx,%ebx
  8002fb:	72 05                	jb     800302 <printnum+0x30>
  8002fd:	39 45 10             	cmp    %eax,0x10(%ebp)
  800300:	77 7a                	ja     80037c <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800302:	83 ec 0c             	sub    $0xc,%esp
  800305:	ff 75 18             	pushl  0x18(%ebp)
  800308:	8b 45 14             	mov    0x14(%ebp),%eax
  80030b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80030e:	53                   	push   %ebx
  80030f:	ff 75 10             	pushl  0x10(%ebp)
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	ff 75 e4             	pushl  -0x1c(%ebp)
  800318:	ff 75 e0             	pushl  -0x20(%ebp)
  80031b:	ff 75 dc             	pushl  -0x24(%ebp)
  80031e:	ff 75 d8             	pushl  -0x28(%ebp)
  800321:	e8 ea 19 00 00       	call   801d10 <__udivdi3>
  800326:	83 c4 18             	add    $0x18,%esp
  800329:	52                   	push   %edx
  80032a:	50                   	push   %eax
  80032b:	89 f2                	mov    %esi,%edx
  80032d:	89 f8                	mov    %edi,%eax
  80032f:	e8 9e ff ff ff       	call   8002d2 <printnum>
  800334:	83 c4 20             	add    $0x20,%esp
  800337:	eb 13                	jmp    80034c <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800339:	83 ec 08             	sub    $0x8,%esp
  80033c:	56                   	push   %esi
  80033d:	ff 75 18             	pushl  0x18(%ebp)
  800340:	ff d7                	call   *%edi
  800342:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800345:	83 eb 01             	sub    $0x1,%ebx
  800348:	85 db                	test   %ebx,%ebx
  80034a:	7f ed                	jg     800339 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	56                   	push   %esi
  800350:	83 ec 04             	sub    $0x4,%esp
  800353:	ff 75 e4             	pushl  -0x1c(%ebp)
  800356:	ff 75 e0             	pushl  -0x20(%ebp)
  800359:	ff 75 dc             	pushl  -0x24(%ebp)
  80035c:	ff 75 d8             	pushl  -0x28(%ebp)
  80035f:	e8 cc 1a 00 00       	call   801e30 <__umoddi3>
  800364:	83 c4 14             	add    $0x14,%esp
  800367:	0f be 80 eb 1f 80 00 	movsbl 0x801feb(%eax),%eax
  80036e:	50                   	push   %eax
  80036f:	ff d7                	call   *%edi
}
  800371:	83 c4 10             	add    $0x10,%esp
  800374:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800377:	5b                   	pop    %ebx
  800378:	5e                   	pop    %esi
  800379:	5f                   	pop    %edi
  80037a:	5d                   	pop    %ebp
  80037b:	c3                   	ret    
  80037c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80037f:	eb c4                	jmp    800345 <printnum+0x73>

00800381 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
  800384:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800387:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80038b:	8b 10                	mov    (%eax),%edx
  80038d:	3b 50 04             	cmp    0x4(%eax),%edx
  800390:	73 0a                	jae    80039c <sprintputch+0x1b>
		*b->buf++ = ch;
  800392:	8d 4a 01             	lea    0x1(%edx),%ecx
  800395:	89 08                	mov    %ecx,(%eax)
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	88 02                	mov    %al,(%edx)
}
  80039c:	5d                   	pop    %ebp
  80039d:	c3                   	ret    

0080039e <printfmt>:
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003a4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a7:	50                   	push   %eax
  8003a8:	ff 75 10             	pushl  0x10(%ebp)
  8003ab:	ff 75 0c             	pushl  0xc(%ebp)
  8003ae:	ff 75 08             	pushl  0x8(%ebp)
  8003b1:	e8 05 00 00 00       	call   8003bb <vprintfmt>
}
  8003b6:	83 c4 10             	add    $0x10,%esp
  8003b9:	c9                   	leave  
  8003ba:	c3                   	ret    

008003bb <vprintfmt>:
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	57                   	push   %edi
  8003bf:	56                   	push   %esi
  8003c0:	53                   	push   %ebx
  8003c1:	83 ec 2c             	sub    $0x2c,%esp
  8003c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003ca:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003cd:	e9 8c 03 00 00       	jmp    80075e <vprintfmt+0x3a3>
		padc = ' ';
  8003d2:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003dd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003eb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8d 47 01             	lea    0x1(%edi),%eax
  8003f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003f6:	0f b6 17             	movzbl (%edi),%edx
  8003f9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003fc:	3c 55                	cmp    $0x55,%al
  8003fe:	0f 87 dd 03 00 00    	ja     8007e1 <vprintfmt+0x426>
  800404:	0f b6 c0             	movzbl %al,%eax
  800407:	ff 24 85 20 21 80 00 	jmp    *0x802120(,%eax,4)
  80040e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800411:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800415:	eb d9                	jmp    8003f0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80041a:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80041e:	eb d0                	jmp    8003f0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800420:	0f b6 d2             	movzbl %dl,%edx
  800423:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
  80042b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80042e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800431:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800435:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800438:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80043b:	83 f9 09             	cmp    $0x9,%ecx
  80043e:	77 55                	ja     800495 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800440:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800443:	eb e9                	jmp    80042e <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800445:	8b 45 14             	mov    0x14(%ebp),%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	8d 40 04             	lea    0x4(%eax),%eax
  800453:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800456:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800459:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045d:	79 91                	jns    8003f0 <vprintfmt+0x35>
				width = precision, precision = -1;
  80045f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800462:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800465:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80046c:	eb 82                	jmp    8003f0 <vprintfmt+0x35>
  80046e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800471:	85 c0                	test   %eax,%eax
  800473:	ba 00 00 00 00       	mov    $0x0,%edx
  800478:	0f 49 d0             	cmovns %eax,%edx
  80047b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800481:	e9 6a ff ff ff       	jmp    8003f0 <vprintfmt+0x35>
  800486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800489:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800490:	e9 5b ff ff ff       	jmp    8003f0 <vprintfmt+0x35>
  800495:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800498:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80049b:	eb bc                	jmp    800459 <vprintfmt+0x9e>
			lflag++;
  80049d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004a3:	e9 48 ff ff ff       	jmp    8003f0 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8d 78 04             	lea    0x4(%eax),%edi
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	53                   	push   %ebx
  8004b2:	ff 30                	pushl  (%eax)
  8004b4:	ff d6                	call   *%esi
			break;
  8004b6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004bc:	e9 9a 02 00 00       	jmp    80075b <vprintfmt+0x3a0>
			err = va_arg(ap, int);
  8004c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c4:	8d 78 04             	lea    0x4(%eax),%edi
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	31 d0                	xor    %edx,%eax
  8004cc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ce:	83 f8 0f             	cmp    $0xf,%eax
  8004d1:	7f 23                	jg     8004f6 <vprintfmt+0x13b>
  8004d3:	8b 14 85 80 22 80 00 	mov    0x802280(,%eax,4),%edx
  8004da:	85 d2                	test   %edx,%edx
  8004dc:	74 18                	je     8004f6 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8004de:	52                   	push   %edx
  8004df:	68 b5 23 80 00       	push   $0x8023b5
  8004e4:	53                   	push   %ebx
  8004e5:	56                   	push   %esi
  8004e6:	e8 b3 fe ff ff       	call   80039e <printfmt>
  8004eb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ee:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004f1:	e9 65 02 00 00       	jmp    80075b <vprintfmt+0x3a0>
				printfmt(putch, putdat, "error %d", err);
  8004f6:	50                   	push   %eax
  8004f7:	68 03 20 80 00       	push   $0x802003
  8004fc:	53                   	push   %ebx
  8004fd:	56                   	push   %esi
  8004fe:	e8 9b fe ff ff       	call   80039e <printfmt>
  800503:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800506:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800509:	e9 4d 02 00 00       	jmp    80075b <vprintfmt+0x3a0>
			if ((p = va_arg(ap, char *)) == NULL)
  80050e:	8b 45 14             	mov    0x14(%ebp),%eax
  800511:	83 c0 04             	add    $0x4,%eax
  800514:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80051c:	85 ff                	test   %edi,%edi
  80051e:	b8 fc 1f 80 00       	mov    $0x801ffc,%eax
  800523:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800526:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80052a:	0f 8e bd 00 00 00    	jle    8005ed <vprintfmt+0x232>
  800530:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800534:	75 0e                	jne    800544 <vprintfmt+0x189>
  800536:	89 75 08             	mov    %esi,0x8(%ebp)
  800539:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80053f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800542:	eb 6d                	jmp    8005b1 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800544:	83 ec 08             	sub    $0x8,%esp
  800547:	ff 75 d0             	pushl  -0x30(%ebp)
  80054a:	57                   	push   %edi
  80054b:	e8 39 03 00 00       	call   800889 <strnlen>
  800550:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800553:	29 c1                	sub    %eax,%ecx
  800555:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800558:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80055b:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80055f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800562:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800565:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800567:	eb 0f                	jmp    800578 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	53                   	push   %ebx
  80056d:	ff 75 e0             	pushl  -0x20(%ebp)
  800570:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800572:	83 ef 01             	sub    $0x1,%edi
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	85 ff                	test   %edi,%edi
  80057a:	7f ed                	jg     800569 <vprintfmt+0x1ae>
  80057c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80057f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800582:	85 c9                	test   %ecx,%ecx
  800584:	b8 00 00 00 00       	mov    $0x0,%eax
  800589:	0f 49 c1             	cmovns %ecx,%eax
  80058c:	29 c1                	sub    %eax,%ecx
  80058e:	89 75 08             	mov    %esi,0x8(%ebp)
  800591:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800594:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800597:	89 cb                	mov    %ecx,%ebx
  800599:	eb 16                	jmp    8005b1 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80059b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80059f:	75 31                	jne    8005d2 <vprintfmt+0x217>
					putch(ch, putdat);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	ff 75 0c             	pushl  0xc(%ebp)
  8005a7:	50                   	push   %eax
  8005a8:	ff 55 08             	call   *0x8(%ebp)
  8005ab:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ae:	83 eb 01             	sub    $0x1,%ebx
  8005b1:	83 c7 01             	add    $0x1,%edi
  8005b4:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005b8:	0f be c2             	movsbl %dl,%eax
  8005bb:	85 c0                	test   %eax,%eax
  8005bd:	74 59                	je     800618 <vprintfmt+0x25d>
  8005bf:	85 f6                	test   %esi,%esi
  8005c1:	78 d8                	js     80059b <vprintfmt+0x1e0>
  8005c3:	83 ee 01             	sub    $0x1,%esi
  8005c6:	79 d3                	jns    80059b <vprintfmt+0x1e0>
  8005c8:	89 df                	mov    %ebx,%edi
  8005ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8005cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005d0:	eb 37                	jmp    800609 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005d2:	0f be d2             	movsbl %dl,%edx
  8005d5:	83 ea 20             	sub    $0x20,%edx
  8005d8:	83 fa 5e             	cmp    $0x5e,%edx
  8005db:	76 c4                	jbe    8005a1 <vprintfmt+0x1e6>
					putch('?', putdat);
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	ff 75 0c             	pushl  0xc(%ebp)
  8005e3:	6a 3f                	push   $0x3f
  8005e5:	ff 55 08             	call   *0x8(%ebp)
  8005e8:	83 c4 10             	add    $0x10,%esp
  8005eb:	eb c1                	jmp    8005ae <vprintfmt+0x1f3>
  8005ed:	89 75 08             	mov    %esi,0x8(%ebp)
  8005f0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005f3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005f6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005f9:	eb b6                	jmp    8005b1 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	6a 20                	push   $0x20
  800601:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800603:	83 ef 01             	sub    $0x1,%edi
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	85 ff                	test   %edi,%edi
  80060b:	7f ee                	jg     8005fb <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80060d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	e9 43 01 00 00       	jmp    80075b <vprintfmt+0x3a0>
  800618:	89 df                	mov    %ebx,%edi
  80061a:	8b 75 08             	mov    0x8(%ebp),%esi
  80061d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800620:	eb e7                	jmp    800609 <vprintfmt+0x24e>
	if (lflag >= 2)
  800622:	83 f9 01             	cmp    $0x1,%ecx
  800625:	7e 3f                	jle    800666 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8b 50 04             	mov    0x4(%eax),%edx
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800632:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8d 40 08             	lea    0x8(%eax),%eax
  80063b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80063e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800642:	79 5c                	jns    8006a0 <vprintfmt+0x2e5>
				putch('-', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	53                   	push   %ebx
  800648:	6a 2d                	push   $0x2d
  80064a:	ff d6                	call   *%esi
				num = -(long long) num;
  80064c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80064f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800652:	f7 da                	neg    %edx
  800654:	83 d1 00             	adc    $0x0,%ecx
  800657:	f7 d9                	neg    %ecx
  800659:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80065c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800661:	e9 db 00 00 00       	jmp    800741 <vprintfmt+0x386>
	else if (lflag)
  800666:	85 c9                	test   %ecx,%ecx
  800668:	75 1b                	jne    800685 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800672:	89 c1                	mov    %eax,%ecx
  800674:	c1 f9 1f             	sar    $0x1f,%ecx
  800677:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8d 40 04             	lea    0x4(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
  800683:	eb b9                	jmp    80063e <vprintfmt+0x283>
		return va_arg(*ap, long);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068d:	89 c1                	mov    %eax,%ecx
  80068f:	c1 f9 1f             	sar    $0x1f,%ecx
  800692:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 40 04             	lea    0x4(%eax),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
  80069e:	eb 9e                	jmp    80063e <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006a0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ab:	e9 91 00 00 00       	jmp    800741 <vprintfmt+0x386>
	if (lflag >= 2)
  8006b0:	83 f9 01             	cmp    $0x1,%ecx
  8006b3:	7e 15                	jle    8006ca <vprintfmt+0x30f>
		return va_arg(*ap, unsigned long long);
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8b 10                	mov    (%eax),%edx
  8006ba:	8b 48 04             	mov    0x4(%eax),%ecx
  8006bd:	8d 40 08             	lea    0x8(%eax),%eax
  8006c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c8:	eb 77                	jmp    800741 <vprintfmt+0x386>
	else if (lflag)
  8006ca:	85 c9                	test   %ecx,%ecx
  8006cc:	75 17                	jne    8006e5 <vprintfmt+0x32a>
		return va_arg(*ap, unsigned int);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 10                	mov    (%eax),%edx
  8006d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d8:	8d 40 04             	lea    0x4(%eax),%eax
  8006db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e3:	eb 5c                	jmp    800741 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8b 10                	mov    (%eax),%edx
  8006ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ef:	8d 40 04             	lea    0x4(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fa:	eb 45                	jmp    800741 <vprintfmt+0x386>
			putch('X', putdat);
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	53                   	push   %ebx
  800700:	6a 58                	push   $0x58
  800702:	ff d6                	call   *%esi
			putch('X', putdat);
  800704:	83 c4 08             	add    $0x8,%esp
  800707:	53                   	push   %ebx
  800708:	6a 58                	push   $0x58
  80070a:	ff d6                	call   *%esi
			putch('X', putdat);
  80070c:	83 c4 08             	add    $0x8,%esp
  80070f:	53                   	push   %ebx
  800710:	6a 58                	push   $0x58
  800712:	ff d6                	call   *%esi
			break;
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	eb 42                	jmp    80075b <vprintfmt+0x3a0>
			putch('0', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	53                   	push   %ebx
  80071d:	6a 30                	push   $0x30
  80071f:	ff d6                	call   *%esi
			putch('x', putdat);
  800721:	83 c4 08             	add    $0x8,%esp
  800724:	53                   	push   %ebx
  800725:	6a 78                	push   $0x78
  800727:	ff d6                	call   *%esi
			num = (unsigned long long)
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8b 10                	mov    (%eax),%edx
  80072e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800733:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800748:	57                   	push   %edi
  800749:	ff 75 e0             	pushl  -0x20(%ebp)
  80074c:	50                   	push   %eax
  80074d:	51                   	push   %ecx
  80074e:	52                   	push   %edx
  80074f:	89 da                	mov    %ebx,%edx
  800751:	89 f0                	mov    %esi,%eax
  800753:	e8 7a fb ff ff       	call   8002d2 <printnum>
			break;
  800758:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80075b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80075e:	83 c7 01             	add    $0x1,%edi
  800761:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800765:	83 f8 25             	cmp    $0x25,%eax
  800768:	0f 84 64 fc ff ff    	je     8003d2 <vprintfmt+0x17>
			if (ch == '\0')
  80076e:	85 c0                	test   %eax,%eax
  800770:	0f 84 8b 00 00 00    	je     800801 <vprintfmt+0x446>
			putch(ch, putdat);
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	53                   	push   %ebx
  80077a:	50                   	push   %eax
  80077b:	ff d6                	call   *%esi
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	eb dc                	jmp    80075e <vprintfmt+0x3a3>
	if (lflag >= 2)
  800782:	83 f9 01             	cmp    $0x1,%ecx
  800785:	7e 15                	jle    80079c <vprintfmt+0x3e1>
		return va_arg(*ap, unsigned long long);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8b 10                	mov    (%eax),%edx
  80078c:	8b 48 04             	mov    0x4(%eax),%ecx
  80078f:	8d 40 08             	lea    0x8(%eax),%eax
  800792:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800795:	b8 10 00 00 00       	mov    $0x10,%eax
  80079a:	eb a5                	jmp    800741 <vprintfmt+0x386>
	else if (lflag)
  80079c:	85 c9                	test   %ecx,%ecx
  80079e:	75 17                	jne    8007b7 <vprintfmt+0x3fc>
		return va_arg(*ap, unsigned int);
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8b 10                	mov    (%eax),%edx
  8007a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007aa:	8d 40 04             	lea    0x4(%eax),%eax
  8007ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b0:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b5:	eb 8a                	jmp    800741 <vprintfmt+0x386>
		return va_arg(*ap, unsigned long);
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8b 10                	mov    (%eax),%edx
  8007bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007c1:	8d 40 04             	lea    0x4(%eax),%eax
  8007c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c7:	b8 10 00 00 00       	mov    $0x10,%eax
  8007cc:	e9 70 ff ff ff       	jmp    800741 <vprintfmt+0x386>
			putch(ch, putdat);
  8007d1:	83 ec 08             	sub    $0x8,%esp
  8007d4:	53                   	push   %ebx
  8007d5:	6a 25                	push   $0x25
  8007d7:	ff d6                	call   *%esi
			break;
  8007d9:	83 c4 10             	add    $0x10,%esp
  8007dc:	e9 7a ff ff ff       	jmp    80075b <vprintfmt+0x3a0>
			putch('%', putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	6a 25                	push   $0x25
  8007e7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	89 f8                	mov    %edi,%eax
  8007ee:	eb 03                	jmp    8007f3 <vprintfmt+0x438>
  8007f0:	83 e8 01             	sub    $0x1,%eax
  8007f3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007f7:	75 f7                	jne    8007f0 <vprintfmt+0x435>
  8007f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007fc:	e9 5a ff ff ff       	jmp    80075b <vprintfmt+0x3a0>
}
  800801:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800804:	5b                   	pop    %ebx
  800805:	5e                   	pop    %esi
  800806:	5f                   	pop    %edi
  800807:	5d                   	pop    %ebp
  800808:	c3                   	ret    

00800809 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800809:	55                   	push   %ebp
  80080a:	89 e5                	mov    %esp,%ebp
  80080c:	83 ec 18             	sub    $0x18,%esp
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800815:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800818:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80081c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80081f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800826:	85 c0                	test   %eax,%eax
  800828:	74 26                	je     800850 <vsnprintf+0x47>
  80082a:	85 d2                	test   %edx,%edx
  80082c:	7e 22                	jle    800850 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80082e:	ff 75 14             	pushl  0x14(%ebp)
  800831:	ff 75 10             	pushl  0x10(%ebp)
  800834:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800837:	50                   	push   %eax
  800838:	68 81 03 80 00       	push   $0x800381
  80083d:	e8 79 fb ff ff       	call   8003bb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800842:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800845:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084b:	83 c4 10             	add    $0x10,%esp
}
  80084e:	c9                   	leave  
  80084f:	c3                   	ret    
		return -E_INVAL;
  800850:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800855:	eb f7                	jmp    80084e <vsnprintf+0x45>

00800857 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80085d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800860:	50                   	push   %eax
  800861:	ff 75 10             	pushl  0x10(%ebp)
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	ff 75 08             	pushl  0x8(%ebp)
  80086a:	e8 9a ff ff ff       	call   800809 <vsnprintf>
	va_end(ap);

	return rc;
}
  80086f:	c9                   	leave  
  800870:	c3                   	ret    

00800871 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	eb 03                	jmp    800881 <strlen+0x10>
		n++;
  80087e:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800881:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800885:	75 f7                	jne    80087e <strlen+0xd>
	return n;
}
  800887:	5d                   	pop    %ebp
  800888:	c3                   	ret    

00800889 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80088f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800892:	b8 00 00 00 00       	mov    $0x0,%eax
  800897:	eb 03                	jmp    80089c <strnlen+0x13>
		n++;
  800899:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089c:	39 d0                	cmp    %edx,%eax
  80089e:	74 06                	je     8008a6 <strnlen+0x1d>
  8008a0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008a4:	75 f3                	jne    800899 <strnlen+0x10>
	return n;
}
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	53                   	push   %ebx
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008b2:	89 c2                	mov    %eax,%edx
  8008b4:	83 c1 01             	add    $0x1,%ecx
  8008b7:	83 c2 01             	add    $0x1,%edx
  8008ba:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008be:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008c1:	84 db                	test   %bl,%bl
  8008c3:	75 ef                	jne    8008b4 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008c5:	5b                   	pop    %ebx
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	53                   	push   %ebx
  8008cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008cf:	53                   	push   %ebx
  8008d0:	e8 9c ff ff ff       	call   800871 <strlen>
  8008d5:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	01 d8                	add    %ebx,%eax
  8008dd:	50                   	push   %eax
  8008de:	e8 c5 ff ff ff       	call   8008a8 <strcpy>
	return dst;
}
  8008e3:	89 d8                	mov    %ebx,%eax
  8008e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e8:	c9                   	leave  
  8008e9:	c3                   	ret    

008008ea <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	56                   	push   %esi
  8008ee:	53                   	push   %ebx
  8008ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f5:	89 f3                	mov    %esi,%ebx
  8008f7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008fa:	89 f2                	mov    %esi,%edx
  8008fc:	eb 0f                	jmp    80090d <strncpy+0x23>
		*dst++ = *src;
  8008fe:	83 c2 01             	add    $0x1,%edx
  800901:	0f b6 01             	movzbl (%ecx),%eax
  800904:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800907:	80 39 01             	cmpb   $0x1,(%ecx)
  80090a:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80090d:	39 da                	cmp    %ebx,%edx
  80090f:	75 ed                	jne    8008fe <strncpy+0x14>
	}
	return ret;
}
  800911:	89 f0                	mov    %esi,%eax
  800913:	5b                   	pop    %ebx
  800914:	5e                   	pop    %esi
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	8b 75 08             	mov    0x8(%ebp),%esi
  80091f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800922:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800925:	89 f0                	mov    %esi,%eax
  800927:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80092b:	85 c9                	test   %ecx,%ecx
  80092d:	75 0b                	jne    80093a <strlcpy+0x23>
  80092f:	eb 17                	jmp    800948 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800931:	83 c2 01             	add    $0x1,%edx
  800934:	83 c0 01             	add    $0x1,%eax
  800937:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80093a:	39 d8                	cmp    %ebx,%eax
  80093c:	74 07                	je     800945 <strlcpy+0x2e>
  80093e:	0f b6 0a             	movzbl (%edx),%ecx
  800941:	84 c9                	test   %cl,%cl
  800943:	75 ec                	jne    800931 <strlcpy+0x1a>
		*dst = '\0';
  800945:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800948:	29 f0                	sub    %esi,%eax
}
  80094a:	5b                   	pop    %ebx
  80094b:	5e                   	pop    %esi
  80094c:	5d                   	pop    %ebp
  80094d:	c3                   	ret    

0080094e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800954:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800957:	eb 06                	jmp    80095f <strcmp+0x11>
		p++, q++;
  800959:	83 c1 01             	add    $0x1,%ecx
  80095c:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80095f:	0f b6 01             	movzbl (%ecx),%eax
  800962:	84 c0                	test   %al,%al
  800964:	74 04                	je     80096a <strcmp+0x1c>
  800966:	3a 02                	cmp    (%edx),%al
  800968:	74 ef                	je     800959 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80096a:	0f b6 c0             	movzbl %al,%eax
  80096d:	0f b6 12             	movzbl (%edx),%edx
  800970:	29 d0                	sub    %edx,%eax
}
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	53                   	push   %ebx
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097e:	89 c3                	mov    %eax,%ebx
  800980:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800983:	eb 06                	jmp    80098b <strncmp+0x17>
		n--, p++, q++;
  800985:	83 c0 01             	add    $0x1,%eax
  800988:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80098b:	39 d8                	cmp    %ebx,%eax
  80098d:	74 16                	je     8009a5 <strncmp+0x31>
  80098f:	0f b6 08             	movzbl (%eax),%ecx
  800992:	84 c9                	test   %cl,%cl
  800994:	74 04                	je     80099a <strncmp+0x26>
  800996:	3a 0a                	cmp    (%edx),%cl
  800998:	74 eb                	je     800985 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80099a:	0f b6 00             	movzbl (%eax),%eax
  80099d:	0f b6 12             	movzbl (%edx),%edx
  8009a0:	29 d0                	sub    %edx,%eax
}
  8009a2:	5b                   	pop    %ebx
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    
		return 0;
  8009a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009aa:	eb f6                	jmp    8009a2 <strncmp+0x2e>

008009ac <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b6:	0f b6 10             	movzbl (%eax),%edx
  8009b9:	84 d2                	test   %dl,%dl
  8009bb:	74 09                	je     8009c6 <strchr+0x1a>
		if (*s == c)
  8009bd:	38 ca                	cmp    %cl,%dl
  8009bf:	74 0a                	je     8009cb <strchr+0x1f>
	for (; *s; s++)
  8009c1:	83 c0 01             	add    $0x1,%eax
  8009c4:	eb f0                	jmp    8009b6 <strchr+0xa>
			return (char *) s;
	return 0;
  8009c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    

008009cd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d7:	eb 03                	jmp    8009dc <strfind+0xf>
  8009d9:	83 c0 01             	add    $0x1,%eax
  8009dc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009df:	38 ca                	cmp    %cl,%dl
  8009e1:	74 04                	je     8009e7 <strfind+0x1a>
  8009e3:	84 d2                	test   %dl,%dl
  8009e5:	75 f2                	jne    8009d9 <strfind+0xc>
			break;
	return (char *) s;
}
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    

008009e9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	57                   	push   %edi
  8009ed:	56                   	push   %esi
  8009ee:	53                   	push   %ebx
  8009ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009f5:	85 c9                	test   %ecx,%ecx
  8009f7:	74 13                	je     800a0c <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009f9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ff:	75 05                	jne    800a06 <memset+0x1d>
  800a01:	f6 c1 03             	test   $0x3,%cl
  800a04:	74 0d                	je     800a13 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a09:	fc                   	cld    
  800a0a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a0c:	89 f8                	mov    %edi,%eax
  800a0e:	5b                   	pop    %ebx
  800a0f:	5e                   	pop    %esi
  800a10:	5f                   	pop    %edi
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    
		c &= 0xFF;
  800a13:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a17:	89 d3                	mov    %edx,%ebx
  800a19:	c1 e3 08             	shl    $0x8,%ebx
  800a1c:	89 d0                	mov    %edx,%eax
  800a1e:	c1 e0 18             	shl    $0x18,%eax
  800a21:	89 d6                	mov    %edx,%esi
  800a23:	c1 e6 10             	shl    $0x10,%esi
  800a26:	09 f0                	or     %esi,%eax
  800a28:	09 c2                	or     %eax,%edx
  800a2a:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a2c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a2f:	89 d0                	mov    %edx,%eax
  800a31:	fc                   	cld    
  800a32:	f3 ab                	rep stos %eax,%es:(%edi)
  800a34:	eb d6                	jmp    800a0c <memset+0x23>

00800a36 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	57                   	push   %edi
  800a3a:	56                   	push   %esi
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a41:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a44:	39 c6                	cmp    %eax,%esi
  800a46:	73 35                	jae    800a7d <memmove+0x47>
  800a48:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a4b:	39 c2                	cmp    %eax,%edx
  800a4d:	76 2e                	jbe    800a7d <memmove+0x47>
		s += n;
		d += n;
  800a4f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a52:	89 d6                	mov    %edx,%esi
  800a54:	09 fe                	or     %edi,%esi
  800a56:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a5c:	74 0c                	je     800a6a <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a5e:	83 ef 01             	sub    $0x1,%edi
  800a61:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a64:	fd                   	std    
  800a65:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a67:	fc                   	cld    
  800a68:	eb 21                	jmp    800a8b <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6a:	f6 c1 03             	test   $0x3,%cl
  800a6d:	75 ef                	jne    800a5e <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a6f:	83 ef 04             	sub    $0x4,%edi
  800a72:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a75:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a78:	fd                   	std    
  800a79:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7b:	eb ea                	jmp    800a67 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7d:	89 f2                	mov    %esi,%edx
  800a7f:	09 c2                	or     %eax,%edx
  800a81:	f6 c2 03             	test   $0x3,%dl
  800a84:	74 09                	je     800a8f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a86:	89 c7                	mov    %eax,%edi
  800a88:	fc                   	cld    
  800a89:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a8b:	5e                   	pop    %esi
  800a8c:	5f                   	pop    %edi
  800a8d:	5d                   	pop    %ebp
  800a8e:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8f:	f6 c1 03             	test   $0x3,%cl
  800a92:	75 f2                	jne    800a86 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a94:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a97:	89 c7                	mov    %eax,%edi
  800a99:	fc                   	cld    
  800a9a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9c:	eb ed                	jmp    800a8b <memmove+0x55>

00800a9e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800aa1:	ff 75 10             	pushl  0x10(%ebp)
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	ff 75 08             	pushl  0x8(%ebp)
  800aaa:	e8 87 ff ff ff       	call   800a36 <memmove>
}
  800aaf:	c9                   	leave  
  800ab0:	c3                   	ret    

00800ab1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	56                   	push   %esi
  800ab5:	53                   	push   %ebx
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abc:	89 c6                	mov    %eax,%esi
  800abe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac1:	39 f0                	cmp    %esi,%eax
  800ac3:	74 1c                	je     800ae1 <memcmp+0x30>
		if (*s1 != *s2)
  800ac5:	0f b6 08             	movzbl (%eax),%ecx
  800ac8:	0f b6 1a             	movzbl (%edx),%ebx
  800acb:	38 d9                	cmp    %bl,%cl
  800acd:	75 08                	jne    800ad7 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800acf:	83 c0 01             	add    $0x1,%eax
  800ad2:	83 c2 01             	add    $0x1,%edx
  800ad5:	eb ea                	jmp    800ac1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ad7:	0f b6 c1             	movzbl %cl,%eax
  800ada:	0f b6 db             	movzbl %bl,%ebx
  800add:	29 d8                	sub    %ebx,%eax
  800adf:	eb 05                	jmp    800ae6 <memcmp+0x35>
	}

	return 0;
  800ae1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae6:	5b                   	pop    %ebx
  800ae7:	5e                   	pop    %esi
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800af3:	89 c2                	mov    %eax,%edx
  800af5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800af8:	39 d0                	cmp    %edx,%eax
  800afa:	73 09                	jae    800b05 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800afc:	38 08                	cmp    %cl,(%eax)
  800afe:	74 05                	je     800b05 <memfind+0x1b>
	for (; s < ends; s++)
  800b00:	83 c0 01             	add    $0x1,%eax
  800b03:	eb f3                	jmp    800af8 <memfind+0xe>
			break;
	return (void *) s;
}
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	57                   	push   %edi
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b13:	eb 03                	jmp    800b18 <strtol+0x11>
		s++;
  800b15:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b18:	0f b6 01             	movzbl (%ecx),%eax
  800b1b:	3c 20                	cmp    $0x20,%al
  800b1d:	74 f6                	je     800b15 <strtol+0xe>
  800b1f:	3c 09                	cmp    $0x9,%al
  800b21:	74 f2                	je     800b15 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b23:	3c 2b                	cmp    $0x2b,%al
  800b25:	74 2e                	je     800b55 <strtol+0x4e>
	int neg = 0;
  800b27:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b2c:	3c 2d                	cmp    $0x2d,%al
  800b2e:	74 2f                	je     800b5f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b30:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b36:	75 05                	jne    800b3d <strtol+0x36>
  800b38:	80 39 30             	cmpb   $0x30,(%ecx)
  800b3b:	74 2c                	je     800b69 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b3d:	85 db                	test   %ebx,%ebx
  800b3f:	75 0a                	jne    800b4b <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b41:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b46:	80 39 30             	cmpb   $0x30,(%ecx)
  800b49:	74 28                	je     800b73 <strtol+0x6c>
		base = 10;
  800b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b50:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b53:	eb 50                	jmp    800ba5 <strtol+0x9e>
		s++;
  800b55:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b58:	bf 00 00 00 00       	mov    $0x0,%edi
  800b5d:	eb d1                	jmp    800b30 <strtol+0x29>
		s++, neg = 1;
  800b5f:	83 c1 01             	add    $0x1,%ecx
  800b62:	bf 01 00 00 00       	mov    $0x1,%edi
  800b67:	eb c7                	jmp    800b30 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b69:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b6d:	74 0e                	je     800b7d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b6f:	85 db                	test   %ebx,%ebx
  800b71:	75 d8                	jne    800b4b <strtol+0x44>
		s++, base = 8;
  800b73:	83 c1 01             	add    $0x1,%ecx
  800b76:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b7b:	eb ce                	jmp    800b4b <strtol+0x44>
		s += 2, base = 16;
  800b7d:	83 c1 02             	add    $0x2,%ecx
  800b80:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b85:	eb c4                	jmp    800b4b <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b87:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b8a:	89 f3                	mov    %esi,%ebx
  800b8c:	80 fb 19             	cmp    $0x19,%bl
  800b8f:	77 29                	ja     800bba <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b91:	0f be d2             	movsbl %dl,%edx
  800b94:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b97:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b9a:	7d 30                	jge    800bcc <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b9c:	83 c1 01             	add    $0x1,%ecx
  800b9f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ba3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ba5:	0f b6 11             	movzbl (%ecx),%edx
  800ba8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bab:	89 f3                	mov    %esi,%ebx
  800bad:	80 fb 09             	cmp    $0x9,%bl
  800bb0:	77 d5                	ja     800b87 <strtol+0x80>
			dig = *s - '0';
  800bb2:	0f be d2             	movsbl %dl,%edx
  800bb5:	83 ea 30             	sub    $0x30,%edx
  800bb8:	eb dd                	jmp    800b97 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800bba:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bbd:	89 f3                	mov    %esi,%ebx
  800bbf:	80 fb 19             	cmp    $0x19,%bl
  800bc2:	77 08                	ja     800bcc <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bc4:	0f be d2             	movsbl %dl,%edx
  800bc7:	83 ea 37             	sub    $0x37,%edx
  800bca:	eb cb                	jmp    800b97 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	74 05                	je     800bd7 <strtol+0xd0>
		*endptr = (char *) s;
  800bd2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bd7:	89 c2                	mov    %eax,%edx
  800bd9:	f7 da                	neg    %edx
  800bdb:	85 ff                	test   %edi,%edi
  800bdd:	0f 45 c2             	cmovne %edx,%eax
}
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	57                   	push   %edi
  800be9:	56                   	push   %esi
  800bea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800beb:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf6:	89 c3                	mov    %eax,%ebx
  800bf8:	89 c7                	mov    %eax,%edi
  800bfa:	89 c6                	mov    %eax,%esi
  800bfc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c09:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c13:	89 d1                	mov    %edx,%ecx
  800c15:	89 d3                	mov    %edx,%ebx
  800c17:	89 d7                	mov    %edx,%edi
  800c19:	89 d6                	mov    %edx,%esi
  800c1b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c1d:	5b                   	pop    %ebx
  800c1e:	5e                   	pop    %esi
  800c1f:	5f                   	pop    %edi
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	57                   	push   %edi
  800c26:	56                   	push   %esi
  800c27:	53                   	push   %ebx
  800c28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c30:	8b 55 08             	mov    0x8(%ebp),%edx
  800c33:	b8 03 00 00 00       	mov    $0x3,%eax
  800c38:	89 cb                	mov    %ecx,%ebx
  800c3a:	89 cf                	mov    %ecx,%edi
  800c3c:	89 ce                	mov    %ecx,%esi
  800c3e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c40:	85 c0                	test   %eax,%eax
  800c42:	7f 08                	jg     800c4c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5f                   	pop    %edi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4c:	83 ec 0c             	sub    $0xc,%esp
  800c4f:	50                   	push   %eax
  800c50:	6a 03                	push   $0x3
  800c52:	68 df 22 80 00       	push   $0x8022df
  800c57:	6a 23                	push   $0x23
  800c59:	68 fc 22 80 00       	push   $0x8022fc
  800c5e:	e8 80 f5 ff ff       	call   8001e3 <_panic>

00800c63 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c69:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6e:	b8 02 00 00 00       	mov    $0x2,%eax
  800c73:	89 d1                	mov    %edx,%ecx
  800c75:	89 d3                	mov    %edx,%ebx
  800c77:	89 d7                	mov    %edx,%edi
  800c79:	89 d6                	mov    %edx,%esi
  800c7b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <sys_yield>:

void
sys_yield(void)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c88:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c92:	89 d1                	mov    %edx,%ecx
  800c94:	89 d3                	mov    %edx,%ebx
  800c96:	89 d7                	mov    %edx,%edi
  800c98:	89 d6                	mov    %edx,%esi
  800c9a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c9c:	5b                   	pop    %ebx
  800c9d:	5e                   	pop    %esi
  800c9e:	5f                   	pop    %edi
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    

00800ca1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	57                   	push   %edi
  800ca5:	56                   	push   %esi
  800ca6:	53                   	push   %ebx
  800ca7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800caa:	be 00 00 00 00       	mov    $0x0,%esi
  800caf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb5:	b8 04 00 00 00       	mov    $0x4,%eax
  800cba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cbd:	89 f7                	mov    %esi,%edi
  800cbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc1:	85 c0                	test   %eax,%eax
  800cc3:	7f 08                	jg     800ccd <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc8:	5b                   	pop    %ebx
  800cc9:	5e                   	pop    %esi
  800cca:	5f                   	pop    %edi
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccd:	83 ec 0c             	sub    $0xc,%esp
  800cd0:	50                   	push   %eax
  800cd1:	6a 04                	push   $0x4
  800cd3:	68 df 22 80 00       	push   $0x8022df
  800cd8:	6a 23                	push   $0x23
  800cda:	68 fc 22 80 00       	push   $0x8022fc
  800cdf:	e8 ff f4 ff ff       	call   8001e3 <_panic>

00800ce4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ced:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf3:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cfe:	8b 75 18             	mov    0x18(%ebp),%esi
  800d01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7f 08                	jg     800d0f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	50                   	push   %eax
  800d13:	6a 05                	push   $0x5
  800d15:	68 df 22 80 00       	push   $0x8022df
  800d1a:	6a 23                	push   $0x23
  800d1c:	68 fc 22 80 00       	push   $0x8022fc
  800d21:	e8 bd f4 ff ff       	call   8001e3 <_panic>

00800d26 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
  800d2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3a:	b8 06 00 00 00       	mov    $0x6,%eax
  800d3f:	89 df                	mov    %ebx,%edi
  800d41:	89 de                	mov    %ebx,%esi
  800d43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	7f 08                	jg     800d51 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d51:	83 ec 0c             	sub    $0xc,%esp
  800d54:	50                   	push   %eax
  800d55:	6a 06                	push   $0x6
  800d57:	68 df 22 80 00       	push   $0x8022df
  800d5c:	6a 23                	push   $0x23
  800d5e:	68 fc 22 80 00       	push   $0x8022fc
  800d63:	e8 7b f4 ff ff       	call   8001e3 <_panic>

00800d68 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
  800d6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d71:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	b8 08 00 00 00       	mov    $0x8,%eax
  800d81:	89 df                	mov    %ebx,%edi
  800d83:	89 de                	mov    %ebx,%esi
  800d85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	7f 08                	jg     800d93 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	50                   	push   %eax
  800d97:	6a 08                	push   $0x8
  800d99:	68 df 22 80 00       	push   $0x8022df
  800d9e:	6a 23                	push   $0x23
  800da0:	68 fc 22 80 00       	push   $0x8022fc
  800da5:	e8 39 f4 ff ff       	call   8001e3 <_panic>

00800daa <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbe:	b8 09 00 00 00       	mov    $0x9,%eax
  800dc3:	89 df                	mov    %ebx,%edi
  800dc5:	89 de                	mov    %ebx,%esi
  800dc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7f 08                	jg     800dd5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	50                   	push   %eax
  800dd9:	6a 09                	push   $0x9
  800ddb:	68 df 22 80 00       	push   $0x8022df
  800de0:	6a 23                	push   $0x23
  800de2:	68 fc 22 80 00       	push   $0x8022fc
  800de7:	e8 f7 f3 ff ff       	call   8001e3 <_panic>

00800dec <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	57                   	push   %edi
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
  800df2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e00:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e05:	89 df                	mov    %ebx,%edi
  800e07:	89 de                	mov    %ebx,%esi
  800e09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	7f 08                	jg     800e17 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e17:	83 ec 0c             	sub    $0xc,%esp
  800e1a:	50                   	push   %eax
  800e1b:	6a 0a                	push   $0xa
  800e1d:	68 df 22 80 00       	push   $0x8022df
  800e22:	6a 23                	push   $0x23
  800e24:	68 fc 22 80 00       	push   $0x8022fc
  800e29:	e8 b5 f3 ff ff       	call   8001e3 <_panic>

00800e2e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e34:	8b 55 08             	mov    0x8(%ebp),%edx
  800e37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e3f:	be 00 00 00 00       	mov    $0x0,%esi
  800e44:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e47:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e4a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e4c:	5b                   	pop    %ebx
  800e4d:	5e                   	pop    %esi
  800e4e:	5f                   	pop    %edi
  800e4f:	5d                   	pop    %ebp
  800e50:	c3                   	ret    

00800e51 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	57                   	push   %edi
  800e55:	56                   	push   %esi
  800e56:	53                   	push   %ebx
  800e57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e67:	89 cb                	mov    %ecx,%ebx
  800e69:	89 cf                	mov    %ecx,%edi
  800e6b:	89 ce                	mov    %ecx,%esi
  800e6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	7f 08                	jg     800e7b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7b:	83 ec 0c             	sub    $0xc,%esp
  800e7e:	50                   	push   %eax
  800e7f:	6a 0d                	push   $0xd
  800e81:	68 df 22 80 00       	push   $0x8022df
  800e86:	6a 23                	push   $0x23
  800e88:	68 fc 22 80 00       	push   $0x8022fc
  800e8d:	e8 51 f3 ff ff       	call   8001e3 <_panic>

00800e92 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	05 00 00 00 30       	add    $0x30000000,%eax
  800e9d:	c1 e8 0c             	shr    $0xc,%eax
}
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    

00800ea2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ead:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eb2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ebf:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ec4:	89 c2                	mov    %eax,%edx
  800ec6:	c1 ea 16             	shr    $0x16,%edx
  800ec9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ed0:	f6 c2 01             	test   $0x1,%dl
  800ed3:	74 2a                	je     800eff <fd_alloc+0x46>
  800ed5:	89 c2                	mov    %eax,%edx
  800ed7:	c1 ea 0c             	shr    $0xc,%edx
  800eda:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ee1:	f6 c2 01             	test   $0x1,%dl
  800ee4:	74 19                	je     800eff <fd_alloc+0x46>
  800ee6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800eeb:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ef0:	75 d2                	jne    800ec4 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ef2:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ef8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800efd:	eb 07                	jmp    800f06 <fd_alloc+0x4d>
			*fd_store = fd;
  800eff:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f0e:	83 f8 1f             	cmp    $0x1f,%eax
  800f11:	77 36                	ja     800f49 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f13:	c1 e0 0c             	shl    $0xc,%eax
  800f16:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f1b:	89 c2                	mov    %eax,%edx
  800f1d:	c1 ea 16             	shr    $0x16,%edx
  800f20:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f27:	f6 c2 01             	test   $0x1,%dl
  800f2a:	74 24                	je     800f50 <fd_lookup+0x48>
  800f2c:	89 c2                	mov    %eax,%edx
  800f2e:	c1 ea 0c             	shr    $0xc,%edx
  800f31:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f38:	f6 c2 01             	test   $0x1,%dl
  800f3b:	74 1a                	je     800f57 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f40:	89 02                	mov    %eax,(%edx)
	return 0;
  800f42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    
		return -E_INVAL;
  800f49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f4e:	eb f7                	jmp    800f47 <fd_lookup+0x3f>
		return -E_INVAL;
  800f50:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f55:	eb f0                	jmp    800f47 <fd_lookup+0x3f>
  800f57:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5c:	eb e9                	jmp    800f47 <fd_lookup+0x3f>

00800f5e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 08             	sub    $0x8,%esp
  800f64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f67:	ba 8c 23 80 00       	mov    $0x80238c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f6c:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f71:	39 08                	cmp    %ecx,(%eax)
  800f73:	74 33                	je     800fa8 <dev_lookup+0x4a>
  800f75:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f78:	8b 02                	mov    (%edx),%eax
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	75 f3                	jne    800f71 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f7e:	a1 08 40 80 00       	mov    0x804008,%eax
  800f83:	8b 40 48             	mov    0x48(%eax),%eax
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	51                   	push   %ecx
  800f8a:	50                   	push   %eax
  800f8b:	68 0c 23 80 00       	push   $0x80230c
  800f90:	e8 29 f3 ff ff       	call   8002be <cprintf>
	*dev = 0;
  800f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f9e:	83 c4 10             	add    $0x10,%esp
  800fa1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fa6:	c9                   	leave  
  800fa7:	c3                   	ret    
			*dev = devtab[i];
  800fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fab:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fad:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb2:	eb f2                	jmp    800fa6 <dev_lookup+0x48>

00800fb4 <fd_close>:
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	57                   	push   %edi
  800fb8:	56                   	push   %esi
  800fb9:	53                   	push   %ebx
  800fba:	83 ec 1c             	sub    $0x1c,%esp
  800fbd:	8b 75 08             	mov    0x8(%ebp),%esi
  800fc0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fc3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fc6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fcd:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fd0:	50                   	push   %eax
  800fd1:	e8 32 ff ff ff       	call   800f08 <fd_lookup>
  800fd6:	89 c3                	mov    %eax,%ebx
  800fd8:	83 c4 08             	add    $0x8,%esp
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	78 05                	js     800fe4 <fd_close+0x30>
	    || fd != fd2)
  800fdf:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fe2:	74 16                	je     800ffa <fd_close+0x46>
		return (must_exist ? r : 0);
  800fe4:	89 f8                	mov    %edi,%eax
  800fe6:	84 c0                	test   %al,%al
  800fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fed:	0f 44 d8             	cmove  %eax,%ebx
}
  800ff0:	89 d8                	mov    %ebx,%eax
  800ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ffa:	83 ec 08             	sub    $0x8,%esp
  800ffd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801000:	50                   	push   %eax
  801001:	ff 36                	pushl  (%esi)
  801003:	e8 56 ff ff ff       	call   800f5e <dev_lookup>
  801008:	89 c3                	mov    %eax,%ebx
  80100a:	83 c4 10             	add    $0x10,%esp
  80100d:	85 c0                	test   %eax,%eax
  80100f:	78 15                	js     801026 <fd_close+0x72>
		if (dev->dev_close)
  801011:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801014:	8b 40 10             	mov    0x10(%eax),%eax
  801017:	85 c0                	test   %eax,%eax
  801019:	74 1b                	je     801036 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80101b:	83 ec 0c             	sub    $0xc,%esp
  80101e:	56                   	push   %esi
  80101f:	ff d0                	call   *%eax
  801021:	89 c3                	mov    %eax,%ebx
  801023:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	56                   	push   %esi
  80102a:	6a 00                	push   $0x0
  80102c:	e8 f5 fc ff ff       	call   800d26 <sys_page_unmap>
	return r;
  801031:	83 c4 10             	add    $0x10,%esp
  801034:	eb ba                	jmp    800ff0 <fd_close+0x3c>
			r = 0;
  801036:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103b:	eb e9                	jmp    801026 <fd_close+0x72>

0080103d <close>:

int
close(int fdnum)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801043:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801046:	50                   	push   %eax
  801047:	ff 75 08             	pushl  0x8(%ebp)
  80104a:	e8 b9 fe ff ff       	call   800f08 <fd_lookup>
  80104f:	83 c4 08             	add    $0x8,%esp
  801052:	85 c0                	test   %eax,%eax
  801054:	78 10                	js     801066 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801056:	83 ec 08             	sub    $0x8,%esp
  801059:	6a 01                	push   $0x1
  80105b:	ff 75 f4             	pushl  -0xc(%ebp)
  80105e:	e8 51 ff ff ff       	call   800fb4 <fd_close>
  801063:	83 c4 10             	add    $0x10,%esp
}
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <close_all>:

void
close_all(void)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	53                   	push   %ebx
  80106c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80106f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801074:	83 ec 0c             	sub    $0xc,%esp
  801077:	53                   	push   %ebx
  801078:	e8 c0 ff ff ff       	call   80103d <close>
	for (i = 0; i < MAXFD; i++)
  80107d:	83 c3 01             	add    $0x1,%ebx
  801080:	83 c4 10             	add    $0x10,%esp
  801083:	83 fb 20             	cmp    $0x20,%ebx
  801086:	75 ec                	jne    801074 <close_all+0xc>
}
  801088:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80108b:	c9                   	leave  
  80108c:	c3                   	ret    

0080108d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	57                   	push   %edi
  801091:	56                   	push   %esi
  801092:	53                   	push   %ebx
  801093:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801096:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801099:	50                   	push   %eax
  80109a:	ff 75 08             	pushl  0x8(%ebp)
  80109d:	e8 66 fe ff ff       	call   800f08 <fd_lookup>
  8010a2:	89 c3                	mov    %eax,%ebx
  8010a4:	83 c4 08             	add    $0x8,%esp
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	0f 88 81 00 00 00    	js     801130 <dup+0xa3>
		return r;
	close(newfdnum);
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	ff 75 0c             	pushl  0xc(%ebp)
  8010b5:	e8 83 ff ff ff       	call   80103d <close>

	newfd = INDEX2FD(newfdnum);
  8010ba:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010bd:	c1 e6 0c             	shl    $0xc,%esi
  8010c0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010c6:	83 c4 04             	add    $0x4,%esp
  8010c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010cc:	e8 d1 fd ff ff       	call   800ea2 <fd2data>
  8010d1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010d3:	89 34 24             	mov    %esi,(%esp)
  8010d6:	e8 c7 fd ff ff       	call   800ea2 <fd2data>
  8010db:	83 c4 10             	add    $0x10,%esp
  8010de:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010e0:	89 d8                	mov    %ebx,%eax
  8010e2:	c1 e8 16             	shr    $0x16,%eax
  8010e5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010ec:	a8 01                	test   $0x1,%al
  8010ee:	74 11                	je     801101 <dup+0x74>
  8010f0:	89 d8                	mov    %ebx,%eax
  8010f2:	c1 e8 0c             	shr    $0xc,%eax
  8010f5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010fc:	f6 c2 01             	test   $0x1,%dl
  8010ff:	75 39                	jne    80113a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801101:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801104:	89 d0                	mov    %edx,%eax
  801106:	c1 e8 0c             	shr    $0xc,%eax
  801109:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801110:	83 ec 0c             	sub    $0xc,%esp
  801113:	25 07 0e 00 00       	and    $0xe07,%eax
  801118:	50                   	push   %eax
  801119:	56                   	push   %esi
  80111a:	6a 00                	push   $0x0
  80111c:	52                   	push   %edx
  80111d:	6a 00                	push   $0x0
  80111f:	e8 c0 fb ff ff       	call   800ce4 <sys_page_map>
  801124:	89 c3                	mov    %eax,%ebx
  801126:	83 c4 20             	add    $0x20,%esp
  801129:	85 c0                	test   %eax,%eax
  80112b:	78 31                	js     80115e <dup+0xd1>
		goto err;

	return newfdnum;
  80112d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801130:	89 d8                	mov    %ebx,%eax
  801132:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801135:	5b                   	pop    %ebx
  801136:	5e                   	pop    %esi
  801137:	5f                   	pop    %edi
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80113a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801141:	83 ec 0c             	sub    $0xc,%esp
  801144:	25 07 0e 00 00       	and    $0xe07,%eax
  801149:	50                   	push   %eax
  80114a:	57                   	push   %edi
  80114b:	6a 00                	push   $0x0
  80114d:	53                   	push   %ebx
  80114e:	6a 00                	push   $0x0
  801150:	e8 8f fb ff ff       	call   800ce4 <sys_page_map>
  801155:	89 c3                	mov    %eax,%ebx
  801157:	83 c4 20             	add    $0x20,%esp
  80115a:	85 c0                	test   %eax,%eax
  80115c:	79 a3                	jns    801101 <dup+0x74>
	sys_page_unmap(0, newfd);
  80115e:	83 ec 08             	sub    $0x8,%esp
  801161:	56                   	push   %esi
  801162:	6a 00                	push   $0x0
  801164:	e8 bd fb ff ff       	call   800d26 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801169:	83 c4 08             	add    $0x8,%esp
  80116c:	57                   	push   %edi
  80116d:	6a 00                	push   $0x0
  80116f:	e8 b2 fb ff ff       	call   800d26 <sys_page_unmap>
	return r;
  801174:	83 c4 10             	add    $0x10,%esp
  801177:	eb b7                	jmp    801130 <dup+0xa3>

00801179 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	53                   	push   %ebx
  80117d:	83 ec 14             	sub    $0x14,%esp
  801180:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801183:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801186:	50                   	push   %eax
  801187:	53                   	push   %ebx
  801188:	e8 7b fd ff ff       	call   800f08 <fd_lookup>
  80118d:	83 c4 08             	add    $0x8,%esp
  801190:	85 c0                	test   %eax,%eax
  801192:	78 3f                	js     8011d3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80119a:	50                   	push   %eax
  80119b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80119e:	ff 30                	pushl  (%eax)
  8011a0:	e8 b9 fd ff ff       	call   800f5e <dev_lookup>
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	78 27                	js     8011d3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011af:	8b 42 08             	mov    0x8(%edx),%eax
  8011b2:	83 e0 03             	and    $0x3,%eax
  8011b5:	83 f8 01             	cmp    $0x1,%eax
  8011b8:	74 1e                	je     8011d8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bd:	8b 40 08             	mov    0x8(%eax),%eax
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	74 35                	je     8011f9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011c4:	83 ec 04             	sub    $0x4,%esp
  8011c7:	ff 75 10             	pushl  0x10(%ebp)
  8011ca:	ff 75 0c             	pushl  0xc(%ebp)
  8011cd:	52                   	push   %edx
  8011ce:	ff d0                	call   *%eax
  8011d0:	83 c4 10             	add    $0x10,%esp
}
  8011d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011d8:	a1 08 40 80 00       	mov    0x804008,%eax
  8011dd:	8b 40 48             	mov    0x48(%eax),%eax
  8011e0:	83 ec 04             	sub    $0x4,%esp
  8011e3:	53                   	push   %ebx
  8011e4:	50                   	push   %eax
  8011e5:	68 50 23 80 00       	push   $0x802350
  8011ea:	e8 cf f0 ff ff       	call   8002be <cprintf>
		return -E_INVAL;
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f7:	eb da                	jmp    8011d3 <read+0x5a>
		return -E_NOT_SUPP;
  8011f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011fe:	eb d3                	jmp    8011d3 <read+0x5a>

00801200 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	57                   	push   %edi
  801204:	56                   	push   %esi
  801205:	53                   	push   %ebx
  801206:	83 ec 0c             	sub    $0xc,%esp
  801209:	8b 7d 08             	mov    0x8(%ebp),%edi
  80120c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80120f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801214:	39 f3                	cmp    %esi,%ebx
  801216:	73 25                	jae    80123d <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801218:	83 ec 04             	sub    $0x4,%esp
  80121b:	89 f0                	mov    %esi,%eax
  80121d:	29 d8                	sub    %ebx,%eax
  80121f:	50                   	push   %eax
  801220:	89 d8                	mov    %ebx,%eax
  801222:	03 45 0c             	add    0xc(%ebp),%eax
  801225:	50                   	push   %eax
  801226:	57                   	push   %edi
  801227:	e8 4d ff ff ff       	call   801179 <read>
		if (m < 0)
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	78 08                	js     80123b <readn+0x3b>
			return m;
		if (m == 0)
  801233:	85 c0                	test   %eax,%eax
  801235:	74 06                	je     80123d <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801237:	01 c3                	add    %eax,%ebx
  801239:	eb d9                	jmp    801214 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80123b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80123d:	89 d8                	mov    %ebx,%eax
  80123f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801242:	5b                   	pop    %ebx
  801243:	5e                   	pop    %esi
  801244:	5f                   	pop    %edi
  801245:	5d                   	pop    %ebp
  801246:	c3                   	ret    

00801247 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
  80124a:	53                   	push   %ebx
  80124b:	83 ec 14             	sub    $0x14,%esp
  80124e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801251:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801254:	50                   	push   %eax
  801255:	53                   	push   %ebx
  801256:	e8 ad fc ff ff       	call   800f08 <fd_lookup>
  80125b:	83 c4 08             	add    $0x8,%esp
  80125e:	85 c0                	test   %eax,%eax
  801260:	78 3a                	js     80129c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801262:	83 ec 08             	sub    $0x8,%esp
  801265:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801268:	50                   	push   %eax
  801269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126c:	ff 30                	pushl  (%eax)
  80126e:	e8 eb fc ff ff       	call   800f5e <dev_lookup>
  801273:	83 c4 10             	add    $0x10,%esp
  801276:	85 c0                	test   %eax,%eax
  801278:	78 22                	js     80129c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80127a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801281:	74 1e                	je     8012a1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801286:	8b 52 0c             	mov    0xc(%edx),%edx
  801289:	85 d2                	test   %edx,%edx
  80128b:	74 35                	je     8012c2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80128d:	83 ec 04             	sub    $0x4,%esp
  801290:	ff 75 10             	pushl  0x10(%ebp)
  801293:	ff 75 0c             	pushl  0xc(%ebp)
  801296:	50                   	push   %eax
  801297:	ff d2                	call   *%edx
  801299:	83 c4 10             	add    $0x10,%esp
}
  80129c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8012a6:	8b 40 48             	mov    0x48(%eax),%eax
  8012a9:	83 ec 04             	sub    $0x4,%esp
  8012ac:	53                   	push   %ebx
  8012ad:	50                   	push   %eax
  8012ae:	68 6c 23 80 00       	push   $0x80236c
  8012b3:	e8 06 f0 ff ff       	call   8002be <cprintf>
		return -E_INVAL;
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c0:	eb da                	jmp    80129c <write+0x55>
		return -E_NOT_SUPP;
  8012c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c7:	eb d3                	jmp    80129c <write+0x55>

008012c9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012cf:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012d2:	50                   	push   %eax
  8012d3:	ff 75 08             	pushl  0x8(%ebp)
  8012d6:	e8 2d fc ff ff       	call   800f08 <fd_lookup>
  8012db:	83 c4 08             	add    $0x8,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	78 0e                	js     8012f0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	53                   	push   %ebx
  8012f6:	83 ec 14             	sub    $0x14,%esp
  8012f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ff:	50                   	push   %eax
  801300:	53                   	push   %ebx
  801301:	e8 02 fc ff ff       	call   800f08 <fd_lookup>
  801306:	83 c4 08             	add    $0x8,%esp
  801309:	85 c0                	test   %eax,%eax
  80130b:	78 37                	js     801344 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80130d:	83 ec 08             	sub    $0x8,%esp
  801310:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801313:	50                   	push   %eax
  801314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801317:	ff 30                	pushl  (%eax)
  801319:	e8 40 fc ff ff       	call   800f5e <dev_lookup>
  80131e:	83 c4 10             	add    $0x10,%esp
  801321:	85 c0                	test   %eax,%eax
  801323:	78 1f                	js     801344 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801328:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80132c:	74 1b                	je     801349 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80132e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801331:	8b 52 18             	mov    0x18(%edx),%edx
  801334:	85 d2                	test   %edx,%edx
  801336:	74 32                	je     80136a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801338:	83 ec 08             	sub    $0x8,%esp
  80133b:	ff 75 0c             	pushl  0xc(%ebp)
  80133e:	50                   	push   %eax
  80133f:	ff d2                	call   *%edx
  801341:	83 c4 10             	add    $0x10,%esp
}
  801344:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801347:	c9                   	leave  
  801348:	c3                   	ret    
			thisenv->env_id, fdnum);
  801349:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80134e:	8b 40 48             	mov    0x48(%eax),%eax
  801351:	83 ec 04             	sub    $0x4,%esp
  801354:	53                   	push   %ebx
  801355:	50                   	push   %eax
  801356:	68 2c 23 80 00       	push   $0x80232c
  80135b:	e8 5e ef ff ff       	call   8002be <cprintf>
		return -E_INVAL;
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801368:	eb da                	jmp    801344 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80136a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136f:	eb d3                	jmp    801344 <ftruncate+0x52>

00801371 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	53                   	push   %ebx
  801375:	83 ec 14             	sub    $0x14,%esp
  801378:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80137b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80137e:	50                   	push   %eax
  80137f:	ff 75 08             	pushl  0x8(%ebp)
  801382:	e8 81 fb ff ff       	call   800f08 <fd_lookup>
  801387:	83 c4 08             	add    $0x8,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	78 4b                	js     8013d9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801394:	50                   	push   %eax
  801395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801398:	ff 30                	pushl  (%eax)
  80139a:	e8 bf fb ff ff       	call   800f5e <dev_lookup>
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	78 33                	js     8013d9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013ad:	74 2f                	je     8013de <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013af:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013b2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013b9:	00 00 00 
	stat->st_isdir = 0;
  8013bc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013c3:	00 00 00 
	stat->st_dev = dev;
  8013c6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013cc:	83 ec 08             	sub    $0x8,%esp
  8013cf:	53                   	push   %ebx
  8013d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8013d3:	ff 50 14             	call   *0x14(%eax)
  8013d6:	83 c4 10             	add    $0x10,%esp
}
  8013d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    
		return -E_NOT_SUPP;
  8013de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e3:	eb f4                	jmp    8013d9 <fstat+0x68>

008013e5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	56                   	push   %esi
  8013e9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013ea:	83 ec 08             	sub    $0x8,%esp
  8013ed:	6a 00                	push   $0x0
  8013ef:	ff 75 08             	pushl  0x8(%ebp)
  8013f2:	e8 e7 01 00 00       	call   8015de <open>
  8013f7:	89 c3                	mov    %eax,%ebx
  8013f9:	83 c4 10             	add    $0x10,%esp
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	78 1b                	js     80141b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	50                   	push   %eax
  801407:	e8 65 ff ff ff       	call   801371 <fstat>
  80140c:	89 c6                	mov    %eax,%esi
	close(fd);
  80140e:	89 1c 24             	mov    %ebx,(%esp)
  801411:	e8 27 fc ff ff       	call   80103d <close>
	return r;
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	89 f3                	mov    %esi,%ebx
}
  80141b:	89 d8                	mov    %ebx,%eax
  80141d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801420:	5b                   	pop    %ebx
  801421:	5e                   	pop    %esi
  801422:	5d                   	pop    %ebp
  801423:	c3                   	ret    

00801424 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	56                   	push   %esi
  801428:	53                   	push   %ebx
  801429:	89 c6                	mov    %eax,%esi
  80142b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80142d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801434:	74 27                	je     80145d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801436:	6a 07                	push   $0x7
  801438:	68 00 50 80 00       	push   $0x805000
  80143d:	56                   	push   %esi
  80143e:	ff 35 04 40 80 00    	pushl  0x804004
  801444:	e8 30 08 00 00       	call   801c79 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801449:	83 c4 0c             	add    $0xc,%esp
  80144c:	6a 00                	push   $0x0
  80144e:	53                   	push   %ebx
  80144f:	6a 00                	push   $0x0
  801451:	e8 0c 08 00 00       	call   801c62 <ipc_recv>
}
  801456:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801459:	5b                   	pop    %ebx
  80145a:	5e                   	pop    %esi
  80145b:	5d                   	pop    %ebp
  80145c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80145d:	83 ec 0c             	sub    $0xc,%esp
  801460:	6a 01                	push   $0x1
  801462:	e8 29 08 00 00       	call   801c90 <ipc_find_env>
  801467:	a3 04 40 80 00       	mov    %eax,0x804004
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	eb c5                	jmp    801436 <fsipc+0x12>

00801471 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8b 40 0c             	mov    0xc(%eax),%eax
  80147d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80148a:	ba 00 00 00 00       	mov    $0x0,%edx
  80148f:	b8 02 00 00 00       	mov    $0x2,%eax
  801494:	e8 8b ff ff ff       	call   801424 <fsipc>
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <devfile_flush>:
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b1:	b8 06 00 00 00       	mov    $0x6,%eax
  8014b6:	e8 69 ff ff ff       	call   801424 <fsipc>
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <devfile_stat>:
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	53                   	push   %ebx
  8014c1:	83 ec 04             	sub    $0x4,%esp
  8014c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8014cd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d7:	b8 05 00 00 00       	mov    $0x5,%eax
  8014dc:	e8 43 ff ff ff       	call   801424 <fsipc>
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	78 2c                	js     801511 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	68 00 50 80 00       	push   $0x805000
  8014ed:	53                   	push   %ebx
  8014ee:	e8 b5 f3 ff ff       	call   8008a8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014f3:	a1 80 50 80 00       	mov    0x805080,%eax
  8014f8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014fe:	a1 84 50 80 00       	mov    0x805084,%eax
  801503:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801511:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <devfile_write>:
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 0c             	sub    $0xc,%esp
  80151c:	8b 45 10             	mov    0x10(%ebp),%eax
  80151f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801524:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801529:	0f 47 c2             	cmova  %edx,%eax
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80152c:	8b 55 08             	mov    0x8(%ebp),%edx
  80152f:	8b 52 0c             	mov    0xc(%edx),%edx
  801532:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = n;
  801538:	a3 04 50 80 00       	mov    %eax,0x805004
        memmove(fsipcbuf.write.req_buf, buf, n);
  80153d:	50                   	push   %eax
  80153e:	ff 75 0c             	pushl  0xc(%ebp)
  801541:	68 08 50 80 00       	push   $0x805008
  801546:	e8 eb f4 ff ff       	call   800a36 <memmove>
        if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80154b:	ba 00 00 00 00       	mov    $0x0,%edx
  801550:	b8 04 00 00 00       	mov    $0x4,%eax
  801555:	e8 ca fe ff ff       	call   801424 <fsipc>
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <devfile_read>:
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	56                   	push   %esi
  801560:	53                   	push   %ebx
  801561:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8b 40 0c             	mov    0xc(%eax),%eax
  80156a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80156f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801575:	ba 00 00 00 00       	mov    $0x0,%edx
  80157a:	b8 03 00 00 00       	mov    $0x3,%eax
  80157f:	e8 a0 fe ff ff       	call   801424 <fsipc>
  801584:	89 c3                	mov    %eax,%ebx
  801586:	85 c0                	test   %eax,%eax
  801588:	78 1f                	js     8015a9 <devfile_read+0x4d>
	assert(r <= n);
  80158a:	39 f0                	cmp    %esi,%eax
  80158c:	77 24                	ja     8015b2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80158e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801593:	7f 33                	jg     8015c8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	50                   	push   %eax
  801599:	68 00 50 80 00       	push   $0x805000
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	e8 90 f4 ff ff       	call   800a36 <memmove>
	return r;
  8015a6:	83 c4 10             	add    $0x10,%esp
}
  8015a9:	89 d8                	mov    %ebx,%eax
  8015ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ae:	5b                   	pop    %ebx
  8015af:	5e                   	pop    %esi
  8015b0:	5d                   	pop    %ebp
  8015b1:	c3                   	ret    
	assert(r <= n);
  8015b2:	68 9c 23 80 00       	push   $0x80239c
  8015b7:	68 a3 23 80 00       	push   $0x8023a3
  8015bc:	6a 7c                	push   $0x7c
  8015be:	68 b8 23 80 00       	push   $0x8023b8
  8015c3:	e8 1b ec ff ff       	call   8001e3 <_panic>
	assert(r <= PGSIZE);
  8015c8:	68 c3 23 80 00       	push   $0x8023c3
  8015cd:	68 a3 23 80 00       	push   $0x8023a3
  8015d2:	6a 7d                	push   $0x7d
  8015d4:	68 b8 23 80 00       	push   $0x8023b8
  8015d9:	e8 05 ec ff ff       	call   8001e3 <_panic>

008015de <open>:
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	56                   	push   %esi
  8015e2:	53                   	push   %ebx
  8015e3:	83 ec 1c             	sub    $0x1c,%esp
  8015e6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015e9:	56                   	push   %esi
  8015ea:	e8 82 f2 ff ff       	call   800871 <strlen>
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015f7:	7f 6c                	jg     801665 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015f9:	83 ec 0c             	sub    $0xc,%esp
  8015fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ff:	50                   	push   %eax
  801600:	e8 b4 f8 ff ff       	call   800eb9 <fd_alloc>
  801605:	89 c3                	mov    %eax,%ebx
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	85 c0                	test   %eax,%eax
  80160c:	78 3c                	js     80164a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80160e:	83 ec 08             	sub    $0x8,%esp
  801611:	56                   	push   %esi
  801612:	68 00 50 80 00       	push   $0x805000
  801617:	e8 8c f2 ff ff       	call   8008a8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801627:	b8 01 00 00 00       	mov    $0x1,%eax
  80162c:	e8 f3 fd ff ff       	call   801424 <fsipc>
  801631:	89 c3                	mov    %eax,%ebx
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	85 c0                	test   %eax,%eax
  801638:	78 19                	js     801653 <open+0x75>
	return fd2num(fd);
  80163a:	83 ec 0c             	sub    $0xc,%esp
  80163d:	ff 75 f4             	pushl  -0xc(%ebp)
  801640:	e8 4d f8 ff ff       	call   800e92 <fd2num>
  801645:	89 c3                	mov    %eax,%ebx
  801647:	83 c4 10             	add    $0x10,%esp
}
  80164a:	89 d8                	mov    %ebx,%eax
  80164c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164f:	5b                   	pop    %ebx
  801650:	5e                   	pop    %esi
  801651:	5d                   	pop    %ebp
  801652:	c3                   	ret    
		fd_close(fd, 0);
  801653:	83 ec 08             	sub    $0x8,%esp
  801656:	6a 00                	push   $0x0
  801658:	ff 75 f4             	pushl  -0xc(%ebp)
  80165b:	e8 54 f9 ff ff       	call   800fb4 <fd_close>
		return r;
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	eb e5                	jmp    80164a <open+0x6c>
		return -E_BAD_PATH;
  801665:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80166a:	eb de                	jmp    80164a <open+0x6c>

0080166c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801672:	ba 00 00 00 00       	mov    $0x0,%edx
  801677:	b8 08 00 00 00       	mov    $0x8,%eax
  80167c:	e8 a3 fd ff ff       	call   801424 <fsipc>
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801683:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801687:	7e 38                	jle    8016c1 <writebuf+0x3e>
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	53                   	push   %ebx
  80168d:	83 ec 08             	sub    $0x8,%esp
  801690:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801692:	ff 70 04             	pushl  0x4(%eax)
  801695:	8d 40 10             	lea    0x10(%eax),%eax
  801698:	50                   	push   %eax
  801699:	ff 33                	pushl  (%ebx)
  80169b:	e8 a7 fb ff ff       	call   801247 <write>
		if (result > 0)
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	7e 03                	jle    8016aa <writebuf+0x27>
			b->result += result;
  8016a7:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8016aa:	39 43 04             	cmp    %eax,0x4(%ebx)
  8016ad:	74 0d                	je     8016bc <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b6:	0f 4f c2             	cmovg  %edx,%eax
  8016b9:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8016bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    
  8016c1:	f3 c3                	repz ret 

008016c3 <putch>:

static void
putch(int ch, void *thunk)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	53                   	push   %ebx
  8016c7:	83 ec 04             	sub    $0x4,%esp
  8016ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8016cd:	8b 53 04             	mov    0x4(%ebx),%edx
  8016d0:	8d 42 01             	lea    0x1(%edx),%eax
  8016d3:	89 43 04             	mov    %eax,0x4(%ebx)
  8016d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d9:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8016dd:	3d 00 01 00 00       	cmp    $0x100,%eax
  8016e2:	74 06                	je     8016ea <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8016e4:	83 c4 04             	add    $0x4,%esp
  8016e7:	5b                   	pop    %ebx
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    
		writebuf(b);
  8016ea:	89 d8                	mov    %ebx,%eax
  8016ec:	e8 92 ff ff ff       	call   801683 <writebuf>
		b->idx = 0;
  8016f1:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8016f8:	eb ea                	jmp    8016e4 <putch+0x21>

008016fa <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80170c:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801713:	00 00 00 
	b.result = 0;
  801716:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80171d:	00 00 00 
	b.error = 1;
  801720:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801727:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80172a:	ff 75 10             	pushl  0x10(%ebp)
  80172d:	ff 75 0c             	pushl  0xc(%ebp)
  801730:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801736:	50                   	push   %eax
  801737:	68 c3 16 80 00       	push   $0x8016c3
  80173c:	e8 7a ec ff ff       	call   8003bb <vprintfmt>
	if (b.idx > 0)
  801741:	83 c4 10             	add    $0x10,%esp
  801744:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80174b:	7f 11                	jg     80175e <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80174d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801753:	85 c0                	test   %eax,%eax
  801755:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    
		writebuf(&b);
  80175e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801764:	e8 1a ff ff ff       	call   801683 <writebuf>
  801769:	eb e2                	jmp    80174d <vfprintf+0x53>

0080176b <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801771:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801774:	50                   	push   %eax
  801775:	ff 75 0c             	pushl  0xc(%ebp)
  801778:	ff 75 08             	pushl  0x8(%ebp)
  80177b:	e8 7a ff ff ff       	call   8016fa <vfprintf>
	va_end(ap);

	return cnt;
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <printf>:

int
printf(const char *fmt, ...)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801788:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80178b:	50                   	push   %eax
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	6a 01                	push   $0x1
  801791:	e8 64 ff ff ff       	call   8016fa <vfprintf>
	va_end(ap);

	return cnt;
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	56                   	push   %esi
  80179c:	53                   	push   %ebx
  80179d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017a0:	83 ec 0c             	sub    $0xc,%esp
  8017a3:	ff 75 08             	pushl  0x8(%ebp)
  8017a6:	e8 f7 f6 ff ff       	call   800ea2 <fd2data>
  8017ab:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8017ad:	83 c4 08             	add    $0x8,%esp
  8017b0:	68 cf 23 80 00       	push   $0x8023cf
  8017b5:	53                   	push   %ebx
  8017b6:	e8 ed f0 ff ff       	call   8008a8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017bb:	8b 46 04             	mov    0x4(%esi),%eax
  8017be:	2b 06                	sub    (%esi),%eax
  8017c0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8017c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017cd:	00 00 00 
	stat->st_dev = &devpipe;
  8017d0:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  8017d7:	30 80 00 
	return 0;
}
  8017da:	b8 00 00 00 00       	mov    $0x0,%eax
  8017df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e2:	5b                   	pop    %ebx
  8017e3:	5e                   	pop    %esi
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    

008017e6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	53                   	push   %ebx
  8017ea:	83 ec 0c             	sub    $0xc,%esp
  8017ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8017f0:	53                   	push   %ebx
  8017f1:	6a 00                	push   $0x0
  8017f3:	e8 2e f5 ff ff       	call   800d26 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8017f8:	89 1c 24             	mov    %ebx,(%esp)
  8017fb:	e8 a2 f6 ff ff       	call   800ea2 <fd2data>
  801800:	83 c4 08             	add    $0x8,%esp
  801803:	50                   	push   %eax
  801804:	6a 00                	push   $0x0
  801806:	e8 1b f5 ff ff       	call   800d26 <sys_page_unmap>
}
  80180b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <_pipeisclosed>:
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	57                   	push   %edi
  801814:	56                   	push   %esi
  801815:	53                   	push   %ebx
  801816:	83 ec 1c             	sub    $0x1c,%esp
  801819:	89 c7                	mov    %eax,%edi
  80181b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80181d:	a1 08 40 80 00       	mov    0x804008,%eax
  801822:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801825:	83 ec 0c             	sub    $0xc,%esp
  801828:	57                   	push   %edi
  801829:	e8 9b 04 00 00       	call   801cc9 <pageref>
  80182e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801831:	89 34 24             	mov    %esi,(%esp)
  801834:	e8 90 04 00 00       	call   801cc9 <pageref>
		nn = thisenv->env_runs;
  801839:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80183f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	39 cb                	cmp    %ecx,%ebx
  801847:	74 1b                	je     801864 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801849:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80184c:	75 cf                	jne    80181d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80184e:	8b 42 58             	mov    0x58(%edx),%eax
  801851:	6a 01                	push   $0x1
  801853:	50                   	push   %eax
  801854:	53                   	push   %ebx
  801855:	68 d6 23 80 00       	push   $0x8023d6
  80185a:	e8 5f ea ff ff       	call   8002be <cprintf>
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	eb b9                	jmp    80181d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801864:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801867:	0f 94 c0             	sete   %al
  80186a:	0f b6 c0             	movzbl %al,%eax
}
  80186d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801870:	5b                   	pop    %ebx
  801871:	5e                   	pop    %esi
  801872:	5f                   	pop    %edi
  801873:	5d                   	pop    %ebp
  801874:	c3                   	ret    

00801875 <devpipe_write>:
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	57                   	push   %edi
  801879:	56                   	push   %esi
  80187a:	53                   	push   %ebx
  80187b:	83 ec 28             	sub    $0x28,%esp
  80187e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801881:	56                   	push   %esi
  801882:	e8 1b f6 ff ff       	call   800ea2 <fd2data>
  801887:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	bf 00 00 00 00       	mov    $0x0,%edi
  801891:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801894:	74 4f                	je     8018e5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801896:	8b 43 04             	mov    0x4(%ebx),%eax
  801899:	8b 0b                	mov    (%ebx),%ecx
  80189b:	8d 51 20             	lea    0x20(%ecx),%edx
  80189e:	39 d0                	cmp    %edx,%eax
  8018a0:	72 14                	jb     8018b6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8018a2:	89 da                	mov    %ebx,%edx
  8018a4:	89 f0                	mov    %esi,%eax
  8018a6:	e8 65 ff ff ff       	call   801810 <_pipeisclosed>
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	75 3a                	jne    8018e9 <devpipe_write+0x74>
			sys_yield();
  8018af:	e8 ce f3 ff ff       	call   800c82 <sys_yield>
  8018b4:	eb e0                	jmp    801896 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018b9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8018bd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8018c0:	89 c2                	mov    %eax,%edx
  8018c2:	c1 fa 1f             	sar    $0x1f,%edx
  8018c5:	89 d1                	mov    %edx,%ecx
  8018c7:	c1 e9 1b             	shr    $0x1b,%ecx
  8018ca:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8018cd:	83 e2 1f             	and    $0x1f,%edx
  8018d0:	29 ca                	sub    %ecx,%edx
  8018d2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8018d6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8018da:	83 c0 01             	add    $0x1,%eax
  8018dd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018e0:	83 c7 01             	add    $0x1,%edi
  8018e3:	eb ac                	jmp    801891 <devpipe_write+0x1c>
	return i;
  8018e5:	89 f8                	mov    %edi,%eax
  8018e7:	eb 05                	jmp    8018ee <devpipe_write+0x79>
				return 0;
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018f1:	5b                   	pop    %ebx
  8018f2:	5e                   	pop    %esi
  8018f3:	5f                   	pop    %edi
  8018f4:	5d                   	pop    %ebp
  8018f5:	c3                   	ret    

008018f6 <devpipe_read>:
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	57                   	push   %edi
  8018fa:	56                   	push   %esi
  8018fb:	53                   	push   %ebx
  8018fc:	83 ec 18             	sub    $0x18,%esp
  8018ff:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801902:	57                   	push   %edi
  801903:	e8 9a f5 ff ff       	call   800ea2 <fd2data>
  801908:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	be 00 00 00 00       	mov    $0x0,%esi
  801912:	3b 75 10             	cmp    0x10(%ebp),%esi
  801915:	74 47                	je     80195e <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801917:	8b 03                	mov    (%ebx),%eax
  801919:	3b 43 04             	cmp    0x4(%ebx),%eax
  80191c:	75 22                	jne    801940 <devpipe_read+0x4a>
			if (i > 0)
  80191e:	85 f6                	test   %esi,%esi
  801920:	75 14                	jne    801936 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801922:	89 da                	mov    %ebx,%edx
  801924:	89 f8                	mov    %edi,%eax
  801926:	e8 e5 fe ff ff       	call   801810 <_pipeisclosed>
  80192b:	85 c0                	test   %eax,%eax
  80192d:	75 33                	jne    801962 <devpipe_read+0x6c>
			sys_yield();
  80192f:	e8 4e f3 ff ff       	call   800c82 <sys_yield>
  801934:	eb e1                	jmp    801917 <devpipe_read+0x21>
				return i;
  801936:	89 f0                	mov    %esi,%eax
}
  801938:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193b:	5b                   	pop    %ebx
  80193c:	5e                   	pop    %esi
  80193d:	5f                   	pop    %edi
  80193e:	5d                   	pop    %ebp
  80193f:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801940:	99                   	cltd   
  801941:	c1 ea 1b             	shr    $0x1b,%edx
  801944:	01 d0                	add    %edx,%eax
  801946:	83 e0 1f             	and    $0x1f,%eax
  801949:	29 d0                	sub    %edx,%eax
  80194b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801950:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801953:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801956:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801959:	83 c6 01             	add    $0x1,%esi
  80195c:	eb b4                	jmp    801912 <devpipe_read+0x1c>
	return i;
  80195e:	89 f0                	mov    %esi,%eax
  801960:	eb d6                	jmp    801938 <devpipe_read+0x42>
				return 0;
  801962:	b8 00 00 00 00       	mov    $0x0,%eax
  801967:	eb cf                	jmp    801938 <devpipe_read+0x42>

00801969 <pipe>:
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	56                   	push   %esi
  80196d:	53                   	push   %ebx
  80196e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801971:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801974:	50                   	push   %eax
  801975:	e8 3f f5 ff ff       	call   800eb9 <fd_alloc>
  80197a:	89 c3                	mov    %eax,%ebx
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	85 c0                	test   %eax,%eax
  801981:	78 5b                	js     8019de <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801983:	83 ec 04             	sub    $0x4,%esp
  801986:	68 07 04 00 00       	push   $0x407
  80198b:	ff 75 f4             	pushl  -0xc(%ebp)
  80198e:	6a 00                	push   $0x0
  801990:	e8 0c f3 ff ff       	call   800ca1 <sys_page_alloc>
  801995:	89 c3                	mov    %eax,%ebx
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	85 c0                	test   %eax,%eax
  80199c:	78 40                	js     8019de <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80199e:	83 ec 0c             	sub    $0xc,%esp
  8019a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a4:	50                   	push   %eax
  8019a5:	e8 0f f5 ff ff       	call   800eb9 <fd_alloc>
  8019aa:	89 c3                	mov    %eax,%ebx
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	78 1b                	js     8019ce <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019b3:	83 ec 04             	sub    $0x4,%esp
  8019b6:	68 07 04 00 00       	push   $0x407
  8019bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8019be:	6a 00                	push   $0x0
  8019c0:	e8 dc f2 ff ff       	call   800ca1 <sys_page_alloc>
  8019c5:	89 c3                	mov    %eax,%ebx
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	79 19                	jns    8019e7 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8019ce:	83 ec 08             	sub    $0x8,%esp
  8019d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d4:	6a 00                	push   $0x0
  8019d6:	e8 4b f3 ff ff       	call   800d26 <sys_page_unmap>
  8019db:	83 c4 10             	add    $0x10,%esp
}
  8019de:	89 d8                	mov    %ebx,%eax
  8019e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e3:	5b                   	pop    %ebx
  8019e4:	5e                   	pop    %esi
  8019e5:	5d                   	pop    %ebp
  8019e6:	c3                   	ret    
	va = fd2data(fd0);
  8019e7:	83 ec 0c             	sub    $0xc,%esp
  8019ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ed:	e8 b0 f4 ff ff       	call   800ea2 <fd2data>
  8019f2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019f4:	83 c4 0c             	add    $0xc,%esp
  8019f7:	68 07 04 00 00       	push   $0x407
  8019fc:	50                   	push   %eax
  8019fd:	6a 00                	push   $0x0
  8019ff:	e8 9d f2 ff ff       	call   800ca1 <sys_page_alloc>
  801a04:	89 c3                	mov    %eax,%ebx
  801a06:	83 c4 10             	add    $0x10,%esp
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	0f 88 8c 00 00 00    	js     801a9d <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a11:	83 ec 0c             	sub    $0xc,%esp
  801a14:	ff 75 f0             	pushl  -0x10(%ebp)
  801a17:	e8 86 f4 ff ff       	call   800ea2 <fd2data>
  801a1c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a23:	50                   	push   %eax
  801a24:	6a 00                	push   $0x0
  801a26:	56                   	push   %esi
  801a27:	6a 00                	push   $0x0
  801a29:	e8 b6 f2 ff ff       	call   800ce4 <sys_page_map>
  801a2e:	89 c3                	mov    %eax,%ebx
  801a30:	83 c4 20             	add    $0x20,%esp
  801a33:	85 c0                	test   %eax,%eax
  801a35:	78 58                	js     801a8f <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3a:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801a40:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a45:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4f:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801a55:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a61:	83 ec 0c             	sub    $0xc,%esp
  801a64:	ff 75 f4             	pushl  -0xc(%ebp)
  801a67:	e8 26 f4 ff ff       	call   800e92 <fd2num>
  801a6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a6f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a71:	83 c4 04             	add    $0x4,%esp
  801a74:	ff 75 f0             	pushl  -0x10(%ebp)
  801a77:	e8 16 f4 ff ff       	call   800e92 <fd2num>
  801a7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a7f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a8a:	e9 4f ff ff ff       	jmp    8019de <pipe+0x75>
	sys_page_unmap(0, va);
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	56                   	push   %esi
  801a93:	6a 00                	push   $0x0
  801a95:	e8 8c f2 ff ff       	call   800d26 <sys_page_unmap>
  801a9a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801a9d:	83 ec 08             	sub    $0x8,%esp
  801aa0:	ff 75 f0             	pushl  -0x10(%ebp)
  801aa3:	6a 00                	push   $0x0
  801aa5:	e8 7c f2 ff ff       	call   800d26 <sys_page_unmap>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	e9 1c ff ff ff       	jmp    8019ce <pipe+0x65>

00801ab2 <pipeisclosed>:
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ab8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abb:	50                   	push   %eax
  801abc:	ff 75 08             	pushl  0x8(%ebp)
  801abf:	e8 44 f4 ff ff       	call   800f08 <fd_lookup>
  801ac4:	83 c4 10             	add    $0x10,%esp
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	78 18                	js     801ae3 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801acb:	83 ec 0c             	sub    $0xc,%esp
  801ace:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad1:	e8 cc f3 ff ff       	call   800ea2 <fd2data>
	return _pipeisclosed(fd, p);
  801ad6:	89 c2                	mov    %eax,%edx
  801ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adb:	e8 30 fd ff ff       	call   801810 <_pipeisclosed>
  801ae0:	83 c4 10             	add    $0x10,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  801aed:	5d                   	pop    %ebp
  801aee:	c3                   	ret    

00801aef <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801af5:	68 ee 23 80 00       	push   $0x8023ee
  801afa:	ff 75 0c             	pushl  0xc(%ebp)
  801afd:	e8 a6 ed ff ff       	call   8008a8 <strcpy>
	return 0;
}
  801b02:	b8 00 00 00 00       	mov    $0x0,%eax
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <devcons_write>:
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	57                   	push   %edi
  801b0d:	56                   	push   %esi
  801b0e:	53                   	push   %ebx
  801b0f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b15:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b1a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b20:	eb 2f                	jmp    801b51 <devcons_write+0x48>
		m = n - tot;
  801b22:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b25:	29 f3                	sub    %esi,%ebx
  801b27:	83 fb 7f             	cmp    $0x7f,%ebx
  801b2a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801b2f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801b32:	83 ec 04             	sub    $0x4,%esp
  801b35:	53                   	push   %ebx
  801b36:	89 f0                	mov    %esi,%eax
  801b38:	03 45 0c             	add    0xc(%ebp),%eax
  801b3b:	50                   	push   %eax
  801b3c:	57                   	push   %edi
  801b3d:	e8 f4 ee ff ff       	call   800a36 <memmove>
		sys_cputs(buf, m);
  801b42:	83 c4 08             	add    $0x8,%esp
  801b45:	53                   	push   %ebx
  801b46:	57                   	push   %edi
  801b47:	e8 99 f0 ff ff       	call   800be5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b4c:	01 de                	add    %ebx,%esi
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b54:	72 cc                	jb     801b22 <devcons_write+0x19>
}
  801b56:	89 f0                	mov    %esi,%eax
  801b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b5b:	5b                   	pop    %ebx
  801b5c:	5e                   	pop    %esi
  801b5d:	5f                   	pop    %edi
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    

00801b60 <devcons_read>:
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 08             	sub    $0x8,%esp
  801b66:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801b6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b6f:	75 07                	jne    801b78 <devcons_read+0x18>
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    
		sys_yield();
  801b73:	e8 0a f1 ff ff       	call   800c82 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801b78:	e8 86 f0 ff ff       	call   800c03 <sys_cgetc>
  801b7d:	85 c0                	test   %eax,%eax
  801b7f:	74 f2                	je     801b73 <devcons_read+0x13>
	if (c < 0)
  801b81:	85 c0                	test   %eax,%eax
  801b83:	78 ec                	js     801b71 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801b85:	83 f8 04             	cmp    $0x4,%eax
  801b88:	74 0c                	je     801b96 <devcons_read+0x36>
	*(char*)vbuf = c;
  801b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8d:	88 02                	mov    %al,(%edx)
	return 1;
  801b8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b94:	eb db                	jmp    801b71 <devcons_read+0x11>
		return 0;
  801b96:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9b:	eb d4                	jmp    801b71 <devcons_read+0x11>

00801b9d <cputchar>:
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ba9:	6a 01                	push   $0x1
  801bab:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bae:	50                   	push   %eax
  801baf:	e8 31 f0 ff ff       	call   800be5 <sys_cputs>
}
  801bb4:	83 c4 10             	add    $0x10,%esp
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <getchar>:
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801bbf:	6a 01                	push   $0x1
  801bc1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bc4:	50                   	push   %eax
  801bc5:	6a 00                	push   $0x0
  801bc7:	e8 ad f5 ff ff       	call   801179 <read>
	if (r < 0)
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	78 08                	js     801bdb <getchar+0x22>
	if (r < 1)
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	7e 06                	jle    801bdd <getchar+0x24>
	return c;
  801bd7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    
		return -E_EOF;
  801bdd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801be2:	eb f7                	jmp    801bdb <getchar+0x22>

00801be4 <iscons>:
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bed:	50                   	push   %eax
  801bee:	ff 75 08             	pushl  0x8(%ebp)
  801bf1:	e8 12 f3 ff ff       	call   800f08 <fd_lookup>
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	78 11                	js     801c0e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c00:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801c06:	39 10                	cmp    %edx,(%eax)
  801c08:	0f 94 c0             	sete   %al
  801c0b:	0f b6 c0             	movzbl %al,%eax
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <opencons>:
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c19:	50                   	push   %eax
  801c1a:	e8 9a f2 ff ff       	call   800eb9 <fd_alloc>
  801c1f:	83 c4 10             	add    $0x10,%esp
  801c22:	85 c0                	test   %eax,%eax
  801c24:	78 3a                	js     801c60 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c26:	83 ec 04             	sub    $0x4,%esp
  801c29:	68 07 04 00 00       	push   $0x407
  801c2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c31:	6a 00                	push   $0x0
  801c33:	e8 69 f0 ff ff       	call   800ca1 <sys_page_alloc>
  801c38:	83 c4 10             	add    $0x10,%esp
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	78 21                	js     801c60 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c42:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801c48:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c54:	83 ec 0c             	sub    $0xc,%esp
  801c57:	50                   	push   %eax
  801c58:	e8 35 f2 ff ff       	call   800e92 <fd2num>
  801c5d:	83 c4 10             	add    $0x10,%esp
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_recv not implemented");
  801c68:	68 fa 23 80 00       	push   $0x8023fa
  801c6d:	6a 1a                	push   $0x1a
  801c6f:	68 13 24 80 00       	push   $0x802413
  801c74:	e8 6a e5 ff ff       	call   8001e3 <_panic>

00801c79 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	panic("ipc_send not implemented");
  801c7f:	68 1d 24 80 00       	push   $0x80241d
  801c84:	6a 2a                	push   $0x2a
  801c86:	68 13 24 80 00       	push   $0x802413
  801c8b:	e8 53 e5 ff ff       	call   8001e3 <_panic>

00801c90 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c96:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c9b:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c9e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ca4:	8b 52 50             	mov    0x50(%edx),%edx
  801ca7:	39 ca                	cmp    %ecx,%edx
  801ca9:	74 11                	je     801cbc <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801cab:	83 c0 01             	add    $0x1,%eax
  801cae:	3d 00 04 00 00       	cmp    $0x400,%eax
  801cb3:	75 e6                	jne    801c9b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cba:	eb 0b                	jmp    801cc7 <ipc_find_env+0x37>
			return envs[i].env_id;
  801cbc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801cbf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801cc4:	8b 40 48             	mov    0x48(%eax),%eax
}
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    

00801cc9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ccf:	89 d0                	mov    %edx,%eax
  801cd1:	c1 e8 16             	shr    $0x16,%eax
  801cd4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801cdb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ce0:	f6 c1 01             	test   $0x1,%cl
  801ce3:	74 1d                	je     801d02 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ce5:	c1 ea 0c             	shr    $0xc,%edx
  801ce8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801cef:	f6 c2 01             	test   $0x1,%dl
  801cf2:	74 0e                	je     801d02 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801cf4:	c1 ea 0c             	shr    $0xc,%edx
  801cf7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801cfe:	ef 
  801cff:	0f b7 c0             	movzwl %ax,%eax
}
  801d02:	5d                   	pop    %ebp
  801d03:	c3                   	ret    
  801d04:	66 90                	xchg   %ax,%ax
  801d06:	66 90                	xchg   %ax,%ax
  801d08:	66 90                	xchg   %ax,%ax
  801d0a:	66 90                	xchg   %ax,%ax
  801d0c:	66 90                	xchg   %ax,%ax
  801d0e:	66 90                	xchg   %ax,%ax

00801d10 <__udivdi3>:
  801d10:	55                   	push   %ebp
  801d11:	57                   	push   %edi
  801d12:	56                   	push   %esi
  801d13:	53                   	push   %ebx
  801d14:	83 ec 1c             	sub    $0x1c,%esp
  801d17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801d1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801d1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801d27:	85 d2                	test   %edx,%edx
  801d29:	75 35                	jne    801d60 <__udivdi3+0x50>
  801d2b:	39 f3                	cmp    %esi,%ebx
  801d2d:	0f 87 bd 00 00 00    	ja     801df0 <__udivdi3+0xe0>
  801d33:	85 db                	test   %ebx,%ebx
  801d35:	89 d9                	mov    %ebx,%ecx
  801d37:	75 0b                	jne    801d44 <__udivdi3+0x34>
  801d39:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3e:	31 d2                	xor    %edx,%edx
  801d40:	f7 f3                	div    %ebx
  801d42:	89 c1                	mov    %eax,%ecx
  801d44:	31 d2                	xor    %edx,%edx
  801d46:	89 f0                	mov    %esi,%eax
  801d48:	f7 f1                	div    %ecx
  801d4a:	89 c6                	mov    %eax,%esi
  801d4c:	89 e8                	mov    %ebp,%eax
  801d4e:	89 f7                	mov    %esi,%edi
  801d50:	f7 f1                	div    %ecx
  801d52:	89 fa                	mov    %edi,%edx
  801d54:	83 c4 1c             	add    $0x1c,%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5f                   	pop    %edi
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    
  801d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801d60:	39 f2                	cmp    %esi,%edx
  801d62:	77 7c                	ja     801de0 <__udivdi3+0xd0>
  801d64:	0f bd fa             	bsr    %edx,%edi
  801d67:	83 f7 1f             	xor    $0x1f,%edi
  801d6a:	0f 84 98 00 00 00    	je     801e08 <__udivdi3+0xf8>
  801d70:	89 f9                	mov    %edi,%ecx
  801d72:	b8 20 00 00 00       	mov    $0x20,%eax
  801d77:	29 f8                	sub    %edi,%eax
  801d79:	d3 e2                	shl    %cl,%edx
  801d7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d7f:	89 c1                	mov    %eax,%ecx
  801d81:	89 da                	mov    %ebx,%edx
  801d83:	d3 ea                	shr    %cl,%edx
  801d85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801d89:	09 d1                	or     %edx,%ecx
  801d8b:	89 f2                	mov    %esi,%edx
  801d8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d91:	89 f9                	mov    %edi,%ecx
  801d93:	d3 e3                	shl    %cl,%ebx
  801d95:	89 c1                	mov    %eax,%ecx
  801d97:	d3 ea                	shr    %cl,%edx
  801d99:	89 f9                	mov    %edi,%ecx
  801d9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d9f:	d3 e6                	shl    %cl,%esi
  801da1:	89 eb                	mov    %ebp,%ebx
  801da3:	89 c1                	mov    %eax,%ecx
  801da5:	d3 eb                	shr    %cl,%ebx
  801da7:	09 de                	or     %ebx,%esi
  801da9:	89 f0                	mov    %esi,%eax
  801dab:	f7 74 24 08          	divl   0x8(%esp)
  801daf:	89 d6                	mov    %edx,%esi
  801db1:	89 c3                	mov    %eax,%ebx
  801db3:	f7 64 24 0c          	mull   0xc(%esp)
  801db7:	39 d6                	cmp    %edx,%esi
  801db9:	72 0c                	jb     801dc7 <__udivdi3+0xb7>
  801dbb:	89 f9                	mov    %edi,%ecx
  801dbd:	d3 e5                	shl    %cl,%ebp
  801dbf:	39 c5                	cmp    %eax,%ebp
  801dc1:	73 5d                	jae    801e20 <__udivdi3+0x110>
  801dc3:	39 d6                	cmp    %edx,%esi
  801dc5:	75 59                	jne    801e20 <__udivdi3+0x110>
  801dc7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dca:	31 ff                	xor    %edi,%edi
  801dcc:	89 fa                	mov    %edi,%edx
  801dce:	83 c4 1c             	add    $0x1c,%esp
  801dd1:	5b                   	pop    %ebx
  801dd2:	5e                   	pop    %esi
  801dd3:	5f                   	pop    %edi
  801dd4:	5d                   	pop    %ebp
  801dd5:	c3                   	ret    
  801dd6:	8d 76 00             	lea    0x0(%esi),%esi
  801dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  801de0:	31 ff                	xor    %edi,%edi
  801de2:	31 c0                	xor    %eax,%eax
  801de4:	89 fa                	mov    %edi,%edx
  801de6:	83 c4 1c             	add    $0x1c,%esp
  801de9:	5b                   	pop    %ebx
  801dea:	5e                   	pop    %esi
  801deb:	5f                   	pop    %edi
  801dec:	5d                   	pop    %ebp
  801ded:	c3                   	ret    
  801dee:	66 90                	xchg   %ax,%ax
  801df0:	31 ff                	xor    %edi,%edi
  801df2:	89 e8                	mov    %ebp,%eax
  801df4:	89 f2                	mov    %esi,%edx
  801df6:	f7 f3                	div    %ebx
  801df8:	89 fa                	mov    %edi,%edx
  801dfa:	83 c4 1c             	add    $0x1c,%esp
  801dfd:	5b                   	pop    %ebx
  801dfe:	5e                   	pop    %esi
  801dff:	5f                   	pop    %edi
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    
  801e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801e08:	39 f2                	cmp    %esi,%edx
  801e0a:	72 06                	jb     801e12 <__udivdi3+0x102>
  801e0c:	31 c0                	xor    %eax,%eax
  801e0e:	39 eb                	cmp    %ebp,%ebx
  801e10:	77 d2                	ja     801de4 <__udivdi3+0xd4>
  801e12:	b8 01 00 00 00       	mov    $0x1,%eax
  801e17:	eb cb                	jmp    801de4 <__udivdi3+0xd4>
  801e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801e20:	89 d8                	mov    %ebx,%eax
  801e22:	31 ff                	xor    %edi,%edi
  801e24:	eb be                	jmp    801de4 <__udivdi3+0xd4>
  801e26:	66 90                	xchg   %ax,%ax
  801e28:	66 90                	xchg   %ax,%ax
  801e2a:	66 90                	xchg   %ax,%ax
  801e2c:	66 90                	xchg   %ax,%ax
  801e2e:	66 90                	xchg   %ax,%ax

00801e30 <__umoddi3>:
  801e30:	55                   	push   %ebp
  801e31:	57                   	push   %edi
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	83 ec 1c             	sub    $0x1c,%esp
  801e37:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  801e3b:	8b 74 24 30          	mov    0x30(%esp),%esi
  801e3f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  801e43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e47:	85 ed                	test   %ebp,%ebp
  801e49:	89 f0                	mov    %esi,%eax
  801e4b:	89 da                	mov    %ebx,%edx
  801e4d:	75 19                	jne    801e68 <__umoddi3+0x38>
  801e4f:	39 df                	cmp    %ebx,%edi
  801e51:	0f 86 b1 00 00 00    	jbe    801f08 <__umoddi3+0xd8>
  801e57:	f7 f7                	div    %edi
  801e59:	89 d0                	mov    %edx,%eax
  801e5b:	31 d2                	xor    %edx,%edx
  801e5d:	83 c4 1c             	add    $0x1c,%esp
  801e60:	5b                   	pop    %ebx
  801e61:	5e                   	pop    %esi
  801e62:	5f                   	pop    %edi
  801e63:	5d                   	pop    %ebp
  801e64:	c3                   	ret    
  801e65:	8d 76 00             	lea    0x0(%esi),%esi
  801e68:	39 dd                	cmp    %ebx,%ebp
  801e6a:	77 f1                	ja     801e5d <__umoddi3+0x2d>
  801e6c:	0f bd cd             	bsr    %ebp,%ecx
  801e6f:	83 f1 1f             	xor    $0x1f,%ecx
  801e72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e76:	0f 84 b4 00 00 00    	je     801f30 <__umoddi3+0x100>
  801e7c:	b8 20 00 00 00       	mov    $0x20,%eax
  801e81:	89 c2                	mov    %eax,%edx
  801e83:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e87:	29 c2                	sub    %eax,%edx
  801e89:	89 c1                	mov    %eax,%ecx
  801e8b:	89 f8                	mov    %edi,%eax
  801e8d:	d3 e5                	shl    %cl,%ebp
  801e8f:	89 d1                	mov    %edx,%ecx
  801e91:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e95:	d3 e8                	shr    %cl,%eax
  801e97:	09 c5                	or     %eax,%ebp
  801e99:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e9d:	89 c1                	mov    %eax,%ecx
  801e9f:	d3 e7                	shl    %cl,%edi
  801ea1:	89 d1                	mov    %edx,%ecx
  801ea3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801ea7:	89 df                	mov    %ebx,%edi
  801ea9:	d3 ef                	shr    %cl,%edi
  801eab:	89 c1                	mov    %eax,%ecx
  801ead:	89 f0                	mov    %esi,%eax
  801eaf:	d3 e3                	shl    %cl,%ebx
  801eb1:	89 d1                	mov    %edx,%ecx
  801eb3:	89 fa                	mov    %edi,%edx
  801eb5:	d3 e8                	shr    %cl,%eax
  801eb7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  801ebc:	09 d8                	or     %ebx,%eax
  801ebe:	f7 f5                	div    %ebp
  801ec0:	d3 e6                	shl    %cl,%esi
  801ec2:	89 d1                	mov    %edx,%ecx
  801ec4:	f7 64 24 08          	mull   0x8(%esp)
  801ec8:	39 d1                	cmp    %edx,%ecx
  801eca:	89 c3                	mov    %eax,%ebx
  801ecc:	89 d7                	mov    %edx,%edi
  801ece:	72 06                	jb     801ed6 <__umoddi3+0xa6>
  801ed0:	75 0e                	jne    801ee0 <__umoddi3+0xb0>
  801ed2:	39 c6                	cmp    %eax,%esi
  801ed4:	73 0a                	jae    801ee0 <__umoddi3+0xb0>
  801ed6:	2b 44 24 08          	sub    0x8(%esp),%eax
  801eda:	19 ea                	sbb    %ebp,%edx
  801edc:	89 d7                	mov    %edx,%edi
  801ede:	89 c3                	mov    %eax,%ebx
  801ee0:	89 ca                	mov    %ecx,%edx
  801ee2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  801ee7:	29 de                	sub    %ebx,%esi
  801ee9:	19 fa                	sbb    %edi,%edx
  801eeb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801eef:	89 d0                	mov    %edx,%eax
  801ef1:	d3 e0                	shl    %cl,%eax
  801ef3:	89 d9                	mov    %ebx,%ecx
  801ef5:	d3 ee                	shr    %cl,%esi
  801ef7:	d3 ea                	shr    %cl,%edx
  801ef9:	09 f0                	or     %esi,%eax
  801efb:	83 c4 1c             	add    $0x1c,%esp
  801efe:	5b                   	pop    %ebx
  801eff:	5e                   	pop    %esi
  801f00:	5f                   	pop    %edi
  801f01:	5d                   	pop    %ebp
  801f02:	c3                   	ret    
  801f03:	90                   	nop
  801f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f08:	85 ff                	test   %edi,%edi
  801f0a:	89 f9                	mov    %edi,%ecx
  801f0c:	75 0b                	jne    801f19 <__umoddi3+0xe9>
  801f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f13:	31 d2                	xor    %edx,%edx
  801f15:	f7 f7                	div    %edi
  801f17:	89 c1                	mov    %eax,%ecx
  801f19:	89 d8                	mov    %ebx,%eax
  801f1b:	31 d2                	xor    %edx,%edx
  801f1d:	f7 f1                	div    %ecx
  801f1f:	89 f0                	mov    %esi,%eax
  801f21:	f7 f1                	div    %ecx
  801f23:	e9 31 ff ff ff       	jmp    801e59 <__umoddi3+0x29>
  801f28:	90                   	nop
  801f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f30:	39 dd                	cmp    %ebx,%ebp
  801f32:	72 08                	jb     801f3c <__umoddi3+0x10c>
  801f34:	39 f7                	cmp    %esi,%edi
  801f36:	0f 87 21 ff ff ff    	ja     801e5d <__umoddi3+0x2d>
  801f3c:	89 da                	mov    %ebx,%edx
  801f3e:	89 f0                	mov    %esi,%eax
  801f40:	29 f8                	sub    %edi,%eax
  801f42:	19 ea                	sbb    %ebp,%edx
  801f44:	e9 14 ff ff ff       	jmp    801e5d <__umoddi3+0x2d>
